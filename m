Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097DF3C5F31
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235632AbhGLPZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:55 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:46304
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235514AbhGLPZi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CpI3R5VnU4XIxozFEs2HP5/hLpSlAAJvgHapAfiw7RMXciFKmaKJuGB3raMnNsvQ51yq0TXauofcLLx7ZwsQ+yLgleZvFCvLL7kvcPvsot7ZUpfTixjrkTInRRM2ZmAY2Pl7Fu/P522aQ6VyW1TA6gimPk3D52RcqTFZl+Kf1oC9ZS2V4yLjGzXUgnwKnrrI3sBKKiWN7oglNv4L+UbELbgJyHmqsHN9eO0EZQ5xmo0F1DAe2Nmog4YvOeDzh5tACC3EJjGrxzgUt9URacITBn7WnHvOrR3pb63QAwr06pwoWHnsqBN73TQtpCIcs8lNnHstLLiJpKyfxuhYRy/+4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+KVIVbzF/qsJO5Fqwixkq4iaulIzPKoUTb3Hy7E3rE=;
 b=WaTK7WuVW3qRZSkGlB6LIuLKLL+bJAUQHE9fzuSZdltaJ4L4gatEpMXAnTX52Pcn1Ty6o3QdVTXcGv/QD9xIqgYRBabkkdOf7NSoTJNdtiBg8PvUgcy8Ul/ReXNy5FfVKPGVHZOnUAAcu0Np7bolUF5jD2k7U3628hSFMMKur23SUR1fQbZvM3iAdPAfdZuF97fNgZvQyFdG0js3C62GhIOoHUAZyIQ8ZfdhKhY/L8jvMu0k7jkJtM9N/6aYL2fihDyg04sMF2I6B6TvgSMkS+zurcGOm6GAKaMOtGLPBQKSwWTUrY+5Oan+KXlLrxubgSX4s05xKzmfgf4y6GgRVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+KVIVbzF/qsJO5Fqwixkq4iaulIzPKoUTb3Hy7E3rE=;
 b=rxxjx85DkbYYDMKFiqHMiAgYud85HrCaV5qVRJT1iSXl4LhIsXr2+RYKBk/j49gEYPA21Y4LWx1IpV5472323pd9xz7GieJJTxFOOt9luXyFNSsZQrYecGZQLvcgpAhE0THvGd/3KGr/guQo0zbUgPkUjVXMsgBLo1EMBsUfvZ8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:38 +0000
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
Subject: [RFC PATCH v3 net-next 22/24] net: dsa: add support for bridge TX forwarding offload
Date:   Mon, 12 Jul 2021 18:21:40 +0300
Message-Id: <20210712152142.800651-23-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd9a0eda-1a4c-4201-bf5f-08d94548e1e5
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB62719B9949A68886B4914E46E0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FkRnMQMEl+sw5Wfg51onHJixVfuOwOyxnr5FbqqviCW6y6DKflFETRn6Xnh1LXxk6uGtMS/riD0FE0GB+cenFM8UBp5U7ZtBNPvoIYeObpl8edb/yaa+mz8g5pS26MpyMzYHTFJqzREKsRyuYH5RZAQlRK1ky22+dsT5RyVfCFRwUG5uTuxl6w9gnxU+wjOlXpJowtcAZFPu16Y09U/knX3wr83gQxPP8kVrPsjXJ4ElIkNQmjjWfsCBOjCUbH2XIgw7SjX891d/fIQMGXLhBunCy210PllLtoCeQxbjSLzacGK8WqtW0cXJAAd0H7HX4XKx2fg+O2XO7kcCfzEz4k2uuJMzCYFLpnnJE9f52ALPdtwHinpFrsPCA5eFO2J1Va6Esw36yLPBkg3O+Gu4UM4qzmVqLfipf/oVlcciLaHQWZYgtSfb8PNYDPk/HkoMeFOUcT6F1rpYCHT/TRaf7Fa4AKdJ9LDJb7eboTqcq8aQ+2UZSvUE9MHaf3BdiN8Tg6V+cMispmT2l/C3TOrV1HZXIcIfPyzxkfxgpU5oJxW+1gIwoimU41EmsxX2a38ANzMJjgXfKmkJ6S8GUI4sZG1WjLaaALUtHmBWmqnoIUM75ra5dUQKKJcVQFDd1IiaoVS0r76Zy6mFEsJ7Cck+zN+ICbyOwdnr8VI27l3jOcO4lXD6+jUOaqO/ikZ2MCWY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(6666004)(83380400001)(66556008)(38100700002)(8676002)(30864003)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qMn+upSYZ+I/iV/Y8lMMgles+x4ItzTt99qyUDfjha3dvoVG73voyaZNCgS7?=
 =?us-ascii?Q?cbWFrwb85h9G+Lw9bpkPPOYtduxyOstnDECcEJPUXROJ2tOD/7ZjWAqIuke2?=
 =?us-ascii?Q?mXMhr+J2uDfxwdq8PLRfBthv1ey5eHDpHhO2aWPjksnti9fr9iPyfjEGUjl5?=
 =?us-ascii?Q?wjvVNZgNxII5wtqJhJpbH02ZJ92z1lj8TMLa1Q25ijlLgQR5RysCXlJarmq3?=
 =?us-ascii?Q?kj1Gmg1k9ESFvEgXL0eoI2qvLqv053RJux0iIZKWYm/Dt+9qJUlwLEs3/G0a?=
 =?us-ascii?Q?tRNjv2fDXh3sUqp4uHbqDQBLdL88n2ZlOp/R75qzLv2UKeCNuwULNqkYDPW9?=
 =?us-ascii?Q?ZvS5FjXPCfsL88lXOjQmzwY7Sa58kuGDhGwUraN4GiqJU8OKDBHT9JpAp6P9?=
 =?us-ascii?Q?gBLu6sER3hSeOAU70a9lkoIiUQdQbKzX0x1uanrKnK+CvLq73otHA41KSqif?=
 =?us-ascii?Q?RkdoUi8kzLJgGV4ldIBTWn6Kj5pmJTlDpixnMcP6HImFDHvbSWqa6l4tkv49?=
 =?us-ascii?Q?XLxKR5P1tz3byeG8b3ky37bRe4tHHP/hQeIdWGZpMkObl1FOA4hZOmSX6ES1?=
 =?us-ascii?Q?Li0O86ZRyvFx1YYpi7zMNyX/RSFwPrfKH2PN75lsqH16dXamdQ5DN8HX8ZWz?=
 =?us-ascii?Q?cF8YF9w7DwU49Nhvk5/VQ4pnnanjwtH4fgk4hQV3W9KD8diZB0T3IzZuBlPX?=
 =?us-ascii?Q?IaO09Uqgh2+as5om3Fk1vcUAlWbSAk6kCc7wExLteSxOECwS+cK6i+1nEr1i?=
 =?us-ascii?Q?evReNLSa/xMBqoa/LBhnXJEK4cnxwyHazNQWYNL916JrxEZ4P2ej+HGTnzl4?=
 =?us-ascii?Q?SVguHOHzNWzAV6SH2cLNnrOZ0QtiJqpQuF1sO9TsuJFvgqQBfLxOQiW8GXzd?=
 =?us-ascii?Q?z8Bp7JL5RU7UrOewkW4HZw7MFDXDe7F3qdahuZty+Hlg1MovNF/E79kPBmK8?=
 =?us-ascii?Q?xSFoH0YNNa1D24zv2Pfk4b0yPCPymm9iDK+a8WF2AIE9h7A6l8saXgGNI9Lr?=
 =?us-ascii?Q?xPwl5XTHcHZJCPgVDH2Vfe9Wty+MztbVQ9GQeNGx4YIXKZIkbBwaRCVcqlL6?=
 =?us-ascii?Q?YMArLx/LmfnyLdgWcJmWcRXNYIKcSVoNs5J31reDT4Bx1BL5GPBI55jfaZJo?=
 =?us-ascii?Q?2HPBnzVNXWr+BnuFy4oXYf3LnC7LITNAb8mx7vnkwaZRfLK6/m8XYekTRAIi?=
 =?us-ascii?Q?5JMwq/UB/Ui1eDjDzN3gAh+uzERGS7E8y2245g9YqbR1LX2B8aK2PlyP84hA?=
 =?us-ascii?Q?XeoPlmBhy0Iio0TBc6L7EFLqMMT5FOUAd9gpIv2WW9zYBWDAHNqR3Io88+3m?=
 =?us-ascii?Q?YDiYn898AcLBnbXi63yMz3Mf?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd9a0eda-1a4c-4201-bf5f-08d94548e1e5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:38.1586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: efxtqv3q11+T6cB90Dt0sOSY9HWyyAqT/1RKYWHf8U2fdr/MtmGD18njbsuUsy2apzZZMYa+7PdNsvrBXUVLrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For a DSA switch, to offload the forwarding process of a bridge device
