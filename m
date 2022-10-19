Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5CA2604F88
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiJSSVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiJSSVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:21:48 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2057.outbound.protection.outlook.com [40.107.212.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D691B94ED
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:21:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDv+9mDbFNmacNiTOQLZyfgP7bPA5yvTCsqFYYzi2GLPQKAe5NyEFi0RwqpPqplEoL4xeEw3PkCcDzCst0+u+kHKcrgxpcZ+VojCxNzOeWE3RqnOTkwI9x3AHhQx9LM3qPYPHd9Dpqv4OJ6Fj2tLyoW98vK85vt3Z6Gc3U7Ve3pZwhnWVeVokSt5EWPPj7HuxjU5QHwRsw9RhE1DnQOgxnXFQloxhywwc2NkjEueZQ26P3pn+AiROnVrFMCAcCYcZpyJrWuGIaXjk6X0X0CnhfPyQxSiPwmrFe5nwBnAWZASAkQGiIKQ3ErJpZojlVBJYaoAudeXSnSKXxsjbr8kbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i2u0j5NaN1BtHwhcTaOHNhBL/HukfFzknnMzjDa5YZ8=;
 b=OSr92p358q7u3TewITJqBWSQmNnri7ApUTov1fubZoa3QGUCbDFjh78sObYl0dyNujCtD3+B1XxkY+wceaBz+xWz9vS2u7vjp3PELQqF41HvbGp8jTFN+bjafhPxVE9NzKy62Xkt/3WT4IKPEaNnxwNHF4EX5SLhW7qzPKwF4/qgUdFMedzp1U6Oh5+EvLdZd04c/xHYeAIUMKbbPR11JxKLibkKBTw97w/YiGuhgsslwl2Ita0EvdPMg84uAfsqpigEfCVrQPg5fNAWhwYU/EA6Kak86FFhuwq58C5f27TKGTzJcy5+HDHtay1svUoKo5vUg3hBgs/1yCYyu2IjQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2u0j5NaN1BtHwhcTaOHNhBL/HukfFzknnMzjDa5YZ8=;
 b=LoQW79TybbvSUhsdI8+6CfBybtWMls0fRWWhfIi5oFFee+cOP4FJeBoT21XopcpGlamzrj/grHcsdmdMtOBLn3WfZJgc5kkqgvtK4nx3969/I1i0F4hthYhVnpqP3GrzQ0FmPKjz9H3A9+JrJg5mHLzhv7dx6nIJSwNxS9+ScZA=
Received: from MW4PR03CA0080.namprd03.prod.outlook.com (2603:10b6:303:b6::25)
 by SN7PR12MB6912.namprd12.prod.outlook.com (2603:10b6:806:26d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Wed, 19 Oct
 2022 18:21:44 +0000
Received: from CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::b0) by MW4PR03CA0080.outlook.office365.com
 (2603:10b6:303:b6::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34 via Frontend
 Transport; Wed, 19 Oct 2022 18:21:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT082.mail.protection.outlook.com (10.13.175.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Wed, 19 Oct 2022 18:21:44 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 19 Oct
 2022 13:21:38 -0500
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>
CC:     <netdev@vger.kernel.org>, <rajesh1.kumar@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH v2 net 1/5] amd-xgbe: Yellow carp devices do not need rrc
Date:   Wed, 19 Oct 2022 23:50:17 +0530
Message-ID: <20221019182021.2334783-2-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221019182021.2334783-1-Raju.Rangoju@amd.com>
References: <20221019182021.2334783-1-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT082:EE_|SN7PR12MB6912:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c61cce5-0c97-4219-1344-08dab1fec6f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Ur7vKXsJduyieF33dn+XtG/Y4wIVrOtI7MhuH3xMQNk5qrF5Ha24IgoKaL6hbTEFtCEKhWLngsaEB8UvRiCACyw7Aj5EG8ULD0oVtYuGEhTV3WxQTcNWuQNY9Mam8/Qzd0y7e7SsSxdc5PJ2RaFe40GJ+aR9TVMoLg7UcsNcYn2siuf6MxzbiSpbCBL3qyHeEUnYYuv8o75nlekQDAShFeDbhVzF2ghsM6sgxHyqZ8kBakwmgCysOhYRYEqStv/7Z675a0p0TQpO0cMMJYMqXprLjQ5vnQR313agdV+P0Db0uKgnIfcMdu5ufDGzYu1nATC/gRLLLLlLj8F4n08bYc5PuM4+iHC3JwOiJJaD7FlSPadv7SFF6xUioAfzslpNjb7j0qXAUZqSVu6TWIZJHOHbgGpwbB+hsB/K+PtbmxbUQIzuRh/UxM24BLuuz8HFOo01gMwdbgZMCrInmfaC/wKeq0Usq8QuLRNzQv9ZH9wl1kKPZkPPtebdaS3mfJVRCFeFraoXh9q2yUAwxQ9fhxgsaRAfun1BmT5Uu0oAzoPpUlBqAGvagJwqFLXudRqe7AyIrXs8igSnrwcNwHjFTZKo4WGyaBcGETPgmrAgrMfjyb7yInR5ZVfI/a5JLbTpxJnKKjTOROKfdTLYOkGXmQWCThNe/YQZBGbleQd6kT9gaFO4bFXAktrdafesxlKa3heGYMO2+CzBooUrjVK5EK9IOKS9+VxLwNfe9wfaapo8PM04zU00/rS/21G54gYW/mrnnPAxVP8eCdy/SspClAjTPN5L58jLIxG9J2Mwl0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199015)(46966006)(40470700004)(36840700001)(82740400003)(70206006)(36756003)(478600001)(8676002)(6666004)(6636002)(54906003)(70586007)(4326008)(41300700001)(7696005)(110136005)(40480700001)(1076003)(16526019)(82310400005)(336012)(26005)(2616005)(40460700003)(36860700001)(83380400001)(81166007)(426003)(47076005)(356005)(186003)(86362001)(5660300002)(316002)(8936002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 18:21:44.2649
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c61cce5-0c97-4219-1344-08dab1fec6f9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6912
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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

