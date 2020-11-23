Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70992C0EF9
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389575AbgKWPio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389505AbgKWPin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:38:43 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F95C061A4D;
        Mon, 23 Nov 2020 07:38:42 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id a16so23933978ejj.5;
        Mon, 23 Nov 2020 07:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vn8Bkfbu1JnwwkVBWlSgjeaX8jpdmKjpBKcRBW0TQRw=;
        b=EKPOLuBkljJYw2yYR2+yQCx5b5qi2FrWrYKRhARtKlpIBgPmt2ib2fltLNrpZKSyWC
         N0P+y2uizaXpunOi/XkbXlEI1RNIN6PrxYvY+ya25tYBSyODdpgJ5sCeoJq15GBNHty9
         MFx/GoUsFtawB38W0IIwEr3/Po28FGxCdMsbgqjEctRY6bhDafL8EVeJKxiUI4WuXaxU
         /TxFJWfOssxe/PkYbm0yQY7TatEvieVa4qScZPQ6a4MDCNfESrHcyf/WsQ2+Zd4GRfFH
         g3Gqb8OBLo887ezGY7Fd5txNkIgzhegAs0Hin9KLwYcyk5Zqimg5yLgGRPBV7VNzBY9H
         I1iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vn8Bkfbu1JnwwkVBWlSgjeaX8jpdmKjpBKcRBW0TQRw=;
        b=IlTAwIGpNd83aFviMVQk6gzEJY8GCJKobLGf9aAVDKJKmhcOb7XcljSx0YnDzXieq7
         uq+hn5IettL0aLHqKAT9wjd9ABdrzxLy4SYeyY8z4rOfmA4wLvkzHb9GKaxq0uB+r4bl
         7saSbRwf9IQzMRSNF+Dsl18WcwnbQj+7iBcY39x0zo0tEqFCscSCdHWCBWATsqHE9reh
         eCtrBY/khy8qk/IGvdq8XJqSNBasNA3rtsbYcuPsPBKCq6c4BG5Hiu2XThLT9pfl6E59
         hP94Q62QGkL5q3ACJ95xNKjnWNw//0O+8hFke1qVaq8NeEsl9sLm5l6kbEPDKiytADBU
         vfTA==
X-Gm-Message-State: AOAM531UB1b4wZoBOOPGa1y9agGSpfnhyMSS7vP8MasEk1SL3nV5u8cu
        Z7GvyiNorMElO0s/9/AOTZM=
X-Google-Smtp-Source: ABdhPJz7NBggxHS9j+OhMbUVoulEQ7FmeGWah2Jkb7FMkZvKdrSQaX8VHhMOUqNODdxxQTLXd5cj/w==
X-Received: by 2002:a17:906:7b82:: with SMTP id s2mr131912ejo.435.1606145921230;
        Mon, 23 Nov 2020 07:38:41 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c6sm4800126edy.62.2020.11.23.07.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:38:40 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Mathias Kresin <dev@kresin.me>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH net-next 02/15] net: phy: intel-xway: remove the use of .ack_interrupt()
Date:   Mon, 23 Nov 2020 17:38:04 +0200
Message-Id: <20201123153817.1616814-3-ciorneiioana@gmail.com>
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

Cc: Mathias Kresin <dev@kresin.me>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/intel-xway.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/intel-xway.c b/drivers/net/phy/intel-xway.c
index 1a27ae1bec5c..6eac50d4b42f 100644
--- a/drivers/net/phy/intel-xway.c
+++ b/drivers/net/phy/intel-xway.c
@@ -212,11 +212,24 @@ static int xway_gphy_ack_interrupt(struct phy_device *phydev)
 static int xway_gphy_config_intr(struct phy_device *phydev)
 {
 	u16 mask = 0;
+	int err;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = xway_gphy_ack_interrupt(phydev);
+		if (err)
+			return err;
 
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
 		mask = XWAY_MDIO_INIT_MASK;
+		err = phy_write(phydev, XWAY_MDIO_IMASK, mask);
+	} else {
+		err = phy_write(phydev, XWAY_MDIO_IMASK, mask);
+		if (err)
+			return err;
+
+		err = xway_gphy_ack_interrupt(phydev);
+	}
 
