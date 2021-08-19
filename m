Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C583F1A1B
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbhHSNNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239808AbhHSNNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:13:09 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234C1C061756
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:12:33 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id f9-20020a05600c1549b029025b0f5d8c6cso6779465wmg.4
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=41vzQz17yY023l5WeMyfnRBC0yKCfFsWSJLJ4kmuWB0=;
        b=uIvVIpuYUYl+rROb47a8U0dUIX8Q/zFRZJIti5ypNef2+0vn6pZR//V4FX+TpTKsRR
         lJWb0CqCIpzs2p4sX23CaD4LutIIvHQwKbllk1lk0m6AdcyDlPKscgU8cXm7DJpGkNKT
         XBwPWP+sE9Q+7F7aVH8SXpjHntybx9MtUFKCQE7Fxp8FPKfbexaL7ZPntE8cE65ZHq7o
         tyVdiCg9MjK6vfaBomdoxNfGQYX/FqKiIhbHgGfj0niLa4pcOXhS2GcnJc1gu6nFxS/v
         JgVzAGozJEbnzTitPNLKoyytxBPPB+DWsBm1NKXV6j8qRF/7XOygtZ9rMdoRyMfxLmXQ
         aY2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=41vzQz17yY023l5WeMyfnRBC0yKCfFsWSJLJ4kmuWB0=;
        b=CvX5i/v61J1l3dn5aFwIR07MSwucMU1Cy4MRQp/AVsTPD7MIWeyE9rebBdPZKLQTiw
         vVX1GXyYr+ZnEhI2Aeep4Gxv2vEGLh3p3lthrU1cW4QkhhwIVPxmPvs8d/M59YrWf3A+
         CNAt3CqYkN7eHnuXPH/1Px7mdtCbARTEOGKTnwhxAAr1afTxQKJbHtHY4ZdOMvfmT+Jp
         sboVcrDBK45x0syTLAO345o/p7sgcp9B/COAsgqig8yAv8FaN+04zoGT2ZGAw3JEqBlc
         ANHGLw4xNYNvhnHtf0jVPb7IuMp+fgtQQ+6iEBMpEx6M1CPFZRCtuE2xOSZWG7hvBlxC
         HiUA==
X-Gm-Message-State: AOAM532NBIaP2em6k6pZ8uhWbaoAELaO+3/Yw/cCuNTaXdUV7b1nHppd
        0Cvja53E7nQ5M9vL+5Vmxp+VYQ==
X-Google-Smtp-Source: ABdhPJx7p/Q2U170DrSuVWLkIvnIE64c+YJs/hMeV7g4n9/p7kNXo73GDAgkVyFuVjQiSgr5a50mNQ==
X-Received: by 2002:a05:600c:4ec8:: with SMTP id g8mr11921627wmq.34.1629378751790;
        Thu, 19 Aug 2021 06:12:31 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2el0lv6sxxeorz8a81-pd01.res.v6.highway.a1.net. [2001:871:23a:b9:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id d4sm3087088wrc.34.2021.08.19.06.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:12:31 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 3/3] net: phy: gmii2rgmii: Support PHY loopback
Date:   Thu, 19 Aug 2021 15:11:54 +0200
Message-Id: <20210819131154.6586-4-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210819131154.6586-1-gerhard@engleder-embedded.com>
References: <20210819131154.6586-1-gerhard@engleder-embedded.com>
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

