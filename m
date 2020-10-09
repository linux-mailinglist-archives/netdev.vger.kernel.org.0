Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19E6288CE2
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389415AbgJIPgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:36:02 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51280 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389257AbgJIPf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:35:59 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 099FUjet023503;
        Fri, 9 Oct 2020 08:35:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=abXxAGUFWTUMZelkQmFx0gRvPmGArY9rKW5NbgwISzg=;
 b=ftZxDzUgyf/r2T9TnhNXY0qZAljClpHBoN7QypyFqxLA8h+65WhgtYLcOmuL8SNodGFo
 DF3qXFq8njGzW8JqaJytt7H0dEFTvhA/xtxk0hv+NmE+XxTDa8ilzOZo45Mh48N9hK6+
 jZTt4bcll8mm8hXHo/aigwiWsLO3xvok0jQ2CpiV6bE/KpZaxJLrQr3y5Ntd9vqb+IO2
 LrhPLAgL2bRxS7oFXZkpLmXamoR7RA0oN+jnlNWB9faB6S0VblfzJ+yAAseBb0SoRJXU
 fyFvFuaI1YmH5wkH1eCiNHPIk6IAniuxFfMDmXemv3M6fgJ1glM/9RUK9li/phJyQY5A Wg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3429hh34qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Oct 2020 08:35:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 08:35:48 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 08:35:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Oct 2020 08:35:47 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id EB2CE3F703F;
        Fri,  9 Oct 2020 08:35:43 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v4,net-next,08/13] crypto: octeontx2: add LF framework
Date:   Fri, 9 Oct 2020 21:04:16 +0530
Message-ID: <20201009153421.30562-9-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009153421.30562-1-schalla@marvell.com>
References: <20201009153421.30562-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_06:2020-10-09,2020-10-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPT RVU Local Functions(LFs) needs to be attached to the PF/VF to
submit the instructions to CPT. This patch adds the interface to
initialize and attach the LFs. It also adds interface to register
the LF's interrupts.

Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/octeontx2/Makefile     |   2 +-
 .../marvell/octeontx2/otx2_cpt_common.h       |   4 +
 .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  56 +++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c | 426 ++++++++++++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h | 282 ++++++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   2 +
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |   8 +
 7 files changed, 779 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.h

diff --git a/drivers/crypto/marvell/octeontx2/Makefile b/drivers/crypto/marvell/octeontx2/Makefile
index 3c4155446296..e47a55961bb8 100644
--- a/drivers/crypto/marvell/octeontx2/Makefile
+++ b/drivers/crypto/marvell/octeontx2/Makefile
@@ -2,6 +2,6 @@
 obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += octeontx2-cpt.o
 
 octeontx2-cpt-objs := otx2_cptpf_main.o otx2_cptpf_mbox.o \
-		      otx2_cpt_mbox_common.o otx2_cptpf_ucode.o
+		      otx2_cpt_mbox_common.o otx2_cptpf_ucode.o otx2_cptlf.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index ae16dc102459..d5576f5d3b90 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -76,4 +76,8 @@ int otx2_cpt_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
 			 u64 reg, u64 *val);
 int otx2_cpt_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
 			  u64 reg, u64 val);
+struct otx2_cptlfs_info;
+int otx2_cpt_attach_rscrs_msg(struct otx2_cptlfs_info *lfs);
+int otx2_cpt_detach_rsrcs_msg(struct otx2_cptlfs_info *lfs);
+
 #endif /* __OTX2_CPT_COMMON_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
index ef1291c4881b..0933031ac827 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2020 Marvell. */
 
 #include "otx2_cpt_common.h"
+#include "otx2_cptlf.h"
 
 int otx2_cpt_send_mbox_msg(struct otx2_mbox *mbox, struct pci_dev *pdev)
 {
@@ -112,3 +113,58 @@ int otx2_cpt_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
 
 	return otx2_cpt_send_mbox_msg(mbox, pdev);
 }
