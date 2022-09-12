Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7D35B6132
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbiILSkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiILSkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:40:20 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAB6BC36
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:39:47 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id bu5-20020a17090aee4500b00202e9ca2182so891620pjb.0
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=bs6cY7jsJqoKWWPHSReiAiAq8v2yuiAMDwslSXetISo=;
        b=rcXmXPCVnwCcRVgP2Twc30tTHXUF+WsfGDNbmtzRFUEU9vaxsyXceGBG7JTMjbiT8G
         wkfZapuTCZOuPsq4/c0vPoyL/WNn1DtoJekFDrCwa7zD32zpxvb/S5V9XsbhlNh4+2e3
         WZvOQVtKWg4xyZi7H/rIVhrTbsSIwwwwfvqGra67loAudGAFeB8172IdWwq0crHFiJWm
         eSu9O5l4+zgZHfr3o1bmTbl/dtYwV/o189fTmy0Mh4FxBQgvSAE9kG9sTbjZAt5hj4p+
         /Jg5E+nt4XJDGVEgt3L+Y/EAN+5YdO7CHVTZuK7VVW7m/dtQSPJOS6/Wltq9DZfPAqAy
         Ekmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=bs6cY7jsJqoKWWPHSReiAiAq8v2yuiAMDwslSXetISo=;
        b=o33qsxfjPyAFrSohAFM+ZIgzGejrD9OgEa6eiPKNLBBnCfd4dtqF9/IILI27oJJpI+
         nD0vnuEX8x16HD86TORrwB1rcA7m7CkB6qjYRjsD3LJadnpG2KehO283WqH6B8zjVoxJ
         97Asu6KEOVqUbS0x7QICoYg3+9OAYwczisovw/n4mQOKU0NHynHkv1L6Y0YAQMbk/8qE
         prX5AHnbxOCnz+Zij7tXmxSe7LsKGufS69lXdjuZo2ou+CAx6ENg/Wp7SVJ6iWjjF583
         zUe3RNWTszs6OmgATtJCUyTKDFMe9j0pc0wUCmFS2SmLw3AeberaeH8x0x3R9NROU4tG
         33Aw==
X-Gm-Message-State: ACgBeo3koLf9PXI29JezpbSEuo+5ib2PyQxLSw8GUuMmMjU4q831cJ4m
        UYRMZalHR+UxbmnsS4bH47CYrg==
X-Google-Smtp-Source: AA6agR50Ne1mei+wMUxARhvXYS3lsDFitgnEjrHfsvDUce33WQnq7GF8owQjID6Zrcapn13BcvL+nQ==
X-Received: by 2002:a17:90b:2743:b0:200:9be5:d492 with SMTP id qi3-20020a17090b274300b002009be5d492mr25287793pjb.237.1663007986508;
        Mon, 12 Sep 2022 11:39:46 -0700 (PDT)
Received: from ?IPV6:2401:4900:1c60:5362:9d7f:2354:1d0a:78e3? ([2401:4900:1c60:5362:9d7f:2354:1d0a:78e3])
        by smtp.gmail.com with ESMTPSA id s18-20020a170902c65200b00176d8e33601sm6312937pls.203.2022.09.12.11.39.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 11:39:46 -0700 (PDT)
Message-ID: <0f98adbf-1786-7212-77e2-22c58484aed1@linaro.org>
Date:   Tue, 13 Sep 2022 00:09:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 4/4] dt-bindings: net: snps,dwmac: Update interrupt-names
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, agross@kernel.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
References: <20220907204924.2040384-1-bhupesh.sharma@linaro.org>
 <20220907204924.2040384-5-bhupesh.sharma@linaro.org>
 <71d970bc-fe6f-91e7-80c1-711af1af5530@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
In-Reply-To: <71d970bc-fe6f-91e7-80c1-711af1af5530@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/8/22 8:13 PM, Krzysztof Kozlowski wrote:
> On 07/09/2022 22:49, Bhupesh Sharma wrote:
>> As commit fc191af1bb0d ("net: stmmac: platform: Fix misleading
>> interrupt error msg") noted, not every stmmac based platform
>> makes use of the 'eth_wake_irq' or 'eth_lpi' interrupts.
>>
>> So, update the 'interrupt-names' inside 'snps,dwmac' YAML
>> bindings to reflect the same.
>>
>> Cc: Bjorn Andersson <andersson@kernel.org>
>> Cc: Rob Herring <robh@kernel.org>
>> Cc: Vinod Koul <vkoul@kernel.org>
>> Cc: David Miller <davem@davemloft.net>
>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>> ---
>>   Documentation/devicetree/bindings/net/snps,dwmac.yaml | 10 ++++++----
>>   1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> index f89ca308d55f..4d7fe4ee3d87 100644
>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> @@ -105,10 +105,12 @@ properties:
>>   
>>     interrupt-names:
>>       minItems: 1
>> -    items:
>> -      - const: macirq
>> -      - const: eth_wake_irq
>> -      - const: eth_lpi
>> +    maxItems: 3
>> +    contains:
>> +      enum:
>> +        - macirq
>> +        - eth_wake_irq
>> +        - eth_lpi
>>   
> 
> This gives quite a flexibility, e.g. missing macirq. Instead should be
> probably a list with enums:
> items:
>    - const: macirq
>    - enum: [eth_wake_irq, eth_lpi]
>    - enum: [eth_wake_irq, eth_lpi]

Ok, will fix in v2.

Thanks.
