Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6007C43CEA2
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238164AbhJ0QYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:24:11 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:57505
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238242AbhJ0QYL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 12:24:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0jxoRquG6N1+b322NyjZXvrG42JJXbYZ9VZ6jocoJP/ThRewqd+EXGIy49KlGgiD44zs00Fzae1UlCbuU/IfscOqfr/rdVA+8LR6lorYSDLuAo9h+zdg18WSdZ8PABOpH+Nwyp+twvUYt9wNrJj0B7egiCuCmds/5POQoG6wO6/HPp5SUcOPizINn/dMsBuiVkfDyGLpC/ZY7w1V7BO8rvLJGRggCgjbagMg8IabaNdEGlRHbKlvrZ6TA+3JW/rxTijTvlHWUnQsomqRM2sRirEZfaKt6M9dY60x+vZgVQ9QG4w9N+wmuomy8jcJ6rgsVX2BqYEGtmqdcXA2juSRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NciszpcP7ObvnrGxGEWNqptEBcaWNpxVnf4x+JfJksY=;
 b=CmsFSP7tLPSo58QGfJ4MmBzsDhxyOfMyuFnYedsc7l6Fl6TsCqGJJC7XVG/JMGdqwV5Ma2RxlXxnynYW5CtLOEQ5U7VFEJYcAVeb+kSazUuT4xZLXtDwpBMpvc3krfUxJQmB6tzhzifPAkeq4936pbqKh9eCl5XKiDPcCGr26EYAepcAMAT6SeTSKmQxJDEGIglNdTxvyM//K7YpOm0llqXOhUcTouBNo3AIoEYSBOOtBKIhgUtl5ZDPTxhUDrAsaFgNn3GDC3DiKutUU3SVFkU9zhrmHF98W5VNRLNGH3iVPJC1QRoF0CEEUkLiU/4BXsWypm7BOh4t/VuA2XWxdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NciszpcP7ObvnrGxGEWNqptEBcaWNpxVnf4x+JfJksY=;
 b=WA5i07yGRIu0iuSG0x2OV+wolnKJQ8m3C2+A/0KcuNmArxVYKy6/8d4doNQd6axoP2r/KHvHsHXlRGDiFs4R6g+DAhXFD5wOUwOUwAxXfZPg4OGgsGeEXRT9ZLw7QiEQldMeZD3XNdDRauZUFuaZv6S48ZcAzdWoAkHzWH5zuIg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6014.eurprd04.prod.outlook.com (2603:10a6:803:c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 16:21:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 16:21:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/5] net: bridge: switchdev: consistent function naming
