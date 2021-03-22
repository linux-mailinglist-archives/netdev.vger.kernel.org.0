Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C3A345360
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhCVXw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhCVXwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:52:18 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B37C061574;
        Mon, 22 Mar 2021 16:52:17 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h10so21393414edt.13;
        Mon, 22 Mar 2021 16:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hFbiUL7ABXs6BfCWtiegfX2Fp+LkfCID65v2V8vWIyg=;
        b=VLpEciWpNnj73+AwsFpdoev+W/7JfvXO+pWYRqNcxJoJ86J6uDrflJjlSgfK5+9Flb
         nCzXjbloXtKu8W/4opTa8RL179JUfkRWb08CZiECZ1RiB7RkRT7v/vM3AIFRYsu02o96
         w+pVe42CHZr4TQFKp4RqHpJJxlAEptTWVCfiU6BpKb6ciRfSfoz1WKSfLhfbhHepmJMu
         JNKMWcSxajW3xm7lO5Ot8CDa7+IZ/U73+ppF3Rdp0ES4mMwv3YL/ukpZR9rZyjQOUemp
         u9PF9u1Z8DadOrhYXEJDJoBNstm3Zbbr9ZYgQ4VLbdpemziFGtir4cqdmrB5jp2mxUid
         US+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hFbiUL7ABXs6BfCWtiegfX2Fp+LkfCID65v2V8vWIyg=;
        b=FXKlDZ856TAX4TE2cgLEKyC2WUB8xQYn6bPqMahvsCw7a35fwv7Xdk3nZeLfpHVSh+
         8/dwAkc0EKaeC/wHzxlZ5xEQe6ZVgbjZGXCFAhGWGJTMsV4tc4vbbDrepdiYEBAhe+bV
         DkkRuW+BE6jMFXglhejkFoGaDyMTrxT3Fw4OTP1Yzq92b43iVqGIyK6nT2bDVn/XNTuA
         AfwdaByEXVrUab6oJvn5D7ie7YmNmz7sH7CaHc2xq4uNqmnJcKODfgT0XREuNbjV7szR
         L+9PpsNNTsrN8C/QXTkgXTlsSALMgRDP0n6STMsvyJ2ihx5WF+TzdIEePFgR8rBsElwO
         HExw==
X-Gm-Message-State: AOAM532vE8syPx3/eZUMZqvjtJtjCulEJXOVm6/lMu8XHcmz/ceNTzKQ
        Jqvrhc6/yr5ial1bI2PlzGc=
X-Google-Smtp-Source: ABdhPJx/WrLhFLaeMAwner/ZUJclIhZ3h7XEY4vq/xERS8KWTcC3JOx2h6/BzBdJoUwjy1LVmB3uLA==
X-Received: by 2002:aa7:d1d0:: with SMTP id g16mr1991091edp.358.1616457136064;
        Mon, 22 Mar 2021 16:52:16 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q16sm12436933edv.61.2021.03.22.16.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 16:52:15 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 11/11] net: ocelot: replay switchdev events when joining bridge
Date:   Tue, 23 Mar 2021 01:51:52 +0200
Message-Id: <20210322235152.268695-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322235152.268695-1-olteanv@gmail.com>
References: <20210322235152.268695-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The premise of this change is that the switchdev port attributes and
objects offloaded by ocelot might have been missed when we are joining
an already existing bridge port, such as a bonding interface.

The patch pulls these switchdev attributes and objects from the bridge,
on behalf of the 'bridge port' net device which might be either the
ocelot switch interface, or the bonding upper interface.

The ocelot_net.c belongs strictly to the switchdev ocelot driver, while
ocelot.c is part of a library shared with the DSA felix driver.
The ocelot_port_bridge_leave function (part of the common library) used
to call ocelot_port_vlan_filtering(false), something which is not
necessary for DSA, since the framework deals with that already there.
So we move this function to ocelot_switchdev_unsync, which is specific
to the switchdev driver.

