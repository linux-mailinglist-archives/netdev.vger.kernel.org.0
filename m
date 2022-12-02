Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A0E64017E
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbiLBIDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbiLBIC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:02:59 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDA455AE
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:02:57 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id g12so6251144lfh.3
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 00:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4IdzLY27aCfwCW+1kAuSU/YopF0MIss2eIYe4Dhln+A=;
        b=WwORmOy0PdSeZraQD4PW1wRX4DBbzps3+/13hXtqSupW3mVWggBYxzs0sl9NVLdSR3
         SGeEXsKV58pwrZTUo0xD9oQKZOAoWVgCQ/pDd8C5UW9UJfhur8r2tV9ZgOs9deGme9w6
         xdqGGLei8ZRlIT5wNI5qoPpnR9uRFUV2onDVarxh16nbs7nwN++8pES26K5EiXr3QsmL
         /dkCeM9ha1Z125/Xe/w8PXBjc6J3t8Q83TYtDlbJPVp8ObRJ3O8VCRW1e7cD792FgVv8
         imvViUQyi4yU/4nWID4wMVr5YpA+Xdsg+8PWWt8rISVt3C2AKZYvUYg7RdpybprTPHb0
         wWsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4IdzLY27aCfwCW+1kAuSU/YopF0MIss2eIYe4Dhln+A=;
        b=wbPQ3rmWaZakPMXCwRyznb0MU+igIIArzLt1za6u92VxvtZkE7wKGRFIpNHXCMtH98
         rpxoh9hU4nw8Amc4cpjbZSZi7mfyYWSKg9UJ84NW6R+V/OlNX+DQiVRxJeRlE8xe1rFE
         Q/lv1P7b/UkJD7DI1xqFES//Ye/qrE1xbC3pEvJh87HstmpnfW4aSmrtGufyfVDxtXml
         PdN/9yGNg6dsu2BK6Uq/O70NFsxFbk7HyPUOdqybiya04W7iIOwz4MUaGOxnEisDOL5S
         8SzLJ8Kz+qSdmha6ZeRK7iz6xL0+dJ+OFV0CNRhBbWylYy/+1QaIv6NUpm02wgGHQtP/
         xgkw==
X-Gm-Message-State: ANoB5pnuXZ76QrrQxhwHOkI/1RbgtgErCvjjW2ZTA4ifABivP1IPSiAR
        GMkZHTyzYUieZbnw0zVL3H8XCg==
X-Google-Smtp-Source: AA0mqf70C1bJlKmKFjcvD7Qyc8TcS8FceaKeI5XTpRJUCRbVV4tThfx7ViN/h19grRUXplwWTc59zA==
X-Received: by 2002:a05:6512:4017:b0:4b1:be16:4a4a with SMTP id br23-20020a056512401700b004b1be164a4amr26683347lfb.0.1669968176004;
        Fri, 02 Dec 2022 00:02:56 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id x31-20020a0565123f9f00b00497a32e2576sm940879lfa.32.2022.12.02.00.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 00:02:55 -0800 (PST)
Message-ID: <84d26a47-2d7a-bf7d-9e0b-fd9952262620@linaro.org>
Date:   Fri, 2 Dec 2022 09:02:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1 3/7] dt-bindings: net: Add bindings for StarFive dwmac
Content-Language: en-US
To:     yanhong wang <yanhong.wang@starfivetech.com>,
        Conor Dooley <conor@kernel.org>
Cc:     linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
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
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-4-yanhong.wang@starfivetech.com>
 <36565cc1-3c48-0fa8-f98b-414a7ac8f5bf@linaro.org> <Y4jl6awCMFgZsQGC@spud>
 <1d3f1334-b6bf-57cb-7f7e-48e3c08a5560@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <1d3f1334-b6bf-57cb-7f7e-48e3c08a5560@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/12/2022 08:16, yanhong wang wrote:
> 
> 
> On 2022/12/2 1:35, Conor Dooley wrote:
>> On Thu, Dec 01, 2022 at 05:21:04PM +0100, Krzysztof Kozlowski wrote:
>>> On 01/12/2022 10:02, Yanhong Wang wrote:
>>>> Add bindings for the StarFive dwmac module on the StarFive RISC-V SoCs.
>>>
>>> Subject: drop second, redundant "bindings".
>>>
>>>>
>>>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>>>> ---
>>>>  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
>>>> +properties:
>>>> +  compatible:
>>>> +    oneOf:
>>>
>>> Drop oneOf. You do not have more cases here.
>>>
>>>> +      - items:
>>>> +          - enum:
>>>> +               - starfive,dwmac
>>>
>>> Wrong indentation.... kind of expected since you did not test the bindings.
>>>
>>>> +          - const: snps,dwmac-5.20
>>
>> Disclaimer: no familiarity with the version info with DW stuff
>>
>> Is it a bit foolish to call this binding "starfive,dwmac"? Could there
>> not be another StarFive SoC in the future that uses another DW mac IP
>> version & this would be better off as "starfive,jh7110-dwmac" or similar?
>>
> 
> The StarFive JH8100 SoC in the future that uses the same mac IP version, so call this binding "starfive,dwmac".

It's not a reason to make compatible generic.

Best regards,
Krzysztof

