Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D486D912A
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbjDFIG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235735AbjDFIG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:06:27 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02117E5D
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 01:06:22 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-4faef469610so1076720a12.1
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 01:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680768381;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=69TVopjhQVPLVwi8OVVS1vg/daLfOb7O6QqF2s6OeBA=;
        b=maT5n92ia/kYld3rI4DXOOT9mlrg9CePT06TnIDnt/uTXl1FCNjmP/7vqFkspE73Nt
         LWuTCJjFHWRWZkqZQ7I3ehrqe3W9zW/8w9+3q2w89JWtCOtpkMCxgZNeTq0pIUtTcenu
         bsYj+GOg2hE8gRk6Z02FZlgWL6yk/JcZetRWVrXZXv42lxljPDsNPEJNIbE876SD2R9j
         AaOiINYXBS12SmWKzaZ66uzlcPd7QybicIte3mKTsUAevH/SLiFrjQRHFbOCGKMeaF+l
         wrY+tHh0hO2YZi1zVBR49wNQ0ojU7OLtndxA4vyhQdbd3uJgNlaEGw0mIPcw5FQul0ZZ
         McRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680768381;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=69TVopjhQVPLVwi8OVVS1vg/daLfOb7O6QqF2s6OeBA=;
        b=CDpsF9GKjCpYIZ1+BKomTRwVKbIFCePdbtFPkQPdrjkeBp1vS5CYiVyLA9ELtQOoKU
         LgPGuYGgn8gljdgJ7PS574kp84cGVssc6/5OpmiqV/jKbiP7U1SzitMtNi5rkPuUE+vm
         1apkKwNem3Dl1UVuFmLkZftK9fOVkXZoX9LXSB+hr6MppdMf3Uzoqgy9yosT3b8LjpEX
         DAlZcNI+6IUSF/zUsV/5PqP9z0z04JeUUkOEo+0UjvXOWAu9ApvRtlbKtYIOmHtJ+ETn
         WGdUwMT8MbE1WCgeqFxr2wwJad6nAY3O17ZABdHfSK7U//IVaVTi2fkSRmjUvm8b9CLz
         tZBg==
X-Gm-Message-State: AAQBX9cuHzKKpSKhbqW7ZPxRSZhZdHPikyPuABBE8g+5qEdT+4Emf60D
        G4pCG4ljCNHTzfh5g/yhTkw+ww==
X-Google-Smtp-Source: AKy350aZ99MMAGXZWWO2a9UE7E+zhyRuyYzUbhUHck4NB5s8/jusNuU5FK1x0afe0JsEIzuG6JALBw==
X-Received: by 2002:aa7:da06:0:b0:502:8f49:2552 with SMTP id r6-20020aa7da06000000b005028f492552mr4264273eds.27.1680768381382;
        Thu, 06 Apr 2023 01:06:21 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:49e6:bb8c:a05b:c4ed? ([2a02:810d:15c0:828:49e6:bb8c:a05b:c4ed])
        by smtp.gmail.com with ESMTPSA id d20-20020a50cd54000000b005027dd7c403sm386901edj.66.2023.04.06.01.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 01:06:20 -0700 (PDT)
Message-ID: <48a6b0a3-b441-a84d-e321-b9a773743878@linaro.org>
Date:   Thu, 6 Apr 2023 10:06:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/2] dt-bindings: net: Convert ATH10K to YAML
Content-Language: en-US
To:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     Marijn Suijten <marijn.suijten@somainline.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <20230406-topic-ath10k_bindings-v1-0-1ef181c50236@linaro.org>
 <20230406-topic-ath10k_bindings-v1-1-1ef181c50236@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230406-topic-ath10k_bindings-v1-1-1ef181c50236@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/04/2023 02:59, Konrad Dybcio wrote:
> Convert the ATH10K bindings to YAML.
> 
> Dropped properties that are absent at the current state of mainline:
> - qcom,msi_addr
> - qcom,msi_base
> 
> qcom,coexist-support and qcom,coexist-gpio-pin do very little and should
> be reconsidered on the driver side, especially the latter one.
> 
> Somewhat based on the ath11k bindings.
> 

Thank you for your patch. There is something to discuss/improve.

> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
> new file mode 100644
> index 000000000000..2ff004e404d9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
> @@ -0,0 +1,357 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/wireless/qcom,ath10k.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm Technologies ATH10K wireless devices
> +
> +maintainers:
> +  - Kalle Valo <kvalo@kernel.org>
> +
> +description: |

Do not need '|'.

> +  Qualcomm Technologies, Inc. IEEE 802.11ac devices.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - qcom,ath10k # SDIO-based devices
> +      - qcom,ipq4019-wifi
> +      - qcom,wcn3990-wifi # SNoC-based devices
> +
> +  reg:
> +    maxItems: 1
> +
> +  reg-names:
> +    items:
> +      - const: membase
> +
> +  interrupts:
> +    minItems: 12
> +    maxItems: 17
> +
> +  interrupt-names:
> +    minItems: 12
> +    maxItems: 17
> +
> +  memory-region:
> +    maxItems: 1
> +    description:
> +      Reference to the MSA memory region used by the Wi-Fi firmware
> +      running on the Q6 core.
> +
> +  iommus:
> +    minItems: 1
> +    maxItems: 2
> +
> +  clocks:
> +    minItems: 1
> +    maxItems: 3
> +
> +  clock-names:
> +    minItems: 1
> +    maxItems: 3
> +
> +  resets:
> +    minItems: 6

