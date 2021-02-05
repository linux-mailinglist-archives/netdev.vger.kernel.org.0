Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F70311896
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhBFCmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:42:07 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62358 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231349AbhBFCi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:38:29 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 115MfPDr030581;
        Fri, 5 Feb 2021 14:51:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=p6I48ui5arSSbdcltWHo0zvhopna55FWxhEQgQlFnJA=;
 b=fYbLXhokvsRpcVbp0ZhBxAVGyvRhdeYLJF4/SSka6vtaenrMi9YWQ0rZ/mpeUO/wddff
 5ihZrCXqs/r6gWpNHYRZHFQfipedRlUvCoEBVPN2fSS6HPseEtnPSY9wPl3J/h49Lxju
 N/LDRl7jtzsKWdJB3TiS+ldiWDJBc/NOXxZNzWX+d24C1WjNJxueyWqK8K/kUUYW/mNP
 OziHr5YiEEhSVed2zmZENJAEDjLVsZrz3nWbepdnP2sZSUN8hK40i8fVd7BS2gjmBHnF
 HLC1xevVKj3VpMEITBUlZe3W8OneC41WSWBRAlW4Vw9A6NxR3MfgSPURl+tlhHVuomcE ww== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36fnr6ag2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 14:51:41 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Feb
 2021 14:51:39 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Feb
 2021 14:51:39 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 5 Feb 2021 14:51:39 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 1F2043F703F;
        Fri,  5 Feb 2021 14:51:34 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <jerinj@marvell.com>,
        <lcherian@marvell.com>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <schalla@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v4 07/14] octeontx2-pf: cn10k: Use LMTST lines for NPA/NIX
Date:   Sat, 6 Feb 2021 04:20:06 +0530
Message-ID: <20210205225013.15961-8-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210205225013.15961-1-gakula@marvell.com>
References: <20210205225013.15961-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-05_13:2021-02-05,2021-02-05 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support to use new LMTST lines for NPA batch free
and burst SQE flush. Adds new dev_hw_ops structure to hold platform
specific functions and create new files cn10k.c and cn10k.h.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c | 182 +++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h |  17 ++
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  81 ++++-----
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  67 +++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  36 +---
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |   1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  38 ++---
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   7 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  28 +---
 include/linux/soc/marvell/octeontx2/asm.h          |   8 +
 11 files changed, 333 insertions(+), 134 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index 29c82b9..745aa8a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_OCTEONTX2_PF) += rvu_nicpf.o
 obj-$(CONFIG_OCTEONTX2_VF) += rvu_nicvf.o
 
 rvu_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o \
-		     otx2_ptp.o otx2_flows.o
+		     otx2_ptp.o otx2_flows.o cn10k.o
 rvu_nicvf-y := otx2_vf.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
