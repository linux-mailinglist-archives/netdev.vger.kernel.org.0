Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1A8316220
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhBJJY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhBJJVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:21:15 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD6BC061797;
        Wed, 10 Feb 2021 01:19:22 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id b9so2747243ejy.12;
        Wed, 10 Feb 2021 01:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CXjCmzUECth2G3l3PXrELz5l4B9Xa3RRpLzHdvC5vhA=;
        b=Fx7mvDMWNovGTLJbpSArsu/Gq+1sgkx7cs2dCn4YW0zH7Qur0Xrlh+GsvD9zh0pCuW
         9nu0qZ4tmDTfaINXhqglSn5OFkDwThY5ikhrX1gpETMz8/pIWQglO4VJeH0QJbjIkGqQ
         gEDl74vTveTsFDOViq6F6PtN+2Qn5BemOYbevq5Fb/BF7pp9BmLq37GmuIVT+OYksg7B
         BSALdPTVPrxENRWR+lqZNYQsRhc/JMCaY7+7ydkW527l1LGttJR0A8ThgnSnZ2ZXwKCc
         otPEAvAdaPZFhnyrErLB2kC7S7eRA1406FdAUOZnYlBpqBtwInP39fk6oobRZgNyRwOG
         JHvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CXjCmzUECth2G3l3PXrELz5l4B9Xa3RRpLzHdvC5vhA=;
        b=ogdMUWd0529DuVfhCu/z0t9Z9Ceo5eWnfw36uLirrUJUfgwoTDdOC1WpRnlt/pQCKm
         E4gW3NuQ6HyCWEtsQaeQ0BkzEXWNtvyyx/FSlnG3d48fBk53xCp2DV1KO7qZbHgKOZPf
         QXI1hVU3u4ImfSnfFVQw78J0onfYZssojWpoj1qYkwRjmhpXR1gz8qfchCuo7OdWgr3+
         +VrB0cZVdP/jglU+/q29xqOWENLKuDZfRFhccT/jqLMCs0JW6ctfaSVIdgtbIbnx7L1M
         2P/6HcTKdq9RRWqllq8ycTrdIynCmfiNyHyOGwo9B4g2AWrTwUjlserFZPncYAOZMIqb
         yqzQ==
X-Gm-Message-State: AOAM532gR8pFcQTE6Jr7JGDMXIAPVXYDRMHI763/LbvDZHbKvaGeGMUt
        AXwrkARMaNzg64g/w355H3U=
X-Google-Smtp-Source: ABdhPJxATxtELfV/YEBtt9kTgw6RwN/3CnRgGAMpEFwTJfk2sghvrJ0VoWsXzOGqII+UIH/mOYNoFw==
X-Received: by 2002:a17:906:9b4f:: with SMTP id ep15mr1984202ejc.423.1612948761239;
        Wed, 10 Feb 2021 01:19:21 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u2sm701801ejb.65.2021.02.10.01.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 01:19:20 -0800 (PST)
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
Subject: [PATCH v3 net-next 05/11] net: squash switchdev attributes PRE_BRIDGE_FLAGS and BRIDGE_FLAGS
Date:   Wed, 10 Feb 2021 11:14:39 +0200
Message-Id: <20210210091445.741269-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210091445.741269-1-olteanv@gmail.com>
References: <20210210091445.741269-1-olteanv@gmail.com>
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

This can be solved by passing the "flags" and the "mask" together into
a single switchdev attribute, and it also reduces some boilerplate in
the drivers that offload this.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- Reworked mlxsw to check mask before performing any change.
- Also adapted the newly introduced dsa_port_change_brport_flags to the
  new API.

