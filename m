Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DDE58DC0E
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 18:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245132AbiHIQ2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 12:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245072AbiHIQ2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 12:28:19 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A285921822
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 09:28:07 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id c17so17719319lfb.3
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 09:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qhv9k0TbYNDlEH5wJV2m/URwiIcfUYBdwGvhAbNRhYc=;
        b=EiKupjYynxiyS9Uwk2mNnJzzAIT3urs5FtysK2HK54pytgUUl2otaC9r8FRiN8VPbk
         Jg4kBYK52Zx6R1aldTuV+4G13ygwtq+o+I5wCerQAk9lhqr1ohdkDMKKM6f6Rzhi468v
         oen26vYiW/DLmKbM5XYQ8exGEnzaRdGf9OzchwXf9iSJt2lnDmO6Rj+K2P88++GHE1ND
         XNBDXn11cLAk9bDVKhCDUCi5CYkV29cETrv5/u780v23Ve7ZMl5o9HAW0Ntg3/Ucoze8
         rSSzeIjHfN8XIgrwVoGvcC6uqrPJIRuEvFSjx0+SuKpI2nd7xRYv2GFWsegu2CKHRLAf
         UXpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qhv9k0TbYNDlEH5wJV2m/URwiIcfUYBdwGvhAbNRhYc=;
        b=QlNecloDgrIHBAiRb5whsLdXEd0Jedwz51B5CMDsiKFBepZLnhm8MxPsafem5zAB4m
         0n/agc4+NTaYXgFOPd6bTTeqYC04FImvLQlyjXhr1mPbLR+9rO/n/l/15YNHQexGDRrP
         cDVLpTbkH+D7GY1U/+UrwSvslq5HV5wBrNrkoADP+9ysmr/MT4XeLtK8O0rZjAd3opa6
         QdfrfU+5R6EemWvziP6XpnwGGWaua30Y+gpS90atdtw7KFIHpndOOF8t5gh1kPVZV3A7
         benHI86yNG6V/aFIFkStw71vcZRxxTqF0mDzButODFKpHtKX7kE/qAdNa4YJSONqlj+m
         ipzw==
X-Gm-Message-State: ACgBeo398C+JMpKwmalGB8U1sq+KR+MaPb4huxStkiwUKg0e/RAM9dR5
        GghCzPQirThF8yN3rxPd8/JdmQ==
X-Google-Smtp-Source: AA6agR42hKIYpkLWqFJZdS65VukpL2Tjqz72YTDDKxz0IV0ext6Zf4qjr7mf1IyY+1bUCOW+Rgo/wg==
X-Received: by 2002:a05:6512:690:b0:48b:beb:9868 with SMTP id t16-20020a056512069000b0048b0beb9868mr8021822lfe.541.1660062485452;
        Tue, 09 Aug 2022 09:28:05 -0700 (PDT)
Received: from localhost.localdomain ([83.146.140.105])
        by smtp.gmail.com with ESMTPSA id h7-20020ac24d27000000b0048a8c907fe9sm20999lfk.167.2022.08.09.09.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 09:28:04 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Michael Hennerich <Michael.Hennerich@analog.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pavel Machek <pavel@ucw.cz>,
        Tim Harvey <tharvey@gateworks.com>, Lee Jones <lee@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Reichel <sre@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Andrew Davis <afd@ti.com>,
        linux-hwmon@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2 5/5] dt-bindings: Drop Dan Murphy and Ricardo Rivera-Matos
