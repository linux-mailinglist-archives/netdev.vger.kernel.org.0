Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436576EAF17
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 18:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjDUQaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 12:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbjDUQaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 12:30:00 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4860014F50
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 09:29:55 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-95678d891d6so263881766b.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 09:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682094593; x=1684686593;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z2lceN+RcwbSriAog87kmvBp4Ig+d6w1NXjdL4Cuf98=;
        b=fKabE0ElpYsMxF83dciHx+q2lQtVpj8xDFMkd5xJDuLQZyduLpPWVxLtoFPO/iZH1Q
         Z65x2GC5QMz24qKRiVygOtekLW43se+ZhZ353Mn1LGmInPlvMYOK+hLhv1xRfYZCLY2K
         RUKkEHspFlxCO2A3jWyLFUWcSMxSuS9CPF35ZRt14uewJjtSmDfdCKytDddOfuf0Iqf+
         twyiMIMnSDslk4ethIXrdFljQAgJ9SnckNXSQxZCoevFBi/O3nTVpsGjlg8dObloCKUV
         KRnl2OfDq4KDoxUEWGjRGaEhnBr0fMOyZ4kuPPbj8n9s3iFwddSiX52V/6MFFP9YWyHj
         aRxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682094593; x=1684686593;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2lceN+RcwbSriAog87kmvBp4Ig+d6w1NXjdL4Cuf98=;
        b=FOlcIae3r553LRi1TBsiSX0pVi5TAonxuIfPthOkwahIPHwNSIkFrdudeOoarv8LHk
         D3sc6idsRwv41x+vcNpRubpMa4nIgYBHm+Jm6rCdJQEsgrlxK39ZRVptU8CsuAXMMHjc
         KlKVevFXAveOGDF30N8CGMdvVqKS3yCiPX0s1hUIszDWjsY39ZZmAknJHESQg+uDHVAG
         z0uFLNJFNEJQ5KpFjNiTHX6z6yj1cef8Gfv2C7UBlWn+6DLLSmD4xcMioW/XK1x7OHsr
         r0V8VZTKCslcT5NlmhWxbZOazpEJw8tTvwWDul7HnVjcNvxpDmkX92I/CaAklxNU6ty5
         AJEA==
X-Gm-Message-State: AAQBX9e4E7+eAS5PopSkLPEbI4T8eZ0dp0fNJAthvlZ9MDQ5ngCVMMj4
        OInraIx/6Z3xDGF3yVNLFO/oig==
X-Google-Smtp-Source: AKy350aIhPQmR/hsnm+P58a4r9cji9+qzdkITlRnifWQto3w83ZN/C+OETaXEew8IlrbQY0qKJho7g==
X-Received: by 2002:a17:906:7311:b0:94a:3ff1:53ad with SMTP id di17-20020a170906731100b0094a3ff153admr3619196ejc.75.1682094593689;
        Fri, 21 Apr 2023 09:29:53 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:687d:8c5:41cb:9883? ([2a02:810d:15c0:828:687d:8c5:41cb:9883])
        by smtp.gmail.com with ESMTPSA id vp3-20020a170907a48300b0094f14286f86sm2225058ejc.48.2023.04.21.09.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 09:29:53 -0700 (PDT)
Message-ID: <e4c24fcf-bd92-7208-95d8-c71cc17caf3b@linaro.org>
Date:   Fri, 21 Apr 2023 18:29:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 1/2] dt-bindings: pinctrl: qcom: Add SDX75 pinctrl
 devicetree compatible
Content-Language: en-US
To:     Rohit Agarwal <quic_rohiagar@quicinc.com>, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
        manivannan.sadhasivam@linaro.org
Cc:     linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1682070196-980-1-git-send-email-quic_rohiagar@quicinc.com>
 <1682070196-980-2-git-send-email-quic_rohiagar@quicinc.com>
 <a68e1bc8-df55-684e-300c-678565ae1dd6@linaro.org>
 <df304802-bcd9-f241-419a-3345d79bfd1e@quicinc.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <df304802-bcd9-f241-419a-3345d79bfd1e@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/04/2023 12:35, Rohit Agarwal wrote:
