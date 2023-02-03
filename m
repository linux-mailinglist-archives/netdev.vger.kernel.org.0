Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC52689541
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 11:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbjBCKR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 05:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbjBCKRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 05:17:12 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBAA9D07A
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 02:16:39 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id bk16so4159509wrb.11
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 02:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6u+Yvf5WZ8YxNp1dBfH/8Y8RlJK+oLYlzIil4bIeK2w=;
        b=pHHWyzQnAxRahu6QfkoQFd0fc+l5fXpXdnilIdPj32wddcTjq364lXPaAujS1QG0vo
         wCi8aiPxGN5gJBXRvfClcLQFmxJ1pyhRJNmMEaEne0PbfClx/gEyM260QURovQDk+ETZ
         FIID6F71s2S5wcQhQerqg5lDxExLcnETUqysDCQHRohLCWGIVqNKJ+towDeMyi0/GBoA
         2rHavNAVwbewMco5QAbokx5Nie4iZ7if1QKEtMCR6V3T60qP8wKELIE6gftFFzSjMruK
         4VYc3YHTDybt0xEa73jJLRHwSWRE6aMFI608VpfywWfIYBBDaI+Yse1/faVmexGR3yWx
         Ov9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6u+Yvf5WZ8YxNp1dBfH/8Y8RlJK+oLYlzIil4bIeK2w=;
        b=upTSyDf6n1v2gRpm4noyud1dWnb9j+K8R851VHIkvqSTM+GswKUEemo5xa6ZUCky09
         3VKAXOtnUO32mi3gYGs+JzbamqitS8wumKtFIF+y0gGty9dH/y+bgSee0+8Iy/KXJTGC
         LzEASMft1A6Oa/F8JhTb3KCwVKra2A6tlPrjwROcKXXWH6VHXiXRZP9OHKH6AONDyo38
         YJZfn4qaE+04yF9UQlNqizPmQA8Qr+17UTW4caTjMloOkHXI+RPbgvtWel53bzzdEmt+
         aiiUPYOc6ybrOrcjV1odOZlCUI06qHMfjj17P0Vbvhtd83O5ef0Osv4g4/K5wMpRJJK0
         1snA==
X-Gm-Message-State: AO0yUKVLqFQT0gTRrIlaXp4fAijN8nRBtJtOkBdcX+PRn2GInJdgm51J
        8q2ybL5UlMfkEnjFctxWelmrhw==
X-Google-Smtp-Source: AK7set/1ZSIpvkzQ9NHdqjNKQNssxyljvMduHn94dnsLV27Q/PVXZCfq/7m7E8yPZ3qjviovsHk7Ug==
X-Received: by 2002:a5d:6d05:0:b0:2bf:e39d:c8a7 with SMTP id e5-20020a5d6d05000000b002bfe39dc8a7mr12178860wrq.44.1675419391976;
        Fri, 03 Feb 2023 02:16:31 -0800 (PST)
Received: from 1.. ([79.115.63.122])
        by smtp.gmail.com with ESMTPSA id w7-20020adfde87000000b002755e301eeasm1596501wrl.100.2023.02.03.02.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 02:16:31 -0800 (PST)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     trivial@kernel.org, linux-kernel@vger.kernel.org
Cc:     dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-gpio@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-mips@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-wireless@vger.kernel.org, chrome-platform@lists.linux.dev,
        linux-rtc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-usb@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH] tree-wide: trivial: s/ a SPI/ an SPI/
Date:   Fri,  3 Feb 2023 12:16:24 +0200
Message-Id: <20230203101624.474611-1-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=71771; i=tudor.ambarus@linaro.org; h=from:subject; bh=/eHRDe1UPSRADIsSmmLcLBI7zWykpjh5s3YigweorAc=; b=owEBbQGS/pANAwAKAUtVT0eljRTpAcsmYgBj3N7zQHixGo5T3XvQRVPf672yN4FBWwNbjctmM kjY3IEW7QyJATMEAAEKAB0WIQQdQirKzw7IbV4d/t9LVU9HpY0U6QUCY9ze8wAKCRBLVU9HpY0U 6Q7dB/9WnEt0UCAPfh4WGSnOWbj2kqk590gThAe/LTuqUhcKsdk39lStjdB/c6dEa3TIHn2QtEy W0ZcoLQ+9nzyKFxDlnMBqDqkPwj1wPuFtvCkwZ1ORbqLfF/EUM3T3M1hHIabPB8/zcEAE5IQsY0 JdRT/awfpnZQDMN7o5/jDu7293vr45T1fVPYyhtjURzC/bBkcxKWFmYtezFSjSBDN8yAChP5CU7 SkyTvo1UUzLTbtRPRNJoYZvdG/gb+zo+Fhl+rdBd5gvEMpa1kHFXVGD0LcN7PNrrC03zSzW1vrI RdFIFLoZpzjDHpvVRl5V32B65llgB0v56GjduE8GqZGVHfP+
X-Developer-Key: i=tudor.ambarus@linaro.org; a=openpgp; fpr=280B06FD4CAAD2980C46DDDF4DB1B079AD29CF3D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The deciding factor for when a/an should be used is the sound
that begins the word which follows these indefinite articles,
rather than the letter which does. Use "an SPI" (SPI begins
with the consonant letter S, but the S is pronounced with its
letter name, "es.").

Used sed to do the replacement:
find . -type f -exec sed -i "s/ a SPI/ an SPI/g" {} \;

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
Generated on top of v6.2-rc6.

 .../bindings/display/himax,hx8357d.txt         |  2 +-
 .../bindings/display/ilitek,ili9225.txt        |  2 +-
 .../bindings/display/multi-inno,mi0283qt.txt   |  2 +-
 .../bindings/display/panel/lg,lg4573.yaml      |  2 +-
 .../display/panel/samsung,lms397kf04.yaml      |  2 +-
 .../devicetree/bindings/display/repaper.txt    |  2 +-
 .../bindings/display/sitronix,st7586.txt       |  2 +-
 .../bindings/iio/accel/adi,adis16240.yaml      |  2 +-
 .../bindings/iio/accel/adi,adxl313.yaml        |  2 +-
 .../bindings/iio/accel/adi,adxl345.yaml        |  2 +-
 .../devicetree/bindings/iio/accel/lis302.txt   |  2 +-
 .../bindings/iio/accel/nxp,fxls8962af.yaml     |  2 +-
 .../bindings/iio/adc/microchip,mcp3201.yaml    |  2 +-
 .../bindings/input/touchscreen/ads7846.txt     |  2 +-
 .../devicetree/bindings/leds/leds-lp8860.txt   |  2 +-
 .../bindings/media/renesas,drif.yaml           |  2 +-
 .../memory-controllers/renesas,rpc-if.yaml     |  2 +-
 .../devicetree/bindings/mfd/atmel-flexcom.txt  |  2 +-
 .../bindings/misc/olpc,xo1.75-ec.yaml          |  2 +-
 .../devicetree/bindings/mmc/mmc-spi-slot.yaml  |  2 +-
 .../bindings/net/dsa/vitesse,vsc73xx.txt       |  2 +-
 .../bindings/net/microchip,enc28j60.txt        |  2 +-
 .../devicetree/bindings/net/wiznet,w5x00.txt   |  2 +-
 .../bindings/spi/brcm,spi-bcm-qspi.yaml        |  4 ++--
 .../bindings/spi/marvell,mmp2-ssp.yaml         |  2 +-
 .../bindings/spi/mxicy,mx25f0a-spi.yaml        |  2 +-
 .../bindings/spi/snps,dw-apb-ssi.yaml          |  2 +-
 .../devicetree/bindings/spi/spi-mux.yaml       |  2 +-
 .../bindings/spi/spi-peripheral-props.yaml     |  2 +-
 Documentation/driver-api/mtd/spi-nor.rst       |  4 ++--
 .../firmware-guide/acpi/enumeration.rst        |  2 +-
 .../firmware-guide/acpi/gpio-properties.rst    |  2 +-
 .../sound/designs/compress-offload.rst         |  2 +-
 Documentation/spi/spi-lm70llp.rst              |  4 ++--
 Documentation/spi/spidev.rst                   |  4 ++--
 arch/arm/boot/dts/imx7d-flex-concentrator.dts  |  2 +-
 .../cavium-octeon/executive/cvmx-helper-spi.c  |  6 +++---
 arch/mips/cavium-octeon/executive/cvmx-spi.c   | 16 ++++++++--------
 arch/mips/include/asm/octeon/cvmx-helper-spi.h |  4 ++--
 arch/mips/include/asm/octeon/cvmx-spi.h        | 18 +++++++++---------
 arch/mips/include/asm/octeon/cvmx-wqe.h        |  2 +-
 drivers/auxdisplay/lcd2s.c                     |  2 +-
 drivers/gpu/drm/solomon/ssd130x-spi.c          |  2 +-
 drivers/gpu/drm/tiny/ili9486.c                 |  2 +-
 drivers/input/misc/Kconfig                     |  4 ++--
 drivers/input/rmi4/Kconfig                     |  2 +-
 drivers/input/touchscreen/Kconfig              |  2 +-
 drivers/mfd/Kconfig                            |  2 +-
 drivers/mfd/ocelot.h                           |  2 +-
 drivers/mmc/host/Kconfig                       |  2 +-
 drivers/mtd/spi-nor/controllers/Kconfig        |  2 +-
 drivers/mtd/spi-nor/core.c                     | 14 +++++++-------
 drivers/mtd/spi-nor/core.h                     |  4 ++--
 drivers/mtd/spi-nor/sfdp.c                     |  6 +++---
 .../net/dsa/sja1105/sja1105_dynamic_config.c   |  4 ++--
 drivers/net/ethernet/microchip/enc28j60.c      |  2 +-
 .../net/wireless/microchip/wilc1000/Kconfig    |  2 +-
 drivers/net/wireless/st/cw1200/Kconfig         |  2 +-
 drivers/platform/chrome/Kconfig                |  2 +-
 drivers/platform/chrome/cros_ec_spi.c          |  2 +-
 drivers/rtc/rtc-ds1305.c                       |  2 +-
 drivers/spi/Kconfig                            |  8 ++++----
 drivers/spi/spi-mem.c                          | 10 +++++-----
 drivers/spi/spi-mpc52xx-psc.c                  |  2 +-
 drivers/spi/spi.c                              |  4 ++--
 drivers/staging/fbtft/fbtft.h                  |  2 +-
 drivers/staging/iio/meter/Kconfig              |  2 +-
 drivers/staging/octeon/ethernet-spi.c          |  2 +-
 drivers/usb/host/max3421-hcd.c                 |  2 +-
 include/linux/mtd/spinand.h                    | 14 +++++++-------
 include/linux/rmi.h                            |  2 +-
 include/linux/spi/spi-mem.h                    | 18 +++++++++---------
 include/linux/spi/spi.h                        |  8 ++++----
 73 files changed, 131 insertions(+), 131 deletions(-)

