Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76806B11CB
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjCHTKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 14:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjCHTJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:09:56 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F276A8389
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 11:09:37 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id ay14so66132098edb.11
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 11:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678302576;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KkeMJhDrlZR0CW+jwOzfg7rjixWcjZ+Lh7Jc51LTf60=;
        b=B96dkgosvOFrjaliQ2bHaZnATfVIl/u0wBOla4aMLgLW9v7xGKNsAkGfFhgplw/1qx
         9PRA7zHf3N1TVpwuke4D1gGgHY1638Z9T+V2C3Kw2LDrlUZzrs0ABAehuNtoBHXHBE4E
         HeyUOgofgRQSJJyBL0AmFHfa8ywTIePc5ncbH6l2Q+drnSOaj08jk30dpNleG5AHJMI+
         NfjbwhpbKbNVO4zrVwktv+RSP1Rbx3nSSh1N+TsBtdGqi8VWcJZQe6x/n+b/wk4rXXBg
         NnF2fG7Un4CHiSilqpPlb82PHWhwybO6LviZEcqwmZXSwJ9b3Ms8elEBgzVUuYJqx4nO
         Ev2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678302576;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KkeMJhDrlZR0CW+jwOzfg7rjixWcjZ+Lh7Jc51LTf60=;
        b=B7VdCQbHrrzP1FvRje2fHzowBRuI+KtcNufHDDec4MYeiGusCCXIStufLNjznEW9JU
         T0HPQeSakT1hJAC97l1MeZXyYi7bJX6IyZqs5WZ67RXa1oOz9ZDpAs564yUd2WLSODeT
         L6HuJ8QG+GVuWqq9nvitHJfDVnFpfF4IrEV6prKhUz2r/mOvnK4krBbf7rLedbsTfxxc
         AyqDYM8gyu371KWsssYdXCo1p3eH4VNEr3/v30LV5h2TuTw1arU52BxIlJQVjy281h1V
         AjVlNA9F5O5e7EcOpmxt0wh0UwWgmnYas2F8d20o/b3uoZLcsB9QPxR7CVo/XY7/qcVF
         ZhWA==
X-Gm-Message-State: AO0yUKXoxeEF21ZBnHrAquuQooxi+ddbJpzXXBNFFzI0EIXb3lF+yfaQ
        D7UjcTslF3vyUydLzuqTo7Hh+Q==
X-Google-Smtp-Source: AK7set+R6sbw18cgLNiAvl5saG3Boseyg7OJmQeoP4FW1+FdDJOmHm71GRSBxtg+nuJlzIzOZwY6oA==
X-Received: by 2002:a17:906:da82:b0:88f:9f5e:f40 with SMTP id xh2-20020a170906da8200b0088f9f5e0f40mr27784941ejb.68.1678302576476;
        Wed, 08 Mar 2023 11:09:36 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:ff33:9b14:bdd2:a3da? ([2a02:810d:15c0:828:ff33:9b14:bdd2:a3da])
        by smtp.gmail.com with ESMTPSA id g10-20020a50d0ca000000b004bc9d44478fsm8601884edf.51.2023.03.08.11.09.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 11:09:36 -0800 (PST)
Message-ID: <36169a8a-d418-6d7e-b64c-a7c346b9a218@linaro.org>
Date:   Wed, 8 Mar 2023 20:09:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [net-next PATCH 09/11] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
 <20230307170046.28917-10-ansuelsmth@gmail.com>
 <ad43a809-b9fd-bd24-ee1a-9e509939023b@linaro.org>
 <df6264de-36c5-41f2-a2a0-08b61d692c75@lunn.ch>
 <5992cb0a-50a0-a19c-3ad1-03dd347a630b@linaro.org>
 <6408dbbb.1c0a0220.a28ce.1b32@mx.google.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <6408dbbb.1c0a0220.a28ce.1b32@mx.google.com>
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

On 08/03/2023 20:02, Christian Marangi wrote:
> On Wed, Mar 08, 2023 at 07:49:26PM +0100, Krzysztof Kozlowski wrote:
>> On 08/03/2023 14:57, Andrew Lunn wrote:
>>> On Wed, Mar 08, 2023 at 11:58:33AM +0100, Krzysztof Kozlowski wrote:
>>>> On 07/03/2023 18:00, Christian Marangi wrote:
>>>>> Add LEDs definition example for qca8k Switch Family to describe how they
>>>>> should be defined for a correct usage.
>>>>>
>>>>> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
>>>>
>>>> Where is the changelog? This was v8 already! What happened with all
>>>> review, changes?
>>>
>>> Did you read patch 0?
>>>
>>> We have decided to start again, starting small and working up. This
>>> patchset just adds plain, boring LEDs. No acceleration, on hardware
>>> offload. Just on/off, and fixed blink.
>>
>> Sure, but the patch is carried over. So what happened with all its
>> feedback? Was there or was not? How can we know?
>>
> 
> The history of the old series is a bit sad, not enough review, another
> dev asking for a different implementation and me doing an hybrid to
> reach a common point (and then disappear intro oblivion)...
> 
> Short story is that this current series have nothing related to the HW
> offload feature and only in v7 it was asked to put the LED nodes in
> ethernet-phy.yaml
> 
> I can put in the cover letter of v2 of this series the changelog of the
> previous series but they would only be related to other part that are
> not related to this.
> 
> Just to give you some context and explain why the changelog was dropped.

I am less interested in the changelog of entire patchset but of the
patches which are for me to review. Sending vX as v1 suggests that all
previous review work on this patch could be in some limbo state. Maybe
nothing happened in all previous version, but it's now my task to dig it?

This is why you have "---" for the patch changelog.

Best regards,
Krzysztof

