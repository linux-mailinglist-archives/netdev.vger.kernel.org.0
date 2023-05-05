Return-Path: <netdev+bounces-636-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E88F46F8B0D
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 23:29:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CD3D2810CB
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 21:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EB9DD305;
	Fri,  5 May 2023 21:29:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF6B2F33
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 21:29:52 +0000 (UTC)
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7A5DF;
	Fri,  5 May 2023 14:29:51 -0700 (PDT)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-18f4a6d2822so20160837fac.1;
        Fri, 05 May 2023 14:29:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683322191; x=1685914191;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HFeDUyo6AKuXS79TAn9Cc44Tads4aooewVV9T4r6M0g=;
        b=dZyPWFywv32sonGj/fAdNDXMxS3ceDkBqPG/W0Pn1QkowDFTfjqIAYxwrdT7qTCnPr
         Qakn+Ecegs2igeWnW+cDw79ATc4oE8y0X7hu7yHsC61qY/rKvZ+wV2KYlxZyQX5+HBbn
         TcmVG++8ZNJpWc7ax5uuhImvQBsnF1cLlakouWT3cYvivMqCBI3ygl7yH2iZhPsDRlLd
         0kHm3BA6Xe7eLXdx8mMAe5B0SvVA4h9VwvxF3vrVXpsoTBpN9MGXlNYZJyHj8V3HKd7t
         sxhvE3FIc8odS8kaM2dJ7HJbk2fc0DxvHlBOdhry/MouBaQk76v4F3v12ACsjLAVE9fQ
         W6Ng==
X-Gm-Message-State: AC+VfDyoYDaG+6BRq28RdVCtJVEDwVeSWfJSgxReBnkioPTldAhajKJC
	vFXxveDooSB+tGPGhfW9zw==
X-Google-Smtp-Source: ACHHUZ7aycN1QluDBhyWe/IUee4uCc1VOdrIKAR+AJ7bfwvk/TZdgDz4IwmG4Ng6bzcWJOffABFmaA==
X-Received: by 2002:a05:6871:7a4:b0:192:6fdd:6e36 with SMTP id o36-20020a05687107a400b001926fdd6e36mr3229320oap.17.1683322190696;
        Fri, 05 May 2023 14:29:50 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t1-20020a9d7f81000000b006a62aac5736sm1369180otp.28.2023.05.05.14.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 14:29:49 -0700 (PDT)
Received: (nullmailer pid 3595549 invoked by uid 1000);
	Fri, 05 May 2023 21:29:48 -0000
Date: Fri, 5 May 2023 16:29:48 -0500
From: Rob Herring <robh@kernel.org>
To: Judith Mendez <jm@ti.com>
Cc: Chandrasekar Ramakrishnan <rcsekar@samsung.com>, Wolfgang Grandegger <wg@grandegger.com>, Marc Kleine-Budde <mkl@pengutronix.de>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>, Vignesh Raghavendra <vigneshr@ti.com>, Tero Kristo <kristo@kernel.org>, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>, Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v4 1/4] dt-bindings: net: can: Add poll-interval for MCAN
Message-ID: <20230505212948.GA3590042-robh@kernel.org>
References: <20230501224624.13866-1-jm@ti.com>
 <20230501224624.13866-2-jm@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230501224624.13866-2-jm@ti.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
	FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 01, 2023 at 05:46:21PM -0500, Judith Mendez wrote:
> On AM62x SoC, MCANs on MCU domain do not have hardware interrupt
> routed to A53 Linux, instead they will use software interrupt by
> hrtimer. To enable timer method, interrupts should be optional so
> remove interrupts property from required section and introduce
> poll-interval property.
> 
> Signed-off-by: Judith Mendez <jm@ti.com>
> ---
> Changelog:
> v3:
>  1. Move binding patch to first in series
>  2. Update description for poll-interval
>  3. Add oneOf to specify using interrupts/interrupt-names or poll-interval
>  4. Fix example property: add comment below 'example'
> 
> v2:
>   1. Add poll-interval property to enable timer polling method
>   2. Add example using poll-interval property
>   
>  .../bindings/net/can/bosch,m_can.yaml         | 36 +++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> index 67879aab623b..c024ee49962c 100644
> --- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> +++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> @@ -14,6 +14,13 @@ maintainers:
>  allOf:
>    - $ref: can-controller.yaml#
>  
> +oneOf:
> +  - required:
> +      - interrupts
> +      - interrupt-names
> +  - required:
> +      - poll-interval

Move this next to 'required'.

> +
>  properties:
>    compatible:
>      const: bosch,m_can
> @@ -40,6 +47,14 @@ properties:
>        - const: int1
>      minItems: 1
>  
> +  poll-interval:
> +    $ref: /schemas/types.yaml#/definitions/flag

This is a common property already defined as a uint32. You shouldn't 
define a new type.

A flag doesn't even make sense. If that's all you need, then just enable 
polling if no interrupt is present.

> +    description: Enable hrtimer polling method for an M_CAN device.
> +      If this property is defined in MCAN node, it tells the driver to
> +      enable polling method for an MCAN device. If for an MCAN device,
> +      hardware interrupt is found and hrtimer polling method is enabled,

What's hrtimer? (Don't put Linuxisms in bindings)

> +      the driver will use hardware interrupt method.
> +
>    clocks:
>      items:
>        - description: peripheral clock
> @@ -122,8 +137,6 @@ required:
>    - compatible
>    - reg
>    - reg-names
> -  - interrupts
> -  - interrupt-names
>    - clocks
>    - clock-names
>    - bosch,mram-cfg
> @@ -132,6 +145,7 @@ additionalProperties: false
>  
>  examples:
>    - |
> +    // Example with interrupts
>      #include <dt-bindings/clock/imx6sx-clock.h>
>      can@20e8000 {
>        compatible = "bosch,m_can";
> @@ -149,4 +163,22 @@ examples:
>        };
>      };
>  
> +  - |
> +    // Example with timer polling
> +    #include <dt-bindings/clock/imx6sx-clock.h>
> +    can@20e8000 {
> +      compatible = "bosch,m_can";
> +      reg = <0x020e8000 0x4000>, <0x02298000 0x4000>;
> +      reg-names = "m_can", "message_ram";
> +      poll-interval;
> +      clocks = <&clks IMX6SX_CLK_CANFD>,
> +               <&clks IMX6SX_CLK_CANFD>;
> +      clock-names = "hclk", "cclk";
> +      bosch,mram-cfg = <0x0 0 0 32 0 0 0 1>;
> +
> +      can-transceiver {
> +        max-bitrate = <5000000>;
> +      };
> +    };
> +
>  ...
> -- 
> 2.17.1
> 

