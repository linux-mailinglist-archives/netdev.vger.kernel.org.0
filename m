Return-Path: <netdev+bounces-3238-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78F897062C0
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:26:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35B232815AC
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82419154AE;
	Wed, 17 May 2023 08:26:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AB515492
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:26:44 +0000 (UTC)
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2E6468A
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:26:42 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-50bc5197d33so862437a12.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684312000; x=1686904000;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SIOrvUUAtZyi4FUcHTM2x45qSYsRRVl2b97WHgQpvzE=;
        b=eQ3g/7Rm2/GZIotGQTg6KTEm2qew6cAgGks8iRaNvcPsWwXAFYZsrAKPtZC9leV57r
         OkmcZ+onUsyadK95vLiahEr/ht/fI0Km4qnow2gVjD3f3ENWjmmVMB9MxWk1SGhvKDye
         0N03RnFIiWFqMa+0Ph3YnDkIgj0qUmM0SYmv4rMMgY0XJP0l1LLZywu3oWugm0spIpGB
         +cgBR81BvIQBEGwE30xAM/NQIg2+rf9dXi9aKRVxIFhxTUCcgYLiYqgXRU9SnDPU6KMi
         NUbw6jjFT7jfkaA1+YE+xKERJR8AeGWms3MEpI5n4z32X0yU35nuUcDaN4eRmlsVDLKB
         M64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684312000; x=1686904000;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SIOrvUUAtZyi4FUcHTM2x45qSYsRRVl2b97WHgQpvzE=;
        b=Bn1mVDgKJq0YUSK8IMK9Y6KhH97IpEJC9HJlKt7fgotZO/AUbWNWHa4E1RQDspJdRc
         Fk50WA1UozYUXsC2JQOGQHrEdUCIsgoE5taMuqMtGHWPAOFdfuohaxKJdSx+g0qWuLNc
         1744rz3GqhCJ/zbZGYHYEdkfEkDYi0gALI24dp9QFjGuKOothMYGtt2rufm6NS2y2F2V
         89olJS8ytLXi+N8AD0hBVcq0orzZj1Tt62A5SKLrFFzK9S0urWnvK4cEGH2JFy4BKGrw
         /SHJNkHhmu0sNElS2tf7QU2xTR/pumhgGalhKscNGXilwIVq2PpWc4Q9TMcm4KGM88/t
         6pfw==
X-Gm-Message-State: AC+VfDxhhDEdyaVG5Y7xLYU+tYiFjrHx4lYvJAnBqC6rrIg5zpRroYTN
	6HlSHrLVRC31z8l/LT6Nwe/RFA==
X-Google-Smtp-Source: ACHHUZ7eptdbo1d96sX474rlETqgth2MCTCvWmKHpGMhDBMtcdSR5IZGuNGlLOAJwIKRGbpoWAwKcw==
X-Received: by 2002:aa7:d551:0:b0:508:3f06:8fd1 with SMTP id u17-20020aa7d551000000b005083f068fd1mr1386249edr.29.1684312000564;
        Wed, 17 May 2023 01:26:40 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:c9ff:4c84:dd21:568d? ([2a02:810d:15c0:828:c9ff:4c84:dd21:568d])
        by smtp.gmail.com with ESMTPSA id u24-20020a056402111800b0050bc4eb9846sm9010673edv.1.2023.05.17.01.26.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 01:26:40 -0700 (PDT)
Message-ID: <50cc1727-999f-9b7a-ef09-14461fa4ddfb@linaro.org>
Date: Wed, 17 May 2023 10:26:38 +0200
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
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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

It would be great missing net-next was pointed out by checkpatch.pl.

Best regards,
Krzysztof


