Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895223E4524
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 13:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbhHIL6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 07:58:15 -0400
Received: from mail-eopbgr40056.outbound.protection.outlook.com ([40.107.4.56]:40885
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235148AbhHIL6N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 07:58:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UO3ysSBH+YaRP6ylIcj15Uf4g4A6ycJxtRa2qQ3NY1hws0Eoxr/hKW3Hu1v1PjQnbejCu2f8T5rqk/qvammUiUomBcy+U2L6hlrFu3LoWBM4BxpnXPEtW2WcsZXeLWxEgT1bF3mmrlv77LWcDi9zF2+rDs1Gnb/iW4XDTbIKbTY3Z/qyrQ+LsiCEUWZsR/1J5rrswnyPLCwStLyL85V25wZ3rTQFl6PkduBzmpX5u6G8M4vDGhEJHZaVRRhgtrsqK2Ol5SykXVt8IrQISKdI9437Vf+ii5A9CZ3Vj9RkNTBNAWvgZjCoR/Y7u2UPzc9XqwxvAq1ne8Wm1mRIPvjPLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fRf5iVzoHiLMjdx+tXdiEL1+iucDTN9QEFL9/Sj0Cs=;
 b=MJVth7c+FydcXTcb7A+jJ6KPu0/HcWIehxySaiuM7L5onbmU4686Wb2iOzcAjsNpu2Dcsx49+eF2vQW1JW+gbeQ2/w3Pp1Ega4+P61OZwISMU6Bn9KdSTdefWxeGLkZJ+7ji8HLcUc+Bybc4g8v+7QjMUGMgl1xPEXli2tpGlGTfNreOqiavEgC6r2QK4X1ptQFZkOyBHCdyTJE0lqpswBmilXhMRZC3ltnrTgARQ4gAhowBkNr04lGqAVRChb1yjLyjZzxpWfBiVBLTzdKPxPDnKgu0sEWF7vJ86wMUd7x7hBIPpON5gN0q7ZpfCjWUv5jwJYZq9XOvwF2Ygm8y0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fRf5iVzoHiLMjdx+tXdiEL1+iucDTN9QEFL9/Sj0Cs=;
 b=eKcpavOWAX0B78f6YVwgCS2EDMoUo6IO8P33tpi5JyGC7Hc7JxzXsfIPo88sjX5Rx7VVvH9KpmjAucR+KV491QSASKkWUJea23vzpXdgqi81SBYD27xzEZnVkjsrIZbJ5smoktM+baLL6A4bINFrRuLBtolqWiHCbKymyjL+dHM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3712.eurprd04.prod.outlook.com (2603:10a6:803:1c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Mon, 9 Aug
 2021 11:57:46 +0000
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
Subject: [RFC PATCH net-next 3/4] net: dsa: create a helper for locating EtherType DSA headers on RX
Date:   Mon,  9 Aug 2021 14:57:21 +0300
Message-Id: <20210809115722.351383-4-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by VE1PR03CA0012.eurprd03.prod.outlook.com (2603:10a6:802:a0::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Mon, 9 Aug 2021 11:57:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be7eff2d-f383-4f1c-e6f5-08d95b2ce6fb
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3712:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB37125C63E98A1933606B46BBE0F69@VI1PR0402MB3712.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JhgxT/9eOGQgAe5fkZ2vrD18AjlDwMrBdVkW7ZTC+i65B1YvzC1/QD8c94ctWqOP8F0wcTP95y1r7ODTMN3KxI4zG541rrf3m/MvQk55t08qvBJsFJsC11nMVA0KkgSVilYst8dTLkChhhgKF/MCgM+TD1bIVS0JDXC3bvN9Am8U6wgH5vCnQTzVlKtzSRq1huzXNKrVC6tZDa6cVlAzJqKFnbomDdT+dVZL4B3A0QNfFbSLKqSS3HshKigBUjalZvWbBzeZPW/7JdkPwvwhKXrOWR7J7PmDeqQx9e/K1b4GbHeSdh8ra6jF/vzvuTdJFJv4foXBP0CIQeENiqycgelAIsHkeBhUHqBHTymsimpNFF2RacR8DAQeHSGT0xnXRXqiXeAwI6gKDJ0qzAwKSzE2x4vw3ldubM9I9tHPpkH3JULpGE/4otX590nLtbFBTraqzjbVS15g6Art14VnI2TnXCgliUudmykESk9t8R/wejPbVLn5wkVEAH1ggQ/1M0MDL9aCCp1uj7NnsrbfvzK1gug157bJa7Zp3k5P8VJzQO3Blzzm0w0/+rJWhkYiduWoL151lvFOdlIpqL+78yJWRY9cXUKHf3eUMNrjt7bTCucQ/I82yJZ4TJmvfOvF8lqjoB0TdcE9+WysIIryEeTkzbZbCN74G/SkyY4jw4ATglqzH5MVpaTAg4pZWPm+wCGrurHT6hMVDIfNNyTao3vNxvQxZFT9NvtnbdSw/uc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(44832011)(6486002)(6666004)(5660300002)(36756003)(52116002)(38350700002)(4326008)(38100700002)(2616005)(86362001)(956004)(66556008)(66476007)(7416002)(6512007)(316002)(66946007)(26005)(110136005)(2906002)(54906003)(6506007)(1076003)(8676002)(8936002)(83380400001)(478600001)(186003)(83323001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oRxE9TuvXxbAvvWZcyQGjJyO2jIpml+7CdcvLu3sv1Hhh6LGewDSjQuLQLFW?=
 =?us-ascii?Q?8p5zOhWZlxS2njO3ehm7qcgkZLNqdYb7hX04OjZNVse3Z7PKDrW7V0RnF2/7?=
 =?us-ascii?Q?+1UBaW+7XMj7wE/j4rS5NAvW0NJ76Qsg6RZ7NI2cQjXpaF3V9Zq0AU1z22gJ?=
 =?us-ascii?Q?zOJm79ChTaLmoHihq5+Y6EA/BJBvRXoh15bPdrfffItLKKjyrcyGWIRUrjZq?=
 =?us-ascii?Q?N09l3xqYZKa2c7R8v33VJPsuG4cAsl+yLYGsOdUz5tSmq+BIElbSFGBYWMFf?=
 =?us-ascii?Q?Ll7RE5CoIgjnEeT7ku0yIDKQTO2xYthxzep2HgTGUXX8Vo81wBGbI/VGrfwT?=
 =?us-ascii?Q?q6yVbW3Y/z4RUmlnMJj9okLnsbUD6bdb9PIXgMRgWvNvS9a/5p7wFXn9qfn1?=
 =?us-ascii?Q?fFFrmtgpgTVF0HZGmUu8IMdAHH5un+NN6FCs+0ktJsRE7BLs6YS/5oscccAL?=
 =?us-ascii?Q?q81b/RUyZpJ8i107DwhTpTI8SvWminhN5ikMHmeVOMUezRxhOmBq4wu2vl6H?=
 =?us-ascii?Q?KtRU6DewdJxQtX/3l01AOjDfJbAXg2Xz0mET8Mp0YWEXl1GDewi9rJVOOVlY?=
 =?us-ascii?Q?Icn48idu30j25lx61b74cIJSVt+HS1tRAb37yxoJj3Nfzn4WePXSR7gpfLWN?=
 =?us-ascii?Q?QVCP9jrCMZmr+c12QXxPiaSq9742sie7SkLkzTrtyJsr+uPnl+VJfJZEV4ju?=
 =?us-ascii?Q?h43ooFbAh21KaxG/m5C1JWGjv3jikjygDhIaW3rPTfJJoouEHlePJQ4ObbzZ?=
 =?us-ascii?Q?JEoHA88yaQsoWjf9Nxy78delhxWekcD/Vp1dwFAltxmBHKTxEbw/lgK33GTx?=
 =?us-ascii?Q?Us3vN4wk89zfWtY1Qo3jeLX1fNJK0YDBJJCwvmSrl76axp8lNj5TJus6pbNk?=
 =?us-ascii?Q?cWL3GdtWswoZzM86eJKhPH1xZra8qhb3SYvRlyr85iCugmL0SvKffcmIIP/t?=
 =?us-ascii?Q?Tf3wdBulpMb0YD6u4b6mDITE4uIcA/PNaNAa3mDvoYcABPstr+Jf/blB2PXj?=
 =?us-ascii?Q?IRR+TuR1vQ3Ih14piD3Ng2cgYzkKDpUOBVLk8XDT803lbvKau3f4/NPYaL0R?=
 =?us-ascii?Q?7LpI3UdfOiFyjyN8B6j7BzLV9zCwrCfr9cbyrIFH/pIqX+MTSQF+WD6JWOI5?=
 =?us-ascii?Q?pTeql7jmlxIBHnjnbCoLFwBOYe8lclmCJwsBleWiVOFdQihh69rjcvKKsRec?=
 =?us-ascii?Q?MK91TNWDhIOT4bgdcc+2973Onebv+3hpPpvvrUS4fIs+hS7gUB0WzxhpswJE?=
 =?us-ascii?Q?PSZxA2Xp6KpPKMapNaJ686hMCh/u0lxV6t3uO2kCD0Vy/J8gANa8SJDRa2d0?=
 =?us-ascii?Q?iY/rRtNbJh6VlcMT3I5vnnH6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be7eff2d-f383-4f1c-e6f5-08d95b2ce6fb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 11:57:46.2822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G+SmtxRDfhsFOfRkBZ3KUVJZEITV6aCUNIYwOSDg/mylyj/OkWo+ms86hHWtBWTNrG74CsGjw5GaROkWy47jVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3712
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems that protocol tagging driver writers are always surprised about
the formula they use to reach their EtherType header on RX, which
becomes apparent from the fact that there are comments in multiple
drivers that mention the same information.

Create a helper that returns a void pointer to skb->data - 2, as well as
centralize the explanation why that is the case.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h    | 14 ++++++++++++++
 net/dsa/tag_brcm.c    |  2 +-
 net/dsa/tag_dsa.c     |  2 +-
 net/dsa/tag_lan9303.c |  8 +-------
 net/dsa/tag_mtk.c     |  6 +-----
 net/dsa/tag_qca.c     |  6 +-----
 net/dsa/tag_rtl4_a.c  |  7 +------
 net/dsa/tag_sja1105.c |  2 +-
 8 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 28e1fbe64ee0..ee194df68902 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -507,6 +507,20 @@ static inline void dsa_alloc_etype_header(struct sk_buff *skb, int len)
 	memmove(skb->data, skb->data + len, 2 * ETH_ALEN);
 }
 
+/* On RX, eth_type_trans() on the DSA master pulls ETH_HLEN bytes starting from
+ * skb_mac_header(skb), which leaves skb->data pointing at the first byte after
+ * what the DSA master perceives as the EtherType (the beginning of the L3
+ * protocol). Since DSA EtherType header taggers treat the EtherType as part of
+ * the DSA tag itself, and the EtherType is 2 bytes in length, the DSA header
+ * is located 2 bytes behind skb->data. Note that EtherType in this context
+ * means the first 2 bytes of the DSA header, not the encapsulated EtherType
+ * that will become visible after the DSA header is stripped.
+ */
+static inline void *dsa_etype_header_pos_rx(struct sk_buff *skb)
+{
+	return skb->data - 2;
+}
+
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index c62a89bb8de3..96dbb8ee2fee 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -254,7 +254,7 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_PORT_ID)))
 		return NULL;
 
