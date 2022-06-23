Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC98557455
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiFWHrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiFWHrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:47:14 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2085.outbound.protection.outlook.com [40.107.102.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764B946C89;
        Thu, 23 Jun 2022 00:47:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J7dJm9R6dx8scuPFS9Mrza/TYJqEbdEvNuQz1PfRh1a+54niFuz5x4L9/puYMEp0MO6aKxJuK2bfIggTl4MdHAGMLlGe0X+e+Ebiq5PT6wDPvBJRKh59biBGj5eunr7wB9P4pmu17+wBvwmj7yL/nzgBsfzQhd6mxQIhzN4uOXcem0tTG4veSy7eKl9agIUtpi/pMERC6MdhdoNsQqLACpJJVURHo5R+4R16jHgd2feSDE4tzCPhejraukXnf83AYewls3pCDL6tQqaG7x4TVfQYM4xB4lT+HnKA72+eCKhTnhAxsNTFFlJFPlyfLJDjnfFje94S0YzYFKB2CDxfWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZSGJf24W5VSpcSXwRsgckLYnbLA6N4FEG3oeJkAxJwk=;
 b=SK/gYJ2ACrN/fCzokl9JxzaUCTF1S1WeRH4XftiVd363tI2ygL02gGeDNepqYGZDQALYYFpT9Tz2J91kzX7STgy6Rp0xfNBLb7wbzsKCzH2p2mmWKJCUyfKvVTxmKtxzmQN4wl9ynBgbqEJfKGCsBAlMhwBmmEBQOoaK0pUK+ehX72djX8vTzNKGZ6GATYdRaQVRxnFtyvf3E1qsz0cJ9jlbk4qEMIwGJgS2yAsITLNelHqzHRhofrWQ9dwSs3JtUq1Sm97QmBcfp0cI0uu/lXv96/zl6Qv+6tJ63AwHnm7iwkaJiMzZh8dnJQ7jbxrhMu1ilBNv3ljEsg3QQkiAYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZSGJf24W5VSpcSXwRsgckLYnbLA6N4FEG3oeJkAxJwk=;
 b=iQ0E1pW20vG11Ff/xiy1smjsoIx11iVu6zJnp+kw9es4WYr8MiVn2JBaTsBP0QuA4qZaIKpjp5RMVo+AThrkOW+ck2x6kN2XrK75bpDn/jcbelOh95rEAiqNREJ0xtV/p/wBEQ8YpmKIs+Kikuwm5NBGqTOy5lFGYx3sl2DtIAi0VJADCylX2G9Ycgv6Xh6VY7GxpKz10Id1S9/w4P/5EhafwMfQgMctrHsoTqvWyBK162aiy3KDkv7qFJMjqeT46zrY05/0DOlzypo15d3XApY/mhmDDsit6O2MIMuw+DBGmX08mHdmB4I8BBGqQUw4DJJHvg7zEPdoGdLH3FIA1A==
Received: from DM6PR04CA0003.namprd04.prod.outlook.com (2603:10b6:5:334::8) by
 DS7PR12MB5789.namprd12.prod.outlook.com (2603:10b6:8:74::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Thu, 23 Jun 2022 07:47:12 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::e9) by DM6PR04CA0003.outlook.office365.com
 (2603:10b6:5:334::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Thu, 23 Jun 2022 07:47:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 07:47:12 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 23 Jun
 2022 07:47:11 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 00:47:10 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.26 via
 Frontend Transport; Thu, 23 Jun 2022 00:47:07 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v1 9/9] arm64: defconfig: Enable Tegra MGBE driver
Date:   Thu, 23 Jun 2022 13:16:15 +0530
Message-ID: <20220623074615.56418-9-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220623074615.56418-1-vbhadram@nvidia.com>
References: <20220623074615.56418-1-vbhadram@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f235d2bb-47f8-447d-a70a-08da54ec955d
X-MS-TrafficTypeDiagnostic: DS7PR12MB5789:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB5789BB0481CA03E3363D1808AFB59@DS7PR12MB5789.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0gRsCVBTZDnva7IDodWv2KuYZkhlzO/TtKlYzv2LnPzEbeX2d5FBTthD5O/URoM67iFp51GaTEZu4bWSivd9/4hzrIW7m9khbU4jqtIfpWSQtI7JLdTu1sagc0Zy6ET3215Bjhio2qr0q73fTDRzmtVgfIRC2UWKyv3RKpNP4xkyboKNcZH+uLqmGfCfDuGJ65mfeepWaaHYR+DYz9Pm9cxVs7moR+gNX7/M/nepgK34J52yXCCeBHC2v0s21yayJR3vT83x9GHfxtHxFY0x3kcjfuYEvDMoJ7H8ZCQrXo/lLGw+zHkBtofq8Js4GlnMN9dRNYedVOnfDHpUwGoKqVYFWUWOvlrFXsCVlu6I+xDg5c0cGIzby2XL1GaktYYbgFpi0SFN7HFwduO6l0lVSeV72XcDnVplGkULRY4x5mww9kjd4Cb7pkmbJICLVw843180+H36DkFOnsr5dihSfYkMms+2zP5SMuHiOZYy8zdKRCNPA1XJziFsU0/yvhoDQKjMS28Xx/ej/NT0Qx83Xk0eQZ2d9nCesNK4OrpHnSJl/nZdUSXHCHeme1SLXansDWsGYG2qbANGu/1i/J22VH/lERtWKRjbP4GENZ74X+ZwFD1YsRNmWGvnsMJoUT1BMENZXV6wEVHQXcVdizaZJ51Cl4EgfFj4d0MUlUCtlvkUeq3PlcwF6F9N1TSsHvwoQHQeeQ24Mg46I4dwH35sZVBawT+nKnNnA0l2L6QWIM2Yen3JBeCAyGYnbUyICDMBJuLz5O6HPzdvVP/wjWFUDZciIX+N55sNP0zFwGqUpWQ=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(36840700001)(40470700004)(46966006)(110136005)(478600001)(82310400005)(36860700001)(70206006)(41300700001)(54906003)(6666004)(40480700001)(26005)(316002)(426003)(40460700003)(86362001)(82740400003)(2906002)(81166007)(107886003)(70586007)(5660300002)(1076003)(186003)(8676002)(2616005)(8936002)(336012)(7696005)(4744005)(36756003)(47076005)(356005)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:47:12.0054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f235d2bb-47f8-447d-a70a-08da54ec955d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5789
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable Tegra MGBE driver which found on T234 SoC's.

Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 7d1105343bc2..f80142abd9c6 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -359,6 +359,7 @@ CONFIG_SMSC911X=y
 CONFIG_SNI_AVE=y
 CONFIG_SNI_NETSEC=y
 CONFIG_STMMAC_ETH=m
+CONFIG_DWMAC_TEGRA=m
 CONFIG_TI_K3_AM65_CPSW_NUSS=y
 CONFIG_QCOM_IPA=m
 CONFIG_MESON_GXL_PHY=m
-- 
2.17.1

