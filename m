Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2D95189E4
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 18:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239581AbiECQbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 12:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239563AbiECQbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 12:31:15 -0400
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008BE25C79;
        Tue,  3 May 2022 09:27:41 -0700 (PDT)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-e5e433d66dso17664811fac.5;
        Tue, 03 May 2022 09:27:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z4lfkT14v7bT6nOHk8qi3JK/y5icAT3Ixmbs9ZwWf20=;
        b=RRupuWp0zUMuOzdXWOAh7J3UzzrAhbf63HlHh7EQQhSQnRGQuIDlcKn/jZ8XUBn+qy
         ko0/B3nHEyowEvXY7JZu+Ax2ZuIaKXUxr4XJSsrXuHg6Tgln1bNoSp/2z0NWAKQiiFrY
         KfJWphn2B/Hvd6rHjQ2AmL0hegNfWcsKFS7YoXht3N3z671hbgUOYOfTSd64531YxoHl
         nAu/RqucfJLWWA9WOOakuDsLs4ND0twk1G/3RvkQiam+0qlPKkis3HwMayziuow1E6P9
         VrRPLwUMzr4vjsm2Rs576NtSaEgXBj4rnZtg2bYe28tr0G+Xc581FSuWs7ylfmDJbBKP
         /rfA==
X-Gm-Message-State: AOAM531oteD3VNarryIxZP854wUWX6GpBjv29iuSsoQjcxK0nuvq4Xkn
        RFaxUIMwzWAhSHo55EjGeiMRgp5evQ==
X-Google-Smtp-Source: ABdhPJxosiUao6mZmrnywdAC67g7+Z55T6+662lrbDbqPM70zNW74nFLdhWk6CR81pTdruoCl/wasA==
X-Received: by 2002:a05:6870:618e:b0:e5:c2f3:e009 with SMTP id a14-20020a056870618e00b000e5c2f3e009mr2067802oah.10.1651595260866;
        Tue, 03 May 2022 09:27:40 -0700 (PDT)