Date:   Tue,  9 Aug 2022 19:27:52 +0300
Message-Id: <20220809162752.10186-6-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220809162752.10186-1-krzysztof.kozlowski@linaro.org>
References: <20220809162752.10186-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Emails to Dan Murphy and Ricardo Rivera-Matos bounce ("550 Invalid
recipient").  Andrew Davis agreed to take over the bindings.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Changes since v1:
1. Add Andrew Davis instead.
2. Not adding accumulated ack due to change above.
---
 Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml    | 2 +-
 .../devicetree/bindings/leds/leds-class-multicolor.yaml        | 2 +-
 Documentation/devicetree/bindings/leds/leds-lp50xx.yaml        | 2 +-
 Documentation/devicetree/bindings/net/ti,dp83822.yaml          | 2 +-
 Documentation/devicetree/bindings/net/ti,dp83867.yaml          | 2 +-
 Documentation/devicetree/bindings/net/ti,dp83869.yaml          | 2 +-
 Documentation/devicetree/bindings/power/supply/bq2515x.yaml    | 3 +--
 Documentation/devicetree/bindings/power/supply/bq256xx.yaml    | 2 +-
 Documentation/devicetree/bindings/power/supply/bq25980.yaml    | 3 +--
 Documentation/devicetree/bindings/sound/tas2562.yaml           | 2 +-
 Documentation/devicetree/bindings/sound/tlv320adcx140.yaml     | 2 +-
 11 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml b/Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml
index 9f5e96439c01..2e6abc9d746a 100644
--- a/Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Texas Instruments' ads124s08 and ads124s06 ADC chip
 
 maintainers:
-  - Dan Murphy <dmurphy@ti.com>
+  - Andrew Davis <afd@ti.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml b/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
index 12693483231f..31840e33dcf5 100644
--- a/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
+++ b/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Common properties for the multicolor LED class.
 
 maintainers:
-  - Dan Murphy <dmurphy@ti.com>
+  - Andrew Davis <afd@ti.com>
 
 description: |
   Bindings for multi color LEDs show how to describe current outputs of
diff --git a/Documentation/devicetree/bindings/leds/leds-lp50xx.yaml b/Documentation/devicetree/bindings/leds/leds-lp50xx.yaml
index e0b658f07973..63da380748bf 100644
--- a/Documentation/devicetree/bindings/leds/leds-lp50xx.yaml
+++ b/Documentation/devicetree/bindings/leds/leds-lp50xx.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: LED driver for LP50XX RGB LED from Texas Instruments.
 
 maintainers:
-  - Dan Murphy <dmurphy@ti.com>
+  - Andrew Davis <afd@ti.com>
 
 description: |
   The LP50XX is multi-channel, I2C RGB LED Drivers that can group RGB LEDs into
diff --git a/Documentation/devicetree/bindings/net/ti,dp83822.yaml b/Documentation/devicetree/bindings/net/ti,dp83822.yaml
index 75e8712e903a..f2489a9c852f 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83822.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83822.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: TI DP83822 ethernet PHY
 
 maintainers:
-  - Dan Murphy <dmurphy@ti.com>
+  - Andrew Davis <afd@ti.com>
 
 description: |
   The DP83822 is a low-power, single-port, 10/100 Mbps Ethernet PHY. It
diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.yaml b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
index 76ff08a477ba..b8c0e4b5b494 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83867.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
@@ -11,7 +11,7 @@ allOf:
   - $ref: "ethernet-controller.yaml#"
 
 maintainers:
-  - Dan Murphy <dmurphy@ti.com>
+  - Andrew Davis <afd@ti.com>
 
 description: |
   The DP83867 device is a robust, low power, fully featured Physical Layer
diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
index 1b780dce61ab..b04ff0014a59 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83869.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
@@ -11,7 +11,7 @@ allOf:
   - $ref: "ethernet-phy.yaml#"
 
 maintainers:
-  - Dan Murphy <dmurphy@ti.com>
+  - Andrew Davis <afd@ti.com>
 
 description: |
   The DP83869HM device is a robust, fully-featured Gigabit (PHY) transceiver
diff --git a/Documentation/devicetree/bindings/power/supply/bq2515x.yaml b/Documentation/devicetree/bindings/power/supply/bq2515x.yaml
index 27db38577822..1a1b240034ef 100644
--- a/Documentation/devicetree/bindings/power/supply/bq2515x.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq2515x.yaml
@@ -8,8 +8,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: TI bq2515x 500-mA Linear charger family
 
 maintainers:
-  - Dan Murphy <dmurphy@ti.com>
-  - Ricardo Rivera-Matos <r-rivera-matos@ti.com>
+  - Andrew Davis <afd@ti.com>
 
 description: |
   The BQ2515x family is a highly integrated battery charge management IC that
diff --git a/Documentation/devicetree/bindings/power/supply/bq256xx.yaml b/Documentation/devicetree/bindings/power/supply/bq256xx.yaml
index 91abe5733c41..82f382a7ffb3 100644
--- a/Documentation/devicetree/bindings/power/supply/bq256xx.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq256xx.yaml
@@ -8,7 +8,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: TI bq256xx Switch Mode Buck Charger
 
 maintainers:
-  - Ricardo Rivera-Matos <r-rivera-matos@ti.com>
+  - Andrew Davis <afd@ti.com>
 
 description: |
   The bq256xx devices are a family of highly-integrated battery charge
diff --git a/Documentation/devicetree/bindings/power/supply/bq25980.yaml b/Documentation/devicetree/bindings/power/supply/bq25980.yaml
index 4883527ab5c7..b687b8bcd705 100644
--- a/Documentation/devicetree/bindings/power/supply/bq25980.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq25980.yaml
@@ -8,8 +8,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: TI BQ25980 Flash Charger
 
 maintainers:
-  - Dan Murphy <dmurphy@ti.com>
-  - Ricardo Rivera-Matos <r-rivera-matos@ti.com>
+  - Andrew Davis <afd@ti.com>
 
 description: |
   The BQ25980, BQ25975, and BQ25960 are a series of flash chargers intended
diff --git a/Documentation/devicetree/bindings/sound/tas2562.yaml b/Documentation/devicetree/bindings/sound/tas2562.yaml
index 5f7dd5d6cbca..30f6b029ac08 100644
--- a/Documentation/devicetree/bindings/sound/tas2562.yaml
+++ b/Documentation/devicetree/bindings/sound/tas2562.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Texas Instruments TAS2562 Smart PA
 
 maintainers:
-  - Dan Murphy <dmurphy@ti.com>
+  - Andrew Davis <afd@ti.com>
 
 description: |
   The TAS2562 is a mono, digital input Class-D audio amplifier optimized for
diff --git a/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml b/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
index bc2fb1a80ed7..ee698614862e 100644
--- a/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
+++ b/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
@@ -8,7 +8,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Texas Instruments TLV320ADCX140 Quad Channel Analog-to-Digital Converter
 
 maintainers:
-  - Dan Murphy <dmurphy@ti.com>
+  - Andrew Davis <afd@ti.com>
 
 description: |
   The TLV320ADCX140 are multichannel (4-ch analog recording or 8-ch digital
-- 
2.34.1