The code movement described above makes ocelot_port_bridge_leave no
longer return an error code, so we change its type from int to void.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         |   4 +-
 drivers/net/ethernet/mscc/Kconfig      |   3 +-
 drivers/net/ethernet/mscc/ocelot.c     |  18 ++--
 drivers/net/ethernet/mscc/ocelot_net.c | 117 +++++++++++++++++++++----
 include/soc/mscc/ocelot.h              |   6 +-
 5 files changed, 113 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 628afb47b579..6b5442be0230 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -719,7 +719,9 @@ static int felix_bridge_join(struct dsa_switch *ds, int port,
 {
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_port_bridge_join(ocelot, port, br);
+	ocelot_port_bridge_join(ocelot, port, br);
+
+	return 0;
 }
 
 static void felix_bridge_leave(struct dsa_switch *ds, int port,
diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index 05cb040c2677..2d3157e4d081 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -11,7 +11,7 @@ config NET_VENDOR_MICROSEMI
 
 if NET_VENDOR_MICROSEMI
 
-# Users should depend on NET_SWITCHDEV, HAS_IOMEM
+# Users should depend on NET_SWITCHDEV, HAS_IOMEM, BRIDGE
 config MSCC_OCELOT_SWITCH_LIB
 	select NET_DEVLINK
 	select REGMAP_MMIO
@@ -24,6 +24,7 @@ config MSCC_OCELOT_SWITCH_LIB
 
 config MSCC_OCELOT_SWITCH
 	tristate "Ocelot switch driver"
+	depends on BRIDGE || BRIDGE=n
 	depends on NET_SWITCHDEV
 	depends on HAS_IOMEM
 	depends on OF_NET
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ce57929ba3d1..1a36b416fd9b 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1514,34 +1514,28 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_port_mdb_del);
 
-int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
-			    struct net_device *bridge)
+void ocelot_port_bridge_join(struct ocelot *ocelot, int port,
+			     struct net_device *bridge)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
 	ocelot_port->bridge = bridge;
 
-	return 0;
+	ocelot_apply_bridge_fwd_mask(ocelot);
 }
 EXPORT_SYMBOL(ocelot_port_bridge_join);
 
-int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
-			     struct net_device *bridge)
+void ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
+			      struct net_device *bridge)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct ocelot_vlan pvid = {0}, native_vlan = {0};
-	int ret;
 
 	ocelot_port->bridge = NULL;
 
-	ret = ocelot_port_vlan_filtering(ocelot, port, false);
-	if (ret)
-		return ret;
-
 	ocelot_port_set_pvid(ocelot, port, pvid);
 	ocelot_port_set_native_vlan(ocelot, port, native_vlan);
-
-	return 0;
+	ocelot_apply_bridge_fwd_mask(ocelot);
 }
 EXPORT_SYMBOL(ocelot_port_bridge_leave);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index d1376f7b34fd..36f32a4d9b0f 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1117,47 +1117,126 @@ static int ocelot_port_obj_del(struct net_device *dev,
 	return ret;
 }
 