-	brcm_tag = skb->data - 2;
+	brcm_tag = dsa_etype_header_pos_rx(skb);
 
 	source_port = brcm_tag[5] & BRCM_LEG_PORT_ID;
 
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index ab2c63859d12..2eeabab27078 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -205,7 +205,7 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	u8 *dsa_header;
 
 	/* The ethertype field is part of the DSA header. */
-	dsa_header = skb->data - 2;
+	dsa_header = dsa_etype_header_pos_rx(skb);
 
 	cmd = dsa_header[0] >> 6;
 	switch (cmd) {
diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index e8ad3727433e..d06951273127 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -86,13 +86,7 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev)
 		return NULL;
 	}
 
-	/* '->data' points into the middle of our special VLAN tag information:
-	 *
-	 * ~ MAC src   | 0x81 | 0x00 | 0xyy | 0xzz | ether type
-	 *                           ^
-	 *                        ->data
-	 */
-	lan9303_tag = (__be16 *)(skb->data - 2);
+	lan9303_tag = dsa_etype_header_pos_rx(skb);
 
 	if (lan9303_tag[0] != htons(ETH_P_8021Q)) {
 		dev_warn_ratelimited(&dev->dev, "Dropping packet due to invalid VLAN marker\n");
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 06d1cfc6d19b..a75f99e5fbe3 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -70,11 +70,7 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	if (unlikely(!pskb_may_pull(skb, MTK_HDR_LEN)))
 		return NULL;
 
-	/* The MTK header is added by the switch between src addr
-	 * and ethertype at this point, skb->data points to 2 bytes
-	 * after src addr so header should be 2 bytes right before.
-	 */
-	phdr = (__be16 *)(skb->data - 2);
+	phdr = dsa_etype_header_pos_rx(skb);
 	hdr = ntohs(*phdr);
 
 	/* Remove MTK tag and recalculate checksum. */
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index c68a814188e7..79a81569d7ec 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -58,11 +58,7 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	if (unlikely(!pskb_may_pull(skb, QCA_HDR_LEN)))
 		return NULL;
 
-	/* The QCA header is added by the switch between src addr and Ethertype
-	 * At this point, skb->data points to ethertype so header should be
-	 * right before
-	 */
-	phdr = (__be16 *)(skb->data - 2);
+	phdr = dsa_etype_header_pos_rx(skb);
 	hdr = ntohs(*phdr);
 
 	/* Make sure the version is correct */
diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index 06e901eda298..947247d2124e 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -76,12 +76,7 @@ static struct sk_buff *rtl4a_tag_rcv(struct sk_buff *skb,
 	if (unlikely(!pskb_may_pull(skb, RTL4_A_HDR_LEN)))
 		return NULL;
 
-	/* The RTL4 header has its own custom Ethertype 0x8899 and that
-	 * starts right at the beginning of the packet, after the src
-	 * ethernet addr. Apparently skb->data always points 2 bytes in,
-	 * behind the Ethertype.
-	 */
-	tag = skb->data - 2;
+	tag = dsa_etype_header_pos_rx(skb);
 	p = (__be16 *)tag;
 	etype = ntohs(*p);
 	if (etype != RTL4_A_ETHERTYPE) {
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 939161822f31..34f3212a6703 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -481,11 +481,11 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 
 static struct sk_buff *sja1110_rcv_meta(struct sk_buff *skb, u16 rx_header)
 {
+	u8 *buf = dsa_etype_header_pos_rx(skb) + SJA1110_HEADER_LEN;
 	int switch_id = SJA1110_RX_HEADER_SWITCH_ID(rx_header);
 	int n_ts = SJA1110_RX_HEADER_N_TS(rx_header);
 	struct net_device *master = skb->dev;
 	struct dsa_port *cpu_dp;
-	u8 *buf = skb->data + 2;
 	struct dsa_switch *ds;
 	int i;
 
-- 
2.25.1

