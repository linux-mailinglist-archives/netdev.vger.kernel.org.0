Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851EB661F4A
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 08:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbjAIHg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 02:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbjAIHgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 02:36:23 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20788E099
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 23:36:23 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3097Fmrl029366;
        Sun, 8 Jan 2023 23:36:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=OUq4RXH8WxxomjbhnfUIO3yAweeWV56v3VnT/sNRKfg=;
 b=OQAqJyeUYSNIa8uAVpwUTlnZloHzHEjJfTs3UYJ38nSUm2Win2FtWmTrEOamcubvpTTD
 2aGNLLpcHICb/uAbrPneuOfKf6moAyv+9/6BInrdcG/hFY7oTnXY/NSeumv75JgxqA9b
 JEgaJXPbDUVGIBZSI+j/rgK9vbKMoLIPJV700UOm4eVJN1v6JN8RmLiUm07L1bHlyaGf
 dHFsC6+hMb1iMl0HdfntlpLcZ5Zc2lYguBi5SOpeNncwxRZK0o2XWhe6JG1y/INFrCxw
 +o+S6oEoG4Qs2vG3i6iLcTS2vhm3xWV6D44vlhr7fESQypI4xzlob/2uBWLT+VtzE1oY aQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3my6yw3gdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 08 Jan 2023 23:36:13 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sun, 8 Jan
 2023 23:36:11 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Sun, 8 Jan 2023 23:36:11 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 0A0183F7048;
        Sun,  8 Jan 2023 23:36:07 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <jerinj@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        "Dave Kleikamp" <dave.kleikamp@oracle.com>,
        Henry Willard <henry.willard@oracle.com>
Subject: [PATCH net-next,1/9] octeontx2-af: Fix interrupt name strings completely
Date:   Mon, 9 Jan 2023 13:05:55 +0530
Message-ID: <20230109073603.861043-2-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230109073603.861043-1-schalla@marvell.com>
References: <20230109073603.861043-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 8PB7XISXCVx_e4_aasnEXGesAfed3bM8
X-Proofpoint-ORIG-GUID: 8PB7XISXCVx_e4_aasnEXGesAfed3bM8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_02,2023-01-06_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Kleikamp <dave.kleikamp@oracle.com>

The earlier commit: ("octeontx2-af: Fix interrupt name strings") fixed
one instance of a stack address being saved as if it were static.
This patch fixes another instance.

Signed-off-by: Henry Willard <henry.willard@oracle.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 38bbae5d9ae0..33979adb7d02 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -209,7 +209,6 @@ static int cpt_register_interrupts(struct rvu *rvu, int blkaddr)
 	struct rvu_hwinfo *hw = rvu->hw;
 	struct rvu_block *block;
 	int i, offs, ret = 0;
-	char irq_name[16];
 
 	if (!is_block_implemented(rvu->hw, blkaddr))
 		return 0;
@@ -226,10 +225,10 @@ static int cpt_register_interrupts(struct rvu *rvu, int blkaddr)
 		return cpt_10k_register_interrupts(block, offs);
 
 	for (i = CPT_AF_INT_VEC_FLT0; i < CPT_AF_INT_VEC_RVU; i++) {
-		snprintf(irq_name, sizeof(irq_name), "CPTAF FLT%d", i);
+		sprintf(&rvu->irq_name[(offs + i) * NAME_SIZE], "CPTAF FLT%d", i);
 		ret = rvu_cpt_do_register_interrupt(block, offs + i,
 						    rvu_cpt_af_flt_intr_handler,
-						    irq_name);
+						    &rvu->irq_name[(offs + i) * NAME_SIZE]);
 		if (ret)
 			goto err;
 		rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1S(i), 0x1);
-- 
2.25.1

