Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4850E3EE5C7
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbhHQEpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:45:50 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55312 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233999AbhHQEpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 00:45:45 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2ldw6006753;
        Mon, 16 Aug 2021 21:45:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=rT+0dxwtle1hKenwjtqlVn68HcH98cRa9wmt2c0QBrk=;
 b=W5a/IrpM9uZ6S1ThlJhOfm3yWnrXRgkrO/TvTvG9XrSKiMvU0aAFp9/lri3yOurba3/t
 x6N5+N80ykn4jBSAeUpmfTOwE8K0UO3AJjdJr6BoGBfva3PtXRmWYlUEpEIvhnLSXJJq
 36tCu9gnpTw0eobWxRMJ+xzHDw84ZPhFSLB0Rx/+gz+ywH4U9aUiq1evoaJ10w2ZNiCw
 6aKx9qKFBS+4NBT+m5LyfvI0i1E6SmSj0ujgNKw09JNQMRGUacuabn33zpmQMLVBizSA
 Pu/sK6yvg1habc0QFXQ7L2ewePqx3hf3xCMhRi2Q87HuVMQYUtg8SNnCFPkE1P+OsA8H tw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0ra4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 21:45:12 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 21:45:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 21:45:10 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 04E723F70B5;
        Mon, 16 Aug 2021 21:45:02 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        "Naveen Mamindlapalli" <naveenm@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 02/11] octeontx2-af: add proper return codes for AF mailbox handlers
Date:   Tue, 17 Aug 2021 10:14:44 +0530
Message-ID: <1629175493-4895-3-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
References: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: HgFjfWYgQ1RlWkOp2qaWjQ72f8s3gCyx
X-Proofpoint-ORIG-GUID: HgFjfWYgQ1RlWkOp2qaWjQ72f8s3gCyx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Naveen Mamindlapalli <naveenm@marvell.com>

Add appropriate error codes to be used when returning from AF
mailbox handlers due to some error condition.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  9 +++++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 12 +++---
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 45 +++++++++++++++-------
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |  2 +-
 4 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 3ad10a4..add4a39 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1433,4 +1433,13 @@ struct cpt_rxc_time_cfg_req {
 	u16 active_limit;
 };
 
+/* CGX mailbox error codes
+ * Range 1101 - 1200.
+ */
+enum cgx_af_status {
+	LMAC_AF_ERR_INVALID_PARAM	= -1101,
+	LMAC_AF_ERR_PF_NOT_MAPPED	= -1102,
+	LMAC_AF_ERR_PERM_DENIED		= -1103,
+};
+
 #endif /* MBOX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index fe99ac4..d34e595 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -448,7 +448,7 @@ int rvu_cgx_config_rxtx(struct rvu *rvu, u16 pcifunc, bool start)
 	u8 cgx_id, lmac_id;
 
 	if (!is_cgx_config_permitted(rvu, pcifunc))
-		return -EPERM;
+		return LMAC_AF_ERR_PERM_DENIED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
@@ -507,7 +507,7 @@ static int rvu_lmac_get_stats(struct rvu *rvu, struct msg_req *req,
 	void *cgxd;
 
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
-		return -ENODEV;
+		return LMAC_AF_ERR_PERM_DENIED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_idx, &lmac);
 	cgxd = rvu_cgx_pdata(cgx_idx, rvu);
@@ -561,7 +561,7 @@ int rvu_mbox_handler_cgx_fec_stats(struct rvu *rvu,
 	void *cgxd;
 
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
-		return -EPERM;
+		return LMAC_AF_ERR_PERM_DENIED;
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_idx, &lmac);
 
 	cgxd = rvu_cgx_pdata(cgx_idx, rvu);
