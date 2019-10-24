Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 146F6E2E41
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 12:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405673AbfJXKJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 06:09:50 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:35914 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405628AbfJXKJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 06:09:48 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9OA9ePT122499;
        Thu, 24 Oct 2019 05:09:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1571911780;
        bh=m7ZP1T5BJULFut2poEVt94Xsvalf43ZqUvdky6v0/Fk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=mTDL4kT3O5YDZsPPlf2jj2c9iIB9tkW0h1XLEhkAtpJjsbD0ZlvYBsHROgdaCmmeQ
         byx04c6eOoQu16w0ztYSLAHM9CSuVAdgt0rPl0yAWNbYWqeb8L1kUt/3ZU8BVZfZJL
         thWIecCMhCUr6qH3SBx8c/OzJLXZee8JddUWRhY8=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9OA9e2Q124915
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Oct 2019 05:09:40 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 24
 Oct 2019 05:09:29 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 24 Oct 2019 05:09:29 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9OA9djN107228;
        Thu, 24 Oct 2019 05:09:39 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v5 net-next 05/12] dt-bindings: net: ti: add new cpsw switch driver bindings
Date:   Thu, 24 Oct 2019 13:09:07 +0300
Message-ID: <20191024100914.16840-6-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191024100914.16840-1-grygorii.strashko@ti.com>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings for the new TI CPSW switch driver. Comparing to the legacy
bindings (net/cpsw.txt):
- ports definition follows DSA bindings (net/dsa/dsa.txt) and ports can be
marked as "disabled" if not physically wired.
- all deprecated properties dropped;
- all legacy propertiies dropped which represent constant HW cpapbilities
(cpdma_channels, ale_entries, bd_ram_size, mac_control, slaves,
active_slave)
- TI CPTS DT properties are reused as is, but grouped in "cpts" sub-node
- TI Davinci MDIO DT bindings are reused as is, because Davinci MDIO is
reused.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../bindings/net/ti,cpsw-switch.txt           | 145 ++++++++++++++++++
 1 file changed, 145 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,cpsw-switch.txt

diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.txt b/Documentation/devicetree/bindings/net/ti,cpsw-switch.txt
new file mode 100644
index 000000000000..c0110391be9d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.txt
@@ -0,0 +1,145 @@
+TI SoC Ethernet Switch Controller Device Tree Bindings (new)
+------------------------------------------------------
+
+The 3-port switch gigabit ethernet subsystem provides ethernet packet
+communication and can be configured as an ethernet switch. It provides the
+gigabit media independent interface (GMII),reduced gigabit media
+independent interface (RGMII), reduced media independent interface (RMII),
+the management data input output (MDIO) for physical layer device (PHY)
+management.
+
+Required properties:
+- compatible : be one of the below:
+	  "ti,cpsw-switch" for backward compatible
+	  "ti,am335x-cpsw-switch" for AM335x controllers
+	  "ti,am4372-cpsw-switch" for AM437x controllers
+	  "ti,dra7-cpsw-switch" for DRA7x controllers
+- reg : physical base address and size of the CPSW module IO range
+- ranges : shall contain the CPSW module IO range available for child devices
+- clocks : should contain the CPSW functional clock
+- clock-names : should be "fck"
+	See bindings/clock/clock-bindings.txt
+- interrupts : should contain CPSW RX_THRESH, RX, TX, MISC interrupts
+- interrupt-names : should contain "rx_thresh", "rx", "tx", "misc"
+	See bindings/interrupt-controller/interrupts.txt
+
+Optional properties:
+- syscon : phandle to the system control device node which provides access to
+	efuse IO range with MAC addresses
+
+Required Sub-nodes:
+- ethernet-ports : contains CPSW external ports descriptions
+	Required properties:
+	- #address-cells : Must be 1
+	- #size-cells : Must be 0
+	- reg : CPSW port number. Should be 1 or 2
+	- phys : phandle on phy-gmii-sel PHY (see phy/ti-phy-gmii-sel.txt)
+	- phy-mode : See [1]
+	- phy-handle : See [1]
+
+	Optional properties:
+	- label : Describes the label associated with this port
+	- ti,dual-emac-pvid : Specifies default PORT VID to be used to segregate
+		ports. Default value - CPSW port number.
+	- mac-address : See [1]
+	- local-mac-address : See [1]
+
+- mdio : CPSW MDIO bus block description
+	- bus_freq : MDIO Bus frequency
+	See bindings/net/mdio.txt and davinci-mdio.txt
+
+- cpts : The Common Platform Time Sync (CPTS) module description
+	- clocks : should contain the CPTS reference clock
+	- clock-names : should be "cpts"
+	See bindings/clock/clock-bindings.txt
+
+	Optional properties - all ports:
+	- cpts_clock_mult : Numerator to convert input clock ticks into ns
+	- cpts_clock_shift : Denominator to convert input clock ticks into ns
+			  Mult and shift will be calculated basing on CPTS
+			  rftclk frequency if both cpts_clock_shift and
+			  cpts_clock_mult properties are not provided.
+
+[1] See Documentation/devicetree/bindings/net/ethernet-controller.yaml
+
+Examples:
+
+mac_sw: switch@0 {
+	compatible = "ti,dra7-cpsw-switch","ti,cpsw-switch";
+	reg = <0x0 0x4000>;
+	ranges = <0 0 0x4000>;
+	clocks = <&gmac_main_clk>;
+	clock-names = "fck";
+	#address-cells = <1>;
+	#size-cells = <1>;
+	syscon = <&scm_conf>;
+	status = "disabled";
+
+	interrupts = <GIC_SPI 334 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SPI 335 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SPI 336 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SPI 337 IRQ_TYPE_LEVEL_HIGH>;
+	interrupt-names = "rx_thresh", "rx", "tx", "misc"
+
+	ethernet-ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpsw_port1: port@1 {
+			reg = <1>;
+			label = "port1";
+			/* Filled in by U-Boot */
+			mac-address = [ 00 00 00 00 00 00 ];
+			phys = <&phy_gmii_sel 1>;
+		};
+
+		cpsw_port2: port@2 {
+			reg = <2>;
+			label = "wan";
+			/* Filled in by U-Boot */
+			mac-address = [ 00 00 00 00 00 00 ];
+			phys = <&phy_gmii_sel 2>;
+		};
+	};
+
+	davinci_mdio_sw: mdio@1000 {
+		compatible = "ti,cpsw-mdio","ti,davinci_mdio";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		ti,hwmods = "davinci_mdio";
+		bus_freq = <1000000>;
+		reg = <0x1000 0x100>;
+	};
+
+	cpts {
+		clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 25>;
+		clock-names = "cpts";
+	};
+};
+
+&mac_sw {
+	pinctrl-names = "default", "sleep";
+	status = "okay";
+};
+
+&cpsw_port1 {
+	phy-handle = <&ethphy0_sw>;
+	phy-mode = "rgmii";
+	ti,dual_emac_pvid = <1>;
+};
+
+&cpsw_port2 {
+	phy-handle = <&ethphy1_sw>;
+	phy-mode = "rgmii";
+	ti,dual_emac_pvid = <2>;
+};
+
+&davinci_mdio_sw {
+	ethphy0_sw: ethernet-phy@0 {
+		reg = <0>;
+	};
+
+	ethphy1_sw: ethernet-phy@1 {
+		reg = <1>;
+	};
+};
-- 
2.17.1

