Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D023E5ACB
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241080AbhHJNOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:14:46 -0400
Received: from mail-db8eur05on2062.outbound.protection.outlook.com ([40.107.20.62]:47684
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240561AbhHJNOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:14:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1FrgTKsywbcxgWTcxZn/KyO6s2i/3qfa8Jp/1ME7+q8V9UOnlWtAPM1E7xAioBcW+zPn7JjokoYOQTQ7RnGliFwvWKVDiU0TF84wmW5HpvLyzdC+tJW6UtVVj1UvJUV9TDXGnhFMVtm29xtnMvbfT7URF7MviDFfvv8jX8exxR1Qb3ZaIeHARi2tV8xsyTXOqBh3UdjbG67GNtXpAUNgxvhYD3qUWmsMagu3nNCJOaqdI7/HmmCyncaiRXzbF5EmrMIvE4YjgarFUP/9saspuyUmY+MlzZL3FlUszjyOUyfMj70rJGl7X0Xg7yc6i3BuvjQmezZ+2ULPpH2jhfAJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/kw8FZpVYv6g732wu+b3qd8OCqQx9Lr88ViMTZZYo8Y=;
 b=Fi40jAK+EjmOky6QShGfxRKjaYPmaXXcPxOykJw2+9lJo/fnSL4MOzbGCALGgivIuXJ1lrtenIfCMHXjFqZhmup+NEFtwbvR4FYmi18+NloP3JmH2s7jbZ3y16RgS1ZU+fn2QJHpox8rrX651Y3lfEEsC2hH73ReSbqqI3P5b04t6hMavEpqd+YvpP2Vm62uoUqySOqoZeEFNGp7fWYoW7Jt92DnB4iQoc7Otp6IJd60I02BwQd/32dsm55WhVAh4zDs1NJqb1TaIKzFUg5p/dY7omNznE7+NIy9UD6tz7zSSUi8mr7GgmIimxtHAoYNpF9mtfCwm2GIg33cRFWIxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/kw8FZpVYv6g732wu+b3qd8OCqQx9Lr88ViMTZZYo8Y=;
 b=NM9eKx6vkAP8t6VHRlyUqKbQtGv6kG/oex8FDNRw+Yla/dVXl+vL3ECOBtY9kdmhsyATYyO40Tio2SpPlGyXohSX3Yh1jMwgHFVg35l+fTmZrhabLiOm7SbDphzqchwpRhk9L/z6qsRxzIUUiiNR7V7MkgPwgAvAoYyLQbuxAnw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6013.eurprd04.prod.outlook.com (2603:10a6:803:cb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Tue, 10 Aug
 2021 13:14:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 13:14:15 +0000
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
Subject: [PATCH v2 net-next 1/4] net: dsa: create a helper that strips EtherType DSA headers on RX
Date:   Tue, 10 Aug 2021 16:13:53 +0300
Message-Id: <20210810131356.1655069-2-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by AM0PR02CA0228.eurprd02.prod.outlook.com (2603:10a6:20b:28f::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Tue, 10 Aug 2021 13:14:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9be74d93-1dac-4b60-2f0d-08d95c00c0ee
X-MS-TrafficTypeDiagnostic: VI1PR04MB6013:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6013CAB14A527211A56DB8B4E0F79@VI1PR04MB6013.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9PSTKzV7AvmtkchplWLrKyiTmdVFdyzQj3ITSNjoX/OTuOfLb0Z38R8soEgOWFOlUxPM3o/FxtpxYV362z7vWDCPD6TBVaiL+YxZ0PXpswx/urN/pm65hgjAKT/zdca5xFL9ME0jGfvvrN0X54WbEeUiaNjSh+Uf58TtaxXycw3KhSuQCq0oTCP7r1fZOnoukPOVR+ZOGbGSmfGYYMaNcPhR8VRMA2CEk+zkqSZbBJqfuJliWucdOgSxJzJ53KEeNY8q2CdJsNokJj9f2rGQOnyPDjDButwsCWNYE49VW0bO3nRPutK3DoZkMYeRhv5jQK/ASUYCALBXnk5DeZUiZ2Nt9leizUfweH2aUvW0bdciNAQTjax/GVjdqqQTmfJwIrUvD58/0LKeUOYTuEecnNjy9rGrVa7h5Jo9+VilanxnAA1zVK/hvToVS62Mbd5ljBnlLLXeXuvVtW/Oyeid12XJnXKiKJnvuSmQFmNTeJTtZIJCL3FvRuZEROmeDNtPxF4MU6x41/au6l0HvKjstLFdm98Lp+Q+3ABK71OhPkiz5IGaijmKX0Kt+1TlNHq0QhXatgOC13ifqsoYRFsN6NjGP5ZS+Fwk6CauLjoPTyyx5xJfHvhuBF9U3BuNMFlwH/tUtpmdUMWPQLH89vaDo9OE/AiuiCF5cmGaPcjOTQ5ubu9QBxqUsVsUkYNXbEDLLxS23qafgGVi3JWvUPGm9/qKDJivM/PMYImSUFcPxHY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(366004)(346002)(136003)(52116002)(2906002)(6506007)(956004)(2616005)(36756003)(316002)(7416002)(26005)(86362001)(5660300002)(44832011)(1076003)(4326008)(6512007)(6486002)(478600001)(110136005)(54906003)(186003)(38350700002)(38100700002)(6666004)(66946007)(66476007)(8936002)(66556008)(8676002)(83380400001)(83323001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dwhj6DIVO1m0GLkTACu4ULgWB3U6SyEypN6Hp58owwzD0IqY1kCLXlDoxdtn?=
 =?us-ascii?Q?idSWIP11t+aMmTjANi/z4Jk09JG6V/Tg0Gz/OinwtmC+kW0QHobXAe/alY7R?=
 =?us-ascii?Q?VXE/iRnjYckXvw3KCHfjU+aIaUSChzfu3fvha3RpxuEDFuNLzkLlBrTv4V7T?=
 =?us-ascii?Q?rTXPvEOdf93HtTtaAdY7H7Ts8euiCK+I7en9a2GzG6P7xuwHcKHy+NC4f8Ta?=
 =?us-ascii?Q?Ek/Lw87iALFXZ4b27+gGsClMBv2ZQMEP+IDWCSdpHT3gm7YpYhkbP/gFQqaf?=
 =?us-ascii?Q?jJSbP6smaab9V1gsrQhp0id9rnVeFzjFdtFJlSj0Xm7p7iI9ZQRu7SorgNLx?=
 =?us-ascii?Q?V5Q5JbuEGR9gfJdycNyME4lunkOpkqkI0EQRYq/rnUw+lK2C4e8TFRuRLZbm?=
 =?us-ascii?Q?rGUdvzkhp07y6qWy2LHxy0VrdtcAj03C3wp43IphgLvsKXR2on4pojPFWSmH?=
 =?us-ascii?Q?OyG9nPg3swZ5R2JAoMPkldsgu9qE41Nd7n9R9kXHa6UVl2HFbiEBfsSohwfn?=
 =?us-ascii?Q?+zu7WE9wUw2dpHjKO0ipbrlFcOVsIJqfOXqs6BTQPrpYQaUQWb6zHER2q0Me?=
 =?us-ascii?Q?BR9TcrtgimZFnvZtBM8uJmXnRb0CjY97WQC6fEeE7nOB9YzS8HCs9YtZ1x/N?=
 =?us-ascii?Q?oZmrWEqwJY9V0EYMnTRHGQ0sASoJuLWbtGXR488NY0fRLfARm6ZhlSwzNGmx?=
 =?us-ascii?Q?nABUqNH9IB99kbvwC/OgYSJuP9FWkIWbETJFQWURTFSzPmm1hA0Qg95jcazt?=
 =?us-ascii?Q?2u+mMWRvwLpnaOc86o2bmLmwtjzvWE0G+G4fk7PyAYfT5Z7/geRD8YraEPo9?=
 =?us-ascii?Q?5jZQ5A5+E6cO+Wcjwty2WKwH7QuBaZObHeIU2ZYgo0xCNnWRCwbhKchsoTzb?=
 =?us-ascii?Q?iJMsREcoXQAPFcK01DuDij0ZrA2V1nCMK3VF/XIaL/OVVATgRQndkmJed/Zi?=
 =?us-ascii?Q?nhb9c+t6bjdOtPSp4QGMVqI57LSQwCKJCmK6JwoPEcTHp+C8imhtyeeiH/i8?=
 =?us-ascii?Q?PbQil/ufXeGWOWikWc9vQ/2hXuTH/fbHAjckRT/pyJB4LR6PZy2vz7eihHsH?=
 =?us-ascii?Q?Xe3AxFUEKjxrKWGEbq1XbqwU0fJZ+OWRVZseYapvFufjbM4gf/NI+LJEyvWF?=
 =?us-ascii?Q?/bdPT6Z881+KVP9fl9p1BYyXTRDZ9PfhONmweYoO4Y6aF3Y7j/V2p/uDexVm?=
 =?us-ascii?Q?PHbIOJoAx4DVIc8wUWAT9TOkSxxnc/KExOpIU37Kcp06phFsJFmgLcSzO+HS?=
 =?us-ascii?Q?8rYMrCCjQHjvuKe+FjV3iX1vtac3do0qyOZAOMRqFT3Y4UTVLFnnGonv++nP?=
 =?us-ascii?Q?yGOfVPvO+39YWx2h5ISjKsd5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be74d93-1dac-4b60-2f0d-08d95c00c0ee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 13:14:15.7955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMD/440LaY2JrkBwqH5ls3s3rcJddI56Kx0jxR9RiQ58lsqk4YNdsM2A2qry+wsPbrC4d/mputkavhzC7mLPOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6013
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All header taggers open-code a memmove that is fairly not all that
obvious, and we can hide the details behind a helper function, since the
only thing specific to the driver is the length of the header tag.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa_priv.h    | 26 ++++++++++++++++++++++++++
 net/dsa/tag_brcm.c    | 10 ++--------
 net/dsa/tag_dsa.c     |  8 ++------
 net/dsa/tag_lan9303.c |  5 +++--
 net/dsa/tag_mtk.c     |  4 +---
 net/dsa/tag_qca.c     |  3 +--
 net/dsa/tag_rtl4_a.c  |  5 +----
 net/dsa/tag_sja1105.c |  4 +---
 8 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 9575cabd3ec3..8a12ec1f9d21 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -452,6 +452,32 @@ static inline void dsa_default_offload_fwd_mark(struct sk_buff *skb)
 	skb->offload_fwd_mark = !!(dp->bridge_dev);
 }
 
+/* Helper for removing DSA header tags from packets in the RX path.
+ * Must not be called before skb_pull(len).
+ *                                                                 skb->data
+ *                                                                         |
+ *                                                                         v
+ * |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
+ * +-----------------------+-----------------------+---------------+-------+
+ * |    Destination MAC    |      Source MAC       |  DSA header   | EType |
+ * +-----------------------+-----------------------+---------------+-------+
+ *                                                 |               |
+ * <----- len ----->                               <----- len ----->
+ *                 |
+ *       >>>>>>>   v
+ *       >>>>>>>   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
+ *       >>>>>>>   +-----------------------+-----------------------+-------+
+ *       >>>>>>>   |    Destination MAC    |      Source MAC       | EType |
+ *                 +-----------------------+-----------------------+-------+
+ *                                                                         ^
+ *                                                                         |
+ *                                                                 skb->data
+ */
+static inline void dsa_strip_etype_header(struct sk_buff *skb, int len)
+{
+	memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - len, 2 * ETH_ALEN);
+}
+
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 96e93b544a0d..2fc546b31ad8 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -190,10 +190,7 @@ static struct sk_buff *brcm_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	if (!nskb)
 		return nskb;
 
-	/* Move the Ethernet DA and SA */
-	memmove(nskb->data - ETH_HLEN,
-		nskb->data - ETH_HLEN - BRCM_TAG_LEN,
-		2 * ETH_ALEN);
+	dsa_strip_etype_header(skb, BRCM_TAG_LEN);
 
 	return nskb;
 }
@@ -270,10 +267,7 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 
 	dsa_default_offload_fwd_mark(skb);
 
-	/* Move the Ethernet DA and SA */
-	memmove(skb->data - ETH_HLEN,
-		skb->data - ETH_HLEN - BRCM_LEG_TAG_LEN,
-		2 * ETH_ALEN);
+	dsa_strip_etype_header(skb, BRCM_LEG_TAG_LEN);
 
 	return skb;
 }
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index e32f8160e895..ad9c841c998f 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -312,14 +312,10 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 		memcpy(dsa_header, new_header, DSA_HLEN);
 
 		if (extra)
