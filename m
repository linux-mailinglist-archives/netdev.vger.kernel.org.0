Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81094643725
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbiLEVnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233994AbiLEVma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:42:30 -0500
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E2D2D1CB;
        Mon,  5 Dec 2022 13:42:12 -0800 (PST)
Received: by mail-ot1-f52.google.com with SMTP id s30-20020a056830439e00b0067052c70922so1312924otv.11;
        Mon, 05 Dec 2022 13:42:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=At/Iy89jbSM+uM6oAL5A4QbrrbFSKepIZsFF2MdZt+I=;
        b=AWAUbJDpnVUh56HB46rATCN01SoA5EjjByMGabv5rrqUpBXPZax1BeB5EvHespkX8I
         gDu2vTQx52VjV8JxaRhu+YIsgVnWyKsg5hPUx1PfZdfJ55RAqU2IVXBWAjAYTzc2/fr2
         knHF105pMhVjcJWQaP9GgR/TcZgN4B+SbMwWz8pQHhKtof1H5SpWtVUWr6lIBYb3cPvV
         Oa5U61uCmNmiIIVLUSjQ61vcX6AVxsEEapZDyQuF6fGo4AcMEAxYBDp2ervUgQdch9ui
         TKy4gbJHitK5boU5FZkn6/vE+vGxh2KyNdxn9ywZISRGBz05Ri8Ol3Q3F20Bz48PUTDq
         B2pA==
X-Gm-Message-State: ANoB5pkxJ0kApDpclWuLM+YxhPcDZXDW+SRTIhm75OLq1Wc5IG771fhE
        LG7UM3M9sQt2WdnsFEP5bQ==
X-Google-Smtp-Source: AA0mqf6kj1GoiLDfY3xtoeuyCtevhKeHsvjbFdh4JVs9EO/VSyl7R6SPPnX8FN/JLUwlfcWHCl3skQ==
X-Received: by 2002:a9d:7751:0:b0:637:1464:cebf with SMTP id t17-20020a9d7751000000b006371464cebfmr41256218otl.100.1670276531645;
        Mon, 05 Dec 2022 13:42:11 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id b24-20020a9d5d18000000b0066da36d2c45sm8233897oti.22.2022.12.05.13.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 13:42:11 -0800 (PST)
Received: (nullmailer pid 2674599 invoked by uid 1000);
        Mon, 05 Dec 2022 21:42:10 -0000
Date:   Mon, 5 Dec 2022 15:42:10 -0600
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Marek Vasut <marex@denx.de>, UNGLinuxDriver@microchip.com,
        John Crispin <john@phrozen.org>, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Eric Dumazet <edumazet@google.com>, devicetree@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        ", DENG Qingfang" <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH v4 net-next 3/9] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Message-ID: <167027652411.2674430.15313904791062984653.robh@kernel.org>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
 <20221202204559.162619-4-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221202204559.162619-4-colin.foster@in-advantage.com>
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


On Fri, 02 Dec 2022 12:45:53 -0800, Colin Foster wrote:
> DSA switches can fall into one of two categories: switches where all ports
> follow standard '(ethernet-)?port' properties, and switches that have
> additional properties for the ports.
> 
> The scenario where DSA ports are all standardized can be handled by
> swtiches with a reference to the new 'dsa.yaml#/$defs/ethernet-ports'.
> 
> The scenario where DSA ports require additional properties can reference
> '$dsa.yaml#' directly. This will allow switches to reference these standard
> defitions of the DSA switch, but add additional properties under the port
> nodes.
> 
> Suggested-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Acked-by: Alvin Šipraga <alsi@bang-olufsen.dk> # realtek
> ---
> 
> v3 -> v4
>   * Rename "$defs/base" to "$defs/ethernet-ports" to avoid implication of a
>     "base class" and fix commit message accordingly
>   * Add the following to the common etherent-ports node:
>       "additionalProperties: false"
>       "#address-cells" property
>       "#size-cells" property
>   * Fix "etherenet-ports@[0-9]+" to correctly be "ethernet-port@[0-9]+"
>   * Remove unnecessary newline
>   * Apply changes to mediatek,mt7530.yaml that were previously in a separate patch
>   * Add Reviewed and Acked tags
> 
> v3
>   * New patch
> 
> ---
>  .../bindings/net/dsa/arrow,xrs700x.yaml       |  2 +-
>  .../devicetree/bindings/net/dsa/brcm,b53.yaml |  2 +-
>  .../devicetree/bindings/net/dsa/dsa.yaml      | 25 ++++++++++++++++---
>  .../net/dsa/hirschmann,hellcreek.yaml         |  2 +-
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 16 +++---------
>  .../bindings/net/dsa/microchip,ksz.yaml       |  2 +-
>  .../bindings/net/dsa/microchip,lan937x.yaml   |  2 +-
>  .../bindings/net/dsa/mscc,ocelot.yaml         |  2 +-
>  .../bindings/net/dsa/nxp,sja1105.yaml         |  2 +-
>  .../devicetree/bindings/net/dsa/realtek.yaml  |  2 +-
>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |  2 +-
>  11 files changed, 35 insertions(+), 24 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
