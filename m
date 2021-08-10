Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A633E5ACC
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240561AbhHJNOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:14:48 -0400
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:28640
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240574AbhHJNOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:14:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fq6848kTzQ0j8bmxH7wbFd2eyv9Zg0Rzc3a6p/eYY9VNjcrHghIslYf75E6v+jmiZ81pcq5fO7tjv9SeDg4xOz9UZ6XtPv/7Yt/HQLmMHLdysiOFfFd+CLkl9/Gm87DWHzmw2FComQWv6mb4dB/FFr06QQ9Wndwzm0aUKmYTp4+LLOtMuOewKC7gEGXSl8yqcs6LQlS/uV1EFh+sqCSkRsOBbMEZIagKfi4hPV4x9/BgBG9IBbthZiJyZvL8mJ1ob2NcqFDXFNb7APBzMA7442JGmRnjPdmTB4IeFHEjxb9O8LFz4CF6pGO/M/LkWUlSL/K31ISxoZga/o+WuSKb+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+iPTgYox/DcBCPz5437/Eo/vms7PZS4C+yt8q8gckt4=;
 b=ReBiiVkHS0VFF8oOAV+3Lj9cXA10++yspItQjaeZEV49CwXFbUlVytiyuGXukwhNbZ4wVlgA/2ZI9AGfpH74LvkV+ESykQqWMR1IwtOBIx+VYk1aYtQFuvVkBK++QEXxQEisGH8jMWqSRU+96/+JP/y7nxMBojaAuww9ooyKNk3jcRxi4sGvGm3dbbjBlOL4zlc59xd4L3PMJ2B37UXQLH1qFyZqcpCy8AgCJ0MTcc8oRPMGbbBjl3MIL1SFzOUZOM3sKWVIxq4MNpFLhuCEiYwovY9BL/NJd3XnF6aT0CH4M1oxd5xKIa+mmX5ohtzH5OjIcWOJKthBttHzX+RAEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+iPTgYox/DcBCPz5437/Eo/vms7PZS4C+yt8q8gckt4=;
 b=jAfkTbWcS3Je2BlsbUdX74rfSQPdzXZWkiIruaMgsWJ2j35emLKyUfA5jQ4somdKJw18sfzrJBpzc3uvojSjOcdlOH21XgftDLVCsu7MQdBzK0zP9g/ylY7h9DP4E27826VEgkBEao1+ZT7DaYmfErfMQ4PU5zIaPW6KYNoyVZE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7119.eurprd04.prod.outlook.com (2603:10a6:800:12e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 13:14:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 13:14:19 +0000
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
Subject: [PATCH v2 net-next 4/4] net: dsa: create a helper for locating EtherType DSA headers on TX
Date:   Tue, 10 Aug 2021 16:13:56 +0300
Message-Id: <20210810131356.1655069-5-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by AM0PR02CA0228.eurprd02.prod.outlook.com (2603:10a6:20b:28f::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Tue, 10 Aug 2021 13:14:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fd74470-8567-4bac-f7a4-08d95c00c345
X-MS-TrafficTypeDiagnostic: VI1PR04MB7119:
X-Microsoft-Antispam-PRVS: <VI1PR04MB71195E927067BE55D4367388E0F79@VI1PR04MB7119.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4AhVHFW0q5tKYb7AfsLKAcgwglb8mNqJXPblqpTOQDAaNnxi9zLTA2oHshcpyno9ogWA9Lg5/OrqyDfQe6jJpiMy68A46hgEvUOSZWZZzxGaCxUXo9QbLpNpEdboMpbEBLFMy4KmqTC4QAklfqn55WJ1AYmljmd/0wERiEn5iv5Ad+aFn3SBPfo4rwOYDi9Rgz3AxG/9rNws226cbWJQrW7UASktIo2KjXhql/3Y91MhxTB/V2z2g6SSSnEZ17osodX5IKedrHml6RH2i0ry2mF0Ri9dZHISk2wn5j4uu/T8W2Hpb1YBzVYPmr8V/hlSvRT0WlBXlXv9m7qvWENBc1FOEZHuhyBSR9uUA+5oLkIFF+0zD1Y1hcQIXXLA1+VPXmhp/2Ulnrkt06YPwv/XGMTddpVAlgKW9ZOHaT9f+HJc7C9AqfC8GauzHRYOh5Rn5M2HL6BEwnFtcUCHjJqMWSokmbTdbsIyKQxcvjflIJh+kJVZixNeAcAqTVnsGEcatKKv0qySPHCWi4/PdDVu4PF01mcOtq5msgA5YDcVbra0F4ybLy8W8FP3I/rf2Z9XO8NcOt+QZ5lciOECxULKwSKWtK2VmUKQJH0gaQTs1EHALIts5xrcX2H2338PruXog9/MogQvaOY1q/IwwJbmG1bNVFWWJLNJI53v+WQyf7Xta2OTGw/onWRIo5hI3wqOBj/lEGDXaShoJYgxbNKwLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(186003)(26005)(478600001)(8936002)(4326008)(52116002)(2906002)(8676002)(38100700002)(66476007)(86362001)(66556008)(6506007)(38350700002)(6666004)(66946007)(36756003)(6486002)(1076003)(956004)(2616005)(316002)(110136005)(6512007)(5660300002)(44832011)(83380400001)(7416002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YuYSWR4JN8Adq+6ulms4To/+QdQlBegcGamVQ+F+5o65zbsIB41x/5G/lSIy?=
 =?us-ascii?Q?N70Qjn9dU0DOXhrbOC73PmbeerA3nnYFgk0yyFCnK466qGITDA3NJDHMi3TY?=
 =?us-ascii?Q?kCYYHOcFd7heok74j2riomvx/NiQUcLG7R4xK5aas1jYxOuZM/OkBWx+jhJ9?=
 =?us-ascii?Q?ARo68soCpi03kqJ664mgLIW6DKxIf3AITSI8u+/9gE4s4SIluYVuUGeEA0e/?=
 =?us-ascii?Q?hh1RcVa8/UyJx1QznEXtCClUwHFMBJTRYe1HqdrOTAWqZ4uJS3CV4F+UVbM2?=
 =?us-ascii?Q?m4xWnpMZgErh7l+ORUYGw/XNbZpQK5bNyNv1H3T3aS83azV/y/wi3x56UX8f?=
 =?us-ascii?Q?IJ8TwzMxFWYtzcrL+V25hci0rTu0vINkNQhqukwv3rozSUMl0rnEuogPs4M7?=
 =?us-ascii?Q?wQM6zjzFcqqZ6205K1xUMrGAcIFCsIUJoq+diHnsAIuSZLgMmCWU0Hy+/mdh?=
 =?us-ascii?Q?st+YeWSM1KyheCAOCrAuMJxCj/skV/zG/QAAfQ1FaaJcakNqoMMQJQuLWgKp?=
 =?us-ascii?Q?W+jR8WhOtZIea0GERIYN7d3OlUSSRdw6sjAbnoO22W1ZpLD12wibZpjleyX4?=
 =?us-ascii?Q?rkzIY62s7DJD7R/OvSwmNaS/HzSctByFBjEMiQmLQyi7DozNR5ihcelomjI+?=
 =?us-ascii?Q?aEcFo4Ye/7Di20+12FuGPWAkPaaUz+/v0xVd14WZI5rphs22yr3UOMsvQV4a?=
 =?us-ascii?Q?QFA9vUUFHLVPDkx/TmnOdgn1MySalYS5tj+DL4ZF/gVnXKXq6a7WplVycgtm?=
 =?us-ascii?Q?Hkl0orBuw/lH+lTUUiVQKIageweovwHZ6aCNGxnuBDk9mgAXaNGKdCr7hnbA?=
 =?us-ascii?Q?/ifWvD0VavERn8xybUggOjoVjbsDS/4bY07KmAzwFqmy+nLduEK5sLi4hlIb?=
 =?us-ascii?Q?Nvdi8Ia+uyP3LsDxMROLAUJhE6t0+acQdovU3Uenf/4QFQasgq2VrXo+rZKr?=
 =?us-ascii?Q?IlJEYvn2iR+VLNcMxkdgZEOnrlue+8JQYN+rumUzfLO9itNtNXSBB/Hk9jAL?=
 =?us-ascii?Q?leaFnF0jPYa0SPt2ZoLDNFl1lrS8TcXrC3AFakUrrMcoTDGBM+kRot89Tyli?=
 =?us-ascii?Q?Bu1xYdQMRsXiN718fQxvrkVE4VcgRU5I4WpckPDRwbZg6aY5hO1UNkYihaB9?=
 =?us-ascii?Q?2zVJciukca/wWSjs5AsSyW8rIJJbcu3zNjJL87ExZCzLEv/Y2iDP2YumxVAa?=
 =?us-ascii?Q?pd6tWkFK5au8cUlJw70lrmn33IwnxBHmOXnhtLUqvqSQaONAFxv7t5QdIvzS?=
 =?us-ascii?Q?eO1MMknx9790bHqJcKvIUm/MXoZAizpNuHF3Bo8DhT9t3+9guZb+502SWAxl?=
 =?us-ascii?Q?GUHN9Ha7JPh6NwNzeroUA9D+?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd74470-8567-4bac-f7a4-08d95c00c345
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 13:14:19.7842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2o00ESUNuH8dyes/SGCNwCGmiMVeUDi1kUr1mwq+7jxzi/7SAbgmefL/uf1gCYDOWYH7TVEDfUJ7Akm7Cjcsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a similar helper for locating the offset to the DSA header
relative to skb->data, and make the existing EtherType header taggers to
use it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dsa/dsa_priv.h    |  9 +++++++++
 net/dsa/tag_dsa.c     |  6 +++---
 net/dsa/tag_lan9303.c |  3 ++-
 net/dsa/tag_mtk.c     |  2 +-
 net/dsa/tag_qca.c     |  2 +-
 net/dsa/tag_rtl4_a.c  |  2 +-
 net/dsa/tag_sja1105.c | 16 ++++++----------
 7 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index ee194df68902..9ea637832ea9 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -521,6 +521,15 @@ static inline void *dsa_etype_header_pos_rx(struct sk_buff *skb)
 	return skb->data - 2;
 }
 
+/* On TX, skb->data points to skb_mac_header(skb), which means that EtherType
+ * header taggers start exactly where the EtherType is (the EtherType is
+ * treated as part of the DSA header).
+ */
+static inline void *dsa_etype_header_pos_tx(struct sk_buff *skb)
+{
+	return skb->data + 2 * ETH_ALEN;
+}
+
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 2eeabab27078..77d0ce89ab77 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -170,7 +170,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		}
 
 		/* Construct tagged DSA tag from 802.1Q tag. */
-		dsa_header = skb->data + 2 * ETH_ALEN + extra;
+		dsa_header = dsa_etype_header_pos_tx(skb) + extra;
 		dsa_header[0] = (cmd << 6) | 0x20 | tag_dev;
 		dsa_header[1] = tag_port << 3;
 
@@ -184,7 +184,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		dsa_alloc_etype_header(skb, DSA_HLEN + extra);
 
 		/* Construct untagged DSA tag. */
-		dsa_header = skb->data + 2 * ETH_ALEN + extra;
+		dsa_header = dsa_etype_header_pos_tx(skb) + extra;
 
 		dsa_header[0] = (cmd << 6) | tag_dev;
 		dsa_header[1] = tag_port << 3;
@@ -360,7 +360,7 @@ static struct sk_buff *edsa_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (!skb)
 		return NULL;
 
-	edsa_header = skb->data + 2 * ETH_ALEN;
+	edsa_header = dsa_etype_header_pos_tx(skb);
 	edsa_header[0] = (ETH_P_EDSA >> 8) & 0xff;
 	edsa_header[1] = ETH_P_EDSA & 0xff;
 	edsa_header[2] = 0x00;
diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index d06951273127..cb548188f813 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -64,7 +64,8 @@ static struct sk_buff *lan9303_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* make room between MACs and Ether-Type */
 	dsa_alloc_etype_header(skb, LAN9303_TAG_LEN);
 
-	lan9303_tag = (__be16 *)(skb->data + 2 * ETH_ALEN);
+	lan9303_tag = dsa_etype_header_pos_tx(skb);
+
 	tag = lan9303_xmit_use_arl(dp, skb->data) ?
 		LAN9303_TAG_TX_USE_ALR :
 		dp->index | LAN9303_TAG_TX_STP_OVERRIDE;
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index a75f99e5fbe3..415d8ece242a 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -44,7 +44,7 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 		dsa_alloc_etype_header(skb, MTK_HDR_LEN);
 	}
 
