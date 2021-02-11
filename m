Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12B0318339
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 02:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhBKBth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 20:49:37 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10240 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229870AbhBKBsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 20:48:10 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11B1kKqx023671;
        Wed, 10 Feb 2021 17:47:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Wo3zwsaIZKkzo1vsTZoWODzN9OLUxvKuGiUGo3GKseI=;
 b=Qvfw3synYGJuimdNUD1LM+LUCxaie5kCQEdj3xXqCWW6G1qFrPAcWtQ8s3V6Wb1XV0OB
 p+jcLykag34WHQfoM3QhnYkXzJLJs5yaba9+RLD1yiEidajBp+71OOBkPX9nNh2vX5XV
 qjHsvbD/JGxSJ8Xr6DyxqJIpj8d6ysrBLFYo+fTOLZzoNg+ty3PaSXc0e05SSZB/dIK0
 vA29Sx1LnXqRl58NFdpsWVsEkwa3FUHcviEpeZBd1lSad+ivWyFBdxdBaiVjDDdq9XXO
 ExRJCnwXRY62JtKUN/0IjU+XBpVLvmctlELT0ktJu9EoJEo9Rjp9RkaD7AxBhj401Iy8 /g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrnttc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 17:47:24 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 17:47:22 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Feb 2021 17:47:22 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id B18273F703F;
        Wed, 10 Feb 2021 17:47:18 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <jerinj@marvell.com>,
        <bbrezillon@kernel.org>, <arno@natisbad.org>,
        <schalla@marvell.com>, Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v5 04/14] octeontx2-af: cn10k: Update NIX and NPA context in debugfs
Date:   Thu, 11 Feb 2021 07:16:21 +0530
Message-ID: <20210211014631.9578-5-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210211014631.9578-1-gakula@marvell.com>
References: <20210211014631.9578-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_11:2021-02-10,2021-02-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On CN10K platform NPA and NIX context structure bit fields
had changed to support new features like bandwidth steering etc.
This patch dumps approprate context for CN10K platform.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../marvell/octeontx2/af/rvu_debugfs.c        | 177 +++++++++++++++++-
 1 file changed, 175 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 80e964330de3..02775d49cf0f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -449,6 +449,7 @@ RVU_DEBUG_SEQ_FOPS(npa_qsize, npa_qsize_display, npa_qsize_write);
 static void print_npa_aura_ctx(struct seq_file *m, struct npa_aq_enq_rsp *rsp)
 {
 	struct npa_aura_s *aura = &rsp->aura;
+	struct rvu *rvu = m->private;
 
 	seq_printf(m, "W0: Pool addr\t\t%llx\n", aura->pool_addr);
 
@@ -468,6 +469,9 @@ static void print_npa_aura_ctx(struct seq_file *m, struct npa_aq_enq_rsp *rsp)
 
 	seq_printf(m, "W3: limit\t\t%llu\nW3: bp\t\t\t%d\nW3: fc_ena\t\t%d\n",
 		   (u64)aura->limit, aura->bp, aura->fc_ena);
+
+	if (!is_rvu_otx2(rvu))
+		seq_printf(m, "W3: fc_be\t\t%d\n", aura->fc_be);
 	seq_printf(m, "W3: fc_up_crossing\t%d\nW3: fc_stype\t\t%d\n",
 		   aura->fc_up_crossing, aura->fc_stype);
 	seq_printf(m, "W3: fc_hyst_bits\t%d\n", aura->fc_hyst_bits);
@@ -485,12 +489,15 @@ static void print_npa_aura_ctx(struct seq_file *m, struct npa_aq_enq_rsp *rsp)
 	seq_printf(m, "W5: err_qint_idx \t%d\n", aura->err_qint_idx);
 
 	seq_printf(m, "W6: thresh\t\t%llu\n", (u64)aura->thresh);
+	if (!is_rvu_otx2(rvu))
+		seq_printf(m, "W6: fc_msh_dst\t\t%d\n", aura->fc_msh_dst);
 }
 
 /* Dumps given NPA Pool's context */
 static void print_npa_pool_ctx(struct seq_file *m, struct npa_aq_enq_rsp *rsp)
 {
 	struct npa_pool_s *pool = &rsp->pool;
+	struct rvu *rvu = m->private;
 
 	seq_printf(m, "W0: Stack base\t\t%llx\n", pool->stack_base);
 
@@ -512,6 +519,8 @@ static void print_npa_pool_ctx(struct seq_file *m, struct npa_aq_enq_rsp *rsp)
 		   pool->avg_con, pool->fc_ena, pool->fc_stype);
 	seq_printf(m, "W4: fc_hyst_bits\t%d\nW4: fc_up_crossing\t%d\n",
 		   pool->fc_hyst_bits, pool->fc_up_crossing);
