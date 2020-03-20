Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A6518D809
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 19:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgCTS6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 14:58:07 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44434 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbgCTS6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 14:58:07 -0400
Received: by mail-pf1-f193.google.com with SMTP id b72so3741512pfb.11
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 11:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L9/1ZU5amMbdcvmFlYMISxBrnNH9zk2HwadE1YTFdVY=;
        b=BEpFCw8sxF2lmbECQMyk5kAlQZc5O8ryaWUKFCEnSj+vBWVtYrhkPxUuB36mEr+wEK
         Q6kljzNZhchDXj+g2hDkLQTj3Lrdmv9CD66ccPa2N+4skamB0FhvqqBCrE7wSQriet4R
         yhhB9TOmv5xvAqK7mCIfKiTZrDNMKOCrSf5cDAnn4ryB7PnszpP7gljVD/J2SCjITlW7
         YIfCqMB9VOdo2L/SDKvAXE1i1O/OikPey+60PmDdu9Y4bamVZt7g2lkNaUFJWh5WOHuO
         NjieEWSe7PAK5VS1Hkd/0pKeyQ7wF73tKzzGzv0m6AyeKVMazUmmDpxOpYkdH5i7X6k7
         Di/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L9/1ZU5amMbdcvmFlYMISxBrnNH9zk2HwadE1YTFdVY=;
        b=Q2hs/0GC5J8rxmiTHl9Q3VUYEoh7oJ/PhMjQ/JB/02Ofg0F74bssR1CcfAtfy+iMol
         6pMgMAZKJsa3Aymk0+sBaEJYY7wTPwVXGPaNkBuUwbPOKHqMX5jdzhWhkj50auWTogqp
         2h+OjAXn78XtyR4inb1xQfBKTptgSPFG86EAkT7EmrQkIHu7LwiO1u910OmxV0yukbvy
         H8ODZRNlSNd5umy5sa8mKJlt/ik5nDugJx2XltDx3LmhSDruVz+A1tNfW54eQb00fUjj
         Kti+1dTZGJsAqMdzNONdoBoTmtOfNJlEo30O0lSOaAe+j+GqjubTK6JLrIQs+/9hYSrQ
         rtRg==
X-Gm-Message-State: ANhLgQ09L+nS2DykTrWS2gpWbYc4Xbp4UZAv2jXhUJDO/WR4MHwHBtFN
        o5Ge5Bh2y3SJxkGyOTX9Q+4XYxbkZ2Q=
X-Google-Smtp-Source: ADFU+vscw1b5JAUN534BGB33Qyakw48a+BLPbe14/XeH8/0LvJ1md2aJFi+dXvb1R+ng6g3mqVh2Ag==
X-Received: by 2002:a62:3086:: with SMTP id w128mr11275525pfw.63.1584730683561;
        Fri, 20 Mar 2020 11:58:03 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id l59sm2407044pjb.2.2020.03.20.11.58.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Mar 2020 11:58:02 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        andrew@lunn.ch, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v4 net-next 8/8] octeontx2-pf: Remove wrapper APIs for mutex lock and unlock
Date:   Sat, 21 Mar 2020 00:27:26 +0530
Message-Id: <1584730646-15953-9-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584730646-15953-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1584730646-15953-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

This patch removes wrapper fn()s around mutex_init/lock/unlock.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 76 +++++++++++-----------
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   | 15 -----
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 65 +++++++++---------
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  6 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  2 +-
 5 files changed, 75 insertions(+), 89 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index bac1922..f1d2dea 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -49,15 +49,15 @@ void otx2_update_lmac_stats(struct otx2_nic *pfvf)
 	if (!netif_running(pfvf->netdev))
 		return;
 
-	otx2_mbox_lock(&pfvf->mbox);
+	mutex_lock(&pfvf->mbox.lock);
 	req = otx2_mbox_alloc_msg_cgx_stats(&pfvf->mbox);
 	if (!req) {
-		otx2_mbox_unlock(&pfvf->mbox);
+		mutex_unlock(&pfvf->mbox.lock);
 		return;
 	}
 
 	otx2_sync_mbox_msg(&pfvf->mbox);
