Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F9458C6DA
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 12:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242834AbiHHKsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 06:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242694AbiHHKrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 06:47:51 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A55012D37
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 03:47:49 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id z20so9386376ljq.3
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 03:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wtlxEtiRF9lqCy5R1k9yAeU8U13bw6nu384fYfSEqBw=;
        b=jv07OtZt2pyX0cJM44iITqxyodBbbHPDRiX71FoCVjTJ9XCj3HKpzDLaprbvsELIsH
         8GL8/jtjYb35pkZPiQn9Lrw8gkvIPe6INQik7whWlNe3P5KQeRDPb4WaK57tNa3zLaCA
         ncJc/TMltNRL+gsmrkJzoK5WLoL6MMGMjq05iKT5IFN8IPyzgHo+sJ9MUEu/A59RWVAm
         Ws2EiUwUDHptJP9HHb5q1V/fpZXAm6yqLaT3F4zsviTvFNol6Q5gHyV9mt4RpzFMB0AX
         NdBK/lBDAvz5fQnS2Yac3mIUt+j1+m3t3jp1W5c1zky+9sdQlLU2sKwrN2W4I76YbhVn
         l+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wtlxEtiRF9lqCy5R1k9yAeU8U13bw6nu384fYfSEqBw=;
        b=vZBQOclM6iphmrqKD/MRma4CWUM6p8F67M0OAnujwdYvMBGk5H7fwpTyAzD4QrXV5m
         9oCgFH7M2tHVVXr2AUZa5iU0f8XqPFD8ZUiEvsoNnbcib/z3C1oJTF2kGNGiL1JoEbgy
         W91Q5B4VDaSyAKDbIi8sUFhbjM7k27n94O41dCbpGyemOvPbfoZ5b+xWyCP7p3zxqjlS
         cQK5JnWnH9OaWKFVOm3IEKo/6fmFscF4e7/aq8c76MWrvlzHvaSwaRqMdhfdN7Vw0nhz
         3toH4MzJnemBq/DEMbWBsWw4FI0DzV8hXsi6iwBPR0OVywnemactUpUQR/oKgXi9cqCU
         IO3A==
X-Gm-Message-State: ACgBeo1LmoIcizhLUrNUD8nzEVyN+a1Fx2Ym+6kSPtvKXXnUR0ej7uIi
        ch8QKcmtgTokAD7ZlPzfyiMSuA==
X-Google-Smtp-Source: AA6agR6t9xJZKEAAv4TIEwAFqoquIJFksglsomLyRD3HG8nsDWNUsnErUldbfkSXaP31ifRT7EPZcQ==
X-Received: by 2002:a2e:9b42:0:b0:25e:59a7:6734 with SMTP id o2-20020a2e9b42000000b0025e59a76734mr5299134ljj.346.1659955667663;
        Mon, 08 Aug 2022 03:47:47 -0700 (PDT)
Received: from localhost.localdomain ([83.146.140.105])
        by smtp.gmail.com with ESMTPSA id l18-20020a2ea312000000b0025e040510e7sm1314321lje.74.2022.08.08.03.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 03:47:47 -0700 (PDT)
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
Subject: [PATCH 2/5] dt-bindings: iio: Drop Bogdan Pricop
Date:   Mon,  8 Aug 2022 13:47:09 +0300
Message-Id: <20220808104712.54315-3-krzysztof.kozlowski@linaro.org>
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

Emails to Bogdan Pricop bounce ("550 5.4.1 Recipient address rejected:
Access denied. AS(201806281)").

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/iio/adc/ti,adc108s102.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/iio/adc/ti,adc108s102.yaml b/Documentation/devicetree/bindings/iio/adc/ti,adc108s102.yaml
index 54955f03df93..ae5ce60987fe 100644
--- a/Documentation/devicetree/bindings/iio/adc/ti,adc108s102.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/ti,adc108s102.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Texas Instruments ADC108S102 and ADC128S102
 
 maintainers:
-  - Bogdan Pricop <bogdan.pricop@emutex.com>
+  - Jonathan Cameron <jic23@kernel.org>
 
 description: |
   Family of 8 channel, 10/12 bit, SPI, single ended ADCs.
-- 
2.34.1

