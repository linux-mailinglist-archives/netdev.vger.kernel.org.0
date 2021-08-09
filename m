Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBAF3E4CA2
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 21:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbhHITEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 15:04:13 -0400
Received: from mail-am6eur05on2046.outbound.protection.outlook.com ([40.107.22.46]:52065
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235918AbhHITEH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 15:04:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQr4Z06YzKOsUt9BRFFqIS9ZQnvV9COUwuZUC60cP5f0VALSW60btF7sc/zR7i+o6NRBlQLPDlNioHB99FmT/BaDk5Lm6FtGYexraNaRpzM+KWdIro61Mi9vCLvkcdG/9dtgvEa6DA5AZiZMeu1qWfUe0sER0uFf+uCglKQnf/fH8F2DSuBUnuB0EzNxP/o/I6tJGJwYTf9v7RlLyaGWhxYOyjpZUVNO72XGT5do0FZq6CcZNi838nOek1uCdDE/A84rAKQ4uTIu6DJDJWK8yp6whJ7MCcV/jl/gKS9PixGFwaisB2+wCvvIXsFC7/CeaL8mlJV9z4ZA+3TfdHokLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=55mDgRE1XTiGrtUbcB6BntK0qGxSWDmDRRqH/VfeUQI=;
 b=iif1f5ttNzhlTWiEdEzpRcv9cYWofvtrWL2egdiGxpDTCgFebaIvZnP+hIiE0XzNte+oNeRKB+QHdrnY041lbfRKb6IvM/Vl+BEat+bTFq36fMOQJ9HUzhQpoUwRPUUN0sZT3y57mgv8bxupN9EyMGTSud/orHRTRLBj2P6TbZvxQXj5YOgS1JfaXJsCz9OsIMytEMyJmJXSi7j1iBjIIS6HelW1mV/yskqRXwZWLqCYeaIKjr3GyFDkQcce3+FW7f8LEKfZtmgoIrPq6gHlYcWUtUKhW2VNL+JpZ/ipdAiCP5ytyOPkUEV8gHTyjsCQWcLR5bMIpwf64QxilmikkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=55mDgRE1XTiGrtUbcB6BntK0qGxSWDmDRRqH/VfeUQI=;
 b=qUruYkSliQ4t5ff8Q8xbOXwToNLodY7T+IB6BziafxF/hbLNDYF7N8DyLeeagyYXujaZQsW6lBPtGvIvP18c2T8CHjBqVnQpb09qGMvNo72mGUsY7LCzztij853sCjPXeehE3mgvtBT+xnvXhoVVegajuAFqagC64/ThuWlSuqE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Mon, 9 Aug
 2021 19:03:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 19:03:43 +0000
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
Subject: [RFC PATCH net-next 4/4] net: dsa: b53: express b53_for_each_port in terms of dsa_switch_for_each_port
Date:   Mon,  9 Aug 2021 22:03:20 +0300
Message-Id: <20210809190320.1058373-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809190320.1058373-1-vladimir.oltean@nxp.com>
References: <20210809190320.1058373-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0057.eurprd04.prod.outlook.com
 (2603:10a6:208:1::34) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR04CA0057.eurprd04.prod.outlook.com (2603:10a6:208:1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Mon, 9 Aug 2021 19:03:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f513edfb-a4b2-4ce1-ba34-08d95b686868
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5501394431F221D625D54F90E0F69@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I22nOWnnHpGUyiQ3++pHjQAN0uN2TdxTw3M5kkP1rUqUUJuytPUwZwMh9/Dxw8T3DkX1jG4jms3pGE7iprJQlskpQOlpf/6ZLAI5jVT5wEwRDGtech0+0Q6zN8EsvBmQMS+5Ea62rdCgrcgoQ4wFkpe5VExCEvJ00V8mvnQjhecw6ZqMLP+vfSts9QmHqYuB0Xt6mk8Ozk9AXGO0QWNSxtnfXzKjmbJ6/W1gP55+HNKtUwi/lTYvFBeeNtOtQo3bJ9V01XdYH2kFx6Rj2aaH/e2MYykC3a+Lfda9DiUNgfTrHzK1FD/8m7ibyoTVlwLgk6JXFAsDfsxpBF1O+hGU4WeEgSgwUNrnaXsY2GRPw6lYttfpf1L4QTpHsNmQGzHwQfo94TQW4QjBKEKlNJYvkg9fVNNchkJRlfIDPPAcsruS6zkEOY6hpYfdUy6/X/6+FveOQeIA1qOaVPDDS2VTIVSU4FphH6itnJgkItMa3D+8QuhARJ7O76lGzEpfWXU81AjltzhOQ6mRNnGiLRujyHjpXODljy/hFtUv5hMsYlIxOXvv1GkckXuP8w2hBrDZZWynj+oUhPDKuMW6t9StZq8+st6nsPvDbpVQ70aIa6+1QvErCuaseVSCgje24TIMzXdva3HuAbmNzOp6Hp9C0jURUQS6CqgnYXsjJXwaDhUzfZv4rO2ZOW/GtXoR9y/wPaPGG1u7RcyYiIgGZHNJkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(136003)(366004)(396003)(376002)(5660300002)(66946007)(66476007)(66556008)(7416002)(4326008)(6506007)(44832011)(54906003)(52116002)(6512007)(6486002)(38100700002)(2616005)(1076003)(956004)(110136005)(6666004)(38350700002)(86362001)(186003)(36756003)(8676002)(83380400001)(8936002)(478600001)(26005)(2906002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8vYmwLtawUCmjLIIx680oRikPkaamNh7KwmQ4IpHB5tzdvZHmXEM6ubbVL5s?=
 =?us-ascii?Q?gh7sLDp41B8UPma+XAQ76twrwJdDrzhY4Kl7ryUMpQqlQZCR22Y54stlR65O?=
 =?us-ascii?Q?MncN/ROSMD6FE6jk0jr1JYI4zoWuMWKSNjm0EyxKZY7YADTk7ckOQGxF4OY5?=
 =?us-ascii?Q?9zWipnu06ppRASMaeSjD9HRbJ+8xtUCPpgisIPaGR3yPrbHK0WKWyaSDC8qh?=
 =?us-ascii?Q?4HoY323+7krB4WIXiW9yYQohIULmZ6526iURV9hFxvE1FMeQhK12D+HUd54M?=
 =?us-ascii?Q?AzAGGems1HX5p7PTdKvCpHSLkHfV7xzkY7wbAI4mr9Hjntw4Z45p92s4fbxG?=
 =?us-ascii?Q?kkQh94yUoeoluLk3Zb2WAs+KXDo4cTkRnfUuB4C7jmHiY/BUNBW6PgsHe3GM?=
 =?us-ascii?Q?ow/G3Bwi5tKY/GTvQLczmaZhzrBvn/9oKME5bMEgyzOeBs1BhAH07SAi8x6q?=
 =?us-ascii?Q?UWvRZjpY9s2Q0Z81p+39rYz4gBPnr8NETFsmFdHUiCRO1OrbXyQz8XMLhKjP?=
 =?us-ascii?Q?lOwBtUYMY/DS1C/P5eibdvZ/AjuV5RYHy+kIFdEPtznS9p1dmocgXOoe01xw?=
 =?us-ascii?Q?p9ToXa7bM7RZZE6I4ulVmCoJtsyLPLjAJHTaZyMzEPq8u/Ee6uXGpcH64Gcq?=
 =?us-ascii?Q?Xe1XNkJR9ljK1fvz7gNDoYXxEh+lE+1wt7sudUBfZd2bsUopQPjzLtAqmX+1?=
 =?us-ascii?Q?jHX6hUkT1snwymjrlfD2hY6QOEp6Hu4WTTDl2FNp/PVllaODZ5oJmenfGF1p?=
 =?us-ascii?Q?oEcIQT6ly5pFFIUrT/x59tnH6P6QLM7MAKz8sfDB4hm5lAgmNZAroOLhhh3D?=
 =?us-ascii?Q?0JyZrZlfDTtQNoBnUG5komM/W2r+fNzkgrhteqrDtaTPDY1Qa1YNpQle90Kh?=
 =?us-ascii?Q?V4j7qBr1yvojct6UsU3cszcb7YCx9dchUIXASjYBSCWFklXJWDO0ECtcaTgE?=
 =?us-ascii?Q?o3l8TgnCb761CsCMhxWcDFJdTS882vnXi5CeIZ+ASJrR13exZzcqOaz4uQfg?=
 =?us-ascii?Q?4FCHtpffNQ2Dr1U0S1QxFi30YVm6yG7vUDxG0lxlxmgQJNa+CE99+EJZt3Ba?=
 =?us-ascii?Q?pEKswq2k31yPE/pc8Dqk6FX9QRLy2wLSgmU3yq+bhmb/r7+PVjTYLqWmXsE4?=
 =?us-ascii?Q?U/J3728v31KwbgHshv3vgqwhbHW7Hm6d2aNMkKzk7/8U92kTJVUDJ2AadKsZ?=
 =?us-ascii?Q?wNY16+W+5qWptPdkzzIT8jjDhKMQYZN8T6llB6Yre86p+FCiIrofvRRgrKhp?=
 =?us-ascii?Q?li49+ov02sCoQICnnbFo7V+ONUsSIv6fg7oP5EvV4Zd8Ht5RAwa0saRcfo+C?=
 =?us-ascii?Q?C/Ja/TkKYauyStlp9k64CVvr?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f513edfb-a4b2-4ce1-ba34-08d95b686868
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 19:03:43.7935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XNKyvVf0ziBTO6o/fREZVq5FF2/sYZgKEBb9phQWKUb5vnERjiZ5eCy8/m84TdzgdblzKo2pOJpmEaKFHaURkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
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

