Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2044C58E0C3
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 22:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245586AbiHIUMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 16:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343914AbiHIUMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 16:12:05 -0400
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41A5240AF;
        Tue,  9 Aug 2022 13:12:03 -0700 (PDT)
Received: by mail-io1-f52.google.com with SMTP id v185so10485116ioe.11;
        Tue, 09 Aug 2022 13:12:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=iGYCnu/+0HqcH4tfufizkhmIGeG4o6QBo9lBG1d5OQ8=;
        b=RF22QeCfHYWpROAGjTNMDmNRlRDWEufe1OX7QPazJBLGeEgHwo4YiLE0jiPfETgdeP
         e/u9rcByddUwB7v3MM4A4SPl11pCbAiT40C4HmBX5fEKW08Jk/jDGjDOhlihDTmCP46K
         gtXhvo79EiT3nCKVpqfoNflLP2sw/5LswbK8w1oA0IKMcjaMuV5BTjjHFeEvBrfPWzGa
         4krIwTha3AIxF1dDam1u7MuJHnntaaQxBsmtCcpb+Ep+5LzY5HQ/6phAt16iw/ylUurQ
         k2ULDuXjCSoWKrUQsmPHI6Vw1YmcR0QSeGu1tLbM9SwSUyMoXypkQv81DVFDoq11MWTb
         zVvA==
X-Gm-Message-State: ACgBeo2ebACJVKJp3luJZbYR5FzWw0xz5RnMRZ4n9Mmso4Xi89GeWdyN
        J+fMJ20ujGweJ9HLIzlMSg==
X-Google-Smtp-Source: AA6agR5Qst/eIQ8/xLYMwvH9yeGU5D6Vf0TMw4Pd8I8O9lscYOsM0Z6NtDruvuek+k69L4EeEGs8Hw==
X-Received: by 2002:a6b:ba88:0:b0:681:a46e:ce22 with SMTP id k130-20020a6bba88000000b00681a46ece22mr10179302iof.183.1660075922888;
        Tue, 09 Aug 2022 13:12:02 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id c11-20020a056638028b00b0033f11276715sm6681995jaq.132.2022.08.09.13.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 13:12:02 -0700 (PDT)
Received: (nullmailer pid 2312982 invoked by uid 1000);
        Tue, 09 Aug 2022 20:11:57 -0000
Date:   Tue, 9 Aug 2022 14:11:57 -0600
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, netdev@vger.kernel.org,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        George McCollister <george.mccollister@gmail.com>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        devicetree@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-renesas-soc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Crispin <john@phrozen.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Landen Chao <Landen.Chao@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Mans Rullgard <mans@mansr.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [RFC PATCH v3 net-next 05/10] dt-bindings: net: dsa: rzn1-a5psw:
 add missing CPU port phy-mode to example
Message-ID: <20220809201157.GA2312930-robh@kernel.org>
References: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
 <20220806141059.2498226-6-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220806141059.2498226-6-vladimir.oltean@nxp.com>
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

On Sat, 06 Aug 2022 17:10:54 +0300, Vladimir Oltean wrote:
> To prevent warnings during "make dt_bindings_check" after dsa-port.yaml
> will make phylink properties mandatory, add phy-mode = "internal" to the
> example.
> 
> This new property is taken straight out of the SoC dtsi at
> arch/arm/boot/dts/r9a06g032.dtsi, so it seems likely that only the
> example needs to be fixed, rather than DT blobs in circulation.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v2->v3: patch is new
> 
>  .../devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml         | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
