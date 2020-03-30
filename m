Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F571982A1
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgC3Row (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:44:52 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55992 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727905AbgC3Row (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:44:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Z1a4ic91vYa9T2GunEQUej7BBOl52EoblBwQJ4I3Vbs=; b=HaGRKRdlE4mW/qJk+rc727Sjxw
        jW4Zye+FzBL5TtFvoIBQDsDHPk8yJBcKz8yoJ9KBj4Dw6Fmw2ZmIinx5dbREem8tJFPBpWo3CU9IR
        I9B0Mqitjkud2NrmeoHVYwfD5yW2OH3kw4HYvO1zim+agRqZyBwyTIY1jQPCyc0KPXwRgK1Mie0YN
        EyeolejG2XFizX4wBq+r9AT4uYNMeqFl6kTay9kco9mWNnDQZgzGp1mkuEPF5kN6ULyG5XoNsYBj8
        cwN/X5c/aTiSqDxtAQCHsBX9avlgujGnNwos/zb0AQ4uWmmri6Mz1oZpTmFXqvN8tIFDWfCmz72gB
        zKPIf+Uw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:54094 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jIySs-0003Vu-1L; Mon, 30 Mar 2020 18:44:46 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jIySq-00038m-NL; Mon, 30 Mar 2020 18:44:44 +0100
In-Reply-To: <20200330174330.GH25745@shell.armlinux.org.uk>
References: <20200330174330.GH25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 1/3] net: phylink: change
 phylink_mii_c22_pcs_set_advertisement() prototype
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jIySq-00038m-NL@rmk-PC.armlinux.org.uk>
Date:   Mon, 30 Mar 2020 18:44:44 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change phylink_mii_c22_pcs_set_advertisement() to take only the PHY
interface and advertisement mask, rather than the full phylink state.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 12 +++++++-----
 include/linux/phylink.h   |  3 ++-
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index fed0c5907c6a..f31bfd39df4b 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2184,7 +2184,8 @@ EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_get_state);
  * phylink_mii_c22_pcs_set_advertisement() - configure the clause 37 PCS
  *	advertisement
  * @pcs: a pointer to a &struct mdio_device.
- * @state: a pointer to the state being configured.
+ * @interface: the PHY interface mode being configured
+ * @advertising: the ethtool advertisement mask
  *
  * Helper for MAC PCS supporting the 802.3 clause 22 register set for
  * clause 37 negotiation and/or SGMII control.
@@ -2197,22 +2198,23 @@ EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_get_state);
  * zero if no change has been made, or one if the advertisement has changed.
  */
 int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
-					const struct phylink_link_state *state)
+					  phy_interface_t interface,
+					  const unsigned long *advertising)
 {
 	struct mii_bus *bus = pcs->bus;
 	int addr = pcs->addr;
 	int val, ret;
 	u16 adv;
 
-	switch (state->interface) {
+	switch (interface) {
 	case PHY_INTERFACE_MODE_1000BASEX:
 	case PHY_INTERFACE_MODE_2500BASEX:
 		adv = ADVERTISE_1000XFULL;
 		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
-				      state->advertising))
+				      advertising))
 			adv |= ADVERTISE_1000XPAUSE;
 		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
-				      state->advertising))
+				      advertising))
 			adv |= ADVERTISE_1000XPSE_ASYM;
 
 		val = mdiobus_read(bus, addr, MII_ADVERTISE);
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 8fa6df3b881b..6f6ecf3e0be1 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -320,7 +320,8 @@ void phylink_helper_basex_speed(struct phylink_link_state *state);
 void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
 				   struct phylink_link_state *state);
 int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
-					const struct phylink_link_state *state);
+					  phy_interface_t interface,
+					  const unsigned long *advertising);
 void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs);
 
 void phylink_mii_c45_pcs_get_state(struct mdio_device *pcs,
-- 
2.20.1

