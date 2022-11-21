Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65F9631F43
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiKULHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiKULGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:06:49 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82968AEA61
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:06:24 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id g12so18305196lfh.3
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WWhVscdioJN/cEHs4ipvczCnfx2VKdpPaEhWUzL9tgY=;
        b=TcXsdn3Qtm9pSsZpB4uyZ+VKiUjBNjjrnjV/LhDDleQh2kOlS8ua8NIT/WS+2XcLWf
         S90IuNT/oahtqVTPCgt/ydRob/wMJfugZYb1Poz5eGmnv56iFPkjPy0BtmoZ3jOmR/f3
         ApGVYbleUz57OTf+/hnwcVDgiT/GChfiPbV062XHKTc7PGsIkwNzIar8U+9Q2dSkqyYq
         AemGQPHF1Eua9KXqxCovwdVa/1l1++bId1c0aA2VsV2PBGjXEeQv8G79blofw4eW7znJ
         Ua2kT+bU6KQ6ats+S4YHbuaDJyq0AyNAUnwrmmUFLUH0zxcwBejyaCDbZ0hg5nFy6VeH
         qgcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WWhVscdioJN/cEHs4ipvczCnfx2VKdpPaEhWUzL9tgY=;
        b=L/1Yf+7Jt8Q1IDudJLdkYeIjhJRvUGHe7x5VdckTj46Wtjndowd0Bh+c7x2aXH0WAk
         rguyn/NRg0mtqnn6aY07hV2Xjg96aNFW3PPucddiayHV138ThMqwVt2Dl/iAs4gclXoc
         ERDXaTyMIzZz4MS9GFU779ozHU1/iCv0Fdtw8/pKGYc8UgXxtlDqH01PG2jGS2epKmAr
         Kw8vsMVzljHckGyjOtWslqsk5IWvK/He9RD2+23rXJLM0x0u78DjAh6HqnKnsn6Ubhf8
         kdpoH5hJPH5Zbt7b/sh5xUr1tCR/CJPBOz/KfDuh3O/lugEopMuLoAz0NJ7kzokkJweV
         vbsQ==
X-Gm-Message-State: ANoB5plfXmg/RkDNXpZFRz3bkrQP6oCoNkEfCK3GSA2u0lhsKMIU/s6s
        f/Mbkaho/9MMAsjqvSPVVtryyw==
X-Google-Smtp-Source: AA0mqf4QLih8RM/9VdAlECwB7C0VVn0R/fZFDhHCIfnJRYNFZz8wQfEvOoAnqnW2HmRxfMhxIxldJw==
X-Received: by 2002:a05:6512:118d:b0:4a6:c596:6ffd with SMTP id g13-20020a056512118d00b004a6c5966ffdmr1392886lfr.427.1669028782210;
        Mon, 21 Nov 2022 03:06:22 -0800 (PST)
Received: from krzk-bin.NAT.warszawa.vectranet.pl (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id n1-20020a05651203e100b0049313f77755sm1991521lfq.213.2022.11.21.03.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 03:06:21 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-watchdog@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH v2 1/9] dt-bindings: drop redundant part of title of shared bindings
Date:   Mon, 21 Nov 2022 12:06:07 +0100
Message-Id: <20221121110615.97962-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
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

