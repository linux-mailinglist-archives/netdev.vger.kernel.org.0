Return-Path: <netdev+bounces-8029-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83448722780
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:34:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF7561C20B9E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72FCB1C778;
	Mon,  5 Jun 2023 13:34:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6640F134BE
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:34:35 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6761F7
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:34:32 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-977e7d6945aso102001366b.2
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 06:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685972071; x=1688564071;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5rq3Widh6hOEiY5YdsfneGamzIlwkE0sJ5k3vngcFSc=;
        b=H1IHNMyQRtp1DX11ax4fGQWgXmX7bBwuCedLwUTO/0JImjrcWQ7PGrGucaNUYW9QWq
         OUft8vP7ux3whhgItsECM02LirXUQBIyB6Ybw9GTQC2z3G1v9H7yKm7biLhmZQAmiF84
         fxrMtDdPeYmoM9gROxzDXjylvVQydkQmK7fvG5bBtrNELPq2EFtAbWquJc67We1IWHvV
         HBU8TNQWja6X0MwKURm6oaVdSzqmJN6qbm5yOpZarC2wmli/OIP6zZ1esJivH5vJaiA4
         ODag4hmmTEijO9vsz5QmSXv3wxbgmkd1Lx74f0Zmt6RoBg/OR/6gQJp/fxXMXcaHcn+1
         nWLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685972071; x=1688564071;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5rq3Widh6hOEiY5YdsfneGamzIlwkE0sJ5k3vngcFSc=;
        b=NcMSrgIbBVsF752vRV1kjuQLRUVu4x4ANGLh9hLdI+GG4+yu6MWMbJTPBKZGY/bmeW
         ENKpGoJ8AiGFc3RQ22pK4h0uD4J7FsvYjLwgSrRatcWv1mwvBOXwVOyi4Lp1mY6Ng50K
         K9PlmtIWsjfK8J51XcyKvkMrdVlROZTy/TxCcUUzAnTNIW8vvmvMib2+nBCf9aVvw4ab
         KPXwqbV1ek4zIlW9uB+vS6t3TSKOOvPa2vPe5NBfPInoz6APYGZjnmR9WLAoK5DC/okO
         KxhnLAjPPCxrg6e/2938GpptT0TdJVIIYTkQyrDDUh5D+cO5RwFGgvOfKnmmJqE2Cgat
         EN0A==
X-Gm-Message-State: AC+VfDyDzdsArNCt86Pc4mu+S7IyJ2vzvIOwvx3ReVTVvtkq//VN5psN
	mkSNxXdVdqkGSMR2Shq896h6LA==
X-Google-Smtp-Source: ACHHUZ7s745giAKDDO4doxV94noEtK/FRaEwLZP9MaulFyeyXHe/0hxRLNnut3NFVjxtd4jewVlWpA==
X-Received: by 2002:a17:907:848:b0:974:61dc:107c with SMTP id ww8-20020a170907084800b0097461dc107cmr6376623ejb.44.1685972071027;
        Mon, 05 Jun 2023 06:34:31 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id g19-20020a170906869300b0097461a7ebdcsm4251734ejx.82.2023.06.05.06.34.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 06:34:30 -0700 (PDT)
Message-ID: <9b8a4221-beac-4394-8d71-a9060d4457f1@linaro.org>
Date: Mon, 5 Jun 2023 15:34:26 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 21/21] net: macb: add support for gmac to sam9x7
Content-Language: en-US
To: Nicolas Ferre <nicolas.ferre@microchip.com>,
 Varshini Rajendran <varshini.rajendran@microchip.com>, tglx@linutronix.de,
 maz@kernel.org, robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
 conor+dt@kernel.org, alexandre.belloni@bootlin.com,
 claudiu.beznea@microchip.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, gregkh@linuxfoundation.org,
 linux@armlinux.org.uk, mturquette@baylibre.com, sboyd@kernel.org,
 sre@kernel.org, broonie@kernel.org, arnd@arndb.de,
 gregory.clement@bootlin.com, sudeep.holla@arm.com,
 balamanikandan.gunasundar@microchip.com, mihai.sain@microchip.com,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-clk@vger.kernel.org,
 linux-pm@vger.kernel.org
Cc: Hari.PrasathGE@microchip.com, cristian.birsan@microchip.com,
 durai.manickamkr@microchip.com, manikandan.m@microchip.com,
 dharma.b@microchip.com, nayabbasha.sayed@microchip.com,
 balakrishnan.s@microchip.com
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-22-varshini.rajendran@microchip.com>
 <be3716e0-383f-e79a-b441-c606c0e049df@linaro.org>
 <3e262485-bf5f-1a98-e399-e02add3eaa89@microchip.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <3e262485-bf5f-1a98-e399-e02add3eaa89@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05/06/2023 14:07, Nicolas Ferre wrote:
> On 05/06/2023 at 08:42, Krzysztof Kozlowski wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> On 03/06/2023 22:02, Varshini Rajendran wrote:
>>> From: Nicolas Ferre <nicolas.ferre@microchip.com>
>>>
>>> Add support for GMAC in sam9x7 SoC family
>>>
>>> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
>>> ---
>>>   drivers/net/ethernet/cadence/macb_main.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>>> index 29a1199dad14..609c8e9305ba 100644
>>> --- a/drivers/net/ethernet/cadence/macb_main.c
>>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>>> @@ -4913,6 +4913,7 @@ static const struct of_device_id macb_dt_ids[] = {
>>>        { .compatible = "microchip,mpfs-macb", .data = &mpfs_config },
>>>        { .compatible = "microchip,sama7g5-gem", .data = &sama7g5_gem_config },
>>>        { .compatible = "microchip,sama7g5-emac", .data = &sama7g5_emac_config },
>>> +     { .compatible = "microchip,sam9x7-gem", .data = &sama7g5_gem_config },
>>
>> These are compatible, aren't they? Why do you need new entry?
> 
> The hardware itself is different, even if the new features are not 
> supported yet in the macb driver.
> The macb driver will certainly evolve in order to add these features so 
> we decided to match a new compatible string all the way to the driver.

You claim to be fully compatible with sama7g5-gem, so adding new
features does not warrant not-reusing old match entry now.

Best regards,
Krzysztof


