Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9786258E0C0
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 22:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245499AbiHIUL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 16:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244714AbiHIULz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 16:11:55 -0400
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9E4252BA;
        Tue,  9 Aug 2022 13:11:54 -0700 (PDT)
Received: by mail-io1-f50.google.com with SMTP id l24so10487863ion.13;
        Tue, 09 Aug 2022 13:11:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=T69D2tuf/Zb04X+HXywr6FOGAZATIEwTGKk/Wy7xIiQ=;
        b=1ZWsqEy4P7zKL/bkylIoE7YJJ3JKgvgOsDgKgpNEPOghHs9HAH98NFfy0+pwHOeTtN
         8ZuVKwh6XDa5W54x6aO2oO1IdTZh7y7VJT+rXw3thL8RftFLCLxj0n8hDen1Tz4pyVgR
         E8w09WnQ97Ctxm3mGvxXWV69jTO91C7UT0Cc/G79XVm1pR3d/rltwTI95HtsnxWJdPxx
         mzOlUUMSIDaHHDd5HjTWSP6b6+xMGlsrfs9SM1OiFNaI1VIieADY62lUTOx5KiZp18yu
         cUbFdwxOzsryylGwCmWXi/CdFkdH9TacpwuYvMaCc+xJwvZ/QsszH2awqRECTdZKCbNE
         /4NQ==
X-Gm-Message-State: ACgBeo28MZ+Q0xtIQdy3AQ4ZX8j+lcwV/SUfJQxMqpm4x7OL2N6XDqiY
        O6GCd16NaPSd+DHj7tOJxw==
X-Google-Smtp-Source: AA6agR502lLntu8olvprYwu+vWVFaPZ/whWwevZvbZfSxSD3wwpQBq4nslJQ6BrDLOqGlKKw09BUjg==
X-Received: by 2002:a05:6638:3791:b0:342:a327:798b with SMTP id w17-20020a056638379100b00342a327798bmr11332371jal.102.1660075913262;
        Tue, 09 Aug 2022 13:11:53 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id m3-20020a02a143000000b0034278894fccsm6623549jah.90.2022.08.09.13.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 13:11:52 -0700 (PDT)
Received: (nullmailer pid 2312628 invoked by uid 1000);
        Tue, 09 Aug 2022 20:11:48 -0000
Date:   Tue, 9 Aug 2022 14:11:48 -0600
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Mans Rullgard <mans@mansr.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-renesas-soc@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com,
        George McCollister <george.mccollister@gmail.com>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        DENG Qingfang <dqfext@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        devicetree@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: Re: [RFC PATCH v3 net-next 04/10] dt-bindings: net: dsa: microchip:
 add missing CPU port phy-mode to example
Message-ID: <20220809201148.GA2312573-robh@kernel.org>
References: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
 <20220806141059.2498226-5-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220806141059.2498226-5-vladimir.oltean@nxp.com>
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

On Sat, 06 Aug 2022 17:10:53 +0300, Vladimir Oltean wrote:
> The ksz_switch_chips[] element for KSZ9477 says that port 5 is an xMII
> port and it supports speeds of 10/100/1000. The device tree example does
> declare a fixed-link at 1000, and RGMII is the only one of those modes
> that supports this speed, so use this phy-mode.
> 
> The microchip,ksz8565 compatible string is not supported by the
> microchip driver, however on Microchip's product page it says that there
> are 5 ports, 4 of which have internal PHYs and the 5th is an
> MII/RMII/RGMII port. It's a bit strange that this is port@6, but it is
> probably just the way it is. Select an RGMII phy-mode for this one as
> well.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v2->v3: patch is new
> 
>  Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
