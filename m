Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8D228CB9A
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 12:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731027AbgJMK1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 06:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730786AbgJMK1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 06:27:08 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C44C0613D5
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:27:08 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t18so10441711plo.1
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P8nja6Kd/qFsIIjFOvmrMehw60TZQHk+u9NXaknxf0s=;
        b=WVQhCnAVCcFKF2+pK9nSc5VEASAoDw82tVvWW+MGrmKT2f6JqbwqPMuOTRgGNEbbjR
         AjxaoRIqMvDTDrAFrx9LTC6JRRqWuz/WGrlSjEky11d8EzBgojKlXzP60Is1Kqd4TgVl
         PbNScSotIf39ywgy7AY7JjQZwwfZZCfEA2gyResSVncvPa3q9Kw+8YikBkJYH3mVk6mz
         oPQVWWENZNMU/ffpViXc+4TKl/4GfPOVvbnLFu4IHc9BR2Tho+gABqUk/yPCIidRt6uu
         znZejRNXiTZPU6IJ0vNztuZ9JbJp8kS5QuI+iApje87YRemGRMPcIPSGz14E8Hu4Hrow
         4SRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P8nja6Kd/qFsIIjFOvmrMehw60TZQHk+u9NXaknxf0s=;
        b=Q7YKK1HoHL4zGqAt7KJxvp/+4RCT7IlIUJjfsMBpUbmgzqy8J59RMDh20Gp8UbB3WR
         1jWfcbmb/agIQ30pHjdxiozBklwTVA/SSB7y7ToGmuZaRls90ybZ18dUsz2+QuewFwbo
         t9w5Puri/yBPblMfEOo7fGpC3GqY4/+HNESaQJo1BOXoWEG8uSAHZ7IibQ8pUtMBwr6/
         7eTjmspxEyiRTyAuHp3m3UFXqFpQB2p4l4ttpbPU69WJXAErSJagUER28rPNaNVMbij2
         8mb2jX0V5JzTJbVqQimK7ngIMoO22VJg2QyHzYqDjeR6CiP5Zk1Yv/uRnKwiZLUAw6PY
         jKJg==
X-Gm-Message-State: AOAM533XRG9QATFn3FVwcB8DbN+chVMRDNmA76Co6JnURlyhLhRL/lJm
        qYs8TI7v21jJT4UKeITCDRk=
X-Google-Smtp-Source: ABdhPJxnW5Hw6HWroFCcVv9A7nzNJaF58vt/S/8fEnVacRunhoA24vDC8ILn3bQ4xHNhVxMvZgll6w==
X-Received: by 2002:a17:902:d394:b029:d3:f13b:5ef0 with SMTP id e20-20020a170902d394b02900d3f13b5ef0mr26549751pld.64.1602584827593;
        Tue, 13 Oct 2020 03:27:07 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id g4sm22034444pgj.15.2020.10.13.03.27.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 03:27:07 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     rsaladi2@marvell.com, sgoutham@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 07/10] octeontx2-af: Mbox changes for 98xx
Date:   Tue, 13 Oct 2020 15:56:29 +0530
Message-Id: <1602584792-22274-8-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
References: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

This patch puts together all mailbox changes
for 98xx silicon:

Attach ->
Modify resource attach mailbox handler to
request LFs from a block address out of multiple
blocks of same type. If a PF/VF need LFs from two
blocks of same type then attach mbox should be
called twice.

Example:
        struct rsrc_attach *attach;
        .. Allocate memory for message ..
        attach->cptlfs = 3; /* 3 LFs from CPT0 */
        .. Send message ..
        .. Allocate memory for message ..
        attach->modify = 1;
        attach->cpt_blkaddr = BLKADDR_CPT1;
        attach->cptlfs = 2; /* 2 LFs from CPT1 */
        .. Send message ..

Detach ->
Update detach mailbox and its handler to detach
resources from CPT1 and NIX1 blocks.

MSIX ->
Updated the MSIX mailbox and its handler to return
MSIX offsets for the new block CPT1.

Free resources ->
Update free_rsrc mailbox and its handler to return
the free resources count of new blocks NIX1 and CPT1

