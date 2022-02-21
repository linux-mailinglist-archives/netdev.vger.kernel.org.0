Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850D54BEC8C
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbiBUVYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:24:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234674AbiBUVYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:24:30 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2053.outbound.protection.outlook.com [40.107.21.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E9010FD7
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 13:24:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ogp815Zua6yZxB3kzSkSmTN/12bZ1lzQZCiUQookL9+bzk6rcezsOMFdr84a/W+r5BgSoWeioESEQ4lzYSRlRDvY9ZmPOtwHqdXnCIpXYlaQiKsrM7MC+N/UEDMuXDrDEnfL+2wXjbVSiKZ/YoeMQf0HFJhvtjeIHrjsrMIQAcBc88rbbzrK7IiNlnR6oRfJwBTAmMRlNR0rsznSbVVumCfP+JKGjVpViCV7LAGfwrMjoXK8P+UVdC2lvWrtkF1NnMF4vXg+jp/pWgLa7kaxBWup9kDbIsHqXGMb1ObTlcOYTvtf4rtOKS+ZDL4g//+u7YF+AQCX1VxiOnwg5yDTAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TjwMRxOBKwnU0kBE7mJm20Zo4qORl61j3cdWVTvxjy0=;
 b=LPLNJ5fUYoDm2eEkdR1NVXJcqNfPbjNwzo1S/VSNxwoPcnbPEPHL8hpZ1Z9kdnnMfUc8HFOEQ195sF3zRqrCilYj+F1uJuPof1LcAvEigrkOLSIxQebCMEMUpbDGuvrOjOwULbFb30qIpFTABw4OkeH5wh0Ee8fPq6sZbOClm/OplEUu5vCrNGZX+5wK1RqTnhsO871/QAxuY6OP2wBQyXNLt65occE98hsGU4GylIqSknYZGtgXPPPqAeteHvTKyLcdNQKC6Vrif9Uqaac+AaRHDmfSu9JNZP/0MpdCnM4RAenAogECGxYSy9DAIgKH75YKRgkmwGBg7/fbJNmc1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TjwMRxOBKwnU0kBE7mJm20Zo4qORl61j3cdWVTvxjy0=;
 b=TEofYU4q04jbeuU3Rhe32ZKOhvv6q/wgMIFq13v/TT3ZN4o+w5QDphP1ye60NI04wBCwH+3RkT5592Wt8+/Nqr4Fpn9PBQpFJ1DVsvdEv+cRA5/H8euh5wDnXy2ixZJyMyPofJm/o7z80LX3ucDdexTvsMmy8dAMhlLvuW/YnKQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5645.eurprd04.prod.outlook.com (2603:10a6:803:df::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 21:24:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 21:24:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v4 net-next 01/11] net: dsa: rename references to "lag" as "lag_dev"
Date:   Mon, 21 Feb 2022 23:23:27 +0200
Message-Id: <20220221212337.2034956-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
References: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0701CA0017.eurprd07.prod.outlook.com
 (2603:10a6:203:51::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55b70b1f-13df-4e64-1748-08d9f5807b41
X-MS-TrafficTypeDiagnostic: VI1PR04MB5645:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5645B7349C612CC99EF4B1D3E03A9@VI1PR04MB5645.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1bi8B1PtjeYo5OO69Kk7nzpUPb9BU1OGNIA4N9foKuxe0q5dUpbgSljYOqY+yPUIbpADL3Oedg/jKYyjRmm3lEpo+Ev1SxWiUsxEbekBNilaAK31+lVGNAN3aWUAWDaDAF9MoeSD532tgtUJ4Dcz6bGiFLZN+ks5xE8yS24k9BSC1bCis5o3/EyVweacbTjS24/O+lnf98qYxP2dDKuWWjsfylykmUcYTu3X2qYuCmqakb6hgZg1g7wdlKr7392H+0fSHMWemVzo4i+fVSIcLxJhitbvVc67WPzps+zhrvRzzXYjtLp1dJCLuMwXkih30I5tl2RT3of+cN5beKOwWjzTcKxc00DsXtnAMhHvsqHqFYyi6qxx2IBxc464kfeXvxcannrt/aVoKyg+DqsbbEc+CIyzFYF2vn4gzdaHdsQyb3FFUo5Bn0zLSsCKSOCXH0mHwxGemoqc/Yf1kj3ALMGxeChOOM43SPYHlBO94FUJqAjfr5mwujlU0LlELHaex7PaoEgWJy8vC/k8jVOYCiyMuh3NxZwggYCMddEcJ7E3hdxhxHCN2YypQVf+rYqwDAFKxbOr7+a+3KQEjykjqsrdGlRkF9p+LbYeITMeau3yuXOF2IeMwtOSfJ1QxKL/BzcHEjxAOb4miveid3U3eHvSMX4Ki9yfJznkVqI4o1SQ/VTJqw44q7oEZkYXBOcJ/4p6z7TO7FpzFTRzN6d6Kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(66476007)(1076003)(66556008)(26005)(186003)(66946007)(6486002)(2616005)(508600001)(316002)(6512007)(38350700002)(38100700002)(86362001)(83380400001)(2906002)(44832011)(6506007)(54906003)(7416002)(6916009)(8936002)(5660300002)(36756003)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XdYX3Wh95OgINOI/GRYMQ3Ih3y5AJ2J7rfi/F8gew19XEY9wEkAWZx8OKpjV?=
 =?us-ascii?Q?4hnZgwGTkUgEFx7C9T+O3T46L01KQ5NNCG2EMVtWKEB93d8ZbUATf2y+H+mL?=
 =?us-ascii?Q?gB9p9TOxxhxB17OiUvhmuqe3NGdbXrXpsrsw1TdnlFy4z5XEPl4NnTDFDSsC?=
 =?us-ascii?Q?+vag6uYlaFoo+m/8GM2flPM1Sfm0753koUlgkDtJZVzJfbczeHG+u99uwdXk?=
 =?us-ascii?Q?aPXW/7DI9eKRVs9sQGBK5kzJbya0N6dcOlTJ3SWC9xi1b5XM9jtUaAXT4c2y?=
 =?us-ascii?Q?YjoW1nCetJ6PHAOfJoYfaj5aYG8OKWOkkb1Po0NbyJXN87v1sb2JSwl7Y6sl?=
 =?us-ascii?Q?NWJutNncG18ZNH2Tr0Eo7MyQzWCO+Y/2e17pugvzJ3EktvW2KeV7EMe25Dj8?=
 =?us-ascii?Q?IUmBZRonmEgW4MCGDN6kN/swsozlTeSkS899cPe3FTYPZGr0bcmAIzBZU6Wg?=
 =?us-ascii?Q?8gi333y+peHPaEhl/QJ1nha0vNXl6U1iXGreW17AG0OHKMgHhlwwplu6EF0q?=
 =?us-ascii?Q?ZoJnh6RwoTnNs3m7gLpRBjgP2azt2/WyUxcgJWB6t33Ow7NIFNMin/19qRhM?=
 =?us-ascii?Q?G6Gxjxt+b3Lp55r+Kq/6nRq/CzhbpHygJ1oaORteEDXO9QIVsZyhZ+sX/NOQ?=
 =?us-ascii?Q?pPpBZQyZbUAR1vBUty0loodyrdLV6rYeU6905Q38knRLAFWMBGj5g2pxi9DR?=
 =?us-ascii?Q?upo9RPRc17LmUnrIWEbf4gVn9E2j4IA5wTf2Y8td2Of0/aYGLUqij18V8R5Q?=
 =?us-ascii?Q?9ZBkV4PUcjMK9IKC8VTHIF+rAiIxlPVds8D4DrYRpCJdgnsevFzJ20VGjqb5?=
 =?us-ascii?Q?j7eLlpwVV2WJ39VY49LlMYEB0/VFh9eEYaEXYAFSbL2uthHzp/ziLYFRADFF?=
 =?us-ascii?Q?7mtQk6jCDNwkOKX6vhSGwDj8jmEgiltfX+WkgYUPkVGYVu76LgdcsKjjBpsz?=
 =?us-ascii?Q?4dzm0TX2341vG4IJ29u2il8ZiQZpMCpFRQkKCsLh/mRKgzmPonslV0E/+PIv?=
 =?us-ascii?Q?eayqSTCyTJt0B5rt1Rf48x8AHlfS/ul4KlTCDWKilgAuou/dfwHWv/EGqACU?=
 =?us-ascii?Q?Hq2Ymw5OIXAbrShEtoRnETjEz9cT6WqotwYcK7exvWIiLXtqpWtIktK9oTrL?=
 =?us-ascii?Q?drkER4N3b7YyV8GxukfhfIhJQ5IAUqGBF0nrSFB3g+BG9HoQnhAxySE4xYbf?=
 =?us-ascii?Q?hp2uOsPWR0R0VfhtNmf4vWpMsSbxWYhxGDF27fS+t/9aOb7/k05lmBPnt3Ee?=
 =?us-ascii?Q?b1BskM4z+AVxpcG66YUPm3lvukDly7H9IHCHJyPX1RZiSdbqxPQZ2oLV261P?=
 =?us-ascii?Q?Ay6NncoZ2UXuS7L1GUf0DQfSpRd8rZNXFEKFfdkeVlpOY+pCHCBrYKDjXuvz?=
 =?us-ascii?Q?8oUjF2SGOXWVOQc0SSdqxcfrKUc1X6ZVe/XZLDQ44iF7su93Gr/MgQSAoVxl?=
 =?us-ascii?Q?dfpIxou9/Yl8OukPbJkImeAMLsE+WrvGjpoBeuQdksihSsFb4X5RVxgl4Vq3?=
 =?us-ascii?Q?xmEStHve7xrcpnKZn1Ao+WnzjTb8rjOM1vQlIXO3ka0FNZaoVqeg/IsPeiMg?=
 =?us-ascii?Q?B3wz/8/XrMdoVNwRdgHyw13yOhuuCtWKBKE8yO7nGziPVTW8o0xf0mRv0h0o?=
 =?us-ascii?Q?j421MLzGFe8xlEgvx8UN/KM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55b70b1f-13df-4e64-1748-08d9f5807b41
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 21:24:02.4618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2T3yQR0rR80ogiU74ccI6lXni3UGwPoMsC9iLdx+/pXnmUgv8fL4527xnxLK1B3doZgl2e1FyP7CiamAxqkTcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5645
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of converting struct net_device *dp->lag_dev into a
struct dsa_lag *dp->lag, we need to rename, for consistency purposes,
all occurrences of the "lag" variable in the DSA core to "lag_dev".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v4: none

 include/net/dsa.h  | 12 ++++++------
 net/dsa/dsa2.c     | 16 ++++++++--------
 net/dsa/dsa_priv.h |  6 +++---
 net/dsa/port.c     | 20 ++++++++++----------
 net/dsa/switch.c   |  8 ++++----
 5 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f13de2d8aef3..ef7f446cbdf4 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -182,12 +182,12 @@ static inline struct net_device *dsa_lag_dev(struct dsa_switch_tree *dst,
 }
 
 static inline int dsa_lag_id(struct dsa_switch_tree *dst,
-			     struct net_device *lag)
+			     struct net_device *lag_dev)
 {
 	unsigned int id;
 
 	dsa_lags_foreach_id(id, dst) {
-		if (dsa_lag_dev(dst, id) == lag)
+		if (dsa_lag_dev(dst, id) == lag_dev)
 			return id;
 	}
 
@@ -966,10 +966,10 @@ struct dsa_switch_ops {
 	int	(*crosschip_lag_change)(struct dsa_switch *ds, int sw_index,
 					int port);
 	int	(*crosschip_lag_join)(struct dsa_switch *ds, int sw_index,
-				      int port, struct net_device *lag,
+				      int port, struct net_device *lag_dev,
 				      struct netdev_lag_upper_info *info);
 	int	(*crosschip_lag_leave)(struct dsa_switch *ds, int sw_index,
-				       int port, struct net_device *lag);
+				       int port, struct net_device *lag_dev);
 
 	/*
 	 * PTP functionality
@@ -1041,10 +1041,10 @@ struct dsa_switch_ops {
 	 */
 	int	(*port_lag_change)(struct dsa_switch *ds, int port);
 	int	(*port_lag_join)(struct dsa_switch *ds, int port,
-				 struct net_device *lag,
+				 struct net_device *lag_dev,
 				 struct netdev_lag_upper_info *info);
 	int	(*port_lag_leave)(struct dsa_switch *ds, int port,
-				  struct net_device *lag);
+				  struct net_device *lag_dev);
 
 	/*
 	 * HSR integration
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 408b79a28cd4..01a8efcaabac 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -74,7 +74,7 @@ int dsa_broadcast(unsigned long e, void *v)
 /**
  * dsa_lag_map() - Map LAG netdev to a linear LAG ID
  * @dst: Tree in which to record the mapping.
- * @lag: Netdev that is to be mapped to an ID.
+ * @lag_dev: Netdev that is to be mapped to an ID.
  *
  * dsa_lag_id/dsa_lag_dev can then be used to translate between the
  * two spaces. The size of the mapping space is determined by the
@@ -82,17 +82,17 @@ int dsa_broadcast(unsigned long e, void *v)
  * it unset if it is not needed, in which case these functions become
  * no-ops.
  */
-void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag)
+void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev)
 {
 	unsigned int id;
 
-	if (dsa_lag_id(dst, lag) >= 0)
+	if (dsa_lag_id(dst, lag_dev) >= 0)
 		/* Already mapped */
 		return;
 
 	for (id = 0; id < dst->lags_len; id++) {
 		if (!dsa_lag_dev(dst, id)) {
-			dst->lags[id] = lag;
+			dst->lags[id] = lag_dev;
 			return;
 		}
 	}
@@ -108,22 +108,22 @@ void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag)
 /**
  * dsa_lag_unmap() - Remove a LAG ID mapping
  * @dst: Tree in which the mapping is recorded.
- * @lag: Netdev that was mapped.
+ * @lag_dev: Netdev that was mapped.
  *
  * As there may be multiple users of the mapping, it is only removed
  * if there are no other references to it.
  */
