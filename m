Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9DD2EF5DE
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbhAHQdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728093AbhAHQdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:33:40 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F177C061380
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:32:37 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id dk8so11861596edb.1
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xAwZqhenVXxDHPGV4AyEjTD352xFHBBYj6oHTpVvFyo=;
        b=crVOuCevMrhoPJM5L60i2j3gzrlzMWO2Hbx2Pz25QJspsh4rBcEHb1/dovgeNqX60x
         7ORdc6RrpUyhezAcGacWCYnrLXROhnKliHQKdmDqbuptvYBdBip0MZLV49NEYe5H7Byi
         1UMoXTuhWIEmvF1O0Lk6rJ1YZOdwQx8DHpC6BqH95dodPRoiDyyTlnESRn56pz+msdn3
         mqFz115nzo+jPE4sPE2JOYtark20JF6vyvOzWPENtRxMdqohaVLOn9ybnCOAtYt9wySM
         phkEYF8zYsF7+0WVqTQjl+RmP3CG1wmtirdAurRP5/i/CYLDM9yQfdOyOEoZzPeYNRGI
         dcTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xAwZqhenVXxDHPGV4AyEjTD352xFHBBYj6oHTpVvFyo=;
        b=jQeBJ7AUNIAHv/MCyy06oJygEEofI6u1RTfyxDcBY6MVxKkHsp91IItiJi9m/mLZkz
         WFfoB5CX1qR+dfSfSaiZ9KGG6kmgRHzELnRniSrWCLcIQ29kNmW4B/cY/DfMeq/jclX7
         OlDTw0oHVowr70q8mmtw/Ha/iREkbOhjkawqm1OAPVTYld/8UzE8PnnRIGr+MZBIR0y0
         nQxFGpsnOYRzz0+JrdDQEQ0LQDnfjvij5xYETQ7r8GKFgcFAbl4yonCRZfADQDhMXEey
         5FVJcOhU/Bxl697+mNPwX067/V42Nt4uoEie6pouUOuhuww0dVyBWMqwghZkPubAd6V+
         9aRA==
X-Gm-Message-State: AOAM5331YPyX0Ym/q5nINTsqhZh94/1v3PMiNiswVcubp0wFF1MS8hle
        DxXKfuukYaR27WTbL02LFhg=
X-Google-Smtp-Source: ABdhPJwkEVgcoRe2NyQpE1e2aWPxt8Uog5e0JMDkF0lN7Gek3LfvsZI9x6pQtf8dhHJtKQ2sqmqwaQ==
X-Received: by 2002:aa7:cf04:: with SMTP id a4mr5866165edy.99.1610123555966;
        Fri, 08 Jan 2021 08:32:35 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x6sm3957737edl.67.2021.01.08.08.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:32:35 -0800 (PST)
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
Subject: [PATCH v5 net-next 11/16] net: propagate errors from dev_get_stats
Date:   Fri,  8 Jan 2021 18:31:54 +0200
Message-Id: <20210108163159.358043-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108163159.358043-1-olteanv@gmail.com>
References: <20210108163159.358043-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

dev_get_stats can now return error codes. Take the remaining call sites
where those errors can be propagated, which are all trivial, and convert
them to look at that error code and stop processing.

The effects of simulating a kernel error (returning -ENOMEM) upon
existing programs or kernel interfaces:

- cat /proc/net/dev prints up until the interface that failed, and there
  it returns:
cat: read error: Cannot allocate memory

- ifstat simply returns this and prints nothing:
Error: Buffer too small for object.
Dump terminated

- ip -s -s link show behaves the same as ifstat.

- ifconfig prints only the info for the interfaces whose statistics did
  not fail.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
- Actually propagate errors from bonding and net_failover from within
  this patch.
- Properly propagating the dev_get_stats() error code from
  rtnl_fill_stats now, and not -EMSGSIZE.

Changes in v4:
Patch is new (Eric's suggestion).

 drivers/net/bonding/bond_main.c     | 24 ++++++++++++++++-----
 drivers/net/net_failover.c          | 33 ++++++++++++++++++++++-------
 drivers/parisc/led.c                |  7 +++++-
 drivers/usb/gadget/function/rndis.c |  4 +++-
 net/8021q/vlanproc.c                |  7 ++++--
 net/core/net-procfs.c               | 16 ++++++++++----
 net/core/net-sysfs.c                |  4 +++-
 net/core/rtnetlink.c                | 15 +++++++++----
 8 files changed, 84 insertions(+), 26 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5a3178b3dba3..2352ef64486b 100644
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
@@ -2094,7 +2099,13 @@ static int __bond_release_one(struct net_device *bond_dev,
 	bond_sysfs_slave_del(slave);
 
 	/* recompute stats just before removing the slave */
-	bond_get_stats(bond->dev, &bond->bond_stats);
+	err = bond_get_stats(bond->dev, &bond->bond_stats);
+	if (err) {
+		slave_info(bond_dev, slave_dev, "dev_get_stats returned %d\n",
+			   err);
+		unblock_netpoll_tx();
+		return err;
+	}
 
 	bond_upper_dev_unlink(bond, slave);
 	/* unregister rx_handler early so bond_handle_frame wouldn't be called
@@ -3743,7 +3754,7 @@ static int bond_get_stats(struct net_device *bond_dev,
 	struct list_head *iter;
 	struct slave *slave;
 	int nest_level = 0;
-
+	int res = 0;
 
 	rcu_read_lock();
 #ifdef CONFIG_LOCKDEP
@@ -3754,7 +3765,9 @@ static int bond_get_stats(struct net_device *bond_dev,
 	memcpy(stats, &bond->bond_stats, sizeof(*stats));
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		dev_get_stats(slave->dev, &temp);
+		res = dev_get_stats(slave->dev, &temp);
+		if (res)
+			goto out;
 
 		bond_fold_stats(stats, &temp, &slave->slave_stats);
 
@@ -3763,10 +3776,11 @@ static int bond_get_stats(struct net_device *bond_dev,
 	}
 
 	memcpy(&bond->bond_stats, stats, sizeof(*stats));
+out:
 	spin_unlock(&bond->stats_lock);
 	rcu_read_unlock();
 
-	return 0;
+	return res;
 }
 
 static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd)
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index e032ad1c5e22..7f70555e68d1 100644
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
index bb0596c41b3e..656c482befac 100644
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
+	int err = -EMSGSIZE;
 
 	ASSERT_RTNL();
 	nlh = nlmsg_put(skb, pid, seq, type, sizeof(*ifm), flags);
@@ -1780,7 +1784,8 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (rtnl_phys_switch_id_fill(skb, dev))
 		goto nla_put_failure;
 
-	if (rtnl_fill_stats(skb, dev))
+	err = rtnl_fill_stats(skb, dev);
+	if (err)
 		goto nla_put_failure;
 
 	if (rtnl_fill_vf(skb, dev, ext_filter_mask))
@@ -1826,7 +1831,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	rcu_read_unlock();
 nla_put_failure:
 	nlmsg_cancel(skb, nlh);
-	return -EMSGSIZE;
+	return err;
 }
 
 static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
@@ -5135,7 +5140,9 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 			goto nla_put_failure;
 
 		sp = nla_data(attr);
-		dev_get_stats(dev, sp);
+		err = dev_get_stats(dev, sp);
+		if (err)
+			goto nla_put_failure;
 	}
 
 	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_XSTATS, *idxattr)) {
-- 
2.25.1

