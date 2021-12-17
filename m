Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4671847899F
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 12:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbhLQLQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 06:16:41 -0500
Received: from mail-dm6nam11on2044.outbound.protection.outlook.com ([40.107.223.44]:43425
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232235AbhLQLQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 06:16:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJrpF/+U34p1uHFRKIX2nUYWAYU/9yMlsRJk9b4cb8O91pzb/jmA9FwR1ZZeO+qVefuhRgxtt2l/G4cYy/17J7lJjjAkeh0dpAUbna5XRW19jBjGOeyJFm1w9UGhW5dPVufCzmvYZChs1+U0Pdy2xem0kQEfTOGzPQMmlE21/9AGcg0A16hHeBcjFaSk2vpRE01020ti0iGTdgYrMNUpQBVv5a+2fwCwkkKac5448Q1p0w3sGa6QnxsAL4Ob+4+VZRtGXluCoZ/xBK09JNEG8BIPhcyurRYvfa2xLZXvz5BzQA37+/ZhI/Gujqko6u+xBHOPouNw1BG1SOg0gFidTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4t6Ivx/GRkAZR0vTGo5BCG3JQUkXdcG7yp7N5g5N0eA=;
 b=MSFvTtXcNx50f8Y+R6AXwSLFG1OkAJDzVArNuGo2EZClVJ5RMtIC1HTdskUVMZK0xajnp24xYYKGVwCqnb96sCrk0R8+ARaKj/FtxP1sHw57VAKG8nXF4QIAFgbJ/0w//c9l9soL2XMciS8+4LI5f0gC+5qd+9VLasCa0AeUfegT17SdUISScMl0GN+lGbb1bleNb3IuWt962AVhGKRoDCvn8oTWba82wfaDGM7M2kYn9vCk2F5m/SGbjZ0sKuz0sikBkdITNP60phvFo/rBLWMLorC4ROtbj9T0gVmikwdUlg4V8eONqo7Oma0qhDGk4BTtqnPkgjBKe/bl7xdjyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4t6Ivx/GRkAZR0vTGo5BCG3JQUkXdcG7yp7N5g5N0eA=;
 b=hWtt24dmTukhpAiy4nAfdsIr69VME10Z4tX6iPp6l56D3sL6NcNczT72oiy5c7eQj0twqYpkp0Ov8QRR8gVcswjXiauOwp0IW5574hnx7qSNrmQeuGQViasRAs7vO7eDeRtIFrug7FOzDGUNiJ0P+pNzzBks0wjFN9+3m1B0kts=
Received: from DM6PR08CA0060.namprd08.prod.outlook.com (2603:10b6:5:1e0::34)
 by BYAPR12MB3512.namprd12.prod.outlook.com (2603:10b6:a03:134::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 11:16:38 +0000
Received: from DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::b8) by DM6PR08CA0060.outlook.office365.com
 (2603:10b6:5:1e0::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17 via Frontend
 Transport; Fri, 17 Dec 2021 11:16:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT065.mail.protection.outlook.com (10.13.172.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4801.14 via Frontend Transport; Fri, 17 Dec 2021 11:16:38 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 17 Dec
 2021 05:16:35 -0600
From:   Raju Rangoju <rrangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Shyam-sundar.S-k@amd.com>,
        <Sudheesh.Mavila@amd.com>, <Raju.Rangoju@amd.com>
Subject: [PATCH net-next 1/3] net: amd-xgbe: Add Support for Yellow Carp Ethernet device
Date:   Fri, 17 Dec 2021 16:45:55 +0530
Message-ID: <20211217111557.1099919-2-rrangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211217111557.1099919-1-rrangoju@amd.com>
References: <20211217111557.1099919-1-rrangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a52c4ae-0c4a-417a-9683-08d9c14eb1a3
X-MS-TrafficTypeDiagnostic: BYAPR12MB3512:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3512AD51CD3ED1044044030995789@BYAPR12MB3512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EibF5A3Yf3jZbV35jTrzlI7Qy6RQiVrWQ2WmFHlkV5TC4wC4Dm3UXelCCZTw4Kpf0px29g40cZUlKRh68R1elMqOPYewzr0bQhoZoSLImkbI+mVwLKayuS4GVB/h5ildeAXtxR3dk38gxF9OjLMGxUIJmgT2QPGJxxWVLV0wNBDa/LnwqofsUCmQFsEG3l7sCNff6ZAEdopaeN51GGlpbKKr3LUvEuMx6RYAjpyRG+kmnW94++zR4H1DzWKe1EjyNZdYA+6ptKY2sL4ir2kY8qoATAbdBdFC3oX/1n/4AKCiHL/GjGWzfSEo/hMB6rUA1sDLCrpx1KdYQ26hS7mBVgZHjZjLokLcqpqg4f7MiAfJ8gaQIOAiXBN12EDn29pbICLRbZTJhsBY9+u9R6gJnG/S9sVCcM7+4KLABGrcuTqKPrv+599zfkMqpGbn/zExX6gtFtpSpH/NRpesJevxVQJeS5GseyvqZfbjn9mcKsaH0exQtMb1H5IyAyEdJEsTTqWWgGxeejyzJh6Dx5gNCeOEOeLh48a96vmZOzHVBuZymu0hUw4d/MwVJ8S9Y8nA6eElRSGSa1iQezFhHEUw+tikQ/F+LiNkgDbczFfmyBysn6AhB5LGWJ6MwS+2bwPTatyEn2J1dAY+RLT4/mc7CFOz0WC2NyTIrEr5W8Id7DwcOt8KNSy4GZ4spEA1cf47334jGL4hYdxpC0lfIT03JSmkfWm/CQ5rpCrCCXgZHcXMnCsysNlu9+rqkMU6M0Fi7xXsnbI89kufUPVIgD+MlFENIDhp6MeUJwe41FYQidY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(4326008)(81166007)(356005)(83380400001)(508600001)(6666004)(1076003)(426003)(316002)(336012)(8676002)(186003)(36756003)(16526019)(36860700001)(2616005)(2906002)(70586007)(70206006)(47076005)(5660300002)(54906003)(110136005)(26005)(40460700001)(7696005)(8936002)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 11:16:38.0596
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a52c4ae-0c4a-417a-9683-08d9c14eb1a3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Rangoju <Raju.Rangoju@amd.com>

Yellow Carp Ethernet devices use the existing PCI ID but
the window settings for the indirect PCS access have been
altered. Add the check for Yellow Carp Ethernet devices to
use the new register values.

Co-developed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-common.h |  2 ++
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c    | 12 ++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
index 533b8519ec35..0075939121d1 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-common.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
@@ -898,6 +898,8 @@
 #define PCS_V2_WINDOW_SELECT		0x9064
 #define PCS_V2_RV_WINDOW_DEF		0x1060
 #define PCS_V2_RV_WINDOW_SELECT		0x1064
+#define PCS_V2_YC_WINDOW_DEF		0x18060
+#define PCS_V2_YC_WINDOW_SELECT		0x18064
 
 /* PCS register entry bit positions and sizes */
 #define PCS_V2_WINDOW_DEF_OFFSET_INDEX	6
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
index 90cb55eb5466..39e606c4d653 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
@@ -274,10 +274,14 @@ static int xgbe_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* Set the PCS indirect addressing definition registers */
 	rdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
-	if (rdev &&
-	    (rdev->vendor == PCI_VENDOR_ID_AMD) && (rdev->device == 0x15d0)) {
-		pdata->xpcs_window_def_reg = PCS_V2_RV_WINDOW_DEF;
-		pdata->xpcs_window_sel_reg = PCS_V2_RV_WINDOW_SELECT;
+	if (rdev && rdev->vendor == PCI_VENDOR_ID_AMD) {
+		if (rdev->device == 0x15d0) {
+			pdata->xpcs_window_def_reg = PCS_V2_RV_WINDOW_DEF;
+			pdata->xpcs_window_sel_reg = PCS_V2_RV_WINDOW_SELECT;
+		} else if (rdev->device == 0x14b5) {
+			pdata->xpcs_window_def_reg = PCS_V2_YC_WINDOW_DEF;
+			pdata->xpcs_window_sel_reg = PCS_V2_YC_WINDOW_SELECT;
+		}
 	} else {
 		pdata->xpcs_window_def_reg = PCS_V2_WINDOW_DEF;
 		pdata->xpcs_window_sel_reg = PCS_V2_WINDOW_SELECT;
-- 
2.25.1