-	otx2_mbox_unlock(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
 }
 
 int otx2_update_rq_stats(struct otx2_nic *pfvf, int qidx)
@@ -136,17 +136,17 @@ static int otx2_hw_set_mac_addr(struct otx2_nic *pfvf, u8 *mac)
 	struct nix_set_mac_addr *req;
 	int err;
 
-	otx2_mbox_lock(&pfvf->mbox);
+	mutex_lock(&pfvf->mbox.lock);
 	req = otx2_mbox_alloc_msg_nix_set_mac_addr(&pfvf->mbox);
 	if (!req) {
-		otx2_mbox_unlock(&pfvf->mbox);
+		mutex_unlock(&pfvf->mbox.lock);
 		return -ENOMEM;
 	}
 
 	ether_addr_copy(req->mac_addr, mac);
 
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
-	otx2_mbox_unlock(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
 	return err;
 }
 
@@ -158,27 +158,27 @@ static int otx2_hw_get_mac_addr(struct otx2_nic *pfvf,
 	struct msg_req *req;
 	int err;
 
-	otx2_mbox_lock(&pfvf->mbox);
+	mutex_lock(&pfvf->mbox.lock);
 	req = otx2_mbox_alloc_msg_nix_get_mac_addr(&pfvf->mbox);
 	if (!req) {
-		otx2_mbox_unlock(&pfvf->mbox);
+		mutex_unlock(&pfvf->mbox.lock);
 		return -ENOMEM;
 	}
 
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
 	if (err) {
-		otx2_mbox_unlock(&pfvf->mbox);
+		mutex_unlock(&pfvf->mbox.lock);
 		return err;
 	}
 
 	msghdr = otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
 	if (IS_ERR(msghdr)) {
-		otx2_mbox_unlock(&pfvf->mbox);
+		mutex_unlock(&pfvf->mbox.lock);
 		return PTR_ERR(msghdr);
 	}
 	rsp = (struct nix_get_mac_addr_rsp *)msghdr;
 	ether_addr_copy(netdev->dev_addr, rsp->mac_addr);
-	otx2_mbox_unlock(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
 
 	return 0;
 }
@@ -205,10 +205,10 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 	struct nix_frs_cfg *req;
 	int err;
 
-	otx2_mbox_lock(&pfvf->mbox);
+	mutex_lock(&pfvf->mbox.lock);
 	req = otx2_mbox_alloc_msg_nix_set_hw_frs(&pfvf->mbox);
 	if (!req) {
-		otx2_mbox_unlock(&pfvf->mbox);
+		mutex_unlock(&pfvf->mbox.lock);
 		return -ENOMEM;
 	}
 
@@ -216,7 +216,7 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 	req->maxlen = pfvf->max_frs;
 
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
-	otx2_mbox_unlock(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
 	return err;
 }
 
@@ -228,7 +228,7 @@ int otx2_config_pause_frm(struct otx2_nic *pfvf)
 	if (is_otx2_lbkvf(pfvf->pdev))
 		return 0;
 
-	otx2_mbox_lock(&pfvf->mbox);
+	mutex_lock(&pfvf->mbox.lock);
 	req = otx2_mbox_alloc_msg_cgx_cfg_pause_frm(&pfvf->mbox);
 	if (!req) {
 		err = -ENOMEM;
@@ -241,7 +241,7 @@ int otx2_config_pause_frm(struct otx2_nic *pfvf)
 
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
 unlock:
-	otx2_mbox_unlock(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
 	return err;
 }
 
@@ -251,10 +251,10 @@ int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 	struct nix_rss_flowkey_cfg *req;
 	int err;
 
-	otx2_mbox_lock(&pfvf->mbox);
+	mutex_lock(&pfvf->mbox.lock);
 	req = otx2_mbox_alloc_msg_nix_rss_flowkey_cfg(&pfvf->mbox);
 	if (!req) {
-		otx2_mbox_unlock(&pfvf->mbox);
+		mutex_unlock(&pfvf->mbox.lock);
 		return -ENOMEM;
 	}
 	req->mcam_index = -1; /* Default or reserved index */
@@ -262,7 +262,7 @@ int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 	req->group = DEFAULT_RSS_CONTEXT_GROUP;
 
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
-	otx2_mbox_unlock(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
 	return err;
 }
 
@@ -273,7 +273,7 @@ int otx2_set_rss_table(struct otx2_nic *pfvf)
 	struct nix_aq_enq_req *aq;
 	int idx, err;
 
-	otx2_mbox_lock(mbox);
+	mutex_lock(&mbox->lock);
 	/* Get memory to put this msg */
 	for (idx = 0; idx < rss->rss_size; idx++) {
 		aq = otx2_mbox_alloc_msg_nix_aq_enq(mbox);
@@ -283,12 +283,12 @@ int otx2_set_rss_table(struct otx2_nic *pfvf)
 			 */
 			err = otx2_sync_mbox_msg(mbox);
 			if (err) {
-				otx2_mbox_unlock(mbox);
+				mutex_unlock(&mbox->lock);
 				return err;
 			}
 			aq = otx2_mbox_alloc_msg_nix_aq_enq(mbox);
 			if (!aq) {
-				otx2_mbox_unlock(mbox);
+				mutex_unlock(&mbox->lock);
 				return -ENOMEM;
 			}
 		}
@@ -301,7 +301,7 @@ int otx2_set_rss_table(struct otx2_nic *pfvf)
 		aq->op = NIX_AQ_INSTOP_INIT;
 	}
 	err = otx2_sync_mbox_msg(mbox);
-	otx2_mbox_unlock(mbox);
+	mutex_unlock(&mbox->lock);
 	return err;
 }
 
