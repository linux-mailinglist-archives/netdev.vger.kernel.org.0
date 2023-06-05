Return-Path: <netdev+bounces-7862-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4992721E2C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:35:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C0A51C20B38
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 06:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CFDA194;
	Mon,  5 Jun 2023 06:35:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5389D382
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:35:15 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68193DA
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 23:35:13 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-5151934a4e3so6558686a12.1
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 23:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685946912; x=1688538912;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HAkCrvHOWXDqwj1iMGZRedd16rhqvqKQgu07G0b3u+w=;
        b=e7E3JztSPDwCFOVrzxyEbVKg2EBeBOYgZaTU4BRpwJs1h7uHWXDo+l4Zk5OwWH3gxO
         EqYoWrI2nluRnjKjwdlqLEnBcCpOkMVsq/NL07i8ATGoappT2Y7Iu+bHCO+sxDx/d6PF
         m1yW2VgipEcnRLFaW68NCN+FFcFIJPbw/eYHR3Y07vtSoQ9V57ZsG/OrkuBfp0zcE7uO
         mUMJdZb3Ktm56WuGjYfV4znaUsZVjWccpeON3w72rzjU7HO+wQmcEKdi3vZPb9spMHEO
         MAxQO8sclY35BjwjlYS1iRkx51Kv62cQ0tFvY3zdkd4n9Jlo0VDzxWWtcb/m129XFaB6
         19jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685946912; x=1688538912;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HAkCrvHOWXDqwj1iMGZRedd16rhqvqKQgu07G0b3u+w=;
        b=ZtgH3JClrLdOVjlNyYh/RNkL8i8kqz4jN7yuyZb9Mnz5RfKGJ4Miif+H0RVHEDkKd5
         T/O4ylKya59kE1G6C25Qo+SdNpHdR+nehBnS8/hh3LjhfLa8/tX7VBHCeAX5wHIKhCqc
         rat1ExvyuWk0W+vgk4wsExmZ42yeFLuIAKvzHM1UsSuZKwY5U09FFbf+lGPlTDtbxRjl
         rvVhmuCKOxC5Y4Qk9Feht+J9IYgZpqm68/NKiIcASjgFoT1A2umTn3tluysH5gSzieq+
         0TT7F024GlJct1DBiW9p9eFiHjSNTw+pJHQ/YpFT0vOh+ZgITIWtJf3Ipfq/qTigR4Z0
         X/EA==
X-Gm-Message-State: AC+VfDxlFCK+PpUNVOxUH6sWHvnhFfxKTeVrllb3UqtfIFQ7sEoDNdJj
	aMeMiFwYfqc3pVrgKKd2dm96CA==
X-Google-Smtp-Source: ACHHUZ4BgooRJqWw2thRF8QqkzdRcCJ+hGa1VmZ7YEgpaG6Ikj580m9cbKbqSO9oirFRyquUlSnLew==
X-Received: by 2002:aa7:cd10:0:b0:513:53f7:8ca2 with SMTP id b16-20020aa7cd10000000b0051353f78ca2mr6734317edw.9.1685946911857;
        Sun, 04 Jun 2023 23:35:11 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id v1-20020aa7dbc1000000b005163a0f84a1sm3636951edt.48.2023.06.04.23.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jun 2023 23:35:11 -0700 (PDT)
Message-ID: <c72f45ec-c185-8676-b31c-ec48cd46278c@linaro.org>
Date: Mon, 5 Jun 2023 08:35:07 +0200
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
 <20230603200243.243878-2-varshini.rajendran@microchip.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230603200243.243878-2-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 03/06/2023 22:02, Varshini Rajendran wrote:
> Add sam9x60 compatible string support in the schema file
> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> ---
>  .../devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml  | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml b/Documentation/devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml
> index a46411149571..c70c77a5e8e5 100644
> --- a/Documentation/devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml
> +++ b/Documentation/devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml
> @@ -20,6 +20,7 @@ properties:
>            - atmel,at91rm9200-tcb
>            - atmel,at91sam9x5-tcb
>            - atmel,sama5d2-tcb
> +          - microchip,sam9x60-tcb

No wildcards.

Best regards,
Krzysztof


