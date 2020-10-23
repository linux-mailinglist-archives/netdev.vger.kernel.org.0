Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926CC296D2D
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 12:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S462639AbgJWK5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 06:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S462576AbgJWK4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 06:56:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB106C0613D2
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 03:56:39 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVukG-00087p-Kr; Fri, 23 Oct 2020 12:56:28 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVukF-0001kT-F6; Fri, 23 Oct 2020 12:56:27 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>, linux-can@vger.kernel.org
Subject: [RFC PATCH v1 3/6] net: phy: add CAN interface mode
Date:   Fri, 23 Oct 2020 12:56:23 +0200
Message-Id: <20201023105626.6534-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201023105626.6534-1-o.rempel@pengutronix.de>
References: <20201023105626.6534-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy.c | 2 ++
 include/linux/phy.h   | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 35525a671400..4fb355df3e61 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -324,6 +324,8 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
 	cmd->base.master_slave_state = phydev->master_slave_state;
 	if (phydev->interface == PHY_INTERFACE_MODE_MOCA)
 		cmd->base.port = PORT_BNC;
+	else if (phydev->interface == PHY_INTERFACE_MODE_CAN)
+		cmd->base.port = PORT_OTHER;
 	else
 		cmd->base.port = PORT_MII;
 	cmd->base.transceiver = phy_is_internal(phydev) ?
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 92225fc0d105..c5d8628cecf3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -144,6 +144,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_USXGMII,
 	/* 10GBASE-KR - with Clause 73 AN */
 	PHY_INTERFACE_MODE_10GKR,
+	PHY_INTERFACE_MODE_CAN,
 	PHY_INTERFACE_MODE_MAX,
 } phy_interface_t;
 
@@ -225,6 +226,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "usxgmii";
 	case PHY_INTERFACE_MODE_10GKR:
 		return "10gbase-kr";
+	case PHY_INTERFACE_MODE_CAN:
+		return "can";
 	default:
 		return "unknown";
 	}
-- 
2.28.0

