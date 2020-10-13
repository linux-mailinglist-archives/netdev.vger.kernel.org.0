Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4121B28CB90
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 12:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387513AbgJMK0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 06:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbgJMK0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 06:26:49 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CD1C0613D0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:26:49 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id c20so5846930pfr.8
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mnbrXjOu2r7m8kUXZRAW+15sxoGBtspl4dOMIdYzzgk=;
        b=eUNjIo+URZ+wsW7TpwPSWHtecgLibuoNYO1n8B4lcHTGx7fQ1OcPEztnC3u4VB8PrA
         IuxZbjSahGYDYfrARDM59rwcBRn6yxvxsWDcvvCh+t/cilMY4r1rTKxpIjSf8jXvzTxe
         pgJvya+uumBGCkwhTlfk+YFEnv5vfXsld3dQgo6SuwEGamPpEYJnr6bLRja7kQEM0qJF
         fn8IdSHauM3It9b/nOX7EtXWaBBOg8Dz5BXcOd1DfCWz2H8bNjHtVu7EG65I6D7ZreGT
         fnXBW5XR96A4mUv76zov5xzsu0gkUmyt8So+GrAagaQv4GfRaCwpKwXJ7BSw6cUmWwkM
         bw2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mnbrXjOu2r7m8kUXZRAW+15sxoGBtspl4dOMIdYzzgk=;
        b=sb4B1UOAkfN555yyCKZUdCF7b79aiDy0Xf6/qcwRwsiF2OhHxOlXCZV2HoDdC1NXgg
         zYWsIlOk3WOBoguuZxmXJ4ittUl4TIioP4w2FFHfs2jHW4KmExHDNw/hEeKQdPHYhZX2
         ifxsL4rOHl94C+vAd15Cs2Ve9KpxEewXEjxkpfB9yezipT2sp0DKc2MuzDMea4dRyqgq
         mA6fHMyjboKld5monmlEIODs1N8MZbejkGFQZPxvGIPFq9QyS6gYkvV2Of259PX6Bc6m
         S1uUasIb7qseOUCVwNEntd+xAurWOqanE1zI8lqGwBzOeIOgPtknFslg34Iej/L7kMKi
         YDTA==
X-Gm-Message-State: AOAM533h4vYWbCeZ+PKTyIWZ+QPQ4IN8wX9WNsEdxhfJkI0wPfpt1mUR
        qS8aIYQs+dr/j0PqvpnjOhU=
X-Google-Smtp-Source: ABdhPJzeXkGlvrxUlGwjF/OkDh6w9JBgejiWiCX0kPF9flRP2CrG+QslrHc7IJt/YM3v80JDWkK+/A==
X-Received: by 2002:a62:b506:0:b029:155:d56e:5193 with SMTP id y6-20020a62b5060000b0290155d56e5193mr12273973pfe.52.1602584808912;
        Tue, 13 Oct 2020 03:26:48 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id g4sm22034444pgj.15.2020.10.13.03.26.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 03:26:48 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     rsaladi2@marvell.com, sgoutham@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 01/10] octeontx2-af: Update get/set resource count functions
Date:   Tue, 13 Oct 2020 15:56:23 +0530
Message-Id: <1602584792-22274-2-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
References: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Since multiple blocks of same type are present in
98xx, modify functions which get resource count and
which update resource count to work with individual
block address instead of block type.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 73 +++++++++++++++++--------
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h |  2 +
 2 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index e1f9189..ead7711 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -306,31 +306,36 @@ static void rvu_update_rsrc_map(struct rvu *rvu, struct rvu_pfvf *pfvf,
 
 	block->fn_map[lf] = attach ? pcifunc : 0;
 
-	switch (block->type) {
-	case BLKTYPE_NPA:
+	switch (block->addr) {
+	case BLKADDR_NPA:
 		pfvf->npalf = attach ? true : false;
 		num_lfs = pfvf->npalf;
 		break;
-	case BLKTYPE_NIX:
+	case BLKADDR_NIX0:
+	case BLKADDR_NIX1:
 		pfvf->nixlf = attach ? true : false;
 		num_lfs = pfvf->nixlf;
 		break;
-	case BLKTYPE_SSO:
+	case BLKADDR_SSO:
 		attach ? pfvf->sso++ : pfvf->sso--;
 		num_lfs = pfvf->sso;
 		break;
-	case BLKTYPE_SSOW:
+	case BLKADDR_SSOW:
 		attach ? pfvf->ssow++ : pfvf->ssow--;
 		num_lfs = pfvf->ssow;
 		break;
-	case BLKTYPE_TIM:
+	case BLKADDR_TIM:
 		attach ? pfvf->timlfs++ : pfvf->timlfs--;
 		num_lfs = pfvf->timlfs;
 		break;
-	case BLKTYPE_CPT:
+	case BLKADDR_CPT0:
 		attach ? pfvf->cptlfs++ : pfvf->cptlfs--;
 		num_lfs = pfvf->cptlfs;
 		break;
+	case BLKADDR_CPT1:
+		attach ? pfvf->cpt1_lfs++ : pfvf->cpt1_lfs--;
+		num_lfs = pfvf->cpt1_lfs;
+		break;
 	}
 
 	reg = is_pf ? block->pf_lfcnt_reg : block->vf_lfcnt_reg;
@@ -1025,7 +1030,30 @@ int rvu_mbox_handler_ready(struct rvu *rvu, struct msg_req *req,
 /* Get current count of a RVU block's LF/slots
  * provisioned to a given RVU func.
  */
-static u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blktype)
+u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blkaddr)
+{
+	switch (blkaddr) {
+	case BLKADDR_NPA:
+		return pfvf->npalf ? 1 : 0;
+	case BLKADDR_NIX0:
+	case BLKADDR_NIX1:
+		return pfvf->nixlf ? 1 : 0;
+	case BLKADDR_SSO:
+		return pfvf->sso;
+	case BLKADDR_SSOW:
+		return pfvf->ssow;
+	case BLKADDR_TIM:
+		return pfvf->timlfs;
+	case BLKADDR_CPT0:
+		return pfvf->cptlfs;
+	case BLKADDR_CPT1:
+		return pfvf->cpt1_lfs;
+	}
+	return 0;
+}
+
+/* Return true if LFs of block type are attached to pcifunc */
+static bool is_blktype_attached(struct rvu_pfvf *pfvf, int blktype)
 {
 	switch (blktype) {
 	case BLKTYPE_NPA:
@@ -1033,15 +1061,16 @@ static u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blktype)
 	case BLKTYPE_NIX:
 		return pfvf->nixlf ? 1 : 0;
 	case BLKTYPE_SSO:
-		return pfvf->sso;
+		return !!pfvf->sso;
 	case BLKTYPE_SSOW:
-		return pfvf->ssow;
+		return !!pfvf->ssow;
 	case BLKTYPE_TIM:
-		return pfvf->timlfs;
+		return !!pfvf->timlfs;
 	case BLKTYPE_CPT:
-		return pfvf->cptlfs;
+		return pfvf->cptlfs || pfvf->cpt1_lfs;
 	}
-	return 0;
+
+	return false;
 }
 
 bool is_pffunc_map_valid(struct rvu *rvu, u16 pcifunc, int blktype)
