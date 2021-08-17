Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F361E3EE5C6
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhHQEpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:45:49 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29406 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233902AbhHQEpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 00:45:44 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2ldd5006756;
        Mon, 16 Aug 2021 21:45:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=UZQySyz5d1Cv3gJraOhAHUxLGGkSRvq1vzxFky8Y9LU=;
 b=eVUOWcVc6z1jiAQfkazWDVxpL/kw1exQOnSkuByExZF4zzk4R9A7G+a5sx5lvbgl+QMg
 nqhE2IHxdi6J/c6oLyjeWzgpS7tqsfpHZxPXXD9cb0yhwZIrk1IcoFUzxbq3VxapOEKn
 cpiFpLwkHdTceVjwrqfaSBm9LdTDF9Z8eTC1Qf+tqCL05s1/rRDNC+9PrLJhKo7602fO
 DxFNM3uNfvYmQYMr/S9S+RWgPUl+/aNhA9AGljK4BUeurFKn9DkrzMEocO1g/MOrX+cH
 IAdZxrNPcc9JAx3JYZzmELRJLvIDts2/0vQ/aAXbVcg8nPIepH/IKNZMuP1vfv+MFn1P gg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0ra4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 21:45:11 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 21:45:09 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 21:45:09 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id D88E53F70A9;
        Mon, 16 Aug 2021 21:45:05 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 03/11] octeontx2-af: Add debug messages for failures
Date:   Tue, 17 Aug 2021 10:14:45 +0530
Message-ID: <1629175493-4895-4-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
References: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: ezelSufvXe7pbOhhKxJBbWcC5F3xOFmn
X-Proofpoint-ORIG-GUID: ezelSufvXe7pbOhhKxJBbWcC5F3xOFmn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Added debug messages for various failures during probe.
This will help in quickly identifying the API where the failure
is happening.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 92 ++++++++++++++++++++-----
 1 file changed, 73 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 5fe277e..fb50df9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -924,16 +924,26 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 	block->lfreset_reg = NPA_AF_LF_RST;
 	sprintf(block->name, "NPA");
 	err = rvu_alloc_bitmap(&block->lf);
-	if (err)
+	if (err) {
+		dev_err(rvu->dev,
+			"%s: Failed to allocate NPA LF bitmap\n", __func__);
 		return err;
+	}
 
 nix:
 	err = rvu_setup_nix_hw_resource(rvu, BLKADDR_NIX0);
-	if (err)
+	if (err) {
+		dev_err(rvu->dev,
+			"%s: Failed to allocate NIX0 LFs bitmap\n", __func__);
 		return err;
+	}
+
 	err = rvu_setup_nix_hw_resource(rvu, BLKADDR_NIX1);
-	if (err)
+	if (err) {
+		dev_err(rvu->dev,
+			"%s: Failed to allocate NIX1 LFs bitmap\n", __func__);
 		return err;
+	}
 
 	/* Init SSO group's bitmap */
 	block = &hw->block[BLKADDR_SSO];
@@ -953,8 +963,11 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 	block->lfreset_reg = SSO_AF_LF_HWGRP_RST;
 	sprintf(block->name, "SSO GROUP");
 	err = rvu_alloc_bitmap(&block->lf);
-	if (err)
+	if (err) {
+		dev_err(rvu->dev,
+			"%s: Failed to allocate SSO LF bitmap\n", __func__);
 		return err;
+	}
 
 ssow:
 	/* Init SSO workslot's bitmap */
@@ -974,8 +987,11 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 	block->lfreset_reg = SSOW_AF_LF_HWS_RST;
 	sprintf(block->name, "SSOWS");
 	err = rvu_alloc_bitmap(&block->lf);
-	if (err)
+	if (err) {
+		dev_err(rvu->dev,
+			"%s: Failed to allocate SSOW LF bitmap\n", __func__);
 		return err;
+	}
 
 tim:
 	/* Init TIM LF's bitmap */
@@ -996,35 +1012,55 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 	block->lfreset_reg = TIM_AF_LF_RST;
 	sprintf(block->name, "TIM");
 	err = rvu_alloc_bitmap(&block->lf);
-	if (err)
+	if (err) {
+		dev_err(rvu->dev,
+			"%s: Failed to allocate TIM LF bitmap\n", __func__);
 		return err;
+	}
 
 cpt:
 	err = rvu_setup_cpt_hw_resource(rvu, BLKADDR_CPT0);
