Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1198A3575D8
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356123AbhDGUYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:24:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356088AbhDGUXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:23:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 413E56124C;
        Wed,  7 Apr 2021 20:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827019;
        bh=YnZ1WlkKxRhoo0AnsQAL/iHERvmV0/UdEzK9TPgfoUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxPkKr2p1FW+loWzKw8cMPSsCqVCuroHTm/SQgFnim6mcSrHuPdlMS4iFfS+rQkVN
         5UrMk/zdbS117bXWDBERd+PX9REu8iipKoJYsl3Qx6jbv328VH0WHJGC/KcA3IeBo5
         DCaIsUqI3pknHi4Hs4r//CTR/2ltGAZ9MokgZYU+MR9E9NROrfqOBtU3gSnLKJ668l
         TxErsKi3o0dr90oagmr57P9T/+6hRSGU8fS8ajnFmjOqS+qQj/l4ET7zzh4bouZvqI
         xyDvVLeg9mtvsv9XrzFG7xzb+eJ2VbO00LwY+qv0X4WetiMynfekPqaRdIbKRINF9N
         GYqVZvpA5VakA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 03/16] net: phy: marvell10g: allow 5gbase-r and usxgmii
Date:   Wed,  7 Apr 2021 22:22:41 +0200
Message-Id: <20210407202254.29417-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407202254.29417-1-kabel@kernel.org>
References: <20210407202254.29417-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These modes are also supported by these PHYs.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

