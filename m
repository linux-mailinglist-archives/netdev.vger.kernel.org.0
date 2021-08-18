Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA4A3F032A
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbhHRMDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:03:47 -0400
Received: from mail-eopbgr00067.outbound.protection.outlook.com ([40.107.0.67]:52143
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233833AbhHRMDb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:03:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ti+LMbXDC4YESf8LrmVObVmjE9/+I0oEddS4mEz8n8sImSl7Oy/ma69rxV8tN8nWZKAh+zMlh0f3Ff2rqxDBGjead1dqyc5ugojUvP3M+86EMmw9MLjaGehrVZ08DHJGAVMbJnysN5Uo9nQ4eD/4qsIl05Y7n5JoqHVxsIsfgwSZ7eTVnXPRa8EInZCNWHoPk61g9As+Ce2N7rM5TsB6cRnnM4mfeMnSvq5rW2K6kZKliiQWDakHjQOOwUq+wnEaYXU1N/oLloxjkkNWdbNEMhRYUqhBdexU0XqymltAOm4Mt9uTEJimt6VfYDawcXUkF2VpKNtFd+tisdIS2Z5RAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AchM5qEWGpob9zgSD03vrGypRQHFtJDK1++b6gW7VP8=;
 b=hBlY0T8J3cykEhIV/lzLn8c3RgRaZAo2Z+MTqCrpYW4RmAyc2Aw+MGyn+TAd+ZJNKHVdfEVhrRUXZBYm1TfRY+bnNCPKqryZpygVBV7kGvj4qbMcu8ZLygi0PaIrHdKExcWj01nLjfoTdc3Q9TJnq7muU3/ZeiZZm3A3HK8g5S48OHo/BgweOhEK4kOMnYsY073OmAOwl5YFBP7jfJ5l1oLoa5BlcvlFrjC3kcKSzGLFsJJmNCFlkcwB8EIvn+EX0JI1E8+W2jlHafhEKcUVOzFm7E5xELa5f+FB7DJZpWRcKafpvF/hXSUKd439KaR/cwzMfk0uv9dTaGst2qCYbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AchM5qEWGpob9zgSD03vrGypRQHFtJDK1++b6gW7VP8=;
 b=BvFjPE+ff7QgzaiXPzpRLcxaPpSjxff7FaJI43+RhJRFkdLl7xjEG3vb4k7e4kHOIpN9OHOFSIq8C94QPUBvXS4TuJhKcHIzp/C37FyWwwEk4g4MzI/fza5UtniWFMCr3bm13XxsH8SlIJLY/23ju3VqEVySxOs5ElXhyBnoRKg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 12:02:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:02:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [RFC PATCH net-next 01/20] net: dsa: track unique bridge numbers across all DSA switch trees
Date:   Wed, 18 Aug 2021 15:01:31 +0300
Message-Id: <20210818120150.892647-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210818120150.892647-1-vladimir.oltean@nxp.com>
References: <20210818120150.892647-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0134.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:02:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8688ba6-08e9-436f-d370-08d962401a8d
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3839346B33610BEA16B38EAEE0FF9@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fcxLvl0Oxqvx2YFDmqtwo30ZKRxRjYpZSTZ1ltc7Te2M5/a/LIm+GSM23adgRIsz/IXEB8d9eQq4EhlRSMuzYgObqd8IVV9DULwFPWJ3osSRbOBCmmTRFFmDbliCLmOArIBkOs9n73q3AgOjmxSFRdLr2L8OERff9Psx4gq6nD0cu8WfeiYp/lJrg+aA048ujERSZE3vrL/mNWHo+epAc9y7LZXqQjMOvH0qqczmD1+LKnle/HNuJFE73LRmdAxtuVOEhpfMYcHQo00+RFYnjyOBbOnyc5FkX9yypPz+YBQqHKYWtueL2JDEFpIrNA6VlX0ytwxPALDUhH3dIH8ehWonu3fLde5efyvtCaPo+g6Txab8FbXP8oiaxf72JbUccwQv0hTHo1doFs7QHyFq3bEzcbP9Cp3i9DrvFynJO1pB9sC7TuzqC2WHDoYbZXzvC7tVSinfWU+IJqMbhRVweZCpJvEdKmkDokHmwvDGVMZmKi1vGej7rPUl+wsGBnTig2Je49SLr7zc4SCweAJfN+5xTGxPMMzvlxFGxb/f5G3BWWAq+qfKOoLCZ2ey0HM1nwMLhM4Jx7Veyr4UQa34xNUsAmHBP6H0Ph2mXjnfypNVhOkuqO5GfOACT5cWs1pUTV7intcnhObmcAOYo9igaw6yjOYyrjb1vSGM4oGEJ2aMZ+IJR4d3/whrqGeBxDeJPzPYu32xEsofwcurr9eXLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39840400004)(366004)(376002)(66476007)(2906002)(66556008)(8936002)(6506007)(186003)(7406005)(7416002)(52116002)(26005)(86362001)(66946007)(6486002)(44832011)(36756003)(5660300002)(1076003)(110136005)(54906003)(6512007)(8676002)(316002)(6666004)(38350700002)(38100700002)(956004)(478600001)(83380400001)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OvH3aC7SzufJYmHZ8DVTiMUFaOtlDgNjKI3M9UOQe0QFhaLC91wTDM7DVW4/?=
 =?us-ascii?Q?pDCKpDZjgOkwWBGHhV/DspOGEMRDlH5RkDBCILJU1+rqvQY0f00gK/Yz2dEO?=
 =?us-ascii?Q?4j8y/oqxuN5Z4V3jVbxbCUX4luw5oYvON43Jc9jVUFKzZIWKrk8zgHZPRpP/?=
 =?us-ascii?Q?oaYHm6zldbI9820OxQtIT+QyYUxICAMd6RdgNZ5h679XtUr0beA3l3rp4qvj?=
 =?us-ascii?Q?nw4VE817mQiy7bibN1ajB6i7saL7pO3qd4o+Ntof1UopjmrkV1kGgFrJ2WNt?=
 =?us-ascii?Q?g8PjGrRD2nUkgw6hEp/mQEwvEZsBqFRGBTIh5G3ck4uKm5QICOzy80wjlnSj?=
 =?us-ascii?Q?lS60l4GZu17AB6apWN3zuruQnP6f6XxNhktzMPQJtzq52IQyxuV3KreQiGbB?=
 =?us-ascii?Q?uJoelza4IfIPKN++dfRry5SNfveQGtGXgG9mZfa/iGU7ybQ73W4RNY1QlvLq?=
 =?us-ascii?Q?7fkcF4G5wSV3ipG6OdMPDi/whL8iKgMr3OCJ4tHzCSfxhSvhJ6iOkmESsQVG?=
 =?us-ascii?Q?d/r0bx/CIZkUx3S6FeiM1vGch8TBqS7DTNZswB81u3t5SxcWOmzxRdCF8EP6?=
 =?us-ascii?Q?Lwe4iQVIoxVejJiWACevJ2y+sHWiQINyih78b1F7ZDQ+HnOdmk1/QxXHsR/e?=
 =?us-ascii?Q?UuPDrdaNPi7hn8FR5WhtKTJmgFskj0UClQwsQ9bTR6n3skg19Exej+rdAQlh?=
 =?us-ascii?Q?MkaoTogIeAk6XCrr4jqKYfsO4K/llq7ZK5vfKDrPn6OMdy/6eJCB4CZ5JbSr?=
 =?us-ascii?Q?ycB7HShmHARDshbWSY+JtjQ8T7cV0xkT/rzsLMeKs2B1FQLstVmza7wIlEfe?=
 =?us-ascii?Q?TCl+4UVXTrYYXfJYOVqdX+eqQnL2PN+QAtiMdnlxEpOe/TgP96YQEfLUVhK5?=
 =?us-ascii?Q?RskvM+uOjgKqzfs3s4btNOkv88VftwjxhURLNmaJKdMo9oKwkoh/wutCyrSr?=
 =?us-ascii?Q?jnNrmB2yPHo4COYLO+8DDlqr8U9SMmDWppoxCK3IHlDhoqQ8rpO18sw0NFwF?=
 =?us-ascii?Q?SuiM5jm9G/5B35j2lNrOOfc/RkDLV44gQHjfcVw1ZxFt46M09nHWzyeGS2Az?=
 =?us-ascii?Q?uJg0+4wNp52t4YMCMzTdY0JTLIMVINXrIpXubx/XVaSOxwSuLwiaIIKi9w4H?=
 =?us-ascii?Q?CY3+evzJt+ITwhaiN2eRTH2NKB2qIsAeA0VzjMXubtXHQUO7yZljhR638jvu?=
 =?us-ascii?Q?KJX9xU2EcBsk7yXf8k1xhutzRMlsvr79sREK4PnbfDUt65P1GhEghwEy5mQ6?=
 =?us-ascii?Q?78rabfogg3E77m0rT+ZzaBS6ctVFwK+AO3su47qNrRZp+hbfEUiPg8TlaS0/?=
 =?us-ascii?Q?BpM8mfoGG7bj6gsO1m3htIxf?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8688ba6-08e9-436f-d370-08d962401a8d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:02:51.5515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zvH0sSG/32hL9R+bVhhIfJrS+1Mw3qxhSlwkkxEtfEUHMnCPDGGxFx1jSD4WaRQLocsw988xUg4oCoZm8UF1jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now, cross-tree bridging setups work somewhat by mistake.

