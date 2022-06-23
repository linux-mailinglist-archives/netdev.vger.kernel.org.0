Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266C5557453
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbiFWHrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiFWHrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:47:07 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3B346C86;
        Thu, 23 Jun 2022 00:47:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJ6JwzIRw3JfH0DXns8RxK0aA45skVRzqQdo5N2YmmOmWiWcnKxL1F07v1R0hWEPRdBfEJphngo7DXurQ6eLss2zOJw9bXGx0Db9P9g+uliVgGXUPQLGqbtp2MiXunn9TP1gEL8zqGeBFLY8imEEbzqHCzOkCcg+fg55lOere7g/3TUKZWfsCBrl+MkMPCFzHJQkb2DGpOSEyRh8clSD0gfmrydBPw4EUDCQtfz4egXJD91uZHycNV6ztYwcRRtQsD8bDsBxtixu50+frssphyxf2zN/xCqeQ0i4kDWvu7PjcwVOlleT1ykQuYvBLRp3LVn8Z1e+4cigG787Y2L3lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kcsbq/jGk+xH0Yh31gLSHnt5nt0UXwr6HP+5Rt2cqG0=;
 b=WV3hhFDQ/+b7jRB5mDKOwJbc7QXjGTjGZUIWu/SmpxPkw3x4Nr9BLB6l368SycDnzNcPz+/deoLrvvijQFGXNz7f5ytWuWOVdZsCjvqxuqaT0WWj1eGt08V3VVTZuEa8dYTOP3RsCOmWgbShTblVdMl8GX9gAul+T1vWflheIxbQqIhJt8HPLk0yNBj2VOP+zsMNcmZGC3nMbvP97WPHjcMEk+/CPiC6FkC5ccB6Aq4g9q5LfRq7SfiDNY61NNrn7Ci+eVBQLN5YHo49LkSFrGUFY85yWt8zCTiZ7QDL89RigxuqQlnGJG+K3GId9Cel/8WRmp/KT7W4yvNwhuAuDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcsbq/jGk+xH0Yh31gLSHnt5nt0UXwr6HP+5Rt2cqG0=;
 b=T5NzP6I+Xw+VkX1jtuKwRWaOjJqCRQJuEJW2hedRGyEGW0wKgIV+/NV5Y37+sjWCIwkympmx92WXAmzu624Cu0TLDgSWWi9F4aDbbkDFLF2kI7fYidBIu9eNfn1YoNTrc94E951lB6Tb0sN3pV/VIPcFWyH4ugM/njPnAqzfzBf+ZMAWRNwbUDBY8+rmxdUC1lu1ZBmjKSthJk0IAetfFG+0pCO8DFGijwvEs2AHgPQk9mgpNHLoBm7Jp+fUSp3v8PnOQ1gcVZygpnsoFj9bd1MjX2ipfute+i81czm3qLPUBOwo84zEt5HVXcjarrbh2SkciVAKPcLBt7XD16YTCA==
Received: from BN9P223CA0011.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::16)
 by CY4PR12MB1687.namprd12.prod.outlook.com (2603:10b6:910:3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Thu, 23 Jun
 2022 07:47:01 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::14) by BN9P223CA0011.outlook.office365.com
 (2603:10b6:408:10b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Thu, 23 Jun 2022 07:47:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 07:47:01 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 23 Jun
 2022 07:47:00 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 00:46:59 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.26 via
 Frontend Transport; Thu, 23 Jun 2022 00:46:56 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v1 6/9] arm64: tegra: Add MGBE nodes on Tegra234
Date:   Thu, 23 Jun 2022 13:16:12 +0530
Message-ID: <20220623074615.56418-6-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220623074615.56418-1-vbhadram@nvidia.com>
References: <20220623074615.56418-1-vbhadram@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 302baa8e-a061-421c-5356-08da54ec8ef1
X-MS-TrafficTypeDiagnostic: CY4PR12MB1687:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB168788A8A947B2429CE5907CAFB59@CY4PR12MB1687.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xx7WQM6AyXKPqksGyO8dppvPOijuYk01PxM4XD9rRpfu4aHP0KVs9RDQ6TWVuJTrqb/sLgbyfJYJuB4s7wCRTKOC8gPPuoKtRIAdnyVXCcvsXWXuGpf1il3uv1+ylvvAjm+pkWuXyQoBxaPDZHIqL6BzTe862l6LMqyoqDBhUuFEWKTOQgnXl5oU9Je21qXGsFzNnvZ4HvOXsPnwuPK9vxpdBPDKViedj5lx69nR39PDy0vEF9ChzYsOeiUSEbNWbIdxlDYvIZCd0f7xHvgsYq9GwcU3uvB2GK8y75E+U5jn1mfyOKndyHkgII8STOvQ+OHohxTPaOU/9oAm3Iw0bW+oWxXJwg1bal4QlerLMLZECfhxtP2kJAoFIrX1EFmK91Iw9xQTg2EpOpuEGSk+CIgKAmme7VaefMO5UmIGfzOKIeKhUcphX3fxZXVI2PItAmLoxN5HMNPaiJ/k1HUhCWmqTiWNkj0Rz/aj7u7dnGQ8EuXz19A8q7tWMb9t4O3WWMMYDJltfGx1xEyiIlGIv37tpf71II2yXN5ApCVK3tPab90UBB6hDekFLVM0GQ8/4ktPfm803KVw7ZmKgBv0VQZ005NAlbsmgqAPpdQD8FS9jWeiWiTGTw0dXV49Fg584gLP1+RTtbJ217iTJoztqm9VHBF5E/0o/TKoYb0yu1T9FHkT7ru1YV8hfQ+4cxhC1OJoMpay7hXyhG6ANHWylEl88WdphQC39SiNrufJbRx4UqdrkG7VDiNnafU/7kTigan83b3YJn0EhXR/7+Kl3dFqRHX4X1FqJtjF+SSVb3Y=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(40470700004)(36840700001)(46966006)(41300700001)(82310400005)(83380400001)(70206006)(186003)(107886003)(2616005)(81166007)(40480700001)(426003)(356005)(36860700001)(1076003)(47076005)(336012)(82740400003)(4326008)(70586007)(316002)(26005)(2906002)(40460700003)(8676002)(8936002)(7696005)(54906003)(86362001)(5660300002)(478600001)(110136005)(6666004)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:47:01.1666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 302baa8e-a061-421c-5356-08da54ec8ef1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1687
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

