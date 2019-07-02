Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C39CE5D588
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 19:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfGBRoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 13:44:11 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48123 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726486AbfGBRoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 13:44:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D03322199;
        Tue,  2 Jul 2019 13:44:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 02 Jul 2019 13:44:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=q/tVBAbC8ieDM
        RbWDZ6QFc0WdOQFIg/iqBIVO3Zgai0=; b=Cec9UzYrfOUh8lafKtfzfXOzj11MX
        BjC+TpQGgNpX6HXie4CteyE6LW+62YBUtyXBlO++LU1YQJXHJQbQLSv53ku3U8zC
        YkydmyEDOTI5nxOmQT9g6innPTqAbj1HEAQw83sA4hvWNOtVrKYrqB4+OUJkXV2e
        f8nqYbde4hl7XrXyt7jygsRHUsFlFvSjKQRW/hRgjY6fvhfundXEzC5bprM1QA4e
        8T2Ks241XG6qMBbrAZ2S1TxOOm9VfWbsPCQc/SE7Q/mjJjypaKO7OFfeNTAlmXBS
        owFNq213u+Qdeo5MnWv4j7Q49qn2FM7Q6V0G6t4hf4MDMa7xMeblgI2wA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=q/tVBAbC8ieDMRbWDZ6QFc0WdOQFIg/iqBIVO3Zgai0=; b=1sAcckpu
        LJREJEGUigoYOGOdMHADosCvAR4LnxeXaoPHqsweu1NMTdAczKiuFWeHh7iksePX
        YPcY4n0SDu2xiW4RkBfLxeSNXFWMpHlqZaxuwf/zmEF6lqF5fg2lAhosyG+rZVUb
        vZs61kXfETpf6SGsjaVv3SDFYCDVik23+cMsuJXKoS3nyTm5lUPMmZCCbntESzu/
        Qu4dcCsaQsJ51jaHd6E/fHcocgukD+k7RMzRe4en0kPA70nV1JxWM18Wv3OMLI11
        qKQi894TbLV7JBe7Sy+4vQg2xfEUbVcajIlDm0759zR3GZGeoD3Mddn1BH1xqMtj
        S6jmRpySi9tj8A==
X-ME-Sender: <xms:55cbXU4pSLZ4axSCK-1T4bgSmsICW55d0XgUunVwHqwS8UQocvfPmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdekgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeggihhntggv
    nhhtuceuvghrnhgrthcuoehvihhntggvnhhtsegsvghrnhgrthdrtghhqeenucfkphepke
    ehrddurddutddvrddvfedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgrthes
    lhhufhhfhidrtgignecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:55cbXWArTzR9XMGzoTdok6tsBadotyO5tor3n9Kiw4pQXAe3ildAig>
    <xmx:55cbXbbBABEVJLR4d-vyataW_DoyCneSlxyhyWsAeGuJ_xPJhxl0UQ>
    <xmx:55cbXRa_UrayOpTSSkrdUQlG9iiOZMSsJp-jnZ1hSjgjIke9NIIOVw>
    <xmx:6JcbXW8rpH7GhfpAcK3CcP87mNJNl0Y3UIVoNN6-T8P333W9C96TFg>
Received: from neo.luffy.cx (230.102.1.85.dynamic.wline.res.cust.swisscom.ch [85.1.102.230])
        by mail.messagingengine.com (Postfix) with ESMTPA id D02C580062;
        Tue,  2 Jul 2019 13:44:06 -0400 (EDT)
Received: by neo.luffy.cx (Postfix, from userid 500)
        id C238C1132; Tue,  2 Jul 2019 19:44:04 +0200 (CEST)
From:   Vincent Bernat <vincent@bernat.ch>
To:     Jiri Pirko <jiri@resnulli.us>, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Vincent Bernat <vincent@bernat.ch>
Subject: [PATCH net-next v2] bonding: add an option to specify a delay between peer notifications
Date:   Tue,  2 Jul 2019 19:43:54 +0200
Message-Id: <20190702174354.10154-1-vincent@bernat.ch>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190701092758.GA2250@nanopsycho>
References: <20190701092758.GA2250@nanopsycho>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, gratuitous ARP/ND packets are sent every `miimon'
milliseconds. This commit allows a user to specify a custom delay
through a new option, `peer_notif_delay'.

