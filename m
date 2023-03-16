Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3696BC8D5
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjCPIU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjCPIU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:20:27 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C610B3E28
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:20:07 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id y4so4343155edo.2
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678954805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BynrooWKIxkWeQyg7mnmSJ2ueKqYW94JcoiUOzTY5V4=;
        b=vkBiUbvG/+vI40uyHOAzlaDtm41eW8cO0hQ5d/d7/CKQOmZ2ZB7RyW9C3bbzIiF4Pi
         8d0v5MpmyIgLBIrbh/z1TSS1Yd2Ud1QkqtrGdGHS8iZs5DJzIFtnFqsAURZ1JV+JBLND
         wqrkwPNcwJ0hW6jBrL1HKjACeL+s43lLtaJlV8ND+78p+ZHiQzuhGAr9lr5XCUiKMoHU
         DvnjMArYvi0rz6Ah/xD22s62iK1DxRsHv0v0QRsvKV+xmm/K52GWYpLoJ+k04GerG650
         6Id5O6ixn2cmqFWkXAbUMhPPBRqTIH4bs81mhA9aIWHKiRrOF4moQjaepOqyiPV7r1LX
         Lcqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678954805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BynrooWKIxkWeQyg7mnmSJ2ueKqYW94JcoiUOzTY5V4=;
        b=Ys4T7wxi/y3WBEbsaSiqSOxE/dxVCsgDzpnZp+NhxK2DvLeafSEcqCxuO3UmBR8TjY
         zfyy1AfJbUigLM4FUS94l7xWYIXR/q2cfXeVjPzGOAuu/RVX5JFXqeCEXgyjXxUr9ztp
         SOy8f1gagjxEc/z5tjzceFEWcET0qJDrxMt1PYDRsvs5FLSh+Goh37Gf9r8jzzVKqevb
         kuTXSUXAOKSpR/w8ER8w+XGSmar7sv7Bqor22CHaWUL6FMEQ5L6TvX+/2V34Eg9Nvyt4
         h/9CJy/fkfwbzAvYMwWHyx/YGFaM8BajkeFwHlRb3SyQm6u08gP35SE3k1Gaz7qMNkGy
         T+Cg==
X-Gm-Message-State: AO0yUKVEoNABy2BYpe7bI3C2qeF5ehTCVnh6FgQO6x3mCqpweIRj46zr
        0VmgNXCkMEg6coA2Q7J+XfuUZQ==
X-Google-Smtp-Source: AK7set8dYeIq31oR9827BEvtiAOuEvaOYnqpP/1mG7zuAMx51MqASoiJh2B18rkUSChPrWKIdOuorQ==
X-Received: by 2002:a17:906:ca02:b0:88a:2e57:9813 with SMTP id jt2-20020a170906ca0200b0088a2e579813mr8973409ejb.33.1678954805151;
        Thu, 16 Mar 2023 01:20:05 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9827:5f65:8269:a95f? ([2a02:810d:15c0:828:9827:5f65:8269:a95f])
        by smtp.gmail.com with ESMTPSA id w11-20020a1709062f8b00b00923bb9f0c36sm3534063eji.127.2023.03.16.01.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 01:20:04 -0700 (PDT)
Message-ID: <c716e535-7426-56da-ca6f-51c7d7d69bb3@linaro.org>
Date:   Thu, 16 Mar 2023 09:20:03 +0100
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
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <d2bb7fa5-206f-2059-bde0-b65e1acc44de@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2023 09:15, Guo Samin wrote:
>>>> interrupts: ???
>>>>
>>>
>>> Hi Krzysztof, 
>>>
>>> snps,dwmac.yaml has defined the reg/interrupt/interrupt-names nodes,
>>> and the JH7110 SoC is also applicable.
>>> Maybe just add reg/interrupt/interrupt-names to the required ?
>>
>> You need to constrain them.
> 
> 
> I see. I will add reg constraints in the next version, thanks.
> 
> I have one more question, the interrupts/interrup-names of JH7110 SoC's gmac are exactly the same as snps,dwmac.yaml,
> do these also need to be constrained?

The interrupts on common binding are variable, so you need to constrain
them - you have fixed number of them, right?

Best regards,
Krzysztof

