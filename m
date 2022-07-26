Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB9A58131E
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 14:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbiGZMZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 08:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiGZMZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 08:25:45 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44A2186C0;
        Tue, 26 Jul 2022 05:25:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1658838286; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=SI8erzqmWifB8RmSt98sZ8JJg31CV+c0xbc9NwehMHBswmwgfI8muFyZubfsLw4gGtIfFlkux/ErP3oMTf2Arxa5dbV9ruE7IAgvbMg8KvBjyC4E5SBoTYAvz47VaWBtHh3faQ3M13ibj4DDbthh/+MuljmMcv6RWpaQA2V6/Nw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1658838286; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=4vD8StGxrYuVW8dpV+apjQ5LVL8U8Xz4DQgwitZkxTo=; 
        b=mphxZP9Pc85BFFqhNDrPcSYJatlSEfP61LHxgAUO+8wuCjBECg4KhDMiIhjwCTY8zXXZ4Vjq7/HJTss8CngjZd8AP3Z5u+qVW8CSOEzwwCU1cVnp0Fl/xWvjHLYPdl6B6lYE0sablTBjCryrtIllsUksZodeTCZAvKzpqRDT0mM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1658838286;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=4vD8StGxrYuVW8dpV+apjQ5LVL8U8Xz4DQgwitZkxTo=;
        b=Wy7FGCIGkUVsb41y6Ch3LrpBKjXhN3JkzdE2v4MUkFHINjp/tg9zr92wOtRiYXYV
        YBPiFC/NKVgJrK1boniONuJmfpYUzLk65zh+L9Ui1+9IuwpueDVZVhwxMTudywgQm9G
        3Je7RDBi9OKDn6jg5WmZoCz+Nh0IbuomTIblipMA=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 16588382832761012.2008693998877; Tue, 26 Jul 2022 05:24:43 -0700 (PDT)
From:   =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [RFC PATCH net-next] dt-bindings: net: dsa: mediatek,mt7530: completely rework binding
Date:   Tue, 26 Jul 2022 15:24:06 +0300
Message-Id: <20220726122406.31043-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Completely rework the binding for MediaTek MT7530 and MT7531 switches.

- Update title to include MT7531 switch.
- Add me as a maintainer. List maintainers in alphabetical order by first
name.
- Update binding description. Describe the switches, which SoCs they are
on, or if they are standalone.
- Add description to compatible strings.
- Fix MCM description. mediatek,mcm is not used on MT7623NI.
- Remove phy-mode = “rgmii-txid” from description. Same code path is
followed for delayed rgmii and rgmii phy-mode on mtk_eth_soc.c.
- Define acceptable phy-mode values for certain compatible strings and dsa
port regs.
- Remove requiring reg since the referred dsa-port.yaml already does that.
- Remove quotes from $ref: "dsa.yaml#".
- Require mediatek,mcm for MT7621 as the compatible string is only used for
MT7530 which is a part of the multi-chip module.
- Add description for reset-gpios.
- Only allow port 6 to be the cpu port for MT7530 as port 5 is not
supported yet.

Examples:
- Add examples which include all different configurations.
- Make example comments YAML comment instead of DT binding comment.
- Define examples from platform to make the bindings clearer.
- Add interrupt controller to the examples. Include header file for
interrupt.
- Change reset line for MT7621 examples.
- Pretty formatting for the examples.
- Change switch reg to 0.
- Change port labels to fit the example, change some lan labels to wan.
Make port 4, wan.
- Change ethernet-ports to ports.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
I’m new to json schema so I experimented a lot with this binding. Open to
suggestions! I've checked the bindings with "make dt_binding_check
DT_SCHEMA_FILES=mediatek,mt7530.yaml".

If anyone knows the GIC bit for interrupt for multi-chip module MT7530 in
MT7623AI SoC, let me know. I’ll add it to the examples.

PHY0/4 muxing on MT7623AI may be possible. Has anyone got a Unielec U7623
or another MT7623AI board to test?

We require the interrupt-parent right? interrupts property shouldn't make
sense without the parent defined, such as GIC or GPIO. I have it missing on
a devicetree, I want to add it.

