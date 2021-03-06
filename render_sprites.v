module render_sprites(
	input clock,	//put clock 50 into this
	input draw,		//put rate divider into this
	input reset,	//put reset into this
	input[7:0] cannonX,
	input[7:0] cannonY,
	input[7:0] alienX,
	input[7:0] alienY,
	input[14:0] alive,	//does nothing right now
	output reg[7:0] xOut,	//send to VGA x
	output reg[7:0] yOut,	//send to VGA y
	output [2:0] colourOut,
	output reg plot, 			//send to VGA writeEn
	output reg done);						
	
	wire [2:0] yAdd;
	wire [4:0] update;		//update row, x, and y
	reg [4:0] rowBlock;		//this and yAdd define row to be taken
	wire ld, enable, plotOut, stop, clock112Out;
	reg [7:0] xPos;
	reg [6:0] yPos;
	wire [7:0] x;
	wire [6:0] y;
	wire [7:0] xOutW;
	wire [6:0] yOutW;
	reg [12:0] row;
	reg fsmStart;
	wire st;
	reg alienAlive;
	
	localparam row0 = 13'b0001000001000,
				  row1 = 13'b0000100010000,
				  row2 = 13'b0001111111000,
				  row3 = 13'b0011011101100,
				  row4 = 13'b0111111111110,
				  row5 = 13'b0101111111010,
				  row6 = 13'b0101000001010,
				  row7 = 13'b0000110110000,
				  row8 = 13'b0000001100000,
				  row9 = 13'b0000011110000,
				  row10 = 13'b0000111111000,
				  row11 = 13'b0001101101100,
				  row12 = 13'b0001111111100,
				  row13 = 13'b0000010010000,
				  row14 = 13'b0000101101000,
				  row15 = 13'b0001010010100,
				  row16 = 13'b0000011110000,
				  row17 = 13'b0011111111110,
				  row18 = 13'b0111111111111,
				  row19 = 13'b0111001100111,
				  row20 = 13'b0111111111111,
				  row21 = 13'b0000110011000,
				  row22 = 13'b0001101101100,
				  row23 = 13'b0110000000011,
				  row24 = 13'b0000001000000,
				  row25 = 13'b0000011100000,
				  row26 = 13'b0000011100000,
				  row27 = 13'b0111111111110,
				  row28 = 13'b1111111111111,
				  row29 = 13'b1111111111111,
				  row30 = 13'b1111111111111,
				  row31 = 13'b1111111111111;
	
	counter112 count112(clock, draw, reset, clock112Out);
	counter16 count16(clock, clock112Out, reset, draw, update);
	
	//Based on state of counter 16, update x, y, and row
	always@(*) begin
		case(update)
			5'd0: begin
			xPos = alienX;
			yPos = alienY;
			rowBlock = 5'b0;
			fsmStart = 1'b1;
			alienAlive = alive[0];
			done = 1'b0;
			end
			5'd1: begin 
			xPos = alienX + 5'd18;
			yPos = alienY;
			rowBlock = 5'b0;
			fsmStart = 1'b1;
			alienAlive = alive[1];
			done = 1'b0;
			end
			5'd2: begin 
			xPos = alienX + 7'd36;
			yPos = alienY;
			rowBlock = 5'b0;
			fsmStart = 1'b1;
			alienAlive = alive[2];
			done = 1'b0;
			end
			5'd3: begin 
			xPos = alienX + 7'd54;
			yPos = alienY;
			rowBlock = 5'b0;
			fsmStart = 1'b1;
			alienAlive = alive[3];
			done = 1'b0;
			end
			5'd4: begin 
			xPos = alienX + 7'd72;
			yPos = alienY;
			rowBlock = 5'b0;
			fsmStart = 1'b1;
			alienAlive = alive[4];
			done = 1'b0;
			end
			5'd5: begin
			xPos = alienX;
			yPos = alienY + 4'd10;
			rowBlock = 5'd8;
			fsmStart = 1'b1;
			alienAlive = alive[5];
			done = 1'b0;
			end
			5'd6: begin
			xPos = alienX + 7'd18;
			yPos = alienY + 4'd10;
			rowBlock = 5'd8;
			fsmStart = 1'b1;
			alienAlive = alive[6];
			done = 1'b0;
			end
			5'd7: begin
			xPos = alienX + 7'd36;
			yPos = alienY + 4'd10;
			rowBlock = 5'd8;
			fsmStart = 1'b1;
			alienAlive = alive[7];
			done = 1'b0;
			end
			5'd8: begin
			xPos = alienX + 7'd54;
			yPos = alienY + 4'd10;
			rowBlock = 5'd8;
			fsmStart = 1'b1;
			alienAlive = alive[8];
			done = 1'b0;
			end
			5'd9: begin
			xPos = alienX + 7'd72;
			yPos = alienY + 4'd10;
			rowBlock = 5'd8;
			fsmStart = 1'b1;
			alienAlive = alive[9];
			done = 1'b0;
			end
			5'd10: begin
			xPos = alienX;
			yPos = alienY + 5'd20;
			rowBlock = 5'd16;
			fsmStart = 1'b1;
			alienAlive = alive[10];
			done = 1'b0;
			end
			5'd11: begin
			xPos = alienX + 7'd18;
			yPos = alienY + 5'd20;
			rowBlock = 5'd16;
			fsmStart = 1'b1;
			alienAlive = alive[11];
			done = 1'b0;
			end
			5'd12: begin
			xPos = alienX + 7'd36;
			yPos = alienY + 5'd20;
			rowBlock = 5'd16;
			fsmStart = 1'b1;
			alienAlive = alive[12];
			done = 1'b0;
			end
			5'd13: begin
			xPos = alienX + 7'd54;
			yPos = alienY + 5'd20;
			rowBlock = 5'd16;
			fsmStart = 1'b1;
			alienAlive = alive[13];
			done = 1'b0;
			end
			5'd14: begin
			xPos = alienX + 7'd72;
			yPos = alienY + 5'd20;
			rowBlock = 5'd16;
			fsmStart = 1'b1;
			alienAlive = alive[14];
			done = 1'b0;
			end
			5'd15: begin
			xPos = cannonX;
			yPos = cannonY;
			rowBlock = 5'd24;
			fsmStart = 1'b1;
			alienAlive = 1'b1;
			done = 1'b0;
			end
			5'd16: begin
			xPos = cannonX;
			yPos = cannonY;
			rowBlock = 5'd24;
			fsmStart = 1'b0;
			alienAlive = 1'b1;
			done = 1'b1;
			end
			5'd20: begin
			xPos = cannonX;
			yPos = cannonY;
			rowBlock = 5'd24;
			fsmStart = 1'b0;
			alienAlive = 1'b1;
			done = 1'b0;
			end
			default: begin
			xPos = cannonX;
			yPos = cannonY;
			rowBlock = 5'd0;
			fsmStart = 1'b0;
			alienAlive = 1'b1;
			done = 1'b0;
			end
		endcase
	end
	
	always@(*) begin
		case(yAdd+rowBlock)
		5'd0: row = row0;
		5'd1: row = row1;
		5'd2: row = row2;
		5'd3: row = row3;
		5'd4: row = row4;
		5'd5: row = row5;
		5'd6: row = row6;
		5'd7: row = row7;
		5'd8: row = row8;
		5'd9: row = row9;
		5'd10: row = row10;
		5'd11: row = row11;
		5'd12: row = row12;
		5'd13: row = row13;
		5'd14: row = row14;
		5'd15: row = row15;
		5'd16: row = row16;
		5'd17: row = row17;
		5'd18: row = row18;
		5'd19: row = row19;
		5'd20: row = row20;
		5'd21: row = row21;
		5'd22: row = row22;
		5'd23: row = row23;
		5'd24: row = row24;
		5'd25: row = row25;
		5'd26: row = row26;
		5'd27: row = row27;
		5'd28: row = row28;
		5'd29: row = row29;
		5'd30: row = row30;
		5'd31: row = row31;
		default: row = row0;
		endcase
	end
	
	
	sprite_control spriteControl1(clock, reset, fsmStart, st, ld, enable);
	sprite_data spriteData1(clock, reset, ld, enable, x, (y + yAdd), row, xOutW, yOutW, plotOut, stop);
	counter c1(clock, reset, st, 3'd7, yAdd);
	flip flipStop(st, reset, clock, stop);

	assign x = xPos;
	assign y = yPos;
	assign colourOut = 3'b10;
	always@(*) begin
		xOut <= xOutW;
		yOut <= yOutW;
		plot <= (plotOut && fsmStart && alienAlive);
	end

endmodule


module flip (output pcEn, input reset, input clock, input ready);
reg state;
		reg count;

		always@(negedge clock) begin
			if(!reset) begin
				state <= 1'b0;
			end
			else begin
				if(count) begin
					state <= 1'b1;
				end
				else begin
					state <= 1'b0;
				end
			end
		end
		
		always@(posedge clock) begin
			if(!reset) begin
				count <= 1'b0;
			end
			else if(ready) begin
				count <= 1'b1;
			end
			else begin
				count <= 1'b0;
			end
		end
		
assign pcEn = (state != ready) && !(ready == 0 && state == 1);

endmodule


//sends a pulse out every 112 clock cycles
module counter112(
	input clock,
	input resetD,
	input reset, 
	output reg q);
	reg [6:0] count;
	
	always@(posedge clock) begin
		if(!reset) begin
			count <= 7'd0;
			q <= 1'b0;
		end
		else if(resetD) begin
			count <= 7'd0;
			q <= 1'b0;
		end
		else begin
			if(count > 7'd0) begin
				count <= count - 1'b1;
				q = 1'b0;
			end
			else begin
				count <= 7'd111;
				q <= 1'b1;
			end
		end
	end
	
endmodule

//takes in a pulse to start counting up from 0 to 15, stopping once it gets there
//outputs a number from 0-15
module counter16(
	input clock,
	input clock112,
	input reset,
	input start,
	output reg[4:0] q);
	
	reg[4:0] count;
	
	always@(posedge clock) begin
		if(!reset) begin
			count <= 5'd21;
			q <= 5'd21;
		end
		else if(count == 5'd20) begin
			count <= 5'd21;
			q <= 5'd20;
		end
		else if(start) begin
				count <= 5'd0;
				q <= count[4:0];
			end
		else if(clock112) begin
			if(count < 5'd16) begin
				count <= count + 1'b1;
				q <= count[4:0];
				end
			else if(count == 5'd16) begin
				count <= 5'd20;
				q <= 5'd16;
			end
		end
	end
endmodule

module sprite_control(
	input clock, 
	input reset, 
	input draw,			//shift bits out to be drawn
	input stop,			//load bits into shifter
	output reg ld, 
	output reg enable);
	
	reg[4:0] current_state, next_state;
	
	localparam LOAD = 1'd0,
				  SHIFT = 1'd1;
				  
	always@(*)
	begin: state_table
			case(current_state)
				LOAD: next_state = draw ? SHIFT : LOAD;
				SHIFT: next_state = stop ? LOAD : SHIFT;
				default: next_state = LOAD;
			endcase
	end
	
	always@(*)
	begin
		ld = 1'b0;
		enable = 1'b0;
		case(current_state)
			LOAD:begin
				ld = 1'b1;
				end
			SHIFT:begin
				enable = 1'b1;
				end
			endcase
	end
	
	always@(posedge clock)
	begin: state_FFs
			if(!reset)
				current_state <= LOAD;
			else
				current_state <= next_state;
	end
endmodule

module sprite_data(
	input clock,
	input reset,
	input ld,						//load state on
	input shift,					//shift state on
	input [7:0]xIn,
	input [6:0]yIn,
	input [12:0]row,
	output reg [7:0] xOut,
	output reg [6:0] yOut,
	output reg enableOut, 		//turn on the plot of VGA
	output reg stop);				//send to control to move to next state
	
	reg s;
	reg [3:0]count;
	wire shiftOut;
	
	always@(posedge clock)
	begin
		if(!reset) begin
		xOut <= 8'd0;
		yOut <= 7'd0;
		count <= 4'd0;
		stop <= 1'b0;
		enableOut <= 1'b0;
		end
		else begin
			if(ld) begin							//load in pos and reset count
				xOut <= xIn;
				yOut <= yIn;
				enableOut <= shiftOut;
				count <= 1'b0;
			end
			if(shift) begin
				if(count < 4'd11) begin			//plot equals shifter bit
					enableOut <= shiftOut;
					stop <= 1'b0;
					end
				else begin
					stop <= 1'b1;						//go to next state
					enableOut <= shiftOut;
					end
				count <= count + 1'b1;				//increase x coord
				xOut <= xOut + 1'b1;
			end
		end
	end
	
	shifter alien_shifter(clock, shift, ld, row, shiftOut);
	
endmodule
	
module shifter(
	input clock,
	input draw,					//tells when to start drawing
	input load,					//loads in a value
	input[12:0] value,
	output reg q);				//bit to be drawn

	reg[12:0] n;
	
	always@(negedge clock) begin
		if(load)begin
			n <= value;
			end
		if(draw) begin
			n <= n >> 1'b1;
		end
	end
	
	always@(*) begin
		q <= n[0];
	end
endmodule

module counter(
	input clock,
	input reset,
	input enable,
	input [2:0]in,
	output reg[2:0] q);
	
	reg[2:0] count;
	
	always@(posedge clock) begin
		if(!reset)begin
			count <= 3'd0;
			end
		else begin
			if (enable) begin
				if(count < in) begin
					count <= count + 1'b1;
					end
				else begin
					count <= 3'b0;
					end
				end
			end
	end
	
	always@(*) begin
		q <= count;
	end
endmodule
