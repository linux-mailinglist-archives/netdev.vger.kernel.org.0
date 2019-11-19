Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAACC102F24
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfKSWTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:19:47 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:56434 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbfKSWTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:19:45 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJcfQ059741;
        Tue, 19 Nov 2019 16:19:38 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574201978;
        bh=Gktt+peeGEEHXNKyTxsifrJXrOOpJRpEwdId664Wn0k=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=uN96tcZpgzOxHffj0vGLh5keE/ldbNxWGOf0kanTpVvRqVih68kupyv5sPJNGQKkA
         743Xoo23pxG68vBQ+HnaVtYyFCy+v2TPUaYOB6F9F3MaGHVdHMlb5yU1+yNBpHFW2i
         oijBfFP/q8/w0mWSlcFMaGybvPykLUN/Xh7n/qo4=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJcbR034334;
        Tue, 19 Nov 2019 16:19:38 -0600
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 19
 Nov 2019 16:19:37 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 19 Nov 2019 16:19:37 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJacp084841;
        Tue, 19 Nov 2019 16:19:37 -0600
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
Subject: [PATCH v7 net-next 06/13] dt-bindings: net: ti: add new cpsw switch driver bindings
Date:   Wed, 20 Nov 2019 00:19:18 +0200
Message-ID: <20191119221925.28426-7-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191119221925.28426-1-grygorii.strashko@ti.com>
References: <20191119221925.28426-1-grygorii.strashko@ti.com>
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
 .../bindings/net/ti,cpsw-switch.yaml          | 240 ++++++++++++++++++
 1 file changed, 240 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml

diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
new file mode 100644
index 000000000000..81ae8cafabc1
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
@@ -0,0 +1,240 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ti,cpsw-switch.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: TI SoC Ethernet Switch Controller (CPSW) Device Tree Bindings
+
+maintainers:
+  - Grygorii Strashko <grygorii.strashko@ti.com>
+  - Sekhar Nori <nsekhar@ti.com>
+
+description:
+  The 3-port switch gigabit ethernet subsystem provides ethernet packet
+  communication and can be configured as an ethernet switch. It provides the
+  gigabit media independent interface (GMII),reduced gigabit media
+  independent interface (RGMII), reduced media independent interface (RMII),
+  the management data input output (MDIO) for physical layer device (PHY)
+  management.
+
+properties:
+  compatible:
+    oneOf:
+      - const: ti,cpsw-switch
+      - items:
+         - const: ti,am335x-cpsw-switch
+         - const: ti,cpsw-switch
+      - items:
+        - const: ti,am4372-cpsw-switch
+        - const: ti,cpsw-switch
+      - items:
+        - const: ti,dra7-cpsw-switch
+        - const: ti,cpsw-switch
+
+  reg:
+    maxItems: 1
+    description:
+       The physical base address and size of full the CPSW module IO range
+
+  ranges: true
+
+  clocks:
+    maxItems: 1
+    description: CPSW functional clock
+
+  clock-names:
+    maxItems: 1
+    items:
+      - const: fck
+
+  interrupts:
+    items:
+      - description: RX_THRESH interrupt
+      - description: RX interrupt
+      - description: TX interrupt
+      - description: MISC interrupt
+
+  interrupt-names:
+    items:
+      - const: "rx_thresh"
+      - const: "rx"
+      - const: "tx"
+      - const: "misc"
+
+  pinctrl-names: true
+
+  syscon:
+    $ref: /schemas/types.yaml#definitions/phandle
+    description:
+      Phandle to the system control device node which provides access to
+      efuse IO range with MAC addresses
+
+
+  ethernet-ports:
+    type: object
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      "^port@[0-9]+$":
+          type: object
+          minItems: 1
+          maxItems: 2
+          description: CPSW external ports
+
+          allOf:
+            - $ref: ethernet-controller.yaml#
+
+          properties:
+            reg:
+              maxItems: 1
+              enum: [1, 2]
+              description: CPSW port number
+
+            phys:
+              $ref: /schemas/types.yaml#definitions/phandle-array
+              maxItems: 1
+              description:  phandle on phy-gmii-sel PHY
+
+            label:
+              $ref: /schemas/types.yaml#/definitions/string-array
+              maxItems: 1
+              description: label associated with this port
+
+            ti,dual-emac-pvid:
+              $ref: /schemas/types.yaml#/definitions/uint32
+              maxItems: 1
+              minimum: 1
+              maximum: 1024
+              description:
+                Specifies default PORT VID to be used to segregate
+                ports. Default value - CPSW port number.
+
+          required:
+            - reg
+            - phys
+
+  mdio:
+    type: object
+    allOf:
+      - $ref: "ti,davinci-mdio.yaml#"
+    description:
+      CPSW MDIO bus.
+
+  cpts:
+    type: object
+    description:
+      The Common Platform Time Sync (CPTS) module
+
+    properties:
+      clocks:
+        maxItems: 1
+        description: CPTS reference clock
+
+      clock-names:
+        maxItems: 1
+        items:
+          - const: cpts
+
+      cpts_clock_mult:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description:
+          Numerator to convert input clock ticks into ns
+
+      cpts_clock_shift:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description:
+          Denominator to convert input clock ticks into ns.
+          Mult and shift will be calculated basing on CPTS rftclk frequency if
+          both cpts_clock_shift and cpts_clock_mult properties are not provided.
+
+    required:
+      - clocks
+      - clock-names
+
+required:
+  - compatible
+  - reg
+  - ranges
+  - clocks
+  - clock-names
+  - interrupts
+  - interrupt-names
+  - '#address-cells'
+  - '#size-cells'
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/dra7.h>
+
+    mac_sw: switch@0 {
+        compatible = "ti,dra7-cpsw-switch","ti,cpsw-switch";
+        reg = <0x0 0x4000>;
+        ranges = <0 0 0x4000>;
+        clocks = <&gmac_main_clk>;
+        clock-names = "fck";
+        #address-cells = <1>;
+        #size-cells = <1>;
+        syscon = <&scm_conf>;
+        inctrl-names = "default", "sleep";
+
+        interrupts = <GIC_SPI 334 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 335 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 336 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 337 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "rx_thresh", "rx", "tx", "misc";
+
+        ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                cpsw_port1: port@1 {
+                        reg = <1>;
+                        label = "port1";
+                        mac-address = [ 00 00 00 00 00 00 ];
+                        phys = <&phy_gmii_sel 1>;
+                        phy-handle = <&ethphy0_sw>;
+                        phy-mode = "rgmii";
+                        ti,dual_emac_pvid = <1>;
+                };
+
+                cpsw_port2: port@2 {
+                        reg = <2>;
+                        label = "wan";
+                        mac-address = [ 00 00 00 00 00 00 ];
+                        phys = <&phy_gmii_sel 2>;
+                        phy-handle = <&ethphy1_sw>;
+                        phy-mode = "rgmii";
+                        ti,dual_emac_pvid = <2>;
+                };
+        };
+
+        davinci_mdio_sw: mdio@1000 {
+                compatible = "ti,cpsw-mdio","ti,davinci_mdio";
+                reg = <0x1000 0x100>;
+                clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 0>;
+                clock-names = "fck";
+                #address-cells = <1>;
+                #size-cells = <0>;
+                bus_freq = <1000000>;
+
+                ethphy0_sw: ethernet-phy@0 {
+                        reg = <0>;
+                };
+
+                ethphy1_sw: ethernet-phy@1 {
+                        reg = <1>;
+                };
+        };
+
+        cpts {
+                clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 25>;
+                clock-names = "cpts";
+        };
+    };
-- 
2.17.1

