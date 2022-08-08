Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494B158C6DB
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 12:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242784AbiHHKr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 06:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242700AbiHHKr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 06:47:56 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9A512D37
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 03:47:53 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id a9so12028831lfm.12
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 03:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2me5XEAf0ofFirE+9ir/dwTvKRWjjaESV5ln3eJw2Hw=;
        b=CuVZZAuRK7wnpkN4SgjBYiCNJctDMSXGAa5tukH+acTFa5KoHplR3S6yO3Zg8IsTiK
         FXfKau4gB1IULpTxjrFJGwFlVnDp2FSRo0mLHy6Rr4Y0fJuivOjbk1wTypPV2+Y8TtNh
         qXkp3tkgVqzVAbaoGMkBF0u+nLxe4qLWkA1wAjIVCz5MhKCOr4RmSxPKVFcHxPBfzSrI
         Xy5SMIO5qZja0iBGcYJvDkQuCUEQHuqcneGCV+jiN6MTbhzmsrWKUjlOS1BD+qYyfRxX
         NOmyfe5nGk1MU7HPF9NGkLXVnPK1QScHtKSpOeih02tYIzIsjds2LJgApgk7bpfbgt0B
         Vg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2me5XEAf0ofFirE+9ir/dwTvKRWjjaESV5ln3eJw2Hw=;
        b=737pB6lzG1EO2Akd/ZnpzPrzld+O+Yk/mrR5wKZ7DWvvW4kUkXl2XHpkTzBzdWiZx3
         FAy6GeuSD7v2+Nowi/R7+cZTvOVfFwiTrlt2BVGVmw9RCpIp6aEZWBhG+66hXLa600It
         TmB3FUCYW/+Qz/b+TUWOKSbWKojJAMTNgoCmwkSAAqQ9ddTUUI7mnXRa0QJMb3pO5Ooq
         CyCCwMgU46laX15FUiNBN9D7ivlDHbmNycUxUaBUgbwf/6h36zGdMU6MLJM69DZpT6Ss
         lwrHw9NOaL6GPXEmWI98nFXpW5HPLJ5BYxRqp2q33rMCFQo/2HL29T/XQ8BZDHs+WAAs
         Qgaw==
X-Gm-Message-State: ACgBeo2zIZd1oooizAHIw+w/VzsWUvFy8QZ0z3AKnf81cgijsMuGI6YT
        UOC0Aw/L9hUAqJJiBPWd/tMDiA==
X-Google-Smtp-Source: AA6agR7SHBGl5VdYjMKVL5UzdrTUUcHRsum2qdgVfy4yK3qFurC9b/riPzx+QLdQbigJ4aBmocHf2Q==
X-Received: by 2002:a05:6512:3d0e:b0:48b:3976:b319 with SMTP id d14-20020a0565123d0e00b0048b3976b319mr5532909lfv.362.1659955673039;
        Mon, 08 Aug 2022 03:47:53 -0700 (PDT)
Received: from localhost.localdomain ([83.146.140.105])
        by smtp.gmail.com with ESMTPSA id l18-20020a2ea312000000b0025e040510e7sm1314321lje.74.2022.08.08.03.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 03:47:51 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Michael Hennerich <Michael.Hennerich@analog.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pavel Machek <pavel@ucw.cz>,
        Tim Harvey <tharvey@gateworks.com>,
        Robert Jones <rjones@gateworks.com>,
        Lee Jones <lee@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Reichel <sre@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Ricardo Rivera-Matos <r-rivera-matos@ti.com>,
        linux-hwmon@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 4/5] dt-bindings: Drop Robert Jones
Date:   Mon,  8 Aug 2022 13:47:11 +0300
Message-Id: <20220808104712.54315-5-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220808104712.54315-1-krzysztof.kozlowski@linaro.org>
References: <20220808104712.54315-1-krzysztof.kozlowski@linaro.org>
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

Emails to Robert Jones bounce ("550 5.2.1 The email account that you
tried to reach is disabled").

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/iio/imu/nxp,fxos8700.yaml | 2 +-
 Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml    | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/iio/imu/nxp,fxos8700.yaml b/Documentation/devicetree/bindings/iio/imu/nxp,fxos8700.yaml
index 479e7065d4eb..0203b83b8587 100644
--- a/Documentation/devicetree/bindings/iio/imu/nxp,fxos8700.yaml
+++ b/Documentation/devicetree/bindings/iio/imu/nxp,fxos8700.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Freescale FXOS8700 Inertial Measurement Unit
 
 maintainers:
-  - Robert Jones <rjones@gateworks.com>
+  - Jonathan Cameron <jic23@kernel.org>
 
 description: |
   Accelerometer and magnetometer combo device with an i2c and SPI interface.
diff --git a/Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml b/Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml
index 5a1e8d21f7a0..5e0fe3ebe1d2 100644
--- a/Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml
+++ b/Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml
@@ -19,7 +19,6 @@ description: |
 
 maintainers:
   - Tim Harvey <tharvey@gateworks.com>
-  - Robert Jones <rjones@gateworks.com>
 
 properties:
   $nodename:
-- 
2.34.1

