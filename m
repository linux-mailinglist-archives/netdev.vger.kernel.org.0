Return-Path: <netdev+bounces-2094-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 714FE7003B9
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:27:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28772281ACA
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFAA2BE5E;
	Fri, 12 May 2023 09:24:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD77E138A
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:24:56 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D5110A0A
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 02:24:53 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so87593391a12.0
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 02:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683883492; x=1686475492;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e59Z513Z+sJEMOgqzM+yyZIxs7sBXNtv5zHcR3wz36w=;
        b=MyFqPnWUtOSHxIbollXfdpTNYzXVp7iLGBKBd5Vq6XLbSNYUSE8dEbqJPngxRyOC7/
         sX0Ks08xrJgBSlSzkL9JV/xCX5rqktn4NtWUhFjDziTMIZ8gTCPj/6wvueQs36/s2JeG
         u3uVT/h8pBy5DAMnK4f1ye83PDh41FXCVDFZYsf4M5ku2yIMF50rQnS6Bl723FYGUQ3P
         CFasVqbiH3Iv+5MH22t7QPmZM5MCADP9uVE3AKhU5AFFc7wQVTfpbwo8s+xHmRDTxIqs
         ImUuss9P8DFFe36TP2KNbiKHmwfZn5vMiv4+uk5epvPaenu/M2YtD3t5R700qsQpy2uc
         Boeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683883492; x=1686475492;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e59Z513Z+sJEMOgqzM+yyZIxs7sBXNtv5zHcR3wz36w=;
        b=KMSUOFdJTLDI3wLktkvkxgqA7eVp7qPQVh5+zjdxpH1++LVayembpI+Wb3XnYk/1iH
         2hSI4vAQxWhzUKXQ8U6LH5Qxy3RrIq62zp46vZnce+UAobDv6+x/FaBny5wlwPrXJXPf
         kXZLQasGn4aNNpKAoJ1Z73cDKDwdRaiSDpxR0AVkSMwNQ4OBpH2CfTvaIFVa2U0W83yc
         7eLG44fdw9aXLn2hC4Ft5Hmd/LLHJPqXP41RRwfKEGRG8458zB25oWpZPNdVEJ0nupEz
         izxDTbM7IJ08RIMHp7CioPaE8+BjXvtTYEl7TCvb7RYXzVe+Ccy/A7cHA+chJkvSL5zN
         zw2w==
X-Gm-Message-State: AC+VfDw4zZsPch9+/S8TNiuxmTFdK6eyuZvxSUdhfTSlGvUl/sFlCp8U
	DHlI0M1WRg4UOA5on740mk8Nyg==
X-Google-Smtp-Source: ACHHUZ5SJgRjdxPTyQHwUlqVbdI9FOAmLfmVC4nzz5A6wB+hQJViZGkFBW/A41OdjL/VFyueRMCDeg==
X-Received: by 2002:a17:907:2d0e:b0:967:13a3:d82c with SMTP id gs14-20020a1709072d0e00b0096713a3d82cmr16110519ejc.26.1683883492322;
        Fri, 12 May 2023 02:24:52 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:7ede:fc7b:2328:3883? ([2a02:810d:15c0:828:7ede:fc7b:2328:3883])
        by smtp.gmail.com with ESMTPSA id gf25-20020a170906e21900b0094edfbd475csm5063131ejb.127.2023.05.12.02.24.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 May 2023 02:24:51 -0700 (PDT)
Message-ID: <5b826dc7-2d02-d4ed-3b6a-63737abe732b@linaro.org>
Date: Fri, 12 May 2023 11:24:50 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 3/5] dt-bindings: net: add mac-address-increment option
Content-Language: en-US
To: Ivan Mikhaylov <fr0st61te@gmail.com>,
 Samuel Mendoza-Jonas <sam@mendozajonas.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org,
 Paul Fertser <fercerpav@gmail.com>
References: <20230509143504.30382-1-fr0st61te@gmail.com>
 <20230509143504.30382-4-fr0st61te@gmail.com>
 <6b5be71e-141e-c02a-8cba-a528264b26c2@linaro.org>
 <fc3dae42f2dfdf046664d964bae560ff6bb32f69.camel@gmail.com>
 <8de01e81-43dc-71af-f56f-4fba957b0b0b@linaro.org>
 <be85bef7e144ebe08f422bf53bb81b59a130cb29.camel@gmail.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <be85bef7e144ebe08f422bf53bb81b59a130cb29.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 12/05/2023 13:28, Ivan Mikhaylov wrote:
