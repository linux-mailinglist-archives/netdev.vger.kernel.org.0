Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1E21640D0
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 10:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgBSJwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 04:52:02 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:32980 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgBSJwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 04:52:01 -0500
Received: by mail-pf1-f195.google.com with SMTP id n7so12252989pfn.0
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 01:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GSAnMWzX+AP6bAJBG/Py/WXCgWjsAZJ3fyEBpF+J76w=;
        b=k4c7bcoNPvPJp3rabNXBbSQrf3g3cI91TGCjzFytCiSfZlTBDtPn59vE65Z5viqDrE
         q+bxNNpY3NZ/egYfzxZDjpeLKlBiXe2bEJbmZpj+tmhaRQv3gDgshjhdSKnIyChhIBmk
         R3wIGhhAly/Dy8zUTY0ngDeIAqBflNDcjUNfpJI0KY7gnYX3/53lzTYtIeIG+sqBHSra
         HHwPSJ3q+gqxnq/A2nVrtj0DKLUSITi8ZqINOtaV2sZa4FPy0mJerVNlszLlrGr6WbOM
         VhSGkke0+DzeiStgqYrt9PE3gwt/r8jJWGKYGzenJ25E2wz/86yt9jJ6SNLvhgMvT5es
         61DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GSAnMWzX+AP6bAJBG/Py/WXCgWjsAZJ3fyEBpF+J76w=;
        b=ZaL8Gfk9W+skZd/YfifNL7qmCYhZh6izBektzPgbMCW1BgJV0ombq13+wquCIk0qjO
         kYzBOaNH4/TGDIXQWLg5t4WaIGeDc3lm8FOJoNXz0wYsFF4yLnnGnP0QxmvwtKetyB6z
         MSrgV2rvze4OEQEz+N18X531FlE1gGUPN/R1nMcnuZDfsP5WlXUrV5BdCIe4LYBtcDmM
         317SGOMMlYAEkxiq7gjHWvdBtDaxLIc+oh/BiObGNHDt8JaAA0cIrw6LY6grPqSCaZIr
         1FicMw1lBZ1YmMNldcsrMVOOjVJ0UDdTWbxj97+cDKKjSh1+DTzsjIUrm1fpuA89ULLg
         +WeQ==
X-Gm-Message-State: APjAAAWnP1yUMLAng8KhLamv/Xf18SuygCi7N40cOvx7oZSD0csxBg7X
        F7IcZKzc9XgTUfmwOGqT9Zpdewgsdz8=
X-Google-Smtp-Source: APXvYqwfJH9qYko2A0P7bxvMmo9WuxFtyIof2mQ2x/Mr9mshJNBEU+I3vmQaJMCjXwzINjJBG7x2HA==
X-Received: by 2002:aa7:93a4:: with SMTP id x4mr25940814pff.42.1582105920908;
        Wed, 19 Feb 2020 01:52:00 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id w11sm2023724pgh.5.2020.02.19.01.51.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 19 Feb 2020 01:52:00 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 3/3] octeontx2-af: Cleanup nixlf and blkaddr retrieval logic
Date:   Wed, 19 Feb 2020 15:21:08 +0530
Message-Id: <1582105868-29012-4-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582105868-29012-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1582105868-29012-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Cleanedup repititive nixlf and blkaddr retrieving logic
is various mailbox handlers throughout the rvu_nix.c file.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 131 ++++++++-------------
 2 files changed, 50 insertions(+), 83 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 51c206f..7afb7ca 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -432,7 +432,7 @@ int rvu_nix_reserve_mark_format(struct rvu *rvu, struct nix_hw *nix_hw,
 void rvu_nix_freemem(struct rvu *rvu);
 int rvu_get_nixlf_count(struct rvu *rvu);
 void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int npalf);
-int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf);
+int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf, int *nix_blkaddr);
 
 /* NPC APIs */
 int rvu_npc_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index eb5e542..a29e5c7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -90,6 +90,26 @@ int rvu_get_nixlf_count(struct rvu *rvu)
 	return block->lf.max;
 }
 
