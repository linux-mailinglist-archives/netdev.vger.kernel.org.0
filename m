Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01E9598003
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 10:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240223AbiHRIWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 04:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239951AbiHRIWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 04:22:34 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22857CB60
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 01:22:31 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id e15so1242295lfs.0
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 01:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=ZISBdhU5jjsQ/J0wTDtKXgSITQfAqU8864taLHzaYjM=;
        b=h6ZJ2B4Dt3c05SoEFIulAnGd7MNkX38buE09h03m1YVDrOI4kULqre4pETeIfBeheU
         W4CL4F7IHfrDgJl36TqihuPkalIjzkhykUZXE9O3CD5dMKioWnXAzfzb8hbICqkMjwQM
         7zTrM7xzfGBlIevNqpx+TCfp41NA9mFD5xdWbKedMY/ZorkWeQnTgsKHNbC96Ba0kYRH
         H54B3XA19tnygktHG7Vr/0atmyLax/Vp7obBCjy0P2kruxeOWNdCvKSyzL30r097UX3T
         BEz9W7ajXVd1YAA0Uwm2T4IByu/eOH3ZL2LVtDDxiP2oyJhDdoXNDckSsc0JkafpmMcf
         ei5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=ZISBdhU5jjsQ/J0wTDtKXgSITQfAqU8864taLHzaYjM=;
        b=DQV39w+apU6uBGEe6TCCaqZtx8/Fvt0YFa8+EYDJ8256OLVzC108oBZCpYGS6cSxcF
         9O4js2hahwh15OdjYmzZwMjuNDFA45iAVVaD9fcOqUQYIBgoVHnSMBrNeMVEEzKYUuxV
         5QzbgzQQHb0SBxsJjA87bDrcweVmPNaYL9BbWEN0EkDg3DoqN94cKPFO7NVncGaTbRcq
         G1r9zczWJ0rj1BBnNKEu4WakfYeEBnZc0QQCG574sJysaoWWZEVS2tce5MQFIDC03kx5
         tJj6dQV3J24KoVzv3Dkxa7mKKXTeMVti3L+GFxJ5KV0jjvjK11CMHJxlr33Fgha/zmbY
         uJeA==
X-Gm-Message-State: ACgBeo0dOj8iwHVkWLUqSjsoN8Ey7Q8RHQmCZQGg8npyGavGFOidvZ6u
        O6znp6XkQbGWmxDljhhgHFOmyhS8dH1LZtTB
X-Google-Smtp-Source: AA6agR7XMgueVY9H5NCQMxHMX/tByaMro7wUOEat1L/UTWiXyjOMiAkwE86qNw66Vl2z4V0qwL19Dw==
X-Received: by 2002:a05:6512:31ca:b0:48b:c4c2:d6d4 with SMTP id j10-20020a05651231ca00b0048bc4c2d6d4mr557266lfe.423.1660810950225;
        Thu, 18 Aug 2022 01:22:30 -0700 (PDT)
Received: from ?IPV6:2001:14bb:ae:539c:53ab:2635:d4f2:d6d5? (d15l54z9nf469l8226z-4.rev.dnainternet.fi. [2001:14bb:ae:539c:53ab:2635:d4f2:d6d5])
        by smtp.gmail.com with ESMTPSA id a8-20020a2eb548000000b00261b05d9d54sm127426ljn.127.2022.08.18.01.22.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 01:22:29 -0700 (PDT)
Message-ID: <b851147b-6453-c19e-7c31-a9cf8f87c1a4@linaro.org>
Date:   Thu, 18 Aug 2022 11:22:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH 1/4] dt-bindings: net: can: add STM32 bxcan DT
 bindings
Content-Language: en-US
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220817143529.257908-1-dario.binacchi@amarulasolutions.com>
 <20220817143529.257908-2-dario.binacchi@amarulasolutions.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220817143529.257908-2-dario.binacchi@amarulasolutions.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/08/2022 17:35, Dario Binacchi wrote:
> Add documentation of device tree bindings for the STM32 basic extended
> CAN (bxcan) controller.
> 
> Signed-off-by: Dario Binacchi <dariobin@libero.it>
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

You do not need two SoBs. Keep only one, matching the From field.

> ---
> 
>  .../devicetree/bindings/net/can/st,bxcan.yaml | 139 ++++++++++++++++++
>  1 file changed, 139 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/can/st,bxcan.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/can/st,bxcan.yaml b/Documentation/devicetree/bindings/net/can/st,bxcan.yaml
> new file mode 100644
> index 000000000000..f4cfd26e4785
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/st,bxcan.yaml

