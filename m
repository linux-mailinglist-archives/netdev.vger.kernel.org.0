Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74DA3BA897
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 13:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhGCMBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 08:01:15 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:47491
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230232AbhGCMBG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 08:01:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKKHAdX5qSR+Cfti61G8iaUXb9bG5kSmtMYwK7Q4zhJpW36fSA6dyQH+nql/QC8Y6GU4Do+wIzxb/GNWuM+DL7jOkV+enmNiYvPtA4mg3cVLsv5bHdJG1+pO1HD7+DX5m1me3Dp9l+acGTKKoaDojAbpsgreD/YOlktkBjRoKXfmX+3b9ieNbzNyklhN6+P49ehcJgOLR9fS+nuMnGbqa1+1zNHNE/MITSjpZaUxdfMMKIqhqRrI+e4URC2hdXYLHcfiraIApqhilT3CsOi9twxPHDq5JSqaDA5d4NZTnzyhTJiqt6DXwKbeOqvBNFMMB42krsVs22BEE0dplbxb4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23nRG5Gwg8ZyF9G2b15V4G3AQDjXOyi4pS+pH4O6H6E=;
 b=dlhcrAkOo4UfH3PnT5NJTGcKFjOO3ig+j7rjvy4f6qdjKx8NSqgcG9lTGRfYabRcAOEB/la8Mj8g7keR6qksR3mn9twk6eQSCTgcfDgx5fSNSek452fERlDfHodWsGVKwYO+mZOW+l4AKHG4OGLOU7dW7mqYrtRRq7ODcb/uJBN3qJUeI67/KYhoGY6JmAKByMmcqvC8P4N2pYNesGpKiw836wIPSLCfvhQUV82SrmVCyeImmY4hQN2py42iepvSY37ZwsQHIAMrKA7nsLucjq1pha88GM0C2cb/D62G5TuisobhlasBY80+J9/WP18UaOryBAMiLESQxlai6fnVaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23nRG5Gwg8ZyF9G2b15V4G3AQDjXOyi4pS+pH4O6H6E=;
 b=DmYtY+M7ZwocFWW/DUxJ2SBfX5CcqwBERzUvGUlAuYSqbR3lSjyAJVyb26bJ3r8a0eYTBC2ktsuDIfoikBzD2bGxWhF1FUeOCVmfOclwqHhmZGGN9TLDzvz2JdVwQMCa6QDVYWiQSTSQx1O0PVa8jNlPtLwO6oniYhfqcWKzElA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Sat, 3 Jul
 2021 11:58:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4287.031; Sat, 3 Jul 2021
 11:58:30 +0000
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
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [RFC PATCH v2 net-next 03/10] net: bridge: switchdev: recycle unused hwdoms
Date:   Sat,  3 Jul 2021 14:56:58 +0300
Message-Id: <20210703115705.1034112-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
References: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.224.68]
X-ClientProxiedBy: PR3P189CA0081.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.224.68) by PR3P189CA0081.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Sat, 3 Jul 2021 11:58:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 790bd6b0-0a43-4201-e9d4-08d93e19e01b
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2509A656FD5E2FBA101556BAE01E9@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n08rB0HripkAh3Kf5EzN344txaHa85WmLevWHsMkX0AHskZOJNssOJuup0bqYUpvnLm8Q7P6JfV5H/wbBOIHmwDAQSpOA7zi2hYQZSEQLbUWcYnJ9OSH8Opp03Cj10be89VU/32px6SeRH63NU7Y12KGrhuJVkor2YUtJwOLJig4398VK+hQJP/0rUxx+ujWSNc1PXGIaBLJk/RtozUawOqSdSSdxylFNA4yX8Y9Jr0f9WfJfUX5MQntNWLqjDUCL9oEOTjhatta9DlkDtEyTT5ft8bXyrET2B8dGHKeMzyM2byyldbTDR4BjeGwMgKu1vOdWHH5n8KuwUHjnvJfvfAuA8AqtGD5pBSN2xy01fzBYb3gl2lGJsvbf4OFx1gmVQhhaw4c9OuIJckmorlwdcY4KNcw+31LBBusFmP/9WuPSvePJq073TfM2lFOCW6ru9w+EeuT7wwYEVLHl7E82lUlMcNAPPyAF8+Crpbkfib04sL0knpgFeX6PIJO1JP4l6ZwqcsmkmSgATP/7qp3uu89pjdHIC3pBJoKvTEW9Jnhx/3zIb4IOixHB4gfW2GNaCluFRbtdTFtu9qkLiHrH1A3GkrEQcYF6Au1mS7oroWt5G4ZIC71wckOUSulDNOG/wzEMWd3imZIvwcDe85Pno8B4/b9TPvi39WM7xDOIEyc5gW7qGO2brOUmZtENyx0wKg5mMr7MXZ8DYtaRNVUTV+nZoP1Q10SJSPhyS9KoNna3pGFXXtdPCLWDRhxX6ZC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39850400004)(6506007)(2906002)(4326008)(36756003)(2616005)(44832011)(956004)(6666004)(478600001)(7416002)(5660300002)(110136005)(66946007)(26005)(52116002)(1076003)(8676002)(8936002)(316002)(54906003)(66476007)(66556008)(6486002)(38100700002)(16526019)(38350700002)(186003)(83380400001)(86362001)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g8scRTQ32Y7plqkznipE2H+PzmYNtMc/8BFW1E7GAgWUoFB2C2Nzl3gYWaZ0?=
 =?us-ascii?Q?/2rTYkG5KC/FC5UUvj30pQENkpv92yuPnSmDO0gxfU2/U07r5Z5igBP8YmiT?=
 =?us-ascii?Q?XB5UPjWq4iBP7ZzX+afzYN3ZTfr9eb6Xrad876t1O2Km3gBlsBkP0RQvCZdl?=
 =?us-ascii?Q?uGTMdqfW8l15GNc+kz8/Z36gxHpPPKrEnfOxqCcVogIIr7734JCm6O7z2Bwx?=
 =?us-ascii?Q?LDRj61tTxIPjCflwmRxHm6Q4ssjLHucRqArDEfmWZ2/Qe1+4Ww/OUkR56cUw?=
 =?us-ascii?Q?U5zSVqwGvu5dkZxFEQaUPLpcfPVyIFYSbDMQYzdmJ/2qJX5d44AfUDyt2Gnd?=
 =?us-ascii?Q?OuV5ttNaZ8zrthDMstBPRXtlApuPYxArb6/TU7soHw1EjVt25lElxNyDFh3P?=
 =?us-ascii?Q?XvWqSdXL/aACPsW3vCBTiu6LyW93qplftO470kBg6WQKPVWEilvF4oseGaMg?=
 =?us-ascii?Q?RrHv/Z2ClxrLNW3A7TEaGmCyNv8z3ZgaLFW0F5FR0allV0ybzzJc5tTSSwkY?=
 =?us-ascii?Q?ArcfidkbRTcfd8JvzbYLHaUZ+gRzSbCWu9awKQBDNUVmzrw+mmTfZOAbbz0v?=
 =?us-ascii?Q?jvo1ZAi9XV3MKIhrPIdVDS6moS7GM3M5h6Tzy9SRoK9C4D6v0UStKqn2z3dl?=
 =?us-ascii?Q?nQ/QartoVEJC57zwu4GRYJ7p3u1p/UezSss+MWf3lme5RHFzLC+4dQJqp24r?=
 =?us-ascii?Q?qDxZmS3ZW7AFwWf75pLwC7Dv7fahEsY2QqNSm0/80fyVNRnKvPQGN7fXkQRv?=
 =?us-ascii?Q?9Pdb/ha6EL5jGPW8fDTdi0s8KLAFIY1QehXROWZyeQa+bupc33ABGe2hrZ+B?=
 =?us-ascii?Q?4pbQSNa9Aoj6ExP6PgWHgQQUi89X48k21/Q+db992wNXQm4U9P/VAPcAvBHX?=
 =?us-ascii?Q?ZnQHd51h/oTb/egfjrcUlN2+7BpawyuOXv2uETwL+tXcyMbtmsxMoGElQw8v?=
 =?us-ascii?Q?lhvf0lMFuaDXQCo+LppuBTI/pLfXexzhQF/rRgyju7YL4g8ACSFUGJB+l0TB?=
 =?us-ascii?Q?g+kf+wvplWXIc8wntvy5EF/pVlco9y5SBU6dbQzMBPmvLJvz+UDK7FORzLvt?=
 =?us-ascii?Q?UIzcBSDLwbd8bVMmWBu9mcacxmLJMKP5h9bqU4kPkHCGO8YVNnimV4L783hD?=
 =?us-ascii?Q?pFM0+UtGhaaCrUcyowv05LYSaJkr8aI0qivIUINtAMhjgggyF8/5WTrs9/AS?=
 =?us-ascii?Q?J35lhMqauOSYFMEP3wr79CO+3GAzsdy+/Mq8n1vt1uAOwzjrlADFEz9BiSLX?=
 =?us-ascii?Q?iiy/Ir9sbk7hCVgDrySqV6Xa7Oovs1nm4MG8OdCObe/nlpvkco8Otyo0J8wo?=
 =?us-ascii?Q?cLmCsMRmuV7ecH2Juz5eKpqH?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 790bd6b0-0a43-4201-e9d4-08d93e19e01b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2021 11:58:30.6614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8z3ZtuOH5SfhweurBe7ZcSdETxDILZe3EtJTFoPiZrQL4almii6OYeIJddwU44P3QqZpTRhpN/sCTBGLpW7sZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
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
 3 files changed, 85 insertions(+), 40 deletions(-)

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
index e16879caaaf3..9ff09a32e3f8 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -29,6 +29,8 @@
 
 #define BR_MULTICAST_DEFAULT_HASH_MAX 4096
 
+#define BR_HWDOM_MAX BITS_PER_LONG
+
 #define BR_VERSION	"2.3"
 
 /* Control of forwarding link local multicast */
@@ -476,7 +478,7 @@ struct net_bridge {
 	u32				auto_cnt;
 
 #ifdef CONFIG_NET_SWITCHDEV
-	int last_hwdom;
+	unsigned long			busy_hwdoms;
 #endif
 	struct hlist_head		fdb_list;
 
@@ -1645,7 +1647,6 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 
 /* br_switchdev.c */
 #ifdef CONFIG_NET_SWITCHDEV
-int nbp_switchdev_hwdom_set(struct net_bridge_port *p);
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb);
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
@@ -1659,17 +1660,15 @@ void br_switchdev_fdb_notify(struct net_bridge *br,
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
@@ -1710,6 +1709,20 @@ br_switchdev_fdb_notify(struct net_bridge *br,
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

