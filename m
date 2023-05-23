Return-Path: <netdev+bounces-4576-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71B1370D45D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:53:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D7931C20CDD
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 381171D2CF;
	Tue, 23 May 2023 06:53:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F891C756
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:53:02 +0000 (UTC)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CF1118;
	Mon, 22 May 2023 23:52:59 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1ae79528d4dso46303095ad.2;
        Mon, 22 May 2023 23:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684824779; x=1687416779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pHVJOrZTLhWxfI/dA1jc/7StnNnfOvKPoL5oGZLJdis=;
        b=mCssCrHbRZzxaj8bWmxvVy63hBj2eLFh5dSTr4sfFOMScdQYPJ4mpxJUP9Hu5mxx12
         FCjR7liO0CSm2do/4NiubfpRliyKtLT3v15PzXqRmGeze0VRti85inMdTVpxwxeN2OpI
         p94QNGuigm3z62c59zixUlpXCzmvl3INRJaT0RDvyXF1BTBABuN5GuKNkXQgxOiwp6zS
         GgETo9PQvH4CB72r6TW/tWbf6RUnC1zeqxDHMFaEtXHjGV7NX8xQCT1DJBnVFzqSxp74
         pwbGL03u+GADOja3nTV/vjd5hcaKLVFCOnux/KDPH2a5EpAyXbY9MgEuRl3Xwy4oUZeT
         xj+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684824779; x=1687416779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pHVJOrZTLhWxfI/dA1jc/7StnNnfOvKPoL5oGZLJdis=;
        b=L2zhi7I3nDRW4ORPQDw7FVvQ7eB+KUkuhN7QboZLz6CO+xjqs5z0jhDdoNTCT1Xsjm
         HZ2k3ZxurAbSRKQRwNSpeG3aYvddWpnkEEPi0oRyyO2aJFBxRVEYOIlXsEXTPTk9mr46
         tBWNtKICUTXu61hi8lb8ksNlmXVfWHIIXh7LY2x1xKZSEN7L+dvlxNAKAFlz279l1Wyj
         7ns158LV5RDO4/5Yy1RSpGrXtHjOyCiJPjjgKzvZSiu8+yJwbA0cmf7lgQZCw7GaodYZ
         i5lfu6y+8gm8yt5acxIL08gVNdE1eyS1lCf+hlQVJ71bwSjs04+DyMyYxW5rGgcMmyHu
         9S9g==
X-Gm-Message-State: AC+VfDyjaRy0GwqXHdDnTWyj58RmCC2zDMHl6jCNHSiN//gxnz06eb+6
	JZyjuF5o9QJ0c5SypNYbsLUU7LeVnZ4=
X-Google-Smtp-Source: ACHHUZ56VO7pRIv3NwujIPlTt9j7JaggLiXDEl86vjoqZ8eleL2NRPo30ZftRRxYForZv7Uaf0/DWw==
X-Received: by 2002:a17:902:d04a:b0:1ac:5b6b:df4c with SMTP id l10-20020a170902d04a00b001ac5b6bdf4cmr10768105pll.69.1684824779002;
        Mon, 22 May 2023 23:52:59 -0700 (PDT)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id d10-20020a170902ceca00b001aafa2e212esm5963920plg.52.2023.05.22.23.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 23:52:58 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
	linux-can@vger.kernel.org,
	Thomas.Kopp@microchip.com
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
	netdev@vger.kernel.org,
	marex@denx.de,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v2 3/3] can: length: refactor frame lengths definition to add size in bits
Date: Tue, 23 May 2023 15:52:18 +0900
Message-Id: <20230523065218.51227-4-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230523065218.51227-1-mailhol.vincent@wanadoo.fr>
References: <20230507155506.3179711-1-mailhol.vincent@wanadoo.fr>
 <20230523065218.51227-1-mailhol.vincent@wanadoo.fr>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Introduce a method to calculate the exact size in bits of a CAN(-FD)
frame with or without dynamic bitsuffing.

These are all the possible combinations taken into account:

  - Classical CAN or CAN-FD
  - Standard or Extended frame format
  - CAN-FD CRC17 or CRC21
  - Include or not intermission

Instead of doing several macro definitions, declare the
can_frame_bits() static inline function. To this extend, do a full
refactoring of the length definitions.

If given integer constant expressions as argument, can_frame_bits()
folds into a compile time constant expression, giving no penalty over
the use of macros.

