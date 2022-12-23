Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2786550FD
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 14:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbiLWN0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 08:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbiLWNZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 08:25:59 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3D026A82
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 05:25:58 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id gv5-20020a17090b11c500b00223f01c73c3so7612335pjb.0
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 05:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edgeble-ai.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJOAEuTCZH9I37ZOI2Y3RZgmgEqqxJBzOZPsdbMXeRo=;
        b=LDqIJEsr5yxpLVhXH0biAGVKubl8/fkFSEUgH5qqyXu5uHrmbmbm7lr5PvDuXLZh14
         MpNpL5drGTKBvTzkBqktMbnCh/LTdYTg+/JJK+4YiC34SE/opt5WBu4EV+YvESrICkGF
         n55VDIbltxFCUaWTsB27PpMm/2guNRqRHz4EJwFgnfan9slki2geTMgsXoHpe53QfGAa
         c83ZAr++QhYpFtpZnwy6HAFe4tTWi4naRMnL2HF+5LYpsqddvT4+Ckaf5O65m/6e/zen
         WJjFB568czAQt+yQ7zyc/jL9N3+NoiJ5YTcK/m738DyPrLBx8O0czmVNh+tCM5B4OMno
         lEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WJOAEuTCZH9I37ZOI2Y3RZgmgEqqxJBzOZPsdbMXeRo=;
        b=rO2sBfqRep7paJxPTr9aNwA5ebXUDfwnwnj6pMbyWr+Xp1o8rFYD34RWmy1WMcJH1d
         +NWSpi4SSMiPlmFQrJAMarYUMk4w2p3fUZU3iQCtZuqedVUBGPz9tr6SsFu3AUCMbmlX
         UqJ70+yekPyEQBbOLd5PKYMZenFufNVYmqLu2c1U9j6ORFN03U7L/6tJTdHl3ZMmLbyC
         SkFiFsPzGKuLodNbidmSkQ/x89QP8u4Fg044kZNx76s0jOZFG9GIQhVpit1ogKsRPzKj
         q4fcBV8l9q+QAUdM5PRe2R/ShHhHbq6Ll3ejTqcBVrcGTwUOvFVNTBd4AFrHeqi3vdFO
         up/g==
X-Gm-Message-State: AFqh2koY5VgRWG/9d5GwTLWV0bQL5HBNFvmRrgvshfdmS/PB8AdOhixd
        yB6+9TMUSlbyHCIHdZlx0tke4Q==
X-Google-Smtp-Source: AMrXdXtXEFysaVAJF+CTDEiz+OWvQED5ldVWf0lcmRDBjbFVHBbTFEagf9y08uwCuoQOfLo05hH8Fg==
X-Received: by 2002:a05:6a21:998a:b0:ad:f86d:c0bc with SMTP id ve10-20020a056a21998a00b000adf86dc0bcmr14574349pzb.7.1671801958229;
        Fri, 23 Dec 2022 05:25:58 -0800 (PST)
Received: from archl-hc1b.. ([45.112.3.26])
        by smtp.gmail.com with ESMTPSA id m3-20020a635803000000b0047681fa88d1sm1308587pgb.53.2022.12.23.05.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 05:25:57 -0800 (PST)
From:   Anand Moon <anand@edgeble.ai>
To:     Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Anand Moon <anand@edgeble.ai>, Jagan Teki <jagan@edgeble.ai>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCHv1 linux-next 3/4] ARM: dts: rockchip: rv1126: Add GMAC node
Date:   Fri, 23 Dec 2022 13:22:32 +0000
Message-Id: <20221223132235.16149-3-anand@edgeble.ai>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221223132235.16149-1-anand@edgeble.ai>
References: <20221223132235.16149-1-anand@edgeble.ai>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rockchip RV1126 has GMAC 10/100/1000M ethernet controller
add GMAC node for RV1126 SoC.

Signed-off-by: Anand Moon <anand@edgeble.ai>
Signed-off-by: Jagan Teki <jagan@edgeble.ai>
---
 arch/arm/boot/dts/rv1126.dtsi | 63 +++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/arch/arm/boot/dts/rv1126.dtsi b/arch/arm/boot/dts/rv1126.dtsi
index 1cb43147e90b..bae318c1d839 100644
--- a/arch/arm/boot/dts/rv1126.dtsi
+++ b/arch/arm/boot/dts/rv1126.dtsi
@@ -90,6 +90,69 @@ xin24m: oscillator {
 		#clock-cells = <0>;
 	};
 
+	gmac_clkin_m0: external-gmac-clockm0 {
+		compatible = "fixed-clock";
+		clock-frequency = <125000000>;
+		clock-output-names = "clk_gmac_rgmii_clkin_m0";
+		#clock-cells = <0>;
+	};
+
+	gmac_clkini_m1: external-gmac-clockm1 {
+		compatible = "fixed-clock";
+		clock-frequency = <125000000>;
+		clock-output-names = "clk_gmac_rgmii_clkin_m1";
+		#clock-cells = <0>;
+	};
+
+	gmac: ethernet@ffc40000 {
+		compatible = "rockchip,rv1126-gmac", "snps,dwmac-4.20a";
+		reg = <0xffc40000 0x4000>;
+		interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "macirq", "eth_wake_irq";
+		rockchip,grf = <&grf>;
+		clocks = <&cru CLK_GMAC_SRC>, <&cru CLK_GMAC_TX_RX>,
+			 <&cru CLK_GMAC_TX_RX>, <&cru CLK_GMAC_REF>,
+			 <&cru ACLK_GMAC>, <&cru PCLK_GMAC>,
+			 <&cru CLK_GMAC_TX_RX>, <&cru CLK_GMAC_PTPREF>;
+		clock-names = "stmmaceth", "mac_clk_rx",
+			      "mac_clk_tx", "clk_mac_ref",
+			      "aclk_mac", "pclk_mac",
+			      "clk_mac_speed", "ptp_ref";
+		resets = <&cru SRST_GMAC_A>;
+		reset-names = "stmmaceth";
+
+		snps,mixed-burst;
+		snps,tso;
+
+		snps,axi-config = <&stmmac_axi_setup>;
+		snps,mtl-rx-config = <&mtl_rx_setup>;
+		snps,mtl-tx-config = <&mtl_tx_setup>;
+		status = "disabled";
+
+		mdio: mdio {
+			compatible = "snps,dwmac-mdio";
+			#address-cells = <0x1>;
+			#size-cells = <0x0>;
+		};
+
+		stmmac_axi_setup: stmmac-axi-config {
+			snps,wr_osr_lmt = <4>;
+			snps,rd_osr_lmt = <8>;
+			snps,blen = <0 0 0 0 16 8 4>;
+		};
+
+		mtl_rx_setup: rx-queues-config {
+			snps,rx-queues-to-use = <1>;
+			queue0 {};
+		};
+
+		mtl_tx_setup: tx-queues-config {
+			snps,tx-queues-to-use = <1>;
+			queue0 {};
+		};
+	};
+
 	grf: syscon@fe000000 {
 		compatible = "rockchip,rv1126-grf", "syscon", "simple-mfd";
 		reg = <0xfe000000 0x20000>;
-- 
2.39.0

