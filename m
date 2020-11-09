Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D3F2AB7CF
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 13:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbgKIMKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 07:10:13 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2838 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726410AbgKIMKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 07:10:13 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A9C9sAm011326;
        Mon, 9 Nov 2020 04:10:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=fZG6ngg59MIm1RHjdYKJT0H3mLGU/LQ0Yf5VZIPSnvY=;
 b=PBLnz+6B+E3H7lMJ8E2w1iM3hZtuVSIs7uYOVBRy29KAll/DG7PnqJLazuZ4GhnvvmEV
 5zpadhXJBOL0Aa0thIO33HZVGyDQ+wsPudtIsLmKNFOefef+84rl1Ft16cY5tgPsw7Uy
 3StFtSAvH+UQqIRCsijiT4RgSALyfAVLJbUSBCiE9he/QE6uLmQhSvoJ2CvncV328eMf
 5n5ZWeSS+A5CIHQnqyPYrUqGvIOszFp1uXsbgprN5KqNbeL2+h6ztAu5on4vwT4nfVVo
 1XW7rh1pyIomY8LgitUxEJ5pILCPKrFKvLaBk2h8r0dUPujxdzelu4uyRSI50IILV1Bm kQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34nuysad97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 04:10:07 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 9 Nov
 2020 04:10:05 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 9 Nov
 2020 04:10:05 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 9 Nov 2020 04:10:05 -0800
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 220E03F704D;
        Mon,  9 Nov 2020 04:10:00 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>,
        Lukasz Bartosik <lbartosik@marvell.com>
Subject: [PATCH v9,net-next,02/12] octeontx2-af: add mailbox interface for CPT
Date:   Mon, 9 Nov 2020 17:39:14 +0530
Message-ID: <20201109120924.358-3-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201109120924.358-1-schalla@marvell.com>
References: <20201109120924.358-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_02:2020-11-05,2020-11-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On OcteonTX2 SoC, the admin function (AF) is the only one with all
priviliges to configure HW and alloc resources, PFs and it's VFs
have to request AF via mailbox for all their needs. This patch adds
a mailbox interface for CPT PFs and VFs to allocate resources
for cryptography. It also adds hardware CPT AF register defines.

Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Lukasz Bartosik <lbartosik@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/Makefile    |   3 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  33 +++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 233 ++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  63 ++++-
 4 files changed, 325 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index 2f7a861d0c7b..d258b9a8cefb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_OCTEONTX2_AF) += octeontx2_af.o
 
 octeontx2_mbox-y := mbox.o rvu_trace.o
 octeontx2_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
-		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o
+		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o \
+		  rvu_cpt.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index f46de8419b77..3538c78b09d1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -158,6 +158,11 @@ M(NPA_HWCTX_DISABLE,	0x403, npa_hwctx_disable, hwctx_disable_req, msg_rsp)\
 /* SSO/SSOW mbox IDs (range 0x600 - 0x7FF) */				\
 /* TIM mbox IDs (range 0x800 - 0x9FF) */				\
 /* CPT mbox IDs (range 0xA00 - 0xBFF) */				\
+M(CPT_LF_ALLOC,		0xA00, cpt_lf_alloc, cpt_lf_alloc_req_msg,	\
+			       msg_rsp)					\
+M(CPT_LF_FREE,		0xA01, cpt_lf_free, msg_req, msg_rsp)		\
+M(CPT_RD_WR_REGISTER,	0xA02, cpt_rd_wr_register,  cpt_rd_wr_reg_msg,	\
+			       cpt_rd_wr_reg_msg)			\
 /* NPC mbox IDs (range 0x6000 - 0x7FFF) */				\
 M(NPC_MCAM_ALLOC_ENTRY,	0x6000, npc_mcam_alloc_entry, npc_mcam_alloc_entry_req,\
 				npc_mcam_alloc_entry_rsp)		\
@@ -898,4 +903,32 @@ struct ptp_rsp {
 	u64 clk;
 };
 
+/* CPT mailbox error codes
+ * Range 901 - 1000.
+ */
+enum cpt_af_status {
+	CPT_AF_ERR_PARAM		= -901,
+	CPT_AF_ERR_GRP_INVALID		= -902,
+	CPT_AF_ERR_LF_INVALID		= -903,
+	CPT_AF_ERR_ACCESS_DENIED	= -904,
+	CPT_AF_ERR_SSO_PF_FUNC_INVALID	= -905,
+	CPT_AF_ERR_NIX_PF_FUNC_INVALID	= -906
+};
+
+/* CPT mbox message formats */
+struct cpt_rd_wr_reg_msg {
+	struct mbox_msghdr hdr;
+	u64 reg_offset;
+	u64 *ret_val;
+	u64 val;
+	u8 is_write;
+};
+
+struct cpt_lf_alloc_req_msg {
+	struct mbox_msghdr hdr;
+	u16 nix_pf_func;
+	u16 sso_pf_func;
+	u16 eng_grpmsk;
+};
+
 #endif /* MBOX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
