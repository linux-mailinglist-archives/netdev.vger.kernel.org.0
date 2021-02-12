Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF0D31A17E
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhBLPT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbhBLPRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:17:36 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA96C061794;
        Fri, 12 Feb 2021 07:16:23 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id jj19so16280691ejc.4;
        Fri, 12 Feb 2021 07:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wTIzFT+PgPAUqTo/z74g0XCLg8NJH/Gc9vxgNHggcXA=;
        b=j2ztp3D8EyBGtVTgegygOT0NAWCPSBHP6CPhLleB+9JYjn9KZWysG1WJgM/5IBT4Yx
         TDmQtFSeN2ty7iyXmaSgslC6PyrmKSaxO7O3RT5xwU6rkMimNj4F5/35VJWNOAcPRSgm
         qwkHw24qjsCI1u8ZCZaxdbmGUnuq3MVWi1K/q+JMg5epDj5JJMGIzsH8GUo7KH/iEYCP
         XGSxLgvHQi9se3YU1wdpnSDNY+j5q+ns+M2sqKJtlzbwfBWHZXzcxd+78B/FG+nN3h4S
         KJhwOu5rmJ5BunUzK+TDXT0SRz53HnWmE9Fe+p3H0An+sfdej1NP1RtOYVLe52NdWFQe
         kwNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wTIzFT+PgPAUqTo/z74g0XCLg8NJH/Gc9vxgNHggcXA=;
        b=i8iIO+2ruiLiLbimlfZdN9xPOAlBgmbiZpgtYSmHyr+M3bZ2qHCMnZ1GiCS3GkvCHx
         CGal+C2Zy4bOwneUc9t9RX28VdvFiBtbKRBFq38W2i4ggmXNBOka5004fZcGX/FKJXtf
         C2JD2tukRWfrrJnxC9G/eX22zIhXx/KuEXZuFFGErVJQ9gubLrYoPlFLBzhrqOVOAbFt
         gIO9xUrG5ecO116rteBrlyz8l0hAc9Eq6JAygShnOHml09JGxdWMgZ1TbHEMxfrU1b+1
         Oqn0uhLrUGKrx7qV04iccvFus7Wx0UkYuAfxNdT+L6J5rrFkxi4M2KtfUefCkJZcL6zj
         T31Q==
X-Gm-Message-State: AOAM533pXdeSoVvGN99vaVDh9fVWk/XMBiixR20aSWDYNQn9VJy3+gWP
        mc26eosq8y2cDY0QlqSMKr8=
X-Google-Smtp-Source: ABdhPJwAcqlj3tCQcFrXdtEiEYP+BHzdpD8qcvhl5/nMbbusYajPEvXQZGZ20dHQ6Ud8dawAl0whOQ==
X-Received: by 2002:a17:907:ea3:: with SMTP id ho35mr3461618ejc.396.1613142982430;
        Fri, 12 Feb 2021 07:16:22 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z19sm6515456edr.69.2021.02.12.07.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 07:16:22 -0800 (PST)
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
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH v5 net-next 09/10] net: mscc: ocelot: offload bridge port flags to device
Date:   Fri, 12 Feb 2021 17:15:59 +0200
Message-Id: <20210212151600.3357121-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212151600.3357121-1-olteanv@gmail.com>
References: <20210212151600.3357121-1-olteanv@gmail.com>
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
everything, and also when the port joins and leaves the bridge.
The flood configuration was already configured ok for standalone mode
in ocelot_init, we just need to disable learning in ocelot_init_port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v5:
None.

Changes in v4:
- Applying the bridge port flags by hand at bridge join and leave, like
  DSA and other switchdev drivers.
- Put every bridge port flag in a separate function.
- Export ocelot_port_pre_bridge_flags for felix DSA to use.

Changes in v3:
None.

Changes in v2:
- Disable learning in ocelot_init_port.
- Keep a single bool ocelot_port->learn_ena instead of
  ocelot_port->brport_flags.