-	return phy_write(phydev, XWAY_MDIO_IMASK, mask);
+	return err;
 }
 
 static irqreturn_t xway_gphy_handle_interrupt(struct phy_device *phydev)
@@ -245,7 +258,6 @@ static struct phy_driver xway_gphy[] = {
 		/* PHY_GBIT_FEATURES */
 		.config_init	= xway_gphy_config_init,
 		.config_aneg	= xway_gphy14_config_aneg,
-		.ack_interrupt	= xway_gphy_ack_interrupt,
 		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
@@ -257,7 +269,6 @@ static struct phy_driver xway_gphy[] = {
 		/* PHY_BASIC_FEATURES */
 		.config_init	= xway_gphy_config_init,
 		.config_aneg	= xway_gphy14_config_aneg,
-		.ack_interrupt	= xway_gphy_ack_interrupt,
 		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
@@ -269,7 +280,6 @@ static struct phy_driver xway_gphy[] = {
 		/* PHY_GBIT_FEATURES */
 		.config_init	= xway_gphy_config_init,
 		.config_aneg	= xway_gphy14_config_aneg,
-		.ack_interrupt	= xway_gphy_ack_interrupt,
 		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
@@ -281,7 +291,6 @@ static struct phy_driver xway_gphy[] = {
 		/* PHY_BASIC_FEATURES */
 		.config_init	= xway_gphy_config_init,
 		.config_aneg	= xway_gphy14_config_aneg,
-		.ack_interrupt	= xway_gphy_ack_interrupt,
 		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
@@ -292,7 +301,6 @@ static struct phy_driver xway_gphy[] = {
 		.name		= "Intel XWAY PHY11G (PEF 7071/PEF 7072) v1.5 / v1.6",
 		/* PHY_GBIT_FEATURES */
 		.config_init	= xway_gphy_config_init,
-		.ack_interrupt	= xway_gphy_ack_interrupt,
 		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
@@ -303,7 +311,6 @@ static struct phy_driver xway_gphy[] = {
 		.name		= "Intel XWAY PHY22F (PEF 7061) v1.5 / v1.6",
 		/* PHY_BASIC_FEATURES */
 		.config_init	= xway_gphy_config_init,
-		.ack_interrupt	= xway_gphy_ack_interrupt,
 		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
@@ -314,7 +321,6 @@ static struct phy_driver xway_gphy[] = {
 		.name		= "Intel XWAY PHY11G (xRX v1.1 integrated)",
 		/* PHY_GBIT_FEATURES */
 		.config_init	= xway_gphy_config_init,
-		.ack_interrupt	= xway_gphy_ack_interrupt,
 		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
@@ -325,7 +331,6 @@ static struct phy_driver xway_gphy[] = {
 		.name		= "Intel XWAY PHY22F (xRX v1.1 integrated)",
 		/* PHY_BASIC_FEATURES */
 		.config_init	= xway_gphy_config_init,
-		.ack_interrupt	= xway_gphy_ack_interrupt,
 		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
@@ -336,7 +341,6 @@ static struct phy_driver xway_gphy[] = {
 		.name		= "Intel XWAY PHY11G (xRX v1.2 integrated)",
 		/* PHY_GBIT_FEATURES */
 		.config_init	= xway_gphy_config_init,
-		.ack_interrupt	= xway_gphy_ack_interrupt,
 		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
@@ -347,7 +351,6 @@ static struct phy_driver xway_gphy[] = {
 		.name		= "Intel XWAY PHY22F (xRX v1.2 integrated)",
 		/* PHY_BASIC_FEATURES */
 		.config_init	= xway_gphy_config_init,
-		.ack_interrupt	= xway_gphy_ack_interrupt,
 		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
-- 
2.28.0

