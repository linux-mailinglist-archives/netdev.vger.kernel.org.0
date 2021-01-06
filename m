Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405F72EC6BA
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbhAFXSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbhAFXSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 18:18:32 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FEAC06179C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 15:17:52 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id dk8so6022393edb.1
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 15:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5F8I+iYDgth7J6iRf/FlF24vL8ZkWWyzc5F1koPGgrE=;
        b=SSR1/Ft9+yYX2uBo8aVB4syBZyU7q6e5oC3/nWlmZK+bI76qF6LbfxDOxo7grD0VH0
         V5MsupS0Ywh65tsyTexnsmZLaZVkV0uAtm1b4+idhA0ZzNam/pST1Gui//CRS/D9atHQ
         5U6fgK3Dh2q48ncHjamHEImvuNihTz1LGewIyB/CjdC17FiFARWqSca2qkliWgdTxPE4
         sd3JniECFZXaSJWRXD9kYFywQJT1A74Hfc2P/O8IibMZxCnQcyC1mw7EyJyau0adctth
         yEfvD+p1WUjvuVDn/Y7uTr4IFkTscO8v7eGAYLFbWRvrGwkZd5gWOnluavPB/jhod5nv
         29eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5F8I+iYDgth7J6iRf/FlF24vL8ZkWWyzc5F1koPGgrE=;
        b=aYDSFDqt0jkAzJ6TtrKnXtbzdnq1Zmtt84e8o4WwLhyJiebPBOtpofvohG6+O2+htj
         SL/1S0rWLuLHrsOTpxkf0sxbw7y5Ux5V5hqgr9Te4bi+3H+sJK1MMyeZ5IaJQOepOFlK
         jZiFoWixczvH8SomRkRdjpkqkfqzuh/3ZAluAMN3uS+tayo1aCoLxlWRKjVDpcQiCWvA
         +KR60ZuzPmeSXgKkQPT7R+o1g3uAI4R1hcz5jA+J15zGyY8QZ+lY42NpgJTn5ba7HXK+
         BTnUvceXoMkxj2lbQMck4QkAP+HAAECedJpTx4303o/KjXG+y2dulg74FtHX7vnueQ/X
         S72g==
X-Gm-Message-State: AOAM532SPyV8CcjBWi1upw4p+bH283mxSh9FTQzTQZEGig4c938+3PjX
        nx/Kt+rM/oJtDzLkc2460rbqIsYyRXvtQg==
X-Google-Smtp-Source: ABdhPJwxSALR2eRa0nxLx2Xr4GwSrNYi3T77+zSFvRaAJmOUdBzlEvJnDHJ/9TsuzhOMz/4QOMaiTg==
X-Received: by 2002:a05:6402:22ea:: with SMTP id dn10mr5400710edb.67.1609975070784;
        Wed, 06 Jan 2021 15:17:50 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a6sm1958263edv.74.2021.01.06.15.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 15:17:50 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v3 net-next 03/11] net: switchdev: remove the transaction structure from port object notifiers
Date:   Thu,  7 Jan 2021 01:17:20 +0200
Message-Id: <20210106231728.1363126-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106231728.1363126-1-olteanv@gmail.com>
References: <20210106231728.1363126-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since the introduction of the switchdev API, port objects were
transmitted to drivers for offloading using a two-step transactional
model, with a prepare phase that was supposed to catch all errors, and a
commit phase that was supposed to never fail.

