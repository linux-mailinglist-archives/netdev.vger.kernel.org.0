Return-Path: <netdev+bounces-7173-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9002871EFE2
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:58:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B21E2818B6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:58:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9146042537;
	Thu,  1 Jun 2023 16:57:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851CA13AC3
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:57:21 +0000 (UTC)
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECEED1;
	Thu,  1 Jun 2023 09:57:19 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b02497f4cfso6001025ad.3;
        Thu, 01 Jun 2023 09:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685638639; x=1688230639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7h0TdCJfD08H6NCGeosONtPPa8bYF9tCFg6CCBMwsB0=;
        b=DN3Nug1TQrYqdnnpmwPWOztrA7QQE9+rRjh6LL5BoITjeQ5YYjlwrES+SP843//pL3
         UvhTJI7qCAKXvffRaB0x4MyZXHeablRoyQZzqfqpkp9HlGBpPQ76/C8dHvohW5B9FQuw
         xLRq1mvQCky3AYiF7Ptg7qh3ksbssvTjxbbB/e+KxD2eg3eY228ZBocwYRAVDeeq2Vb/
         AU+BUKc5n5QnUWIMpGPYN3jwJEtyhA7MPDG8V+WER+Ji2vey4WnUnUad7+ZG4/5Gmlue
         pxIxNFw0j0/N1/ohnwYjNi80n16DKEzM4REYNMIv90VuurwsxnEb13T1KqAHO7jn9Lgd
         HKDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685638639; x=1688230639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7h0TdCJfD08H6NCGeosONtPPa8bYF9tCFg6CCBMwsB0=;
        b=I0TcWQ4lCt3wOKxu1O4tnI16YtHw8NgrcoWYp3047P36uoVMHKvTQY0E/lD3SvLGub
         3NzXOtq/1mMUjdgeQ4isHRQEnqwQ8TLNItbjsz7csS1pGl//ioinO4Q/gXecMUfseAPk
         2AhBtgbo1yA+9JTBBIo14xAs002+H7KpJyo6rUgwfrThwXoX4Ct+a1RSXerkEXk0/FEM
         by4jSuRs4+ANNTT9vUkRFknzkeOviawgNXrPrw9HduYp64xXLQb1Tdc6/oeg7HtBZ3ns
         QF/uzyKe4c9N4YHDW5zkmW4Le0eq4yM1nucdA3Fb/vjwf4c+DjTLXnHIST8MyVz0h8Ce
         IwZw==
X-Gm-Message-State: AC+VfDwP/dgV1Hwct+gsGwS6p4q5ogZ52vnxYSezUzcPRGJ2nge8buMi
	tzD+d+ovqqatnr5SWLm89VJ0UgeRxwA=
X-Google-Smtp-Source: ACHHUZ6p9E3FJUPUWSBfCoFafQ942GYFg1v2UlEzW306v+QfH3k/f9QvqvSLvcE+t+o15nWKV/7w1g==
X-Received: by 2002:a17:902:6546:b0:1b0:307c:e6fe with SMTP id d6-20020a170902654600b001b0307ce6femr40846pln.10.1685638639457;
        Thu, 01 Jun 2023 09:57:19 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902788500b001b0305757c3sm3744648pll.51.2023.06.01.09.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 09:57:19 -0700 (PDT)
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
Subject: [PATCH v4 2/3] can: length: fix description of the RRS field
Date: Fri,  2 Jun 2023 01:56:24 +0900
Message-Id: <20230601165625.100040-3-mailhol.vincent@wanadoo.fr>
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

The CAN-FD frames only have one reserved bit. The bit corresponding to
Classical CAN frame's RTR bit is called the "Remote Request
Substitution (RRS)" [1].

N.B. The RRS is not to be confused with the Substitute remote request
(SRR).

Fix the description in the CANFD_FRAME_OVERHEAD_SFF/EFF.

The total remains unchanged, so this is just a documentation fix.

In addition to the above add myself as copyright owner for 2020 (as
coauthor of the initial version, c.f. Fixes tag).

[1] ISO 11898-1:2015 paragraph 10.4.2.3 "Arbitration field":

  RSS bit [only in FD Frames]

    The RRS bit shall be transmitted in FD Frames at the position of
    the RTR bit in Classical Frames. The RRS bit shall be transmitted
    dominant, but receivers shall accept recessive and dominant RRS
    bits.

Fixes: 85d99c3e2a13 ("can: length: can_skb_get_frame_len(): introduce function to get data length of frame in data link layer")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Reviewed-by: Thomas Kopp <Thomas.Kopp@microchip.com>
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
2.39.3


