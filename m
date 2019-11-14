Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED96FBF9D
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfKNF1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:27:32 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43847 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfKNF1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 00:27:32 -0500
Received: by mail-pg1-f195.google.com with SMTP id l24so2926760pgh.10
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c/Zz5bWW0bGSXkDz8JOdChXcgYUp6e1WI8CIQVbkF8s=;
        b=B1AF9U+LcbN+Wk9Hf/UkTydHDby/kqElM0POKwLiFevYusWWbdAI/RJH87EDwuOdjH
         QJNDSPdFLF0JR+/+lZAtakr1Nu0NE6MYl551Ld4Iw0BX+OLOxm1UIEsWlz4FIETdNo9B
         dv3XTgiat90kP9peu9g9KJkOJgQHuq6yEJn5td++XvD47pKxTKTgs7/qE4HJtN9khqVb
         8P88H2fVixXiPrJkf4NM4iF+igBzyIBfCFhh2XGHiqSaJnOj+OwgZd3nLHSCf1mKXen4
         tje5bghhMVn5s8s2H77xnZAtZO1FSC9axG06ygNQqF/tuGENpvSxQ2lwwaRvnWDgQpxk
         5iOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c/Zz5bWW0bGSXkDz8JOdChXcgYUp6e1WI8CIQVbkF8s=;
        b=OJksFwdxg508WBwjfj1u24XeWvrRSmpn89GzugCYF/QzXPFRUSzo/8zN+K4z+7oSYT
         nqy2BbPYujDiLdPLAFAOmP0WTBYmQGSxBkY3xxVyYYWpgXeWesIlhS7Ff3AECjeR5yc4
         hbMfxPX1MVChpEPYrOd56o3lgulG11SeR7V7wpDdKreEdI2CWqNyOchCWRBOfmlsOeVo
         Pe0m1VNoLHHqR/aFs+aHlbr1B12N5HVg+iq8mTwj1g/YlwQ8aQOOHjws1+TKPjiqG/u5
         SFtHDihqBxapV7eLjoxbbOfwBkIVFGbLCAORG55cNOGZhaQTd2TJywIPgj8x624W2+Ff
         NGHA==
X-Gm-Message-State: APjAAAU9GVH7S1OgFDlB1l3lCRVvehuyjZhrJNHtB/7GUepAs1RfNQma
        c8JfFD+YvX2caK9BVlPEEOvJwsIrQKA=
X-Google-Smtp-Source: APXvYqzAuds4DSc1FVz5PxKcfGj5raohPUASwUUu61HjcrUoHF63eYqwvOft5PEuZa0RrSGxCi+XsQ==
X-Received: by 2002:a63:d1a:: with SMTP id c26mr7925621pgl.24.1573709250611;
        Wed, 13 Nov 2019 21:27:30 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id a6sm4913261pja.30.2019.11.13.21.27.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Nov 2019 21:27:30 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 07/18] octeontx2-af: Add NPC MCAM entry allocation status to debugfs
Date:   Thu, 14 Nov 2019 10:56:22 +0530
Message-Id: <1573709193-15446-8-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Added support to display current NPC MCAM entries and counter's allocation
status ín debugfs.

cat /sys/kernel/debug/octeontx2/npc/mcam_info' will dump following info
- MCAM Rx and Tx keysize
- Total MCAM entries and counters
- Current available count
- Count of number of MCAM entries and counters allocated
  by a RVU PF/VF device.

