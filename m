Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CD421B41B
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 13:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgGJLgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 07:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728098AbgGJLgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 07:36:35 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC35C08E763;
        Fri, 10 Jul 2020 04:36:34 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594380993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qVwjHtWGfQEymI42xswgbLLssGllrLxNhmwD9iS8ZHc=;
        b=eif+J+dHEMYqsIc14jVZfW/GevMwxqa8BSYzd22PFHfzjzGciQ9foDRAuBULuS0lCmgteq
        3RpbB0r4hlrE9BbAWYDPcc6RxciA9zA20sYxPZ8fwqq4uvbECd/A9QZYzOmBBkQT96z+xg
        fXnJOg5v77mGF8u7hvevMxGGKzV8ZDHzAO4Lpq1VfLzl958S7jlY3Wumnp/90wN5UuNYwV
        rpInVZ/ZBnSX5y8McmsbTvxD6b4ba7ADXNcafPePGZ5r5B9gKqyJy8Zd0DUy6iB4w6OSNe
        7JAqI6D8BXRxZJUjWpIIj01BHaWwTnKcHyrJM0H6wQSOuCVdkL/BrNQPjiBPqg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594380993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qVwjHtWGfQEymI42xswgbLLssGllrLxNhmwD9iS8ZHc=;
        b=azW9jjQD8mwO040/NHQITW4NiU+doJw4UQt2mVDOwrGnn4wWtl/NP3+119XKfkWWSW5MHD
        kr3SovmHpFppQcBg==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v1 8/8] dt-bindings: net: dsa: Add documentation for Hellcreek switches
Date:   Fri, 10 Jul 2020 13:36:11 +0200
Message-Id: <20200710113611.3398-9-kurt@linutronix.de>
In-Reply-To: <20200710113611.3398-1-kurt@linutronix.de>
References: <20200710113611.3398-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic documentation and example.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 .../bindings/net/dsa/hellcreek.yaml           | 132 ++++++++++++++++++
 1 file changed, 132 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/hellcreek.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
new file mode 100644
index 000000000000..bb8ccc1762c8
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
@@ -0,0 +1,132 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/hellcreek.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Hirschmann Hellcreek TSN Switch Device Tree Bindings
+
+allOf:
+  - $ref: dsa.yaml#
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Vivien Didelot <vivien.didelot@gmail.com>
+
+description:
+  The Hellcreek TSN Switch IP is a 802.1Q Ethernet compliant switch. It supports
+  the Pricision Time Protocol, Hardware Timestamping as well the Time Aware
+  Shaper.
+
+properties:
+  compatible:
+    oneOf:
+      - const: hirschmann,hellcreek
+
+  reg:
+    description:
+      The physical base address and size of TSN and PTP memory base
+
+  reg-names:
+    description:
+      Names of the physical base addresses
+
+  '#address-cells':
+    const: 1
+
+  '#size-cells':
+    const: 1
+
+  leds:
+    type: object
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      "^led@[0-9]+$":
+          type: object
+          description: Hellcreek leds
+
+          properties:
+            reg:
+              items:
+                - enum: [0, 1]
+              description: Led number
+
+            label:
+              description: Label associated with this led
+              $ref: /schemas/types.yaml#/definitions/string
+
+            default-state:
+              items:
+                enum: ["on", "off", "keep"]
+              description: Default state for the led
+              $ref: /schemas/types.yaml#/definitions/string
+
+          required:
+            - reg
+
+required:
+  - compatible
+  - reg
+  - '#address-cells'
+  - '#size-cells'
+  - ports
+  - leds
+
+examples:
+  - |
+        switch0: switch@ff240000 {
+            compatible = "hirschmann,hellcreek";
+            status = "okay";
+            reg = <0xff240000 0x1000>,
+                  <0xff250000 0x1000>;
+            reg-names = "reg", "ptp";
+            #address-cells = <1>;
+            #size-cells = <1>;
+            dsa,member = <0 0>;
+
+            ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                    reg = <0>;
+                    label = "cpu";
+                    ethernet = <&gmac0>;
+                };
+
+                port@2 {
+                    reg = <2>;
+                    label = "lan0";
+                    phy-handle = <&phy1>;
+                };
+
+                port@3 {
+                    reg = <3>;
+                    label = "lan1";
+                    phy-handle = <&phy2>;
+                };
+            };
+
+            leds {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                led@0 {
+                    reg = <0>;
+                    label = "sync_good";
+                    default-state = "on";
+                };
+
+                led@1 {
+                    reg = <1>;
+                    label = "is_gm";
+                    default-state = "off";
+                };
+            };
+        };
-- 
2.20.1

