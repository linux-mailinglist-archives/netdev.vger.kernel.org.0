Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9C76DC4DA
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 11:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjDJJIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 05:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjDJJIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 05:08:53 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA55B3AB8;
        Mon, 10 Apr 2023 02:08:51 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 339LpE7u026521;
        Mon, 10 Apr 2023 01:42:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=4xvgnuGtY2Auq2VHn8kwYkQVFzgoyUfmSu32RBKSJMg=;
 b=BLSrDafPDKtpu4gk2wsxezP+gGNavL3JzprHNNo2r/orW6w8xpBsRIL9Y3tl6OBPuZ9G
 62S9M4RqJNKTXO/HAiyQK8YsWZSuAn46XdJV5sRuZu0Tb8YQ9BW3dXB0v5WjOhmS/49q
 VT/YnR20ErEnFVmtpkO7Qy3HNbX73j/qnNbfN74x/nYJOOMoFesvUhGeGPtZcrQatfGE
 S7W9yZn7mEiSW+YAJvjVVZUmOPNLwnpvnM62LNQPQr4Z68X6wccxHqMk1XdvFNimsIB1
 vzIPAp4X+ny/6EVZEVrNcSpQ41fZYf0R7WxlUro4oE1ghznejan/PRNCPRQI8gyTLEXR YA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pu5ms79j8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 10 Apr 2023 01:42:45 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 10 Apr
 2023 01:42:44 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Mon, 10 Apr 2023 01:42:44 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 6C9735C68E5;
        Mon, 10 Apr 2023 01:42:38 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <naveenm@marvell.com>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>, <corbet@lwn.net>
Subject: [net-next Patch v8 2/6] octeontx2-pf: Rename tot_tx_queues to non_qos_queues
Date:   Mon, 10 Apr 2023 14:12:19 +0530
Message-ID: <20230410084223.5325-3-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230410084223.5325-1-hkelam@marvell.com>
References: <20230410084223.5325-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: OvYg5Kguu5SoUJeGOOkm3BWreWRIJ2PC
X-Proofpoint-GUID: OvYg5Kguu5SoUJeGOOkm3BWreWRIJ2PC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_05,2023-04-06_03,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

current implementation is such that tot_tx_queues contains both
xdp queues and normal tx queues. which will be allocated in interface
open calls and deallocated on interface down calls respectively.

With addition of QOS, where send quees are allocated/deallacated upon
user request Qos send queues won't be part of tot_tx_queues. So this
patch renames tot_tx_queues to non_qos_queues.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 12 ++++++------
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 14 +++++++-------
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  2 +-
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 8a41ad8ca04f..43bc56fb3c33 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -762,7 +762,7 @@ void otx2_sqb_flush(struct otx2_nic *pfvf)
 	int timeout = 1000;
 
 	ptr = (u64 *)otx2_get_regaddr(pfvf, NIX_LF_SQ_OP_STATUS);
