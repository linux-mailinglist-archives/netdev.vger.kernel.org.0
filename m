Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E86B7FBFA0
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfKNF1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:27:42 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34012 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfKNF1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 00:27:41 -0500
Received: by mail-pf1-f194.google.com with SMTP id n13so3357616pff.1
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4yVhNDMohQjLZ3mxRXbachIrkHm0romPWdB+YxLEfZo=;
        b=BliLEYtq2fQrGW9q5287TJArVuRh/LyIXVwpOMAm6SAb8VcgoTvxBH4JP7TqIv5teK
         lvCdRCIeILrFOjUULlQyr+D3s3brR0qMlUYB+dvkOa8opRimeL3K4H5gBwNBuBwM6iYM
         fIfOvbynt+a3EVCL4s4FONsDdLY01HgCS1M7fIfrLMjeMc5FzxyrcE/LM9vgWpr/Nr3R
         BdZy+ILUZgp3h7rmnxYX+qlRRAqW6iPzpy+8LNHKhwtsSnawhVAmkZkcrkWPz29S1RoG
         vortuVBLyKeEWRwRsN21SYTGdMzom6fBQwyf7pht0hah8/jXmecfKEJBAwwdjZXBt7km
         Tp3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4yVhNDMohQjLZ3mxRXbachIrkHm0romPWdB+YxLEfZo=;
        b=dkwQ7DSSOkb2lEUC2MWZRSoDgh/TgkTD2EeKom0QvVrJ6DbLR6N4Vx1PBHybkS+Yix
         YnjOijHewLuYLCqe70ndgeR28Kfp7Nf60RBRgwn6LYLyNCWaydzPNHA9MTVCmyDsg+nA
         qo3AOIkpQ30OGxo0AAtx2yOXWA0C8E8rpf1X5tlrBwueKe2DrhMQAjHcJd3pcGK6zU2p
         1TMeemLUSAxzOHNuLYvbVHzGUYINM/1vPXAj/mBZTEaQK99aT4BCrqvQBPQba5t7T5Wj
         ZhJpg01c6ex9F3FsmYQc2n8kioWiLlFeDNXHAN1krgpOMXsEnaOtI+oNnhLAfX3Wul8l
         YP3A==
X-Gm-Message-State: APjAAAVA7S97fElolFUBuS7TtK2l3kTawDMIpqrcN4uy/Kc10TxHbid5
        ZrZW9cDfiu4DnOhXZJhBC0qC6PT2Vog=
X-Google-Smtp-Source: APXvYqxkzakOPmHhKcgHWNp1atz7rEVT6chZ8wGSPQ8o649MeTojFpJESLSWuaiqjzHiFk7HbuWBig==
X-Received: by 2002:a63:af1a:: with SMTP id w26mr5534350pge.251.1573709260596;
        Wed, 13 Nov 2019 21:27:40 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id a6sm4913261pja.30.2019.11.13.21.27.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Nov 2019 21:27:39 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 10/18] octeontx2-af: Add macro to generate mbox handlers declarations
Date:   Thu, 14 Nov 2019 10:56:25 +0530
Message-Id: <1573709193-15446-11-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

For every mailbox handler added to rvu, we are adding a function
declaration in rvu header file. Cleaned this up by adding a macro
to generate these declarations automatically.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c |  24 ++---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h | 127 +-----------------------
 2 files changed, 17 insertions(+), 134 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index f5e6aca..49e48b6d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -877,8 +877,8 @@ int rvu_aq_alloc(struct rvu *rvu, struct admin_queue **ad_queue,
 	return 0;
 }
 
-static int rvu_mbox_handler_ready(struct rvu *rvu, struct msg_req *req,
-				  struct ready_msg_rsp *rsp)
+int rvu_mbox_handler_ready(struct rvu *rvu, struct msg_req *req,
+			   struct ready_msg_rsp *rsp)
 {
 	return 0;
 }
@@ -1023,9 +1023,9 @@ static int rvu_detach_rsrcs(struct rvu *rvu, struct rsrc_detach *detach,
 	return 0;
 }
 
