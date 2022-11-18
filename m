Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF74E62F861
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 15:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241966AbiKROzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 09:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241701AbiKROz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 09:55:26 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70B18FE5E
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:55:25 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id i12so5750854wrb.0
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dlGYFl6XUQyH5xQEd1E/V0bevUlACNWAQdHVOgdC8jc=;
        b=yObTaGsa5pkib3AbTNfuBC8H28vZJR4hDG74Zwave5uRYVAMPPJnAqtb7j/mH3O6sN
         wSI/DxmsBmlohnlux6f8e/e9cy7iWKwXJCmVCa+yuWo3AVE4YbIYGt2IWhm86Zq4G+OS
         E3L1fUEWkIpmVIIkYfL9qjsgDvQO0DOUXmLsULq5Ujw5FFziIj5vypCFGt6pI/SXp4VV
         VmcT6KR0S7KVvA08BB1W8rW3T8NaXj7nGnTZiw5Kc11R4HGgm15/moMqyaz+f2pi/hMG
         ecIwHwlKULEctd20uFy9dkSyyiJ7/+B4TWUVhNONlzQQRZEEYY/ujUkktx7nHhV1YDKL
         p/4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dlGYFl6XUQyH5xQEd1E/V0bevUlACNWAQdHVOgdC8jc=;
        b=gwx+09dI7/rwYOqOBXUhFBQZUEcpgyoQVYD8Lryikl7oRu/eCdbv4eXEdMAr4uW1JX
         rY3FPCdUjabnz/XRlOAUC1XOmllPzlv0yoZTVqmP1Cjw/735IThP9rN1hqDEIq3GlMi8
         DLoiSNHxuKUALtSeTIup6jShF1Tt2FirezRel5QUbSQJNWaRw02cXh7dWcOIcshjQTBR
         ykZ+lXGCUGpvYtF4C2b6ok5MR3RybwS8QMWZSa5oNy8GU6m23MAQqR3GTNUW5B6se79Z
         RahsoaMv3tiNvwvNG/8GECnovWbaI4K3zDDg3uUsv4xY6R+7qET+5uXa4fuD2OLh6l3M
         hbDg==
X-Gm-Message-State: ANoB5pm3v8w7ymfVlVfe5L1zJUFPFwYuMIb4BJhHSMQLaW3G9lFbrIlq
        A6cBM9qtf56dWKkKSXev84mt+Q==
X-Google-Smtp-Source: AA0mqf5B4c3Ofn4nvA8MCzk2t7U4aqKAjKRq8PhiFCL67Pk/bpuzhbbgJcn6qstPNN1EKZyNDibw0g==
X-Received: by 2002:adf:fc48:0:b0:236:e0d:9ad with SMTP id e8-20020adffc48000000b002360e0d09admr4594782wrs.692.1668783324421;
        Fri, 18 Nov 2022 06:55:24 -0800 (PST)
Received: from ?IPV6:2a01:e0a:982:cbb0:f7cc:460c:56ae:45a? ([2a01:e0a:982:cbb0:f7cc:460c:56ae:45a])
        by smtp.gmail.com with ESMTPSA id a8-20020adffb88000000b002383fc96509sm3742721wrr.47.2022.11.18.06.55.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 06:55:24 -0800 (PST)
Message-ID: <95abd39d-b084-68e5-f012-6a1149bdb8a3@linaro.org>
Date:   Fri, 18 Nov 2022 15:55:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
From:   Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH 07/12] dt-bindings: power: remove deprecated
 amlogic,meson-gx-pwrc.txt bindings
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Eric Dumazet <edumazet@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, devicetree@vger.kernel.org
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v1-7-3f025599b968@linaro.org>
 <15840da8-bae2-3bb2-af0c-0af563fdc27d@linaro.org>
Organization: Linaro Developer Services
In-Reply-To: <15840da8-bae2-3bb2-af0c-0af563fdc27d@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/11/2022 15:52, Krzysztof Kozlowski wrote:
> On 18/11/2022 15:33, Neil Armstrong wrote:
>> Remove the deprecated amlogic,meson-gx-pwrc.txt bindings, which was
>> replaced by the amlogic,meson-ee-pwrc.yaml bindings.
>>
>> The amlogic,meson-gx-pwrc-vpu compatible isn't used anymore since [1]
>> was merged in v5.8-rc1 and amlogic,meson-g12a-pwrc-vpu either since [2]
>> was merged in v5.3-rc1.
>>
>> [1] commit 5273d6cacc06 ("arm64: dts: meson-gx: Switch to the meson-ee-pwrc bindings")
>> [2] commit f4f1c8d9ace7 ("arm64: dts: meson-g12: add Everything-Else power domain controller")
> 
> As of next-20221109 I see both compatibles used, so something here is
> not accurate.

Yes driver still exists, was left for compatibility with older DTs during the migration.

> 
>>
>> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
>> ---
>>   .../bindings/power/amlogic,meson-gx-pwrc.txt       | 63 ----------------------
>>   1 file changed, 63 deletions(-)
>>
> 
> 
> Best regards,
> Krzysztof
> 

