Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715086BCBBE
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjCPJ7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjCPJ6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:58:49 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A906F95BDF
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 02:58:25 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id cy23so5114791edb.12
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 02:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678960704;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7rGyVHn72S3f+yP1Dpa8iV3gyVbOxOtWl0FDsXatOAo=;
        b=wotGgL7cieAvnZJI1ayV9RrXnV5X/12AOH5ogveYXgGa4RTFpKtGAdB5mDKcpBO8+D
         7s9zugMXv9XO4iJWNTddZo58NpTxi4FkZVJwn/6/InkPGE9hc2Zo3n8PdZCc41z/gN+L
         I0dNoX/+1vJ9MIeb51CJC8m0HBeXhe8KylNjXAw5JrPwgcfMy5FJGIwaW8NLsPOmaxFh
         suzxwhZmovIFO2X7pDnjfCboClsW+ASPPqV3xMg42Ep4BYR6aAjnRAlCWNQY0kKF+gUj
         JcXs8ddLMCkHZvP9D0FSskVVRkXal0qqppGP91erVttch6wFrtMzNYB5BDnx6BJKIZgx
         aP/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678960704;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7rGyVHn72S3f+yP1Dpa8iV3gyVbOxOtWl0FDsXatOAo=;
        b=EGiVqPm+ehMBABctvBHtDFg8wNa2rl9uo+DpbgzWpUmVzWNqoDT28+46jYPlcjU8I0
         mbJwi1vBnr1hQ/WpVzIe4p4wnmz4vCjfsxTCIfOLl2f7mweScFHc4TGACarX76RCEYiB
         CZTu6qeXXK0R9Wqwi37ekfQZFXH+upXLZbKLSbEBfa50vfZNuReKWemzaCMJsMcXy7lf
         B2JX1G1s1wymJQGkiDrgu7WhSFSN/Cy0aWTbADUOjxOIlPncfOLmEuvSm1zGgqrW8fZ0
         gjsT01+3zUWCaRXq9IY7XGYB0DNgRD26Tb8cbCP53Y1RDVexeQZqpGOfnAwkZGIEGuEE
         J8PQ==
X-Gm-Message-State: AO0yUKWtyENQe4qseRHE5EyT0NJOaDWfFEHpw3hF3Q2hyoZZuiRmaHyD
        ugUOEhLHPFFV+nJ+l2m3YeD8f9nNjJvhuHRtLtk=
X-Google-Smtp-Source: AK7set+uFvdmcmTzTE5XT99s0No3h1JbE0DG2UjhiIjcQ+/02A3xmqNlG8+ZhcJq7kpCG02F0bNZag==
X-Received: by 2002:a17:907:d482:b0:8e5:2a12:8ec0 with SMTP id vj2-20020a170907d48200b008e52a128ec0mr9457794ejc.31.1678960704057;
        Thu, 16 Mar 2023 02:58:24 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9827:5f65:8269:a95f? ([2a02:810d:15c0:828:9827:5f65:8269:a95f])
        by smtp.gmail.com with ESMTPSA id l9-20020a50d6c9000000b004fc649481basm3614242edj.58.2023.03.16.02.58.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 02:58:23 -0700 (PDT)
Message-ID: <d2eda9a8-f532-d7f0-7ef3-b3b8e1a0a79f@linaro.org>
Date:   Thu, 16 Mar 2023 10:58:22 +0100
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
 <9038dba0-6f72-44a1-9f57-1c08b03b9c31@linaro.org>
 <d2bb7fa5-206f-2059-bde0-b65e1acc44de@starfivetech.com>
 <c716e535-7426-56da-ca6f-51c7d7d69bb3@linaro.org>
 <b7766151-cf21-a5b4-e0ef-7b070e9e5c33@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <b7766151-cf21-a5b4-e0ef-7b070e9e5c33@starfivetech.com>
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

On 16/03/2023 09:28, Guo Samin wrote:
> 
> 
> -------- 原始信息 --------
> 主题: Re: [PATCH v7 4/6] dt-bindings: net: Add support StarFive dwmac
> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 收件人: Guo Samin <samin.guo@starfivetech.com>, linux-riscv@lists.infradead.org, netdev@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
> 日期: 2023/3/16
> 
>> On 16/03/2023 09:15, Guo Samin wrote:
>>>>>> interrupts: ???
>>>>>>
>>>>>
>>>>> Hi Krzysztof, 
>>>>>
>>>>> snps,dwmac.yaml has defined the reg/interrupt/interrupt-names nodes,
>>>>> and the JH7110 SoC is also applicable.
>>>>> Maybe just add reg/interrupt/interrupt-names to the required ?
>>>>
>>>> You need to constrain them.
>>>
>>>
>>> I see. I will add reg constraints in the next version, thanks.
>>>
>>> I have one more question, the interrupts/interrup-names of JH7110 SoC's gmac are exactly the same as snps,dwmac.yaml,
>>> do these also need to be constrained?
>>
>> The interrupts on common binding are variable, so you need to constrain
>> them - you have fixed number of them, right?
>>
>> Best regards,
>> Krzysztof
>>
> 
> Yes, JH7110 fixed is 3 pcs. Thanks, I will constrain them.

Then just minItems: 3, maxItems: 3 here should be enough

Best regards,
Krzysztof

