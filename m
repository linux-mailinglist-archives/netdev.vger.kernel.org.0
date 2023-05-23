Return-Path: <netdev+bounces-4574-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB78370D45B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:53:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 668772812A4
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F1A01C760;
	Tue, 23 May 2023 06:52:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545351C756
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:52:57 +0000 (UTC)
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83286109;
	Mon, 22 May 2023 23:52:55 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1ae4c5e12edso52896005ad.3;
        Mon, 22 May 2023 23:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684824775; x=1687416775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v6WoMUPBPZ0xKom/xo0TfG/SnouT/YookA478MfBXb4=;
        b=F0wJm02uha2IhksGg8WhtsbsyRvqPaHuOQ05l9L17GEPb9unQNKjWdzengHn6z1kQ/
         /IIQqe+zSusJD/cSFy/0IbFZ/hVJmx4fQ6FlkflnO3il6FJqhiQMg1WpxnefvgaEdXer
         J2XMaW7Pp2Gs+9fA+hyOl8759MGReIb2cPyh8zIffjtAQm+KQZUjqhL8GudbMcOAETTe
         2ViT2Dserzqruo+Yw4Tksn7+iYs6vmYuCyarK/vOCQBUusZPxdGQa6Q3fh2XNBtuJUpn
         a95lA0icXIjkuMQ0Ai5CQayg5bx+LotQ6sZFBqfVZQOrIAdwQwxoSeqfCdISNF3tEpbZ
         Ldow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684824775; x=1687416775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v6WoMUPBPZ0xKom/xo0TfG/SnouT/YookA478MfBXb4=;
        b=ZkWNJ/5q7qv92dpC0gLO/3HdifXcRYQgQtC6cHsNPACSrUdxppmZ2g1ZwV5KAuXYvC
         kqRjiF0G2EGAqZotQ3yZVL6OwrvWxNd3FpDNMfxgehcxOFYT/idQfn78EqdBpPa15/Pe
         sch3xZBQwieSB2k+nO229uQJTmkfnArdKmAjMgw1mo4Ekt16QT+ZN/SrYK9Qy1QyDQYE
         xps7Dlj1OLXqap2Pb9N5r28XPLBmx0O28taaZHVrCcUm0xFdKh/NtTKXDvSGedZZx9RH
         UYQ93hwadYAhD384kxaEXGZZ4hotmobuaCN8wK7tkf7ln0Y431YT3yNLBR/rCc8mvqnk
         +bQQ==
X-Gm-Message-State: AC+VfDwQ9iRFy7cuvmihv5tpT2k4wZiDHg8T+IuH8pxQ/YmIi6xHydbX
	grLqrnMDucV5ihAYcZK7g1mGm6HmRBc=
X-Google-Smtp-Source: ACHHUZ6HV5t+LdWMZI7SSiC067iesOljqC4dUAif5TXzMvtC3V33m2GpmjS4cWyc1Yh1wAdce10Oew==
X-Received: by 2002:a17:902:d2c2:b0:1ac:b4db:6a62 with SMTP id n2-20020a170902d2c200b001acb4db6a62mr13896815plc.65.1684824774460;
        Mon, 22 May 2023 23:52:54 -0700 (PDT)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id d10-20020a170902ceca00b001aafa2e212esm5963920plg.52.2023.05.22.23.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 23:52:54 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
	linux-can@vger.kernel.org,
	Thomas.Kopp@microchip.com
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
	netdev@vger.kernel.org,
	marex@denx.de,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v2 1/3] can: length: fix bitstuffing count
Date: Tue, 23 May 2023 15:52:16 +0900
Message-Id: <20230523065218.51227-2-mailhol.vincent@wanadoo.fr>
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

The Stuff Bit Count is always coded on 4 bits (ref [1]). Update the
Stuff Bit Count size accordingly.

In addition, the CRC fields of CAN FD Frames contain stuff bits at
fixed positions call fixed stuff bits [2]. The CRC field starts with a
fixed stuff bit and then has another fixed stuff bit after each fourth
bit [2], which allow us to derive this formula:

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
2.25.1


