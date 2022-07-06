Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0FF4567C60
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 05:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiGFDNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 23:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbiGFDN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 23:13:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164B910E1;
        Tue,  5 Jul 2022 20:13:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GD+4PTAOtOqhgUhzYRSJWR+kSgO8PODkGuLgDWJI7YwvFfYN2NtRqGoXKPiZGNu0+dDrUsB7BYC4RqYdjxld7v8PZnFBVSO4Nw7q3LR3ePCJK2rFsnFk2FVj+HIxU9ZxDeCLR1jq7SpP4Eye5QdymaSAiy1MIdfAf9bdDQZWC8NpTmkIX+CUHTIvG6sw4mh5mkdPxZ+LbPvlrYJj2sLn6/+sv1GFLH0IwkKk0EbwG6qvVdIVvELTuz36kED75CA05OXb7lAtg2fCqn/DJUn95I3cnkQ5MwVUwd0kTtKPhQxZj6kVmLd3H8C8868Pv2zSfPq7szzOssN0KVEx3fQpqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jSmPgUbrgSv2fJrSdfo/GxXDMO2ZXJl+wlnQXzeLsA4=;
 b=VJcxzQplLBFC0rypR4fR4IYAJggpeuJFAS2f/DhL7XKrMhMylzigWD3tkOeimKwApUSP52Osm5TCtAXwHCXSqbGzBLYjxPUi8D5vz7a4xT4Qfgb8HpomPZw4VGAOQxW58qTmD4EAb0tOIwAMeH+MgO+Y4at7eCtA8Da32Qi8elczksVQ+w3asOpLPEM64B7B+KuhxAVhmuEqPyA5fGGDyutNuWcBPzQBAllSuyybrn4+7j7Tp0NWYpzZpEA0+pDwEtP3zveDlky+XIRZ8SiNtwVUi1CREwD9B6hAMH3XalpxM3DZJv7kYwefII/p2yhuBQ7IuWHzB3MECRXypDdxLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSmPgUbrgSv2fJrSdfo/GxXDMO2ZXJl+wlnQXzeLsA4=;
 b=CYcWWTJkqbVyQ6cg/mCWaI0tm2ipFx6dvCSKVHp6smi42hjd3drQHhxu/0Nd72Po0Jx7R5fWCYaDm0s+HHIGOf+T9SrHqhQ22lrgpiBZsT4xin//mfbqF8muAwNddJWnvSDL8QYa9/Z/exnY6dZ1nWGsko5B09J1LRuSXdDcseEG/BrMfO2BOQL/TMnEz81aWB3uylgaeWzdlFPGMNegEQHNSL14MtNa/wquvmYDJsTFfwlS5a0xLvOa81iprx+f2k9Z8W6agaxHjINiLAneTK2/RTtR0Iicj+VtRS2/wXOL5vNT13xAWE4IJ28UjJ6qt+L/yjvGFS2mfF5+zplRhg==
Received: from MW4PR04CA0095.namprd04.prod.outlook.com (2603:10b6:303:83::10)
 by MN2PR12MB2944.namprd12.prod.outlook.com (2603:10b6:208:ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Wed, 6 Jul
 2022 03:13:23 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::93) by MW4PR04CA0095.outlook.office365.com
 (2603:10b6:303:83::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Wed, 6 Jul 2022 03:13:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Wed, 6 Jul 2022 03:13:23 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 6 Jul 2022 03:13:22 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 20:13:22 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26
 via Frontend Transport; Tue, 5 Jul 2022 20:13:18 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        <pabeni@redhat.com>, <davem@davemloft.net>, <edumazet@google.com>,
        Thierry Reding <treding@nvidia.com>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v2 2/9] dt-bindings: Add Tegra234 MGBE clocks and resets
