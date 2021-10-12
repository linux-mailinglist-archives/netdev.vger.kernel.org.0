Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEA742A375
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbhJLLnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:43:07 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:6350
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236129AbhJLLnE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 07:43:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJhgT4UOiJnvvsOqb1FtRKM1zIvlEb4ZW0U1p6xeLmiamH/KcWXb4/Dmyeaa9OZveHbOJtTQCuucXG1If6hKiRsgki8FlE+T9WwsR7UMq0+j09FkNrZJjog6rubEt0vpDjhSrEI+EEXODOWb95x+CRM/6UOQCCwyLxALTuOaF4/yx3SQ4Q+GQTYtKfj6SGIThL2ucig/mf15WiP3A6RQ3Txj+CssP4plwFV47Fj3P+Qurnr2TSzCTs048X3Yxn20fz3WZs7kGMYv11CSHiKbtpetAlhu53qudxdXu9naZZVbKtkJsQliS1e34i2yWJOMOsJK5bm1UWHcsfkqyDlZGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eTwANCJc/B+V2EX3wEPLSg7Cy24CXpy/HDveuz2R+0I=;
 b=i5ekOy8MWmYJFm0l9AKGt1QocpbE65U8Od4F0tbz72e1To+GEyTJvY+GLp3G+ri0BvfbRyP3OM9MORKB2e8pOuAic8XLAbUPEkfXRkiTYiNqA758tuzaun9569KR8hUo7TYFDgXV8kn6mK0Sl+capSuEWM5NfMSJcCPLEjUmbYfperENDx0TYN3v5pIsu8tD+vmBYv3r3A2ZYxP1cZc/LBAlTgoldTSQCf0I5+pyRR4w+HDfuOqO3NqMwmxP8/9F2FpspnY6uXRvM1xpn4SCoSa4EREJKrbeGE0VNnz6crz36AfQmBZatI6gWylJfdisot+dVBeUwGFaWGi7GTc7Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eTwANCJc/B+V2EX3wEPLSg7Cy24CXpy/HDveuz2R+0I=;
 b=Y3wj2NFE4v6Q1uOiOA+L5ENUbYG3ELvAP1Ey8/xN6au4GoA7BGVTMZCcU+ZagWRlNYA85NoGZ66tR4WPzLs0V655Tkx7AREzhI6PwyvupNyZrkXHTqa3xWjueQZ5lJ25eARMKkseeB6gg3Vn86eKCeZjy0r4bEzVN1lcihmjCwM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6941.eurprd04.prod.outlook.com (2603:10a6:803:12e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 11:41:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 11:41:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net 06/10] net: dsa: tag_ocelot: break circular dependency with ocelot switch lib driver
