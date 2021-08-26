Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE9C3F878F
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 14:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241232AbhHZMel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 08:34:41 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64066 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233929AbhHZMek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 08:34:40 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17QAHJ5i005584;
        Thu, 26 Aug 2021 05:33:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=uf+RaaX0dIczhny93UDheiCjRXWnKZF0msWwVcd/mLc=;
 b=eD7DKmesThEqbMJEEeRfSaECMZDGinh207TIDe1daukn4jJF161KdADl2iyyL92gq25Z
 vurm6nQjat0w91azm0zGqSYe3wSpO9d8ffgagVsNx4RkIWrGEfUZ9Ri00dOU5uf4okmd
 p3gvuplCob8+PIZoh8wp5CtjTNeqXhjuH32SLvix3L+AiwfflSaoheKOH0q0hG7Fpt1T
 dvCgXwfoCDRocghizVSoGHqyI6zOWFnx4K4Tt4r+LpSMmw27ayReBp+BrItU0iHFSwbC
 pa3e0LF1Gosn+LrE/2yWENdAGaIZVkTPUFZU6JdZnobYl/aaymtf3Efy0M2TTWLMkkXn NA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ap92mrfab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 26 Aug 2021 05:33:48 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 26 Aug
 2021 05:33:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 26 Aug 2021 05:33:46 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 8E9D13F7057;
        Thu, 26 Aug 2021 05:33:42 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <hkalra@marvell.com>
Subject: [net-next PATCH] octeontx2-af: cn10K: support for sched lmtst and other features
Date:   Thu, 26 Aug 2021 18:03:40 +0530
Message-ID: <20210826123340.14507-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: sZ8GxKDpwu4xzLFYkKRKzmBu3yzzJiX1
X-Proofpoint-GUID: sZ8GxKDpwu4xzLFYkKRKzmBu3yzzJiX1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-26_03,2021-08-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harman Kalra <hkalra@marvell.com>

Enhancing the mailbox scope to support important configurations
like enabling scheduled LMTST, disable LMTLINE prefetch, disable
early completion for ordered LMTST, as per request from the
application. On FLR these configurations will be reset to default.
This patch also adds the 95XXO silicon version to octeontx2 silicon
list.

Signed-off-by: Harman Kalra <hkalra@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  6 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  8 +-
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c | 90 ++++++++++++++++---
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  3 +
 4 files changed, 91 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index ef3c41cf3413..3720cf48837b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -273,7 +273,7 @@ M(NIX_BP_ENABLE,	0x8016, nix_bp_enable, nix_bp_cfg_req,	\
 				nix_bp_cfg_rsp)	\
 M(NIX_BP_DISABLE,	0x8017, nix_bp_disable, nix_bp_cfg_req, msg_rsp) \
 M(NIX_GET_MAC_ADDR, 0x8018, nix_get_mac_addr, msg_req, nix_get_mac_addr_rsp) \
