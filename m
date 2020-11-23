Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358DB2C0F11
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389733AbgKWPjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389671AbgKWPi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:38:59 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265C0C061A4D;
        Mon, 23 Nov 2020 07:38:59 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id d18so17557736edt.7;
        Mon, 23 Nov 2020 07:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wwB73Rsm8FBWnbvpf/xQy1++g6Ol49vkh6A+mPeRjjk=;
        b=UIu2R2bhoRMdWFafFO5W99F8jopHui1zsDFYd93/V6h76c7q0AJ8ej6v/8gdBlSGoo
         mu42ZDwok/TqDqNQenFc63I81In9EJMs6JZUAmaNZxWKLHQR8qUsQcs8xhXtOFl5446L
         lvtiCrOHLbUVZ6E19S7T4/zGEnRjh+7b3ha4PK2oGFLKFO/9bIL2yvzJUh4KWFGYLwsI
         noNp9/I1WxnFuxuqQg2LoNH4N+7tfggy7jy74s7w8SouoxBKA5bAuyb8o2SHnJiy2T1a
         aQB8jtc2TdbWkJh11i/ojBw5EvPs5FrKiMkq/tO7lvEcXwd0e8IqmtCSPMdoyoNEaivk
         0R9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wwB73Rsm8FBWnbvpf/xQy1++g6Ol49vkh6A+mPeRjjk=;
        b=YVbBV9VutNNHk/SkokmVcAVtTCQlO7mtNJdzmGHREF17YWigZDLfYOnDu4BxO23X3s
         5pQKQOfqjVYyioO2akYhzbHmRiKQsSuzapz/ejsyO9z7d0urLwuNBpy9VWVbN21T6Com
         sc0totwU6u0HEZ9sBgDxvEb44jq28Ys/GcIHArXw51kaUNcwdLKvEZd0flmyW4Z8+0v4
         MJNpMmI/t/C/IzhpBGm54bbAIA55NPRayO8A2I8XoyfcWA420LHKc1TE32W1TTB0y/bP
         XTJ+xclvWKhAb3cpOozzlFQm2enqtY4eriH+IYGt71lBx09vJgTc56i3/UDlXz246xvo
         h71Q==
X-Gm-Message-State: AOAM530CM3uO/+MoNGV1hoHBZqsjs7RXWAyI0X7HIY8Z0IGbQjFCAp8y
        QDu0RwLN8ZivnEmyx93C2Rk=
X-Google-Smtp-Source: ABdhPJxoYVXS0T7HRmcIVMTPwHiBL0LaA4PspY0HyGSihwZIUnZHXKKZupkR41d7M1qcxHjxjCEsAw==
X-Received: by 2002:aa7:d711:: with SMTP id t17mr47974769edq.83.1606145937829;
        Mon, 23 Nov 2020 07:38:57 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c6sm4800126edy.62.2020.11.23.07.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:38:57 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next 12/15] net: phy: ti: remove the use of .ack_interrupt()
Date:   Mon, 23 Nov 2020 17:38:14 +0200
Message-Id: <20201123153817.1616814-13-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123153817.1616814-1-ciorneiioana@gmail.com>
References: <20201123153817.1616814-1-ciorneiioana@gmail.com>
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

Cc: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/dp83640.c   | 11 +++++++++--
 drivers/net/phy/dp83822.c   | 17 -----------------
 drivers/net/phy/dp83848.c   | 14 ++++++++++++--
 drivers/net/phy/dp83867.c   | 19 ++++++++++++++-----
 drivers/net/phy/dp83869.c   | 17 +++++++++++++----
 drivers/net/phy/dp83tc811.c |  9 ++++++++-
 6 files changed, 56 insertions(+), 31 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 89577f1d3576..f1001ae1df51 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -1159,6 +1159,10 @@ static int dp83640_config_intr(struct phy_device *phydev)
 	int err;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = dp83640_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		misr = phy_read(phydev, MII_DP83640_MISR);
 		if (misr < 0)
 			return misr;
@@ -1197,7 +1201,11 @@ static int dp83640_config_intr(struct phy_device *phydev)
 			MII_DP83640_MISR_DUP_INT_EN |
 			MII_DP83640_MISR_SPD_INT_EN |
 			MII_DP83640_MISR_LINK_INT_EN);
