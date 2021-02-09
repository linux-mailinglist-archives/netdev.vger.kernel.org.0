Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF34C3152B1
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 16:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbhBIPYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 10:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbhBIPVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 10:21:15 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0DAC0617AA;
        Tue,  9 Feb 2021 07:20:09 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id l12so24224122edt.3;
        Tue, 09 Feb 2021 07:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c1pny1b48sKsEbv6rVca01Eti9d/VIqA4FzxKGgQlq4=;
        b=vcFoijkidJ20uNV3aDzXVPrjCU4zs5QjLtUa60SHWFEa6BF21dbTUPaigA/DOzmhlE
         E6sUWNhwjwGtpckjo5LMVlIzibXzo78fjwRwFkHROeMYIGD195XEyei8voJU7vySmPVk
         +qBV98PSZXdA/ddnImEvMp0CJnUXMeOr6BJ+mD/R0XLpkTyX5+irjwv7p2vOLjC3B21L
         eg7iUhhbPAvrQLRKv0KI3TJkGzmO4dnNblA30YbChiW0cdfxX5cMz8nE4ygtEnmlRZjJ
         KeIVTTugS91l36q00sHQ9NdkLhcpGy8NjrP+3tAWj+Z5+YztVm2i03oLKqP9CvmTtXzs
         afEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c1pny1b48sKsEbv6rVca01Eti9d/VIqA4FzxKGgQlq4=;
        b=MmchX7CpuYnuxl3xc+V4I30qT1XTpAIxXP6fCfUj2TImgc3WTDX3GLtyYYTYz6wpQ2
         Xe8dzirj71lcq+JlV1YnWQEljAcpeUx/UXr3BfD05OB3qWAaMjPf+RdoFIfSSlHMA7WB
         PsFaS9ae6xXC3SdIbbDR8QHQDAjHpg7T9VQXDYWbRRgx7K4+s0PLJqSoADlyWBCwF8fx
         xBsAiH+zIfwoqXrm94xliqVZyme9IcqdlRJ5ibin3mUn2odGh4JVFOlZ5U+/9YVlufiG
         9SF6rQlVqvHggtbtH2aj7Dz6o5g179JNsRJfYc5hjUKaHRbUQr4Fp0SyA2KW9PVWo0hg
         surA==
X-Gm-Message-State: AOAM530iCBAbyyq7hgA1EMnqsrHHyx1vRZGzd6IIc258qjNwO9dtlCYh
        Gelwr+F0qKwxGtyc1qro0HA=
X-Google-Smtp-Source: ABdhPJxjUOMVnIadWENCQNO/1uV1fV9SI3kApXJ2sBNU2CekcqmAiIVPQ0K0dH5p40TKoPWBCn9bPA==
X-Received: by 2002:a50:cf02:: with SMTP id c2mr23230333edk.333.1612884008308;
        Tue, 09 Feb 2021 07:20:08 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q2sm11686108edv.93.2021.02.09.07.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 07:20:06 -0800 (PST)
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
Subject: [PATCH v2 net-next 10/11] net: mscc: ocelot: offload bridge port flags to device
Date:   Tue,  9 Feb 2021 17:19:35 +0200
Message-Id: <20210209151936.97382-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209151936.97382-1-olteanv@gmail.com>
References: <20210209151936.97382-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

We should not be unconditionally enabling address learning, since doing
that is actively detrimential when a port is standalone and not offloading
a bridge. Namely, if a port in the switch is standalone and others are
offloading the bridge, then we could enter a situation where we learn an
address towards the standalone port, but the bridged ports could not
forward the packet there, because the CPU is the only path between the
standalone and the bridged ports. The solution of course is to not
enable address learning unless the bridge asks for it.

We need to set up the initial port flags for no learning and flooding
everything, then the bridge takes over. The flood configuration was
already configured ok in ocelot_init, we just need to disable learning
in ocelot_init_port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v2:
- Disable learning in ocelot_init_port.
- Keep a single bool ocelot_port->learn_ena instead of
  ocelot_port->brport_flags.
- Stop touching the brport_flags from ocelot_port_bridge_leave (which
  was a leftover).

 drivers/net/dsa/ocelot/felix.c         | 10 +++++
 drivers/net/ethernet/mscc/ocelot.c     | 59 +++++++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_net.c |  4 ++
 include/soc/mscc/ocelot.h              |  3 ++
 4 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 1bd5aea12b25..4ff18415ef95 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -553,6 +553,15 @@ static void felix_bridge_stp_state_set(struct dsa_switch *ds, int port,
 	return ocelot_bridge_stp_state_set(ocelot, port, state);
 }
 
