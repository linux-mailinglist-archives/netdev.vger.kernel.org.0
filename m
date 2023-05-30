Return-Path: <netdev+bounces-6445-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02CCC7164C5
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:48:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABC082811A2
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CDC819516;
	Tue, 30 May 2023 14:47:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFBE1F164
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:47:48 +0000 (UTC)
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2979DF7;
	Tue, 30 May 2023 07:47:44 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-64d2c865e4eso3418951b3a.0;
        Tue, 30 May 2023 07:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685458063; x=1688050063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r9Vs5xR8nydXbwbFsmEP2aZ3ezlg/aDoPCpyXtJ3KIM=;
        b=AX83e/k3/uhHFrCO6w6wKFI3XUs3CVPwnoNw1fJ8aVjVd4DAPyH/sdCl6gu5WSVmzc
         9b8uCMejW1MDMKQr7ZQ0A+TKhvlBEeAEJJd2UuApH/+jXaGNRjWwi48MpPNpzmI1RwF0
         kVLDMZnJptKyOQv+O4qbd6qRlVfkB3A/rq0dDgW9K7IylqrwvNk/ARJw0htEs+BJZmSv
         n3iNF31mnRv6WatIgIzpgznCKwwlKt7IDnRk6Z7PEJgFZlwNJp5oht8ivTgd10FXBZOc
         66FtoBKxc/V/vw62sYOuXGWTLx3F+FxwB5yPSxuObKSO47xsfkHKyxyJpT1cHN23lTbY
         dhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685458063; x=1688050063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r9Vs5xR8nydXbwbFsmEP2aZ3ezlg/aDoPCpyXtJ3KIM=;
        b=DrhH7QgS37yKxZiQnPgU8W5CVRwa6ezllK//7vDUhhHPGtvzTh3oV1gEOThoEgcH2j
         kBjfGaER3IeL3TPCV5wULuhgFRmiMghLdZSqdX9mqOfZ5b+aa4emc4rtO6pVJ4PXoAP4
         4hRe3D77AMT9Ygnd7JYk2YO3m6LF48YXlui4Os/wXIl+XQHqCcf+RHv+r5BJOMqdayno
         CwdUoskthp2Wo0WYBiPqJbJ/veUVngTR2MKmKU+FTrhm60CGBxcBBjKMX+RSJgtSlyli
         f27FDbwkPqT231I4cg+f8IusyYYHBl+tzgK//TGG0mnOWnFhPttJCwitXroYyaC6erDa
         Pqxg==
X-Gm-Message-State: AC+VfDxiquYDuK6ww7vBxLXhcCdjeQhbzeIKFVclA5BAzAg+/UQPCiy3
	mjXnBMKkdd8uIhAgxB3LowmJxYvSao8=
X-Google-Smtp-Source: ACHHUZ4MJTLCjQLM9/PfrfcltRoqujDbj2ac4w5r4R4BKzGyJuye1kzKpE1dBsagK52ZYj9PKuAmHQ==
X-Received: by 2002:a05:6a00:148b:b0:64c:f4f9:de87 with SMTP id v11-20020a056a00148b00b0064cf4f9de87mr3097455pfu.18.1685458063296;
        Tue, 30 May 2023 07:47:43 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id e3-20020aa78c43000000b0063a04905379sm1703193pfd.137.2023.05.30.07.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 07:47:43 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
	linux-can@vger.kernel.org,
	Thomas.Kopp@microchip.com
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
	netdev@vger.kernel.org,
	marex@denx.de,
	Simon Horman <simon.horman@corigine.com>,
	linux-kernel@vger.kernel.org,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 3/3] can: length: refactor frame lengths definition to add size in bits
Date: Tue, 30 May 2023 23:46:37 +0900
Message-Id: <20230530144637.4746-4-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230530144637.4746-1-mailhol.vincent@wanadoo.fr>
References: <20230507155506.3179711-1-mailhol.vincent@wanadoo.fr>
 <20230530144637.4746-1-mailhol.vincent@wanadoo.fr>
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

Instead of doing several individual macro definitions, declare the
can_frame_bits() function-like macro. To this extent, do a full
refactoring of the length definitions.

In addition add the can_frame_bytes(). This function-like macro
replaces the existing macro:

  - CAN_FRAME_OVERHEAD_SFF: can_frame_bytes(false, false, 0)
  - CAN_FRAME_OVERHEAD_EFF: can_frame_bytes(false, true, 0)
  - CANFD_FRAME_OVERHEAD_SFF: can_frame_bytes(true, false, 0)
  - CANFD_FRAME_OVERHEAD_EFF: can_frame_bytes(true, true, 0)

