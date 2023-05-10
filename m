Return-Path: <netdev+bounces-1413-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 505476FDB55
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B94D1C20D06
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB2F6FD5;
	Wed, 10 May 2023 10:08:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A6A20B4E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 10:08:47 +0000 (UTC)
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024A4CC
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:08:46 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-50bc25f0c7dso12921817a12.3
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683713324; x=1686305324;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jvB4fpU8+So5VWO8ax0y0Ffp0LarCBg3hyDsYVyRDvs=;
        b=cuJm4LR/uVjYQO2u1k1ggNHX/xrJraHzGQ+vB6zB14LymvptbbR9cV0lrlSG9Kg0+T
         bU3FQaWGHw0v1wBPJAnuvaQ/VAAPn7Hd8bLjOUdE2fn2uB92qi8cGHplgNVNdyNCl1To
         LbqWGBz8LHhlNwxgnhnALptjwdZkVYSRXS7z0Jj7KzdZqcWO3AZh3s72oVT5oMVOI3hF
         AdxdCkoDhsH2mNjQpE3mzkD97LXWlu/hEVuITTpSR4+sDkP8ZGnd9iDh7CixyjXOqk1O
         jWzeoaNsVAMOGKeO+uJ5u5YDSRO6s3mlDJiszAyVK6392DL2xNWN0mSKOXAwBJ41gtHf
         7xsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683713324; x=1686305324;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jvB4fpU8+So5VWO8ax0y0Ffp0LarCBg3hyDsYVyRDvs=;
        b=XhjdnYv6J4E4i4cvQRo3V2FPVTznp+9QgdM+RtUDws7PSWDKqSHBMPisaKDHCcKWnB
         aPvNfhJrAm3duthdrs8cEwmBCwCPbSlLCNjEh4u9/gj3xr0HQhnRNQ8MCCJLscciyABT
         jH/8XN4P5ivxCgi4EzmkGzxLKbeAE3xWzDm4j40fL5tqViXDdP24fPIPOOt68/D7jSes
         2ozigzpzf2xCI/Qj93QDWa5XfJ91drikonyWhBGqX3Q3yBJw0rnE/Ldg3ka6gVv+gsaX
         pVTNqIpDdm7tMju0Drrz6Ulb5yYvONgSx565nY/oL1OJ9yLQXrZJyAziEOatXH3lQ9Jd
         KWhA==
X-Gm-Message-State: AC+VfDzOyqDq9C3lR9rFYGDAMHeAzu29H/z0gk+KAHB9WkRY4QMIx/EF
	p/yYwc444psKAa47EazLXYmK2w==
X-Google-Smtp-Source: ACHHUZ6IH9XailMZy2rKRP+9vQEskj9TsR2DXWiq2j6Y56PQOUOUTPxnNJqZrydw1sMMrTb2B7kfDQ==
X-Received: by 2002:a05:6402:216:b0:50b:bfee:ea26 with SMTP id t22-20020a056402021600b0050bbfeeea26mr11863642edv.35.1683713324445;
        Wed, 10 May 2023 03:08:44 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:c175:a0f9:6928:8c9d? ([2a02:810d:15c0:828:c175:a0f9:6928:8c9d])
        by smtp.gmail.com with ESMTPSA id w15-20020a50fa8f000000b0050d89daaa70sm1707195edr.2.2023.05.10.03.08.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 03:08:43 -0700 (PDT)
Message-ID: <95f61847-2ec3-a4e0-d277-5d68836f66cf@linaro.org>
Date: Wed, 10 May 2023 12:08:42 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next V3 1/3] dt-bindings: net: xilinx_axienet:
 Introduce dmaengine binding support
Content-Language: en-US
To: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org
Cc: linux@armlinux.org.uk, michal.simek@amd.com, radhey.shyam.pandey@amd.com,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 anirudha.sarangi@amd.com, harini.katakam@amd.com, git@amd.com
References: <20230510085031.1116327-1-sarath.babu.naidu.gaddam@amd.com>
 <20230510085031.1116327-2-sarath.babu.naidu.gaddam@amd.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230510085031.1116327-2-sarath.babu.naidu.gaddam@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 10/05/2023 10:50, Sarath Babu Naidu Gaddam wrote:
> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> 
> The axiethernet driver will use dmaengine framework to communicate
> with dma controller IP instead of built-in dma programming sequence.

Subject: drop second/last, redundant "bindings". The "dt-bindings"
prefix is already stating that these are bindings.

Actually also drop "dmaenging" as it is Linuxism. Focus on hardware,
e.g. "Add DMA support".

> 
> To request dma transmit and receive channels the axiethernet driver uses
> generic dmas, dma-names properties.
> 
> Also to support the backward compatibility, use "dmas" property to
> identify as it should use dmaengine framework or legacy
> driver(built-in dma programming).
> 
> At this point it is recommended to use dmaengine framework but it's
> optional. Once the solution is stable will make dmas as
> required properties.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
> ---
> These changes are on top of below txt to yaml conversion discussion
> https://lore.kernel.org/all/20230308061223.1358637-1-sarath.babu.naidu.gaddam@amd.com/#Z2e.:20230308061223.1358637-1-sarath.babu.naidu.gaddam::40amd.com:1bindings:net:xlnx::2caxi-ethernet.yaml
> 
> Changes in V3:
> 1) Reverted reg and interrupts property to  support backward compatibility.
> 2) Moved dmas and dma-names properties from Required properties.
> 
> Changes in V2:
> - None.
> ---
>  .../devicetree/bindings/net/xlnx,axi-ethernet.yaml   | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
> index 80843c177029..9dfa1976e260 100644
> --- a/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
> +++ b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
> @@ -122,6 +122,16 @@ properties:
>        modes, where "pcs-handle" should be used to point to the PCS/PMA PHY,
>        and "phy-handle" should point to an external PHY if exists.
>  
> +  dmas:
> +    items:
> +      - description: TX DMA Channel phandle and DMA request line number
> +      - description: RX DMA Channel phandle and DMA request line number
> +
> +  dma-names:
> +    items:
> +      - const: tx_chan0

tx

> +      - const: rx_chan0

rx

Why doing these differently than all other devices?


Best regards,
Krzysztof


