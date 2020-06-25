Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2768B20A1D5
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405826AbgFYPYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405394AbgFYPYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:24:05 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1082C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:24:04 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id i14so6344330ejr.9
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uy4cc04lGctIV8y5qbKXSbMwhHgLQfNZ4JjK7jOuGek=;
        b=GM+1O3e865DRz13ba7+2uyNzGrxTJgyEtYzBiYxpxJFhSIOkagax3009NesAaZsOG0
         e59yr34hVWuLLyvtIZTDFB6ZaHEVhPwwzoXPhx01tHja5YS9O7klC7xfKJKcNWaEVBNX
         us6O+rWUnWwNkxH40nyGIJke8zhZHy1049hdjq39VTY8LPYSoJbtKyYrRCbnEJTUKBw6
         xZ7GHoeAcfimC/QUp+ycV4AYcUkhfb2Y45OcX8nS/TkBLeXsHUa3+qeyeR5utLN6hcxO
         YqZu53J8SnznnA7Wlf1dO9wDy+XLRty16bcHeM/OvgGwonzrsDt0mlh0fePCyE4vv18j
         TGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uy4cc04lGctIV8y5qbKXSbMwhHgLQfNZ4JjK7jOuGek=;
        b=ov0CKN8j9CY2yBc9FlsnnehqoZVqSc+E5FYuutuk9eNa4YgALpjfL+j91DZ8GTR8Qf
         IzBFVyVleUJiMilMj7MFiLmnJ3VoTt/oHWGdI3Lae/b3713YSmnVGvMx9V1b3CUYjXr7
         M9/aUrdIweq/RE3LmTPslSwVIwXUn2uVwF+indniQgcA0okN8pDDrObudjFDsphODuEM
         BcGuwcBOiyqZByYpXityyUSqaCe7HKvw41FrJe8Dl8ofT2IZfhV9C/hz8KVw+OWd15eC
         RnccIjjtcO85uX1QekGyGzDSTXakLS6oU8DDwnfVJOfK+45/C7XwZjKX1yED4IJAX4H1
         LeLA==
X-Gm-Message-State: AOAM533iy71AWc2khy+VMnpeDXAh1SDliGSghAlMryTofCXVWFuKNjU5
        zPZWdgU//NQJ3nVnD797nbk=
X-Google-Smtp-Source: ABdhPJy3WgrXToSB6MNkzeEi9iBxec4iNQRFPwKbPqqFrPGPIad/7a16m3egoZRHxAR3O9du2oeVaw==
X-Received: by 2002:a17:906:1ed2:: with SMTP id m18mr28958227ejj.529.1593098643565;
        Thu, 25 Jun 2020 08:24:03 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id o17sm9102898ejb.105.2020.06.25.08.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 08:24:00 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH net-next 5/7] net: dsa: felix: delete .phylink_mac_an_restart code
Date:   Thu, 25 Jun 2020 18:23:29 +0300
Message-Id: <20200625152331.3784018-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200625152331.3784018-1-olteanv@gmail.com>
References: <20200625152331.3784018-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In hardware, the AN_RESTART field for these SerDes protocols (SGMII,
USXGMII) clears the resolved configuration from the PCS's
auto-negotiation state machine.

But PHYLINK has a different interpretation of "AN restart". It assumes
that this Linux system is capable of re-triggering an auto-negotiation
sequence, something which is only possible with 1000Base-X and
2500Base-X, where the auto-negotiation is symmetrical. In SGMII and
USXGMII, there's an AN master and an AN slave, and it isn't so much of
"auto-negotiation" as it is "PHY passing the resolved link state on to
the MAC".

So, in PHYLINK's interpretation of "AN restart", it doesn't make sense
to do anything for SGMII and USXGMII. In fact, PHYLINK won't even call
us for any other SerDes protocol than 1000Base-X and 2500Base-X. But we
are not supporting those. So just remove this code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         | 10 -------
 drivers/net/dsa/ocelot/felix.h         |  1 -
 drivers/net/dsa/ocelot/felix_vsc9959.c | 37 --------------------------
 3 files changed, 48 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index da337c63e7ca..4ec05090121c 100644
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
@@ -812,7 +803,6 @@ static const struct dsa_switch_ops felix_switch_ops = {
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
index c1220b488f9c..7d2673dab7d3 100644
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
@@ -1412,7 +1376,6 @@ struct felix_info felix_info_vsc9959 = {
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9959_mdio_bus_free,
 	.pcs_init		= vsc9959_pcs_init,
-	.pcs_an_restart		= vsc9959_pcs_an_restart,
 	.pcs_link_state		= vsc9959_pcs_link_state,
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc          = vsc9959_port_setup_tc,
-- 
2.25.1

