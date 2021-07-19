Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735103CE82F
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349864AbhGSQiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:38:46 -0400
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:25006
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355081AbhGSQfr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 12:35:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gojq3k9v7FYmG+pMbPhdzDpQ8tm4vKzpj2VXc4S1x08pi9AQgYO3rYQtH3j+GT+eqo3DpyXavNsluQimMdigmQiRyU2ei+pTbJLOeSAbw5/aNusil0gmbEBXlGsC+jvT7kLnZPvTYyl7Dy/n1/3Sn5TCG9TDW023qPhn6gkAehPYyqt2n5M8xGMmqjYLXZ5bpz+4Csrs9WOyNpPCD16BXjyCDCM+eAseSnlW16NujKSY4iwmrjq47SEHHaD/Tlvq+7H9DXF/sJsndn9SjjepW/V0snaG5ZRxNTtu6UdzUGC952zyo66dkTF9xkpiN6iOfInf8nZ1pXex6W1c3lIO+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PO/Yk3FlzCRGEOhbB+5NhZ6QCpsNKN3DybAWh79VHE=;
 b=Cglasa/+WxpI+giAjdJh5BYfG8c1YOkIoTpXDHFY6zh9p1Y5MP1Zli2z3AY/Lyz6idjqI3Rp3DMy90cQfblRXQQnIou4dXxE4Q9sKzjgrab26NlJi14iL9SzysKLXDWuktcuXLY/TSGqchYv1Zw3NRCnYUwq4XBjMPQUkIFnfNASZaEY/XPiq5pb74OqbdFU7KeSPJ01OEBM+wbHKQODgEU2hcP1kmQmaT0v1oGegev2J+ShxBDW1Q37fMhrZ1J5QwLsoqdNlgqpKytBjkUt60oy/EGKjFVJtqLrjhwyZSAidT2C7FF6nHR/WA4Uv5tRVn6iaKSiFI+hFw/8DMxa1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PO/Yk3FlzCRGEOhbB+5NhZ6QCpsNKN3DybAWh79VHE=;
 b=jTmAdvNBD9lAco3RXSumwzotbAMrjXwGyiKEvxbEHh2dKUgt5Cz8VlJnGNeaBc0zEWGbdb8QaX3PNERAcBv+R9sL6BMCxZ/WiTwxXPesa/HhFUPDsen+O6DWrlnB1pXknhunHUnMTUJVNvKBXSFLvn+nwUgO+LFoJVirdB4z2cM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 17:16:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 17:16:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 06/11] net: dsa: build tag_8021q.c as part of DSA core
