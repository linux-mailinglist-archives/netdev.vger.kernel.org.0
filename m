Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13DC622A2A
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiKILSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiKILSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:18:21 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4160329356
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 03:18:17 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id bp15so25091078lfb.13
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 03:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GxnRxhJDAb9pUXgjx0ze3PK4gBhKnoYZaP+jiMHEIwc=;
        b=rrdf/2LQbbWL2VazpVcvioRGi2+YVTKcv/7fB9zDmCig/+yB/o4N+i/VBEALmyev/D
         YWUNg/mor6YQiUBMEMhCrinvixhmmSQn343rtWRFuxGemCJi63NJoVlsBLNNmfSnBTrI
         Ct3KzCk2GkdneiFrR7QaqaKZq3ljMlfoCyg6vRN3ZECEOw/tL/vWTgKro+RGWqFJzwrU
         J/58HiRynzLhGystfYbkhdvc4mWo1S+wch/xDppDou/zNTA5Dl9Driwr5iTpeN6btnGt
         Gu0K7ZqdnrP+mP4t+c4IHoejAxC9zPP4vM/GdgC6Jkd28IjAH2+Io5FjjPt3sxLOd+VU
         +UuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GxnRxhJDAb9pUXgjx0ze3PK4gBhKnoYZaP+jiMHEIwc=;
        b=xB0PEUltLLZZoH7wOXYBfatPWp9IQzrb2I9brih/hDMnaOT1P3Ka+qhQxhnAvW7qZ2
         cymKIBc8pUhOyvQKsNuPyWDs6RnrSf2iLCCM7RiYE7GTUJozM0v0t5Vozg44GqzvVNZf
         F4kSsAueuMDevtkN9xffnvkOLOH0+O/SVUYHo4kXRKXBB5NbZCwYzrpO7q8ysZ7h7qYF
         Ofq8nJEeSRQrLMyPgvzF4hTFNtmSY+Iv8F2qCDXSXInYUXsEB5/T6XszrxYm0aVwO/ou
         BFAcoaXdOmxUP/qccO5aQuWAqFMrT0AKiQbbV5uL1xQ1ed0FdAPdHXT0uvetalBYlMxF
         4NHA==
X-Gm-Message-State: ACrzQf2f8l8Z9XxSKfPCQOUBUJndnY9HVppr0qxdJwldDBEYv57Uzsrs
        3G4BGNU2OrtY4fJqQByqnRmVsg==
X-Google-Smtp-Source: AMsMyM6ZZpdCos9MrILyRLgHX42HfVp77qJ7plzL3OTJoGzg4oaMPAZQl3bqQNUXAAPX0C0VI99plg==
X-Received: by 2002:ac2:551c:0:b0:4a2:3c32:aff5 with SMTP id j28-20020ac2551c000000b004a23c32aff5mr22829210lfk.31.1667992695455;
        Wed, 09 Nov 2022 03:18:15 -0800 (PST)
Received: from [192.168.0.20] (088156142199.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.199])
        by smtp.gmail.com with ESMTPSA id h3-20020a197003000000b004b3b7557893sm1637970lfc.259.2022.11.09.03.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 03:18:14 -0800 (PST)
