Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CC23C5F27
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbhGLPZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:30 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:46304
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235511AbhGLPZT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ajoj2t7PEyIu10xH4omQgex9bYQ5o9amUF1L265spWfs9pNz3/BIgtPp2l18TSSwqyC2cwQpMHHZllHvC3+BbGZKo/+LZZoeImUTq/1LYRjtisUu7PTwlbF09jzfNOkXYNtDWWpGSUXiysRR5R0VRBuZvlnx8Q18kxXahQ2IIog+r1mzkxPtN4zo8MuZF8MTFpFK5llCjgO0PFQUzBxWiIJWLD8i8p6ME6DhLJduGxudTIvtlR8IdRdXzig0R9bJB/bKzCKzkCB+nRQtZQtriFWPSguEZsfeYRWJeIEIz4VMG9A8qkb3/VHnFgfAE1umuwZRxpjg4NCjpSL9yByFJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKBM7Fl6q1XMHGHXHcaKF/ZFWalOLNVhEubPkfDeL4w=;
 b=Evr4Ur8tiNyKHhYXQHK2cDqybQySd+LZ6P1ry7ac9h0P8IUnteyhqhAqde+ONmFVy8kUegOI/41S1wNkpqqiAvUVSV40tKzvz7qhEPWKo5hTrQmotKZbMAvfp8yUIWt7S61JEdv12F26wowtaNrQ/tGwPNzcakR4WW9mtl5vDgV+004UkIK+utuX6ySNW8krWrWPRI962u6dNxzKcCaBTJLFF0PaPkvDPgqxzEzmL73ceJ5J6EgU9YjPCOOWX6p/uPOtD882Uj5IAIxCnGk9SEJ+Wh6/yZFo0vGUxXEowNKdmjMU8uCwili6vKkNpqHgXM77/LZ08UQgUHzwQoe77Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKBM7Fl6q1XMHGHXHcaKF/ZFWalOLNVhEubPkfDeL4w=;
 b=f8OW6qD//2ld8FH9FLRr5yy1/9SLRXFAxM3wNxhJR6WCMYXmw3SarqI931pJYs0jdSAi0p/tsuflxbTPsPfqOir4Af9N4Zh1IRak/pFW6FkMrcZqaMhrVbznTRugywbxcRcJZT4Aorwij0CbVNNE8pvRJHAX2ropJuV9XRWEjp0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 13/24] net: bridge: use the public notifier chain for br_fdb_replay
