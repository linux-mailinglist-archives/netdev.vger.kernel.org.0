Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDA433D0C0
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbhCPJ1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:27:50 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2820 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233002AbhCPJ1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:27:32 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G9QRwd020155;
        Tue, 16 Mar 2021 02:27:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=f4wDCsbXH4YETe98HxKm64cvWck1J8s5Dvrag+7DKjA=;
 b=E0kJUM+74L3ty01+7izuBXkpS3QocxvR2BLVC4WNkrrMirrFilw3KDW54llMx3k6emwk
 +ShixQvkwFQ0PpNcv/JHF8XV/WWQblrJyFIGw32C4vz/xMzLTok+4rt0NGmj15b0zJrF
 Xfla6z+chjcL/8sjoox58CTsBcy3Zla99yFVj3OAkTISNbbCyxthV+dpfNV+2e86wd9u
 UGQIUPrFwZMqljllkq04uzRan+UWLT27XOyJoqWj7Z7nhU48Bkk485Ne23iyq12LtupX
 MUT/dbz2pSDaZsFzlCzF4qaGE8dg9HkusKm9oVVbO+2No9MMeaiYJ0/0fVOExy9fLSz9 IQ== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0a-0016f401.pphosted.com with ESMTP id 378umtfrbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 02:27:30 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Mar 2021 05:27:28 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Mar 2021 05:27:28 -0400
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id 09EB33F7040;
        Tue, 16 Mar 2021 02:27:24 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 3/9] octeontx2-af: Do not allocate memory for devlink private
Date:   Tue, 16 Mar 2021 14:57:07 +0530
Message-ID: <1615886833-71688-4-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
References: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_03:2021-03-15,2021-03-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Memory for driver private structure rvu_devlink is
also allocated during devlink_alloc. Hence use
the allocated memory by devlink_alloc and access it
by devlink_priv call.

Fixes: fae06da4("octeontx2-af: Add devlink suppoort to af driver")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 10a98bc..d88ac90 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1380,14 +1380,9 @@ int rvu_register_dl(struct rvu *rvu)
 	struct devlink *dl;
 	int err;
 
-	rvu_dl = kzalloc(sizeof(*rvu_dl), GFP_KERNEL);
-	if (!rvu_dl)
-		return -ENOMEM;
-
 	dl = devlink_alloc(&rvu_devlink_ops, sizeof(struct rvu_devlink));
 	if (!dl) {
 		dev_warn(rvu->dev, "devlink_alloc failed\n");
-		kfree(rvu_dl);
 		return -ENOMEM;
 	}
 
@@ -1395,10 +1390,10 @@ int rvu_register_dl(struct rvu *rvu)
 	if (err) {
 		dev_err(rvu->dev, "devlink register failed with error %d\n", err);
 		devlink_free(dl);
-		kfree(rvu_dl);
 		return err;
 	}
 
+	rvu_dl = devlink_priv(dl);
 	rvu_dl->dl = dl;
 	rvu_dl->rvu = rvu;
 	rvu->rvu_dl = rvu_dl;
-- 
2.7.4

