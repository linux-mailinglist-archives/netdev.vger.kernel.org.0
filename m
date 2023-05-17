Return-Path: <netdev+bounces-3445-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA7D8707220
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0BB128176E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7EDF34CDF;
	Wed, 17 May 2023 19:27:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6ACF111AD
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 19:27:03 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0760DD07F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:26:41 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-9659443fb56so172791166b.2
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684351597; x=1686943597;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mm1FTlLFksMfdpbiAMAJzUodVZBvDKUEnd/MrdiN4SE=;
        b=ah3JKaxqw48Owmtqcin9G2kpFmSJG8xXLqbqJf/sbesavcjD11tzf/n+zkfbp7ZNPn
         p5OcoclJk5sUAb3FirHxTvN25HKiL2dpTdlnZAVZeYsyhxOCjEhaaIN/VOGbF/ONXO6Z
         8jBF0vNA9utft1oi4E/qCcQfVwz1n1x78kvuhzfsaoSJ6HtxXJbbqhHtTep5w9qn2mox
         soooocVeS6hzk9nJRDiRSLt+WUA4tix/LOph4Ek6w6oTNSl2E4DShg68SmBb6jNXKM0N
         hvLO1eTvrtcs4eGxtJFm5HpXsFV0NykSjc2PGiKGDDSSNaGNldRlFZvF2hhL4z5nvZlu
         ncRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684351597; x=1686943597;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mm1FTlLFksMfdpbiAMAJzUodVZBvDKUEnd/MrdiN4SE=;
        b=iOjzPAUyt2MqSCqRXvSqIj4643u1PLtDglxaOzmkkM83c3eh1lBk83Uobzkccy55Ci
         5yZZq1toZT+J36ODqjBLbuorJhX93aFvfxeOCtY6pG65hfA1bvK59ZKQWGA7I2zBKppF
         XKAKYJS2jJrgpn1bDZ7M7Srzo1z02Tq+4+3waEvSrwEtXlNmyax0Z3kRqzcuSpvg4bay
         ViXjSzxRaeFBIpt8fG+lQHX5kAEt1b7WlEUM1CF//gkPr/WMsKsNpUCVeIZiUDefrsy9
         aamOGKy7Jwp5F5Hwuehln8XL8sOT2oYRiek8bE9JTgIrYuBD5H2k3nWQN/6PwJT2ZLhY
         j1rg==
X-Gm-Message-State: AC+VfDz+wWuvli6uCfmINGTRaS9mn9wsrSVFArjXKVFUvCOGQFgq41f5
	frWVnkc/FofHuyD9YM0+VPuUbg==
X-Google-Smtp-Source: ACHHUZ6++WL2KoWrWr1kQFg7pgPeyB9wQttL5UxWx7+NYYB6bmuyDQFSgFA845peRuMllKux/N69yg==
X-Received: by 2002:a17:907:3daa:b0:96a:1cbf:3dcc with SMTP id he42-20020a1709073daa00b0096a1cbf3dccmr32103920ejc.54.1684351597249;
        Wed, 17 May 2023 12:26:37 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:d7a:e7cc:21b3:c435? ([2a02:810d:15c0:828:d7a:e7cc:21b3:c435])
        by smtp.gmail.com with ESMTPSA id w12-20020aa7da4c000000b0050bc5727507sm9712685eds.73.2023.05.17.12.26.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 12:26:36 -0700 (PDT)
Message-ID: <408ee74c-e6ed-d654-af04-58bd7d1e087b@linaro.org>
Date: Wed, 17 May 2023 21:26:35 +0200
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
 <5b826dc7-2d02-d4ed-3b6a-63737abe732b@linaro.org>
 <e6247cb39cc16a9328d9432e0595745b67c0aed5.camel@gmail.com>
 <38ae4ceb-da21-d73e-9625-1918b4ab4e16@linaro.org>
 <5d7421b6a419a9645f97e6240b1dfbf47ffcab4e.camel@gmail.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <5d7421b6a419a9645f97e6240b1dfbf47ffcab4e.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 17/05/2023 23:38, Ivan Mikhaylov wrote:
> On Wed, 2023-05-17 at 10:36 +0200, Krzysztof Kozlowski wrote:
>> On 16/05/2023 13:47, Ivan Mikhaylov wrote:
>> hy this is property of the hardware. I
>>>>>> understand
>>>>>> that this is something you want Linux to do, but DT is not
>>>>>> for
>>>>>> that
>>>>>> purpose. Do not encode system policies into DT and what above
>>>>>> commit
>>>>>> says is a policy.
>>>>>>
>>>>>
>>>>> Krzysztof, okay then to which DT subsystem it should belong? To
>>>>> ftgmac100 after conversion?
>>>>
>>>> To my understanding, decision to add some numbers to MAC address
>>>> does
>>>> not look like DT property at all. Otherwise please help me to
>>>> understand
>>>> - why different boards with same device should have different
>>>> offset/value?