> 
> On 4/21/2023 3:38 PM, Krzysztof Kozlowski wrote:
>> On 21/04/2023 11:43, Rohit Agarwal wrote:
>>> Add device tree binding Documentation details for Qualcomm SDX75
>>> pinctrl driver.
>>>
>>> Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
>> Thank you for your patch. There is something to discuss/improve.
>>
>>> +properties:
>>> +  compatible:
>>> +    const: qcom,sdx75-tlmm
>>> +
>>> +  reg:
>>> +    maxItems: 1
>>> +
>>> +  interrupts: true
>>> +  interrupt-controller: true
>>> +  "#interrupt-cells": true
>>> +  gpio-controller: true
>>> +
>>> +  gpio-reserved-ranges:
>>> +    minItems: 1
>>> +    maxItems: 105
>>> +
>>> +  gpio-line-names:
>>> +    maxItems: 133
>> If you have 210 GPIOs, then this should be 210.
>>
>>> +
>>> +  "#gpio-cells": true
>>> +  gpio-ranges: true
>>> +  wakeup-parent: true
>>> +
>>> +patternProperties:
>>> +  "-state$":
>>> +    oneOf:
>>> +      - $ref: "#/$defs/qcom-sdx75-tlmm-state"
>>> +      - patternProperties:
>>> +          "-pins$":
>>> +            $ref: "#/$defs/qcom-sdx75-tlmm-state"
>>> +        additionalProperties: false
>>> +
>>> +$defs:
>>> +  qcom-sdx75-tlmm-state:
>>> +    type: object
>>> +    description:
>>> +      Pinctrl node's client devices use subnodes for desired pin configuration.
>>> +      Client device subnodes use below standard properties.
>>> +    $ref: qcom,tlmm-common.yaml#/$defs/qcom-tlmm-state
>> unevaluatedProperties: false
>>> +
>>> +    properties:
>>> +      pins:
>>> +        description:
>>> +          List of gpio pins affected by the properties specified in this
>>> +          subnode.
>>> +        items:
>>> +          oneOf:
>>> +            - pattern: "^gpio([0-9]|[1-9][0-9]|1[0-9][0-9]|20[0-9])$"
>> This says you have 210 GPIOs.
>>
>>> +            - enum: [ ufs_reset, sdc2_clk, sdc2_cmd, sdc2_data ]
>> Keep these four enum values sorted alphabetically.
>>
>>> +        minItems: 1
>>> +        maxItems: 36
>>> +
>>> +      function:
>>> +        description:
>>> +          Specify the alternative function to be configured for the specified
>>> +          pins.
>>> +        enum: [ gpio, eth0_mdc, eth0_mdio, eth1_mdc, eth1_mdio,
>>> +                qlink0_wmss_reset, qlink1_wmss_reset, rgmii_rxc, rgmii_rxd0,
>>> +                rgmii_rxd1, rgmii_rxd2, rgmii_rxd3,rgmii_rx_ctl, rgmii_txc,
>>> +                rgmii_txd0, rgmii_txd1, rgmii_txd2, rgmii_txd3, rgmii_tx_ctl,
>>> +                adsp_ext_vfr, atest_char_start, atest_char_status0,
>>> +                atest_char_status1, atest_char_status2, atest_char_status3,
>>> +                audio_ref_clk, bimc_dte_test0, bimc_dte_test1,
>>> +                char_exec_pending, char_exec_release, coex_uart2_rx,
>>> +                coex_uart2_tx, coex_uart_rx, coex_uart_tx, cri_trng_rosc,
>>> +                cri_trng_rosc0, cri_trng_rosc1, dbg_out_clk, ddr_bist_complete,
>>> +                ddr_bist_fail, ddr_bist_start, ddr_bist_stop, ddr_pxi0_test,
>>> +                ebi0_wrcdc_dq2, ebi0_wrcdc_dq3, ebi2_a_d, ebi2_lcd_cs,
>>> +                ebi2_lcd_reset, ebi2_lcd_te, emac0_mcg_pst0, emac0_mcg_pst1,
>>> +                emac0_mcg_pst2, emac0_mcg_pst3, emac0_ptp_aux, emac0_ptp_pps,
>>> +                emac1_mcg_pst0, emac1_mcg_pst1, emac1_mcg_pst2, emac1_mcg_pst3,
>>> +                emac1_ptp_aux0, emac1_ptp_aux1, emac1_ptp_aux2, emac1_ptp_aux3,
>>> +                emac1_ptp_pps0, emac1_ptp_pps1, emac1_ptp_pps2, emac1_ptp_pps3,
>>> +                emac_cdc_dtest0, emac_cdc_dtest1, emac_pps_in, ext_dbg_uart,
>>> +                gcc_125_clk, gcc_gp1_clk, gcc_gp2_clk, gcc_gp3_clk,
>>> +                gcc_plltest_bypassnl, gcc_plltest_resetn, i2s_mclk,
>>> +                jitter_bist_ref, ldo_en, ldo_update, m_voc_ext, mgpi_clk_req,
>>> +                native0, native1, native2, native3, native_char_start,
>>> +                native_tsens_osc, native_tsense_pwm1, nav_dr_sync, nav_gpio_0,
>>> +                nav_gpio_1, nav_gpio_2, nav_gpio_3, pa_indicator_1, pci_e_rst,
>>> +                pcie0_clkreq_n, pcie1_clkreq_n, pcie2_clkreq_n, pll_bist_sync,
>>> +                pll_clk_aux, pll_ref_clk, pri_mi2s_data0, pri_mi2s_data1,
>>> +                pri_mi2s_sck, pri_mi2s_ws, prng_rosc_test0, prng_rosc_test1,
>>> +                prng_rosc_test2, prng_rosc_test3, qdss_cti_trig0,
>>> +                qdss_cti_trig1, qdss_gpio_traceclk, qdss_gpio_tracectl,
>>> +                qdss_gpio_tracedata0, qdss_gpio_tracedata1,
>>> +                qdss_gpio_tracedata10, qdss_gpio_tracedata11,
>>> +                qdss_gpio_tracedata12, qdss_gpio_tracedata13,
>>> +                qdss_gpio_tracedata14, qdss_gpio_tracedata15,
>>> +                qdss_gpio_tracedata2, qdss_gpio_tracedata3,
>>> +                qdss_gpio_tracedata4, qdss_gpio_tracedata5,
>>> +                qdss_gpio_tracedata6, qdss_gpio_tracedata7,
>>> +                qdss_gpio_tracedata8, qdss_gpio_tracedata9, qlink0_b_en,
>>> +                qlink0_b_req, qlink0_l_en, qlink0_l_req, qlink1_l_en,
>>> +                qlink1_l_req, qup_se0_l0, qup_se0_l1, qup_se0_l2, qup_se0_l3,
>>> +                qup_se1_l2, qup_se1_l3, qup_se2_l0, qup_se2_l1, qup_se2_l2,
>>> +                qup_se2_l3, qup_se3_l0, qup_se3_l1, qup_se3_l2, qup_se3_l3,
>>> +                qup_se4_l2, qup_se4_l3, qup_se5_l0, qup_se5_l1, qup_se6_l0,
>>> +                qup_se6_l1, qup_se6_l2, qup_se6_l3, qup_se7_l0, qup_se7_l1,
>>> +                qup_se7_l2, qup_se7_l3, qup_se8_l2, qup_se8_l3, sdc1_tb_trig,
>>> +                sdc2_tb_trig, sec_mi2s_data0, sec_mi2s_data1, sec_mi2s_sck,
>>> +                sec_mi2s_ws, sgmii_phy_intr0, sgmii_phy_intr1, spmi_coex_clk,
>>> +                spmi_coex_data, spmi_vgi_hwevent, tgu_ch0_trigout,
>>> +                tri_mi2s_data0, tri_mi2s_data1, tri_mi2s_sck, tri_mi2s_ws,
>>> +                uim1_clk, uim1_data, uim1_present, uim1_reset, uim2_clk,
>>> +                uim2_data, uim2_present, uim2_reset, usb2phy_ac_en,
>>> +                vsense_trigger_mirnat]
>>> +
>>> +      bias-disable: true
>>> +      bias-pull-down: true
>>> +      bias-pull-up: true
>>> +      drive-strength: true
>>> +      input-enable: true
>> This is not allowed. Please rebase on pinctrl maintainer tree or next.
> Will do this.
>>
>>> +      output-high: true
>>> +      output-low: true
>>> +
>>> +    required:
>>> +      - pins
>>> +
>>> +    additionalProperties: false
>>> +
>>> +required:
>>> +  - compatible
>>> +  - reg
>>> +
>>> +additionalProperties: false
>>> +
>>> +examples:
>>> +  - |
>>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
>>> +    tlmm: pinctrl@f100000 {
>>> +        compatible = "qcom,sdx75-tlmm";
>>> +        reg = <0x0f100000 0x300000>;
>>> +        gpio-controller;
>>> +        #gpio-cells = <2>;
>>> +        gpio-ranges = <&tlmm 0 0 134>;
>> Wrong number of pins. You have 210, right? This should be number of
>> GPIOs + optionally UFS reset.
> Thanks for reviewing the patch.
> Actually it has 133 pins. Ok. Let me update the above property as well.
> And just checked there is no ufs reset pin. So it should be removed 
> completely.

Then the pattern for GPIOs should be narrowed and gpio-reserved-ranges
should be (half + 1), so 67.

Best regards,
Krzysztof

