Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6DA157CF00
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiGUPcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiGUPcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:32:10 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9477456B89
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:32:08 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id m12so2278786lfj.4
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rrDT1Pzl9yr81tqKMwbGgy4cc56GaF0iYxKKVp4xCJc=;
        b=zsAklumWJlcbhY0ct4EIIAbj8yOgjitDEOWYeEOJlE4CCM/XHYHvaWSlbP6tmRmXjv
         7/TYVDfTMN1x9GJZA8AThGagQsi0vGlfKn4OI3Nfuz/g1Xp9piLcI6wvL4rvf4eCVd+V
         EvAim5664qNdtseuKGB0LW5vrXqLKUAI/B5y04Dcugf+sgKdPJ/P/8baq+az85Qp9xSB
         KwhuxBMoryZfPxi0rFBAdC12/YwtYTX3hmphh8aKtx5Hvzjs/A9fIF1L3CZVvblsDKdo
         cSHpT1tqSKM77FPIlNMkdNudbVW8u/jdEqKTZD9xwDkgE8+v5A9W2OPKbol5HLuwdfoI
         MEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rrDT1Pzl9yr81tqKMwbGgy4cc56GaF0iYxKKVp4xCJc=;
        b=t/Z37QA22JyinCWvNegrvezH3H4DgAJ71TqDYAy2NusDNcCzdKD4mDCAZ9idUkpf5Z
         g1s0RqzJbgZ/DLDTjdibgOMGbw3gBUIXvfK90ZkWvIz8rRh7JtHLqJUEIc1E36zSoXsW
         J2uFdCSFt89JJM/mQwgusEtTgAfZX0Pxcm+v0hsdPmB4kPGcdQhFcJMF29kBhYL41bcT
         ZbvHRpLuZF6PSTIEeHz/2YOTLJJUL7OZS2/hz9ooWbbwlQKLY+Gs4VmoIY8XMg3avDFq
         1LGmBiUOawbITjE6eJo6goiIv06GX9TGHgSpoi4MgygaviCgzkipJ0mjf+tOE6pp8J5T
         TfWw==
X-Gm-Message-State: AJIora9OUwq4j7np/wMDXqWKGxrimuf3bFBguzkp5RmUevzWnDdmtHkZ
        5er9rVnPGDO+89HY2AB+sPUoNA==
X-Google-Smtp-Source: AGRyM1vu1xuZW6P4hxkiBne/br5RRQinT3eBea1kYAmvFe+TrOCrAhcFqOe1CC4JG1hETPWqt+GIMg==
X-Received: by 2002:a05:6512:2244:b0:489:e75e:8e56 with SMTP id i4-20020a056512224400b00489e75e8e56mr24603377lfu.290.1658417526742;
        Thu, 21 Jul 2022 08:32:06 -0700 (PDT)
Received: from krzk-bin.. (89-162-31-138.fiber.signal.no. [89.162.31.138])
        by smtp.gmail.com with ESMTPSA id a27-20020ac25e7b000000b0048a2995772asm504604lfr.73.2022.07.21.08.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 08:32:06 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Markuss Broks <markuss.broks@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Tomislav Denis <tomislav.denis@avl.com>,
        Cosmin Tanislav <cosmin.tanislav@analog.com>,
        Nishant Malpani <nish.malpani25@gmail.com>,
        Dragos Bogdan <dragos.bogdan@analog.com>,
        Nuno Sa <nuno.sa@analog.com>,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Marek Belisko <marek@goldelico.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Christian Eggers <ceggers@arri.de>,
        Beniamin Bia <beniamin.bia@analog.com>,
        Stefan Popa <stefan.popa@analog.com>,
        Oskar Andero <oskar.andero@gmail.com>,
        =?UTF-8?q?M=C3=A5rten=20Lindahl?= <martenli@axis.com>,
        Dan Murphy <dmurphy@ti.com>, Sean Nyekjaer <sean@geanix.com>,
        Cristian Pop <cristian.pop@analog.com>,
        Lukas Wunner <lukas@wunner.de>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Matheus Tavares <matheus.bernardino@usp.br>,
        Sankar Velliangiri <navin@linumiz.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Stefan Wahren <stefan.wahren@in-tech.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-fbdev@vger.kernel.org, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 0/6] dt-bindings: iio/panel/eeprom/misc/net/spi: drop SPI CPHA and CPOL
Date:   Thu, 21 Jul 2022 17:31:49 +0200
Message-Id: <20220721153155.245336-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
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

Hi,

Rebased on next-20220714

Merging
=======
1. The first five patches (panel, eeprom, iio, misc and net) are independent
   and could be taken as is.
2. The last SPI patch depends on all previous five, so:
   a. either everything goes through one tree (e.g. DT bindings),
   b. or SPI patch waits one cycle till dependencies get to rcX.

