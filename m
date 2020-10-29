Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5055929E883
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgJ2KJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbgJ2KJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:09:02 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A5DC0613D3;
        Thu, 29 Oct 2020 03:09:01 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id s15so2981747ejf.8;
        Thu, 29 Oct 2020 03:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ruBDJW8SR47ikrJUmtyZ1VXzuMp6ewwLM2VSQ9OgnW4=;
        b=oTjm2m0vOhDMAWmCLfrLH7ycdNGtEGkThg/Xo49pO9seC3DxqSFhAvb6eio871RLNL
         okA1NC+5xIGIirhiXxSzmCJF8JJItjX5YzOSidFXX7eYdFPSBhzL5YyDcf5NBrExV3aG
         27Wk79kAYWP2Sd6heVGHvalDU1wGs+5Gn3eXms6RPeL/DM+2zYlXJCgIjTUhr6wrXrvt
         jLQXtJTv9oRDbiOT6KUix+uaQJ5CqioRgrRqigiBESuGaTFpxj9bhPB01uMfPmayOasV
         p5mQP2kcEb/s1zrBvST4A2IFDansYRsb6HBJI/X+yC4/ZAgsz/UZj39PKUXt4rJYW116
         0s0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ruBDJW8SR47ikrJUmtyZ1VXzuMp6ewwLM2VSQ9OgnW4=;
        b=STGOtbucaLEYUqkEGBnDIN2In5uumRC5G825oHE73bXBqUic1sJ+/Qx1HVFqOOY5Jx
         leMPOICY8aKCb6sHUc3mJETFumvboEFahVOw3P+AiYCbpKHCYEkKeak6eSbdCzqWss8I
         R3C/BWyyReHbH5/dM8x1DBBHUZ0x/EeuQWdPtrRmhMt8WaOIB9MxAOb6y3rs4WhFNnW8
         mK9DsK5d5ABHp6m2vioFoOIAeulREh6zlt3PdUs07VfsnU5SLU/Gimso8/CfMvOkMCKX
         ymgojEFGwuNg62DJB1rK0MVqhT/Msnj+oAnTz2/BWbA7MYP5kkVNUF2XW6h8+L8bfKgB
         63dQ==
X-Gm-Message-State: AOAM532Wpwb4zrgwDhCq0Zb7amGA9GpmqJs9nfPYcjxKw4KQ4mtjVX8O
        Od92PMcubvqw3dYCZr/Hw/g=
X-Google-Smtp-Source: ABdhPJwm4AEsmVc7szhjj3sOY+2WuWwAARFGo0IGTHYZhmasM3gm2hBmYwGYWcEHB+BQk+VDqa1K9g==
X-Received: by 2002:a17:907:40c0:: with SMTP id nu24mr3383752ejb.359.1603966140458;
        Thu, 29 Oct 2020 03:09:00 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:08:59 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 16/19] net: phy: davicom: remove the use of .ack_interrupt()
Date:   Thu, 29 Oct 2020 12:07:38 +0200
Message-Id: <20201029100741.462818-17-ciorneiioana@gmail.com>
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

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/davicom.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/davicom.c b/drivers/net/phy/davicom.c
index 262ff6c79860..a5a2468732c2 100644
--- a/drivers/net/phy/davicom.c
+++ b/drivers/net/phy/davicom.c
@@ -57,24 +57,40 @@ MODULE_AUTHOR("Andy Fleming");
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
@@ -150,13 +166,6 @@ static int dm9161_config_init(struct phy_device *phydev)
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
@@ -165,7 +174,6 @@ static struct phy_driver dm91xx_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.config_init	= dm9161_config_init,
 	.config_aneg	= dm9161_config_aneg,
-	.ack_interrupt	= dm9161_ack_interrupt,
 	.config_intr	= dm9161_config_intr,
 	.handle_interrupt = dm9161_handle_interrupt,
 }, {
@@ -175,7 +183,6 @@ static struct phy_driver dm91xx_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.config_init	= dm9161_config_init,
 	.config_aneg	= dm9161_config_aneg,
-	.ack_interrupt	= dm9161_ack_interrupt,
 	.config_intr	= dm9161_config_intr,
 	.handle_interrupt = dm9161_handle_interrupt,
 }, {
@@ -185,7 +192,6 @@ static struct phy_driver dm91xx_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.config_init	= dm9161_config_init,
 	.config_aneg	= dm9161_config_aneg,
-	.ack_interrupt	= dm9161_ack_interrupt,
 	.config_intr	= dm9161_config_intr,
 	.handle_interrupt = dm9161_handle_interrupt,
 }, {
@@ -193,7 +199,6 @@ static struct phy_driver dm91xx_driver[] = {
 	.name		= "Davicom DM9131",
 	.phy_id_mask	= 0x0ffffff0,
 	/* PHY_BASIC_FEATURES */
-	.ack_interrupt	= dm9161_ack_interrupt,
 	.config_intr	= dm9161_config_intr,
 	.handle_interrupt = dm9161_handle_interrupt,
 } };
-- 
2.28.0

