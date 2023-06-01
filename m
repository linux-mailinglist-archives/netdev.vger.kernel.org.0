Return-Path: <netdev+bounces-7172-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F42971EFDE
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:57:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDD85281873
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C70E042527;
	Thu,  1 Jun 2023 16:57:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB59D13AC3
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:57:18 +0000 (UTC)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC1DD1;
	Thu,  1 Jun 2023 09:57:17 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b04706c85fso10383645ad.0;
        Thu, 01 Jun 2023 09:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685638637; x=1688230637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rhRwdGVTDqMreg20cBOQ5Au8S4SSEFVxnZxcM9wWpK8=;
        b=MaFI+LiiZuEAR7KDYtruCInME3DoQSZw2MUxzC+TgsoXozgU9XYEeyHjp73N7EA1nM
         JI/w5KD096jPJt66pneAq183NAzoMEfYMK/ORmfQTP5boyIEzxk282RmiFIFXTPTh2uA
         KVKFIJATT16GlRPDfghxYQFz+3zgDtGiS+qXxHtXxw9+uH7atFwvT8CkeGGb+UF98LaF
         0K3mFjLpPzrCa5T/tL1Nplo17fz43DhWh1zpiM+EM7zUyYYNjXBZLUQajeOQYQBcKefn
         BvyyZFjTU+5GMqReikpA+ASnpL5cg/aZVfxsoS32Zfo4eaP2ZbG8mGyoAEle6X8MAbF8
         zTig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685638637; x=1688230637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rhRwdGVTDqMreg20cBOQ5Au8S4SSEFVxnZxcM9wWpK8=;
        b=HLBtKgWUjmLINf4603LgHrQUqQska9xnAt8hYO11Q6Hp6yYekTk1abNY+0TWsn7BwK
         fo19VT81VbLVWxFL0GNOJ7haPXbu4aWpuaB4Ccb9AC3u27MlZX5U8ts3QgkEtedlYzmB
         diRmvROnnodRTy9BDtFwL9CBbNdo548N9uvP6K6gFz+pzwcUiFWy6se88+WGDf5zx8Nq
         JI8eQ4+vkejBK+4pyZfL9rgmmuvA8GMd1f8WMYbmQT0IjeHX4lES3fTTKKZaxpRusdyt
         Th+5LSlFY0BzjddCtLWBz48XnxWJv6VcM9KYmNn+vadruEEvg+0MOGmUueb35jbTD6jt
         YgQA==
X-Gm-Message-State: AC+VfDx2L+A3YavD+uWyraozaA0IpTGc1uoRcpt+773jW77/RSbDOuPd
	l21tzohLvHGFAisYNjLAj1E=
X-Google-Smtp-Source: ACHHUZ5mwsTkviUqaEANLyvv4GjLOWrLCHxCSK3BOcT6hgDYkCMu08w8T3NG+IuvQiq8/DZNNBmH+g==
X-Received: by 2002:a17:902:c948:b0:1af:e2f2:1cce with SMTP id i8-20020a170902c94800b001afe2f21ccemr12304697pla.38.1685638636917;
        Thu, 01 Jun 2023 09:57:16 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902788500b001b0305757c3sm3744648pll.51.2023.06.01.09.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 09:57:16 -0700 (PDT)
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
Subject: [PATCH v4 1/3] can: length: fix bitstuffing count
Date: Fri,  2 Jun 2023 01:56:23 +0900
Message-Id: <20230601165625.100040-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230601165625.100040-1-mailhol.vincent@wanadoo.fr>
References: <20230507155506.3179711-1-mailhol.vincent@wanadoo.fr>
 <20230601165625.100040-1-mailhol.vincent@wanadoo.fr>
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
fourth bit [2], which allow us to derive this formula:

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
  fixed positions; they are called fixed stuff bits. There shall be a
  fixed stuff bit before the first bit of the stuff count, even if the
  last bits of the preceding field are a sequence of five consecutive
  bits of identical value, there shall be only the fixed stuff bit,
  there shall not be two consecutive stuff bits. A further fixed stuff
  bit shall be inserted after each fourth bit of the CRC field [...]

Fixes: 85d99c3e2a13 ("can: length: can_skb_get_frame_len(): introduce function to get data length of frame in data link layer")
Suggested-by: Thomas Kopp <Thomas.Kopp@microchip.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Reviewed-by: Thomas Kopp <Thomas.Kopp@microchip.com>
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


