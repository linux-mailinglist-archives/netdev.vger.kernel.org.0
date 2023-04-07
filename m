Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662AA6DAA9D
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 11:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239550AbjDGJHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 05:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbjDGJHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 05:07:22 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08FDA5FA
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 02:07:19 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-930720f1b32so210125766b.3
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 02:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680858438;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6BxRk1PJc+XW+qEn8Ij5zM9MBUl9XatvAPXfsp+KF0k=;
        b=nkw+ddycbW5GjtdYGmkun62fRdFQENsmzY6BQjEiOlj8CA7TBenBvvXCinnKeAVPnW
         e3WureIZ4KLMhI/pJRQaDe7kvwwjrRtW3RLdcLBm2604TpgQLsn5FBK3s4XG2IxOfxwV
         qhiX67+b7XRHjv5s////3QhTRmAkz3WgSplFukprZLA/nFDKK3TSPWBVR5eonu9kO7fN
         Irm9/TTEtC/nyGuzI5xnvumhfqfGUUNf3JiZLwkS8SZZGV+cV8944LvYPQFwYv2bYB9d
         taRWaETWQxS88AOebWZD2RNJx9gFFMQgKMJJu7LoS+4tiAaFmEqgpP3cNs/2NDjd+1bH
         EiYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680858438;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6BxRk1PJc+XW+qEn8Ij5zM9MBUl9XatvAPXfsp+KF0k=;
        b=gHnUL448QhvNoqmK9ZdgxIoauhO8U6FaVdvU0lbCbczBCmrrec5gIuBDphDJ6LWwrW
         LLuguX/EI73mLQ3DZJS5+8oGz5x3nJ/ghIKOKc3/jVOUxKITlx7NyOZNsaPhbN61kqbK
         JQeVwEOvcTkgh+2sIPbO2ilhH8KQMTzUCLTCoJu4G4u5t+fC0OmrFaOUers22rHAblvb
         SEwy2B26AfhX02gt31ZN/IKZ6OBzEZ0KlpSH1GBr/WcUudAQnOrcTYz/V1aYNE3ZZSxD
         OsvKs4qtAtpx85dWROdoDZsDqfMTNDjpFcMBlGK7lFGwpRXfEJ1X3EEad4ljUokMSalI
         up/w==
X-Gm-Message-State: AAQBX9e9lMAQrQV2R5pJDbQNdaDOsaxIq3756L0Le0UC/6uUzhQihDOu
        UJ5d63DLjhFhU4vJVTjnhwNzhQ==
X-Google-Smtp-Source: AKy350Yp72jRlPW6PS3fGi3S7qmBR7ADa8EpkJ1qdw9IUSi7baFQV7muxP54AqpFgd65vqFrgqsC4w==
X-Received: by 2002:a50:fb8b:0:b0:4fd:29a1:6a58 with SMTP id e11-20020a50fb8b000000b004fd29a16a58mr2318193edq.19.1680858437893;
        Fri, 07 Apr 2023 02:07:17 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:14a3:366:3172:3c37? ([2a02:810d:15c0:828:14a3:366:3172:3c37])
        by smtp.gmail.com with ESMTPSA id b20-20020a056402351400b004bf5981ef3dsm1619711edd.94.2023.04.07.02.07.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 02:07:17 -0700 (PDT)
Message-ID: <951841d3-59a4-fa86-5b45-46afdb2942dd@linaro.org>
Date:   Fri, 7 Apr 2023 11:07:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 3/7] dt-bindings: net: dsa: mediatek,mt7530: add port
 bindings for MT7988
Content-Language: en-US
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230406080141.22924-1-arinc.unal@arinc9.com>
 <20230406080141.22924-3-arinc.unal@arinc9.com>
 <23c8c4b5-baaa-b72b-4103-b415d970acf2@linaro.org>
 <5b3a10ff-e960-1c6e-3482-cb25200c83c6@arinc9.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <5b3a10ff-e960-1c6e-3482-cb25200c83c6@arinc9.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/04/2023 21:18, Arınç ÜNAL wrote:
> On 6.04.2023 22:07, Krzysztof Kozlowski wrote:
>> On 06/04/2023 10:01, arinc9.unal@gmail.com wrote:
>>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>
>>> The switch on MT7988 has got only port 6 as a CPU port. The only phy-mode
>>> to be used is internal. Add this.
>>>
>>> Some bindings are incorrect for this switch now, so move them to more
>>> specific places.
>>>
>>> Address the incorrect information of which ports can be used as a user
>>> port. Any port can be used as a user port.
>>>
>>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>>> ---
>>>   .../bindings/net/dsa/mediatek,mt7530.yaml     | 63 ++++++++++++++-----
>>>   1 file changed, 46 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>> index 7045a98d9593..605888ce2bc6 100644
>>> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>> @@ -160,22 +160,6 @@ patternProperties:
>>>         "^(ethernet-)?port@[0-9]+$":
>>>           type: object
>>>   
>>> -        properties:
>>> -          reg:
>>> -            description:
>>> -              Port address described must be 5 or 6 for CPU port and from 0 to 5
>>> -              for user ports.
>>> -
>>> -        allOf:
>>> -          - if:
>>> -              required: [ ethernet ]
>>> -            then:
>>> -              properties:
>>> -                reg:
>>> -                  enum:
>>> -                    - 5
>>> -                    - 6
>>> -
>>
>> I have doubts that the binding is still maintainable/reviewable. First,
>> why do you need all above patterns after removal of entire contents?
> 
> The 'type: object' item is still globally used. I'd have to define that 
> on each definitions, I suppose?

Doesn't it come from dsa.yaml/dsa-port.yaml schema?

> 
>>
>> Second, amount of if-then-if-then located in existing blocks (not
>> top-level) is quite big. I counted if-then-using defs, where defs has
>> patternProps-patternProps-if-then-if-then-properties.... OMG. :)
> 
> Yup, not much to do if we want to keep the information. I'm still 
> maintaining this though. ¯\_(ツ)_/¯

Maybe it should be split into few bindings sharing common part.

Best regards,
Krzysztof

