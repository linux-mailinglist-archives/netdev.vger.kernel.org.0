Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF93D63FA85
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 23:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiLAWZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 17:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiLAWYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 17:24:51 -0500
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F7A8D648;
        Thu,  1 Dec 2022 14:24:47 -0800 (PST)
Received: by mail-ot1-f49.google.com with SMTP id s9-20020a05683004c900b0066e7414466bso1872517otd.12;
        Thu, 01 Dec 2022 14:24:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LpWRHTmVhm2s7NkcuBRmMhNUH73cqPk0NBvzmuTS558=;
        b=xhwDTdc+o7/7NIKEumFIrQsO6xdc0sZTMyqgjyafudrWDLbuuqZ9DDx4tY5UdZ292x
         jw3w8bKHkVam/vTA+E7kgnc94ghzpVvAyke4xnrJ+KwYBAsBn9KNH+TnXYBGrCtp+SZO
         KKk7BhrOdzi2pG3xSyW3oIfaHbR5QLUZbjDNFRfHX6kwGTyEZLDpdp0n4dXAuHjXu8WF
         Y/U/gnpLu519Mtxwszzeg1UvWq9sZ46hxCSGSdkpwBBJTgyU9l/GEATl0UWNhCVgBsAk
         lXMKuThDXHI6b3SSrLUyrzXB0s7uxKLIEWevSuRSa77hWXZRYx6A+8QsGvJQ5RYWdtzW
         BYiw==
X-Gm-Message-State: ANoB5plm/DYQeFbMonVK+qJtBXmwAc+Nincy0BK9pNlVOB9NJt/EN/po
        YNKx9nnfNd1e8abWLS3LUw==
X-Google-Smtp-Source: AA0mqf412a4wYEQetqAAzqAyOQt/Mf3sAGn6eCUrPWEixr5txkptgCbRV+bxMQOTawyQj+8LmqUuWQ==
X-Received: by 2002:a9d:6a05:0:b0:66c:703f:d5a4 with SMTP id g5-20020a9d6a05000000b0066c703fd5a4mr26685522otn.290.1669933486469;
        Thu, 01 Dec 2022 14:24:46 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id c6-20020a9d4806000000b0066c15490a55sm2645528otf.19.2022.12.01.14.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 14:24:46 -0800 (PST)
Received: (nullmailer pid 1554712 invoked by uid 1000);
        Thu, 01 Dec 2022 22:24:44 -0000
Date:   Thu, 1 Dec 2022 16:24:44 -0600
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        devicetree@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        ", Eric Dumazet" <edumazet@google.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com, Marek Vasut <marex@denx.de>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        John Crispin <john@phrozen.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 net-next 02/10] dt-bindings: net: dsa: qca8k: remove
 address-cells and size-cells from switch node
Message-ID: <166993348424.1554653.6511937074374406374.robh@kernel.org>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-3-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221127224734.885526-3-colin.foster@in-advantage.com>
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


On Sun, 27 Nov 2022 14:47:26 -0800, Colin Foster wrote:
> The children of the switch node don't have a unit address, and therefore
> should not need the #address-cells or #size-cells entries. Fix the example
> schemas accordingly.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v3
>   * New patch
> 
> ---
>  Documentation/devicetree/bindings/net/dsa/qca8k.yaml | 4 ----
>  1 file changed, 4 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
