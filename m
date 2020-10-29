Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9987D29E206
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgJ2CFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:05:23 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4622 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727096AbgJ1Vib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:38:31 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09SEoArZ016968;
        Wed, 28 Oct 2020 07:51:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=txP4I4dvIuuowR0jIWb/bP94QvcHoB59EyGjbms2OYw=;
 b=FSvmOCY/AlzSK59N1iI8nrqdyahDQmNZe1Q1FKsGy9vGT8Yry/oukCRHCj72dCAQy1u8
 SufbK6MYLJTu5LEpTbhjyZ42RfpfTXEMG2v54kw5ZaeXT/o3Sj3VNuiwFBcDT0Z7CFse
 npHv84UMs2RK1q2Q9jyUxXfjpqKjHZNN74fxKRUQ6WVDM0XpndRDXd+8ITU8uI1kGAzU
 H1K24IcbV+/wVStYbauMJa9Uj1ZHL2Y4f4+943/px7ZsfIJQ/jdDJn38fW+Q8XzHj2JK
 f7dYZdOFqtgfG6bFZ/qzd6Yq5Y7vboThEkKqCCBcKs7/NLb8eK9JoHEYihgZVnMz8yjM cw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 34chmn886w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 07:51:49 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 28 Oct
 2020 07:51:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 28 Oct 2020 07:51:48 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 915033F703F;
        Wed, 28 Oct 2020 07:51:44 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v8,net-next,10/12] crypto: octeontx2: add virtual function driver support
Date:   Wed, 28 Oct 2020 20:20:13 +0530
Message-ID: <20201028145015.19212-11-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201028145015.19212-1-schalla@marvell.com>
References: <20201028145015.19212-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_07:2020-10-28,2020-10-28 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the Marvell OcteonTX2 CPT virtual function
driver. This patch includes probe, PCI specific initialization
and interrupt handling.

Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/octeontx2/Makefile     |   4 +-
 .../marvell/octeontx2/otx2_cpt_common.h       |   1 +
 .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  32 +++
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h |  28 +++
 .../marvell/octeontx2/otx2_cptvf_main.c       | 194 ++++++++++++++++++
 .../marvell/octeontx2/otx2_cptvf_mbox.c       | 113 ++++++++++
 6 files changed, 371 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c

diff --git a/drivers/crypto/marvell/octeontx2/Makefile b/drivers/crypto/marvell/octeontx2/Makefile
index e47a55961bb8..ef6fb2ab3571 100644
--- a/drivers/crypto/marvell/octeontx2/Makefile
+++ b/drivers/crypto/marvell/octeontx2/Makefile
@@ -1,7 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += octeontx2-cpt.o
+obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += octeontx2-cpt.o octeontx2-cptvf.o
 
 octeontx2-cpt-objs := otx2_cptpf_main.o otx2_cptpf_mbox.o \
 		      otx2_cpt_mbox_common.o otx2_cptpf_ucode.o otx2_cptlf.o
+octeontx2-cptvf-objs := otx2_cptvf_main.o otx2_cptvf_mbox.o otx2_cptlf.o \
+			otx2_cpt_mbox_common.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index 705a0503b962..ca220178e518 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -115,5 +115,6 @@ int otx2_cpt_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
 struct otx2_cptlfs_info;
 int otx2_cpt_attach_rscrs_msg(struct otx2_cptlfs_info *lfs);
 int otx2_cpt_detach_rsrcs_msg(struct otx2_cptlfs_info *lfs);
+int otx2_cpt_msix_offset_msg(struct otx2_cptlfs_info *lfs);
 
 #endif /* __OTX2_CPT_COMMON_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
index 0933031ac827..51cb6404ded7 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
@@ -168,3 +168,35 @@ int otx2_cpt_detach_rsrcs_msg(struct otx2_cptlfs_info *lfs)
 
 	return ret;
 }
