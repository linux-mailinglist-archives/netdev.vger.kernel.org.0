Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2347D5B6150
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiILSxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiILSxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:53:51 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A7E192B1
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:53:49 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h188so9082105pgc.12
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=eu+Y0GxqpAYk/blE6b6eAg2V++css9z9LTCv5OV58Iw=;
        b=itTP2g8kQuP+En3k3FWdKM7MuG2mB8+HmOuv4jvVRnEupfn0/dVq41Rf2pcrexOJVD
         /VCUMeem5Kh52IvYayTLE6K+sYTKq81CShFxm0ksahAIhL5b0X2UZAUaRIApZYClYW4A
         D9uDIZ1IYn/+gz8MWx6860tvmEOr1du8pDU+7hCbpKUF33gEJeOlxOyicPjGPL5vqZ6K
         dhHeNuGwxjCxT0fAvHniKJSO5KnhAOmO07VR4DRCH2iYOi3zPDzsDgALJ4ZGMJ6wzh2T
         J9MMWXBwBRHJsEaxLa6ywP1NtUGP1TtZFqydNvE4BGPWnZQF/IVZ+QhzLOsMfobggWJE
         2bXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=eu+Y0GxqpAYk/blE6b6eAg2V++css9z9LTCv5OV58Iw=;
        b=h0paaqZIyxUkuW+iegIlgRp9vik8PUv9QSrF6eyY3lKXl0znsoZxjxAsUlHvyjuj+i
         78QgknMErZEo7UwBxRy8tbOd7Mi0GB3WOepB5waDAZJANWp2vVhPUpIoC5LVOH/UG6yC
         omXYjdP17LReSzkPz+fYu2YY119hAPKErjsxxYhntcwF2r5WcJdCablysK3Z2c4C1iCl
         KkiZCW2E9RmCPggdaaUzZvtl4YFNjH58AnLYQWHGb4kS38A2MjM8BfQRiJa9zxT5Qmlh
         siekKYI3Y1B5EV1XCBYE2/1D2TkFf09LvgLZhSEq0OLZRxoa/vdrwWz1gCsHFEC0eY4S
         CCaA==
X-Gm-Message-State: ACgBeo1LI6vCm2k9ILz/xbB5XGvE5wfveVQriCeFuDyzWNj0j9h+420K
        Cnt/69naTu61TMK7ChT9I8qIYg==
X-Google-Smtp-Source: AA6agR58cC1Ep7n6UweoDOxuW+z7oY73tW/YVyeR/I5tQtNtY/F2m9g02EzS5c1w6qxs7ZTsBDD7wQ==
X-Received: by 2002:a63:1f0e:0:b0:438:5cd8:8d60 with SMTP id f14-20020a631f0e000000b004385cd88d60mr18709989pgf.70.1663008828733;
        Mon, 12 Sep 2022 11:53:48 -0700 (PDT)
Received: from ?IPV6:2401:4900:1c60:5362:9d7f:2354:1d0a:78e3? ([2401:4900:1c60:5362:9d7f:2354:1d0a:78e3])
        by smtp.gmail.com with ESMTPSA id j3-20020a170902da8300b001714e7608fdsm6414843plx.256.2022.09.12.11.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 11:53:48 -0700 (PDT)
Message-ID: <46087486-bacd-c408-7ead-5b120412412b@linaro.org>
Date:   Tue, 13 Sep 2022 00:23:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 3/4] dt-bindings: net: snps,dwmac: Update reg maxitems
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
 <20220907204924.2040384-4-bhupesh.sharma@linaro.org>
 <da383499-fe9f-816e-8180-a9661a9c0496@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
In-Reply-To: <da383499-fe9f-816e-8180-a9661a9c0496@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/22 8:11 PM, Krzysztof Kozlowski wrote:
> On 07/09/2022 22:49, Bhupesh Sharma wrote:
>> Since the Qualcomm dwmac based ETHQOS ethernet block
>> supports 64-bit register addresses, update the
>> reg maxitems inside snps,dwmac YAML bindings.
> 
> Please wrap commit message according to Linux coding style / submission
> process:
> https://elixir.bootlin.com/linux/v5.18-rc4/source/Documentation/process/submitting-patches.rst#L586
> 
>>
>> Cc: Bjorn Andersson <andersson@kernel.org>
>> Cc: Rob Herring <robh@kernel.org>
>> Cc: Vinod Koul <vkoul@kernel.org>
>> Cc: David Miller <davem@davemloft.net>
>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>> ---
>>   Documentation/devicetree/bindings/net/snps,dwmac.yaml | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> index 2b6023ce3ac1..f89ca308d55f 100644
>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> @@ -94,7 +94,7 @@ properties:
>>   
>>     reg:
>>       minItems: 1
>> -    maxItems: 2
>> +    maxItems: 4
> 
> Qualcomm ETHQOS schema allows only 2 in reg-names, so this does not make
> sense for Qualcomm and there are no users of 4 items.

On this platform the two reg spaces are 64-bit, whereas for other
platforms based on dwmmac, for e.g. stm32 have 32-bit address space.

Without this fix I was getting the following error with 'make dtbs_check':

Documentation/devicetree/bindings/net/qcom,ethqos.example.dtb: 
ethernet@20000: reg: [[0, 131072], [0, 65536], [0, 221184], [0, 256]] is 
too long
	From schema: 
/home/bhsharma/code/upstream/linux-bckup/linux/Documentation/devicetree/bindings/net/snps,dwmac.yaml

Thanks.