-static int rvu_mbox_handler_detach_resources(struct rvu *rvu,
-					     struct rsrc_detach *detach,
-					     struct msg_rsp *rsp)
+int rvu_mbox_handler_detach_resources(struct rvu *rvu,
+				      struct rsrc_detach *detach,
+				      struct msg_rsp *rsp)
 {
 	return rvu_detach_rsrcs(rvu, detach, detach->hdr.pcifunc);
 }
@@ -1171,9 +1171,9 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 	return -ENOSPC;
 }
 
-static int rvu_mbox_handler_attach_resources(struct rvu *rvu,
-					     struct rsrc_attach *attach,
-					     struct msg_rsp *rsp)
+int rvu_mbox_handler_attach_resources(struct rvu *rvu,
+				      struct rsrc_attach *attach,
+				      struct msg_rsp *rsp)
 {
 	u16 pcifunc = attach->hdr.pcifunc;
 	int err;
@@ -1294,8 +1294,8 @@ static void rvu_clear_msix_offset(struct rvu *rvu, struct rvu_pfvf *pfvf,
 	rvu_free_rsrc_contig(&pfvf->msix, nvecs, offset);
 }
 
-static int rvu_mbox_handler_msix_offset(struct rvu *rvu, struct msg_req *req,
-					struct msix_offset_rsp *rsp)
+int rvu_mbox_handler_msix_offset(struct rvu *rvu, struct msg_req *req,
+				 struct msix_offset_rsp *rsp)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
 	u16 pcifunc = req->hdr.pcifunc;
@@ -1343,8 +1343,8 @@ static int rvu_mbox_handler_msix_offset(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
-static int rvu_mbox_handler_vf_flr(struct rvu *rvu, struct msg_req *req,
-				   struct msg_rsp *rsp)
+int rvu_mbox_handler_vf_flr(struct rvu *rvu, struct msg_req *req,
+			    struct msg_rsp *rsp)
 {
 	u16 pcifunc = req->hdr.pcifunc;
 	u16 vf, numvfs;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index e81b0ed..7e990bb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -374,56 +374,23 @@ static inline void rvu_get_cgx_lmac_id(u8 map, u8 *cgx_id, u8 *lmac_id)
 	*lmac_id = (map & 0xF);
 }
 
+#define M(_name, _id, fn_name, req, rsp)				\
+int rvu_mbox_handler_ ## fn_name(struct rvu *, struct req *, struct rsp *);
+MBOX_MESSAGES
+#undef M
+
 int rvu_cgx_init(struct rvu *rvu);
 int rvu_cgx_exit(struct rvu *rvu);
 void *rvu_cgx_pdata(u8 cgx_id, struct rvu *rvu);
 int rvu_cgx_config_rxtx(struct rvu *rvu, u16 pcifunc, bool start);
 int rvu_cgx_nix_cuml_stats(struct rvu *rvu, void *cgxd, int lmac_id, int index,
 			   int rxtxflag, u64 *stat);
-int rvu_mbox_handler_cgx_start_rxtx(struct rvu *rvu, struct msg_req *req,
-				    struct msg_rsp *rsp);
-int rvu_mbox_handler_cgx_stop_rxtx(struct rvu *rvu, struct msg_req *req,
-				   struct msg_rsp *rsp);
-int rvu_mbox_handler_cgx_stats(struct rvu *rvu, struct msg_req *req,
-			       struct cgx_stats_rsp *rsp);
-int rvu_mbox_handler_cgx_mac_addr_set(struct rvu *rvu,
-				      struct cgx_mac_addr_set_or_get *req,
-				      struct cgx_mac_addr_set_or_get *rsp);
-int rvu_mbox_handler_cgx_mac_addr_get(struct rvu *rvu,
-				      struct cgx_mac_addr_set_or_get *req,
-				      struct cgx_mac_addr_set_or_get *rsp);
-int rvu_mbox_handler_cgx_promisc_enable(struct rvu *rvu, struct msg_req *req,
-					struct msg_rsp *rsp);
-int rvu_mbox_handler_cgx_promisc_disable(struct rvu *rvu, struct msg_req *req,
-					 struct msg_rsp *rsp);
-int rvu_mbox_handler_cgx_start_linkevents(struct rvu *rvu, struct msg_req *req,
-					  struct msg_rsp *rsp);
-int rvu_mbox_handler_cgx_stop_linkevents(struct rvu *rvu, struct msg_req *req,
-					 struct msg_rsp *rsp);
-int rvu_mbox_handler_cgx_get_linkinfo(struct rvu *rvu, struct msg_req *req,
-				      struct cgx_link_info_msg *rsp);
-int rvu_mbox_handler_cgx_intlbk_enable(struct rvu *rvu, struct msg_req *req,
-				       struct msg_rsp *rsp);
-int rvu_mbox_handler_cgx_intlbk_disable(struct rvu *rvu, struct msg_req *req,
-					struct msg_rsp *rsp);
-
 /* NPA APIs */
 int rvu_npa_init(struct rvu *rvu);
 void rvu_npa_freemem(struct rvu *rvu);
 void rvu_npa_lf_teardown(struct rvu *rvu, u16 pcifunc, int npalf);
 int rvu_npa_aq_enq_inst(struct rvu *rvu, struct npa_aq_enq_req *req,
 			struct npa_aq_enq_rsp *rsp);
-int rvu_mbox_handler_npa_aq_enq(struct rvu *rvu,
-				struct npa_aq_enq_req *req,
-				struct npa_aq_enq_rsp *rsp);
-int rvu_mbox_handler_npa_hwctx_disable(struct rvu *rvu,
-				       struct hwctx_disable_req *req,
-				       struct msg_rsp *rsp);
-int rvu_mbox_handler_npa_lf_alloc(struct rvu *rvu,
-				  struct npa_lf_alloc_req *req,
-				  struct npa_lf_alloc_rsp *rsp);
-int rvu_mbox_handler_npa_lf_free(struct rvu *rvu, struct msg_req *req,
-				 struct msg_rsp *rsp);
 
 /* NIX APIs */
 bool is_nixlf_attached(struct rvu *rvu, u16 pcifunc);
@@ -433,55 +400,6 @@ int rvu_nix_reserve_mark_format(struct rvu *rvu, struct nix_hw *nix_hw,
 void rvu_nix_freemem(struct rvu *rvu);
 int rvu_get_nixlf_count(struct rvu *rvu);
 void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int npalf);
-int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
-				  struct nix_lf_alloc_req *req,
-				  struct nix_lf_alloc_rsp *rsp);
-int rvu_mbox_handler_nix_lf_free(struct rvu *rvu, struct msg_req *req,
-				 struct msg_rsp *rsp);
-int rvu_mbox_handler_nix_aq_enq(struct rvu *rvu,
-				struct nix_aq_enq_req *req,
-				struct nix_aq_enq_rsp *rsp);
-int rvu_mbox_handler_nix_hwctx_disable(struct rvu *rvu,
-				       struct hwctx_disable_req *req,
-				       struct msg_rsp *rsp);
-int rvu_mbox_handler_nix_txsch_alloc(struct rvu *rvu,
-				     struct nix_txsch_alloc_req *req,
-				     struct nix_txsch_alloc_rsp *rsp);
-int rvu_mbox_handler_nix_txsch_free(struct rvu *rvu,
-				    struct nix_txsch_free_req *req,
-				    struct msg_rsp *rsp);
-int rvu_mbox_handler_nix_txschq_cfg(struct rvu *rvu,
-				    struct nix_txschq_config *req,
-				    struct msg_rsp *rsp);
-int rvu_mbox_handler_nix_stats_rst(struct rvu *rvu, struct msg_req *req,
-				   struct msg_rsp *rsp);
-int rvu_mbox_handler_nix_vtag_cfg(struct rvu *rvu,
-				  struct nix_vtag_config *req,
-				  struct msg_rsp *rsp);
-int rvu_mbox_handler_nix_rxvlan_alloc(struct rvu *rvu, struct msg_req *req,
-				      struct msg_rsp *rsp);
-int rvu_mbox_handler_nix_rss_flowkey_cfg(struct rvu *rvu,
-					 struct nix_rss_flowkey_cfg *req,
-					 struct nix_rss_flowkey_cfg_rsp *rsp);
-int rvu_mbox_handler_nix_set_mac_addr(struct rvu *rvu,
-				      struct nix_set_mac_addr *req,
-				      struct msg_rsp *rsp);
-int rvu_mbox_handler_nix_set_rx_mode(struct rvu *rvu, struct nix_rx_mode *req,
-				     struct msg_rsp *rsp);
-int rvu_mbox_handler_nix_set_hw_frs(struct rvu *rvu, struct nix_frs_cfg *req,
-				    struct msg_rsp *rsp);
-int rvu_mbox_handler_nix_lf_start_rx(struct rvu *rvu, struct msg_req *req,
-				     struct msg_rsp *rsp);
-int rvu_mbox_handler_nix_lf_stop_rx(struct rvu *rvu, struct msg_req *req,
-				    struct msg_rsp *rsp);
-int rvu_mbox_handler_nix_mark_format_cfg(struct rvu *rvu,
-					 struct nix_mark_format_cfg  *req,
-					 struct nix_mark_format_cfg_rsp *rsp);
-int rvu_mbox_handler_nix_set_rx_cfg(struct rvu *rvu, struct nix_rx_cfg *req,
-				    struct msg_rsp *rsp);
-int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,
-					struct nix_lso_format_cfg *req,
-					struct nix_lso_format_cfg_rsp *rsp);
 
 /* NPC APIs */
 int rvu_npc_init(struct rvu *rvu);