new file mode 100644
index 0000000..70548d1
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -0,0 +1,182 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Physcial Function ethernet driver
+ *
+ * Copyright (C) 2020 Marvell.
+ */
+
+#include "cn10k.h"
+#include "otx2_reg.h"
+#include "otx2_struct.h"
+
+static struct dev_hw_ops	otx2_hw_ops = {
+	.sq_aq_init = otx2_sq_aq_init,
+	.sqe_flush = otx2_sqe_flush,
+	.aura_freeptr = otx2_aura_freeptr,
+	.refill_pool_ptrs = otx2_refill_pool_ptrs,
+};
+
+static struct dev_hw_ops cn10k_hw_ops = {
+	.sq_aq_init = cn10k_sq_aq_init,
+	.sqe_flush = cn10k_sqe_flush,
+	.aura_freeptr = cn10k_aura_freeptr,
+	.refill_pool_ptrs = cn10k_refill_pool_ptrs,
+};
+
+int cn10k_pf_lmtst_init(struct otx2_nic *pf)
+{
+	int size, num_lines;
+	u64 base;
+
+	if (!test_bit(CN10K_LMTST, &pf->hw.cap_flag)) {
+		pf->hw_ops = &otx2_hw_ops;
+		return 0;
+	}
+
+	pf->hw_ops = &cn10k_hw_ops;
+	base = pci_resource_start(pf->pdev, PCI_MBOX_BAR_NUM) +
+		       (MBOX_SIZE * (pf->total_vfs + 1));
+
+	size = pci_resource_len(pf->pdev, PCI_MBOX_BAR_NUM) -
+	       (MBOX_SIZE * (pf->total_vfs + 1));
+
+	pf->hw.lmt_base = ioremap(base, size);
+
+	if (!pf->hw.lmt_base) {
+		dev_err(pf->dev, "Unable to map PF LMTST region\n");
+		return -ENOMEM;
+	}
+
+	/* FIXME: Get the num of LMTST lines from LMT table */
+	pf->tot_lmt_lines = size / LMT_LINE_SIZE;
+	num_lines = (pf->tot_lmt_lines - NIX_LMTID_BASE) /
+			    pf->hw.tx_queues;
+	/* Number of LMT lines per SQ queues */
+	pf->nix_lmt_lines = num_lines > 32 ? 32 : num_lines;
+
+	pf->nix_lmt_size = pf->nix_lmt_lines * LMT_LINE_SIZE;
+	return 0;
+}
+
+int cn10k_vf_lmtst_init(struct otx2_nic *vf)
+{
+	int size, num_lines;
+
+	if (!test_bit(CN10K_LMTST, &vf->hw.cap_flag)) {
+		vf->hw_ops = &otx2_hw_ops;
+		return 0;
+	}
+
+	vf->hw_ops = &cn10k_hw_ops;
+	size = pci_resource_len(vf->pdev, PCI_MBOX_BAR_NUM);
+	vf->hw.lmt_base = ioremap_wc(pci_resource_start(vf->pdev,
+							PCI_MBOX_BAR_NUM),
+				     size);
+	if (!vf->hw.lmt_base) {
+		dev_err(vf->dev, "Unable to map VF LMTST region\n");
+		return -ENOMEM;
+	}
+
+	vf->tot_lmt_lines = size / LMT_LINE_SIZE;
+	/* LMTST lines per SQ */
+	num_lines = (vf->tot_lmt_lines - NIX_LMTID_BASE) /
+			    vf->hw.tx_queues;
+	vf->nix_lmt_lines = num_lines > 32 ? 32 : num_lines;
+	vf->nix_lmt_size = vf->nix_lmt_lines * LMT_LINE_SIZE;
+	return 0;
+}
+EXPORT_SYMBOL(cn10k_vf_lmtst_init);
+
+int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
+{
+	struct nix_cn10k_aq_enq_req *aq;
+	struct otx2_nic *pfvf = dev;
+	struct otx2_snd_queue *sq;
+
+	sq = &pfvf->qset.sq[qidx];
+	sq->lmt_addr = (__force u64 *)((u64)pfvf->hw.nix_lmt_base +
+			       (qidx * pfvf->nix_lmt_size));
+
+	/* Get memory to put this msg */
+	aq = otx2_mbox_alloc_msg_nix_cn10k_aq_enq(&pfvf->mbox);
+	if (!aq)
+		return -ENOMEM;
+
+	aq->sq.cq = pfvf->hw.rx_queues + qidx;
+	aq->sq.max_sqe_size = NIX_MAXSQESZ_W16; /* 128 byte */
+	aq->sq.cq_ena = 1;
+	aq->sq.ena = 1;
+	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
+	aq->sq.smq = pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
+	/* FIXME: set based on NIX_AF_DWRR_RPM_MTU*/
+	aq->sq.smq_rr_weight = OTX2_MAX_MTU;
+	aq->sq.default_chan = pfvf->hw.tx_chan_base;
+	aq->sq.sqe_stype = NIX_STYPE_STF; /* Cache SQB */
+	aq->sq.sqb_aura = sqb_aura;
+	aq->sq.sq_int_ena = NIX_SQINT_BITS;
+	aq->sq.qint_idx = 0;
+	/* Due pipelining impact minimum 2000 unused SQ CQE's
+	 * need to maintain to avoid CQ overflow.
+	 */
+	aq->sq.cq_limit = ((SEND_CQ_SKID * 256) / (pfvf->qset.sqe_cnt));
+
+	/* Fill AQ info */
+	aq->qidx = qidx;
+	aq->ctype = NIX_AQ_CTYPE_SQ;
+	aq->op = NIX_AQ_INSTOP_INIT;
+
+	return otx2_sync_mbox_msg(&pfvf->mbox);
+}
+
+#define NPA_MAX_BURST 16
+void cn10k_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq)
+{
+	struct otx2_nic *pfvf = dev;
+	u64 ptrs[NPA_MAX_BURST];
+	int num_ptrs = 1;
+	s64 bufptr;
+
+	/* Refill pool with new buffers */
+	while (cq->pool_ptrs) {
+		bufptr = otx2_alloc_buffer(pfvf, cq);
+		if (unlikely(bufptr <= 0)) {
+			if (num_ptrs--)
+				__cn10k_aura_freeptr(pfvf, cq->cq_idx, ptrs,
+						     num_ptrs,
+						     cq->rbpool->lmt_addr);
+			break;
+		}
+		cq->pool_ptrs--;
+		ptrs[num_ptrs] = (u64)bufptr + OTX2_HEAD_ROOM;
+		num_ptrs++;
+		if (num_ptrs == NPA_MAX_BURST || cq->pool_ptrs == 0) {
+			__cn10k_aura_freeptr(pfvf, cq->cq_idx, ptrs,
+					     num_ptrs,
+					     cq->rbpool->lmt_addr);
+			num_ptrs = 1;
+		}
+	}
+}
+
+void cn10k_sqe_flush(void *dev, struct otx2_snd_queue *sq, int size, int qidx)
+{
+	struct otx2_nic *pfvf = dev;
+	int lmt_id = NIX_LMTID_BASE + (qidx * pfvf->nix_lmt_lines);
+	u64 val = 0, tar_addr = 0;
+
+	/* FIXME: val[0:10] LMT_ID.
+	 * [12:15] no of LMTST - 1 in the burst.
+	 * [19:63] data size of each LMTST in the burst except first.
+	 */
+	val = (lmt_id & 0x7FF);
+	/* Target address for LMTST flush tells HW how many 128bit
+	 * words are present.
+	 * tar_addr[6:4] size of first LMTST - 1 in units of 128b.
+	 */
+	tar_addr |= sq->io_addr | (((size / 16) - 1) & 0x7) << 4;
+	dma_wmb();
+	memcpy(sq->lmt_addr, sq->sqe_base, size);
+	cn10k_lmt_flush(val, tar_addr);
+
+	sq->head++;
+	sq->head &= (sq->sqe_cnt - 1);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
new file mode 100644
index 0000000..e0bc595
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * Marvell OcteonTx2 RVU Ethernet driver
+ *
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef CN10K_H
+#define CN10K_H
+
+#include "otx2_common.h"
+
+void cn10k_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq);
+void cn10k_sqe_flush(void *dev, struct otx2_snd_queue *sq, int size, int qidx);
+int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
+int cn10k_pf_lmtst_init(struct otx2_nic *pf);
+int cn10k_vf_lmtst_init(struct otx2_nic *vf);
+#endif /* CN10K_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 0ae2c0a..fe62bfd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -15,6 +15,7 @@
 #include "otx2_reg.h"
 #include "otx2_common.h"
 #include "otx2_struct.h"
