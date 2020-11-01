Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995352A1E0F
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgKAMxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbgKAMwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:43 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027F5C0617A6;
        Sun,  1 Nov 2020 04:52:43 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id l24so11347676edj.8;
        Sun, 01 Nov 2020 04:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PnJLOEQTKLqjGEvrG6MYX2BGzArZcrHWdrn4+Hna4UY=;
        b=hP+KxPtnoByVASH9YQCPOaJeBz9XrZ/1IlIF4fiH4c65HO5qyO4M3KIOMvhr3uDoBD
         UrasPa0G/0Dzjo6Jr9lbzTVKLflQaSAELz9S6qq1bsYDL1IJ1Ubj7aECXiyWEVp/XcN6
         yN6jK92tFRfhc/aiKGSZxxfMgK01ykchhrnKLyPv+F+zc+Gelj5qqucIP3BHAKLuSnYa
         SoyvAEu4EzDtOrkFBlRb9LKh2o0EHuhUgeu76xhAwjfIh0urC5Vk5qWURk98VfujVHWX
         i/7rWTVSYYhs3x1qLy7NvxcDfu7pCKATgak8h/Gl79B9swsxrKyJNh1pbW34tRGxqm+7
         qUdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PnJLOEQTKLqjGEvrG6MYX2BGzArZcrHWdrn4+Hna4UY=;
        b=esJA7pAB8YhxCjyaYDoeSRuuoEH9EPMW0mqMvnEAHRaIaj0ZJHLqH0WBQ535hqfvx0
         vvVg77PK32i0VGthlN7ybv8HR5Q73XWCPWCL7wzeUg1A4wS944CFLsgOpW3ugShhrszy
         pAhNMEFH7zPl6wPwPJcwrXi0CQvgcShxh7c/rQ5/USUrcKeYr/6aCfOZMOw3g/XHrT7C
         Fm7y4gfPkeGx4VtvL836TSALSJFmiumI3FlZbYeTWIjfBa2RBwDbkrw6YRWD1Y0C95Ox
         0kaQXrYUOokKLc2mzCLVJSbSc4Yc5e8nmqUh8MFSo3sNPK3ZJ2S40LHK7tCpiKL3dGw/
         Zp3w==
X-Gm-Message-State: AOAM533j00A5aZhzfzL+CendzxrQNH+oRsobFQUSSc2+7ddpwL70odpY
        /NVEknEyfFwyj7Erz6+GzBw=
X-Google-Smtp-Source: ABdhPJzuqoy+YhpsNz73akt0iHz7Msd65Xf0JyT5sXK9snKRR4vTS0AHwXRp4AdumPPy7TRsF6qnBg==
X-Received: by 2002:aa7:d843:: with SMTP id f3mr12173304eds.354.1604235161716;
        Sun, 01 Nov 2020 04:52:41 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:41 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 16/19] net: phy: davicom: remove the use of .ack_interrupt()
Date:   Sun,  1 Nov 2020 14:51:11 +0200
Message-Id: <20201101125114.1316879-17-ciorneiioana@gmail.com>
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

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 drivers/net/phy/davicom.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/davicom.c b/drivers/net/phy/davicom.c
index bfa6c835070f..a3b3842c67e5 100644
--- a/drivers/net/phy/davicom.c
+++ b/drivers/net/phy/davicom.c
@@ -61,24 +61,40 @@ MODULE_AUTHOR("Andy Fleming");
 MODULE_LICENSE("GPL");
 
 
+static int dm9161_ack_interrupt(struct phy_device *phydev)
+{
+	int err = phy_read(phydev, MII_DM9161_INTR);
+
+	return (err < 0) ? err : 0;
+}
+
 #define DM9161_DELAY 1
 static int dm9161_config_intr(struct phy_device *phydev)
 {
-	int temp;
+	int temp, err;
 
 	temp = phy_read(phydev, MII_DM9161_INTR);
 
 	if (temp < 0)
 		return temp;
 
-	if (PHY_INTERRUPT_ENABLED == phydev->interrupts)
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = dm9161_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		temp &= ~(MII_DM9161_INTR_STOP);
-	else
+		err = phy_write(phydev, MII_DM9161_INTR, temp);
+	} else {
 		temp |= MII_DM9161_INTR_STOP;
+		err = phy_write(phydev, MII_DM9161_INTR, temp);
+		if (err)
+			return err;
 
-	temp = phy_write(phydev, MII_DM9161_INTR, temp);
+		err = dm9161_ack_interrupt(phydev);
+	}
 
-	return temp;
+	return err;
 }
 
 static irqreturn_t dm9161_handle_interrupt(struct phy_device *phydev)
@@ -154,13 +170,6 @@ static int dm9161_config_init(struct phy_device *phydev)
 	return phy_write(phydev, MII_BMCR, BMCR_ANENABLE);
 }
 
-static int dm9161_ack_interrupt(struct phy_device *phydev)
-{
-	int err = phy_read(phydev, MII_DM9161_INTR);
-
-	return (err < 0) ? err : 0;
-}
-
 static struct phy_driver dm91xx_driver[] = {
 {
 	.phy_id		= 0x0181b880,
@@ -169,7 +178,6 @@ static struct phy_driver dm91xx_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.config_init	= dm9161_config_init,
 	.config_aneg	= dm9161_config_aneg,
-	.ack_interrupt	= dm9161_ack_interrupt,
 	.config_intr	= dm9161_config_intr,
 	.handle_interrupt = dm9161_handle_interrupt,
 }, {
@@ -179,7 +187,6 @@ static struct phy_driver dm91xx_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.config_init	= dm9161_config_init,
 	.config_aneg	= dm9161_config_aneg,
-	.ack_interrupt	= dm9161_ack_interrupt,
 	.config_intr	= dm9161_config_intr,
 	.handle_interrupt = dm9161_handle_interrupt,
 }, {
@@ -189,7 +196,6 @@ static struct phy_driver dm91xx_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.config_init	= dm9161_config_init,
 	.config_aneg	= dm9161_config_aneg,
-	.ack_interrupt	= dm9161_ack_interrupt,
 	.config_intr	= dm9161_config_intr,
 	.handle_interrupt = dm9161_handle_interrupt,
 }, {
@@ -197,7 +203,6 @@ static struct phy_driver dm91xx_driver[] = {
 	.name		= "Davicom DM9131",
 	.phy_id_mask	= 0x0ffffff0,
 	/* PHY_BASIC_FEATURES */
-	.ack_interrupt	= dm9161_ack_interrupt,
 	.config_intr	= dm9161_config_intr,
 	.handle_interrupt = dm9161_handle_interrupt,
 } };
-- 
2.28.0

