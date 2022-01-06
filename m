Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F886485CFF
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 01:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343585AbiAFAPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 19:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239471AbiAFAPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 19:15:19 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C15C061245;
        Wed,  5 Jan 2022 16:15:19 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id j18so1489070wrd.2;
        Wed, 05 Jan 2022 16:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WogvoeJov+AGHp0WG2ilXOyUljhCVWuwqdnyYhSWOc8=;
        b=IcN8x7d5qV/2IkeYXNX5oJVcqUA5mtfVT5zlpJWJky2ccGE0DcSniXOFha3qLOXXvL
         i8mECGKcRSDYXN9rqpi1W+02QtpnQJjcS4BoDkhf3JBKEi0pz8YIqurHPzsjtQfeK5/6
         yUeDhs0dLq1DJ6CwZG+XvhoZghbnMYvtRRnxcKsrxw/+6FlJdMosQU57l3LQgI+ZVYQE
         fMpA0SkiPRCFIhCjjLXdxfgubzT6IdpmYmpWKrWVSbnj0SSPcSpdP9IxQspciZsPABvv
         PAXa0tKZbSPWZmAwfw497Wc2ZQPKFNI+lO92STx60Y/TFLeQXHoxSR9c+UVm8PN/5nIn
         gKWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WogvoeJov+AGHp0WG2ilXOyUljhCVWuwqdnyYhSWOc8=;
        b=A6hdo+BM83ZURzrRjARM/E7szwxl9X/TAKGxSTJ4NTB4Xf7Mj+ThV+w3TqDFNNux2T
         O1WNXOlBrhFl60QcpeIsXBe4IUxh0Mde8vtD9WOZE2VVsPd/K1BM1aTRpEGwvyPJ7IRw
         oYc99oZWi3Zbx+QyzFAvIEluLfHSy0MQZ69q95B9qYOh8I+MJjE/vAtIVcKObiH1ltyY
         eLE6IYFvkOfDY65m0brQsZiN1SOSh4g1Us/wkVWian41HDaPnSbLzd0nIwbm97oAQa78
         EuHnOKMXxUi8Ia6oUb4WkVfA4wXm5QHOW7Mb0N+bIhSWz0CRZnf5h+cAnOoFbDpwPBNs
         9jYQ==
X-Gm-Message-State: AOAM533RrStjjAmq7TlsJ+5hgXhM17CoI4br6VwEojVLfdk2r+wvsY9o
        nqg7LhgGaoo+8wcIR642gOMwqnbHEHrdZ3zH+G4=
X-Google-Smtp-Source: ABdhPJwwzsXVHsrPMFOP9hOx6T+xCBftHG/tj4abruxEs91+r7yqXwNQWL37M7n58oveFsDQYov6xMJnYittVhIB1po=
X-Received: by 2002:a5d:588c:: with SMTP id n12mr49172437wrf.56.1641428117671;
 Wed, 05 Jan 2022 16:15:17 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-2-miquel.raynal@bootlin.com> <CAB_54W7BeSA+2GVzb9Yvz1kj12wkRSqHj9Ybr8cK7oYd7804RQ@mail.gmail.com>
 <20220104164449.1179bfc7@xps13> <CAB_54W6LG4SKdS4HDSj1o2A64UiA6BEv_Bh_5e9WCyyJKeAbtg@mail.gmail.com>
 <CAB_54W6o-wBD2wu7sohCD0ack5PR_wqc2NqOnYC6WEVV5VF8FQ@mail.gmail.com> <20220105091441.10e96b34@xps13>