The different maximum frame lengths (maximum data length, including
intermission) are as follow:

   Frame type				bits	bytes
  -------------------------------------------------------
   Classic CAN SFF no-bitstuffing	111	14
   Classic CAN EFF no-bitstuffing	131	17
   Classic CAN SFF bitstuffing		135	17
   Classic CAN EFF bitstuffing		160	20
   CAN-FD SFF no-bitstuffing		579	73
   CAN-FD EFF no-bitstuffing		598	75
   CAN-FD SFF bitstuffing		712	89
   CAN-FD EFF bitstuffing		736	92

The macro CAN_FRAME_LEN_MAX and CANFD_FRAME_LEN_MAX are kept as an
alias to, respectively, can_frame_bytes(false, true, CAN_MAX_DLEN) and
can_frame_bytes(true, true, CANFD_MAX_DLEN).

In addition to the above:

 - Use ISO 11898-1:2015 definitions for the name of the CAN frame
   fields.
 - Include linux/bits.h for use of BITS_PER_BYTE.
 - Include linux/math.h for use of mult_frac() and
   DIV_ROUND_UP(). N.B: the use of DIV_ROUND_UP() is not new to this
   patch, but the include was previously omitted.
 - Add copyright 2023 for myself.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev/length.c |  15 +-
 include/linux/can/length.h   | 298 +++++++++++++++++++++++++----------
 2 files changed, 213 insertions(+), 100 deletions(-)

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
index 521fdbce2d69..ef6e78fa95b9 100644
--- a/include/linux/can/length.h
+++ b/include/linux/can/length.h
@@ -1,132 +1,256 @@
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
  *
- * Name of Field			Bits
+ * Name of Field				Bits
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
- * ACK slot				1
- * ACK delimiter			1
- * End-of-frame (EOF)			7
- * Inter frame spacing			3
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
  *
- * rounded up and ignoring bitstuffing
+ * including all fields preceding the data field, ignoring bitstuffing
  */
-#define CAN_FRAME_OVERHEAD_SFF DIV_ROUND_UP(47, 8)
+#define CANFD_FRAME_HEADER_EFF_BITS 41
 
 /*
- * Size of a Classical CAN Extended Frame
+ * Size of a CAN CRC Field in bits
  *
  * Name of Field			Bits
  * ---------------------------------------------------------
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
+ * CRC sequence (CRC15)			15
+ * CRC Delimiter			1
  *
- * rounded up and ignoring bitstuffing
+ * ignoring bitstuffing
  */
