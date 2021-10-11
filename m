Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEE54287E4
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 09:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbhJKHmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 03:42:09 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:57474
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234678AbhJKHl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 03:41:56 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 85EDB3FFE0
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 07:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633937995;
        bh=CPCA02s/SUPanw77EF1mmKLV8dt3hzeoEjW66M7WKxY=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=e13rYR5XeyDUCN9MICZYVPlWC7ktiLX3NTuhQOfBslIe1ovL6gSYKNuJ62ZkdqzV5
         El+O36WFD5Sd4vwHuh4xR5md/tPcV3VPw58RlIFlMwqRBkXl5f+pk2KgKZmxt3SlPR
         xjSACj27lQo8/EEcwOso6Vl15wUdpzSNRAM5fhtxBfh8LBair2BN9lG0zXjumU2okz
         kr4nE8dmKQkoNIlrVr+nDqLPcE0R805lKZSQQdHpIEaLaJwmJ2Bt/EkHXcQAJeNkBW
         X9tU0EH1i0SfoZrJehplQmLMiwATIgrdUTnbsSHH7SyDfnoFBM3RbZy9B6nvfXsk+J
         WSIt0KzmCa1Ng==
Received: by mail-ed1-f70.google.com with SMTP id 14-20020a508e4e000000b003d84544f33eso15105684edx.2
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 00:39:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CPCA02s/SUPanw77EF1mmKLV8dt3hzeoEjW66M7WKxY=;
        b=MmnkklCaR8sXzDP2IEoVBDdstNf2Hf52Xw/2CMAYpKX4xYeYHxpbRXqjjlQWD751Sj
         lHMhboZyhTbRUQPVjI3PMz34ctMPEllKPdJxrcYUN90K4N7h3pZ2nCYey8y3huQPGVon
         8Qa2SFgFyH8AW6BWWzgmcTVZSC0mPlxu4p8EAhbv7gwm/sCt4a3HKS8hHt2VQjlJ0nt8
         FdpV8Yvfw+PO8cAfShyAJKMlhlMqbRiOylNNCPaXvdq8Zadf5s+dNGVzTI5rHZv4VCuE
         gXUjLGix0ligL+cuG7WgkR/RfKh6UqDNYyWoYxtIjTb74vYl+MVTfIXi1fy+X43pXyuW
         8F+A==
X-Gm-Message-State: AOAM5304/oBiUYYQKs9p9XbygzJ0TvpP2qRP5ISCf/hV0YtPrz2C/PPE
        4zMA0k+JjXKb8C7ceVMvnMEvQ4ihNrHLUQTMOroQqQA3WG2NDjvNHvmSjmc+MC8mwjkYvODX7oP
        WjJgzzPCVfMjh8CuO/IG2/7hLSr0QF1iKNw==
X-Received: by 2002:a17:906:230c:: with SMTP id l12mr23244326eja.52.1633937995143;
        Mon, 11 Oct 2021 00:39:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDgu2s/kdqZCsNvJNxGCM7mQ2fU1eUh5c5DKqfhDLv5ziZmkE96bmMk35GtCjsqqCLbd1gDQ==
X-Received: by 2002:a17:906:230c:: with SMTP id l12mr23244306eja.52.1633937994905;
        Mon, 11 Oct 2021 00:39:54 -0700 (PDT)
Received: from localhost.localdomain (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id y8sm3023965ejm.104.2021.10.11.00.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 00:39:54 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Mark Greer <mgreer@animalcreek.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 7/8] dt-bindings: nfc: ti,trf7970a: convert to dtschema
Date:   Mon, 11 Oct 2021 09:39:33 +0200
Message-Id: <20211011073934.34340-8-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
References: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the TI TRF7970A NFC to DT schema format.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../bindings/net/nfc/ti,trf7970a.yaml         | 98 +++++++++++++++++++
 .../devicetree/bindings/net/nfc/trf7970a.txt  | 43 --------
 MAINTAINERS                                   |  2 +-
 3 files changed, 99 insertions(+), 44 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/ti,trf7970a.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/nfc/trf7970a.txt

