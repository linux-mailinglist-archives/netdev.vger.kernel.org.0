Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF5561768F
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 07:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiKCGGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 02:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKCGGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 02:06:20 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2B3192B8;
        Wed,  2 Nov 2022 23:06:18 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A35Jk7l028197;
        Wed, 2 Nov 2022 23:06:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=aUwPKMHMtxeBcSQnf7JFwYu10iJp0Z7AtIcoHeJlaZA=;
 b=DP28xSZ3/UoG+0VaSJtdWzeNL0A0VX8iG272KUXbgoCfcJLznlm5M6vBI5effajt5k72
 Dfp3I5dJ3uJGzZDTsdmDNhIa554gYcoCd6laOr8p/FLQz//PWkB/34ZAfkJawBJceKjU
 FNbDbuUM7l+qsfkdlSd4Lgbbfad9J8nZg0GMM6HT3l3wf3nQGZkLsKYWQyF3TZ/1loVh
 2GBXCJiyUIk6HGOyJfAaDwJNAUvzvOZ/+aj6nqGMm8/lX1RtWK2AhJ+ycNhe9leUJ6ny
 trBgXxH9prurLPkx/CiXCiasODprkINSNSu4IGL+Erm9wFF3YOgSFv4Dy2PRAGo37iR5 EQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3km7da05g3-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 23:06:03 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 2 Nov
 2022 23:06:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 2 Nov 2022 23:06:02 -0700
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 3179A3F70FA;
        Wed,  2 Nov 2022 23:06:02 -0700 (PDT)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>
Subject: [PATCH net-next v4] octeon_ep: support Octeon device CNF95N
Date:   Wed, 2 Nov 2022 23:05:57 -0700
Message-ID: <20221103060600.1858-1-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: pwUKfBp_NGNOlz2YE4KrArP1yccwGy2H
X-Proofpoint-GUID: pwUKfBp_NGNOlz2YE4KrArP1yccwGy2H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
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

update supported device list in Documentation.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
---
V3 -> V4:
  - fix the lines exceeding 80 columns
V2 -> V3:
  - fixed the prefix in subject: "net-next PATCH" to "PATCH net-next".
V1 -> V2:
  - update supported device list in Documentation.

 .../ethernet/marvell/octeon_ep.rst            |  1 +
 .../ethernet/marvell/octeon_ep/octep_main.c   | 20 ++++++++++++++++---
 .../ethernet/marvell/octeon_ep/octep_main.h   |  2 ++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst b/Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst
index bc562c49011b..cad96c8d1f97 100644
--- a/Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst
+++ b/Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst
@@ -23,6 +23,7 @@ Supported Devices
 =================
 Currently, this driver support following devices:
  * Network controller: Cavium, Inc. Device b200
+ * Network controller: Cavium, Inc. Device b400
 
 Interface Control
 =================
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 9089adcb75f9..1cbfa800a8af 100644
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
@@ -939,9 +952,10 @@ int octep_device_setup(struct octep_device *oct)
 
 	switch (oct->chip_id) {
 	case OCTEP_PCI_DEVICE_ID_CN93_PF:
-		dev_info(&pdev->dev,
-			 "Setting up OCTEON CN93XX PF PASS%d.%d\n",
-			 OCTEP_MAJOR_REV(oct), OCTEP_MINOR_REV(oct));
+	case OCTEP_PCI_DEVICE_ID_CNF95N_PF:
+		dev_info(&pdev->dev, "Setting up OCTEON %s PF PASS%d.%d\n",
+			 octep_devid_to_str(oct), OCTEP_MAJOR_REV(oct),
+			 OCTEP_MINOR_REV(oct));
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

base-commit: d3a4706339da26633316357efe7ab9a92ff29b2a
-- 
2.36.0

