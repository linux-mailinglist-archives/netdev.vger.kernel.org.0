Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C935E30C3DA
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235598AbhBBPbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:31:21 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57824 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232554AbhBBP2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 10:28:54 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 112FPbOw000974;
        Tue, 2 Feb 2021 07:28:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=77udfHydF5b4ageGCEPBplqTtNg0qQhTfRVrQDn5kps=;
 b=MYDkxVaeYK9tanKc58fG9fZIb5T4CcukQbSYsJk0nXF/Xd0gmrmqC5eYChAtw2ZgDFJU
 q+JtKKFgdNDySI+EfICZ7IbRvxgxQx5NMRiBeinggrEW48oiU4z2l1GN4viWRyIUz2ZF
 /o6m53cyps1Pm4n9xYhSQJsATlgrhFum241n/ilLHvNrvqjnfH4do1maPQEEJK/Rwamr
 KRsB1bOr9yIw4h6kHU05RlNZ3mpCBASWpBPQQzC/RDjFhCanvv1qOo1NcwdAdtsCMm3A
 rMKNfkFTB9y2CmbiuunTKNSjDNc+z5bSE71BsmEdo3ipoJeX1Xu3QSBCepIimCMGUO8I Uw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d7uq7hqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 07:28:10 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Feb
 2021 07:28:08 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Feb
 2021 07:28:07 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Feb 2021 07:28:07 -0800
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 805223F7043;
        Tue,  2 Feb 2021 07:28:04 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, <jerinj@marvell.com>,
        Srujana Challa <schalla@marvell.com>
Subject: [PATCH v2,net-next,3/3] octeontx2-af: Handle CPT function level reset
Date:   Tue, 2 Feb 2021 20:57:09 +0530
Message-ID: <20210202152709.20450-4-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210202152709.20450-1-schalla@marvell.com>
References: <20210202152709.20450-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-02_07:2021-02-02,2021-02-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When FLR is initiated for a VF (PCI function level reset),
the parent PF gets a interrupt. PF then sends a message to
admin function (AF), which then cleans up all resources
attached to that VF. This patch adds support to handle
CPT FLR.

Signed-off-by: Narayana Prasad Raju Atherya <pathreya@marvell.com>
Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  3 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  2 +
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 89 +++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  8 ++
 4 files changed, 102 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 4ef7fc8bbb19..50c2a1d800f4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2150,6 +2150,9 @@ static void rvu_blklf_teardown(struct rvu *rvu, u16 pcifunc, u8 blkaddr)
 			rvu_nix_lf_teardown(rvu, pcifunc, block->addr, lf);
 		else if (block->addr == BLKADDR_NPA)
 			rvu_npa_lf_teardown(rvu, pcifunc, lf);
+		else if ((block->addr == BLKADDR_CPT0) ||
+			 (block->addr == BLKADDR_CPT1))
+			rvu_cpt_lf_teardown(rvu, pcifunc, lf, slot);
 
 		err = rvu_lf_reset(rvu, block, lf);
 		if (err) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index aabf6d5ee020..ce931d86600b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -608,6 +608,8 @@ void npc_enable_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 void npc_read_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 			 int blkaddr, u16 src, struct mcam_entry *entry,
 			 u8 *intf, u8 *ena);
+/* CPT APIs */
+int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot);
 
 #ifdef CONFIG_DEBUG_FS
 void rvu_dbg_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index b6de4b95a72a..0945c3a3b180 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -240,3 +240,92 @@ int rvu_mbox_handler_cpt_rd_wr_register(struct rvu *rvu,
 
 	return 0;
 }
