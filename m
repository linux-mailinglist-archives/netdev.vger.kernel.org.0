Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE582A23EA
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 06:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgKBFHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 00:07:14 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:65296 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727936AbgKBFHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 00:07:11 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A255agU013142;
        Sun, 1 Nov 2020 21:07:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=lUk3UNJFCYDIPuhv0YuoHtK09VG02PeB8a8INh1IiQk=;
 b=Wi5fE/AWLDTPoKx2QJiKPLezYlcZA0S5xLRVGUH21k5EsgJQFQt0ndpLwufInQRJfN1v
 yYsToxXbqPN5kGkB4J91R3pG3616h3L2lh6NAho0LepgJkcKfU6ShyshlyHCJrYYHw/i
 04jjq4UfXx0BiELpBeHRpRk/gzViq39dSQ0Wu3DOpf016TbMsGT0y+Gdu2uLedhybZ4L
 FiAWyILrYgLn1D8fsSc9ACK+vWTYqO0o8mAVie/KbPb1/X9gdddrvw0W8heQrZfMLhiS
 GvDEITxTjusa8MFzwuHXDkDmKtbKhZUTuYldPLwfXnvSq4J7V6QhcOxhrx9YQp6rG72M 9A== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34h7ennyvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 01 Nov 2020 21:07:07 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 1 Nov
 2020 21:07:06 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 1 Nov
 2020 21:07:05 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 1 Nov 2020 21:07:05 -0800
Received: from hyd1584.caveonetworks.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 339F93F7052;
        Sun,  1 Nov 2020 21:07:01 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <masahiroy@kernel.org>, <george.cherian@marvell.com>
Subject: [net-next PATCH 3/3] octeontx2-af: Add devlink health reporters for NIX
Date:   Mon, 2 Nov 2020 10:36:49 +0530
Message-ID: <20201102050649.2188434-4-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102050649.2188434-1-george.cherian@marvell.com>
References: <20201102050649.2188434-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_01:2020-10-30,2020-11-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add health reporters for RVU NPA block.
Only reporter dump is supported.

Output:
 # ./devlink health
 pci/0002:01:00.0:
   reporter npa
     state healthy error 0 recover 0
   reporter nix
     state healthy error 0 recover 0
 # ./devlink  health dump show pci/0002:01:00.0 reporter nix
  NIX_AF_GENERAL:
         Memory Fault on NIX_AQ_INST_S read: 0
         Memory Fault on NIX_AQ_RES_S write: 0
         AQ Doorbell error: 0
         Rx on unmapped PF_FUNC: 0
         Rx multicast replication error: 0
         Memory fault on NIX_RX_MCE_S read: 0
         Memory fault on multicast WQE read: 0
         Memory fault on mirror WQE read: 0
         Memory fault on mirror pkt write: 0
         Memory fault on multicast pkt write: 0
   NIX_AF_RAS:
         Poisoned data on NIX_AQ_INST_S read: 0
         Poisoned data on NIX_AQ_RES_S write: 0
         Poisoned data on HW context read: 0
         Poisoned data on packet read from mirror buffer: 0
         Poisoned data on packet read from mcast buffer: 0
         Poisoned data on WQE read from mirror buffer: 0
         Poisoned data on WQE read from multicast buffer: 0
         Poisoned data on NIX_RX_MCE_S read: 0
   NIX_AF_RVU:
         Unmap Slot Error: 0

Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Jerin Jacob <jerinj@marvell.com>
Signed-off-by: George Cherian <george.cherian@marvell.com>
---
 .../marvell/octeontx2/af/rvu_devlink.c        | 376 +++++++++++++++++-
 .../marvell/octeontx2/af/rvu_devlink.h        |  24 ++
 .../marvell/octeontx2/af/rvu_struct.h         |  10 +
 3 files changed, 409 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 946e751fb544..c2dd2026c7da 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -14,6 +14,7 @@
 #define DRV_NAME "octeontx2-af"
 
 void rvu_npa_unregister_interrupts(struct rvu *rvu);
