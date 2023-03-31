Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709BD6D214B
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbjCaNO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbjCaNOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:14:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5CE2033D;
        Fri, 31 Mar 2023 06:14:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EE66B82F6C;
        Fri, 31 Mar 2023 13:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85E1C433D2;
        Fri, 31 Mar 2023 13:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680268446;
        bh=mkUhLoNbLeiHtSsfwVORMtUtAD48E6wlCdxRrEPVV30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqULA+hFBdKRZjy/9rQlidaQwQ578NiyOjHLH2/c7HVAHeq3QEHMJjfqrxIioizZ9
         RVhRZ6N1u4stIykzG7h02KfCC2ucGV52xwu//c7ZBYKCA4dcbPCYsQoclPVDXZZ24A
         WYTlrj9yDDiJ8tenhJDOuk19mNzJnIpEMj/AyECgH+QDJdvpPGnOHdOG80GCEnz69Z
         SJSCYpzok/j2gPPoKJiaTWEfRSXGBmcoxOJhi3801Fmv52Xz1H9stxx0LlNbnsU4s9
         rnCheTKHf1A7BMqFaNb4m0MKDa6kyAmxMKZkh6Gq/N87AdB56nYNdxp6Imq4wPWDdo
         CGOOfMYrwaLOQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 net-next 10/10] arm64: dts: mt7986: move dlm in a dedicated node
Date:   Fri, 31 Mar 2023 15:12:46 +0200
Message-Id: <7787ec209a3c79cd83ed4660ad4189a163dac734.1680268101.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680268101.git.lorenzo@kernel.org>
References: <cover.1680268101.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the dlm memory region is not part of the RAM SoC, move dlm in a
deidicated syscon node.

Acked-by: Matthias Brugger <matthias.bgg@gmail.com>
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

