Return-Path: <netdev+bounces-6442-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32EF17164B8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:47:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB9A51C20B94
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C23C1F174;
	Tue, 30 May 2023 14:47:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF2A1F164
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:47:31 +0000 (UTC)
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850FAA7;
	Tue, 30 May 2023 07:47:29 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-64d4e45971bso3057666b3a.2;
        Tue, 30 May 2023 07:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685458049; x=1688050049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZz0jOLUEDQ4PhvWl6svx6nwTxioTgR9+aed2oIyP90=;
        b=aHVoU/JQBfEnUYOXxPRfcLvz9oAsk5mg4R8nEX+L+NrCEUVKbQK3pqbnjQqBi+GWa2
         hOKRZMKDwyVdzwaY5tARCilXmEnNfjBxlQxMITVTdT6+Og5LByszj+cXe1rdZoqKi2GE
         FMx3KZbP7IQ9EsTVoLDxjbqgznKaabP0wrYqqMFI0nYTD/qouGj6QUEdw/t/70g9zjPz
         u66O+FYO3HYs64KQ260u3cD3wY0uo00FOpsoPBCQm5TZ+qWbqxprxr+uEpbmsD8qGQYV
         I5JvnHIGLVzAsWplnaf8XhWskXOFr+iL6D+4fiBIdE1wNgLE8dAAbaoFDubYXKb/lllI
         NicA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685458049; x=1688050049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mZz0jOLUEDQ4PhvWl6svx6nwTxioTgR9+aed2oIyP90=;
        b=jnaUdQZSMOdRf6GcLPVWa/HWSCo1/+44dMDl3q2/SFLQHeLX7fR3+okZ7SyftD1nHt
         EUsRtXgn8LbhZA50RhmfDLVUseiVJ04IjaoWJwEOkREHb8o1bXoSVTx4O1HC4RKehXox
         y6l5KUPBF3NBjnbihcN86ZVgFLIdJDxNa+1Hpk4UHDV8JGpr1pMegxTtduwktkBTO5lP
         Pmf5WYYZvk5Gso+8Xh77Y0OdX0XpE6QXGWT5oZ1q7pzYSkNn4GGaWoiNnPYKnQyfraV5
         h91r2GCn4weYhTJ/YU7KWTraywcsEwilVzjmBwTB4vTx9SfhrBiOxPVzYzoN+NCXsrrY
         rz3g==
X-Gm-Message-State: AC+VfDxIZBOIlal7tMEi/fGfSwAMkZSTmxcr5cwo7QNCtZzIlMiWAdbw
	ar80+NvAC/QbiEzaCF8tnVE=
X-Google-Smtp-Source: ACHHUZ60DopcWxp7/qD1C/V+OfdtkDZbEkDTkFK5+0J4U1NO7Buy2PUY5+u3fx/HYn6VNy8Zw5qKzQ==
X-Received: by 2002:a05:6a21:78b:b0:10d:b160:3d5c with SMTP id mg11-20020a056a21078b00b0010db1603d5cmr2663649pzb.12.1685458048944;
        Tue, 30 May 2023 07:47:28 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id e3-20020aa78c43000000b0063a04905379sm1703193pfd.137.2023.05.30.07.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 07:47:28 -0700 (PDT)
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
Subject: [PATCH v3 1/3] can: length: fix bitstuffing count
Date: Tue, 30 May 2023 23:46:35 +0900
Message-Id: <20230530144637.4746-2-mailhol.vincent@wanadoo.fr>
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

The Stuff Bit Count is always coded on 4 bits (ref [1]). Update the
Stuff Bit Count size accordingly.

In addition, the CRC fields of CAN FD Frames contain stuff bits at
fixed positions called fixed stuff bits [2]. The CRC field starts with
a fixed stuff bit and then has another fixed stuff bit after each
fourth bit [2], which allows us to derive this formula:

  FSB count = 1 + round_down(len(CRC field)/4)

