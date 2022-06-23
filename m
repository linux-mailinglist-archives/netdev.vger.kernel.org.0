Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3946B557447
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiFWHqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiFWHqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:46:49 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA2246B36;
        Thu, 23 Jun 2022 00:46:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJfh0LFI5LMJjsizcCJfGNPDxWzqxPCW9iOsokf+2K/Da5mgPAB7/0SRqbJyI6u54jwr9Mf9Eksqjiu46EuD8GzxeMqEyEqcRiIYTBXUUOx3nYiQ0H3L3bOBFvWqPp6WjuyI0dqx4O1H0HAr4LZ3fCQ4gm0nONEXNEVWxEYhBiY5/bcwVAIisGCWFpYmj9vhdEP0FDqKMuvJsCqPGHjt8USlyO7xdnAGbN03CwrHUEqZcLHIEVBn6+7jVlvHrX117hwdflwDL8c4txwNKVwr9RDSyF9CwFq2TBvGnfQO09h8JN2cqy7zrIIwxggTwNkuAt2jriaBkxJw53NlhPc/aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jSmPgUbrgSv2fJrSdfo/GxXDMO2ZXJl+wlnQXzeLsA4=;
 b=KPQq0eibGPWwcJyRU4b0pi5ygEdiAEoDv+1xMDF0Tb7s6xbw8druz++lvTh1DiAnFValRymFmgtanmwwAvzzqMu8aTrg6RamyXMU29ukDb0gVzPV3Z1z2tNBJhh+sv+BxiJsvZ0rvbwYyA4dYFuFk0lr86dfzMAgnWdXXp7JH5PsKawALOYtkabngsyU5iUBJVcuCl5m3ebhEin3mXjlrShr5/oeqB5xSr9j/8tvoxQsMIonp8atQQai77s3+F/S7sokE+oeIHNB+ULEZlqambXC+djgH62AUTbkauE3PdMA5hRE3IkNrxqs2EA1mF5jZqMocEgn6ekMjYphXRIDuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSmPgUbrgSv2fJrSdfo/GxXDMO2ZXJl+wlnQXzeLsA4=;
 b=Ij+U3IxbbvSq/tMpE8N4qgtj0pVMmXRMG5vf9QpkKgmjRLsFIDNLnYB3ZHqNDJpd/GrUbWzqLHily+y/0NdNB13Jd0nisFQUICdEhVNcfc3JgXGMo7PgoiRUxX6GDLVrDc6+Y5jVO/iCdZpP02oqS2P3AQYusfqtcUDnHaS53N9wb30fTww5UjyVZmugq25MTrZYoKqiuc+/EMFY9vJ2qOKsVX/HGQpDvwQpatWPzuVITjjjHTSJP1FWwF7hRDgml6QAa1dqeFPqn6c3st3TXYrvc8cWXC3PVIQVdCI9nyYx8yQfwyHrFnkGc8mcJ90idVDPUjHRI4ZW/F4yvnTRRw==
Received: from MW4PR03CA0205.namprd03.prod.outlook.com (2603:10b6:303:b8::30)
 by CH0PR12MB5297.namprd12.prod.outlook.com (2603:10b6:610:d4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 07:46:46 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::d) by MW4PR03CA0205.outlook.office365.com
 (2603:10b6:303:b8::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Thu, 23 Jun 2022 07:46:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 07:46:45 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 23 Jun
 2022 07:46:45 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 00:46:44 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.26 via
 Frontend Transport; Thu, 23 Jun 2022 00:46:41 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v1 2/9] dt-bindings: Add Tegra234 MGBE clocks and resets
Date:   Thu, 23 Jun 2022 13:16:08 +0530
Message-ID: <20220623074615.56418-2-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220623074615.56418-1-vbhadram@nvidia.com>
References: <20220623074615.56418-1-vbhadram@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93423072-2b2a-4b3c-f0eb-08da54ec85c4
X-MS-TrafficTypeDiagnostic: CH0PR12MB5297:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB52973221885CF188A55A9430AFB59@CH0PR12MB5297.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M9bMx57ZaVXg5jAVTv5uaYsFBu9F7n13HychLNKLbMBUvVncP1XjuDlt2QZ9MjqWKA2eyNftiuU3rRWKnF5P2jN2cYUUYvUp7rkdIYFH14T5VvIeQrXjb5Z3J5ul9EkjfmUsxhzkcx8FwS1Gh2V4AChDvCPu4aVEjo6luP2tqJlAcdJamIks+bt8FSarOResA5HMTjcl6PBfs25iGGaxswdaY8yuIVvh7qt6tktkctDkbzKYPlgRspUTZu2uUmA8WwfGgl0fzvVqfBOFZeo0yGEtU5+Sz6EWWpH5HOkO2NpGhEgAueRsBTp/gGh80izkMesWCQ6d119PRxPW1wv9L1b32KUY2ljt5TAIUM7/F+8QMapETmirKudi7asmCNxbUPewHlrJcVL+ECKls1PR7ajoW6md7dE1E75bS+mD8D890sHvtgB6oJAdNcC0VUeq52HsMog3gKtRyT8ZHlj8C6hHHhGhgFYCjiYq3CIx80ubIiNhHPzQ6r0329q9gcvbcWkU974PgtRjl7kfmGhzmVfb1Z0SmIFIPpVhkWkFNOEjol8NCFYTHQ4k6IDBfmeTkuOmA7GYLmY9ZMAXjjHFS4hiz+3Vm0MPqi+NKCcBLeYIFxZvKYZ/efUp3Fd4YWpXipOlGSDc2gROwQR9WKBA37tX7t/xMyI013d92AzGF5Nr8RB6i29aQvwKhtHHO5vu9eLMMR3UhibrrNJw9T7J7lB0pgZABfqOXOSQbmFTdGfBMGCbH7YRnCa9o4T29X8uYYtOgBvb4esS/3+2eTa0qYuoMBdMAmXY7Ak+ugKbfPs=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(396003)(346002)(36840700001)(46966006)(40470700004)(2906002)(7696005)(41300700001)(2616005)(8676002)(70586007)(6666004)(4326008)(478600001)(26005)(81166007)(86362001)(40460700003)(36860700001)(54906003)(36756003)(8936002)(40480700001)(70206006)(82740400003)(356005)(426003)(47076005)(336012)(1076003)(82310400005)(83380400001)(107886003)(186003)(5660300002)(110136005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:46:45.8388
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93423072-2b2a-4b3c-f0eb-08da54ec85c4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5297
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

