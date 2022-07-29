Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55693585360
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 18:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbiG2QXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 12:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiG2QXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 12:23:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C65326DC
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 09:23:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5F0C61B29
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 16:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFCBC4314A
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 16:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659111783;
        bh=wEGZb3Dh/y5RPDMdWtcPYequ/bwQxkYZVROdIi5Q1Qk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CYDTgbIzjEeiQa9kJuJL2A0Bdj2ZQwVg7HDL5px4Rpt8Y/xdHKS78Q33+5e43a6nC
         dkUU4m+aYYZVWeik6uI9WwiHcgBTl//yDPXMZxiPfE3uYCgG5JCpIrQoU2aHUcVyua
         Ggm5xDzdz8mj2yDJezpsN6+H+YfTRAWr7k8VXMFnLCnc3pIPNE2Fe8PKmR+G9aYSa7
         IMEGfZkH6Zxzmi115yrUa/w9rJ1ZNqGelcTDg5o8Rj7ea8KF0QDSsgp+j4wQYRJD1b
         07kDWQ5hBgUId+CiXFSr/1I3+joiD3UTR5Mibgx2bCtJ1Ptk8E/6UDAShAm6Hs+vMR
         mB5NVd00kUqQw==
Received: by mail-vs1-f45.google.com with SMTP id 125so5055949vsd.5
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 09:23:02 -0700 (PDT)
X-Gm-Message-State: AJIora/cyERyvd4jYa8yAGlznu5WRMT1aBTVZQ/T96291kKALvx0Cm2V
        wbCadiDs4oawQU9nr5hNPSRknr/o41u+eas8cQ==
X-Google-Smtp-Source: AGRyM1sl9yx2cOG9ppvBwbYhZ+bhIDeQrH5KJa0V66iBXLNQLiTpvKBZIqZzDjWDqooui2cVDres2ItDpwYQwIMlzG0=
X-Received: by 2002:a67:c18d:0:b0:358:5bb6:2135 with SMTP id
 h13-20020a67c18d000000b003585bb62135mr1549740vsj.53.1659111781857; Fri, 29
 Jul 2022 09:23:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com> <20220729132119.1191227-5-vladimir.oltean@nxp.com>
In-Reply-To: <20220729132119.1191227-5-vladimir.oltean@nxp.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 29 Jul 2022 10:22:49 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJJBDC9_RbJwUSs5Q-OjWJDSA=8GTXyfZ4LdYijB-AqqA@mail.gmail.com>
Message-ID: <CAL_JsqJJBDC9_RbJwUSs5Q-OjWJDSA=8GTXyfZ4LdYijB-AqqA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Frank Rowand <frowand.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 7:21 AM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> There is a desire coming from Russell King to make all DSA drivers
> register unconditionally with phylink, to simplify the code paths:
> https://lore.kernel.org/netdev/YtGPO5SkMZfN8b%2Fs@shell.armlinux.org.uk/
>
> However this is not possible today without risking to break drivers
> which rely on a different mechanism, that where ports are manually
> brought up to the highest link speed during setup, and never touched by
> phylink at runtime.
>
> This happens because DSA was not always integrated with phylink, and
> when the early drivers were converted from platform data to the new DSA
> bindings, there was no information kept in the platform data structures
> about port link speeds, so as a result, there was no information
> translated into the first DT bindings.
>
> https://lore.kernel.org/all/YtXFtTsf++AeDm1l@lunn.ch/
>
> Today we have a workaround in place, introduced by commit a20f997010c4
> ("net: dsa: Don't instantiate phylink for CPU/DSA ports unless needed"),
> where shared ports would be checked for the presence of phy-handle/
> fixed-link/managed OF properties, and if missing, phylink registration
> would be skipped.
>
> We modify the logic of this workaround such as to stop the proliferation
> of more port OF nodes with lacking information, to put an upper bound to
> the number of switches for which a link management description must be
> faked in order for phylink registration to become possible for them.
>
> Today we have drivers introduced years after the phylink migration of
> CPU/DSA ports, and yet we're still not completely sure whether all new
> drivers use phylink, because this depends on dynamic information
> (DT blob, which may very well not be upstream, because why would it).
> Driver maintainers may even be unaware about the fact that omitting
> fixed-link/phy-handle for CPU/DSA ports is legal, and even works with
> some of the old pre-phylink drivers.
>
> Add central validation in DSA for the OF properties required by phylink,
> in an attempt to sanitize the environment for future driver writers, and
> as much as possible for existing driver maintainers.

It's not the kernel's job to validate the DT. If it was, it does a
horrible job. Is the schema providing this validation? If not, you
need to add it.

Rob
