Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0784E3C5F10
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbhGLPZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:12 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:46304
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232203AbhGLPZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjHnkL545LaxTq7QAzVSlZUrYZGGXlhVqDIfrHaThqeHfCGLW3IkUJ7c3D+9TCZLIapHwKRE7ie0Oz8OExFmoNwtZDFkbyv5hGeTqmlRp3SHStATCo/bfJxRl/zaKLvW22n33UtnX0IX67A1KlJ3QxZ6Pl6ArTLnUFyU419SpnTmUL6Vf92wpwCOsyV0bjM99abFJZ+Exl/lZ5yCXNOABx69WZRdz2Kle5nfED7dsHwb89h/KtW+MgC5C6z4+mrzyNQOiaSwW+hjkH+CP1aW7XDSSH3A8mVmwRkZdsQMbz1bt2qM+RRuEWNcBqvTGIh6faUwDtA14hkESo4e/LVEFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AEgvkFxIKhFi4/Lc1IhTUlb99C35DWTo4eSdHg+w4q8=;
 b=OMPtMmAtvDXUcTiNm6ZY5GolxaHIMqy/yWI5jXicij00G3Y3F6h+5+Jp27uWszH/R/KfFKOZW6G6sV3eQGkU/up48l55oQq4y2fV1x6hnuRw+DJotJgwVCZ5xwiLIy70rlktaJMFBez1nH1ak6B4cqAC278djyfsXdpLLWEXxE4R+X+mQap/TSg+jO53j3y34Gx4ozcwrK14J5HfYb5eKvuAfNEuMmntsGjIWkL0syCwOYvWYP0QKZDjMIZWZqGDa/LZ0HglJvxl+vcnaZ2zsWcIcncxeVVIl//P367Ia3lZKsEDrls6IxbdBiTZS3iEn5vBWWd+Oce8Xi0Bywfd9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AEgvkFxIKhFi4/Lc1IhTUlb99C35DWTo4eSdHg+w4q8=;
 b=b4+5vlJ3XZd8Pi+jDiTfMcs5R7BxgDmpJljw1382qZ9NES6QlLhHbeWA4z3Nu5CIC0BJM2g1Q+2N8VwrnOmGTU2GpJ3DEEh9S6iTYar4iJUByT0vQlHJfBL3OrtMKDbwK4LJNO9vbto2ZybsLnEMQKDyw05EYM25Q/cUZyxP8V4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:17 +0000
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
Subject: [RFC PATCH v3 net-next 08/24] net: bridge: switchdev: recycle unused hwdoms
Date:   Mon, 12 Jul 2021 18:21:26 +0300
Message-Id: <20210712152142.800651-9-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a0e6e0e-d807-4115-b834-08d94548d5d2
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6271EEC93549ED8B4C110424E0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kcTxdLai+gKJb8wGgqtdrzOwVcJmDajX+BgPscgLTVTnfOxpPew2Xy9KrqtgP7aL3ws+KImPZeubRDNfdn5wnScqKFYX//egNTRndRqRT0VBE3RTouSwZxiUvCCYBAecXbNFUfM5S3yidKJnbqW6kaMdF4TO8+jA2td60uQHZjFFVYKltF1o5mEbDY5pTa7WiKemCh465+51FGRslg570AcCqZgmPkfUYxmjP4DtHzFmYO+yrGPuOIBpWadfAiMlvPg+bfvg9Y8vgsvvrH5kL/lpriAC5R6fS1dfgJeny2gzjO3US9au3U3FrvHUE804FoZdNU57eqIVA69/xY/9c47y3BuYou+fGJv8t3HCjikREXbGKLFMNjVvWgBbv8rimiN2sYSb1Zj+/7gbwe+oSBrQe52TVdtfSQX0Ca3lO45nppudB8jlRbsdGvo6n4QTAh6gOYgjtKYki31d+Cb6Nn5PqLKFRPG2aorNhL8ox3z9lzSSiZI0jgtqX4ar7M71emyiIuQAPFp8GZo+mIpi7knv/exOx8LmZN6xtaml/t1QkyZWlKnkiIM4dV/NLMmwDxRLDU0PnyHm3SV4GTa5+fCHiFtaJUxE/JU4aKyRHVk3urnV/3CtXyi+ebCXX8VKCNYRPW19W9oD+4UndzKQrIU36LPprvSIXdslhGw8UsN8oOuBZHRwwrlfw0F/+FPiZ2pYJ5mWIsYSwogQGi/eYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(6666004)(83380400001)(66556008)(38100700002)(8676002)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cVCDgEGuOJSlnG1tkPli3ueoAs5lBhVZE5T+fRnB//QOO/LdykwStqYgS4ZX?=
 =?us-ascii?Q?A+r7+UeTctojDP+U1swGzPa6AhHhMxlqAdk1JxlAzQRbBkD2BFyWEpC6tyPk?=
 =?us-ascii?Q?EA756xqivMLztDxDwyU1oqobWGR79/LTLH6ixrNf9/1SZapSfqkqOeMX1xHv?=
 =?us-ascii?Q?M8wsSOfBNxg8emmi2CfMklwXNXqZZbc7CpxtBz0czT5UM62xfiYrBCqQN+5x?=
 =?us-ascii?Q?rqxir90PZPwM6osufLmS47ZqeX6YVAZcZN/hJk3lU7owTcfAWkoo1CP0yAhm?=
 =?us-ascii?Q?yAW5Oi1DS5ErsY21y5yMjGcU2DcWlixMjSriHKFGPRm7MMX+ctEq9OoPbhD8?=
 =?us-ascii?Q?SFRY/moa5ygtG4rOrh0Z1ohP3A977kA0QBoe7fw7mMvJxbzWMtp3nWzc4kEF?=
 =?us-ascii?Q?wm5rq5u8OwTVJo9BugT1kK+dVIhYcUZAz3dCdSD0F+EAxYxc51CbiuQLkjnK?=
 =?us-ascii?Q?J3ZAvMc61SdlZ4Zq51LRcyawE62+JkRcv+QcBtFKs1rHr8mkMyXKvo7dHdDp?=
 =?us-ascii?Q?6iv5VEBlQ6KJu2EPKachvEmcJP14GNkmdRdAOHWptLlcTLiMpeFOAtbSIMbv?=
 =?us-ascii?Q?0qwzwVFHr6ve9bVAGBdryvk/pKaOa7eanbsSJgVa0r0hJSpSlPks1w75tuC/?=
 =?us-ascii?Q?7W6qffvzBI5bQdpAZxcQpR8d2ayOW3x8oP+emYcMXdJghTFAE4Z901XVTKqX?=
 =?us-ascii?Q?qLwWDOtxR5OINHOYUKo99wBuwIq5WTbOH6yzEICZAz7fljYpOFjvy7f0XoeA?=
 =?us-ascii?Q?MPZ8s/nYIQBovXq9kSBqaL1dwQxdABZslgzQYLr6SoKk5zPF+tzbOM2Ob1ED?=
 =?us-ascii?Q?kKsymvppn4wPB5rZA39BjBHRhRRKFrbbFwk6+3poewXnqq02+GtcNOqlHcQQ?=
 =?us-ascii?Q?FVB70vxp9D1ynCgQxRy0fBm1bxbVunpms6GG+a2t5TAt0g9LCHRvXSCSny5M?=
 =?us-ascii?Q?6qfbE49soSPoJZusk/+ekOQ5DQWk5/FPolbi7tqjgXPefIRuA2LbJmJHw4ml?=
 =?us-ascii?Q?hNcfetD6MMtr7ayUGFdWHHryWmTbWDEeOU6iON6Un1aWj0kqt5/3oDjRwnSg?=
 =?us-ascii?Q?oJRgkuFQMFfC9rgPfghoH2TEmLrsbXOpIhFlFCQk4T7ED0ofYgBGnR97rdy8?=
 =?us-ascii?Q?/jb8DTgms7fKeDnpgLkmUxD0fWiwcg3wqyuHNVPZ+RxPnjAsGauKuArDeemG?=
 =?us-ascii?Q?UkqtLU4r7DIVSCEJAIM+U7hvgfrnISACDYD1X6DwFRkt0c4q242Mth84R/rh?=
 =?us-ascii?Q?51qH77I4+zyh2Kp/CPWXjkv3CmaNJY3EyDK+aP54hVzjCoHw8kG5YUAAruFo?=
 =?us-ascii?Q?9j0fl3p9OHKOPttEvekRgSMD?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a0e6e0e-d807-4115-b834-08d94548d5d2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:17.8533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JP8tvCbNM5c6sLKr4JjtrK2O96xImNQdXUCGeNke/HFMuqKUw8m/NtZNwlCgR4cdAlxvlU+TnX7zlj+CTJY/3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Since hwdoms have only been used thus far for equality comparisons, the