+	if (!is_rvu_otx2(rvu))
+		seq_printf(m, "W4: fc_be\t\t%d\n", pool->fc_be);
 	seq_printf(m, "W4: update_time\t\t%d\n", pool->update_time);
 
 	seq_printf(m, "W5: fc_addr\t\t%llx\n", pool->fc_addr);
@@ -525,8 +534,10 @@ static void print_npa_pool_ctx(struct seq_file *m, struct npa_aq_enq_rsp *rsp)
 	seq_printf(m, "W8: thresh_int\t\t%d\n", pool->thresh_int);
 	seq_printf(m, "W8: thresh_int_ena\t%d\nW8: thresh_up\t\t%d\n",
 		   pool->thresh_int_ena, pool->thresh_up);
-	seq_printf(m, "W8: thresh_qint_idx\t%d\nW8: err_qint_idx\t\t%d\n",
+	seq_printf(m, "W8: thresh_qint_idx\t%d\nW8: err_qint_idx\t%d\n",
 		   pool->thresh_qint_idx, pool->err_qint_idx);
+	if (!is_rvu_otx2(rvu))
+		seq_printf(m, "W8: fc_msh_dst\t\t%d\n", pool->fc_msh_dst);
 }
 
 /* Reads aura/pool's ctx from admin queue */
