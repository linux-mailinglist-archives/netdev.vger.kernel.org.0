Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01F7662605
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 13:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbjAIMyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 07:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236492AbjAIMxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 07:53:51 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A2E15FC6
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 04:53:43 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id ay12-20020a05600c1e0c00b003d9ea12bafcso3518712wmb.3
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 04:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tquvwj2kpJM2Ju/UAJGs8M9lyCJgcUVyQS/lXUiEhkI=;
        b=j4WnyX0OrhV3Tl4dXLdREy6trUYPvtp6GUEeJ7GPOcr73tsXoa4iOdeDXWB502uqCb
         L8UokGsnT4o4qVlJsUCzo/J4Gx6YpBCaStpX8O2/AfvVVoCCWuOV6iFQdxiWGFhCM7pr
         eBwl3cWeK751NdGbRKATht+u7uei9a51RSkVcEAxkFTpHBB7n4BU97L6gu+R591cFEc6
         wrZPz6ROTTgyq5NNhr3BhFw/WQJVusUfgPQ6SFLl23+qT0Me5yjaHsxlb2fyXlliEoz4
         gtb5vBBw0hqWuV9GYsAWdnIcxSuWq0N4fHT6PY0U8ME5pivWgx1xfJq+6oR1s6KvA+97
         69Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tquvwj2kpJM2Ju/UAJGs8M9lyCJgcUVyQS/lXUiEhkI=;
        b=FByAVVXbKTlksxZtYPQPataMs9wawRWQnL894bFNdQgfMWNFNpXJYOFx0wpbTJ+WQW
         wMSlmEgfCuduUN0M+S6jAfnAVtRi5zA9S+aRVCRfoeiXdCn+seTk4sJ3L98HqnohIljD
         19bt9TJqregtJqZW8nwnKnpIK8RHwqToBytaGgfS37gdW9GexfPdZyDgKAWP5MDhqSv4
         +wMIQgVXIXsFg3zoQOJPFobG1U9j+gpTpyHf2LH+z8WLax8B98kbPd20Z9GVzqfo90qu
         a00qQXX1IY00HgciQK+BQl45LmRyv/SBNoRC9g64JPnGTZTjD3VK2ulNfZr5xuv81wNB
         J0cQ==
X-Gm-Message-State: AFqh2kr+wnAFi+qqnXc/H5n0ip8D7spCLclSg+5odRkpPum4yKtumBHB
        +O8/l1Dg8qNdb5HcuSuBujnYvA==
X-Google-Smtp-Source: AMrXdXuDMWMWyAxYhduaA0kIz0hDTTIZak6lv6S7NHGoYj5aNSpW7iiMBldGLNyII8nQkPvLHAq60w==
X-Received: by 2002:a05:600c:3b16:b0:3d5:365b:7749 with SMTP id m22-20020a05600c3b1600b003d5365b7749mr46672260wms.16.1673268823250;
        Mon, 09 Jan 2023 04:53:43 -0800 (PST)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id y7-20020a7bcd87000000b003d997e5e679sm12805667wmj.14.2023.01.09.04.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 04:53:42 -0800 (PST)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Mon, 09 Jan 2023 13:53:32 +0100
Subject: [PATCH v2 08/11] dt-bindings: phy: convert meson-gxl-usb2-phy.txt to
 dt-schema
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221117-b4-amlogic-bindings-convert-v2-8-36ad050bb625@linaro.org>
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

Convert the Amlogic Meson GXL USB2 PHY bindings to dt-schema.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 .../bindings/phy/amlogic,meson-gxl-usb2-phy.yaml   | 56 ++++++++++++++++++++++
 .../devicetree/bindings/phy/meson-gxl-usb2-phy.txt | 21 --------
 2 files changed, 56 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/amlogic,meson-gxl-usb2-phy.yaml b/Documentation/devicetree/bindings/phy/amlogic,meson-gxl-usb2-phy.yaml
new file mode 100644
index 000000000000..c2f5c9d2fce6
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/amlogic,meson-gxl-usb2-phy.yaml
@@ -0,0 +1,56 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/amlogic,meson-gxl-usb2-phy.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Amlogic Meson GXL USB2 PHY
+
+maintainers:
+  - Neil Armstrong <neil.armstrong@linaro.org>
+
+properties:
+  compatible:
+    const: amlogic,meson-gxl-usb2-phy
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: phy
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    items:
+      - const: phy
+
+  "#phy-cells":
+    const: 0
+
+  phy-supply: true
+
+required:
+  - compatible
+  - reg
+  - "#phy-cells"
+
+additionalProperties: false
+
+examples:
+  - |
+    phy@78000 {
+        compatible = "amlogic,meson-gxl-usb2-phy";
+        reg = <0x78000 0x20>;
+        clocks = <&xtal>;
+        clock-names = "phy";
+        resets = <&phy_reset>;
+        reset-names = "phy";
+        #phy-cells = <0>;
+        phy-supply = <&usb2_supply>;
+    };
diff --git a/Documentation/devicetree/bindings/phy/meson-gxl-usb2-phy.txt b/Documentation/devicetree/bindings/phy/meson-gxl-usb2-phy.txt
deleted file mode 100644
index b84a02ebffdf..000000000000
--- a/Documentation/devicetree/bindings/phy/meson-gxl-usb2-phy.txt
+++ /dev/null
@@ -1,21 +0,0 @@
-* Amlogic Meson GXL and GXM USB2 PHY binding
-
-Required properties:
-- compatible:	Should be "amlogic,meson-gxl-usb2-phy"
-- reg:		The base address and length of the registers
-- #phys-cells:	must be 0 (see phy-bindings.txt in this directory)
-
-Optional properties:
-- clocks:	a phandle to the clock of this PHY
-- clock-names:	must be "phy"
-- resets:	a phandle to the reset line of this PHY
-- reset-names:	must be "phy"
-- phy-supply:	see phy-bindings.txt in this directory
-
-
-Example:
-	usb2_phy0: phy@78000 {
-		compatible = "amlogic,meson-gxl-usb2-phy";
-		#phy-cells = <0>;
-		reg = <0x0 0x78000 0x0 0x20>;
-	};

-- 
2.34.1
