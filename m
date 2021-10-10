Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D09F4281D4
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 16:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbhJJOZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 10:25:40 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:60116
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233000AbhJJOZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 10:25:31 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id BE2B63F044
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 14:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633875811;
        bh=ONDFWAF3Os4f+pjgFsy5pB3Qg13aS7WOCaakfyRRUkQ=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=bmf+It+Lv5rmH7YVUEfLV17+FhabRynBscSEgRSovOORfQKuCCdCCVk0MV+7aLQ5Q
         uYJe1zvj0RWuwsML2jaQK1aS2TiSZWrmJAvMum2jac+VoH4uUYFp5Km0Id3ufEGnJh
         M0TitLc170s5fi+a0dxGyEDG4aUmz6psq4dR9/VgB/NS32d9UTRjAXsd4gQJjhGJ7N
         nPIdp/2Ah1yypNTBgAMVK0vtN22VkXiYMPzo1mc4FJMOiXWPaAou7j/5saN2BoKyKg
         TRSm+FcGN+JkY6cuFjSf2grYGmyy4vpm6MU+5vdS0qm9nb6ac2+k79oChAW/tJbmhL
         GBnguC7F9Zsyw==
Received: by mail-ed1-f71.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso13403907edj.20
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 07:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ONDFWAF3Os4f+pjgFsy5pB3Qg13aS7WOCaakfyRRUkQ=;
        b=tcXF8/YSvVhBehFIXU5Ujxyl9sPnhNUEWINVCjSGbUQwIiOEt5uLjDM+7gQRdPzFag
         YjcL0/HI1UnbpXOvhlhhFQPKGAwGILrq++dKhawmiifGiycM1AZTzzmuEx1bX+ECRanH
         YaWYSwoG1cYr6p6JL/v80OZqhJQ/OZJralZOGXyp1mSoUNByi6hxt9VwBKiO7MtoQb1x
         vaXHXL210zD3D9gst7NjL6fzi8xPaOheAicsVUHWwPQG6mAazZT8k/5bU4zz4k+uILYM
         pCo0gBtOY2SxU7fdeSJVdgjC5Waw4hVJckxRkMMDgYU1b8mO28w4+cKa3PDlATEMuw3G
         NmqQ==
X-Gm-Message-State: AOAM533+3fCdSD7XR5eR7c/D9gLgQDQGFxN26I+r7esZ4BTNS97DOplI
        br+yp+0BbQUtdlMv7pDhMLarC1ZhTHejzkrJlsMLtTallaf8kN5lPiMVjcHlozW0fSRIHiyRbNA
        kZqk+p+LAwngujEXPCr78RlmvpaUnhHH0pQ==
X-Received: by 2002:a17:906:1451:: with SMTP id q17mr19043463ejc.214.1633875811148;
        Sun, 10 Oct 2021 07:23:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlSwwBZr023ecljsU2pQ+A6KOmi11yj/gJpFXKdoIY7MpnIneA4rpONBq3izjUZIE6KvWMpg==
X-Received: by 2002:a17:906:1451:: with SMTP id q17mr19043445ejc.214.1633875810951;
        Sun, 10 Oct 2021 07:23:30 -0700 (PDT)
Received: from localhost.localdomain (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id 6sm2129017ejx.82.2021.10.10.07.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 07:23:30 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Mark Greer <mgreer@animalcreek.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 5/7] dt-bindings: nfc: st,nci: convert to dtschema
Date:   Sun, 10 Oct 2021 16:23:15 +0200
Message-Id: <20211010142317.168259-5-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211010142317.168259-1-krzysztof.kozlowski@canonical.com>
References: <20211010142317.168259-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the ST NCI (ST21NFCB) NFC controller to DT schema format.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../bindings/net/nfc/st,st-nci.yaml           | 114 ++++++++++++++++++
 .../bindings/net/nfc/st-nci-i2c.txt           |  38 ------
 .../bindings/net/nfc/st-nci-spi.txt           |  36 ------
 3 files changed, 114 insertions(+), 74 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/st,st-nci.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/nfc/st-nci-i2c.txt
 delete mode 100644 Documentation/devicetree/bindings/net/nfc/st-nci-spi.txt

