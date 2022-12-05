Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CA8643739
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbiLEVoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbiLEVn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:43:28 -0500
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F552D77D;
        Mon,  5 Dec 2022 13:42:24 -0800 (PST)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-1322d768ba7so15086666fac.5;
        Mon, 05 Dec 2022 13:42:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PNGr0I77rqwyAC8AXud43K7iOEl8cm1zQzmCR6XwoTA=;
        b=v8uB9poEjkO2y3zmcUdDNIze/TafNWODQ7KqC9mJhz0CnwYe/sXGrVkZidjjLDUqpV
         M6PolbzAa6uX3ypTWXO4OxjCFueMy80eqeCoZN3pRlH6bn4NqqW5NM1GN1xjeWO68K5Q
         bLZgqDi6CmJx7nrBzZQMwek8Jp35VHKdKdBqpEGjcXlN0+a3ktiDo4KpmH/wnW6c0VIP
         Gq7SgdXJ/9fa2wDRboO+fDyMVsuEJ95KeFqEfh3dZ/1MZviy/iyfySZVs0+Y7fyCs5Ts
         pSItRC1bzw7BuBXr6XS39OOMy0hSQr8U6ibnipPIFZGaRIlxnsKXiphTkblKKIDAUHHV
         4mLA==
X-Gm-Message-State: ANoB5pkFPpn/VkmFfB3sK9plonRj38IdGTX9mmlIMY2945RY26YDP2aw
        gGqD4flNf7dwH7z9usfMgg==
X-Google-Smtp-Source: AA0mqf7hwLNcWO6bZt8FX+2pOdAAkaDRY2N5Cp1AwZT3A0cQlaZQR1AeANmbE7FqmKtksp2OPcT/og==
X-Received: by 2002:a05:6870:3b8f:b0:144:2395:41b9 with SMTP id gi15-20020a0568703b8f00b00144239541b9mr10882014oab.294.1670276543724;
        Mon, 05 Dec 2022 13:42:23 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id bh8-20020a056830380800b006621427ecc7sm8120175otb.60.2022.12.05.13.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 13:42:23 -0800 (PST)
Received: (nullmailer pid 2674969 invoked by uid 1000);
        Mon, 05 Dec 2022 21:42:22 -0000
Date:   Mon, 5 Dec 2022 15:42:22 -0600
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Landen Chao <Landen.Chao@mediatek.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        linux-mediatek@lists.infradead.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-renesas-soc@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        John Crispin <john@phrozen.org>, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        ", Kurt Kanzenbach" <kurt@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Marek Vasut <marex@denx.de>,
        =?UTF-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH v4 net-next 4/9] dt-bindings: net: dsa: allow additional
 ethernet-port properties
Message-ID: <167027654137.2674912.5511174194632704012.robh@kernel.org>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
 <20221202204559.162619-5-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202204559.162619-5-colin.foster@in-advantage.com>
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


On Fri, 02 Dec 2022 12:45:54 -0800, Colin Foster wrote:
> Explicitly allow additional properties for both the ethernet-port and
> ethernet-ports properties. This specifically will allow the qca8k.yaml
> binding to use shared properties.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> 
> v3 -> v4
>   * Change ethernet-ports node to have "unevaluatedProperties: false"
>     instead of "additionalProperties: true"
>   * Change ethernet-port node to have "additionalProperties: true" instead
>     of "unevaluatedProperties: true"
>   * Add Reviewed tag
> 
> v2 -> v3
>   * No change
> 
> v1 -> v2
>   * New patch
> 
> ---
>  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