+#include "cn10k.h"
 
 static void otx2_nix_rq_op_stats(struct queue_stats *stats,
 				 struct otx2_nic *pfvf, int qidx)
@@ -513,6 +514,25 @@ static dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)
 	return addr;
 }
 
+s64 otx2_alloc_buffer(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
+{
+	s64 bufptr;
+
+	bufptr = __otx2_alloc_rbuf(pfvf, cq->rbpool);
+	if (unlikely(bufptr <= 0)) {
+		struct refill_work *work;
+		struct delayed_work *dwork;
+
+		work = &pfvf->refill_wrk[cq->cq_idx];
+		dwork = &work->pool_refill_work;
+		/* Schedule a task if no other task is running */
+		if (!cq->refill_task_sched) {
+			cq->refill_task_sched = true;
+			schedule_delayed_work(dwork, msecs_to_jiffies(100));
+		}
+	}
+	return bufptr;
+}
 void otx2_tx_timeout(struct net_device *netdev, unsigned int txq)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
@@ -715,9 +735,6 @@ void otx2_sqb_flush(struct otx2_nic *pfvf)
 #define RQ_PASS_LVL_AURA (255 - ((95 * 256) / 100)) /* RED when 95% is full */
 #define RQ_DROP_LVL_AURA (255 - ((99 * 256) / 100)) /* Drop when 99% is full */
 
-/* Send skid of 2000 packets required for CQ size of 4K CQEs. */
-#define SEND_CQ_SKID	2000
-
 static int otx2_rq_init(struct otx2_nic *pfvf, u16 qidx, u16 lpb_aura)
 {
 	struct otx2_qset *qset = &pfvf->qset;
@@ -751,45 +768,14 @@ static int otx2_rq_init(struct otx2_nic *pfvf, u16 qidx, u16 lpb_aura)
 	return otx2_sync_mbox_msg(&pfvf->mbox);
 }
 
-static int cn10k_sq_aq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
-{
-	struct nix_cn10k_aq_enq_req *aq;
-
-	/* Get memory to put this msg */
-	aq = otx2_mbox_alloc_msg_nix_cn10k_aq_enq(&pfvf->mbox);
-	if (!aq)
-		return -ENOMEM;
-
-	aq->sq.cq = pfvf->hw.rx_queues + qidx;
-	aq->sq.max_sqe_size = NIX_MAXSQESZ_W16; /* 128 byte */
-	aq->sq.cq_ena = 1;
-	aq->sq.ena = 1;
-	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
-	aq->sq.smq = pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
-	/* FIXME: set based on NIX_AF_DWRR_RPM_MTU*/
-	aq->sq.smq_rr_weight = OTX2_MAX_MTU;
-	aq->sq.default_chan = pfvf->hw.tx_chan_base;
-	aq->sq.sqe_stype = NIX_STYPE_STF; /* Cache SQB */
-	aq->sq.sqb_aura = sqb_aura;
-	aq->sq.sq_int_ena = NIX_SQINT_BITS;
-	aq->sq.qint_idx = 0;
-	/* Due pipelining impact minimum 2000 unused SQ CQE's
-	 * need to maintain to avoid CQ overflow.
-	 */
-	aq->sq.cq_limit = ((SEND_CQ_SKID * 256) / (pfvf->qset.sqe_cnt));
-
-	/* Fill AQ info */
-	aq->qidx = qidx;
-	aq->ctype = NIX_AQ_CTYPE_SQ;
-	aq->op = NIX_AQ_INSTOP_INIT;
-
-	return otx2_sync_mbox_msg(&pfvf->mbox);
-}
-
-static int otx2_sq_aq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
+int otx2_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
 {
+	struct otx2_nic *pfvf = dev;
+	struct otx2_snd_queue *sq;
 	struct nix_aq_enq_req *aq;
 
+	sq = &pfvf->qset.sq[qidx];
+	sq->lmt_addr = (__force u64 *)(pfvf->reg_base + LMT_LF_LMTLINEX(qidx));
 	/* Get memory to put this msg */
 	aq = otx2_mbox_alloc_msg_nix_aq_enq(&pfvf->mbox);
 	if (!aq)
@@ -860,16 +846,12 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	sq->sqe_thresh = ((sq->num_sqbs * sq->sqe_per_sqb) * 10) / 100;
 	sq->aura_id = sqb_aura;
 	sq->aura_fc_addr = pool->fc_addr->base;
-	sq->lmt_addr = (__force u64 *)(pfvf->reg_base + LMT_LF_LMTLINEX(qidx));
 	sq->io_addr = (__force u64)otx2_get_regaddr(pfvf, NIX_LF_OP_SENDX(0));
 
 	sq->stats.bytes = 0;
 	sq->stats.pkts = 0;
 
-	if (is_dev_otx2(pfvf->pdev))
-		return otx2_sq_aq_init(pfvf, qidx, sqb_aura);
-	else
-		return cn10k_sq_aq_init(pfvf, qidx, sqb_aura);
+	return pfvf->hw_ops->sq_aq_init(pfvf, qidx, sqb_aura);
 
 }
 
@@ -1219,6 +1201,11 @@ static int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
 
 	pool->rbsize = buf_size;
 
+	/* Set LMTST addr for NPA batch free */
+	if (test_bit(CN10K_LMTST, &pfvf->hw.cap_flag))
+		pool->lmt_addr = (__force u64 *)((u64)pfvf->hw.npa_lmt_base +
+						 (pool_id * LMT_LINE_SIZE));
+
 	/* Initialize this pool's context via AF */
 	aq = otx2_mbox_alloc_msg_npa_aq_enq(&pfvf->mbox);
 	if (!aq) {
@@ -1308,7 +1295,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 			bufptr = otx2_alloc_rbuf(pfvf, pool);
 			if (bufptr <= 0)
 				return bufptr;
-			otx2_aura_freeptr(pfvf, pool_id, bufptr);
+			pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr);
 			sq->sqb_ptrs[sq->sqb_count++] = (u64)bufptr;
 		}
 	}
