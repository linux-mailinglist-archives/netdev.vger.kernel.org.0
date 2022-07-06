Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FC356947A
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbiGFVd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234621AbiGFVdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:33:16 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B2B2A965;
        Wed,  6 Jul 2022 14:33:14 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l40-20020a05600c1d2800b003a18adff308so10045569wms.5;
        Wed, 06 Jul 2022 14:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BT2h5agj6IQ4VViNGEZCcLa1QmBAGb3xQLO5iXow8hk=;
        b=WDVOiloddHYzSvCejjUwm6Wd5IPw5g5+uj/zioK4dAqfjKfMvr+Rezu4ZWea8HSkyK
         T7tWX05sHWGvNORDsBmNbNqj4Ia1/ZFCG22sR/59PpbwOtz4gceMN+De9MlaZlWlfrtg
         ktPvlAycQmA2z893gE/OMes2eOcdcdcnqPwom0JukgXSSSlRB4rAcgrem+pwR1oPIWh5
         If0h8O2p5NzfgCXGI4DfRXQFGfKLbbXUiGlsj/3YF8CqhmIhHKnAeG21Kg5SvCbCJtjM
         oMurjMrkhz5csPeFC9G40nxeTvv5o8E1LugwjIYBB1fuHbgd+2jGdOSqcFmIWZ+lCeU+
         jp5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BT2h5agj6IQ4VViNGEZCcLa1QmBAGb3xQLO5iXow8hk=;
        b=wL2+gavmi6U89XiduXmaF/a7zn4IVPSso/APqCtgts4KLsmCDk1lc6rnAdhuMPYG5f
         gHrm1kd9eblLnT+I9Hbyx+2z7nOZr+tE2h0CYZgeJPxdJXlQ0pt8dQduUqq71K5/qHU5
         OM4+1Cq+wCa0mIM5S0zUi0OtawKgsCMuQ4U0GUnK0wKiUhN1AFoGvbbDhdA5N/ZlOm2e
         F9KLncGFm9AZ/dbNkdRB5wQPC9oQ1xDwv/AI+5hM/GjovJZsKRQhF2/3JMzltYtAOWaa
         fxI+EcwzuCYnzJEUNDuajRfnm9DqJu8ONq/I/VRsP8Wj2xPTAL+RgAOWSg0iAsw8XJrx
         xUeg==
X-Gm-Message-State: AJIora/UX8TJ3HgMQikage5RPtDNLPnWUm/L3KmeL2zoeaa7ykzzwrWH
        fwBBKKZCN7wyXjNacTUGYz8=
X-Google-Smtp-Source: AGRyM1s0UemMu6iOqd03ctKmZCafBQaeRAicvu94MTTHC15dNkqlYW5llHZCZ3sP7qpfEiXy8tsjjA==
X-Received: by 2002:a05:600c:1f19:b0:3a1:8fbf:f75c with SMTP id bd25-20020a05600c1f1900b003a18fbff75cmr631145wmb.47.1657143192443;
        Wed, 06 Jul 2022 14:33:12 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id z9-20020adff1c9000000b0021a34023ca3sm8801822wro.62.2022.07.06.14.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 14:33:11 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 6/9] arm64: tegra: Add MGBE nodes on Tegra234
Date:   Wed,  6 Jul 2022 23:32:52 +0200
Message-Id: <20220706213255.1473069-7-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706213255.1473069-1-thierry.reding@gmail.com>
References: <20220706213255.1473069-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Add device tree nodes for the four instances of the Multi-Gigabit
Ethernet (MGBE) IP found on NVIDIA Tegra234 SoCs.

Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 136 +++++++++++++++++++++++
 1 file changed, 136 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 5c1b74526645..c3c74ec67c94 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -884,6 +884,142 @@ hsp_top0: hsp@3c00000 {
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
2.36.1

