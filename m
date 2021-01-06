Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C94F2EC6C4
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbhAFXTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727878AbhAFXTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 18:19:11 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372FEC06135B
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 15:18:05 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id q22so7367733eja.2
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 15:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zRUgN6h11Fruj8QZN9ZX8W0q8/MQWVUot1iJdv2ebks=;
        b=R5qomqyx5ywaY8kTRnv0MCl56afJpaJ2ziz2IVl1BVLs/ex2vS8YXDLuTb5vBaIREE
         EHmyGxQdwbfgSLLd7n2BE/J+PCedUdRBrMYeh2g4PNreVLi8Ea2AYouD/DLf8MCLiYHy
         S5cGiLzKfjMMkIp7zO1wpuzXtCHTfkatAZV5gsjCykiA5PGDj5f8kPR55fT7ZfiWZoDr
         r0RTqckGHnTuOMbfryEYiiEnH69Zgd8Yi+ZLm6r/PPN0HtCaRZ3tksZwrXmnfvTrNxUI
         qzHKMdQSOA7LGM01fQmM3NG8k25kIjVdF/JFz99npnSCtqbX+x5TB2qXmyD2pLHt2dC+
         wc2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zRUgN6h11Fruj8QZN9ZX8W0q8/MQWVUot1iJdv2ebks=;
        b=joS6jUw8YE/rdh9eZJpdbWhc+dKueWg09ub/2FHKYmRBw8a4tXAk5Jucfy6wIwfq5k
         DMAx1lDK3/OzGsVb/GU34kiKwo4iKAz9o18uUYIGw+BsA639PiOggrYNo5CTAbqKblgN
         hE3eDdQDmKvcHopxZanUx5BeZ8f9nG2+uXxHLvxt2UyOt1rJDO3N1qwlBU5B6YL+3vdl
         /5ZoDJtW1zicLyWZr0XMjy10rIvuruFw4hrdXXmFd+xq7XU4XpVZBRnlD9PWodbxKQTl
         2kWJIPeUxPNjsi/dKcqhPPb0PJLx6nyMdiNNzTGc8tb1olGlMZDlFdCaD9TCdH7UGemC
         F2Qg==
X-Gm-Message-State: AOAM5306HqbWLWbdSEPEULoffW8XGp1lIQ/uGpHOAdgOhwWMVtsk5V6j
        5ed3R+Y7y3PysGw6WGortHA=
X-Google-Smtp-Source: ABdhPJzQxZwD5Ls08HEHLq+zoNF3sXmtwZq2ko+X2rOMJb5u4ZsgFQJQ7ANmhtMiKQOwtY8TdH/e9w==
X-Received: by 2002:a17:906:4c55:: with SMTP id d21mr4465344ejw.116.1609975083926;
        Wed, 06 Jan 2021 15:18:03 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a6sm1958263edv.74.2021.01.06.15.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 15:18:02 -0800 (PST)
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
Subject: [PATCH v3 net-next 10/11] mlxsw: spectrum_switchdev: remove transactional logic for VLAN objects
Date:   Thu,  7 Jan 2021 01:17:27 +0200
Message-Id: <20210106231728.1363126-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106231728.1363126-1-olteanv@gmail.com>
References: <20210106231728.1363126-1-olteanv@gmail.com>
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

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
Changes in v3:
Restored the comment to its original state.

Changes in v2:
Rebased on top of VLAN ranges removal.

 .../mellanox/mlxsw/spectrum_switchdev.c       | 34 +++----------------
 1 file changed, 4 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 003c4a4fc8db..34a622506d36 100644
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
 		if (err)
 			break;
 
@@ -1783,10 +1775,6 @@ static int mlxsw_sp_port_obj_add(struct net_device *dev,
 		 * updated bridge state.
 		 */
 		mlxsw_sp_span_respin(mlxsw_sp_port->mlxsw_sp);
-
-		trans.ph_prepare = false;
-		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, &trans,
-					      extack);
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		err = mlxsw_sp_port_mdb_add(mlxsw_sp_port,
@@ -3350,8 +3338,7 @@ mlxsw_sp_switchdev_vxlan_vlan_del(struct mlxsw_sp *mlxsw_sp,
 static int
 mlxsw_sp_switchdev_vxlan_vlans_add(struct net_device *vxlan_dev,
 				   struct switchdev_notifier_port_obj_info *
-				   port_obj_info,
-				   struct switchdev_trans *trans)
+				   port_obj_info)
 {
 	struct switchdev_obj_port_vlan *vlan =
 		SWITCHDEV_OBJ_PORT_VLAN(port_obj_info->obj);
@@ -3373,9 +3360,6 @@ mlxsw_sp_switchdev_vxlan_vlans_add(struct net_device *vxlan_dev,
 
 	port_obj_info->handled = true;
 
-	if (switchdev_trans_ph_commit(trans))
-		return 0;
-
 	bridge_device = mlxsw_sp_bridge_device_find(mlxsw_sp->bridge, br_dev);
 	if (!bridge_device)
 		return -EINVAL;
@@ -3426,22 +3410,12 @@ mlxsw_sp_switchdev_handle_vxlan_obj_add(struct net_device *vxlan_dev,
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

