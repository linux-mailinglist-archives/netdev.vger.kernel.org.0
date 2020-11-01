Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E9B2A1E08
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgKAMwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgKAMwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:47 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3EFC061A48;
        Sun,  1 Nov 2020 04:52:46 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id a15so2553785edy.1;
        Sun, 01 Nov 2020 04:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dzOityyH9yb/DG7iNqmb4hgLSIqdku/w0btbjwH1wPA=;
        b=NLYlOGJVtEIdbm0u/Romnf6yluLP0u9kd02EDX0jClbQ6pRlwsoSk14KoEWObw1JUB
         7M6omqVFCsbGFeVH5ik2T0tpei7F+xU8z1e3y0S/u7KGVAuA3wZVlOskQWjpriLnrspA
         FTbVHfWoa4GVVjkY7KdKu9MVIbQ3a8n4lwAT3FU7URt/iMTr7tPdooix7/eaqSI9+1Sh
         AkjvOY+xutm3jG9usUlrFxA5sUpadlCWnYbcAOxZ8SddJ+IUKjSNkbFz7VRh7vmlwggr
         EY/LxNGMNSF6/SlSXp4/9ujpSDeqbAkbNTyjI2kMeqhTSwIT2yWSFzfZHfYILgybfTRI
         vdfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dzOityyH9yb/DG7iNqmb4hgLSIqdku/w0btbjwH1wPA=;
        b=dKGK812R7LRlcMYMMQ1YQ1qvhevykeI1K8EkReZFjWyrJS2CFlCjTxNWSmZoqX2cT2
         0TNHBp/x7qjKLoe+cWrbvEvCx4Y8kml/BekyMbC3o/Pp56Qb/jRA99Zqrw20i9o6om+Z
         w6eHxUM3x9/dicMaYrVwt85o+2dMTOAh4sNr3Xnka+eqGo4QGRAMxNXhCNTYA6Zy+l1J
         b5ShXzk8M+NJPtJencrCPzvU4RJTxc6jA9vbdipBltJtrLOftdG06pZsIwCg/UlmiYvL
         36JU4Xvibe5AiGZnwXMLyvcznnalxewZXoaEooNevAgXTiJR1Y/PRT6yixfPjwsZn6ly
         bV5w==
X-Gm-Message-State: AOAM532OSWnNmPXgAaqpz31ntZzOrS055vENTzC35x49+DsAYKxjwWeD
        wpMAm/G9nYQCWf8S71P0TxM=
X-Google-Smtp-Source: ABdhPJzzICF1pd1IwRqYWI6Ozl/8575x5CgnH1zvea6J1yDcpuhvVWhTE6JXS8j4Q3Hh7IbB4k7lIA==
X-Received: by 2002:aa7:da13:: with SMTP id r19mr11781242eds.20.1604235165698;
        Sun, 01 Nov 2020 04:52:45 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:45 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Willy Liu <willy.liu@realtek.com>
Subject: [PATCH net-next v2 19/19] net: phy: realtek: remove the use of .ack_interrupt()
Date:   Sun,  1 Nov 2020 14:51:14 +0200
Message-Id: <20201101125114.1316879-20-ciorneiioana@gmail.com>
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

Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Willy Liu <willy.liu@realtek.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 drivers/net/phy/realtek.c | 68 ++++++++++++++++++++++++++++++---------
 1 file changed, 52 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 820b4e8ef23a..231b32118054 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -108,24 +108,45 @@ static int rtl8211f_ack_interrupt(struct phy_device *phydev)
 static int rtl8201_config_intr(struct phy_device *phydev)
 {
 	u16 val;
+	int err;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = rtl8201_ack_interrupt(phydev);
+		if (err)
+			return err;
 
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
 		val = BIT(13) | BIT(12) | BIT(11);
-	else
+		err = phy_write_paged(phydev, 0x7, RTL8201F_IER, val);
+	} else {
 		val = 0;
+		err = phy_write_paged(phydev, 0x7, RTL8201F_IER, val);
+		if (err)
+			return err;
+
+		err = rtl8201_ack_interrupt(phydev);
+	}
 
-	return phy_write_paged(phydev, 0x7, RTL8201F_IER, val);
+	return err;
 }
 
 static int rtl8211b_config_intr(struct phy_device *phydev)
 {
 	int err;
 
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = rtl821x_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		err = phy_write(phydev, RTL821x_INER,
 				RTL8211B_INER_INIT);
-	else
+	} else {
 		err = phy_write(phydev, RTL821x_INER, 0);
+		if (err)
+			return err;
+
+		err = rtl821x_ack_interrupt(phydev);
+	}
 
 	return err;
 }
