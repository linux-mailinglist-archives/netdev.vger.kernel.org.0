Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665D731A179
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbhBLPSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhBLPRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:17:33 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1DEC06178A;
        Fri, 12 Feb 2021 07:16:17 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id v7so34063eds.10;
        Fri, 12 Feb 2021 07:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ficNygvMQR2i/ynCstk4J2m6rytXns5Vj35F/uwG9iI=;
        b=AiE9sZINQia2D+iU4b35DSwYBvtNu5zvRLJdlImDQguYNbDlp8kSCO/RcQrXExFPEL
         GG+wMAauFLxTWrJVQ5gm95BXTxogPuHD+KuP7gAvDEWvDXx1HKAdGcFiZR4INwPTXCjN
         UUA3yusySmx7tdU/KeIL2wQEkbbbQMvI8Brh5uPMf40nM4uHRaecZpCq6BoV0+dOaKgV
         QZIrMZfoAAi3rPTjjkXiqcH6i4+YLeD4kRZvKkWt1ilsgH8Hdg0FxipXu0OajASiT7cD
         TpsTw3HYkGu6QQpKMUFGiDSYkBgV+qO5kCg7LheYbdVm/ez55Z9bV43t1/4hMGBxNt1K
         0v2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ficNygvMQR2i/ynCstk4J2m6rytXns5Vj35F/uwG9iI=;
        b=IAmMrXmrFoYUYhLot3PIgbfdutzjX5l53VgBKdB/Zz9kZ/hlg9aRJLvAkFIDpd5lXm
         zzraXXvQa67kimM3yQp17RWDV28k67/4dgbK1VfEPUo3WshAXn19qeGVo1UOiAPt6vjb
         2NAaNNAPaA3hyvVbJinvWe73ph934jPeINgHbphHSs+mqRVl7ye2ljMD+21Aik26KY8g
         AjILs+9JHvVqkAIVzeDWrj6xJpZO04AywJ2U3n1sQ4REFB26l4WrRG4XCjgHz+RDNqLZ
         BMfxWO3RxAh53p9yXbob2877dzZFMTURUEC84/B6DvEx5kKgEKhNZ+IlSt6b9ZWWNacL
         Lj8w==
X-Gm-Message-State: AOAM533zJLh5TrLmCQqBmwKHpeHsDDWrpT9Kv+I+n4EKMhyikkHtdE2z
        5cFuJSVJz/4PrIvf4MoPEKg=
X-Google-Smtp-Source: ABdhPJwuujPf5hXytnk6kPQoTSTcaFsFlFxsxStjrYKKciQXf4J2wfDmU6AFaHtG93l1+2gCn2fzrg==
X-Received: by 2002:a05:6402:5207:: with SMTP id s7mr3703480edd.311.1613142976353;
        Fri, 12 Feb 2021 07:16:16 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z19sm6515456edr.69.2021.02.12.07.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 07:16:15 -0800 (PST)
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
Subject: [PATCH v5 net-next 05/10] net: switchdev: pass flags and mask to both {PRE_,}BRIDGE_FLAGS attributes
Date:   Fri, 12 Feb 2021 17:15:55 +0200
Message-Id: <20210212151600.3357121-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212151600.3357121-1-olteanv@gmail.com>
References: <20210212151600.3357121-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This switchdev attribute offers a counterproductive API for a driver
writer, because although br_switchdev_set_port_flag gets passed a
"flags" and a "mask", those are passed piecemeal to the driver, so while
the PRE_BRIDGE_FLAGS listener knows what changed because it has the
"mask", the BRIDGE_FLAGS listener doesn't, because it only has the final
value. But certain drivers can offload only certain combinations of
settings, like for example they cannot change unicast flooding
independently of multicast flooding - they must be both on or both off.
The way the information is passed to switchdev makes drivers not
expressive enough, and unable to reject this request ahead of time, in
the PRE_BRIDGE_FLAGS notifier, so they are forced to reject it during
the deferred BRIDGE_FLAGS attribute, where the rejection is currently
ignored.

This patch also changes drivers to make use of the "mask" field for edge
detection when possible.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
Rebased on top of AM65 CPSW driver.

