Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDF2619A04
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbiKDOdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiKDOdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:33:00 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8103F47336
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 07:31:09 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id w10so3299172qvr.3
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 07:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pBEKtj5T51f51CFIMJKfn028IX//LL9SvX54Zm0sOzQ=;
        b=huln3VTRqH40TTYCIhJlLVIbHkAjYz7JTpT0SHEwv67xquAm1j5E97Q544rPicCSXJ
         gQt3KdXOo1FiEAHNo28RgFRlBrGYzgNG2mCqikNvRqKADpwMj3Xg8G+iAujSzs/CDoZs
         KZii5uPcl1dmmnDjBbPo3TDiU1QphkMy9QLKhHEn92B5OU7PcN+uf4b9Nz/dlJGS40ao
         ubwiQzE5MnQ9vSkK6Q7IfxAIv8oH+1s8kJiBh3D2XrWzbfiDzwl4mYHyeKhciYXp4Ccj
         cR11qCXMQJv3wqTT/romNLLI9MnAbonWvr+ErDWNzsPWSKURZRF9WG+ZYsrgnts77mxp
         2yIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pBEKtj5T51f51CFIMJKfn028IX//LL9SvX54Zm0sOzQ=;
        b=lapr7uIIGSXylmq+T/EGjUjp/6XBuCRttoxIpWuHvbDdO2cZ9fRm/9zJw4Q2zWI1+D
         5wnFK7YF+QIUAiQhjf7OyvACJ0pc+sD+y/0iBRehWttMXHl2wtP9J08vLnn3jeBxH44G
         TAMC9QRO3+sVRV9BIqac5FFXsGw02oS/sm0vAd3IYKrl+CntPwrGagEQnvZ66Hwk6Pol
         OPflCa1BjgKAFC0JCvv+PK6pT4rNUq3VxQZxzQyd+Hmfnlp43IDzDfAZnoQsUdlz9P1P
         d8+alb+fW1h5bNpGnT8HnOKM/HyGOw/kI+bWPf3tJon2rp+fOKPMuv+smzOHJPpWLJyV
         0wfQ==
X-Gm-Message-State: ACrzQf2arW7PUuOotPtG5mWSSq+WY0oJolmrYWWgotgqOW5FfUNEgLSX
        fyMhDnv1A5obdo+mMuOpx8t38A==
X-Google-Smtp-Source: AMsMyM4wiC2zozB/6Px2gKa4h3gl5XX9R2SJ2Zc19cUdIM6gD1nDY6IPvfAwdLFijOz2B7PVsKsEYw==
X-Received: by 2002:a0c:e2c8:0:b0:4b7:c1bf:784a with SMTP id t8-20020a0ce2c8000000b004b7c1bf784amr32688535qvl.17.1667572268294;
        Fri, 04 Nov 2022 07:31:08 -0700 (PDT)
Received: from ?IPV6:2601:586:5000:570:aad6:acd8:4ed9:299b? ([2601:586:5000:570:aad6:acd8:4ed9:299b])
        by smtp.gmail.com with ESMTPSA id 8-20020ac85748000000b0039ee562799csm2626891qtx.59.2022.11.04.07.31.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 07:31:08 -0700 (PDT)
Message-ID: <50814a5b-03d3-95b4-ab14-bfd19adae52b@linaro.org>
Date:   Fri, 4 Nov 2022 10:31:06 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v7 5/5] ARM: dts: qcom: ipq4019: Add description
 for the IPQESS Ethernet controller
Content-Language: en-US
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
References: <20221104142746.350468-1-maxime.chevallier@bootlin.com>
 <20221104142746.350468-6-maxime.chevallier@bootlin.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221104142746.350468-6-maxime.chevallier@bootlin.com>
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

On 04/11/2022 10:27, Maxime Chevallier wrote:
> The Qualcomm IPQ4019 includes an internal 5 ports switch, which is
> connected to the CPU through the internal IPQESS Ethernet controller.
> 
> Add support for this internal interface, which is internally connected to a
> modified version of the QCA8K Ethernet switch.
> 
> This Ethernet controller only support a specific internal interface mode
> for connection to the switch.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
> V6->V7:
>  - No Changes
> V5->V6:
>  - Removed extra blank lines
>  - Put the status property last
> V4->V5:
>  - Reword the commit log
> V3->V4:
>  - No Changes
> V2->V3:
>  - No Changes
> V1->V2:
>  - Added clock and resets
> 
>  arch/arm/boot/dts/qcom-ipq4019.dtsi | 44 +++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
> index b23591110bd2..5fa1af147df9 100644
> --- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
> +++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
> @@ -38,6 +38,7 @@ aliases {
>  		spi1 = &blsp1_spi2;
>  		i2c0 = &blsp1_i2c3;
>  		i2c1 = &blsp1_i2c4;
> +		ethernet0 = &gmac;

Hm, I have doubts about this one. Why alias is needed and why it is a
property of a SoC? Not every board has Ethernet enabled, so this looks
like board property.

I also wonder why do you need it at all?

Best regards,
Krzysztof

