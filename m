Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A0728CB92
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 12:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbgJMK05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 06:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbgJMK04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 06:26:56 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C212C0613D0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:26:55 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y1so6906689plp.6
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=++fHmNDvbhoQgnwTB7QfOMvHXuPYbZS4H/nW6oBz3Wk=;
        b=Y11r8XXfl69qMQC/CuJYSog9MLJSfX254FZkmgUl3ge9unv5iBs1JcU9p8Wka0mpQO
         p4yIMxOeS7gsaD9hp70gMyrocxIFsM7oqXeMoyLQ323Wud9za+q9e+w517Dxu8PXLz0P
         yaIPSz/dR6UH7eGPFhwW5dDHwAivNQZ5wKBCzOFEnPOlA1aOv9m96DwqSrSCHIzwMzHd
         0RJhPY2T2lQRfT7ykvfJB7xKIVqJux5MggT0t3cr2nAVDy7rn/zG3wfPOaQQDQbnJGb/
         8akDdtCAf1QBbyiJKdROvtdlNjdqo2iPT3YAmHkgxP5QHqkuuxEcwv/gGK03GrNNf/cb
         0pmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=++fHmNDvbhoQgnwTB7QfOMvHXuPYbZS4H/nW6oBz3Wk=;
        b=LXuez1DItfQaVFKufHauXNR15TYVToymQrE6dlv8Opi6almLRmJtLojOplEXxthR2o
         4a3sLZsR9GM8meYJ8Tz05uOOwQoE5gTLV8lCkjlf2U/eP2wi/PJJv5QAAJhFFQV0zh7a
         MQ4wvQmfCV6XM5sSqZYqwey59UMRgEyNbZb07J4XDonZWyWfp29QxXqJ41HP2TdKQpvP
         e87A9dhOPXZ2CPj5VgJP3I/YBz/X+KXbxLklcmhpX4+9JztE4jwT0uXXGBepclEDQGWj
         fDHJvcWU4vb3GqH8iqOOJkwl4HWgJdPf/OXOtk8V8eDTai7zovMwwgsCVZpqcewpaCxo
         yH1w==
X-Gm-Message-State: AOAM531csCTD3r4INCLlQd7suJWujGxY/hccir/YJ0RE1Aq1V4Ep+lwq
        iASvckjEckwQqhoMlqktcXk=
X-Google-Smtp-Source: ABdhPJzpY5A1vTYONKDW6PZp4H/AzsoaJO8qe6OR64fOXfgSUoGgu1FgiU31H36L0LHkFUuucpD78Q==
X-Received: by 2002:a17:90a:ad98:: with SMTP id s24mr24943081pjq.199.1602584815084;
        Tue, 13 Oct 2020 03:26:55 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id g4sm22034444pgj.15.2020.10.13.03.26.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 03:26:54 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     rsaladi2@marvell.com, sgoutham@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 03/10] octeontx2-af: Initialize NIX1 block
Date:   Tue, 13 Oct 2020 15:56:25 +0530
Message-Id: <1602584792-22274-4-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
References: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Babu <rsaladi2@marvell.com>

This patch modifies NIX functions to operate
with nix_hw context so that existing functions
can be used for both NIX0 and NIX1 blocks. And
the NIX blocks present in the system are initialized
during driver init and freed during exit.

Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   2 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   9 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 128 +++++++++++++++------
 3 files changed, 104 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 2f59983..79b9553 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -66,6 +66,7 @@ static void rvu_setup_hw_capabilities(struct rvu *rvu)
 	hw->cap.nix_shaping = true;
 	hw->cap.nix_tx_link_bp = true;
 	hw->cap.nix_rx_multicast = true;
+	hw->rvu = rvu;
 
 	if (is_rvu_96xx_B0(rvu)) {
 		hw->cap.nix_fixed_txschq_mapping = true;
@@ -812,6 +813,7 @@ static int rvu_setup_nix_hw_resource(struct rvu *rvu, int blkaddr)
 	block->msixcfg_reg = NIX_PRIV_LFX_INT_CFG;
 	block->lfreset_reg = NIX_AF_LF_RST;
 	sprintf(block->name, "NIX%d", blkid);
+	rvu->nix_blkaddr[blkid] = blkaddr;
 	return rvu_alloc_bitmap(&block->lf);
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 0cb5093..a419075 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -28,6 +28,7 @@
 #define	PCI_MBOX_BAR_NUM			4
 
 #define NAME_SIZE				32
+#define MAX_NIX_BLKS				2
 
 /* PF_FUNC */
 #define RVU_PFVF_PF_SHIFT	10
@@ -220,6 +221,8 @@ struct nix_lso {
 };
 
 struct nix_hw {
+	int blkaddr;
+	struct rvu *rvu;
 	struct nix_txsch txsch[NIX_TXSCH_LVL_CNT]; /* Tx schedulers */
 	struct nix_mcast mcast;
 	struct nix_flowkey flowkey;
@@ -255,7 +258,8 @@ struct rvu_hwinfo {
 
 	struct hw_cap    cap;
 	struct rvu_block block[BLK_COUNT]; /* Block info */
-	struct nix_hw    *nix0;
+	struct nix_hw    *nix;
+	struct rvu	 *rvu;
 	struct npc_pkind pkind;
 	struct npc_mcam  mcam;
 };
@@ -316,6 +320,7 @@ struct rvu {
 	struct rvu_pfvf		*hwvf;
 	struct mutex		rsrc_lock; /* Serialize resource alloc/free */
 	int			vfs; /* Number of VFs attached to RVU */
+	int			nix_blkaddr[MAX_NIX_BLKS];
 
 	/* Mbox */
 	struct mbox_wq_info	afpf_wq_info;
@@ -487,6 +492,8 @@ int rvu_get_nixlf_count(struct rvu *rvu);
 void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int npalf);
 int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf, int *nix_blkaddr);
 int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add);