I would like to remind this question.
"why different boards with same device should have different offset/value?"

It was literally ignored and you started explaining network cards and
BMC. I don't understand why, but it does not help your case.

Let me extend this question with one more:
"Why for all your boards of one type, so using the same DTS, would you
use one value of incrementing MAC address?"

>>>>
>>>> Anyway, commit msg also lacks any justification for this.
>>>>
>>>> Best regards,
>>>> Krzysztof
>>>>
>>>
>>> Krzysztof, essentially some PCIe network cards have like an
>>> additional
>>> *MII interface which connects directly to a BMC (separate SoC for
>>> managing a motherboard) and by sending special ethernet type frames
>>> over that connection (called NC-SI) the BMC can obtain MAC, get
>>> link
>>> parameters etc. So it's natural for a vendor to allocate two MACs
>>> per
>>> such a board with PCIe card intergrated, with one MAC "flashed
>>> into"
>>> the network card, under the assumption that the BMC should
>>
>> Who makes the assumption that next MAC should differ by 1 or 2?
> 
> Krzysztof, in this above case BMC does, BMC should care about changing
> it and doing it with current codebase without any options just by some
> hardcoded numbers which is wrong.

But you hard-code the number, just in BMC DTS. How does it differ from
BMC hard-coding it differently?

You encode policy - or software decisions - into Devicetree.

> 
>>
>>> automatically use the next MAC. So it's the property of the
>>> hardware as
>>> the vendor designs it, not a matter of usage policy.
>>>
>>> Also at the nvmem binding tree is "nvmem-cell-cells" which is
>>> literally
>>> the same as what was proposed but on different level.
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/Documentation/devicetree/bindings/nvmem?id=7e2805c203a6c8dc85c1cfda205161ed39ae82d5
>>
>> How is this similar? This points the location of mac address on some
>> NV
>> storage. You add fixed value which should be added to the Ethernet.
> 
> It's not the points the location, this particular option provides this
> increment for mac addresses to make use of them with multiple
> interfaces. Just part of above commit:
> "It's used as a base for calculating addresses for multiple interfaces.
> It's done by adding proper values. Actual offsets are picked by
> manufacturers and vary across devices."
> 
> It is same as we talked before about mac-address-increment in openwrt
> project, if you want examples, you can look into their github. And same
> as we trying to achieve here.
> 
> https://github.com/openwrt/openwrt/blob/master/target/linux/generic/pending-5.15/682-of_net-add-mac-address-increment-support.patch

Awesome... so if project added wrong property to bindings, e.g. SW
property, you find it as an argument for anyone else.

No, that's not how it works.

> 
> "Lots of embedded devices use the mac-address of other interface
> extracted from nvmem cells and increments it by one or two. Add two
> bindings to integrate this and directly use the right mac-address for
> the interface. Some example are some routers that use the gmac
> mac-address stored in the art partition and increments it by one for
> the
> wifi. mac-address-increment-byte bindings is used to tell what byte of
> the mac-address has to be increased (if not defined the last byte is
> increased) and mac-address-increment tells how much the byte decided
> early has to be increased."
> 
> Don't you see similarity with nvmem commit?

Explanation is similar, but you are using wrong argument to justify the
property. The MAC address is stored in some NVMEM cell. There is such
NVMEM cell. That's the hardware property, thus it is justified in DT.

Now how MAC address will be modified - by 1, 2, 3, 252 - is not related
to that commit, because it is a software decision.

Again, we are back to the previous question to which you answered "BMC
will do it". I understand this is property for the BMC DTS, thus:
Why for all your boards of one type, so using one DTS, would you use one
value of incrementing MAC address?
Why devices with same board cannot use different values? One board "1"
and second "2" for MAC increments? I am sure that one customer could
have it different.

The choice how much you increment some MAC address is not a hardware
property. It does not even look like a firmware property. If playing
with this property was done by firmware, like we do for all MAC address
fields, then I would expect here some references to it. Which you did
not provide, I believe.



> 
>>
>> I might be missing the context but there is no DTS example nor user
>> of
>> this property, so how can I get such?
>>
> 
> I don't see it either in linux kernel DTS tree but it in DTS doc.
> 
> Also, just a little bit history about older propositions
> https://lore.kernel.org/all/?q=mac-address-increment
> https://lore.kernel.org/all/20200919214941.8038-5-ansuelsmth@gmail.com/

I don't see any user there, except the same rejected proposal:

https://lore.kernel.org/all/CAL_JsqKhyeh2=pJcpBKkh+s3FM__DY+VoYSYJLRUErrujTLn9A@mail.gmail.com/

If you want to convince us, please illustrate it in a real world
upstreamed DTS (or explain why it cannot). Otherwise I don't see
justification as it is not a hardware property.

This is a NAK from me.

Feel free to ping Rob in some later time, as he might have different
opinion.

Best regards,
Krzysztof


