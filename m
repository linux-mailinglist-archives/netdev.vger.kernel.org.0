Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEB85B26CA
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 21:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiIHTfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 15:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiIHTfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 15:35:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2EC32EF8;
        Thu,  8 Sep 2022 12:35:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EFA4B82236;
        Thu,  8 Sep 2022 19:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEED8C433C1;
        Thu,  8 Sep 2022 19:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662665704;
        bh=kYB4D/y+Ews0cFobxl2wcNCaZL6yhPF3HS5lGLSaQHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iW8uXyiqaI+2Y0Y3SQeYGhhDQDKgF7HZDTARKg/+khSslZU8DVQ7ZbsFTAw4N5m+l
         Mp2EH4Pt3Awk6hQSjJqp59R3ul/MiJj/8MkCdvAy0tseGUsEX0IgqkS5Idw2Jt/GyY
         ud/hNImRA0JNDnvP7RINaU4U5Jv0le117g7+2sSHLPgRxzuvEdVfgl8lf++4bObm90
         3vYwERIMds4XHAynd52YvrFK30sBfnl2Y6Eox0ral65awmRKYwemQYsI0y86d+FAaJ
         kv8HLuyah2cfgOy+fX/ormiitdhptz/ni8NFUL0NVQBCL4HXWTrpPelITjf6IrCsJo
         8XQo8SRc1UsZA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org
Subject: [PATCH net-next 01/12] arm64: dts: mediatek: mt7986: add support for Wireless Ethernet Dispatch
Date:   Thu,  8 Sep 2022 21:33:35 +0200
Message-Id: <e034b4b71437bce747b128382f1504d5cdc6974b.1662661555.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1662661555.git.lorenzo@kernel.org>
References: <cover.1662661555.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index e3a407d03551..419d056b8369 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -222,6 +222,25 @@ ethsys: syscon@15000000 {
 			 #reset-cells = <1>;
 		};
 
+		wed_pcie: wed_pcie@10003000 {
+			compatible = "mediatek,wed";
+			reg = <0 0x10003000 0 0x10>;
+		};
+
+		wed0: wed@15010000 {
+			compatible = "mediatek,wed", "syscon";
+			reg = <0 0x15010000 0 0x1000>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
+		wed1: wed@15011000 {
+			compatible = "mediatek,wed", "syscon";
+			reg = <0 0x15011000 0 0x1000>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
 		eth: ethernet@15100000 {
 			compatible = "mediatek,mt7986-eth";
 			reg = <0 0x15100000 0 0x80000>;
@@ -256,6 +275,7 @@ eth: ethernet@15100000 {
 						 <&apmixedsys CLK_APMIXED_SGMPLL>;
 			mediatek,ethsys = <&ethsys>;
 			mediatek,sgmiisys = <&sgmiisys0>, <&sgmiisys1>;
+			mediatek,wed = <&wed0>, <&wed1>;
 			#reset-cells = <1>;
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.37.3

