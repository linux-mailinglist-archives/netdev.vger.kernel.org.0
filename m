Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DF3368EC7
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 10:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241398AbhDWIWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 04:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbhDWIWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 04:22:52 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2220C061756
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 01:22:15 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id a5so17879169ljk.0
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 01:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MPPttOQ4y+lHOJw1rgFNqb/3DdTQmk+sv8Yecz46jBg=;
        b=nh0qFlJNsOOnu0zf+GVaL/eA3VBUitV0yswC8M5MACrAXAOtyyugGd9NBUKghUknnT
         oIff5VGMkQwNIkTIfkZbOnexfqAjfdDDps/f+tflAg1BNJGPk6aFsy8KSPMNpQqxMjKt
         71OFy1UbdNOpQ9+AKI0pMY4A9KLNp7GYeeiPsuGeblXfnePkIcaQHT72MnarzgRq659D
         5C6SbN49wsl0yrvPRlERsv6JNcl/PJTtaYmZrj+PxHR/TCT9Kk0miwn5+yJx3fBKxu1e
         FSUaYXvtpg5W8hzOezyEhT1F9VUIYVk0fGHOwaupvx3KBTTYXZP6h/yFpqEA9IOb8GpL
         hZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MPPttOQ4y+lHOJw1rgFNqb/3DdTQmk+sv8Yecz46jBg=;
        b=nUZmEbWr2uC0eovvUi9TJ01fDGLPyMHzKyElhYZQ8qVhtKe2RplGC7p+je4n3W+7aQ
         IIYw/1ZNm3vYbwCJwSg3KrN8sXpqesgKZqnWOYA/4hWZtEieZ2b963FBWPrPMSg9KMgs
         /NHu7zVNFf6BdyOdi9HHqgdoygt8gXMtZhevwLvmwj5bGcv73MMAqahPnl8IwoN2Cu6L
         YmMXfAlshm8MgDcpZNzwA2zj2F2UFCJ6QkQvIiZLMRoBUGKuImnURt1IRGzO4/lv0Ipe
         hI94HQ5POy0c3EY8gsdui21P1NL13lFp0avYkhC3TCFDFtcKm2P0JUa58oNlS//0uvmq
         VbWw==
X-Gm-Message-State: AOAM530cxNyNvMCWWu57XQLxkQpTZSXAbxEoz71bYOaz/qk031kRsbux
        BPu9U05Pw0RcgNNnnZ8A+yLKUBk2ULI11g==
X-Google-Smtp-Source: ABdhPJy6YuACZoPzJN8OKrxMthaBnv7ji4nJWBX5SLHsI9WIIq3vhFYwqKi4U0d6sbSBRben1LmNKg==
X-Received: by 2002:a05:651c:321:: with SMTP id b1mr2038443ljp.67.1619166133727;
        Fri, 23 Apr 2021 01:22:13 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id x74sm484475lff.145.2021.04.23.01.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 01:22:13 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/3 net-next v3] net: ethernet: ixp4xx: Retire ancient phy retrieveal
Date:   Fri, 23 Apr 2021 10:22:07 +0200
Message-Id: <20210423082208.2244803-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210423082208.2244803-1-linus.walleij@linaro.org>
References: <20210423082208.2244803-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver was using a really dated way of obtaining the
phy by printing a string and using it with phy_connect().
Switch to using more reasonable modern interfaces.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v3:
- New patch
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 9defaa21a1a9..4df2686ac5b8 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1360,7 +1360,6 @@ static const struct net_device_ops ixp4xx_netdev_ops = {
 
 static int ixp4xx_eth_probe(struct platform_device *pdev)
 {
-	char phy_id[MII_BUS_ID_SIZE + 3];
 	struct phy_device *phydev = NULL;
 	struct device *dev = &pdev->dev;
 	struct eth_plat_info *plat;
@@ -1462,14 +1461,15 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	__raw_writel(DEFAULT_CORE_CNTRL, &port->regs->core_control);
 	udelay(50);
 
-	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
-		mdio_bus->id, plat->phy);
-	phydev = phy_connect(ndev, phy_id, &ixp4xx_adjust_link,
-			     PHY_INTERFACE_MODE_MII);
+	phydev = mdiobus_get_phy(mdio_bus, plat->phy);
 	if (IS_ERR(phydev)) {
 		err = PTR_ERR(phydev);
 		goto err_free_mem;
 	}
+	err = phy_connect_direct(ndev, phydev, ixp4xx_adjust_link,
+				 PHY_INTERFACE_MODE_MII);
+	if (err)
+		goto err_free_mem;
 
 	phydev->irq = PHY_POLL;
 
-- 
2.29.2