diff --git a/Documentation/devicetree/bindings/net/nfc/ti,trf7970a.yaml b/Documentation/devicetree/bindings/net/nfc/ti,trf7970a.yaml
new file mode 100644
index 000000000000..40da2ac98978
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/ti,trf7970a.yaml
@@ -0,0 +1,98 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/nfc/ti,trf7970a.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Texas Instruments TRF7970A RFID/NFC/15693 Transceiver
+
+maintainers:
+  - Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+  - Mark Greer <mgreer@animalcreek.com>
+
+properties:
+  compatible:
+    const: ti,trf7970a
+
+  autosuspend-delay:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      Specify autosuspend delay in milliseconds.
+
+  clock-frequency:
+    description: |
+      Set to specify that the input frequency to the trf7970a is 13560000Hz or
+      27120000Hz
+
+  en2-rf-quirk:
+    type: boolean
+    description: |
+      Specify that the trf7970a being used has the "EN2 RF" erratum
+
+  interrupts:
+    maxItems: 1
+
+  irq-status-read-quirk:
+    type: boolean
+    description: |
+      Specify that the trf7970a being used has the "IRQ Status Read" erratum
+
+  reg:
+    maxItems: 1
+
+  spi-max-frequency: true
+
+  ti,enable-gpios:
+    minItems: 1
+    maxItems: 2
+    description: |
+      One or two GPIO entries used for 'EN' and 'EN2' pins on the TRF7970A. EN2
+      is optional.
+
+  vdd-io-supply:
+    description: |
+      Regulator specifying voltage for VDD-IO
+
+  vin-supply:
+    description: |
+      Regulator for supply voltage to VIN pin
+
+required:
+  - compatible
+  - interrupts
+  - reg
+  - spi-max-frequency
+  - ti,enable-gpios
+  - vin-supply
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
+        nfc@0 {
+            compatible = "ti,trf7970a";
+            reg = <0>;
+
+            pinctrl-names = "default";
+            pinctrl-0 = <&trf7970a_default>;
+            spi-max-frequency = <2000000>;
+            interrupt-parent = <&gpio2>;
+            interrupts = <14 0>;
+
+            ti,enable-gpios = <&gpio2 2 GPIO_ACTIVE_HIGH>,
+                              <&gpio2 5 GPIO_ACTIVE_HIGH>;
+            vin-supply = <&ldo3_reg>;
+            vdd-io-supply = <&ldo2_reg>;
+            autosuspend-delay = <30000>;
+            irq-status-read-quirk;
+            en2-rf-quirk;
+            clock-frequency = <27120000>;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
deleted file mode 100644
index ba1934b950e5..000000000000
--- a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
+++ /dev/null
@@ -1,43 +0,0 @@
-* Texas Instruments TRF7970A RFID/NFC/15693 Transceiver
-
-Required properties:
-- compatible: Should be "ti,trf7970a".
-- spi-max-frequency: Maximum SPI frequency (<= 2000000).
-- interrupts: A single interrupt specifier.
-- ti,enable-gpios: One or two GPIO entries used for 'EN' and 'EN2' pins on the
-  TRF7970A. EN2 is optional.
-- vin-supply: Regulator for supply voltage to VIN pin
-
-Optional SoC Specific Properties:
-- pinctrl-names: Contains only one value - "default".
-- pintctrl-0: Specifies the pin control groups used for this controller.
-- autosuspend-delay: Specify autosuspend delay in milliseconds.
-- irq-status-read-quirk: Specify that the trf7970a being used has the
-  "IRQ Status Read" erratum.
-- en2-rf-quirk: Specify that the trf7970a being used has the "EN2 RF"
-  erratum.
-- vdd-io-supply: Regulator specifying voltage for vdd-io
-- clock-frequency: Set to specify that the input frequency to the trf7970a is 13560000Hz or 27120000Hz
-
-Example (for ARM-based BeagleBone with TRF7970A on SPI1):
-
-&spi1 {
-
-	nfc@0 {
-		compatible = "ti,trf7970a";
-		reg = <0>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&trf7970a_default>;
-		spi-max-frequency = <2000000>;
-		interrupt-parent = <&gpio2>;
-		interrupts = <14 0>;
-		ti,enable-gpios = <&gpio2 2 GPIO_ACTIVE_HIGH>,
-				  <&gpio2 5 GPIO_ACTIVE_HIGH>;
-		vin-supply = <&ldo3_reg>;
-		vdd-io-supply = <&ldo2_reg>;
-		autosuspend-delay = <30000>;
-		irq-status-read-quirk;
-		en2-rf-quirk;
-		clock-frequency = <27120000>;
-	};
-};
diff --git a/MAINTAINERS b/MAINTAINERS
index 3294aaf5e56c..23dd7aac38a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18916,7 +18916,7 @@ M:	Mark Greer <mgreer@animalcreek.com>
 L:	linux-wireless@vger.kernel.org
 L:	linux-nfc@lists.01.org (subscribers-only)
 S:	Supported
-F:	Documentation/devicetree/bindings/net/nfc/trf7970a.txt
+F:	Documentation/devicetree/bindings/net/nfc/ti,trf7970a.yaml
 F:	drivers/nfc/trf7970a.c
 
 TI TSC2046 ADC DRIVER
-- 
2.30.2

