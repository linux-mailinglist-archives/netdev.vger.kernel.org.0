Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BADFA3FBB5D
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 20:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238411AbhH3SCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 14:02:04 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31972 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238393AbhH3SCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 14:02:03 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17U9ZKSJ011134;
        Mon, 30 Aug 2021 11:01:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Dc/gfADs6TOv6fTVDSJMJaMuFddFWdfJ3xINhQmQA7A=;
 b=UAa2Jtw0e6+waH7PFvA9bpRnQXZ5p5JENDXpByHMxclWKVsvKbLX3SqrMffB8JO7Z9/w
 bMwoNZVA1abdBa9IMnvkhN4wZNz+UwFLMtZzQMo5rdm6C2+9oFtoThmCIQEU6aqrEfW+
 Yjy+s0kjonFp8MCtpyzRrG+iiMPdvjUBEG3FpYSll9tc5isNjtHqQnBEAMGIIhLB5/Ez
 12hI41tc9gqczstM60sLj+ycL/TQZ4sDRPn1XNiz21GHwooIqD9GNMrxbCFxl0n2YA8i
 QR9yU36ibjUku8hrB2/HwKtxaNkOZXsr3oxGpDNEsUjIojqEWWApCnvFtBEnM9MhWlfp lg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3arj9m3crf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Aug 2021 11:01:06 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 30 Aug
 2021 11:01:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 30 Aug 2021 11:01:04 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 35D573F707D;
        Mon, 30 Aug 2021 11:01:00 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 3/4] octeontx2-af: Fix static code analyzer reported issues
Date:   Mon, 30 Aug 2021 23:30:45 +0530
Message-ID: <1630346446-21609-4-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1630346446-21609-1-git-send-email-sbhatta@marvell.com>
References: <1630346446-21609-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: _TBCu8x5YfLS7i6pjEUdReh_gTl7f_uQ
X-Proofpoint-ORIG-GUID: _TBCu8x5YfLS7i6pjEUdReh_gTl7f_uQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-30_06,2021-08-30_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the static code analyzer reported issues
in rvu_npc.c. The reported errors are different sizes of
operands in bitops and returning uninitialized values.

Fixes: 651cd2652339 ("octeontx2-af: MCAM entry installation support")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 9aeecb8..4d94bd0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -20,7 +20,7 @@
 #define RSVD_MCAM_ENTRIES_PER_NIXLF	1 /* Ucast for LFs */
 
 #define NPC_PARSE_RESULT_DMAC_OFFSET	8
-#define NPC_HW_TSTAMP_OFFSET		8
+#define NPC_HW_TSTAMP_OFFSET		8ULL
 #define NPC_KEX_CHAN_MASK		0xFFFULL
 #define NPC_KEX_PF_FUNC_MASK		0xFFFFULL
 
@@ -2154,7 +2154,7 @@ static void npc_unmap_mcam_entry_and_cntr(struct rvu *rvu,
 					  int blkaddr, u16 entry, u16 cntr)
 {
 	u16 index = entry & (mcam->banksize - 1);
-	u16 bank = npc_get_bank(mcam, entry);
+	u32 bank = npc_get_bank(mcam, entry);
 
 	/* Remove mapping and reduce counter's refcnt */
 	mcam->entry2cntr_map[entry] = NPC_MCAM_INVALID_MAP;
@@ -2777,8 +2777,8 @@ int rvu_mbox_handler_npc_mcam_shift_entry(struct rvu *rvu,
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u16 pcifunc = req->hdr.pcifunc;
 	u16 old_entry, new_entry;
+	int blkaddr, rc = 0;
 	u16 index, cntr;
-	int blkaddr, rc;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0)
-- 
2.7.4

