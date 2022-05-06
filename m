Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D2B51D7CB
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 14:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391962AbiEFMfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 08:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349746AbiEFMe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 08:34:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AF63A5E0;
        Fri,  6 May 2022 05:31:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 727F6B835A9;
        Fri,  6 May 2022 12:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C7DC385B0;
        Fri,  6 May 2022 12:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651840272;
        bh=e3HwAJgXFgwZGADyox9TBD3Y9WV6JkXcZIW+MQUu/l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyKQ+Z/2iNSsacZdxEB+bSaKGYt8+oGUl3W40JLVbXszHsGFZLQJBYtQhjo5fhqMf
         /Axfzylm7GypmnWx2HzPFDYqNak/SN0T2+ATJ6c3zFk0ekHk50FX2XGeSmNGYQZcZw
         XGFbWoede4bNXwfAs+gxwHdzuikaRhd+ThoMjs2uBRofqydmq5R3GYZEfA4+cYb/UK
         1hzGY8RmmmysbS4UcTBbQvzXjDxrQRkOzAtarTFeDM43k3R5uLIWdY8Ph3XLyAh8g+
         3seQ/+btLGMnMu9WOGBopJuoDv0uUL8oAvn3oi62vx2rxASK9vcjCf3N0goEGQlDaT
         odl4NelENn6+Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org
Subject: [PATCH net-next 01/14] arm64: dts: mediatek: mt7986: introduce ethernet nodes
Date:   Fri,  6 May 2022 14:30:18 +0200
Message-Id: <1d555fbbac820e9b580da3e8c0db30e7d003c4b6.1651839494.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651839494.git.lorenzo@kernel.org>
References: <cover.1651839494.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce ethernet nodes in mt7986 bindings in order to
enable mt7986a/mt7986b ethernet support.

Co-developed-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a-rfb.dts | 95 ++++++++++++++++++++
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi    | 39 ++++++++
 arch/arm64/boot/dts/mediatek/mt7986b-rfb.dts | 91 +++++++++++++++++++
 3 files changed, 225 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a-rfb.dts b/arch/arm64/boot/dts/mediatek/mt7986a-rfb.dts
index 21e420829572..c5a4e999234c 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a-rfb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt7986a-rfb.dts
@@ -25,6 +25,101 @@ memory@40000000 {
 	};
 };
 