+struct nix_hw *get_nix_hw(struct rvu_hwinfo *hw, int blkaddr);
+int rvu_get_next_nix_blkaddr(struct rvu *rvu, int blkaddr);
 
 /* NPC APIs */
 int rvu_npc_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 21a89dd..096c2e0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -68,6 +68,23 @@ struct mce {
 	u16			pcifunc;
 };
 
+int rvu_get_next_nix_blkaddr(struct rvu *rvu, int blkaddr)
+{
+	int i = 0;
+
+	/*If blkaddr is 0, return the first nix block address*/
+	if (blkaddr == 0)
+		return rvu->nix_blkaddr[blkaddr];
+
+	while (i + 1 < MAX_NIX_BLKS) {
+		if (rvu->nix_blkaddr[i] == blkaddr)
+			return rvu->nix_blkaddr[i + 1];
+		i++;
+	}
+
+	return 0;
+}
+
 bool is_nixlf_attached(struct rvu *rvu, u16 pcifunc)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
@@ -81,14 +98,16 @@ bool is_nixlf_attached(struct rvu *rvu, u16 pcifunc)
 
 int rvu_get_nixlf_count(struct rvu *rvu)
 {
+	int blkaddr = 0, max = 0;
 	struct rvu_block *block;
-	int blkaddr;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
-	if (blkaddr < 0)
-		return 0;
-	block = &rvu->hw->block[blkaddr];
-	return block->lf.max;
+	blkaddr = rvu_get_next_nix_blkaddr(rvu, blkaddr);
+	while (blkaddr) {
+		block = &rvu->hw->block[blkaddr];
+		max += block->lf.max;
+		blkaddr = rvu_get_next_nix_blkaddr(rvu, blkaddr);
+	}
+	return max;
 }
 
 int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf, int *nix_blkaddr)
@@ -130,11 +149,18 @@ static u16 nix_alloc_mce_list(struct nix_mcast *mcast, int count)
 	return idx;
 }
 
-static inline struct nix_hw *get_nix_hw(struct rvu_hwinfo *hw, int blkaddr)
+struct nix_hw *get_nix_hw(struct rvu_hwinfo *hw, int blkaddr)
 {
-	if (blkaddr == BLKADDR_NIX0 && hw->nix0)
-		return hw->nix0;
+	int nix_blkaddr = 0, i = 0;
+	struct rvu *rvu = hw->rvu;
 
+	nix_blkaddr = rvu_get_next_nix_blkaddr(rvu, nix_blkaddr);
+	while (nix_blkaddr) {
+		if (blkaddr == nix_blkaddr && hw->nix)
+			return &hw->nix[i];
+		nix_blkaddr = rvu_get_next_nix_blkaddr(rvu, nix_blkaddr);
+		i++;
+	}
 	return NULL;
 }
 
@@ -622,6 +648,7 @@ static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 	struct rvu_block *block;
 	struct admin_queue *aq;
 	struct rvu_pfvf *pfvf;
+	struct nix_hw *nix_hw;
 	void *ctx, *mask;
 	bool ena;
 	u64 cfg;
@@ -637,6 +664,10 @@ static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 		return NIX_AF_ERR_AQ_ENQUEUE;
 	}
 
+	nix_hw =  get_nix_hw(rvu->hw, blkaddr);
+	if (!nix_hw)
+		return -EINVAL;
+
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
 	nixlf = rvu_get_lf(rvu, block, pcifunc, 0);
 
@@ -669,8 +700,9 @@ static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 		break;
 	case NIX_AQ_CTYPE_MCE:
 		cfg = rvu_read64(rvu, blkaddr, NIX_AF_RX_MCAST_CFG);
+
 		/* Check if index exceeds MCE list length */
