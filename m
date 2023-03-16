Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052986BD8E2
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 20:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjCPTU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 15:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjCPTU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 15:20:57 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100E0113E1
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 12:20:55 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w9so11878160edc.3
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 12:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678994453;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I6W9kUfmlY3tEraL4nU9eY/Af3MdcpRFdLZzCUy+85U=;
        b=hVfamywI7Z36xHj6XfceRT3rEYu7wfXqO1XRTmOt0XtuS1PkmzUQX16lsH2KqLEfeV
         d255f9CAmKEI7EjqrU+c2cWlBUD0/GqyV9J10tpEQV7fjFsPcfLEIB8cu57VtX7rUDek
         4UanuNT7Ya6abBq+7caHifRqkiFOySFpEFbTnXAGI11fG0/r91wVhtxEmL9DFt2KZ+v9
         61m93BAFn1HQ/DoFe2qm/JF3HyET+PE7ufKR1sVG3VDpherQkPZwxCxGbZFJj/Mf+ZmD
         KzSeMCcilkxHvT6YH859eyYaRNj29AaCjaDhv1aCh46FqqymjR95pJOp7h4ME5sShC6V
         8VDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678994453;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I6W9kUfmlY3tEraL4nU9eY/Af3MdcpRFdLZzCUy+85U=;
        b=Bbd3UtjNidqOQfzGKl3wrRuJHioOSHcUlFsaE07H79HkrhpOeYDyzFdE9XcRBrYoP1
         yEr6iMkBF7U+Jj1GC+diGucqtXQn1OwJthErm235YO5+aIb/H4rn8GDLLeOldweFZc0O
         bZ+wLilfmEQSRYmjcwcu5PsoY17+ITSQbnAdEegQL2ROR7/uDvqddtwJGgwn7n/TEObG
         IcaAVsxp4d5GYzMEBdiaHC1KCFxSW++ZCmCu3NOKZ64yqZvVsCkLfJ5/HMEQdPJhtWEG
         OfQ3JJNimlxMJ4PM6/JU1XsQOwYiOvRXsUJkvmXZaEoVqf5Htr03Mt70waMgCvu1dYU/
         PNNg==
X-Gm-Message-State: AO0yUKU7tr7dprhQvdFBNJbtpJeRfIefI/Pnugu+BFd9hgh9QJaYtI2s
        04RLY/0uEj8Dak3qtKoXZWVHRA==
X-Google-Smtp-Source: AK7set8t10Jjk9M0yulDUJsBcv70/mUwE18d9PBfWRZHveo8W0esOHyL0XnxuDdXiwksCvF4lp4NSg==
X-Received: by 2002:aa7:db96:0:b0:4fa:d2b1:9176 with SMTP id u22-20020aa7db96000000b004fad2b19176mr672063edt.22.1678994453564;
        Thu, 16 Mar 2023 12:20:53 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9827:5f65:8269:a95f? ([2a02:810d:15c0:828:9827:5f65:8269:a95f])
        by smtp.gmail.com with ESMTPSA id k12-20020a50ce4c000000b004af70c546dasm143487edj.87.2023.03.16.12.20.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 12:20:53 -0700 (PDT)
Message-ID: <066ca8a9-783d-de4f-aa49-86748e5ee716@linaro.org>
Date:   Thu, 16 Mar 2023 20:20:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 01/11] dt-bindings: net: snps,dwmac: Update
 interrupt-names
Content-Language: en-US
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     linux-kernel@vger.kernel.org, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, mturquette@baylibre.com,
        sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com
References: <20230313165620.128463-1-ahalaney@redhat.com>
 <20230313165620.128463-2-ahalaney@redhat.com>
 <d4831176-c6f1-5a9b-3086-23d82f1f05a6@linaro.org>
 <20230316161525.fwzfyj3fhekfwafd@halaney-x13s>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230316161525.fwzfyj3fhekfwafd@halaney-x13s>
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

On 16/03/2023 17:15, Andrew Halaney wrote:
> On Thu, Mar 16, 2023 at 08:13:24AM +0100, Krzysztof Kozlowski wrote:
>> On 13/03/2023 17:56, Andrew Halaney wrote:
>>> From: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>>>
>>> As commit fc191af1bb0d ("net: stmmac: platform: Fix misleading
>>> interrupt error msg") noted, not every stmmac based platform
>>> makes use of the 'eth_wake_irq' or 'eth_lpi' interrupts.
>>>
>>> So, update the 'interrupt-names' inside 'snps,dwmac' YAML
>>> bindings to reflect the same.
>>>
>>> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>>> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
>>> ---
>>>
>>> I picked this up from:
>>> 		https://lore.kernel.org/netdev/20220929060405.2445745-2-bhupesh.sharma@linaro.org/
>>> No changes other than collecting the Acked-by.
>>>
>>>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> index 16b7d2904696..52ce14a4bea7 100644
>>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> @@ -105,8 +105,8 @@ properties:
>>>      minItems: 1
>>>      items:
>>>        - const: macirq
>>> -      - const: eth_wake_irq
>>> -      - const: eth_lpi
>>> +      - enum: [eth_wake_irq, eth_lpi]
>>> +      - enum: [eth_wake_irq, eth_lpi]
>>
>> I acked it before but this is not correct. This should be:
>> +      - enum: [eth_wake_irq, eth_lpi]
>> +      - enum: eth_lpi
> 
> Would
> +      - enum: [eth_wake_irq, eth_lpi]
> +      - const: eth_lpi
> be more appropriate? With the suggested change above I get the following
> error, but with the above things seem to work as I expect:
> 
>     (dtschema) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac|rebase-i] % git diff HEAD~
>     diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>     index 16b7d2904696..ca199a17f83d 100644
>     --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>     +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>     @@ -105,8 +105,8 @@ properties:
>          minItems: 1
>          items:
>            - const: macirq
>     -      - const: eth_wake_irq
>     -      - const: eth_lpi
>     +      - enum: [eth_wake_irq, eth_lpi]
>     +      - enum: eth_lpi

Eh, right, obviously should be here const, so:

 - const: eth_lpi

Best regards,
Krzysztof

