Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1279D2A1E04
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgKAMwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbgKAMwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:36 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DA5C061A47;
        Sun,  1 Nov 2020 04:52:35 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id oq3so12955931ejb.7;
        Sun, 01 Nov 2020 04:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t3EZK1CHCygs4K68ahkK28Oq/Nbw2XTbfb0hKa3yoLU=;
        b=fG51Pi8kPgge/wmg8bSLMJ4Xx7Mvg6ZQfNKbBGGfQBh3q3Ux3FsX6gybGCulj0oD79
         6tnryHhuxlMHz8rczy2hAPG6id8G0T2UcptEMN/mQgaC9x+1G10+RQHkkAnYd+TOVCZl
         poiSjkoniR5+hSSk366nycIRoRPCf+sifans7TMeWx3TFs12ONif/vUZkAqnEzjipOpD
         QWnR2gfLEP3Hj1mJKj7FZFeEU6dG+CMkyJUV/9aEm36n504E3VJyO9TIucqRPOoYYdIO
         pUutLbeu6hQ4OGVWSKsqZdjph0pQ8Qoslu9uXVXMsI18NhQ+Z70APRsz7bhQ6SU44MaN
         +6cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t3EZK1CHCygs4K68ahkK28Oq/Nbw2XTbfb0hKa3yoLU=;
        b=B3EndhMlZxGQ9MA22aepvWm2NybH7dB6dtqnOEKEOKffXYLtVzZOjjci8iuScRg9zt
         VHPG0kBf7PjnfjdNZjAmBcxhh11k6NoI+eLU1n6183AKROSDzaBT0BP6NG9PMuRc/fSW
         CQMH1/LaVL4qMT4BUTV3aYAAB2uwPFEwFw1T/259wby8zczopfiroxBPNi6qqdAro27k
         69BDp0Htr6oiKB2NyVVzwNaW3O9Z8CNoUnnkatEEDzI7f7Gc0fWCuCBw4x36ZuNTFFrR
         7TYFdXPkw0XNrQuagf+F1p/bPTthsgtxY8F9d03x4pvYNXGC+KKyDhHg+4RGeJ03epwz
         UunA==
X-Gm-Message-State: AOAM532hZ9iUXskLouZdshO6DnqLiHBzASJsf+4ZZRsRWoHxG+ROH7d+
        +HxGgycYbGVkQpZ9/d8Ki6o=
X-Google-Smtp-Source: ABdhPJzAHvYhTzBoMFTt9nmMF56IrQAXq7W1VAdhE7LvLgPnZ6eykm+jHdrihKF1e1Q30AwYcRZk3g==
X-Received: by 2002:a17:906:3150:: with SMTP id e16mr10817687eje.266.1604235153948;
        Sun, 01 Nov 2020 04:52:33 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:33 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 10/19] net: phy: aquantia: remove the use of .ack_interrupt()
Date:   Sun,  1 Nov 2020 14:51:05 +0200
Message-Id: <20201101125114.1316879-11-ciorneiioana@gmail.com>
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

Cc: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 drivers/net/phy/aquantia_main.c | 36 +++++++++++++++++----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 17b33f0cb179..345f70f9d39b 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -247,6 +247,13 @@ static int aqr_config_intr(struct phy_device *phydev)
 	bool en = phydev->interrupts == PHY_INTERRUPT_ENABLED;
 	int err;
 
+	if (en) {
+		/* Clear any pending interrupts before enabling them */
+		err = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_TX_VEND_INT_STATUS2);
+		if (err)
+			return err;
+	}
+
 	err = phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_TX_VEND_INT_MASK2,
 			    en ? MDIO_AN_TX_VEND_INT_MASK2_LINK : 0);
 	if (err < 0)
@@ -257,18 +264,20 @@ static int aqr_config_intr(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
-	return phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_GLOBAL_INT_VEND_MASK,
-			     en ? VEND1_GLOBAL_INT_VEND_MASK_GLOBAL3 |
-			     VEND1_GLOBAL_INT_VEND_MASK_AN : 0);
-}
+	err = phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_GLOBAL_INT_VEND_MASK,
+			    en ? VEND1_GLOBAL_INT_VEND_MASK_GLOBAL3 |
+			    VEND1_GLOBAL_INT_VEND_MASK_AN : 0);
+	if (err < 0)
+		return err;
 
-static int aqr_ack_interrupt(struct phy_device *phydev)
-{
-	int reg;
+	if (!en) {
+		/* Clear any pending interrupts after we have disabled them */
+		err = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_TX_VEND_INT_STATUS2);
+		if (err)
+			return err;
+	}
 
-	reg = phy_read_mmd(phydev, MDIO_MMD_AN,
-			   MDIO_AN_TX_VEND_INT_STATUS2);
-	return (reg < 0) ? reg : 0;
+	return 0;
 }
 
 static irqreturn_t aqr_handle_interrupt(struct phy_device *phydev)
@@ -604,7 +613,6 @@ static struct phy_driver aqr_driver[] = {
 	.name		= "Aquantia AQ1202",
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
-	.ack_interrupt	= aqr_ack_interrupt,
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
@@ -613,7 +621,6 @@ static struct phy_driver aqr_driver[] = {
 	.name		= "Aquantia AQ2104",
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
-	.ack_interrupt	= aqr_ack_interrupt,
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
@@ -622,7 +629,6 @@ static struct phy_driver aqr_driver[] = {
 	.name		= "Aquantia AQR105",
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
-	.ack_interrupt	= aqr_ack_interrupt,
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 	.suspend	= aqr107_suspend,
@@ -633,7 +639,6 @@ static struct phy_driver aqr_driver[] = {
 	.name		= "Aquantia AQR106",
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
-	.ack_interrupt	= aqr_ack_interrupt,
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
@@ -644,7 +649,6 @@ static struct phy_driver aqr_driver[] = {
 	.config_init	= aqr107_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
-	.ack_interrupt	= aqr_ack_interrupt,
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr107_read_status,
 	.get_tunable    = aqr107_get_tunable,
@@ -663,7 +667,6 @@ static struct phy_driver aqr_driver[] = {
 	.config_init	= aqcs109_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
-	.ack_interrupt	= aqr_ack_interrupt,
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr107_read_status,
 	.get_tunable    = aqr107_get_tunable,
@@ -680,7 +683,6 @@ static struct phy_driver aqr_driver[] = {
 	.name		= "Aquantia AQR405",
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
-	.ack_interrupt	= aqr_ack_interrupt,
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
-- 
2.28.0

