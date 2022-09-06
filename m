Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05735AE60A
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 12:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiIFK5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 06:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbiIFK5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 06:57:35 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDC075485
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 03:57:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jN+BOq1HF8YmByTUIIdYZkvPJMPPKaXnoftr+87cNaebQHzan1OyC6rDAYFQ89D2oIji0RpHEcb9uTJHO8AGI7ZWGa+zHgH6kH0Cdv2Jvje34zTaMT5Ux67d0/oZQ/LbDFWfplwHoJHbui9OCP4TfOfZiin7nfrpbSY+8New/WnxRlpYjTnX/KPVivLY2sBFg7WjNQ3rbiEXOi5YhMcMKSgiz7Rq0bSJvq4K5ZgWYCapjq0/zSg2ojWQC5gfxSLsUZG9vPMuZ3+IJqIPw+J1UWDtxqn9VHjrEEqK/Tai1Hkuem3LRDGMUx44nxnRK//QuYvDMV8zZTUHLbKitdpvVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xsZALVnqlXFYHslfBJMQYvPNLuvq26Ov/tsJn9XwK0g=;
 b=AMp3aS62zT5GisLWb4XZuWN8d4v5APEFcDSny8Zp4ew0ASu3RO4tPd9w3YrA88tVTQhwRQuo+zoxmYFUTVGcctqgbunTFmwzry3RcHFCZ9AFMqMSjRl6Bqz7QyHeJi72uJc+h4ZHMjvMkoahaXBrrnxX/KBv7TTW6SPew3i9Dusq0qSusn+SYqoghwkK3jBYfhwVtTjsV1EJH/ze/gfUnXept11W7CgVB2jBfuS2RbfalpYzEjkzONR2/mvobgSAcEdie0v0ElpjRH/tAloM7vDnKJZ+Jx1hVhjMJJBZbpTbn1QZfUhJFCrj/HaCoN9qtB9lAZJfO2TfyMCkoiCJfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsZALVnqlXFYHslfBJMQYvPNLuvq26Ov/tsJn9XwK0g=;
 b=xfsUrL5f4oFscs8AtJBbCecK3dVUACuh76sDjq3FnOWVi8Wr1uXtFklGPRe83bDg4shKm4pf/XJhsOLrQeDuI9aIhnxFZOXvbeSidJRh5qbxhfzc9DVybt90x71D8TucsayDjHB4dDtSjnS3yFMAJ0Mo61A7/Uhf+h2gbWB+7ec=
