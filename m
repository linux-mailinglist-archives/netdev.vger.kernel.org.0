Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFAA288CD9
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389360AbgJIPfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:35:41 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61704 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389259AbgJIPfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:35:38 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 099FV3Tf023632;
        Fri, 9 Oct 2020 08:35:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=/WSjSXGfnCfP4hhQJMit/fGb2HQvAeI++iiOSEdg+gY=;
 b=CIHxCJTIqcOMCrtXTFunN3Lzq8WOoTxYx1of3oZF8IpBY8g8hFBKy8S2s3kMT9jF9hTh
 aAKA1+a8ZPSE/3UFipPCTaAfYPj5Ei6ee100d4piFd5ZzEls3pFVvZ61wJOLnWUiOkKb
 EomJPO89rPvy4uJgvDWNFEjCqlmsyS4Xw5oa6DANVqXANrsB8FcpmkilRD8sQxnnB7GS
 PxULSw5UC5fuZPPIPHY/jkpLLl8BLWzPw4dY29GiWQ/xAOD0snMEujLcE9eh3EEtbQGN
 rWq5QIrUXv9zi8zbG8sVxc+YjfxjxGW4r+h/ZiIfExcMAiF+l9u/k/LU86AU/fQKcK+V MA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3429hh34pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Oct 2020 08:35:27 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 08:35:25 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 08:35:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Oct 2020 08:35:25 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id ED3D43F703F;
        Fri,  9 Oct 2020 08:35:21 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v4,net-next,04/13] drivers: crypto: add Marvell OcteonTX2 CPT PF driver
Date:   Fri, 9 Oct 2020 21:04:12 +0530
Message-ID: <20201009153421.30562-5-schalla@marvell.com>
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

Adds skeleton for the Marvell OcteonTX2 CPT physical function
driver which includes probe, PCI specific initialization and
hardware register defines.
RVU defines are present in AF driver
(drivers/net/ethernet/marvell/octeontx2/af), header files from
AF driver are included here to avoid duplication.

Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/Kconfig                |  10 +
 drivers/crypto/marvell/Makefile               |   1 +
 drivers/crypto/marvell/octeontx2/Makefile     |   6 +
 .../marvell/octeontx2/otx2_cpt_common.h       |  32 ++
 .../marvell/octeontx2/otx2_cpt_hw_types.h     | 464 ++++++++++++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |  13 +
 .../marvell/octeontx2/otx2_cptpf_main.c       | 115 +++++
 7 files changed, 641 insertions(+)
 create mode 100644 drivers/crypto/marvell/octeontx2/Makefile
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c

diff --git a/drivers/crypto/marvell/Kconfig b/drivers/crypto/marvell/Kconfig
index 13063384f958..1440ec9e1fb4 100644
--- a/drivers/crypto/marvell/Kconfig
+++ b/drivers/crypto/marvell/Kconfig
@@ -35,3 +35,13 @@ config CRYPTO_DEV_OCTEONTX_CPT
 
 		To compile this driver as module, choose M here:
 		the modules will be called octeontx-cpt and octeontx-cptvf
+
+config CRYPTO_DEV_OCTEONTX2_CPT
+	tristate "Marvell OcteonTX2 CPT driver"
+	depends on ARM64 || COMPILE_TEST
+	depends on PCI_MSI && 64BIT
+	select OCTEONTX2_MBOX
+	select CRYPTO_DEV_MARVELL
+	help
+		This driver allows you to utilize the Marvell Cryptographic
+		Accelerator Unit(CPT) found in OcteonTX2 series of processors.
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
index 000000000000..db763ad46a91
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += octeontx2-cpt.o
+
+octeontx2-cpt-objs := otx2_cptpf_main.o
+
+ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
new file mode 100644
index 000000000000..eff4ffa58dc4
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -0,0 +1,32 @@
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
+#define OTX2_CPT_RVU_FUNC_ADDR_S(blk, slot, offs) \
+		(((blk) << 20) | ((slot) << 12) | (offs))
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
index 000000000000..ecafc42f37a2
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
@@ -0,0 +1,464 @@
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
+/* RVU VF registers */
+#define OTX2_RVU_VF_INT                 (0x20)
+#define OTX2_RVU_VF_INT_W1S             (0x28)
+#define OTX2_RVU_VF_INT_ENA_W1S         (0x30)
+#define OTX2_RVU_VF_INT_ENA_W1C         (0x38)
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
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
new file mode 100644
index 000000000000..84cdc8cc2c15
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef __OTX2_CPTPF_H
+#define __OTX2_CPTPF_H
+
+struct otx2_cptpf_dev {
+	void __iomem *reg_base;		/* CPT PF registers start address */
+	struct pci_dev *pdev;		/* PCI device handle */
+};
+
+#endif /* __OTX2_CPTPF_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
new file mode 100644
index 000000000000..d46015e2acb8
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include <linux/firmware.h>
+#include "otx2_cpt_hw_types.h"
+#include "otx2_cpt_common.h"
+#include "otx2_cptpf.h"
+#include "rvu_reg.h"
+
+#define OTX2_CPT_DRV_NAME    "octeontx2-cpt"
+#define OTX2_CPT_DRV_STRING  "Marvell OcteonTX2 CPT Physical Function Driver"
+#define OTX2_CPT_DRV_VERSION "1.0"
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
+static int otx2_cptpf_probe(struct pci_dev *pdev,
+			    const struct pci_device_id *ent)
+{
+	struct device *dev = &pdev->dev;
+	struct otx2_cptpf_dev *cptpf;
+	int err;
+
+	cptpf = devm_kzalloc(dev, sizeof(*cptpf), GFP_KERNEL);
+	if (!cptpf)
+		return -ENOMEM;
+
+	err = pcim_enable_device(pdev);
+	if (err) {
+		dev_err(dev, "Failed to enable PCI device\n");
+		goto clear_drvdata;
+	}
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
+	pci_set_master(pdev);
+	pci_set_drvdata(pdev, cptpf);
+	cptpf->pdev = pdev;
+
+	cptpf->reg_base = pcim_iomap_table(pdev)[PCI_PF_REG_BAR_NUM];
+
+	/* Check if AF driver is up, otherwise defer probe */
+	err = cpt_is_pf_usable(cptpf);
+	if (err)
+		goto clear_drvdata;
+
+	return 0;
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
+};
+
+module_pci_driver(otx2_cpt_pci_driver);
+
+MODULE_AUTHOR("Marvell");
+MODULE_DESCRIPTION(OTX2_CPT_DRV_STRING);
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(OTX2_CPT_DRV_VERSION);
+MODULE_DEVICE_TABLE(pci, otx2_cpt_id_table);
-- 
2.28.0

