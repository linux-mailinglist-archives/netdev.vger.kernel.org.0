Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A31567C5F
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 05:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiGFDNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 23:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiGFDNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 23:13:19 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2070.outbound.protection.outlook.com [40.107.100.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88ADD1BE93;
        Tue,  5 Jul 2022 20:13:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1MCJvupDO71ELcc5NyYU2DkIT6gpu7KWi8k2ysiB//RmC5bsnOY6CALF7jM6NgFovr4X30K2tLknTTyCzbuxcjYE5tq19CjCNW3pJq+ieFxAIOGeEgYMunEXdvZ7zfC1PIpVdOapAJrtAQpsECBHTl6a3WPsHD9QFOcEGwjn6aqw6b8yiY9gKwE0oZSMRb7YiwCzoYTLSK3mQGU4Q2Gcd5qwBBjH0toxn+kg6Lcx9Oo6KBCeJx9jRLHoRq70xCkkvVrlLbFsOSUylkBUFbbOYj4JJNpTWGOhQGklOU5NtZ2ZE7FkrEy4wjlW6D18oU5TrK5E2F6nAh6Rr1t5zJsdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEZJKsAoH73F4qH6+BqyfsQR1zjjSVBCx094d3GYEMw=;
 b=j1yqDicN21E3AwU4Aa7fUugNNh3uwJYUKcWucZtyIRF1lZHV6XUawdyOnTaKiGLxO1/T+6fTYZR20QdE02Ds40duI2oJ3YXzPDp1NmU6sLKn6BnhxE47ihJjkPH8ffvsSGhYGolH6yingzrvr/nuhRD5FRaje9mdQnZpaqEYzxZvFvo44HYgVtb0YLKYov5zt5eBAwJSEVwtm8xoJ6l8/vRDLw24K8lHdAJHgSftvQf/BX3NrN2NeybhlPXV+HdcvWNmLNl031EwLo4upveKHfzejQQIVw/9NHNhNOnqLdu4iVHPHRpk5ikocrNoXs5Qj41xPhgKIhk8bh/iOWRxng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEZJKsAoH73F4qH6+BqyfsQR1zjjSVBCx094d3GYEMw=;
 b=UH3tSaDSgmHEnzwvhru82uLrGADO3flBz/Hdeab84b3cHjy9QPPDiq5V0EiI0wHCOinrTzapJK2VEHiJkZhagsk8CQqNxjLrUFPnloDbROLTuqb4+4/HRilUZVicQWSL+bKZUibu3U8huZFsLUCMq0i/0du2VDK9XSeMrprD2bCY4nx6XKYSoCAI3Wc881SEzD8nuV5tIvEhChzwKKPmzJtA1ew4PRnhpEXJge8R707tzwChipTIZgenWKrDg8Flu9pB522CnQqnYGMKzfj6onOJbmSnFyHdZHb/ond39U38h/YT5nmi+GV4KS4d15l4uCEjD3eJCU6Mp5I7BHxqSg==
Received: from MW4PR04CA0293.namprd04.prod.outlook.com (2603:10b6:303:89::28)
 by BY5PR12MB4148.namprd12.prod.outlook.com (2603:10b6:a03:208::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Wed, 6 Jul
 2022 03:13:15 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::c7) by MW4PR04CA0293.outlook.office365.com
 (2603:10b6:303:89::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Wed, 6 Jul 2022 03:13:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Wed, 6 Jul 2022 03:13:14 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 6 Jul 2022 03:13:14 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 20:13:13 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26
 via Frontend Transport; Tue, 5 Jul 2022 20:13:10 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        <pabeni@redhat.com>, <davem@davemloft.net>, <edumazet@google.com>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v2 0/9] tegra: Add support for MGBE controller
Date:   Wed, 6 Jul 2022 08:42:50 +0530
Message-ID: <20220706031259.53746-1-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32af2f11-ff74-464e-350d-08da5efd7761
X-MS-TrafficTypeDiagnostic: BY5PR12MB4148:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aeUG8/YHL0oeg9cCOtJsJ/qkFxme89g1eIMR61eyuxqG5iCuw2gEp5/VGk84Ctx87wg8EuGY0D8A1z8gyyAm8w8cNzPlV6avF0d9Z71oLQrS1QFkiVM6dO1U0lg0Fjh62H1VRREn0CuGApSflc/qFlS3vxAx3/mvZduNKRqCYApI+wp431OdoTautewF6n5Ywyum/8lNgNneWqxtidYrYbzAFrTnwo9NxAH809ZIKWryawZwhQGWGPSRomLAVVJZbqKUmdBlimdCfdfGc55WMQY/HSx722TiV6Mj9LGhVsIzhj65qVfXzeYkk4p9APRmvuiIQAnxkaqpo9DbV4FsoIj0TjG3k8tI1+rIlnWEbzVJUoOH2z000bwhj1pl6mV6oe230MWiK4XKo8BgW0vrsrDculiWyyBfKS4XNXljTQA4YHBsC5FvMhc1rUnEhSwJ3A3a/8COMwFp0TYVjI2nLCYK0rvojyyoKOTx/kppUL6DGm3Bcp7Y1h0hs1x+gM7CLxKtXWNCQlEOWngv8a4uPFYyyYsZ9IPzNig7OfUXjCBkodCrnSblyDJ2FQcIgs6m8VHxH3FFi0plbstD4ODoV9uNo3779fPH+RXaWefJiEGDKAxtIsb5mVuEy+V3DVJ9TZ5+VdCHHxndOUphW59xqCVM6zOiYyjDZMULxAyPoKeER4v21EVcaISflLKtUmznwYr2VMTiOxtZU5qeAFe21E5bnYIVgWeJX0xz/QrtG7YhGk+WG/MKKr8FfKNeLzvIE0cb9EslVsDcwRgQwbsHjTcydlE4lWL024mTQqhfJ0I3LQU+fSZZrgNfwY4/gOlWHsDyptpH3F5Ye/y/oouOkr2/I48AxzNHmhdTANNSQrc=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(396003)(39860400002)(40470700004)(36840700001)(46966006)(81166007)(336012)(426003)(82310400005)(82740400003)(356005)(316002)(47076005)(54906003)(86362001)(8936002)(5660300002)(7416002)(83380400001)(40480700001)(4326008)(8676002)(70206006)(70586007)(40460700003)(36860700001)(26005)(186003)(2616005)(1076003)(107886003)(478600001)(6666004)(7696005)(41300700001)(110136005)(36756003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 03:13:14.7692
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32af2f11-ff74-464e-350d-08da5efd7761
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4148
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds the support for MGBE ethernet controller
which is part of Tegra234 SoC's.

Bhadram Varka (3):
  dt-bindings: net: Add Tegra234 MGBE
  arm64: defconfig: Enable Tegra MGBE driver
  stmmac: tegra: Add MGBE support

Thierry Reding (6):
  dt-bindings: power: Add Tegra234 MGBE power domains
  dt-bindings: Add Tegra234 MGBE clocks and resets
  dt-bindings: memory: Add Tegra234 MGBE memory clients
  memory: tegra: Add MGBE memory clients for Tegra234
  arm64: tegra: Add MGBE nodes on Tegra234
  arm64: tegra: Enable MGBE on Jetson AGX Orin Developer Kit

 .../bindings/net/nvidia,tegra234-mgbe.yaml    | 167 ++++++++++
 .../nvidia/tegra234-p3737-0000+p3701-0000.dts |  21 ++
 arch/arm64/boot/dts/nvidia/tegra234.dtsi      | 136 ++++++++
 arch/arm64/configs/defconfig                  |   1 +
 drivers/memory/tegra/tegra234.c               |  80 +++++
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   6 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-tegra.c | 294 ++++++++++++++++++
 include/dt-bindings/clock/tegra234-clock.h    | 101 ++++++
 include/dt-bindings/memory/tegra234-mc.h      |  21 ++
 .../dt-bindings/power/tegra234-powergate.h    |   1 +
 include/dt-bindings/reset/tegra234-reset.h    |   8 +
 12 files changed, 837 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c

-- 
2.17.1

