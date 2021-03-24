Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E2F347E34
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 17:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236954AbhCXQvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 12:51:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236672AbhCXQvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 12:51:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2774F61A11;
        Wed, 24 Mar 2021 16:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616604662;
        bh=mBCES6V7e2/rkmOdt6W+gbb9VKDXIRD8GND4pLe8IkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YqeLHA3CCxGlKenLSEcsBXiFOZiNtE3eASxo22YxsB5QJj9iQiVlwPF38fBZzyOg9
         uxP/1vLgtazf8RYdqKZl4nKjW1WSMbSU/YnOiD9USu25wPjly2SwhCnsQCBcl/F+fL
         XjTEKupVU4WrSsUbwZOXCU/RjIOtU2FcvOnkwhcxVzqc/CAPo1jAr8NPC7jpBEVCbr
         Y10pI57JftfmuVPW0GzqWb5ytHgwP/rufSeVmFW/CyrxAa7vtWx3DUccqY5qA+bSwY
         NfzKFZevGzXSFh0X2dNP8rufRHK9+LX9N6qLwrosHuYZQgdKeLJcDTcaLEmK1bDBL8
         zUDguTigJxwNA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 3/7] net: phy: marvell10g: allow 5gabse-r and usxgmii
Date:   Wed, 24 Mar 2021 17:50:19 +0100
Message-Id: <20210324165023.32352-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210324165023.32352-1-kabel@kernel.org>
References: <20210324165023.32352-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This modes are also supported by this PHYs.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 567e7900e5b8..70639b9393f3 100644
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
@@ -611,6 +613,9 @@ static void mv3310_update_interface(struct phy_device *phydev)
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

