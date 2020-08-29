Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED34256842
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 16:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgH2O37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 10:29:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728012AbgH2O35 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 10:29:57 -0400
Received: from localhost.localdomain (unknown [194.230.155.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1125206C0;
        Sat, 29 Aug 2020 14:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598711396;
        bh=+r594Mll/9YuTOqi3UrI/hCezf7xrKr/GY6GKpDqTCw=;
        h=From:To:Cc:Subject:Date:From;
        b=Rc7P51Xbp8wfp1EbyQwhCBLsD74s5v2H17QUdDJFuMJVOJtjDXKiGtSwcXVkAhwYH
         7tMAEQiutEDfnBU455F7+7IpXTWSkfPkAsLl5EOp7S9cXhY3mDAiEKUZCFpuPQziHl
         SP5vbQ3isjClTnmaZgEeDHbMFzvaqI3eswUXJbCE=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 1/4] dt-bindings: net: nfc: s3fwrn5: Convert to dtschema
Date:   Sat, 29 Aug 2020 16:29:45 +0200
Message-Id: <20200829142948.32365-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Samsung S3FWRN5 NCI NFC controller bindings to dtschema.
This is conversion only so it includes properties with invalid prefixes
(s3fwrn5,en-gpios) which should be addressed later.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 .../devicetree/bindings/net/nfc/s3fwrn5.txt   | 25 --------
 .../devicetree/bindings/net/nfc/s3fwrn5.yaml  | 59 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 3 files changed, 60 insertions(+), 25 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/nfc/s3fwrn5.txt
 create mode 100644 Documentation/devicetree/bindings/net/nfc/s3fwrn5.yaml

diff --git a/Documentation/devicetree/bindings/net/nfc/s3fwrn5.txt b/Documentation/devicetree/bindings/net/nfc/s3fwrn5.txt
deleted file mode 100644
index f02f6fb7f81c..000000000000
--- a/Documentation/devicetree/bindings/net/nfc/s3fwrn5.txt
+++ /dev/null
@@ -1,25 +0,0 @@
-* Samsung S3FWRN5 NCI NFC Controller
-
-Required properties:
-- compatible: Should be "samsung,s3fwrn5-i2c".
-- reg: address on the bus
-- interrupts: GPIO interrupt to which the chip is connected
-- s3fwrn5,en-gpios: Output GPIO pin used for enabling/disabling the chip
-- s3fwrn5,fw-gpios: Output GPIO pin used to enter firmware mode and
-  sleep/wakeup control
-
-Example:
-
-&hsi2c_4 {
-	s3fwrn5@27 {
-		compatible = "samsung,s3fwrn5-i2c";
-
-		reg = <0x27>;
-
-		interrupt-parent = <&gpa1>;
-		interrupts = <3 0 0>;
-
-		s3fwrn5,en-gpios = <&gpf1 4 0>;
-		s3fwrn5,fw-gpios = <&gpj0 2 0>;
-	};
-};
diff --git a/Documentation/devicetree/bindings/net/nfc/s3fwrn5.yaml b/Documentation/devicetree/bindings/net/nfc/s3fwrn5.yaml
new file mode 100644
index 000000000000..c22451dea350
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/s3fwrn5.yaml
@@ -0,0 +1,59 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/nfc/s3fwrn5.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Samsung S3FWRN5 NCI NFC Controller
+
+maintainers:
+  - Krzysztof Kozlowski <krzk@kernel.org>
+  - Krzysztof Opasiak <k.opasiak@samsung.com>
+
+properties:
+  compatible:
+    const: samsung,s3fwrn5-i2c
+
+  interrupts:
+    maxItems: 1
+
+  reg:
+    maxItems: 1
+
+  s3fwrn5,en-gpios:
+    maxItems: 1
+    description:
+      Output GPIO pin used for enabling/disabling the chip
+
+  s3fwrn5,fw-gpios:
+    maxItems: 1
+    description:
+      Output GPIO pin used to enter firmware mode and sleep/wakeup control
+
+required:
+  - compatible
+  - interrupts
+  - reg
+  - s3fwrn5,en-gpios
+  - s3fwrn5,fw-gpios
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    i2c4 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        s3fwrn5@27 {
+            compatible = "samsung,s3fwrn5-i2c";
+            reg = <0x27>;
+
+            interrupt-parent = <&gpa1>;
+            interrupts = <3 IRQ_TYPE_LEVEL_HIGH>;
+
+            s3fwrn5,en-gpios = <&gpf1 4 GPIO_ACTIVE_HIGH>;
+            s3fwrn5,fw-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index ac79fdbdf8d0..91b3d5c349d8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15273,6 +15273,7 @@ M:	Robert Baldyga <r.baldyga@samsung.com>
 M:	Krzysztof Opasiak <k.opasiak@samsung.com>
 L:	linux-nfc@lists.01.org (moderated for non-subscribers)
 S:	Supported
+F:	Documentation/devicetree/bindings/net/nfc/s3fwrn5.yaml
 F:	drivers/nfc/s3fwrn5
 
 SAMSUNG S5C73M3 CAMERA DRIVER
-- 
2.17.1

