Return-Path: <netdev+bounces-6406-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B10977162FB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:04:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 002BB1C20BE4
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D0A21072;
	Tue, 30 May 2023 14:04:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7531A1993C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:04:09 +0000 (UTC)
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9218DE8
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:04:07 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-96fd3a658eeso650338566b.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685455446; x=1688047446;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kAaRAHBvmn5TiFi21og9H3c8Ufuxifop3fwjLkOCVes=;
        b=Aek8BtY/hryhXWGyso4A1d8LRPMyM1i6oQXslgfxRZnF8cAliqg5ePF4ytNdN3E+o6
         WmS0KpTrdb3r9/kUbqLGU09/wzgYaICG31s/pkSXtBRptvvmnm0O3TN+lcBEOJfNyQJw
         Jyo2qk66nTv4MIvWjps71q6cdC0XZ5627vivMGlIpQg4f2iwaUCKoZOPqxJSEA+cUqme
         7SLaLmXWpBAVoIJTMzfnNHlWJ7YVzvolgK82JIQUgFSaHUaikPkTgbkYT3r1izuzCR9C
         75Yr1WaVTrV4AvNAMD1ft0m7sL8mFg0r8vukhZyV6EL86xe1Oxzd2StmJY2OC4/ZSeUv
         gjig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685455446; x=1688047446;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kAaRAHBvmn5TiFi21og9H3c8Ufuxifop3fwjLkOCVes=;
        b=c9sivpePHSugyp3x0xMm7I2mlbhqEDFGjOuJyKiqLABVr7JWXjVTGjXMHH6tVOovPy
         2zIikN47f66JhXYQn0GsqxcsNQoxjbA5REr/+a2eEu5ZFyGPD00fDOXmBb9ZwklJ0oVl
         F6O6Xeqqhh1R13jlp0jwUfLzCLrwSgYcG02//Tp055IIZgzywIvlVNcYCzdFPtTdgM7f
         5jW2HYaet0DUTYiraOXuOXNjVOtRzTc1kDFPCveRq0ItUuumVlUE2Io5zuS1eJP2xF6M
         Gae4vxVKHfhFAbz8g0l4jLQfFXBeK4Uf1A/h9Pdju2C6EP7W4DHpGKOmEnEw3Dpwb111
         etSw==
X-Gm-Message-State: AC+VfDwfHak/mv94GqDTbKaEekhFBcmBUysvFcFdNt9NbIgjAVNwo2eK
	fKIL6rutBcKEs/hK3ioP31Y77Q==
X-Google-Smtp-Source: ACHHUZ5eqKSA0S3xLv0PuDvXBu0UeK4GkplmqjpmtXOP8+/T/kVFZMGqkpaNHjXSCThrWsX2lB2TYQ==
X-Received: by 2002:a17:907:724b:b0:958:4c75:705e with SMTP id ds11-20020a170907724b00b009584c75705emr2423155ejc.17.1685455446007;
        Tue, 30 May 2023 07:04:06 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.199.204])
        by smtp.gmail.com with ESMTPSA id x15-20020a170906148f00b00969f13d886fsm7439467ejc.71.2023.05.30.07.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 07:04:05 -0700 (PDT)
Message-ID: <1cce5a11-f182-04b0-0aa3-ed27614a564d@linaro.org>
Date: Tue, 30 May 2023 16:04:03 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 1/3] dt-bindings: net: pse-pd: Update regex pattern for
 ethernet-pse nodes
To: Oleksij Rempel <o.rempel@pengutronix.de>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Rob Herring <robh+dt@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
 netdev@vger.kernel.org
References: <20230530083713.2527380-1-o.rempel@pengutronix.de>
 <20230530083713.2527380-2-o.rempel@pengutronix.de>
Content-Language: en-US
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230530083713.2527380-2-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 30/05/2023 10:37, Oleksij Rempel wrote:
> This patch modifies the regex pattern for the $nodename property in the

Please do not use "This commit/patch", but imperative mood. See longer
explanation here:
https://elixir.bootlin.com/linux/v5.17.1/source/Documentation/process/submitting-patches.rst#L95

> device tree bindings documentation for PSE-PD controllers. The updated
> pattern allows for additional node names, including those with a hyphen
> followed by a hexadecimal digit.
> 
> Before this change, the pattern ^ethernet-pse(@.*)?$ only allowed for
> node names like "ethernet-pse" or "ethernet-pse@1". With the new pattern
> node names like "ethernet-pse-1" are now also valid.

This part is duplicating first paragraph. What you should have here is
answer to why we need it.

> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/pse-pd/pse-controller.yaml          | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/pse-pd/pse-controller.yaml b/Documentation/devicetree/bindings/net/pse-pd/pse-controller.yaml
> index b110abb42597..3548efc2191c 100644
> --- a/Documentation/devicetree/bindings/net/pse-pd/pse-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/pse-pd/pse-controller.yaml
> @@ -16,7 +16,7 @@ maintainers:
>  
>  properties:
>    $nodename:
> -    pattern: "^ethernet-pse(@.*)?$"
> +    pattern: "^ethernet-pse(@[0-9a-f]+|-([0-9a-f]+))?$"

No need for inner ()

Let's make -N suffix only decimal, as discussed here:
https://lore.kernel.org/all/20221123024153.GB1026269-robh@kernel.org/

I will send a patch for other files.

>  
>    "#pse-cells":
>      description:

Best regards,
Krzysztof


