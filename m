Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC9555744C
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiFWHrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiFWHq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:46:58 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E1C46C82;
        Thu, 23 Jun 2022 00:46:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/98yXjZP2gtA0uriZpkusL4HIR2XQdj3zNHYmZERkKfPd1tPwxSvzjiqoOw7Dvseknb+DUxxv/KgK/yPWaEJAtj6VkdZtZwH9ZEe3XrbGf5zGEdbWv25j6nvRyRvkWoZkKDSmWYs/Fs5dA6Jb1EMheAdfzyObKsRg4rsQXq/0e//7u3mHb9qHN8q3HOkHn32dnDArehISk5I6AKDfZblxjHbd3PyKsNUgPhb78fBEpKS1T+TwZlWqT/DyJ5eiWpOf2ltKndDYR6QhzwZb9/vGrn4ACr6rUvvNcg8lYvyzP+qE7OyGwCsDaTVkqA1amwLN87iigXygI9c/BGzh1z3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tiKTMbWpq3/WGSsqSsMdE68z9XVapnouuuUr8tAHKUQ=;
 b=hoHdigbaUjsvxIJ7+8Yd75wetzKjLca68L7iVhVLlrwlsTVr+U2/Xg3hSyKuOAbdSwZUtWJm4AmK6YO4ih8UinQStsLekv+9jwZLsyIXnYSFYdPqbhlzaB170kq+uLxB2pS7U1Lc6xoT3/D3IaKVzhSWtE7YDZR0HhT5DQiZaCKFE6U1CJ3HWN8t+7z4Cwr5MWiKqraCYYE9pdKjuIbAR+nvaU2rmHqR62/0tlAfxpEd0Xk6Slmicm2D2dV7TxUvCMPwZ+VQ12GUAsgCsIIEbUdAqhtaAFKogSHJhtvLFpGfHGqKW5VKBlXzEblgAvVZXnwp2CcFQ05YyuMjaPz63Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tiKTMbWpq3/WGSsqSsMdE68z9XVapnouuuUr8tAHKUQ=;
 b=PZYB1sLOVn7ryuEZbO6TAX2+3OBRO3hEefCfWN+PgxcgOz4U/iOxkPqiJ+QP/F2K2OPZRpohVNrrdXX/tlrcv/8E5ihPVix/PF8ZJl2ADWX9Dc14Z+kBZGZIBwW3gZrEt6hnAiEPjrjaOqr23bYOL8+e7sPKUsi8L3OhG92NbDZVw8B+rz+UIuPw+j29eU4M7dFQSP3VlE2qahx5T7fDE6h53I38qpwby20yD+HKBd4caKs4805E+pkTljG9pnNPd7UcRrG48S+s1BLhR82FlH1zEhP438EAMB37y9sty9/Bm7Dmsr7E+/rYa8dVg7JyxrOiYJML0dSRGPPpJNcUfw==
Received: from MWHPR04CA0064.namprd04.prod.outlook.com (2603:10b6:300:6c::26)
 by CY4PR1201MB0232.namprd12.prod.outlook.com (2603:10b6:910:21::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Thu, 23 Jun
 2022 07:46:54 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:6c:cafe::72) by MWHPR04CA0064.outlook.office365.com
 (2603:10b6:300:6c::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16 via Frontend
 Transport; Thu, 23 Jun 2022 07:46:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 07:46:54 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 23 Jun
 2022 07:46:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 00:46:52 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.26 via
 Frontend Transport; Thu, 23 Jun 2022 00:46:49 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v1 4/9] memory: tegra: Add MGBE memory clients for Tegra234