Also add the can_frame_bytes(). This function replaces the existing
macro:

  - CAN_FRAME_OVERHEAD_SFF: can_frame_bytes(false, false, 0)
  - CAN_FRAME_OVERHEAD_EFF: can_frame_bytes(false, true, 0)
  - CANFD_FRAME_OVERHEAD_SFF: can_frame_bytes(true, false, 0)
  - CANFD_FRAME_OVERHEAD_EFF: can_frame_bytes(true, true, 0)

The different frame lengths (including intermission) are as follow:

   Frame type				bits	bytes
  ----------------------------------------------------------
   Classic CAN SFF no-bitstuffing	111	14
   Classic CAN EFF no-bitstuffing	131	17
   Classic CAN SFF bitstuffing		135	17
   Classic CAN EFF bitstuffing		160	20
   CAN-FD SFF no-bitstuffing		579	73
   CAN-FD EFF no-bitstuffing		598	75
   CAN-FD SFF bitstuffing		712	89
   CAN-FD EFF bitstuffing		736	92

The macro CAN_FRAME_LEN_MAX and CANFD_FRAME_LEN_MAX are kept to be
used in const struct declarations (folding of can_frame_bytes() occurs
too late in the compilation to be used in struct declarations).

In addition to the above:

 - Use ISO 11898-1:2015 definitions for the name of the CAN frame
   fields.
 - Include linux/bits.h for use of BITS_PER_BYTE.
 - Include linux/math.h for use of mult_frac() and
   DIV_ROUND_UP(). N.B: the use of DIV_ROUND_UP() is not new to this
   patch, but the include was previously omitted.
 - Add copyright 2023 for myself.

[1] commit 85d99c3e2a13 ("can: length: can_skb_get_frame_len(): introduce
    function to get data length of frame in data link layer")
Link: https://git.kernel.org/torvalds/c/85d99c3e2a13

[2] RE: [PATCH] can: mcp251xfd: Increase poll timeout
Link: https://lore.kernel.org/linux-can/BL3PR11MB64846C83ACD04E9330B0FE66FB729@BL3PR11MB6484.namprd11.prod.outlook.com/

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
In case you ask, here is the proof that can_frame_bits() folds into
a compile time constant expression.

This file:

  #include <linux/can/length.h>

  unsigned int canfd_max_len_bitsuffing(void)
  {
	return can_frame_bytes(true, true, true, CANFD_MAX_DLEN);
  }

Produces this assembly code:

  0000000000000010 <canfd_max_len_bitsuffing>:
    10:	f3 0f 1e fa          	endbr64
    14:	b8 5c 00 00 00       	mov    $0x5c,%eax
    19:	e9 00 00 00 00       	jmpq   1e <canfd_max_len_bitsuffing+0xe>

where 0x5c corresponds to the expected value of 92 bytes.
---
 drivers/net/can/dev/length.c |  15 +-
 include/linux/can/length.h   | 326 +++++++++++++++++++++++++----------
 2 files changed, 238 insertions(+), 103 deletions(-)

diff --git a/drivers/net/can/dev/length.c b/drivers/net/can/dev/length.c
index b48140b1102e..b7f4d76dd444 100644
--- a/drivers/net/can/dev/length.c
+++ b/drivers/net/can/dev/length.c
@@ -78,18 +78,7 @@ unsigned int can_skb_get_frame_len(const struct sk_buff *skb)
 	else
 		len = cf->len;
 
-	if (can_is_canfd_skb(skb)) {
-		if (cf->can_id & CAN_EFF_FLAG)
-			len += CANFD_FRAME_OVERHEAD_EFF;
-		else
-			len += CANFD_FRAME_OVERHEAD_SFF;
-	} else {
-		if (cf->can_id & CAN_EFF_FLAG)
-			len += CAN_FRAME_OVERHEAD_EFF;
-		else
-			len += CAN_FRAME_OVERHEAD_SFF;
-	}
-
-	return len;
+	return can_frame_bytes(can_is_canfd_skb(skb), cf->can_id & CAN_EFF_FLAG,
+			       false, len);
 }
 EXPORT_SYMBOL_GPL(can_skb_get_frame_len);
diff --git a/include/linux/can/length.h b/include/linux/can/length.h
index 521fdbce2d69..7518117ee5fc 100644
--- a/include/linux/can/length.h
+++ b/include/linux/can/length.h
@@ -1,132 +1,278 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (C) 2020 Oliver Hartkopp <socketcan@hartkopp.net>
  * Copyright (C) 2020 Marc Kleine-Budde <kernel@pengutronix.de>
- * Copyright (C) 2020 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
+ * Copyright (C) 2020, 2023 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
  */
 
 #ifndef _CAN_LENGTH_H
 #define _CAN_LENGTH_H
 
