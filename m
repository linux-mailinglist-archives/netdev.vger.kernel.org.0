Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F4E666E71
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 10:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239943AbjALJlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 04:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239955AbjALJkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 04:40:43 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AC21BE89
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 01:37:19 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id jo4so43334507ejb.7
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 01:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lipiQg+uY4xDOD4O2Ee0KGbRPD+b+ApBwEUjybcB87s=;
        b=kNICJHQaOgIqlkwm6tfaCkuNuC+stQGxM8kMGgixBndptAwdXyywHV1nb1TlQCgjHf
         cHPK4DylNfGyPl+UVbwSzywCe+0F2o/uyfjT8oTMfqvDJcshQoIwReKr1afzhj2GG0td
         0OaSsVMn9y7zCr2PN9U78HEuCzIg69Ht6Yvse+k9lPQew4QGFq3AESWltxRWMUJmKy0v
         UkcdjEqsoM8a0weM+OLKFLu+nW9JWW7aMhy8VKtnWkbJfF0eE+5xjeMtDA1HVb0x52S7
         7waRD1ewic6M1RFBs1OgbKPeDpD3dkU6pa8u3p1IYL3QZUTS92CYXkDZq0nN6my5FkRK
         7V+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lipiQg+uY4xDOD4O2Ee0KGbRPD+b+ApBwEUjybcB87s=;
        b=s1+apZ/f72Sx8UEkMg3z9sUZfxqbaEj2fCZucjrfrOknHpveF7LXjqzH0lbqfzoRgk
         aHy1GEvRtC6rAh7aLlpFLVrE0dyQsEaOGp+phXYPQvUb9+jmZv59YXUgG2CJEmrxTGht
         tX26agXI50S4GTvHcnTpZZQdmpWwrKrILkUqbYgYcjw75pmev65U+pRNwpBYKL1EDhaD
         xKQsohD+O9w6O4CFL+kaBd8egzPffGf41JDtQxHbKSQ7FycDnnpNtRAdn8oYAa47OVF8
         DZ9ABWrzhD8qPHpgfGShaD24nR6uWu/KUe4DtAI/dRi8oaNfXt1P1uO28+cudAShH1oC
         gbcg==
X-Gm-Message-State: AFqh2kqX9tn4pjNdCsJNtgLQy4dA3m/iKjl7eXZ4evcgnFzA+AWUjKrM
        1f7r9tWRlMW0jrVlIHr20GebZg==
X-Google-Smtp-Source: AMrXdXvKLUtCslDkplodzN/U9ppVUuh8+J2xPIKgWLCVwcuElM3F+sZP9NFmaSDUX/VmXkPxFVK96g==
X-Received: by 2002:a17:907:d68b:b0:7c1:691a:6d2c with SMTP id wf11-20020a170907d68b00b007c1691a6d2cmr86414643ejc.7.1673516238137;
        Thu, 12 Jan 2023 01:37:18 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id p4-20020a170906614400b008512e1379dbsm3736393ejl.171.2023.01.12.01.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 01:37:17 -0800 (PST)
Message-ID: <7d74a96e-e3a5-118c-04a9-e8ed95fffa54@linaro.org>
Date:   Thu, 12 Jan 2023 10:37:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 4/4] arm64: dts: fsd: Add Ethernet support for PERIC
 Block of FSD SoC
Content-Language: en-US
To:     Sriranjani P <sriranjani.p@samsung.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        alexandre.torgue@foss.st.com, peppe.cavallaro@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, pankaj.dubey@samsung.com,
        alim.akhtar@samsung.com, ravi.patel@samsung.com,
        Jayati Sahu <jayati.sahu@samsung.com>
References: <20230111075422.107173-1-sriranjani.p@samsung.com>
 <CGME20230111075455epcas5p1951d1981f15d252e09281621ef5fbf15@epcas5p1.samsung.com>
 <20230111075422.107173-5-sriranjani.p@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230111075422.107173-5-sriranjani.p@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/01/2023 08:54, Sriranjani P wrote:
> The FSD SoC contains two instances of Synopsys DWC QoS Ethernet IP, one in
> FSYS0 block and other in PERIC block.
> 
> Adds device tree node for Ethernet in PERIC Block and enables the same for
> FSD platform.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Signed-off-by: Jayati Sahu <jayati.sahu@samsung.com>
> Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
> ---
>  arch/arm64/boot/dts/tesla/fsd-evb.dts      |  9 ++++
>  arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi | 56 ++++++++++++++++++++++
>  arch/arm64/boot/dts/tesla/fsd.dtsi         | 29 +++++++++++
>  3 files changed, 94 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/tesla/fsd-evb.dts b/arch/arm64/boot/dts/tesla/fsd-evb.dts
> index ca0c1a28d562..2c0cbe775e04 100644
> --- a/arch/arm64/boot/dts/tesla/fsd-evb.dts
> +++ b/arch/arm64/boot/dts/tesla/fsd-evb.dts
> @@ -39,6 +39,15 @@
>  	};
>  };
>  
> +&ethernet_1 {
> +	status = "okay";
> +
> +	fixed-link {
> +		speed = <1000>;
> +		full-duplex;
> +	};
> +};
> +
>  &fin_pll {
>  	clock-frequency = <24000000>;
>  };
> diff --git a/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi b/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
> index 7ccc0738a149..c955bf159786 100644
> --- a/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
> +++ b/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
> @@ -395,6 +395,62 @@
>  		samsung,pin-pud = <FSD_PIN_PULL_UP>;
>  		samsung,pin-drv = <FSD_PIN_DRV_LV1>;
>  	};
> +
> +	eth1_tx_clk: eth1-tx-clk-pins {
> +		samsung,pins = "gpf2-0";
> +		samsung,pin-function = <FSD_PIN_FUNC_2>;
> +		samsung,pin-pud = <FSD_PIN_PULL_DOWN>;
> +		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
> +	};
> +
> +	eth1_tx_data: eth1-tx-data-pins {
> +		samsung,pins = "gpf2-1", "gpf2-2", "gpf2-3", "gpf2-4";
> +		samsung,pin-function = <FSD_PIN_FUNC_2>;
> +		samsung,pin-pud = <FSD_PIN_PULL_UP>;
> +		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
> +	};
> +
> +	eth1_tx_ctrl: eth1-tx-ctrl-pins {
> +		samsung,pins = "gpf2-5";
> +		samsung,pin-function = <FSD_PIN_FUNC_2>;
> +		samsung,pin-pud = <FSD_PIN_PULL_UP>;
> +		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
> +	};
> +
> +	eth1_phy_intr: eth1-phy-intr-pins {
> +		samsung,pins = "gpf2-6";
> +		samsung,pin-function = <FSD_PIN_FUNC_2>;
> +		samsung,pin-pud = <FSD_PIN_PULL_UP>;
> +		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
> +	};
> +
> +	eth1_rx_clk: eth1-rx-clk-pins {
> +		samsung,pins = "gpf3-0";
> +		samsung,pin-function = <FSD_PIN_FUNC_2>;
> +		samsung,pin-pud = <FSD_PIN_PULL_UP>;
> +		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
> +	};
> +
> +	eth1_rx_data: eth1-rx-data-pins {
> +		samsung,pins = "gpf3-1", "gpf3-2", "gpf3-3", "gpf3-4";
> +		samsung,pin-function = <FSD_PIN_FUNC_2>;
> +		samsung,pin-pud = <FSD_PIN_PULL_UP>;
> +		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
> +	};
> +
> +	eth1_rx_ctrl: eth1-rx-ctrl-pins {
> +		samsung,pins = "gpf3-5";
> +		samsung,pin-function = <FSD_PIN_FUNC_2>;
> +		samsung,pin-pud = <FSD_PIN_PULL_UP>;
> +		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
> +	};
> +
> +	eth1_mdio: eth1-mdio-pins {
> +		samsung,pins = "gpf3-6", "gpf3-7";
> +		samsung,pin-function = <FSD_PIN_FUNC_2>;
> +		samsung,pin-pud = <FSD_PIN_PULL_UP>;
> +		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
> +	};
>  };
>  
>  &pinctrl_pmu {
> diff --git a/arch/arm64/boot/dts/tesla/fsd.dtsi b/arch/arm64/boot/dts/tesla/fsd.dtsi
> index ade707cc646b..8807055807dd 100644
> --- a/arch/arm64/boot/dts/tesla/fsd.dtsi
> +++ b/arch/arm64/boot/dts/tesla/fsd.dtsi
> @@ -33,6 +33,7 @@
>  		spi1 = &spi_1;
>  		spi2 = &spi_2;
>  		eth0 = &ethernet_0;
> +		eth1 = &ethernet_1;

Nope for the reasons I explained last time.

>  	};
>  
>  	cpus {
> @@ -882,6 +883,34 @@
>  			phy-mode = "rgmii";
>  			status = "disabled";
>  		};
> +
> +		ethernet_1: ethernet@14300000 {

Do not add nodes to the end.

Best regards,
Krzysztof