@@ -556,17 +556,17 @@ int otx2_txschq_stop(struct otx2_nic *pfvf)
 	struct nix_txsch_free_req *free_req;
 	int lvl, schq, err;
 
-	otx2_mbox_lock(&pfvf->mbox);
+	mutex_lock(&pfvf->mbox.lock);
 	/* Free the transmit schedulers */
 	free_req = otx2_mbox_alloc_msg_nix_txsch_free(&pfvf->mbox);
 	if (!free_req) {
-		otx2_mbox_unlock(&pfvf->mbox);
+		mutex_unlock(&pfvf->mbox.lock);
 		return -ENOMEM;
 	}
 
 	free_req->flags = TXSCHQ_FREE_ALL;
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
-	otx2_mbox_unlock(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
 
 	/* Clear the txschq list */
 	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
@@ -1256,10 +1256,10 @@ int otx2_detach_resources(struct mbox *mbox)
 {
 	struct rsrc_detach *detach;
 
-	otx2_mbox_lock(mbox);
+	mutex_lock(&mbox->lock);
 	detach = otx2_mbox_alloc_msg_detach_resources(mbox);
 	if (!detach) {
-		otx2_mbox_unlock(mbox);
+		mutex_unlock(&mbox->lock);
 		return -ENOMEM;
 	}
 
@@ -1268,7 +1268,7 @@ int otx2_detach_resources(struct mbox *mbox)
 
 	/* Send detach request to AF */
 	otx2_mbox_msg_send(&mbox->mbox, 0);
-	otx2_mbox_unlock(mbox);
+	mutex_unlock(&mbox->lock);
 	return 0;
 }
 EXPORT_SYMBOL(otx2_detach_resources);
@@ -1279,11 +1279,11 @@ int otx2_attach_npa_nix(struct otx2_nic *pfvf)
 	struct msg_req *msix;
 	int err;
 
-	otx2_mbox_lock(&pfvf->mbox);
+	mutex_lock(&pfvf->mbox.lock);
 	/* Get memory to put this msg */
 	attach = otx2_mbox_alloc_msg_attach_resources(&pfvf->mbox);
 	if (!attach) {
-		otx2_mbox_unlock(&pfvf->mbox);
+		mutex_unlock(&pfvf->mbox.lock);
 		return -ENOMEM;
 	}
 
@@ -1293,7 +1293,7 @@ int otx2_attach_npa_nix(struct otx2_nic *pfvf)
 	/* Send attach request to AF */
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
 	if (err) {
-		otx2_mbox_unlock(&pfvf->mbox);
+		mutex_unlock(&pfvf->mbox.lock);
 		return err;
 	}
 
@@ -1308,16 +1308,16 @@ int otx2_attach_npa_nix(struct otx2_nic *pfvf)
 	/* Get NPA and NIX MSIX vector offsets */
 	msix = otx2_mbox_alloc_msg_msix_offset(&pfvf->mbox);
 	if (!msix) {
-		otx2_mbox_unlock(&pfvf->mbox);
+		mutex_unlock(&pfvf->mbox.lock);
 		return -ENOMEM;
 	}
 
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
 	if (err) {
-		otx2_mbox_unlock(&pfvf->mbox);
+		mutex_unlock(&pfvf->mbox.lock);
 		return err;
 	}
-	otx2_mbox_unlock(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
 
 	if (pfvf->hw.npa_msixoff == MSIX_VECTOR_INVALID ||
 	    pfvf->hw.nix_msixoff == MSIX_VECTOR_INVALID) {
@@ -1334,7 +1334,7 @@ void otx2_ctx_disable(struct mbox *mbox, int type, bool npa)
 {
 	struct hwctx_disable_req *req;
 
-	otx2_mbox_lock(mbox);
+	mutex_lock(&mbox->lock);
 	/* Request AQ to disable this context */
 	if (npa)
 		req = otx2_mbox_alloc_msg_npa_hwctx_disable(mbox);
@@ -1342,7 +1342,7 @@ void otx2_ctx_disable(struct mbox *mbox, int type, bool npa)
 		req = otx2_mbox_alloc_msg_nix_hwctx_disable(mbox);
 
 	if (!req) {
-		otx2_mbox_unlock(mbox);
+		mutex_unlock(&mbox->lock);
 		return;
 	}
 
@@ -1352,7 +1352,7 @@ void otx2_ctx_disable(struct mbox *mbox, int type, bool npa)
 		dev_err(mbox->pfvf->dev, "%s failed to disable context\n",
 			__func__);
 
-	otx2_mbox_unlock(mbox);
+	mutex_unlock(&mbox->lock);
 }
 
 int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index f51a29c..eaff5f6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -375,21 +375,6 @@ static inline void otx2_sync_mbox_bbuf(struct otx2_mbox *mbox, int devid)
 	       hw_mbase + mbox->rx_start, msg_size + msgs_offset);
 }
 
-static inline void otx2_mbox_lock_init(struct mbox *mbox)
-{
-	mutex_init(&mbox->lock);
-}
-
-static inline void otx2_mbox_lock(struct mbox *mbox)
-{
-	mutex_lock(&mbox->lock);
-}
-
-static inline void otx2_mbox_unlock(struct mbox *mbox)
-{
-	mutex_unlock(&mbox->lock);
-}
-
 /* With the absence of API for 128-bit IO memory access for arm64,
  * implement required operations at place.
  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 4a72738..4618c90 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -98,15 +98,16 @@ static void otx2_flr_handler(struct work_struct *work)
 {
 	struct flr_work *flrwork = container_of(work, struct flr_work, work);
 	struct otx2_nic *pf = flrwork->pf;
+	struct mbox *mbox = &pf->mbox;
 	struct msg_req *req;
 	int vf, reg = 0;
 
 	vf = flrwork - pf->flr_wrk;
 
-	otx2_mbox_lock(&pf->mbox);
-	req = otx2_mbox_alloc_msg_vf_flr(&pf->mbox);
+	mutex_lock(&mbox->lock);
+	req = otx2_mbox_alloc_msg_vf_flr(mbox);
 	if (!req) {
-		otx2_mbox_unlock(&pf->mbox);
+		mutex_unlock(&mbox->lock);
 		return;
 	}
 	req->hdr.pcifunc &= RVU_PFVF_FUNC_MASK;
@@ -122,7 +123,7 @@ static void otx2_flr_handler(struct work_struct *work)
 		otx2_write64(pf, RVU_PF_VFFLR_INT_ENA_W1SX(reg), BIT_ULL(vf));
 	}
 
-	otx2_mbox_unlock(&pf->mbox);
+	mutex_unlock(&mbox->lock);
 }
 
 static irqreturn_t otx2_pf_flr_intr_handler(int irq, void *pf_irq)
@@ -375,7 +376,7 @@ static int otx2_forward_vf_mbox_msgs(struct otx2_nic *pf,
 
 		dst_mdev = &dst_mbox->mbox.dev[0];
 
-		otx2_mbox_lock(&pf->mbox);
+		mutex_lock(&pf->mbox.lock);
 		dst_mdev->mbase = src_mdev->mbase;
 		dst_mdev->msg_size = mbox_hdr->msg_size;
 		dst_mdev->num_msgs = num_msgs;
@@ -385,7 +386,7 @@ static int otx2_forward_vf_mbox_msgs(struct otx2_nic *pf,
 				 "AF not responding to VF%d messages\n", vf);
 			/* restore PF mbase and exit */
 			dst_mdev->mbase = pf->mbox.bbuf_base;
-			otx2_mbox_unlock(&pf->mbox);
+			mutex_unlock(&pf->mbox.lock);
 			return err;
 		}
 		/* At this point, all the VF messages sent to AF are acked
@@ -398,7 +399,7 @@ static int otx2_forward_vf_mbox_msgs(struct otx2_nic *pf,
 
 		otx2_forward_msg_pfvf(dst_mdev, &pf->mbox_pfvf[0].mbox,
 				      pf->mbox.bbuf_base, vf);
-		otx2_mbox_unlock(&pf->mbox);
+		mutex_unlock(&pf->mbox.lock);
 	} else if (dir == MBOX_DIR_PFVF_UP) {
 		src_mdev = &src_mbox->dev[0];
 		mbox_hdr = src_mbox->hwbase + src_mbox->rx_start;
@@ -1050,7 +1051,7 @@ static int otx2_pfaf_mbox_init(struct otx2_nic *pf)
 
 	INIT_WORK(&mbox->mbox_wrk, otx2_pfaf_mbox_handler);
 	INIT_WORK(&mbox->mbox_up_wrk, otx2_pfaf_mbox_up_handler);
-	otx2_mbox_lock_init(&pf->mbox);
+	mutex_init(&mbox->lock);
 
 	return 0;
 exit:
@@ -1063,19 +1064,19 @@ static int otx2_cgx_config_linkevents(struct otx2_nic *pf, bool enable)
 	struct msg_req *msg;
 	int err;
 
-	otx2_mbox_lock(&pf->mbox);
+	mutex_lock(&pf->mbox.lock);
 	if (enable)
 		msg = otx2_mbox_alloc_msg_cgx_start_linkevents(&pf->mbox);
 	else
 		msg = otx2_mbox_alloc_msg_cgx_stop_linkevents(&pf->mbox);
 
 	if (!msg) {
-		otx2_mbox_unlock(&pf->mbox);
+		mutex_unlock(&pf->mbox.lock);
 		return -ENOMEM;
 	}
 
 	err = otx2_sync_mbox_msg(&pf->mbox);
-	otx2_mbox_unlock(&pf->mbox);
+	mutex_unlock(&pf->mbox.lock);
 	return err;
 }
 
@@ -1084,19 +1085,19 @@ static int otx2_cgx_config_loopback(struct otx2_nic *pf, bool enable)
 	struct msg_req *msg;
 	int err;
 
-	otx2_mbox_lock(&pf->mbox);
+	mutex_lock(&pf->mbox.lock);
 	if (enable)
 		msg = otx2_mbox_alloc_msg_cgx_intlbk_enable(&pf->mbox);
 	else
 		msg = otx2_mbox_alloc_msg_cgx_intlbk_disable(&pf->mbox);
 
 	if (!msg) {
-		otx2_mbox_unlock(&pf->mbox);
+		mutex_unlock(&pf->mbox.lock);
 		return -ENOMEM;
 	}
 
 	err = otx2_sync_mbox_msg(&pf->mbox);
-	otx2_mbox_unlock(&pf->mbox);
+	mutex_unlock(&pf->mbox.lock);
 	return err;
 }
 
@@ -1282,7 +1283,7 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 	/* Get the size of receive buffers to allocate */
 	pf->rbsize = RCV_FRAG_LEN(pf->netdev->mtu + OTX2_ETH_HLEN);
 
