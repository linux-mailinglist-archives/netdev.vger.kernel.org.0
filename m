Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C225B610F
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbiILSfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiILSeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:34:36 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on060f.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::60f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DBA474FF
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:31:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5Vhr4fo89+p5azNKH0PAsIxf/3CJEGQxA5IWalrLYxTrQSugZk8WgFLolYEgy8AF7a8W4IHH+yJdGPfLcXBZ5o+SgST3ElrjCVo/vzGKYQNCntC+I/SKeK4K+lbGih1DwgGRDsQwzVgXaEfitsVV92XNYx5b1xw4EgwzacDZyAp04s6ifVsrMl2U09e5pT0fsYl9W8zgX3+dyj68Wu73H+rESRDnkAOoacMyL/PGPnDGyjg7zjVmmnrdiM/ijwTAlv+3ObGKhatOiwsgUYcbiV4LikhND4iMNtGeW0pyWoL3RTVPjdGVkaIksv3cg2T2zX9RWMDzb59SfK1IGAj7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KoamHjFHqAWZNOhsNIjDhF9/pNcgIpCcb4GrNCkTB08=;
 b=Oy9JnKfp4tJXgNhBfS3fZfdo/psDoGoE9Nmp5NMzpmf73WcMV8ftWLbNNIIE4gzugoIYlMyce++34JELwYsXClPpj4zxmIhehEXq2KD38UFil/3i3PTjiHqHNMJV9Zp9R+dTjSH0FS+rgY1ltB6vpwdQoIRV3dacpzT/A+WCQwm5p7Njl50oEX6u+601een9RDBtjrI+4H+J/MnjU/nMjphceGvm8N/77sU9vONJTtslCEfIphZZbYFyMxHexHyrdpt05YOgeUb8jftgXkvIhlrz3ONbDFiOY/VTKuLYaofeHBLjLmv50ldBTxfsJOkoft5/LxK9CwR/bKu6x8wAuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KoamHjFHqAWZNOhsNIjDhF9/pNcgIpCcb4GrNCkTB08=;
 b=bP+fJ/pnUILJCrrwZ5kr08POGZ59J/vCLbV8KXiKVf0mO4W5cci6B02awJ9HObsSjIELhuzaIiOj8swJSrrCUju20GgX6x86vf/TofivYa+7lMIAQGMiiCFtx2kd5z8hGRUqHuHuZ6C96V8i9bwbsdAkB24eeYzrYD8WkcS7jVs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8023.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 18:29:05 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 18:29:04 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 08/12] net: dpaa2-eth: create and export the dpaa2_eth_alloc_skb function