bridge has used the simplest possible assignment policy; using a
counter to keep track of the last value handed out.

With the upcoming transmit offloading, we need to perform set
operations efficiently based on hwdoms, e.g. we want to answer
questions like "has this skb been forwarded to any port within this
hwdom?"

Move to a bitmap-based allocation scheme that recycles hwdoms once all
members leaves the bridge. This means that we can use a single
unsigned long to keep track of the hwdoms that have received an skb.

v1->v2: convert the typedef DECLARE_BITMAP(br_hwdom_map_t, BR_HWDOM_MAX)
        into a plain unsigned long.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_if.c        |  4 +-
 net/bridge/br_private.h   | 27 ++++++++---
 net/bridge/br_switchdev.c | 94 ++++++++++++++++++++++++++-------------
 3 files changed, 86 insertions(+), 39 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 73fa703f8df5..adaf78e45c23 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -349,6 +349,7 @@ static void del_nbp(struct net_bridge_port *p)
 	nbp_backup_clear(p);
 
 	nbp_update_port_count(br);
+	nbp_switchdev_del(p);
 
 	netdev_upper_dev_unlink(dev, br->dev);
 
@@ -643,7 +644,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	if (err)
 		goto err5;
 
-	err = nbp_switchdev_hwdom_set(p);
+	err = nbp_switchdev_add(p);
 	if (err)
 		goto err6;
 