Links ->
Number of CGX,LBK and SDP links may vary between
platforms. For example, in 98xx number of CGX and LBK
links are more than 96xx. Hence the info about number
of links present in hardware is useful for consumers to
request link configuration properly. This patch sends
this info in nix_lf_alloc_rsp.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   | 19 ++++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 85 ++++++++++++++++++----
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  4 +
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.c    |  2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |  2 +
 5 files changed, 94 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 263a211..f46de841 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -86,7 +86,7 @@ struct mbox_msghdr {
 #define OTX2_MBOX_REQ_SIG (0xdead)
 #define OTX2_MBOX_RSP_SIG (0xbeef)
 	u16 sig;         /* Signature, for validating corrupted msgs */
-#define OTX2_MBOX_VERSION (0x0001)
+#define OTX2_MBOX_VERSION (0x0007)
 	u16 ver;         /* Version of msg's structure for this ID */
 	u16 next_msgoff; /* Offset of next msg within mailbox region */
 	int rc;          /* Msg process'ed response code */
@@ -271,6 +271,17 @@ struct ready_msg_rsp {
  * or to detach partial of a cetain resource type.
  * Rest of the fields specify how many of what type to
  * be attached.
+ * To request LFs from two blocks of same type this mailbox
+ * can be sent twice as below:
+ *      struct rsrc_attach *attach;
+ *       .. Allocate memory for message ..
+ *       attach->cptlfs = 3; <3 LFs from CPT0>
+ *       .. Send message ..
+ *       .. Allocate memory for message ..
+ *       attach->modify = 1;
+ *       attach->cpt_blkaddr = BLKADDR_CPT1;
+ *       attach->cptlfs = 2; <2 LFs from CPT1>
+ *       .. Send message ..
  */
 struct rsrc_attach {
 	struct mbox_msghdr hdr;
@@ -281,6 +292,7 @@ struct rsrc_attach {
 	u16  ssow;
 	u16  timlfs;
 	u16  cptlfs;
+	int  cpt_blkaddr; /* BLKADDR_CPT0/BLKADDR_CPT1 or 0 for BLKADDR_CPT0 */
 };
 
 /* Structure for relinquishing resources.
@@ -314,6 +326,8 @@ struct msix_offset_rsp {
 	u16  ssow_msixoff[MAX_RVU_BLKLF_CNT];
 	u16  timlf_msixoff[MAX_RVU_BLKLF_CNT];
 	u16  cptlf_msixoff[MAX_RVU_BLKLF_CNT];
+	u8   cpt1_lfs;
+	u16  cpt1_lf_msixoff[MAX_RVU_BLKLF_CNT];
 };
 
 struct get_hw_cap_rsp {
@@ -491,6 +505,9 @@ struct nix_lf_alloc_rsp {
 	u8	lf_tx_stats; /* NIX_AF_CONST1::LF_TX_STATS */
 	u16	cints; /* NIX_AF_CONST2::CINTS */
 	u16	qints; /* NIX_AF_CONST2::QINTS */
+	u8	cgx_links;  /* No. of CGX links present in HW */
+	u8	lbk_links;  /* No. of LBK links present in HW */
+	u8	sdp_links;  /* No. of SDP links present in HW */
 };
 
 /* NIX AQ enqueue msg */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 2a95641..a28a518 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1229,6 +1229,8 @@ static int rvu_detach_rsrcs(struct rvu *rvu, struct rsrc_detach *detach,
 				continue;
 			else if ((blkid == BLKADDR_NIX0) && !detach->nixlf)
 				continue;
+			else if ((blkid == BLKADDR_NIX1) && !detach->nixlf)
+				continue;
 			else if ((blkid == BLKADDR_SSO) && !detach->sso)
 				continue;
 			else if ((blkid == BLKADDR_SSOW) && !detach->ssow)
@@ -1237,6 +1239,8 @@ static int rvu_detach_rsrcs(struct rvu *rvu, struct rsrc_detach *detach,
 				continue;
 			else if ((blkid == BLKADDR_CPT0) && !detach->cptlfs)
 				continue;
+			else if ((blkid == BLKADDR_CPT1) && !detach->cptlfs)
+				continue;
 		}
 		rvu_detach_block(rvu, pcifunc, block->type);
 	}
@@ -1290,7 +1294,8 @@ static int rvu_get_nix_blkaddr(struct rvu *rvu, u16 pcifunc)
 	return pfvf->nix_blkaddr;
 }
 
-static int rvu_get_attach_blkaddr(struct rvu *rvu, int blktype, u16 pcifunc)
+static int rvu_get_attach_blkaddr(struct rvu *rvu, int blktype,
+				  u16 pcifunc, struct rsrc_attach *attach)
 {
 	int blkaddr;
 
@@ -1298,6 +1303,14 @@ static int rvu_get_attach_blkaddr(struct rvu *rvu, int blktype, u16 pcifunc)
 	case BLKTYPE_NIX:
 		blkaddr = rvu_get_nix_blkaddr(rvu, pcifunc);
 		break;
+	case BLKTYPE_CPT:
+		if (attach->hdr.ver < RVU_MULTI_BLK_VER)
+			return rvu_get_blkaddr(rvu, blktype, 0);
+		blkaddr = attach->cpt_blkaddr ? attach->cpt_blkaddr :
+			  BLKADDR_CPT0;
+		if (blkaddr != BLKADDR_CPT0 && blkaddr != BLKADDR_CPT1)
+			return -ENODEV;
+		break;
 	default:
 		return rvu_get_blkaddr(rvu, blktype, 0);
 	};
@@ -1308,8 +1321,8 @@ static int rvu_get_attach_blkaddr(struct rvu *rvu, int blktype, u16 pcifunc)
 	return -ENODEV;
 }
 
