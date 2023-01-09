Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31678662E64
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbjAISM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235113AbjAISM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:12:27 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5719A6A0E3
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:09:58 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id c4-20020a1c3504000000b003d9e2f72093so4944632wma.1
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=am+JRvWgrZee9DkApRcaffbu+WjKJWqxiwRdtbJxQOM=;
        b=qKpDrSoZRnDRxTK3T89R9vLe6086TcPIDbRam2C7P5xQ4cZS1eodAG9ncabvZjpdoc
         +KL0mxl5OW1RfDcAoNkCUmcpYYPm6R4wx/4elKGA6SX3hsxB4o6/W7rrDrdtIfpKmkLx
         oENsXcdqk3NE8UNl69x4eHGK/6Vi0Dt9VeqptvEinmVm7xhbBwr4K7ZApr9ZorS+ZJ+l
         Pf6cHAJ+8mcSCcEfdTEd7c4eEYtOzG4gH9WVHw0/u1p1P/u4g0rgHgI6uIxE1yEHsg4b
         qPJ1HP+9+Sb4Kg/GYnF9l7XhZgZB5+FV84Lvg4lIB0lFejJM+ghU4QbPlCG41Mb2/cDU
         wTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=am+JRvWgrZee9DkApRcaffbu+WjKJWqxiwRdtbJxQOM=;
        b=KVUDnQM0dJIuoVgRPl/46SDSQ7WJTPdX/oLpvv03ZF1OdJK354cbJBoiu+p23Y+Zjb
         PrdeEGDWPDZmvNt9gZg4PRbpMwI35n9akrss6SAkXaAjbAmoJ51WoZw99uYFsu/Oyctn
         0RUQWnC8GWB9b/5Kf2upnquKeqHvso5R9BtHQfsYaaBAC7bocv8kuRA7AaS/cyxVNnFe
         RZbG3d83bVVuGUV3pmVYUxHdo6TZhx49yq/iwrxohPgD8ajL7Y6HpgAVZFS9wdSyav6F
         JwxNMW69qHLYLGEfo0K8i+UGkoc85waCE6ZCcVWYEb+W8lzLjtSFhb3i9EF91sTYF8Mk
         V1xA==
X-Gm-Message-State: AFqh2kr70bPkIdUsOcUvzQY1O4xiSAmqG+YmR8KHszPfSzvlSZio6fnZ
        eO6U9Wj0/NWxXZkzQCGOL5f1Wg==
X-Google-Smtp-Source: AMrXdXu/tz7JPMOxUMwqSf85/nX86afoIPu/dn5TEqz/JAWfswEei9XzHCQ6xcwdlw9CXjWybAZuJg==
X-Received: by 2002:a7b:cb56:0:b0:3d2:3be4:2d9a with SMTP id v22-20020a7bcb56000000b003d23be42d9amr47302610wmj.20.1673287796783;
        Mon, 09 Jan 2023 10:09:56 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id o21-20020a1c7515000000b003d995a704fdsm12174018wmc.33.2023.01.09.10.09.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 10:09:56 -0800 (PST)
Message-ID: <c9ba8035-17c3-0e90-2142-fc9004d286f5@linaro.org>
Date:   Mon, 9 Jan 2023 19:09:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 09/18] dt-bindings: pinctrl: sa8775p: add bindings for
 qcom,sa8775p-tlmm
Content-Language: en-US
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230109174511.1740856-1-brgl@bgdev.pl>
 <20230109174511.1740856-10-brgl@bgdev.pl>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230109174511.1740856-10-brgl@bgdev.pl>
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

On 09/01/2023 18:45, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Add DT bindings for the TLMM controller on sa8775p platforms.

Subject: drop second/last, redundant "bindings for". The "dt-bindings"
prefix is already stating that these are bindings.

> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  .../bindings/pinctrl/qcom,sa8775p-tlmm.yaml   | 142 ++++++++++++++++++
>  1 file changed, 142 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sa8775p-tlmm.yaml
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,sa8775p-tlmm.yaml b/Documentation/devicetree/bindings/pinctrl/qcom,sa8775p-tlmm.yaml
> new file mode 100644
> index 000000000000..44abf83b1358
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/qcom,sa8775p-tlmm.yaml
> @@ -0,0 +1,142 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/pinctrl/qcom,sa8775p-tlmm.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm Technologies, Inc. SA8775P TLMM block
> +
> +maintainers:
> +  - Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> +
> +description: |
> +  Top Level Mode Multiplexer pin controller in Qualcomm SA8775P SoC.
> +
> +allOf:
> +  - $ref: /schemas/pinctrl/qcom,tlmm-common.yaml#
> +
> +properties:
> +  compatible:
> +    const: qcom,sa8775p-tlmm
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts: true
> +  interrupt-controller: true
> +  "#interrupt-cells": true
> +  gpio-controller: true
> +  "#gpio-cells": true
> +  gpio-ranges: true

Add also gpio-reserved-ranges with min/maxItems (see for example sm8450)
and gpio-line-names with maxItems.

> +
> +required:
> +  - compatible
> +  - reg
> +
> +additionalProperties: false
> +
> +patternProperties:
> +  "-state$":
> +    oneOf:
> +      - $ref: "#/$defs/qcom-sa8775p-tlmm-state"
> +      - patternProperties:
> +          "-pins$":
> +            $ref: "#/$defs/qcom-sa8775p-tlmm-state"
> +        additionalProperties: false
> +
> +$defs:
> +  qcom-sa8775p-tlmm-state:
> +    type: object
> +    description:
> +      Pinctrl node's client devices use subnodes for desired pin configuration.
> +      Client device subnodes use below standard properties.
> +    $ref: qcom,tlmm-common.yaml#/$defs/qcom-tlmm-state
> +
> +    properties:
> +      pins:
> +        description:
> +          List of gpio pins affected by the properties specified in this
> +          subnode.
> +        items:
> +          oneOf:
> +            - pattern: "^gpio([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-1][0-9]|22[0-7])$"
> +            - enum: [ sdc1_rclk, sdc1_clk, sdc1_cmd, sdc1_data, ufs_reset ]

