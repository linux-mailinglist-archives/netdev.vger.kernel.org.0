Return-Path: <netdev+bounces-6705-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 495207177AA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:18:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02ABF281337
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:18:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42928A93D;
	Wed, 31 May 2023 07:18:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FB2946F
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:18:21 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC72113
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:18:19 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-96f5685f902so812065566b.2
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685517498; x=1688109498;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3fFyLFhsggW8A8YrdnWJOLOkpBJdZswSLetiahcSr+o=;
        b=nq5BILXY39XcNsBRsD2kWVG5orno9JOxYhk4t+GDnNTRUVCPzXs8ooW5khrP5OTSfy
         8eCpk5H3JQM+Unpj0y2Ptw9lFeFhzGjkZ3dTF4s7JGwJQIuOoggO4NBNVkQ/GfhJRxqp
         jm+IUQ+XTpSc9ntDj6Rsh7e2r5mcMP4Y69CmHc9oIEjt2I99eF0pwQPjfgD6RbRx2LFL
         6zTv7baCYCzXhab6ZJEpUD5ooUyXewlHlZAGNiK+f+2z9+IMSXF2+xJWv2JLp6asjncw
         OaWcvCsa83CoSA3GtlLWO3rm2gKc5IGAz6nmvEt9LebW8PIfHrIA+iw+dNCWe++UJ5rt
         cFkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685517498; x=1688109498;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3fFyLFhsggW8A8YrdnWJOLOkpBJdZswSLetiahcSr+o=;
        b=SmBmHfRwQog7sHxp92R6lvpCHC+hBrzBgWNSDTpHueXgMR9QO6AZvMsoUmVoOg4/h1
         B706NMXpwj0/uo7vPjUoQHbEqTME2VLy47xtK/L3booyY9AYfCIwAAm7a+WkK7YbXgvx
         650VsqDi5rWFFC3Dgjv7kJ8+dCWKLJvVXB9smfkXtTx/4bSPxnvxkrQna4h4fzd6M1nF
         Kcrz+r4J0M1PR2gLm+moZa8plyVDuqSGFA3TDDqMH6epkbbQGBsZL0so572V4XUdnBxL
         cLX8E0MrJQfNy4YvDWWXG+fDEYQiPbIqSwWmCxSR0K3djHudCvz175qO6PlLBoWAxDVy
         lAmw==
X-Gm-Message-State: AC+VfDzNSbRsBPxD9QaG+0X1FS8bKFxkPndwv8H29BexCnvIeZyq1z4P
	Y0JjlNDP2xcDdPs13o6uDrhDlJJED1ZQePEVj5mkHw==
X-Google-Smtp-Source: ACHHUZ45JXthOqFQmjKUFzygujKR44SA7fO7b6Z6A+/RQ0o3szCpXKFF3BbHPhOInNc6o5VRNCBlGA==
X-Received: by 2002:a17:907:3e28:b0:96a:3811:f589 with SMTP id hp40-20020a1709073e2800b0096a3811f589mr5536703ejc.10.1685517497980;
        Wed, 31 May 2023 00:18:17 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.199.204])
        by smtp.gmail.com with ESMTPSA id u20-20020aa7db94000000b00502689a06b2sm5203661edt.91.2023.05.31.00.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 00:18:17 -0700 (PDT)
Message-ID: <fb3de5a5-4477-ec8d-eb2c-e00813f078a0@linaro.org>
Date: Wed, 31 May 2023 09:18:15 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v3 1/2] dt-bindings: net: cdns,macb: Add
 rx-watermark property
Content-Language: en-US
To: Pranavi Somisetty <pranavi.somisetty@amd.com>, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org, nicolas.ferre@microchip.com,
 claudiu.beznea@microchip.com
Cc: git@amd.com, michal.simek@amd.com, harini.katakam@amd.com,
 radhey.shyam.pandey@amd.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20230530095138.1302-1-pranavi.somisetty@amd.com>
 <20230530095138.1302-2-pranavi.somisetty@amd.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230530095138.1302-2-pranavi.somisetty@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 30/05/2023 11:51, Pranavi Somisetty wrote:
> watermark value is the minimum amount of packet data
> required to activate the forwarding process. The watermark
> implementation and maximum size is dependent on the device
> where Cadence MACB/GEM is used.
> 
> Signed-off-by: Pranavi Somisetty <pranavi.somisetty@amd.com>
> ---
> Changes v2:
> None (patch added in v2)
> 
> Changes v3:
> 1. Fixed DT schema error: "scalar properties shouldn't have array keywords".
> 2. Modified description of rx-watermark to include units of the watermark value.
> 3. Modified the DT property name corresponding to rx_watermark in
> pbuf_rxcutthru to "cdns,rx-watermark".
> 4. Modified commit description to remove references to Xilinx platforms,
> since the changes aren't platform specific.
> --- 
>  Documentation/devicetree/bindings/net/cdns,macb.yaml | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
> index bef5e0f895be..2c733c061dce 100644
> --- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
> +++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
> @@ -109,6 +109,14 @@ properties:
>    power-domains:
>      maxItems: 1
>  
> +  cdns,rx-watermark:
> +    $ref: /schemas/types.yaml#/definitions/uint16
> +    description:
> +      Set watermark value for pbuf_rxcutthru reg and enable
> +      rx partial store and forward. Watermark value here
> +      corresponds to number of SRAM locations. The width of SRAM is
> +      system dependent and can be 4,8 or 16 bytes.

You described device programming model - registers - not the actual
hardware.

Best regards,
Krzysztof