The Devicetree bindings document does not have to say in the title that
it is a "binding", but instead just describe the hardware.  For shared
(re-usable) schemas, name them all as "common properties".

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Guenter Roeck <linux@roeck-us.net> # watchdog
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> # IIO
Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 Documentation/devicetree/bindings/clock/qcom,gcc.yaml           | 2 +-
 Documentation/devicetree/bindings/dma/dma-common.yaml           | 2 +-
 Documentation/devicetree/bindings/dma/dma-controller.yaml       | 2 +-
 Documentation/devicetree/bindings/dma/dma-router.yaml           | 2 +-
 Documentation/devicetree/bindings/iio/adc/adc.yaml              | 2 +-
 Documentation/devicetree/bindings/input/input.yaml              | 2 +-
 .../devicetree/bindings/media/video-interface-devices.yaml      | 2 +-
 Documentation/devicetree/bindings/media/video-interfaces.yaml   | 2 +-
 Documentation/devicetree/bindings/mmc/mmc-controller.yaml       | 2 +-
 Documentation/devicetree/bindings/mtd/nand-chip.yaml            | 2 +-
 Documentation/devicetree/bindings/mtd/nand-controller.yaml      | 2 +-
 .../devicetree/bindings/net/bluetooth/bluetooth-controller.yaml | 2 +-
 Documentation/devicetree/bindings/net/can/can-controller.yaml   | 2 +-
 Documentation/devicetree/bindings/net/ethernet-controller.yaml  | 2 +-
 Documentation/devicetree/bindings/net/ethernet-phy.yaml         | 2 +-
 Documentation/devicetree/bindings/net/mdio.yaml                 | 2 +-
 Documentation/devicetree/bindings/opp/opp-v2-base.yaml          | 2 +-
 .../devicetree/bindings/power/reset/restart-handler.yaml        | 2 +-
 Documentation/devicetree/bindings/rtc/rtc.yaml                  | 2 +-
 .../devicetree/bindings/soundwire/soundwire-controller.yaml     | 2 +-
 Documentation/devicetree/bindings/spi/spi-controller.yaml       | 2 +-
 Documentation/devicetree/bindings/watchdog/watchdog.yaml        | 2 +-
 22 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc.yaml
index 1ab416c83c8d..7129fbcf2b6c 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Common Bindings
+title: Qualcomm Global Clock & Reset Controller Common Properties
 
 maintainers:
   - Stephen Boyd <sboyd@kernel.org>
diff --git a/Documentation/devicetree/bindings/dma/dma-common.yaml b/Documentation/devicetree/bindings/dma/dma-common.yaml
index ad06d36af208..ea700f8ee6c6 100644
--- a/Documentation/devicetree/bindings/dma/dma-common.yaml
+++ b/Documentation/devicetree/bindings/dma/dma-common.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/dma/dma-common.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: DMA Engine Generic Binding
+title: DMA Engine Common Properties
 
 maintainers:
   - Vinod Koul <vkoul@kernel.org>
diff --git a/Documentation/devicetree/bindings/dma/dma-controller.yaml b/Documentation/devicetree/bindings/dma/dma-controller.yaml
index 6d3727267fa8..538ebadff652 100644
--- a/Documentation/devicetree/bindings/dma/dma-controller.yaml
+++ b/Documentation/devicetree/bindings/dma/dma-controller.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/dma/dma-controller.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: DMA Controller Generic Binding
+title: DMA Controller Common Properties
 
 maintainers:
   - Vinod Koul <vkoul@kernel.org>
diff --git a/Documentation/devicetree/bindings/dma/dma-router.yaml b/Documentation/devicetree/bindings/dma/dma-router.yaml
index 4b817f5dc30e..f8d8c3c88bcc 100644
--- a/Documentation/devicetree/bindings/dma/dma-router.yaml
+++ b/Documentation/devicetree/bindings/dma/dma-router.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/dma/dma-router.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: DMA Router Generic Binding
+title: DMA Router Common Properties
 
 maintainers:
   - Vinod Koul <vkoul@kernel.org>
diff --git a/Documentation/devicetree/bindings/iio/adc/adc.yaml b/Documentation/devicetree/bindings/iio/adc/adc.yaml
index db348fcbb52c..261601729745 100644
--- a/Documentation/devicetree/bindings/iio/adc/adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/adc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/iio/adc/adc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Generic IIO bindings for ADC channels
+title: IIO Common Properties for ADC Channels
 
 maintainers:
   - Jonathan Cameron <jic23@kernel.org>
diff --git a/Documentation/devicetree/bindings/input/input.yaml b/Documentation/devicetree/bindings/input/input.yaml
index 17512f4347fd..94f7942189e8 100644
--- a/Documentation/devicetree/bindings/input/input.yaml
+++ b/Documentation/devicetree/bindings/input/input.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/input.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Common input schema binding
+title: Input Devices Common Properties
 
 maintainers:
   - Dmitry Torokhov <dmitry.torokhov@gmail.com>
