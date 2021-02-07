Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E815A312850
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 00:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhBGX0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 18:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhBGXY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 18:24:29 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D4BC0617A9;
        Sun,  7 Feb 2021 15:23:19 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id q2so16116202edi.4;
        Sun, 07 Feb 2021 15:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sMuPubZ45bqcqp7F8mYy1wbLZt7y2eQbAhZhBI5pduQ=;
        b=E6IkE+EEEAbE0TKB4FhAcQL0fn5pBQkSvkaQTo99WVLWEKXka6frrJqeOmlHcibsdn
         XWVJEIkNFXdVUNJhmXJESmEh5zkOij/Hc51cAFOxLXDLA3vr77Zx+9pYcGZ0XE/vtAaH
         cIcWfRxImTW5gQRljjrEsMqRNCxWOKm/xx+MFtP0J/On7hizsAlpEL819U5Kj/v7p/rz
         0kLjGK03xzWh5O0Zt/1A0rSsejT3hNQivdSC9IytGlklNW4ekVkxil4pK//jCsre5evU
         XhnQs5WnfbRHEHOXVwrWE92kijxc7D7sOj82FbM0v1BZFZN0Kouwp5EwOdKHmXGQrnSd
         3nQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sMuPubZ45bqcqp7F8mYy1wbLZt7y2eQbAhZhBI5pduQ=;
        b=Q2iipv8P5p3Xs4RLgczb6oqpj+6iUXJ7f2RhSDxW+8ztJgSyexGtgXvdRGhn+xgXOk
         Wnd8kCG1Tp6TPLemJrGB4jRcOsWtUgblvKhwwKeFcj0+Tnyxi/YxfmlRarU4Fr/exB0v
         EywaJAlsm/EBB4cOhXAhwM76czH2hLOIpjOgfOxG2E6J2N9mNvbDFXfnMpU2m5Ss6opf
         qkiElz0MRBDbWKAYLssOYYznupbKk37naHeNs2NG3CZo94VLRFYelRBdiFCq76GzwuOE
         VjfkvmQhq9YQYAp8G0X/pdoprZgpgGzZpObm6qOahXYu/dZNRQck6WxtC0TMQWzHtWWr
         oPSA==
X-Gm-Message-State: AOAM530nq4h11Q+3ONqCGpx4A/dNmxRIyBvtFHjoo5SMvDXDIM3uyVj+
        ERhMRo2HjCu8q64GryqzqXg=
X-Google-Smtp-Source: ABdhPJxx8zCBbcCYDSH7IkOVT3WhlPRqi+moQ4NwndkfmHp5byWVOD/6TBrjVf3FAdSJBzDWV15ZXw==
X-Received: by 2002:a05:6402:4391:: with SMTP id o17mr14733767edc.196.1612740197806;
        Sun, 07 Feb 2021 15:23:17 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u21sm7540016ejj.120.2021.02.07.15.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 15:23:17 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH net-next 9/9] net: mscc: ocelot: support multiple bridges
Date:   Mon,  8 Feb 2021 01:21:41 +0200
Message-Id: <20210207232141.2142678-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207232141.2142678-1-olteanv@gmail.com>
References: <20210207232141.2142678-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The ocelot switches are a bit odd in that they do not have an STP state
to put the ports into. Instead, the forwarding configuration is delayed
from the typical port_bridge_join into stp_state_set, when the port enters
the BR_STATE_FORWARDING state.

I can only guess that the implementation of this quirk is the reason that
led to the simplification of the driver such that only one bridge could
be offloaded at a time.

We can simplify the data structures somewhat, and introduce a per-port
bridge device pointer and STP state, similar to how the LAG offload
works now (there we have a per-port bonding device pointer and TX
enabled state). This allows offloading multiple bridges with relative
ease, while still keeping in place the quirk to delay the programming of
the PGIDs.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c         | 69 +++++++++++-----------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  2 +-
 include/soc/mscc/ocelot.h                  |  7 +--
 3 files changed, 38 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index c8bfc2f9534a..6f2967376210 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -912,6 +912,26 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
 	return mask;
 }
 