+void rvu_nix_unregister_interrupts(struct rvu *rvu);
 
 int rvu_report_pair_start(struct devlink_fmsg *fmsg, const char *name)
 {
@@ -37,6 +38,373 @@ int rvu_report_pair_end(struct devlink_fmsg *fmsg)
 	return devlink_fmsg_pair_nest_end(fmsg);
 }
 
+irqreturn_t rvu_nix_af_rvu_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu_nix_event_cnt *nix_event_count;
+	struct rvu_devlink *rvu_dl = rvu_irq;
+	struct rvu *rvu;
+	int blkaddr;
+	u64 intr;
+
+	rvu = rvu_dl->rvu;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	nix_event_count = rvu_dl->nix_event_cnt;
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_RVU_INT);
+
+	if (intr & BIT_ULL(0))
+		nix_event_count->unmap_slot_count++;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT, intr);
+	return IRQ_HANDLED;
+}
+
+irqreturn_t rvu_nix_af_err_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu_nix_event_cnt *nix_event_count;
+	struct rvu_devlink *rvu_dl = rvu_irq;
+	struct rvu *rvu;
+	int blkaddr;
+	u64 intr;
+
+	rvu = rvu_dl->rvu;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	nix_event_count = rvu_dl->nix_event_cnt;
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_ERR_INT);
+
+	if (intr & BIT_ULL(14))
+		nix_event_count->aq_inst_count++;
+	if (intr & BIT_ULL(13))
+		nix_event_count->aq_res_count++;
+	if (intr & BIT_ULL(12))
+		nix_event_count->aq_db_count++;
+	if (intr & BIT_ULL(6))
+		nix_event_count->rx_on_unmap_pf_count++;
+	if (intr & BIT_ULL(5))
+		nix_event_count->rx_mcast_repl_count++;
+	if (intr & BIT_ULL(4))
+		nix_event_count->rx_mcast_memfault_count++;
+	if (intr & BIT_ULL(3))
+		nix_event_count->rx_mcast_wqe_memfault_count++;
+	if (intr & BIT_ULL(2))
+		nix_event_count->rx_mirror_wqe_memfault_count++;
+	if (intr & BIT_ULL(1))
+		nix_event_count->rx_mirror_pktw_memfault_count++;
+	if (intr & BIT_ULL(0))
+		nix_event_count->rx_mcast_pktw_memfault_count++;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT, intr);
+	return IRQ_HANDLED;
+}
+
+irqreturn_t rvu_nix_af_ras_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu_nix_event_cnt *nix_event_count;
+	struct rvu_devlink *rvu_dl = rvu_irq;
+	struct rvu *rvu;
+	int blkaddr;
+	u64 intr;
+
+	rvu = rvu_dl->rvu;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	nix_event_count = rvu_dl->nix_event_cnt;
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_RAS);
+
+	if (intr & BIT_ULL(34))
+		nix_event_count->poison_aq_inst_count++;
+	if (intr & BIT_ULL(33))
+		nix_event_count->poison_aq_res_count++;
+	if (intr & BIT_ULL(32))
+		nix_event_count->poison_aq_cxt_count++;
+	if (intr & BIT_ULL(4))
+		nix_event_count->rx_mirror_data_poison_count++;
+	if (intr & BIT_ULL(3))
+		nix_event_count->rx_mcast_data_poison_count++;
+	if (intr & BIT_ULL(2))
+		nix_event_count->rx_mirror_wqe_poison_count++;
+	if (intr & BIT_ULL(1))
+		nix_event_count->rx_mcast_wqe_poison_count++;
+	if (intr & BIT_ULL(0))
+		nix_event_count->rx_mce_poison_count++;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_RAS, intr);
+	return IRQ_HANDLED;
+}
+
+static bool rvu_nix_af_request_irq(struct rvu *rvu, int offset,
+				   const char *name, irq_handler_t fn)
+{
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	int rc;
+
+	WARN_ON(rvu->irq_allocated[offset]);
+	rvu->irq_allocated[offset] = false;
+	sprintf(&rvu->irq_name[offset * NAME_SIZE], name);
+	rc = request_irq(pci_irq_vector(rvu->pdev, offset), fn, 0,
+			 &rvu->irq_name[offset * NAME_SIZE], rvu_dl);
+	if (rc)
+		dev_warn(rvu->dev, "Failed to register %s irq\n", name);
+	else
+		rvu->irq_allocated[offset] = true;
+
+	return rvu->irq_allocated[offset];
+}
+
+static int rvu_nix_blk_register_interrupts(struct rvu *rvu,
+					   int blkaddr)
+{
+	int base;
+	bool rc;
+
+	/* Get NIX AF MSIX vectors offset. */
+	base = rvu_read64(rvu, blkaddr, NIX_PRIV_AF_INT_CFG) & 0x3ff;
+	if (!base) {
+		dev_warn(rvu->dev,
+			 "Failed to get NIX%d NIX_AF_INT vector offsets\n",
+			 blkaddr - BLKADDR_NIX0);
+		return 0;
+	}
+	/* Register and enable NIX_AF_RVU_INT interrupt */
+	rc = rvu_nix_af_request_irq(rvu, base +  NIX_AF_INT_VEC_RVU,
+				    "NIX_AF_RVU_INT",
+				    rvu_nix_af_rvu_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NIX_AF_ERR_INT interrupt */
+	rc = rvu_nix_af_request_irq(rvu, base + NIX_AF_INT_VEC_AF_ERR,
+				    "NIX_AF_ERR_INT",
+				    rvu_nix_af_err_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NIX_AF_RAS interrupt */
+	rc = rvu_nix_af_request_irq(rvu, base + NIX_AF_INT_VEC_POISON,
+				    "NIX_AF_RAS",
+				    rvu_nix_af_ras_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NIX_AF_RAS_ENA_W1S, ~0ULL);
+
+	return 0;
+err:
+	rvu_nix_unregister_interrupts(rvu);
+	return -1;
+}
+
+int rvu_nix_register_interrupts(struct rvu *rvu)
+{
+	int blkaddr = 0;
+
+	blkaddr = rvu_get_blkaddr(rvu, blkaddr, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	rvu_nix_blk_register_interrupts(rvu, blkaddr);
+
+	return 0;
+}
+
+static void rvu_nix_blk_unregister_interrupts(struct rvu *rvu,
+					      int blkaddr)
+{
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	int offs, i;
+
+	offs = rvu_read64(rvu, blkaddr, NIX_PRIV_AF_INT_CFG) & 0x3ff;
+	if (!offs)
+		return;
+
+	rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT_ENA_W1C, ~0ULL);
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT_ENA_W1C, ~0ULL);
+	rvu_write64(rvu, blkaddr, NIX_AF_RAS_ENA_W1C, ~0ULL);
+
+	if (rvu->irq_allocated[offs + NIX_AF_INT_VEC_RVU]) {
+		free_irq(pci_irq_vector(rvu->pdev, offs + NIX_AF_INT_VEC_RVU),
+			 rvu_dl);
+		rvu->irq_allocated[offs + NIX_AF_INT_VEC_RVU] = false;
+	}
+
+	for (i = NIX_AF_INT_VEC_AF_ERR; i < NIX_AF_INT_VEC_CNT; i++)
+		if (rvu->irq_allocated[offs + i]) {
+			free_irq(pci_irq_vector(rvu->pdev, offs + i), rvu_dl);
+			rvu->irq_allocated[offs + i] = false;
+		}
+}
+
+void rvu_nix_unregister_interrupts(struct rvu *rvu)
+{
+	int blkaddr = 0;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return;
+
+	rvu_nix_blk_unregister_interrupts(rvu, blkaddr);
+}
+
+static int rvu_nix_report_show(struct devlink_fmsg *fmsg, struct rvu *rvu)
+{
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	struct rvu_nix_event_cnt *nix_event_count = rvu_dl->nix_event_cnt;
+	int err;
+
+	err = rvu_report_pair_start(fmsg, "NIX_AF_GENERAL");
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\tMemory Fault on NIX_AQ_INST_S read",
+					nix_event_count->aq_inst_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tMemory Fault on NIX_AQ_RES_S write",
+					nix_event_count->aq_res_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tAQ Doorbell error",
+					nix_event_count->aq_db_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tRx on unmapped PF_FUNC",
+					nix_event_count->rx_on_unmap_pf_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tRx multicast replication error",
+					nix_event_count->rx_mcast_repl_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tMemory fault on NIX_RX_MCE_S read",
+					nix_event_count->rx_mcast_memfault_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tMemory fault on multicast WQE read",
+					nix_event_count->rx_mcast_wqe_memfault_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tMemory fault on mirror WQE read",
+					nix_event_count->rx_mirror_wqe_memfault_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tMemory fault on mirror pkt write",
+					nix_event_count->rx_mirror_pktw_memfault_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tMemory fault on multicast pkt write",
+					nix_event_count->rx_mcast_pktw_memfault_count);
+	if (err)
+		return err;
+	err = rvu_report_pair_end(fmsg);
+	if (err)
+		return err;
+	err = rvu_report_pair_start(fmsg, "NIX_AF_RAS");
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\tPoisoned data on NIX_AQ_INST_S read",
+					nix_event_count->poison_aq_inst_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on NIX_AQ_RES_S write",
+					nix_event_count->poison_aq_res_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on HW context read",
+					nix_event_count->poison_aq_cxt_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on packet read from mirror buffer",
+					nix_event_count->rx_mirror_data_poison_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on packet read from mcast buffer",
+					nix_event_count->rx_mcast_data_poison_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on WQE read from mirror buffer",
+					nix_event_count->rx_mirror_wqe_poison_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on WQE read from multicast buffer",
+					nix_event_count->rx_mcast_wqe_poison_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on NIX_RX_MCE_S read",
+					nix_event_count->rx_mce_poison_count);
+	if (err)
+		return err;
+	err = rvu_report_pair_end(fmsg);
+	if (err)
+		return err;
+	err = rvu_report_pair_start(fmsg, "NIX_AF_RVU");
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\tUnmap Slot Error",
+					nix_event_count->unmap_slot_count);
+	if (err)
+		return err;
+	err = rvu_report_pair_end(fmsg);
+	if (err)
+		return err;
+	return 0;
+}
+
+static int rvu_nix_reporter_dump(struct devlink_health_reporter *reporter,
+				 struct devlink_fmsg *fmsg, void *ctx,
+				 struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+
+	return rvu_nix_report_show(fmsg, rvu);
+}
+
+static const struct devlink_health_reporter_ops rvu_nix_fault_reporter_ops = {
+		.name = "nix",
+		.dump = rvu_nix_reporter_dump,
+};
+
+int rvu_nix_health_reporters_create(struct rvu_devlink *rvu_dl)
+{
+	struct devlink_health_reporter *rvu_nix_health_reporter;
+	struct rvu_nix_event_cnt *nix_event_count;
+	struct rvu *rvu = rvu_dl->rvu;
+
+	nix_event_count = kzalloc(sizeof(*nix_event_count), GFP_KERNEL);
+	if (!nix_event_count)
+		return -ENOMEM;
+
+	rvu_dl->nix_event_cnt = nix_event_count;
+	rvu_nix_health_reporter = devlink_health_reporter_create(rvu_dl->dl,
+								 &rvu_nix_fault_reporter_ops,
+								 0, rvu);
+	if (IS_ERR(rvu_nix_health_reporter)) {
+		dev_warn(rvu->dev, "Failed to create nix reporter, err = %ld\n",
+			 PTR_ERR(rvu_nix_health_reporter));
+		return PTR_ERR(rvu_nix_health_reporter);
+	}
+
+	rvu_dl->rvu_nix_health_reporter = rvu_nix_health_reporter;
+	return 0;
+}
+
+void rvu_nix_health_reporters_destroy(struct rvu_devlink *rvu_dl)
+{
+	if (!rvu_dl->rvu_nix_health_reporter)
+		return;
+
+	devlink_health_reporter_destroy(rvu_dl->rvu_nix_health_reporter);
+}
+
 static irqreturn_t rvu_npa_af_rvu_intr_handler(int irq, void *rvu_irq)
 {
 	struct rvu_npa_event_cnt *npa_event_count;
@@ -420,12 +788,17 @@ static void rvu_npa_health_reporters_destroy(struct rvu_devlink *rvu_dl)
 static int rvu_health_reporters_create(struct rvu *rvu)
 {
 	struct rvu_devlink *rvu_dl;
+	int err;
 
 	if (!rvu->rvu_dl)
 		return -EINVAL;
 
 	rvu_dl = rvu->rvu_dl;
-	return rvu_npa_health_reporters_create(rvu_dl);
+	err = rvu_npa_health_reporters_create(rvu_dl);
+	if (err)
+		return err;
+
+	return rvu_nix_health_reporters_create(rvu_dl);
 }
 
 static void rvu_health_reporters_destroy(struct rvu *rvu)
@@ -437,6 +810,7 @@ static void rvu_health_reporters_destroy(struct rvu *rvu)
 
 	rvu_dl = rvu->rvu_dl;
 	rvu_npa_health_reporters_destroy(rvu_dl);
+	rvu_nix_health_reporters_destroy(rvu_dl);
 }
 
 static int rvu_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
