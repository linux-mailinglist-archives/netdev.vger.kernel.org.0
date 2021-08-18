Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120753F0692
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 16:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239697AbhHROXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 10:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239486AbhHROXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 10:23:22 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4938FC06124C;
        Wed, 18 Aug 2021 07:18:45 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id y7so5456039ljp.3;
        Wed, 18 Aug 2021 07:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lkAbLPzA0+wReYg+uxeyS4Ahai638dniVQIMwe53wBs=;
        b=Q9JpuXpCsvHk9PrWBL1oLdxi2jguY2jemVD/SMzo1fHNfTZeaG3Ol5eBeUEAoVlB3k
         b9Hs/0dug65DDZ5KhgtfYw38WhiO36egQQcbriUOLZJUZeLVfzpuUHjsl6xXRRJdiDT0
         ppG+tetxznJ4V9sdW9EAwLOtoiOsFND8XKw9kgklZVIXl6TqEmm+JLtIG5wjSGEqAKSG
         2JqrBQtx4jqh69Al/IS2p5mOVIz5qgAlUAEzkQYcvFMVmOc11T0NilR/1LXx87oNmKJ0
         SlnU426lLdytQ1EIwP9LNSkOy3rm98YTHR1Zh36wFRQBEI0zJA+XI3+u/yyvta3lU2+d
         etaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lkAbLPzA0+wReYg+uxeyS4Ahai638dniVQIMwe53wBs=;
        b=lQ196ZVyrphn6DrEylLdGJ7klZVDRDAZPx/dDyuw5etTmUiBdZs/2FgxBSoREHH/p/
         SOvXrgoucoupcplYoWB9D95utkiKs4QuMBbJtkHhTNrI8QHzfsWItRQ/6OblP44Dh2CW
         Np/DCFRessdF7WBLuAdJlY9K2Di++FSgs7rasJenCGxP9dhwpg4GqfxVkDzUPIMggxaG
         5M7bbZrIwgLLxzXpYa9AwBMULVRZxw+gNyjVtyVSixzZZQ5BPyMdavXeUuSnnE5HXouX
         cKYbeWeTb0wt0iA/0gX3fjQHqKZY4HOMXvRxrA+Fs4dGcpGPalHaO5/2TbycpDfwBChd
         hNZA==
X-Gm-Message-State: AOAM532g8Z1BzQJLcoSbNzlTRHwAGlEQjehThus95mbsBXg5VXCRYgJF
        CVb6SXcc3pqeLyWD9hDzEHs=
X-Google-Smtp-Source: ABdhPJw5B+BvVmUgefznwOf+Ok/MATOeln+DmyWv0+2vibtrno462ozclmlabL6syPOIrf+dRIMsOg==
X-Received: by 2002:a2e:b042:: with SMTP id d2mr2287208ljl.279.1629296323633;
        Wed, 18 Aug 2021 07:18:43 -0700 (PDT)
Received: from localhost.localdomain ([46.235.66.127])
        by smtp.gmail.com with ESMTPSA id f12sm504832lft.294.2021.08.18.07.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 07:18:43 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        andriy.shevchenko@linux.intel.com, christophe.jaillet@wanadoo.fr,
        kaixuxia@tencent.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH v2 1/2] net: pch_gbe: remove mii_ethtool_gset() error handling
Date:   Wed, 18 Aug 2021 17:18:10 +0300
Message-Id: <7e8946ac52de91a963beb7fa0354a19a21c5cf73.1629296113.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <YRzJwjuoJvjfEJpa@smile.fi.intel.com>
References: <YRzJwjuoJvjfEJpa@smile.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mii_ethtool_gset() does not return any errors, so error handling can be
omitted to make code more simple.

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	inverted the order of patches

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