+#include <linux/bits.h>
 #include <linux/can.h>
 #include <linux/can/netlink.h>
+#include <linux/math.h>
 
 /*
- * Size of a Classical CAN Standard Frame
+ * Size of a Classical CAN Standard Frame header in bits
+ *
+ * Name of Field				Bits
+ * ---------------------------------------------------------
+ * Start Of Frame (SOF)				1
+ * Arbitration field:
+ *	base ID					11
+ *	Remote Transmission Request (RTR)	1
+ * Control field:
+ *	IDentifier Extension bit (IDE)		1
+ *	FD Format indicatior (FDF)		1
+ *	Data Length Code (DLC)			4
+ *
+ * including all fields preceding the data field, ignoring bitstuffing
+ */
+#define CAN_FRAME_HEADER_SFF_BITS 19
+
+/*
+ * Size of a Classical CAN Extended Frame header in bits
+ *
+ * Name of Field				Bits
+ * ---------------------------------------------------------
+ * Start Of Frame (SOF)				1
+ * Arbitration field:
+ *	base ID					11
+ *	Substitute Remote Request (SRR)		1
+ *	IDentifier Extension bit (IDE)		1
+ *	ID extension				18
+ *	Remote Transmission Request (RTR)	1
+ * Control field:
+ *	FD Format indicatior (FDF)		1
+ *	Reserved bit (r0)			1
+ *	Data length code (DLC)			4
+ *
+ * including all fields preceding the data field, ignoring bitstuffing
+ */
+#define CAN_FRAME_HEADER_EFF_BITS 39
+
+/*
+ * Size of a CAN-FD Standard Frame in bits
+ *
+ * Name of Field				Bits
+ * ---------------------------------------------------------
+ * Start Of Frame (SOF)				1
+ * Arbitration field:
+ *	base ID					11
+ *	Remote Request Substitution (RRS)	1
+ * Control field:
+ *	IDentifier Extension bit (IDE)		1
+ *	FD Format indicator (FDF)		1
+ *	Reserved bit (res)			1
+ *	Bit Rate Switch (BRS)			1
+ *	Error Status Indicator (ESI)		1
+ *	Data length code (DLC)			4
+ *
+ * including all fields preceding the data field, ignoring bitstuffing
+ */
+#define CANFD_FRAME_HEADER_SFF_BITS 22
+
+/*
+ * Size of a CAN-FD Extended Frame in bits
+ *
+ * Name of Field				Bits
+ * ---------------------------------------------------------
+ * Start Of Frame (SOF)				1
+ * Arbitration field:
+ *	base ID					11
+ *	Substitute Remote Request (SRR)		1
+ *	IDentifier Extension bit (IDE)		1
+ *	ID extension				18
+ *	Remote Request Substitution (RRS)	1
+ * Control field:
+ *	FD Format indicator (FDF)		1
+ *	Reserved bit (res)			1
+ *	Bit Rate Switch (BRS)			1
+ *	Error Status Indicator (ESI)		1
+ *	Data length code (DLC)			4
+ *
+ * including all fields preceding the data field, ignoring bitstuffing
+ */
+#define CANFD_FRAME_HEADER_EFF_BITS 41
+
+/*
+ * Size of a CAN CRC Field in bits
+ *
+ * Name of Field			Bits
+ * ---------------------------------------------------------
+ * CRC sequence (CRC15)			15
+ * CRC Delimiter			1
+ *
+ * ignoring bitstuffing
+ */
+#define CAN_FRAME_CRC_FIELD_BITS 16
+
+/*
+ * Size of a CAN-FD CRC17 Field in bits (length: 0..16)
+ *
+ * Name of Field			Bits
+ * ---------------------------------------------------------
+ * Stuff Count				4
+ * CRC Sequence (CRC17)			17
+ * CRC Delimiter			1
+ * Fixed stuff bits			6
+ */
+#define CANFD_FRAME_CRC17_FIELD_BITS 28
+
+/*
+ * Size of a CAN-FD CRC21 Field in bits (length: 20..64)
+ *
+ * Name of Field			Bits
+ * ---------------------------------------------------------
+ * Stuff Count				4
+ * CRC sequence (CRC21)			21
+ * CRC Delimiter			1
+ * Fixed stuff bits			7
+ */
+#define CANFD_FRAME_CRC21_FIELD_BITS 33
+
+/*
+ * Size of a CAN(-FD) Frame footer in bits
  *
  * Name of Field			Bits
  * ---------------------------------------------------------
- * Start-of-frame			1
- * Identifier				11
- * Remote transmission request (RTR)	1
- * Identifier extension bit (IDE)	1
- * Reserved bit (r0)			1
- * Data length code (DLC)		4
- * Data field				0...64
- * CRC					15
- * CRC delimiter			1
  * ACK slot				1
  * ACK delimiter			1
- * End-of-frame (EOF)			7
- * Inter frame spacing			3
+ * End Of Frame (EOF)			7
  *
- * rounded up and ignoring bitstuffing
+ * including all fields following the CRC field
  */