means to send the packets coming from the software bridge as data plane
packets. This is contrary to everything that DSA has done so far,
because the current taggers only know to send control packets (ones that
target a specific destination port), whereas data plane packets are
supposed to be forwarded according to the FDB lookup, much like packets
ingressing on any regular ingress port. If the FDB lookup process
returns multiple destination ports (flooding, multicast), then
replication is also handled by the switch hardware - the bridge only
sends a single packet and avoids the skb_clone().

DSA plays a substantial role in backing the forwarding offload, and
leaves relatively few things up to the switch driver. In particular, DSA
keeps for each bridge port a zero-based index (the number of the
bridge). Multiple ports enslaved to the same bridge have a pointer to
the same accel_priv structure.

The tagger can check if the packet that is being transmitted on has
skb->offload_fwd_mark = true or not. If it does, it can be sure that the
packet belongs to the data plane of a bridge, further information about
which can be obtained based on dp->bridge_dev and dp->bridge_num.
It can then compose a DSA tag for injecting a data plane packet into
that bridge number.

For the switch driver side, we offer two new dsa_switch_ops methods,
called .port_bridge_fwd_offload_{add,del}, which are modeled after
.port_bridge_{join,leave}.
These methods are provided in case the driver needs to configure the
hardware to treat packets coming from that bridge software interface as
data plane packets. The switchdev <-> bridge interaction happens during
the netdev_master_upper_dev_link() call, so to switch drivers, the
effect is that the .port_bridge_fwd_offload_add() method is called
immediately after .port_bridge_join().