Date:   Tue, 12 Oct 2021 14:40:40 +0300
Message-Id: <20211012114044.2526146-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
References: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0150.eurprd07.prod.outlook.com
 (2603:10a6:802:16::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0150.eurprd07.prod.outlook.com (2603:10a6:802:16::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 11:41:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a77642e-5bee-49a8-fc03-08d98d752a23
X-MS-TrafficTypeDiagnostic: VI1PR04MB6941:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6941276D2CD0F33F163B303EE0B69@VI1PR04MB6941.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cLxmgMJ2LTPExrjm7S43WePlRFcQccacVWhdeXrMdHao3sBT+0Aa/0B62AIr7kpLiNsKvNO0UIYcecekCwliju7Z70qT6AG8LkdRv6KijyDGQJ/Y7Nrksu/4h953IcBlbTDARfMvyKyn2QPAk/kWV8OVSi2bmKhFYbd5qu8F0t37BE6NvDFoBw0WIbwHAO9FcIuAyeCldEp2Ct4/imspwlIC7ofGhVrumyHZTaEgElqOscIZ/GlQ/0HMRYNEPH6xwMJCs+yqXP7J5w1oP8LTP4rDT5h+eX51tIWmpCihEvkyqO63lfvWMM+x3LCDgKNIfA/2zWuwB3V3Ayb9QcDCkNgd+0oWeD5oh0AU6EyHe5S8UH63YQFs4XyJ/8IOxsGTBVUIit/NlCenU75NzkhMnC7wdCkX4u1avlwuh5n0DKB/70uMVGgx0ZRRi9fGIcLKYgy+hxjkXRBnHNLCWiuyLXX8HXyw6RzRvJnOQta6yoKvbQvQPdlZWXDO98WhutiLzMWM0zKMRwRC6HzvfIwWwmkkIBEsv5cqhgkFDwveHIrHdPWWX/dRmuTcQXWRfUBlTs0yeRVIBCEPaOS1v0+tCR8i1+XPiAltROYA4PX+zye9u5rA+MaDohrluSQ8G54QyzELhDTcsyhwfaAA+Ag6NCCV7kfk3cTs6oE4vZY4AI8oJijYkrZOzkcqnZ/LBq7iYSP23QV3u7zaG3hcfsahaF4Ngl2DEAzGBnk41+Js1QHFo++uowL0ZZR0g3n+ZYSbOaKVA65bGgG3m56Vt3Pk2euyZgN6xLEiP/x03X61m54=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(44832011)(508600001)(110136005)(6636002)(2906002)(66556008)(66476007)(54906003)(52116002)(6512007)(4326008)(316002)(2616005)(956004)(966005)(26005)(186003)(38350700002)(6506007)(7416002)(66946007)(8936002)(6666004)(83380400001)(6486002)(86362001)(36756003)(1076003)(8676002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PahmJuB8gc65UN7cm4ZOkMdAFliYLSUaA4yxhMED1rPL+8zxp7v8lvoIBaR8?=
 =?us-ascii?Q?cg+S9SOnz+Es6WAc0op+nF8CZEtRO5VKZpGjg9eD5+kk0lr1nZCtckKxyZZT?=
 =?us-ascii?Q?Oiu5p/iGZwXt6KoXqgtnaja7Tl6r2gTIvuQjxoCi7wxySeqNuSEf55yNCX3n?=
 =?us-ascii?Q?gSo6tHYN1gTxtGmfDZO3+kjsRM5KZ47C7RqQc8VvYKkW5E3yLrTT81lZGYoS?=
 =?us-ascii?Q?poDWnIUpaIcCEpxxQu3E31wf0u7t9WNl1N3wsm58kOdlOcjbWx50ESCYjunA?=
 =?us-ascii?Q?zT0NLYoI9lytXfXPNLkwx4JFqv2wnAOiINDtT8JQrnigi5ncEAIQxu+eeBYk?=
 =?us-ascii?Q?EbAA1TCHcXIb7Wt8Hd9W5zx7fe01dznyDuv5YqglI62+c+iyGspMrcS7KGRw?=
 =?us-ascii?Q?qe6Pt0/XcSwtBjOnIMmAbkxhGE2VK5xctAwC8rDVeRuq9j6hEpsak4bBgc7J?=
 =?us-ascii?Q?rGqrcUMqimz9AlzIrdt4HTG052XOIuq8vZm1YuoUMwSLYiagT5nT53vf0ErK?=
 =?us-ascii?Q?NQmcNmmEiFlCHkk5y8CwrSDXw4tl9u2S0nB3T3sZD7mCU5kGOsHsh0cO+qTf?=
 =?us-ascii?Q?/znS05uNc84gjDKTwhSwrYVo0anNXJ0y3PScZMoTtVR07BZ5lMsodsm1aKDj?=
 =?us-ascii?Q?gWXKtZCrXkTyt/ezdT7DlVbPLsdWRJM4soVgXZr85aMLStp1ZxQjpKp8W+Q9?=
 =?us-ascii?Q?9KQ4oSEEEkxzIoDjINJChWQmkzIKKMOQ+SNcYUTio9Dcy52jS8HtTm+oLZjD?=
 =?us-ascii?Q?1hY4xJTEE4ah7mRQWHJJLbdIlM0lTGR04TFCXXmPtcNolKO0ez96axgPj3fJ?=
 =?us-ascii?Q?ajdqJBTNQv/acBeyfhQhmKFVn4iyhiZXkYXUYV8TGZ6nyg1eZYsJjMgLQwCW?=
 =?us-ascii?Q?8INb4ek3L7CxSoTDqKp1Il4K6Hp/Gv7o39pjlt75Idd6u56kF+dx7pbFpBWq?=
 =?us-ascii?Q?kkshg3L3XYeuPwPLOE2Slh8rVKw2fYkk8zBJeWMkrOkIUdDSluNLEvZC8Tmh?=
 =?us-ascii?Q?eircO8eoUVZwiXxAKXNK7RL8+vcNEdShDV3Hd8r+POzsWtkNdsB4VpoWi95X?=
 =?us-ascii?Q?P7oZTjr5GmJbjU327zw1fNdR9Jkjo4Fs/qK6BGcZCoKXhCowWkuygSCEWRo5?=
 =?us-ascii?Q?jaTe29YFneYcAADONYTm7aU8lwzxPnyPcO9/1YF6P6rbqQyY6rR83AoN2Tlm?=
 =?us-ascii?Q?P+tSO/uWtim6e/e9rzxUMJgODhAcycTQIDiMjbvw4Ye8kjhmZvq+EVlqt0Mg?=
 =?us-ascii?Q?xrD3VFnetNFVG6LRusJ6Pf/U8g8dJenkEaZ50Me5ewA6EJGPDWoIiE6DKKIs?=
 =?us-ascii?Q?Y/+Pyy6zC8NYFt+UlNJ5AJBz?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a77642e-5bee-49a8-fc03-08d98d752a23
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 11:41:00.8986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GDXBxIWXTBL0Qlwnu4ZIfSnUrDSsyU0h5TW6lk3oGYyBzieMrkiaig3RB2eW8YN5TBgW2iYTVgo7570UvjQNHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As explained here:
https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/
DSA tagging protocol drivers cannot depend on symbols exported by switch
drivers, because this creates a circular dependency that breaks module
autoloading.

The tag_ocelot.c file depends on the ocelot_ptp_rew_op() function
exported by the common ocelot switch lib. This function looks at
OCELOT_SKB_CB(skb) and computes how to populate the REW_OP field of the
DSA tag, for PTP timestamping (the command: one-step/two-step, and the
TX timestamp identifier).

None of that requires deep insight into the driver, it is quite
stateless, as it only depends upon the skb->cb. So let's make it a
static inline function and put it in include/linux/dsa/ocelot.h, a
file that despite its name is used by the ocelot switch driver for
populating the injection header too - since commit 40d3f295b5fe ("net:
mscc: ocelot: use common tag parsing code with DSA").

With that function declared as static inline, its body is expanded
inside each call site, so the dependency is broken and the DSA tagger
can be built without the switch library, upon which the felix driver
depends.

Fixes: 39e5308b3250 ("net: mscc: ocelot: support PTP Sync one-step timestamping")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/mscc/ocelot.c     | 17 ------------
 drivers/net/ethernet/mscc/ocelot_net.c |  1 +
 include/linux/dsa/ocelot.h             | 37 ++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h              | 24 -----------------
 net/dsa/Kconfig                        |  2 --
 net/dsa/tag_ocelot.c                   |  1 -
 net/dsa/tag_ocelot_8021q.c             |  1 +
 7 files changed, 39 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 48c02692380c..d479030bf915 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -601,23 +601,6 @@ static int ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
 	return 0;
 }
 
-u32 ocelot_ptp_rew_op(struct sk_buff *skb)
-{
-	struct sk_buff *clone = OCELOT_SKB_CB(skb)->clone;
-	u8 ptp_cmd = OCELOT_SKB_CB(skb)->ptp_cmd;
-	u32 rew_op = 0;
-
-	if (ptp_cmd == IFH_REW_OP_TWO_STEP_PTP && clone) {
-		rew_op = ptp_cmd;
-		rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
-	} else if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
-		rew_op = ptp_cmd;
-	}
-
-	return rew_op;
-}
-EXPORT_SYMBOL(ocelot_ptp_rew_op);
-
 static bool ocelot_ptp_is_onestep_sync(struct sk_buff *skb,
 				       unsigned int ptp_class)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index e54b9fb2a97a..e7fe5dbd8726 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -8,6 +8,7 @@
  * Copyright 2020-2021 NXP
  */
 
+#include <linux/dsa/ocelot.h>
 #include <linux/if_bridge.h>
 #include <linux/of_net.h>
 #include <linux/phy/phy.h>
diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
index 435777a0073c..50641a7529ad 100644
--- a/include/linux/dsa/ocelot.h
+++ b/include/linux/dsa/ocelot.h
@@ -6,6 +6,26 @@
 #define _NET_DSA_TAG_OCELOT_H
 
 #include <linux/packing.h>
+#include <linux/skbuff.h>
+
+struct ocelot_skb_cb {
+	struct sk_buff *clone;
+	unsigned int ptp_class; /* valid only for clones */
+	u8 ptp_cmd;
+	u8 ts_id;
+};
+
+#define OCELOT_SKB_CB(skb) \
+	((struct ocelot_skb_cb *)((skb)->cb))
+
+#define IFH_TAG_TYPE_C			0
+#define IFH_TAG_TYPE_S			1
+
+#define IFH_REW_OP_NOOP			0x0
+#define IFH_REW_OP_DSCP			0x1
+#define IFH_REW_OP_ONE_STEP_PTP		0x2
+#define IFH_REW_OP_TWO_STEP_PTP		0x3
+#define IFH_REW_OP_ORIGIN_PTP		0x5
 
 #define OCELOT_TAG_LEN			16
 #define OCELOT_SHORT_PREFIX_LEN		4
@@ -215,4 +235,21 @@ static inline void ocelot_ifh_set_vid(void *injection, u64 vid)
 	packing(injection, &vid, 11, 0, OCELOT_TAG_LEN, PACK, 0);
 }
 
+/* Determine the PTP REW_OP to use for injecting the given skb */
+static inline u32 ocelot_ptp_rew_op(struct sk_buff *skb)
+{
+	struct sk_buff *clone = OCELOT_SKB_CB(skb)->clone;
+	u8 ptp_cmd = OCELOT_SKB_CB(skb)->ptp_cmd;
+	u32 rew_op = 0;
+
+	if (ptp_cmd == IFH_REW_OP_TWO_STEP_PTP && clone) {
+		rew_op = ptp_cmd;
+		rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
+	} else if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
+		rew_op = ptp_cmd;
+	}
+
+	return rew_op;
+}
+
 #endif
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index cabacef8731c..66b2e65c1179 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -89,15 +89,6 @@
 /* Source PGIDs, one per physical port */
 #define PGID_SRC			80
 
