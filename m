Return-Path: <netdev+bounces-7887-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F448721FA4
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:34:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA3E4280F25
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A45CC2DE;
	Mon,  5 Jun 2023 07:34:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060D5AD3D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:34:40 +0000 (UTC)
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC0ACA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 00:34:38 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-514ab6cb529so11717091a12.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 00:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685950477; x=1688542477;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8g/uCudoNru8NUO2fRncIkM8apZtWaRSA3Sr+dRP0vE=;
        b=EZqnx3qFRzHckRGwu64NGFgrgksidmNU1uyIQBt8oEIuivVfPmQQm2nf+4hU2lw/iP
         1RnUU91boWEi92AIWXrVDRMKsf80YofR1suYBsd/Fh7jgN3vq3oi+e0GOve1rJlCOnYD
         ikUKL7snfLrifOPTbfuyEMtcWzU4tpJqOpLlIuxSzwxo7gDnZjAy4tgm1ZhSXoEoJhfi
         O/L42N6w2VrH4KG42Ck/GUYtS3ru2VgfcC0u37bz9U2vS0y2zCHEyOSH+zkOWwMTMO3C
         pgDe8kPdWaMNjqVxVX4vD5cDv3zKdgiTnURbLu7hBWruQBn1ChoKt4prNtdvXB33umNT
         0ORg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685950477; x=1688542477;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8g/uCudoNru8NUO2fRncIkM8apZtWaRSA3Sr+dRP0vE=;
        b=MuFc8kixm4Ivt5W0W8wu22jk+kvF/3GZ+CLeKjJhnWk9iV4ryrDQyw5gWOIq8S9M2Q
         ijHosSisT/OaQj4qrs6r/mYh8dKpgoiClI0BpVrnR1x4CeZnEjeSIGGaGXIvhyXQa7+m
         B3bFJxRQZsP0kA16D41eGlM+4hjFKi9jYTaIajzmxzCUTNq4QrgsgVBC5Icj3x4z2Wkj
         L4GSBE7dEBfKpePqmuOzga+2wPnARL1MiKhrlrlMyGPbALGD26nAJCgaVYTnx2PS4If7
         U8Mib9xKuqFGMX2gMkANni4Os5pO8Zy/U1QOcyL/jhm9/GzXa/WS/qDmXfg9CaA0P4i6
         ST9w==
X-Gm-Message-State: AC+VfDze51aT9RTYz3+63RhZNUNB3pL+FKrWnYlTZc+46ZqA+tsdSz76
	/9+U6XCCkftY6Sq3LggA3IypOw==
X-Google-Smtp-Source: ACHHUZ6O0Ax8DYnAnWLCNsurzFRYdg0Bla791PJzJB/LCSFqUBdwOYwfakFHXzUGj5RgB1RVZModzA==
X-Received: by 2002:a17:907:16a6:b0:977:c405:6c76 with SMTP id hc38-20020a17090716a600b00977c4056c76mr5497706ejc.14.1685950476974;
        Mon, 05 Jun 2023 00:34:36 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id j21-20020a170906431500b00966265be7adsm3910219ejm.22.2023.06.05.00.34.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 00:34:36 -0700 (PDT)
Message-ID: <d4509ee4-3eb7-0499-36f8-7d7848ab4928@linaro.org>
Date: Mon, 5 Jun 2023 09:34:32 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 01/21] dt-bindings: microchip: atmel,at91rm9200-tcb: add
 sam9x60 compatible
To: Arnd Bergmann <arnd@arndb.de>,
 Varshini Rajendran <varshini.rajendran@microchip.com>,
 Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <maz@kernel.org>,
 Rob Herring <robh+dt@kernel.org>, krzysztof.kozlowski+dt@linaro.org,
 Conor Dooley <conor+dt@kernel.org>,
 Nicolas Ferre <nicolas.ferre@microchip.com>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Claudiu Beznea <claudiu.beznea@microchip.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Russell King <linux@armlinux.org.uk>,
 Michael Turquette <mturquette@baylibre.com>, Stephen Boyd
 <sboyd@kernel.org>, Sebastian Reichel <sre@kernel.org>,
 Mark Brown <broonie@kernel.org>,
 Gregory Clement <gregory.clement@bootlin.com>,
 Sudeep Holla <sudeep.holla@arm.com>,
 Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>,
 "Mihai.Sain" <mihai.sain@microchip.com>, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Hari.PrasathGE@microchip.com, cristian.birsan@microchip.com,
 durai.manickamkr@microchip.com, manikandan.m@microchip.com,
 dharma.b@microchip.com, nayabbasha.sayed@microchip.com,
 balakrishnan.s@microchip.com
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-2-varshini.rajendran@microchip.com>
 <c72f45ec-c185-8676-b31c-ec48cd46278c@linaro.org>
 <d95d37f5-5bef-43a9-b319-0bbe0ac366b4@app.fastmail.com>
Content-Language: en-US
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <d95d37f5-5bef-43a9-b319-0bbe0ac366b4@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05/06/2023 09:04, Arnd Bergmann wrote:
> On Mon, Jun 5, 2023, at 08:35, Krzysztof Kozlowski wrote:
>> On 03/06/2023 22:02, Varshini Rajendran wrote:
>>> Add sam9x60 compatible string support in the schema file
>>>
>>> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
>>> ---
>>>  .../devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml  | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml b/Documentation/devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml
>>> index a46411149571..c70c77a5e8e5 100644
>>> --- a/Documentation/devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml
>>> +++ b/Documentation/devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml
>>> @@ -20,6 +20,7 @@ properties:
>>>            - atmel,at91rm9200-tcb
>>>            - atmel,at91sam9x5-tcb
>>>            - atmel,sama5d2-tcb
>>> +          - microchip,sam9x60-tcb
>>
>> No wildcards.
> 
> sam9x60 is the actual name of the chip, it's no wildcard. For sam9x70,
> sam9x72 and sam9x75, I think using sam9x7 as the compatible string
> is probably fine, as long as they are actually the same chip. Again,
> the 'x' in there is not a wildcard but part of the name.

OK, if that's the case.

Best regards,
Krzysztof


