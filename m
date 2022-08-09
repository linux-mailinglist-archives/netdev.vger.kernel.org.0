Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7AE58E0BD
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 22:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244724AbiHIULw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 16:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244714AbiHIULt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 16:11:49 -0400
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28033252BA;
        Tue,  9 Aug 2022 13:11:48 -0700 (PDT)
Received: by mail-il1-f182.google.com with SMTP id p9so5909372ilq.13;
        Tue, 09 Aug 2022 13:11:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=+9Al/NVh4mkaew/fjthVmDnX9GMBVGMc//f+obA48/o=;
        b=74uOfa0xZlJwdibar1AYVw3P+ASu9lZcOLKcnG4s0GsWKLbjCsL8p192Isr5vzdPvs
         FhfgigMwaiORWs+ceN98Q+6GY+fKCheUbV17aRfivm4RiMqAerb+hMTJGlXvwbJoKgTv
         M+T1s8ga3HtuRcXFXxCX2pBuXI3/tIBamq+uOixXFHJ3V6jeaNCXAkGQDrvTr++owR3b
         dRV/V0WK6mAQhjRhiIek9vG55PTRQrNB3REOfrSLu0AKyTztBvTwbXzCcBSRsHEGpLl6
         x3DorCq0vj+Tm+TRHZ93S+KOPEB2nyiBHrsmJia17G0SgmW8gsIn6jnOCBVjMao3Edl2
         Mxpg==
X-Gm-Message-State: ACgBeo2Xj5bmk/DpPyoUA1NcSpT0puvudxvo0mG4KVKVBAwSDYQ2V0Ap
        4tL28BBq0O7+gmnvkUmS+Q==
X-Google-Smtp-Source: AA6agR6zU2QL6f+v0fRJ8B5OxHQZ/q5sS3zP7j5tp7HWp4QfNVwsB9eCAZOMV+7gZc2CCbKopPeI6w==
X-Received: by 2002:a05:6e02:219e:b0:2de:c6a5:5638 with SMTP id j30-20020a056e02219e00b002dec6a55638mr10255392ila.210.1660075907266;
        Tue, 09 Aug 2022 13:11:47 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id g3-20020a92c7c3000000b002de42539fddsm1373864ilk.68.2022.08.09.13.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 13:11:46 -0700 (PDT)
Received: (nullmailer pid 2312325 invoked by uid 1000);
        Tue, 09 Aug 2022 20:11:42 -0000
Date:   Tue, 9 Aug 2022 14:11:42 -0600
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        UNGLinuxDriver@microchip.com, devicetree@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andrew Lunn <andrew@lunn.ch>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Kurt Kanzenbach <kurt@linutronix.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        John Crispin <john@phrozen.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marek Vasut <marex@denx.de>, Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        linux-renesas-soc@vger.kernel.org, Mans Rullgard <mans@mansr.com>,
        George McCollister <george.mccollister@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [RFC PATCH v3 net-next 03/10] dt-bindings: net: dsa: b53: add
 missing CPU port phy-mode to example
Message-ID: <20220809201142.GA2312298-robh@kernel.org>
References: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
 <20220806141059.2498226-4-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220806141059.2498226-4-vladimir.oltean@nxp.com>
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

On Sat, 06 Aug 2022 17:10:52 +0300, Vladimir Oltean wrote:
> Looking at b53_srab_phylink_get_caps() I get no indication of what PHY
> modes does port 8 support, since it is implemented circularly based on
> the p->mode retrieved from the device tree (and in PHY_INTERFACE_MODE_NA
> it reports nothing to supported_interfaces).
> 
> However if I look at the b53_switch_chips[] element for BCM58XX_DEVICE_ID,
> I see that port 8 is the IMP port, and SRAB means the IMP port is
> internal to the SoC. So use phy-mode = "internal" in the example.
> 
> Note that this will make b53_srab_phylink_get_caps() go through the
> "default" case and report PHY_INTERFACE_MODE_INTERNAL to
> supported_interfaces, which is probably a good thing.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v2->v3: patch is new
> 
>  Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
