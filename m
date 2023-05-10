Return-Path: <netdev+bounces-1509-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 322186FE0C3
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:48:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 556FD1C20D8D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63333154A9;
	Wed, 10 May 2023 14:48:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BD63D60
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:48:24 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE089006
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:48:15 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-9659443fb56so1138530466b.2
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683730094; x=1686322094;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f6J1at/UfOBYlhKmXRcHodshRJDkjuRkHYlvCekUlaQ=;
        b=iNDBMZ3Qo/Ta40vyO3EF+rrpA6RSS0EQpoiRnrl+XngL9Vmh01gFgTLSCxICapeEsh
         daMH8kT6BzRJ7tOiLg9BOIyFxoYPKy1UTtBs+KRujHFwX6/TpTkx5ATMWgamCvbFYylZ
         aeKI2KTncm+HdQIKHtE4wZylBYjc0wfZ8+rZiWy5W5HFuiwZg+SjV0/mWe76xGCfpDX7
         LneNP04ablGNXFUmnjKXKFWdF5NJ3h57KcmCvVto2kKeI4ELTHFaKoXNu3/oeJZR+8tb
         Rtb0J4RTHI4GRLVs7ApJvwEjff15qO/3eFmjvYFxR3bdpKaQMpB3bfWDkk0KQJGVmntA
         VaFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683730094; x=1686322094;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f6J1at/UfOBYlhKmXRcHodshRJDkjuRkHYlvCekUlaQ=;
        b=OSEnfz9yO3YHHeqJ3PZ1XMlpWW8NvGtL9cH+Lh1al98o8igTMrn6jsK+lyUzk6Y4+A
         4K7OrDbxMxO598g18/lutS14sk+KlWqZMkOrPeVnObJBsZzru/lHuoTDYj1m1/cfGQTH
         HHDfQ3laW+jJF+yOw3LVTD21nsa+LCE7QblNCsS9WIqkr3A+Gb5virK4ZDGB1XOds59U
         sskHPh0/kEGE4tH83X78Dnc3FjQ7T1aIstC7Qi0QNFdtg2riwhNHlkZnHGPUKM29/QF7
         zqtvIq7Ph6rE6sWbGTl6vP2a4NG7SWKG10nCoL8ynxlgMVSrZn0zK29cXtYj5WCPUTJ4
         cY8w==
X-Gm-Message-State: AC+VfDyC+xnzt1zg8rQ5HR152+QaziUzPZx/QZMdvC7c+rSUMVGj0YK7
	8s4vOnlN5e2y4Wpvy7EVdaxvKA==
X-Google-Smtp-Source: ACHHUZ6nlFU/rkd4wiS8p9XQtJiSjSA/y7NII5AZrzIETV3go8PONFgO0szicvwQF++ebH0pnpxuGg==
X-Received: by 2002:a17:907:8a02:b0:967:d161:61c6 with SMTP id sc2-20020a1709078a0200b00967d16161c6mr9898351ejc.3.1683730094012;
        Wed, 10 May 2023 07:48:14 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:c175:a0f9:6928:8c9d? ([2a02:810d:15c0:828:c175:a0f9:6928:8c9d])
        by smtp.gmail.com with ESMTPSA id va8-20020a17090711c800b0094f282fc29asm2693778ejb.207.2023.05.10.07.48.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 07:48:13 -0700 (PDT)
Message-ID: <6b5be71e-141e-c02a-8cba-a528264b26c2@linaro.org>
Date: Wed, 10 May 2023 16:48:12 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 3/5] dt-bindings: net: add mac-address-increment option
Content-Language: en-US
To: Ivan Mikhaylov <fr0st61te@gmail.com>,
 Samuel Mendoza-Jonas <sam@mendozajonas.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org,
 Paul Fertser <fercerpav@gmail.com>
References: <20230509143504.30382-1-fr0st61te@gmail.com>
 <20230509143504.30382-4-fr0st61te@gmail.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230509143504.30382-4-fr0st61te@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 09/05/2023 16:35, Ivan Mikhaylov wrote:
> Add the mac-address-increment option for specify MAC address taken by
> any other sources.
> 
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
> ---
>  .../devicetree/bindings/net/ethernet-controller.yaml      | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index 00be387984ac..6900098c5105 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -34,6 +34,14 @@ properties:
>      minItems: 6
>      maxItems: 6
>  
> +  mac-address-increment:
> +    $ref: /schemas/types.yaml#/definitions/int32
> +    description:
> +      Specifies the MAC address increment to be added to the MAC address.
> +      Should be used in cases when there is a need to use MAC address
> +      different from one obtained by any other level, like u-boot or the
> +      NC-SI stack.

We don't store MAC addresses in DT, but provide simple placeholder for
firmware or bootloader. Why shall we store static "increment" part of
MAC address? Can't the firmware give you proper MAC address?

Best regards,
Krzysztof