-			memmove(skb->data - ETH_HLEN,
-				skb->data - ETH_HLEN - extra,
-				2 * ETH_ALEN);
+			dsa_strip_etype_header(skb, extra);
 	} else {
 		skb_pull_rcsum(skb, DSA_HLEN);
-		memmove(skb->data - ETH_HLEN,
-			skb->data - ETH_HLEN - DSA_HLEN - extra,
-			2 * ETH_ALEN);
+		dsa_strip_etype_header(skb, DSA_HLEN + extra);
 	}
 
 	return skb;
diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index 58d3a0e712d2..af13c0a9cb41 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -112,8 +112,9 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev)
 	 * and the current ethertype field.
 	 */
 	skb_pull_rcsum(skb, 2 + 2);
-	memmove(skb->data - ETH_HLEN, skb->data - (ETH_HLEN + LAN9303_TAG_LEN),
-		2 * ETH_ALEN);
+
+	dsa_strip_etype_header(skb, LAN9303_TAG_LEN);
+
 	if (!(lan9303_tag1 & LAN9303_TAG_RX_TRAPPED_TO_CPU))
 		dsa_default_offload_fwd_mark(skb);
 
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index bbf37c031d44..6a78e9f146e5 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -80,9 +80,7 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	/* Remove MTK tag and recalculate checksum. */
 	skb_pull_rcsum(skb, MTK_HDR_LEN);
 