In-Reply-To: <20220105091441.10e96b34@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 5 Jan 2022 19:15:06 -0500
Message-ID: <CAB_54W6uc5vGrk19Lm0cZpKBaWakJJOcsG1OEn64160pcWGp0A@mail.gmail.com>
Subject: Re: [net-next 01/18] ieee802154: hwsim: Ensure proper channel
 selection at probe time
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 5 Jan 2022 at 03:14, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Tue, 4 Jan 2022 18:10:44 -0500:
>
> > Hi,
> >
> > On Tue, 4 Jan 2022 at 18:08, Alexander Aring <alex.aring@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > On Tue, 4 Jan 2022 at 10:44, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > Hi Alexander,
> > > >
> > > > alex.aring@gmail.com wrote on Tue, 28 Dec 2021 16:05:43 -0500:
> > > >
> > > > > Hi,
> > > > >
> > > > > On Wed, 22 Dec 2021 at 10:57, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > > >
> > > > > > A default channel is selected by default (13), let's clarify that this
> > > > > > is page 0 channel 13. Call the right helper to ensure the necessary
> > > > > > configuration for this channel has been applied.
> > > > > >
> > > > > > So far there is very little configuration done in this helper but we
> > > > > > will soon add more information (like the symbol duration which is
> > > > > > missing) and having this helper called at probe time will prevent us to
> > > > > > this type of initialization at two different locations.
> > > > > >
> > > > >
> > > > > I see why this patch is necessary because in later patches the symbol
> > > > > duration is set at ".set_channel()" callback like the at86rf230 driver
> > > > > is doing it.
> > > > > However there is an old TODO [0]. I think we should combine it and
> > > > > implement it in ieee802154_set_channel() of "net/mac802154/cfg.c".
> > > > > Also do the symbol duration setting according to the channel/page when
> > > > > we call ieee802154_register_hw(), so we have it for the default
> > > > > settings.
> > > >
> > > > While I totally agree on the background idea, I don't really see how
> > > > this is possible. Every driver internally knows what it supports but
> > > > AFAIU the core itself has no easy and standard access to it?
> > > >
> > >
> > > I am a little bit confused here, because a lot of timing related
> > > things in the phy information rate points to "x times symbols". If
> >
> > s/rate/base/
>
> Yes indeed, but I bet it works because the phy drivers set the symbol
> duration by themselves. You can see that none of them does something
> clever like:
>
> switch (phy.protocol) {
>         case XXXXX:
>                 symbol_duration = y;
>                 break;
>         ...
>
> Instead, they all go through the page/channel list in a quite hardcoded
> way because the phy driver knows internally that protocol X is used on
> {page, channel}, but the protocol id, while not being totally absent
> from drivers, is always provided as a comment.
>
> So getting rid of the core TODO you mentioned earlier means:
> - Listing properly the PHY protocols in the core (if not already done)
> - For each PHY protocol knowing the possible base frequencies
> - For each of these base frequencies knowing the symbol duration
> - Having the possibility to add more information such as the PRF in
>   order to let the core pick the right symbol duration when there is
>   more than one possibility for a {protocol, base frequency} couple
> - Convert the phy drivers (at least hwsim) to fill these new fields
>   correctly and expect the core to set the symbol duration properly.
>

I think this becomes quite large to provide all that information and
somehow this reminds me about the other TODO to extend the wireless
regdb with 802.15.4 specs and somehow let the kernel get the
information from there.

> Two side notes as well:
> - I was not able to find all the the corresponding protocol from the
>   hwsim driver in the spec (these channels are marked "unknown")

I think those frequencies were taken from the fakelb driver, I think
currently that the static channel array has a limitation on its own to
provide all channel/page combinations which could be set.

> - The symbol duration in a few specific UWB cases is below 1us while
>   the core expects a value in us. Should we change the symbol duration
>   to ns?
>

At some point yes, I think we need to switch to ns.

> I believe all this is doable in a reasonable time frame provided that
> I only focus on the few protocols supported by hwsim which I already
> "addressed" and perhaps a couple of simple drivers. On the core side,
> the logic might be: "is the driver providing information about the phy
> protocols used? if yes, then set the symbol duration if we have enough
> data, otherwise let the driver handle it by itself". Such logic would
> allow a progressive shift towards the situation where drivers do not
> have to bother with symbol duration by themselves.
>
> As this looks like a project on its own and my first goal was to be
> able to use hwsim to demonstrate the different scan features, maybe we
> can continue to discuss this and consider tackling it as a separate
> series whish would apply on top of the current one, what do you think?

I think the current way that the driver sets is fine, we can still
find other possible ways... for doing it better (e.g. regdb) is a new
project, I agree with that.

- Alex