Date:   Mon, 12 Sep 2022 21:28:25 +0300
Message-Id: <20220912182829.160715-9-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220912182829.160715-1-ioana.ciornei@nxp.com>
References: <20220912182829.160715-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::16) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8023:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b2e14c3-d2cf-49ea-060e-08da94ecabfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ok19N4VozXI0LkXyjPT7M80ZUAdFDByMP2wnBb7oTDI5u4nAFvuquLwcDO+tYbqFHVMwSyzYcw+ZR3M7+EXYqT0+o5wlNm+R3JFeGxpXARvVPUd8oL67+UoBYaw3YI2/9eMCfbzGLSiv+BgVs9/2p2szTtRVsdVmsjJur+l9alLDy47ShEMOo8Rj0tZDQfDU4VUFCAwcG+pyAXDvUOGZgUJWLNC9eGV8R3Bye8eA2e2JHEAGXuLJva74oMmWZItFh5UOmXf2rYGH8SP/BzmZqpU9h6fzBxxlKQpne44X6U6MK30+tPGJXlxMnXVJkuKAvbrQTSbllwkeJCXc7tVZJWvkgQVnbyR97HFAPiWNT0fy/xCQzR19NkUxwodYooFnpEkF71TxKNF6xaiVtqZtuqt/9oSkqoiXJnUseHCTPaZoUQGzVdxG3da2geDkzFHkUQr7e3ObZQvtTJGxCiRh0o/meksWlDh83LhBHfjc++7yHvYdlyXMSW0kWLLpkv4fwcNam6PSaU89oOt9F2vbBbXDJ5LcTgGyEuRuF7NFRz29l/0nkKqX5AuDUNJewEkNoMy4Efo3m5wtQTriX2RB8pQDvy3DkGR8YrjKJpQ25//dwnbZ2C7Ey+pcph/hnx3KeHl4fCh+7InNuKE1M4EU18/90/yCdnfocJLw/N/x9bZg5frO3ZNNXOmXwGjH97zx8Krdvv/JmUG8JMWNAfpKfLFW6g3fGMmkvhlaYPbo0A6iCnXrgu6mXzojBWwv3J0SUIplG7lTidJqPw/jg8l+Yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(4326008)(5660300002)(8936002)(2616005)(6486002)(1076003)(2906002)(8676002)(6666004)(316002)(36756003)(41300700001)(86362001)(38350700002)(38100700002)(66476007)(44832011)(6506007)(6512007)(66556008)(186003)(66946007)(52116002)(478600001)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t255SCDtMatCqerhaNYokrEDjUPntd8SEFgVjcsizA92EXJLggTpBU8ZTAtQ?=
 =?us-ascii?Q?s9PTKjU9ZzXIipx+oADmr2b7BiGvl+65ou04M36DiXM9x/N/UyNO4RzBkOqF?=
 =?us-ascii?Q?8mTmF5RzVC7+i1qBEzoXv/620pnaH9ebg/e0saPY6rwB1rJTLTc4KODVlAay?=
 =?us-ascii?Q?ATxeQ4sSxSms5HwqBjgztJA0amJB0lfAYrH/za9RDVWtE/qMtSbVwSD/eRyw?=
 =?us-ascii?Q?nSlZZvafJIDXghUa+PkLPuDFtGR2xjXdXsY7OmjFKcCvuh9xGH91KbnHlaPU?=
 =?us-ascii?Q?tBEVwABvhPo7ns8GLuzor9fVnzZbrpwVLUaWCnHTGmeqVEwC7XoMY0VeREpf?=
 =?us-ascii?Q?FTYKEauBoFTYtnl9PAdVySM05xf3yRJz8dcWl/ieqpXLKOfnF/WmoXKiMIQg?=
 =?us-ascii?Q?+rtJaNSSHGjyH1Mzq3l7xElg3e0ka0GYJ7CmJrwUvkYwxwmgz1zCFzPTPGbN?=
 =?us-ascii?Q?vlz3yEoq2IHDASjB4tta1ZoKdEQp09B7bbH+KExM5Q//ElDIwmmH1rtmeA2g?=
 =?us-ascii?Q?a+Lkj0iQZC7gKvZIKB+YrTRvr9nXakAMRN0yC8yjWGsfULf89D0b5E55fH6+?=
 =?us-ascii?Q?xP62QPNprs6n1InsU1BUhFQp+Dqp9OO5Nfp4zFbCmLqPRgkPz5WaDod87efJ?=
 =?us-ascii?Q?iEP4HR3Un1aYvSTqU2Qz5p/EUSzrd4cmrd88SHS6PJs2csF9C/SdxBf8HbIp?=
 =?us-ascii?Q?HKwLgF9hpxVzdBTjIVHtzYjeXLqBOBtrnem4EV/jjDYxwlSCfzp4JW8ztuSL?=
 =?us-ascii?Q?xMQqB7zhTlGvfFYDfw5bsCm35rNoHBLqwBXedPV++JewBJeqzLFgsiXfToon?=
 =?us-ascii?Q?NPIeTpxBBsm7MQkcWYclV6eG0KgRvOnq+r4lg/lpc0LJD1CaMhkqKpsQZft0?=
 =?us-ascii?Q?FvT4eecU3cLuXxoXTREMVke7PgrXHbpKZolxUCYbrrfDwKq9IeyndiF1O330?=
 =?us-ascii?Q?Td1XzYLzHl2kwz8NpPWS9AB899+q+Iw0Rh3Wfio5an1RrgFHe8qibez92P7y?=
 =?us-ascii?Q?mQiFJWCrEDR0aLmKs6yd5ndKdZov9+Jasoyo0+L/JmxFHT6Lg8FQA+Pr60yA?=
 =?us-ascii?Q?5d2EidoXex5mbZhedJcwT+PzcR9Q8WMdT9y99ZAaWAWhNDKN5HzXoKWYLuvS?=
 =?us-ascii?Q?Yp49wWEvxovlg/o4HCVl2B8pB9fpneM6aWTv63o6mM7o8OULRpE5ploPL3ZO?=
 =?us-ascii?Q?+62ObvSk4+Vdd4cYTX7x3ZcSgbCyJOdn7PsoZVKG/AP3yFdSpl9rFEyzBdZX?=
 =?us-ascii?Q?iKtp9Qb2JiHv0E/cRTnKLuknW8wpDhLeMDqBI9IoxtlnGmjxeosD+QQV8vEj?=
 =?us-ascii?Q?o9gXEEq7ocvaP9SY9BvJgY5LITcUqyDmkiYH1a+sW+wcm7HJQv22sEUUG2aT?=
 =?us-ascii?Q?DMHDMaqTiHstwVNVSO1hZMuTdaCl0J0vGxrGNqrYs6LhILqOxjfyIv4XZOr9?=
 =?us-ascii?Q?9ZulqHFCJxo2uqg0AasWy3tH5N5t2RWGzm5NjB4F2V4uY5vEPPJ+Hukx97lV?=
 =?us-ascii?Q?CJTFX9Lrn4c3cgVB9V24yyCf9ob4PCCvnmGDhyE6R0fsvsSjEwXToP3BrRpH?=
 =?us-ascii?Q?4EVnC6YFrtWFUH5a4LTze+t6H9tTLlE5OyTx0KAf?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b2e14c3-d2cf-49ea-060e-08da94ecabfa
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 18:29:04.8577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cyQvf53I7XtDqToWiYs0Br7jWOCof+ujPA9iN5B+HJCiA23b93C6eu8ajASnH2BN6mBDr+lawAVwm/4ELwEVkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8023
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

