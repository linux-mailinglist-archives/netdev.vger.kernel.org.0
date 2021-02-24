Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925F8323B6E
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbhBXLq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbhBXLp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:45:26 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5142EC061794
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:09 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id h25so2090956eds.4
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zM0PPFR+CS534MEi0dmiqmCC/cSsNMNZs9q4OHJGGfU=;
        b=U9FRwdS2NuAhcGva/znwVxqX6bWldErC0cDJq7BGCBsk+YjizWIF8TOChwNJcbODa+
         t9v1utuWd5+aU7kt/FmNPbHxxj8wg//kY3W49iK3j11OvKSPR7mMdO5pwy5hYK1ebVBX
         Pr96NF4fBetOlx2apzXJ4iZyAj17hGENE5DzcDC3lxc4TzRLkNiEwf6XDV63AZyYRt+9
         moIuezi9O7DqaOPUCC9f5quaEqXbOqOfpIPvboBHfA0UFCu5+10Mz/nCt/LBCWLHUmha
         9lKDAa2SUuOb6c10lT69gBloZC+Tnie8JilQuWENs4ZnCOogKnEijR5mS7xTOl9N5mwL
         4+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zM0PPFR+CS534MEi0dmiqmCC/cSsNMNZs9q4OHJGGfU=;
        b=oFsVZUA+OSuBREWFpq9t9u0U2slWi9THi6CRxmYIL0e84ykovjZbJzPcLB0Rh7wg7W
         2Wcsv8eNKVUqSpeOiKKRDh+1bZ5CacS+7ogNHs9xGNZTCXXqs47FClN6J00QCTD2f2Wm
         U8id3itsaNR9htlAeg4rE7HqMXN61ZB6Gy7RnVmzJweUdSAvYGlAZivutRlq7Zaqyu77
         fKC0VNeCwXXlG4WxUeQ/ltgg0BXVAMS9CEhAd/FcGq8TFQKf/b0p8ePgBRCa1nfMYNv0
         GWaHHqYkw3CLxrWPAS1+JZ45OXIiCp75XeeRjIjnd2K0P6FHRvhBw9wi/ioQMqjPlUJw
         dYRA==
X-Gm-Message-State: AOAM531dxZMabJk42An1O2yEGpJE03uFAnsrGvisZUISmYFYnYOPCI3P
        YM7Rdwh5z7Q2CNAj21PoIF74M4Dyw9I=
X-Google-Smtp-Source: ABdhPJzcz+AkqbOMjB1kzCWIcQBVWC0++fT5pEhHq8s3ge2P6c7KQVL/099XCqVVHSgLdcIEFz3SwQ==
X-Received: by 2002:a05:6402:5107:: with SMTP id m7mr4077050edd.155.1614167047669;
        Wed, 24 Feb 2021 03:44:07 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:07 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH v2 net-next 06/17] net: dsa: add addresses obtained from RX filtering to host addresses
Date:   Wed, 24 Feb 2021 13:43:39 +0200
Message-Id: <20210224114350.2791260-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In case we have ptp4l running on a bridged DSA switch interface, the PTP
traffic is classified as link-local (in the default profile, the MAC
addresses are 01:1b:19:00:00:00 and 01:80:c2:00:00:0e), which means it
isn't the responsibility of the bridge to make sure it gets trapped to
the CPU.

The solution is to implement the standard callbacks for dev_uc_add and
dev_mc_add, and behave just like any other network interface: ensure
that the user space program can see those packets.

Note that since ndo_set_rx_mode runs in atomic context, we must schedule
the dsa_slave_switchdev_event_work in order to install the FDB and MDB
entries to a DSA switch that may sleep. But since the DSA switchdev
event logic only deals with FDB entries, we must fake some events for
MDB ones.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  10 +-
 net/dsa/slave.c    | 329 ++++++++++++++++++++++++++++++++-------------
 2 files changed, 239 insertions(+), 100 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 4043da2bacc0..c03c67631e23 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -117,10 +117,12 @@ struct dsa_switchdev_event_work {
 	struct dsa_switch *ds;
 	int port;
 	struct work_struct work;
-	unsigned long event;
-	/* Specific for SWITCHDEV_FDB_ADD_TO_DEVICE and
-	 * SWITCHDEV_FDB_DEL_TO_DEVICE
-	 */
+	enum dsa_switchdev_event {
+		DSA_EVENT_FDB_ADD,
+		DSA_EVENT_FDB_DEL,
+		DSA_EVENT_MDB_ADD,
+		DSA_EVENT_MDB_DEL,
+	} event;
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
 	bool host_addr;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 6544a4ec69f4..65b3c1166fe7 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -171,6 +171,220 @@ static int dsa_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	return 0;
 }
 
