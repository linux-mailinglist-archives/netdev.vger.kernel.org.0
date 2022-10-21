Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB41F607BFF
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 18:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiJUQTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 12:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiJUQTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 12:19:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB74A27FAB7;
        Fri, 21 Oct 2022 09:19:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A0B4B82CA0;
        Fri, 21 Oct 2022 16:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4588C433D6;
        Fri, 21 Oct 2022 16:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666369152;
        bh=k9QkP/BFaRmPxQyPPvcZYHjcL7Yz23A2zYgMeiywtsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRGtWJ9m7cpUf3zsbQ67b0Koz1rC6UX3TSi4YHnay7OsmOj1pCLwPmJ4lxFmWKNiT
         QA7GMj0go7FL4vfBbg0Q2dqw3Jw/uvr2jCeGUwsKqwaqz1s+ZspvMSQffOoBqS8dov
         783qVXmFb30e09g4pho1OqZcHm2QyzqWiRy7KH9lchIeyACyBJs9ArT5Fzf2xZymny
         59yOG9YqSidChzyHl04N79Y0AHDIfiCGIoBnRil138zwMg+OIGVv+SPsRty5RHEThW
         n+lX5jVSahs6pv2a4AMR5iMR0U2BOH29YkQtv/RyLMuOZFIzTSoC7gr0j7MQaPQpp5
         LG41viaf5Yurw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
Subject: [PATCH net-next 1/6] arm64: dts: mediatek: mt7986: add support for RX Wireless Ethernet Dispatch
Date:   Fri, 21 Oct 2022 18:18:31 +0200
Message-Id: <27485d296c51aeae5a0c146e46df3f369d5be1ff.1666368566.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666368566.git.lorenzo@kernel.org>
References: <cover.1666368566.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 79 +++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 72e0d9722e07..3ee26cd0f8a9 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -8,6 +8,7 @@
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/clock/mt7986-clk.h>
 #include <dt-bindings/reset/mt7986-resets.h>
+#include <dt-bindings/reset/ti-syscon.h>
 
 / {
 	interrupt-parent = <&gic>;
@@ -75,6 +76,20 @@ secmon_reserved: secmon@43000000 {
 		wmcpu_emi: wmcpu-reserved@4fc00000 {
 			no-map;
 			reg = <0 0x4fc00000 0 0x00100000>;
+
+		wocpu0_emi: wocpu0_emi@4fd00000 {
+			reg = <0 0x4fd00000 0 0x40000>;
+			no-map;
+		};
+
+		wocpu1_emi: wocpu1_emi@4fd40000 {
+			reg = <0 0x4fd40000 0 0x40000>;
+			no-map;
+		};
+
+		wocpu_data: wocpu_data@4fd80000 {
+			reg = <0 0x4fd80000 0 0x240000>;
+			no-map;
 		};
 	};
 
@@ -226,6 +241,12 @@ ethsys: syscon@15000000 {
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
@@ -240,6 +261,12 @@ wed0: wed@15010000 {
 			reg = <0 0x15010000 0 0x1000>;
 			interrupt-parent = <&gic>;
 			interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
+			mediatek,wocpu_data = <&wocpu_data>;
+			mediatek,ap2woccif = <&ap2woccif0>;
+			mediatek,wocpu_ilm = <&wocpu0_ilm>;
+			mediatek,wocpu_dlm = <&wocpu0_dlm>;
+			mediatek,wocpu_emi = <&wocpu0_emi>;
+			mediatek,wocpu_boot = <&cpu_boot>;
 		};
 
 		wed1: wed@15011000 {
@@ -248,6 +275,58 @@ wed1: wed@15011000 {
 			reg = <0 0x15011000 0 0x1000>;
 			interrupt-parent = <&gic>;
 			interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
+			mediatek,wocpu_data = <&wocpu_data>;
+			mediatek,ap2woccif = <&ap2woccif1>;
+			mediatek,wocpu_ilm = <&wocpu1_ilm>;
+			mediatek,wocpu_dlm = <&wocpu1_dlm>;
+			mediatek,wocpu_emi = <&wocpu1_emi>;
+			mediatek,wocpu_boot = <&cpu_boot>;
+		};
+
+		ap2woccif0: ap2woccif@151a5000 {
+			compatible = "mediatek,ap2woccif",
+				     "syscon";
+			reg = <0 0x151a5000 0 0x1000>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 211 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
+		ap2woccif1: ap2woccif@0x151ad000 {
+			compatible = "mediatek,ap2woccif",
+				     "syscon";
+			reg = <0 0x151ad000 0 0x1000>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 212 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
+		wocpu0_ilm: wocpu0_ilm@151e0000 {
+			compatible = "mediatek,wocpu0_ilm";
+			reg = <0 0x151e0000 0 0x8000>;
+		};
+
+		wocpu1_ilm: wocpu1_ilm@151f0000 {
+			compatible = "mediatek,wocpu1_ilm";
+			reg = <0 0x151f0000 0 0x8000>;
+		};
+
+		wocpu0_dlm: wocpu_dlm@151e8000 {
+			compatible = "mediatek,wocpu_dlm";
+			reg = <0 0x151e8000 0 0x2000>;
+			resets = <&ethsysrst 0>;
+			reset-names = "wocpu_rst";
+		};
+
+		wocpu1_dlm: wocpu_dlm@0x151f8000 {
+			compatible = "mediatek,wocpu_dlm";
+			reg = <0 0x151f8000 0 0x2000>;
+			resets = <&ethsysrst 0>;
+			reset-names = "wocpu_rst";
+		};
+
+		cpu_boot: wocpu_boot@15194000 {
+			compatible = "mediatek,wocpu_boot",
+				     "syscon";
+			reg = <0 0x15194000 0 0x1000>;
 		};
 
 		eth: ethernet@15100000 {
-- 
2.37.3

