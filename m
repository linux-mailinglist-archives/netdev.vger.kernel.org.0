Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21BA6BCE59
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 12:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjCPLgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 07:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjCPLgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 07:36:14 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254ED2884E
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 04:36:01 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id x3so6248091edb.10
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 04:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678966559;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DqDI/M1Af8/sNqbCpEB0H1SmBWIzYviu82ZtF7Bi/bY=;
        b=rRiEU5oazgQw0R1aSrCBttAqFSEJbGCKYqagvYeE7JYF//DJybGNz6QSbv2vA07802
         dlLfQ+Yulm4Iqsuz0cMhG7nEGJfRGeZqyJVaah9azQkwJm1F46Ci4e1AgEY8zzju++/g
         cEqoPpZjBM7kZVe2+ZcrvrjK6G1JXhVTodHZjT1QIGOE2dIBKG9C5jGGQzviDkwWfDQN
         C/sdbca1RYlv1W6tQHtImGRS3uNb4EZrh9ITaYedh8GcRQs9VXcnn4NnAAY76T8sdI8F
         wHLDEHsJcnRzHbhyrcGYBykxBR3sGVENScBstgDamWjuJOIk5QttOiqcWZQMSclPr9PO
         XkUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678966559;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DqDI/M1Af8/sNqbCpEB0H1SmBWIzYviu82ZtF7Bi/bY=;
        b=hMMcjwNXqVIT4RUFkjl/3zFb5xx7XjyS1ffaiEAF2MLm8xDf+pn7TBMm84lL47v6+h
         mNXAFdQCl8kzeIJW0tGgy5iNQmK+F+gnnyrxwzUYtEXLb0FKWPfWJyjQ8qszMJ6zWnRA
         3YrBh7LkDWMwrH61ERfUPbDhI846tqioO/o77coa3oiSlLqz/zqD+2Vhogc25R0MQeZ4
         zYj9fEIUdeAUWvBayimmjZS0pdR+2Pgpg4BoPur4Ts2tOxAHlUcXSWlWOhF9+5CegiAg
         /9ATwmh0AHJEl82WIJbByrQ3YhVuzyWbL3/WPJNSbKTS/YQqj4WUrxdJjaGlx5HZxjOO
         aHUQ==
X-Gm-Message-State: AO0yUKWU3Z1VCZmtoBbgRTx3NmgVM0/jAG46+/GODKLHL75GsuAWUHWP
        ZMLWWBSYM5reVXQRSC1Z6KXwvg==
X-Google-Smtp-Source: AK7set8sYZiwje7c5FUEwR9UZNt5fMGvnqOF2tI01ccg9IOBFjG/kdx4xLMiQvZ3K+XFDGc8yi4+vg==
X-Received: by 2002:aa7:c94e:0:b0:4fb:5089:6e01 with SMTP id h14-20020aa7c94e000000b004fb50896e01mr6438016edt.6.1678966559627;
        Thu, 16 Mar 2023 04:35:59 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9827:5f65:8269:a95f? ([2a02:810d:15c0:828:9827:5f65:8269:a95f])
        by smtp.gmail.com with ESMTPSA id g24-20020a50d0d8000000b004fd29e87535sm3714492edf.14.2023.03.16.04.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 04:35:59 -0700 (PDT)
Message-ID: <2751a83d-d3ff-8dbf-4fa3-dedc40d23d45@linaro.org>
Date:   Thu, 16 Mar 2023 12:35:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
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
 <9038dba0-6f72-44a1-9f57-1c08b03b9c31@linaro.org>
 <d2bb7fa5-206f-2059-bde0-b65e1acc44de@starfivetech.com>
 <c716e535-7426-56da-ca6f-51c7d7d69bb3@linaro.org>
 <b7766151-cf21-a5b4-e0ef-7b070e9e5c33@starfivetech.com>
 <d2eda9a8-f532-d7f0-7ef3-b3b8e1a0a79f@linaro.org>
 <ed8dbe90-ee1d-405a-5aa6-cbc16a0057ac@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <ed8dbe90-ee1d-405a-5aa6-cbc16a0057ac@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2023 11:18, Guo Samin wrote:
> 
> 
> -------- 原始信息 --------
> Re: [PATCH v7 4/6] dt-bindings: net: Add support StarFive dwmac
> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> to : Guo Samin <samin.guo@starfivetech.com>, linux-riscv@lists.infradead.org, netdev@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
> data: 2023/3/16
> 
>> On 16/03/2023 09:28, Guo Samin wrote:
>>>
>>>
>>> -------- 原始信息 --------
>>> 主题: Re: [PATCH v7 4/6] dt-bindings: net: Add support StarFive dwmac
>>> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>> 收件人: Guo Samin <samin.guo@starfivetech.com>, linux-riscv@lists.infradead.org, netdev@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
>>> 日期: 2023/3/16
>>>
>>>> On 16/03/2023 09:15, Guo Samin wrote:
>>>>>>>> interrupts: ???
>>>>>>>>
>>>>>>>
>>>>>>> Hi Krzysztof, 
>>>>>>>
>>>>>>> snps,dwmac.yaml has defined the reg/interrupt/interrupt-names nodes,
>>>>>>> and the JH7110 SoC is also applicable.
>>>>>>> Maybe just add reg/interrupt/interrupt-names to the required ?
>>>>>>
>>>>>> You need to constrain them.
>>>>>
>>>>>
>>>>> I see. I will add reg constraints in the next version, thanks.
>>>>>
>>>>> I have one more question, the interrupts/interrup-names of JH7110 SoC's gmac are exactly the same as snps,dwmac.yaml,
>>>>> do these also need to be constrained?
>>>>
>>>> The interrupts on common binding are variable, so you need to constrain
>>>> them - you have fixed number of them, right?
>>>>
>>>> Best regards,
>>>> Krzysztof
>>>>
>>>
>>> Yes, JH7110 fixed is 3 pcs. Thanks, I will constrain them.
>>
>> Then just minItems: 3, maxItems: 3 here should be enough
>>
>> Best regards,
>> Krzysztof
>>
> 
> Hi Krzysztof,
> 
> Thank you for the suggestion. 
> I'll change it like this in the next version, is right?

Yes, looks good for me.

Best regards,
Krzysztof

