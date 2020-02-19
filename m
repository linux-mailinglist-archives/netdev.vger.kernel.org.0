Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C75B1640CF
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 10:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgBSJv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 04:51:59 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35314 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgBSJv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 04:51:59 -0500
Received: by mail-pf1-f194.google.com with SMTP id i19so963463pfa.2
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 01:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AmJ4Bvcc6f3eiunx+/mE+4GDNQRQlbSmVnOijpA6h0k=;
        b=XOj94PTG+H9kFBQosniOPefpGfSQD4WYp4bjMlJbY3cjWTo2uRoJKVh1bDKCFROTs+
         AvcGigFAFZby0jzZB/+sDC3GzKtgq//I2XAVjWSNjdTjPuZ8eIC9UDAuW0cpc4Xma6bt
         HG9aL9j9W0p38rGxNjdgP3SQEEEUVM9bjCXh/Ay+FCpJUw9XYHuGdE9OU+69qtBh+kp0
         k27d5fAcdAMtGHWNZd0JuyHzsd+r5AglSOOYLP/TAEllJJLkl+wYRycsbr6L/8Rn/mkA
         A5p/CNZ2CKhSvwiZ3lG2l5WnvLSiD/+8s1dvw97KWFBMe/i45bkBkgXQodlAFddhO1Yp
         zmgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AmJ4Bvcc6f3eiunx+/mE+4GDNQRQlbSmVnOijpA6h0k=;
        b=eeez/R7POAEL2qiR35W1ayBVCPWS1L06/g1CbSs3j4bmjoIl7rAkLLYeyoodi3dQYJ
         m8QcW1ySOWYmf/iKy9JJ49r+vgAy+RMDK8YQq32LYpx2A+HHN/iCnXMsSuwlTNpLBWt7
         h9CLm2p2JZ2c71ztkbcVp04EyUnlS+fdHNdosngZ0rfBL9P24ZjVKKwGula4xpfwEqd1
         pZfndbHNoYhd+/T4QAKSwZiopUv5S+J698gTe0tEoTTDCCIpKpCBAnBlF6+l3fmyA8AF
         LY33P+tk5/RmTBiUfcjBWQeLuKpWru7Zi+MzI9pPvJNM96EKGSrMhMwXVyNlQ19kg533
         zsUw==
X-Gm-Message-State: APjAAAX4g7w9cwd24+kODRQUu9IqaRrTf8GRhE3clh7on221B/eFOxDZ
        iscNm4gg2wCmRIBLtL7vmjzbaVgff+Q=
X-Google-Smtp-Source: APXvYqz16QcNdaurgCiE29welstYCo6GXqIebxPbbelBVla40gCyBkM9/iOuGTAKpDiEDoxi/4ZVRg==
X-Received: by 2002:aa7:93a6:: with SMTP id x6mr26309804pff.72.1582105917731;
        Wed, 19 Feb 2020 01:51:57 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id w11sm2023724pgh.5.2020.02.19.01.51.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 19 Feb 2020 01:51:57 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 2/3] octeontx2-af: Cleanup CGX config permission checks
Date:   Wed, 19 Feb 2020 15:21:07 +0530
Message-Id: <1582105868-29012-3-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582105868-29012-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1582105868-29012-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Most of the CGX register config is restricted to mapped RVU PFs,
this patch cleans up these permission checks spread across
the rvu_cgx.c file by moving the checks to a common fn().

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 55 ++++++++++------------
 1 file changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 11e5921..b8e8f33 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -350,6 +350,18 @@ int rvu_cgx_exit(struct rvu *rvu)
 	return 0;
 }
 
