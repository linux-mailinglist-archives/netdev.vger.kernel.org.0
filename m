Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C17156B6F4
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 12:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbiGHKHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 06:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237738AbiGHKHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 06:07:48 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2119.outbound.protection.outlook.com [40.107.244.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633C583F34
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 03:07:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=buX947a1W1ElrKvMwxmQSGJd5olNAnK64NwTN1nNAFOQkurwWEG06l55UvaOYqTkf7ggN8EC3hyQ1sHFxV5UhqMDP0peANLe7Np1vTHnLT8PdwD8+aa9Xc96y0TQLVhoIFSXvh1EPHstHV7cNPanIx6pQiKwpjdaxjLhOfBcI5/5BF5o7YeYM7GSEZA6xrUWO+XPDLI4mQMtCwbievifKHr/xGkLUQFY9M2fIAkPN0F8U5q+iDkQT20mBAigho5lKvOUzEBciINJ0YuGbUbqAgsg4P+oraHfYghYdvPOu/eXHtkenUTHOzwFtU+NyX6jix3KwE2locOY6uYdnMtNbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NkwTjFtTUQvaXtu5AsU2En4WU2qMBj+mMszI2PIu7X8=;
 b=X445iI+pVOHUTHrM/vPotZMT8dPr/WP4DftCRen6SLd2+3UyuW2lBToD7D/yRHT94rPOt+NpEqcbjkPMifbuLIQ5looee/4E0EsOL8fxzbd3Zc/HuZcYxgeBkhYROiqHsLDC80S/xFC/PhOUWEfSTVAhuIUlN6gUv/3cWF1qlVlBJP/GcwC7G6WQ2XLroN8l4XgsIroWd01dsR1u0BI9FbJSv+P88XJiwgC1LRX4Gkj78YaSrTkcIC3LsX0lL3NNu2XaB6Rq+tc5b8DIpTE8wWmKKKgPMkAwu/UCzRRG3X1xtdutrD+jvOHkHzO0I9bfLrzraA0/yu8C4ickVsaARQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NkwTjFtTUQvaXtu5AsU2En4WU2qMBj+mMszI2PIu7X8=;
 b=rHTJP2SZA8rc7CTwNwtMyxZXN22K4X0JkI7+s8C6tk5Ih7lmL9W0y3YtoJ3mufxrh+AXoVeYv266XUxal4DDEvAiMKSfJ//YCKhjJum/tSqRGHGho0SlIr/EI0GkA+4HHQol9eJnkUPnoXsR4K/5psHhsC36xwnPGvgAh/Mhh9M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5478.namprd13.prod.outlook.com (2603:10b6:510:130::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Fri, 8 Jul
 2022 10:07:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2%7]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 10:07:46 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net] nfp: fix issue of skb segments exceeds descriptor limitation