+
+int otx2_cpt_msix_offset_msg(struct otx2_cptlfs_info *lfs)
+{
+	struct otx2_mbox *mbox = lfs->mbox;
+	struct pci_dev *pdev = lfs->pdev;
+	struct mbox_msghdr *req;
+	int ret, i;
+
+	req = otx2_mbox_alloc_msg_rsp(mbox, 0, sizeof(*req),
+				      sizeof(struct msix_offset_rsp));
+	if (req == NULL) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+
+	req->id = MBOX_MSG_MSIX_OFFSET;
+	req->sig = OTX2_MBOX_REQ_SIG;
+	req->pcifunc = 0;
+	ret = otx2_cpt_send_mbox_msg(mbox, pdev);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < lfs->lfs_num; i++) {
+		if (lfs->lf[i].msix_offset == MSIX_VECTOR_INVALID) {
+			dev_err(&pdev->dev,
+				"Invalid msix offset %d for LF %d\n",
+				lfs->lf[i].msix_offset, i);
+			return -EINVAL;
+		}
+	}
+	return ret;
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf.h b/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
new file mode 100644
index 000000000000..4b01eb9d9f70
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef __OTX2_CPTVF_H
+#define __OTX2_CPTVF_H
+
+#include "mbox.h"
+#include "otx2_cptlf.h"
+
+struct otx2_cptvf_dev {
+	void __iomem *reg_base;		/* Register start address */
+	void __iomem *pfvf_mbox_base;	/* PF-VF mbox start address */
+	struct pci_dev *pdev;		/* PCI device handle */
+	struct otx2_cptlfs_info lfs;	/* CPT LFs attached to this VF */
+	u8 vf_id;			/* Virtual function index */
+
+	/* PF <=> VF mbox */
+	struct otx2_mbox	pfvf_mbox;
+	struct work_struct	pfvf_mbox_work;
+	struct workqueue_struct *pfvf_mbox_wq;
+};
+
+irqreturn_t otx2_cptvf_pfvf_mbox_intr(int irq, void *arg);
+void otx2_cptvf_pfvf_mbox_handler(struct work_struct *work);
+int otx2_cptvf_send_eng_grp_num_msg(struct otx2_cptvf_dev *cptvf, int eng_type);
+
+#endif /* __OTX2_CPTVF_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
new file mode 100644
index 000000000000..b90b265f0f42
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -0,0 +1,194 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include "otx2_cpt_common.h"
+#include "otx2_cptvf.h"
+#include <rvu_reg.h>
+
+#define OTX2_CPTVF_DRV_NAME "octeontx2-cptvf"
+
+static void cptvf_enable_pfvf_mbox_intrs(struct otx2_cptvf_dev *cptvf)
+{
+	/* Clear interrupt if any */
+	otx2_cpt_write64(cptvf->reg_base, BLKADDR_RVUM, 0, OTX2_RVU_VF_INT,
+			 0x1ULL);
+
+	/* Enable PF-VF interrupt */
+	otx2_cpt_write64(cptvf->reg_base, BLKADDR_RVUM, 0,
+			 OTX2_RVU_VF_INT_ENA_W1S, 0x1ULL);
+}
+
+static void cptvf_disable_pfvf_mbox_intrs(struct otx2_cptvf_dev *cptvf)
+{
+	/* Disable PF-VF interrupt */
+	otx2_cpt_write64(cptvf->reg_base, BLKADDR_RVUM, 0,
+			 OTX2_RVU_VF_INT_ENA_W1C, 0x1ULL);
+
+	/* Clear interrupt if any */
+	otx2_cpt_write64(cptvf->reg_base, BLKADDR_RVUM, 0, OTX2_RVU_VF_INT,
+			 0x1ULL);
+}
+
+static int cptvf_register_interrupts(struct otx2_cptvf_dev *cptvf)
+{
+	int ret, irq;
+	u32 num_vec;
+
+	num_vec = pci_msix_vec_count(cptvf->pdev);
+	if (num_vec <= 0)
+		return -EINVAL;
+
+	/* Enable MSI-X */
+	ret = pci_alloc_irq_vectors(cptvf->pdev, num_vec, num_vec,
+				    PCI_IRQ_MSIX);
+	if (ret < 0) {
+		dev_err(&cptvf->pdev->dev,
+			"Request for %d msix vectors failed\n", num_vec);
+		return ret;
+	}
+	irq = pci_irq_vector(cptvf->pdev, OTX2_CPT_VF_INT_VEC_E_MBOX);
+	/* Register VF<=>PF mailbox interrupt handler */
+	ret = devm_request_irq(&cptvf->pdev->dev, irq,
+			       otx2_cptvf_pfvf_mbox_intr, 0,
+			       "CPTPFVF Mbox", cptvf);
+	if (ret)
+		return ret;
+	/* Enable PF-VF mailbox interrupts */
+	cptvf_enable_pfvf_mbox_intrs(cptvf);
+
+	ret = otx2_cpt_send_ready_msg(&cptvf->pfvf_mbox, cptvf->pdev);
+	if (ret) {
+		dev_warn(&cptvf->pdev->dev,
+			 "PF not responding to mailbox, deferring probe\n");
+		cptvf_disable_pfvf_mbox_intrs(cptvf);
+		return -EPROBE_DEFER;
+	}
+	return 0;
+}
+
+static int cptvf_pfvf_mbox_init(struct otx2_cptvf_dev *cptvf)
+{
+	int ret;
+
+	cptvf->pfvf_mbox_wq = alloc_workqueue("cpt_pfvf_mailbox",
+					      WQ_UNBOUND | WQ_HIGHPRI |
+					      WQ_MEM_RECLAIM, 1);
+	if (!cptvf->pfvf_mbox_wq)
+		return -ENOMEM;
+
+	ret = otx2_mbox_init(&cptvf->pfvf_mbox, cptvf->pfvf_mbox_base,
+			     cptvf->pdev, cptvf->reg_base, MBOX_DIR_VFPF, 1);
+	if (ret)
+		goto free_wqe;
+
+	INIT_WORK(&cptvf->pfvf_mbox_work, otx2_cptvf_pfvf_mbox_handler);
+	return 0;
+free_wqe:
+	destroy_workqueue(cptvf->pfvf_mbox_wq);
+	return ret;
+}
+
+static void cptvf_pfvf_mbox_destroy(struct otx2_cptvf_dev *cptvf)
+{
+	destroy_workqueue(cptvf->pfvf_mbox_wq);
+	otx2_mbox_destroy(&cptvf->pfvf_mbox);
+}
+
+static int otx2_cptvf_probe(struct pci_dev *pdev,
+			    const struct pci_device_id *ent)
+{
+	struct device *dev = &pdev->dev;
+	resource_size_t offset, size;
+	struct otx2_cptvf_dev *cptvf;
+	int ret;
+
+	cptvf = devm_kzalloc(dev, sizeof(*cptvf), GFP_KERNEL);
+	if (!cptvf)
+		return -ENOMEM;
+
+	ret = pcim_enable_device(pdev);
+	if (ret) {
+		dev_err(dev, "Failed to enable PCI device\n");
+		goto clear_drvdata;
+	}
+
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
+	if (ret) {
+		dev_err(dev, "Unable to get usable DMA configuration\n");
+		goto clear_drvdata;
+	}
+	/* Map VF's configuration registers */
+	ret = pcim_iomap_regions_request_all(pdev, 1 << PCI_PF_REG_BAR_NUM,
+					     OTX2_CPTVF_DRV_NAME);
+	if (ret) {
+		dev_err(dev, "Couldn't get PCI resources 0x%x\n", ret);
+		goto clear_drvdata;
+	}
+	pci_set_master(pdev);
+	pci_set_drvdata(pdev, cptvf);
+	cptvf->pdev = pdev;
+
+	cptvf->reg_base = pcim_iomap_table(pdev)[PCI_PF_REG_BAR_NUM];
+
+	offset = pci_resource_start(pdev, PCI_MBOX_BAR_NUM);
+	size = pci_resource_len(pdev, PCI_MBOX_BAR_NUM);
+	/* Map PF-VF mailbox memory */
+	cptvf->pfvf_mbox_base = devm_ioremap_wc(dev, offset, size);
+	if (!cptvf->pfvf_mbox_base) {
+		dev_err(&pdev->dev, "Unable to map BAR4\n");
+		ret = -ENODEV;
+		goto clear_drvdata;
+	}
+	/* Initialize PF<=>VF mailbox */
+	ret = cptvf_pfvf_mbox_init(cptvf);
+	if (ret)
+		goto clear_drvdata;
+
+	/* Register interrupts */
+	ret = cptvf_register_interrupts(cptvf);
+	if (ret)
+		goto destroy_pfvf_mbox;
+
+	return 0;
+destroy_pfvf_mbox:
+	cptvf_pfvf_mbox_destroy(cptvf);
+clear_drvdata:
+	pci_set_drvdata(pdev, NULL);
+
+	return ret;
+}
+
+static void otx2_cptvf_remove(struct pci_dev *pdev)
+{
+	struct otx2_cptvf_dev *cptvf = pci_get_drvdata(pdev);
+
+	if (!cptvf) {
+		dev_err(&pdev->dev, "Invalid CPT VF device.\n");
+		return;
+	}
+	/* Disable PF-VF mailbox interrupt */
+	cptvf_disable_pfvf_mbox_intrs(cptvf);
+	/* Destroy PF-VF mbox */
+	cptvf_pfvf_mbox_destroy(cptvf);
+	pci_set_drvdata(pdev, NULL);
+}
+
+/* Supported devices */
+static const struct pci_device_id otx2_cptvf_id_table[] = {
+	{PCI_VDEVICE(CAVIUM, OTX2_CPT_PCI_VF_DEVICE_ID), 0},
+	{ 0, }  /* end of table */
+};
+
+static struct pci_driver otx2_cptvf_pci_driver = {
+	.name = OTX2_CPTVF_DRV_NAME,
+	.id_table = otx2_cptvf_id_table,
+	.probe = otx2_cptvf_probe,
+	.remove = otx2_cptvf_remove,
+};
+
+module_pci_driver(otx2_cptvf_pci_driver);
+
+MODULE_AUTHOR("Marvell");
+MODULE_DESCRIPTION("Marvell OcteonTX2 CPT Virtual Function Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(pci, otx2_cptvf_id_table);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
new file mode 100644
index 000000000000..417099a86742
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include "otx2_cpt_common.h"
+#include "otx2_cptvf.h"
+#include <rvu_reg.h>
+
+irqreturn_t otx2_cptvf_pfvf_mbox_intr(int __always_unused irq, void *arg)
+{
+	struct otx2_cptvf_dev *cptvf = arg;
+	u64 intr;
+
+	/* Read the interrupt bits */
+	intr = otx2_cpt_read64(cptvf->reg_base, BLKADDR_RVUM, 0,
+			       OTX2_RVU_VF_INT);
+
+	if (intr & 0x1ULL) {
+		/* Schedule work queue function to process the MBOX request */
+		queue_work(cptvf->pfvf_mbox_wq, &cptvf->pfvf_mbox_work);
+		/* Clear and ack the interrupt */
+		otx2_cpt_write64(cptvf->reg_base, BLKADDR_RVUM, 0,
+				 OTX2_RVU_VF_INT, 0x1ULL);
+	}
+	return IRQ_HANDLED;
+}
+
+static void process_pfvf_mbox_mbox_msg(struct otx2_cptvf_dev *cptvf,
+				       struct mbox_msghdr *msg)
+{
+	struct otx2_cptlfs_info *lfs = &cptvf->lfs;
+	struct cpt_rd_wr_reg_msg *rsp_reg;
+	struct msix_offset_rsp *rsp_msix;
+	int i;
+
+	if (msg->id >= MBOX_MSG_MAX) {
+		dev_err(&cptvf->pdev->dev,
+			"MBOX msg with unknown ID %d\n", msg->id);
+		return;
+	}
+	if (msg->sig != OTX2_MBOX_RSP_SIG) {
+		dev_err(&cptvf->pdev->dev,
+			"MBOX msg with wrong signature %x, ID %d\n",
+			msg->sig, msg->id);
+		return;
+	}
+	switch (msg->id) {
+	case MBOX_MSG_READY:
+		cptvf->vf_id = ((msg->pcifunc >> RVU_PFVF_FUNC_SHIFT)
+				& RVU_PFVF_FUNC_MASK) - 1;
+		break;
+	case MBOX_MSG_ATTACH_RESOURCES:
+		/* Check if resources were successfully attached */
+		if (!msg->rc)
+			lfs->are_lfs_attached = 1;
+		break;
+	case MBOX_MSG_DETACH_RESOURCES:
+		/* Check if resources were successfully detached */
+		if (!msg->rc)
+			lfs->are_lfs_attached = 0;
+		break;
+	case MBOX_MSG_MSIX_OFFSET:
+		rsp_msix = (struct msix_offset_rsp *) msg;
+		for (i = 0; i < rsp_msix->cptlfs; i++)
+			lfs->lf[i].msix_offset = rsp_msix->cptlf_msixoff[i];
+		break;
+	case MBOX_MSG_CPT_RD_WR_REGISTER:
+		rsp_reg = (struct cpt_rd_wr_reg_msg *) msg;
+		if (msg->rc) {
+			dev_err(&cptvf->pdev->dev,
+				"Reg %llx rd/wr(%d) failed %d\n",
+				rsp_reg->reg_offset, rsp_reg->is_write,
+				msg->rc);
+			return;
+		}
+		if (!rsp_reg->is_write)
+			*rsp_reg->ret_val = rsp_reg->val;
+		break;
+	default:
+		dev_err(&cptvf->pdev->dev, "Unsupported msg %d received.\n",
+			msg->id);
+		break;
+	}
+}
+
+void otx2_cptvf_pfvf_mbox_handler(struct work_struct *work)
+{
+	struct otx2_cptvf_dev *cptvf;
+	struct otx2_mbox *pfvf_mbox;
+	struct otx2_mbox_dev *mdev;
+	struct mbox_hdr *rsp_hdr;
+	struct mbox_msghdr *msg;
+	int offset, i;
+
+	/* sync with mbox memory region */
+	smp_rmb();
+
+	cptvf = container_of(work, struct otx2_cptvf_dev, pfvf_mbox_work);
+	pfvf_mbox = &cptvf->pfvf_mbox;
+	mdev = &pfvf_mbox->dev[0];
+	rsp_hdr = (struct mbox_hdr *)(mdev->mbase + pfvf_mbox->rx_start);
+	if (rsp_hdr->num_msgs == 0)
+		return;
+	offset = ALIGN(sizeof(struct mbox_hdr), MBOX_MSG_ALIGN);
+
+	for (i = 0; i < rsp_hdr->num_msgs; i++) {
+		msg = (struct mbox_msghdr *)(mdev->mbase + pfvf_mbox->rx_start +
+					     offset);
+		process_pfvf_mbox_mbox_msg(cptvf, msg);
+		offset = msg->next_msgoff;
+		mdev->msgs_acked++;
+	}
+	otx2_mbox_reset(pfvf_mbox, 0);
+}
-- 
2.28.0

