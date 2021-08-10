Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8A63E7D52
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 18:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbhHJQSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 12:18:25 -0400
Received: from mail-am6eur05on2081.outbound.protection.outlook.com ([40.107.22.81]:23521
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234563AbhHJQPr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 12:15:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hjIXnAh9A5cWZ8tqcnQIimOxoM+6Ue6nsmRnZ08M86cAOuykyFp6JwZRF8VDfPZ3UcTyWiYHi55ykBzeuBGAV7TutPNMyVNiwSicVesJ01l1wM4VLj3vfWxbPzJa+jNUFEij7IsKl5S0RIgOIg/cn2WsbG98zkjYt3R3tHT7yIe0s1VW79eIjjsRIp1XcelXIYYpHjSdyYqoaKLZfLEKYriVhyEWMgSXWl7kFQAgRkvdf7dA+Gxdb1kh46XXYFYSnFxhdLU/9PhzAUm20M5AnBzGbd+rqHyGfEBfc9eN9ljO94d44bYZqPcSoIpS98ySSQxOUodeDnYlvl7M6/3/5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJlmxUCfbDE+OMVdfCypNOtR2YblOD41FiQZE1YbSk0=;
 b=oTod03SUwTrC09yMLa32PmeF7TrgmsvIpDp9uaayeEeoEtd0bp/z6RZXtFJ2z+R6FB8q3ETu8RkXusltnOYHsXILYfXReuJIg/WMgun9Em4aJ2LEUHinfMWrG0nT3OJVe2rTji/waBMEVrJyA7uQQcmo8eRYLLtOyBHlAliRghwtPElLoDpBTORmrq0SXP4Y/f358jhNMoEDYtNG7zMJGwdRwdZTsPU5Po7pEh4uYEp20LKSH1m9oTzmt1Co8R3Z1fPp2+6TGaxJTXxEsLoJrA97qWM5Bnn5kWLlQ3uCv7qch3PJeLeBxBZU6G4D6JcuTio6mQssZ0mFsyTMdf1sUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJlmxUCfbDE+OMVdfCypNOtR2YblOD41FiQZE1YbSk0=;
 b=lRzvp+auqX6bCLfdjy6gyyYp4I6qzo1OU6FgY3cV0knM7nF93HeXKv3jvpvVyxl2eBVA935Q7Py6GKg/P7acVbxSKAYloXaqGU4mWAX4mLgRYBYuefWpdHDfvTURVrzo4lkU529PUq77urn30R71vKexPHX5gZslVWZqGCNK8DY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 16:15:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 16:15:09 +0000
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
Subject: [RFC PATCH v2 net-next 4/8] net: dsa: b53: express b53_for_each_port in terms of dsa_switch_for_each_port
Date:   Tue, 10 Aug 2021 19:14:44 +0300
Message-Id: <20210810161448.1879192-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810161448.1879192-1-vladimir.oltean@nxp.com>
References: <20210810161448.1879192-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 16:15:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8a4ecf5-b2d2-4889-c2a6-08d95c1a060d
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2800:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28003C2F89C0180A0D035CCFE0F79@VI1PR0402MB2800.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S9/MoVCcrwidKXCca7BFUSwn23kQ99hQrk8v9lDkvTPmkZvRvoYl9/DEv5G0FgpEC0f9f3+KnGdDScUgLcxWIfiUdTdriXM9AVTh9im5ZQQT3pnk+E9VnCbja9CKYJ32wyWBzQC+q+3wjfToJNl3g4yYiFVxYqfvsF9dDrlSozIcr7Omil2++igAdFFrghp3L05NkgQA2Z10L6/DGUogZD2CBOTg60+HQuN/QECZvlpUOZDjmZlI/SWkpskh8mrfBWeu4OIIyceQxO2NgLRfZUvD0cd1WmYRUNzXTRv6yT21Az/p7IVUsK0VgVqwsuxmXAe59ay7nFt8HWZ5r4ChlGb0Tzm0DX/LPnG2ghVkr1Qa2SmxlyAKgTHiDWyYpOeOF0ll/HqucC3oQ+QZn+yzMe0YE0zOIWBqXtjutRpRCoPuL9VA+Sk5Y1oMfc5dPpGqFFNp96SiXBvm0AfbLi+kfqRfJZ6u+Btp+rVGq3bQJaEHI9VK35Cu+VcmzQPO+PQmWedSYa41BSWhhSELfZaY0eG+yxHhXdEkcFh3qd2IK8pbw0ic2Ex02KkK6JTsidN5ZOYEgFNfdY1u1gqDQyLnr5i3qD4ilY/990lIUZnF3eNw8YrEH+RoQbTgYBqZxFuaZ5e5PhNU9KlFSL5+esdBtgRJRYmCWTO7TsofkIOmoqfI0tbSitR1UTo+LwxOfPf84rkewX/RQZ91mRbSLsgWUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(6506007)(52116002)(6512007)(86362001)(110136005)(478600001)(8676002)(2906002)(956004)(83380400001)(54906003)(26005)(1076003)(8936002)(6486002)(316002)(36756003)(7416002)(186003)(66946007)(5660300002)(66556008)(66476007)(44832011)(2616005)(6666004)(4326008)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U5hLL+2Gh4D8AvNz68ZvzB66auDERDgGwh8lSLgdD917IdSwgLRD/8Y8G/Vp?=
 =?us-ascii?Q?+20S74T975w709kSPz4DycFjdiTG/d+vmlsQ25CSgVBWEZo3REBSLFenH8QT?=
 =?us-ascii?Q?+/ZRWIYB46nFoB28JS7FRRoDc4gIvlNfO+rvuWx1T7V88FA5z1IcicdI3rZy?=
 =?us-ascii?Q?kIdVvtlA1LfpycmojONfx/L/lwUQCLrkIRUWmo+bqQw7bVZRezI3EE7JW+X3?=
 =?us-ascii?Q?oqC85nxlhNZXEI1SX/9Jbp285Ifh9X651FxXJHvGA2Wgev/sJvabpVjGwctE?=
 =?us-ascii?Q?n6gEZgR1yrc3X4f8mXq0cXcfelPscQnJNtwPrWEzuJdOsWnaAnCWbhsqGbil?=
 =?us-ascii?Q?OESE7A1OhFTJppJk5Icd+oo+YjPx4PMOYte59YsHDmXpqTMeiTA1z/1gYMqX?=
 =?us-ascii?Q?LiSDaadGsDy3TKvQ9oMQDX+Ld+9BkJYgKRknB91JOodIswmHTJP6lVZUeI60?=
 =?us-ascii?Q?cUSBlEN4cFiLOEVPyhiAZxoAvQLhlmsYgBymwheN2EOtaZfFHh6BurC7IWDk?=
 =?us-ascii?Q?ljs1wy3p6rqSxVVEgwYV/XQfwjkDYMzhE82bZpPDytBjm/vMBKAiRnjULsUR?=
 =?us-ascii?Q?n3HsyHZD+u2MTo16wr9ORJ5udPykedgfqHgMYJD7NOfKOuiLofJha07B43jw?=
 =?us-ascii?Q?SG/o6wml6P9hftF+Yg5M0iTE9rODsLb4lmSAUHYIkRP3u35d4VFXXwY/SYY4?=
 =?us-ascii?Q?pBzKAZUn5SDH2ZqjlLMTZ9/R/QEI3Pz63OqReEyj5skISmEJJAkOjCFHINro?=
 =?us-ascii?Q?b8s3kuXKno/2bRJSCPcrJVK9sxKvBVGYFGxw/XjfcoBRCZ0rY80M0ZGCjJ83?=
 =?us-ascii?Q?t9WErW7pTlLTtl51muUIBbokGr3tHlteNOe/jRfzR4VmYNS2S/up7b4uX/LL?=
 =?us-ascii?Q?aT+by/GD7VbBMaa/HEtmGPc4c3sXVxjbPK1PtAh2z4A+lHSKWT1FzaMiZSzi?=
 =?us-ascii?Q?P5785SooPaeEAVEBYyBnon0KH8BpBrCTABqp4uKXzMFom9+bwCA8DHdsLgO1?=
 =?us-ascii?Q?tuW7c302VJOXnQKvlhgxa/LTdM0YMeHBWbqW0Z4vWiPEbCrFFI5LMlXRpcTG?=
 =?us-ascii?Q?L0Y9XfE3VeL0XS2tjKWKU4qyznMDV0XkBpiwyMTDQSKBvsCvfjadP99xnS+U?=
 =?us-ascii?Q?jexxBhes9Mn9D2R6ixEkqwfy0uOB3oO0hRcWwbgaVn2rM+Y3m40t+Cu8pihp?=
 =?us-ascii?Q?LPGylSo8iNRFWHCcjC+G2CpX2yb+QrzGKNZjvRIGV7yHEnrplIx/Nm+pdChQ?=
 =?us-ascii?Q?2hJQW/3GDIDRMeDPua05SJVjH9yyW3mZLO1w8yw87qpKk3i/l4sExfcw/+uW?=
 =?us-ascii?Q?vHCnHwpfnSCZtTpqqMY2SszJ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8a4ecf5-b2d2-4889-c2a6-08d95c1a060d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 16:15:09.1735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y4jUtzzcEMt5VW/997Km0uhJK4Z2ZZx8YQ/2h4Aw6cbVgU3MrhZCInGIzDmjay2cqO3nl+CU5FqrP2abbSgOvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merging the two allows us to remove the open-coded
"dev->enabled_ports & BIT(i)" check from b53_br_join and b53_br_leave,
while still avoiding a quadratic iteration through the switch's ports.

Sadly I don't know if it's possible to completely get rid of
b53_for_each_port and replace it with dsa_switch_for_each_available_port,
especially for the platforms that use pdata and not OF bindings.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/b53/b53_common.c | 20 ++++++++++----------
 drivers/net/dsa/b53/b53_priv.h   |  6 +++---
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index ccd93147d994..5351d1f65ed9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -498,6 +498,7 @@ static int b53_fast_age_vlan(struct b53_device *dev, u16 vid)
 void b53_imp_vlan_setup(struct dsa_switch *ds, int cpu_port)
 {
 	struct b53_device *dev = ds->priv;
+	struct dsa_port *dp;
 	unsigned int i;
 	u16 pvlan;
 
@@ -505,7 +506,9 @@ void b53_imp_vlan_setup(struct dsa_switch *ds, int cpu_port)
 	 * on a per-port basis such that we only have Port i and IMP in
 	 * the same VLAN.
 	 */
-	b53_for_each_port(dev, i) {
+	b53_for_each_port(dp, dev) {
+		i = dp->index;
+
 		b53_read16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(i), &pvlan);
 		pvlan |= BIT(cpu_port);
 		b53_write16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(i), pvlan);
@@ -739,6 +742,7 @@ int b53_configure_vlan(struct dsa_switch *ds)
 {
 	struct b53_device *dev = ds->priv;
 	struct b53_vlan vl = { 0 };
+	struct dsa_port *dp;
 	struct b53_vlan *v;
 	int i, def_vid;
 	u16 vid;
@@ -761,7 +765,9 @@ int b53_configure_vlan(struct dsa_switch *ds)
 	 * entry. Do this only when the tagging protocol is not
 	 * DSA_TAG_PROTO_NONE
 	 */
-	b53_for_each_port(dev, i) {
+	b53_for_each_port(dp, dev) {
+		i = dp->index;
+
 		v = &dev->vlans[def_vid];
 		v->members |= BIT(i);
 		if (!b53_vlan_port_needs_forced_tagged(ds, i))
@@ -1874,12 +1880,9 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 
 	b53_read16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), &pvlan);
 
-	dsa_switch_for_each_port(dp, ds) {
+	b53_for_each_port(dp, dev) {
 		i = dp->index;
 
-		if (!(dev->enabled_ports & BIT(i)))
-			continue;
-
 		if (dp->bridge_dev != br)
 			continue;
 
@@ -1915,12 +1918,9 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
 
 	b53_read16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), &pvlan);
 
-	dsa_switch_for_each_port(dp, ds) {
+	b53_for_each_port(dp, dev) {
 		i = dp->index;
 
-		if (!(dev->enabled_ports & BIT(i)))
-			continue;
-
 		/* Don't touch the remaining ports */
 		if (dp->bridge_dev != br)
 			continue;
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 9bf8319342b0..aec4b1176be9 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -145,10 +145,10 @@ struct b53_device {
 	struct b53_port *ports;
 };
 
-#define b53_for_each_port(dev, i) \
-	for (i = 0; i < B53_N_PORTS; i++) \
-		if (dev->enabled_ports & BIT(i))
 
+#define b53_for_each_port(_dp, _dev) \
+	dsa_switch_for_each_port((_dp), (_dev)->ds) \
+		if ((_dev)->enabled_ports & BIT((_dp)->index))
 
 static inline int is5325(struct b53_device *dev)
 {
-- 
2.25.1

