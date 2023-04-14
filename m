Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C126E1DB8
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 10:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjDNIBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 04:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDNIBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 04:01:40 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CF765BD
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 01:01:38 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id si1so13416567ejb.10
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 01:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681459297; x=1684051297;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xje8D9sa7nkYBBtoZ60rXI27tiHKZTyz3H3ko6glfWs=;
        b=SNzhq9yJd9kEmkttqZyGlJGyME1zSO4jRes4LYWjxfYh998ByIMuuMTsRUC891pvxw
         5AbB3DkE+/EOqA2BNkBBk8hUjWFZ/fsDHsISSnQjmlvPXuU+ZIjNOAu5lpXAwpfJfTEA
         yO5q6VoErPQyjATCG48//JjePz1qHYt2qjl4TzMF9ZlJVwNabncUPeq+tecx6EDJUKf1
         SmJBsa6PEJixtGxDfajFmw+YdCKCVQXPhhvgr9ARk8zGh5bbnAwaR8WlRfTPIIMRv581
         skHZEIVneM3xKjRXv+yhfg+Kzzu/zgEY9CydYX7AmUffCqlQBHKN8c655e6lzeHPdX4E
         d/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681459297; x=1684051297;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xje8D9sa7nkYBBtoZ60rXI27tiHKZTyz3H3ko6glfWs=;
        b=KHVCMmmT1FGol0d26+TxhA5X4FPoMEgAwOK2z0UeKo4oieWhqE41Tp1RTF1XrBSawD
         y1Eyv509OFdI4JqAlDJAmtqtUzry6j/t/XTAm0yhOFtpYVn+EHATFoL2SqsVF+73Wal3
         fo1zMBYGc8YQEAJ/ulyM/NRHvKWK59VEJJHqhDrJ++rJtlA79Z6LekdteRfmFoqMWCqh
         gSYJ7KUkvsy9QQp5bxrdXNkQHBlv7ByDY8kz4T6g3ekZ1+FZR1U/Wm+MY4U8eapBAps7
         exv0dzIcoNww6J6Mwljxb8IIEP0RjpySSootlwe2ouDTXFrUAVaYvX3bXhGmKqvYBj3s
         L4nQ==
X-Gm-Message-State: AAQBX9c0J/smtW6ZpYOEP7zHTzoz1bvbpswR3jVYGq4abn26W8MkiW9g
        Y0A0Q0oGcxJZuBoRMgim6QxmUA==
X-Google-Smtp-Source: AKy350ZpPz0lsPYf/WDpVV1jLkM/RaqXPVT1AUiSTHl5MrL2rJ/rUIEn3+7mlYfUZuE5d3lI///K/w==
X-Received: by 2002:a17:906:4d1:b0:94e:8aeb:f8f3 with SMTP id g17-20020a17090604d100b0094e8aebf8f3mr5886098eja.57.1681459297579;
        Fri, 14 Apr 2023 01:01:37 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:8a60:6b0f:105a:eefb? ([2a02:810d:15c0:828:8a60:6b0f:105a:eefb])
        by smtp.gmail.com with ESMTPSA id gj19-20020a170906e11300b0094a83007249sm2129846ejb.16.2023.04.14.01.01.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 01:01:37 -0700 (PDT)
Message-ID: <9ab56180-328e-1416-56cb-bbf71af0c26d@linaro.org>
Date:   Fri, 14 Apr 2023 10:01:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [RFC PATCH 4/5] arm64: dts: ti: Enable multiple MCAN for AM62x in
 MCU MCAN overlay
Content-Language: en-US
To:     Judith Mendez <jm@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>
Cc:     Nishanth Menon <nm@ti.com>, Vignesh Raghavendra <vigneshr@ti.com>,
        Andrew Davis <afd@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Schuyler Patton <spatton@ti.com>
References: <20230413223051.24455-1-jm@ti.com>
 <20230413223051.24455-5-jm@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230413223051.24455-5-jm@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2023 00:30, Judith Mendez wrote:
> Enable two MCAN in MCU domain. AM62x does not have on-board CAN
> transcievers, so instead of changing the DTB permanently, add
> MCU MCAN nodes and transceiver nodes to a MCU MCAN overlay.
> 
> If there are no hardware interrupts rounted to the GIC interrupt
> controller for MCAN IP, A53 Linux will not receive hardware
> interrupts. If an hrtimer is used to generate software interrupts,
> the two required interrupt attributes in the MCAN node do not have
> to be included.
> 
> Signed-off-by: Judith Mendez <jm@ti.com>
> ---
>  arch/arm64/boot/dts/ti/Makefile               |  2 +-
>  .../boot/dts/ti/k3-am625-sk-mcan-mcu.dtso     | 75 +++++++++++++++++++
>  2 files changed, 76 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso
> 
> diff --git a/arch/arm64/boot/dts/ti/Makefile b/arch/arm64/boot/dts/ti/Makefile
> index abe15e76b614..c76be3888e4d 100644
> --- a/arch/arm64/boot/dts/ti/Makefile
> +++ b/arch/arm64/boot/dts/ti/Makefile
> @@ -9,7 +9,7 @@
>  # alphabetically.
>  
>  # Boards with AM62x SoC
> -k3-am625-sk-mcan-dtbs := k3-am625-sk.dtb k3-am625-sk-mcan-main.dtbo
> +k3-am625-sk-mcan-dtbs := k3-am625-sk.dtb k3-am625-sk-mcan-main.dtbo k3-am625-sk-mcan-mcu.dtbo
>  dtb-$(CONFIG_ARCH_K3) += k3-am625-beagleplay.dtb
>  dtb-$(CONFIG_ARCH_K3) += k3-am625-sk.dtb
>  dtb-$(CONFIG_ARCH_K3) += k3-am625-sk-mcan.dtb
> diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso b/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso
> new file mode 100644
> index 000000000000..777705aea546
> --- /dev/null
> +++ b/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso
> @@ -0,0 +1,75 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/**
> + * DT overlay for MCAN in MCU domain on AM625 SK
> + *
> + * Copyright (C) 2022 Texas Instruments Incorporated - https://www.ti.com/
> + */
> +
> +/dts-v1/;
> +/plugin/;
> +
> +#include <dt-bindings/pinctrl/k3.h>
> +#include <dt-bindings/soc/ti,sci_pm_domain.h>
> +
> +
> +&{/} {
> +	transceiver2: can-phy1 {
> +		compatible = "ti,tcan1042";
> +		#phy-cells = <0>;
> +		max-bitrate = <5000000>;
> +	};
> +
> +	transceiver3: can-phy2 {
> +		compatible = "ti,tcan1042";
> +		#phy-cells = <0>;
> +		max-bitrate = <5000000>;
> +	};
> +};
> +
> +&mcu_pmx0 {
> +	mcu_mcan1_pins_default: mcu-mcan1-pins-default {
> +		pinctrl-single,pins = <
> +			AM62X_IOPAD(0x038, PIN_INPUT, 0) /* (B3) MCU_MCAN0_RX */
> +			AM62X_IOPAD(0x034, PIN_OUTPUT, 0) /* (D6) MCU_MCAN0_TX */
> +		>;
> +	};
> +
> +	mcu_mcan2_pins_default: mcu-mcan2-pins-default {
> +		pinctrl-single,pins = <
> +			AM62X_IOPAD(0x040, PIN_INPUT, 0) /* (D4) MCU_MCAN1_RX */
> +			AM62X_IOPAD(0x03C, PIN_OUTPUT, 0) /* (E5) MCU_MCAN1_TX */
> +		>;
> +	};
> +};
> +
> +&cbass_mcu {
> +	mcu_mcan1: can@4e00000 {
> +		compatible = "bosch,m_can";
> +		reg = <0x00 0x4e00000 0x00 0x8000>,
> +			  <0x00 0x4e08000 0x00 0x200>;
> +		reg-names = "message_ram", "m_can";
> +		power-domains = <&k3_pds 188 TI_SCI_PD_EXCLUSIVE>;
> +		clocks = <&k3_clks 188 6>, <&k3_clks 188 1>;
> +		clock-names = "hclk", "cclk";
> +		bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&mcu_mcan1_pins_default>;
> +		phys = <&transceiver2>;
> +		status = "okay";

okay is by default. Why do you need it?



Best regards,
Krzysztof

