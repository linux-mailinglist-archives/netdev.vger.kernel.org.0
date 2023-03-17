Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2438D6BF668
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 00:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCQXgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 19:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCQXgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 19:36:18 -0400
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421C2168B9;
        Fri, 17 Mar 2023 16:36:15 -0700 (PDT)
Received: by mail-il1-f177.google.com with SMTP id r4so3556086ilt.8;
        Fri, 17 Mar 2023 16:36:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679096174;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P0aF6ySv7asajF8QSLAx821GR/b/dPYB7aTm0dn3L94=;
        b=Z2zaCvIFDBJzMVlCkh/m0A+2hxzxlk1685aGtJ/SI5tp0kMyasmhw1KCqcGgLQw9mW
         Ld132F7ZD1oFVuA5TyRP0T3o2C8quXcxKaZ7beLzo8De8gK5XZIvpT6TGUpOxetTFeZO
         aaxl2te26PC281FIf75YW/BrhHF54E9e+jI+Jn+LlmSpyxI86Cp8m7/I6b6nlTCx0z9k
         dHi8vTG+gVwFUV89cakh+JacfxoPAMTmxsRUlE2Awnxn58LX37gQGfaNMBpbzhOT/1xS
         h+U0ddmRZYvw2mI0k4OUE38WtRke+1D14S0Yu9qogWwQeZ/TP3RzFVo7uyJMdElffukN
         VbAQ==
X-Gm-Message-State: AO0yUKWxQg6OvYhx7P7cgyM/LQB/K6c9ODtNjxi8kg/UezTFcZ/liuSt
        1U0Qz/fCbLR+/aRnjV3Eqg==
X-Google-Smtp-Source: AK7set8i36jIwNGiz3lVm0JEUk3Sk3gigF6WNTviKuhT/8WfE7jes3Obudbc+M/tAFS0rHecCDO7zg==
X-Received: by 2002:a92:ca8d:0:b0:314:e56:54fc with SMTP id t13-20020a92ca8d000000b003140e5654fcmr245501ilo.1.1679096174333;
        Fri, 17 Mar 2023 16:36:14 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id f6-20020a056e020c6600b00315327197d4sm960686ilj.23.2023.03.17.16.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 16:36:13 -0700 (PDT)
Received: (nullmailer pid 3967802 invoked by uid 1000);
        Fri, 17 Mar 2023 23:36:10 -0000
From:   Rob Herring <robh@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, linux-aspeed@lists.ozlabs.org,
        linux-can@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH] dt-bindings: net: Drop unneeded quotes