-M(NIX_CN10K_AQ_ENQ,	0x8019, nix_cn10k_aq_enq, nix_cn10k_aq_enq_req, \
+M(NIX_CN10K_AQ_ENQ,	0x801b, nix_cn10k_aq_enq, nix_cn10k_aq_enq_req, \
 				nix_cn10k_aq_enq_rsp)			\
 M(NIX_GET_HW_INFO,	0x801c, nix_get_hw_info, msg_req, nix_hw_info)	\
 M(NIX_BANDPROF_ALLOC,	0x801d, nix_bandprof_alloc, nix_bandprof_alloc_req, \
@@ -1383,6 +1383,10 @@ struct set_vf_perm  {
 
 struct lmtst_tbl_setup_req {
 	struct mbox_msghdr hdr;
+	u64 dis_sched_early_comp :1;
+	u64 sch_ena		 :1;
+	u64 dis_line_pref	 :1;
+	u64 ssow_pf_func	 :13;
 	u16 base_pcifunc;
 	u8  use_local_lmt_region;
 	u64 lmt_iova;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index a85d7eb1ef77..31c20c917a0b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -245,6 +245,7 @@ struct rvu_pfvf {
 	u8	nix_tx_intf; /* NIX0_TX/NIX1_TX interface to NPC */
 	u8	lbkid;	     /* NIX0/1 lbk link ID */
 	u64     lmt_base_addr; /* Preseving the pcifunc's lmtst base addr*/
+	u64     lmt_map_ent_w1; /* Preseving the word1 of lmtst map table entry*/
 	unsigned long flags;
 	struct  sdp_node_info *sdp_info;
 };
@@ -556,9 +557,10 @@ static inline bool is_rvu_95xx_A0(struct rvu *rvu)
  */
 #define PCI_REVISION_ID_96XX		0x00
 #define PCI_REVISION_ID_95XX		0x10
-#define PCI_REVISION_ID_LOKI		0x20
+#define PCI_REVISION_ID_95XXN		0x20
 #define PCI_REVISION_ID_98XX		0x30
 #define PCI_REVISION_ID_95XXMM		0x40
+#define PCI_REVISION_ID_95XXO		0xE0
 
 static inline bool is_rvu_otx2(struct rvu *rvu)
 {
@@ -567,8 +569,8 @@ static inline bool is_rvu_otx2(struct rvu *rvu)
 	u8 midr = pdev->revision & 0xF0;
 
 	return (midr == PCI_REVISION_ID_96XX || midr == PCI_REVISION_ID_95XX ||
-		midr == PCI_REVISION_ID_LOKI || midr == PCI_REVISION_ID_98XX ||
-		midr == PCI_REVISION_ID_95XXMM);
+		midr == PCI_REVISION_ID_95XXN || midr == PCI_REVISION_ID_98XX ||
+		midr == PCI_REVISION_ID_95XXMM || midr == PCI_REVISION_ID_95XXO);
 }
 
 static inline u16 rvu_nix_chan_cgx(struct rvu *rvu, u8 cgxid,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index dbe9149a215e..87395927a489 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -49,6 +49,7 @@ static int lmtst_map_table_ops(struct rvu *rvu, u32 index, u64 *val,
 	return 0;
 }
 
+#define LMT_MAP_TBL_W1_OFF  8
 static u32 rvu_get_lmtst_tbl_index(struct rvu *rvu, u16 pcifunc)
 {
 	return ((rvu_get_pf(pcifunc) * rvu->hw->total_vfs) +
@@ -131,9 +132,11 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu,
 				     struct lmtst_tbl_setup_req *req,
 				     struct msg_rsp *rsp)
 {
-	u64 lmt_addr, val;
-	u32 pri_tbl_idx;
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
+	u32 pri_tbl_idx, tbl_idx;
+	u64 lmt_addr;
 	int err = 0;
+	u64 val;
 
 	/* Check if PF_FUNC wants to use it's own local memory as LMTLINE
 	 * region, if so, convert that IOVA to physical address and
@@ -170,7 +173,7 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu,
 			dev_err(rvu->dev,
 				"Failed to read LMT map table: index 0x%x err %d\n",
 				pri_tbl_idx, err);
-			return err;
+			goto error;
 		}
 
 		/* Update the base lmt addr of secondary with primary's base
@@ -181,7 +184,53 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu,
 			return err;
 	}
 
-	return 0;
+	/* This mailbox can also be used to update word1 of APR_LMT_MAP_ENTRY_S
+	 * like enabling scheduled LMTST, disable LMTLINE prefetch, disable
+	 * early completion for ordered LMTST.
+	 */
+	if (req->sch_ena || req->dis_sched_early_comp || req->dis_line_pref) {
+		tbl_idx = rvu_get_lmtst_tbl_index(rvu, req->hdr.pcifunc);
+		err = lmtst_map_table_ops(rvu, tbl_idx + LMT_MAP_TBL_W1_OFF,
+					  &val, LMT_TBL_OP_READ);
+		if (err) {
+			dev_err(rvu->dev,
+				"Failed to read LMT map table: index 0x%x err %d\n",
+				tbl_idx + LMT_MAP_TBL_W1_OFF, err);
+			goto error;
+		}
+
+		/* Storing lmt map table entry word1 default value as this needs
+		 * to be reverted in FLR. Also making sure this default value
+		 * doesn't get overwritten on multiple calls to this mailbox.
+		 */
+		if (!pfvf->lmt_map_ent_w1)
+			pfvf->lmt_map_ent_w1 = val;
+
+		/* Disable early completion for Ordered LMTSTs. */
+		if (req->dis_sched_early_comp)
+			val |= (req->dis_sched_early_comp <<
+				APR_LMT_MAP_ENT_DIS_SCH_CMP_SHIFT);
+		/* Enable scheduled LMTST */
+		if (req->sch_ena)
+			val |= (req->sch_ena << APR_LMT_MAP_ENT_SCH_ENA_SHIFT) |
+				req->ssow_pf_func;
+		/* Disables LMTLINE prefetch before receiving store data. */
+		if (req->dis_line_pref)
+			val |= (req->dis_line_pref <<
+				APR_LMT_MAP_ENT_DIS_LINE_PREF_SHIFT);
+
+		err = lmtst_map_table_ops(rvu, tbl_idx + LMT_MAP_TBL_W1_OFF,
+					  &val, LMT_TBL_OP_WRITE);
+		if (err) {
+			dev_err(rvu->dev,
+				"Failed to update LMT map table: index 0x%x err %d\n",
+				tbl_idx + LMT_MAP_TBL_W1_OFF, err);
+			goto error;
+		}
+	}
+
+error:
+	return err;
 }
 
 /* Resetting the lmtst map table to original base addresses */
@@ -194,19 +243,36 @@ void rvu_reset_lmt_map_tbl(struct rvu *rvu, u16 pcifunc)
 	if (is_rvu_otx2(rvu))
 		return;
 
-	if (pfvf->lmt_base_addr) {
+	if (pfvf->lmt_base_addr || pfvf->lmt_map_ent_w1) {
 		/* This corresponds to lmt map table index */
 		tbl_idx = rvu_get_lmtst_tbl_index(rvu, pcifunc);
 		/* Reverting back original lmt base addr for respective
 		 * pcifunc.
 		 */
-		err = lmtst_map_table_ops(rvu, tbl_idx, &pfvf->lmt_base_addr,
-					  LMT_TBL_OP_WRITE);
-		if (err)
-			dev_err(rvu->dev,
-				"Failed to update LMT map table: index 0x%x err %d\n",
-				tbl_idx, err);
-		pfvf->lmt_base_addr = 0;
+		if (pfvf->lmt_base_addr) {
+			err = lmtst_map_table_ops(rvu, tbl_idx,
+						  &pfvf->lmt_base_addr,
+						  LMT_TBL_OP_WRITE);
+			if (err)
+				dev_err(rvu->dev,
+					"Failed to update LMT map table: index 0x%x err %d\n",
+					tbl_idx, err);
+			pfvf->lmt_base_addr = 0;
+		}
+		/* Reverting back to orginal word1 val of lmtst map table entry
+		 * which underwent changes.
+		 */
+		if (pfvf->lmt_map_ent_w1) {
+			err = lmtst_map_table_ops(rvu,
+						  tbl_idx + LMT_MAP_TBL_W1_OFF,
+						  &pfvf->lmt_map_ent_w1,
+						  LMT_TBL_OP_WRITE);
+			if (err)
+				dev_err(rvu->dev,
+					"Failed to update LMT map table: index 0x%x err %d\n",
+					tbl_idx + LMT_MAP_TBL_W1_OFF, err);
+			pfvf->lmt_map_ent_w1 = 0;
+		}
 	}
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 4600c31b336b..a40aeaec423c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -704,5 +704,8 @@
 #define	APR_AF_LMT_CFG			(0x000ull)
 #define	APR_AF_LMT_MAP_BASE		(0x008ull)
 #define	APR_AF_LMT_CTL			(0x010ull)
+#define APR_LMT_MAP_ENT_DIS_SCH_CMP_SHIFT	23
+#define APR_LMT_MAP_ENT_SCH_ENA_SHIFT		22
+#define APR_LMT_MAP_ENT_DIS_LINE_PREF_SHIFT	21
 
 #endif /* RVU_REG_H */
-- 
2.17.1

