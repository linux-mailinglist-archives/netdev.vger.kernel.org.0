Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D939047AABA
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 14:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhLTN4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 08:56:14 -0500
Received: from mail-bn8nam08on2061.outbound.protection.outlook.com ([40.107.100.61]:10528
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232329AbhLTN4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 08:56:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IcQLL5uffpLno2XRuipdKB9r7xTB0ufrB+jlBhMbj8ZKRKh/w1ZnrAa667GcXmzDpi+XC+v9Y0Uv5BYwBabiqoipBXjqFMZzqs0NbUdzeUPTq1SvVx008ccrxZN7PPA6vBjuS5XTQTXM9+EiuIa6fDMCzziolg5LADMdB7GbEmICutfjgJk0VbwXNB+uAXpfkWk57DiKhzYyazcjyX7ksWKYf4VDZ8he1nC7I3omk+HLxQx0tKaH9D6xb2t+vVCqjSMf0uQrZvBekiEIBogl635bWTiZvu1XjHBdEXkBqMpQU9GSEWdX2lzVXF4aKuoPH7e+Lz0GrZ9ggPR+A9P8lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aOJtlM2r83uJbOQcuchLYbaMGtehshu58WPeJTCxcfY=;
 b=UDQz70Vnm87vYuAF6nvGMukIaV9LJmgX7CmN3Kb+/FMaWIrXce5Xia4WA9EcfIOnySYdDRUIvvBGc7z/dIcHkI8K72Daxle33449AyJgCW5mLw6oJePHLu/KCLI1SGEGfsFWnin1fZ8+tsSPS2tQcZ+3SJyAQF2XbzG7f/1M7q9KZP9GPJzjL+kCZCsWt9BmBBrHkGU9jmfOEkAzydXBN/4ggL5AVyBRRt+YWYRSlt7aVw7PdEaoqfpiHtThrFKQ4zX5Z466LcDtqE0GTUWiqdexbpqFtoQPgrf46NpraVkWGzT9nS84n1dfmJSosmzzdx78UfCCnmbGVC0edb3M9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOJtlM2r83uJbOQcuchLYbaMGtehshu58WPeJTCxcfY=;
 b=VGWbl9VJGyODVDMKpndovZ8LM7bnjvpQZSDj/j+xX8QqSa7Ua7Ok6dYKa3qrMntSYYaNV3aStBXIiz7kYfzLqBbWgIrcLPES68H7cr73XUnTC3aKy+nlz8eBRAvPi8TilsgyrCTrnAUsI6Yq4OipX5iTdLvJwLuMh27qVBeapDA=
Received: from MW4PR02CA0022.namprd02.prod.outlook.com (2603:10b6:303:16d::15)
 by CO6PR12MB5395.namprd12.prod.outlook.com (2603:10b6:303:13a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Mon, 20 Dec
 2021 13:56:11 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::e6) by MW4PR02CA0022.outlook.office365.com
 (2603:10b6:303:16d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15 via Frontend
 Transport; Mon, 20 Dec 2021 13:56:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4801.14 via Frontend Transport; Mon, 20 Dec 2021 13:56:10 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 20 Dec
 2021 07:56:07 -0600
From:   Raju Rangoju <rrangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Shyam-sundar.S-k@amd.com>,
        <Sudheesh.Mavila@amd.com>, <Raju.Rangoju@amd.com>
Subject: [PATCH net-next v2 3/3] net: amd-xgbe: Disable the CDR workaround path for Yellow Carp Devices
Date:   Mon, 20 Dec 2021 19:24:28 +0530
Message-ID: <20211220135428.1123575-4-rrangoju@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9788a4b0-58ec-4542-f453-08d9c3c07aae
X-MS-TrafficTypeDiagnostic: CO6PR12MB5395:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB539532845CCE87D0FF9EEF6F957B9@CO6PR12MB5395.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KTscx/u3+RO7JQEga9O0fXj+9oiLovitgYlKDZFPHNYMACit4L8DAD/gPkqknOUO8DJLT74Taqz5w7xNFOzPG21VEzvq6G+rsnFau00P4HgVZjOUZhnhFhVmTzdKQOaZiA0n8IpRM9a/ihPyZ3iBQNFsJDVrSWQGw5APjhYvweWAKXZWSuBIDD5QAgguFXTcBEqGyXf8g0B7BKhKwuzOLmH2vqiKZP3XIXaxgKRDWH9UAmtBXEINzgyoG3iBg2cKVLNYHSvEeC4zRhG7XA1XbBVExJpVSbK1Cfl6RG0kySPtcAY/oibu9I3m6xrnVLOZXeSJCuiq/izVXiwO200yVBXHskdcv5w3nThMEV5r2sFLHjgVXrFRR0Z0aafwIBLBEadJdDi9GQRLgERp3swTCX4xAyOO3bH3xpqBVrGAlwY2nKah/xOTWWY3zBaVPYce8p0Rnrwf0M8T8CgWlTKn2XTIOXM/UQy9Wxhj9DpRSdeopwg9LJwL6cnd7jSVMj8WV5yhPfPFi3jC/5G1ehsRpaIT24vqpWJas3W+8r/N17MvpFQvc0ecijZZ7SRL7oqCJ1U5nFnPB6+uMc8OPRae6hFrjfHnuRLbxhZBzEpoj74FOZw46hph3muVfqMIckq6NrMVxNCrUu4PWFI7DYk/8lzJ+DsOlj6klWJSOxCyttMuOiQudMTyLJeP9ZcGTNaUj8Q5IMOfahsbqMOnfcTJJBzig+rCCvc87DndRsZMSZcDmIFFOAWO0oMpmdMkPuHbMI5glx3y32ijqlP/xNZkIlZTsAYkRTuJzLdr3kbNKVY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(7696005)(26005)(5660300002)(47076005)(8676002)(81166007)(1076003)(83380400001)(2616005)(110136005)(6666004)(16526019)(336012)(4326008)(356005)(186003)(70206006)(508600001)(8936002)(82310400004)(36860700001)(316002)(40460700001)(2906002)(70586007)(426003)(54906003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 13:56:10.7496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9788a4b0-58ec-4542-f453-08d9c3c07aae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5395
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
changelog:
v1->v2:
 - Add a blank line before the comment
---
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
index 0f930b17980e..efdcf484a510 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
@@ -282,6 +282,9 @@ static int xgbe_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		   (rdev->device == 0x14b5)) {
 		pdata->xpcs_window_def_reg = PCS_V2_YC_WINDOW_DEF;
 		pdata->xpcs_window_sel_reg = PCS_V2_YC_WINDOW_SELECT;
+
+		/* Yellow Carp devices do not need cdr workaround */
+		pdata->vdata->an_cdr_workaround = 0;
 	} else {
 		pdata->xpcs_window_def_reg = PCS_V2_WINDOW_DEF;
 		pdata->xpcs_window_sel_reg = PCS_V2_WINDOW_SELECT;
@@ -464,7 +467,7 @@ static int __maybe_unused xgbe_pci_resume(struct device *dev)
 	return ret;
 }
 
-static const struct xgbe_version_data xgbe_v2a = {
+static struct xgbe_version_data xgbe_v2a = {
 	.init_function_ptrs_phy_impl	= xgbe_init_function_ptrs_phy_v2,
 	.xpcs_access			= XGBE_XPCS_ACCESS_V2,
 	.mmc_64bit			= 1,
@@ -479,7 +482,7 @@ static const struct xgbe_version_data xgbe_v2a = {
 	.an_cdr_workaround		= 1,
 };
 
-static const struct xgbe_version_data xgbe_v2b = {
+static struct xgbe_version_data xgbe_v2b = {
 	.init_function_ptrs_phy_impl	= xgbe_init_function_ptrs_phy_v2,
 	.xpcs_access			= XGBE_XPCS_ACCESS_V2,
 	.mmc_64bit			= 1,
-- 
2.25.1

