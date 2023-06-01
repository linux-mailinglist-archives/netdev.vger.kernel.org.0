Return-Path: <netdev+bounces-7168-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6367371EFAD
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:52:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E60F3281734
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1264F21CED;
	Thu,  1 Jun 2023 16:52:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0723E156F0
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:52:36 +0000 (UTC)
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE3A196
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:52:24 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2af24ee004dso15535411fa.0
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 09:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685638343; x=1688230343;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cv5o48CpGTaTmkSqmSGB6JrLPZbZffPhXroyECMP20Q=;
        b=dK2zE69rNsGt4bXTMWMxq6bZpD4cU/x1vn4XebDWEoyqfWByDSis5f5x5GGv4KO6+g
         B+FkzBs6FLdaaLN183dNIA96rVI5Kzag0fh8EugZ5FurJHNO/MwMye+IcB4vb1hIHsRV
         q1+Uau405GRgsgxsByoJgmnJACabUg9vPnQBfz9vtnbQiTiEtWB6MoHLDz7LUyRHm9+1
         DwKobSv0MjAJ+TlLpEN3pyvRUZXb23HNRa7tQe88t8gq2Eo/iVfo4PegSVzC8fRDa7dZ
         gMtLNuqAvIOS8aRLs7GsGHEJwnJIV1/4y8GwjlFi459jLzGr5gsmz9I7H1xLmg0DAZeg
         dWPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685638343; x=1688230343;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cv5o48CpGTaTmkSqmSGB6JrLPZbZffPhXroyECMP20Q=;
        b=FMCm7Zbfn/ExE/DSeOpx3ZKVuO6TX5/ij7IKHj6im+6UmHkoSdJFKlXoMI7xnossDO
         v+IBAg2YDZMLF64J33n6Gyzr4TVZexA+V3U9ziZqteGnMAJbm6od5vmPZcCMLWE0QeQN
         w2oWHbwW8pA1fgfNVmFKae8nYaeUijEufSdyiwMuhycE9zm0rZxzvnkdeZWcNetCSc0g
         2zaTgyh938eJlbiJhKsqMhnC/3+sVFnPTjCEaes9Av3r7wHo7MclP6ozsMYbtwL4sn9y
         0HPd9/mCwvt+is3G9lOqJQT3e9WTsmQQk89i4d8EA0YnfeVToOcXp+4ZGnjzglioPBVd
         47Qw==
X-Gm-Message-State: AC+VfDyaZrN0xBPDZZMhYrx5mPrMlqaEOURUvV5S0Rggp60QObl3DZgX
	rC3TQlWNAdlqzg/blfre6z60kkEWjKRTPnQOFMc=
X-Google-Smtp-Source: ACHHUZ45xf+TTk2bM1U0IxRDaisGc8GzwSlvqbxUDojASZ12tvMvve9++CtLVgt3KkKUeuYY89L//A==
X-Received: by 2002:a2e:b043:0:b0:2af:1807:9e6 with SMTP id d3-20020a2eb043000000b002af180709e6mr7081ljl.35.1685638342869;
        Thu, 01 Jun 2023 09:52:22 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.199.204])
        by smtp.gmail.com with ESMTPSA id fi13-20020a170906da0d00b0096fbc516a93sm10668583ejb.211.2023.06.01.09.52.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 09:52:22 -0700 (PDT)
Message-ID: <5f5f6412-f466-9a3f-3ec7-aa45ab0049c6@linaro.org>
Date: Thu, 1 Jun 2023 18:52:18 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 1/2] dt-bindings: net: phy: Support external PHY xtal
Content-Language: en-US
To: Detlev Casanova <detlev.casanova@collabora.com>,
 Andrew Lunn <andrew@lunn.ch>
Cc: linux-kernel@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <linux@armlinux.org.uk>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
 netdev@vger.kernel.org, devicetree@vger.kernel.org
References: <20230531150340.522994-1-detlev.casanova@collabora.com>
 <ade45bcf-c174-429a-96ca-d0ffb41748d4@lunn.ch> <6646604.lOV4Wx5bFT@arisu>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <6646604.lOV4Wx5bFT@arisu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 31/05/2023 20:00, Detlev Casanova wrote:
>>> +  clock-names:
>>> +    items:
>>> +      - const: xtal
>>
>> I don't think xtal is the best of names here. It generally is used as
>> an abbreviation for crystal. And the commit message is about there not
>> being a crystal, but an actual clock.
>>
>> How is this clock named on the datasheet?
> 
> In the case of the PHY I used (RTL8211F), it is EXT_CLK. But this must be 
> generic to any (ethernet) PHY, so using ext_clk to match it would not be
> good either.
> 
> Now this is about having an external clock, so the ext_clk name makes sense in 
> this case.
> 
> I'm not pushing one name or another, let's use what you feel is more natural.

Just drop the name.

Best regards,
Krzysztof


