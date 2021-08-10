Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D0E3E5ACA
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241125AbhHJNOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:14:51 -0400
Received: from mail-db8eur05on2062.outbound.protection.outlook.com ([40.107.20.62]:47684
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230214AbhHJNOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:14:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQyNPEYGBrxK2mmfSR7tZItfYubMirP6peK0W0I05Z7az9QMp0Sp0raGTWlA/GbNYgTAlN+JSzsnD8OStUmmbgrIgYC4sKbw4z6cgUcrKJ8+rGxHyameum1D6Pd3cXdehGt4UGgYXBbV6fiIyDpj1l8K/Wm+qn+0OejKGBAsHU2pmeIOceypIj5VT70oD6XFP+6bFGDUZfZ0qZ4wCwXOLRDMb7ChZX7Jr8zuOMAsAPwIpE3WHestshHAfGO+ORKIvrQ/xuIEL27L+kDanKi2RqS3v5kk/a3XfAFszUVH7SyzOetIU6po39CTLzlhfhCcnWNhGvVcilE51a3AjpjT7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QxoZpmZHSv3YxvCx0HpGTouDLnCp7rtC49Qi7C3+o+8=;
 b=lRBUXhi58jp3MBkwaQF8fuMHzFUummOlHnc7Vdy7jz/a2j0+U3oHqEEpQcgVHtLGYfJ8wIrOBO5Mt32fpD18U2E06qhXYIEVv7taFbqJCEmqUuQTL7C+4zOwlkAoeBR0Ut2hnFFLaNXV8fz1rYvugG+vUT5kr9nP+tj6eRTkMFc1RXxmlFtnnWheEkZyprP6QawnHydRdugRwvd+obTreeRb3aSCDPUKJUpfezI/xDcOYEUY9lOMSbH119HQEIB93Kb+GmW/1O3cMm0G4CV4I0ozTAfleqkxrL/UvFvWNxM/q1X9pkt5yzFxN1ShUKgpxhf7ycLcA6sZRO4RNfDYxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QxoZpmZHSv3YxvCx0HpGTouDLnCp7rtC49Qi7C3+o+8=;
 b=ee101Jsh645ElX5pc1P8v85zCGfsOzp8pY+7ObmeD/ADBf49Vb4dk0jw8ilzh622GzMFLitP0niSeJmRBKeXWkyLMfyMpdNGDHQ6Il3PWJy4xW3BJwWuN8Zvy5Z0OLxqcnl5X1FWlr0ujBla8q/eMf4GjRxLMFYvHvOUWKzifK0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6013.eurprd04.prod.outlook.com (2603:10a6:803:cb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Tue, 10 Aug
 2021 13:14:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 13:14:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>
Subject: [PATCH v2 net-next 2/4] net: dsa: create a helper which allocates space for EtherType DSA headers
Date:   Tue, 10 Aug 2021 16:13:54 +0300
Message-Id: <20210810131356.1655069-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810131356.1655069-1-vladimir.oltean@nxp.com>
References: <20210810131356.1655069-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0228.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR02CA0228.eurprd02.prod.outlook.com (2603:10a6:20b:28f::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Tue, 10 Aug 2021 13:14:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1581845e-8355-4f56-c628-08d95c00c1b0
X-MS-TrafficTypeDiagnostic: VI1PR04MB6013:
X-Microsoft-Antispam-PRVS: <VI1PR04MB60135256FF1D79DE39AB1094E0F79@VI1PR04MB6013.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n7vr6Wnf9bb9447VpM4XBw3dGoJ21sr4tfV5syjG8Ls6x7lexHFBGdiu4sNvCPEGBK78Zuaa8zbDmEZLEuOcxvT688y2FAmJ/S9yJ14+JQtvBhLGOKlEyFl+FYlJdfPBRrLGtUskGGnUAqIMwfFHgvhq+O7Flsb7+rajQCzST7PoGAHs/UCtr3kjYLB5WHfUrGTaKk8GjanCNOeUcNBQ53rEtHWhKJdnsj85QkcrbzIXYNTIJFBQwhOGN2SuKK9cvvfpfKGSdXhOAzaIGzpLbQv13S9AmxQh5x3oi7yEIlxatEQpG4aTOBPuUK3O/fE8tlLwxrLbZrhoMyJ+kNvnrHxaQFTLy37LJRi1VozAeRZyq7TCQoP5u+IYQL+/MYKwGdViFk4laiIDeep2uLUPoR6Njw5tofB7DkBEF/LdE2Un83MamEA6+jjuXR6gf8zLr/7rUVNSgoqno1qTXfFsVc6ocKhL3AcfrTYhJyraAXKfDjPEP9veNP/UmM2eewUWOKsIKohXZroAbtrTfyQAYB04mKulAM4bh/S4HZz47LsdLCzYrQsje0Vf1QP38QSNHwjbXUG1stE/al+tcylMQlaHjqjV+O6hGSGr/cMa4nAJe+1qejGXzqGCyiLjRViwxXw/ELKzuFEyg3Ri5/tqsRzA97lxrT5H7WvlA3rBJJTundPPUPLyxw114mGNEkq7r7206wyXxHIdGnGohFzTeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(366004)(346002)(136003)(52116002)(2906002)(6506007)(956004)(2616005)(36756003)(316002)(7416002)(26005)(86362001)(5660300002)(44832011)(1076003)(4326008)(6512007)(6486002)(478600001)(110136005)(54906003)(186003)(38350700002)(38100700002)(6666004)(66946007)(66476007)(8936002)(66556008)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7SU46wP+gES5hQhZurtaCya7ZY8PDoereWWf8TGDFr8yd6wqogNGjPen8PdC?=
 =?us-ascii?Q?q9wjvjXj3UAK8CbnrjR//CJQoIUyKKbDt0TYp59ZSrYYg+yJd7GTO1QcIrRQ?=
 =?us-ascii?Q?hIHu+NOaayqb5iUOSiUZg7UODdXDUaSLM8QzLw8uKv0vZPrvXpQURGlpQfWS?=
 =?us-ascii?Q?KHtjd21M2Sc5NlNqSZIHZSHBnzDG6pldYHdxrK64oIDeJmuLTyKtMgG4fEX4?=
 =?us-ascii?Q?mYCf4ZNdzjFRbT+WdyXAGVlkOXFZaYGMzvRBU4q/ENjwQQwLc7WahJUzOunc?=
 =?us-ascii?Q?+ekcV85fa4wnhj1y7pY2B6EYlsOaOvuI2qFhdKliM/LQoGFSArw/6Ep9wn72?=
 =?us-ascii?Q?oNXiPfpmPafQIdSm5xBBLamq6D5IQ6t2AAPqNsyyXLOQ+uA2vhPyfxYrKI41?=
 =?us-ascii?Q?eFr5RNEEmB7BEt1nIqb0mN4A5MpT8qpLNbbmWwy/HndTCdcGZDo0NDMAaZkp?=
 =?us-ascii?Q?M8BI6QFGXOn4ocPOpYYGJFL39tiOeLvackwcEEY4U1VIy1lpz7Vb9Mjlych8?=
 =?us-ascii?Q?bpiONltoo/YCCBFF1GYDKFmyZZCBa1ipMJTSQle82S+YcQtP3yRgX8gjTzuH?=
 =?us-ascii?Q?Gy0DXMc8rjn/vlWQiY/NJeCSzJ3FdnucYCPYd5sVEnvwsuOdETXQelkK4hao?=
 =?us-ascii?Q?rBslP23pHv0WTPAhG72SBHXffVXyDVsJ3NWvc7r01VEjyyndBQgkv7JQEc6L?=
 =?us-ascii?Q?0buK+del6IgIIb/7NkvoaNcIq/I3R7M+zrVXfIAqRtQQp07C4UNIRROtPKqc?=
 =?us-ascii?Q?8Ic5Tu4WG3Ez9gXrxw33rIW9JEGyOMaMmjr11MOgl7QMBcoNzC4vfGvVO2vM?=
 =?us-ascii?Q?ajxD7v6Qg+S4Zs9twCYmWuFhdDhvEduCmoMChTCZxsmTMMFMHRv6bk2Oc/i9?=
 =?us-ascii?Q?p0FdHhEuaIXTG8t6y/Im+C8e7gCCeHo5j902WUB+ixZwDKOxiILkn4++MebM?=
 =?us-ascii?Q?THn+Vw7CZ3hP2Unm9zQ0ySvcnH6OaPFo+ktciYC/GhRgZ0LLl/oZ1iT2Z3qa?=
 =?us-ascii?Q?3qQg7IjuDvPIWxXrg/575F4SEaJmTQuO2UARwn8YUGePiA6CJo8+3mI2Vs6z?=
 =?us-ascii?Q?Ow8A0juxkXVTe/I/lOC7c700k8eMhe1hYLZafqLgw+zbHY2V/3ZKZt1jYk0a?=
 =?us-ascii?Q?RMuJbVEsByn60j9Q20ogltk6yqA3NGuIjURvZg1lEj3lEg+TXH0QPtR0WgQJ?=
 =?us-ascii?Q?UCgnxPQ+bOOnOHda08HfXhSJwhAetVqFefGoR1MyhCzEdePhPJI0c8vSDZCP?=
 =?us-ascii?Q?je5PpSnn7zIwj0zZ4cbWhJSzm8bJPo0wmmvwFesYOF9GtSj7DmukthXviP8K?=
 =?us-ascii?Q?eRhGsn+qNduk8NYgwM45H+q1?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1581845e-8355-4f56-c628-08d95c00c1b0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 13:14:17.0428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vWmEMBvMcsZzt0hpcmW4NLuhf4BnEvxFFEoOlHkAR7Kdp5MfaRJik3TXv4GuJtABHOXxKoyO2eDuA5HYJx1uAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6013
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hide away the memmove used by DSA EtherType header taggers to shift the
MAC SA and DA to the left to make room for the header, after they've
called skb_push(). The call to skb_push() is still left explicit in
drivers, to be symmetric with dsa_strip_etype_header, and because not
all callers can be refactored to do it (for example, brcm_tag_xmit_ll
has common code for a pre-Ethernet DSA tag and an EtherType DSA tag).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa_priv.h    | 29 +++++++++++++++++++++++++++++
 net/dsa/tag_brcm.c    |  4 ++--
 net/dsa/tag_dsa.c     |  4 ++--
 net/dsa/tag_lan9303.c |  2 +-
 net/dsa/tag_mtk.c     |  2 +-
 net/dsa/tag_qca.c     |  2 +-
 net/dsa/tag_rtl4_a.c  |  2 +-
 net/dsa/tag_sja1105.c |  3 +--
 8 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 8a12ec1f9d21..28e1fbe64ee0 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -478,6 +478,35 @@ static inline void dsa_strip_etype_header(struct sk_buff *skb, int len)
 	memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - len, 2 * ETH_ALEN);
 }
 
+/* Helper for creating space for DSA header tags in TX path packets.
+ * Must not be called before skb_push(len).
+ *
+ * Before:
+ *
+ *       <<<<<<<   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
+ * ^     <<<<<<<   +-----------------------+-----------------------+-------+
+ * |     <<<<<<<   |    Destination MAC    |      Source MAC       | EType |
+ * |               +-----------------------+-----------------------+-------+
+ * <----- len ----->
+ * |
+ * |
+ * skb->data
+ *
+ * After:
+ *
+ * |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
+ * +-----------------------+-----------------------+---------------+-------+
+ * |    Destination MAC    |      Source MAC       |  DSA header   | EType |
+ * +-----------------------+-----------------------+---------------+-------+
+ * ^                                               |               |
+ * |                                               <----- len ----->
+ * skb->data
+ */
+static inline void dsa_alloc_etype_header(struct sk_buff *skb, int len)
+{
+	memmove(skb->data, skb->data + len, 2 * ETH_ALEN);
+}
+
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 2fc546b31ad8..c62a89bb8de3 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -99,7 +99,7 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 	skb_push(skb, BRCM_TAG_LEN);
 
 	if (offset)
-		memmove(skb->data, skb->data + BRCM_TAG_LEN, offset);
+		dsa_alloc_etype_header(skb, BRCM_TAG_LEN);
 
 	brcm_tag = skb->data + offset;
 
@@ -228,7 +228,7 @@ static struct sk_buff *brcm_leg_tag_xmit(struct sk_buff *skb,
 
 	skb_push(skb, BRCM_LEG_TAG_LEN);
 
-	memmove(skb->data, skb->data + BRCM_LEG_TAG_LEN, 2 * ETH_ALEN);
+	dsa_alloc_etype_header(skb, BRCM_LEG_TAG_LEN);
 
 	brcm_tag = skb->data + 2 * ETH_ALEN;
 
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index ad9c841c998f..ab2c63859d12 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -166,7 +166,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 	if (skb->protocol == htons(ETH_P_8021Q)) {
 		if (extra) {
 			skb_push(skb, extra);
-			memmove(skb->data, skb->data + extra, 2 * ETH_ALEN);
+			dsa_alloc_etype_header(skb, extra);
 		}
 
 		/* Construct tagged DSA tag from 802.1Q tag. */
@@ -181,7 +181,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		}
 	} else {
 		skb_push(skb, DSA_HLEN + extra);
-		memmove(skb->data, skb->data + DSA_HLEN + extra, 2 * ETH_ALEN);
+		dsa_alloc_etype_header(skb, DSA_HLEN + extra);
 
 		/* Construct untagged DSA tag. */
 		dsa_header = skb->data + 2 * ETH_ALEN + extra;
diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index af13c0a9cb41..e8ad3727433e 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -62,7 +62,7 @@ static struct sk_buff *lan9303_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb_push(skb, LAN9303_TAG_LEN);
 
 	/* make room between MACs and Ether-Type */
-	memmove(skb->data, skb->data + LAN9303_TAG_LEN, 2 * ETH_ALEN);
+	dsa_alloc_etype_header(skb, LAN9303_TAG_LEN);
 
 	lan9303_tag = (__be16 *)(skb->data + 2 * ETH_ALEN);
 	tag = lan9303_xmit_use_arl(dp, skb->data) ?
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 6a78e9f146e5..06d1cfc6d19b 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -41,7 +41,7 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	default:
 		xmit_tpid = MTK_HDR_XMIT_UNTAGGED;
 		skb_push(skb, MTK_HDR_LEN);
-		memmove(skb->data, skb->data + MTK_HDR_LEN, 2 * ETH_ALEN);
+		dsa_alloc_etype_header(skb, MTK_HDR_LEN);
 	}
 
 	mtk_tag = skb->data + 2 * ETH_ALEN;
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index f9fc881da591..c68a814188e7 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -36,7 +36,7 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	skb_push(skb, QCA_HDR_LEN);
 
-	memmove(skb->data, skb->data + QCA_HDR_LEN, 2 * ETH_ALEN);
+	dsa_alloc_etype_header(skb, QCA_HDR_LEN);
 	phdr = (__be16 *)(skb->data + 2 * ETH_ALEN);
 
 	/* Set the version field, and set destination port information */
diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index ff8707ff0c5b..06e901eda298 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -47,7 +47,7 @@ static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
 		   dp->index);
 	skb_push(skb, RTL4_A_HDR_LEN);
 
-	memmove(skb->data, skb->data + RTL4_A_HDR_LEN, 2 * ETH_ALEN);
+	dsa_alloc_etype_header(skb, RTL4_A_HDR_LEN);
 	tag = skb->data + 2 * ETH_ALEN;
 
 	/* Set Ethertype */
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 5e8234079d08..939161822f31 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -245,8 +245,7 @@ static struct sk_buff *sja1110_xmit(struct sk_buff *skb,
 
 	skb_push(skb, SJA1110_HEADER_LEN);
 
-	/* Move Ethernet header to the left, making space for DSA tag */
-	memmove(skb->data, skb->data + SJA1110_HEADER_LEN, 2 * ETH_ALEN);
+	dsa_alloc_etype_header(skb, SJA1110_HEADER_LEN);
 
 	trailer_pos = skb->len;
 
-- 
2.25.1

