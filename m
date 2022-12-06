Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DF3643EDB
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 09:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbiLFIjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 03:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiLFIiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 03:38:46 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0C22664
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 00:38:44 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id s8so22553574lfc.8
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 00:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ANyVsngf65a+eFmtwb0iMJHr0EeOJEcLYKSjm4qNpxI=;
        b=NJMk55P+sC/tqvVTE5YgKq8nQusWlrdEnAyJYx0CsOvhX9rLKLkm4pnwSIvQk6SAZm
         ONCSQRQ1JXQIeAKiPGbM848T1ZIW2d7l+/tP6GaB06wKMQ1zq7TJupMR4/QJbvZ5AYzA
         KApImDchL4woQ6iEfLs7s0HrjmzKegSkNkD2M+/HxZDyfrsw9Jx1zbwGJH/Kk9Uly+lq
         zNtBHZXfMM1sNaFXNCHVqjnEJoph6+nUF/9/bZ9T+GjzR2z+j2IPdhMflij5zxKIwQwL
         FHdA+RgpZ0/9YNbYpGoZ2PzHSdM6qC735HYmAsZ2Ow4Ex7LA2iZ7foVSmULQ6AB52RdM
         W3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ANyVsngf65a+eFmtwb0iMJHr0EeOJEcLYKSjm4qNpxI=;
        b=O1mU9PDnNoIj5wEhdx70HRC/RphvJAlrwTDtewQGYsO4fQqSFk6CUX+ODx8U0eV8kn
         2zCjs65loJKwI7PwX5TLm8m7yLytaSMYTNex7akMLmCSw3KzetXajIQNjDYMuAzPQSJ2
         YgW/96yySQp7+aJImV3/OfyxjNmYv9Vht3I1f5mUlLXZuWY0a+9iDC759DN8pxQZXwyh
         oh6hAZ2MixhIBj861kmgkrewixONITcmaZ3nRISn1wNUzcP02Qprks7/kKoPynl989/u
         1KK3Aaib67EPxBdSqKxE9U5K8RVMgNH42+itcQ+YmmoYhBcdeL3LSqPTqNFLm5+3cLbB
         lZBw==
X-Gm-Message-State: ANoB5pkrKEXrdKs+WdyFiwWJKMbx4ww5o46Iw8MEZGFdCcGflN4WMqOa
        DiwdE4XtYKt8K9JYytAaQA3QHw==
X-Google-Smtp-Source: AA0mqf64avDHaRy5jJ5LqrBrk9vceu4eOGM5kyWEz2n90p+ntO8hFrEe7y5FzENUFnVh7tv2lJ+tuA==
X-Received: by 2002:a05:6512:445:b0:4b5:8d2c:fc36 with SMTP id y5-20020a056512044500b004b58d2cfc36mr31490lfk.505.1670315922955;
        Tue, 06 Dec 2022 00:38:42 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id bi20-20020a05651c231400b002773ac59697sm1599383ljb.0.2022.12.06.00.38.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 00:38:42 -0800 (PST)
Message-ID: <2597b9e5-7c61-e91c-741c-3fe18247e27c@linaro.org>
Date:   Tue, 6 Dec 2022 09:38:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next v1 3/4] dt-bindings: net: phy: add MaxLinear
 GPY2xx bindings
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>, Rob Herring <robh@kernel.org>
Cc:     Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-4-michael@walle.cc>
 <20221205212924.GA2638223-robh@kernel.org>
 <99d4f476d4e0ce5945fa7e1823d9824a@walle.cc>
 <9c0506a6f654f72ea62fed864c1b2a26@walle.cc>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <9c0506a6f654f72ea62fed864c1b2a26@walle.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/12/2022 09:29, Michael Walle wrote:
> Am 2022-12-05 22:53, schrieb Michael Walle:
>> Am 2022-12-05 22:29, schrieb Rob Herring:
>>> On Fri, Dec 02, 2022 at 04:12:03PM +0100, Michael Walle wrote:
>>>> Add the device tree bindings for the MaxLinear GPY2xx PHYs.
>>>>
>>>> Signed-off-by: Michael Walle <michael@walle.cc>
>>>> ---
>>>>
>>>> Is the filename ok? I was unsure because that flag is only for the 
>>>> GPY215
>>>> for now. But it might also apply to others. Also there is no 
>>>> compatible
>>>> string, so..
>>>>
>>>>  .../bindings/net/maxlinear,gpy2xx.yaml        | 47 
>>>> +++++++++++++++++++
>>>>  1 file changed, 47 insertions(+)
>>>>  create mode 100644 
>>>> Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
>>>>
>>>> diff --git 
>>>> a/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml 
>>>> b/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
>>>> new file mode 100644
>>>> index 000000000000..d71fa9de2b64
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
>>>> @@ -0,0 +1,47 @@
>>>> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>>>> +%YAML 1.2
>>>> +---
>>>> +$id: http://devicetree.org/schemas/net/maxlinear,gpy2xx.yaml#
>>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>>> +
>>>> +title: MaxLinear GPY2xx PHY
>>>> +
>>>> +maintainers:
>>>> +  - Andrew Lunn <andrew@lunn.ch>
>>>> +  - Michael Walle <michael@walle.cc>
>>>> +
>>>> +allOf:
>>>> +  - $ref: ethernet-phy.yaml#
>>>> +
>>>> +properties:
>>>> +  maxlinear,use-broken-interrupts:
>>>> +    description: |
>>>> +      Interrupts are broken on some GPY2xx PHYs in that they keep 
>>>> the
>>>> +      interrupt line asserted even after the interrupt status 
>>>> register is
>>>> +      cleared. Thus it is blocking the interrupt line which is 
>>>> usually bad
>>>> +      for shared lines. By default interrupts are disabled for this 
>>>> PHY and
>>>> +      polling mode is used. If one can live with the consequences, 
>>>> this
>>>> +      property can be used to enable interrupt handling.
>>>
>>> Just omit the interrupt property if you don't want interrupts and add 
>>> it
>>> if you do.
>>
>> How does that work together with "the device tree describes
>> the hardware and not the configuration". The interrupt line
>> is there, its just broken sometimes and thus it's disabled
>> by default for these PHY revisions/firmwares. With this
>> flag the user can say, "hey on this hardware it is not
>> relevant because we don't have shared interrupts or because
>> I know what I'm doing".

Yeah, that's a good question. In your case broken interrupts could be
understood the same as "not connected", so property not present. When
things are broken, you do not describe them fully in DTS for the
completeness of hardware description, right?

> 
> Specifically you can't do the following: Have the same device
> tree and still being able to use it with a future PHY firmware
> update/revision. Because according to your suggestion, this
> won't have the interrupt property set. With this flag you can
> have the following cases:
>   (1) the interrupt information is there and can be used in the
>       future by non-broken PHY revisions,
>   (2) broken PHYs will ignore the interrupt line
>   (3) except the system designer opts-in with this flag (because
>       maybe this is the only PHY on the interrupt line etc).

I am not sure if I understand the case. You want to have a DTS with
interrupts and "maxlinear,use-broken-interrupts", where the latter will
be ignored by some future firmware? Isn't then the property not really
correct? Broken for one firmware on the same device, working for other
firmware on the same device?

I would assume that in such cases you (or bootloader or overlay) should
patch the DTS...



Best regards,
Krzysztof