diff --git a/Documentation/devicetree/bindings/display/himax,hx8357d.txt b/Documentation/devicetree/bindings/display/himax,hx8357d.txt
index e641f664763d..ed7aebbd3c69 100644
--- a/Documentation/devicetree/bindings/display/himax,hx8357d.txt
+++ b/Documentation/devicetree/bindings/display/himax,hx8357d.txt
@@ -8,7 +8,7 @@ Required properties:
 - dc-gpios:	D/C pin
 - reg:		address of the panel on the SPI bus
 
-The node for this driver must be a child node of a SPI controller, hence
+The node for this driver must be a child node of an SPI controller, hence
 all mandatory properties described in ../spi/spi-bus.txt must be specified.
 
 Optional properties:
diff --git a/Documentation/devicetree/bindings/display/ilitek,ili9225.txt b/Documentation/devicetree/bindings/display/ilitek,ili9225.txt
index a59feb52015b..a62c896926d3 100644
--- a/Documentation/devicetree/bindings/display/ilitek,ili9225.txt
+++ b/Documentation/devicetree/bindings/display/ilitek,ili9225.txt
@@ -8,7 +8,7 @@ Required properties:
 - rs-gpios:	Register select signal
 - reset-gpios:	Reset pin
 
-The node for this driver must be a child node of a SPI controller, hence
+The node for this driver must be a child node of an SPI controller, hence
 all mandatory properties described in ../spi/spi-bus.txt must be specified.
 
 Optional properties:
diff --git a/Documentation/devicetree/bindings/display/multi-inno,mi0283qt.txt b/Documentation/devicetree/bindings/display/multi-inno,mi0283qt.txt
index eed48c3d4875..3b9b3053a438 100644
--- a/Documentation/devicetree/bindings/display/multi-inno,mi0283qt.txt
+++ b/Documentation/devicetree/bindings/display/multi-inno,mi0283qt.txt
@@ -3,7 +3,7 @@ Multi-Inno MI0283QT display panel
 Required properties:
 - compatible:	"multi-inno,mi0283qt".
 
-The node for this driver must be a child node of a SPI controller, hence
+The node for this driver must be a child node of an SPI controller, hence
 all mandatory properties described in ../spi/spi-bus.txt must be specified.
 
 Optional properties:
diff --git a/Documentation/devicetree/bindings/display/panel/lg,lg4573.yaml b/Documentation/devicetree/bindings/display/panel/lg,lg4573.yaml
index ee357e139ac0..39cae0e07741 100644
--- a/Documentation/devicetree/bindings/display/panel/lg,lg4573.yaml
+++ b/Documentation/devicetree/bindings/display/panel/lg,lg4573.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: LG LG4573 TFT Liquid Crystal Display with SPI control bus
 
 description: |
-  The panel must obey the rules for a SPI slave device as specified in
+  The panel must obey the rules for an SPI slave device as specified in
   spi/spi-controller.yaml
 
 maintainers:
diff --git a/Documentation/devicetree/bindings/display/panel/samsung,lms397kf04.yaml b/Documentation/devicetree/bindings/display/panel/samsung,lms397kf04.yaml
index 5e77cee93f83..dfaf1c63f0a7 100644
--- a/Documentation/devicetree/bindings/display/panel/samsung,lms397kf04.yaml
+++ b/Documentation/devicetree/bindings/display/panel/samsung,lms397kf04.yaml
@@ -39,7 +39,7 @@ properties:
   spi-cpol: true
 
   spi-max-frequency:
-    description: inherited as a SPI client node, the datasheet specifies
+    description: inherited as an SPI client node, the datasheet specifies
       maximum 300 ns minimum cycle which gives around 3 MHz max frequency
     maximum: 3000000
 
diff --git a/Documentation/devicetree/bindings/display/repaper.txt b/Documentation/devicetree/bindings/display/repaper.txt
index f5f9f9cf6a25..707cb50d7fc1 100644
--- a/Documentation/devicetree/bindings/display/repaper.txt
+++ b/Documentation/devicetree/bindings/display/repaper.txt
@@ -14,7 +14,7 @@ Required properties:
 Required property for e2271cs021:
 - border-gpios:		Border control
 
-The node for this driver must be a child node of a SPI controller, hence
+The node for this driver must be a child node of an SPI controller, hence
 all mandatory properties described in ../spi/spi-bus.txt must be specified.
 
 Optional property:
diff --git a/Documentation/devicetree/bindings/display/sitronix,st7586.txt b/Documentation/devicetree/bindings/display/sitronix,st7586.txt
index 1d0dad1210d3..b2f287d64a37 100644
--- a/Documentation/devicetree/bindings/display/sitronix,st7586.txt
+++ b/Documentation/devicetree/bindings/display/sitronix,st7586.txt
@@ -6,7 +6,7 @@ Required properties:
                 the pin labeled D1 on the controller, not the pin labeled A0)
 - reset-gpios:	Reset pin
 
-The node for this driver must be a child node of a SPI controller, hence
+The node for this driver must be a child node of an SPI controller, hence
 all mandatory properties described in ../spi/spi-bus.txt must be specified.
 
 Optional properties:
diff --git a/Documentation/devicetree/bindings/iio/accel/adi,adis16240.yaml b/Documentation/devicetree/bindings/iio/accel/adi,adis16240.yaml
index f6f97164c2ca..e60f3c3f1b27 100644
--- a/Documentation/devicetree/bindings/iio/accel/adi,adis16240.yaml
+++ b/Documentation/devicetree/bindings/iio/accel/adi,adis16240.yaml
@@ -43,7 +43,7 @@ examples:
         #address-cells = <1>;
         #size-cells = <0>;
 
