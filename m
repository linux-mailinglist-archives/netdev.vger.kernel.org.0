Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969E56BA090
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbjCNUTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjCNUTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:19:01 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4FB22039;
        Tue, 14 Mar 2023 13:18:58 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id eg48so7772302edb.13;
        Tue, 14 Mar 2023 13:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678825137;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9SB+BZ9VlItZGYcgdFLvcDeLn9V7Ni7FQjQccgDvwrY=;
        b=g2hoRZekVEYCAA8AduTtlGx8aHEyEgxe2KGWlhuvqT/NzAGwGTGmjtYrbLRKUkj/wC
         ixN4tLnGKw0EOf6XQVFTAKUO0PSuxqrCr1IKFlTpzQnWIBBZT7Sgeis4gCQE7LHrIYdO
         qkV5VwvwitJQnZ4FlccFrAGfsk2nVIPv+MPA1MyP5qzyVI4kYlqCujyASvQAveQ4FPeY
         B5dlrTebAbQ9+DZTk+1PEWHk5D9a37BcqwGleAtP6gxghkvyDbkLp9UxLWqBnBE/ZZYU
         4Jca3ivZyIdkvJCcAEVWcV0ewYECKMOey4nEsh/eLKxzvCJoQKoEKSQq6sc/5CjUgEn2
         mU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678825137;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9SB+BZ9VlItZGYcgdFLvcDeLn9V7Ni7FQjQccgDvwrY=;
        b=4v+/wHrLPJLvwZ8h7l38/3Fsu1ldwjosraBmnkcSzbkx4oWlnZMcxuElHndTHZL0UV
         AT/dCLzQDBPC7jpXVfEJI/WplHpk1ozRp7mIThaDZpLTiKrL5//Opc/+RFooZSL6rUoc
         dgIm/p+tbOoGCyWMFT+agJ++Vn6ziDffXjCZEyyvMYFRLlHeSMbHNrPnPmFD2BcrLXdR
         y0c84AIj5XkNY59c4fELpDkTsZyeTSEBWhyIrnxIUX8H776W1Ny+AQFSeiDbGvWsLpI+
         l6yMNed4AYZH4zQqipndDMP+LwOtK2Ghs4rfI/y3vpcf9pnvaao10I88vfAByJUT4gYw
         na2Q==
X-Gm-Message-State: AO0yUKUwsJkLAuG41gO75hr/CvoIEEOi2+Y08f8OF79PQj5iggCASlcJ
        5WELFWY2QfdlM1HERrun2FU=
X-Google-Smtp-Source: AK7set+Az0JnVlYyAujOmgXmvxHSPGWN2t4HQaFP5dCEv4IGXZVHl2FMuV5ikQn6E1nGZaa7D6LW/A==
X-Received: by 2002:a17:906:c047:b0:926:8992:4310 with SMTP id bm7-20020a170906c04700b0092689924310mr4316468ejb.38.1678825136545;
        Tue, 14 Mar 2023 13:18:56 -0700 (PDT)
Received: from shift (pd9e2911a.dip0.t-ipconnect.de. [217.226.145.26])
        by smtp.gmail.com with ESMTPSA id dt5-20020a170906b78500b008e82cb55195sm1543714ejb.203.2023.03.14.13.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 13:18:56 -0700 (PDT)
Received: from localhost ([127.0.0.1])
        by shift with esmtp (Exim 4.96)
        (envelope-from <chunkeey@gmail.com>)
        id 1pcB4d-000AO6-1G;
        Tue, 14 Mar 2023 21:18:55 +0100
Message-ID: <e8dc9acb-6f85-e0a9-a145-d101ca6da201@gmail.com>
Date:   Tue, 14 Mar 2023 21:18:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] p54spi: convert to devicetree
To:     Arnd Bergmann <arnd@kernel.org>, Kalle Valo <kvalo@kernel.org>
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
Content-Language: de-DE
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20230314163201.955689-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 3/14/23 17:30, Arnd Bergmann wrote:
> The Prism54 SPI driver hardcodes GPIO numbers and expects users to
> pass them as module parameters, apparently a relic from its life as a
> staging driver. This works because there is only one user, the Nokia
> N8x0 tablet.
> 
> Convert this to the gpio descriptor interface and move the gpio
> line information into devicetree to improve this and simplify the
> code at the same time.

Yes, this is definitely the right idea/way. From what I remember, Kalle
Valo was partially involved in p54spi/stlc45xx. The details are very fuzzy.
So,  I could be totally wrong. From what I remember Kalle was working
for Nokia (or as a contractor for Nokia?) at the time.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I've seen the device-tree comments. That said, this is/was overdue.
You can definitely have this for a v2 :).
Acked-by: Christian Lamparter <chunkeey@gmail.com>

Thanks you!
Christian

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
>   .../bindings/net/wireless/st,stlc45xx.yaml    | 64 +++++++++++++++++
>   MAINTAINERS                                   |  1 +
>   arch/arm/boot/dts/omap2.dtsi                  |  4 ++
>   arch/arm/boot/dts/omap2420-n8x0-common.dtsi   | 12 ++++
>   arch/arm/mach-omap2/board-n8x0.c              | 18 -----
>   drivers/net/wireless/intersil/p54/p54spi.c    | 69 +++++++------------
>   drivers/net/wireless/intersil/p54/p54spi.h    |  3 +
>   7 files changed, 109 insertions(+), 62 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/net/wireless/st,stlc45xx.yaml
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
Can you please change that to: Christian Lamparter <chunkeey@gmail.com> ?
(the @web.de/googlemail.com address still work too, but they are now just
forwarding)

> +description: |
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
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  power-gpios:
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
> +     gpio-controller;
> +     #gpio-cells = <1>;
> +     #interupt-cells = <1>;
> +   };
> +   spi {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +
> +      wifi@0 {
> +        reg = <0>;
> +        compatible = "st,stlc4560";
> +        spi-max-frequency = <48000000>;
> +        interrupts-extended = <&gpio 23>;
> +        power-gpios = <&gpio 1>;
> +     };
> +   };

