Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA863F0338
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236552AbhHRMFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:05:19 -0400
Received: from mail-eopbgr00079.outbound.protection.outlook.com ([40.107.0.79]:39586
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236514AbhHRMEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:04:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRUMeQUu6dzd8mMZzzMZwr/AgyjK4jpJysDe8+HSmtGltXGaX0YmKsIIIVHMaLfmCGXdTJYklA4ChTjswSy86a77DMymyJUxqApWylLzywkESqz2TZ7WXWfJIG8fSnbdhwX2EfKaxsy487CaTEPrs0IsEfTkFUsNcA+auJ+F7nFSBm0sn4VvxjIfNw8GhvXYrbJoP5mOWmra5/qhm2i7y3StR3lDM8sgxYQ3H/dVqhvgSXh9OAEBdEjqMDE+aJ8mAxgqUnawSWbpz+8kIEffLVz2UldY0hFKt5GVQeSwUcA11UhFoknLExg8H7JEPOaghbx98NlF7fjp9aHdDqT1zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gYMrjC734w41a+FENTyateW6BDOP9qXfJuiGdkGxu0=;
 b=btO33jVeZBQ+8RVEl6uNb48KVuv8WqRIJ2GkJ3hV+dZn0nYOCLh8hnlR/xELB9wubp+LWbb8781qIfpXwoc5eD8s0Io7cOUnAYXoNnRqt3AyJK2wvrLhFY3nrtodi2rzzSD3bNsWOFjuoalsC0BJfCbWWSnSzi4QUmucfAJAnvv0bhlGYG6K2vmP0YkdNgB1VTeGtS7leqKOx63mR4hXPUIwPGbDB1g+bOHeMH265OMy9N66Ankp2nuMTrv3Xkrg/4QEND8g8m8q/7xtR98y0h39ChDsHk74y2uThXi1AHpyd7tNmTpM6ecjZpTht3g4JtpYsU+SqLaPpEBPOIXlGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gYMrjC734w41a+FENTyateW6BDOP9qXfJuiGdkGxu0=;
 b=H+U5p9JCKGP8ZyMY0wBLfLLXoddqlW/kmie/L+2CXjQjoKCJtee3BHr8BdLZh2h6c9h00ns8KPTVlno9s+PsjGvxTQILPoaAgDZW2tpwXLgoY4dCHoBxdjqKxrvSIvxEozPK1xfURyppuGSuetBc04wJEda8I30MOQFSmfeBMzw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 12:03:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:03:13 +0000
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
Subject: [RFC PATCH net-next 16/20] net: dsa: sja1105: enforce FDB isolation
Date:   Wed, 18 Aug 2021 15:01:46 +0300
Message-Id: <20210818120150.892647-17-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:03:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4e7e361-475d-4f1a-a24e-08d962402751
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3839E6C355E194CE91071CB2E0FF9@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t79XLDclmAKI97AEkFbSTV62zPUcts2rjFWf+Gz9ex6ytg5CzvjGX95ENaPiuIK5c97eUTSv0P86N4FWlL9uRpby32xSk+ZedySVI+2ArBgZllh7EnZuQJ5QeDK7I+dWnhXd10IK8miMTmQKXGZO7lMatiJPUs0uAjjIgn4d4zv5ubA/wYbQAoLyzF2zASaejPehkD0X9qugDYV5RnOACjyVbQDa3JAbO3zB9V0p7fXT31kf731O2icRk11tZDjXFrSY/PQ4BNGrKxlHgoL8/CsKOwsTMnVf10Rh3AHGAx+3vvfssKZpbwUovvcmI2h3TVTHjbOAz0sMMl1ozdT0xd2Tq8LD0eS6CdWLOHMUfiY61Py7AD3E+JJgOEyiS6eevrk59XFaQT3UsLbTu67ipo2jTr4Llh9OCuNTYB/5HHUhwpgAYLje9sbmN+erq3lq+AZH3zD1NxZ9h61gb//7ixSfRBIqg77n+QAT0Ah8zZ5ENDXtrekRwvANBQRWL1XMHwoUiZyy3yS/YNUL1pVn3yNmiPz4AKJ+wwNuiwrabaMzHM35PezFxu5npR22UTRQGD61diHjOBmDcFIBT4Cz+LSXzA3VVXWsbuHQh2z0xlo1HuA3fTQ8kGEBKbQLHBctOBRzLacup3sUs6M1JhLcHPT7N9JtSh/c4vcS5RpMPoSwS5ieJGSmQHT5Ngz5YNhCHv0fZsbhOlfOjRnQ/W0QgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39850400004)(366004)(376002)(66476007)(2906002)(66556008)(8936002)(6506007)(186003)(7406005)(7416002)(52116002)(26005)(86362001)(66946007)(6486002)(44832011)(36756003)(5660300002)(1076003)(110136005)(54906003)(6512007)(8676002)(316002)(6666004)(38350700002)(38100700002)(956004)(478600001)(83380400001)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zz0IhX+bjIM8t/52tySATmGztEcAaEGCweFDSVA8MTWU9Rp7VJWSWE9ZuiAF?=
 =?us-ascii?Q?Crs14XpGQCodTD7cezcEzYGiTqsiBeykjYtLmvgtXjZEoFjG8uiQWscaREma?=
 =?us-ascii?Q?oXS2Pz4VTlxhl+O/IU8F+yhl3MDUQtISlMNc0zc/cLd95Q7AMmGQviJISkq5?=
 =?us-ascii?Q?rV3L3XAb5UPCYsXFChnegVyddJmia24ujwlH8Z35hdbUifjhxoHWJrNS3Ovz?=
 =?us-ascii?Q?oDjC0Hj7XNLzl7bCHFlC2SEbg2j2T4kWUAH6HaZF9pA09aQ9l7gZXPi4nMQU?=
 =?us-ascii?Q?W9p0Sd55onls1EW+GyrXC42o9I3xdNbnLDwAo3lV8ZTDBILP2n+fbjocn9O8?=
 =?us-ascii?Q?qyBvoDJv6Vy7t9+mWyi3sNdEiV2/lpwhK8MZHInNY/xdcsXo2GxPP+MV+uxH?=
 =?us-ascii?Q?fA5IGeYc6AELfAO6f9+Rp5u77qFlW1h12S9uK6RG2WrHeguSILd2rRv0rF7W?=
 =?us-ascii?Q?hRDPQ8VhJSL9FDy4i+hC8RObcLsQ8Y+NgE3Cy9rJI+1aQzWC6co24YoVIN5d?=
 =?us-ascii?Q?QN0dXJcPJ6pw886ZntP7LyyjWybm+vJM5ODd5XbxSAht57sEDV4MCfjXgioS?=
 =?us-ascii?Q?I/tXwHjdnIAFxMGxGUQCydAEWW/rGedJzjF3DO+m18Z73Fz9THTo239CW3rs?=
 =?us-ascii?Q?KJApsI5MXf9nNFwyrC1wf86zGKYxMqzd9fJdtR9Bl47tUB/m4PSZmvZgaVeI?=
 =?us-ascii?Q?f67UwDGXsww0K2/KC/IDb8xJFjaKLtwaUKe84/ghRTgq4BL+RiXPemM066MO?=
 =?us-ascii?Q?DWecQRbU4tiltUeST3XTwVK2BrUmJI8wu2rLajeoDwGr9rAd8CqMF3OFxI+U?=
 =?us-ascii?Q?+Iv2euW4/Ax7hUu+qzUFzOqyaqdSFryAiWIh0swW1/vpmFONx11IqnezKx6C?=
 =?us-ascii?Q?pi0EqT731FpI1CQsYlM7rhDOzcVlpF3Ld0Z7TuLaL5Xp/p7ezbOSV9SVKdqv?=
 =?us-ascii?Q?RIqCgODWjm9+QQMrBNSkWLedfPeQ2CMx/krW6yNA/OI2Rxvy4YsPLMpBGC1M?=
 =?us-ascii?Q?6v6LGGFoAqJ2M8jmxwUTXnd5JQnysqutlk/Qv+hpJL5Fk9RAJUGXUAlbD8gH?=
 =?us-ascii?Q?+wttuFdEajRienM9rLqSEZQEPE7LC7ulbOZjpdDCFln3SFadj2j8daNtc0cj?=
 =?us-ascii?Q?1HdjZH2BxYOUOXBDJoSCdfuyk2j7IAApA1nyuU6AIT2avFRxZ1gtJJZEQrlb?=
 =?us-ascii?Q?XfKXSEeb7OesO2XyGSi4mOrewTjZVFiVzyrXyfrhORSGw0reHlIFIL0Fr5b2?=
 =?us-ascii?Q?lu9HC6HNv7lfDxTCxavqKqhGpndsnvcj+sdc0GlHFiju+LsDwdPCgxQpKPgH?=
 =?us-ascii?Q?KVLcjNdO9H7Wtxcljr9+Lq6A?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e7e361-475d-4f1a-a24e-08d962402751
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:03:12.9284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kzueV/2TV5ZbsjUJ8EZ7Esp7Ylr1M/Pc3buhM1i6vw6A7N5aRLBPElB3DPhv4m4axB6uYUNahKQvk1hushzqhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For sja1105, to enforce FDB isolation simply means to turn on
Independent VLAN Learning unconditionally, and to remap VLAN-unaware FDB
and MDB entries towards the private VLAN allocated by tag_8021q for each
bridge.

Standalone ports each have their own standalone tag_8021q VLAN. No
learning happens in that VLAN due to:
- learning being disabled on standalone user ports
- learning being disabled on the CPU port (we use
  assisted_learning_on_cpu_port which only installs bridge FDBs)

VLAN-aware ports learn FDB entries with the bridge VLANs.

VLAN-unaware bridge ports learn with the tag_8021q VLAN for bridging.

Since sja1105 is the first driver to use the dsa_bridge_num_find()
helper, we need to export it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 38 +++++++-------------------
 include/net/dsa.h                      |  1 +
 net/dsa/dsa2.c                         |  3 +-
 3 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 667e698b5ae8..bc0d89b96353 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -361,10 +361,8 @@ static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
 		.start_dynspc = 0,
 		/* 2^8 + 2^5 + 2^3 + 2^2 + 2^1 + 1 in Koopman notation */
 		.poly = 0x97,
-		/* This selects between Independent VLAN Learning (IVL) and
-		 * Shared VLAN Learning (SVL)
-		 */
-		.shared_learn = true,
+		/* Always use Independent VLAN Learning (IVL) */
+		.shared_learn = false,
 		/* Don't discard management traffic based on ENFPORT -
 		 * we don't perform SMAC port enforcement anyway, so
 		 * what we are setting here doesn't matter.
@@ -1736,6 +1734,9 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 
+	if (!vid)
+		vid = dsa_tag_8021q_bridge_vid(dsa_bridge_num_find(br));
+
 	return priv->info->fdb_add_cmd(ds, port, addr, vid);
 }
 
@@ -1745,6 +1746,9 @@ static int sja1105_fdb_del(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 
+	if (!vid)
+		vid = dsa_tag_8021q_bridge_vid(dsa_bridge_num_find(br));
+
 	return priv->info->fdb_del_cmd(ds, port, addr, vid);
 }
 
@@ -1787,8 +1791,9 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
 
 		/* We need to hide the dsa_8021q VLANs from the user. */
-		if (!priv->vlan_aware)
+		if (vid_is_dsa_8021q(l2_lookup.vlanid))
 			l2_lookup.vlanid = 0;
+
 		rc = cb(macaddr, l2_lookup.vlanid, l2_lookup.lockeds, data);
 		if (rc)
 			return rc;
@@ -2269,7 +2274,6 @@ sja1105_get_tag_protocol(struct dsa_switch *ds, int port,
 int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 			   struct netlink_ext_ack *extack)
 {
-	struct sja1105_l2_lookup_params_entry *l2_lookup_params;
 	struct sja1105_general_params_entry *general_params;
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_table *table;
@@ -2321,28 +2325,6 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 	general_params->incl_srcpt1 = enabled;
 	general_params->incl_srcpt0 = enabled;
 
-	/* VLAN filtering => independent VLAN learning.
-	 * No VLAN filtering (or best effort) => shared VLAN learning.
-	 *
-	 * In shared VLAN learning mode, untagged traffic still gets
-	 * pvid-tagged, and the FDB table gets populated with entries
-	 * containing the "real" (pvid or from VLAN tag) VLAN ID.
-	 * However the switch performs a masked L2 lookup in the FDB,
-	 * effectively only looking up a frame's DMAC (and not VID) for the
-	 * forwarding decision.
-	 *
-	 * This is extremely convenient for us, because in modes with
-	 * vlan_filtering=0, dsa_8021q actually installs unique pvid's into
-	 * each front panel port. This is good for identification but breaks
-	 * learning badly - the VID of the learnt FDB entry is unique, aka
-	 * no frames coming from any other port are going to have it. So
-	 * for forwarding purposes, this is as though learning was broken
-	 * (all frames get flooded).
-	 */
-	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS];
-	l2_lookup_params = table->entries;
-	l2_lookup_params->shared_learn = !priv->vlan_aware;
-
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_is_unused_port(ds, port))
 			continue;
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 103b738bd773..5bf8d3a85106 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1046,6 +1046,7 @@ static inline int dsa_ndo_eth_ioctl(struct net_device *dev, struct ifreq *ifr,
 void dsa_unregister_switch(struct dsa_switch *ds);
 int dsa_register_switch(struct dsa_switch *ds);
 struct dsa_switch *dsa_switch_find(int tree_index, int sw_index);
+int dsa_bridge_num_find(const struct net_device *bridge_dev);
 #ifdef CONFIG_PM_SLEEP
 int dsa_switch_suspend(struct dsa_switch *ds);
 int dsa_switch_resume(struct dsa_switch *ds);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 1b2b25d7bd02..0d07a44eeecf 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -129,7 +129,7 @@ void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag)
 	}
 }
 
-static int dsa_bridge_num_find(const struct net_device *bridge_dev)
+int dsa_bridge_num_find(const struct net_device *bridge_dev)
 {
 	struct dsa_switch_tree *dst;
 	struct dsa_port *dp;
@@ -147,6 +147,7 @@ static int dsa_bridge_num_find(const struct net_device *bridge_dev)
 
 	return -1;
 }
+EXPORT_SYMBOL_GPL(dsa_bridge_num_find);
 
 int dsa_bridge_num_get(const struct net_device *bridge_dev, int max)
 {
-- 
2.25.1

