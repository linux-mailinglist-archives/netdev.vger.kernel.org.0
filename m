Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4583CE824
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352818AbhGSQiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:38:05 -0400
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:25006
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354938AbhGSQfg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 12:35:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4vDj0ELyo+zQfNBMWNFgPdn4MaXeH4Ik7aLwNiKYpsVAb+Ogv8kG1b5ZmUWaz8gR1U4+2zaDjche4TCExpBAPAoV2hacvb6f3g1dtRiE6hhszsj1kgyTqYD7Dy8oJ5QGCsUx0fGZ7RQKHqil9BoIP/ptCb3m6Pkc44zeUG23Femj+zuu7A+K4OH80birT47rUPw6RcfnqsGrxNybzezi/7ap4yVIJP3zeSnTCK323txl/5iTxKEaT+JSUluyxTYVdbBIHNb4hxXGyb0P5TNb469L/sWNycBmPgYKycNfKTabz1bZkgebrHdmx8gPuhOHwiVaxj6lYVvpsvs2by61A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIaRaRGtEdwf1EK7TI5G5kcsokjGiZaQcOYrVK41s/I=;
 b=gvpp8cAcsk9e/HVq3iM/jhh7ikLm6+EFvQmYkJNJW9F5W1eO6EJXfhTBfbVvWfp0E9PUJtSNKRXIG+o/nGiv03lU2Uz8B8/jGuzQHvmjWybTvZLvRrL95VMLMuXFjJwAERow/p9O0DJJ9/a6ghJcp8axqLBDOfk0Qc9mu0liF0U2IZ1f5jz8kbLiT6RYyYS2wb9zlz0JjZyROu2EHM0Opw66dOQBqr55nKBMkFBXLNbU0jmNcXMMN23xFXGhvI535OW8pRVLx616yKRKZUS/sfwTCrjinBmz9C+88QkLDTVapNIJ/6UHIDStKQ21KFiCRkGWbyb5gyoyEjTHDsKMPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIaRaRGtEdwf1EK7TI5G5kcsokjGiZaQcOYrVK41s/I=;
 b=fXL5mb+KI+fPKCznStshrCnRLC4Xfe/vVXsCJ+FLrgLiYrgKGzqoJeDSyUKl+xYF2m5wdNnH8FECBs7Ln3jtHAzgkr3XcyLl6vcIfqv2YQOpZmWKVaYinJlcvTjU6WXk1e6d8pf8y1+gpnp8H3Dmuk8dDrov2nxVFzm7zTqhZkc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 17:16:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 17:16:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 01/11] net: dsa: sja1105: delete the best_effort_vlan_filtering mode
Date:   Mon, 19 Jul 2021 20:14:42 +0300
Message-Id: <20210719171452.463775-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210719171452.463775-1-vladimir.oltean@nxp.com>
References: <20210719171452.463775-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 17:16:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f6eeb24-e8c4-4e5d-245b-08d94ad8e3c1
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3407275EE3037D95EEC42771E0E19@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xbZgvSq6pyhrt+PMBG3DKOTtWPlrocBApwm9gPDoYcOrm1gWt5iskJ828ZR71WvC13MBh2QBt6z3qGYKMEh6/xvz7kYq9SQ2W9g/1w+kxyuj725X1dAoCaMDfBip2j8yy4r+7PMPCEP4gcpw3zxTtxZI3ljTM1BijmqqoPFWKKnJ+IEk8WKy+ssNYBZY67l5MDEq04M2rtav7Ya1G34DuDLahAY3CUxnRH+diuHJ0eHdQJ9sX512jAj2rqGqxGXPiI6/HID6jKQQVQphL+oaNeQGRGMGMCn/Y7JEvq2FFqPF+BG6wq8GRvZ7kmLR3ZsUEEHXYjfKovhftUFTJqMxEt/T/c+Qauph/B4wINv/fVLzp13IkHfMo0flCWQAOJkCgoZQ19CSSEjxyBv63/ijLURhGodR2ysOgWQBR7GORyNrLNHgnAQDmoTQ34Z6zadNPXsT6Vtnw8vcmD4Ozd11WjTU6dmHkWhvVCIpGrACO6A0nq0qCBQnopPMiAlQRdp3KScUDUbmTIQB8mbSQo/QHYki7XsutnzwH6jKwQuJ7Y+yp/xtmkpZ4xV+I/3mC0lRHNiadJYuigcXTLBHn1D5+g+ZIg/Y6BkDHAILViWJljhX8wXpAH2WtY5O8TbJFbjioV8In4SV9Uf6Idc5gtprXV5tNth/WLVhIZGpvgixizFG5y0OrtKWgKW7LvnW2m0yB7b4OCU6sFAAzBd0f2dxuC9UqnJPHeRRhfM+ZKPacJQP7iRkCGahQX7nYX0tCsNbJA3x9ID7zUb1e6FQz2prnDYSuYjtWakxN0+N+QwH9mo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(366004)(136003)(346002)(376002)(6666004)(6512007)(86362001)(36756003)(52116002)(30864003)(8676002)(8936002)(6506007)(83380400001)(316002)(5660300002)(66476007)(4326008)(66946007)(66556008)(110136005)(2616005)(956004)(1076003)(6486002)(54906003)(38350700002)(478600001)(38100700002)(186003)(44832011)(2906002)(26005)(966005)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4UZDwu60P3Nhl8Mcqd+rlYtLEQxid5cm7+RgA5/6hS+n+3numgMS+P8YwGv5?=
 =?us-ascii?Q?fEO7UqpaK8SUNkQG+L4Dn3B5ny+x/OnEgDj2u5Z9Wyn7lSjUkRD6KoJR10IR?=
 =?us-ascii?Q?ZCq6hVT3/K17+7qkl4nkDhyfkaupp+kWwnlunGF3g03McaLA9EDYmhxBv41B?=
 =?us-ascii?Q?Fexm9wKAnn5qBjL3srLzQVGz5imV/JTHOd1oQ/Y++AaI6NE/rtY1iuti1urw?=
 =?us-ascii?Q?qj5FcQq40n7SieafQJtPjdw/c8epqh5jaBzlxyL0wWHFWxl18pZ1lmvkEJ6N?=
 =?us-ascii?Q?+9AADkL0wpp5Q3XYWbgG6kxBYRRcbK0Y4VYr5pyHwe11wLkWNUVTm/nJedle?=
 =?us-ascii?Q?dVcFvQcRnYAfjKIAY8jr3XpVkDjkpxNq7eq0jyIl9zvyYzv17K9u3kKZplV8?=
 =?us-ascii?Q?2FfokJ1aMB/VDs+7+odJXQOJor1GP7ltwOmg5cMkzq9oayo6yX7FPAkVC8uR?=
 =?us-ascii?Q?DGgk24eLnJC8jLb8nVxikL494vi9/NaRtzWjXzvf1ZOvvqPtocx/3UCS7pp9?=
 =?us-ascii?Q?PzK0oYTXmHRpSWmHD1jkvnBZTJeUiaZrfRvr7CGJ/Uf6I6PqbnIVkezurpKH?=
 =?us-ascii?Q?XJII1n3Y7B4LILkDdx2Pi5IqEmQ5cQ2v5wyitefsNQvkJXWMwhylj4T/I4xl?=
 =?us-ascii?Q?/LlxigBEu8+BHN7eZGw7hvO3AoQZeEJkhVic0UVjejIJvE3ONoSu5aMpusnl?=
 =?us-ascii?Q?0LG8mB1+U0Ocs/cpfU4Pz9YjzDXN9C3G0ACF71QZSCXilZDJZoeQtnN13bte?=
 =?us-ascii?Q?dnfDOR/F8DnN62SOCK/qSay02iS/aj8Etg/ugEdabJ6CkSM0yykB/2gPefud?=
 =?us-ascii?Q?Xxj7LHDMf3TWjABBT6ip9Wlisq3fx/P5dB+XyYJXNtzMSGW/KAwfmU2/QaqK?=
 =?us-ascii?Q?9RQ0cTK54xhJ2wN0NYaVygz19RaqD8tgfdhfrrT5IeEL7bHKy2W43h7fkxSU?=
 =?us-ascii?Q?0285P5QyJ+9MH3l+zy4BdJ/C+R0M8scgVeWPnjMQi6MpE7JhFW13Sw1EBY9o?=
 =?us-ascii?Q?vFjVCi7f1FRQueoBvJhzZiYk8oKW1ysOG/ArJha44ck91XLWHammkjz5ISax?=
 =?us-ascii?Q?I3nNoDbxj7zMh8Ako9Vo3+Xvn1KhQEdJm9Esc8MSA3li9z3KXBHwYQS1Htoz?=
 =?us-ascii?Q?yqeGEPr9Q3LbPPMUkw4Ds9DL4R3MpJhujDrUkCrgDpfAOpM5spLygPFl8q68?=
 =?us-ascii?Q?YgGuBaqqiJ1tUGoqc2CE1Zl+3N8TQrrFnEk3e++KjJrkgfcFyacaaHN52Y/u?=
 =?us-ascii?Q?5HSt/y1RLnGd2QxFefEWudIEBk4Dwee4AigH0aaq8nNtCeSV/Y/dCxAIIHaf?=
 =?us-ascii?Q?l81b9rUj8+819Q5Vzf+yui6L?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f6eeb24-e8c4-4e5d-245b-08d94ad8e3c1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 17:16:04.6741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YzVSYLnnZG8ldEkigE4NqUVCVFpS+ROs8msE6u/qEsIPpShawKTZr/f7E/Is4SgA0gJnbj3GWmU7jS/7zsYTBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simply put, the best-effort VLAN filtering mode relied on VLAN retagging
