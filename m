Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD396312846
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 00:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhBGXYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 18:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhBGXYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 18:24:22 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA3EC06178C;
        Sun,  7 Feb 2021 15:23:12 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id c6so16128248ede.0;
        Sun, 07 Feb 2021 15:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zlz7bjVNF9/MTX7P6d7PFu82V+wVVk03D7gELioz3RY=;
        b=tMDU8Wau3BKsMIp9zSNU/vVpu+R9i2v5rNtpE8xgVw3O04otVqldC+qBpIgjtrM9sM
         8YzamjttyJX6ZozN9YFwYaffPKwUEL2+2RmLGyVqlc2Co6WplGPiFFqJhV+gAZZ3Aw+V
         0T3bXSXKqrhwZPxoMy5c0ZQZ42w0dMACrsxlkbYmzBPI8Y0oxtvmLeykYEDJSHBTga4z
         GaCeiUdEMrIHo44rbg2q893+K9vXg1bptLGxpC1DUi66rrtJdCyjaYcNTtikjzIHa3x4
         TFYsKl6Jl/ASk27RZ6Wsq6TxN967sZfZ0HPgRqVP6ZGF/vAVJw6Ca/EJk+0fZpJFYHLm
         wcHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zlz7bjVNF9/MTX7P6d7PFu82V+wVVk03D7gELioz3RY=;
        b=lh9r5++7B8yYc6FlqQiLsP7ORNHucdmQW8Ym2rUUD506jzINMXXux0nbL8LLwJ/HFG
         QcWTgbPSI5IAinPT0WXz2XLwIL7wbpMoF8fUJs0Rw+Hrz+Wruu1aBjrAH4+I1oKrDoS7
         vh1qmdZTLF0ePu2p+r5CO3kbg/iQfAGTVNQVkIKdN5md8yTYh+oBNISxvU9YMuNyALfK
         8jvvwS2muu4USVDN/oiD11sCE8L6txd8NapZmCbaeuQY6T2EwFF88Wlob9w91gJ3cioB
         0KLuyDyVkv6KWEdYd5EZLQ9MA048SGsNbQA1bCWF2/Ek+vSYXMBhZfOzO4KcTD4GbS6k
         wqQw==
X-Gm-Message-State: AOAM533Dd9j9ImX9jd3MT0EL0iRocsFfyBXlm3cw+00cgCnZdA4vZMLY
        4XkPEAhRAwXQCHZuLMUqMGY=
X-Google-Smtp-Source: ABdhPJxgzqTjUTCIDYBHxdkJMnbe3ghH40nIGmdkZebswQtc5VMcvBx98km6RP5J4YgzpzNH+oyxhw==
X-Received: by 2002:a05:6402:4253:: with SMTP id g19mr14532932edb.343.1612740190870;
        Sun, 07 Feb 2021 15:23:10 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u21sm7540016ejj.120.2021.02.07.15.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 15:23:10 -0800 (PST)
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
Subject: [PATCH net-next 5/9] net: squash switchdev attributes PRE_BRIDGE_FLAGS and BRIDGE_FLAGS
Date:   Mon,  8 Feb 2021 01:21:37 +0200
Message-Id: <20210207232141.2142678-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207232141.2142678-1-olteanv@gmail.com>
References: <20210207232141.2142678-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There does not appear to be any strong reason why
br_switchdev_set_port_flag issues a separate notification for checking
the supported brport flags rather than just attempting to apply them and
propagating the error if that fails.

However, there is a reason why this switchdev API is counterproductive
for a driver writer, and that is because although br_switchdev_set_port_flag
gets passed a "flags" and a "mask", those are passed piecemeal to the
driver, so while the PRE_BRIDGE_FLAGS listener knows what changed
because it has the "mask", the BRIDGE_FLAGS listener doesn't, because it
only has the final value. This means that "edge detection" needs to be
done by each individual BRIDGE_FLAGS listener by XOR-ing the old and the
new flags, which in turn means that copying the flags into a driver
private variable is strictly necessary.

