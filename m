Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024F3347E30
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 17:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236688AbhCXQvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 12:51:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236616AbhCXQu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 12:50:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ABFA61A06;
        Wed, 24 Mar 2021 16:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616604658;
        bh=Nk/SfS4eM984ElTZInSbY5F2MeODu/172v5in/niB1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9ZXpMk075uMsU58j2VYKDos4hVv1sKiE2WWXQ1KJEIWSwwmy6/iKEKAleO+BUNkF
         RcOs+JC1lpZIIHPf8xKJQILdJ297AKVPE0nn8jmYZWmeVrDWOmx7kYR5oxnjW6ywnZ
         pnFHLIx1LkwbZpF+990deFxydORcUPHXt4PSH/K9VEOXQR0kClhfvbLaWT5zfDYHfg
         Bynsc30XKFUbt3Wxe8fFeHdtsKOgwuUxcWmgK/akOSl0fL2rM8/OJBokib3kvIQXfw
         Dd90R/kI3QYmRYn9dt0b+qcUUhbOeL0ZrTLyLJdNP3z71YMsBb3c27i7oytbLbXVnq
         Q2xRw7wIh/Rlg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 1/7] net: phy: marvell10g: rename register
Date:   Wed, 24 Mar 2021 17:50:17 +0100
Message-Id: <20210324165023.32352-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210324165023.32352-1-kabel@kernel.org>
References: <20210324165023.32352-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MV_V2_PORT_MAC_TYPE_* is part of the CTRL register. Rename to
MV_V2_PORT_CTRL_MACTYPE_*.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index b1bb9b8e1e4e..96c081a7ec54 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -80,8 +80,8 @@ enum {
 	MV_V2_PORT_CTRL		= 0xf001,
 	MV_V2_PORT_CTRL_SWRST	= BIT(15),
 	MV_V2_PORT_CTRL_PWRDOWN = BIT(11),
-	MV_V2_PORT_MAC_TYPE_MASK = 0x7,
-	MV_V2_PORT_MAC_TYPE_RATE_MATCH = 0x6,
+	MV_V2_PORT_CTRL_MACTYPE_MASK = 0x7,
+	MV_V2_PORT_CTRL_MACTYPE_RATE_MATCH = 0x6,
 	/* Temperature control/read registers (88X3310 only) */
 	MV_V2_TEMP_CTRL		= 0xf08a,
 	MV_V2_TEMP_CTRL_MASK	= 0xc000,
@@ -477,8 +477,8 @@ static int mv3310_config_init(struct phy_device *phydev)
 	val = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL);
 	if (val < 0)
 		return val;
-	priv->rate_match = ((val & MV_V2_PORT_MAC_TYPE_MASK) ==
-			MV_V2_PORT_MAC_TYPE_RATE_MATCH);
+	priv->rate_match = ((val & MV_V2_PORT_CTRL_MACTYPE_MASK) ==
+			MV_V2_PORT_CTRL_MACTYPE_RATE_MATCH);
 
 	/* Enable EDPD mode - saving 600mW */
 	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
-- 
2.26.2

