Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20A86292D6
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 08:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbiKOH76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 02:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbiKOH7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 02:59:54 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9F220BC4
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:59:51 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id d6so23164407lfs.10
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HJPFTJOGuPRhd7ksoWE06DkherlyxwNY/RJOZ9ATVqs=;
        b=hO1pWG9FFw6lcA0dz0nGIKvIKA4R/SiXFR4HgemXVKeuy4ri+jgZm9KmbvhcTkPemv
         9ZPEmoWV29gKa+KZ3+bVE3krOfiof6B2Miohku1IQFC6r1ZB2pa+OckJ9K/AgXva+/1C
         qV8JLBtSUR8i9ufUY/1Zw5bUQqOvy6uGGzVol5BxOvWR5XsDP7P3g7Er/spdOOdVPuK5
         9I2nC8zz2eG+VcaF1vK9Z34SeBvF/iSThHPxPxjH2jvy/9qHtcXuS56MAmVamZ7jixxm
         1zjcu/F9Wdp4X/UurrUyZow9zrbqD+7cA+gSrPT843Smx57rhfuqTqyfHh0euoXhAWbK
         lIvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HJPFTJOGuPRhd7ksoWE06DkherlyxwNY/RJOZ9ATVqs=;
        b=KRMli9ZMS6/NT4YqUoKaJPllCZCzhY4ahWriI+Ml8hcx+uIVLJi9MfhPEduo9c3g+z
         z1OasnqPF7eZ0p070tb8U4UkoNUCkaHmuGUT5czNtrkuMiX2YkotjYJk8snLrUxwRj1T
         1iR2S6CrNQnrLjwd6WMHZfEBLDn5t3hhIR/XdqQJDBsb4WvRxClgcEqDbhbInLy7FEjg
         UJ5wQhsPeGr9B6DGnoZSHw/BOAphSIsQt5liZNsfffvE4VdS7BAJM1gAMsqOX/1bVdyh
         xI1s7M4MmMbOVfaXIeJvWdZLHWnUN5m1efPrUJecOdCbsD3UQpFB/7T7y3w93dVBXFhd
         kvwA==
X-Gm-Message-State: ANoB5plyHXEGhmbnlpo/zN7+AbG1hRM1tXUOuelpvEGHa43RG/MxeeI8
        MKuHUDsjrOx8MQY8x4BePYAT2g==
X-Google-Smtp-Source: AA0mqf4DsOuYz5YY9s6MWxbp9QH+GSKO3GjqvZ5CD3NNuQLOAKv/l/8yIDLggMj1iSKZHpcGsP8elg==
X-Received: by 2002:a05:6512:2803:b0:4a6:2ff6:f32f with SMTP id cf3-20020a056512280300b004a62ff6f32fmr6024570lfb.1.1668499190153;
        Mon, 14 Nov 2022 23:59:50 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id a27-20020a2eb55b000000b0026e8b82eba6sm2388385ljn.34.2022.11.14.23.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 23:59:49 -0800 (PST)
Message-ID: <88fd2f42-6f20-7bbe-1a4d-1f482c153f07@linaro.org>
Date:   Tue, 15 Nov 2022 08:59:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 1/5] dt-bindings: net: qcom,ipa: deprecate
 modem-init
Content-Language: en-US
To:     Alex Elder <elder@ieee.org>, Alex Elder <elder@linaro.org>,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221112200717.1533622-1-elder@linaro.org>
 <20221112200717.1533622-2-elder@linaro.org>
 <de98dbb4-afb5-de05-1e75-2959aa720333@linaro.org>
 <2f827660-ae9d-01dd-ded8-7fd4c2f8f8ae@ieee.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <2f827660-ae9d-01dd-ded8-7fd4c2f8f8ae@ieee.org>
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

On 14/11/2022 18:48, Alex Elder wrote:
> On 11/14/22 03:56, Krzysztof Kozlowski wrote:
>> On 12/11/2022 21:07, Alex Elder wrote:
>>> GSI firmware for IPA must be loaded during initialization, either by
>>> the AP or by the modem.  The loader is currently specified based on
>>> whether the Boolean modem-init property is present.
>>>
>>> Instead, use a new property with an enumerated value to indicate
>>> explicitly how GSI firmware gets loaded.  With this in place, a
>>> third approach can be added in an upcoming patch.
>>>
>>> The new qcom,gsi-loader property has two defined values:
>>>    - self:   The AP loads GSI firmware
>>>    - modem:  The modem loads GSI firmware
>>> The modem-init property must still be supported, but is now marked
>>> deprecated.
>>>
>>> Signed-off-by: Alex Elder <elder@linaro.org>
>>> ---
>>>   .../devicetree/bindings/net/qcom,ipa.yaml     | 59 +++++++++++++++----
>>>   1 file changed, 46 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
>>> index e752b76192df0..0dfd6c721e045 100644
>>> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
>>> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
>>> @@ -124,12 +124,22 @@ properties:
>>>         - const: ipa-clock-enabled-valid
>>>         - const: ipa-clock-enabled
>>>   
>>> +  qcom,gsi-loader:
>>> +    enum:
>>> +      - self
>>> +      - modem
>>> +    description:
>>> +      This indicates how GSI firmware should be loaded.  If the AP loads
>>
>> s/This indicates/Indicate/
>> (or any other grammar without describing DT syntax but hardware/system)
> 
> OK.
> 
>>> +      and validates GSI firmware, this property has value "self".  If the
>>> +      modem does this, this property has value "modem".
>>> +
>>>     modem-init:
>>> +    deprecated: true
>>>       type: boolean
>>>       description:
>>> -      If present, it indicates that the modem is responsible for
>>> -      performing early IPA initialization, including loading and
>>> -      validating firwmare used by the GSI.
>>> +      This is the older (deprecated) way of indicating how GSI firmware
>>> +      should be loaded.  If present, the modem loads GSI firmware; if
>>> +      absent, the AP loads GSI firmware.
>>>   
>>>     memory-region:
>>>       maxItems: 1
>>> @@ -155,15 +165,36 @@ required:
>>>     - interconnects
>>>     - qcom,smem-states
>>>   
>>> -# If modem-init is not present, the AP loads GSI firmware, and
>>> -# memory-region must be specified
>>> -if:
>>> -  not:
>>> -    required:
>>> -      - modem-init
>>> -then:
>>> -  required:
>>> -    - memory-region
>>> +allOf:
>>> +  # If qcom,gsi-loader is present, modem-init must not be present
>>> +  - if:
>>> +      required:
>>> +        - qcom,gsi-loader
>>> +    then:
>>> +      properties:
>>> +        modem-init: false
>>
>> This is ok, but will not allow you to keep deprecated property in DTS
>> for the transition period. We talked about this that you need to keep
>> both or wait few cycles before applying DTS cleanups.
> 
> My intention is expressed in the comment.  Is it because of the
> "if .... required ... qcom,gsi-loader"?
> 
> Should it be "if ... properties ... qcom,gsi-loader"?

You disallow modem-init here, so it cannot be present in DTS if
gsi-loader is present. Therefore the deprecated case like this:
  qcom,gsi-loader = "modem"
  modem-init;
is not allowed by the schema.

As I said, it is fine, but your DTS should wait a cycle.


Best regards,
Krzysztof