Changes in v2:
- Renamed "val" to "flags".
- Reworked drivers to check mask before performing any change.

 .../marvell/prestera/prestera_switchdev.c     | 29 +++++----
 .../mellanox/mlxsw/spectrum_switchdev.c       | 59 +++++++++----------
 drivers/net/ethernet/rocker/rocker_main.c     | 24 ++------
 drivers/net/ethernet/ti/cpsw_switchdev.c      | 32 ++++------
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       | 43 +++++++-------
 include/net/switchdev.h                       |  8 ++-
 net/bridge/br_switchdev.c                     | 15 +----
 net/dsa/dsa_priv.h                            |  4 +-
 net/dsa/port.c                                | 43 ++++++--------
 net/dsa/slave.c                               |  3 -
 10 files changed, 109 insertions(+), 151 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 2c1619715a4b..a797a7ff0cfe 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -581,24 +581,32 @@ int prestera_bridge_port_event(struct net_device *dev, unsigned long event,
 
 static int prestera_port_attr_br_flags_set(struct prestera_port *port,
 					   struct net_device *dev,
-					   unsigned long flags)
+					   struct switchdev_brport_flags flags)
 {
 	struct prestera_bridge_port *br_port;
 	int err;
 
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
+		err = -EINVAL;
+
 	br_port = prestera_bridge_port_by_dev(port->sw->swdev, dev);
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
@@ -706,11 +714,6 @@ static int prestera_port_obj_attr_set(struct net_device *dev,
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
index 18e4f1cd5587..7af79e3a3c7a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -653,51 +653,52 @@ mlxsw_sp_bridge_port_learning_set(struct mlxsw_sp_port *mlxsw_sp_port,
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
+					   struct switchdev_brport_flags flags)
 {
 	struct mlxsw_sp_bridge_port *bridge_port;
 	int err;
 
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
+		return -EINVAL;
+
 	bridge_port = mlxsw_sp_bridge_port_find(mlxsw_sp_port->mlxsw_sp->bridge,
 						orig_dev);
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
 
@@ -899,10 +900,6 @@ static int mlxsw_sp_port_attr_set(struct net_device *dev,
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
index 740a715c49c6..898abf3d14d0 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -1575,8 +1575,8 @@ rocker_world_port_attr_bridge_flags_support_get(const struct rocker_port *
 }
 
 static int
-rocker_world_port_attr_pre_bridge_flags_set(struct rocker_port *rocker_port,
-					    unsigned long brport_flags)
+rocker_world_port_attr_bridge_flags_set(struct rocker_port *rocker_port,
+					struct switchdev_brport_flags flags)
 {
 	struct rocker_world_ops *wops = rocker_port->rocker->wops;
 	unsigned long brport_flags_s;
@@ -1590,22 +1590,10 @@ rocker_world_port_attr_pre_bridge_flags_set(struct rocker_port *rocker_port,
 	if (err)
 		return err;
 
-	if (brport_flags & ~brport_flags_s)
+	if (flags.mask & ~brport_flags_s)
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
+	return wops->port_attr_bridge_flags_set(rocker_port, flags.val);
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
index 13524cbaa8b6..5d8ec34f82ad 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -57,27 +57,25 @@ static int cpsw_port_stp_state_set(struct cpsw_priv *priv, u8 state)
 
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
+	if (flags.mask & ~(BR_LEARNING | BR_MCAST_FLOOD))
+		return -EINVAL;
 
-	cpsw_ale_set_unreg_mcast(cpsw->ale, BIT(priv->emac_port),
-				 unreg_mcast_add);
+	if (flags.mask & BR_MCAST_FLOOD) {
+		bool unreg_mcast_add = false;
 
-	return 0;
-}
+		if (flags.val & BR_MCAST_FLOOD)
+			unreg_mcast_add = true;
 
-static int cpsw_port_attr_br_flags_pre_set(struct net_device *netdev,
-					   unsigned long flags)
-{
-	if (flags & ~(BR_LEARNING | BR_MCAST_FLOOD))
-		return -EINVAL;
+		dev_dbg(priv->dev, "BR_MCAST_FLOOD: %d port %u\n",
+			unreg_mcast_add, priv->emac_port);
+
+		cpsw_ale_set_unreg_mcast(cpsw->ale, BIT(priv->emac_port),
+					 unreg_mcast_add);
+	}
 
 	return 0;
 }
@@ -92,10 +90,6 @@ static int cpsw_port_attr_set(struct net_device *ndev,
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
index ca3d07fe7f58..f675a2ba4dce 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -908,31 +908,32 @@ static int dpaa2_switch_port_attr_stp_state_set(struct net_device *netdev,
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
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD))
+		return -EINVAL;
+
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
@@ -945,10 +946,6 @@ static int dpaa2_switch_port_attr_set(struct net_device *netdev,
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
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 84c765312001..aa9cad9bad7d 100644
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
+	unsigned long val;
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
index ac8dead86bf2..92d207c8a30e 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -65,7 +65,7 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 {
 	struct switchdev_attr attr = {
 		.orig_dev = p->dev,
-		.id = SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS,
+		.id = SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS,
 	};
 	struct switchdev_notifier_port_attr_info info = {
 		.attr = &attr,
@@ -77,7 +77,8 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 	if (!mask)
 		return 0;
 
-	attr.u.brport_flags = mask;
+	attr.u.brport_flags.val = flags;
+	attr.u.brport_flags.mask = mask;
 
 	/* We run from atomic context here */
 	err = call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
@@ -93,16 +94,6 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
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
index 8a1bcb2b4208..63770e421e4d 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -174,8 +174,8 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_mdb_del(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
-int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags);
-int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags);
+int dsa_port_bridge_flags(const struct dsa_port *dp,
+			  struct switchdev_brport_flags flags);
 int dsa_port_mrouter(struct dsa_port *dp, bool mrouter);
 int dsa_port_vlan_add(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 9f65ba11ad00..736c5debcb96 100644
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
 
-		dsa_port_bridge_flags(dp, flags & BIT(flag));
+		tmp.val = flags.val & BIT(flag);
+		tmp.mask = BIT(flag);
+
+		dsa_port_bridge_flags(dp, tmp);
 	}
 }
 
@@ -423,28 +424,18 @@ int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
 	return 0;
 }
 
-int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags)
+int dsa_port_bridge_flags(const struct dsa_port *dp,
+			  struct switchdev_brport_flags flags)
 {
 	struct dsa_switch *ds = dp->ds;
+	int port = dp->index;
 
 	if (!ds->ops->port_egress_floods ||
-	    (flags & ~(BR_FLOOD | BR_MCAST_FLOOD)))
+	    (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD)))
 		return -EINVAL;
 
-	return 0;
-}
-
-int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags)
-{
-	struct dsa_switch *ds = dp->ds;
-	int port = dp->index;
-	int err = 0;
-
-	if (ds->ops->port_egress_floods)
-		err = ds->ops->port_egress_floods(ds, port, flags & BR_FLOOD,
-						  flags & BR_MCAST_FLOOD);
-
-	return err;
+	return ds->ops->port_egress_floods(ds, port, flags.val & BR_FLOOD,
+					   flags.val & BR_MCAST_FLOOD);
 }
 
 int dsa_port_mrouter(struct dsa_port *dp, bool mrouter)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8f4c7c232e2c..0e1f8f1d4e2c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -290,9 +290,6 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
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

