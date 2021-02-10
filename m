Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E345831622A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhBJJ1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhBJJVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:21:36 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9855C061356;
        Wed, 10 Feb 2021 01:19:30 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id f14so2789870ejc.8;
        Wed, 10 Feb 2021 01:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WVxLiMT9g68m/JVM6MaJZIJ5oyzOL2cDAhgE0vgYmTU=;
        b=JVL++JG/GA5Jio0pPuO1J8OXFfjurMuWG7TZSwBB6wuP2lT1bKrV4ck3jIistiHCTC
         hs/zHmu/FvdMbauJ5P3AylYCSZCCOFhHPYFERyIfDhNXJN4lEWJWhIYE0C5CF98fJnoR
         unyY4jMzqKzD1q3N4a+riEnRgF0RceTjCmy5+XK5GWZtmP2Lc96U4HKIi/OE4GioBEp6
         wdB/0NI/vY9+I3C8W9NWvGN3YZNfxI3Gt7QWzhXrySzIjyQkFqAFfrSFBrj3SNGURIhI
         hGXmRJMHK/1kMFAyfPkwehNWIOy6ynD4Bp+IjCxmd+bCxkUwUaMrYF2UBGzJvP9KxE3D
         Hdkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WVxLiMT9g68m/JVM6MaJZIJ5oyzOL2cDAhgE0vgYmTU=;
        b=Jn8QgT74mkoVjjrt+k5P5+o8Pc9rBHN+y6cRYEqBoUlYTIoekvexEtuUY7cn+moXDT
         Qrn933nYq1KgcVSf8BqFUTeyamgekd7gbP+CfAkrV2fxvWiZdaIphjwzxHluBuO+kBNg
         mTlaaYlhUedN7JAd5FYTl5vNPd01T00Ycr6BirtCf7ZV5EG9BZ3cN4hf3tTB7k9aQlQF
         +KS5KK/JiJ5QJF42ZMNEx7hxMWUIHne3UsN2wpgeG9+SsOXKXeUA8rOsM5uVgAttuYSm
         V18N96TCttvukiXHum/dEXZyVDx+/581FT8ciwY8otwIEidc3Pbzoo7GUooSi3LCKytT
         NH2g==
X-Gm-Message-State: AOAM532CKOFFojm4e6bn1ydI7sOWc8Ih/urG7PTUga4xhJnQ8X+WZMFT
        NrP5PF9DfU2wwabNVgk/c0s=
X-Google-Smtp-Source: ABdhPJyvNPDuPLMCpocQmKoAszPM1yjqQJyU+kXeP1/WDpXwng3BHt5Det/7xKiU1msWkcVGg+v0LQ==
X-Received: by 2002:a17:906:398c:: with SMTP id h12mr2005821eje.469.1612948769514;
        Wed, 10 Feb 2021 01:19:29 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u2sm701801ejb.65.2021.02.10.01.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 01:19:28 -0800 (PST)
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
Subject: [PATCH v3 net-next 10/11] net: mscc: ocelot: offload bridge port flags to device
Date:   Wed, 10 Feb 2021 11:14:44 +0200
Message-Id: <20210210091445.741269-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210091445.741269-1-olteanv@gmail.com>
References: <20210210091445.741269-1-olteanv@gmail.com>
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
Changes in v3:
None.

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