File name like compatible, so st,stm32-bxcan-core.yaml (or some other
name, see comment later)

> @@ -0,0 +1,139 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/st,bxcan.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: STMicroelectronics bxCAN controller Device Tree Bindings

s/Device Tree Bindings//

> +
> +description: STMicroelectronics BxCAN controller for CAN bus
> +
> +maintainers:
> +  - Dario Binacchi <dario.binacchi@amarulasolutions.com>
> +
> +allOf:
> +  - $ref: can-controller.yaml#
> +
> +properties:
> +  compatible:
> +    enum:
> +      - st,stm32-bxcan-core

compatibles are supposed to be specific. If this is some type of
micro-SoC, then it should have its name/number. If it is dedicated
device, is the final name bxcan core? Google says  the first is true, so
you miss specific device part.
	
> +
> +  reg:
> +    maxItems: 1
> +
> +  resets:
> +    maxItems: 1
> +
> +  clocks:
> +    description:
> +      Input clock for registers access
> +    maxItems: 1
> +
> +  '#address-cells':
> +    const: 1
> +
> +  '#size-cells':
> +    const: 0
> +
> +required:
> +  - compatible
> +  - reg
> +  - resets
> +  - clocks
> +  - '#address-cells'
> +  - '#size-cells'
> +
> +additionalProperties: false
> +
> +patternProperties:

This goes after "properties: in top level (before "required").

> +  "^can@[0-9]+$":
> +    type: object
> +    description:
> +      A CAN block node contains two subnodes, representing each one a CAN
> +      instance available on the machine.
> +
> +    properties:
> +      compatible:
> +        enum:
> +          - st,stm32-bxcan

Why exactly do you need compatible for the child? Is it an entierly
separate device?

Comments about specific part are applied here as well.

> +
> +      master:

Is this a standard property? I don't see it anywhere else. Non-standard
properties require vendor prefix.

> +        description:
> +          Master and slave mode of the bxCAN peripheral is only relevant
> +          if the chip has two CAN peripherals. In that case they share
> +          some of the required logic, and that means you cannot use the
> +          slave CAN without the master CAN.
> +        type: boolean
> +
> +      reg:
> +        description: |
> +          Offset of CAN instance in CAN block. Valid values are:
> +            - 0x0:   CAN1
> +            - 0x400: CAN2
> +        maxItems: 1
> +
> +      interrupts:
> +        items:
> +          - description: transmit interrupt
> +          - description: FIFO 0 receive interrupt
> +          - description: FIFO 1 receive interrupt
> +          - description: status change error interrupt
> +
> +      interrupt-names:
> +        items:
> +          - const: tx
> +          - const: rx0
> +          - const: rx1
> +          - const: sce
> +
> +      resets:
> +        maxItems: 1
> +
> +      clocks:
> +        description:
> +          Input clock for registers access
> +        maxItems: 1
> +
> +    additionalProperties: false
> +
> +    required:
> +      - compatible
> +      - reg
> +      - interrupts
> +      - resets
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/stm32fx-clock.h>
> +    #include <dt-bindings/mfd/stm32f4-rcc.h>
> +
> +    can: can@40006400 {
> +        compatible = "st,stm32-bxcan-core";
> +        reg = <0x40006400 0x800>;
> +        resets = <&rcc STM32F4_APB1_RESET(CAN1)>;
> +        clocks = <&rcc 0 STM32F4_APB1_CLOCK(CAN1)>;
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        status = "disabled";

No status in examples.

> +
> +        can1: can@0 {
> +            compatible = "st,stm32-bxcan";
> +            reg = <0x0>;
> +            interrupts = <19>, <20>, <21>, <22>;
> +            interrupt-names = "tx", "rx0", "rx1", "sce";
> +            resets = <&rcc STM32F4_APB1_RESET(CAN1)>;
> +            master;
> +            status = "disabled";

No status in examples.


> +        };
> +
> +        can2: can@400 {
> +            compatible = "st,stm32-bxcan";
> +            reg = <0x400>;
> +            interrupts = <63>, <64>, <65>, <66>;
> +            interrupt-names = "tx", "rx0", "rx1", "sce";
> +            resets = <&rcc STM32F4_APB1_RESET(CAN2)>;
> +            clocks = <&rcc 0 STM32F4_APB1_CLOCK(CAN2)>;
> +            status = "disabled";

No status in examples.

> +        };
> +    };


Best regards,
Krzysztof
