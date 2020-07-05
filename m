Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF57214DF5
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 18:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgGEQRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 12:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEQRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 12:17:03 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22650C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 09:17:03 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id d15so32471685edm.10
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 09:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/wPdVO0936YgMTAAjgbwi0qPC1JZJY6KSmEgQQuTtZQ=;
        b=lw+VrFGvRkbItUXjXm3pAZnbQlwuzc0MQDr4ip0C+A6sNmGFrjgqPjIZx5T6Cf7QqK
         ZF2/4m8Fb35VVyXq/s5lWUEHXQa39jld+C2WHLig9WrkYV8qDmKy5R3ZnSLXuoT1y7VE
         vQC4zqtR8izEvzT8CC1QwbBgaIuVDuHa+8ikvFToBwL58g2z+ZzICoYiS1OaBYCKbf5i
         W0mRKCou321MYLqTGRiJG31lBCcpxB6RI8lAOGoo/YBaVzit7aylxIKGlW/vQahu7gW4
         GrlBCZkDbRZ/YCkiMB2im4bGYgDbJNKUygeYpH4ve77qDLgj6gpTVOYIClqvWOAg6dxp
         PeHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/wPdVO0936YgMTAAjgbwi0qPC1JZJY6KSmEgQQuTtZQ=;
        b=rbFDWC9PndYTh1XkAYDVTfaHde9Bm7WNEfjZsmKAKbt3Nyolz28Y88GDWEFvb8i45D
         wgozQVugxvVQsMIUo6WFGgRhTfYdnkWovwCcRs85cTzk8zPH7PclaFqTeujugwdT9T0V
         K4aN33I61nxxlXKKhLpQf5GwTMjEtmGwOTA/EE8/DtRsyGaHWRMunLRbIPvuZbsAGp8o
         LIUmeas2tvm5uJZeSf1OZAc7glaYtmZEEvDU82WHk/So4AsqpPfuub1fkQfTFlg0/3o7
         WrBz1XieOm9o6O1LBuokorJtX92Wg//GLkpLCGeeqcGJZNVLxUMP2PKgHd+LwDoT5kmS
         wNxg==
X-Gm-Message-State: AOAM531HKGmOgxqnzlSuVqwK9mudvbL/2Lk7BnmPbTmUj07S9I9rLbsJ
        sbiQyJO6kPSSKX8Ym50cBaA=
X-Google-Smtp-Source: ABdhPJxdK3dSKzMvFuJeaRpGNjsEeY7xEyYa5rn+LodyFqhcjRl8UpQoshiyt8SzUHGQXnf1tMiLlw==
X-Received: by 2002:a05:6402:176e:: with SMTP id da14mr36004726edb.262.1593965821881;
        Sun, 05 Jul 2020 09:17:01 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id x4sm14406126eju.2.2020.07.05.09.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 09:17:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH v3 net-next 5/6] net: dsa: felix: delete .phylink_mac_an_restart code
Date:   Sun,  5 Jul 2020 19:16:25 +0300
Message-Id: <20200705161626.3797968-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200705161626.3797968-1-olteanv@gmail.com>
References: <20200705161626.3797968-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Phylink uses the .mac_an_restart method to offer the user an
implementation of the "ethtool -r" behavior, when the media-side auto
negotiation can be restarted by the local MAC PCS. This is the case for
fiber modes 1000Base-X and 2500Base-X (IEEE clause 37) that don't have
an Ethernet PHY connected locally, and the media is connected to the MAC
PCS directly.

On the other hand, the Cisco SGMII and USXGMII standards also have an
auto negotiation mechanism based on IEEE 802.3 clause 37 (their
respective specs require a MAC PCS and a PHY PCS to implement the same
state machine, which is described in IEEE 802.3 "Auto-Negotiation Figure
37-6"), so the ability to restart auto-negotiation is intrinsically
symmetrical (the MAC PCS can do it too).

However, it appears that not all SGMII/USXGMII PHYs have logic to
restart the MDI-side auto-negotiation process when they detect a
transition of the SGMII link from data mode to configuration mode.
Some do (VSC8234) and some don't (AR8033, MV88E1111). IEEE and/or Cisco
specification wordings to not help to prove whether propagating the "AN
restart" event from MII side ("mr_restart_an") to MDI side
("mr_restart_negotiation") is required behavior - neither of them
specifies any mandatory interaction between the clause 37 AN state
machine from Figure 37-6 and the clause 28 AN state machine from Figure
28-18.

Therefore, even if a certain behavior could be proven as being required,
real-life SGMII/USXGMII PHYs are inconsistent enough that a clause 37 AN
restart cannot be used by phylink to reliably trigger a media-side
renegotiation, when the user requests it via ethtool.

The only remaining use that the .mac_an_restart callback might possibly
have, given what we know now, is to implement some silicon quirks, but
so far that has proven to not be necessary.

So remove this code for now, since it never gets called and we don't
foresee any circumstance in which it might be, either.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Update commit message to remove the lecturing tone, shorten the
description, acknowledge what phylink is trying to achieve with the
method and the fact that SGMII/USXGMII cannot achieve that.

Changes in v2:
Update commit message to be more clear.

 drivers/net/dsa/ocelot/felix.c         | 10 -------
 drivers/net/dsa/ocelot/felix.h         |  1 -
 drivers/net/dsa/ocelot/felix_vsc9959.c | 37 --------------------------
 3 files changed, 48 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 4684339012c5..57c400a67f16 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -296,15 +296,6 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 						  state->speed);
 }
 