-	otx2_mbox_lock(mbox);
+	mutex_lock(&mbox->lock);
 	/* NPA init */
 	err = otx2_config_npa(pf);
 	if (err)
@@ -1299,35 +1300,35 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 	/* Init Auras and pools used by NIX RQ, for free buffer ptrs */
 	err = otx2_rq_aura_pool_init(pf);
 	if (err) {
-		otx2_mbox_unlock(mbox);
+		mutex_unlock(&mbox->lock);
 		goto err_free_nix_lf;
 	}
 	/* Init Auras and pools used by NIX SQ, for queueing SQEs */
 	err = otx2_sq_aura_pool_init(pf);
 	if (err) {
-		otx2_mbox_unlock(mbox);
+		mutex_unlock(&mbox->lock);
 		goto err_free_rq_ptrs;
 	}
 
 	err = otx2_txsch_alloc(pf);
 	if (err) {
-		otx2_mbox_unlock(mbox);
+		mutex_unlock(&mbox->lock);
 		goto err_free_sq_ptrs;
 	}
 
 	err = otx2_config_nix_queues(pf);
 	if (err) {
-		otx2_mbox_unlock(mbox);
+		mutex_unlock(&mbox->lock);
 		goto err_free_txsch;
 	}
 	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
 		err = otx2_txschq_config(pf, lvl);
 		if (err) {
-			otx2_mbox_unlock(mbox);
+			mutex_unlock(&mbox->lock);
 			goto err_free_nix_queues;
 		}
 	}
