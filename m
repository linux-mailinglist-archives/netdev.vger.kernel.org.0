Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594B856144E
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbiF3IIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbiF3IID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:08:03 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D6F41985;
        Thu, 30 Jun 2022 01:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656576477; x=1688112477;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vbBZBVb8B22VRpxKb/0dz1k5O/GgdpM5EBwjjdArU6w=;
  b=q+tqjryGI0UN6eN3MHtK3phxa1+owx9XoUok4gcVmowNRs6DBAu//tP+
   TIhq9EMOJrjqMy8qFeWBjweL1sdR0NEWz/kB5s9iGbmVmHJ9pgVZiOtdt
   ceMxCpCn/i/Gy3PDyngeFStpKPuBVwtcNkox/zXmPp3ipO1pBqBANyvRv
   Z4JvVe1ODHetJ+sqpvT+rEVFxFw4XrZGr/B8wAooHgqQUVnVOdPnzRxNW
   zkuqYij4QNTjCaDyVUmENId/tVrup+gGaJ8Cf4CztbMJKBTgo8CNqhlgc
   bl677Eq3mST424LNk2SLo9yzpWq72+NmmZ3z0UlkY890BSwEB4XPOUAcp
   w==;
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="170217523"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 01:07:57 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 01:07:55 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 30 Jun 2022 01:07:51 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        "Nicolas Ferre" <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Daire McNamara" <daire.mcnamara@microchip.com>
CC:     Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, <linux-clk@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-riscv@lists.infradead.org>
Subject: [PATCH v1 07/14] riscv: dts: microchip: add mpfs specific macb reset support
Date:   Thu, 30 Jun 2022 09:05:26 +0100
Message-ID: <20220630080532.323731-8-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630080532.323731-1-conor.dooley@microchip.com>
References: <20220630080532.323731-1-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macb on PolarFire SoC has reset support which the generic compatible
does not use. Add the newly introduced MPFS specific compatible as the
primary compatible to avail of this support & wire up the reset to the
clock controllers devicetree entry.

Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/boot/dts/microchip/mpfs.dtsi | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/boot/dts/microchip/mpfs.dtsi b/arch/riscv/boot/dts/microchip/mpfs.dtsi
index 8c3259134194..5a33cbf9467a 100644
--- a/arch/riscv/boot/dts/microchip/mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/mpfs.dtsi
@@ -197,6 +197,7 @@ clkcfg: clkcfg@20002000 {
 			reg = <0x0 0x20002000 0x0 0x1000>, <0x0 0x3E001000 0x0 0x1000>;
 			clocks = <&refclk>;
 			#clock-cells = <1>;
+			#reset-cells = <1>;
 		};
 
 		mmuart0: serial@20000000 {
@@ -331,7 +332,7 @@ i2c1: i2c@2010b000 {
 		};
 
 		mac0: ethernet@20110000 {
-			compatible = "cdns,macb";
+			compatible = "microchip,mpfs-macb", "cdns,macb";
 			reg = <0x0 0x20110000 0x0 0x2000>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -340,11 +341,12 @@ mac0: ethernet@20110000 {
 			local-mac-address = [00 00 00 00 00 00];
 			clocks = <&clkcfg CLK_MAC0>, <&clkcfg CLK_AHB>;
 			clock-names = "pclk", "hclk";
+			resets = <&clkcfg CLK_MAC0>;
 			status = "disabled";
 		};
 
 		mac1: ethernet@20112000 {
-			compatible = "cdns,macb";
+			compatible = "microchip,mpfs-macb", "cdns,macb";
 			reg = <0x0 0x20112000 0x0 0x2000>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -353,6 +355,7 @@ mac1: ethernet@20112000 {
 			local-mac-address = [00 00 00 00 00 00];
 			clocks = <&clkcfg CLK_MAC1>, <&clkcfg CLK_AHB>;
 			clock-names = "pclk", "hclk";
+			resets = <&clkcfg CLK_MAC1>;
 			status = "disabled";
 		};
 
-- 
2.36.1