-void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag)
+void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag_dev)
 {
 	struct dsa_port *dp;
 	unsigned int id;
 
-	dsa_lag_foreach_port(dp, dst, lag)
+	dsa_lag_foreach_port(dp, dst, lag_dev)
 		/* There are remaining users of this mapping */
 		return;
 
 	dsa_lags_foreach_id(id, dst) {
-		if (dsa_lag_dev(dst, id) == lag) {
+		if (dsa_lag_dev(dst, id) == lag_dev) {
 			dst->lags[id] = NULL;
 			break;
 		}
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index a37f0883676a..0293a749b3ac 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -76,7 +76,7 @@ struct dsa_notifier_mdb_info {
 
 /* DSA_NOTIFIER_LAG_* */
 struct dsa_notifier_lag_info {
-	struct net_device *lag;
+	struct net_device *lag_dev;
 	int sw_index;
 	int port;
 
@@ -487,8 +487,8 @@ int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
 
 /* dsa2.c */
-void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag);
-void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag);
+void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev);
+void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag_dev);
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_broadcast(unsigned long e, void *v);
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 8ce5b259ee95..9ee1236bf3b3 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -447,27 +447,27 @@ int dsa_port_lag_change(struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_CHANGE, &info);
 }
 
-int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
+int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 		      struct netdev_lag_upper_info *uinfo,
 		      struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_lag_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.lag = lag,