Date:   Fri,  8 Jul 2022 11:07:18 +0100
Message-Id: <20220708100718.791158-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P189CA0087.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 005db0b0-3dad-492b-5818-08da60c9b437
X-MS-TrafficTypeDiagnostic: PH7PR13MB5478:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fmasY5XwfRF7oSVBtWrv95vQt4wY0e6mAkdXrNoW82qEuU68gyN7GxihMiMHhcqIgsEdlG1L5ERTJ1nEU83nGIhk+K0QcwmIWR63ZRKoDBJtOfk1pp0/8UevNV+n/riIg2ThC+Xvw0Lj3NptscOApi01jz/s8q4wnLwt4PRzWdDcPbeZeX3rhU9EvuBFS1zCja2scN2B0aJ0iytU9b8qniUy+8iNhUsN6z/mVoCqlNJn3bYgtD5VndYG4q+MliR8D2fvwPDP6WMReW+Ou49uebweNqQTI7l91FK0ZhhSrwTBKGffMNpfe3AApcmXUfHxDD3+MpnnfiqhQgLMm+JuUIo4zcrA7Gskc3MQDfhjG5rbn1JRcI6tmXNUHASqbGa4nYALZRkxvvApcT6OsBYyelKQK1WkJKjOfkgDnKEdK6FsncbmVp6k5NxI4t02Op+BzP9kFkR4i+XQCy5N89wuo6Qmf0S5QcLmqQ8RAwrtLzLDW6/PPbcqYLxUPHt1ziE197UX9glcmL+L6cGx2HZEjkAi86yd0eDCXmX1eBethpAsnI/RTxE69Zp177+yPgB++7uByy7ed7qzcnARZIjqRpmBBeyN4L+bmS+ZM4cq7kknQWu/Yw+XzNeH+/VaDVkyRfSKSWqS5+Ay4XsMMjDBJ6XLU7qj52MMBZ6AtLPIPQQ0hIHkJ9AT1zb0Eo/sDNPOEQnXStUGfEFyhM0EjiKF5Wbjf+KaOdNrrjka2uxyZ52O+rWTPnXbW5Ge2zABLhqi1cTqFXAWer4g2NDbWK/UU9+Upms0ZVVodserHB+jNfBMvJcj7yPWznntDaDtkjJD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39840400004)(346002)(376002)(396003)(366004)(136003)(26005)(8936002)(6506007)(110136005)(107886003)(6512007)(86362001)(1076003)(52116002)(186003)(478600001)(6486002)(83380400001)(2616005)(38350700002)(6666004)(41300700001)(66476007)(8676002)(36756003)(44832011)(2906002)(38100700002)(4326008)(66946007)(316002)(5660300002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1/uAY0sqG1f+PhgXrS/tynSqpqQSuRt0wyn1OWwAUCiLDpYwus+GoYmkhCUE?=
 =?us-ascii?Q?uNSILkpZihDm8e/nNTvgdH95sEtyeyu/WIAFSPvU+lxIvYxrgn09QQf/KBqA?=
 =?us-ascii?Q?i/sCammYQpxOC4B+uDqQCD7CE4wQDsb6Dup5tnPDGKJTGgvl7G2RB/ymIVbK?=
 =?us-ascii?Q?pYfmD2z9N1ANN2IcbzaIO2g0u5/NWc7kc7Neh+J7cg6YAg/MrQEJo0D2VY3u?=
 =?us-ascii?Q?Dca2djPQEIEAyDgcle9CuGwRO5kWbg0ZH7euIFjFL3GT+IsQWZVjsXAM7l+N?=
 =?us-ascii?Q?+40RgR0QwIBQZJ0DgGk43e1nRMp4F07K/lrC7pe5JP/K/Udc5srAjj37/KKk?=
 =?us-ascii?Q?H1p+2SlmdfDitpiH0XI6nLDPxEgaRTw7hz8crJNNUEq3TlE9wSOeyh0d/ytw?=
 =?us-ascii?Q?gLWzJMOqeoW/kiYso3mBKNrbtq2/XH0Mwx4Ij/actmQjtmaUO3YQ1Px5LSoa?=
 =?us-ascii?Q?MZscnl6pEF8s6dJEz+JwjqmlECsuaDio0ah3ndkI+U0lstEB93BFLPWRQdx5?=
 =?us-ascii?Q?Yl6Ou6+eLYfKxrQFL1042ajtPy+gRq4CfG0lfH2VCnddvA59Yq5EF/0D9l0E?=
 =?us-ascii?Q?jISSr8FTZkMM5KCQsvgjbGE0mQxlp7mmvW1aoBeTrVRQHmXrvefp0RnlEN85?=
 =?us-ascii?Q?9F0wUJqsNRb+BuWAUMXZAq93RhMhhegPM7BShF6EFZsj/OxZ5EPOIEueb7pH?=
 =?us-ascii?Q?+C84mbTK4smdBfHjmYRtFF9UjW4ho20djfdr+T0K1FSs1KmtE7JsiX7ARnzu?=
 =?us-ascii?Q?rbccWxiWMMK7Y/VNzjcBS1JyClkTrQjgCPAe7oFpA/Juru2Bhjcp4XM6Oy9H?=
 =?us-ascii?Q?D+D/ihd7RXv4Kr5q8BVNqwpWRaw2p3gsm31KteoRkMDl5k9boDcaJuhjOUhj?=
 =?us-ascii?Q?hvRa7T5Q+3ky+ikd7JsXrauCOvNpnWGtfZWVN6vybMgee57ZHp3Lfhp3yZHH?=
 =?us-ascii?Q?H+FsPG8WtrXNNoRpukTqL1Z1H9hO6gQp0GkRJ4A2lsif5BDUy8/NHa7s55ha?=
 =?us-ascii?Q?Zo0Yf677XkK09vg9Ze5s76acSpW5q1Qwg1m8uTbniYKYT9mSfsWfPkhoZfyg?=
 =?us-ascii?Q?7qxkis4S8yUgbUIs5kuOu95I5sK9csNluJfxujr+nnhSxneaKGdUXDpSfLST?=
 =?us-ascii?Q?TGrfDcBpQvdoJGZ2FdbTlm/BXxNTfUnsqq6zaV4Mgf7DM7wohWoNR+nxiA93?=
 =?us-ascii?Q?1wfqDpcsWBKFlomdo8/iY29RyDvrme8Sh7Z4poGygnZIwmCQ175Osuknddob?=
 =?us-ascii?Q?pk6HybVsx0I/tL6P5qp4CFmluJJS6ggy490wRRd7msHysI5vJC+NAHnaAJE5?=
 =?us-ascii?Q?qZBCFib9Cl65C7za8Tw0LNS9q4fGKSVLXeVRsuR9R5ZnMi1q5BKUXidPGOk3?=
 =?us-ascii?Q?afge2mVRcgaXwHvz2c6oT4xa4FUfm6qTgrfC82+nm78OFJVcBvWWOWFegZPT?=
 =?us-ascii?Q?GMBCIFNZMKqteTh54EeKjLg4uuKXegUmOSRJCpA1Erlg1a7D9H3elLXIyVSB?=
 =?us-ascii?Q?bwfzivT2/eQjjnUEjBibxKfEZnRwJgqjHMnRzGNs1qIWUSJQaRrdMSP3aRPZ?=
 =?us-ascii?Q?U8CNcUAn8urt2YShtublPj4N5RSkYYuauP7cqITfWmnJGwZpJN7C3Qo+hHBd?=
 =?us-ascii?Q?NQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 005db0b0-3dad-492b-5818-08da60c9b437
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 10:07:46.0970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JwLVP/EfXr5F2edqGK3ICnvwbiLoTeZll653VXbUGZPqVgTcmoHY8daUJKKdCsI93VMAoSxPJOi2d+KA/wzmOuwcUMsVpolEbotxAsB+Juk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5478
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

TCP packets will be dropped if the segments number in the tx skb
exceeds limitation when sending iperf3 traffic with --zerocopy option.

we make the following changes:

Get nr_frags in nfp_nfdk_tx_maybe_close_block instead of passing from
outside because it will be changed after skb_linearize operation.

Fill maximum dma_len in first tx descriptor to make sure the whole
head is included in the first descriptor.

Fixes: c10d12e3dce8 ("nfp: add support for NFDK data path")
Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c | 33 +++++++++++++++-----
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index e509d6dcba5c..805071d64a20 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -125,17 +125,18 @@ nfp_nfdk_tx_csum(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 
 static int
 nfp_nfdk_tx_maybe_close_block(struct nfp_net_tx_ring *tx_ring,
-			      unsigned int nr_frags, struct sk_buff *skb)
+			      struct sk_buff *skb)
 {
 	unsigned int n_descs, wr_p, nop_slots;
 	const skb_frag_t *frag, *fend;
 	struct nfp_nfdk_tx_desc *txd;
+	unsigned int nr_frags;
 	unsigned int wr_idx;
 	int err;
 
 recount_descs:
 	n_descs = nfp_nfdk_headlen_to_segs(skb_headlen(skb));
-
+	nr_frags = skb_shinfo(skb)->nr_frags;
 	frag = skb_shinfo(skb)->frags;
 	fend = frag + nr_frags;
 	for (; frag < fend; frag++)
@@ -281,10 +282,13 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 	if (unlikely((int)metadata < 0))
 		goto err_flush;
 
-	nr_frags = skb_shinfo(skb)->nr_frags;
-	if (nfp_nfdk_tx_maybe_close_block(tx_ring, nr_frags, skb))
+	if (nfp_nfdk_tx_maybe_close_block(tx_ring, skb))
 		goto err_flush;
 
+	/* nr_frags will change after skb_linearize so we get nr_frags after
+	 * nfp_nfdk_tx_maybe_close_block function
+	 */
+	nr_frags = skb_shinfo(skb)->nr_frags;
 	/* DMA map all */
 	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
 	txd = &tx_ring->ktxds[wr_idx];
@@ -310,7 +314,16 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 
 	/* FIELD_PREP() implicitly truncates to chunk */
 	dma_len -= 1;
-	dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN_HEAD, dma_len) |
+
+	/* We will do our best to pass as much data as we can in descriptor
+	 * and we need to make sure the first descriptor includes whole head
+	 * since there is limitation in firmware side. Sometimes the value of
+	 * dma_len bitwise and NFDK_DESC_TX_DMA_LEN_HEAD will less than
+	 * headlen.
+	 */
+	dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN_HEAD,
+			       dma_len > NFDK_DESC_TX_DMA_LEN_HEAD ?
+			       NFDK_DESC_TX_DMA_LEN_HEAD : dma_len) |
 		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
 
 	txd->dma_len_type = cpu_to_le16(dlen_type);
