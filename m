Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EAC5E76D1
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 11:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbiIWJXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 05:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbiIWJXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 05:23:17 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87F8E10AD
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 02:23:15 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 10so923383lfy.5
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 02:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=6KRGHi5QO3WPnDzOkycHTFaQ6rn1LlFLCXaq4LIPA2o=;
        b=nr19Q9adKvfDHJX1/MuKtdcCmb+W2G4kH9i+60wOK18TE2mFjrQb+Zhxkd4iaZDLYw
         UljVVMKI9OZEOTsuDxxGAT5c/UFL8XR67rS6OWaaw9r4B8Qgmujg/irw+c6WkX8QZbyS
         uc4dhF5ciBcdB6NnytStFtuQlGW/MCd6onKxK6cu8Ue6qxkAAec6dFtEW27xIKGPCGf+
         RJUnMQeiGSrQ6DmPFstmf9gOAdikqtf/ykVZrUAvavkQBmcQrXPZk3kubgEHf9sxAbjQ
         KYQt8AkzYu1LGEoaUIe2emDFYd9Atk9KwGWgew5BnOESRBgIDVIrqORDZrcToYmUVGlb
         5d/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=6KRGHi5QO3WPnDzOkycHTFaQ6rn1LlFLCXaq4LIPA2o=;
        b=Yiw0rn4SLjb8cOukn+YmtX++T8VbN9uSpY89UxvmXO8Jm/bRrJdXXlyyu8uonz2jx/
         zB8n6kvkMgbxHsnOjMOCGun2p8gDQA1fy3EIjZqNdbUPFkgZQXp4tCbaIxyE59gA/RAJ
         YBGKCjaAB9Xh9yrgUxNYWXHH076P1qLoAFDa/3icJiFpPKOnrDqCo6Q7ytM3KTVGuajh
         v0/CEg7O8vEuWL+LNNXbIw5EvwTgFsiUvsVZxZsaZKCZpCwVDVeGxHQ9LJO00rkDOK56
         wHo1gklcK5AjcdfzoCU0yeGptV3jJukbFqy3U1r2zJfK+3OfiQaMiAUDgsc20p4nW2RJ
         vs4A==
X-Gm-Message-State: ACrzQf1fPPKZHoOYB7Wu7yJHmRdm8T5fULTYFpWDHJbBJFnZLqXDDMLz
        1NlchPtX8s3OwSjuo37dRqrk/w==
X-Google-Smtp-Source: AMsMyM5CQWggSmYXQq0F3Di+/pXRM3IYsH2YikO+/Bi2/zu7pZyr6nxphxgrV9sWndQW0zsNvXqCvQ==
X-Received: by 2002:a05:6512:1320:b0:488:8fcc:e196 with SMTP id x32-20020a056512132000b004888fcce196mr2715533lfu.602.1663924994025;
        Fri, 23 Sep 2022 02:23:14 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id 11-20020ac25f4b000000b00499b1873d6dsm1349862lfz.269.2022.09.23.02.23.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 02:23:13 -0700 (PDT)
Message-ID: <29f9fbd3-a266-e947-5dad-27181d3945e3@linaro.org>
Date:   Fri, 23 Sep 2022 11:23:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [resend PATCH v4 2/2] dt-bindings: net: snps,dwmac: add clk_csr
 property
Content-Language: en-US
To:     Jianguo Zhang <jianguo.zhang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Christophe Roullier <christophe.roullier@st.com>
References: <20220922092743.22824-1-jianguo.zhang@mediatek.com>
 <20220922092743.22824-3-jianguo.zhang@mediatek.com>
 <04b9e5ef-f3c7-3400-f9df-2f585a084c5d@linaro.org>
 <8007b455dd18837c06ab099a6009505e7dddc124.camel@mediatek.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <8007b455dd18837c06ab099a6009505e7dddc124.camel@mediatek.com>
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

On 23/09/2022 03:48, Jianguo Zhang wrote:
> Dear Krzysztof,
> 
> 	Thanks for your comment.
> 
> On Thu, 2022-09-22 at 17:07 +0200, Krzysztof Kozlowski wrote:
>> On 22/09/2022 11:27, Jianguo Zhang wrote:
>>> The clk_csr property is parsed in driver for generating MDC clock
>>> with correct frequency. A warning('clk_csr' was unexpeted) is
>>> reported
>>> when runing 'make_dtbs_check' because the clk_csr property
>>> has been not documented in the binding file.
>>>
>>
>> You did not describe the case, but apparently this came with
>> 81311c03ab4d ("net: ethernet: stmmac: add management of clk_csr
>> property") which never brought the bindings change.
>>
>> Therefore the property was never part of bindings documentation and
>> bringing them via driver is not the correct process. It bypasses the
>> review and such bypass cannot be an argument to bring the property to
>> bindings. It's not how new properties can be added.
>>
>> Therefore I don't agree. Please make it a property matching bindings,
>> so
>> vendor prefix, no underscores in node names.
>>
>> Driver and DTS need updates.
>>
> We will rename the property 'clk_csr' as 'snps,clk-csr' and update DTS
> & driver to align with the new name in next versions patches.

Thanks!

Best regards,
Krzysztof

