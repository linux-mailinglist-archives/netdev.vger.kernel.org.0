Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1906C1D3E
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbjCTRG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbjCTRGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:06:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1937C3AA9;
        Mon, 20 Mar 2023 10:01:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EB1161706;
        Mon, 20 Mar 2023 16:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB44C433D2;
        Mon, 20 Mar 2023 16:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679331557;
        bh=4/gQUt4YWFNm/6YwT4rVQA1tyKYT3o8UQlO++zo/1OQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c085N1aFCtD3ZLC4G1Wr8tStlsKV6pZIijpWWJYjGy3QwNos3yiXvlVHdk2EcxakJ
         jiIUavZhu2ccRhaGs1ck01pU0vRKizw6jsvX6n/fuX3jtB6t5TF7fYzz9517/TEFPX
         bQjo5Pq2woJfNNLCzww7s+ebjulp9XqmleR37touusZAD2xsFpIx5uaCtdndBhX3Rd
         tubf6mrBkjcKWm+1+LFypVN0Xw83NqnhXEm3XT1bPcqc/+G/2rbZQj+yDQ5xSylJ17
         su7dQ6q84anmfWwSWQqY3Dm5vnoyA3JKkhC/xwwNhIyJiUkZphjubGqb8tuqthCj+3
         R6zxdpF/VtLBg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH net-next 07/10] arm64: dts: mt7986: move ilm in a dedicated node
Date:   Mon, 20 Mar 2023 17:58:01 +0100
Message-Id: <5e1168bc8fd29f4871f81d8e4a9fd43a2c3be146.1679330630.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1679330630.git.lorenzo@kernel.org>
References: <cover.1679330630.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the ilm memory region is not part of the RAM SoC, move ilm in a
deidicated syscon node.
This patch helps to keep backward-compatibility with older version of
uboot codebase where we have a limit of 8 reserved-memory dts child
nodes.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 34 +++++++++++------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 668b6cfa6a3d..a0d96d232ee5 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -89,16 +89,6 @@ wo_emi1: wo-emi@4fd40000 {
 			no-map;
 		};
 
-		wo_ilm0: wo-ilm@151e0000 {
-			reg = <0 0x151e0000 0 0x8000>;
-			no-map;
-		};
-
-		wo_ilm1: wo-ilm@151f0000 {
-			reg = <0 0x151f0000 0 0x8000>;
-			no-map;
-		};
-
 		wo_data: wo-data@4fd80000 {
 			reg = <0 0x4fd80000 0 0x240000>;
 			no-map;
@@ -454,11 +444,10 @@ wed0: wed@15010000 {
 			reg = <0 0x15010000 0 0x1000>;
 			interrupt-parent = <&gic>;
 			interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
-			memory-region = <&wo_emi0>, <&wo_ilm0>, <&wo_dlm0>,
-					<&wo_data>;
-			memory-region-names = "wo-emi", "wo-ilm", "wo-dlm",
-					      "wo-data";
+			memory-region = <&wo_emi0>, <&wo_dlm0>, <&wo_data>;
+			memory-region-names = "wo-emi", "wo-dlm", "wo-data";
 			mediatek,wo-ccif = <&wo_ccif0>;
+			mediatek,wo-ilm = <&wo_ilm0>;
 			mediatek,wo-cpuboot = <&wo_cpuboot>;
 		};
 
@@ -468,11 +457,10 @@ wed1: wed@15011000 {
 			reg = <0 0x15011000 0 0x1000>;
 			interrupt-parent = <&gic>;
 			interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
-			memory-region = <&wo_emi1>, <&wo_ilm1>, <&wo_dlm1>,
-					<&wo_data>;
-			memory-region-names = "wo-emi", "wo-ilm", "wo-dlm",
-					      "wo-data";
+			memory-region = <&wo_emi1>, <&wo_dlm1>, <&wo_data>;
+			memory-region-names = "wo-emi", "wo-dlm", "wo-data";
 			mediatek,wo-ccif = <&wo_ccif1>;
+			mediatek,wo-ilm = <&wo_ilm1>;
 			mediatek,wo-cpuboot = <&wo_cpuboot>;
 		};
 
@@ -490,6 +478,16 @@ wo_ccif1: syscon@151ad000 {
 			interrupts = <GIC_SPI 212 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
+		wo_ilm0: syscon@151e0000 {
+			compatible = "mediatek,mt7986-wo-ilm", "syscon";
+			reg = <0 0x151e0000 0 0x8000>;
+		};
+
+		wo_ilm1: syscon@151f0000 {
+			compatible = "mediatek,mt7986-wo-ilm", "syscon";
+			reg = <0 0x151f0000 0 0x8000>;
+		};
+
 		wo_cpuboot: syscon@15194000 {
 			compatible = "mediatek,mt7986-wo-cpuboot", "syscon";
 			reg = <0 0x15194000 0 0x1000>;
-- 
2.39.2