In the case of cross-tree bridging with sja1105, all switch instances
need to agree upon a common VLAN ID for forwarding a packet that belongs
to a certain bridging domain.

With TX forwarding offload, the VLAN ID is the bridge VLAN for
VLAN-aware bridging, and the tag_8021q TX forwarding offload VID
(a VLAN which has non-zero VBID bits) for VLAN-unaware bridging.

The VBID for VLAN-unaware bridging is derived from the dp->bridge_num
value calculated by DSA independently for each switch tree.

If ports from one tree join one bridge, and ports from another tree join
another bridge, DSA will assign them the same bridge_num, even though
the bridges are different. If cross-tree bridging is supported, this
is an issue.

Modify DSA to calculate the bridge_num globally across all switch trees.
This has the implication for a driver that the dp->bridge_num value that
DSA will assign to its ports might not be contiguous, if there are
boards with multiple DSA drivers instantiated. Additionally, all
bridge_num values eat up towards each switch's
ds->num_fwd_offloading_bridges maximum, which is potentially unfortunate,
and can be seen as a limitation introduced by this patch. However, that
is the lesser evil for now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  |  8 +++-----
 net/dsa/dsa2.c     | 48 ++++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 39 +++++--------------------------------
 4 files changed, 58 insertions(+), 39 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 0c2cba45fa79..c7ea0f61056f 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -155,9 +155,6 @@ struct dsa_switch_tree {
 
 	/* Track the largest switch index within a tree */
 	unsigned int last_switch;
-
-	/* Track the bridges with forwarding offload enabled */
-	unsigned long fwd_offloading_bridges;
 };
 
 #define dsa_lags_foreach_id(_id, _dst)				\