-	mtk_tag = skb->data + 2 * ETH_ALEN;
+	mtk_tag = dsa_etype_header_pos_tx(skb);
 
 	/* Mark tag attribute on special tag insertion to notify hardware
 	 * whether that's a combined special tag with 802.1Q header.
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 79a81569d7ec..1ea9401b8ace 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -37,7 +37,7 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb_push(skb, QCA_HDR_LEN);
 
 	dsa_alloc_etype_header(skb, QCA_HDR_LEN);
-	phdr = (__be16 *)(skb->data + 2 * ETH_ALEN);
+	phdr = dsa_etype_header_pos_tx(skb);
 
 	/* Set the version field, and set destination port information */
 	hdr = QCA_HDR_VERSION << QCA_HDR_XMIT_VERSION_S |
diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index 947247d2124e..40811bab4d09 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -48,7 +48,7 @@ static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
 	skb_push(skb, RTL4_A_HDR_LEN);
 
 	dsa_alloc_etype_header(skb, RTL4_A_HDR_LEN);
-	tag = skb->data + 2 * ETH_ALEN;
+	tag = dsa_etype_header_pos_tx(skb);
 
 	/* Set Ethertype */
 	p = (__be16 *)tag;
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 34f3212a6703..0ed379a28ab6 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -223,7 +223,6 @@ static struct sk_buff *sja1110_xmit(struct sk_buff *skb,
 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
-	struct ethhdr *eth_hdr;
 	__be32 *tx_trailer;
 	__be16 *tx_header;
 	int trailer_pos;
@@ -249,23 +248,20 @@ static struct sk_buff *sja1110_xmit(struct sk_buff *skb,
 
 	trailer_pos = skb->len;
 
-	/* On TX, skb->data points to skb_mac_header(skb) */
-	eth_hdr = (struct ethhdr *)skb->data;
-	tx_header = (__be16 *)(eth_hdr + 1);
+	tx_header = dsa_etype_header_pos_tx(skb);
 	tx_trailer = skb_put(skb, SJA1110_TX_TRAILER_LEN);
 
-	eth_hdr->h_proto = htons(ETH_P_SJA1110);
-
-	*tx_header = htons(SJA1110_HEADER_HOST_TO_SWITCH |
-			   SJA1110_TX_HEADER_HAS_TRAILER |
-			   SJA1110_TX_HEADER_TRAILER_POS(trailer_pos));
+	tx_header[0] = htons(ETH_P_SJA1110);
+	tx_header[1] = htons(SJA1110_HEADER_HOST_TO_SWITCH |
+			     SJA1110_TX_HEADER_HAS_TRAILER |
+			     SJA1110_TX_HEADER_TRAILER_POS(trailer_pos));
 	*tx_trailer = cpu_to_be32(SJA1110_TX_TRAILER_PRIO(pcp) |
 				  SJA1110_TX_TRAILER_SWITCHID(dp->ds->index) |
 				  SJA1110_TX_TRAILER_DESTPORTS(BIT(dp->index)));
 	if (clone) {
 		u8 ts_id = SJA1105_SKB_CB(clone)->ts_id;
 
-		*tx_header |= htons(SJA1110_TX_HEADER_TAKE_TS);
+		tx_header[1] |= htons(SJA1110_TX_HEADER_TAKE_TS);
 		*tx_trailer |= cpu_to_be32(SJA1110_TX_TRAILER_TSTAMP_ID(ts_id));
 	}
 
-- 
2.25.1

