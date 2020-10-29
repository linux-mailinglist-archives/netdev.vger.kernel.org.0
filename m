Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECD729E414
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgJ2HeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728246AbgJ2HY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:59 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B090CC0613B8
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 22:16:07 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w65so1389856pfd.3
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 22:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LG6CHPyVONw5tFFrnfLcjfQtq5fgy1SH9ww7KpidR8g=;
        b=SS4h1PkZNKgcgB3oGLlUZ8Sc0YV+W7d+duaAzlZO8ysPP629RRTmvBjzRuB/s26TQn
         0/+5Zw/Ef+7g8bVvj9xIVBcEwY4wCvYgosoycTm44SeKjV0MhpS35NwN4R5tJP0kmfJM
         /MDfkXpRQO4GVHqVZTAouwdm4CXIL8eYt70ORet5soJuBx8odKgYDua4SsgG2tHwd9MP
         wCvn7fr3jCyOjxlTSwsRgbQZ793LNHCY0PLPaXYbkTSmt1ebXK6Sf2QxFvK3T+8CwGSi
         iH7sPWIliS6S6CZeV1GCpPQw+83XJtwH1IZ0fprgOSw0AhhDdN1NpwxAtkQLXEuPnydp
         SyVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LG6CHPyVONw5tFFrnfLcjfQtq5fgy1SH9ww7KpidR8g=;
        b=eQMhYlSsyK98m1LQGPpWTEzswF9R9gzzWBInDHP4nTQ4ehPKMkHq4FTWFnYHbj89Zq
         wJjmo+kzVqE2EJxnJp585cghtMvAQOSZ1wUFZ8y1OEvwXRAN4dMIICfyOIXuMSUJOt4k
         MUPbPpSjtEK4SKu5HUi8BgkndWa3bdbxLUBWetu9k46TfCk+uyRqaIlRl9vjrs2QosZJ
         wEOxFsK/s9hK50WbjugNBjGn4Yh4Y5WWwSuZ9NFSBZWS27libElsOGwXiLhfqhokhLlD
         MFNYj+SljaeU9pLhzEzZopORS6527N3fADiYbThAO4aVDOzYINi8OzcRs8ngp3FQWX/n
         LHIw==
X-Gm-Message-State: AOAM530NQwcfYtPk6gtdA8YHN9RhUR4XwYYnf9E/AFaqwxktdJJS9/RA
        fkkYpjn66c9toQWSHPAuajA=
X-Google-Smtp-Source: ABdhPJxiX6RJAhIXekfAdJmaoPvURG/be5ZSVA+A+mfice8uDrZ4k505GX7UENoMlmVb9B8Sn+klYw==
X-Received: by 2002:a63:fc09:: with SMTP id j9mr2445758pgi.388.1603948567228;
        Wed, 28 Oct 2020 22:16:07 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id k7sm1292242pfa.184.2020.10.28.22.16.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Oct 2020 22:16:06 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        netdev@vger.kernel.org
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>
Subject: [v2 net-next PATCH 01/10] octeontx2-af: Update get/set resource count functions
Date:   Thu, 29 Oct 2020 10:45:40 +0530
Message-Id: <1603948549-781-2-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
References: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Since multiple blocks of same type are present in
98xx, modify functions which get resource count and
which update resource count to work with individual
block address instead of block type.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
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

