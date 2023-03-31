Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7518E6D213F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbjCaNNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbjCaNNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:13:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34F420C1F;
        Fri, 31 Mar 2023 06:13:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3193762908;
        Fri, 31 Mar 2023 13:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6F9C4339B;
        Fri, 31 Mar 2023 13:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680268423;
        bh=a7RlPuu7MvSxqwEXcrLQIgFMCd4DHwUbSml1aECRMIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zgtz4gCbONlRSOWEdIhp+sSDoMwKXRIiez+xhP/ZBMA1djCH1C22p/RfgOfvsJzjb
         yKzEQ4ISqFEkAnL4NEDjUO/mTNeNY3dRUaADiP8Be5LUfnrYaUKR4km8QWj+efk22o
         DlFBmHmpmXFFDAoDeXp2yZGyRdj02hdsQoLcXHhLaLLtedlfN1IJx2OxKiSnaVny0n
         Ap36N68wqM0kmgNoR9OaA8PE1SoNlGzBj2LVFY37bQIIlDxVZ5UTGefYl40cRoquo+
         D3rSnfQqjGee2DV8VBpvWGOjp1NsJNsxDj1nimgGHcz8/L4ynIDPok9dXeNnG2fomu
         BN9vKZOGGimOg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 net-next 04/10] arm64: dts: mt7986: move cpuboot in a dedicated node
Date:   Fri, 31 Mar 2023 15:12:40 +0200
Message-Id: <56608130babe671e5dd354900480abbe43bec362.1680268101.git.lorenzo@kernel.org>
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

Since the cpuboot memory region is not part of the MT7986 RAM SoC,
move cpuboot in a deidicated syscon node.

Acked-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 51944690e790..668b6cfa6a3d 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -113,12 +113,6 @@ wo_dlm1: wo-dlm@151f8000 {
 			reg = <0 0x151f8000 0 0x2000>;
 			no-map;
 		};
-
-		wo_boot: wo-boot@15194000 {
-			reg = <0 0x15194000 0 0x1000>;
-			no-map;
-		};
-
 	};
 
 	timer {
@@ -461,10 +455,11 @@ wed0: wed@15010000 {
 			interrupt-parent = <&gic>;
 			interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
 			memory-region = <&wo_emi0>, <&wo_ilm0>, <&wo_dlm0>,
-					<&wo_data>, <&wo_boot>;
+					<&wo_data>;
 			memory-region-names = "wo-emi", "wo-ilm", "wo-dlm",
-					      "wo-data", "wo-boot";
+					      "wo-data";
 			mediatek,wo-ccif = <&wo_ccif0>;
+			mediatek,wo-cpuboot = <&wo_cpuboot>;
 		};
 
 		wed1: wed@15011000 {
@@ -474,10 +469,11 @@ wed1: wed@15011000 {
 			interrupt-parent = <&gic>;
 			interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
 			memory-region = <&wo_emi1>, <&wo_ilm1>, <&wo_dlm1>,
-					<&wo_data>, <&wo_boot>;
+					<&wo_data>;
 			memory-region-names = "wo-emi", "wo-ilm", "wo-dlm",
-					      "wo-data", "wo-boot";
+					      "wo-data";
 			mediatek,wo-ccif = <&wo_ccif1>;
+			mediatek,wo-cpuboot = <&wo_cpuboot>;
 		};
 
 		wo_ccif0: syscon@151a5000 {
@@ -494,6 +490,11 @@ wo_ccif1: syscon@151ad000 {
 			interrupts = <GIC_SPI 212 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
+		wo_cpuboot: syscon@15194000 {
+			compatible = "mediatek,mt7986-wo-cpuboot", "syscon";
+			reg = <0 0x15194000 0 0x1000>;
+		};
+
 		eth: ethernet@15100000 {
 			compatible = "mediatek,mt7986-eth";
 			reg = <0 0x15100000 0 0x80000>;
-- 
2.39.2

