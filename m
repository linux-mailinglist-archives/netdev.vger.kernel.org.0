Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2856352F225
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352427AbiETSM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352435AbiETSMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:12:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE6A18C07B;
        Fri, 20 May 2022 11:12:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC082617A3;
        Fri, 20 May 2022 18:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F982C385A9;
        Fri, 20 May 2022 18:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653070341;
        bh=jjinRlKFxifScyEw3OjetYoQ52Kq5EtAMT5xBGYx7aA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LiwTZmXLHfwOJAT5WaYmr6GlPo9pA3MmpoMzn3RfKNDZ1dheuVogGEZk6YW1WsfQ+
         /ZpZ8kVybqRn38Xa/PVeqJRKONhBKe9PYiA780J4NkP/wEQXk3muwCiwyiAO5JOcOs
         uwBn+PY8XEe1sgLslmvW1A2SYwMFQbwtcOkmwbrDrpOZV79USdRgl/2m1HWTb7GOke
         1UMzCaF/Y8DrcwvbjderK/HMWJEp6NLK15dW6KnZqkBG+zLgyTjFHyn+xaVLaKHeuU
         nIVv0zd270SKdJvmqMkN66EtcxLiOTsgYiTazRjSf+qL+WHPeBlBGYFSi3nb/JIax5
         I9J4Ns8iPi/DQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v3 net-next 01/16] arm64: dts: mediatek: mt7986: introduce ethernet nodes
Date:   Fri, 20 May 2022 20:11:24 +0200
Message-Id: <6b41d8c5f3c88328947a9d0850ac01f1f98e7da5.1653069056.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653069056.git.lorenzo@kernel.org>
References: <cover.1653069056.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/arm64/boot/dts/mediatek/mt7986a-rfb.dts | 74 ++++++++++++++++++++
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi    | 39 +++++++++++
 arch/arm64/boot/dts/mediatek/mt7986b-rfb.dts | 70 ++++++++++++++++++
 3 files changed, 183 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a-rfb.dts b/arch/arm64/boot/dts/mediatek/mt7986a-rfb.dts
index 21e420829572..882277a52b69 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a-rfb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt7986a-rfb.dts
@@ -25,6 +25,80 @@ memory@40000000 {
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
+	mdio: mdio-bus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+};
+
+&mdio {
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
+		port@4 {
+			reg = <4>;
+			label = "lan4";
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
index d73467ea3641..0f49d5764ff3 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986b-rfb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt7986b-rfb.dts
@@ -28,3 +28,73 @@ memory@40000000 {
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
+	mdio: mdio-bus {
+		#address-cells = <1>;
+		#size-cells = <0>;
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
+				port@4 {
+					reg = <4>;
+					label = "lan4";
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
2.35.3