@@ -508,41 +426,6 @@ void rvu_npc_get_mcam_entry_alloc_info(struct rvu *rvu, u16 pcifunc,
 void rvu_npc_get_mcam_counter_alloc_info(struct rvu *rvu, u16 pcifunc,
 					 int blkaddr, int *alloc_cnt,
 					 int *enable_cnt);
-int rvu_mbox_handler_npc_mcam_alloc_entry(struct rvu *rvu,
-					  struct npc_mcam_alloc_entry_req *req,
-					  struct npc_mcam_alloc_entry_rsp *rsp);
-int rvu_mbox_handler_npc_mcam_free_entry(struct rvu *rvu,
-					 struct npc_mcam_free_entry_req *req,
-					 struct msg_rsp *rsp);
-int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
-					  struct npc_mcam_write_entry_req *req,
-					  struct msg_rsp *rsp);
-int rvu_mbox_handler_npc_mcam_ena_entry(struct rvu *rvu,
-					struct npc_mcam_ena_dis_entry_req *req,
-					struct msg_rsp *rsp);
-int rvu_mbox_handler_npc_mcam_dis_entry(struct rvu *rvu,
-					struct npc_mcam_ena_dis_entry_req *req,
-					struct msg_rsp *rsp);
-int rvu_mbox_handler_npc_mcam_shift_entry(struct rvu *rvu,
-					  struct npc_mcam_shift_entry_req *req,
-					  struct npc_mcam_shift_entry_rsp *rsp);
-int rvu_mbox_handler_npc_mcam_alloc_counter(struct rvu *rvu,
-				struct npc_mcam_alloc_counter_req *req,
-				struct npc_mcam_alloc_counter_rsp *rsp);
-int rvu_mbox_handler_npc_mcam_free_counter(struct rvu *rvu,
-		   struct npc_mcam_oper_counter_req *req, struct msg_rsp *rsp);
-int rvu_mbox_handler_npc_mcam_clear_counter(struct rvu *rvu,
-		struct npc_mcam_oper_counter_req *req, struct msg_rsp *rsp);
-int rvu_mbox_handler_npc_mcam_unmap_counter(struct rvu *rvu,
-		struct npc_mcam_unmap_counter_req *req, struct msg_rsp *rsp);
-int rvu_mbox_handler_npc_mcam_counter_stats(struct rvu *rvu,
-			struct npc_mcam_oper_counter_req *req,
-			struct npc_mcam_oper_counter_rsp *rsp);
-int rvu_mbox_handler_npc_mcam_alloc_and_write_entry(struct rvu *rvu,
-			  struct npc_mcam_alloc_and_write_entry_req *req,
-			  struct npc_mcam_alloc_and_write_entry_rsp *rsp);
-int rvu_mbox_handler_npc_get_kex_cfg(struct rvu *rvu, struct msg_req *req,
-				     struct npc_get_kex_cfg_rsp *rsp);
 
 #ifdef CONFIG_DEBUG_FS
 void rvu_dbg_init(struct rvu *rvu);
-- 
2.7.4

