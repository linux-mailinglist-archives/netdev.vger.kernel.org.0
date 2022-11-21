Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A4C631FDB
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiKULKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiKULJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:09:33 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D644AA84F5
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:07:08 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id r12so18315269lfp.1
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ykrr97Kx6dPwpQpPLkSQPEIss0usMVQMF4V3McQGImg=;
        b=aqIQbAwX7kJEr4u1y2d/vOKLmFZrO9Tr46iUeC6k3KtUD89g1BJF5rEtGzfYBNZ8kj
         D5rMFPm7fjgyAzZFmghUYZqAYJbklnoAWq1GPWcZW8bWlBWHhf0PyFtRO2H5b2TCXsV3
         aHYShVMWdPp9aJKEqrP5J9YGgv4G14SERxMTlgywtddqE+iK5fsnQYn0X7wPLN6B+PBn
         ShE6SLKDCci4bQS1rFgh+/OR3/rnSVM4lMVDpTYl+mAEGisdkeIyUrHonUmg8MTqeXi5
         3Cq66j29vBtJhRYcrIpm8QPE91IoQZ2s241/7C0IFL6A6uYq9HxVMUqPbB55Bv69xUz2
         LhVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ykrr97Kx6dPwpQpPLkSQPEIss0usMVQMF4V3McQGImg=;
        b=ypAzbXXAI0Mvs8wOcxZz7VlTyxni4dIRZ/ITzwK/a6VauGWtMXttFJ2+Ip0GEOXzPJ
         JRzKGBwt7ly5eFUSaGrynQdAoXv/K3Uoh3OzvzmhQUeNB6bpBHwEQ5PNtXoSmLxKBHlV
         1pRjWi5knQ05Q3JPgtG9vcrg81dHCTJtXpw4LdDmrLE0yzVAzyDg22wcpqlOzK+g5wT1
         OKSQ7YnbWN5ofDbC4XErJFSeankXl2kbrG0q8TbssiDhtOuo1wo/VNDcThk0lnhBgsb0
         Y94zF1YCu/Q76lm2ldQf0qAO1HvVBRcXz//ANzY9frSw4ldhzJFdWWcg39QhEQqGiqRe
         b7zA==
X-Gm-Message-State: ANoB5pkWrIqV83R4GyTObPnFGmzfxDpl8p0u3O/v5XXAW5QjIWAPYA4H
        2CcbFDltee+f0mIHbElAVpN4WQ==
X-Google-Smtp-Source: AA0mqf5/enQ9D+vtSq4jU+plDQR2darfKhhZbr6PaDRoZIzW/KhmYoxs/Xb6U6lu4KGVoFJnJNKNJA==
X-Received: by 2002:a05:6512:3248:b0:4aa:148d:5168 with SMTP id c8-20020a056512324800b004aa148d5168mr5432818lfr.561.1669028799198;
        Mon, 21 Nov 2022 03:06:39 -0800 (PST)
