Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67AF26E46E
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgIQSsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:48:53 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58214 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728467AbgIQQr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 12:47:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HDOaVM011062;
        Thu, 17 Sep 2020 06:29:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=Zu12tMZdRPy5H914B1GO4UpwNu1Cmc++JvwFKufpK8g=;
 b=OqRdR/uCN3PEk9sweYQAGLLWOBNAE/QmzsK6mfl4uPuDPnW+JwDM3SGbGIq8YgK/fo8q
 5KGvGdyTlf85guMCrf1dI8muFYptYDGZN49p/r9KUdwSWNPvjaEiCH1bUbmkCWXdb7PF
 MOsnXoof8u6UhsrzpWF0PbPCgjFq+JAJ5wDMXQyHx3BSjvtttOMz3Ysv2a13f5TzLeBi
 hV+gHwXNpVQ7a6OEFMNYa5oXioj0Giz9wEZu60SKl1MStsh8sW71SqVoRx1uut2BiJSC
 +j8LCW4D50Tqr/xA9sdBFETlptLid4Zw4osZayuu17wPe3PfITxj2AN7C+JBhrqNkWDy rw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33m73mrame-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 06:29:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Sep
 2020 06:29:13 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Sep
 2020 06:29:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Sep 2020 06:29:11 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id D0A7A3F7048;
        Thu, 17 Sep 2020 06:29:04 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>,
        Lukas Bartosik <lbartosik@marvell.com>
Subject: [PATCH v3,net-next,3/4] drivers: crypto: add support for OCTEONTX2 CPT engine
Date:   Thu, 17 Sep 2020 18:58:34 +0530
Message-ID: <20200917132835.28325-4-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200917132835.28325-1-schalla@marvell.com>
References: <20200917132835.28325-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_09:2020-09-16,2020-09-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the cryptographic acceleration unit (CPT) on
OcteonTX2 CN96XX SoC.

Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Lukas Bartosik <lbartosik@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/Kconfig                |   13 +
 drivers/crypto/marvell/Makefile               |    1 +
 drivers/crypto/marvell/octeontx2/Makefile     |    7 +
 .../marvell/octeontx2/otx2_cpt_common.h       |   53 +
 .../marvell/octeontx2/otx2_cpt_hw_types.h     |  462 ++++
 .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  286 +++
 .../marvell/octeontx2/otx2_cpt_mbox_common.h  |  100 +
 .../marvell/octeontx2/otx2_cpt_reqmgr.h       |   76 +
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  342 +++
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   79 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |  598 +++++
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |  694 ++++++
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 2173 +++++++++++++++++
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |  180 ++
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   24 +
 15 files changed, 5088 insertions(+)
 create mode 100644 drivers/crypto/marvell/octeontx2/Makefile
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf.h

diff --git a/drivers/crypto/marvell/Kconfig b/drivers/crypto/marvell/Kconfig
index 13063384f958..9c4001105cb6 100644
--- a/drivers/crypto/marvell/Kconfig
+++ b/drivers/crypto/marvell/Kconfig
@@ -35,3 +35,16 @@ config CRYPTO_DEV_OCTEONTX_CPT
 
 		To compile this driver as module, choose M here:
 		the modules will be called octeontx-cpt and octeontx-cptvf
+
+config CRYPTO_DEV_OCTEONTX2_CPT
+	tristate "Support for Marvell OcteonTX2 CPT driver"
+	depends on ARM64 || COMPILE_TEST
+	depends on PCI_MSI && 64BIT
+	select OCTEONTX2_MBOX
+	select CRYPTO_DEV_MARVELL
+	help
+		This driver allows you to utilize the Marvell Cryptographic
+		Accelerator Unit(CPT) found in OcteonTX2 series of processors.
+
+		To compile this driver as module, choose M here:
+		the modules will be called octeontx2-cpt and octeontx2-cptvf
diff --git a/drivers/crypto/marvell/Makefile b/drivers/crypto/marvell/Makefile
index 6c6a1519b0f1..39db6d9c0aaf 100644
--- a/drivers/crypto/marvell/Makefile
+++ b/drivers/crypto/marvell/Makefile
@@ -2,3 +2,4 @@
 
 obj-$(CONFIG_CRYPTO_DEV_MARVELL_CESA) += cesa/
 obj-$(CONFIG_CRYPTO_DEV_OCTEONTX_CPT) += octeontx/
+obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += octeontx2/
diff --git a/drivers/crypto/marvell/octeontx2/Makefile b/drivers/crypto/marvell/octeontx2/Makefile
new file mode 100644
index 000000000000..d5d8f962bbb3
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += octeontx2-cpt.o
+
+octeontx2-cpt-objs := otx2_cptpf_main.o otx2_cptpf_mbox.o otx2_cptpf_ucode.o \
+		      otx2_cpt_mbox_common.o
+
+ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
new file mode 100644
index 000000000000..00cd53448f8e
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef __OTX2_CPT_COMMON_H
+#define __OTX2_CPT_COMMON_H
+
+#include <linux/pci.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/crypto.h>
+#include "otx2_cpt_hw_types.h"
+#include "rvu.h"
+
+#define OTX2_CPT_MAX_VFS_NUM 128
+#define OTX2_CPT_MAX_LFS_NUM 64
+
+#define OTX2_CPT_RVU_PFFUNC(pf, func)	\
+	((((pf) & RVU_PFVF_PF_MASK) << RVU_PFVF_PF_SHIFT) | \
+	(((func) & RVU_PFVF_FUNC_MASK) << RVU_PFVF_FUNC_SHIFT))
+
+#define OTX2_CPT_RVU_FUNC_ADDR_S(blk, slot, offs) \
+		(((blk) << 20) | ((slot) << 12) | (offs))
+
+#define OTX2_CPT_DMA_MINALIGN 128
+#define OTX2_CPT_INVALID_CRYPTO_ENG_GRP 0xFF
+
+#define OTX2_CPT_NAME_LENGTH 64
+
+#define BAD_OTX2_CPT_ENG_TYPE OTX2_CPT_MAX_ENG_TYPES
+
+enum otx2_cpt_eng_type {
+	OTX2_CPT_AE_TYPES = 1,
+	OTX2_CPT_SE_TYPES = 2,
+	OTX2_CPT_IE_TYPES = 3,
+	OTX2_CPT_MAX_ENG_TYPES,
+};
+
+static inline void otx2_cpt_write64(void __iomem *reg_base, u64 blk, u64 slot,
+				    u64 offs, u64 val)
+{
+	writeq_relaxed(val, reg_base +
+		       OTX2_CPT_RVU_FUNC_ADDR_S(blk, slot, offs));
+}
+
+static inline u64 otx2_cpt_read64(void __iomem *reg_base, u64 blk, u64 slot,
+				  u64 offs)
+{
+	return readq_relaxed(reg_base +
+			     OTX2_CPT_RVU_FUNC_ADDR_S(blk, slot, offs));
+}
+#endif /* __OTX2_CPT_COMMON_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
new file mode 100644
index 000000000000..d927f1f0f07f
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
@@ -0,0 +1,462 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef __OTX2_CPT_HW_TYPES_H
+#define __OTX2_CPT_HW_TYPES_H
+
+#include <linux/types.h>
+
+/* Device IDs */
+#define OTX2_CPT_PCI_PF_DEVICE_ID 0xA0FD
+#define OTX2_CPT_PCI_VF_DEVICE_ID 0xA0FE
+
+/* Mailbox interrupts offset */
+#define OTX2_CPT_PF_MBOX_INT	6
+#define OTX2_CPT_PF_INT_VEC_E_MBOXX(x, a) ((x) + (a))
+
+/* Number of MSIX supported in PF */
+#define OTX2_CPT_PF_MSIX_VECTORS 7
+
+/* Maximum supported microcode groups */
+#define OTX2_CPT_MAX_ENGINE_GROUPS 8
+
+/* CPT instruction size in bytes */
+#define OTX2_CPT_INST_SIZE	64
+/*
+ * CPT VF MSIX vectors and their offsets
+ */
+#define OTX2_CPT_VF_MSIX_VECTORS 1
+#define OTX2_CPT_VF_INTR_MBOX_MASK BIT(0)
+
+/* CPT LF MSIX vectors */
+#define OTX2_CPT_LF_MSIX_VECTORS 2
+
+/* OcteonTX2 CPT PF registers */
+#define OTX2_CPT_PF_CONSTANTS           (0x0)
+#define OTX2_CPT_PF_RESET               (0x100)
+#define OTX2_CPT_PF_DIAG                (0x120)
+#define OTX2_CPT_PF_BIST_STATUS         (0x160)
+#define OTX2_CPT_PF_ECC0_CTL            (0x200)
+#define OTX2_CPT_PF_ECC0_FLIP           (0x210)
+#define OTX2_CPT_PF_ECC0_INT            (0x220)
+#define OTX2_CPT_PF_ECC0_INT_W1S        (0x230)
+#define OTX2_CPT_PF_ECC0_ENA_W1S        (0x240)
+#define OTX2_CPT_PF_ECC0_ENA_W1C        (0x250)
+#define OTX2_CPT_PF_MBOX_INTX(b)        (0x400 | (b) << 3)
+#define OTX2_CPT_PF_MBOX_INT_W1SX(b)    (0x420 | (b) << 3)
+#define OTX2_CPT_PF_MBOX_ENA_W1CX(b)    (0x440 | (b) << 3)
+#define OTX2_CPT_PF_MBOX_ENA_W1SX(b)    (0x460 | (b) << 3)
+#define OTX2_CPT_PF_EXEC_INT            (0x500)
+#define OTX2_CPT_PF_EXEC_INT_W1S        (0x520)
+#define OTX2_CPT_PF_EXEC_ENA_W1C        (0x540)
+#define OTX2_CPT_PF_EXEC_ENA_W1S        (0x560)
+#define OTX2_CPT_PF_GX_EN(b)            (0x600 | (b) << 3)
+#define OTX2_CPT_PF_EXEC_INFO           (0x700)
+#define OTX2_CPT_PF_EXEC_BUSY           (0x800)
+#define OTX2_CPT_PF_EXEC_INFO0          (0x900)
+#define OTX2_CPT_PF_EXEC_INFO1          (0x910)
+#define OTX2_CPT_PF_INST_REQ_PC         (0x10000)
+#define OTX2_CPT_PF_INST_LATENCY_PC     (0x10020)
+#define OTX2_CPT_PF_RD_REQ_PC           (0x10040)
+#define OTX2_CPT_PF_RD_LATENCY_PC       (0x10060)
+#define OTX2_CPT_PF_RD_UC_PC            (0x10080)
+#define OTX2_CPT_PF_ACTIVE_CYCLES_PC    (0x10100)
+#define OTX2_CPT_PF_EXE_CTL             (0x4000000)
+#define OTX2_CPT_PF_EXE_STATUS          (0x4000008)
+#define OTX2_CPT_PF_EXE_CLK             (0x4000010)
+#define OTX2_CPT_PF_EXE_DBG_CTL         (0x4000018)
+#define OTX2_CPT_PF_EXE_DBG_DATA        (0x4000020)
+#define OTX2_CPT_PF_EXE_BIST_STATUS     (0x4000028)
+#define OTX2_CPT_PF_EXE_REQ_TIMER       (0x4000030)
+#define OTX2_CPT_PF_EXE_MEM_CTL         (0x4000038)
+#define OTX2_CPT_PF_EXE_PERF_CTL        (0x4001000)
+#define OTX2_CPT_PF_EXE_DBG_CNTX(b)     (0x4001100 | (b) << 3)
+#define OTX2_CPT_PF_EXE_PERF_EVENT_CNT  (0x4001180)
+#define OTX2_CPT_PF_EXE_EPCI_INBX_CNT(b)  (0x4001200 | (b) << 3)
+#define OTX2_CPT_PF_EXE_EPCI_OUTBX_CNT(b) (0x4001240 | (b) << 3)
+#define OTX2_CPT_PF_ENGX_UCODE_BASE(b)  (0x4002000 | (b) << 3)
+#define OTX2_CPT_PF_QX_CTL(b)           (0x8000000 | (b) << 20)
+#define OTX2_CPT_PF_QX_GMCTL(b)         (0x8000020 | (b) << 20)
+#define OTX2_CPT_PF_QX_CTL2(b)          (0x8000100 | (b) << 20)
+#define OTX2_CPT_PF_VFX_MBOXX(b, c)     (0x8001000 | (b) << 20 | \
+					 (c) << 8)
+
+/* OcteonTX2 CPT LF registers */
+#define OTX2_CPT_LF_CTL                 (0x10)
+#define OTX2_CPT_LF_DONE_WAIT           (0x30)
+#define OTX2_CPT_LF_INPROG              (0x40)
+#define OTX2_CPT_LF_DONE                (0x50)
+#define OTX2_CPT_LF_DONE_ACK            (0x60)
+#define OTX2_CPT_LF_DONE_INT_ENA_W1S    (0x90)
+#define OTX2_CPT_LF_DONE_INT_ENA_W1C    (0xa0)
+#define OTX2_CPT_LF_MISC_INT            (0xb0)
+#define OTX2_CPT_LF_MISC_INT_W1S        (0xc0)
+#define OTX2_CPT_LF_MISC_INT_ENA_W1S    (0xd0)
+#define OTX2_CPT_LF_MISC_INT_ENA_W1C    (0xe0)
+#define OTX2_CPT_LF_Q_BASE              (0xf0)
+#define OTX2_CPT_LF_Q_SIZE              (0x100)
+#define OTX2_CPT_LF_Q_INST_PTR          (0x110)
+#define OTX2_CPT_LF_Q_GRP_PTR           (0x120)
+#define OTX2_CPT_LF_NQX(a)              (0x400 | (a) << 3)
+#define OTX2_CPT_RVU_FUNC_BLKADDR_SHIFT 20
+/* LMT LF registers */
+#define OTX2_CPT_LMT_LFBASE             BIT_ULL(OTX2_CPT_RVU_FUNC_BLKADDR_SHIFT)
+#define OTX2_CPT_LMT_LF_LMTLINEX(a)     (OTX2_CPT_LMT_LFBASE | 0x000 | \
+					 (a) << 12)
+
+/*
+ * Enumeration otx2_cpt_ucode_error_code_e
+ *
+ * Enumerates ucode errors
+ */
+enum otx2_cpt_ucode_comp_code_e {
+	OTX2_CPT_UCC_SUCCESS = 0x00,
+	OTX2_CPT_UCC_INVALID_OPCODE = 0x01,
+
+	/* Scatter gather */
+	OTX2_CPT_UCC_SG_WRITE_LENGTH = 0x02,
+	OTX2_CPT_UCC_SG_LIST = 0x03,
+	OTX2_CPT_UCC_SG_NOT_SUPPORTED = 0x04,
+
+};
+
+/*
+ * Enumeration otx2_cpt_comp_e
+ *
+ * OcteonTX2 CPT Completion Enumeration
+ * Enumerates the values of CPT_RES_S[COMPCODE].
+ */
+enum otx2_cpt_comp_e {
+	OTX2_CPT_COMP_E_NOTDONE = 0x00,
+	OTX2_CPT_COMP_E_GOOD = 0x01,
+	OTX2_CPT_COMP_E_FAULT = 0x02,
+	OTX2_CPT_COMP_E_HWERR = 0x04,
+	OTX2_CPT_COMP_E_INSTERR = 0x05,
+	OTX2_CPT_COMP_E_LAST_ENTRY = 0x06
+};
+
+/*
+ * Enumeration otx2_cpt_vf_int_vec_e
+ *
+ * OcteonTX2 CPT VF MSI-X Vector Enumeration
+ * Enumerates the MSI-X interrupt vectors.
+ */
+enum otx2_cpt_vf_int_vec_e {
+	OTX2_CPT_VF_INT_VEC_E_MBOX = 0x00
+};
+
+/*
+ * Enumeration otx2_cpt_lf_int_vec_e
+ *
+ * OcteonTX2 CPT LF MSI-X Vector Enumeration
+ * Enumerates the MSI-X interrupt vectors.
+ */
+enum otx2_cpt_lf_int_vec_e {
+	OTX2_CPT_LF_INT_VEC_E_MISC = 0x00,
+	OTX2_CPT_LF_INT_VEC_E_DONE = 0x01
+};
+
+/*
+ * Structure otx2_cpt_inst_s
+ *
+ * CPT Instruction Structure
+ * This structure specifies the instruction layout. Instructions are
+ * stored in memory as little-endian unless CPT()_PF_Q()_CTL[INST_BE] is set.
+ * cpt_inst_s_s
+ * Word 0
+ * doneint:1 Done interrupt.
+ *	0 = No interrupts related to this instruction.
+ *	1 = When the instruction completes, CPT()_VQ()_DONE[DONE] will be
+ *	incremented,and based on the rules described there an interrupt may
+ *	occur.
+ * Word 1
+ * res_addr [127: 64] Result IOVA.
+ *	If nonzero, specifies where to write CPT_RES_S.
+ *	If zero, no result structure will be written.
+ *	Address must be 16-byte aligned.
+ *	Bits <63:49> are ignored by hardware; software should use a
+ *	sign-extended bit <48> for forward compatibility.
+ * Word 2
+ *  grp:10 [171:162] If [WQ_PTR] is nonzero, the SSO guest-group to use when
+ *	CPT submits work SSO.
+ *	For the SSO to not discard the add-work request, FPA_PF_MAP() must map
+ *	[GRP] and CPT()_PF_Q()_GMCTL[GMID] as valid.
+ *  tt:2 [161:160] If [WQ_PTR] is nonzero, the SSO tag type to use when CPT
+ *	submits work to SSO
+ *  tag:32 [159:128] If [WQ_PTR] is nonzero, the SSO tag to use when CPT
+ *	submits work to SSO.
+ * Word 3
+ *  wq_ptr [255:192] If [WQ_PTR] is nonzero, it is a pointer to a
+ *	work-queue entry that CPT submits work to SSO after all context,
+ *	output data, and result write operations are visible to other
+ *	CNXXXX units and the cores. Bits <2:0> must be zero.
+ *	Bits <63:49> are ignored by hardware; software should
+ *	use a sign-extended bit <48> for forward compatibility.
+ *	Internal:
+ *	Bits <63:49>, <2:0> are ignored by hardware, treated as always 0x0.
+ * Word 4
+ *  ei0; [319:256] Engine instruction word 0. Passed to the AE/SE.
+ * Word 5
+ *  ei1; [383:320] Engine instruction word 1. Passed to the AE/SE.
+ * Word 6
+ *  ei2; [447:384] Engine instruction word 1. Passed to the AE/SE.
+ * Word 7
+ *  ei3; [511:448] Engine instruction word 1. Passed to the AE/SE.
+ *
+ */
+union otx2_cpt_inst_s {
+	u64 u[8];
+
+	struct {
+		/* Word 0 */
+		u64 nixtxl:3;
+		u64 doneint:1;
+		u64 nixtx_addr:60;
+		/* Word 1 */
+		u64 res_addr;
+		/* Word 2 */
+		u64 tag:32;
+		u64 tt:2;
+		u64 grp:10;
+		u64 reserved_172_175:4;
+		u64 rvu_pf_func:16;
+		/* Word 3 */
+		u64 qord:1;
+		u64 reserved_194_193:2;
+		u64 wq_ptr:61;
+		/* Word 4 */
+		u64 ei0;
+		/* Word 5 */
+		u64 ei1;
+		/* Word 6 */
+		u64 ei2;
+		/* Word 7 */
+		u64 ei3;
+	} s;
+};
+
+/*
+ * Structure otx2_cpt_res_s
+ *
+ * CPT Result Structure
+ * The CPT coprocessor writes the result structure after it completes a
+ * CPT_INST_S instruction. The result structure is exactly 16 bytes, and
+ * each instruction completion produces exactly one result structure.
+ *
+ * This structure is stored in memory as little-endian unless
+ * CPT()_PF_Q()_CTL[INST_BE] is set.
+ * cpt_res_s_s
+ * Word 0
+ *  doneint:1 [16:16] Done interrupt. This bit is copied from the
+ *	corresponding instruction's CPT_INST_S[DONEINT].
+ *  compcode:8 [7:0] Indicates completion/error status of the CPT coprocessor
+ *	for the	associated instruction, as enumerated by CPT_COMP_E.
+ *	Core software may write the memory location containing [COMPCODE] to
+ *	0x0 before ringing the doorbell, and then poll for completion by
+ *	checking for a nonzero value.
+ *	Once the core observes a nonzero [COMPCODE] value in this case,the CPT
+ *	coprocessor will have also completed L2/DRAM write operations.
+ * Word 1
+ *  reserved
+ *
+ */
+union otx2_cpt_res_s {
+	u64 u[2];
+
+	struct {
+		u64 compcode:8;
+		u64 uc_compcode:8;
+		u64 doneint:1;
+		u64 reserved_17_63:47;
+		u64 reserved_64_127;
+	} s;
+};
+
+/*
+ * Register (RVU_PF_BAR0) cpt#_af_constants1
+ *
+ * CPT AF Constants Register
+ * This register contains implementation-related parameters of CPT.
+ */
+union otx2_cptx_af_constants1 {
+	u64 u;
+	struct otx2_cptx_af_constants1_s {
+		u64 se:16;
+		u64 ie:16;
+		u64 ae:16;
+		u64 reserved_48_63:16;
+	} s;
+};
+
+/*
+ * RVU_PFVF_BAR2 - cpt_lf_misc_int
+ *
+ * This register contain the per-queue miscellaneous interrupts.
+ *
+ */
+union otx2_cptx_lf_misc_int {
+	u64 u;
+	struct otx2_cptx_lf_misc_int_s {
+		u64 reserved_0:1;
+		u64 nqerr:1;
+		u64 irde:1;
+		u64 nwrp:1;
+		u64 reserved_4:1;
+		u64 hwerr:1;
+		u64 fault:1;
+		u64 reserved_7_63:57;
+	} s;
+};
+
+/*
+ * RVU_PFVF_BAR2 - cpt_lf_misc_int_ena_w1s
+ *
+ * This register sets interrupt enable bits.
+ *
+ */
+union otx2_cptx_lf_misc_int_ena_w1s {
+	u64 u;
+	struct otx2_cptx_lf_misc_int_ena_w1s_s {
+		u64 reserved_0:1;
+		u64 nqerr:1;
+		u64 irde:1;
+		u64 nwrp:1;
+		u64 reserved_4:1;
+		u64 hwerr:1;
+		u64 fault:1;
+		u64 reserved_7_63:57;
+	} s;
+};
+
+/*
+ * RVU_PFVF_BAR2 - cpt_lf_ctl
+ *
+ * This register configures the queue.
+ *
+ * When the queue is not execution-quiescent (see CPT_LF_INPROG[EENA,INFLIGHT]),
+ * software must only write this register with [ENA]=0.
+ */
+union otx2_cptx_lf_ctl {
+	u64 u;
+	struct otx2_cptx_lf_ctl_s {
+		u64 ena:1;
+		u64 fc_ena:1;
+		u64 fc_up_crossing:1;
+		u64 reserved_3:1;
+		u64 fc_hyst_bits:4;
+		u64 reserved_8_63:56;
+	} s;
+};
+
+/*
+ * RVU_PFVF_BAR2 - cpt_lf_done_wait
+ *
+ * This register specifies the per-queue interrupt coalescing settings.
+ */
+union otx2_cptx_lf_done_wait {
+	u64 u;
+	struct otx2_cptx_lf_done_wait_s {
+		u64 num_wait:20;
+		u64 reserved_20_31:12;
+		u64 time_wait:16;
+		u64 reserved_48_63:16;
+	} s;
+};
+
+/*
+ * RVU_PFVF_BAR2 - cpt_lf_done
+ *
+ * This register contain the per-queue instruction done count.
+ */
+union otx2_cptx_lf_done {
+	u64 u;
+	struct otx2_cptx_lf_done_s {
+		u64 done:20;
+		u64 reserved_20_63:44;
+	} s;
+};
+
+/*
+ * RVU_PFVF_BAR2 - cpt_lf_inprog
+ *
+ * These registers contain the per-queue instruction in flight registers.
+ *
+ */
+union otx2_cptx_lf_inprog {
+	u64 u;
+	struct otx2_cptx_lf_inprog_s {
+		u64 inflight:9;
+		u64 reserved_9_15:7;
+		u64 eena:1;
+		u64 grp_drp:1;
+		u64 reserved_18_30:13;
+		u64 grb_partial:1;
+		u64 grb_cnt:8;
+		u64 gwb_cnt:8;
+		u64 reserved_48_63:16;
+	} s;
+};
+
+/*
+ * RVU_PFVF_BAR2 - cpt_lf_q_base
+ *
+ * CPT initializes these CSR fields to these values on any CPT_LF_Q_BASE write:
+ * _ CPT_LF_Q_INST_PTR[XQ_XOR]=0.
+ * _ CPT_LF_Q_INST_PTR[NQ_PTR]=2.
+ * _ CPT_LF_Q_INST_PTR[DQ_PTR]=2.
+ * _ CPT_LF_Q_GRP_PTR[XQ_XOR]=0.
+ * _ CPT_LF_Q_GRP_PTR[NQ_PTR]=1.
+ * _ CPT_LF_Q_GRP_PTR[DQ_PTR]=1.
+ */
+union otx2_cptx_lf_q_base {
+	u64 u;
+	struct otx2_cptx_lf_q_base_s {
+		u64 fault:1;
+		u64 reserved_1_6:6;
+		u64 addr:46;
+		u64 reserved_53_63:11;
+	} s;
+};
+
+/*
+ * RVU_PFVF_BAR2 - cpt_lf_q_size
+ *
+ * CPT initializes these CSR fields to these values on any CPT_LF_Q_SIZE write:
+ * _ CPT_LF_Q_INST_PTR[XQ_XOR]=0.
+ * _ CPT_LF_Q_INST_PTR[NQ_PTR]=2.
+ * _ CPT_LF_Q_INST_PTR[DQ_PTR]=2.
+ * _ CPT_LF_Q_GRP_PTR[XQ_XOR]=0.
+ * _ CPT_LF_Q_GRP_PTR[NQ_PTR]=1.
+ * _ CPT_LF_Q_GRP_PTR[DQ_PTR]=1.
+ */
+union otx2_cptx_lf_q_size {
+	u64 u;
+	struct otx2_cptx_lf_q_size_s {
+		u64 size_div40:15;
+		u64 reserved_15_63:49;
+	} s;
+};
+
+/*
+ * RVU_PF_BAR0 - cpt_af_lf_ctl
+ *
+ * This register configures queues. This register should be written only
+ * when the queue is execution-quiescent (see CPT_LF_INPROG[INFLIGHT]).
+ */
+union otx2_cptx_af_lf_ctrl {
+	u64 u;
+	struct otx2_cptx_af_lf_ctrl_s {
+		u64 pri:1;
+		u64 reserved_1_8:8;
+		u64 pf_func_inst:1;
+		u64 cont_err:1;
+		u64 reserved_11_15:5;
+		u64 nixtx_en:1;
+		u64 reserved_17_47:31;
+		u64 grp:8;
+		u64 reserved_56_63:8;
+	} s;
+};
+
+#endif /* __OTX2_CPT_HW_TYPES_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
new file mode 100644
index 000000000000..1a41d1318da9
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
@@ -0,0 +1,286 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include "otx2_cpt_mbox_common.h"
+
+static inline struct otx2_mbox *get_mbox(struct pci_dev *pdev)
+{
+	struct otx2_cptpf_dev *cptpf;
+	struct otx2_cptvf_dev *cptvf;
+
+	if (pdev->is_physfn) {
+		cptpf = pci_get_drvdata(pdev);
+		return &cptpf->afpf_mbox;
+	}
+	cptvf = pci_get_drvdata(pdev);
+	return &cptvf->pfvf_mbox;
+}
+
+static inline int get_pf_id(struct pci_dev *pdev)
+{
+	struct otx2_cptpf_dev *cptpf;
+
+	if (pdev->is_physfn) {
+		cptpf = pci_get_drvdata(pdev);
+		return cptpf->pf_id;
+	}
+	return 0;
+}
+
+static inline int get_vf_id(struct pci_dev *pdev)
+{
+	struct otx2_cptvf_dev *cptvf;
+
+	if (pdev->is_virtfn) {
+		cptvf = pci_get_drvdata(pdev);
+		return cptvf->vf_id;
+	}
+	return 0;
+}
+
+char *otx2_cpt_get_mbox_opcode_str(int msg_opcode)
+{
+	char *str = "Unknown";
+
+	switch (msg_opcode) {
+	case MBOX_MSG_READY:
+		str = "READY";
+		break;
+
+	case MBOX_MSG_ATTACH_RESOURCES:
+		str = "ATTACH_RESOURCES";
+		break;
+
+	case MBOX_MSG_DETACH_RESOURCES:
+		str = "DETACH_RESOURCES";
+		break;
+
+	case MBOX_MSG_MSIX_OFFSET:
+		str = "MSIX_OFFSET";
+		break;
+
+	case MBOX_MSG_CPT_RD_WR_REGISTER:
+		str = "RD_WR_REGISTER";
+		break;
+
+	case MBOX_MSG_GET_ENG_GRP_NUM:
+		str = "GET_ENG_GRP_NUM";
+		break;
+
+	case MBOX_MSG_RX_INLINE_IPSEC_LF_CFG:
+		str = "RX_INLINE_IPSEC_LF_CFG";
+		break;
+
+	case MBOX_MSG_GET_CAPS:
+		str = "GET_CAPS";
+		break;
+
+	case MBOX_MSG_GET_KCRYPTO_LIMITS:
+		str = "GET_KCRYPTO_LIMITS";
+		break;
+	}
+	return str;
+}
+
+int otx2_cpt_send_mbox_msg(struct pci_dev *pdev)
+{
+	struct otx2_mbox *mbox = get_mbox(pdev);
+	int ret;
+
+	otx2_mbox_msg_send(mbox, 0);
+	ret = otx2_mbox_wait_for_rsp(mbox, 0);
+	if (ret == -EIO) {
+		dev_err(&pdev->dev, "RVU MBOX timeout.\n");
+		return ret;
+	} else if (ret) {
+		dev_err(&pdev->dev, "RVU MBOX error: %d.\n", ret);
+		return -EFAULT;
+	}
+	return ret;
+}
+
+int otx2_cpt_send_ready_msg(struct pci_dev *pdev)
+{
+	struct otx2_mbox *mbox = get_mbox(pdev);
+	struct mbox_msghdr *req;
+
+	req = otx2_mbox_alloc_msg_rsp(mbox, 0, sizeof(*req),
+				      sizeof(struct ready_msg_rsp));
+
+	if (req == NULL) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+
+	req->id = MBOX_MSG_READY;
+	req->sig = OTX2_MBOX_REQ_SIG;
+	req->pcifunc = OTX2_CPT_RVU_PFFUNC(get_pf_id(pdev), get_vf_id(pdev));
+
+	return otx2_cpt_send_mbox_msg(pdev);
+}
+
+int otx2_cpt_attach_rscrs_msg(struct pci_dev *pdev)
+{
+	struct otx2_cptlfs_info *lfs = otx2_cpt_get_lfs_info(pdev);
+	struct otx2_mbox *mbox = get_mbox(pdev);
+	struct rsrc_attach *req;
+	int ret;
+
+	req = (struct rsrc_attach *)
+			otx2_mbox_alloc_msg_rsp(mbox, 0, sizeof(*req),
+						sizeof(struct msg_rsp));
+	if (req == NULL) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+
+	req->hdr.id = MBOX_MSG_ATTACH_RESOURCES;
+	req->hdr.sig = OTX2_MBOX_REQ_SIG;
+	req->hdr.pcifunc = OTX2_CPT_RVU_PFFUNC(get_pf_id(pdev),
+					       get_vf_id(pdev));
+	req->cptlfs = lfs->lfs_num;
+	ret = otx2_cpt_send_mbox_msg(pdev);
+	if (ret)
+		return ret;
+
+	if (!lfs->are_lfs_attached)
+		ret = -EINVAL;
+
+	return ret;
+}
+
+int otx2_cpt_detach_rsrcs_msg(struct pci_dev *pdev)
+{
+	struct otx2_cptlfs_info *lfs = otx2_cpt_get_lfs_info(pdev);
+	struct otx2_mbox *mbox = get_mbox(pdev);
+	struct rsrc_detach *req;
+	int ret;
+
+	req = (struct rsrc_detach *)
+				otx2_mbox_alloc_msg_rsp(mbox, 0, sizeof(*req),
+							sizeof(struct msg_rsp));
+	if (req == NULL) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+
+	req->hdr.id = MBOX_MSG_DETACH_RESOURCES;
+	req->hdr.sig = OTX2_MBOX_REQ_SIG;
+	req->hdr.pcifunc = OTX2_CPT_RVU_PFFUNC(get_pf_id(pdev),
+					       get_vf_id(pdev));
+	ret = otx2_cpt_send_mbox_msg(pdev);
+	if (ret)
+		return ret;
+
+	if (lfs->are_lfs_attached)
+		ret = -EINVAL;
+
+	return ret;
+}
+
+int otx2_cpt_msix_offset_msg(struct pci_dev *pdev)
+{
+	struct otx2_cptlfs_info *lfs = otx2_cpt_get_lfs_info(pdev);
+	struct otx2_mbox *mbox = get_mbox(pdev);
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
+	req->pcifunc = OTX2_CPT_RVU_PFFUNC(get_pf_id(pdev), get_vf_id(pdev));
+	ret = otx2_cpt_send_mbox_msg(pdev);
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
+
+int otx2_cpt_send_af_reg_requests(struct pci_dev *pdev)
+{
+	return otx2_cpt_send_mbox_msg(pdev);
+}
+
+int otx2_cpt_add_read_af_reg(struct pci_dev *pdev, u64 reg, u64 *val)
+{
+	struct otx2_mbox *mbox = get_mbox(pdev);
+	struct cpt_rd_wr_reg_msg *reg_msg;
+
+	reg_msg = (struct cpt_rd_wr_reg_msg *)
+			otx2_mbox_alloc_msg_rsp(mbox, 0, sizeof(*reg_msg),
+						sizeof(*reg_msg));
+	if (reg_msg == NULL) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+
+	reg_msg->hdr.id = MBOX_MSG_CPT_RD_WR_REGISTER;
+	reg_msg->hdr.sig = OTX2_MBOX_REQ_SIG;
+	reg_msg->hdr.pcifunc = OTX2_CPT_RVU_PFFUNC(get_pf_id(pdev),
+						   get_vf_id(pdev));
+	reg_msg->is_write = 0;
+	reg_msg->reg_offset = reg;
+	reg_msg->ret_val = val;
+
+	return 0;
+}
+
+int otx2_cpt_add_write_af_reg(struct pci_dev *pdev, u64 reg, u64 val)
+{
+	struct otx2_mbox *mbox = get_mbox(pdev);
+	struct cpt_rd_wr_reg_msg *reg_msg;
+
+	reg_msg = (struct cpt_rd_wr_reg_msg *)
+			otx2_mbox_alloc_msg_rsp(mbox, 0, sizeof(*reg_msg),
+						sizeof(*reg_msg));
+	if (reg_msg == NULL) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+
+	reg_msg->hdr.id = MBOX_MSG_CPT_RD_WR_REGISTER;
+	reg_msg->hdr.sig = OTX2_MBOX_REQ_SIG;
+	reg_msg->hdr.pcifunc = OTX2_CPT_RVU_PFFUNC(get_pf_id(pdev),
+						   get_vf_id(pdev));
+	reg_msg->is_write = 1;
+	reg_msg->reg_offset = reg;
+	reg_msg->val = val;
+
+	return 0;
+}
+
+int otx2_cpt_read_af_reg(struct pci_dev *pdev, u64 reg, u64 *val)
+{
+	int ret;
+
+	ret = otx2_cpt_add_read_af_reg(pdev, reg, val);
+	if (ret)
+		return ret;
+
+	return otx2_cpt_send_mbox_msg(pdev);
+}
+
+int otx2_cpt_write_af_reg(struct pci_dev *pdev, u64 reg, u64 val)
+{
+	int ret;
+
+	ret = otx2_cpt_add_write_af_reg(pdev, reg, val);
+	if (ret)
+		return ret;
+
+	return otx2_cpt_send_mbox_msg(pdev);
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.h
new file mode 100644
index 000000000000..f92b76bf69e3
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.h
@@ -0,0 +1,100 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef __OTX2_CPT_MBOX_COMMON_H
+#define __OTX2_CPT_MBOX_COMMON_H
+
+#include "otx2_cptpf.h"
+#include "otx2_cptvf.h"
+
+/* Take mbox id from end of CPT mbox range in AF (range 0xA00 - 0xBFF) */
+#define MBOX_MSG_RX_INLINE_IPSEC_LF_CFG 0xBFE
+#define MBOX_MSG_GET_ENG_GRP_NUM        0xBFF
+#define MBOX_MSG_GET_CAPS               0xBFD
+#define MBOX_MSG_GET_KCRYPTO_LIMITS     0xBFC
+
+/*
+ * Message request and response to get engine group number
+ * which has attached a given type of engines (SE, AE, IE)
+ * This messages are only used between CPT PF <-> CPT VF
+ */
+struct otx2_cpt_eng_grp_num_msg {
+	struct mbox_msghdr hdr;
+	u8 eng_type;
+};
+
+struct otx2_cpt_eng_grp_num_rsp {
+	struct mbox_msghdr hdr;
+	u8 eng_type;
+	u8 eng_grp_num;
+};
+
+/*
+ * Message request to config cpt lf for inline inbound ipsec.
+ * This message is only used between CPT PF <-> CPT VF
+ */
+struct otx2_cpt_rx_inline_lf_cfg {
+	struct mbox_msghdr hdr;
+	u16 sso_pf_func;
+};
+
+/*
+ * Message request and response to get HW capabilities for each
+ * engine type (SE, IE, AE).
+ * This messages are only used between CPT PF <-> CPT VF
+ */
+struct otx2_cpt_caps_msg {
+	struct mbox_msghdr hdr;
+};
+
+struct otx2_cpt_caps_rsp {
+	struct mbox_msghdr hdr;
+	u16 cpt_pf_drv_version;
+	u8 cpt_revision;
+	union otx2_cpt_eng_caps eng_caps[OTX2_CPT_MAX_ENG_TYPES];
+};
+
+/*
+ * Message request and response to get kernel crypto limits
+ * This messages are only used between CPT PF <-> CPT VF
+ */
+struct otx2_cpt_kcrypto_limits_msg {
+	struct mbox_msghdr hdr;
+};
+
+struct otx2_cpt_kcrypto_limits_rsp {
+	struct mbox_msghdr hdr;
+	u8 kcrypto_limits;
+};
+
+static inline struct otx2_cptlfs_info *
+		     otx2_cpt_get_lfs_info(struct pci_dev *pdev)
+{
+	struct otx2_cptpf_dev *cptpf;
+	struct otx2_cptvf_dev *cptvf;
+
+	if (pdev->is_physfn) {
+		cptpf = (struct otx2_cptpf_dev *) pci_get_drvdata(pdev);
+		return &cptpf->lfs;
+	}
+
+	cptvf = (struct otx2_cptvf_dev *) pci_get_drvdata(pdev);
+	return &cptvf->lfs;
+}
+
+int otx2_cpt_send_ready_msg(struct pci_dev *pdev);
+int otx2_cpt_attach_rscrs_msg(struct pci_dev *pdev);
+int otx2_cpt_detach_rsrcs_msg(struct pci_dev *pdev);
+int otx2_cpt_msix_offset_msg(struct pci_dev *pdev);
+
+int otx2_cpt_send_af_reg_requests(struct pci_dev *pdev);
+int otx2_cpt_add_read_af_reg(struct pci_dev *pdev, u64 reg, u64 *val);
+int otx2_cpt_add_write_af_reg(struct pci_dev *pdev, u64 reg, u64 val);
+int otx2_cpt_read_af_reg(struct pci_dev *pdev, u64 reg, u64 *val);
+int otx2_cpt_write_af_reg(struct pci_dev *pdev, u64 reg, u64 val);
+
+int otx2_cpt_send_mbox_msg(struct pci_dev *pdev);
+char *otx2_cpt_get_mbox_opcode_str(int msg_opcode);
+
+#endif /* __OTX2_CPT_MBOX_COMMON_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
new file mode 100644
index 000000000000..1b5f8e272c8d
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef __OTX2_CPT_REQMGR_H
+#define __OTX2_CPT_REQMGR_H
+
+#include "otx2_cpt_common.h"
+
+/* Completion code size and initial value */
+#define OTX2_CPT_COMPLETION_CODE_SIZE 8
+#define OTX2_CPT_COMPLETION_CODE_INIT OTX2_CPT_COMP_E_NOTDONE
+
+union otx2_cpt_opcode {
+	u16 flags;
+	struct {
+		u8 major;
+		u8 minor;
+	} s;
+};
+
+struct otx2_cptvf_request {
+	u32 param1;
+	u32 param2;
+	u16 dlen;
+	union otx2_cpt_opcode opcode;
+};
+
+/*
+ * CPT_INST_S software command definitions
+ * Words EI (0-3)
+ */
+union otx2_cpt_iq_cmd_word0 {
+	u64 u;
+	struct {
+		__be16 opcode;
+		__be16 param1;
+		__be16 param2;
+		__be16 dlen;
+	} s;
+};
+
+union otx2_cpt_iq_cmd_word3 {
+	u64 u;
+	struct {
+		u64 cptr:61;
+		u64 grp:3;
+	} s;
+};
+
+struct otx2_cpt_iq_command {
+	union otx2_cpt_iq_cmd_word0 cmd;
+	u64 dptr;
+	u64 rptr;
+	union otx2_cpt_iq_cmd_word3 cptr;
+};
+
+struct otx2_cpt_pending_entry {
+	void *completion_addr;	/* Completion address */
+	void *info;
+	/* Kernel async request callback */
+	void (*callback)(int status, void *arg1, void *arg2);
+	struct crypto_async_request *areq; /* Async request callback arg */
+	u8 resume_sender;	/* Notify sender to resume sending requests */
+	u8 busy;		/* Entry status (free/busy) */
+};
+
+struct otx2_cpt_pending_queue {
+	struct otx2_cpt_pending_entry *head; /* Head of the queue */
+	u32 front;		/* Process work from here */
+	u32 rear;		/* Append new work here */
+	u32 pending_count;	/* Pending requests count */
+	u32 qlen;		/* Queue length */
+	spinlock_t lock;	/* Queue lock */
+};
+#endif /* __OTX2_CPT_REQMGR_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
new file mode 100644
index 000000000000..353ab5d2cd5b
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
@@ -0,0 +1,342 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef __OTX2_CPTLF_H
+#define __OTX2_CPTLF_H
+
+#include <linux/soc/marvell/octeontx2/asm.h>
+#include "otx2_cpt_reqmgr.h"
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
+/* Queue priority */
+#define OTX2_CPT_QUEUE_HI_PRIO  0x1
+#define OTX2_CPT_QUEUE_LOW_PRIO 0x0
+
+
+struct otx2_cptlf_sysfs_cfg {
+	char name[OTX2_CPT_NAME_LENGTH];
+	struct device_attribute eng_grps_mask_attr;
+	struct device_attribute coalesc_tw_attr;
+	struct device_attribute coalesc_nw_attr;
+	struct device_attribute prio_attr;
+#define OTX2_CPT_ATTRS_NUM 5
+	struct attribute *attrs[OTX2_CPT_ATTRS_NUM];
+	struct attribute_group attr_grp;
+	bool is_sysfs_grp_created;
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
+	struct otx2_cptlf_sysfs_cfg sysfs_cfg;  /* LF sysfs config entries */
+	void __iomem *lmtline;                  /* Address of LMTLINE */
+	void __iomem *ioreg;                    /* LMTLINE send register */
+	int msix_offset;                        /* MSI-X interrupts offset */
+	cpumask_var_t affinity_mask;            /* IRQs affinity mask */
+	u8 irq_name[OTX2_CPT_LF_MSIX_VECTORS][32];/* Interrupts name */
+	u8 is_irq_reg[OTX2_CPT_LF_MSIX_VECTORS];  /* Is interrupt registered */
+	u8 slot;                                /* Slot number of this LF */
+
+	struct otx2_cpt_inst_queue iqueue;/* Instruction queue */
+	struct otx2_cpt_pending_queue pqueue; /* Pending queue */
+	struct otx2_cptlf_wqe *wqe;       /* Tasklet work info */
+};
+
+struct otx2_cptlfs_info {
+	/* Registers start address of VF/PF LFs are attached to */
+	void __iomem *reg_base;
+	struct pci_dev *pdev;   /* Device LFs are attached to */
+	struct otx2_cptlf_info lf[OTX2_CPT_MAX_LFS_NUM];
+	u8 kcrypto_eng_grp_num;	/* Kernel crypto engine group number */
+	u8 are_lfs_attached;	/* Whether CPT LFs are attached */
+	u8 lfs_num;		/* Number of CPT LFs */
+	u8 kcrypto_limits;      /* Kernel crypto limits */
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
+
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
+static inline void otx2_cpt_fill_inst(union otx2_cpt_inst_s *cptinst,
+				      struct otx2_cpt_iq_command *iq_cmd,
+				      u64 comp_baddr)
+{
+	cptinst->u[0] = 0x0;
+	cptinst->s.doneint = true;
+	cptinst->s.res_addr = comp_baddr;
+	cptinst->u[2] = 0x0;
+	cptinst->u[3] = 0x0;
+	cptinst->s.ei0 = iq_cmd->cmd.u;
+	cptinst->s.ei1 = iq_cmd->dptr;
+	cptinst->s.ei2 = iq_cmd->rptr;
+	cptinst->s.ei3 = iq_cmd->cptr.u;
+}
+
+/*
+ * On OcteonTX2 platform the parameter insts_num is used as a count of
+ * instructions to be enqueued. The valid values for insts_num are:
+ * 1 - 1 CPT instruction will be enqueued during LMTST operation
+ * 2 - 2 CPT instructions will be enqueued during LMTST operation
+ */
+static inline void otx2_cpt_send_cmd(union otx2_cpt_inst_s *cptinst,
+				     u32 insts_num, struct otx2_cptlf_info *lf)
+{
+	void __iomem *lmtline = lf->lmtline;
+	long ret;
+
+	/*
+	 * Make sure memory areas pointed in CPT_INST_S
+	 * are flushed before the instruction is sent to CPT
+	 */
+	dma_wmb();
+
+	do {
+		/* Copy CPT command to LMTLINE */
+		memcpy_toio(lmtline, cptinst, insts_num * OTX2_CPT_INST_SIZE);
+
+		/*
+		 * LDEOR initiates atomic transfer to I/O device
+		 * The following will cause the LMTST to fail (the LDEOR
+		 * returns zero):
+		 * - No stores have been performed to the LMTLINE since it was
+		 * last invalidated.
+		 * - The bytes which have been stored to LMTLINE since it was
+		 * last invalidated form a pattern that is non-contiguous, does
+		 * not start at byte 0, or does not end on a 8-byte boundary.
+		 * (i.e.comprises a formation of other than 1–16 8-byte
+		 * words.)
+		 *
+		 * These rules are designed such that an operating system
+		 * context switch or hypervisor guest switch need have no
+		 * knowledge of the LMTST operations; the switch code does not
+		 * need to store to LMTCANCEL. Also note as LMTLINE data cannot
+		 * be read, there is no information leakage between processes.
+		 */
+		ret = otx2_lmt_flush(lf->ioreg);
+
+	} while (!ret);
+}
+#endif /* __OTX2_CPTLF_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
new file mode 100644
index 000000000000..d55f831ed6f5
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef __OTX2_CPTPF_H
+#define __OTX2_CPTPF_H
+
+#include "otx2_cptpf_ucode.h"
+#include "otx2_cptlf.h"
+
+struct otx2_cptpf_dev;
+struct otx2_cptvf_info {
+	struct otx2_cptpf_dev *cptpf;	/* PF pointer this VF belongs to */
+	struct work_struct vfpf_mbox_work;
+	struct pci_dev *vf_dev;
+	int vf_id;
+	int intr_idx;
+};
+
+struct otx2_cpt_kvf_limits {
+	struct device_attribute kvf_limits_attr;
+	int lfs_num; /* Number of LFs allocated for kernel VF driver */
+};
+
+/* CPT HW capabilities */
+union otx2_cpt_eng_caps {
+	u64 u;
+	struct {
+		u64 reserved_0_4:5;
+		u64 mul:1;
+		u64 sha1_sha2:1;
+		u64 chacha20:1;
+		u64 zuc_snow3g:1;
+		u64 sha3:1;
+		u64 aes:1;
+		u64 kasumi:1;
+		u64 des:1;
+		u64 crc:1;
+		u64 reserved_14_63:50;
+	};
+};
+
+struct otx2_cptpf_dev {
+	void __iomem *reg_base;		/* CPT PF registers start address */
+	void __iomem *afpf_mbox_base;	/* PF-AF mbox start address */
+	void __iomem *vfpf_mbox_base;   /* VF-PF mbox start address */
+	struct pci_dev *pdev;		/* PCI device handle */
+	struct otx2_cptvf_info vf[OTX2_CPT_MAX_VFS_NUM];
+	struct otx2_cptlfs_info lfs;	/* CPT LFs attached to this PF */
+	struct otx2_cpt_eng_grps eng_grps;/* Engine groups information */
+	/* HW capabilities for each engine type */
+	union otx2_cpt_eng_caps eng_caps[OTX2_CPT_MAX_ENG_TYPES];
+	bool is_eng_caps_discovered;
+
+	/* AF <=> PF mbox */
+	struct otx2_mbox	afpf_mbox;
+	struct work_struct	afpf_mbox_work;
+	struct workqueue_struct *afpf_mbox_wq;
+
+	/* VF <=> PF mbox */
+	struct otx2_mbox	vfpf_mbox;
+	struct workqueue_struct *vfpf_mbox_wq;
+
+	u8 pf_id;		/* RVU PF number */
+	u8 max_vfs;		/* Maximum number of VFs supported by CPT */
+	u8 enabled_vfs;		/* Number of enabled VFs */
+	u8 sso_pf_func_ovrd;	/* SSO PF_FUNC override bit */
+	u8 kvf_limits;		/* Kernel VF limits */
+};
+
+irqreturn_t otx2_cptpf_afpf_mbox_intr(int irq, void *arg);
+irqreturn_t otx2_cptpf_vfpf_mbox_intr(int irq, void *arg);
+void otx2_cptpf_afpf_mbox_handler(struct work_struct *work);
+void otx2_cptpf_vfpf_mbox_handler(struct work_struct *work);
+int otx2_cptpf_lf_init(struct otx2_cptpf_dev *cptpf, u8 eng_grp_mask,
+		       int pri, int lfs_num);
+void otx2_cptpf_lf_cleanup(struct otx2_cptlfs_info *lfs);
+
+#endif /* __OTX2_CPTPF_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
new file mode 100644
index 000000000000..8536671226ff
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -0,0 +1,598 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include <linux/firmware.h>
+#include "otx2_cpt_mbox_common.h"
+#include "rvu_reg.h"
+
+#define OTX2_CPT_DRV_NAME    "octeontx2-cpt"
+#define OTX2_CPT_DRV_STRING  "Marvell OcteonTX2 CPT Physical Function Driver"
+#define OTX2_CPT_DRV_VERSION "1.0"
+
+static void cptpf_enable_vf_flr_intrs(struct otx2_cptpf_dev *cptpf)
+{
+	/* Clear interrupt if any */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_VFFLR_INTX(0),
+			~0x0ULL);
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_VFFLR_INTX(1),
+			~0x0ULL);
+
+	/* Enable VF FLR interrupts */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFFLR_INT_ENA_W1SX(0), ~0x0ULL);
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFFLR_INT_ENA_W1SX(1), ~0x0ULL);
+}
+
+static void cptpf_disable_vf_flr_intrs(struct otx2_cptpf_dev *cptpf)
+{
+	/* Disable VF FLR interrupts */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFFLR_INT_ENA_W1CX(0), ~0x0ULL);
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFFLR_INT_ENA_W1CX(1), ~0x0ULL);
+
+	/* Clear interrupt if any */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_VFFLR_INTX(0),
+			 ~0x0ULL);
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_VFFLR_INTX(1),
+			 ~0x0ULL);
+}
+
+static void cptpf_enable_afpf_mbox_intrs(struct otx2_cptpf_dev *cptpf)
+{
+	/* Clear interrupt if any */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_INT, 0x1ULL);
+
+	/* Enable AF-PF interrupt */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_INT_ENA_W1S,
+			 0x1ULL);
+}
+
+static void cptpf_disable_afpf_mbox_intrs(struct otx2_cptpf_dev *cptpf)
+{
+	/* Disable AF-PF interrupt */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_INT_ENA_W1C,
+			 0x1ULL);
+
+	/* Clear interrupt if any */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_INT, 0x1ULL);
+}
+
+static void cptpf_enable_vfpf_mbox_intrs(struct otx2_cptpf_dev *cptpf,
+					 int numvfs)
+{
+	int ena_bits;
+
+	/* Clear any pending interrupts */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFPF_MBOX_INTX(0), ~0x0ULL);
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFPF_MBOX_INTX(1), ~0x0ULL);
+
+	/* Enable VF interrupts for VFs from 0 to 63 */
+	ena_bits = ((numvfs - 1) % 64);
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFPF_MBOX_INT_ENA_W1SX(0),
+			 GENMASK_ULL(ena_bits, 0));
+
+	if (numvfs > 64) {
+		/* Enable VF interrupts for VFs from 64 to 127 */
+		ena_bits = numvfs - 64 - 1;
+		otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+				RVU_PF_VFPF_MBOX_INT_ENA_W1SX(1),
+				GENMASK_ULL(ena_bits, 0));
+	}
+}
+
+static void cptpf_disable_vfpf_mbox_intrs(struct otx2_cptpf_dev *cptpf)
+{
+	/* Disable VF-PF interrupts */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFPF_MBOX_INT_ENA_W1CX(0), ~0x0ULL);
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFPF_MBOX_INT_ENA_W1CX(1), ~0x0ULL);
+
+	/* Clear any pending interrupts */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFPF_MBOX_INTX(0), ~0x0ULL);
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFPF_MBOX_INTX(1), ~0x0ULL);
+}
+
+static irqreturn_t cptpf_vf_flr_intr(int __always_unused irq, void *arg)
+{
+	struct otx2_cptpf_dev *cptpf = arg;
+
+	/* Clear transaction pending register */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_VFTRPENDX(0),
+			 ~0x0ULL);
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_VFTRPENDX(1),
+			 ~0x0ULL);
+
+	/* Clear interrupt if any */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_VFFLR_INTX(0),
+			 ~0x0ULL);
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_VFFLR_INTX(1),
+			 ~0x0ULL);
+
+	return IRQ_HANDLED;
+}
+
+static int cptpf_register_interrupts(struct otx2_cptpf_dev *cptpf)
+{
+	struct pci_dev *pdev = cptpf->pdev;
+	struct device *dev = &pdev->dev;
+	int ret, irq;
+	u32 num_vec;
+
+	num_vec = OTX2_CPT_PF_MSIX_VECTORS;
+
+	/* Enable MSI-X */
+	ret = pci_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSIX);
+	if (ret < 0) {
+		dev_err(dev, "Request for %d msix vectors failed\n", num_vec);
+		return ret;
+	}
+	irq = pci_irq_vector(pdev, RVU_PF_INT_VEC_VFFLR0);
+	/* Register VF FLR interrupt handler */
+	ret = devm_request_irq(dev, irq, cptpf_vf_flr_intr, 0, "CPTPF FLR0",
+			       cptpf);
+	if (ret)
+		return ret;
+
+	irq = pci_irq_vector(pdev, RVU_PF_INT_VEC_VFFLR1);
+	ret = devm_request_irq(dev, irq, cptpf_vf_flr_intr, 0,
+			       "CPTPF FLR1", cptpf);
+	if (ret)
+		return ret;
+
+	irq = pci_irq_vector(pdev, RVU_PF_INT_VEC_AFPF_MBOX);
+	/* Register AF-PF mailbox interrupt handler */
+	ret = devm_request_irq(dev, irq, otx2_cptpf_afpf_mbox_intr, 0,
+			       "CPTAFPF Mbox", cptpf);
+	if (ret)
+		return ret;
+
+	irq = pci_irq_vector(pdev, RVU_PF_INT_VEC_VFPF_MBOX0);
+	/* Register VF-PF mailbox interrupt handler */
+	ret = devm_request_irq(dev, irq, otx2_cptpf_vfpf_mbox_intr, 0,
+			       "CPTVFPF Mbox0", cptpf);
+	if (ret)
+		return ret;
+
+	irq = pci_irq_vector(pdev, RVU_PF_INT_VEC_VFPF_MBOX1);
+	ret = devm_request_irq(dev, irq, otx2_cptpf_vfpf_mbox_intr, 0,
+			       "CPTVFPF Mbox1", cptpf);
+
+	return ret;
+}
+
+static int cptpf_afpf_mbox_init(struct otx2_cptpf_dev *cptpf)
+{
+	int err;
+
+	cptpf->afpf_mbox_wq = alloc_workqueue("cpt_afpf_mailbox",
+					      WQ_UNBOUND | WQ_HIGHPRI |
+					      WQ_MEM_RECLAIM, 1);
+	if (!cptpf->afpf_mbox_wq)
+		return -ENOMEM;
+
+	err = otx2_mbox_init(&cptpf->afpf_mbox, cptpf->afpf_mbox_base,
+			     cptpf->pdev, cptpf->reg_base, MBOX_DIR_PFAF, 1);
+	if (err)
+		goto error;
+
+	INIT_WORK(&cptpf->afpf_mbox_work, otx2_cptpf_afpf_mbox_handler);
+	return 0;
+error:
+	destroy_workqueue(cptpf->afpf_mbox_wq);
+	return err;
+}
+
+static int cptpf_vfpf_mbox_init(struct otx2_cptpf_dev *cptpf, int numvfs)
+{
+	int err, i;
+
+	cptpf->vfpf_mbox_wq = alloc_workqueue("cpt_vfpf_mailbox",
+					      WQ_UNBOUND | WQ_HIGHPRI |
+					      WQ_MEM_RECLAIM, 1);
+	if (!cptpf->vfpf_mbox_wq)
+		return -ENOMEM;
+
+	err = otx2_mbox_init(&cptpf->vfpf_mbox, cptpf->vfpf_mbox_base,
+			     cptpf->pdev, cptpf->reg_base, MBOX_DIR_PFVF,
+			     numvfs);
+	if (err)
+		goto error;
+
+	for (i = 0; i < numvfs; i++) {
+		cptpf->vf[i].vf_id = i;
+		cptpf->vf[i].cptpf = cptpf;
+		cptpf->vf[i].intr_idx = i % 64;
+		INIT_WORK(&cptpf->vf[i].vfpf_mbox_work,
+			  otx2_cptpf_vfpf_mbox_handler);
+	}
+	return 0;
+error:
+	destroy_workqueue(cptpf->vfpf_mbox_wq);
+	return err;
+}
+
+static void cptpf_afpf_mbox_destroy(struct otx2_cptpf_dev *cptpf)
+{
+	destroy_workqueue(cptpf->afpf_mbox_wq);
+	otx2_mbox_destroy(&cptpf->afpf_mbox);
+}
+
+static void cptpf_vfpf_mbox_destroy(struct otx2_cptpf_dev *cptpf)
+{
+	destroy_workqueue(cptpf->vfpf_mbox_wq);
+	otx2_mbox_destroy(&cptpf->vfpf_mbox);
+}
+
+static int cptpf_device_reset(struct otx2_cptpf_dev *cptpf)
+{
+	int timeout = 10, ret;
+	u64 reg = 0;
+
+	ret = otx2_cpt_write_af_reg(cptpf->pdev, CPT_AF_BLK_RST, 0x1);
+	if (ret)
+		return ret;
+
+	do {
+		ret = otx2_cpt_read_af_reg(cptpf->pdev, CPT_AF_BLK_RST,
+					   &reg);
+		if (ret)
+			return ret;
+
+		if (!((reg >> 63) & 0x1))
+			break;
+
+		usleep_range(10000, 20000);
+		if (timeout-- < 0)
+			return -EBUSY;
+	} while (1);
+
+	return ret;
+}
+
+static int cptpf_device_init(struct otx2_cptpf_dev *cptpf)
+{
+	union otx2_cptx_af_constants1 af_cnsts1 = {0};
+	int ret = 0;
+
+	/* Reset the CPT PF device */
+	ret = cptpf_device_reset(cptpf);
+	if (ret)
+		return ret;
+
+	/* Get number of SE, IE and AE engines */
+	ret = otx2_cpt_read_af_reg(cptpf->pdev, CPT_AF_CONSTANTS1,
+				   &af_cnsts1.u);
+	if (ret)
+		return ret;
+
+	cptpf->eng_grps.avail.max_se_cnt = af_cnsts1.s.se;
+	cptpf->eng_grps.avail.max_ie_cnt = af_cnsts1.s.ie;
+	cptpf->eng_grps.avail.max_ae_cnt = af_cnsts1.s.ae;
+
+	/* Disable all cores */
+	ret = otx2_cpt_disable_all_cores(cptpf);
+
+	return ret;
+}
+
+static ssize_t sso_pf_func_ovrd_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct otx2_cptpf_dev *cptpf = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", cptpf->sso_pf_func_ovrd);
+}
+
+static ssize_t sso_pf_func_ovrd_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct otx2_cptpf_dev *cptpf = dev_get_drvdata(dev);
+	u8 sso_pf_func_ovrd;
+
+	if (kstrtou8(buf, 0, &sso_pf_func_ovrd))
+		return -EINVAL;
+
+	cptpf->sso_pf_func_ovrd = sso_pf_func_ovrd;
+
+	return count;
+}
+
+static ssize_t kvf_limits_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct otx2_cptpf_dev *cptpf = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", cptpf->kvf_limits);
+}
+
+static ssize_t kvf_limits_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct otx2_cptpf_dev *cptpf = dev_get_drvdata(dev);
+	int lfs_num;
+
+	if (kstrtoint(buf, 0, &lfs_num)) {
+		dev_err(dev, "lfs count %d must be in range [1 - %d]\n",
+			lfs_num, num_online_cpus());
+		return -EINVAL;
+	}
+	if (lfs_num < 1 || lfs_num > num_online_cpus()) {
+		dev_err(dev, "lfs count %d must be in range [1 - %d]\n",
+			lfs_num, num_online_cpus());
+		return -EINVAL;
+	}
+	cptpf->kvf_limits = lfs_num;
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(kvf_limits);
+static DEVICE_ATTR_RW(sso_pf_func_ovrd);
+
+static struct attribute *cptpf_attrs[] = {
+	&dev_attr_kvf_limits.attr,
+	&dev_attr_sso_pf_func_ovrd.attr,
+	NULL
+};
+
+static const struct attribute_group cptpf_sysfs_group = {
+	.attrs = cptpf_attrs,
+};
+
+static int cpt_is_pf_usable(struct otx2_cptpf_dev *cptpf)
+{
+	u64 rev;
+
+	rev = otx2_cpt_read64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			      RVU_PF_BLOCK_ADDRX_DISC(BLKADDR_RVUM));
+	rev = (rev >> 12) & 0xFF;
+	/*
+	 * Check if AF has setup revision for RVUM block, otherwise
+	 * driver probe should be deferred until AF driver comes up
+	 */
+	if (!rev) {
+		dev_warn(&cptpf->pdev->dev,
+			 "AF is not initialized, deferring probe\n");
+		return -EPROBE_DEFER;
+	}
+	return 0;
+}
+
+static int otx2_cptpf_sriov_configure(struct pci_dev *pdev, int numvfs)
+{
+	struct otx2_cptpf_dev *cptpf = pci_get_drvdata(pdev);
+	int ret = 0;
+
+	if (numvfs > cptpf->max_vfs)
+		numvfs = cptpf->max_vfs;
+
+	if (numvfs > 0) {
+		/* Get CPT HW capabilities using LOAD_FVC operation. */
+		ret = otx2_cpt_discover_eng_capabilities(cptpf);
+		if (ret)
+			return ret;
+		ret = otx2_cpt_try_create_default_eng_grps(cptpf->pdev,
+							   &cptpf->eng_grps);
+		if (ret)
+			return ret;
+
+		cptpf->enabled_vfs = numvfs;
+
+		ret = pci_enable_sriov(pdev, numvfs);
+		if (ret)
+			goto reset_numvfs;
+
+		otx2_cpt_set_eng_grps_is_rdonly(&cptpf->eng_grps, true);
+		try_module_get(THIS_MODULE);
+		ret = numvfs;
+	} else {
+		pci_disable_sriov(pdev);
+		otx2_cpt_set_eng_grps_is_rdonly(&cptpf->eng_grps, false);
+		module_put(THIS_MODULE);
+		cptpf->enabled_vfs = 0;
+	}
+
+	dev_notice(&cptpf->pdev->dev, "VFs enabled: %d\n", ret);
+	return ret;
+reset_numvfs:
+	cptpf->enabled_vfs = 0;
+	return ret;
+}
+
+static int otx2_cptpf_probe(struct pci_dev *pdev,
+			    const struct pci_device_id *ent)
+{
+	struct device *dev = &pdev->dev;
+	resource_size_t offset, size;
+	struct otx2_cptpf_dev *cptpf;
+	u64 vfpf_mbox_base;
+	int err;
+
+	cptpf = devm_kzalloc(dev, sizeof(*cptpf), GFP_KERNEL);
+	if (!cptpf)
+		return -ENOMEM;
+
+	pci_set_drvdata(pdev, cptpf);
+	cptpf->pdev = pdev;
+	cptpf->max_vfs = pci_sriov_get_totalvfs(pdev);
+
+	err = pcim_enable_device(pdev);
+	if (err) {
+		dev_err(dev, "Failed to enable PCI device\n");
+		goto clear_drvdata;
+	}
+
+	pci_set_master(pdev);
+
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(48));
+	if (err) {
+		dev_err(dev, "Unable to get usable DMA configuration\n");
+		goto clear_drvdata;
+	}
+
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(48));
+	if (err) {
+		dev_err(dev, "Unable to get 48-bit DMA for consistent allocations\n");
+		goto clear_drvdata;
+	}
+
+	/* Map PF's configuration registers */
+	err = pcim_iomap_regions_request_all(pdev, 1 << PCI_PF_REG_BAR_NUM,
+					     OTX2_CPT_DRV_NAME);
+	if (err) {
+		dev_err(dev, "Couldn't get PCI resources 0x%x\n", err);
+		goto clear_drvdata;
+	}
+
+	cptpf->reg_base = pcim_iomap_table(pdev)[PCI_PF_REG_BAR_NUM];
+
+	/* Check if AF driver is up, otherwise defer probe */
+	err = cpt_is_pf_usable(cptpf);
+	if (err)
+		goto clear_drvdata;
+
+	offset = pci_resource_start(pdev, PCI_MBOX_BAR_NUM);
+	size = pci_resource_len(pdev, PCI_MBOX_BAR_NUM);
+	/* Map AF-PF mailbox memory */
+	cptpf->afpf_mbox_base = devm_ioremap_wc(dev, offset, size);
+	if (!cptpf->afpf_mbox_base) {
+		dev_err(&pdev->dev, "Unable to map BAR4\n");
+		err = -ENODEV;
+		goto clear_drvdata;
+	}
+
+	/* Map VF-PF mailbox memory */
+	vfpf_mbox_base = readq(cptpf->reg_base + RVU_PF_VF_BAR4_ADDR);
+	if (!vfpf_mbox_base) {
+		dev_err(&pdev->dev, "VF-PF mailbox address not configured\n");
+		err = -ENOMEM;
+		goto clear_drvdata;
+	}
+	cptpf->vfpf_mbox_base = devm_ioremap_wc(dev, vfpf_mbox_base,
+					   MBOX_SIZE * cptpf->max_vfs);
+	if (!cptpf->vfpf_mbox_base) {
+		dev_err(&pdev->dev,
+			"Mapping of VF-PF mailbox address failed\n");
+		err = -ENOMEM;
+		goto clear_drvdata;
+	}
+
+	/* Initialize AF-PF mailbox */
+	err = cptpf_afpf_mbox_init(cptpf);
+	if (err)
+		goto clear_drvdata;
+
+	/* Initialize VF-PF mailbox */
+	err = cptpf_vfpf_mbox_init(cptpf, cptpf->max_vfs);
+	if (err)
+		goto destroy_afpf_mbox;
+
+	/* Register interrupts */
+	err = cptpf_register_interrupts(cptpf);
+	if (err)
+		goto destroy_vfpf_mbox;
+
+	/* Enable VF FLR interrupts */
+	cptpf_enable_vf_flr_intrs(cptpf);
+
+	/* Enable AF-PF mailbox interrupts */
+	cptpf_enable_afpf_mbox_intrs(cptpf);
+
+	/* Enable VF-PF mailbox interrupts */
+	cptpf_enable_vfpf_mbox_intrs(cptpf, cptpf->max_vfs);
+
+	/* Initialize CPT PF device */
+	err = cptpf_device_init(cptpf);
+	if (err)
+		goto unregister_interrupts;
+
+	err = otx2_cpt_send_ready_msg(cptpf->pdev);
+	if (err)
+		goto unregister_interrupts;
+
+	/* Initialize engine groups */
+	err = otx2_cpt_init_eng_grps(pdev, &cptpf->eng_grps);
+	if (err)
+		goto unregister_interrupts;
+
+	err = sysfs_create_group(&dev->kobj, &cptpf_sysfs_group);
+	if (err)
+		goto cleanup_eng_grps;
+	return 0;
+
+cleanup_eng_grps:
+	otx2_cpt_cleanup_eng_grps(pdev, &cptpf->eng_grps);
+unregister_interrupts:
+	cptpf_disable_vfpf_mbox_intrs(cptpf);
+	cptpf_disable_afpf_mbox_intrs(cptpf);
+	cptpf_disable_vf_flr_intrs(cptpf);
+destroy_vfpf_mbox:
+	cptpf_vfpf_mbox_destroy(cptpf);
+destroy_afpf_mbox:
+	cptpf_afpf_mbox_destroy(cptpf);
+clear_drvdata:
+	pci_set_drvdata(pdev, NULL);
+	return err;
+}
+
+static void otx2_cptpf_remove(struct pci_dev *pdev)
+{
+	struct otx2_cptpf_dev *cptpf = pci_get_drvdata(pdev);
+
+	if (!cptpf)
+		return;
+
+	/* Disable SRIOV */
+	pci_disable_sriov(pdev);
+	/*
+	 * Delete sysfs entry created for kernel VF limits
+	 * and sso_pf_func_ovrd bit.
+	 */
+	sysfs_remove_group(&pdev->dev.kobj, &cptpf_sysfs_group);
+	/* Cleanup engine groups */
+	otx2_cpt_cleanup_eng_grps(pdev, &cptpf->eng_grps);
+	/* Disable VF-PF interrupts */
+	cptpf_disable_vfpf_mbox_intrs(cptpf);
+	/* Disable AF-PF mailbox interrupt */
+	cptpf_disable_afpf_mbox_intrs(cptpf);
+	/* Disable VF FLR interrupts */
+	cptpf_disable_vf_flr_intrs(cptpf);
+	/* Unregister CPT interrupts */
+	/* Destroy AF-PF mbox */
+	cptpf_afpf_mbox_destroy(cptpf);
+	/* Destroy VF-PF mbox */
+	cptpf_vfpf_mbox_destroy(cptpf);
+	pci_set_drvdata(pdev, NULL);
+}
+
+/* Supported devices */
+static const struct pci_device_id otx2_cpt_id_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, OTX2_CPT_PCI_PF_DEVICE_ID) },
+	{ 0, }  /* end of table */
+};
+
+static struct pci_driver otx2_cpt_pci_driver = {
+	.name = OTX2_CPT_DRV_NAME,
+	.id_table = otx2_cpt_id_table,
+	.probe = otx2_cptpf_probe,
+	.remove = otx2_cptpf_remove,
+	.sriov_configure = otx2_cptpf_sriov_configure
+};
+
+module_pci_driver(otx2_cpt_pci_driver);
+
+MODULE_AUTHOR("Marvell");
+MODULE_DESCRIPTION(OTX2_CPT_DRV_STRING);
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(OTX2_CPT_DRV_VERSION);
+MODULE_DEVICE_TABLE(pci, otx2_cpt_id_table);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
new file mode 100644
index 000000000000..5cc5218fc7ef
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -0,0 +1,694 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include "otx2_cpt_mbox_common.h"
+#include "rvu_reg.h"
+
+/* Fastpath ipsec opcode with inplace processing */
+#define CPT_INLINE_RX_OPCODE (0x26 | (1 << 6))
+/*
+ * CPT PF driver version, It will be incremented by 1 for every feature
+ * addition in CPT PF driver.
+ */
+#define OTX2_CPT_PF_DRV_VERSION 0x2
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
+static int get_eng_grp(struct otx2_cptpf_dev *cptpf, u8 eng_type)
+{
+	int eng_grp_num = OTX2_CPT_INVALID_CRYPTO_ENG_GRP;
+	struct otx2_cpt_eng_grp_info *grp;
+	int i;
+
+
+	mutex_lock(&cptpf->eng_grps.lock);
+
+	switch (eng_type) {
+	case OTX2_CPT_SE_TYPES:
+		/*
+		 * Find engine group for kernel crypto functionality, select
+		 * first engine group which is configured and has only
+		 * SE engines attached
+		 */
+		for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+			grp = &cptpf->eng_grps.grp[i];
+			if (!grp->is_enabled)
+				continue;
+
+			if (otx2_cpt_eng_grp_has_eng_type(grp,
+							  OTX2_CPT_SE_TYPES) &&
+			    !otx2_cpt_eng_grp_has_eng_type(grp,
+							   OTX2_CPT_IE_TYPES)) {
+				eng_grp_num = i;
+				break;
+			}
+		}
+		break;
+
+	case OTX2_CPT_AE_TYPES:
+	case OTX2_CPT_IE_TYPES:
+		for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+			grp = &cptpf->eng_grps.grp[i];
+			if (!grp->is_enabled)
+				continue;
+
+			if (otx2_cpt_eng_grp_has_eng_type(grp, eng_type)) {
+				eng_grp_num = i;
+				break;
+			}
+		}
+		break;
+
+	default:
+		dev_err(&cptpf->pdev->dev, "Invalid engine type %d\n",
+			eng_type);
+	}
+	mutex_unlock(&cptpf->eng_grps.lock);
+
+	return eng_grp_num;
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
+
+	return ret;
+}
+
+static int cptlf_set_eng_grps_mask(struct pci_dev *pdev,
+				   struct otx2_cptlf_info *lf,
+				   u8 eng_grp_mask)
+{
+	union otx2_cptx_af_lf_ctrl lf_ctrl;
+	int ret;
+
+	ret = otx2_cpt_read_af_reg(pdev, CPT_AF_LFX_CTL(lf->slot), &lf_ctrl.u);
+	if (ret)
+		return ret;
+
+	lf_ctrl.s.grp = eng_grp_mask;
+
+	ret = otx2_cpt_write_af_reg(pdev, CPT_AF_LFX_CTL(lf->slot), lf_ctrl.u);
+
+	return ret;
+}
+
+static int cptlf_set_grp_and_pri(struct pci_dev *pdev,
+				 struct otx2_cptlfs_info *lfs,
+				 u8 eng_grp_mask, int pri)
+{
+	int slot, ret;
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
+	return 0;
+}
+
+void otx2_cptpf_lf_cleanup(struct otx2_cptlfs_info *lfs)
+{
+	otx2_cptlf_disable_iqueues(lfs);
+	otx2_cpt_free_instruction_queues(lfs);
+	otx2_cpt_detach_rsrcs_msg(lfs->pdev);
+	lfs->lfs_num = 0;
+}
+
+int otx2_cptpf_lf_init(struct otx2_cptpf_dev *cptpf, u8 eng_grp_mask, int pri,
+		       int lfs_num)
+{
+	struct otx2_cptlfs_info *lfs = &cptpf->lfs;
+	struct pci_dev *pdev = cptpf->pdev;
+	int ret, slot;
+
+	lfs->reg_base = cptpf->reg_base;
+	lfs->lfs_num = lfs_num;
+	lfs->pdev = pdev;
+
+	for (slot = 0; slot < lfs->lfs_num; slot++) {
+		lfs->lf[slot].lfs = lfs;
+		lfs->lf[slot].slot = slot;
+		lfs->lf[slot].lmtline = lfs->reg_base +
+			OTX2_CPT_RVU_FUNC_ADDR_S(BLKADDR_LMT, slot,
+			OTX2_CPT_LMT_LF_LMTLINEX(0));
+		lfs->lf[slot].ioreg = lfs->reg_base +
+			OTX2_CPT_RVU_FUNC_ADDR_S(BLKADDR_CPT0, slot,
+			OTX2_CPT_LF_NQX(0));
+	}
+	ret = otx2_cpt_attach_rscrs_msg(pdev);
+	if (ret)
+		goto clear_lfs_num;
+
+	ret = otx2_cpt_alloc_instruction_queues(lfs);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Allocating instruction queues failed\n");
+		goto detach_rsrcs;
+	}
+	otx2_cptlf_disable_iqueues(lfs);
+
+	otx2_cptlf_set_iqueues_base_addr(lfs);
+
+	otx2_cptlf_set_iqueues_size(lfs);
+
+	otx2_cptlf_enable_iqueues(lfs);
+
+	ret = cptlf_set_grp_and_pri(pdev, lfs, eng_grp_mask, pri);
+	if (ret)
+		goto free_iqueue;
+
+	return 0;
+
+free_iqueue:
+	otx2_cptlf_disable_iqueues(lfs);
+	otx2_cpt_free_instruction_queues(lfs);
+detach_rsrcs:
+	otx2_cpt_detach_rsrcs_msg(pdev);
+clear_lfs_num:
+	lfs->lfs_num = 0;
+	return ret;
+}
+
+static int forward_to_af(struct otx2_cptpf_dev *cptpf,
+			 struct otx2_cptvf_info *vf,
+			 struct mbox_msghdr *req, int size)
+{
+	struct mbox_msghdr *msg;
+	int ret;
+
+	msg = otx2_mbox_alloc_msg(&cptpf->afpf_mbox, 0, size);
+	if (msg == NULL)
+		return -ENOMEM;
+
+	memcpy((uint8_t *)msg + sizeof(struct mbox_msghdr),
+	       (uint8_t *)req + sizeof(struct mbox_msghdr), size);
+	msg->id = req->id;
+	msg->pcifunc = req->pcifunc;
+	msg->sig = req->sig;
+	msg->ver = req->ver;
+
+	otx2_mbox_msg_send(&cptpf->afpf_mbox, 0);
+	ret = otx2_mbox_wait_for_rsp(&cptpf->afpf_mbox, 0);
+	if (ret == -EIO) {
+		dev_err(&cptpf->pdev->dev, "RVU MBOX timeout.\n");
+		return ret;
+	} else if (ret) {
+		dev_err(&cptpf->pdev->dev, "RVU MBOX error: %d.\n", ret);
+		return -EFAULT;
+	}
+	return 0;
+}
+
+static int check_attach_rsrcs_req(struct otx2_cptpf_dev *cptpf,
+				  struct otx2_cptvf_info *vf,
+				  struct mbox_msghdr *req, int size)
+{
+	struct rsrc_attach *rsrc_req = (struct rsrc_attach *)req;
+
+	if (rsrc_req->sso > 0 || rsrc_req->ssow > 0 || rsrc_req->npalf > 0 ||
+	    rsrc_req->timlfs > 0 || rsrc_req->nixlf > 0) {
+		dev_err(&cptpf->pdev->dev,
+			"Invalid ATTACH_RESOURCES request from %s\n",
+			dev_name(&vf->vf_dev->dev));
+
+		return -EINVAL;
+	}
+
+	return forward_to_af(cptpf, vf, req, size);
+}
+
+static int reply_ready_msg(struct otx2_cptpf_dev *cptpf,
+			   struct otx2_cptvf_info *vf,
+			   struct mbox_msghdr *req)
+{
+	struct ready_msg_rsp *rsp;
+
+	rsp = (struct ready_msg_rsp *)
+	       otx2_mbox_alloc_msg(&cptpf->vfpf_mbox, vf->vf_id, sizeof(*rsp));
+	if (!rsp)
+		return -ENOMEM;
+
+	rsp->hdr.id = MBOX_MSG_READY;
+	rsp->hdr.sig = OTX2_MBOX_RSP_SIG;
+	rsp->hdr.pcifunc = req->pcifunc;
+
+	return 0;
+}
+
+static int reply_eng_grp_num_msg(struct otx2_cptpf_dev *cptpf,
+				 struct otx2_cptvf_info *vf,
+				 struct mbox_msghdr *req)
+{
+	struct otx2_cpt_eng_grp_num_msg *grp_req =
+			(struct otx2_cpt_eng_grp_num_msg *)req;
+	struct otx2_cpt_eng_grp_num_rsp *rsp;
+
+	rsp = (struct otx2_cpt_eng_grp_num_rsp *)
+			      otx2_mbox_alloc_msg(&cptpf->vfpf_mbox, vf->vf_id,
+						  sizeof(*rsp));
+	if (!rsp)
+		return -ENOMEM;
+
+	rsp->hdr.id = MBOX_MSG_GET_ENG_GRP_NUM;
+	rsp->hdr.sig = OTX2_MBOX_RSP_SIG;
+	rsp->hdr.pcifunc = req->pcifunc;
+	rsp->eng_type = grp_req->eng_type;
+	rsp->eng_grp_num = get_eng_grp(cptpf, grp_req->eng_type);
+
+	return 0;
+}
+
+static int rx_inline_ipsec_lf_cfg(struct otx2_cptpf_dev *cptpf, u8 egrp,
+				  u16 sso_pf_func, bool enable)
+{
+	struct cpt_inline_ipsec_cfg_msg *req;
+	struct nix_inline_ipsec_cfg *nix_req;
+	struct pci_dev *pdev = cptpf->pdev;
+	int ret;
+
+	nix_req = (struct nix_inline_ipsec_cfg *)
+			otx2_mbox_alloc_msg_rsp(&cptpf->afpf_mbox, 0,
+						sizeof(*nix_req),
+						sizeof(struct msg_rsp));
+	if (nix_req == NULL) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+	memset(nix_req, 0, sizeof(*nix_req));
+	nix_req->hdr.id = MBOX_MSG_NIX_INLINE_IPSEC_CFG;
+	nix_req->hdr.sig = OTX2_MBOX_REQ_SIG;
+	nix_req->enable = enable;
+	nix_req->cpt_credit = OTX2_CPT_INST_QLEN_MSGS - 1;
+	nix_req->gen_cfg.egrp = egrp;
+	nix_req->gen_cfg.opcode = CPT_INLINE_RX_OPCODE;
+	nix_req->inst_qsel.cpt_pf_func = OTX2_CPT_RVU_PFFUNC(cptpf->pf_id, 0);
+	nix_req->inst_qsel.cpt_slot = 0;
+	ret = otx2_cpt_send_mbox_msg(pdev);
+	if (ret)
+		return ret;
+
+	req = (struct cpt_inline_ipsec_cfg_msg *)
+			otx2_mbox_alloc_msg_rsp(&cptpf->afpf_mbox, 0,
+						sizeof(*req),
+						sizeof(struct msg_rsp));
+	if (req == NULL) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+	memset(req, 0, sizeof(*req));
+	req->hdr.id = MBOX_MSG_CPT_INLINE_IPSEC_CFG;
+	req->hdr.sig = OTX2_MBOX_REQ_SIG;
+	req->hdr.pcifunc = OTX2_CPT_RVU_PFFUNC(cptpf->pf_id, 0);
+	req->dir = CPT_INLINE_INBOUND;
+	req->slot = 0;
+	req->sso_pf_func_ovrd = cptpf->sso_pf_func_ovrd;
+	req->sso_pf_func = sso_pf_func;
+	req->enable = enable;
+	ret = otx2_cpt_send_mbox_msg(pdev);
+
+	return ret;
+}
+
+static int rx_inline_ipsec_lf_enable(struct otx2_cptpf_dev *cptpf,
+				     struct mbox_msghdr *req)
+{
+	struct otx2_cpt_rx_inline_lf_cfg *cfg_req =
+					(struct otx2_cpt_rx_inline_lf_cfg *)req;
+	u8 egrp;
+	int ret;
+
+	if (cptpf->lfs.lfs_num) {
+		dev_err(&cptpf->pdev->dev,
+			"LF is already configured for RX inline ipsec.\n");
+		return -EEXIST;
+	}
+	/*
+	 * Allow LFs to execute requests destined to only grp IE_TYPES and
+	 * set queue priority of each LF to high
+	 */
+	egrp = get_eng_grp(cptpf, OTX2_CPT_IE_TYPES);
+	if (egrp == OTX2_CPT_INVALID_CRYPTO_ENG_GRP) {
+		dev_err(&cptpf->pdev->dev,
+			"Engine group for inline ipsec is not available\n");
+		return -ENOENT;
+	}
+
+	ret = otx2_cptpf_lf_init(cptpf, 1 << egrp, OTX2_CPT_QUEUE_HI_PRIO, 1);
+	if (ret)
+		return ret;
+
+	ret = rx_inline_ipsec_lf_cfg(cptpf, egrp, cfg_req->sso_pf_func, true);
+	if (ret)
+		goto lf_cleanup;
+
+	return 0;
+
+lf_cleanup:
+	otx2_cptpf_lf_cleanup(&cptpf->lfs);
+	return ret;
+}
+
+static int reply_caps_msg(struct otx2_cptpf_dev *cptpf,
+			  struct otx2_cptvf_info *vf,
+			  struct mbox_msghdr *req)
+{
+	struct otx2_cpt_caps_rsp *rsp;
+
+	rsp = (struct otx2_cpt_caps_rsp *)
+			      otx2_mbox_alloc_msg(&cptpf->vfpf_mbox, vf->vf_id,
+						  sizeof(*rsp));
+	if (!rsp)
+		return -ENOMEM;
+
+	rsp->hdr.id = MBOX_MSG_GET_CAPS;
+	rsp->hdr.sig = OTX2_MBOX_RSP_SIG;
+	rsp->hdr.pcifunc = req->pcifunc;
+	rsp->cpt_pf_drv_version = OTX2_CPT_PF_DRV_VERSION;
+	rsp->cpt_revision = cptpf->pdev->revision;
+	memcpy(&rsp->eng_caps, &cptpf->eng_caps, sizeof(rsp->eng_caps));
+
+	return 0;
+}
+
+static int reply_kcrypto_limits_msg(struct otx2_cptpf_dev *cptpf,
+				    struct otx2_cptvf_info *vf,
+				    struct mbox_msghdr *req)
+{
+	struct otx2_cpt_kcrypto_limits_rsp *rsp;
+
+	rsp = (struct otx2_cpt_kcrypto_limits_rsp *)
+			      otx2_mbox_alloc_msg(&cptpf->vfpf_mbox, vf->vf_id,
+						  sizeof(*rsp));
+	if (!rsp)
+		return -ENOMEM;
+
+	rsp->hdr.id = MBOX_MSG_GET_KCRYPTO_LIMITS;
+	rsp->hdr.sig = OTX2_MBOX_RSP_SIG;
+	rsp->hdr.pcifunc = req->pcifunc;
+	rsp->kcrypto_limits = cptpf->kvf_limits;
+
+	return 0;
+}
+
+static int check_cpt_lf_alloc_req(struct otx2_cptpf_dev *cptpf,
+				  struct otx2_cptvf_info *vf,
+				  struct mbox_msghdr *req, int size)
+{
+	struct cpt_lf_alloc_req_msg *alloc_req =
+					(struct cpt_lf_alloc_req_msg *)req;
+
+	if (alloc_req->eng_grpmsk == 0x0)
+		alloc_req->eng_grpmsk = OTX2_CPT_ALL_ENG_GRPS_MASK;
+
+	return forward_to_af(cptpf, vf, req, size);
+}
+
+static int cptpf_handle_vf_req(struct otx2_cptpf_dev *cptpf,
+			       struct otx2_cptvf_info *vf,
+			       struct mbox_msghdr *req, int size)
+{
+	int err = 0;
+
+	/* Check if msg is valid, if not reply with an invalid msg */
+	if (req->sig != OTX2_MBOX_REQ_SIG)
+		return otx2_reply_invalid_msg(&cptpf->vfpf_mbox, vf->vf_id,
+					      req->pcifunc, req->id);
+	switch (req->id) {
+	case MBOX_MSG_READY:
+		err = reply_ready_msg(cptpf, vf, req);
+		break;
+
+	case MBOX_MSG_ATTACH_RESOURCES:
+		err = check_attach_rsrcs_req(cptpf, vf, req, size);
+		break;
+
+	case MBOX_MSG_GET_ENG_GRP_NUM:
+		err = reply_eng_grp_num_msg(cptpf, vf, req);
+		break;
+
+	case MBOX_MSG_RX_INLINE_IPSEC_LF_CFG:
+		err = rx_inline_ipsec_lf_enable(cptpf, req);
+		break;
+
+	case MBOX_MSG_GET_CAPS:
+		err = reply_caps_msg(cptpf, vf, req);
+		break;
+
+	case MBOX_MSG_GET_KCRYPTO_LIMITS:
+		err = reply_kcrypto_limits_msg(cptpf, vf, req);
+		break;
+
+	case MBOX_MSG_CPT_LF_ALLOC:
+		err = check_cpt_lf_alloc_req(cptpf, vf, req, size);
+		break;
+
+	default:
+		err = forward_to_af(cptpf, vf, req, size);
+		break;
+	}
+
+	return err;
+}
+
+irqreturn_t otx2_cptpf_afpf_mbox_intr(int __always_unused irq, void *arg)
+{
+	struct otx2_cptpf_dev *cptpf = arg;
+	u64 intr;
+
+	/* Read the interrupt bits */
+	intr = otx2_cpt_read64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_INT);
+
+	if (intr & 0x1ULL) {
+		/* Schedule work queue function to process the MBOX request */
+		queue_work(cptpf->afpf_mbox_wq, &cptpf->afpf_mbox_work);
+		/* Clear and ack the interrupt */
+		otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_INT,
+			    0x1ULL);
+	}
+	return IRQ_HANDLED;
+}
+
+irqreturn_t otx2_cptpf_vfpf_mbox_intr(int __always_unused irq, void *arg)
+{
+	struct otx2_cptpf_dev *cptpf = arg;
+	struct otx2_cptvf_info *vf;
+	int i, vf_idx;
+	u64 intr;
+
+	/*
+	 * Check which VF has raised an interrupt and schedule
+	 * corresponding work queue to process the messages
+	 */
+	for (i = 0; i < 2; i++) {
+		/* Read the interrupt bits */
+		intr = otx2_cpt_read64(cptpf->reg_base, BLKADDR_RVUM, 0,
+				       RVU_PF_VFPF_MBOX_INTX(i));
+
+		for (vf_idx = i * 64; vf_idx < cptpf->enabled_vfs; vf_idx++) {
+			vf = &cptpf->vf[vf_idx];
+			if (intr & (1ULL << vf->intr_idx)) {
+				queue_work(cptpf->vfpf_mbox_wq,
+					   &vf->vfpf_mbox_work);
+				/* Clear the interrupt */
+				otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM,
+						 0, RVU_PF_VFPF_MBOX_INTX(i),
+						 BIT_ULL(vf->intr_idx));
+			}
+		}
+	}
+	return IRQ_HANDLED;
+}
+
+void otx2_cptpf_afpf_mbox_handler(struct work_struct *work)
+{
+	struct cpt_rd_wr_reg_msg *rsp_rd_wr;
+	struct otx2_cptpf_dev *cptpf;
+	struct otx2_mbox *afpf_mbox;
+	struct otx2_mbox *vfpf_mbox;
+	struct mbox_hdr *rsp_hdr;
+	struct mbox_msghdr *msg;
+	struct mbox_msghdr *fwd;
+	int offset, size;
+	int vf_id, i;
+
+	/* Read latest mbox data */
+	smp_rmb();
+
+	cptpf = container_of(work, struct otx2_cptpf_dev, afpf_mbox_work);
+	afpf_mbox = &cptpf->afpf_mbox;
+	vfpf_mbox = &cptpf->vfpf_mbox;
+	rsp_hdr = (struct mbox_hdr *)(afpf_mbox->dev->mbase +
+		   afpf_mbox->rx_start);
+	if (rsp_hdr->num_msgs == 0)
+		return;
+	offset = ALIGN(sizeof(struct mbox_hdr), MBOX_MSG_ALIGN);
+
+	for (i = 0; i < rsp_hdr->num_msgs; i++) {
+		msg = (struct mbox_msghdr *)(afpf_mbox->dev->mbase +
+					     afpf_mbox->rx_start + offset);
+		size = msg->next_msgoff - offset;
+
+		if (msg->id >= MBOX_MSG_MAX) {
+			dev_err(&cptpf->pdev->dev,
+				"MBOX msg with unknown ID %d\n", msg->id);
+			goto error;
+		}
+
+		if (msg->sig != OTX2_MBOX_RSP_SIG) {
+			dev_err(&cptpf->pdev->dev,
+				"MBOX msg with wrong signature %x, ID %d\n",
+				msg->sig, msg->id);
+			goto error;
+		}
+
+		offset = msg->next_msgoff;
+		vf_id = (msg->pcifunc >> RVU_PFVF_FUNC_SHIFT) &
+			 RVU_PFVF_FUNC_MASK;
+		if (vf_id > 0) {
+			vf_id--;
+			if (vf_id >= cptpf->enabled_vfs) {
+				dev_err(&cptpf->pdev->dev,
+					"MBOX msg to unknown VF: %d >= %d\n",
+					vf_id, cptpf->enabled_vfs);
+				goto error;
+			}
+			fwd = otx2_mbox_alloc_msg(vfpf_mbox, vf_id, size);
+			if (!fwd) {
+				dev_err(&cptpf->pdev->dev,
+					"Forwarding to VF%d failed.\n", vf_id);
+				goto error;
+			}
+			memcpy((uint8_t *)fwd + sizeof(struct mbox_msghdr),
+			       (uint8_t *)msg + sizeof(struct mbox_msghdr),
+			       size);
+			fwd->id = msg->id;
+			fwd->pcifunc = msg->pcifunc;
+			fwd->sig = msg->sig;
+			fwd->ver = msg->ver;
+			fwd->rc = msg->rc;
+		} else {
+			dump_mbox_msg(msg, size);
+			switch (msg->id) {
+			case MBOX_MSG_READY:
+				cptpf->pf_id =
+					(msg->pcifunc >> RVU_PFVF_PF_SHIFT) &
+					RVU_PFVF_PF_MASK;
+				break;
+
+			case MBOX_MSG_CPT_RD_WR_REGISTER:
+				rsp_rd_wr = (struct cpt_rd_wr_reg_msg *)
+					     msg;
+				if (msg->rc) {
+					dev_err(&cptpf->pdev->dev,
+						"Reg %llx rd/wr(%d) failed %d\n",
+						rsp_rd_wr->reg_offset,
+						rsp_rd_wr->is_write,
+						msg->rc);
+					goto error;
+				}
+
+				if (!rsp_rd_wr->is_write)
+					*rsp_rd_wr->ret_val = rsp_rd_wr->val;
+				break;
+
+			case MBOX_MSG_ATTACH_RESOURCES:
+				if (!msg->rc)
+					cptpf->lfs.are_lfs_attached = 1;
+				break;
+
+			case MBOX_MSG_DETACH_RESOURCES:
+				if (!msg->rc)
+					cptpf->lfs.are_lfs_attached = 0;
+				break;
+			case MBOX_MSG_CPT_INLINE_IPSEC_CFG:
+			case MBOX_MSG_NIX_INLINE_IPSEC_CFG:
+				break;
+			default:
+				dev_err(&cptpf->pdev->dev,
+					"Unsupported msg %d received.\n",
+					msg->id);
+				break;
+			}
+		}
+error:
+		afpf_mbox->dev->msgs_acked++;
+	}
+
+	otx2_mbox_reset(afpf_mbox, 0);
+}
+
+void otx2_cptpf_vfpf_mbox_handler(struct work_struct *work)
+{
+	struct otx2_cptvf_info *vf = container_of(work, struct otx2_cptvf_info,
+						  vfpf_mbox_work);
+	struct otx2_cptpf_dev *cptpf = vf->cptpf;
+	struct otx2_mbox *mbox = &cptpf->vfpf_mbox;
+	struct otx2_mbox_dev *mdev;
+	struct mbox_hdr *req_hdr;
+	struct mbox_msghdr *msg;
+	int offset, id, err;
+
+	/* sync with mbox memory region */
+	rmb();
+
+	mdev = &mbox->dev[vf->vf_id];
+	/* Process received mbox messages */
+	req_hdr = (struct mbox_hdr *)(mdev->mbase + mbox->rx_start);
+	offset = ALIGN(sizeof(*req_hdr), MBOX_MSG_ALIGN);
+	id = 0;
+	while (id < req_hdr->num_msgs) {
+		while (id < req_hdr->num_msgs) {
+			msg = (struct mbox_msghdr *)(mdev->mbase +
+						     mbox->rx_start + offset);
+
+			/* Set which VF sent this message based on mbox IRQ */
+			msg->pcifunc = ((u16)cptpf->pf_id << RVU_PFVF_PF_SHIFT)
+				| ((vf->vf_id + 1) & RVU_PFVF_FUNC_MASK);
+
+			err = cptpf_handle_vf_req(cptpf, vf, msg,
+						  msg->next_msgoff - offset);
+
+			/*
+			 * Behave as the AF, drop the msg if there is
+			 * no memory, timeout handling also goes here
+			 */
+			if (err == -ENOMEM ||
+			    err == -EIO)
+				break;
+
+			offset = msg->next_msgoff;
+			id++;
+		}
+
+		/* Send mbox responses to VF */
+		if (mdev->num_msgs)
+			otx2_mbox_msg_send(mbox, vf->vf_id);
+	}
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
new file mode 100644
index 000000000000..29f27b3f4d79
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -0,0 +1,2173 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include <linux/ctype.h>
+#include <linux/firmware.h>
+#include "otx2_cptpf_ucode.h"
+#include "otx2_cpt_common.h"
+#include "otx2_cpt_mbox_common.h"
+#include "rvu_reg.h"
+
+#define CSR_DELAY 30
+/* Tar archive defines */
+#define TAR_MAGIC "ustar"
+#define TAR_MAGIC_LEN 6
+#define TAR_BLOCK_LEN 512
+#define REGTYPE '0'
+#define AREGTYPE '\0'
+
+#define LOADFVC_RLEN 8
+#define LOADFVC_MAJOR_OP 0x01
+#define LOADFVC_MINOR_OP 0x08
+
+/* tar header as defined in POSIX 1003.1-1990. */
+struct tar_hdr_t {
+	char name[100];
+	char mode[8];
+	char uid[8];
+	char gid[8];
+	char size[12];
+	char mtime[12];
+	char chksum[8];
+	char typeflag;
+	char linkname[100];
+	char magic[6];
+	char version[2];
+	char uname[32];
+	char gname[32];
+	char devmajor[8];
+	char devminor[8];
+	char prefix[155];
+};
+
+struct tar_blk_t {
+	union {
+		struct tar_hdr_t hdr;
+		char block[TAR_BLOCK_LEN];
+	};
+};
+
+struct tar_arch_info_t {
+	struct list_head ucodes;
+	const struct firmware *fw;
+};
+
+static struct otx2_cpt_bitmap get_cores_bmap(struct device *dev,
+					struct otx2_cpt_eng_grp_info *eng_grp)
+{
+	struct otx2_cpt_bitmap bmap = { {0} };
+	bool found = false;
+	int i;
+
+	if (eng_grp->g->engs_num > OTX2_CPT_MAX_ENGINES) {
+		dev_err(dev, "unsupported number of engines %d on octeontx2\n",
+			eng_grp->g->engs_num);
+		return bmap;
+	}
+
+	for (i = 0; i  < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		if (eng_grp->engs[i].type) {
+			bitmap_or(bmap.bits, bmap.bits,
+				  eng_grp->engs[i].bmap,
+				  eng_grp->g->engs_num);
+			bmap.size = eng_grp->g->engs_num;
+			found = true;
+		}
+	}
+
+	if (!found)
+		dev_err(dev, "No engines reserved for engine group %d\n",
+			eng_grp->idx);
+	return bmap;
+}
+
+static int is_eng_type(int val, int eng_type)
+{
+	return val & (1 << eng_type);
+}
+
+static int dev_supports_eng_type(struct otx2_cpt_eng_grps *eng_grps,
+				 int eng_type)
+{
+	return is_eng_type(eng_grps->eng_types_supported, eng_type);
+}
+
+static int is_2nd_ucode_used(struct otx2_cpt_eng_grp_info *eng_grp)
+{
+	if (eng_grp->ucode[1].type)
+		return true;
+	else
+		return false;
+}
+
+static void set_ucode_filename(struct otx2_cpt_ucode *ucode,
+			       const char *filename)
+{
+	strlcpy(ucode->filename, filename, OTX2_CPT_NAME_LENGTH);
+}
+
+static char *get_eng_type_str(int eng_type)
+{
+	char *str = "unknown";
+
+	switch (eng_type) {
+	case OTX2_CPT_SE_TYPES:
+		str = "SE";
+		break;
+
+	case OTX2_CPT_IE_TYPES:
+		str = "IE";
+		break;
+
+	case OTX2_CPT_AE_TYPES:
+		str = "AE";
+		break;
+	}
+	return str;
+}
+
+static char *get_ucode_type_str(int ucode_type)
+{
+	char *str = "unknown";
+
+	switch (ucode_type) {
+	case (1 << OTX2_CPT_SE_TYPES):
+		str = "SE";
+		break;
+
+	case (1 << OTX2_CPT_IE_TYPES):
+		str = "IE";
+		break;
+
+	case (1 << OTX2_CPT_AE_TYPES):
+		str = "AE";
+		break;
+
+	case (1 << OTX2_CPT_SE_TYPES | 1 << OTX2_CPT_IE_TYPES):
+		str = "SE+IPSEC";
+		break;
+	}
+	return str;
+}
+
+static void swap_engines(struct otx2_cpt_engines *engsl,
+			 struct otx2_cpt_engines *engsr)
+{
+	struct otx2_cpt_engines engs;
+
+	engs = *engsl;
+	*engsl = *engsr;
+	*engsr = engs;
+}
+
+static void swap_ucodes(struct otx2_cpt_ucode *ucodel,
+			struct otx2_cpt_ucode *ucoder)
+{
+	struct otx2_cpt_ucode ucode;
+
+	ucode = *ucodel;
+	*ucodel = *ucoder;
+	*ucoder = ucode;
+}
+
+static int get_ucode_type(struct device *dev,
+			  struct otx2_cpt_ucode_hdr *ucode_hdr,
+			  int *ucode_type)
+{
+	struct otx2_cptpf_dev *cptpf = dev_get_drvdata(dev);
+	char ver_str_prefix[OTX2_CPT_UCODE_VER_STR_SZ];
+	char tmp_ver_str[OTX2_CPT_UCODE_VER_STR_SZ];
+	struct pci_dev *pdev = cptpf->pdev;
+	int i, val = 0;
+	u8 nn;
+
+	strlcpy(tmp_ver_str, ucode_hdr->ver_str, OTX2_CPT_UCODE_VER_STR_SZ);
+	for (i = 0; i < strlen(tmp_ver_str); i++)
+		tmp_ver_str[i] = tolower(tmp_ver_str[i]);
+
+	sprintf(ver_str_prefix, "ocpt-%02d", pdev->revision);
+	if (!strnstr(tmp_ver_str, ver_str_prefix, OTX2_CPT_UCODE_VER_STR_SZ))
+		return -EINVAL;
+
+	nn = ucode_hdr->ver_num.nn;
+	if (strnstr(tmp_ver_str, "se-", OTX2_CPT_UCODE_VER_STR_SZ) &&
+	    (nn == OTX2_CPT_SE_UC_TYPE1 || nn == OTX2_CPT_SE_UC_TYPE2 ||
+	     nn == OTX2_CPT_SE_UC_TYPE3))
+		val |= 1 << OTX2_CPT_SE_TYPES;
+	if (strnstr(tmp_ver_str, "ipsec", OTX2_CPT_UCODE_VER_STR_SZ) &&
+	    (nn == OTX2_CPT_IE_UC_TYPE1 || nn == OTX2_CPT_IE_UC_TYPE2 ||
+	     nn == OTX2_CPT_IE_UC_TYPE3))
+		val |= 1 << OTX2_CPT_IE_TYPES;
+	if (strnstr(tmp_ver_str, "ae", OTX2_CPT_UCODE_VER_STR_SZ) &&
+	    nn == OTX2_CPT_AE_UC_TYPE)
+		val |= 1 << OTX2_CPT_AE_TYPES;
+
+	*ucode_type = val;
+
+	if (!val)
+		return -EINVAL;
+	if (is_eng_type(val, OTX2_CPT_AE_TYPES) &&
+	    (is_eng_type(val, OTX2_CPT_SE_TYPES) ||
+	    is_eng_type(val, OTX2_CPT_IE_TYPES)))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int is_mem_zero(const char *ptr, int size)
+{
+	int i;
+
+	for (i = 0; i < size; i++) {
+		if (ptr[i])
+			return 0;
+	}
+	return 1;
+}
+
+static int cpt_set_ucode_base(struct otx2_cpt_eng_grp_info *eng_grp, void *obj)
+{
+	struct otx2_cptpf_dev *cptpf = obj;
+	struct otx2_cpt_engs_rsvd *engs;
+	dma_addr_t dma_addr;
+	int i, bit, ret;
+
+	/* Set PF number for microcode fetches */
+	ret = otx2_cpt_write_af_reg(cptpf->pdev, CPT_AF_PF_FUNC,
+				    cptpf->pf_id << RVU_PFVF_PF_SHIFT);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		engs = &eng_grp->engs[i];
+		if (!engs->type)
+			continue;
+
+		dma_addr = engs->ucode->dma;
+
+		/*
+		 * Set UCODE_BASE only for the cores which are not used,
+		 * other cores should have already valid UCODE_BASE set
+		 */
+		for_each_set_bit(bit, engs->bmap, eng_grp->g->engs_num)
+			if (!eng_grp->g->eng_ref_cnt[bit]) {
+				ret = otx2_cpt_write_af_reg(cptpf->pdev,
+						CPT_AF_EXEX_UCODE_BASE(bit),
+						(u64) dma_addr);
+				if (ret)
+					return ret;
+			}
+	}
+	return 0;
+}
+
+static int cpt_detach_and_disable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
+					void *obj)
+{
+	struct otx2_cptpf_dev *cptpf = obj;
+	struct otx2_cpt_bitmap bmap;
+	int i, timeout = 10;
+	int busy, ret;
+	u64 reg = 0;
+
+	bmap = get_cores_bmap(&cptpf->pdev->dev, eng_grp);
+	if (!bmap.size)
+		return -EINVAL;
+
+	/* Detach the cores from group */
+	for_each_set_bit(i, bmap.bits, bmap.size) {
+		ret = otx2_cpt_read_af_reg(cptpf->pdev, CPT_AF_EXEX_CTL2(i),
+					   &reg);
+		if (ret)
+			return ret;
+
+		if (reg & (1ull << eng_grp->idx)) {
+			eng_grp->g->eng_ref_cnt[i]--;
+			reg &= ~(1ull << eng_grp->idx);
+
+			ret = otx2_cpt_write_af_reg(cptpf->pdev,
+						    CPT_AF_EXEX_CTL2(i), reg);
+			if (ret)
+				return ret;
+		}
+	}
+
+	/* Wait for cores to become idle */
+	do {
+		busy = 0;
+		usleep_range(10000, 20000);
+		if (timeout-- < 0)
+			return -EBUSY;
+
+		for_each_set_bit(i, bmap.bits, bmap.size) {
+			ret = otx2_cpt_read_af_reg(cptpf->pdev,
+						   CPT_AF_EXEX_STS(i), &reg);
+			if (ret)
+				return ret;
+
+			if (reg & 0x1) {
+				busy = 1;
+				break;
+			}
+		}
+	} while (busy);
+
+	/* Disable the cores only if they are not used anymore */
+	for_each_set_bit(i, bmap.bits, bmap.size) {
+		if (!eng_grp->g->eng_ref_cnt[i]) {
+			ret = otx2_cpt_write_af_reg(cptpf->pdev,
+						    CPT_AF_EXEX_CTL(i), 0x0);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int cpt_attach_and_enable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
+				       void *obj)
+{
+	struct otx2_cptpf_dev *cptpf = obj;
+	struct otx2_cpt_bitmap bmap;
+	u64 reg = 0;
+	int i, ret;
+
+	bmap = get_cores_bmap(&cptpf->pdev->dev, eng_grp);
+	if (!bmap.size)
+		return -EINVAL;
+
+	/* Attach the cores to the group */
+	for_each_set_bit(i, bmap.bits, bmap.size) {
+		ret = otx2_cpt_read_af_reg(cptpf->pdev, CPT_AF_EXEX_CTL2(i),
+					   &reg);
+		if (ret)
+			return ret;
+
+		if (!(reg & (1ull << eng_grp->idx))) {
+			eng_grp->g->eng_ref_cnt[i]++;
+			reg |= 1ull << eng_grp->idx;
+
+			ret = otx2_cpt_write_af_reg(cptpf->pdev,
+						    CPT_AF_EXEX_CTL2(i), reg);
+			if (ret)
+				return ret;
+		}
+	}
+
+	/* Enable the cores */
+	for_each_set_bit(i, bmap.bits, bmap.size) {
+		ret = otx2_cpt_add_write_af_reg(cptpf->pdev,
+						CPT_AF_EXEX_CTL(i), 0x1);
+		if (ret)
+			return ret;
+	}
+	ret = otx2_cpt_send_af_reg_requests(cptpf->pdev);
+
+	return ret;
+}
+
+static int process_tar_file(struct device *dev,
+			    struct tar_arch_info_t *tar_arch, char *filename,
+			    const u8 *data, int size)
+{
+	struct tar_ucode_info_t *tar_ucode_info;
+	struct otx2_cpt_ucode_hdr *ucode_hdr;
+	int ucode_type, ucode_size;
+
+	/*
+	 * If size is less than microcode header size then don't report
+	 * an error because it might not be microcode file, just process
+	 * next file from archive
+	 */
+	if (size < sizeof(struct otx2_cpt_ucode_hdr))
+		return 0;
+
+	ucode_hdr = (struct otx2_cpt_ucode_hdr *) data;
+	/*
+	 * If microcode version can't be found don't report an error
+	 * because it might not be microcode file, just process next file
+	 */
+	if (get_ucode_type(dev, ucode_hdr, &ucode_type))
+		return 0;
+
+	ucode_size = ntohl(ucode_hdr->code_length) * 2;
+	if (!ucode_size || (size < round_up(ucode_size, 16) +
+	    sizeof(struct otx2_cpt_ucode_hdr) + OTX2_CPT_UCODE_SIGN_LEN)) {
+		dev_err(dev, "Ucode %s invalid size\n", filename);
+		return -EINVAL;
+	}
+
+	tar_ucode_info = kzalloc(sizeof(*tar_ucode_info), GFP_KERNEL);
+	if (!tar_ucode_info)
+		return -ENOMEM;
+
+	tar_ucode_info->ucode_ptr = data;
+	set_ucode_filename(&tar_ucode_info->ucode, filename);
+	memcpy(tar_ucode_info->ucode.ver_str, ucode_hdr->ver_str,
+	       OTX2_CPT_UCODE_VER_STR_SZ);
+	tar_ucode_info->ucode.ver_num = ucode_hdr->ver_num;
+	tar_ucode_info->ucode.type = ucode_type;
+	tar_ucode_info->ucode.size = ucode_size;
+	list_add_tail(&tar_ucode_info->list, &tar_arch->ucodes);
+
+	return 0;
+}
+
+static void release_tar_archive(struct tar_arch_info_t *tar_arch)
+{
+	struct tar_ucode_info_t *curr, *temp;
+
+	if (!tar_arch)
+		return;
+
+	list_for_each_entry_safe(curr, temp, &tar_arch->ucodes, list) {
+		list_del(&curr->list);
+		kfree(curr);
+	}
+
+	if (tar_arch->fw)
+		release_firmware(tar_arch->fw);
+	kfree(tar_arch);
+}
+
+static struct tar_ucode_info_t *get_uc_from_tar_archive(
+					struct tar_arch_info_t *tar_arch,
+					int ucode_type)
+{
+	struct tar_ucode_info_t *curr, *uc_found = NULL;
+
+	list_for_each_entry(curr, &tar_arch->ucodes, list) {
+		if (!is_eng_type(curr->ucode.type, ucode_type))
+			continue;
+
+		if (ucode_type == OTX2_CPT_IE_TYPES &&
+		    is_eng_type(curr->ucode.type, OTX2_CPT_SE_TYPES))
+			continue;
+
+		if (!uc_found) {
+			uc_found = curr;
+			continue;
+		}
+
+		switch (ucode_type) {
+		case OTX2_CPT_AE_TYPES:
+			break;
+
+		case OTX2_CPT_SE_TYPES:
+			if (uc_found->ucode.ver_num.nn ==
+							OTX2_CPT_SE_UC_TYPE2 ||
+			    (uc_found->ucode.ver_num.nn ==
+							OTX2_CPT_SE_UC_TYPE3 &&
+			     curr->ucode.ver_num.nn == OTX2_CPT_SE_UC_TYPE1))
+				uc_found = curr;
+			break;
+
+		case OTX2_CPT_IE_TYPES:
+			if (uc_found->ucode.ver_num.nn ==
+							OTX2_CPT_IE_UC_TYPE2 ||
+			    (uc_found->ucode.ver_num.nn ==
+							OTX2_CPT_IE_UC_TYPE3 &&
+			     curr->ucode.ver_num.nn == OTX2_CPT_IE_UC_TYPE1))
+				uc_found = curr;
+			break;
+		}
+	}
+	return uc_found;
+}
+
+static void print_tar_dbg_info(struct tar_arch_info_t *tar_arch,
+			       char *tar_filename)
+{
+	struct tar_ucode_info_t *curr;
+
+	pr_debug("Tar archive filename %s\n", tar_filename);
+	pr_debug("Tar archive pointer %p, size %ld\n", tar_arch->fw->data,
+		 tar_arch->fw->size);
+	list_for_each_entry(curr, &tar_arch->ucodes, list) {
+		pr_debug("Ucode filename %s\n", curr->ucode.filename);
+		pr_debug("Ucode version string %s\n", curr->ucode.ver_str);
+		pr_debug("Ucode version %d.%d.%d.%d\n",
+			 curr->ucode.ver_num.nn, curr->ucode.ver_num.xx,
+			 curr->ucode.ver_num.yy, curr->ucode.ver_num.zz);
+		pr_debug("Ucode type (%d) %s\n", curr->ucode.type,
+			 get_ucode_type_str(curr->ucode.type));
+		pr_debug("Ucode size %d\n", curr->ucode.size);
+		pr_debug("Ucode ptr %p\n", curr->ucode_ptr);
+	}
+}
+
+static struct tar_arch_info_t *load_tar_archive(struct device *dev,
+						char *tar_filename)
+{
+	struct tar_arch_info_t *tar_arch = NULL;
+	struct tar_blk_t *tar_blk;
+	unsigned int cur_size;
+	size_t tar_offs = 0;
+	size_t tar_size;
+	int ret;
+
+	tar_arch = kzalloc(sizeof(struct tar_arch_info_t), GFP_KERNEL);
+	if (!tar_arch)
+		return NULL;
+
+	INIT_LIST_HEAD(&tar_arch->ucodes);
+
+	/* Load tar archive */
+	ret = request_firmware(&tar_arch->fw, tar_filename, dev);
+	if (ret)
+		goto release_tar_arch;
+
+	if (tar_arch->fw->size < TAR_BLOCK_LEN) {
+		dev_err(dev, "Invalid tar archive %s\n", tar_filename);
+		goto release_tar_arch;
+	}
+
+	tar_size = tar_arch->fw->size;
+	tar_blk = (struct tar_blk_t *) tar_arch->fw->data;
+	if (strncmp(tar_blk->hdr.magic, TAR_MAGIC, TAR_MAGIC_LEN - 1)) {
+		dev_err(dev, "Unsupported format of tar archive %s\n",
+			tar_filename);
+		goto release_tar_arch;
+	}
+
+	while (1) {
+		/* Read current file size */
+		ret = kstrtouint(tar_blk->hdr.size, 8, &cur_size);
+		if (ret)
+			goto release_tar_arch;
+
+		if (tar_offs + cur_size > tar_size ||
+		    tar_offs + 2*TAR_BLOCK_LEN > tar_size) {
+			dev_err(dev, "Invalid tar archive %s\n", tar_filename);
+			goto release_tar_arch;
+		}
+
+		tar_offs += TAR_BLOCK_LEN;
+		if (tar_blk->hdr.typeflag == REGTYPE ||
+		    tar_blk->hdr.typeflag == AREGTYPE) {
+			ret = process_tar_file(dev, tar_arch,
+					       tar_blk->hdr.name,
+					       &tar_arch->fw->data[tar_offs],
+					       cur_size);
+			if (ret)
+				goto release_tar_arch;
+		}
+
+		tar_offs += (cur_size/TAR_BLOCK_LEN) * TAR_BLOCK_LEN;
+		if (cur_size % TAR_BLOCK_LEN)
+			tar_offs += TAR_BLOCK_LEN;
+
+		/* Check for the end of the archive */
+		if (tar_offs + 2*TAR_BLOCK_LEN > tar_size) {
+			dev_err(dev, "Invalid tar archive %s\n", tar_filename);
+			goto release_tar_arch;
+		}
+
+		if (is_mem_zero(&tar_arch->fw->data[tar_offs],
+		    2*TAR_BLOCK_LEN))
+			break;
+
+		/* Read next block from tar archive */
+		tar_blk = (struct tar_blk_t *) &tar_arch->fw->data[tar_offs];
+	}
+
+	print_tar_dbg_info(tar_arch, tar_filename);
+	return tar_arch;
+release_tar_arch:
+	release_tar_archive(tar_arch);
+	return NULL;
+}
+
+static struct otx2_cpt_engs_rsvd *find_engines_by_type(
+					struct otx2_cpt_eng_grp_info *eng_grp,
+					int eng_type)
+{
+	int i;
+
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		if (!eng_grp->engs[i].type)
+			continue;
+
+		if (eng_grp->engs[i].type == eng_type)
+			return &eng_grp->engs[i];
+	}
+	return NULL;
+}
+
+int otx2_cpt_uc_supports_eng_type(struct otx2_cpt_ucode *ucode, int eng_type)
+{
+	return is_eng_type(ucode->type, eng_type);
+}
+
+int otx2_cpt_eng_grp_has_eng_type(struct otx2_cpt_eng_grp_info *eng_grp,
+				  int eng_type)
+{
+	struct otx2_cpt_engs_rsvd *engs;
+
+	engs = find_engines_by_type(eng_grp, eng_type);
+
+	return (engs != NULL ? 1 : 0);
+}
+
+static void print_ucode_info(struct otx2_cpt_eng_grp_info *eng_grp,
+			     char *buf, int size)
+{
+	int len;
+
+	if (eng_grp->mirror.is_ena) {
+		scnprintf(buf, size, "%s (shared with engine_group%d)",
+			  eng_grp->g->grp[eng_grp->mirror.idx].ucode[0].ver_str,
+			  eng_grp->mirror.idx);
+	} else {
+		scnprintf(buf, size, "%s", eng_grp->ucode[0].ver_str);
+	}
+
+	if (is_2nd_ucode_used(eng_grp)) {
+		len = strlen(buf);
+		scnprintf(buf + len, size - len, ", %s (used by IE engines)",
+			  eng_grp->ucode[1].ver_str);
+	}
+}
+
+static void print_engs_info(struct otx2_cpt_eng_grp_info *eng_grp,
+			    char *buf, int size, int idx)
+{
+	struct otx2_cpt_engs_rsvd *mirrored_engs = NULL;
+	struct otx2_cpt_engs_rsvd *engs;
+	int len, i;
+
+	buf[0] = '\0';
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		engs = &eng_grp->engs[i];
+		if (!engs->type)
+			continue;
+		if (idx != -1 && idx != i)
+			continue;
+
+		if (eng_grp->mirror.is_ena)
+			mirrored_engs = find_engines_by_type(
+					&eng_grp->g->grp[eng_grp->mirror.idx],
+					engs->type);
+		if (i > 0 && idx == -1) {
+			len = strlen(buf);
+			scnprintf(buf+len, size-len, ", ");
+		}
+
+		len = strlen(buf);
+		scnprintf(buf+len, size-len, "%d %s ", mirrored_engs ?
+			  engs->count + mirrored_engs->count : engs->count,
+			  get_eng_type_str(engs->type));
+		if (mirrored_engs) {
+			len = strlen(buf);
+			scnprintf(buf+len, size-len,
+				  "(%d shared with engine_group%d) ",
+				  engs->count <= 0 ? engs->count +
+				  mirrored_engs->count : mirrored_engs->count,
+				  eng_grp->mirror.idx);
+		}
+	}
+}
+
+static void print_ucode_dbg_info(struct otx2_cpt_ucode *ucode)
+{
+	pr_debug("Ucode info\n");
+	pr_debug("Ucode version string %s\n", ucode->ver_str);
+	pr_debug("Ucode version %d.%d.%d.%d\n", ucode->ver_num.nn,
+		 ucode->ver_num.xx, ucode->ver_num.yy, ucode->ver_num.zz);
+	pr_debug("Ucode type %s\n", get_ucode_type_str(ucode->type));
+	pr_debug("Ucode size %d\n", ucode->size);
+	pr_debug("Ucode virt address %16.16llx\n", (u64)ucode->va);
+	pr_debug("Ucode phys address %16.16llx\n", ucode->dma);
+}
+
+static void print_engines_mask(struct otx2_cpt_eng_grp_info *eng_grp,
+			       void *obj, char *buf, int size)
+{
+	struct otx2_cptpf_dev *cptpf = obj;
+	struct otx2_cpt_bitmap bmap;
+	u32 mask[4];
+
+	bmap = get_cores_bmap(&cptpf->pdev->dev, eng_grp);
+	if (!bmap.size) {
+		scnprintf(buf, size, "unknown");
+		return;
+	}
+	bitmap_to_arr32(mask, bmap.bits, bmap.size);
+	scnprintf(buf, size, "%8.8x %8.8x %8.8x %8.8x", mask[3], mask[2],
+		  mask[1], mask[0]);
+}
+
+static void print_dbg_info(struct device *dev,
+			   struct otx2_cpt_eng_grps *eng_grps)
+{
+	struct otx2_cpt_eng_grp_info *mirrored_grp;
+	char engs_info[2*OTX2_CPT_NAME_LENGTH];
+	char engs_mask[OTX2_CPT_NAME_LENGTH];
+	struct otx2_cpt_eng_grp_info *grp;
+	struct otx2_cpt_engs_rsvd *engs;
+	u32 mask[4];
+	int i, j;
+
+	pr_debug("Engine groups global info\n");
+	pr_debug("max SE %d, max IE %d, max AE %d\n",
+		 eng_grps->avail.max_se_cnt, eng_grps->avail.max_ie_cnt,
+		 eng_grps->avail.max_ae_cnt);
+	pr_debug("free SE %d\n", eng_grps->avail.se_cnt);
+	pr_debug("free IE %d\n", eng_grps->avail.ie_cnt);
+	pr_debug("free AE %d\n", eng_grps->avail.ae_cnt);
+
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+		grp = &eng_grps->grp[i];
+		pr_debug("engine_group%d, state %s\n", i, grp->is_enabled ?
+			 "enabled" : "disabled");
+		if (grp->is_enabled) {
+			mirrored_grp = &eng_grps->grp[grp->mirror.idx];
+			pr_debug("Ucode0 filename %s, version %s\n",
+				 grp->mirror.is_ena ?
+				 mirrored_grp->ucode[0].filename :
+				 grp->ucode[0].filename,
+				 grp->mirror.is_ena ?
+				 mirrored_grp->ucode[0].ver_str :
+				 grp->ucode[0].ver_str);
+			if (is_2nd_ucode_used(grp))
+				pr_debug("Ucode1 filename %s, version %s\n",
+					 grp->ucode[1].filename,
+					 grp->ucode[1].ver_str);
+			else
+				pr_debug("Ucode1 not used\n");
+		}
+
+		for (j = 0; j < OTX2_CPT_MAX_ETYPES_PER_GRP; j++) {
+			engs = &grp->engs[j];
+			if (engs->type) {
+				print_engs_info(grp, engs_info,
+						2*OTX2_CPT_NAME_LENGTH,
+						j);
+				pr_debug("Slot%d: %s\n", j, engs_info);
+				bitmap_to_arr32(mask, engs->bmap,
+						eng_grps->engs_num);
+				pr_debug("Mask:  %8.8x %8.8x %8.8x %8.8x\n",
+					 mask[3], mask[2], mask[1], mask[0]);
+			} else
+				pr_debug("Slot%d not used\n", j);
+		}
+		if (grp->is_enabled) {
+			print_engines_mask(grp, eng_grps->obj, engs_mask,
+					   OTX2_CPT_NAME_LENGTH);
+			pr_debug("Cmask: %s\n", engs_mask);
+		}
+	}
+}
+
+static int update_engines_avail_count(struct device *dev,
+				      struct otx2_cpt_engs_available *avail,
+				      struct otx2_cpt_engs_rsvd *engs, int val)
+{
+	switch (engs->type) {
+	case OTX2_CPT_SE_TYPES:
+		avail->se_cnt += val;
+		break;
+
+	case OTX2_CPT_IE_TYPES:
+		avail->ie_cnt += val;
+		break;
+
+	case OTX2_CPT_AE_TYPES:
+		avail->ae_cnt += val;
+		break;
+
+	default:
+		dev_err(dev, "Invalid engine type %d\n", engs->type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int update_engines_offset(struct device *dev,
+				 struct otx2_cpt_engs_available *avail,
+				 struct otx2_cpt_engs_rsvd *engs)
+{
+	switch (engs->type) {
+	case OTX2_CPT_SE_TYPES:
+		engs->offset = 0;
+		break;
+
+	case OTX2_CPT_IE_TYPES:
+		engs->offset = avail->max_se_cnt;
+		break;
+
+	case OTX2_CPT_AE_TYPES:
+		engs->offset = avail->max_se_cnt + avail->max_ie_cnt;
+		break;
+
+	default:
+		dev_err(dev, "Invalid engine type %d\n", engs->type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int release_engines(struct device *dev,
+			   struct otx2_cpt_eng_grp_info *grp)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		if (!grp->engs[i].type)
+			continue;
+
+		if (grp->engs[i].count > 0) {
+			ret = update_engines_avail_count(dev, &grp->g->avail,
+							 &grp->engs[i],
+							 grp->engs[i].count);
+			if (ret)
+				return ret;
+		}
+
+		grp->engs[i].type = 0;
+		grp->engs[i].count = 0;
+		grp->engs[i].offset = 0;
+		grp->engs[i].ucode = NULL;
+		bitmap_zero(grp->engs[i].bmap, grp->g->engs_num);
+	}
+	return 0;
+}
+
+static int do_reserve_engines(struct device *dev,
+			      struct otx2_cpt_eng_grp_info *grp,
+			      struct otx2_cpt_engines *req_engs)
+{
+	struct otx2_cpt_engs_rsvd *engs = NULL;
+	int i, ret;
+
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		if (!grp->engs[i].type) {
+			engs = &grp->engs[i];
+			break;
+		}
+	}
+
+	if (!engs)
+		return -ENOMEM;
+
+	engs->type = req_engs->type;
+	engs->count = req_engs->count;
+
+	ret = update_engines_offset(dev, &grp->g->avail, engs);
+	if (ret)
+		return ret;
+
+	if (engs->count > 0) {
+		ret = update_engines_avail_count(dev, &grp->g->avail, engs,
+						 -engs->count);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int check_engines_availability(struct device *dev,
+				      struct otx2_cpt_eng_grp_info *grp,
+				      struct otx2_cpt_engines *req_eng)
+{
+	int avail_cnt = 0;
+
+	switch (req_eng->type) {
+	case OTX2_CPT_SE_TYPES:
+		avail_cnt = grp->g->avail.se_cnt;
+		break;
+
+	case OTX2_CPT_IE_TYPES:
+		avail_cnt = grp->g->avail.ie_cnt;
+		break;
+
+	case OTX2_CPT_AE_TYPES:
+		avail_cnt = grp->g->avail.ae_cnt;
+		break;
+
+	default:
+		dev_err(dev, "Invalid engine type %d\n", req_eng->type);
+		return -EINVAL;
+	}
+
+	if (avail_cnt < req_eng->count) {
+		dev_err(dev,
+			"Error available %s engines %d < than requested %d\n",
+			get_eng_type_str(req_eng->type),
+			avail_cnt, req_eng->count);
+		return -EBUSY;
+	}
+	return 0;
+}
+
+static int reserve_engines(struct device *dev,
+			   struct otx2_cpt_eng_grp_info *grp,
+			   struct otx2_cpt_engines *req_engs, int req_cnt)
+{
+	int i, ret = 0;
+
+	/* Validate if a number of requested engines is available */
+	for (i = 0; i < req_cnt; i++) {
+		ret = check_engines_availability(dev, grp, &req_engs[i]);
+		if (ret)
+			return ret;
+	}
+
+	/* Reserve requested engines for this engine group */
+	for (i = 0; i < req_cnt; i++) {
+		ret = do_reserve_engines(dev, grp, &req_engs[i]);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static ssize_t eng_grp_info_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct otx2_cpt_eng_grp_info *eng_grp;
+	char ucode_info[2*OTX2_CPT_NAME_LENGTH];
+	char engs_info[2*OTX2_CPT_NAME_LENGTH];
+	char engs_mask[OTX2_CPT_NAME_LENGTH];
+	int ret;
+
+	eng_grp = container_of(attr, struct otx2_cpt_eng_grp_info, info_attr);
+	mutex_lock(&eng_grp->g->lock);
+
+	print_engs_info(eng_grp, engs_info, 2 * OTX2_CPT_NAME_LENGTH, -1);
+	print_ucode_info(eng_grp, ucode_info, 2 * OTX2_CPT_NAME_LENGTH);
+	print_engines_mask(eng_grp, eng_grp->g, engs_mask,
+			   OTX2_CPT_NAME_LENGTH);
+	ret = scnprintf(buf, PAGE_SIZE,
+			"Microcode : %s\nEngines: %s\nEngines mask: %s\n",
+			ucode_info, engs_info, engs_mask);
+
+	mutex_unlock(&eng_grp->g->lock);
+	return ret;
+}
+
+static int create_sysfs_eng_grps_info(struct device *dev,
+				      struct otx2_cpt_eng_grp_info *eng_grp)
+{
+	int ret;
+
+	eng_grp->info_attr.show = eng_grp_info_show;
+	eng_grp->info_attr.store = NULL;
+	eng_grp->info_attr.attr.name = eng_grp->sysfs_info_name;
+	eng_grp->info_attr.attr.mode = 0440;
+	sysfs_attr_init(&eng_grp->info_attr.attr);
+	ret = device_create_file(dev, &eng_grp->info_attr);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void ucode_unload(struct device *dev, struct otx2_cpt_ucode *ucode)
+{
+	if (ucode->va) {
+		dma_free_coherent(dev, ucode->size, ucode->va, ucode->dma);
+		ucode->va = NULL;
+		ucode->dma = 0;
+		ucode->size = 0;
+	}
+
+	memset(&ucode->ver_str, 0, OTX2_CPT_UCODE_VER_STR_SZ);
+	memset(&ucode->ver_num, 0, sizeof(struct otx2_cpt_ucode_ver_num));
+	set_ucode_filename(ucode, "");
+	ucode->type = 0;
+}
+
+static int copy_ucode_to_dma_mem(struct device *dev,
+				 struct otx2_cpt_ucode *ucode,
+				 const u8 *ucode_data)
+{
+	u32 i;
+
+	/*  Allocate DMAable space */
+	ucode->va = dma_alloc_coherent(dev, ucode->size, &ucode->dma,
+				       GFP_KERNEL);
+	if (!ucode->va)
+		return -ENOMEM;
+
+	memcpy(ucode->va, ucode_data + sizeof(struct otx2_cpt_ucode_hdr),
+	       ucode->size);
+
+	/* Byte swap 64-bit */
+	for (i = 0; i < (ucode->size / 8); i++)
+		cpu_to_be64s(&((u64 *)ucode->va)[i]);
+	/*  Ucode needs 16-bit swap */
+	for (i = 0; i < (ucode->size / 2); i++)
+		cpu_to_be16s(&((u16 *)ucode->va)[i]);
+	return 0;
+}
+
+static int ucode_load(struct device *dev, struct otx2_cpt_ucode *ucode,
+		      const char *ucode_filename)
+{
+	struct otx2_cpt_ucode_hdr *ucode_hdr;
+	const struct firmware *fw;
+	int ret;
+
+	set_ucode_filename(ucode, ucode_filename);
+	ret = request_firmware(&fw, ucode->filename, dev);
+	if (ret)
+		return ret;
+
+	ucode_hdr = (struct otx2_cpt_ucode_hdr *) fw->data;
+	memcpy(ucode->ver_str, ucode_hdr->ver_str, OTX2_CPT_UCODE_VER_STR_SZ);
+	ucode->ver_num = ucode_hdr->ver_num;
+	ucode->size = ntohl(ucode_hdr->code_length) * 2;
+	if (!ucode->size || (fw->size < round_up(ucode->size, 16)
+	    + sizeof(struct otx2_cpt_ucode_hdr) + OTX2_CPT_UCODE_SIGN_LEN)) {
+		dev_err(dev, "Ucode %s invalid size\n", ucode_filename);
+		ret = -EINVAL;
+		goto release_fw;
+	}
+
+	ret = get_ucode_type(dev, ucode_hdr, &ucode->type);
+	if (ret) {
+		dev_err(dev, "Microcode %s unknown type 0x%x\n",
+			ucode->filename, ucode->type);
+		goto release_fw;
+	}
+
+	ret = copy_ucode_to_dma_mem(dev, ucode, fw->data);
+	if (ret)
+		goto release_fw;
+
+	print_ucode_dbg_info(ucode);
+release_fw:
+	release_firmware(fw);
+	return ret;
+}
+
+static int enable_eng_grp(struct otx2_cpt_eng_grp_info *eng_grp,
+			  void *obj)
+{
+	int ret;
+
+	/* Point microcode to each core of the group */
+	ret = cpt_set_ucode_base(eng_grp, obj);
+	if (ret)
+		return ret;
+
+	/* Attach the cores to the group and enable them */
+	ret = cpt_attach_and_enable_cores(eng_grp, obj);
+
+	return ret;
+}
+
+static int disable_eng_grp(struct device *dev,
+			   struct otx2_cpt_eng_grp_info *eng_grp,
+			   void *obj)
+{
+	int i, ret;
+
+	/* Disable all engines used by this group */
+	ret = cpt_detach_and_disable_cores(eng_grp, obj);
+	if (ret)
+		return ret;
+
+	/* Unload ucode used by this engine group */
+	ucode_unload(dev, &eng_grp->ucode[0]);
+	ucode_unload(dev, &eng_grp->ucode[1]);
+
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		if (!eng_grp->engs[i].type)
+			continue;
+
+		eng_grp->engs[i].ucode = &eng_grp->ucode[0];
+	}
+
+	/* Clear UCODE_BASE register for each engine used by this group */
+	ret = cpt_set_ucode_base(eng_grp, obj);
+
+	return ret;
+}
+
+static void setup_eng_grp_mirroring(struct otx2_cpt_eng_grp_info *dst_grp,
+				    struct otx2_cpt_eng_grp_info *src_grp)
+{
+	/* Setup fields for engine group which is mirrored */
+	src_grp->mirror.is_ena = false;
+	src_grp->mirror.idx = 0;
+	src_grp->mirror.ref_count++;
+
+	/* Setup fields for mirroring engine group */
+	dst_grp->mirror.is_ena = true;
+	dst_grp->mirror.idx = src_grp->idx;
+	dst_grp->mirror.ref_count = 0;
+}
+
+static void remove_eng_grp_mirroring(struct otx2_cpt_eng_grp_info *dst_grp)
+{
+	struct otx2_cpt_eng_grp_info *src_grp;
+
+	if (!dst_grp->mirror.is_ena)
+		return;
+
+	src_grp = &dst_grp->g->grp[dst_grp->mirror.idx];
+
+	src_grp->mirror.ref_count--;
+	dst_grp->mirror.is_ena = false;
+	dst_grp->mirror.idx = 0;
+	dst_grp->mirror.ref_count = 0;
+}
+
+static void update_requested_engs(struct otx2_cpt_eng_grp_info *mirror_eng_grp,
+				  struct otx2_cpt_engines *engs, int engs_cnt)
+{
+	struct otx2_cpt_engs_rsvd *mirrored_engs;
+	int i;
+
+	for (i = 0; i < engs_cnt; i++) {
+		mirrored_engs = find_engines_by_type(mirror_eng_grp,
+						     engs[i].type);
+		if (!mirrored_engs)
+			continue;
+
+		/*
+		 * If mirrored group has this type of engines attached then
+		 * there are 3 scenarios possible:
+		 * 1) mirrored_engs.count == engs[i].count then all engines
+		 * from mirrored engine group will be shared with this engine
+		 * group
+		 * 2) mirrored_engs.count > engs[i].count then only a subset of
+		 * engines from mirrored engine group will be shared with this
+		 * engine group
+		 * 3) mirrored_engs.count < engs[i].count then all engines
+		 * from mirrored engine group will be shared with this group
+		 * and additional engines will be reserved for exclusively use
+		 * by this engine group
+		 */
+		engs[i].count -= mirrored_engs->count;
+	}
+}
+
+static struct otx2_cpt_eng_grp_info *find_mirrored_eng_grp(
+					struct otx2_cpt_eng_grp_info *grp)
+{
+	struct otx2_cpt_eng_grps *eng_grps = grp->g;
+	int i;
+
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+		if (!eng_grps->grp[i].is_enabled)
+			continue;
+		if (eng_grps->grp[i].ucode[0].type &&
+		    eng_grps->grp[i].ucode[1].type)
+			continue;
+		if (grp->idx == i)
+			continue;
+		if (!strncasecmp(eng_grps->grp[i].ucode[0].ver_str,
+				 grp->ucode[0].ver_str,
+				 OTX2_CPT_UCODE_VER_STR_SZ))
+			return &eng_grps->grp[i];
+	}
+
+	return NULL;
+}
+
+static struct otx2_cpt_eng_grp_info *find_unused_eng_grp(
+					struct otx2_cpt_eng_grps *eng_grps)
+{
+	int i;
+
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+		if (!eng_grps->grp[i].is_enabled)
+			return &eng_grps->grp[i];
+	}
+	return NULL;
+}
+
+static int eng_grp_update_masks(struct device *dev,
+				struct otx2_cpt_eng_grp_info *eng_grp)
+{
+	struct otx2_cpt_engs_rsvd *engs, *mirrored_engs;
+	struct otx2_cpt_bitmap tmp_bmap = { {0} };
+	int i, j, cnt, max_cnt;
+	int bit;
+
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		engs = &eng_grp->engs[i];
+		if (!engs->type)
+			continue;
+		if (engs->count <= 0)
+			continue;
+
+		switch (engs->type) {
+		case OTX2_CPT_SE_TYPES:
+			max_cnt = eng_grp->g->avail.max_se_cnt;
+			break;
+
+		case OTX2_CPT_IE_TYPES:
+			max_cnt = eng_grp->g->avail.max_ie_cnt;
+			break;
+
+		case OTX2_CPT_AE_TYPES:
+			max_cnt = eng_grp->g->avail.max_ae_cnt;
+			break;
+
+		default:
+			dev_err(dev, "Invalid engine type %d\n", engs->type);
+			return -EINVAL;
+		}
+
+		cnt = engs->count;
+		WARN_ON(engs->offset + max_cnt > OTX2_CPT_MAX_ENGINES);
+		bitmap_zero(tmp_bmap.bits, eng_grp->g->engs_num);
+		for (j = engs->offset; j < engs->offset + max_cnt; j++) {
+			if (!eng_grp->g->eng_ref_cnt[j]) {
+				bitmap_set(tmp_bmap.bits, j, 1);
+				cnt--;
+				if (!cnt)
+					break;
+			}
+		}
+
+		if (cnt)
+			return -ENOSPC;
+
+		bitmap_copy(engs->bmap, tmp_bmap.bits, eng_grp->g->engs_num);
+	}
+
+	if (!eng_grp->mirror.is_ena)
+		return 0;
+
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		engs = &eng_grp->engs[i];
+		if (!engs->type)
+			continue;
+
+		mirrored_engs = find_engines_by_type(
+					&eng_grp->g->grp[eng_grp->mirror.idx],
+					engs->type);
+		WARN_ON(!mirrored_engs && engs->count <= 0);
+		if (!mirrored_engs)
+			continue;
+
+		bitmap_copy(tmp_bmap.bits, mirrored_engs->bmap,
+			    eng_grp->g->engs_num);
+		if (engs->count < 0) {
+			bit = find_first_bit(mirrored_engs->bmap,
+					     eng_grp->g->engs_num);
+			bitmap_clear(tmp_bmap.bits, bit, -engs->count);
+		}
+		bitmap_or(engs->bmap, engs->bmap, tmp_bmap.bits,
+			  eng_grp->g->engs_num);
+	}
+	return 0;
+}
+
+static int delete_engine_group(struct device *dev,
+			       struct otx2_cpt_eng_grp_info *eng_grp)
+{
+	int i, ret;
+
+	if (!eng_grp->is_enabled)
+		return -EINVAL;
+
+	if (eng_grp->mirror.ref_count) {
+		dev_err(dev, "Can't delete engine_group%d as it is used by engine group(s):",
+			eng_grp->idx);
+		for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+			if (eng_grp->g->grp[i].mirror.is_ena &&
+			    eng_grp->g->grp[i].mirror.idx == eng_grp->idx)
+				pr_cont("%d", i);
+		}
+		pr_cont("\n");
+		return -EINVAL;
+	}
+
+	/* Removing engine group mirroring if enabled */
+	remove_eng_grp_mirroring(eng_grp);
+
+	/* Disable engine group */
+	ret = disable_eng_grp(dev, eng_grp, eng_grp->g->obj);
+	if (ret)
+		return ret;
+
+	/* Release all engines held by this engine group */
+	ret = release_engines(dev, eng_grp);
+	if (ret)
+		return ret;
+
+	device_remove_file(dev, &eng_grp->info_attr);
+	eng_grp->is_enabled = false;
+
+	return 0;
+}
+
+static int validate_2_ucodes_scenario(struct device *dev,
+				      struct otx2_cpt_eng_grp_info *eng_grp)
+{
+	struct otx2_cpt_ucode *se_ucode = NULL, *ie_ucode = NULL;
+	struct otx2_cpt_ucode *ucode;
+	int i;
+
+	/*
+	 * Find ucode which supports SE engines and ucode which supports
+	 * IE engines only
+	 */
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		ucode = &eng_grp->ucode[i];
+		if (otx2_cpt_uc_supports_eng_type(ucode, OTX2_CPT_SE_TYPES))
+			se_ucode = ucode;
+		else if (otx2_cpt_uc_supports_eng_type(ucode,
+						       OTX2_CPT_IE_TYPES) &&
+			 !otx2_cpt_uc_supports_eng_type(ucode,
+							OTX2_CPT_SE_TYPES))
+			ie_ucode = ucode;
+	}
+
+	if (!se_ucode || !ie_ucode) {
+		dev_err(dev,
+			"Only combination of SE+IE microcodes is supported.\n");
+		return -EINVAL;
+	}
+
+	/* Keep SE ucode at index 0 */
+	if (otx2_cpt_uc_supports_eng_type(&eng_grp->ucode[1],
+					  OTX2_CPT_SE_TYPES))
+		swap_ucodes(&eng_grp->ucode[0], &eng_grp->ucode[1]);
+
+	return 0;
+}
+
+static int validate_1_ucode_scenario(struct device *dev,
+				     struct otx2_cpt_eng_grp_info *eng_grp,
+				     struct otx2_cpt_engines *engs,
+				     int engs_cnt)
+{
+	int i;
+
+	/* Verify that ucode loaded supports requested engine types */
+	for (i = 0; i < engs_cnt; i++) {
+		if (otx2_cpt_uc_supports_eng_type(&eng_grp->ucode[0],
+						  OTX2_CPT_SE_TYPES) &&
+		    engs[i].type == OTX2_CPT_IE_TYPES) {
+			dev_err(dev,
+				"IE engines can't be used with SE microcode\n");
+			return -EINVAL;
+		}
+
+		if (!otx2_cpt_uc_supports_eng_type(&eng_grp->ucode[0],
+						   engs[i].type)) {
+			/*
+			 * Exception to this rule is the case
+			 * where IPSec ucode can use SE engines
+			 */
+			if (otx2_cpt_uc_supports_eng_type(&eng_grp->ucode[0],
+							  OTX2_CPT_IE_TYPES) &&
+			    engs[i].type == OTX2_CPT_SE_TYPES)
+				continue;
+
+			dev_err(dev,
+				"Microcode %s does not support %s engines\n",
+				eng_grp->ucode[0].filename,
+				get_eng_type_str(engs[i].type));
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+static void update_ucode_ptrs(struct otx2_cpt_eng_grp_info *eng_grp)
+{
+	struct otx2_cpt_ucode *ucode;
+
+	if (eng_grp->mirror.is_ena)
+		ucode = &eng_grp->g->grp[eng_grp->mirror.idx].ucode[0];
+	else
+		ucode = &eng_grp->ucode[0];
+	WARN_ON(!eng_grp->engs[0].type);
+	eng_grp->engs[0].ucode = ucode;
+
+	if (eng_grp->engs[1].type) {
+		if (is_2nd_ucode_used(eng_grp))
+			eng_grp->engs[1].ucode = &eng_grp->ucode[1];
+		else
+			eng_grp->engs[1].ucode = ucode;
+	}
+}
+
+static int get_eng_caps_discovery_grp(struct otx2_cpt_eng_grps *eng_grps,
+				      u8 eng_type)
+{
+	struct otx2_cpt_eng_grp_info *grp;
+	int eng_grp_num = 0xff, i;
+
+	switch (eng_type) {
+	case OTX2_CPT_SE_TYPES:
+		for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+			grp = &eng_grps->grp[i];
+			if (!grp->is_enabled)
+				continue;
+
+			if (otx2_cpt_eng_grp_has_eng_type(grp,
+							  OTX2_CPT_SE_TYPES) &&
+			    !otx2_cpt_eng_grp_has_eng_type(grp,
+							   OTX2_CPT_IE_TYPES) &&
+			    !otx2_cpt_eng_grp_has_eng_type(grp,
+							   OTX2_CPT_AE_TYPES)) {
+				eng_grp_num = i;
+				break;
+			}
+		}
+		break;
+
+	case OTX2_CPT_IE_TYPES:
+		for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+			grp = &eng_grps->grp[i];
+			if (!grp->is_enabled)
+				continue;
+
+			if (otx2_cpt_eng_grp_has_eng_type(grp,
+							  OTX2_CPT_IE_TYPES) &&
+			    !otx2_cpt_eng_grp_has_eng_type(grp,
+							   OTX2_CPT_SE_TYPES)) {
+				eng_grp_num = i;
+				break;
+			}
+		}
+		break;
+
+	case OTX2_CPT_AE_TYPES:
+		for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+			grp = &eng_grps->grp[i];
+			if (!grp->is_enabled)
+				continue;
+
+			if (otx2_cpt_eng_grp_has_eng_type(grp, eng_type)) {
+				eng_grp_num = i;
+				break;
+			}
+		}
+		break;
+	}
+	return eng_grp_num;
+}
+
+static int delete_eng_caps_discovery_grps(struct pci_dev *pdev,
+					  struct otx2_cpt_eng_grps *eng_grps)
+{
+	struct otx2_cpt_eng_grp_info *grp;
+	int i, ret;
+
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+		grp = &eng_grps->grp[i];
+		ret = delete_engine_group(&pdev->dev, grp);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+static int create_engine_group(struct device *dev,
+			       struct otx2_cpt_eng_grps *eng_grps,
+			       struct otx2_cpt_engines *engs, int engs_cnt,
+			       void *ucode_data[], int ucodes_cnt,
+			       bool use_uc_from_tar_arch)
+{
+	struct otx2_cpt_eng_grp_info *mirrored_eng_grp;
+	struct tar_ucode_info_t *tar_ucode_info;
+	struct otx2_cpt_eng_grp_info *eng_grp;
+	int i, ret = 0;
+
+	if (ucodes_cnt > OTX2_CPT_MAX_ETYPES_PER_GRP)
+		return -EINVAL;
+
+	/* Validate if requested engine types are supported by this device */
+	for (i = 0; i < engs_cnt; i++)
+		if (!dev_supports_eng_type(eng_grps, engs[i].type)) {
+			dev_err(dev, "Device does not support %s engines\n",
+				get_eng_type_str(engs[i].type));
+			return -EPERM;
+		}
+
+	/* Find engine group which is not used */
+	eng_grp = find_unused_eng_grp(eng_grps);
+	if (!eng_grp) {
+		dev_err(dev, "Error all engine groups are being used\n");
+		return -ENOSPC;
+	}
+
+	/* Load ucode */
+	for (i = 0; i < ucodes_cnt; i++) {
+		if (use_uc_from_tar_arch) {
+			tar_ucode_info =
+				     (struct tar_ucode_info_t *) ucode_data[i];
+			eng_grp->ucode[i] = tar_ucode_info->ucode;
+			ret = copy_ucode_to_dma_mem(dev, &eng_grp->ucode[i],
+						    tar_ucode_info->ucode_ptr);
+		} else
+			ret = ucode_load(dev, &eng_grp->ucode[i],
+					 (char *) ucode_data[i]);
+		if (ret)
+			goto err_ucode_unload;
+	}
+
+	if (ucodes_cnt > 1) {
+		/*
+		 * Validate scenario where 2 ucodes are used - this
+		 * is only allowed for combination of SE+IE ucodes
+		 */
+		ret = validate_2_ucodes_scenario(dev, eng_grp);
+		if (ret)
+			goto err_ucode_unload;
+	} else {
+		/* Validate scenario where 1 ucode is used */
+		ret = validate_1_ucode_scenario(dev, eng_grp, engs, engs_cnt);
+		if (ret)
+			goto err_ucode_unload;
+	}
+
+	/* Check if this group mirrors another existing engine group */
+	mirrored_eng_grp = find_mirrored_eng_grp(eng_grp);
+	if (mirrored_eng_grp) {
+		/* Setup mirroring */
+		setup_eng_grp_mirroring(eng_grp, mirrored_eng_grp);
+
+		/*
+		 * Update count of requested engines because some
+		 * of them might be shared with mirrored group
+		 */
+		update_requested_engs(mirrored_eng_grp, engs, engs_cnt);
+	}
+
+	ret = reserve_engines(dev, eng_grp, engs, engs_cnt);
+	if (ret)
+		goto err_ucode_unload;
+
+	/* Update ucode pointers used by engines */
+	update_ucode_ptrs(eng_grp);
+
+	/* Update engine masks used by this group */
+	ret = eng_grp_update_masks(dev, eng_grp);
+	if (ret)
+		goto err_release_engs;
+
+	/* Create sysfs entry for engine group info */
+	ret = create_sysfs_eng_grps_info(dev, eng_grp);
+	if (ret)
+		goto err_release_engs;
+
+	/* Enable engine group */
+	ret = enable_eng_grp(eng_grp, eng_grps->obj);
+	if (ret)
+		goto err_release_engs;
+
+	/*
+	 * If this engine group mirrors another engine group
+	 * then we need to unload ucode as we will use ucode
+	 * from mirrored engine group
+	 */
+	if (eng_grp->mirror.is_ena)
+		ucode_unload(dev, &eng_grp->ucode[0]);
+
+	eng_grp->is_enabled = true;
+	if (mirrored_eng_grp)
+		dev_info(dev,
+			 "Engine_group%d: reuse microcode %s from group %d\n",
+			 eng_grp->idx, mirrored_eng_grp->ucode[0].ver_str,
+			 mirrored_eng_grp->idx);
+	else
+		dev_info(dev, "Engine_group%d: microcode loaded %s\n",
+			 eng_grp->idx, eng_grp->ucode[0].ver_str);
+	if (is_2nd_ucode_used(eng_grp))
+		dev_info(dev, "Engine_group%d: microcode loaded %s\n",
+			 eng_grp->idx, eng_grp->ucode[1].ver_str);
+
+	return 0;
+
+err_release_engs:
+	release_engines(dev, eng_grp);
+err_ucode_unload:
+	ucode_unload(dev, &eng_grp->ucode[0]);
+	ucode_unload(dev, &eng_grp->ucode[1]);
+	return ret;
+}
+
+static ssize_t ucode_load_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct otx2_cpt_engines engs[OTX2_CPT_MAX_ETYPES_PER_GRP] = { {0} };
+	char *ucode_filename[OTX2_CPT_MAX_ETYPES_PER_GRP];
+	char tmp_buf[OTX2_CPT_NAME_LENGTH] = { 0 };
+	struct otx2_cpt_eng_grps *eng_grps;
+	char *start, *val, *err_msg, *tmp;
+	int grp_idx = 0, ret = -EINVAL;
+	bool has_se, has_ie, has_ae;
+	int del_grp_idx = -1;
+	int ucode_idx = 0;
+	char *sbegin;
+
+	if (strlen(buf) > OTX2_CPT_NAME_LENGTH)
+		return -EINVAL;
+
+	eng_grps = container_of(attr, struct otx2_cpt_eng_grps,
+				ucode_load_attr);
+	err_msg = "Invalid engine group format";
+	strlcpy(tmp_buf, buf, OTX2_CPT_NAME_LENGTH);
+	start = tmp_buf;
+
+	has_se = has_ie = has_ae = false;
+
+	for (;;) {
+		val = strsep(&start, ";");
+		if (!val)
+			break;
+		val = strim(val);
+		if (!*val)
+			continue;
+
+		if (!strncasecmp(val, "engine_group", 12)) {
+			if (del_grp_idx != -1)
+				goto err_print;
+			sbegin = strsep(&val, ":");
+			if (sbegin == NULL || val == NULL)
+				goto err_print;
+			tmp = strim(sbegin);
+			if (strlen(tmp) != 13)
+				goto err_print;
+			if (kstrtoint((tmp + 12), 10, &del_grp_idx))
+				goto err_print;
+			val = strim(val);
+			if (strncasecmp(val, "null", 4))
+				goto err_print;
+			if (strlen(val) != 4)
+				goto err_print;
+		} else if (!strncasecmp(val, "se", 2) && strchr(val, ':')) {
+			if (has_se || ucode_idx)
+				goto err_print;
+			sbegin = strsep(&val, ":");
+			if (sbegin == NULL || val == NULL)
+				goto err_print;
+			tmp = strim(sbegin);
+			if (strlen(tmp) != 2)
+				goto err_print;
+			if (kstrtoint(strim(val), 10, &engs[grp_idx].count))
+				goto err_print;
+			engs[grp_idx++].type = OTX2_CPT_SE_TYPES;
+			has_se = true;
+		} else if (!strncasecmp(val, "ae", 2) && strchr(val, ':')) {
+			if (has_ae || ucode_idx)
+				goto err_print;
+			sbegin = strsep(&val, ":");
+			if (sbegin == NULL || !val)
+				goto err_print;
+			tmp = strim(sbegin);
+			if (strlen(tmp) != 2)
+				goto err_print;
+			if (kstrtoint(strim(val), 10, &engs[grp_idx].count))
+				goto err_print;
+			engs[grp_idx++].type = OTX2_CPT_AE_TYPES;
+			has_ae = true;
+		} else if (!strncasecmp(val, "ie", 2) && strchr(val, ':')) {
+			if (has_ie || ucode_idx)
+				goto err_print;
+			sbegin = strsep(&val, ":");
+			if (sbegin == NULL || !val)
+				goto err_print;
+			tmp = strim(sbegin);
+			if (strlen(tmp) != 2)
+				goto err_print;
+			if (kstrtoint(strim(val), 10, &engs[grp_idx].count))
+				goto err_print;
+			engs[grp_idx++].type = OTX2_CPT_IE_TYPES;
+			has_ie = true;
+		} else {
+			if (ucode_idx > 1)
+				goto err_print;
+			if (!strlen(val))
+				goto err_print;
+			if (strnstr(val, " ", strlen(val)))
+				goto err_print;
+			ucode_filename[ucode_idx++] = val;
+		}
+	}
+
+	/* Validate input parameters */
+	if (del_grp_idx == -1) {
+		if (!(grp_idx && ucode_idx))
+			goto err_print;
+
+		if (ucode_idx > 1 && grp_idx < 2)
+			goto err_print;
+
+		if (grp_idx > OTX2_CPT_MAX_ETYPES_PER_GRP) {
+			err_msg = "Error max 2 engine types can be attached";
+			goto err_print;
+		}
+
+		if (grp_idx > 1) {
+			if ((engs[0].type + engs[1].type) !=
+			    (OTX2_CPT_SE_TYPES + OTX2_CPT_IE_TYPES)) {
+				err_msg =
+				"Only combination of SE+IE engines is allowed";
+				goto err_print;
+			}
+
+			/* Keep SE engines at zero index */
+			if (engs[1].type == OTX2_CPT_SE_TYPES)
+				swap_engines(&engs[0], &engs[1]);
+		}
+
+	} else {
+		if (del_grp_idx < 0 || del_grp_idx >=
+						OTX2_CPT_MAX_ENGINE_GROUPS) {
+			dev_err(dev, "Invalid engine group index %d\n",
+				del_grp_idx);
+			return -EINVAL;
+		}
+
+		if (!eng_grps->grp[del_grp_idx].is_enabled) {
+			dev_err(dev, "Error engine_group%d is not configured\n",
+				del_grp_idx);
+			return -EINVAL;
+		}
+
+		if (grp_idx || ucode_idx)
+			goto err_print;
+	}
+
+	mutex_lock(&eng_grps->lock);
+
+	if (eng_grps->is_rdonly) {
+		dev_err(dev, "Disable VFs before modifying engine groups\n");
+		ret = -EACCES;
+		goto err_unlock;
+	}
+
+	if (del_grp_idx == -1)
+		/* create engine group */
+		ret = create_engine_group(dev, eng_grps, engs, grp_idx,
+					  (void **) ucode_filename,
+					  ucode_idx, false);
+	else
+		/* delete engine group */
+		ret = delete_engine_group(dev, &eng_grps->grp[del_grp_idx]);
+	if (ret)
+		goto err_unlock;
+
+	print_dbg_info(dev, eng_grps);
+err_unlock:
+	mutex_unlock(&eng_grps->lock);
+	return ret ? ret : count;
+err_print:
+	dev_err(dev, "%s\n", err_msg);
+
+	return ret;
+}
+
+static int create_eng_caps_discovery_grps(struct pci_dev *pdev,
+					  struct otx2_cpt_eng_grps *eng_grps)
+{
+	struct tar_ucode_info_t *tar_info[OTX2_CPT_MAX_ETYPES_PER_GRP] = {  };
+	struct otx2_cpt_engines engs[OTX2_CPT_MAX_ETYPES_PER_GRP] = { {0} };
+	struct tar_arch_info_t *tar_arch = NULL;
+	char tar_filename[OTX2_CPT_NAME_LENGTH];
+	int ret = -EINVAL;
+
+	sprintf(tar_filename, "cpt%02d-mc.tar", pdev->revision);
+	tar_arch = load_tar_archive(&pdev->dev, tar_filename);
+	if (!tar_arch)
+		return -EINVAL;
+	/*
+	 * If device supports AE engines and there is AE microcode in tar
+	 * archive try to create engine group with AE engines.
+	 */
+	tar_info[0] = get_uc_from_tar_archive(tar_arch, OTX2_CPT_AE_TYPES);
+	if (tar_info[0] && dev_supports_eng_type(eng_grps, OTX2_CPT_AE_TYPES)) {
+
+		engs[0].type = OTX2_CPT_AE_TYPES;
+		engs[0].count = 2;
+
+		ret = create_engine_group(&pdev->dev, eng_grps, engs, 1,
+					  (void **) tar_info, 1, true);
+		if (ret)
+			goto release_tar;
+	}
+	/*
+	 * If device supports SE engines and there is SE microcode in tar
+	 * archive try to create engine group with SE engines.
+	 */
+	tar_info[0] = get_uc_from_tar_archive(tar_arch, OTX2_CPT_SE_TYPES);
+	if (tar_info[0] && dev_supports_eng_type(eng_grps, OTX2_CPT_SE_TYPES)) {
+
+		engs[0].type = OTX2_CPT_SE_TYPES;
+		engs[0].count = 2;
+
+		ret = create_engine_group(&pdev->dev, eng_grps, engs, 1,
+					  (void **) tar_info, 1, true);
+		if (ret)
+			goto release_tar;
+	}
+	/*
+	 * If device supports IE engines and there is IE microcode in tar
+	 * archive try to create engine group with IE engines.
+	 */
+	tar_info[0] = get_uc_from_tar_archive(tar_arch, OTX2_CPT_IE_TYPES);
+	if (tar_info[0] && dev_supports_eng_type(eng_grps, OTX2_CPT_IE_TYPES)) {
+
+		engs[0].type = OTX2_CPT_IE_TYPES;
+		engs[0].count = 2;
+
+		ret = create_engine_group(&pdev->dev, eng_grps, engs, 1,
+					  (void **) tar_info, 1, true);
+		if (ret)
+			goto release_tar;
+	}
+release_tar:
+	release_tar_archive(tar_arch);
+	return ret;
+}
+
+/*
+ * Get CPT HW capabilities using LOAD_FVC operation.
+ */
+int otx2_cpt_discover_eng_capabilities(void *obj)
+{
+	struct otx2_cptpf_dev *cptpf = obj;
+	struct otx2_cpt_iq_command iq_cmd;
+	union otx2_cpt_opcode opcode;
+	union otx2_cpt_res_s *result;
+	union otx2_cpt_inst_s inst;
+	dma_addr_t rptr_baddr;
+	struct pci_dev *pdev;
+	u32 len, compl_rlen;
+	int ret, etype;
+	void *rptr;
+
+	/*
+	 * We don't get capabilities if it was already done
+	 * (when user enabled VFs for the first time)
+	 */
+	if (cptpf->is_eng_caps_discovered)
+		return 0;
+
+	pdev = cptpf->pdev;
+	ret = create_eng_caps_discovery_grps(pdev, &cptpf->eng_grps);
+	if (ret)
+		goto delete_grps;
+
+	ret = otx2_cptpf_lf_init(cptpf, OTX2_CPT_ALL_ENG_GRPS_MASK,
+				 OTX2_CPT_QUEUE_HI_PRIO, 1);
+	if (ret)
+		goto delete_grps;
+
+	compl_rlen = ALIGN(sizeof(union otx2_cpt_res_s), OTX2_CPT_DMA_MINALIGN);
+	len = compl_rlen + LOADFVC_RLEN;
+
+	result = kzalloc(len, GFP_KERNEL);
+	if (!result) {
+		ret = -ENOMEM;
+		goto lf_cleanup;
+	}
+	rptr_baddr = dma_map_single(&pdev->dev, (void *)result, len,
+				    DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(&pdev->dev, rptr_baddr)) {
+		dev_err(&pdev->dev, "DMA mapping failed\n");
+		ret = -EFAULT;
+		goto free_result;
+	}
+	rptr = (u8 *)result + compl_rlen;
+
+	/* Fill in the command */
+	opcode.s.major = LOADFVC_MAJOR_OP;
+	opcode.s.minor = LOADFVC_MINOR_OP;
+
+	iq_cmd.cmd.u = 0;
+	iq_cmd.cmd.s.opcode = cpu_to_be16(opcode.flags);
+
+	/* 64-bit swap for microcode data reads, not needed for addresses */
+	cpu_to_be64s(&iq_cmd.cmd.u);
+	iq_cmd.dptr = 0;
+	iq_cmd.rptr = rptr_baddr + compl_rlen;
+	iq_cmd.cptr.u = 0;
+
+	for (etype = 1; etype < OTX2_CPT_MAX_ENG_TYPES; etype++) {
+		result->s.compcode = OTX2_CPT_COMPLETION_CODE_INIT;
+		iq_cmd.cptr.s.grp = get_eng_caps_discovery_grp(
+						&cptpf->eng_grps, etype);
+		otx2_cpt_fill_inst(&inst, &iq_cmd, rptr_baddr);
+		otx2_cpt_send_cmd(&inst, 1, &cptpf->lfs.lf[0]);
+
+		while (result->s.compcode == OTX2_CPT_COMPLETION_CODE_INIT)
+			cpu_relax();
+
+		cptpf->eng_caps[etype].u = be64_to_cpup(rptr);
+	}
+	dma_unmap_single(&pdev->dev, rptr_baddr, len, DMA_BIDIRECTIONAL);
+	cptpf->is_eng_caps_discovered = true;
+free_result:
+	kzfree(result);
+lf_cleanup:
+	otx2_cptpf_lf_cleanup(&cptpf->lfs);
+delete_grps:
+	delete_eng_caps_discovery_grps(pdev, &cptpf->eng_grps);
+
+	return ret;
+}
+
+
+int otx2_cpt_try_create_default_eng_grps(struct pci_dev *pdev,
+					 struct otx2_cpt_eng_grps *eng_grps)
+{
+	struct tar_ucode_info_t *tar_info[OTX2_CPT_MAX_ETYPES_PER_GRP] = {  };
+	struct otx2_cpt_engines engs[OTX2_CPT_MAX_ETYPES_PER_GRP] = { {0} };
+	struct tar_arch_info_t *tar_arch = NULL;
+	char tar_filename[OTX2_CPT_NAME_LENGTH];
+	int i, ret = 0;
+
+	mutex_lock(&eng_grps->lock);
+
+	/*
+	 * We don't create engine group for kernel crypto if attempt to create
+	 * it was already made (when user enabled VFs for the first time)
+	 */
+	if (eng_grps->is_first_try)
+		goto unlock_mutex;
+	eng_grps->is_first_try = true;
+
+	/* We create group for kcrypto only if no groups are configured */
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++)
+		if (eng_grps->grp[i].is_enabled)
+			goto unlock_mutex;
+
+	sprintf(tar_filename, "cpt%02d-mc.tar", pdev->revision);
+
+	tar_arch = load_tar_archive(&pdev->dev, tar_filename);
+	if (!tar_arch)
+		goto unlock_mutex;
+
+	/*
+	 * If device supports SE engines and there is SE microcode in tar
+	 * archive try to create engine group with SE engines for kernel
+	 * crypto functionality (symmetric crypto)
+	 */
+	tar_info[0] = get_uc_from_tar_archive(tar_arch, OTX2_CPT_SE_TYPES);
+	if (tar_info[0] && dev_supports_eng_type(eng_grps, OTX2_CPT_SE_TYPES)) {
+
+		engs[0].type = OTX2_CPT_SE_TYPES;
+		engs[0].count = eng_grps->avail.max_se_cnt;
+
+		ret = create_engine_group(&pdev->dev, eng_grps, engs, 1,
+					  (void **) tar_info, 1, true);
+		if (ret)
+			goto release_tar_arch;
+	}
+
+	/*
+	 * If device supports SE+IE engines and there is SE and IE microcode in
+	 * tar archive try to create engine group with SE+IE engines for IPSec.
+	 * All SE engines will be shared with engine group 0.
+	 */
+	tar_info[0] = get_uc_from_tar_archive(tar_arch, OTX2_CPT_SE_TYPES);
+	tar_info[1] = get_uc_from_tar_archive(tar_arch, OTX2_CPT_IE_TYPES);
+	if (tar_info[0] && tar_info[1] &&
+	    dev_supports_eng_type(eng_grps, OTX2_CPT_SE_TYPES) &&
+	    dev_supports_eng_type(eng_grps, OTX2_CPT_IE_TYPES)) {
+
+		engs[0].type = OTX2_CPT_SE_TYPES;
+		engs[0].count = eng_grps->avail.max_se_cnt;
+		engs[1].type = OTX2_CPT_IE_TYPES;
+		engs[1].count = eng_grps->avail.max_ie_cnt;
+
+		ret = create_engine_group(&pdev->dev, eng_grps, engs, 2,
+					  (void **) tar_info, 2, true);
+		if (ret)
+			goto release_tar_arch;
+	}
+
+	/*
+	 * If device supports AE engines and there is AE microcode in tar
+	 * archive try to create engine group with AE engines for asymmetric
+	 * crypto functionality.
+	 */
+	tar_info[0] = get_uc_from_tar_archive(tar_arch, OTX2_CPT_AE_TYPES);
+	if (tar_info[0] && dev_supports_eng_type(eng_grps, OTX2_CPT_AE_TYPES)) {
+
+		engs[0].type = OTX2_CPT_AE_TYPES;
+		engs[0].count = eng_grps->avail.max_ae_cnt;
+
+		ret = create_engine_group(&pdev->dev, eng_grps, engs, 1,
+					  (void **) tar_info, 1, true);
+		if (ret)
+			goto release_tar_arch;
+	}
+
+	print_dbg_info(&pdev->dev, eng_grps);
+release_tar_arch:
+	release_tar_archive(tar_arch);
+unlock_mutex:
+	mutex_unlock(&eng_grps->lock);
+	return ret;
+}
+
+void otx2_cpt_set_eng_grps_is_rdonly(struct otx2_cpt_eng_grps *eng_grps,
+				     bool is_rdonly)
+{
+	mutex_lock(&eng_grps->lock);
+
+	eng_grps->is_rdonly = is_rdonly;
+
+	mutex_unlock(&eng_grps->lock);
+}
+
+int otx2_cpt_disable_all_cores(struct otx2_cptpf_dev *cptpf)
+{
+	int i, ret, busy, total_cores;
+	int timeout = 10;
+	u64 reg = 0;
+
+	total_cores = cptpf->eng_grps.avail.max_se_cnt +
+		      cptpf->eng_grps.avail.max_ie_cnt +
+		      cptpf->eng_grps.avail.max_ae_cnt;
+
+	/* Disengage the cores from groups */
+	for (i = 0; i < total_cores; i++) {
+		ret = otx2_cpt_add_write_af_reg(cptpf->pdev,
+						CPT_AF_EXEX_CTL2(i), 0x0);
+		if (ret)
+			return ret;
+
+		cptpf->eng_grps.eng_ref_cnt[i] = 0;
+	}
+	ret = otx2_cpt_send_af_reg_requests(cptpf->pdev);
+	if (ret)
+		return ret;
+
+	/* Wait for cores to become idle */
+	do {
+		busy = 0;
+		usleep_range(10000, 20000);
+		if (timeout-- < 0)
+			return -EBUSY;
+
+		for (i = 0; i < total_cores; i++) {
+			ret = otx2_cpt_read_af_reg(cptpf->pdev,
+						   CPT_AF_EXEX_STS(i), &reg);
+			if (ret)
+				return ret;
+
+			if (reg & 0x1) {
+				busy = 1;
+				break;
+			}
+		}
+	} while (busy);
+
+	/* Disable the cores */
+	for (i = 0; i < total_cores; i++) {
+		ret = otx2_cpt_add_write_af_reg(cptpf->pdev, CPT_AF_EXEX_CTL(i),
+						0x0);
+		if (ret)
+			return ret;
+	}
+	ret = otx2_cpt_send_af_reg_requests(cptpf->pdev);
+
+	return ret;
+}
+
+void otx2_cpt_cleanup_eng_grps(struct pci_dev *pdev,
+			       struct otx2_cpt_eng_grps *eng_grps)
+{
+	struct otx2_cpt_eng_grp_info *grp;
+	int i, j;
+
+	mutex_lock(&eng_grps->lock);
+	if (eng_grps->is_ucode_load_created) {
+		device_remove_file(&pdev->dev,
+				   &eng_grps->ucode_load_attr);
+		eng_grps->is_ucode_load_created = false;
+	}
+
+	/* First delete all mirroring engine groups */
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++)
+		if (eng_grps->grp[i].mirror.is_ena)
+			delete_engine_group(&pdev->dev, &eng_grps->grp[i]);
+
+	/* Delete remaining engine groups */
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++)
+		delete_engine_group(&pdev->dev, &eng_grps->grp[i]);
+
+	/* Release memory */
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+		grp = &eng_grps->grp[i];
+		for (j = 0; j < OTX2_CPT_MAX_ETYPES_PER_GRP; j++) {
+			kfree(grp->engs[j].bmap);
+			grp->engs[j].bmap = NULL;
+		}
+	}
+	mutex_unlock(&eng_grps->lock);
+}
+
+int otx2_cpt_init_eng_grps(struct pci_dev *pdev,
+			   struct otx2_cpt_eng_grps *eng_grps)
+{
+	struct otx2_cpt_eng_grp_info *grp;
+	int i, j, ret;
+
+	mutex_init(&eng_grps->lock);
+	eng_grps->obj = pci_get_drvdata(pdev);
+	eng_grps->avail.se_cnt = eng_grps->avail.max_se_cnt;
+	eng_grps->avail.ie_cnt = eng_grps->avail.max_ie_cnt;
+	eng_grps->avail.ae_cnt = eng_grps->avail.max_ae_cnt;
+
+	eng_grps->engs_num = eng_grps->avail.max_se_cnt +
+			     eng_grps->avail.max_ie_cnt +
+			     eng_grps->avail.max_ae_cnt;
+	if (eng_grps->engs_num > OTX2_CPT_MAX_ENGINES) {
+		dev_err(&pdev->dev,
+			"Number of engines %d > than max supported %d\n",
+			eng_grps->engs_num, OTX2_CPT_MAX_ENGINES);
+		ret = -EINVAL;
+		goto cleanup_eng_grps;
+	}
+
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+		grp = &eng_grps->grp[i];
+		grp->g = eng_grps;
+		grp->idx = i;
+
+		snprintf(grp->sysfs_info_name, OTX2_CPT_NAME_LENGTH,
+			 "engine_group%d", i);
+		for (j = 0; j < OTX2_CPT_MAX_ETYPES_PER_GRP; j++) {
+			grp->engs[j].bmap =
+				kcalloc(BITS_TO_LONGS(eng_grps->engs_num),
+					sizeof(long), GFP_KERNEL);
+			if (!grp->engs[j].bmap) {
+				ret = -ENOMEM;
+				goto cleanup_eng_grps;
+			}
+		}
+	}
+
+	eng_grps->eng_types_supported = 1 << OTX2_CPT_SE_TYPES |
+					1 << OTX2_CPT_IE_TYPES |
+					1 << OTX2_CPT_AE_TYPES;
+
+	eng_grps->ucode_load_attr.show = NULL;
+	eng_grps->ucode_load_attr.store = ucode_load_store;
+	eng_grps->ucode_load_attr.attr.name = "ucode_load";
+	eng_grps->ucode_load_attr.attr.mode = 0220;
+	sysfs_attr_init(&eng_grps->ucode_load_attr.attr);
+	ret = device_create_file(&pdev->dev,
+				 &eng_grps->ucode_load_attr);
+	if (ret)
+		goto cleanup_eng_grps;
+	eng_grps->is_ucode_load_created = true;
+
+	print_dbg_info(&pdev->dev, eng_grps);
+	return 0;
+cleanup_eng_grps:
+	otx2_cpt_cleanup_eng_grps(pdev, eng_grps);
+	return ret;
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
new file mode 100644
index 000000000000..8144b8623f74
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
@@ -0,0 +1,180 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef __OTX2_CPTPF_UCODE_H
+#define __OTX2_CPTPF_UCODE_H
+
+#include <linux/pci.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include "otx2_cpt_hw_types.h"
+#include "otx2_cpt_common.h"
+
+/*
+ * On OcteonTX2 platform IPSec ucode can use both IE and SE engines therefore
+ * IE and SE engines can be attached to the same engine group.
+ */
+#define OTX2_CPT_MAX_ETYPES_PER_GRP 2
+
+/* CPT ucode alignment */
+#define OTX2_CPT_UCODE_ALIGNMENT    128
+
+/* CPT ucode signature size */
+#define OTX2_CPT_UCODE_SIGN_LEN     256
+
+/* Microcode version string length */
+#define OTX2_CPT_UCODE_VER_STR_SZ   44
+
+/* Maximum number of supported engines/cores on OcteonTX2 platform */
+#define OTX2_CPT_MAX_ENGINES        128
+
+#define OTX2_CPT_ENGS_BITMASK_LEN   (OTX2_CPT_MAX_ENGINES/(BITS_PER_BYTE * \
+					 sizeof(unsigned long)))
+
+/* Microcode types */
+enum otx2_cpt_ucode_type {
+	OTX2_CPT_AE_UC_TYPE = 1,  /* AE-MAIN */
+	OTX2_CPT_SE_UC_TYPE1 = 20,/* SE-MAIN - combination of 21 and 22 */
+	OTX2_CPT_SE_UC_TYPE2 = 21,/* Fast Path IPSec + AirCrypto */
+	OTX2_CPT_SE_UC_TYPE3 = 22,/*
+				   * Hash + HMAC + FlexiCrypto + RNG +
+				   * Full Feature IPSec + AirCrypto + Kasumi
+				   */
+	OTX2_CPT_IE_UC_TYPE1 = 30, /* IE-MAIN - combination of 31 and 32 */
+	OTX2_CPT_IE_UC_TYPE2 = 31, /* Fast Path IPSec */
+	OTX2_CPT_IE_UC_TYPE3 = 32, /*
+				    * Hash + HMAC + FlexiCrypto + RNG +
+				    * Full Future IPSec
+				    */
+};
+
+struct otx2_cpt_bitmap {
+	unsigned long bits[OTX2_CPT_ENGS_BITMASK_LEN];
+	int size;
+};
+
+struct otx2_cpt_engines {
+	int type;
+	int count;
+};
+
+/* Microcode version number */
+struct otx2_cpt_ucode_ver_num {
+	u8 nn;
+	u8 xx;
+	u8 yy;
+	u8 zz;
+};
+
+struct otx2_cpt_ucode_hdr {
+	struct otx2_cpt_ucode_ver_num ver_num;
+	u8 ver_str[OTX2_CPT_UCODE_VER_STR_SZ];
+	__be32 code_length;
+	u32 padding[3];
+};
+
+struct otx2_cpt_ucode {
+	u8 ver_str[OTX2_CPT_UCODE_VER_STR_SZ];/*
+					       * ucode version in readable
+					       * format
+					       */
+	struct otx2_cpt_ucode_ver_num ver_num;/* ucode version number */
+	char filename[OTX2_CPT_NAME_LENGTH];/* ucode filename */
+	dma_addr_t dma;		/* phys address of ucode image */
+	dma_addr_t align_dma;	/* aligned phys address of ucode image */
+	void *va;		/* virt address of ucode image */
+	void *align_va;		/* aligned virt address of ucode image */
+	u32 size;		/* ucode image size */
+	int type;		/* ucode image type SE, IE, AE or SE+IE */
+};
+
+struct tar_ucode_info_t {
+	struct list_head list;
+	struct otx2_cpt_ucode ucode;/* microcode information */
+	const u8 *ucode_ptr;	/* pointer to microcode in tar archive */
+};
+
+/* Maximum and current number of engines available for all engine groups */
+struct otx2_cpt_engs_available {
+	int max_se_cnt;
+	int max_ie_cnt;
+	int max_ae_cnt;
+	int se_cnt;
+	int ie_cnt;
+	int ae_cnt;
+};
+
+/* Engines reserved to an engine group */
+struct otx2_cpt_engs_rsvd {
+	int type;	/* engine type */
+	int count;	/* number of engines attached */
+	int offset;     /* constant offset of engine type in the bitmap */
+	unsigned long *bmap;		/* attached engines bitmap */
+	struct otx2_cpt_ucode *ucode;	/* ucode used by these engines */
+};
+
+struct otx2_cpt_mirror_info {
+	int is_ena;	/*
+			 * is mirroring enabled, it is set only for engine
+			 * group which mirrors another engine group
+			 */
+	int idx;	/*
+			 * index of engine group which is mirrored by this
+			 * group, set only for engine group which mirrors
+			 * another group
+			 */
+	int ref_count;	/*
+			 * number of times this engine group is mirrored by
+			 * other groups, this is set only for engine group
+			 * which is mirrored by other group(s)
+			 */
+};
+
+struct otx2_cpt_eng_grp_info {
+	struct otx2_cpt_eng_grps *g; /* pointer to engine_groups structure */
+	struct device_attribute info_attr; /* group info entry attr */
+	/* engines attached */
+	struct otx2_cpt_engs_rsvd engs[OTX2_CPT_MAX_ETYPES_PER_GRP];
+	/* ucodes information */
+	struct otx2_cpt_ucode ucode[OTX2_CPT_MAX_ETYPES_PER_GRP];
+	/* sysfs info entry name */
+	char sysfs_info_name[OTX2_CPT_NAME_LENGTH];
+	/* engine group mirroring information */
+	struct otx2_cpt_mirror_info mirror;
+	int idx;	 /* engine group index */
+	bool is_enabled; /*
+			  * is engine group enabled, engine group is enabled
+			  * when it has engines attached and ucode loaded
+			  */
+};
+
+struct otx2_cpt_eng_grps {
+	struct otx2_cpt_eng_grp_info grp[OTX2_CPT_MAX_ENGINE_GROUPS];
+	struct device_attribute ucode_load_attr;/* ucode load attr */
+	struct otx2_cpt_engs_available avail;
+	struct mutex lock;
+	void *obj;			/* device specific data */
+	int engs_num;			/* total number of engines supported */
+	int eng_types_supported;	/* engine types supported SE, IE, AE */
+	u8 eng_ref_cnt[OTX2_CPT_MAX_ENGINES];/* engines reference count */
+	bool is_ucode_load_created;	/* is ucode_load sysfs entry created */
+	bool is_first_try; /* is this first try to create kcrypto engine grp */
+	bool is_rdonly;	/* do engine groups configuration can be modified */
+};
+struct otx2_cptpf_dev;
+int otx2_cpt_init_eng_grps(struct pci_dev *pdev,
+			   struct otx2_cpt_eng_grps *eng_grps);
+void otx2_cpt_cleanup_eng_grps(struct pci_dev *pdev,
+			       struct otx2_cpt_eng_grps *eng_grps);
+int otx2_cpt_try_create_default_eng_grps(struct pci_dev *pdev,
+					 struct otx2_cpt_eng_grps *eng_grps);
+void otx2_cpt_set_eng_grps_is_rdonly(struct otx2_cpt_eng_grps *eng_grps,
+				     bool is_rdonly);
+int otx2_cpt_uc_supports_eng_type(struct otx2_cpt_ucode *ucode, int eng_type);
+int otx2_cpt_eng_grp_has_eng_type(struct otx2_cpt_eng_grp_info *eng_grp,
+				  int eng_type);
+int otx2_cpt_disable_all_cores(struct otx2_cptpf_dev *cptpf);
+int otx2_cpt_discover_eng_capabilities(void *obj);
+
+#endif /* __OTX2_CPTPF_UCODE_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf.h b/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
new file mode 100644
index 000000000000..51039c7a7195
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
@@ -0,0 +1,24 @@
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
+#endif /* __OTX2_CPTVF_H */
-- 
2.28.0