-static void rvu_attach_block(struct rvu *rvu, int pcifunc,
-			     int blktype, int num_lfs)
+static void rvu_attach_block(struct rvu *rvu, int pcifunc, int blktype,
+			     int num_lfs, struct rsrc_attach *attach)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -1321,7 +1334,7 @@ static void rvu_attach_block(struct rvu *rvu, int pcifunc,
 	if (!num_lfs)
 		return;
 
-	blkaddr = rvu_get_attach_blkaddr(rvu, blktype, pcifunc);
+	blkaddr = rvu_get_attach_blkaddr(rvu, blktype, pcifunc, attach);
 	if (blkaddr < 0)
 		return;
 
@@ -1369,7 +1382,8 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 
 	/* Only one NIX LF can be attached */
 	if (req->nixlf && !is_blktype_attached(pfvf, BLKTYPE_NIX)) {
-		blkaddr = rvu_get_attach_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+		blkaddr = rvu_get_attach_blkaddr(rvu, BLKTYPE_NIX,
+						 pcifunc, req);
 		if (blkaddr < 0)
 			return blkaddr;
 		block = &hw->block[blkaddr];
@@ -1431,7 +1445,11 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 	}
 
 	if (req->cptlfs) {
-		block = &hw->block[BLKADDR_CPT0];
+		blkaddr = rvu_get_attach_blkaddr(rvu, BLKTYPE_CPT,
+						 pcifunc, req);
+		if (blkaddr < 0)
+			return blkaddr;
+		block = &hw->block[blkaddr];
 		if (req->cptlfs > block->lf.max) {
 			dev_err(&rvu->pdev->dev,
 				"Func 0x%x: Invalid CPTLF req, %d > max %d\n",
@@ -1452,6 +1470,22 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 	return -ENOSPC;
 }
 
+static bool rvu_attach_from_same_block(struct rvu *rvu, int blktype,
+				       struct rsrc_attach *attach)
+{
+	int blkaddr, num_lfs;
+
+	blkaddr = rvu_get_attach_blkaddr(rvu, blktype,
+					 attach->hdr.pcifunc, attach);
+	if (blkaddr < 0)
+		return false;
+
+	num_lfs = rvu_get_rsrc_mapcount(rvu_get_pfvf(rvu, attach->hdr.pcifunc),
+					blkaddr);
+	/* Requester already has LFs from given block ? */
+	return !!num_lfs;
+}
+
 int rvu_mbox_handler_attach_resources(struct rvu *rvu,
 				      struct rsrc_attach *attach,
 				      struct msg_rsp *rsp)
@@ -1472,10 +1506,10 @@ int rvu_mbox_handler_attach_resources(struct rvu *rvu,
 
 	/* Now attach the requested resources */
 	if (attach->npalf)
-		rvu_attach_block(rvu, pcifunc, BLKTYPE_NPA, 1);
+		rvu_attach_block(rvu, pcifunc, BLKTYPE_NPA, 1, attach);
 
 	if (attach->nixlf)
-		rvu_attach_block(rvu, pcifunc, BLKTYPE_NIX, 1);
+		rvu_attach_block(rvu, pcifunc, BLKTYPE_NIX, 1, attach);
 
 	if (attach->sso) {
 		/* RVU func doesn't know which exact LF or slot is attached
@@ -1485,25 +1519,30 @@ int rvu_mbox_handler_attach_resources(struct rvu *rvu,
 		 */
 		if (attach->modify)
 			rvu_detach_block(rvu, pcifunc, BLKTYPE_SSO);
-		rvu_attach_block(rvu, pcifunc, BLKTYPE_SSO, attach->sso);
+		rvu_attach_block(rvu, pcifunc, BLKTYPE_SSO,
+				 attach->sso, attach);
 	}
 
 	if (attach->ssow) {
 		if (attach->modify)
 			rvu_detach_block(rvu, pcifunc, BLKTYPE_SSOW);
-		rvu_attach_block(rvu, pcifunc, BLKTYPE_SSOW, attach->ssow);
+		rvu_attach_block(rvu, pcifunc, BLKTYPE_SSOW,
+				 attach->ssow, attach);
 	}
 
 	if (attach->timlfs) {
 		if (attach->modify)
 			rvu_detach_block(rvu, pcifunc, BLKTYPE_TIM);
-		rvu_attach_block(rvu, pcifunc, BLKTYPE_TIM, attach->timlfs);
+		rvu_attach_block(rvu, pcifunc, BLKTYPE_TIM,
+				 attach->timlfs, attach);
 	}
 
 	if (attach->cptlfs) {
-		if (attach->modify)
+		if (attach->modify &&
+		    rvu_attach_from_same_block(rvu, BLKTYPE_CPT, attach))
 			rvu_detach_block(rvu, pcifunc, BLKTYPE_CPT);
-		rvu_attach_block(rvu, pcifunc, BLKTYPE_CPT, attach->cptlfs);
+		rvu_attach_block(rvu, pcifunc, BLKTYPE_CPT,
+				 attach->cptlfs, attach);
 	}
 
 exit:
@@ -1581,7 +1620,7 @@ int rvu_mbox_handler_msix_offset(struct rvu *rvu, struct msg_req *req,
 	struct rvu_hwinfo *hw = rvu->hw;
 	u16 pcifunc = req->hdr.pcifunc;
 	struct rvu_pfvf *pfvf;
-	int lf, slot;
+	int lf, slot, blkaddr;
 
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
 	if (!pfvf->msix.bmap)
@@ -1591,8 +1630,14 @@ int rvu_mbox_handler_msix_offset(struct rvu *rvu, struct msg_req *req,
 	lf = rvu_get_lf(rvu, &hw->block[BLKADDR_NPA], pcifunc, 0);
 	rsp->npa_msixoff = rvu_get_msix_offset(rvu, pfvf, BLKADDR_NPA, lf);
 
-	lf = rvu_get_lf(rvu, &hw->block[BLKADDR_NIX0], pcifunc, 0);
-	rsp->nix_msixoff = rvu_get_msix_offset(rvu, pfvf, BLKADDR_NIX0, lf);
+	/* Get BLKADDR from which LFs are attached to pcifunc */
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+	if (blkaddr < 0) {
+		rsp->nix_msixoff = MSIX_VECTOR_INVALID;
+	} else {
+		lf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
+		rsp->nix_msixoff = rvu_get_msix_offset(rvu, pfvf, blkaddr, lf);
+	}
 
 	rsp->sso = pfvf->sso;
 	for (slot = 0; slot < rsp->sso; slot++) {
@@ -1621,6 +1666,14 @@ int rvu_mbox_handler_msix_offset(struct rvu *rvu, struct msg_req *req,
 		rsp->cptlf_msixoff[slot] =
 			rvu_get_msix_offset(rvu, pfvf, BLKADDR_CPT0, lf);
 	}
+
+	rsp->cpt1_lfs = pfvf->cpt1_lfs;
+	for (slot = 0; slot < rsp->cpt1_lfs; slot++) {
+		lf = rvu_get_lf(rvu, &hw->block[BLKADDR_CPT1], pcifunc, slot);
+		rsp->cpt1_lf_msixoff[slot] =
+			rvu_get_msix_offset(rvu, pfvf, BLKADDR_CPT1, lf);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 9b60172..8bac1dd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1217,6 +1217,10 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST2);
 	rsp->qints = ((cfg >> 12) & 0xFFF);
 	rsp->cints = ((cfg >> 24) & 0xFFF);
+	rsp->cgx_links = hw->cgx_links;
+	rsp->lbk_links = hw->lbk_links;
+	rsp->sdp_links = hw->sdp_links;
+
 	return rc;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.c
index 9d7c135..e266f0c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.c
@@ -35,7 +35,7 @@ static struct hw_reg_map txsch_reg_map[NIX_TXSCH_LVL_CNT] = {
 			      {0x1200, 0x12E0} } },
 	{NIX_TXSCH_LVL_TL3, 3, 0xFFFF, {{0x1000, 0x10E0}, {0x1600, 0x1608},
 			      {0x1610, 0x1618} } },
-	{NIX_TXSCH_LVL_TL2, 2, 0xFFFF, {{0x0E00, 0x0EE0}, {0x1700, 0x1768} } },
+	{NIX_TXSCH_LVL_TL2, 2, 0xFFFF, {{0x0E00, 0x0EE0}, {0x1700, 0x17B0} } },
 	{NIX_TXSCH_LVL_TL1, 1, 0xFFFF, {{0x0C00, 0x0D98} } },
 };
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 6336de3..9a7eb07 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -14,6 +14,8 @@
 /* RVU Block revision IDs */
 #define RVU_BLK_RVUM_REVID		0x01
 
+#define RVU_MULTI_BLK_VER		0x7ULL
+
 /* RVU Block Address Enumeration */
 enum rvu_block_addr_e {
 	BLKADDR_RVUM		= 0x0ULL,
-- 
2.7.4

