Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92BE4287EC
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 09:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbhJKHmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 03:42:23 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:43870
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234674AbhJKHlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 03:41:55 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id D25D43FFFC
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 07:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633937992;
        bh=I/dEoNLrdiZf46+osatVihop4LOFN9ipzJ5r/D9Ro0Y=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=cY5OPx40B812009ZMYZM71Qen+/AecqpoxNVb6l1kgbzsVRuNdiY1JaMRn+Uvm7OU
         K7wpX4WLUmcJh7JtgFPf6ci+x+XWVfQR1g/4sctYtAtGGGuzwCCZw58mri//gQhJFS
         lCcdu0f4jJ0yrmCe94oJHuxRinyl234tnlPzyJnUJH0Fn8lSPZtfD7f4cWbbLzZY6P
         2Zsh0ttptB1Ir3JWI/HN/hU4dIZz06Va46dWbxRkm9EXj3rPGbhfcCzTOEGQid39S3
         9mKdU8QZRVVmWp10vQK6p6iY8jBgzbWX1SKOsQCJWRStOUtLr1WPojo/JMH1Jf67yl
         xsHAcxDFIR4tg==
Received: by mail-ed1-f70.google.com with SMTP id v2-20020a50f082000000b003db24e28d59so15074942edl.5
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 00:39:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I/dEoNLrdiZf46+osatVihop4LOFN9ipzJ5r/D9Ro0Y=;
        b=TIhEQdLd4G+owehb0t531taTuyjbqpruBl9ANvc1OMo2c62oZd6wUY9//bOcvJCrBZ
         yqjx/u18xusZ0cdLw8E/VyQLiHqq3NmE7Ip/Xupv8rpHshLXhrHaKJt1vkE+XwmeCYPQ
         MDeyktY4txVWjrbvol9ewFAGHzvcYjMEqRlXadQAPFIGpo1BpQ0ejAyiWaXfG48sAQ/p
         bANwOJ6KeFUpTX/JaLSfocn5piqbUnzUhJshOlgZMn0CmLi3EBTJHSuyRWvQ+ZD/JnxV
         kvnGlAqi7j2iipW1jr/Lum4EEaCWESosj3rov6gsHHwl87fBIVPXx7L22hdFPdUKGUeL
         XbDw==
X-Gm-Message-State: AOAM5327A8Z6bKxgY4yu6Gp1fnoXCELyD0LFPEj+FjPYUMNvpX4/+DeW
        eTVyU8/e3eU8FOduc/c4z0sV83F6BCVEnI1exu4iqYgf5CRxuBxXLZ2CzYf3noH/GiUlshbE+KK
        GilZyNKCLLL/CHgmtPdrdJL66dYXdncQSwA==
X-Received: by 2002:a17:906:9554:: with SMTP id g20mr8822751ejy.173.1633937992234;
        Mon, 11 Oct 2021 00:39:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydlyHM++aNbPEbVBXtm8qPF7gijwoo4iTHGVhgZn6hnEZ1scPUrmmfXAyYaXgv6SZ59wa6HQ==
X-Received: by 2002:a17:906:9554:: with SMTP id g20mr8822740ejy.173.1633937992070;
        Mon, 11 Oct 2021 00:39:52 -0700 (PDT)
Received: from localhost.localdomain (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id y8sm3023965ejm.104.2021.10.11.00.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 00:39:51 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Mark Greer <mgreer@animalcreek.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 5/8] dt-bindings: nfc: st,st95hf: convert to dtschema
Date:   Mon, 11 Oct 2021 09:39:31 +0200
Message-Id: <20211011073934.34340-6-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
References: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the ST ST95HF NFC controller to DT schema format.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../bindings/net/nfc/st,st95hf.yaml           | 57 +++++++++++++++++++
 .../devicetree/bindings/net/nfc/st95hf.txt    | 45 ---------------
 2 files changed, 57 insertions(+), 45 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/st,st95hf.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/nfc/st95hf.txt

diff --git a/Documentation/devicetree/bindings/net/nfc/st,st95hf.yaml b/Documentation/devicetree/bindings/net/nfc/st,st95hf.yaml
new file mode 100644
index 000000000000..d3bca376039e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/st,st95hf.yaml
@@ -0,0 +1,57 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/nfc/st,st95hf.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: STMicroelectronics ST95HF NFC controller
+
+maintainers:
+  - Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+
+properties:
+  compatible:
+    const: st,st95hf
+
+  enable-gpio:
+    description: Output GPIO pin used for enabling/disabling the controller
+
+  interrupts:
+    maxItems: 1
+
+  reg:
+    maxItems: 1
+
+  st95hfvin-supply:
+    description: ST95HF transceiver's Vin regulator supply
+
+  spi-max-frequency: true
+
+required:
+  - compatible
+  - enable-gpio
+  - interrupts
+  - reg
+  - spi-max-frequency
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    spi {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        nfc@0{
+            compatible = "st,st95hf";
+            reg = <0>;
+
+            spi-max-frequency = <1000000>;
+            enable-gpio = <&pio4 GPIO_ACTIVE_HIGH>;
+            interrupt-parent = <&pio0>;
+            interrupts = <7 IRQ_TYPE_EDGE_FALLING>;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/net/nfc/st95hf.txt b/Documentation/devicetree/bindings/net/nfc/st95hf.txt
deleted file mode 100644
index 3f373a1e20ff..000000000000
--- a/Documentation/devicetree/bindings/net/nfc/st95hf.txt
+++ /dev/null
@@ -1,45 +0,0 @@
-* STMicroelectronics : NFC Transceiver ST95HF
-
-ST NFC Transceiver is required to attach with SPI bus.
-ST95HF node should be defined in DT as SPI slave device of SPI
-master with which ST95HF transceiver is physically connected.
-The properties defined below are required to be the part of DT
-to include ST95HF transceiver into the platform.
-
-Required properties:
-===================
-- reg: Address of SPI slave "ST95HF transceiver" on SPI master bus.
-
-- compatible: should be "st,st95hf" for ST95HF NFC transceiver
-
-- spi-max-frequency: Max. operating SPI frequency for ST95HF
-	transceiver.
-
-- enable-gpio: GPIO line to enable ST95HF transceiver.
-
-- interrupts : Standard way to define ST95HF transceiver's out
-	interrupt.
-
-Optional property:
-=================
-- st95hfvin-supply : This is an optional property. It contains a
-	phandle to ST95HF transceiver's regulator supply node in DT.
-
-Example:
-=======
-spi@9840000 {
-	reg = <0x9840000 0x110>;
-	#address-cells = <1>;
-	#size-cells = <0>;
-	cs-gpios = <&pio0 4>;
-
-	st95hf@0{
-		reg = <0>;
-		compatible = "st,st95hf";
-		spi-max-frequency = <1000000>;
-		enable-gpio = <&pio4 0>;
-		interrupt-parent = <&pio0>;
-		interrupts = <7 IRQ_TYPE_EDGE_FALLING>;
-	};
-
-};
-- 
2.30.2