-	otx2_mbox_unlock(mbox);
+	mutex_unlock(&mbox->lock);
 	return err;
 
 err_free_nix_queues:
@@ -1345,7 +1346,7 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 	otx2_ctx_disable(mbox, NPA_AQ_CTYPE_AURA, true);
 	otx2_aura_pool_free(pf);
 err_free_nix_lf:
-	otx2_mbox_lock(mbox);
+	mutex_lock(&mbox->lock);
 	req = otx2_mbox_alloc_msg_nix_lf_free(mbox);
 	if (req) {
 		if (otx2_sync_mbox_msg(mbox))
@@ -1359,7 +1360,7 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 			dev_err(pf->dev, "%s failed to free npalf\n", __func__);
 	}
 exit:
-	otx2_mbox_unlock(mbox);
+	mutex_unlock(&mbox->lock);
 	return err;
 }
 
@@ -1379,11 +1380,11 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 	if (err)
 		dev_err(pf->dev, "RVUPF: Failed to stop/free TX schedulers\n");
 
-	otx2_mbox_lock(mbox);
+	mutex_lock(&mbox->lock);
 	/* Disable backpressure */
 	if (!(pf->pcifunc & RVU_PFVF_FUNC_MASK))
 		otx2_nix_config_bp(pf, false);
