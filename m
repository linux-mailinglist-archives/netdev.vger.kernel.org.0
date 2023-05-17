Return-Path: <netdev+bounces-3215-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C406706094
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5500E1C20E45
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 494CE610B;
	Wed, 17 May 2023 07:01:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D6D5CBB
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:01:45 +0000 (UTC)
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222213586
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 00:01:42 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-965d2749e2eso54283166b.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 00:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684306900; x=1686898900;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Eudh4inWklLfywh9TpEbNPnOHsTbUH6VKtKxjFTWxyU=;
        b=Docejfk3kZ/UN4dmv+Anhivz5V45YpqS5q2HEi+RLT30w0P9o6IGlEbbouWrQBet/R
         8yOuN5VW/AXWr+fHPn7mafafhdGW8llxs1fnxMo9kOgwnEzAlEkU4qLaLKD6MX1pSEgS
         hKIE6MBGOtGxLo8bp0/xeN303djbakXfvqbZjBC76Xvt9O5r46fhZsiKQYIhtBLUbfPA
         3Gol+80gBmHIkbiRpaazXeu4akqktexsIaz9di/ncO1rhInMmCFGV178lHNqQaEIb2g7
         k0x7Hzkv9XxTjKZlzGeT+TjPbvGBrR5rtoBkI17qKSTGE3OEZWnnWJLMpu836Kg1IYdk
         FUvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684306900; x=1686898900;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Eudh4inWklLfywh9TpEbNPnOHsTbUH6VKtKxjFTWxyU=;
        b=DLSvJMJn66pjZprJTW6Dr/5gJEeLECldGMwpNePqKotrcG5vuhsLQm3If05ZAl0T1W
         Lk56v+l8ATIYUOQ6feXj0UpngCo0FjPjfavB9PbnsTyQ5/UwrDezlo6Wlm0BKeVFlB2Q
         1gsfAQ6UM4sp/gD+zrEVwyRsCdoXGOSncJyFUErafMu5O1Z5cU+hrTwwktcRKdduRVMQ
         yNwiDu5RKpxxUjq9hP78s5tS1anpVqDTbP64XLcQnLYyd+86jynFxA0qzBt/r1H31aNl
         NDLC2xq253fXUOXjTRDtW0/bMedzfb+v0vi6bx+hXZyadahH0AkrDoNMwjKIKh9/bRKB
         lmzg==
X-Gm-Message-State: AC+VfDwTjtWTVjM3hVpKjJY/J8+T0BvoEd1TNKiT8Qts5HBe7hQlI/D4
	lorHDwid3NiPcTmGglQZoz93NcVFB+ay4X0SDwA=
X-Google-Smtp-Source: ACHHUZ6M/hgvmz5FYkFFbF8FjI6LYzfAb484NWf2CE9BH51n/xY7xJ7MX2+il0qYXyLhlnjnL+yC2g==
X-Received: by 2002:a17:907:318b:b0:962:9ffa:be19 with SMTP id xe11-20020a170907318b00b009629ffabe19mr36669810ejb.5.1684306900651;
        Wed, 17 May 2023 00:01:40 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:c9ff:4c84:dd21:568d? ([2a02:810d:15c0:828:c9ff:4c84:dd21:568d])
        by smtp.gmail.com with ESMTPSA id z23-20020a17090674d700b0096ac911ecb8sm6443334ejl.55.2023.05.17.00.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 00:01:40 -0700 (PDT)
Message-ID: <124a5697-9bcf-38ec-ca0e-5fbcae069646@linaro.org>
Date: Wed, 17 May 2023 09:01:38 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>, Vladimir Oltean <olteanv@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 Conor Dooley <conor.dooley@microchip.com>
References: <20230515074525.53592-1-krzysztof.kozlowski@linaro.org>
 <20230515074525.53592-1-krzysztof.kozlowski@linaro.org>
 <20230515105035.kzmygf2ru2jhusek@skbuf> <20230516201000.49216ca0@kernel.org>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230516201000.49216ca0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 17/05/2023 05:10, Jakub Kicinski wrote:
> On Mon, 15 May 2023 13:50:35 +0300 Vladimir Oltean wrote:
>> On Mon, May 15, 2023 at 09:45:25AM +0200, Krzysztof Kozlowski wrote:
>>> Some boards use SJA1105 Ethernet Switch with SPI CPHA, while ones with
>>> SJA1110 use SPI CPOL, so document this to fix dtbs_check warnings:
>>>
>>>   arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dtb: ethernet-switch@0: Unevaluated properties are not allowed ('spi-cpol' was unexpected)
>>>
>>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
>>
>> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Is my instinct that this should go to net-next correct?

Yes, apologies, I usually forget the net-next tag.

Shall I resend?

Best regards,
Krzysztof