+&eth {
+	status = "okay";
+
+	gmac0: mac@0 {
+		compatible = "mediatek,eth-mac";
+		reg = <0>;
+		phy-mode = "2500base-x";
+
+		fixed-link {
+			speed = <2500>;
+			full-duplex;
+			pause;
+		};
+	};
+
+	gmac1: mac@1 {
+		compatible = "mediatek,eth-mac";
+		reg = <1>;
+		phy-mode = "2500base-x";
+
+		fixed-link {
+			speed = <2500>;
+			full-duplex;
+			pause;
+		};
+	};
+
+	mdio: mdio-bus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+};
+
+&mdio {
+	phy5: phy@5 {
+		compatible = "ethernet-phy-id67c9.de0a";
+		reg = <5>;
+		reset-gpios = <&pio 6 1>;
+		reset-deassert-us = <20000>;
+		phy-mode = "2500base-x";
+	};
+
+	phy6: phy@6 {
+		compatible = "ethernet-phy-id67c9.de0a";
+		reg = <6>;
+		phy-mode = "2500base-x";
+	};
+
+	switch: switch@0 {
+		compatible = "mediatek,mt7531";
+		reg = <31>;
+		reset-gpios = <&pio 5 0>;
+	};
+};
+
+&switch {
+	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@0 {
+			reg = <0>;
+			label = "lan0";
+		};
+
+		port@1 {
+			reg = <1>;
+			label = "lan1";
+		};
+
+		port@2 {
+			reg = <2>;
+			label = "lan2";
+		};
+
+		port@3 {
+			reg = <3>;
+			label = "lan3";
+		};
+
+		port@6 {
+			reg = <6>;
+			label = "cpu";
+			ethernet = <&gmac0>;
+			phy-mode = "2500base-x";
+
+			fixed-link {
+				speed = <2500>;
+				full-duplex;
+				pause;
+			};
+		};
+	};
+};
+
 &uart0 {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 694acf8f5b70..d2636a0ed152 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -222,6 +222,45 @@ ethsys: syscon@15000000 {
 			 #reset-cells = <1>;
 		};
 
+		eth: ethernet@15100000 {
+			compatible = "mediatek,mt7986-eth";
+			reg = <0 0x15100000 0 0x80000>;
+			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 197 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 198 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 199 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ethsys CLK_ETH_FE_EN>,
+				 <&ethsys CLK_ETH_GP2_EN>,
+				 <&ethsys CLK_ETH_GP1_EN>,
+				 <&ethsys CLK_ETH_WOCPU1_EN>,
+				 <&ethsys CLK_ETH_WOCPU0_EN>,
+				 <&sgmiisys0 CLK_SGMII0_TX250M_EN>,
+				 <&sgmiisys0 CLK_SGMII0_RX250M_EN>,
+				 <&sgmiisys0 CLK_SGMII0_CDR_REF>,
+				 <&sgmiisys0 CLK_SGMII0_CDR_FB>,
+				 <&sgmiisys1 CLK_SGMII1_TX250M_EN>,
+				 <&sgmiisys1 CLK_SGMII1_RX250M_EN>,
+				 <&sgmiisys1 CLK_SGMII1_CDR_REF>,
+				 <&sgmiisys1 CLK_SGMII1_CDR_FB>,
+				 <&topckgen CLK_TOP_NETSYS_SEL>,
+				 <&topckgen CLK_TOP_NETSYS_500M_SEL>;
+			clock-names = "fe", "gp2", "gp1", "wocpu1", "wocpu0",
+				      "sgmii_tx250m", "sgmii_rx250m",
+				      "sgmii_cdr_ref", "sgmii_cdr_fb",
+				      "sgmii2_tx250m", "sgmii2_rx250m",
+				      "sgmii2_cdr_ref", "sgmii2_cdr_fb",
+				      "netsys0", "netsys1";
+			assigned-clocks = <&topckgen CLK_TOP_NETSYS_2X_SEL>,
+					  <&topckgen CLK_TOP_SGM_325M_SEL>;
+			assigned-clock-parents = <&apmixedsys CLK_APMIXED_NET2PLL>,
+						 <&apmixedsys CLK_APMIXED_SGMPLL>;
+			mediatek,ethsys = <&ethsys>;
+			mediatek,sgmiisys = <&sgmiisys0>, <&sgmiisys1>;
+			#reset-cells = <1>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+		};
 	};
 
 };
diff --git a/arch/arm64/boot/dts/mediatek/mt7986b-rfb.dts b/arch/arm64/boot/dts/mediatek/mt7986b-rfb.dts
index d73467ea3641..5ed275dcd3dc 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986b-rfb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt7986b-rfb.dts
@@ -28,3 +28,94 @@ memory@40000000 {
 &uart0 {
 	status = "okay";
 };
+
+&eth {
+	status = "okay";
+
+	gmac0: mac@0 {
+		compatible = "mediatek,eth-mac";
+		reg = <0>;
+		phy-mode = "2500base-x";
+
+		fixed-link {
+			speed = <2500>;
+			full-duplex;
+			pause;
+		};
+	};
+
+	gmac1: mac@1 {
+		compatible = "mediatek,eth-mac";
+		reg = <1>;
+		phy-mode = "2500base-x";
+
+		fixed-link {
+			speed = <2500>;
+			full-duplex;
+			pause;
+		};
+	};
+
+	mdio: mdio-bus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		phy5: phy@5 {
+			compatible = "ethernet-phy-id67c9.de0a";
+			reg = <5>;
+			reset-gpios = <&pio 6 1>;
+			reset-deassert-us = <20000>;
+			phy-mode = "2500base-x";
+		};
+
+		phy6: phy@6 {
+			compatible = "ethernet-phy-id67c9.de0a";
+			reg = <6>;
+			phy-mode = "2500base-x";
+		};
+
+		switch@0 {
+			compatible = "mediatek,mt7531";
+			reg = <31>;
+			reset-gpios = <&pio 5 0>;
+
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				port@0 {
+					reg = <0>;
+					label = "lan0";
+				};
+
+				port@1 {
+					reg = <1>;
+					label = "lan1";
+				};
+
+				port@2 {
+					reg = <2>;
+					label = "lan2";
+				};
+
+				port@3 {
+					reg = <3>;
+					label = "lan3";
+				};
+
+				port@6 {
+					reg = <6>;
+					label = "cpu";
+					ethernet = <&gmac0>;
+					phy-mode = "2500base-x";
+
+					fixed-link {
+						speed = <2500>;
+						full-duplex;
+						pause;
+					};
+				};
+			};
+		};
+	};
+};
-- 
2.35.1

