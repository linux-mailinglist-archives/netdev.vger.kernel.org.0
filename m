Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C71B4FFAB1
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 17:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfKQQPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 11:15:24 -0500
Received: from mail-pg1-f170.google.com ([209.85.215.170]:39547 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfKQQPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 11:15:23 -0500
Received: by mail-pg1-f170.google.com with SMTP id 29so8380381pgm.6
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 08:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UWNQgulpvns7PFu7wDbpVagOUhFGeP8AePWXF28rIVw=;
        b=iuOAr4QiRhiQ8aAdDncoYqdiyg1cYFOr2O9if9GFi+2c2deCOECVqY42+NUqrPm75L
         A43HDrG5XHNZ5GJrpONMNm4n29tGMul+VkW8HXiw4mq7t+oMJrJO/FQeJmexOCBn7o/0
         DvJjPydCgjka+pDxGyuVZXTlFtIVxSpXxB/SvcmtzCfraNKemRtiQHNqP6tN++kTGwN8
         kcsVpgGY5XPPDA1azTOivzgWIraM7OZJ1ctI6bknx4N0phg92p9RXcRNcc1qAxRujX4S
         /rXJ5WqsStw7CziRzYx9fxjLV4roI4F7gWzfyxRsm0Pk1sRl/dMYtea+5AOvJK9jnggr
         D1Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UWNQgulpvns7PFu7wDbpVagOUhFGeP8AePWXF28rIVw=;
        b=Rf3/IU5J2rNXTC0/QWsk9j34HBOgLpKiS9NTECWD8iOoHz4HyorskU3XxR7aZ/9o4H
         eTht85vI7Q2o2Ok3JgWuYnRlhIYJ6CWKOfDTNM8DSUzaOFhO9GEZwORnvOtehEcTzLhv
         YK5ExkIJZl35ufYG/lA38f2HxBTkdG3XWwcJ5HurQ/kImDezzVTTu+fT78a61vKSFnky
         buL78n1pV5TussOARIGxwiMozzc5J2o5Z0/zOcy7BMWW67gxL/VHEinWqMxVepP+mOk/
         2QS4A+0zYylItjZIOeQR6Dmij8o6oNkazGwu5ftFrXay1EBcn6u8fUxNfM6PvOjNrmgC
         MqZw==
X-Gm-Message-State: APjAAAWNg0LsZtGYFyY2F0Lv1wryDZgyoNVYQKrhXpc6HUC3FyHGTxDj
        mQaTBrH6/Q2TcPxBPfsCldyNesY/ytU=
X-Google-Smtp-Source: APXvYqyM4iRjORs10NbX3TjCXaXCoJx/aWuRMeBvOjEbKl1ZnBTmOLCH3qEOytv+sZWCULonJhA+kg==
X-Received: by 2002:a63:fc09:: with SMTP id j9mr19077037pgi.272.1574007322182;
        Sun, 17 Nov 2019 08:15:22 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v2sm2675231pgi.79.2019.11.17.08.15.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 17 Nov 2019 08:15:21 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Pavan Nikhilesh <pbhagavatula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 09/15] octeontx2-af: Config support for per HWGRP thresholds
Date:   Sun, 17 Nov 2019 21:44:20 +0530
Message-Id: <1574007266-17123-10-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Nikhilesh <pbhagavatula@marvell.com>

Add mbox to support configuring per queue XAQ/TAQ/IAQ thresholds
that helps in prioritizing each HWGRP differently

Also added support to retrieve stats of a given GWS/GGRP by a PF/VF.