+
+int otx2_cpt_attach_rscrs_msg(struct otx2_cptlfs_info *lfs)
+{
+	struct otx2_mbox *mbox = lfs->mbox;
+	struct rsrc_attach *req;
+	int ret;
+
+	req = (struct rsrc_attach *)
+			otx2_mbox_alloc_msg_rsp(mbox, 0, sizeof(*req),
+						sizeof(struct msg_rsp));
+	if (req == NULL) {
+		dev_err(&lfs->pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+
+	req->hdr.id = MBOX_MSG_ATTACH_RESOURCES;
+	req->hdr.sig = OTX2_MBOX_REQ_SIG;
+	req->hdr.pcifunc = 0;
+	req->cptlfs = lfs->lfs_num;
+	ret = otx2_cpt_send_mbox_msg(mbox, lfs->pdev);
+	if (ret)
+		return ret;
+
+	if (!lfs->are_lfs_attached)
+		ret = -EINVAL;
+
+	return ret;
+}
+
+int otx2_cpt_detach_rsrcs_msg(struct otx2_cptlfs_info *lfs)
+{
+	struct otx2_mbox *mbox = lfs->mbox;
+	struct rsrc_detach *req;
+	int ret;
+
+	req = (struct rsrc_detach *)
+				otx2_mbox_alloc_msg_rsp(mbox, 0, sizeof(*req),
+							sizeof(struct msg_rsp));
+	if (req == NULL) {
+		dev_err(&lfs->pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+
+	req->hdr.id = MBOX_MSG_DETACH_RESOURCES;
+	req->hdr.sig = OTX2_MBOX_REQ_SIG;
+	req->hdr.pcifunc = 0;
+	ret = otx2_cpt_send_mbox_msg(mbox, lfs->pdev);
+	if (ret)
+		return ret;
+
+	if (lfs->are_lfs_attached)
+		ret = -EINVAL;
+
+	return ret;
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
new file mode 100644
index 000000000000..4069e4802072
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
@@ -0,0 +1,426 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include "otx2_cpt_common.h"
+#include "otx2_cptlf.h"
+#include "rvu_reg.h"
+
+#define CPT_TIMER_HOLD 0x03F
+#define CPT_COUNT_HOLD 32
+
+static void cptlf_do_set_done_time_wait(struct otx2_cptlf_info *lf,
+					int time_wait)
+{
+	union otx2_cptx_lf_done_wait done_wait;
+
+	done_wait.u = otx2_cpt_read64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+				      OTX2_CPT_LF_DONE_WAIT);
+	done_wait.s.time_wait = time_wait;
+	otx2_cpt_write64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+			 OTX2_CPT_LF_DONE_WAIT, done_wait.u);
+}
+
+static void cptlf_do_set_done_num_wait(struct otx2_cptlf_info *lf, int num_wait)
+{
+	union otx2_cptx_lf_done_wait done_wait;
+
+	done_wait.u = otx2_cpt_read64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+				      OTX2_CPT_LF_DONE_WAIT);
+	done_wait.s.num_wait = num_wait;
+	otx2_cpt_write64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+			 OTX2_CPT_LF_DONE_WAIT, done_wait.u);
+}
+
+static void cptlf_set_done_time_wait(struct otx2_cptlfs_info *lfs,
+				     int time_wait)
+{
+	int slot;
+
+	for (slot = 0; slot < lfs->lfs_num; slot++)
+		cptlf_do_set_done_time_wait(&lfs->lf[slot], time_wait);
+}
+
+static void cptlf_set_done_num_wait(struct otx2_cptlfs_info *lfs, int num_wait)
+{
+	int slot;
+
+	for (slot = 0; slot < lfs->lfs_num; slot++)
+		cptlf_do_set_done_num_wait(&lfs->lf[slot], num_wait);
+}
+
+static int cptlf_set_pri(struct otx2_cptlf_info *lf, int pri)
+{
+	struct otx2_cptlfs_info *lfs = lf->lfs;
+	union otx2_cptx_af_lf_ctrl lf_ctrl;
+	int ret;
+
+	ret = otx2_cpt_read_af_reg(lfs->mbox, lfs->pdev,
+				   CPT_AF_LFX_CTL(lf->slot),
+				   &lf_ctrl.u);
+	if (ret)
+		return ret;
+
+	lf_ctrl.s.pri = pri ? 1 : 0;
+
+	ret = otx2_cpt_write_af_reg(lfs->mbox, lfs->pdev,
+				    CPT_AF_LFX_CTL(lf->slot),
+				    lf_ctrl.u);
+	return ret;
+}
+
+static int cptlf_set_eng_grps_mask(struct otx2_cptlf_info *lf,
+				   int eng_grps_mask)
+{
+	struct otx2_cptlfs_info *lfs = lf->lfs;
+	union otx2_cptx_af_lf_ctrl lf_ctrl;
+	int ret;
+
+	ret = otx2_cpt_read_af_reg(lfs->mbox, lfs->pdev,
+				   CPT_AF_LFX_CTL(lf->slot),
+				   &lf_ctrl.u);
+	if (ret)
+		return ret;
+
+	lf_ctrl.s.grp = eng_grps_mask;
+
+	ret = otx2_cpt_write_af_reg(lfs->mbox, lfs->pdev,
+				    CPT_AF_LFX_CTL(lf->slot),
+				    lf_ctrl.u);
+	return ret;
+}
+
+static int cptlf_set_grp_and_pri(struct otx2_cptlfs_info *lfs,
+				 int eng_grp_mask, int pri)
+{
+	int slot, ret = 0;
+
+	for (slot = 0; slot < lfs->lfs_num; slot++) {
+		ret = cptlf_set_pri(&lfs->lf[slot], pri);
+		if (ret)
+			return ret;
+
+		ret = cptlf_set_eng_grps_mask(&lfs->lf[slot], eng_grp_mask);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+static void cptlf_hw_init(struct otx2_cptlfs_info *lfs)
+{
+	/* Disable instruction queues */
+	otx2_cptlf_disable_iqueues(lfs);
+
+	/* Set instruction queues base addresses */
+	otx2_cptlf_set_iqueues_base_addr(lfs);
+
+	/* Set instruction queues sizes */
+	otx2_cptlf_set_iqueues_size(lfs);
+
+	/* Set done interrupts time wait */
+	cptlf_set_done_time_wait(lfs, CPT_TIMER_HOLD);
+
+	/* Set done interrupts num wait */
+	cptlf_set_done_num_wait(lfs, CPT_COUNT_HOLD);
+
+	/* Enable instruction queues */
+	otx2_cptlf_enable_iqueues(lfs);
+}
+
+static void cptlf_hw_cleanup(struct otx2_cptlfs_info *lfs)
+{
+	/* Disable instruction queues */
+	otx2_cptlf_disable_iqueues(lfs);
+}
+
+static void cptlf_set_misc_intrs(struct otx2_cptlfs_info *lfs, u8 enable)
+{
+	union otx2_cptx_lf_misc_int_ena_w1s irq_misc = { .u = 0x0 };
+	u64 reg = enable ? OTX2_CPT_LF_MISC_INT_ENA_W1S :
+			   OTX2_CPT_LF_MISC_INT_ENA_W1C;
+	int slot;
+
+	irq_misc.s.fault = 0x1;
+	irq_misc.s.hwerr = 0x1;
+	irq_misc.s.irde = 0x1;
+	irq_misc.s.nqerr = 0x1;
+	irq_misc.s.nwrp = 0x1;
+
+	for (slot = 0; slot < lfs->lfs_num; slot++)
+		otx2_cpt_write64(lfs->reg_base, BLKADDR_CPT0, slot, reg,
+				 irq_misc.u);
+}
+
+static void cptlf_enable_intrs(struct otx2_cptlfs_info *lfs)
+{
+	int slot;
+
+	/* Enable done interrupts */
+	for (slot = 0; slot < lfs->lfs_num; slot++)
+		otx2_cpt_write64(lfs->reg_base, BLKADDR_CPT0, slot,
+				 OTX2_CPT_LF_DONE_INT_ENA_W1S, 0x1);
+	/* Enable Misc interrupts */
+	cptlf_set_misc_intrs(lfs, true);
+}
+
+static void cptlf_disable_intrs(struct otx2_cptlfs_info *lfs)
+{
+	int slot;
+
+	for (slot = 0; slot < lfs->lfs_num; slot++)
+		otx2_cpt_write64(lfs->reg_base, BLKADDR_CPT0, slot,
+				 OTX2_CPT_LF_DONE_INT_ENA_W1C, 0x1);
+	cptlf_set_misc_intrs(lfs, false);
+}
+
+static inline int cptlf_read_done_cnt(struct otx2_cptlf_info *lf)
+{
+	union otx2_cptx_lf_done irq_cnt;
+
+	irq_cnt.u = otx2_cpt_read64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+				    OTX2_CPT_LF_DONE);
+	return irq_cnt.s.done;
+}
+
+static irqreturn_t cptlf_misc_intr_handler(int __always_unused irq, void *arg)
+{
+	union otx2_cptx_lf_misc_int irq_misc, irq_misc_ack;
+	struct otx2_cptlf_info *lf = arg;
+	struct device *dev;
+
+	dev = &lf->lfs->pdev->dev;
+	irq_misc.u = otx2_cpt_read64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+				     OTX2_CPT_LF_MISC_INT);
+	irq_misc_ack.u = 0x0;
+
+	if (irq_misc.s.fault) {
+		dev_err(dev, "Memory error detected while executing CPT_INST_S, LF %d.\n",
+			lf->slot);
+		irq_misc_ack.s.fault = 0x1;
+
+	} else if (irq_misc.s.hwerr) {
+		dev_err(dev, "HW error from an engine executing CPT_INST_S, LF %d.",
+			lf->slot);
+		irq_misc_ack.s.hwerr = 0x1;
+
+	} else if (irq_misc.s.nwrp) {
+		dev_err(dev, "SMMU fault while writing CPT_RES_S to CPT_INST_S[RES_ADDR], LF %d.\n",
+			lf->slot);
+		irq_misc_ack.s.nwrp = 0x1;
+
+	} else if (irq_misc.s.irde) {
+		dev_err(dev, "Memory error when accessing instruction memory queue CPT_LF_Q_BASE[ADDR].\n");
+		irq_misc_ack.s.irde = 0x1;
+
+	} else if (irq_misc.s.nqerr) {
+		dev_err(dev, "Error enqueuing an instruction received at CPT_LF_NQ.\n");
+		irq_misc_ack.s.nqerr = 0x1;
+
+	} else {
+		dev_err(dev, "Unhandled interrupt in CPT LF %d\n", lf->slot);
+		return IRQ_NONE;
+	}
+
+	/* Acknowledge interrupts */
+	otx2_cpt_write64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+			 OTX2_CPT_LF_MISC_INT, irq_misc_ack.u);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t cptlf_done_intr_handler(int irq, void *arg)
+{
+	union otx2_cptx_lf_done_wait done_wait;
+	struct otx2_cptlf_info *lf = arg;
+	int irq_cnt;
+
+	/* Read the number of completed requests */
+	irq_cnt = cptlf_read_done_cnt(lf);
+	if (irq_cnt) {
+		done_wait.u = otx2_cpt_read64(lf->lfs->reg_base, BLKADDR_CPT0,
+					      lf->slot, OTX2_CPT_LF_DONE_WAIT);
+		/* Acknowledge the number of completed requests */
+		otx2_cpt_write64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+				 OTX2_CPT_LF_DONE_ACK, irq_cnt);
+
+		otx2_cpt_write64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+				 OTX2_CPT_LF_DONE_WAIT, done_wait.u);
+		if (unlikely(!lf->wqe)) {
+			dev_err(&lf->lfs->pdev->dev, "No work for LF %d\n",
+				lf->slot);
+			return IRQ_NONE;
+		}
+
+		/* Schedule processing of completed requests */
+		tasklet_hi_schedule(&lf->wqe->work);
+	}
+	return IRQ_HANDLED;
+}
+
+void otx2_cptlf_unregister_interrupts(struct otx2_cptlfs_info *lfs)
+{
+	int i, offs, vector;
+
+	for (i = 0; i < lfs->lfs_num; i++) {
+		for (offs = 0; offs < OTX2_CPT_LF_MSIX_VECTORS; offs++) {
+			if (!lfs->lf[i].is_irq_reg[offs])
+				continue;
+
+			vector = pci_irq_vector(lfs->pdev,
+						lfs->lf[i].msix_offset + offs);
+			free_irq(vector, &lfs->lf[i]);
+			lfs->lf[i].is_irq_reg[offs] = false;
+		}
+	}
+	cptlf_disable_intrs(lfs);
+}
+
+static int cptlf_do_register_interrrupts(struct otx2_cptlfs_info *lfs,
+					 int lf_num, int irq_offset,
+					 irq_handler_t handler)
+{
+	int ret, vector;
+
+	vector = pci_irq_vector(lfs->pdev, lfs->lf[lf_num].msix_offset +
+				irq_offset);
+	ret = request_irq(vector, handler, 0,
+			  lfs->lf[lf_num].irq_name[irq_offset],
+			  &lfs->lf[lf_num]);
+	if (ret)
+		return ret;
+
+	lfs->lf[lf_num].is_irq_reg[irq_offset] = true;
+
+	return ret;
+}
+
+int otx2_cptlf_register_interrupts(struct otx2_cptlfs_info *lfs)
+{
+	int irq_offs, ret, i;
+
+	for (i = 0; i < lfs->lfs_num; i++) {
+		irq_offs = OTX2_CPT_LF_INT_VEC_E_MISC;
+		snprintf(lfs->lf[i].irq_name[irq_offs], 32, "CPTLF Misc%d", i);
+		ret = cptlf_do_register_interrrupts(lfs, i, irq_offs,
+						    cptlf_misc_intr_handler);
+		if (ret)
+			goto free_irq;
+
+		irq_offs = OTX2_CPT_LF_INT_VEC_E_DONE;
+		snprintf(lfs->lf[i].irq_name[irq_offs], 32, "OTX2_CPTLF Done%d",
+			 i);
+		ret = cptlf_do_register_interrrupts(lfs, i, irq_offs,
+						    cptlf_done_intr_handler);
+		if (ret)
+			goto free_irq;
+	}
+	cptlf_enable_intrs(lfs);
+	return 0;
+free_irq:
+	otx2_cptlf_unregister_interrupts(lfs);
+	return ret;
+}
+
+void otx2_cptlf_free_irqs_affinity(struct otx2_cptlfs_info *lfs)
+{
+	int slot, offs;
+
+	for (slot = 0; slot < lfs->lfs_num; slot++) {
+		for (offs = 0; offs < OTX2_CPT_LF_MSIX_VECTORS; offs++)
+			irq_set_affinity_hint(pci_irq_vector(lfs->pdev,
+					      lfs->lf[slot].msix_offset +
+					      offs), NULL);
+		if (lfs->lf[slot].affinity_mask)
+			free_cpumask_var(lfs->lf[slot].affinity_mask);
+	}
+}
+
+int otx2_cptlf_set_irqs_affinity(struct otx2_cptlfs_info *lfs)
+{
+	struct otx2_cptlf_info *lf = lfs->lf;
+	int slot, offs, ret;
+
+	for (slot = 0; slot < lfs->lfs_num; slot++) {
+		if (!zalloc_cpumask_var(&lf[slot].affinity_mask, GFP_KERNEL)) {
+			dev_err(&lfs->pdev->dev,
+				"cpumask allocation failed for LF %d", slot);
+			ret = -ENOMEM;
+			goto free_affinity_mask;
+		}
+
+		cpumask_set_cpu(cpumask_local_spread(slot,
+				dev_to_node(&lfs->pdev->dev)),
+				lf[slot].affinity_mask);
+
+		for (offs = 0; offs < OTX2_CPT_LF_MSIX_VECTORS; offs++) {
+			ret = irq_set_affinity_hint(pci_irq_vector(lfs->pdev,
+						lf[slot].msix_offset + offs),
+						lf[slot].affinity_mask);
+			if (ret)
+				goto free_affinity_mask;
+		}
+	}
+	return 0;
+free_affinity_mask:
+	otx2_cptlf_free_irqs_affinity(lfs);
+	return ret;
+}
+
+int otx2_cptlf_init(struct otx2_cptlfs_info *lfs, u8 eng_grp_mask, int pri,
+		    int lfs_num)
+{
+	int slot, ret;
+
+	if (!lfs->pdev || !lfs->reg_base)
+		return -EINVAL;
+
+	lfs->lfs_num = lfs_num;
+	for (slot = 0; slot < lfs->lfs_num; slot++) {
+		lfs->lf[slot].lfs = lfs;
+		lfs->lf[slot].slot = slot;
+		lfs->lf[slot].lmtline = lfs->reg_base +
+			OTX2_CPT_RVU_FUNC_ADDR_S(BLKADDR_LMT, slot,
+						 OTX2_CPT_LMT_LF_LMTLINEX(0));
+		lfs->lf[slot].ioreg = lfs->reg_base +
+			OTX2_CPT_RVU_FUNC_ADDR_S(BLKADDR_CPT0, slot,
+						 OTX2_CPT_LF_NQX(0));
+	}
+	/* Send request to attach LFs */
+	ret = otx2_cpt_attach_rscrs_msg(lfs);
+	if (ret)
+		goto clear_lfs_num;
+
+	ret = otx2_cpt_alloc_instruction_queues(lfs);
+	if (ret) {
+		dev_err(&lfs->pdev->dev,
+			"Allocating instruction queues failed\n");
+		goto detach_rsrcs;
+	}
+	cptlf_hw_init(lfs);
+	/*
+	 * Allow each LF to execute requests destined to any of 8 engine
+	 * groups and set queue priority of each LF to high
+	 */
+	ret = cptlf_set_grp_and_pri(lfs, eng_grp_mask, pri);
+	if (ret)
+		goto free_iq;
+
+	return 0;
+free_iq:
+	otx2_cpt_free_instruction_queues(lfs);
+	cptlf_hw_cleanup(lfs);
+detach_rsrcs:
+	otx2_cpt_detach_rsrcs_msg(lfs);
+clear_lfs_num:
+	lfs->lfs_num = 0;
+	return ret;
+}
+
+void otx2_cptlf_shutdown(struct otx2_cptlfs_info *lfs)
+{
+	lfs->lfs_num = 0;
+	/* Cleanup LFs hardware side */
+	cptlf_hw_cleanup(lfs);
+	/* Send request to detach LFs */
+	otx2_cpt_detach_rsrcs_msg(lfs);
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
new file mode 100644
index 000000000000..be1315ddfb7b
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
@@ -0,0 +1,282 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2020 Marvell.
+ */
+#ifndef __OTX2_CPTLF_H
+#define __OTX2_CPTLF_H
+
+#include <mbox.h>
+#include <rvu.h>
+#include "otx2_cpt_common.h"
+
+/*
+ * CPT instruction and pending queues user requested length in CPT_INST_S msgs
+ */
+#define OTX2_CPT_USER_REQUESTED_QLEN_MSGS 8200
+
+/*
+ * CPT instruction queue size passed to HW is in units of 40*CPT_INST_S
+ * messages.
+ */
+#define OTX2_CPT_SIZE_DIV40 (OTX2_CPT_USER_REQUESTED_QLEN_MSGS/40)
+
+/*
+ * CPT instruction and pending queues length in CPT_INST_S messages
+ */
+#define OTX2_CPT_INST_QLEN_MSGS	((OTX2_CPT_SIZE_DIV40 - 1) * 40)
+
+/* CPT instruction queue length in bytes */
+#define OTX2_CPT_INST_QLEN_BYTES (OTX2_CPT_SIZE_DIV40 * 40 * \
+				  OTX2_CPT_INST_SIZE)
+
+/* CPT instruction group queue length in bytes */
+#define OTX2_CPT_INST_GRP_QLEN_BYTES (OTX2_CPT_SIZE_DIV40 * 16)
+
+/* CPT FC length in bytes */
+#define OTX2_CPT_Q_FC_LEN 128
+
+/* CPT instruction queue alignment */
+#define OTX2_CPT_INST_Q_ALIGNMENT  128
+
+/* Mask which selects all engine groups */
+#define OTX2_CPT_ALL_ENG_GRPS_MASK 0xFF
+
+/* Maximum LFs supported in OcteonTX2 for CPT */
+#define OTX2_CPT_MAX_LFS_NUM    64
+
+/* Queue priority */
+#define OTX2_CPT_QUEUE_HI_PRIO  0x1
+#define OTX2_CPT_QUEUE_LOW_PRIO 0x0
+
+enum otx2_cptlf_state {
+	OTX2_CPTLF_IN_RESET,
+	OTX2_CPTLF_STARTED,
+};
+
+struct otx2_cpt_inst_queue {
+	u8 *vaddr;
+	u8 *real_vaddr;
+	dma_addr_t dma_addr;
+	dma_addr_t real_dma_addr;
+	u32 size;
+};
+
+struct otx2_cptlfs_info;
+struct otx2_cptlf_wqe {
+	struct tasklet_struct work;
+	struct otx2_cptlfs_info *lfs;
+	u8 lf_num;
+};
+
+struct otx2_cptlf_info {
+	struct otx2_cptlfs_info *lfs;           /* Ptr to cptlfs_info struct */
+	void __iomem *lmtline;                  /* Address of LMTLINE */
+	void __iomem *ioreg;                    /* LMTLINE send register */
+	int msix_offset;                        /* MSI-X interrupts offset */
+	cpumask_var_t affinity_mask;            /* IRQs affinity mask */
+	u8 irq_name[OTX2_CPT_LF_MSIX_VECTORS][32];/* Interrupts name */
+	u8 is_irq_reg[OTX2_CPT_LF_MSIX_VECTORS];  /* Is interrupt registered */
+	u8 slot;                                /* Slot number of this LF */
+
+	struct otx2_cpt_inst_queue iqueue;/* Instruction queue */
+	struct otx2_cptlf_wqe *wqe;       /* Tasklet work info */
+};
+
+struct otx2_cptlfs_info {
+	/* Registers start address of VF/PF LFs are attached to */
+	void __iomem *reg_base;
+	struct pci_dev *pdev;   /* Device LFs are attached to */
+	struct otx2_cptlf_info lf[OTX2_CPT_MAX_LFS_NUM];
+	struct otx2_mbox *mbox;
+	u8 are_lfs_attached;	/* Whether CPT LFs are attached */
+	u8 lfs_num;		/* Number of CPT LFs */
+	atomic_t state;         /* LF's state. started/reset */
+};
+
+static inline void otx2_cpt_free_instruction_queues(
+					struct otx2_cptlfs_info *lfs)
+{
+	struct otx2_cpt_inst_queue *iq;
+	int i;
+
+	for (i = 0; i < lfs->lfs_num; i++) {
+		iq = &lfs->lf[i].iqueue;
+		if (iq->real_vaddr)
+			dma_free_coherent(&lfs->pdev->dev,
+					  iq->size,
+					  iq->real_vaddr,
+					  iq->real_dma_addr);
+		iq->real_vaddr = NULL;
+		iq->vaddr = NULL;
+	}
+}
+
+static inline int otx2_cpt_alloc_instruction_queues(
+					struct otx2_cptlfs_info *lfs)
+{
+	struct otx2_cpt_inst_queue *iq;
+	int ret = 0, i;
+
+	if (!lfs->lfs_num)
+		return -EINVAL;
+
+	for (i = 0; i < lfs->lfs_num; i++) {
+		iq = &lfs->lf[i].iqueue;
+		iq->size = OTX2_CPT_INST_QLEN_BYTES +
+			   OTX2_CPT_Q_FC_LEN +
+			   OTX2_CPT_INST_GRP_QLEN_BYTES +
+			   OTX2_CPT_INST_Q_ALIGNMENT;
+		iq->real_vaddr = dma_alloc_coherent(&lfs->pdev->dev, iq->size,
+					&iq->real_dma_addr, GFP_KERNEL);
+		if (!iq->real_vaddr) {
+			ret = -ENOMEM;
+			goto error;
+		}
+		iq->vaddr = iq->real_vaddr + OTX2_CPT_INST_GRP_QLEN_BYTES;
+		iq->dma_addr = iq->real_dma_addr + OTX2_CPT_INST_GRP_QLEN_BYTES;
+
+		/* Align pointers */
+		iq->vaddr = PTR_ALIGN(iq->vaddr, OTX2_CPT_INST_Q_ALIGNMENT);
+		iq->dma_addr = PTR_ALIGN(iq->dma_addr,
+					 OTX2_CPT_INST_Q_ALIGNMENT);
+	}
+	return 0;
+error:
+	otx2_cpt_free_instruction_queues(lfs);
+	return ret;
+}
+
+static inline void otx2_cptlf_set_iqueues_base_addr(
+					struct otx2_cptlfs_info *lfs)
+{
+	union otx2_cptx_lf_q_base lf_q_base;
+	int slot;
+
+	for (slot = 0; slot < lfs->lfs_num; slot++) {
+		lf_q_base.u = lfs->lf[slot].iqueue.dma_addr;
+		otx2_cpt_write64(lfs->reg_base, BLKADDR_CPT0, slot,
+				 OTX2_CPT_LF_Q_BASE, lf_q_base.u);
+	}
+}
+
+static inline void otx2_cptlf_do_set_iqueue_size(struct otx2_cptlf_info *lf)
+{
+	union otx2_cptx_lf_q_size lf_q_size = { .u = 0x0 };
+
+	lf_q_size.s.size_div40 = OTX2_CPT_SIZE_DIV40;
+	otx2_cpt_write64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+			 OTX2_CPT_LF_Q_SIZE, lf_q_size.u);
+}
+
+static inline void otx2_cptlf_set_iqueues_size(struct otx2_cptlfs_info *lfs)
+{
+	int slot;
+
+	for (slot = 0; slot < lfs->lfs_num; slot++)
+		otx2_cptlf_do_set_iqueue_size(&lfs->lf[slot]);
+}
+
+static inline void otx2_cptlf_do_disable_iqueue(struct otx2_cptlf_info *lf)
+{
+	union otx2_cptx_lf_ctl lf_ctl = { .u = 0x0 };
+	union otx2_cptx_lf_inprog lf_inprog;
+	int timeout = 20;
+
+	/* Disable instructions enqueuing */
+	otx2_cpt_write64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+			 OTX2_CPT_LF_CTL, lf_ctl.u);
+
+	/* Wait for instruction queue to become empty */
+	do {
+		lf_inprog.u = otx2_cpt_read64(lf->lfs->reg_base, BLKADDR_CPT0,
+					      lf->slot, OTX2_CPT_LF_INPROG);
+		if (!lf_inprog.s.inflight)
+			break;
+
+		usleep_range(10000, 20000);
+		if (timeout-- < 0) {
+			dev_err(&lf->lfs->pdev->dev,
+				"Error LF %d is still busy.\n", lf->slot);
+			break;
+		}
+
+	} while (1);
+
+	/*
+	 * Disable executions in the LF's queue,
+	 * the queue should be empty at this point
+	 */
+	lf_inprog.s.eena = 0x0;
+	otx2_cpt_write64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+			 OTX2_CPT_LF_INPROG, lf_inprog.u);
+}
+
+static inline void otx2_cptlf_disable_iqueues(struct otx2_cptlfs_info *lfs)
+{
+	int slot;
+
+	for (slot = 0; slot < lfs->lfs_num; slot++)
+		otx2_cptlf_do_disable_iqueue(&lfs->lf[slot]);
+}
+
+static inline void otx2_cptlf_set_iqueue_enq(struct otx2_cptlf_info *lf,
+					     bool enable)
+{
+	union otx2_cptx_lf_ctl lf_ctl;
+
+	lf_ctl.u = otx2_cpt_read64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+				   OTX2_CPT_LF_CTL);
+
+	/* Set iqueue's enqueuing */
+	lf_ctl.s.ena = enable ? 0x1 : 0x0;
+	otx2_cpt_write64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+			 OTX2_CPT_LF_CTL, lf_ctl.u);
+}
+
+static inline void otx2_cptlf_enable_iqueue_enq(struct otx2_cptlf_info *lf)
+{
+	otx2_cptlf_set_iqueue_enq(lf, true);
+}
+
+static inline void otx2_cptlf_set_iqueue_exec(struct otx2_cptlf_info *lf,
+					      bool enable)
+{
+	union otx2_cptx_lf_inprog lf_inprog;
+
+	lf_inprog.u = otx2_cpt_read64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+				      OTX2_CPT_LF_INPROG);
+
+	/* Set iqueue's execution */
+	lf_inprog.s.eena = enable ? 0x1 : 0x0;
+	otx2_cpt_write64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+			 OTX2_CPT_LF_INPROG, lf_inprog.u);
+}
+
+static inline void otx2_cptlf_enable_iqueue_exec(struct otx2_cptlf_info *lf)
+{
+	otx2_cptlf_set_iqueue_exec(lf, true);
+}
+
+static inline void otx2_cptlf_disable_iqueue_exec(struct otx2_cptlf_info *lf)
+{
+	otx2_cptlf_set_iqueue_exec(lf, false);
+}
+
+static inline void otx2_cptlf_enable_iqueues(struct otx2_cptlfs_info *lfs)
+{
+	int slot;
+
+	for (slot = 0; slot < lfs->lfs_num; slot++) {
+		otx2_cptlf_enable_iqueue_exec(&lfs->lf[slot]);
+		otx2_cptlf_enable_iqueue_enq(&lfs->lf[slot]);
+	}
+}
+
+int otx2_cptlf_init(struct otx2_cptlfs_info *lfs, u8 eng_grp_msk, int pri,
+		    int lfs_num);
+void otx2_cptlf_shutdown(struct otx2_cptlfs_info *lfs);
+int otx2_cptlf_register_interrupts(struct otx2_cptlfs_info *lfs);
+void otx2_cptlf_unregister_interrupts(struct otx2_cptlfs_info *lfs);
+void otx2_cptlf_free_irqs_affinity(struct otx2_cptlfs_info *lfs);
+int otx2_cptlf_set_irqs_affinity(struct otx2_cptlfs_info *lfs);
+
+#endif /* __OTX2_CPTLF_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
index 528a3975b9c2..15561fe50bc0 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
@@ -7,6 +7,7 @@
 
 #include "otx2_cpt_common.h"
 #include "otx2_cptpf_ucode.h"