@@ -910,11 +921,78 @@ static int rvu_dbg_nix_ndc_tx_hits_miss_display(struct seq_file *filp,
 
 RVU_DEBUG_SEQ_FOPS(nix_ndc_tx_hits_miss, nix_ndc_tx_hits_miss_display, NULL);
 
+static void print_nix_cn10k_sq_ctx(struct seq_file *m,
+				   struct nix_cn10k_sq_ctx_s *sq_ctx)
+{
+	seq_printf(m, "W0: ena \t\t\t%d\nW0: qint_idx \t\t\t%d\n",
+		   sq_ctx->ena, sq_ctx->qint_idx);
+	seq_printf(m, "W0: substream \t\t\t0x%03x\nW0: sdp_mcast \t\t\t%d\n",
+		   sq_ctx->substream, sq_ctx->sdp_mcast);
+	seq_printf(m, "W0: cq \t\t\t\t%d\nW0: sqe_way_mask \t\t%d\n\n",
+		   sq_ctx->cq, sq_ctx->sqe_way_mask);
+
+	seq_printf(m, "W1: smq \t\t\t%d\nW1: cq_ena \t\t\t%d\nW1: xoff\t\t\t%d\n",
+		   sq_ctx->smq, sq_ctx->cq_ena, sq_ctx->xoff);
+	seq_printf(m, "W1: sso_ena \t\t\t%d\nW1: smq_rr_weight\t\t%d\n",
+		   sq_ctx->sso_ena, sq_ctx->smq_rr_weight);
+	seq_printf(m, "W1: default_chan\t\t%d\nW1: sqb_count\t\t\t%d\n\n",
+		   sq_ctx->default_chan, sq_ctx->sqb_count);
+
+	seq_printf(m, "W2: smq_rr_count_lb \t\t%d\n", sq_ctx->smq_rr_count_lb);
+	seq_printf(m, "W2: smq_rr_count_ub \t\t%d\n", sq_ctx->smq_rr_count_ub);
+	seq_printf(m, "W2: sqb_aura \t\t\t%d\nW2: sq_int \t\t\t%d\n",
+		   sq_ctx->sqb_aura, sq_ctx->sq_int);
+	seq_printf(m, "W2: sq_int_ena \t\t\t%d\nW2: sqe_stype \t\t\t%d\n",
+		   sq_ctx->sq_int_ena, sq_ctx->sqe_stype);
+
+	seq_printf(m, "W3: max_sqe_size\t\t%d\nW3: cq_limit\t\t\t%d\n",
+		   sq_ctx->max_sqe_size, sq_ctx->cq_limit);
+	seq_printf(m, "W3: lmt_dis \t\t\t%d\nW3: mnq_dis \t\t\t%d\n",
+		   sq_ctx->mnq_dis, sq_ctx->lmt_dis);
+	seq_printf(m, "W3: smq_next_sq\t\t\t%d\nW3: smq_lso_segnum\t\t%d\n",
+		   sq_ctx->smq_next_sq, sq_ctx->smq_lso_segnum);
+	seq_printf(m, "W3: tail_offset \t\t%d\nW3: smenq_offset\t\t%d\n",
+		   sq_ctx->tail_offset, sq_ctx->smenq_offset);
+	seq_printf(m, "W3: head_offset\t\t\t%d\nW3: smenq_next_sqb_vld\t\t%d\n\n",
+		   sq_ctx->head_offset, sq_ctx->smenq_next_sqb_vld);
+
+	seq_printf(m, "W4: next_sqb \t\t\t%llx\n\n", sq_ctx->next_sqb);
+	seq_printf(m, "W5: tail_sqb \t\t\t%llx\n\n", sq_ctx->tail_sqb);
+	seq_printf(m, "W6: smenq_sqb \t\t\t%llx\n\n", sq_ctx->smenq_sqb);
+	seq_printf(m, "W7: smenq_next_sqb \t\t%llx\n\n",
+		   sq_ctx->smenq_next_sqb);
+
+	seq_printf(m, "W8: head_sqb\t\t\t%llx\n\n", sq_ctx->head_sqb);
+
+	seq_printf(m, "W9: vfi_lso_total\t\t%d\n", sq_ctx->vfi_lso_total);
+	seq_printf(m, "W9: vfi_lso_sizem1\t\t%d\nW9: vfi_lso_sb\t\t\t%d\n",
+		   sq_ctx->vfi_lso_sizem1, sq_ctx->vfi_lso_sb);
+	seq_printf(m, "W9: vfi_lso_mps\t\t\t%d\nW9: vfi_lso_vlan0_ins_ena\t%d\n",
+		   sq_ctx->vfi_lso_mps, sq_ctx->vfi_lso_vlan0_ins_ena);
+	seq_printf(m, "W9: vfi_lso_vlan1_ins_ena\t%d\nW9: vfi_lso_vld \t\t%d\n\n",
+		   sq_ctx->vfi_lso_vld, sq_ctx->vfi_lso_vlan1_ins_ena);
+
+	seq_printf(m, "W10: scm_lso_rem \t\t%llu\n\n",
+		   (u64)sq_ctx->scm_lso_rem);
+	seq_printf(m, "W11: octs \t\t\t%llu\n\n", (u64)sq_ctx->octs);
+	seq_printf(m, "W12: pkts \t\t\t%llu\n\n", (u64)sq_ctx->pkts);
+	seq_printf(m, "W14: dropped_octs \t\t%llu\n\n",
+		   (u64)sq_ctx->dropped_octs);
+	seq_printf(m, "W15: dropped_pkts \t\t%llu\n\n",
+		   (u64)sq_ctx->dropped_pkts);
+}
+
 /* Dumps given nix_sq's context */
 static void print_nix_sq_ctx(struct seq_file *m, struct nix_aq_enq_rsp *rsp)
 {
 	struct nix_sq_ctx_s *sq_ctx = &rsp->sq;
+	struct nix_hw *nix_hw = m->private;
+	struct rvu *rvu = nix_hw->rvu;
 
+	if (!is_rvu_otx2(rvu)) {
+		print_nix_cn10k_sq_ctx(m, (struct nix_cn10k_sq_ctx_s *)sq_ctx);
+		return;
+	}
 	seq_printf(m, "W0: sqe_way_mask \t\t%d\nW0: cq \t\t\t\t%d\n",
 		   sq_ctx->sqe_way_mask, sq_ctx->cq);
 	seq_printf(m, "W0: sdp_mcast \t\t\t%d\nW0: substream \t\t\t0x%03x\n",
@@ -974,10 +1052,94 @@ static void print_nix_sq_ctx(struct seq_file *m, struct nix_aq_enq_rsp *rsp)
 		   (u64)sq_ctx->dropped_pkts);
 }
 
+static void print_nix_cn10k_rq_ctx(struct seq_file *m,
+				   struct nix_cn10k_rq_ctx_s *rq_ctx)
+{
+	seq_printf(m, "W0: ena \t\t\t%d\nW0: sso_ena \t\t\t%d\n",
+		   rq_ctx->ena, rq_ctx->sso_ena);
+	seq_printf(m, "W0: ipsech_ena \t\t\t%d\nW0: ena_wqwd \t\t\t%d\n",
+		   rq_ctx->ipsech_ena, rq_ctx->ena_wqwd);
+	seq_printf(m, "W0: cq \t\t\t\t%d\nW0: lenerr_dis \t\t\t%d\n",
+		   rq_ctx->cq, rq_ctx->lenerr_dis);
+	seq_printf(m, "W0: csum_il4_dis \t\t%d\nW0: csum_ol4_dis \t\t%d\n",
+		   rq_ctx->csum_il4_dis, rq_ctx->csum_ol4_dis);
+	seq_printf(m, "W0: len_il4_dis \t\t%d\nW0: len_il3_dis \t\t%d\n",
+		   rq_ctx->len_il4_dis, rq_ctx->len_il3_dis);
+	seq_printf(m, "W0: len_ol4_dis \t\t%d\nW0: len_ol3_dis \t\t%d\n",
+		   rq_ctx->len_ol4_dis, rq_ctx->len_ol3_dis);
+	seq_printf(m, "W0: wqe_aura \t\t\t%d\n\n", rq_ctx->wqe_aura);
+
+	seq_printf(m, "W1: spb_aura \t\t\t%d\nW1: lpb_aura \t\t\t%d\n",
+		   rq_ctx->spb_aura, rq_ctx->lpb_aura);
+	seq_printf(m, "W1: spb_aura \t\t\t%d\n", rq_ctx->spb_aura);
+	seq_printf(m, "W1: sso_grp \t\t\t%d\nW1: sso_tt \t\t\t%d\n",
+		   rq_ctx->sso_grp, rq_ctx->sso_tt);
+	seq_printf(m, "W1: pb_caching \t\t\t%d\nW1: wqe_caching \t\t%d\n",
+		   rq_ctx->pb_caching, rq_ctx->wqe_caching);
+	seq_printf(m, "W1: xqe_drop_ena \t\t%d\nW1: spb_drop_ena \t\t%d\n",
+		   rq_ctx->xqe_drop_ena, rq_ctx->spb_drop_ena);
+	seq_printf(m, "W1: lpb_drop_ena \t\t%d\nW1: pb_stashing \t\t%d\n",
+		   rq_ctx->lpb_drop_ena, rq_ctx->pb_stashing);
+	seq_printf(m, "W1: ipsecd_drop_ena \t\t%d\nW1: chi_ena \t\t\t%d\n\n",
+		   rq_ctx->ipsecd_drop_ena, rq_ctx->chi_ena);
+
+	seq_printf(m, "W2: band_prof_id \t\t%d\n", rq_ctx->band_prof_id);
+	seq_printf(m, "W2: policer_ena \t\t%d\n", rq_ctx->policer_ena);
+	seq_printf(m, "W2: spb_sizem1 \t\t\t%d\n", rq_ctx->spb_sizem1);
+	seq_printf(m, "W2: wqe_skip \t\t\t%d\nW2: sqb_ena \t\t\t%d\n",
+		   rq_ctx->wqe_skip, rq_ctx->spb_ena);
+	seq_printf(m, "W2: lpb_size1 \t\t\t%d\nW2: first_skip \t\t\t%d\n",
+		   rq_ctx->lpb_sizem1, rq_ctx->first_skip);
+	seq_printf(m, "W2: later_skip\t\t\t%d\nW2: xqe_imm_size\t\t%d\n",
+		   rq_ctx->later_skip, rq_ctx->xqe_imm_size);
+	seq_printf(m, "W2: xqe_imm_copy \t\t%d\nW2: xqe_hdr_split \t\t%d\n\n",
+		   rq_ctx->xqe_imm_copy, rq_ctx->xqe_hdr_split);
+
+	seq_printf(m, "W3: xqe_drop \t\t\t%d\nW3: xqe_pass \t\t\t%d\n",
+		   rq_ctx->xqe_drop, rq_ctx->xqe_pass);
+	seq_printf(m, "W3: wqe_pool_drop \t\t%d\nW3: wqe_pool_pass \t\t%d\n",
+		   rq_ctx->wqe_pool_drop, rq_ctx->wqe_pool_pass);
+	seq_printf(m, "W3: spb_pool_drop \t\t%d\nW3: spb_pool_pass \t\t%d\n",
+		   rq_ctx->spb_pool_drop, rq_ctx->spb_pool_pass);
+	seq_printf(m, "W3: spb_aura_drop \t\t%d\nW3: spb_aura_pass \t\t%d\n\n",
+		   rq_ctx->spb_aura_pass, rq_ctx->spb_aura_drop);
+
+	seq_printf(m, "W4: lpb_aura_drop \t\t%d\nW3: lpb_aura_pass \t\t%d\n",
+		   rq_ctx->lpb_aura_pass, rq_ctx->lpb_aura_drop);
+	seq_printf(m, "W4: lpb_pool_drop \t\t%d\nW3: lpb_pool_pass \t\t%d\n",
+		   rq_ctx->lpb_pool_drop, rq_ctx->lpb_pool_pass);
+	seq_printf(m, "W4: rq_int \t\t\t%d\nW4: rq_int_ena\t\t\t%d\n",
+		   rq_ctx->rq_int, rq_ctx->rq_int_ena);
+	seq_printf(m, "W4: qint_idx \t\t\t%d\n\n", rq_ctx->qint_idx);
+
+	seq_printf(m, "W5: ltag \t\t\t%d\nW5: good_utag \t\t\t%d\n",
+		   rq_ctx->ltag, rq_ctx->good_utag);
+	seq_printf(m, "W5: bad_utag \t\t\t%d\nW5: flow_tagw \t\t\t%d\n",
+		   rq_ctx->bad_utag, rq_ctx->flow_tagw);
+	seq_printf(m, "W5: ipsec_vwqe \t\t\t%d\nW5: vwqe_ena \t\t\t%d\n",
+		   rq_ctx->ipsec_vwqe, rq_ctx->vwqe_ena);
+	seq_printf(m, "W5: vwqe_wait \t\t\t%d\nW5: max_vsize_exp\t\t%d\n",
+		   rq_ctx->vwqe_wait, rq_ctx->max_vsize_exp);
+	seq_printf(m, "W5: vwqe_skip \t\t\t%d\n\n", rq_ctx->vwqe_skip);
+
+	seq_printf(m, "W6: octs \t\t\t%llu\n\n", (u64)rq_ctx->octs);
+	seq_printf(m, "W7: pkts \t\t\t%llu\n\n", (u64)rq_ctx->pkts);
+	seq_printf(m, "W8: drop_octs \t\t\t%llu\n\n", (u64)rq_ctx->drop_octs);
+	seq_printf(m, "W9: drop_pkts \t\t\t%llu\n\n", (u64)rq_ctx->drop_pkts);
+	seq_printf(m, "W10: re_pkts \t\t\t%llu\n", (u64)rq_ctx->re_pkts);
+}
+
 /* Dumps given nix_rq's context */
 static void print_nix_rq_ctx(struct seq_file *m, struct nix_aq_enq_rsp *rsp)
 {
 	struct nix_rq_ctx_s *rq_ctx = &rsp->rq;
+	struct nix_hw *nix_hw = m->private;
+	struct rvu *rvu = nix_hw->rvu;
+
+	if (!is_rvu_otx2(rvu)) {
+		print_nix_cn10k_rq_ctx(m, (struct nix_cn10k_rq_ctx_s *)rq_ctx);
+		return;
+	}
 
 	seq_printf(m, "W0: wqe_aura \t\t\t%d\nW0: substream \t\t\t0x%03x\n",
 		   rq_ctx->wqe_aura, rq_ctx->substream);
@@ -1551,6 +1713,9 @@ static void rvu_dbg_cgx_init(struct rvu *rvu)
 	char dname[20];
 	void *cgx;
 
+	if (!cgx_get_cgxcnt_max())
+		return;
+
 	rvu->rvu_dbg.cgx_root = debugfs_create_dir("cgx", rvu->rvu_dbg.root);
 
 	for (i = 0; i < cgx_get_cgxcnt_max(); i++) {
@@ -2128,9 +2293,17 @@ static void rvu_dbg_cpt_init(struct rvu *rvu, int blkaddr)
 			    &rvu_dbg_cpt_err_info_fops);
 }
 
+static const char *rvu_get_dbg_dir_name(struct rvu *rvu)
+{
+	if (!is_rvu_otx2(rvu))
+		return "cn10k";
+	else
+		return "octeontx2";
+}
+
 void rvu_dbg_init(struct rvu *rvu)
 {
-	rvu->rvu_dbg.root = debugfs_create_dir(DEBUGFS_DIR_NAME, NULL);
+	rvu->rvu_dbg.root = debugfs_create_dir(rvu_get_dbg_dir_name(rvu), NULL);
 
 	debugfs_create_file("rsrc_alloc", 0444, rvu->rvu_dbg.root, rvu,
 			    &rvu_dbg_rsrc_status_fops);
-- 
2.17.1