Received: from krzk-bin.NAT.warszawa.vectranet.pl (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id n1-20020a05651203e100b0049313f77755sm1991521lfq.213.2022.11.21.03.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 03:06:38 -0800 (PST)
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
Subject: [PATCH v2 8/9] dt-bindings: clock: drop redundant part of title
Date:   Mon, 21 Nov 2022 12:06:14 +0100
Message-Id: <20221121110615.97962-9-krzysztof.kozlowski@linaro.org>
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
it is a "Devicetree binding", but instead just describe the hardware.

Drop "Devicetree bindings" in various forms:

  find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
    -exec sed -i -e 's/^title: [dD]evice[ -]\?[tT]ree [cC]lock [bB]indings\? for \([tT]he \)\?\(.*\)$/title: \u\2 Clock Controller/' {} \;

  find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
    -exec sed -i -e 's/^title: [cC]lock [bB]indings\? for \([tT]he \)\?\(.*\)$/title: \u\2 Clock Controller/' {} \;

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 Documentation/devicetree/bindings/clock/calxeda.yaml           | 2 +-
 Documentation/devicetree/bindings/clock/imx1-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/imx21-clock.yaml       | 2 +-
 Documentation/devicetree/bindings/clock/imx23-clock.yaml       | 2 +-
 Documentation/devicetree/bindings/clock/imx25-clock.yaml       | 2 +-
 Documentation/devicetree/bindings/clock/imx27-clock.yaml       | 2 +-
 Documentation/devicetree/bindings/clock/imx28-clock.yaml       | 2 +-
 Documentation/devicetree/bindings/clock/imx31-clock.yaml       | 2 +-
 Documentation/devicetree/bindings/clock/imx35-clock.yaml       | 2 +-
 Documentation/devicetree/bindings/clock/imx5-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/imx6q-clock.yaml       | 2 +-
 Documentation/devicetree/bindings/clock/imx6sl-clock.yaml      | 2 +-
 Documentation/devicetree/bindings/clock/imx6sll-clock.yaml     | 2 +-
 Documentation/devicetree/bindings/clock/imx6sx-clock.yaml      | 2 +-
 Documentation/devicetree/bindings/clock/imx6ul-clock.yaml      | 2 +-
 Documentation/devicetree/bindings/clock/imx7d-clock.yaml       | 2 +-
 Documentation/devicetree/bindings/clock/imx7ulp-pcc-clock.yaml | 2 +-
 Documentation/devicetree/bindings/clock/imx7ulp-scg-clock.yaml | 2 +-
 Documentation/devicetree/bindings/clock/imxrt1050-clock.yaml   | 2 +-
 Documentation/devicetree/bindings/clock/ti,lmk04832.yaml       | 2 +-
 20 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/calxeda.yaml b/Documentation/devicetree/bindings/clock/calxeda.yaml
index a34cbf3c9aaf..a88fbe20fef1 100644
--- a/Documentation/devicetree/bindings/clock/calxeda.yaml
+++ b/Documentation/devicetree/bindings/clock/calxeda.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/calxeda.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Device Tree Clock bindings for Calxeda highbank platform
+title: Calxeda highbank platform Clock Controller
 
 description: |
   This binding covers the Calxeda SoC internal peripheral and bus clocks
diff --git a/Documentation/devicetree/bindings/clock/imx1-clock.yaml b/Documentation/devicetree/bindings/clock/imx1-clock.yaml
index 56f524780b1a..7ade4c32aff3 100644
--- a/Documentation/devicetree/bindings/clock/imx1-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx1-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx1-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX1 CPUs
+title: Freescale i.MX1 CPUs Clock Controller
 
 maintainers:
   - Alexander Shiyan <shc_work@mail.ru>
diff --git a/Documentation/devicetree/bindings/clock/imx21-clock.yaml b/Documentation/devicetree/bindings/clock/imx21-clock.yaml
index e2d50544700a..79cc843703ec 100644
--- a/Documentation/devicetree/bindings/clock/imx21-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx21-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx21-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX21
+title: Freescale i.MX21 Clock Controller
 
 maintainers:
   - Alexander Shiyan <shc_work@mail.ru>
diff --git a/Documentation/devicetree/bindings/clock/imx23-clock.yaml b/Documentation/devicetree/bindings/clock/imx23-clock.yaml
index 7e890ab9c77d..5e71c9219500 100644
--- a/Documentation/devicetree/bindings/clock/imx23-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx23-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx23-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX23
+title: Freescale i.MX23 Clock Controller
 
 maintainers:
   - Shawn Guo <shawnguo@kernel.org>
diff --git a/Documentation/devicetree/bindings/clock/imx25-clock.yaml b/Documentation/devicetree/bindings/clock/imx25-clock.yaml
index 1792e138984b..c626a158590e 100644
--- a/Documentation/devicetree/bindings/clock/imx25-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx25-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx25-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX25
+title: Freescale i.MX25 Clock Controller
 
 maintainers:
   - Sascha Hauer <s.hauer@pengutronix.de>
diff --git a/Documentation/devicetree/bindings/clock/imx27-clock.yaml b/Documentation/devicetree/bindings/clock/imx27-clock.yaml
index 99925aa22a4c..71d78a0b551f 100644
--- a/Documentation/devicetree/bindings/clock/imx27-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx27-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx27-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX27
+title: Freescale i.MX27 Clock Controller
 
 maintainers:
   - Fabio Estevam <festevam@gmail.com>
diff --git a/Documentation/devicetree/bindings/clock/imx28-clock.yaml b/Documentation/devicetree/bindings/clock/imx28-clock.yaml
index a542d680b1ca..4aaad7b9c66e 100644
--- a/Documentation/devicetree/bindings/clock/imx28-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx28-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx28-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX28
+title: Freescale i.MX28 Clock Controller
 
 maintainers:
   - Shawn Guo <shawnguo@kernel.org>
diff --git a/Documentation/devicetree/bindings/clock/imx31-clock.yaml b/Documentation/devicetree/bindings/clock/imx31-clock.yaml
index 168c8ada5e81..50a8498eef8a 100644
--- a/Documentation/devicetree/bindings/clock/imx31-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx31-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx31-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX31
+title: Freescale i.MX31 Clock Controller
 
 maintainers:
   - Fabio Estevam <festevam@gmail.com>
diff --git a/Documentation/devicetree/bindings/clock/imx35-clock.yaml b/Documentation/devicetree/bindings/clock/imx35-clock.yaml
index 6415bb6a8d04..c063369de3ec 100644
--- a/Documentation/devicetree/bindings/clock/imx35-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx35-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx35-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX35
+title: Freescale i.MX35 Clock Controller
 
 maintainers:
   - Steffen Trumtrar <s.trumtrar@pengutronix.de>
diff --git a/Documentation/devicetree/bindings/clock/imx5-clock.yaml b/Documentation/devicetree/bindings/clock/imx5-clock.yaml
index c0e19ff92c76..423c0142c1d3 100644
--- a/Documentation/devicetree/bindings/clock/imx5-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx5-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx5-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX5
+title: Freescale i.MX5 Clock Controller
 
 maintainers:
   - Fabio Estevam <festevam@gmail.com>
diff --git a/Documentation/devicetree/bindings/clock/imx6q-clock.yaml b/Documentation/devicetree/bindings/clock/imx6q-clock.yaml
index 4f4637eddb8b..bae4fcb3aacc 100644
--- a/Documentation/devicetree/bindings/clock/imx6q-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx6q-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx6q-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX6 Quad
+title: Freescale i.MX6 Quad Clock Controller
 
 maintainers:
   - Anson Huang <Anson.Huang@nxp.com>
diff --git a/Documentation/devicetree/bindings/clock/imx6sl-clock.yaml b/Documentation/devicetree/bindings/clock/imx6sl-clock.yaml
index b83c8f43d664..c85ff6ea3d24 100644
--- a/Documentation/devicetree/bindings/clock/imx6sl-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx6sl-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx6sl-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX6 SoloLite
+title: Freescale i.MX6 SoloLite Clock Controller
 
 maintainers:
   - Anson Huang <Anson.Huang@nxp.com>
diff --git a/Documentation/devicetree/bindings/clock/imx6sll-clock.yaml b/Documentation/devicetree/bindings/clock/imx6sll-clock.yaml
index 484894a4b23f..6b549ed1493c 100644
--- a/Documentation/devicetree/bindings/clock/imx6sll-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx6sll-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx6sll-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX6 SLL
+title: Freescale i.MX6 SLL Clock Controller
 
 maintainers:
   - Anson Huang <Anson.Huang@nxp.com>
diff --git a/Documentation/devicetree/bindings/clock/imx6sx-clock.yaml b/Documentation/devicetree/bindings/clock/imx6sx-clock.yaml
index e6c795657c24..55dcad18b7c6 100644
--- a/Documentation/devicetree/bindings/clock/imx6sx-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx6sx-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx6sx-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX6 SoloX
+title: Freescale i.MX6 SoloX Clock Controller
 
 maintainers:
   - Anson Huang <Anson.Huang@nxp.com>
diff --git a/Documentation/devicetree/bindings/clock/imx6ul-clock.yaml b/Documentation/devicetree/bindings/clock/imx6ul-clock.yaml
index 6a51a3f51cd9..be54d4df5afa 100644
--- a/Documentation/devicetree/bindings/clock/imx6ul-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx6ul-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx6ul-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX6 UltraLite
+title: Freescale i.MX6 UltraLite Clock Controller
 
 maintainers:
   - Anson Huang <Anson.Huang@nxp.com>
diff --git a/Documentation/devicetree/bindings/clock/imx7d-clock.yaml b/Documentation/devicetree/bindings/clock/imx7d-clock.yaml
index cefb61db01a8..e7d8427e4957 100644
--- a/Documentation/devicetree/bindings/clock/imx7d-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx7d-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx7d-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX7 Dual
+title: Freescale i.MX7 Dual Clock Controller
 
 maintainers:
   - Frank Li <Frank.Li@nxp.com>
diff --git a/Documentation/devicetree/bindings/clock/imx7ulp-pcc-clock.yaml b/Documentation/devicetree/bindings/clock/imx7ulp-pcc-clock.yaml
index 739c3378f8c8..76842038f52e 100644
--- a/Documentation/devicetree/bindings/clock/imx7ulp-pcc-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx7ulp-pcc-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx7ulp-pcc-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX7ULP Peripheral Clock Control (PCC) modules
+title: Freescale i.MX7ULP Peripheral Clock Control (PCC) modules Clock Controller
 
 maintainers:
   - A.s. Dong <aisheng.dong@nxp.com>
diff --git a/Documentation/devicetree/bindings/clock/imx7ulp-scg-clock.yaml b/Documentation/devicetree/bindings/clock/imx7ulp-scg-clock.yaml
index d06344d7e34f..5e25bc6d1372 100644
--- a/Documentation/devicetree/bindings/clock/imx7ulp-scg-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx7ulp-scg-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx7ulp-scg-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MX7ULP System Clock Generation (SCG) modules
+title: Freescale i.MX7ULP System Clock Generation (SCG) modules Clock Controller
 
 maintainers:
   - A.s. Dong <aisheng.dong@nxp.com>
diff --git a/Documentation/devicetree/bindings/clock/imxrt1050-clock.yaml b/Documentation/devicetree/bindings/clock/imxrt1050-clock.yaml
index 03fc5c1a2939..777af4aad4b2 100644
--- a/Documentation/devicetree/bindings/clock/imxrt1050-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imxrt1050-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imxrt1050-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for Freescale i.MXRT
+title: Freescale i.MXRT Clock Controller
 
 maintainers:
   - Giulio Benetti <giulio.benetti@benettiengineering.com>
diff --git a/Documentation/devicetree/bindings/clock/ti,lmk04832.yaml b/Documentation/devicetree/bindings/clock/ti,lmk04832.yaml
index bd8173848253..73d17830f165 100644
--- a/Documentation/devicetree/bindings/clock/ti,lmk04832.yaml
+++ b/Documentation/devicetree/bindings/clock/ti,lmk04832.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/ti,lmk04832.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for the Texas Instruments LMK04832
+title: Texas Instruments LMK04832 Clock Controller
 
 maintainers:
   - Liam Beguin <liambeguin@gmail.com>
-- 
2.34.1