Date:   Wed, 27 Oct 2021 19:21:19 +0300
Message-Id: <20211027162119.2496321-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0057.eurprd05.prod.outlook.com
 (2603:10a6:200:68::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.175.102) by AM4PR0501CA0057.eurprd05.prod.outlook.com (2603:10a6:200:68::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 16:21:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7298b76f-6651-4368-73d7-08d99965d801
X-MS-TrafficTypeDiagnostic: VI1PR04MB6014:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6014D88230BB6D9C31C13EA6E0859@VI1PR04MB6014.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aWXN4+Ud+g6LrEwJ2zFJu3HYE7tFV+UiKSEaSPScShQRUW6EGdFcaMD+XA4R2wGfsqDULdiow8XkI80j6lMrKgEDuxOv8SfdgpMXnIkp9ONdNEEZTR6RYqSSxGGEvGxOJxBYryEXIJDPS6bh7IV3Hv22fDS1L/T+z64XaXIrut2bee1sV5yg9SnPqqN7R2NHHva622xCGOwoAjTz782uyYj0L9GrukYKfdYKQdLmqrYS2N60ubiSQ2JY+LzGT5huZXHKLvG85GJEjwRKEXeKtMLwDH5Fa4einhVfy01q6+5lrEr7xz3VgR7DfIIFtFhJxioY0MsnsccPWU6IkOb6LF0CbdWqvD2gFzgQXYDKHid6F4/REdluLkFat66Ii3u14Fm3NRrctWnhq1cGKPLr2nywyz4vOzx80CtstkqT+vNFDIDHILIMk8/Bso4Om4JarZK4riqVN+lKlifWKWEzxVa3+FxOe9vfHL9Y2k6iHd5KXbTxjTNj8VtEdrttTicxnRe8tlTh75wd7C4nD8eIh2fJXRM18PYWTO9eYyWvzV5VRCGJ6Ed84ibn4NYEwywRAPpecM1UZjUURwUcwcfJpHGSxaGU53z1sCZvD1sQ5vNuMChyCbCjh35mKImgMv9yAhnzTrjP8ULTCePEL4hXECFMj03o1+nYMm/DzUyN+7NbA9PGaA6PjApzF0nXE8eZIKYuzDMnKV7CDVvLJZJr+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(66476007)(52116002)(6506007)(2616005)(316002)(86362001)(6512007)(83380400001)(508600001)(26005)(6916009)(4326008)(8676002)(66556008)(66946007)(5660300002)(8936002)(186003)(38100700002)(36756003)(54906003)(2906002)(38350700002)(6486002)(956004)(1076003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S1KjxXbylYBfRkSzeOL5OcezMFP1AUzba0AzZ1DWWoLeLVxTtfrykCXhr0P4?=
 =?us-ascii?Q?bB8Ymd+Gb0NIy1XodAWd0c3WR68y/ah6cAnB037SLSPUWwZHfApY+pU7frWH?=
 =?us-ascii?Q?xfFXTH4nEzO3VgQyLgbgLN5TbXLWkMFkBHgtR/YWZSpQq64YJlGt0rZIY8/C?=
 =?us-ascii?Q?jvfaeA4KYLQXuSPCFG/9gMp45yfFm3V5gINnzHYVYCvDwZcr+3hD49Q6gGXx?=
 =?us-ascii?Q?fG7G/qYTKX67aCtsfJ4irrUFjqr/83OuRI84VjsBCUETL/gPkKfqY5MAlQsC?=
 =?us-ascii?Q?ToQCjfg4R9dvR4V1NDi8L2yIQVOetMyYO/acsovhZqgUhlNtjl2qhrSdbG3K?=
 =?us-ascii?Q?EbyFW8QmegcHufg+s66sHWFp4IDoN3V4Hy6GWwhZjeB8bxvYeOMV7Ef47C4z?=
 =?us-ascii?Q?uq4g+eNNtSklPNANB1KMIEQV+mRKI8sV+j9jkDXNt1kfZoPhkgXpuYg4mxs+?=
 =?us-ascii?Q?cg4M0GQ6LXgZ5wrMuVIocaDJBiUETUqAepl6J76EXpcVZcKzO8BCSqDLSNdX?=
 =?us-ascii?Q?cf6hL0YT4eOLy5w8e5oHONlu3lAYKWxh1EnxEw5IDrb553fuxwPepiuiEqmH?=
 =?us-ascii?Q?kWwD+eLb7YPGaMjddVppM87HM3JUDMAjKkLkpkRCgfbDiMyB0xn9/1tg7wdz?=
 =?us-ascii?Q?0poETiy9/ti/eXh91tKJo8U+2TPfZta0vocik5+kHm+wSXN3j4X4QuTO9OXu?=
 =?us-ascii?Q?0TwOp0kVSsPOJWitSyMlWXA4w67H8tXGVvMLBiNSjIezRkdrnTb9yCce0Nsa?=
 =?us-ascii?Q?9mZbj+hqLzlPWqjNMjEAfNUHKa/OBbm42tTdkCpS+dLKihjX6TOJB2l4B/nb?=
 =?us-ascii?Q?Mh5OBh/i2jFQ2VsMBmQ6hjdWw2hTJwjm4nWvJegOorK5GwQ0NDH+MqyijSDL?=
 =?us-ascii?Q?kG52fUx9xmSPX1rG4FQ9SI/maTvWE+UstRy+9aeSpuOSEopWzhQS7JCpEs7W?=
 =?us-ascii?Q?l6waBbqABtCuqcaMg/glVe1KPRLFjfxTy3lfTgd39bDVBvgiOoVJOCJbRrLh?=
 =?us-ascii?Q?Id2xCuvauJ+VXYo/bdycCxl8385KYjgpYgyVxRgfpNUGhv7Wa6VVKzy0bVm+?=
 =?us-ascii?Q?NOjcrEG5k7Q2AioJDkmDgZMPxAkcrZt88vnmoHRlQmD8tq5nvORGtDUhUC9a?=
 =?us-ascii?Q?7fj+ZeHduGP3nZmWHrbQm7CkyyAAPo6NgruKz8K6LTSpDJJjsRosXYg6Ni2z?=
 =?us-ascii?Q?gA7vZyLH+T4TBZ2N+rTbRKpKHF9q0Pa/P3intsC5C2/BDj7UJjGWIT4DYPts?=
 =?us-ascii?Q?B3Er6cuDkPomZOUNMlEFb+wON6hRGHLDRVwGUwx7CRCTZvpPiT48O7/P6t7C?=
 =?us-ascii?Q?jgM2GBhwIdDxDLjX4pkHgzkBINZ/zPljzwVl2HcFk6i5Zprq6jZGGDwsh+T8?=
 =?us-ascii?Q?vc6OVY4nPeyuYe2WDXtlfJ04KzW/SdL2KARxMXvyzu1qmRtTPH3oKPmss2SQ?=
 =?us-ascii?Q?dyIqzouyzIRrDq0syTrCSZLISEQkBny61hEWL07OlfQyl4g9zZslsDaaL2nO?=
 =?us-ascii?Q?uDC6B4syZF3n2YiQNxqIolvtNzAxIeU4xHlK8Ie4/3bmI17EQ4eSfuOqIvtV?=
 =?us-ascii?Q?zy97ydHTsz+1ntU2JbOICywHxYrTZEqhNQ+/bUjLXTgdfTpvFTn/EtYtyQ9z?=
 =?us-ascii?Q?H7rPVZGD5ElHZOjR9V3Bv9s=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7298b76f-6651-4368-73d7-08d99965d801
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 16:21:34.6105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QVn1vtD2M4ea8JHZm6lvfYcGqF9c6KLPNFSqdipfOvRS5LY22mCjh6yXdXIFHBaIt7RrZYw3vB3zEJcJO+1pSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6014
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename all recently imported functions in br_switchdev.c to start with a
br_switchdev_* prefix.

br_fdb_replay_one() -> br_switchdev_fdb_replay_one()
br_fdb_replay() -> br_switchdev_fdb_replay()
br_vlan_replay_one() -> br_switchdev_vlan_replay_one()
br_vlan_replay() -> br_switchdev_vlan_replay()
struct br_mdb_complete_info -> struct br_switchdev_mdb_complete_info
br_mdb_complete() -> br_switchdev_mdb_complete()
br_mdb_switchdev_host_port() -> br_switchdev_host_mdb_one()
br_mdb_switchdev_host() -> br_switchdev_host_mdb()
br_mdb_replay_one() -> br_switchdev_mdb_replay_one()
br_mdb_replay() -> br_switchdev_mdb_replay()
br_mdb_queue_one() -> br_switchdev_mdb_queue_one()

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_switchdev.c | 117 ++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 54 deletions(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index b7645165143c..f8fbaaa7c501 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -281,9 +281,10 @@ static void nbp_switchdev_del(struct net_bridge_port *p)
 	}
 }
 
-static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
-			     const struct net_bridge_fdb_entry *fdb,
-			     unsigned long action, const void *ctx)
+static int
+br_switchdev_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
+			    const struct net_bridge_fdb_entry *fdb,
+			    unsigned long action, const void *ctx)
 {
 	struct switchdev_notifier_fdb_info item;
 	int err;
@@ -294,8 +295,9 @@ static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
 	return notifier_to_errno(err);
 }
 
