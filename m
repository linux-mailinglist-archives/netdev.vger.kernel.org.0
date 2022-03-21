Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63EE4E248E
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346440AbiCUKo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346453AbiCUKoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:44:15 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2132.outbound.protection.outlook.com [40.107.243.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787E114AC87
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:42:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erEXAWJ4mCZ+vJa8SYBGYNYUm7vjNniMx2js7+JqHREJ7KL7Q29zSIaa0XYeNp5qGF1mNirRleaadE5MWRjF3FeXwnvCnp1EwsdEr+aXUbojfy6de0oVqVNv8S8O5ikP+SuvUgrQfj8I10zVcdi5Z4Xl0yde1To1m6UKl4D0U0kp+/+xiWXHl6a5IoRCQusyJwFzWp0uX7m5mxX/qu0TAIUtrhEV+sSgt9kvOQERw1ORHIOSwRiIt4KFIyxqPC6jmhq1tKF/wNhXSIl1unPCSaZR8ylBy8T9QAsPu/O3x16+8tbfEQ8J3Kk4MRmr+Lg3HWguntzkafHhPngDmGxMIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iek99xu795rIT4PwJPOY/uUr49z9eODgP+STBRniy+4=;
 b=akp4KzohRecJK5aOnv4SoN1y+9GkKMV3vZsMjd9KbFUoxSQm08cER5AOioPCdsXEr+7RvqY50WKrP7b3IhVS5fwzWgv7eYIa/9dD9bwkJcvl73YvquQe0byyrd3NT9/bm7WV4yiFQyOyj63Rcuv2MBjlKre40Xk4uOlnSESsAEA9/+YPur88Ay7F559hZfg9+QEMr7thIUjNMmbz1SSUZvuNrWnhhVg2w5WBwvXTLGs+6V/20xpYSaWlfs/JJeEwRuh8v4Wj1JTFnp522zxMDRQNtherMvMCSRtrS0+XUMEYydj8SbTPXr1fuNWLIvr+aoOrc4VFtfdy+YiHOJvpsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iek99xu795rIT4PwJPOY/uUr49z9eODgP+STBRniy+4=;
 b=jhg7yPVeQmPF3AEJJaI2beXqff1x0z4SI0TVm8IjH5OhMCGFsQfifyjS9ZDwv4/+kLrTVUfTsezDB126e+0oTHrb+NG8yC2hi8WxMPvUTKu1PoUm6iEzY8KHzAuOkHYgfz6eCZ3arJD6eb2T1tYOy5POntvu1BcCTR/rtbOvO9Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1512.namprd13.prod.outlook.com (2603:10b6:903:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.15; Mon, 21 Mar
 2022 10:42:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113%4]) with mapi id 15.20.5102.015; Mon, 21 Mar 2022
 10:42:40 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Yinjun Zhang <yinjun.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next v2 10/10] nfp: nfdk: implement xdp tx path for NFDK
