Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4ADB61DF17
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 23:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiKEWgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 18:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiKEWgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 18:36:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C820212747;
        Sat,  5 Nov 2022 15:36:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DC78B802BD;
        Sat,  5 Nov 2022 22:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8496AC433D6;
        Sat,  5 Nov 2022 22:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667687795;
        bh=Kb6KkBtmhNtLWv9svClSm5pwHrj3YLKeWKy7cZ60Dhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kb5rlFRcEG6VYbqtLWZqPKgVraRlXezA0Q5OT13FlmzX4f5auc1Tr4a0WI+6qWD7w
         k3FPfo0lydIpvbbEKaWWHs4WizNtWuoWC5yknS91Tr2Po/RRPnlDC/5tJ64WjY46GZ
         4jPdixy8OKD4cfj5axXP4N5bEcXnxVMJg5kzHwLdDuWtZlymOIlQNQw0/Kq3P7jfhf
         D3JNFCMJPJXQy3IPA8HgUvOwF3qdxPqbV45Ia+p3k/FjUkRkRxiHBb2qSPlkqwKNxW
         1elacvi8C4exa4z6xD72S9qI2KPVnonC58nN8xbketcO5AHgLyE9NQx8ZVfRfAehjb
         DJfSNyUAnRb4Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org,
        angelogioacchino.delregno@collabora.com
Subject: [PATCH v4 net-next 1/8] arm64: dts: mediatek: mt7986: add support for RX Wireless Ethernet Dispatch
Date:   Sat,  5 Nov 2022 23:36:16 +0100
Message-Id: <e3489a697b404bd47447190cd2e5adf090ae61c2.1667687249.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1667687249.git.lorenzo@kernel.org>
References: <cover.1667687249.git.lorenzo@kernel.org>
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
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 65 +++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 72e0d9722e07..07dee1c0d281 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -76,6 +76,47 @@ wmcpu_emi: wmcpu-reserved@4fc00000 {
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
+
+		wo_dlm0: wo-dlm@151e8000 {
+			reg = <0 0x151e8000 0 0x2000>;
+			no-map;
+		};
+
+		wo_dlm1: wo-dlm@151f8000 {
+			reg = <0 0x151f8000 0 0x2000>;
+			no-map;
+		};
+
+		wo_boot: wo-boot@15194000 {
+			reg = <0 0x15194000 0 0x1000>;
+			no-map;
+		};
+
 	};
 
 	timer {
@@ -240,6 +281,11 @@ wed0: wed@15010000 {
 			reg = <0 0x15010000 0 0x1000>;
 			interrupt-parent = <&gic>;
 			interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
+			memory-region = <&wo_emi0>, <&wo_ilm0>, <&wo_dlm0>,
+					<&wo_data>, <&wo_boot>;
+			memory-region-names = "wo-emi", "wo-ilm", "wo-dlm",
+					      "wo-data", "wo-boot";
+			mediatek,wo-ccif = <&wo_ccif0>;
 		};
 
 		wed1: wed@15011000 {
@@ -248,6 +294,25 @@ wed1: wed@15011000 {
 			reg = <0 0x15011000 0 0x1000>;
 			interrupt-parent = <&gic>;
 			interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
+			memory-region = <&wo_emi1>, <&wo_ilm1>, <&wo_dlm1>,
+					<&wo_data>, <&wo_boot>;
+			memory-region-names = "wo-emi", "wo-ilm", "wo-dlm",
+					      "wo-data", "wo-boot";
+			mediatek,wo-ccif = <&wo_ccif1>;
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
 		};
 
 		eth: ethernet@15100000 {
-- 
2.38.1

