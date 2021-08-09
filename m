Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECEC3E4523
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 13:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbhHIL6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 07:58:14 -0400
Received: from mail-eopbgr40056.outbound.protection.outlook.com ([40.107.4.56]:40885
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234818AbhHIL6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 07:58:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEsQMmg05860Y3wam+bqx+4LhUOSnZuJeKXJrNPfGkhtZ8E3dq0xK3sogS3nHiqVQ6B4iwKI4HYdfwbAbueLbNbG9VkaEBZx4iO4wdVnF2i/FWKfM7Cc2mL0oHhG/Fnm4YKR3vYeT1VYPn7XgOwasa3SunQwPyACEEiX0ZdUz9h+qwxDFobKPUiGn7b17Z3n7F5sORCfuURHK2Mr76+3xVl7U6V2HvesTl9exBomc3wHyEHxF1VCQ5ExdW/uVNV8rf3q/0DoUGvlKS1/BbP7OqD1nxI2i//5Vm2gRLNsC5tIYgWsLiSNlsilqGvNqa68nqOu5QZ7TBx70T+sn2+y+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PpVbRLxD+YGj/DI5JeUoTiZsiRwexZ1F5OjlAbewWt0=;
 b=DnWVPxwd8YJbwpqieo6gKmxor7LzXnpVkV2C4iP0PiqItsws+lJ86enRLa1pBBhyScdXUxxpOljbysD4ZCm7eiPhR8XaPqd9rNzDN76MDeUC9EdOEKXMQHG3nVMXEbo2M6+RQoZ9toOlZB8yx2qYTs005lw5xOlg1L4hRI+zcROseK3Zh80IVJpRbIQZVoWmSejPJoXU7mIb3yAO/UUhLu0N7VZ3hJH0nJVD6nyurg9E6MJD7y23/wLAVGHh03KfDTkFqvwELfi+XuC9X/dGhOyLwUPxSlSZTBSq1maHwrzNwNg4ubc3g1/RRjnzyg+KiqCpShNSDOoHfBpbSYzDOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PpVbRLxD+YGj/DI5JeUoTiZsiRwexZ1F5OjlAbewWt0=;
 b=QCBmsbnbmQgnAR0wmrA+byY0bMBmE1tdf8tYB/eDYaOwDyKrmnJkMMooZntfuufMIMfj+Nsso5QBsFddlhSF205F0B6caZwznqNQbcKVPF0+N1EOYiLP+AqMoL63XlAqmRSInxOtMHcw9yCL4IjmeDJdUBiVUvah7WDSF5dQjNE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3712.eurprd04.prod.outlook.com (2603:10a6:803:1c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Mon, 9 Aug
 2021 11:57:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 11:57:45 +0000
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
Subject: [RFC PATCH net-next 2/4] net: dsa: create a helper which allocates space for EtherType DSA headers
Date:   Mon,  9 Aug 2021 14:57:20 +0300
Message-Id: <20210809115722.351383-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4d7c872a-57a5-47c3-445f-08d95b2ce69e
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3712:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB37127F23376B25273528A37BE0F69@VI1PR0402MB3712.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uatR86fPpyT7l/1Hh7e5Cll2hizbGJMjgGleyJ5cLJPLSB5zm7ZVu21mLJxuOe9P5NrSR8nZlKi12ybXZY8+foyyhuo2cyTVV8FPvNJY02vsNpGtdNP1tGmgpLF22HJKBqIK5WuQ6H473c3WKhO5MbHV0IurLyCOmBFYNFKzDoAdMYbtznILdrfNbM+sQFu0YAzqDipUDCyDAUrkQitV6GU3OjDCbNjbTi0CL2emoIZ+6+fpBa7nB8b0zTN4zfw/5pFNx4CvnMA+ArbpXvgpgA1IDkL2KK7YRbPgsgAXB/6pTUgQyS6bX4GmfcskpeczmCsUDZZuYqzqpm6DrzEctpvxxmUTFJgqkPGNb64mDjSBRlWDTLRZwu2o11seOhsORjE3Fd/bjqsquXVLW0jcpIe45mZSDGMBVejafqPmkKmkqYKOmshBeoSWi1g5H+E3j+Px2rf9wSwc6sPlmn0vEGNTdQOHtzX4/bHGsIV6k6jjiboSDY+b6GG9e4f1hg1hRB1lluBiy2XBa0WKPm/LecTtBw/1tbJGBEsQp+8K/pOBAP+xLIgOP/5GpVt/jTqefr4ZQQVtYRvWA//nulkE3xmr1bZy6TVfV8judprt0CZtHnERrW08ng9BSSUufhGxDW0J1X31L77xeSfWb6NhRqdib23OMPcrHW1ZjjrZvIyszDMGVFc31DILbn8SCyj7d8dH6g/+5nd4mabjM0kQuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(44832011)(6486002)(6666004)(5660300002)(36756003)(52116002)(38350700002)(4326008)(38100700002)(2616005)(86362001)(956004)(66556008)(66476007)(7416002)(6512007)(316002)(66946007)(26005)(110136005)(2906002)(54906003)(6506007)(1076003)(8676002)(8936002)(83380400001)(478600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gG0bSAjZgEM6a1/QNoDkAfvZdstrGOPrly1+WurFhy9N2rq8EAO+cR1skP7z?=
 =?us-ascii?Q?BaO1U45olisVHqlsD4TiR+SdIkCf9E1HQgcGQmxgomhwWc27wB8Mw0GtFCbj?=
 =?us-ascii?Q?HJpArOOMKl5kMpUxUisobcL2S5zJGeTs0gsuuHANfZtW4bLrcxhkVgkZBNIp?=
 =?us-ascii?Q?4MRMI9QLQYx+hkqK5IlgGhh7JLttORc34iKWjBRqw/RrotrnxbEqVoKAPm+e?=
 =?us-ascii?Q?SGWsAQ9EYzjoQtmM+rUX59YA16PFmovxG85zKkgXUOHxNpiBIffrqhTWcIgc?=
 =?us-ascii?Q?mJAHeGophJThdy41goNpIq3uiOwtjtXNH3j+aLidU1XAf2q+avLK2a/XcreJ?=
 =?us-ascii?Q?tufe+9dUqWKNNvs2cI9HO/5CcbPKS9e/qSqy5ra6UmcvSojchNCqihW+i0WB?=
 =?us-ascii?Q?zzonwtiTHnYo/PpbDPCCodi3zQYefrMyhBF9maZv0GH5sKiGNg2aKJ0CqXsp?=
 =?us-ascii?Q?NXseckrlL1Rq6OQ2AxWUwi7c9vNe2ba5hQFY0i2myIncrpMiRMDKB2Gpqw2V?=
 =?us-ascii?Q?4uN9tD9x9u4df23lnuI4zPm+pHfER1tmFTA6NB62wAcKrrAwRQMj3aBAaM7u?=
 =?us-ascii?Q?HvY8GPyjCYjnrU2iT4jaUCwi0JyXrYNI7ayFyTq2iUbO5BV4t9lVP8belyOp?=
 =?us-ascii?Q?Y9K3P/JtSJKSqZvHazVzap2hrwWBbzpqs6n8kFfRrkT31OastL7qkoqsTMqH?=
 =?us-ascii?Q?lry6Jx6bNoAjbafnFJp67ogkUqCcNYmC0ZmBbYpO7umpcMDAO4K3tp2VIPxB?=
 =?us-ascii?Q?4mrnyukAA5E2BFpj7Lmwn0JpG30BpI8J35dLVb/Aya3ESxNXBOj7mIbNUaMn?=
 =?us-ascii?Q?L7zcA/cxOeYmWTL1VYoJrbVcjGpKONMs4GvjqrxtiXR2Ins0WSDzVbnEZdBH?=
 =?us-ascii?Q?1pXL+zRHGadleV3nD+dBuUdbk7hW+zTfNKxsteoNuyqSobQoXWGDMWVgAQCf?=
 =?us-ascii?Q?cJhcnkFT5arOCLGrmSrcSGqZTqACbVKBQGv7lCO6+zltEUcfm8JnR3kAVOdc?=
 =?us-ascii?Q?RiM/4X05S2muJ4hhh5Cv/CkpfDn0SG4qT4IsnU3SEaLMY2JqrpCU3a6KVtWw?=
 =?us-ascii?Q?5LmtgdXDqb+88DiqKFIm9jFrFTUThzKGxJRxE3HEgT+mE8sgtvwdrHEalrcR?=
 =?us-ascii?Q?iQDP7QTqAZVIMhoh7BaWjvUlMbjf+MiExUVO4N97VCwJOZBRCFFNoCvGIsC/?=
 =?us-ascii?Q?GQ4BCiBdyLJn3F8yz1Wionxtl7uY3mGKwsVOUNLKoM5yXUERCcKJi+nwIXPn?=
 =?us-ascii?Q?0cPuu7fyFEk67JumpPu7OEEPh7tPAyKXCyP7ynWW6ucEoPuyzIS8+0bqnsrL?=
 =?us-ascii?Q?fuapQAPC3z543RCWSzAqKP0g?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d7c872a-57a5-47c3-445f-08d95b2ce69e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 11:57:45.6895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Biq4k4cE9DGHdqgFsG9T79OhNAaVglPdYG9CW9ZsUT2rkbys21HuQK3W4QXX2OqT+7++U1dDkKvHqDKmHrKTmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3712
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