Signed-off-by: Pavan Nikhilesh <pbhagavatula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  30 ++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_sso.c    | 101 +++++++++++++++++++++
 2 files changed, 131 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index aa75757..5d199e3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -167,6 +167,9 @@ M(SSO_GRP_SET_PRIORITY,	0x605, sso_grp_set_priority,			\
 M(SSO_GRP_GET_PRIORITY,	0x606, sso_grp_get_priority,			\
 				sso_info_req, sso_grp_priority)	\
 M(SSO_WS_CACHE_INV,	0x607, sso_ws_cache_inv, msg_req, msg_rsp)	\
+M(SSO_GRP_QOS_CONFIG,	0x608, sso_grp_qos_config, sso_grp_qos_cfg, msg_rsp)\
+M(SSO_GRP_GET_STATS,	0x609, sso_grp_get_stats, sso_info_req, sso_grp_stats)\
+M(SSO_HWS_GET_STATS,	0x610, sso_hws_get_stats, sso_info_req, sso_hws_stats)\
 /* TIM mbox IDs (range 0x800 - 0x9FF) */				\
 /* CPT mbox IDs (range 0xA00 - 0xBFF) */				\
 /* NPC mbox IDs (range 0x6000 - 0x7FFF) */				\
@@ -800,6 +803,33 @@ struct ssow_lf_free_req {
 	u16 hws;
 };
 
+struct sso_grp_qos_cfg {
+	struct mbox_msghdr hdr;
+	u16 grp;
+	u32 xaq_limit;
+	u16 taq_thr;
+	u16 iaq_thr;
+};
+
+struct sso_grp_stats {
+	struct mbox_msghdr hdr;
+	u16 grp;
+	u64 ws_pc;
+	u64 ext_pc;
+	u64 wa_pc;
+	u64 ts_pc;
+	u64 ds_pc;
+	u64 dq_pc;
+	u64 aw_status;
+	u64 page_cnt;
+};
+
+struct sso_hws_stats {
+	struct mbox_msghdr hdr;
+	u16 hws;
+	u64 arbitration;
+};
+
 /* NPC mbox message structs */
 
 #define NPC_MCAM_ENTRY_INVALID	0xFFFF
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sso.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sso.c
index cc80cc7..8e0d3df 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sso.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sso.c
@@ -534,6 +534,107 @@ int rvu_mbox_handler_sso_grp_get_priority(struct rvu *rvu,
 	return 0;
 }
 
+int rvu_mbox_handler_sso_grp_qos_config(struct rvu *rvu,
+					struct sso_grp_qos_cfg *req,
+					struct msg_rsp *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
+	u64 regval, grp_rsvd;
+	int lf, blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, pcifunc);
+	if (blkaddr < 0)
+		return SSO_AF_ERR_LF_INVALID;
+
+	lf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, req->grp);
+	if (lf < 0)
+		return SSO_AF_ERR_LF_INVALID;
+
+	/* Check if GGRP has been active. */
+	regval = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_WA_PC(lf));
+	if (regval)
+		return SSO_AF_ERR_GRP_EBUSY;
+
+	/* Configure XAQ threhold */
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_XAQ_LIMIT(lf), req->xaq_limit);
+
+	/* Configure TAQ threhold */
+	regval = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_TAQ_THR(lf));
+	grp_rsvd = regval & SSO_HWGRP_TAQ_RSVD_THR_MASK;
+	if (req->taq_thr < grp_rsvd)
+		req->taq_thr = grp_rsvd;
+
+	regval = req->taq_thr & SSO_HWGRP_TAQ_MAX_THR_MASK;
+	regval = (regval << SSO_HWGRP_TAQ_MAX_THR_SHIFT) | grp_rsvd;
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_TAQ_THR(lf), regval);
+
+	/* Configure IAQ threhold */
+	regval = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_IAQ_THR(lf));
+	grp_rsvd = regval & SSO_HWGRP_IAQ_RSVD_THR_MASK;
+	if (req->iaq_thr < grp_rsvd + 4)
+		req->iaq_thr = grp_rsvd + 4;
+
+	regval = req->iaq_thr & SSO_HWGRP_IAQ_MAX_THR_MASK;
+	regval = (regval << SSO_HWGRP_IAQ_MAX_THR_SHIFT) | grp_rsvd;
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_IAQ_THR(lf), regval);
+
+	return 0;
+}
+
+int rvu_mbox_handler_sso_grp_get_stats(struct rvu *rvu,
+				       struct sso_info_req *req,
+				       struct sso_grp_stats *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
+	int lf, blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, pcifunc);
+	if (blkaddr < 0)
+		return SSO_AF_ERR_LF_INVALID;
+
+	lf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, req->grp);
+	if (lf < 0)
+		return SSO_AF_ERR_LF_INVALID;
+
+	rsp->ws_pc = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_WS_PC(lf));
+	rsp->ext_pc = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_EXT_PC(lf));
+	rsp->wa_pc = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_WA_PC(lf));
+	rsp->ts_pc = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_TS_PC(lf));
+	rsp->ds_pc = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_DS_PC(lf));
+	rsp->dq_pc = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_DQ_PC(lf));
+	rsp->aw_status = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_AW_STATUS(lf));
+	rsp->page_cnt = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_PAGE_CNT(lf));
+
+	return 0;
+}
+
+int rvu_mbox_handler_sso_hws_get_stats(struct rvu *rvu,
+				       struct sso_info_req *req,
+				       struct sso_hws_stats *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
+	int lf, blkaddr, ssow_blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, pcifunc);
+	if (blkaddr < 0)
+		return SSO_AF_ERR_LF_INVALID;
+
+	ssow_blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSOW, pcifunc);
+	if (ssow_blkaddr < 0)
+		return SSO_AF_ERR_LF_INVALID;
+
+	lf = rvu_get_lf(rvu, &hw->block[ssow_blkaddr], pcifunc, req->hws);
+	if (lf < 0)
+		return SSO_AF_ERR_LF_INVALID;
+
+	rsp->arbitration = rvu_read64(rvu, blkaddr, SSO_AF_HWSX_ARB(lf));
+
+	return 0;
+}
+
 int rvu_mbox_handler_sso_lf_alloc(struct rvu *rvu, struct sso_lf_alloc_req *req,
 				  struct sso_lf_alloc_rsp *rsp)
 {
-- 
2.7.4

