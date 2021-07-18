Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452823CCB24
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbhGRVtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:49:35 -0400
Received: from mail-eopbgr140071.outbound.protection.outlook.com ([40.107.14.71]:24552
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233391AbhGRVtW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 17:49:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wc4mGUiNrYW3OchD9oNydIi477zJyPCv8LEQCd7Rezzie6iygWP8smc2M7F8+TfFw+s0mR7TpYF2P1DZR8vpSmZwPjNb9Q4UpIcURoQWDr9NFidVQ+DJxEtrJNrCPdRKL0sxEJcT0OPBcQ4uEWy3LGsNgbUecngCECVfR9RkAuNfGJUKkF1EUi0m/VwJ+JKGgN+SXT1ocQyctLCWM5cjvm/3zRFXpSTKrHmXhe1vsTLACB8m8IE7duqmY2SsUR2QLuylPUh54Jn/+LHiqm/HK/8VlAuEvvJ18Jsmuvv9AmHn9BehPPKWLAjbgnThj/2C8VguspGAgZOtF8FSm/iA/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZjb3r/46jgpGPCgW2Nfh5oISY9zHOJJBz/anbIcATc=;
 b=L8DYv/ZMC81QboDn8mHK4kseeKC54ZxmFESqVVc75cRUISbeIKs1JleO0MK1Y1foRKiSItZKi0EhjX1Dng+dmnCg0C344daHQLXoT2j2kHRPGNl+MraqaMZbMiTOPUWIfv5ZQGWYfnQ8Uk7Dd2Uv9NqFtq6igI8dAqDbgRtc3xluYbMf3tXod7td0ThJ0znztwpvsE/t5r31a3Iz/8zmxcTaCh3hUH5pjUc4+OTujQnC016nToBwkNgiGkwxac76YJ4JRzG4yhB43U3gVDlIPpmYhI89X2qA+uRX0Cdc4oYvFKtGtjev4gydDCBtf+s1fD2Dxs7t0Id1yz1aCRWIvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZjb3r/46jgpGPCgW2Nfh5oISY9zHOJJBz/anbIcATc=;
 b=XspJmYycAzJcGUUyeu0MCaKrHkVtiVPQkII7G/z33/KW98MMuYQYlWkEOjGGsCvOHpWWZYCKwyXprP4kTUHOjl8nVV2FQEbiRQBbN23aabLpkaAPOTWSmIB5Eci7o5mNNwJN621zKMYyVPubTgllQCJF5HaDRfv8dhkeisKtgFY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7325.eurprd04.prod.outlook.com (2603:10a6:800:1af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Sun, 18 Jul
 2021 21:46:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Sun, 18 Jul 2021
 21:46:16 +0000
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
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v4 net-next 08/15] net: bridge: switchdev: recycle unused hwdoms
Date:   Mon, 19 Jul 2021 00:44:27 +0300
Message-Id: <20210718214434.3938850-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0014.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by VI1PR0602CA0014.eurprd06.prod.outlook.com (2603:10a6:800:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Sun, 18 Jul 2021 21:46:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef250610-11a8-4d09-8a04-08d94a357860
X-MS-TrafficTypeDiagnostic: VE1PR04MB7325:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7325D8A9A6EE64643C9AE79EE0E09@VE1PR04MB7325.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k7Nu77USJpttHpK3/WqNnNzi/+RFlKAMRB8Sp/6JxLLzpHfrRt8pSQjkhsXgKxqJ4wEMk+Aj+RVcdTrW+fizqyT0XVZW7mkI6EkeGdotpDbsN7AkvTRgioTZX52W3AlKhz/6MAMOoie0v5cRlU2pa+muCGLHRzpBsR79Jrmo9C1ByWdWggKD0evAoT4/ctELB3MAXektRG6KT89atMz2OFiFPU9XM90GQoEfONOy2e87oxsuTlqMh1MYPv31MuZ/IQYjLCU/08CVsRTAuhPz9LnJsWOqWc2UfEJxMqwVKksE+etPlSAq4TXAYva3/OPi/1+mCoM0WhLYjQLNGa1A6+ns0Um03Ua9Phn4bN8AT5ZDe/bJPYfx3/H6o7C5h82/DHKy9gtEX+96nRCj3Vv/aeKWpvf4n1JtMhXSJ6E70V7B1ETj0h5wAxh6W0xKJ0pLsl2l2dIsXBvJUUQNUEaIKhV82HcNzDU8HPDnuCoWmYvmI3uZ517JC5Qv5fpYhwGdmxF5of8yYJdkmQ6ICCg3KBoz4Hd+rf60y9WiBy/9au0z0jkZewF8K5Bi0J4Pb8y0DuMO6m6asTzF9oJfUHAH2TMN/f8cc8OAlBBZMTU/dMksaDqpdHXa+TYNgx5pWP6WOg6vGq3GNZ4qrMM48OzSpy9Gesv/1HNsxXU23mlA5XKVEAWfpfNV3SRK6yPVvjli3eY1gmtrdx+aCmaZ3V9pPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(39850400004)(346002)(6666004)(110136005)(8936002)(6506007)(8676002)(86362001)(54906003)(186003)(26005)(66946007)(66556008)(83380400001)(66476007)(52116002)(2906002)(1076003)(316002)(7416002)(5660300002)(478600001)(36756003)(6512007)(6486002)(44832011)(4326008)(956004)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0ltuMPKN+zpmid6QXdA57addUd7qLfKjEzexYPGG76Xnu//WlkUZs4rg1Z5H?=
 =?us-ascii?Q?DNJPbSi19MDRTVTisBCnsuEQhOUatCwz9UyemgeJCINtp350jW4sMgq/MbWW?=
 =?us-ascii?Q?5e92+tQQsWc98ppGy5ToPCGYAMRYJZUaD0WawoThql/jk6P8Nriwe435KVi3?=
 =?us-ascii?Q?3K021eLZfS3WQQI8/YcD7guV6KbQx0yHC6Db0T2owmiOH7fqRWT1gliQIk6N?=
 =?us-ascii?Q?NDOM45XbuCQ/dQ6ATZ674QZCeEtZ5BCkvt+fsrHg5uzP0xcwShQzEx3mBOM8?=
 =?us-ascii?Q?CSpqeCWGNCiK526NHaXXQcz4CmFI1UA2w2SdnTEIGNt6aar6isoj4QU51Bx4?=
 =?us-ascii?Q?QWzWkIxMQCN9BFsBya/XgZbZq0zhyjOiZ1IZHvOzKmeS+VDbjCe17p5e6HmR?=
 =?us-ascii?Q?kMjD9v3MPYbvZjtS3EYiGzSOKJXtgkzRwU/iOT9bXlMw5Iv4hTK8FPH4mXlz?=
 =?us-ascii?Q?hSAIVISaELTKE48KojIOnfT1z7eVnoJajeevIryZrHisWeRYRXfWIPa0s9LK?=
 =?us-ascii?Q?6lNMeeHDJchOY5VRJEl2ZLqYaSLfl3jFXhTs5G7k+/vJYe5MsS1+2/nPKL8O?=
 =?us-ascii?Q?oxfJVTPmGt0uDl4OAKimTDw13C1CAxIX4dDD4virxzh7d8F3BcIlaNAvbwmT?=
 =?us-ascii?Q?8h+ZqHzHwG4ephWoGaqXfoMbJ/AmRLlqqOn96TvhYmQ9eEndFiFdb3joMwwG?=
 =?us-ascii?Q?ecJkchB1gMD6Xx4En5o/6XTXLwxO3C3xvcG1PX/H8ULE09HqjBBzp9Yuz1Yy?=
 =?us-ascii?Q?NDHSpGXU6gMWewLQ8mOFtXds2yorsImM7L7hwq87YTplWZeW30pWWRs/Sqs9?=
 =?us-ascii?Q?3aBF3jhKMP1d2tavPovF8WT4PwzPCcZ7lFlQW944tNENZMRM0BNZNbiRRhPS?=
 =?us-ascii?Q?9ozUOTG97JNQ2lZaoqusFK/8R8MIPCKWFnmaTKvi+HY2tH0jq4AnfbAemHkr?=
 =?us-ascii?Q?ujXKK3Dg4QGZit5pIJ9WTrHgYnJGM/7YWcWPyz7MQCH/AGbggi4WxPbEuh72?=
 =?us-ascii?Q?nWXKbJT+H+VqXpLIJPw4+UwwDUNQHF/dZ00Wz+x0m9xvSNt1YgTpGGEY+4Jk?=
 =?us-ascii?Q?FDdw8qn2kK6wkr1q9ujiYbbBMV8Ntu9DXIfB4+VSnFMaVWi9Zg5p5hRpT32R?=
 =?us-ascii?Q?bj+pknqzLIHb2hPdwNsb8mRDEeJ9Ck2aoLY39OT8yb+Ih5cpmQx1P8xL8l2+?=
 =?us-ascii?Q?8nMwMiD/mWLMF6v7Fj1dUHul3jhqWWGlEyPEb21ibA/YEv2EfS6SYvKEolPm?=
 =?us-ascii?Q?tfJiM7KJzoStYeLwft5HG0mzdlDpx8vzeBSMtC/YUUePS3giRTlXbtDK4tcC?=
 =?us-ascii?Q?tTeH1H76mJi34fZkiGxSJnXa?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef250610-11a8-4d09-8a04-08d94a357860
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2021 21:46:16.4209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1CC6dBeDjdHT0dX4T5i+p48zYJa96Ek76ig97AtMJF6kxOZ1B266U/MgZCIcLUQA39S0ijYoAGBmYzM9l8Xv+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7325
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
v2->v4: none

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_if.c        |  4 +-
 net/bridge/br_private.h   | 27 ++++++++---
 net/bridge/br_switchdev.c | 94 ++++++++++++++++++++++++++-------------
 3 files changed, 86 insertions(+), 39 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 838a277e3cf7..c0df50e4abbb 100644
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
 
@@ -719,6 +720,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
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