This can be solved by passing the "flags" and the "value" together into
a single switchdev attribute, and it also reduces some boilerplate in
the drivers that offload this.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c              | 16 ++++-------
 drivers/net/dsa/mv88e6xxx/chip.c              | 17 ++++-------
 .../marvell/prestera/prestera_switchdev.c     | 16 +++++------
 .../mellanox/mlxsw/spectrum_switchdev.c       | 28 ++++++-------------
 drivers/net/ethernet/rocker/rocker_main.c     | 24 +++-------------
 drivers/net/ethernet/ti/cpsw_switchdev.c      | 20 ++++---------
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       | 22 ++++-----------
 include/net/dsa.h                             |  4 +--
 include/net/switchdev.h                       |  8 ++++--
 net/bridge/br_switchdev.c                     | 19 ++++---------
 net/dsa/dsa_priv.h                            |  4 +--
 net/dsa/port.c                                | 15 ++--------
 net/dsa/slave.c                               |  3 --
 13 files changed, 58 insertions(+), 138 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 0c4000783b15..a713117111c6 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1948,19 +1948,14 @@ int b53_br_egress_floods(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_br_egress_floods);
 
-static int b53_pre_br_flags(struct dsa_switch *ds, int port,
-			    unsigned long mask)
+static int b53_br_flags(struct dsa_switch *ds, int port,
+			struct switchdev_brport_flags val)
 {
-	if (mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
+	if (val.mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
 		return -EINVAL;
 
-	return 0;
-}
-
-static int b53_br_flags(struct dsa_switch *ds, int port, unsigned long flags)
-{
-	return b53_br_egress_floods(ds, port, flags & BR_FLOOD,
-				    flags & BR_MCAST_FLOOD);
+	return b53_br_egress_floods(ds, port, val.flags & BR_FLOOD,
+				    val.flags & BR_MCAST_FLOOD);
 }
 
 static int b53_set_mrouter(struct dsa_switch *ds, int port, bool mrouter)
@@ -2208,7 +2203,6 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_bridge_join	= b53_br_join,
 	.port_bridge_leave	= b53_br_leave,
 	.port_bridge_flags	= b53_br_flags,
-	.port_pre_bridge_flags	= b53_pre_br_flags,
 	.port_set_mrouter	= b53_set_mrouter,
 	.port_stp_state_set	= b53_br_set_stp_state,
 	.port_fast_age		= b53_br_fast_age,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index bd986244aa27..deb68e54fa74 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5380,20 +5380,14 @@ static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
 	return err;
 }
 
-static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
-					   unsigned long mask)
+static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
+				       struct switchdev_brport_flags val)
 {
-	if (mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
+	if (val.mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
 		return -EINVAL;
 
-	return 0;
-}
-
-static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
-				       unsigned long flags)
-{
-	return mv88e6xxx_port_egress_floods(ds, port, flags & BR_FLOOD,
-					    flags & BR_MCAST_FLOOD);
+	return mv88e6xxx_port_egress_floods(ds, port, val.flags & BR_FLOOD,
+					    val.flags & BR_MCAST_FLOOD);
 }
 
 static int mv88e6xxx_port_set_mrouter(struct dsa_switch *ds, int port,
@@ -5700,7 +5694,6 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.set_ageing_time	= mv88e6xxx_set_ageing_time,
 	.port_bridge_join	= mv88e6xxx_port_bridge_join,
 	.port_bridge_leave	= mv88e6xxx_port_bridge_leave,
-	.port_pre_bridge_flags	= mv88e6xxx_port_pre_bridge_flags,
 	.port_bridge_flags	= mv88e6xxx_port_bridge_flags,
 	.port_set_mrouter	= mv88e6xxx_port_set_mrouter,
 	.port_stp_state_set	= mv88e6xxx_port_stp_state_set,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 8c2b03151736..ab62945c7183 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -581,24 +581,27 @@ int prestera_bridge_port_event(struct net_device *dev, unsigned long event,
 
 static int prestera_port_attr_br_flags_set(struct prestera_port *port,
 					   struct net_device *dev,
-					   unsigned long flags)
+					   struct switchdev_brport_flags val)
 {
 	struct prestera_bridge_port *br_port;
 	int err;
 
+	if (val.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
+		err = -EINVAL;
+
 	br_port = prestera_bridge_port_by_dev(port->sw->swdev, dev);
 	if (!br_port)
 		return 0;
 
-	err = prestera_hw_port_flood_set(port, flags & BR_FLOOD);
+	err = prestera_hw_port_flood_set(port, val.flags & BR_FLOOD);
 	if (err)
 		return err;
 
-	err = prestera_hw_port_learning_set(port, flags & BR_LEARNING);
+	err = prestera_hw_port_learning_set(port, val.flags & BR_LEARNING);
 	if (err)
 		return err;
 
-	memcpy(&br_port->flags, &flags, sizeof(flags));
+	memcpy(&br_port->flags, &val.flags, sizeof(val.flags));
 
 	return 0;
 }
@@ -705,11 +708,6 @@ static int prestera_port_obj_attr_set(struct net_device *dev,
 		err = prestera_port_attr_stp_state_set(port, attr->orig_dev,
 						       attr->u.stp_state);
 		break;
-	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
-		if (attr->u.brport_flags &
-		    ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
-			err = -EINVAL;
-		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
 		err = prestera_port_attr_br_flags_set(port, attr->orig_dev,
 						      attr->u.brport_flags);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 20c4f3c2cf23..f19be04704e7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -653,23 +653,16 @@ mlxsw_sp_bridge_port_learning_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return err;
 }
 
-static int mlxsw_sp_port_attr_br_pre_flags_set(struct mlxsw_sp_port
-					       *mlxsw_sp_port,
-					       unsigned long brport_flags)
-{
-	if (brport_flags & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
-		return -EINVAL;
-
-	return 0;
-}
-
 static int mlxsw_sp_port_attr_br_flags_set(struct mlxsw_sp_port *mlxsw_sp_port,
 					   struct net_device *orig_dev,
-					   unsigned long brport_flags)
+					   struct switchdev_brport_flags val)
 {
 	struct mlxsw_sp_bridge_port *bridge_port;
 	int err;
 
+	if (val.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
+		return -EINVAL;
+
 	bridge_port = mlxsw_sp_bridge_port_find(mlxsw_sp_port->mlxsw_sp->bridge,
 						orig_dev);
 	if (!bridge_port)
@@ -677,12 +670,12 @@ static int mlxsw_sp_port_attr_br_flags_set(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	err = mlxsw_sp_bridge_port_flood_table_set(mlxsw_sp_port, bridge_port,
 						   MLXSW_SP_FLOOD_TYPE_UC,
-						   brport_flags & BR_FLOOD);
+						   val.flags & BR_FLOOD);
 	if (err)
 		return err;
 
 	err = mlxsw_sp_bridge_port_learning_set(mlxsw_sp_port, bridge_port,
-						brport_flags & BR_LEARNING);
+						val.flags & BR_LEARNING);
 	if (err)
 		return err;
 
@@ -691,13 +684,12 @@ static int mlxsw_sp_port_attr_br_flags_set(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	err = mlxsw_sp_bridge_port_flood_table_set(mlxsw_sp_port, bridge_port,
 						   MLXSW_SP_FLOOD_TYPE_MC,
-						   brport_flags &
-						   BR_MCAST_FLOOD);
+						   val.flags & BR_MCAST_FLOOD);
 	if (err)
 		return err;
 
 out:
-	memcpy(&bridge_port->flags, &brport_flags, sizeof(brport_flags));
+	memcpy(&bridge_port->flags, &val.flags, sizeof(val.flags));
 	return 0;
 }
 
@@ -898,10 +890,6 @@ static int mlxsw_sp_port_attr_set(struct net_device *dev,
 						       attr->orig_dev,
 						       attr->u.stp_state);
 		break;
-	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
-		err = mlxsw_sp_port_attr_br_pre_flags_set(mlxsw_sp_port,
-							  attr->u.brport_flags);
-		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
 		err = mlxsw_sp_port_attr_br_flags_set(mlxsw_sp_port,
 						      attr->orig_dev,
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 740a715c49c6..b8087dd0b284 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -1575,8 +1575,8 @@ rocker_world_port_attr_bridge_flags_support_get(const struct rocker_port *
 }
 
 static int
-rocker_world_port_attr_pre_bridge_flags_set(struct rocker_port *rocker_port,
-					    unsigned long brport_flags)
+rocker_world_port_attr_bridge_flags_set(struct rocker_port *rocker_port,
+					struct switchdev_brport_flags val)
 {
 	struct rocker_world_ops *wops = rocker_port->rocker->wops;
 	unsigned long brport_flags_s;
@@ -1590,22 +1590,10 @@ rocker_world_port_attr_pre_bridge_flags_set(struct rocker_port *rocker_port,
 	if (err)
 		return err;
 
-	if (brport_flags & ~brport_flags_s)
+	if (val.mask & ~brport_flags_s)
 		return -EINVAL;
 
-	return 0;
-}
-
-static int
-rocker_world_port_attr_bridge_flags_set(struct rocker_port *rocker_port,
-					unsigned long brport_flags)
-{
-	struct rocker_world_ops *wops = rocker_port->rocker->wops;
-
-	if (!wops->port_attr_bridge_flags_set)
-		return -EOPNOTSUPP;
-
-	return wops->port_attr_bridge_flags_set(rocker_port, brport_flags);
+	return wops->port_attr_bridge_flags_set(rocker_port, val.flags);
 }
 
 static int
@@ -2056,10 +2044,6 @@ static int rocker_port_attr_set(struct net_device *dev,
 		err = rocker_world_port_attr_stp_state_set(rocker_port,
 							   attr->u.stp_state);
 		break;
-	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
-		err = rocker_world_port_attr_pre_bridge_flags_set(rocker_port,
-							      attr->u.brport_flags);
-		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
 		err = rocker_world_port_attr_bridge_flags_set(rocker_port,
 							      attr->u.brport_flags);
diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
index 9967cf985728..dd4b1e161dde 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -57,12 +57,15 @@ static int cpsw_port_stp_state_set(struct cpsw_priv *priv, u8 state)
 
 static int cpsw_port_attr_br_flags_set(struct cpsw_priv *priv,
 				       struct net_device *orig_dev,
-				       unsigned long brport_flags)
+				       struct switchdev_brport_flags val)
 {
 	struct cpsw_common *cpsw = priv->cpsw;
 	bool unreg_mcast_add = false;
 
-	if (brport_flags & BR_MCAST_FLOOD)
+	if (val.mask & ~(BR_LEARNING | BR_MCAST_FLOOD))
+		return -EINVAL;
+
+	if (val.flags & BR_MCAST_FLOOD)
 		unreg_mcast_add = true;
 	dev_dbg(priv->dev, "BR_MCAST_FLOOD: %d port %u\n",
 		unreg_mcast_add, priv->emac_port);
@@ -73,15 +76,6 @@ static int cpsw_port_attr_br_flags_set(struct cpsw_priv *priv,
 	return 0;
 }
 
-static int cpsw_port_attr_br_flags_pre_set(struct net_device *netdev,
-					   unsigned long flags)
-{
-	if (flags & ~(BR_LEARNING | BR_MCAST_FLOOD))
-		return -EINVAL;
-
-	return 0;
-}
-
 static int cpsw_port_attr_set(struct net_device *ndev,
 			      const struct switchdev_attr *attr)
 {
@@ -91,10 +85,6 @@ static int cpsw_port_attr_set(struct net_device *ndev,
 	dev_dbg(priv->dev, "attr: id %u port: %u\n", attr->id, priv->emac_port);
 
 	switch (attr->id) {
-	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
-		ret = cpsw_port_attr_br_flags_pre_set(ndev,
-						      attr->u.brport_flags);
-		break;
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
 		ret = cpsw_port_stp_state_set(priv, attr->u.stp_state);
 		dev_dbg(priv->dev, "stp state: %u\n", attr->u.stp_state);
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index ca3d07fe7f58..c4bcd63b68b8 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -908,28 +908,22 @@ static int dpaa2_switch_port_attr_stp_state_set(struct net_device *netdev,
 	return dpaa2_switch_port_set_stp_state(port_priv, state);
 }
 
-static int dpaa2_switch_port_attr_br_flags_pre_set(struct net_device *netdev,
-						   unsigned long flags)
-{
-	if (flags & ~(BR_LEARNING | BR_FLOOD))
-		return -EINVAL;
-
-	return 0;
-}
-
 static int dpaa2_switch_port_attr_br_flags_set(struct net_device *netdev,
-					       unsigned long flags)
+					       struct switchdev_brport_flags val)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	int err = 0;
 
+	if (val.mask & ~(BR_LEARNING | BR_FLOOD))
+		return -EINVAL;
+
 	/* Learning is enabled per switch */
 	err = dpaa2_switch_set_learning(port_priv->ethsw_data,
-					!!(flags & BR_LEARNING));
+					!!(val.flags & BR_LEARNING));
 	if (err)
 		goto exit;
 
-	err = dpaa2_switch_port_set_flood(port_priv, !!(flags & BR_FLOOD));
+	err = dpaa2_switch_port_set_flood(port_priv, !!(val.flags & BR_FLOOD));
 
 exit:
 	return err;
@@ -945,10 +939,6 @@ static int dpaa2_switch_port_attr_set(struct net_device *netdev,
 		err = dpaa2_switch_port_attr_stp_state_set(netdev,
 							   attr->u.stp_state);
 		break;
-	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
-		err = dpaa2_switch_port_attr_br_flags_pre_set(netdev,
-							      attr->u.brport_flags);
-		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
 		err = dpaa2_switch_port_attr_br_flags_set(netdev,
 							  attr->u.brport_flags);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index e37fee22caab..8af12850337d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -621,10 +621,8 @@ struct dsa_switch_ops {
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
 				      u8 state);
 	void	(*port_fast_age)(struct dsa_switch *ds, int port);
-	int	(*port_pre_bridge_flags)(struct dsa_switch *ds, int port,
-					 unsigned long mask);
 	int	(*port_bridge_flags)(struct dsa_switch *ds, int port,
-				     unsigned long flags);
+				     struct switchdev_brport_flags val);
 	int	(*port_set_mrouter)(struct dsa_switch *ds, int port,
 				    bool mrouter);
 
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 88fcac140966..62f16a6bd313 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -20,7 +20,6 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_UNDEFINED,
 	SWITCHDEV_ATTR_ID_PORT_STP_STATE,
 	SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS,
-	SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS,
 	SWITCHDEV_ATTR_ID_PORT_MROUTER,
 	SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME,
 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING,
@@ -33,6 +32,11 @@ enum switchdev_attr_id {
 #endif
 };
 
+struct switchdev_brport_flags {
+	unsigned long flags;
+	unsigned long mask;
+};
+
 struct switchdev_attr {
 	struct net_device *orig_dev;
 	enum switchdev_attr_id id;
@@ -41,7 +45,7 @@ struct switchdev_attr {
 	void (*complete)(struct net_device *dev, int err, void *priv);
 	union {
 		u8 stp_state;				/* PORT_STP_STATE */
-		unsigned long brport_flags;		/* PORT_{PRE}_BRIDGE_FLAGS */
+		struct switchdev_brport_flags brport_flags; /* PORT_BRIDGE_FLAGS */
 		bool mrouter;				/* PORT_MROUTER */
 		clock_t ageing_time;			/* BRIDGE_AGEING_TIME */
 		bool vlan_filtering;			/* BRIDGE_VLAN_FILTERING */
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index c18e1d600dc6..3b460eb225dd 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -65,8 +65,11 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 {
 	struct switchdev_attr attr = {
 		.orig_dev = p->dev,
-		.id = SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS,
-		.u.brport_flags = mask,
+		.id = SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS,
+		.u.brport_flags = {
+			.flags = flags,
+			.mask = mask,
+		},
 	};
 	struct switchdev_notifier_port_attr_info info = {
 		.attr = &attr,
@@ -78,7 +81,7 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 
 	/* We run from atomic context here */
 	err = call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
-				       &info.info, NULL);
+				       &info.info, extack);
 	err = notifier_to_errno(err);
 	if (err == -EOPNOTSUPP)
 		return 0;
@@ -88,16 +91,6 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 		return -EOPNOTSUPP;
 	}
 
-	attr.id = SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS;
-	attr.flags = SWITCHDEV_F_DEFER;
-	attr.u.brport_flags = flags;
-
-	err = switchdev_port_attr_set(p->dev, &attr);
-	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "error setting offload flag on port");
-		return err;
-	}
-
 	return 0;
 }
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index da99961599de..4fed6b833936 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -174,8 +174,8 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_mdb_del(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
-int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long mask);
-int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags);
+int dsa_port_bridge_flags(const struct dsa_port *dp,
+			  struct switchdev_brport_flags val);
 int dsa_port_mrouter(struct dsa_port *dp, bool mrouter);
 int dsa_port_vlan_add(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 8df492412138..fffe5f14ec0a 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -382,24 +382,15 @@ int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
 	return 0;
 }
 
-int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long mask)
-{
-	struct dsa_switch *ds = dp->ds;
-
-	if (!ds->ops->port_pre_bridge_flags)
-		return -EINVAL;
-
-	return ds->ops->port_pre_bridge_flags(ds, dp->index, mask);
-}
-
-int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags)
+int dsa_port_bridge_flags(const struct dsa_port *dp,
+			  struct switchdev_brport_flags val)
 {
 	struct dsa_switch *ds = dp->ds;
 
 	if (!ds->ops->port_bridge_flags)
 		return -EINVAL;
 
-	return ds->ops->port_bridge_flags(ds, dp->index, flags);
+	return ds->ops->port_bridge_flags(ds, dp->index, val);
 }
 
 int dsa_port_mrouter(struct dsa_port *dp, bool mrouter)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 431bdbdd8473..d53c455a73f3 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -289,9 +289,6 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
 		ret = dsa_port_ageing_time(dp, attr->u.ageing_time);
 		break;
-	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
-		ret = dsa_port_pre_bridge_flags(dp, attr->u.brport_flags);
-		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
 		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags);
 		break;
-- 
2.25.1

