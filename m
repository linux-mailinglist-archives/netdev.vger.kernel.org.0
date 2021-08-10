Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBFD3E7D4C
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 18:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbhHJQS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 12:18:28 -0400
Received: from mail-am6eur05on2080.outbound.protection.outlook.com ([40.107.22.80]:16133
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234553AbhHJQPr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 12:15:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5Zn38u1TZT2iYuCU34fE807tIc/9KwGQ/VvSL1fcFaekNcV02kf7TEqs72GgFTr7inMo9w3Ot9qwOEpSoAi9AvEKOew/ctpN82AJXS3rqqV65L8I5+RquD65NIgdVCBxC8i/gwV1Eh7fRrXt06wxf4mIv9rKDtGXNRpUuLxG2En1wpPQaJysTUJqNEHErHiU7Bks3SZtC+/D24OiMl8cLNWUdtrWnToZB5WdB6j+SbNs6XNtqIgd91TEw0BpDmBC5XlRtewWHbq+1/99K/rAL780p4s0HfHtQ8GT2w2VjfqvlgiEp/ARb/6b6WangQqEpuA4d0y27XkV0na1zIsKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QZfLfrwcf/2oOaww7/aUkUxIRwkO7Xa/ENl5e/NIB7Y=;
 b=WFrlBVQJXfoRX+yS5+7AzHUHNfGUHxohK5lZqeOCuyklzfxszEUJTrvgKWSJneef7URSxPOjvjnY+FnWnyFw4NIaBUoU1tUyWlSSAscBo+Cnfv3OdE7NgjCcxrH38b9WRZBxDJrpX1JyKcb+bVhf2WskOqb1vIOQO2B2GCbBlv8c0ioeba9B+tmtvLzie0Yek+diVBevgvihoD3W82XM12xchNvrqv25FgrvPLGWtEQRTojHEwYDvU+umtTrFUbf9XY/3jtTxYxLdi+IkzIqVQ7Osga6Dv/Ey+Ox2QQx7U25oJWDevfoc6HTLktQVk+eyV2qEq6U/nup8dxJu1Hxdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QZfLfrwcf/2oOaww7/aUkUxIRwkO7Xa/ENl5e/NIB7Y=;
 b=lnzY8ANyXHyPrvEgi6VXtTHLEUgxHdBcGuxlC1DPbDZG8NeLlZg53LuYXDFBsr9wRDCnrReSV+hmQ8NfMm2LhFz+82gNn2KyVJafS6W3CUeHr8mii9LpQ4m6WsIoPXgj7odXzwJve029wD0wfD1MoY6UxfZN9Cc2XqGuWDLSo6M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 16:15:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 16:15:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: [RFC PATCH v2 net-next 2/8] net: dsa: remove the "dsa_to_port in a loop" antipattern from the core
Date:   Tue, 10 Aug 2021 19:14:42 +0300
Message-Id: <20210810161448.1879192-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810161448.1879192-1-vladimir.oltean@nxp.com>
References: <20210810161448.1879192-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 16:15:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 985c3726-836a-4816-ee8a-08d95c1a041a
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2800:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2800057D9C8383C29651D2F3E0F79@VI1PR0402MB2800.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8RQAxRzBhHI0VDilRLxiRdudRhD5jlrP39IwKFyGZ0PhJuUoKsUBJqnYGClKSol2cQ4wprfm96hnwhu3xGOBzCnuhgvHfVnrtXPrLFrpMrn7XXPv4hZypFohdHgRC/XDAc1zBe976v+bnTY9wi5eaAjD6Wp4qcqnj++icjiqPV6vRcuICs7yzljKFFLTFsowTX2ogFdU6FQaS7kHNLIyHMdCVujJNcDbCZsGmWrJywIW2qSA8eEYRjVyq7HYWClUmThUWSYbCl87nKCIIAZ6E0HLZxheLoJkfOj39K1/nVJoFO+ZYZNXXtjG0EzCWLrPDEUy/xNNQsAToUZ0zjHk4UDsD+oj/IT+I3ABfbVji/eESRixu5pxMxIuNevFk3m41SDz+k+x/c9QUcXuKLHAWu7w4lx9DnptAdrMtw3vl+STxsqwIIEBXeRHThvqS2JtXySKUUFPP4zalzq7zCNTsiPDPii6iU/8D1Xpmw5jBwAjpt+wQgmmGSUsFSbFYpezbzImzro83ccu19vbCpy/IjXRcdiSWwH5Ur8u6LY5rQ2+Mty67hq8VbsrP5DG1m6uSu7v/P/7x6d5d1TVOzcS9FhVQ4yW8+GE8qWI/Qlgd8FNhULYqg/LIIEcd3zMwTJ+Ywo/AdZYu7JF5YR42L2unKC+5huwLbjLgcfNRixZUJwLE0eDhetUINRUnam+hzL1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(6506007)(52116002)(6512007)(86362001)(110136005)(478600001)(8676002)(2906002)(956004)(83380400001)(54906003)(26005)(1076003)(8936002)(6486002)(316002)(36756003)(7416002)(30864003)(186003)(66946007)(5660300002)(66556008)(66476007)(44832011)(2616005)(6666004)(4326008)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BH0Xf9iC/2Tmqm4EnF7gx1RXBjrQo7EZjouRN343huRxz0F2PBEADBnQ5gG9?=
 =?us-ascii?Q?tQtCTJeDB5GE2ZS9pxdcHJSVVqogEQx1RQEPkmSawpdEeGBtTTIyrIjCMare?=
 =?us-ascii?Q?IqWeUPhjTJDCxbV7q+jShten2BikG/BBZysD+/JLHgy7ujkXXF20MlVvViTi?=
 =?us-ascii?Q?CEhNuGbTcXhecCLXb21FWJlpRL7YpdRthDtmZbzhdErg4XhPWDMCySHs+JoO?=
 =?us-ascii?Q?VAUB9mZ9YReUWohibu+fSWKBVsivXcE0Dr/MyMKL8MoG2zjguyVd8DX1H57F?=
 =?us-ascii?Q?zJp2hzKW9HFhPku3hpZFvlu55HhDGUR9oB8Gq44EsrLqT6hJw38/qF4r9qEw?=
 =?us-ascii?Q?uZYtJXwIDyv+TWbr2Un6m5JYTGtMYYDFXpLAN6DdrM/bzTzEWp20EazH+3VR?=
 =?us-ascii?Q?DhpHVDqFjbRR2E/Dw3qdSDDbTbywxJwDkviJDJQEuCzfumY6ZVujjwrDETeq?=
 =?us-ascii?Q?J/id4MD3jILMyWotJLP5cahnP99wpZr7HMlVUXvvNlvz3MTvU4yZ4hgiItH7?=
 =?us-ascii?Q?a7honDrIospSaV0mNZbTlRFx9e7i0O8Slk1pvYbmHbdv8lMLSwUy2CfpeluE?=
 =?us-ascii?Q?CZoi0Qp9ecjwufBHWcZlz/4cLjsp+qXDQIQOTulJbGLRoQ7ZbKvm6YNvDAgX?=
 =?us-ascii?Q?9l3YAU+naurEFrvUeUs3M9U8fCPwuqc5LiWZ7wEjj+95DX0zi+qSqpWdG9h+?=
 =?us-ascii?Q?+NcCqcX1WGU0sTUnLBTrByJcvNVQKwbxmoGEb/rZg2xuIPiCdrppKGOfVFTy?=
 =?us-ascii?Q?2+lflu/erO2SBgrn2rPCTCD3Ijd9efI1bnEbr+bslNbKlmsm2W1of7KpO25x?=
 =?us-ascii?Q?FeqetMWvz1Z4n+2n/7LrFY5VYMrVGwH0K9MrOijv5PePiUcC34nXx9mZ2Pop?=
 =?us-ascii?Q?jq+9ldfUzyp+eT6xoqghRdqa3Vog4zCbKgQQMkK4kODO4MZNwvYE3y9hdOJs?=
 =?us-ascii?Q?fEM4oRSw2Tb+EPgnVsUprAzv0QNDIn+DbGTQl4SuWvG3sENUhVVWLVoJUR2h?=
 =?us-ascii?Q?i6Q9HkTeCIy1toDS+jv+UOGgrNKvIADzmXbhsihRltFWRHilElzNxTUpNtFY?=
 =?us-ascii?Q?oG7LXFx+M2OnO+hZ7CRY6dAjBB+1qC7v+Ggempb9Q/lf6HbXRBr3+nurlqYB?=
 =?us-ascii?Q?Jw/reCQmoKuFwAdmsJ6d0GqRcdX+gV+2C7ch3CIta44QFCDpaf7/Y45q+Y6k?=
 =?us-ascii?Q?sQtAXv9gZuK90tJjeCs0vcGE6mmh3eOgpx544VH3QXvajk1j1GJI4ZOEDGBh?=
 =?us-ascii?Q?KkrIfS8op0vBntyHh7dSCJ5RkokYvqJe77k9YeZCafv+SkBPf0iufNxzzym0?=
 =?us-ascii?Q?8dmqOfy5o3Xnkdb5vjkRinme?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 985c3726-836a-4816-ee8a-08d95c1a041a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 16:15:05.9543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hjwlAP4ccWbARUk1GmMw3LTai79e52d/Vn+NiYV9eHxFM9qjSJ3MjDO4Rgguj1lt1lp6DZ7NF7YwHMCgYwsnEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ever since Vivien's conversion of the ds->ports array into a dst->ports
list, and the introduction of dsa_to_port, iterations through the ports
of a switch became quadratic whenever dsa_to_port was needed.

dsa_to_port can either be called directly, or indirectly through the
dsa_is_{user,cpu,dsa,unused}_port helpers.

Introduce a basic switch port iterator macro, dsa_switch_for_each_port,
that works with the iterator variable being a struct dsa_port *dp
directly, and not an int i. It is an expensive variable to go from i to
dp, but cheap to go from dp to i.

This macro iterates through the entire ds->dst->ports list and filters
by the ports belonging just to the switch provided as argument.

While at it, provide some more flavors of that macro which filter for
specific types of ports: at the moment just user ports and CPU ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: two more conversions of dsa_port_is_user

 include/net/dsa.h   | 19 +++++++++++++++----
 net/dsa/dsa.c       | 22 +++++++++++-----------
 net/dsa/dsa2.c      | 13 ++++++-------
 net/dsa/port.c      |  7 ++++---
 net/dsa/slave.c     |  2 +-
 net/dsa/switch.c    | 41 ++++++++++++++++++-----------------------
 net/dsa/tag_8021q.c | 29 +++++++++++++----------------
 7 files changed, 68 insertions(+), 65 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index d05c71a92715..4639a82bab66 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -471,14 +471,25 @@ static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
 	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_USER;
 }
 
