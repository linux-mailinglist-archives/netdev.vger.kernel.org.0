Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FD12F0240
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 18:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbhAIR26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 12:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbhAIR2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 12:28:48 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2122FC0617B0
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 09:27:40 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id d17so18801717ejy.9
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 09:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GFHFsO2k/SRW6fg93UiE4iJUmTDgEkwLLbxjP0lkX+E=;
        b=taJfwDtXxkgtlKZKQHhuHOxLX0uikBPP9iW8a4o1nL9T/mT1LDuf4uuTKF1Vn89ntc
         4SoU+EP6xgFNlPTUrNO+E8eKwFNJKNqvW7hmvZSUDqLZlw+QzN2q2JBHkDdg091XabUF
         vGDFTHa5B1htRPW9pXtrfMYaJP060oNQSb6/59QrbDIOGTx9aS7vvygeDA5c8Fg45g9u
         LtVGBBN1gICemGTHLRN76hg0IhbLCtM2NAQlkstaivpE6FvgHuYCoRyopfwkD6rj9p0K
         NTJMhKq7ar5F6n68Drn0tRUkmHJuSYXq23XMZNysY0oXfWmuE5fl5N6aBOQ/D3VgEfpv
         pnvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GFHFsO2k/SRW6fg93UiE4iJUmTDgEkwLLbxjP0lkX+E=;
        b=c3O5nN/d9T8zA22tRJdJiUI4JWa0ACmaq1xTOYGIJZq1yR1s7H6ONyvuymsT1wA3sP
         cq1e8YGUdDyUV1V0iTDQJ4ZnE+lcACEfycTiCywDDK3v9Rg7rk81Bnr6ER53e8XGZgHp
         cztKBjPRse+HFoL4CzHllZHUy1ocjMdHAhQ3whBHTq1dnuOB4mnLOkcwubUadXz/bnW/
         kJZ7IRza1O7+q5tWtRhGylW7b+4d5uJ5aWncSon7jnWBGFxAg8mpra9m1ZfjhSkyAOtm
         gYOiUFYtAXD+NIPMQ7T5AWcNfTbP3qf1SNp9gy2FKYgUcMM8hNWaCfqfKUaQiSL0IMB0
         tLlw==
X-Gm-Message-State: AOAM532oLtBhHbg5ocx9m5CwK9aANUAg+414S5EspKoPWH6L4+UsKNwn
        4A32M0CM7DYqUREpDG7eJ3A=
X-Google-Smtp-Source: ABdhPJyZcYMmjjfMhbdxXkOMcvsk6Ud/SuUvGyGvPvWJIhVaRkx1X5tfVLTH8xLkOhW/Hmm2zW4kGQ==
X-Received: by 2002:a17:906:2b1a:: with SMTP id a26mr5880476ejg.23.1610213258705;
        Sat, 09 Jan 2021 09:27:38 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h16sm4776714eji.110.2021.01.09.09.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 09:27:38 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH v6 net-next 11/15] net: catch errors from dev_get_stats
Date:   Sat,  9 Jan 2021 19:26:20 +0200
Message-Id: <20210109172624.2028156-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109172624.2028156-1-olteanv@gmail.com>
References: <20210109172624.2028156-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

dev_get_stats can now return error codes. Convert all remaining call
sites to look at that error code and stop processing.

The effects of simulating a kernel error (returning -ENOMEM) upon
existing programs or kernel interfaces:

- ifconfig and "cat /proc/net/dev" print up until the interface that
  failed, and there they return:
cat: read error: Cannot allocate memory

- ifstat and "ip -s -s link show":
RTNETLINK answers: Cannot allocate memory
Dump terminated

Some call sites are coming from a context that returns void (ethtool
stats, workqueue context). So since we can't report to the upper layer,
do the next best thing: print an error to the console.

This patch wraps up the conversion of existing dev_get_stats callers, so
we can add the __must_check attribute now to ensure that future callers
keep doing this too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v6:
- Fixed rtnetlink incorrectly returning 0 in rtnl_fill_ifinfo on
  nla_put_failure and causing "ip a" to not show any interfaces.