The dpaa2_eth_alloc_skb() function is added by moving code from the
dpaa2_eth_copybreak() previously defined function. What the new API does
is to allocate a new skb, copy the frame data from the passed FD to the
new skb and then return the skb.
Export this new function since we'll need the this functionality also
from the XSK code path.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 25 +++++++++++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  5 ++++
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 244a8039e855..a43498ac0846 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -485,19 +485,15 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 	return xdp_act;
 }
 
-static struct sk_buff *dpaa2_eth_copybreak(struct dpaa2_eth_channel *ch,
-					   const struct dpaa2_fd *fd,
-					   void *fd_vaddr)
+struct sk_buff *dpaa2_eth_alloc_skb(struct dpaa2_eth_priv *priv,
+				    struct dpaa2_eth_channel *ch,
+				    const struct dpaa2_fd *fd, u32 fd_length,
+				    void *fd_vaddr)
 {
 	u16 fd_offset = dpaa2_fd_get_offset(fd);
-	struct dpaa2_eth_priv *priv = ch->priv;
-	u32 fd_length = dpaa2_fd_get_len(fd);
 	struct sk_buff *skb = NULL;
 	unsigned int skb_len;
 
-	if (fd_length > priv->rx_copybreak)
-		return NULL;
-
 	skb_len = fd_length + dpaa2_eth_needed_headroom(NULL);
 
 	skb = napi_alloc_skb(&ch->napi, skb_len);
@@ -514,6 +510,19 @@ static struct sk_buff *dpaa2_eth_copybreak(struct dpaa2_eth_channel *ch,
 	return skb;
 }
 
+static struct sk_buff *dpaa2_eth_copybreak(struct dpaa2_eth_channel *ch,
+					   const struct dpaa2_fd *fd,
+					   void *fd_vaddr)
+{
+	struct dpaa2_eth_priv *priv = ch->priv;
+	u32 fd_length = dpaa2_fd_get_len(fd);
+
+	if (fd_length > priv->rx_copybreak)
+		return NULL;
+
+	return dpaa2_eth_alloc_skb(priv, ch, fd, fd_length, fd_vaddr);
+}
+
 /* Main Rx frame processing routine */
 static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 			 struct dpaa2_eth_channel *ch,
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index daae160aa6b3..6412fde6db4b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -788,4 +788,9 @@ void dpaa2_eth_dl_traps_unregister(struct dpaa2_eth_priv *priv);
 
 struct dpaa2_eth_trap_item *dpaa2_eth_dl_get_trap(struct dpaa2_eth_priv *priv,
 						  struct dpaa2_fapr *fapr);
+
+struct sk_buff *dpaa2_eth_alloc_skb(struct dpaa2_eth_priv *priv,
+				    struct dpaa2_eth_channel *ch,
+				    const struct dpaa2_fd *fd, u32 fd_length,
+				    void *fd_vaddr);
 #endif	/* __DPAA2_H */
-- 
2.33.1

