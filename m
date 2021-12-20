Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F20F47AAB8
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 14:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhLTN4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 08:56:09 -0500
Received: from mail-mw2nam08on2046.outbound.protection.outlook.com ([40.107.101.46]:2657
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229979AbhLTN4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 08:56:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRpS2atfg6ZhZWVHRSspDoYIInNyomeA2JbJEgHAL/xKbbE1V5P7WA/UoZZdNxdlEaIkZYudiHExBcJO1TpQhq70S5duoRXmqTlqlFJXH9q5dnJ7MXw2uHvCV/U3s1OzIPayMHBb6aQej5u/FYBU/9icY9e/nsB5pIA+9POaF+6RSzQeV36DO4TyWI5ryRArrpnijlam5pKNCoc4Ge+j76W3PuhCTTsixaC8KbDAc62JtyfI4vZeBGYccgPOilDV7z5oNkWgn/o7fwoq8N09tpafTfGvrqp78d9aTU+Y4mfHLHFKxxQYhLRWc+QvPMLcmu71/GeeIhjBXBuSYS+S4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XHLYmb070CCcC0tw2W6fSKTBlIk4GP+Qr325dcAwI/c=;
 b=IwNXpbqKce43B6k8UsNaZ7vQgD2z7FR0GvO2H4zSuhyGINCMtUR3wDa03SDmDqF0dKO9MVCbFQSCHe+Q3JGHfmLDc5lsvNyEecESCWBFMg874agadqSbucEgWsJxLkl6uorj+ngF7FivsegnTrGIa3gxGR1MIDUd/7iDlo7zctE6j3SBWXhNAjKphb18QcJCKkcwS3YLpOrhsCS9aZjwFJUScsRgg3gSuwsCcuna48SqG3Oef5NhWD/fOZKy5HuMh9eUsCmEKA8RjruDLMeRWzAv3M6+hH2Tfo4muXTY5g0hlIkSHEt/q8qdwx5vnpW5LzhRfFvO5PQiNIlFwrFWZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHLYmb070CCcC0tw2W6fSKTBlIk4GP+Qr325dcAwI/c=;
 b=OX1SxZYbVkocZHKeQFnzqKc0aBatO558LQUiFRuNyZjWVfTosJZ1DrUa49sSjD4Qfz58+UG6Um28khZrrsUyoUy11NddV3sej6LBhaQNI6NaugFR+A4LqRjY/6uDjv+me7c05CE9nuGJYyayAF38CgHtw1UoUAeD48qxeEkc0jE=
Received: from CO2PR05CA0094.namprd05.prod.outlook.com (2603:10b6:104:1::20)
 by CH2PR12MB4069.namprd12.prod.outlook.com (2603:10b6:610:ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Mon, 20 Dec
 2021 13:56:06 +0000
Received: from CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:1:cafe::80) by CO2PR05CA0094.outlook.office365.com
 (2603:10b6:104:1::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.14 via Frontend
 Transport; Mon, 20 Dec 2021 13:56:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT032.mail.protection.outlook.com (10.13.174.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4801.14 via Frontend Transport; Mon, 20 Dec 2021 13:56:06 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 20 Dec
 2021 07:56:02 -0600
From:   Raju Rangoju <rrangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Shyam-sundar.S-k@amd.com>,
        <Sudheesh.Mavila@amd.com>, <Raju.Rangoju@amd.com>
Subject: [PATCH net-next v2 1/3] net: amd-xgbe: Add Support for Yellow Carp Ethernet device
Date:   Mon, 20 Dec 2021 19:24:26 +0530
Message-ID: <20211220135428.1123575-2-rrangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211220135428.1123575-1-rrangoju@amd.com>
References: <20211220135428.1123575-1-rrangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28a4debd-489e-48b9-aecc-08d9c3c077ea
X-MS-TrafficTypeDiagnostic: CH2PR12MB4069:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4069C766F24A614E7A7ADEA0957B9@CH2PR12MB4069.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1URRzZy7fHQTayStVKUqw4B2JWQxBn/DRs1Ozhc+54mhAEpHlJ7CkNeWt7qE/w5KHQZORAxRFGASl8YWrKavz0UW/ABLEPcP7SREWXy2+ec5tZZI41ZfsJsu4GeWlFK2r5gm5D/48iUywpOHgwvYYn4iIIL8lvL+czwImJ9yZ/VhQHANw7BCE7Z3oIotOD3GYRSz28WEspCMW8obyR6spi23o0AtyF26vcIAZtJn/UZ5yhGaDovm2QRmanlnBwUOeffp42CCCor/Hdv5QuWp8jXaREYu0nyAYUqJDrOTdBoPxalXwcR+ao8X3GjZYgiTPI488OvHOM2aLKEKYvRGgq0zgHouBPo34dQfRxNrbacKWSLipyjm0OxC+nEHBk2rrwF8d0/DYBne96l6nVAlRSW26NCB/f//wU5Ui83ku/8q79HatT8Pp5+6sGe3IA9ym+TEpLlt0w0WmYgpOY0QsS6sMZBdAS5KGRshQMZ5xNCdmCb+WVLQD+Ay5b58Wx+UTKZrwobBi3ZYdipSQ4ZR7tuzRNnVwGWtcphB8xuukLLI5qUORBLtNfJe2T77a4OST9thANp3GvxyAZrLJVHu84Sk3dqSc/1Y0uRtaZJrfa05yp8y3EVj3aBv09ruUjMhK1XHO7BIAn/X/+/K19V1TguACSq0ZEYjxAegvPm1MWUd90P2G/OjZI6OBj7K/kw9rd1Opf/oDZbsYBHm/jGaiduvWleo0FxRBtbvi8ftQvixEArqYkFatvyYVrqOiSxMoA/T6t8ZHDaVqupYJWMtcgfhrfXcEwWlSqWKRB53Gvo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(1076003)(16526019)(36860700001)(2616005)(70206006)(47076005)(2906002)(36756003)(82310400004)(7696005)(186003)(26005)(83380400001)(54906003)(426003)(508600001)(6666004)(8936002)(5660300002)(316002)(70586007)(356005)(81166007)(110136005)(336012)(4326008)(8676002)(40460700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 13:56:06.1079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28a4debd-489e-48b9-aecc-08d9c3c077ea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4069
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
changelog:
v1->v2:
 - Rework xgbe_pci_probe logic to set pdata->xpcs_window.. registers for
   all the platforms
---
 drivers/net/ethernet/amd/xgbe/xgbe-common.h | 2 ++
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c    | 4 ++++
 2 files changed, 6 insertions(+)

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
index 90cb55eb5466..0f930b17980e 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
@@ -278,6 +278,10 @@ static int xgbe_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	    (rdev->vendor == PCI_VENDOR_ID_AMD) && (rdev->device == 0x15d0)) {
 		pdata->xpcs_window_def_reg = PCS_V2_RV_WINDOW_DEF;
 		pdata->xpcs_window_sel_reg = PCS_V2_RV_WINDOW_SELECT;
+	} else if (rdev && (rdev->vendor == PCI_VENDOR_ID_AMD) &&
+		   (rdev->device == 0x14b5)) {
+		pdata->xpcs_window_def_reg = PCS_V2_YC_WINDOW_DEF;
+		pdata->xpcs_window_sel_reg = PCS_V2_YC_WINDOW_SELECT;
 	} else {
 		pdata->xpcs_window_def_reg = PCS_V2_WINDOW_DEF;
 		pdata->xpcs_window_sel_reg = PCS_V2_WINDOW_SELECT;
-- 
2.25.1