-static int br_fdb_replay(const struct net_device *br_dev, const void *ctx,
-			 bool adding, struct notifier_block *nb)
+static int
+br_switchdev_fdb_replay(const struct net_device *br_dev, const void *ctx,
+			bool adding, struct notifier_block *nb)
 {
 	struct net_bridge_fdb_entry *fdb;
 	struct net_bridge *br;
@@ -318,7 +320,7 @@ static int br_fdb_replay(const struct net_device *br_dev, const void *ctx,
 	rcu_read_lock();
 
 	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
-		err = br_fdb_replay_one(br, nb, fdb, action, ctx);
+		err = br_switchdev_fdb_replay_one(br, nb, fdb, action, ctx);
 		if (err)
 			break;
 	}
@@ -328,11 +330,12 @@ static int br_fdb_replay(const struct net_device *br_dev, const void *ctx,
 	return err;
 }
 
-static int br_vlan_replay_one(struct notifier_block *nb,
-			      struct net_device *dev,
-			      struct switchdev_obj_port_vlan *vlan,
-			      const void *ctx, unsigned long action,
-			      struct netlink_ext_ack *extack)
+static int
+br_switchdev_vlan_replay_one(struct notifier_block *nb,
+			     struct net_device *dev,
+			     struct switchdev_obj_port_vlan *vlan,
+			     const void *ctx, unsigned long action,
+			     struct netlink_ext_ack *extack)
 {
 	struct switchdev_notifier_port_obj_info obj_info = {
 		.info = {
@@ -348,10 +351,11 @@ static int br_vlan_replay_one(struct notifier_block *nb,
 	return notifier_to_errno(err);
 }
 
-static int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
-			  const void *ctx, bool adding,
-			  struct notifier_block *nb,
-			  struct netlink_ext_ack *extack)
+static int br_switchdev_vlan_replay(struct net_device *br_dev,
+				    struct net_device *dev,
+				    const void *ctx, bool adding,
+				    struct notifier_block *nb,
+				    struct netlink_ext_ack *extack)
 {
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_vlan *v;
@@ -405,7 +409,8 @@ static int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
 		if (!br_vlan_should_use(v))
 			continue;
 
-		err = br_vlan_replay_one(nb, dev, &vlan, ctx, action, extack);
+		err = br_switchdev_vlan_replay_one(nb, dev, &vlan, ctx,
+						   action, extack);
 		if (err)
 			return err;
 	}
@@ -414,14 +419,14 @@ static int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
 }
 
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
-struct br_mdb_complete_info {
+struct br_switchdev_mdb_complete_info {
 	struct net_bridge_port *port;
 	struct br_ip ip;
 };
 
-static void br_mdb_complete(struct net_device *dev, int err, void *priv)
+static void br_switchdev_mdb_complete(struct net_device *dev, int err, void *priv)
 {
-	struct br_mdb_complete_info *data = priv;
+	struct br_switchdev_mdb_complete_info *data = priv;
 	struct net_bridge_port_group __rcu **pp;
 	struct net_bridge_port_group *p;
 	struct net_bridge_mdb_entry *mp;
@@ -462,10 +467,10 @@ static void br_switchdev_mdb_populate(struct switchdev_obj_port_mdb *mdb,
 	mdb->vid = mp->addr.vid;
 }
 
-static void br_mdb_switchdev_host_port(struct net_device *dev,
-				       struct net_device *lower_dev,
-				       struct net_bridge_mdb_entry *mp,
-				       int type)
+static void br_switchdev_host_mdb_one(struct net_device *dev,
+				      struct net_device *lower_dev,
+				      struct net_bridge_mdb_entry *mp,
+				      int type)
 {
 	struct switchdev_obj_port_mdb mdb = {
 		.obj = {
@@ -487,20 +492,21 @@ static void br_mdb_switchdev_host_port(struct net_device *dev,
 	}
 }
 
-static void br_mdb_switchdev_host(struct net_device *dev,
+static void br_switchdev_host_mdb(struct net_device *dev,
 				  struct net_bridge_mdb_entry *mp, int type)
 {
 	struct net_device *lower_dev;
 	struct list_head *iter;
 
 	netdev_for_each_lower_dev(dev, lower_dev, iter)
-		br_mdb_switchdev_host_port(dev, lower_dev, mp, type);
+		br_switchdev_host_mdb_one(dev, lower_dev, mp, type);
 }
 
-static int br_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
-			     const struct switchdev_obj_port_mdb *mdb,
-			     unsigned long action, const void *ctx,
-			     struct netlink_ext_ack *extack)
+static int
+br_switchdev_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
+			    const struct switchdev_obj_port_mdb *mdb,
+			    unsigned long action, const void *ctx,
+			    struct netlink_ext_ack *extack)
 {
 	struct switchdev_notifier_port_obj_info obj_info = {
 		.info = {
@@ -516,10 +522,10 @@ static int br_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
 	return notifier_to_errno(err);
 }
 
-static int br_mdb_queue_one(struct list_head *mdb_list,
-			    enum switchdev_obj_id id,
-			    const struct net_bridge_mdb_entry *mp,
-			    struct net_device *orig_dev)
+static int br_switchdev_mdb_queue_one(struct list_head *mdb_list,
+				      enum switchdev_obj_id id,
+				      const struct net_bridge_mdb_entry *mp,
+				      struct net_device *orig_dev)
 {
 	struct switchdev_obj_port_mdb *mdb;
 
@@ -540,7 +546,7 @@ void br_switchdev_mdb_notify(struct net_device *dev,
 			     struct net_bridge_port_group *pg,
 			     int type)
 {
-	struct br_mdb_complete_info *complete_info;
+	struct br_switchdev_mdb_complete_info *complete_info;
 	struct switchdev_obj_port_mdb mdb = {
 		.obj = {
 			.id = SWITCHDEV_OBJ_ID_PORT_MDB,
@@ -549,7 +555,7 @@ void br_switchdev_mdb_notify(struct net_device *dev,
 	};
 
 	if (!pg)
-		return br_mdb_switchdev_host(dev, mp, type);
+		return br_switchdev_host_mdb(dev, mp, type);
 
 	br_switchdev_mdb_populate(&mdb, mp);
 
@@ -562,7 +568,7 @@ void br_switchdev_mdb_notify(struct net_device *dev,
 		complete_info->port = pg->key.port;
 		complete_info->ip = mp->addr;
 		mdb.obj.complete_priv = complete_info;
-		mdb.obj.complete = br_mdb_complete;
+		mdb.obj.complete = br_switchdev_mdb_complete;
 		if (switchdev_port_obj_add(pg->key.port->dev, &mdb.obj, NULL))
 			kfree(complete_info);
 		break;
@@ -573,10 +579,10 @@ void br_switchdev_mdb_notify(struct net_device *dev,
 }
 #endif
 
-static int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
-			 const void *ctx, bool adding,
-			 struct notifier_block *nb,
-			 struct netlink_ext_ack *extack)
+static int
+br_switchdev_mdb_replay(struct net_device *br_dev, struct net_device *dev,
+			const void *ctx, bool adding, struct notifier_block *nb,
+			struct netlink_ext_ack *extack)
 {
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	const struct net_bridge_mdb_entry *mp;
@@ -614,9 +620,9 @@ static int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
 		const struct net_bridge_port_group *p;
 
 		if (mp->host_joined) {
-			err = br_mdb_queue_one(&mdb_list,
-					       SWITCHDEV_OBJ_ID_HOST_MDB,
-					       mp, br_dev);
+			err = br_switchdev_mdb_queue_one(&mdb_list,
+							 SWITCHDEV_OBJ_ID_HOST_MDB,
+							 mp, br_dev);
 			if (err) {
 				rcu_read_unlock();
 				goto out_free_mdb;
@@ -628,9 +634,9 @@ static int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
 			if (p->key.port->dev != dev)
 				continue;
 
-			err = br_mdb_queue_one(&mdb_list,
-					       SWITCHDEV_OBJ_ID_PORT_MDB,
-					       mp, dev);
+			err = br_switchdev_mdb_queue_one(&mdb_list,
+							 SWITCHDEV_OBJ_ID_PORT_MDB,
+							 mp, dev);
 			if (err) {
 				rcu_read_unlock();
 				goto out_free_mdb;
@@ -646,8 +652,9 @@ static int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
 		action = SWITCHDEV_PORT_OBJ_DEL;
 
 	list_for_each_entry(obj, &mdb_list, list) {
-		err = br_mdb_replay_one(nb, dev, SWITCHDEV_OBJ_PORT_MDB(obj),
-					action, ctx, extack);
+		err = br_switchdev_mdb_replay_one(nb, dev,
+						  SWITCHDEV_OBJ_PORT_MDB(obj),
+						  action, ctx, extack);
 		if (err)
 			goto out_free_mdb;
 	}
@@ -674,15 +681,17 @@ static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
 	struct net_device *dev = p->dev;
 	int err;
 
-	err = br_vlan_replay(br_dev, dev, ctx, true, blocking_nb, extack);
+	err = br_switchdev_vlan_replay(br_dev, dev, ctx, true, blocking_nb,
+				       extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_mdb_replay(br_dev, dev, ctx, true, blocking_nb, extack);
+	err = br_switchdev_mdb_replay(br_dev, dev, ctx, true, blocking_nb,
+				      extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_fdb_replay(br_dev, ctx, true, atomic_nb);
+	err = br_switchdev_fdb_replay(br_dev, ctx, true, atomic_nb);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
@@ -697,11 +706,11 @@ static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
 	struct net_device *br_dev = p->br->dev;
 	struct net_device *dev = p->dev;
 
-	br_vlan_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
+	br_switchdev_vlan_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
 
-	br_mdb_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
+	br_switchdev_mdb_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
 
-	br_fdb_replay(br_dev, ctx, false, atomic_nb);
+	br_switchdev_fdb_replay(br_dev, ctx, false, atomic_nb);
 }
 
 /* Let the bridge know that this port is offloaded, so that it can assign a
-- 
2.25.1