> On Fri, 2023-05-12 at 08:22 +0200, Krzysztof Kozlowski wrote:
>> On 11/05/2023 01:31, Ivan Mikhaylov wrote:
>>> On Wed, 2023-05-10 at 16:48 +0200, Krzysztof Kozlowski wrote:
>>>> On 09/05/2023 16:35, Ivan Mikhaylov wrote:
>>>>> Add the mac-address-increment option for specify MAC address
>>>>> taken
>>>>> by
>>>>> any other sources.
>>>>>
>>>>> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
>>>>> Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
>>>>> ---
>>>>>  .../devicetree/bindings/net/ethernet-controller.yaml      | 8
>>>>> ++++++++
>>>>>  1 file changed, 8 insertions(+)
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/net/ethernet-
>>>>> controller.yaml
>>>>> b/Documentation/devicetree/bindings/net/ethernet-
>>>>> controller.yaml
>>>>> index 00be387984ac..6900098c5105 100644
>>>>> --- a/Documentation/devicetree/bindings/net/ethernet-
>>>>> controller.yaml
>>>>> +++ b/Documentation/devicetree/bindings/net/ethernet-
>>>>> controller.yaml
>>>>> @@ -34,6 +34,14 @@ properties:
>>>>>      minItems: 6
>>>>>      maxItems: 6
>>>>>  
>>>>> +  mac-address-increment:
>>>>> +    $ref: /schemas/types.yaml#/definitions/int32
>>>>> +    description:
>>>>> +      Specifies the MAC address increment to be added to the
>>>>> MAC
>>>>> address.
>>>>> +      Should be used in cases when there is a need to use MAC
>>>>> address
>>>>> +      different from one obtained by any other level, like u-
>>>>> boot
>>>>> or the
>>>>> +      NC-SI stack.
>>>>
>>>> We don't store MAC addresses in DT, but provide simple
>>>> placeholder
>>>> for
>>>> firmware or bootloader. Why shall we store static "increment"
>>>> part of
>>>> MAC address? Can't the firmware give you proper MAC address?
>>>>
>>>> Best regards,
>>>> Krzysztof
>>>>
>>>
>>> Krzysztof, maybe that's a point to make commit message with better
>>> explanation from my side. At current time there is at least two
>>> cases
>>> where I see it's possible to be used:
>>>
>>> 1. NC-SI
>>> 2. embedded
>>>
>>> At NC-SI level there is Get Mac Address command which provides to
>>> BMC
>>> mac address from the host which is same as host mac address, it
>>> happens
>>> at runtime and overrides old one.
>>>
>>> Also, this part was also to be discussed 2 years ago in this
>>> thread:
>>> https://lore.kernel.org/all/OF8E108F72.39D22E89-ON00258765.001E46EB-00258765.00251157@ibm.com/
>>
>> Which was not sent to Rob though...
>>
>>
>>>
>>> Where Milton provided this information:
>>>
>>> DTMF spec DSP0222 NC-SI (network controller sideband interface)
>>> is a method to provide a BMC (Baseboard management controller)
>>> shared
>>> access to an external ethernet port for comunication to the
>>> management
>>> network in the outside world.  The protocol describes ethernet
>>> packets 
>>> that control selective bridging implemented in a host network
>>> controller
>>> to share its phy.  Various NIC OEMs have added a query to find out
>>> the 
>>> address the host is using, and some vendors have added code to
>>> query
>>> host
>>> nic and set the BMC mac to a fixed offset (current hard coded +1
>>> from
>>> the host value).  If this is compiled in the kernel, the NIC OEM is
>>> recognised and the BMC doesn't miss the NIC response the address is
>>> set
>>> once each time the NCSI stack reinitializes.  This mechanism
>>> overrides
>>> any mac-address or local-mac-address or other assignment.
>>>
>>> DSP0222
>>> https://www.dmtf.org/documents/pmci/network-controller-sideband-interface-nc-si-specification-110
>>>
>>>
>>> In embedded case, sometimes you have different multiple ethernet
>>> interfaces which using one mac address which increments or
>>> decrements
>>> for particular interface, just for better explanation, there is
>>> patch
>>> with explanation which providing them such way of work:
>>> https://github.com/openwrt/openwrt/blob/master/target/linux/generic/pending-5.15/682-of_net-add-mac-address-increment-support.patch
>>>
>>> In their rep a lot of dts using such option.
>>
>> None of these explain why this is property of the hardware. I
>> understand
>> that this is something you want Linux to do, but DT is not for that
>> purpose. Do not encode system policies into DT and what above commit
>> says is a policy.
>>
> 
> Krzysztof, okay then to which DT subsystem it should belong? To
> ftgmac100 after conversion?

To my understanding, decision to add some numbers to MAC address does
not look like DT property at all. Otherwise please help me to understand
- why different boards with same device should have different offset/value?

Anyway, commit msg also lacks any justification for this.

Best regards,
Krzysztof