Date:   Mon, 19 Jul 2021 20:14:47 +0300
Message-Id: <20210719171452.463775-7-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 17:16:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd640e3f-6146-45b5-86f1-08d94ad8e68c
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3407D304FEB9DE4395C4DE4DE0E19@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MkcBN37I/oIuv7/+/VZswF/AjcOOlDVehOh6H9XL7AB3s7fEm8kAAymscJNW8OoYdM2mccddJ+JvUPUk89FXXjMoJMyoduBC22/+rC6mJnal9Tgv6jTuHC1ABYxGaURrexVehZ3Lw25kqsqgzgtZqOcyX6zMuz2DvmxWG++NH3ChLHtnfx4zS7EKb9dVJ2M4+agbAuoH00s0Q4IzRpRcuYxjPR47oNt92CArjzg9yCiKeScbK8xdKjNYTy4OSamUIfMZak8SIsGhhnY8amZd6frEFgUvQKVpJOGOBr/jxZ/An/tgGbLicfEziZx6Qjy9vGoxigrLikTdJNZmvL8tLRZ7ljAKxFR7x4uunpxTayKzwKHP1Phv6AVNkjAv6oMSWzmEQCvK7fPdxE4StOh3eI5XkKTZ24kGMbX+udLjQs6IagSU6OHJXoWy9xNSlUwQDVyWwvQF61pILjeuOwffkk0iX1SCZuDDNfCCYc/eGt4Zpg7aEjgd7Nln8Y4s290U63Dd6f8KvSSHl0jB3Pt6cfauxW/0FYBHMan4bFF9GXzBU4rrYQJYgyeX/VFpKYmq4pNUrpKp58xMQmf4Yf5bDVx++zxoewikDR37n7/wC0HTo8XsXEq7tY4WX36EezmaTZGfOv1FQ2YR+YJ/zU+T8FaUO2baBBSbkRBqtgDhrpAdbUaYZugKIywdL3hgpfMK+h1aSiLuotmvIgdyoL6Pyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(366004)(136003)(346002)(376002)(6666004)(6512007)(86362001)(36756003)(52116002)(8676002)(8936002)(6506007)(83380400001)(316002)(5660300002)(66476007)(4326008)(66946007)(66556008)(110136005)(2616005)(956004)(1076003)(6486002)(54906003)(38350700002)(478600001)(38100700002)(186003)(44832011)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T9PrauaXLrr2q+ntHSFo36UW2GqEHZiBxcr3qcBqxScXq9a7igD3n+0WhbwG?=
 =?us-ascii?Q?uvdBpk3dBs2inF5r/1fMOrobfFCjHUTenfdiZyjjTc8kykAKunhaRtUkrdE8?=
 =?us-ascii?Q?8A+6Ywfdom7fJIae7kJr6u0Az6d0zavYAPBBEHGRyPYVY0SrNTv7c0bSwDUs?=
 =?us-ascii?Q?74RaMRiqhr3G4DjXzN2A0ZqoXY9XVkaoRH0dhTqEfZLJrDMJMbJsLey39dzY?=
 =?us-ascii?Q?P2O4l9kp3iIVC57IAp3tRRuqUoSsMSGq9kHT9b4a2Qe6kilPeZvSTJczmo3j?=
 =?us-ascii?Q?5E8hjpBRPGHryxDMH4KidPSegf2MgAdUdewg/JUi7BRwCr+uMn4JUwAy8l/i?=
 =?us-ascii?Q?219tyHvCk+oCY2ZBIup+SKzju1yqNthBbr5gSITXcF6jWtPkJGIxjngpMSHg?=
 =?us-ascii?Q?5CnaioVTQ/HjWoYKz9NQvC6zdWj9rS79u9JTFZtmZhJ4RcM84yrDUi7V5Y+Y?=
 =?us-ascii?Q?YDt61OwI0wOKAAH1RzJcjkuSWEAA83iCWGoui8qYw92YARUzCNQrqYfQ4/AH?=
 =?us-ascii?Q?dPoa1aVNdaaoVH3ka6GhyhC1J34kdlfUNppkmQw+EkGxp3LDaDHFwmqWLJno?=
 =?us-ascii?Q?ikZh0SU8lWJaj5zMZCltBKDi+DspMpIQgpuLiQv6B9Kpal0TKMKmV5Hf1eSA?=
 =?us-ascii?Q?jgJwMPQ6mCAPu0w19+HFDS6RvRXDVjCevGVJZMVXrZ0+uZ4edjE6fbCpkfUu?=
 =?us-ascii?Q?v5KcIDzWQluQRRLlH2dwGzzvyCtMaosv1LLBGXiWzcpnEljREo1X71Cur/79?=
 =?us-ascii?Q?C90swa6Tkb1iFc8bidNgl3vIzz8mSDzLuX9TQuy3/ThdS9mJGv08hQVfxz70?=
 =?us-ascii?Q?seLy22VfbNaCLEN4GdbkiEl2q2lN3ORXr5HNiI1hfTNmBUZHAqOPoVjdPSeB?=
 =?us-ascii?Q?aTDhIhU+w9JslwYXMYWUcAfo74EwKYgO7d70QrK1i6xWxOl8rEWHkHDj1Z3m?=
 =?us-ascii?Q?Gbnd1UDJyn4hMyOoagqljVg4m+VtG5eYE0YJkWi2ig3Ir5KwXUdQ8yLjU2JY?=
 =?us-ascii?Q?8B2hBn7Uud8nGFn3bm+m9EK3oQNFwxq0T2LHUy4+22d0NGLQwOEoMzUAagrx?=
 =?us-ascii?Q?gSlZqmvybdJ9Ll3iYj+KAzkyI19senx/yUXdHXnLoX2Pcc38Clg9zWnS7cgp?=
 =?us-ascii?Q?H9VlRiDxsQFAVUoPmYVK0yquy40E/2/o5kN6kcOBqrYIDcPrmFGKRlyAnsEl?=
 =?us-ascii?Q?qqsePmi8AtIobFmY29yeD38sVxn3jGCxCDQFPouw/cY9P1DJUP1asgGLMUbO?=
 =?us-ascii?Q?i+2rGTo5PSud4aIA20gZ37SrFEDOb4egIzr8IldlK4WbDWdFft4nWRdu+LTs?=
 =?us-ascii?Q?xPdAHe3gra8tRLJr6nG/gHo5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd640e3f-6146-45b5-86f1-08d94ad8e68c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 17:16:09.3125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x+B1C+rtWXsg4EGULipD5I+kx+NXTJOPn+gOHcEwuWsGDGPg1xbTzbLB6WISCJG/6xbMOt5gLtjSV1ab5H0d2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upcoming patches will add tag_8021q related logic to switch.c and
