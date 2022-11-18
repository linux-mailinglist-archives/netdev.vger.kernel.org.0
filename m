Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9010E62F7B9
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 15:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbiKROff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 09:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242434AbiKROef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 09:34:35 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365A68F3F7
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:33:45 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id j15so8860898wrq.3
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x+959Y5+XNaVCC9GiYukZyKg53qWkxIcg2rooGUoYxs=;
        b=YSNhB9fk95FVP8eq+MinfzITNvsGPTw7J/BfOAnCA6MRKMZfnjmjw9p0/GKJYPgLgu
         9Uf3MLZ6MeHhpyDqphm8PgmMbOmI9M/f+OzOpVjM43Nv9m86WVCmGrOj3l0tGB+1v4t9
         E55zg742HdjX3I8Xez3VNhN0tPDng4BOl+fLOTvBMcL27QGtZ2ILefS8PazePVfQle8N
         y5zWv0VxBqSYKmxV91YmcyduS6mo33+3c1BFDlnM3XuEmnbuSXpdI+vZHZN2DMvAYLH/
         DOifHgLjWiXg9pIpOeFLg9R+b1hj6UykJ86b/75uNd67UTOdRulhaB7c80oFGVdcUp/y
         +K2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x+959Y5+XNaVCC9GiYukZyKg53qWkxIcg2rooGUoYxs=;
        b=xZdZXQ7YTEE7Vt7ojaXPNDRkBhpAr7f1v4E6yaohLYGbOR+dxLZtmqi3Bz2chI1dBB
         IsL27Q+f2KrGirdb1D4Qmnf+IBFDWq6iuk7YM6K0WGfJR4bqL5Ac91JxdpUknAe5bsYk
         /HTxSpoW5Cyo70+A7XF+whG6Swd+MZ3mncUjTZZMEIDcrqXLRfz8dLVwJvRUmBJ8TmL3
         8N1MIsZaCbdMN3OFAonjWIjPc5+vpFkwYUyawmkXrkS0z6ksY2W7hprr0MhH4AiU8Ml7
         bJu6J/Ts1IKw4x2qBgbITa311CjluN4KP7/DhplKw+Rj3W3MnoB7ooVYCCudvJcQeP7R
         /QNA==
X-Gm-Message-State: ANoB5pl7dlr6iQHU3E4ozC4p6FJmI5VBM9zeXuPidRxD4ji2d/2BBo+Z
        zZNovXJ+tLZ7vbaS5pDs8by5WQ==
X-Google-Smtp-Source: AA0mqf6kIg/NB07SkdVixNMP4pENqPKYVFH1VHQ4hmTwJX0k5brwWTGOjQC+G8oF6LOfXK+X71xZ2w==
X-Received: by 2002:a05:6000:884:b0:241:b92c:6d73 with SMTP id ca4-20020a056000088400b00241b92c6d73mr3938192wrb.242.1668782024045;
        Fri, 18 Nov 2022 06:33:44 -0800 (PST)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id j21-20020a05600c1c1500b003cfb7c02542sm5436726wms.11.2022.11.18.06.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 06:33:43 -0800 (PST)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 18 Nov 2022 15:33:35 +0100
Subject: [PATCH 09/12] dt-bindings: phy: convert meson-gxl-usb2-phy.txt to dt-schema
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20221117-b4-amlogic-bindings-convert-v1-9-3f025599b968@linaro.org>
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Eric Dumazet <edumazet@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>,
        devicetree@vger.kernel.org
X-Mailer: b4 0.10.1
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

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 .../bindings/phy/amlogic,meson-gxl-usb2-phy.yaml   | 56 ++++++++++++++++++++++
 .../devicetree/bindings/phy/meson-gxl-usb2-phy.txt | 21 --------
 2 files changed, 56 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/amlogic,meson-gxl-usb2-phy.yaml b/Documentation/devicetree/bindings/phy/amlogic,meson-gxl-usb2-phy.yaml
new file mode 100644
index 000000000000..4dd287f1f400
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
+          compatible = "amlogic,meson-gxl-usb2-phy";
+          reg = <0x78000 0x20>;
+          clocks = <&xtal>;
+          clock-names = "phy";
+          resets = <&phy_reset>;
+          reset-names = "phy";
+          #phy-cells = <0>;
+          phy-supply = <&usb2_supply>;
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
b4 0.10.1