Received: from MW4PR03CA0316.namprd03.prod.outlook.com (2603:10b6:303:dd::21)
 by BY5PR12MB4035.namprd12.prod.outlook.com (2603:10b6:a03:206::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 6 Sep
 2022 10:57:19 +0000
Received: from CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::fc) by MW4PR03CA0316.outlook.office365.com
 (2603:10b6:303:dd::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12 via Frontend
 Transport; Tue, 6 Sep 2022 10:57:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT071.mail.protection.outlook.com (10.13.175.56) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5588.10 via Frontend Transport; Tue, 6 Sep 2022 10:57:18 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 05:57:17 -0500
Received: from xcbpieterj41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Tue, 6 Sep 2022 05:57:16 -0500
From:   <pieter.jansen-van-vuuren@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <ecree.xilinx@gmail.com>,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: [PATCH net-next] sfc: introduce shutdown entry point in efx pci driver
Date:   Tue, 6 Sep 2022 11:56:20 +0100
Message-ID: <20220906105620.26179-1-pieter.jansen-van-vuuren@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70ffc3a5-1c73-4150-ab07-08da8ff6914c
X-MS-TrafficTypeDiagnostic: BY5PR12MB4035:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LCEbOVceWPUmd9qczrW6O1Ng4ENxtpgTEB+UC/jmvu9iH75GqxtAn1xMKH1qgAOVJX2v3ewZrRjV1rD0659TkGsc4ImN4vpmhwcNSyeiYxM1+yJ2W7CwKAVHTcomAvU+IY7DiNkTQPxcuSDkq9RndeX19l3lVskmDQmp5TYtTVfIPZuvfPeKvwtZg5NsC4xqB1K8hrrAUGEKJRL8Mifz5Yp07/icFHN7YByhFt3FbwAvJj3aSB1qA6mHHyCDjaOZ2bbaHOFb367xB5vIgH+9X+lgzttpYA+sIBYrvA9Afg03qs/GePrtDFdEHSmolQIlCSzhUWrXT3kGjWlgxkTWKnSC1Mv40Fc0g+3j41DH3hjbEjhrln4GDxLitpBiLGysuaCwpOii2ggmuBcvOrguUWGiNC9gBJX8sC9u6bns0hIxYsSmE6pOiMxnN0vldA8lv2feYSyedYuKoX2iBFS4Pkj5LXzgQuYq95RxUyax8M/IqzviAtm+p0FmE9YuGxpk0IyFlu7z3XkajPTVseluS49nIZdPbudA1+pc0ZNR5URT9CaFu0XUkRpHqeuYIVQ6H5WL+RQe72oXhOvhYiOw8XwmRVT5KHo/SlhvZfb+mcXIv6TroYlSCaItiBUHLLEwr5UwxQ7Lep4ssZLzwssK1nTIKijONAWKk94bOjrQsBPd7qSnHsj0rMyKE/1esC8yNgIXDXrrG2VtoqRzUcw2F/GqhmRW6qJEJNCFcDnPI8GW1R9hiiiEdCdcic8tFrdIu2x5XYQYuoS+8NkMW4gqVg930obWFP76h6zyNN9TZys=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(396003)(39860400002)(46966006)(40470700004)(36840700001)(82740400003)(336012)(40460700003)(8936002)(356005)(81166007)(47076005)(4326008)(8676002)(70206006)(426003)(70586007)(26005)(41300700001)(6666004)(1076003)(2616005)(186003)(86362001)(2876002)(82310400005)(40480700001)(54906003)(36860700001)(316002)(110136005)(6636002)(2906002)(478600001)(36756003)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 10:57:18.6919
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70ffc3a5-1c73-4150-ab07-08da8ff6914c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4035
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>

Make the device inactive when the system shutdown callback has been
invoked. This is achieved by freezing the driver and disabling the
PCI bus mastering.

Co-developed-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
---
 drivers/net/ethernet/sfc/efx.c       | 12 ++++++++++++
 drivers/net/ethernet/sfc/siena/efx.c | 12 ++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 153d68e29b8b..b85c95e1ae7c 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1175,6 +1175,17 @@ static int efx_pm_freeze(struct device *dev)
 	return 0;
 }
 
+static void efx_pci_shutdown(struct pci_dev *pci_dev)
+{
+	struct efx_nic *efx = pci_get_drvdata(pci_dev);
+
+	if (!efx)
+		return;
+
+	efx_pm_freeze(&pci_dev->dev);
+	pci_disable_device(pci_dev);
+}
+
 static int efx_pm_thaw(struct device *dev)
 {
 	int rc;
@@ -1279,6 +1290,7 @@ static struct pci_driver efx_pci_driver = {
 	.probe		= efx_pci_probe,
 	.remove		= efx_pci_remove,
 	.driver.pm	= &efx_pm_ops,
+	.shutdown	= efx_pci_shutdown,
 	.err_handler	= &efx_err_handlers,
 #ifdef CONFIG_SFC_SRIOV
 	.sriov_configure = efx_pci_sriov_configure,
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index 63d999e63960..cf09521b0c64 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -1148,6 +1148,17 @@ static int efx_pm_freeze(struct device *dev)
 	return 0;
 }
 
+static void efx_pci_shutdown(struct pci_dev *pci_dev)
+{
+	struct efx_nic *efx = pci_get_drvdata(pci_dev);
+
+	if (!efx)
+		return;
+
+	efx_pm_freeze(&pci_dev->dev);
+	pci_disable_device(pci_dev);
+}
+
 static int efx_pm_thaw(struct device *dev)
 {
 	int rc;
@@ -1252,6 +1263,7 @@ static struct pci_driver efx_pci_driver = {
 	.probe		= efx_pci_probe,
 	.remove		= efx_pci_remove,
 	.driver.pm	= &efx_pm_ops,
+	.shutdown	= efx_pci_shutdown,
 	.err_handler	= &efx_siena_err_handlers,
 #ifdef CONFIG_SFC_SIENA_SRIOV
 	.sriov_configure = efx_pci_sriov_configure,
-- 
2.25.1

