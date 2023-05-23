Return-Path: <netdev+bounces-4575-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA09F70D45C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:53:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 883B61C20BF8
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:53:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E28201D2B2;
	Tue, 23 May 2023 06:52:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72F61C756
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:52:58 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FD1119;
	Mon, 22 May 2023 23:52:57 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64d57cd373fso1833828b3a.1;
        Mon, 22 May 2023 23:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684824777; x=1687416777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zpK9eA/3lj+tjk28hEidhkgrs72aVJBKWP37x7Y8nRU=;
        b=jxSF1xNrMXLa2fxm1HVUxgI+vnvNGjGG11M8uSAyHpciiyZxguwmmwPhAqXAIuX7Al
         AXQfvAgbkmHVEAFeY69CvN4nFCfMfBSVVaE8o7GQscOHPMZCzjApSWdQfuMQbMgF/qJS
         Tz5Cdrc5SW94sdDyhA4kFzIqI9pRQ1GP6g8RrPNMTAoNT0LmH9R+DE72NrSG6oB55itw
         UlXLmZbvB/x3WwJMG5AprzGcrl5rnCtv89xqTAirRoyxh4jy5NZMKtdnZbbIFBjfPc0t
         1BYEY8ju8QuR6wfNOt1agDFKlRo653+KePKZ6eDtgpd+6+DVWqyr0H5/nB03nfWd6dnO
         /Twg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684824777; x=1687416777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zpK9eA/3lj+tjk28hEidhkgrs72aVJBKWP37x7Y8nRU=;
        b=QzKjcIsbBm0WI14+y73Cz8QZExeDEx0X2DG2xHDrOJPqD0Pt5pgMM/MUd+V5FA8d5i
         BeGpTsfS82krUS4YLPWwMECuDoMobdGNp+qzqWjaHRA1QAFLsqed5o6dcyvdLbmYWEcS
         lHsbJxXFTzAJ42sIWHowNloHTBUjzQu6CUqcbXzXPjwcOk5wFLSvFmK2FpEuSYNqEM+N
         S/k2rpuYqOfh6EDpZp7dGhZNXuBPGO6LDmIzYfsX11rhQMN4Xuv/w/Dstz1iTScINlq7
         GX1bAlR0C38M29Q+WLtsg3ohyHo7P2019qJY5su2q9IcfFBr2id0vNx9ztlmHjFY1/a1
         5upQ==
X-Gm-Message-State: AC+VfDzkrvnd1MBaHCNOBrPR6lO9LBN2GQVcvq5sZfj+eR0swalZlOKO
	JyX6t70V9RRDl/Plc9nu3lU=
X-Google-Smtp-Source: ACHHUZ5OxZKCKXwKZUZsVbNCwhiHNClCKuTWkPqsjWpXlN1aK1d5YNXWHwIALY/HIiTRg9XVvYnMoQ==
X-Received: by 2002:a17:902:ecc8:b0:1ab:1260:19de with SMTP id a8-20020a170902ecc800b001ab126019demr15771034plh.11.1684824776960;
        Mon, 22 May 2023 23:52:56 -0700 (PDT)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id d10-20020a170902ceca00b001aafa2e212esm5963920plg.52.2023.05.22.23.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 23:52:56 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
	linux-can@vger.kernel.org,
	Thomas.Kopp@microchip.com
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
	netdev@vger.kernel.org,
	marex@denx.de,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v2 2/3] can: length: fix description of the RRS field
Date: Tue, 23 May 2023 15:52:17 +0900
Message-Id: <20230523065218.51227-3-mailhol.vincent@wanadoo.fr>
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

The CAN-FD frames only have one reserved bit. The bit corresponding to
Classical CAN frame's RTR bit is called the "Remote Request
Substitution (RRS)" [1].

N.B. The RRS is not to be confused with the Substitute remote request
(SRR).

Fix the description in the CANFD_FRAME_OVERHEAD_SFF/EFF.

The total remains unchange, so this is just a documentation fix.

In addition to the above add myself as copyright owner for 2020 (as
coauthor of the initial version, c.f. Fixes tag).

[1] ISO 11898-1:2015 paragraph 10.4.2.3 "Arbitration field":

  RSS bit [only in FD Frames]

    The RRS bit shall be transmitted in fD Frames at the position of
    the RTR bit in Classical Frames. The RRS bit shall be transmitted
    dominant, but receivers shall accept recessive and dominant RRS
    bits.

Fixes: 85d99c3e2a13 ("can: length: can_skb_get_frame_len(): introduce function to get data length of frame in data link layer")
Suggested-by: Thomas Kopp <Thomas.Kopp@microchip.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 include/linux/can/length.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/can/length.h b/include/linux/can/length.h
index b8c12c83bc51..521fdbce2d69 100644
--- a/include/linux/can/length.h
+++ b/include/linux/can/length.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (C) 2020 Oliver Hartkopp <socketcan@hartkopp.net>
  * Copyright (C) 2020 Marc Kleine-Budde <kernel@pengutronix.de>
+ * Copyright (C) 2020 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
  */
 
 #ifndef _CAN_LENGTH_H
@@ -64,7 +65,7 @@
  * ---------------------------------------------------------
  * Start-of-frame			1
  * Identifier				11
- * Reserved bit (r1)			1
+ * Remote Request Substitution (RRS)	1
  * Identifier extension bit (IDE)	1
  * Flexible data rate format (FDF)	1
  * Reserved bit (r0)			1
@@ -95,7 +96,7 @@
  * Substitute remote request (SRR)	1
  * Identifier extension bit (IDE)	1
  * Identifier B				18
- * Reserved bit (r1)			1
+ * Remote Request Substitution (RRS)	1
  * Flexible data rate format (FDF)	1
  * Reserved bit (r0)			1
  * Bit Rate Switch (BRS)		1
-- 
2.25.1


