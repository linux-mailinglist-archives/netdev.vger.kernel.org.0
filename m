Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75A8656854
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 09:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiL0ISt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 03:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiL0ISa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 03:18:30 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9E67657
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 00:18:27 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id cf42so18693938lfb.1
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 00:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ln/8Ql524XEPoI9ew3MSboAB3m1N4yBN0rK6DAhoSQc=;
        b=Gn8jP14aqJUl2sYT/CC74nEl6iK3r3GlM8+8U3U2+YDVio9yhnwmgt8kiSBHdIbqcZ
         ddDMnFUk4+QFTQuGirYV8QtkNE66naw29OBxcx0z8sYGypp/mQy3TidxPa/umQ3qgxGz
         P1fF5EZWv1mavEyymtzMJLNrgXuv8eaYS9qZNKXSxRAs8scvzL8HOiGSFuoA29gIrDU4
         CgwZGcGgIiqXJ+CU6dt7sBv3UVEMDJ1Kz6CfdlAqz5RUv7scScTe1mDYrPxpGJ+8ihmW
         jwh+XoTRXbJmB1BtsNOBREKB4Ka/6luOkNqYop1dp7ZxBs3D1q/P1SGWcAGjkFq1cs7w
         U2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ln/8Ql524XEPoI9ew3MSboAB3m1N4yBN0rK6DAhoSQc=;
        b=HPX2tc9mhlfPCc49qDkWUF3w1QXqOZjC6/W0Bq6lZOCf9VtI/31tjNEMCyoMs5KFIW
         aYzYcQa16OgMuSOzwQuiZa8qHOc3hbRDAajr5nJlNewozEWh7XVz7XQZJ0h64It/5LBK
         KTOAB5pb0IABKB1I/5pRVqQ0pGISIN73XwTxs3SVYIqmCcXPI6bDuIoRyxinYGsQZd+z
         E9hAqwyTk8cOvuvni/D6Ct+6NEsvrhzrMV8nLWchTJOIhKdwmAhXB7JhgEZpdZXlZoB/
         iC2RHFXpY3n1v9Tt8KKFJjkBVLKYp0799KblBJ8d/1QA6vJB4EMInSKRid67sSPILfMx
         JNEQ==
X-Gm-Message-State: AFqh2kp5P6WI9aliWG3+QmnLFJ2d5GCMjGdhmzxXR1EG8nywPZLbuxbJ
        vkcxntDNgnJsILZXiLCUT3nv6g==
X-Google-Smtp-Source: AMrXdXtinLKfEQpXrboACp/LM0hIqO/J5ZwM/NFnK4xJuv9eNoY6MPwpJBHtI2U0eFo6wqOde5ngRg==
X-Received: by 2002:a05:6512:3ba1:b0:4b5:8fbf:7dd6 with SMTP id g33-20020a0565123ba100b004b58fbf7dd6mr10587170lfv.61.1672129106302;
        Tue, 27 Dec 2022 00:18:26 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id m1-20020a197101000000b004b094730074sm2142854lfc.267.2022.12.27.00.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 00:18:25 -0800 (PST)
Message-ID: <526ab8a0-f77c-64f8-7209-c33bec8cb3e6@linaro.org>
Date:   Tue, 27 Dec 2022 09:18:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 2/9] dt-bindings: net: snps,dwmac: Update the maxitems
 number of resets and reset-names
Content-Language: en-US
To:     yanhong wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
 <20221216070632.11444-3-yanhong.wang@starfivetech.com>
 <040b56b1-c65c-34c3-e4a1-5cae4428d1d2@linaro.org>
 <7f4339df-6616-120f-f16a-cd38a2b6ea1d@starfivetech.com>
 <1a696768-45ef-0144-07f3-d356af9659e5@linaro.org>
 <25fce6e7-604e-6c07-3ff1-b65a5115a491@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <25fce6e7-604e-6c07-3ff1-b65a5115a491@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/12/2022 08:48, yanhong wang wrote:
> 
> 
> On 2022/12/20 17:21, Krzysztof Kozlowski wrote:
>> On 20/12/2022 07:48, yanhong wang wrote:
>>
>>>>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>>>> index e26c3e76ebb7..7870228b4cd3 100644
>>>>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>>>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>>>> @@ -133,12 +133,19 @@ properties:
>>>>>          - ptp_ref
>>>>>  
>>>>>    resets:
>>>>> -    maxItems: 1
>>>>> -    description:
>>>>> -      MAC Reset signal.
>>>>> +    minItems: 1
>>>>> +    maxItems: 3
>>>>> +    additionalItems: true
>>>>> +    items:
>>>>> +      - description: MAC Reset signal
>>>>>  
>>>>>    reset-names:
>>>>> -    const: stmmaceth
>>>>> +    minItems: 1
>>>>> +    maxItems: 3
>>>>> +    additionalItems: true
>>>>> +    contains:
>>>>> +      enum:
>>>>> +        - stmmaceth
>>>>
>>>> No, this is highly unspecific and you know affect all the schemas using
>>>> snps,dwmac.yaml. Both lists must be specific - for your device and for
>>>> others.
>>>>
>>>
>>> I have tried to define the resets in "starfive,jh71x0-dwmac.yaml", but it can not over-write the maxItems limit in "snps,dwmac.yaml",therefore, it will report error "reset-names: ['stmmaceth', 'ahb'] is too long"  running "make dt_binding_check". Do you have any suggestions to deal with this situation?
>>
>> The solution is not to affect all schemas with allowing anything as reset.
>>
>> If you need more items for your case, you can change snps,dwmac.yaml and
>> add constraints in allOf:if:then: allowing it only for your compatible.
>> There are plenty of examples how this is done, e.g.:
>>
>> https://elixir.bootlin.com/linux/v5.19-rc6/source/Documentation/devicetree/bindings/clock/samsung,exynos7-clock.yaml#L57
>>
> 
> Thanks. Refer to the definition in the example and update the definition as follows:
> 
> snps,dwmac.yaml[Partial Content]:
> 
> properties:
>   resets:
>     maxItems: 1
>     description:
>       MAC Reset signal.
> 
>   reset-names:
>     const: stmmaceth
> 
> allOf:
>   - if:
>       properties:
>         compatible:
>           contains:
>             const: starfive,jh7110-dwmac
> 
>     then:
>       properties:
>         resets:
>           minItems: 2
>           maxItems: 2
>         reset-names:
>           items:
>             - const: stmmaceth
>             - const: ahb
>       required:
>         - resets
>         - reset-names
> 
> 
> starfive,jh7110-dwmac.yaml[Partial Content]:
> 
> properties:
>   resets:
>     items:
>       - description: MAC Reset signal.
>       - description: AHB Reset signal.
> 
>   reset-names:
>     items:
>       - const: stmmaceth
>       - const: ahb
> 
> allOf:
>   - $ref: snps,dwmac.yaml#
> 
> It will also report error "reset-names: ['stmmaceth', 'ahb'] is too long"  running "make dt_binding_check" with 'starfive,jh7110-dwmac.yaml'. Do you have any better suggestions to solve this problem?

Because it is not correct. The top-level properties must have the widest
constraints which in allOf:if:then:else you are further narrowing for
all of variants. ALL.

https://elixir.bootlin.com/linux/v5.19-rc6/source/Documentation/devicetree/bindings/clock/samsung,exynos7-clock.yaml#L57

Best regards,
Krzysztof

