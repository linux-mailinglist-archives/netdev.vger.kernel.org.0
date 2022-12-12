Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2EB564A5A7
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 18:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbiLLRNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 12:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbiLLRNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 12:13:36 -0500
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ECA12759;
        Mon, 12 Dec 2022 09:13:35 -0800 (PST)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-144b21f5e5fso9145210fac.12;
        Mon, 12 Dec 2022 09:13:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AGUdmy+g/qTasB/RYlCtkR0cf44cupB5Kch7orL6C8k=;
        b=KPMawPKOn7178HUm02T17nvqcMDHKcmyW2QsRoR5jA3EaXm3U9Wjw6HHRp/LvkBHxT
         9WW8yfH3GQ1Zr/r712R6WhUhRv5Gbb1H+HO6V6SGCaAJNoHmqL1hYli1xXabKwi5DMO0
         YFlzJXICm8Xucl7hV2e2yP5XyPKHPYBeub+k+NFuavzNnOnw6fzEzPK79ERviRUmb+K8
         UnEm3e9fljo/GPkqnL5CayP/wnF4bRWnl9mKouXELHwab2zHQSukCSnNWLCdoVZFDp07
         6LZ1KstNAdNOo6wIaMyxFjYHRV57+ZTr9iikkggvIjkQcPxyrUScZdau2KmP8R6mBjBi
         +odA==
X-Gm-Message-State: ANoB5plPNdKKYPCTUCpuZGnUXXM17eSzbGBEXFhvED+hS94UP6cGgD9H
        24JwndaxclrYMxMek9QPWg==
X-Google-Smtp-Source: AA0mqf4TgLSi1nA9lDe/di5Hok12V+737QACa0Nu2l7rV/UJ4b97Gx0ku7i4xI0Vm0f3uz83kDKy1A==
X-Received: by 2002:a05:6870:9123:b0:144:d2bd:f6ac with SMTP id o35-20020a056870912300b00144d2bdf6acmr9120964oae.43.1670865215081;
        Mon, 12 Dec 2022 09:13:35 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id ba35-20020a056870c5a300b0013b9ee734dcsm155255oab.35.2022.12.12.09.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 09:13:34 -0800 (PST)
Received: (nullmailer pid 1147754 invoked by uid 1000);
        Mon, 12 Dec 2022 17:13:33 -0000
Date:   Mon, 12 Dec 2022 11:13:33 -0600
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        ", Eric Dumazet" <edumazet@google.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        linux-renesas-soc@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mediatek@lists.infradead.org,
        Kurt Kanzenbach <kurt@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        DENG Qingfang <dqfext@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        John Crispin <john@phrozen.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        =?UTF-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH v5 net-next 01/10] dt-bindings: dsa: sync with maintainers
Message-ID: <167086521259.1147694.13128574954492521303.robh@kernel.org>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-2-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221210033033.662553-2-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 09 Dec 2022 19:30:24 -0800, Colin Foster wrote:
> The MAINTAINERS file has Andrew Lunn, Florian Fainelli, and Vladimir Oltean
> listed as the maintainers for generic dsa bindings. Update dsa.yaml and
> dsa-port.yaml accordingly.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> 
> ---
> 
> v5
>   * New patch
> 
> ---
>  Documentation/devicetree/bindings/net/dsa/dsa-port.yaml | 2 +-
>  Documentation/devicetree/bindings/net/dsa/dsa.yaml      | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
