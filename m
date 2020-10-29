Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED8A29E492
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgJ2HkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbgJ2HYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:48 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A484C0611BF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 22:16:29 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g12so1384249pgm.8
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 22:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SZSIjvRmiHjmprgbBa1hYTijjhvThg+IG6XFdYD/tYI=;
        b=nHKBSfzrU0iygpb8rbzcWYRUtrT58u31DyfH/gzL2HpUgYChCv1ecndX/Occz94bKh
         uJw5m24fInrJOBVwc9IP8DKx/y9fmudnExtd8T25yll24Cpeb+u0pLn3MLWndZvNq7v+
         IVb/FZaGFI/mXOyq7DRN0wgh4icAtWoa/q1TgzvQjfzwY/PvdtnkKLYMbKSSBh4MENJ4
         wgIK/U5icih0a5HHb9aT1UCbB8544C8htSmVIcAE/gZ64QtoapBbgDQfTd1fE7j7x0r9
         f/vQd0HLvNBJSkq4qtL01jGrJh57FBuyAnilqRJUlOQ+NgUrGJMmpL08jct/RCEMt+3B
         oPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SZSIjvRmiHjmprgbBa1hYTijjhvThg+IG6XFdYD/tYI=;
        b=eNjpY31h78bGcmErDE64SBAl9R2wMpAGe8OED4NHz3iX9vFKFP/wl0BAtBwkDb6Gyb
         KVpw7QQ+0fU1rgIC9uhw+kYrTFWp0iYdiNFoW8rdWGlaEHH0aq9p65h2FYBWPEH7gWhA
         fc/cR8VeLv2Uj+ZFeq/vebg4vaKY4sQlgDq1GIlqJ5B/KtwMWw3/XqZhzNd+HJGRRGa5
         7cuJr3ix2YRpS+I96kPyZR8pFzsWa8QCAMlJFakyiCmBt/prFqB1SNTgYBP1c9BOA70g
         k20U/IZy0lba0dWp4lahu8lG0C8wzQ1JyCyY3gOMEo+XAc0I86Kfqur+WTOJF9nCGBN3
         mDag==
X-Gm-Message-State: AOAM5311cO2rWIiTQDN4ODQ2YKb4SJZWIa9kFIIQqiP30FOv2jHss6Aj
        yuSIqEYZJem9g1jJHD88mwk=
X-Google-Smtp-Source: ABdhPJzAorCSPVIq5tOqWDos8Vnohwxl/47CFdHaUuA6CXGk5gH0n/goNXukJs/EEOaIEP0BDGGabw==
X-Received: by 2002:a17:90a:b302:: with SMTP id d2mr2464809pjr.57.1603948588544;
        Wed, 28 Oct 2020 22:16:28 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id k7sm1292242pfa.184.2020.10.28.22.16.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Oct 2020 22:16:27 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        netdev@vger.kernel.org
Cc:     Rakesh Babu <rsaladi2@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [v2 net-next PATCH 09/10] octeontx2-af: Display NIX1 also in debugfs
Date:   Thu, 29 Oct 2020 10:45:48 +0530
Message-Id: <1603948549-781-10-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
References: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Babu <rsaladi2@marvell.com>