-	otx2_mbox_unlock(mbox);
+	mutex_unlock(&mbox->lock);
 
 	/* Disable RQs */
 	otx2_ctx_disable(mbox, NIX_AQ_CTYPE_RQ, false);
@@ -1404,28 +1405,28 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 
 	otx2_free_cq_res(pf);
 
-	otx2_mbox_lock(mbox);
+	mutex_lock(&mbox->lock);
 	/* Reset NIX LF */
 	req = otx2_mbox_alloc_msg_nix_lf_free(mbox);
 	if (req) {
 		if (otx2_sync_mbox_msg(mbox))
 			dev_err(pf->dev, "%s failed to free nixlf\n", __func__);
 	}
-	otx2_mbox_unlock(mbox);
+	mutex_unlock(&mbox->lock);
 
 	/* Disable NPA Pool and Aura hw context */
 	otx2_ctx_disable(mbox, NPA_AQ_CTYPE_POOL, true);
 	otx2_ctx_disable(mbox, NPA_AQ_CTYPE_AURA, true);
 	otx2_aura_pool_free(pf);
 
-	otx2_mbox_lock(mbox);
+	mutex_lock(&mbox->lock);
 	/* Reset NPA LF */
 	req = otx2_mbox_alloc_msg_npa_lf_free(mbox);
 	if (req) {
 		if (otx2_sync_mbox_msg(mbox))
 			dev_err(pf->dev, "%s failed to free npalf\n", __func__);
 	}
