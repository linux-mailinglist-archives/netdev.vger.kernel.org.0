Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9B348FFA0
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 00:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbiAPXVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 18:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbiAPXV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 18:21:29 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CC3C061574;
        Sun, 16 Jan 2022 15:21:29 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id n19-20020a7bc5d3000000b003466ef16375so20307645wmk.1;
        Sun, 16 Jan 2022 15:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EX2t9AEA4pRaVoM2Pq865EYbBUdDIs7vDiRLy8uT8m4=;
        b=pVrVB6JWDZqi/mvFqboQcQFhZ4AR5mZxt0WTE9SdDP+RQa32PKEmIJwXCYq69N8Ebl
         eq1/Lo8SzAdnrAhUCSfGmky4ZP5JV8juWTc9q0B6XEHbnfOgQKff/I1FpJ/hazY2UgtQ
         TBbuLAhf6twKfZjR6eCH5ZTOLGu7nvp5MBoV49Pz8breJaQTgGT+wEdo6aUkriUGO9rt
         5jVXJProuPgvOtT93LJh02T4JWIICFnJqE49y3HmCwQS1zGAeaJBftwsEDyqgZlwoqws
         ASf/ollao5zINHUh+ITIpmZBdS6kTQ4D12WxGLgOk4zlJXy3F3t9aaPi0P364G28icNP
         4bXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EX2t9AEA4pRaVoM2Pq865EYbBUdDIs7vDiRLy8uT8m4=;
        b=I43Jf70lGKYA8b+Z59Iay96eLkSGXkFBeFR819W4geb7Wzk+bPkkVDCQaAnRnMOL1b
         hn+WtqJWGwwyTIkDyl28kae5tuoVGYiUMLKLQN6NaF5fVoxl0Dza+YWzZHrIhIK+FCnB
         IhvmADSfVeUYK4OW4PyPJr5KaPmIgJmAR6vXD3FTX7ZI22JdCK+K0ASP5H+apgEA/+w3
         hRkzJjoX5kZlp9J9sc3NwyAy+yc6frkZwen7G1GXMgo8ltKHmHJPu4FTX848FY/PlaQ9
         xSIaSkn0/xb4dVCVPqzysJEIiN2dRtE1F+lki1JICOzxq99Mm1EnzjUmNrwyGUNEO7a0
         LPzQ==
X-Gm-Message-State: AOAM530ibm9YNuOUvNBOAV7JVqUz7JgrjamwOgJ7nk8YPLSgRnlrNqIV
        SYPkOyoElnWAlN7VkKxdeTyNtzUMKBYW8HyMoBw=
X-Google-Smtp-Source: ABdhPJyifs4iaqrEenTwSs+2p8jKGiMjpkHqe52A8goSkKl4QjvH2te+HZz0eJsGNy5/4+uy/t8WhobZRGP0Vmnii8s=
X-Received: by 2002:a1c:43c5:: with SMTP id q188mr17070604wma.54.1642375287712;
 Sun, 16 Jan 2022 15:21:27 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
 <20220112173312.764660-9-miquel.raynal@bootlin.com> <CAB_54W5QU5JCtQYwvTKREd6ZeQWmC19LF4mj853U0Gz-mCObVQ@mail.gmail.com>
 <20220113121645.434a6ef6@xps13> <CAB_54W5_x88zVgSJep=yK5WVjPvcWMy8dmyOJWcjy=5o0jCy0w@mail.gmail.com>
 <20220114112113.63661251@xps13>