+static void
+dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
+{
+	struct dsa_switch *ds = switchdev_work->ds;
+	struct switchdev_notifier_fdb_info info;
+	struct dsa_port *dp;
+
+	if (!dsa_is_user_port(ds, switchdev_work->port))
+		return;
+
+	info.addr = switchdev_work->addr;
+	info.vid = switchdev_work->vid;
+	info.offloaded = true;
+	dp = dsa_to_port(ds, switchdev_work->port);
+	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
+				 dp->slave, &info.info, NULL);
+}
+
+#define work_to_ctx(w) \
+	container_of((w), struct dsa_switchdev_event_work, work)
+
+static void dsa_slave_switchdev_event_work(struct work_struct *work)
+{
+	struct dsa_switchdev_event_work *switchdev_work = work_to_ctx(work);
+	struct dsa_switch *ds = switchdev_work->ds;
+	struct dsa_port *dp;
+	int err;
+
+	dp = dsa_to_port(ds, switchdev_work->port);
+
+	rtnl_lock();
+	switch (switchdev_work->event) {
+	case DSA_EVENT_FDB_ADD:
+		if (switchdev_work->host_addr)
+			err = dsa_host_fdb_add(dp, switchdev_work->addr,
+					       switchdev_work->vid);
+		else
+			err = dsa_port_fdb_add(dp, switchdev_work->addr,
+					       switchdev_work->vid);
+		if (err) {
+			dev_err(ds->dev,
+				"port %d failed to add %pM vid %d to fdb: %d\n",
+				dp->index, switchdev_work->addr,
+				switchdev_work->vid, err);
+			break;
+		}
+		dsa_fdb_offload_notify(switchdev_work);
+		break;
+
+	case DSA_EVENT_FDB_DEL:
+		if (switchdev_work->host_addr)
+			err = dsa_host_fdb_del(dp, switchdev_work->addr,
+					       switchdev_work->vid);
+		else
+			err = dsa_port_fdb_del(dp, switchdev_work->addr,
+					       switchdev_work->vid);
+		if (err) {
+			dev_err(ds->dev,
+				"port %d failed to delete %pM vid %d from fdb: %d\n",
+				dp->index, switchdev_work->addr,
+				switchdev_work->vid, err);
+		}
+
+		break;
+
+	case DSA_EVENT_MDB_ADD: {
+		struct switchdev_obj_port_mdb mdb;
+
+		ether_addr_copy(mdb.addr, switchdev_work->addr);
+		mdb.vid = switchdev_work->vid;
+
+		if (switchdev_work->host_addr)
+			err = dsa_host_mdb_add(dp, &mdb);
+		else
+			err = dsa_port_mdb_add(dp, &mdb);
+		if (err) {
+			dev_err(ds->dev,
+				"port %d failed to add %pM vid %d to mdb: %d\n",
+				dp->index, mdb.addr, mdb.vid, err);
+			break;
+		}
+		dsa_fdb_offload_notify(switchdev_work);
+		break;
+	}
+	case DSA_EVENT_MDB_DEL: {
+		struct switchdev_obj_port_mdb mdb;
+
+		ether_addr_copy(mdb.addr, switchdev_work->addr);
+		mdb.vid = switchdev_work->vid;
+
+		if (switchdev_work->host_addr)
+			err = dsa_host_mdb_del(dp, &mdb);
+		else
+			err = dsa_port_mdb_del(dp, &mdb);
+		if (err) {
+			dev_err(ds->dev,
+				"port %d failed to delete %pM vid %d from mdb: %d\n",
+				dp->index, mdb.addr, mdb.vid, err);
+		}
+		break;
+	}
+	default:
+		break;
+	}
+	rtnl_unlock();
+
+	kfree(switchdev_work);
+	dev_put(dp->slave);
+}
+
+
+static int dsa_slave_schedule_switchdev_work(struct net_device *dev,
+					     enum dsa_switchdev_event event,
+					     const unsigned char *addr, u16 vid,
+					     bool host_addr)
+{
+	struct dsa_switchdev_event_work *switchdev_work;
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+
+	if (!dp->ds->ops->port_fdb_add || !dp->ds->ops->port_fdb_del)
+		return -EOPNOTSUPP;
+
+	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+	if (!switchdev_work)
+		return -ENOMEM;
+
+	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
+	switchdev_work->ds = dp->ds;
+	switchdev_work->port = dp->index;
+	switchdev_work->event = event;
+
+	ether_addr_copy(switchdev_work->addr, addr);
+	switchdev_work->vid = vid;
+	switchdev_work->host_addr = host_addr;
+
+	/* Hold a reference on the slave for dsa_fdb_offload_notify */
+	dev_hold(dev);
+	dsa_schedule_work(&switchdev_work->work);
+
+	return 0;
+}
+
+static int dsa_slave_sync_uc(struct net_device *dev,
+			     const unsigned char *addr)
+{
+	int err;
+
+	err = dsa_slave_schedule_switchdev_work(dev, DSA_EVENT_FDB_ADD,
+						addr, 0, true);
+	if (err == -EOPNOTSUPP) {
+		struct dsa_port *dp = dsa_slave_to_port(dev);
+
+		dev_uc_add(dp->cpu_dp->master, addr);
+
+		return 0;
+	}
+
+	return err;
+}
+
+static int dsa_slave_unsync_uc(struct net_device *dev,
+			       const unsigned char *addr)
+{
+	int err;
+
+	err = dsa_slave_schedule_switchdev_work(dev, DSA_EVENT_FDB_DEL,
+						addr, 0, true);
+	if (err == -EOPNOTSUPP) {
+		struct dsa_port *dp = dsa_slave_to_port(dev);
+
+		dev_uc_del(dp->cpu_dp->master, addr);
+
+		return 0;
+	}
+
+	return err;
+}
+
+static int dsa_slave_sync_mc(struct net_device *dev,
+			     const unsigned char *addr)
+{
+	int err;
+
+	err = dsa_slave_schedule_switchdev_work(dev, DSA_EVENT_MDB_ADD,
+						addr, 0, true);
+	if (err == -EOPNOTSUPP) {
+		struct dsa_port *dp = dsa_slave_to_port(dev);
+
+		dev_mc_add(dp->cpu_dp->master, addr);
+
+		return 0;
+	}
+
+	return err;
+}
+
+static int dsa_slave_unsync_mc(struct net_device *dev,
+			       const unsigned char *addr)
+{
+	int err;
+
+	err = dsa_slave_schedule_switchdev_work(dev, DSA_EVENT_MDB_DEL,
+						addr, 0, true);
+	if (err == -EOPNOTSUPP) {
+		struct dsa_port *dp = dsa_slave_to_port(dev);
+
+		dev_mc_del(dp->cpu_dp->master, addr);
+
+		return 0;
+	}
+
+	return err;
+}
+
 /* slave mii_bus handling ***************************************************/
 static int dsa_slave_phy_read(struct mii_bus *bus, int addr, int reg)
 {
@@ -263,8 +477,9 @@ static int dsa_slave_close(struct net_device *dev)
 
 	dsa_port_disable_rt(dp);
 
-	dev_mc_unsync(master, dev);
-	dev_uc_unsync(master, dev);
+	__dev_uc_sync(dev, dsa_slave_sync_uc, dsa_slave_unsync_uc);
+	__dev_mc_sync(dev, dsa_slave_sync_mc, dsa_slave_unsync_mc);
+
 	if (dev->flags & IFF_ALLMULTI)
 		dev_set_allmulti(master, -1);
 	if (dev->flags & IFF_PROMISC)
@@ -290,10 +505,8 @@ static void dsa_slave_change_rx_flags(struct net_device *dev, int change)
 
 static void dsa_slave_set_rx_mode(struct net_device *dev)
 {
-	struct net_device *master = dsa_slave_to_master(dev);
-
-	dev_mc_sync(master, dev);
-	dev_uc_sync(master, dev);
+	__dev_uc_sync(dev, dsa_slave_sync_uc, dsa_slave_unsync_uc);
+	__dev_mc_sync(dev, dsa_slave_sync_mc, dsa_slave_unsync_mc);
 }
 
 static int dsa_slave_set_mac_address(struct net_device *dev, void *a)
@@ -1970,6 +2183,8 @@ int dsa_slave_create(struct dsa_port *port)
 	else
 		eth_hw_addr_inherit(slave_dev, master);
 	slave_dev->priv_flags |= IFF_NO_QUEUE;
+	if (ds->ops->port_fdb_add && ds->ops->port_fdb_del)
+		slave_dev->priv_flags |= IFF_UNICAST_FLT;
 	slave_dev->netdev_ops = &dsa_slave_netdev_ops;
 	if (ds->ops->port_max_mtu)
 		slave_dev->max_mtu = ds->ops->port_max_mtu(ds, port->index);
@@ -2290,75 +2505,6 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static void
-dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
-{
-	struct dsa_switch *ds = switchdev_work->ds;
-	struct switchdev_notifier_fdb_info info;
-	struct dsa_port *dp;
-
-	if (!dsa_is_user_port(ds, switchdev_work->port))
-		return;
-
-	info.addr = switchdev_work->addr;
-	info.vid = switchdev_work->vid;
-	info.offloaded = true;
-	dp = dsa_to_port(ds, switchdev_work->port);
-	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				 dp->slave, &info.info, NULL);
-}
-
-static void dsa_slave_switchdev_event_work(struct work_struct *work)
-{
-	struct dsa_switchdev_event_work *switchdev_work =
-		container_of(work, struct dsa_switchdev_event_work, work);
-	struct dsa_switch *ds = switchdev_work->ds;
-	struct dsa_port *dp;
-	int err;
-
-	dp = dsa_to_port(ds, switchdev_work->port);
-
-	rtnl_lock();
-	switch (switchdev_work->event) {
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		if (switchdev_work->host_addr)
-			err = dsa_host_fdb_add(dp, switchdev_work->addr,
-					       switchdev_work->vid);
-		else
-			err = dsa_port_fdb_add(dp, switchdev_work->addr,
-					       switchdev_work->vid);
-		if (err) {
-			dev_err(ds->dev,
-				"port %d failed to add %pM vid %d to fdb: %d\n",
-				dp->index, switchdev_work->addr,
-				switchdev_work->vid, err);
-			break;
-		}
-		dsa_fdb_offload_notify(switchdev_work);
-		break;
-
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		if (switchdev_work->host_addr)
-			err = dsa_host_fdb_del(dp, switchdev_work->addr,
-					       switchdev_work->vid);
-		else
-			err = dsa_port_fdb_del(dp, switchdev_work->addr,
-					       switchdev_work->vid);
-		if (err) {
-			dev_err(ds->dev,
-				"port %d failed to delete %pM vid %d from fdb: %d\n",
-				dp->index, switchdev_work->addr,
-				switchdev_work->vid, err);
-		}
-
-		break;
-	}
-	rtnl_unlock();
-
-	kfree(switchdev_work);
-	dev_put(dp->slave);
-}
-
 static int dsa_lower_dev_walk(struct net_device *lower_dev,
 			      struct netdev_nested_priv *priv)
 {
@@ -2387,7 +2533,7 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
 	const struct switchdev_notifier_fdb_info *fdb_info;
-	struct dsa_switchdev_event_work *switchdev_work;
+	enum dsa_switchdev_event dsa_event;
 	bool host_addr = false;
 	struct dsa_port *dp;
 	int err;
@@ -2441,28 +2587,19 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 				return NOTIFY_DONE;
 		}
 
