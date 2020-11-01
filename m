Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550C22A1E19
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgKAMyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgKAMwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:40 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0C6C0617A6;
        Sun,  1 Nov 2020 04:52:38 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id p93so11345467edd.7;
        Sun, 01 Nov 2020 04:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zw4rs+DFNR/S9FRYseki/k8zysIGgEtxoZqA3FOwSMk=;
        b=eCfQjOpRxgLX+uM/hBjFB2J9e0irz1THD71LDjg9KUfh2A/1Gn6u0+1QxZlvBRTG67
         lzyPXqJIRpIAPWEjhrVQ/SmxWZt4NolQlfbBa+E898gYObkG3bVpNdEQTjW3MSBSdyS9
         H8wFrmWledDuMrBoq6PHITNUfBxBDgemrHj6AGeLNsEifwW3JHzi2XbI3YjF6DnXhU23
         f6iFbH/foDS1uIYy9irenDTzDj265XTYAZCHsMxP5mI0yaY9ghZQYrcx38qYF7NEno/d
         +RBY1ONxvbFBRPSJaP3z0Zv1EgaWKcORL2sMUwSOVhlNzCvX8OPmXigpIkc39O7uiGX1
         nY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zw4rs+DFNR/S9FRYseki/k8zysIGgEtxoZqA3FOwSMk=;
        b=CY85BOOaLBpiA9BTzIre55mZEzTeuCOsS1sI727UR4Z9w2ubna7bis++GhR7upRFjL
         8ALXP1bwW7najM3i7BheGWNjgQCyc3OZNBy1tAR/b9ftpYD9WRLESZz9x4OO0z8hrPGn
         kfiPpyrZIbQ91hrnebZmjagIxtJ/+q1GKVoaCwgxAMz2V2y0qOF3gm2lz/ScJdkdY1nr
         UkN6fWRsVgx8rVA+5E04+a7BT+Yk/n1C9cyheVTgqaIHOXT1v3zOd0LfeoZ4lOuwpnoD
         mTjXsHNzmxWSY5hjXySkMcB7sSW+fJwmW8bQ7cOuRAaxpYID9Pm/Pe7HmYFT/YaqU0m5
         wDdg==
X-Gm-Message-State: AOAM533/HiNFrtDnX6PZXAJBkNdd+sz6E7eJ4IRHb2rWBiVJs2K83RR+
        R/x8O5Y/dOHLWqp+6m5hmL4=
X-Google-Smtp-Source: ABdhPJwQShQbLCnBXavFMfeh+qYouFdGhjsc9piFLXudriKupWMzQCy7cbJ7oXb4zUEOgHm1z9CyWg==
X-Received: by 2002:aa7:dc09:: with SMTP id b9mr778405edu.285.1604235156751;
        Sun, 01 Nov 2020 04:52:36 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:36 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 12/19] net: phy: broadcom: remove use of ack_interrupt()
Date:   Sun,  1 Nov 2020 14:51:07 +0200
Message-Id: <20201101125114.1316879-13-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201101125114.1316879-1-ciorneiioana@gmail.com>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

In preparation of removing the .ack_interrupt() callback, we must replace
its occurrences (aka phy_clear_interrupt), from the 2 places where it is
called from (phy_enable_interrupts and phy_disable_interrupts), with
equivalent functionality.

This means that clearing interrupts now becomes something that the PHY
driver is responsible of doing, before enabling interrupts and after
clearing them. Make this driver follow the new contract.

Cc: Michael Walle <michael@walle.cc>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 drivers/net/phy/bcm-cygnus.c  |  1 -
 drivers/net/phy/bcm-phy-lib.c | 18 ++++++++++++++----
 drivers/net/phy/bcm54140.c    | 20 +++++++++++++++-----
 drivers/net/phy/bcm63xx.c     | 18 +++++++++++++-----
 drivers/net/phy/bcm87xx.c     | 34 +++++++++++++---------------------
 drivers/net/phy/broadcom.c    | 34 +++++++++++++---------------------
 6 files changed, 68 insertions(+), 57 deletions(-)