- Stop touching the brport_flags from ocelot_port_bridge_leave (which
  was a leftover).

 drivers/net/dsa/ocelot/felix.c         | 22 +++++++
 drivers/net/ethernet/mscc/ocelot.c     | 87 +++++++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_net.c | 49 +++++++++++++--
 include/soc/mscc/ocelot.h              |  5 ++
 4 files changed, 158 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 00b053d8294f..d3180b0f2307 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -556,6 +556,26 @@ static void felix_bridge_stp_state_set(struct dsa_switch *ds, int port,
 	return ocelot_bridge_stp_state_set(ocelot, port, state);
 }
 
+static int felix_pre_bridge_flags(struct dsa_switch *ds, int port,
+				  struct switchdev_brport_flags val,
+				  struct netlink_ext_ack *extack)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_pre_bridge_flags(ocelot, port, val);
+}
+
+static int felix_bridge_flags(struct dsa_switch *ds, int port,
+			      struct switchdev_brport_flags val,
+			      struct netlink_ext_ack *extack)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_bridge_flags(ocelot, port, val);
+
+	return 0;
+}
+
 static int felix_bridge_join(struct dsa_switch *ds, int port,
 			     struct net_device *br)
 {
@@ -1376,6 +1396,8 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_fdb_del			= felix_fdb_del,
 	.port_mdb_add			= felix_mdb_add,
 	.port_mdb_del			= felix_mdb_del,
+	.port_pre_bridge_flags		= felix_pre_bridge_flags,
+	.port_bridge_flags		= felix_bridge_flags,
 	.port_bridge_join		= felix_bridge_join,
 	.port_bridge_leave		= felix_bridge_leave,
 	.port_lag_join			= felix_lag_join,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 1a31598e2ae6..d1a9cdbf7a3e 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1038,6 +1038,7 @@ EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
 
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 port_cfg;
 
 	if (!(BIT(port) & ocelot->bridge_mask))
@@ -1050,7 +1051,8 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 		ocelot->bridge_fwd_mask |= BIT(port);
 		fallthrough;
 	case BR_STATE_LEARNING:
-		port_cfg |= ANA_PORT_PORT_CFG_LEARN_ENA;
+		if (ocelot_port->learn_ena)
+			port_cfg |= ANA_PORT_PORT_CFG_LEARN_ENA;
 		break;
 
 	default:
@@ -1534,6 +1536,86 @@ int ocelot_get_max_mtu(struct ocelot *ocelot, int port)
 }
 EXPORT_SYMBOL(ocelot_get_max_mtu);
 
+static void ocelot_port_set_learning(struct ocelot *ocelot, int port,
+				     bool enabled)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u32 val = 0;
+
+	if (enabled)
+		val = ANA_PORT_PORT_CFG_LEARN_ENA;
+
+	ocelot_rmw_gix(ocelot, val, ANA_PORT_PORT_CFG_LEARN_ENA,
+		       ANA_PORT_PORT_CFG, port);
+
+	ocelot_port->learn_ena = enabled;
+}
+
+static void ocelot_port_set_ucast_flood(struct ocelot *ocelot, int port,
+					bool enabled)
+{
+	u32 val = 0;
+
+	if (enabled)
+		val = BIT(port);
+
+	ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_UC);
+}
+
+static void ocelot_port_set_mcast_flood(struct ocelot *ocelot, int port,
+					bool enabled)
+{
+	u32 val = 0;
+
+	if (enabled)
+		val = BIT(port);
+
+	ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_MC);
+}
+
+static void ocelot_port_set_bcast_flood(struct ocelot *ocelot, int port,
+					bool enabled)
+{
+	u32 val = 0;
+
+	if (enabled)
+		val = BIT(port);
+
+	ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_BC);
+}
+
+int ocelot_port_pre_bridge_flags(struct ocelot *ocelot, int port,
+				 struct switchdev_brport_flags flags)
+{
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
+			   BR_BCAST_FLOOD))
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_port_pre_bridge_flags);
+
+void ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
+			      struct switchdev_brport_flags flags)
+{
+	if (flags.mask & BR_LEARNING)
+		ocelot_port_set_learning(ocelot, port,
+					 !!(flags.val & BR_LEARNING));
+
+	if (flags.mask & BR_FLOOD)
+		ocelot_port_set_ucast_flood(ocelot, port,
+					    !!(flags.val & BR_FLOOD));
+
+	if (flags.mask & BR_MCAST_FLOOD)
+		ocelot_port_set_mcast_flood(ocelot, port,
+					    !!(flags.val & BR_MCAST_FLOOD));
+
+	if (flags.mask & BR_BCAST_FLOOD)
+		ocelot_port_set_bcast_flood(ocelot, port,
+					    !!(flags.val & BR_BCAST_FLOOD));
+}
+EXPORT_SYMBOL(ocelot_port_bridge_flags);
+
 void ocelot_init_port(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -1583,6 +1665,9 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 		       REW_PORT_VLAN_CFG_PORT_TPID_M,
 		       REW_PORT_VLAN_CFG, port);
 