The length of the CRC field is [1]:

  len(CRC field) = len(Stuff Bit Count) + len(CRC)
                 = 4 + len(CRC)

with len(CRC) either 17 or 21 bits depending of the payload length.

In conclusion, for CRC17:

  FSB count = 1 + round_down((4 + 17)/4)
            = 6

and for CRC 21:

  FSB count = 1 + round_down((4 + 21)/4)
            = 7

Add a Fixed Stuff bits (FSB) field with above values and update
CANFD_FRAME_OVERHEAD_SFF and CANFD_FRAME_OVERHEAD_EFF accordingly.

[1] ISO 11898-1:2015 section 10.4.2.6 "CRC field":

  The CRC field shall contain the CRC sequence followed by a recessive
  CRC delimiter. For FD Frames, the CRC field shall also contain the
  stuff count.

  Stuff count

  If FD Frames, the stuff count shall be at the beginning of the CRC
  field. It shall consist of the stuff bit count modulo 8 in a 3-bit
  gray code followed by a parity bit [...]

[2] ISO 11898-1:2015 paragraph 10.5 "Frame coding":

  In the CRC field of FD Frames, the stuff bits shall be inserted at
  fixed positions; they are called field stuff bits. There shall be a
  fixed stuff bit before the first bit of the stuff count, even if the
  last bits of the preceding field are a sequence of five consecutive
  bits of identical value, there shall be only the fixed stuff bit,
  there shall not be two consecutive stuff bits. A further fixed stuff
  bit shall be inserted after each fourth bit of the CRC field [...]

Fixes: 85d99c3e2a13 ("can: length: can_skb_get_frame_len(): introduce function to get data length of frame in data link layer")
Suggested-by: Thomas Kopp <Thomas.Kopp@microchip.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 include/linux/can/length.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/linux/can/length.h b/include/linux/can/length.h
index 69336549d24f..b8c12c83bc51 100644
--- a/include/linux/can/length.h
+++ b/include/linux/can/length.h
@@ -72,17 +72,18 @@
  * Error Status Indicator (ESI)		1
  * Data length code (DLC)		4
  * Data field				0...512
- * Stuff Bit Count (SBC)		0...16: 4 20...64:5
+ * Stuff Bit Count (SBC)		4
  * CRC					0...16: 17 20...64:21
  * CRC delimiter (CD)			1
+ * Fixed Stuff bits (FSB)		0...16: 6 20...64:7
  * ACK slot (AS)			1
  * ACK delimiter (AD)			1
  * End-of-frame (EOF)			7
  * Inter frame spacing			3
  *
- * assuming CRC21, rounded up and ignoring bitstuffing
+ * assuming CRC21, rounded up and ignoring dynamic bitstuffing
  */
-#define CANFD_FRAME_OVERHEAD_SFF DIV_ROUND_UP(61, 8)
+#define CANFD_FRAME_OVERHEAD_SFF DIV_ROUND_UP(67, 8)
 
 /*
  * Size of a CAN-FD Extended Frame
@@ -101,17 +102,18 @@
  * Error Status Indicator (ESI)		1
  * Data length code (DLC)		4
  * Data field				0...512
- * Stuff Bit Count (SBC)		0...16: 4 20...64:5
+ * Stuff Bit Count (SBC)		4
  * CRC					0...16: 17 20...64:21
  * CRC delimiter (CD)			1
+ * Fixed Stuff bits (FSB)		0...16: 6 20...64:7
  * ACK slot (AS)			1
  * ACK delimiter (AD)			1
  * End-of-frame (EOF)			7
  * Inter frame spacing			3
  *
- * assuming CRC21, rounded up and ignoring bitstuffing
+ * assuming CRC21, rounded up and ignoring dynamic bitstuffing
  */
-#define CANFD_FRAME_OVERHEAD_EFF DIV_ROUND_UP(80, 8)
+#define CANFD_FRAME_OVERHEAD_EFF DIV_ROUND_UP(86, 8)
 
 /*
  * Maximum size of a Classical CAN frame
-- 
2.39.3