Message-ID: <6868ceb7-a274-7eb4-32b6-9e0e4eb467bf@linaro.org>
Date:   Wed, 9 Nov 2022 12:18:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 4/6] arm64: dts: fsd: Add MCAN device node
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
 <CGME20221109100258epcas5p2966d5e93e00d2a5b4e4a3096dc5a5ec6@epcas5p2.samsung.com>
 <20221109100928.109478-5-vivek.2311@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221109100928.109478-5-vivek.2311@samsung.com>
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
> Add MCAN device node and enable the same for FSD platform.
> This also adds the required pin configuration for the same.
> 
> Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
> Cc: devicetree@vger.kernel.org
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
> ---
>  arch/arm64/boot/dts/tesla/fsd-evb.dts      | 16 +++++
>  arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi | 28 +++++++++
>  arch/arm64/boot/dts/tesla/fsd.dtsi         | 68 ++++++++++++++++++++++
>  3 files changed, 112 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/tesla/fsd-evb.dts b/arch/arm64/boot/dts/tesla/fsd-evb.dts
> index 1db6ddf03f01..af3862e9fe3b 100644
> --- a/arch/arm64/boot/dts/tesla/fsd-evb.dts
> +++ b/arch/arm64/boot/dts/tesla/fsd-evb.dts
> @@ -34,6 +34,22 @@
>  	clock-frequency = <24000000>;
>  };
>  
> +&m_can0 {
> +	status = "okay";
> +};
> +
> +&m_can1 {
> +	status = "okay";
> +};
> +
> +&m_can2 {
> +	status = "okay";
> +};
> +
> +&m_can3 {
> +	status = "okay";
> +};
> +
>  &serial_0 {
>  	status = "okay";
>  };
> diff --git a/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi b/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
> index d0abb9aa0e9e..bb5289ebfef3 100644
> --- a/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
> +++ b/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
> @@ -339,6 +339,34 @@
>  		samsung,pin-pud = <FSD_PIN_PULL_UP>;
>  		samsung,pin-drv = <FSD_PIN_DRV_LV1>;
>  	};
> +
> +	m_can0_bus: m-can0-bus-pins {
> +		samsung,pins = "gpd0-0", "gpd0-1";
> +		samsung,pin-function = <FSD_PIN_FUNC_2>;
> +		samsung,pin-pud = <FSD_PIN_PULL_UP>;
> +		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
> +	};
> +
> +	m_can1_bus: m-can1-bus-pins {
> +		samsung,pins = "gpd0-2", "gpd0-3";
> +		samsung,pin-function = <FSD_PIN_FUNC_2>;
> +		samsung,pin-pud = <FSD_PIN_PULL_UP>;
> +		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
> +	};
> +
> +	m_can2_bus: m-can2-bus-pins {
> +		samsung,pins = "gpd0-4", "gpd0-5";
> +		samsung,pin-function = <FSD_PIN_FUNC_2>;
> +		samsung,pin-pud = <FSD_PIN_PULL_UP>;
> +		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
> +	};
> +
> +	m_can3_bus: m-can3-bus-pins {
> +		samsung,pins = "gpd0-6", "gpd0-7";
> +		samsung,pin-function = <FSD_PIN_FUNC_2>;
> +		samsung,pin-pud = <FSD_PIN_PULL_UP>;
> +		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
> +	};
>  };
>  
>  &pinctrl_pmu {
> diff --git a/arch/arm64/boot/dts/tesla/fsd.dtsi b/arch/arm64/boot/dts/tesla/fsd.dtsi
> index 3d8ebbfc27f4..154fd3fc5895 100644
> --- a/arch/arm64/boot/dts/tesla/fsd.dtsi
> +++ b/arch/arm64/boot/dts/tesla/fsd.dtsi
> @@ -765,6 +765,74 @@
>  			interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
>  		};
>  
> +		m_can0: can@14088000 {
> +			compatible = "bosch,m_can";
> +			reg = <0x0 0x14088000 0x0 0x0200>,
> +				<0x0 0x14080000 0x0 0x8000>;

Align with < in line before.

> +			reg-names = "m_can", "message_ram";
> +			interrupts = <GIC_SPI 159 IRQ_TYPE_LEVEL_HIGH>,
> +					<GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupt-names = "int0", "int1";
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&m_can0_bus>;
> +			clocks = <&clock_peric PERIC_MCAN0_IPCLKPORT_PCLK>,
> +				<&clock_peric PERIC_MCAN0_IPCLKPORT_CCLK>;

The same (unless it's the problem of diff/patch and these are actually
aligned).


Best regards,
Krzysztof