If NIX1 block is also implemented then add a new
directory for NIX1 in debugfs root. Stats of
NIX1 block can be read/writen from/to the files
in directory "/sys/kernel/debug/octeontx2/nix1/".

Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/common.h |   2 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 166 +++++++++++++++------
 2 files changed, 125 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index 3b7cad5..8f68e7a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -210,6 +210,8 @@ enum ndc_idx_e {
 	NIX0_RX = 0x0,
 	NIX0_TX = 0x1,
 	NPA0_U  = 0x2,
+	NIX1_RX = 0x4,
+	NIX1_TX = 0x5,
 };
 
 enum ndc_ctype_e {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 7b8cc55..b1b54cb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -224,18 +224,11 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 
 RVU_DEBUG_FOPS(rsrc_status, rsrc_attach_status, NULL);
 
-static bool rvu_dbg_is_valid_lf(struct rvu *rvu, int blktype, int lf,
+static bool rvu_dbg_is_valid_lf(struct rvu *rvu, int blkaddr, int lf,
 				u16 *pcifunc)
 {
 	struct rvu_block *block;
 	struct rvu_hwinfo *hw;
-	int blkaddr;
-
-	blkaddr = rvu_get_blkaddr(rvu, blktype, 0);
-	if (blkaddr < 0) {
-		dev_warn(rvu->dev, "Invalid blktype\n");
-		return false;
-	}
 
 	hw = rvu->hw;
 	block = &hw->block[blkaddr];
@@ -291,10 +284,12 @@ static int rvu_dbg_qsize_display(struct seq_file *filp, void *unsused,
 {
 	void (*print_qsize)(struct seq_file *filp,
 			    struct rvu_pfvf *pfvf) = NULL;
+	struct dentry *current_dir;
 	struct rvu_pfvf *pfvf;
 	struct rvu *rvu;
 	int qsize_id;
 	u16 pcifunc;
+	int blkaddr;
 
 	rvu = filp->private;
 	switch (blktype) {
@@ -312,7 +307,15 @@ static int rvu_dbg_qsize_display(struct seq_file *filp, void *unsused,
 		return -EINVAL;
 	}
 
-	if (!rvu_dbg_is_valid_lf(rvu, blktype, qsize_id, &pcifunc))
+	if (blktype == BLKTYPE_NPA) {
+		blkaddr = BLKADDR_NPA;
+	} else {
+		current_dir = filp->file->f_path.dentry->d_parent;
+		blkaddr = (!strcmp(current_dir->d_name.name, "nix1") ?
+				   BLKADDR_NIX1 : BLKADDR_NIX0);
+	}
+
+	if (!rvu_dbg_is_valid_lf(rvu, blkaddr, qsize_id, &pcifunc))
 		return -EINVAL;
 
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
@@ -329,6 +332,8 @@ static ssize_t rvu_dbg_qsize_write(struct file *filp,
 	struct seq_file *seqfile = filp->private_data;
 	char *cmd_buf, *cmd_buf_tmp, *subtoken;
 	struct rvu *rvu = seqfile->private;
+	struct dentry *current_dir;
+	int blkaddr;
 	u16 pcifunc;
 	int ret, lf;
 
@@ -355,7 +360,15 @@ static ssize_t rvu_dbg_qsize_write(struct file *filp,
 		goto qsize_write_done;
 	}
 
-	if (!rvu_dbg_is_valid_lf(rvu, blktype, lf, &pcifunc)) {
+	if (blktype == BLKTYPE_NPA) {
+		blkaddr = BLKADDR_NPA;
+	} else {
+		current_dir = filp->f_path.dentry->d_parent;
+		blkaddr = (!strcmp(current_dir->d_name.name, "nix1") ?
+				   BLKADDR_NIX1 : BLKADDR_NIX0);
+	}
+
+	if (!rvu_dbg_is_valid_lf(rvu, blkaddr, lf, &pcifunc)) {
 		ret = -EINVAL;
 		goto qsize_write_done;
 	}
@@ -498,7 +511,7 @@ static int rvu_dbg_npa_ctx_display(struct seq_file *m, void *unused, int ctype)
 		return -EINVAL;
 	}
 
-	if (!rvu_dbg_is_valid_lf(rvu, BLKTYPE_NPA, npalf, &pcifunc))
+	if (!rvu_dbg_is_valid_lf(rvu, BLKADDR_NPA, npalf, &pcifunc))
 		return -EINVAL;
 
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
@@ -556,7 +569,7 @@ static int write_npa_ctx(struct rvu *rvu, bool all,
 	int max_id = 0;
 	u16 pcifunc;
 
-	if (!rvu_dbg_is_valid_lf(rvu, BLKTYPE_NPA, npalf, &pcifunc))
+	if (!rvu_dbg_is_valid_lf(rvu, BLKADDR_NPA, npalf, &pcifunc))
 		return -EINVAL;
 
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
@@ -704,9 +717,17 @@ static void ndc_cache_stats(struct seq_file *s, int blk_addr,
 			    int ctype, int transaction)
 {
 	u64 req, out_req, lat, cant_alloc;
-	struct rvu *rvu = s->private;
+	struct nix_hw *nix_hw;
+	struct rvu *rvu;
 	int port;
 
+	if (blk_addr == BLKADDR_NDC_NPA0) {
+		rvu = s->private;
+	} else {
+		nix_hw = s->private;
+		rvu = nix_hw->rvu;
+	}
+
 	for (port = 0; port < NDC_MAX_PORT; port++) {
 		req = rvu_read64(rvu, blk_addr, NDC_AF_PORTX_RTX_RWX_REQ_PC
 						(port, ctype, transaction));
@@ -749,9 +770,17 @@ RVU_DEBUG_SEQ_FOPS(npa_ndc_cache, npa_ndc_cache_display, NULL);
 
 static int ndc_blk_hits_miss_stats(struct seq_file *s, int idx, int blk_addr)
 {
-	struct rvu *rvu = s->private;
+	struct nix_hw *nix_hw;
+	struct rvu *rvu;
 	int bank, max_bank;
 
+	if (blk_addr == BLKADDR_NDC_NPA0) {
+		rvu = s->private;
+	} else {
+		nix_hw = s->private;
+		rvu = nix_hw->rvu;
+	}
+
 	max_bank = NDC_MAX_BANK(rvu, blk_addr);
 	for (bank = 0; bank < max_bank; bank++) {
 		seq_printf(s, "BANK:%d\n", bank);
@@ -767,16 +796,30 @@ static int ndc_blk_hits_miss_stats(struct seq_file *s, int idx, int blk_addr)
 
 static int rvu_dbg_nix_ndc_rx_cache_display(struct seq_file *filp, void *unused)
 {
-	return ndc_blk_cache_stats(filp, NIX0_RX,
-				   BLKADDR_NDC_NIX0_RX);
+	struct nix_hw *nix_hw = filp->private;
+	int blkaddr = 0;
+	int ndc_idx = 0;
+
+	blkaddr = (nix_hw->blkaddr == BLKADDR_NIX1 ?
+		   BLKADDR_NDC_NIX1_RX : BLKADDR_NDC_NIX0_RX);
+	ndc_idx = (nix_hw->blkaddr == BLKADDR_NIX1 ? NIX1_RX : NIX0_RX);
+
+	return ndc_blk_cache_stats(filp, ndc_idx, blkaddr);
 }
 
 RVU_DEBUG_SEQ_FOPS(nix_ndc_rx_cache, nix_ndc_rx_cache_display, NULL);
 
 static int rvu_dbg_nix_ndc_tx_cache_display(struct seq_file *filp, void *unused)
 {
-	return ndc_blk_cache_stats(filp, NIX0_TX,
-				   BLKADDR_NDC_NIX0_TX);
+	struct nix_hw *nix_hw = filp->private;
+	int blkaddr = 0;
+	int ndc_idx = 0;
+
+	blkaddr = (nix_hw->blkaddr == BLKADDR_NIX1 ?
+		   BLKADDR_NDC_NIX1_TX : BLKADDR_NDC_NIX0_TX);
+	ndc_idx = (nix_hw->blkaddr == BLKADDR_NIX1 ? NIX1_TX : NIX0_TX);
+
+	return ndc_blk_cache_stats(filp, ndc_idx, blkaddr);
 }
 
 RVU_DEBUG_SEQ_FOPS(nix_ndc_tx_cache, nix_ndc_tx_cache_display, NULL);
@@ -792,8 +835,14 @@ RVU_DEBUG_SEQ_FOPS(npa_ndc_hits_miss, npa_ndc_hits_miss_display, NULL);
 static int rvu_dbg_nix_ndc_rx_hits_miss_display(struct seq_file *filp,
 						void *unused)
 {
-	return ndc_blk_hits_miss_stats(filp,
-				      NPA0_U, BLKADDR_NDC_NIX0_RX);
+	struct nix_hw *nix_hw = filp->private;
+	int ndc_idx = NPA0_U;
+	int blkaddr = 0;
+
+	blkaddr = (nix_hw->blkaddr == BLKADDR_NIX1 ?
+		   BLKADDR_NDC_NIX1_RX : BLKADDR_NDC_NIX0_RX);
+
+	return ndc_blk_hits_miss_stats(filp, ndc_idx, blkaddr);
 }
 
 RVU_DEBUG_SEQ_FOPS(nix_ndc_rx_hits_miss, nix_ndc_rx_hits_miss_display, NULL);
@@ -801,8 +850,14 @@ RVU_DEBUG_SEQ_FOPS(nix_ndc_rx_hits_miss, nix_ndc_rx_hits_miss_display, NULL);
 static int rvu_dbg_nix_ndc_tx_hits_miss_display(struct seq_file *filp,
 						void *unused)
 {
-	return ndc_blk_hits_miss_stats(filp,
-				      NPA0_U, BLKADDR_NDC_NIX0_TX);
+	struct nix_hw *nix_hw = filp->private;
+	int ndc_idx = NPA0_U;
+	int blkaddr = 0;
+
+	blkaddr = (nix_hw->blkaddr == BLKADDR_NIX1 ?
+		   BLKADDR_NDC_NIX1_TX : BLKADDR_NDC_NIX0_TX);
+
+	return ndc_blk_hits_miss_stats(filp, ndc_idx, blkaddr);
 }
 
 RVU_DEBUG_SEQ_FOPS(nix_ndc_tx_hits_miss, nix_ndc_tx_hits_miss_display, NULL);
@@ -969,7 +1024,8 @@ static int rvu_dbg_nix_queue_ctx_display(struct seq_file *filp,
 {
 	void (*print_nix_ctx)(struct seq_file *filp,
 			      struct nix_aq_enq_rsp *rsp) = NULL;
-	struct rvu *rvu = filp->private;
+	struct nix_hw *nix_hw = filp->private;
+	struct rvu *rvu = nix_hw->rvu;
 	struct nix_aq_enq_req aq_req;
 	struct nix_aq_enq_rsp rsp;
 	char *ctype_string = NULL;
@@ -1001,7 +1057,7 @@ static int rvu_dbg_nix_queue_ctx_display(struct seq_file *filp,
 		return -EINVAL;
 	}
 
-	if (!rvu_dbg_is_valid_lf(rvu, BLKTYPE_NIX, nixlf, &pcifunc))
+	if (!rvu_dbg_is_valid_lf(rvu, nix_hw->blkaddr, nixlf, &pcifunc))
 		return -EINVAL;
 
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
@@ -1053,13 +1109,15 @@ static int rvu_dbg_nix_queue_ctx_display(struct seq_file *filp,
 }
 
 static int write_nix_queue_ctx(struct rvu *rvu, bool all, int nixlf,
-			       int id, int ctype, char *ctype_string)
+			       int id, int ctype, char *ctype_string,
+			       struct seq_file *m)
 {
+	struct nix_hw *nix_hw = m->private;
 	struct rvu_pfvf *pfvf;
 	int max_id = 0;
 	u16 pcifunc;
 
-	if (!rvu_dbg_is_valid_lf(rvu, BLKTYPE_NIX, nixlf, &pcifunc))
+	if (!rvu_dbg_is_valid_lf(rvu, nix_hw->blkaddr, nixlf, &pcifunc))
 		return -EINVAL;
 
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
@@ -1119,7 +1177,8 @@ static ssize_t rvu_dbg_nix_queue_ctx_write(struct file *filp,
 					   int ctype)
 {
 	struct seq_file *m = filp->private_data;
-	struct rvu *rvu = m->private;
+	struct nix_hw *nix_hw = m->private;
+	struct rvu *rvu = nix_hw->rvu;
 	char *cmd_buf, *ctype_string;
 	int nixlf, id = 0, ret;
 	bool all = false;
@@ -1155,7 +1214,7 @@ static ssize_t rvu_dbg_nix_queue_ctx_write(struct file *filp,
 		goto done;
 	} else {
 		ret = write_nix_queue_ctx(rvu, all, nixlf, id, ctype,
-					  ctype_string);
+					  ctype_string, m);
 	}
 done:
 	kfree(cmd_buf);
@@ -1259,49 +1318,67 @@ static int rvu_dbg_nix_qsize_display(struct seq_file *filp, void *unused)
 
 RVU_DEBUG_SEQ_FOPS(nix_qsize, nix_qsize_display, nix_qsize_write);
 
-static void rvu_dbg_nix_init(struct rvu *rvu)
+static void rvu_dbg_nix_init(struct rvu *rvu, int blkaddr)
 {
 	const struct device *dev = &rvu->pdev->dev;
+	struct nix_hw *nix_hw;
 	struct dentry *pfile;
 
-	rvu->rvu_dbg.nix = debugfs_create_dir("nix", rvu->rvu_dbg.root);
-	if (!rvu->rvu_dbg.nix) {
-		dev_err(rvu->dev, "create debugfs dir failed for nix\n");
+	if (!is_block_implemented(rvu->hw, blkaddr))
 		return;
+
+	if (blkaddr == BLKADDR_NIX0) {
+		rvu->rvu_dbg.nix = debugfs_create_dir("nix", rvu->rvu_dbg.root);
+		if (!rvu->rvu_dbg.nix) {
+			dev_err(rvu->dev, "create debugfs dir failed for nix\n");
+			return;
+		}
+		nix_hw = &rvu->hw->nix[0];
+	} else {
+		rvu->rvu_dbg.nix = debugfs_create_dir("nix1",
+						      rvu->rvu_dbg.root);
+		if (!rvu->rvu_dbg.nix) {
+			dev_err(rvu->dev,
+				"create debugfs dir failed for nix1\n");
+			return;
+		}
+		nix_hw = &rvu->hw->nix[1];
 	}
 
-	pfile = debugfs_create_file("sq_ctx", 0600, rvu->rvu_dbg.nix, rvu,
+	pfile = debugfs_create_file("sq_ctx", 0600, rvu->rvu_dbg.nix, nix_hw,
 				    &rvu_dbg_nix_sq_ctx_fops);
 	if (!pfile)
 		goto create_failed;
 
-	pfile = debugfs_create_file("rq_ctx", 0600, rvu->rvu_dbg.nix, rvu,
+	pfile = debugfs_create_file("rq_ctx", 0600, rvu->rvu_dbg.nix, nix_hw,
 				    &rvu_dbg_nix_rq_ctx_fops);
 	if (!pfile)
 		goto create_failed;
 
-	pfile = debugfs_create_file("cq_ctx", 0600, rvu->rvu_dbg.nix, rvu,
+	pfile = debugfs_create_file("cq_ctx", 0600, rvu->rvu_dbg.nix, nix_hw,
 				    &rvu_dbg_nix_cq_ctx_fops);
 	if (!pfile)
 		goto create_failed;
 
-	pfile = debugfs_create_file("ndc_tx_cache", 0600, rvu->rvu_dbg.nix, rvu,
-				    &rvu_dbg_nix_ndc_tx_cache_fops);
+	pfile = debugfs_create_file("ndc_tx_cache", 0600, rvu->rvu_dbg.nix,
+				    nix_hw, &rvu_dbg_nix_ndc_tx_cache_fops);
 	if (!pfile)
 		goto create_failed;
 
-	pfile = debugfs_create_file("ndc_rx_cache", 0600, rvu->rvu_dbg.nix, rvu,
-				    &rvu_dbg_nix_ndc_rx_cache_fops);
+	pfile = debugfs_create_file("ndc_rx_cache", 0600, rvu->rvu_dbg.nix,
+				    nix_hw, &rvu_dbg_nix_ndc_rx_cache_fops);
 	if (!pfile)
 		goto create_failed;
 
 	pfile = debugfs_create_file("ndc_tx_hits_miss", 0600, rvu->rvu_dbg.nix,
-				    rvu, &rvu_dbg_nix_ndc_tx_hits_miss_fops);
+				    nix_hw,
+				    &rvu_dbg_nix_ndc_tx_hits_miss_fops);
 	if (!pfile)
 		goto create_failed;
 
 	pfile = debugfs_create_file("ndc_rx_hits_miss", 0600, rvu->rvu_dbg.nix,
-				    rvu, &rvu_dbg_nix_ndc_rx_hits_miss_fops);
+				    nix_hw,
+				    &rvu_dbg_nix_ndc_rx_hits_miss_fops);
 	if (!pfile)
 		goto create_failed;
 
@@ -1312,7 +1389,8 @@ static void rvu_dbg_nix_init(struct rvu *rvu)
 
 	return;
 create_failed:
-	dev_err(dev, "Failed to create debugfs dir/file for NIX\n");
+	dev_err(dev,
+		"Failed to create debugfs dir/file for NIX blk\n");
 	debugfs_remove_recursive(rvu->rvu_dbg.nix);
 }
 
@@ -1692,7 +1770,9 @@ void rvu_dbg_init(struct rvu *rvu)
 		goto create_failed;
 
 	rvu_dbg_npa_init(rvu);
-	rvu_dbg_nix_init(rvu);
+	rvu_dbg_nix_init(rvu, BLKADDR_NIX0);
+
+	rvu_dbg_nix_init(rvu, BLKADDR_NIX1);
 	rvu_dbg_cgx_init(rvu);
 	rvu_dbg_npc_init(rvu);
 
-- 
2.7.4

