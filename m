Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612D86BB435
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbjCONPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbjCONO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:14:58 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FDAA1892
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:14:31 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id eg48so16138132edb.13
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678886069;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ko8uIaVTtfK98OPtq0RbCtmBQ5zzSH/lzWDgsNNPcGE=;
        b=kssdTtT8POAG8MVoPg4E3KHsJGK4vMa/mFMHgzOQKrLzka5xTyBd4krZ2yg6dBB3Jl
         mIANJsj8iYfru04IwdD4CvNg7Ej8rUELE7sLJp4bnOjZnaZPdDjlGtEu+6A7ZiVMypgf
         5jRcg+HDExItHNTgZ+3q0CmDdNoVjpupKMOgV7DaB/D6/rlyuR3jHynwZSW1MXh8d58h
         biNcc98lJafN6jrub5MpB1uayIwcqpfeLhKS1xreOU+1nRjWp4l5DrrSYimArdUYwL6T
         ZTGFOEgaqS7ls51CIc0Xic+SCpbOahiMqVCyzWUqRwDwEG9jnjpEF65T5m2Yn3ksiMPe
         w8/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678886069;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ko8uIaVTtfK98OPtq0RbCtmBQ5zzSH/lzWDgsNNPcGE=;
        b=o9OJvaYgDA40DKz750UDGBPS+t8AvhaJy/kSPAW20HXDcILj8szaTtdSiCczpGbAxc
         YiPZuKWEFBMHP6WMBTvqJ9HFOf2ILUozV8Efa5QijzBfVUHw+bWn0e1LkN2rLANuEfHw
         NW+bPYABDdJYFGdMPXvzI4uZlh8/oGeDniJUuxaq5Ro9fbZfFUQPZX6yYaPQS8WFd/h2
         b/GhxXxx2LYyjMey3fF1mL3CyZ4nFFY23SE+1coABIGS5vCOfNkCD/V+QazbVZCK6Kve
         JSABiMxFjuxdy2la2SnOQ+k79r2GmatWx8N42sNMcZh3gUnza7Dx5DZt9/AQZ2jEmFHo
         3x3Q==
X-Gm-Message-State: AO0yUKX5uJ4x+OC/rg+8lu7OfZDQ6nzvSbkzh1Rg0Ou1cAKelrJATaIo
        tNWCWi8TA3SyrJK1vpnn7jVPRA==
X-Google-Smtp-Source: AK7set/zo2nQvhu3yQ8tXP5JkC8OVGgJOgcta7DN6Bw6XOHhr8ldC9OwaIy35bcMX3a5DV02+BT8uA==
X-Received: by 2002:a17:907:a582:b0:92f:3e2b:fbb7 with SMTP id vs2-20020a170907a58200b0092f3e2bfbb7mr1805219ejc.14.1678886069514;
        Wed, 15 Mar 2023 06:14:29 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:940e:8615:37dc:c2bd? ([2a02:810d:15c0:828:940e:8615:37dc:c2bd])
        by smtp.gmail.com with ESMTPSA id g12-20020a1709064e4c00b008df7d2e122dsm2511882ejw.45.2023.03.15.06.14.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 06:14:28 -0700 (PDT)
Message-ID: <54aae3b8-ee85-c7eb-ecda-f574cb140675@linaro.org>
Date:   Wed, 15 Mar 2023 14:14:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/5] dt-bindings: can: tcan4x5x: Add tcan4552 and tcan4553
 variants
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Markus Schneider-Pargmann <msp@baylibre.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230314151201.2317134-1-msp@baylibre.com>
 <20230314151201.2317134-2-msp@baylibre.com>
 <680053bc-66fb-729f-ecdc-2f5fe511cecd@linaro.org>
 <20230315112508.6q52rekhmk66uiwj@pengutronix.de>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230315112508.6q52rekhmk66uiwj@pengutronix.de>
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

On 15/03/2023 12:25, Marc Kleine-Budde wrote:
> On 14.03.2023 21:01:10, Krzysztof Kozlowski wrote:
>> On 14/03/2023 16:11, Markus Schneider-Pargmann wrote:
>>> These two new chips do not have state or wake pins.
>>>
>>> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
>>> ---
>>>  .../devicetree/bindings/net/can/tcan4x5x.txt          | 11 ++++++++---
>>>  1 file changed, 8 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
>>> index e3501bfa22e9..38a2b5369b44 100644
>>> --- a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
>>> +++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
>>> @@ -4,7 +4,10 @@ Texas Instruments TCAN4x5x CAN Controller
>>>  This file provides device node information for the TCAN4x5x interface contains.
>>>  
>>>  Required properties:
>>> -	- compatible: "ti,tcan4x5x"
>>> +	- compatible:
>>> +		"ti,tcan4x5x" or
>>> +		"ti,tcan4552" or
>>> +		"ti,tcan4553"
>>
>> Awesome, they nicely fit into wildcard... Would be useful to deprecate
>> the wildcard at some point and switch to proper compatibles in such
>> case, because now they became confusing.
> 
> I plead for DT stability!
> 
> As I understand correctly, the exact version of the chip (4550, 4552, or
> 4553) can be detected via the ID2 register.

So maybe there is no need for this patch at all? Or the new compatibles
should be made compatible with generic fallback?

Best regards,
Krzysztof

