Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2530B4F5427
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389147AbiDFE17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245710AbiDEUNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 16:13:33 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9317FF94FD;
        Tue,  5 Apr 2022 12:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TFVjDpMBzikmsOPbftDhPL/vuxdtl+pABOZRs13meDI=; b=on2i/12safI584EKtjB+2mXflF
        RCUdyDig4wDPF1t5RxfXOvodcEQHARZFV9YAvk4Tf2Jgid1N9zL6YFukmjNl5u2qaSNnlvXx+w4Xs
        YLpsVKUhteCxx3RgspyKDIxRkl32bHTYJFe1gtT0ALVifAXNhChYe0iWa6EPOvfMbFv0=;
Received: from p200300daa70ef200456864e8b8d10029.dip0.t-ipconnect.de ([2003:da:a70e:f200:4568:64e8:b8d1:29] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nbpJQ-00035V-HQ; Tue, 05 Apr 2022 21:58:00 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/14] arm64: dts: mediatek: mt7622: add support for coherent DMA
Date:   Tue,  5 Apr 2022 21:57:44 +0200
Message-Id: <20220405195755.10817-4-nbd@nbd.name>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405195755.10817-1-nbd@nbd.name>
References: <20220405195755.10817-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It improves performance by eliminating the need for a cache flush on rx and tx

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index 6f8cb3ad1e84..a2257ec6d256 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -357,7 +357,7 @@ cci_control1: slave-if@4000 {
 		};
 
 		cci_control2: slave-if@5000 {
-			compatible = "arm,cci-400-ctrl-if";
+			compatible = "arm,cci-400-ctrl-if", "syscon";
 			interface-type = "ace";
 			reg = <0x5000 0x1000>;
 		};
@@ -945,6 +945,8 @@ eth: ethernet@1b100000 {
 		power-domains = <&scpsys MT7622_POWER_DOMAIN_ETHSYS>;
 		mediatek,ethsys = <&ethsys>;
 		mediatek,sgmiisys = <&sgmiisys>;
+		mediatek,cci-control = <&cci_control2>;
+		dma-coherent;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
-- 
2.35.1

