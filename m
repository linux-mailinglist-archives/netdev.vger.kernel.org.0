Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16BB3F3F2B
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 14:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhHVMDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 08:03:34 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61202 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231580AbhHVMDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 08:03:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17MBLSwO006972;
        Sun, 22 Aug 2021 05:02:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=N9f5GZNAdvDPBo5HgALod4DU3+eTEndHl50kWYAHLEA=;
 b=CeHtboKS+vw4QJ1y+QacgnNRImxnXB66OT2X/0p9osI6XfVCZZJqcMaHcSpu/h6NB143
 c+OGkU0sVCj4FHaMT0sVk1pgtO31RE/ZNGAD8lNf+W00R98eHyNU9dRjhPQdFku8DPo6
 yMSWX///4+xui0g2an5eJLQnI6CozD0zf+Aaf14HV5eL/M+epU71bYQxTZC+SQDY+Gs+
 dRZsC0Zh75mNLAjpg/L0zoO3ZjlZpHyZ7lmL4D8R9ci5htVD6L2o4EQKp+qNDpcG0/iG
 yqXKg4wImCAJzuFSlnDD3nAyVSYm3ed28TyAjGBjD7mrWqCueTR6drz+wDzknNtsA70F Ow== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ak10mtr5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Aug 2021 05:02:47 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Sun, 22 Aug
 2021 05:02:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.23 via Frontend
 Transport; Sun, 22 Aug 2021 05:02:45 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 3486D3F7061;
        Sun, 22 Aug 2021 05:02:43 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [net PATCH 03/10] octeontx2-af: Handle return value in block reset.
Date:   Sun, 22 Aug 2021 17:32:20 +0530
Message-ID: <1629633747-22061-4-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
References: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 65IvyFbS1LE8pKni0e6fBz62OSkYkrbG
X-Proofpoint-ORIG-GUID: 65IvyFbS1LE8pKni0e6fBz62OSkYkrbG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-21_11,2021-08-20_03,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

Print debug message if any of the RVU hardware blocks
reset fails.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 5fe277e..633ba6c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -498,12 +498,15 @@ int rvu_lf_reset(struct rvu *rvu, struct rvu_block *block, int lf)
 static void rvu_block_reset(struct rvu *rvu, int blkaddr, u64 rst_reg)
 {
 	struct rvu_block *block = &rvu->hw->block[blkaddr];
+	int err;
 
 	if (!block->implemented)
 		return;
 
 	rvu_write64(rvu, blkaddr, rst_reg, BIT_ULL(0));
-	rvu_poll_reg(rvu, blkaddr, rst_reg, BIT_ULL(63), true);
+	err = rvu_poll_reg(rvu, blkaddr, rst_reg, BIT_ULL(63), true);
+	if (err)
+		dev_err(rvu->dev, "HW block:%d reset failed\n", blkaddr);
 }
 
 static void rvu_reset_all_blocks(struct rvu *rvu)
-- 
2.7.4

