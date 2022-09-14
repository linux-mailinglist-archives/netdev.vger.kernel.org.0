Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5045B836A
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 10:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiINI4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 04:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiINI4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 04:56:02 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DF1371AB;
        Wed, 14 Sep 2022 01:55:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663145733; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=AoSBTWqQ39jMdawJUMN6V+Cl0FF7bMWFRIG/oEatTajK1kuQv5lExZHNStFm2XkU+acTYJekrJWKSYKraA+UHM4mAItRFHuuGSwzIfUHmd8QL2y4CxcngLL0/fsQk12cDISrDhlZrky3R1AASXZDS8VCXBL4by+XYBWHRUlQIBo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663145733; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=yAKjMq/uUK9WZ8CnisN9As4Pk+9tXhXvBVyYrH2ZjnQ=; 
        b=RG+PoUpkaGGxECzyQrpf4ygLaoiqPxbkQMWDS91pZ36b32x929DxFmwNtL08kUmHtq7FXvbTKLODWN7fJXsUUnTCodomomy8IakRMthiGeUpP7xHIhMD9wdj2QXbDl4qwVafjQpbXNF2b5UEAyrlak+UuqbHBzI/+2bCM/tvGto=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663145733;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=yAKjMq/uUK9WZ8CnisN9As4Pk+9tXhXvBVyYrH2ZjnQ=;
        b=jfKnSJunLzTND9Hq/5TTo8MGc0iZZZwSXwE5/eMNAIoD5pVSpJfIXEnnA05CuGxW
        a44/hv0XiVKmkMl6jFeBs5c1s2LHOsFrnAsDhWv8AvEBnTRA94K5KlDYCY9/ltdBrcT
        eW7fUQqZPxMENUirNlVCXcRRWCl/y6lmCsfK7SSs=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663145731156740.504015969723; Wed, 14 Sep 2022 01:55:31 -0700 (PDT)
From:   =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        erkin.bozoglu@xeront.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH 05/10] mips: dts: ralink: mt7621: fix some dtc warnings
Date:   Wed, 14 Sep 2022 11:54:46 +0300
Message-Id: <20220914085451.11723-6-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914085451.11723-1-arinc.unal@arinc9.com>
References: <20220914085451.11723-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the dtc warnings below.

/cpus/cpu@0: failed to match any schema with compatible: ['mips,mips1004Kc']
/cpus/cpu@1: failed to match any schema with compatible: ['mips,mips1004Kc']
uartlite@c00: $nodename:0: 'uartlite@c00' does not match '^serial(@.*)?$'
	From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/serial/8250.yaml
uartlite@c00: Unevaluated properties are not allowed ('clock-names' was unexpected)
	From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/serial/8250.yaml
sdhci@1e130000: $nodename:0: 'sdhci@1e130000' does not match '^mmc(@.*)?$'
	From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/mmc/mtk-sd.yaml
sdhci@1e130000: Unevaluated properties are not allowed ('bus-width', 'cap-mmc-highspeed', 'cap-sd-highspeed', 'disable-wp', 'max-frequency', 'vmmc-supply', 'vqmmc-supply' were unexpected)
	From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/mmc/mtk-sd.yaml
xhci@1e1c0000: $nodename:0: 'xhci@1e1c0000' does not match '^usb(@.*)?'
	From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.yaml
xhci@1e1c0000: compatible: ['mediatek,mt8173-xhci'] is too short
	From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.yaml
switch0@0: $nodename:0: 'switch0@0' does not match '^(ethernet-)?switch(@.*)?$'
	From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
port@1: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
	From schema: /home/arinc9/.local/lib/python3.10/site-packages/dtschema/schemas/dt-core.yaml
port@2: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
	From schema: /home/arinc9/.local/lib/python3.10/site-packages/dtschema/schemas/dt-core.yaml
port@3: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
	From schema: /home/arinc9/.local/lib/python3.10/site-packages/dtschema/schemas/dt-core.yaml

- Remove "mips,mips1004Kc" compatible string from the cpu nodes. This
doesn't exist anywhere.
- Change "memc: syscon@5000" to "memc: memory-controller@5000".
- Change "uartlite: uartlite@c00" to "serial0: serial@c00" and remove the
aliases node.
- Remove "clock-names" from the serial0 node. The property doesn't exist on
the 8250.yaml schema.
- Change "sdhci: sdhci@1e130000" to "mmc: mmc@1e130000".
- Change "xhci: xhci@1e1c0000" to "usb: usb@1e1c0000".
- Add "mediatek,mtk-xhci" as the second compatible string on the usb node.
- Change "switch0: switch0@0" to "switch0: switch@0"
- Change "off" to "disabled" for disabled nodes.

Remaining warnings are caused by the lack of json-schema documentation.

