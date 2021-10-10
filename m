Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E2F4281D5
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 16:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhJJOZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 10:25:42 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:45416
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233030AbhJJOZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 10:25:33 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 297BA40017
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 14:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633875814;
        bh=sEh5KUYuxEm3bzH5hsUc+ps6L/VdQWx+zLSKJvPfz9w=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=VyZZtcASe1pO0P0rxz7P52CCOO7yZRO6uVw+boMSt57xIVSaPAfNu+MB1wtm3Gyu4
         t+5AyxUWrKZB7BfhPtUgm+Elyf2JhUjuQNT0uc0i18BChkG8RJcmMc+37DIUbPu34G
         jWhm9ctI6QBv9Q83L2EAtgmiZxXOoB5Dr70prdCb4tFDMrGg8brzIQdy12gokrp2ju
         NmuBNbxfwGGqwuMQzDeBLRBR9FnzwbeujgY8nIZDGcRF7rsYCQ8im8CUP1GAFK4IqX
         AteorF92Eo1imfVsX4zq+PsP2ryVzb3M0y1tMUXv3dHG0Ve25jiafwbVbSFvzyZrqr
         6cNtVSKySkPdQ==
Received: by mail-ed1-f69.google.com with SMTP id u23-20020a50a417000000b003db23c7e5e2so13481398edb.8
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 07:23:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sEh5KUYuxEm3bzH5hsUc+ps6L/VdQWx+zLSKJvPfz9w=;
        b=QhNmMaIRWSMn2RIXJu44R3CnABw45QhFSno43yp68TVN2LydyCNREX6Z/mHVxFZtCm
         zBWqlIm66+wZKvAOg5wJaLITMBZgYW/kVXh5f/lLXxf5RvJt/Zl0Bw8Vt6FIxTXil9US
         hJoK6rSa/9eaB63KqDHvJMSzrPj8HmjjNpEZ03iHn03S5tpSLH+zbVO8hEyA0sL6N+CS
         jVAlRLjVUNsLx7oYGwLJbjwFRV90HGlGU/csW2A8ypdnyboDRjgxf9rRSFM+1np1WOfD
         nKg5aCKs3o8P3IyxUBwLnkDYutx391gunFlroTyYxNpl47un4Wo5xvb6pHjBXXDg5pIi
         qVgA==
X-Gm-Message-State: AOAM531F0Yrsm5xUcSTg/tQPfX44IN2gLCbjd305F+Hrl/lQHQ4ozHHg
        FJHbwCGG3nUmyBjP8//JgCsrBTNXBIPJYCJJGehYBKGSvpVlOcI2J0oVlb03UjWIJgHBH9HW3DJ
        TUDcEOrgiJ7dq3EPXmpoF8T7chg4PjYznCQ==
X-Received: by 2002:a05:6402:4402:: with SMTP id y2mr24480380eda.222.1633875813782;
        Sun, 10 Oct 2021 07:23:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSm8Z9KjucD039kn/b+DLN9Na+qvLcx4ZvjArJNxoedCFKyLu8nt+Jwvf6H9WcO3menFHzzw==
X-Received: by 2002:a05:6402:4402:: with SMTP id y2mr24480345eda.222.1633875813587;
        Sun, 10 Oct 2021 07:23:33 -0700 (PDT)
Received: from localhost.localdomain (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id 6sm2129017ejx.82.2021.10.10.07.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 07:23:33 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Mark Greer <mgreer@animalcreek.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 7/7] dt-bindings: nfc: marvell,nfc: convert to dtschema
Date:   Sun, 10 Oct 2021 16:23:17 +0200
Message-Id: <20211010142317.168259-7-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211010142317.168259-1-krzysztof.kozlowski@canonical.com>
References: <20211010142317.168259-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Marvell NCI NFC controller to DT schema format.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../bindings/net/nfc/marvell,nci.yaml         | 170 ++++++++++++++++++
 .../devicetree/bindings/net/nfc/nfcmrvl.txt   |  84 ---------
 2 files changed, 170 insertions(+), 84 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/nfc/nfcmrvl.txt