-#define IFH_TAG_TYPE_C			0
-#define IFH_TAG_TYPE_S			1
-
-#define IFH_REW_OP_NOOP			0x0
-#define IFH_REW_OP_DSCP			0x1
-#define IFH_REW_OP_ONE_STEP_PTP		0x2
-#define IFH_REW_OP_TWO_STEP_PTP		0x3
-#define IFH_REW_OP_ORIGIN_PTP		0x5
-
 #define OCELOT_NUM_TC			8
 
 #define OCELOT_SPEED_2500		0
@@ -695,16 +686,6 @@ struct ocelot_policer {
 	u32 burst; /* bytes */
 };
 
-struct ocelot_skb_cb {
-	struct sk_buff *clone;
-	unsigned int ptp_class; /* valid only for clones */
-	u8 ptp_cmd;
-	u8 ts_id;
-};
-
-#define OCELOT_SKB_CB(skb) \
-	((struct ocelot_skb_cb *)((skb)->cb))
-
 #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
 #define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
 #define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
@@ -765,7 +746,6 @@ void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
 void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
 
-u32 ocelot_ptp_rew_op(struct sk_buff *skb);
 #else
 
 static inline bool ocelot_can_inject(struct ocelot *ocelot, int grp)
@@ -789,10 +769,6 @@ static inline void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp)
 {
 }
 
