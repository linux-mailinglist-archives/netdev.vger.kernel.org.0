Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D496E5B612C
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiILSjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiILSjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:39:06 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C56EBE16
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:37:58 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q9-20020a17090a178900b0020265d92ae3so13209936pja.5
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=+Cpo4D45zMfxpSWTI7OS+5a+1V2tM3ykTTdnWVjeH5E=;
        b=Fnc0GUG7GypbUI1LdW5XHIgARglcRF4NHSftf8AzG6ZuHYRPZZXICQpZQzUI0Uj4+p
         k+AAP9hSgWC/ail7d+YayuThoa972s8Vd7c++TerqZXFiSOWc5JVpWbPhZlkO4862R+T
         /KOC2p2Lnxir+HtSzUJCSZ9HD+pRjDdbOgZS7ZUgWlh99BX4PUsKgbkJdjEhp33hdEir
         doQthJHhCaSwYmFxocSDC8GhlJT4upAPp3JShBiMfazN5/UceozJBvKbWx1E7ko+rCDl
         sRRIl6Ny/P7rBarx4fKOoCuOtHs3ezUFad5x8EZ3tTB85vHovop3Dkv/YAMnp+AKtyzq
         /fyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=+Cpo4D45zMfxpSWTI7OS+5a+1V2tM3ykTTdnWVjeH5E=;
        b=Gpap3tmLMNx7jPRW35z/u0SytQVrs4ujbafNSEoWHiK2jm2NZSpMnBKEDOjLJ7kmxR
         +g2hMdO5UO3qJH4Ux4V0AQ7GwyvNDqWKTtKVPer9R1Rs+/9K7xNGVTqj5TDd4O92Oh8t
         Vp10NkLqvuTgy/F1cQDX9+zOto7RooxRrjPjVzoeDhf0gJh4OsMQqeG4+ryhwuJxZYuu
         jsJ1fIt4BuZkEN+dal94t82kbHs0swrxyZgrog9qg4GjyzMbrzbWpn/qk46S3SIvAXi5
         PG1+e+OLAT+uNgCoPSySGEGruCt7dpDLkncBGMvAC7GCukYddn1MQuONgafeijuF8bQY
         5wSA==
X-Gm-Message-State: ACgBeo14e36PX/HlqYedndghld1R7LwvsPr3tArg6cK/jFebJNuS/3Fo
        QGdtVoDJXFdN3TjUg2mwKdrj9A==
X-Google-Smtp-Source: AA6agR7kFJHc9KI2S3cILtOhfV5azMbrfW6yKSTHSfnbla37nqdznLONQMTmOZotbsfNFrYmmyMOHw==
X-Received: by 2002:a17:90b:3b89:b0:202:e2db:6eaf with SMTP id pc9-20020a17090b3b8900b00202e2db6eafmr3444181pjb.92.1663007877242;
        Mon, 12 Sep 2022 11:37:57 -0700 (PDT)
Received: from ?IPV6:2401:4900:1c60:5362:9d7f:2354:1d0a:78e3? ([2401:4900:1c60:5362:9d7f:2354:1d0a:78e3])
        by smtp.gmail.com with ESMTPSA id o6-20020a170902d4c600b0016b81679c1fsm6406187plg.216.2022.09.12.11.37.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 11:37:56 -0700 (PDT)
Message-ID: <f541a2cb-9a91-7d89-c2f9-948d77376a87@linaro.org>
Date:   Tue, 13 Sep 2022 00:07:51 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 2/4] dt-bindings: net: snps,dwmac: Add Qualcomm Ethernet
 ETHQOS compatibles
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
 <20220907204924.2040384-3-bhupesh.sharma@linaro.org>
 <d191cdd3-64be-4fc4-56d6-c0e6c5c80b19@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
In-Reply-To: <d191cdd3-64be-4fc4-56d6-c0e6c5c80b19@linaro.org>
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



On 9/8/22 8:09 PM, Krzysztof Kozlowski wrote:
> On 07/09/2022 22:49, Bhupesh Sharma wrote:
>> Add Qualcomm Ethernet ETHQOS compatible checks
>> in snps,dwmac YAML binding document.
>>
>> Cc: Bjorn Andersson <andersson@kernel.org>
>> Cc: Rob Herring <robh@kernel.org>
>> Cc: Vinod Koul <vkoul@kernel.org>
>> Cc: David Miller <davem@davemloft.net>
>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>> ---
>>   Documentation/devicetree/bindings/net/snps,dwmac.yaml | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> index 2d4e7c7c230a..2b6023ce3ac1 100644
>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> @@ -65,6 +65,8 @@ properties:
>>           - ingenic,x2000-mac
>>           - loongson,ls2k-dwmac
>>           - loongson,ls7a-dwmac
>> +        - qcom,qcs404-ethqos
>> +        - qcom,sm8150-ethqos
> 
> This must be squashed with previous one, otherwise patchset is not
> bisectable.

Ok, will fix in v2.

Thanks.
