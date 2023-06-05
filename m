Return-Path: <netdev+bounces-7863-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38139721E36
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27CEF281124
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 06:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61C5E382;
	Mon,  5 Jun 2023 06:36:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA1D194
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:36:33 +0000 (UTC)
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2593DF1
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 23:36:31 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-97668583210so366450966b.1
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 23:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685946989; x=1688538989;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2DzCC5nNj9v724sBHpzIo/I7iRoYP7iyXhmHfz9Pk7Y=;
        b=EfGxmQgBDHTK3j0dd8RNyLsGK1duhmTxBU8B3HBUvpPxlCuH5uWRWAxz7HvXZCq524
         jwQ2hCHnyKGWaP+VcXdHo8XVXue7aJTSH7pKErryvBtVqaVmXOgsjmA61C+/XMBvyXuI
         XpazGattWkNXMdKUK31h68OPYWLUhgNRVtpCNO6l8nTJzLZp/4Hz9cQdGYhRySi5fCh+
         iHwasAxQMWf4whFDhyfjmRyufJ+tObicaoV78hGCqWie2UEBKUngjNKqNycneMm2GZ+a
         esgYE7DDocfsBeYkJ/Ydl4NmbHxvGf0d08XzDVNqqdsVrXIxa4vi9P++2Uuryl2FP/lE
         2TmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685946989; x=1688538989;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2DzCC5nNj9v724sBHpzIo/I7iRoYP7iyXhmHfz9Pk7Y=;
        b=XxYFoPcOnTQD3lpW9Ht/mg3JCPLqQ6TrJ006fMBL1oaTgruW2Yrb0m8AtkAyg4ZLCz
         RPc+Y/8FVrl8QtgICaVezDHLHYPs9EiDgl7Y7M38w5Ur+547HeYzj8+NhcpelyPJ9cIQ
         h8xNEAWk1q6YK9zPkaeViK29DnUiv/lDexagEcNmv+r9F2gow4WbwrK5Su7bR+fr6y+g
         f2SLCgFxc4P/vkCE92mOu+8YfQecAu293z5zUi6fD7qi/sqpPJZYrdODwPjyDw9Xlvw2
         dN2Rj7yIYw33ETW1ZKtwlL/bqBiu6hgL26FSjDssoGwTBp6ds09hM/L5/sLaudnxeSCx
         MYsw==
X-Gm-Message-State: AC+VfDy79S5LZXaGzGytoYauWWmgdtaOotpqrA3TMLYYsESOrCUgSZi9
	mWUNuXb3+RQXBIgt813t79ZpbQ==
X-Google-Smtp-Source: ACHHUZ6d00GdMTR6aAxeVElkl0mxPzjdle9Lbahv1I4pFtz6RO6KSMrZET+M4yBitY9jdcpIUHeAuA==
X-Received: by 2002:a17:906:5d09:b0:974:1c91:a752 with SMTP id g9-20020a1709065d0900b009741c91a752mr6371767ejt.5.1685946989561;
        Sun, 04 Jun 2023 23:36:29 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id y11-20020a17090668cb00b00977eb9957e9sm145894ejr.128.2023.06.04.23.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jun 2023 23:36:29 -0700 (PDT)
Message-ID: <3b776a90-add5-f870-b20d-0b1bf9b05bc8@linaro.org>
Date: Mon, 5 Jun 2023 08:36:25 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 03/21] dt-bindings: usb: generic-ehci: Document
 clock-names property
Content-Language: en-US
To: Varshini Rajendran <varshini.rajendran@microchip.com>,
 tglx@linutronix.de, maz@kernel.org, robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
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
 <20230603200243.243878-4-varshini.rajendran@microchip.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230603200243.243878-4-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 03/06/2023 22:02, Varshini Rajendran wrote:
> Document the property clock-names in the schema.
> 
> It fixes the dtbs_warning,
> 'clock-names' does not match any of the regexes: 'pinctrl-[0-9]+'

You cut too much from the warning. Which target/board?

> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> ---
>  Documentation/devicetree/bindings/usb/generic-ehci.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/usb/generic-ehci.yaml b/Documentation/devicetree/bindings/usb/generic-ehci.yaml
> index 7e486cc6cfb8..542ac26960fc 100644
> --- a/Documentation/devicetree/bindings/usb/generic-ehci.yaml
> +++ b/Documentation/devicetree/bindings/usb/generic-ehci.yaml
> @@ -102,6 +102,10 @@ properties:
>          - if a USB DRD channel: first clock should be host and second
>            one should be peripheral
>  
> +  clock-names:
> +    minItems: 1
> +    maxItems: 4

Not really, because we want them to be fixed, so you need to list the
items. But it seems this is not needed at all... which boards and
drivers use names?


Best regards,
Krzysztof


