Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A790026E5BA
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 21:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgIQT4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 15:56:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55936 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727046AbgIQOs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 10:48:59 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HDOefE011247;
        Thu, 17 Sep 2020 06:29:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=k1txBHXMf7We8V7GDD+JN/IsIsnv7+JVSXRybq6WBOw=;
 b=Cnhf5nBCGGZWo7Ah8lkS96gvqU5q6kA8OwMaLhGHRnDPHXvems91doJc2mkrYCtS/JPJ
 uT4JCQCakmcPWCMwIllH2D0gyDsqUiJnbHOnEQThLavMrzOH1yOpEh8HH4kz+X7Y6SWQ
 WfJ099pmKZrqq5qi/cI4qbbG6BBiOyOSVf33I75Qa8DTRuChwYg9Ce+5rL0c1fKQbvdL
 9ihzX0GvKLEWYpGV5XBN4B3LuyOfJl4r7TRJdUWBWp38TrX8sv7de0iS8I5RDt3ltBsy
 U7UOYcYOn8UEgBZ9zLIYKS+Pjoq5R/qPAspJcUIaJwm3GGffZHnm3vL8spiASMZgxjCP XQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33m73mramt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 06:29:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Sep
 2020 06:29:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Sep 2020 06:29:20 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 14AF23F703F;
        Thu, 17 Sep 2020 06:29:12 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>,
        Lukas Bartosik <lbartosik@marvell.com>
Subject: [PATCH v3,net-next,4/4] drivers: crypto: add the Virtual Function driver for OcteonTX2 CPT
Date:   Thu, 17 Sep 2020 18:58:35 +0530
Message-ID: <20200917132835.28325-5-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200917132835.28325-1-schalla@marvell.com>
References: <20200917132835.28325-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_09:2020-09-16,2020-09-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the cryptographic accelerator unit virtual functions on
OcteonTX2 96XX SoC.

Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Lukas Bartosik <lbartosik@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/Kconfig                |    4 +
 drivers/crypto/marvell/octeontx2/Makefile     |    5 +-
 .../marvell/octeontx2/otx2_cpt_hw_types.h     |    5 +
 .../marvell/octeontx2/otx2_cpt_reqmgr.h       |  121 ++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h |   14 +
 .../marvell/octeontx2/otx2_cptlf_main.c       |  967 ++++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h |    5 +
 .../marvell/octeontx2/otx2_cptvf_algs.c       | 1698 +++++++++++++++++
 .../marvell/octeontx2/otx2_cptvf_algs.h       |  172 ++
 .../marvell/octeontx2/otx2_cptvf_main.c       |  229 +++
 .../marvell/octeontx2/otx2_cptvf_mbox.c       |  189 ++
 .../marvell/octeontx2/otx2_cptvf_reqmgr.c     |  540 ++++++
 12 files changed, 3948 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c

diff --git a/drivers/crypto/marvell/Kconfig b/drivers/crypto/marvell/Kconfig
index 9c4001105cb6..1f118bea077e 100644
--- a/drivers/crypto/marvell/Kconfig
+++ b/drivers/crypto/marvell/Kconfig
@@ -40,8 +40,12 @@ config CRYPTO_DEV_OCTEONTX2_CPT
 	tristate "Support for Marvell OcteonTX2 CPT driver"
 	depends on ARM64 || COMPILE_TEST
 	depends on PCI_MSI && 64BIT
+	depends on CRYPTO_LIB_AES
 	select OCTEONTX2_MBOX
 	select CRYPTO_DEV_MARVELL
+	select CRYPTO_SKCIPHER
+	select CRYPTO_HASH
+	select CRYPTO_AEAD
 	help
 		This driver allows you to utilize the Marvell Cryptographic
 		Accelerator Unit(CPT) found in OcteonTX2 series of processors.
diff --git a/drivers/crypto/marvell/octeontx2/Makefile b/drivers/crypto/marvell/octeontx2/Makefile
index d5d8f962bbb3..e08df488b5a9 100644
--- a/drivers/crypto/marvell/octeontx2/Makefile
+++ b/drivers/crypto/marvell/octeontx2/Makefile
@@ -1,7 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += octeontx2-cpt.o
+obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += octeontx2-cpt.o octeontx2-cptvf.o
 
 octeontx2-cpt-objs := otx2_cptpf_main.o otx2_cptpf_mbox.o otx2_cptpf_ucode.o \
 		      otx2_cpt_mbox_common.o
+octeontx2-cptvf-objs := otx2_cptvf_main.o otx2_cptvf_mbox.o otx2_cptlf_main.o \
+			otx2_cptvf_reqmgr.o otx2_cptvf_algs.o \
+			otx2_cpt_mbox_common.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
index d927f1f0f07f..73d83a19d69b 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
@@ -104,6 +104,11 @@
 #define OTX2_CPT_LMT_LFBASE             BIT_ULL(OTX2_CPT_RVU_FUNC_BLKADDR_SHIFT)
 #define OTX2_CPT_LMT_LF_LMTLINEX(a)     (OTX2_CPT_LMT_LFBASE | 0x000 | \
 					 (a) << 12)
+/* RVU VF registers */
+#define OTX2_RVU_VF_INT                 (0x20)
+#define OTX2_RVU_VF_INT_W1S             (0x28)
+#define OTX2_RVU_VF_INT_ENA_W1S         (0x30)
+#define OTX2_RVU_VF_INT_ENA_W1C         (0x38)
 
 /*
  * Enumeration otx2_cpt_ucode_error_code_e
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
index 1b5f8e272c8d..265d2a38c71c 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
@@ -10,6 +10,22 @@
 /* Completion code size and initial value */
 #define OTX2_CPT_COMPLETION_CODE_SIZE 8
 #define OTX2_CPT_COMPLETION_CODE_INIT OTX2_CPT_COMP_E_NOTDONE
+/*
+ * Maximum total number of SG buffers is 100, we divide it equally
+ * between input and output
+ */
+#define OTX2_CPT_MAX_SG_IN_CNT  50
+#define OTX2_CPT_MAX_SG_OUT_CNT 50
+
+/* DMA mode direct or SG */
+#define OTX2_CPT_DMA_MODE_DIRECT 0
+#define OTX2_CPT_DMA_MODE_SG     1
+
+/* Context source CPTR or DPTR */
+#define OTX2_CPT_FROM_CPTR 0
+#define OTX2_CPT_FROM_DPTR 1
+
+#define OTX2_CPT_MAX_REQ_SIZE 65535
 
 union otx2_cpt_opcode {
 	u16 flags;
@@ -73,4 +89,109 @@ struct otx2_cpt_pending_queue {
 	u32 qlen;		/* Queue length */
 	spinlock_t lock;	/* Queue lock */
 };
+
+struct otx2_cpt_buf_ptr {
+	u8 *vptr;
+	dma_addr_t dma_addr;
+	u16 size;
+};
+
+union otx2_cpt_ctrl_info {
+	u32 flags;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u32 reserved_6_31:26;
+		u32 grp:3;	/* Group bits */
+		u32 dma_mode:2;	/* DMA mode */
+		u32 se_req:1;	/* To SE core */
+#else
+		u32 se_req:1;	/* To SE core */
+		u32 dma_mode:2;	/* DMA mode */
+		u32 grp:3;	/* Group bits */
+		u32 reserved_6_31:26;
+#endif
+	} s;
+};
+
+struct otx2_cpt_req_info {
+	/* Kernel async request callback */
+	void (*callback)(int status, void *arg1, void *arg2);
+	struct crypto_async_request *areq; /* Async request callback arg */
+	struct otx2_cptvf_request req;/* Request information (core specific) */
+	union otx2_cpt_ctrl_info ctrl;/* User control information */
+	struct otx2_cpt_buf_ptr in[OTX2_CPT_MAX_SG_IN_CNT];
+	struct otx2_cpt_buf_ptr out[OTX2_CPT_MAX_SG_OUT_CNT];
+	u8 *iv_out;     /* IV to send back */
+	u16 rlen;	/* Output length */
+	u8 in_cnt;	/* Number of input buffers */
+	u8 out_cnt;	/* Number of output buffers */
+	u8 req_type;	/* Type of request */
+	u8 is_enc;	/* Is a request an encryption request */
+	u8 is_trunc_hmac;/* Is truncated hmac used */
+};
+
+struct otx2_cpt_inst_info {
+	struct otx2_cpt_pending_entry *pentry;
+	struct otx2_cpt_req_info *req;
+	struct pci_dev *pdev;
+	void *completion_addr;
+	u8 *out_buffer;
+	u8 *in_buffer;
+	dma_addr_t dptr_baddr;
+	dma_addr_t rptr_baddr;
+	dma_addr_t comp_baddr;
+	unsigned long time_in;
+	u32 dlen;
+	u32 dma_len;
+	u8 extra_time;
+};
+
+struct otx2_cpt_sglist_component {
+	__be16 len0;
+	__be16 len1;
+	__be16 len2;
+	__be16 len3;
+	__be64 ptr0;
+	__be64 ptr1;
+	__be64 ptr2;
+	__be64 ptr3;
+};
+
+static inline void otx2_cpt_info_destroy(struct pci_dev *pdev,
+					 struct otx2_cpt_inst_info *info)
+{
+	struct otx2_cpt_req_info *req;
+	int i;
+
+	if (info->dptr_baddr)
+		dma_unmap_single(&pdev->dev, info->dptr_baddr,
+				 info->dma_len, DMA_BIDIRECTIONAL);
+
+	if (info->req) {
+		req = info->req;
+		for (i = 0; i < req->out_cnt; i++) {
+			if (req->out[i].dma_addr)
+				dma_unmap_single(&pdev->dev,
+						 req->out[i].dma_addr,
+						 req->out[i].size,
+						 DMA_BIDIRECTIONAL);
+		}
+
+		for (i = 0; i < req->in_cnt; i++) {
+			if (req->in[i].dma_addr)
+				dma_unmap_single(&pdev->dev,
+						 req->in[i].dma_addr,
+						 req->in[i].size,
+						 DMA_BIDIRECTIONAL);
+		}
+	}
+	kzfree(info);
+}
+
+struct otx2_cptlf_wqe;
+int otx2_cpt_get_kcrypto_eng_grp_num(struct pci_dev *pdev);
+int otx2_cpt_do_request(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
+			int cpu_num);
+void otx2_cpt_post_process(struct otx2_cptlf_wqe *wqe);
+
 #endif /* __OTX2_CPT_REQMGR_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
index 353ab5d2cd5b..5dcd552c9aca 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
@@ -44,6 +44,10 @@
 #define OTX2_CPT_QUEUE_HI_PRIO  0x1
 #define OTX2_CPT_QUEUE_LOW_PRIO 0x0
 
+enum otx2_cptlf_state {
+	OTX2_CPTLF_IN_RESET,
+	OTX2_CPTLF_STARTED,
+};
 
 struct otx2_cptlf_sysfs_cfg {
 	char name[OTX2_CPT_NAME_LENGTH];
@@ -339,4 +343,14 @@ static inline void otx2_cpt_send_cmd(union otx2_cpt_inst_s *cptinst,
 
 	} while (!ret);
 }
+
+static inline bool otx2_cptlf_started(struct otx2_cptlfs_info *lfs)
+{
+	return atomic_read(&lfs->state) == OTX2_CPTLF_STARTED;
+}
+
+int otx2_cptvf_lf_init(struct pci_dev *pdev, void __iomem *reg_base,
+		       struct otx2_cptlfs_info *lfs, int lfs_num);
+int otx2_cptvf_lf_shutdown(struct pci_dev *pdev, struct otx2_cptlfs_info *lfs);
+
 #endif /* __OTX2_CPTLF_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptlf_main.c
