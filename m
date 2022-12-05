Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E69643756
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbiLEVuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiLEVtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:49:47 -0500
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7EDA7643;
        Mon,  5 Dec 2022 13:47:49 -0800 (PST)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-14449b7814bso10147295fac.3;
        Mon, 05 Dec 2022 13:47:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mjzds2RzECUq1xcqjJsP8nfg2ZPV+dnkXlgwu7if9PE=;
        b=t+gfM+a6ADFjr169f1qZXmh2Y+iLccK8cb6xXtYsc2lWB/vGHbQCwAnVGLnl9ysD3s
         UIxfhqlw94va1T67ZXrwD9tN3rzGD6HbeVipduEDKWXxUA5WWqJ8LyCkNESNr6V6a8FD
         vWUF3eiHvV83ANoj5kRw7eQF9O4FMa1GN1grg+KGmdxfg6OtX0iWmW+WjqH7cBUH6Q0W
         FAo5A2rc4wBwsDfOwNrvNUc0FzLhKlDjAKISmAYzB1cJRGJ4GeJk5q/ESJmR7RGlm+lf
         +nXkan0sTHJfBZuUlceXRT4YOidnQxir/0FJ/UPAQ1AaF1QDvCx3qMFGC6ybKQr2BTB3
         YM5w==
X-Gm-Message-State: ANoB5pmazc9ZaZMXjmHQ+AitrhBj+TLHibHNVEB8dKszix/z/AEbC+gr
        b36U9LsndKeBDssJu+29gw==
X-Google-Smtp-Source: AA0mqf4QO8UMt6OJ+ls46GBA4Vjcws9My+eLdy2ZBabpLPBkFaP2SMxFEfNh2jRUy5s9QIaB0EhSmg==
X-Received: by 2002:a05:6870:7988:b0:13c:84e6:96d2 with SMTP id he8-20020a056870798800b0013c84e696d2mr4030384oab.72.1670276869061;
        Mon, 05 Dec 2022 13:47:49 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id y7-20020a4ac407000000b0049ea9654facsm7064489oop.32.2022.12.05.13.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 13:47:48 -0800 (PST)
Received: (nullmailer pid 2682645 invoked by uid 1000);
        Mon, 05 Dec 2022 21:47:47 -0000
Date:   Mon, 5 Dec 2022 15:47:47 -0600
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
Subject: Re: [PATCH v4 net-next 7/9] dt-bindings: net: add generic
 ethernet-switch
Message-ID: <20221205214747.GA2679200-robh@kernel.org>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
 <20221202204559.162619-8-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202204559.162619-8-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 12:45:57PM -0800, Colin Foster wrote:
> The dsa.yaml bindings had references that can apply to non-dsa switches. To
> prevent duplication of this information, keep the dsa-specific information
> inside dsa.yaml and move the remaining generic information to the newly
> created ethernet-switch.yaml.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> 
> v3 -> v4
>   * Update ethernet-ports and ethernet-port nodes to match what the new
>     dsa.yaml has. Namely:
>       "unevaluatedProperties: false" instead of "additionalProperties: true"
>       "additionalProperties: true" instead of "unevaluatedProperties: true"
>     for ethernet-ports and ethernet-port, respectively.
>   * Add Florian Reviewed tag
> 
> v2 -> v3
>   * Change ethernet-switch.yaml title from "Ethernet Switch Device
>     Tree Bindings" to "Generic Ethernet Switch"
>   * Rework ethernet-switch.yaml description
>   * Add base defs structure for switches that don't have any additional
>     properties.
>   * Add "additionalProperties: true" under "^(ethernet-)?ports$" node
>   * Correct port reference from /schemas/net/dsa/dsa-port.yaml# to
>     ethernet-controller.yaml#
> 
> v1 -> v2
>   * No net change, but deletions from dsa.yaml included the changes for
>     "addionalProperties: true" under ports and "unevaluatedProperties:
>     true" under port.
> 
> ---
>  .../devicetree/bindings/net/dsa/dsa.yaml      | 28 +-------
>  .../bindings/net/ethernet-switch.yaml         | 66 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  3 files changed, 69 insertions(+), 26 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> index 5081f4979f1b..843205ea722d 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> @@ -18,6 +18,8 @@ description:
>  
>  select: false
>  
> +$ref: "/schemas/net/ethernet-switch.yaml#"

You can drop quotes here.

With that,

Reviewed-by: Rob Herring <robh@kernel.org>

This is a nice clean-up.

Rob
