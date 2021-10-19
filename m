Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9156B433640
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbhJSMpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235714AbhJSMpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 08:45:36 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B01AC061749
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 05:43:22 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:b4c3:ba80:54db:46f])
        by albert.telenet-ops.be with bizsmtp
        id 7ojF2600S12AN0U06ojFsy; Tue, 19 Oct 2021 14:43:21 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mcoSZ-0069O6-Dh; Tue, 19 Oct 2021 14:43:15 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mcoSY-00EESt-I4; Tue, 19 Oct 2021 14:43:14 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        David Lechner <david@lechnology.com>,
        Sebastian Reichel <sre@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 3/3] dt-bindings: net: ti,bluetooth: Convert to json-schema
Date:   Tue, 19 Oct 2021 14:43:13 +0200
Message-Id: <c1814db9aff7f09ea41b562a2da305312d8df2dd.1634646975.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1634646975.git.geert+renesas@glider.be>
References: <cover.1634646975.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Texas Instruments serial-attached bluetooth Device Tree
binding documentation to json-schema.

Add missing max-speed property.
Update the example.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
I listed David as maintainer, as he wrote the original bindings.
Please scream if not appropriate.
---
 .../devicetree/bindings/net/ti,bluetooth.yaml | 91 +++++++++++++++++++
 .../devicetree/bindings/net/ti-bluetooth.txt  | 60 ------------
 2 files changed, 91 insertions(+), 60 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ti,bluetooth.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/ti-bluetooth.txt

diff --git a/Documentation/devicetree/bindings/net/ti,bluetooth.yaml b/Documentation/devicetree/bindings/net/ti,bluetooth.yaml
new file mode 100644
index 0000000000000000..9f6102977c9732d2
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ti,bluetooth.yaml
@@ -0,0 +1,91 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ti,bluetooth.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Texas Instruments Bluetooth Chips
+
+maintainers:
+  - David Lechner <david@lechnology.com>
+
+description: |
+  This documents the binding structure and common properties for serial
+  attached TI Bluetooth devices. The following chips are included in this
+  binding:
+
+  * TI CC256x Bluetooth devices
+  * TI WiLink 7/8 (wl12xx/wl18xx) Shared Transport BT/FM/GPS devices
+
+  TI WiLink devices have a UART interface for providing Bluetooth, FM radio,
+  and GPS over what's called "shared transport". The shared transport is
+  standard BT HCI protocol with additional channels for the other functions.
+
+  TI WiLink devices also have a separate WiFi interface as described in
+  wireless/ti,wlcore.yaml.
+
+  This bindings follows the UART slave device binding in ../serial/serial.yaml.
+
+properties:
+  compatible:
+    enum:
+      - ti,cc2560
+      - ti,wl1271-st
+      - ti,wl1273-st
+      - ti,wl1281-st
+      - ti,wl1283-st
+      - ti,wl1285-st
+      - ti,wl1801-st
+      - ti,wl1805-st
+      - ti,wl1807-st
+      - ti,wl1831-st
+      - ti,wl1835-st
+      - ti,wl1837-st
+
+  enable-gpios:
+    maxItems: 1
+
+  vio-supply:
+    description: Vio input supply (1.8V)
+
+  vbat-supply:
+    description: Vbat input supply (2.9-4.8V)
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: ext_clock
+
+  max-speed: true
+
+  nvmem-cells:
+    maxItems: 1
+    description:
+      Nvmem data cell that contains a 6 byte BD address with the most
+      significant byte first (big-endian).
+
+  nvmem-cell-names:
+    items:
+      - const: bd-address
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+
+    serial {
+            bluetooth {
+                    compatible = "ti,wl1835-st";
+                    enable-gpios = <&gpio1 7 GPIO_ACTIVE_HIGH>;
+                    clocks = <&clk32k_wl18xx>;
+                    clock-names = "ext_clock";
+                    nvmem-cells = <&bd_address>;
+                    nvmem-cell-names = "bd-address";
+            };
+    };
diff --git a/Documentation/devicetree/bindings/net/ti-bluetooth.txt b/Documentation/devicetree/bindings/net/ti-bluetooth.txt
deleted file mode 100644
index 3c01cfc1e12dc132..0000000000000000
--- a/Documentation/devicetree/bindings/net/ti-bluetooth.txt
+++ /dev/null
@@ -1,60 +0,0 @@
-Texas Instruments Bluetooth Chips
----------------------------------
-
-This documents the binding structure and common properties for serial
-attached TI Bluetooth devices. The following chips are included in this
-binding:
-
-* TI CC256x Bluetooth devices
-* TI WiLink 7/8 (wl12xx/wl18xx) Shared Transport BT/FM/GPS devices
-
-TI WiLink devices have a UART interface for providing Bluetooth, FM radio,
-and GPS over what's called "shared transport". The shared transport is
-standard BT HCI protocol with additional channels for the other functions.
-
-TI WiLink devices also have a separate WiFi interface as described in
-wireless/ti,wlcore.yaml.
-
-This bindings follows the UART slave device binding in ../serial/serial.yaml.
-
-Required properties:
- - compatible: should be one of the following:
-    "ti,cc2560"
-    "ti,wl1271-st"
-    "ti,wl1273-st"
-    "ti,wl1281-st"
-    "ti,wl1283-st"
-    "ti,wl1285-st"
-    "ti,wl1801-st"
-    "ti,wl1805-st"
-    "ti,wl1807-st"
-    "ti,wl1831-st"
-    "ti,wl1835-st"
-    "ti,wl1837-st"
-
-Optional properties:
- - enable-gpios : GPIO signal controlling enabling of BT. Active high.
- - vio-supply : Vio input supply (1.8V)
- - vbat-supply : Vbat input supply (2.9-4.8V)
- - clocks : Must contain an entry, for each entry in clock-names.
-   See ../clocks/clock-bindings.txt for details.
- - clock-names : Must include the following entry:
-   "ext_clock" (External clock provided to the TI combo chip).
- - nvmem-cells: phandle to nvmem data cell that contains a 6 byte BD address
-   with the most significant byte first (big-endian).
- - nvmem-cell-names: "bd-address" (required when nvmem-cells is specified)
-
-Example:
-
-&serial0 {
-	compatible = "ns16550a";
-	...
-	bluetooth {
-		compatible = "ti,wl1835-st";
-		enable-gpios = <&gpio1 7 GPIO_ACTIVE_HIGH>;
-		clocks = <&clk32k_wl18xx>;
-		clock-names = "ext_clock";
-		nvmem-cells = <&bd_address>;
-		nvmem-cell-names = "bd-address";
-	};
-};
-- 
2.25.1