-		if (!hw->nix0->mcast.mce_ctx ||
+		if (!nix_hw->mcast.mce_ctx ||
 		    (req->qidx >= (256UL << (cfg & 0xF))))
 			rc = NIX_AF_ERR_AQ_ENQUEUE;
 
@@ -3109,17 +3141,15 @@ static int nix_aq_init(struct rvu *rvu, struct rvu_block *block)
 	return 0;
 }
 
-int rvu_nix_init(struct rvu *rvu)
+static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
 {
 	const struct npc_lt_def_cfg *ltdefs;
 	struct rvu_hwinfo *hw = rvu->hw;
+	int blkaddr = nix_hw->blkaddr;
 	struct rvu_block *block;
-	int blkaddr, err;
+	int err;
 	u64 cfg;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
-	if (blkaddr < 0)
-		return 0;
 	block = &hw->block[blkaddr];
 
 	if (is_rvu_96xx_B0(rvu)) {
@@ -3164,26 +3194,21 @@ int rvu_nix_init(struct rvu *rvu)
 	/* Restore CINT timer delay to HW reset values */
 	rvu_write64(rvu, blkaddr, NIX_AF_CINT_DELAY, 0x0ULL);
 
-	if (blkaddr == BLKADDR_NIX0) {
-		hw->nix0 = devm_kzalloc(rvu->dev,
-					sizeof(struct nix_hw), GFP_KERNEL);
-		if (!hw->nix0)
-			return -ENOMEM;
-
-		err = nix_setup_txschq(rvu, hw->nix0, blkaddr);
+	if (is_block_implemented(hw, blkaddr)) {
+		err = nix_setup_txschq(rvu, nix_hw, blkaddr);
 		if (err)
 			return err;
 
-		err = nix_af_mark_format_setup(rvu, hw->nix0, blkaddr);
+		err = nix_af_mark_format_setup(rvu, nix_hw, blkaddr);
 		if (err)
 			return err;
 
-		err = nix_setup_mcast(rvu, hw->nix0, blkaddr);
+		err = nix_setup_mcast(rvu, nix_hw, blkaddr);
 		if (err)
 			return err;
 
 		/* Configure segmentation offload formats */
-		nix_setup_lso(rvu, hw->nix0, blkaddr);
+		nix_setup_lso(rvu, nix_hw, blkaddr);
 
 		/* Config Outer/Inner L2, IP, TCP, UDP and SCTP NPC layer info.
 		 * This helps HW protocol checker to identify headers
@@ -3236,23 +3261,44 @@ int rvu_nix_init(struct rvu *rvu)
 	return 0;
 }
 
-void rvu_nix_freemem(struct rvu *rvu)
+int rvu_nix_init(struct rvu *rvu)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
-	struct rvu_block *block;
+	struct nix_hw *nix_hw;
+	int blkaddr = 0, err;
+	int i = 0;
+
+	hw->nix = devm_kcalloc(rvu->dev, MAX_NIX_BLKS, sizeof(struct nix_hw),
+			       GFP_KERNEL);
+	if (!hw->nix)
+		return -ENOMEM;
+
+	blkaddr = rvu_get_next_nix_blkaddr(rvu, blkaddr);
+	while (blkaddr) {
+		nix_hw = &hw->nix[i];
+		nix_hw->rvu = rvu;
+		nix_hw->blkaddr = blkaddr;
+		err = rvu_nix_block_init(rvu, nix_hw);
+		if (err)
+			return err;
+		blkaddr = rvu_get_next_nix_blkaddr(rvu, blkaddr);
+		i++;
+	}
+
+	return 0;
+}
+
+static void rvu_nix_block_freemem(struct rvu *rvu, int blkaddr,
+				  struct rvu_block *block)
+{
 	struct nix_txsch *txsch;
 	struct nix_mcast *mcast;
 	struct nix_hw *nix_hw;
-	int blkaddr, lvl;
+	int lvl;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
-	if (blkaddr < 0)
-		return;
-
-	block = &hw->block[blkaddr];
 	rvu_aq_free(rvu, block->aq);
 
-	if (blkaddr == BLKADDR_NIX0) {
+	if (is_block_implemented(rvu->hw, blkaddr)) {
 		nix_hw = get_nix_hw(rvu->hw, blkaddr);
 		if (!nix_hw)
 			return;
@@ -3269,6 +3315,20 @@ void rvu_nix_freemem(struct rvu *rvu)
 	}
 }
 
+void rvu_nix_freemem(struct rvu *rvu)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_block *block;
+	int blkaddr = 0;
+
+	blkaddr = rvu_get_next_nix_blkaddr(rvu, blkaddr);
+	while (blkaddr) {
+		block = &hw->block[blkaddr];
+		rvu_nix_block_freemem(rvu, blkaddr, block);
+		blkaddr = rvu_get_next_nix_blkaddr(rvu, blkaddr);
+	}
+}
+
 int rvu_mbox_handler_nix_lf_start_rx(struct rvu *rvu, struct msg_req *req,
 				     struct msg_rsp *rsp)
 {
-- 
2.7.4

