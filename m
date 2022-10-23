Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B303E609591
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 20:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiJWS2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 14:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiJWS2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 14:28:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B786112A;
        Sun, 23 Oct 2022 11:28:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B591560EF5;
        Sun, 23 Oct 2022 18:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E62C433D6;
        Sun, 23 Oct 2022 18:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666549706;
        bh=hq/OUm5IwFir6aoyVv7hgfICch5NZo+NXXIP7DNNrCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFdpitBy9Ta8IkSGni+rbTOcywmZE0SfnYpMLdDSYjCFVSo6aZDMsTeWzwImpGiOh
         O0fUytnvoXYNb9tKyQqE0+Er1VnO8KRATzXO2Th3TUim2Kuq8Wqh8gnlW8Vr3y5nwk
         jdXvd0SCtMoQW5POhTejRWcu9BpXYZROYbJ2HXm/mblqqy9g66u2l2I2J+1Wrld7oP
         uI00/3NEpU4uPz3byLHP8uOqWtzzwmL5XESg/qEL9vfzRoIllKOwJMGnvkRfnnInpl
         WpmB/WaHlc8dlKThuqOoctL6qsL61DDMX5rnTFvLLdlSdXH/bBsDphPvLmz2H1UlWZ
         T1DdnoTc/GplA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
Subject: [PATCH v2 net-next 1/6] arm64: dts: mediatek: mt7986: add support for RX Wireless Ethernet Dispatch
Date:   Sun, 23 Oct 2022 20:28:05 +0200
Message-Id: <41d67d36481f3099f953a462a80e99a4fcd477dd.1666549145.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666549145.git.lorenzo@kernel.org>
References: <cover.1666549145.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to TX Wireless Ethernet Dispatch, introduce RX Wireless Ethernet
Dispatch to offload traffic received by the wlan interface to lan/wan
one.

Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 73 +++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 72e0d9722e07..e3b05280dcb6 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -8,6 +8,7 @@
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/clock/mt7986-clk.h>
 #include <dt-bindings/reset/mt7986-resets.h>
+#include <dt-bindings/reset/ti-syscon.h>
 
 / {
 	interrupt-parent = <&gic>;
@@ -76,6 +77,31 @@ wmcpu_emi: wmcpu-reserved@4fc00000 {
 			no-map;
 			reg = <0 0x4fc00000 0 0x00100000>;
 		};
+
+		wo_emi0: wo-emi0@4fd00000 {
+			reg = <0 0x4fd00000 0 0x40000>;
+			no-map;
+		};
+
+		wo_emi1: wo-emi1@4fd40000 {
+			reg = <0 0x4fd40000 0 0x40000>;
+			no-map;
+		};
+
+		wo_ilm0: wo-ilm0@151e0000 {
+			reg = <0 0x151e0000 0 0x8000>;
+			no-map;
+		};
+
+		wo_ilm1: wo-ilm1@151f0000 {
+			reg = <0 0x151f0000 0 0x8000>;
+			no-map;
+		};
+
+		wo_data: wo-data@4fd80000 {
+			reg = <0 0x4fd80000 0 0x240000>;
+			no-map;
+		};
 	};
 
 	timer {
@@ -226,6 +252,12 @@ ethsys: syscon@15000000 {
 			 reg = <0 0x15000000 0 0x1000>;
 			 #clock-cells = <1>;
 			 #reset-cells = <1>;
+
+			ethsysrst: reset-controller {
+				compatible = "ti,syscon-reset";
+				#reset-cells = <1>;
+				ti,reset-bits = <0x34 4 0x34 4 0x34 4 (ASSERT_SET | DEASSERT_CLEAR | STATUS_SET)>;
+			};
 		};
 
 		wed_pcie: wed-pcie@10003000 {
@@ -240,6 +272,10 @@ wed0: wed@15010000 {
 			reg = <0 0x15010000 0 0x1000>;
 			interrupt-parent = <&gic>;
 			interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
+			memory-region = <&wo_emi0>, <&wo_ilm0>, <&wo_data>;
+			mediatek,wo-ccif = <&wo_ccif0>;
+			mediatek,wo-dlm = <&wo_dlm0>;
+			mediatek,wo-boot = <&wo_boot>;
 		};
 
 		wed1: wed@15011000 {
@@ -248,6 +284,43 @@ wed1: wed@15011000 {
 			reg = <0 0x15011000 0 0x1000>;
 			interrupt-parent = <&gic>;
 			interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
+			memory-region = <&wo_emi1>, <&wo_ilm1>, <&wo_data>;
+			mediatek,wo-ccif = <&wo_ccif1>;
+			mediatek,wo-dlm = <&wo_dlm1>;
+			mediatek,wo-boot = <&wo_boot>;
+		};
+
+		wo_ccif0: wo-ccif1@151a5000 {
+			compatible = "mediatek,mt7986-wo-ccif","syscon";
+			reg = <0 0x151a5000 0 0x1000>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 211 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
+		wo_ccif1: wo-ccif1@151ad000 {
+			compatible = "mediatek,mt7986-wo-ccif","syscon";
+			reg = <0 0x151ad000 0 0x1000>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 212 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
+		wo_dlm0: wo-dlm@151e8000 {
+			compatible = "mediatek,mt7986-wo-dlm";
+			reg = <0 0x151e8000 0 0x2000>;
+			resets = <&ethsysrst 0>;
+			reset-names = "wocpu_rst";
+		};
+
+		wo_dlm1: wo-dlm@0x151f8000 {
+			compatible = "mediatek,mt7986-wo-dlm";
+			reg = <0 0x151f8000 0 0x2000>;
+			resets = <&ethsysrst 0>;
+			reset-names = "wocpu_rst";
+		};
+
+		wo_boot: wo-boot@15194000 {
+			compatible = "mediatek,mt7986-wo-boot","syscon";
+			reg = <0 0x15194000 0 0x1000>;
 		};
 
 		eth: ethernet@15100000 {
-- 
2.37.3

