Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD12599C39
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 14:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbiHSMlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 08:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348496AbiHSMlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 08:41:00 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F201A1DA75
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 05:40:58 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id z6so5955120lfu.9
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 05:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=vu2lHdZxEJpxevVE8eil1qxgFt43nikAxZVf13/nJys=;
        b=VDbRbwgBCqlvGplcG49N2W2pqBty1ZXmsqM9ti5lVULn8qCrNwpzo4W4gHp2usxMya
         oAsYzH5Vhwu7qq0lKCQdIujO24m/7EVtTOkK365b3AQtl3fYUBSvV75onErnYW1XMzNm
         U6KpBKZInfm1Hd8R4FTmo1Vq4lZuzkz5UTcjOAXN6xx6tVneuRGeBLIBEnuzRSKA3YXz
         Z3wOBk7yoLLZWrC8AvjYuBN8Cv6W9D9TpCakQwJKdoUlkqsPJJrKxKdmMYZ4IYJLwZeX
         r91KoUsH5bsl1e6OkR3y+iG7hnX5yUehzk4JBygP6g6p6yHVzxmIS3O6B1HmJWupv4H8
         tZuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=vu2lHdZxEJpxevVE8eil1qxgFt43nikAxZVf13/nJys=;
        b=c96aJmjXRcpw1r3j4gC0FCOrVs5tcl/D7I0gcBdpwGe+c1rJwRbz3cd2KQF2omBdF2
         HxOHd16vfbtSkt4im263+9aVENZz3Y8UQY+3jJxzWw/TLvrj76UwXt8IUWrQr/HwCW+e
         Yr/fYDgajHKjCNW0d+P/aRqZRTQ03ORPwHTpZldS2VLwt471BwUJAjxp8A7bQUQEN0pN
         nWUi2wL8r5ewYy0I4r3MhF5e9bzoeFkFhgf/BIdmcxoFfc0+0/RrrKv25w/ePdFi//Ju
         7XWaLYoPEn63soCewY9ibI69ZL//7V1E2CoTQnt4rOywFZSsEcR6YhCj+1RgyulQC4Fd
         QPIA==
X-Gm-Message-State: ACgBeo0Wk9R/2ix9CWJAyh+YQyc0zdrOmN7oTQ7c/y72yxLQ7FdxY/Gx
        zNv0INiW5aKR3TIPtAbwbsSAmA==
X-Google-Smtp-Source: AA6agR4J0Ea6eFpB2FAYhtL/1C6G9QtgQ0s9SRqW88AqI0njZbR8KWIKtwNgd6F0NHKqPvcSU9d+Dw==
X-Received: by 2002:a05:6512:1091:b0:491:f135:4633 with SMTP id j17-20020a056512109100b00491f1354633mr2651400lfg.553.1660912857246;
        Fri, 19 Aug 2022 05:40:57 -0700 (PDT)
Received: from ?IPV6:2001:14bb:ac:e5a8:ef73:73ed:75b3:8ed5? (d1xw6v77xrs23np8r6z-4.rev.dnainternet.fi. [2001:14bb:ac:e5a8:ef73:73ed:75b3:8ed5])
        by smtp.gmail.com with ESMTPSA id d4-20020ac25444000000b0048ad4c718f3sm628432lfn.30.2022.08.19.05.40.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 05:40:56 -0700 (PDT)
Message-ID: <cb605db2-62f2-b585-1978-ef0d675bcfb3@linaro.org>
Date:   Fri, 19 Aug 2022 15:40:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 4/4] dt-bindings: net: dsa: mediatek,mt7530: update
 json-schema
Content-Language: en-US
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220730142627.29028-1-arinc.unal@arinc9.com>
 <20220730142627.29028-5-arinc.unal@arinc9.com>
 <e5cf8a19-637c-95cf-1527-11980c73f6c0@linaro.org>
 <bb60608a-7902-99fa-72aa-5765adabd300@arinc9.com>
 <8a665b7a-bbd0-99ce-658e-bc78568bdca2@linaro.org>
 <40130c63-1e36-bb43-43b4-444a8f287226@linaro.org>
 <70e246af-c336-0896-95b5-9e42a17a239d@arinc9.com>
 <3731cd56-f7e8-6807-06b5-b8b176b078b6@linaro.org>
 <24e251d7-f5db-5715-463d-333f5dfbfceb@arinc9.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <24e251d7-f5db-5715-463d-333f5dfbfceb@arinc9.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/08/2022 17:06, Arınç ÜNAL wrote:
