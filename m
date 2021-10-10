Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6764281BE
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 16:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhJJOZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 10:25:26 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:45286
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231846AbhJJOZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 10:25:25 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 688E140012
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 14:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633875806;
        bh=GFOKzNYALQa+608FIQZ/in0rfsEAI0+jCScuqGun71I=;
        h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=RKHCHLE4VlJGcf4P3HX9IK1O4Dy62hZqsal5DFYo3/OxKAgwHl6gRF3vWTDUMwClM
         ZwYhyJTUWtJpDKgtVMNOSmh28qgwqqoWAe0IbYZo4mrlU/ckhVewDqZ5ii0sPr41dc
         QMLoMnyDGHcn8Xns3I7CDWGTu/+wcAnNWmQTADhOadWW7/wcxpr83rctXRJlm9kIcU
         fKStQLVt8YCbv+Sx2fQgbSX4f+rrauMXQ4Fy73o/3+EQeDk1l4M9FIc7AQmpRwyYXr
         6UwFMwaasc/e840vqZg0u28ekDfRtHV2fsO23XZ1CNAHx7Ikz1TCmLkUPhuKT36xbN
         2uydcxSgIPF5w==
Received: by mail-ed1-f71.google.com with SMTP id 2-20020a508e02000000b003d871759f5dso13446746edw.10
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 07:23:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GFOKzNYALQa+608FIQZ/in0rfsEAI0+jCScuqGun71I=;
        b=f0GQeHtajuhXrNMBjEJxeGcQdejJIRPO/Wz4XtH2S+reswgHwqAqbEGMCzOIi2Vz0r
         tAu+58tdAd4jMMWerqbX9VTF/VxuljmdhbQAuYQfIRBWK986n0daY3zFWZo//QaFIRd0
         vaZ+YZxlvKDiC/Rq8x5pyS4P4xM9TQtkdm4m5V4SYEbaHi8w684pwJ+Izy5wg7zIwk0+
         Gc5G3RQQQoTYfvZfvoc8CKj6NJjNXgGy6CdDfiUSfBbZrGICjpGqgUXWfQbDFeTrY14A
         LvDM8kkSZUvKw7Xj6gqzYk8rEQ+1/DYtR4AaQhe4HL9PJ8aXq9cIyHqxc3M3f2BJLdJY
         MHtw==
X-Gm-Message-State: AOAM530EMMAVXkB9mCUGhvKi5bVP3THrEuk3uDvYAvrOoZeF66JEoFXJ
        0HakMeXY4yWO0objucRoz3VFGvuyctREd/rbQtzns0RuLX215ciK0u1gpOWOHSNSbKyTP2HkW2V
        dmpab1omwdFrtR+HfhjKgHm0l4iPuaB0kAQ==
X-Received: by 2002:a17:906:4452:: with SMTP id i18mr18335289ejp.374.1633875805953;
        Sun, 10 Oct 2021 07:23:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx94bZ2ipwW70tBjgvzGZ79+303zLFR8lQVDmyzo0Dkcvx/qGXoXfyUNj77BL8MoxAU7lKhuQ==
X-Received: by 2002:a17:906:4452:: with SMTP id i18mr18335272ejp.374.1633875805770;
        Sun, 10 Oct 2021 07:23:25 -0700 (PDT)
Received: from localhost.localdomain (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id 6sm2129017ejx.82.2021.10.10.07.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 07:23:25 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Mark Greer <mgreer@animalcreek.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 1/7] dt-bindings: nfc: nxp,nci: convert to dtschema
Date:   Sun, 10 Oct 2021 16:23:11 +0200
Message-Id: <20211010142317.168259-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the NXP NCI NFC controller to DT schema format.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../devicetree/bindings/net/nfc/nxp,nci.yaml  | 61 +++++++++++++++++++
 .../devicetree/bindings/net/nfc/nxp-nci.txt   | 33 ----------
 MAINTAINERS                                   |  1 +
 3 files changed, 62 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/nfc/nxp-nci.txt

diff --git a/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml b/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
new file mode 100644
index 000000000000..f84e69775eb5
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
@@ -0,0 +1,61 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/nfc/nxp,nci.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP Semiconductors NCI NFC controller
+
+maintainers:
+  - Charles Gorand <charles.gorand@effinnov.com>
+  - Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+
+properties:
+  compatible:
+    const: nxp,nxp-nci-i2c
+
+  clock-frequency: true
+
+  enable-gpios:
+    description: Output GPIO pin used for enabling/disabling the controller
+
+  firmware-gpios:
+    description: Output GPIO pin used to enter firmware download mode
+
+  interrupts:
+    maxItems: 1
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - clock-frequency
+  - enable-gpios
+  - interrupts
+  - reg
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
+        nfc@29 {
+            compatible = "nxp,nxp-nci-i2c";
+
+            reg = <0x29>;
+            clock-frequency = <100000>;
+
+            interrupt-parent = <&gpio1>;
+            interrupts = <29 IRQ_TYPE_LEVEL_HIGH>;
+
+            enable-gpios = <&gpio0 30 GPIO_ACTIVE_HIGH>;
+            firmware-gpios = <&gpio0 31 GPIO_ACTIVE_HIGH>;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt b/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
deleted file mode 100644
index 285a37c2f189..000000000000
--- a/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
+++ /dev/null
@@ -1,33 +0,0 @@
-* NXP Semiconductors NXP NCI NFC Controllers
-
-Required properties:
-- compatible: Should be "nxp,nxp-nci-i2c".
-- clock-frequency: I²C work frequency.
-- reg: address on the bus
-- interrupts: GPIO interrupt to which the chip is connected
-- enable-gpios: Output GPIO pin used for enabling/disabling the chip
-
-Optional SoC Specific Properties:
-- pinctrl-names: Contains only one value - "default".
-- pintctrl-0: Specifies the pin control groups used for this controller.
-- firmware-gpios: Output GPIO pin used to enter firmware download mode
-
-Example (for ARM-based BeagleBone with NPC100 NFC controller on I2C2):
-
-&i2c2 {
-
-
-	npc100: npc100@29 {
-
-		compatible = "nxp,nxp-nci-i2c";
-
-		reg = <0x29>;
-		clock-frequency = <100000>;
-
-		interrupt-parent = <&gpio1>;
-		interrupts = <29 IRQ_TYPE_LEVEL_HIGH>;
-
-		enable-gpios = <&gpio0 30 GPIO_ACTIVE_HIGH>;
-		firmware-gpios = <&gpio0 31 GPIO_ACTIVE_HIGH>;
-	};
-};
diff --git a/MAINTAINERS b/MAINTAINERS
index 7cfd63ce7122..3294aaf5e56c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13632,6 +13632,7 @@ NXP-NCI NFC DRIVER
 R:	Charles Gorand <charles.gorand@effinnov.com>
 L:	linux-nfc@lists.01.org (subscribers-only)
 S:	Supported
+F:	Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
 F:	drivers/nfc/nxp-nci
 
 NXP i.MX 8QXP/8QM JPEG V4L2 DRIVER
-- 
2.30.2

