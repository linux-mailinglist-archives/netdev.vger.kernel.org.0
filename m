Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AD01B4610
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 15:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgDVNQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 09:16:19 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54032 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726200AbgDVNQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 09:16:18 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03MDBccH013951;
        Wed, 22 Apr 2020 06:16:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=ltqaSUtvEyt8+VfRNSFL9XR4I6WFkysqPGJl+eMTFkc=;
 b=YIGYRFuCrdMGk2QNg9FClLggIMFadgHc5aYAH3RVpYw5z12bpkJAMFLrKXBCOUaAKo3u
 3hz/AvnhR/vxJvQNKVKZEdOfsdiitTKcu6Arnn+sc8VEf5i0etMnZQLLM6PCuDXSEI0Q
 CwzRXasb86oG34mJlZo/HONNlOelnVHIwCtU1we7/teUQ63PhnMx4ICAq6CuJLnMGRmz
 +sdvxrG72hgAq7AWyvYC2uji84IMtsajlM20rScoFwALO1+zbwYroWf2OupWuv+ZNXvp
 H+JcokAgtm2q3D3MBP0f3tK7w2O1VnusoY0t5WJI5Tr6r4eUK9/fqM90JuvB1yXFBHpF dA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 30jd0126a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Apr 2020 06:16:16 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Apr
 2020 06:16:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Apr
 2020 06:16:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Apr 2020 06:16:14 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7CB0F3F703F;
        Wed, 22 Apr 2020 06:16:13 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 03MDGDhB007303;
        Wed, 22 Apr 2020 06:16:13 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 03MDGDQX007302;
        Wed, 22 Apr 2020 06:16:13 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net-next v2 1/2] qed: Enable device error reporting capability.
Date:   Wed, 22 Apr 2020 06:16:06 -0700
Message-ID: <20200422131607.7262-2-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200422131607.7262-1-skalluru@marvell.com>
References: <20200422131607.7262-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-22_06:2020-04-22,2020-04-22 signatures=0
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
index 96356e8..38a1d26 100644
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