-static void felix_phylink_mac_an_restart(struct dsa_switch *ds, int port)
-{
-	struct ocelot *ocelot = ds->priv;
-	struct felix *felix = ocelot_to_felix(ocelot);
-
-	if (felix->info->pcs_an_restart)
-		felix->info->pcs_an_restart(ocelot, port);
-}
-
 static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
 					unsigned int link_an_mode,
 					phy_interface_t interface)
@@ -810,7 +801,6 @@ static const struct dsa_switch_ops felix_switch_ops = {
 	.phylink_validate	= felix_phylink_validate,
 	.phylink_mac_link_state	= felix_phylink_mac_pcs_get_state,
 	.phylink_mac_config	= felix_phylink_mac_config,
-	.phylink_mac_an_restart	= felix_phylink_mac_an_restart,
 	.phylink_mac_link_down	= felix_phylink_mac_link_down,
 	.phylink_mac_link_up	= felix_phylink_mac_link_up,
 	.port_enable		= felix_port_enable,
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index a891736ca006..4a4cebcf04a7 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -31,7 +31,6 @@ struct felix_info {
 	void	(*pcs_init)(struct ocelot *ocelot, int port,
 			    unsigned int link_an_mode,
 			    const struct phylink_link_state *state);
-	void	(*pcs_an_restart)(struct ocelot *ocelot, int port);
 	void	(*pcs_link_state)(struct ocelot *ocelot, int port,
 				  struct phylink_link_state *state);
 	int	(*prevalidate_phy_mode)(struct ocelot *ocelot, int port,
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 94e946b26f90..65f83386bad1 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -728,42 +728,6 @@ static int vsc9959_reset(struct ocelot *ocelot)
 	return 0;
 }
 
-static void vsc9959_pcs_an_restart_sgmii(struct phy_device *pcs)
-{
-	phy_set_bits(pcs, MII_BMCR, BMCR_ANRESTART);
-}
-
-static void vsc9959_pcs_an_restart_usxgmii(struct phy_device *pcs)
-{
-	phy_write_mmd(pcs, MDIO_MMD_VEND2, MII_BMCR,
-		      USXGMII_BMCR_RESET |
-		      USXGMII_BMCR_AN_EN |
-		      USXGMII_BMCR_RST_AN);
-}
-
-static void vsc9959_pcs_an_restart(struct ocelot *ocelot, int port)
-{
-	struct felix *felix = ocelot_to_felix(ocelot);
-	struct phy_device *pcs = felix->pcs[port];
-
-	if (!pcs)
-		return;
-
-	switch (pcs->interface) {
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_QSGMII:
-		vsc9959_pcs_an_restart_sgmii(pcs);
-		break;
-	case PHY_INTERFACE_MODE_USXGMII:
-		vsc9959_pcs_an_restart_usxgmii(pcs);
-		break;
-	default:
-		dev_err(ocelot->dev, "Invalid PCS interface type %s\n",
-			phy_modes(pcs->interface));
-		break;
-	}
-}
-
 /* We enable SGMII AN only when the PHY has managed = "in-band-status" in the
  * device tree. If we are in MLO_AN_PHY mode, we program directly state->speed
  * into the PCS, which is retrieved out-of-band over MDIO. This also has the
@@ -1411,7 +1375,6 @@ struct felix_info felix_info_vsc9959 = {
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9959_mdio_bus_free,
 	.pcs_init		= vsc9959_pcs_init,
-	.pcs_an_restart		= vsc9959_pcs_an_restart,
 	.pcs_link_state		= vsc9959_pcs_link_state,
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc          = vsc9959_port_setup_tc,
-- 
2.25.1