diff --git a/Documentation/devicetree/bindings/net/nfc/st,st-nci.yaml b/Documentation/devicetree/bindings/net/nfc/st,st-nci.yaml
new file mode 100644
index 000000000000..4486ae75f8a2
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/st,st-nci.yaml
@@ -0,0 +1,114 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/nfc/st,st-nci.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: STMicroelectronics ST NCI NFC controller
+
+maintainers:
+  - Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+
+properties:
+  compatible:
+    enum:
+      - st,st21nfcb-i2c
+      - st,st21nfcb-spi
+      - st,st21nfcc-i2c
+
+  clock-frequency: true
+
+  reset-gpios:
+    description: Output GPIO pin used for resetting the controller
+
+  ese-present:
+    type: boolean
+    description: |
+      Specifies that an ese is physically connected to the controller
+
+  interrupts:
+    maxItems: 1
+
+  reg:
+    maxItems: 1
+
+  spi-max-frequency: true
+
+  uicc-present:
+    type: boolean
+    description: |
+      Specifies that the uicc swp signal can be physically connected to the
+      controller
+
+required:
+  - compatible
+  - interrupts
+  - reg
+  - reset-gpios
+
+if:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - st,st21nfcb-i2c
+          - st,st21nfcc-i2c
+then:
+  properties:
+    spi-max-frequency: false
+  required:
+    - clock-frequency
+else:
+  properties:
+    clock-frequency: false
+  required:
+    - spi-max-frequency
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
+        nfc@8 {
+            compatible = "st,st21nfcb-i2c";
+            reg = <0x08>;
+
+            clock-frequency = <400000>;
+
+            interrupt-parent = <&gpio5>;
+            interrupts = <2 IRQ_TYPE_LEVEL_HIGH>;
+            reset-gpios = <&gpio5 29 GPIO_ACTIVE_HIGH>;
+
+            ese-present;
+            uicc-present;
+        };
+    };
+
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    spi {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        nfc@0 {
+            compatible = "st,st21nfcb-spi";
+            reg = <0>;
+
+            spi-max-frequency = <4000000>;
+
+            interrupt-parent = <&gpio5>;
+            interrupts = <2 IRQ_TYPE_EDGE_RISING>;
+            reset-gpios = <&gpio5 29 GPIO_ACTIVE_HIGH>;
+
+            ese-present;
+            uicc-present;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/net/nfc/st-nci-i2c.txt b/Documentation/devicetree/bindings/net/nfc/st-nci-i2c.txt
deleted file mode 100644
index baa8f8133d19..000000000000
--- a/Documentation/devicetree/bindings/net/nfc/st-nci-i2c.txt
+++ /dev/null
@@ -1,38 +0,0 @@
-* STMicroelectronics SAS. ST NCI NFC Controller
-
-Required properties:
-- compatible: Should be "st,st21nfcb-i2c" or "st,st21nfcc-i2c".
-- clock-frequency: I²C work frequency.
-- reg: address on the bus
-- interrupts: GPIO interrupt to which the chip is connected
-- reset-gpios: Output GPIO pin used to reset the ST21NFCB
-
-Optional SoC Specific Properties:
-- pinctrl-names: Contains only one value - "default".
-- pintctrl-0: Specifies the pin control groups used for this controller.
-- ese-present: Specifies that an ese is physically connected to the nfc
-controller.
-- uicc-present: Specifies that the uicc swp signal can be physically
-connected to the nfc controller.
-
-Example (for ARM-based BeagleBoard xM with ST21NFCB on I2C2):
-
-&i2c2 {
-
-
-	st21nfcb: st21nfcb@8 {
-
-		compatible = "st,st21nfcb-i2c";
-
-		reg = <0x08>;
-		clock-frequency = <400000>;
-
-		interrupt-parent = <&gpio5>;
-		interrupts = <2 IRQ_TYPE_LEVEL_HIGH>;
-
-		reset-gpios = <&gpio5 29 GPIO_ACTIVE_HIGH>;
-
-		ese-present;
-		uicc-present;
-	};
-};
diff --git a/Documentation/devicetree/bindings/net/nfc/st-nci-spi.txt b/Documentation/devicetree/bindings/net/nfc/st-nci-spi.txt
deleted file mode 100644
index d33343330b94..000000000000
--- a/Documentation/devicetree/bindings/net/nfc/st-nci-spi.txt
+++ /dev/null
@@ -1,36 +0,0 @@
-* STMicroelectronics SAS. ST NCI NFC Controller
-
-Required properties:
-- compatible: Should be "st,st21nfcb-spi"
-- spi-max-frequency: Maximum SPI frequency (<= 4000000).
-- interrupts: GPIO interrupt to which the chip is connected
-- reset-gpios: Output GPIO pin used to reset the ST21NFCB
-
-Optional SoC Specific Properties:
-- pinctrl-names: Contains only one value - "default".
-- pintctrl-0: Specifies the pin control groups used for this controller.
-- ese-present: Specifies that an ese is physically connected to the nfc
-controller.
-- uicc-present: Specifies that the uicc swp signal can be physically
-connected to the nfc controller.
-
-Example (for ARM-based BeagleBoard xM with ST21NFCB on SPI4):
-
-&mcspi4 {
-
-
-	st21nfcb: st21nfcb@0 {
-
-		compatible = "st,st21nfcb-spi";
-
-		clock-frequency = <4000000>;
-
-		interrupt-parent = <&gpio5>;
-		interrupts = <2 IRQ_TYPE_EDGE_RISING>;
-
-		reset-gpios = <&gpio5 29 GPIO_ACTIVE_HIGH>;
-
-		ese-present;
-		uicc-present;
-	};
-};
-- 
2.30.2

