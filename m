Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D102586CC8
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 16:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbiHAO0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 10:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbiHAO0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 10:26:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89182871F
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 07:26:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B85536135D
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 14:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F1AC43147
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 14:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659364003;
        bh=VJ+yBmunTCGga69iMDX/p4W9JnV0RhpdQuM8jOFTJSs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XVXMKy4To9P3A6sjuScyrpxH+cTwRV1s0Fso4pk7G6OP1MT6T62qZXXxS1AZwexaZ
         SkYkr4md5srZWoX5izDmipWfsn7/GUIesRUzzXGpe9eAcjCqknzojQ7gXAkCFW8bid
         A+M3y6Fjhq3DzUYOrt9ujHyvZZjo3E2KeKjlqI/8b8WTuQdpc9k5M2SwU3zG97K2Mk
         f86mZDx8T9R5bheayBostfMDzJ+pXuK9gY1hUrVjjTO0aH7F25GBNDRqLSagd1TIZc
         Bil29fSE4ltIYBOy2ZrquyDnccBPDISgAhO5VEtD0j3/NvSaXAbZpp7u7xG/FpLiTZ
         s1kpwmjZmRRsw==
Received: by mail-ua1-f49.google.com with SMTP id s18so2041135uac.10
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 07:26:43 -0700 (PDT)
X-Gm-Message-State: ACgBeo1v/gRg80QmLOBIzZ5z0xaQW3hSa7OvHAcZK23UaAycnDGx8IgC
        oyn89bRto4T3XzlKJy3pMsm6mI1BtQNOw3HMKA==
X-Google-Smtp-Source: AA6agR5QNhVhHdamIy0LAbErkLIH6i76S+1Ex2LIToq0LO2FsbGIdzzJ3OJtgtvbNGMRW3aDo2Ma1UMRHw9BcPTtWpY=
X-Received: by 2002:ab0:2505:0:b0:384:cc62:9a75 with SMTP id
 j5-20020ab02505000000b00384cc629a75mr5802056uan.36.1659364001860; Mon, 01 Aug
 2022 07:26:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
 <20220729132119.1191227-5-vladimir.oltean@nxp.com> <CAL_JsqJJBDC9_RbJwUSs5Q-OjWJDSA=8GTXyfZ4LdYijB-AqqA@mail.gmail.com>
 <20220729170107.h4ariyl5rvhcrhq3@skbuf> <CAL_JsqL7AcAbtqwjYmhbtwZBXyRNsquuM8LqEFGYgha-xpuE+Q@mail.gmail.com>
 <20220730162351.rwfzpma5uvsg3kax@skbuf> <CAL_JsqLyCJE2c4ORx-kK1iUMR08iMUMDi0FMb9WeTyfyzO3GKw@mail.gmail.com>
 <20220801141124.2bhkzqtp36hdkq5u@skbuf>
In-Reply-To: <20220801141124.2bhkzqtp36hdkq5u@skbuf>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 1 Aug 2022 08:26:30 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKZ6cEny_xD8LUMQUR6AQ0q7JKZMmdP-9MUZxzzNxZ3JQ@mail.gmail.com>
Message-ID: <CAL_JsqKZ6cEny_xD8LUMQUR6AQ0q7JKZMmdP-9MUZxzzNxZ3JQ@mail.gmail.com>
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
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
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

On Mon, Aug 1, 2022 at 8:11 AM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> On Mon, Aug 01, 2022 at 08:02:56AM -0600, Rob Herring wrote:
> > > +if:
> > > +  oneOf:
> > > +    - properties:
> > > +        ethernet:
> > > +          items:
> > > +            $ref: /schemas/types.yaml#/definitions/phandle
> > > +    - properties:
> > > +        link:
> > > +          items:
> > > +            $ref: /schemas/types.yaml#/definitions/phandle-array
> >
> > 'items' here is wrong. 'required' is needed because the property not
> > present will be true otherwise.
> >
> > Checking the type is redundant given the top-level schema already does that.
>
> Excuse me, but I don't understand. I verified this and it works as
> expected - if the property is present, the 'items' evaluates to true,
> otherwise to false.

The main schema has:

link:
  $ref: /schemas/types.yaml#/definitions/phandle-array

Both with and without 'items' can't be correct.

> Could you suggest an alternative way of checking whether the 'ethernet'
> or 'link' properties are present, as part of a conditional?

if:
  oneOf:
    - required: [ ethernet ]
    - required: [ link ]

'required' here doesn't mean the property is required, but is simply
true if the property is present and false if not present.


> > > I have deliberately made this part of dsa-port.yaml and not depend on
> > > any compatible string. The reason is the code - we'll warn about missing
> > > properties regardless of whether we have fallback logic for some older
> > > switches. Essentially the fact that some switches have the fallback to
> > > not use phylink will remain an undocumented easter egg as far as the
> > > dt-schema is concerned.
> >
> > dsa-port.yaml is only applied when some other schema references it
> > which is probably based on some compatible. If you want to apply this
> > under some other condition, then you need a custom 'select' schema to
> > define when.
>
> No, this is good, I think. I got a "build warning" from your bot which
> found the DSA examples which had missing required properties, so I think
> it works the way I indended it.

Okay, I was thinking you wanted to check cases that didn't yet have a
schema for the specific device.

Rob
