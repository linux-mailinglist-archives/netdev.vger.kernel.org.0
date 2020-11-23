Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90072C0F19
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389769AbgKWPjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389608AbgKWPis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:38:48 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A76C0613CF;
        Mon, 23 Nov 2020 07:38:46 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id mc24so2812809ejb.6;
        Mon, 23 Nov 2020 07:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uEhSuCuWwfzMW+QeM5P/cCH9mtQg5NrGbw5n/aF/ziI=;
        b=lOQoRZPmZGsy53rhdRaudNiRXggmb2wtjqeqVnfntbddSO1S1xtU6Cbfiq3SmZBkKr
         6BBdo5NufbMdm3OAVdowDA/lANLAgrrAi1eLFMbT0C+VZeQpZeXWQOrgSFFKJ8rLT9pV
         k9TOVWNvhuey2BxHNDr4fW5jw8n63K20CRszBtxjAJWpgpsWZWDdeRu0ynDIbryOQlyg
         f/p7JMa+KouiWKEz3Aj/EUrK4O5EFl9io9hfiwUJNzTs0QW7Vb+L3uY/+FuvUp2m+YCd
         7ZWFVkTs+7nkUpauj7a0HiP6y2i0Bnm/7mM3qXY/llr3DyuA0oPbI7DxNjyx/7xokOZ2
         KSBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uEhSuCuWwfzMW+QeM5P/cCH9mtQg5NrGbw5n/aF/ziI=;
        b=mwCKGLh+pL3i0DkH9x14Z39wFxLcD9U00tNJpr7VFXR4kq1yvmrS5b6PiTzlVZH/Tm
         1w0f087s8upCEAB8scBt0jHHE+t/8i0si5knoP0n3O+atk0eiZypByG2owdIxQxdLcJ5
         vGXpG4b1DWkTv/TmJREVcW8jtv6IL78pJJRXxzCSkv8awQ/jwRl+bqV3KnmRC7iC9rX4
         x0Jn3hDBwbPlAWUNX7vNG5mc4GEk4Ob9F0NM/tAKI/7WUa1SEsEtOdOoySHal2KSlMvD
         6HXWWBIRbdlCGAwyQysXxtQ4aRaGwrvchyMNxesEbJXWH0f1lx9YfgDYTEJg0NJYCDLk
         CHcw==
X-Gm-Message-State: AOAM530sYRBLELo0jwifD0BhVCC4jfkbHA8ypdQcjWjvIpCB6EA+Hj3C
        YGLP0WUrS8jh52SLgjpCmTxON47M2Upaxg==
X-Google-Smtp-Source: ABdhPJw7PRSfxSr/12H/xsTWrk77oLXEzcmBMzchwOuOSQ0rK7e3ttqPjlmV/962i7DnCuYNRALd2g==
X-Received: by 2002:a17:906:5955:: with SMTP id g21mr152380ejr.271.1606145925503;
        Mon, 23 Nov 2020 07:38:45 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c6sm4800126edy.62.2020.11.23.07.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:38:44 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net-next 04/15] net: phy: icplus: remove the use .ack_interrupt()
Date:   Mon, 23 Nov 2020 17:38:06 +0200
Message-Id: <20201123153817.1616814-5-ciorneiioana@gmail.com>
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

Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/icplus.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index a74ff45fa99c..b632947cbcdf 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -272,17 +272,39 @@ static int ip101a_g_config_init(struct phy_device *phydev)
 	return phy_write(phydev, IP10XX_SPEC_CTRL_STATUS, c);
 }
 
+static int ip101a_g_ack_interrupt(struct phy_device *phydev)
+{
+	int err = phy_read(phydev, IP101A_G_IRQ_CONF_STATUS);
+
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
 static int ip101a_g_config_intr(struct phy_device *phydev)
 {
 	u16 val;
+	int err;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = ip101a_g_ack_interrupt(phydev);
+		if (err)
+			return err;
 
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
 		/* INTR pin used: Speed/link/duplex will cause an interrupt */
 		val = IP101A_G_IRQ_PIN_USED;
-	else
+		err = phy_write(phydev, IP101A_G_IRQ_CONF_STATUS, val);
+	} else {
 		val = IP101A_G_IRQ_ALL_MASK;
+		err = phy_write(phydev, IP101A_G_IRQ_CONF_STATUS, val);
+		if (err)
+			return err;
+
+		err = ip101a_g_ack_interrupt(phydev);
+	}
 
-	return phy_write(phydev, IP101A_G_IRQ_CONF_STATUS, val);
+	return err;
 }
 
 static irqreturn_t ip101a_g_handle_interrupt(struct phy_device *phydev)
@@ -305,15 +327,6 @@ static irqreturn_t ip101a_g_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
-static int ip101a_g_ack_interrupt(struct phy_device *phydev)
-{
-	int err = phy_read(phydev, IP101A_G_IRQ_CONF_STATUS);
-	if (err < 0)
-		return err;
-
-	return 0;
-}
-
 static struct phy_driver icplus_driver[] = {
 {
 	.phy_id		= 0x02430d80,
@@ -340,7 +353,6 @@ static struct phy_driver icplus_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.probe		= ip101a_g_probe,
 	.config_intr	= ip101a_g_config_intr,
-	.ack_interrupt	= ip101a_g_ack_interrupt,
 	.handle_interrupt = ip101a_g_handle_interrupt,
 	.config_init	= &ip101a_g_config_init,
 	.suspend	= genphy_suspend,
-- 
2.28.0

