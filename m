Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF2A642530
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 09:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbiLEI5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 03:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbiLEI5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 03:57:02 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDE2186D7
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 00:55:44 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id s8so17463863lfc.8
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 00:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xfg1yHqtX0q12ifIkBoCcowFenHMwDLU9Aqmhql/1bM=;
        b=IDrbX64GmS8b+LNLFOReZkvoEfZxUM6UZGnodlCyKKbbV27VDRJiEeHTNgUg2Z0VcK
         j9TLnGcx/5q9yxhHXf+Nn+6HTNQWQoeu1RmrYUW3KaeANTcXuyKNsli+Xhn9Uf/Lsm17
         Dlk2g0N8T4EvD6KEsi0H/oblhJc6NYhjElPxtdbdPCWv50TvtbvJ7idC+KRsPQXvlkse
         z4ExG+DpCnVwpH5T1dyDZ+JJn/4aZstmCCyn3Qz0N3sDivUlSC2HDuhP32RWUTAyahnj
         qayfb9kVj87lc9nLr7OAcx2MbG3MlwhFI6cJie7Q25+VwdQXkTXCkEK95qgNZUkuWsDu
         Zjtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xfg1yHqtX0q12ifIkBoCcowFenHMwDLU9Aqmhql/1bM=;
        b=SSetn4FLlLn5aJihqtdQDX6/+sEbKeVEQutUi5Wz+/p8NSCNbIRP/L2xXptY13S5XA
         z4RiNp1EooNxeLR7BsrO6J98u8JIYmAP7/TdrkDOMk7isnF7vfnFQ+wVE3sUMN8Iud5E
         SiGh6f3pNo4W79CZVlL8kRmvTGKuOkdRL4RZlpBxFerwKLvhm4nZEhQ74USvo2bAzUqf
         +s3EKSDDQiqEZjYuCddVLzyMLOgJBAeK4VMzaR1y6y+gQ/GNzgQm9fTXOBmk6cEE2vh+
         0y1yt9TMRdymrG3UTMFXnTmq/szLjolTnbfjI0Bxx1FfppiLzEUPmTnGL3anYf7aEhzi
         c7uQ==
X-Gm-Message-State: ANoB5pn1Mm9xs7ZNqUQjvqYhehRrnsQy28eo/q1OL9mhtUIH9cbmQW49
        bqbM6msS+V7yB88yYudlkEXh0g==
X-Google-Smtp-Source: AA0mqf51OQRphoCP+4uJweGZvapM+0agWx3FNr/wgHdYZQfwi37Ra6dU7e4LVM9n9/3PDpWxryXt2g==
X-Received: by 2002:ac2:4c54:0:b0:4a2:7e2a:d2e1 with SMTP id o20-20020ac24c54000000b004a27e2ad2e1mr23313316lfk.641.1670230542363;
        Mon, 05 Dec 2022 00:55:42 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id g1-20020a056512118100b004aab0ca795csm2066258lfr.211.2022.12.05.00.55.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 00:55:41 -0800 (PST)
Message-ID: <3908e923-a063-0377-1854-ccbb3ecc704d@linaro.org>
Date:   Mon, 5 Dec 2022 09:55:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 2/5] dt-bindings: net: add schema for NXP S32CC dwmac
 glue driver
To:     Chester Lin <clin@suse.com>
Cc:     =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <mbrugger@suse.com>,
        ghennadi.procopciuc@oss.nxp.com
References: <20221128054920.2113-1-clin@suse.com>
 <20221128054920.2113-3-clin@suse.com>
 <4a7a9bf7-f831-e1c1-0a31-8afcf92ae84c@linaro.org>
 <560c38a5-318a-7a72-dc5f-8b79afb664ca@suse.de>
 <9778695f-f8a9-e361-e28f-f99525c96689@linaro.org>
 <Y42jqDiiq+rOurV+@linux-8mug>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <Y42jqDiiq+rOurV+@linux-8mug>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2022 08:54, Chester Lin wrote:
>>>>> +examples:
>>>>> +  - |
>>>>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
>>>>> +    #include <dt-bindings/interrupt-controller/irq.h>
>>>>> +
>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_AXI
>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_PCS
>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_RGMII
>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_RMII
>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_MII
>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_PCS
>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_RGMII
>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_RMII
>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_MII
>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TS
>>>>
>>>> Why defines? Your clock controller is not ready? If so, just use raw
>>>> numbers.
>>>
>>> Please compare v1: There is no Linux-driven clock controller here but 
>>> rather a fluid SCMI firmware interface. Work towards getting clocks into 
>>> a kernel-hosted .dtsi was halted in favor of (downstream) TF-A, which 
>>> also explains the ugly examples here and for pinctrl.
>>
>> This does not explain to me why you added defines in the example. Are
>> you saying these can change any moment?
>>
> 
> Actually these GMAC-related SCMI clock IDs changed once in NXP's downstream TF-A,
> some redundant TS clock IDs were removed and the rest of clock IDs were all moved
> forward. 

This is not accepted. Your downstream TF-A cannot change bindings. As an
upstream contributor you should push this back and definitely not try to
upstream such approach.

> Apart from GMAC-related IDs, some other clock IDs were also appended
> in both base-clock IDs and platform-specific clock IDs [The first plat ID =
> The last base ID + 1]. Due to the current design of the clk-scmi driver and the
> SCMI clock protocol, IIUC, it's better to keep all clock IDs in sequence without
> a blank in order to avoid query miss, which could affect the probe speed.

You miss here broken ABI! Any change in IDs causes all DTBs to be
broken. Downstream, upstream, other projects, everywhere.

Therefore thank you for clarifying that we need to be more careful about
stuff coming from (or for) NXP. Here you need to drop all defines and
all your patches must assume the ID is fixed. Once there, it's
unchangeable without breaking the ABI.

Best regards,
Krzysztof