diff --git a/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml b/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml
new file mode 100644
index 000000000000..15a45db3899a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml
@@ -0,0 +1,170 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/nfc/marvell,nci.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Marvell International Ltd. NCI NFC controller
+
+maintainers:
+  - Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+
+properties:
+  compatible:
+    enum:
+      - marvell,nfc-i2c
+      - marvell,nfc-spi
+      - marvell,nfc-uart
+
+  hci-muxed:
+    type: boolean
+    description: |
+      Specifies that the chip is muxing NCI over HCI frames
+
+  interrupts:
+    maxItems: 1
+
+  reg:
+    maxItems: 1
+
+  reset-n-io:
+    $ref: "/schemas/types.yaml#/definitions/phandle-array"
+    maxItems: 1
+    description: |
+      Output GPIO pin used to reset the chip (active low)
+
+  i2c-int-falling:
+    type: boolean
+    description: |
+      For I2C type of connection. Specifies that the chip read event shall be
+      trigged on falling edge.
+
+  i2c-int-rising:
+    type: boolean
+    description: |
+      For I2C type of connection.  Specifies that the chip read event shall be
+      trigged on rising edge.
+
+  break-control:
+    type: boolean
+    description: |
+      For UART type of connection. Specifies that the chip needs specific break
+      management.
+
+  flow-control:
+    type: boolean
+    description: |
+      For UART type of connection. Specifies that the chip is using RTS/CTS.
+
+  spi-cpha: true
+  spi-cpol: true
+  spi-max-frequency: true
+
+required:
+  - compatible
+
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: marvell,nfc-i2c
+    then:
+      properties:
+        break-control: false
+        flow-control: false
+        spi-cpha: false
+        spi-cpol: false
+        spi-max-frequency: false
+      required:
+        - reg
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: marvell,nfc-spi
+    then:
+      properties:
+        break-control: false
+        flow-control: false
+        i2c-int-falling: false
+        i2c-int-rising: false
+      required:
+        - reg
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: marvell,nfc-uart
+    then:
+      properties:
+        i2c-int-falling: false
+        i2c-int-rising: false
+        interrupts: false
+        spi-cpha: false
+        spi-cpol: false
+        spi-max-frequency: false
+        reg: false
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
+            compatible = "marvell,nfc-i2c";
+            reg = <0x8>;
+
+            interrupt-parent = <&gpio3>;
+            interrupts = <21 IRQ_TYPE_EDGE_RISING>;
+
+            i2c-int-rising;
+
+            reset-n-io = <&gpio3 19 GPIO_ACTIVE_HIGH>;
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
+            compatible = "marvell,nfc-spi";
+            reg = <0>;
+
+            spi-max-frequency = <3000000>;
+            spi-cpha;
+            spi-cpol;
+
+            interrupt-parent = <&gpio1>;
+            interrupts = <17 IRQ_TYPE_EDGE_RISING>;
+
+            reset-n-io = <&gpio3 19 GPIO_ACTIVE_HIGH>;
+        };
+    };
+
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+
+    uart {
+        nfc {
+            compatible = "marvell,nfc-uart";
+
+            reset-n-io = <&gpio3 16 GPIO_ACTIVE_HIGH>;
+
+            hci-muxed;
+            flow-control;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/net/nfc/nfcmrvl.txt b/Documentation/devicetree/bindings/net/nfc/nfcmrvl.txt
deleted file mode 100644
index c9b35251bb20..000000000000
--- a/Documentation/devicetree/bindings/net/nfc/nfcmrvl.txt
+++ /dev/null
@@ -1,84 +0,0 @@
-* Marvell International Ltd. NCI NFC Controller
-
-Required properties:
-- compatible: Should be:
-  - "marvell,nfc-uart" or "mrvl,nfc-uart" for UART devices
-  - "marvell,nfc-i2c" for I2C devices
-  - "marvell,nfc-spi" for SPI devices
-
-Optional SoC specific properties:
-- pinctrl-names: Contains only one value - "default".
-- pintctrl-0: Specifies the pin control groups used for this controller.
-- reset-n-io: Output GPIO pin used to reset the chip (active low).
-- hci-muxed: Specifies that the chip is muxing NCI over HCI frames.
-
-Optional UART-based chip specific properties:
-- flow-control: Specifies that the chip is using RTS/CTS.
-- break-control: Specifies that the chip needs specific break management.
-
-Optional I2C-based chip specific properties:
-- i2c-int-falling: Specifies that the chip read event shall be trigged on
-  		   falling edge.
-- i2c-int-rising: Specifies that the chip read event shall be trigged on
-  		  rising edge.
-
-Example (for ARM-based BeagleBoard Black with 88W8887 on UART5):
-
-&uart5 {
-
-	nfcmrvluart: nfcmrvluart@5 {
-		compatible = "marvell,nfc-uart";
-
-		reset-n-io = <&gpio3 16 0>;
-
-		hci-muxed;
-		flow-control;
-        }
-};
-
-
-Example (for ARM-based BeagleBoard Black with 88W8887 on I2C1):
-
-&i2c1 {
-	clock-frequency = <400000>;
-
-	nfcmrvli2c0: i2c@1 {
-		compatible = "marvell,nfc-i2c";
-
-		reg = <0x8>;
-
-		/* I2C INT configuration */
-		interrupt-parent = <&gpio3>;
-		interrupts = <21 0>;
-
-		/* I2C INT trigger configuration */
-		i2c-int-rising;
-
-		/* Reset IO */
-		reset-n-io = <&gpio3 19 0>;
-	};
-};
-
-
-Example (for ARM-based BeagleBoard Black on SPI0):
-
-&spi0 {
-
-	mrvlnfcspi0: spi@0 {
-		compatible = "marvell,nfc-spi";
-
-		reg = <0>;
-
-		/* SPI Bus configuration */
-		spi-max-frequency = <3000000>;
-		spi-cpha;
-		spi-cpol;
-
-		/* SPI INT configuration */
-		interrupt-parent = <&gpio1>;
-		interrupts = <17 0>;
-
-		/* Reset IO */
-       		reset-n-io = <&gpio3 19 0>;
-	};
-};
-- 
2.30.2