@@ -1359,8 +1346,8 @@ int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
 			bufptr = otx2_alloc_rbuf(pfvf, pool);
 			if (bufptr <= 0)
 				return bufptr;
-			otx2_aura_freeptr(pfvf, pool_id,
-					  bufptr + OTX2_HEAD_ROOM);
+			pfvf->hw_ops->aura_freeptr(pfvf, pool_id,
+						   bufptr + OTX2_HEAD_ROOM);
 		}
 	}
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 80f892f..52205cb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -50,6 +50,9 @@ enum arua_mapped_qtypes {
 #define NIX_LF_ERR_VEC				0x81
 #define NIX_LF_POISON_VEC			0x82
 
+/* Send skid of 2000 packets required for CQ size of 4K CQEs. */
+#define SEND_CQ_SKID	2000
+
 /* RSS configuration */
 struct otx2_rss_ctx {
 	u8  ind_tbl[MAX_RSS_INDIR_TBL_SIZE];
@@ -273,9 +276,18 @@ struct otx2_flow_config {
 	struct list_head	flow_list;
 };
 
+struct dev_hw_ops {
+	int	(*sq_aq_init)(void *dev, u16 qidx, u16 sqb_aura);
+	void	(*sqe_flush)(void *dev, struct otx2_snd_queue *sq,
+			     int size, int qidx);
+	void	(*refill_pool_ptrs)(void *dev, struct otx2_cq_queue *cq);
+	void	(*aura_freeptr)(void *dev, int aura, s64 buf);
+};
+
 struct otx2_nic {
 	void __iomem		*reg_base;
 	struct net_device	*netdev;
+	struct dev_hw_ops	*hw_ops;
 	void			*iommu_domain;
 	u16			max_frs;
 	u16			rbsize; /* Receive buffer size */
@@ -505,10 +517,51 @@ static inline u64 otx2_atomic64_add(u64 incr, u64 *ptr)
 }
 
 #else
-#define otx2_write128(lo, hi, addr)
+#define otx2_write128(lo, hi, addr)		writeq((hi) | (lo), addr)
 #define otx2_atomic64_add(incr, ptr)		({ *ptr += incr; })
 #endif
 
+static inline void __cn10k_aura_freeptr(struct otx2_nic *pfvf, u64 aura,
+					u64 *ptrs, u64 num_ptrs,
+					u64 *lmt_addr)
+{
+	u64 size = 0, count_eot = 0;
+	u64 tar_addr, val = 0;
+
+	tar_addr = (__force u64)otx2_get_regaddr(pfvf, NPA_LF_AURA_BATCH_FREE0);
+	/* LMTID is same as AURA Id */
+	val = (aura & 0x7FF) | BIT_ULL(63);
+	/* Set if [127:64] of last 128bit word has a valid pointer */
+	count_eot = (num_ptrs % 2) ? 0ULL : 1ULL;
+	/* Set AURA ID to free pointer */
+	ptrs[0] = (count_eot << 32) | (aura & 0xFFFFF);
+	/* Target address for LMTST flush tells HW how many 128bit
+	 * words are valid from NPA_LF_AURA_BATCH_FREE0.
+	 *
+	 * tar_addr[6:4] is LMTST size-1 in units of 128b.
+	 */
+	if (num_ptrs > 2) {
+		size = (sizeof(u64) * num_ptrs) / 16;
+		if (!count_eot)
+			size++;
+		tar_addr |=  ((size - 1) & 0x7) << 4;
+	}
+	memcpy(lmt_addr, ptrs, sizeof(u64) * num_ptrs);
+	/* Perform LMTST flush */
+	cn10k_lmt_flush(val, tar_addr);
+}
+
+static inline void cn10k_aura_freeptr(void *dev, int aura, s64 buf)
+{
+	struct otx2_nic *pfvf = dev;
+	struct otx2_pool *pool;
+	u64 ptrs[2];
+
+	pool = &pfvf->qset.pool[aura];
+	ptrs[1] = (u64)buf;
+	__cn10k_aura_freeptr(pfvf, aura, ptrs, 2, pool->lmt_addr);
+}
+
 /* Alloc pointer from pool/aura */
 static inline u64 otx2_aura_allocptr(struct otx2_nic *pfvf, int aura)
 {
@@ -520,11 +573,12 @@ static inline u64 otx2_aura_allocptr(struct otx2_nic *pfvf, int aura)
 }
 
 /* Free pointer to a pool/aura */
-static inline void otx2_aura_freeptr(struct otx2_nic *pfvf,
-				     int aura, s64 buf)
+static inline void otx2_aura_freeptr(void *dev, int aura, s64 buf)
 {
-	otx2_write128((u64)buf, (u64)aura | BIT_ULL(63),
-		      otx2_get_regaddr(pfvf, NPA_LF_AURA_OP_FREE0));
+	struct otx2_nic *pfvf = dev;
+	void __iomem *addr = otx2_get_regaddr(pfvf, NPA_LF_AURA_OP_FREE0);
+
+	otx2_write128((u64)buf, (u64)aura | BIT_ULL(63), addr);
 }
 
 static inline int otx2_get_pool_idx(struct otx2_nic *pfvf, int type, int idx)
@@ -678,6 +732,9 @@ void otx2_ctx_disable(struct mbox *mbox, int type, bool npa);
 int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable);
 void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
 void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
+int otx2_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
+int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
+s64 otx2_alloc_buffer(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
 
 /* RSS configuration APIs*/
 int otx2_rss_init(struct otx2_nic *pfvf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 997d137..8b6a012 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -22,6 +22,7 @@
 #include "otx2_txrx.h"
 #include "otx2_struct.h"
 #include "otx2_ptp.h"
+#include "cn10k.h"
 #include <rvu_trace.h>
 
 #define DRV_NAME	"rvu_nicpf"
@@ -46,39 +47,6 @@ enum {
 static int otx2_config_hw_tx_tstamp(struct otx2_nic *pfvf, bool enable);
 static int otx2_config_hw_rx_tstamp(struct otx2_nic *pfvf, bool enable);
 
-static int cn10k_lmtst_init(struct otx2_nic *pf)
-{
-	int size, num_lines;
-	u64 base;
-
-	if (!test_bit(CN10K_LMTST, &pf->hw.cap_flag))
-		return 0;
-
-	base = pci_resource_start(pf->pdev, PCI_MBOX_BAR_NUM) +
-		       (MBOX_SIZE * (pf->total_vfs + 1));
-
-	size = pci_resource_len(pf->pdev, PCI_MBOX_BAR_NUM) -
-	       (MBOX_SIZE * (pf->total_vfs + 1));
-
-	pf->hw.lmt_base = ioremap(base, size);
-
-	if (!pf->hw.lmt_base) {
-		dev_err(pf->dev, "Unable to map PF LMTST region\n");
-		return -ENOMEM;
-	}
-
-	/* FIXME: Get the num of LMTST lines from LMT table */
-	pf->tot_lmt_lines = size / LMT_LINE_SIZE;
-	num_lines = (pf->tot_lmt_lines - NIX_LMTID_BASE) /
-			    pf->hw.tx_queues;
-	/* Number of LMT lines per SQ queues */
-	pf->nix_lmt_lines = num_lines > 32 ? 32 : num_lines;
-
-	pf->nix_lmt_size = pf->nix_lmt_lines * LMT_LINE_SIZE;
-
-	return 0;
-}
-
 static int otx2_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	bool if_up = netif_running(netdev);
@@ -2401,7 +2369,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_detach_rsrc;
 
-	err = cn10k_lmtst_init(pf);
+	err = cn10k_pf_lmtst_init(pf);
 	if (err)
 		goto err_detach_rsrc;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
index 1e052d7..21b811c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
@@ -94,6 +94,7 @@
 #define NPA_LF_QINTX_INT_W1S(a)         (NPA_LFBASE | 0x318 | (a) << 12)
 #define NPA_LF_QINTX_ENA_W1S(a)         (NPA_LFBASE | 0x320 | (a) << 12)
 #define NPA_LF_QINTX_ENA_W1C(a)         (NPA_LFBASE | 0x330 | (a) << 12)
+#define NPA_LF_AURA_BATCH_FREE0         (NPA_LFBASE | 0x400)
 
 /* NIX LF registers */
 #define	NIX_LFBASE			(BLKTYPE_NIX << RVU_FUNC_BLKADDR_SHIFT)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index a7eb5ea..cdae83c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -17,6 +17,7 @@
 #include "otx2_struct.h"
 #include "otx2_txrx.h"
 #include "otx2_ptp.h"
+#include "cn10k.h"
 
 #define CQE_ADDR(CQ, idx) ((CQ)->cqe_base + ((CQ)->cqe_size * (idx)))
 
@@ -199,7 +200,7 @@ static void otx2_free_rcv_seg(struct otx2_nic *pfvf, struct nix_cqe_rx_s *cqe,
 		sg = (struct nix_rx_sg_s *)start;
 		seg_addr = &sg->seg_addr;
 		for (seg = 0; seg < sg->segs; seg++, seg_addr++)
-			otx2_aura_freeptr(pfvf, qidx, *seg_addr & ~0x07ULL);
+			pfvf->hw_ops->aura_freeptr(pfvf, qidx, *seg_addr & ~0x07ULL);
 		start += sizeof(*sg);
 	}
 }
@@ -304,7 +305,6 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 {
 	struct nix_cqe_rx_s *cqe;
 	int processed_cqe = 0;
-	s64 bufptr;
 
 	while (likely(processed_cqe < budget)) {
 		cqe = (struct nix_cqe_rx_s *)CQE_ADDR(cq, cq->cq_head);
@@ -330,29 +330,24 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 
 	if (unlikely(!cq->pool_ptrs))
 		return 0;
+	pfvf->hw_ops->refill_pool_ptrs(pfvf, cq);
+
+	return processed_cqe;
+}
+
+void otx2_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq)
+{
+	struct otx2_nic *pfvf = dev;
+	s64 bufptr;
 
 	/* Refill pool with new buffers */
 	while (cq->pool_ptrs) {
-		bufptr = __otx2_alloc_rbuf(pfvf, cq->rbpool);
-		if (unlikely(bufptr <= 0)) {
-			struct refill_work *work;
-			struct delayed_work *dwork;
-
-			work = &pfvf->refill_wrk[cq->cq_idx];
-			dwork = &work->pool_refill_work;
-			/* Schedule a task if no other task is running */
-			if (!cq->refill_task_sched) {
-				cq->refill_task_sched = true;
-				schedule_delayed_work(dwork,
-						      msecs_to_jiffies(100));
-			}
+		bufptr = otx2_alloc_buffer(pfvf, cq);
+		if (unlikely(bufptr <= 0))
 			break;
-		}
 		otx2_aura_freeptr(pfvf, cq->cq_idx, bufptr + OTX2_HEAD_ROOM);
 		cq->pool_ptrs--;
 	}
-
-	return processed_cqe;
 }
 
 static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
@@ -439,7 +434,8 @@ int otx2_napi_handler(struct napi_struct *napi, int budget)
 	return workdone;
 }
 
-static void otx2_sqe_flush(struct otx2_snd_queue *sq, int size)
+void otx2_sqe_flush(void *dev, struct otx2_snd_queue *sq,
+		    int size, int qidx)
 {
 	u64 status;
 
@@ -797,7 +793,7 @@ static void otx2_sq_append_tso(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 		sqe_hdr->sizem1 = (offset / 16) - 1;
 
 		/* Flush SQE to HW */
-		otx2_sqe_flush(sq, offset);
+		pfvf->hw_ops->sqe_flush(pfvf, sq, offset, qidx);
 	}
 }
 
@@ -916,7 +912,7 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 	netdev_tx_sent_queue(txq, skb->len);
 
 	/* Flush SQE to HW */
-	otx2_sqe_flush(sq, offset);
+	pfvf->hw_ops->sqe_flush(pfvf, sq, offset, qidx);
 
 	return true;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index 73af156..d2b26b3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -114,6 +114,7 @@ struct otx2_cq_poll {
 struct otx2_pool {
 	struct qmem		*stack;
 	struct qmem		*fc_addr;
+	u64			*lmt_addr;
 	u16			rbsize;
 };
 
@@ -156,4 +157,10 @@ static inline u64 otx2_iova_to_phys(void *iommu_domain, dma_addr_t dma_addr)
 int otx2_napi_handler(struct napi_struct *napi, int budget);
 bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 			struct sk_buff *skb, u16 qidx);
+void cn10k_sqe_flush(void *dev, struct otx2_snd_queue *sq,
+		     int size, int qidx);
+void otx2_sqe_flush(void *dev, struct otx2_snd_queue *sq,
+		    int size, int qidx);
+void otx2_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq);
+void cn10k_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq);
 #endif /* OTX2_TXRX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 9ed850b..31e0325 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -7,6 +7,7 @@
 
 #include "otx2_common.h"
 #include "otx2_reg.h"