+	/* Disable source address learning for standalone mode */
+	ocelot_port_set_learning(ocelot, port, false);
+
 	/* Enable vcap lookups */
 	ocelot_vcap_enable(ocelot, port);
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index f9da4aa39444..b5ffe6724eb7 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1026,6 +1026,13 @@ static int ocelot_port_attr_set(struct net_device *dev,
 	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
 		ocelot_port_attr_mc_set(ocelot, port, !attr->u.mc_disabled);
 		break;
+	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
+		err = ocelot_port_pre_bridge_flags(ocelot, port,
+						   attr->u.brport_flags);
+		break;
+	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		ocelot_port_bridge_flags(ocelot, port, attr->u.brport_flags);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
@@ -1111,6 +1118,40 @@ static int ocelot_port_obj_del(struct net_device *dev,
 	return ret;
 }
 
+static int ocelot_netdevice_bridge_join(struct ocelot *ocelot, int port,
+					struct net_device *bridge)
+{
+	struct switchdev_brport_flags flags;
+	int err;
+
+	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
+	flags.val = flags.mask;
+
+	err = ocelot_port_bridge_join(ocelot, port, bridge);
+	if (err)
+		return err;
+
+	ocelot_port_bridge_flags(ocelot, port, flags);
+
+	return 0;
+}
+
+static int ocelot_netdevice_bridge_leave(struct ocelot *ocelot, int port,
+					 struct net_device *bridge)
+{
+	struct switchdev_brport_flags flags;
+	int err;
+
+	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
+	flags.val = flags.mask & ~BR_LEARNING;
+
+	err = ocelot_port_bridge_leave(ocelot, port, bridge);
+
+	ocelot_port_bridge_flags(ocelot, port, flags);
+
+	return err;
+}
+
 static int ocelot_netdevice_changeupper(struct net_device *dev,
 					struct netdev_notifier_changeupper_info *info)
 {
@@ -1122,11 +1163,11 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
 
 	if (netif_is_bridge_master(info->upper_dev)) {
 		if (info->linking) {
-			err = ocelot_port_bridge_join(ocelot, port,
-						      info->upper_dev);
+			err = ocelot_netdevice_bridge_join(ocelot, port,
+							   info->upper_dev);
 		} else {
-			err = ocelot_port_bridge_leave(ocelot, port,
-						       info->upper_dev);
+			err = ocelot_netdevice_bridge_leave(ocelot, port,
+							    info->upper_dev);
 		}
 	}
 	if (netif_is_lag_master(info->upper_dev)) {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 9acbef1416f1..40792b37bb9f 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -612,6 +612,7 @@ struct ocelot_port {
 
 	u8				*xmit_template;
 	bool				is_dsa_8021q_cpu;
+	bool				learn_ena;
 
 	struct net_device		*bond;
 	bool				lag_tx_active;
@@ -766,6 +767,10 @@ void ocelot_adjust_link(struct ocelot *ocelot, int port,
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled);
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state);
 void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot);
+int ocelot_port_pre_bridge_flags(struct ocelot *ocelot, int port,
+				 struct switchdev_brport_flags val);
+void ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
+			      struct switchdev_brport_flags val);
 int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 			    struct net_device *bridge);
 int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
-- 
2.25.1