index b3ce1a8fff57..15724ad2ed44 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
@@ -29,11 +29,35 @@ struct rvu_npa_event_cnt {
 	unsigned long poison_aq_cxt_count;
 };
 
+struct rvu_nix_event_cnt {
+	unsigned long unmap_slot_count;
+	unsigned long aq_inst_count;
+	unsigned long aq_res_count;
+	unsigned long aq_db_count;
+	unsigned long rx_on_unmap_pf_count;
+	unsigned long rx_mcast_repl_count;
+	unsigned long rx_mcast_memfault_count;
+	unsigned long rx_mcast_wqe_memfault_count;
+	unsigned long rx_mirror_wqe_memfault_count;
+	unsigned long rx_mirror_pktw_memfault_count;
+	unsigned long rx_mcast_pktw_memfault_count;
+	unsigned long poison_aq_inst_count;
+	unsigned long poison_aq_res_count;
+	unsigned long poison_aq_cxt_count;
+	unsigned long rx_mirror_data_poison_count;
+	unsigned long rx_mcast_data_poison_count;
+	unsigned long rx_mirror_wqe_poison_count;
+	unsigned long rx_mcast_wqe_poison_count;
+	unsigned long rx_mce_poison_count;
+};
+
 struct rvu_devlink {
 	struct devlink *dl;
 	struct rvu *rvu;
 	struct devlink_health_reporter *rvu_npa_health_reporter;
 	struct rvu_npa_event_cnt *npa_event_cnt;
+	struct devlink_health_reporter *rvu_nix_health_reporter;
+	struct rvu_nix_event_cnt *nix_event_cnt;
 };
 
 /* Devlink APIs */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 995add5d8bff..b5944199faf5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -74,6 +74,16 @@ enum npa_af_int_vec_e {
 	NPA_AF_INT_VEC_CNT	= 0x5,
 };
 
+/* NIX Admin function Interrupt Vector Enumeration */
+enum nix_af_int_vec_e {
+	NIX_AF_INT_VEC_RVU	= 0x0,
+	NIX_AF_INT_VEC_GEN	= 0x1,
+	NIX_AF_INT_VEC_AQ_DONE	= 0x2,
+	NIX_AF_INT_VEC_AF_ERR	= 0x3,
+	NIX_AF_INT_VEC_POISON	= 0x4,
+	NIX_AF_INT_VEC_CNT	= 0x5,
+};
+
 /**
  * RVU PF Interrupt Vector Enumeration
  */
-- 
2.25.1

