Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4424287DE
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 09:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbhJKHmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 03:42:01 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:43826
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234592AbhJKHlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 03:41:52 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6F0BE3FFF0
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 07:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633937991;
        bh=p7DB9CXnt9jgmm22VXqbPUHJTzgACaTPyFxSkRyfsXw=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=CBNa5RG579jyed4g5wgG+Kb5Zk3cKj+ZAiDN0hP75nMhZ+SsEppkX+DuBLkuofkIS
         D4pv+q+rWddFxmflTVWGcA0TGzQYaVbOczxi9sSWbEuRkKyNlRVq/Wfynzds4ZyD4e
         h//3Ax19MUMcngAkthibgCMXIyl3aS86/N7qBbyEDS6+ztK9wqTBkh8psYfCqd0JOR
         7tApQ5xadUHVWgAqINaarsLrmY6eUyw65TD4b9pkbhW1bESstv1tml9kLBEeDijsma
         4bJDMhcqrR21bluOM4Qxu2NAoqrPniu5F7Z+ajy/WQSVYafZPuuloa9vnQhIcbbS4j
         2l6L+HULHnbqA==
Received: by mail-ed1-f72.google.com with SMTP id cy14-20020a0564021c8e00b003db8c9a6e30so2673326edb.1
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 00:39:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p7DB9CXnt9jgmm22VXqbPUHJTzgACaTPyFxSkRyfsXw=;
        b=uFAK2pSZvZtW7K6vb5hLxaCYyXmxiVWVvdVTFu80/kieXbofCGoOVR3JegZn3eWjF6
         C2JyIEMKWXSnGI5DTepYu9uGa8OxpWzc30JSMCACXFemrsZ8VmPytDog+E837v90BuXS
         eyiQZQmI5Q2LKxSENuHcdN7AnVKkjz2yPEepAvTeTqS1BWnFQwRCYT5TPqQp/vLssQea
         FB77beG+x6XToC0MEBFBxPU/yN6Z049i2+lUnp7/20cCvscP9HA5yVHpxME0af8SVEUh
         kuBVdMjfLqh5VgYWLiKSidYIe8zkMX1x0UxrlFLFfMMGpxz2BmEHEYy9bDojCTgAy5Jx
         JCbQ==
X-Gm-Message-State: AOAM5330wl3SaFQYSdzSyhrJrs5GlNQLTJszm1bnHdKzAAOCAat/vhQS
        r2g19xkkJEvrin1yfRQxum/zzKifWoR6W+3vcZv/AOQBR7qDi+gNOlk2hey0brohJOCcyxMK/9u
        mSoXj3uqTnJFO71ZlSgOmSDuMeuevc7u69Q==
X-Received: by 2002:a50:cf0d:: with SMTP id c13mr38438489edk.269.1633937988952;
        Mon, 11 Oct 2021 00:39:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwtcAHNa5bqyvBP7uHLdC5fEGKfVXP1SsqWgMZIcsmIr3wnyRbIRzVESmj8E1CmPDnaMSvDJA==
X-Received: by 2002:a50:cf0d:: with SMTP id c13mr38438472edk.269.1633937988744;
        Mon, 11 Oct 2021 00:39:48 -0700 (PDT)
Received: from localhost.localdomain (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id y8sm3023965ejm.104.2021.10.11.00.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 00:39:48 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Mark Greer <mgreer@animalcreek.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 3/8] dt-bindings: nfc: nxp,pn532: convert to dtschema
Date:   Mon, 11 Oct 2021 09:39:29 +0200
Message-Id: <20211011073934.34340-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
References: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the NXP PN532 NFC controller to DT schema format.

Drop the "clock-frequency" property during conversion because it is a
property of I2C bus controller, not I2C slave device.  It was also never
used by the driver.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../bindings/net/nfc/nxp,pn532.yaml           | 65 +++++++++++++++++++
 .../devicetree/bindings/net/nfc/pn532.txt     | 46 -------------
 2 files changed, 65 insertions(+), 46 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp,pn532.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/nfc/pn532.txt

diff --git a/Documentation/devicetree/bindings/net/nfc/nxp,pn532.yaml b/Documentation/devicetree/bindings/net/nfc/nxp,pn532.yaml
new file mode 100644
index 000000000000..d8ba5a18db98
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/nxp,pn532.yaml
@@ -0,0 +1,65 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/nfc/nxp,pn532.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP Semiconductors PN532 NFC controller
+
+maintainers:
+  - Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+
+properties:
+  compatible:
+    oneOf:
+      - const: nxp,pn532
+      - description: Deprecated bindings
+        enum:
+          - nxp,pn532-i2c
+          - nxp,pn533-i2c
+        deprecated: true
+
+  interrupts:
+    description: Required if connected via I2C
+    maxItems: 1
+
+  reg:
+    description: Required if connected via I2C
+    maxItems: 1
+
+required:
+  - compatible
+
+dependencies:
+  interrupts: [ 'reg' ]
+
+additionalProperties: false
+
+examples:
+  # PN532 on I2C bus
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    i2c {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        nfc@24 {
+            compatible = "nxp,pn532";
+
+            reg = <0x24>;
+
+            interrupt-parent = <&gpio1>;
+            interrupts = <17 IRQ_TYPE_LEVEL_HIGH>;
+        };
+    };
+
+  # PN532 connected via UART
+  - |
+    serial@49042000 {
+        reg = <0x49042000 0x400>;
+
+        nfc {
+            compatible = "nxp,pn532";
+        };
+    };
diff --git a/Documentation/devicetree/bindings/net/nfc/pn532.txt b/Documentation/devicetree/bindings/net/nfc/pn532.txt
deleted file mode 100644
index a5507dc499bc..000000000000
--- a/Documentation/devicetree/bindings/net/nfc/pn532.txt
+++ /dev/null
@@ -1,46 +0,0 @@
-* NXP Semiconductors PN532 NFC Controller
-
-Required properties:
-- compatible: Should be
-    - "nxp,pn532" Place a node with this inside the devicetree node of the bus
-                  where the NFC chip is connected to.
-                  Currently the kernel has phy bindings for uart and i2c.
-    - "nxp,pn532-i2c" (DEPRECATED) only works for the i2c binding.
-    - "nxp,pn533-i2c" (DEPRECATED) only works for the i2c binding.
-
-Required properties if connected on i2c:
-- clock-frequency: I²C work frequency.
-- reg: for the I²C bus address. This is fixed at 0x24 for the PN532.
-- interrupts: GPIO interrupt to which the chip is connected
-
-Optional SoC Specific Properties:
-- pinctrl-names: Contains only one value - "default".
-- pintctrl-0: Specifies the pin control groups used for this controller.
-
-Example (for ARM-based BeagleBone with PN532 on I2C2):
-
-&i2c2 {
-
-
-	pn532: nfc@24 {
-
-		compatible = "nxp,pn532";
-
-		reg = <0x24>;
-		clock-frequency = <400000>;
-
-		interrupt-parent = <&gpio1>;
-		interrupts = <17 IRQ_TYPE_EDGE_FALLING>;
-
-	};
-};
-
-Example (for PN532 connected via uart):
-
-uart4: serial@49042000 {
-        compatible = "ti,omap3-uart";
-
-        pn532: nfc {
-                compatible = "nxp,pn532";
-        };
-};
-- 
2.30.2