-	memmove(skb->data - ETH_HLEN,
-		skb->data - ETH_HLEN - MTK_HDR_LEN,
-		2 * ETH_ALEN);
+	dsa_strip_etype_header(skb, MTK_HDR_LEN);
 
 	/* Get source port information */
 	port = (hdr & MTK_HDR_RECV_SOURCE_PORT_MASK);
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 6e3136990491..f9fc881da591 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -72,8 +72,7 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 
 	/* Remove QCA tag and recalculate checksum */
 	skb_pull_rcsum(skb, QCA_HDR_LEN);
-	memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - QCA_HDR_LEN,
-		ETH_HLEN - QCA_HDR_LEN);
+	dsa_strip_etype_header(skb, QCA_HDR_LEN);
 
 	/* Get source port information */
 	port = (hdr & QCA_HDR_RECV_SOURCE_PORT_MASK);
diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index aaddca3c0245..ff8707ff0c5b 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -108,10 +108,7 @@ static struct sk_buff *rtl4a_tag_rcv(struct sk_buff *skb,
 	/* Remove RTL4 tag and recalculate checksum */
 	skb_pull_rcsum(skb, RTL4_A_HDR_LEN);
 
-	/* Move ethernet DA and SA in front of the data */
-	memmove(skb->data - ETH_HLEN,
-		skb->data - ETH_HLEN - RTL4_A_HDR_LEN,
-		2 * ETH_ALEN);
+	dsa_strip_etype_header(skb, RTL4_A_HDR_LEN);
 
 	dsa_default_offload_fwd_mark(skb);
 
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index fc4cde775e50..5e8234079d08 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -571,9 +571,7 @@ static struct sk_buff *sja1110_rcv_inband_control_extension(struct sk_buff *skb,
 	/* Advance skb->data past the DSA header */
 	skb_pull_rcsum(skb, SJA1110_HEADER_LEN);
 
-	/* Remove the DSA header */
-	memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - SJA1110_HEADER_LEN,
-		2 * ETH_ALEN);
+	dsa_strip_etype_header(skb, SJA1110_HEADER_LEN);
 
 	/* With skb->data in its final place, update the MAC header
 	 * so that eth_hdr() continues to works properly.
-- 
2.25.1

