Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D8954BCC2
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 23:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344159AbiFNV0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 17:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiFNV0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 17:26:14 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C8850B39
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 14:26:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5RZ/Yk8qDgfBtciiQZhqWkwioho/jk3r9B0ytatdYlyksekPrlsaFmrdDAUF9cPkkw8FCgdjNIGQrDbapUAveMbLwK6QFcc0iAZ5rywbzhVi4qf/QCiKzq1mIOfmaqqjUkWyo04FrlbCqmboSyrDjWmhysH5bLO4hnItDEWaWWPdSZnnDamPZZ8nWr9IkPV7Zxm1DYzo8tdOpu0m9UZv/s3OCKF/G7aSTPZf+hAMCsZkGxCk66NJte3YWC2sjlZZaWne5/Uf9e2sw33dd2DvLhrPZ8DCm/K/bBMDeyeDddvBAr+bLSeov9KKAUMbVjMm6rBAsTa6ycMeeUGxh7/XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AhKlT7iyXjIDINDgT6uVQZTXvaIjeTjbNAdqiAsOmj0=;
 b=dv8jzYf9QFMA3EXIBC7wWdvBfgDhhA9n78gN4SeNbsvJMjemxdvBMUt2uKtSR/WiwFVQiyaakJF2fiBXBk505xwamuRH1S0+EZDVZ4REFX02znfDt1cwIGzfU0ryGJaXlz69FeKNEBQQxCXdlhE/TUasUcAvXgoNKBfphGQDHHNjhps3MJyl8CFqUkQRDoD8wmDn7RNTR9yxL1c3xqXoyBqdiBMDVb9+yGcy/lFx6gWoHijZuat20rgObGYCII3d5ok5VUhno9mWTEYrZRYkXgqo4/5vTFy2umP4MMT+NvcyFL3h3/k+j+6C9zhPqIIhzhnw5OPZpf+YdG3jW3dyTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=bgdev.pl smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhKlT7iyXjIDINDgT6uVQZTXvaIjeTjbNAdqiAsOmj0=;
 b=UWoSM8tAunGZ3NisSybbkaLrDOZIGx6YeQBT3Vm24nTKGdu0NYiJ5QZ3svIeM2u5yOFZZ6+k6y0nQVSp6FNBS8lwdAvcy0lwyFb2Oyjlame1YDmItlx6cNutWbLJqjBACIz6ojxB7qNDiOLz0Fr33a1Unop69jiVP6ps1KB6CWEaPZmQj2Kro2738diIt/Ewo306heB0PsBpoTr6wV44IXKHlJmFbS4OG2S2AaaZkllQcMI8iHOn7ggIdLxKEI5pynzWlhkK43gVZyK5hHkXQZyRwW6Frb/gfhkBeZ7QSGMRLnZ+wWouaohQGxP2Hai21zUM6q4wqT/Sk0nG0VDZUg==
Received: from MWHPR1601CA0020.namprd16.prod.outlook.com
 (2603:10b6:300:da::30) by CY5PR12MB6084.namprd12.prod.outlook.com
 (2603:10b6:930:28::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Tue, 14 Jun
 2022 21:26:11 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:da:cafe::cc) by MWHPR1601CA0020.outlook.office365.com
 (2603:10b6:300:da::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Tue, 14 Jun 2022 21:26:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Tue, 14 Jun 2022 21:26:11 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 14 Jun 2022 21:26:06 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 14 Jun 2022 14:26:05 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Tue, 14 Jun 2022 14:26:04 -0700
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>
CC:     <netdev@vger.kernel.org>, <limings@nvidia.com>, <brgl@bgdev.pl>,
        <chenhao288@hisilicon.com>, <cai.huoqing@linux.dev>,
        David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: [PATCH net-next v1] mlxbf_gige: remove own module name define and use KBUILD_MODNAME instead
Date:   Tue, 14 Jun 2022 17:26:02 -0400
Message-ID: <20220614212602.28061-1-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67b174a2-5b02-4ed8-ae13-08da4e4c80e2
X-MS-TrafficTypeDiagnostic: CY5PR12MB6084:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB6084E64F04FF0A4193994EE1C7AA9@CY5PR12MB6084.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rwiK7lQA85G3y2fCTpnvd20UUzKd8UpYn2FsqRrAe1LiClHdesceHVo9CI2VzikdinI7c/OcbhW/OPp0WkpKL0mhKekSE3SqO2sNveEzBZnhWkctaHJILmUKzFMIyVIrFJpqlzcWgXCMsK6+CdAeFNnMrDwo87hwgqZQCvKz42VmSeY4SNDwB6taBmctOCLyT/H0MfhSmDpbpwmAwx9PNo51ODoMXVWW9WL43Qd0Cfas9TSEZ1DJJpPkcf5swZHD8iTGcZrLpHw3olgI021yW3keEn8cC04T1p2a2vhKctdiwCOfdoOsafJFTvwXGpUWDz6vTSRCsgMDbytesLsK85bL5bzBrg3AwLdufVQ7LJxMze7jd0CL5FbaPxxKf3y64AsDUgLA1C40xO8Y/ai0wn8+kMov/6qNJdL34i6uOJJpEKCOONh67/PU+dN5pSts/wAJsCfMwus6ykoaqZa5+7UAyIlNjPbvmzaVYyCsF494V1fbU9vZmP5t+/1S+fyTgaZmbbf71R9iggSjHrEIRHPUVTu8v9e8AGA4ccPQdTJ1LpggpI7fgPJJNQ2L8S2Fkl6KRatS5Ou00TP04dcOAsy5uVWin6lx/b09w9LmCC3Zvw40D/Y2Le6GtQ7SN7Rb4YDx3W4i/0JmC458L8oPULrq31M8BTQaS+RqA41mx383PjPTn5uuFIJf5Qa7QH9Dzk//JVOy86plfx6at9OSBA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(46966006)(40470700004)(356005)(426003)(107886003)(336012)(83380400001)(70206006)(47076005)(1076003)(186003)(36756003)(5660300002)(2906002)(8676002)(8936002)(4326008)(316002)(70586007)(54906003)(26005)(7696005)(2616005)(110136005)(81166007)(40460700003)(82310400005)(86362001)(508600001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 21:26:11.1760
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67b174a2-5b02-4ed8-ae13-08da4e4c80e2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6084
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds use of KBUILD_MODNAME as defined by the build system,
replacing the definition and use of a custom-defined name.

Signed-off-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 84621b4cb15b..b03e1c66bac0 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -19,8 +19,6 @@
 #include "mlxbf_gige.h"
 #include "mlxbf_gige_regs.h"
 
-#define DRV_NAME    "mlxbf_gige"
-
 /* Allocate SKB whose payload pointer aligns with the Bluefield
  * hardware DMA limitation, i.e. DMA operation can't cross
  * a 4KB boundary.  A maximum packet size of 2KB is assumed in the
@@ -427,7 +425,7 @@ static struct platform_driver mlxbf_gige_driver = {
 	.remove = mlxbf_gige_remove,
 	.shutdown = mlxbf_gige_shutdown,
 	.driver = {
-		.name = DRV_NAME,
+		.name = KBUILD_MODNAME,
 		.acpi_match_table = ACPI_PTR(mlxbf_gige_acpi_match),
 	},
 };
-- 
2.30.1

