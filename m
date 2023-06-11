Return-Path: <netdev+bounces-9866-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EEE272B00F
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 04:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 690A41C20B05
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 02:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C4EB15CB;
	Sun, 11 Jun 2023 02:58:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E73315B2
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 02:58:01 +0000 (UTC)
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A4294;
	Sat, 10 Jun 2023 19:58:00 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-25bc1014777so325306a91.2;
        Sat, 10 Jun 2023 19:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686452279; x=1689044279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sos5o2aSl2Xna3lUYggO8oUvOki47+N42NOhecvp6Vo=;
        b=Q0OF3etzomXhdeRg6ENjdEchikfpz1lT3HZNcT5mmdHo2mDA8Wh5evlx5DBhAiJT1D
         JhWSqPzCBu19NuMPjJJ7CXdZN9+7H3oV67hMjmQQp9U6ep/P39K1LReydwamXqLbF9Dx
         WJqB17NNI9DQHmyThf1GRZ25WuIuHmJPRV/10cJzJJs9a2HewuUKMTWBgnWBHoXh7qVa
         qxk0mwkW4N+G8dKyLT2ijn8kSEDYNMgKHMMlgHqNckLAWrFF+iGuyR6jv7pq/b6ZEH9j
         K2DLpck9k7Bd747i3oSvXv4tZA7A77LRc3iz5mj5KW4a99Lia+H04bWwXDtZK2wSXeKJ
         1RmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686452279; x=1689044279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sos5o2aSl2Xna3lUYggO8oUvOki47+N42NOhecvp6Vo=;
        b=lJSMZZYUyV9Y73OVWAO4cz6QoxpqavmH0rpJoUAdikiaE9WDw4E6LsYrk4VjxmSRmt
         xluIuVGN6lmqCDyWuE6EdfiK/JOaIZxhpXwQ6d/VWeY5FKqsjwt1GQ1vJnW2ZvyRKPs7
         wjy6xvYQME4RqjpArAEKEbHNdB8WZiw+62Ve3vyA0pcJk4fV9FKIbmsiUfENNRyUUu2E
         amq42b9DmRaJcdxxM+xl9NVAj4xmiYW4fiJVE9WvSwFz7mEPsSUUqKjdz1k+wPx8Yqmf
         5I2DTrAWJmL7WGE7uc6pSefQleR7owwsYMUDGqNWm8Jaj9Mc8Ngiy4ruJ1taVjwtdn/T
         tgPQ==
X-Gm-Message-State: AC+VfDz3bGy3d0FTZEUImevDANKZDExvVxZFqngFYKaiPpe3mD6N+Nhq
	u0tbRfiB7OBK//YpIG1oKEA=
X-Google-Smtp-Source: ACHHUZ7qUgwQ+ZoY49q3sUoL3fEpdG9yHrhouP2h5VlXnMee+FJEdlPZgbvG8N2Zw9m7+KOn772x5g==
X-Received: by 2002:a17:90b:4a84:b0:259:16e6:ceaa with SMTP id lp4-20020a17090b4a8400b0025916e6ceaamr5047249pjb.12.1686452279554;
        Sat, 10 Jun 2023 19:57:59 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id l7-20020a17090a150700b0025621aa4c6bsm1530319pja.25.2023.06.10.19.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 19:57:59 -0700 (PDT)
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
Subject: [PATCH v5 2/3] can: length: fix description of the RRS field
Date: Sun, 11 Jun 2023 11:57:27 +0900
Message-Id: <20230611025728.450837-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230611025728.450837-1-mailhol.vincent@wanadoo.fr>
References: <20230507155506.3179711-1-mailhol.vincent@wanadoo.fr>
 <20230611025728.450837-1-mailhol.vincent@wanadoo.fr>
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

N.B. The RRS is not to be confused with the Substitute Remote Request
(SRR).

Fix the description in the CANFD_FRAME_OVERHEAD_SFF/EFF macros.

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


