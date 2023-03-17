Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A2B6BE858
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 12:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjCQLgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 07:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjCQLgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 07:36:37 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54D3AF2B3;
        Fri, 17 Mar 2023 04:35:50 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id m2so4123532wrh.6;
        Fri, 17 Mar 2023 04:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679052906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T7SQ9kaOy/S8FPUlJEhgskNXuG1oAfv0f3g7BLxvENA=;
        b=bFQmSZEDWdDZhF9L2URNpiIIe/JoGgban6C6b10czszEnLI2jBVncRYn2Hd5aDkP6a
         s4QA+muJ6Be9yNItjMB/6xBXsgzvatlITdPTjsQ3HKWAN+5vMNUoHvqbBfU1kkWbJZHj
         usLXl4cEp37U4m0QeCGfxrK/E4Wgy/BCvp6KmO0udQm1WiI5zIFDs1QjF3LocLavrfQI
         jj0utg/0E6N6wb9urLUZwSSS74vUK6QDbb6U7dgU8/cWMWmqjDYct/vQjUFubSostF2s
         AzvdAkAP5Gt8DmyZO1l7mUYWmEi2PhoJ2syc6GRWu22MFo8cTMiQ/i2xha1LfLjUEM10
         DBhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679052906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T7SQ9kaOy/S8FPUlJEhgskNXuG1oAfv0f3g7BLxvENA=;
        b=L4m7MgSsoOK9KsCfUIhm162HFC58a11EvTXe7JwMgqQIIsZKD4L+RuH2wAzf2ombhD
         xL3i5Nw59nR/PZer59BYQyMinJbIOWk/MxuYNefjXPCmuxPcCtchMHDB6t5GMmLmk949
         Q9booQua6i4HTdVLj99Fxmuic6nGRhTfuTvt6g87guq21XsD+WPQ/BGhuuvugUzh5z9w
         PNoG4g6F0deWAFOKuhyoKIWQj1Wlt4F62qHw7UD2wWNRKV6K7RJLD85+75HnX4UUdiE7
         oZYL+kEX1EVTPmaib0L0Y4AQkHgIF3IjiKMvjoc1H3v2GAu7eEx0JknXsVXHsrEs8NB1
         ARgA==
X-Gm-Message-State: AO0yUKWz1IASPpmXYzjuiUoVq6aww06JBTnJ+YooTtjIGRVt6kw8bhHw
        BMKFPvhovX8G83oG+5q7aLA=
X-Google-Smtp-Source: AK7set8ugol2R2dd4CTPf6kAsYMLUvAGMbKSL+WadpTOi4RnD23/YxghLWiXhTjIhH4hEESaqwXLTA==
X-Received: by 2002:a5d:674c:0:b0:2ce:aace:5b27 with SMTP id l12-20020a5d674c000000b002ceaace5b27mr6407172wrw.11.1679052905561;
        Fri, 17 Mar 2023 04:35:05 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm1763505wrj.47.2023.03.17.04.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:35:05 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH 1/3] dt-bindings: net: move bcm6368-mdio-mux bindings to b53
Date:   Fri, 17 Mar 2023 12:34:25 +0100
Message-Id: <20230317113427.302162-2-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230317113427.302162-1-noltari@gmail.com>
References: <20230317113427.302162-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

b53 MMAP devices have a MDIO Mux bus controller that must be registered after
properly initializing the switch. If the MDIO Mux controller is registered
from a separate driver and the device has an external switch present, it will
cause a race condition which will hang the device.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 .../bindings/net/brcm,bcm6368-mdio-mux.yaml   |  52 -------
 .../devicetree/bindings/net/dsa/brcm,b53.yaml | 131 ++++++++++++++++++
 2 files changed, 131 insertions(+), 52 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml b/Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml
deleted file mode 100644
index 9ef28c2a0afc..000000000000
--- a/Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml
+++ /dev/null
@@ -1,52 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
-%YAML 1.2
----
-$id: http://devicetree.org/schemas/net/brcm,bcm6368-mdio-mux.yaml#
-$schema: http://devicetree.org/meta-schemas/core.yaml#
-
-title: Broadcom BCM6368 MDIO bus multiplexer
-
-maintainers:
-  - Álvaro Fernández Rojas <noltari@gmail.com>
-
-description:
-  This MDIO bus multiplexer defines buses that could be internal as well as
-  external to SoCs. When child bus is selected, one needs to select these two
-  properties as well to generate desired MDIO transaction on appropriate bus.
-
-allOf:
-  - $ref: mdio-mux.yaml#
-
-properties:
-  compatible:
-    const: brcm,bcm6368-mdio-mux
-
-  reg:
-    maxItems: 1
-
-required:
-  - compatible
-  - reg
-
-unevaluatedProperties: false
-
-examples:
-  - |
-    mdio0: mdio@10e000b0 {
-      #address-cells = <1>;
-      #size-cells = <0>;
-      compatible = "brcm,bcm6368-mdio-mux";
-      reg = <0x10e000b0 0x6>;
-
-      mdio_int: mdio@0 {
-        #address-cells = <1>;
-        #size-cells = <0>;
-        reg = <0>;
-      };
-
-      mdio_ext: mdio@1 {
-        #address-cells = <1>;
-        #size-cells = <0>;
-        reg = <1>;
-      };
-    };
diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
index 5bef4128d175..b1a894899306 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
@@ -61,6 +61,17 @@ properties:
               - brcm,bcm6368-switch
           - const: brcm,bcm63xx-switch
 
+  big-endian:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      Set this flag for switches with big endian registers.
+
+  mdio-mux:
+    $ref: /schemas/net/mdio-mux.yaml
+    description:
+      MDIO bus multiplexer defines buses that could be internal as well as
+      external to SoCs.
+
 required:
   - compatible
   - reg
@@ -131,6 +142,22 @@ allOf:
         reg:
           maxItems: 1
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - brcm,bcm3384-switch
+              - brcm,bcm6328-switch
+              - brcm,bcm6368-switch
+    then:
+      properties:
+        reg:
+          minItems: 1
+          maxItems: 1
+      required:
+        - mdio-mux
+
 unevaluatedProperties: false
 
 examples:
@@ -262,3 +289,107 @@ examples:
             };
         };
     };
+  - |
+    switch0: switch@10f00000 {
+      compatible = "brcm,bcm6368-switch", "brcm,bcm63xx-switch";
+      reg = <0x10f00000 0x8000>;
+      big-endian;
+
+      dsa,member = <0 0>;
+
+      mdio-mux {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        mdio@0 {
+          #address-cells = <1>;
+          #size-cells = <0>;
+          reg = <0>;
+        };
+
+        mdio@1 {
+          #address-cells = <1>;
+          #size-cells = <0>;
+          reg = <1>;
+
+          switch@1e {
+            compatible = "brcm,bcm53125";
+            reg = <30>;
+
+            dsa,member = <1 0>;
+
+            ports {
+              #address-cells = <1>;
+              #size-cells = <0>;
+
+              port@0 {
+                reg = <0>;
+                label = "lan1";
+              };
+
+              port@1 {
+                reg = <1>;
+                label = "lan2";
+              };
+
+              port@2 {
+                reg = <2>;
+                label = "lan3";
+              };
+
+              port@3 {
+                reg = <3>;
+                label = "lan4";
+              };
+
+              port@4 {
+                reg = <4>;
+                label = "wan";
+              };
+
+              port@8 {
+                reg = <8>;
+                label = "cpu";
+
+                phy-mode = "rgmii";
+                ethernet = <&switch0port4>;
+
+                fixed-link {
+                  speed = <1000>;
+                  full-duplex;
+                };
+              };
+            };
+          };
+        };
+      };
+
+      ports {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        switch0port4: port@4 {
+          reg = <4>;
+          label = "extsw";
+
+          phy-mode = "rgmii";
+
+          fixed-link {
+            speed = <1000>;
+            full-duplex;
+          };
+        };
+
+        port@8 {
+          reg = <8>;
+
+          phy-mode = "internal";
+          ethernet = <&ethernet>;
+
+          fixed-link {
+            speed = <1000>;
+            full-duplex;
+          };
+        };
+      };
+    };
-- 
2.30.2

