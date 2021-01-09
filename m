Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968802EFBFD
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbhAIADl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbhAIADf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 19:03:35 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D62C061796
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 16:02:28 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id cw27so12910188edb.5
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 16:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4pl23qWTQMk1sgFRFZr571y1Duw+kqz8+FdVMa1bVZc=;
        b=OfN6QuMjsSx+rwpRWA7IAHM8ZdU7IiKDJrX18r31CaSjsZ6xZcTwpIdzlMDbwJTLts
         HHgXDQfbmxypuOreEtL5S2WSw175l0Wh29XuJwi3vHc9HyDVQPwS4Kg34fWZ0qg+wMr/
         0+gErBQn9jStE0MOd51qVlmF4CzJX42c3xsnptr1aiFK87N/bmQEHeVkYqoRkYiNehHo
         AnxexlA6XBTR8gPd9Ce9FY27KlKbvTh4v1nPvus+fjdDX76MawKKDdCEkAYYObyA2RK7
         VFjso9gzXiHAxibqqn3ssGp5wqIoIfgaXsZIOppZEVsFYZtm0+LpI7D2UOGoQhYOcopR
         4vOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4pl23qWTQMk1sgFRFZr571y1Duw+kqz8+FdVMa1bVZc=;
        b=DJ8Gar6vyZWUqkdIJ6O8qBWZYBm8DPbUEn2jLfVNcXpuIqQWaXZDihJDjpR/dkTbQc
         ui0mbm7/ynsA4ZidgdFpUCrVzQkyOZ9pS58wSUpA/u3S9Kv2ivVLPUFifJ0rLGe4zSvP
         JTLPONBKd4feoOpEBxWnA+AVTh3aUewH5z5icun0TO940Guh5QDSuLpI4WVmXuW9pNaX
         lgdWnSikHy2pQu5gfNY/l0ZUbWGeczhmlUVbrmXMSDQ4NZB4VJ8n3nkFAg1XIZt6rkxh
         xPWmpAMSAh1W3nf0fMUXsCqRE9ULP9OyekJ9dL9TBD+2Wy3HADHSo2iT+hKvKW8wK4oL
         5vkA==
X-Gm-Message-State: AOAM533LGa8IvMGhEKDha2UqnlYc3c/3QVXhaDG0xKn9jD/WzK5pUgvi
        oQqQ5TmVRrBrwA+Jm+G0Ivw=
X-Google-Smtp-Source: ABdhPJy6x2fRv57aeBSeYzRIE6noQM5OQK7JKpeGYA16sbACaYOTZUN4U0+32yHhOM2aBvyy6ndJ4A==
X-Received: by 2002:aa7:dc4b:: with SMTP id g11mr7143105edu.379.1610150547664;
        Fri, 08 Jan 2021 16:02:27 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id dx7sm4045346ejb.120.2021.01.08.16.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 16:02:27 -0800 (PST)
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
        Ivan Vecera <ivecera@redhat.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH v4 net-next 10/11] mlxsw: spectrum_switchdev: remove transactional logic for VLAN objects