diff --git a/drivers/net/phy/bcm-cygnus.c b/drivers/net/phy/bcm-cygnus.c
index a236e0b8d04d..da8f7cb41b44 100644
--- a/drivers/net/phy/bcm-cygnus.c
+++ b/drivers/net/phy/bcm-cygnus.c
@@ -256,7 +256,6 @@ static struct phy_driver bcm_cygnus_phy_driver[] = {
 	.name          = "Broadcom Cygnus PHY",
 	/* PHY_GBIT_FEATURES */
 	.config_init   = bcm_cygnus_config_init,
-	.ack_interrupt = bcm_phy_ack_intr,
 	.config_intr   = bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.suspend       = genphy_suspend,
diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index c232fcfe0e20..53282a6d5928 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -181,18 +181,28 @@ EXPORT_SYMBOL_GPL(bcm_phy_ack_intr);
 
 int bcm_phy_config_intr(struct phy_device *phydev)
 {
-	int reg;
+	int reg, err;
 
 	reg = phy_read(phydev, MII_BCM54XX_ECR);
 	if (reg < 0)
 		return reg;
 
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = bcm_phy_ack_intr(phydev);
+		if (err)
+			return err;
+
 		reg &= ~MII_BCM54XX_ECR_IM;
-	else
+		err = phy_write(phydev, MII_BCM54XX_ECR, reg);
+	} else {
 		reg |= MII_BCM54XX_ECR_IM;
+		err = phy_write(phydev, MII_BCM54XX_ECR, reg);
+		if (err)
+			return err;
 
-	return phy_write(phydev, MII_BCM54XX_ECR, reg);
+		err = bcm_phy_ack_intr(phydev);
+	}
+	return err;
 }
 EXPORT_SYMBOL_GPL(bcm_phy_config_intr);
 
diff --git a/drivers/net/phy/bcm54140.c b/drivers/net/phy/bcm54140.c
index 36c899a88c5d..d8f3024860dc 100644
--- a/drivers/net/phy/bcm54140.c
+++ b/drivers/net/phy/bcm54140.c
@@ -681,7 +681,7 @@ static int bcm54140_config_intr(struct phy_device *phydev)
 		BCM54140_RDB_TOP_IMR_PORT0, BCM54140_RDB_TOP_IMR_PORT1,
 		BCM54140_RDB_TOP_IMR_PORT2, BCM54140_RDB_TOP_IMR_PORT3,
 	};
-	int reg;
+	int reg, err;
 
 	if (priv->port >= ARRAY_SIZE(port_to_imr_bit))
 		return -EINVAL;
@@ -690,12 +690,23 @@ static int bcm54140_config_intr(struct phy_device *phydev)
 	if (reg < 0)
 		return reg;
 
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = bcm54140_ack_intr(phydev);
+		if (err)
+			return err;
+
 		reg &= ~port_to_imr_bit[priv->port];
-	else
+		err = bcm54140_base_write_rdb(phydev, BCM54140_RDB_TOP_IMR, reg);
+	} else {
 		reg |= port_to_imr_bit[priv->port];
+		err = bcm54140_base_write_rdb(phydev, BCM54140_RDB_TOP_IMR, reg);
+		if (err)
+			return err;
+
+		err = bcm54140_ack_intr(phydev);
+	}
 
-	return bcm54140_base_write_rdb(phydev, BCM54140_RDB_TOP_IMR, reg);
+	return err;
 }
 
 static int bcm54140_get_downshift(struct phy_device *phydev, u8 *data)
@@ -850,7 +861,6 @@ static struct phy_driver bcm54140_drivers[] = {
 		.flags		= PHY_POLL_CABLE_TEST,
 		.features       = PHY_GBIT_FEATURES,
 		.config_init    = bcm54140_config_init,
-		.ack_interrupt  = bcm54140_ack_intr,
 		.handle_interrupt = bcm54140_handle_interrupt,
 		.config_intr    = bcm54140_config_intr,
 		.probe		= bcm54140_probe,
diff --git a/drivers/net/phy/bcm63xx.c b/drivers/net/phy/bcm63xx.c
index 818c853b6638..0eb33be824f1 100644
--- a/drivers/net/phy/bcm63xx.c
+++ b/drivers/net/phy/bcm63xx.c
@@ -25,12 +25,22 @@ static int bcm63xx_config_intr(struct phy_device *phydev)
 	if (reg < 0)
 		return reg;
 
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = bcm_phy_ack_intr(phydev);
+		if (err)
+			return err;
+
 		reg &= ~MII_BCM63XX_IR_GMASK;
-	else
+		err = phy_write(phydev, MII_BCM63XX_IR, reg);
+	} else {
 		reg |= MII_BCM63XX_IR_GMASK;
+		err = phy_write(phydev, MII_BCM63XX_IR, reg);
+		if (err)
+			return err;
+
+		err = bcm_phy_ack_intr(phydev);
+	}
 
-	err = phy_write(phydev, MII_BCM63XX_IR, reg);
 	return err;
 }
 
@@ -67,7 +77,6 @@ static struct phy_driver bcm63xx_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.flags		= PHY_IS_INTERNAL,
 	.config_init	= bcm63xx_config_init,
