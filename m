Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AA91B2A96
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 17:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbgDUPA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 11:00:59 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44626 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726628AbgDUPA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 11:00:58 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03LEtXcu022739;
        Tue, 21 Apr 2020 08:00:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=hQl+K1HzzMcvR3cx2bjw3hWL6M8WR1UzaMQxeyClR0Y=;
 b=kBiY/imTRTbTqnfy5Bjjis9vtCAu3WIma9avuhaywI2k15iU96EgAdEVOnEJ9/ic6vvj
 lVvfFtdmxby/sSlzz5HNJ18fGFd+I7cKF5MtrnMWksY+l9RzZ4Z6B0I34LUnAknm8JMQ
 /kUKQoSsU5VrVxjU+N7wY+4UabH2iyTFGnA2DF4lZf6/DVPvyZBW3FFVMAHVIirC2GPe
 fO7sQMlDjh9RQVjk7dZJ6lZAadwTWPgY4fegkGYayArunEoD3sV5g8oFIUfhzEMr/2NY
 ptK8zOS2JAdU8PcxCe89cJE6cO60ZABatOqlhx77NAZ4B9VdBG52hjiWn6ZgEeCoiDvc 4Q== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 30fxwpcqx5-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 21 Apr 2020 08:00:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Apr
 2020 07:53:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Apr 2020 07:53:26 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A06AC3F7040;
        Tue, 21 Apr 2020 07:53:26 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 03LErQHx016327;
        Tue, 21 Apr 2020 07:53:26 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 03LErQTd016326;
        Tue, 21 Apr 2020 07:53:26 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net-next 1/3] qed: Enable device error reporting capability.
Date:   Tue, 21 Apr 2020 07:52:58 -0700
Message-ID: <20200421145300.16278-2-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200421145300.16278-1-skalluru@marvell.com>
References: <20200421145300.16278-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_05:2020-04-20,2020-04-21 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch enables the device to send error messages to root port when
an error is detected.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 2c189c6..262b663 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -49,6 +49,7 @@
 #include <linux/qed/qed_if.h>
 #include <linux/qed/qed_ll2_if.h>
 #include <net/devlink.h>
+#include <linux/aer.h>
 
 #include "qed.h"
 #include "qed_sriov.h"
@@ -129,6 +130,8 @@ static void qed_free_pci(struct qed_dev *cdev)
 {
 	struct pci_dev *pdev = cdev->pdev;
 
+	pci_disable_pcie_error_reporting(pdev);
+
 	if (cdev->doorbells && cdev->db_size)
 		iounmap(cdev->doorbells);
 	if (cdev->regview)
@@ -231,6 +234,12 @@ static int qed_init_pci(struct qed_dev *cdev, struct pci_dev *pdev)
 		return -ENOMEM;
 	}
 
+	/* AER (Advanced Error reporting) configuration */
+	rc = pci_enable_pcie_error_reporting(pdev);
+	if (rc)
+		DP_VERBOSE(cdev, NETIF_MSG_DRV,
+			   "Failed to configure PCIe AER [%d]\n", rc);
+
 	return 0;
 
 err2:
-- 
1.8.3.1

