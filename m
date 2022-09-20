Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00515BE2BF
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 12:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiITKMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 06:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiITKMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 06:12:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A915F7FC;
        Tue, 20 Sep 2022 03:11:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 729D5B80CB4;
        Tue, 20 Sep 2022 10:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDD3C433C1;
        Tue, 20 Sep 2022 10:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663668717;
        bh=qvEP025B6TRwZR+DuaT1m+QpQNlslSR24zRXyWzzujk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6aM6pG0XEBakBAJiu6P9SfpQIydBKxSZ7AuSGMjB7XWhv4/hfpPVlGbYW2AsKaii
         Zim8PK/sUcSOc/jS6J8Y9TjxO/6eqIkgbvg8Aa4x/O4DJfohp4XdHziN9Apr2EvYUn
         J8yj433hYUDV2wsJnjaOnjFuQWqFWF3VCC0LDelfzo5F8nNmmyIcbgYQx45f4QxGxs
         x3h+UVaWylaMpCYOeRfv0DC7Tyb6IuCL+c/0CzUsCAci3doERkotF3E9WhfpYFofks
         vrSxCfNi6ndCEA6iPqORfd82lHVVzTbNJkgNwxD9WCfZZHLDkmcLbNf8YIpL1DJMzx
         0qDEKM2ot5VWQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
Subject: [PATCH v3 net-next 01/11] arm64: dts: mediatek: mt7986: add support for Wireless Ethernet Dispatch
Date:   Tue, 20 Sep 2022 12:11:13 +0200
Message-Id: <af0c305b7eb8d7aec4c088cba6889a22724d33f3.1663668203.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1663668203.git.lorenzo@kernel.org>
References: <cover.1663668203.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce wed0 and wed1 nodes in order to enable offloading forwarding
between ethernet and wireless devices on the mt7986 chipset.

Co-developed-by: Bo Jiao <Bo.Jiao@mediatek.com>
Signed-off-by: Bo Jiao <Bo.Jiao@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 24 +++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index e3a407d03551..692102f6248d 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -222,6 +222,28 @@ ethsys: syscon@15000000 {
 			 #reset-cells = <1>;
 		};
 
+		wed_pcie: wed-pcie@10003000 {
+			compatible = "mediatek,mt7986-wed-pcie",
+				     "syscon";
+			reg = <0 0x10003000 0 0x10>;
+		};
+
+		wed0: wed@15010000 {
+			compatible = "mediatek,mt7986-wed",
+				     "syscon";
+			reg = <0 0x15010000 0 0x1000>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
+		wed1: wed@15011000 {
+			compatible = "mediatek,mt7986-wed",
+				     "syscon";
+			reg = <0 0x15011000 0 0x1000>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
 		eth: ethernet@15100000 {
 			compatible = "mediatek,mt7986-eth";
 			reg = <0 0x15100000 0 0x80000>;
@@ -256,6 +278,8 @@ eth: ethernet@15100000 {
 						 <&apmixedsys CLK_APMIXED_SGMPLL>;
 			mediatek,ethsys = <&ethsys>;
 			mediatek,sgmiisys = <&sgmiisys0>, <&sgmiisys1>;
+			mediatek,wed-pcie = <&wed_pcie>;
+			mediatek,wed = <&wed0>, <&wed1>;
 			#reset-cells = <1>;
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.37.3