-		if (!dp->ds->ops->port_fdb_add || !dp->ds->ops->port_fdb_del)
-			return NOTIFY_DONE;
-
-		switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
-		if (!switchdev_work)
-			return NOTIFY_BAD;
-
-		INIT_WORK(&switchdev_work->work,
-			  dsa_slave_switchdev_event_work);
-		switchdev_work->ds = dp->ds;
-		switchdev_work->port = dp->index;
-		switchdev_work->event = event;
+		if (event == SWITCHDEV_FDB_ADD_TO_DEVICE)
+			dsa_event = DSA_EVENT_FDB_ADD;
+		else
+			dsa_event = DSA_EVENT_FDB_DEL;
 
-		ether_addr_copy(switchdev_work->addr,
-				fdb_info->addr);
-		switchdev_work->vid = fdb_info->vid;
-		switchdev_work->host_addr = host_addr;
+		err = dsa_slave_schedule_switchdev_work(dp->slave, dsa_event,
+							fdb_info->addr,
+							fdb_info->vid,
+							host_addr);
+		if (err == -EOPNOTSUPP)
+			return NOTIFY_OK;
 
-		/* Hold a reference on the slave for dsa_fdb_offload_notify */
-		dev_hold(dev);
-		dsa_schedule_work(&switchdev_work->work);
-		break;
+		return notifier_from_errno(err);
 	default:
 		return NOTIFY_DONE;
 	}
-- 
2.25.1

