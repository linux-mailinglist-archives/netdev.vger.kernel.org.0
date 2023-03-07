Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB2C6AD9B5
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 09:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCGI6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 03:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjCGI6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 03:58:05 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A2932CCB
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 00:58:03 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id i34so49339875eda.7
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 00:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678179482;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZVTfPiVagOZL90gtIf96Yys0KYhqSZTVjW5Vb21u5PM=;
        b=lMOa5uVEs630Vnh6L/HLw1O+7z304xtCXQWssdZJSHBtS4gIfwMxoSXq/0Zgf/xUbN
         PN1HG2FZxjcmO345RxD5HR4grPkXWhRsqUFgr+JvkV6aWU72WtqZAe/ZZCkkq+sgsB7p
         fx4vQxO+UJweosWCMiYvgAzNM1YfAP9OG9zO3yJvtLyT4cA1G0ud0lgINu7+Gbm+/6Gd
         qa1h8WDwJJGEWNAxdRiEPORgRxXprK2YQflKCXc3dUfIcRoueho+UxtOkW3L/SOLWnrD
         xkMAvbpKIcDVZqMHPIrVJJMNjpMaPY96d0ICAOMq8opK6t40l4RJ4EO05Fmv0hpF3O3g
         axKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678179482;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZVTfPiVagOZL90gtIf96Yys0KYhqSZTVjW5Vb21u5PM=;
        b=YYwPx648FOvuciftZHwczrUbtixjsdU9KkRXWL2WkjmuM1npMcLEq9IuP1rhJPXVS8
         28/d//QgKVn7k9OPChyRU9lRJAQV8q/05P1C8S8SV2VvRwzq8MguulPm08+9/+vKevjm
         TLVI7ktg+g4EET6g10vmTbDQmLRvFGnf8W5bz+UWlknrZWw0CVx+foFUJg8r0WrEYfRi
         r1m3TCVXh/azrBT4kMGp+b1q/UIidQNKfcYiI9aPRInpPt1uZtokxidK/fajpikdQzss
         gFhinVOSKIdqVSDyaANkLMDdIdpL2DDIUlHC8imszTgWoTQ7Ron7eY60H1Y7qWh5MvzP
         yHIg==
X-Gm-Message-State: AO0yUKXl9mViPcBqP7RnWn1hLjVgAg1BZM+/t7CBVl+o0w3GZ+bztWIJ
        ZvpsecCpOAfIrWlyQ3jahaZTjg==
X-Google-Smtp-Source: AK7set9i6XN8jLMfyZaebyCVBR+PyyIEq6PPzmiHj6R2qI1SLS1ib+ru7uB7rd79hwfISF1aZfF07Q==
X-Received: by 2002:aa7:d7c3:0:b0:4af:5aa1:6e58 with SMTP id e3-20020aa7d7c3000000b004af5aa16e58mr13274064eds.21.1678179482002;
        Tue, 07 Mar 2023 00:58:02 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:5310:35c7:6f9e:2cd3? ([2a02:810d:15c0:828:5310:35c7:6f9e:2cd3])
        by smtp.gmail.com with ESMTPSA id o22-20020a509b16000000b004c4eed3fe20sm6364807edi.5.2023.03.07.00.58.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 00:58:01 -0800 (PST)
Message-ID: <63dbbda7-a444-8dac-6399-45e305652155@linaro.org>
Date:   Tue, 7 Mar 2023 09:58:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [EXTERNAL] Re: [PATCH v5 1/2] dt-bindings: net: Add ICSSG
 Ethernet
Content-Language: en-US
To:     Md Danish Anwar <a0501179@ti.com>, Rob Herring <robh@kernel.org>,
        MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, andrew@lunn.ch, nm@ti.com,
        ssantosh@kernel.org, srk@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20230210114957.2667963-1-danishanwar@ti.com>
 <20230210114957.2667963-2-danishanwar@ti.com>
 <20230210192001.GB2923614-robh@kernel.org>
 <43df3c2c-d0d0-f2b8-cf8b-8a2453ca43b4@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <43df3c2c-d0d0-f2b8-cf8b-8a2453ca43b4@ti.com>
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

On 07/03/2023 05:57, Md Danish Anwar wrote:
>>> +allOf:
>>> +  - $ref: /schemas/remoteproc/ti,pru-consumer.yaml#
>>> +
>>> +properties:
>>> +  compatible:
>>> +    enum:
>>> +      - ti,am654-icssg-prueth  # for AM65x SoC family
>>> +
>>> +  ti,sram:
>>> +    $ref: /schemas/types.yaml#/definitions/phandle
>>> +    description:
>>> +      phandle to MSMC SRAM node
>>
>> I believe we have a standard 'sram' property to point to SRAM nodes 
>> assuming this is just mmio-sram or similar.
>>
> 
> Yes, we have standard 'sram' property but Krzysztof had asked me to make the
> sram property vendor specific in last revision of this series.

Sorry about that. I missed that we already have a 'sram'. The question
remains whether this is a phandle to MMIO SRAM or similar (sram.yaml).

Best regards,
Krzysztof