+/* Most of the CGX configuration is restricted to the mapped PF only,
+ * VF's of mapped PF and other PFs are not allowed. This fn() checks
+ * whether a PFFUNC is permitted to do the config or not.
+ */
+static bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc)
+{
+	if ((pcifunc & RVU_PFVF_FUNC_MASK) ||
+	    !is_pf_cgxmapped(rvu, rvu_get_pf(pcifunc)))
+		return false;
+	return true;
+}
+
 void rvu_cgx_enadis_rx_bp(struct rvu *rvu, int pf, bool enable)
 {
 	u8 cgx_id, lmac_id;
@@ -373,11 +385,8 @@ int rvu_cgx_config_rxtx(struct rvu *rvu, u16 pcifunc, bool start)
 	int pf = rvu_get_pf(pcifunc);
 	u8 cgx_id, lmac_id;
 
-	/* This msg is expected only from PFs that are mapped to CGX LMACs,
-	 * if received from other PF/VF simply ACK, nothing to do.
-	 */
-	if ((pcifunc & RVU_PFVF_FUNC_MASK) || !is_pf_cgxmapped(rvu, pf))
-		return -ENODEV;
+	if (!is_cgx_config_permitted(rvu, pcifunc))
+		return -EPERM;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
@@ -409,8 +418,7 @@ int rvu_mbox_handler_cgx_stats(struct rvu *rvu, struct msg_req *req,
 	u8 cgx_idx, lmac;
 	void *cgxd;
 
-	if ((req->hdr.pcifunc & RVU_PFVF_FUNC_MASK) ||
-	    !is_pf_cgxmapped(rvu, pf))
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -ENODEV;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_idx, &lmac);
@@ -477,12 +485,8 @@ int rvu_mbox_handler_cgx_promisc_enable(struct rvu *rvu, struct msg_req *req,
 	int pf = rvu_get_pf(pcifunc);
 	u8 cgx_id, lmac_id;
 
-	/* This msg is expected only from PFs that are mapped to CGX LMACs,
-	 * if received from other PF/VF simply ACK, nothing to do.
-	 */
-	if ((req->hdr.pcifunc & RVU_PFVF_FUNC_MASK) ||
-	    !is_pf_cgxmapped(rvu, pf))
-		return -ENODEV;
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
@@ -493,16 +497,11 @@ int rvu_mbox_handler_cgx_promisc_enable(struct rvu *rvu, struct msg_req *req,
 int rvu_mbox_handler_cgx_promisc_disable(struct rvu *rvu, struct msg_req *req,
 					 struct msg_rsp *rsp)
 {
-	u16 pcifunc = req->hdr.pcifunc;
-	int pf = rvu_get_pf(pcifunc);
+	int pf = rvu_get_pf(req->hdr.pcifunc);
 	u8 cgx_id, lmac_id;
 
-	/* This msg is expected only from PFs that are mapped to CGX LMACs,
-	 * if received from other PF/VF simply ACK, nothing to do.
-	 */
-	if ((req->hdr.pcifunc & RVU_PFVF_FUNC_MASK) ||
-	    !is_pf_cgxmapped(rvu, pf))
-		return -ENODEV;
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
@@ -515,11 +514,8 @@ static int rvu_cgx_config_linkevents(struct rvu *rvu, u16 pcifunc, bool en)
 	int pf = rvu_get_pf(pcifunc);
 	u8 cgx_id, lmac_id;
 
-	/* This msg is expected only from PFs that are mapped to CGX LMACs,
-	 * if received from other PF/VF simply ACK, nothing to do.
-	 */
-	if ((pcifunc & RVU_PFVF_FUNC_MASK) || !is_pf_cgxmapped(rvu, pf))
-		return -ENODEV;
+	if (!is_cgx_config_permitted(rvu, pcifunc))
+		return -EPERM;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
@@ -571,11 +567,8 @@ static int rvu_cgx_config_intlbk(struct rvu *rvu, u16 pcifunc, bool en)
 	int pf = rvu_get_pf(pcifunc);
 	u8 cgx_id, lmac_id;
 
-	/* This msg is expected only from PFs that are mapped to CGX LMACs,
-	 * if received from other PF/VF simply ACK, nothing to do.
-	 */
-	if ((pcifunc & RVU_PFVF_FUNC_MASK) || !is_pf_cgxmapped(rvu, pf))
-		return -ENODEV;
+	if (!is_cgx_config_permitted(rvu, pcifunc))
+		return -EPERM;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
-- 
2.7.4

