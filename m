Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671E92B2105
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgKMQxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgKMQxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:53:01 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8449FC0613D1;
        Fri, 13 Nov 2020 08:53:00 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id s25so14416099ejy.6;
        Fri, 13 Nov 2020 08:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oNz8ucszFZGajN27xAe/ut4viosb6LUQd+Phco1FxbU=;
        b=dYDXpbAO0zu458DtRgxh4SP4FpjD55d76IJ/6znu2Fd4ZlqzGMLxPTV1VlmG8uDTAA
         y442kv+jmQEORHqyymjaWnE6H8ouxrO6SKbkht38ZHo5lBI95CoH1ZuwRZw0GSl4Gbb6
         IdlqHAJjUr2wF40SnukOwSNybRyJvRkQE7INzPIvdsSTdQu0G1Em0QW3QatpOwCHD271
         Xm7wE+VatFR5n+gCZ6hYTlKl8WqY5vv1Wy6YFfEWiIeJvlwDfL05KdJ6tBnJzbv++q7s
         +N+hzGYBqGm8yPlO4ZGkBcIKkW/o4+q0cfvfexqc5tvKvO+Y/tH1Oxzv0KqGzVk0JXky
         oTFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oNz8ucszFZGajN27xAe/ut4viosb6LUQd+Phco1FxbU=;
        b=m/bsM+mmK3OT8HFK6N0LdEe9NqbZ3ftF/HNLZUSb+UNytkCTPIz0b/iKaPvjDK/BJs
         zwqc6LM37pBFA7Xwky5sb38MUUmmgDHFcEykYU9CLA2BMmyVHRDS1M7MOljZ6w1s/uvE
         GDvOmtPA+10u4JqFodrPyULcqaQVBwQ+LzX8InPwUXQh15aW4oX8Ezbn9HH0m5gua47X
         9lUNm8C0aAVnoGpVAuV3cHENFIIrNmqS/ieOuLV9l6cQl20QO7NzqkSA2rQVZp9xFb4q
         sJteB0XcJrU+1Ka6QUx9oyzMF/7AYPXLd7xIhLlKSh5xgRg3F8ZSM3A6W6WlejBCp+Es
         w60w==
X-Gm-Message-State: AOAM530yFiN2pxaoOJecg6uE2Dby2mWJZCdYVxciAtSoliB13h37h/Pn
        EQP1lW4nStDVLcjXvsSeuP8=
X-Google-Smtp-Source: ABdhPJy6g2g0qtAu3SEZinpWPEr/Y6d0pFLt3N7OFluITX7UXL5+rxG/IwDHp/7gFRMvRhvWYplSdw==
X-Received: by 2002:a17:906:748b:: with SMTP id e11mr2717387ejl.513.1605286374834;
        Fri, 13 Nov 2020 08:52:54 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:52:54 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Baruch Siach <baruch@tkos.co.il>,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH RESEND net-next 06/18] net: phy: marvell: remove the use of .ack_interrupt()
Date:   Fri, 13 Nov 2020 18:52:14 +0200
Message-Id: <20201113165226.561153-7-ciorneiioana@gmail.com>
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

Cc: Maxim Kochetkov <fido_max@inbox.ru>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/marvell.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index bb843b960436..587930a7f48b 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -317,12 +317,21 @@ static int marvell_config_intr(struct phy_device *phydev)
 {
 	int err;
 
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = marvell_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		err = phy_write(phydev, MII_M1011_IMASK,
 				MII_M1011_IMASK_INIT);
-	else
+	} else {
 		err = phy_write(phydev, MII_M1011_IMASK,
 				MII_M1011_IMASK_CLEAR);
+		if (err)
+			return err;
+
+		err = marvell_ack_interrupt(phydev);
+	}
 
 	return err;
 }
@@ -2703,7 +2712,6 @@ static struct phy_driver marvell_drivers[] = {
 		.probe = marvell_probe,
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1101_config_aneg,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2722,7 +2730,6 @@ static struct phy_driver marvell_drivers[] = {
 		.probe = marvell_probe,
 		.config_init = m88e1111_config_init,
 		.config_aneg = marvell_config_aneg,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2744,7 +2751,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = m88e1111_config_init,
 		.config_aneg = m88e1111_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2766,7 +2772,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = m88e1111_config_init,
 		.config_aneg = m88e1111_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2787,7 +2792,6 @@ static struct phy_driver marvell_drivers[] = {
 		.probe = marvell_probe,
 		.config_init = m88e1118_config_init,
 		.config_aneg = m88e1118_config_aneg,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2807,7 +2811,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1121_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2829,7 +2832,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = m88e1318_config_init,
 		.config_aneg = m88e1318_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.get_wol = m88e1318_get_wol,
@@ -2851,7 +2853,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = m88e1145_config_init,
 		.config_aneg = m88e1101_config_aneg,
 		.read_status = genphy_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2872,7 +2873,6 @@ static struct phy_driver marvell_drivers[] = {
 		.probe = marvell_probe,
 		.config_init = m88e1149_config_init,
 		.config_aneg = m88e1118_config_aneg,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2891,7 +2891,6 @@ static struct phy_driver marvell_drivers[] = {
 		.probe = marvell_probe,
 		.config_init = m88e1111_config_init,
 		.config_aneg = marvell_config_aneg,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2909,7 +2908,6 @@ static struct phy_driver marvell_drivers[] = {
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
 		.config_init = m88e1116r_config_init,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2932,7 +2930,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = m88e1510_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.get_wol = m88e1318_get_wol,
@@ -2961,7 +2958,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2987,7 +2983,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -3012,7 +3007,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = m88e3016_config_init,
 		.aneg_done = marvell_aneg_done,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -3033,7 +3027,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = marvell_config_init,
 		.config_aneg = m88e6390_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -3058,7 +3051,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -3080,7 +3072,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
-- 
2.28.0