Like for `updelay' and `downdelay', this delay should be a multiple of
`miimon' to avoid managing an additional work queue. The configuration
logic is copied from `updelay' and `downdelay'. However, the default
value cannot be set using a module parameter: Netlink or sysfs should
be used to configure this feature.

When setting `miimon' to 100 and `peer_notif_delay' to 500, we can
observe the 500 ms delay is respected:

    20:30:19.354693 ARP, Request who-has 203.0.113.10 tell 203.0.113.10, length 28
    20:30:19.874892 ARP, Request who-has 203.0.113.10 tell 203.0.113.10, length 28
    20:30:20.394919 ARP, Request who-has 203.0.113.10 tell 203.0.113.10, length 28
    20:30:20.914963 ARP, Request who-has 203.0.113.10 tell 203.0.113.10, length 28

In bond_mii_monitor(), I have tried to keep the lock logic readable.
The change is due to the fact we cannot rely on a notification to
lower the value of `bond->send_peer_notif' as `NETDEV_NOTIFY_PEERS' is
only triggered once every N times, while we need to decrement the
counter each time.

iproute2 also needs to be updated to be able to specify this new
attribute through `ip link'.

Signed-off-by: Vincent Bernat <vincent@bernat.ch>
---
 drivers/net/bonding/bond_main.c    | 31 ++++++++-----
 drivers/net/bonding/bond_netlink.c | 14 ++++++
 drivers/net/bonding/bond_options.c | 71 +++++++++++++++++++-----------
 drivers/net/bonding/bond_procfs.c  |  2 +
 drivers/net/bonding/bond_sysfs.c   | 13 ++++++
 include/net/bond_options.h         |  1 +
 include/net/bonding.h              |  1 +
 include/uapi/linux/if_link.h       |  1 +
 tools/include/uapi/linux/if_link.h |  1 +
 9 files changed, 98 insertions(+), 37 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 4f5b3baf04c3..74e90381a317 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -796,6 +796,8 @@ static bool bond_should_notify_peers(struct bonding *bond)
 		   slave ? slave->dev->name : "NULL");
 
 	if (!slave || !bond->send_peer_notif ||
+	    bond->send_peer_notif %
+	    max(1, bond->params.peer_notif_delay) != 0 ||
 	    !netif_carrier_ok(bond->dev) ||
 	    test_bit(__LINK_STATE_LINKWATCH_PENDING, &slave->dev->state))
 		return false;
@@ -886,15 +888,18 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 
 			if (netif_running(bond->dev)) {
 				bond->send_peer_notif =
-					bond->params.num_peer_notif;
+					bond->params.num_peer_notif *
+					max(1, bond->params.peer_notif_delay);
 				should_notify_peers =
 					bond_should_notify_peers(bond);
 			}
 
 			call_netdevice_notifiers(NETDEV_BONDING_FAILOVER, bond->dev);
-			if (should_notify_peers)
+			if (should_notify_peers) {
+				bond->send_peer_notif--;
 				call_netdevice_notifiers(NETDEV_NOTIFY_PEERS,
 							 bond->dev);
+			}
 		}
 	}
 
@@ -2279,6 +2284,7 @@ static void bond_mii_monitor(struct work_struct *work)
 	struct bonding *bond = container_of(work, struct bonding,
 					    mii_work.work);
 	bool should_notify_peers = false;
+	bool commit;
 	unsigned long delay;
 	struct slave *slave;
 	struct list_head *iter;
@@ -2289,12 +2295,19 @@ static void bond_mii_monitor(struct work_struct *work)
 		goto re_arm;
 
 	rcu_read_lock();
-
 	should_notify_peers = bond_should_notify_peers(bond);
-
-	if (bond_miimon_inspect(bond)) {
+	commit = !!bond_miimon_inspect(bond);
+	if (bond->send_peer_notif) {
+		rcu_read_unlock();
+		if (rtnl_trylock()) {
+			bond->send_peer_notif--;
+			rtnl_unlock();
+		}
+	} else {
 		rcu_read_unlock();
+	}
 
+	if (commit) {
 		/* Race avoidance with bond_close cancel of workqueue */
 		if (!rtnl_trylock()) {
 			delay = 1;
@@ -2308,8 +2321,7 @@ static void bond_mii_monitor(struct work_struct *work)
 		bond_miimon_commit(bond);
 
 		rtnl_unlock();	/* might sleep, hold no other locks */
-	} else
-		rcu_read_unlock();
+	}
 
 re_arm:
 	if (bond->params.miimon)
@@ -3065,10 +3077,6 @@ static int bond_master_netdev_event(unsigned long event,
 	case NETDEV_REGISTER:
 		bond_create_proc_entry(event_bond);
 		break;
-	case NETDEV_NOTIFY_PEERS:
-		if (event_bond->send_peer_notif)
-			event_bond->send_peer_notif--;
-		break;
 	default:
 		break;
 	}
@@ -4691,6 +4699,7 @@ static int bond_check_params(struct bond_params *params)
 	params->arp_all_targets = arp_all_targets_value;
 	params->updelay = updelay;
 	params->downdelay = downdelay;
+	params->peer_notif_delay = 0;
 	params->use_carrier = use_carrier;
 	params->lacp_fast = lacp_fast;
 	params->primary[0] = 0;
diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index b24cce48ae35..a259860a7208 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -108,6 +108,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_MAX + 1] = {
 	[IFLA_BOND_AD_ACTOR_SYSTEM]	= { .type = NLA_BINARY,
 					    .len  = ETH_ALEN },
 	[IFLA_BOND_TLB_DYNAMIC_LB]	= { .type = NLA_U8 },
+	[IFLA_BOND_PEER_NOTIF_DELAY]    = { .type = NLA_U32 },
 };
 
 static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1] = {
@@ -215,6 +216,14 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		if (err)
 			return err;
 	}
+	if (data[IFLA_BOND_PEER_NOTIF_DELAY]) {
+		int delay = nla_get_u32(data[IFLA_BOND_PEER_NOTIF_DELAY]);
+
+		bond_opt_initval(&newval, delay);
+		err = __bond_opt_set(bond, BOND_OPT_PEER_NOTIF_DELAY, &newval);
+		if (err)
+			return err;
+	}
 	if (data[IFLA_BOND_USE_CARRIER]) {
 		int use_carrier = nla_get_u8(data[IFLA_BOND_USE_CARRIER]);
 
@@ -494,6 +503,7 @@ static size_t bond_get_size(const struct net_device *bond_dev)
 		nla_total_size(sizeof(u16)) + /* IFLA_BOND_AD_USER_PORT_KEY */
 		nla_total_size(ETH_ALEN) + /* IFLA_BOND_AD_ACTOR_SYSTEM */
 		nla_total_size(sizeof(u8)) + /* IFLA_BOND_TLB_DYNAMIC_LB */
+		nla_total_size(sizeof(u32)) +	/* IFLA_BOND_PEER_NOTIF_DELAY */
 		0;
 }
 
@@ -536,6 +546,10 @@ static int bond_fill_info(struct sk_buff *skb,
 			bond->params.downdelay * bond->params.miimon))
 		goto nla_put_failure;
 
+	if (nla_put_u32(skb, IFLA_BOND_PEER_NOTIF_DELAY,
+			bond->params.downdelay * bond->params.miimon))
+		goto nla_put_failure;
+
 	if (nla_put_u8(skb, IFLA_BOND_USE_CARRIER, bond->params.use_carrier))
 		goto nla_put_failure;
 
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 0d852fe9da7c..ddb3916d3506 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -24,6 +24,8 @@ static int bond_option_updelay_set(struct bonding *bond,
 				   const struct bond_opt_value *newval);
 static int bond_option_downdelay_set(struct bonding *bond,
 				     const struct bond_opt_value *newval);
+static int bond_option_peer_notif_delay_set(struct bonding *bond,
+					    const struct bond_opt_value *newval);
 static int bond_option_use_carrier_set(struct bonding *bond,
 				       const struct bond_opt_value *newval);
 static int bond_option_arp_interval_set(struct bonding *bond,
@@ -424,6 +426,13 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.desc = "Number of peer notifications to send on failover event",
 		.values = bond_num_peer_notif_tbl,
 		.set = bond_option_num_peer_notif_set
+	},
+	[BOND_OPT_PEER_NOTIF_DELAY] = {
+		.id = BOND_OPT_PEER_NOTIF_DELAY,
+		.name = "peer_notif_delay",
+		.desc = "Delay between each peer notification on failover event, in milliseconds",
+		.values = bond_intmax_tbl,
+		.set = bond_option_peer_notif_delay_set
 	}
 };
 
@@ -841,6 +850,9 @@ static int bond_option_miimon_set(struct bonding *bond,
 	if (bond->params.downdelay)
 		netdev_dbg(bond->dev, "Note: Updating downdelay (to %d) since it is a multiple of the miimon value\n",
 			   bond->params.downdelay * bond->params.miimon);
+	if (bond->params.peer_notif_delay)
+		netdev_dbg(bond->dev, "Note: Updating peer_notif_delay (to %d) since it is a multiple of the miimon value\n",
+			   bond->params.peer_notif_delay * bond->params.miimon);
 	if (newval->value && bond->params.arp_interval) {
 		netdev_dbg(bond->dev, "MII monitoring cannot be used with ARP monitoring - disabling ARP monitoring...\n");
 		bond->params.arp_interval = 0;
@@ -864,52 +876,59 @@ static int bond_option_miimon_set(struct bonding *bond,
 	return 0;
 }
 
-/* Set up and down delays. These must be multiples of the
- * MII monitoring value, and are stored internally as the multiplier.
- * Thus, we must translate to MS for the real world.
+/* Set up, down and peer notification delays. These must be multiples
+ * of the MII monitoring value, and are stored internally as the
+ * multiplier. Thus, we must translate to MS for the real world.
  */
-static int bond_option_updelay_set(struct bonding *bond,
-				   const struct bond_opt_value *newval)
+static int _bond_option_delay_set(struct bonding *bond,
+				  const struct bond_opt_value *newval,
+				  const char *name,
+				  int *target)
 {
 	int value = newval->value;
 
 	if (!bond->params.miimon) {
-		netdev_err(bond->dev, "Unable to set up delay as MII monitoring is disabled\n");
+		netdev_err(bond->dev, "Unable to set %s as MII monitoring is disabled\n",
+			   name);
 		return -EPERM;
 	}
 	if ((value % bond->params.miimon) != 0) {
-		netdev_warn(bond->dev, "up delay (%d) is not a multiple of miimon (%d), updelay rounded to %d ms\n",
+		netdev_warn(bond->dev,
+			    "%s (%d) is not a multiple of miimon (%d), value rounded to %d ms\n",
+			    name,
 			    value, bond->params.miimon,
 			    (value / bond->params.miimon) *
 			    bond->params.miimon);
 	}
-	bond->params.updelay = value / bond->params.miimon;
-	netdev_dbg(bond->dev, "Setting up delay to %d\n",
-		   bond->params.updelay * bond->params.miimon);
+	*target = value / bond->params.miimon;
+	netdev_dbg(bond->dev, "Setting %s to %d\n",
+		   name,
+		   *target * bond->params.miimon);
 
 	return 0;
 }
 
+static int bond_option_updelay_set(struct bonding *bond,
+				   const struct bond_opt_value *newval)
+{
+	return _bond_option_delay_set(bond, newval, "up delay",
+				      &bond->params.updelay);
+}
+
 static int bond_option_downdelay_set(struct bonding *bond,
 				     const struct bond_opt_value *newval)
 {
-	int value = newval->value;
-
-	if (!bond->params.miimon) {
-		netdev_err(bond->dev, "Unable to set down delay as MII monitoring is disabled\n");
-		return -EPERM;
-	}
-	if ((value % bond->params.miimon) != 0) {
-		netdev_warn(bond->dev, "down delay (%d) is not a multiple of miimon (%d), delay rounded to %d ms\n",
-			    value, bond->params.miimon,
-			    (value / bond->params.miimon) *
-			    bond->params.miimon);
-	}
-	bond->params.downdelay = value / bond->params.miimon;
-	netdev_dbg(bond->dev, "Setting down delay to %d\n",
-		   bond->params.downdelay * bond->params.miimon);
+	return _bond_option_delay_set(bond, newval, "down delay",
+				      &bond->params.downdelay);
+}
 
-	return 0;
+static int bond_option_peer_notif_delay_set(struct bonding *bond,
+					    const struct bond_opt_value *newval)
+{
+	int ret = _bond_option_delay_set(bond, newval,
+					 "peer notification delay",
+					 &bond->params.peer_notif_delay);
+	return ret;
 }
 
 static int bond_option_use_carrier_set(struct bonding *bond,
diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index 9f7d83e827c3..fd5c9cbe45b1 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -104,6 +104,8 @@ static void bond_info_show_master(struct seq_file *seq)
 		   bond->params.updelay * bond->params.miimon);
 	seq_printf(seq, "Down Delay (ms): %d\n",
 		   bond->params.downdelay * bond->params.miimon);
+	seq_printf(seq, "Peer Notification Delay (ms): %d\n",
+		   bond->params.peer_notif_delay * bond->params.miimon);
 
 
 	/* ARP information */
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 94214eaf53c5..2d615a93685e 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -327,6 +327,18 @@ static ssize_t bonding_show_updelay(struct device *d,
 static DEVICE_ATTR(updelay, 0644,
 		   bonding_show_updelay, bonding_sysfs_store_option);
 
+static ssize_t bonding_show_peer_notif_delay(struct device *d,
+					     struct device_attribute *attr,
+					     char *buf)
+{
+	struct bonding *bond = to_bond(d);
+
+	return sprintf(buf, "%d\n",
+		       bond->params.peer_notif_delay * bond->params.miimon);
+}
+static DEVICE_ATTR(peer_notif_delay, 0644,
+		   bonding_show_peer_notif_delay, bonding_sysfs_store_option);
+
 /* Show the LACP interval. */
 static ssize_t bonding_show_lacp(struct device *d,
 				 struct device_attribute *attr,
@@ -718,6 +730,7 @@ static struct attribute *per_bond_attrs[] = {
 	&dev_attr_arp_ip_target.attr,
 	&dev_attr_downdelay.attr,
 	&dev_attr_updelay.attr,
+	&dev_attr_peer_notif_delay.attr,
 	&dev_attr_lacp_rate.attr,
 	&dev_attr_ad_select.attr,
 	&dev_attr_xmit_hash_policy.attr,
diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index 2a05cc349018..9d382f2f0bc5 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -63,6 +63,7 @@ enum {
 	BOND_OPT_AD_ACTOR_SYSTEM,
 	BOND_OPT_AD_USER_PORT_KEY,
 	BOND_OPT_NUM_PEER_NOTIF_ALIAS,
+	BOND_OPT_PEER_NOTIF_DELAY,
 	BOND_OPT_LAST
 };
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 676e7fae05a3..f7fe45689142 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -123,6 +123,7 @@ struct bond_params {
 	int fail_over_mac;
 	int updelay;
 	int downdelay;
+	int peer_notif_delay;
 	int lacp_fast;
 	unsigned int min_links;
 	int ad_select;
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 6f75bda2c2d7..4a8c02cafa9a 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -636,6 +636,7 @@ enum {
 	IFLA_BOND_AD_USER_PORT_KEY,
 	IFLA_BOND_AD_ACTOR_SYSTEM,
 	IFLA_BOND_TLB_DYNAMIC_LB,
+	IFLA_BOND_PEER_NOTIF_DELAY,
 	__IFLA_BOND_MAX,
 };
 
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 5b225ff63b48..7d113a9602f0 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -636,6 +636,7 @@ enum {
 	IFLA_BOND_AD_USER_PORT_KEY,
 	IFLA_BOND_AD_ACTOR_SYSTEM,
 	IFLA_BOND_TLB_DYNAMIC_LB,
+	IFLA_BOND_PEER_NOTIF_DELAY,
 	__IFLA_BOND_MAX,
 };
 
-- 
2.20.1

