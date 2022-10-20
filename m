Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2628360577D
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 08:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiJTGnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 02:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiJTGnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 02:43:15 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2138F15A315
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 23:43:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RC2ha5yN+RUri11TSRleaH6eAylDYC22z74P+IExUN82rQwJkK427RLoTQjItYgvyKJdhvzGxGwE+/ftFadkbD+9l5R90IefJ9lA4Sy/mnMr5Rm/Tpx632idf5b4G7UT3eRP8sadd8VFlurfVE7El9lBR9lhSeCzXoq2dTE4niur54MgZHfRLH9YMeqfKBOM6dJHcOz5batc+yDtrcVQ+/w8H0D1d2E/SyiSG2C4GfNeqB9mLYXI6GxkOKczwcSPaRPYPlyZ66ubOhRBl1yfdx/HutFL7TbrFYLFRKVcPNtgxCBRqpJi1SOVTnrC9nSMfr1LlWNblaCQ0uumGQpBBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i2u0j5NaN1BtHwhcTaOHNhBL/HukfFzknnMzjDa5YZ8=;
 b=ZwVEyzlH2h/uRJMgahAknIk+FfvHPOktXtUlM3m01eXlwHgTAfadbKujOheaxt99Q7X5ht4+KMvSbJrYd18ODCGCfl4JiJrSR7GnhuW8jbsuic9h/bTlF5PiqPX/TJLhF8Q9n0k5QIUYeYQHrBFlpe5dAA9xd2pOOwg7aWnWv0DxuuKsp2MvJ5dFDt44wldjwTxGaUnU0OHavU9vox1s6AVnVkpXgiuWtY6zYktxt4hyI+WaxQtQ5ct0eSQchaoRX0cVQzzLanNmOxvgO2U80gd9c5oHqNppvyWziME6hvWYosEMt/k+fUaMNR7ZaXjuLFoOapWLSYp51WKpI6jnIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2u0j5NaN1BtHwhcTaOHNhBL/HukfFzknnMzjDa5YZ8=;
 b=xLrYZC421ePtWA2TD23iYvTmaxacP3PLCDYKobcaDKquQFcaLgrmhlZTx2JbXePmnQVEhXNAME9gD9cDFavGZ34BkYNDPREIceaHvySPqWZhN668hbVU4WNbsxq7KuS148MFCH/lQbmv3NDp4vjD2aqFrUbZ6f4kaSExcSEKSwM=
