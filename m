Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E47585681
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbiG2Vdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiG2Vdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:33:43 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EB08BAAF
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 14:33:42 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id h125so7048637oif.8
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 14:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GN1IJJvgwXtbnJsNeXo0E2HUyY8y8AGVj39BfTM/llg=;
        b=Zht23Cxgm1RvRgCqv110Yi0WxEDTwv5JMK/6Fts+2657lSBDfi3tXGvl00PgC+jqgX
         rFBK0RgjWzEDMnXvg2r2b4XR0tWBjJENl5QCskC9JGQRHuyWNdrD2UkJlhEv9MFMmyeP
         AGdKS0iDmcF29UnX/a4Ywhnle1tpftDH4NqoywVCNlnbel0MRC6bNJ3pUT7twe5w3gDx
         f5fHqh39w++6sT8Y3Smdn0GiPhBCaNAsM1Qkb4XnKngjQq9982YF3FURzb85GxNNiAVp
         Q6fE+Vb4V38q/DkWmr9Z9s1Jno4R7wmZfg5oJM9HYojs7pGzBnRkRMQwK8wAi+STox+X
         1vUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GN1IJJvgwXtbnJsNeXo0E2HUyY8y8AGVj39BfTM/llg=;
        b=XNhDkSL2sCBFllG4v8ykzqnRkVvI3xAYjp6H/mcQULGaILtI04sTh/WZywog1pmff+
         Q2FfkjNcr5hMUBAVD5wY7pDBiyKrqzJ71CFCSnrEcc+AddeWD04Re2A1jXgV3nqh9OSU
         MtkP1lFtLaG296fDx5Q0pOYj7wd1Sh/rwMFLFKfZU3Tr+pd6QLdb7iqtae12YJSpkkwO
         79M9JautzvQX3K7isD25l759yYYhz5SndN6qdLDF2K78xoEvY0PBbf93mWzK7M3ocONi
         uNHNMaGnUWnd991rsfoICErZpktsOcAxBAqDz+raJCENSfBTm4GB+VA0lxXczLizoDuJ
         a3dw==
X-Gm-Message-State: AJIora9QPLx0KGdSNmrBaDL4X3M2/pD5DcUqDT2SJdrqpFlpNHx60F9r
        afIj0JcJAREQoxLDQFTRqY4ObU9qIvwHWmhmDcHnLw==
X-Google-Smtp-Source: AGRyM1u9CThOLaaoZRSw2BkXUu263VqJzTyLr0wdDaPLva6XSkDoLjJvLpjEd4YtClAC8/Bh/kEPxHrO7EoUxnh4A8A=
X-Received: by 2002:aca:ba86:0:b0:33a:c6f7:3001 with SMTP id
 k128-20020acaba86000000b0033ac6f73001mr2687424oif.5.1659130421755; Fri, 29
 Jul 2022 14:33:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
 <20220729132119.1191227-5-vladimir.oltean@nxp.com> <CAPv3WKe7BVS3cjPws69Zi=XqBE3UkgQM1yLKJgmphiQO_n8Jgw@mail.gmail.com>
 <20220729183444.jzr3eoj6xdumezwu@skbuf> <CAPv3WKfLc_3D+BQg0Mhp9t8kHzpfYo1SKZkSDHYBLEoRbTqpmw@mail.gmail.com>
 <YuROg1t+dXMwddi6@lunn.ch> <7a8b57c3-5b5a-dfc8-67cb-52061fb9085e@gmail.com>
In-Reply-To: <7a8b57c3-5b5a-dfc8-67cb-52061fb9085e@gmail.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Fri, 29 Jul 2022 23:33:30 +0200
Message-ID: <CAPv3WKcoi8M6WmEtUXAObhRjJmR3jm7MguWUyw=RJQfNnt7c6w@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
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
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pt., 29 lip 2022 o 23:24 Florian Fainelli <f.fainelli@gmail.com> napisa=C5=
=82(a):
>
> On 7/29/22 14:17, Andrew Lunn wrote:
> >> What I propose is to enforce more strictly an update of DT description
> >> with a specified timeline, abandoning 'camps' idea and driver-specific
> >> contents in the generic code.
> >
> > Regressions are the problem. We are supposed to be backwards
> > compatible with older DT blobs. If we now say old DT blobs are
> > invalid, and refuse to probe, we cause a regression.
> >
> > For some of the in kernel DT files using the mv88e6xxx i can make a
> > good guess at what the missing properties are. However, i'm bound to
> > guess wrong at some point, and cause a regression. So we could change
> > just those we can test. But at some point, the other blobs are going
> > to fail the enforces checks and cause a regression anyway.
> >
> > And what about out of tree blobs? Probably OpenWRT have some. Do we
> > want to cause them to regress?
>
> No, we do not want that, which is why Vladimir's approach IMHO is reasona=
ble in that it acknowledges mistakes or shortcomings of the past into the p=
resent, and expects the future to be corrected and not repeat those same mi=
stakes. The deprectiation window idea is all well and good in premise, howe=
ver with such a large user base, I am not sure it is going to go very far u=
nfortunately, nor that it will hinder our ability to have a more maintainab=
le DSA framework TBH.
>
> BTW, OpenWrt does not typically ship DT blobs that stay frozen, all of th=
e kernel, DTBs, root filesystem, and sometimes a recent u-boot copy will be=
 updated at the same time because very rarely do the existing boot loader s=
atisfy modern requirements (PSCI, etc.).

Initially, I thought that the idea is a probe failure (hence the camps
to prevent that) - but it was clarified later, it's not the case.

I totally agree and I am all against breaking the backward
compatibility (this is why I work on ACPI support that much :) ). The
question is whether for existing deployments with 'broken' DT
description we would be ok to introduce a dev_warn/WARN_ON message
after a kernel update. That would be a case if the check is performed
unconditionally - this way we can keep compat strings out of net/dsa.
What do you think?

Best regards,
Marcin
