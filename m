Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D269C567C6A
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 05:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiGFDNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 23:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbiGFDNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 23:13:37 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF36111449;
        Tue,  5 Jul 2022 20:13:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvvT+fVc8SsFARcVmwUOeJlnXkzUrCJxLxgaxUlyDTtxasTlTyWM51NNuVOQrMXCBz0jd5mlteqHj0S8tcSgTZYGGns32Nu5AKpWHdfi2HcbyWz8i6QbagMCVEISkCT7M0mv3khfJ9xFhZRMb11ATbjn4TTr/m3WUOsPFq5SlTWJs5eL1SaaWP041sMxy6HjwP5EwpfNy0Ghm3/l0newZOaBedGWWCGmziqqh4ZOpbn+N5ah8OuRp2ff8CSrIQ7Hf8QlXX29NQBxuIJjgUshXOrkFhfszykYNEFSuPllaWWhbqfTK89oL91HfZI0ehaMilwNPxxQdmTFfSOjNDSaAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tiKTMbWpq3/WGSsqSsMdE68z9XVapnouuuUr8tAHKUQ=;
 b=YAuIwCViz0XG62yb2jU2HFLam/2VThNEFXM5rIFqItECNPpZP4G6f7Tqv/VqayNOROPhbpMjkHR1S4dV4vv26YiflHJ+e/3uiSp94220kmY7O0uzg6Rp4DcWys90DgUSb8do4wF5pDLdxb3+kdVBeUz9UiS8/NoKxUlOPN5odLYhb2het5h8IQJA7mlv2qC5E+lw7NpgxkTT8UffFFSrQtqCl4sURWJFMUvwNzsDBxPMdzH4la6MRGHOrHvSPcMeQsMRV4dSSg3jFyKyAjpsMJviofppr58jmnUIOW3l8WT88RWe5kA2oY6ZToqPgB92dEzxPpSY2WL/7vmVM+n0Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tiKTMbWpq3/WGSsqSsMdE68z9XVapnouuuUr8tAHKUQ=;
 b=OrNo8b9mfRvnzxI6Brfng48scVl2CJ0BUyoiAxtQKTfXmxhjFC+hPryF7Ksh4qcsvQgnowDnaTnyR9i5eqQzFnbWUB7kTFbfLbG9nrJkvrLLKpurdub8pfM3bHi/ak1+BZAgO0P+JXsZGDsOW7HrjRC01bTo0qMtjXV5zhEinVqzxN/E38Fyg2IDt1iI98eUPJmtdVqX1Ri0Kw2kYi6WlYqdY8RWKHBdqZ+m6hvDLg8WNZArItO9HupbyXO1VHb996zKidWZc2640ul2yQH6Fjc2+qJhnmtLBfitSBMDpP5hy9IVp2QVG4uu62UbrtxDe04qtN6hWFvf4UJwpjxMkQ==
Received: from MWHPR19CA0056.namprd19.prod.outlook.com (2603:10b6:300:94::18)
 by DS7PR12MB5790.namprd12.prod.outlook.com (2603:10b6:8:75::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Wed, 6 Jul
 2022 03:13:32 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:94:cafe::ef) by MWHPR19CA0056.outlook.office365.com
 (2603:10b6:300:94::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.22 via Frontend
 Transport; Wed, 6 Jul 2022 03:13:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Wed, 6 Jul 2022 03:13:31 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 6 Jul 2022 03:13:31 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 20:13:30 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26
 via Frontend Transport; Tue, 5 Jul 2022 20:13:27 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        <pabeni@redhat.com>, <davem@davemloft.net>, <edumazet@google.com>,
        Thierry Reding <treding@nvidia.com>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v2 4/9] memory: tegra: Add MGBE memory clients for Tegra234
Date:   Wed, 6 Jul 2022 08:42:54 +0530
Message-ID: <20220706031259.53746-5-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220706031259.53746-1-vbhadram@nvidia.com>
References: <20220706031259.53746-1-vbhadram@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f3ad275-6d1a-442d-f77a-08da5efd817d
X-MS-TrafficTypeDiagnostic: DS7PR12MB5790:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C6JQOpYM6cwE3k65jjS7VBS//KoblMKv1j4pM0Vmtov9wGebhZ3FOwunkKmu/Ab3AwBymsavAyuXnUXJaPgLbuxRf9a3u2AuUnPCFMz1IGZWhVlJk/X8rVjw+S52jxDWMffb52mFj+hIh78EQ3x2zKx1Q84PIsPvJLP10kNgx815E3sOoVOjIoy2AMk0C3Bxe3komQoCot+bjcugPzz5eKJLkUryPcug2PURTWeLWqSPC9kI/E70Ub/hT3E1GFTiLyaBwPSeVS3RIasnd8CvMetY1CKpdZiHOksLShwcmj+mWoa8PECMmrey4RlnwmZXzpm59Ge3zgxfwvC0Gvj98xqIGeL/y/Pu3WZlDE1LvdZKA1oH1/eCcjaATYMdsCaC6mg3nielb+74BDk/qVtdjRw98D25QRGBG7FmYUyQ3ntFLVrWH9PEeMl+0teRbF7tTuVKq7uA08i7DBshQH4NKOHtnWSMCbb2sW8e47gUEKuHHfUZppaExtO89TeExYdX5fu808kfqy7KU/BFAnbMpfVN0lQ6bd9Z6aoqIh6e29AoRLVbg75FHLtgBaShDEsDuuvv+GaM4YI6qf81X1hk3P+lzi1kHNDSHFYRp1kfrMJD+J/lqB+6dW2mUGrMtA1JcOccXXJVnON16IT8jN5hBl3T4HGAZsqXbvlI2smjbY0iP+R/n3tSFXS0VbTgqhrsmT82XQqhWU2dpQ2BeAfzeBplLVCIfmj2MMA8M7ennlaJNeqBmiLva+bNVB5clQI5iCd2XR2GL8k5v2tgwi0556GF/zN9qQO3FYd4RO4vUSuX9X8wMrNZgRqpT+EEgVN8R1bY5WY+WXjgsD6YhZUehf/cDas2Zihyn7ynwUJQe8g=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(136003)(39860400002)(40470700004)(46966006)(36840700001)(26005)(2906002)(478600001)(7696005)(6666004)(41300700001)(4326008)(82740400003)(86362001)(36756003)(81166007)(40480700001)(82310400005)(8676002)(107886003)(40460700003)(426003)(186003)(336012)(2616005)(47076005)(1076003)(316002)(5660300002)(8936002)(54906003)(83380400001)(36860700001)(356005)(7416002)(110136005)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 03:13:31.7505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3ad275-6d1a-442d-f77a-08da5efd817d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5790
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

