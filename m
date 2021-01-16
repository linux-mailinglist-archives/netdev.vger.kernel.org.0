Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EDD2F8A2F
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbhAPBCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbhAPBB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:01:59 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06436C0617A1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:51 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id hs11so13505710ejc.1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=37LfDkexTqbGj/RF1ETXVQpjIqqqNvve6EvhfPw+lnQ=;
        b=luryd/zG3KZN12C2MxZBUxIM5j3Naw8xalJl2WOSLdZVrgGuP5ZGGQLXs/fkt7NC3F
         7b3W0A66S/dXD2RQxDk3s6eISMRxhgulgMiw/IAI/aEK5+8vX6rRDeuMiYxPseV1Jm9k
         pAGFDE0BUMbl8pUvGuih5IQ0eKcRo8L11La8KNqT+38KLYOd6iwsdIl6iXID2Phb//YH
         lxNe018FjK5+iTpuvRt55g+goMzf5OfcYgVeY0rBD8R+5JK7odzivWl42x9i0fjGXKgU
         VIPe0D6NIXYdbJF5bngnsJFiCQG3PVgTXNyDrOuS1SFCtyVOsYhaNMROqIC0ukZxPqtO
         qwAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=37LfDkexTqbGj/RF1ETXVQpjIqqqNvve6EvhfPw+lnQ=;
        b=R9wibvM1B2PWsVUxsnZMf3ZrpUfmZfKut7xMw1M6zAV61rOQPjqcZY5wm65tGgW0+Z
         aSQtOihgA/O4MckRFjRV1wLAcFNcHuwt1t2+2f59jhXwx7HTsZSxT40uafLf+s/7dM4X
         LMEZXGe62lwRNVnY6Du9+4DtqMHLUEdca7GSs2tqWeoYW+U0Y5kyW4w9h0xwJegBjQhy
         voisYiqFFw64tqveXXUmgXtzTsgODN6Vn8MqC7eXxI/YyMo1s3iHAj8sGxEpSS2Q/35P
         d4xiSkOg6ropyYsZGQDZj8TPRukxQxNb8BAlDBbOdYwJYqzSwpSLpwzMK9KjQSkyhNaz
         A8Ng==
X-Gm-Message-State: AOAM532/D+pE2gMlthOjUP87zcSvWQOUf6r84uJOcmy0hGV8gmHMxI7K
        wJ5FSnLoDrLAS/Uq+Bb78tk=
X-Google-Smtp-Source: ABdhPJy8GTR6wfRa+8JyrZZEojZV2Rq0wMT2l1fjCK50/Z0Zr2891r7xI+7KBoukFuWFm9TWz+OYAw==
X-Received: by 2002:a17:907:3e04:: with SMTP id hp4mr7851569ejc.188.1610758849690;
        Fri, 15 Jan 2021 17:00:49 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k3sm5666655eds.87.2021.01.15.17.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:00:49 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH v2 net-next 13/14] net: mscc: ocelot: rebalance LAGs on link up/down events
Date:   Sat, 16 Jan 2021 02:59:42 +0200
Message-Id: <20210116005943.219479-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116005943.219479-1-olteanv@gmail.com>
References: <20210116005943.219479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

At present there is an issue when ocelot is offloading a bonding
interface, but one of the links of the physical ports goes down. Traffic
keeps being hashed towards that destination, and of course gets dropped
on egress.

Monitor the netdev notifier events emitted by the bonding driver for
changes in the physical state of lower interfaces, to determine which
ports are active and which ones are no longer.

Then extend ocelot_get_bond_mask to return either the configured bonding
interfaces, or the active ones, depending on a boolean argument. The
code that does rebalancing only needs to do so among the active ports,
whereas the bridge forwarding mask and the logical port IDs still need
to look at the permanently bonded ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
- Adapt to the merged version of the DSA API, which now passes just a
  bool lag_tx_active in .port_lag_change instead of the full struct
  netdev_lag_lower_state_info *info.
- Renamed "just_active_ports" -> "only_active_ports"

 drivers/net/ethernet/mscc/ocelot.c     | 38 ++++++++++++++++++++------
 drivers/net/ethernet/mscc/ocelot.h     |  1 +
 drivers/net/ethernet/mscc/ocelot_net.c | 30 ++++++++++++++++++++
 include/soc/mscc/ocelot.h              |  1 +
 4 files changed, 61 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 78a468d39e9b..c31a63d9fe2a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -876,7 +876,8 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
-static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
+static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
+				bool only_active_ports)
 {
 	u32 bond_mask = 0;
 	int port;
@@ -887,8 +888,12 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 		if (!ocelot_port)
 			continue;
 
-		if (ocelot_port->bond == bond)
+		if (ocelot_port->bond == bond) {
+			if (only_active_ports && !ocelot_port->lag_tx_active)
+				continue;
+
 			bond_mask |= BIT(port);
+		}
 	}
 
 	return bond_mask;
