Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14303F6ED8
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 07:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhHYFgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 01:36:00 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29298 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229457AbhHYFf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 01:35:59 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OISE1S024948;
        Tue, 24 Aug 2021 22:35:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=tclLrg4wF9TWVSPrUW01x6YZcaJfOb5h2YgaX3HNudY=;
 b=XRHxBt2eXyItxFkTIyJDISjxR96q6TYY28ubHYnBpOwjvUli/LTFh1I6QBwQmmPJrKfX
 PHyjxMeqsxwsorWhJGWFEhyTCVE+E6HRCahTDC9VlF2fdsXOlUWtLRsWJHMjBwWMupAk
 x7eWQlyszMSAMkahjO4KIJMQiJrTzpNQB/LvIRrUcWt92cG9JTHSVMmomfYDE2mxCJEz
 +QenuI3wGJfYX1Ek9srlNAF2El9swBSuDyqyLCQsHE/C64OxtfY/LRSJKi9z9Fil12yA
 FpuDbJbetUkKVofP/mX0fLbx9pdNlMfensuDQbykmSlrNcW/n02EmkuZXkdvUZcS2JF0 6w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3an62ksx8n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 22:35:10 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 24 Aug
 2021 22:35:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 24 Aug 2021 22:35:07 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 195E73F7067;
        Tue, 24 Aug 2021 22:35:04 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH] octeontx2-af: cn10k: Set cache lines for NPA batch alloc
Date:   Wed, 25 Aug 2021 11:05:03 +0530
Message-ID: <20210825053503.3506-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: hTgJoQwLcxObUTSQDynq5EMKMXFKvub2
X-Proofpoint-GUID: hTgJoQwLcxObUTSQDynq5EMKMXFKvub2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-25_01,2021-08-25_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set NPA batch allocation engine to process 35 cache lines
per turn on CN10k platform.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h    |  1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c | 11 +++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h |  1 +
 3 files changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index add4a39edced..d8f5e61f0304 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -594,6 +594,7 @@ struct npa_lf_alloc_rsp {
 	u32 stack_pg_ptrs;  /* No of ptrs per stack page */
 	u32 stack_pg_bytes; /* Size of stack page */
 	u16 qints; /* NPA_AF_CONST::QINTS */
+	u8 cache_lines; /*BATCH ALLOC DMA */
 };
 
 /* NPA AQ enqueue msg */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
index 24c2bfdfec4e..f046f2e4256a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
@@ -419,6 +419,10 @@ int rvu_mbox_handler_npa_lf_alloc(struct rvu *rvu,
 	rsp->stack_pg_ptrs = (cfg >> 8) & 0xFF;
 	rsp->stack_pg_bytes = cfg & 0xFF;
 	rsp->qints = (cfg >> 28) & 0xFFF;
+	if (!is_rvu_otx2(rvu)) {
+		cfg = rvu_read64(rvu, block->addr, NPA_AF_BATCH_CTL);
+		rsp->cache_lines = (cfg >> 1) & 0x3F;
+	}
 	return rc;
 }
 
@@ -478,6 +482,13 @@ static int npa_aq_init(struct rvu *rvu, struct rvu_block *block)
 #endif
 	rvu_write64(rvu, block->addr, NPA_AF_NDC_CFG, cfg);
 
+	/* For CN10K NPA BATCH DMA set 35 cache lines */
+	if (!is_rvu_otx2(rvu)) {
+		cfg = rvu_read64(rvu, block->addr, NPA_AF_BATCH_CTL);
+		cfg &= ~0x7EULL;
+		cfg |= BIT_ULL(6) | BIT_ULL(2) | BIT_ULL(1);
+		rvu_write64(rvu, block->addr, NPA_AF_BATCH_CTL, cfg);
+	}
 	/* Result structure can be followed by Aura/Pool context at
 	 * RES + 128bytes and a write mask at RES + 256 bytes, depending on
 	 * operation type. Alloc sufficient result memory for all operations.
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 960ee1c2e178..4600c31b336b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -156,6 +156,7 @@
 #define NPA_AF_AQ_DONE_INT_W1S          (0x0688)
 #define NPA_AF_AQ_DONE_ENA_W1S          (0x0690)
 #define NPA_AF_AQ_DONE_ENA_W1C          (0x0698)
+#define NPA_AF_BATCH_CTL		(0x06a0)
 #define NPA_AF_LFX_AURAS_CFG(a)         (0x4000 | (a) << 18)
 #define NPA_AF_LFX_LOC_AURAS_BASE(a)    (0x4010 | (a) << 18)
 #define NPA_AF_LFX_QINTS_CFG(a)         (0x4100 | (a) << 18)
-- 
2.17.1