-	if (err)
+	if (err) {
+		dev_err(rvu->dev,
+			"%s: Failed to allocate CPT0 LF bitmap\n", __func__);
 		return err;
+	}
 	err = rvu_setup_cpt_hw_resource(rvu, BLKADDR_CPT1);
+	if (err) {
+		dev_err(rvu->dev,
+			"%s: Failed to allocate CPT1 LF bitmap\n", __func__);
+		return err;
+	}
 	if (err)
 		return err;
 
 	/* Allocate memory for PFVF data */
 	rvu->pf = devm_kcalloc(rvu->dev, hw->total_pfs,
 			       sizeof(struct rvu_pfvf), GFP_KERNEL);
-	if (!rvu->pf)
+	if (!rvu->pf) {
+		dev_err(rvu->dev,
+			"%s: Failed to allocate memory for PF's rvu_pfvf struct\n", __func__);
 		return -ENOMEM;
+	}
 
 	rvu->hwvf = devm_kcalloc(rvu->dev, hw->total_vfs,
 				 sizeof(struct rvu_pfvf), GFP_KERNEL);
-	if (!rvu->hwvf)
+	if (!rvu->hwvf) {
+		dev_err(rvu->dev,
+			"%s: Failed to allocate memory for VF's rvu_pfvf struct\n", __func__);
 		return -ENOMEM;
+	}
 
 	mutex_init(&rvu->rsrc_lock);
 
 	rvu_fwdata_init(rvu);
 
 	err = rvu_setup_msix_resources(rvu);
-	if (err)
+	if (err) {
+		dev_err(rvu->dev,
+			"%s: Failed to setup MSIX resources\n", __func__);
 		return err;
+	}
 
 	for (blkid = 0; blkid < BLK_COUNT; blkid++) {
 		block = &hw->block[blkid];
@@ -1050,25 +1086,33 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 		goto msix_err;
 
 	err = rvu_npc_init(rvu);
-	if (err)
+	if (err) {
+		dev_err(rvu->dev, "%s: Failed to initialize npc\n", __func__);
 		goto npc_err;
+	}
 
 	err = rvu_cgx_init(rvu);
-	if (err)
+	if (err) {
+		dev_err(rvu->dev, "%s: Failed to initialize cgx\n", __func__);
 		goto cgx_err;
+	}
 
 	/* Assign MACs for CGX mapped functions */
 	rvu_setup_pfvf_macaddress(rvu);
 
 	err = rvu_npa_init(rvu);
-	if (err)
+	if (err) {
+		dev_err(rvu->dev, "%s: Failed to initialize npa\n", __func__);
 		goto npa_err;
+	}
 
 	rvu_get_lbk_bufsize(rvu);
 
 	err = rvu_nix_init(rvu);
-	if (err)
+	if (err) {
+		dev_err(rvu->dev, "%s: Failed to initialize nix\n", __func__);
 		goto nix_err;
+	}
 
 	rvu_program_channels(rvu);
 
@@ -2984,27 +3028,37 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = rvu_mbox_init(rvu, &rvu->afpf_wq_info, TYPE_AFPF,
 			    rvu->hw->total_pfs, rvu_afpf_mbox_handler,
 			    rvu_afpf_mbox_up_handler);
-	if (err)
+	if (err) {
+		dev_err(dev, "%s: Failed to initialize mbox\n", __func__);
 		goto err_hwsetup;
+	}
 
 	err = rvu_flr_init(rvu);
-	if (err)
+	if (err) {
+		dev_err(dev, "%s: Failed to initialize flr\n", __func__);
 		goto err_mbox;
+	}
 
 	err = rvu_register_interrupts(rvu);
-	if (err)
+	if (err) {
+		dev_err(dev, "%s: Failed to register interrupts\n", __func__);
 		goto err_flr;
+	}
 
 	err = rvu_register_dl(rvu);
-	if (err)
+	if (err) {
+		dev_err(dev, "%s: Failed to register devlink\n", __func__);
 		goto err_irq;
+	}
 
 	rvu_setup_rvum_blk_revid(rvu);
 
 	/* Enable AF's VFs (if any) */
 	err = rvu_enable_sriov(rvu);
-	if (err)
+	if (err) {
+		dev_err(dev, "%s: Failed to enable sriov\n", __func__);
 		goto err_dl;
+	}
 
 	/* Initialize debugfs */
 	rvu_dbg_init(rvu);
-- 
2.7.4

