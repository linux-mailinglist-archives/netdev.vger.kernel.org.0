Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6284D4FCD
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244023AbiCJQ4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242956AbiCJQ4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:56:05 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA77158D97
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:55:03 -0800 (PST)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 62F0B3F499
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 16:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646931302;
        bh=QcVJE48kyfYYnn5CBUnoW5WSJWpsZDFf7PteXVRFUGE=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=l5KES+Vawl3Gkm3yyQXpdKvk0BFdlyyPtursOmtMjNhUA5JBm9chB9uBJ6cgtpUzQ
         l/OWb9x5Fn1AVkCLsjocL/wqiTwcjgE3OJJwA5joQl/nfEs0Q4T76XZERTQ0kdFHHA
         31U1EkGQevSFJgFsi+Sj7XxDHb0KIZfaDnSsN86JB10SF0wHa89IjJW9sDVwohZPhp
         7aSXRgYibutAAcyGDuijPpHuNi+rN0/gowN0z6xfnLLbulFqzaoUlHnhXesw4q8PMp
         rWdt40N4lUbWup+Cr2P3qwaHU5WminbO+TgabHWcDEqt8MJK/TEflU/FLJtl0aOFMJ
         4hFL5KlCyGuFQ==
Received: by mail-ej1-f72.google.com with SMTP id 13-20020a170906328d00b006982d0888a4so3410741ejw.9
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:55:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QcVJE48kyfYYnn5CBUnoW5WSJWpsZDFf7PteXVRFUGE=;
        b=NFUKH8VLsL5pr0NlfqzSBryxKiEM0n2Ci+H5U/wNrC/9DVSaqiVH35foxYTEeA2GVF
         M1SQCQ12PM3KIu9WXixBkBeOeeOCkS8vzykajrHB1D3fc7VFo4QfgAW+6IsjNHVsmEHH
         NpIK3lSxCgqyksOk1K1qXfRtdTcbjH9K+G3k2z2cgeFpxVCCTL8GTUEyyhdj1PgSiNPM
         Jy4AwkQ7WKbfC3C13zxdhqc+Bgf3HQQ6pMQmfArFdY8QYDbzhITCfKdMAy1ciMIVIGYf
         vkyhrNly9iy4MrUjL5TR05eEHx7WTBzZUZqN26uxNsmO6UCFr9UxZe4puAXASkly5f0B
         kJxg==
X-Gm-Message-State: AOAM5307ilp7GMsSvHwEDoJrHD0V7XUl4PzjRESwQkg54PL8k1vww5zp
        biYGDRRWM8XMfH3LNBLBO9NTT4oHN1NlX4xoUvn2w4Jk2xPiMF64REXR0bKorObtHQlStYfGSno
        V9socROw0EQLLXjDF/Gg3KbsqrIHDC9g71A==
X-Received: by 2002:aa7:d1cc:0:b0:416:60c6:9225 with SMTP id g12-20020aa7d1cc000000b0041660c69225mr5264418edp.71.1646931302028;
        Thu, 10 Mar 2022 08:55:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwtlnrEBO/0kPGLY5xtCd+TgH6kN7BHyUjyhCkxDJiwbHTSElFKzyHh3dJJfSvanmZtZ3PCaA==
X-Received: by 2002:aa7:d1cc:0:b0:416:60c6:9225 with SMTP id g12-20020aa7d1cc000000b0041660c69225mr5264397edp.71.1646931301780;
        Thu, 10 Mar 2022 08:55:01 -0800 (PST)
Received: from [192.168.0.147] (xdsl-188-155-174-239.adslplus.ch. [188.155.174.239])
        by smtp.gmail.com with ESMTPSA id bn14-20020a170906c0ce00b006c5ef0494besm1948155ejb.86.2022.03.10.08.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 08:55:01 -0800 (PST)
Message-ID: <78c7b777-1527-759f-41f7-bd8422cb4eb0@canonical.com>
Date:   Thu, 10 Mar 2022 17:55:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] dt-bindings: can: xilinx_can: Convert Xilinx CAN
 binding to YAML
Content-Language: en-US
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        wg@grandegger.com, mkl@pengutronix.de, kuba@kernel.org,
        robh+dt@kernel.org, appana.durga.rao@xilinx.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, michal.simek@xilinx.com,
        git@xilinx.com, akumarma@xilinx.com