-	for (qidx = 0; qidx < pfvf->hw.tot_tx_queues; qidx++) {
+	for (qidx = 0; qidx < pfvf->hw.non_qos_queues; qidx++) {
 		incr = (u64)qidx << 32;
 		while (timeout) {
 			val = otx2_atomic64_add(incr, ptr);
@@ -1048,7 +1048,7 @@ int otx2_config_nix_queues(struct otx2_nic *pfvf)
 	}
 
 	/* Initialize TX queues */
-	for (qidx = 0; qidx < pfvf->hw.tot_tx_queues; qidx++) {
+	for (qidx = 0; qidx < pfvf->hw.non_qos_queues; qidx++) {
 		u16 sqb_aura = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
 
 		err = otx2_sq_init(pfvf, qidx, sqb_aura);
@@ -1095,7 +1095,7 @@ int otx2_config_nix(struct otx2_nic *pfvf)
 
 	/* Set RQ/SQ/CQ counts */
 	nixlf->rq_cnt = pfvf->hw.rx_queues;
-	nixlf->sq_cnt = pfvf->hw.tot_tx_queues;
+	nixlf->sq_cnt = pfvf->hw.non_qos_queues;
 	nixlf->cq_cnt = pfvf->qset.cq_cnt;
 	nixlf->rss_sz = MAX_RSS_INDIR_TBL_SIZE;
 	nixlf->rss_grps = MAX_RSS_GROUPS;
@@ -1133,7 +1133,7 @@ void otx2_sq_free_sqbs(struct otx2_nic *pfvf)
 	int sqb, qidx;
 	u64 iova, pa;
 
-	for (qidx = 0; qidx < hw->tot_tx_queues; qidx++) {
+	for (qidx = 0; qidx < hw->non_qos_queues; qidx++) {
 		sq = &qset->sq[qidx];
 		if (!sq->sqb_ptrs)
 			continue;
@@ -1349,7 +1349,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 	stack_pages =
 		(num_sqbs + hw->stack_pg_ptrs - 1) / hw->stack_pg_ptrs;
 
-	for (qidx = 0; qidx < hw->tot_tx_queues; qidx++) {
+	for (qidx = 0; qidx < hw->non_qos_queues; qidx++) {
 		pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
 		/* Initialize aura context */
 		err = otx2_aura_init(pfvf, pool_id, pool_id, num_sqbs);
@@ -1369,7 +1369,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 		goto fail;
 
 	/* Allocate pointers and free them to aura/pool */
-	for (qidx = 0; qidx < hw->tot_tx_queues; qidx++) {
+	for (qidx = 0; qidx < hw->non_qos_queues; qidx++) {
 		pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
 		pool = &pfvf->qset.pool[pool_id];
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 3d22cc6a2804..b926a50138cc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -189,7 +189,7 @@ struct otx2_hw {
 	u16                     rx_queues;
 	u16                     tx_queues;
 	u16                     xdp_queues;
-	u16                     tot_tx_queues;
+	u16                     non_qos_queues; /* tx queues plus xdp queues */
 	u16			max_queues;
 	u16			pool_cnt;
 	u16			rqpool_cnt;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 179433d0a54a..33d677849aa9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1257,7 +1257,7 @@ static irqreturn_t otx2_q_intr_handler(int irq, void *data)
 	}
 
 	/* SQ */
-	for (qidx = 0; qidx < pf->hw.tot_tx_queues; qidx++) {
+	for (qidx = 0; qidx < pf->hw.non_qos_queues; qidx++) {
 		u64 sq_op_err_dbg, mnq_err_dbg, snd_err_dbg;
 		u8 sq_op_err_code, mnq_err_code, snd_err_code;
 
@@ -1383,7 +1383,7 @@ static void otx2_free_sq_res(struct otx2_nic *pf)
 	otx2_ctx_disable(&pf->mbox, NIX_AQ_CTYPE_SQ, false);
 	/* Free SQB pointers */
 	otx2_sq_free_sqbs(pf);
-	for (qidx = 0; qidx < pf->hw.tot_tx_queues; qidx++) {
+	for (qidx = 0; qidx < pf->hw.non_qos_queues; qidx++) {
 		sq = &qset->sq[qidx];
 		qmem_free(pf->dev, sq->sqe);
 		qmem_free(pf->dev, sq->tso_hdrs);
@@ -1433,7 +1433,7 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 	 * so, aura count = pool count.
 	 */
 	hw->rqpool_cnt = hw->rx_queues;
-	hw->sqpool_cnt = hw->tot_tx_queues;
+	hw->sqpool_cnt = hw->non_qos_queues;
 	hw->pool_cnt = hw->rqpool_cnt + hw->sqpool_cnt;
 
 	/* Maximum hardware supported transmit length */
@@ -1688,7 +1688,7 @@ int otx2_open(struct net_device *netdev)
 
 	netif_carrier_off(netdev);
 
-	pf->qset.cq_cnt = pf->hw.rx_queues + pf->hw.tot_tx_queues;
+	pf->qset.cq_cnt = pf->hw.rx_queues + pf->hw.non_qos_queues;
 	/* RQ and SQs are mapped to different CQs,
 	 * so find out max CQ IRQs (i.e CINTs) needed.
 	 */
@@ -1708,7 +1708,7 @@ int otx2_open(struct net_device *netdev)
 	if (!qset->cq)
 		goto err_free_mem;
 
-	qset->sq = kcalloc(pf->hw.tot_tx_queues,
+	qset->sq = kcalloc(pf->hw.non_qos_queues,
 			   sizeof(struct otx2_snd_queue), GFP_KERNEL);
 	if (!qset->sq)
 		goto err_free_mem;
@@ -2520,7 +2520,7 @@ static int otx2_xdp_setup(struct otx2_nic *pf, struct bpf_prog *prog)
 		xdp_features_clear_redirect_target(dev);
 	}
 
-	pf->hw.tot_tx_queues += pf->hw.xdp_queues;
+	pf->hw.non_qos_queues += pf->hw.xdp_queues;
 
 	if (if_up)
 		otx2_open(pf->netdev);
@@ -2751,7 +2751,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hw->pdev = pdev;
 	hw->rx_queues = qcount;
 	hw->tx_queues = qcount;
-	hw->tot_tx_queues = qcount;
+	hw->non_qos_queues = qcount;
 	hw->max_queues = qcount;
 	hw->rbuf_len = OTX2_DEFAULT_RBUF_LEN;
 	/* Use CQE of 128 byte descriptor size by default */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index ab126f8706c7..a078949430ce 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -570,7 +570,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hw->rx_queues = qcount;
 	hw->tx_queues = qcount;
 	hw->max_queues = qcount;
-	hw->tot_tx_queues = qcount;
+	hw->non_qos_queues = qcount;
 	hw->rbuf_len = OTX2_DEFAULT_RBUF_LEN;
 	/* Use CQE of 128 byte descriptor size by default */
 	hw->xqe_size = 128;
-- 
2.17.1