Also, one NPC MCAM counter (last one) is reserved and mapped to
NPC RX_INTF's MISS_ACTION to count dropped packets due to no MCAM
entry match. This pkt drop counter can be checked via debugfs.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   8 ++
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 154 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  52 ++++++-
 3 files changed, 213 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 0451c2b..63b6bbc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -49,6 +49,7 @@ struct rvu_debugfs {
 	struct dentry *lmac;
 	struct dentry *npa;
 	struct dentry *nix;
+	struct dentry *npc;
 	struct dump_ctx npa_aura_ctx;
 	struct dump_ctx npa_pool_ctx;
 	struct dump_ctx nix_cq_ctx;
@@ -123,6 +124,7 @@ struct npc_mcam {
 	u16	lprio_start;
 	u16	hprio_count;
 	u16	hprio_end;
+	u16     rx_miss_act_cntr; /* Counter for RX MISS action */
 };
 
 /* Structure for per RVU func info ie PF/VF */
@@ -498,6 +500,12 @@ void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_enable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_update_flowkey_alg_idx(struct rvu *rvu, u16 pcifunc, int nixlf,
 				    int group, int alg_idx, int mcam_index);
+void rvu_npc_get_mcam_entry_alloc_info(struct rvu *rvu, u16 pcifunc,
+				       int blkaddr, int *alloc_cnt,
+				       int *enable_cnt);
+void rvu_npc_get_mcam_counter_alloc_info(struct rvu *rvu, u16 pcifunc,
+					 int blkaddr, int *alloc_cnt,
+					 int *enable_cnt);
 int rvu_mbox_handler_npc_mcam_alloc_entry(struct rvu *rvu,
 					  struct npc_mcam_alloc_entry_req *req,
 					  struct npc_mcam_alloc_entry_rsp *rsp);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 023f3e5..77adad4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -19,6 +19,7 @@
 #include "rvu_reg.h"
 #include "rvu.h"
 #include "cgx.h"
+#include "npc.h"
 
 #define DEBUGFS_DIR_NAME "octeontx2"
 
@@ -1523,6 +1524,158 @@ static void rvu_dbg_cgx_init(struct rvu *rvu)
 	debugfs_remove_recursive(rvu->rvu_dbg.cgx_root);
 }
 
