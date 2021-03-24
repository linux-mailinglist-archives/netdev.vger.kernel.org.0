Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11218347E35
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 17:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236980AbhCXQv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 12:51:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236686AbhCXQvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 12:51:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0097E61A0E;
        Wed, 24 Mar 2021 16:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616604664;
        bh=u+fGSu2A9+2ehYSGNcYHL+VcnOBUky0cZ0Q2ZPH0Ags=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyNjo8vXMyipAA81F2t0MTFwtu9DQpF/NCfJsbAsjxm83OuYrCV9z+41F+ZT3nJx6
         v+tOf5LdLnfIqL28xuURTNJQuzVoXZ8zoR66HzB9RYSmVIgHRQo9syftZzDje44W1N
         65ESl7NBRiM8txJ9AsC9daXe6CyyOfPCEd2DYzLBUT7ULRG2obETMbTzRGSlaDYkc3
         Jv7gjopvFyZTeE5M/RSjfwgxWe/+MO9gdnFu6eaXOJjPMR8eCTyAj/gPsxOc0kniri
         pT9yRRSAYnXKSKfDDRHu5tpyuS35RV/zNZY42A3zmuHlCmjR+WwCfD75VUKarusSSH
         o3vjPFwmrC+Wg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 4/7] net: phy: marvell10g: add MACTYPE definitions for 88X3310/88X3310P
Date:   Wed, 24 Mar 2021 17:50:20 +0100
Message-Id: <20210324165023.32352-5-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210324165023.32352-1-kabel@kernel.org>
References: <20210324165023.32352-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add all MACTYPE definitions for 88X3310/88X3310P.

In order to have consistent naming, rename
MV_V2_PORT_CTRL_MACTYPE_RATE_MATCH to
MV_V2_PORT_CTRL_MACTYPE_10GR_RATE_MATCH.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 70639b9393f3..46e853f2d41b 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -80,8 +80,15 @@ enum {
 	MV_V2_PORT_CTRL		= 0xf001,
 	MV_V2_PORT_CTRL_SWRST	= BIT(15),
 	MV_V2_PORT_CTRL_PWRDOWN	= BIT(11),
-	MV_V2_PORT_CTRL_MACTYPE_MASK = 0x7,
-	MV_V2_PORT_CTRL_MACTYPE_RATE_MATCH = 0x6,
+	MV_V2_PORT_CTRL_MACTYPE_MASK			= 0x7,
+	MV_V2_PORT_CTRL_MACTYPE_RXAUI			= 0x0,
+	MV_V2_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH		= 0x1,
+	MV_V2_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH	= 0x2,
+	MV_V2_PORT_CTRL_MACTYPE_XAUI			= 0x3,
+	MV_V2_PORT_CTRL_MACTYPE_10GBASER		= 0x4,
+	MV_V2_PORT_CTRL_MACTYPE_10GBASER_NO_SGMII_AN	= 0x5,
+	MV_V2_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH	= 0x6,
+	MV_V2_PORT_CTRL_MACTYPE_USXGMII			= 0x7,
 	/* Temperature control/read registers (88X3310 only) */
 	MV_V2_TEMP_CTRL		= 0xf08a,
 	MV_V2_TEMP_CTRL_MASK	= 0xc000,
@@ -480,7 +487,7 @@ static int mv3310_config_init(struct phy_device *phydev)
 	if (val < 0)
 		return val;
 	priv->rate_match = ((val & MV_V2_PORT_CTRL_MACTYPE_MASK) ==
-			MV_V2_PORT_CTRL_MACTYPE_RATE_MATCH);
+			MV_V2_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH);
 
 	/* Enable EDPD mode - saving 600mW */
 	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
-- 
2.26.2

