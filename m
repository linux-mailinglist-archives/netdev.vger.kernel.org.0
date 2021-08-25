Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D6C3F74FC
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 14:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241032AbhHYMUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:20:15 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6132 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240829AbhHYMUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:20:00 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17P6evIu015441;
        Wed, 25 Aug 2021 05:19:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ziRyPB+gOD4sl5J7wjagS6O3a1BjYvuqrF9L3FyJ3jA=;
 b=Mx5asF3qjrjofJg/vHW7EwqnNVCPbkb5AZUG+XWj4WOHh3HZSpDH248HZ6uJ5gPB6sKs
 UbnSTMlwiOtamKiDWL4+0Z1Yb9H+SdkLY4SA1kg0sMN24mVkDfqpI9MiWrKj6iTpk4Sp
 Q8CvTH2GXyR4yX4R9012qZxB89wFzRKXpFBF0rPBYfZ9vpZ8HkJNf5AF/qO+mAauYsY1
 PxlKwIoKJBIqf18TJR/90LY0so7+rr4SCh9mViygBqa9RiiCm3wIzeSLlVcXvlJ1Z8Yf
 GtquZx8GOGcYH14jQxe0t/GIkO4SXlBT8KoH5jDPlkYC8SqTDFzGQ5FFqkhXsy8kngl1 aA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3angt017qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 05:19:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 25 Aug
 2021 05:19:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 25 Aug 2021 05:19:12 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id F1DDF3F7067;
        Wed, 25 Aug 2021 05:19:10 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [net-next PATCH 8/9] octeontx2-af: Remove channel verification while installing MCAM rules
Date:   Wed, 25 Aug 2021 17:48:45 +0530
Message-ID: <1629893926-18398-9-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
References: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tMNaXCOr2l23qTJk0ItKZLj-x127Qb-F
X-Proofpoint-GUID: tMNaXCOr2l23qTJk0ItKZLj-x127Qb-F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-25_05,2021-08-25_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New usecases are popping up where in user wants to install common MCAM
filters for all interfaces. Having channel verification will result in
duplicating such MCAM filters for each of the ingress interface. Hence
removed channel verification.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 -
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 49 ----------------------
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |  5 ---
 3 files changed, 55 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index eeb7909..a85d7eb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -784,7 +784,6 @@ bool is_npc_intf_tx(u8 intf);
 bool is_npc_intf_rx(u8 intf);
 bool is_npc_interface_valid(struct rvu *rvu, u8 intf);
 int rvu_npc_get_tx_nibble_cfg(struct rvu *rvu, u64 nibble_ena);
-int npc_mcam_verify_channel(struct rvu *rvu, u16 pcifunc, u8 intf, u16 channel);
 int npc_flow_steering_init(struct rvu *rvu, int blkaddr);
 const char *npc_get_field_name(u8 hdr);
 int npc_get_bank(struct npc_mcam *mcam, int index);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 1ffe8a7..d71fe69 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -85,36 +85,6 @@ static int npc_mcam_verify_pf_func(struct rvu *rvu,
 	return 0;
 }
 
-int npc_mcam_verify_channel(struct rvu *rvu, u16 pcifunc, u8 intf, u16 channel)
-{
-	int pf = rvu_get_pf(pcifunc);
-	u8 cgx_id, lmac_id;
-	int base = 0, end;
-
-	if (is_npc_intf_tx(intf))
-		return 0;
-
-	/* return in case of AF installed rules */
-	if (is_pffunc_af(pcifunc))
-		return 0;
-
-	if (is_afvf(pcifunc)) {
-		end = rvu_get_num_lbk_chans();
-		if (end < 0)
-			return -EINVAL;
-	} else {
-		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-		base = rvu_nix_chan_cgx(rvu, cgx_id, lmac_id, 0x0);
-		/* CGX mapped functions has maximum of 16 channels */
-		end = rvu_nix_chan_cgx(rvu, cgx_id, lmac_id, 0xF);
-	}
-
-	if (channel < base || channel > end)
-		return -EINVAL;
-
-	return 0;
-}
-
 void rvu_npc_set_pkind(struct rvu *rvu, int pkind, struct rvu_pfvf *pfvf)
 {
 	int blkaddr;
@@ -2706,7 +2676,6 @@ int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u16 pcifunc = req->hdr.pcifunc;
-	u16 channel, chan_mask;
 	int blkaddr, rc;
 	u8 nix_intf;
 
@@ -2714,10 +2683,6 @@ int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
 	if (blkaddr < 0)
 		return NPC_MCAM_INVALID_REQ;
 
-	chan_mask = req->entry_data.kw_mask[0] & NPC_KEX_CHAN_MASK;
-	channel = req->entry_data.kw[0] & NPC_KEX_CHAN_MASK;
-	channel &= chan_mask;
-
 	mutex_lock(&mcam->lock);
 	rc = npc_mcam_verify_entry(mcam, pcifunc, req->entry);
 	if (rc)
@@ -2740,12 +2705,6 @@ int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
 		nix_intf = pfvf->nix_rx_intf;
 
 	if (!is_pffunc_af(pcifunc) &&
-	    npc_mcam_verify_channel(rvu, pcifunc, req->intf, channel)) {
-		rc = NPC_MCAM_INVALID_REQ;
-		goto exit;
-	}
-
-	if (!is_pffunc_af(pcifunc) &&
 	    npc_mcam_verify_pf_func(rvu, &req->entry_data, req->intf, pcifunc)) {
 		rc = NPC_MCAM_INVALID_REQ;
 		goto exit;
@@ -3091,7 +3050,6 @@ int rvu_mbox_handler_npc_mcam_alloc_and_write_entry(struct rvu *rvu,
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u16 entry = NPC_MCAM_ENTRY_INVALID;
 	u16 cntr = NPC_MCAM_ENTRY_INVALID;
-	u16 channel, chan_mask;
 	int blkaddr, rc;
 	u8 nix_intf;
 
@@ -3102,13 +3060,6 @@ int rvu_mbox_handler_npc_mcam_alloc_and_write_entry(struct rvu *rvu,
 	if (!is_npc_interface_valid(rvu, req->intf))
 		return NPC_MCAM_INVALID_REQ;
 
-	chan_mask = req->entry_data.kw_mask[0] & NPC_KEX_CHAN_MASK;
-	channel = req->entry_data.kw[0] & NPC_KEX_CHAN_MASK;
-	channel &= chan_mask;
-
-	if (npc_mcam_verify_channel(rvu, req->hdr.pcifunc, req->intf, channel))
-		return NPC_MCAM_INVALID_REQ;
-
 	if (npc_mcam_verify_pf_func(rvu, &req->entry_data, req->intf,
 				    req->hdr.pcifunc))
 		return NPC_MCAM_INVALID_REQ;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 9bde1bb..43874d3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -1173,11 +1173,6 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	if (err)
 		return NPC_FLOW_NOT_SUPPORTED;
 
-	/* Skip channel validation if AF is installing */
-	if (!is_pffunc_af(req->hdr.pcifunc) &&
-	    npc_mcam_verify_channel(rvu, target, req->intf, req->channel))
-		return NPC_FLOW_CHAN_INVALID;
-
 	pfvf = rvu_get_pfvf(rvu, target);
 
 	/* PF installing for its VF */
-- 
2.7.4