In-Reply-To: <20220114112113.63661251@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 16 Jan 2022 18:21:16 -0500
Message-ID: <CAB_54W77d_PjX_ZfKJdO4D4hHsAWjw0jWgRA7L0ewNnqApQhcQ@mail.gmail.com>
Subject: Re: [wpan-next v2 08/27] net: ieee802154: Drop symbol duration
 settings when the core does it already
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 14 Jan 2022 at 05:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Thu, 13 Jan 2022 18:34:00 -0500:
>
> > Hi,
> >
> > On Thu, 13 Jan 2022 at 06:16, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > alex.aring@gmail.com wrote on Wed, 12 Jan 2022 17:26:14 -0500:
> > >
> > > > Hi,
> > > >
> > > > On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > > The core now knows how to set the symbol duration in a few cases, when
> > > > > drivers correctly advertise the protocols used on each channel. For
> > > > > these drivers, there is no more need to bother with symbol duration, so
> > > > > just drop the duplicated code.
> > > > >
> > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > ---
> > > > >  drivers/net/ieee802154/ca8210.c | 1 -
> > > > >  drivers/net/ieee802154/mcr20a.c | 2 --
> > > > >  2 files changed, 3 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> > > > > index 82b2a173bdbd..d3a9e4fe05f4 100644
> > > > > --- a/drivers/net/ieee802154/ca8210.c
> > > > > +++ b/drivers/net/ieee802154/ca8210.c
> > > > > @@ -2977,7 +2977,6 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
> > > > >         ca8210_hw->phy->cca.mode = NL802154_CCA_ENERGY_CARRIER;
> > > > >         ca8210_hw->phy->cca.opt = NL802154_CCA_OPT_ENERGY_CARRIER_AND;
> > > > >         ca8210_hw->phy->cca_ed_level = -9800;
> > > > > -       ca8210_hw->phy->symbol_duration = 16 * 1000;
> > > > >         ca8210_hw->phy->lifs_period = 40;
> > > > >         ca8210_hw->phy->sifs_period = 12;
> > > > >         ca8210_hw->flags =
> > > > > diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
> > > > > index 8aa87e9bf92e..da2ab19cb5ee 100644
> > > > > --- a/drivers/net/ieee802154/mcr20a.c
> > > > > +++ b/drivers/net/ieee802154/mcr20a.c
> > > > > @@ -975,7 +975,6 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
> > > > >
> > > > >         dev_dbg(printdev(lp), "%s\n", __func__);
> > > > >
> > > > > -       phy->symbol_duration = 16 * 1000;
> > > > >         phy->lifs_period = 40;
> > > > >         phy->sifs_period = 12;
> > > > >
> > > > > @@ -1010,7 +1009,6 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
> > > > >         phy->current_page = 0;
> > > > >         /* MCR20A default reset value */
> > > > >         phy->current_channel = 20;
> > > > > -       phy->symbol_duration = 16 * 1000;
> > > > >         phy->supported.tx_powers = mcr20a_powers;
> > > > >         phy->supported.tx_powers_size = ARRAY_SIZE(mcr20a_powers);
> > > > >         phy->cca_ed_level = phy->supported.cca_ed_levels[75];
> > > >
> > > > What's about the atrf86230 driver?
> > >
> > > I couldn't find reliable information about what this meant:
> > >
> > >         /* SUB:0 and BPSK:0 -> BPSK-20 */
> > >         /* SUB:1 and BPSK:0 -> BPSK-40 */
> > >         /* SUB:0 and BPSK:1 -> OQPSK-100/200/400 */
> > >         /* SUB:1 and BPSK:1 -> OQPSK-250/500/1000 */
> > >
> > > None of these comments match the spec so I don't know what to put
> > > there. If you know what these protocols are, I will immediately
> > > provide this information into the driver and ensure the core handles
> > > these durations properly before dropping the symbol_durations settings
> > > from the code.
> >
> > I think those are from the transceiver datasheets (which are free to
> > access). Can you not simply merge them or is there a conflict?
>
> Actually I misread the driver, it supports several kind of chips with
> different channel settings and this disturbed me. I downloaded the
> datasheet and figured that the number after the protocol is the bit
> rate. This helped me to make the connection with what I already know,
> so both atusb and atrf86230 drivers have been converted too.

and what is about hwsim? I think the table gets too large then...
that's why I was thinking of moving that somehow to the regdb, however
this is another project as I said and this way is fine. Maybe we use a
kind of fallback then? The hwsim phy isn't really any 802.15.4 PHY,
it's just memcpy() but it would be nice to be able to test scan with
it. So far I understand it is already possible to make something with
hwsim here but what about the zero symbol rate and the "waiting
period" is zero?

btw:
Also for testing with hwsim and the missing features which currently
exist. Can we implement some user space test program which replies
(active scan) or sends periodically something out via AF_PACKET raw
and a monitor interface that should work to test if it is working?
Ideally we could do that very easily with scapy (not sure about their
_upstream_ 802.15.4 support). I hope I got that right that there is
still something missing but we could fake it in such a way (just for
hwsim testing).

Side note: tx via monitor over AF_PACKET raw is without fcs currently.

- Alex
