Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F1F6BC823
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjCPIES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjCPIEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:04:13 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F08A30298
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:03:55 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id fd5so4123717edb.7
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678953834;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b+cZwh2hI/bgGeKTrAQebGxqZCqqNNagfDg/OgVtVDg=;
        b=cLqpe5KxXJEEEdU7lSOKM8wQALxgGMFJ7k3H3uZCLHZcwJt7RArA6ZlrxFXuc5L0PA
         VY1qvxAs/j/HrGwfjHNXU5zEw8BerQ079NdnCkbydxb7QLjUT8xtYEDNP5IVymC+rT9X
         2xZ/ztafdHhNtxpn4EHuLsL8d4CZ8uDrH5NzHLoNTcFQ4q5yYyGXOPjW6U0WQB/7aRsO
         19asYfeQm60/lND7aq+D/a3VEyGqxStBfZobn3bbP0KKlrBr006iUZZ+ynG/7DGSn0F5
         KQrmsmYhVMMt84ps4528f2AwuljVQiuVNQ38eb+zuaB4ri/W4XSpn9Wh9HUvf96tbb66
         XXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678953834;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b+cZwh2hI/bgGeKTrAQebGxqZCqqNNagfDg/OgVtVDg=;
        b=WJ68xUUeQGqLOziS4/e/J+UDaqc4I1swDx+uk1KKeQUQazdV6a90a3g04c7a1utaS1
         yRFJUGKVblyMlBf7nbbJ/K0P8o2LDy0lBKtyH+7C/VYsPgveolUDBJEEWftqp39ToBua
         7WjLydIpRI1S5RN2kiQyE9tXOX3ENj3hp5pRPKe9w2gP3VpACGEEAheJQU6N340QYO2K
         Ru18dhmMlqcGf4LW7qyEDFyNYAvnQC+KMxzv6wykb9XNb1zjYh9wSkmZsFLBfz6TqWzK
         6ZKqXz0ocjkxBOz9CshZzqDMQQuzaXog9s7K8KdWuHXzk21TFt9wr5f9MAnhJgFac7kw
         Vhtw==
X-Gm-Message-State: AO0yUKWooGwKGWWVhKaTNDimrd7Cd/KfXi1TGB4+EKp1sSsTmd+DWDBN
        wzUTHblGZZHSa+b4dctJiyWRCA==
X-Google-Smtp-Source: AK7set++cHuluKT9KRDqdqU7M4iRO64R+sbBtAPAQnOnNLB7bIOQ5c0wLOiKR0IEg24HPnbLTZ1r2w==
X-Received: by 2002:a17:906:7687:b0:8a6:e075:e364 with SMTP id o7-20020a170906768700b008a6e075e364mr8804524ejm.26.1678953833948;
        Thu, 16 Mar 2023 01:03:53 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9827:5f65:8269:a95f? ([2a02:810d:15c0:828:9827:5f65:8269:a95f])
        by smtp.gmail.com with ESMTPSA id md21-20020a170906ae9500b0092b546b57casm3475456ejb.195.2023.03.16.01.03.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 01:03:53 -0700 (PDT)
Message-ID: <9038dba0-6f72-44a1-9f57-1c08b03b9c31@linaro.org>
Date:   Thu, 16 Mar 2023 09:03:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v7 4/6] dt-bindings: net: Add support StarFive dwmac
Content-Language: en-US
To:     Guo Samin <samin.guo@starfivetech.com>,
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
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
References: <20230316043714.24279-1-samin.guo@starfivetech.com>
 <20230316043714.24279-5-samin.guo@starfivetech.com>
 <cfeec762-de75-f90f-7ba1-6c0bd8b70dff@linaro.org>
 <93a3b4bb-35a4-da7c-6816-21225b42f79b@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <93a3b4bb-35a4-da7c-6816-21225b42f79b@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2023 09:02, Guo Samin wrote:
> 
> 
> -------- 原始信息 --------
> 主题: Re: [PATCH v7 4/6] dt-bindings: net: Add support StarFive dwmac
> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 收件人: Samin Guo <samin.guo@starfivetech.com>, linux-riscv@lists.infradead.org, netdev@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
> 日期: 2023/3/16
> 
>> On 16/03/2023 05:37, Samin Guo wrote:
>>> From: Yanhong Wang <yanhong.wang@starfivetech.com>
>>>
>>> Add documentation to describe StarFive dwmac driver(GMAC).
>>>
>> Thank you for your patch. There is something to discuss/improve.
>>
>>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>>> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
>>> Tested-by: Tommaso Merciai <tomm.merciai@gmail.com>
>>> ---
>>>  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
>>>  .../bindings/net/starfive,jh7110-dwmac.yaml   | 130 ++++++++++++++++++
>>>  MAINTAINERS                                   |   6 +
>>>  3 files changed, 137 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> index e4519cf722ab..245f7d713261 100644
>>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> @@ -91,6 +91,7 @@ properties:
>>>          - snps,dwmac-5.20
>>>          - snps,dwxgmac
>>>          - snps,dwxgmac-2.10
>>> +        - starfive,jh7110-dwmac
>>>  
>>>    reg:
>>>      minItems: 1
>>> diff --git a/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
>>> new file mode 100644
>>> index 000000000000..b59e6bd8201f
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
>>> @@ -0,0 +1,130 @@
>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>> +# Copyright (C) 2022 StarFive Technology Co., Ltd.
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/net/starfive,jh7110-dwmac.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: StarFive JH7110 DWMAC glue layer
>>> +
>>> +maintainers:
>>> +  - Emil Renner Berthing <kernel@esmil.dk>
>>> +  - Samin Guo <samin.guo@starfivetech.com>
>>> +
>>> +select:
>>> +  properties:
>>> +    compatible:
>>> +      contains:
>>> +        enum:
>>> +          - starfive,jh7110-dwmac
>>> +  required:
>>> +    - compatible
>>> +
>>> +properties:
>>> +  compatible:
>>> +    items:
>>> +      - enum:
>>> +          - starfive,jh7110-dwmac
>>> +      - const: snps,dwmac-5.20
>>> +
>>
>> reg:
>>   maxItems: 1
> 
>>
>>> +  clocks:
>>> +    items:
>>> +      - description: GMAC main clock
>>> +      - description: GMAC AHB clock
>>> +      - description: PTP clock
>>> +      - description: TX clock
>>> +      - description: GTX clock
>>> +
>>> +  clock-names:
>>> +    items:
>>> +      - const: stmmaceth
>>> +      - const: pclk
>>> +      - const: ptp_ref
>>> +      - const: tx
>>> +      - const: gtx
>>> +
>>
>> interrupts: ???
>>
> 
> Hi Krzysztof, 
> 
> snps,dwmac.yaml has defined the reg/interrupt/interrupt-names nodes,
> and the JH7110 SoC is also applicable.
> Maybe just add reg/interrupt/interrupt-names to the required ?

You need to constrain them.

> 
> 
>   required:
>     - compatible
> +   - reg
>     - clocks
>     - clock-names
> +   - interrupts
> +   - interrupt-names
>     - resets
>     - reset-names
Best regards,
Krzysztof