new file mode 100644
index 000000000000..35261d52c997
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -0,0 +1,233 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include <linux/pci.h>
+#include "rvu_struct.h"
+#include "rvu_reg.h"
+#include "mbox.h"
+#include "rvu.h"
+
+/* CPT PF device id */
+#define	PCI_DEVID_OTX2_CPT_PF	0xA0FD
+
+static int get_cpt_pf_num(struct rvu *rvu)
+{
+	int i, domain_nr, cpt_pf_num = -1;
+	struct pci_dev *pdev;
+
+	domain_nr = pci_domain_nr(rvu->pdev->bus);
+	for (i = 0; i < rvu->hw->total_pfs; i++) {
+		pdev = pci_get_domain_bus_and_slot(domain_nr, i + 1, 0);
+		if (!pdev)
+			continue;
+
+		if (pdev->device == PCI_DEVID_OTX2_CPT_PF) {
+			cpt_pf_num = i;
+			put_device(&pdev->dev);
+			break;
+		}
+		put_device(&pdev->dev);
+	}
+	return cpt_pf_num;
+}
+
+static bool is_cpt_pf(struct rvu *rvu, u16 pcifunc)
+{
+	int cpt_pf_num = get_cpt_pf_num(rvu);
+
+	if (rvu_get_pf(pcifunc) != cpt_pf_num)
+		return false;
+	if (pcifunc & RVU_PFVF_FUNC_MASK)
+		return false;
+
+	return true;
+}
+
+static bool is_cpt_vf(struct rvu *rvu, u16 pcifunc)
+{
+	int cpt_pf_num = get_cpt_pf_num(rvu);
+
+	if (rvu_get_pf(pcifunc) != cpt_pf_num)
+		return false;
+	if (!(pcifunc & RVU_PFVF_FUNC_MASK))
+		return false;
+
+	return true;
+}
+
+int rvu_mbox_handler_cpt_lf_alloc(struct rvu *rvu,
+				  struct cpt_lf_alloc_req_msg *req,
+				  struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_block *block;
+	int cptlf, blkaddr;
+	int num_lfs, slot;
+	u64 val;
+
+	if (req->eng_grpmsk == 0x0)
+		return CPT_AF_ERR_GRP_INVALID;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	block = &rvu->hw->block[blkaddr];
+	num_lfs = rvu_get_rsrc_mapcount(rvu_get_pfvf(rvu, pcifunc),
+					block->addr);
+	if (!num_lfs)
+		return CPT_AF_ERR_LF_INVALID;
+
+	/* Check if requested 'CPTLF <=> NIXLF' mapping is valid */
+	if (req->nix_pf_func) {
+		/* If default, use 'this' CPTLF's PFFUNC */
+		if (req->nix_pf_func == RVU_DEFAULT_PF_FUNC)
+			req->nix_pf_func = pcifunc;
+		if (!is_pffunc_map_valid(rvu, req->nix_pf_func, BLKTYPE_NIX))
+			return CPT_AF_ERR_NIX_PF_FUNC_INVALID;
+	}
+
+	/* Check if requested 'CPTLF <=> SSOLF' mapping is valid */
+	if (req->sso_pf_func) {
+		/* If default, use 'this' CPTLF's PFFUNC */
+		if (req->sso_pf_func == RVU_DEFAULT_PF_FUNC)
+			req->sso_pf_func = pcifunc;
+		if (!is_pffunc_map_valid(rvu, req->sso_pf_func, BLKTYPE_SSO))
+			return CPT_AF_ERR_SSO_PF_FUNC_INVALID;
+	}
+
+	for (slot = 0; slot < num_lfs; slot++) {
+		cptlf = rvu_get_lf(rvu, block, pcifunc, slot);
+		if (cptlf < 0)
+			return CPT_AF_ERR_LF_INVALID;
+
+		/* Set CPT LF group and priority */
+		val = (u64)req->eng_grpmsk << 48 | 1;
+		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), val);
+
+		/* Set CPT LF NIX_PF_FUNC and SSO_PF_FUNC */
+		val = (u64)req->nix_pf_func << 48 |
+		      (u64)req->sso_pf_func << 32;
+		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf), val);
+	}
+
+	return 0;
+}
+
+int rvu_mbox_handler_cpt_lf_free(struct rvu *rvu, struct msg_req *req,
+				 struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_block *block;
+	int cptlf, blkaddr;
+	int num_lfs, slot;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	block = &rvu->hw->block[blkaddr];
+	num_lfs = rvu_get_rsrc_mapcount(rvu_get_pfvf(rvu, pcifunc),
+					block->addr);
+	if (!num_lfs)
+		return CPT_AF_ERR_LF_INVALID;
+
+	for (slot = 0; slot < num_lfs; slot++) {
+		cptlf = rvu_get_lf(rvu, block, pcifunc, slot);
+		if (cptlf < 0)
+			return CPT_AF_ERR_LF_INVALID;
+
+		/* Reset CPT LF group and priority */
+		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), 0x0);
+		/* Reset CPT LF NIX_PF_FUNC and SSO_PF_FUNC */
+		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf), 0x0);
+	}
+
+	return 0;
+}
+
+static bool is_valid_offset(struct rvu *rvu, struct cpt_rd_wr_reg_msg *req)
+{
+	u64 offset = req->reg_offset;
+	int blkaddr, num_lfs, lf;
+	struct rvu_block *block;
+	struct rvu_pfvf *pfvf;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+
+	/* Registers that can be accessed from PF/VF */
+	if ((offset & 0xFF000) ==  CPT_AF_LFX_CTL(0) ||
+	    (offset & 0xFF000) ==  CPT_AF_LFX_CTL2(0)) {
+		if (offset & 7)
+			return false;
+
+		lf = (offset & 0xFFF) >> 3;
+		block = &rvu->hw->block[blkaddr];
+		pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
+		num_lfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
+		if (lf >= num_lfs)
+			/* Slot is not valid for that PF/VF */
+			return false;
+
+		/* Translate local LF used by VFs to global CPT LF */
+		lf = rvu_get_lf(rvu, &rvu->hw->block[blkaddr],
+				req->hdr.pcifunc, lf);
+		if (lf < 0)
+			return false;
+
+		return true;
+	} else if (!(req->hdr.pcifunc & RVU_PFVF_FUNC_MASK)) {
+		/* Registers that can be accessed from PF */
+		switch (offset) {
+		case CPT_AF_CTL:
+		case CPT_AF_PF_FUNC:
+		case CPT_AF_BLK_RST:
+		case CPT_AF_CONSTANTS1:
+			return true;
+		}
+
+		switch (offset & 0xFF000) {
+		case CPT_AF_EXEX_STS(0):
+		case CPT_AF_EXEX_CTL(0):
+		case CPT_AF_EXEX_CTL2(0):
+		case CPT_AF_EXEX_UCODE_BASE(0):
+			if (offset & 7)
+				return false;
+			break;
+		default:
+			return false;
+		}
+		return true;
+	}
+	return false;
+}
+
+int rvu_mbox_handler_cpt_rd_wr_register(struct rvu *rvu,
+					struct cpt_rd_wr_reg_msg *req,
+					struct cpt_rd_wr_reg_msg *rsp)
+{
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	/* This message is accepted only if sent from CPT PF/VF */
+	if (!is_cpt_pf(rvu, req->hdr.pcifunc) &&
+	    !is_cpt_vf(rvu, req->hdr.pcifunc))
+		return CPT_AF_ERR_ACCESS_DENIED;
+
+	rsp->reg_offset = req->reg_offset;
+	rsp->ret_val = req->ret_val;
+	rsp->is_write = req->is_write;
+
+	if (!is_valid_offset(rvu, req))
+		return CPT_AF_ERR_ACCESS_DENIED;
+
+	if (req->is_write)
+		rvu_write64(rvu, blkaddr, req->reg_offset, req->val);
+	else
+		rsp->val = rvu_read64(rvu, blkaddr, req->reg_offset);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 1f3379f12b81..0fb2aa909a23 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -429,12 +429,63 @@
 #define TIM_AF_LF_RST			(0x20)
 
 /* CPT */
-#define CPT_AF_CONSTANTS0		(0x0000)
-#define CPT_PRIV_LFX_CFG		(0x41000)
-#define CPT_PRIV_LFX_INT_CFG		(0x43000)
-#define CPT_AF_RVU_LF_CFG_DEBUG		(0x45000)
-#define CPT_AF_LF_RST			(0x44000)
-#define CPT_AF_BLK_RST			(0x46000)
+#define CPT_AF_CONSTANTS0               (0x0000)
+#define CPT_AF_CONSTANTS1               (0x1000)
+#define CPT_AF_DIAG                     (0x3000)
+#define CPT_AF_ECO                      (0x4000)
+#define CPT_AF_FLTX_INT(a)              (0xa000ull | (u64)(a) << 3)
+#define CPT_AF_FLTX_INT_W1S(a)          (0xb000ull | (u64)(a) << 3)
+#define CPT_AF_FLTX_INT_ENA_W1C(a)      (0xc000ull | (u64)(a) << 3)
+#define CPT_AF_FLTX_INT_ENA_W1S(a)      (0xd000ull | (u64)(a) << 3)
+#define CPT_AF_PSNX_EXE(a)              (0xe000ull | (u64)(a) << 3)
+#define CPT_AF_PSNX_EXE_W1S(a)          (0xf000ull | (u64)(a) << 3)
+#define CPT_AF_PSNX_LF(a)               (0x10000ull | (u64)(a) << 3)
+#define CPT_AF_PSNX_LF_W1S(a)           (0x11000ull | (u64)(a) << 3)
+#define CPT_AF_EXEX_CTL2(a)             (0x12000ull | (u64)(a) << 3)
+#define CPT_AF_EXEX_STS(a)              (0x13000ull | (u64)(a) << 3)
+#define CPT_AF_EXE_ERR_INFO             (0x14000)
+#define CPT_AF_EXEX_ACTIVE(a)           (0x16000ull | (u64)(a) << 3)
+#define CPT_AF_INST_REQ_PC              (0x17000)
+#define CPT_AF_INST_LATENCY_PC          (0x18000)
+#define CPT_AF_RD_REQ_PC                (0x19000)
+#define CPT_AF_RD_LATENCY_PC            (0x1a000)
+#define CPT_AF_RD_UC_PC                 (0x1b000)
+#define CPT_AF_ACTIVE_CYCLES_PC         (0x1c000)
+#define CPT_AF_EXE_DBG_CTL              (0x1d000)
+#define CPT_AF_EXE_DBG_DATA             (0x1e000)
+#define CPT_AF_EXE_REQ_TIMER            (0x1f000)
+#define CPT_AF_EXEX_CTL(a)              (0x20000ull | (u64)(a) << 3)
+#define CPT_AF_EXE_PERF_CTL             (0x21000)
+#define CPT_AF_EXE_DBG_CNTX(a)          (0x22000ull | (u64)(a) << 3)
+#define CPT_AF_EXE_PERF_EVENT_CNT       (0x23000)
+#define CPT_AF_EXE_EPCI_INBX_CNT(a)     (0x24000ull | (u64)(a) << 3)
+#define CPT_AF_EXE_EPCI_OUTBX_CNT(a)    (0x25000ull | (u64)(a) << 3)
+#define CPT_AF_EXEX_UCODE_BASE(a)       (0x26000ull | (u64)(a) << 3)
+#define CPT_AF_LFX_CTL(a)               (0x27000ull | (u64)(a) << 3)
+#define CPT_AF_LFX_CTL2(a)              (0x29000ull | (u64)(a) << 3)
+#define CPT_AF_CPTCLK_CNT               (0x2a000)
+#define CPT_AF_PF_FUNC                  (0x2b000)
+#define CPT_AF_LFX_PTR_CTL(a)           (0x2c000ull | (u64)(a) << 3)
+#define CPT_AF_GRPX_THR(a)              (0x2d000ull | (u64)(a) << 3)
+#define CPT_AF_CTL                      (0x2e000ull)
+#define CPT_AF_XEX_THR(a)               (0x2f000ull | (u64)(a) << 3)
+#define CPT_PRIV_LFX_CFG                (0x41000)
+#define CPT_PRIV_AF_INT_CFG             (0x42000)
+#define CPT_PRIV_LFX_INT_CFG            (0x43000)
+#define CPT_AF_LF_RST                   (0x44000)
+#define CPT_AF_RVU_LF_CFG_DEBUG         (0x45000)
+#define CPT_AF_BLK_RST                  (0x46000)
+#define CPT_AF_RVU_INT                  (0x47000)
+#define CPT_AF_RVU_INT_W1S              (0x47008)
+#define CPT_AF_RVU_INT_ENA_W1S          (0x47010)
+#define CPT_AF_RVU_INT_ENA_W1C          (0x47018)
+#define CPT_AF_RAS_INT                  (0x47020)
+#define CPT_AF_RAS_INT_W1S              (0x47028)
+#define CPT_AF_RAS_INT_ENA_W1S          (0x47030)
+#define CPT_AF_RAS_INT_ENA_W1C          (0x47038)
+
+#define CPT_AF_LF_CTL2_SHIFT 3
+#define CPT_AF_LF_SSO_PF_FUNC_SHIFT 32
 
 #define NPC_AF_BLK_RST                  (0x00040)
 
-- 
2.28.0

