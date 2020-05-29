Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A2D1E824C
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgE2PnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbgE2PnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:43:00 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2246C08C5C9
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 08:42:59 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id k11so2500299ejr.9
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 08:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GUBu7hjguH+cOPhWRxMwWBIw4PPhjHXH350aqMuTMGQ=;
        b=sHJfXptgfnJ0U8uXWlgTf6S+vlJGwqPICEir5hxYoiGh/QodoHODP5NvJcn+HeLD/S
         YuKeY5b5sOwxPt/Ta5TL6Gk7OfxdnBjCw6BcViv2gEPxpaqcsoAzgzOieliESwoi26P4
         9czCMj2VZ4xlvKOFfxKMZ7ylE24ElxwnEeXAE2xmJgjapb2zgAVhgCUaPCmrd+ZfgvHy
         0rkLS0w+lsj9pEyr2a+SYwo//O0yUUHiueEWhXuHRl4z0Y+6cm42dD4VdvjXw43/yyTX
         iiEhBcVpEP2xFp5Syiaab+SiEU1Z+L7ZVXTVngdDy86lnVia68RWBt61C2La8pPmFnju
         J2ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GUBu7hjguH+cOPhWRxMwWBIw4PPhjHXH350aqMuTMGQ=;
        b=OKncVUSKz+ycHRtAnvnBbWsCtcSU80Qv56ZjV9qT5aCKrYYxm5DKqFzz9FCZiyRNEo
         cXOl03UVc68ymSbq40oLcQex1d8DmbAsTE0cAjQC2o6yt5rVNLm6YMYxAR4L8w5VTIGJ
         ET0Nhrc7RFdpHMAFMAh6VZHjGGByID9bzosjk8OhRhd4WZVvsgLI67nQ7lo5xzq9k0Es
         cVls95EoIlNBLynXGEjfhWr90TzzdfSGE9BPW9qtm3vrZvT9A9TcFn+uNnuDBX4LO4gj
         gwQwDsEMnvHzw/DgUcqR/nRJKl61Q9zR5FN+bH8/B+3fnznWadOt6B9Tdn2H7LMWfIDu
         ILrg==
X-Gm-Message-State: AOAM533Ut486YpP/KqH9i1LNb0RGLqlN/ZFrDXtXbLFxPuLawvPTUmr/
        4DTlG+XCdb635zwCN7hyrYyYUKC9h1bKtT7r4JA=
X-Google-Smtp-Source: ABdhPJwPuZdXvvG4fHl263f6QEMBPkwanHRMj1oRp/f4/6KkTNbuAaI4bGG4ZDYmtaDfTPg3/N3Wm8EL06HT9YdNXB8=
X-Received: by 2002:a17:906:2e50:: with SMTP id r16mr8001742eji.305.1590766978638;
 Fri, 29 May 2020 08:42:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200527234113.2491988-1-olteanv@gmail.com> <20200527234113.2491988-12-olteanv@gmail.com>
 <20200528215618.GA853774@lunn.ch> <CA+h21hoVQPVJiYDQV7j+d7Vt8o5rK+Z8APO2Hp85Dt8cOU7e4w@mail.gmail.com>
 <20200529081441.GW3972@piout.net> <CA+h21hpqf720YO84QJ6vBbF7chZkgnv_ow2-mRmP9OaOC_Ho1g@mail.gmail.com>
 <20200529090312.GA3972@piout.net>
In-Reply-To: <20200529090312.GA3972@piout.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 29 May 2020 18:42:47 +0300
Message-ID: <CA+h21hqQmGTrhybFAvqN2A14ZU5KRvS8h2cgGYh185HevtfwWA@mail.gmail.com>
Subject: Re: [PATCH net-next 11/11] net: dsa: ocelot: introduce driver for
 Seville VSC9953 switch
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 at 12:03, Alexandre Belloni
<alexandre.belloni@bootlin.com> wrote:
>
> On 29/05/2020 11:30:43+0300, Vladimir Oltean wrote:
> > > As ocelot can be used in a DSA configuration (even if it is not
> > > implemented yet), I don't think this would be correct. From my point of
> > > view, felix and seville are part of the ocelot family.
> > >
> >
> > In this case, there would be a third driver in
> > drivers/net/dsa/ocelot/ocelot_vsc7511.c which uses the intermediate
> > felix_switch_ops from felix.c to access the ocelot core
> > implementation. Unless you have better naming suggestions?
> >
>
> I don't. Maybe felix.c should have been ocelot.c from the beginning but
> honestly, it doesn't matter that much.
>

Technically Seville is not part of the Ocelot family but part of
Serval, but then again, it's just a marketing name, so it doesn't
really mean anything..
I am a bit reluctant to rename the DSA driver ops to "ocelot", since
it would be even more confusing for everyone to have a function
ocelot_dsa_set_ageing_time that calls ocelot_set_ageing_time. At least
this way, there's going to be some learning curve figuring out that
felix is an umbrella term for DSA ops, but there will be more naming
predictability. (at least that's how I see it)

> BTW, maybe we should merge the VITESSE FELIX ETHERNET SWITCH DRIVER and
> MICROSEMI ETHERNET SWITCH DRIVER entries in MAINTAINERS. You do much
> more work in drivers/net/ethernet/mscc/ than I currently do.
>

How would you see the merged MAINTAINERS entry? Something like this?

MICROSEMI ETHERNET SWITCH DRIVER
M:    Alexandre Belloni <alexandre.belloni@bootlin.com>
M:    Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
M:    Vladimir Oltean <vladimir.oltean@nxp.com>
M:    Claudiu Manoil <claudiu.manoil@nxp.com>
L:    netdev@vger.kernel.org
S:    Maintained
F:    include/soc/mscc/ocelot*
F:    drivers/net/ethernet/mscc/
F:    drivers/net/dsa/ocelot/*
F:    net/dsa/tag_ocelot.c

Any takers from Microchip, or is the internal mailing list enough?

> --
> Alexandre Belloni, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com