+
+#define INPROG_INFLIGHT(reg)    ((reg) & 0x1FF)
+#define INPROG_GRB_PARTIAL(reg) ((reg) & BIT_ULL(31))
+#define INPROG_GRB(reg)         (((reg) >> 32) & 0xFF)
+#define INPROG_GWB(reg)         (((reg) >> 40) & 0xFF)
+
+static void cpt_lf_disable_iqueue(struct rvu *rvu, int blkaddr, int slot)
+{
+	int i = 0, hard_lp_ctr = 100000;
+	u64 inprog, grp_ptr;
+	u16 nq_ptr, dq_ptr;
+
+	/* Disable instructions enqueuing */
+	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_ALIASX(slot, CPT_LF_CTL), 0x0);
+
+	/* Disable executions in the LF's queue */
+	inprog = rvu_read64(rvu, blkaddr,
+			    CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG));
+	inprog &= ~BIT_ULL(16);
+	rvu_write64(rvu, blkaddr,
+		    CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG), inprog);
+
+	/* Wait for CPT queue to become execution-quiescent */
+	do {
+		inprog = rvu_read64(rvu, blkaddr,
+				    CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG));
+		if (INPROG_GRB_PARTIAL(inprog)) {
+			i = 0;
+			hard_lp_ctr--;
+		} else {
+			i++;
+		}
+
+		grp_ptr = rvu_read64(rvu, blkaddr,
+				     CPT_AF_BAR2_ALIASX(slot,
+							CPT_LF_Q_GRP_PTR));
+		nq_ptr = (grp_ptr >> 32) & 0x7FFF;
+		dq_ptr = grp_ptr & 0x7FFF;
+
+	} while (hard_lp_ctr && (i < 10) && (nq_ptr != dq_ptr));
+
+	if (hard_lp_ctr == 0)
+		dev_warn(rvu->dev, "CPT FLR hits hard loop counter\n");
+
+	i = 0;
+	hard_lp_ctr = 100000;
+	do {
+		inprog = rvu_read64(rvu, blkaddr,
+				    CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG));
+
+		if ((INPROG_INFLIGHT(inprog) == 0) &&
+		    (INPROG_GWB(inprog) < 40) &&
+		    ((INPROG_GRB(inprog) == 0) ||
+		     (INPROG_GRB((inprog)) == 40))) {
+			i++;
+		} else {
+			i = 0;
+			hard_lp_ctr--;
+		}
+	} while (hard_lp_ctr && (i < 10));
+
+	if (hard_lp_ctr == 0)
+		dev_warn(rvu->dev, "CPT FLR hits hard loop counter\n");
+}
+
+int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot)
+{
+	int blkaddr;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, pcifunc);
+	if (blkaddr != BLKADDR_CPT0 && blkaddr != BLKADDR_CPT1)
+		return -EINVAL;
+
+	/* Enable BAR2 ALIAS for this pcifunc. */
+	reg = BIT_ULL(16) | pcifunc;
+	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, reg);
+
+	cpt_lf_disable_iqueue(rvu, blkaddr, slot);
+
+	/* Set group drop to help clear out hardware */
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG));
+	reg |= BIT_ULL(17);
+	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG), reg);
+
+	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, 0);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 0fb2aa909a23..79a6dcf0e3c0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -484,9 +484,17 @@
 #define CPT_AF_RAS_INT_ENA_W1S          (0x47030)
 #define CPT_AF_RAS_INT_ENA_W1C          (0x47038)
 
+#define AF_BAR2_ALIASX(a, b)            (0x9100000ull | (a) << 12 | (b))
+#define CPT_AF_BAR2_SEL                 0x9000000
+#define CPT_AF_BAR2_ALIASX(a, b)        AF_BAR2_ALIASX(a, b)
+
 #define CPT_AF_LF_CTL2_SHIFT 3
 #define CPT_AF_LF_SSO_PF_FUNC_SHIFT 32
 
+#define CPT_LF_CTL                      0x10
+#define CPT_LF_INPROG                   0x40
+#define CPT_LF_Q_GRP_PTR                0x120
+
 #define NPC_AF_BLK_RST                  (0x00040)
 
 /* NPC */
-- 
2.29.0