@@ -411,8 +408,9 @@ struct dsa_switch {
 	unsigned int		num_lag_ids;
 
 	/* Drivers that support bridge forwarding offload should set this to
-	 * the maximum number of bridges spanning the same switch tree that can
-	 * be offloaded.
+	 * the maximum number of bridges spanning the same switch tree (or all
+	 * trees, in the case of cross-tree bridging support) that can be
+	 * offloaded.
 	 */
 	unsigned int		num_fwd_offloading_bridges;
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index dcd67801eca4..1b2b25d7bd02 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -21,6 +21,9 @@
 static DEFINE_MUTEX(dsa2_mutex);
 LIST_HEAD(dsa_tree_list);
 
+/* Track the bridges with forwarding offload enabled */
+static unsigned long dsa_fwd_offloading_bridges;
+
 /**
  * dsa_tree_notify - Execute code for all switches in a DSA switch tree.
  * @dst: collection of struct dsa_switch devices to notify.
@@ -126,6 +129,51 @@ void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag)
 	}
 }
 
+static int dsa_bridge_num_find(const struct net_device *bridge_dev)
+{
+	struct dsa_switch_tree *dst;
+	struct dsa_port *dp;
+
+	/* When preparing the offload for a port, it will have a valid
+	 * dp->bridge_dev pointer but a not yet valid dp->bridge_num.
+	 * However there might be other ports having the same dp->bridge_dev
+	 * and a valid dp->bridge_num, so just ignore this port.
+	 */
+	list_for_each_entry(dst, &dsa_tree_list, list)
+		list_for_each_entry(dp, &dst->ports, list)
+			if (dp->bridge_dev == bridge_dev &&
+			    dp->bridge_num != -1)
+				return dp->bridge_num;
+
+	return -1;
+}
+
+int dsa_bridge_num_get(const struct net_device *bridge_dev, int max)
+{
+	int bridge_num = dsa_bridge_num_find(bridge_dev);
+
+	if (bridge_num < 0) {
+		/* First port that offloads TX forwarding for this bridge */
+		bridge_num = find_first_zero_bit(&dsa_fwd_offloading_bridges,
+						 DSA_MAX_NUM_OFFLOADING_BRIDGES);
+		if (bridge_num >= max)
+			return -1;
+
+		set_bit(bridge_num, &dsa_fwd_offloading_bridges);
+	}
+
+	return bridge_num;
+}
+
+void dsa_bridge_num_put(const struct net_device *bridge_dev, int bridge_num)
+{
+	/* Check if the bridge is still in use, otherwise it is time
+	 * to clean it up so we can reuse this bridge_num later.
+	 */
+	if (!dsa_bridge_num_find(bridge_dev))
+		clear_bit(bridge_num, &dsa_fwd_offloading_bridges);
+}
+
 struct dsa_switch *dsa_switch_find(int tree_index, int sw_index)
 {
 	struct dsa_switch_tree *dst;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b7a269e0513f..88aaf43b2da4 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -543,6 +543,8 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops);