Received: from xps15.. (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.googlemail.com with ESMTPSA id m63-20020aca5842000000b00325cda1ff9esm3478258oib.29.2022.05.03.09.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 09:27:40 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc:     Abel Vesa <abel.vesa@nxp.com>, Stephen Boyd <sboyd@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Anson Huang <Anson.Huang@nxp.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Han Xu <han.xu@nxp.com>, Dario Binacchi <dariobin@libero.it>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Ripard <mripard@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-iio@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-pm@vger.kernel.org
Subject: [PATCH] dt-bindings: Drop redundant 'maxItems/minItems' in if/then schemas
Date:   Tue,  3 May 2022 11:27:38 -0500
Message-Id: <20220503162738.3827041-1-robh@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another round of removing redundant minItems/maxItems when 'items' list is
specified. This time it is in if/then schemas as the meta-schema was
failing to check this case.

If a property has an 'items' list, then a 'minItems' or 'maxItems' with the
same size as the list is redundant and can be dropped. Note that is DT
schema specific behavior and not standard json-schema behavior. The tooling
will fixup the final schema adding any unspecified minItems/maxItems.

Cc: Abel Vesa <abel.vesa@nxp.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Jonathan Hunter <jonathanh@nvidia.com>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: "Niklas Söderlund" <niklas.soderlund@ragnatech.se>
Cc: Anson Huang <Anson.Huang@nxp.com>
Cc: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Cc: Han Xu <han.xu@nxp.com>
Cc: Dario Binacchi <dariobin@libero.it>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-clk@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-iio@vger.kernel.org
Cc: linux-mmc@vger.kernel.org
Cc: linux-mtd@lists.infradead.org
Cc: linux-can@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-phy@lists.infradead.org
Cc: linux-rtc@vger.kernel.org
Cc: linux-serial@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Cc: linux-pm@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../bindings/clock/imx8m-clock.yaml           |  4 ----
 .../bindings/display/bridge/renesas,lvds.yaml |  4 ----
 .../bindings/display/renesas,du.yaml          | 23 -------------------
 .../bindings/iio/adc/st,stm32-adc.yaml        |  2 --
 .../bindings/mmc/nvidia,tegra20-sdhci.yaml    |  7 +-----
 .../devicetree/bindings/mtd/gpmi-nand.yaml    |  2 --
 .../bindings/net/can/bosch,c_can.yaml         |  3 ---
 .../bindings/phy/brcm,sata-phy.yaml           | 10 ++++----
 .../bindings/rtc/allwinner,sun6i-a31-rtc.yaml | 10 --------
 .../bindings/serial/samsung_uart.yaml         |  4 ----
 .../sound/allwinner,sun4i-a10-i2s.yaml        |  1 -
 .../bindings/sound/ti,j721e-cpb-audio.yaml    |  2 --
 .../bindings/thermal/rcar-gen3-thermal.yaml   |  1 -
 13 files changed, 5 insertions(+), 68 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/imx8m-clock.yaml b/Documentation/devicetree/bindings/clock/imx8m-clock.yaml
index 625f573a7b90..458c7645ee68 100644
--- a/Documentation/devicetree/bindings/clock/imx8m-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx8m-clock.yaml
@@ -55,8 +55,6 @@ allOf:
     then:
       properties:
         clocks:
-          minItems: 7
-          maxItems: 7
           items:
             - description: 32k osc
             - description: 25m osc
@@ -66,8 +64,6 @@ allOf:
             - description: ext3 clock input
             - description: ext4 clock input
         clock-names:
-          minItems: 7
-          maxItems: 7
           items:
             - const: ckil
             - const: osc_25m
diff --git a/Documentation/devicetree/bindings/display/bridge/renesas,lvds.yaml b/Documentation/devicetree/bindings/display/bridge/renesas,lvds.yaml
index a51baf8a4c76..bb9dbfb9beaf 100644
--- a/Documentation/devicetree/bindings/display/bridge/renesas,lvds.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/renesas,lvds.yaml
@@ -95,7 +95,6 @@ then:
   properties:
     clocks:
       minItems: 1
-      maxItems: 4
       items:
         - description: Functional clock
         - description: EXTAL input clock
@@ -104,7 +103,6 @@ then:
 
     clock-names:
       minItems: 1
-      maxItems: 4
       items:
         - const: fck
         # The LVDS encoder can use the EXTAL or DU_DOTCLKINx clocks.
@@ -128,12 +126,10 @@ then:
 else:
   properties:
     clocks:
-      maxItems: 1
       items:
         - description: Functional clock
 
     clock-names:
-      maxItems: 1
       items:
         - const: fck
 
diff --git a/Documentation/devicetree/bindings/display/renesas,du.yaml b/Documentation/devicetree/bindings/display/renesas,du.yaml
index 56cedcd6d576..b3e588022082 100644
--- a/Documentation/devicetree/bindings/display/renesas,du.yaml
+++ b/Documentation/devicetree/bindings/display/renesas,du.yaml
@@ -109,7 +109,6 @@ allOf:
       properties:
         clocks:
           minItems: 1
-          maxItems: 3
           items:
             - description: Functional clock
             - description: DU_DOTCLKIN0 input clock
@@ -117,7 +116,6 @@ allOf:
 
         clock-names:
           minItems: 1
-          maxItems: 3
           items:
             - const: du.0
             - pattern: '^dclkin\.[01]$'
@@ -159,7 +157,6 @@ allOf:
       properties:
         clocks:
           minItems: 2
-          maxItems: 4
           items:
             - description: Functional clock for DU0
             - description: Functional clock for DU1
@@ -168,7 +165,6 @@ allOf:
 
         clock-names:
           minItems: 2
-          maxItems: 4
           items:
             - const: du.0
             - const: du.1
@@ -216,7 +212,6 @@ allOf:
       properties:
         clocks:
           minItems: 2
-          maxItems: 4
           items:
             - description: Functional clock for DU0
             - description: Functional clock for DU1
@@ -225,7 +220,6 @@ allOf:
 
         clock-names:
           minItems: 2
-          maxItems: 4
           items:
             - const: du.0
             - const: du.1
@@ -271,7 +265,6 @@ allOf:
       properties:
         clocks:
           minItems: 2
-          maxItems: 4
           items:
             - description: Functional clock for DU0
             - description: Functional clock for DU1
@@ -280,7 +273,6 @@ allOf:
 
         clock-names:
           minItems: 2
-          maxItems: 4
           items:
             - const: du.0
             - const: du.1
@@ -327,7 +319,6 @@ allOf:
       properties:
         clocks:
           minItems: 2
-          maxItems: 4
           items:
             - description: Functional clock for DU0
             - description: Functional clock for DU1
@@ -336,7 +327,6 @@ allOf:
 
         clock-names:
           minItems: 2
-          maxItems: 4
           items:
             - const: du.0
             - const: du.1
@@ -386,7 +376,6 @@ allOf:
       properties:
         clocks:
           minItems: 3
-          maxItems: 6
           items:
             - description: Functional clock for DU0
             - description: Functional clock for DU1
@@ -397,7 +386,6 @@ allOf:
 
         clock-names:
           minItems: 3
-          maxItems: 6
           items:
             - const: du.0
             - const: du.1
@@ -448,7 +436,6 @@ allOf:
       properties:
         clocks:
           minItems: 4
-          maxItems: 8
           items:
             - description: Functional clock for DU0
             - description: Functional clock for DU1
@@ -461,7 +448,6 @@ allOf:
 
         clock-names:
           minItems: 4
-          maxItems: 8
           items:
             - const: du.0
             - const: du.1
@@ -525,7 +511,6 @@ allOf:
       properties:
         clocks:
           minItems: 3
-          maxItems: 6
           items:
             - description: Functional clock for DU0
             - description: Functional clock for DU1
@@ -536,7 +521,6 @@ allOf:
 
         clock-names:
           minItems: 3
-          maxItems: 6
           items:
             - const: du.0
             - const: du.1
@@ -596,7 +580,6 @@ allOf:
       properties:
         clocks:
           minItems: 3
-          maxItems: 6
           items:
             - description: Functional clock for DU0
             - description: Functional clock for DU1
@@ -607,7 +590,6 @@ allOf:
 
         clock-names:
           minItems: 3
-          maxItems: 6
           items:
             - const: du.0
             - const: du.1
@@ -666,14 +648,12 @@ allOf:
       properties:
         clocks:
           minItems: 1
-          maxItems: 2
           items:
             - description: Functional clock for DU0
             - description: DU_DOTCLKIN0 input clock
 
         clock-names:
           minItems: 1
-          maxItems: 2
           items:
             - const: du.0
             - const: dclkin.0
@@ -723,7 +703,6 @@ allOf:
       properties:
         clocks:
           minItems: 2
-          maxItems: 4
           items:
             - description: Functional clock for DU0
             - description: Functional clock for DU1
@@ -732,7 +711,6 @@ allOf:
 
         clock-names:
           minItems: 2
-          maxItems: 4
           items:
             - const: du.0
             - const: du.1
@@ -791,7 +769,6 @@ allOf:
             - description: Functional clock
 
         clock-names:
-          maxItems: 1
           items:
             - const: du.0
 
diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
index 4d6074518b5c..fa8da42cb1e6 100644
--- a/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
@@ -138,7 +138,6 @@ allOf:
             - const: bus
             - const: adc
           minItems: 1
-          maxItems: 2
 
         interrupts:
           items:
@@ -170,7 +169,6 @@ allOf:
             - const: bus
             - const: adc
           minItems: 1
-          maxItems: 2
 
         interrupts:
           items:
diff --git a/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.yaml b/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.yaml
index f3f4d5b02744..fe0270207622 100644
--- a/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.yaml
+++ b/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.yaml
@@ -202,22 +202,17 @@ allOf:
         clocks:
           items:
             - description: module clock
-          minItems: 1
-          maxItems: 1
     else:
       properties:
         clocks:
           items:
             - description: module clock
             - description: timeout clock
-          minItems: 2
-          maxItems: 2
+
         clock-names:
           items:
             - const: sdhci
             - const: tmclk
-          minItems: 2
-          maxItems: 2
       required:
         - clock-names
 
diff --git a/Documentation/devicetree/bindings/mtd/gpmi-nand.yaml b/Documentation/devicetree/bindings/mtd/gpmi-nand.yaml
index 9d764e654e1d..849aeae319a9 100644
--- a/Documentation/devicetree/bindings/mtd/gpmi-nand.yaml
+++ b/Documentation/devicetree/bindings/mtd/gpmi-nand.yaml
@@ -147,8 +147,6 @@ allOf:
             - description: SoC gpmi io clock
             - description: SoC gpmi bch apb clock
         clock-names:
-          minItems: 2
-          maxItems: 2
           items:
             - const: gpmi_io
             - const: gpmi_bch_apb
diff --git a/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
index 8bad328b184d..51aa89ac7e85 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
@@ -80,8 +80,6 @@ if:
 then:
   properties:
     interrupts:
-      minItems: 4
-      maxItems: 4
       items:
         - description: Error and status IRQ
         - description: Message object IRQ
@@ -91,7 +89,6 @@ then:
 else:
   properties:
     interrupts:
-      maxItems: 1
       items:
         - description: Error and status IRQ
 
diff --git a/Documentation/devicetree/bindings/phy/brcm,sata-phy.yaml b/Documentation/devicetree/bindings/phy/brcm,sata-phy.yaml
index cb1aa325336f..435b971dfd9b 100644
--- a/Documentation/devicetree/bindings/phy/brcm,sata-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/brcm,sata-phy.yaml
@@ -102,19 +102,17 @@ if:
 then:
   properties:
     reg:
-      maxItems: 2
+      minItems: 2
+
     reg-names:
-      items:
-        - const: "phy"
-        - const: "phy-ctrl"
+      minItems: 2
 else:
   properties:
     reg:
       maxItems: 1
+
     reg-names:
       maxItems: 1
-      items:
-        - const: "phy"
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml b/Documentation/devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml
index 0b767fec39d8..6b38bd7eb3b4 100644
--- a/Documentation/devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml
+++ b/Documentation/devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml
@@ -71,7 +71,6 @@ allOf:
     then:
       properties:
         clock-output-names:
-          minItems: 1
           maxItems: 1
 
   - if:
@@ -102,7 +101,6 @@ allOf:
       properties:
         clock-output-names:
           minItems: 3
-          maxItems: 3
 
   - if:
       properties:
@@ -113,16 +111,12 @@ allOf:
     then:
       properties:
         clocks:
-          minItems: 3
-          maxItems: 3
           items:
             - description: Bus clock for register access
             - description: 24 MHz oscillator
             - description: 32 kHz clock from the CCU
 
         clock-names:
-          minItems: 3
-          maxItems: 3
           items:
             - const: bus
             - const: hosc
@@ -142,7 +136,6 @@ allOf:
       properties:
         clocks:
           minItems: 3
-          maxItems: 4
           items:
             - description: Bus clock for register access
             - description: 24 MHz oscillator
@@ -151,7 +144,6 @@ allOf:
 
         clock-names:
           minItems: 3
-          maxItems: 4
           items:
             - const: bus
             - const: hosc
@@ -174,14 +166,12 @@ allOf:
     then:
       properties:
         interrupts:
-          minItems: 1
           maxItems: 1
 
     else:
       properties:
         interrupts:
           minItems: 2
-          maxItems: 2
 
 required:
   - "#clock-cells"
diff --git a/Documentation/devicetree/bindings/serial/samsung_uart.yaml b/Documentation/devicetree/bindings/serial/samsung_uart.yaml
index d4688e317fc5..901c1e2cea28 100644
--- a/Documentation/devicetree/bindings/serial/samsung_uart.yaml
+++ b/Documentation/devicetree/bindings/serial/samsung_uart.yaml
@@ -100,7 +100,6 @@ allOf:
           maxItems: 3
         clock-names:
           minItems: 2
-          maxItems: 3
           items:
             - const: uart
             - pattern: '^clk_uart_baud[0-1]$'
@@ -118,11 +117,8 @@ allOf:
     then:
       properties:
         clocks:
-          minItems: 2
           maxItems: 2
         clock-names:
-          minItems: 2
-          maxItems: 2
           items:
             - const: uart
             - const: clk_uart_baud0
diff --git a/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-i2s.yaml b/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-i2s.yaml
index c21c807b667c..34f6ee9de392 100644
--- a/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-i2s.yaml
+++ b/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-i2s.yaml
@@ -89,7 +89,6 @@ allOf:
       properties:
         dmas:
           minItems: 1
-          maxItems: 2
           items:
             - description: RX DMA Channel
             - description: TX DMA Channel
diff --git a/Documentation/devicetree/bindings/sound/ti,j721e-cpb-audio.yaml b/Documentation/devicetree/bindings/sound/ti,j721e-cpb-audio.yaml
index 6806f53a4aed..20ea5883b7ff 100644
--- a/Documentation/devicetree/bindings/sound/ti,j721e-cpb-audio.yaml
+++ b/Documentation/devicetree/bindings/sound/ti,j721e-cpb-audio.yaml
@@ -80,7 +80,6 @@ allOf:
     then:
       properties:
         clocks:
-          minItems: 6
           items:
             - description: AUXCLK clock for McASP used by CPB audio
             - description: Parent for CPB_McASP auxclk (for 48KHz)
@@ -107,7 +106,6 @@ allOf:
     then:
       properties:
         clocks:
-          maxItems: 4
           items:
             - description: AUXCLK clock for McASP used by CPB audio
             - description: Parent for CPB_McASP auxclk (for 48KHz)
diff --git a/Documentation/devicetree/bindings/thermal/rcar-gen3-thermal.yaml b/Documentation/devicetree/bindings/thermal/rcar-gen3-thermal.yaml
index f963204e0b16..1368d90da0e8 100644
--- a/Documentation/devicetree/bindings/thermal/rcar-gen3-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/rcar-gen3-thermal.yaml
@@ -67,7 +67,6 @@ then:
   properties:
     reg:
       minItems: 2
-      maxItems: 3
       items:
         - description: TSC1 registers
         - description: TSC2 registers
-- 
2.34.1