port.c, in order to allow it to make use of cross-chip notifiers.
In addition, a struct dsa_8021q_context *ctx pointer will be added to
struct dsa_switch.

It seems fairly low-reward to #ifdef the *ctx from struct dsa_switch and
to provide shim implementations of the entire tag_8021q.c calling
surface (not even clear what to do about the tag_8021q cross-chip
notifiers to avoid compiling them). The runtime overhead for switches
which don't use tag_8021q is fairly small because all helpers will check
for ds->tag_8021q_ctx being a NULL pointer and stop there.

So let's make it part of dsa_core.o.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/Kconfig     | 12 ------------
 net/dsa/Makefile    |  3 +--
 net/dsa/tag_8021q.c |  2 --
 3 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 00bb89b2d86f..bca1b5d66df2 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -18,16 +18,6 @@ if NET_DSA
 
 # Drivers must select the appropriate tagging format(s)
 
-config NET_DSA_TAG_8021Q
-	tristate
-	select VLAN_8021Q
-	help
-	  Unlike the other tagging protocols, the 802.1Q config option simply
-	  provides helpers for other tagging implementations that might rely on
-	  VLAN in one way or another. It is not a complete solution.
-
-	  Drivers which use these helpers should select this as dependency.
-
 config NET_DSA_TAG_AR9331
 	tristate "Tag driver for Atheros AR9331 SoC with built-in switch"
 	help
@@ -126,7 +116,6 @@ config NET_DSA_TAG_OCELOT_8021Q
 	tristate "Tag driver for Ocelot family of switches, using VLAN"
 	depends on MSCC_OCELOT_SWITCH_LIB || \
 	          (MSCC_OCELOT_SWITCH_LIB=n && COMPILE_TEST)
-	select NET_DSA_TAG_8021Q
 	help
 	  Say Y or M if you want to enable support for tagging frames with a
 	  custom VLAN-based header. Frames that require timestamping, such as
@@ -149,7 +138,6 @@ config NET_DSA_TAG_LAN9303
 
 config NET_DSA_TAG_SJA1105
 	tristate "Tag driver for NXP SJA1105 switches"
-	select NET_DSA_TAG_8021Q
 	select PACKING
 	help
 	  Say Y or M if you want to enable support for tagging frames with the
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 44bc79952b8b..67ea009f242c 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -1,10 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 # the core
 obj-$(CONFIG_NET_DSA) += dsa_core.o
-dsa_core-y += dsa.o dsa2.o master.o port.o slave.o switch.o
+dsa_core-y += dsa.o dsa2.o master.o port.o slave.o switch.o tag_8021q.o
 
 # tagging formats
-obj-$(CONFIG_NET_DSA_TAG_8021Q) += tag_8021q.o
 obj-$(CONFIG_NET_DSA_TAG_AR9331) += tag_ar9331.o
 obj-$(CONFIG_NET_DSA_TAG_BRCM_COMMON) += tag_brcm.o
 obj-$(CONFIG_NET_DSA_TAG_DSA_COMMON) += tag_dsa.o
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 73966ca23ac3..16eb2c7bcc8d 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -473,5 +473,3 @@ void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id)
 	skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rcv);
-
-MODULE_LICENSE("GPL v2");
-- 
2.25.1

