Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CF56BA8CB
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjCOHLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjCOHLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:11:15 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EA5168BB
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:11:12 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y4so42174553edo.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678864270;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RJKjy9eK5wZQcLG5fFeMeaK9idc1WueAlGl5cn4lHVQ=;
        b=Bsyq91aeeTKsmlxTlYJI010C+B/lkrmiPlzr++t5RiGJkiL9FWgJQAMu4ndc0dD+qt
         bEyp1MWTUlzNQHtaC2+56g8+iWouWBuRidMKrm2RUOdt6+3iAfCmPd6IY+SP59Fp+coY
         oZkjnHSaUlA6DtLSvwYNivKPiKWBC8j52WMFZiitR7bz62y11hQ1c2IrhCXVGnLV1NwZ
         zQHiswP6WArtrzrbxtmHYCe5SCUCGS9tYVy6SGZMoBXzxjg62E/GdCHaqDufA0ieDEM5
         EOKs7EC6GXQNpkpvS50aAVqarob3qGI1wwL8dt7TT5vv9io2zPkKrG01Hwg9AmHHoxb8
         iqBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678864270;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RJKjy9eK5wZQcLG5fFeMeaK9idc1WueAlGl5cn4lHVQ=;
        b=5umssfrRXdF+RSyX2UB15IQvXBXPm4KUrDqzbbcX5To2SlXry/i/u935Ab2NVkErVE
         fl8TlBSjbRVPi8BuX3qGr1GziEH6b7TluQYkh4wm5UAE5m+Bisg+XzBiNsqx3MRSi0eP
         geAUIGDz1GQr1CqHpqj3k3pskq6COcliN1jWaFZkNQgWE0TWgwZLZCo7Y2fBRYBHI9i4
         L6VGApciNCVXuhwnoXRmb4meLkYKukx9EeKi2rnRCiomSTF4xFyMt/Q3mTyA/af84YRw
         AezLeeprDEOu/gDw47whgXdAuUXAsL/3j8g9q+jdOHxjRM1RoYiLyLinED6YPEqyOD+x
         oGDg==
X-Gm-Message-State: AO0yUKVj7Cx7KMzNBFB9umYvilCIiTHjQzIo/eBcfjCHvgNkjTYaqSed
        UzeS3Ry3kY8KMkn0XLLilVVNHw==
X-Google-Smtp-Source: AK7set/qDWN5EGtvyO4q718AHYQ/mq+PNb2Tfe4xtM7aMrCVi4QxJZNgnoNyQ52prNArRS2/pT1mwg==
X-Received: by 2002:a05:6402:453:b0:4ea:a9b0:a518 with SMTP id p19-20020a056402045300b004eaa9b0a518mr1200057edw.17.1678864270104;
        Wed, 15 Mar 2023 00:11:10 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:940e:8615:37dc:c2bd? ([2a02:810d:15c0:828:940e:8615:37dc:c2bd])
        by smtp.gmail.com with ESMTPSA id u14-20020a50a40e000000b004bbb691a334sm1960301edb.2.2023.03.15.00.11.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 00:11:09 -0700 (PDT)
Message-ID: <19ca470e-8219-5ba9-3de6-f4560278f87b@linaro.org>
Date:   Wed, 15 Mar 2023 08:11:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] p54spi: convert to devicetree
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Felipe Balbi <balbi@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?UTF-8?Q?Beno=c3=aet_Cousson?= <bcousson@baylibre.com>,
        Russell King <linux@armlinux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20230314163201.955689-1-arnd@kernel.org>
 <4ac809d2-3924-3839-479f-0b4be9f18a1f@linaro.org>
 <e19fd8bc-5944-409d-a4a1-3a3d53691634@app.fastmail.com>
 <57c42604-38b0-61ce-2fc4-2284fbb9d708@linaro.org>
 <afee6a67-2406-4f52-99a2-ee7eb26e587b@app.fastmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <afee6a67-2406-4f52-99a2-ee7eb26e587b@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2023 07:50, Arnd Bergmann wrote:
> On Wed, Mar 15, 2023, at 07:32, Krzysztof Kozlowski wrote:
>> On 14/03/2023 22:40, Arnd Bergmann wrote:
>>
>>>>> +
>>>>> +  power-gpios:
>>>>
>>>> If this is GPIO driving some power pin, then it should be
>>>> "powerdown-gpios" (like in /bindings/gpio/gpio-consumer-common.yaml)
>>>
>>> As far as I can tell, it's the opposite: the gpio turns the power on
>>> in 'high' state. I could make it GPIO_ACTIVE_LOW and call it powerdown,
>>> if you think that's better, but I don't think that is how it was
>>> meant.
>>
>> Whether this is active low or high, I think does not matter. If this is
>> pin responsible to control the power, then we use the name
>> "powerdown-gpios". Effectively powerup GPIO is the same as powerdown,
>> just reversed.
> 
> Ok, so should I make this GPIO_ACTIVE_LOW and adapt the patch to
> call it powerdown in both the code and dt for consistency?

If you have schematics (or datasheet) then this should reflect truth. If
not, then judging by the old code it is something like powerdown, so yes
- ACTIVE_LOW and reverse values in the code.

Best regards,
Krzysztof