-static inline u32 ocelot_ptp_rew_op(struct sk_buff *skb)
-{
-	return 0;
-}
 #endif
 
 /* Hardware initialization */
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 548285539752..208693161e98 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -101,8 +101,6 @@ config NET_DSA_TAG_RTL4_A
 
 config NET_DSA_TAG_OCELOT
 	tristate "Tag driver for Ocelot family of switches, using NPI port"
-	depends on MSCC_OCELOT_SWITCH_LIB || \
-		   (MSCC_OCELOT_SWITCH_LIB=n && COMPILE_TEST)
 	select PACKING
 	help
 	  Say Y or M if you want to enable NPI tagging for the Ocelot switches
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 8025ed778d33..605b51ca6921 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -2,7 +2,6 @@
 /* Copyright 2019 NXP
  */
 #include <linux/dsa/ocelot.h>
-#include <soc/mscc/ocelot.h>
 #include "dsa_priv.h"
 
 static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 59072930cb02..1e4e66ea6796 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -9,6 +9,7 @@
  *   that on egress
  */
 #include <linux/dsa/8021q.h>
+#include <linux/dsa/ocelot.h>
 #include <soc/mscc/ocelot.h>
 #include <soc/mscc/ocelot_ptp.h>
 #include "dsa_priv.h"
-- 
2.25.1

