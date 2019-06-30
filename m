Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF9B95B162
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 20:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfF3S7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 14:59:55 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:39631 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726572AbfF3S7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 14:59:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 460F83E9;
        Sun, 30 Jun 2019 14:59:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 30 Jun 2019 14:59:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=+ofqA7e6xKJL13J11q7ZJmAlXp
        fGr3dUwS3UxTnBSNg=; b=HJ0gR4qhafjVMB//LuRtCgVBMswcPQbLGpUubytxu/
        pBwt48pljMyPEm65f+D2rT+CkQtMqAPPuLJn78+8xOIFhU2BtCI5GFBnLEL1Ax56
        ntlax6ICW2Ou/sKvpjkv8uSL9QT44LuYFElpf54+As7YYiXAgnl74k6ppldU6z1D
        JWGAI1IxZkqRIiufMeP1vUW+5e5Zm96koWv91T2yrlCEtTCsFw21Dtr23XD3o/AL
        cR+kRFVJgWgNL9qPIHoeqrRl9J+LIVBFJU47o+nrA94tYm1nt76+pyhQRcArFe4O
        mytMk7pXXjYfDYxBiVvDhbU3uVnjSa/y5Cs6kgIo1yyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+ofqA7e6xKJL13J11
        q7ZJmAlXpfGr3dUwS3UxTnBSNg=; b=jQjrzHiJHY6DHw2CZxlsTv1U0MWP8ahzh
        o6a7qDk2JcS6R0vv7j6/Rc6UztRn65CKTJbIcwTI4j/8il9L5vF0kcIXTM4Of4S7
        xL+iuN91L8S2fanTa9n4UGltnJ2zubTs9aJW8FsTzI2XNjjqZYPcNeLTMCtslGA/
        zbsR6tVpLHkEqSnJKncR7pXwbGfmy0dDr7toeau7ricw2SVo7WyHTeZLWom2M9Nd
        8n0ymRSQjLlrTar3vPUi42xZaDakJNK5P/Zc4Pgdt2T2jrseAFjGTv5e+nKVuax1
        Ce3MzegMQ5u834CV61NfJVJQNWxO6TrmJtMbdSF/P3mZiQSEp3qnQ==
X-ME-Sender: <xms:pQYZXZsO6szgttFgZI0vJ8afRZN16SyaXbscOQb9mvkrhkeMm1m0ow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdeggddufedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeggihhntggvnhht
    uceuvghrnhgrthcuoehvihhntggvnhhtsegsvghrnhgrthdrtghhqeenucfkphepkeehrd
    durddutddvrddvfedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgrtheslhhu
    fhhfhidrtgignecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:pQYZXUwQDhakypV4yVmCum4CWW-aB4wy_iieJqPP6YV98eIEIzeDEw>
    <xmx:pQYZXbhfXCGX31aLXB7HugWQEQGjrbd5UPSDKOhqyRi5Nfzxw8om7w>
    <xmx:pQYZXaZ9gwl2nPjX3HsmpqM8JhpySO3TisgVK3y1hJ98AL1wFzhQBQ>
    <xmx:pQYZXSW3iBLeFP1k8DmdaLaaFwN0HH1FFWyiDCNK0TYvyzhvfUGoPw>
Received: from neo.luffy.cx (230.102.1.85.dynamic.wline.res.cust.swisscom.ch [85.1.102.230])
        by mail.messagingengine.com (Postfix) with ESMTPA id AEC8D80060;
        Sun, 30 Jun 2019 14:59:48 -0400 (EDT)
Received: by neo.luffy.cx (Postfix, from userid 500)
        id 4E3C11107; Sun, 30 Jun 2019 20:59:47 +0200 (CEST)
From:   Vincent Bernat <vincent@bernat.ch>
To:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Vincent Bernat <vincent@bernat.ch>
Subject: [PATCH net-next v1] bonding: add an option to specify a delay between peer notifications
Date:   Sun, 30 Jun 2019 20:59:31 +0200
Message-Id: <20190630185931.18746-1-vincent@bernat.ch>
X-Mailer: git-send-email 2.20.1
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
logic is copied from `updelay' and `downdelay'.

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
 drivers/net/bonding/bond_main.c    | 55 +++++++++++++++++------
 drivers/net/bonding/bond_netlink.c | 14 ++++++
 drivers/net/bonding/bond_options.c | 71 +++++++++++++++++++-----------
 drivers/net/bonding/bond_procfs.c  |  2 +
 drivers/net/bonding/bond_sysfs.c   | 13 ++++++
 include/net/bond_options.h         |  1 +
 include/net/bonding.h              |  1 +
 include/uapi/linux/if_link.h       |  1 +
 tools/include/uapi/linux/if_link.h |  1 +
 9 files changed, 119 insertions(+), 40 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 4f5b3baf04c3..6ee35df482a4 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -93,6 +93,7 @@ static int num_peer_notif = 1;
 static int miimon;
 static int updelay;
 static int downdelay;