If the bridge number exceeds the number of bridges for which the switch
driver can offload the TX data plane (and this includes the case where
the driver can offload none), DSA falls back to simply returning
tx_fwd_offload = false in the switchdev_bridge_port_offload() call.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  |  19 ++++++++-
 net/dsa/dsa2.c     |   1 +
 net/dsa/dsa_priv.h |   6 +++
 net/dsa/port.c     | 100 ++++++++++++++++++++++++++++++++++++++++++++-
 net/dsa/slave.c    |  13 +++++-
 5 files changed, 136 insertions(+), 3 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 89626eab92b9..99b4e23b003b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -162,6 +162,9 @@ struct dsa_switch_tree {
 
 	/* Track the largest switch index within a tree */
 	unsigned int last_switch;
+
+	/* Track the bridges with forwarding offload enabled */
+	unsigned long fwd_offloading_bridges;
 };
 
 #define dsa_lags_foreach_id(_id, _dst)				\
@@ -224,7 +227,6 @@ struct dsa_mall_tc_entry {
 	};
 };
 
-
 struct dsa_port {
 	/* A CPU port is physically connected to a master device.
 	 * A user port exposed to userspace has a slave device.
@@ -262,6 +264,7 @@ struct dsa_port {
 	bool			vlan_filtering;
 	u8			stp_state;
 	struct net_device	*bridge_dev;
+	int			bridge_num;
 	struct devlink_port	devlink_port;
 	bool			devlink_port_setup;
 	struct phylink		*pl;
@@ -410,6 +413,12 @@ struct dsa_switch {
 	 */
 	unsigned int		num_lag_ids;
 
+	/* Drivers that support bridge forwarding offload should set this to
+	 * the maximum number of bridges spanning the same switch tree that can
+	 * be offloaded.
+	 */
+	unsigned int		num_fwd_offloading_bridges;
+
 	size_t num_ports;
 };
 
