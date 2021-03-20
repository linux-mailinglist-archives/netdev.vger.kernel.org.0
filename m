Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2785334300B
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 23:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhCTWgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 18:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhCTWfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 18:35:36 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A73C061763;
        Sat, 20 Mar 2021 15:35:36 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id hq27so15291045ejc.9;
        Sat, 20 Mar 2021 15:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J8YAC1uwHCk1hgPlMm7HJR85SXBcUjAUNou54XaHHWg=;
        b=CA4ejeTPH2NE9n/9ESnAbxdLzYntzEpNAqiiftwOTlz3qFpgMsUn7xMLMjN1M8nBPx
         4JXcuaTLZcA/4vs+N/w2nFmRFm8vU3sm/0cNH4gDCn/TCFZpsB11A4pO4BeGgnNMJh9V
         21cuyyfgiQ318F3IVSUdA4B3D3uQfJE8cDFu5bDYfpCNzsK8q61krWww+9zFjkPvNSBu
         ljuLK/bazed3oBT8qgDuX5ceGsyjFtNqBpBOmfAhbY68xiWSW8RfPGQxcnx+DqOQ+C9U
         Cum97rJtXahtXKZHmclXxBpwAdQjVvxkjbm580vpsnc6FYsReOmBDTG29QBMXZQDJlFi
         dr3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J8YAC1uwHCk1hgPlMm7HJR85SXBcUjAUNou54XaHHWg=;
        b=lLh5odEVw7BE01dKa0hKxeQ4ubN09o1H04QPV+IipOIV1SxFkvAbWNaFyulGZ26Ty+
         3Ajv+dTLXycO7dLxHGObmCOE8FhDDEu6thj+g+5yDByjHom8ff852WGSEk1TprlK7Qn3
         uTSMC0K3Uo4hXzElWQDotdFkn0721TafQQPdm26vJvSu/OhzmsfFD8IfH3+bPbBbc5hB
         SvKZHOPORf3kCqmKrEIx6j8nTf4n968gXkR8L7f2hrAZZ/sMkdH9zkUZP/R+n025+eZP
         8MHdIYVawUEDgkGrKr+XzVuW4EBY8DoIStXZRFlFJmu5k9i0hPOSGHNJ+XokXAmhd07A
         oGyg==
X-Gm-Message-State: AOAM5321zDy1WE3kV8WImAu+MimO42Giqx8JD9SrgNs+whllFVuaxLXD
        WTXJ7xMj0MU8Sn2m3k2GnmU=
X-Google-Smtp-Source: ABdhPJy2TyyM+QxGYlqcAih/GvwKcA0n570zBSjsue6GZNy0Det6lf098mRkYVycGCAiXwX8MVGTig==
X-Received: by 2002:a17:906:1c98:: with SMTP id g24mr11708378ejh.51.1616279734918;
        Sat, 20 Mar 2021 15:35:34 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n2sm6090850ejl.1.2021.03.20.15.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 15:35:34 -0700 (PDT)
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
Subject: [PATCH v3 net-next 12/12] net: ocelot: replay switchdev events when joining bridge
Date:   Sun, 21 Mar 2021 00:34:48 +0200
Message-Id: <20210320223448.2452869-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210320223448.2452869-1-olteanv@gmail.com>
References: <20210320223448.2452869-1-olteanv@gmail.com>
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
Changes in v3:
Added -EOPNOTSUPP to br_mdb_replay and br_vlan_replay, which can be
compiled out.

 drivers/net/dsa/ocelot/felix.c         |   4 +-
 drivers/net/ethernet/mscc/ocelot.c     |  18 ++--
 drivers/net/ethernet/mscc/ocelot_net.c | 117 +++++++++++++++++++++----
 include/soc/mscc/ocelot.h              |   6 +-
 4 files changed, 111 insertions(+), 34 deletions(-)

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