@@ -704,6 +705,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	list_del_rcu(&p->list);
 	br_fdb_delete_by_port(br, p, 0, 1);
 	nbp_update_port_count(br);
+	nbp_switchdev_del(p);
 err6:
 	netdev_upper_dev_unlink(dev, br->dev);
 err5:
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 54e29a8576a1..a23c565b8970 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -29,6 +29,8 @@
 
 #define BR_MULTICAST_DEFAULT_HASH_MAX 4096
 
+#define BR_HWDOM_MAX BITS_PER_LONG
+
 #define BR_VERSION	"2.3"
 
 /* Control of forwarding link local multicast */
@@ -483,6 +485,8 @@ struct net_bridge {
 	 * identifiers in case a bridge spans multiple switchdev instances.
 	 */
 	int				last_hwdom;
+	/* Bit mask of hardware domain numbers in use */
+	unsigned long			busy_hwdoms;
 #endif
 	struct hlist_head		fdb_list;
 
@@ -1656,7 +1660,6 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 
 /* br_switchdev.c */
 #ifdef CONFIG_NET_SWITCHDEV
-int nbp_switchdev_hwdom_set(struct net_bridge_port *p);
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb);
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
@@ -1670,17 +1673,15 @@ void br_switchdev_fdb_notify(struct net_bridge *br,
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 			       struct netlink_ext_ack *extack);
 int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
