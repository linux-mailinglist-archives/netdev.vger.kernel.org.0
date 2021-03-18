Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FEA3410E5
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbhCRXTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbhCRXTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:19:01 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E87C06174A;
        Thu, 18 Mar 2021 16:19:01 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id o19so8704806edc.3;
        Thu, 18 Mar 2021 16:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0n6RVIMy61f+SBbaXZIOPzctcUf7WXfwiPthV/9bGvI=;
        b=s6G6P983viOiYLkEW6GHi+lQJ2UfYmmIdFJi73bZKHA+QUlDCRIrucrOEqwWKxNFPb
         6HEy2N7diJXhG9yg2sLqf/g+58Nu7zfLtjMAYARGgW50AE2nHFTEF15TtIJMNILPiqrT
         Z5Z4f1BvD3hJ5CihJvYSJ9rczTbt7Z6b4QSWXRjG74SFVbBqtasjDFmA30MljRLhhk3H
         9qE/ZgiXu6D67LmF7g3JTvT2skttfoHUD2Fo148CF9iKhoUrgBShTZP3AewXe6UQN/Sy
         fmXVwQtOlgY51yGwE0cxCkNsqVQPwNdAAdgoads8w27d5OWJcGMVU7/mwzZbHqzNCLD1
         CbYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0n6RVIMy61f+SBbaXZIOPzctcUf7WXfwiPthV/9bGvI=;
        b=ARJITbbp1gQo1c9pUQ6elZI5SzJuDkzClstwv5JEC8/L97xORXE2F5rJj5RSk66bf7
         7J+Z404q37XhxXwrAff4Jote5IpZ2WUX5Gd/BT0wXprx2e/8CeQ8anwkZmi/uQTu+vG5
         F4/4xMvx/QqZsIqrLdjxIJHEeThq5EnPzbd+a1R6qDG7f+yIOzxg9pOSOK0wkwSQroxE
         sDGRh26Afjv1S82jkNBZWhsJrurz0eqCvPkWy3jyt2jmAj+tTlGmQpmYCKLFGI6ZaupX
         lhm39HXN6J5WKFNh9SMJNVBr7tOFBHb/dO9+wcIqDJJLtMVXIC0Tm0EcFqs7KevO9uLA
         XaAA==
X-Gm-Message-State: AOAM533EB+bt0N8YYtrh1ggc1dGsR2GQH3AVC4SYsfovyXmHbYg8mloe
        LgyQ5/eIrvMQjZZuIjjTDH0=
X-Google-Smtp-Source: ABdhPJwGRWqqSwXrnEcca0FrNI2AJX+eLrWMb+zkndJwNb3/SZpWbWXCUnIqcrN9hamDPyDjWwMSCw==
X-Received: by 2002:aa7:d287:: with SMTP id w7mr6423487edq.23.1616109539908;
        Thu, 18 Mar 2021 16:18:59 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bx24sm2801131ejc.88.2021.03.18.16.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:18:59 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 11/16] net: ocelot: support multiple bridges
Date:   Fri, 19 Mar 2021 01:18:24 +0200
Message-Id: <20210318231829.3892920-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318231829.3892920-1-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
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

We actually need this change now because we need to remove the bogus
restriction from ocelot_bridge_stp_state_set that ocelot->bridge_mask
needs to contain BIT(port), otherwise that function is a no-op.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 72 +++++++++++++++---------------
 include/soc/mscc/ocelot.h          |  7 ++-
 2 files changed, 39 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 9f0c9bdd9f5d..ce57929ba3d1 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -766,7 +766,7 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
 	/* Everything we see on an interface that is in the HW bridge
 	 * has already been forwarded.
 	 */
-	if (ocelot->bridge_mask & BIT(src_port))
+	if (ocelot->ports[src_port]->bridge)
 		skb->offload_fwd_mark = 1;
 
 	skb->protocol = eth_type_trans(skb, dev);
@@ -1183,6 +1183,26 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
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
@@ -1232,10 +1252,12 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
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
@@ -1256,29 +1278,16 @@ EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
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
-		if (ocelot_port->learn_ena)
-			port_cfg |= ANA_PORT_PORT_CFG_LEARN_ENA;
-		break;
-
-	default:
-		port_cfg &= ~ANA_PORT_PORT_CFG_LEARN_ENA;
-		ocelot->bridge_fwd_mask &= ~BIT(port);
-		break;
-	}
+	if ((state == BR_STATE_LEARNING || state == BR_STATE_FORWARDING) &&
+	    ocelot_port->learn_ena)
+		learn_ena = ANA_PORT_PORT_CFG_LEARN_ENA;
 
-	ocelot_write_gix(ocelot, port_cfg, ANA_PORT_PORT_CFG, port);
+	ocelot_rmw_gix(ocelot, learn_ena, ANA_PORT_PORT_CFG_LEARN_ENA,
+		       ANA_PORT_PORT_CFG, port);
 
 	ocelot_apply_bridge_fwd_mask(ocelot);
 }
@@ -1508,16 +1517,9 @@ EXPORT_SYMBOL(ocelot_port_mdb_del);
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
@@ -1526,13 +1528,11 @@ EXPORT_SYMBOL(ocelot_port_bridge_join);
 int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 			     struct net_device *bridge)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct ocelot_vlan pvid = {0}, native_vlan = {0};
 	int ret;
 
-	ocelot->bridge_mask &= ~BIT(port);
-
-	if (!ocelot->bridge_mask)
-		ocelot->hw_bridge_dev = NULL;
+	ocelot_port->bridge = NULL;
 
 	ret = ocelot_port_vlan_filtering(ocelot, port, false);
 	if (ret)
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 0a0751bf97dd..ce7e5c1bd90d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -615,6 +615,9 @@ struct ocelot_port {
 	bool				lag_tx_active;
 
 	u16				mrp_ring_id;
+
+	struct net_device		*bridge;
+	u8				stp_state;
 };
 
 struct ocelot {
@@ -634,10 +637,6 @@ struct ocelot {
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