+int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf, int *nix_blkaddr)
+{
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	struct rvu_hwinfo *hw = rvu->hw;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+	if (!pfvf->nixlf || blkaddr < 0)
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	*nixlf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
+	if (*nixlf < 0)
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	if (nix_blkaddr)
+		*nix_blkaddr = blkaddr;
+
+	return 0;
+}
+
 static void nix_mce_list_init(struct nix_mce_list *list, int max)
 {
 	INIT_HLIST_HEAD(&list->head);
@@ -1667,13 +1687,9 @@ int rvu_mbox_handler_nix_txschq_cfg(struct rvu *rvu,
 	    req->num_regs > MAX_REGS_PER_MBOX_MSG)
 		return NIX_AF_INVAL_TXSCHQ_CFG;
 
-	err = nix_get_nixlf(rvu, pcifunc, &nixlf);
+	err = nix_get_nixlf(rvu, pcifunc, &nixlf, &blkaddr);
 	if (err)
-		return NIX_AF_ERR_AF_LF_INVALID;
-
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
-	if (blkaddr < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
+		return err;
 
 	nix_hw = get_nix_hw(rvu->hw, blkaddr);
 	if (!nix_hw)
@@ -1767,17 +1783,12 @@ int rvu_mbox_handler_nix_vtag_cfg(struct rvu *rvu,
 				  struct nix_vtag_config *req,
 				  struct msg_rsp *rsp)
 {
-	struct rvu_hwinfo *hw = rvu->hw;
 	u16 pcifunc = req->hdr.pcifunc;
 	int blkaddr, nixlf, err;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
-	if (blkaddr < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
-
-	nixlf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
-	if (nixlf < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
+	err = nix_get_nixlf(rvu, pcifunc, &nixlf, &blkaddr);
+	if (err)
+		return err;
 
 	if (req->cfg_type) {
 		err = nix_rx_vtag_cfg(rvu, nixlf, blkaddr, req);
@@ -2119,18 +2130,13 @@ static int nix_af_mark_format_setup(struct rvu *rvu, struct nix_hw *nix_hw,
 int rvu_mbox_handler_nix_stats_rst(struct rvu *rvu, struct msg_req *req,
 				   struct msg_rsp *rsp)
 {
-	struct rvu_hwinfo *hw = rvu->hw;
 	u16 pcifunc = req->hdr.pcifunc;
-	int i, nixlf, blkaddr;
+	int i, nixlf, blkaddr, err;
 	u64 stats;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
-	if (blkaddr < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
-
-	nixlf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
-	if (nixlf < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
+	err = nix_get_nixlf(rvu, pcifunc, &nixlf, &blkaddr);
+	if (err)
+		return err;
 
 	/* Get stats count supported by HW */
 	stats = rvu_read64(rvu, blkaddr, NIX_AF_CONST1);
@@ -2418,18 +2424,14 @@ int rvu_mbox_handler_nix_rss_flowkey_cfg(struct rvu *rvu,
 					 struct nix_rss_flowkey_cfg *req,
 					 struct nix_rss_flowkey_cfg_rsp *rsp)
 {
-	struct rvu_hwinfo *hw = rvu->hw;
 	u16 pcifunc = req->hdr.pcifunc;
 	int alg_idx, nixlf, blkaddr;
 	struct nix_hw *nix_hw;
+	int err;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
-	if (blkaddr < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
-
-	nixlf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
-	if (nixlf < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
+	err = nix_get_nixlf(rvu, pcifunc, &nixlf, &blkaddr);
+	if (err)
+		return err;
 
 	nix_hw = get_nix_hw(rvu->hw, blkaddr);
 	if (!nix_hw)
@@ -2522,19 +2524,15 @@ int rvu_mbox_handler_nix_set_mac_addr(struct rvu *rvu,
 				      struct nix_set_mac_addr *req,
 				      struct msg_rsp *rsp)
 {
-	struct rvu_hwinfo *hw = rvu->hw;
 	u16 pcifunc = req->hdr.pcifunc;
+	int blkaddr, nixlf, err;
 	struct rvu_pfvf *pfvf;
-	int blkaddr, nixlf;
 
-	pfvf = rvu_get_pfvf(rvu, pcifunc);
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
-	if (!pfvf->nixlf || blkaddr < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
+	err = nix_get_nixlf(rvu, pcifunc, &nixlf, &blkaddr);
+	if (err)
+		return err;
 
-	nixlf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
-	if (nixlf < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
 
 	ether_addr_copy(pfvf->mac_addr, req->mac_addr);
 
@@ -2567,19 +2565,15 @@ int rvu_mbox_handler_nix_set_rx_mode(struct rvu *rvu, struct nix_rx_mode *req,
 				     struct msg_rsp *rsp)
 {
 	bool allmulti = false, disable_promisc = false;
-	struct rvu_hwinfo *hw = rvu->hw;
 	u16 pcifunc = req->hdr.pcifunc;
+	int blkaddr, nixlf, err;
 	struct rvu_pfvf *pfvf;
-	int blkaddr, nixlf;
 
-	pfvf = rvu_get_pfvf(rvu, pcifunc);
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
-	if (!pfvf->nixlf || blkaddr < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
+	err = nix_get_nixlf(rvu, pcifunc, &nixlf, &blkaddr);
+	if (err)
+		return err;
 
-	nixlf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
-	if (nixlf < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
 
 	if (req->mode & NIX_RX_MODE_PROMISC)
 		allmulti = false;
@@ -2794,22 +2788,12 @@ int rvu_mbox_handler_nix_rxvlan_alloc(struct rvu *rvu, struct msg_req *req,
 int rvu_mbox_handler_nix_set_rx_cfg(struct rvu *rvu, struct nix_rx_cfg *req,
 				    struct msg_rsp *rsp)
 {
-	struct rvu_hwinfo *hw = rvu->hw;
-	u16 pcifunc = req->hdr.pcifunc;
-	struct rvu_block *block;
-	struct rvu_pfvf *pfvf;
-	int nixlf, blkaddr;
+	int nixlf, blkaddr, err;
 	u64 cfg;
 
-	pfvf = rvu_get_pfvf(rvu, pcifunc);
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
-	if (!pfvf->nixlf || blkaddr < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
-
-	block = &hw->block[blkaddr];
-	nixlf = rvu_get_lf(rvu, block, pcifunc, 0);
-	if (nixlf < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
+	err = nix_get_nixlf(rvu, req->hdr.pcifunc, &nixlf, &blkaddr);
+	if (err)
+		return err;
 
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_RX_CFG(nixlf));
 	/* Set the interface configuration */
@@ -3114,30 +3098,13 @@ void rvu_nix_freemem(struct rvu *rvu)
 	}
 }
 
-int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf)
-{
-	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
-	struct rvu_hwinfo *hw = rvu->hw;
-	int blkaddr;
-
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
-	if (!pfvf->nixlf || blkaddr < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
-
-	*nixlf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
-	if (*nixlf < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
-
-	return 0;
-}
-
 int rvu_mbox_handler_nix_lf_start_rx(struct rvu *rvu, struct msg_req *req,
 				     struct msg_rsp *rsp)
 {
 	u16 pcifunc = req->hdr.pcifunc;
 	int nixlf, err;
 
-	err = nix_get_nixlf(rvu, pcifunc, &nixlf);
+	err = nix_get_nixlf(rvu, pcifunc, &nixlf, NULL);
 	if (err)
 		return err;
 
@@ -3152,7 +3119,7 @@ int rvu_mbox_handler_nix_lf_stop_rx(struct rvu *rvu, struct msg_req *req,
 	u16 pcifunc = req->hdr.pcifunc;
 	int nixlf, err;
 
-	err = nix_get_nixlf(rvu, pcifunc, &nixlf);
+	err = nix_get_nixlf(rvu, pcifunc, &nixlf, NULL);
 	if (err)
 		return err;
 
-- 
2.7.4