@@ -888,7 +888,7 @@ int rvu_mbox_handler_cgx_get_phy_fec_stats(struct rvu *rvu, struct msg_req *req,
 	u8 cgx_id, lmac_id;
 
 	if (!is_pf_cgxmapped(rvu, pf))
-		return -EPERM;
+		return LMAC_AF_ERR_PF_NOT_MAPPED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	return cgx_get_phy_fec_stats(rvu_cgx_pdata(cgx_id, rvu), lmac_id);
@@ -1046,7 +1046,7 @@ int rvu_mbox_handler_cgx_mac_addr_reset(struct rvu *rvu, struct msg_req *req,
 	u8 cgx_id, lmac_id;
 
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
-		return -EPERM;
+		return LMAC_AF_ERR_PERM_DENIED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	return cgx_lmac_addr_reset(cgx_id, lmac_id);
@@ -1060,7 +1060,7 @@ int rvu_mbox_handler_cgx_mac_addr_update(struct rvu *rvu,
 	u8 cgx_id, lmac_id;
 
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
-		return -EPERM;
+		return LMAC_AF_ERR_PERM_DENIED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	return cgx_lmac_addr_update(cgx_id, lmac_id, req->mac_addr, req->index);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 53db8eb..22039d9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -984,7 +984,7 @@ static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 
 	nix_hw =  get_nix_hw(rvu->hw, blkaddr);
 	if (!nix_hw)
-		return -EINVAL;
+		return NIX_AF_ERR_INVALID_NIXBLK;
 
 	return rvu_nix_blk_aq_enq_inst(rvu, nix_hw, req, rsp);
 }
@@ -1405,7 +1405,7 @@ int rvu_mbox_handler_nix_mark_format_cfg(struct rvu *rvu,
 
 	nix_hw = get_nix_hw(rvu->hw, blkaddr);
 	if (!nix_hw)
-		return -EINVAL;
+		return NIX_AF_ERR_INVALID_NIXBLK;
 
 	cfg = (((u32)req->offset & 0x7) << 16) |
 	      (((u32)req->y_mask & 0xF) << 12) |
@@ -1673,7 +1673,7 @@ int rvu_mbox_handler_nix_txsch_alloc(struct rvu *rvu,
 
 	nix_hw = get_nix_hw(rvu->hw, blkaddr);
 	if (!nix_hw)
-		return -EINVAL;
+		return NIX_AF_ERR_INVALID_NIXBLK;
 
 	mutex_lock(&rvu->rsrc_lock);
 
@@ -1795,7 +1795,7 @@ static int nix_txschq_free(struct rvu *rvu, u16 pcifunc)
 
 	nix_hw = get_nix_hw(rvu->hw, blkaddr);
 	if (!nix_hw)
-		return -EINVAL;
+		return NIX_AF_ERR_INVALID_NIXBLK;
 
 	nixlf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
 	if (nixlf < 0)
@@ -1866,7 +1866,7 @@ static int nix_txschq_free_one(struct rvu *rvu,
 
 	nix_hw = get_nix_hw(rvu->hw, blkaddr);
 	if (!nix_hw)
-		return -EINVAL;
+		return NIX_AF_ERR_INVALID_NIXBLK;
 
 	nixlf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
 	if (nixlf < 0)
@@ -2066,7 +2066,7 @@ int rvu_mbox_handler_nix_txschq_cfg(struct rvu *rvu,
 
 	nix_hw = get_nix_hw(rvu->hw, blkaddr);
 	if (!nix_hw)
-		return -EINVAL;
+		return NIX_AF_ERR_INVALID_NIXBLK;
 
 	txsch = &nix_hw->txsch[req->lvl];
 	pfvf_map = txsch->pfvf_map;
@@ -2164,8 +2164,12 @@ static int nix_tx_vtag_free(struct rvu *rvu, int blkaddr,
 			    u16 pcifunc, int index)
 {
 	struct nix_hw *nix_hw = get_nix_hw(rvu->hw, blkaddr);
-	struct nix_txvlan *vlan = &nix_hw->txvlan;
+	struct nix_txvlan *vlan;
+
+	if (!nix_hw)
+		return NIX_AF_ERR_INVALID_NIXBLK;
 
+	vlan = &nix_hw->txvlan;
 	if (vlan->entry2pfvf_map[index] != pcifunc)
 		return NIX_AF_ERR_PARAM;
 
@@ -2206,10 +2210,15 @@ static int nix_tx_vtag_alloc(struct rvu *rvu, int blkaddr,
 			     u64 vtag, u8 size)
 {
 	struct nix_hw *nix_hw = get_nix_hw(rvu->hw, blkaddr);
-	struct nix_txvlan *vlan = &nix_hw->txvlan;
+	struct nix_txvlan *vlan;
 	u64 regval;
 	int index;
 
+	if (!nix_hw)
+		return NIX_AF_ERR_INVALID_NIXBLK;
+
+	vlan = &nix_hw->txvlan;
+
 	mutex_lock(&vlan->rsrc_lock);
 
 	index = rvu_alloc_rsrc(&vlan->rsrc);
@@ -2234,12 +2243,16 @@ static int nix_tx_vtag_decfg(struct rvu *rvu, int blkaddr,
 			     struct nix_vtag_config *req)
 {
 	struct nix_hw *nix_hw = get_nix_hw(rvu->hw, blkaddr);
-	struct nix_txvlan *vlan = &nix_hw->txvlan;
 	u16 pcifunc = req->hdr.pcifunc;
 	int idx0 = req->tx.vtag0_idx;
 	int idx1 = req->tx.vtag1_idx;
+	struct nix_txvlan *vlan;
 	int err = 0;
 
+	if (!nix_hw)
+		return NIX_AF_ERR_INVALID_NIXBLK;
+
+	vlan = &nix_hw->txvlan;
 	if (req->tx.free_vtag0 && req->tx.free_vtag1)
 		if (vlan->entry2pfvf_map[idx0] != pcifunc ||
 		    vlan->entry2pfvf_map[idx1] != pcifunc)
@@ -2266,9 +2279,13 @@ static int nix_tx_vtag_cfg(struct rvu *rvu, int blkaddr,
 			   struct nix_vtag_config_rsp *rsp)
 {
 	struct nix_hw *nix_hw = get_nix_hw(rvu->hw, blkaddr);
-	struct nix_txvlan *vlan = &nix_hw->txvlan;
+	struct nix_txvlan *vlan;
 	u16 pcifunc = req->hdr.pcifunc;
 
+	if (!nix_hw)
+		return NIX_AF_ERR_INVALID_NIXBLK;
+
+	vlan = &nix_hw->txvlan;
 	if (req->tx.cfg_vtag0) {
 		rsp->vtag0_idx =
 			nix_tx_vtag_alloc(rvu, blkaddr,
@@ -3142,7 +3159,7 @@ static int reserve_flowkey_alg_idx(struct rvu *rvu, int blkaddr, u32 flow_cfg)
 
 	hw = get_nix_hw(rvu->hw, blkaddr);
 	if (!hw)
-		return -EINVAL;
+		return NIX_AF_ERR_INVALID_NIXBLK;
 
 	/* No room to add new flow hash algoritham */
 	if (hw->flowkey.in_use >= NIX_FLOW_KEY_ALG_MAX)
@@ -3182,7 +3199,7 @@ int rvu_mbox_handler_nix_rss_flowkey_cfg(struct rvu *rvu,
 
 	nix_hw = get_nix_hw(rvu->hw, blkaddr);
 	if (!nix_hw)
-		return -EINVAL;
+		return NIX_AF_ERR_INVALID_NIXBLK;
 
 	alg_idx = get_flowkey_alg_idx(nix_hw, req->flowkey_cfg);
 	/* Failed to get algo index from the exiting list, reserve new  */
@@ -3459,7 +3476,7 @@ int rvu_mbox_handler_nix_set_hw_frs(struct rvu *rvu, struct nix_frs_cfg *req,
 
 	nix_hw = get_nix_hw(rvu->hw, blkaddr);
 	if (!nix_hw)
-		return -EINVAL;
+		return NIX_AF_ERR_INVALID_NIXBLK;
 
 	if (is_afvf(pcifunc))
 		rvu_get_lbk_link_max_frs(rvu, &max_mtu);
@@ -4126,7 +4143,7 @@ int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,
 
 	nix_hw = get_nix_hw(rvu->hw, blkaddr);
 	if (!nix_hw)
-		return -EINVAL;
+		return NIX_AF_ERR_INVALID_NIXBLK;
 
 	/* Find existing matching LSO format, if any */
 	for (idx = 0; idx < nix_hw->lso.in_use; idx++) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index fd07562..5e77bfe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -1139,7 +1139,7 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0) {
 		dev_err(rvu->dev, "%s: NPC block not implemented\n", __func__);
-		return -ENODEV;
+		return NPC_MCAM_INVALID_REQ;
 	}
 
 	if (!is_npc_interface_valid(rvu, req->intf))
-- 
2.7.4