-#define CAN_FRAME_OVERHEAD_SFF DIV_ROUND_UP(47, 8)
+#define CAN_FRAME_FOOTER_BITS 9
 
 /*
- * Size of a Classical CAN Extended Frame
- *
- * Name of Field			Bits
- * ---------------------------------------------------------
- * Start-of-frame			1
- * Identifier A				11
- * Substitute remote request (SRR)	1
- * Identifier extension bit (IDE)	1
- * Identifier B				18
- * Remote transmission request (RTR)	1
- * Reserved bits (r1, r0)		2
- * Data length code (DLC)		4
- * Data field				0...64
- * CRC					15
- * CRC delimiter			1
- * ACK slot				1
- * ACK delimiter			1
- * End-of-frame (EOF)			7
- * Inter frame spacing			3
- *
- * rounded up and ignoring bitstuffing
+ * First part of the Inter Frame Space
+ * (a.k.a. IMF - intermission field)
  */
-#define CAN_FRAME_OVERHEAD_EFF DIV_ROUND_UP(67, 8)
+#define CAN_INTERMISSION_BITS 3
 
 /*
- * Size of a CAN-FD Standard Frame
+ * CAN bit stuffing overhead multiplication factor
  *
- * Name of Field			Bits
- * ---------------------------------------------------------
- * Start-of-frame			1
- * Identifier				11
- * Remote Request Substitution (RRS)	1
- * Identifier extension bit (IDE)	1
- * Flexible data rate format (FDF)	1
- * Reserved bit (r0)			1
- * Bit Rate Switch (BRS)		1
- * Error Status Indicator (ESI)		1
- * Data length code (DLC)		4
- * Data field				0...512
- * Stuff Bit Count (SBC)		4
- * CRC					0...16: 17 20...64:21
- * CRC delimiter (CD)			1
- * Fixed Stuff bits (FSB)		0...16: 6 20...64:7
- * ACK slot (AS)			1
- * ACK delimiter (AD)			1
- * End-of-frame (EOF)			7
- * Inter frame spacing			3
+ * The worst bit stuffing case is a sequence in which dominant and
+ * recessive bits alternate every four bits:
  *
- * assuming CRC21, rounded up and ignoring dynamic bitstuffing
+ *   Destuffed: 1 1111  0000  1111  0000  1111
+ *   Stuffed:   1 1111o 0000i 1111o 0000i 1111o
+ *
+ * Nomenclature:
+ *
+ *  - "0": dominant bit
+ *  - "o": dominant stuff bit
+ *  - "1": recessive bit
+ *  - "i": recessive stuff bit
+ *
+ * Ignoring the first bit, one stuff bit is added every four bits
+ * giving us an overhead of 1/4 = 0.25.
  */