Date:   Wed, 6 Jul 2022 08:42:52 +0530
Message-ID: <20220706031259.53746-3-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220706031259.53746-1-vbhadram@nvidia.com>
References: <20220706031259.53746-1-vbhadram@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34b7bf90-b70b-4c14-e853-08da5efd7c64
X-MS-TrafficTypeDiagnostic: MN2PR12MB2944:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +PpWpdO1uUIn96nztHBCqJw/2kGPxhHQzRNm1DmtA5BmXm0LxDRBFJFGW/zfn9qljuWhvHKwE77C9tdJD16xIUjm28pSBetWyAXryg3HHZIhWf/BTbS2KKgzyvskTaWvh5KgHpTgIz+JvMYi6plP6JtqMbXyGZyC4Z6BkeSjgrqnQeqQxDRFK3ciVK7/0CRqiW12b/tvdadp8GMdIbo62AEYQB80OCV7NG31X7/rNNqpYWhnBjJCM8GBzMizOcCZakBPcYcptMUyaPMKBx52G+hR5Ftgsl0kK5ok7OCe7NZAMsNCgu5Vzyqf0gzTD9aD7pUZC8J3q7d4f8bZMSKe9nbjOruUwcgb+bakRs+OM7kGFjYllLViiLf3W68fhWoCiIbbRQj9ABmy0jVrIruUSoLVUjM0AFuEa4UM18knMAh7HcaFIWz2YNUiEOs+YsJXZOw+po8N7ZeYisSYyG+FonV4YkdaF2oLpRr0G+nz1rf1TVd6T/gkmUZ9tXFyLMjjlwW1LwRRTtgPHRjps13+4EG0smB5nWR25KKtSQ8insH/lMRJK+teX2+IXoOGAAGqDqeEauYpimSDuR/158MC97RbnrK8YBniTjn7i7uqynZepfa2jpny3hrxLKf2tgu6J6Gir/BqekqKJ7H0cBIlPjzMzF6WFqFqeL79Docv0xQ8vAdDgzVn/u8398m30CjzXTiKMgSFcqL2UMe/FXYmY4nFWDdt69anmJD72CnsQ3iAG5ztpvv9HPakGcDw9X6WsT09hvnNJG2nTwaD8O5SlxZ6kXjF0Zge4YzZdL4tk3xoSScSgvpe9L06rBg9jJ6F+W0ZsnnOotNc/pCDBl3LDCZsMOJyWeNzApnlxDZFwaA=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(36840700001)(46966006)(40470700004)(47076005)(26005)(336012)(426003)(70206006)(70586007)(83380400001)(41300700001)(2906002)(8676002)(4326008)(5660300002)(107886003)(7416002)(1076003)(8936002)(2616005)(478600001)(40460700003)(186003)(36860700001)(110136005)(54906003)(36756003)(356005)(81166007)(7696005)(40480700001)(316002)(6666004)(82310400005)(82740400003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 03:13:23.1821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34b7bf90-b70b-4c14-e853-08da5efd7c64
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2944
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

Add the clocks and resets used by the MGBE Ethernet hardware found on
Tegra234 SoCs.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
---
 include/dt-bindings/clock/tegra234-clock.h | 101 +++++++++++++++++++++
 include/dt-bindings/reset/tegra234-reset.h |   8 ++
 2 files changed, 109 insertions(+)

diff --git a/include/dt-bindings/clock/tegra234-clock.h b/include/dt-bindings/clock/tegra234-clock.h
index bd4c3086a2da..bab85d9ba8cd 100644
--- a/include/dt-bindings/clock/tegra234-clock.h
+++ b/include/dt-bindings/clock/tegra234-clock.h
@@ -164,10 +164,111 @@
 #define TEGRA234_CLK_PEX1_C5_CORE		225U
 /** @brief PLL controlled by CLK_RST_CONTROLLER_PLLC4_BASE */
 #define TEGRA234_CLK_PLLC4			237U
+/** @brief RX clock recovered from MGBE0 lane input */
+#define TEGRA234_CLK_MGBE0_RX_INPUT		248U
+/** @brief RX clock recovered from MGBE1 lane input */
+#define TEGRA234_CLK_MGBE1_RX_INPUT		249U
+/** @brief RX clock recovered from MGBE2 lane input */
+#define TEGRA234_CLK_MGBE2_RX_INPUT		250U
+/** @brief RX clock recovered from MGBE3 lane input */
+#define TEGRA234_CLK_MGBE3_RX_INPUT		251U
 /** @brief 32K input clock provided by PMIC */
 #define TEGRA234_CLK_CLK_32K			289U
+/** @brief Monitored branch of MBGE0 RX input clock */
+#define TEGRA234_CLK_MGBE0_RX_INPUT_M		357U
+/** @brief Monitored branch of MBGE1 RX input clock */
+#define TEGRA234_CLK_MGBE1_RX_INPUT_M		358U
+/** @brief Monitored branch of MBGE2 RX input clock */
+#define TEGRA234_CLK_MGBE2_RX_INPUT_M		359U
+/** @brief Monitored branch of MBGE3 RX input clock */
+#define TEGRA234_CLK_MGBE3_RX_INPUT_M		360U
+/** @brief Monitored branch of MGBE0 RX PCS mux output */
+#define TEGRA234_CLK_MGBE0_RX_PCS_M		361U
+/** @brief Monitored branch of MGBE1 RX PCS mux output */
+#define TEGRA234_CLK_MGBE1_RX_PCS_M		362U
+/** @brief Monitored branch of MGBE2 RX PCS mux output */
+#define TEGRA234_CLK_MGBE2_RX_PCS_M		363U
+/** @brief Monitored branch of MGBE3 RX PCS mux output */
+#define TEGRA234_CLK_MGBE3_RX_PCS_M		364U
+/** @brief RX PCS clock recovered from MGBE0 lane input */
+#define TEGRA234_CLK_MGBE0_RX_PCS_INPUT		369U
+/** @brief RX PCS clock recovered from MGBE1 lane input */
+#define TEGRA234_CLK_MGBE1_RX_PCS_INPUT		370U
+/** @brief RX PCS clock recovered from MGBE2 lane input */
+#define TEGRA234_CLK_MGBE2_RX_PCS_INPUT		371U
+/** @brief RX PCS clock recovered from MGBE3 lane input */
+#define TEGRA234_CLK_MGBE3_RX_PCS_INPUT		372U
+/** @brief output of mux controlled by GBE_UPHY_MGBE0_RX_PCS_CLK_SRC_SEL */
+#define TEGRA234_CLK_MGBE0_RX_PCS		373U
+/** @brief GBE_UPHY_MGBE0_TX_CLK divider gated output */
+#define TEGRA234_CLK_MGBE0_TX			374U
+/** @brief GBE_UPHY_MGBE0_TX_PCS_CLK divider gated output */
+#define TEGRA234_CLK_MGBE0_TX_PCS		375U
+/** @brief GBE_UPHY_MGBE0_MAC_CLK divider output */
+#define TEGRA234_CLK_MGBE0_MAC_DIVIDER		376U
+/** @brief GBE_UPHY_MGBE0_MAC_CLK gate output */
+#define TEGRA234_CLK_MGBE0_MAC			377U
+/** @brief GBE_UPHY_MGBE0_MACSEC_CLK gate output */
+#define TEGRA234_CLK_MGBE0_MACSEC		378U
+/** @brief GBE_UPHY_MGBE0_EEE_PCS_CLK gate output */
+#define TEGRA234_CLK_MGBE0_EEE_PCS		379U
+/** @brief GBE_UPHY_MGBE0_APP_CLK gate output */
+#define TEGRA234_CLK_MGBE0_APP			380U
+/** @brief GBE_UPHY_MGBE0_PTP_REF_CLK divider gated output */
+#define TEGRA234_CLK_MGBE0_PTP_REF		381U
+/** @brief output of mux controlled by GBE_UPHY_MGBE1_RX_PCS_CLK_SRC_SEL */
+#define TEGRA234_CLK_MGBE1_RX_PCS		382U
+/** @brief GBE_UPHY_MGBE1_TX_CLK divider gated output */
+#define TEGRA234_CLK_MGBE1_TX			383U
+/** @brief GBE_UPHY_MGBE1_TX_PCS_CLK divider gated output */
+#define TEGRA234_CLK_MGBE1_TX_PCS		384U
+/** @brief GBE_UPHY_MGBE1_MAC_CLK divider output */
+#define TEGRA234_CLK_MGBE1_MAC_DIVIDER		385U
+/** @brief GBE_UPHY_MGBE1_MAC_CLK gate output */
+#define TEGRA234_CLK_MGBE1_MAC			386U
+/** @brief GBE_UPHY_MGBE1_EEE_PCS_CLK gate output */
+#define TEGRA234_CLK_MGBE1_EEE_PCS		388U
+/** @brief GBE_UPHY_MGBE1_APP_CLK gate output */
+#define TEGRA234_CLK_MGBE1_APP			389U
+/** @brief GBE_UPHY_MGBE1_PTP_REF_CLK divider gated output */
+#define TEGRA234_CLK_MGBE1_PTP_REF		390U
+/** @brief output of mux controlled by GBE_UPHY_MGBE2_RX_PCS_CLK_SRC_SEL */
+#define TEGRA234_CLK_MGBE2_RX_PCS		391U
+/** @brief GBE_UPHY_MGBE2_TX_CLK divider gated output */
+#define TEGRA234_CLK_MGBE2_TX			392U
+/** @brief GBE_UPHY_MGBE2_TX_PCS_CLK divider gated output */
+#define TEGRA234_CLK_MGBE2_TX_PCS		393U
+/** @brief GBE_UPHY_MGBE2_MAC_CLK divider output */
+#define TEGRA234_CLK_MGBE2_MAC_DIVIDER		394U
+/** @brief GBE_UPHY_MGBE2_MAC_CLK gate output */
+#define TEGRA234_CLK_MGBE2_MAC			395U
+/** @brief GBE_UPHY_MGBE2_EEE_PCS_CLK gate output */
+#define TEGRA234_CLK_MGBE2_EEE_PCS		397U
+/** @brief GBE_UPHY_MGBE2_APP_CLK gate output */
+#define TEGRA234_CLK_MGBE2_APP			398U
+/** @brief GBE_UPHY_MGBE2_PTP_REF_CLK divider gated output */
+#define TEGRA234_CLK_MGBE2_PTP_REF		399U
+/** @brief output of mux controlled by GBE_UPHY_MGBE3_RX_PCS_CLK_SRC_SEL */
+#define TEGRA234_CLK_MGBE3_RX_PCS		400U
+/** @brief GBE_UPHY_MGBE3_TX_CLK divider gated output */
+#define TEGRA234_CLK_MGBE3_TX			401U
+/** @brief GBE_UPHY_MGBE3_TX_PCS_CLK divider gated output */
+#define TEGRA234_CLK_MGBE3_TX_PCS		402U
+/** @brief GBE_UPHY_MGBE3_MAC_CLK divider output */
+#define TEGRA234_CLK_MGBE3_MAC_DIVIDER		403U
+/** @brief GBE_UPHY_MGBE3_MAC_CLK gate output */
+#define TEGRA234_CLK_MGBE3_MAC			404U
+/** @brief GBE_UPHY_MGBE3_MACSEC_CLK gate output */
+#define TEGRA234_CLK_MGBE3_MACSEC		405U
+/** @brief GBE_UPHY_MGBE3_EEE_PCS_CLK gate output */
+#define TEGRA234_CLK_MGBE3_EEE_PCS		406U
+/** @brief GBE_UPHY_MGBE3_APP_CLK gate output */
+#define TEGRA234_CLK_MGBE3_APP			407U
+/** @brief GBE_UPHY_MGBE3_PTP_REF_CLK divider gated output */
+#define TEGRA234_CLK_MGBE3_PTP_REF		408U
 /** @brief CLK_RST_CONTROLLER_AZA2XBITCLK_OUT_SWITCH_DIVIDER switch divider output (aza_2xbitclk) */
 #define TEGRA234_CLK_AZA_2XBIT			457U
 /** @brief aza_2xbitclk / 2 (aza_bitclk) */
 #define TEGRA234_CLK_AZA_BIT			458U
+
 #endif
diff --git a/include/dt-bindings/reset/tegra234-reset.h b/include/dt-bindings/reset/tegra234-reset.h
index 547ca3b60caa..55e397823a38 100644
--- a/include/dt-bindings/reset/tegra234-reset.h
+++ b/include/dt-bindings/reset/tegra234-reset.h
@@ -29,6 +29,12 @@
 #define TEGRA234_RESET_I2C7			33U
 #define TEGRA234_RESET_I2C8			34U
 #define TEGRA234_RESET_I2C9			35U
+#define TEGRA234_RESET_MGBE0_PCS		45U
+#define TEGRA234_RESET_MGBE0_MAC		46U
+#define TEGRA234_RESET_MGBE1_PCS		49U
+#define TEGRA234_RESET_MGBE1_MAC		50U
+#define TEGRA234_RESET_MGBE2_PCS		53U
+#define TEGRA234_RESET_MGBE2_MAC		54U
 #define TEGRA234_RESET_PEX2_CORE_10		56U
 #define TEGRA234_RESET_PEX2_CORE_10_APB		57U
 #define TEGRA234_RESET_PEX2_COMMON_APB		58U
@@ -43,6 +49,8 @@
 #define TEGRA234_RESET_QSPI0			76U
 #define TEGRA234_RESET_QSPI1			77U
 #define TEGRA234_RESET_SDMMC4			85U
+#define TEGRA234_RESET_MGBE3_PCS		87U
+#define TEGRA234_RESET_MGBE3_MAC		88U
 #define TEGRA234_RESET_UARTA			100U
 #define TEGRA234_RESET_PEX0_CORE_0		116U
 #define TEGRA234_RESET_PEX0_CORE_1		117U
-- 
2.17.1

