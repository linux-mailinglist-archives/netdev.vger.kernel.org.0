Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A1B2B0943
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgKLP7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728911AbgKLP6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:36 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2ECC0613D6;
        Thu, 12 Nov 2020 07:58:35 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id t11so6808221edj.13;
        Thu, 12 Nov 2020 07:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oGBDzVq5PZR4Pbyh6TLReVGAkLMraG8njIqpD/GjZy4=;
        b=gyU2ZCluc6uOODrLzfErFIjhrVH3ygBhzm4oeVFQgYBNWEbKb7/gPnbW/blK4V6TiP
         O0+DtQU496ra3TUjgPJsvGnKrpBxsO8Az1ezzaUmjTr9pG9i8AvfnERzpX/diI5+iqA4
         Dz55bbj1eDCry5cQM4BiJLpBYCPr+BsqyRj6EB2g8r7CCYt/AMrivnVG5WSjTOPyy/sp
         c8md/XImr/R8XgiAQ1okrgDIpGwxdbgvXc12nryhyBcAeJd/FYub0lznDeGBnS2fYJ4/
         eMAEOHGhKi3E+Ph/cGF82UqGdnEjs4Pvk6YcdTiFiQLRj3wUevFY71dl/l60i72PKoOA
         4eUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oGBDzVq5PZR4Pbyh6TLReVGAkLMraG8njIqpD/GjZy4=;
        b=aujkOP+OeOPGV2vfPvo/oFCvfKmNKUfX/9kT3+HRlnHCigELodjoBnx3FuwzCC3Rtc
         jkyQ0JHxmkwx7N5hdWO6Z/4YMhx+hVj4XAnsjQy24Y9wSPW93RR4jjwdZvOCRs2vn/JI
         eUttLQvfrkTsJzzarxhGJhOjCEPpJd7q9gt70VkDC5CmznNZtWch8LmCTONraRMleXYL
         UbeNG+2LCk9SzCvvajcQ3wm7+CDytLaxAqzs10dYE3/gx4DjJvGN6tn1teM1hxSKyGYB
         CCCYNGV1kFnFpHJnKXLx88sTt2ysNctNy0lVCZ0f0+492r+5HWWmDx/oDu7W8MxfnLdG
         h/yQ==
X-Gm-Message-State: AOAM532bRwms7V4oOAbFTC+S9Ttj+xwGquO+YZEvj3IS1dhwPNzTYgyV
        aCEZfFcuhXz771tHrbTp6S4=
X-Google-Smtp-Source: ABdhPJzM0/ak9DmUQkzyI1gbrsZmVlX5qinZTqAnCaPh2nyP5OgRmcKkN0HOYhMw/74W1iFDzYCL+g==
X-Received: by 2002:aa7:c716:: with SMTP id i22mr459791edq.94.1605196714198;
        Thu, 12 Nov 2020 07:58:34 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:33 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andre Edich <andre.edich@microchip.com>,
        Marco Felsch <m.felsch@pengutronix.de>
Subject: [PATCH net-next 14/18] net: phy: smsc: remove the use of .ack_interrupt()
Date:   Thu, 12 Nov 2020 17:55:09 +0200
Message-Id: <20201112155513.411604-15-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201112155513.411604-1-ciorneiioana@gmail.com>
References: <20201112155513.411604-1-ciorneiioana@gmail.com>
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

Cc: Andre Edich <andre.edich@microchip.com>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/smsc.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 8d9eb1b3d2df..bc05a4a9d10a 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -48,6 +48,13 @@ struct smsc_phy_priv {
 	struct clk *refclk;
 };
 
+static int smsc_phy_ack_interrupt(struct phy_device *phydev)
+{
+	int rc = phy_read(phydev, MII_LAN83C185_ISF);
+
+	return rc < 0 ? rc : 0;
+}
+
 static int smsc_phy_config_intr(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
@@ -55,19 +62,21 @@ static int smsc_phy_config_intr(struct phy_device *phydev)
 	int rc;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		rc = smsc_phy_ack_interrupt(phydev);
+		if (rc)
+			return rc;
+
 		intmask = MII_LAN83C185_ISF_INT4 | MII_LAN83C185_ISF_INT6;
 		if (priv->energy_enable)
 			intmask |= MII_LAN83C185_ISF_INT7;
-	}
-
-	rc = phy_write(phydev, MII_LAN83C185_IM, intmask);
-
-	return rc < 0 ? rc : 0;
-}
+		rc = phy_write(phydev, MII_LAN83C185_IM, intmask);
+	} else {
+		rc = phy_write(phydev, MII_LAN83C185_IM, intmask);
+		if (rc)
+			return rc;
 
-static int smsc_phy_ack_interrupt(struct phy_device *phydev)
-{
-	int rc = phy_read (phydev, MII_LAN83C185_ISF);
+		rc = smsc_phy_ack_interrupt(phydev);
+	}
 
 	return rc < 0 ? rc : 0;
 }
@@ -336,7 +345,6 @@ static struct phy_driver smsc_phy_driver[] = {
 	.soft_reset	= smsc_phy_reset,
 
 	/* IRQ related */
-	.ack_interrupt	= smsc_phy_ack_interrupt,
 	.config_intr	= smsc_phy_config_intr,
 	.handle_interrupt = smsc_phy_handle_interrupt,
 
@@ -356,7 +364,6 @@ static struct phy_driver smsc_phy_driver[] = {
 	.soft_reset	= smsc_phy_reset,
 
 	/* IRQ related */
-	.ack_interrupt	= smsc_phy_ack_interrupt,
 	.config_intr	= smsc_phy_config_intr,
 	.handle_interrupt = smsc_phy_handle_interrupt,
 
@@ -386,7 +393,6 @@ static struct phy_driver smsc_phy_driver[] = {
 	.config_aneg	= lan87xx_config_aneg,
 
 	/* IRQ related */
-	.ack_interrupt	= smsc_phy_ack_interrupt,
 	.config_intr	= smsc_phy_config_intr,
 	.handle_interrupt = smsc_phy_handle_interrupt,
 
@@ -410,7 +416,6 @@ static struct phy_driver smsc_phy_driver[] = {
 	.config_init	= lan911x_config_init,
 
 	/* IRQ related */
-	.ack_interrupt	= smsc_phy_ack_interrupt,
 	.config_intr	= smsc_phy_config_intr,
 	.handle_interrupt = smsc_phy_handle_interrupt,
 
@@ -436,7 +441,6 @@ static struct phy_driver smsc_phy_driver[] = {
 	.config_aneg	= lan87xx_config_aneg_ext,
 
 	/* IRQ related */
-	.ack_interrupt	= smsc_phy_ack_interrupt,
 	.config_intr	= smsc_phy_config_intr,
 	.handle_interrupt = smsc_phy_handle_interrupt,
 
@@ -463,7 +467,6 @@ static struct phy_driver smsc_phy_driver[] = {
 	.soft_reset	= smsc_phy_reset,
 
 	/* IRQ related */
-	.ack_interrupt	= smsc_phy_ack_interrupt,
 	.config_intr	= smsc_phy_config_intr,
 	.handle_interrupt = smsc_phy_handle_interrupt,
 
-- 
2.28.0

