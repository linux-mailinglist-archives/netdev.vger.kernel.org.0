Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00EA2B20F9
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgKMQxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgKMQxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:53:16 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363CDC0613D1;
        Fri, 13 Nov 2020 08:53:14 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id 7so14422514ejm.0;
        Fri, 13 Nov 2020 08:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oGBDzVq5PZR4Pbyh6TLReVGAkLMraG8njIqpD/GjZy4=;
        b=EtZd8OwgbOLqoIZfd5Jb7pm4r6JzHOwyoxm/Tfz63atbND+7xIUhVMvgtAM6ngX4EK
         2dPTUAqIu1nQKW706keacPPiKcyB1ZwECWZZ04Ds0HpNCAuHNJmSTdhXmWOi61vVBCj+
         UCz2k0Tlb1JNPgTiDzPpBiJmvxcRTgB2GwH6aR8zm0VDVgvTp+I5kpXp35q3QdwoV8KO
         49CqgWJbu77zasI13rALawSlOkM3kozxDyBfrfwBqS3KRhxjXs9ICoJyrR9Jgg2gXxrs
         R9qXOWfX+sZ3V7CRNdSBuKQy6cVwRUUvBnGdGeAczw/68qepY1jOgGtZjSNz0sq+qdCJ
         rasg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oGBDzVq5PZR4Pbyh6TLReVGAkLMraG8njIqpD/GjZy4=;
        b=Ux3TdWsajnCJyteGRLLZphw/TkDsaDdvcncg2v+jhH03E/0qoT9mX6aYPvvshKHerA
         prrUg6O74I7UjW0XxTGiI3XgYVbun+rVqz4jADZXZK8h2bHrmUFgF4xYCnW7W5z87Dyh
         kkXuRwxxh9Up9+U0V9ueZzgpulynxFKUjPCE4Sio+mC0PCKkV2K6NkvbafGv+Z5u65oq
         HJxBvfTUi9Ag/CypeHmw3XTBhii+VRc3gI2lWffcYvlRPH36M+frNBFvJL1HDThl3lT2
         1UPveTge7FtdWOaweFwNIsatC7yrEBRHRB3o0XY+bhM85ImfD4jvfBHiMfRNKSz6EQo4
         GUFQ==
X-Gm-Message-State: AOAM5333sF5dhBusxJRiG1qLmazFKxs3Zw28DSHY3nj8DgsYg02kiFTs
        Cbqc50S5anHGhbwa1XZPbAE=
X-Google-Smtp-Source: ABdhPJzIsDh+m1soIX80keARC9jBzgVsaeveP4Xkiv9BsUe0nkC8CxTtS/vW7RnY80KFG8nG+eR7UA==
X-Received: by 2002:a17:907:2175:: with SMTP id rl21mr2875737ejb.59.1605286387669;
        Fri, 13 Nov 2020 08:53:07 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:53:07 -0800 (PST)
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
Subject: [PATCH RESEND net-next 14/18] net: phy: smsc: remove the use of .ack_interrupt()
Date:   Fri, 13 Nov 2020 18:52:22 +0200
Message-Id: <20201113165226.561153-15-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113165226.561153-1-ciorneiioana@gmail.com>
References: <20201113165226.561153-1-ciorneiioana@gmail.com>
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

