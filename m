Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 875E14420D
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391092AbfFMQS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:18:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41750 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731100AbfFMIkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 04:40:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5D8Z3MY021656;
        Thu, 13 Jun 2019 01:39:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=HZxs9upwP+QSeDyP0vHDTRE5ZM1scl8qwAKoetc+Ghk=;
 b=iXE3xxMSnJIWSM9qbRXcAEYmqQQbzZG1kp1aaVY4YQDD0gcnJ/is9RVtU5s1rRN3LwXh
 iP0cU1fah8Bw7zgBCtujUYXXVeu4mC5gKkn5Tsh12CEzSxIbdaTm/La1G23luDdQO2Yt
 X5g02flrdxTodpS7kKvQSVBN+pS6DZfFd5xI8XWOmkUUE0U7fdFYlxTDSjbHl2qCs3od
 30MZaaFV/V8pKju+SLbQ5z11EfqTvS92p+GHkI7uw0yeAYf3lV1gHtjoiVBfQ+Bk0ymG
 ZdOWYEh0ypSqTMdyKQah9fHEH38/s1CBc7HHUjj5xqA9+q12WieVq82WX8XenA9GHzgv Jw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2t3hvpr95n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 01:39:41 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 13 Jun
 2019 01:39:39 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 13 Jun 2019 01:39:39 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id A638F3F7040;
        Thu, 13 Jun 2019 01:39:37 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <jgg@ziepe.ca>, <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 rdma-next 1/3] qed*: Change dpi_addr to be denoted with __iomem
Date:   Thu, 13 Jun 2019 11:38:17 +0300
Message-ID: <20190613083819.6998-2-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190613083819.6998-1-michal.kalderon@marvell.com>
References: <20190613083819.6998-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_05:,,
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
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 6 +++---
 include/linux/qed/qed_rdma_if.h            | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 083c2c00a8e9..3d1f32d56b37 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -813,7 +813,7 @@ static int qedr_init_hw(struct qedr_dev *dev)
 	if (rc)
 		goto out;
 
-	dev->db_addr = (void __iomem *)(uintptr_t)out_params.dpi_addr;
+	dev->db_addr = out_params.dpi_addr;
 	dev->db_phys_addr = out_params.dpi_phys_addr;
 	dev->db_size = out_params.dpi_size;
 	dev->dpi = out_params.dpi;
diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 6175d1e98717..8df56aba9d2c 100644
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
index 7873d6dfd91f..fef3e6979a26 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -799,9 +799,9 @@ static int qed_rdma_add_user(void *rdma_cxt,
 	/* Calculate the corresponding DPI address */
 	dpi_start_offset = p_hwfn->dpi_start_offset;
 
-	out_params->dpi_addr = (u64)((u8 __iomem *)p_hwfn->doorbells +
-				     dpi_start_offset +
-				     ((out_params->dpi) * p_hwfn->dpi_size));
+	out_params->dpi_addr = ((u8 __iomem *)p_hwfn->doorbells +
+				dpi_start_offset +
+				((out_params->dpi) * p_hwfn->dpi_size));
 
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

