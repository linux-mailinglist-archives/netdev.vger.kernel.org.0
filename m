Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D6F36A3B1
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 02:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhDYAbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 20:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhDYAbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 20:31:34 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C545C06174A
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 17:30:54 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id s9so1897166ljj.6
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 17:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CV0QcDYHdPhLsI1lETsCV1+IJ2hDnY14lRZaKI1aN9E=;
        b=d0L9OC/TPCuJfnnobfJi+VELMSvhRacjPYxNeT19dJ5+i/kZ/4qxJkSbDGGjZl6eyO
         eZO9FOnP5kTGqE5/rb5MSdXo3DrODq7bHarnKF4+HvHC43KTsV6TfrdEuUJRgsD4vU89
         5h7BIuYn1R+sO1qmCRQ+3MtFjUpWE0z/q15ySm9f0MC3axVAkNbpWCkFIcm2T6Vo0mBu
         GinAWK89iD2+TPOliZCGSSKYK4QUzmA2wqeCcQ61SJ+G7G8IfLcxHdOaRiux/zYsKdfh
         EysuwkZNst3j6pifhqymazeoD1S0RabS2EXKMXnk5PdtSgwMvNZfAvaD02AcZbueA1bH
         4OeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CV0QcDYHdPhLsI1lETsCV1+IJ2hDnY14lRZaKI1aN9E=;
        b=O66HGYhs6Yu+sxpDHUSolCqVDSa2n16EhWSmHOcSmeEsAuyxEoOgX4d5TGeocOvPfe
         eObILKdLtjkqn6g4NM0hwXsgUYzNPOentraiBybDYrB0UyMOAATZqGogi7/KwAOuDNk0
         xGXB6WurOLckJI+Xmnv0eXmPcPAlxatDsWNwJXAifKn1es++A+FXs4OkAJaQED0oXoRb
         wsMWuHe3qbHGknwgKf18ZbUwKl0uJ9Buw4Ge4PuaEnt3vHFJ/v+Wkfb+bFZhUi9IsgaF
         U+teRYCh6FcvUDWIqU58VtiLdbX+iu4eNw7GvdItOBwiyc2qMbPROBjowwVzz/b10e/K
         OU3A==
X-Gm-Message-State: AOAM531LBMegvhZYdCjee0k/etjbru6U1ki+J82GkTla99nFEYbPR35E
        rqdsXiQmPvCbqGmajzeJxWn4q+LjXavDxw==
X-Google-Smtp-Source: ABdhPJwPFus9FRHHB7BODkJEP/L8g8I70+oe5HsF5HSmbdUQiWyjVEItrlNnIHBDtaTy+rmOCqViWQ==
X-Received: by 2002:a2e:8992:: with SMTP id c18mr7903358lji.74.1619310652505;
        Sat, 24 Apr 2021 17:30:52 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id t5sm950352lfe.211.2021.04.24.17.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Apr 2021 17:30:52 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/3 net-next v4] net: ethernet: ixp4xx: Retire ancient phy retrieveal
Date:   Sun, 25 Apr 2021 02:30:37 +0200
Message-Id: <20210425003038.2937498-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210425003038.2937498-1-linus.walleij@linaro.org>
References: <20210425003038.2937498-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver was using a really dated way of obtaining the
phy by printing a string and using it with phy_connect().
Switch to using more reasonable modern interfaces.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v3->v4:
- Collect Andrew's review tag
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