from a bridge VLAN towards a tag_8021q sub-VLAN in order to be able to
decode the source port in the tagger, but the VLAN retagging
implementation inside the sja1105 chips is not the best and we were
relying on marginal operating conditions.

The most notable limitation of the best-effort VLAN filtering mode is
its incapacity to treat this case properly:

ip link add br0 type bridge vlan_filtering 1
ip link set swp2 master br0
ip link set swp4 master br0
bridge vlan del dev swp4 vid 1
bridge vlan add dev swp4 vid 1 pvid

When sending an untagged packet through swp2, the expectation is for it
to be forwarded to swp4 as egress-tagged (so it will contain VLAN ID 1
on egress). But the switch will send it as egress-untagged.

There was an attempt to fix this here:
https://patchwork.kernel.org/project/netdevbpf/patch/20210407201452.1703261-2-olteanv@gmail.com/

but it failed miserably because it broke PTP RX timestamping, in a way
that cannot be corrected due to hardware issues related to VLAN
retagging.

So with either PTP broken or pushing VLAN headers on egress for untagged
packets being broken, the sad reality is that the best-effort VLAN
filtering code is broken. Delete it.

Note that this means there will be a temporary loss of functionality in
this driver until it is replaced with something better (network stack
RX/TX capability for "mode 2" as described in
Documentation/networking/dsa/sja1105.rst, the "port under VLAN-aware
bridge" case). We simply cannot keep this code until that driver rework
is done, it is super bloated and tangled with tag_8021q.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h         |  13 +-
 drivers/net/dsa/sja1105/sja1105_devlink.c | 114 +----
 drivers/net/dsa/sja1105/sja1105_main.c    | 482 +---------------------
 drivers/net/dsa/sja1105/sja1105_vl.c      |  14 +-
 include/linux/dsa/8021q.h                 |   9 +-
 include/linux/dsa/sja1105.h               |   1 -
 net/dsa/tag_8021q.c                       |  77 +---
 net/dsa/tag_ocelot_8021q.c                |   4 +-
 net/dsa/tag_sja1105.c                     |  28 +-
 9 files changed, 42 insertions(+), 700 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 221c7abdef0e..869b19c08fc0 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -234,19 +234,13 @@ struct sja1105_bridge_vlan {
 	bool untagged;
 };
 
-enum sja1105_vlan_state {
-	SJA1105_VLAN_UNAWARE,
-	SJA1105_VLAN_BEST_EFFORT,
-	SJA1105_VLAN_FILTERING_FULL,
-};
-
 struct sja1105_private {
 	struct sja1105_static_config static_config;
 	bool rgmii_rx_delay[SJA1105_MAX_NUM_PORTS];
 	bool rgmii_tx_delay[SJA1105_MAX_NUM_PORTS];
 	phy_interface_t phy_mode[SJA1105_MAX_NUM_PORTS];
 	bool fixed_link[SJA1105_MAX_NUM_PORTS];
-	bool best_effort_vlan_filtering;
+	bool vlan_aware;
 	unsigned long learn_ena;
 	unsigned long ucast_egress_floods;
 	unsigned long bcast_egress_floods;
@@ -264,7 +258,6 @@ struct sja1105_private {
 	 */
 	struct mutex mgmt_lock;
 	struct dsa_8021q_context *dsa_8021q_ctx;
-	enum sja1105_vlan_state vlan_state;
 	struct devlink_region **regions;
 	struct sja1105_cbs_entry *cbs;
 	struct mii_bus *mdio_base_t1;
@@ -311,10 +304,6 @@ int sja1110_pcs_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val);
 /* From sja1105_devlink.c */
 int sja1105_devlink_setup(struct dsa_switch *ds);
 void sja1105_devlink_teardown(struct dsa_switch *ds);
-int sja1105_devlink_param_get(struct dsa_switch *ds, u32 id,
-			      struct devlink_param_gset_ctx *ctx);
-int sja1105_devlink_param_set(struct dsa_switch *ds, u32 id,
-			      struct devlink_param_gset_ctx *ctx);
 int sja1105_devlink_info_get(struct dsa_switch *ds,
 			     struct devlink_info_req *req,
 			     struct netlink_ext_ack *extack);
diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
index b6a4a16b8c7e..05c7f4ca3b1a 100644
--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -115,105 +115,6 @@ static void sja1105_teardown_devlink_regions(struct dsa_switch *ds)
 	kfree(priv->regions);
 }
 
-static int sja1105_best_effort_vlan_filtering_get(struct sja1105_private *priv,
-						  bool *be_vlan)
-{
-	*be_vlan = priv->best_effort_vlan_filtering;
-
-	return 0;
-}
-
-static int sja1105_best_effort_vlan_filtering_set(struct sja1105_private *priv,
-						  bool be_vlan)
-{
-	struct dsa_switch *ds = priv->ds;
-	bool vlan_filtering;
-	int port;
-	int rc;
-
-	priv->best_effort_vlan_filtering = be_vlan;
-
-	rtnl_lock();
-	for (port = 0; port < ds->num_ports; port++) {
-		struct dsa_port *dp;
-
-		if (!dsa_is_user_port(ds, port))
-			continue;
-
-		dp = dsa_to_port(ds, port);
-		vlan_filtering = dsa_port_is_vlan_filtering(dp);
-
-		rc = sja1105_vlan_filtering(ds, port, vlan_filtering, NULL);
-		if (rc)
-			break;
-	}
-	rtnl_unlock();
-
-	return rc;
-}
-
-enum sja1105_devlink_param_id {
-	SJA1105_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
-	SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING,
-};
-
-int sja1105_devlink_param_get(struct dsa_switch *ds, u32 id,
-			      struct devlink_param_gset_ctx *ctx)
-{
-	struct sja1105_private *priv = ds->priv;
-	int err;
-
-	switch (id) {
-	case SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING:
-		err = sja1105_best_effort_vlan_filtering_get(priv,
-							     &ctx->val.vbool);
-		break;
-	default:
-		err = -EOPNOTSUPP;
-		break;
-	}
-
-	return err;
-}
-
-int sja1105_devlink_param_set(struct dsa_switch *ds, u32 id,
-			      struct devlink_param_gset_ctx *ctx)
-{
-	struct sja1105_private *priv = ds->priv;
-	int err;
-
-	switch (id) {
-	case SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING:
-		err = sja1105_best_effort_vlan_filtering_set(priv,
-							     ctx->val.vbool);
-		break;
-	default:
-		err = -EOPNOTSUPP;
-		break;
-	}
-
-	return err;
-}
-
-static const struct devlink_param sja1105_devlink_params[] = {
-	DSA_DEVLINK_PARAM_DRIVER(SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING,
-				 "best_effort_vlan_filtering",
-				 DEVLINK_PARAM_TYPE_BOOL,
-				 BIT(DEVLINK_PARAM_CMODE_RUNTIME)),
-};
-
-static int sja1105_setup_devlink_params(struct dsa_switch *ds)
-{
-	return dsa_devlink_params_register(ds, sja1105_devlink_params,
-					   ARRAY_SIZE(sja1105_devlink_params));
-}
-
-static void sja1105_teardown_devlink_params(struct dsa_switch *ds)
-{
-	dsa_devlink_params_unregister(ds, sja1105_devlink_params,
-				      ARRAY_SIZE(sja1105_devlink_params));
-}
-
 int sja1105_devlink_info_get(struct dsa_switch *ds,
 			     struct devlink_info_req *req,
 			     struct netlink_ext_ack *extack)
@@ -233,23 +134,10 @@ int sja1105_devlink_info_get(struct dsa_switch *ds,
 
 int sja1105_devlink_setup(struct dsa_switch *ds)
 {
-	int rc;
-
-	rc = sja1105_setup_devlink_params(ds);
-	if (rc)
-		return rc;
-
-	rc = sja1105_setup_devlink_regions(ds);
-	if (rc < 0) {
-		sja1105_teardown_devlink_params(ds);
-		return rc;
-	}
-
-	return 0;
+	return sja1105_setup_devlink_regions(ds);
 }
 
 void sja1105_devlink_teardown(struct dsa_switch *ds)
 {
-	sja1105_teardown_devlink_params(ds);
 	sja1105_teardown_devlink_regions(ds);
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ced8c9cb29c2..4514ac468cc8 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -545,18 +545,11 @@ void sja1105_frame_memory_partitioning(struct sja1105_private *priv)
 {
 	struct sja1105_l2_forwarding_params_entry *l2_fwd_params;
 	struct sja1105_vl_forwarding_params_entry *vl_fwd_params;
-	int max_mem = priv->info->max_frame_mem;
 	struct sja1105_table *table;
 
-	/* VLAN retagging is implemented using a loopback port that consumes
-	 * frame buffers. That leaves less for us.
-	 */
-	if (priv->vlan_state == SJA1105_VLAN_BEST_EFFORT)
-		max_mem -= SJA1105_FRAME_MEMORY_RETAGGING_OVERHEAD;
-
 	table = &priv->static_config.tables[BLK_IDX_L2_FORWARDING_PARAMS];
 	l2_fwd_params = table->entries;
-	l2_fwd_params->part_spc[0] = max_mem;
+	l2_fwd_params->part_spc[0] = SJA1105_MAX_FRAME_MEMORY;
 
 	/* If we have any critical-traffic virtual links, we need to reserve
 	 * some frame buffer memory for them. At the moment, hardcode the value
@@ -1416,7 +1409,7 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 	l2_lookup.vlanid = vid;
 	l2_lookup.iotag = SJA1105_S_TAG;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
-	if (priv->vlan_state != SJA1105_VLAN_UNAWARE) {
+	if (priv->vlan_aware) {
 		l2_lookup.mask_vlanid = VLAN_VID_MASK;
 		l2_lookup.mask_iotag = BIT(0);
 	} else {
@@ -1479,7 +1472,7 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 	l2_lookup.vlanid = vid;
 	l2_lookup.iotag = SJA1105_S_TAG;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
-	if (priv->vlan_state != SJA1105_VLAN_UNAWARE) {
+	if (priv->vlan_aware) {
 		l2_lookup.mask_vlanid = VLAN_VID_MASK;
 		l2_lookup.mask_iotag = BIT(0);
 	} else {
@@ -1525,7 +1518,7 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 	 * for what gets printed in 'bridge fdb show'.  In the case of zero,
 	 * no VID gets printed at all.
 	 */
-	if (priv->vlan_state != SJA1105_VLAN_FILTERING_FULL)
+	if (!priv->vlan_aware)
 		vid = 0;
 
 	return priv->info->fdb_add_cmd(ds, port, addr, vid);
@@ -1536,7 +1529,7 @@ static int sja1105_fdb_del(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 
-	if (priv->vlan_state != SJA1105_VLAN_FILTERING_FULL)
+	if (!priv->vlan_aware)
 		vid = 0;
 
 	return priv->info->fdb_del_cmd(ds, port, addr, vid);
@@ -1581,7 +1574,7 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
 
 		/* We need to hide the dsa_8021q VLANs from the user. */
-		if (priv->vlan_state == SJA1105_VLAN_UNAWARE)
+		if (!priv->vlan_aware)
 			l2_lookup.vlanid = 0;
 		cb(macaddr, l2_lookup.vlanid, l2_lookup.lockeds, data);
 	}
@@ -2085,57 +2078,6 @@ sja1105_get_tag_protocol(struct dsa_switch *ds, int port,
 	return priv->info->tag_proto;
 }
 
-static int sja1105_find_free_subvlan(u16 *subvlan_map, bool pvid)
-{
-	int subvlan;
-
-	if (pvid)
-		return 0;
-
-	for (subvlan = 1; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++)
-		if (subvlan_map[subvlan] == VLAN_N_VID)
-			return subvlan;
-
-	return -1;
-}
-
-static int sja1105_find_subvlan(u16 *subvlan_map, u16 vid)
-{
-	int subvlan;
-
-	for (subvlan = 0; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++)
-		if (subvlan_map[subvlan] == vid)
-			return subvlan;
-
-	return -1;
-}
-
-static int sja1105_find_committed_subvlan(struct sja1105_private *priv,
-					  int port, u16 vid)
-{
-	struct sja1105_port *sp = &priv->ports[port];
-
-	return sja1105_find_subvlan(sp->subvlan_map, vid);
-}
-
-static void sja1105_init_subvlan_map(u16 *subvlan_map)
-{
-	int subvlan;
-
-	for (subvlan = 0; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++)
-		subvlan_map[subvlan] = VLAN_N_VID;
-}
-
-static void sja1105_commit_subvlan_map(struct sja1105_private *priv, int port,
-				       u16 *subvlan_map)
-{
-	struct sja1105_port *sp = &priv->ports[port];
-	int subvlan;
-
-	for (subvlan = 0; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++)
-		sp->subvlan_map[subvlan] = subvlan_map[subvlan];
-}
-
 static int sja1105_is_vlan_configured(struct sja1105_private *priv, u16 vid)
 {
 	struct sja1105_vlan_lookup_entry *vlan;
@@ -2152,29 +2094,9 @@ static int sja1105_is_vlan_configured(struct sja1105_private *priv, u16 vid)
 	return -1;
 }
 
-static int
-sja1105_find_retagging_entry(struct sja1105_retagging_entry *retagging,
-			     int count, int from_port, u16 from_vid,
-			     u16 to_vid)
-{
-	int i;
-
-	for (i = 0; i < count; i++)
-		if (retagging[i].ing_port == BIT(from_port) &&
-		    retagging[i].vlan_ing == from_vid &&
-		    retagging[i].vlan_egr == to_vid)
-			return i;
-
-	/* Return an invalid entry index if not found */
-	return -1;
-}
-
 static int sja1105_commit_vlans(struct sja1105_private *priv,
-				struct sja1105_vlan_lookup_entry *new_vlan,
-				struct sja1105_retagging_entry *new_retagging,
-				int num_retagging)
+				struct sja1105_vlan_lookup_entry *new_vlan)
 {
-	struct sja1105_retagging_entry *retagging;
 	struct sja1105_vlan_lookup_entry *vlan;
 	struct sja1105_table *table;
 	int num_vlans = 0;
@@ -2234,50 +2156,9 @@ static int sja1105_commit_vlans(struct sja1105_private *priv,
 		vlan[k++] = new_vlan[i];
 	}
 
-	/* VLAN Retagging Table */
-	table = &priv->static_config.tables[BLK_IDX_RETAGGING];
-	retagging = table->entries;
-
-	for (i = 0; i < table->entry_count; i++) {
-		rc = sja1105_dynamic_config_write(priv, BLK_IDX_RETAGGING,
-						  i, &retagging[i], false);
-		if (rc)
-			return rc;
-	}
-
-	if (table->entry_count)
-		kfree(table->entries);
-
-	table->entries = kcalloc(num_retagging, table->ops->unpacked_entry_size,
-				 GFP_KERNEL);
-	if (!table->entries)
-		return -ENOMEM;
-
-	table->entry_count = num_retagging;
-	retagging = table->entries;
-
-	for (i = 0; i < num_retagging; i++) {
-		retagging[i] = new_retagging[i];
-
-		/* Update entry */
-		rc = sja1105_dynamic_config_write(priv, BLK_IDX_RETAGGING,
-						  i, &retagging[i], true);
-		if (rc < 0)
-			return rc;
-	}
-
 	return 0;
 }
 
-struct sja1105_crosschip_vlan {
-	struct list_head list;
-	u16 vid;
-	bool untagged;
-	int port;
-	int other_port;
-	struct dsa_8021q_context *other_ctx;
-};
-
 struct sja1105_crosschip_switch {
 	struct list_head list;
 	struct dsa_8021q_context *other_ctx;
@@ -2289,7 +2170,7 @@ static int sja1105_commit_pvid(struct sja1105_private *priv)
 	struct list_head *vlan_list;
 	int rc = 0;
 
-	if (priv->vlan_state == SJA1105_VLAN_FILTERING_FULL)
+	if (priv->vlan_aware)
 		vlan_list = &priv->bridge_vlans;
 	else
 		vlan_list = &priv->dsa_8021q_vlans;
@@ -2311,7 +2192,7 @@ sja1105_build_bridge_vlans(struct sja1105_private *priv,
 {
 	struct sja1105_bridge_vlan *v;
 
-	if (priv->vlan_state == SJA1105_VLAN_UNAWARE)
+	if (!priv->vlan_aware)
 		return 0;
 
 	list_for_each_entry(v, &priv->bridge_vlans, list) {
@@ -2334,9 +2215,6 @@ sja1105_build_dsa_8021q_vlans(struct sja1105_private *priv,
 {
 	struct sja1105_bridge_vlan *v;
 
-	if (priv->vlan_state == SJA1105_VLAN_FILTERING_FULL)
-		return 0;
-
 	list_for_each_entry(v, &priv->dsa_8021q_vlans, list) {
 		int match = v->vid;
 
@@ -2351,267 +2229,6 @@ sja1105_build_dsa_8021q_vlans(struct sja1105_private *priv,
 	return 0;
 }
 
-static int sja1105_build_subvlans(struct sja1105_private *priv,
-				  u16 subvlan_map[][DSA_8021Q_N_SUBVLAN],
-				  struct sja1105_vlan_lookup_entry *new_vlan,
-				  struct sja1105_retagging_entry *new_retagging,
-				  int *num_retagging)
-{
-	struct sja1105_bridge_vlan *v;
-	int k = *num_retagging;
-
-	if (priv->vlan_state != SJA1105_VLAN_BEST_EFFORT)
-		return 0;
-
-	list_for_each_entry(v, &priv->bridge_vlans, list) {
-		int upstream = dsa_upstream_port(priv->ds, v->port);
-		int match, subvlan;
-		u16 rx_vid;
-
-		/* Only sub-VLANs on user ports need to be applied.
-		 * Bridge VLANs also include VLANs added automatically
-		 * by DSA on the CPU port.
-		 */
-		if (!dsa_is_user_port(priv->ds, v->port))
-			continue;
-
-		subvlan = sja1105_find_subvlan(subvlan_map[v->port],
-					       v->vid);
-		if (subvlan < 0) {
-			subvlan = sja1105_find_free_subvlan(subvlan_map[v->port],
-							    v->pvid);
-			if (subvlan < 0) {
-				dev_err(priv->ds->dev, "No more free subvlans\n");
-				return -ENOSPC;
-			}
-		}
-
-		rx_vid = dsa_8021q_rx_vid_subvlan(priv->ds, v->port, subvlan);
-
-		/* @v->vid on @v->port needs to be retagged to @rx_vid
-		 * on @upstream. Assume @v->vid on @v->port and on
-		 * @upstream was already configured by the previous
-		 * iteration over bridge_vlans.
-		 */
-		match = rx_vid;
-		new_vlan[match].vlanid = rx_vid;
-		new_vlan[match].vmemb_port |= BIT(v->port);
-		new_vlan[match].vmemb_port |= BIT(upstream);
-		new_vlan[match].vlan_bc |= BIT(v->port);
-		new_vlan[match].vlan_bc |= BIT(upstream);
-		/* The "untagged" flag is set the same as for the
-		 * original VLAN
-		 */
-		if (!v->untagged)
-			new_vlan[match].tag_port |= BIT(v->port);
-		/* But it's always tagged towards the CPU */
-		new_vlan[match].tag_port |= BIT(upstream);
-		new_vlan[match].type_entry = SJA1110_VLAN_D_TAG;
-
-		/* The Retagging Table generates packet *clones* with
-		 * the new VLAN. This is a very odd hardware quirk
-		 * which we need to suppress by dropping the original
-		 * packet.
-		 * Deny egress of the original VLAN towards the CPU
-		 * port. This will force the switch to drop it, and
-		 * we'll see only the retagged packets.
-		 */
-		match = v->vid;
-		new_vlan[match].vlan_bc &= ~BIT(upstream);
-
-		/* And the retagging itself */
-		new_retagging[k].vlan_ing = v->vid;
-		new_retagging[k].vlan_egr = rx_vid;
-		new_retagging[k].ing_port = BIT(v->port);
-		new_retagging[k].egr_port = BIT(upstream);
-		if (k++ == SJA1105_MAX_RETAGGING_COUNT) {
-			dev_err(priv->ds->dev, "No more retagging rules\n");
-			return -ENOSPC;
-		}
-
-		subvlan_map[v->port][subvlan] = v->vid;
-	}
-
-	*num_retagging = k;
-
-	return 0;
-}
-
-/* Sadly, in crosschip scenarios where the CPU port is also the link to another
- * switch, we should retag backwards (the dsa_8021q vid to the original vid) on
- * the CPU port of neighbour switches.
- */
-static int
-sja1105_build_crosschip_subvlans(struct sja1105_private *priv,
-				 struct sja1105_vlan_lookup_entry *new_vlan,
-				 struct sja1105_retagging_entry *new_retagging,
-				 int *num_retagging)
-{
-	struct sja1105_crosschip_vlan *tmp, *pos;
-	struct dsa_8021q_crosschip_link *c;
-	struct sja1105_bridge_vlan *v, *w;
-	struct list_head crosschip_vlans;
-	int k = *num_retagging;
-	int rc = 0;
-
-	if (priv->vlan_state != SJA1105_VLAN_BEST_EFFORT)
-		return 0;
-
-	INIT_LIST_HEAD(&crosschip_vlans);
-
-	list_for_each_entry(c, &priv->dsa_8021q_ctx->crosschip_links, list) {
-		struct sja1105_private *other_priv = c->other_ctx->ds->priv;
-
-		if (other_priv->vlan_state == SJA1105_VLAN_FILTERING_FULL)
-			continue;
-
-		/* Crosschip links are also added to the CPU ports.
-		 * Ignore those.
-		 */
-		if (!dsa_is_user_port(priv->ds, c->port))
-			continue;
-		if (!dsa_is_user_port(c->other_ctx->ds, c->other_port))
-			continue;
-
-		/* Search for VLANs on the remote port */
-		list_for_each_entry(v, &other_priv->bridge_vlans, list) {
-			bool already_added = false;
-			bool we_have_it = false;
-
-			if (v->port != c->other_port)
-				continue;
-
-			/* If @v is a pvid on @other_ds, it does not need
-			 * re-retagging, because its SVL field is 0 and we
-			 * already allow that, via the dsa_8021q crosschip
-			 * links.
-			 */
-			if (v->pvid)
-				continue;
-
-			/* Search for the VLAN on our local port */
-			list_for_each_entry(w, &priv->bridge_vlans, list) {
-				if (w->port == c->port && w->vid == v->vid) {
-					we_have_it = true;
-					break;
-				}
-			}
-
-			if (!we_have_it)
-				continue;
-
-			list_for_each_entry(tmp, &crosschip_vlans, list) {
-				if (tmp->vid == v->vid &&
-				    tmp->untagged == v->untagged &&
-				    tmp->port == c->port &&
-				    tmp->other_port == v->port &&
-				    tmp->other_ctx == c->other_ctx) {
-					already_added = true;
-					break;
-				}
-			}
-
-			if (already_added)
-				continue;
-
-			tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
-			if (!tmp) {
-				dev_err(priv->ds->dev, "Failed to allocate memory\n");
-				rc = -ENOMEM;
-				goto out;
-			}
-			tmp->vid = v->vid;
-			tmp->port = c->port;
-			tmp->other_port = v->port;
-			tmp->other_ctx = c->other_ctx;
-			tmp->untagged = v->untagged;
-			list_add(&tmp->list, &crosschip_vlans);
-		}
-	}
-
-	list_for_each_entry(tmp, &crosschip_vlans, list) {
-		struct sja1105_private *other_priv = tmp->other_ctx->ds->priv;
-		int upstream = dsa_upstream_port(priv->ds, tmp->port);
-		int match, subvlan;
-		u16 rx_vid;
-
-		subvlan = sja1105_find_committed_subvlan(other_priv,
-							 tmp->other_port,
-							 tmp->vid);
-		/* If this happens, it's a bug. The neighbour switch does not
-		 * have a subvlan for tmp->vid on tmp->other_port, but it
-		 * should, since we already checked for its vlan_state.
-		 */
-		if (WARN_ON(subvlan < 0)) {
-			rc = -EINVAL;
-			goto out;
-		}
-
-		rx_vid = dsa_8021q_rx_vid_subvlan(tmp->other_ctx->ds,
-						  tmp->other_port,
-						  subvlan);
-
-		/* The @rx_vid retagged from @tmp->vid on
-		 * {@tmp->other_ds, @tmp->other_port} needs to be
-		 * re-retagged to @tmp->vid on the way back to us.
-		 *
-		 * Assume the original @tmp->vid is already configured
-		 * on this local switch, otherwise we wouldn't be
-		 * retagging its subvlan on the other switch in the
-		 * first place. We just need to add a reverse retagging
-		 * rule for @rx_vid and install @rx_vid on our ports.
-		 */
-		match = rx_vid;
-		new_vlan[match].vlanid = rx_vid;
-		new_vlan[match].vmemb_port |= BIT(tmp->port);
-		new_vlan[match].vmemb_port |= BIT(upstream);
-		/* The "untagged" flag is set the same as for the
-		 * original VLAN. And towards the CPU, it doesn't
-		 * really matter, because @rx_vid will only receive
-		 * traffic on that port. For consistency with other dsa_8021q
-		 * VLANs, we'll keep the CPU port tagged.
-		 */
-		if (!tmp->untagged)
-			new_vlan[match].tag_port |= BIT(tmp->port);
-		new_vlan[match].tag_port |= BIT(upstream);
-		new_vlan[match].type_entry = SJA1110_VLAN_D_TAG;
-		/* Deny egress of @rx_vid towards our front-panel port.
-		 * This will force the switch to drop it, and we'll see
-		 * only the re-retagged packets (having the original,
-		 * pre-initial-retagging, VLAN @tmp->vid).
-		 */
-		new_vlan[match].vlan_bc &= ~BIT(tmp->port);
-
-		/* On reverse retagging, the same ingress VLAN goes to multiple
-		 * ports. So we have an opportunity to create composite rules
-		 * to not waste the limited space in the retagging table.
-		 */
-		k = sja1105_find_retagging_entry(new_retagging, *num_retagging,
-						 upstream, rx_vid, tmp->vid);
-		if (k < 0) {
-			if (*num_retagging == SJA1105_MAX_RETAGGING_COUNT) {
-				dev_err(priv->ds->dev, "No more retagging rules\n");
-				rc = -ENOSPC;
-				goto out;
-			}
-			k = (*num_retagging)++;
-		}
-		/* And the retagging itself */
-		new_retagging[k].vlan_ing = rx_vid;
-		new_retagging[k].vlan_egr = tmp->vid;
-		new_retagging[k].ing_port = BIT(upstream);
-		new_retagging[k].egr_port |= BIT(tmp->port);
-	}
-
-out:
-	list_for_each_entry_safe(tmp, pos, &crosschip_vlans, list) {
-		list_del(&tmp->list);
-		kfree(tmp);
-	}
-
-	return rc;
-}
-
 static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify);
 
 static int sja1105_notify_crosschip_switches(struct sja1105_private *priv)
@@ -2665,12 +2282,9 @@ static int sja1105_notify_crosschip_switches(struct sja1105_private *priv)
 
 static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
 {
-	u16 subvlan_map[SJA1105_MAX_NUM_PORTS][DSA_8021Q_N_SUBVLAN];
-	struct sja1105_retagging_entry *new_retagging;
 	struct sja1105_vlan_lookup_entry *new_vlan;
 	struct sja1105_table *table;
-	int i, num_retagging = 0;
-	int rc;
+	int rc, i;
 
 	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
 	new_vlan = kcalloc(VLAN_N_VID,
@@ -2679,22 +2293,10 @@ static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
 		return -ENOMEM;
 
 	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
-	new_retagging = kcalloc(SJA1105_MAX_RETAGGING_COUNT,
-				table->ops->unpacked_entry_size, GFP_KERNEL);
-	if (!new_retagging) {
-		kfree(new_vlan);
-		return -ENOMEM;
-	}
 
 	for (i = 0; i < VLAN_N_VID; i++)
 		new_vlan[i].vlanid = VLAN_N_VID;
 
-	for (i = 0; i < SJA1105_MAX_RETAGGING_COUNT; i++)
-		new_retagging[i].vlan_ing = VLAN_N_VID;
-
-	for (i = 0; i < priv->ds->num_ports; i++)
-		sja1105_init_subvlan_map(subvlan_map[i]);
-
 	/* Bridge VLANs */
 	rc = sja1105_build_bridge_vlans(priv, new_vlan);
 	if (rc)
@@ -2709,22 +2311,7 @@ static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
 	if (rc)
 		goto out;
 
-	/* Private VLANs necessary for dsa_8021q operation, which we need to
-	 * determine on our own:
-	 * - Sub-VLANs
-	 * - Sub-VLANs of crosschip switches
-	 */
-	rc = sja1105_build_subvlans(priv, subvlan_map, new_vlan, new_retagging,
-				    &num_retagging);
-	if (rc)
-		goto out;
-
-	rc = sja1105_build_crosschip_subvlans(priv, new_vlan, new_retagging,
-					      &num_retagging);
-	if (rc)
-		goto out;
-
-	rc = sja1105_commit_vlans(priv, new_vlan, new_retagging, num_retagging);
+	rc = sja1105_commit_vlans(priv, new_vlan);
 	if (rc)
 		goto out;
 
@@ -2732,9 +2319,6 @@ static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
 	if (rc)
 		goto out;
 
-	for (i = 0; i < priv->ds->num_ports; i++)
-		sja1105_commit_subvlan_map(priv, i, subvlan_map[i]);
-
 	if (notify) {
 		rc = sja1105_notify_crosschip_switches(priv);
 		if (rc)
@@ -2743,7 +2327,6 @@ static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
 
 out:
 	kfree(new_vlan);
-	kfree(new_retagging);
 
 	return rc;
 }
@@ -2758,10 +2341,8 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 	struct sja1105_l2_lookup_params_entry *l2_lookup_params;
 	struct sja1105_general_params_entry *general_params;
 	struct sja1105_private *priv = ds->priv;
-	enum sja1105_vlan_state state;
 	struct sja1105_table *table;
 	struct sja1105_rule *rule;
-	bool want_tagging;
 	u16 tpid, tpid2;
 	int rc;
 
@@ -2792,19 +2373,10 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 			sp->xmit_tpid = ETH_P_SJA1105;
 	}
 
-	if (!enabled)
-		state = SJA1105_VLAN_UNAWARE;
-	else if (priv->best_effort_vlan_filtering)
-		state = SJA1105_VLAN_BEST_EFFORT;
-	else
-		state = SJA1105_VLAN_FILTERING_FULL;
-
-	if (priv->vlan_state == state)
+	if (priv->vlan_aware == enabled)
 		return 0;
 
-	priv->vlan_state = state;
-	want_tagging = (state == SJA1105_VLAN_UNAWARE ||
-			state == SJA1105_VLAN_BEST_EFFORT);
+	priv->vlan_aware = enabled;
 
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
 	general_params = table->entries;
@@ -2818,8 +2390,6 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 	general_params->incl_srcpt1 = enabled;
 	general_params->incl_srcpt0 = enabled;
 
-	want_tagging = priv->best_effort_vlan_filtering || !enabled;
-
 	/* VLAN filtering => independent VLAN learning.
 	 * No VLAN filtering (or best effort) => shared VLAN learning.
 	 *
@@ -2840,9 +2410,7 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 	 */
 	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS];
 	l2_lookup_params = table->entries;
-	l2_lookup_params->shared_learn = want_tagging;
-
-	sja1105_frame_memory_partitioning(priv);
+	l2_lookup_params->shared_learn = !priv->vlan_aware;
 
 	rc = sja1105_build_vlan_table(priv, false);
 	if (rc)
@@ -2852,12 +2420,7 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 	if (rc)
 		NL_SET_ERR_MSG_MOD(extack, "Failed to change VLAN Ethertype");
 
-	/* Switch port identification based on 802.1Q is only passable
-	 * if we are not under a vlan_filtering bridge. So make sure
-	 * the two configurations are mutually exclusive (of course, the
-	 * user may know better, i.e. best_effort_vlan_filtering).
-	 */
-	return sja1105_setup_8021q_tagging(ds, want_tagging);
+	return rc;
 }
 
 /* Returns number of VLANs added (0 or 1) on success,
@@ -2927,12 +2490,9 @@ static int sja1105_vlan_add(struct dsa_switch *ds, int port,
 	bool vlan_table_changed = false;
 	int rc;
 
-	/* If the user wants best-effort VLAN filtering (aka vlan_filtering
-	 * bridge plus tagging), be sure to at least deny alterations to the
-	 * configuration done by dsa_8021q.
+	/* Be sure to deny alterations to the configuration done by tag_8021q.
 	 */
-	if (priv->vlan_state != SJA1105_VLAN_FILTERING_FULL &&
-	    vid_is_dsa_8021q(vlan->vid)) {
+	if (vid_is_dsa_8021q(vlan->vid)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Range 1024-3071 reserved for dsa_8021q operation");
 		return -EBUSY;
@@ -3086,8 +2646,6 @@ static int sja1105_setup(struct dsa_switch *ds)
 
 	ds->mtu_enforcement_ingress = true;
 
-	priv->best_effort_vlan_filtering = true;
-
 	rc = sja1105_devlink_setup(ds);
 	if (rc < 0)
 		goto out_static_config_free;
@@ -3604,8 +3162,6 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.cls_flower_stats	= sja1105_cls_flower_stats,
 	.crosschip_bridge_join	= sja1105_crosschip_bridge_join,
 	.crosschip_bridge_leave	= sja1105_crosschip_bridge_leave,
-	.devlink_param_get	= sja1105_devlink_param_get,
-	.devlink_param_set	= sja1105_devlink_param_set,
 	.devlink_info_get	= sja1105_devlink_info_get,
 };
 
@@ -3785,7 +3341,6 @@ static int sja1105_probe(struct spi_device *spi)
 		struct sja1105_port *sp = &priv->ports[port];
 		struct dsa_port *dp = dsa_to_port(ds, port);
 		struct net_device *slave;
-		int subvlan;
 
 		if (!dsa_is_user_port(ds, port))
 			continue;
@@ -3806,9 +3361,6 @@ static int sja1105_probe(struct spi_device *spi)
 		}
 		skb_queue_head_init(&sp->xmit_queue);
 		sp->xmit_tpid = ETH_P_SJA1105;
-
-		for (subvlan = 0; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++)
-			sp->subvlan_map[subvlan] = VLAN_N_VID;
 	}
 
 	return 0;
diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index f6e13e6c6a18..ec7b65daec20 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -496,14 +496,11 @@ int sja1105_vl_redirect(struct sja1105_private *priv, int port,
 	struct sja1105_rule *rule = sja1105_rule_find(priv, cookie);
 	int rc;
 
-	if (priv->vlan_state == SJA1105_VLAN_UNAWARE &&
-	    key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
+	if (!priv->vlan_aware && key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only redirect based on DMAC");
 		return -EOPNOTSUPP;
-	} else if ((priv->vlan_state == SJA1105_VLAN_BEST_EFFORT ||
-		    priv->vlan_state == SJA1105_VLAN_FILTERING_FULL) &&
-		   key->type != SJA1105_KEY_VLAN_AWARE_VL) {
+	} else if (priv->vlan_aware && key->type != SJA1105_KEY_VLAN_AWARE_VL) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only redirect based on {DMAC, VID, PCP}");
 		return -EOPNOTSUPP;
@@ -595,14 +592,11 @@ int sja1105_vl_gate(struct sja1105_private *priv, int port,
 		return -ERANGE;
 	}
 
-	if (priv->vlan_state == SJA1105_VLAN_UNAWARE &&
-	    key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
+	if (!priv->vlan_aware && key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only gate based on DMAC");
 		return -EOPNOTSUPP;
-	} else if ((priv->vlan_state == SJA1105_VLAN_BEST_EFFORT ||
-		    priv->vlan_state == SJA1105_VLAN_FILTERING_FULL) &&
-		   key->type != SJA1105_KEY_VLAN_AWARE_VL) {
+	} else if (priv->vlan_aware && key->type != SJA1105_KEY_VLAN_AWARE_VL) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only gate based on {DMAC, VID, PCP}");
 		return -EOPNOTSUPP;
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 1587961f1a7b..608607f904a5 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -35,8 +35,6 @@ struct dsa_8021q_context {
 	__be16 proto;
 };
 
-#define DSA_8021Q_N_SUBVLAN			8
-
 int dsa_8021q_setup(struct dsa_8021q_context *ctx, bool enabled);
 
 int dsa_8021q_crosschip_bridge_join(struct dsa_8021q_context *ctx, int port,
@@ -50,21 +48,16 @@ int dsa_8021q_crosschip_bridge_leave(struct dsa_8021q_context *ctx, int port,
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci);
 
-void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id,
-		   int *subvlan);
+void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id);
 
 u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port);
 
 u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port);
 
-u16 dsa_8021q_rx_vid_subvlan(struct dsa_switch *ds, int port, u16 subvlan);
-
 int dsa_8021q_rx_switch_id(u16 vid);
 
 int dsa_8021q_rx_source_port(u16 vid);
 
-u16 dsa_8021q_rx_subvlan(u16 vid);
-
 bool vid_is_dsa_8021q_rxvlan(u16 vid);
 
 bool vid_is_dsa_8021q_txvlan(u16 vid);
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index b6089b88314c..0eadc7ac44ec 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -59,7 +59,6 @@ struct sja1105_skb_cb {
 	((struct sja1105_skb_cb *)((skb)->cb))
 
 struct sja1105_port {
-	u16 subvlan_map[DSA_8021Q_N_SUBVLAN];
 	struct kthread_worker *xmit_worker;
 	struct kthread_work xmit_work;
 	struct sk_buff_head xmit_queue;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 4aa29f90ecea..d657864969d4 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -17,7 +17,7 @@
  *
  * | 11  | 10  |  9  |  8  |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
  * +-----------+-----+-----------------+-----------+-----------------------+
- * |    DIR    | SVL |    SWITCH_ID    |  SUBVLAN  |          PORT         |
+ * |    DIR    | RSV |    SWITCH_ID    |    RSV    |          PORT         |
  * +-----------+-----+-----------------+-----------+-----------------------+
  *
  * DIR - VID[11:10]:
@@ -27,24 +27,13 @@
  *	These values make the special VIDs of 0, 1 and 4095 to be left
  *	unused by this coding scheme.
  *
- * SVL/SUBVLAN - { VID[9], VID[5:4] }:
- *	Sub-VLAN encoding. Valid only when DIR indicates an RX VLAN.
- *	* 0 (0b000): Field does not encode a sub-VLAN, either because
- *	received traffic is untagged, PVID-tagged or because a second
- *	VLAN tag is present after this tag and not inside of it.
- *	* 1 (0b001): Received traffic is tagged with a VID value private
- *	to the host. This field encodes the index in the host's lookup
- *	table through which the value of the ingress VLAN ID can be
- *	recovered.
- *	* 2 (0b010): Field encodes a sub-VLAN.
- *	...
- *	* 7 (0b111): Field encodes a sub-VLAN.
- *	When DIR indicates a TX VLAN, SUBVLAN must be transmitted as zero
- *	(by the host) and ignored on receive (by the switch).
- *
  * SWITCH_ID - VID[8:6]:
  *	Index of switch within DSA tree. Must be between 0 and 7.
  *
+ * RSV - VID[5:4]:
+ *	To be used for further expansion of PORT or for other purposes.
+ *	Must be transmitted as zero and ignored on receive.
+ *
  * PORT - VID[3:0]:
  *	Index of switch port. Must be between 0 and 15.
  */
@@ -61,18 +50,6 @@
 #define DSA_8021Q_SWITCH_ID(x)		(((x) << DSA_8021Q_SWITCH_ID_SHIFT) & \
 						 DSA_8021Q_SWITCH_ID_MASK)
 
-#define DSA_8021Q_SUBVLAN_HI_SHIFT	9
-#define DSA_8021Q_SUBVLAN_HI_MASK	GENMASK(9, 9)
-#define DSA_8021Q_SUBVLAN_LO_SHIFT	4
-#define DSA_8021Q_SUBVLAN_LO_MASK	GENMASK(5, 4)
-#define DSA_8021Q_SUBVLAN_HI(x)		(((x) & GENMASK(2, 2)) >> 2)
-#define DSA_8021Q_SUBVLAN_LO(x)		((x) & GENMASK(1, 0))
-#define DSA_8021Q_SUBVLAN(x)		\
-		(((DSA_8021Q_SUBVLAN_LO(x) << DSA_8021Q_SUBVLAN_LO_SHIFT) & \
-		  DSA_8021Q_SUBVLAN_LO_MASK) | \
-		 ((DSA_8021Q_SUBVLAN_HI(x) << DSA_8021Q_SUBVLAN_HI_SHIFT) & \
-		  DSA_8021Q_SUBVLAN_HI_MASK))
-
 #define DSA_8021Q_PORT_SHIFT		0
 #define DSA_8021Q_PORT_MASK		GENMASK(3, 0)
 #define DSA_8021Q_PORT(x)		(((x) << DSA_8021Q_PORT_SHIFT) & \
@@ -98,13 +75,6 @@ u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_vid);
 
-u16 dsa_8021q_rx_vid_subvlan(struct dsa_switch *ds, int port, u16 subvlan)
-{
-	return DSA_8021Q_DIR_RX | DSA_8021Q_SWITCH_ID(ds->index) |
-	       DSA_8021Q_PORT(port) | DSA_8021Q_SUBVLAN(subvlan);
-}
-EXPORT_SYMBOL_GPL(dsa_8021q_rx_vid_subvlan);
-
 /* Returns the decoded switch ID from the RX VID. */
 int dsa_8021q_rx_switch_id(u16 vid)
 {
@@ -119,20 +89,6 @@ int dsa_8021q_rx_source_port(u16 vid)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_source_port);
 
-/* Returns the decoded subvlan from the RX VID. */
-u16 dsa_8021q_rx_subvlan(u16 vid)
-{
-	u16 svl_hi, svl_lo;
-
-	svl_hi = (vid & DSA_8021Q_SUBVLAN_HI_MASK) >>
-		 DSA_8021Q_SUBVLAN_HI_SHIFT;
-	svl_lo = (vid & DSA_8021Q_SUBVLAN_LO_MASK) >>
-		 DSA_8021Q_SUBVLAN_LO_SHIFT;
-
-	return (svl_hi << 2) | svl_lo;
-}
-EXPORT_SYMBOL_GPL(dsa_8021q_rx_subvlan);
-
 bool vid_is_dsa_8021q_rxvlan(u16 vid)
 {
 	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX;
@@ -227,7 +183,7 @@ static int dsa_8021q_setup_port(struct dsa_8021q_context *ctx, int port,
 	u16 rx_vid = dsa_8021q_rx_vid(ctx->ds, port);
 	u16 tx_vid = dsa_8021q_tx_vid(ctx->ds, port);
 	struct net_device *master;
-	int i, err, subvlan;
+	int i, err;
 
 	/* The CPU port is implicitly configured by
 	 * configuring the front-panel ports
@@ -275,18 +231,11 @@ static int dsa_8021q_setup_port(struct dsa_8021q_context *ctx, int port,
 		return err;
 	}
 
-	/* Add to the master's RX filter not only @rx_vid, but in fact
-	 * the entire subvlan range, just in case this DSA switch might
-	 * want to use sub-VLANs.
-	 */
-	for (subvlan = 0; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++) {
-		u16 vid = dsa_8021q_rx_vid_subvlan(ctx->ds, port, subvlan);
-
-		if (enabled)
-			vlan_vid_add(master, ctx->proto, vid);
-		else
-			vlan_vid_del(master, ctx->proto, vid);
-	}
+	/* Add @rx_vid to the master's RX filter. */
+	if (enabled)
+		vlan_vid_add(master, ctx->proto, rx_vid);
+	else
+		vlan_vid_del(master, ctx->proto, rx_vid);
 
 	/* Finally apply the TX VID on this port and on the CPU port */
 	err = dsa_8021q_vid_apply(ctx, port, tx_vid, BRIDGE_VLAN_INFO_UNTAGGED,
@@ -471,8 +420,7 @@ struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_xmit);
 
-void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id,
-		   int *subvlan)
+void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id)
 {
 	u16 vid, tci;
 
@@ -489,7 +437,6 @@ void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id,
 
 	*source_port = dsa_8021q_rx_source_port(vid);
 	*switch_id = dsa_8021q_rx_switch_id(vid);
-	*subvlan = dsa_8021q_rx_subvlan(vid);
 	skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rcv);
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 85ac85c3af8c..d0781b058610 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -41,9 +41,9 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 				  struct net_device *netdev,
 				  struct packet_type *pt)
 {
-	int src_port, switch_id, subvlan;
+	int src_port, switch_id;
 
-	dsa_8021q_rcv(skb, &src_port, &switch_id, &subvlan);
+	dsa_8021q_rcv(skb, &src_port, &switch_id);
 
 	skb->dev = dsa_master_find_slave(netdev, switch_id, src_port);
 	if (!skb->dev)
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 9c2df9ece01b..7c92c329a092 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -358,20 +358,6 @@ static struct sk_buff
 	return skb;
 }
 
-static void sja1105_decode_subvlan(struct sk_buff *skb, u16 subvlan)
-{
-	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-	struct sja1105_port *sp = dp->priv;
-	u16 vid = sp->subvlan_map[subvlan];
-	u16 vlan_tci;
-
-	if (vid == VLAN_N_VID)
-		return;
-
-	vlan_tci = (skb->priority << VLAN_PRIO_SHIFT) | vid;
-	__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tci);
-}
-
 static bool sja1105_skb_has_tag_8021q(const struct sk_buff *skb)
 {
 	u16 tpid = ntohs(eth_hdr(skb)->h_proto);
@@ -389,8 +375,8 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 				   struct net_device *netdev,
 				   struct packet_type *pt)
 {
-	int source_port, switch_id, subvlan = 0;
 	struct sja1105_meta meta = {0};
+	int source_port, switch_id;
 	struct ethhdr *hdr;
 	bool is_link_local;
 	bool is_meta;
@@ -403,7 +389,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 
 	if (sja1105_skb_has_tag_8021q(skb)) {
 		/* Normal traffic path. */
-		dsa_8021q_rcv(skb, &source_port, &switch_id, &subvlan);
+		dsa_8021q_rcv(skb, &source_port, &switch_id);
 	} else if (is_link_local) {
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
@@ -428,9 +414,6 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
-	if (subvlan)
-		sja1105_decode_subvlan(skb, subvlan);
-
 	return sja1105_rcv_meta_state_machine(skb, &meta, is_link_local,
 					      is_meta);
 }
@@ -538,7 +521,7 @@ static struct sk_buff *sja1110_rcv(struct sk_buff *skb,
 				   struct net_device *netdev,
 				   struct packet_type *pt)
 {
-	int source_port = -1, switch_id = -1, subvlan = 0;
+	int source_port = -1, switch_id = -1;
 
 	skb->offload_fwd_mark = 1;
 
@@ -551,7 +534,7 @@ static struct sk_buff *sja1110_rcv(struct sk_buff *skb,
 
 	/* Packets with in-band control extensions might still have RX VLANs */
 	if (likely(sja1105_skb_has_tag_8021q(skb)))
-		dsa_8021q_rcv(skb, &source_port, &switch_id, &subvlan);
+		dsa_8021q_rcv(skb, &source_port, &switch_id);
 
 	skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
 	if (!skb->dev) {
@@ -561,9 +544,6 @@ static struct sk_buff *sja1110_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
-	if (subvlan)
-		sja1105_decode_subvlan(skb, subvlan);
-
 	return skb;
 }
 
-- 
2.25.1