+/* NPC debugfs APIs */
+static void rvu_print_npc_mcam_info(struct seq_file *s,
+				    u16 pcifunc, int blkaddr)
+{
+	struct rvu *rvu = s->private;
+	int entry_acnt, entry_ecnt;
+	int cntr_acnt, cntr_ecnt;
+
+	/* Skip PF0 */
+	if (!pcifunc)
+		return;
+	rvu_npc_get_mcam_entry_alloc_info(rvu, pcifunc, blkaddr,
+					  &entry_acnt, &entry_ecnt);
+	rvu_npc_get_mcam_counter_alloc_info(rvu, pcifunc, blkaddr,
+					    &cntr_acnt, &cntr_ecnt);
+	if (!entry_acnt && !cntr_acnt)
+		return;
+
+	if (!(pcifunc & RVU_PFVF_FUNC_MASK))
+		seq_printf(s, "\n\t\t Device \t\t: PF%d\n",
+			   rvu_get_pf(pcifunc));
+	else
+		seq_printf(s, "\n\t\t Device \t\t: PF%d VF%d\n",
+			   rvu_get_pf(pcifunc),
+			   (pcifunc & RVU_PFVF_FUNC_MASK) - 1);
+
+	if (entry_acnt) {
+		seq_printf(s, "\t\t Entries allocated \t: %d\n", entry_acnt);
+		seq_printf(s, "\t\t Entries enabled \t: %d\n", entry_ecnt);
+	}
+	if (cntr_acnt) {
+		seq_printf(s, "\t\t Counters allocated \t: %d\n", cntr_acnt);
+		seq_printf(s, "\t\t Counters enabled \t: %d\n", cntr_ecnt);
+	}
+}
+
+static int rvu_dbg_npc_mcam_info_display(struct seq_file *filp, void *unsued)
+{
+	struct rvu *rvu = filp->private;
+	int pf, vf, numvfs, blkaddr;
+	struct npc_mcam *mcam;
+	u16 pcifunc;
+	u64 cfg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	mcam = &rvu->hw->mcam;
+
+	seq_puts(filp, "\nNPC MCAM info:\n");
+	/* MCAM keywidth on receive and transmit sides */
+	cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX));
+	cfg = (cfg >> 32) & 0x07;
+	seq_printf(filp, "\t\t RX keywidth \t: %s\n", (cfg == NPC_MCAM_KEY_X1) ?
+		   "112bits" : ((cfg == NPC_MCAM_KEY_X2) ?
+		   "224bits" : "448bits"));
+	cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_TX));
+	cfg = (cfg >> 32) & 0x07;
+	seq_printf(filp, "\t\t TX keywidth \t: %s\n", (cfg == NPC_MCAM_KEY_X1) ?
+		   "112bits" : ((cfg == NPC_MCAM_KEY_X2) ?
+		   "224bits" : "448bits"));
+
+	mutex_lock(&mcam->lock);
+	/* MCAM entries */
+	seq_printf(filp, "\n\t\t MCAM entries \t: %d\n", mcam->total_entries);
+	seq_printf(filp, "\t\t Reserved \t: %d\n",
+		   mcam->total_entries - mcam->bmap_entries);
+	seq_printf(filp, "\t\t Available \t: %d\n", mcam->bmap_fcnt);
+
+	/* MCAM counters */
+	cfg = rvu_read64(rvu, blkaddr, NPC_AF_CONST);
+	cfg = (cfg >> 48) & 0xFFFF;
+	seq_printf(filp, "\n\t\t MCAM counters \t: %lld\n", cfg);
+	seq_printf(filp, "\t\t Reserved \t: %lld\n", cfg - mcam->counters.max);
+	seq_printf(filp, "\t\t Available \t: %d\n",
+		   rvu_rsrc_free_count(&mcam->counters));
+
+	if (mcam->bmap_entries == mcam->bmap_fcnt) {
+		mutex_unlock(&mcam->lock);
+		return 0;
+	}
+
+	seq_puts(filp, "\n\t\t Current allocation\n");
+	seq_puts(filp, "\t\t====================\n");
+	for (pf = 0; pf < rvu->hw->total_pfs; pf++) {
+		pcifunc = (pf << RVU_PFVF_PF_SHIFT);
+		rvu_print_npc_mcam_info(filp, pcifunc, blkaddr);
+
+		cfg = rvu_read64(rvu, BLKADDR_RVUM, RVU_PRIV_PFX_CFG(pf));
+		numvfs = (cfg >> 12) & 0xFF;
+		for (vf = 0; vf < numvfs; vf++) {
+			pcifunc = (pf << RVU_PFVF_PF_SHIFT) | (vf + 1);
+			rvu_print_npc_mcam_info(filp, pcifunc, blkaddr);
+		}
+	}
+
+	mutex_unlock(&mcam->lock);
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(npc_mcam_info, npc_mcam_info_display, NULL);
+
+static int rvu_dbg_npc_rx_miss_stats_display(struct seq_file *filp,
+					     void *unused)
+{
+	struct rvu *rvu = filp->private;
+	struct npc_mcam *mcam;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	mcam = &rvu->hw->mcam;
+
+	seq_puts(filp, "\nNPC MCAM RX miss action stats\n");
+	seq_printf(filp, "\t\tStat %d: \t%lld\n", mcam->rx_miss_act_cntr,
+		   rvu_read64(rvu, blkaddr,
+			      NPC_AF_MATCH_STATX(mcam->rx_miss_act_cntr)));
+
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(npc_rx_miss_act, npc_rx_miss_stats_display, NULL);
+
+static void rvu_dbg_npc_init(struct rvu *rvu)
+{
+	const struct device *dev = &rvu->pdev->dev;
+	struct dentry *pfile;
+
+	rvu->rvu_dbg.npc = debugfs_create_dir("npc", rvu->rvu_dbg.root);
+	if (!rvu->rvu_dbg.npc)
+		return;
+
+	pfile = debugfs_create_file("mcam_info", 0444, rvu->rvu_dbg.npc,
+				    rvu, &rvu_dbg_npc_mcam_info_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("rx_miss_act_stats", 0444, rvu->rvu_dbg.npc,
+				    rvu, &rvu_dbg_npc_rx_miss_act_fops);
+	if (!pfile)
+		goto create_failed;
+
+	return;
+
+create_failed:
+	dev_err(dev, "Failed to create debugfs dir/file for NPC\n");
+	debugfs_remove_recursive(rvu->rvu_dbg.npc);
+}
+
 void rvu_dbg_init(struct rvu *rvu)
 {
 	struct device *dev = &rvu->pdev->dev;
@@ -1541,6 +1694,7 @@ void rvu_dbg_init(struct rvu *rvu)
 	rvu_dbg_npa_init(rvu);
 	rvu_dbg_nix_init(rvu);
 	rvu_dbg_cgx_init(rvu);
+	rvu_dbg_npc_init(rvu);
 
 	return;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 15f7027..e300abb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1064,6 +1064,13 @@ static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 	mcam->hprio_count = mcam->lprio_count;
 	mcam->hprio_end = mcam->hprio_count;
 
+	/* Reserve last counter for MCAM RX miss action which is set to
+	 * drop pkt. This way we will know how many pkts didn't match
+	 * any MCAM entry.
+	 */
+	mcam->counters.max--;
+	mcam->rx_miss_act_cntr = mcam->counters.max;
+
 	/* Allocate bitmap for managing MCAM counters and memory
 	 * for saving counter to RVU PFFUNC allocation mapping.
 	 */
@@ -1101,6 +1108,7 @@ static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 int rvu_npc_init(struct rvu *rvu)
 {
 	struct npc_pkind *pkind = &rvu->hw->pkind;
+	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u64 keyz = NPC_MCAM_KEY_X2;
 	int blkaddr, entry, bank, err;
 	u64 cfg, nibble_ena;
@@ -1183,9 +1191,13 @@ int rvu_npc_init(struct rvu *rvu)
 	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_MISS_ACT(NIX_INTF_TX),
 		    NIX_TX_ACTIONOP_UCAST_DEFAULT);
 
-	/* If MCAM lookup doesn't result in a match, drop the received packet */
+	/* If MCAM lookup doesn't result in a match, drop the received packet.
+	 * And map this action to a counter to count dropped pkts.
+	 */
 	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_MISS_ACT(NIX_INTF_RX),
 		    NIX_RX_ACTIONOP_DROP);
+	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_MISS_STAT_ACT(NIX_INTF_RX),
+		    BIT_ULL(9) | mcam->rx_miss_act_cntr);
 
 	return 0;
 }