+int nbp_switchdev_add(struct net_bridge_port *p);
+void nbp_switchdev_del(struct net_bridge_port *p);
+void br_switchdev_init(struct net_bridge *br);
 
 static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 {
 	skb->offload_fwd_mark = 0;
 }
 #else
-static inline int nbp_switchdev_hwdom_set(struct net_bridge_port *p)
-{
-	return 0;
-}
-
 static inline void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 					    struct sk_buff *skb)
 {
@@ -1721,6 +1722,20 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 {
 }
+
+static inline int nbp_switchdev_add(struct net_bridge_port *p)
+{
+	return 0;
+}
+
+static inline void nbp_switchdev_del(struct net_bridge_port *p)
+{
+}
+
+static inline void br_switchdev_init(struct net_bridge *br)
+{
+}
+
 #endif /* CONFIG_NET_SWITCHDEV */
 
 /* br_arp_nd_proxy.c */
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 833fd30482c2..f3120f13c293 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -8,38 +8,6 @@
 
 #include "br_private.h"
 
-static int br_switchdev_hwdom_get(struct net_bridge *br, struct net_device *dev)
-{
-	struct net_bridge_port *p;
-
-	/* dev is yet to be added to the port list. */
-	list_for_each_entry(p, &br->port_list, list) {
-		if (netdev_port_same_parent_id(dev, p->dev))
-			return p->hwdom;
-	}
-
-	return ++br->last_hwdom;
-}
-
-int nbp_switchdev_hwdom_set(struct net_bridge_port *p)
-{
-	struct netdev_phys_item_id ppid = { };
-	int err;
-
-	ASSERT_RTNL();
-
-	err = dev_get_port_parent_id(p->dev, &ppid, true);
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			return 0;
-		return err;
-	}
-
-	p->hwdom = br_switchdev_hwdom_get(p->br, p->dev);
-
-	return 0;
-}
-
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb)
 {
@@ -156,3 +124,65 @@ int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
 
 	return switchdev_port_obj_del(dev, &v.obj);
 }
+
+static int nbp_switchdev_hwdom_set(struct net_bridge_port *joining)
+{
+	struct net_bridge *br = joining->br;
+	struct net_bridge_port *p;
+	int hwdom;
+
+	/* joining is yet to be added to the port list. */
+	list_for_each_entry(p, &br->port_list, list) {
+		if (netdev_port_same_parent_id(joining->dev, p->dev)) {
+			joining->hwdom = p->hwdom;
+			return 0;
+		}
+	}
+
+	hwdom = find_next_zero_bit(&br->busy_hwdoms, BR_HWDOM_MAX, 1);
+	if (hwdom >= BR_HWDOM_MAX)
+		return -EBUSY;
+
+	set_bit(hwdom, &br->busy_hwdoms);
+	joining->hwdom = hwdom;
+	return 0;
+}
+
+static void nbp_switchdev_hwdom_put(struct net_bridge_port *leaving)
+{
+	struct net_bridge *br = leaving->br;
+	struct net_bridge_port *p;
+
+	/* leaving is no longer in the port list. */
+	list_for_each_entry(p, &br->port_list, list) {
+		if (p->hwdom == leaving->hwdom)
+			return;
+	}
+
+	clear_bit(leaving->hwdom, &br->busy_hwdoms);
+}
+
+int nbp_switchdev_add(struct net_bridge_port *p)
+{
+	struct netdev_phys_item_id ppid = { };
+	int err;
+
+	ASSERT_RTNL();
+
+	err = dev_get_port_parent_id(p->dev, &ppid, true);
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			return 0;
+		return err;
+	}
+
+	return nbp_switchdev_hwdom_set(p);
+}
+
+void nbp_switchdev_del(struct net_bridge_port *p)
+{
+	ASSERT_RTNL();
+
+	if (p->hwdom)
+		nbp_switchdev_hwdom_put(p);
+}
-- 
2.25.1