@@ -134,11 +155,20 @@ static int rtl8211e_config_intr(struct phy_device *phydev)
 {
 	int err;
 
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = rtl821x_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		err = phy_write(phydev, RTL821x_INER,
 				RTL8211E_INER_LINK_STATUS);
-	else
+	} else {
 		err = phy_write(phydev, RTL821x_INER, 0);
+		if (err)
+			return err;
+
+		err = rtl821x_ack_interrupt(phydev);
+	}
 
 	return err;
 }
@@ -146,13 +176,25 @@ static int rtl8211e_config_intr(struct phy_device *phydev)
 static int rtl8211f_config_intr(struct phy_device *phydev)
 {
 	u16 val;
+	int err;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = rtl8211f_ack_interrupt(phydev);
+		if (err)
+			return err;
 
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
 		val = RTL8211F_INER_LINK_STATUS;
-	else
+		err = phy_write_paged(phydev, 0xa42, RTL821x_INER, val);
+	} else {
 		val = 0;
+		err = phy_write_paged(phydev, 0xa42, RTL821x_INER, val);
+		if (err)
+			return err;
 
-	return phy_write_paged(phydev, 0xa42, RTL821x_INER, val);
+		err = rtl8211f_ack_interrupt(phydev);
+	}
+
+	return err;
 }
 
 static irqreturn_t rtl8201_handle_interrupt(struct phy_device *phydev)
@@ -620,7 +662,6 @@ static struct phy_driver realtek_drvs[] = {
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc816),
 		.name		= "RTL8201F Fast Ethernet",
-		.ack_interrupt	= &rtl8201_ack_interrupt,
 		.config_intr	= &rtl8201_config_intr,
 		.handle_interrupt = rtl8201_handle_interrupt,
 		.suspend	= genphy_suspend,
@@ -647,7 +688,6 @@ static struct phy_driver realtek_drvs[] = {
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc912),
 		.name		= "RTL8211B Gigabit Ethernet",
-		.ack_interrupt	= &rtl821x_ack_interrupt,
 		.config_intr	= &rtl8211b_config_intr,
 		.handle_interrupt = rtl821x_handle_interrupt,
 		.read_mmd	= &genphy_read_mmd_unsupported,
@@ -667,7 +707,6 @@ static struct phy_driver realtek_drvs[] = {
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc914),
 		.name		= "RTL8211DN Gigabit Ethernet",
-		.ack_interrupt	= rtl821x_ack_interrupt,
 		.config_intr	= rtl8211e_config_intr,
 		.handle_interrupt = rtl821x_handle_interrupt,
 		.suspend	= genphy_suspend,
@@ -678,7 +717,6 @@ static struct phy_driver realtek_drvs[] = {
 		PHY_ID_MATCH_EXACT(0x001cc915),
 		.name		= "RTL8211E Gigabit Ethernet",
 		.config_init	= &rtl8211e_config_init,
-		.ack_interrupt	= &rtl821x_ack_interrupt,
 		.config_intr	= &rtl8211e_config_intr,
 		.handle_interrupt = rtl821x_handle_interrupt,
 		.suspend	= genphy_suspend,
@@ -689,7 +727,6 @@ static struct phy_driver realtek_drvs[] = {
 		PHY_ID_MATCH_EXACT(0x001cc916),
 		.name		= "RTL8211F Gigabit Ethernet",
 		.config_init	= &rtl8211f_config_init,
-		.ack_interrupt	= &rtl8211f_ack_interrupt,
 		.config_intr	= &rtl8211f_config_intr,
 		.handle_interrupt = rtl8211f_handle_interrupt,
 		.suspend	= genphy_suspend,
@@ -739,7 +776,6 @@ static struct phy_driver realtek_drvs[] = {
 		 * irq is requested and ACKed by reading the status register,
 		 * which is done by the irqchip code.
 		 */
-		.ack_interrupt	= genphy_no_ack_interrupt,
 		.config_intr	= genphy_no_config_intr,
 		.handle_interrupt = genphy_handle_interrupt_no_ack,
 		.suspend	= genphy_suspend,
-- 
2.28.0

