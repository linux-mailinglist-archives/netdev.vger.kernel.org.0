Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAD94281CD
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 16:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhJJOZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 10:25:35 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:45334
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232950AbhJJOZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 10:25:28 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id BEF6240012
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 14:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633875808;
        bh=Sqq+rJjHFyF04O1yXJWbxHdRB21zrCNZRwhAK9LaA+4=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=NE63b3ZyxlzmMTbbrNq5oTS7XywVrP7xFe7t/wBkvhnAiihd65iux9Rtvc5T3Fguq
         VLuoInqhpukz2QBpwOZNOhnKat1H9b9x8/usF4tgsC19lr7OqyPSYLwU9idFBKsfwM
         SJynte9Zvqm/6NvvmpFgjw4pdvWhZmNFboXw5ACQHklyLMgl2f2hKak3AL0jhwUxn4
         azn8HFNUfxkj5/ThMrGbCaoSPg6T9bRucb511f2vJu3uJfCJhw1CZZoFayfj+XmeGn
         hrDVpVX3SV6baRLZ+YsrnZDlvunvjSah80GEaLSZogB0ZE0edyG83XxFMKaionypSu
         02cerbu+10LdA==
Received: by mail-ed1-f71.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso13403846edj.20
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 07:23:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sqq+rJjHFyF04O1yXJWbxHdRB21zrCNZRwhAK9LaA+4=;
        b=xK1VTcKZJc4mBP7cSS4r5orPD7z0TnKFRMLRoNjxkLu8i1X/X5tlHbc4iWfKaOtBl/
         YdCuXIvfYCC0iC5cIIQLSiSzs1h2sdhJsw7v2PTodC5q2FRB4vNvcvpNA8PUB4jiupkk
         wzM9NzQOznrMQ1jeYDN7H09SeU9BrRFPG1Y0dPUHlFUxZ9ZD7AEf2DbIFPr6qFyrpgFJ
         r+afizEHA/gKs/hq55ppy7R1R6OBZrt5m1C2P9gKDuFq/VcHS2BncC4B8pnZSEuejmur
         GeIZ4ydbouwSeH/gAf0mdxmckwuDOX4SsVz/Nu/ac/r+N9UU+vD2LRTmFnPFKfl2ckgM
         aGmg==
X-Gm-Message-State: AOAM530Ry8lPdNSPEOEnTNUKptnaedl3kHq9v56gkt8df9BSfNSqLWzf
        wHMDfL4/tSi7NawQFIfW+toPNHa05iAZoXxBN2+XdSTlQuwsIf9UqnUnL7Qy7luR0+Ae7FrpWpF
        BvlOamHJ/1W68Qpu2zu3mhaNlNP+ESJRaOQ==
X-Received: by 2002:a17:906:f243:: with SMTP id gy3mr19625853ejb.327.1633875808467;
        Sun, 10 Oct 2021 07:23:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygD3KxN2qJU4LDVv1B2y+f6WnK3BXJ1VsrwWfy7ykP5hc4CknX+W8Wk656n8tIDYBu5hp19A==
X-Received: by 2002:a17:906:f243:: with SMTP id gy3mr19625832ejb.327.1633875808307;
        Sun, 10 Oct 2021 07:23:28 -0700 (PDT)
Received: from localhost.localdomain (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id 6sm2129017ejx.82.2021.10.10.07.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 07:23:27 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Mark Greer <mgreer@animalcreek.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 3/7] dt-bindings: nfc: st,st21nfca: convert to dtschema
Date:   Sun, 10 Oct 2021 16:23:13 +0200
Message-Id: <20211010142317.168259-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211010142317.168259-1-krzysztof.kozlowski@canonical.com>
References: <20211010142317.168259-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the ST ST21NFCA NFC controller to DT schema format.  The
conversion also adds a new required property - interrupts - because it
was missing in the old bindings by mistake.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../bindings/net/nfc/st,st21nfca.yaml         | 68 +++++++++++++++++++
 .../devicetree/bindings/net/nfc/st21nfca.txt  | 37 ----------
 2 files changed, 68 insertions(+), 37 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/st,st21nfca.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/nfc/st21nfca.txt

diff --git a/Documentation/devicetree/bindings/net/nfc/st,st21nfca.yaml b/Documentation/devicetree/bindings/net/nfc/st,st21nfca.yaml
new file mode 100644
index 000000000000..2cb65fd517ed
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/st,st21nfca.yaml
@@ -0,0 +1,68 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/nfc/st,st21nfca.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: STMicroelectronics SAS ST21NFCA NFC controller
+
+maintainers:
+  - Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+
+properties:
+  compatible:
+    const: st,st21nfca-i2c
+
+  clock-frequency: true
+
+  enable-gpios:
+    description: Output GPIO pin used for enabling/disabling the controller
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
+  uicc-present:
+    type: boolean
+    description: |
+      Specifies that the uicc swp signal can be physically connected to the
+      controller
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
+        nfc@1 {
+            compatible = "st,st21nfca-i2c";
+            reg = <0x1>;
+
+            clock-frequency = <400000>;
+            interrupt-parent = <&gpio5>;
+            interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
+            enable-gpios = <&gpio5 29 GPIO_ACTIVE_HIGH>;
+
+            ese-present;
+            uicc-present;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/net/nfc/st21nfca.txt b/Documentation/devicetree/bindings/net/nfc/st21nfca.txt
deleted file mode 100644
index b8bd90f80e12..000000000000
--- a/Documentation/devicetree/bindings/net/nfc/st21nfca.txt
+++ /dev/null
@@ -1,37 +0,0 @@
-* STMicroelectronics SAS. ST21NFCA NFC Controller
-
-Required properties:
-- compatible: Should be "st,st21nfca-i2c".
-- clock-frequency: I²C work frequency.
-- reg: address on the bus
-- enable-gpios: Output GPIO pin used for enabling/disabling the ST21NFCA
-
-Optional SoC Specific Properties:
-- pinctrl-names: Contains only one value - "default".
-- pintctrl-0: Specifies the pin control groups used for this controller.
-- ese-present: Specifies that an ese is physically connected to the nfc
-controller.
-- uicc-present: Specifies that the uicc swp signal can be physically
-connected to the nfc controller.
-
-Example (for ARM-based BeagleBoard xM with ST21NFCA on I2C2):
-
-&i2c2 {
-
-
-	st21nfca: st21nfca@1 {
-
-		compatible = "st,st21nfca-i2c";
-
-		reg = <0x01>;
-		clock-frequency = <400000>;
-
-		interrupt-parent = <&gpio5>;
-		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
-
-		enable-gpios = <&gpio5 29 GPIO_ACTIVE_HIGH>;
-
-		ese-present;
-		uicc-present;
-	};
-};
-- 
2.30.2

