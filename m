Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FEC58E0CA
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 22:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239279AbiHIUMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 16:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245425AbiHIUMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 16:12:43 -0400
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06CC1A041;
        Tue,  9 Aug 2022 13:12:42 -0700 (PDT)
Received: by mail-io1-f54.google.com with SMTP id 68so3852615iou.2;
        Tue, 09 Aug 2022 13:12:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=2S4gHgCzeKx3rsprRQrYWjwhMs+dYZT9zKQ8myXpKKo=;
        b=VjBD+PPw4nCSoi9mOhiXgobCDRxpjf4GR0Ib3iAekOueV9p45SEs30gAvLEk+wpgTI
         RybWC+E2Cw04mKaTPiMbgH1NfQJcMcjKvLhpzEyOEpZkdbpe91Qm8KQVSvVkSrz1veaR
         eo560wuaGQyqKIvR8u2/Mv+bwC28YPmS0a9O6jiop0oqxClaaHc74bg2uW2tVo3dHmbV
         f1W9PV1iGnvGa/Kgw5e3Y42o5i+AtsjZbj3sSjlXgG9ozCocF26aCjcgD9l/GMI6Ih1Z
         w6ePJajY13bMYcOPNfTfJgM+XVc09XNHtGBnQcShoezUv+4W9FksbJVFkCQY4XouWX1L
         GAfw==
X-Gm-Message-State: ACgBeo1rjrNYjJxqZLeTefVN7qtRq7USdFI/WkqbHvaVTPRA66LweSgW
        BYEAThWiPsCRFgkq2tNiKQ==
X-Google-Smtp-Source: AA6agR5qhHkStSfTAX8Vbjn1ZGp7rzbiHGpxeho3BOYk+JNvqlVS5dP0qzhlr4+y0qwKX+uzL9q/AQ==
X-Received: by 2002:a02:9997:0:b0:342:7631:be49 with SMTP id a23-20020a029997000000b003427631be49mr11222504jal.39.1660075960558;
        Tue, 09 Aug 2022 13:12:40 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id f1-20020a028481000000b003426eb18d1dsm6653730jai.105.2022.08.09.13.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 13:12:40 -0700 (PDT)
Received: (nullmailer pid 2314197 invoked by uid 1000);
        Tue, 09 Aug 2022 20:12:35 -0000
Date:   Tue, 9 Aug 2022 14:12:35 -0600
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        John Crispin <john@phrozen.org>, Marek Vasut <marex@denx.de>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Woojung Huh <woojung.huh@microchip.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com, Marcin Wojtas <mw@semihalf.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Mans Rullgard <mans@mansr.com>
Subject: Re: [RFC PATCH v3 net-next 07/10] of: base: export
 of_device_compatible_match() for use in modules
Message-ID: <20220809201235.GA2314138-robh@kernel.org>
References: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
 <20220806141059.2498226-8-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220806141059.2498226-8-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 06 Aug 2022 17:10:56 +0300, Vladimir Oltean wrote:
> Modules such as net/dsa/dsa_core.ko might want to iterate through an
> array of compatible strings for things such as validation (or rather,
> skipping it for some potentially broken drivers).
> 
> of_device_is_compatible() is exported, by of_device_compatible_match()
> isn't. Export the latter as well, so we don't have to open-code the
> iteration.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Frank Rowand <frowand.list@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v1->v2: patch is new
> v2->v3: none
> 
>  drivers/of/base.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
