Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019743E4525
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 13:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbhHIL6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 07:58:17 -0400
Received: from mail-eopbgr40056.outbound.protection.outlook.com ([40.107.4.56]:40885
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234840AbhHIL6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 07:58:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSPg5ul5Uroi6SvYQr6k9wQqtxcRble+h1UBe+aV8724gQ7fxWIO8UzzFfJLUQJX3gTroH1HiJs0l2SnUi2n3NsWsNHdo4EKE8ogYHW4ztooO5yX2cpgkVNQCcAN8g3zJGvW4cmKvhqSUz6fNCM8+tGcWkiq/6/pezBrD8jjMYPWmcpir+JZ5XI32ybudsnILhxQPDOcARNreOIb/gIv0AxOCDgY1r1WG5dKLIgF/dxMG54b/atSd8kGNK+w7whtMBP/O9m/0Z61HceNYGD5BQpUH/hOfzrygfV2Apo25PDhm+PZbBWQYiRSXix5Z4p5Aet4O6yRxfEYVfR4vwvvjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxeGAZK8Kz0NFoLMwJ0rkare1ml7C30XwCYZ+/GRlBY=;
 b=KfnuRwYJEqbV/eVs+7ifv4af4Fauxc4i/PTzWoDUFidQDO/1HXFNVLJpSH4lfhi2RuETc2kugkNiwFm2vZI5h2RH3Aw8iCRXPO5Nplf6faK4sqXnZXQvmrCiVHhZfU61GlGxX1kCzC3FY8uSz1ZfrM+XZ30yatDKzq1rMC7r+qQCa1cMY/hQ9gQ3iGjcov3vDZ5uRW2e8iPfeRHk21D0OBpNryVESmfHx3Oj3zEUsTlqrIvvTeqpF9Vs/gQqGGzkKv9Dc9FD4GZ0YH2s9ARbLKtxGHs5bJn2idcJ24eSVIaqmyYQdgqnZitR+tI62NK35tj82HUeTrvYzbaKObjnzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxeGAZK8Kz0NFoLMwJ0rkare1ml7C30XwCYZ+/GRlBY=;
 b=dWEC9YHkeJBvCcX32zDLdrCD6IClP/DvAI6ZPncG0HKXUYE+YnIApj+u8trKS2+xVqMksSv1Sh+u/X3qsMdRxhXW2B+5tEIz3lXHYAuN5A4R67ComeTo+SxAaOs/+3ElRgCwfyToJIj6ugV4oEX3K5F2uuOn3r1yWbsQjyVWpbA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3712.eurprd04.prod.outlook.com (2603:10a6:803:1c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Mon, 9 Aug
 2021 11:57:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 11:57:46 +0000
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
Subject: [RFC PATCH net-next 4/4] net: dsa: create a helper for locating EtherType DSA headers on TX
Date:   Mon,  9 Aug 2021 14:57:22 +0300
Message-Id: <20210809115722.351383-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809115722.351383-1-vladimir.oltean@nxp.com>
References: <20210809115722.351383-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0012.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VE1PR03CA0012.eurprd03.prod.outlook.com (2603:10a6:802:a0::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Mon, 9 Aug 2021 11:57:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92d65704-c099-45dd-1476-08d95b2ce759
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3712:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3712B7D1A0DDBE6F36BC65A2E0F69@VI1PR0402MB3712.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8XDr+EIHzOlk81l1vz9dRRhyYYU6QaNP/ydIlgDLpU0zFHcwmcdWSJqVFqsAoQaoOGjku6uW9qpWzNusAwWZfwgkqW8amDOKaTf4mtM0MjSBcy4D2J3aRcLl4BpeWxICed0GX42JSMiJG2LAjM6SxjFU3os6gd8LIpYZ5vIhqOMrgpDnM7DTWldujZlR1CyUczNO/FDV+N+hFN6CLY2YI/eFoj5a49WjSRd9W8c1xqn3fAScb7lJjL3U3KSgZ1EqQOcLh9jEpzZkbV5quNNkXEcEvV8drhUw1hbgHWHmJPpuCRkwWe/bc60jA6l9a6+mL5mTTVWwIiBsSjEO1WFT/4RLOyPJJZlm5w5IuvqbZSpR36cuiwBWUzWjy9ASVQx9psvkT7JYU0GhrGSy+DYlwwpyVLbqHtg9e8XI0TWLJj5AkLfZ5W7si6oRKyxHkco8eSUFUq/TNVN1LWFlFkpSwNQ/zWW94HwcT1/bSJgZmmRQvBmoyNqLEsvdo8AojJ2wjO9jjmU+DnfIgCQgmy1R63yxQzdQ4wn5Q8xO4pg83TADkSRL0cFmg7euHokmr9DVsPfcK0ja/sz3rmmn82UA55QogVzeD1INIUXabg00qC/cLxMxZO30wSpttenIRiugqU/L3aszbI+hffAr7h/gwkhaK66+wWYZSzpOoihGgf9+5LXBPqjESsXWIHifFKUcvEXRJtzuK584zDO0Z4MOpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(44832011)(6486002)(6666004)(5660300002)(36756003)(52116002)(38350700002)(4326008)(38100700002)(2616005)(86362001)(956004)(66556008)(66476007)(7416002)(6512007)(316002)(66946007)(26005)(110136005)(2906002)(54906003)(6506007)(1076003)(8676002)(8936002)(83380400001)(478600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?06cm0iKkHeyIUUmleoGZSEXYhuvUEbb/JyWGmc+Z56h909gbTx543A3J8ejQ?=
 =?us-ascii?Q?nnSiyfI7XfGbcHfOQcWH4+B+/dJilzssCYrdokuLOBjQQ01C3/SRh318TTFb?=
 =?us-ascii?Q?Us07ybtGb5LeYwGnEcaANWKm5zwraILeRBTYMsxo/Yxmvehj9XTl0W9sRjPc?=
 =?us-ascii?Q?nfdszNTH+GeIeKqKtiAE962620HxA51xj/DglWtdWCN6ivpisnO1m+8/V118?=
 =?us-ascii?Q?oG36Eh+SBAo7jbW/NtOicIqufI4LpuSIrD8pfU+V/b12Oi4Z7ygAjc0H41D7?=
 =?us-ascii?Q?Mk0jukLiNOeO12ITCEnBCBybnmOu+hqCx47S0QeZ6ilrHzJHy1xcU9bmzDAP?=
 =?us-ascii?Q?eBSMve8CUAPSc89Sop977c1zbslms8HZABeo8DOo4Z8IWvZolSJOe84tW8+3?=
 =?us-ascii?Q?uasNHlmnxeE1CNM7uglV4u4n/H9aLug8TYK5TtjlqCvHrLMEuXmjp9gUH8Iu?=
 =?us-ascii?Q?UPDNh2q4AcG12TQizo3EflJHSzUR1KoMStqBhHGZ8HDdu+r4kyPLjF3QzRjG?=
 =?us-ascii?Q?EKRlEhZ5dWKKixHus7SI79GRSRHzXxXDLTh8PfNGgt4tbT0cIvjbWakxCjf9?=
 =?us-ascii?Q?lOGJw/c3awcIvwWdBlAfVzNucL4JwK0g0jRhaR4R16TJtF1elW/ff+eGIC8b?=
 =?us-ascii?Q?Tzb3eXe40O4QiqYGz2zaRwhoGDHT3KbSLZH9NccpzPAVbs2eqzY6XTyP+0Bw?=
 =?us-ascii?Q?yAE8lcA7X7K46RMDNtFf5y77yCFDe0vwm8TRJ0Cy7Td0H51KGUyXGQFq85Dv?=
 =?us-ascii?Q?em77ODyHz7tWpM+tF6jOjpwBjiAoLufDuUqJQDbUVKopK5ERM3RFhtQMzxNo?=
 =?us-ascii?Q?hxUA3r/glLt+mh9pgvmtW/s0OMBhCXPFY6ilqRS0CXCHkr63O6igR+5HnmwP?=
 =?us-ascii?Q?LIhIWEy0PFR4TA+em6dasL3BThox3VIUeuF3YSXmn9Xh04isuiNiRcAh1QeE?=
 =?us-ascii?Q?gUEDFupO3pnIr3YTcrsV72fUxYHP64YuSgRbBkQE+N9I4k9K46ILkeRGupu7?=
 =?us-ascii?Q?DvkX9wG0nLaVsfVrZWjA0YA2hpPXq0IuYryVLP/8BIrLb6jxc/dHiy1KVtex?=
 =?us-ascii?Q?XQxTMaJhx7Df8kVEUCl42G4QsvxsFRtfPvXEDpFMBtPR9phEu5t97IW/Nmnp?=
 =?us-ascii?Q?QqLyyD1S5NrAf6eaWxbdXviJG00yZoWEYxfEXMOMKsUdz4C9z8hWwuQa7wON?=
 =?us-ascii?Q?zphyks1jORGdYLiXuU/KPbKs4OzT2iLGMoUIScGLvPeyns5N9bUejiXGglp9?=
 =?us-ascii?Q?Bckk+m2WjtZMff/q1YFD5uYMGN6+8c3EKVIpshnoFLDAmjYZEAspySdPK+RS?=
 =?us-ascii?Q?IfcQ5HQ9HV2OKJJ0gydlmloT?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d65704-c099-45dd-1476-08d95b2ce759
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 11:57:46.9038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: po1pGR0jhULgmSp6fGgKeTs8jzphvureukGUyFosRpTYYqQEz6vx47KAKqCaP7Jv120SBgNhl+G2aIxxhew9Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3712
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a similar helper for locating the offset to the DSA header
relative to skb->data, and make the existing EtherType header taggers to
use it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
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