-	otx2_mbox_unlock(mbox);
+	mutex_unlock(&mbox->lock);
 }
 
 int otx2_open(struct net_device *netdev)
@@ -1683,10 +1684,10 @@ static void otx2_set_rx_mode(struct net_device *netdev)
 	if (!(netdev->flags & IFF_UP))
 		return;
 
-	otx2_mbox_lock(&pf->mbox);
+	mutex_lock(&pf->mbox.lock);
 	req = otx2_mbox_alloc_msg_nix_set_rx_mode(&pf->mbox);
 	if (!req) {
-		otx2_mbox_unlock(&pf->mbox);
+		mutex_unlock(&pf->mbox.lock);
 		return;
 	}
 
@@ -1699,7 +1700,7 @@ static void otx2_set_rx_mode(struct net_device *netdev)
 		req->mode |= NIX_RX_MODE_ALLMULTI;
 
 	otx2_sync_mbox_msg(&pf->mbox);
-	otx2_mbox_unlock(&pf->mbox);
+	mutex_unlock(&pf->mbox.lock);
 }
 
 static int otx2_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index b4d523a..94044a5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -856,18 +856,18 @@ int otx2_rxtx_enable(struct otx2_nic *pfvf, bool enable)
 	struct msg_req *msg;
 	int err;
 
-	otx2_mbox_lock(&pfvf->mbox);
+	mutex_lock(&pfvf->mbox.lock);
 	if (enable)
 		msg = otx2_mbox_alloc_msg_nix_lf_start_rx(&pfvf->mbox);
 	else
 		msg = otx2_mbox_alloc_msg_nix_lf_stop_rx(&pfvf->mbox);
 
 	if (!msg) {
-		otx2_mbox_unlock(&pfvf->mbox);
+		mutex_unlock(&pfvf->mbox.lock);
 		return -ENOMEM;
 	}
 
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
-	otx2_mbox_unlock(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
 	return err;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index b2727b6..187c633 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -323,7 +323,7 @@ static int otx2vf_vfaf_mbox_init(struct otx2_nic *vf)
 
 	INIT_WORK(&mbox->mbox_wrk, otx2vf_vfaf_mbox_handler);
 	INIT_WORK(&mbox->mbox_up_wrk, otx2vf_vfaf_mbox_up_handler);
-	otx2_mbox_lock_init(&vf->mbox);
+	mutex_init(&mbox->lock);
 
 	return 0;
 exit:
-- 
2.7.4

