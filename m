Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6AE64373C
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbiLEVo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbiLEVo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:44:26 -0500
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B3F38A2;
        Mon,  5 Dec 2022 13:42:37 -0800 (PST)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-1445ca00781so8487636fac.1;
        Mon, 05 Dec 2022 13:42:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y3FyNfYivQwMLOF6RUZwmkn/sgZ3GskW73HlQfJ4j1s=;
        b=HZy6SjmfjR1Csxsp+pdPNfvepDFGxO065IbxAaCuGjON8RkAeAF95CaMczX9ZOuit7
         oRxyVvA/MgQmr7sUK4ljZBs5x5u3mzI7eh7SJdskHJYOZYSaZj8b/CY1H6pXWS+zzG5T
         UGcCDDju87HTRS1+57KDMXkiL9hRdkSAicK+iS0v22o6OQhBYXnNGRh2Bh3QuQa0Z985
         XrrxQ5u1WxnXJXYfQ/DPmIUKR3H9UCmoGybWDC3GscMPwjBZE5FWRtyvkJCI3hOAt41v
         6HrXM2ON3hLiukdw35B0kbAR8T81wakAeNHYizOu30cEBxwGj7zR0lOUyV1ArD0z5cvG
         2Tpw==
X-Gm-Message-State: ANoB5pn2mrN7vG2cY1+1OWuebug95D+ac12An3n85VAoZmh3Op0S1bTq
        q82c2PpwjJkpKhDA5ncnjg==
X-Google-Smtp-Source: AA0mqf5lL0R7+W+RHjbcvEkN74SVEW9xDKe8Lo/rK/nX1nK5gtfCsbsVFuNwy7AFbJIFsEkverQ85w==
X-Received: by 2002:a05:6870:179d:b0:13a:fa4a:27d0 with SMTP id r29-20020a056870179d00b0013afa4a27d0mr37686866oae.255.1670276556697;
        Mon, 05 Dec 2022 13:42:36 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 123-20020aca0781000000b0035028730c90sm7616822oih.1.2022.12.05.13.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 13:42:36 -0800 (PST)
Received: (nullmailer pid 2675372 invoked by uid 1000);
        Mon, 05 Dec 2022 21:42:35 -0000
Date:   Mon, 5 Dec 2022 15:42:35 -0600
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-mediatek@lists.infradead.org,
        George McCollister <george.mccollister@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        linux-arm-kernel@lists.infradead.org,
        John Crispin <john@phrozen.org>, UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?B?LG7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-renesas-soc@vger.kernel.org, Marek Vasut <marex@denx.de>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v4 net-next 5/9] dt-bindings: net: dsa: qca8k: utilize
 shared dsa.yaml
Message-ID: <167027655461.2675313.2465931055798706710.robh@kernel.org>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
 <20221202204559.162619-6-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202204559.162619-6-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 02 Dec 2022 12:45:55 -0800, Colin Foster wrote:
> The dsa.yaml binding contains duplicated bindings for address and size
> cells, as well as the reference to dsa-port.yaml. Instead of duplicating
> this information, remove the reference to dsa-port.yaml and include the
> full reference to dsa.yaml.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> 
> v3 -> v4
>   * Add Reviewed tag
>   * Remove unnecessary blank line deletion
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
>  Documentation/devicetree/bindings/net/dsa/qca8k.yaml | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