Date:   Mon, 12 Jul 2021 18:21:31 +0300
Message-Id: <20210712152142.800651-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27e74d2b-7177-4e73-72f4-08d94548da21
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB62715D790CB1DD2585797A6EE0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RQxES6N/cDzMK+k5vg56lsnl8JsxuNQBXosEuWd7TvWrQJbcLGLbU/Gt6w35SPyBQci0K8RPSS4+7QPrfrst6LYAD/ZUkKqpkeR1t53GrVjKe0KbQ+IMacMBBDj0lBGI21ueCqr4MUdVEnRD28NZCKJYCPjv9+Dvc0bUAOu3ABpxMhIJ3uVxxL3yt88u9jYb/9RfqxQYJFmC66RvhDj1i2J9r14P8dhJbdH2qQP8Z8axbnCk1rI9gtsHYamsa+LuCqJzEMb0wh6eDcwI7g2bXQA16ycnqPu9s6VGPb6o9K4/xp/PEJ5HGFnuidi1HTqedh2kN+F5oVXcZWefZC4BJmmcz9SHZmq2f6K/tDqz+34XIttsxvkqaU7FTnroLV6iBTZUcDOuNAZohnw0iePrIyPXxMMZmh0beAodJsRPhtb7GSJ7+m+dkVy2iynE7/Wh28WFFwaKfw+XuPfY/WMTh/pT5kDQN+UQBCuswj2C3jG75SzJzlnzcllJyqQ9vRYDMGb+S5aV9xWz5zYfS5ihMHqPTbLWM9BGm77ql4F03c4743fWCz7VX9l0rcqkYYm0vjNAtGoNfoThQPnZr3rQhZuf2nPQ2SMdZmoz+RPkEA89kk1lnXrP+GSsmmYVbEEbxciVjswod/G4htZdlcmsGYEbXpbDFPRUOq9Lr77WN38E6ZAwrFDmx/N+jIsR60hpGVjzjOijGjtYB+PyJeJ3rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(6666004)(83380400001)(66556008)(38100700002)(8676002)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Nv0/ub9jYrfUnKPjqao3iZFaUaq94IXLOQCmFdZ6hRj+CV6/JY4VMgZOcGk?=
 =?us-ascii?Q?jEMRi0rVQ6Our6DQYIT0oX6ZmH5g89imq8LZH4GNYGBGl6sZZBqwnhTOoOJj?=
 =?us-ascii?Q?BQ6T7Fr729G21UaLrLfzVYbSC2LzQKtTWRoJYdo/+IsCEbjvJryG3OY1VdOV?=
 =?us-ascii?Q?GfrrNRNlXXG6bwI7hvI/arWrTBlanykXO9j9bheNlV95upPXPSNGMOYuJHJk?=
 =?us-ascii?Q?0f6KIt8o0wSxszq0I8yjJdHq45pCH3RtCvLZNzgopG4iVzox6F7foGYuoL5T?=
 =?us-ascii?Q?Fv+Rvp9srlVp2yfptNUbPEuXJZnCJxagZIpPLKXUEsvSwsdwIY1J/oN+FPWy?=
 =?us-ascii?Q?fdT9ylEMppSaCiG/fql9RK41wlT3V9itXDc9ZX01384e8Eo5v10r8055LC4S?=
 =?us-ascii?Q?NRJLe67qSC7y5Frj36MoZxe69O6+lOoP62fygG/W7PM+z37l+bk/XyLD3SSO?=
 =?us-ascii?Q?lSQcI15cgUnIUUqmS6UhGd5Zyfa6bH5KS9wphVMvA1ihCHZ3LtDsT5+AzCuB?=
 =?us-ascii?Q?j55Qn4Wo9ctpR7PvWMdT/0PEj9/fZcSBBL/7wkxunFvK9cidAONcgfEMiuiM?=
 =?us-ascii?Q?wzArPISncTisv35/p7PVsCEGvsWTu6HGNVJ11HxXvk4DHRzFGBAfrZt3Sbk5?=
 =?us-ascii?Q?J3dWnRK3hfWc1aWEFoKYWMeAMApBoB/iilq33wPS1v/5lY4OFvglrjrPFJ0V?=
 =?us-ascii?Q?6i/OPiuXWpgGUJzaS8vBpLflRJxM206BR++KdA8eKY5V0/iHy66ogD2MROZb?=
 =?us-ascii?Q?5Xw5BXXer3Q3rllIV0E+Im3MsrJMlPb9LxdnkWuonEL83eW/PRWfaKQOBI6k?=
 =?us-ascii?Q?lF4k94yipUf4SuQZEdQChObklAoctapH4MzD56p5lkgPGkI21k/ENPx/IXMm?=
 =?us-ascii?Q?xM6eX9APNHAOGsi5v2TUAKE7dUpZ7owggSpbzr8D6rPtEZ7PgCdq8ycO8vAW?=
 =?us-ascii?Q?nY8JmGUTBlfLRI8i0P/hvxUgTMeGO0ryqbxmwU8UZ1YA/hSvOalCWHnCvtTc?=
 =?us-ascii?Q?Us7suoGaVsrar8BBxKoE5zPMQ+mT/sGF96Jo5OB7oqKqSERHcweM+3B2HFj7?=
 =?us-ascii?Q?/1yGKBixv/BXhIWDdD2SMsn53RkQXMdYqNP3viveV0bzyXFRe4BxmNPgLYhz?=
 =?us-ascii?Q?JewMqJA0YX/oBp1D61BLdyFp9GNj+Ru8XIcBuKgMAImTtgC57vUF2oc5rtpq?=
 =?us-ascii?Q?HHIui5Z+EFp2wMJg8hbUJ/LIJp4f6qPiTagLoD0eGZAIG3D/0jziN8Rm7Uto?=
 =?us-ascii?Q?5WBCazakMlvjYJcQarSx2UStqrmn3cJR0uxWtYUE3HUy4FcY3mp2z5k+JCEa?=
 =?us-ascii?Q?TuAs0iZgpTMe1/3wvbhq9nIY?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e74d2b-7177-4e73-72f4-08d94548da21
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:25.0811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: asdR3QcINuvDC/McIst9zVBbNzdmlWJuj9xGuYkC6GtJTq9N6FRnq2VphBnpaZhdtPTtcf7EppENAfutXnZOAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, switchdev users of br_fdb_replay pass a pointer to their
atomic notifier block for the bridge to replay the FDB entries on the
port and local to the bridge, and the bridge whispers those FDB entries
to that driver only, and not publicly on the switchdev atomic notifier
call chain.

Going forward we would like to introduce push-mode FDB replays for all
switchdev drivers, and there are at least two reasons why the current
setup is not ideal.

First and most obvious, every driver would have to be changed to pass
its atomic notifier block to the switchdev_bridge_port_offload() and
switchdev_bridge_port_unoffload() calls, which gets a bit cumbersome.

