<%@page  errorPage="_Error.jsp"%>
<%@page import="java.util.*"%>
<%@page import="model.FixedCard" %>
<%@page import="dao.FixedCardDao"%>
<%@page import="dao.FixedDao"%>
<%@page import="dao.SeatDao"%>
<%@page import="model.Seat"%>
<%@page import="model.Page" %>
<%@page import="model.Fixed" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path=request.getContextPath();//获取项目名称
 %>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=path %>/Style/MsgStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=path %>/Script/jquery-1.10.1.js"></script>
<title>Insert title here</title>
<script>
	$(function()
	{
		$(".btnGo").click(function()
		{
			if($("[name=htype]").val()=="turnPage")
			{

				location.href="<%=path %>/FixedServlet?type=getfixedlist&page="+($(".txtPage").val()==""?1:$(".txtPage").val())+"&condition="+$("[name=hcondition]").val()+"&search_value="+$("[name=hvalue]").val();
			}		
		});
	});
</script>
</head>
<body>

<fieldset>
	<legend>添加入场信息</legend>
	<form action="<%=path %>/FixedServlet?type=add" method="post" class="Form">
		<table style=" margin:10px 0;"> 
	            <tbody>
			<tr><td>IC卡号：</td><td>
				<select name="card_id">
					<%
					
					     FixedCard fixedcard=new FixedCard();//这里是在固定车主卡号中选择  一个   因为固定车主要进场了
					     //这里获得不在场内的固定车主信息   即在  voutfixed中进行查找    state =0的固定车主
					     fixedcard.setSeat_state(0);
						 FixedCardDao fixedcardDao=new FixedCardDao();
						 Page pages=null;
						 int pageSize=fixedcardDao.getOutFixedCardListTotal(fixedcard);
						 try{
						 List<FixedCard> list=fixedcardDao.getOutFixedCardList(fixedcard, new Page(1,pageSize));
						 fixedcardDao.closeCon();
					     for(int i=0;i<list.size();i++)
					     {
					      fixedcard=(FixedCard)list.get(i);
					      out.write("<option value='"+fixedcard.getCard_id()+"'>"+fixedcard.getCard_id()+"("+fixedcard.getSeat_id()+")</option>");
					     }
					}catch(Exception e){
           				e.printStackTrace();
					}
					
					 %>
				</select>
				
				<input type="submit" value="确定" id="btnSure"/>
			</td></tr>
	            </tbody>      
	        </table>
	</form>
</fieldset>

<div class="div_container">
<fieldset>
	<legend>出场信息管理</legend>
	<div class="searchDiv">
		<form action="<%=path %>/FixedServlet" method="get">
			<span>查询条件：</span>
			<select name="condition">
				<option value='card_id'>IC卡号</option>
				<option value='name'>车主姓名</option>
				<option value='car_num'>车牌号码</option>
				<option value='entry_date'>进场日期</option>
			</select>
			 	
			<span>查询值：</span>
			<input type="hidden" name="type" value="stillin" />
			<input type="text" name="search_value" />
			<input type="submit" value="查询 "/>
		</form>
	</div>
	<!-- searchDiv End -->

	<table>
		<thead>
			<tr>
				<th>IC卡号</th>
				<th>车位编号</th>
				<th>车主姓名</th>
				<th>车牌号码</th>
				<th>入场日期</th>
				<th>是否出场</th>

				<th>操作</th>
			</tr>
		</thead>

		<tbody>
			<% 
			//这个表其实就是 固定车主进出场信息表   这个用来保存固定车主进出场的信息
	            response.setCharacterEncoding("UTF-8");//设置输出数据的编码格式
				request.setCharacterEncoding("UTF-8");//设置获取数据的编码格式
				try{
				List<Fixed> fixedlist=(List<Fixed>)request.getAttribute("list");//获取servlet端转发的list数据列表
				out.write("<input type='hidden' name='hcondition' value='"+(request.getAttribute("condition")!=null?request.getAttribute("condition").toString():"")+"' />");
				out.write("<input type='hidden' name='hvalue' value='"+(request.getAttribute("Search_value")!=null?request.getAttribute("Search_value").toString():"")+"' />");
                		if(fixedlist!=null) //循环数据列表，生成表格行
                		{
                			for(int i=0;i<fixedlist.size();i++)
	                		{
	               				Fixed fixed;
	               				fixed=(Fixed)fixedlist.get(i);
	               				String result=fixed.getOut_date().toString().equals("1111-11-11")?"未出场":"已出场";
	               				out.print("<tr><td>"+fixed.getCard_id()+"</td><td>"+fixed.getSeat_id()+"</td><td>"+fixed.getName()+"</td><td>"+fixed.getCar_num()+"</td><td>"+fixed.getEntry_date()+" "+fixed.getEntry_time()+"</td><td>"+result+"</td><td><a href='"+path+"/FixedServlet?type=out&card_id="+fixed.getCard_id()+"&entry_date="+fixed.getEntry_date()+"&entry_time="+fixed.getEntry_time()+"' class='a_del' onclick='return confirm(\"是否确认出场？\")'>设置出场</a></td></tr>");
	                		}
                		}
				}catch(Exception e){
					e.printStackTrace();
				}
	                %>
		</tbody>

		<tfoot>
            		<tr><td colspan="7">
            				<div>
						<%
						int totalPage=0;
						if(request.getAttribute("totalPage")!=null){
							totalPage=Integer.parseInt(request.getAttribute("totalPage").toString());
							out.write("<input type='hidden' name='htype' value='turnPage' />");
						}

            					 %>
            					<span>共<strong><%=totalPage %></strong>页  </span>
            					<span>跳转至</span><input type="text" class="txtPage" /><input type="button" value="转" class="btnGo" />
            				</div>
            			</td>
			</tr>
            </tfoot>

	</table>
	</fieldset>
</div>
</body>
</html>