+static int peer_notif_delay;
 static int use_carrier	= 1;
 static char *mode;
 static char *primary;
@@ -129,6 +130,9 @@ MODULE_PARM_DESC(updelay, "Delay before considering link up, in milliseconds");
 module_param(downdelay, int, 0);
 MODULE_PARM_DESC(downdelay, "Delay before considering link down, "
 			    "in milliseconds");
+module_param(peer_notif_delay, int, 0);
+MODULE_PARM_DESC(peer_notif_delay, "Delay between each peer notification on "
+				   "failover event, in milliseconds");
 module_param(use_carrier, int, 0);
 MODULE_PARM_DESC(use_carrier, "Use netif_carrier_ok (vs MII ioctls) in miimon; "
 			      "0 for off, 1 for on (default)");
@@ -796,6 +800,8 @@ static bool bond_should_notify_peers(struct bonding *bond)
 		   slave ? slave->dev->name : "NULL");
 
 	if (!slave || !bond->send_peer_notif ||
+	    bond->send_peer_notif %
+	    max(1, bond->params.peer_notif_delay) != 0 ||
 	    !netif_carrier_ok(bond->dev) ||
 	    test_bit(__LINK_STATE_LINKWATCH_PENDING, &slave->dev->state))
 		return false;
@@ -886,15 +892,18 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 
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
 
@@ -2279,6 +2288,7 @@ static void bond_mii_monitor(struct work_struct *work)
 	struct bonding *bond = container_of(work, struct bonding,
 					    mii_work.work);
 	bool should_notify_peers = false;
+	bool commit;
 	unsigned long delay;
 	struct slave *slave;
 	struct list_head *iter;
@@ -2289,12 +2299,19 @@ static void bond_mii_monitor(struct work_struct *work)
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
@@ -2308,8 +2325,7 @@ static void bond_mii_monitor(struct work_struct *work)
 		bond_miimon_commit(bond);
 
 		rtnl_unlock();	/* might sleep, hold no other locks */
-	} else
-		rcu_read_unlock();
+	}
 
 re_arm:
 	if (bond->params.miimon)
@@ -3065,10 +3081,6 @@ static int bond_master_netdev_event(unsigned long event,
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
@@ -4443,6 +4455,12 @@ static int bond_check_params(struct bond_params *params)
 		downdelay = 0;
 	}
 
+	if (peer_notif_delay < 0) {
+		pr_warn("Warning: peer_notif_delay module parameter (%d), not in range 0-%d, so it was reset to 0\n",
+			peer_notif_delay, INT_MAX);
+		peer_notif_delay = 0;
+	}
+
 	if ((use_carrier != 0) && (use_carrier != 1)) {
 		pr_warn("Warning: use_carrier module parameter (%d), not of valid value (0/1), so it was set to 1\n",
 			use_carrier);
@@ -4495,12 +4513,12 @@ static int bond_check_params(struct bond_params *params)
 	}
 
 	if (!miimon) {
-		if (updelay || downdelay) {
+		if (updelay || downdelay || peer_notif_delay) {
 			/* just warn the user the up/down delay will have
 			 * no effect since miimon is zero...
 			 */
-			pr_warn("Warning: miimon module parameter not set and updelay (%d) or downdelay (%d) module parameter is set; updelay and downdelay have no effect unless miimon is set\n",
-				updelay, downdelay);
+			pr_warn("Warning: miimon module parameter not set and updelay (%d), downdelay (%d) or peer_notif_delay (%d) module parameter is set; updelay, downdelay have and peer_notif_delay have no effect unless miimon is set\n",
+				updelay, downdelay, peer_notif_delay);
 		}
 	} else {
 		/* don't allow arp monitoring */
@@ -4524,6 +4542,14 @@ static int bond_check_params(struct bond_params *params)
 		}
 
 		downdelay /= miimon;
+
+		if ((peer_notif_delay % miimon) != 0) {
+			pr_warn("Warning: peer_notif_delay (%d) is not a multiple of miimon (%d), peer_notif_delay rounded to %d ms\n",
+				peer_notif_delay, miimon,
+				(peer_notif_delay / miimon) * miimon);
+		}
+
+		peer_notif_delay /= miimon;
 	}
 
 	if (arp_interval < 0) {
@@ -4691,6 +4717,7 @@ static int bond_check_params(struct bond_params *params)
 	params->arp_all_targets = arp_all_targets_value;
 	params->updelay = updelay;
 	params->downdelay = downdelay;
+	params->peer_notif_delay = peer_notif_delay;
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

