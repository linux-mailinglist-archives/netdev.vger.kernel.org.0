Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEC061C44
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 11:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbfGHJRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 05:17:14 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3404 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729763AbfGHJRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 05:17:10 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x689GhUm014464;
        Mon, 8 Jul 2019 02:16:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=LTHYzTbxR3HanCEwR0nptnE4msixX4blE2Z0Vo4k310=;
 b=n/pcSYhBVduTx1YLmuZqwj4XfThhHMWPr+puvYKGB7T01odDLlnPFuGaeKwM50etnoHT
 DNHfD4LNYd4UuAusE7Z2TI3mDhkj8r6/Dntq+SSePEhVjOijJpKKoMQbh1RA++BG+BNN
 DZC8NvkMkqh1BfWkIh8Yjtxr9lg1XiXiefUSwhkxo9hsGlPcPgOL+1uSJmS5fmBYARXu
 fMMxrT7uU6KGcs0Wzq5/MgniKDHBCfXPPiTAQzTRZmj3TRG+m3k4KDvKSAcR0fLt7SPG
 uiC9Ww5/VuVPCVsQwtvsqBIjZacQzLnkkiBPdZlMhPf+D/IOIHAPpNVc4GCSzS0fbTbY UA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tju5j6f96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 02:16:51 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 8 Jul
 2019 02:16:49 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 8 Jul 2019 02:16:49 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 408DD3F7041;
        Mon,  8 Jul 2019 02:16:47 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <jgg@ziepe.ca>, <dledford@redhat.com>, <galpress@amazon.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH v5 rdma-next 4/6] qed*: Change dpi_addr to be denoted with __iomem
Date:   Mon, 8 Jul 2019 12:15:01 +0300
Message-ID: <20190708091503.14723-5-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190708091503.14723-1-michal.kalderon@marvell.com>
References: <20190708091503.14723-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_02:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several casts were required around dpi_addr parameter in qed_rdma_if.h
This is an address on the doorbell bar and should therefore be marked
with __iomem.

Reported-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/main.c          | 2 +-
 drivers/infiniband/hw/qedr/qedr.h          | 2 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 5 ++---
 include/linux/qed/qed_rdma_if.h            | 2 +-
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index a0a7ba0a5af4..3db4b6ba5ad6 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -815,7 +815,7 @@ static int qedr_init_hw(struct qedr_dev *dev)
 	if (rc)
 		goto out;
 
-	dev->db_addr = (void __iomem *)(uintptr_t)out_params.dpi_addr;
+	dev->db_addr = out_params.dpi_addr;
 	dev->db_phys_addr = out_params.dpi_phys_addr;
 	dev->db_size = out_params.dpi_size;
 	dev->dpi = out_params.dpi;
diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 97c90d1e525d..7e80ce521d8d 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -227,7 +227,7 @@ struct qedr_ucontext {
 	struct ib_ucontext ibucontext;
 	struct qedr_dev *dev;
 	struct qedr_pd *pd;
-	u64 dpi_addr;
+	void __iomem *dpi_addr;
 	u64 dpi_phys_addr;
 	u32 dpi_size;
 	u16 dpi;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 7873d6dfd91f..fb3fe60a1a68 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -799,9 +799,8 @@ static int qed_rdma_add_user(void *rdma_cxt,
 	/* Calculate the corresponding DPI address */
 	dpi_start_offset = p_hwfn->dpi_start_offset;
 
-	out_params->dpi_addr = (u64)((u8 __iomem *)p_hwfn->doorbells +
-				     dpi_start_offset +
-				     ((out_params->dpi) * p_hwfn->dpi_size));
+	out_params->dpi_addr = p_hwfn->doorbells + dpi_start_offset +
+			       out_params->dpi * p_hwfn->dpi_size;
 
 	out_params->dpi_phys_addr = p_hwfn->cdev->db_phys_addr +
 				    dpi_start_offset +
diff --git a/include/linux/qed/qed_rdma_if.h b/include/linux/qed/qed_rdma_if.h
index d15f8e4815e3..834166809a6c 100644
--- a/include/linux/qed/qed_rdma_if.h
+++ b/include/linux/qed/qed_rdma_if.h
@@ -225,7 +225,7 @@ struct qed_rdma_start_in_params {
 
 struct qed_rdma_add_user_out_params {
 	u16 dpi;
-	u64 dpi_addr;
+	void __iomem *dpi_addr;
 	u64 dpi_phys_addr;
 	u32 dpi_size;
 	u16 wid_count;
-- 
2.14.5