Changes in v4:
Patch is new.

 .../marvell/prestera/prestera_switchdev.c     | 23 +++++----
 .../mellanox/mlxsw/spectrum_switchdev.c       | 50 +++++++++++--------
 drivers/net/ethernet/rocker/rocker_main.c     | 10 ++--
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c | 24 +++++----
 drivers/net/ethernet/ti/cpsw_switchdev.c      | 24 +++++----
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       | 34 ++++++++-----
 include/net/switchdev.h                       |  7 ++-
 net/bridge/br_switchdev.c                     |  6 +--
 net/dsa/dsa_priv.h                            |  6 ++-
 net/dsa/port.c                                | 34 +++++++------
 10 files changed, 129 insertions(+), 89 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 2c1619715a4b..49e052273f30 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -581,7 +581,7 @@ int prestera_bridge_port_event(struct net_device *dev, unsigned long event,
 
 static int prestera_port_attr_br_flags_set(struct prestera_port *port,
 					   struct net_device *dev,
-					   unsigned long flags)
+					   struct switchdev_brport_flags flags)
 {
 	struct prestera_bridge_port *br_port;
 	int err;
@@ -590,15 +590,20 @@ static int prestera_port_attr_br_flags_set(struct prestera_port *port,
 	if (!br_port)
 		return 0;
 
-	err = prestera_hw_port_flood_set(port, flags & BR_FLOOD);
-	if (err)
-		return err;
+	if (flags.mask & BR_FLOOD) {
+		err = prestera_hw_port_flood_set(port, flags.val & BR_FLOOD);
+		if (err)
+			return err;
+	}
 
-	err = prestera_hw_port_learning_set(port, flags & BR_LEARNING);
-	if (err)
-		return err;
+	if (flags.mask & BR_LEARNING) {
+		err = prestera_hw_port_learning_set(port,
+						    flags.val & BR_LEARNING);
+		if (err)
+			return err;
+	}
 
-	memcpy(&br_port->flags, &flags, sizeof(flags));
+	memcpy(&br_port->flags, &flags.val, sizeof(flags.val));
 
 	return 0;
 }
@@ -707,7 +712,7 @@ static int prestera_port_obj_attr_set(struct net_device *dev,
 						       attr->u.stp_state);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
-		if (attr->u.brport_flags &
+		if (attr->u.brport_flags.mask &
 		    ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
 			err = -EINVAL;
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 18e4f1cd5587..23b7e8d6386b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -653,11 +653,11 @@ mlxsw_sp_bridge_port_learning_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return err;
 }
 
-static int mlxsw_sp_port_attr_br_pre_flags_set(struct mlxsw_sp_port
-					       *mlxsw_sp_port,
-					       unsigned long brport_flags)
+static int
+mlxsw_sp_port_attr_br_pre_flags_set(struct mlxsw_sp_port *mlxsw_sp_port,
+				    struct switchdev_brport_flags flags)
 {
-	if (brport_flags & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
 		return -EINVAL;
 
 	return 0;
@@ -665,7 +665,7 @@ static int mlxsw_sp_port_attr_br_pre_flags_set(struct mlxsw_sp_port
 
 static int mlxsw_sp_port_attr_br_flags_set(struct mlxsw_sp_port *mlxsw_sp_port,
 					   struct net_device *orig_dev,
-					   unsigned long brport_flags)
+					   struct switchdev_brport_flags flags)
 {
 	struct mlxsw_sp_bridge_port *bridge_port;
 	int err;
@@ -675,29 +675,37 @@ static int mlxsw_sp_port_attr_br_flags_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (!bridge_port)
 		return 0;
 
-	err = mlxsw_sp_bridge_port_flood_table_set(mlxsw_sp_port, bridge_port,
-						   MLXSW_SP_FLOOD_TYPE_UC,
-						   brport_flags & BR_FLOOD);
-	if (err)
-		return err;
+	if (flags.mask & BR_FLOOD) {
+		err = mlxsw_sp_bridge_port_flood_table_set(mlxsw_sp_port,
+							   bridge_port,
+							   MLXSW_SP_FLOOD_TYPE_UC,
+							   flags.val & BR_FLOOD);
+		if (err)
+			return err;
+	}
 
-	err = mlxsw_sp_bridge_port_learning_set(mlxsw_sp_port, bridge_port,
-						brport_flags & BR_LEARNING);
-	if (err)
-		return err;
+	if (flags.mask & BR_LEARNING) {
+		err = mlxsw_sp_bridge_port_learning_set(mlxsw_sp_port,
+							bridge_port,
+							flags.val & BR_LEARNING);
+		if (err)
+			return err;
+	}
 
 	if (bridge_port->bridge_device->multicast_enabled)
 		goto out;
 
-	err = mlxsw_sp_bridge_port_flood_table_set(mlxsw_sp_port, bridge_port,
-						   MLXSW_SP_FLOOD_TYPE_MC,
-						   brport_flags &
-						   BR_MCAST_FLOOD);
-	if (err)
-		return err;
+	if (flags.mask & BR_MCAST_FLOOD) {
+		err = mlxsw_sp_bridge_port_flood_table_set(mlxsw_sp_port,
+							   bridge_port,
+							   MLXSW_SP_FLOOD_TYPE_MC,
+							   flags.val & BR_MCAST_FLOOD);
+		if (err)
+			return err;
+	}
 
 out:
-	memcpy(&bridge_port->flags, &brport_flags, sizeof(brport_flags));
+	memcpy(&bridge_port->flags, &flags.val, sizeof(flags.val));
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 740a715c49c6..3473d296b2e2 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -1576,7 +1576,7 @@ rocker_world_port_attr_bridge_flags_support_get(const struct rocker_port *
 
 static int
 rocker_world_port_attr_pre_bridge_flags_set(struct rocker_port *rocker_port,
-					    unsigned long brport_flags)
+					    struct switchdev_brport_flags flags)
 {
 	struct rocker_world_ops *wops = rocker_port->rocker->wops;
 	unsigned long brport_flags_s;
@@ -1590,7 +1590,7 @@ rocker_world_port_attr_pre_bridge_flags_set(struct rocker_port *rocker_port,
 	if (err)
 		return err;
 
-	if (brport_flags & ~brport_flags_s)
+	if (flags.mask & ~brport_flags_s)
 		return -EINVAL;
 
 	return 0;
@@ -1598,14 +1598,14 @@ rocker_world_port_attr_pre_bridge_flags_set(struct rocker_port *rocker_port,
 
 static int
 rocker_world_port_attr_bridge_flags_set(struct rocker_port *rocker_port,
-					unsigned long brport_flags)
+					struct switchdev_brport_flags flags)
 {
 	struct rocker_world_ops *wops = rocker_port->rocker->wops;
 
 	if (!wops->port_attr_bridge_flags_set)
 		return -EOPNOTSUPP;
 
-	return wops->port_attr_bridge_flags_set(rocker_port, brport_flags);
+	return wops->port_attr_bridge_flags_set(rocker_port, flags.val);
 }
 
 static int
@@ -2058,7 +2058,7 @@ static int rocker_port_attr_set(struct net_device *dev,
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
 		err = rocker_world_port_attr_pre_bridge_flags_set(rocker_port,
-							      attr->u.brport_flags);
+								  attr->u.brport_flags);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
 		err = rocker_world_port_attr_bridge_flags_set(rocker_port,
diff --git a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
index 314825acf0a0..d93ffd8a08b0 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
@@ -55,26 +55,30 @@ static int am65_cpsw_port_stp_state_set(struct am65_cpsw_port *port, u8 state)
 
 static int am65_cpsw_port_attr_br_flags_set(struct am65_cpsw_port *port,
 					    struct net_device *orig_dev,
-					    unsigned long brport_flags)
+					    struct switchdev_brport_flags flags)
 {
 	struct am65_cpsw_common *cpsw = port->common;
-	bool unreg_mcast_add = false;
 
-	if (brport_flags & BR_MCAST_FLOOD)
-		unreg_mcast_add = true;
-	netdev_dbg(port->ndev, "BR_MCAST_FLOOD: %d port %u\n",
-		   unreg_mcast_add, port->port_id);
+	if (flags.mask & BR_MCAST_FLOOD) {
+		bool unreg_mcast_add = false;
 
-	cpsw_ale_set_unreg_mcast(cpsw->ale, BIT(port->port_id),
-				 unreg_mcast_add);
+		if (flags.val & BR_MCAST_FLOOD)
+			unreg_mcast_add = true;
+
+		netdev_dbg(port->ndev, "BR_MCAST_FLOOD: %d port %u\n",
+			   unreg_mcast_add, port->port_id);
+
+		cpsw_ale_set_unreg_mcast(cpsw->ale, BIT(port->port_id),
+					 unreg_mcast_add);
+	}
 
 	return 0;
 }
 
 static int am65_cpsw_port_attr_br_flags_pre_set(struct net_device *netdev,
-						unsigned long flags)
+						struct switchdev_brport_flags flags)
 {
-	if (flags & ~(BR_LEARNING | BR_MCAST_FLOOD))
+	if (flags.mask & ~(BR_LEARNING | BR_MCAST_FLOOD))
 		return -EINVAL;
 
 	return 0;
diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
index 13524cbaa8b6..a72bb570756f 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -57,26 +57,30 @@ static int cpsw_port_stp_state_set(struct cpsw_priv *priv, u8 state)
 
 static int cpsw_port_attr_br_flags_set(struct cpsw_priv *priv,
 				       struct net_device *orig_dev,
-				       unsigned long brport_flags)
+				       struct switchdev_brport_flags flags)
 {
 	struct cpsw_common *cpsw = priv->cpsw;
-	bool unreg_mcast_add = false;
 
-	if (brport_flags & BR_MCAST_FLOOD)
-		unreg_mcast_add = true;
-	dev_dbg(priv->dev, "BR_MCAST_FLOOD: %d port %u\n",
-		unreg_mcast_add, priv->emac_port);
+	if (flags.mask & BR_MCAST_FLOOD) {
+		bool unreg_mcast_add = false;
 
-	cpsw_ale_set_unreg_mcast(cpsw->ale, BIT(priv->emac_port),
-				 unreg_mcast_add);
+		if (flags.val & BR_MCAST_FLOOD)
+			unreg_mcast_add = true;
+
+		dev_dbg(priv->dev, "BR_MCAST_FLOOD: %d port %u\n",
+			unreg_mcast_add, priv->emac_port);
+
+		cpsw_ale_set_unreg_mcast(cpsw->ale, BIT(priv->emac_port),
+					 unreg_mcast_add);
+	}
 
 	return 0;
 }
 
 static int cpsw_port_attr_br_flags_pre_set(struct net_device *netdev,
-					   unsigned long flags)
+					   struct switchdev_brport_flags flags)
 {
-	if (flags & ~(BR_LEARNING | BR_MCAST_FLOOD))
+	if (flags.mask & ~(BR_LEARNING | BR_MCAST_FLOOD))
 		return -EINVAL;
 
 	return 0;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index ca3d07fe7f58..703055e063ff 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -908,31 +908,39 @@ static int dpaa2_switch_port_attr_stp_state_set(struct net_device *netdev,
 	return dpaa2_switch_port_set_stp_state(port_priv, state);
 }
 
-static int dpaa2_switch_port_attr_br_flags_pre_set(struct net_device *netdev,
-						   unsigned long flags)
+static int
+dpaa2_switch_port_attr_br_flags_pre_set(struct net_device *netdev,
+					struct switchdev_brport_flags flags)
 {
-	if (flags & ~(BR_LEARNING | BR_FLOOD))
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD))
 		return -EINVAL;
 
 	return 0;
 }
 
-static int dpaa2_switch_port_attr_br_flags_set(struct net_device *netdev,
-					       unsigned long flags)
+static int
+dpaa2_switch_port_attr_br_flags_set(struct net_device *netdev,
+				    struct switchdev_brport_flags flags)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	int err = 0;
 
-	/* Learning is enabled per switch */
-	err = dpaa2_switch_set_learning(port_priv->ethsw_data,
-					!!(flags & BR_LEARNING));
-	if (err)
-		goto exit;
+	if (flags.mask & BR_LEARNING) {
+		/* Learning is enabled per switch */
+		err = dpaa2_switch_set_learning(port_priv->ethsw_data,
+						!!(flags.val & BR_LEARNING));
+		if (err)
+			return err;
+	}
 
-	err = dpaa2_switch_port_set_flood(port_priv, !!(flags & BR_FLOOD));
+	if (flags.mask & BR_FLOOD) {
+		err = dpaa2_switch_port_set_flood(port_priv,
+						  !!(flags.val & BR_FLOOD));
+		if (err)
+			return err;
+	}
 
-exit:
-	return err;
+	return 0;
 }
 
 static int dpaa2_switch_port_attr_set(struct net_device *netdev,
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 9279d4245bab..25d9e4570934 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -32,6 +32,11 @@ enum switchdev_attr_id {
 #endif
 };
 
+struct switchdev_brport_flags {
+	unsigned long val;
+	unsigned long mask;
+};
+
 struct switchdev_attr {
 	struct net_device *orig_dev;
 	enum switchdev_attr_id id;
@@ -40,7 +45,7 @@ struct switchdev_attr {
 	void (*complete)(struct net_device *dev, int err, void *priv);
 	union {
 		u8 stp_state;				/* PORT_STP_STATE */
-		unsigned long brport_flags;		/* PORT_{PRE}_BRIDGE_FLAGS */
+		struct switchdev_brport_flags brport_flags; /* PORT_BRIDGE_FLAGS */
 		bool mrouter;				/* PORT_MROUTER */
 		clock_t ageing_time;			/* BRIDGE_AGEING_TIME */
 		bool vlan_filtering;			/* BRIDGE_VLAN_FILTERING */
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index bb21dd35ae85..184cf4c8b06d 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -65,7 +65,6 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 {
 	struct switchdev_attr attr = {
 		.orig_dev = p->dev,
-		.id = SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS,
 	};
 	struct switchdev_notifier_port_attr_info info = {
 		.attr = &attr,
@@ -76,7 +75,9 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 	if (!mask)
 		return 0;
 
-	attr.u.brport_flags = mask;
+	attr.id = SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS;
+	attr.u.brport_flags.val = flags;
+	attr.u.brport_flags.mask = mask;
 
 	/* We run from atomic context here */
 	err = call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
@@ -94,7 +95,6 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 
 	attr.id = SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS;
 	attr.flags = SWITCHDEV_F_DEFER;
-	attr.u.brport_flags = flags;
 
 	err = switchdev_port_attr_set(p->dev, &attr);
 	if (err) {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 7060f128386b..bc835f3de2be 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -183,8 +183,10 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_mdb_del(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
-int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags);
-int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags);
+int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
+			      struct switchdev_brport_flags flags);
+int dsa_port_bridge_flags(const struct dsa_port *dp,
+			  struct switchdev_brport_flags flags);
 int dsa_port_mrouter(struct dsa_port *dp, bool mrouter);
 int dsa_port_vlan_add(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 1f877bf21bb4..368064dfd93e 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -125,21 +125,22 @@ void dsa_port_disable(struct dsa_port *dp)
 static void dsa_port_change_brport_flags(struct dsa_port *dp,
 					 bool bridge_offload)
 {
-	unsigned long mask, flags;
-	int flag, err;
+	struct switchdev_brport_flags flags;
+	int flag;
 
-	mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
+	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
 	if (bridge_offload)
-		flags = mask;
+		flags.val = flags.mask;
 	else
-		flags = mask & ~BR_LEARNING;
+		flags.val = flags.mask & ~BR_LEARNING;
 
-	for_each_set_bit(flag, &mask, 32) {
-		err = dsa_port_pre_bridge_flags(dp, BIT(flag));
-		if (err)
-			continue;
+	for_each_set_bit(flag, &flags.mask, 32) {
+		struct switchdev_brport_flags tmp;
+
+		tmp.val = flags.val & BIT(flag);
+		tmp.mask = BIT(flag);
 
-		dsa_port_bridge_flags(dp, flags & BIT(flag));
+		dsa_port_bridge_flags(dp, tmp);
 	}
 }
 
@@ -423,26 +424,29 @@ int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
 	return 0;
 }
 
-int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags)
+int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
+			      struct switchdev_brport_flags flags)
 {
 	struct dsa_switch *ds = dp->ds;
 
 	if (!ds->ops->port_egress_floods ||
-	    (flags & ~(BR_FLOOD | BR_MCAST_FLOOD)))
+	    (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD)))
 		return -EINVAL;
 
 	return 0;
 }
 
-int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags)
+int dsa_port_bridge_flags(const struct dsa_port *dp,
+			  struct switchdev_brport_flags flags)
 {
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
 	int err = 0;
 
 	if (ds->ops->port_egress_floods)
-		err = ds->ops->port_egress_floods(ds, port, flags & BR_FLOOD,
-						  flags & BR_MCAST_FLOOD);
+		err = ds->ops->port_egress_floods(ds, port,
+						  flags.val & BR_FLOOD,
+						  flags.val & BR_MCAST_FLOOD);
 
 	return err;
 }
-- 
2.25.1

