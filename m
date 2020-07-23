Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B5022AA82
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 10:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgGWIRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 04:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbgGWIRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 04:17:37 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489B5C0619DC;
        Thu, 23 Jul 2020 01:17:37 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595492254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dnjGn/AU+fRt0hpW+UXz0JagirHdk28DLXmyBPvv19g=;
        b=SEypb57nnN9grdWOCwBey1cyuVRmJlRal2ROTB5aswjCEu1mPmntswo2YLn5NmuV/0k3Tl
        ndB8TEi/P79y8k+1LnAgVnQqW9LXnA+WdOZvs0nFr0CqwsuObs379PGOW3SjfsAtG1Pf4Y
        bCO3mONcOkFlETuiu83gQsi5v7Bh2L63ixczpiXiEhnPTF63uzPeJoFV52+0PAculJt5BZ
        Vd5CrmcxdaJiJ5Z6IslUESBpAb9Shc2spxemo5SikoS8eeIZdGIo1DxtwIhkmdQcKnL9xP
        NO17+7z7Ec+zsjpyy31pxugIUexT45rjihE/FBvZPZQTaPfsaVRj+/un389qew==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595492254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dnjGn/AU+fRt0hpW+UXz0JagirHdk28DLXmyBPvv19g=;
        b=KC9+afCPXnPf+iSA8Pa91xafcnq3pwkZiqpEKhzJujnbmi5PJdIep+nAxj+tloi6nRzxqj
        4/t+cWcd67ePIKBw==
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
Subject: [PATCH v2 8/8] dt-bindings: net: dsa: Add documentation for Hellcreek switches
Date:   Thu, 23 Jul 2020 10:17:14 +0200
Message-Id: <20200723081714.16005-9-kurt@linutronix.de>
In-Reply-To: <20200723081714.16005-1-kurt@linutronix.de>
References: <20200723081714.16005-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic documentation and example.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 .../bindings/net/dsa/hellcreek.yaml           | 126 ++++++++++++++++++
 1 file changed, 126 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/hellcreek.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
new file mode 100644
index 000000000000..1b192ba7f4ca
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
@@ -0,0 +1,126 @@
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
+  - Kurt Kanzenbach <kurt@linutronix.de>
+
+description:
+  The Hellcreek TSN Switch IP is a 802.1Q Ethernet compliant switch. It supports
+  the Precision Time Protocol, Hardware Timestamping as well the Time Aware
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
+    minItems: 2
+    maxItems: 2
+
+  reg-names:
+    description:
+      Names of the physical base addresses
+    minItems: 2
+    maxItems: 2
+    items:
+      enum: ["reg", "ptp"]
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
+            label: true
+
+            default-state: true
+
+          required:
+            - reg
+
+          additionalProperties: false
+
+required:
+  - compatible
+  - reg
+  - reg-names
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