-		return phy_write(phydev, MII_DP83640_MISR, misr);
+		err = phy_write(phydev, MII_DP83640_MISR, misr);
+		if (err)
+			return err;
+
+		return dp83640_ack_interrupt(phydev);
 	}
 }
 
@@ -1541,7 +1549,6 @@ static struct phy_driver dp83640_driver = {
 	.remove		= dp83640_remove,
 	.soft_reset	= dp83640_soft_reset,
 	.config_init	= dp83640_config_init,
-	.ack_interrupt  = dp83640_ack_interrupt,
 	.config_intr    = dp83640_config_intr,
 	.handle_interrupt = dp83640_handle_interrupt,
 };
diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index bb512ac3f533..fff371ca1086 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -119,21 +119,6 @@ struct dp83822_private {
 	u16 fx_sd_enable;
 };
 
-static int dp83822_ack_interrupt(struct phy_device *phydev)
-{
-	int err;
-
-	err = phy_read(phydev, MII_DP83822_MISR1);
-	if (err < 0)
-		return err;
-
-	err = phy_read(phydev, MII_DP83822_MISR2);
-	if (err < 0)
-		return err;
-
-	return 0;
-}
-
 static int dp83822_set_wol(struct phy_device *phydev,
 			   struct ethtool_wolinfo *wol)
 {
@@ -609,7 +594,6 @@ static int dp83822_resume(struct phy_device *phydev)
 		.read_status	= dp83822_read_status,		\
 		.get_wol = dp83822_get_wol,			\
 		.set_wol = dp83822_set_wol,			\
-		.ack_interrupt = dp83822_ack_interrupt,		\
 		.config_intr = dp83822_config_intr,		\
 		.handle_interrupt = dp83822_handle_interrupt,	\
 		.suspend = dp83822_suspend,			\
@@ -625,7 +609,6 @@ static int dp83822_resume(struct phy_device *phydev)
 		.config_init	= dp8382x_config_init,		\
 		.get_wol = dp83822_get_wol,			\
 		.set_wol = dp83822_set_wol,			\
-		.ack_interrupt = dp83822_ack_interrupt,		\
 		.config_intr = dp83822_config_intr,		\
 		.handle_interrupt = dp83822_handle_interrupt,	\
 		.suspend = dp83822_suspend,			\
diff --git a/drivers/net/phy/dp83848.c b/drivers/net/phy/dp83848.c
index b707a9b27847..937061acfc61 100644
--- a/drivers/net/phy/dp83848.c
+++ b/drivers/net/phy/dp83848.c
@@ -67,17 +67,28 @@ static int dp83848_config_intr(struct phy_device *phydev)
 		return control;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		ret = dp83848_ack_interrupt(phydev);
+		if (ret)
+			return ret;
+
 		control |= DP83848_MICR_INT_OE;
 		control |= DP83848_MICR_INTEN;
 
 		ret = phy_write(phydev, DP83848_MISR, DP83848_INT_EN_MASK);
 		if (ret < 0)
 			return ret;
+
+		ret = phy_write(phydev, DP83848_MICR, control);
 	} else {
 		control &= ~DP83848_MICR_INTEN;
+		ret = phy_write(phydev, DP83848_MICR, control);
+		if (ret)
+			return ret;
+
+		ret = dp83848_ack_interrupt(phydev);
 	}
 
-	return phy_write(phydev, DP83848_MICR, control);
+	return ret;
 }
 
 static irqreturn_t dp83848_handle_interrupt(struct phy_device *phydev)
@@ -134,7 +145,6 @@ MODULE_DEVICE_TABLE(mdio, dp83848_tbl);
 		.resume		= genphy_resume,		\
 								\
 		/* IRQ related */				\
-		.ack_interrupt	= dp83848_ack_interrupt,	\
 		.config_intr	= dp83848_config_intr,		\
 		.handle_interrupt = dp83848_handle_interrupt,	\
 	}
diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index aba4e4c1f75c..9bd9a5c0b1db 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -288,9 +288,13 @@ static void dp83867_get_wol(struct phy_device *phydev,
 
 static int dp83867_config_intr(struct phy_device *phydev)
 {
-	int micr_status;
+	int micr_status, err;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = dp83867_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		micr_status = phy_read(phydev, MII_DP83867_MICR);
 		if (micr_status < 0)
 			return micr_status;
@@ -303,11 +307,17 @@ static int dp83867_config_intr(struct phy_device *phydev)
 			MII_DP83867_MICR_DUP_MODE_CHNG_INT_EN |
 			MII_DP83867_MICR_SLEEP_MODE_CHNG_INT_EN);
 
-		return phy_write(phydev, MII_DP83867_MICR, micr_status);
+		err = phy_write(phydev, MII_DP83867_MICR, micr_status);
+	} else {
+		micr_status = 0x0;
+		err = phy_write(phydev, MII_DP83867_MICR, micr_status);
+		if (err)
+			return err;
+
+		err = dp83867_ack_interrupt(phydev);
 	}
 
-	micr_status = 0x0;
-	return phy_write(phydev, MII_DP83867_MICR, micr_status);
+	return err;
 }
 
 static irqreturn_t dp83867_handle_interrupt(struct phy_device *phydev)
@@ -849,7 +859,6 @@ static struct phy_driver dp83867_driver[] = {
 		.set_wol	= dp83867_set_wol,
 
 		/* IRQ related */
-		.ack_interrupt	= dp83867_ack_interrupt,
 		.config_intr	= dp83867_config_intr,
 		.handle_interrupt = dp83867_handle_interrupt,
 
diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 487d1b8beec5..b30bc142d82e 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -186,9 +186,13 @@ static int dp83869_ack_interrupt(struct phy_device *phydev)
 
 static int dp83869_config_intr(struct phy_device *phydev)
 {
-	int micr_status = 0;
+	int micr_status = 0, err;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = dp83869_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		micr_status = phy_read(phydev, MII_DP83869_MICR);
 		if (micr_status < 0)
 			return micr_status;
@@ -201,10 +205,16 @@ static int dp83869_config_intr(struct phy_device *phydev)
 			MII_DP83869_MICR_DUP_MODE_CHNG_INT_EN |
 			MII_DP83869_MICR_SLEEP_MODE_CHNG_INT_EN);
 
-		return phy_write(phydev, MII_DP83869_MICR, micr_status);
+		err = phy_write(phydev, MII_DP83869_MICR, micr_status);
+	} else {
+		err = phy_write(phydev, MII_DP83869_MICR, micr_status);
+		if (err)
+			return err;
+
+		err = dp83869_ack_interrupt(phydev);
 	}
 
-	return phy_write(phydev, MII_DP83869_MICR, micr_status);
+	return err;
 }
 
 static irqreturn_t dp83869_handle_interrupt(struct phy_device *phydev)
@@ -874,7 +884,6 @@ static struct phy_driver dp83869_driver[] = {
 		.soft_reset	= dp83869_phy_reset,
 
 		/* IRQ related */
-		.ack_interrupt	= dp83869_ack_interrupt,
 		.config_intr	= dp83869_config_intr,
 		.handle_interrupt = dp83869_handle_interrupt,
 		.read_status	= dp83869_read_status,
diff --git a/drivers/net/phy/dp83tc811.c b/drivers/net/phy/dp83tc811.c
index a93c64ac76a3..688fadffb249 100644
--- a/drivers/net/phy/dp83tc811.c
+++ b/drivers/net/phy/dp83tc811.c
@@ -197,6 +197,10 @@ static int dp83811_config_intr(struct phy_device *phydev)
 	int misr_status, err;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = dp83811_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		misr_status = phy_read(phydev, MII_DP83811_INT_STAT1);
 		if (misr_status < 0)
 			return misr_status;
@@ -249,6 +253,10 @@ static int dp83811_config_intr(struct phy_device *phydev)
 			return err;
 
 		err = phy_write(phydev, MII_DP83811_INT_STAT3, 0);
+		if (err < 0)
+			return err;
+
+		err = dp83811_ack_interrupt(phydev);
 	}
 
 	return err;
@@ -386,7 +394,6 @@ static struct phy_driver dp83811_driver[] = {
 		.soft_reset = dp83811_phy_reset,
 		.get_wol = dp83811_get_wol,
 		.set_wol = dp83811_set_wol,
-		.ack_interrupt = dp83811_ack_interrupt,
 		.config_intr = dp83811_config_intr,
 		.handle_interrupt = dp83811_handle_interrupt,
 		.suspend = dp83811_suspend,
-- 
2.28.0