@@ -693,6 +702,14 @@ struct dsa_switch_ops {
 				    struct net_device *bridge);
 	void	(*port_bridge_leave)(struct dsa_switch *ds, int port,
 				     struct net_device *bridge);
+	/* Called right after .port_bridge_join() */
+	int	(*port_bridge_fwd_offload_add)(struct dsa_switch *ds, int port,
+					       struct net_device *bridge,
+					       int bridge_num);
+	/* Called right before .port_bridge_leave() */
+	void	(*port_bridge_fwd_offload_del)(struct dsa_switch *ds, int port,
+					       struct net_device *bridge,
+					       int bridge_num);
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
 				      u8 state);
 	void	(*port_fast_age)(struct dsa_switch *ds, int port);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index de5e93ba2a9d..c7fa85fb3086 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1044,6 +1044,7 @@ static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 
 	dp->ds = ds;
 	dp->index = index;
+	dp->bridge_num = -1;
 
 	INIT_LIST_HEAD(&dp->list);
 	list_add_tail(&dp->list, &dst->ports);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 3b51aaa26760..ff70e5afe3f2 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -14,6 +14,8 @@
 #include <net/dsa.h>
 #include <net/gro_cells.h>
 
+#define DSA_MAX_NUM_OFFLOADING_BRIDGES		BITS_PER_LONG
+
 enum {
 	DSA_NOTIFIER_AGEING_TIME,
 	DSA_NOTIFIER_BRIDGE_JOIN,
@@ -197,6 +199,10 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 int dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br,
 			      struct netlink_ext_ack *extack);
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
+int dsa_port_bridge_fwd_offload_add(struct dsa_port *dp,
+				    struct net_device *br, int bridge_num);
+void dsa_port_bridge_fwd_offload_del(struct dsa_port *dp,
+				     struct net_device *br, int bridge_num);
 int dsa_port_lag_change(struct dsa_port *dp,
 			struct netdev_lag_lower_state_info *linfo);
 int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index fce02db6a845..283726f5121b 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -230,6 +230,75 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 	 */
 }
 
+static int dsa_tree_find_bridge_num(struct dsa_switch_tree *dst,
+				    struct net_device *bridge_dev)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dp->bridge_dev  == bridge_dev)
+			return dp->bridge_num;
+
+	return -1;
+}
+
+static void dsa_port_bridge_tx_fwd_unprepare(struct dsa_port *dp,
+					     struct net_device *bridge_dev)
+{
+	struct dsa_switch *ds = dp->ds;
+	struct dsa_switch_tree *dst;
+	int bridge_num;
+
+	dst = ds->dst;
+
+	bridge_num = dp->bridge_num;
+
+	dp->bridge_num = -1;
+
+	/* bridge no longer in use, time to clean it up */
+	if (!dsa_tree_find_bridge_num(dst, bridge_dev))
+		clear_bit(bridge_num, &dst->fwd_offloading_bridges);
+
+	/* Notify the chips only once the offload has been deactivated, so
+	 * that they can update their configuration accordingly.
+	 */
+	dsa_port_bridge_fwd_offload_del(dp, bridge_dev, bridge_num);
+}
+
+static bool dsa_port_bridge_tx_fwd_prepare(struct dsa_port *dp,
+					   struct net_device *bridge_dev)
+{
+	struct dsa_switch *ds = dp->ds;
+	struct dsa_switch_tree *dst;
+	int bridge_num, err;
+
+	dst = ds->dst;
+
+	bridge_num = dsa_tree_find_bridge_num(dst, bridge_dev);
+	if (bridge_num < 0) {
+		/* First port that offloads TX forwarding for this bridge */
+		int bridge_num;
+
+		bridge_num = find_first_zero_bit(&dst->fwd_offloading_bridges,
+						 DSA_MAX_NUM_OFFLOADING_BRIDGES);
+		if (bridge_num >= ds->num_fwd_offloading_bridges)
+			return false;
+
+		set_bit(bridge_num, &dst->fwd_offloading_bridges);
+	}
+
+	dp->bridge_num = bridge_num;
+
+	/* Notify the driver */
+	err = dsa_port_bridge_fwd_offload_add(dp, bridge_dev, bridge_num);
+	if (err) {
+		dsa_port_bridge_tx_fwd_unprepare(dp, bridge_dev);
+		return false;
+	}
+
+	return true;
+}
+
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 			 struct netlink_ext_ack *extack)
 {
@@ -241,6 +310,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	};
 	struct net_device *dev = dp->slave;
 	struct net_device *brport_dev;