Preference is (2a) - everything through one tree because I plan to include
spi-peripheral-props.yaml in several SPI client bindings (continuation of [1]).

However IIO and SPI patch might not apply cleanly on DT bindings tree, as I
based it on linux-next. I can rebase if such merging is preferred.

Description
===========
The spi-cpha and spi-cpol properties are device specific and should be
accepted only if device really needs them.  Inspired by [1].

[1] https://lore.kernel.org/all/20220718220012.GA3625497-robh@kernel.org/

Best regards,
Krzysztof

Krzysztof Kozlowski (6):
  dt-bindings: panel: explicitly list SPI CPHA and CPOL
  dt-bindings: eeprom: at25: explicitly list SPI CPHA and CPOL
  dt-bindings: iio: explicitly list SPI CPHA and CPOL
  dt-bindings: misc: explicitly list SPI CPHA and CPOL
  dt-bindings: net: explicitly list SPI CPHA and CPOL
  spi: dt-bindings: drop CPHA and CPOL from common properties

 .../bindings/display/panel/lgphilips,lb035q02.yaml   | 10 ++++++++++
 .../bindings/display/panel/samsung,ld9040.yaml       | 10 ++++++++++
 .../bindings/display/panel/samsung,lms380kf01.yaml   | 12 +++++++++---
 .../bindings/display/panel/samsung,lms397kf04.yaml   | 12 +++++++++---
 .../bindings/display/panel/samsung,s6d27a1.yaml      | 12 +++++++++---
 .../bindings/display/panel/sitronix,st7789v.yaml     | 10 ++++++++++
 .../devicetree/bindings/display/panel/tpo,td.yaml    | 10 ++++++++++
 Documentation/devicetree/bindings/eeprom/at25.yaml   | 10 ++++++++--
 .../devicetree/bindings/iio/accel/adi,adxl345.yaml   | 10 ++++++++--
 .../devicetree/bindings/iio/adc/adi,ad7192.yaml      | 10 ++++++++--
 .../devicetree/bindings/iio/adc/adi,ad7292.yaml      |  5 ++++-
 .../devicetree/bindings/iio/adc/adi,ad7606.yaml      | 10 ++++++++--
 .../devicetree/bindings/iio/adc/adi,ad7768-1.yaml    | 10 ++++++++--
 .../bindings/iio/adc/microchip,mcp3201.yaml          | 12 ++++++++++--
 .../devicetree/bindings/iio/adc/ti,adc084s021.yaml   | 11 +++++++++--
 .../devicetree/bindings/iio/adc/ti,ads124s08.yaml    |  5 ++++-
 .../devicetree/bindings/iio/adc/ti,ads131e08.yaml    |  5 ++++-
 .../devicetree/bindings/iio/addac/adi,ad74413r.yaml  |  5 ++++-
 .../devicetree/bindings/iio/dac/adi,ad5592r.yaml     |  5 ++++-
 .../devicetree/bindings/iio/dac/adi,ad5755.yaml      | 10 ++++++++--
 .../devicetree/bindings/iio/dac/adi,ad5758.yaml      |  6 +++++-
 .../devicetree/bindings/iio/dac/adi,ad5766.yaml      |  5 ++++-
 .../devicetree/bindings/iio/dac/ti,dac082s085.yaml   |  9 +++++++--
 .../bindings/iio/gyroscope/adi,adxrs290.yaml         | 10 ++++++++--
 .../devicetree/bindings/iio/imu/adi,adis16460.yaml   | 12 +++++++++---
 .../devicetree/bindings/iio/imu/adi,adis16475.yaml   | 10 ++++++++--
 .../devicetree/bindings/iio/imu/adi,adis16480.yaml   | 11 +++++++++--
 .../bindings/iio/imu/invensense,icm42600.yaml        | 12 ++++++++++--
 .../bindings/iio/proximity/ams,as3935.yaml           |  5 ++++-
 .../devicetree/bindings/iio/resolver/adi,ad2s90.yaml | 10 ++++++++--
 .../bindings/iio/temperature/maxim,max31855k.yaml    |  6 +++++-
 .../bindings/iio/temperature/maxim,max31856.yaml     |  6 +++++-
 .../bindings/iio/temperature/maxim,max31865.yaml     |  6 +++++-
 .../devicetree/bindings/misc/olpc,xo1.75-ec.yaml     |  5 ++++-
 .../devicetree/bindings/net/nfc/marvell,nci.yaml     | 12 ++++++++++--
 .../devicetree/bindings/net/vertexcom-mse102x.yaml   | 12 +++++++++---
 .../bindings/spi/spi-peripheral-props.yaml           | 10 ----------
 37 files changed, 264 insertions(+), 67 deletions(-)

-- 
2.34.1