-	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm63xx_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
@@ -78,7 +87,6 @@ static struct phy_driver bcm63xx_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.flags		= PHY_IS_INTERNAL,
 	.config_init	= bcm63xx_config_init,
-	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm63xx_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 } };
diff --git a/drivers/net/phy/bcm87xx.c b/drivers/net/phy/bcm87xx.c
index f20cfb05ef04..4ac8fd190e9d 100644
--- a/drivers/net/phy/bcm87xx.c
+++ b/drivers/net/phy/bcm87xx.c
@@ -144,12 +144,22 @@ static int bcm87xx_config_intr(struct phy_device *phydev)
 	if (reg < 0)
 		return reg;
 
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = phy_read(phydev, BCM87XX_LASI_STATUS);
+		if (err)
+			return err;
+
 		reg |= 1;
-	else
+		err = phy_write(phydev, BCM87XX_LASI_CONTROL, reg);
+	} else {
 		reg &= ~1;
+		err = phy_write(phydev, BCM87XX_LASI_CONTROL, reg);
+		if (err)
+			return err;
+
+		err = phy_read(phydev, BCM87XX_LASI_STATUS);
+	}
 
-	err = phy_write(phydev, BCM87XX_LASI_CONTROL, reg);
 	return err;
 }
 
@@ -171,22 +181,6 @@ static irqreturn_t bcm87xx_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
-static int bcm87xx_ack_interrupt(struct phy_device *phydev)
-{
-	int reg;
-
-	/* Reading the LASI status clears it. */
-	reg = phy_read(phydev, BCM87XX_LASI_STATUS);
-
-	if (reg < 0) {
-		phydev_err(phydev,
-			   "Error: Read of BCM87XX_LASI_STATUS failed: %d\n",
-			   reg);
-		return 0;
-	}
-	return (reg & 1) != 0;
-}
-
 static int bcm8706_match_phy_device(struct phy_device *phydev)
 {
 	return phydev->c45_ids.device_ids[4] == PHY_ID_BCM8706;
@@ -206,7 +200,6 @@ static struct phy_driver bcm87xx_driver[] = {
 	.config_init	= bcm87xx_config_init,
 	.config_aneg	= bcm87xx_config_aneg,
 	.read_status	= bcm87xx_read_status,
-	.ack_interrupt	= bcm87xx_ack_interrupt,
 	.config_intr	= bcm87xx_config_intr,
 	.handle_interrupt = bcm87xx_handle_interrupt,
 	.match_phy_device = bcm8706_match_phy_device,
@@ -218,7 +211,6 @@ static struct phy_driver bcm87xx_driver[] = {
 	.config_init	= bcm87xx_config_init,
 	.config_aneg	= bcm87xx_config_aneg,
 	.read_status	= bcm87xx_read_status,
-	.ack_interrupt	= bcm87xx_ack_interrupt,
 	.config_intr	= bcm87xx_config_intr,
 	.handle_interrupt = bcm87xx_handle_interrupt,
 	.match_phy_device = bcm8727_match_phy_device,
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 8bcdb94ef2fc..8a4ec3222168 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -634,12 +634,22 @@ static int brcm_fet_config_intr(struct phy_device *phydev)
 	if (reg < 0)
 		return reg;
 
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = brcm_fet_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		reg &= ~MII_BRCM_FET_IR_MASK;
-	else
+		err = phy_write(phydev, MII_BRCM_FET_INTREG, reg);
+	} else {
 		reg |= MII_BRCM_FET_IR_MASK;
+		err = phy_write(phydev, MII_BRCM_FET_INTREG, reg);
+		if (err)
+			return err;
+
+		err = brcm_fet_ack_interrupt(phydev);
+	}
 
-	err = phy_write(phydev, MII_BRCM_FET_INTREG, reg);
 	return err;
 }
 
@@ -699,7 +709,6 @@ static struct phy_driver broadcom_drivers[] = {
 	.name		= "Broadcom BCM5411",
 	/* PHY_GBIT_FEATURES */
 	.config_init	= bcm54xx_config_init,
-	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
@@ -708,7 +717,6 @@ static struct phy_driver broadcom_drivers[] = {
 	.name		= "Broadcom BCM5421",
 	/* PHY_GBIT_FEATURES */
 	.config_init	= bcm54xx_config_init,
-	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
@@ -717,7 +725,6 @@ static struct phy_driver broadcom_drivers[] = {
 	.name		= "Broadcom BCM54210E",
 	/* PHY_GBIT_FEATURES */
 	.config_init	= bcm54xx_config_init,
-	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
@@ -726,7 +733,6 @@ static struct phy_driver broadcom_drivers[] = {
 	.name		= "Broadcom BCM5461",
 	/* PHY_GBIT_FEATURES */
 	.config_init	= bcm54xx_config_init,
-	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
@@ -735,7 +741,6 @@ static struct phy_driver broadcom_drivers[] = {
 	.name		= "Broadcom BCM54612E",
 	/* PHY_GBIT_FEATURES */
 	.config_init	= bcm54xx_config_init,
-	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
@@ -745,7 +750,6 @@ static struct phy_driver broadcom_drivers[] = {
 	/* PHY_GBIT_FEATURES */
 	.config_init	= bcm54xx_config_init,
 	.config_aneg	= bcm54616s_config_aneg,
-	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.read_status	= bcm54616s_read_status,
@@ -756,7 +760,6 @@ static struct phy_driver broadcom_drivers[] = {
 	.name		= "Broadcom BCM5464",
 	/* PHY_GBIT_FEATURES */
 	.config_init	= bcm54xx_config_init,
-	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.suspend	= genphy_suspend,
@@ -768,7 +771,6 @@ static struct phy_driver broadcom_drivers[] = {
 	/* PHY_GBIT_FEATURES */
 	.config_init	= bcm54xx_config_init,
 	.config_aneg	= bcm5481_config_aneg,
-	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
@@ -778,7 +780,6 @@ static struct phy_driver broadcom_drivers[] = {
 	/* PHY_GBIT_FEATURES */
 	.config_init    = bcm54xx_config_init,
 	.config_aneg    = bcm5481_config_aneg,
-	.ack_interrupt  = bcm_phy_ack_intr,
 	.config_intr    = bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.suspend	= genphy_suspend,
@@ -790,7 +791,6 @@ static struct phy_driver broadcom_drivers[] = {
 	/* PHY_GBIT_FEATURES */
 	.config_init    = bcm54811_config_init,
 	.config_aneg    = bcm5481_config_aneg,
-	.ack_interrupt  = bcm_phy_ack_intr,
 	.config_intr    = bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.suspend	= genphy_suspend,
@@ -802,7 +802,6 @@ static struct phy_driver broadcom_drivers[] = {
 	/* PHY_GBIT_FEATURES */
 	.config_init	= bcm5482_config_init,
 	.read_status	= bcm5482_read_status,
-	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
@@ -811,7 +810,6 @@ static struct phy_driver broadcom_drivers[] = {
 	.name		= "Broadcom BCM50610",
 	/* PHY_GBIT_FEATURES */
 	.config_init	= bcm54xx_config_init,
-	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
@@ -820,7 +818,6 @@ static struct phy_driver broadcom_drivers[] = {
 	.name		= "Broadcom BCM50610M",
 	/* PHY_GBIT_FEATURES */
 	.config_init	= bcm54xx_config_init,
-	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
@@ -829,7 +826,6 @@ static struct phy_driver broadcom_drivers[] = {
 	.name		= "Broadcom BCM57780",
 	/* PHY_GBIT_FEATURES */
 	.config_init	= bcm54xx_config_init,
-	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
@@ -838,7 +834,6 @@ static struct phy_driver broadcom_drivers[] = {
 	.name		= "Broadcom BCMAC131",
 	/* PHY_BASIC_FEATURES */
 	.config_init	= brcm_fet_config_init,
-	.ack_interrupt	= brcm_fet_ack_interrupt,
 	.config_intr	= brcm_fet_config_intr,
 	.handle_interrupt = brcm_fet_handle_interrupt,
 }, {
@@ -847,7 +842,6 @@ static struct phy_driver broadcom_drivers[] = {
 	.name		= "Broadcom BCM5241",
 	/* PHY_BASIC_FEATURES */
 	.config_init	= brcm_fet_config_init,
-	.ack_interrupt	= brcm_fet_ack_interrupt,
 	.config_intr	= brcm_fet_config_intr,
 	.handle_interrupt = brcm_fet_handle_interrupt,
 }, {
@@ -871,7 +865,6 @@ static struct phy_driver broadcom_drivers[] = {
 	.get_stats	= bcm53xx_phy_get_stats,
 	.probe		= bcm53xx_phy_probe,
 	.config_init	= bcm54xx_config_init,
-	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
@@ -880,7 +873,6 @@ static struct phy_driver broadcom_drivers[] = {
 	.name           = "Broadcom BCM89610",
 	/* PHY_GBIT_FEATURES */
 	.config_init    = bcm54xx_config_init,
-	.ack_interrupt  = bcm_phy_ack_intr,
 	.config_intr    = bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 } };
-- 
2.28.0

