Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999D16BA026
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 20:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjCNT5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 15:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjCNT5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 15:57:20 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29E84616F
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 12:57:18 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id r11so15143562edd.5
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 12:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678823837;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aORkeEWyO4el94Bv6We6yy/BW+bw5NjQvuZusdWHXhw=;
        b=gr18aPzM5zECvOkClsBTCdIMXKpwux+V1a6gMKvaYD7cxf8xfCzZFnwTplfRbntBe+
         pBvDyOSmdKO8kWrmxOskVrIOGRk9Pex1nzNb0goa0jkia5LwixA+rneqPQM3iQfp0C51
         s2EefWp9yN8cUY3QUv4nuKg6X8aM+WgZwDvIhcbzshhyPV4dqqSz9fXz9w6t6M+8lHf1
         I+biZuTX+mYJBpYz4OZ8zOAFr99syPdi6A+eboC3FsZBfm+fU3psVzJD0aePAq5n4LZU
         CQ3lVGIYOMc+LaWysoxc+lTzEw5+z/DKx3Gw4IqFNa9O9x/b53pkMtJIPBifAyfHBcP7
         vw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678823837;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aORkeEWyO4el94Bv6We6yy/BW+bw5NjQvuZusdWHXhw=;
        b=dMo8ieATwP9c0U5LeHBHkLLxc4tCl2yD4+mcyuBA1qoDYCawjvz4FKApc8qiZobO/7
         pJJEKKhZKVGfhzcfhukWILuoA5qcl245d4JabSA4y43YtCIjxjNYGyjYraNHZ7iV2zo0
         Xfm44jsjeYO+Pikh3HY1F0ahfCgncpg5oRzmHwb9tUxl25JElZK9J6nm1qPb0Ey+EKV2
         uoRGAM4/HvAXM8kS15NJ8kT99nAhUj+lvoJiRoj0yZnt5Z2Ed8CzgGyUgTKsAw8ipMdb
         sbnQ04r3jMM0g6X6OleuwLuHxS4SQfz5j5/fkrJL5olCi7iThNDc37uIsnRoCNDqDK55
         NCqg==
X-Gm-Message-State: AO0yUKWYsF7bNnyCiHUASyNjw4hKjmMEgc5An3b1XLgAhPrEq7ISU6SB
        myt2phzNpRyDOt36OrnPudK46Q==
X-Google-Smtp-Source: AK7set/XAW5ciHQcJno6hH/Z88UfN6YapdX8vcLUOlfdJ3yyprHp0j3qR3GzULGcqsy5r/vRByYzFQ==
X-Received: by 2002:a17:906:a0e:b0:91e:acf4:b009 with SMTP id w14-20020a1709060a0e00b0091eacf4b009mr4068970ejf.22.1678823837351;
        Tue, 14 Mar 2023 12:57:17 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:642b:87c2:1efc:c8af? ([2a02:810d:15c0:828:642b:87c2:1efc:c8af])
        by smtp.gmail.com with ESMTPSA id c37-20020a509fa8000000b004fb17f10326sm1514478edf.10.2023.03.14.12.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 12:57:16 -0700 (PDT)
Message-ID: <4ac809d2-3924-3839-479f-0b4be9f18a1f@linaro.org>
Date:   Tue, 14 Mar 2023 20:57:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] p54spi: convert to devicetree
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        linux-gpio@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Felipe Balbi <balbi@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?UTF-8?Q?Beno=c3=aet_Cousson?= <bcousson@baylibre.com>,
        Russell King <linux@armlinux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20230314163201.955689-1-arnd@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230314163201.955689-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2023 17:30, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The Prism54 SPI driver hardcodes GPIO numbers and expects users to
> pass them as module parameters, apparently a relic from its life as a
> staging driver. This works because there is only one user, the Nokia
> N8x0 tablet.
> 
> Convert this to the gpio descriptor interface and move the gpio
> line information into devicetree to improve this and simplify the
> code at the same time.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> As I don't have an N8x0, this is completely untested.
> 
> I listed the driver authors (Johannes and Christian) as the maintainers
> of the binding document, but I don't know if they actually have this
> hardware. It might be better to list someone who is actually using it.
> 
> Among the various chip identifications, I wasn't sure which one to
> use for the compatible string and the name of the binding document.
> I picked st,stlc4560 as that was cited as the version in the N800
> on multiple websites.
> ---
>  .../bindings/net/wireless/st,stlc45xx.yaml    | 64 +++++++++++++++++

Please split bindings to separate patch.

>  MAINTAINERS                                   |  1 +
>  arch/arm/boot/dts/omap2.dtsi                  |  4 ++
>  arch/arm/boot/dts/omap2420-n8x0-common.dtsi   | 12 ++++

DTS as well...

>  arch/arm/mach-omap2/board-n8x0.c              | 18 -----
>  drivers/net/wireless/intersil/p54/p54spi.c    | 69 +++++++------------
>  drivers/net/wireless/intersil/p54/p54spi.h    |  3 +
>  7 files changed, 109 insertions(+), 62 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/st,stlc45xx.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/st,stlc45xx.yaml b/Documentation/devicetree/bindings/net/wireless/st,stlc45xx.yaml
> new file mode 100644
> index 000000000000..45bc4fab409a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/st,stlc45xx.yaml
> @@ -0,0 +1,64 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/wireless/st,stlc45xx.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: ST/Intersil/Conexant stlc45xx/p54spi/cx3110x SPI wireless device
> +
> +maintainers:
> +  - Johannes Berg <johannes@sipsolutions.net>
> +  - Christian Lamparter <chunkeey@web.de>
> +
> +description: |

You can drop '|'.

> +  The SPI variant of the Intersil Prism54 wireless device was sold
> +  under a variety of names, including ST Microelectronics STLC5460
> +  and Conexant CX3110x.
> +
> +allOf:
> +  - $ref: ieee80211.yaml#
> +  - $ref: /schemas/spi/spi-peripheral-props.yaml#
> +
> +properties:
> +  compatible:
> +    enum:
> +      - st,stlc4550
> +      - st,stlc4560
> +      - isil,p54spi
> +      - cnxt,3110x

Order above entries by name.

> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  power-gpios:

If this is GPIO driving some power pin, then it should be
"powerdown-gpios" (like in /bindings/gpio/gpio-consumer-common.yaml)

> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +   gpio {

Align example with above |, so four spaces. Or better indent entire
example with four spaces.

> +     gpio-controller;
> +     #gpio-cells = <1>;
> +     #interupt-cells = <1>;
> +   };

Drop "gpio" node. It's not needed for the example.

> +   spi {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +
> +      wifi@0 {
> +        reg = <0>;
> +        compatible = "st,stlc4560";

compatible before reg.

> +        spi-max-frequency = <48000000>;
> +        interrupts-extended = <&gpio 23>;
> +        power-gpios = <&gpio 1>;
> +     };
> +   };

Best regards,
Krzysztof

