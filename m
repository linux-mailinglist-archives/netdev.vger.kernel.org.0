Return-Path: <netdev+bounces-7868-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA094721E60
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:42:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2602A1C20ABC
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 06:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B955254;
	Mon,  5 Jun 2023 06:42:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A8C5388
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:42:17 +0000 (UTC)
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC71E67
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 23:41:44 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-977cc662f62so199461866b.3
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 23:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685947301; x=1688539301;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ES4QwZGNTqaGDHkT5g+vUXHwRybmHm+v/fVuOTJ+7nY=;
        b=zvVD+Qymqy+NcNPO08oupjqv+659xgLwRbW2xE7uEMe5qvtSExF/OpeShP9JAzUcl+
         NV0nE0NP873VpH1gnyDpAVAtzyPjw1/2FE4TIw4MkMytJOXU80szSd8wX38WrUVBN1Hs
         3S2BcZfkEJ18KMmG4zUNHCTKIXZDcJIXRuqTlN3W+cHPwhVHGK6Sb9CxFJpgS0V+YImr
         pCXMu9yOzKi4fCo5Qh3nZhWuLYcX4OGbmKiFk0q9/04XFkH+znzUunADVm5q2Ap7+6Jn
         C1AR9OLDsL0IvZBrDtKlPfFrDQkfTo6Zg/ha2nhoPyNSjbQcILanOw0s10R1zekKDR8/
         7DOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685947301; x=1688539301;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ES4QwZGNTqaGDHkT5g+vUXHwRybmHm+v/fVuOTJ+7nY=;
        b=ejNcB1MVgfSYfyfZLHk1d/lL7qgvRdcbwLvwEuzaNQjtJTU2KPwlOcBZ512RRHP2eg
         qJPjOTG+6Mg8S6sEzyQu7wUtFkAlYFCksoMhxd6J1Uh05hiNzOvz5x8eZruMsGcasvT/
         HzjhDnghfc1h8a4WKCD3r+iFvsOH3gvBx9DzcH/rAKQsqHc5daiwBLFeSULVIj76ECwq
         zqPUqocxcOG/mSEBuwyZejE8T0NNn9ZUoNhMP+pCcTyB4YdCbdSfHB166hPF4uLrzOy7
         hbjjKkxVWa2BUBosbAs8qUp6zFxBhJY7omJQDR/DnDU81tQEwBuu+utcdh2Pt5Hx8E7S
         c+CA==
X-Gm-Message-State: AC+VfDzFM7V08cUsuzv4IS0yiBhPSz5aoNGrxN4ffM32XkwEG1J9hdwl
	6x5T4n7Pim6OSmR7EsXYcw/i9w==
X-Google-Smtp-Source: ACHHUZ4MLkQ0TxRJYotGe0A3pkwTJOfonlJxjBPm4WV0ed3f0oPF4CbcpOdQhoL+RWTTYXC+hwB8CQ==
X-Received: by 2002:a17:907:6d28:b0:973:9337:1aac with SMTP id sa40-20020a1709076d2800b0097393371aacmr5790961ejc.60.1685947301554;
        Sun, 04 Jun 2023 23:41:41 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id jp25-20020a170906f75900b0096f675ce45csm3863114ejb.182.2023.06.04.23.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jun 2023 23:41:41 -0700 (PDT)
Message-ID: <fdf5723d-802f-21c2-3808-dcdcf1869bf4@linaro.org>
Date: Mon, 5 Jun 2023 08:41:38 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 04/21] ARM: dts: at91: sam9x7: add device tree for soc
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
 <20230603200243.243878-5-varshini.rajendran@microchip.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230603200243.243878-5-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 03/06/2023 22:02, Varshini Rajendran wrote:
> Add device tree file for SAM9X7 SoC family
> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> [nicolas.ferre@microchip.com: add support for gmac to sam9x7]
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> [balamanikandan.gunasundar@microchip.com: Add device node csi2host and isc]
> Signed-off-by: Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>
> ---
>  arch/arm/boot/dts/sam9x7.dtsi | 1333 +++++++++++++++++++++++++++++++++
>  1 file changed, 1333 insertions(+)
>  create mode 100644 arch/arm/boot/dts/sam9x7.dtsi

How do you even test it? Where are boards and their bindings?

Best regards,
Krzysztof