-        /* Example for a SPI device node */
+        /* Example for an SPI device node */
         accelerometer@0 {
             compatible = "adi,adis16240";
             reg = <0>;
diff --git a/Documentation/devicetree/bindings/iio/accel/adi,adxl313.yaml b/Documentation/devicetree/bindings/iio/accel/adi,adxl313.yaml
index 185b68ffb536..dc70d5b8964b 100644
--- a/Documentation/devicetree/bindings/iio/accel/adi,adxl313.yaml
+++ b/Documentation/devicetree/bindings/iio/accel/adi,adxl313.yaml
@@ -79,7 +79,7 @@ examples:
         #address-cells = <1>;
         #size-cells = <0>;
 
-        /* Example for a SPI device node */
+        /* Example for an SPI device node */
         accelerometer@0 {
             compatible = "adi,adxl313";
             reg = <0>;
diff --git a/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml b/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
index 346abfb13a3a..d2214170f5ae 100644
--- a/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
+++ b/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
@@ -68,7 +68,7 @@ examples:
         #address-cells = <1>;
         #size-cells = <0>;
 
-        /* Example for a SPI device node */
+        /* Example for an SPI device node */
         accelerometer@0 {
             compatible = "adi,adxl345";
             reg = <0>;
diff --git a/Documentation/devicetree/bindings/iio/accel/lis302.txt b/Documentation/devicetree/bindings/iio/accel/lis302.txt
index 764e28ec1a0a..03d8a5c6c9aa 100644
--- a/Documentation/devicetree/bindings/iio/accel/lis302.txt
+++ b/Documentation/devicetree/bindings/iio/accel/lis302.txt
@@ -62,7 +62,7 @@ Optional properties for all bus drivers:
 				(used by self-test)
 
 
-Example for a SPI device node:
+Example for an SPI device node:
 
 	accelerometer@0 {
 		compatible = "st,lis302dl-spi";
diff --git a/Documentation/devicetree/bindings/iio/accel/nxp,fxls8962af.yaml b/Documentation/devicetree/bindings/iio/accel/nxp,fxls8962af.yaml
index 65ce8ea14b52..9a8ecdc5a056 100644
--- a/Documentation/devicetree/bindings/iio/accel/nxp,fxls8962af.yaml
+++ b/Documentation/devicetree/bindings/iio/accel/nxp,fxls8962af.yaml
@@ -69,7 +69,7 @@ examples:
         #address-cells = <1>;
         #size-cells = <0>;
 
-        /* Example for a SPI device node */
+        /* Example for an SPI device node */
         accelerometer@0 {
             compatible = "nxp,fxls8962af";
             reg = <0>;
diff --git a/Documentation/devicetree/bindings/iio/adc/microchip,mcp3201.yaml b/Documentation/devicetree/bindings/iio/adc/microchip,mcp3201.yaml
index 18108f0f3731..5bc50d350783 100644
--- a/Documentation/devicetree/bindings/iio/adc/microchip,mcp3201.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/microchip,mcp3201.yaml
@@ -10,7 +10,7 @@ maintainers:
   - Oskar Andero <oskar.andero@gmail.com>
 
 description: |
-   Family of simple ADCs with a SPI interface.
+   Family of simple ADCs with an SPI interface.
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/input/touchscreen/ads7846.txt b/Documentation/devicetree/bindings/input/touchscreen/ads7846.txt
index 81f6bda97d3c..3c3fd7326bdd 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/ads7846.txt
+++ b/Documentation/devicetree/bindings/input/touchscreen/ads7846.txt
@@ -1,7 +1,7 @@
 Device tree bindings for TI's ADS7843, ADS7845, ADS7846, ADS7873, TSC2046
 SPI driven touch screen controllers.
 
-The node for this driver must be a child node of a SPI controller, hence
+The node for this driver must be a child node of an SPI controller, hence
 all mandatory properties described in
 
 	Documentation/devicetree/bindings/spi/spi-bus.txt
diff --git a/Documentation/devicetree/bindings/leds/leds-lp8860.txt b/Documentation/devicetree/bindings/leds/leds-lp8860.txt
index 8bb25749a3da..ea9d8bcc7f06 100644
--- a/Documentation/devicetree/bindings/leds/leds-lp8860.txt
+++ b/Documentation/devicetree/bindings/leds/leds-lp8860.txt
@@ -3,7 +3,7 @@
 The LP8860-Q1 is an high-efficiency LED
 driver with boost controller. It has 4 high-precision
 current sinks that can be controlled by a PWM input
-signal, a SPI/I2C master, or both.
+signal, an SPI/I2C master, or both.
 
 Required properties:
 	- compatible :
diff --git a/Documentation/devicetree/bindings/media/renesas,drif.yaml b/Documentation/devicetree/bindings/media/renesas,drif.yaml
index 9403b235e976..aa30115469f3 100644
--- a/Documentation/devicetree/bindings/media/renesas,drif.yaml
+++ b/Documentation/devicetree/bindings/media/renesas,drif.yaml
@@ -11,7 +11,7 @@ maintainers:
   - Fabrizio Castro <fabrizio.castro.jz@renesas.com>
 
 description: |
-  R-Car Gen3 DRIF is a SPI like receive only slave device. A general
+  R-Car Gen3 DRIF is an SPI like receive only slave device. A general
   representation of DRIF interfacing with a master device is shown below.
 
   +---------------------+                +---------------------+
diff --git a/Documentation/devicetree/bindings/memory-controllers/renesas,rpc-if.yaml b/Documentation/devicetree/bindings/memory-controllers/renesas,rpc-if.yaml
index 30a403b1b79a..3b5c56ca2daa 100644
--- a/Documentation/devicetree/bindings/memory-controllers/renesas,rpc-if.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/renesas,rpc-if.yaml
@@ -10,7 +10,7 @@ maintainers:
   - Sergei Shtylyov <sergei.shtylyov@gmail.com>
 
 description: |
-  Renesas RPC-IF allows a SPI flash or HyperFlash connected to the SoC to
+  Renesas RPC-IF allows an SPI flash or HyperFlash connected to the SoC to
   be accessed via the external address space read mode or the manual mode.
 
   The flash chip itself should be represented by a subnode of the RPC-IF node.
diff --git a/Documentation/devicetree/bindings/mfd/atmel-flexcom.txt b/Documentation/devicetree/bindings/mfd/atmel-flexcom.txt
index 9d837535637b..076aa61a01ab 100644
--- a/Documentation/devicetree/bindings/mfd/atmel-flexcom.txt
+++ b/Documentation/devicetree/bindings/mfd/atmel-flexcom.txt
@@ -1,6 +1,6 @@
 * Device tree bindings for Atmel Flexcom (Flexible Serial Communication Unit)
 
-The Atmel Flexcom is just a wrapper which embeds a SPI controller, an I2C
+The Atmel Flexcom is just a wrapper which embeds an SPI controller, an I2C
 controller and an USART. Only one function can be used at a time and is chosen
 at boot time according to the device tree.
 
diff --git a/Documentation/devicetree/bindings/misc/olpc,xo1.75-ec.yaml b/Documentation/devicetree/bindings/misc/olpc,xo1.75-ec.yaml
index e99342f268a6..a53087ff80d9 100644
--- a/Documentation/devicetree/bindings/misc/olpc,xo1.75-ec.yaml
+++ b/Documentation/devicetree/bindings/misc/olpc,xo1.75-ec.yaml
@@ -8,7 +8,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: OLPC XO-1.75 Embedded Controller
 
 description: |
-  This binding describes the Embedded Controller acting as a SPI bus master
+  This binding describes the Embedded Controller acting as an SPI bus master
   on a OLPC XO-1.75 laptop computer.
 
   The embedded controller requires the SPI controller driver to signal
diff --git a/Documentation/devicetree/bindings/mmc/mmc-spi-slot.yaml b/Documentation/devicetree/bindings/mmc/mmc-spi-slot.yaml
index c0662ce9946d..897709a51208 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-spi-slot.yaml
+++ b/Documentation/devicetree/bindings/mmc/mmc-spi-slot.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mmc/mmc-spi-slot.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: MMC/SD/SDIO slot directly connected to a SPI bus
+title: MMC/SD/SDIO slot directly connected to an SPI bus
 
 maintainers:
   - Ulf Hansson <ulf.hansson@linaro.org>
diff --git a/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt b/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
index 258bef483673..6a6f4a813620 100644
--- a/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
+++ b/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
@@ -14,7 +14,7 @@ Vitesse VSC7398 SparX-G8e 8-port Integrated Gigabit Ethernet Switch
 This switch could have two different management interface.
 
 If SPI interface is used, the device tree node is an SPI device so it must
-reside inside a SPI bus device tree node, see spi/spi-bus.txt
+reside inside an SPI bus device tree node, see spi/spi-bus.txt
 
 When the chip is connected to a parallel memory bus and work in memory-mapped
 I/O mode, a platform device is used to represent the vsc73xx. In this case it
diff --git a/Documentation/devicetree/bindings/net/microchip,enc28j60.txt b/Documentation/devicetree/bindings/net/microchip,enc28j60.txt
index a8275921a896..3cd4774f7de2 100644
--- a/Documentation/devicetree/bindings/net/microchip,enc28j60.txt
+++ b/Documentation/devicetree/bindings/net/microchip,enc28j60.txt
@@ -2,7 +2,7 @@
 
 This is a standalone 10 MBit ethernet controller with SPI interface.
 
-For each device connected to a SPI bus, define a child node within
+For each device connected to an SPI bus, define a child node within
 the SPI master node.
 
 Required properties:
diff --git a/Documentation/devicetree/bindings/net/wiznet,w5x00.txt b/Documentation/devicetree/bindings/net/wiznet,w5x00.txt
index e9665798c4be..a9f979e2e897 100644
--- a/Documentation/devicetree/bindings/net/wiznet,w5x00.txt
+++ b/Documentation/devicetree/bindings/net/wiznet,w5x00.txt
@@ -2,7 +2,7 @@
 
 This is a standalone 10/100 MBit Ethernet controller with SPI interface.
 
-For each device connected to a SPI bus, define a child node within
+For each device connected to an SPI bus, define a child node within
 the SPI master node.
 
 Required properties:
diff --git a/Documentation/devicetree/bindings/spi/brcm,spi-bcm-qspi.yaml b/Documentation/devicetree/bindings/spi/brcm,spi-bcm-qspi.yaml
index ec5873919170..6202aa959a17 100644
--- a/Documentation/devicetree/bindings/spi/brcm,spi-bcm-qspi.yaml
+++ b/Documentation/devicetree/bindings/spi/brcm,spi-bcm-qspi.yaml
@@ -11,10 +11,10 @@ maintainers:
   - Rafał Miłecki <rafal@milecki.pl>
 
 description: |
-  The Broadcom SPI controller is a SPI master found on various SOCs, including
+  The Broadcom SPI controller is an SPI master found on various SOCs, including
   BRCMSTB (BCM7XXX), Cygnus, NSP and NS2. The Broadcom Master SPI hw IP consits
   of:
-    MSPI : SPI master controller can read and write to a SPI slave device
+    MSPI : SPI master controller can read and write to an SPI slave device
     BSPI : Broadcom SPI in combination with the MSPI hw IP provides acceleration
            for flash reads and be configured to do single, double, quad lane
            io with 3-byte and 4-byte addressing support.
diff --git a/Documentation/devicetree/bindings/spi/marvell,mmp2-ssp.yaml b/Documentation/devicetree/bindings/spi/marvell,mmp2-ssp.yaml
index 5f4f6b5615d0..c13c4c8a4e08 100644
--- a/Documentation/devicetree/bindings/spi/marvell,mmp2-ssp.yaml
+++ b/Documentation/devicetree/bindings/spi/marvell,mmp2-ssp.yaml
@@ -28,7 +28,7 @@ properties:
 
   ready-gpios:
     description: |
-      GPIO used to signal a SPI master that the FIFO is filled and we're
+      GPIO used to signal an SPI master that the FIFO is filled and we're
       ready to service a transfer. Only useful in slave mode.
     maxItems: 1
 
diff --git a/Documentation/devicetree/bindings/spi/mxicy,mx25f0a-spi.yaml b/Documentation/devicetree/bindings/spi/mxicy,mx25f0a-spi.yaml
index a3aa5e07c0e4..875f609d09be 100644
--- a/Documentation/devicetree/bindings/spi/mxicy,mx25f0a-spi.yaml
+++ b/Documentation/devicetree/bindings/spi/mxicy,mx25f0a-spi.yaml
@@ -40,7 +40,7 @@ properties:
 
   nand-ecc-engine:
     description: NAND ECC engine used by the SPI controller in order to perform
-      on-the-fly correction when using a SPI-NAND memory.
+      on-the-fly correction when using an SPI-NAND memory.
     $ref: /schemas/types.yaml#/definitions/phandle
 
 required:
diff --git a/Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.yaml b/Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.yaml
index d33b72fabc5d..b9f976d1b5bf 100644
--- a/Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.yaml
+++ b/Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.yaml
@@ -128,7 +128,7 @@ properties:
     description: |
       Default value of the rx-sample-delay-ns property.
       This value will be used if the property is not explicitly defined
-      for a SPI slave device.
+      for an SPI slave device.
 
       SPI Rx sample delay offset, unit is nanoseconds.
       The delay from the default sample time before the actual sample of the
diff --git a/Documentation/devicetree/bindings/spi/spi-mux.yaml b/Documentation/devicetree/bindings/spi/spi-mux.yaml
index 7ea79f6d33f3..cc65f7d5e1ed 100644
--- a/Documentation/devicetree/bindings/spi/spi-mux.yaml
+++ b/Documentation/devicetree/bindings/spi/spi-mux.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Generic SPI Multiplexer
 
 description: |
-  This binding describes a SPI bus multiplexer to route the SPI chip select
+  This binding describes an SPI bus multiplexer to route the SPI chip select
   signals. This can be used when you need more devices than the SPI controller
   has chip selects available. An example setup is shown in ASCII art; the actual
   setting of the multiplexer to a channel needs to be done by a specific SPI mux
diff --git a/Documentation/devicetree/bindings/spi/spi-peripheral-props.yaml b/Documentation/devicetree/bindings/spi/spi-peripheral-props.yaml
index 9a60c0664bbe..62959906aac3 100644
--- a/Documentation/devicetree/bindings/spi/spi-peripheral-props.yaml
+++ b/Documentation/devicetree/bindings/spi/spi-peripheral-props.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/spi/spi-peripheral-props.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Peripheral-specific properties for a SPI bus.
+title: Peripheral-specific properties for an SPI bus.
 
 description:
   Many SPI controllers need to add properties to peripheral devices. They could
diff --git a/Documentation/driver-api/mtd/spi-nor.rst b/Documentation/driver-api/mtd/spi-nor.rst
index 4a3adca417fd..bd091612dc16 100644
--- a/Documentation/driver-api/mtd/spi-nor.rst
+++ b/Documentation/driver-api/mtd/spi-nor.rst
@@ -12,7 +12,7 @@ arbitrary streams of bytes, but rather are designed specifically for SPI NOR.
 
 In particular, Freescale's QuadSPI controller must know the NOR commands to
 find the right LUT sequence. Unfortunately, the SPI subsystem has no notion of
-opcodes, addresses, or data payloads; a SPI controller simply knows to send or
+opcodes, addresses, or data payloads; an SPI controller simply knows to send or
 receive bytes (Tx and Rx). Therefore, we must define a new layering scheme under
 which the controller driver is aware of the opcodes, addressing, and other
 details of the SPI NOR protocol.
@@ -62,7 +62,7 @@ Part III - How can drivers use the framework?
 The main API is spi_nor_scan(). Before you call the hook, a driver should
 initialize the necessary fields for spi_nor{}. Please see
 drivers/mtd/spi-nor/spi-nor.c for detail. Please also refer to spi-fsl-qspi.c
-when you want to write a new driver for a SPI NOR controller.
+when you want to write a new driver for an SPI NOR controller.
 Another API is spi_nor_restore(), this is used to restore the status of SPI
 flash chip such as addressing mode. Call it whenever detach the driver from
 device or reboot the system.
diff --git a/Documentation/firmware-guide/acpi/enumeration.rst b/Documentation/firmware-guide/acpi/enumeration.rst
index b9dc0c603f36..47a5868940c3 100644
--- a/Documentation/firmware-guide/acpi/enumeration.rst
+++ b/Documentation/firmware-guide/acpi/enumeration.rst
@@ -187,7 +187,7 @@ Slave devices behind SPI bus have SpiSerialBus resource attached to them.
 This is extracted automatically by the SPI core and the slave devices are
 enumerated once spi_register_master() is called by the bus driver.
 
-Here is what the ACPI namespace for a SPI slave might look like::
+Here is what the ACPI namespace for an SPI slave might look like::
 
 	Device (EEP0)
 	{
diff --git a/Documentation/firmware-guide/acpi/gpio-properties.rst b/Documentation/firmware-guide/acpi/gpio-properties.rst
index eaec732cc77c..a5c865c266ac 100644
--- a/Documentation/firmware-guide/acpi/gpio-properties.rst
+++ b/Documentation/firmware-guide/acpi/gpio-properties.rst
@@ -86,7 +86,7 @@ reprograms them differently.
 
 It is possible to leave holes in the array of GPIOs. This is useful in
 cases like with SPI host controllers where some chip selects may be
-implemented as GPIOs and some as native signals. For example a SPI host
+implemented as GPIOs and some as native signals. For example an SPI host
 controller can have chip selects 0 and 2 implemented as GPIOs and 1 as
 native::
 
diff --git a/Documentation/sound/designs/compress-offload.rst b/Documentation/sound/designs/compress-offload.rst
index 935f325dbc77..bbd1c040f06a 100644
--- a/Documentation/sound/designs/compress-offload.rst
+++ b/Documentation/sound/designs/compress-offload.rst
@@ -93,7 +93,7 @@ ring buffer cannot be invalidated, except when dropping all buffers.
 
 The Compressed Data API does not make any assumptions on how the data
 is transmitted to the audio DSP. DMA transfers from main memory to an
-embedded audio cluster or to a SPI interface for external DSPs are
+embedded audio cluster or to an SPI interface for external DSPs are
 possible. As in the ALSA PCM case, a core set of routines is exposed;
 each driver implementer will have to write support for a set of
 mandatory routines and possibly make use of optional ones.
diff --git a/Documentation/spi/spi-lm70llp.rst b/Documentation/spi/spi-lm70llp.rst
index 07631aef4343..6c8413dba420 100644
--- a/Documentation/spi/spi-lm70llp.rst
+++ b/Documentation/spi/spi-lm70llp.rst
@@ -16,10 +16,10 @@ Description
 This driver provides glue code connecting a National Semiconductor LM70 LLP
 temperature sensor evaluation board to the kernel's SPI core subsystem.
 
-This is a SPI master controller driver. It can be used in conjunction with
+This is an SPI master controller driver. It can be used in conjunction with
 (layered under) the LM70 logical driver (a "SPI protocol driver").
 In effect, this driver turns the parallel port interface on the eval board
-into a SPI bus with a single device, which will be driven by the generic
+into an SPI bus with a single device, which will be driven by the generic
 LM70 driver (drivers/hwmon/lm70.c).
 
 
diff --git a/Documentation/spi/spidev.rst b/Documentation/spi/spidev.rst
index 369c657ba435..2108cc704b26 100644
--- a/Documentation/spi/spidev.rst
+++ b/Documentation/spi/spidev.rst
@@ -66,12 +66,12 @@ To make the spidev driver bind to such a device, use the following:
     echo spidev > /sys/bus/spi/devices/spiB.C/driver_override
     echo spiB.C > /sys/bus/spi/drivers/spidev/bind
 
-When the spidev driver is bound to a SPI device, the sysfs node for the
+When the spidev driver is bound to an SPI device, the sysfs node for the
 device will include a child device node with a "dev" attribute that will
 be understood by udev or mdev (udev replacement from BusyBox; it's less
 featureful, but often enough).
 
-For a SPI device with chipselect C on bus B, you should see:
+For an SPI device with chipselect C on bus B, you should see:
 
     /dev/spidevB.C ...
 	character special device, major number 153 with
diff --git a/arch/arm/boot/dts/imx7d-flex-concentrator.dts b/arch/arm/boot/dts/imx7d-flex-concentrator.dts
index bd6b5285aa8d..ac5f6faa2a3f 100644
--- a/arch/arm/boot/dts/imx7d-flex-concentrator.dts
+++ b/arch/arm/boot/dts/imx7d-flex-concentrator.dts
@@ -130,7 +130,7 @@ &ecspi4 {
 	 * ST chip maximum SPI clock frequency is 33 MHz.
 	 *
 	 * TCG specification - Section 6.4.1 Clocking:
-	 * TPM shall support a SPI clock frequency range of 10-24 MHz.
+	 * TPM shall support an SPI clock frequency range of 10-24 MHz.
 	 */
 	st33htph: tpm-tis@0 {
 		compatible = "st,st33htpm-spi", "tcg,tpm_tis-spi";
diff --git a/arch/mips/cavium-octeon/executive/cvmx-helper-spi.c b/arch/mips/cavium-octeon/executive/cvmx-helper-spi.c
index 525914e9b22d..3886d460cb2a 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-helper-spi.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-helper-spi.c
@@ -60,7 +60,7 @@ int __cvmx_helper_spi_enumerate(int interface)
 }
 
 /**
- * Probe a SPI interface and determine the number of ports
+ * Probe an SPI interface and determine the number of ports
  * connected to it. The SPI interface should still be down after
  * this call.
  *
@@ -93,7 +93,7 @@ int __cvmx_helper_spi_probe(int interface)
 }
 
 /**
- * Bringup and enable a SPI interface. After this call packet I/O
+ * Bringup and enable an SPI interface. After this call packet I/O
  * should be fully functional. This is called with IPD enabled but
  * PKO disabled.
  *
@@ -195,7 +195,7 @@ union cvmx_helper_link_info __cvmx_helper_spi_link_get(int ipd_port)
  */
 int __cvmx_helper_spi_link_set(int ipd_port, union cvmx_helper_link_info link_info)
 {
-	/* Nothing to do. If we have a SPI4000 then the setup was already performed
+	/* Nothing to do. If we have an SPI4000 then the setup was already performed
 	   by cvmx_spi4000_check_speed(). If not then there isn't any link
 	   info */
 	return 0;
diff --git a/arch/mips/cavium-octeon/executive/cvmx-spi.c b/arch/mips/cavium-octeon/executive/cvmx-spi.c
index eb9333e84a6b..f9814a4be84f 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-spi.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-spi.c
@@ -92,7 +92,7 @@ void cvmx_spi_set_callbacks(cvmx_spi_callbacks_t *new_callbacks)
  * Initialize and start the SPI interface.
  *
  * @interface: The identifier of the packet interface to configure and
- *		    use as a SPI interface.
+ *		    use as an SPI interface.
  * @mode:      The operating mode for the SPI interface. The interface
  *		    can operate as a full duplex (both Tx and Rx data paths
  *		    active) or as a halfplex (either the Tx data path is
@@ -138,7 +138,7 @@ int cvmx_spi_start_interface(int interface, cvmx_spi_mode_t mode, int timeout,
  * with its correspondent system.
  *
  * @interface: The identifier of the packet interface to configure and
- *		    use as a SPI interface.
+ *		    use as an SPI interface.
  * @mode:      The operating mode for the SPI interface. The interface
  *		    can operate as a full duplex (both Tx and Rx data paths
  *		    active) or as a halfplex (either the Tx data path is
@@ -183,7 +183,7 @@ EXPORT_SYMBOL_GPL(cvmx_spi_restart_interface);
  * Callback to perform SPI4 reset
  *
  * @interface: The identifier of the packet interface to configure and
- *		    use as a SPI interface.
+ *		    use as an SPI interface.
  * @mode:      The operating mode for the SPI interface. The interface
  *		    can operate as a full duplex (both Tx and Rx data paths
  *		    active) or as a halfplex (either the Tx data path is
@@ -298,7 +298,7 @@ int cvmx_spi_reset_cb(int interface, cvmx_spi_mode_t mode)
  * Callback to setup calendar and miscellaneous settings before clock detection
  *
  * @interface: The identifier of the packet interface to configure and
- *		    use as a SPI interface.
+ *		    use as an SPI interface.
  * @mode:      The operating mode for the SPI interface. The interface
  *		    can operate as a full duplex (both Tx and Rx data paths
  *		    active) or as a halfplex (either the Tx data path is
@@ -417,7 +417,7 @@ int cvmx_spi_calendar_setup_cb(int interface, cvmx_spi_mode_t mode,
  * Callback to perform clock detection
  *
  * @interface: The identifier of the packet interface to configure and
- *		    use as a SPI interface.
+ *		    use as an SPI interface.
  * @mode:      The operating mode for the SPI interface. The interface
  *		    can operate as a full duplex (both Tx and Rx data paths
  *		    active) or as a halfplex (either the Tx data path is
@@ -495,7 +495,7 @@ int cvmx_spi_clock_detect_cb(int interface, cvmx_spi_mode_t mode, int timeout)
  * Callback to perform link training
  *
  * @interface: The identifier of the packet interface to configure and
- *		    use as a SPI interface.
+ *		    use as an SPI interface.
  * @mode:      The operating mode for the SPI interface. The interface
  *		    can operate as a full duplex (both Tx and Rx data paths
  *		    active) or as a halfplex (either the Tx data path is
@@ -564,7 +564,7 @@ int cvmx_spi_training_cb(int interface, cvmx_spi_mode_t mode, int timeout)
  * Callback to perform calendar data synchronization
  *
  * @interface: The identifier of the packet interface to configure and
- *		    use as a SPI interface.
+ *		    use as an SPI interface.
  * @mode:      The operating mode for the SPI interface. The interface
  *		    can operate as a full duplex (both Tx and Rx data paths
  *		    active) or as a halfplex (either the Tx data path is
@@ -621,7 +621,7 @@ int cvmx_spi_calendar_sync_cb(int interface, cvmx_spi_mode_t mode, int timeout)
  * Callback to handle interface up
  *
  * @interface: The identifier of the packet interface to configure and
- *		    use as a SPI interface.
+ *		    use as an SPI interface.
  * @mode:      The operating mode for the SPI interface. The interface
  *		    can operate as a full duplex (both Tx and Rx data paths
  *		    active) or as a halfplex (either the Tx data path is
diff --git a/arch/mips/include/asm/octeon/cvmx-helper-spi.h b/arch/mips/include/asm/octeon/cvmx-helper-spi.h
index bc8cab9367b8..d2a15c3382ff 100644
--- a/arch/mips/include/asm/octeon/cvmx-helper-spi.h
+++ b/arch/mips/include/asm/octeon/cvmx-helper-spi.h
@@ -33,7 +33,7 @@
 #define __CVMX_HELPER_SPI_H__
 
 /**
- * Probe a SPI interface and determine the number of ports
+ * Probe an SPI interface and determine the number of ports
  * connected to it. The SPI interface should still be down after
  * this call.
  *
@@ -45,7 +45,7 @@ extern int __cvmx_helper_spi_probe(int interface);
 extern int __cvmx_helper_spi_enumerate(int interface);
 
 /**
- * Bringup and enable a SPI interface. After this call packet I/O
+ * Bringup and enable an SPI interface. After this call packet I/O
  * should be fully functional. This is called with IPD enabled but
  * PKO disabled.
  *
diff --git a/arch/mips/include/asm/octeon/cvmx-spi.h b/arch/mips/include/asm/octeon/cvmx-spi.h
index d5038cc4b475..2d52578262a7 100644
--- a/arch/mips/include/asm/octeon/cvmx-spi.h
+++ b/arch/mips/include/asm/octeon/cvmx-spi.h
@@ -84,7 +84,7 @@ static inline int cvmx_spi_is_spi_interface(int interface)
  * Initialize and start the SPI interface.
  *
  * @interface: The identifier of the packet interface to configure and
- *		    use as a SPI interface.
+ *		    use as an SPI interface.
  * @mode:      The operating mode for the SPI interface. The interface
  *		    can operate as a full duplex (both Tx and Rx data paths
  *		    active) or as a halfplex (either the Tx data path is
@@ -102,7 +102,7 @@ extern int cvmx_spi_start_interface(int interface, cvmx_spi_mode_t mode,
  * with its corespondant system.
  *
  * @interface: The identifier of the packet interface to configure and
- *		    use as a SPI interface.
+ *		    use as an SPI interface.
  * @mode:      The operating mode for the SPI interface. The interface
  *		    can operate as a full duplex (both Tx and Rx data paths
  *		    active) or as a halfplex (either the Tx data path is
@@ -114,7 +114,7 @@ extern int cvmx_spi_restart_interface(int interface, cvmx_spi_mode_t mode,
 				      int timeout);
 
 /**
- * Return non-zero if the SPI interface has a SPI4000 attached
+ * Return non-zero if the SPI interface has an SPI4000 attached
  *
  * @interface: SPI interface the SPI4000 is connected to
  *
@@ -171,7 +171,7 @@ extern void cvmx_spi_set_callbacks(cvmx_spi_callbacks_t *new_callbacks);
  * Callback to perform SPI4 reset
  *
  * @interface: The identifier of the packet interface to configure and
- *		    use as a SPI interface.
+ *		    use as an SPI interface.
  * @mode:      The operating mode for the SPI interface. The interface
  *		    can operate as a full duplex (both Tx and Rx data paths
  *		    active) or as a halfplex (either the Tx data path is
@@ -187,7 +187,7 @@ extern int cvmx_spi_reset_cb(int interface, cvmx_spi_mode_t mode);
  * detection
  *
  * @interface: The identifier of the packet interface to configure and
- *		    use as a SPI interface.
+ *		    use as an SPI interface.
  * @mode:      The operating mode for the SPI interface. The interface
  *		    can operate as a full duplex (both Tx and Rx data paths
  *		    active) or as a halfplex (either the Tx data path is
@@ -204,7 +204,7 @@ extern int cvmx_spi_calendar_setup_cb(int interface, cvmx_spi_mode_t mode,
  * Callback to perform clock detection
  *
  * @interface: The identifier of the packet interface to configure and
- *		    use as a SPI interface.
+ *		    use as an SPI interface.
  * @mode:      The operating mode for the SPI interface. The interface
  *		    can operate as a full duplex (both Tx and Rx data paths
  *		    active) or as a halfplex (either the Tx data path is
@@ -221,7 +221,7 @@ extern int cvmx_spi_clock_detect_cb(int interface, cvmx_spi_mode_t mode,
  * Callback to perform link training
  *
  * @interface: The identifier of the packet interface to configure and
- *		    use as a SPI interface.
+ *		    use as an SPI interface.
  * @mode:      The operating mode for the SPI interface. The interface
  *		    can operate as a full duplex (both Tx and Rx data paths
  *		    active) or as a halfplex (either the Tx data path is
@@ -238,7 +238,7 @@ extern int cvmx_spi_training_cb(int interface, cvmx_spi_mode_t mode,
  * Callback to perform calendar data synchronization
  *
  * @interface: The identifier of the packet interface to configure and
- *		    use as a SPI interface.
+ *		    use as an SPI interface.
  * @mode:      The operating mode for the SPI interface. The interface
  *		    can operate as a full duplex (both Tx and Rx data paths
  *		    active) or as a halfplex (either the Tx data path is
@@ -255,7 +255,7 @@ extern int cvmx_spi_calendar_sync_cb(int interface, cvmx_spi_mode_t mode,
  * Callback to handle interface up
  *
  * @interface: The identifier of the packet interface to configure and
- *		    use as a SPI interface.
+ *		    use as an SPI interface.
  * @mode:      The operating mode for the SPI interface. The interface
  *		    can operate as a full duplex (both Tx and Rx data paths
  *		    active) or as a halfplex (either the Tx data path is
diff --git a/arch/mips/include/asm/octeon/cvmx-wqe.h b/arch/mips/include/asm/octeon/cvmx-wqe.h
index 9cec2299b81b..4a4c39311a40 100644
--- a/arch/mips/include/asm/octeon/cvmx-wqe.h
+++ b/arch/mips/include/asm/octeon/cvmx-wqe.h
@@ -359,7 +359,7 @@ typedef union {
 		 *	  RGMII packet had a studder error (data not
 		 *	  repeated - 10/100M only) or the SPI4 packet
 		 *	  was sent to an NXA.
-		 * - 16 = FCS error: a SPI4.2 packet had an FCS error.
+		 * - 16 = FCS error: an SPI4.2 packet had an FCS error.
 		 * - 17 = Skip error: a packet was not large enough to
 		 *	  cover the skipped bytes.
 		 * - 18 = L2 header malformed: the packet is not long
diff --git a/drivers/auxdisplay/lcd2s.c b/drivers/auxdisplay/lcd2s.c
index 135831a16514..7864df3607b1 100644
--- a/drivers/auxdisplay/lcd2s.c
+++ b/drivers/auxdisplay/lcd2s.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  *  Console driver for LCD2S 4x20 character displays connected through i2c.
- *  The display also has a SPI interface, but the driver does not support
+ *  The display also has an SPI interface, but the driver does not support
  *  this yet.
  *
  *  This is a driver allowing you to use a LCD2S 4x20 from Modtronix
diff --git a/drivers/gpu/drm/solomon/ssd130x-spi.c b/drivers/gpu/drm/solomon/ssd130x-spi.c
index 19ab4942cb33..f9e1f10c42a3 100644
--- a/drivers/gpu/drm/solomon/ssd130x-spi.c
+++ b/drivers/gpu/drm/solomon/ssd130x-spi.c
@@ -138,7 +138,7 @@ MODULE_DEVICE_TABLE(of, ssd130x_of_match);
  * if the device was registered via OF. This means that the module will not be
  * auto loaded, unless it contains an alias that matches the MODALIAS reported.
  *
- * To workaround this issue, add a SPI device ID table. Even when this should
+ * To workaround this issue, add an SPI device ID table. Even when this should
  * not be needed for this driver to match the registered SPI devices.
  */
 static const struct spi_device_id ssd130x_spi_table[] = {
diff --git a/drivers/gpu/drm/tiny/ili9486.c b/drivers/gpu/drm/tiny/ili9486.c
index 1bb847466b10..f059369b1f1d 100644
--- a/drivers/gpu/drm/tiny/ili9486.c
+++ b/drivers/gpu/drm/tiny/ili9486.c
@@ -35,7 +35,7 @@
 #define ILI9486_MADCTL_MY       BIT(7)
 
 /*
- * The PiScreen/waveshare rpi-lcd-35 has a SPI to 16-bit parallel bus converter
+ * The PiScreen/waveshare rpi-lcd-35 has an SPI to 16-bit parallel bus converter
  * in front of the  display controller. This means that 8-bit values have to be
  * transferred as 16-bit.
  */
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 5c2d0c06d2a5..4a3f92a59693 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -68,7 +68,7 @@ config INPUT_AD714X_SPI
 	depends on INPUT_AD714X && SPI
 	default y
 	help
-	  Say Y here if you have AD7142/AD7147 hooked to a SPI bus.
+	  Say Y here if you have AD7142/AD7147 hooked to an SPI bus.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called ad714x-spi.
@@ -724,7 +724,7 @@ config INPUT_ADXL34X_SPI
 	depends on INPUT_ADXL34X && SPI
 	default y
 	help
-	  Say Y here if you have ADXL345/6 hooked to a SPI bus.
+	  Say Y here if you have ADXL345/6 hooked to an SPI bus.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called adxl34x-spi.
diff --git a/drivers/input/rmi4/Kconfig b/drivers/input/rmi4/Kconfig
index c0163b983ce6..055819188b3c 100644
--- a/drivers/input/rmi4/Kconfig
+++ b/drivers/input/rmi4/Kconfig
@@ -26,7 +26,7 @@ config RMI4_SPI
 	tristate "RMI4 SPI Support"
 	depends on SPI
 	help
-	  Say Y here if you want to support RMI4 devices connected to a SPI
+	  Say Y here if you want to support RMI4 devices connected to an SPI
 	  bus.
 
 	  If unsure, say N.
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 68d99a112e14..1870ab3aed46 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -82,7 +82,7 @@ config TOUCHSCREEN_AD7879_SPI
 	depends on TOUCHSCREEN_AD7879 && SPI_MASTER
 	select REGMAP_SPI
 	help
-	  Say Y here if you have AD7879-1/AD7889-1 hooked to a SPI bus.
+	  Say Y here if you have AD7879-1/AD7889-1 hooked to an SPI bus.
 
 	  If unsure, say N (but it's safe to say "Y").
 
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 30db49f31866..413e926ecb3c 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -138,7 +138,7 @@ config MFD_ATMEL_FLEXCOM
 	depends on OF
 	help
 	  Select this to get support for Atmel Flexcom. This is a wrapper
-	  which embeds a SPI controller, a I2C controller and a USART. Only
+	  which embeds an SPI controller, a I2C controller and a USART. Only
 	  one function can be used at a time. The choice is done at boot time
 	  by the probe function of this MFD driver according to a device tree
 	  property.
diff --git a/drivers/mfd/ocelot.h b/drivers/mfd/ocelot.h
index b8bc2f1486e2..0a6505edba53 100644
--- a/drivers/mfd/ocelot.h
+++ b/drivers/mfd/ocelot.h
@@ -21,7 +21,7 @@ struct resource;
  *			initialization based on bus speed.
  * @dummy_buf:		Zero-filled buffer of spi_padding_bytes size. The dummy
  *			bytes that will be sent out between the address and
- *			data of a SPI read operation.
+ *			data of an SPI read operation.
  */
 struct ocelot_ddata {
 	struct regmap *gcb_regmap;
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 5e19a961c34d..9cc2ae72b957 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -632,7 +632,7 @@ config MMC_SPI
 	select CRC7
 	select CRC_ITU_T
 	help
-	  Some systems access MMC/SD/SDIO cards using a SPI controller
+	  Some systems access MMC/SD/SDIO cards using an SPI controller
 	  instead of using a "native" MMC/SD/SDIO controller.  This has a
 	  disadvantage of being relatively high overhead, but a compensating
 	  advantage of working on many systems without dedicated MMC/SD/SDIO
diff --git a/drivers/mtd/spi-nor/controllers/Kconfig b/drivers/mtd/spi-nor/controllers/Kconfig
index ca45dcd3ffe8..250295c8d85c 100644
--- a/drivers/mtd/spi-nor/controllers/Kconfig
+++ b/drivers/mtd/spi-nor/controllers/Kconfig
@@ -14,5 +14,5 @@ config SPI_NXP_SPIFI
 	  Enable support for the NXP LPC SPI Flash Interface controller.
 
 	  SPIFI is a specialized controller for connecting serial SPI
-	  Flash. Enable this option if you have a device with a SPIFI
+	  Flash. Enable this option if you have a device with an SPIFI
 	  controller and want to access the Flash as a mtd device.
diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index d67c926bca8b..9fb03bf0202d 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1138,7 +1138,7 @@ int spi_nor_erase_sector(struct spi_nor *nor, u32 addr)
 
 /**
  * spi_nor_div_by_erase_size() - calculate remainder and update new dividend
- * @erase:	pointer to a structure that describes a SPI NOR erase type
+ * @erase:	pointer to a structure that describes an SPI NOR erase type
  * @dividend:	dividend value
  * @remainder:	pointer to u32 remainder (will be updated)
  *
@@ -1159,7 +1159,7 @@ static u64 spi_nor_div_by_erase_size(const struct spi_nor_erase_type *erase,
  *				    which the address fits is expected to be
  *				    provided.
  * @map:	the erase map of the SPI NOR
- * @region:	pointer to a structure that describes a SPI NOR erase region
+ * @region:	pointer to a structure that describes an SPI NOR erase region
  * @addr:	offset in the serial flash memory
  * @len:	number of bytes to erase
  *
@@ -1217,7 +1217,7 @@ static u64 spi_nor_region_end(const struct spi_nor_erase_region *region)
 
 /**
  * spi_nor_region_next() - get the next spi nor region
- * @region:	pointer to a structure that describes a SPI NOR erase region
+ * @region:	pointer to a structure that describes an SPI NOR erase region
  *
  * Return: the next spi nor region or NULL if last region.
  */
@@ -1260,8 +1260,8 @@ spi_nor_find_erase_region(const struct spi_nor_erase_map *map, u64 addr)
 
 /**
  * spi_nor_init_erase_cmd() - initialize an erase command
- * @region:	pointer to a structure that describes a SPI NOR erase region
- * @erase:	pointer to a structure that describes a SPI NOR erase type
+ * @region:	pointer to a structure that describes an SPI NOR erase region
+ * @erase:	pointer to a structure that describes an SPI NOR erase type
  *
  * Return: the pointer to the allocated erase command, ERR_PTR(-errno)
  *	   otherwise.
@@ -2011,8 +2011,8 @@ spi_nor_spimem_adjust_hwcaps(struct spi_nor *nor, u32 *hwcaps)
 }
 
 /**
- * spi_nor_set_erase_type() - set a SPI NOR erase type
- * @erase:	pointer to a structure that describes a SPI NOR erase type
+ * spi_nor_set_erase_type() - set an SPI NOR erase type
+ * @erase:	pointer to a structure that describes an SPI NOR erase type
  * @size:	the size of the sector/block erased by the erase type
  * @opcode:	the SPI command op code to erase the sector/block
  */
diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index f03b55cf7e6f..19b2eaaaea0e 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -189,7 +189,7 @@ enum spi_nor_pp_command_index {
 };
 
 /**
- * struct spi_nor_erase_type - Structure to describe a SPI NOR erase type
+ * struct spi_nor_erase_type - Structure to describe an SPI NOR erase type
  * @size:		the size of the sector/block erased by the erase type.
  *			JEDEC JESD216B imposes erase sizes to be a power of 2.
  * @size_shift:		@size is a power of 2, the shift is stored in
@@ -228,7 +228,7 @@ struct spi_nor_erase_command {
 };
 
 /**
- * struct spi_nor_erase_region - Structure to describe a SPI NOR erase region
+ * struct spi_nor_erase_region - Structure to describe an SPI NOR erase region
  * @offset:		the offset in the data array of erase region start.
  *			LSB bits are used as a bitmask encoding flags to
  *			determine if this region is overlaid, if this region is
diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index 8434f654eca1..dfead627da6b 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -304,7 +304,7 @@ static const struct sfdp_bfpt_erase sfdp_bfpt_erases[] = {
 
 /**
  * spi_nor_set_erase_settings_from_bfpt() - set erase type settings from BFPT
- * @erase:	pointer to a structure that describes a SPI NOR erase type
+ * @erase:	pointer to a structure that describes an SPI NOR erase type
  * @size:	the size of the sector/block erased by the erase type
  * @opcode:	the SPI command op code to erase the sector/block
  * @i:		erase type index as sorted in the Basic Flash Parameter Table
@@ -775,8 +775,8 @@ static void spi_nor_region_mark_overlay(struct spi_nor_erase_region *region)
 
 /**
  * spi_nor_region_check_overlay() - set overlay bit when the region is overlaid
- * @region:	pointer to a structure that describes a SPI NOR erase region
- * @erase:	pointer to a structure that describes a SPI NOR erase type
+ * @region:	pointer to a structure that describes an SPI NOR erase region
+ * @erase:	pointer to a structure that describes an SPI NOR erase type
  * @erase_type:	erase type bitmask
  */
 static void
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 7729d3f8b7f5..4985d3427441 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -71,11 +71,11 @@
  *		  (the switch will read the fields provided in the buffer).
  *	OP_DEL: Set if the manual says the VALIDENT bit is supported in the
  *		COMMAND portion of this dynamic config buffer (i.e. the
- *		specified entry can be invalidated through a SPI write
+ *		specified entry can be invalidated through an SPI write
  *		command).
  *	OP_SEARCH: Set if the manual says that the index of an entry can
  *		   be retrieved in the COMMAND portion of the buffer based
- *		   on its ENTRY portion, as a result of a SPI write command.
+ *		   on its ENTRY portion, as a result of an SPI write command.
  *		   Only the TCAM-based FDB table on SJA1105 P/Q/R/S supports
  *		   this.
  *	OP_VALID_ANYWAY: Reading some tables through the dynamic config
diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethernet/microchip/enc28j60.c
index 176efbeae127..8133ee248c78 100644
--- a/drivers/net/ethernet/microchip/enc28j60.c
+++ b/drivers/net/ethernet/microchip/enc28j60.c
@@ -346,7 +346,7 @@ static void locked_regw_write(struct enc28j60_net *priv, u8 address, u16 data)
 
 /*
  * Buffer memory read
- * Select the starting address and execute a SPI buffer read.
+ * Select the starting address and execute an SPI buffer read.
  */
 static void enc28j60_mem_read(struct enc28j60_net *priv, u16 addr, int len,
 			      u8 *data)
diff --git a/drivers/net/wireless/microchip/wilc1000/Kconfig b/drivers/net/wireless/microchip/wilc1000/Kconfig
index 62cfcdc9aacc..8fb10ce1b5ce 100644
--- a/drivers/net/wireless/microchip/wilc1000/Kconfig
+++ b/drivers/net/wireless/microchip/wilc1000/Kconfig
@@ -31,7 +31,7 @@ config WILC1000_SPI
 	help
 	  This module adds support for the SPI interface of adapters using
 	  WILC1000 chipset. The Atmel WILC1000 has a Serial Peripheral
-	  Interface (SPI) that operates as a SPI slave. This SPI interface can
+	  Interface (SPI) that operates as an SPI slave. This SPI interface can
 	  be used for control and for serial I/O of 802.11 data. The SPI is a
 	  full-duplex slave synchronous serial interface that is available
 	  immediately following reset when pin 9 (SDIO_SPI_CFG) is tied to
diff --git a/drivers/net/wireless/st/cw1200/Kconfig b/drivers/net/wireless/st/cw1200/Kconfig
index 03575e9894bb..f6a1f83e4dd5 100644
--- a/drivers/net/wireless/st/cw1200/Kconfig
+++ b/drivers/net/wireless/st/cw1200/Kconfig
@@ -24,7 +24,7 @@ config CW1200_WLAN_SPI
 	tristate "Support SPI platforms"
 	depends on CW1200 && SPI
 	help
-	  Enables support for the CW1200 connected via a SPI bus.  You will
+	  Enables support for the CW1200 connected via an SPI bus.  You will
 	  need to add appropriate platform data glue in your board setup
 	  file.
 
diff --git a/drivers/platform/chrome/Kconfig b/drivers/platform/chrome/Kconfig
index c1ca247987d2..ba0d4a2f1096 100644
--- a/drivers/platform/chrome/Kconfig
+++ b/drivers/platform/chrome/Kconfig
@@ -115,7 +115,7 @@ config CROS_EC_SPI
 
 	help
 	  If you say Y here, you get support for talking to the ChromeOS EC
-	  through a SPI bus, using a byte-level protocol. Since the EC's
+	  through an SPI bus, using a byte-level protocol. Since the EC's
 	  response time cannot be guaranteed, we support ignoring
 	  'pre-amble' bytes before the response actually starts.
 
diff --git a/drivers/platform/chrome/cros_ec_spi.c b/drivers/platform/chrome/cros_ec_spi.c
index 21143dba8970..f0e793e9a4ce 100644
--- a/drivers/platform/chrome/cros_ec_spi.c
+++ b/drivers/platform/chrome/cros_ec_spi.c
@@ -61,7 +61,7 @@
 #define EC_SPI_RECOVERY_TIME_NS	(200 * 1000)
 
 /**
- * struct cros_ec_spi - information about a SPI-connected EC
+ * struct cros_ec_spi - information about an SPI-connected EC
  *
  * @spi: SPI device we are connected to
  * @last_transfer_ns: time that we last finished a transfer.
diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
index ed9360486953..2c187264b249 100644
--- a/drivers/rtc/rtc-ds1305.c
+++ b/drivers/rtc/rtc-ds1305.c
@@ -701,7 +701,7 @@ static int ds1305_probe(struct spi_device *spi)
 
 	/* Maybe set up alarm IRQ; be ready to handle it triggering right
 	 * away.  NOTE that we don't share this.  The signal is active low,
-	 * and we can't ack it before a SPI message delay.  We temporarily
+	 * and we can't ack it before an SPI message delay.  We temporarily
 	 * disable the IRQ until it's acked, which lets us work with more
 	 * IRQ trigger modes (not all IRQ controllers can do falling edge).
 	 */
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 3b1c0878bb85..64825495c3e1 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -77,7 +77,7 @@ config SPI_ALTERA_DFL
 	help
 	  This is a Device Feature List (DFL) bus driver for the
 	  Altera SPI master controller.  The SPI master is connected
-	  to a SPI slave to Avalon bridge in a Intel MAX BMC.
+	  to an SPI slave to Avalon bridge in a Intel MAX BMC.
 
 config SPI_AR934X
 	tristate "Qualcomm Atheros AR934X/QCA95XX SPI controller driver"
@@ -632,7 +632,7 @@ config SPI_MTK_SNFI
 	help
 	  This enables support for SPI-NAND mode on the MediaTek NAND
 	  Flash Interface found on MediaTek ARM SoCs. This controller
-	  is implemented as a SPI-MEM controller with pipelined ECC
+	  is implemented as an SPI-MEM controller with pipelined ECC
 	  capcability.
 
 config SPI_WPCM_FIU
@@ -765,7 +765,7 @@ config SPI_PXA2XX
 	depends on ARCH_PXA || ARCH_MMP || PCI || ACPI || COMPILE_TEST
 	select PXA_SSP if ARCH_PXA || ARCH_MMP
 	help
-	  This enables using a PXA2xx or Sodaville SSP port as a SPI master
+	  This enables using a PXA2xx or Sodaville SSP port as an SPI master
 	  controller. The driver can be configured to use any SSP port and
 	  additional documentation can be found a Documentation/spi/pxa2xx.rst.
 
@@ -1151,7 +1151,7 @@ config SPI_MUX
 	select MULTIPLEXER
 	help
 	  This adds support for SPI multiplexers. Each SPI mux will be
-	  accessible as a SPI controller, the devices behind the mux will appear
+	  accessible as an SPI controller, the devices behind the mux will appear
 	  to be chip selects on this controller. It is still necessary to
 	  select one or more specific mux-controller drivers.
 
diff --git a/drivers/spi/spi-mem.c b/drivers/spi/spi-mem.c
index 0c79193d9697..cfd1c4fff606 100644
--- a/drivers/spi/spi-mem.c
+++ b/drivers/spi/spi-mem.c
@@ -438,7 +438,7 @@ const char *spi_mem_get_name(struct spi_mem *mem)
 EXPORT_SYMBOL_GPL(spi_mem_get_name);
 
 /**
- * spi_mem_adjust_op_size() - Adjust the data size of a SPI mem operation to
+ * spi_mem_adjust_op_size() - Adjust the data size of an SPI mem operation to
  *			      match controller limitations
  * @mem: the SPI memory
  * @op: the operation to adjust
@@ -886,11 +886,11 @@ static void spi_mem_shutdown(struct spi_device *spi)
 }
 
 /**
- * spi_mem_driver_register_with_owner() - Register a SPI memory driver
+ * spi_mem_driver_register_with_owner() - Register an SPI memory driver
  * @memdrv: the SPI memory driver to register
  * @owner: the owner of this driver
  *
- * Registers a SPI memory driver.
+ * Registers an SPI memory driver.
  *
  * Return: 0 in case of success, a negative error core otherwise.
  */
@@ -907,10 +907,10 @@ int spi_mem_driver_register_with_owner(struct spi_mem_driver *memdrv,
 EXPORT_SYMBOL_GPL(spi_mem_driver_register_with_owner);
 
 /**
- * spi_mem_driver_unregister() - Unregister a SPI memory driver
+ * spi_mem_driver_unregister() - Unregister an SPI memory driver
  * @memdrv: the SPI memory driver to unregister
  *
- * Unregisters a SPI memory driver.
+ * Unregisters an SPI memory driver.
  */
 void spi_mem_driver_unregister(struct spi_mem_driver *memdrv)
 {
diff --git a/drivers/spi/spi-mpc52xx-psc.c b/drivers/spi/spi-mpc52xx-psc.c
index 609311231e64..30015b6bffc4 100644
--- a/drivers/spi/spi-mpc52xx-psc.c
+++ b/drivers/spi/spi-mpc52xx-psc.c
@@ -285,7 +285,7 @@ static int mpc52xx_psc_spi_port_config(int psc_id, struct mpc52xx_psc_spi *mps)
 	out_8(&fifo->rfcntl, 0);
 	out_8(&psc->mode, MPC52xx_PSC_MODE_FFULL);
 
-	/* Configure 8bit codec mode as a SPI master and use EOF flags */
+	/* Configure 8bit codec mode as an SPI master and use EOF flags */
 	/* SICR_SIM_CODEC8|SICR_GENCLK|SICR_SPI|SICR_MSTR|SICR_USEEOF */
 	out_be32(&psc->sicr, 0x0180C800);
 	out_be16((u16 __iomem *)&psc->ccr, 0x070F); /* default SPI Clk 1MHz */
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 15f174f4e056..95da8dafb652 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -470,7 +470,7 @@ struct bus_type spi_bus_type = {
 EXPORT_SYMBOL_GPL(spi_bus_type);
 
 /**
- * __spi_register_driver - register a SPI driver
+ * __spi_register_driver - register an SPI driver
  * @owner: owner module of the driver to register
  * @sdrv: the driver to register
  * Context: can sleep
@@ -3241,7 +3241,7 @@ static void devm_spi_unregister(struct device *dev, void *res)
  *	spi_alloc_slave()
  * Context: can sleep
  *
- * Register a SPI device as with spi_register_controller() which will
+ * Register an SPI device as with spi_register_controller() which will
  * automatically be unregistered and freed.
  *
  * Return: zero on success, else a negative error code.
diff --git a/drivers/staging/fbtft/fbtft.h b/drivers/staging/fbtft/fbtft.h
index 2c2b5f1c1df3..21d07b09fd36 100644
--- a/drivers/staging/fbtft/fbtft.h
+++ b/drivers/staging/fbtft/fbtft.h
@@ -152,7 +152,7 @@ struct fbtft_platform_data {
  * supported by kernel-doc.
  *
  */
-/* @spi: Set if it is a SPI device
+/* @spi: Set if it is an SPI device
  * @pdev: Set if it is a platform device
  * @info: Pointer to framebuffer fb_info structure
  * @pdata: Pointer to platform data
diff --git a/drivers/staging/iio/meter/Kconfig b/drivers/staging/iio/meter/Kconfig
index aa6a3e7f6cdb..316d2589a484 100644
--- a/drivers/staging/iio/meter/Kconfig
+++ b/drivers/staging/iio/meter/Kconfig
@@ -29,7 +29,7 @@ config ADE7854_SPI
 	depends on ADE7854 && SPI
 	default y
 	help
-	  Say Y here if you have ADE7854/58/68/78 hooked to a SPI bus.
+	  Say Y here if you have ADE7854/58/68/78 hooked to an SPI bus.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called ade7854-spi.
diff --git a/drivers/staging/octeon/ethernet-spi.c b/drivers/staging/octeon/ethernet-spi.c
index 699c98c5ec13..f5c58b029349 100644
--- a/drivers/staging/octeon/ethernet-spi.c
+++ b/drivers/staging/octeon/ethernet-spi.c
@@ -175,7 +175,7 @@ static void cvm_oct_spi_poll(struct net_device *dev)
 		if (priv->port == spi4000_port) {
 			/*
 			 * This function does nothing if it is called on an
-			 * interface without a SPI4000.
+			 * interface without an SPI4000.
 			 */
 			cvmx_spi4000_check_speed(interface, priv->port);
 			/*
diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index 352e3ac2b377..6980796f8af2 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -7,7 +7,7 @@
  * (C) Copyright 2014 David Mosberger-Tang <davidm@egauge.net>
  *
  * MAX3421 is a chip implementing a USB 2.0 Full-/Low-Speed host
- * controller on a SPI bus.
+ * controller on an SPI bus.
  *
  * Based on:
  *	o MAX3421E datasheet
diff --git a/include/linux/mtd/spinand.h b/include/linux/mtd/spinand.h
index 6d3392a7edc6..2564de8b6ed3 100644
--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -231,8 +231,8 @@ struct spinand_devid {
 
 /**
  * struct manufacurer_ops - SPI NAND manufacturer specific operations
- * @init: initialize a SPI NAND device
- * @cleanup: cleanup a SPI NAND device
+ * @init: initialize an SPI NAND device
+ * @cleanup: cleanup an SPI NAND device
  *
  * Each SPI NAND manufacturer driver should implement this interface so that
  * NAND chips coming from this vendor can be initialized properly.
@@ -293,7 +293,7 @@ struct spinand_op_variants {
 	}
 
 /**
- * spinand_ecc_info - description of the on-die ECC implemented by a SPI NAND
+ * spinand_ecc_info - description of the on-die ECC implemented by an SPI NAND
  *		      chip
  * @get_status: get the ECC status. Should return a positive number encoding
  *		the number of corrected bitflips if correction was possible or
@@ -462,7 +462,7 @@ static inline struct spinand_device *mtd_to_spinand(struct mtd_info *mtd)
 }
 
 /**
- * spinand_to_mtd() - Get the MTD device embedded in a SPI NAND device
+ * spinand_to_mtd() - Get the MTD device embedded in an SPI NAND device
  * @spinand: SPI NAND device
  *
  * Return: the MTD device embedded in @spinand.
@@ -484,7 +484,7 @@ static inline struct spinand_device *nand_to_spinand(struct nand_device *nand)
 }
 
 /**
- * spinand_to_nand() - Get the NAND device embedded in a SPI NAND object
+ * spinand_to_nand() - Get the NAND device embedded in an SPI NAND object
  * @spinand: SPI NAND device
  *
  * Return: the NAND device embedded in @spinand.
@@ -496,11 +496,11 @@ spinand_to_nand(struct spinand_device *spinand)
 }
 
 /**
- * spinand_set_of_node - Attach a DT node to a SPI NAND device
+ * spinand_set_of_node - Attach a DT node to an SPI NAND device
  * @spinand: SPI NAND device
  * @np: DT node
  *
- * Attach a DT node to a SPI NAND device.
+ * Attach a DT node to an SPI NAND device.
  */
 static inline void spinand_set_of_node(struct spinand_device *spinand,
 				       struct device_node *np)
diff --git a/include/linux/rmi.h b/include/linux/rmi.h
index ab7eea01ab42..3b437ee3905f 100644
--- a/include/linux/rmi.h
+++ b/include/linux/rmi.h
@@ -173,7 +173,7 @@ struct rmi_f01_power_management {
  * SPI mode.
  * @split_read_byte_delay_us - the delay between each byte of a read operation
  * in V2 mode.
- * @pre_delay_us - the delay before the start of a SPI transaction.  This is
+ * @pre_delay_us - the delay before the start of an SPI transaction.  This is
  * typically useful in conjunction with custom chip select assertions (see
  * below).
  * @post_delay_us - the delay after the completion of an SPI transaction.  This
diff --git a/include/linux/spi/spi-mem.h b/include/linux/spi/spi-mem.h
index 8e984d75f5b6..2a9a8a7893ac 100644
--- a/include/linux/spi/spi-mem.h
+++ b/include/linux/spi/spi-mem.h
@@ -56,7 +56,7 @@
 #define SPI_MEM_OP_NO_DATA	{ }
 
 /**
- * enum spi_mem_data_dir - describes the direction of a SPI memory data
+ * enum spi_mem_data_dir - describes the direction of an SPI memory data
  *			   transfer from the controller perspective
  * @SPI_MEM_NO_DATA: no data transferred
  * @SPI_MEM_DATA_IN: data coming from the SPI memory
@@ -69,7 +69,7 @@ enum spi_mem_data_dir {
 };
 
 /**
- * struct spi_mem_op - describes a SPI memory operation
+ * struct spi_mem_op - describes an SPI memory operation
  * @cmd.nbytes: number of opcode bytes (only 1 or 2 are valid). The opcode is
  *		sent MSB-first.
  * @cmd.buswidth: number of IO lines used to transmit the command
@@ -182,7 +182,7 @@ struct spi_mem_dirmap_desc {
 };
 
 /**
- * struct spi_mem - describes a SPI memory device
+ * struct spi_mem - describes an SPI memory device
  * @spi: the underlying SPI device
  * @drvpriv: spi_mem_driver private data
  * @name: name of the SPI memory device
@@ -200,7 +200,7 @@ struct spi_mem {
 };
 
 /**
- * struct spi_mem_set_drvdata() - attach driver private data to a SPI mem
+ * struct spi_mem_set_drvdata() - attach driver private data to an SPI mem
  *				  device
  * @mem: memory device
  * @data: data to attach to the memory device
@@ -211,7 +211,7 @@ static inline void spi_mem_set_drvdata(struct spi_mem *mem, void *data)
 }
 
 /**
- * struct spi_mem_get_drvdata() - get driver private data attached to a SPI mem
+ * struct spi_mem_get_drvdata() - get driver private data attached to an SPI mem
  *				  device
  * @mem: memory device
  *
@@ -228,7 +228,7 @@ static inline void *spi_mem_get_drvdata(struct spi_mem *mem)
  *		    limitations (can be alignment or max RX/TX size
  *		    limitations)
  * @supports_op: check if an operation is supported by the controller
- * @exec_op: execute a SPI memory operation
+ * @exec_op: execute an SPI memory operation
  * @get_name: get a custom name for the SPI mem device from the controller.
  *	      This might be needed if the controller driver has been ported
  *	      to use the SPI mem layer and a custom name is used to keep
@@ -302,10 +302,10 @@ struct spi_controller_mem_caps {
 
 /**
  * struct spi_mem_driver - SPI memory driver
- * @spidrv: inherit from a SPI driver
- * @probe: probe a SPI memory. Usually where detection/initialization takes
+ * @spidrv: inherit from an SPI driver
+ * @probe: probe an SPI memory. Usually where detection/initialization takes
  *	   place
- * @remove: remove a SPI memory
+ * @remove: remove an SPI memory
  * @shutdown: take appropriate action when the system is shutdown
  *
  * This is just a thin wrapper around a spi_driver. The core takes care of
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 9a32495fbb1f..debe88fdaddb 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -279,7 +279,7 @@ struct spi_message;
  *	field of this structure.
  *
  * This represents the kind of device driver that uses SPI messages to
- * interact with the hardware at the other end of a SPI link.  It's called
+ * interact with the hardware at the other end of an SPI link.  It's called
  * a "protocol" driver because it works through messages rather than talking
  * directly to SPI hardware (which is what the underlying SPI controller
  * driver does to pass those messages).  These protocols are defined in the
@@ -323,7 +323,7 @@ extern struct spi_device *spi_new_ancillary_device(struct spi_device *spi, u8 ch
 	__spi_register_driver(THIS_MODULE, driver)
 
 /**
- * module_spi_driver() - Helper macro for registering a SPI driver
+ * module_spi_driver() - Helper macro for registering an SPI driver
  * @__spi_driver: spi_driver struct
  *
  * Helper macro for SPI drivers which do not do anything special in module
@@ -839,7 +839,7 @@ int acpi_spi_count_resources(struct acpi_device *adev);
 #endif
 
 /*
- * SPI resource management while processing a SPI message
+ * SPI resource management while processing an SPI message
  */
 
 typedef void (*spi_res_release_t)(struct spi_controller *ctlr,
@@ -1454,7 +1454,7 @@ static inline ssize_t spi_w8r16be(struct spi_device *spi, u8 cmd)
  */
 
 /**
- * struct spi_board_info - board-specific template for a SPI device
+ * struct spi_board_info - board-specific template for an SPI device
  * @modalias: Initializes spi_device.modalias; identifies the driver.
  * @platform_data: Initializes spi_device.platform_data; the particular
  *	data stored there is driver-specific.
-- 
2.34.1

