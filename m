Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6F34287D4
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 09:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbhJKHly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 03:41:54 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:57474
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234568AbhJKHlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 03:41:49 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 637244001E
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 07:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633937987;
        bh=hrLA5o9OEIQ0nHS0Sc5B651Iz0OK3SR27lQhWVZgzKI=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=I0mYu0D31VuK4pRmlCnk7ZywwcaMk+gp0zhdWj8iXMgwQewfI9QG6qIU91Pwhh+c2
         9wGMiTvyaksVArjqqY/f8gbxgAOX2sNvaPds7LVIL888LQLe3Pe9Mb+dg1fn/KvpzV
         E3sy0MKQDDQELkQMzsQ4E+RRWD8smZFiCX72yMd6n2+Mpi6+kOWIYPi/qC78Hlyzme
         jjHQvA831DH0+HtG4sOSbORbLOqWx2Dp9e0FJbg5spbKEFYoYEq28FJvt5b2RbBOF0
         Uj0rABuoFsPV0tvCyVslMnu9goVjeZBN1Pey87RySvXFIahhr3HAy4xea+A3NNdxM6
         yl5Mryw2TRQig==
Received: by mail-ed1-f69.google.com with SMTP id v9-20020a50d849000000b003db459aa3f5so12473129edj.15
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 00:39:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hrLA5o9OEIQ0nHS0Sc5B651Iz0OK3SR27lQhWVZgzKI=;
        b=osGF1WRR/C0y3BfEahsX3jLQkdEJgKHET6mFLh7NPzAIh9kXSfcUMyVHjP83+dlzr4
         Ig9EnXY8yqtRFMHhF7y52FYLUWWA+iO9nHMGKGMad8Q/Ayve1+q2enfTBtdQ1ksu7S5J
         JNf8UsZtA9XIMoo0gfuyBrKoNVMwvMTmHcyC8hWyzNbOzaHJe20gtZtgANykBhM5Kshz
         313HX56BZv96f2MHam+Xozbeb9PAMeDDAxrI0uO6l9GTttWAWlQBUFXKSGRkp2d4pT25
         IPyQzoxmf+UWFqbLZGUHAJouUhAWcgFirCnn2DXnVXv0iyWDdT/eXMagI65R3Ri2wwtf
         e57w==
X-Gm-Message-State: AOAM533eGlhomWxZsSia15ynKxOmqUZlyeiekqSii07va4TJEa9Ev7i/
        mjHgMF/3bCU8jDt2Qo6sg38iqN9JI07m4BpccgvZGTm18t3pvM+u3aexVeEEFaA0RLhkTSN+rFW
        7vJAkfA4rgKKawImP3X8dsga0n2vdEYICQA==
X-Received: by 2002:a50:be81:: with SMTP id b1mr39180545edk.59.1633937986055;
        Mon, 11 Oct 2021 00:39:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRojHIPPzkKpzS+divt5D4CXRSkB9G3jbMbb2k4RwWF1y3DeZtH0vRHHfAbA51bv493rwOpQ==
X-Received: by 2002:a50:be81:: with SMTP id b1mr39180520edk.59.1633937985884;
        Mon, 11 Oct 2021 00:39:45 -0700 (PDT)
Received: from localhost.localdomain (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id y8sm3023965ejm.104.2021.10.11.00.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 00:39:45 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Mark Greer <mgreer@animalcreek.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/8] dt-bindings: nfc: nxp,nci: convert to dtschema
Date:   Mon, 11 Oct 2021 09:39:27 +0200
Message-Id: <20211011073934.34340-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
References: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the NXP NCI NFC controller to DT schema format.

Drop the "clock-frequency" property during conversion because it is a
property of I2C bus controller, not I2C slave device.  It was also never
used by the driver.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../devicetree/bindings/net/nfc/nxp,nci.yaml  | 57 +++++++++++++++++++
 .../devicetree/bindings/net/nfc/nxp-nci.txt   | 33 -----------
 MAINTAINERS                                   |  1 +
 3 files changed, 58 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/nfc/nxp-nci.txt

diff --git a/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml b/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
new file mode 100644
index 000000000000..70634d20d4d7
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
@@ -0,0 +1,57 @@
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