Some classes of failures can never be avoided, like hardware access, or
memory allocation. In the latter case, merely attempting to move the
memory allocation to the preparation phase makes it impossible to avoid
memory leaks, since commit 91cf8eceffc1 ("switchdev: Remove unused
transaction item queue") which has removed the unused mechanism of
passing on the allocated memory between one phase and another.

It is time we admit that separating the preparation from the commit
phase is something that is best left for the driver to decide, and not
something that should be baked into the API, especially since there are
no switchdev callers that depend on this.

This patch removes the struct switchdev_trans member from switchdev port
object notifier structures, and converts drivers to not look at this
member.

Where driver conversion is trivial (like in the case of the Marvell
Prestera driver, NXP DPAA2 switch, TI CPSW, and Rocker drivers), it is
done in this patch.

Where driver conversion needs more attention (DSA, Mellanox Spectrum),
the conversion is left for subsequent patches and here we only fake the
prepare/commit phases at a lower level, just not in the switchdev
notifier itself.

Where the code has a natural structure that is best left alone as a
preparation and a commit phase (as in the case of the Ocelot switch),
that structure is left in place, just made to not depend upon the
switchdev transactional model.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
Changes in v3:
None.

Changes in v2:
Rebased on top of the VLAN range deletion.

 .../marvell/prestera/prestera_switchdev.c     |  7 +--
 .../mellanox/mlxsw/spectrum_switchdev.c       | 51 +++++++++-------
 drivers/net/ethernet/mscc/ocelot_net.c        | 25 +++-----
 drivers/net/ethernet/rocker/rocker_main.c     | 15 ++---
 drivers/net/ethernet/ti/cpsw_switchdev.c      | 17 ++----
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       | 59 +++++++++----------
 include/net/switchdev.h                       |  3 -
 net/dsa/dsa_priv.h                            |  8 +--
 net/dsa/port.c                                |  8 +--
 net/dsa/slave.c                               | 34 +++--------
 net/dsa/switch.c                              | 36 ++---------
 net/switchdev/switchdev.c                     | 42 ++-----------
 12 files changed, 97 insertions(+), 208 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index c87667c1cca0..3235458a5501 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -1020,7 +1020,6 @@ prestera_bridge_port_vlan_del(struct prestera_port *port,
 
 static int prestera_port_vlans_add(struct prestera_port *port,
 				   const struct switchdev_obj_port_vlan *vlan,
-				   struct switchdev_trans *trans,
 				   struct netlink_ext_ack *extack)
 {
 	bool flag_untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
@@ -1034,9 +1033,6 @@ static int prestera_port_vlans_add(struct prestera_port *port,
 	if (netif_is_bridge_master(dev))
 		return 0;
 
-	if (switchdev_trans_ph_commit(trans))
-		return 0;
-
 	br_port = prestera_bridge_port_by_dev(sw->swdev, dev);
 	if (WARN_ON(!br_port))
 		return -EINVAL;
@@ -1052,7 +1048,6 @@ static int prestera_port_vlans_add(struct prestera_port *port,
 
 static int prestera_port_obj_add(struct net_device *dev,
 				 const struct switchdev_obj *obj,
-				 struct switchdev_trans *trans,
 				 struct netlink_ext_ack *extack)
 {
 	struct prestera_port *port = netdev_priv(dev);
@@ -1061,7 +1056,7 @@ static int prestera_port_obj_add(struct net_device *dev,
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
-		return prestera_port_vlans_add(port, vlan, trans, extack);
+		return prestera_port_vlans_add(port, vlan, extack);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 7039cff69680..6620233bd656 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1704,8 +1704,7 @@ static int mlxsw_sp_port_remove_from_mid(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int mlxsw_sp_port_mdb_add(struct mlxsw_sp_port *mlxsw_sp_port,
-				 const struct switchdev_obj_port_mdb *mdb,
-				 struct switchdev_trans *trans)
+				 const struct switchdev_obj_port_mdb *mdb)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct net_device *orig_dev = mdb->obj.orig_dev;
@@ -1717,9 +1716,6 @@ static int mlxsw_sp_port_mdb_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	u16 fid_index;
 	int err = 0;
 
-	if (switchdev_trans_ph_commit(trans))
-		return 0;
-
 	bridge_port = mlxsw_sp_bridge_port_find(mlxsw_sp->bridge, orig_dev);
 	if (!bridge_port)
 		return 0;
@@ -1801,32 +1797,37 @@ mlxsw_sp_port_mrouter_update_mdb(struct mlxsw_sp_port *mlxsw_sp_port,
 
 static int mlxsw_sp_port_obj_add(struct net_device *dev,
 				 const struct switchdev_obj *obj,
-				 struct switchdev_trans *trans,
 				 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	const struct switchdev_obj_port_vlan *vlan;
+	struct switchdev_trans trans;
 	int err = 0;
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
-		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, trans,
+
+		trans.ph_prepare = true;
+		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, &trans,
 					      extack);
+		if (err)
+			break;
 
-		if (switchdev_trans_ph_prepare(trans)) {
-			/* The event is emitted before the changes are actually
-			 * applied to the bridge. Therefore schedule the respin
-			 * call for later, so that the respin logic sees the
-			 * updated bridge state.
-			 */
-			mlxsw_sp_span_respin(mlxsw_sp_port->mlxsw_sp);
-		}
+		/* The event is emitted before the changes are actually
+		 * applied to the bridge. Therefore schedule the respin
+		 * call for later, so that the respin logic sees the
+		 * updated bridge state.
+		 */
+		mlxsw_sp_span_respin(mlxsw_sp_port->mlxsw_sp);
+
+		trans.ph_prepare = false;
+		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, &trans,
+					      extack);
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		err = mlxsw_sp_port_mdb_add(mlxsw_sp_port,
-					    SWITCHDEV_OBJ_PORT_MDB(obj),
-					    trans);
+					    SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	default:
 		err = -EOPNOTSUPP;
@@ -3386,13 +3387,13 @@ mlxsw_sp_switchdev_vxlan_vlan_del(struct mlxsw_sp *mlxsw_sp,
 static int
 mlxsw_sp_switchdev_vxlan_vlans_add(struct net_device *vxlan_dev,
 				   struct switchdev_notifier_port_obj_info *
-				   port_obj_info)
+				   port_obj_info,
+				   struct switchdev_trans *trans)
 {
 	struct switchdev_obj_port_vlan *vlan =
 		SWITCHDEV_OBJ_PORT_VLAN(port_obj_info->obj);
 	bool flag_untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool flag_pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
-	struct switchdev_trans *trans = port_obj_info->trans;
 	struct mlxsw_sp_bridge_device *bridge_device;
 	struct netlink_ext_ack *extack;
 	struct mlxsw_sp *mlxsw_sp;
@@ -3462,12 +3463,22 @@ mlxsw_sp_switchdev_handle_vxlan_obj_add(struct net_device *vxlan_dev,
 					struct switchdev_notifier_port_obj_info *
 					port_obj_info)
 {
+	struct switchdev_trans trans;
 	int err = 0;
 
 	switch (port_obj_info->obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		trans.ph_prepare = true;
+		err = mlxsw_sp_switchdev_vxlan_vlans_add(vxlan_dev,
+							 port_obj_info,
+							 &trans);
+		if (err)
+			break;
+
+		trans.ph_prepare = false;
 		err = mlxsw_sp_switchdev_vxlan_vlans_add(vxlan_dev,
-							 port_obj_info);
+							 port_obj_info,
+							 &trans);
 		break;
 	default:
 		break;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 3b8718b143bb..16d958a6e206 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -890,33 +890,27 @@ static int ocelot_port_attr_set(struct net_device *dev,
 }
 
 static int ocelot_port_obj_add_vlan(struct net_device *dev,
-				    const struct switchdev_obj_port_vlan *vlan,
-				    struct switchdev_trans *trans)
+				    const struct switchdev_obj_port_vlan *vlan)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	int ret;
 
-	if (switchdev_trans_ph_prepare(trans))
-		ret = ocelot_vlan_vid_prepare(dev, vlan->vid, pvid, untagged);
-	else
-		ret = ocelot_vlan_vid_add(dev, vlan->vid, pvid, untagged);
+	ret = ocelot_vlan_vid_prepare(dev, vlan->vid, pvid, untagged);
+	if (ret)
+		return ret;
 
-	return ret;
+	return ocelot_vlan_vid_add(dev, vlan->vid, pvid, untagged);
 }
 
 static int ocelot_port_obj_add_mdb(struct net_device *dev,
-				   const struct switchdev_obj_port_mdb *mdb,
-				   struct switchdev_trans *trans)
+				   const struct switchdev_obj_port_mdb *mdb)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	return ocelot_port_mdb_add(ocelot, port, mdb);
 }
 
@@ -933,7 +927,6 @@ static int ocelot_port_obj_del_mdb(struct net_device *dev,
 
 static int ocelot_port_obj_add(struct net_device *dev,
 			       const struct switchdev_obj *obj,
-			       struct switchdev_trans *trans,
 			       struct netlink_ext_ack *extack)
 {
 	int ret = 0;
@@ -941,12 +934,10 @@ static int ocelot_port_obj_add(struct net_device *dev,
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		ret = ocelot_port_obj_add_vlan(dev,
-					       SWITCHDEV_OBJ_PORT_VLAN(obj),
-					       trans);
+					       SWITCHDEV_OBJ_PORT_VLAN(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		ret = ocelot_port_obj_add_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj),
-					      trans);
+		ret = ocelot_port_obj_add_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index dd0bc7f0aaee..1018d3759316 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -1638,17 +1638,13 @@ rocker_world_port_attr_bridge_ageing_time_set(struct rocker_port *rocker_port,
 
 static int
 rocker_world_port_obj_vlan_add(struct rocker_port *rocker_port,
-			       const struct switchdev_obj_port_vlan *vlan,
-			       struct switchdev_trans *trans)
+			       const struct switchdev_obj_port_vlan *vlan)
 {
 	struct rocker_world_ops *wops = rocker_port->rocker->wops;
 
 	if (!wops->port_obj_vlan_add)
 		return -EOPNOTSUPP;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	return wops->port_obj_vlan_add(rocker_port, vlan);
 }
 
@@ -2102,8 +2098,7 @@ static int rocker_port_attr_set(struct net_device *dev,
 }
 
 static int rocker_port_obj_add(struct net_device *dev,
-			       const struct switchdev_obj *obj,
-			       struct switchdev_trans *trans)
+			       const struct switchdev_obj *obj)
 {
 	struct rocker_port *rocker_port = netdev_priv(dev);
 	int err = 0;
@@ -2111,8 +2106,7 @@ static int rocker_port_obj_add(struct net_device *dev,
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		err = rocker_world_port_obj_vlan_add(rocker_port,
-						     SWITCHDEV_OBJ_PORT_VLAN(obj),
-						     trans);
+						     SWITCHDEV_OBJ_PORT_VLAN(obj));
 		break;
 	default:
 		err = -EOPNOTSUPP;
@@ -2847,8 +2841,7 @@ rocker_switchdev_port_obj_event(unsigned long event, struct net_device *netdev,
 
 	switch (event) {
 	case SWITCHDEV_PORT_OBJ_ADD:
-		err = rocker_port_obj_add(netdev, port_obj_info->obj,
-					  port_obj_info->trans);
+		err = rocker_port_obj_add(netdev, port_obj_info->obj);
 		break;
 	case SWITCHDEV_PORT_OBJ_DEL:
 		err = rocker_port_obj_del(netdev, port_obj_info->obj);
diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
index 8a36228acc5d..3232f483c068 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -253,8 +253,7 @@ static int cpsw_port_vlan_del(struct cpsw_priv *priv, u16 vid,
 }
 
 static int cpsw_port_vlans_add(struct cpsw_priv *priv,
-			       const struct switchdev_obj_port_vlan *vlan,
-			       struct switchdev_trans *trans)
+			       const struct switchdev_obj_port_vlan *vlan)
 {
 	bool untag = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct net_device *orig_dev = vlan->obj.orig_dev;
@@ -267,15 +266,11 @@ static int cpsw_port_vlans_add(struct cpsw_priv *priv,
 	if (cpu_port && !(vlan->flags & BRIDGE_VLAN_INFO_BRENTRY))
 		return 0;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	return cpsw_port_vlan_add(priv, untag, pvid, vlan->vid, orig_dev);
 }
 
 static int cpsw_port_mdb_add(struct cpsw_priv *priv,
-			     struct switchdev_obj_port_mdb *mdb,
-			     struct switchdev_trans *trans)
+			     struct switchdev_obj_port_mdb *mdb)
 
 {
 	struct net_device *orig_dev = mdb->obj.orig_dev;
@@ -284,9 +279,6 @@ static int cpsw_port_mdb_add(struct cpsw_priv *priv,
 	int port_mask;
 	int err;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	if (cpu_port)
 		port_mask = BIT(HOST_PORT_NUM);
 	else
@@ -325,7 +317,6 @@ static int cpsw_port_mdb_del(struct cpsw_priv *priv,
 
 static int cpsw_port_obj_add(struct net_device *ndev,
 			     const struct switchdev_obj *obj,
-			     struct switchdev_trans *trans,
 			     struct netlink_ext_ack *extack)
 {
 	struct switchdev_obj_port_vlan *vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
@@ -338,11 +329,11 @@ static int cpsw_port_obj_add(struct net_device *ndev,
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		err = cpsw_port_vlans_add(priv, vlan, trans);
+		err = cpsw_port_vlans_add(priv, vlan);
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
-		err = cpsw_port_mdb_add(priv, mdb, trans);
+		err = cpsw_port_mdb_add(priv, mdb);
 		break;
 	default:
 		err = -EOPNOTSUPP;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 62edb8d01f4e..197dea9c3b42 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -975,33 +975,38 @@ static int dpaa2_switch_port_attr_set(struct net_device *netdev,
 }
 
 static int dpaa2_switch_port_vlans_add(struct net_device *netdev,
-				       const struct switchdev_obj_port_vlan *vlan,
-				       struct switchdev_trans *trans)
+				       const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	struct dpsw_attr *attr = &ethsw->sw_attr;
 	int err = 0;
 
-	if (switchdev_trans_ph_prepare(trans)) {
-		/* Make sure that the VLAN is not already configured
-		 * on the switch port
-		 */
-		if (port_priv->vlans[vlan->vid] & ETHSW_VLAN_MEMBER)
-			return -EEXIST;
+	/* Make sure that the VLAN is not already configured
+	 * on the switch port
+	 */
+	if (port_priv->vlans[vlan->vid] & ETHSW_VLAN_MEMBER)
+		return -EEXIST;
 
-		/* Check if there is space for a new VLAN */
-		err = dpsw_get_attributes(ethsw->mc_io, 0, ethsw->dpsw_handle,
-					  &ethsw->sw_attr);
-		if (err) {
-			netdev_err(netdev, "dpsw_get_attributes err %d\n", err);
-			return err;
-		}
-		if (attr->max_vlans - attr->num_vlans < 1)
-			return -ENOSPC;
+	/* Check if there is space for a new VLAN */
+	err = dpsw_get_attributes(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				  &ethsw->sw_attr);
+	if (err) {
+		netdev_err(netdev, "dpsw_get_attributes err %d\n", err);
+		return err;
+	}
+	if (attr->max_vlans - attr->num_vlans < 1)
+		return -ENOSPC;
 
-		return 0;
+	/* Check if there is space for a new VLAN */
+	err = dpsw_get_attributes(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				  &ethsw->sw_attr);
+	if (err) {
+		netdev_err(netdev, "dpsw_get_attributes err %d\n", err);
+		return err;
 	}
+	if (attr->max_vlans - attr->num_vlans < 1)
+		return -ENOSPC;
 
 	if (!port_priv->ethsw_data->vlans[vlan->vid]) {
 		/* this is a new VLAN */
@@ -1033,15 +1038,11 @@ static int dpaa2_switch_port_lookup_address(struct net_device *netdev, int is_uc
 }
 
 static int dpaa2_switch_port_mdb_add(struct net_device *netdev,
-				     const struct switchdev_obj_port_mdb *mdb,
-				     struct switchdev_trans *trans)
+				     const struct switchdev_obj_port_mdb *mdb)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	int err;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	/* Check if address is already set on this port */
 	if (dpaa2_switch_port_lookup_address(netdev, 0, mdb->addr))
 		return -EEXIST;
@@ -1060,21 +1061,18 @@ static int dpaa2_switch_port_mdb_add(struct net_device *netdev,
 }
 
 static int dpaa2_switch_port_obj_add(struct net_device *netdev,
-				     const struct switchdev_obj *obj,
-				     struct switchdev_trans *trans)
+				     const struct switchdev_obj *obj)
 {
 	int err;
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		err = dpaa2_switch_port_vlans_add(netdev,
-						  SWITCHDEV_OBJ_PORT_VLAN(obj),
-						  trans);
+						  SWITCHDEV_OBJ_PORT_VLAN(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		err = dpaa2_switch_port_mdb_add(netdev,
-						SWITCHDEV_OBJ_PORT_MDB(obj),
-						trans);
+						SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	default:
 		err = -EOPNOTSUPP;
@@ -1394,8 +1392,7 @@ static int dpaa2_switch_port_obj_event(unsigned long event,
 
 	switch (event) {
 	case SWITCHDEV_PORT_OBJ_ADD:
-		err = dpaa2_switch_port_obj_add(netdev, port_obj_info->obj,
-						port_obj_info->trans);
+		err = dpaa2_switch_port_obj_add(netdev, port_obj_info->obj);
 		break;
 	case SWITCHDEV_PORT_OBJ_DEL:
 		err = dpaa2_switch_port_obj_del(netdev, port_obj_info->obj);
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index bac7d3ba574f..cbe6e35d51f5 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -233,7 +233,6 @@ struct switchdev_notifier_fdb_info {
 struct switchdev_notifier_port_obj_info {
 	struct switchdev_notifier_info info; /* must be first */
 	const struct switchdev_obj *obj;
-	struct switchdev_trans *trans;
 	bool handled;
 };
 
@@ -288,7 +287,6 @@ int switchdev_handle_port_obj_add(struct net_device *dev,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*add_cb)(struct net_device *dev,
 				      const struct switchdev_obj *obj,
-				      struct switchdev_trans *trans,
 				      struct netlink_ext_ack *extack));
 int switchdev_handle_port_obj_del(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
@@ -372,7 +370,6 @@ switchdev_handle_port_obj_add(struct net_device *dev,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*add_cb)(struct net_device *dev,
 				      const struct switchdev_obj *obj,
-				      struct switchdev_trans *trans,
 				      struct netlink_ext_ack *extack))
 {
 	return 0;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 7c96aae9062c..6132b66fa2c0 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -52,7 +52,6 @@ struct dsa_notifier_fdb_info {
 /* DSA_NOTIFIER_MDB_* */
 struct dsa_notifier_mdb_info {
 	const struct switchdev_obj_port_mdb *mdb;
-	struct switchdev_trans *trans;
 	int sw_index;
 	int port;
 };
@@ -60,7 +59,6 @@ struct dsa_notifier_mdb_info {
 /* DSA_NOTIFIER_VLAN_* */
 struct dsa_notifier_vlan_info {
 	const struct switchdev_obj_port_vlan *vlan;
-	struct switchdev_trans *trans;
 	int sw_index;
 	int port;
 };
@@ -148,8 +146,7 @@ int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data);
 int dsa_port_mdb_add(const struct dsa_port *dp,
-		     const struct switchdev_obj_port_mdb *mdb,
-		     struct switchdev_trans *trans);
+		     const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_mdb_del(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags,
@@ -159,8 +156,7 @@ int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags,
 int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
 		     struct switchdev_trans *trans);
 int dsa_port_vlan_add(struct dsa_port *dp,
-		      const struct switchdev_obj_port_vlan *vlan,
-		      struct switchdev_trans *trans);
+		      const struct switchdev_obj_port_vlan *vlan);
 int dsa_port_vlan_del(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
 int dsa_port_link_register_of(struct dsa_port *dp);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 73569c9af3cc..6668fe188f47 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -425,13 +425,11 @@ int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data)
 }
 
 int dsa_port_mdb_add(const struct dsa_port *dp,
-		     const struct switchdev_obj_port_mdb *mdb,
-		     struct switchdev_trans *trans)
+		     const struct switchdev_obj_port_mdb *mdb)
 {
 	struct dsa_notifier_mdb_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.trans = trans,
 		.mdb = mdb,
 	};
 
@@ -451,13 +449,11 @@ int dsa_port_mdb_del(const struct dsa_port *dp,
 }
 
 int dsa_port_vlan_add(struct dsa_port *dp,
-		      const struct switchdev_obj_port_vlan *vlan,
-		      struct switchdev_trans *trans)
+		      const struct switchdev_obj_port_vlan *vlan)
 {
 	struct dsa_notifier_vlan_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.trans = trans,
 		.vlan = vlan,
 	};
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 62b7dcfd16ce..c5538cf19862 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -326,8 +326,7 @@ dsa_slave_vlan_check_for_8021q_uppers(struct net_device *slave,
 }
 
 static int dsa_slave_vlan_add(struct net_device *dev,
-			      const struct switchdev_obj *obj,
-			      struct switchdev_trans *trans)
+			      const struct switchdev_obj *obj)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -345,7 +344,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	/* Deny adding a bridge VLAN when there is already an 802.1Q upper with
 	 * the same VID.
 	 */
-	if (trans->ph_prepare && br_vlan_enabled(dp->bridge_dev)) {
+	if (br_vlan_enabled(dp->bridge_dev)) {
 		rcu_read_lock();
 		err = dsa_slave_vlan_check_for_8021q_uppers(dev, &vlan);
 		rcu_read_unlock();
@@ -353,7 +352,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 			return err;
 	}
 
-	err = dsa_port_vlan_add(dp, &vlan, trans);
+	err = dsa_port_vlan_add(dp, &vlan);
 	if (err)
 		return err;
 
@@ -363,7 +362,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	 */
 	vlan.flags &= ~BRIDGE_VLAN_INFO_PVID;
 
-	err = dsa_port_vlan_add(dp->cpu_dp, &vlan, trans);
+	err = dsa_port_vlan_add(dp->cpu_dp, &vlan);
 	if (err)
 		return err;
 
@@ -372,7 +371,6 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 
 static int dsa_slave_port_obj_add(struct net_device *dev,
 				  const struct switchdev_obj *obj,
-				  struct switchdev_trans *trans,
 				  struct netlink_ext_ack *extack)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -387,17 +385,16 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		if (obj->orig_dev != dev)
 			return -EOPNOTSUPP;
-		err = dsa_port_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj), trans);
+		err = dsa_port_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
 		/* DSA can directly translate this to a normal MDB add,
 		 * but on the CPU port.
 		 */
-		err = dsa_port_mdb_add(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj),
-				       trans);
+		err = dsa_port_mdb_add(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		err = dsa_slave_vlan_add(dev, obj, trans);
+		err = dsa_slave_vlan_add(dev, obj);
 		break;
 	default:
 		err = -EOPNOTSUPP;
@@ -1286,28 +1283,15 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 		/* This API only allows programming tagged, non-PVID VIDs */
 		.flags = 0,
 	};
-	struct switchdev_trans trans;
 	int ret;
 
 	/* User port... */
-	trans.ph_prepare = true;
-	ret = dsa_port_vlan_add(dp, &vlan, &trans);
-	if (ret)
-		return ret;
-
-	trans.ph_prepare = false;
-	ret = dsa_port_vlan_add(dp, &vlan, &trans);
+	ret = dsa_port_vlan_add(dp, &vlan);
 	if (ret)
 		return ret;
 
 	/* And CPU port... */
-	trans.ph_prepare = true;
-	ret = dsa_port_vlan_add(dp->cpu_dp, &vlan, &trans);
-	if (ret)
-		return ret;
-
-	trans.ph_prepare = false;
-	ret = dsa_port_vlan_add(dp->cpu_dp, &vlan, &trans);
+	ret = dsa_port_vlan_add(dp->cpu_dp, &vlan);
 	if (ret)
 		return ret;
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 3fb362b6874e..5b0bf29e1375 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -190,8 +190,8 @@ static bool dsa_switch_mdb_match(struct dsa_switch *ds, int port,
 	return false;
 }
 
-static int dsa_switch_mdb_prepare(struct dsa_switch *ds,
-				  struct dsa_notifier_mdb_info *info)
+static int dsa_switch_mdb_add(struct dsa_switch *ds,
+			      struct dsa_notifier_mdb_info *info)
 {
 	int port, err;
 
@@ -206,20 +206,6 @@ static int dsa_switch_mdb_prepare(struct dsa_switch *ds,
 		}
 	}
 
-	return 0;
-}
-
-static int dsa_switch_mdb_add(struct dsa_switch *ds,
-			      struct dsa_notifier_mdb_info *info)
-{
-	int port;
-
-	if (switchdev_trans_ph_prepare(info->trans))
-		return dsa_switch_mdb_prepare(ds, info);
-
-	if (!ds->ops->port_mdb_add)
-		return 0;
-
 	for (port = 0; port < ds->num_ports; port++)
 		if (dsa_switch_mdb_match(ds, port, info))
 			ds->ops->port_mdb_add(ds, port, info->mdb);
@@ -251,8 +237,8 @@ static bool dsa_switch_vlan_match(struct dsa_switch *ds, int port,
 	return false;
 }
 
-static int dsa_switch_vlan_prepare(struct dsa_switch *ds,
-				   struct dsa_notifier_vlan_info *info)
+static int dsa_switch_vlan_add(struct dsa_switch *ds,
+			       struct dsa_notifier_vlan_info *info)
 {
 	int port, err;
 
@@ -267,20 +253,6 @@ static int dsa_switch_vlan_prepare(struct dsa_switch *ds,
 		}
 	}
 
-	return 0;
-}
-
-static int dsa_switch_vlan_add(struct dsa_switch *ds,
-			       struct dsa_notifier_vlan_info *info)
-{
-	int port;
-
-	if (switchdev_trans_ph_prepare(info->trans))
-		return dsa_switch_vlan_prepare(ds, info);
-
-	if (!ds->ops->port_vlan_add)
-		return 0;
-
 	for (port = 0; port < ds->num_ports; port++)
 		if (dsa_switch_vlan_match(ds, port, info))
 			ds->ops->port_vlan_add(ds, port, info->vlan);
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 23d868545362..a575bb33ee6c 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -221,7 +221,6 @@ static size_t switchdev_obj_size(const struct switchdev_obj *obj)
 static int switchdev_port_obj_notify(enum switchdev_notifier_type nt,
 				     struct net_device *dev,
 				     const struct switchdev_obj *obj,
-				     struct switchdev_trans *trans,
 				     struct netlink_ext_ack *extack)
 {
 	int rc;
@@ -229,7 +228,6 @@ static int switchdev_port_obj_notify(enum switchdev_notifier_type nt,
 
 	struct switchdev_notifier_port_obj_info obj_info = {
 		.obj = obj,
-		.trans = trans,
 		.handled = false,
 	};
 
@@ -248,35 +246,10 @@ static int switchdev_port_obj_add_now(struct net_device *dev,
 				      const struct switchdev_obj *obj,
 				      struct netlink_ext_ack *extack)
 {
-	struct switchdev_trans trans;
-	int err;
-
 	ASSERT_RTNL();
 
-	/* Phase I: prepare for obj add. Driver/device should fail
-	 * here if there are going to be issues in the commit phase,
-	 * such as lack of resources or support.  The driver/device
-	 * should reserve resources needed for the commit phase here,
-	 * but should not commit the obj.
-	 */
-
-	trans.ph_prepare = true;
-	err = switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
-					dev, obj, &trans, extack);
-	if (err)
-		return err;
-
-	/* Phase II: commit obj add.  This cannot fail as a fault
-	 * of driver/device.  If it does, it's a bug in the driver/device
-	 * because the driver said everythings was OK in phase I.
-	 */
-
-	trans.ph_prepare = false;
-	err = switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
-					dev, obj, &trans, extack);
-	WARN(err, "%s: Commit of object (id=%d) failed.\n", dev->name, obj->id);
-
-	return err;
+	return switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
+					 dev, obj, extack);
 }
 
 static void switchdev_port_obj_add_deferred(struct net_device *dev,
@@ -307,10 +280,6 @@ static int switchdev_port_obj_add_defer(struct net_device *dev,
  *	@obj: object to add
  *	@extack: netlink extended ack
  *
- *	Use a 2-phase prepare-commit transaction model to ensure
- *	system is not left in a partially updated state due to
- *	failure from driver/device.
- *
  *	rtnl_lock must be held and must not be in atomic section,
  *	in case SWITCHDEV_F_DEFER flag is not set.
  */
@@ -329,7 +298,7 @@ static int switchdev_port_obj_del_now(struct net_device *dev,
 				      const struct switchdev_obj *obj)
 {
 	return switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_DEL,
-					 dev, obj, NULL, NULL);
+					 dev, obj, NULL);
 }
 
 static void switchdev_port_obj_del_deferred(struct net_device *dev,
@@ -449,7 +418,6 @@ static int __switchdev_handle_port_obj_add(struct net_device *dev,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*add_cb)(struct net_device *dev,
 				      const struct switchdev_obj *obj,
-				      struct switchdev_trans *trans,
 				      struct netlink_ext_ack *extack))
 {
 	struct netlink_ext_ack *extack;
@@ -462,8 +430,7 @@ static int __switchdev_handle_port_obj_add(struct net_device *dev,
 	if (check_cb(dev)) {
 		/* This flag is only checked if the return value is success. */
 		port_obj_info->handled = true;
-		return add_cb(dev, port_obj_info->obj, port_obj_info->trans,
-			      extack);
+		return add_cb(dev, port_obj_info->obj, extack);
 	}
 
 	/* Switch ports might be stacked under e.g. a LAG. Ignore the
@@ -491,7 +458,6 @@ int switchdev_handle_port_obj_add(struct net_device *dev,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*add_cb)(struct net_device *dev,
 				      const struct switchdev_obj *obj,
-				      struct switchdev_trans *trans,
 				      struct netlink_ext_ack *extack))
 {
 	int err;
-- 
2.25.1