- Squashed the patch to propagate errors with the one to terminate them.

Changes in v5:
- Actually propagate errors from bonding and net_failover from within
  this patch.
- Properly propagating the dev_get_stats() error code from
  rtnl_fill_stats now, and not -EMSGSIZE.

Changes in v4:
Patch is new (Eric's suggestion).

 arch/s390/appldata/appldata_net_sum.c         | 10 ++++--
 drivers/leds/trigger/ledtrig-netdev.c         |  9 ++++-
 drivers/net/bonding/bond_main.c               | 29 ++++++++++++----
 .../ethernet/apm/xgene/xgene_enet_ethtool.c   |  9 +++--
 .../net/ethernet/hisilicon/hns/hns_ethtool.c  |  7 +++-
 drivers/net/ethernet/intel/e1000e/ethtool.c   |  9 +++--
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  9 +++--
 drivers/net/ethernet/intel/ixgbevf/ethtool.c  |  9 +++--
 drivers/net/net_failover.c                    | 33 ++++++++++++++-----
 drivers/parisc/led.c                          |  7 +++-
 drivers/usb/gadget/function/rndis.c           |  4 ++-
 include/linux/netdevice.h                     |  3 +-
 net/8021q/vlanproc.c                          |  7 ++--
 net/core/dev.c                                |  3 +-
 net/core/net-procfs.c                         | 16 ++++++---
 net/core/net-sysfs.c                          |  4 ++-
 net/core/rtnetlink.c                          | 23 +++++++++----
 17 files changed, 147 insertions(+), 44 deletions(-)

diff --git a/arch/s390/appldata/appldata_net_sum.c b/arch/s390/appldata/appldata_net_sum.c
index 6146606ac9a3..72cb5344e488 100644
--- a/arch/s390/appldata/appldata_net_sum.c
+++ b/arch/s390/appldata/appldata_net_sum.c
@@ -58,11 +58,11 @@ struct appldata_net_sum_data {
  */
 static void appldata_get_net_sum_data(void *data)
 {
-	int i;
 	struct appldata_net_sum_data *net_data;
 	struct net_device *dev;
 	unsigned long rx_packets, tx_packets, rx_bytes, tx_bytes, rx_errors,
 			tx_errors, rx_dropped, tx_dropped, collisions;
+	int ret, i;
 
 	net_data = data;
 	net_data->sync_count_1++;
@@ -83,7 +83,13 @@ static void appldata_get_net_sum_data(void *data)
 	for_each_netdev(&init_net, dev) {
 		struct rtnl_link_stats64 stats;
 
-		dev_get_stats(dev, &stats);
+		ret = dev_get_stats(dev, &stats);
+		if (ret) {
+			netif_lists_unlock(&init_net);
+			netdev_err(dev, "dev_get_stats returned %d\n", ret);
+			return;
+		}
+
 		rx_packets += stats.rx_packets;
 		tx_packets += stats.tx_packets;
 		rx_bytes   += stats.rx_bytes;
diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 4382ee278309..c717b7e7dd81 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -351,6 +351,7 @@ static void netdev_trig_work(struct work_struct *work)
 	unsigned int new_activity;
 	unsigned long interval;
 	int invert;
+	int err;
 
 	/* If we dont have a device, insure we are off */
 	if (!trigger_data->net_dev) {
@@ -363,7 +364,13 @@ static void netdev_trig_work(struct work_struct *work)
 	    !test_bit(NETDEV_LED_RX, &trigger_data->mode))
 		return;
 
-	dev_get_stats(trigger_data->net_dev, &dev_stats);
+	err = dev_get_stats(trigger_data->net_dev, &dev_stats);
+	if (err) {
+		netdev_err(trigger_data->net_dev,
+			   "dev_get_stats returned %d\n", err);
+		return;
+	}
+
 	new_activity =
 	    (test_bit(NETDEV_LED_TX, &trigger_data->mode) ?
 		dev_stats.tx_packets : 0) +
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 17faf431d85b..b70ca0e41142 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1757,7 +1757,12 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 	slave_dev->priv_flags |= IFF_BONDING;
 	/* initialize slave stats */
-	dev_get_stats(new_slave->dev, &new_slave->slave_stats);
+	res = dev_get_stats(new_slave->dev, &new_slave->slave_stats);
+	if (res) {
+		slave_err(bond_dev, slave_dev, "dev_get_stats returned %d\n",
+			  res);
+		goto err_close;
+	}
 
 	if (bond_is_lb(bond)) {
 		/* bond_alb_init_slave() must be called before all other stages since
@@ -2070,6 +2075,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 	struct sockaddr_storage ss;
 	int old_flags = bond_dev->flags;
 	netdev_features_t old_features = bond_dev->features;
+	int err;
 
 	/* slave is not a slave or master is not master of this slave */
 	if (!(slave_dev->flags & IFF_SLAVE) ||
@@ -2088,13 +2094,19 @@ static int __bond_release_one(struct net_device *bond_dev,
 		return -EINVAL;
 	}
 
+	/* recompute stats just before removing the slave */
+	err = bond_get_stats(bond->dev, &bond->bond_stats);
+	if (err) {
+		slave_info(bond_dev, slave_dev, "dev_get_stats returned %d\n",
+			   err);
+		unblock_netpoll_tx();
+		return err;
+	}
+
 	bond_set_slave_inactive_flags(slave, BOND_SLAVE_NOTIFY_NOW);
 
 	bond_sysfs_slave_del(slave);
 
-	/* recompute stats just before removing the slave */
-	bond_get_stats(bond->dev, &bond->bond_stats);
-
 	bond_upper_dev_unlink(bond, slave);
 	/* unregister rx_handler early so bond_handle_frame wouldn't be called
 	 * for this slave anymore.
@@ -3742,7 +3754,7 @@ static int bond_get_stats(struct net_device *bond_dev,
 	struct list_head *iter;
 	struct slave *slave;
 	int nest_level = 0;
-
+	int res = 0;
 
 	rcu_read_lock();
 #ifdef CONFIG_LOCKDEP
@@ -3753,7 +3765,9 @@ static int bond_get_stats(struct net_device *bond_dev,
 	memcpy(stats, &bond->bond_stats, sizeof(*stats));
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		dev_get_stats(slave->dev, &temp);
+		res = dev_get_stats(slave->dev, &temp);
+		if (res)
+			goto out;
 
 		bond_fold_stats(stats, &temp, &slave->slave_stats);
 
@@ -3762,10 +3776,11 @@ static int bond_get_stats(struct net_device *bond_dev,
 	}
 
 	memcpy(&bond->bond_stats, stats, sizeof(*stats));
+out:
 	spin_unlock(&bond->stats_lock);
 	rcu_read_unlock();
 
-	return 0;
+	return res;
 }
 
 static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd)
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c b/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c
index ada70425b48c..aab6a81f0438 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c
@@ -266,9 +266,14 @@ static void xgene_get_ethtool_stats(struct net_device *ndev,
 {
 	struct xgene_enet_pdata *pdata = netdev_priv(ndev);
 	struct rtnl_link_stats64 stats;
-	int i;
+	int err, i;
+
+	err = dev_get_stats(ndev, &stats);
+	if (err) {
+		netdev_err(ndev, "dev_get_stats returned %d\n", err);
+		return;
+	}
 
-	dev_get_stats(ndev, &stats);
 	for (i = 0; i < XGENE_STATS_LEN; i++)
 		data[i] = *(u64 *)((char *)&stats + gstrings_stats[i].offset);
 
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index ee2172011051..d05fa7b3f6e0 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -840,6 +840,7 @@ static void hns_get_ethtool_stats(struct net_device *netdev,
 	struct hns_nic_priv *priv = netdev_priv(netdev);
 	struct hnae_handle *h = priv->ae_handle;
 	struct rtnl_link_stats64 net_stats;
+	int err;
 
 	if (!h->dev->ops->get_stats || !h->dev->ops->update_stats) {
 		netdev_err(netdev, "get_stats or update_stats is null!\n");
@@ -848,7 +849,11 @@ static void hns_get_ethtool_stats(struct net_device *netdev,
 
 	h->dev->ops->update_stats(h, &netdev->stats);
 
-	dev_get_stats(netdev, &net_stats);
+	err = dev_get_stats(netdev, &net_stats);
+	if (err) {
+		netdev_err(netdev, "dev_get_stats returned %d\n", err);
+		return;
+	}
 
 	/* get netdev statistics */
 	p[0] = net_stats.rx_packets;
diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 06442e6bef73..41bd3e0598ce 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -2060,15 +2060,20 @@ static void e1000_get_ethtool_stats(struct net_device *netdev,
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct rtnl_link_stats64 net_stats;
-	int i;
 	char *p = NULL;
+	int err, i;
 
 	pm_runtime_get_sync(netdev->dev.parent);
 
-	dev_get_stats(netdev, &net_stats);
+	err = dev_get_stats(netdev, &net_stats);
 
 	pm_runtime_put_sync(netdev->dev.parent);
 
+	if (err) {
+		netdev_err(netdev, "dev_get_stats returned %d\n", err);
+		return;
+	}
+
 	for (i = 0; i < E1000_GLOBAL_STATS_LEN; i++) {
 		switch (e1000_gstrings_stats[i].type) {
 		case NETDEV_STATS:
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 2b8084664403..a647e2774f76 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1298,11 +1298,16 @@ static void ixgbe_get_ethtool_stats(struct net_device *netdev,
 	struct rtnl_link_stats64 net_stats;
 	unsigned int start;
 	struct ixgbe_ring *ring;
-	int i, j;
 	char *p = NULL;
+	int err, i, j;
 
 	ixgbe_update_stats(adapter);
-	dev_get_stats(netdev, &net_stats);
+	err = dev_get_stats(netdev, &net_stats);
+	if (err) {
+		netdev_err(netdev, "dev_get_stats returned %d\n", err);
+		return;
+	}
+
 	for (i = 0; i < IXGBE_GLOBAL_STATS_LEN; i++) {
 		switch (ixgbe_gstrings_stats[i].type) {
 		case NETDEV_STATS:
diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
index 3b9b7e5c2998..665e39301092 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
@@ -423,11 +423,16 @@ static void ixgbevf_get_ethtool_stats(struct net_device *netdev,
 	struct rtnl_link_stats64 net_stats;
 	unsigned int start;
 	struct ixgbevf_ring *ring;
-	int i, j;
+	int err, i, j;
 	char *p;
 
 	ixgbevf_update_stats(adapter);
-	dev_get_stats(netdev, &net_stats);
+	err = dev_get_stats(netdev, &net_stats);
+	if (err) {
+		netdev_err(netdev, "dev_get_stats returned %d\n", err);
+		return;
+	}
+
 	for (i = 0; i < IXGBEVF_GLOBAL_STATS_LEN; i++) {
 		switch (ixgbevf_gstrings_stats[i].type) {
 		case NETDEV_STATS:
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index e032ad1c5e22..2815228a34d5 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -185,6 +185,7 @@ static int net_failover_get_stats(struct net_device *dev,
 	struct net_failover_info *nfo_info = netdev_priv(dev);
 	struct rtnl_link_stats64 temp;
 	struct net_device *slave_dev;
+	int err = 0;
 
 	spin_lock(&nfo_info->stats_lock);
 	memcpy(stats, &nfo_info->failover_stats, sizeof(*stats));
@@ -193,24 +194,29 @@ static int net_failover_get_stats(struct net_device *dev,
 
 	slave_dev = rcu_dereference(nfo_info->primary_dev);
 	if (slave_dev) {
-		dev_get_stats(slave_dev, &temp);
+		err = dev_get_stats(slave_dev, &temp);
+		if (err)
+			goto out;
 		net_failover_fold_stats(stats, &temp, &nfo_info->primary_stats);
 		memcpy(&nfo_info->primary_stats, &temp, sizeof(temp));
 	}
 
 	slave_dev = rcu_dereference(nfo_info->standby_dev);
 	if (slave_dev) {
-		dev_get_stats(slave_dev, &temp);
+		err = dev_get_stats(slave_dev, &temp);
+		if (err)
+			goto out;
 		net_failover_fold_stats(stats, &temp, &nfo_info->standby_stats);
 		memcpy(&nfo_info->standby_stats, &temp, sizeof(temp));
 	}
 
+out:
 	rcu_read_unlock();
 
 	memcpy(&nfo_info->failover_stats, stats, sizeof(*stats));
 	spin_unlock(&nfo_info->stats_lock);
 
-	return 0;
+	return err;
 }
 
 static int net_failover_change_mtu(struct net_device *dev, int new_mtu)
@@ -545,11 +551,15 @@ static int net_failover_slave_register(struct net_device *slave_dev,
 	if (slave_is_standby) {
 		rcu_assign_pointer(nfo_info->standby_dev, slave_dev);
 		standby_dev = slave_dev;
-		dev_get_stats(standby_dev, &nfo_info->standby_stats);
+		err = dev_get_stats(standby_dev, &nfo_info->standby_stats);
+		if (err)
+			goto err_stats_get;
 	} else {
 		rcu_assign_pointer(nfo_info->primary_dev, slave_dev);
 		primary_dev = slave_dev;
-		dev_get_stats(primary_dev, &nfo_info->primary_stats);
+		err = dev_get_stats(primary_dev, &nfo_info->primary_stats);
+		if (err)
+			goto err_stats_get;
 		failover_dev->min_mtu = slave_dev->min_mtu;
 		failover_dev->max_mtu = slave_dev->max_mtu;
 	}
@@ -564,6 +574,8 @@ static int net_failover_slave_register(struct net_device *slave_dev,
 
 	return 0;
 
+err_stats_get:
+	vlan_vids_del_by_dev(slave_dev, failover_dev);
 err_vlan_add:
 	dev_uc_unsync(slave_dev, failover_dev);
 	dev_mc_unsync(slave_dev, failover_dev);
@@ -597,6 +609,7 @@ static int net_failover_slave_unregister(struct net_device *slave_dev,
 	struct net_device *standby_dev, *primary_dev;
 	struct net_failover_info *nfo_info;
 	bool slave_is_standby;
+	int err;
 
 	nfo_info = netdev_priv(failover_dev);
 	primary_dev = rtnl_dereference(nfo_info->primary_dev);
@@ -611,7 +624,8 @@ static int net_failover_slave_unregister(struct net_device *slave_dev,
 	dev_close(slave_dev);
 
 	nfo_info = netdev_priv(failover_dev);
-	dev_get_stats(failover_dev, &nfo_info->failover_stats);
+	/* Proceed with the deregistration anyway */
+	err = dev_get_stats(failover_dev, &nfo_info->failover_stats);
 
 	slave_is_standby = slave_dev->dev.parent == failover_dev->dev.parent;
 	if (slave_is_standby) {
@@ -631,7 +645,7 @@ static int net_failover_slave_unregister(struct net_device *slave_dev,
 	netdev_info(failover_dev, "failover %s slave:%s unregistered\n",
 		    slave_is_standby ? "standby" : "primary", slave_dev->name);
 
-	return 0;
+	return err;
 }
 
 static int net_failover_slave_link_change(struct net_device *slave_dev,
@@ -639,6 +653,7 @@ static int net_failover_slave_link_change(struct net_device *slave_dev,
 {
 	struct net_device *primary_dev, *standby_dev;
 	struct net_failover_info *nfo_info;
+	int err;
 
 	nfo_info = netdev_priv(failover_dev);
 
@@ -653,7 +668,9 @@ static int net_failover_slave_link_change(struct net_device *slave_dev,
 		netif_carrier_on(failover_dev);
 		netif_tx_wake_all_queues(failover_dev);
 	} else {
-		dev_get_stats(failover_dev, &nfo_info->failover_stats);
+		err = dev_get_stats(failover_dev, &nfo_info->failover_stats);
+		if (err)
+			return err;
 		netif_carrier_off(failover_dev);
 		netif_tx_stop_all_queues(failover_dev);
 	}
diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index cc6108785323..d17d0fbf878d 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -370,7 +370,12 @@ static __inline__ int led_get_net_activity(void)
 
 		in_dev_put(in_dev);
 
-		dev_get_stats(dev, &stats);
+		retval = dev_get_stats(dev, &stats);
+		if (retval) {
+			netif_lists_unlock(&init_net);
+			return retval;
+		}
+
 		rx_total += stats.rx_packets;
 		tx_total += stats.tx_packets;
 	}
diff --git a/drivers/usb/gadget/function/rndis.c b/drivers/usb/gadget/function/rndis.c
index 7ec29e007ae9..bec474819c3d 100644
--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -198,7 +198,9 @@ static int gen_ndis_query_resp(struct rndis_params *params, u32 OID, u8 *buf,
 	resp->InformationBufferOffset = cpu_to_le32(16);
 
 	net = params->dev;
-	dev_get_stats(net, &stats);
+	retval = dev_get_stats(net, &stats);
+	if (retval)
+		return retval;
 
 	switch (OID) {
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index bd471f1e1fa3..b1aebab916a8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4545,7 +4545,8 @@ void netdev_notify_peers(struct net_device *dev);
 void netdev_features_change(struct net_device *dev);
 /* Load a device via the kmod */
 void dev_load(struct net *net, const char *name);
-int dev_get_stats(struct net_device *dev, struct rtnl_link_stats64 *storage);
+int __must_check dev_get_stats(struct net_device *dev,
+			       struct rtnl_link_stats64 *storage);
 void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
 			     const struct net_device_stats *netdev_stats);
 void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
diff --git a/net/8021q/vlanproc.c b/net/8021q/vlanproc.c
index 3a6682d79630..d89b75804834 100644
--- a/net/8021q/vlanproc.c
+++ b/net/8021q/vlanproc.c
@@ -244,12 +244,15 @@ static int vlandev_seq_show(struct seq_file *seq, void *offset)
 	const struct vlan_dev_priv *vlan = vlan_dev_priv(vlandev);
 	static const char fmt64[] = "%30s %12llu\n";
 	struct rtnl_link_stats64 stats;
-	int i;
+	int err, i;
 
 	if (!is_vlan_dev(vlandev))
 		return 0;
 
-	dev_get_stats(vlandev, &stats);
+	err = dev_get_stats(vlandev, &stats);
+	if (err)
+		return err;
+
 	seq_printf(seq,
 		   "%s  VID: %d	 REORDER_HDR: %i  dev->priv_flags: %hx\n",
 		   vlandev->name, vlan->vlan_id,
diff --git a/net/core/dev.c b/net/core/dev.c
index dfbd66ba3cad..30facac95d5e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10403,7 +10403,8 @@ EXPORT_SYMBOL(netdev_stats_to_stats64);
  *	dev->netdev_ops->get_stats64 or dev->netdev_ops->get_stats;
  *	otherwise the internal statistics structure is used.
  */
-int dev_get_stats(struct net_device *dev, struct rtnl_link_stats64 *storage)
+int __must_check dev_get_stats(struct net_device *dev,
+			       struct rtnl_link_stats64 *storage)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	int err = 0;
diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 64666ba7ccab..ee19c35f6e00 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -78,11 +78,14 @@ static void dev_seq_stop(struct seq_file *seq, void *v)
 	netif_lists_unlock(net);
 }
 
-static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
+static int dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
 {
 	struct rtnl_link_stats64 stats;
+	int err;
 
-	dev_get_stats(dev, &stats);
+	err = dev_get_stats(dev, &stats);
+	if (err)
+		return err;
 
 	seq_printf(seq, "%6s: %7llu %7llu %4llu %4llu %4llu %5llu %10llu %9llu "
 		   "%8llu %7llu %4llu %4llu %4llu %5llu %7llu %10llu\n",
@@ -101,6 +104,8 @@ static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
 		    stats.tx_window_errors +
 		    stats.tx_heartbeat_errors,
 		   stats.tx_compressed);
+
+	return 0;
 }
 
 /*
@@ -109,6 +114,8 @@ static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
  */
 static int dev_seq_show(struct seq_file *seq, void *v)
 {
+	int err = 0;
+
 	if (v == SEQ_START_TOKEN)
 		seq_puts(seq, "Inter-|   Receive                            "
 			      "                    |  Transmit\n"
@@ -116,8 +123,9 @@ static int dev_seq_show(struct seq_file *seq, void *v)
 			      "compressed multicast|bytes    packets errs "
 			      "drop fifo colls carrier compressed\n");
 	else
-		dev_seq_printf_stats(seq, v);
-	return 0;
+		err = dev_seq_printf_stats(seq, v);
+
+	return err;
 }
 
 static u32 softnet_backlog_len(struct softnet_data *sd)
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 5d89c85b42d4..6f789e178e92 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -588,7 +588,9 @@ static ssize_t netstat_show(const struct device *d,
 	if (dev_isalive(dev)) {
 		struct rtnl_link_stats64 stats;
 
-		dev_get_stats(dev, &stats);
+		ret = dev_get_stats(dev, &stats);
+		if (ret)
+			return ret;
 
 		ret = sprintf(buf, fmt_u64, *(u64 *)(((u8 *)&stats) + offset));
 	}
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index bb0596c41b3e..6cc87094924d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1201,6 +1201,7 @@ static noinline_for_stack int rtnl_fill_stats(struct sk_buff *skb,
 {
 	struct rtnl_link_stats64 *sp;
 	struct nlattr *attr;
+	int err;
 
 	attr = nla_reserve_64bit(skb, IFLA_STATS64,
 				 sizeof(struct rtnl_link_stats64), IFLA_PAD);
@@ -1208,7 +1209,9 @@ static noinline_for_stack int rtnl_fill_stats(struct sk_buff *skb,
 		return -EMSGSIZE;
 
 	sp = nla_data(attr);
-	dev_get_stats(dev, sp);
+	err = dev_get_stats(dev, sp);
+	if (err)
+		return err;
 
 	attr = nla_reserve(skb, IFLA_STATS,
 			   sizeof(struct rtnl_link_stats));
@@ -1707,6 +1710,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 {
 	struct ifinfomsg *ifm;
 	struct nlmsghdr *nlh;
+	int err;
 
 	ASSERT_RTNL();
 	nlh = nlmsg_put(skb, pid, seq, type, sizeof(*ifm), flags);
@@ -1780,8 +1784,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (rtnl_phys_switch_id_fill(skb, dev))
 		goto nla_put_failure;
 
-	if (rtnl_fill_stats(skb, dev))
-		goto nla_put_failure;
+	err = rtnl_fill_stats(skb, dev);
+	if (err)
+		goto get_stats_failure;
 
 	if (rtnl_fill_vf(skb, dev, ext_filter_mask))
 		goto nla_put_failure;
@@ -1825,8 +1830,10 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 nla_put_failure_rcu:
 	rcu_read_unlock();
 nla_put_failure:
+	err = -EMSGSIZE;
+get_stats_failure:
 	nlmsg_cancel(skb, nlh);
-	return -EMSGSIZE;
+	return err;
 }
 
 static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
@@ -5135,7 +5142,9 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 			goto nla_put_failure;
 
 		sp = nla_data(attr);
-		dev_get_stats(dev, sp);
+		err = dev_get_stats(dev, sp);
+		if (err)
+			goto get_stats_failure;
 	}
 
 	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_XSTATS, *idxattr)) {
@@ -5242,13 +5251,15 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 	return 0;
 
 nla_put_failure:
+	err = -EMSGSIZE;
+get_stats_failure:
 	/* not a multi message or no progress mean a real error */
 	if (!(flags & NLM_F_MULTI) || s_prividx == *prividx)
 		nlmsg_cancel(skb, nlh);
 	else
 		nlmsg_end(skb, nlh);
 
-	return -EMSGSIZE;
+	return err;
 }
 
 static size_t if_nlmsg_stats_size(const struct net_device *dev,
-- 
2.25.1