Received: from DS7PR05CA0013.namprd05.prod.outlook.com (2603:10b6:5:3b9::18)
 by IA1PR12MB6212.namprd12.prod.outlook.com (2603:10b6:208:3e4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Thu, 20 Oct
 2022 06:43:11 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::7c) by DS7PR05CA0013.outlook.office365.com
 (2603:10b6:5:3b9::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.9 via Frontend
 Transport; Thu, 20 Oct 2022 06:43:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 20 Oct 2022 06:43:11 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 20 Oct
 2022 01:43:09 -0500
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Rajesh1.Kumar@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH v3 net 1/5] amd-xgbe: Yellow carp devices do not need rrc
Date:   Thu, 20 Oct 2022 12:12:11 +0530
Message-ID: <20221020064215.2341278-2-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
References: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT020:EE_|IA1PR12MB6212:EE_
X-MS-Office365-Filtering-Correlation-Id: fcdc15d5-20a1-4071-f9d6-08dab2665b5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XDEJJz8TBBmEdYorxzAUJ0Q6frkzgy77K7QCgXNcrKmenFGpExYZakmyikJykZabbA+H903f7XtPAyBMHPLIPCnCB/6WXQ8DU7M9zjnOKtj1K6veecd7i1rlXcxK5O2FTm7rz3GjTthAh4d4CYA/2iYuaUH1rvLrNv/Ncx22vzHU4nyJov4Eyv10+KYDCHhzeaq7kt9TteVDx+RgvqZAVqSSmwXTz4gmWB+dIxgeUSx5uAuRyNav27ZoB6wTsLsCxIOTtk92ukvRhQb3IOtwHIppqdYoKNBbbPVTW6bXDlu/zeQJAefUofJuUMbe5hGzFM9RjZLiMWd4EC5Rg7vdF/OJMZJgpOcXVR8PyPbhtlqJvE3Wyyi9urMtCp1XrTETF92LD5RDg7aRpioTXxUc8ndacROq4ravKsuJc/sFH6m8dVbpv2+7J7ZDEuyq2N0avDZPvM54aihbZeI2UM8uvF+S8zo/5FXPteb/4OBIgS7i+2z3sP4lRtbwrI3ZxG3DXC/QNE4lB0lZPz59Q01FIjaw5EaUln9fKrpSDDRDSWw/UgITibarhfsuCppyXFGigC5EsQ7DbdIxCYvxkumhDSb9LX6GmYGj0MMu3s5wJK9yzQTS19dmtMBT0O7t0sDqjND9NxhsFv2Ln7z3reV+TLIuuPeeasOLyQxF+aWAdowIE5T6EBnZG1euEv0RbUiziSeLbRKOOEke8+9bOh/MVssauHZTJqBoEJ3bNEEcq5tfxIfXXB+qRDDkB/QJQcRRsiTfUrrMs0N7Lz6YaOwQpnDJzTq44Amlw6sAH5sV/xk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(346002)(136003)(451199015)(46966006)(36840700001)(40470700004)(54906003)(478600001)(110136005)(316002)(70586007)(4326008)(8676002)(6666004)(70206006)(7696005)(8936002)(5660300002)(26005)(82310400005)(82740400003)(40480700001)(41300700001)(36860700001)(186003)(2616005)(86362001)(2906002)(336012)(426003)(16526019)(40460700003)(36756003)(356005)(1076003)(83380400001)(47076005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 06:43:11.4662
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fcdc15d5-20a1-4071-f9d6-08dab2665b5a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6212
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Link stability issues are noticed on Yellow carp platforms when Receiver
Reset Cycle is issued. Since the CDR workaround is disabled on these
platforms, the Receiver Reset Cycle is not needed.

So, avoid issuing rrc on Yellow carp platforms.

Fixes: dbb6c58b5a61 ("net: amd-xgbe: Add Support for Yellow Carp Ethernet device")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
Changes since v1:
- Use the correct fixes tag
- Update the commit message

 drivers/net/ethernet/amd/xgbe/xgbe-pci.c    | 5 +++++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 2 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h        | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
index 2af3da4b2d05..f409d7bd1f1e 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
@@ -285,6 +285,9 @@ static int xgbe_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 		/* Yellow Carp devices do not need cdr workaround */
 		pdata->vdata->an_cdr_workaround = 0;
+
+		/* Yellow Carp devices do not need rrc */
+		pdata->vdata->enable_rrc = 0;
 	} else {
 		pdata->xpcs_window_def_reg = PCS_V2_WINDOW_DEF;
 		pdata->xpcs_window_sel_reg = PCS_V2_WINDOW_SELECT;
@@ -483,6 +486,7 @@ static struct xgbe_version_data xgbe_v2a = {
 	.tx_desc_prefetch		= 5,
 	.rx_desc_prefetch		= 5,
 	.an_cdr_workaround		= 1,
+	.enable_rrc			= 1,
 };
 
 static struct xgbe_version_data xgbe_v2b = {
@@ -498,6 +502,7 @@ static struct xgbe_version_data xgbe_v2b = {
 	.tx_desc_prefetch		= 5,
 	.rx_desc_prefetch		= 5,
 	.an_cdr_workaround		= 1,
+	.enable_rrc			= 1,
 };
 
 static const struct pci_device_id xgbe_pci_table[] = {
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 2156600641b6..19b943eba560 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -2640,7 +2640,7 @@ static int xgbe_phy_link_status(struct xgbe_prv_data *pdata, int *an_restart)
 	}
 
 	/* No link, attempt a receiver reset cycle */
-	if (phy_data->rrc_count++ > XGBE_RRC_FREQUENCY) {
+	if (pdata->vdata->enable_rrc && phy_data->rrc_count++ > XGBE_RRC_FREQUENCY) {
 		phy_data->rrc_count = 0;
 		xgbe_phy_rrc(pdata);
 	}
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index b875c430222e..49d23abce73d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -1013,6 +1013,7 @@ struct xgbe_version_data {
 	unsigned int tx_desc_prefetch;
 	unsigned int rx_desc_prefetch;
 	unsigned int an_cdr_workaround;
+	unsigned int enable_rrc;
 };
 
 struct xgbe_prv_data {
-- 
2.25.1

