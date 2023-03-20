Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28ECC6C1D40
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbjCTRG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbjCTRGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:06:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B9CCDDB;
        Mon, 20 Mar 2023 10:01:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 274DBB8100B;
        Mon, 20 Mar 2023 16:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B860C433D2;
        Mon, 20 Mar 2023 16:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679331568;
        bh=erXq85FyIZtloI+86moWAdAbuiYWCHhJtUTWTR5zF24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6Yew46aNS37ilruUDPlt8PDEPagkM02hjjuYvwmCyha0ErZGzm+AnrYwU4QfSneu
         aVhngWEpjFKmnzW/ounuNw2VTPBYK4UVmX8666/kyvzx4MvPPWvIXSuo7ty1fSrpqy
         EX3RTHitTqmOuAENKuqWmy+Wdj9oPbECvfe4MbQFZ7Xjl3Fdz6HucCyw2CwowTc8rZ
         ToR74R+tKAslNphht+kW1LWEEtow7yyvayizvEUUwtY52+nkSy6g5qRQ0RAmBw5rE2
         PC7E4NPpSULVp1NCM8fVAB66RJFwZvCIJ15jlo4d4P3tBnHbs8tNTQpeliwS2Fpx1Y
         G4KaBPh8WWIvQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH net-next 10/10] arm64: dts: mt7986: move dlm in a dedicated node
Date:   Mon, 20 Mar 2023 17:58:04 +0100
Message-Id: <d74e38de00ad1b858b59a7ef6cb02321b0faf750.1679330630.git.lorenzo@kernel.org>
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

Since the dlm memory region is not part of the RAM SoC, move dlm in a
deidicated syscon node.
This patch helps to keep backward-compatibility with older version of
uboot codebase where we have a limit of 8 reserved-memory dts child
nodes.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 30 ++++++++++++-----------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index a0d96d232ee5..0ae6aa59d3c6 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -93,16 +93,6 @@ wo_data: wo-data@4fd80000 {
 			reg = <0 0x4fd80000 0 0x240000>;
 			no-map;
 		};
-
-		wo_dlm0: wo-dlm@151e8000 {
-			reg = <0 0x151e8000 0 0x2000>;
-			no-map;
-		};
-
-		wo_dlm1: wo-dlm@151f8000 {
-			reg = <0 0x151f8000 0 0x2000>;
-			no-map;
-		};
 	};
 
 	timer {
@@ -444,10 +434,11 @@ wed0: wed@15010000 {
 			reg = <0 0x15010000 0 0x1000>;
 			interrupt-parent = <&gic>;
 			interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
-			memory-region = <&wo_emi0>, <&wo_dlm0>, <&wo_data>;
-			memory-region-names = "wo-emi", "wo-dlm", "wo-data";
+			memory-region = <&wo_emi0>, <&wo_data>;
+			memory-region-names = "wo-emi", "wo-data";
 			mediatek,wo-ccif = <&wo_ccif0>;
 			mediatek,wo-ilm = <&wo_ilm0>;
+			mediatek,wo-dlm = <&wo_dlm0>;
 			mediatek,wo-cpuboot = <&wo_cpuboot>;
 		};
 
@@ -457,10 +448,11 @@ wed1: wed@15011000 {
 			reg = <0 0x15011000 0 0x1000>;
 			interrupt-parent = <&gic>;
 			interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
-			memory-region = <&wo_emi1>, <&wo_dlm1>, <&wo_data>;
-			memory-region-names = "wo-emi", "wo-dlm", "wo-data";
+			memory-region = <&wo_emi1>, <&wo_data>;
+			memory-region-names = "wo-emi", "wo-data";
 			mediatek,wo-ccif = <&wo_ccif1>;
 			mediatek,wo-ilm = <&wo_ilm1>;
+			mediatek,wo-dlm = <&wo_dlm1>;
 			mediatek,wo-cpuboot = <&wo_cpuboot>;
 		};
 
@@ -488,6 +480,16 @@ wo_ilm1: syscon@151f0000 {
 			reg = <0 0x151f0000 0 0x8000>;
 		};
 
+		wo_dlm0: syscon@151e8000 {
+			compatible = "mediatek,mt7986-wo-dlm", "syscon";
+			reg = <0 0x151e8000 0 0x2000>;
+		};
+
+		wo_dlm1: syscon@151f8000 {
+			compatible = "mediatek,mt7986-wo-dlm", "syscon";
+			reg = <0 0x151f8000 0 0x2000>;
+		};
+
 		wo_cpuboot: syscon@15194000 {
 			compatible = "mediatek,mt7986-wo-cpuboot", "syscon";
 			reg = <0 0x15194000 0 0x1000>;
-- 
2.39.2