> 
> 
> On 12.08.2022 16:48, Krzysztof Kozlowski wrote:
>> On 12/08/2022 16:41, Arınç ÜNAL wrote:
>>> On 12.08.2022 10:01, Krzysztof Kozlowski wrote:
>>>> On 12/08/2022 09:57, Krzysztof Kozlowski wrote:
>>>>> On 12/08/2022 01:09, Arınç ÜNAL wrote:
>>>>>>>> -patternProperties:
>>>>>>>> -  "^(ethernet-)?ports$":
>>>>>>>> -    type: object
>>>>>>>
>>>>>>> Actually four patches...
>>>>>>>
>>>>>>> I don't find this change explained in commit msg. What is more, it looks
>>>>>>> incorrect. All properties and patternProperties should be explained in
>>>>>>> top-level part.
>>>>>>>
>>>>>>> Defining such properties (with big piece of YAML) in each if:then: is no
>>>>>>> readable.
>>>>>>
>>>>>> I can't figure out another way. I need to require certain properties for
>>>>>> a compatible string AND certain enum/const for certain properties which
>>>>>> are inside patternProperties for "^(ethernet-)?port@[0-9]+$" by reading
>>>>>> the compatible string.
>>>>>
>>>>> requiring properties is not equal to defining them and nothing stops you
>>>>> from defining all properties top-level and requiring them in
>>>>> allOf:if:then:patternProperties.
>>>>>
>>>>>
>>>>>> If I put allOf:if:then under patternProperties, I can't do the latter.
>>>>>
>>>>> You can.
>>>
>>> Am I supposed to do something like this:
>>>
>>> patternProperties:
>>>     "^(ethernet-)?ports$":
>>>       type: object
>>>
>>>       patternProperties:
>>>         "^(ethernet-)?port@[0-9]+$":
>>>           type: object
>>>           description: Ethernet switch ports
>>>
>>>           unevaluatedProperties: false
>>>
>>>           properties:
>>>             reg:
>>>               description:
>>>                 Port address described must be 5 or 6 for CPU port and
>>>                 from 0 to 5 for user ports.
>>>
>>>           allOf:
>>>             - $ref: dsa-port.yaml#
>>>             - if:
>>>                 properties:
>>>                   label:
>>>                     items:
>>>                       - const: cpu
>>>               then:
>>>                 allOf:
>>>                   - if:
>>>                       properties:
>>
>> Not really, this is absolutely unreadable.
>>
>> Usually the way it is handled is:
>>
>> patternProperties:
>>     "^(ethernet-)?ports$":
>>       type: object
>>
>>       patternProperties:
>>         "^(ethernet-)?port@[0-9]+$":
>>           type: object
>>           description: Ethernet switch ports
>>           unevaluatedProperties: false
>>           ... regular stuff follows
>>
>> allOf:
>>   - if:
>>       properties:
>>         compatible:
>>           .....
>>     then:
>>       patternProperties:
>>         "^(ethernet-)?ports$":
>>           patternProperties:
>>             "^(ethernet-)?port@[0-9]+$":
>>               properties:
>>                 reg:
>>                   const: 5
>>
>>
>> I admit that it is still difficult to parse, which could justify
>> splitting to separate schema. Anyway the point of my comment was to
>> define all properties in top level, not in allOf.
>>
>> allOf should be used to constrain these properties.
> 
> The problem is:
> - only specific values of reg are allowed if label is cpu.
> - only specific values of phy-mode are allowed if reg is 5 or 6.
> 
> This forces me to define properties under allOf:if:then. 

None of the reasons above force you to define properties in some
allOf:if:then subblock. These force you to constrain the properties in
allOf:if:then, but not define.

> Splitting to 
> separate schema (per compatible string?) wouldn't help in this case.

True.

> 
> I can split patternProperties to two sections, but I can't directly 
> define the reg property like you put above.

Of course you can and original bindings were doing it.

Let me ask specific questions (yes, no):
1. Are ethernet-ports and ethernet-port present in each variant?

2. Is dsa-port.yaml applicable to each variant? (looks like that - three
compatibles, three all:if:then)
3. If reg appearing in each variant?
4. If above is true, if reg is maximum one item in each variant?

Looking at your patch, I think answer is 4x yes, which means you can
define them in one place and constrain in allOf:if:then, just like all
other schemas, because this one is not different.

Best regards,
Krzysztof