trgmii speed is 1200 Mbps. Are we supposed to use 2500 speed for fixed-link
trgmii?

To Frank:
Let me know if MII bindings for port 5 and 6 on MT7531 are okay.

Does your recent patch for MT7531 make it possible to set any port for CPU,
including user ports? For now, I put a rule to restrict CPU ports to 5 and
6, as described on the description of dsa port reg property.

I suppose your patch does not bring support for using MT7530's port 5 as
CPU port. We could try this on a BPI-R2. Device schematics show that
MT7530's GMII pins are wired to GMAC1 of MT7623NI to work as RGMII.

Arınç
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 959 +++++++++++++-----
 1 file changed, 717 insertions(+), 242 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 17ab6c69ecc7..d448090981a6 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -4,60 +4,63 @@
 $id: http://devicetree.org/schemas/net/dsa/mediatek,mt7530.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Mediatek MT7530 Ethernet switch
+title: Mediatek MT7530 and MT7531 Ethernet Switches
 
 maintainers:
-  - Sean Wang <sean.wang@mediatek.com>
+  - Arınç ÜNAL <arinc.unal@arinc9.com>
   - Landen Chao <Landen.Chao@mediatek.com>
   - DENG Qingfang <dqfext@gmail.com>
+  - Sean Wang <sean.wang@mediatek.com>
 
 description: |
-  Port 5 of mt7530 and mt7621 switch is muxed between:
-  1. GMAC5: GMAC5 can interface with another external MAC or PHY.
-  2. PHY of port 0 or port 4: PHY interfaces with an external MAC like 2nd GMAC
-     of the SOC. Used in many setups where port 0/4 becomes the WAN port.
-     Note: On a MT7621 SOC with integrated switch: 2nd GMAC can only connected to
-       GMAC5 when the gpios for RGMII2 (GPIO 22-33) are not used and not
-       connected to external component!
-
-  Port 5 modes/configurations:
-  1. Port 5 is disabled and isolated: An external phy can interface to the 2nd
-     GMAC of the SOC.
-     In the case of a build-in MT7530 switch, port 5 shares the RGMII bus with 2nd
-     GMAC and an optional external phy. Mind the GPIO/pinctl settings of the SOC!
-  2. Port 5 is muxed to PHY of port 0/4: Port 0/4 interfaces with 2nd GMAC.
-     It is a simple MAC to PHY interface, port 5 needs to be setup for xMII mode
-     and RGMII delay.
-  3. Port 5 is muxed to GMAC5 and can interface to an external phy.
-     Port 5 becomes an extra switch port.
-     Only works on platform where external phy TX<->RX lines are swapped.
-     Like in the Ubiquiti ER-X-SFP.
-  4. Port 5 is muxed to GMAC5 and interfaces with the 2nd GAMC as 2nd CPU port.
-     Currently a 2nd CPU port is not supported by DSA code.
-
-  Depending on how the external PHY is wired:
-  1. normal: The PHY can only connect to 2nd GMAC but not to the switch
-  2. swapped: RGMII TX, RX are swapped; external phy interface with the switch as
-     a ethernet port. But can't interface to the 2nd GMAC.
-
-    Based on the DT the port 5 mode is configured.
-
-  Driver tries to lookup the phy-handle of the 2nd GMAC of the master device.
-  When phy-handle matches PHY of port 0 or 4 then port 5 set-up as mode 2.
-  phy-mode must be set, see also example 2 below!
-  * mt7621: phy-mode = "rgmii-txid";
-  * mt7623: phy-mode = "rgmii";
-
-  CPU-Ports need a phy-mode property:
-    Allowed values on mt7530 and mt7621:
-      - "rgmii"
-      - "trgmii"
-    On mt7531:
-      - "1000base-x"
-      - "2500base-x"
-      - "rgmii"
-      - "sgmii"
+  There are two versions of MT7530. MT7621AT, MT7621DAT, MT7621ST and MT7623AI
+  SoCs include MT7530 which is a part of the multi-chip module.
+  The other version of MT7530 comes as a standalone chip.
+  There is only one version of MT7531 which comes as a standalone chip.
+
+  Port 5 on MT7530 has got various ways of configuration.
+
+  For standalone MT7530:
+
+    - Port 5 can be used as a DSA master.
+      This is currently not supported on the driver.
+
+    - PHY 0 or 4 of the switch can be muxed to connect to the gmac of the SoC
+      which port 5 is wired to. Usually used for connecting the wan port
+      directly to the CPU to achieve 2 Gbps routing in total.
+
+      The driver requires the gmac of the SoC to have "mediatek,eth-mac" as the
+      compatible string and the reg must be 1. So, for now, only gmac1 of an
+      MediaTek SoC can benefit this. Banana Pi BPI-R2 for example.
+      Check out example 5 for a similar configuration.
+
+    - Port 5 can be wired to an external phy. Port 5 becomes a DSA slave.
+      Check out example 7 for a similar configuration.
+
+  For multi-chip module MT7530:
+
+    - Port 5 can be used as a DSA master.
+      This is currently not supported on the driver.
+
+    - PHY 0 or 4 of the switch can be muxed to connect to gmac1 of the SoC.
+      Usually used for connecting the wan port directly to the CPU to achieve 2
+      Gbps routing in total.
+
+      For the MT7621 SoCs, rgmii2 group must be claimed with rgmii2 function.
+      Check out example 5.
+
+    - In case of an external phy wired to gmac1 of the SoC, port 5 must not be
+      enabled.
+
+      For the MT7621 SoCs, rgmii2 group must be claimed with rgmii2 function.
+      Check out example 6.
 
