Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00D4B74C61
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 13:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391478AbfGYLBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 07:01:30 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:15326 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388173AbfGYLBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 07:01:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6PB0Va1001004;
        Thu, 25 Jul 2019 04:01:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=FwURqODJkvM0zrIWS14p96nNulMX0DwXr9XftxeSKvY=;
 b=sXC8gI9wiGChr7M3LlM6SiQBShiMP/NSh5vekjFnxwD/UGROZny78D5Fx8hnMqI25fKn
 /dUr7W+Wya/a5jWOQzQlP27tuozvURFTFC0lydMIgeaSus7GeOhBj5nra8Ml6oYCRqxk
 tpNRhwmQcRaKem6zI8pDPVtzsNNhg5KSXnU4GNo8oyOvZRsmYu/npkFXMjdRYyXMMj//
 9dYYficr0usYAbGW12LuEY4vRiTATAY3k/JYV+HHIAnJpdVcbu56+ekBMIjvwh98/H9V
 6KBCGI3VIzwKJPMoVPH79M+DOIgHJ2ruVqI1qeqycRIVF3WfbEqAKryF2QNmYsQCLrks QQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tx61rh4h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 25 Jul 2019 04:01:28 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 25 Jul
 2019 04:01:27 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 25 Jul 2019 04:01:27 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 2BB333F703F;
        Thu, 25 Jul 2019 04:01:25 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH] qed: RDMA - Fix the hw_ver returned in device attributes
Date:   Thu, 25 Jul 2019 13:59:55 +0300
Message-ID: <20190725105955.12492-1-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-25_04:2019-07-25,2019-07-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hw_ver field was initialized to zero. Return the chip revision.
This is relevant for rdma driver.

Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index f900fde448db..7110cae384ee 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -442,7 +442,7 @@ static void qed_rdma_init_devinfo(struct qed_hwfn *p_hwfn,
 	/* Vendor specific information */
 	dev->vendor_id = cdev->vendor_id;
 	dev->vendor_part_id = cdev->device_id;
-	dev->hw_ver = 0;
+	dev->hw_ver = cdev->chip_rev;
 	dev->fw_ver = (FW_MAJOR_VERSION << 24) | (FW_MINOR_VERSION << 16) |
 		      (FW_REVISION_VERSION << 8) | (FW_ENGINEERING_VERSION);
 
-- 
2.14.5

