Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE4F656076
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 07:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbiLZGhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 01:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiLZGhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 01:37:04 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8D65F69
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 22:36:50 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d15so10042049pls.6
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 22:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edgeble-ai.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zRydJoD+3l5BbQJGYGzK94pJXqmLy5AkAXCFfnzAak8=;
        b=BFKUYDcDi3wJiuZe2q7RhU8Ttz5/yi1pUbqQclFaweXlBEp/WqAB8nILCvIWhw/Ljp
         bedu0Ey77KV4ihqj2K2cN2YqIO15O44OogbyVhFhzzHZaLxoIAitNkdqucOPEhv2jlIi
         UrkSEQafSVHrGMtwZycsUn8w0jHX9WlsHbZg/IMdhgYzcn+xfB2PuOhb7Q8FInRZuB4o
         D1hRwpcy5kOAsZZiTitt/JNsKp2CLLMDMdaI1lojwdsq5H+ZWMBJI2bfBiicfLMJopp9
         cpus5BZf7g9N+aA2ptDcdEBC/uvCexvfJMiQcnBZc2hJ+lit6eBpvMdkVGiFbKu05QDp
         PA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zRydJoD+3l5BbQJGYGzK94pJXqmLy5AkAXCFfnzAak8=;
        b=3qWg4VjWXjQ+5N+323VE6q5iWhM04Rxv/J1jlAY8q8kvMaOizLE+jR4ruUEsxeP+4y
         oCzQz207ruTe/agxNxGoO5dAd52danmzUtWcN5XOCIxc/qPFRHl/lERGgAhDSmQtgjP/
         j8mEOvUSS66zhOQ0agHJFPLAhJLVJ3rVvCWklY0g9nDTHYTV4HyPYnX8pd+N3IrHmsNJ
         M3senrYI/7pwexmIwVZSxGMbTB8KarV6/goHkHJ1WgMenczP8fTcX5F8f/G0r0lszrF3
         ++i65M66+OvSWQqKAwuDdms8Kw6jNO9f0lsw6laOUO0ZMuI4lmopgJoM2zMRRiiEEPwd
         w5UQ==
X-Gm-Message-State: AFqh2kqpyvZc7Ne7DCnJPBywhOdx7isPSYfoA22ifPZKxkN29qLTcbw9
        rkhsimDuSOUTOsOYTTDjMeQs1K+PBwzqSiUj2qY=
X-Google-Smtp-Source: AMrXdXvW7ZGz0p3A8h2MncIToc6h6JK5uh5DjZOAx25rPJ7yJsQI2fj/1Ma3hLFakhZZ83eXaZUb6g==
X-Received: by 2002:a17:90a:ce07:b0:21a:db1:d87e with SMTP id f7-20020a17090ace0700b0021a0db1d87emr34264398pju.8.1672036610156;
        Sun, 25 Dec 2022 22:36:50 -0800 (PST)
Received: from archl-hc1b.. ([45.112.3.26])
        by smtp.gmail.com with ESMTPSA id 31-20020a63145f000000b0047048c201e3sm5730659pgu.33.2022.12.25.22.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Dec 2022 22:36:49 -0800 (PST)
From:   Anand Moon <anand@edgeble.ai>
To:     Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Anand Moon <anand@edgeble.ai>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCHv2 linux-next 3/4] ARM: dts: rockchip: rv1126: Add GMAC node
Date:   Mon, 26 Dec 2022 06:36:21 +0000
Message-Id: <20221226063625.1913-3-anand@edgeble.ai>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221226063625.1913-1-anand@edgeble.ai>
References: <20221226063625.1913-1-anand@edgeble.ai>
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
---
drop SoB of Jagan Teki
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

