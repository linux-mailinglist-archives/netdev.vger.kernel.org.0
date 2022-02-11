Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C024B2428
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 12:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349415AbiBKLTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 06:19:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbiBKLTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 06:19:01 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60353E65
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 03:19:00 -0800 (PST)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A9F53402BB
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 11:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644578335;
        bh=0i+aSrLr2xP12LjhI6EGPNptekavOphCpozo/xyqLbQ=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=U9fDkaaXF09V9ScKZozChPsN7bleUZXzCcBjWCxZkMTlVtPJyfRO76QDF75pI/eOB
         hJ0KCKgv0AUwSBbwjarsimNPRUXAUxQD+X6wpi5kVYBLCLgz4GEKToBq2dwsh77N/v
         d4l9DJ6iDzAfUJiOgyook8uc/KLWUUL49jtvroGOuwt2F4JLusKvYeZ+6+BRgiR9xF
         RmXl7WpbEss3i3oP50oUipj0vPkiMmrKFdKqUy0jtCKfngP/vBlEahePVdoE9ZnAeK
         SRczMwXgJm+pZPw6ylRRtv2MV04qMr+BSfj5RioW8Gulw3mp/D8LzSWZphbvhHYoHh
         QBqNAEVJ47Y6Q==
Received: by mail-ej1-f70.google.com with SMTP id mp5-20020a1709071b0500b0069f2ba47b20so3904446ejc.19
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 03:18:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0i+aSrLr2xP12LjhI6EGPNptekavOphCpozo/xyqLbQ=;
        b=NQAoSiYLCTlKM+tn9k6ud/c3tKUjmuALC7S/fOqFs2VNxQnGVWw0AlRw22FGQeqdRi
         44F8D3b1nbZChAVZJa1jvXgWwWkU1w6DG08qmvQ6ChIRMZT68NqwFyyUsiLz0kLpb1Fw
         5uoNZn4dZEPQBJ53HAYpIvXKfwmcU482TOyz54lyUqp0GpKQGWH+v/7s0Dr2Ikd9xjvd
         DuuMzCzXCwK4hp+dfWU1ZiX1ltZ/7TlUeBKM+6FmCMkes7M//mNdUHWfBQA7oLDniSQ9
         G1gbU2GG4vD7nBUfdvdC/8xfzgCxgxFo2s1FSGjS8/VIjQ85vnbSJOhWPtmet3hT1Css
         YRGA==
X-Gm-Message-State: AOAM531K3NxrLIDpB3mrWF77Sc5WWPSdc3X3KiJXW07PCEXnGvZaCIrf
        sN2ok1HeZkxfQbNrWJ+FbY8qK+J14pOFiUejsCOyzzoyLGo7WWbWXsFdSkzmzhZwhdR4lIryrjI
        Jh6czm9RbNa1X38VFn5Hh3da1v22wxC1i9w==
X-Received: by 2002:a50:fd05:: with SMTP id i5mr1319900eds.181.1644578335239;
        Fri, 11 Feb 2022 03:18:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0ThMbWOUMZug/PhGRlx8+RCR1I4AWli57PleeLNdxvQnHOAF8RQGQonbAT923GDZUK2j2gw==
X-Received: by 2002:a50:fd05:: with SMTP id i5mr1319881eds.181.1644578334990;
        Fri, 11 Feb 2022 03:18:54 -0800 (PST)
Received: from [192.168.0.99] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id j20sm2367935ejo.27.2022.02.11.03.18.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 03:18:54 -0800 (PST)
Message-ID: <bcaec716-52ec-1db9-e123-b9e59f41b2f3@canonical.com>
Date:   Fri, 11 Feb 2022 12:18:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] dt-bindings: can: xilinx_can: Convert Xilinx CAN binding
 to YAML
Content-Language: en-US
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        appana.durga.rao@xilinx.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org
Cc:     git@xilinx.com, naga.sureshkumar.relli@xilinx.com,
        michal.simek@xilinx.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220208155209.25926-1-amit.kumar-mahapatra@xilinx.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220208155209.25926-1-amit.kumar-mahapatra@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/02/2022 16:52, Amit Kumar Mahapatra wrote:
