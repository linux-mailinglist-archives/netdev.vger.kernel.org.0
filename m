Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6416D9FDC
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 20:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240198AbjDFSa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 14:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240179AbjDFSaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 14:30:55 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AD383FB
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 11:30:53 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id lj25so3567322ejb.11
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 11:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680805852;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x/9T8X0aJGHx3fxYyKXLVBxSn1+GBp9A84npgBtxwpQ=;
        b=rTJAZMeAk8kQps82Fl2QjyfHxMfDmnwPODIiNEWQF04PsneOdC7VSCbZ4UexBAQ6js
         SwPlM7FXnVBx1GyrIpIAskjllZGuoN1u8WayX9TrPXS9y3CaPQpbKY5CxTtjDzs+Pk/D
         Uhkg/Wr/ZOl7A4PIY4qgY6FPv1RRG2G8lhG5iRVBSEnqE5p9qmSREBHupbthnA6MYsWC
         KcAwmVzgeXUi7XfDE6EVTPY3elVw2K/wGcP/paiCYepU1smywjlhxlUEZFAb/8cKBiNF
         ki8BK9tOVsU6/T1pEKBNjYxilS7F/8wVv3lNhNZ6iSVh6Dv9WFI3o1eyslRjXj3/GPcM
         7bRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680805852;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x/9T8X0aJGHx3fxYyKXLVBxSn1+GBp9A84npgBtxwpQ=;
        b=fZkQIrr3Y7kQ5A5e/21VJ8WVzVuiUt17uxkjC9UXvPWpanNM8JEZNRZfdMPU0vqkpK
         yfit28dJxPj8YtC9ANyGzxQLjHwVHx66Sio7GLL1iYeWw4M3HHyMQSgOnKzY0WLsNXUl
         ltqxCNYLIRIMIO2L1Lbx/KZz7p4diV12FVyrzvxgymzGwvql7gLSDodyUjbUlY6EfXZA
         93uQVSh2zLlqlMr/IW4IngYXja9YhNrWD5H2j/a8ssWEF5Ef/Fi5Pa0vg9CVjCbrbEhD
         rts17Gw07PbeNq6queQwmLoQBo5hJB63okPIYulnq9Jqibj+JxPRRGeLUtpTveswQzUG
         +Sww==
X-Gm-Message-State: AAQBX9egGD0A3AqCotTa4N8NUFh/PrrHqQ+N24freSpt4ywC2uDg2f+C
        7wZLcsFAQ+YFUol/MO2D9H7RCw==
X-Google-Smtp-Source: AKy350bDMKSCylnIPj1Ksoj4IJGQIYTiAs8Q2jfaOhuGPgSR8H22JsRbXfT+Le5UTWJl6pi5F11lzg==
X-Received: by 2002:a17:907:9870:b0:944:18e0:6ef2 with SMTP id ko16-20020a170907987000b0094418e06ef2mr6970633ejc.73.1680805851773;
        Thu, 06 Apr 2023 11:30:51 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:49e6:bb8c:a05b:c4ed? ([2a02:810d:15c0:828:49e6:bb8c:a05b:c4ed])
        by smtp.gmail.com with ESMTPSA id i18-20020a170906251200b009447277c2aasm1124481ejb.39.2023.04.06.11.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 11:30:51 -0700 (PDT)
Message-ID: <6720f61e-550f-6e16-8860-54233a3ea069@linaro.org>
Date:   Thu, 6 Apr 2023 20:30:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v3 1/2] dt-bindings: net: Convert ATH10K to YAML
Content-Language: en-US
To:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     Marijn Suijten <marijn.suijten@somainline.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <20230406-topic-ath10k_bindings-v3-0-00895afc7764@linaro.org>
 <20230406-topic-ath10k_bindings-v3-1-00895afc7764@linaro.org>
 <223892d0-9b1b-9459-dec1-574875f7c1c6@linaro.org>
 <8c818f95-b4a4-658f-701d-3151afdd5179@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <8c818f95-b4a4-658f-701d-3151afdd5179@linaro.org>
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

On 06/04/2023 20:26, Konrad Dybcio wrote:

>>> +        interrupts:
>>> +          items:
>>> +            - description: CE0
>>> +            - description: CE1
>>> +            - description: CE2
>>> +            - description: CE3
>>> +            - description: CE4
>>> +            - description: CE5
>>> +            - description: CE6
>>> +            - description: CE7
>>> +            - description: CE8
>>> +            - description: CE9
>>> +            - description: CE10
>>> +            - description: CE11
>>
>> What about interrupt-names here? If they are not expected, then just
>> interrupt-names: false
> They obviously wouldn't hurt, but they're unused on the driver side:
> 
> for (i = 0; i < CE_COUNT; i++) {
> 		ret = platform_get_irq(ar_snoc->dev, i);
> 
> So I will forbid them.

Assuming DTS does not have them.

Best regards,
Krzysztof