+    - Port 5 can be muxed to an external phy. Port 5 becomes a DSA slave.
+      The external phy must be wired TX to TX to gmac1 of the SoC for this to
+      work. Ubiquiti EdgeRouter X SFP for example.
+
+      For the MT7621 SoCs, rgmii2 group must be claimed with gpio function.
+      Check out example 7.
 
 properties:
   compatible:
@@ -66,6 +69,14 @@ properties:
       - mediatek,mt7531
       - mediatek,mt7621
 
+    description: |
+      mediatek,mt7530:
+        For standalone MT7530 and multi-chip module MT7530 in MT7623AI SoC.
+      mediatek,mt7531:
+        For standalone MT7531.
+      mediatek,mt7621:
+        For multi-chip module MT7530 in MT7621AT, MT7621DAT and MT7621ST SoCs.
+
   reg:
     maxItems: 1
 
@@ -79,7 +90,7 @@ properties:
   gpio-controller:
     type: boolean
     description:
-      if defined, MT7530's LED controller will run on GPIO mode.
+      If defined, MT7530's LED controller will run on GPIO mode.
 
   "#interrupt-cells":
     const: 1
@@ -98,11 +109,14 @@ properties:
   mediatek,mcm:
     type: boolean
     description:
-      if defined, indicates that either MT7530 is the part on multi-chip
-      module belong to MT7623A has or the remotely standalone chip as the
-      function MT7623N reference board provided for.
+      Used for MT7621AT, MT7621DAT, MT7621ST and MT7623AI SoCs which the MT7530
+      switch is a part of the multi-chip module.
 
   reset-gpios:
+    description:
+      GPIO to reset the switch. Use this if mediatek,mcm is not used.
+      This is optional since some boards share the reset line with other
+      components which makes it impossible to probe the switch.
     maxItems: 1
 
   reset-names:
@@ -114,41 +128,12 @@ properties:
       the ethsys.
     maxItems: 1
 
-patternProperties:
-  "^(ethernet-)?ports$":
-    type: object
-
-    patternProperties:
-      "^(ethernet-)?port@[0-9]+$":
-        type: object
-        description: Ethernet switch ports
-
-        unevaluatedProperties: false
-
-        properties:
-          reg:
-            description:
-              Port address described must be 5 or 6 for CPU port and from 0
-              to 5 for user ports.
-
-        allOf:
-          - $ref: dsa-port.yaml#
-          - if:
-              properties:
-                label:
-                  items:
-                    - const: cpu
-            then:
-              required:
-                - reg
-                - phy-mode
-
 required:
   - compatible
   - reg
 
 allOf:
-  - $ref: "dsa.yaml#"
+  - $ref: dsa.yaml#
   - if:
       required:
         - mediatek,mcm
@@ -166,151 +151,531 @@ allOf:
           items:
             - const: mediatek,mt7530
     then:
+      patternProperties:
+        "^(ethernet-)?ports$":
+          type: object
+
+          patternProperties:
+            "^(ethernet-)?port@[0-9]+$":
+              type: object
+              description: Ethernet switch ports
+
+              unevaluatedProperties: false
+
+              properties:
+                reg:
+                  description:
+                    Port address described must be 6 for CPU port and from 0 to
+                    5 for user ports.
+
+              allOf:
+                - $ref: dsa-port.yaml#
+                - if:
+                    properties:
+                      label:
+                        items:
+                          - const: cpu
+                  then:
+                    properties:
+                      phy-mode:
+                        enum:
+                          - rgmii
+                          - trgmii
+
+                      reg:
+                        enum:
+                          - 6
+
+                    required:
+                      - phy-mode
+
       required:
         - core-supply
         - io-supply
 
+  - if:
+      properties:
+        compatible:
+          items:
+            - const: mediatek,mt7531
+    then:
+      patternProperties:
+        "^(ethernet-)?ports$":
+          type: object
+
+          patternProperties:
+            "^(ethernet-)?port@[0-9]+$":
+              type: object
+              description: Ethernet switch ports
+
+              unevaluatedProperties: false
+
+              properties:
+                reg:
+                  description:
+                    Port address described must be 5 or 6 for CPU port and from
+                    0 to 5 for user ports.
+
+              allOf:
+                - $ref: dsa-port.yaml#
+                - if:
+                    properties:
+                      label:
+                        items:
+                          - const: cpu
+                  then:
+                    allOf:
+                      - if:
+                          properties:
+                            reg:
+                              const: 5
+                        then:
+                          properties:
+                            phy-mode:
+                              enum:
+                                - 1000base-x
+                                - 2500base-x
+                                - rgmii
+                                - sgmii
+
+                      - if:
+                          properties:
+                            reg:
+                              const: 6
+                        then:
+                          properties:
+                            phy-mode:
+                              enum:
+                                - 1000base-x
+                                - 2500base-x
+                                - sgmii
+
+                    properties:
+                      reg:
+                        enum:
+                          - 5
+                          - 6
+
+                    required:
+                      - phy-mode
+
+  - if:
+      properties:
+        compatible:
+          items:
+            - const: mediatek,mt7621
+    then:
+      patternProperties:
+        "^(ethernet-)?ports$":
+          type: object
+
+          patternProperties:
+            "^(ethernet-)?port@[0-9]+$":
+              type: object
+              description: Ethernet switch ports
+
+              unevaluatedProperties: false
+
+              properties:
+                reg:
+                  description:
+                    Port address described must be 6 for CPU port and from 0 to
+                    5 for user ports.
+
+              allOf:
+                - $ref: dsa-port.yaml#
+                - if:
+                    properties:
+                      label:
+                        items:
+                          - const: cpu
+                  then:
+                    properties:
+                      phy-mode:
+                        enum:
+                          - rgmii
+                          - trgmii
+
+                      reg:
+                        enum:
+                          - 6
+
+                    required:
+                      - phy-mode
+
+      required:
+        - mediatek,mcm
+
 unevaluatedProperties: false
 
 examples:
+  # Example 1: Standalone MT7530
   - |
     #include <dt-bindings/gpio/gpio.h>