@@ -925,7 +938,9 @@ nfp_nfdk_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
 
 	/* FIELD_PREP() implicitly truncates to chunk */
 	dma_len -= 1;
-	dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN_HEAD, dma_len) |
+	dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN_HEAD,
+			       dma_len > NFDK_DESC_TX_DMA_LEN_HEAD ?
+			       NFDK_DESC_TX_DMA_LEN_HEAD : dma_len) |
 		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
 
 	txd->dma_len_type = cpu_to_le16(dlen_type);
@@ -1303,7 +1318,7 @@ nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 				   skb_push(skb, 4));
 	}
 
-	if (nfp_nfdk_tx_maybe_close_block(tx_ring, 0, skb))
+	if (nfp_nfdk_tx_maybe_close_block(tx_ring, skb))
 		goto err_free;
 
 	/* DMA map all */
@@ -1328,7 +1343,9 @@ nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 	txbuf++;
 
 	dma_len -= 1;
-	dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN_HEAD, dma_len) |
+	dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN_HEAD,
+			       dma_len > NFDK_DESC_TX_DMA_LEN_HEAD ?
+			       NFDK_DESC_TX_DMA_LEN_HEAD : dma_len) |
 		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
 
 	txd->dma_len_type = cpu_to_le16(dlen_type);
-- 
2.30.2

