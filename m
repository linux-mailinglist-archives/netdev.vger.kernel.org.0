Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B179B2B5BCB
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 10:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgKQJ3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 04:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgKQJ3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 04:29:19 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498EEC0613CF;
        Tue, 17 Nov 2020 01:29:19 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id y22so9927508plr.6;
        Tue, 17 Nov 2020 01:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=taVuaxJuJ7EQ+4hVrsVwgU82k/trg5+cP1h86NsfPac=;
        b=dCXq2U0Sobx9V5ZtpD2vGFsvvj24LDEvbXY1Rn3BNpIOaOOouTG6v/TTxdgY33H3gk
         pPb5X86LbNjA7dGIkXbbZQcgA9l5RmZA6er7MKZPZyQNjAnaAIsgYrU3+WyiA5b6OpPe
         Yhg4w1SwToqY1lh0Mf+3FcDiKL5FxdjY50t7nkGlsm1IudU0z9zxWA1oHgpWJ0s05lm/
         um2TlK7Alera6eQDGViwJsWWWmi76KkFb8GLIL9Y/g8VfAfNJMztPHj15LMSccQCIM3V
         z4aB2ha0h5kPQ+9f6Xtokp+UMf2OO1Es/HJZINK+AuagCHpnmkw+zvDo+RWl3xfHHG83
         w5Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=taVuaxJuJ7EQ+4hVrsVwgU82k/trg5+cP1h86NsfPac=;
        b=QY5FqlAZDYugd/YONcFpaFeXQ6tgHrVnQQybkEVVmcfw4blaR1b/cMjX7HhrPtzdgM
         8YaJi1xOT4Nd8xp/F6WieQOO1NYbIVwOAiqUAWs9h3W1/UNrOG8aaOizsd3Ueq1ao/Vx
         IaCp2HlAp0CtzoCyr0+1TBHBvlUYKyUhLXEoL0mqZ+nXkpJWEEV79w01iG0gX/gZNMHC
         Kgpd1qjF3DeK+Roy+EfN0AnICL8m43dXe+sjKJLW7mfQO0MP1MMZFAXp/v0Nx9m3qB1u
         EFg6zRj/FW9Xf8jU0apjyQfiv3yOzeWqbjubUwfXnSf+uOR5ktEKhdq1QMDrVMosK36B
         69cw==
X-Gm-Message-State: AOAM531paBmfJzrlyjdBJzmmZ0nnWj1XaPADqygjilt8HWp6puNxZurK
        qO892FdtKcqM+qE/iz3gyA==
X-Google-Smtp-Source: ABdhPJy3fOkbTcEtV9UNV1OJsW2pjwOEqevFpIvmZicEo8cfUyjqzTavhSG2kkL2jBzx3Px+mXcLqw==
X-Received: by 2002:a17:90b:1881:: with SMTP id mn1mr3116990pjb.113.1605605358947;
        Tue, 17 Nov 2020 01:29:18 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id b3sm19814965pfd.66.2020.11.17.01.29.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Nov 2020 01:29:17 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     mkl@pengutronix.de, manivannan.sadhasivam@linaro.org,
        thomas.kopp@microchip.com, wg@grandegger.com, kuba@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] can: mcp251xfd: remove useless code in mcp251xfd_chip_softreset
Date:   Tue, 17 Nov 2020 17:29:12 +0800
Message-Id: <1605605352-25298-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

It would directly return if the variable err equals to 0 or other errors.
Only when the err equals to -ETIMEDOUT it can reach the 'if (err)'
statement, so the 'if (err)' and last 'return -ETIMEDOUT' statements are
useless. Romove them.

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 9c215f7c5f81..ceae18270c01 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -644,10 +644,7 @@ static int mcp251xfd_chip_softreset(const struct mcp251xfd_priv *priv)
 		return 0;
 	}
 
-	if (err)
-		return err;
-
-	return -ETIMEDOUT;
+	return err;
 }
 
 static int mcp251xfd_chip_clock_init(const struct mcp251xfd_priv *priv)
-- 
2.20.0