Date:   Mon, 21 Mar 2022 11:42:09 +0100
Message-Id: <20220321104209.273535-11-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321104209.273535-1-simon.horman@corigine.com>
References: <20220321104209.273535-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0001.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45b62dd9-fb8e-4d24-9c67-08da0b278591
X-MS-TrafficTypeDiagnostic: CY4PR13MB1512:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB15128457F1FDA4AF1E4B6E8CE8169@CY4PR13MB1512.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YUoJZKcIM9W3Yb+EdzRa0u0qkc2rPisnxDb+y70vYnQAankhgE1MgLyQSeXOUYT9E3KI4q6rmawlJp3kmta++ToCo4D03MklDM+QS6yGGoOKtN06wlvXmp19it2eEZ2sg9ejtuncJ33tE2ZXSOc32KpWIrNux+HPLhdpBoLCYQ+hoXYvAwIjD27DerGuRE2ikRcRxvr7D65rRBoI9dYr85vTGcR45Vh3bQXqY877mQXa/KM5Jnm5pCUP1AvJAaSJ/T9KdMvJZ6e1VZv4ozlzjiDLaWyQhzYrtOObN7XSJEZIkr55hkn9CaaDgKq0ZiPWvT3mRM/6sU2cD73j5A1ksSLOIGkP6S/iZEwK04Ge19H4cdeknWENxCrGBdk8EyDYUopzQj8xO05brrCEuCj0L5IaGimMUoLuunEvqnGCEVMNTWffmx94ENW5B+dy3qg8VVLs9Xe0nOEGP+hDPE+/3o+fs5IoKzTroyzLXmykgVlHzV1g7GFzqN64bUu+j3f3MvUHZ0nO5WuQ3qsL6XfE2uGAtlA5RVJYHPR2eNJeOXvIv/q7ZGpZ9kD5AJLjThsHyshQTFN73OtNTaZSSa74R8SYuGQgyNUwe3UL/HHd9/EaFWZydMMT4sg//6Vl/60lWDTP3nu+9KiqFn5rrdJaQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(396003)(376002)(366004)(346002)(8936002)(186003)(1076003)(6512007)(110136005)(6506007)(2906002)(8676002)(5660300002)(86362001)(52116002)(107886003)(6666004)(6486002)(44832011)(66946007)(4326008)(38100700002)(66556008)(2616005)(66476007)(316002)(83380400001)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WlMBl1YowMTAvlS0SrbX8TBEAcx2rzLLpafpITjFPLa00i1wSCsa666k/B/j?=
 =?us-ascii?Q?F03ttTtGdoEyG9POX+6h/mcw+FmUXcyXz2/UMUx9h7GPtI/6pFHMVx3QWeKn?=
 =?us-ascii?Q?pxQaJSt55yV8R7NYNAB/BE4aOWuClGi3S7lrO/QzlyxglMGsdSkVjDC7pvDP?=
 =?us-ascii?Q?LPpOzOuSxTu+5wVb+62LEMMT/fL5IMsEiCdMqtesei4NMCNMWLV3hd+C/mVG?=
 =?us-ascii?Q?lM95+0h8DzmVriADqf4es9viVfogn17PP6noMvHzZ3JKwdSXyzXoHR8KWJKj?=
 =?us-ascii?Q?DlfJN7X26Cw0MshBH5n/ae1lFRu7m3Z1OMMesyu/MfGJWVoceAz7IL7nwd8W?=
 =?us-ascii?Q?e/QDsCFC5JiE/qb1+diVM+ag117mKIIDMZTvi36b23OAH7ych+yp4IOVkt9h?=
 =?us-ascii?Q?Cdw9v5wMA0TLiLO8lcK1xFQn2Hx3Bp7KWf0opU+OitwdL3BaBomT52CVmpiF?=
 =?us-ascii?Q?aOWqY8XPltAStd7bjhgh4MyTdJJ0hC21jBQo1z+0WKV9mNF0YksNpWnKDgKs?=
 =?us-ascii?Q?eMpEckKt5+y6WHMDZlQwQDyrNCuBQK+snBdb6kOgNa60m3G5l3CIg5a8eEuU?=
 =?us-ascii?Q?7B0ERQ+jGvTjfk9bxrQLRPhYDL37vdSPWjzLeVyl6uR8bZMwVZPcUYZ4ML5f?=
 =?us-ascii?Q?kA++JQ7CKP0PAsgy7asP1QsTf8KEmUZh/jb0/HPhMzfXHOgBPAgTkclxVWbH?=
 =?us-ascii?Q?yO/a+QhwxWxjJ6TVDiSv2CTRQ3Mjko1n3lc46BqNainHPJRcLtq6v1PAJ9Or?=
 =?us-ascii?Q?kTbiRkmwGuN1lNfYdIY5VQas+O47Tcfxt9a1GePkybwuyRwD0OB9kaggrNRb?=
 =?us-ascii?Q?HEcX1e0kZkCFUhfyuoh5aqdFQAgZG6su/gSNWAzNBUku490llgHbsaSGZNiR?=
 =?us-ascii?Q?21jJTXSksEO3yRPF/aZwJZ6k4jvx6fsDLvOXWRunJqUSPQDV36Rj1Xq7TgL+?=
 =?us-ascii?Q?CU9D3dLxHerirmg6iegS7A5FEz98jWVplkL1RYgkSMiHKpITXHKwmPHLFYXl?=
 =?us-ascii?Q?26CLzBPcoaQQZl2nMMu+c4nnvsQ7Z4+frbeSR+PBOs+o4OKhkEtYaTnsFaet?=
 =?us-ascii?Q?r4otsLWxb90OIRzD7xEhcW8/FBWXFKi0idji7BBwXBcO64Sjmy29GDzpsaT0?=
 =?us-ascii?Q?ztgwkKs0pAXUD/M8O73umRxQTsFg51Z25Gd+qSHBQa6YEYqX12R4wpgSTqQJ?=
 =?us-ascii?Q?BrItFk0MK1yhFfhaztOJXTsnWowNpuMc81DQfulM3ewtz0cR4aLwlDQfSnfr?=
 =?us-ascii?Q?M/M6IeI+LC5+ZBgVV7pEdM3Zznnwe78Sel5zg/SsuLPBUcHwKXQ1yV5gHYSF?=
 =?us-ascii?Q?dCWqBu3U0lGDjWt2k/STeocqoyGMfVFTdKVNV+KngCJtYaBXwQOBQ8fEBfy6?=
 =?us-ascii?Q?oPVL5XHDqEraW5ox0gXE/IJe0iOfP78HOqDcCzNMUuxQ4kYP6RkAh/HSrSCt?=
 =?us-ascii?Q?HwawfrKTNl2xzK5LKf6O5zUpIw9zleMBq9KErlGe1sQCaukx3fu1zoWSnkz5?=
 =?us-ascii?Q?UMjMpo01rfe1T9DxwtMiz84P4s2SV9DKhfbEijhW2WbM6gdV1qMerT4QCw?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45b62dd9-fb8e-4d24-9c67-08da0b278591
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 10:42:40.1076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a/zpFZKPIqnXdSV1R5MRbIEMk081dcflxOOwn+sGKmQ+J1UwcjVtjULosCwILhIMGbjl6/RefBDSfcI1IyRdzidG3nkb4ZpVMrvCKE4yVtw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Due to the different definition of txbuf in NFDK comparing to NFD3,
there're no pre-allocated txbufs for xdp use in NFDK's implementation,
we just use the existed rxbuf and recycle it when xdp tx is completed.

