Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB07066262B
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 13:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbjAIMyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 07:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234926AbjAIMxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 07:53:41 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6534164A6
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 04:53:38 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so6618148wms.4
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 04:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GGsfIAFzoH7ggFb2voxRa7ZKIwz9PZMg5nKhBB1/kDo=;
        b=z5gNcqLJBYobEGNLqbeCjCAoRvI6N0EkNGB7H6G1yD1PxLGCRCMLm4Gz4V/FT3amV1
         q9EUbcnvEt9hP4RrjbiTOVAEnxtKfBOvaecmIDRaAIXlDFQRh19h/cHXbyZ2afMEScqP
         oKknYvdvQVzjfVxOiHVO/YOGsDGKTMeE3NZ2X5W1QjixQWr8tB1hHsI9XN6CHZe7NLDA
         t8KHchtoA4WwY3HJHXRLpCDhSTwu3DQQXqCDsgOASjyEz7KWxIyiU8NwLvL5oHBgRQT1
         HwK+ONcxqvC7BNRHCTC5o+J55xpWYHpSMmmbMufee+LcKHs89mmysgfObw+DfeC1aBB3
         oZ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GGsfIAFzoH7ggFb2voxRa7ZKIwz9PZMg5nKhBB1/kDo=;
        b=1gOwhqPhGviOv/jHCVq7cMz+vEkS1V1wZKQIvK27cm25Rn9cpeajP7pWot0uNpXWeD
         DwvlkNXPNFnVD/R5YBTB76S0Sc0895tGgzCYcvOQMyj+wCPq6EC2uIGNXgDOgZX2LVyA
         KpBqw5jmLEnieFIZ1Sf8dw1JxWB1IhziZur6gWvJgJqsf05f9MVvL8KHG/zKruCedTVM
         jGjVfRWvFw7CduJUCdVC2go0ht6NAqyzd5umuCt0kncuwqW1+AwoBtDqsltwvmSyQRvb
         sCFLPFbCDWEPwxd7yEW5cjIyt1P2eOG+7Y415EoFv2ABtldWJT1bDQCS3C+fvjARXy3y
         fylw==
X-Gm-Message-State: AFqh2krspr7YOUMXliIV40gSalTom8dwclIG6dXrduKRVVPQnk0TBQAo
        0A0ljSj2eeEYcYgEh3gX8OKXrxf4mtfUCrQI
X-Google-Smtp-Source: AMrXdXtdPYhHUaCl+iEvPcgDarKLArcUin1VypOwrhRsxqtGFwclSBHHlL5WVmJxrAa2H2QuyV3s6A==
X-Received: by 2002:a05:600c:354b:b0:3d0:4993:d45b with SMTP id i11-20020a05600c354b00b003d04993d45bmr47720065wmq.4.1673268818448;
        Mon, 09 Jan 2023 04:53:38 -0800 (PST)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id y7-20020a7bcd87000000b003d997e5e679sm12805667wmj.14.2023.01.09.04.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 04:53:38 -0800 (PST)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Mon, 09 Jan 2023 13:53:29 +0100
Subject: [PATCH v2 05/11] dt-bindings: media: convert meson-ir.txt to dt-schema
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221117-b4-amlogic-bindings-convert-v2-5-36ad050bb625@linaro.org>
References: <20221117-b4-amlogic-bindings-convert-v2-0-36ad050bb625@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v2-0-36ad050bb625@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Amlogic Meson IR remote control receiver bindings to
dt-schema.

Take in account the used variant with amlogic,meson-gx-ir.

Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 .../bindings/media/amlogic,meson6-ir.yaml          | 47 ++++++++++++++++++++++
 .../devicetree/bindings/media/meson-ir.txt         | 20 ---------
 2 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/amlogic,meson6-ir.yaml b/Documentation/devicetree/bindings/media/amlogic,meson6-ir.yaml
new file mode 100644
index 000000000000..3f9fa92703bb
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/amlogic,meson6-ir.yaml
@@ -0,0 +1,47 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/media/amlogic,meson6-ir.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Amlogic Meson IR remote control receiver
+
+maintainers:
+  - Neil Armstrong <neil.armstrong@linaro.org>
+
+allOf:
+  - $ref: rc.yaml#
+
+properties:
+  compatible:
+    oneOf:
+      - enum:
+          - amlogic,meson6-ir
+          - amlogic,meson8b-ir
+          - amlogic,meson-gxbb-ir
+      - items:
+          - const: amlogic,meson-gx-ir
+          - const: amlogic,meson-gxbb-ir
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    ir-receiver@c8100480 {
+        compatible = "amlogic,meson6-ir";
+        reg = <0xc8100480 0x20>;
+        interrupts = <GIC_SPI 15 IRQ_TYPE_EDGE_RISING>;
+    };
diff --git a/Documentation/devicetree/bindings/media/meson-ir.txt b/Documentation/devicetree/bindings/media/meson-ir.txt
deleted file mode 100644
index efd9d29a8f10..000000000000
--- a/Documentation/devicetree/bindings/media/meson-ir.txt
+++ /dev/null
@@ -1,20 +0,0 @@
-* Amlogic Meson IR remote control receiver
-
-Required properties:
- - compatible	: depending on the platform this should be one of:
-		  - "amlogic,meson6-ir"
-		  - "amlogic,meson8b-ir"
-		  - "amlogic,meson-gxbb-ir"
- - reg		: physical base address and length of the device registers
- - interrupts	: a single specifier for the interrupt from the device
-
-Optional properties:
- - linux,rc-map-name:	see rc.txt file in the same directory.
-
-Example:
-
-	ir-receiver@c8100480 {
-		compatible= "amlogic,meson6-ir";
-		reg = <0xc8100480 0x20>;
-		interrupts = <0 15 1>;
-	};

-- 
2.34.1
