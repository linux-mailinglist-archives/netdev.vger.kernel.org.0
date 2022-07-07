Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14BA5569C19
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbiGGHsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiGGHsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:48:32 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837A315702;
        Thu,  7 Jul 2022 00:48:31 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id a5so10395973wrx.12;
        Thu, 07 Jul 2022 00:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4JHBqE0DQ2XHU3tiDx/d/lTFPX4IcMwvbw15OSlGoBE=;
        b=PNZxlLurHRMNVYSzZxbwtjm077/nl6iet0BcroYYyJuFDSc6UHJM7o7Yr2vjFgrreX
         kaM5AfWxjGAfz70+P0Vc4dMIkDK3xQAVjU6yTQru7EH0fLoR3evxRmld8DILBk6rOtbF
         CdTzhW0FejYc5ceT3ZDecZTEyIi1HvRRS6ClGqXzhMbzy5AqQG7WxEiwinpeZBVLFmE5
         BWKmbjhG7FU73Eq7wqDW1jx26CaLUNEkC3qczyjZyyTNDLM3gEXSNnvSd3F0ieNPzJkW
         JMBHAE0FAGZwyQTE3JMy3QwqhCZdgLAAxqKoyuHNjGFmMOR5ZMQweWR+LavhuflPS/Wi
         yjGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4JHBqE0DQ2XHU3tiDx/d/lTFPX4IcMwvbw15OSlGoBE=;
        b=Me1ZL74Vzu03JdSd9aA9W6m8O6oW3gJh1qy+UoZP+ZMOi3kg4nVa72ZOzVy4Nlj7cy
         7+RjG6lE2BgCgx3L3wnmDvAf4/rtaz4ybGN0g/U1QyUnqajQ4LeNDgTiQFuigXcWUWJS
         Tvqy8uPzfBAIPYyh6xWsrt6hPBSfN0AUXxtKr96y2Io/VjB952tpvxN3Dvve9te8/kWY
         wTLYMFLx8kVM1cqYoraf7Xq6eRJCzSkz1WIGZlaZWAlQSa90Cm/VPu52QXCMTPXYrFDi
         1DjkVVmuuwHekmYn8XAw8Fqlx8OctRqh9LkFeTkFa1hJbcoEIrUt/nkq7bhBwNpUKWYB
         t/Yw==
X-Gm-Message-State: AJIora/NXqYsKU4TnqN4FUcYsPKmhtVegUqbxmCxRNhFSaYw43WJA1ky
        ArKUh3w/sHuAKMUWGfmHCL8=
X-Google-Smtp-Source: AGRyM1vIl0sEGR+qFSNU6k+Ioo34Dimwf8haF2yfiJHUvvt2O55+y5hc0JMGki47rTv8ZhH+YiCBBA==
X-Received: by 2002:a5d:61d0:0:b0:21d:5e08:af3c with SMTP id q16-20020a5d61d0000000b0021d5e08af3cmr24617079wrv.25.1657180110055;
        Thu, 07 Jul 2022 00:48:30 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id s12-20020a05600c384c00b003a2c7bf0497sm1872879wmr.16.2022.07.07.00.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 00:48:29 -0700 (PDT)
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
Subject: [PATCH v4 6/9] arm64: tegra: Add MGBE nodes on Tegra234
Date:   Thu,  7 Jul 2022 09:48:15 +0200
Message-Id: <20220707074818.1481776-7-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220707074818.1481776-1-thierry.reding@gmail.com>
References: <20220707074818.1481776-1-thierry.reding@gmail.com>
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
index cb3af539e477..b77b55e80223 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -791,6 +791,142 @@ hsp_top0: hsp@3c00000 {
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

