Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C19557443
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbiFWHqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiFWHqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:46:46 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC05B46B3B;
        Thu, 23 Jun 2022 00:46:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tg/tehgpQipynJiWXhs14mlbGTUzFkBN77uqIHTA6UxRNlEUZx9bs3d+eULYxJlIwqGqcnidXjJSUv6UNi4doRoeEpe2zxJCTukycexlVO9W7xUL8h4gW9dQGPyKXsysx3yX2yDn/pXyh3+3N5GSMPwAc3I5XsRhUWAjE2cqU6jDs0lDlG5cWb5lmBoUCfRTm7sQ5meZYXkWPHBn5E23UrY74xf3zoEm/ghMWkBISkztMUXelJ4MVh5VdNslSt9xIUjnKj6/TpB+DjRBCaGN1o9aPcAt8A1wZqvtMQXe4+spugNzcgRNEs/f7FUrJRDxxQeYxXKZTLltahF+mJtZrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U4zZt4PoIT5NPRkdhm9OYO2gcnN+PnXtnKtYzei29tY=;
 b=bMXQdgr54YwTHHYB5cLpKmH+KHe+aBwtdlSGuBpBM4ZOiWD3AvWx7aqkwiwt2qWW7YLN/WK/Fh62X+L5QH66SC78XgmosxTuHHIQuLsT3lhDWTITLN7jYNswtlZeNrlEUR52HUk3+bXil5bmyKRbsMNHxF/PJLrsWeaLp+Kz9iIsedVxml5pA7O+Do4gJVIYdAVP6WltDIDRMeVDRKIdkxelqdo3ussDVAco1NDhidQetcbrAQXbhlCJqplOs2B+MwMDDE80ry6iqmE7o2+zXlk5oX24gZPH5adsybe0h8NMoKEcKduAferA3Cow9xfny4E7qaA+rTYDfl7LPhZFpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U4zZt4PoIT5NPRkdhm9OYO2gcnN+PnXtnKtYzei29tY=;
 b=f+5xja33c2TByiYKTSOh1D5o9H3llslsBSSgEe5Ztng6oe/oMP4x9WSYNf7/ZJ5wSeLv0zC2cRiGMKNf41PWO80o6cKR2ISpuM34gG50vizTOJs02RRf6Aof17QU1pKr00IsM6y5+wF4nj4oLRorNQFDJ515bYdX+ta0SHD0X9L5IE8sNp872CoMDdRwi4umUuXJ05N4pfzyA/v7Bcw0aNvXGcMQvmX2PGIBarYKxe+g3DoiiINbybOet1nvHlSRUg1ASdK9hWxiLop6nvNGMOAYgo8RS+mYHb40/CsMnb0XznSjv+lokIO7ZECh2n6zKFsvFEZ86hBnwx8rDTrkJA==
Received: from BN9PR03CA0393.namprd03.prod.outlook.com (2603:10b6:408:111::8)
 by MN2PR12MB3485.namprd12.prod.outlook.com (2603:10b6:208:c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 07:46:42 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::d0) by BN9PR03CA0393.outlook.office365.com
 (2603:10b6:408:111::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16 via Frontend
 Transport; Thu, 23 Jun 2022 07:46:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 07:46:42 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 23 Jun
 2022 07:46:41 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 00:46:40 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.26 via
 Frontend Transport; Thu, 23 Jun 2022 00:46:37 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v1 1/9] dt-bindings: power: Add Tegra234 MGBE power domains
Date:   Thu, 23 Jun 2022 13:16:07 +0530
Message-ID: <20220623074615.56418-1-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a803b06f-b6e4-4222-7900-08da54ec838d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3485:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3485DCD2541E1C51FDB530FFAFB59@MN2PR12MB3485.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m2UnNdCMaFLVHrkeSGCt9XlpoKts5/94NCiLAc7IMxdz1MqgA1u0oxpe07L0r7teNQKfR18h7pXjnoUbV81a/h3/iUP6gUL2PfqDVMj2Yk4QRB9liKNZFhSlmN0R4GumyckHAUS4BlZsHGjRGWC1W8oDeyoksZwN0JfFJWDMiBEIKb9QOLcpgBf6JT187cPVO/s2QQ7FIDxAn/gmTLJRyvfaI0dy4ovm3p93PtI5D9TbOiccVxoqLCrzZ63qEqowENbQXB39fdWbBkx1DWpDoLFdPwD2++a6LMg95Qt3KWZwLfVqR+/PaD/60jc/wXqItdu/jQ0xgSNK0p5r+cuIkepFbr+4y0G5CN/4/+KgQD+zKmH/1IdrpAbjlusnrHM7KyADUV+HlAUnfEr4g2dAEGjXyBOfZYlJmoGCCdeoNV71J4jqMjwUNL/WJM/YBe/yauScX6XtwqFnTR/RBoYB4NX7YDriYMqquDuokrN4Ru5mBxB4jvcweKhnFJAqeoaU8eg/5mWxoBOeD+BoIpj73zgbuZJuWy6gJo3aSP7r64rvybHaJj2Wq1DtoLu5z9ellJ0JRK/iGTL9F9kgVdNhqd7PgfrH+KtpiATBbYUmBlB6bCsMHS4ldEzKkuzJa9XqRpJE1p1CMP0E5qPOAodvPvKSQJP6bplRnxH3Zk6M2dixDx9ssEIpzopvJYQUxt0/3jazilJ9IWGI4uOP+q5/ZQO9PJB3Nq7UTpnrMPrDpEfiVj1Fdwwf2DK5LUzK28iFN4+59zzis5H4T5qXpV2LwOAZUd2ZOTr5PTJpsixecc4=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(346002)(396003)(36840700001)(40470700004)(46966006)(7696005)(356005)(82740400003)(6666004)(82310400005)(4744005)(316002)(2906002)(336012)(54906003)(36860700001)(426003)(186003)(2616005)(47076005)(110136005)(107886003)(86362001)(36756003)(1076003)(40480700001)(8936002)(41300700001)(70586007)(478600001)(70206006)(8676002)(4326008)(26005)(40460700003)(81166007)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:46:42.0573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a803b06f-b6e4-4222-7900-08da54ec838d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3485
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

Add power domain IDs for the four MGBE power partitions found on
Tegra234.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
---
 include/dt-bindings/power/tegra234-powergate.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/power/tegra234-powergate.h b/include/dt-bindings/power/tegra234-powergate.h
index f610eee9bce8..df1d4dd8dcf3 100644
--- a/include/dt-bindings/power/tegra234-powergate.h
+++ b/include/dt-bindings/power/tegra234-powergate.h
@@ -18,5 +18,6 @@
 #define TEGRA234_POWER_DOMAIN_MGBEA	17U
 #define TEGRA234_POWER_DOMAIN_MGBEB	18U
 #define TEGRA234_POWER_DOMAIN_MGBEC	19U
+#define TEGRA234_POWER_DOMAIN_MGBED	20U
 
 #endif
-- 
2.17.1