Date:   Fri, 17 Mar 2023 18:36:03 -0500
Message-Id: <20230317233605.3967621-1-robh@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cleanup bindings dropping unneeded quotes. Once all these are fixed,
checking for this can be enabled in yamllint.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/actions,owl-emac.yaml  |  2 +-
 .../bindings/net/allwinner,sun4i-a10-emac.yaml     |  2 +-
 .../bindings/net/allwinner,sun4i-a10-mdio.yaml     |  2 +-
 .../devicetree/bindings/net/altr,tse.yaml          |  2 +-
 .../bindings/net/aspeed,ast2600-mdio.yaml          |  2 +-
 .../devicetree/bindings/net/brcm,amac.yaml         |  2 +-
 .../devicetree/bindings/net/brcm,systemport.yaml   |  2 +-
 .../bindings/net/broadcom-bluetooth.yaml           |  2 +-
 .../devicetree/bindings/net/can/xilinx,can.yaml    |  6 +++---
 .../devicetree/bindings/net/dsa/brcm,sf2.yaml      |  2 +-
 .../devicetree/bindings/net/dsa/qca8k.yaml         |  2 +-
 .../devicetree/bindings/net/engleder,tsnep.yaml    |  2 +-
 .../devicetree/bindings/net/ethernet-phy.yaml      |  2 +-
 .../bindings/net/fsl,qoriq-mc-dpmac.yaml           |  2 +-
 .../bindings/net/intel,ixp4xx-ethernet.yaml        |  8 ++++----
 .../devicetree/bindings/net/intel,ixp4xx-hss.yaml  | 14 +++++++-------
 .../devicetree/bindings/net/marvell,mvusb.yaml     |  2 +-
 .../devicetree/bindings/net/mdio-gpio.yaml         |  2 +-
 .../devicetree/bindings/net/mediatek,net.yaml      |  2 +-
 .../bindings/net/mediatek,star-emac.yaml           |  2 +-
 .../bindings/net/microchip,lan966x-switch.yaml     |  2 +-
 .../bindings/net/microchip,sparx5-switch.yaml      |  4 ++--
 .../devicetree/bindings/net/mscc,miim.yaml         |  2 +-
 .../devicetree/bindings/net/nfc/marvell,nci.yaml   |  2 +-
 .../devicetree/bindings/net/nfc/nxp,pn532.yaml     |  2 +-
 .../bindings/net/pse-pd/podl-pse-regulator.yaml    |  2 +-
 .../devicetree/bindings/net/qcom,ipq4019-mdio.yaml |  2 +-
 .../devicetree/bindings/net/qcom,ipq8064-mdio.yaml |  2 +-
 .../devicetree/bindings/net/rockchip,emac.yaml     |  2 +-
 .../devicetree/bindings/net/snps,dwmac.yaml        |  2 +-
 .../devicetree/bindings/net/stm32-dwmac.yaml       |  4 ++--
 .../devicetree/bindings/net/ti,cpsw-switch.yaml    | 10 +++++-----
 .../devicetree/bindings/net/ti,davinci-mdio.yaml   |  2 +-
 .../devicetree/bindings/net/ti,dp83822.yaml        |  2 +-
 .../devicetree/bindings/net/ti,dp83867.yaml        |  2 +-
 .../devicetree/bindings/net/ti,dp83869.yaml        |  2 +-
 36 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/actions,owl-emac.yaml b/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
index d30fada2ac39..5718ab4654b2 100644
--- a/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
+++ b/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
@@ -16,7 +16,7 @@ description: |
   operation modes at 10/100 Mb/s data transfer rates.
 
 allOf:
-  - $ref: "ethernet-controller.yaml#"
+  - $ref: ethernet-controller.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml
index 987b91b9afe9..eb26623dab51 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Allwinner A10 EMAC Ethernet Controller
 
 allOf:
-  - $ref: "ethernet-controller.yaml#"
+  - $ref: ethernet-controller.yaml#
 
 maintainers:
   - Chen-Yu Tsai <wens@csie.org>
diff --git a/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-mdio.yaml b/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-mdio.yaml
index ede977cdfb8d..85f552b907f3 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-mdio.yaml
@@ -11,7 +11,7 @@ maintainers:
   - Maxime Ripard <mripard@kernel.org>
 
 allOf:
-  - $ref: "mdio.yaml#"
+  - $ref: mdio.yaml#
 
 # Select every compatible, including the deprecated ones. This way, we
 # will be able to report a warning when we have that compatible, since
diff --git a/Documentation/devicetree/bindings/net/altr,tse.yaml b/Documentation/devicetree/bindings/net/altr,tse.yaml
index 8d1d94494349..9d02af468906 100644
--- a/Documentation/devicetree/bindings/net/altr,tse.yaml
+++ b/Documentation/devicetree/bindings/net/altr,tse.yaml
@@ -66,7 +66,7 @@ required:
   - tx-fifo-depth
 
 allOf:
-  - $ref: "ethernet-controller.yaml#"
+  - $ref: ethernet-controller.yaml#
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
index f81eda8cb0a5..d6ef468495c5 100644
--- a/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
@@ -15,7 +15,7 @@ description: |+
   MAC.
 
 allOf:
-  - $ref: "mdio.yaml#"
+  - $ref: mdio.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/brcm,amac.yaml b/Documentation/devicetree/bindings/net/brcm,amac.yaml
index ee2eac8f5710..210fb29c4e7b 100644
--- a/Documentation/devicetree/bindings/net/brcm,amac.yaml
+++ b/Documentation/devicetree/bindings/net/brcm,amac.yaml
@@ -10,7 +10,7 @@ maintainers:
   - Florian Fainelli <f.fainelli@gmail.com>
 
 allOf:
-  - $ref: "ethernet-controller.yaml#"
+  - $ref: ethernet-controller.yaml#
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/net/brcm,systemport.yaml b/Documentation/devicetree/bindings/net/brcm,systemport.yaml
index 5fc9c9fafd85..b40006d44791 100644
--- a/Documentation/devicetree/bindings/net/brcm,systemport.yaml
+++ b/Documentation/devicetree/bindings/net/brcm,systemport.yaml
@@ -66,7 +66,7 @@ required:
   - phy-mode
 
 allOf:
-  - $ref: "ethernet-controller.yaml#"
+  - $ref: ethernet-controller.yaml#
 
 unevaluatedProperties: false
 
diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
index b964c7dcec15..cc70b00c6ce5 100644
--- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
@@ -121,7 +121,7 @@ required:
   - compatible
 
 dependencies:
-  brcm,requires-autobaud-mode: [ 'shutdown-gpios' ]
+  brcm,requires-autobaud-mode: [ shutdown-gpios ]
 
 if:
   not:
diff --git a/Documentation/devicetree/bindings/net/can/xilinx,can.yaml b/Documentation/devicetree/bindings/net/can/xilinx,can.yaml
index 65af8183cb9c..897d2cbda45b 100644
--- a/Documentation/devicetree/bindings/net/can/xilinx,can.yaml
+++ b/Documentation/devicetree/bindings/net/can/xilinx,can.yaml
@@ -35,15 +35,15 @@ properties:
     maxItems: 1
 
   tx-fifo-depth:
-    $ref: "/schemas/types.yaml#/definitions/uint32"
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: CAN Tx fifo depth (Zynq, Axi CAN).
 
   rx-fifo-depth:
-    $ref: "/schemas/types.yaml#/definitions/uint32"
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: CAN Rx fifo depth (Zynq, Axi CAN, CAN FD in sequential Rx mode)
 
   tx-mailbox-count:
-    $ref: "/schemas/types.yaml#/definitions/uint32"
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: CAN Tx mailbox buffer count (CAN FD)
 
 required:
diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
index eed16e216fb6..37bf33bd4670 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
@@ -103,7 +103,7 @@ required:
   - "#size-cells"
 
 allOf:
-  - $ref: "dsa.yaml#"
+  - $ref: dsa.yaml#
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 389892592aac..fe9ebe285938 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -66,7 +66,7 @@ properties:
                  With the legacy mapping the reg corresponding to the internal
                  mdio is the switch reg with an offset of -1.
 
-$ref: "dsa.yaml#"
+$ref: dsa.yaml#
 
 patternProperties:
   "^(ethernet-)?ports$":
diff --git a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
index 4116667133ce..82a5d7927ca4 100644
--- a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
+++ b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
@@ -62,7 +62,7 @@ properties:
 
   mdio:
     type: object
-    $ref: "mdio.yaml#"
+    $ref: mdio.yaml#
     description: optional node for embedded MDIO controller
 
 required:
diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 1327b81f15a2..ac04f8efa35c 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -83,7 +83,7 @@ properties:
       0: Disable 2.4 Vpp operating mode.
       1: Request 2.4 Vpp operating mode from link partner.
       Absence of this property will leave configuration to default values.
-    $ref: "/schemas/types.yaml#/definitions/uint32"
+    $ref: /schemas/types.yaml#/definitions/uint32
     enum: [0, 1]
 
   broken-turn-around:
diff --git a/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml b/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
index 6e0763898d3a..a1b71b35319e 100644
--- a/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
@@ -14,7 +14,7 @@ description:
   located under the 'dpmacs' node for the fsl-mc bus DTS node.
 
 allOf:
-  - $ref: "ethernet-controller.yaml#"
+  - $ref: ethernet-controller.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
index 4e1b79818aff..d79901451abd 100644
--- a/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
+++ b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Intel IXP4xx ethernet
 
 allOf:
-  - $ref: "ethernet-controller.yaml#"
+  - $ref: ethernet-controller.yaml#
 
 maintainers:
   - Linus Walleij <linus.walleij@linaro.org>
@@ -28,7 +28,7 @@ properties:
     description: Ethernet MMIO address range
 
   queue-rx:
-    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     items:
       - items:
           - description: phandle to the RX queue node
@@ -36,7 +36,7 @@ properties:
     description: phandle to the RX queue on the NPE
 
   queue-txready:
-    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     items:
       - items:
           - description: phandle to the TX READY queue node
@@ -48,7 +48,7 @@ properties:
   phy-handle: true
 
   intel,npe-handle:
-    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     items:
       - items:
           - description: phandle to the NPE this ethernet instance is using
diff --git a/Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml b/Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml
index e6329febb60c..5adf95e75781 100644
--- a/Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml
+++ b/Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml
@@ -24,7 +24,7 @@ properties:
     description: The HSS instance
 
   intel,npe-handle:
-    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     items:
       items:
         - description: phandle to the NPE this HSS instance is using
@@ -33,7 +33,7 @@ properties:
       and the instance to use in the second cell
 
   intel,queue-chl-rxtrig:
-    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     items:
       - items:
           - description: phandle to the RX trigger queue on the NPE
@@ -41,7 +41,7 @@ properties:
     description: phandle to the RX trigger queue on the NPE
 
   intel,queue-chl-txready:
-    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     items:
       - items:
           - description: phandle to the TX ready queue on the NPE
@@ -49,7 +49,7 @@ properties:
     description: phandle to the TX ready queue on the NPE
 
   intel,queue-pkt-rx:
-    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     items:
       - items:
           - description: phandle to the RX queue on the NPE
@@ -57,7 +57,7 @@ properties:
     description: phandle to the packet RX queue on the NPE
 
   intel,queue-pkt-tx:
-    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     maxItems: 4
     items:
       items:
@@ -66,7 +66,7 @@ properties:
     description: phandle to the packet TX0, TX1, TX2 and TX3 queues on the NPE
 
   intel,queue-pkt-rxfree:
-    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     maxItems: 4
     items:
       items:
@@ -76,7 +76,7 @@ properties:
       RXFREE3 queues on the NPE
 
   intel,queue-pkt-txdone:
-    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     items:
       - items:
           - description: phandle to the TXDONE queue on the NPE
diff --git a/Documentation/devicetree/bindings/net/marvell,mvusb.yaml b/Documentation/devicetree/bindings/net/marvell,mvusb.yaml
index 8e288ab38fd7..3a3325168048 100644
--- a/Documentation/devicetree/bindings/net/marvell,mvusb.yaml
+++ b/Documentation/devicetree/bindings/net/marvell,mvusb.yaml
@@ -20,7 +20,7 @@ description: |+
   definition.
 
 allOf:
-  - $ref: "mdio.yaml#"
+  - $ref: mdio.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/mdio-gpio.yaml b/Documentation/devicetree/bindings/net/mdio-gpio.yaml
index 137657341802..eb4171a1940e 100644
--- a/Documentation/devicetree/bindings/net/mdio-gpio.yaml
+++ b/Documentation/devicetree/bindings/net/mdio-gpio.yaml
@@ -12,7 +12,7 @@ maintainers:
   - Russell King <linux@armlinux.org.uk>
 
 allOf:
-  - $ref: "mdio.yaml#"
+  - $ref: mdio.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/Documentation/devicetree/bindings/net/mediatek,net.yaml
index 7ef696204c5a..49e7f5e1a531 100644
--- a/Documentation/devicetree/bindings/net/mediatek,net.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
@@ -91,7 +91,7 @@ properties:
     const: 0
 
 allOf:
-  - $ref: "ethernet-controller.yaml#"
+  - $ref: ethernet-controller.yaml#
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml b/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
index 64c893c98d80..2e889f9a563e 100644
--- a/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
@@ -15,7 +15,7 @@ description:
   modes with flow-control as well as CRC offloading and VLAN tags.
 
 allOf:
-  - $ref: "ethernet-controller.yaml#"
+  - $ref: ethernet-controller.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
index dc116f14750e..306ef9ecf2b9 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
@@ -73,7 +73,7 @@ properties:
       "^port@[0-9a-f]+$":
         type: object
 
-        $ref: "/schemas/net/ethernet-controller.yaml#"
+        $ref: /schemas/net/ethernet-controller.yaml#
         unevaluatedProperties: false
 
         properties:
diff --git a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
index 57ffeb8fc876..fcafef8d5a33 100644
--- a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
@@ -99,7 +99,7 @@ properties:
 
           microchip,bandwidth:
             description: Specifies bandwidth in Mbit/s allocated to the port.
-            $ref: "/schemas/types.yaml#/definitions/uint32"
+            $ref: /schemas/types.yaml#/definitions/uint32
             maximum: 25000
 
           microchip,sd-sgpio:
@@ -107,7 +107,7 @@ properties:
               Index of the ports Signal Detect SGPIO in the set of 384 SGPIOs
               This is optional, and only needed if the default used index is
               is not correct.
-            $ref: "/schemas/types.yaml#/definitions/uint32"
+            $ref: /schemas/types.yaml#/definitions/uint32
             minimum: 0
             maximum: 383
 
diff --git a/Documentation/devicetree/bindings/net/mscc,miim.yaml b/Documentation/devicetree/bindings/net/mscc,miim.yaml
index 2c451cfa4e0b..5b292e7c9e46 100644
--- a/Documentation/devicetree/bindings/net/mscc,miim.yaml
+++ b/Documentation/devicetree/bindings/net/mscc,miim.yaml
@@ -10,7 +10,7 @@ maintainers:
   - Alexandre Belloni <alexandre.belloni@bootlin.com>
 
 allOf:
-  - $ref: "mdio.yaml#"
+  - $ref: mdio.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml b/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml
index 308485a8ee6c..8e9a95f24c80 100644
--- a/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml
@@ -28,7 +28,7 @@ properties:
     maxItems: 1
 
   reset-n-io:
-    $ref: "/schemas/types.yaml#/definitions/phandle-array"
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     maxItems: 1
     description: |
       Output GPIO pin used to reset the chip (active low)
diff --git a/Documentation/devicetree/bindings/net/nfc/nxp,pn532.yaml b/Documentation/devicetree/bindings/net/nfc/nxp,pn532.yaml
index 0509e0166345..07c67c1e985f 100644
--- a/Documentation/devicetree/bindings/net/nfc/nxp,pn532.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/nxp,pn532.yaml
@@ -31,7 +31,7 @@ required:
   - compatible
 
 dependencies:
-  interrupts: [ 'reg' ]
+  interrupts: [ reg ]
 
 additionalProperties: false
 
diff --git a/Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml b/Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml
index c6b1c188abf7..94a527e6aa1b 100644
--- a/Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml
+++ b/Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml
@@ -13,7 +13,7 @@ description: Regulator based PoDL PSE controller. The device must be referenced
   by the PHY node to control power injection to the Ethernet cable.
 
 allOf:
-  - $ref: "pse-controller.yaml#"
+  - $ref: pse-controller.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
index 7631ecc8fd01..3407e909e8a7 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
@@ -51,7 +51,7 @@ required:
   - "#size-cells"
 
 allOf:
-  - $ref: "mdio.yaml#"
+  - $ref: mdio.yaml#
 
   - if:
       properties:
diff --git a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
index d7748dd33199..144001ff840c 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
@@ -14,7 +14,7 @@ description:
   used to communicate with the gmac phy connected.
 
 allOf:
-  - $ref: "mdio.yaml#"
+  - $ref: mdio.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/rockchip,emac.yaml b/Documentation/devicetree/bindings/net/rockchip,emac.yaml
index a6d4f14df442..364028b3bba4 100644
--- a/Documentation/devicetree/bindings/net/rockchip,emac.yaml
+++ b/Documentation/devicetree/bindings/net/rockchip,emac.yaml
@@ -61,7 +61,7 @@ required:
   - mdio
 
 allOf:
-  - $ref: "ethernet-controller.yaml#"
+  - $ref: ethernet-controller.yaml#
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 16b7d2904696..74f2ddc12018 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -555,7 +555,7 @@ dependencies:
   snps,reset-delays-us: ["snps,reset-gpio"]
 
 allOf:
-  - $ref: "ethernet-controller.yaml#"
+  - $ref: ethernet-controller.yaml#
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
index 5c93167b3b41..caae3c2a9419 100644
--- a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
@@ -26,7 +26,7 @@ select:
     - compatible
 
 allOf:
-  - $ref: "snps,dwmac.yaml#"
+  - $ref: snps,dwmac.yaml#
 
 properties:
   compatible:
@@ -73,7 +73,7 @@ properties:
         - ptp_ref
 
   st,syscon:
-    $ref: "/schemas/types.yaml#/definitions/phandle-array"
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     items:
       - items:
           - description: phandle to the syscon node which encompases the glue register
diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
index e36c7817be69..b04ac4966608 100644
--- a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
+++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
@@ -62,10 +62,10 @@ properties:
 
   interrupt-names:
     items:
-      - const: "rx_thresh"
-      - const: "rx"
-      - const: "tx"
-      - const: "misc"
+      - const: rx_thresh
+      - const: rx
+      - const: tx
+      - const: misc
 
   pinctrl-names: true
 
@@ -154,7 +154,7 @@ patternProperties:
     type: object
     description:
       CPSW MDIO bus.
-    $ref: "ti,davinci-mdio.yaml#"
+    $ref: ti,davinci-mdio.yaml#
 
 
 required:
diff --git a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
index a339202c5e8e..53604fab0b73 100644
--- a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
@@ -13,7 +13,7 @@ description:
   TI SoC Davinci/Keystone2 MDIO Controller
 
 allOf:
-  - $ref: "mdio.yaml#"
+  - $ref: mdio.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/ti,dp83822.yaml b/Documentation/devicetree/bindings/net/ti,dp83822.yaml
index f2489a9c852f..633a551c1501 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83822.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83822.yaml
@@ -21,7 +21,7 @@ description: |
     http://www.ti.com/lit/ds/symlink/dp83822i.pdf
 
 allOf:
-  - $ref: "ethernet-phy.yaml#"
+  - $ref: ethernet-phy.yaml#
 
 properties:
   reg:
diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.yaml b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
index b8c0e4b5b494..d3c3e589bd6f 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83867.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: TI DP83867 ethernet PHY
 
 allOf:
-  - $ref: "ethernet-controller.yaml#"
+  - $ref: ethernet-controller.yaml#
 
 maintainers:
   - Andrew Davis <afd@ti.com>
diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
index b04ff0014a59..4f1e5224bb00 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83869.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: TI DP83869 ethernet PHY
 
 allOf:
-  - $ref: "ethernet-phy.yaml#"
+  - $ref: ethernet-phy.yaml#
 
 maintainers:
   - Andrew Davis <afd@ti.com>
-- 
2.39.2