new file mode 100644
index 000000000000..30c11803f976
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf_main.c
@@ -0,0 +1,967 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include "otx2_cpt_common.h"
+#include "otx2_cpt_reqmgr.h"
+#include "otx2_cptvf_algs.h"
+#include "otx2_cpt_mbox_common.h"
+#include "rvu_reg.h"
+
+#define CPT_TIMER_HOLD 0x03F
+#define CPT_COUNT_HOLD 32
+/* Minimum and maximum values for interrupt coalescing */
+#define CPT_COALESC_MIN_TIME_WAIT  0x0
+#define CPT_COALESC_MAX_TIME_WAIT  ((1<<16)-1)
+#define CPT_COALESC_MIN_NUM_WAIT   0x0
+#define CPT_COALESC_MAX_NUM_WAIT   ((1<<20)-1)
+
+static int cptlf_get_done_time_wait(struct otx2_cptlf_info *lf)
+{
+	union otx2_cptx_lf_done_wait done_wait;
+
+	done_wait.u = otx2_cpt_read64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+				      OTX2_CPT_LF_DONE_WAIT);
+	return done_wait.s.time_wait;
+}
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
+static int cptlf_get_done_num_wait(struct otx2_cptlf_info *lf)
+{
+	union otx2_cptx_lf_done_wait done_wait;
+
+	done_wait.u = otx2_cpt_read64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+				      OTX2_CPT_LF_DONE_WAIT);
+	return done_wait.s.num_wait;
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
+static int cptlf_get_inflight(struct otx2_cptlf_info *lf)
+{
+	union otx2_cptx_lf_inprog lf_inprog;
+
+	lf_inprog.u = otx2_cpt_read64(lf->lfs->reg_base, BLKADDR_CPT0, lf->slot,
+				      OTX2_CPT_LF_INPROG);
+
+	return lf_inprog.s.inflight;
+}
+
+static int cptlf_get_pri(struct pci_dev *pdev, struct otx2_cptlf_info *lf,
+			 int *pri)
+{
+	union otx2_cptx_af_lf_ctrl lf_ctrl;
+	int ret;
+
+	ret = otx2_cpt_read_af_reg(pdev, CPT_AF_LFX_CTL(lf->slot), &lf_ctrl.u);
+	if (ret)
+		return ret;
+
+	*pri = lf_ctrl.s.pri;
+
+	return ret;
+}
+
+static int cptlf_set_pri(struct pci_dev *pdev, struct otx2_cptlf_info *lf,
+			 int pri)
+{
+	union otx2_cptx_af_lf_ctrl lf_ctrl;
+	int ret;
+
+	ret = otx2_cpt_read_af_reg(pdev, CPT_AF_LFX_CTL(lf->slot), &lf_ctrl.u);
+	if (ret)
+		return ret;
+
+	lf_ctrl.s.pri = pri ? 1 : 0;
+
+	ret = otx2_cpt_write_af_reg(pdev, CPT_AF_LFX_CTL(lf->slot), lf_ctrl.u);
+	return ret;
+}
+
+static int cptlf_get_eng_grps_mask(struct pci_dev *pdev,
+				   struct otx2_cptlf_info *lf,
+				   int *eng_grps_mask)
+{
+	union otx2_cptx_af_lf_ctrl lf_ctrl;
+	int ret;
+
+	ret = otx2_cpt_read_af_reg(pdev, CPT_AF_LFX_CTL(lf->slot), &lf_ctrl.u);
+	if (ret)
+		return ret;
+
+	*eng_grps_mask = lf_ctrl.s.grp;
+
+	return ret;
+}
+
+static int cptlf_set_eng_grps_mask(struct pci_dev *pdev,
+				   struct otx2_cptlf_info *lf,
+				   int eng_grps_mask)
+{
+	union otx2_cptx_af_lf_ctrl lf_ctrl;
+	int ret;
+
+	ret = otx2_cpt_read_af_reg(pdev, CPT_AF_LFX_CTL(lf->slot), &lf_ctrl.u);
+	if (ret)
+		return ret;
+
+	lf_ctrl.s.grp = eng_grps_mask;
+
+	ret = otx2_cpt_write_af_reg(pdev, CPT_AF_LFX_CTL(lf->slot), lf_ctrl.u);
+	return ret;
+}
+
+static int cptlf_set_grp_and_pri(struct pci_dev *pdev,
+				 struct otx2_cptlfs_info *lfs,
+				 int eng_grp_mask, int pri)
+{
+	int slot, ret = 0;
+
+	for (slot = 0; slot < lfs->lfs_num; slot++) {
+		ret = cptlf_set_pri(pdev, &lfs->lf[slot], pri);
+		if (ret)
+			return ret;
+
+		ret = cptlf_set_eng_grps_mask(pdev, &lfs->lf[slot],
+					      eng_grp_mask);
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
+static void cptlf_enable_misc_intrs(struct otx2_cptlfs_info *lfs)
+{
+	cptlf_set_misc_intrs(lfs, true);
+}
+
+static void cptlf_disable_misc_intrs(struct otx2_cptlfs_info *lfs)
+{
+	cptlf_set_misc_intrs(lfs, false);
+}
+
+static void cptlf_enable_done_intr(struct otx2_cptlfs_info *lfs)
+{
+	int slot;
+
+	for (slot = 0; slot < lfs->lfs_num; slot++)
+		otx2_cpt_write64(lfs->reg_base, BLKADDR_CPT0, slot,
+				 OTX2_CPT_LF_DONE_INT_ENA_W1S, 0x1);
+}
+
+static void cptlf_disable_done_intr(struct otx2_cptlfs_info *lfs)
+{
+	int slot;
+
+	for (slot = 0; slot < lfs->lfs_num; slot++)
+		otx2_cpt_write64(lfs->reg_base, BLKADDR_CPT0, slot,
+				 OTX2_CPT_LF_DONE_INT_ENA_W1C, 0x1);
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
+static void cptlf_unregister_interrupts(struct otx2_cptlfs_info *lfs)
+{
+	int i, offs;
+
+	for (i = 0; i < lfs->lfs_num; i++) {
+		for (offs = 0; offs < OTX2_CPT_LF_MSIX_VECTORS; offs++) {
+			if (lfs->lf[i].is_irq_reg[offs]) {
+				free_irq(pci_irq_vector(lfs->pdev,
+							lfs->lf[i].msix_offset
+							+ offs),
+							&lfs->lf[i]);
+				lfs->lf[i].is_irq_reg[offs] = false;
+			}
+		}
+	}
+}
+
+static int cptlf_do_register_interrrupts(struct otx2_cptlfs_info *lfs,
+					 int lf_num, int irq_offset,
+					 irq_handler_t handler)
+{
+	int ret;
+
+	ret = request_irq(pci_irq_vector(lfs->pdev, lfs->lf[lf_num].msix_offset
+			  + irq_offset), handler, 0,
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
+static int cptlf_register_interrupts(struct otx2_cptlfs_info *lfs)
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
+	return 0;
+free_irq:
+	cptlf_unregister_interrupts(lfs);
+	return ret;
+}
+
+static void cptlf_free_irqs_affinity(struct otx2_cptlfs_info *lfs)
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
+static int cptlf_set_irqs_affinity(struct otx2_cptlfs_info *lfs)
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
+	cptlf_free_irqs_affinity(lfs);
+	return ret;
+}
+
+static void cptlf_work_handler(unsigned long data)
+{
+	otx2_cpt_post_process((struct otx2_cptlf_wqe *) data);
+}
+
+static void cleanup_tasklet_work(struct otx2_cptlfs_info *lfs)
+{
+	int i;
+
+	for (i = 0; i <  lfs->lfs_num; i++) {
+		if (!lfs->lf[i].wqe)
+			continue;
+
+		tasklet_kill(&lfs->lf[i].wqe->work);
+		kfree(lfs->lf[i].wqe);
+		lfs->lf[i].wqe = NULL;
+	}
+}
+
+static int init_tasklet_work(struct otx2_cptlfs_info *lfs)
+{
+	struct otx2_cptlf_wqe *wqe;
+	int i, ret = 0;
+
+	for (i = 0; i < lfs->lfs_num; i++) {
+		wqe = kzalloc(sizeof(struct otx2_cptlf_wqe), GFP_KERNEL);
+		if (!wqe) {
+			ret = -ENOMEM;
+			goto cleanup_tasklet;
+		}
+
+		tasklet_init(&wqe->work, cptlf_work_handler, (u64) wqe);
+		wqe->lfs = lfs;
+		wqe->lf_num = i;
+		lfs->lf[i].wqe = wqe;
+	}
+	return 0;
+cleanup_tasklet:
+	cleanup_tasklet_work(lfs);
+	return ret;
+}
+
+static void free_pending_queues(struct otx2_cptlfs_info *lfs)
+{
+	int i;
+
+	for (i = 0; i < lfs->lfs_num; i++) {
+		kfree(lfs->lf[i].pqueue.head);
+		lfs->lf[i].pqueue.head = NULL;
+	}
+}
+
+static int alloc_pending_queues(struct otx2_cptlfs_info *lfs)
+{
+	int size, ret, i;
+
+	if (!lfs->lfs_num)
+		return -EINVAL;
+
+	for (i = 0; i < lfs->lfs_num; i++) {
+		lfs->lf[i].pqueue.qlen = OTX2_CPT_INST_QLEN_MSGS;
+		size = lfs->lf[i].pqueue.qlen *
+		       sizeof(struct otx2_cpt_pending_entry);
+
+		lfs->lf[i].pqueue.head = kzalloc(size, GFP_KERNEL);
+		if (!lfs->lf[i].pqueue.head) {
+			ret = -ENOMEM;
+			goto error;
+		}
+
+		/* Initialize spin lock */
+		spin_lock_init(&lfs->lf[i].pqueue.lock);
+	}
+	return 0;
+error:
+	free_pending_queues(lfs);
+	return ret;
+}
+
+static int cptlf_sw_init(struct otx2_cptlfs_info *lfs)
+{
+	int ret;
+
+	ret = otx2_cpt_alloc_instruction_queues(lfs);
+	if (ret) {
+		dev_err(&lfs->pdev->dev,
+			"Allocating instruction queues failed\n");
+		return ret;
+	}
+
+	ret = alloc_pending_queues(lfs);
+	if (ret) {
+		dev_err(&lfs->pdev->dev,
+			"Allocating pending queues failed\n");
+		goto instruction_queues_free;
+	}
+
+	ret = init_tasklet_work(lfs);
+	if (ret) {
+		dev_err(&lfs->pdev->dev,
+			"Tasklet work init failed\n");
+		goto pending_queues_free;
+	}
+	return 0;
+
+pending_queues_free:
+	free_pending_queues(lfs);
+instruction_queues_free:
+	otx2_cpt_free_instruction_queues(lfs);
+	return ret;
+}
+
+static void cptlf_sw_cleanup(struct otx2_cptlfs_info *lfs)
+{
+	cleanup_tasklet_work(lfs);
+	free_pending_queues(lfs);
+	otx2_cpt_free_instruction_queues(lfs);
+}
+
+static ssize_t cptlf_coalesc_time_wait_show(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct otx2_cptlf_sysfs_cfg *cfg;
+	struct otx2_cptlf_info *lf;
+
+	cfg = container_of(attr, struct otx2_cptlf_sysfs_cfg, coalesc_tw_attr);
+	lf = container_of(cfg, struct otx2_cptlf_info, sysfs_cfg);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", cptlf_get_done_time_wait(lf));
+}
+
+static ssize_t cptlf_coalesc_time_wait_store(struct device *dev,
+					     struct device_attribute *attr,
+					     const char *buf, size_t count)
+{
+	struct otx2_cptlf_sysfs_cfg *cfg;
+	struct otx2_cptlf_info *lf;
+	long val;
+	int ret;
+
+	ret = kstrtol(buf, 10, &val);
+	if (ret != 0)
+		return ret;
+
+	if (val < CPT_COALESC_MIN_TIME_WAIT ||
+	    val > CPT_COALESC_MAX_TIME_WAIT)
+		return -EINVAL;
+
+	cfg = container_of(attr, struct otx2_cptlf_sysfs_cfg, coalesc_tw_attr);
+	lf = container_of(cfg, struct otx2_cptlf_info, sysfs_cfg);
+
+	cptlf_do_set_done_time_wait(lf, val);
+	return count;
+}
+
+static ssize_t cptlf_coalesc_num_wait_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct otx2_cptlf_sysfs_cfg *cfg;
+	struct otx2_cptlf_info *lf;
+
+	cfg = container_of(attr, struct otx2_cptlf_sysfs_cfg, coalesc_nw_attr);
+	lf = container_of(cfg, struct otx2_cptlf_info, sysfs_cfg);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", cptlf_get_done_num_wait(lf));
+}
+
+static ssize_t cptlf_coalesc_num_wait_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct otx2_cptlf_sysfs_cfg *cfg;
+	struct otx2_cptlf_info *lf;
+	long val;
+	int ret;
+
+	ret = kstrtol(buf, 10, &val);
+	if (ret != 0)
+		return ret;
+
+	if (val < CPT_COALESC_MIN_NUM_WAIT ||
+	    val > CPT_COALESC_MAX_NUM_WAIT)
+		return -EINVAL;
+
+	cfg = container_of(attr, struct otx2_cptlf_sysfs_cfg, coalesc_nw_attr);
+	lf = container_of(cfg, struct otx2_cptlf_info, sysfs_cfg);
+
+	cptlf_do_set_done_num_wait(lf, val);
+	return count;
+}
+
+static ssize_t cptlf_priority_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct otx2_cptlf_sysfs_cfg *cfg;
+	struct otx2_cptlf_info *lf;
+	struct pci_dev *pdev;
+	int pri, ret;
+
+	cfg = container_of(attr, struct otx2_cptlf_sysfs_cfg, prio_attr);
+	lf = container_of(cfg, struct otx2_cptlf_info, sysfs_cfg);
+	pdev = container_of(dev, struct pci_dev, dev);
+
+	ret = cptlf_get_pri(pdev, lf, &pri);
+	if (ret)
+		return ret;
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", pri);
+}
+
+static ssize_t cptlf_priority_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct otx2_cptlf_sysfs_cfg *cfg;
+	struct otx2_cptlf_info *lf;
+	struct pci_dev *pdev;
+	long val;
+	int ret;
+
+	ret = kstrtol(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	if (val < OTX2_CPT_QUEUE_LOW_PRIO ||
+	    val > OTX2_CPT_QUEUE_HI_PRIO)
+		return -EINVAL;
+
+	cfg = container_of(attr, struct otx2_cptlf_sysfs_cfg, prio_attr);
+	lf = container_of(cfg, struct otx2_cptlf_info, sysfs_cfg);
+	pdev = container_of(dev, struct pci_dev, dev);
+
+	/* Queue's priority can be modified only if queue is quiescent */
+	if (cptlf_get_inflight(lf)) {
+		ret = -EPERM;
+		goto err_print;
+	}
+
+	otx2_cptlf_disable_iqueue_exec(lf);
+
+	if (cptlf_get_inflight(lf)) {
+		ret = -EPERM;
+		otx2_cptlf_enable_iqueue_exec(lf);
+		goto err_print;
+	}
+
+	ret = cptlf_set_pri(pdev, lf, val);
+	if (ret) {
+		otx2_cptlf_enable_iqueue_exec(lf);
+		goto err;
+	}
+
+	otx2_cptlf_enable_iqueue_exec(lf);
+	return count;
+
+err_print:
+	dev_err(&pdev->dev,
+		"Disable traffic before modifying queue's priority");
+err:
+	return ret;
+}
+
+static ssize_t cptlf_eng_grps_mask_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct otx2_cptlf_sysfs_cfg *cfg;
+	struct otx2_cptlf_info *lf;
+	struct pci_dev *pdev;
+	int eng_grps_mask;
+	int ret;
+
+	cfg = container_of(attr, struct otx2_cptlf_sysfs_cfg,
+			   eng_grps_mask_attr);
+	lf = container_of(cfg, struct otx2_cptlf_info, sysfs_cfg);
+	pdev = container_of(dev, struct pci_dev, dev);
+
+	ret = cptlf_get_eng_grps_mask(pdev, lf, &eng_grps_mask);
+	if (ret)
+		return ret;
+
+	return scnprintf(buf, PAGE_SIZE, "0x%2.2X\n", eng_grps_mask);
+}
+
+static ssize_t cptlf_eng_grps_mask_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct otx2_cptlf_sysfs_cfg *cfg;
+	struct otx2_cptlf_info *lf;
+	struct pci_dev *pdev;
+	long val;
+	int ret;
+
+	ret = kstrtol(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	if (val < 1 ||
+	    val > OTX2_CPT_ALL_ENG_GRPS_MASK)
+		return -EINVAL;
+
+	cfg = container_of(attr, struct otx2_cptlf_sysfs_cfg,
+			   eng_grps_mask_attr);
+	lf = container_of(cfg, struct otx2_cptlf_info, sysfs_cfg);
+	pdev = container_of(dev, struct pci_dev, dev);
+
+	/*
+	 * Queue's engine groups mask can be modified only if queue is
+	 * quiescent
+	 */
+	if (cptlf_get_inflight(lf)) {
+		ret = -EPERM;
+		goto err_print;
+	}
+
+	otx2_cptlf_disable_iqueue_exec(lf);
+
+	if (cptlf_get_inflight(lf)) {
+		ret = -EPERM;
+		otx2_cptlf_enable_iqueue_exec(lf);
+		goto err_print;
+	}
+
+	ret = cptlf_set_eng_grps_mask(pdev, lf, val);
+	if (ret) {
+		otx2_cptlf_enable_iqueue_exec(lf);
+		goto err;
+	}
+
+	otx2_cptlf_enable_iqueue_exec(lf);
+	return count;
+
+err_print:
+	dev_err(&pdev->dev,
+		"Disable traffic before modifying queue's engine groups mask");
+err:
+	return ret;
+}
+
+static void cptlf_delete_sysfs_cfg(struct otx2_cptlfs_info *lfs)
+{
+	struct otx2_cptlf_sysfs_cfg *cfg;
+	int i;
+
+	for (i = 0; i < lfs->lfs_num; i++) {
+		cfg = &lfs->lf[i].sysfs_cfg;
+		if (cfg->is_sysfs_grp_created) {
+			sysfs_remove_group(&lfs->pdev->dev.kobj,
+					   &cfg->attr_grp);
+			cfg->is_sysfs_grp_created = false;
+		}
+	}
+}
+
+static int cptlf_create_sysfs_cfg(struct otx2_cptlfs_info *lfs)
+{
+	struct otx2_cptlf_sysfs_cfg *cfg;
+	int i, ret = 0;
+
+	for (i = 0; i < lfs->lfs_num; i++) {
+		cfg = &lfs->lf[i].sysfs_cfg;
+		snprintf(cfg->name, OTX2_CPT_NAME_LENGTH, "cpt_queue%d", i);
+
+		cfg->eng_grps_mask_attr.show = cptlf_eng_grps_mask_show;
+		cfg->eng_grps_mask_attr.store = cptlf_eng_grps_mask_store;
+		cfg->eng_grps_mask_attr.attr.name = "eng_grps_mask";
+		cfg->eng_grps_mask_attr.attr.mode = 0664;
+		sysfs_attr_init(&cfg->eng_grps_mask_attr.attr);
+
+		cfg->coalesc_tw_attr.show = cptlf_coalesc_time_wait_show;
+		cfg->coalesc_tw_attr.store = cptlf_coalesc_time_wait_store;
+		cfg->coalesc_tw_attr.attr.name = "coalescence_time_wait";
+		cfg->coalesc_tw_attr.attr.mode = 0664;
+		sysfs_attr_init(&cfg->coalesc_tw_attr.attr);
+
+		cfg->coalesc_nw_attr.show = cptlf_coalesc_num_wait_show;
+		cfg->coalesc_nw_attr.store = cptlf_coalesc_num_wait_store;
+		cfg->coalesc_nw_attr.attr.name = "coalescence_num_wait";
+		cfg->coalesc_nw_attr.attr.mode = 0664;
+		sysfs_attr_init(&cfg->coalesc_nw_attr.attr);
+
+		cfg->prio_attr.show = cptlf_priority_show;
+		cfg->prio_attr.store = cptlf_priority_store;
+		cfg->prio_attr.attr.name = "priority";
+		cfg->prio_attr.attr.mode = 0664;
+		sysfs_attr_init(&cfg->prio_attr.attr);
+
+		cfg->attrs[0] = &cfg->eng_grps_mask_attr.attr;
+		cfg->attrs[1] = &cfg->coalesc_tw_attr.attr;
+		cfg->attrs[2] = &cfg->coalesc_nw_attr.attr;
+		cfg->attrs[3] = &cfg->prio_attr.attr;
+		cfg->attrs[OTX2_CPT_ATTRS_NUM - 1] = NULL;
+
+		cfg->attr_grp.name = cfg->name;
+		cfg->attr_grp.attrs = cfg->attrs;
+		ret = sysfs_create_group(&lfs->pdev->dev.kobj,
+					 &cfg->attr_grp);
+		if (ret)
+			goto err;
+		cfg->is_sysfs_grp_created = true;
+	}
+
+	return 0;
+err:
+	cptlf_delete_sysfs_cfg(lfs);
+	return ret;
+}
+
+int otx2_cptvf_lf_init(struct pci_dev *pdev, void __iomem *reg_base,
+		       struct otx2_cptlfs_info *lfs, int lfs_num)
+{
+	int slot, ret;
+
+	lfs->reg_base = reg_base;
+	lfs->lfs_num = lfs_num;
+	lfs->pdev = pdev;
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
+
+	/* Send request to attach LFs */
+	ret = otx2_cpt_attach_rscrs_msg(pdev);
+	if (ret)
+		return ret;
+
+	/* Get msix offsets for attached LFs */
+	ret = otx2_cpt_msix_offset_msg(pdev);
+	if (ret)
+		goto detach_rscrs;
+
+	/* Initialize LFs software side */
+	ret = cptlf_sw_init(lfs);
+	if (ret)
+		goto detach_rscrs;
+
+	/* Register LFs interrupts */
+	ret = cptlf_register_interrupts(lfs);
+	if (ret)
+		goto sw_cleanup;
+
+	/* Initialize LFs hardware side */
+	cptlf_hw_init(lfs);
+
+	/*
+	 * Allow each LF to execute requests destined to any of 8 engine
+	 * groups and set queue priority of each LF to high
+	 */
+	ret = cptlf_set_grp_and_pri(pdev, lfs, OTX2_CPT_ALL_ENG_GRPS_MASK,
+				    OTX2_CPT_QUEUE_HI_PRIO);
+	if (ret)
+		goto hw_cleanup;
+
+	/* Create sysfs configuration entries */
+	ret = cptlf_create_sysfs_cfg(lfs);
+	if (ret)
+		goto hw_cleanup;
+
+	/* Set interrupts affinity */
+	ret = cptlf_set_irqs_affinity(lfs);
+	if (ret)
+		goto delete_sysfs_cfg;
+
+	/* Enable interrupts */
+	cptlf_enable_misc_intrs(lfs);
+	cptlf_enable_done_intr(lfs);
+
+	atomic_set(&lfs->state, OTX2_CPTLF_STARTED);
+	/* Register crypto algorithms */
+	ret = otx2_cpt_crypto_init(pdev, THIS_MODULE, OTX2_CPT_SE_TYPES,
+				   lfs_num, 1);
+	if (ret) {
+		dev_err(&pdev->dev, "algorithms registration failed\n");
+		goto disable_irqs;
+	}
+	return 0;
+
+disable_irqs:
+	cptlf_disable_done_intr(lfs);
+	cptlf_disable_misc_intrs(lfs);
+	cptlf_free_irqs_affinity(lfs);
+delete_sysfs_cfg:
+	cptlf_delete_sysfs_cfg(lfs);
+hw_cleanup:
+	cptlf_hw_cleanup(lfs);
+	cptlf_unregister_interrupts(lfs);
+sw_cleanup:
+	cptlf_sw_cleanup(lfs);
+detach_rscrs:
+	otx2_cpt_detach_rsrcs_msg(pdev);
+	atomic_set(&lfs->state, OTX2_CPTLF_IN_RESET);
+
+	return ret;
+}
+
+int otx2_cptvf_lf_shutdown(struct pci_dev *pdev, struct otx2_cptlfs_info *lfs)
+{
+	int ret;
+
+	atomic_set(&lfs->state, OTX2_CPTLF_IN_RESET);
+	/* Remove interrupts affinity */
+	cptlf_free_irqs_affinity(lfs);
+
+	/* Remove sysfs configuration entries */
+	cptlf_delete_sysfs_cfg(lfs);
+
+	/* Cleanup LFs hardware side */
+	cptlf_hw_cleanup(lfs);
+
+	/* Unregister crypto algorithms */
+	otx2_cpt_crypto_exit(pdev, THIS_MODULE, OTX2_CPT_SE_TYPES);
+
+	/* Disable interrupts */
+	cptlf_disable_done_intr(lfs);
+	cptlf_disable_misc_intrs(lfs);
+
+	/* Unregister LFs interrupts */
+	cptlf_unregister_interrupts(lfs);
+
+	/* Cleanup LFs software side */
+	cptlf_sw_cleanup(lfs);
+
+	/* Send request to detach LFs */
+	ret = otx2_cpt_detach_rsrcs_msg(pdev);
+
+	return ret;
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf.h b/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
index 51039c7a7195..6a4d8b5a2dca 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
@@ -21,4 +21,9 @@ struct otx2_cptvf_dev {
 	struct workqueue_struct *pfvf_mbox_wq;
 };
 
+irqreturn_t otx2_cptvf_pfvf_mbox_intr(int irq, void *arg);
+void otx2_cptvf_pfvf_mbox_handler(struct work_struct *work);
+int otx2_cptvf_send_eng_grp_num_msg(struct otx2_cptvf_dev *cptvf, int eng_type);
+int otx2_cptvf_send_kcrypto_limits_msg(struct otx2_cptvf_dev *cptvf);
+
 #endif /* __OTX2_CPTVF_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
new file mode 100644
index 000000000000..f11e9543c5b6
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
@@ -0,0 +1,1698 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include <crypto/aes.h>
+#include <crypto/authenc.h>
+#include <crypto/cryptd.h>
+#include <crypto/des.h>
+#include <crypto/internal/aead.h>
+#include <crypto/sha.h>
+#include <crypto/xts.h>
+#include <crypto/gcm.h>
+#include <crypto/scatterwalk.h>
+#include <linux/rtnetlink.h>
+#include <linux/sort.h>
+#include <linux/module.h>
+#include "otx2_cptvf.h"
+#include "otx2_cptvf_algs.h"
+#include "otx2_cpt_reqmgr.h"
+
+#define CPT_MAX_LF_NUM 64
+/* Size of salt in AES GCM mode */
+#define AES_GCM_SALT_SIZE 4
+/* Size of IV in AES GCM mode */
+#define AES_GCM_IV_SIZE 8
+/* Size of ICV (Integrity Check Value) in AES GCM mode */
+#define AES_GCM_ICV_SIZE 16
+/* Offset of IV in AES GCM mode */
+#define AES_GCM_IV_OFFSET 8
+#define CONTROL_WORD_LEN 8
+#define KEY2_OFFSET 48
+#define DMA_MODE_FLAG(dma_mode) \
+	(((dma_mode) == OTX2_CPT_DMA_MODE_SG) ? (1 << 7) : 0)
+
+/* Truncated SHA digest size */
+#define SHA1_TRUNC_DIGEST_SIZE 12
+#define SHA256_TRUNC_DIGEST_SIZE 16
+#define SHA384_TRUNC_DIGEST_SIZE 24
+#define SHA512_TRUNC_DIGEST_SIZE 32
+
+static DEFINE_MUTEX(mutex);
+static int is_crypto_registered;
+
+struct cpt_device_desc {
+	struct pci_dev *dev;
+	int num_queues;
+};
+
+struct cpt_device_table {
+	atomic_t count;
+	struct cpt_device_desc desc[CPT_MAX_LF_NUM];
+};
+
+static struct cpt_device_table se_devices = {
+	.count = ATOMIC_INIT(0)
+};
+
+static struct cpt_device_table ae_devices = {
+	.count = ATOMIC_INIT(0)
+};
+
+static inline int get_se_device(struct pci_dev **pdev, int *cpu_num)
+{
+	int count;
+
+	count = atomic_read(&se_devices.count);
+	if (count < 1)
+		return -ENODEV;
+
+	*cpu_num = get_cpu();
+	/*
+	 * On OcteonTX2 platform CPT instruction queue is bound to each
+	 * local function LF, in turn LFs can be attached to PF
+	 * or VF therefore we always use first device. We get maximum
+	 * performance if one CPT queue is available for each cpu
+	 * otherwise CPT queues need to be shared between cpus.
+	 */
+	if (*cpu_num >= se_devices.desc[0].num_queues)
+		*cpu_num %= se_devices.desc[0].num_queues;
+	*pdev = se_devices.desc[0].dev;
+
+	put_cpu();
+
+	return 0;
+}
+
+static inline int validate_hmac_cipher_null(struct otx2_cpt_req_info *cpt_req)
+{
+	struct otx2_cpt_req_ctx *rctx;
+	struct aead_request *req;
+	struct crypto_aead *tfm;
+
+	req = container_of(cpt_req->areq, struct aead_request, base);
+	tfm = crypto_aead_reqtfm(req);
+	rctx = aead_request_ctx(req);
+	if (memcmp(rctx->fctx.hmac.s.hmac_calc,
+		   rctx->fctx.hmac.s.hmac_recv,
+		   crypto_aead_authsize(tfm)) != 0)
+		return -EBADMSG;
+
+	return 0;
+}
+
+static void otx2_cpt_aead_callback(int status, void *arg1, void *arg2)
+{
+	struct otx2_cpt_inst_info *inst_info = arg2;
+	struct crypto_async_request *areq = arg1;
+	struct otx2_cpt_req_info *cpt_req;
+	struct pci_dev *pdev;
+
+	if (inst_info) {
+		cpt_req = inst_info->req;
+		if (!status) {
+			/*
+			 * When selected cipher is NULL we need to manually
+			 * verify whether calculated hmac value matches
+			 * received hmac value
+			 */
+			if (cpt_req->req_type ==
+			    OTX2_CPT_AEAD_ENC_DEC_NULL_REQ &&
+			    !cpt_req->is_enc)
+				status = validate_hmac_cipher_null(cpt_req);
+		}
+		pdev = inst_info->pdev;
+		otx2_cpt_info_destroy(pdev, inst_info);
+	}
+	if (areq)
+		areq->complete(areq, status);
+}
+
+static void output_iv_copyback(struct crypto_async_request *areq)
+{
+	struct otx2_cpt_req_info *req_info;
+	struct otx2_cpt_req_ctx *rctx;
+	struct skcipher_request *sreq;
+	struct crypto_skcipher *stfm;
+	struct otx2_cpt_enc_ctx *ctx;
+	u32 start, ivsize;
+
+	sreq = container_of(areq, struct skcipher_request, base);
+	stfm = crypto_skcipher_reqtfm(sreq);
+	ctx = crypto_skcipher_ctx(stfm);
+	if (ctx->cipher_type == OTX2_CPT_AES_CBC ||
+	    ctx->cipher_type == OTX2_CPT_DES3_CBC) {
+		rctx = skcipher_request_ctx(sreq);
+		req_info = &rctx->cpt_req;
+		ivsize = crypto_skcipher_ivsize(stfm);
+		start = sreq->cryptlen - ivsize;
+
+		if (req_info->is_enc) {
+			scatterwalk_map_and_copy(sreq->iv, sreq->dst, start,
+						 ivsize, 0);
+		} else {
+			if (sreq->src != sreq->dst) {
+				scatterwalk_map_and_copy(sreq->iv, sreq->src,
+							 start, ivsize, 0);
+			} else {
+				memcpy(sreq->iv, req_info->iv_out, ivsize);
+				kfree(req_info->iv_out);
+			}
+		}
+	}
+}
+
+static void otx2_cpt_skcipher_callback(int status, void *arg1, void *arg2)
+{
+	struct otx2_cpt_inst_info *inst_info = arg2;
+	struct crypto_async_request *areq = arg1;
+	struct pci_dev *pdev;
+
+	if (areq) {
+		if (!status)
+			output_iv_copyback(areq);
+		if (inst_info) {
+			pdev = inst_info->pdev;
+			otx2_cpt_info_destroy(pdev, inst_info);
+		}
+		areq->complete(areq, status);
+	}
+}
+
+static inline void update_input_data(struct otx2_cpt_req_info *req_info,
+				     struct scatterlist *inp_sg,
+				     u32 nbytes, u32 *argcnt)
+{
+	req_info->req.dlen += nbytes;
+
+	while (nbytes) {
+		u32 len = (nbytes < inp_sg->length) ? nbytes : inp_sg->length;
+		u8 *ptr = sg_virt(inp_sg);
+
+		req_info->in[*argcnt].vptr = (void *)ptr;
+		req_info->in[*argcnt].size = len;
+		nbytes -= len;
+		++(*argcnt);
+		inp_sg = sg_next(inp_sg);
+	}
+}
+
+static inline void update_output_data(struct otx2_cpt_req_info *req_info,
+				      struct scatterlist *outp_sg,
+				      u32 offset, u32 nbytes, u32 *argcnt)
+{
+	u32 len, sg_len;
+	u8 *ptr;
+
+	req_info->rlen += nbytes;
+
+	while (nbytes) {
+		sg_len = outp_sg->length - offset;
+		len = (nbytes < sg_len) ? nbytes : sg_len;
+		ptr = sg_virt(outp_sg);
+
+		req_info->out[*argcnt].vptr = (void *) (ptr + offset);
+		req_info->out[*argcnt].size = len;
+		nbytes -= len;
+		++(*argcnt);
+		offset = 0;
+		outp_sg = sg_next(outp_sg);
+	}
+}
+
+static inline int create_ctx_hdr(struct skcipher_request *req, u32 enc,
+				 u32 *argcnt)
+{
+	struct crypto_skcipher *stfm = crypto_skcipher_reqtfm(req);
+	struct otx2_cpt_req_ctx *rctx = skcipher_request_ctx(req);
+	struct otx2_cpt_enc_ctx *ctx = crypto_skcipher_ctx(stfm);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+	struct otx2_cpt_fc_ctx *fctx = &rctx->fctx;
+	int ivsize = crypto_skcipher_ivsize(stfm);
+	u32 start = req->cryptlen - ivsize;
+	gfp_t flags;
+
+	flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			GFP_KERNEL : GFP_ATOMIC;
+	req_info->ctrl.s.dma_mode = OTX2_CPT_DMA_MODE_SG;
+	req_info->ctrl.s.se_req = 1;
+
+	req_info->req.opcode.s.major = OTX2_CPT_MAJOR_OP_FC |
+				DMA_MODE_FLAG(OTX2_CPT_DMA_MODE_SG);
+	if (enc) {
+		req_info->req.opcode.s.minor = 2;
+	} else {
+		req_info->req.opcode.s.minor = 3;
+		if ((ctx->cipher_type == OTX2_CPT_AES_CBC ||
+		    ctx->cipher_type == OTX2_CPT_DES3_CBC) &&
+		    req->src == req->dst) {
+			req_info->iv_out = kmalloc(ivsize, flags);
+			if (!req_info->iv_out)
+				return -ENOMEM;
+
+			scatterwalk_map_and_copy(req_info->iv_out, req->src,
+						 start, ivsize, 0);
+		}
+	}
+	/* Encryption data length */
+	req_info->req.param1 = req->cryptlen;
+	/* Authentication data length */
+	req_info->req.param2 = 0;
+
+	fctx->enc.enc_ctrl.e.enc_cipher = ctx->cipher_type;
+	fctx->enc.enc_ctrl.e.aes_key = ctx->key_type;
+	fctx->enc.enc_ctrl.e.iv_source = OTX2_CPT_FROM_CPTR;
+
+	if (ctx->cipher_type == OTX2_CPT_AES_XTS)
+		memcpy(fctx->enc.encr_key, ctx->enc_key, ctx->key_len * 2);
+	else
+		memcpy(fctx->enc.encr_key, ctx->enc_key, ctx->key_len);
+
+	memcpy(fctx->enc.encr_iv, req->iv, crypto_skcipher_ivsize(stfm));
+
+	cpu_to_be64s(&fctx->enc.enc_ctrl.u);
+
+	/*
+	 * Storing  Packet Data Information in offset
+	 * Control Word First 8 bytes
+	 */
+	req_info->in[*argcnt].vptr = (u8 *)&rctx->ctrl_word;
+	req_info->in[*argcnt].size = CONTROL_WORD_LEN;
+	req_info->req.dlen += CONTROL_WORD_LEN;
+	++(*argcnt);
+
+	req_info->in[*argcnt].vptr = (u8 *)fctx;
+	req_info->in[*argcnt].size = sizeof(struct otx2_cpt_fc_ctx);
+	req_info->req.dlen += sizeof(struct otx2_cpt_fc_ctx);
+
+	++(*argcnt);
+
+	return 0;
+}
+
+static inline int create_input_list(struct skcipher_request *req, u32 enc,
+				    u32 enc_iv_len)
+{
+	struct otx2_cpt_req_ctx *rctx = skcipher_request_ctx(req);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+	u32 argcnt =  0;
+	int ret;
+
+	ret = create_ctx_hdr(req, enc, &argcnt);
+	if (ret)
+		return ret;
+
+	update_input_data(req_info, req->src, req->cryptlen, &argcnt);
+	req_info->in_cnt = argcnt;
+
+	return 0;
+}
+
+static inline void create_output_list(struct skcipher_request *req,
+				      u32 enc_iv_len)
+{
+	struct otx2_cpt_req_ctx *rctx = skcipher_request_ctx(req);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+	u32 argcnt = 0;
+
+	/*
+	 * OUTPUT Buffer Processing
+	 * AES encryption/decryption output would be
+	 * received in the following format
+	 *
+	 * ------IV--------|------ENCRYPTED/DECRYPTED DATA-----|
+	 * [ 16 Bytes/     [   Request Enc/Dec/ DATA Len AES CBC ]
+	 */
+	update_output_data(req_info, req->dst, 0, req->cryptlen, &argcnt);
+	req_info->out_cnt = argcnt;
+}
+
+static inline int cpt_enc_dec(struct skcipher_request *req, u32 enc)
+{
+	struct crypto_skcipher *stfm = crypto_skcipher_reqtfm(req);
+	struct otx2_cpt_req_ctx *rctx = skcipher_request_ctx(req);
+	struct otx2_cpt_enc_ctx *ctx = crypto_skcipher_ctx(stfm);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+	u32 enc_iv_len = crypto_skcipher_ivsize(stfm);
+	struct pci_dev *pdev;
+	int status, cpu_num;
+
+	if (!req->cryptlen)
+		return 0;
+
+	if (req->cryptlen > OTX2_CPT_MAX_REQ_SIZE ||
+	    !IS_ALIGNED(req->cryptlen, ctx->enc_align_len))
+		return -EINVAL;
+
+	/* Clear control words */
+	rctx->ctrl_word.flags = 0;
+	rctx->fctx.enc.enc_ctrl.u = 0;
+
+	status = create_input_list(req, enc, enc_iv_len);
+	if (status)
+		return status;
+	create_output_list(req, enc_iv_len);
+
+	status = get_se_device(&pdev, &cpu_num);
+	if (status)
+		return status;
+
+	req_info->callback = otx2_cpt_skcipher_callback;
+	req_info->areq = &req->base;
+	req_info->req_type = OTX2_CPT_ENC_DEC_REQ;
+	req_info->is_enc = enc;
+	req_info->is_trunc_hmac = false;
+	req_info->ctrl.s.grp = otx2_cpt_get_kcrypto_eng_grp_num(pdev);
+
+	/*
+	 * We perform an asynchronous send and once
+	 * the request is completed the driver would
+	 * intimate through registered call back functions
+	 */
+	status = otx2_cpt_do_request(pdev, req_info, cpu_num);
+
+	return status;
+}
+
+static int otx2_cpt_skcipher_encrypt(struct skcipher_request *req)
+{
+	return cpt_enc_dec(req, true);
+}
+
+static int otx2_cpt_skcipher_decrypt(struct skcipher_request *req)
+{
+	return cpt_enc_dec(req, false);
+}
+
+static int otx2_cpt_skcipher_xts_setkey(struct crypto_skcipher *tfm,
+				       const u8 *key, u32 keylen)
+{
+	struct otx2_cpt_enc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	const u8 *key2 = key + (keylen / 2);
+	const u8 *key1 = key;
+	int ret;
+
+	ret = xts_check_key(crypto_skcipher_tfm(tfm), key, keylen);
+	if (ret)
+		return ret;
+	ctx->key_len = keylen;
+	ctx->enc_align_len = 1;
+	memcpy(ctx->enc_key, key1, keylen / 2);
+	memcpy(ctx->enc_key + KEY2_OFFSET, key2, keylen / 2);
+	ctx->cipher_type = OTX2_CPT_AES_XTS;
+	switch (ctx->key_len) {
+	case 2 * AES_KEYSIZE_128:
+		ctx->key_type = OTX2_CPT_AES_128_BIT;
+		break;
+	case 2 * AES_KEYSIZE_256:
+		ctx->key_type = OTX2_CPT_AES_256_BIT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int cpt_des_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			  u32 keylen, u8 cipher_type)
+{
+	struct otx2_cpt_enc_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (keylen != DES3_EDE_KEY_SIZE)
+		return -EINVAL;
+
+	ctx->key_len = keylen;
+	ctx->cipher_type = cipher_type;
+	ctx->enc_align_len = 8;
+
+	memcpy(ctx->enc_key, key, keylen);
+
+	return 0;
+}
+
+static int cpt_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			  u32 keylen, u8 cipher_type)
+{
+	struct otx2_cpt_enc_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	switch (keylen) {
+	case AES_KEYSIZE_128:
+		ctx->key_type = OTX2_CPT_AES_128_BIT;
+		break;
+	case AES_KEYSIZE_192:
+		ctx->key_type = OTX2_CPT_AES_192_BIT;
+		break;
+	case AES_KEYSIZE_256:
+		ctx->key_type = OTX2_CPT_AES_256_BIT;
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (cipher_type == OTX2_CPT_AES_CBC || cipher_type == OTX2_CPT_AES_ECB)
+		ctx->enc_align_len = 16;
+	else
+		ctx->enc_align_len = 1;
+
+	ctx->key_len = keylen;
+	ctx->cipher_type = cipher_type;
+
+	memcpy(ctx->enc_key, key, keylen);
+
+	return 0;
+}
+
+static int otx2_cpt_skcipher_cbc_aes_setkey(struct crypto_skcipher *tfm,
+					    const u8 *key, u32 keylen)
+{
+	return cpt_aes_setkey(tfm, key, keylen, OTX2_CPT_AES_CBC);
+}
+
+static int otx2_cpt_skcipher_ecb_aes_setkey(struct crypto_skcipher *tfm,
+					    const u8 *key, u32 keylen)
+{
+	return cpt_aes_setkey(tfm, key, keylen, OTX2_CPT_AES_ECB);
+}
+
+static int otx2_cpt_skcipher_cfb_aes_setkey(struct crypto_skcipher *tfm,
+					    const u8 *key, u32 keylen)
+{
+	return cpt_aes_setkey(tfm, key, keylen, OTX2_CPT_AES_CFB);
+}
+
+static int otx2_cpt_skcipher_cbc_des3_setkey(struct crypto_skcipher *tfm,
+					     const u8 *key, u32 keylen)
+{
+	return cpt_des_setkey(tfm, key, keylen, OTX2_CPT_DES3_CBC);
+}
+
+static int otx2_cpt_skcipher_ecb_des3_setkey(struct crypto_skcipher *tfm,
+					     const u8 *key, u32 keylen)
+{
+	return cpt_des_setkey(tfm, key, keylen, OTX2_CPT_DES3_ECB);
+}
+
+static int otx2_cpt_enc_dec_init(struct crypto_skcipher *tfm)
+{
+	struct otx2_cpt_enc_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	/*
+	 * Additional memory for ablkcipher_request is
+	 * allocated since the cryptd daemon uses
+	 * this memory for request_ctx information
+	 */
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct otx2_cpt_req_ctx) +
+					sizeof(struct skcipher_request));
+
+	return 0;
+}
+
+static int cpt_aead_init(struct crypto_aead *tfm, u8 cipher_type, u8 mac_type)
+{
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	ctx->cipher_type = cipher_type;
+	ctx->mac_type = mac_type;
+
+	/*
+	 * When selected cipher is NULL we use HMAC opcode instead of
+	 * FLEXICRYPTO opcode therefore we don't need to use HASH algorithms
+	 * for calculating ipad and opad
+	 */
+	if (ctx->cipher_type != OTX2_CPT_CIPHER_NULL) {
+		switch (ctx->mac_type) {
+		case OTX2_CPT_SHA1:
+			ctx->hashalg = crypto_alloc_shash("sha1", 0,
+							  CRYPTO_ALG_ASYNC);
+			if (IS_ERR(ctx->hashalg))
+				return PTR_ERR(ctx->hashalg);
+			break;
+
+		case OTX2_CPT_SHA256:
+			ctx->hashalg = crypto_alloc_shash("sha256", 0,
+							  CRYPTO_ALG_ASYNC);
+			if (IS_ERR(ctx->hashalg))
+				return PTR_ERR(ctx->hashalg);
+			break;
+
+		case OTX2_CPT_SHA384:
+			ctx->hashalg = crypto_alloc_shash("sha384", 0,
+							  CRYPTO_ALG_ASYNC);
+			if (IS_ERR(ctx->hashalg))
+				return PTR_ERR(ctx->hashalg);
+			break;
+
+		case OTX2_CPT_SHA512:
+			ctx->hashalg = crypto_alloc_shash("sha512", 0,
+							  CRYPTO_ALG_ASYNC);
+			if (IS_ERR(ctx->hashalg))
+				return PTR_ERR(ctx->hashalg);
+			break;
+		}
+	}
+	switch (ctx->cipher_type) {
+	case OTX2_CPT_AES_CBC:
+	case OTX2_CPT_AES_ECB:
+		ctx->enc_align_len = 16;
+		break;
+	case OTX2_CPT_DES3_CBC:
+	case OTX2_CPT_DES3_ECB:
+		ctx->enc_align_len = 8;
+		break;
+	case OTX2_CPT_AES_GCM:
+	case OTX2_CPT_CIPHER_NULL:
+		ctx->enc_align_len = 1;
+		break;
+	}
+	crypto_aead_set_reqsize(tfm, sizeof(struct otx2_cpt_req_ctx));
+
+	return 0;
+}
+
+static int otx2_cpt_aead_cbc_aes_sha1_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_AES_CBC, OTX2_CPT_SHA1);
+}
+
+static int otx2_cpt_aead_cbc_aes_sha256_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_AES_CBC, OTX2_CPT_SHA256);
+}
+
+static int otx2_cpt_aead_cbc_aes_sha384_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_AES_CBC, OTX2_CPT_SHA384);
+}
+
+static int otx2_cpt_aead_cbc_aes_sha512_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_AES_CBC, OTX2_CPT_SHA512);
+}
+
+static int otx2_cpt_aead_ecb_null_sha1_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_CIPHER_NULL, OTX2_CPT_SHA1);
+}
+
+static int otx2_cpt_aead_ecb_null_sha256_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_CIPHER_NULL, OTX2_CPT_SHA256);
+}
+
+static int otx2_cpt_aead_ecb_null_sha384_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_CIPHER_NULL, OTX2_CPT_SHA384);
+}
+
+static int otx2_cpt_aead_ecb_null_sha512_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_CIPHER_NULL, OTX2_CPT_SHA512);
+}
+
+static int otx2_cpt_aead_gcm_aes_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_AES_GCM, OTX2_CPT_MAC_NULL);
+}
+
+static void otx2_cpt_aead_exit(struct crypto_aead *tfm)
+{
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	kfree(ctx->ipad);
+	kfree(ctx->opad);
+	if (ctx->hashalg)
+		crypto_free_shash(ctx->hashalg);
+	kfree(ctx->sdesc);
+}
+
+static int otx2_cpt_aead_gcm_set_authsize(struct crypto_aead *tfm,
+					  unsigned int authsize)
+{
+	if (crypto_rfc4106_check_authsize(authsize))
+		return -EINVAL;
+
+	tfm->authsize = authsize;
+	return 0;
+}
+
+static int otx2_cpt_aead_set_authsize(struct crypto_aead *tfm,
+				      unsigned int authsize)
+{
+	tfm->authsize = authsize;
+
+	return 0;
+}
+
+static int otx2_cpt_aead_null_set_authsize(struct crypto_aead *tfm,
+					   unsigned int authsize)
+{
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	ctx->is_trunc_hmac = true;
+	tfm->authsize = authsize;
+
+	return 0;
+}
+
+static struct otx2_cpt_sdesc *alloc_sdesc(struct crypto_shash *alg)
+{
+	struct otx2_cpt_sdesc *sdesc;
+	int size;
+
+	size = sizeof(struct shash_desc) + crypto_shash_descsize(alg);
+	sdesc = kmalloc(size, GFP_KERNEL);
+	if (!sdesc)
+		return NULL;
+
+	sdesc->shash.tfm = alg;
+
+	return sdesc;
+}
+
+static inline void swap_data32(void *buf, u32 len)
+{
+	cpu_to_be32_array(buf, buf, len / 4);
+}
+
+static inline void swap_data64(void *buf, u32 len)
+{
+	u64 *src = buf;
+	int i = 0;
+
+	for (i = 0 ; i < len / 8; i++, src++)
+		cpu_to_be64s(src);
+}
+
+static int copy_pad(u8 mac_type, u8 *out_pad, u8 *in_pad)
+{
+	struct sha512_state *sha512;
+	struct sha256_state *sha256;
+	struct sha1_state *sha1;
+
+	switch (mac_type) {
+	case OTX2_CPT_SHA1:
+		sha1 = (struct sha1_state *) in_pad;
+		swap_data32(sha1->state, SHA1_DIGEST_SIZE);
+		memcpy(out_pad, &sha1->state, SHA1_DIGEST_SIZE);
+		break;
+
+	case OTX2_CPT_SHA256:
+		sha256 = (struct sha256_state *) in_pad;
+		swap_data32(sha256->state, SHA256_DIGEST_SIZE);
+		memcpy(out_pad, &sha256->state, SHA256_DIGEST_SIZE);
+		break;
+
+	case OTX2_CPT_SHA384:
+	case OTX2_CPT_SHA512:
+		sha512 = (struct sha512_state *) in_pad;
+		swap_data64(sha512->state, SHA512_DIGEST_SIZE);
+		memcpy(out_pad, &sha512->state, SHA512_DIGEST_SIZE);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int aead_hmac_init(struct crypto_aead *cipher)
+{
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(cipher);
+	int state_size = crypto_shash_statesize(ctx->hashalg);
+	int ds = crypto_shash_digestsize(ctx->hashalg);
+	int bs = crypto_shash_blocksize(ctx->hashalg);
+	int authkeylen = ctx->auth_key_len;
+	u8 *ipad = NULL, *opad = NULL;
+	int ret = 0, icount = 0;
+
+	ctx->sdesc = alloc_sdesc(ctx->hashalg);
+	if (!ctx->sdesc)
+		return -ENOMEM;
+
+	ctx->ipad = kzalloc(bs, GFP_KERNEL);
+	if (!ctx->ipad) {
+		ret = -ENOMEM;
+		goto calc_fail;
+	}
+
+	ctx->opad = kzalloc(bs, GFP_KERNEL);
+	if (!ctx->opad) {
+		ret = -ENOMEM;
+		goto calc_fail;
+	}
+
+	ipad = kzalloc(state_size, GFP_KERNEL);
+	if (!ipad) {
+		ret = -ENOMEM;
+		goto calc_fail;
+	}
+
+	opad = kzalloc(state_size, GFP_KERNEL);
+	if (!opad) {
+		ret = -ENOMEM;
+		goto calc_fail;
+	}
+
+	if (authkeylen > bs) {
+		ret = crypto_shash_digest(&ctx->sdesc->shash, ctx->key,
+					  authkeylen, ipad);
+		if (ret)
+			goto calc_fail;
+
+		authkeylen = ds;
+	} else {
+		memcpy(ipad, ctx->key, authkeylen);
+	}
+
+	memset(ipad + authkeylen, 0, bs - authkeylen);
+	memcpy(opad, ipad, bs);
+
+	for (icount = 0; icount < bs; icount++) {
+		ipad[icount] ^= 0x36;
+		opad[icount] ^= 0x5c;
+	}
+
+	/*
+	 * Partial Hash calculated from the software
+	 * algorithm is retrieved for IPAD & OPAD
+	 */
+
+	/* IPAD Calculation */
+	crypto_shash_init(&ctx->sdesc->shash);
+	crypto_shash_update(&ctx->sdesc->shash, ipad, bs);
+	crypto_shash_export(&ctx->sdesc->shash, ipad);
+	ret = copy_pad(ctx->mac_type, ctx->ipad, ipad);
+	if (ret)
+		goto calc_fail;
+
+	/* OPAD Calculation */
+	crypto_shash_init(&ctx->sdesc->shash);
+	crypto_shash_update(&ctx->sdesc->shash, opad, bs);
+	crypto_shash_export(&ctx->sdesc->shash, opad);
+	ret = copy_pad(ctx->mac_type, ctx->opad, opad);
+	if (ret)
+		goto calc_fail;
+
+	kfree(ipad);
+	kfree(opad);
+
+	return 0;
+
+calc_fail:
+	kfree(ctx->ipad);
+	ctx->ipad = NULL;
+	kfree(ctx->opad);
+	ctx->opad = NULL;
+	kfree(ipad);
+	kfree(opad);
+	kfree(ctx->sdesc);
+	ctx->sdesc = NULL;
+
+	return ret;
+}
+
+static int otx2_cpt_aead_cbc_aes_sha_setkey(struct crypto_aead *cipher,
+					    const unsigned char *key,
+					    unsigned int keylen)
+{
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(cipher);
+	struct crypto_authenc_key_param *param;
+	int enckeylen = 0, authkeylen = 0;
+	struct rtattr *rta = (void *)key;
+	int status;
+
+	if (!RTA_OK(rta, keylen))
+		return -EINVAL;
+
+	if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
+		return -EINVAL;
+
+	if (RTA_PAYLOAD(rta) < sizeof(*param))
+		return -EINVAL;
+
+	param = RTA_DATA(rta);
+	enckeylen = be32_to_cpu(param->enckeylen);
+	key += RTA_ALIGN(rta->rta_len);
+	keylen -= RTA_ALIGN(rta->rta_len);
+	if (keylen < enckeylen)
+		return -EINVAL;
+
+	if (keylen > OTX2_CPT_MAX_KEY_SIZE)
+		return -EINVAL;
+
+	authkeylen = keylen - enckeylen;
+	memcpy(ctx->key, key, keylen);
+
+	switch (enckeylen) {
+	case AES_KEYSIZE_128:
+		ctx->key_type = OTX2_CPT_AES_128_BIT;
+		break;
+	case AES_KEYSIZE_192:
+		ctx->key_type = OTX2_CPT_AES_192_BIT;
+		break;
+	case AES_KEYSIZE_256:
+		ctx->key_type = OTX2_CPT_AES_256_BIT;
+		break;
+	default:
+		/* Invalid key length */
+		return -EINVAL;
+	}
+
+	ctx->enc_key_len = enckeylen;
+	ctx->auth_key_len = authkeylen;
+
+	status = aead_hmac_init(cipher);
+	if (status)
+		return status;
+
+	return 0;
+}
+
+static int otx2_cpt_aead_ecb_null_sha_setkey(struct crypto_aead *cipher,
+					     const unsigned char *key,
+					     unsigned int keylen)
+{
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(cipher);
+	struct crypto_authenc_key_param *param;
+	struct rtattr *rta = (void *)key;
+	int enckeylen = 0;
+
+	if (!RTA_OK(rta, keylen))
+		return -EINVAL;
+
+	if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
+		return -EINVAL;
+
+	if (RTA_PAYLOAD(rta) < sizeof(*param))
+		return -EINVAL;
+
+	param = RTA_DATA(rta);
+	enckeylen = be32_to_cpu(param->enckeylen);
+	key += RTA_ALIGN(rta->rta_len);
+	keylen -= RTA_ALIGN(rta->rta_len);
+	if (enckeylen != 0)
+		return -EINVAL;
+
+	if (keylen > OTX2_CPT_MAX_KEY_SIZE)
+		return -EINVAL;
+
+	memcpy(ctx->key, key, keylen);
+	ctx->enc_key_len = enckeylen;
+	ctx->auth_key_len = keylen;
+
+	return 0;
+}
+
+static int otx2_cpt_aead_gcm_aes_setkey(struct crypto_aead *cipher,
+					const unsigned char *key,
+					unsigned int keylen)
+{
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(cipher);
+
+	/*
+	 * For aes gcm we expect to get encryption key (16, 24, 32 bytes)
+	 * and salt (4 bytes)
+	 */
+	switch (keylen) {
+	case AES_KEYSIZE_128 + AES_GCM_SALT_SIZE:
+		ctx->key_type = OTX2_CPT_AES_128_BIT;
+		ctx->enc_key_len = AES_KEYSIZE_128;
+		break;
+	case AES_KEYSIZE_192 + AES_GCM_SALT_SIZE:
+		ctx->key_type = OTX2_CPT_AES_192_BIT;
+		ctx->enc_key_len = AES_KEYSIZE_192;
+		break;
+	case AES_KEYSIZE_256 + AES_GCM_SALT_SIZE:
+		ctx->key_type = OTX2_CPT_AES_256_BIT;
+		ctx->enc_key_len = AES_KEYSIZE_256;
+		break;
+	default:
+		/* Invalid key and salt length */
+		return -EINVAL;
+	}
+
+	/* Store encryption key and salt */
+	memcpy(ctx->key, key, keylen);
+
+	return 0;
+}
+
+static inline int create_aead_ctx_hdr(struct aead_request *req, u32 enc,
+				      u32 *argcnt)
+{
+	struct otx2_cpt_req_ctx *rctx = aead_request_ctx(req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+	struct otx2_cpt_fc_ctx *fctx = &rctx->fctx;
+	int mac_len = crypto_aead_authsize(tfm);
+	int ds;
+
+	rctx->ctrl_word.e.enc_data_offset = req->assoclen;
+
+	switch (ctx->cipher_type) {
+	case OTX2_CPT_AES_CBC:
+		if (req->assoclen > 248 || !IS_ALIGNED(req->assoclen, 8))
+			return -EINVAL;
+
+		fctx->enc.enc_ctrl.e.iv_source = OTX2_CPT_FROM_CPTR;
+		/* Copy encryption key to context */
+		memcpy(fctx->enc.encr_key, ctx->key + ctx->auth_key_len,
+		       ctx->enc_key_len);
+		/* Copy IV to context */
+		memcpy(fctx->enc.encr_iv, req->iv, crypto_aead_ivsize(tfm));
+
+		ds = crypto_shash_digestsize(ctx->hashalg);
+		if (ctx->mac_type == OTX2_CPT_SHA384)
+			ds = SHA512_DIGEST_SIZE;
+		if (ctx->ipad)
+			memcpy(fctx->hmac.e.ipad, ctx->ipad, ds);
+		if (ctx->opad)
+			memcpy(fctx->hmac.e.opad, ctx->opad, ds);
+		break;
+
+	case OTX2_CPT_AES_GCM:
+		if (crypto_ipsec_check_assoclen(req->assoclen))
+			return -EINVAL;
+
+		fctx->enc.enc_ctrl.e.iv_source = OTX2_CPT_FROM_DPTR;
+		/* Copy encryption key to context */
+		memcpy(fctx->enc.encr_key, ctx->key, ctx->enc_key_len);
+		/* Copy salt to context */
+		memcpy(fctx->enc.encr_iv, ctx->key + ctx->enc_key_len,
+		       AES_GCM_SALT_SIZE);
+
+		rctx->ctrl_word.e.iv_offset = req->assoclen - AES_GCM_IV_OFFSET;
+		break;
+
+	default:
+		/* Unknown cipher type */
+		return -EINVAL;
+	}
+	cpu_to_be64s(&rctx->ctrl_word.flags);
+
+	req_info->ctrl.s.dma_mode = OTX2_CPT_DMA_MODE_SG;
+	req_info->ctrl.s.se_req = 1;
+	req_info->req.opcode.s.major = OTX2_CPT_MAJOR_OP_FC |
+				 DMA_MODE_FLAG(OTX2_CPT_DMA_MODE_SG);
+	if (enc) {
+		req_info->req.opcode.s.minor = 2;
+		req_info->req.param1 = req->cryptlen;
+		req_info->req.param2 = req->cryptlen + req->assoclen;
+	} else {
+		req_info->req.opcode.s.minor = 3;
+		req_info->req.param1 = req->cryptlen - mac_len;
+		req_info->req.param2 = req->cryptlen + req->assoclen - mac_len;
+	}
+
+	fctx->enc.enc_ctrl.e.enc_cipher = ctx->cipher_type;
+	fctx->enc.enc_ctrl.e.aes_key = ctx->key_type;
+	fctx->enc.enc_ctrl.e.mac_type = ctx->mac_type;
+	fctx->enc.enc_ctrl.e.mac_len = mac_len;
+	cpu_to_be64s(&fctx->enc.enc_ctrl.u);
+
+	/*
+	 * Storing Packet Data Information in offset
+	 * Control Word First 8 bytes
+	 */
+	req_info->in[*argcnt].vptr = (u8 *)&rctx->ctrl_word;
+	req_info->in[*argcnt].size = CONTROL_WORD_LEN;
+	req_info->req.dlen += CONTROL_WORD_LEN;
+	++(*argcnt);
+
+	req_info->in[*argcnt].vptr = (u8 *)fctx;
+	req_info->in[*argcnt].size = sizeof(struct otx2_cpt_fc_ctx);
+	req_info->req.dlen += sizeof(struct otx2_cpt_fc_ctx);
+	++(*argcnt);
+
+	return 0;
+}
+
+static inline void create_hmac_ctx_hdr(struct aead_request *req, u32 *argcnt,
+				      u32 enc)
+{
+	struct otx2_cpt_req_ctx *rctx = aead_request_ctx(req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+
+	req_info->ctrl.s.dma_mode = OTX2_CPT_DMA_MODE_SG;
+	req_info->ctrl.s.se_req = 1;
+	req_info->req.opcode.s.major = OTX2_CPT_MAJOR_OP_HMAC |
+				 DMA_MODE_FLAG(OTX2_CPT_DMA_MODE_SG);
+	req_info->is_trunc_hmac = ctx->is_trunc_hmac;
+
+	req_info->req.opcode.s.minor = 0;
+	req_info->req.param1 = ctx->auth_key_len;
+	req_info->req.param2 = ctx->mac_type << 8;
+
+	/* Add authentication key */
+	req_info->in[*argcnt].vptr = ctx->key;
+	req_info->in[*argcnt].size = round_up(ctx->auth_key_len, 8);
+	req_info->req.dlen += round_up(ctx->auth_key_len, 8);
+	++(*argcnt);
+}
+
+static inline int create_aead_input_list(struct aead_request *req, u32 enc)
+{
+	struct otx2_cpt_req_ctx *rctx = aead_request_ctx(req);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+	u32 inputlen =  req->cryptlen + req->assoclen;
+	u32 status, argcnt = 0;
+
+	status = create_aead_ctx_hdr(req, enc, &argcnt);
+	if (status)
+		return status;
+	update_input_data(req_info, req->src, inputlen, &argcnt);
+	req_info->in_cnt = argcnt;
+
+	return 0;
+}
+
+static inline void create_aead_output_list(struct aead_request *req, u32 enc,
+					   u32 mac_len)
+{
+	struct otx2_cpt_req_ctx *rctx = aead_request_ctx(req);
+	struct otx2_cpt_req_info *req_info =  &rctx->cpt_req;
+	u32 argcnt = 0, outputlen = 0;
+
+	if (enc)
+		outputlen = req->cryptlen +  req->assoclen + mac_len;
+	else
+		outputlen = req->cryptlen + req->assoclen - mac_len;
+
+	update_output_data(req_info, req->dst, 0, outputlen, &argcnt);
+	req_info->out_cnt = argcnt;
+}
+
+static inline void create_aead_null_input_list(struct aead_request *req,
+					       u32 enc, u32 mac_len)
+{
+	struct otx2_cpt_req_ctx *rctx = aead_request_ctx(req);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+	u32 inputlen, argcnt = 0;
+
+	if (enc)
+		inputlen =  req->cryptlen + req->assoclen;
+	else
+		inputlen =  req->cryptlen + req->assoclen - mac_len;
+
+	create_hmac_ctx_hdr(req, &argcnt, enc);
+	update_input_data(req_info, req->src, inputlen, &argcnt);
+	req_info->in_cnt = argcnt;
+}
+
+static inline int create_aead_null_output_list(struct aead_request *req,
+					       u32 enc, u32 mac_len)
+{
+	struct otx2_cpt_req_ctx *rctx = aead_request_ctx(req);
+	struct otx2_cpt_req_info *req_info =  &rctx->cpt_req;
+	struct scatterlist *dst;
+	u8 *ptr = NULL;
+	int argcnt = 0, status, offset;
+	u32 inputlen;
+
+	if (enc)
+		inputlen =  req->cryptlen + req->assoclen;
+	else
+		inputlen =  req->cryptlen + req->assoclen - mac_len;
+
+	/*
+	 * If source and destination are different
+	 * then copy payload to destination
+	 */
+	if (req->src != req->dst) {
+
+		ptr = kmalloc(inputlen, (req_info->areq->flags &
+					 CRYPTO_TFM_REQ_MAY_SLEEP) ?
+					 GFP_KERNEL : GFP_ATOMIC);
+		if (!ptr)
+			return -ENOMEM;
+
+		status = sg_copy_to_buffer(req->src, sg_nents(req->src), ptr,
+					   inputlen);
+		if (status != inputlen) {
+			status = -EINVAL;
+			goto error_free;
+		}
+		status = sg_copy_from_buffer(req->dst, sg_nents(req->dst), ptr,
+					     inputlen);
+		if (status != inputlen) {
+			status = -EINVAL;
+			goto error_free;
+		}
+		kfree(ptr);
+	}
+
+	if (enc) {
+		/*
+		 * In an encryption scenario hmac needs
+		 * to be appended after payload
+		 */
+		dst = req->dst;
+		offset = inputlen;
+		while (offset >= dst->length) {
+			offset -= dst->length;
+			dst = sg_next(dst);
+			if (!dst)
+				return -ENOENT;
+		}
+
+		update_output_data(req_info, dst, offset, mac_len, &argcnt);
+	} else {
+		/*
+		 * In a decryption scenario calculated hmac for received
+		 * payload needs to be compare with hmac received
+		 */
+		status = sg_copy_buffer(req->src, sg_nents(req->src),
+					rctx->fctx.hmac.s.hmac_recv, mac_len,
+					inputlen, true);
+		if (status != mac_len)
+			return -EINVAL;
+
+		req_info->out[argcnt].vptr = rctx->fctx.hmac.s.hmac_calc;
+		req_info->out[argcnt].size = mac_len;
+		argcnt++;
+	}
+
+	req_info->out_cnt = argcnt;
+	return 0;
+
+error_free:
+	kfree(ptr);
+	return status;
+}
+
+static int cpt_aead_enc_dec(struct aead_request *req, u8 reg_type, u8 enc)
+{
+	struct otx2_cpt_req_ctx *rctx = aead_request_ctx(req);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct pci_dev *pdev;
+	int status, cpu_num;
+
+	/* Clear control words */
+	rctx->ctrl_word.flags = 0;
+	rctx->fctx.enc.enc_ctrl.u = 0;
+
+	req_info->callback = otx2_cpt_aead_callback;
+	req_info->areq = &req->base;
+	req_info->req_type = reg_type;
+	req_info->is_enc = enc;
+	req_info->is_trunc_hmac = false;
+
+	switch (reg_type) {
+	case OTX2_CPT_AEAD_ENC_DEC_REQ:
+		status = create_aead_input_list(req, enc);
+		if (status)
+			return status;
+		create_aead_output_list(req, enc, crypto_aead_authsize(tfm));
+		break;
+
+	case OTX2_CPT_AEAD_ENC_DEC_NULL_REQ:
+		create_aead_null_input_list(req, enc,
+					    crypto_aead_authsize(tfm));
+		status = create_aead_null_output_list(req, enc,
+						crypto_aead_authsize(tfm));
+		if (status)
+			return status;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+	if (!req_info->req.param1 ||
+	    (req_info->req.param1 > OTX2_CPT_MAX_REQ_SIZE) ||
+	    (req_info->req.param2 > OTX2_CPT_MAX_REQ_SIZE) ||
+	    !IS_ALIGNED(req_info->req.param1, ctx->enc_align_len))
+		return -EINVAL;
+
+	status = get_se_device(&pdev, &cpu_num);
+	if (status)
+		return status;
+
+	req_info->ctrl.s.grp = otx2_cpt_get_kcrypto_eng_grp_num(pdev);
+
+	/*
+	 * We perform an asynchronous send and once
+	 * the request is completed the driver would
+	 * intimate through registered call back functions
+	 */
+	status = otx2_cpt_do_request(pdev, req_info, cpu_num);
+
+	return status;
+}
+
+static int otx2_cpt_aead_encrypt(struct aead_request *req)
+{
+	return cpt_aead_enc_dec(req, OTX2_CPT_AEAD_ENC_DEC_REQ, true);
+}
+
+static int otx2_cpt_aead_decrypt(struct aead_request *req)
+{
+	return cpt_aead_enc_dec(req, OTX2_CPT_AEAD_ENC_DEC_REQ, false);
+}
+
+static int otx2_cpt_aead_null_encrypt(struct aead_request *req)
+{
+	return cpt_aead_enc_dec(req, OTX2_CPT_AEAD_ENC_DEC_NULL_REQ, true);
+}
+
+static int otx2_cpt_aead_null_decrypt(struct aead_request *req)
+{
+	return cpt_aead_enc_dec(req, OTX2_CPT_AEAD_ENC_DEC_NULL_REQ, false);
+}
+
+static struct skcipher_alg otx2_cpt_skciphers[] = { {
+	.base.cra_name = "xts(aes)",
+	.base.cra_driver_name = "cpt_xts_aes",
+	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize = AES_BLOCK_SIZE,
+	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
+	.base.cra_alignmask = 7,
+	.base.cra_priority = 4001,
+	.base.cra_module = THIS_MODULE,
+
+	.init = otx2_cpt_enc_dec_init,
+	.ivsize = AES_BLOCK_SIZE,
+	.min_keysize = 2 * AES_MIN_KEY_SIZE,
+	.max_keysize = 2 * AES_MAX_KEY_SIZE,
+	.setkey = otx2_cpt_skcipher_xts_setkey,
+	.encrypt = otx2_cpt_skcipher_encrypt,
+	.decrypt = otx2_cpt_skcipher_decrypt,
+}, {
+	.base.cra_name = "cbc(aes)",
+	.base.cra_driver_name = "cpt_cbc_aes",
+	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize = AES_BLOCK_SIZE,
+	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
+	.base.cra_alignmask = 7,
+	.base.cra_priority = 4001,
+	.base.cra_module = THIS_MODULE,
+
+	.init = otx2_cpt_enc_dec_init,
+	.ivsize = AES_BLOCK_SIZE,
+	.min_keysize = AES_MIN_KEY_SIZE,
+	.max_keysize = AES_MAX_KEY_SIZE,
+	.setkey = otx2_cpt_skcipher_cbc_aes_setkey,
+	.encrypt = otx2_cpt_skcipher_encrypt,
+	.decrypt = otx2_cpt_skcipher_decrypt,
+}, {
+	.base.cra_name = "ecb(aes)",
+	.base.cra_driver_name = "cpt_ecb_aes",
+	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize = AES_BLOCK_SIZE,
+	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
+	.base.cra_alignmask = 7,
+	.base.cra_priority = 4001,
+	.base.cra_module = THIS_MODULE,
+
+	.init = otx2_cpt_enc_dec_init,
+	.ivsize = 0,
+	.min_keysize = AES_MIN_KEY_SIZE,
+	.max_keysize = AES_MAX_KEY_SIZE,
+	.setkey = otx2_cpt_skcipher_ecb_aes_setkey,
+	.encrypt = otx2_cpt_skcipher_encrypt,
+	.decrypt = otx2_cpt_skcipher_decrypt,
+}, {
+	.base.cra_name = "cfb(aes)",
+	.base.cra_driver_name = "cpt_cfb_aes",
+	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize = 1,
+	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
+	.base.cra_alignmask = 7,
+	.base.cra_priority = 4001,
+	.base.cra_module = THIS_MODULE,
+
+	.init = otx2_cpt_enc_dec_init,
+	.ivsize = AES_BLOCK_SIZE,
+	.min_keysize = AES_MIN_KEY_SIZE,
+	.max_keysize = AES_MAX_KEY_SIZE,
+	.setkey = otx2_cpt_skcipher_cfb_aes_setkey,
+	.encrypt = otx2_cpt_skcipher_encrypt,
+	.decrypt = otx2_cpt_skcipher_decrypt,
+}, {
+	.base.cra_name = "cbc(des3_ede)",
+	.base.cra_driver_name = "cpt_cbc_des3_ede",
+	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
+	.base.cra_alignmask = 7,
+	.base.cra_priority = 4001,
+	.base.cra_module = THIS_MODULE,
+
+	.init = otx2_cpt_enc_dec_init,
+	.min_keysize = DES3_EDE_KEY_SIZE,
+	.max_keysize = DES3_EDE_KEY_SIZE,
+	.ivsize = DES_BLOCK_SIZE,
+	.setkey = otx2_cpt_skcipher_cbc_des3_setkey,
+	.encrypt = otx2_cpt_skcipher_encrypt,
+	.decrypt = otx2_cpt_skcipher_decrypt,
+}, {
+	.base.cra_name = "ecb(des3_ede)",
+	.base.cra_driver_name = "cpt_ecb_des3_ede",
+	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
+	.base.cra_alignmask = 7,
+	.base.cra_priority = 4001,
+	.base.cra_module = THIS_MODULE,
+
+	.init = otx2_cpt_enc_dec_init,
+	.min_keysize = DES3_EDE_KEY_SIZE,
+	.max_keysize = DES3_EDE_KEY_SIZE,
+	.ivsize = 0,
+	.setkey = otx2_cpt_skcipher_ecb_des3_setkey,
+	.encrypt = otx2_cpt_skcipher_encrypt,
+	.decrypt = otx2_cpt_skcipher_decrypt,
+} };
+
+static struct aead_alg otx2_cpt_aeads[] = { {
+	.base = {
+		.cra_name = "authenc(hmac(sha1),cbc(aes))",
+		.cra_driver_name = "cpt_hmac_sha1_cbc_aes",
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_cbc_aes_sha1_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_cbc_aes_sha_setkey,
+	.setauthsize = otx2_cpt_aead_set_authsize,
+	.encrypt = otx2_cpt_aead_encrypt,
+	.decrypt = otx2_cpt_aead_decrypt,
+	.ivsize = AES_BLOCK_SIZE,
+	.maxauthsize = SHA1_DIGEST_SIZE,
+}, {
+	.base = {
+		.cra_name = "authenc(hmac(sha256),cbc(aes))",
+		.cra_driver_name = "cpt_hmac_sha256_cbc_aes",
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_cbc_aes_sha256_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_cbc_aes_sha_setkey,
+	.setauthsize = otx2_cpt_aead_set_authsize,
+	.encrypt = otx2_cpt_aead_encrypt,
+	.decrypt = otx2_cpt_aead_decrypt,
+	.ivsize = AES_BLOCK_SIZE,
+	.maxauthsize = SHA256_DIGEST_SIZE,
+}, {
+	.base = {
+		.cra_name = "authenc(hmac(sha384),cbc(aes))",
+		.cra_driver_name = "cpt_hmac_sha384_cbc_aes",
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_cbc_aes_sha384_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_cbc_aes_sha_setkey,
+	.setauthsize = otx2_cpt_aead_set_authsize,
+	.encrypt = otx2_cpt_aead_encrypt,
+	.decrypt = otx2_cpt_aead_decrypt,
+	.ivsize = AES_BLOCK_SIZE,
+	.maxauthsize = SHA384_DIGEST_SIZE,
+}, {
+	.base = {
+		.cra_name = "authenc(hmac(sha512),cbc(aes))",
+		.cra_driver_name = "cpt_hmac_sha512_cbc_aes",
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_cbc_aes_sha512_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_cbc_aes_sha_setkey,
+	.setauthsize = otx2_cpt_aead_set_authsize,
+	.encrypt = otx2_cpt_aead_encrypt,
+	.decrypt = otx2_cpt_aead_decrypt,
+	.ivsize = AES_BLOCK_SIZE,
+	.maxauthsize = SHA512_DIGEST_SIZE,
+}, {
+	.base = {
+		.cra_name = "authenc(hmac(sha1),ecb(cipher_null))",
+		.cra_driver_name = "cpt_hmac_sha1_ecb_null",
+		.cra_blocksize = 1,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_ecb_null_sha1_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_ecb_null_sha_setkey,
+	.setauthsize = otx2_cpt_aead_null_set_authsize,
+	.encrypt = otx2_cpt_aead_null_encrypt,
+	.decrypt = otx2_cpt_aead_null_decrypt,
+	.ivsize = 0,
+	.maxauthsize = SHA1_DIGEST_SIZE,
+}, {
+	.base = {
+		.cra_name = "authenc(hmac(sha256),ecb(cipher_null))",
+		.cra_driver_name = "cpt_hmac_sha256_ecb_null",
+		.cra_blocksize = 1,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_ecb_null_sha256_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_ecb_null_sha_setkey,
+	.setauthsize = otx2_cpt_aead_null_set_authsize,
+	.encrypt = otx2_cpt_aead_null_encrypt,
+	.decrypt = otx2_cpt_aead_null_decrypt,
+	.ivsize = 0,
+	.maxauthsize = SHA256_DIGEST_SIZE,
+}, {
+	.base = {
+		.cra_name = "authenc(hmac(sha384),ecb(cipher_null))",
+		.cra_driver_name = "cpt_hmac_sha384_ecb_null",
+		.cra_blocksize = 1,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_ecb_null_sha384_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_ecb_null_sha_setkey,
+	.setauthsize = otx2_cpt_aead_null_set_authsize,
+	.encrypt = otx2_cpt_aead_null_encrypt,
+	.decrypt = otx2_cpt_aead_null_decrypt,
+	.ivsize = 0,
+	.maxauthsize = SHA384_DIGEST_SIZE,
+}, {
+	.base = {
+		.cra_name = "authenc(hmac(sha512),ecb(cipher_null))",
+		.cra_driver_name = "cpt_hmac_sha512_ecb_null",
+		.cra_blocksize = 1,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_ecb_null_sha512_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_ecb_null_sha_setkey,
+	.setauthsize = otx2_cpt_aead_null_set_authsize,
+	.encrypt = otx2_cpt_aead_null_encrypt,
+	.decrypt = otx2_cpt_aead_null_decrypt,
+	.ivsize = 0,
+	.maxauthsize = SHA512_DIGEST_SIZE,
+}, {
+	.base = {
+		.cra_name = "rfc4106(gcm(aes))",
+		.cra_driver_name = "cpt_rfc4106_gcm_aes",
+		.cra_blocksize = 1,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_gcm_aes_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_gcm_aes_setkey,
+	.setauthsize = otx2_cpt_aead_gcm_set_authsize,
+	.encrypt = otx2_cpt_aead_encrypt,
+	.decrypt = otx2_cpt_aead_decrypt,
+	.ivsize = AES_GCM_IV_SIZE,
+	.maxauthsize = AES_GCM_ICV_SIZE,
+} };
+
+static inline int cpt_register_algs(void)
+{
+	int i, err = 0;
+
+	if (!IS_ENABLED(CONFIG_DM_CRYPT)) {
+		for (i = 0; i < ARRAY_SIZE(otx2_cpt_skciphers); i++)
+			otx2_cpt_skciphers[i].base.cra_flags &=
+							~CRYPTO_ALG_DEAD;
+
+		err = crypto_register_skciphers(otx2_cpt_skciphers,
+						ARRAY_SIZE(otx2_cpt_skciphers));
+		if (err)
+			return err;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(otx2_cpt_aeads); i++)
+		otx2_cpt_aeads[i].base.cra_flags &= ~CRYPTO_ALG_DEAD;
+
+	err = crypto_register_aeads(otx2_cpt_aeads,
+				    ARRAY_SIZE(otx2_cpt_aeads));
+	if (err) {
+		crypto_unregister_skciphers(otx2_cpt_skciphers,
+					    ARRAY_SIZE(otx2_cpt_skciphers));
+		return err;
+	}
+
+	return 0;
+}
+
+static inline void cpt_unregister_algs(void)
+{
+	crypto_unregister_skciphers(otx2_cpt_skciphers,
+				    ARRAY_SIZE(otx2_cpt_skciphers));
+	crypto_unregister_aeads(otx2_cpt_aeads, ARRAY_SIZE(otx2_cpt_aeads));
+}
+
+static int compare_func(const void *lptr, const void *rptr)
+{
+	const struct cpt_device_desc *ldesc = (struct cpt_device_desc *) lptr;
+	const struct cpt_device_desc *rdesc = (struct cpt_device_desc *) rptr;
+
+	if (ldesc->dev->devfn < rdesc->dev->devfn)
+		return -1;
+	if (ldesc->dev->devfn > rdesc->dev->devfn)
+		return 1;
+	return 0;
+}
+
+static void swap_func(void *lptr, void *rptr, int size)
+{
+	struct cpt_device_desc *ldesc = lptr;
+	struct cpt_device_desc *rdesc = rptr;
+	struct cpt_device_desc desc;
+
+	desc = *ldesc;
+	*ldesc = *rdesc;
+	*rdesc = desc;
+}
+
+int otx2_cpt_crypto_init(struct pci_dev *pdev, struct module *mod,
+			 enum otx2_cpt_eng_type engine_type,
+			 int num_queues, int num_devices)
+{
+	int ret = 0;
+	int count;
+
+	mutex_lock(&mutex);
+	switch (engine_type) {
+	case OTX2_CPT_SE_TYPES:
+		count = atomic_read(&se_devices.count);
+		if (count >= CPT_MAX_LF_NUM) {
+			dev_err(&pdev->dev, "No space to add a new device\n");
+			ret = -ENOSPC;
+			goto unlock;
+		}
+		se_devices.desc[count].num_queues = num_queues;
+		se_devices.desc[count++].dev = pdev;
+		atomic_inc(&se_devices.count);
+
+		if (atomic_read(&se_devices.count) == num_devices &&
+		    is_crypto_registered == false) {
+			if (cpt_register_algs()) {
+				dev_err(&pdev->dev,
+				   "Error in registering crypto algorithms\n");
+				ret =  -EINVAL;
+				goto unlock;
+			}
+			try_module_get(mod);
+			is_crypto_registered = true;
+		}
+		sort(se_devices.desc, count, sizeof(struct cpt_device_desc),
+		     compare_func, swap_func);
+		break;
+
+	case OTX2_CPT_AE_TYPES:
+		count = atomic_read(&ae_devices.count);
+		if (count >= CPT_MAX_LF_NUM) {
+			dev_err(&pdev->dev, "No space to a add new device\n");
+			ret = -ENOSPC;
+			goto unlock;
+		}
+		ae_devices.desc[count].num_queues = num_queues;
+		ae_devices.desc[count++].dev = pdev;
+		atomic_inc(&ae_devices.count);
+		sort(ae_devices.desc, count, sizeof(struct cpt_device_desc),
+		     compare_func, swap_func);
+		break;
+
+	default:
+		dev_err(&pdev->dev, "Unknown VF type %d\n", engine_type);
+		ret = BAD_OTX2_CPT_ENG_TYPE;
+	}
+unlock:
+	mutex_unlock(&mutex);
+	return ret;
+}
+
+void otx2_cpt_crypto_exit(struct pci_dev *pdev, struct module *mod,
+			  enum otx2_cpt_eng_type engine_type)
+{
+	struct cpt_device_table *dev_tbl;
+	bool dev_found = false;
+	int i, j, count;
+
+	mutex_lock(&mutex);
+
+	dev_tbl = (engine_type == OTX2_CPT_AE_TYPES) ? &ae_devices :
+						       &se_devices;
+	count = atomic_read(&dev_tbl->count);
+	for (i = 0; i < count; i++)
+		if (pdev == dev_tbl->desc[i].dev) {
+			for (j = i; j < count-1; j++)
+				dev_tbl->desc[j] = dev_tbl->desc[j+1];
+			dev_found = true;
+			break;
+		}
+
+	if (!dev_found) {
+		dev_err(&pdev->dev, "%s device not found\n", __func__);
+		goto unlock;
+	}
+
+	if (engine_type == OTX2_CPT_SE_TYPES) {
+		if (atomic_dec_and_test(&se_devices.count)) {
+			cpt_unregister_algs();
+			module_put(mod);
+			is_crypto_registered = false;
+		}
+	} else {
+		atomic_dec(&ae_devices.count);
+	}
+unlock:
+	mutex_unlock(&mutex);
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
new file mode 100644
index 000000000000..85f418d7eb79
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
@@ -0,0 +1,172 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef __OTX2_CPT_ALGS_H
+#define __OTX2_CPT_ALGS_H
+
+#include <crypto/hash.h>
+#include "otx2_cpt_common.h"
+
+#define OTX2_CPT_MAX_ENC_KEY_SIZE    32
+#define OTX2_CPT_MAX_HASH_KEY_SIZE   64
+#define OTX2_CPT_MAX_KEY_SIZE (OTX2_CPT_MAX_ENC_KEY_SIZE + \
+			       OTX2_CPT_MAX_HASH_KEY_SIZE)
+enum otx2_cpt_request_type {
+	OTX2_CPT_ENC_DEC_REQ            = 0x1,
+	OTX2_CPT_AEAD_ENC_DEC_REQ       = 0x2,
+	OTX2_CPT_AEAD_ENC_DEC_NULL_REQ  = 0x3,
+	OTX2_CPT_PASSTHROUGH_REQ	= 0x4
+};
+
+enum otx2_cpt_major_opcodes {
+	OTX2_CPT_MAJOR_OP_MISC = 0x01,
+	OTX2_CPT_MAJOR_OP_FC   = 0x33,
+	OTX2_CPT_MAJOR_OP_HMAC = 0x35,
+};
+
+enum otx2_cpt_cipher_type {
+	OTX2_CPT_CIPHER_NULL = 0x0,
+	OTX2_CPT_DES3_CBC = 0x1,
+	OTX2_CPT_DES3_ECB = 0x2,
+	OTX2_CPT_AES_CBC  = 0x3,
+	OTX2_CPT_AES_ECB  = 0x4,
+	OTX2_CPT_AES_CFB  = 0x5,
+	OTX2_CPT_AES_CTR  = 0x6,
+	OTX2_CPT_AES_GCM  = 0x7,
+	OTX2_CPT_AES_XTS  = 0x8
+};
+
+enum otx2_cpt_mac_type {
+	OTX2_CPT_MAC_NULL = 0x0,
+	OTX2_CPT_MD5      = 0x1,
+	OTX2_CPT_SHA1     = 0x2,
+	OTX2_CPT_SHA224   = 0x3,
+	OTX2_CPT_SHA256   = 0x4,
+	OTX2_CPT_SHA384   = 0x5,
+	OTX2_CPT_SHA512   = 0x6,
+	OTX2_CPT_GMAC     = 0x7
+};
+
+enum otx2_cpt_aes_key_len {
+	OTX2_CPT_AES_128_BIT = 0x1,
+	OTX2_CPT_AES_192_BIT = 0x2,
+	OTX2_CPT_AES_256_BIT = 0x3
+};
+
+union otx2_cpt_encr_ctrl {
+	u64 u;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 enc_cipher:4;
+		u64 reserved_59:1;
+		u64 aes_key:2;
+		u64 iv_source:1;
+		u64 mac_type:4;
+		u64 reserved_49_51:3;
+		u64 auth_input_type:1;
+		u64 mac_len:8;
+		u64 reserved_32_39:8;
+		u64 encr_offset:16;
+		u64 iv_offset:8;
+		u64 auth_offset:8;
+#else
+		u64 auth_offset:8;
+		u64 iv_offset:8;
+		u64 encr_offset:16;
+		u64 reserved_32_39:8;
+		u64 mac_len:8;
+		u64 auth_input_type:1;
+		u64 reserved_49_51:3;
+		u64 mac_type:4;
+		u64 iv_source:1;
+		u64 aes_key:2;
+		u64 reserved_59:1;
+		u64 enc_cipher:4;
+#endif
+	} e;
+};
+
+struct otx2_cpt_cipher {
+	const char *name;
+	u8 value;
+};
+
+struct otx2_cpt_fc_enc_ctx {
+	union otx2_cpt_encr_ctrl enc_ctrl;
+	u8 encr_key[32];
+	u8 encr_iv[16];
+};
+
+union otx2_cpt_fc_hmac_ctx {
+	struct {
+		u8 ipad[64];
+		u8 opad[64];
+	} e;
+	struct {
+		u8 hmac_calc[64]; /* HMAC calculated */
+		u8 hmac_recv[64]; /* HMAC received */
+	} s;
+};
+
+struct otx2_cpt_fc_ctx {
+	struct otx2_cpt_fc_enc_ctx enc;
+	union otx2_cpt_fc_hmac_ctx hmac;
+};
+
+struct otx2_cpt_enc_ctx {
+	u32 key_len;
+	u8 enc_key[OTX2_CPT_MAX_KEY_SIZE];
+	u8 cipher_type;
+	u8 key_type;
+	u8 enc_align_len;
+};
+
+union otx2_cpt_offset_ctrl {
+	u64 flags;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved:32;
+		u64 enc_data_offset:16;
+		u64 iv_offset:8;
+		u64 auth_offset:8;
+#else
+		u64 auth_offset:8;
+		u64 iv_offset:8;
+		u64 enc_data_offset:16;
+		u64 reserved:32;
+#endif
+	} e;
+};
+
+struct otx2_cpt_req_ctx {
+	struct otx2_cpt_req_info cpt_req;
+	union otx2_cpt_offset_ctrl ctrl_word;
+	struct otx2_cpt_fc_ctx fctx;
+};
+
+struct otx2_cpt_sdesc {
+	struct shash_desc shash;
+};
+
+struct otx2_cpt_aead_ctx {
+	u8 key[OTX2_CPT_MAX_KEY_SIZE];
+	struct crypto_shash *hashalg;
+	struct otx2_cpt_sdesc *sdesc;
+	u8 *ipad;
+	u8 *opad;
+	u32 enc_key_len;
+	u32 auth_key_len;
+	u8 cipher_type;
+	u8 mac_type;
+	u8 key_type;
+	u8 is_trunc_hmac;
+	u8 enc_align_len;
+};
+int otx2_cpt_crypto_init(struct pci_dev *pdev, struct module *mod,
+			 enum otx2_cpt_eng_type engine_type,
+			 int num_queues, int num_devices);
+void otx2_cpt_crypto_exit(struct pci_dev *pdev, struct module *mod,
+			  enum otx2_cpt_eng_type engine_type);
+
+#endif /* __OTX2_CPT_ALGS_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
new file mode 100644
index 000000000000..623745e0f987
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -0,0 +1,229 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include "otx2_cpt_mbox_common.h"
+#include "rvu_reg.h"
+
+#define OTX2_CPTVF_DRV_NAME "octeontx2-cptvf"
+#define OTX2_CPTVF_DRV_VERSION "1.0"
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
+	/* Register VF-PF mailbox interrupt handler */
+	ret = devm_request_irq(&cptvf->pdev->dev, irq,
+			       otx2_cptvf_pfvf_mbox_intr, 0,
+			       "CPTPFVF Mbox", cptvf);
+	return ret;
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
+	int ret, kcrypto_lfs;
+
+	cptvf = devm_kzalloc(dev, sizeof(*cptvf), GFP_KERNEL);
+	if (!cptvf)
+		return -ENOMEM;
+
+	pci_set_drvdata(pdev, cptvf);
+	cptvf->pdev = pdev;
+
+	ret = pcim_enable_device(pdev);
+	if (ret) {
+		dev_err(dev, "Failed to enable PCI device\n");
+		goto clear_drvdata;
+	}
+	pci_set_master(pdev);
+
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(48));
+	if (ret) {
+		dev_err(dev, "Unable to get usable DMA configuration\n");
+		goto clear_drvdata;
+	}
+
+	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(48));
+	if (ret) {
+		dev_err(dev, "Unable to get 48-bit DMA for consistent allocations\n");
+		goto clear_drvdata;
+	}
+
+	/* Map VF's configuration registers */
+	ret = pcim_iomap_regions_request_all(pdev, 1 << PCI_PF_REG_BAR_NUM,
+					     OTX2_CPTVF_DRV_NAME);
+	if (ret) {
+		dev_err(dev, "Couldn't get PCI resources 0x%x\n", ret);
+		goto clear_drvdata;
+	}
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
+
+	/* Initialize PF-VF mailbox */
+	ret = cptvf_pfvf_mbox_init(cptvf);
+	if (ret)
+		goto clear_drvdata;
+
+	/* Register interrupts */
+	ret = cptvf_register_interrupts(cptvf);
+	if (ret)
+		goto destroy_pfvf_mbox;
+
+	/* Enable PF-VF mailbox interrupts */
+	cptvf_enable_pfvf_mbox_intrs(cptvf);
+
+	/* Send ready message */
+	ret = otx2_cpt_send_ready_msg(cptvf->pdev);
+	if (ret)
+		goto unregister_interrupts;
+
+	/* Get engine group number for symmetric crypto */
+	cptvf->lfs.kcrypto_eng_grp_num = OTX2_CPT_INVALID_CRYPTO_ENG_GRP;
+	ret = otx2_cptvf_send_eng_grp_num_msg(cptvf, OTX2_CPT_SE_TYPES);
+	if (ret)
+		goto unregister_interrupts;
+
+	if (cptvf->lfs.kcrypto_eng_grp_num == OTX2_CPT_INVALID_CRYPTO_ENG_GRP) {
+		dev_err(dev, "Engine group for kernel crypto not available\n");
+		ret = -ENOENT;
+		goto unregister_interrupts;
+	}
+	ret = otx2_cptvf_send_kcrypto_limits_msg(cptvf);
+	if (ret)
+		goto unregister_interrupts;
+
+	kcrypto_lfs = cptvf->lfs.kcrypto_limits ? cptvf->lfs.kcrypto_limits :
+		      num_online_cpus();
+	/* Initialize CPT LFs */
+	ret = otx2_cptvf_lf_init(pdev, cptvf->reg_base, &cptvf->lfs,
+				 kcrypto_lfs);
+	if (ret)
+		goto unregister_interrupts;
+
+	return 0;
+
+unregister_interrupts:
+	cptvf_disable_pfvf_mbox_intrs(cptvf);
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
+
+	/* Shutdown CPT LFs */
+	if (otx2_cptvf_lf_shutdown(pdev, &cptvf->lfs))
+		dev_err(&pdev->dev, "CPT LFs shutdown failed.\n");
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
+MODULE_VERSION(OTX2_CPTVF_DRV_VERSION);
+MODULE_DEVICE_TABLE(pci, otx2_cptvf_id_table);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
new file mode 100644
index 000000000000..976c0a20850d
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
@@ -0,0 +1,189 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include "otx2_cpt_mbox_common.h"
+#include "rvu_reg.h"
+
+static void dump_mbox_msg(struct mbox_msghdr *msg, int size)
+{
+	u16 pf_id, vf_id;
+
+	pf_id = (msg->pcifunc >> RVU_PFVF_PF_SHIFT) & RVU_PFVF_PF_MASK;
+	vf_id = (msg->pcifunc >> RVU_PFVF_FUNC_SHIFT) & RVU_PFVF_FUNC_MASK;
+
+	pr_debug("MBOX opcode %s received from (PF%d/VF%d), size %d, rc %d",
+		 otx2_cpt_get_mbox_opcode_str(msg->id), pf_id, vf_id, size,
+		 msg->rc);
+	print_hex_dump_debug("", DUMP_PREFIX_OFFSET, 16, 2, msg, size, false);
+}
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
+void otx2_cptvf_pfvf_mbox_handler(struct work_struct *work)
+{
+	struct otx2_cpt_kcrypto_limits_rsp *rsp_limits;
+	struct otx2_cpt_eng_grp_num_rsp *rsp_grp;
+	struct cpt_rd_wr_reg_msg *rsp_reg;
+	struct msix_offset_rsp *rsp_msix;
+	struct otx2_cptvf_dev *cptvf;
+	struct otx2_mbox *pfvf_mbox;
+	struct mbox_hdr *rsp_hdr;
+	struct mbox_msghdr *msg;
+	int offset, i, j, size;
+
+	/* Read latest mbox data */
+	smp_rmb();
+
+	cptvf = container_of(work, struct otx2_cptvf_dev, pfvf_mbox_work);
+	pfvf_mbox = &cptvf->pfvf_mbox;
+	rsp_hdr = (struct mbox_hdr *)(pfvf_mbox->dev->mbase +
+		   pfvf_mbox->rx_start);
+	if (rsp_hdr->num_msgs == 0)
+		return;
+	offset = ALIGN(sizeof(struct mbox_hdr), MBOX_MSG_ALIGN);
+
+	for (i = 0; i < rsp_hdr->num_msgs; i++) {
+		msg = (struct mbox_msghdr *)(pfvf_mbox->dev->mbase +
+					     pfvf_mbox->rx_start + offset);
+		size = msg->next_msgoff - offset;
+
+		if (msg->id >= MBOX_MSG_MAX) {
+			dev_err(&cptvf->pdev->dev,
+				"MBOX msg with unknown ID %d\n", msg->id);
+			goto error;
+		}
+
+		if (msg->sig != OTX2_MBOX_RSP_SIG) {
+			dev_err(&cptvf->pdev->dev,
+				"MBOX msg with wrong signature %x, ID %d\n",
+				msg->sig, msg->id);
+			goto error;
+		}
+
+		dump_mbox_msg(msg, size);
+
+		offset = msg->next_msgoff;
+		switch (msg->id) {
+		case MBOX_MSG_READY:
+			cptvf->vf_id = ((msg->pcifunc >> RVU_PFVF_FUNC_SHIFT)
+					& RVU_PFVF_FUNC_MASK) - 1;
+			break;
+
+		case MBOX_MSG_ATTACH_RESOURCES:
+			/* Check if resources were successfully attached */
+			if (!msg->rc)
+				cptvf->lfs.are_lfs_attached = 1;
+			break;
+
+		case MBOX_MSG_DETACH_RESOURCES:
+			/* Check if resources were successfully detached */
+			if (!msg->rc)
+				cptvf->lfs.are_lfs_attached = 0;
+			break;
+
+		case MBOX_MSG_MSIX_OFFSET:
+			rsp_msix = (struct msix_offset_rsp *) msg;
+			for (j = 0; j < rsp_msix->cptlfs; j++)
+				cptvf->lfs.lf[j].msix_offset =
+						rsp_msix->cptlf_msixoff[j];
+			break;
+
+		case MBOX_MSG_CPT_RD_WR_REGISTER:
+			rsp_reg = (struct cpt_rd_wr_reg_msg *) msg;
+			if (msg->rc) {
+				dev_err(&cptvf->pdev->dev,
+					"Reg %llx rd/wr(%d) failed %d\n",
+					rsp_reg->reg_offset, rsp_reg->is_write,
+					msg->rc);
+				goto error;
+			}
+
+			if (!rsp_reg->is_write)
+				*rsp_reg->ret_val = rsp_reg->val;
+			break;
+
+		case MBOX_MSG_GET_ENG_GRP_NUM:
+			rsp_grp = (struct otx2_cpt_eng_grp_num_rsp *) msg;
+			cptvf->lfs.kcrypto_eng_grp_num = rsp_grp->eng_grp_num;
+			break;
+
+		case MBOX_MSG_GET_KCRYPTO_LIMITS:
+			rsp_limits = (struct otx2_cpt_kcrypto_limits_rsp *) msg;
+			cptvf->lfs.kcrypto_limits = rsp_limits->kcrypto_limits;
+			break;
+
+		default:
+			dev_err(&cptvf->pdev->dev,
+				"Unsupported msg %d received.\n",
+				msg->id);
+			break;
+		}
+error:
+		pfvf_mbox->dev->msgs_acked++;
+	}
+	otx2_mbox_reset(pfvf_mbox, 0);
+}
+
+int otx2_cptvf_send_eng_grp_num_msg(struct otx2_cptvf_dev *cptvf, int eng_type)
+{
+	struct otx2_cpt_eng_grp_num_msg *req;
+	struct pci_dev *pdev = cptvf->pdev;
+	int ret;
+
+	req = (struct otx2_cpt_eng_grp_num_msg *)
+		otx2_mbox_alloc_msg_rsp(&cptvf->pfvf_mbox, 0,
+				sizeof(*req),
+				sizeof(struct otx2_cpt_eng_grp_num_rsp));
+	if (req == NULL) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+	req->hdr.id = MBOX_MSG_GET_ENG_GRP_NUM;
+	req->hdr.sig = OTX2_MBOX_REQ_SIG;
+	req->hdr.pcifunc = OTX2_CPT_RVU_PFFUNC(cptvf->vf_id, 0);
+	req->eng_type = eng_type;
+
+	ret = otx2_cpt_send_mbox_msg(pdev);
+
+	return ret;
+}
+
+int otx2_cptvf_send_kcrypto_limits_msg(struct otx2_cptvf_dev *cptvf)
+{
+	struct pci_dev *pdev = cptvf->pdev;
+	struct mbox_msghdr *req;
+	int ret;
+
+	req = (struct mbox_msghdr *)
+		otx2_mbox_alloc_msg_rsp(&cptvf->pfvf_mbox, 0,
+				sizeof(*req),
+				sizeof(struct otx2_cpt_kcrypto_limits_rsp));
+	if (req == NULL) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+	req->id = MBOX_MSG_GET_KCRYPTO_LIMITS;
+	req->sig = OTX2_MBOX_REQ_SIG;
+	req->pcifunc = OTX2_CPT_RVU_PFFUNC(cptvf->vf_id, 0);
+
+	ret = otx2_cpt_send_mbox_msg(pdev);
+
+	return ret;
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
new file mode 100644
index 000000000000..47b10eeedb3e
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
@@ -0,0 +1,540 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include "otx2_cptvf.h"
+#include "otx2_cptvf_algs.h"
+#include "otx2_cpt_mbox_common.h"
+
+/* SG list header size in bytes */
+#define SG_LIST_HDR_SIZE	8
+
+/* Default timeout when waiting for free pending entry in us */
+#define CPT_PENTRY_TIMEOUT	1000
+#define CPT_PENTRY_STEP		50
+
+/* Default threshold for stopping and resuming sender requests */
+#define CPT_IQ_STOP_MARGIN	128
+#define CPT_IQ_RESUME_MARGIN	512
+
+/* Default command timeout in seconds */
+#define CPT_COMMAND_TIMEOUT	4
+#define CPT_TIME_IN_RESET_COUNT 5
+
+static void otx2_cpt_dump_sg_list(struct pci_dev *pdev,
+				  struct otx2_cpt_req_info *req)
+{
+	int i;
+
+	pr_debug("Gather list size %d\n", req->in_cnt);
+	for (i = 0; i < req->in_cnt; i++) {
+		pr_debug("Buffer %d size %d, vptr 0x%p, dmaptr 0x%p\n", i,
+			 req->in[i].size, req->in[i].vptr,
+			 (void *) req->in[i].dma_addr);
+		pr_debug("Buffer hexdump (%d bytes)\n",
+			 req->in[i].size);
+		print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1,
+				     req->in[i].vptr, req->in[i].size, false);
+	}
+
+	pr_debug("Scatter list size %d\n", req->out_cnt);
+	for (i = 0; i < req->out_cnt; i++) {
+		pr_debug("Buffer %d size %d, vptr 0x%p, dmaptr 0x%p\n", i,
+			 req->out[i].size, req->out[i].vptr,
+			 (void *) req->out[i].dma_addr);
+		pr_debug("Buffer hexdump (%d bytes)\n", req->out[i].size);
+		print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1,
+				     req->out[i].vptr, req->out[i].size, false);
+	}
+}
+
+static inline struct otx2_cpt_pending_entry *get_free_pending_entry(
+					struct otx2_cpt_pending_queue *q,
+					int qlen)
+{
+	struct otx2_cpt_pending_entry *ent = NULL;
+
+	ent = &q->head[q->rear];
+	if (unlikely(ent->busy))
+		return NULL;
+
+	q->rear++;
+	if (unlikely(q->rear == qlen))
+		q->rear = 0;
+
+	return ent;
+}
+
+static inline u32 modulo_inc(u32 index, u32 length, u32 inc)
+{
+	if (WARN_ON(inc > length))
+		inc = length;
+
+	index += inc;
+	if (unlikely(index >= length))
+		index -= length;
+
+	return index;
+}
+
+static inline void free_pentry(struct otx2_cpt_pending_entry *pentry)
+{
+	pentry->completion_addr = NULL;
+	pentry->info = NULL;
+	pentry->callback = NULL;
+	pentry->areq = NULL;
+	pentry->resume_sender = false;
+	pentry->busy = false;
+}
+
+static inline int setup_sgio_components(struct pci_dev *pdev,
+					struct otx2_cpt_buf_ptr *list,
+					int buf_count, u8 *buffer)
+{
+	struct otx2_cpt_sglist_component *sg_ptr = NULL;
+	int ret = 0, i, j;
+	int components;
+
+	if (unlikely(!list)) {
+		dev_err(&pdev->dev, "Input list pointer is NULL\n");
+		return -EFAULT;
+	}
+
+	for (i = 0; i < buf_count; i++) {
+		if (unlikely(!list[i].vptr))
+			continue;
+		list[i].dma_addr = dma_map_single(&pdev->dev, list[i].vptr,
+						  list[i].size,
+						  DMA_BIDIRECTIONAL);
+		if (unlikely(dma_mapping_error(&pdev->dev, list[i].dma_addr))) {
+			dev_err(&pdev->dev, "Dma mapping failed\n");
+			ret = -EIO;
+			goto sg_cleanup;
+		}
+	}
+	components = buf_count / 4;
+	sg_ptr = (struct otx2_cpt_sglist_component *)buffer;
+	for (i = 0; i < components; i++) {
+		sg_ptr->len0 = cpu_to_be16(list[i * 4 + 0].size);
+		sg_ptr->len1 = cpu_to_be16(list[i * 4 + 1].size);
+		sg_ptr->len2 = cpu_to_be16(list[i * 4 + 2].size);
+		sg_ptr->len3 = cpu_to_be16(list[i * 4 + 3].size);
+		sg_ptr->ptr0 = cpu_to_be64(list[i * 4 + 0].dma_addr);
+		sg_ptr->ptr1 = cpu_to_be64(list[i * 4 + 1].dma_addr);
+		sg_ptr->ptr2 = cpu_to_be64(list[i * 4 + 2].dma_addr);
+		sg_ptr->ptr3 = cpu_to_be64(list[i * 4 + 3].dma_addr);
+		sg_ptr++;
+	}
+	components = buf_count % 4;
+
+	switch (components) {
+	case 3:
+		sg_ptr->len2 = cpu_to_be16(list[i * 4 + 2].size);
+		sg_ptr->ptr2 = cpu_to_be64(list[i * 4 + 2].dma_addr);
+		fallthrough;
+	case 2:
+		sg_ptr->len1 = cpu_to_be16(list[i * 4 + 1].size);
+		sg_ptr->ptr1 = cpu_to_be64(list[i * 4 + 1].dma_addr);
+		fallthrough;
+	case 1:
+		sg_ptr->len0 = cpu_to_be16(list[i * 4 + 0].size);
+		sg_ptr->ptr0 = cpu_to_be64(list[i * 4 + 0].dma_addr);
+		break;
+	default:
+		break;
+	}
+	return ret;
+
+sg_cleanup:
+	for (j = 0; j < i; j++) {
+		if (list[j].dma_addr) {
+			dma_unmap_single(&pdev->dev, list[j].dma_addr,
+					 list[j].size, DMA_BIDIRECTIONAL);
+		}
+
+		list[j].dma_addr = 0;
+	}
+	return ret;
+}
+
+static inline struct otx2_cpt_inst_info *info_create(struct pci_dev *pdev,
+					      struct otx2_cpt_req_info *req,
+					      gfp_t gfp)
+{
+	int align = OTX2_CPT_DMA_MINALIGN;
+	struct otx2_cpt_inst_info *info;
+	u32 dlen, align_dlen, info_len;
+	u16 g_sz_bytes, s_sz_bytes;
+	u32 total_mem_len;
+
+	if (unlikely(req->in_cnt > OTX2_CPT_MAX_SG_IN_CNT ||
+		     req->out_cnt > OTX2_CPT_MAX_SG_OUT_CNT)) {
+		dev_err(&pdev->dev, "Error too many sg components\n");
+		return NULL;
+	}
+
+	g_sz_bytes = ((req->in_cnt + 3) / 4) *
+		      sizeof(struct otx2_cpt_sglist_component);
+	s_sz_bytes = ((req->out_cnt + 3) / 4) *
+		      sizeof(struct otx2_cpt_sglist_component);
+
+	dlen = g_sz_bytes + s_sz_bytes + SG_LIST_HDR_SIZE;
+	align_dlen = ALIGN(dlen, align);
+	info_len = ALIGN(sizeof(*info), align);
+	total_mem_len = align_dlen + info_len + sizeof(union otx2_cpt_res_s);
+
+	info = kzalloc(total_mem_len, gfp);
+	if (unlikely(!info))
+		return NULL;
+
+	info->dlen = dlen;
+	info->in_buffer = (u8 *)info + info_len;
+
+	((u16 *)info->in_buffer)[0] = req->out_cnt;
+	((u16 *)info->in_buffer)[1] = req->in_cnt;
+	((u16 *)info->in_buffer)[2] = 0;
+	((u16 *)info->in_buffer)[3] = 0;
+	cpu_to_be64s((u64 *)info->in_buffer);
+
+	/* Setup gather (input) components */
+	if (setup_sgio_components(pdev, req->in, req->in_cnt,
+				  &info->in_buffer[8])) {
+		dev_err(&pdev->dev, "Failed to setup gather list\n");
+		goto destroy_info;
+	}
+
+	if (setup_sgio_components(pdev, req->out, req->out_cnt,
+				  &info->in_buffer[8 + g_sz_bytes])) {
+		dev_err(&pdev->dev, "Failed to setup scatter list\n");
+		goto destroy_info;
+	}
+
+	info->dma_len = total_mem_len - info_len;
+	info->dptr_baddr = dma_map_single(&pdev->dev, info->in_buffer,
+					  info->dma_len, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(&pdev->dev, info->dptr_baddr))) {
+		dev_err(&pdev->dev, "DMA Mapping failed for cpt req\n");
+		goto destroy_info;
+	}
+	/*
+	 * Get buffer for union otx2_cpt_res_s response
+	 * structure and its physical address
+	 */
+	info->completion_addr = info->in_buffer + align_dlen;
+	info->comp_baddr = info->dptr_baddr + align_dlen;
+
+	return info;
+destroy_info:
+	otx2_cpt_info_destroy(pdev, info);
+	return NULL;
+}
+
+static int process_request(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
+			   struct otx2_cpt_pending_queue *pqueue,
+			   struct otx2_cptlf_info *lf)
+{
+	struct otx2_cptvf_request *cpt_req = &req->req;
+	struct otx2_cpt_pending_entry *pentry = NULL;
+	union otx2_cpt_ctrl_info *ctrl = &req->ctrl;
+	struct otx2_cpt_inst_info *info = NULL;
+	union otx2_cpt_res_s *result = NULL;
+	struct otx2_cpt_iq_command iq_cmd;
+	union otx2_cpt_inst_s cptinst;
+	int retry, ret = 0;
+	u8 resume_sender;
+	gfp_t gfp;
+
+	gfp = (req->areq->flags & CRYPTO_TFM_REQ_MAY_SLEEP) ? GFP_KERNEL :
+							      GFP_ATOMIC;
+	if (unlikely(!otx2_cptlf_started(lf->lfs)))
+		return -ENODEV;
+
+	info = info_create(pdev, req, gfp);
+	if (unlikely(!info)) {
+		dev_err(&pdev->dev, "Setting up cpt inst info failed");
+		return -ENOMEM;
+	}
+	cpt_req->dlen = info->dlen;
+
+	result = info->completion_addr;
+	result->s.compcode = OTX2_CPT_COMPLETION_CODE_INIT;
+
+	spin_lock_bh(&pqueue->lock);
+	pentry = get_free_pending_entry(pqueue, pqueue->qlen);
+	retry = CPT_PENTRY_TIMEOUT / CPT_PENTRY_STEP;
+	while (unlikely(!pentry) && retry--) {
+		spin_unlock_bh(&pqueue->lock);
+		udelay(CPT_PENTRY_STEP);
+		spin_lock_bh(&pqueue->lock);
+		pentry = get_free_pending_entry(pqueue, pqueue->qlen);
+	}
+
+	if (unlikely(!pentry)) {
+		ret = -ENOSPC;
+		goto destroy_info;
+	}
+
+	/*
+	 * Check if we are close to filling in entire pending queue,
+	 * if so then tell the sender to stop/sleep by returning -EBUSY
+	 * We do it only for context which can sleep (GFP_KERNEL)
+	 */
+	if (gfp == GFP_KERNEL &&
+	    pqueue->pending_count > (pqueue->qlen - CPT_IQ_STOP_MARGIN)) {
+		pentry->resume_sender = true;
+	} else
+		pentry->resume_sender = false;
+	resume_sender = pentry->resume_sender;
+	pqueue->pending_count++;
+
+	pentry->completion_addr = info->completion_addr;
+	pentry->info = info;
+	pentry->callback = req->callback;
+	pentry->areq = req->areq;
+	pentry->busy = true;
+	info->pentry = pentry;
+	info->time_in = jiffies;
+	info->req = req;
+
+	/* Fill in the command */
+	iq_cmd.cmd.u = 0;
+	iq_cmd.cmd.s.opcode = cpu_to_be16(cpt_req->opcode.flags);
+	iq_cmd.cmd.s.param1 = cpu_to_be16(cpt_req->param1);
+	iq_cmd.cmd.s.param2 = cpu_to_be16(cpt_req->param2);
+	iq_cmd.cmd.s.dlen   = cpu_to_be16(cpt_req->dlen);
+
+	/* 64-bit swap for microcode data reads, not needed for addresses*/
+	cpu_to_be64s(&iq_cmd.cmd.u);
+	iq_cmd.dptr = info->dptr_baddr;
+	iq_cmd.rptr = 0;
+	iq_cmd.cptr.u = 0;
+	iq_cmd.cptr.s.grp = ctrl->s.grp;
+
+	/* Fill in the CPT_INST_S type command for HW interpretation */
+	otx2_cpt_fill_inst(&cptinst, &iq_cmd, info->comp_baddr);
+
+	/* Print debug info if enabled */
+	otx2_cpt_dump_sg_list(pdev, req);
+	pr_debug("Cpt_inst_s hexdump (%d bytes)\n", OTX2_CPT_INST_SIZE);
+	print_hex_dump_debug("", 0, 16, 1, &cptinst, OTX2_CPT_INST_SIZE, false);
+	pr_debug("Dptr hexdump (%d bytes)\n", cpt_req->dlen);
+	print_hex_dump_debug("", 0, 16, 1, info->in_buffer,
+			     cpt_req->dlen, false);
+
+	/* Send CPT command */
+	otx2_cpt_send_cmd(&cptinst, 1, lf);
+
+	/*
+	 * We allocate and prepare pending queue entry in critical section
+	 * together with submitting CPT instruction to CPT instruction queue
+	 * to make sure that order of CPT requests is the same in both
+	 * pending and instruction queues
+	 */
+	spin_unlock_bh(&pqueue->lock);
+
+	ret = resume_sender ? -EBUSY : -EINPROGRESS;
+	return ret;
+destroy_info:
+	spin_unlock_bh(&pqueue->lock);
+	otx2_cpt_info_destroy(pdev, info);
+	return ret;
+}
+
+int otx2_cpt_get_kcrypto_eng_grp_num(struct pci_dev *pdev)
+{
+	struct otx2_cptlfs_info *lfs = otx2_cpt_get_lfs_info(pdev);
+
+	return lfs->kcrypto_eng_grp_num;
+}
+
+int otx2_cpt_do_request(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
+			int cpu_num)
+{
+	struct otx2_cptlfs_info *lfs = otx2_cpt_get_lfs_info(pdev);
+
+	return process_request(pdev, req, &lfs->lf[cpu_num].pqueue,
+			       &lfs->lf[cpu_num]);
+}
+
+static int cpt_process_ccode(struct pci_dev *pdev,
+			     union otx2_cpt_res_s *cpt_status,
+			     struct otx2_cpt_inst_info *info,
+			     u32 *res_code)
+{
+	u8 uc_ccode = cpt_status->s.uc_compcode;
+	u8 ccode = cpt_status->s.compcode;
+
+	switch (ccode) {
+	case OTX2_CPT_COMP_E_FAULT:
+		dev_err(&pdev->dev,
+			"Request failed with DMA fault\n");
+		otx2_cpt_dump_sg_list(pdev, info->req);
+		break;
+
+	case OTX2_CPT_COMP_E_HWERR:
+		dev_err(&pdev->dev,
+			"Request failed with hardware error\n");
+		otx2_cpt_dump_sg_list(pdev, info->req);
+		break;
+
+	case OTX2_CPT_COMP_E_INSTERR:
+		dev_err(&pdev->dev,
+			"Request failed with instruction error\n");
+		otx2_cpt_dump_sg_list(pdev, info->req);
+		break;
+
+	case OTX2_CPT_COMP_E_NOTDONE:
+		/* check for timeout */
+		if (time_after_eq(jiffies, info->time_in +
+				  CPT_COMMAND_TIMEOUT * HZ))
+			dev_warn(&pdev->dev,
+				 "Request timed out 0x%p", info->req);
+		else if (info->extra_time < CPT_TIME_IN_RESET_COUNT) {
+			info->time_in = jiffies;
+			info->extra_time++;
+		}
+		return 1;
+
+	case OTX2_CPT_COMP_E_GOOD:
+		/*
+		 * Check microcode completion code, it is only valid
+		 * when completion code is CPT_COMP_E::GOOD
+		 */
+		if (uc_ccode != OTX2_CPT_UCC_SUCCESS) {
+			/*
+			 * If requested hmac is truncated and ucode returns
+			 * s/g write length error then we report success
+			 * because ucode writes as many bytes of calculated
+			 * hmac as available in gather buffer and reports
+			 * s/g write length error if number of bytes in gather
+			 * buffer is less than full hmac size.
+			 */
+			if (info->req->is_trunc_hmac &&
+			    uc_ccode == OTX2_CPT_UCC_SG_WRITE_LENGTH) {
+				*res_code = 0;
+				break;
+			}
+
+			dev_err(&pdev->dev,
+				"Request failed with software error code 0x%x\n",
+				cpt_status->s.uc_compcode);
+			otx2_cpt_dump_sg_list(pdev, info->req);
+			break;
+		}
+		/* Request has been processed with success */
+		*res_code = 0;
+		break;
+
+	default:
+		dev_err(&pdev->dev,
+			"Request returned invalid status %d\n", ccode);
+		break;
+	}
+	return 0;
+}
+
+static inline void process_pending_queue(struct pci_dev *pdev,
+					 struct otx2_cpt_pending_queue *pqueue)
+{
+	struct otx2_cpt_pending_entry *resume_pentry = NULL;
+	void (*callback)(int status, void *arg, void *req);
+	struct otx2_cpt_pending_entry *pentry = NULL;
+	union otx2_cpt_res_s *cpt_status = NULL;
+	struct otx2_cpt_inst_info *info = NULL;
+	struct otx2_cpt_req_info *req = NULL;
+	struct crypto_async_request *areq;
+	u32 res_code, resume_index;
+
+	while (1) {
+		spin_lock_bh(&pqueue->lock);
+		pentry = &pqueue->head[pqueue->front];
+
+		if (WARN_ON(!pentry)) {
+			spin_unlock_bh(&pqueue->lock);
+			break;
+		}
+
+		res_code = -EINVAL;
+		if (unlikely(!pentry->busy)) {
+			spin_unlock_bh(&pqueue->lock);
+			break;
+		}
+
+		if (unlikely(!pentry->callback)) {
+			dev_err(&pdev->dev, "Callback NULL\n");
+			goto process_pentry;
+		}
+
+		info = pentry->info;
+		if (unlikely(!info)) {
+			dev_err(&pdev->dev, "Pending entry post arg NULL\n");
+			goto process_pentry;
+		}
+
+		req = info->req;
+		if (unlikely(!req)) {
+			dev_err(&pdev->dev, "Request NULL\n");
+			goto process_pentry;
+		}
+
+		cpt_status = pentry->completion_addr;
+		if (unlikely(!cpt_status)) {
+			dev_err(&pdev->dev, "Completion address NULL\n");
+			goto process_pentry;
+		}
+
+		if (cpt_process_ccode(pdev, cpt_status, info, &res_code)) {
+			spin_unlock_bh(&pqueue->lock);
+			return;
+		}
+		info->pdev = pdev;
+
+process_pentry:
+		/*
+		 * Check if we should inform sending side to resume
+		 * We do it CPT_IQ_RESUME_MARGIN elements in advance before
+		 * pending queue becomes empty
+		 */
+		resume_index = modulo_inc(pqueue->front, pqueue->qlen,
+					  CPT_IQ_RESUME_MARGIN);
+		resume_pentry = &pqueue->head[resume_index];
+		if (resume_pentry &&
+		    resume_pentry->resume_sender) {
+			resume_pentry->resume_sender = false;
+			callback = resume_pentry->callback;
+			areq = resume_pentry->areq;
+
+			if (callback) {
+				spin_unlock_bh(&pqueue->lock);
+
+				/*
+				 * EINPROGRESS is an indication for sending
+				 * side that it can resume sending requests
+				 */
+				callback(-EINPROGRESS, areq, info);
+				spin_lock_bh(&pqueue->lock);
+			}
+		}
+
+		callback = pentry->callback;
+		areq = pentry->areq;
+		free_pentry(pentry);
+
+		pqueue->pending_count--;
+		pqueue->front = modulo_inc(pqueue->front, pqueue->qlen, 1);
+		spin_unlock_bh(&pqueue->lock);
+
+		/*
+		 * Call callback after current pending entry has been
+		 * processed, we don't do it if the callback pointer is
+		 * invalid.
+		 */
+		if (callback)
+			callback(res_code, areq, info);
+	}
+}
+
+void otx2_cpt_post_process(struct otx2_cptlf_wqe *wqe)
+{
+	process_pending_queue(wqe->lfs->pdev,
+			      &wqe->lfs->lf[wqe->lf_num].pqueue);
+}
-- 
2.28.0