+#include "cn10k.h"
 
 #define DRV_NAME	"rvu_nicvf"
 #define DRV_STRING	"Marvell RVU NIC Virtual Function Driver"
@@ -27,31 +28,6 @@ enum {
 	RVU_VF_INT_VEC_MBOX = 0x0,
 };
 
-static int cn10k_lmtst_init(struct otx2_nic *vf)
-{
-	int size, num_lines;
-
-	if (!test_bit(CN10K_LMTST, &vf->hw.cap_flag))
-		return 0;
-
-	size = pci_resource_len(vf->pdev, PCI_MBOX_BAR_NUM);
-	vf->hw.lmt_base = ioremap_wc(pci_resource_start(vf->pdev,
-							PCI_MBOX_BAR_NUM),
-				     size);
-	if (!vf->hw.lmt_base) {
-		dev_err(vf->dev, "Unable to map VF LMTST region\n");
-		return -ENOMEM;
-	}
-
-	vf->tot_lmt_lines = size / LMT_LINE_SIZE;
-	/* LMTST lines per SQ */
-	num_lines = (vf->tot_lmt_lines - NIX_LMTID_BASE) /
-			    vf->hw.tx_queues;
-	vf->nix_lmt_lines = num_lines > 32 ? 32 : num_lines;
-	vf->nix_lmt_size = vf->nix_lmt_lines * LMT_LINE_SIZE;
-	return 0;
-}
-
 static void otx2vf_process_vfaf_mbox_msg(struct otx2_nic *vf,
 					 struct mbox_msghdr *msg)
 {
@@ -585,7 +561,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_detach_rsrc;
 
-	err = cn10k_lmtst_init(vf);
+	err = cn10k_vf_lmtst_init(vf);
 	if (err)
 		goto err_detach_rsrc;
 
diff --git a/include/linux/soc/marvell/octeontx2/asm.h b/include/linux/soc/marvell/octeontx2/asm.h
index ae2279f..28c04d9 100644
--- a/include/linux/soc/marvell/octeontx2/asm.h
+++ b/include/linux/soc/marvell/octeontx2/asm.h
@@ -22,8 +22,16 @@
 			 : [rs]"r" (ioaddr));           \
 	(result);                                       \
 })
+#define cn10k_lmt_flush(val, addr)			\
+({							\
+	__asm__ volatile(".cpu  generic+lse\n"		\
+			 "steor %x[rf],[%[rs]]"		\
+			 : [rf]"+r"(val)		\
+			 : [rs]"r"(addr));		\
+})
 #else
 #define otx2_lmt_flush(ioaddr)          ({ 0; })
+#define cn10k_lmt_flush(val, addr)	({ addr = val; })
 #endif
 
 #endif /* __SOC_OTX2_ASM_H */
-- 
2.7.4

