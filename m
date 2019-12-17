Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1C7122D1D
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfLQNkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:40:01 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56814 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728324AbfLQNj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:39:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=R2zZxufNdCK4YqPWcNLwIkLf4iLLF5qYE6/RwycXjIM=; b=oprd7NR7I5V5c7aKg5/dPKFWVc
        mHGfhavq5GnfLHuf7feZlOTA9hWyJf0suixbullyG5SiKnggYRQ+czxYEP8jcbpfPfLsiIuGhZaA8
        M45tCtHQrEEXxBr3ew4kk4AvHfgAFL+IkKzQdAfmr/ZKlmRPUA23DZbff163tHfHhwdDkOtVXzeXS
        O37Sj0Z+n/g2q03V+J4Qoc06UFy5S/o1KJJ6hfUNZvrfMoS1dfH4RTGQYebLB6V/mxWuqN1EzWVml
        giW5OpHeT/ynKTj/88Un9SF+abs0kfQg8a6nFM31RtW8Es6o+qlK0oWnnhmIUc1NkPSLLg8TxzJ0+
        /GM4HKwg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39836 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4i-0006Fk-Jn; Tue, 17 Dec 2019 13:39:44 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4g-0001zI-0E; Tue, 17 Dec 2019 13:39:42 +0000
In-Reply-To: <20191217133827.GQ25745@shell.armlinux.org.uk>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 09/11] net: phy: marvell: use existing clause 37
 definitions
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ihD4g-0001zI-0E@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Dec 2019 13:39:42 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use existing clause 37 advertising/link partner definitions rather than
private ones for the advertisement registers.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index b25eee9314a7..2d30653ddf4b 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -156,18 +156,9 @@
 #define MII_88E1510_GEN_CTRL_REG_1_MODE_SGMII	0x1	/* SGMII to copper */
 #define MII_88E1510_GEN_CTRL_REG_1_RESET	0x8000	/* Soft reset */
 
-#define LPA_FIBER_1000HALF	0x40
-#define LPA_FIBER_1000FULL	0x20
-
 #define LPA_PAUSE_FIBER		0x180
 #define LPA_PAUSE_ASYM_FIBER	0x100
 
-#define ADVERTISE_FIBER_1000HALF	0x40
-#define ADVERTISE_FIBER_1000FULL	0x20
-
-#define ADVERTISE_PAUSE_FIBER		0x180
-#define ADVERTISE_PAUSE_ASYM_FIBER	0x100
-
 #define NB_FIBER_STATS	1
 
 MODULE_DESCRIPTION("Marvell PHY driver");
@@ -507,16 +498,15 @@ static inline u32 linkmode_adv_to_fiber_adv_t(unsigned long *advertise)
 	u32 result = 0;
 
 	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, advertise))
-		result |= ADVERTISE_FIBER_1000HALF;
+		result |= ADVERTISE_1000XHALF;
 	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, advertise))
-		result |= ADVERTISE_FIBER_1000FULL;
+		result |= ADVERTISE_1000XFULL;
 
 	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, advertise) &&
 	    linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT, advertise))
-		result |= LPA_PAUSE_ASYM_FIBER;
+		result |= ADVERTISE_1000XPSE_ASYM;
 	else if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT, advertise))
-		result |= (ADVERTISE_PAUSE_FIBER
-			   & (~ADVERTISE_PAUSE_ASYM_FIBER));
+		result |= ADVERTISE_1000XPAUSE;
 
 	return result;
 }
@@ -549,8 +539,8 @@ static int marvell_config_aneg_fiber(struct phy_device *phydev)
 		return adv;
 
 	oldadv = adv;
-	adv &= ~(ADVERTISE_FIBER_1000HALF | ADVERTISE_FIBER_1000FULL
-		| LPA_PAUSE_FIBER);
+	adv &= ~(ADVERTISE_1000XHALF | ADVERTISE_1000XFULL |
+		 ADVERTISE_1000XPAUSE | ADVERTISE_1000XPSE_ASYM);
 	adv |= linkmode_adv_to_fiber_adv_t(phydev->advertising);
 
 	if (adv != oldadv) {
@@ -1177,10 +1167,10 @@ static int m88e6390_config_aneg(struct phy_device *phydev)
 static void fiber_lpa_mod_linkmode_lpa_t(unsigned long *advertising, u32 lpa)
 {
 	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
-			 advertising, lpa & LPA_FIBER_1000HALF);
+			 advertising, lpa & LPA_1000XHALF);
 
 	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
-			 advertising, lpa & LPA_FIBER_1000FULL);
+			 advertising, lpa & LPA_1000XFULL);
 }
 
 static int marvell_read_status_page_an(struct phy_device *phydev,
-- 
2.20.1