For each packet to transmit in xdp path, we cannot use more than
`NFDK_TX_DESC_PER_SIMPLE_PKT` txbufs, one is to stash virtual address,
and another is for dma address, so currently the amount of transmitted
bytes is not accumulated. Also we borrow the last bit of virtual addr
to indicate a new transmitted packet due to address's alignment
attribution.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  | 196 +++++++++++++++++-
 .../net/ethernet/netronome/nfp/nfdk/nfdk.h    |  17 ++
 2 files changed, 208 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index f03de6b7988b..e3da9ac20e57 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -541,11 +541,6 @@ static void nfp_nfdk_tx_complete(struct nfp_net_tx_ring *tx_ring, int budget)
 		  tx_ring->rd_p, tx_ring->wr_p, tx_ring->cnt);
 }
 
-static bool nfp_nfdk_xdp_complete(struct nfp_net_tx_ring *tx_ring)
-{
-	return true;
-}
-
 /* Receive processing */
 static void *
 nfp_nfdk_napi_alloc_one(struct nfp_net_dp *dp, dma_addr_t *dma_addr)
@@ -791,6 +786,185 @@ nfp_nfdk_rx_drop(const struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 		dev_kfree_skb_any(skb);
 }
 
+static bool nfp_nfdk_xdp_complete(struct nfp_net_tx_ring *tx_ring)
+{
+	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
+	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
+	struct nfp_net_rx_ring *rx_ring;
+	u32 qcp_rd_p, done = 0;
+	bool done_all;
+	int todo;
+
+	/* Work out how many descriptors have been transmitted */
+	qcp_rd_p = nfp_net_read_tx_cmpl(tx_ring, dp);
+	if (qcp_rd_p == tx_ring->qcp_rd_p)
+		return true;
+
+	todo = D_IDX(tx_ring, qcp_rd_p - tx_ring->qcp_rd_p);
+
+	done_all = todo <= NFP_NET_XDP_MAX_COMPLETE;
+	todo = min(todo, NFP_NET_XDP_MAX_COMPLETE);
+
+	rx_ring = r_vec->rx_ring;
+	while (todo > 0) {
+		int idx = D_IDX(tx_ring, tx_ring->rd_p + done);
+		struct nfp_nfdk_tx_buf *txbuf;
+		unsigned int step = 1;
+
+		txbuf = &tx_ring->ktxbufs[idx];
+		if (!txbuf->raw)
+			goto next;
+
+		if (NFDK_TX_BUF_INFO(txbuf->val) != NFDK_TX_BUF_INFO_SOP) {
+			WARN_ONCE(1, "Unexpected TX buffer in XDP TX ring\n");
+			goto next;
+		}
+
+		/* Two successive txbufs are used to stash virtual and dma
+		 * address respectively, recycle and clean them here.
+		 */
+		nfp_nfdk_rx_give_one(dp, rx_ring,
+				     (void *)NFDK_TX_BUF_PTR(txbuf[0].val),
+				     txbuf[1].dma_addr);
+		txbuf[0].raw = 0;
+		txbuf[1].raw = 0;
+		step = 2;
+
+		u64_stats_update_begin(&r_vec->tx_sync);
+		/* Note: tx_bytes not accumulated. */
+		r_vec->tx_pkts++;
+		u64_stats_update_end(&r_vec->tx_sync);
+next:
+		todo -= step;
+		done += step;
+	}
+
+	tx_ring->qcp_rd_p = D_IDX(tx_ring, tx_ring->qcp_rd_p + done);
+	tx_ring->rd_p += done;
+
+	WARN_ONCE(tx_ring->wr_p - tx_ring->rd_p > tx_ring->cnt,
+		  "XDP TX ring corruption rd_p=%u wr_p=%u cnt=%u\n",
+		  tx_ring->rd_p, tx_ring->wr_p, tx_ring->cnt);
+
+	return done_all;
+}
+
+static bool
+nfp_nfdk_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
+		    struct nfp_net_tx_ring *tx_ring,
+		    struct nfp_net_rx_buf *rxbuf, unsigned int dma_off,
+		    unsigned int pkt_len, bool *completed)
+{
+	unsigned int dma_map_sz = dp->fl_bufsz - NFP_NET_RX_BUF_NON_DATA;
+	unsigned int dma_len, type, cnt, dlen_type, tmp_dlen;
+	struct nfp_nfdk_tx_buf *txbuf;
+	struct nfp_nfdk_tx_desc *txd;
+	unsigned int n_descs;
+	dma_addr_t dma_addr;
+	int wr_idx;
+
+	/* Reject if xdp_adjust_tail grow packet beyond DMA area */
+	if (pkt_len + dma_off > dma_map_sz)
+		return false;
+
+	/* Make sure there's still at least one block available after
+	 * aligning to block boundary, so that the txds used below
+	 * won't wrap around the tx_ring.
+	 */
+	if (unlikely(nfp_net_tx_full(tx_ring, NFDK_TX_DESC_STOP_CNT))) {
+		if (!*completed) {
+			nfp_nfdk_xdp_complete(tx_ring);
+			*completed = true;
+		}
+
+		if (unlikely(nfp_net_tx_full(tx_ring, NFDK_TX_DESC_STOP_CNT))) {
+			nfp_nfdk_rx_drop(dp, rx_ring->r_vec, rx_ring, rxbuf,
+					 NULL);
+			return false;
+		}
+	}
+
+	/* Check if cross block boundary */
+	n_descs = nfp_nfdk_headlen_to_segs(pkt_len);
+	if ((round_down(tx_ring->wr_p, NFDK_TX_DESC_BLOCK_CNT) !=
+	     round_down(tx_ring->wr_p + n_descs, NFDK_TX_DESC_BLOCK_CNT)) ||
+	    ((u32)tx_ring->data_pending + pkt_len >
+	     NFDK_TX_MAX_DATA_PER_BLOCK)) {
+		unsigned int nop_slots = D_BLOCK_CPL(tx_ring->wr_p);
+
+		wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
+		txd = &tx_ring->ktxds[wr_idx];
+		memset(txd, 0,
+		       array_size(nop_slots, sizeof(struct nfp_nfdk_tx_desc)));
+
+		tx_ring->data_pending = 0;
+		tx_ring->wr_p += nop_slots;
+		tx_ring->wr_ptr_add += nop_slots;
+	}
+
+	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
+
+	txbuf = &tx_ring->ktxbufs[wr_idx];
+
+	txbuf[0].val = (unsigned long)rxbuf->frag | NFDK_TX_BUF_INFO_SOP;
+	txbuf[1].dma_addr = rxbuf->dma_addr;
+	/* Note: pkt len not stored */
+
+	dma_sync_single_for_device(dp->dev, rxbuf->dma_addr + dma_off,
+				   pkt_len, DMA_BIDIRECTIONAL);
+
+	/* Build TX descriptor */
+	txd = &tx_ring->ktxds[wr_idx];
+	dma_len = pkt_len;
+	dma_addr = rxbuf->dma_addr + dma_off;
+
+	if (dma_len < NFDK_TX_MAX_DATA_PER_HEAD)
+		type = NFDK_DESC_TX_TYPE_SIMPLE;
+	else
+		type = NFDK_DESC_TX_TYPE_GATHER;
+
+	/* FIELD_PREP() implicitly truncates to chunk */
+	dma_len -= 1;
+	dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN_HEAD, dma_len) |
+		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
+
+	txd->dma_len_type = cpu_to_le16(dlen_type);
+	nfp_desc_set_dma_addr(txd, dma_addr);
+
+	tmp_dlen = dlen_type & NFDK_DESC_TX_DMA_LEN_HEAD;
+	dma_len -= tmp_dlen;
+	dma_addr += tmp_dlen + 1;
+	txd++;
+
+	while (dma_len > 0) {
+		dma_len -= 1;
+		dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN, dma_len);
+		txd->dma_len_type = cpu_to_le16(dlen_type);
+		nfp_desc_set_dma_addr(txd, dma_addr);
+
+		dlen_type &= NFDK_DESC_TX_DMA_LEN;
+		dma_len -= dlen_type;
+		dma_addr += dlen_type + 1;
+		txd++;
+	}
+
+	(txd - 1)->dma_len_type = cpu_to_le16(dlen_type | NFDK_DESC_TX_EOP);
+
+	/* Metadata desc */
+	txd->raw = 0;
+	txd++;
+
+	cnt = txd - tx_ring->ktxds - wr_idx;
+	tx_ring->wr_p += cnt;
+	if (tx_ring->wr_p % NFDK_TX_DESC_BLOCK_CNT)
+		tx_ring->data_pending += pkt_len;
+	else
+		tx_ring->data_pending = 0;
+
+	tx_ring->wr_ptr_add += cnt;
+	return true;
+}
+
 /**
  * nfp_nfdk_rx() - receive up to @budget packets on @rx_ring
  * @rx_ring:   RX ring to receive from
@@ -903,6 +1077,7 @@ static int nfp_nfdk_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 
 		if (xdp_prog && !meta.portid) {
 			void *orig_data = rxbuf->frag + pkt_off;
+			unsigned int dma_off;
 			int act;
 
 			xdp_prepare_buff(&xdp,
@@ -919,6 +1094,17 @@ static int nfp_nfdk_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 			case XDP_PASS:
 				meta_len_xdp = xdp.data - xdp.data_meta;
 				break;
+			case XDP_TX:
+				dma_off = pkt_off - NFP_NET_RX_BUF_HEADROOM;
+				if (unlikely(!nfp_nfdk_tx_xdp_buf(dp, rx_ring,
+								  tx_ring,
+								  rxbuf,
+								  dma_off,
+								  pkt_len,
+								  &xdp_tx_cmpl)))
+					trace_xdp_exception(dp->netdev,
+							    xdp_prog, act);
+				continue;
 			default:
 				bpf_warn_invalid_xdp_action(dp->netdev, xdp_prog, act);
 				fallthrough;
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h b/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
index 5107c4f03feb..c41e0975eb73 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
@@ -71,12 +71,29 @@ struct nfp_nfdk_tx_desc {
 	};
 };
 
+/* The device don't make use of the 2 or 3 least significant bits of the address
+ * due to alignment constraints. The driver can make use of those bits to carry
+ * information about the buffer before giving it to the device.
+ *
+ * NOTE: The driver must clear the lower bits before handing the buffer to the
+ * device.
+ *
+ * - NFDK_TX_BUF_INFO_SOP - Start of a packet
+ *   Mark the buffer as a start of a packet. This is used in the XDP TX process
+ *   to stash virtual and DMA address so that they can be recycled when the TX
+ *   operation is completed.
+ */
+#define NFDK_TX_BUF_PTR(val) ((val) & ~(sizeof(void *) - 1))
+#define NFDK_TX_BUF_INFO(val) ((val) & (sizeof(void *) - 1))
+#define NFDK_TX_BUF_INFO_SOP BIT(0)
+
 struct nfp_nfdk_tx_buf {
 	union {
 		/* First slot */
 		union {
 			struct sk_buff *skb;
 			void *frag;
+			unsigned long val;
 		};
 
 		/* 1 + nr_frags next slots */
-- 
2.30.2