+	bool tx_fwd_offload;
 	int err;
 
 	/* Here the interface is already bridged. Reflect the current
@@ -254,7 +324,10 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	if (err)
 		goto out_rollback;
 
-	err = switchdev_bridge_port_offload(brport_dev, dev, dp, false, extack);
+	tx_fwd_offload = dsa_port_bridge_tx_fwd_prepare(dp, br);
+
+	err = switchdev_bridge_port_offload(brport_dev, dev, dp, tx_fwd_offload,
+					    extack);
 	if (err)
 		goto out_rollback_unbridge;
 
@@ -279,6 +352,8 @@ int dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br,
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 	struct net_device *dev = dp->slave;
 
+	dsa_port_bridge_tx_fwd_prepare(dp, br);
+
 	return switchdev_bridge_port_unoffload(brport_dev, dev, dp, extack);
 }
 
@@ -304,6 +379,29 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	dsa_port_switchdev_unsync_attrs(dp);
 }
 
+int dsa_port_bridge_fwd_offload_add(struct dsa_port *dp,
+				    struct net_device *br, int bridge_num)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->port_bridge_fwd_offload_add)
+		return -EOPNOTSUPP;
+
+	return ds->ops->port_bridge_fwd_offload_add(ds, dp->index, br,
+						    bridge_num);
+}
+
+void dsa_port_bridge_fwd_offload_del(struct dsa_port *dp,
+				     struct net_device *br, int bridge_num)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->port_bridge_fwd_offload_del)
+		return;
+
+	ds->ops->port_bridge_fwd_offload_del(ds, dp->index, br, bridge_num);
+}
+
 int dsa_port_lag_change(struct dsa_port *dp,
 			struct netdev_lag_lower_state_info *linfo)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f8f06756c6a3..4eff63b4ef2a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1877,10 +1877,21 @@ int dsa_slave_create(struct dsa_port *port)
 
 	slave_dev = alloc_netdev_mqs(sizeof(struct dsa_slave_priv), name,
 				     NET_NAME_UNKNOWN, ether_setup,
-				     ds->num_tx_queues, 1);
+				     ds->num_tx_queues + 1, 1);
 	if (slave_dev == NULL)
 		return -ENOMEM;
 
+	/* To avoid changing the number of TX queues at runtime depending on
+	 * whether the tagging protocol in use supports bridge forwarding
+	 * offload or not, just assume that all tagging protocols do, and
+	 * unconditionally register one extra TX queue to back that offload.
+	 * Then set num_real_tx_queues such that it will never be selected by
+	 * netdev_pick_tx(), just by ourselves.
+	 */
+	ret = netif_set_real_num_tx_queues(slave_dev, ds->num_tx_queues);
+	if (ret)
+		goto out_free;
+
 	slave_dev->features = master->vlan_features | NETIF_F_HW_TC;
 	if (ds->ops->port_vlan_add && ds->ops->port_vlan_del)
 		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-- 
2.25.1