Drop minItems here.

> +    maxItems: 6
> +
> +  reset-names:
> +    items:
> +      - const: wifi_cpu_init
> +      - const: wifi_radio_srif
> +      - const: wifi_radio_warm
> +      - const: wifi_radio_cold
> +      - const: wifi_core_warm
> +      - const: wifi_core_cold
> +
> +  ext-fem-name:
> +    $ref: /schemas/types.yaml#/definitions/string
> +    description: Name of external front end module used.
> +    items:

Drop items (it's just enum)

> +      enum:
> +        - microsemi-lx5586
> +        - sky85703-11
> +        - sky85803
> +
> +  wifi-firmware:
> +    type: object

additionalProperties: false

> +    description: |
> +      The ATH10K Wi-Fi node can contain one optional firmware subnode.
> +      Firmware subnode is needed when the platform does not have Trustzone.

properties:
  iommus:
    maxItems: 1

> +    required:
> +      - iommus
> +
> +  qcom,ath10k-calibration-data:
> +    $ref: /schemas/types.yaml#/definitions/uint8-array
> +    description:
> +      Calibration data + board-specific data as a byte array. The length
> +      can vary between hardware versions.
> +
> +  qcom,ath10k-calibration-variant:
> +    $ref: /schemas/types.yaml#/definitions/string
> +    description:
> +      Unique variant identifier of the calibration data in board-2.bin
> +      for designs with colliding bus and device specific ids
> +
> +  qcom,ath10k-pre-calibration-data:
> +    $ref: /schemas/types.yaml#/definitions/uint8-array
> +    description:
> +      Pre-calibration data as a byte array. The length can vary between
> +      hardware versions.
> +
> +  qcom,coexist-support:
> +    $ref: /schemas/types.yaml#/definitions/uint8

enum: [0, 1]

> +    description:
> +      0 or 1 to indicate coex support by the hardware.
> +
> +  qcom,coexist-gpio-pin:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      COEX GPIO number provided to the Wi-Fi firmware.
> +
> +  qcom,msa-fixed-perm:
> +    type: boolean
> +    description:
> +      Whether to skip executing an SCM call that reassigns the memory
> +      region ownership.
> +
> +  qcom,smem-states:
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    description: State bits used by the AP to signal the WLAN Q6.
> +    items:
> +      - description: Signal bits used to enable/disable low power mode
> +                     on WCN in the case of WoW (Wake on Wireless).
> +
> +  qcom,smem-state-names:
> +    description: The names of the state bits used for SMP2P output.
> +    items:
> +      - const: wlan-smp2p-out
> +
> +  qcom,snoc-host-cap-8bit-quirk:
> +    type: boolean
> +    description:
> +      Quirk specifying that the firmware expects the 8bit version
> +      of the host capability QMI request
> +
> +  qcom,xo-cal-data:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      XO cal offset to be configured in XO trim register.
> +
> +  vdd-0.8-cx-mx-supply:
> +    description: Main logic power rail
> +
> +  vdd-1.8-xo-supply:
> +    description: Crystal oscillator supply
> +
> +  vdd-1.3-rfa-supply:
> +    description: RFA supply
> +
> +  vdd-3.3-ch0-supply:
> +    description: Primary Wi-Fi antenna supply
> +
> +  vdd-3.3-ch1-supply:
> +    description: Secondary Wi-Fi antenna supply
> +
> +required:
> +  - compatible
> +  - reg
> +
> +additionalProperties: false
> +
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - qcom,ipq4019-wifi
> +    then:
> +      properties:
> +        interrupts:
> +          minItems: 17
> +          maxItems: 17
> +
> +        interrupt-names:
> +          minItems: 17
> +          items:
> +            - const: msi0
> +            - const: msi1
> +            - const: msi2
> +            - const: msi3
> +            - const: msi4
> +            - const: msi5
> +            - const: msi6
> +            - const: msi7
> +            - const: msi8
> +            - const: msi9
> +            - const: msi10
> +            - const: msi11
> +            - const: msi12
> +            - const: msi13
> +            - const: msi14
> +            - const: msi15
> +            - const: legacy
> +
> +        clocks:
> +          items:
> +            - description: Wi-Fi command clock
> +            - description: Wi-Fi reference clock
> +            - description: Wi-Fi RTC clock
> +
> +        clock-names:
> +          items:
> +            - const: wifi_wcss_cmd
> +            - const: wifi_wcss_ref
> +            - const: wifi_wcss_rtc
> +
> +      required:
> +        - clocks
> +        - clock-names
> +        - interrupts
> +        - interrupt-names
> +        - resets
> +        - reset-names
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - qcom,wcn3990-wifi
> +
> +    then:
> +      properties:
> +        clocks:
> +          minItems: 1
> +          items:
> +            - description: XO reference clock
> +            - description: Qualcomm Debug Subsystem clock
> +
> +        clock-names:
> +          minItems: 1
> +          items:
> +            - const: cxo_ref_clk_pin
> +            - const: qdss
> +
> +        interrupts:
> +          items:
> +            - description: CE0
> +            - description: CE1
> +            - description: CE2
> +            - description: CE3
> +            - description: CE4
> +            - description: CE5
> +            - description: CE6
> +            - description: CE7
> +            - description: CE8
> +            - description: CE9
> +            - description: CE10
> +            - description: CE11
> +
> +      required:
> +        - interrupts
> +
> +examples:
> +  # SNoC
> +  - |
> +    #include <dt-bindings/clock/qcom,rpmcc.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    reserved-memory {
> +        #address-cells = <2>;
> +        #size-cells = <2>;
> +
> +        wlan_msa_mem: memory@4cd000 {
> +            no-map;
> +            reg = <0x0 0x004cd000 0x0 0x1000>;
> +        };
> +    };