> Convert Xilinx CAN binding documentation to YAML.
> 
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
> ---
> BRANCH: yaml
> ---
>  .../bindings/net/can/xilinx_can.txt           |  61 --------
>  .../bindings/net/can/xilinx_can.yaml          | 146 ++++++++++++++++++
>  2 files changed, 146 insertions(+), 61 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt
>  create mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/can/xilinx_can.txt b/Documentation/devicetree/bindings/net/can/xilinx_can.txt
> deleted file mode 100644
> index 100cc40b8510..000000000000
> --- a/Documentation/devicetree/bindings/net/can/xilinx_can.txt
> +++ /dev/null
> @@ -1,61 +0,0 @@
> -Xilinx Axi CAN/Zynq CANPS controller Device Tree Bindings
> ----------------------------------------------------------
> -
> -Required properties:
> -- compatible		: Should be:
> -			  - "xlnx,zynq-can-1.0" for Zynq CAN controllers
> -			  - "xlnx,axi-can-1.00.a" for Axi CAN controllers
> -			  - "xlnx,canfd-1.0" for CAN FD controllers
> -			  - "xlnx,canfd-2.0" for CAN FD 2.0 controllers
> -- reg			: Physical base address and size of the controller
> -			  registers map.
> -- interrupts		: Property with a value describing the interrupt
> -			  number.
> -- clock-names		: List of input clock names
> -			  - "can_clk", "pclk" (For CANPS),
> -			  - "can_clk", "s_axi_aclk" (For AXI CAN and CAN FD).
> -			  (See clock bindings for details).
> -- clocks		: Clock phandles (see clock bindings for details).
> -- tx-fifo-depth		: Can Tx fifo depth (Zynq, Axi CAN).
> -- rx-fifo-depth		: Can Rx fifo depth (Zynq, Axi CAN, CAN FD in
> -                          sequential Rx mode).
> -- tx-mailbox-count	: Can Tx mailbox buffer count (CAN FD).
> -- rx-mailbox-count	: Can Rx mailbox buffer count (CAN FD in mailbox Rx
> -			  mode).
> -
> -
> -Example:
> -
> -For Zynq CANPS Dts file:
> -	zynq_can_0: can@e0008000 {
> -			compatible = "xlnx,zynq-can-1.0";
> -			clocks = <&clkc 19>, <&clkc 36>;
> -			clock-names = "can_clk", "pclk";
> -			reg = <0xe0008000 0x1000>;
> -			interrupts = <0 28 4>;
> -			interrupt-parent = <&intc>;
> -			tx-fifo-depth = <0x40>;
> -			rx-fifo-depth = <0x40>;
> -		};
> -For Axi CAN Dts file:
> -	axi_can_0: axi-can@40000000 {
> -			compatible = "xlnx,axi-can-1.00.a";
> -			clocks = <&clkc 0>, <&clkc 1>;
> -			clock-names = "can_clk","s_axi_aclk" ;
> -			reg = <0x40000000 0x10000>;
> -			interrupt-parent = <&intc>;
> -			interrupts = <0 59 1>;
> -			tx-fifo-depth = <0x40>;
> -			rx-fifo-depth = <0x40>;
> -		};
> -For CAN FD Dts file:
> -	canfd_0: canfd@40000000 {
> -			compatible = "xlnx,canfd-1.0";
> -			clocks = <&clkc 0>, <&clkc 1>;
> -			clock-names = "can_clk", "s_axi_aclk";
> -			reg = <0x40000000 0x2000>;
> -			interrupt-parent = <&intc>;
> -			interrupts = <0 59 1>;
> -			tx-mailbox-count = <0x20>;
> -			rx-fifo-depth = <0x20>;
> -		};
> diff --git a/Documentation/devicetree/bindings/net/can/xilinx_can.yaml b/Documentation/devicetree/bindings/net/can/xilinx_can.yaml
> new file mode 100644
> index 000000000000..cdf2e4a20662
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/xilinx_can.yaml
> @@ -0,0 +1,146 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/xilinx_can.yaml#

Filename: xilinx,can.yaml to match common format.

> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title:
> +  Xilinx Axi CAN/Zynq CANPS controller Binding
> +
> +maintainers:
> +  - Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - const: xlnx,zynq-can-1.0
> +        description: For Zynq CAN controller
> +      - const: xlnx,axi-can-1.00.a
> +        description: For Axi CAN controller
> +      - const: xlnx,canfd-1.0
> +        description: For CAN FD controller
> +      - const: xlnx,canfd-2.0
> +        description: For CAN FD 2.0 controller

This should be enum, not oneOf. Any reason for using oneOf?

> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    description: |
> +      CAN functional clock phandle
> +    maxItems: 2

1. minItems
2. You miss clock-names.

> +
> +  tx-fifo-depth:
> +    description: |
> +      CAN Tx fifo depth (Zynq, Axi CAN).

Non-standard fields need type. Here and in all other places.

> +
> +  rx-fifo-depth:
> +    description: |
> +      CAN Rx fifo depth (Zynq, Axi CAN, CAN FD in sequential Rx mode)
> +
> +  tx-mailbox-count:
> +    description: |
> +      CAN Tx mailbox buffer count (CAN FD)
> +
> +  rx-mailbox-count:
> +    description: |
> +      CAN Rx mailbox buffer count (CAN FD in mailbox Rx  mode)
> +
> +  clock-names:
> +    maxItems: 2

Oh... here are the clock-names.... why sorted randomly?

> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - clock-names
> +
> +additionalProperties: false
> +
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: xlnx,zynq-can-1.0
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
> +            const: xlnx,axi-can-1.00.a
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
> +            const: xlnx,canfd-1.0
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
> +    can@e0008000 {
> +        compatible = "xlnx,zynq-can-1.0";
> +        clocks = <&clkc 19>, <&clkc 36>;
> +        clock-names = "can_clk", "pclk";
> +        reg = <0xe0008000 0x1000>;
> +        interrupts = <0 28 4>;

Isn't it a regular GIC interrupt? If yes, use defines instead of
hard-coded values.

> +        interrupt-parent = <&intc>;
> +        tx-fifo-depth = <0x40>;
> +        rx-fifo-depth = <0x40>;
> +    };

Blank line.

> +  - |
> +    axi-can@40000000 {

Generic node name, so "can".

> +        compatible = "xlnx,axi-can-1.00.a";
> +        clocks = <&clkc 0>, <&clkc 1>;
> +        clock-names = "can_clk","s_axi_aclk" ;
> +        reg = <0x40000000 0x10000>;
> +        interrupt-parent = <&intc>;
> +        interrupts = <0 59 1>;
> +        tx-fifo-depth = <0x40>;
> +        rx-fifo-depth = <0x40>;
> +    };

Blank line.

> +  - |
> +    canfd@40000000 {

Generic node name, so "can".

> +        compatible = "xlnx,canfd-1.0";
> +        clocks = <&clkc 0>, <&clkc 1>;
> +        clock-names = "can_clk", "s_axi_aclk";
> +        reg = <0x40000000 0x2000>;
> +        interrupt-parent = <&intc>;
> +        interrupts = <0 59 1>;
> +        tx-mailbox-count = <0x20>;
> +        rx-fifo-depth = <0x20>;
> +    };


Best regards,
Krzysztof
