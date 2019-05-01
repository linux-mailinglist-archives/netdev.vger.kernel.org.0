Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6BF106B9
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 11:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfEAJ6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 05:58:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33858 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726428AbfEAJ6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 05:58:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x419tGBc026205;
        Wed, 1 May 2019 02:58:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Je8u5Nwlg+DIiSZukeTPgb8P2kk8Ac1DUk9f4ZnXszE=;
 b=tnesT+JDOgez+FjxoTdu9JTyK6RD2A86qY3X4t3sRv6JlJNzn4LCQmO8A07oGud34CfO
 O+pNrgp8YV561g3mKlDs80RhSY+jOaEUUfuL7oNOqBCNktx0Z2dNcrmGqpLBKkazqCxI
 YKawY/CIMpWQu0KRbTk5ND3n48beoOtW5eudtIsAhuirdhsT07TfZtvxtTR1neKJYQvQ
 x6eZ5ZxEK5DsIXies7XYwDpkxWWrow7SZJs/gcKxdcKEkiGqCGd2iyz1ylvCtPpB9h9m
 cmsamgudPa6v2MklM6YqPc7qDRvV2XYSNW1q6q2wSmLpckgkKk0h4JaIwUWmCBQldLOx Qw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2s6xj61wq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 May 2019 02:58:49 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 1 May
 2019 02:58:48 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Wed, 1 May 2019 02:58:48 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 35DE13F7041;
        Wed,  1 May 2019 02:58:45 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <jgg@ziepe.ca>, <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        Manish Rangankar <mrangankar@marvell.com>
Subject: [PATCH net-next 08/10] Revert "scsi: qedi: Allocate IRQs based on msix_cnt"
Date:   Wed, 1 May 2019 12:57:20 +0300
Message-ID: <20190501095722.6902-9-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501095722.6902-1-michal.kalderon@marvell.com>
References: <20190501095722.6902-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-01_04:,,
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

