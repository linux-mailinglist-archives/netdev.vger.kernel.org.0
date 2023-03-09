Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985616B1B55
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 07:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjCIGV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 01:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjCIGV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 01:21:56 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4465BC70A8
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 22:21:54 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id a25so2996550edb.0
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 22:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678342913;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=629HUKu9ysTE8LoxfEMeOnsoL7Im0RfsyDKZUedE5Xk=;
        b=GFx+5RxlDimXAhFVzROdjGt+iQwtj5yTq9kv1DBv6rSlkZtxT7zJvhAkoR9onnCFxp
         OTQaGQKSFr4LJAX6ox9p28QjgVzdheHdXbZg51uB4pMcNdR3PKcjVXC3AnMndiFyLIOa
         nxveWZ7EUIjwyN/9OipFP+wXaqLVRmF15zaWxoDWOqTlNXPoy2/Qux5xNHbIxWZOz5q5
         RJXlI0ti+/SMVw/A7BAxrSHKeQ5wD7hNvZ+zPNVtU/q6RTC1NElCwRNhSs2aPwdCBxJU
         vEGNEKpxGUUBCCrvfp3tjUs0gglE02qedQ9XmcLLomYSvgMIVBgjSpv+3zpC/uc1kLIl
         Hfxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678342913;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=629HUKu9ysTE8LoxfEMeOnsoL7Im0RfsyDKZUedE5Xk=;
        b=7Ham0coVJ0txX+kATaMDr1sotmKicdOJT2SUdvsPoLyI8ZvZDU/n1APn+ja5t8E40W
         TSO4b/0JpdpAjsWT8ItBbGyq9oPnRnFVuGfV761mcyQCawFRmMfkVYiGAl9DTbj7a7ap
         8F+TUKx3NNxMF/hQliqQzxQ85r8NaNdzdkCUW/AhnrCpQfULO/B3Nm2O4prSl2gAsXj3
         K2sWcwuEfTChr4MbfoqHTcYwp/lPn0A3VydU3/cKlQUXa0uOWjfyfsWW7ugUi8BHMWIe
         dkfgjv68107Vx5HQLlfyhlqYfMojxmqn8/ebpBVWDV0kKXJ02CWO6xl20PsXqfh2WWED
         RXmQ==
X-Gm-Message-State: AO0yUKWbIdqwVHCwkkR27GU79EzBjPvdULwL5hOE9avnoiPY1B/eD3ky
        4gEUxX71nBNhQ81qTJIafP/QIg==
X-Google-Smtp-Source: AK7set/QLffEPle8Wh9gk5/86+LCNm7TyOrefjJkwRpgWvOBGuPd7HNwGDbfMIPT23raSrKfVuIJ8g==
X-Received: by 2002:a17:906:7948:b0:8b2:37b5:cc4 with SMTP id l8-20020a170906794800b008b237b50cc4mr30024197ejo.7.1678342912726;
        Wed, 08 Mar 2023 22:21:52 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:7ee2:e73e:802e:45c1? ([2a02:810d:15c0:828:7ee2:e73e:802e:45c1])
        by smtp.gmail.com with ESMTPSA id d17-20020a50f691000000b004c0cc79f4aesm9080730edn.92.2023.03.08.22.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 22:21:52 -0800 (PST)
Message-ID: <624f5dc8-0807-e799-d66e-213aadabfc84@linaro.org>
Date:   Thu, 9 Mar 2023 07:21:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2] dt-bindings: net: ti: k3-am654-cpsw-nuss:
 Document Serdes PHY
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>,
        krzysztof.kozlowski+dt@linaro.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux@armlinux.org.uk, pabeni@redhat.com, robh+dt@kernel.org,
        nsekhar@ti.com, rogerq@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
References: <20230308051835.276552-1-s-vadapalli@ti.com>
 <1ffed720-322c-fa73-1160-5fd73ce3c7c2@linaro.org>
 <7b6e8131-8e5b-88bc-69f7-b737c0c35bb6@ti.com>
 <dbbe3cd2-3329-d267-338b-8e513209ddcd@linaro.org>
 <882cdb42-3f80-048a-88a5-836c479a421f@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <882cdb42-3f80-048a-88a5-836c479a421f@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/03/2023 05:18, Siddharth Vadapalli wrote:
> Hello Krzysztof,
> 
> On 08/03/23 18:04, Krzysztof Kozlowski wrote:
>> On 08/03/2023 09:38, Siddharth Vadapalli wrote:
>>> Hello Krzysztof,
>>>
>>> On 08/03/23 14:04, Krzysztof Kozlowski wrote:
>>>> On 08/03/2023 06:18, Siddharth Vadapalli wrote:
>>>>> Update bindings to include Serdes PHY as an optional PHY, in addition to
>>>>> the existing CPSW MAC's PHY. The CPSW MAC's PHY is required while the
>>>>> Serdes PHY is optional. The Serdes PHY handle has to be provided only
>>>>> when the Serdes is being configured in a Single-Link protocol. Using the
>>>>> name "serdes-phy" to represent the Serdes PHY handle, the am65-cpsw-nuss
>>>>> driver can obtain the Serdes PHY and request the Serdes to be
>>>>> configured.
>>>>>
>>>>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>>>>> ---
>>>>>
>>>>> Hello,
>>>>>
>>>>> This patch corresponds to the Serdes PHY bindings that were missed out in
>>>>> the series at:
>>>>> https://lore.kernel.org/r/20230104103432.1126403-1-s-vadapalli@ti.com/
>>>>> This was pointed out at:
>>>>> https://lore.kernel.org/r/CAMuHMdW5atq-FuLEL3htuE3t2uO86anLL3zeY7n1RqqMP_rH1g@mail.gmail.com/
>>>>>
>>>>> Changes from v1:
>>>>> 1. Describe phys property with minItems, items and description.
>>>>> 2. Use minItems and items in phy-names.
>>>>> 3. Remove the description in phy-names.
>>>>>
>>>>> v1:
>>>>> https://lore.kernel.org/r/20230306094750.159657-1-s-vadapalli@ti.com/
>>>>>
>>>>>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml        | 14 ++++++++++++--
>>>>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>>>>> index 900063411a20..0fb48bb6a041 100644
>>>>> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>>>>> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>>>>> @@ -126,8 +126,18 @@ properties:
>>>>>              description: CPSW port number
>>>>>  
>>>>>            phys:
>>>>> -            maxItems: 1
>>>>> -            description: phandle on phy-gmii-sel PHY
>>>>> +            minItems: 1
>>>>> +            items:
>>>>> +              - description: CPSW MAC's PHY.
>>>>> +              - description: Serdes PHY. Serdes PHY is required only if
>>>>> +                             the Serdes has to be configured in the
>>>>> +                             Single-Link configuration.
>>>>> +
>>>>> +          phy-names:
>>>>> +            minItems: 1
>>>>> +            items:
>>>>> +              - const: mac-phy
>>>>> +              - const: serdes-phy
>>>>
>>>> Drop "phy" suffixes.
>>>
>>> The am65-cpsw driver fetches the Serdes PHY by looking for the string
>>> "serdes-phy". Therefore, modifying the string will require changing the driver's
>>> code as well. Please let me know if it is absolutely necessary to drop the phy
>>> suffix. If so, I will post a new series with the changes involving dt-bindings
>>> changes and the driver changes.
>>
>> Why the driver uses some properties before adding them to the binding?
> 
> I missed adding the bindings for the Serdes PHY as a part of the series
> mentioned in the section below the tearline of the patch. With this patch, I am
> attempting to fix it.
> 
>>
>> And is it correct method of adding ABI? You add incorrect properties
>> without documentation and then use this as an argument "driver already
>> does it"?
> 
> I apologize if my earlier comment appeared to justify the usage of "serdes-phy"
> based on the driver already using it. I did not mean it in that sense. I simply
> meant to ask if dropping "phy" suffixes was a suggestion or a rule. In that
> context, I felt that if it was a suggestion, I would prefer retaining the names
> with the "phy" suffixes, since the driver is already using it. Additionally, I
> also mentioned in my earlier comment that if it is necessary to drop the "phy"
> suffix, then I will do so and add another patch to change the string the driver
> looks for as well.
> 
> I shall take it that dropping "phy" suffixes is a rule/necessity. With this, I
> will post the v3 series making this change, along with the patch to update the
> string the driver looks for.

Drop the "phy" suffix.

It's a new binding. "phy" as suffix for "phy" is useless and for new
bindings it should be dropped. If you submitted driver changes without
bindings, which document the ABI, it's not good, but also not a reason
for me for exceptions.

Best regards,
Krzysztof