-    mdio {
-        #address-cells = <1>;
-        #size-cells = <0>;
-        switch@0 {
-            compatible = "mediatek,mt7530";
-            reg = <0>;
-
-            core-supply = <&mt6323_vpa_reg>;
-            io-supply = <&mt6323_vemc3v3_reg>;
-            reset-gpios = <&pio 33 GPIO_ACTIVE_HIGH>;
-
-            ethernet-ports {
+
+    platform {
+        ethernet {
+            mdio {
                 #address-cells = <1>;
                 #size-cells = <0>;
-                port@0 {
+
+                switch@0 {
+                    compatible = "mediatek,mt7530";
                     reg = <0>;
-                    label = "lan0";
-                };
 
-                port@1 {
-                    reg = <1>;
-                    label = "lan1";
-                };
+                    reset-gpios = <&pio 33 0>;
 
-                port@2 {
-                    reg = <2>;
-                    label = "lan2";
-                };
+                    core-supply = <&mt6323_vpa_reg>;
+                    io-supply = <&mt6323_vemc3v3_reg>;
+
+                    ports {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        port@0 {
+                            reg = <0>;
+                            label = "lan1";
+                        };
+
+                        port@1 {
+                            reg = <1>;
+                            label = "lan2";
+                        };
+
+                        port@2 {
+                            reg = <2>;
+                            label = "lan3";
+                        };
+
+                        port@3 {
+                            reg = <3>;
+                            label = "lan4";
+                        };
 
-                port@3 {
-                    reg = <3>;
-                    label = "lan3";
+                        port@4 {
+                            reg = <4>;
+                            label = "wan";
+                        };
+
+                        port@6 {
+                            reg = <6>;
+                            label = "cpu";
+                            ethernet = <&gmac0>;
+                            phy-mode = "rgmii";
+
+                            fixed-link {
+                                speed = <1000>;
+                                full-duplex;
+                                pause;
+                            };
+                        };
+                    };
                 };
+            };
+        };
+    };
 
-                port@4 {
-                    reg = <4>;
-                    label = "wan";
+  # Example 2: MT7530 in MT7623AI SoC
+  - |
+    #include <dt-bindings/reset/mt2701-resets.h>
+
+    platform {
+        ethernet {
+            mdio {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                switch@0 {
+                    compatible = "mediatek,mt7530";
+                    reg = <0>;
+
+                    mediatek,mcm;
+                    resets = <&ethsys MT2701_ETHSYS_MCM_RST>;
+                    reset-names = "mcm";
+
+                    core-supply = <&mt6323_vpa_reg>;
+                    io-supply = <&mt6323_vemc3v3_reg>;
+
+                    ports {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        port@0 {
+                            reg = <0>;
+                            label = "lan1";
+                        };
+
+                        port@1 {
+                            reg = <1>;
+                            label = "lan2";
+                        };
+
+                        port@2 {
+                            reg = <2>;
+                            label = "lan3";
+                        };
+
+                        port@3 {
+                            reg = <3>;
+                            label = "lan4";
+                        };
+
+                        port@4 {
+                            reg = <4>;
+                            label = "wan";
+                        };
+
+                        port@6 {
+                            reg = <6>;
+                            label = "cpu";
+                            ethernet = <&gmac0>;
+                            phy-mode = "trgmii";
+
+                            fixed-link {
+                                speed = <1000>;
+                                full-duplex;
+                                pause;
+                            };
+                        };
+                    };
                 };
+            };
+        };
+    };
+
+  # Example 3: Standalone MT7531
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    platform {
+        ethernet {
+            mdio {
+                #address-cells = <1>;
+                #size-cells = <0>;
 
-                port@6 {
-                    reg = <6>;
-                    label = "cpu";
-                    ethernet = <&gmac0>;
-                    phy-mode = "trgmii";
-                    fixed-link {
-                        speed = <1000>;
-                        full-duplex;
+                switch@0 {
+                    compatible = "mediatek,mt7531";
+                    reg = <0>;
+
+                    reset-gpios = <&pio 54 0>;
+
+                    interrupt-controller;
+                    #interrupt-cells = <1>;
+                    interrupt-parent = <&pio>;
+                    interrupts = <53 IRQ_TYPE_LEVEL_HIGH>;
+
+                    ports {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        port@0 {
+                            reg = <0>;
+                            label = "lan1";
+                        };
+
+                        port@1 {
+                            reg = <1>;
+                            label = "lan2";
+                        };
+
+                        port@2 {
+                            reg = <2>;
+                            label = "lan3";
+                        };
+
+                        port@3 {
+                            reg = <3>;
+                            label = "lan4";
+                        };
+
+                        port@4 {
+                            reg = <4>;
+                            label = "wan";
+                        };
+
+                        port@6 {
+                            reg = <6>;
+                            label = "cpu";
+                            ethernet = <&gmac0>;
+                            phy-mode = "2500base-x";
+
+                            fixed-link {
+                                speed = <2500>;
+                                full-duplex;
+                                pause;
+                            };
+                        };
                     };
                 };
             };
         };
     };
 
+  # Example 4: MT7530 in MT7621AT, MT7621DAT and MT7621ST SoCs
   - |
-    //Example 2: MT7621: Port 4 is WAN port: 2nd GMAC -> Port 5 -> PHY port 4.
-
-    ethernet {
-        #address-cells = <1>;
-        #size-cells = <0>;
-        gmac0: mac@0 {
-            compatible = "mediatek,eth-mac";
-            reg = <0>;
-            phy-mode = "rgmii";
-
-            fixed-link {
-                speed = <1000>;
-                full-duplex;
-                pause;
+    #include <dt-bindings/interrupt-controller/mips-gic.h>
+    #include <dt-bindings/reset/mt7621-reset.h>
+
+    platform {
+        ethernet {
+            mdio {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                switch@0 {
+                    compatible = "mediatek,mt7621";
+                    reg = <0>;
+
+                    mediatek,mcm;
+                    resets = <&sysc MT7621_RST_MCM>;
+                    reset-names = "mcm";
+
+                    interrupt-controller;
+                    #interrupt-cells = <1>;
+                    interrupt-parent = <&gic>;
+                    interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
+
+                    ports {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        port@0 {
+                            reg = <0>;
+                            label = "lan1";
+                        };
+
+                        port@1 {
+                            reg = <1>;
+                            label = "lan2";
+                        };
+
+                        port@2 {
+                            reg = <2>;
+                            label = "lan3";
+                        };
+
+                        port@3 {
+                            reg = <3>;
+                            label = "lan4";
+                        };
+
+                        port@4 {
+                            reg = <4>;
+                            label = "wan";
+                        };
+
+                        port@6 {
+                            reg = <6>;
+                            label = "cpu";
+                            ethernet = <&gmac0>;
+                            phy-mode = "trgmii";
+
+                            fixed-link {
+                                speed = <1000>;
+                                full-duplex;
+                                pause;
+                            };
+                        };
+                    };
+                };
             };
         };
+    };
 
-        gmac1: mac@1 {
-            compatible = "mediatek,eth-mac";
-            reg = <1>;
-            phy-mode = "rgmii-txid";
-            phy-handle = <&phy4>;
+  # Example 5: MT7621: mux MT7530's phy4 to SoC's gmac1
+  - |
+    #include <dt-bindings/interrupt-controller/mips-gic.h>
+    #include <dt-bindings/reset/mt7621-reset.h>
+
+    platform {
+        pinctrl {
+            example5_rgmii2_pins: rgmii2-pins {
+                pinmux {
+                    groups = "rgmii2";
+                    function = "rgmii2";
+                };
+            };
         };
 
-        mdio: mdio-bus {
+        ethernet {
             #address-cells = <1>;
             #size-cells = <0>;
 
-            /* Internal phy */
-            phy4: ethernet-phy@4 {
-                reg = <4>;
+            pinctrl-names = "default";
+            pinctrl-0 = <&example5_rgmii2_pins>;
+
+            mac@1 {
+                compatible = "mediatek,eth-mac";
+                reg = <1>;
+
+                phy-handle = <&example5_ethphy4>;
             };
 
-            mt7530: switch@1f {
-                compatible = "mediatek,mt7621";
-                reg = <0x1f>;
-                mediatek,mcm;
+            mdio {
+                #address-cells = <1>;
+                #size-cells = <0>;
 
-                resets = <&rstctrl 2>;
-                reset-names = "mcm";
+                /* MT7530's phy4 */
+                example5_ethphy4: ethernet-phy@4 {
+                    reg = <4>;
+                };
 
-                ethernet-ports {
-                    #address-cells = <1>;
-                    #size-cells = <0>;
+                switch@0 {
+                    compatible = "mediatek,mt7621";
+                    reg = <0>;
 
-                    port@0 {
-                        reg = <0>;
-                        label = "lan0";
-                    };
+                    mediatek,mcm;
+                    resets = <&sysc MT7621_RST_MCM>;
+                    reset-names = "mcm";
 
-                    port@1 {
-                        reg = <1>;
-                        label = "lan1";
-                    };
+                    interrupt-controller;
+                    #interrupt-cells = <1>;
+                    interrupt-parent = <&gic>;
+                    interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
 
-                    port@2 {
-                        reg = <2>;
-                        label = "lan2";
-                    };
+                    ports {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
 
-                    port@3 {
-                        reg = <3>;
-                        label = "lan3";
-                    };
+                        port@0 {
+                            reg = <0>;
+                            label = "lan1";
+                        };
 
-                    /* Commented out. Port 4 is handled by 2nd GMAC.
-                    port@4 {
-                        reg = <4>;
-                        label = "lan4";
-                    };
-                    */
+                        port@1 {
+                            reg = <1>;
+                            label = "lan2";
+                        };
+
+                        port@2 {
+                            reg = <2>;
+                            label = "lan3";
+                        };
 
-                    port@6 {
-                        reg = <6>;
-                        label = "cpu";
-                        ethernet = <&gmac0>;
-                        phy-mode = "rgmii";
+                        port@3 {
+                            reg = <3>;
+                            label = "lan4";
+                        };
 
-                        fixed-link {
-                            speed = <1000>;
-                            full-duplex;
-                            pause;
+                        /* Commented out, phy4 is muxed to gmac1.
+                        port@4 {
+                            reg = <4>;
+                            label = "wan";
+                        };
+                        */
+
+                        port@6 {
+                            reg = <6>;
+                            label = "cpu";
+                            ethernet = <&gmac0>;
+                            phy-mode = "trgmii";
+
+                            fixed-link {
+                                speed = <1000>;
+                                full-duplex;
+                                pause;
+                            };
                         };
                     };
                 };
@@ -318,87 +683,197 @@ examples:
         };
     };
 
+  # Example 6: MT7621: mux external phy to SoC's gmac1
   - |
-    //Example 3: MT7621: Port 5 is connected to external PHY: Port 5 -> external PHY.
-
-    ethernet {
-        #address-cells = <1>;
-        #size-cells = <0>;
-        gmac_0: mac@0 {
-            compatible = "mediatek,eth-mac";
-            reg = <0>;
-            phy-mode = "rgmii";
-
-            fixed-link {
-                speed = <1000>;
-                full-duplex;
-                pause;
+    #include <dt-bindings/interrupt-controller/mips-gic.h>
+    #include <dt-bindings/reset/mt7621-reset.h>
+
+    platform {
+        pinctrl {
+            example6_rgmii2_pins: rgmii2-pins {
+                pinmux {
+                    groups = "rgmii2";
+                    function = "rgmii2";
+                };
             };
         };
 
-        mdio0: mdio-bus {
+        ethernet {
             #address-cells = <1>;
             #size-cells = <0>;
 
-            /* External phy */
-            ephy5: ethernet-phy@7 {
-                reg = <7>;
+            pinctrl-names = "default";
+            pinctrl-0 = <&example6_rgmii2_pins>;
+
+            mac@1 {
+                compatible = "mediatek,eth-mac";
+                reg = <1>;
+
+                phy-handle = <&example6_ethphy7>;
+                phy-mode = "rgmii";
             };
 
-            switch@1f {
-                compatible = "mediatek,mt7621";
-                reg = <0x1f>;
-                mediatek,mcm;
+            mdio {
+                #address-cells = <1>;
+                #size-cells = <0>;
 
-                resets = <&rstctrl 2>;
-                reset-names = "mcm";
+                /* External PHY */
+                example6_ethphy7: ethernet-phy@7 {
+                    reg = <7>;
+                    phy-mode = "rgmii";
+                };
 
-                ethernet-ports {
-                    #address-cells = <1>;
-                    #size-cells = <0>;
+                switch@0 {
+                    compatible = "mediatek,mt7621";
+                    reg = <0>;
 
-                    port@0 {
-                        reg = <0>;
-                        label = "lan0";
-                    };
+                    mediatek,mcm;
+                    resets = <&sysc MT7621_RST_MCM>;
+                    reset-names = "mcm";
 
-                    port@1 {
-                        reg = <1>;
-                        label = "lan1";
-                    };
+                    interrupt-controller;
+                    #interrupt-cells = <1>;
+                    interrupt-parent = <&gic>;
+                    interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
 
-                    port@2 {
-                        reg = <2>;
-                        label = "lan2";
-                    };
+                    ports {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
 
-                    port@3 {
-                        reg = <3>;
-                        label = "lan3";
-                    };
+                        port@0 {
+                            reg = <0>;
+                            label = "lan1";
+                        };
 
-                    port@4 {
-                        reg = <4>;
-                        label = "lan4";
-                    };
+                        port@1 {
+                            reg = <1>;
+                            label = "lan2";
+                        };
 
-                    port@5 {
-                        reg = <5>;
-                        label = "lan5";
-                        phy-mode = "rgmii";
-                        phy-handle = <&ephy5>;
+                        port@2 {
+                            reg = <2>;
+                            label = "lan3";
+                        };
+
+                        port@3 {
+                            reg = <3>;
+                            label = "lan4";
+                        };
+
+                        port@4 {
+                            reg = <4>;
+                            label = "wan";
+                        };
+
+                        port@6 {
+                            reg = <6>;
+                            label = "cpu";
+                            ethernet = <&gmac0>;
+                            phy-mode = "trgmii";
+
+                            fixed-link {
+                                speed = <1000>;
+                                full-duplex;
+                                pause;
+                            };
+                        };
                     };
+                };
+            };
+        };
+    };
+
+  # Example 7: MT7621: mux external phy to MT7530's port 5
+  - |
+    #include <dt-bindings/interrupt-controller/mips-gic.h>
+    #include <dt-bindings/reset/mt7621-reset.h>
+
+    platform {
+        pinctrl {
+            example7_rgmii2_pins: rgmii2-pins {
+                pinmux {
+                    groups = "rgmii2";
+                    function = "gpio";
+                };
+            };
+        };
+
+        ethernet {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            pinctrl-names = "default";
+            pinctrl-0 = <&example7_rgmii2_pins>;
+
+            mdio {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                /* External PHY */
+                example7_ethphy7: ethernet-phy@7 {
+                    reg = <7>;
+                };
+
+                switch@0 {
+                    compatible = "mediatek,mt7621";
+                    reg = <0>;
+
+                    mediatek,mcm;
+                    resets = <&sysc MT7621_RST_MCM>;
+                    reset-names = "mcm";
 
-                    cpu_port0: port@6 {
-                        reg = <6>;
-                        label = "cpu";
-                        ethernet = <&gmac_0>;
-                        phy-mode = "rgmii";
+                    interrupt-controller;
+                    #interrupt-cells = <1>;
+                    interrupt-parent = <&gic>;
+                    interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
+
+                    ports {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        port@0 {
+                            reg = <0>;
+                            label = "lan1";
+                        };
+
+                        port@1 {
+                            reg = <1>;
+                            label = "lan2";
+                        };
+
+                        port@2 {
+                            reg = <2>;
+                            label = "lan3";
+                        };
+
+                        port@3 {
+                            reg = <3>;
+                            label = "lan4";
+                        };
+
+                        port@4 {
+                            reg = <4>;
+                            label = "wan";
+                        };
+
+                        port@5 {
+                            reg = <5>;
+                            label = "extphy";
+                            phy-mode = "rgmii-txid";
+                            phy-handle = <&example7_ethphy7>;
+                        };
 
-                        fixed-link {
-                            speed = <1000>;
-                            full-duplex;
-                            pause;
+                        port@6 {
+                            reg = <6>;
+                            label = "cpu";
+                            ethernet = <&gmac0>;
+                            phy-mode = "trgmii";
+
+                            fixed-link {
+                                speed = <1000>;
+                                full-duplex;
+                                pause;
+                            };
                         };
                     };
                 };
-- 
2.34.1

