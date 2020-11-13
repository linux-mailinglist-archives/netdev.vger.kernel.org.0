Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BB42B20EB
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgKMQw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgKMQwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:52:55 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3355C0613D1;
        Fri, 13 Nov 2020 08:52:54 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id p93so11457564edd.7;
        Fri, 13 Nov 2020 08:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5eEkZyJuYqDgw3qo/V0uy1CW8YE9RreYkILxojzWYTQ=;
        b=Yrv2YuWOhbVzXh1LBqv1pj5PXOMpRA9ov8YzdJ5CniscasZ7AJ+tNSk0hYQNnYLHJf
         8YVStB40Eu6+ON5xr2Yslu8VpJOGtMbCK/rXWOTJXd3o3kvUIPrqzzcWuFT5H6Z4LR1M
         cDSdthAZKWKgPO3x3jQ9ifQ4Q+gMOadEcb82oOQD/j6dzRa1HE89SZ0emwCPAn3lAPo/
         oZyNUrvpcZvNJIEFz+PxUqKr+tGbrd8esSteuEe66eq9DuKK0PeawKj0MY+hPLYSGEms
         xlHqUcIrMACl+seKzPYnvddWVlOlY0UcLHN5F5oVvU0a6IbrQ/qBB1oh3qF2JStaBBKe
         PFfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5eEkZyJuYqDgw3qo/V0uy1CW8YE9RreYkILxojzWYTQ=;
        b=TvgF1Ao91pkoNxOPokdEMPH2fOLDBw7fJxCb/TDcBBM+WGAFPWuvY3rS3JCHJWrAoi
         Q2rV4V3cgA/DhHYts5EPjSRyGUxDudOOt/MgLAV9Slg/xrgCNZ1D1xk12WYappKmZ0Cq
         oY0kt3R4SucSwk+tZbDs+Z5yZYtD0lmz4MD/XJ/SBu9tL6MZIBEnUpf179fH8WPKBoiZ
         ElTZf65MdT0EQ21CpQCoB0rSFDK6PURzJQI6opOk0jjM0XVOfpVkRYjZpaMk2/Dmtapd
         rOMckJ8GvGfiwVsBz9KcCVR4jsq4A48H3pnQSS+BskTJy2q3Vya3hjd4qO8jqaIcxOon
         l3SQ==
X-Gm-Message-State: AOAM530gaZN/VUfkjzgxuiBlDi9PN008UU8CpTjL1+5w6M/oDp/D9u7S
        d3MGuKv8GNj4acEQx8AcFt0=
X-Google-Smtp-Source: ABdhPJxpXIeUT8nrrPe1sXC/sPiJT0GYVlL7JD1l5aBTOVr/O4O7FPmlTfJTok6KyQr0zVCBwlDtCg==
X-Received: by 2002:a05:6402:755:: with SMTP id p21mr3447192edy.349.1605286368789;
        Fri, 13 Nov 2020 08:52:48 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:52:47 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH RESEND net-next 02/18] net: phy: vitesse: remove the use of .ack_interrupt()
Date:   Fri, 13 Nov 2020 18:52:10 +0200
Message-Id: <20201113165226.561153-3-ciorneiioana@gmail.com>
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

Cc: Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/vitesse.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/net/phy/vitesse.c b/drivers/net/phy/vitesse.c
index 9f6cd6ec9747..16704e243162 100644
--- a/drivers/net/phy/vitesse.c
+++ b/drivers/net/phy/vitesse.c
@@ -275,25 +275,14 @@ static int vsc8601_config_init(struct phy_device *phydev)
 	return 0;
 }
 
-static int vsc824x_ack_interrupt(struct phy_device *phydev)
-{
-	int err = 0;
-
-	/* Don't bother to ACK the interrupts if interrupts
-	 * are disabled.  The 824x cannot clear the interrupts
-	 * if they are disabled.
-	 */
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
-		err = phy_read(phydev, MII_VSC8244_ISTAT);
-
-	return (err < 0) ? err : 0;
-}
-
 static int vsc82xx_config_intr(struct phy_device *phydev)
 {
 	int err;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		/* Don't bother to ACK the interrupts since the 824x cannot
+		 * clear the interrupts if they are disabled.
+		 */
 		err = phy_write(phydev, MII_VSC8244_IMASK,
 			(phydev->drv->phy_id == PHY_ID_VSC8234 ||
 			 phydev->drv->phy_id == PHY_ID_VSC8244 ||
@@ -420,7 +409,6 @@ static struct phy_driver vsc82xx_driver[] = {
 	/* PHY_GBIT_FEATURES */
 	.config_init    = &vsc824x_config_init,
 	.config_aneg    = &vsc82x4_config_aneg,
-	.ack_interrupt  = &vsc824x_ack_interrupt,
 	.config_intr    = &vsc82xx_config_intr,
 	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
@@ -430,7 +418,6 @@ static struct phy_driver vsc82xx_driver[] = {
 	/* PHY_GBIT_FEATURES */
 	.config_init	= &vsc824x_config_init,
 	.config_aneg	= &vsc82x4_config_aneg,
-	.ack_interrupt	= &vsc824x_ack_interrupt,
 	.config_intr	= &vsc82xx_config_intr,
 	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
@@ -440,7 +427,6 @@ static struct phy_driver vsc82xx_driver[] = {
 	/* PHY_GBIT_FEATURES */
 	.config_init    = &vsc824x_config_init,
 	.config_aneg    = &vsc82x4_config_aneg,
-	.ack_interrupt  = &vsc824x_ack_interrupt,
 	.config_intr    = &vsc82xx_config_intr,
 	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
@@ -449,7 +435,6 @@ static struct phy_driver vsc82xx_driver[] = {
 	.phy_id_mask    = 0x000ffff0,
 	/* PHY_GBIT_FEATURES */
 	.config_init    = &vsc8601_config_init,
-	.ack_interrupt  = &vsc824x_ack_interrupt,
 	.config_intr    = &vsc82xx_config_intr,
 	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
@@ -495,7 +480,6 @@ static struct phy_driver vsc82xx_driver[] = {
 	/* PHY_GBIT_FEATURES */
 	.config_init    = &vsc824x_config_init,
 	.config_aneg    = &vsc82x4_config_aneg,
-	.ack_interrupt  = &vsc824x_ack_interrupt,
 	.config_intr    = &vsc82xx_config_intr,
 	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
@@ -505,7 +489,6 @@ static struct phy_driver vsc82xx_driver[] = {
 	.name		= "Vitesse VSC8221",
 	/* PHY_GBIT_FEATURES */
 	.config_init	= &vsc8221_config_init,
-	.ack_interrupt	= &vsc824x_ack_interrupt,
 	.config_intr	= &vsc82xx_config_intr,
 	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
@@ -515,7 +498,6 @@ static struct phy_driver vsc82xx_driver[] = {
 	.name		= "Vitesse VSC8211",
 	/* PHY_GBIT_FEATURES */
 	.config_init	= &vsc8221_config_init,
-	.ack_interrupt	= &vsc824x_ack_interrupt,
 	.config_intr	= &vsc82xx_config_intr,
 	.handle_interrupt = &vsc82xx_handle_interrupt,
 } };
-- 
2.28.0

