Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2912A1E1D
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgKAMwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgKAMw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:28 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B841C061A04;
        Sun,  1 Nov 2020 04:52:28 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id s25so899508ejy.6;
        Sun, 01 Nov 2020 04:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=azWRZ+ciy9IGqw+u9BFIIirqcSWYURJ0s6AGtMWUXIg=;
        b=X+p+fsBLGvD7dDHIctDpku0H1caiy82AcE3+qzj4yUlyy2W3JrUh4HIH80q/NY55St
         wxKDVM+IummwXIUbHtClchz2I63U2IbmFUvvQGx2jO+Cm3jhS2n+0t+AfHGoKktv/nIJ
         p+VbdTVtgLR3M2uMvo2ezlgEJisZw7hKMP2bA1ddA1i8hVuIDIlM/OgtbYCk0xzo1Rox
         f6eXbI3x3qw7gIM6S4KbyrUOFszMYel/lxPwrvo7UiFmcUfNEr5mdWIpz9snsPf8eTpe
         V6Aj4JGCWMGhJgLPqlGQeMEy21rEG/livKfyZH1nTVzscbFb2SeZ/olJgmkKlC1CWtBk
         dG6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=azWRZ+ciy9IGqw+u9BFIIirqcSWYURJ0s6AGtMWUXIg=;
        b=VY+hYL1PkSxM22Pf7MpUZDF5mWtPxryAvwnkY9xrqGyosVC2k/VWT4FaZsUlOZPMOH
         4vzTIM4HrbebBcU5N+CPJCKwVYSUnm9jdNRi6oYLINyso++j4D4CnsueH3pirwesCFka
         R8+PF3FWFGQBn8Mo/tWCMfAudQSQoVJdzn6YXvknHBFGTk1aqysx6CoDUZLwNGjnbC76
         qVyU79QjNhIh44O1kgwSF5yhMcnQY52/WuBPAzVwZQYy1QzPSQ+Kayl2AcjOgaYhqKbe
         UTlti3Hq2Az6fOgEkNRyL9IQLHPZsgsbgrhrX0rrfOsRupheTHToPYjOTiRpmdRNWbJl
         yUSA==
X-Gm-Message-State: AOAM531cOq/PO1lA2N9F8mtybMUw2pg3n1oSZ+xXfocC4Iv8iypiC9rC
        9FEWqgK46rzor2rlrfou2HMmov5eGZJHpn1K
X-Google-Smtp-Source: ABdhPJx1dMla5Ti0aGZCYNAYty2+FFhlP8o3BRoX7QGTCNYTisNomMGtdX5QYWzuKH94l25muX9Mmg==
X-Received: by 2002:a17:906:cede:: with SMTP id si30mr385910ejb.16.1604235147253;
        Sun, 01 Nov 2020 04:52:27 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:26 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 05/19] net: phy: at803x: remove the use of .ack_interrupt()
Date:   Sun,  1 Nov 2020 14:51:00 +0200
Message-Id: <20201101125114.1316879-6-ciorneiioana@gmail.com>
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

Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Michael Walle <michael@walle.cc>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 drivers/net/phy/at803x.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index c7f91934cf82..d0b36fd6c265 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -614,6 +614,11 @@ static int at803x_config_intr(struct phy_device *phydev)
 	value = phy_read(phydev, AT803X_INTR_ENABLE);
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		/* Clear any pending interrupts */
+		err = at803x_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		value |= AT803X_INTR_ENABLE_AUTONEG_ERR;
 		value |= AT803X_INTR_ENABLE_SPEED_CHANGED;
 		value |= AT803X_INTR_ENABLE_DUPLEX_CHANGED;
@@ -621,9 +626,14 @@ static int at803x_config_intr(struct phy_device *phydev)
 		value |= AT803X_INTR_ENABLE_LINK_SUCCESS;
 
 		err = phy_write(phydev, AT803X_INTR_ENABLE, value);
-	}
-	else
+	} else {
 		err = phy_write(phydev, AT803X_INTR_ENABLE, 0);
+		if (err)
+			return err;
+
+		/* Clear any pending interrupts */
+		err = at803x_ack_interrupt(phydev);
+	}
 
 	return err;
 }
@@ -1088,7 +1098,6 @@ static struct phy_driver at803x_driver[] = {
 	.resume			= at803x_resume,
 	/* PHY_GBIT_FEATURES */
 	.read_status		= at803x_read_status,
-	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
@@ -1109,7 +1118,6 @@ static struct phy_driver at803x_driver[] = {
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	/* PHY_BASIC_FEATURES */
-	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 }, {
@@ -1128,7 +1136,6 @@ static struct phy_driver at803x_driver[] = {
 	/* PHY_GBIT_FEATURES */
 	.read_status		= at803x_read_status,
 	.aneg_done		= at803x_aneg_done,
-	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
@@ -1149,7 +1156,6 @@ static struct phy_driver at803x_driver[] = {
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	/* PHY_BASIC_FEATURES */
-	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.cable_test_start	= at803x_cable_test_start,
@@ -1162,7 +1168,6 @@ static struct phy_driver at803x_driver[] = {
 	.resume			= at803x_resume,
 	.flags			= PHY_POLL_CABLE_TEST,
 	/* PHY_BASIC_FEATURES */
-	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.cable_test_start	= at803x_cable_test_start,
-- 
2.28.0