-#define CANFD_FRAME_OVERHEAD_SFF DIV_ROUND_UP(67, 8)
+#define can_bit_stuffing_overhead(stream_len) mult_frac(stream_len, 1, 4)
+
+/**
+ * can_frame_bits() - Calculate the number of bits in on the wire in a
+ *	CAN frame
+ * @is_eff: true: Extended Frame; false: Standard Frame.
+ * @bitstuffing: if true, calculate the bitsuffing worst case, if
+ *	false, calculated the bitsuffing best case (no dynamic
+ *	bitsuffing). Fixed stuff bits always get included.
+ * @intermission: if and only if true, include the inter frame space
+ *	assuming no bus idle (i.e. only the intermission gets added).
+ * @data_len: length of the data field in bytes. Correspond to
+ *	can(fd)_frame->len. Should be zero for remote frames. No
+ *	sanitization is done on @data_len.
+ *
+ * Return: the numbers of bits on the wire of a CAN frame.
+ */
+static inline
+unsigned int can_frame_bits(bool is_fd, bool is_eff,
+			    bool bitstuffing, bool intermission,
+			    unsigned int data_len)
+{
+	unsigned int bits;
+
+	if (is_fd) {
+		if (is_eff)
+			bits = CANFD_FRAME_HEADER_EFF_BITS;
+		else
+			bits = CANFD_FRAME_HEADER_SFF_BITS;
+	} else {
+		if (is_eff)
+			bits = CAN_FRAME_HEADER_EFF_BITS;
+		else
+			bits = CAN_FRAME_HEADER_SFF_BITS;
+	}
+
+	bits += data_len * BITS_PER_BYTE;
+
+	if (!is_fd) {
+		bits += CAN_FRAME_CRC_FIELD_BITS;
+		/*
+		 * In Classical CAN, bit stuffing applies to all field
+		 * from SOF to CRC delimiter
+		 */
+		if (bitstuffing)
+			bits += can_bit_stuffing_overhead(bits);
+	} else {
+		/*
+		 * In CAN-FD, the fields preceding the CRC field have
+		 * dynamic bit stuffing; but the CRC field has fixed
+		 * bitstuffing
+		 */
+		if (bitstuffing)
+			bits += can_bit_stuffing_overhead(bits - 1);
+		if (data_len <= 16)
+			bits += CANFD_FRAME_CRC17_FIELD_BITS;
+		else
+			bits += CANFD_FRAME_CRC21_FIELD_BITS;
+	}
+
+	bits += CAN_FRAME_FOOTER_BITS;
+
+	if (intermission)
+		bits += CAN_INTERMISSION_BITS;
+
+	return bits;
+}
 
 /*
- * Size of a CAN-FD Extended Frame
- *
- * Name of Field			Bits
- * ---------------------------------------------------------
- * Start-of-frame			1
- * Identifier A				11
- * Substitute remote request (SRR)	1
- * Identifier extension bit (IDE)	1
- * Identifier B				18
- * Remote Request Substitution (RRS)	1
- * Flexible data rate format (FDF)	1
- * Reserved bit (r0)			1
- * Bit Rate Switch (BRS)		1
- * Error Status Indicator (ESI)		1
- * Data length code (DLC)		4
- * Data field				0...512
- * Stuff Bit Count (SBC)		4
- * CRC					0...16: 17 20...64:21
- * CRC delimiter (CD)			1
- * Fixed Stuff bits (FSB)		0...16: 6 20...64:7
- * ACK slot (AS)			1
- * ACK delimiter (AD)			1
- * End-of-frame (EOF)			7
- * Inter frame spacing			3
- *
- * assuming CRC21, rounded up and ignoring dynamic bitstuffing
+ * Number of bytes in a CAN frame
+ * (rounded up, including intermission)
  */
-#define CANFD_FRAME_OVERHEAD_EFF DIV_ROUND_UP(86, 8)
+static inline
+unsigned int can_frame_bytes(bool is_fd, bool is_eff, bool bitstuffing,
+			     unsigned int data_len)
+{
+	return DIV_ROUND_UP(can_frame_bits(is_fd, is_eff, bitstuffing, true,
+					   data_len),
+			    BITS_PER_BYTE);
+}
 
 /*
  * Maximum size of a Classical CAN frame
- * (rounded up and ignoring bitstuffing)
+ * (rounded up, ignoring bitstuffing but including intermission)
  */
-#define CAN_FRAME_LEN_MAX (CAN_FRAME_OVERHEAD_EFF + CAN_MAX_DLEN)
+#define CAN_FRAME_LEN_MAX				\
+	DIV_ROUND_UP(CAN_FRAME_HEADER_EFF_BITS +	\
+		     CAN_MAX_DLEN * BITS_PER_BYTE +	\
+		     CAN_FRAME_CRC_FIELD_BITS +		\
+		     CAN_FRAME_FOOTER_BITS +		\
+		     CAN_INTERMISSION_BITS,		\
+		     BITS_PER_BYTE)
 
 /*
  * Maximum size of a CAN-FD frame
  * (rounded up and ignoring bitstuffing)
  */
-#define CANFD_FRAME_LEN_MAX (CANFD_FRAME_OVERHEAD_EFF + CANFD_MAX_DLEN)
+#define CANFD_FRAME_LEN_MAX				\
+	DIV_ROUND_UP(CANFD_FRAME_HEADER_EFF_BITS +	\
+		     CANFD_MAX_DLEN * BITS_PER_BYTE +	\
+		     CANFD_FRAME_CRC21_FIELD_BITS	\
+		     CAN_FRAME_FOOTER_BITS +		\
+		     CAN_INTERMISSION_BITS,		\
+		     BITS_PER_BYTE)
 
 /*
  * can_cc_dlc2len(value) - convert a given data length code (dlc) of a
-- 
2.25.1


