Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B10848557E
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbiAEPKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:10:13 -0500
Received: from mail-oi1-f174.google.com ([209.85.167.174]:36723 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236671AbiAEPKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:10:12 -0500
Received: by mail-oi1-f174.google.com with SMTP id t23so64863876oiw.3;
        Wed, 05 Jan 2022 07:10:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=80s0p4eQl8zlVQktN/6w7y1awfotSdQOAfSYLwD7vMc=;
        b=cbEysp0pzACL/2yOQgVwWRcftgFM5rg7Ia4keKpjYRHaSruKrd8UydI5pkSTI4QheZ
         GcQ98eCpc2mE0Mm4roYyvC/99OcjX41IKpYKgpttpX2L2bKm0tF1NhgffH0I8wyWVA5A
         d2MvZ3pZVoy6sz0Yzt42ktnl+7qt0C2wxfFOaDMlYF9Ad4XSTAnuyxFDnDU06uujynfI
         A/haHz355O79RDuYClXSY9ToewG8zrsMXMT0xzfQ696Ph+vaGWI8FdtRNiMialfem0rv
         DukepsiH6kO5mdk3Ld6V5sua1YfA5NTWFdGk8+zlvx/unAuXlhO4IkhlcdnldqLb5Nh9
         0wCQ==
X-Gm-Message-State: AOAM530NybUldOnQzgst3P/EjbO4y5IqqoKQx0HDSqqrjkgIMb5ZGgS6
        u03BCr0KHw+SYv5EVmOS4I0XwBLKBA==
X-Google-Smtp-Source: ABdhPJzU1OFwWdTKt7eopHSq8TdfAa0L1jyOz0zFjRuYPwMaHOFhcTbhSez+JF/dCdWi9jphUM0NoQ==
X-Received: by 2002:aca:de07:: with SMTP id v7mr2758321oig.28.1641395411319;
        Wed, 05 Jan 2022 07:10:11 -0800 (PST)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id q14sm8260943ood.28.2022.01.05.07.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 07:10:10 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Cristian Ciocaltea <cristian.ciocaltea@gmail.com>,
        =?UTF-8?q?Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
        John Crispin <john@phrozen.org>,
        "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: [PATCH] dt-bindings: net: Cleanup MDIO node schemas
Date:   Wed,  5 Jan 2022 09:10:09 -0600
Message-Id: <20220105151009.3093506-1-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The schemas for MDIO bus nodes range from missing to duplicating
everything in mdio.yaml. The MDIO bus node schemas only need to
reference mdio.yaml, define any binding specific properties, and define
'unevaluatedProperties: false'. This ensures that MDIO nodes only
contain defined properties. With this, any duplicated properties can
be removed.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Cc: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Cc: "Fernández Rojas" <noltari@gmail.com>
Cc: John Crispin <john@phrozen.org>
Cc: "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
I can take this via the DT tree.

 .../bindings/net/actions,owl-emac.yaml        |  4 +++
 .../net/allwinner,sun8i-a83t-emac.yaml        | 25 ++++++++----------
 .../bindings/net/brcm,bcm6368-mdio-mux.yaml   | 26 +------------------
 .../bindings/net/dsa/nxp,sja1105.yaml         |  6 ++---
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 23 ++--------------
 .../devicetree/bindings/net/fsl,fec.yaml      |  3 ++-
 .../bindings/net/intel,dwmac-plat.yaml        |  2 +-
 .../bindings/net/intel,ixp4xx-ethernet.yaml   |  4 +--
 .../bindings/net/litex,liteeth.yaml           |  1 +
 .../devicetree/bindings/net/mdio-mux.yaml     |  7 ++---
 .../bindings/net/mediatek,star-emac.yaml      |  5 ++--
 .../devicetree/bindings/net/qca,ar71xx.yaml   |  4 +++
 .../devicetree/bindings/net/snps,dwmac.yaml   |  3 ++-
 .../bindings/net/socionext,uniphier-ave4.yaml |  1 +
 .../bindings/net/toshiba,visconti-dwmac.yaml  |  2 +-
 15 files changed, 38 insertions(+), 78 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/actions,owl-emac.yaml b/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
index 1626e0a821b0..d30fada2ac39 100644
--- a/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
+++ b/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
@@ -51,6 +51,10 @@ properties:
     description:
       Phandle to the device containing custom config.
 
+  mdio:
+    $ref: mdio.yaml#
+    unevaluatedProperties: false
+
 required:
   - compatible
   - reg
diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
index 407586bc366b..6a4831fd3616 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
@@ -122,6 +122,7 @@ allOf:
 
         mdio-mux:
           type: object
+          unevaluatedProperties: false
 
           properties:
             compatible:
@@ -132,17 +133,18 @@ allOf:
               description:
                 Phandle to EMAC MDIO.
 
+            "#address-cells":
+              const: 1
+
+            "#size-cells":
+              const: 0
+
             mdio@1:
-              type: object
+              $ref: mdio.yaml#
+              unevaluatedProperties: false
               description: Internal MDIO Bus
 
               properties:
-                "#address-cells":
-                  const: 1
-
-                "#size-cells":
-                  const: 0
-
                 compatible:
                   const: allwinner,sun8i-h3-mdio-internal
 
@@ -168,16 +170,11 @@ allOf:
 
 
             mdio@2:
-              type: object
+              $ref: mdio.yaml#
+              unevaluatedProperties: false
               description: External MDIO Bus (H3 only)
 
               properties:
-                "#address-cells":
-                  const: 1
-
-                "#size-cells":
-                  const: 0
-
                 reg:
                   const: 2
 
diff --git a/Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml b/Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml
index 2f34fda55fd0..9ef28c2a0afc 100644
--- a/Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml
+++ b/Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml
@@ -15,18 +15,12 @@ description:
   properties as well to generate desired MDIO transaction on appropriate bus.
 
 allOf:
-  - $ref: "mdio.yaml#"
+  - $ref: mdio-mux.yaml#
 
 properties:
   compatible:
     const: brcm,bcm6368-mdio-mux
 
-  "#address-cells":
-    const: 1
-
-  "#size-cells":
-    const: 0
-
   reg:
     maxItems: 1
 
@@ -34,24 +28,6 @@ required:
   - compatible
   - reg
 
-patternProperties:
-  '^mdio@[0-1]$':
-    type: object
-    properties:
-      reg:
-        maxItems: 1
-
-      "#address-cells":
-        const: 1
-
-      "#size-cells":
-        const: 0
-
-    required:
-      - reg
-      - "#address-cells"
-      - "#size-cells"
-
 unevaluatedProperties: false
 
 examples:
diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index 24cd733c11d1..1ea0bd490473 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -52,10 +52,8 @@ properties:
 
     patternProperties:
       "^mdio@[0-1]$":
-        type: object
-
-        allOf:
-          - $ref: "http://devicetree.org/schemas/net/mdio.yaml#"
+        $ref: /schemas/net/mdio.yaml#
+        unevaluatedProperties: false
 
         properties:
           compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 48de0ace265d..907b2ae6442d 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -58,33 +58,14 @@ properties:
       B68 on the QCA832x and B49 on the QCA833x.
 
   mdio:
-    type: object
+    $ref: /schemas/net/mdio.yaml#
+    unevaluatedProperties: false
     description: Qca8k switch have an internal mdio to access switch port.
                  If this is not present, the legacy mapping is used and the
                  internal mdio access is used.
                  With the legacy mapping the reg corresponding to the internal
                  mdio is the switch reg with an offset of -1.
 
-    properties:
-      '#address-cells':
-        const: 1
-      '#size-cells':
-        const: 0
-
-    patternProperties:
-      "^(ethernet-)?phy@[0-4]$":
-        type: object
-
-        allOf:
-          - $ref: "http://devicetree.org/schemas/net/mdio.yaml#"
-
-        properties:
-          reg:
-            maxItems: 1
-
-        required:
-          - reg
-
 patternProperties:
   "^(ethernet-)?ports$":
     type: object
diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index eca41443fcce..fd8371e31867 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -165,7 +165,8 @@ properties:
       req_bit is the gpr bit offset for ENET stop request.
 
   mdio:
-    type: object
+    $ref: mdio.yaml#
+    unevaluatedProperties: false
     description:
       Specifies the mdio bus in the FEC, used as a container for phy nodes.
 
diff --git a/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml b/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
index 08a3f1f6aea2..52a7fa4f49a4 100644
--- a/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
+++ b/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
@@ -117,7 +117,7 @@ examples:
         snps,mtl-tx-config = <&mtl_tx_setup>;
         snps,tso;
 
-        mdio0 {
+        mdio {
             #address-cells = <1>;
             #size-cells = <0>;
             compatible = "snps,dwmac-mdio";
diff --git a/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
index 378ed2d3b003..67eaf02dda80 100644
--- a/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
+++ b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
@@ -48,8 +48,8 @@ properties:
       and the instance to use in the second cell
 
   mdio:
-    type: object
-    $ref: "mdio.yaml#"
+    $ref: mdio.yaml#
+    unevaluatedProperties: false
     description: optional node for embedded MDIO controller
 
 required:
diff --git a/Documentation/devicetree/bindings/net/litex,liteeth.yaml b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
index 76c164a8199a..ebf4e360f8dd 100644
--- a/Documentation/devicetree/bindings/net/litex,liteeth.yaml
+++ b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
@@ -62,6 +62,7 @@ properties:
 
   mdio:
     $ref: mdio.yaml#
+    unevaluatedProperties: false
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/net/mdio-mux.yaml b/Documentation/devicetree/bindings/net/mdio-mux.yaml
index d169adf5d9f4..4321c87de86f 100644
--- a/Documentation/devicetree/bindings/net/mdio-mux.yaml
+++ b/Documentation/devicetree/bindings/net/mdio-mux.yaml
@@ -15,9 +15,6 @@ description: |+
   bus multiplexer/switch will have one child node for each child bus.
 
 properties:
-  $nodename:
-    pattern: '^mdio-mux[\-@]?'
-
   mdio-parent-bus:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
@@ -32,12 +29,12 @@ properties:
 
 patternProperties:
   '^mdio@[0-9a-f]+$':
-    type: object
+    $ref: mdio.yaml#
+    unevaluatedProperties: false
 
     properties:
       reg:
         maxItems: 1
-        description: The sub-bus number.
 
 additionalProperties: true
 
diff --git a/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml b/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
index e6a5ff208253..def994c9cbb4 100644
--- a/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
@@ -48,9 +48,8 @@ properties:
       to control the MII mode.
 
   mdio:
-    type: object
-    description:
-      Creates and registers an MDIO bus.
+    $ref: mdio.yaml#
+    unevaluatedProperties: false
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/net/qca,ar71xx.yaml b/Documentation/devicetree/bindings/net/qca,ar71xx.yaml
index 72c931288109..b76a1436fb1b 100644
--- a/Documentation/devicetree/bindings/net/qca,ar71xx.yaml
+++ b/Documentation/devicetree/bindings/net/qca,ar71xx.yaml
@@ -62,6 +62,10 @@ properties:
       - const: mac
       - const: mdio
 
+  mdio:
+    $ref: mdio.yaml#
+    unevaluatedProperties: false
+
 required:
   - compatible
   - reg
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 1d67ed0cdec1..7eb43707e601 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -286,7 +286,8 @@ properties:
       MAC2MAC connection.
 
   mdio:
-    type: object
+    $ref: mdio.yaml#
+    unevaluatedProperties: false
     description:
       Creates and registers an MDIO bus.
 
diff --git a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
index 6bc61c42418f..aad5a9f3f962 100644
--- a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
+++ b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
@@ -72,6 +72,7 @@ properties:
 
   mdio:
     $ref: mdio.yaml#
+    unevaluatedProperties: false
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml b/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
index 59724d18e6f3..b12bfe61c67a 100644
--- a/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
@@ -71,7 +71,7 @@ examples:
             phy-mode = "rgmii-id";
             phy-handle = <&phy0>;
 
-            mdio0 {
+            mdio {
                 #address-cells = <0x1>;
                 #size-cells = <0x0>;
                 compatible = "snps,dwmac-mdio";
-- 
2.32.0

