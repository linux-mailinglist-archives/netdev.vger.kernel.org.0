Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292A06E4A0A
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjDQNhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjDQNhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:37:05 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E5E6A75
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 06:37:03 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4edb9039a4cso1365963e87.3
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 06:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681738622; x=1684330622;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ajiTsFHjF5bEfn/T0pz497Y4T0W30EVlD5XZiWzW1G8=;
        b=k5Ai8lynqBteD3+ZaXcqgNcsEUo5d6I1KDWEBPrXfHBbhz0GPJDjV+iWgcELffFW2N
         T36YVT2Sy86NuQbvuMLTjodQ0XE3EhFULHLnHvQL09KakbwiDeB9ucZe8XqUj/CXRlSq
         y+WC08aV7bI8zAmgTCxNzlYSLx1NmTVjh80jQmF4d5iM4PYnwi07FcBdx5Rv/ZV5ChPU
         c2XTYkbs9qGVbJRcSVDiCT80JnDIQgpQvPJc49GEyYnTpSOcaJKRcMZZK49DouhhCho3
         7vYIY/lZFf8B8w3lBpnziyPT6B9YA4JVLUswFvsV6lq6RLwnoPuzLu6lhQfowSwA7gho
         WU0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681738622; x=1684330622;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ajiTsFHjF5bEfn/T0pz497Y4T0W30EVlD5XZiWzW1G8=;
        b=kdHnA/Ij29oJTHTjZPF2G0iW92Hj+INk/43ckFZUKfdJ1+YV8E1QF0nMQfdhI2boqj
         3/t6VhNiLkvY3EvGIYC8Xkmp/m2tyjVI+3tzEWJq3o8RHC3RpGxeGSKHXZ48ixS7rPc5
         tIFe/muGDXi9YFbKHdsDVgA5zt0PO7mtHllSD0AYtqkfuI++4xn4Eyc0JUw+kRqZ1aKz
         b4N6oSpFVY7o6ffkyTje1oR46pbcURiVbes7N+NNigV3AyhCkuQvqfWo7fiJ1BnVWBNt
         nVv3L576Wd5KlxLfSQrcT48f5a3fnjLPDYMv9n7jPoxlTkBXS4hAYu7xYgHg0+pfxryJ
         Tb2w==
X-Gm-Message-State: AAQBX9fc9R3y8E2lN+1fQIIbKJmTRTrLDMQ/SGSNYIbML8eBpFGglopH
        Exj/nHQh/Yq6jCI2g4tFlREzQQ==
X-Google-Smtp-Source: AKy350bqpmBwO7pT6gTJyyulqIMk2WplO3I3p5A9atMkIk4oS8bLgIA8QDfDyLRF7NBH71KIU62zxQ==
X-Received: by 2002:ac2:4c2f:0:b0:4ec:b1bf:a55b with SMTP id u15-20020ac24c2f000000b004ecb1bfa55bmr1642956lfq.24.1681738621717;
        Mon, 17 Apr 2023 06:37:01 -0700 (PDT)
Received: from [192.168.1.101] (abyk99.neoplus.adsl.tpnet.pl. [83.9.30.99])
        by smtp.gmail.com with ESMTPSA id u6-20020ac243c6000000b004e7fa99f2b5sm2061422lfl.186.2023.04.17.06.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 06:37:01 -0700 (PDT)
Message-ID: <8a6834d6-8e5a-3c48-8a04-8d9c4d160408@linaro.org>
Date:   Mon, 17 Apr 2023 15:36:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v4] dt-bindings: net: Convert ATH10K to YAML
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <20230406-topic-ath10k_bindings-v4-1-9f67a6bb0d56@linaro.org>
 <87pm82x1ew.fsf@kernel.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <87pm82x1ew.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17.04.2023 12:12, Kalle Valo wrote:
> Konrad Dybcio <konrad.dybcio@linaro.org> writes:
> 
>> Convert the ATH10K bindings to YAML.
>>
>> Dropped properties that are absent at the current state of mainline:
>> - qcom,msi_addr
>> - qcom,msi_base
> 
> Very good, thanks. Clearly I had missed that those were unused during
> the review.
> 
>> qcom,coexist-support and qcom,coexist-gpio-pin do very little and should
>> be reconsidered on the driver side, especially the latter one.
> 
> I'm curious, what do you mean very little? We set ath10k firmware
> parameters based on these coex properties. How would you propose to
> handle these?
Right, I first thought they did nothing and then realized they're
sent to the fw.. I never amended the commit message though..


> 
>> Somewhat based on the ath11k bindings.
>>
>> Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> 
> [...]
> 
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
>> @@ -0,0 +1,358 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/wireless/qcom,ath10k.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Qualcomm Technologies ATH10K wireless devices
> 
> [...]
> 
>> +  wifi-firmware:
>> +    type: object
>> +    additionalProperties: false
>> +    description: |
>> +      The ATH10K Wi-Fi node can contain one optional firmware subnode.
>> +      Firmware subnode is needed when the platform does not have Trustzone.
> 
> Is there a reason why you write ath10k in upper case? There are two case
> of that in the yaml file. We usually write it in lower case, can I
> change to that?
No particular reason, my brain just implicitly decided that it
should be this way.. Please unify it (or LMK if you want me to
perform another resend)!

Konrad
> 
