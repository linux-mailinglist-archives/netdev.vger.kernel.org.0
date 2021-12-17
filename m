Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6241F4789A0
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 12:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbhLQLQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 06:16:48 -0500
Received: from mail-bn7nam10on2072.outbound.protection.outlook.com ([40.107.92.72]:20832
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235292AbhLQLQp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 06:16:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kBycIbUyVrplFJ2xp144BpAORHXll8wziodu82cgt9VdWdL1h7jjzbxgheGJfUu0lKFre810YT8i/dmLmuVIZ+z4GXDff8wuS64Df5sKT7DrkKgxe9k2+lu5ijGvv8LXV+T6fjGZIr3gk1MalqOfvYJIgRwSZkmMLdDChzwL7hvnetW62FcXo7a8ofc5soNHD0mCsFGOmF7hGlBRKkOMyQxw5zdkQfUPKNUewNt+Red0NbPqglLlWboUd7nZlMAzWXZ95DqNN6FFnIzwJ1MTBinxWIedXQ06h7w96ed2K3N+k5K7ocsqDaU9U1+cJKgH/XY0T7sTC3nrzplPNFXPGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rqk/FJg2CCq8IBvC64VQHrzw2lyBDfmC1GJOTqal5jk=;
 b=HFBdtCjcXy+5Ic5N2wwKArhAcN0b23Ztwujao3WSl1Il6hBY/6c6YvIn2WTLbT5azbX8WW2wxx5DCtPJfSWVUxP6WHYYZ2VlXjteEoetaLo2fd9Vl269Jcv0MEUFHl2pC5ydnepWruiVog3RX+3MLflRDP4hDHQgUV/RJxu9YTAqr1ABlTeKQ4ZqjZSwkQ1CdHRdrVRzkC+6u83CMaCrMR6wvLzoPgMFTfkk9thxbrY4sqJFUYFBi0P/TnNTEifkPpzomvFBgU3Eq8Kn07JgU3Gywdq6CS4YyjXbY0ZeNCptXvlLzeLMgYcduGkI32rboEWGUJ9Z8wT/T39AxeH0hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqk/FJg2CCq8IBvC64VQHrzw2lyBDfmC1GJOTqal5jk=;
 b=Z5OAPaG1A5kzQSwo2DtHFeJalWceRe/64YtEij5a7v+lg+UNwb8ae8m2IfS4UhggHbszIh5RSgHMu0dJCVWWRutbH75eX83r3mbfHf00Crnqajl0EDHoESM+eNovMr4+O5Mymji5t94cug3c/KdYS+l707HtcfsxB5WRKkpiDWk=
Received: from DM6PR02CA0076.namprd02.prod.outlook.com (2603:10b6:5:1f4::17)
 by DM5PR12MB1898.namprd12.prod.outlook.com (2603:10b6:3:10d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Fri, 17 Dec
 2021 11:16:43 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::ab) by DM6PR02CA0076.outlook.office365.com
 (2603:10b6:5:1f4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15 via Frontend
 Transport; Fri, 17 Dec 2021 11:16:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4801.14 via Frontend Transport; Fri, 17 Dec 2021 11:16:42 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 17 Dec
 2021 05:16:40 -0600
From:   Raju Rangoju <rrangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Shyam-sundar.S-k@amd.com>,
        <Sudheesh.Mavila@amd.com>, <Raju.Rangoju@amd.com>
Subject: [PATCH net-next 3/3] net: amd-xgbe: Disable the CDR workaround path for Yellow Carp Devices
Date:   Fri, 17 Dec 2021 16:45:57 +0530
Message-ID: <20211217111557.1099919-4-rrangoju@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3f9e0579-d98e-4a86-5aa5-08d9c14eb480
X-MS-TrafficTypeDiagnostic: DM5PR12MB1898:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1898A37A714957AA8913A65695789@DM5PR12MB1898.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LzviKcZMwz5lysl7+OuOW/iu8mDP2DEKf2npv4iY3RXSAftIThaArwtgaiyuCndB9d57ZDv4iJ854Jur2T3JMEMOIK4WX0mTFgLSdMxMvRdERWlWh1DzAaObXWkqV4jJFS/gIdEpzJFd5RrOZtP3EGrdtu/Ybu3EDT/7avf8V2byZ8qx4m1mfEkuhiRfuXnc5RNz6OIriPYjpX1UQH4Py/TiKAZSBf1a4nEL+X0c8wtPYbSaROiA0BD/3lKNvVOPW8OGNZSGa3q3m6+2lg5c3MOlL6kAbJMaVF0XEMCh4z5r1c6bWAKtL+A3gTStXxAay3WjQ2FxwYflPBB058HpK+xaIwJvH0nnD/lYPq3TFHx0XA6pLHnHm9GpGQ8z8Y+5NYML3IKx1Mmwh+WsUj1xy2pZjDWn+Z+c6I9Fyrv5WprSNaG1eXHCpY8pJdwdRd11XtM0jrfpAt++u3kSzg1GWBG+mnZRyptZgv484y7rmW4nI9WJUjxT+5iqgWQaltlBuepiuyqO/ArtsRV4S5R67gzTOoicf9itd9L/reCLf8heZtNFEalv1Qf/UJeksE4IeTOQWgMzXvWVGVYuAVdbt4Ga7JyDoJvpAlHiUHtfq+W2CByNES6oUQfZ/94HonC2F8ua83swgA6ApgrYs1J0NVfZ3KzjZbfQHYC2pf0mNy/Pzng7iq1YNCQ1Rm0MDduMEKNApZwMx++6Iw3V+6UNBNsyYGg/jHut6FlsCRuEhHeGzxLei7DqjqX3mxzD68srobu8UQVrIM5b14Wa5lpn7w9C7TW8oe+2g3qXpU1Ck0s=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(316002)(40460700001)(81166007)(8676002)(2616005)(70586007)(6666004)(4326008)(508600001)(5660300002)(336012)(8936002)(36860700001)(356005)(47076005)(83380400001)(36756003)(82310400004)(54906003)(186003)(16526019)(2906002)(7696005)(1076003)(110136005)(26005)(426003)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 11:16:42.8658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f9e0579-d98e-4a86-5aa5-08d9c14eb480
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1898
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Rangoju <Raju.Rangoju@amd.com>

Yellow Carp Ethernet devices do not require
Autonegotiation CDR workaround, hence disable the same.

Co-developed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
index 39e606c4d653..50ffaf30f3c7 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
@@ -281,6 +281,8 @@ static int xgbe_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		} else if (rdev->device == 0x14b5) {
 			pdata->xpcs_window_def_reg = PCS_V2_YC_WINDOW_DEF;
 			pdata->xpcs_window_sel_reg = PCS_V2_YC_WINDOW_SELECT;
+			/* Yellow Carp devices do not need cdr workaround */
+			pdata->vdata->an_cdr_workaround = 0;
 		}
 	} else {
 		pdata->xpcs_window_def_reg = PCS_V2_WINDOW_DEF;
@@ -464,7 +466,7 @@ static int __maybe_unused xgbe_pci_resume(struct device *dev)
 	return ret;
 }
 
-static const struct xgbe_version_data xgbe_v2a = {
+static struct xgbe_version_data xgbe_v2a = {
 	.init_function_ptrs_phy_impl	= xgbe_init_function_ptrs_phy_v2,
 	.xpcs_access			= XGBE_XPCS_ACCESS_V2,
 	.mmc_64bit			= 1,
@@ -479,7 +481,7 @@ static const struct xgbe_version_data xgbe_v2a = {
 	.an_cdr_workaround		= 1,
 };
 
-static const struct xgbe_version_data xgbe_v2b = {
+static struct xgbe_version_data xgbe_v2b = {
 	.init_function_ptrs_phy_impl	= xgbe_init_function_ptrs_phy_v2,
 	.xpcs_access			= XGBE_XPCS_ACCESS_V2,
 	.mmc_64bit			= 1,
-- 
2.25.1