+#define dsa_switch_for_each_port(_dp, _ds) \
+	list_for_each_entry((_dp), &(_ds)->dst->ports, list) \
+		if ((_dp)->ds == (_ds))
+
+#define dsa_switch_for_each_user_port(_dp, _ds) \
+	dsa_switch_for_each_port((_dp), (_ds)) \
+		if (dsa_port_is_user((_dp)))
+
+#define dsa_switch_for_each_cpu_port(_dp, _ds) \
+	dsa_switch_for_each_port((_dp), (_ds)) \
+		if (dsa_port_is_cpu((_dp)))
+
 static inline u32 dsa_user_ports(struct dsa_switch *ds)
 {
+	struct dsa_port *dp;
 	u32 mask = 0;
-	int p;
 
-	for (p = 0; p < ds->num_ports; p++)
-		if (dsa_is_user_port(ds, p))
-			mask |= BIT(p);
+	dsa_switch_for_each_user_port(dp, ds)
+		mask |= BIT(dp->index);
 
 	return mask;
 }
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 5e73332a9707..8104f2382988 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -280,23 +280,22 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 }
 
 #ifdef CONFIG_PM_SLEEP
-static bool dsa_is_port_initialized(struct dsa_switch *ds, int p)
+static bool dsa_port_is_initialized(const struct dsa_port *dp)
 {
-	const struct dsa_port *dp = dsa_to_port(ds, p);
-
 	return dp->type == DSA_PORT_TYPE_USER && dp->slave;
 }
 
 int dsa_switch_suspend(struct dsa_switch *ds)
 {
-	int i, ret = 0;
+	struct dsa_port *dp;
+	int ret = 0;
 
 	/* Suspend slave network devices */
-	for (i = 0; i < ds->num_ports; i++) {
-		if (!dsa_is_port_initialized(ds, i))
+	dsa_switch_for_each_port(dp, ds) {
+		if (!dsa_port_is_initialized(dp))
 			continue;
 
-		ret = dsa_slave_suspend(dsa_to_port(ds, i)->slave);
+		ret = dsa_slave_suspend(dp->slave);
 		if (ret)
 			return ret;
 	}
@@ -310,7 +309,8 @@ EXPORT_SYMBOL_GPL(dsa_switch_suspend);
 
 int dsa_switch_resume(struct dsa_switch *ds)
 {
-	int i, ret = 0;
+	struct dsa_port *dp;
+	int ret = 0;
 
 	if (ds->ops->resume)
 		ret = ds->ops->resume(ds);
@@ -319,11 +319,11 @@ int dsa_switch_resume(struct dsa_switch *ds)
 		return ret;
 
 	/* Resume slave network devices */
-	for (i = 0; i < ds->num_ports; i++) {
-		if (!dsa_is_port_initialized(ds, i))
+	dsa_switch_for_each_port(dp, ds) {
+		if (!dsa_port_is_initialized(dp))
 			continue;
 
-		ret = dsa_slave_resume(dsa_to_port(ds, i)->slave);
+		ret = dsa_slave_resume(dp->slave);
 		if (ret)
 			return ret;
 	}
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 8150e16aaa55..cf9810d55611 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -707,16 +707,15 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 {
 	const struct dsa_device_ops *tag_ops = ds->dst->tag_ops;
 	struct dsa_switch_tree *dst = ds->dst;
-	int port, err;
+	struct dsa_port *cpu_dp;
+	int err;
 
 	if (tag_ops->proto == dst->default_proto)
 		return 0;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (!dsa_is_cpu_port(ds, port))
-			continue;
-
-		err = ds->ops->change_tag_protocol(ds, port, tag_ops->proto);
+	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
+		err = ds->ops->change_tag_protocol(ds, cpu_dp->index,
+						   tag_ops->proto);
 		if (err) {
 			dev_err(ds->dev, "Unable to use tag protocol \"%s\": %pe\n",
 				tag_ops->name, ERR_PTR(err));
@@ -1040,7 +1039,7 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 		goto out_unlock;
 
 	list_for_each_entry(dp, &dst->ports, list) {
-		if (!dsa_is_user_port(dp->ds, dp->index))
+		if (!dsa_port_is_user(dp))
 			continue;
 
 		if (dp->slave->flags & IFF_UP)
diff --git a/net/dsa/port.c b/net/dsa/port.c
index eedd9881e1ba..05b902d69863 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -540,7 +540,8 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 					      struct netlink_ext_ack *extack)
 {
 	struct dsa_switch *ds = dp->ds;
-	int err, i;
+	struct dsa_port *other_dp;
+	int err;
 
 	/* VLAN awareness was off, so the question is "can we turn it on".
 	 * We may have had 8021q uppers, those need to go. Make sure we don't
@@ -582,10 +583,10 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 	 * different ports of the same switch device and one of them has a
 	 * different setting than what is being requested.
 	 */
-	for (i = 0; i < ds->num_ports; i++) {
+	dsa_switch_for_each_port(other_dp, ds) {
 		struct net_device *other_bridge;
 
-		other_bridge = dsa_to_port(ds, i)->bridge_dev;
+		other_bridge = other_dp->bridge_dev;
 		if (!other_bridge)
 			continue;
 		/* If it's the same bridge, it also has same
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 7674f788d563..2f6a2e7d24c0 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2266,7 +2266,7 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		dst = cpu_dp->ds->dst;
 
 		list_for_each_entry(dp, &dst->ports, list) {
-			if (!dsa_is_user_port(dp->ds, dp->index))
+			if (!dsa_port_is_user(dp))
 				continue;
 
 			list_add(&dp->slave->close_list, &close_list);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index fd1a1c6bf9cf..5ddcf37ecfa5 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -17,14 +17,11 @@
 static unsigned int dsa_switch_fastest_ageing_time(struct dsa_switch *ds,
 						   unsigned int ageing_time)
 {
-	int i;
-
-	for (i = 0; i < ds->num_ports; ++i) {
-		struct dsa_port *dp = dsa_to_port(ds, i);
+	struct dsa_port *dp;
 
+	dsa_switch_for_each_port(dp, ds)
 		if (dp->ageing_time && dp->ageing_time < ageing_time)
 			ageing_time = dp->ageing_time;
-	}
 
 	return ageing_time;
 }
@@ -117,7 +114,8 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	bool unset_vlan_filtering = br_vlan_enabled(info->br);
 	struct dsa_switch_tree *dst = ds->dst;
 	struct netlink_ext_ack extack = {0};
-	int err, port;
+	struct dsa_port *dp;
+	int err;
 
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
 	    ds->ops->port_bridge_leave)
@@ -138,10 +136,10 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	 * VLAN-aware bridge.
 	 */
 	if (unset_vlan_filtering && ds->vlan_filtering_is_global) {
-		for (port = 0; port < ds->num_ports; port++) {
+		dsa_switch_for_each_port(dp, ds) {
 			struct net_device *bridge_dev;
 
-			bridge_dev = dsa_to_port(ds, port)->bridge_dev;
+			bridge_dev = dp->bridge_dev;
 
 			if (bridge_dev && br_vlan_enabled(bridge_dev)) {
 				unset_vlan_filtering = false;
@@ -566,38 +564,35 @@ static int dsa_switch_change_tag_proto(struct dsa_switch *ds,
 				       struct dsa_notifier_tag_proto_info *info)
 {
 	const struct dsa_device_ops *tag_ops = info->tag_ops;
-	int port, err;
+	struct dsa_port *dp, *cpu_dp;
+	int err;
 
 	if (!ds->ops->change_tag_protocol)
 		return -EOPNOTSUPP;
 
 	ASSERT_RTNL();
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (!dsa_is_cpu_port(ds, port))
-			continue;
-
-		err = ds->ops->change_tag_protocol(ds, port, tag_ops->proto);
+	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
+		err = ds->ops->change_tag_protocol(ds, cpu_dp->index,
+						   tag_ops->proto);
 		if (err)
 			return err;
 
-		dsa_port_set_tag_protocol(dsa_to_port(ds, port), tag_ops);
+		dsa_port_set_tag_protocol(cpu_dp, tag_ops);
 	}
 
 	/* Now that changing the tag protocol can no longer fail, let's update
 	 * the remaining bits which are "duplicated for faster access", and the
 	 * bits that depend on the tagger, such as the MTU.
 	 */
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_is_user_port(ds, port)) {
-			struct net_device *slave;
+	dsa_switch_for_each_user_port(dp, ds) {
+		struct net_device *slave;
 
-			slave = dsa_to_port(ds, port)->slave;
-			dsa_slave_setup_tagger(slave);
+		slave = dp->slave;
+		dsa_slave_setup_tagger(slave);
 
-			/* rtnl_mutex is held in dsa_tree_change_tag_proto */
-			dsa_slave_change_mtu(slave, slave->mtu);
-		}
+		/* rtnl_mutex is held in dsa_tree_change_tag_proto */
+		dsa_slave_change_mtu(slave, slave->mtu);
 	}
 
 	return 0;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 654697ebb6f3..b29f4eb9aed1 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -322,15 +322,13 @@ int dsa_switch_tag_8021q_vlan_del(struct dsa_switch *ds,
  * +-+-----+-+-----+-+-----+-+-----+-+    +-+-----+-+-----+-+-----+-+-----+-+
  *   swp0    swp1    swp2    swp3           swp0    swp1    swp2    swp3
  */
-static bool dsa_tag_8021q_bridge_match(struct dsa_switch *ds, int port,
+static bool dsa_tag_8021q_bridge_match(struct dsa_port *dp,
 				       struct dsa_notifier_bridge_info *info)
 {
-	struct dsa_port *dp = dsa_to_port(ds, port);
-
 	/* Don't match on self */
-	if (ds->dst->index == info->tree_index &&
-	    ds->index == info->sw_index &&
-	    port == info->port)
+	if (dp->ds->dst->index == info->tree_index &&
+	    dp->ds->index == info->sw_index &&
+	    dp->index == info->port)
 		return false;
 
 	if (dsa_port_is_user(dp))
@@ -344,8 +342,9 @@ int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
 {
 	struct dsa_switch *targeted_ds;
 	struct dsa_port *targeted_dp;
+	struct dsa_port *dp;
 	u16 targeted_rx_vid;
-	int err, port;
+	int err;
 
 	if (!ds->tag_8021q_ctx)
 		return 0;
@@ -354,11 +353,10 @@ int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
 	targeted_dp = dsa_to_port(targeted_ds, info->port);
 	targeted_rx_vid = dsa_8021q_rx_vid(targeted_ds, info->port);
 
-	for (port = 0; port < ds->num_ports; port++) {
-		struct dsa_port *dp = dsa_to_port(ds, port);
-		u16 rx_vid = dsa_8021q_rx_vid(ds, port);
+	dsa_switch_for_each_port(dp, ds) {
+		u16 rx_vid = dsa_8021q_rx_vid(ds, dp->index);
 
-		if (!dsa_tag_8021q_bridge_match(ds, port, info))
+		if (!dsa_tag_8021q_bridge_match(dp, info))
 			continue;
 
 		/* Install the RX VID of the targeted port in our VLAN table */
@@ -380,8 +378,8 @@ int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
 {
 	struct dsa_switch *targeted_ds;
 	struct dsa_port *targeted_dp;
+	struct dsa_port *dp;
 	u16 targeted_rx_vid;
-	int port;
 
 	if (!ds->tag_8021q_ctx)
 		return 0;
@@ -390,11 +388,10 @@ int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
 	targeted_dp = dsa_to_port(targeted_ds, info->port);
 	targeted_rx_vid = dsa_8021q_rx_vid(targeted_ds, info->port);
 
-	for (port = 0; port < ds->num_ports; port++) {
-		struct dsa_port *dp = dsa_to_port(ds, port);
-		u16 rx_vid = dsa_8021q_rx_vid(ds, port);
+	dsa_switch_for_each_port(dp, ds) {
+		u16 rx_vid = dsa_8021q_rx_vid(ds, dp->index);
 
-		if (!dsa_tag_8021q_bridge_match(ds, port, info))
+		if (!dsa_tag_8021q_bridge_match(dp, info))
 			continue;
 
 		/* Remove the RX VID of the targeted port from our VLAN table */
-- 
2.25.1

