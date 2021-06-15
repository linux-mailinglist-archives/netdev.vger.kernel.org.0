Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402433A7D5D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 13:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFOLis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 07:38:48 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31100 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229601AbhFOLil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 07:38:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15FBUAMr022094;
        Tue, 15 Jun 2021 04:34:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=AARNG0cJ6UKicugwRWgtHhLx2DjzofSqA633lIT1tYc=;
 b=T+R777xm9DzWL17lBoxFMcV/bU2gOfv+3LMzGBKZA+a+Zv31ZyqVPOYBr+86VFU160OA
 xAj3l6SMif1usamHDH4b4TVsdACLwBh2W/pgtwZF/UBNjdWiHsHPMYxNABG0M0m5R2WH
 J6HI5RKGIQej3P5SMoIvwThZWYUqEVF4ZSXlwl5XQPQ7rbiDpSuTW7aLIabDjxP/yY8M
 hDO6SQf613WTqgtCWW2y0CrTsde6SfWXTH0uZ+XxDaHV9NKDM1ObnrDlpiP1Y5DhddWo
 m+1JhGSnBpTnm33tTR58mgknc5+EYNDLDAIkq5Y0Vl5m1PjzHI9PFOanlq/koETA51vG lg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 396m0uj1wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 15 Jun 2021 04:34:48 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Jun
 2021 04:34:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Jun 2021 04:34:47 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id C57173F70B3;
        Tue, 15 Jun 2021 04:34:44 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 2/5] octeontx2-af: cn10k: Debugfs support for bandwidth profiles
Date:   Tue, 15 Jun 2021 17:04:28 +0530
Message-ID: <1623756871-12524-3-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623756871-12524-1-git-send-email-sbhatta@marvell.com>
References: <1623756871-12524-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: xBd7nokstG9TkAZxmZEnDKqfpvPdV05_
X-Proofpoint-ORIG-GUID: xBd7nokstG9TkAZxmZEnDKqfpvPdV05_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-15_04:2021-06-14,2021-06-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Added support for dumping current resource status of bandwidth
profiles and contexts of allocated profiles via debugfs.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   8 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   5 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 163 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   8 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |   7 +
 5 files changed, 187 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index f11a02d..0b09294 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -184,6 +184,14 @@ int rvu_rsrc_free_count(struct rsrc_bmap *rsrc)
 	return (rsrc->max - used);
 }
 
