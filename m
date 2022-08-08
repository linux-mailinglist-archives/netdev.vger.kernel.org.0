Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F0258C6D6
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 12:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242783AbiHHKr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 06:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242587AbiHHKry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 06:47:54 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFB813F6E
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 03:47:52 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id d14so12012564lfl.13
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 03:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QVYe/JXzeU5u9X33rqqaxPzAShxb8AHqm/8GFEODkIs=;
        b=pmUTfKH5ygs4VlVm64UTqe8lyoNatQ30hpXCsJElxd9rETy5V8nzr2Ff8jTQ4allD1
         9CMNDGFP855XamTAn1sj9Ymfj7EDHM5fi+M0jVkwaf4cnsfNTGIXNKpSnxIEaJXvowLO
         i8SxkwcPaOL3j5JNW/9yh0NfVI5T+pLIime0VJXWE1zdjz7DHDz3FcyenyOcveqNA3wc
         8SxssDYAjPF5kNbKHFG2cj2UZtemX93RExbXld4gTIZ2m24dK825b0Et0t35c8GTu2nU
         2WytncCSIPBe/8XVhpqGgLO7ey0t7QXSh86AyRVn4Ed7tHlvx1IcB1j88RElI+CRpQ+y
         FzaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QVYe/JXzeU5u9X33rqqaxPzAShxb8AHqm/8GFEODkIs=;
        b=SVkaCj8bmzAwmFFPPc6IL2vk1ycyEH4y/de6zsTK+qascVZD4kt5BLEydjYZ6ckE3o
         3eOHT7WvGOuKG07q6YV5oQTvsdcGGDJZyZzu7ONWulzPfCQShnEHi49hJKm/bEIvhlSJ
         9/yNR9vpz8LhCPfRBD7uUIhCyjd3oEKG0suGkQz2yFTVGHUqQIYvXBjaaru3AoxQay5G
         o19HVKuxxcMm7kIgAQeEoJBtFnjnSo6VCcrHz885bRPe8WixXrHwqeMUKAKIzwlyEFbh
         l74VGri28o4NB4sHnQnWR4xvBt3YdmrpcmOJDVm70B54p7k7MmNrBiiAPngJTyQD5iCI
         yzdg==
X-Gm-Message-State: ACgBeo221XsIhpBJSe2aomKgr4YoVzpJShGqC3z3NodOpP3GdMS19A9Q
        RHyPykRt5JROx/K/JNCRQbOi9Q==
X-Google-Smtp-Source: AA6agR7uZzSpId0uQwcRPtkDecR7KFV0NXg+wtaUfNYpDtIDCx5dbwlw7cZocxxzXqUkqN216Ndp9A==
X-Received: by 2002:a05:6512:3342:b0:48b:4178:e8a5 with SMTP id y2-20020a056512334200b0048b4178e8a5mr4762468lfd.43.1659955670292;
        Mon, 08 Aug 2022 03:47:50 -0700 (PDT)
Received: from localhost.localdomain ([83.146.140.105])
        by smtp.gmail.com with ESMTPSA id l18-20020a2ea312000000b0025e040510e7sm1314321lje.74.2022.08.08.03.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 03:47:49 -0700 (PDT)
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
Subject: [PATCH 3/5] dt-bindings: Drop Beniamin Bia and Stefan Popa
Date:   Mon,  8 Aug 2022 13:47:10 +0300
Message-Id: <20220808104712.54315-4-krzysztof.kozlowski@linaro.org>
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

Emails to Beniamin Bia and Stefan Popa bounce ("550 5.1.10
RESOLVER.ADR.RecipientNotFound; Recipient not found by SMTP address
lookup").

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/hwmon/adi,adm1177.yaml       | 1 -
 Documentation/devicetree/bindings/iio/adc/adi,ad7091r5.yaml    | 2 +-
 Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml      | 3 +--
 .../devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml        | 1 -
 4 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/hwmon/adi,adm1177.yaml b/Documentation/devicetree/bindings/hwmon/adi,adm1177.yaml
index 154bee851139..d794deb08bb7 100644
--- a/Documentation/devicetree/bindings/hwmon/adi,adm1177.yaml
+++ b/Documentation/devicetree/bindings/hwmon/adi,adm1177.yaml
@@ -8,7 +8,6 @@ title: Analog Devices ADM1177 Hot Swap Controller and Digital Power Monitor
 
 maintainers:
   - Michael Hennerich <michael.hennerich@analog.com>
-  - Beniamin Bia <beniamin.bia@analog.com>
 
 description: |
   Analog Devices ADM1177 Hot Swap Controller and Digital Power Monitor
diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7091r5.yaml b/Documentation/devicetree/bindings/iio/adc/adi,ad7091r5.yaml
index 31ffa275f5fa..b97559f23b3a 100644
--- a/Documentation/devicetree/bindings/iio/adc/adi,ad7091r5.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7091r5.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Analog Devices AD7091R5 4-Channel 12-Bit ADC
 
 maintainers:
-  - Beniamin Bia <beniamin.bia@analog.com>
+  - Michael Hennerich <michael.hennerich@analog.com>
 
 description: |
   Analog Devices AD7091R5 4-Channel 12-Bit ADC
diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml b/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
index 73775174cf57..516fc24d3346 100644
--- a/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
@@ -7,8 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Analog Devices AD7606 Simultaneous Sampling ADC
 
 maintainers:
-  - Beniamin Bia <beniamin.bia@analog.com>
-  - Stefan Popa <stefan.popa@analog.com>
+  - Michael Hennerich <michael.hennerich@analog.com>
 
 description: |
   Analog Devices AD7606 Simultaneous Sampling ADC
diff --git a/Documentation/devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml b/Documentation/devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml
index a557761d8016..9fda56fa49c3 100644
--- a/Documentation/devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml
+++ b/Documentation/devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml
@@ -8,7 +8,6 @@ title: HMC425A 6-bit Digital Step Attenuator
 
 maintainers:
   - Michael Hennerich <michael.hennerich@analog.com>
-  - Beniamin Bia <beniamin.bia@analog.com>
 
 description: |
   Digital Step Attenuator IIO device with gpio interface.
-- 
2.34.1

