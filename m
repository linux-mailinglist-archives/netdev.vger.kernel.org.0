Return-Path: <netdev+bounces-11803-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6B67347B1
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 20:47:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B32721C20828
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 18:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A8E749F;
	Sun, 18 Jun 2023 18:47:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8F33D74
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 18:47:14 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5762DF
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 11:47:12 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-51a426e4f4bso3019855a12.1
        for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 11:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687114031; x=1689706031;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2hab+VindhIOG0MIUDS0WqXLDAI9UcPdnEWEsRW9fqc=;
        b=ZM/AisTFRxQG6THFbpFj/rf7+PFQtOf3iKCt0TX0vBuKInKVxU6SQDMqBWoBvQodmk
         YOfDmL2hHDXRiRVyDzMS67QL/v1n8uDJF836+WH9tfaWoVJ4joWl1JttiSnnPNrG3HuY
         9oBaGRKxWBBzut7ITbCxsBTzFkjdaa89+Cwc5wbG05jBUJVMt55yQvr+VhtDBY8hOLIK
         j+2KktXJTTUauqXO933Ws/O7LlIp/LBDv9m1vIGiu69qDpcp8aibwCDA2xZ1WEjTpVw2
         bhWcKJJ7ooNXA+sY13+VmIE1iPVqDtQ/+d0iee+jfKz0w+xFvD5hV65bbxmaz02Rt4+d
         rADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687114031; x=1689706031;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2hab+VindhIOG0MIUDS0WqXLDAI9UcPdnEWEsRW9fqc=;
        b=J4N7WBVCrt+Hd2XiuHAaDUedfyR4j0SXzQIivrg1qKrDcHmeM2ANOdEPcSuwnFpHEA
         99Bsx4TP5dQNjIgR5MoniqEOKX+RJF3Z5gtm/2UzrRMwb5XaZDxmSKDo1UwD0PHV6fcZ
         XBQN8LETfyOhRQ6SVrdlV89X0uNrgUeCgJiHZILlblrr2oeW9qedv6hu1zhCx7+hK69n
         Qn/DUxxG/RkN+8A74vghgxKdT7d1MNnaqIeW38t5ejGa9tB5PT7mttfV6NhZihqZVFM7
         BFXQrgYA+er0CxqB05OrTCvVIKmTWcs3Gz4aHKrxDY+igk1DPFFmVhHrmk3CvjlY+1Kq
         WScw==
X-Gm-Message-State: AC+VfDxelId0P85IXix/Gde0yG1pTf/4jDu0lFQrXumQ/oUn5jI3ze1+
	0PKfd9a6QHjpN8Zclr+yWsyPuw==
X-Google-Smtp-Source: ACHHUZ4/1pQ31Dnx/F8V/OARE1r0jXPs8y2FLx7mi/eQ9jEw6dIHfl6LoHV08X/SgkAqP7hdTKkwbw==
X-Received: by 2002:a17:907:2d28:b0:96a:3e39:f567 with SMTP id gs40-20020a1709072d2800b0096a3e39f567mr8911168ejc.47.1687114030722;
        Sun, 18 Jun 2023 11:47:10 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id kq17-20020a170906abd100b0098885494649sm928632ejb.128.2023.06.18.11.47.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jun 2023 11:47:10 -0700 (PDT)
Message-ID: <254978f3-3bf3-7cf5-e2b7-69d413acf092@linaro.org>
Date: Sun, 18 Jun 2023 20:47:07 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/4] dt-bindings: intel: Add Intel Agilex5 compatible
To: niravkumar.l.rabara@intel.com, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
 Dinh Nguyen <dinguyen@kernel.org>,
 Michael Turquette <mturquette@baylibre.com>, Stephen Boyd
 <sboyd@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>,
 Wen Ping <wen.ping.teh@intel.com>, Richard Cochran
 <richardcochran@gmail.com>, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
 netdev@vger.kernel.org, Adrian Ng Ho Yin <adrian.ho.yin.ng@intel.com>
References: <20230618132235.728641-1-niravkumar.l.rabara@intel.com>
 <20230618132235.728641-2-niravkumar.l.rabara@intel.com>
Content-Language: en-US
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230618132235.728641-2-niravkumar.l.rabara@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 18/06/2023 15:22, niravkumar.l.rabara@intel.com wrote:
> From: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
> 
> Add new compatible for Intel Agilex5 based boards.
> 
> Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
> ---
>  Documentation/devicetree/bindings/arm/intel,socfpga.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/intel,socfpga.yaml b/Documentation/devicetree/bindings/arm/intel,socfpga.yaml
> index 4b4dcf551eb6..28849c720314 100644
> --- a/Documentation/devicetree/bindings/arm/intel,socfpga.yaml
> +++ b/Documentation/devicetree/bindings/arm/intel,socfpga.yaml
> @@ -20,6 +20,7 @@ properties:
>                - intel,n5x-socdk
>                - intel,socfpga-agilex-n6000
>                - intel,socfpga-agilex-socdk
> +              - intel,socfpga-agilex5-socdk
>            - const: intel,socfpga-agilex

This is agilex5, not agilex. Why are you using the same SoC compatible?
You have entire commit msg to explain your hardware and avoid such
questions...

Best regards,
Krzysztof