+bool is_rsrc_free(struct rsrc_bmap *rsrc, int id)
+{
+	if (!rsrc->bmap)
+		return false;
+
+	return !test_bit(id, rsrc->bmap);
+}
+
 int rvu_alloc_bitmap(struct rsrc_bmap *rsrc)
 {
 	rsrc->bmap = kcalloc(BITS_TO_LONGS(rsrc->max),
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 4d2a5ca..9e5d9ba6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -596,6 +596,7 @@ static inline bool is_rvu_fwdata_valid(struct rvu *rvu)
 int rvu_alloc_bitmap(struct rsrc_bmap *rsrc);
 int rvu_alloc_rsrc(struct rsrc_bmap *rsrc);
 void rvu_free_rsrc(struct rsrc_bmap *rsrc, int id);
+bool is_rsrc_free(struct rsrc_bmap *rsrc, int id);
 int rvu_rsrc_free_count(struct rsrc_bmap *rsrc);
 int rvu_alloc_rsrc_contig(struct rsrc_bmap *rsrc, int nrsrc);
 bool rvu_rsrc_check_contig(struct rsrc_bmap *rsrc, int nrsrc);
@@ -683,6 +684,10 @@ int nix_get_struct_ptrs(struct rvu *rvu, u16 pcifunc,
 			struct nix_hw **nix_hw, int *blkaddr);
 int rvu_nix_setup_ratelimit_aggr(struct rvu *rvu, u16 pcifunc,
 				 u16 rq_idx, u16 match_id);
+int nix_aq_context_read(struct rvu *rvu, struct nix_hw *nix_hw,
+			struct nix_cn10k_aq_enq_req *aq_req,
+			struct nix_cn10k_aq_enq_rsp *aq_rsp,
+			u16 pcifunc, u8 ctype, u32 qidx);
 
 /* NPC APIs */
 int rvu_npc_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 7103f82..3cc3c6f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1632,6 +1632,165 @@ static int rvu_dbg_nix_qsize_display(struct seq_file *filp, void *unused)
 
 RVU_DEBUG_SEQ_FOPS(nix_qsize, nix_qsize_display, nix_qsize_write);
 
+static void print_band_prof_ctx(struct seq_file *m,
+				struct nix_bandprof_s *prof)
+{
+	char *str;
+
+	switch (prof->pc_mode) {
+	case NIX_RX_PC_MODE_VLAN:
+		str = "VLAN";
+		break;
+	case NIX_RX_PC_MODE_DSCP:
+		str = "DSCP";
+		break;
+	case NIX_RX_PC_MODE_GEN:
+		str = "Generic";
+		break;
+	case NIX_RX_PC_MODE_RSVD:
+		str = "Reserved";
+		break;
+	}
+	seq_printf(m, "W0: pc_mode\t\t%s\n", str);
+	str = (prof->icolor == 3) ? "Color blind" :
+		(prof->icolor == 0) ? "Green" :
+		(prof->icolor == 1) ? "Yellow" : "Red";
+	seq_printf(m, "W0: icolor\t\t%s\n", str);
+	seq_printf(m, "W0: tnl_ena\t\t%d\n", prof->tnl_ena);
+	seq_printf(m, "W0: peir_exponent\t%d\n", prof->peir_exponent);
+	seq_printf(m, "W0: pebs_exponent\t%d\n", prof->pebs_exponent);
+	seq_printf(m, "W0: cir_exponent\t%d\n", prof->cir_exponent);
+	seq_printf(m, "W0: cbs_exponent\t%d\n", prof->cbs_exponent);
+	seq_printf(m, "W0: peir_mantissa\t%d\n", prof->peir_mantissa);
+	seq_printf(m, "W0: pebs_mantissa\t%d\n", prof->pebs_mantissa);
+	seq_printf(m, "W0: cir_mantissa\t%d\n", prof->cir_mantissa);
+
+	seq_printf(m, "W1: cbs_mantissa\t%d\n", prof->cbs_mantissa);
+	str = (prof->lmode == 0) ? "byte" : "packet";
+	seq_printf(m, "W1: lmode\t\t%s\n", str);
+	seq_printf(m, "W1: l_select\t\t%d\n", prof->l_sellect);
+	seq_printf(m, "W1: rdiv\t\t%d\n", prof->rdiv);
+	seq_printf(m, "W1: adjust_exponent\t%d\n", prof->adjust_exponent);
+	seq_printf(m, "W1: adjust_mantissa\t%d\n", prof->adjust_mantissa);
+	str = (prof->gc_action == 0) ? "PASS" :
+		(prof->gc_action == 1) ? "DROP" : "RED";
+	seq_printf(m, "W1: gc_action\t\t%s\n", str);
+	str = (prof->yc_action == 0) ? "PASS" :
+		(prof->yc_action == 1) ? "DROP" : "RED";
+	seq_printf(m, "W1: yc_action\t\t%s\n", str);
+	str = (prof->rc_action == 0) ? "PASS" :
+		(prof->rc_action == 1) ? "DROP" : "RED";
+	seq_printf(m, "W1: rc_action\t\t%s\n", str);
+	seq_printf(m, "W1: meter_algo\t\t%d\n", prof->meter_algo);
+	seq_printf(m, "W1: band_prof_id\t%d\n", prof->band_prof_id);
+	seq_printf(m, "W1: hl_en\t\t%d\n", prof->hl_en);
+
+	seq_printf(m, "W2: ts\t\t\t%lld\n", (u64)prof->ts);
+	seq_printf(m, "W3: pe_accum\t\t%d\n", prof->pe_accum);
+	seq_printf(m, "W3: c_accum\t\t%d\n", prof->c_accum);
+	seq_printf(m, "W4: green_pkt_pass\t%lld\n",
+		   (u64)prof->green_pkt_pass);
+	seq_printf(m, "W5: yellow_pkt_pass\t%lld\n",
+		   (u64)prof->yellow_pkt_pass);
+	seq_printf(m, "W6: red_pkt_pass\t%lld\n", (u64)prof->red_pkt_pass);
+	seq_printf(m, "W7: green_octs_pass\t%lld\n",
+		   (u64)prof->green_octs_pass);
+	seq_printf(m, "W8: yellow_octs_pass\t%lld\n",
+		   (u64)prof->yellow_octs_pass);
+	seq_printf(m, "W9: red_octs_pass\t%lld\n", (u64)prof->red_octs_pass);
+	seq_printf(m, "W10: green_pkt_drop\t%lld\n",
+		   (u64)prof->green_pkt_drop);
+	seq_printf(m, "W11: yellow_pkt_drop\t%lld\n",
+		   (u64)prof->yellow_pkt_drop);
+	seq_printf(m, "W12: red_pkt_drop\t%lld\n", (u64)prof->red_pkt_drop);
+	seq_printf(m, "W13: green_octs_drop\t%lld\n",
+		   (u64)prof->green_octs_drop);
+	seq_printf(m, "W14: yellow_octs_drop\t%lld\n",
+		   (u64)prof->yellow_octs_drop);
+	seq_printf(m, "W15: red_octs_drop\t%lld\n", (u64)prof->red_octs_drop);
+	seq_puts(m, "==============================\n");
+}
+
+static int rvu_dbg_nix_band_prof_ctx_display(struct seq_file *m, void *unused)
+{
+	struct nix_hw *nix_hw = m->private;
+	struct nix_cn10k_aq_enq_req aq_req;
+	struct nix_cn10k_aq_enq_rsp aq_rsp;
+	struct rvu *rvu = nix_hw->rvu;
+	struct nix_ipolicer *ipolicer;
+	int layer, prof_idx, idx, rc;
+	u16 pcifunc;
+	char *str;
+
+	for (layer = 0; layer < BAND_PROF_NUM_LAYERS; layer++) {
+		if (layer == BAND_PROF_INVAL_LAYER)
+			continue;
+		str = (layer == BAND_PROF_LEAF_LAYER) ? "Leaf" :
+			(layer == BAND_PROF_MID_LAYER) ? "Mid" : "Top";
+
+		seq_printf(m, "\n%s bandwidth profiles\n", str);
+		seq_puts(m, "=======================\n");
+
+		ipolicer = &nix_hw->ipolicer[layer];
+
+		for (idx = 0; idx < ipolicer->band_prof.max; idx++) {
+			if (is_rsrc_free(&ipolicer->band_prof, idx))
+				continue;
+
+			prof_idx = (idx & 0x3FFF) | (layer << 14);
+			rc = nix_aq_context_read(rvu, nix_hw, &aq_req, &aq_rsp,
+						 0x00, NIX_AQ_CTYPE_BANDPROF,
+						 prof_idx);
+			if (rc) {
+				dev_err(rvu->dev,
+					"%s: Failed to fetch context of %s profile %d, err %d\n",
+					__func__, str, idx, rc);
+				return 0;
+			}
+			seq_printf(m, "\n%s bandwidth profile:: %d\n", str, idx);
+			pcifunc = ipolicer->pfvf_map[idx];
+			if (!(pcifunc & RVU_PFVF_FUNC_MASK))
+				seq_printf(m, "Allocated to :: PF %d\n",
+					   rvu_get_pf(pcifunc));
+			else
+				seq_printf(m, "Allocated to :: PF %d VF %d\n",
+					   rvu_get_pf(pcifunc),
+					   (pcifunc & RVU_PFVF_FUNC_MASK) - 1);
+			print_band_prof_ctx(m, &aq_rsp.prof);
+		}
+	}
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(nix_band_prof_ctx, nix_band_prof_ctx_display, NULL);
+
+static int rvu_dbg_nix_band_prof_rsrc_display(struct seq_file *m, void *unused)
+{
+	struct nix_hw *nix_hw = m->private;
+	struct nix_ipolicer *ipolicer;
+	int layer;
+	char *str;
+
+	seq_puts(m, "\nBandwidth profile resource free count\n");
+	seq_puts(m, "=====================================\n");
+	for (layer = 0; layer < BAND_PROF_NUM_LAYERS; layer++) {
+		if (layer == BAND_PROF_INVAL_LAYER)
+			continue;
+		str = (layer == BAND_PROF_LEAF_LAYER) ? "Leaf" :
+			(layer == BAND_PROF_MID_LAYER) ? "Mid " : "Top ";
+
+		ipolicer = &nix_hw->ipolicer[layer];
+		seq_printf(m, "%s :: Max: %4d  Free: %4d\n", str,
+			   ipolicer->band_prof.max,
+			   rvu_rsrc_free_count(&ipolicer->band_prof));
+	}
+	seq_puts(m, "=====================================\n");
+
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(nix_band_prof_rsrc, nix_band_prof_rsrc_display, NULL);
+
 static void rvu_dbg_nix_init(struct rvu *rvu, int blkaddr)
 {
 	struct nix_hw *nix_hw;
@@ -1664,6 +1823,10 @@ static void rvu_dbg_nix_init(struct rvu *rvu, int blkaddr)
 			    &rvu_dbg_nix_ndc_rx_hits_miss_fops);
 	debugfs_create_file("qsize", 0600, rvu->rvu_dbg.nix, rvu,
 			    &rvu_dbg_nix_qsize_fops);
+	debugfs_create_file("ingress_policer_ctx", 0600, rvu->rvu_dbg.nix, nix_hw,
+			    &rvu_dbg_nix_band_prof_ctx_fops);
+	debugfs_create_file("ingress_policer_rsrc", 0600, rvu->rvu_dbg.nix, nix_hw,
+			    &rvu_dbg_nix_band_prof_rsrc_fops);
 }
 
 static void rvu_dbg_npa_init(struct rvu *rvu)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index ebd73a8..d6f8210 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4365,10 +4365,10 @@ int rvu_mbox_handler_nix_bandprof_free(struct rvu *rvu,
 	return 0;
 }
 
-static int nix_aq_context_read(struct rvu *rvu, struct nix_hw *nix_hw,
-			       struct nix_cn10k_aq_enq_req *aq_req,
-			       struct nix_cn10k_aq_enq_rsp *aq_rsp,
-			       u16 pcifunc, u8 ctype, u32 qidx)
+int nix_aq_context_read(struct rvu *rvu, struct nix_hw *nix_hw,
+			struct nix_cn10k_aq_enq_req *aq_req,
+			struct nix_cn10k_aq_enq_rsp *aq_rsp,
+			u16 pcifunc, u8 ctype, u32 qidx)
 {
 	memset(aq_req, 0, sizeof(struct nix_cn10k_aq_enq_req));
 	aq_req->hdr.pcifunc = pcifunc;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 8fb002d..14aa8e3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -679,6 +679,13 @@ enum NIX_RX_BAND_PROF_ACTIONRESULT_E {
 	NIX_RX_BAND_PROF_ACTIONRESULT_RED = 0x2,
 };
 
+enum nix_band_prof_pc_mode {
+	NIX_RX_PC_MODE_VLAN = 0,
+	NIX_RX_PC_MODE_DSCP = 1,
+	NIX_RX_PC_MODE_GEN = 2,
+	NIX_RX_PC_MODE_RSVD = 3,
+};
+
 /* NIX ingress policer bandwidth profile structure */
 struct nix_bandprof_s {
 	uint64_t pc_mode                     :  2; /* W0 */
-- 
2.7.4

