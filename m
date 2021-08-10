Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B2D3E7D51
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 18:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbhHJQSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 12:18:32 -0400
Received: from mail-am6eur05on2081.outbound.protection.outlook.com ([40.107.22.81]:23521
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234705AbhHJQQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 12:16:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3T5Ir++1jHhaRV8zpg0rVOtEWIzfq2RPzHVwQhHSoiMNyD6VWjHYCVeKh/vHcNIJbFUkwDLBI3npXLZFOYhMS4kJAaINaWbBddTc3qiGHUuV0TxJU78UL1ip6TQyUaD5BvK4oc82rmYphdW4l/dbtmdq1DzHza36eVM/iGiBFqtRClScWb+ZT3eYqF2VAa/oQy+mbfscmEZsTmNaEvQNRKi4OCK/SBifyZx1tD4ZHLm2jwNvHyP5q1/P6UyQs4RVTwjPG1VlS6FBd1wyOHbNiDNAlAsOn6R5p88eW8zbuhXaTpJehlKAo6UuzCavBi+VTTGoH+mQXzAUwGn2Nrn6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ny7NaAawch/pfNyTIbwOCoedn9Rm3DY6Ebw5bvPwpE=;
 b=JF8pOBcYuiAuuN2MA9PQOobSJ6b4Jb8Qlz3yjuEYpxGy8LQoBxXpfK+zQVsODcJdKUgOqKGZkaSo5rN/KpsAFgOTUbECU4T7c/V//E2SWJHiZvDNh43UD984HhYcIFM8dnkR4nGavet56sBtHQwQUX7r/Q3BsdJbkv+g5R4yGcgcwDOlW21PsV1dJXNCvYB45ORnDAANazqwXAvXinKXACVEvEyyX/iMnR1uIw70d2nBLQUr3l/y40xFrNcBixIpvLBWGnHNdVrDaOTPu8R5FceNvPCpMInSwZfkIgwzPl5mGOZ6n/MbvLFarGrRqP/m/28cjz3cMnE8E4ifwc2p5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ny7NaAawch/pfNyTIbwOCoedn9Rm3DY6Ebw5bvPwpE=;
 b=oh0eTgJW+feB1krahISW348gnHOb7yqJOA3Sx0pay1cLc4zAHuhgVGuqyU4kKV9RFSnR1kYcig95S8H33Io5TOyPuM1EkgeYXBxaJoYuI+F8s46XUTD1lTMjDDpVgZvZNRfGszSLYhgYnHComqKnw4kf87yLM0BLohOPOkODtHI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 16:15:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 16:15:10 +0000
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
Subject: [RFC PATCH v2 net-next 5/8] net: dsa: finish conversion to dsa_switch_for_each_port
Date:   Tue, 10 Aug 2021 19:14:45 +0300
Message-Id: <20210810161448.1879192-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810161448.1879192-1-vladimir.oltean@nxp.com>
References: <20210810161448.1879192-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 16:15:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88865c8d-5435-4146-087d-08d95c1a06fd
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2800:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2800D4EBE323E50B72DE4385E0F79@VI1PR0402MB2800.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xkHfJkW+pQF2pRlUGqjtpJRRriKiLtZrB0ntGmOu6id6APzpG7UxAhC4R3y6B08Wi6qbzt8sAWqot1tu2k6Ch96U87n7/pYBGAA2i4i8EPayz9rSAxNCOSzofCuSIhT4WviLsWrSIS26e4KGHIWCQZem9WvoYwvOdW0H+qAWWsGN7jr2I7ToaAUE9cvobMsjZAARaWKpdJUBH6NKwhaVrAYzEnpcgpMhxIYffDMoe9CR2+QWJGkmaOUBNicZthfSwpBTP5Ht6CsMZBlYvQ1ebmeNU9ETzaKqPQsz7fak5Tvs7JM7KdLR8vIk1ecIb5+f9/bXEtY97Ct0NATkdN5ZFUy1iT3V5Z0FZrjZacCcmpAL/Mh3i0458pH8TV5v7ozjUWpFRD78afEoai34I0pxJL58023Yf4Ra+4d7t0dUuV2EOHMg1WQFw4ZGfIkiA189leA84H4p7f1bYKN5cidPwioP0g9mNHarCqtAU4bGO6SJNUW9bKLOeJzcyvnjPBa4D4R+tKIEl45eX8axYAMujLAiN7OdDIfVrGXzMsUJv2rV53Viq5yxVn3rTC7x9y3XIDxLlUlmHGqzPlXQGa9MuDwFHDtY65zwyCY48JVMRyRPJpZjKfMaZRG9sEDO8t61gIPQwvo9kWyzyA8TDVzL3lgX1VWPFXVnrzIN78WdzPwqpDIBS1qEWduQFmGnWtw2v9u+MCLmDCxd/zwGEq/gZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(6506007)(52116002)(6512007)(86362001)(110136005)(478600001)(8676002)(2906002)(956004)(83380400001)(54906003)(26005)(1076003)(8936002)(6486002)(316002)(36756003)(7416002)(186003)(66946007)(5660300002)(66556008)(66476007)(44832011)(2616005)(6666004)(4326008)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n1okFmuWFa84nUH3C0+19eQH/puGgs/occ1utcj74v9yWOyW41BZYWzIwV2F?=
 =?us-ascii?Q?+EfmNnsHCAacL47VryjpVp2wlSF05aFts+2NOHwVqOxAoO2IH/7INj9rB6Li?=
 =?us-ascii?Q?3ZX25boCgtyicyAmcgqiYtqajSwK0vVqGODtCcj7w7n80K6x0Syvug8rw4Br?=
 =?us-ascii?Q?OSfx5PwKwuSsC1CApXBWx+uGNv+8QSPit/91XjBmxgOkQmP6s8VTJrxjmN/i?=
 =?us-ascii?Q?D29wbIc9wFjtSImLuUIJG1csVPOvA2N4pu6w0FEb/oKB74PCjs/xwCnp1yHc?=
 =?us-ascii?Q?2zIlqEFGn7cmIZpMkHAICK6BVbksTF18HBdgEJKJbv6bTqFdxymOaN87f4G6?=
 =?us-ascii?Q?F2Z4wzDKqMFB7hazRc/E9izQrHqNdp/xkuW+t4qbl3HhSFJUV4svJTtBqEGj?=
 =?us-ascii?Q?1CbOubLUu2n46Bnq43V3isuJX7p1aGjbNWPENhLDgpinTZZQkrGJcbc7OVU5?=
 =?us-ascii?Q?33zkXzL2c3DDXpo+BdRJlKrN6MVL+vAfo6kY+tJij8nb6BvFKwVwEFEmaQ73?=
 =?us-ascii?Q?VJrT+AgR+plOQqkFR9nMq1Uzioq4rwnvAeX2xUIWYWOdIH/giSTOLQiw75wY?=
 =?us-ascii?Q?2Kp7I0HRQ1OyVpWKaLdX+FMzDPEkXdu7pxrq947mhrPd9bJv9Xpydnv2TzTn?=
 =?us-ascii?Q?FLmWyZxjAMuYzEv8E2vADd8aaUKaFjbphpeSLmAlVfI0c9cUFXHbCP8sIwNu?=
 =?us-ascii?Q?QSr1AUzgDNUdQ82oTNYZKFo83l7PDjspLxr/pSFlsmDlJvpsdP//VueUQocD?=
 =?us-ascii?Q?GgG6zIDcXEvdQgiKNTcUcHzZAIy9yLcJEu7O7Eh7uXWEvhvUfq6hvLfEfPY5?=
 =?us-ascii?Q?e1IvT4Nw1MxHjllklPGIyE9RBDY2wXVO2+Z6sSdU3z5oq5TWUrN9/C90nedS?=
 =?us-ascii?Q?bXcAqtRNfgtL8ugnWnakDg3wdMMTnrDJnOCv9repU5UkDHjraEXYxSgMQBdP?=
 =?us-ascii?Q?Nx1zekWWLw4bMH1RS7dRAG2X6UN8SybrcAYRt/rKz2AhRGQMzH7SxWuKc/px?=
 =?us-ascii?Q?MIl+kLzDSBNxtFHiq+llf0i5pGZD2Sz0R6BMkswAGSGCdp2cW8JRu9Kaq5JU?=
 =?us-ascii?Q?Tzth40cu6h+w9GhT0hdmksWphl1vLHHtxH1p59SC05w+lglv0RgAux/SsyIX?=
 =?us-ascii?Q?Nb1xqCqfxBD1Om18e8kT2E2a4+ESz09LgsCEaW6qGKnsK3197wNs0c+sYA6I?=
 =?us-ascii?Q?adx+u7sXOG5Q1ufo49I5no8CC+w/jrgRH+pe9LHe9SD6uVR6/KUw6QnpfQt3?=
 =?us-ascii?Q?q6SjBVfZhEK7+Vq6Q1GcBN9d7RwmZ1anIMH05EwDmbfofeRidli/ssIYpNnb?=
 =?us-ascii?Q?FLlYgp/w7Fba+AxHoKhlEMYc?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88865c8d-5435-4146-087d-08d95c1a06fd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 16:15:10.7785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lB8W0Rc3XNW62D5JBwtFm3jrQn3JTvceKNRSftduAYAbYiXxCQc4navhjfzZZJQrGKUHyj/YPLjQPLXPwPaFXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

What is left is a 'beauty' conversion, since the performance is in no
way different than before.

Find the remaining iterators over dst->ports that only filter for the
ports belonging to a certain switch, and replace those with the
dsa_switch_for_each_port helper that we have now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 drivers/net/dsa/mv88e6xxx/chip.c |  9 ++++-----
 include/net/dsa.h                |  4 ++++
 net/dsa/dsa2.c                   | 25 +++++++++----------------
 3 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1525415aca46..5ce3c9129307 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1263,9 +1263,8 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	/* Frames from user ports can egress any local DSA links and CPU ports,
 	 * as well as any local member of their bridge group.
 	 */
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dp->ds == ds &&
-		    (dp->type == DSA_PORT_TYPE_CPU ||
+	dsa_switch_for_each_port(dp, ds)
+		if ((dp->type == DSA_PORT_TYPE_CPU ||
 		     dp->type == DSA_PORT_TYPE_DSA ||
 		     (br && dp->bridge_dev == br)))
 			pvlan |= BIT(dp->index);
@@ -5938,8 +5937,8 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 	ivec = BIT(mv88e6xxx_num_ports(chip)) - 1;
 
 	/* Disable all masks for ports that _are_ members of a LAG. */
-	list_for_each_entry(dp, &ds->dst->ports, list) {
-		if (!dp->lag_dev || dp->ds != ds)
+	dsa_switch_for_each_port(dp, ds) {
+		if (!dp->lag_dev)
 			continue;
 
 		ivec &= ~BIT(dp->index);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 379ad8183639..3203b200cc38 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -475,6 +475,10 @@ static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
 	list_for_each_entry((_dp), &(_ds)->dst->ports, list) \
 		if ((_dp)->ds == (_ds))
 
+#define dsa_switch_for_each_port_safe(_dp, _next, _ds) \
+	list_for_each_entry_safe((_dp), (_next), &(_ds)->dst->ports, list) \
+		if ((_dp)->ds == (_ds))
+
 #define dsa_switch_for_each_port_continue_reverse(_dp, _ds) \
 	list_for_each_entry_continue_reverse((_dp), &(_ds)->dst->ports, list) \
 		if ((_dp)->ds == (_ds))
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cf9810d55611..67222f634876 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -759,12 +759,10 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	/* Setup devlink port instances now, so that the switch
 	 * setup() can register regions etc, against the ports
 	 */
-	list_for_each_entry(dp, &ds->dst->ports, list) {
-		if (dp->ds == ds) {
-			err = dsa_port_devlink_setup(dp);
-			if (err)
-				goto unregister_devlink_ports;
-		}
+	dsa_switch_for_each_port(dp, ds) {
+		err = dsa_port_devlink_setup(dp);
+		if (err)
+			goto unregister_devlink_ports;
 	}
 
 	err = dsa_switch_register_notifier(ds);
@@ -807,9 +805,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 unregister_notifier:
 	dsa_switch_unregister_notifier(ds);
 unregister_devlink_ports:
-	list_for_each_entry(dp, &ds->dst->ports, list)
-		if (dp->ds == ds)
-			dsa_port_devlink_teardown(dp);
+	dsa_switch_for_each_port(dp, ds)
+		dsa_port_devlink_teardown(dp);
 	devlink_unregister(ds->devlink);
 free_devlink:
 	devlink_free(ds->devlink);
@@ -834,9 +831,8 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 		ds->ops->teardown(ds);
 
 	if (ds->devlink) {
-		list_for_each_entry(dp, &ds->dst->ports, list)
-			if (dp->ds == ds)
-				dsa_port_devlink_teardown(dp);
+		dsa_switch_for_each_port(dp, ds)
+			dsa_port_devlink_teardown(dp);
 		devlink_unregister(ds->devlink);
 		devlink_free(ds->devlink);
 		ds->devlink = NULL;
@@ -1412,12 +1408,9 @@ static int dsa_switch_parse(struct dsa_switch *ds, struct dsa_chip_data *cd)
 
 static void dsa_switch_release_ports(struct dsa_switch *ds)
 {
-	struct dsa_switch_tree *dst = ds->dst;
 	struct dsa_port *dp, *next;
 
-	list_for_each_entry_safe(dp, next, &dst->ports, list) {
-		if (dp->ds != ds)
-			continue;
+	dsa_switch_for_each_port_safe(dp, next, ds) {
 		list_del(&dp->list);
 		kfree(dp);
 	}
-- 
2.25.1

