Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E783492E0
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhCYNNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230241AbhCYNN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 09:13:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28B1A61A26;
        Thu, 25 Mar 2021 13:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616678009;
        bh=aEIqfBLBfaoi2rijCx0Z6Sl+e1sdvPs+1ZbqOwzkQ84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9oydgcSdl18RA3B1fEXHs7lk20xSaBCWCCQFlT3TrsM5YsAt/u4q36GlmTtV5R9v
         luyl1W8s1GqltacZgJCjpwgnVfVHCVwZeVqFMYQuGzn7hAzE77e+dnnL4OtgcACm59
         XV0z78wvhulC/43hNydQLx+GFM0Wn7It8UbnpA6YbrSIt70fWiGywiFZbYqgrSU5Ga
         xrAwbgpIavf/bxQB+Tsa67HoMBuD3GVpuKE5a9QN+8PvFfm+4birgfxMhmJ/vqYnBO
         espxOdcEAR3r/XHYw9+53kNNHNJf47JS5LA+vI7jqsNZqA2D08BASad6aN0SHM8fbq
         lmNuwpZFuv7Qg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 03/12] net: phy: marvell10g: allow 5gbase-r and usxgmii
Date:   Thu, 25 Mar 2021 14:12:41 +0100
Message-Id: <20210325131250.15901-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325131250.15901-1-kabel@kernel.org>
References: <20210325131250.15901-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This modes are also supported by this PHYs.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index f2f0da9717be..881a0717846e 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -462,9 +462,11 @@ static int mv3310_config_init(struct phy_device *phydev)
 	/* Check that the PHY interface type is compatible */
 	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
+	    phydev->interface != PHY_INTERFACE_MODE_5GBASER &&
 	    phydev->interface != PHY_INTERFACE_MODE_XAUI &&
 	    phydev->interface != PHY_INTERFACE_MODE_RXAUI &&
-	    phydev->interface != PHY_INTERFACE_MODE_10GBASER)
+	    phydev->interface != PHY_INTERFACE_MODE_10GBASER &&
+	    phydev->interface != PHY_INTERFACE_MODE_USXGMII)
 		return -ENODEV;
 
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
@@ -599,6 +601,7 @@ static void mv3310_update_interface(struct phy_device *phydev)
 
 	if ((phydev->interface == PHY_INTERFACE_MODE_SGMII ||
 	     phydev->interface == PHY_INTERFACE_MODE_2500BASEX ||
+	     phydev->interface == PHY_INTERFACE_MODE_5GBASER ||
 	     phydev->interface == PHY_INTERFACE_MODE_10GBASER) &&
 	    phydev->link) {
 		/* The PHY automatically switches its serdes interface (and
@@ -611,6 +614,9 @@ static void mv3310_update_interface(struct phy_device *phydev)
 		case SPEED_10000:
 			phydev->interface = PHY_INTERFACE_MODE_10GBASER;
 			break;
+		case SPEED_5000:
+			phydev->interface = PHY_INTERFACE_MODE_5GBASER;
+			break;
 		case SPEED_2500:
 			phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
 			break;
-- 
2.26.2

