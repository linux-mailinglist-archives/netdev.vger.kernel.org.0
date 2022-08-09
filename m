Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F3458DBE5
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 18:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245014AbiHIQ2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 12:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242610AbiHIQ2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 12:28:01 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0E315721
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 09:27:58 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id u1so17726111lfq.4
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 09:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AR+nnS9UZD6P2Hs8ZDImw5TD7p9NQC+KnqHa3zocRvk=;
        b=scwhCRJP2cX92hQGoRkNYm1CP1o41FrEej53GLl6u8y5tLL91RoPRZ7d6703rgd6z4
         y4xGg04FcmAIUHsFZQoz3WCYKNxzaLl/PR8KdfKG3pssC1Ay0wa0QlWGw/CoiJHSId30
         hd2EyCkjzIer0sV5O8xkfFRvGUJS2udkZLP+LgpUOsffdh6Ohnu9uFOfrWIMHTe8lNIt
         DcZEoqWOYX3F4kMr76HXbsT2Moht6G1fCn39Xyon/Lq04771JDKk12dmYO1wKfeq7bEo
         IAX75aMK5gnpn0hTmsCJekxKFQfTF8tAtJGgWwg6FDMsH6NiNiY5SGBvidLvPPdbFP1v
         gydA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AR+nnS9UZD6P2Hs8ZDImw5TD7p9NQC+KnqHa3zocRvk=;
        b=IogqeMCC5eTL62grBxZKiqGFJKk4nVUn+Xzaz1unj0AgOa731nJo5oIKz7fqW0G8pT
         KrvrQ01Qf0THE/sX3afxKKMD+StYFzonj7OxezkySkmxNiNThT1nJvmNDcT3mnkyUWfr
         n9a7eqKJNsKoXvBaEiPsZYDUBNS/VyIbF45Yoy/zOxhDHMlByTDqM/O9W/XdxEIYRqhw
         MEQw7hMZTxkGLiSwFWSoYhJr1C6HqPRRuNkA6UUcCF8wfcT6rlpFKEHofy6ABu5bKXhd
         0N08PETqRCtSAcvNhzb+BGzl1mzxDRU3EmGXt/velFL0sK8Zsnr9NJxNwhZJSNcWVnKW
         b0Dw==
X-Gm-Message-State: ACgBeo3doXBXeXzrzSTMzty3f/2VXPJ8osBPqXYSvA+9cEDyaKFUBWL2
        t2c80cYIjSb3/UK/DylsmKEIS+yHya61kDcn
X-Google-Smtp-Source: AA6agR5TRVjeZwahd7WkFhqyuhqfwiPBYep94z8LyDAT7HAxO3MZrTjHFZMuFjki+w1nYUDsee4f8A==
X-Received: by 2002:a05:6512:2a8d:b0:48b:7f1:fe46 with SMTP id dt13-20020a0565122a8d00b0048b07f1fe46mr7624887lfb.261.1660062476861;
        Tue, 09 Aug 2022 09:27:56 -0700 (PDT)
Received: from localhost.localdomain ([83.146.140.105])
        by smtp.gmail.com with ESMTPSA id h7-20020ac24d27000000b0048a8c907fe9sm20999lfk.167.2022.08.09.09.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 09:27:56 -0700 (PDT)
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
Subject: [PATCH v2 0/5] iio/hwmon/mfd/leds/net/power/ASoC: dt-bindings: few stale maintainers cleanup
Date:   Tue,  9 Aug 2022 19:27:47 +0300
Message-Id: <20220809162752.10186-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
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

Hi,

Changes since v1
================
1. Patch #5: Drop also Ricardo Rivera-Matos and assign TI bindings to Andrew Davis
2. Add acks.

A question
==========

Several of the bindings here had only one maintainer and history does not
always point to a new one (although I did not perform extensive digging). I
added subsystem maintainer, because dtschema requires an entry with valid email address.

This is not the best choice as simply subsystem maintainer might not have the
actual device (or its datasheets or any interest in it).

Maybe we could add some "orphaned" entry in such case?

Best regards,
Krzysztof

Krzysztof Kozlowski (5):
  dt-bindings: iio: Drop Joachim Eastwood
  dt-bindings: iio: Drop Bogdan Pricop
  dt-bindings: Drop Beniamin Bia and Stefan Popa
  dt-bindings: Drop Robert Jones
  dt-bindings: Drop Dan Murphy and Ricardo Rivera-Matos

 Documentation/devicetree/bindings/hwmon/adi,adm1177.yaml       | 1 -
 Documentation/devicetree/bindings/iio/accel/fsl,mma7455.yaml   | 1 -
 Documentation/devicetree/bindings/iio/adc/adi,ad7091r5.yaml    | 2 +-
 Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml      | 3 +--
 Documentation/devicetree/bindings/iio/adc/nxp,lpc1850-adc.yaml | 2 +-
 Documentation/devicetree/bindings/iio/adc/ti,adc108s102.yaml   | 2 +-
 Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml    | 2 +-
 .../devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml        | 1 -
 Documentation/devicetree/bindings/iio/imu/nxp,fxos8700.yaml    | 2 +-
 .../devicetree/bindings/leds/leds-class-multicolor.yaml        | 2 +-
 Documentation/devicetree/bindings/leds/leds-lp50xx.yaml        | 2 +-
 Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml       | 1 -
 Documentation/devicetree/bindings/net/ti,dp83822.yaml          | 2 +-
 Documentation/devicetree/bindings/net/ti,dp83867.yaml          | 2 +-
 Documentation/devicetree/bindings/net/ti,dp83869.yaml          | 2 +-
 Documentation/devicetree/bindings/power/supply/bq2515x.yaml    | 3 +--
 Documentation/devicetree/bindings/power/supply/bq256xx.yaml    | 2 +-
 Documentation/devicetree/bindings/power/supply/bq25980.yaml    | 3 +--
 Documentation/devicetree/bindings/sound/tas2562.yaml           | 2 +-
 Documentation/devicetree/bindings/sound/tlv320adcx140.yaml     | 2 +-
 20 files changed, 16 insertions(+), 23 deletions(-)

-- 
2.34.1

