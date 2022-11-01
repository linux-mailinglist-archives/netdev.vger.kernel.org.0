Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CAB614E71
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 16:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiKAPf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 11:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiKAPf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 11:35:57 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EB618B35;
        Tue,  1 Nov 2022 08:35:56 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A1Eh09W023397;
        Tue, 1 Nov 2022 08:35:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=75Fikn0ell3K3XFW9rWytIYn3Zx5mPG/Nu172ngiwog=;
 b=FJHvoI5jX9r3xCsFxlZJtR4ctdUwTHZl2IlOkFErGspz+7fqkrwiDyWj3dGMQ1PINoFE
 MBGTjPdGdTKquqZ9QZEWdYcgKs5opm6aFxXyWkPI8Fb9sdefjlzxW6dijF2IkrhiImLy
 xj4ip3Gw4H3ltoLw1ogRHtgIiF+gdhDTtwr+6t5UCoeERgbeZ2+HA6S1fkVwT9p945Ih
 8x2JgvXacG2r/4umAfTMFW4dd+D1WQqBoVPY4dcuTlFSUFsHsGY55qJ0XUqCaJsc9kq8
 Wd5ee8D8it4L7e6ord5X3iKSHCJs1zp3PCDybNPFtbdV9f67NnfXq9jeq9AfRescGNXB Wg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kk5f8r8j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 01 Nov 2022 08:35:44 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Nov
 2022 08:35:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 1 Nov 2022 08:35:42 -0700
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 72DD93F7053;
        Tue,  1 Nov 2022 08:35:42 -0700 (PDT)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] octeon_ep: support Octeon device CNF95N
Date:   Tue, 1 Nov 2022 08:35:39 -0700
Message-ID: <20221101153539.22630-1-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: XJM2dSwErgz-aoz6nJGjYg14RfyixfIT
X-Proofpoint-ORIG-GUID: XJM2dSwErgz-aoz6nJGjYg14RfyixfIT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-01_07,2022-11-01_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Octeon device CNF95N.
CNF95N is a Octeon Fusion family product with same PCI NIC
characteristics as CN93 which is currently supported by the driver.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
---
 .../ethernet/marvell/octeon_ep/octep_main.c   | 19 ++++++++++++++++---
 .../ethernet/marvell/octeon_ep/octep_main.h   |  2 ++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 9089adcb75f9..e956c1059fc8 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -23,6 +23,7 @@ struct workqueue_struct *octep_wq;
 /* Supported Devices */
 static const struct pci_device_id octep_pci_id_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, OCTEP_PCI_DEVICE_ID_CN93_PF)},
+	{PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, OCTEP_PCI_DEVICE_ID_CNF95N_PF)},
 	{0, },
 };
 MODULE_DEVICE_TABLE(pci, octep_pci_id_tbl);
@@ -907,6 +908,18 @@ static void octep_ctrl_mbox_task(struct work_struct *work)
 	}
 }
 
+static const char *octep_devid_to_str(struct octep_device *oct)
+{
+	switch (oct->chip_id) {
+	case OCTEP_PCI_DEVICE_ID_CN93_PF:
+		return "CN93XX";
+	case OCTEP_PCI_DEVICE_ID_CNF95N_PF:
+		return "CNF95N";
+	default:
+		return "Unsupported";
+	}
+}
+
 /**
  * octep_device_setup() - Setup Octeon Device.
  *
@@ -939,9 +952,9 @@ int octep_device_setup(struct octep_device *oct)
 
 	switch (oct->chip_id) {
 	case OCTEP_PCI_DEVICE_ID_CN93_PF:
-		dev_info(&pdev->dev,
-			 "Setting up OCTEON CN93XX PF PASS%d.%d\n",
-			 OCTEP_MAJOR_REV(oct), OCTEP_MINOR_REV(oct));
+	case OCTEP_PCI_DEVICE_ID_CNF95N_PF:
+		dev_info(&pdev->dev, "Setting up OCTEON %s PF PASS%d.%d\n",
+			 octep_devid_to_str(oct), OCTEP_MAJOR_REV(oct), OCTEP_MINOR_REV(oct));
 		octep_device_setup_cn93_pf(oct);
 		break;
 	default:
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
index 025626a61383..123ffc13754d 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
@@ -21,6 +21,8 @@
 #define  OCTEP_PCI_DEVICE_ID_CN93_PF 0xB200
 #define  OCTEP_PCI_DEVICE_ID_CN93_VF 0xB203
 
+#define  OCTEP_PCI_DEVICE_ID_CNF95N_PF 0xB400    //95N PF
+
 #define  OCTEP_MAX_QUEUES   63
 #define  OCTEP_MAX_IQ       OCTEP_MAX_QUEUES
 #define  OCTEP_MAX_OQ       OCTEP_MAX_QUEUES
-- 
2.36.0