-#define CAN_FRAME_OVERHEAD_EFF DIV_ROUND_UP(67, 8)
+#define CAN_FRAME_CRC_FIELD_BITS 16
 
 /*
- * Size of a CAN-FD Standard Frame
+ * Size of a CAN-FD CRC17 Field in bits (length: 0..16)
  *
  * Name of Field			Bits
  * ---------------------------------------------------------
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
- *
- * assuming CRC21, rounded up and ignoring dynamic bitstuffing
- */
-#define CANFD_FRAME_OVERHEAD_SFF DIV_ROUND_UP(67, 8)
+ * Stuff Count				4
+ * CRC Sequence (CRC17)			17
+ * CRC Delimiter			1
+ * Fixed stuff bits			6
+ */
+#define CANFD_FRAME_CRC17_FIELD_BITS 28
 
 /*
- * Size of a CAN-FD Extended Frame
+ * Size of a CAN-FD CRC21 Field in bits (length: 20..64)
  *
  * Name of Field			Bits
  * ---------------------------------------------------------
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
- */
-#define CANFD_FRAME_OVERHEAD_EFF DIV_ROUND_UP(86, 8)
+ * Stuff Count				4
+ * CRC sequence (CRC21)			21
+ * CRC Delimiter			1
+ * Fixed stuff bits			7
+ */
+#define CANFD_FRAME_CRC21_FIELD_BITS 33
+
+/*
+ * Size of a CAN(-FD) Frame footer in bits
+ *
+ * Name of Field			Bits
+ * ---------------------------------------------------------
+ * ACK slot				1
+ * ACK delimiter			1
+ * End Of Frame (EOF)			7
+ *
+ * including all fields following the CRC field
+ */
+#define CAN_FRAME_FOOTER_BITS 9
+
+/*
+ * First part of the Inter Frame Space
+ * (a.k.a. IMF - intermission field)
+ */
+#define CAN_INTERMISSION_BITS 3
+
+/**
+ * can_bitstuffing_len() - Calculate the maximum length with bitsuffing
+ * @bitstream_len: length of a destuffed bit stream
+ *
+ * The worst bit stuffing case is a sequence in which dominant and
+ * recessive bits alternate every four bits:
+ *
+ *   Destuffed: 1 1111  0000  1111  0000  1111
+ *   Stuffed:   1 1111o 0000i 1111o 0000i 1111o
+ *
+ * Nomenclature
+ *
+ *  - "0": dominant bit
+ *  - "o": dominant stuff bit
+ *  - "1": recessive bit
+ *  - "i": recessive stuff bit
+ *
+ * Aside of the first bit, one stuff bit is added every four bits.
+ *
+ * Return: length of the stuffed bit stream in the worst case scenario.
+ */
+#define can_bitstuffing_len(destuffed_len)			\
+	(destuffed_len + (destuffed_len - 1) / 4)
+
+#define __can_bitstuffing_len(bitstuffing, destuffed_len)	\
+	(bitstuffing ? can_bitstuffing_len(destuffed_len) :	\
+		       destuffed_len)
+
+#define __can_cc_frame_bits(is_eff, bitstuffing,		\
+			    intermission, data_len)		\
+(								\
+	__can_bitstuffing_len(bitstuffing,			\
+		(is_eff ? CAN_FRAME_HEADER_EFF_BITS :		\
+			   CAN_FRAME_HEADER_SFF_BITS) +		\
+		data_len * BITS_PER_BYTE +			\
+		CAN_FRAME_CRC_FIELD_BITS) +			\
+	CAN_FRAME_FOOTER_BITS +					\
+	(intermission ? CAN_INTERMISSION_BITS : 0)		\
+)
+
+#define __can_fd_frame_bits(is_eff, bitstuffing,		\
+			    intermission, data_len)		\
+(								\
+	__can_bitstuffing_len(bitstuffing,			\
+		(is_eff ? CANFD_FRAME_HEADER_EFF_BITS :		\
+			   CANFD_FRAME_HEADER_SFF_BITS) +	\
+		data_len * BITS_PER_BYTE) +			\
+	(data_len <= 16 ?					\
+		CANFD_FRAME_CRC17_FIELD_BITS :			\
+		CANFD_FRAME_CRC21_FIELD_BITS) +			\
+	CAN_FRAME_FOOTER_BITS +					\
+	(intermission ? CAN_INTERMISSION_BITS : 0)		\
+)
+
+/**
+ * can_frame_bits() - Calculate the number of bits in on the wire in a
+ *	CAN frame
+ * @is_fd: true: CAN-FD frame; false: Classical CAN frame.
+ * @is_eff: true: Extended frame; false: Standard frame.
+ * @bitstuffing: true: calculate the bitsuffing worst case; false:
+ *	calculate the bitsuffing best case (no dynamic
+ *	bitsuffing). Fixed stuff bits are always included.
+ * @intermission: if and only if true, include the inter frame space
+ *	assuming no bus idle (i.e. only the intermission gets added).
+ * @data_len: length of the data field in bytes. Correspond to
+ *	can(fd)_frame->len. Should be zero for remote frames. No
+ *	sanitization is done on @data_len.
+ *
+ * Return: the numbers of bits on the wire of a CAN frame.
+ */
+#define can_frame_bits(is_fd, is_eff, bitstuffing,		\
+		       intermission, data_len)			\
+(								\
+	is_fd ? __can_fd_frame_bits(is_eff, bitstuffing,	\
+				    intermission, data_len) :	\
+		__can_cc_frame_bits(is_eff, bitstuffing,	\
+				    intermission, data_len)	\
+)
+
+/*
+ * Number of bytes in a CAN frame
+ * (rounded up, including intermission)
+ */
+#define can_frame_bytes(is_fd, is_eff, bitstuffing, data_len)	\
+	DIV_ROUND_UP(can_frame_bits(is_fd, is_eff, bitstuffing,	\
+				    true, data_len),		\
+		     BITS_PER_BYTE)
 
 /*
  * Maximum size of a Classical CAN frame
- * (rounded up and ignoring bitstuffing)
+ * (rounded up, ignoring bitstuffing but including intermission)
  */
-#define CAN_FRAME_LEN_MAX (CAN_FRAME_OVERHEAD_EFF + CAN_MAX_DLEN)
+#define CAN_FRAME_LEN_MAX \
+	can_frame_bytes(false, true, false, CAN_MAX_DLEN)
 
 /*
  * Maximum size of a CAN-FD frame
  * (rounded up and ignoring bitstuffing)
  */
-#define CANFD_FRAME_LEN_MAX (CANFD_FRAME_OVERHEAD_EFF + CANFD_MAX_DLEN)
+#define CANFD_FRAME_LEN_MAX \
+	can_frame_bytes(true, true, false, CANFD_MAX_DLEN)
 
 /*
  * can_cc_dlc2len(value) - convert a given data length code (dlc) of a
-- 
2.39.3