Date:   Sat,  9 Jan 2021 02:01:55 +0200
Message-Id: <20210109000156.1246735-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109000156.1246735-1-olteanv@gmail.com>
References: <20210109000156.1246735-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As of commit 457e20d65924 ("mlxsw: spectrum_switchdev: Avoid returning
errors in commit phase"), the mlxsw driver performs the VLAN object
offloading during the prepare phase. So conversion just seems to be a
matter of removing the code that was running in the commit phase.

Ido Schimmel explains that the reason why mlxsw_sp_span_respin is called
unconditionally is because the bridge driver will ignore -EOPNOTSUPP and
actually add the VLAN on the bridge device - see commit 9c86ce2c1ae3
("net: bridge: Notify about bridge VLANs") and commit ea4721751977
("mlxsw: spectrum_switchdev: Ignore bridge VLAN events"). Since the VLAN
was successfully added on the bridge device, mlxsw_sp_span_respin_work()
should be able to resolve the egress port for a packet that is mirrored
to a gre tap and passes through the bridge device. Therefore keep the
logic as it is.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
Changes in v4:
Added one more paragraph to the commit message.

Changes in v3:
Restored the comment to its original state.

Changes in v2:
Rebased on top of VLAN ranges removal.

 .../mellanox/mlxsw/spectrum_switchdev.c       | 37 ++-----------------
 1 file changed, 4 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 409c206f813f..20c4f3c2cf23 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1196,7 +1196,6 @@ mlxsw_sp_br_ban_rif_pvid_change(struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp_port_vlans_add(struct mlxsw_sp_port *mlxsw_sp_port,
 				   const struct switchdev_obj_port_vlan *vlan,
-				   struct switchdev_trans *trans,
 				   struct netlink_ext_ack *extack)
 {
 	bool flag_untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
@@ -1209,8 +1208,7 @@ static int mlxsw_sp_port_vlans_add(struct mlxsw_sp_port *mlxsw_sp_port,
 		int err = 0;
 
 		if ((vlan->flags & BRIDGE_VLAN_INFO_BRENTRY) &&
-		    br_vlan_enabled(orig_dev) &&
-		    switchdev_trans_ph_prepare(trans))
+		    br_vlan_enabled(orig_dev))
 			err = mlxsw_sp_br_ban_rif_pvid_change(mlxsw_sp,
 							      orig_dev, vlan);
 		if (!err)
@@ -1218,9 +1216,6 @@ static int mlxsw_sp_port_vlans_add(struct mlxsw_sp_port *mlxsw_sp_port,
 		return err;
 	}
 
-	if (switchdev_trans_ph_commit(trans))
-		return 0;
-
 	bridge_port = mlxsw_sp_bridge_port_find(mlxsw_sp->bridge, orig_dev);
 	if (WARN_ON(!bridge_port))
 		return -EINVAL;
@@ -1764,16 +1759,13 @@ static int mlxsw_sp_port_obj_add(struct net_device *dev,
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	const struct switchdev_obj_port_vlan *vlan;
-	struct switchdev_trans trans;
 	int err = 0;
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
 
-		trans.ph_prepare = true;
-		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, &trans,
-					      extack);
+		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, extack);
 
 		/* The event is emitted before the changes are actually
 		 * applied to the bridge. Therefore schedule the respin
@@ -1781,13 +1773,6 @@ static int mlxsw_sp_port_obj_add(struct net_device *dev,
 		 * updated bridge state.
 		 */
 		mlxsw_sp_span_respin(mlxsw_sp_port->mlxsw_sp);
-
-		if (err)
-			break;
-
-		trans.ph_prepare = false;
-		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, &trans,
-					      extack);
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		err = mlxsw_sp_port_mdb_add(mlxsw_sp_port,
@@ -3351,8 +3336,7 @@ mlxsw_sp_switchdev_vxlan_vlan_del(struct mlxsw_sp *mlxsw_sp,
 static int
 mlxsw_sp_switchdev_vxlan_vlans_add(struct net_device *vxlan_dev,
 				   struct switchdev_notifier_port_obj_info *
-				   port_obj_info,
-				   struct switchdev_trans *trans)
+				   port_obj_info)
 {
 	struct switchdev_obj_port_vlan *vlan =
 		SWITCHDEV_OBJ_PORT_VLAN(port_obj_info->obj);
@@ -3374,9 +3358,6 @@ mlxsw_sp_switchdev_vxlan_vlans_add(struct net_device *vxlan_dev,
 
 	port_obj_info->handled = true;
 
-	if (switchdev_trans_ph_commit(trans))
-		return 0;
-
 	bridge_device = mlxsw_sp_bridge_device_find(mlxsw_sp->bridge, br_dev);
 	if (!bridge_device)
 		return -EINVAL;
@@ -3427,22 +3408,12 @@ mlxsw_sp_switchdev_handle_vxlan_obj_add(struct net_device *vxlan_dev,
 					struct switchdev_notifier_port_obj_info *
 					port_obj_info)
 {
-	struct switchdev_trans trans;
 	int err = 0;
 
 	switch (port_obj_info->obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		trans.ph_prepare = true;
-		err = mlxsw_sp_switchdev_vxlan_vlans_add(vxlan_dev,
-							 port_obj_info,
-							 &trans);
-		if (err)
-			break;
-
-		trans.ph_prepare = false;
 		err = mlxsw_sp_switchdev_vxlan_vlans_add(vxlan_dev,
-							 port_obj_info,
-							 &trans);
+							 port_obj_info);
 		break;
 	default:
 		break;
-- 
2.25.1