/cpuintc: failed to match any schema with compatible: ['mti,cpu-interrupt-controller']
/palmbus@1e000000/wdt@100: failed to match any schema with compatible: ['mediatek,mt7621-wdt']
/palmbus@1e000000/i2c@900: failed to match any schema with compatible: ['mediatek,mt7621-i2c']
/palmbus@1e000000/spi@b00: failed to match any schema with compatible: ['ralink,mt7621-spi']
/ethernet@1e100000: failed to match any schema with compatible: ['mediatek,mt7621-eth']

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../boot/dts/ralink/mt7621-gnubee-gb-pc1.dts  |  2 +-
 .../boot/dts/ralink/mt7621-gnubee-gb-pc2.dts  |  2 +-
 arch/mips/boot/dts/ralink/mt7621.dtsi         | 32 +++++++------------
 3 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
index 24eebc5a85b1..6ecb8165efe8 100644
--- a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
+++ b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
@@ -53,7 +53,7 @@ system {
 	};
 };
 
-&sdhci {
+&mmc {
 	status = "okay";
 };
 
diff --git a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
index 34006e667780..2e534ea5bab7 100644
--- a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
+++ b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
@@ -37,7 +37,7 @@ key-reset {
 	};
 };
 
-&sdhci {
+&mmc {
 	status = "okay";
 };
 
diff --git a/arch/mips/boot/dts/ralink/mt7621.dtsi b/arch/mips/boot/dts/ralink/mt7621.dtsi
index ee46ace0bcc1..9302bdc04510 100644
--- a/arch/mips/boot/dts/ralink/mt7621.dtsi
+++ b/arch/mips/boot/dts/ralink/mt7621.dtsi
@@ -15,13 +15,11 @@ cpus {
 
 		cpu@0 {
 			device_type = "cpu";
-			compatible = "mips,mips1004Kc";
 			reg = <0>;
 		};
 
 		cpu@1 {
 			device_type = "cpu";
-			compatible = "mips,mips1004Kc";
 			reg = <1>;
 		};
 	};
@@ -33,11 +31,6 @@ cpuintc: cpuintc {
 		compatible = "mti,cpu-interrupt-controller";
 	};
 
-	aliases {
-		serial0 = &uartlite;
-	};
-
-
 	mmc_fixed_3v3: regulator-3v3 {
 		compatible = "regulator-fixed";
 		regulator-name = "mmc_power";
@@ -110,17 +103,16 @@ i2c: i2c@900 {
 			pinctrl-0 = <&i2c_pins>;
 		};
 
-		memc: syscon@5000 {
+		memc: memory-controller@5000 {
 			compatible = "mediatek,mt7621-memc", "syscon";
 			reg = <0x5000 0x1000>;
 		};
 
-		uartlite: uartlite@c00 {
+		serial0: serial@c00 {
 			compatible = "ns16550a";
 			reg = <0xc00 0x100>;
 
 			clocks = <&sysc MT7621_CLK_UART1>;
-			clock-names = "uart1";
 
 			interrupt-parent = <&gic>;
 			interrupts = <GIC_SHARED 26 IRQ_TYPE_LEVEL_HIGH>;
@@ -236,7 +228,7 @@ pinmux {
 		};
 	};
 
-	sdhci: sdhci@1e130000 {
+	mmc: mmc@1e130000 {
 		status = "disabled";
 
 		compatible = "mediatek,mt7620-mmc";
@@ -262,8 +254,8 @@ sdhci: sdhci@1e130000 {
 		interrupts = <GIC_SHARED 20 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
-	xhci: xhci@1e1c0000 {
-		compatible = "mediatek,mt8173-xhci";
+	usb: usb@1e1c0000 {
+		compatible = "mediatek,mt8173-xhci", "mediatek,mtk-xhci";
 		reg = <0x1e1c0000 0x1000
 		       0x1e1d0700 0x0100>;
 		reg-names = "mac", "ippc";
@@ -338,7 +330,7 @@ fixed-link {
 		gmac1: mac@1 {
 			compatible = "mediatek,eth-mac";
 			reg = <1>;
-			status = "off";
+			status = "disabled";
 			phy-mode = "rgmii-rxid";
 		};
 
@@ -346,7 +338,7 @@ mdio: mdio-bus {
 			#address-cells = <1>;
 			#size-cells = <0>;
 
-			switch0: switch0@0 {
+			switch0: switch@0 {
 				compatible = "mediatek,mt7621";
 				reg = <0>;
 				mediatek,mcm;
@@ -362,31 +354,31 @@ ports {
 					#size-cells = <0>;
 
 					port@0 {
-						status = "off";
+						status = "disabled";
 						reg = <0>;
 						label = "lan0";
 					};
 
 					port@1 {
-						status = "off";
+						status = "disabled";
 						reg = <1>;
 						label = "lan1";
 					};
 
 					port@2 {
-						status = "off";
+						status = "disabled";
 						reg = <2>;
 						label = "lan2";
 					};
 
 					port@3 {
-						status = "off";
+						status = "disabled";
 						reg = <3>;
 						label = "lan3";
 					};
 
 					port@4 {
-						status = "off";
+						status = "disabled";
 						reg = <4>;
 						label = "lan4";
 					};
-- 
2.34.1

