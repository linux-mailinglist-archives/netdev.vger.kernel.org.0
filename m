Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89C56835F6
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 20:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbjAaTBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 14:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbjAaTBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 14:01:45 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C3F58993
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:01:44 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id j29-20020a05600c1c1d00b003dc52fed235so5845673wms.1
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0f5n/Bb4ZQ3NDjDGqKckIUS2qUmXXS6bLtvGcaKg4v8=;
        b=cdxfXqElRety6rvzIlwBfnO/C4WBsJWfZ8jeoyrmxufbaHUFP6RWEQ2bt8peHS2CHX
         V9yTNKUbAe98kiY413wXqlUwG/VEsW2YgmWauruCyeEo+k8zCoZPL2o9Po8Nqorxq1sk
         XN1prF/g5v1Akd25JmZdQplSN5X3HRvfjRJS6tRTr1UrhXZTh0PnAk+xF/l9bCGyYsQB
         k6+396jkxHnR2D5Ytphl4Wjqap8C0hlsMfh/qdlJ1JeTARhpxq8c9nPzNIvTImjxpT+C
         GMRwixiuq6GeF0ElW1rqSCwjokJMVWJ6qlQC5MYHS4kR+T3ipjsCQ6wLJAnNTAUCuFaK
         aPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0f5n/Bb4ZQ3NDjDGqKckIUS2qUmXXS6bLtvGcaKg4v8=;
        b=y7S831xVLAhi8Wu4EL+Hs3+Om56o/xdJT0U3LI3XugUaEiaLFWrff5rK8CTs3O/6A3
         rMI6tRvN2vjLkKtKVYsJGHoL730f30YOhlS/mosdTNxwErbFxJiQj/o6QBo8nfFXsF46
         3thv+E4pZifStQQqmCfZnaUzmps1oLGxQkKZK8jQwKYfX+lWBkKLEmEItmayG9pElpla
         ZeVbhJM2sUzzldUtjkgtTVSP2lYt6inHG5fl89XInnwECUkwU4Y3arpV1LLqmJrb+k3N
         kS6wZhUyqP+7IS57P7Dbxw2ca1AHVDZq+OXoZ2VZcECx4Nljy1xG0uvpj4V6WdTd8X+o
         qT4Q==
X-Gm-Message-State: AO0yUKV+4QWb94VeJ/gS1Wo733sGwgJpBKdjYxkQwNw9pNqhuaGvLOHM
        bkCB2q70g2i+3bN3XQG7YuQeIw==
X-Google-Smtp-Source: AK7set9a7FuW0Dzh6tzfAaUyOZas2h1eDn7WsexBmWEpoMAWXmh8wHpmKr7+Weg1cVXbQ8uHlMwQMg==
X-Received: by 2002:a05:600c:5386:b0:3cf:9844:7b11 with SMTP id hg6-20020a05600c538600b003cf98447b11mr342875wmb.23.1675191702581;
        Tue, 31 Jan 2023 11:01:42 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id n15-20020a5d598f000000b002bdff778d87sm16939882wri.34.2023.01.31.11.01.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 11:01:41 -0800 (PST)
Message-ID: <c515aae3-88e4-948c-a856-7b45dd2caed9@linaro.org>
Date:   Tue, 31 Jan 2023 20:01:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 4/4] arm64: dts: qcom: thinkpad-x13s: Add bluetooth
Content-Language: en-US
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>
References: <20230131043816.4525-1-steev@kali.org>
 <20230131043816.4525-5-steev@kali.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230131043816.4525-5-steev@kali.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/01/2023 05:38, Steev Klimaszewski wrote:
> Signed-off-by: Steev Klimaszewski <steev@kali.org>
> ---
>  .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 68 +++++++++++++++++++
>  1 file changed, 68 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> index f936b020a71d..951438ac5946 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> @@ -24,6 +24,8 @@ / {
>  	aliases {
>  		i2c4 = &i2c4;
>  		i2c21 = &i2c21;
> +		serial0 = &uart17;
> +		serial1 = &uart2;
>  	};
>  
>  	wcd938x: audio-codec {
> @@ -712,6 +714,32 @@ &qup0 {
>  	status = "okay";
>  };
>  
> +&uart2 {
> +	status = "okay";
> +
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&uart2_state>;
> +
> +	bluetooth {
> +		compatible = "qcom,wcn6855-bt";
> +
> +/*

Why dead code should be in the kernel?

> +		vddio-supply = <&vreg_s4a_1p8>;
> +		vddxo-supply = <&vreg_l7a_1p8>;
> +		vddrf-supply = <&vreg_l17a_1p3>;
> +		vddch0-supply = <&vreg_l25a_3p3>;
> +		vddch1-supply = <&vreg_l23a_3p3>;
> +*/
> +		max-speed = <3200000>;
> +
> +		enable-gpios = <&tlmm 133 GPIO_ACTIVE_HIGH>;
> +		swctrl-gpios = <&tlmm 132 GPIO_ACTIVE_HIGH>;
> +
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&bt_en>;
> +	};
> +};
> +
>  &qup1 {
>  	status = "okay";
>  };
> @@ -720,6 +748,12 @@ &qup2 {
>  	status = "okay";
>  };
>  
> +&uart17 {
> +	compatible = "qcom,geni-debug-uart";
> +
> +	status = "okay";
> +};
> +
>  &remoteproc_adsp {
>  	firmware-name = "qcom/sc8280xp/LENOVO/21BX/qcadsp8280.mbn";
>  
> @@ -980,6 +1014,19 @@ hastings_reg_en: hastings-reg-en-state {
>  &tlmm {
>  	gpio-reserved-ranges = <70 2>, <74 6>, <83 4>, <125 2>, <128 2>, <154 7>;
>  
> +	bt_en: bt-en-state {
> +		hstp-sw-ctrl {

Does not look like you tested the DTS against bindings. Please run `make
dtbs_check` (see Documentation/devicetree/bindings/writing-schema.rst
for instructions).

> +			pins = "gpio132";
> +			function = "gpio";
> +		};
> +
> +		hstp-bt-en {
> +			pins = "gpio133";
> +			function = "gpio";
> +			drive-strength = <16>;
> +		};
> +	};
> +
>  	edp_reg_en: edp-reg-en-state {
>  		pins = "gpio25";
>  		function = "gpio";
> @@ -1001,6 +1048,27 @@ i2c4_default: i2c4-default-state {
>  		bias-disable;
>  	};
>  
> +	uart2_state: uart2-state {
> +		cts {

Does not look like you tested the DTS against bindings. Please run `make
dtbs_check` (see Documentation/devicetree/bindings/writing-schema.rst
for instructions).


Best regards,
Krzysztof