+		.lag_dev = lag_dev,
 		.info = uinfo,
 	};
 	struct net_device *bridge_dev;
 	int err;
 
-	dsa_lag_map(dp->ds->dst, lag);
-	dp->lag_dev = lag;
+	dsa_lag_map(dp->ds->dst, lag_dev);
+	dp->lag_dev = lag_dev;
 
 	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_JOIN, &info);
 	if (err)
 		goto err_lag_join;
 
-	bridge_dev = netdev_master_upper_dev_get(lag);
+	bridge_dev = netdev_master_upper_dev_get(lag_dev);
 	if (!bridge_dev || !netif_is_bridge_master(bridge_dev))
 		return 0;
 
@@ -481,11 +481,11 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
 	dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
 err_lag_join:
 	dp->lag_dev = NULL;
-	dsa_lag_unmap(dp->ds->dst, lag);
+	dsa_lag_unmap(dp->ds->dst, lag_dev);
 	return err;
 }
 
-void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag)
+void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag_dev)
 {
 	struct net_device *br = dsa_port_bridge_dev_get(dp);
 
@@ -493,13 +493,13 @@ void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag)
 		dsa_port_pre_bridge_leave(dp, br);
 }
 
-void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
+void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev)
 {
 	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct dsa_notifier_lag_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.lag = lag,
+		.lag_dev = lag_dev,
 	};
 	int err;
 