Contents of this enum is sorted usually by name (not always, but we try
for new bindings)

> +        minItems: 1
> +        maxItems: 16
> +
> +      function:
> +        description:
> +          Specify the alternative function to be configured for the specified
> +          pins.
> +
> +        enum: [ atest_char, atest_char0, atest_char1, atest_char2,
> +                atest_char3, atest_usb2, atest_usb20, atest_usb21, atest_usb22,
> +                atest_usb23, audio_ref, cam_mclk, cci_async, cci_i2c,
> +                cci_timer0, cci_timer1, cci_timer2, cci_timer3, cci_timer4,
> +                cci_timer5, cci_timer6, cci_timer7, cci_timer8, cci_timer9,
> +                cri_trng, cri_trng0, cri_trng1, dbg_out, ddr_bist, ddr_pxi0,
> +                ddr_pxi1, ddr_pxi2, ddr_pxi3, ddr_pxi4, ddr_pxi5, edp0_hot,
> +                edp0_lcd, edp1_hot, edp1_lcd, edp2_hot, edp2_lcd, edp3_hot,
> +                edp3_lcd, emac0_mcg0, emac0_mcg1, emac0_mcg2, emac0_mcg3,
> +                emac0_mdc, emac0_mdio, emac0_ptp, emac1_mcg0, emac1_mcg1,
> +                emac1_mcg2, emac1_mcg3, emac1_mdc, emac1_mdio, emac1_ptp,
> +                gcc_gp1, gcc_gp2, gcc_gp3, gcc_gp4, gcc_gp5, hs0_mi2s, hs1_mi2s,
> +                hs2_mi2s, ibi_i3c, jitter_bist, mdp0_vsync0, mdp0_vsync1,
> +                mdp0_vsync2, mdp0_vsync3, mdp0_vsync4, mdp0_vsync5, mdp0_vsync6,
> +                mdp0_vsync7, mdp0_vsync8, mdp1_vsync0, mdp1_vsync1, mdp1_vsync2,
> +                mdp1_vsync3, mdp1_vsync4, mdp1_vsync5, mdp1_vsync6, mdp1_vsync7,
> +                mdp1_vsync8, mdp_vsync, mi2s1_data0, mi2s1_data1, mi2s1_sck,
> +                mi2s1_ws, mi2s2_data0, mi2s2_data1, mi2s2_sck, mi2s2_ws,
> +                mi2s_mclk0, mi2s_mclk1, pcie0_clkreq, pcie1_clkreq, phase_flag0,
> +                phase_flag1, phase_flag10, phase_flag11, phase_flag12,
> +                phase_flag13, phase_flag14, phase_flag15, phase_flag16,
> +                phase_flag17, phase_flag18, phase_flag19, phase_flag2,
> +                phase_flag20, phase_flag21, phase_flag22, phase_flag23,
> +                phase_flag24, phase_flag25, phase_flag26, phase_flag27,
> +                phase_flag28, phase_flag29, phase_flag3, phase_flag30,
> +                phase_flag31, phase_flag4, phase_flag5, phase_flag6,
> +                phase_flag7, phase_flag8, phase_flag9, pll_bist, pll_clk,
> +                prng_rosc0, prng_rosc1, prng_rosc2, prng_rosc3, qdss_cti,
> +                qdss_gpio, qdss_gpio0, qdss_gpio1, qdss_gpio10, qdss_gpio11,
> +                qdss_gpio12, qdss_gpio13, qdss_gpio14, qdss_gpio15, qdss_gpio2,
> +                qdss_gpio3, qdss_gpio4, qdss_gpio5, qdss_gpio6, qdss_gpio7,
> +                qdss_gpio8, qdss_gpio9, qup0_se0, qup0_se1, qup0_se2, qup0_se3,
> +                qup0_se4, qup0_se5, qup1_se0, qup1_se1, qup1_se2, qup1_se3,
> +                qup1_se4, qup1_se5, qup1_se6, qup2_se0, qup2_se1, qup2_se2,
> +                qup2_se3, qup2_se4, qup2_se5, qup2_se6, qup3_se0, sail_top,
> +                sailss_emac0, sailss_ospi, sgmii_phy, tb_trig, tgu_ch0, tgu_ch1,
> +                tgu_ch2, tgu_ch3, tgu_ch4, tgu_ch5, tsense_pwm1, tsense_pwm2,
> +                tsense_pwm3, tsense_pwm4, usb2phy_ac, vsense_trigger]

Missing space before ]

> +
> +      bias-disable: true
> +      bias-pull-down: true
> +      bias-pull-up: true
> +      drive-strength: true
> +      input-enable: true
> +      output-high: true
> +      output-low: true
> +
> +    required:
> +      - pins
> +
> +    additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    tlmm: pinctrl@f000000 {
> +        compatible = "qcom,sa8775p-pinctrl";
> +        reg = <0xf000000 0x1000000>;
> +        interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
> +        gpio-controller;
> +        #gpio-cells = <2>;
> +        interrupt-controller;
> +        #interrupt-cells = <2>;
> +        gpio-ranges = <&tlmm 0 0 149>;

Why only 149?

> +
> +        qup_uart10_state {

No underscores in node names.. which points to next one:

Does not look like you tested the bindings. Please run `make
dt_binding_check` (see
Documentation/devicetree/bindings/writing-schema.rst for instructions).


Best regards,
Krzysztof