diff --git a/Documentation/devicetree/bindings/media/video-interface-devices.yaml b/Documentation/devicetree/bindings/media/video-interface-devices.yaml
index 4527f56a5a6e..cf7712ad297c 100644
--- a/Documentation/devicetree/bindings/media/video-interface-devices.yaml
+++ b/Documentation/devicetree/bindings/media/video-interface-devices.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/media/video-interface-devices.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Common bindings for video receiver and transmitter devices
+title: Common Properties for Video Receiver and Transmitter Devices
 
 maintainers:
   - Jacopo Mondi <jacopo@jmondi.org>
diff --git a/Documentation/devicetree/bindings/media/video-interfaces.yaml b/Documentation/devicetree/bindings/media/video-interfaces.yaml
index 68c3b9871cf3..8a7162ce34f6 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.yaml
+++ b/Documentation/devicetree/bindings/media/video-interfaces.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/media/video-interfaces.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Common bindings for video receiver and transmitter interface endpoints
+title: Common Properties for Video Receiver and Transmitter Interface Endpoints
 
 maintainers:
   - Sakari Ailus <sakari.ailus@linux.intel.com>
diff --git a/Documentation/devicetree/bindings/mmc/mmc-controller.yaml b/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
index 802e3ca8be4d..613095a3d19d 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
+++ b/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mmc/mmc-controller.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: MMC Controller Generic Binding
+title: MMC Controller Common Properties
 
 maintainers:
   - Ulf Hansson <ulf.hansson@linaro.org>
diff --git a/Documentation/devicetree/bindings/mtd/nand-chip.yaml b/Documentation/devicetree/bindings/mtd/nand-chip.yaml
index 6e2dc025d694..33d079f76c05 100644
--- a/Documentation/devicetree/bindings/mtd/nand-chip.yaml
+++ b/Documentation/devicetree/bindings/mtd/nand-chip.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mtd/nand-chip.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: NAND Chip and NAND Controller Generic Binding
+title: NAND Chip Common Properties
 
 maintainers:
   - Miquel Raynal <miquel.raynal@bootlin.com>
diff --git a/Documentation/devicetree/bindings/mtd/nand-controller.yaml b/Documentation/devicetree/bindings/mtd/nand-controller.yaml
index 220aa2c8c0b5..efcd415f8641 100644
--- a/Documentation/devicetree/bindings/mtd/nand-controller.yaml
+++ b/Documentation/devicetree/bindings/mtd/nand-controller.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mtd/nand-controller.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: NAND Chip and NAND Controller Generic Binding
+title: NAND Controller Common Properties
 
 maintainers:
   - Miquel Raynal <miquel.raynal@bootlin.com>
diff --git a/Documentation/devicetree/bindings/net/bluetooth/bluetooth-controller.yaml b/Documentation/devicetree/bindings/net/bluetooth/bluetooth-controller.yaml
index 9309dc40f54f..59bb0d7e8ab3 100644
--- a/Documentation/devicetree/bindings/net/bluetooth/bluetooth-controller.yaml
+++ b/Documentation/devicetree/bindings/net/bluetooth/bluetooth-controller.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/bluetooth/bluetooth-controller.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bluetooth Controller Generic Binding
+title: Bluetooth Controller Common Properties
 
 maintainers:
   - Marcel Holtmann <marcel@holtmann.org>
diff --git a/Documentation/devicetree/bindings/net/can/can-controller.yaml b/Documentation/devicetree/bindings/net/can/can-controller.yaml
index 1f0e98051074..217be90960e8 100644
--- a/Documentation/devicetree/bindings/net/can/can-controller.yaml
+++ b/Documentation/devicetree/bindings/net/can/can-controller.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/can/can-controller.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: CAN Controller Generic Binding
+title: CAN Controller Common Properties
 
 maintainers:
   - Marc Kleine-Budde <mkl@pengutronix.de>
diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 3aef506fa158..00be387984ac 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/ethernet-controller.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Ethernet Controller Generic Binding
+title: Ethernet Controller Common Properties
 
 maintainers:
   - David S. Miller <davem@davemloft.net>
diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index ad808e9ce5b9..1327b81f15a2 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/ethernet-phy.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Ethernet PHY Generic Binding
+title: Ethernet PHY Common Properties
 
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
index b5706d4e7e38..a266ade918ca 100644
--- a/Documentation/devicetree/bindings/net/mdio.yaml
+++ b/Documentation/devicetree/bindings/net/mdio.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/mdio.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: MDIO Bus Generic Binding
+title: MDIO Bus Common Properties
 
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
diff --git a/Documentation/devicetree/bindings/opp/opp-v2-base.yaml b/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
index cf9c2f7bddc2..47e6f36b7637 100644
--- a/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
+++ b/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/opp/opp-v2-base.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Generic OPP (Operating Performance Points) Common Binding
+title: Generic OPP (Operating Performance Points) Common Properties
 
 maintainers:
   - Viresh Kumar <viresh.kumar@linaro.org>
diff --git a/Documentation/devicetree/bindings/power/reset/restart-handler.yaml b/Documentation/devicetree/bindings/power/reset/restart-handler.yaml
index 1f9a2aac53c0..378b404af7fd 100644
--- a/Documentation/devicetree/bindings/power/reset/restart-handler.yaml
+++ b/Documentation/devicetree/bindings/power/reset/restart-handler.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/power/reset/restart-handler.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Restart and shutdown handler generic binding
+title: Restart and Shutdown Handler Common Properties
 
 maintainers:
   - Sebastian Reichel <sre@kernel.org>
diff --git a/Documentation/devicetree/bindings/rtc/rtc.yaml b/Documentation/devicetree/bindings/rtc/rtc.yaml
index 0ec3551f12dd..c6fff5486fe6 100644
--- a/Documentation/devicetree/bindings/rtc/rtc.yaml
+++ b/Documentation/devicetree/bindings/rtc/rtc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/rtc/rtc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: RTC Generic Binding
+title: Real Time Clock Common Properties
 
 maintainers:
   - Alexandre Belloni <alexandre.belloni@bootlin.com>
diff --git a/Documentation/devicetree/bindings/soundwire/soundwire-controller.yaml b/Documentation/devicetree/bindings/soundwire/soundwire-controller.yaml
index 4aad121eff3f..fdeb8af417d7 100644
--- a/Documentation/devicetree/bindings/soundwire/soundwire-controller.yaml
+++ b/Documentation/devicetree/bindings/soundwire/soundwire-controller.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/soundwire/soundwire-controller.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: SoundWire Controller Generic Binding
+title: SoundWire Controller Common Properties
 
 maintainers:
   - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
diff --git a/Documentation/devicetree/bindings/spi/spi-controller.yaml b/Documentation/devicetree/bindings/spi/spi-controller.yaml
index 01042a7f382e..5a7c72cadf76 100644
--- a/Documentation/devicetree/bindings/spi/spi-controller.yaml
+++ b/Documentation/devicetree/bindings/spi/spi-controller.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/spi/spi-controller.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: SPI Controller Generic Binding
+title: SPI Controller Common Properties
 
 maintainers:
   - Mark Brown <broonie@kernel.org>
diff --git a/Documentation/devicetree/bindings/watchdog/watchdog.yaml b/Documentation/devicetree/bindings/watchdog/watchdog.yaml
index e3dfb02f0ca5..fccae0d00110 100644
--- a/Documentation/devicetree/bindings/watchdog/watchdog.yaml
+++ b/Documentation/devicetree/bindings/watchdog/watchdog.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/watchdog/watchdog.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Watchdog Generic Bindings
+title: Watchdog Common Properties
 
 maintainers:
   - Guenter Roeck <linux@roeck-us.net>
-- 
2.34.1

