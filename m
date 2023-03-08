Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3546B072B
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 13:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbjCHMed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 07:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjCHMea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 07:34:30 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB710B9BE3
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 04:34:28 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id k10so41187255edk.13
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 04:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678278867;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lHnWVWK4WJysT8nTvpm+ezeTdv9yWzInP/ANaSJalnE=;
        b=VguaXxgdrVNJ6ewt6Lcu2U5zfjODDwprmRErFl1yVDEs6YJM6ae5ih+FlbGaI6vpOg
         BvVdY9I+OBJuGy9IppdW00Ayq1m5JTUzCv5yqvAw5WOCkgYMNFQRN3lenLMSzl2YV7nq
         gx9pncpbeAaOTImFfOQlXekji0AzH/w0ofn/cXAeinaQk0f2Ska3rM4S0fiyQrkshql2
         yumZb3jzUA2bRxUFUPgrjXDa3bFHkYjfSpup//WaDLB+zlIeFWTFqniUNYldCxdZ77Iu
         ZgWwkqECd7cPdXLgugOSNZTtwPtLuaqASBNfS0bcFrr7JXzIPFwgtc06gODGjsh1PO/a
         ZaJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678278867;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lHnWVWK4WJysT8nTvpm+ezeTdv9yWzInP/ANaSJalnE=;
        b=XX2y8oOm49XZEhbuf6sFcAg+3kykyltGAgJ+RC8cFpytuLJE039BSYrtcZ1mMN5BDO
         YWIsQmyChckvmP8Ha6l/6jIRxfvC523uGrLgIetekBXNy8Gsa1FhC/NlTpdbH/wqwDMa
         zXaHdb1Gr2sNWkCIaTtVtOrp1wcjXWdWZZCTPR/O5dJdDK5YxxQTAgo0J1jjEab3A/ra
         581vB/Idya4U0fF4+GwUtT3qQUB+74Pf9nYm4639uvBBMz3bxWbdTsZADbACYQEziTL2
         nu47fRhf4A9Yz6dxR5gYZA1VWUxCeWTvyD3mbuVv6QJ5ot5SV5eWUReEgb44IBXriazk
         Wlrg==
X-Gm-Message-State: AO0yUKWgN2NjXJITVnUxFUPDmS182X5mVsvPYYAq5sR2NSFW2wL+oCBv
        UTJ4eCIjzCWBKQq5whbXPG9XXt7MtOvKxq+Or60=
X-Google-Smtp-Source: AK7set+OkhR9+9zDqw1AYMDA4XeRaaNxz/Gcl9uZU/AQnE6yeWfL8seN9zhdzyFWr7q3YqFl/tr7ng==
X-Received: by 2002:aa7:c14e:0:b0:4ac:d2cd:81c7 with SMTP id r14-20020aa7c14e000000b004acd2cd81c7mr18034215edp.5.1678278867282;
        Wed, 08 Mar 2023 04:34:27 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:ff33:9b14:bdd2:a3da? ([2a02:810d:15c0:828:ff33:9b14:bdd2:a3da])
        by smtp.gmail.com with ESMTPSA id u25-20020a50a419000000b004bd6e3ed196sm8107904edb.86.2023.03.08.04.34.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 04:34:26 -0800 (PST)
Message-ID: <dbbe3cd2-3329-d267-338b-8e513209ddcd@linaro.org>
Date:   Wed, 8 Mar 2023 13:34:25 +0100
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
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <7b6e8131-8e5b-88bc-69f7-b737c0c35bb6@ti.com>
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

On 08/03/2023 09:38, Siddharth Vadapalli wrote:
> Hello Krzysztof,
> 
> On 08/03/23 14:04, Krzysztof Kozlowski wrote:
>> On 08/03/2023 06:18, Siddharth Vadapalli wrote:
>>> Update bindings to include Serdes PHY as an optional PHY, in addition to
>>> the existing CPSW MAC's PHY. The CPSW MAC's PHY is required while the
>>> Serdes PHY is optional. The Serdes PHY handle has to be provided only
>>> when the Serdes is being configured in a Single-Link protocol. Using the
>>> name "serdes-phy" to represent the Serdes PHY handle, the am65-cpsw-nuss
>>> driver can obtain the Serdes PHY and request the Serdes to be
>>> configured.
>>>
>>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>>> ---
>>>
>>> Hello,
>>>
>>> This patch corresponds to the Serdes PHY bindings that were missed out in
>>> the series at:
>>> https://lore.kernel.org/r/20230104103432.1126403-1-s-vadapalli@ti.com/
>>> This was pointed out at:
>>> https://lore.kernel.org/r/CAMuHMdW5atq-FuLEL3htuE3t2uO86anLL3zeY7n1RqqMP_rH1g@mail.gmail.com/
>>>
>>> Changes from v1:
>>> 1. Describe phys property with minItems, items and description.
>>> 2. Use minItems and items in phy-names.
>>> 3. Remove the description in phy-names.
>>>
>>> v1:
>>> https://lore.kernel.org/r/20230306094750.159657-1-s-vadapalli@ti.com/
>>>
>>>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml        | 14 ++++++++++++--
>>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>>> index 900063411a20..0fb48bb6a041 100644
>>> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>>> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>>> @@ -126,8 +126,18 @@ properties:
>>>              description: CPSW port number
>>>  
>>>            phys:
>>> -            maxItems: 1
>>> -            description: phandle on phy-gmii-sel PHY
>>> +            minItems: 1
>>> +            items:
>>> +              - description: CPSW MAC's PHY.
>>> +              - description: Serdes PHY. Serdes PHY is required only if
>>> +                             the Serdes has to be configured in the
>>> +                             Single-Link configuration.
>>> +
>>> +          phy-names:
>>> +            minItems: 1
>>> +            items:
>>> +              - const: mac-phy
>>> +              - const: serdes-phy
>>
>> Drop "phy" suffixes.
> 
> The am65-cpsw driver fetches the Serdes PHY by looking for the string
> "serdes-phy". Therefore, modifying the string will require changing the driver's
> code as well. Please let me know if it is absolutely necessary to drop the phy
> suffix. If so, I will post a new series with the changes involving dt-bindings
> changes and the driver changes.

Why the driver uses some properties before adding them to the binding?

And is it correct method of adding ABI? You add incorrect properties
without documentation and then use this as an argument "driver already
does it"?

Best regards,
Krzysztof

