Return-Path: <netdev+bounces-7869-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FEFA721E63
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:42:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B2FA281035
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 06:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A245254;
	Mon,  5 Jun 2023 06:42:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BA7194
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:42:51 +0000 (UTC)
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9CBB1
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 23:42:28 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-51456392cbbso11667281a12.0
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 23:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685947346; x=1688539346;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vFw4uIz1GvEPa5VtIcDxiD4XJ3vhhZ6UEG438lv36YM=;
        b=W5xargHLQHNwYY/BnnxPytOTujf6MiU4BCQ/YXjlMWkaYtaUQG0NSplDIhFjXr0XEp
         NSft2WQf8bMITNkiAuu729nudJ74n5JdDUc/OeUcnwViYaKf3/Nevt5YgWDTnUxVSMBx
         rjri7/Ra4Ir1cwK5nDOIpEk5Y2gz4yFKe4vqZJju72bHDKkWS6B8Uj/GaDPxHTUYQhpB
         ujkytVet/pXu5rl4n7BJWLI69+ym763ejgSzEpYBBDDesAPcCI0gQ1pFWCJVVqgUiTQe
         gnvXgo0hFD4CZBmF2bdsQwJyfV2dz6sbHjMwUkF8jbTzisH5ithvqVV7xk6WuA7O1sFA
         PE6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685947346; x=1688539346;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vFw4uIz1GvEPa5VtIcDxiD4XJ3vhhZ6UEG438lv36YM=;
        b=GJIhyddNp2SLDiKnjY81vTPYYuwIhq7p2XB/NhlLU+qadeULrY1wH4Qg87JVML5hJz
         /uXBhExyklsYcpFLSeiKQRjm+W/5JkpUh1G45uePF7MRQ4nG6qcrPI/5+MPct5J4F0GI
         w1riFanfuxBjl3fludIFcMsyfllpXawFcGpfqqx7UdL7NH+JN6SJJLGqHNwFgB0lLqOH
         LBff0hPiztvLDOAc7XEPMs4tAIpjRXz3XrL+2N09DhDurKYYjbZ/A5LPg4QwENeRaUJG
         N25Z+BrZPtml+VohgckZUCWf0NkZqZ7BG58CV5PfBWwyljiY3CH4w1lkdl4cCrGDq5Oa
         YtDA==
X-Gm-Message-State: AC+VfDysE73LIhKyvpC1DGntXF6DXlZdF/VhzkAtdzy3B2RDRY+4uyup
	YxJVjmBK/SZr+C2xWbQURZn1S4F4YBLtECvb0DY=
X-Google-Smtp-Source: ACHHUZ45Bczqm3lVsRw49KlK7A65vT6wgUhxPgXPoYV2Y2gF9onThQgLUhtAYX+cEbSh2I+U4voMhQ==
X-Received: by 2002:a05:6402:354c:b0:506:71bd:3931 with SMTP id f12-20020a056402354c00b0050671bd3931mr9594965edd.2.1685947346132;
        Sun, 04 Jun 2023 23:42:26 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id g7-20020aa7c847000000b0051498be5f3csm3661348edt.38.2023.06.04.23.42.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jun 2023 23:42:25 -0700 (PDT)
Message-ID: <7a29a03b-4f2a-35b6-a033-9f4fbe1232d0@linaro.org>
Date: Mon, 5 Jun 2023 08:42:23 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 20/21] dt-bindings: net: cdns,macb: add documentation for
 sam9x7 ethernet interface
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
 <20230603200243.243878-21-varshini.rajendran@microchip.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230603200243.243878-21-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 03/06/2023 22:02, Varshini Rajendran wrote:
> Add documentation for sam9x7 ethernet interface
> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> ---
>  Documentation/devicetree/bindings/net/cdns,macb.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
> index bef5e0f895be..e4f9e9b353e5 100644
> --- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
> +++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
> @@ -54,6 +54,7 @@ properties:
>            - cdns,np4-macb             # NP4 SoC devices
>            - microchip,sama7g5-emac    # Microchip SAMA7G5 ethernet interface
>            - microchip,sama7g5-gem     # Microchip SAMA7G5 gigabit ethernet interface
> +          - microchip,sam9x7-gem      # Microchip SAM9X7 gigabit ethernet interface

No wildcards in compatibles.

Best regards,
Krzysztof


