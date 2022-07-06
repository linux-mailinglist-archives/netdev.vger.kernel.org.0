Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2F4567C69
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 05:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiGFDOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 23:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbiGFDNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 23:13:48 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2059.outbound.protection.outlook.com [40.107.95.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26561CB01;
        Tue,  5 Jul 2022 20:13:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2JioVqO5PoOJt8x62J+q/F0RdRkTC2RJvKVInyRa10EoRqM/t5bQz7qx/yM8bfZdpL4RfslUJWvvB3YwZzdmOeJcp51tu7liVoNRYfE/iq4VLGPle0xXKUoZssEz/NlfPAEC25qCod6rDlRnulxY+GlZGwhbHK8Yi9paGB0RDLKOL03NXz+NazOajwZChF1W3/yi4WjkG1hxEOTNOaOXdOBoahb6nPUJBfEhnRxyBs99yfpX/6olgJ5G68QUAXnK0qpjOK6ZtMTnRLxyLwvRV4cezYXBlxlxGZ7FWqkxa3U5vq7g8ha53EhSF4nGHeGKrAI/VwT/JtFQZRtSqhWnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kcsbq/jGk+xH0Yh31gLSHnt5nt0UXwr6HP+5Rt2cqG0=;
 b=Wc5eNaKlwqdHF/ppaw+pRCbElk1NeRlwYMvUGY170y3RZjJYekgenb+jUZrgJr9j/iL930HQDDZTxHNMqM+TiXWrL00Q4Sz5L8t8AhYJFbwR6yI+HNkw0P3cjC1O6bYMaUKqEjAeyPDrGXE9R46TlEZJdGnVk+aB0khxhERXDPu8h/m2wThj73sJe+K5C/albnopYv/UXm5ji+EGgx2szhf5smlBjikS2vdafYdEQ7LkDVQRu2a016Eq76RKlSWw6wxdpfoZrP9XrOgyXhzOPzkS5SRK4DYEKxCcKCJE007bazOCok4lU4ojTQESEwygX69e8dxsrpsUTKWtdFHQ4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcsbq/jGk+xH0Yh31gLSHnt5nt0UXwr6HP+5Rt2cqG0=;
 b=nMBtgwrV7KjB2WXmS6C3lK+v6Eqj0xOqQHuoP8Ccio4OuP8eMk7bwXwVxah/KHMuyxM7t0TUqXzuuArn2z+/YCYIFP9m4bE7H8pQeSUgkkPZXjc5y82LxGmoKK7zRbQx8bGlbVOQNzFHT4dx2hOIWR90tJIgDkzEejKceTbWhkAFhR02wQ9qp8GITpi/FSOfR/+gnIYXsYT8ZwZM+PfFqNHK/EUOp2wQFYOyc0fBpzLbSvmI6nPjWDBwWLqTZZ4hmPt72BGPxDJEq/iPN+ATHN2EIJWN3+MShHq0eQA9RYMN7j6xLr+pf6V15OYXMWt4lovEJFCxkD+wG1F/bA1l1w==
Received: from MWHPR19CA0008.namprd19.prod.outlook.com (2603:10b6:300:d4::18)
 by BN9PR12MB5066.namprd12.prod.outlook.com (2603:10b6:408:133::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Wed, 6 Jul
 2022 03:13:40 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:d4:cafe::4) by MWHPR19CA0008.outlook.office365.com
 (2603:10b6:300:d4::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21 via Frontend
 Transport; Wed, 6 Jul 2022 03:13:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Wed, 6 Jul 2022 03:13:39 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 6 Jul 2022 03:13:39 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 20:13:38 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26
 via Frontend Transport; Tue, 5 Jul 2022 20:13:35 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        <pabeni@redhat.com>, <davem@davemloft.net>, <edumazet@google.com>,
        Thierry Reding <treding@nvidia.com>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v2 6/9] arm64: tegra: Add MGBE nodes on Tegra234
Date:   Wed, 6 Jul 2022 08:42:56 +0530
Message-ID: <20220706031259.53746-7-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220706031259.53746-1-vbhadram@nvidia.com>
References: <20220706031259.53746-1-vbhadram@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 807451ca-c598-484d-2dd0-08da5efd8659
X-MS-TrafficTypeDiagnostic: BN9PR12MB5066:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mBL+W86j8Si7RPBEqUE+pR3Q1fUbsyDnlaQthl5ybzuMliZWBSBwxeoXwNUQGFJHx2Ru4zonnVTRdt5w8PsaE3e3pYli/y7bdRmd/GCVPB/uLN+aCxtQIq2TIJvpFshz+o31+AFalSOedRzubhemid71aV5/NIFoCcEOKcwdc9qtD1hH/Ig+ShaHUgoP1g3F/3IOkSyOQ8/iLtSoDTxUsflkIdLZXE89IlmJWJ3oyJOJqYxMYHIU0d8dSMLJNDuT7zCE/HhiAk3kYviXozO2vGhnEKEpqrSI8qjFczDNch4Otp1honuJXbGIfINk+HGT49K/G4Vft0Vqs2Kj2Ii9BzANqgo7+aGk+RbEsPwnxriWtCjNzE/3OyquL5pBB6CV07a/FwSl+uCaA4pehkVLrmZVhoy9O09fmwmLUnCubKh64iYZkyqNn46FX8C5p99WTmQerBEq6SFav8a4ieIJwLJKL94FujqQqdjxiSHP+vpDbLdsjtxhNhtYu6TKH19XyBOqJkHEzol9DTDsRzBBYkSHgQmXiPSjTfsNJqeYqxXQwnVJQyh0mvkJanffHY/bXXWzBla6rv/7ck0E4XveazwYZK9CTjEBXV+h7XbiBVSoqjfptgNJKM2q+sAdUE0EzYUluIhVDJ24H+uaUPFDnhaaqZlJB172h6UvsIJBArB84Rb34KK3BTtHBZ+avrIo/eIvt40abKY2zKxPBnyiMkmU+vTV/zOJtLdBFFMaKpoSVkUcUgndNduvy8uknR2XZcGfTU0Ml7c/gAiIAtUDHvkoRqbEnRKiXDZpbtTj/aMW17IoPy5EfnHP0waT0A8a86JRgpISVR0VI+qqYuc2bP3HxnrfsAmLadS1PcPxAAM=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(396003)(346002)(36840700001)(46966006)(40470700004)(81166007)(5660300002)(478600001)(7416002)(54906003)(70206006)(356005)(8936002)(110136005)(82740400003)(316002)(40460700003)(86362001)(8676002)(70586007)(47076005)(426003)(4326008)(83380400001)(1076003)(2616005)(336012)(107886003)(26005)(186003)(7696005)(41300700001)(82310400005)(6666004)(2906002)(40480700001)(36860700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 03:13:39.8981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 807451ca-c598-484d-2dd0-08da5efd8659
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5066
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

Add MGBE IP DT nodes in SOC DT files.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 136 +++++++++++++++++++++++
 1 file changed, 136 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index cb3af539e477..b77b55e80223 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -791,6 +791,142 @@
 			#mbox-cells = <2>;
 		};
 
+		ethernet@6800000 {
+			compatible = "nvidia,tegra234-mgbe";
+			reg = <0x06800000 0x10000>,
+			      <0x06810000 0x10000>,
+			      <0x068a0000 0x10000>;
+			reg-names = "hypervisor", "mac", "xpcs";
+			interrupts = <GIC_SPI 384 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "common";
+			clocks = <&bpmp TEGRA234_CLK_MGBE0_APP>,
+				 <&bpmp TEGRA234_CLK_MGBE0_MAC>,
+				 <&bpmp TEGRA234_CLK_MGBE0_MAC_DIVIDER>,
+				 <&bpmp TEGRA234_CLK_MGBE0_PTP_REF>,
+				 <&bpmp TEGRA234_CLK_MGBE0_RX_INPUT_M>,
+				 <&bpmp TEGRA234_CLK_MGBE0_RX_INPUT>,
+				 <&bpmp TEGRA234_CLK_MGBE0_TX>,
+				 <&bpmp TEGRA234_CLK_MGBE0_EEE_PCS>,
+				 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS_INPUT>,
+				 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS_M>,
+				 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS>,
+				 <&bpmp TEGRA234_CLK_MGBE0_TX_PCS>;
+			clock-names = "mgbe", "mac", "mac-divider", "ptp-ref", "rx-input-m",
+				      "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-pcs-m",
+				      "rx-pcs", "tx-pcs";
+			resets = <&bpmp TEGRA234_RESET_MGBE0_MAC>,
+				 <&bpmp TEGRA234_RESET_MGBE0_PCS>;
+			reset-names = "mac", "pcs";
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_MGBEARD &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_MGBEAWR &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommus = <&smmu_niso0 TEGRA234_SID_MGBE>;
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_MGBEA>;
+			status = "disabled";
+		};
+
+		ethernet@6900000 {
+			compatible = "nvidia,tegra234-mgbe";
+			reg = <0x06900000 0x10000>,
+			      <0x06910000 0x10000>,
+			      <0x069a0000 0x10000>;
+			reg-names = "hypervisor", "mac", "xpcs";
+			interrupts = <GIC_SPI 392 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "common";
+			clocks = <&bpmp TEGRA234_CLK_MGBE1_APP>,
+				 <&bpmp TEGRA234_CLK_MGBE1_MAC>,
+				 <&bpmp TEGRA234_CLK_MGBE1_MAC_DIVIDER>,
+				 <&bpmp TEGRA234_CLK_MGBE1_PTP_REF>,
+				 <&bpmp TEGRA234_CLK_MGBE1_RX_INPUT_M>,
+				 <&bpmp TEGRA234_CLK_MGBE1_RX_INPUT>,
+				 <&bpmp TEGRA234_CLK_MGBE1_TX>,
+				 <&bpmp TEGRA234_CLK_MGBE1_EEE_PCS>,
+				 <&bpmp TEGRA234_CLK_MGBE1_RX_PCS_INPUT>,
+				 <&bpmp TEGRA234_CLK_MGBE1_RX_PCS_M>,
+				 <&bpmp TEGRA234_CLK_MGBE1_RX_PCS>,
+				 <&bpmp TEGRA234_CLK_MGBE1_TX_PCS>;
+			clock-names = "mgbe", "mac", "mac-divider", "ptp-ref", "rx-input-m",
+				      "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-pcs-m",
+				      "rx-pcs", "tx-pcs";
+			resets = <&bpmp TEGRA234_RESET_MGBE1_MAC>,
+				 <&bpmp TEGRA234_RESET_MGBE1_PCS>;
+			reset-names = "mac", "pcs";
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_MGBEBRD &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_MGBEBWR &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommus = <&smmu_niso0 TEGRA234_SID_MGBE_VF1>;
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_MGBEB>;
+			status = "disabled";
+		};
+
+		ethernet@6a00000 {
+			compatible = "nvidia,tegra234-mgbe";
+			reg = <0x06a00000 0x10000>,
+			      <0x06a10000 0x10000>,
+			      <0x06aa0000 0x10000>;
+			reg-names = "hypervisor", "mac", "xpcs";
+			interrupts = <GIC_SPI 400 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "common";
+			clocks = <&bpmp TEGRA234_CLK_MGBE2_APP>,
+				 <&bpmp TEGRA234_CLK_MGBE2_MAC>,
+				 <&bpmp TEGRA234_CLK_MGBE2_MAC_DIVIDER>,
+				 <&bpmp TEGRA234_CLK_MGBE2_PTP_REF>,
+				 <&bpmp TEGRA234_CLK_MGBE2_RX_INPUT_M>,
+				 <&bpmp TEGRA234_CLK_MGBE2_RX_INPUT>,
+				 <&bpmp TEGRA234_CLK_MGBE2_TX>,
+				 <&bpmp TEGRA234_CLK_MGBE2_EEE_PCS>,
+				 <&bpmp TEGRA234_CLK_MGBE2_RX_PCS_INPUT>,
+				 <&bpmp TEGRA234_CLK_MGBE2_RX_PCS_M>,
+				 <&bpmp TEGRA234_CLK_MGBE2_RX_PCS>,
+				 <&bpmp TEGRA234_CLK_MGBE2_TX_PCS>;
+			clock-names = "mgbe", "mac", "mac-divider", "ptp-ref", "rx-input-m",
+				      "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-pcs-m",
+				      "rx-pcs", "tx-pcs";
+			resets = <&bpmp TEGRA234_RESET_MGBE2_MAC>,
+				 <&bpmp TEGRA234_RESET_MGBE2_PCS>;
+			reset-names = "mac", "pcs";
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_MGBECRD &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_MGBECWR &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommus = <&smmu_niso0 TEGRA234_SID_MGBE_VF2>;
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_MGBEC>;
+			status = "disabled";
+		};
+
+		ethernet@6b00000 {
+			compatible = "nvidia,tegra234-mgbe";
+			reg = <0x06b00000 0x10000>,
+			      <0x06b10000 0x10000>,
+			      <0x06ba0000 0x10000>;
+			reg-names = "hypervisor", "mac", "xpcs";
+			interrupts = <GIC_SPI 408 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "common";
+			clocks = <&bpmp TEGRA234_CLK_MGBE3_APP>,
+				 <&bpmp TEGRA234_CLK_MGBE3_MAC>,
+				 <&bpmp TEGRA234_CLK_MGBE3_MAC_DIVIDER>,
+				 <&bpmp TEGRA234_CLK_MGBE3_PTP_REF>,
+				 <&bpmp TEGRA234_CLK_MGBE3_RX_INPUT_M>,
+				 <&bpmp TEGRA234_CLK_MGBE3_RX_INPUT>,
+				 <&bpmp TEGRA234_CLK_MGBE3_TX>,
+				 <&bpmp TEGRA234_CLK_MGBE3_EEE_PCS>,
+				 <&bpmp TEGRA234_CLK_MGBE3_RX_PCS_INPUT>,
+				 <&bpmp TEGRA234_CLK_MGBE3_RX_PCS_M>,
+				 <&bpmp TEGRA234_CLK_MGBE3_RX_PCS>,
+				 <&bpmp TEGRA234_CLK_MGBE3_TX_PCS>;
+			clock-names = "mgbe", "mac", "mac-divider", "ptp-ref", "rx-input-m",
+				      "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-pcs-m",
+				      "rx-pcs", "tx-pcs";
+			resets = <&bpmp TEGRA234_RESET_MGBE3_MAC>,
+				 <&bpmp TEGRA234_RESET_MGBE3_PCS>;
+			reset-names = "mac", "pcs";
+			interconnects = <&mc TEGRA234_MEMORY_CLIENT_MGBEDRD &emc>,
+					<&mc TEGRA234_MEMORY_CLIENT_MGBEDWR &emc>;
+			interconnect-names = "dma-mem", "write";
+			iommus = <&smmu_niso0 TEGRA234_SID_MGBE_VF3>;
+			power-domains = <&bpmp TEGRA234_POWER_DOMAIN_MGBED>;
+			status = "disabled";
+		};
+
 		smmu_niso1: iommu@8000000 {
 			compatible = "nvidia,tegra234-smmu", "nvidia,smmu-500";
 			reg = <0x8000000 0x1000000>,
-- 
2.17.1

