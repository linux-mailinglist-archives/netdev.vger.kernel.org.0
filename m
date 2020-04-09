Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 251B41A3B3D
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 22:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgDIUZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 16:25:02 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33898 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgDIUZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 16:25:02 -0400
Received: by mail-io1-f65.google.com with SMTP id f3so965025ioj.1;
        Thu, 09 Apr 2020 13:25:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PYFXJu2v021QrExjLU89SWC+0SkjsxrrPKrOwguZdE0=;
        b=btJLusidWGoUHhO2tNP2tWKTg8ZqgSsUBki4KbT/0av5PEUNnaw/VIPifJ/nffO6c4
         d55wIG2s2QrWtWyLo6oYjeoPaQH8pUOzvkACDr58nr43EsJ8EWCV64BBXAg66hOpK5fX
         5OGhaW9KjsbsHQ5uCXoeMuoIKyWICbU6LModQOlihDAcJInCqcTxDqIBIeRdMeGKDMmF
         sChQ5TztlRCXWZcxcaLMT5+/GXNjKOfpRxdQ2aA9YWSsa9A/aPCm9tU36l31464qqS4E
         j4HXUo1tL/5oKxoayelIL7PoYDyy2lWLNXM1CWmY/4pHel3kkBc3B1cdr8376vAYoj7/
         7Nww==
X-Gm-Message-State: AGi0PuYZiMNAwmbO+44dOYM3BpTMBSt9t/l5wIOUfsXl27iUzinSTlgj
        Lm2npGPfCRKrV6blGZXX+hfA+Wg=
X-Google-Smtp-Source: APiQypIQrMT7fNU323jRwRLQI78vWEj7QI6Y6DFJa09OnPdPf8iC29OVD5mExa7mQsfGsjdswhxBOg==
X-Received: by 2002:a02:b897:: with SMTP id p23mr1294003jam.120.1586463900599;
        Thu, 09 Apr 2020 13:25:00 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.248])
        by smtp.googlemail.com with ESMTPSA id z17sm25408iln.34.2020.04.09.13.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 13:24:59 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Mark Brown <broonie@kernel.org>, linux-hwmon@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH] dt-bindings: Fix dtc warnings on reg and ranges in examples
Date:   Thu,  9 Apr 2020 14:24:58 -0600
Message-Id: <20200409202458.24509-1-robh@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent update to dtc and changes to the default warnings introduced
some new warnings in the DT binding examples:

Documentation/devicetree/bindings/arm/sunxi/allwinner,sun4i-a10-mbus.example.dts:23.13-61:
 Warning (dma_ranges_format): /example-0/dram-controller@1c01000:dma-ranges: "dma-ranges" property has invalid length (12 bytes) (parent #address-cells == 1, child #address-cells == 2, #size-cells == 1)
Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.example.dts:17.22-28.11:
 Warning (unit_address_vs_reg): /example-0/fpga-axi@0: node has a unit name, but no reg or ranges property
Documentation/devicetree/bindings/memory-controllers/nvidia,tegra186-mc.example.dts:34.13-54:
 Warning (dma_ranges_format): /example-0/memory-controller@2c00000:dma-ranges: "dma-ranges" property has invalid length (24 bytes) (parent #address-cells == 1, child #address-cells == 2, #size-cells == 2)
Documentation/devicetree/bindings/mfd/st,stpmic1.example.dts:19.15-79.11:
 Warning (unit_address_vs_reg): /example-0/i2c@0: node has a unit name, but no reg or ranges property
Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.example.dts:28.23-31.15:
 Warning (unit_address_vs_reg): /example-0/mdio@37000000/switch@10: node has a unit name, but no reg or ranges property
Documentation/devicetree/bindings/rng/brcm,bcm2835.example.dts:17.5-21.11:
 Warning (unit_address_vs_reg): /example-0/rng: node has a reg or ranges property, but no unit name
Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.example.dts:20.20-43.11:
 Warning (unit_address_vs_reg): /example-0/soc@0: node has a unit name, but no reg or ranges property
Documentation/devicetree/bindings/usb/ingenic,musb.example.dts:18.28-21.11:
 Warning (unit_address_vs_reg): /example-0/usb-phy@0: node has a unit name, but no reg or ranges property

Cc: Maxime Ripard <mripard@kernel.org>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: "Nuno Sá" <nuno.sa@analog.com>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Jonathan Hunter <jonathanh@nvidia.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Ray Jui <rjui@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>
Cc: bcm-kernel-feedback-list@broadcom.com
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-hwmon@vger.kernel.org
Cc: linux-tegra@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-rpi-kernel@lists.infradead.org
Cc: linux-spi@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
Will take this via the DT tree.

Rob

 .../arm/sunxi/allwinner,sun4i-a10-mbus.yaml   |  6 +++
 .../bindings/hwmon/adi,axi-fan-control.yaml   |  2 +-
 .../nvidia,tegra186-mc.yaml                   | 41 +++++++++++--------
 .../devicetree/bindings/mfd/st,stpmic1.yaml   |  2 +-
 .../bindings/net/qcom,ipq8064-mdio.yaml       |  1 +
 .../devicetree/bindings/rng/brcm,bcm2835.yaml |  2 +-
 .../bindings/spi/qcom,spi-qcom-qspi.yaml      |  2 +-
 .../devicetree/bindings/usb/ingenic,musb.yaml |  2 +-
 8 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun4i-a10-mbus.yaml b/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun4i-a10-mbus.yaml
index aa0738b4d534..e713a6fe4cf7 100644
--- a/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun4i-a10-mbus.yaml
+++ b/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun4i-a10-mbus.yaml
@@ -42,6 +42,10 @@ properties:
     description:
       See section 2.3.9 of the DeviceTree Specification.
 
+  '#address-cells': true
+
+  '#size-cells': true
+
 required:
   - "#interconnect-cells"
   - compatible
@@ -59,6 +63,8 @@ examples:
         compatible = "allwinner,sun5i-a13-mbus";
         reg = <0x01c01000 0x1000>;
         clocks = <&ccu CLK_MBUS>;
+        #address-cells = <1>;
+        #size-cells = <1>;
         dma-ranges = <0x00000000 0x40000000 0x20000000>;
         #interconnect-cells = <1>;
     };
diff --git a/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml b/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml
index 57a240d2d026..29bb2c778c59 100644
--- a/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml
+++ b/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml
@@ -47,7 +47,7 @@ required:
 
 examples:
   - |
-    fpga_axi: fpga-axi@0 {
+    fpga_axi: fpga-axi {
             #address-cells = <0x2>;
             #size-cells = <0x1>;
 
diff --git a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra186-mc.yaml b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra186-mc.yaml
index 12516bd89cf9..611bda38d187 100644
--- a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra186-mc.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra186-mc.yaml
@@ -97,30 +97,35 @@ examples:
     #include <dt-bindings/clock/tegra186-clock.h>
     #include <dt-bindings/interrupt-controller/arm-gic.h>
 
-    memory-controller@2c00000 {
-        compatible = "nvidia,tegra186-mc";
-        reg = <0x0 0x02c00000 0x0 0xb0000>;
-        interrupts = <GIC_SPI 223 IRQ_TYPE_LEVEL_HIGH>;
-
+    bus {
         #address-cells = <2>;
         #size-cells = <2>;
 
-        ranges = <0x0 0x02c00000 0x02c00000 0x0 0xb0000>;
+        memory-controller@2c00000 {
+            compatible = "nvidia,tegra186-mc";
+            reg = <0x0 0x02c00000 0x0 0xb0000>;
+            interrupts = <GIC_SPI 223 IRQ_TYPE_LEVEL_HIGH>;
+
+            #address-cells = <2>;
+            #size-cells = <2>;
+
+            ranges = <0x0 0x02c00000 0x0 0x02c00000 0x0 0xb0000>;
 
-        /*
-         * Memory clients have access to all 40 bits that the memory
-         * controller can address.
-         */
-        dma-ranges = <0x0 0x0 0x0 0x0 0x100 0x0>;
+            /*
+             * Memory clients have access to all 40 bits that the memory
+             * controller can address.
+             */
+            dma-ranges = <0x0 0x0 0x0 0x0 0x100 0x0>;
 
-        external-memory-controller@2c60000 {
-            compatible = "nvidia,tegra186-emc";
-            reg = <0x0 0x02c60000 0x0 0x50000>;
-            interrupts = <GIC_SPI 224 IRQ_TYPE_LEVEL_HIGH>;
-            clocks = <&bpmp TEGRA186_CLK_EMC>;
-            clock-names = "emc";
+            external-memory-controller@2c60000 {
+                compatible = "nvidia,tegra186-emc";
+                reg = <0x0 0x02c60000 0x0 0x50000>;
+                interrupts = <GIC_SPI 224 IRQ_TYPE_LEVEL_HIGH>;
+                clocks = <&bpmp TEGRA186_CLK_EMC>;
+                clock-names = "emc";
 
-            nvidia,bpmp = <&bpmp>;
+                nvidia,bpmp = <&bpmp>;
+            };
         };
     };
 
diff --git a/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml b/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
index d9ad9260e348..f88d13d70441 100644
--- a/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
+++ b/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
@@ -274,7 +274,7 @@ examples:
   - |
     #include <dt-bindings/mfd/st,stpmic1.h>
     #include <dt-bindings/interrupt-controller/arm-gic.h>
-    i2c@0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
       pmic@33 {
diff --git a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
index b9f90081046f..67df3fe861ee 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
@@ -48,6 +48,7 @@ examples:
 
         switch@10 {
             compatible = "qca,qca8337";
+            reg = <0x10>;
             /* ... */
         };
     };
diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
index 89ab67f20a7f..c147900f9041 100644
--- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
+++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
@@ -39,7 +39,7 @@ additionalProperties: false
 
 examples:
   - |
-    rng {
+    rng@7e104000 {
         compatible = "brcm,bcm2835-rng";
         reg = <0x7e104000 0x10>;
         interrupts = <2 29>;
diff --git a/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml b/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
index 0cf470eaf2a0..5c16cf59ca00 100644
--- a/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
+++ b/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
@@ -61,7 +61,7 @@ examples:
     #include <dt-bindings/clock/qcom,gcc-sdm845.h>
     #include <dt-bindings/interrupt-controller/arm-gic.h>
 
-    soc: soc@0 {
+    soc: soc {
         #address-cells = <2>;
         #size-cells = <2>;
 
diff --git a/Documentation/devicetree/bindings/usb/ingenic,musb.yaml b/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
index 1d6877875077..c2d2ee43ba67 100644
--- a/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
+++ b/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
@@ -56,7 +56,7 @@ additionalProperties: false
 examples:
   - |
     #include <dt-bindings/clock/jz4740-cgu.h>
-    usb_phy: usb-phy@0 {
+    usb_phy: usb-phy {
       compatible = "usb-nop-xceiv";
       #phy-cells = <0>;
     };
-- 
2.20.1

