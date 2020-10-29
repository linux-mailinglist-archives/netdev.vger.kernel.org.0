Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B94D29E885
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbgJ2KJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgJ2KJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:09:06 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFB5C0613D2;
        Thu, 29 Oct 2020 03:09:06 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id v4so2485767edi.0;
        Thu, 29 Oct 2020 03:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PixkTg6tzKGsNR2ZYy3K/BacI9BMn8TVGQrYu2CBUP4=;
        b=qEZ41WRgBhtvbT+zP/57yzcN2SZwFabyrN655W0io7IcMAIoudc4Se/ksWHftjoZTn
         VimyLfEPFRxDGGijsQcvaviqCOXKnQPepMxn4bSD0Ij9hFJTw+Dpgzx+Yrc+vr7iILPQ
         0jVatl0Xog2pqPDUF1W7ivniRHw6s7gST7vWpqRDDRurZXfLwjPx4cpHI+E4z/veJypG
         ZTqY0dsMtb+PdGFwMaJozizEkzwmM2/A2CKeSy11I/ZlfalY522CNIYWOVuxWO057fa1
         ZkKqZP8mDXD8igpq0YRNkf/n/d52BTgt6/KJwmI3vxVWy5MUanSnbJv3wIhOQTWsw4bd
         WWew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PixkTg6tzKGsNR2ZYy3K/BacI9BMn8TVGQrYu2CBUP4=;
        b=oGMqyM4HEY6+Mkn3vySJsMOciH/Tcrnwjzg8Gcyjg9dWqxmAcr3uXhNckRfr6ZVz9+
         FkSUvpVQIz82coBUnxrYmMPQDCq1Qik0TorQag5SSC8yp+7KNjZvFmwtrQibTV+n/6qh
         FebnhxfSbv/6kbHCZoMYMbH1fyLIMxRtt9yxu4Onv8hunljRhNb7CeLSpZ3OrP2zVotr
         xpkpjcKRfB5dxkW1Khe1gJADULTXmbJv4w5cIuhhnJ/YHz6Ae2sXijP/Mig7SKkv+Xrs
         FLps41WOTZb2tl3HenpAiu68p2j7kYuhrMTtgkQWf2XCqx1cDR0Z2DkGBQkVglXli43t
         O5rw==
X-Gm-Message-State: AOAM533UZfumJo8jdJCDo5RanORwWpX+i3yFrZqCVRQQ2oxHRldu0+XQ
        ri0/imr4aQl4YefaBPcPi+4=
X-Google-Smtp-Source: ABdhPJzOvHbEsl3G4rgFnVcRO8IBHW+xlTv7VIaHL3KxjxgjQZ4+Fwl4eaokvDlQS03drbcjWPs7jA==
X-Received: by 2002:aa7:c1d9:: with SMTP id d25mr3030907edp.309.1603966144787;
        Thu, 29 Oct 2020 03:09:04 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:09:04 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Willy Liu <willy.liu@realtek.com>
Subject: [PATCH net-next 19/19] net: phy: realtek: remove the use of .ack_interrupt()
Date:   Thu, 29 Oct 2020 12:07:41 +0200
Message-Id: <20201029100741.462818-20-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029100741.462818-1-ciorneiioana@gmail.com>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
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
 drivers/net/phy/realtek.c | 68 ++++++++++++++++++++++++++++++---------
 1 file changed, 52 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index dd77703af1be..d587f84c7380 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -102,24 +102,45 @@ static int rtl8211f_ack_interrupt(struct phy_device *phydev)
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
@@ -128,11 +149,20 @@ static int rtl8211e_config_intr(struct phy_device *phydev)
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
@@ -140,13 +170,25 @@ static int rtl8211e_config_intr(struct phy_device *phydev)
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
@@ -608,7 +650,6 @@ static struct phy_driver realtek_drvs[] = {
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc816),
 		.name		= "RTL8201F Fast Ethernet",
-		.ack_interrupt	= &rtl8201_ack_interrupt,
 		.config_intr	= &rtl8201_config_intr,
 		.handle_interrupt = rtl8201_handle_interrupt,
 		.suspend	= genphy_suspend,
@@ -635,7 +676,6 @@ static struct phy_driver realtek_drvs[] = {
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc912),
 		.name		= "RTL8211B Gigabit Ethernet",
-		.ack_interrupt	= &rtl821x_ack_interrupt,
 		.config_intr	= &rtl8211b_config_intr,
 		.handle_interrupt = rtl821x_handle_interrupt,
 		.read_mmd	= &genphy_read_mmd_unsupported,
@@ -655,7 +695,6 @@ static struct phy_driver realtek_drvs[] = {
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc914),
 		.name		= "RTL8211DN Gigabit Ethernet",
-		.ack_interrupt	= rtl821x_ack_interrupt,
 		.config_intr	= rtl8211e_config_intr,
 		.handle_interrupt = rtl821x_handle_interrupt,
 		.suspend	= genphy_suspend,
@@ -666,7 +705,6 @@ static struct phy_driver realtek_drvs[] = {
 		PHY_ID_MATCH_EXACT(0x001cc915),
 		.name		= "RTL8211E Gigabit Ethernet",
 		.config_init	= &rtl8211e_config_init,
-		.ack_interrupt	= &rtl821x_ack_interrupt,
 		.config_intr	= &rtl8211e_config_intr,
 		.handle_interrupt = rtl821x_handle_interrupt,
 		.suspend	= genphy_suspend,
@@ -677,7 +715,6 @@ static struct phy_driver realtek_drvs[] = {
 		PHY_ID_MATCH_EXACT(0x001cc916),
 		.name		= "RTL8211F Gigabit Ethernet",
 		.config_init	= &rtl8211f_config_init,
-		.ack_interrupt	= &rtl8211f_ack_interrupt,
 		.config_intr	= &rtl8211f_config_intr,
 		.handle_interrupt = rtl8211f_handle_interrupt,
 		.suspend	= genphy_suspend,
@@ -727,7 +764,6 @@ static struct phy_driver realtek_drvs[] = {
 		 * irq is requested and ACKed by reading the status register,
 		 * which is done by the irqchip code.
 		 */
-		.ack_interrupt	= genphy_no_ack_interrupt,
 		.config_intr	= genphy_no_config_intr,
 		.handle_interrupt = genphy_handle_interrupt_no_ack,
 		.suspend	= genphy_suspend,
-- 
2.28.0