@@ -1054,7 +1083,7 @@ bool is_pffunc_map_valid(struct rvu *rvu, u16 pcifunc, int blktype)
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
 
 	/* Check if this PFFUNC has a LF of type blktype attached */
-	if (!rvu_get_rsrc_mapcount(pfvf, blktype))
+	if (!is_blktype_attached(pfvf, blktype))
 		return false;
 
 	return true;
@@ -1095,7 +1124,7 @@ static void rvu_detach_block(struct rvu *rvu, int pcifunc, int blktype)
 
 	block = &hw->block[blkaddr];
 
-	num_lfs = rvu_get_rsrc_mapcount(pfvf, block->type);
+	num_lfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
 	if (!num_lfs)
 		return;
 
@@ -1216,7 +1245,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 	int free_lfs, mappedlfs;
 
 	/* Only one NPA LF can be attached */
-	if (req->npalf && !rvu_get_rsrc_mapcount(pfvf, BLKTYPE_NPA)) {
+	if (req->npalf && !is_blktype_attached(pfvf, BLKTYPE_NPA)) {
 		block = &hw->block[BLKADDR_NPA];
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (!free_lfs)
@@ -1229,7 +1258,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 	}
 
 	/* Only one NIX LF can be attached */
-	if (req->nixlf && !rvu_get_rsrc_mapcount(pfvf, BLKTYPE_NIX)) {
+	if (req->nixlf && !is_blktype_attached(pfvf, BLKTYPE_NIX)) {
 		block = &hw->block[BLKADDR_NIX0];
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (!free_lfs)
@@ -1250,7 +1279,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 				 pcifunc, req->sso, block->lf.max);
 			return -EINVAL;
 		}
-		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->type);
+		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		/* Check if additional resources are available */
 		if (req->sso > mappedlfs &&
@@ -1266,7 +1295,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 				 pcifunc, req->sso, block->lf.max);
 			return -EINVAL;
 		}
-		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->type);
+		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (req->ssow > mappedlfs &&
 		    ((req->ssow - mappedlfs) > free_lfs))
@@ -1281,7 +1310,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 				 pcifunc, req->timlfs, block->lf.max);
 			return -EINVAL;
 		}
-		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->type);
+		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (req->timlfs > mappedlfs &&
 		    ((req->timlfs - mappedlfs) > free_lfs))
@@ -1296,7 +1325,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 				 pcifunc, req->cptlfs, block->lf.max);
 			return -EINVAL;
 		}
-		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->type);
+		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (req->cptlfs > mappedlfs &&
 		    ((req->cptlfs - mappedlfs) > free_lfs))
@@ -1932,7 +1961,7 @@ static void rvu_blklf_teardown(struct rvu *rvu, u16 pcifunc, u8 blkaddr)
 
 	block = &rvu->hw->block[blkaddr];
 	num_lfs = rvu_get_rsrc_mapcount(rvu_get_pfvf(rvu, pcifunc),
-					block->type);
+					block->addr);
 	if (!num_lfs)
 		return;
 	for (slot = 0; slot < num_lfs; slot++) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 90eed31..0cb5093 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -137,6 +137,7 @@ struct rvu_pfvf {
 	u16		ssow;
 	u16		cptlfs;
 	u16		timlfs;
+	u16		cpt1_lfs;
 	u8		cgx_lmac;
 
 	/* Block LF's MSIX vector info */
@@ -420,6 +421,7 @@ void rvu_free_rsrc(struct rsrc_bmap *rsrc, int id);
 int rvu_rsrc_free_count(struct rsrc_bmap *rsrc);
 int rvu_alloc_rsrc_contig(struct rsrc_bmap *rsrc, int nrsrc);
 bool rvu_rsrc_check_contig(struct rsrc_bmap *rsrc, int nrsrc);
+u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blkaddr);
 int rvu_get_pf(u16 pcifunc);
 struct rvu_pfvf *rvu_get_pfvf(struct rvu *rvu, int pcifunc);
 void rvu_get_pf_numvfs(struct rvu *rvu, int pf, int *numvfs, int *hwvf);
-- 
2.7.4