@@ -1200,6 +1212,44 @@ void rvu_npc_freemem(struct rvu *rvu)
 	mutex_destroy(&mcam->lock);
 }
 
+void rvu_npc_get_mcam_entry_alloc_info(struct rvu *rvu, u16 pcifunc,
+				       int blkaddr, int *alloc_cnt,
+				       int *enable_cnt)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	int entry;
+
+	*alloc_cnt = 0;
+	*enable_cnt = 0;
+
+	for (entry = 0; entry < mcam->bmap_entries; entry++) {
+		if (mcam->entry2pfvf_map[entry] == pcifunc) {
+			(*alloc_cnt)++;
+			if (is_mcam_entry_enabled(rvu, mcam, blkaddr, entry))
+				(*enable_cnt)++;
+		}
+	}
+}
+
+void rvu_npc_get_mcam_counter_alloc_info(struct rvu *rvu, u16 pcifunc,
+					 int blkaddr, int *alloc_cnt,
+					 int *enable_cnt)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	int cntr;
+
+	*alloc_cnt = 0;
+	*enable_cnt = 0;
+
+	for (cntr = 0; cntr < mcam->counters.max; cntr++) {
+		if (mcam->cntr2pfvf_map[cntr] == pcifunc) {
+			(*alloc_cnt)++;
+			if (mcam->cntr_refcnt[cntr])
+				(*enable_cnt)++;
+		}
+	}
+}
+
 static int npc_mcam_verify_entry(struct npc_mcam *mcam,
 				 u16 pcifunc, int entry)
 {
-- 
2.7.4

