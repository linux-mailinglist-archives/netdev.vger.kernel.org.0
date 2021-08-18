Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE763F03BA
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbhHRMa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236732AbhHRMaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 08:30:22 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54734C0613A4
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 05:29:47 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id q6so3256663wrv.6
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 05:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=41vzQz17yY023l5WeMyfnRBC0yKCfFsWSJLJ4kmuWB0=;
        b=s5SBUVqh/uAwzJzYu2B+6dPatfUFRtDv3zRhWwNrPRYlxqD3DQ+isw2GBFXfhtzc1b
         K+VCxlWSha/+1CHlQR0WclWl8zGOv0dmMtbvUaGI30HmQZfZjSdvYiAAFBJMmqOBQqsN
         qzEhiUjgaQeha+WDZuqjNy98UtS13KtRsNUrXy4BJvut/MAbBoA5lEEfT/HY/uEW2S+V
         S60q6zmnHq/7cRec2F9uk617Qt5DJwxuNh6+iwwighG58JgLHlctDRxXJ25bwmipggKL
         HnZwKc70E5pjAU0e3G1aONSPm6S+74m/yuTfHN4aFkVtG6SgBQNAJcPT6hvmiWku1uw+
         rxHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=41vzQz17yY023l5WeMyfnRBC0yKCfFsWSJLJ4kmuWB0=;
        b=pDW9Hizg9PFvuIFc5777U9yWFvM/4QYYO1CI1p8C3Qz9JsI3Z62Nw/9KYMtSGUdsWs
         jJxEBoJmE6LDxMbIIcSgkmLyjKXPWl7bpkw9+Nl+zQFJMKEogkwZOQ7BgU+T0VUoPQ+5
         JVPmg5Xq2XN6Mof7P+Qc3/yRqFDMxsSnUQMIaGenoimLePfsRuwOZe6NLKw9mM4G302z
         2yw7KkPhS4pzE2vn/rODEWm6YI6lBUoHlYoWZZ/27gfSjqxVq9lUeXgUq1wZVDBvC5MF
         td7UqcYmcsg17YevtHAWzIBUcdgfsvdjlD4A99oPiSgG3ZIPfkztT4o5T2lpv/V7Zqsh
         gS/Q==
X-Gm-Message-State: AOAM530CLtGUAasl95MxBEFRqFjPmy5x1WnqDBDL+HPL8623BHmny+xy
        ONDBEC9KGH5htK4z2q0t2OSKQA==
X-Google-Smtp-Source: ABdhPJzNpUqiYkdXgLZsBcbRHUna1WJozPTEv1vNoz2fGDtHSZCDot/kqH7XAovpj/fLeBbCNXFJHQ==
X-Received: by 2002:a5d:6349:: with SMTP id b9mr10263347wrw.341.1629289785972;
        Wed, 18 Aug 2021 05:29:45 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2el0lv6sxxeorz8a81-pd01.res.v6.highway.a1.net. [2001:871:23a:b9:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id u16sm5554869wmc.41.2021.08.18.05.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 05:29:45 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 2/2] net: phy: gmii2rgmii: Support PHY loopback
Date:   Wed, 18 Aug 2021 14:27:36 +0200
Message-Id: <20210818122736.4877-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210818122736.4877-1-gerhard@engleder-embedded.com>
References: <20210818122736.4877-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Configure speed if loopback is used. read_status is not called for
loopback.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/phy/xilinx_gmii2rgmii.c | 46 ++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/xilinx_gmii2rgmii.c b/drivers/net/phy/xilinx_gmii2rgmii.c
index 151c2a3f0b3a..8dcb49ed1f3d 100644
--- a/drivers/net/phy/xilinx_gmii2rgmii.c
+++ b/drivers/net/phy/xilinx_gmii2rgmii.c
@@ -27,12 +27,28 @@ struct gmii2rgmii {
 	struct mdio_device *mdio;
 };
 
-static int xgmiitorgmii_read_status(struct phy_device *phydev)
+static void xgmiitorgmii_configure(struct gmii2rgmii *priv, int speed)
 {
-	struct gmii2rgmii *priv = mdiodev_get_drvdata(&phydev->mdio);
 	struct mii_bus *bus = priv->mdio->bus;
 	int addr = priv->mdio->addr;
-	u16 val = 0;
+	u16 val;
+
+	val = mdiobus_read(bus, addr, XILINX_GMII2RGMII_REG);
+	val &= ~XILINX_GMII2RGMII_SPEED_MASK;
+
+	if (speed == SPEED_1000)
+		val |= BMCR_SPEED1000;
+	else if (speed == SPEED_100)
+		val |= BMCR_SPEED100;
+	else
+		val |= BMCR_SPEED10;
+
+	mdiobus_write(bus, addr, XILINX_GMII2RGMII_REG, val);
+}
+
+static int xgmiitorgmii_read_status(struct phy_device *phydev)
+{
+	struct gmii2rgmii *priv = mdiodev_get_drvdata(&phydev->mdio);
 	int err;
 
 	if (priv->phy_drv->read_status)
@@ -42,17 +58,24 @@ static int xgmiitorgmii_read_status(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
-	val = mdiobus_read(bus, addr, XILINX_GMII2RGMII_REG);
-	val &= ~XILINX_GMII2RGMII_SPEED_MASK;
+	xgmiitorgmii_configure(priv, phydev->speed);
 
-	if (phydev->speed == SPEED_1000)
-		val |= BMCR_SPEED1000;
-	else if (phydev->speed == SPEED_100)
-		val |= BMCR_SPEED100;
+	return 0;
+}
+
+static int xgmiitorgmii_set_loopback(struct phy_device *phydev, bool enable)
+{
+	struct gmii2rgmii *priv = mdiodev_get_drvdata(&phydev->mdio);
+	int err;
+
+	if (priv->phy_drv->set_loopback)
+		err = priv->phy_drv->set_loopback(phydev, enable);
 	else
-		val |= BMCR_SPEED10;
+		err = genphy_loopback(phydev, enable);
+	if (err < 0)
+		return err;
 
-	mdiobus_write(bus, addr, XILINX_GMII2RGMII_REG, val);
+	xgmiitorgmii_configure(priv, phydev->speed);
 
 	return 0;
 }
@@ -90,6 +113,7 @@ static int xgmiitorgmii_probe(struct mdio_device *mdiodev)
 	memcpy(&priv->conv_phy_drv, priv->phy_dev->drv,
 	       sizeof(struct phy_driver));
 	priv->conv_phy_drv.read_status = xgmiitorgmii_read_status;
+	priv->conv_phy_drv.set_loopback = xgmiitorgmii_set_loopback;
 	mdiodev_set_drvdata(&priv->phy_dev->mdio, priv);
 	priv->phy_dev->drv = &priv->conv_phy_drv;
 
-- 
2.20.1