+static void ocelot_inherit_brport_flags(struct ocelot *ocelot, int port,
+					struct net_device *brport_dev)
+{
+	struct switchdev_brport_flags flags = {0};
+	int flag;
+
+	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
+
+	for_each_set_bit(flag, &flags.mask, 32)
+		if (br_port_flag_is_set(brport_dev, BIT(flag)))
+			flags.val |= BIT(flag);
+
+	ocelot_port_bridge_flags(ocelot, port, flags);
+}
+
+static void ocelot_clear_brport_flags(struct ocelot *ocelot, int port)
+{
+	struct switchdev_brport_flags flags;
+
+	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
+	flags.val = flags.mask & ~BR_LEARNING;
+
+	ocelot_port_bridge_flags(ocelot, port, flags);
+}
+
+static int ocelot_switchdev_sync(struct ocelot *ocelot, int port,
+				 struct net_device *brport_dev,
+				 struct net_device *bridge_dev,
+				 struct netlink_ext_ack *extack)
+{
+	clock_t ageing_time;
+	u8 stp_state;
+	int err;
+
+	ocelot_inherit_brport_flags(ocelot, port, brport_dev);
+
+	stp_state = br_port_get_stp_state(brport_dev);
+	ocelot_bridge_stp_state_set(ocelot, port, stp_state);
+
+	err = ocelot_port_vlan_filtering(ocelot, port,
+					 br_vlan_enabled(bridge_dev));
+	if (err)
+		return err;
+
+	ageing_time = br_get_ageing_time(bridge_dev);
+	ocelot_port_attr_ageing_set(ocelot, port, ageing_time);
+
+	err = br_mdb_replay(bridge_dev, brport_dev,
+			    &ocelot_switchdev_blocking_nb, extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	err = br_fdb_replay(bridge_dev, brport_dev, &ocelot_switchdev_nb);
+	if (err)
+		return err;
+
+	err = br_vlan_replay(bridge_dev, brport_dev,
+			     &ocelot_switchdev_blocking_nb, extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+static int ocelot_switchdev_unsync(struct ocelot *ocelot, int port)
+{
+	int err;
+
+	err = ocelot_port_vlan_filtering(ocelot, port, false);
+	if (err)
+		return err;
+
+	ocelot_clear_brport_flags(ocelot, port);
+
+	ocelot_bridge_stp_state_set(ocelot, port, BR_STATE_FORWARDING);
+
+	return 0;
+}
+
 static int ocelot_netdevice_bridge_join(struct net_device *dev,
+					struct net_device *brport_dev,
 					struct net_device *bridge,
 					struct netlink_ext_ack *extack)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	struct switchdev_brport_flags flags;
 	int port = priv->chip_port;
 	int err;
 
-	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
-	flags.val = flags.mask;
+	ocelot_port_bridge_join(ocelot, port, bridge);
 
-	err = ocelot_port_bridge_join(ocelot, port, bridge);
+	err = ocelot_switchdev_sync(ocelot, port, brport_dev, bridge, extack);
 	if (err)
-		return err;
-
-	ocelot_port_bridge_flags(ocelot, port, flags);
+		goto err_switchdev_sync;
 
 	return 0;
+
+err_switchdev_sync:
+	ocelot_port_bridge_leave(ocelot, port, bridge);
+	return err;
 }
 
 static int ocelot_netdevice_bridge_leave(struct net_device *dev,
+					 struct net_device *brport_dev,
 					 struct net_device *bridge)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	struct switchdev_brport_flags flags;
 	int port = priv->chip_port;
 	int err;
 
-	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
-	flags.val = flags.mask & ~BR_LEARNING;
+	err = ocelot_switchdev_unsync(ocelot, port);
+	if (err)
+		return err;
 
-	err = ocelot_port_bridge_leave(ocelot, port, bridge);
+	ocelot_port_bridge_leave(ocelot, port, bridge);
 
-	ocelot_port_bridge_flags(ocelot, port, flags);
-
-	return err;
+	return 0;
 }
 
 static int ocelot_netdevice_lag_join(struct net_device *dev,
@@ -1182,7 +1261,7 @@ static int ocelot_netdevice_lag_join(struct net_device *dev,
 	if (!bridge_dev || !netif_is_bridge_master(bridge_dev))
 		return 0;
 
-	err = ocelot_netdevice_bridge_join(dev, bridge_dev, extack);
+	err = ocelot_netdevice_bridge_join(dev, bond, bridge_dev, extack);
 	if (err)
 		goto err_bridge_join;
 
@@ -1208,7 +1287,7 @@ static int ocelot_netdevice_lag_leave(struct net_device *dev,
 	if (!bridge_dev || !netif_is_bridge_master(bridge_dev))
 		return 0;
 
-	return ocelot_netdevice_bridge_leave(dev, bridge_dev);
+	return ocelot_netdevice_bridge_leave(dev, bond, bridge_dev);
 }
 
 static int ocelot_netdevice_changeupper(struct net_device *dev,
@@ -1221,10 +1300,12 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
 
 	if (netif_is_bridge_master(info->upper_dev)) {
 		if (info->linking)
-			err = ocelot_netdevice_bridge_join(dev, info->upper_dev,
+			err = ocelot_netdevice_bridge_join(dev, dev,
+							   info->upper_dev,
 							   extack);
 		else
-			err = ocelot_netdevice_bridge_leave(dev, info->upper_dev);
+			err = ocelot_netdevice_bridge_leave(dev, dev,
+							    info->upper_dev);
 	}
 	if (netif_is_lag_master(info->upper_dev)) {
 		if (info->linking)
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index ce7e5c1bd90d..68cdc7ceaf4d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -803,10 +803,10 @@ int ocelot_port_pre_bridge_flags(struct ocelot *ocelot, int port,
 				 struct switchdev_brport_flags val);
 void ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
 			      struct switchdev_brport_flags val);
-int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
-			    struct net_device *bridge);
-int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
+void ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 			     struct net_device *bridge);
+void ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
+			      struct net_device *bridge);
 int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 		    dsa_fdb_dump_cb_t *cb, void *data);
 int ocelot_fdb_add(struct ocelot *ocelot, int port,
-- 
2.25.1

