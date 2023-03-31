Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF446D2145
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbjCaNOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbjCaNOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:14:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC091A955;
        Fri, 31 Mar 2023 06:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42640B82F6F;
        Fri, 31 Mar 2023 13:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09AAC4339C;
        Fri, 31 Mar 2023 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680268435;
        bh=4cHdHnyTAhlO3f0cK1byiul6wL08Fc18njzb8Jp2zLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBsKpbWD8FtuvEtQqWYtSO10q+cA3UyyeHUuVAUDglQuekLueAoxi1dmLXQfl77ji
         HX6C3pEoOYXO6Kqu69oB1ZtcwD8DUrxAIhBKAPgiw2+3eK41O0eWHS32/fYJ3xADxB
         anmlaPvXPwwEJoG2/LojRVs1+4aKdwC9zjLOMVOnoGT5z4Hk6RzZ2hHF77ZR8ZVdI3
         iau0np5uRiI1FQ6szkcfJeh3xaP8oUAnffnUveMAjOIt9qqNf0gy8KjIHPT3t8Jj2g
         /D9g40ssIf1YoFjbJv6VGqIl5mr/5UGf+qhDTjeUd6bWw/1TH1CK7KV3kFXX93pMjj
         rtKh/sd3PYi1g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 net-next 07/10] arm64: dts: mt7986: move ilm in a dedicated node
Date:   Fri, 31 Mar 2023 15:12:43 +0200
Message-Id: <b58a1517a81d1d0d591936832a07e5a723934fde.1680268101.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680268101.git.lorenzo@kernel.org>
References: <cover.1680268101.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the ilm memory region is not part of the MT7986 RAM SoC, move ilm
in a deidicated syscon node.

Acked-by: Matthias Brugger <matthias.bgg@gmail.com>
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

