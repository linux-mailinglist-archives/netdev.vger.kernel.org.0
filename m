Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14176622A0B
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiKILRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiKILRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:17:01 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853941EE
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 03:16:59 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id z24so25247863ljn.4
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 03:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4rsVLg9MNVYcsu7j/AVDjA3CpudFe+3V/rIcx//bM/8=;
        b=B/CmR1XUEcS5WLZWLUVsjGgsF4fuXr92HkbkYKQNxq0ZqHv4kcXVa5/bwWgEDUIY5Z
         /+5gl1MCszn9Jk/348pjFi68PPnWaXHHSvlVZH7gtjqYmaDq/TzzcJTIqI5+I4JMwPmw
         LejMH2rkXFIWB+YtpkZrRHE1D3/yzthxVfF0nhGKUUvdpLcIT9OYfPPPVdbsN8ggYh6W
         +zAbKxXfWsskneRQp2FiZAvwBdiHGCTxPCaWBAYRWXANCnXHM8U7F+OwDeNrqJJt98gG
         hVjaiXXsSPVqrhw/APyr2cH28j8D9k+run4gELf3d8EuL3LfR1EUf69Y6FHGgmlFw1Fn
         0NPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4rsVLg9MNVYcsu7j/AVDjA3CpudFe+3V/rIcx//bM/8=;
        b=7yQMOVoAE8HjLG1nCL51DDkSW06FJTfLH9oQYMDmSij5fpWw+/7QRSXNQW5URamIWl
         fRw2qfHdxet9HF3uNkEXc1AAGwocythmWBxx6EnLbpmTN39AxkNxBQyvZgbR0rTYBE6M
         zEs/Me8yk7U6Zy/bscf/PyQ28/LjABihBn+wM4bfB/ChKg3Lr5vpdVv8WEnI5IGKyyXp
         K9GcPC43WySq8EVcfSJTpC7cRMTWQgDcYxBw0e8+vzPbb0mNrGY2JzE/NiLBs90MXmes
         a+D4saBDQoneAoOYXCKnoiLNZRu+FmUBwI4QoWUNP+jOl7ff+b/5X2IFeAmUGjZ/Ldvd
         jWrg==
X-Gm-Message-State: ACrzQf1VIRyDTME2mdvMJiZSD3+5UcF8DzlrbUmsfc87ojD6X4HeLxnY
        mJFX9Svwewpehq51SduUndRG8Q==
X-Google-Smtp-Source: AMsMyM6sOcBec1Du0eXhO+Yr7RRND9y3KXBX470kt/YbaN8UFxrkx/2eswIcD7gcwZsEB3IdXHxgzw==
X-Received: by 2002:a05:651c:54b:b0:277:2f02:8da8 with SMTP id q11-20020a05651c054b00b002772f028da8mr21780310ljp.73.1667992617922;
        Wed, 09 Nov 2022 03:16:57 -0800 (PST)
Received: from [192.168.0.20] (088156142199.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.199])
        by smtp.gmail.com with ESMTPSA id bp9-20020a056512158900b004b19f766b07sm2187362lfb.91.2022.11.09.03.16.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 03:16:57 -0800 (PST)
Message-ID: <953916b4-5c00-29a3-11a8-015911d23f69@linaro.org>
Date:   Wed, 9 Nov 2022 12:16:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 3/6] arm64: dts: fsd: add sysreg device node
Content-Language: en-US
To:     Vivek Yadav <vivek.2311@samsung.com>, rcsekar@samsung.com,
        krzysztof.kozlowski+dt@linaro.org, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com,
        linux-fsd@tesla.com, robh+dt@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com
References: <20221109100928.109478-1-vivek.2311@samsung.com>
 <CGME20221109100254epcas5p48c574876756f899875df8ac71464ce11@epcas5p4.samsung.com>
 <20221109100928.109478-4-vivek.2311@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221109100928.109478-4-vivek.2311@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/11/2022 11:09, Vivek Yadav wrote:
> From: Sriranjani P <sriranjani.p@samsung.com>
> 
> Add SYSREG controller device node, which is available in PERIC and FSYS0
> block of FSD SoC.
> > Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> Signed-off-by: Pankaj Kumar Dubey <pankaj.dubey@samsung.com>
> Cc: devicetree@vger.kernel.org
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>

Drop Cc list from commit msgs. Instead use get_maintainers.pl.

> Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
> ---
>  arch/arm64/boot/dts/tesla/fsd.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/tesla/fsd.dtsi b/arch/arm64/boot/dts/tesla/fsd.dtsi
> index f35bc5a288c2..3d8ebbfc27f4 100644
> --- a/arch/arm64/boot/dts/tesla/fsd.dtsi
> +++ b/arch/arm64/boot/dts/tesla/fsd.dtsi
> @@ -518,6 +518,16 @@
>  				"dout_cmu_fsys1_shared0div4";
>  		};
>  
> +		sysreg_peric: system-controller@14030000 {
> +			compatible = "tesla,sysreg_peric", "syscon";
> +			reg = <0x0 0x14030000 0x0 0x1000>;

Put it next  to the other system-controller node (and ordered by unit
address against it).

Best regards,
Krzysztof

