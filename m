Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209C73EF1F0
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 20:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhHQSgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 14:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbhHQSgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 14:36:12 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AB3C061764;
        Tue, 17 Aug 2021 11:35:38 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id d16so346945ljq.4;
        Tue, 17 Aug 2021 11:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QTBDXnwQGkT+4A4UuLJatqAKSgRrFvBbySkIbNpaSYE=;
        b=QZjIRn7uwlkVj+s5yU06Kvnh0SRLIDmhwCZuVsnW16SlFCD3zkAc7e5sZ6ycLhXUZh
         zZMyHqEm+Ic5etnaDYOFjClkOeAbgMR+e3wbo2VlDKGFzunT6ByjtWXefxDet0UVelBP
         AX/5YTA/IQTZMN1/PsImhZwCqVMwwE5JaL69PR2YrZfKrwvU5RuQ3e0u7ORwhSipxrW9
         ZXVcaxyPCFKb09Tu0xWXb1RoDj31JWnT2rSFT8elvMdeMAwiuEbTIKa2zevX+HemYidg
         /W/JXqQOsJ1XBo9Yv5m30unJxWLC4NOS4MvaRhZvr8peBRUKFnXbOEaZaIQ89VDm0QEx
         e2dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QTBDXnwQGkT+4A4UuLJatqAKSgRrFvBbySkIbNpaSYE=;
        b=QLg3xnySY7QAdfahLGkyXDnEfAMwppZYCTpLePyXIqp7+kG+r99zbktXEMf3p0fTK5
         RZZeo/l6dcmXY6yWqKcOz+WcN9L/m2AreqMD5T1PJCQ6tgl5CVdzDJELaQDOcD2or5G8
         +c2QW0QpDfl3esuDvsvRgpWCPYeTzYXY6sSceaJIgJfoHv9hNXA58Ut+eGR5+YqCmISt
         g9Z0pW3h4ReaXmdhjSpgMEmQQu9gP96JlPYIcaRlItQLwmtyDJOE1B2gc+nGLCDwdsUH
         Zgi1OZuoJrIK12nh8ejP63jWp8iK6A0RvxZlmJQZOe0zbXYCWRvb0MH8woaHXef4KQXM
         br4A==
X-Gm-Message-State: AOAM533gGTbP58JQbYqvi4vKmpeX22IXoDXQ6XlZwtBZ9o0R32DoKqWV
        UFJZfyuZIZrtHc+VtR/8r+s=
X-Google-Smtp-Source: ABdhPJwbnhWtQ8TneqnM2aEr/lMnzIb4+YPLmJLc/hcb8eryahYg4crcKxa/1SYKeymcJjTuJRTUvQ==
X-Received: by 2002:a05:651c:11c7:: with SMTP id z7mr4415069ljo.288.1629225336963;
        Tue, 17 Aug 2021 11:35:36 -0700 (PDT)
Received: from localhost.localdomain ([46.235.66.127])
        by smtp.gmail.com with ESMTPSA id x27sm258004lfa.232.2021.08.17.11.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 11:35:36 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        andriy.shevchenko@linux.intel.com, christophe.jaillet@wanadoo.fr,
        jesse.brandeburg@intel.com, kaixuxia@tencent.com,
        lee.jones@linaro.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 2/2] net: pch_gbe: remove mii_ethtool_gset() error handling
Date:   Tue, 17 Aug 2021 21:35:33 +0300
Message-Id: <2fd83384bde83d9cd4ad5111b03e653bd9a8fe84.1629225090.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <680892d787669c56f0ceac0e9c113d6301fbe7c6.1629225089.git.paskripkin@gmail.com>
References: <680892d787669c56f0ceac0e9c113d6301fbe7c6.1629225089.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since mii_ethtool_gset() becomes void in previous patch we can omit
cheking return value of this function and make code more simple.

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 8 +-------
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.c  | 4 +---
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index e351f3d1608f..539bddfab2d4 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -1031,13 +1031,7 @@ static void pch_gbe_watchdog(struct timer_list *t)
 		struct ethtool_cmd cmd = { .cmd = ETHTOOL_GSET };
 		netdev->tx_queue_len = adapter->tx_queue_len;
 		/* mii library handles link maintenance tasks */
-		if (mii_ethtool_gset(&adapter->mii, &cmd)) {
-			netdev_err(netdev, "ethtool get setting Error\n");
-			mod_timer(&adapter->watchdog_timer,
-				  round_jiffies(jiffies +
-						PCH_GBE_WATCHDOG_PERIOD));
-			return;
-		}
+		mii_ethtool_gset(&adapter->mii, &cmd);
 		hw->mac.link_speed = ethtool_cmd_speed(&cmd);
 		hw->mac.link_duplex = cmd.duplex;
 		/* Set the RGMII control. */
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.c
index ed832046216a..3426f6fa2b57 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.c
@@ -301,9 +301,7 @@ void pch_gbe_phy_init_setting(struct pch_gbe_hw *hw)
 	int ret;
 	u16 mii_reg;
 
-	ret = mii_ethtool_gset(&adapter->mii, &cmd);
-	if (ret)
-		netdev_err(adapter->netdev, "Error: mii_ethtool_gset\n");
+	mii_ethtool_gset(&adapter->mii, &cmd);
 
 	ethtool_cmd_speed_set(&cmd, hw->mac.link_speed);
 	cmd.duplex = hw->mac.link_duplex;
-- 
2.32.0