+static u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot,
+				      struct net_device *bridge)
+{
+	u32 mask = 0;
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+		if (!ocelot_port)
+			continue;
+
+		if (ocelot_port->stp_state == BR_STATE_FORWARDING &&
+		    ocelot_port->bridge == bridge)
+			mask |= BIT(port);
+	}
+
+	return mask;
+}
+
 static u32 ocelot_get_dsa_8021q_cpu_mask(struct ocelot *ocelot)
 {
 	u32 mask = 0;
@@ -961,10 +981,12 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 			 */
 			mask = GENMASK(ocelot->num_phys_ports - 1, 0);
 			mask &= ~cpu_fwd_mask;
-		} else if (ocelot->bridge_fwd_mask & BIT(port)) {
+		} else if (ocelot_port->bridge) {
+			struct net_device *bridge = ocelot_port->bridge;
 			struct net_device *bond = ocelot_port->bond;
 
-			mask = ocelot->bridge_fwd_mask & ~BIT(port);
+			mask = ocelot_get_bridge_fwd_mask(ocelot, bridge);
+			mask &= ~BIT(port);
 			if (bond) {
 				mask &= ~ocelot_get_bond_mask(ocelot, bond,
 							      false);
@@ -985,29 +1007,16 @@ EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	u32 port_cfg;
-
-	if (!(BIT(port) & ocelot->bridge_mask))
-		return;
+	u32 learn_ena = 0;
 
-	port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, port);
+	ocelot_port->stp_state = state;
 
-	switch (state) {
-	case BR_STATE_FORWARDING:
-		ocelot->bridge_fwd_mask |= BIT(port);
-		fallthrough;
-	case BR_STATE_LEARNING:
-		if (ocelot_port->brport_flags & BR_LEARNING)
-			port_cfg |= ANA_PORT_PORT_CFG_LEARN_ENA;
-		break;
-
-	default:
-		port_cfg &= ~ANA_PORT_PORT_CFG_LEARN_ENA;
-		ocelot->bridge_fwd_mask &= ~BIT(port);
-		break;
-	}
+	if ((state == BR_STATE_LEARNING || state == BR_STATE_FORWARDING) &&
+	    ocelot_port->brport_flags & BR_LEARNING)
+		learn_ena = ANA_PORT_PORT_CFG_LEARN_ENA;
 
-	ocelot_write_gix(ocelot, port_cfg, ANA_PORT_PORT_CFG, port);
+	ocelot_rmw_gix(ocelot, learn_ena, ANA_PORT_PORT_CFG_LEARN_ENA,
+		       ANA_PORT_PORT_CFG, port);
 
 	ocelot_apply_bridge_fwd_mask(ocelot);
 }
@@ -1237,16 +1246,9 @@ EXPORT_SYMBOL(ocelot_port_mdb_del);
 int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 			    struct net_device *bridge)
 {
-	if (!ocelot->bridge_mask) {
-		ocelot->hw_bridge_dev = bridge;
-	} else {
-		if (ocelot->hw_bridge_dev != bridge)
-			/* This is adding the port to a second bridge, this is
-			 * unsupported */
-			return -ENODEV;
-	}
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
-	ocelot->bridge_mask |= BIT(port);
+	ocelot_port->bridge = bridge;
 
 	return 0;
 }
@@ -1259,10 +1261,7 @@ int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 	struct ocelot_vlan pvid = {0}, native_vlan = {0};
 	int ret;
 
-	ocelot->bridge_mask &= ~BIT(port);
-
-	if (!ocelot->bridge_mask)
-		ocelot->hw_bridge_dev = NULL;
+	ocelot_port->bridge = NULL;
 
 	ret = ocelot_port_vlan_filtering(ocelot, port, false);
 	if (ret)
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 6b6eb92149ba..c366d96fc945 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -694,7 +694,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		/* Everything we see on an interface that is in the HW bridge
 		 * has already been forwarded.
 		 */
-		if (ocelot->bridge_mask & BIT(info.port))
+		if (ocelot_port->bridge)
 			skb->offload_fwd_mark = 1;
 
 		skb->protocol = eth_type_trans(skb, dev);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index d8b4b1d3be15..333300b14a97 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -617,6 +617,9 @@ struct ocelot_port {
 
 	struct net_device		*bond;
 	bool				lag_tx_active;
+
+	struct net_device		*bridge;
+	u8				stp_state;
 };
 
 struct ocelot {
@@ -636,10 +639,6 @@ struct ocelot {
 	int				num_frame_refs;
 	int				num_mact_rows;
 
-	struct net_device		*hw_bridge_dev;
-	u16				bridge_mask;
-	u16				bridge_fwd_mask;
-
 	struct ocelot_port		**ports;
 
 	u8				base_mac[ETH_ALEN];
-- 
2.25.1