Date:   Thu, 23 Jun 2022 13:16:10 +0530
Message-ID: <20220623074615.56418-4-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220623074615.56418-1-vbhadram@nvidia.com>
References: <20220623074615.56418-1-vbhadram@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a1c1b2d-65fb-4184-fe33-08da54ec8aa1
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0232:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB02326D4B0B34C84CD9D8C619AFB59@CY4PR1201MB0232.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LhY5F003ggjdnNI1VMW8yHC9e0HCKk24wBILPktVdzz+fbqwvQxPx6CtDhtPTLxpvwzHtKhOxKYHqmoo4lVxBRS8EA7tlr1EExs0Okygfr+lExvLnmpJLkIHy8Kjqp4xZjUyKuFbE86BXe6ku/vJ8WhWt3VIIzAtSy1/h1uWF9hlDFFw3WQO517P4RRmg7PUfrLRKhUWfVnBCzvJDP0SDvfyTW4BpkxvvS7ixPo7dIiAwlBIMIfZ8jaRHeJloII9eCdfml1jadj552VBthwb6RaCLC+xO3K1fcaBYBMBrlZ7SVlYawBWsEwCxRELcVffJVc4YJfKYDENLFFHW+PlADTpznxLIZK+HDo2V9d3qlJBlOW6xqA2mxi1qkIm8Vdn4JybFFA3t02UM8nNPhJPpEOJzaKU7rAb0RNLs5aBQYf8zAzMvlADfmpGKsNdZ6W2o534FmJQOMj3BEzTRXpKGz9+E+tn99Sa3RouU+Mm4BqNEyqE84cKPXKQHS3LU0Dwmai8iSS3Z+xh6U7A1yzGISKmr28wAXyURTiQPLHSP18ssCdxSXikeiovkRNZTeCWgErmhvOO2BxugiYrI9v7EZOP2ItDPxvgW5Qqiv6QfDaNeMC81tSvb0s1umPx49sbW0EYjuJiBEHu5fE0nKyrWYaBTe4kw/KZtX1rHUVhJAozkRvjkDq7c4PsSbz5hDRKZTjmqNmntcNUQ+qYuEQFnftzcXB87sb4jHW4+JRlZSq0RuepIqedoSGMdk5ct4jMTX7r4MqU69f3U/vkJQ3bAemD8NCCgJVpQmtpitnLOxc=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(396003)(39860400002)(46966006)(40470700004)(36840700001)(81166007)(186003)(47076005)(82310400005)(40480700001)(83380400001)(8676002)(82740400003)(336012)(36860700001)(2616005)(426003)(41300700001)(1076003)(4326008)(36756003)(316002)(5660300002)(2906002)(86362001)(40460700003)(54906003)(26005)(7696005)(110136005)(70586007)(6666004)(107886003)(478600001)(8936002)(356005)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:46:54.0296
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a1c1b2d-65fb-4184-fe33-08da54ec8aa1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0232
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Tegra234 has multiple network interfaces with each their own memory
clients and stream IDs to allow for proper isolation.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
---
 drivers/memory/tegra/tegra234.c | 80 +++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/drivers/memory/tegra/tegra234.c b/drivers/memory/tegra/tegra234.c
index e23ebd421f17..a9e8fd99730f 100644
--- a/drivers/memory/tegra/tegra234.c
+++ b/drivers/memory/tegra/tegra234.c
@@ -11,6 +11,76 @@
 
 static const struct tegra_mc_client tegra234_mc_clients[] = {
 	{
+		.id = TEGRA234_MEMORY_CLIENT_MGBEARD,
+		.name = "mgbeard",
+		.sid = TEGRA234_SID_MGBE,
+		.regs = {
+			.sid = {
+				.override = 0x2c0,
+				.security = 0x2c4,
+			},
+		},
+	}, {
+		.id = TEGRA234_MEMORY_CLIENT_MGBEBRD,
+		.name = "mgbebrd",
+		.sid = TEGRA234_SID_MGBE_VF1,
+		.regs = {
+			.sid = {
+				.override = 0x2c8,
+				.security = 0x2cc,
+			},
+		},
+	}, {
+		.id = TEGRA234_MEMORY_CLIENT_MGBECRD,
+		.name = "mgbecrd",
+		.sid = TEGRA234_SID_MGBE_VF2,
+		.regs = {
+			.sid = {
+				.override = 0x2d0,
+				.security = 0x2d4,
+			},
+		},
+	}, {
+		.id = TEGRA234_MEMORY_CLIENT_MGBEDRD,
+		.name = "mgbedrd",
+		.sid = TEGRA234_SID_MGBE_VF3,
+		.regs = {
+			.sid = {
+				.override = 0x2d8,
+				.security = 0x2dc,
+			},
+		},
+	}, {
+		.id = TEGRA234_MEMORY_CLIENT_MGBEAWR,
+		.name = "mgbeawr",
+		.sid = TEGRA234_SID_MGBE,
+		.regs = {
+			.sid = {
+				.override = 0x2e0,
+				.security = 0x2e4,
+			},
+		},
+	}, {
+		.id = TEGRA234_MEMORY_CLIENT_MGBEBWR,
+		.name = "mgbebwr",
+		.sid = TEGRA234_SID_MGBE_VF1,
+		.regs = {
+			.sid = {
+				.override = 0x2f8,
+				.security = 0x2fc,
+			},
+		},
+	}, {
+		.id = TEGRA234_MEMORY_CLIENT_MGBECWR,
+		.name = "mgbecwr",
+		.sid = TEGRA234_SID_MGBE_VF2,
+		.regs = {
+			.sid = {
+				.override = 0x308,
+				.security = 0x30c,
+			},
+		},
+	}, {
 		.id = TEGRA234_MEMORY_CLIENT_SDMMCRAB,
 		.name = "sdmmcrab",
 		.sid = TEGRA234_SID_SDMMC4,
@@ -20,6 +90,16 @@ static const struct tegra_mc_client tegra234_mc_clients[] = {
 				.security = 0x31c,
 			},
 		},
+	}, {
+		.id = TEGRA234_MEMORY_CLIENT_MGBEDWR,
+		.name = "mgbedwr",
+		.sid = TEGRA234_SID_MGBE_VF3,
+		.regs = {
+			.sid = {
+				.override = 0x328,
+				.security = 0x32c,
+			},
+		},
 	}, {
 		.id = TEGRA234_MEMORY_CLIENT_SDMMCWAB,
 		.name = "sdmmcwab",
-- 
2.17.1