References: <20220310153909.30933-1-amit.kumar-mahapatra@xilinx.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220310153909.30933-1-amit.kumar-mahapatra@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/03/2022 16:39, Amit Kumar Mahapatra wrote:
> Convert Xilinx CAN binding documentation to YAML.
> 
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
> ---
> BRANCH: yaml
> 
> Changes in v2:
>  - Added reference to can-controller.yaml
>  - Added example node for canfd-2.0
> 
> Changes in v3:
>  - Changed yaml file name from xilinx_can.yaml to xilinx,can.yaml
>  - Added "power-domains" to fix dts_check warnings
>  - Grouped "clock-names" and "clocks" together
>  - Added type $ref for all non-standard fields
>  - Defined compatible strings as enum
>  - Used defines,instead of hard-coded values, for GIC interrupts
>  - Droped unused labels in examples
>  - Droped description for standard feilds
> ---
>  .../bindings/net/can/xilinx,can.yaml          | 161 ++++++++++++++++++
>  .../bindings/net/can/xilinx_can.txt           |  61 -------
>  2 files changed, 161 insertions(+), 61 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/can/xilinx,can.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/can/xilinx,can.yaml b/Documentation/devicetree/bindings/net/can/xilinx,can.yaml
> new file mode 100644
> index 000000000000..78398826677d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/xilinx,can.yaml
> @@ -0,0 +1,161 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/xilinx,can.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title:
> +  Xilinx Axi CAN/Zynq CANPS controller
> +
> +maintainers:
> +  - Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - xlnx,zynq-can-1.0
> +      - xlnx,axi-can-1.00.a
> +      - xlnx,canfd-1.0
> +      - xlnx,canfd-2.0
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    minItems: 1
> +    maxItems: 2
> +
> +  clock-names:
> +    maxItems: 2
> +
> +  power-domains:
> +    maxItems: 1
> +
> +  tx-fifo-depth:
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    description: CAN Tx fifo depth (Zynq, Axi CAN).
> +
> +  rx-fifo-depth:
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    description: CAN Rx fifo depth (Zynq, Axi CAN, CAN FD in sequential Rx mode)
> +
> +  tx-mailbox-count:
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    description: CAN Tx mailbox buffer count (CAN FD)

I asked about vendor prefix and I think I did not get an answer from you
about skipping it. Do you think it is not needed?

> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - clock-names
> +
> +additionalProperties: false

This should be rather unevaluatedProperties:false, so you could use
can-controller properties.

> +
> +allOf:
> +  - $ref: can-controller.yaml#
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - xlnx,zynq-can-1.0
> +
> +    then:
> +      properties:
> +        clock-names:
> +          items:
> +            - const: can_clk
> +            - const: pclk
> +      required:
> +        - tx-fifo-depth
> +        - rx-fifo-depth
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - xlnx,axi-can-1.00.a
> +
> +    then:
> +      properties:
> +        clock-names:
> +          items:
> +            - const: can_clk
> +            - const: s_axi_aclk
> +      required:
> +        - tx-fifo-depth
> +        - rx-fifo-depth
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - xlnx,canfd-1.0
> +              - xlnx,canfd-2.0
> +
> +    then:
> +      properties:
> +        clock-names:
> +          items:
> +            - const: can_clk
> +            - const: s_axi_aclk
> +      required:
> +        - tx-mailbox-count
> +        - rx-fifo-depth
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    can@e0008000 {
> +        compatible = "xlnx,zynq-can-1.0";
> +        clocks = <&clkc 19>, <&clkc 36>;
> +        clock-names = "can_clk", "pclk";
> +        reg = <0xe0008000 0x1000>;

Put reg just after compatible in all DTS examples.

> +        interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
> +        interrupt-parent = <&intc>;
> +        tx-fifo-depth = <0x40>;
> +        rx-fifo-depth = <0x40>;
> +    };
> +
> +  - |
> +    can@40000000 {
> +        compatible = "xlnx,axi-can-1.00.a";
> +        clocks = <&clkc 0>, <&clkc 1>;
> +        clock-names = "can_clk","s_axi_aclk" ;

Missing space after ','.

> +        reg = <0x40000000 0x10000>;
> +        interrupt-parent = <&intc>;
> +        interrupts = <GIC_SPI 59 IRQ_TYPE_EDGE_RISING>;
> +        tx-fifo-depth = <0x40>;
> +        rx-fifo-depth = <0x40>;
> +    };

Best regards,
Krzysztof