@@ -521,7 +521,7 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
 			"port %d failed to notify DSA_NOTIFIER_LAG_LEAVE: %pe\n",
 			dp->index, ERR_PTR(err));
 
-	dsa_lag_unmap(dp->ds->dst, lag);
+	dsa_lag_unmap(dp->ds->dst, lag_dev);
 }
 
 /* Must be called under rcu_read_lock() */
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 0bb3987bd4e6..c71bade9269e 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -468,12 +468,12 @@ static int dsa_switch_lag_join(struct dsa_switch *ds,
 			       struct dsa_notifier_lag_info *info)
 {
 	if (ds->index == info->sw_index && ds->ops->port_lag_join)
-		return ds->ops->port_lag_join(ds, info->port, info->lag,
+		return ds->ops->port_lag_join(ds, info->port, info->lag_dev,
 					      info->info);
 
 	if (ds->index != info->sw_index && ds->ops->crosschip_lag_join)
 		return ds->ops->crosschip_lag_join(ds, info->sw_index,
-						   info->port, info->lag,
+						   info->port, info->lag_dev,
 						   info->info);
 
 	return -EOPNOTSUPP;
@@ -483,11 +483,11 @@ static int dsa_switch_lag_leave(struct dsa_switch *ds,
 				struct dsa_notifier_lag_info *info)
 {
 	if (ds->index == info->sw_index && ds->ops->port_lag_leave)
-		return ds->ops->port_lag_leave(ds, info->port, info->lag);
+		return ds->ops->port_lag_leave(ds, info->port, info->lag_dev);
 
 	if (ds->index != info->sw_index && ds->ops->crosschip_lag_leave)
 		return ds->ops->crosschip_lag_leave(ds, info->sw_index,
-						    info->port, info->lag);
+						    info->port, info->lag_dev);
 
 	return -EOPNOTSUPP;
 }
-- 
2.25.1

