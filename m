Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405992A9B0
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 14:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfEZMYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 08:24:18 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40646 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727865AbfEZMYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 08:24:16 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4QCLKkK001260;
        Sun, 26 May 2019 05:24:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Je8u5Nwlg+DIiSZukeTPgb8P2kk8Ac1DUk9f4ZnXszE=;
 b=re3agucKn+ziEOyK+8j/j8BqTo0rWt/6kgtmREpmbidlLUB7FijdfoolZ+VoVRkJB4aj
 U5JcGYkzGD37+9dshzj2WerdHfwO74OyFZaznzQuwqThW04XsU0y0ThEGjMVeU2tXNa9
 aQnQFyqv/2Csc3UaiJE9S89Zo9HbQVOqQBzNHDRp+rqZ+bdxpOfL0wIIUEe9EeRAhqF3
 sbJAb8QKR9MjLjVIhlF4iqd/mbSwQ0fua8INGMscZllr6mkhqm8XhCoO0bT/vmWXL1Dz
 eirrQH8AjEO0pfgl7KrdRus2C9ddEvcZxJ0vGelGmj79g9eHCGleqFvnT9RQo5THOytR Zw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2sq57fubtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 26 May 2019 05:24:12 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 26 May
 2019 05:24:10 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Sun, 26 May 2019 05:24:10 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 2714E3F7043;
        Sun, 26 May 2019 05:24:07 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <dledford@redhat.com>, <jgg@ziepe.ca>, <leon@kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        Manish Rangankar <mrangankar@marvell.com>
Subject: [PATCH v2 net-next 09/11] Revert "scsi: qedi: Allocate IRQs based on msix_cnt"
Date:   Sun, 26 May 2019 15:22:28 +0300
Message-ID: <20190526122230.30039-10-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190526122230.30039-1-michal.kalderon@marvell.com>
References: <20190526122230.30039-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-26_08:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manish Rangankar <mrangankar@marvell.com>

 Always request for number of irqs equals to number of queues.

This reverts commit 1a291bce5eaf5374627d337157544aa6499ce34a.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/scsi/qedi/qedi_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index e5db9a9954dc..f07e0814a657 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1336,7 +1336,7 @@ static int qedi_request_msix_irq(struct qedi_ctx *qedi)
 	int i, rc, cpu;
 
 	cpu = cpumask_first(cpu_online_mask);
-	for (i = 0; i < qedi->int_info.msix_cnt; i++) {
+	for (i = 0; i < MIN_NUM_CPUS_MSIX(qedi); i++) {
 		rc = request_irq(qedi->int_info.msix[i].vector,
 				 qedi_msix_handler, 0, "qedi",
 				 &qedi->fp_array[i]);
-- 
2.14.5