+#include "otx2_cptlf.h"
 
 struct otx2_cptpf_dev;
 struct otx2_cptvf_info {
@@ -24,6 +25,7 @@ struct otx2_cptpf_dev {
 	struct pci_dev *pdev;		/* PCI device handle */
 	struct otx2_cptvf_info vf[OTX2_CPT_MAX_VFS_NUM];
 	struct otx2_cpt_eng_grps eng_grps;/* Engine groups information */
+	struct otx2_cptlfs_info lfs;      /* CPT LFs attached to this PF */
 
 	/* AF <=> PF mbox */
 	struct otx2_mbox	afpf_mbox;
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
index 8852a7e5e035..c9bb6b14876c 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -207,6 +207,14 @@ static void process_afpf_mbox_msg(struct otx2_cptpf_dev *cptpf,
 		if (!rsp_rd_wr->is_write)
 			*rsp_rd_wr->ret_val = rsp_rd_wr->val;
 		break;
+	case MBOX_MSG_ATTACH_RESOURCES:
+		if (!msg->rc)
+			cptpf->lfs.are_lfs_attached = 1;
+		break;
+	case MBOX_MSG_DETACH_RESOURCES:
+		if (!msg->rc)
+			cptpf->lfs.are_lfs_attached = 0;
+		break;
 
 	default:
 		dev_err(dev,
-- 
2.28.0

