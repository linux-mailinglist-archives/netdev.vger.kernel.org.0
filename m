Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE32D2145EE
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 14:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgGDMpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 08:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727933AbgGDMpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 08:45:34 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44DCC08C5DE
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 05:45:33 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a1so37222299ejg.12
        for <netdev@vger.kernel.org>; Sat, 04 Jul 2020 05:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eIsoFF84FmVJUH0t9kmza3GICFK3VEatxbzHZrSgBPs=;
        b=AGhIaNuIf+upD33bDqCvAT8xHhDKkZp/V6jOHsVLFVbi8QAqy0R1E8ngCAcK6alZCi
         DM6O6A+SswDRwit04UZ+zbuACpT2OXG0k9Dg1bAbPQ7QdikuBZcRMY+JYsY6pfv908bi
         BqgFAAdsSIxKMqU8SeDya9o/Kz+88kA6/iBQD3yI7Uu61byUDnYTC3QNTQepQ9719/PY
         POD6BzdNnjgeQOxZ109i2Hm3WiewlgPQ0uROk8BO9qHRE6JnBo7wAnNqb/yZHtskCkfH
         3ICx+XnLI8hZlzCFZjutzN3v/Ju+iUKfAGJBn2ryLG+aTweUvlpl3Z94EuHmkp7ggN5/
         PTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eIsoFF84FmVJUH0t9kmza3GICFK3VEatxbzHZrSgBPs=;
        b=mEmTRlEkrqtV/Wd9V1ogppLOlmt4sxC/2Ti1EzLjQh/1u+O3Mh83v/hgdeQiJlmmZd
         L7Nj+lWcP1fpfXU1lEkHUHdfgc+lsmZ7J8ULMiiG43An2NM5ToyMH8kNorvD3DNPX0DR
         rzm9jGM6MQpl8mNWqIUJLpoBz0gBdWq7uh7aMJhibaHCLRjAWOxDHNJGJRR1llb8/op2
         TI0zh+p37gn8wQ5D+WtHotLLJUZ0r3exL61Xiil0liMfORjMtMix+DeshIQH1fWG7Y/j
         RhkWfrq+enmsgVgwemLUc3bMGE4X0lHzNCkV62gHBZoXir/o3bBd064EO8z0fX9BUWWO
         vn3g==
X-Gm-Message-State: AOAM5306ZYjBQM8iJ3b5R/L8AKGSXZOYg03Kn+q73gGHmCBUAasb1yoT
        lcpKf0vO2ghqiOzAL3n10OY=
X-Google-Smtp-Source: ABdhPJzXYdB52Fwic5R/lHfyAjEzOVKu4L6cnsYh/e0FVjEEZlHxY/7klmvmnOspCemtoOAsP8A8RQ==
X-Received: by 2002:a17:906:2b92:: with SMTP id m18mr38438271ejg.218.1593866732431;
        Sat, 04 Jul 2020 05:45:32 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id dm1sm12983851ejc.99.2020.07.04.05.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2020 05:45:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH v2 net-next 5/6] net: dsa: felix: delete .phylink_mac_an_restart code
Date:   Sat,  4 Jul 2020 15:45:06 +0300
Message-Id: <20200704124507.3336497-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200704124507.3336497-1-olteanv@gmail.com>
References: <20200704124507.3336497-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The Cisco SGMII and USXGMII standards specify control information
exchange to be "achieved by using the Auto-Negotiation functionality
defined in Clause 37 of the IEEE Specification 802.3z".

The differences to clause 37 auto-negotiation are specified by the
respective standards. In the case of SGMII, the differences are spelled
out as being:

- A reduction of the link timer value, from 10 ms to 1.6 ms.
- A customization of the tx_config_reg[15:0], mostly to allow
  propagation of speed information.

A similar situation is going on for USXGMII as well: "USXGMII Auto-neg
mechanism is based on Clause 37 (Figure 37-6) plus additional management
control to select USXGMII mode".

The point is, both Cisco standards make explicit reference that they
require an auto-negotiation state machine implemented as per "Figure
37-6-Auto-Negotiation state diagram" from IEEE 802.3. In the SGMII spec,
it is very clearly pointed out that both the MAC PCS (Figure 3 MAC
Functional Block) and the PHY PCS (Figure 2 PHY Functional Block)
contain an auto-negotiation block defined by "Auto-Negotiation Figure
37-6".

Since both ends of the SGMII/USXGMII link implement the same state
machine (just carry different tx_config_reg payloads, which they convey
to their link partner via /C/ ordered sets), naturally the ability to
restart auto-negotiation is symmetrical. The state machine in IEEE 802.3
Figure 37-6 specifies the signal that triggers an auto-negotiation
restart as being "mr_restart_an=TRUE".

Furthermore, clause "37.2.5.1.9 State diagram variable to management
register mapping", through its "Table 37-8-PCS state diagram variable to
management register mapping", requires a PCS compliant to clause 37 to
expose the mr_restart_an signal to management through MDIO register "0.9
Auto-Negotiation restart", aka BMCR_ANRESTART in Linux terms.

The Felix PCS for SGMII and USXGMII is compliant to clause 37, so it
exposes BMCR_ANRESTART to the operating system. When this bit is
asserted, the following happens:

1. STATUS[Auto_Negotiation_Complete] goes from 1->0.
2. The PCS starts sending AN sequences instead of packets or IDLEs.
3. The PCS waits to receive AN sequences from PHY and matches them.
4. Once it has received  matching AN sequences and a PHY acknowledge,
   STATUS[Auto_Negotiation_Complete] goes from 0->1.
5. Normal packet transmission restarts.

Otherwise stated, the MAC PCS has the ability to re-trigger a switch of
the lane from data mode into configuration mode, then control
information exchange takes place, then the lane is switched back into
data mode. These 5 steps are collectively described as "restart AN state
machine" by the PCS documentation.
This is all as per IEEE 802.3 Clause 37 AN state machine, which SGMII
and USXGMII do not touch at this fundamental level.

Now, it is true that the Cisco SGMII and USXGMII specs mention that the
control information exchange has a unidirectional meaning. That is, the
PHY restarts the clause 37 auto-negotiation upon any change in MDI
auto-negotiation parameters.

PHYLINK takes this fact a bit further, and since the fact that for
SGMII/USXGMII, the MAC PCS conveys no new information to the PHY PCS
(beyond acknowledging the received config word), does not have any use
for permitting the MAC PCS to trigger a restart of the clause 37
auto-negotiation.

The only SERDES protocols for which PHYLINK allows that are 1000Base-X
and 2500Base-X. For those, the control information exchange _is_
bidirectional (local PCS specifies its duplex and flow control
abilities) since the link partner is at the other side of the media.

For any other SERDES protocols, the .phylink_mac_an_restart callback is
dead code. This is probably OK, I can't come up with a situation where
it might be useful for the MAC PCS to clear its cache of link state and
ask for a new tx_config_reg.

So remove this code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

