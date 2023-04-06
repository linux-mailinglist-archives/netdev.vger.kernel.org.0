Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B9B6D975F
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 14:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238032AbjDFMxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 08:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238083AbjDFMxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 08:53:03 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE02F4C21
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 05:53:00 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id h25so50688235lfv.6
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 05:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680785579;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lbC+iDQolRLSwOunJ/j7FQP3aZrBUa7C2T5gWVYhv6I=;
        b=zvpzUfUNH0GaukXLBpAPf+hyShEdxGxtOyRluKQdxEtL4QovW/AkW/ylzw1ZaXMDtA
         k/3W7Pick4ECwKGVjnf06RQCkdb0mN2xE5IeE5sv9Gw2IIutccQwQx/++EOHPlzdMsH6
         GsjLFOKt7NNvQhsfj8bEYMC27jBNpDMUcg91xXE1rK0VCaBb+iA0U8R/0NIO1JRQKZ2m
         LPtPSJirHSB05LBpEne3q/R8NhgqnwbqW+Plwu7B8Bst4cKi8Sd/lyZiZVytq/9e9P70
         kPjQK++aERFwC1g5gXjSODs39UIli3d8luM642smqM6GgAauZWGZh+n0ekiDfxoBeyrW
         TNZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680785579;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lbC+iDQolRLSwOunJ/j7FQP3aZrBUa7C2T5gWVYhv6I=;
        b=yWbfjKiMmIUOUi+K9ooa9fpLdAWItVP+frgCsucBoxSLCZ0h0HpScugQHq6FIfcUrg
         Zy4TiU5u1ntg9Cn61YeeRvyeDlENKqUqbNzdpbQlzV62y8DCi4eFaURf5cAnRK1LcE7I
         iNvLThZcefrPkMRNYDoA8r+dcorlCCsfDnNwPaisvtVvo4ACOppiZvnNWPKuIgPhFDG/
         M5PUBdlFVveGbwXFx6aR5pyeuemcGisQC8GaPNYRZwQtqcmToAAUgcMrbWP5meiQmiQj
         Vc//1A61JHoiQUpkaaD6EQ3jXcR8+CUxYd5IC+Cz05SOe16Nz3CCiz8XKBKqGCs5/OU7
         YaeA==
X-Gm-Message-State: AAQBX9fpZ+uz5IizhP+yYi7pk0qIdQjKsaDx+iZAW4+YN0D+KvoKyOhK
        PWnYIUQ+wompQMee7vPlZqYcbQ==
X-Google-Smtp-Source: AKy350b/+CKd1ZodmBJD15FdPa3PXTOhvJljgBnSb42oOTa4LlbkXPdGlX4ifOYVKBresOlnli8ugA==
X-Received: by 2002:a19:ae03:0:b0:4ec:5648:70e4 with SMTP id f3-20020a19ae03000000b004ec564870e4mr158178lfc.12.1680785578924;
        Thu, 06 Apr 2023 05:52:58 -0700 (PDT)
Received: from [192.168.1.101] (abxh37.neoplus.adsl.tpnet.pl. [83.9.1.37])
        by smtp.gmail.com with ESMTPSA id y2-20020ac24462000000b004db1a7e6decsm249856lfl.205.2023.04.06.05.52.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 05:52:58 -0700 (PDT)
Message-ID: <857aa6c9-3dcb-d5f7-14bb-6c69c9167b09@linaro.org>
Date:   Thu, 6 Apr 2023 14:52:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Convert ATH10K to YAML
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, linux-wireless@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, Andy Gross <agross@kernel.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        linux-arm-msm@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        ath10k@lists.infradead.org
References: <20230406-topic-ath10k_bindings-v2-0-557f884a65d1@linaro.org>
 <20230406-topic-ath10k_bindings-v2-1-557f884a65d1@linaro.org>
 <168078494959.2736424.13312532374051031538.robh@kernel.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <168078494959.2736424.13312532374051031538.robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6.04.2023 14:47, Rob Herring wrote:
> 
> On Thu, 06 Apr 2023 13:54:04 +0200, Konrad Dybcio wrote:
>> Convert the ATH10K bindings to YAML.
>>
>> Dropped properties that are absent at the current state of mainline:
>> - qcom,msi_addr
>> - qcom,msi_base
>>
>> qcom,coexist-support and qcom,coexist-gpio-pin do very little and should
>> be reconsidered on the driver side, especially the latter one.
>>
>> Somewhat based on the ath11k bindings.
>>
>> Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
>> ---
>>  .../bindings/net/wireless/qcom,ath10k.txt          | 215 ------------
>>  .../bindings/net/wireless/qcom,ath10k.yaml         | 359 +++++++++++++++++++++
>>  2 files changed, 359 insertions(+), 215 deletions(-)
>>
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> 
> yamllint warnings/errors:
> 
> dtschema/dtc warnings/errors:
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.example.dtb: wifi@18800000: wifi-firmware: 'wifi-firmware' does not match any of the regexes: 'pinctrl-[0-9]+'
> 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.example.dtb: wifi@18800000: wifi-firmware: 'iommus' is a required property
> 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
> 
> doc reference errors (make refcheckdocs):
> MAINTAINERS: Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> 
> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230406-topic-ath10k_bindings-v2-1-557f884a65d1@linaro.org
Oh, CHECK_DTBS=1 doesn't run dt_binding_check and I didn't run that
explicitly before resending.. my bad..

Konrad
> 
> The base for the series is generally the latest rc1. A different dependency
> should be noted in *this* patch.
> 
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
> 
> pip3 install dtschema --upgrade
> 
> Please check and re-submit after running the above command yourself. Note
> that DT_SCHEMA_FILES can be set to your schema file to speed up checking
> your schema. However, it must be unset to test all examples with your schema.
> 