@@ -914,7 +919,7 @@ static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 			struct net_device *bond = ocelot_port->bond;
 
 			if (bond)
-				mask &= ~ocelot_get_bond_mask(ocelot, bond);
+				mask &= ~ocelot_get_bond_mask(ocelot, bond, false);
 
 			ocelot_write_rix(ocelot, mask,
 					 ANA_PGID_PGID, PGID_SRC + port);
@@ -1242,22 +1247,22 @@ static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
 		bonds[port] = ocelot_port->bond;
 	}
 
-	/* Now, set PGIDs for each LAG */
+	/* Now, set PGIDs for each active LAG */
 	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
-		int num_ports_in_lag = 0;
+		int num_active_ports = 0;
 		unsigned long bond_mask;
 		u8 aggr_idx[16];
 
 		if (!bonds[lag])
 			continue;
 
-		bond_mask = ocelot_get_bond_mask(ocelot, bonds[lag]);
+		bond_mask = ocelot_get_bond_mask(ocelot, bonds[lag], true);
 
 		for_each_set_bit(port, &bond_mask, ocelot->num_phys_ports) {
 			// Destination mask
 			ocelot_write_rix(ocelot, bond_mask,
 					 ANA_PGID_PGID, port);
-			aggr_idx[num_ports_in_lag++] = port;
+			aggr_idx[num_active_ports++] = port;
 		}
 
 		for_each_aggr_pgid(ocelot, i) {
@@ -1265,7 +1270,11 @@ static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
 
 			ac = ocelot_read_rix(ocelot, ANA_PGID_PGID, i);
 			ac &= ~bond_mask;
-			ac |= BIT(aggr_idx[i % num_ports_in_lag]);
+			/* Don't do division by zero if there was no active
+			 * port. Just make all aggregation codes zero.
+			 */
+			if (num_active_ports)
+				ac |= BIT(aggr_idx[i % num_active_ports]);
 			ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);
 		}
 
@@ -1301,7 +1310,8 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 
 		bond = ocelot_port->bond;
 		if (bond) {
-			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
+			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond,
+							     false));
 
 			ocelot_rmw_gix(ocelot,
 				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
@@ -1342,6 +1352,16 @@ int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_port_lag_leave);
 
+int ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	ocelot_port->lag_tx_active = lag_tx_active;
+
+	/* Rebalance the LAGs */
+	return ocelot_set_aggr_pgids(ocelot);
+}
+
 /* Configure the maximum SDU (L2 payload) on RX to the value specified in @sdu.
  * The length of VLAN tags is accounted for automatically via DEV_MAC_TAGS_CFG.
  * In the special case that it's the NPI port that we're configuring, the
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index c018a54f4e49..fc055525fd88 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -114,6 +114,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct netdev_lag_upper_info *info);
 int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			  struct net_device *bond);
+int ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active);
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
 int ocelot_netdev_to_port(struct net_device *dev);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 871bfbaa8ff1..3cba1c2de6fe 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1163,6 +1163,27 @@ ocelot_netdevice_lag_changeupper(struct net_device *dev,
 	return NOTIFY_DONE;
 }
 
+static int
+ocelot_netdevice_changelowerstate(struct net_device *dev,
+				  struct netdev_lag_lower_state_info *info)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	bool is_active = info->link_up && info->tx_enabled;
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = priv->chip_port;
+	int err;
+
+	if (!ocelot_port->bond)
+		return NOTIFY_DONE;
+
+	if (ocelot_port->lag_tx_active == is_active)
+		return 0;
+
+	err = ocelot_port_lag_change(ocelot, port, is_active);
+	return notifier_from_errno(err);
+}
+
 static int ocelot_netdevice_event(struct notifier_block *unused,
 				  unsigned long event, void *ptr)
 {
@@ -1180,6 +1201,15 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 
 		break;
 	}
+	case NETDEV_CHANGELOWERSTATE: {
+		struct netdev_notifier_changelowerstate_info *info = ptr;
+
+		if (!ocelot_netdevice_dev_check(dev))
+			break;
+
+		return ocelot_netdevice_changelowerstate(dev,
+							 info->lower_state_info);
+	}
 	default:
 		break;
 	}
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 1bb16527f490..7bd7c58a7490 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -612,6 +612,7 @@ struct ocelot_port {
 	u8				*xmit_template;
 
 	struct net_device		*bond;
+	bool				lag_tx_active;
 };
 
 struct ocelot {
-- 
2.25.1

