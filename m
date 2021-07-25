Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58B83D4C9F
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 10:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhGYHT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 03:19:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14332 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230335AbhGYHT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 03:19:29 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16P7qoID011513;
        Sun, 25 Jul 2021 00:59:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=WvmPv3OklfztPa9MD9L/2jLpJK+Tl62is+AwAfjyRac=;
 b=WZeOQ6LNDRyPoSVx6vqRRaBTByOYj4e+oDEEHaf9x8YXEh84s91GS7OuYaS2q7o0g1SM
 L7al8dycBLggzRL6c8jEzBargnwjgr/G9hrOb5WE+fvbymevApAk1X2NXMHF2XaSsnkT
 UyPGI/ib3XfpdvPdPZr9F0ptV5sgXSC6U+6IjPXh9Yax3hg8kN5F3WYpJrt0V2YLcdqj
 W2i2C9zJF3iMyGlIvlOHPF0nRs84PUtiDrWv60mARXoRSesLmlmPBUIrkRbBBLkyn/Lg
 w3HVWT/3vfD/SdZQ42n0sRJutk+gbtOEZsTDA2EsDd5rBwexeRXhBK4JDK8ZRSOLIgxQ cA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a0g7r25u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 25 Jul 2021 00:59:43 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 25 Jul
 2021 00:59:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 25 Jul 2021 00:59:41 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id CE4293F70A4;
        Sun, 25 Jul 2021 00:59:38 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <lcherian@marvell.com>, <tduszynski@marvell.com>,
        <kuba@kernel.org>, <davem@davemloft.net>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>
Subject: [net PATCH] octeontx2-pf: Dont enable backpressure on LBK links
Date:   Sun, 25 Jul 2021 13:29:37 +0530
Message-ID: <20210725075937.6491-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: lBauERlYiil5VX9Bd4U6sSCnJ-nTBM7X
X-Proofpoint-ORIG-GUID: lBauERlYiil5VX9Bd4U6sSCnJ-nTBM7X
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-25_02:2021-07-23,2021-07-25 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

Avoid configure backpressure for LBK links as they
don't support it and enable lmacs before configuration
pause frames.

Fixes: 75f36270990c ("octeontx2-pf: Support to enable/disable pause frames via ethtool")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 14 ++++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 9169849881bf..544c96c8fe1d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1504,8 +1504,8 @@ static int cgx_lmac_init(struct cgx *cgx)
 
 		/* Add reference */
 		cgx->lmac_idmap[lmac->lmac_id] = lmac;
-		cgx->mac_ops->mac_pause_frm_config(cgx, lmac->lmac_id, true);
 		set_bit(lmac->lmac_id, &cgx->lmac_bmap);
+		cgx->mac_ops->mac_pause_frm_config(cgx, lmac->lmac_id, true);
 	}
 
 	return cgx_lmac_verify_fwi_version(cgx);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 7cccd802c4ed..70fcc1fd962f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -924,12 +924,14 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 		aq->cq.drop = RQ_DROP_LVL_CQ(pfvf->hw.rq_skid, cq->cqe_cnt);
 		aq->cq.drop_ena = 1;
 
-		/* Enable receive CQ backpressure */
-		aq->cq.bp_ena = 1;
-		aq->cq.bpid = pfvf->bpid[0];
+		if (!is_otx2_lbkvf(pfvf->pdev)) {
+			/* Enable receive CQ backpressure */
+			aq->cq.bp_ena = 1;
+			aq->cq.bpid = pfvf->bpid[0];
 
-		/* Set backpressure level is same as cq pass level */
-		aq->cq.bp = RQ_PASS_LVL_CQ(pfvf->hw.rq_skid, qset->rqe_cnt);
+			/* Set backpressure level is same as cq pass level */
+			aq->cq.bp = RQ_PASS_LVL_CQ(pfvf->hw.rq_skid, qset->rqe_cnt);
+		}
 	}
 
 	/* Fill AQ info */
@@ -1186,7 +1188,7 @@ static int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
 	aq->aura.fc_hyst_bits = 0; /* Store count on all updates */
 
 	/* Enable backpressure for RQ aura */
-	if (aura_id < pfvf->hw.rqpool_cnt) {
+	if (aura_id < pfvf->hw.rqpool_cnt && !is_otx2_lbkvf(pfvf->pdev)) {
 		aq->aura.bp_ena = 0;
 		aq->aura.nix0_bpid = pfvf->bpid[0];
 		/* Set backpressure level for RQ's Aura */
-- 
2.17.1

