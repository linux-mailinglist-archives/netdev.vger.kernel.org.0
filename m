Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A0F29E42E
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbgJ2Hfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbgJ2HY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:56 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C82C0613BE
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 22:16:23 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t14so1405090pgg.1
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 22:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P8nja6Kd/qFsIIjFOvmrMehw60TZQHk+u9NXaknxf0s=;
        b=FnyqhnTcTWxA1/HtCDZXEKCD3FbMbSHWiYlGIO4O5POosJMZHGGBr+TeS6+8dJmx1j
         h601qPNJiSZ16hQg2MFmr6oHv9K/oOLIxLablqH5CjSQd7KHTbqE7z6o+ly9z2FDCNXm
         bh/5oxE+CyYSzMcIjPDM+zVkKqXh4FKNrW7rCtBCzu1CYxz2m7ALmtLZs+4sE8T3gYmC
         FcJaTpiS8hlS48iSk0RzAD3Hdrd5D7fpWLwvGGXGqTwEWHCOHOhv8xjUFJLtPoLpIUxg
         Fuf4tOYLT8W9E48HAsepkm74CBpkieQsKbClg58wB8IjSBHTl7gbfbxlMcbsObOsTCel
         dJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P8nja6Kd/qFsIIjFOvmrMehw60TZQHk+u9NXaknxf0s=;
        b=qGRYvW16GrGD3Ko5nDuHZfWNBS+CQRlSaNlUpsPSxn7g5bvzZT4y/wE+HrMKJRxHyI
         wOFKJKkGkPs3JsxCm6tRYl5Vswu+48yL7TV/075wEER5TIJvveQgYxNoruHaotuLEkPe
         2SJ52xJUkiqEdehPO6gifefYRb7hQcmeu7SOdiZfrFcIlyTLsoEhugMnOxuAF1h3keD6
         6EU/qfiqQkBcJHfePYE8P2NFQLGSl7lpyJwPsWk5PncrXQ90B/Y/9a43S7KDVVktXuPx
         6EOxPIxDQzmSD/5uxd2E5YQQvabnt10urzQX7u+p7jCMgosxNBoPaQi+c5LUxeRv0d2/
         uqPg==
X-Gm-Message-State: AOAM532oP6O6GDOKJgsC99vVJ8ffXT+iTvxV6AcVJGQ5964qq9aW6ouL
        OUSjEBkfJDx6s0MBa0w7mOI=
X-Google-Smtp-Source: ABdhPJyTMhGGFAgW+5I67SA3cqjPYsLP6TRIpYR66sLW4EO/Fkp/9Zf/0ZacBu5K1agTrUI8UJG4Qg==
X-Received: by 2002:a62:4e56:0:b029:163:d281:8d7d with SMTP id c83-20020a624e560000b0290163d2818d7dmr2467306pfb.35.1603948583220;
        Wed, 28 Oct 2020 22:16:23 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id k7sm1292242pfa.184.2020.10.28.22.16.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Oct 2020 22:16:22 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        netdev@vger.kernel.org
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>
Subject: [v2 net-next PATCH 07/10] octeontx2-af: Mbox changes for 98xx
Date:   Thu, 29 Oct 2020 10:45:46 +0530
Message-Id: <1603948549-781-8-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
References: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
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

