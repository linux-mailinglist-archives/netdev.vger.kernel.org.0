Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D286625FB
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 13:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbjAIMyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 07:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234590AbjAIMxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 07:53:37 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996F51648E
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 04:53:35 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so6618019wms.4
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 04:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UbXe2+vnFi2o0+x3zbVNdzht9oC5iTUElnKdAfsufrk=;
        b=DOvxPAXGiNaerq41sXouK4mUViADCtl1292C8CsCHfPiv5MHP8l+bv4o+zhXHlZeg8
         +TOLBBSwXzBJm1HVsjkOiBczYGdPKQp7IwzQcYyg3Y67Eam+CXMHMOJvDvmICQHb3bXd
         aWBVDWPCA0tC/c7M6s5HslAPQ8l+zUU3XxO8iDbfcIorWmCGz9Prc09mRbAx4PAm3L9n
         Tc7L4YXgyU+ot7CO38EL43CwU/1I5dtTEqvCFO/LYgCavf5P+uT7kXv9tBlKs3jK6ZRB
         auzkSdJwVfsPTlD668SFi3GknfOOf2onl7SHMvMuSCehaEXwhBbEySGZN3oSfJ6ABVxV
         h3Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UbXe2+vnFi2o0+x3zbVNdzht9oC5iTUElnKdAfsufrk=;
        b=PCX1pT404Hg+ZS5GVZ1FPF4z14FYOdZ2W66TifP5N8U3X7SB9TymffGlGnw++/9co+
         byAqiekgM+WWIrfQSMsTMuxBF9yEdgkrmxt04J+VrsrMV/E4JG5X5DUTJfmhvv38qKBe
         Hw1czi/eHW3CCecwZqdK3Yl2/b5gGDopOm+bjvbtkEScGC1P5CrwQ6Db5Y6ND9ccGjXW
         lG7wH/cUiW2utllzwX7iSBqr3JMzDeYrRWLjOfe/1Xl5RpIaNwqmelWGi4B+BqYbRyDJ
         f88NwSWOKDSvM+4/NZRwITN4q8Zp95IrCdLwIpj7voJD7Jbr09KZJ0L2onGCzZtX3ZiK
         hUTw==
X-Gm-Message-State: AFqh2kp0RgMX00IHzCr7FW2TOUqfY23B7RPjCh6hueizUvgjBQeUqBL5
        ReOr5yHLh2lX4dIB1s9x++Be/A==
X-Google-Smtp-Source: AMrXdXudpqXVFbLwik7jPum30M/juG26ZBSd4Z3aISfa1VLm3maETyuA/mzYk1lep4t/A1RsQFwlcA==
X-Received: by 2002:a05:600c:2318:b0:3c6:e63e:23e9 with SMTP id 24-20020a05600c231800b003c6e63e23e9mr49142536wmo.24.1673268815169;
        Mon, 09 Jan 2023 04:53:35 -0800 (PST)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id y7-20020a7bcd87000000b003d997e5e679sm12805667wmj.14.2023.01.09.04.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 04:53:34 -0800 (PST)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Mon, 09 Jan 2023 13:53:27 +0100
Subject: [PATCH v2 03/11] dt-bindings: nvmem: convert
 amlogic-meson-mx-efuse.txt to dt-schema
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221117-b4-amlogic-bindings-convert-v2-3-36ad050bb625@linaro.org>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Amlogic Meson6 eFuse bindings to dt-schema.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 .../bindings/nvmem/amlogic,meson6-efuse.yaml       | 60 ++++++++++++++++++++++
 .../bindings/nvmem/amlogic-meson-mx-efuse.txt      | 22 --------
 2 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/Documentation/devicetree/bindings/nvmem/amlogic,meson6-efuse.yaml b/Documentation/devicetree/bindings/nvmem/amlogic,meson6-efuse.yaml
new file mode 100644
index 000000000000..11cace95d18c
--- /dev/null
+++ b/Documentation/devicetree/bindings/nvmem/amlogic,meson6-efuse.yaml
@@ -0,0 +1,60 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/nvmem/amlogic,meson6-efuse.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Amlogic Meson6 eFuse
+
+maintainers:
+  - Neil Armstrong <neil.armstrong@linaro.org>
+  - Martin Blumenstingl <martin.blumenstingl@googlemail.com>
+
+allOf:
+  - $ref: nvmem.yaml#
+
+properties:
+  compatible:
+    enum:
+      - amlogic,meson6-efuse
+      - amlogic,meson8-efuse
+      - amlogic,meson8b-efuse
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    const: core
+
+  secure-monitor:
+    description: phandle to the secure-monitor node
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    efuse: efuse@0 {
+        compatible = "amlogic,meson6-efuse";
+        reg = <0x0 0x2000>;
+        clocks = <&clk_efuse>;
+        clock-names = "core";
+        #address-cells = <1>;
+        #size-cells = <1>;
+
+        ethernet_mac_address: mac@1b4 {
+            reg = <0x1b4 0x6>;
+        };
+
+        temperature_calib: calib@1f4 {
+             reg = <0x1f4 0x4>;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/nvmem/amlogic-meson-mx-efuse.txt b/Documentation/devicetree/bindings/nvmem/amlogic-meson-mx-efuse.txt
deleted file mode 100644
index a3c63954a1a4..000000000000
--- a/Documentation/devicetree/bindings/nvmem/amlogic-meson-mx-efuse.txt
+++ /dev/null
@@ -1,22 +0,0 @@
-Amlogic Meson6/Meson8/Meson8b efuse
-
-Required Properties:
-- compatible: depending on the SoC this should be one of:
-	- "amlogic,meson6-efuse"
-	- "amlogic,meson8-efuse"
-	- "amlogic,meson8b-efuse"
-- reg: base address and size of the efuse registers
-- clocks: a reference to the efuse core gate clock
-- clock-names: must be "core"
-
-All properties and sub-nodes as well as the consumer bindings
-defined in nvmem.txt in this directory are also supported.
-
-
-Example:
-	efuse: nvmem@0 {
-		compatible = "amlogic,meson8-efuse";
-		reg = <0x0 0x2000>;
-		clocks = <&clkc CLKID_EFUSE>;
-		clock-names = "core";
-	};

-- 
2.34.1
