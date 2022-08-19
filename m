Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92DEF599BA1
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 14:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348434AbiHSME5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 08:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348105AbiHSME4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 08:04:56 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824FEEC4F2
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 05:04:54 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id q18so3318430ljg.12
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 05:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=AiiavDzYSZGUIztBfno9z4N7pQ7TlVNfOCCAVwE9hcE=;
        b=fcrPitOJWPMSCaIFodXOuiGjsjZ3YG++th1NSR69d04k4xiIIxW/vAJTIwA0xfCNCh
         mBrThOoUWZ0bzwd8E0+Y0xg1gbCgKtVeea7xsWTxhXHjBUQ6z6zlUBuyl66T6hgQUEjU
         UPThXCW2kyIGg/3Fb8NHvKLqHBB3ZA2AkyjtbaS+QG9yjzJtXYi7A3zKXEGfC7dnngEr
         dVDhfSoKX8zdnCURcP7oNgylvP+Lz5FO6vGUVw5YeHpJ6RzM9FTUUYGrmidcbbHcxD6p
         QdKB+RjaIH94jw6lG2zwbGhkqY3QUS2IM3kiF62tXgbQ8egLYzhDcNOe6LAO5jWQF0uF
         y6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=AiiavDzYSZGUIztBfno9z4N7pQ7TlVNfOCCAVwE9hcE=;
        b=GA9VPP5CQXZqflYT7S7lA4spOcYaBtK9BUm6Oo8B4BcTRbo4nWyDT1Un3vkPfXxXGI
         9mL7yDSfJXwnvo5chmKzP5wPaKEHBj2mLeBY2fm4d+7RCIopL1dDC1E4ZxvFzL86pPSI
         4dlCj0UIxIQ6N91jUz3ryrdpyC/1unIY8NfQ3byvdqvx7KANhu6Dfy4wKcFvE/ote7O7
         u9caIUyf9rO+Qrm4Q9Cg3zhlrmD/BrsCYH4r6xyZlDo+Jd1y8hSDnHK24W2mSmLENAR6
         HSuUmlOqD7BGn4O/sCKItuj7n1XlUY9QanvDclZHtTw2zM699mXrvGTbqVoV/RG+ZimM
         X71w==
X-Gm-Message-State: ACgBeo3pMeWQAZh4aPSXdvYukBL8ho+drbWWXWik59hxsTca3fEhklml
        MKKfygvTe/lthdkLF6GRtuFVIA==
X-Google-Smtp-Source: AA6agR62NsOl6RRwRFqNAw94cpa4kOYCLcjYJwk01j7896M6g6Q2MZGyA4hvWzdOuTvsQf2wGycn+Q==
X-Received: by 2002:a2e:8484:0:b0:25e:c325:c94f with SMTP id b4-20020a2e8484000000b0025ec325c94fmr2210517ljh.310.1660910692805;
        Fri, 19 Aug 2022 05:04:52 -0700 (PDT)
Received: from ?IPV6:2001:14bb:ac:e5a8:ef73:73ed:75b3:8ed5? (d1xw6v77xrs23np8r6z-4.rev.dnainternet.fi. [2001:14bb:ac:e5a8:ef73:73ed:75b3:8ed5])
        by smtp.gmail.com with ESMTPSA id q5-20020ac25fc5000000b0048b04d494c6sm620337lfg.51.2022.08.19.05.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 05:04:52 -0700 (PDT)
Message-ID: <9d9c2f78-db3e-71aa-2cdd-e2d9aa2b30cf@linaro.org>
Date:   Fri, 19 Aug 2022 15:04:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v4 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update
 bindings for J7200 CPSW5G
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>,
        krzysztof.kozlowski+dt@linaro.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org, linux@armlinux.org.uk,
        vladimir.oltean@nxp.com, grygorii.strashko@ti.com, vigneshr@ti.com,
        nsekhar@ti.com, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com
References: <20220816060139.111934-1-s-vadapalli@ti.com>
 <20220816060139.111934-2-s-vadapalli@ti.com>
 <79e58157-f8f2-6ca8-1aa6-b5cf6c83d9e6@linaro.org>
 <31c3a5b0-17cc-ad7b-6561-5834cac62d3e@ti.com>
 <9c331cdc-e34a-1146-fb83-84c2107b2e2a@linaro.org>
 <176ab999-e274-e22a-97d8-31f655b16800@ti.com>
 <da82e71f-e32c-7adb-250e-0c80cc6e30bd@ti.com>
 <0ca78aad-2145-c88b-a26e-9ababa38df6e@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <0ca78aad-2145-c88b-a26e-9ababa38df6e@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2022 13:43, Siddharth Vadapalli wrote:

>>>> Anyway the location is not correct. Regardless if this is if-then or
>>>> allOf-if-then, put it just like example schema is suggesting.
>>>
>>> I will move the if-then statements to the lines above the
>>> "additionalProperties: false" line. Also, I will add an allOf for this
>>
>> I had a look at the example at [1] and it uses allOf after the
>> "additionalProperties: false" line. Would it be fine then for me to add
>> allOf and the single if-then statement below the "additionalProperties:
>> false" line? Please let me know.
>>
>> [1] -> https://github.com/devicetree-org/dt-schema/blob/mai/test/schemas/conditionals-allof-example.yaml
> 
> Sorry, the correct link is:
> https://github.com/devicetree-org/dt-schema/blob/main/test/schemas/conditionals-allof-example.yaml

You are referring to tests? I did not suggest that. Please put it in
place like example schema is suggesting:

https://elixir.bootlin.com/linux/v5.19/source/Documentation/devicetree/bindings/example-schema.yaml

Best regards,
Krzysztof
