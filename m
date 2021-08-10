Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA143E5AC9
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240846AbhHJNOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:14:45 -0400
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:28640
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239339AbhHJNOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:14:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ETIEP7E6eEXi1M/dNrRZejtNaIGtZtzNdfx6jGSGDjrJg/AJ3ZUZ+0hIsGj4uDlTh9fRfSgQw3nEWl2z1aQ2WcfvRhPbq0o+aD5vIuGa2gPhPm0j8FPGYv67dhENCYL7U9sG0axkI3d8RKNnxy9BjUdfKZlqvHsKU6IX9EDIhOtHW0zzME2FRDiZRGX9uX7dwP/dbDVD7Y2K68im6JdPEcJd/u+YvbI3mNRuskqqIbkH40pF85ECY/TIKOzN9K0uxObq4JxJDuiJcKLfhw/szajomAYXKiryx5YwqERLsyY1JzW6/vAHzo5O5Bd+lKbvc7sweOdcg76gFm9Be4jj1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6JnGFyND2rju3c8NYQUj43DsLIaGDjphJAEumeJcek=;
 b=UQYKRflADde/hJlhRx80V3XdcQo2KS324wAyZTNOqE40nazR55Fh7+2xFrMHgzORRwMLIsgxg4v4jqpZkuRIPQkcPQPg85F29zlAGu4R3e5HgU4Xjd31ZTLtefRibYLs9YpHteKAtxhQwtdOqtQiYu0hdXYL9QYhYQdQQJOjsv6zkaBdTc/Gb27zLbFFwQ6mJzVi/tBz/I9lkTaYjIgKeP7vaxS45zWId1CIstHf3hQYke4rzKssqH6qO+kYVI21eKq/RxwJDCXqRwtgG1KkaFPDau6b+k5GYSuh/5JsYmlX0IAr5i8XIleE8RP6ab+2XZlHcwYlsoQ6LvcEQaoXHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6JnGFyND2rju3c8NYQUj43DsLIaGDjphJAEumeJcek=;
 b=A4eePPdwkeL3mV+PkwARttoVYFg27yKVQCvlJSkggocZe+ZdrFCPBvYLJlQe07Oz2Loa7L515sGR1/bh3C9pl2apUeD0iBJndg1u2jP7zu0X+ca/Fwwbkng+OZpU7FQgdfNJ3FqBXUB2asHrKx5nh/UOFdwa1ewKhzKeX09ry7o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7119.eurprd04.prod.outlook.com (2603:10a6:800:12e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 13:14:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 13:14:18 +0000
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
Subject: [PATCH v2 net-next 3/4] net: dsa: create a helper for locating EtherType DSA headers on RX
Date:   Tue, 10 Aug 2021 16:13:55 +0300
Message-Id: <20210810131356.1655069-4-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by AM0PR02CA0228.eurprd02.prod.outlook.com (2603:10a6:20b:28f::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Tue, 10 Aug 2021 13:14:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24adc024-bf84-46cd-f8d1-08d95c00c27c
X-MS-TrafficTypeDiagnostic: VI1PR04MB7119:
X-Microsoft-Antispam-PRVS: <VI1PR04MB7119ED6F17320191628D3A15E0F79@VI1PR04MB7119.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QGZAimQkuJgU7Yibc0UJ550WjAfBy602IrSvF9K/JCTmLxocps+AYA5sSr3dmKRcIpn3mH/74+7esqb+geB5Zdy2+lqyhVrPW/qSfYtOgVQQmTqqEO5tHBavvCD3wTgyVXCXefB3tY7k7Z0W46WutMsXYYL5ifgDQdu/eWNqtsIA1DqSWX8I9txG8LBWo9vIFyA5kqZdDPbj5hDrtcDeyAjyF7Kf02pt8hywrA8YzhipK+ROt2njz3l5yFEyG3mgrR2tzDoUQQTp2QLqLhCKJOIKtL0GhZ+YNdsDgEy0xJIbIFrcU7Nbd5yHded7Mnz7/wp7XVYgqrcx/HIa2uNafYBf+9uTSz8Nb3HVZro030Z55nuWdHOLDdaDYMhoOJdOv+/0So4FSRLqOSSkUn+DwaJwWTquGlQELKsrwA3e0x5QtZs3BxhWF7MdYoBDF0ygJNGqwFGY47FWDhexLvHroA1fR5Cg34ZUG4lAoAnVXnWs1CToLd8M40cG6k/alfvOKEUjrNBij8s2AC1HU4a0udIFc7htVSIZ5zokXONw/foMKM/AvL09whFhLdfMcym79dmgLfKKceB9Ex76cV2K4sK9tk6DokEaAjmLasNBPynxzqly9Y2GiiFSZ9jxGyrjK0QZiZHU0CNNNB005EQpNEnRk2kTF/A9Icax+QpSbPC2tk+Hrfzd3QPM+8JsYg7Bf+LKyPuHgFyYauiwb5i0JYCblhj2QoYip5+OjxkEU4I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(186003)(26005)(478600001)(8936002)(4326008)(52116002)(2906002)(8676002)(38100700002)(66476007)(86362001)(66556008)(6506007)(38350700002)(6666004)(66946007)(36756003)(6486002)(1076003)(956004)(2616005)(316002)(110136005)(6512007)(5660300002)(44832011)(83380400001)(7416002)(54906003)(83323001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Djy4LZhpN1nWBDSgKq8GDzXtHH9VflT2yVJngONTp7Grw5tEjPaJncD9JMyg?=
 =?us-ascii?Q?g5ZfYZtyD8/LjSrAC5knP8wU0sM8C1IBrhvtUjpIsQr0ksfY1B0wv6Dhz3xX?=
 =?us-ascii?Q?tLKjqyfBDUu8NbNKU3fEhUy4G85T1XYHM5/sveXy6LXchIb/gUZ1dMdF5w4U?=
 =?us-ascii?Q?RXUGFxnxyBL660FV2DQsmkLNfyhAOqeN+ZoNKO4vq29FKjh/m2H14E+R57zf?=
 =?us-ascii?Q?P+xkWOvVNJhf/c7viQDNOUYk81L42DXO4F7x2vcGTUqf4FYaP87GXprLgmR+?=
 =?us-ascii?Q?+GfwFyPDO/V7C30stnPWuH3PPZE9bMhYETb98knZr7PY9A1uUxofEXiU4kKu?=
 =?us-ascii?Q?yCCPf398aOeyku5Gp/8E547yRe828MHD1KC5gXJ6G8d0tSslHmG0soGTzWxu?=
 =?us-ascii?Q?HFVQsjI5ragDbTWZ2cm2LMfc+iWGv6aBvplRszDxS8IVT9pDPdGQwQq5JuU7?=
 =?us-ascii?Q?PIWST0aP7Htops1mY1sDanYBV6q2Mk0NbBb9sHmvr36nEYA85IzXZWxhRwsO?=
 =?us-ascii?Q?cddCIyglQ/6suFugRXZsDpYB+RPK+9BILsBSJ3Hr9lFH3kNIKDBNRgNkLVEa?=
 =?us-ascii?Q?KomzLGv/5APuW0pZJtNqLUmhv9gqKRLeIKEYkPV+2WTlai1SCig5BHjbsIbX?=
 =?us-ascii?Q?9gj8SZOUt/HEeigyN95a0OMs6By96NaN8fXX/kRH3VCNOahmdXo9CgysbTn0?=
 =?us-ascii?Q?vS5OTsavVVnCdXgpnGSrNcir7VQeabbjujJIMkh9VPhjtG6IJcTaffepTdEK?=
 =?us-ascii?Q?T0TOSbeM7E23qsRlsPY7FpSKAD8RQNEpvbEbMqz6Zs4h6z8qGOJLzKnLY06w?=
 =?us-ascii?Q?8kQj/xxIotdp5ojD1lQC6lGKRxO7vs9t4SmURlpdngqtD1for6xxWFRc2gNw?=
 =?us-ascii?Q?6Gyuc9iTWM6Fvk+sX84Fk14Zk27+DMGRgJ/+dk9FCs1zIc9I2JP75Xva1cg3?=
 =?us-ascii?Q?pXEEv3u8EtW1exyQehhi4idNeo72TtoJHEq9Sm/4fJxQki5+wNMV77Njquhl?=
 =?us-ascii?Q?4XkaErzlfiwhLK+rixJlflRLbipfVbHL69OlD8TDq2BbYF9ZARqJJ3DBOczP?=
 =?us-ascii?Q?NGpL3dQJUb0fifZ7RetWPndQtzoHVMhx1gWH0ipMb3PNm3blw1q2th/z0F4B?=
 =?us-ascii?Q?jbRDCpVHC4wYy8nvFBELcCxgGTPnIyLV4AhYhS8NZp9h8xs9QOl/uWrZQGu5?=
 =?us-ascii?Q?vEg/lxGpRgD65+qkos+jGMP3Wtf8j02TOa1FwAFK6W7nJ3HoPa+dtZOH5Pdr?=
 =?us-ascii?Q?HSgA0KMiji1VJE0pxQEG0OZVdPjtSQVRJ+Zq4TYUdoDjEF4FqOC1kQ+P/uQR?=
 =?us-ascii?Q?TzjeXPK2yvifiuD1pR13+d5L?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24adc024-bf84-46cd-f8d1-08d95c00c27c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 13:14:18.4280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DX9LryMhL1GWEncNsVUfNEqEaDapYJSPr4CnQxEUsqHh/iTlzm7ew/3KqYxZfQttlKLYqermfBInA9ViDqw4eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7119
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

