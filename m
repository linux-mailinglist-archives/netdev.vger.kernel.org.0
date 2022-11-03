Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94536179F1
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 10:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbiKCJ3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 05:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiKCJ3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 05:29:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2565E0E4;
        Thu,  3 Nov 2022 02:28:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EB0861DD9;
        Thu,  3 Nov 2022 09:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CFEC433D6;
        Thu,  3 Nov 2022 09:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667467722;
        bh=I9mSsyI6n40XB9Lh0ez9uRU4qkTdwM8u62UijOFX84A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVaERi2vyjNKENagsDzvwVPaBRVMk/xgR/+SvR5KdGk3qi7rWlPKnxuSfA694I0pr
         y38TUd/f2m8J74AoIQkUWeVBMPbqdTw2Wn1HIMgr4NKPcshRYS3zI2+iWEA0HnNY4B
         NshHc8hoiYitvA9OL1W2a72rdvpmpyw1mZYShyo1I6MnKEYNZNAZjsrWrMOGx+Sz3f
         hPhJU2sq+FpA4JWFcL1c7CYWR3MR1wJV137SzxwlXRrgbMkJKvUe7IMGRs5SHvgD05
         IX0VCLk+EO1pFKSiJdu4pmq3vvmOitFdaIqWACL/6wREzPVr5NXjgwZpiG53VIfX8o
         aHnlZka16cXfg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org
Subject: [PATCH v3 net-next 1/8] arm64: dts: mediatek: mt7986: add support for RX Wireless Ethernet Dispatch
Date:   Thu,  3 Nov 2022 10:28:00 +0100
Message-Id: <4bd5f6626174ac042c0e9b9f2ffff40c3c72b88a.1667466887.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1667466887.git.lorenzo@kernel.org>
References: <cover.1667466887.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 75 +++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 72e0d9722e07..b0a593c6020e 100644
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
+		wo_emi0: wo-emi@4fd00000 {
+			reg = <0 0x4fd00000 0 0x40000>;
+			no-map;
+		};
+
+		wo_emi1: wo-emi@4fd40000 {
+			reg = <0 0x4fd40000 0 0x40000>;
+			no-map;
+		};
+
+		wo_ilm0: wo-ilm@151e0000 {
+			reg = <0 0x151e0000 0 0x8000>;
+			no-map;
+		};
+
+		wo_ilm1: wo-ilm@151f0000 {
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
@@ -240,6 +272,11 @@ wed0: wed@15010000 {
 			reg = <0 0x15010000 0 0x1000>;
 			interrupt-parent = <&gic>;
 			interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
+			memory-region = <&wo_emi0>, <&wo_ilm0>, <&wo_data>;
+			memory-region-names = "wo-emi", "wo-ilm", "wo-data";
+			mediatek,wo-ccif = <&wo_ccif0>;
+			mediatek,wo-boot = <&wo_boot>;
+			mediatek,wo-dlm = <&wo_dlm0>;
 		};
 
 		wed1: wed@15011000 {
@@ -248,6 +285,44 @@ wed1: wed@15011000 {
 			reg = <0 0x15011000 0 0x1000>;
 			interrupt-parent = <&gic>;
 			interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
+			memory-region = <&wo_emi1>, <&wo_ilm1>, <&wo_data>;
+			memory-region-names = "wo-emi", "wo-ilm", "wo-data";
+			mediatek,wo-ccif = <&wo_ccif1>;
+			mediatek,wo-boot = <&wo_boot>;
+			mediatek,wo-dlm = <&wo_dlm1>;
+		};
+
+		wo_ccif0: syscon@151a5000 {
+			compatible = "mediatek,mt7986-wo-ccif", "syscon";
+			reg = <0 0x151a5000 0 0x1000>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 211 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
+		wo_ccif1: syscon@151ad000 {
+			compatible = "mediatek,mt7986-wo-ccif", "syscon";
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
+		wo_dlm1: wo-dlm@151f8000 {
+			compatible = "mediatek,mt7986-wo-dlm";
+			reg = <0 0x151f8000 0 0x2000>;
+			resets = <&ethsysrst 0>;
+			reset-names = "wocpu_rst";
+		};
+
+		wo_boot: syscon@15194000 {
+			compatible = "mediatek,mt7986-wo-boot", "syscon";
+			reg = <0 0x15194000 0 0x1000>;
 		};
 
 		eth: ethernet@15100000 {
-- 
2.38.1