+int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
+void dsa_bridge_num_put(const struct net_device *bridge_dev, int bridge_num);
 
 /* tag_8021q.c */
 int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 979042a64d1a..4fbe81ffb1ce 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -270,27 +270,9 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 	 */
 }
 
-static int dsa_tree_find_bridge_num(struct dsa_switch_tree *dst,
-				    struct net_device *bridge_dev)
-{
-	struct dsa_port *dp;
-
-	/* When preparing the offload for a port, it will have a valid
-	 * dp->bridge_dev pointer but a not yet valid dp->bridge_num.
-	 * However there might be other ports having the same dp->bridge_dev
-	 * and a valid dp->bridge_num, so just ignore this port.
-	 */
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dp->bridge_dev == bridge_dev && dp->bridge_num != -1)
-			return dp->bridge_num;
-
-	return -1;
-}
-
 static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
 					     struct net_device *bridge_dev)
 {
-	struct dsa_switch_tree *dst = dp->ds->dst;
 	int bridge_num = dp->bridge_num;
 	struct dsa_switch *ds = dp->ds;
 
@@ -300,11 +282,7 @@ static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
 
 	dp->bridge_num = -1;
 
-	/* Check if the bridge is still in use, otherwise it is time
-	 * to clean it up so we can reuse this bridge_num later.
-	 */
-	if (!dsa_tree_find_bridge_num(dst, bridge_dev))
-		clear_bit(bridge_num, &dst->fwd_offloading_bridges);
+	dsa_bridge_num_put(bridge_dev, bridge_num);
 
 	/* Notify the chips only once the offload has been deactivated, so
 	 * that they can update their configuration accordingly.
@@ -316,23 +294,16 @@ static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
 static bool dsa_port_bridge_tx_fwd_offload(struct dsa_port *dp,
 					   struct net_device *bridge_dev)
 {
-	struct dsa_switch_tree *dst = dp->ds->dst;
 	struct dsa_switch *ds = dp->ds;
 	int bridge_num, err;
 
 	if (!ds->ops->port_bridge_tx_fwd_offload)
 		return false;
 
-	bridge_num = dsa_tree_find_bridge_num(dst, bridge_dev);
-	if (bridge_num < 0) {
-		/* First port that offloads TX forwarding for this bridge */
-		bridge_num = find_first_zero_bit(&dst->fwd_offloading_bridges,
-						 DSA_MAX_NUM_OFFLOADING_BRIDGES);
-		if (bridge_num >= ds->num_fwd_offloading_bridges)
-			return false;
-
-		set_bit(bridge_num, &dst->fwd_offloading_bridges);
-	}
+	bridge_num = dsa_bridge_num_get(bridge_dev,
+					ds->num_fwd_offloading_bridges);
+	if (bridge_num < 0)
+		return false;
 
 	dp->bridge_num = bridge_num;
 
-- 
2.25.1

