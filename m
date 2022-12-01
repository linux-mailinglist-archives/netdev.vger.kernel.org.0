Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E9963FAC4
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 23:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiLAWnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 17:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbiLAWms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 17:42:48 -0500
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105FD2CE35;
        Thu,  1 Dec 2022 14:42:43 -0800 (PST)
Received: by mail-oi1-f179.google.com with SMTP id c129so3680012oia.0;
        Thu, 01 Dec 2022 14:42:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QSoJgBw7gvJKRqtJPwGF8TC9wXnUbl77+8hQ4HnaDNg=;
        b=2Ca8LwsXVD3/x3TAnmkzUnlAegttIwE4WUSXGVhS2tbuPZEtOC+BCPxlCneNTTBHaS
         2SQycET5Dlerp97Gpz1bKF6RfZ8GVjSOZF/UItRnQx4bD5Cd6HcDMkQOhKHESwWZbg3D
         jYfMGjVxmXrNNA0WYhnjGDkLKAytjsRAb6wZGbxU3gBqxzop0kJGZhJ2ar4BltANJHmm
         rlwXfNFF7Vr6z3nytioK1aN3G8tY4THA2vxZKYXjPStanitJyT7fqxFCzxVlXhVBs/5/
         rLxcNTUPmuDPM9ABBlwLPoFy0hKhKWG9zQmY7GeunGepnoH8GLR7r3JqXz9MaGWla0I8
         NX2Q==
X-Gm-Message-State: ANoB5pl0fJZlPL1ZEc9iqzfRSiD0srqOp+fddieeET4VkX3/NnW/azb0
        p/zFfBHSLdrDRb0yeyeOzA==
X-Google-Smtp-Source: AA0mqf7svA0cxObJDPcHKDecL0TjB4LXILyHf3dlg0pDOqySswFXalFd1Qb1ROCnAafNRLIhvA0gbg==
X-Received: by 2002:a05:6808:7c1:b0:35a:eee1:6716 with SMTP id f1-20020a05680807c100b0035aeee16716mr24058254oij.173.1669934562232;
        Thu, 01 Dec 2022 14:42:42 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id f97-20020a9d03ea000000b0066c41be56e7sm2617464otf.55.2022.12.01.14.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 14:42:41 -0800 (PST)
Received: (nullmailer pid 1578165 invoked by uid 1000);
        Thu, 01 Dec 2022 22:42:40 -0000
Date:   Thu, 1 Dec 2022 16:42:40 -0600
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
Subject: Re: [PATCH v3 net-next 05/10] dt-bindings: net: dsa: qca8k: utilize
 shared dsa.yaml
Message-ID: <20221201224240.GA1565974-robh@kernel.org>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-6-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221127224734.885526-6-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 27, 2022 at 02:47:29PM -0800, Colin Foster wrote:
> The dsa.yaml binding contains duplicated bindings for address and size
> cells, as well as the reference to dsa-port.yaml. Instead of duplicating
> this information, remove the reference to dsa-port.yaml and include the
> full reference to dsa.yaml.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> ---
> 
> v2 -> v3
>   * Remove #address-cells and #size-cells from v2. The examples were
>     incorrect and fixed elsewhere.
>   * Remove erroneous unevaluatedProperties: true under Ethernet Port.
>   * Add back ref: dsa-port.yaml#.
> 
> v1 -> v2
>   * Add #address-cells and #size-cells to the switch layer. They aren't
>     part of dsa.yaml.
>   * Add unevaluatedProperties: true to the ethernet-port layer so it can
>     correctly read properties from dsa.yaml.
> 
> ---
>  Documentation/devicetree/bindings/net/dsa/qca8k.yaml | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> index 6fc9bc985726..93a9ddebcac8 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> @@ -66,20 +66,15 @@ properties:
>                   With the legacy mapping the reg corresponding to the internal
>                   mdio is the switch reg with an offset of -1.
>  
> +$ref: "dsa.yaml#"
> +
>  patternProperties:
>    "^(ethernet-)?ports$":
>      type: object
> -    properties:
> -      '#address-cells':
> -        const: 1
> -      '#size-cells':
> -        const: 0
> -
>      patternProperties:
>        "^(ethernet-)?port@[0-6]$":
>          type: object
>          description: Ethernet switch ports
> -
>          $ref: dsa-port.yaml#

So here you need 'unevaluatedProperties: false'.

unevaluatedProperties only applies to the properties defined in a single 
node level, and child nodes properties from 2 schemas can't 'see' each 
other. IOW, what dsa.yaml has in child nodes has no effect on this node. 

>  
>          properties:
> @@ -116,7 +111,7 @@ required:
>    - compatible
>    - reg
>  
> -additionalProperties: true
> +unevaluatedProperties: false

So this has no effect on anything within "^(ethernet-)?port@[0-6]$" and 
below.

Rob
