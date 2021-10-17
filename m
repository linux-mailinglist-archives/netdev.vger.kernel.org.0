Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F048D430A7A
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 18:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242587AbhJQQV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 12:21:59 -0400
Received: from ixit.cz ([94.230.151.217]:43496 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242581AbhJQQV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 12:21:59 -0400
Received: from localhost.localdomain (ip-89-176-96-70.net.upcbroadband.cz [89.176.96.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 7314224E6C;
        Sun, 17 Oct 2021 18:03:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1634486621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ulq8xD8DTGiFupvcK4aBfnwNO5UWy6Ky14vpXrwkpkU=;
        b=kKs0wjIfYAFvOHJ1qjN5bwbjbZFop/yPMWHpnhwjTdf3Pr5PRuhIgRCY04N66srkInMSap
        0oh0nkwQAa4eRz3SUwQ/EXmRpcIDWMDk9py1yPYxlAAxXrWuT15CI8fJGxU5vI8Zvbg+ir
        NOi0N0lO5hFAWVjUPCOoFAq2iHIe6A4=
From:   David Heidelberg <david@ixit.cz>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ~okias/devicetree@lists.sr.ht,
        David Heidelberg <david@ixit.cz>
Subject: [PATCH v4] dt-bindings: net: nfc: nxp,pn544: Convert txt bindings to yaml
Date:   Sun, 17 Oct 2021 18:02:10 +0200
Message-Id: <20211017160210.85543-1-david@ixit.cz>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert bindings for NXP PN544 NFC driver to YAML syntax.

Signed-off-by: David Heidelberg <david@ixit.cz>
---
v2
 - Krzysztof is a maintainer
 - pintctrl dropped
 - 4 space indent for example
 - nfc node name
v3
 - remove whole pinctrl
v4
 - drop clock-frequency, which is inherited by i2c bus

 .../bindings/net/nfc/nxp,pn544.yaml           | 56 +++++++++++++++++++
 .../devicetree/bindings/net/nfc/pn544.txt     | 33 -----------
 2 files changed, 56 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/nfc/pn544.txt

diff --git a/Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml b/Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
new file mode 100644
index 000000000000..4592d1194a71
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
@@ -0,0 +1,56 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/nfc/nxp,pn544.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP Semiconductors PN544 NFC Controller
+
+maintainers:
+  - Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+
+properties:
+  compatible:
+    const: nxp,pn544-i2c
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  enable-gpios:
+    description: Output GPIO pin used for enabling/disabling the PN544
+
+  firmware-gpios:
+    description: Output GPIO pin used to enter firmware download mode
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - enable-gpios
+  - firmware-gpios
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    i2c {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        nfc@28 {
+            compatible = "nxp,pn544-i2c";
+            reg = <0x28>;
+
+            interrupt-parent = <&gpio1>;
+            interrupts = <17 IRQ_TYPE_LEVEL_HIGH>;
+
+            enable-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
+            firmware-gpios = <&gpio3 19 GPIO_ACTIVE_HIGH>;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/net/nfc/pn544.txt b/Documentation/devicetree/bindings/net/nfc/pn544.txt
deleted file mode 100644
index 2bd82562ce8e..000000000000
--- a/Documentation/devicetree/bindings/net/nfc/pn544.txt
+++ /dev/null
@@ -1,33 +0,0 @@
-* NXP Semiconductors PN544 NFC Controller
-
-Required properties:
-- compatible: Should be "nxp,pn544-i2c".
-- clock-frequency: I²C work frequency.
-- reg: address on the bus
-- interrupts: GPIO interrupt to which the chip is connected
-- enable-gpios: Output GPIO pin used for enabling/disabling the PN544
-- firmware-gpios: Output GPIO pin used to enter firmware download mode
-
-Optional SoC Specific Properties:
-- pinctrl-names: Contains only one value - "default".
-- pintctrl-0: Specifies the pin control groups used for this controller.
-
-Example (for ARM-based BeagleBone with PN544 on I2C2):
-
-&i2c2 {
-
-
-	pn544: pn544@28 {
-
-		compatible = "nxp,pn544-i2c";
-
-		reg = <0x28>;
-		clock-frequency = <400000>;
-
-		interrupt-parent = <&gpio1>;
-		interrupts = <17 IRQ_TYPE_LEVEL_HIGH>;
-
-		enable-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
-		firmware-gpios = <&gpio3 19 GPIO_ACTIVE_HIGH>;
-	};
-};
-- 
2.33.0