+static int felix_bridge_flags(struct dsa_switch *ds, int port,
+			      struct switchdev_brport_flags val,
+			      struct netlink_ext_ack *extack)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_bridge_flags(ocelot, port, val);
+}
+
 static int felix_bridge_join(struct dsa_switch *ds, int port,
 			     struct net_device *br)
 {
@@ -1358,6 +1367,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_fdb_del			= felix_fdb_del,
 	.port_mdb_add			= felix_mdb_add,
 	.port_mdb_del			= felix_mdb_del,
+	.port_bridge_flags		= felix_bridge_flags,
 	.port_bridge_join		= felix_bridge_join,
 	.port_bridge_leave		= felix_bridge_leave,
 	.port_lag_join			= felix_lag_join,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 8c1052346b58..65bc7d59d2c9 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -984,6 +984,7 @@ EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
 
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 port_cfg;
 
 	if (!(BIT(port) & ocelot->bridge_mask))
@@ -996,7 +997,8 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 		ocelot->bridge_fwd_mask |= BIT(port);
 		fallthrough;
 	case BR_STATE_LEARNING:
-		port_cfg |= ANA_PORT_PORT_CFG_LEARN_ENA;
+		if (ocelot_port->learn_ena)
+			port_cfg |= ANA_PORT_PORT_CFG_LEARN_ENA;
 		break;
 
 	default:
@@ -1480,6 +1482,57 @@ int ocelot_get_max_mtu(struct ocelot *ocelot, int port)
 }
 EXPORT_SYMBOL(ocelot_get_max_mtu);
 
+int ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
+			     struct switchdev_brport_flags flags)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
+			   BR_BCAST_FLOOD))
+		return -EINVAL;
+
+	if (flags.mask & BR_LEARNING) {
+		u32 val = 0;
+
+		ocelot_port->learn_ena = !!(flags.val & BR_LEARNING);
+		if (ocelot_port->learn_ena)
+			val = ANA_PORT_PORT_CFG_LEARN_ENA;
+
+		ocelot_rmw_gix(ocelot, val, ANA_PORT_PORT_CFG_LEARN_ENA,
+			       ANA_PORT_PORT_CFG, port);
+	}
+
+	if (flags.mask & BR_FLOOD) {
+		u32 val = 0;
+
+		if (flags.val & BR_FLOOD)
+			val = BIT(port);
+
+		ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_UC);
+	}
+
+	if (flags.mask & BR_MCAST_FLOOD) {
+		u32 val = 0;
+
+		if (flags.val & BR_MCAST_FLOOD)
+			val = BIT(port);
+
+		ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_MC);
+	}
+
+	if (flags.mask & BR_BCAST_FLOOD) {
+		u32 val = 0;
+
+		if (flags.val & BR_BCAST_FLOOD)
+			val = BIT(port);
+
+		ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_BC);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_port_bridge_flags);
+
 void ocelot_init_port(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -1524,6 +1577,10 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 		       ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA,
 		       ANA_PORT_DROP_CFG, port);
 
+	/* Disable source address learning for standalone mode */
+	ocelot_rmw_gix(ocelot, 0, ANA_PORT_PORT_CFG_LEARN_ENA,
+		       ANA_PORT_PORT_CFG, port);
+
 	/* Set default VLAN and tag type to 8021Q. */
 	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_TPID(ETH_P_8021Q),
 		       REW_PORT_VLAN_CFG_PORT_TPID_M,
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index f9da4aa39444..9944d79c6685 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1026,6 +1026,10 @@ static int ocelot_port_attr_set(struct net_device *dev,
 	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
 		ocelot_port_attr_mc_set(ocelot, port, !attr->u.mc_disabled);
 		break;
+	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		err = ocelot_port_bridge_flags(ocelot, port,
+					       attr->u.brport_flags);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 7ee85527cb5f..e6aacf65fa1e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -612,6 +612,7 @@ struct ocelot_port {
 
 	u8				*xmit_template;
 	bool				is_dsa_8021q_cpu;
+	bool				learn_ena;
 
 	struct net_device		*bond;
 	bool				lag_tx_active;
@@ -764,6 +765,8 @@ void ocelot_adjust_link(struct ocelot *ocelot, int port,
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled);
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state);
 void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot);
+int ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
+			     struct switchdev_brport_flags val);
 int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 			    struct net_device *bridge);
 int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
-- 
2.25.1