The second is that it wasn't a good idea in the first place for the
other switchdev drivers to not hear anything about the FDB entries on
foreign interfaces. For example, DSA treats these FDB entries in a
special way since commit 3068d466a67e ("net: dsa: sync static FDB
entries on foreign interfaces to hardware"). With the static FDB entry
addition being public on everybody's notifier block but the deletion
being whispered only to the driver whose port leaves the bridge, DSA
would have a lingering static FDB entry pointing towards the host.

Making br_fdb_replay() use the atomic switchdev call chain solves both
problems.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_bridge.h |  4 ++--
 net/bridge/br_fdb.c       | 43 +++++++--------------------------------
 net/dsa/dsa_priv.h        |  1 -
 net/dsa/port.c            | 10 ++++-----
 net/dsa/slave.c           |  2 +-
 5 files changed, 14 insertions(+), 46 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 13acc1ff476c..8d4a157d249d 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -168,7 +168,7 @@ bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
 u8 br_port_get_stp_state(const struct net_device *dev);
 clock_t br_get_ageing_time(const struct net_device *br_dev);
 int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
-		  bool adding, struct notifier_block *nb);
+		  bool adding);
 #else
 static inline struct net_device *
 br_fdb_find_port(const struct net_device *br_dev,
@@ -200,7 +200,7 @@ static inline clock_t br_get_ageing_time(const struct net_device *br_dev)
 
 static inline int br_fdb_replay(const struct net_device *br_dev,
 				const struct net_device *dev,
-				bool adding, struct notifier_block *nb)
+				bool adding)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index c93a2b3a0ad8..4434aee4cfbc 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -732,31 +732,12 @@ static inline size_t fdb_nlmsg_size(void)
 		+ nla_total_size(sizeof(u8)); /* NFEA_ACTIVITY_NOTIFY */
 }
 
-static int br_fdb_replay_one(struct notifier_block *nb,
-			     const struct net_bridge_fdb_entry *fdb,
-			     struct net_device *dev, unsigned long action)
-{
-	struct switchdev_notifier_fdb_info item;
-	int err;
-
-	item.addr = fdb->key.addr.addr;
-	item.vid = fdb->key.vlan_id;
-	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
-	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
-	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
-	item.info.dev = dev;
-
-	err = nb->notifier_call(nb, action, &item);
-	return notifier_to_errno(err);
-}
-
 int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
-		  bool adding, struct notifier_block *nb)
+		  bool adding)
 {
 	struct net_bridge_fdb_entry *fdb;
 	struct net_bridge *br;
-	unsigned long action;
-	int err = 0;
+	int type;
 
 	if (!netif_is_bridge_master(br_dev))
 		return -EINVAL;
@@ -767,28 +748,18 @@ int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
 	br = netdev_priv(br_dev);
 
 	if (adding)
-		action = SWITCHDEV_FDB_ADD_TO_DEVICE;
+		type = RTM_NEWNEIGH;
 	else
-		action = SWITCHDEV_FDB_DEL_TO_DEVICE;
+		type = RTM_DELNEIGH;
 
 	rcu_read_lock();
 
-	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
-		const struct net_bridge_port *dst = READ_ONCE(fdb->dst);
-		struct net_device *dst_dev;
-
-		dst_dev = dst ? dst->dev : br->dev;
-		if (dst_dev != br_dev && dst_dev != dev)
-			continue;
-
-		err = br_fdb_replay_one(nb, fdb, dst_dev, action);
-		if (err)
-			break;
-	}
+	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node)
+		br_switchdev_fdb_notify(br, fdb, type);
 
 	rcu_read_unlock();
 
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(br_fdb_replay);
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f201c33980bf..20003512d8f8 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -285,7 +285,6 @@ static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
 
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
-extern struct notifier_block dsa_slave_switchdev_notifier;
 extern struct notifier_block dsa_slave_switchdev_blocking_notifier;
 
 void dsa_slave_mii_bus_init(struct dsa_switch *ds);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 34b7f64348c2..ccf11bc518fe 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -200,13 +200,12 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 		return err;
 
 	/* Forwarding and termination FDB entries on the port */
-	err = br_fdb_replay(br, brport_dev, true,
-			    &dsa_slave_switchdev_notifier);
+	err = br_fdb_replay(br, brport_dev, true);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
 	/* Termination FDB entries on the bridge itself */
-	err = br_fdb_replay(br, br, true, &dsa_slave_switchdev_notifier);
+	err = br_fdb_replay(br, br, true);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
@@ -232,13 +231,12 @@ static int dsa_port_switchdev_unsync_objs(struct dsa_port *dp,
 		return err;
 
 	/* Forwarding and termination FDB entries on the port */
-	err = br_fdb_replay(br, brport_dev, false,
-			    &dsa_slave_switchdev_notifier);
+	err = br_fdb_replay(br, brport_dev, false);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
 	/* Termination FDB entries on the bridge itself */
-	err = br_fdb_replay(br, br, false, &dsa_slave_switchdev_notifier);
+	err = br_fdb_replay(br, br, false);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ffbba1e71551..461c80bc066a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2517,7 +2517,7 @@ static struct notifier_block dsa_slave_nb __read_mostly = {
 	.notifier_call  = dsa_slave_netdevice_event,
 };
 
-struct notifier_block dsa_slave_switchdev_notifier = {
+static struct notifier_block dsa_slave_switchdev_notifier = {
 	.notifier_call = dsa_slave_switchdev_event,
 };
 
-- 
2.25.1

