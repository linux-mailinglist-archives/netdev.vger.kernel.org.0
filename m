Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16993695C77
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 09:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjBNIMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 03:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjBNIMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 03:12:42 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B0E5249
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 00:12:41 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id o36so10399861wms.1
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 00:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KDJqF/S7FJyy4sENVnOnHXPZ0qWf81BHpxaC1cbZwNM=;
        b=h+TobcQc/AS73YyAUYypTZ92YDFfJx5plIpPRuf1sCayLM1JFXkW8a4EsA4LEKCCFy
         K4fOUEtpDcFPGfu7bdNPsKbbZTKUEUOLKYVW9gj6G/IgtZb6KWi4BGwhLxoGOSzueVHB
         AW+bteyQI3BLdeSiq2g5GzWi5K5SE3ForGuAL4ehR5lYyKXwS9m9fHb5Ql9xOZ3eDdxX
         VSXXpiIxVICQz+al2alOiF/Uo7SlUXGYuYG/H0QFZTbQ9gW39DhLFTJK1PywsWMZpZKl
         YGE+hVKIvYPjr/Wwq6FkgNVCrpJ6iApUiiXfqWrxBblk873u37cWzUQzbWgte5EoWZuF
         vPCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KDJqF/S7FJyy4sENVnOnHXPZ0qWf81BHpxaC1cbZwNM=;
        b=oieC3Jsh8FW3Kwf/rlXkrJ9Qk5rsSJ9EcT0EDGygm1ZqXvTYL9sXPoVTQSNXk5LtuV
         LvEf3vWU9CpidDeJkuL0GM7oBqdFzfiKqOEgTwplg2bZOPZs1WveOYOgWMElZ+LTJ+vl
         BUJKE/4vQVr4KZigPXbQtlQGXxEeHDH8pTVFuI8mVV6wbzqNxEtGOnev9rTkpv6ur/vg
         2n1rI6YHQw4Qi0SRDNHqkQFcuhGunCoClvs7Gq//YEFFFbWIjCKTqrOvpq3BwUNz/aLm
         cOb7lFls2Uy0rImDHo6C5v5AhpdwKW7ZN4Bg7TLYfUYpNtW/RQfK7Z7rSBtsg2iFmku7
         FTLw==
X-Gm-Message-State: AO0yUKX6hcokoXk/HajzmdwIp1rY9yBLjdYDm8Lm0rj/HmDYuKq2Ks24
        oSWytWDDygTiCEoRjl3woQWWlA==
X-Google-Smtp-Source: AK7set/3m2O3fzpBarIh8LFCm08d+49Vr3SGx5eMH/PPNTdNeEpUL1CagISoFFBO/wWosFNGaRlncQ==
X-Received: by 2002:a05:600c:747:b0:3dc:438a:c381 with SMTP id j7-20020a05600c074700b003dc438ac381mr1279174wmn.28.1676362359773;
        Tue, 14 Feb 2023 00:12:39 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id m24-20020a05600c3b1800b003dc41a9836esm18101194wms.43.2023.02.14.00.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 00:12:39 -0800 (PST)
Message-ID: <e4c33665-179b-8bf4-f7eb-38f86dceda56@linaro.org>
Date:   Tue, 14 Feb 2023 09:12:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 2/2] arm64: dts: imx8dxl-evk: Fix eqos phy reset gpio
Content-Language: en-US
To:     Andrew Halaney <ahalaney@redhat.com>, devicetree@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        linux-imx@nxp.com, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com, mripard@kernel.org,
        shenwei.wang@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20230213213104.78443-1-ahalaney@redhat.com>
 <20230213213104.78443-2-ahalaney@redhat.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230213213104.78443-2-ahalaney@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/02/2023 22:31, Andrew Halaney wrote:
> The property is named snps,reset-gpio. Update the name accordingly so
> the corresponding phy is reset.
> 
> Fixes: 8dd495d12374 ("arm64: dts: freescale: add support for i.MX8DXL EVK board")
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
> ---
>  arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
> index 1bcf228a22b8..b6d7c2526131 100644
> --- a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
> +++ b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
> @@ -121,7 +121,7 @@ &eqos {
>  	phy-handle = <&ethphy0>;
>  	nvmem-cells = <&fec_mac1>;
>  	nvmem-cell-names = "mac-address";
> -	snps,reset-gpios = <&pca6416_1 2 GPIO_ACTIVE_LOW>;
> +	snps,reset-gpio = <&pca6416_1 2 GPIO_ACTIVE_LOW>;

I don't think it's correct change. This property is deprecated. Also
uses old, deprecated suffix gpio.

Best regards,
Krzysztof