Drop the reserved memory node, it's more-or-less obvious (same everywhere).

> +
> +    wifi: wifi@18800000 {

Drop label.

> +      compatible = "qcom,wcn3990-wifi";
> +      reg = <0x18800000 0x800000>;
> +      reg-names = "membase";
> +      memory-region = <&wlan_msa_mem>;
> +      clocks = <&rpmcc RPM_SMD_RF_CLK2_PIN>;
> +      clock-names = "cxo_ref_clk_pin";
> +      interrupts = <GIC_SPI 413 IRQ_TYPE_LEVEL_HIGH>,
> +                   <GIC_SPI 414 IRQ_TYPE_LEVEL_HIGH>,
> +                   <GIC_SPI 415 IRQ_TYPE_LEVEL_HIGH>,
> +                   <GIC_SPI 416 IRQ_TYPE_LEVEL_HIGH>,
> +                   <GIC_SPI 417 IRQ_TYPE_LEVEL_HIGH>,
> +                   <GIC_SPI 418 IRQ_TYPE_LEVEL_HIGH>,
> +                   <GIC_SPI 420 IRQ_TYPE_LEVEL_HIGH>,
> +                   <GIC_SPI 421 IRQ_TYPE_LEVEL_HIGH>,
> +                   <GIC_SPI 422 IRQ_TYPE_LEVEL_HIGH>,
> +                   <GIC_SPI 423 IRQ_TYPE_LEVEL_HIGH>,
> +                   <GIC_SPI 424 IRQ_TYPE_LEVEL_HIGH>,
> +                   <GIC_SPI 425 IRQ_TYPE_LEVEL_HIGH>;
> +      iommus = <&anoc2_smmu 0x1900>,
> +               <&anoc2_smmu 0x1901>;
> +      qcom,snoc-host-cap-8bit-quirk;
> +      status = "disabled";

Drop status from examples.

The example looks a bit incomplete. Please add supplies and
wifi-firmware node.

> +    };
> +
> +  # AHB
> +  - |
> +    #include <dt-bindings/clock/qcom,gcc-ipq4019.h>
> +
> +    wifi0: wifi@a000000 {

Drop label.

> +        compatible = "qcom,ipq4019-wifi";
> +        reg = <0xa000000 0x200000>;
> +        resets = <&gcc WIFI0_CPU_INIT_RESET>,
> +                 <&gcc WIFI0_RADIO_SRIF_RESET>,
> +                 <&gcc WIFI0_RADIO_WARM_RESET>,
> +                 <&gcc WIFI0_RADIO_COLD_RESET>,
> +                 <&gcc WIFI0_CORE_WARM_RESET>,
> +                 <&gcc WIFI0_CORE_COLD_RESET>;
> +        reset-names = "wifi_cpu_init",
> +                      "wifi_radio_srif",
> +                      "wifi_radio_warm",
> +                      "wifi_radio_cold",
> +                      "wifi_core_warm",
> +                      "wifi_core_cold";
> +        clocks = <&gcc GCC_WCSS2G_CLK>,
> +                 <&gcc GCC_WCSS2G_REF_CLK>,
> +                 <&gcc GCC_WCSS2G_RTC_CLK>;
> +        clock-names = "wifi_wcss_cmd",
> +                      "wifi_wcss_ref",
> +                      "wifi_wcss_rtc";
> +        interrupts = <GIC_SPI 32 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 33 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 34 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 35 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 36 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 37 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 38 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 39 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 40 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 41 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 42 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 43 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 44 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 45 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 46 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 47 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>;
> +        interrupt-names =  "msi0",
> +                           "msi1",
> +                           "msi2",
> +                           "msi3",
> +                           "msi4",
> +                           "msi5",
> +                           "msi6",
> +                           "msi7",
> +                           "msi8",
> +                           "msi9",
> +                           "msi10",
> +                           "msi11",
> +                           "msi12",
> +                           "msi13",
> +                           "msi14",
> +                           "msi15",
> +                           "legacy";
> +        status = "disabled";

Ditto

> +      };
> 

Best regards,
Krzysztof

