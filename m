Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC6E63B5CC
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbiK1XXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234570AbiK1XXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:23:42 -0500
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BEE31370;
        Mon, 28 Nov 2022 15:23:40 -0800 (PST)
Received: by mail-oi1-f175.google.com with SMTP id l127so13387665oia.8;
        Mon, 28 Nov 2022 15:23:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q5dZdPYvUfozQhqkmlonGbI8EniXavdtqXfZRx36D18=;
        b=2KUzR/rGh13yVKqBidaKmBq5efLqvZrqTa33r+JL0hZsPyszKtu1WRZpeHJ3L7jaFZ
         xedyCXP/fgAkPoQIXiskvOABEjU4lo3lfFcmS7YLIc02za3e5Pe1AxjBe/WqwAv+OpR9
         HQlUrPKo9PUOVVm30SbncSs0/IsvUKU3CcByyiqeK15jlZvyAtayciK7gAgWeuVYSCQ/
         /wY7iY5SwEtozI/nGsoCuezQFowxjEICw/bsr788qODWIaz2YlWOUZ0dtr/Jk2NiMegJ
         xr4NsQKj7B7YIa3d/tnhB+OmCOO/uFmvrXI4gfMTwY+hqlcQuwAGw87ABWUEDAhci+cX
         /UGg==
X-Gm-Message-State: ANoB5pmwlp3m6EM3HwJD7DCit0g5KfDewDWD3PMEo3I7xnGt9ygbKTDQ
        mXcGf897XyXvzGt5I6OGXg==
X-Google-Smtp-Source: AA0mqf6Xi0RitObRTHWEfRmcg3CLjY1g6LEw6t9+uwWWjYPmvv4KJPFIiDn1ezDuYbdQF9T8u3CZeQ==
X-Received: by 2002:aca:c108:0:b0:354:946b:f72f with SMTP id r8-20020acac108000000b00354946bf72fmr19606267oif.48.1669677820060;
        Mon, 28 Nov 2022 15:23:40 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id m25-20020a056870059900b001422f9b5c17sm6565028oap.8.2022.11.28.15.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 15:23:39 -0800 (PST)
Received: (nullmailer pid 1685201 invoked by uid 1000);
        Mon, 28 Nov 2022 23:23:37 -0000
Date:   Mon, 28 Nov 2022 17:23:37 -0600
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v3 net-next 03/10] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Message-ID: <20221128232337.GA1513198-robh@kernel.org>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-4-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221127224734.885526-4-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 27, 2022 at 02:47:27PM -0800, Colin Foster wrote:
> DSA switches can fall into one of two categories: switches where all ports
> follow standard '(ethernet-)?port' properties, and switches that have
> additional properties for the ports.
> 
> The scenario where DSA ports are all standardized can be handled by
> swtiches with a reference to 'dsa.yaml#'.
> 
> The scenario where DSA ports require additional properties can reference
> the new '$dsa.yaml#/$defs/base'. This will allow switches to reference
> these base defitions of the DSA switch, but add additional properties under
> the port nodes.

You have this backwards. '$dsa.yaml#/$defs/base' can't be extended. 
Perhaps '$defs/ethernet-ports' would be a better name.

> 
> Suggested-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v3
>   * New patch
> 
> ---
>  .../bindings/net/dsa/arrow,xrs700x.yaml       |  2 +-
>  .../devicetree/bindings/net/dsa/brcm,b53.yaml |  2 +-
>  .../devicetree/bindings/net/dsa/dsa.yaml      | 19 ++++++++++++++++---
>  .../net/dsa/hirschmann,hellcreek.yaml         |  2 +-
>  .../bindings/net/dsa/mediatek,mt7530.yaml     |  2 +-
>  .../bindings/net/dsa/microchip,ksz.yaml       |  2 +-
>  .../bindings/net/dsa/microchip,lan937x.yaml   |  2 +-
>  .../bindings/net/dsa/mscc,ocelot.yaml         |  2 +-
>  .../bindings/net/dsa/nxp,sja1105.yaml         |  2 +-
>  .../devicetree/bindings/net/dsa/realtek.yaml  |  2 +-
>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |  2 +-
>  11 files changed, 26 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> index 259a0c6547f3..8d5abb05abdf 100644
> --- a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> @@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: Arrow SpeedChips XRS7000 Series Switch Device Tree Bindings
>  
>  allOf:
> -  - $ref: dsa.yaml#
> +  - $ref: dsa.yaml#/$defs/base
>  
>  maintainers:
>    - George McCollister <george.mccollister@gmail.com>
> diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> index 1219b830b1a4..f323fc01b224 100644
> --- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> @@ -66,7 +66,7 @@ required:
>    - reg
>  
>  allOf:
> -  - $ref: dsa.yaml#
> +  - $ref: dsa.yaml#/$defs/base
>    - if:
>        properties:
>          compatible:
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> index b9d48e357e77..bd1f0f7c14a8 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> @@ -19,9 +19,6 @@ description:
>  select: false
>  
>  properties:
> -  $nodename:
> -    pattern: "^(ethernet-)?switch(@.*)?$"
> -
>    dsa,member:
>      minItems: 2
>      maxItems: 2
> @@ -58,4 +55,20 @@ oneOf:
>  
>  additionalProperties: true
>  
> +$defs:
> +  base:
> +    description: A DSA switch without any extra port properties
> +    $ref: '#/'
> +
> +    patternProperties:
> +      "^(ethernet-)?ports$":

This node at the top level needs 'additionalProperties: false' assuming 
we don't allow extra properties in 'ports' nodes. If we do, then we'll 
need to be able to reference the 'ports' schema to extend it like is 
done with dsa-ports.yaml.

> +        type: object
> +
> +        patternProperties:
> +          "^(ethernet-)?ports@[0-9]+$":
> +            description: Ethernet switch ports
> +            $ref: dsa-port.yaml#
> +            unevaluatedProperties: false
> +
> +

One blank line.

>  ...
