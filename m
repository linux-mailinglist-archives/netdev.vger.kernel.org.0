Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BA55EEDC8
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 08:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbiI2GVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 02:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiI2GVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 02:21:08 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162955A155
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 23:21:07 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id i15-20020a17090a4b8f00b0020073b4ac27so420564pjh.3
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 23:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=sLe+12DYg/MsGOLMm2PiwRBOcXOJMIlCQlWuW8Bh/Z4=;
        b=X0gRac3fkiIlOB2YGRyfd+Ue4Rv+jxwT9mPS6EUIoElqbASd7xqUn9sqCZn+G0SQph
         asgx2+EpRRc+pU2dZMU+WsX9F25/8FybJXs+IJm6l9b+WDsxmZsmy4appAcS27YPaMGm
         xm75j2xyadmgzAHLSN0POvKmKx2DQMUbbRVQljAy1Wc8FYx7GVCMTLtMnOWmLdeYoTlO
         6QTYkph7oFAPEsLnpn9H55XyEiRyvlB6fRZ5XNKRKrcyLzq6kO5Cdwr94pjl5fYuDOQL
         f8umul9nXybOJ4CJCHGhBck3KjH253ln+PeJ2tGH+0laVRMAlV8I71W1CMW835DJi6OE
         plBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=sLe+12DYg/MsGOLMm2PiwRBOcXOJMIlCQlWuW8Bh/Z4=;
        b=eTS9rpi6/1TsMX7cacbwpJecjiK1YD+P2SfEcRK7sVkqlMpdzazEeTnkmb6TlDZr/m
         22qzVq/djQ/HucdZj60ywgQtDe8BIHLhTw7JpgFc3XC5ZAm/Y9UgobQ7WJreerBmtk5F
         dxFbSbJgCP0QRvOYtvlTst4n+2NB7ujonhqSjcFTbljST8rcFL+U5hG2ef/YeH9vlCNz
         X8ZEJ3oHveO9m58Tkx7cYpEwT1rG6sQmMWtVTd0pjfLOvHlzIo9l2LUtALnndsDwIZ5A
         t3Thfa4TxYTXGSg+pI576tI6FlYzuU+DmuWRXYv2mA5MMGvlbq6nXjp6MkrpNTeAxtep
         3Y7Q==
X-Gm-Message-State: ACrzQf0xkh6eEfPye4kyRTyCBFPE+G5WQoCYF2SXUP2i3mpTCA5kS6hi
        5LNHWkhSIG+Cy6FfPuDn3NUF9g==
X-Google-Smtp-Source: AMsMyM5mA4SyvOWX5ikSyYkozPV7tSVOQb8hJV1XNYZGm319RXQ57g7obi9wIcFoods3WRR9VZiNaw==
X-Received: by 2002:a17:902:f612:b0:178:a692:b20a with SMTP id n18-20020a170902f61200b00178a692b20amr1858371plg.55.1664432466534;
        Wed, 28 Sep 2022 23:21:06 -0700 (PDT)
Received: from ?IPV6:2401:4900:1f3b:3adb:24f8:ac24:2282:1dc7? ([2401:4900:1f3b:3adb:24f8:ac24:2282:1dc7])
        by smtp.gmail.com with ESMTPSA id n9-20020a170902e54900b0016d295888e3sm4936599plf.241.2022.09.28.23.21.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 23:21:05 -0700 (PDT)
Message-ID: <11bb755c-b608-a13f-1da1-639c6b3f18d4@linaro.org>
Date:   Thu, 29 Sep 2022 11:51:00 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 3/4] dt-bindings: net: snps,dwmac: Update reg maxitems
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        agross@kernel.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
References: <20220907204924.2040384-1-bhupesh.sharma@linaro.org>
 <20220907204924.2040384-4-bhupesh.sharma@linaro.org>
 <da383499-fe9f-816e-8180-a9661a9c0496@linaro.org>
 <46087486-bacd-c408-7ead-5b120412412b@linaro.org>
 <20220912211447.GB1847448-robh@kernel.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
In-Reply-To: <20220912211447.GB1847448-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 9/13/22 2:44 AM, Rob Herring wrote:
> On Tue, Sep 13, 2022 at 12:23:42AM +0530, Bhupesh Sharma wrote:
>> On 9/8/22 8:11 PM, Krzysztof Kozlowski wrote:
>>> On 07/09/2022 22:49, Bhupesh Sharma wrote:
>>>> Since the Qualcomm dwmac based ETHQOS ethernet block
>>>> supports 64-bit register addresses, update the
>>>> reg maxitems inside snps,dwmac YAML bindings.
>>>
>>> Please wrap commit message according to Linux coding style / submission
>>> process:
>>> https://elixir.bootlin.com/linux/v5.18-rc4/source/Documentation/process/submitting-patches.rst#L586
>>>
>>>>
>>>> Cc: Bjorn Andersson <andersson@kernel.org>
>>>> Cc: Rob Herring <robh@kernel.org>
>>>> Cc: Vinod Koul <vkoul@kernel.org>
>>>> Cc: David Miller <davem@davemloft.net>
>>>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>>>> ---
>>>>    Documentation/devicetree/bindings/net/snps,dwmac.yaml | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>>> index 2b6023ce3ac1..f89ca308d55f 100644
>>>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>>> @@ -94,7 +94,7 @@ properties:
>>>>      reg:
>>>>        minItems: 1
>>>> -    maxItems: 2
>>>> +    maxItems: 4
>>>
>>> Qualcomm ETHQOS schema allows only 2 in reg-names, so this does not make
>>> sense for Qualcomm and there are no users of 4 items.
>>
>> On this platform the two reg spaces are 64-bit, whereas for other
>> platforms based on dwmmac, for e.g. stm32 have 32-bit address space.
> 
> The schema for reg is how many addr/size entries regardless of cell
> sizes.
> 
>> Without this fix I was getting the following error with 'make dtbs_check':
>>
>> Documentation/devicetree/bindings/net/qcom,ethqos.example.dtb:
>> ethernet@20000: reg: [[0, 131072], [0, 65536], [0, 221184], [0, 256]] is too
>> long
>> 	From schema: /home/bhsharma/code/upstream/linux-bckup/linux/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> 
> The default cell sizes for examples is 1 for addr/size. If you want it
> to be 2, you have to write your own parent node. But why? It's just an
> example. Use 1 cell like the example originally had.

Got your point. Let me revert to the original example in v2.

Thanks,
Bhupesh
