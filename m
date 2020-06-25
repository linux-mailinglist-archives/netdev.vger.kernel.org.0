Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B19B20A3A7
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 19:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406632AbgFYRGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 13:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404376AbgFYRGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 13:06:20 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96593C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 10:06:20 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id ga4so6637966ejb.11
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 10:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=58vsmkOHkkco0CWewfS1GnT2ciSVRw6D3yQKkiRtVhs=;
        b=pcLRrFyJPfaoMlZ/fWo4XLirwRSov1UD8VkcLq0opo03D/jbZPocbLlqLR1TIir0T4
         88KdyF3L8dC7YsPdmpL4/2GNtE4e1G1EQCRJ+XIlXAMv2DNvGjIWyrUvUsEPHZxL06+A
         2pvQkcliWKoMs0D6LWra8dg4IzgcwA57EulqIMrlFi5klbEwswNEe1Hc6vvr8pMnwGQl
         SSQI1eNhtpN4lAJL7ocP/WlgC7tVJHI6CH42LTXKCzcF2dukO9WUOBmbVKwJxFK3eoiR
         elZykKEa9rfTw5J7dpqPI8C/t5H3qpHNKqoUfqyNOYDU9x8grwuwTr/FHB+yesSpTTjf
         BFZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=58vsmkOHkkco0CWewfS1GnT2ciSVRw6D3yQKkiRtVhs=;
        b=UmGyYzC24EmVqqi3B9F+UyClxY9q8VWMMhgiM8Bs0LLOX0kbVbOPgMl7Y+i8RElV9A
         O1U9iMeygYXWLNJtJbpYzXXp8P+YxoaRsvEP8Vyo/8Jakr1KHSFToXO8ysSgiHROmQiR
         Wtuu55YdhL+ZDnWqA4Z0qEtKBpRKpLMa1+9TOtj1spPPbACuWTMthkm/AMoocbL9vRdB
         p5am8JoV5p5CDA4kukhyBSHW8cGzhr6lXo3WDlaaMBwoVSW3CvxFKA732jygpXhBYcWA
         Sy8ckSGvclRfJJjGEyz8wngJS+lTcqs/05/R9IzCpj44U8vrNGOUteg1qy61+nYLysfa
         6bdQ==
X-Gm-Message-State: AOAM532CeB69YZjQLSlxbMNm4CkOLJ/mE+N4BBZY+gnvp5ESMlkHVZ0X
        KyCa/fi9gV/4b/RgBH0MqC3GMMg08/LdnWiHX+s=
X-Google-Smtp-Source: ABdhPJwfK3agFUkYmTyI4QhXR8OCx46vzctpZl03m4+T7LexwNbcC4Ny+GmRd47TmZf2KYQfbnGzM2mZQIq6eZa+E/Y=
X-Received: by 2002:a17:906:6897:: with SMTP id n23mr7850385ejr.473.1593104779155;
 Thu, 25 Jun 2020 10:06:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200625152331.3784018-1-olteanv@gmail.com> <20200625152331.3784018-5-olteanv@gmail.com>
 <20200625163715.GH1551@shell.armlinux.org.uk> <CA+h21hqVF-QkyuhPY9AjOmebYBKhLH7ACo4cdWa8q2Y_7jRHbg@mail.gmail.com>
 <20200625165818.GK1551@shell.armlinux.org.uk>
In-Reply-To: <20200625165818.GK1551@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 25 Jun 2020 20:06:08 +0300
Message-ID: <CA+h21hp_9R_DiYRQU4q7vGi5N+QGX6CzMZT03yQzmiFn5VSrZA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/7] net: dsa: felix: set proper pause frame
 timers based on link speed
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 at 19:58, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Thu, Jun 25, 2020 at 07:48:23PM +0300, Vladimir Oltean wrote:
> > On Thu, 25 Jun 2020 at 19:37, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Thu, Jun 25, 2020 at 06:23:28PM +0300, Vladimir Oltean wrote:
> > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > >
> > > > state->speed holds a value of 10, 100, 1000 or 2500, but
> > > > SYS_MAC_FC_CFG_FC_LINK_SPEED expects a value in the range 0, 1, 2 or 3.
> > > >
> > > > So set the correct speed encoding into this register.
> > > >
> > > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > ---
> > > >  drivers/net/dsa/ocelot/felix.c | 27 +++++++++++++++++++++++----
> > > >  1 file changed, 23 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> > > > index d229cb5d5f9e..da337c63e7ca 100644
> > > > --- a/drivers/net/dsa/ocelot/felix.c
> > > > +++ b/drivers/net/dsa/ocelot/felix.c
> > > > @@ -250,10 +250,25 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
> > > >                          DEV_CLOCK_CFG_LINK_SPEED(OCELOT_SPEED_1000),
> > > >                          DEV_CLOCK_CFG);
> > > >
> > > > -     /* Flow control. Link speed is only used here to evaluate the time
> > > > -      * specification in incoming pause frames.
> > > > -      */
> > > > -     mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(state->speed);
> > > > +     switch (state->speed) {
> > > > +     case SPEED_10:
> > > > +             mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(3);
> > > > +             break;
> > > > +     case SPEED_100:
> > > > +             mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(2);
> > > > +             break;
> > > > +     case SPEED_1000:
> > > > +     case SPEED_2500:
> > > > +             mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(1);
> > > > +             break;
> > > > +     case SPEED_UNKNOWN:
> > > > +             mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(0);
> > > > +             break;
> > > > +     default:
> > > > +             dev_err(ocelot->dev, "Unsupported speed on port %d: %d\n",
> > > > +                     port, state->speed);
> > > > +             return;
> > > > +     }
> > > >
> > > >       /* handle Rx pause in all cases, with 2500base-X this is used for rate
> > > >        * adaptation.
> > > > @@ -265,6 +280,10 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
> > > >                             SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
> > > >                             SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
> > > >                             SYS_MAC_FC_CFG_ZERO_PAUSE_ENA;
> > > > +
> > > > +     /* Flow control. Link speed is only used here to evaluate the time
> > > > +      * specification in incoming pause frames.
> > > > +      */
> > > >       ocelot_write_rix(ocelot, mac_fc_cfg, SYS_MAC_FC_CFG, port);
> > >
> > > I'm not that happy with the persistence of felix using the legacy
> > > method; I can bring a horse to water but can't make it drink comes
> > > to mind.  I'm at the point where I don't care _if_ my phylink changes
> > > break code that I've asked people to convert and they haven't yet,
> > > and I'm planning to send the series that /may/ cause breakage in
> > > that regard pretty soon, so the lynx PCS changes can move forward.
> > >
> > > I even tried to move felix forward by sending a patch for it, and I
> > > just gave up with that approach based on your comment.
> > >
> > > Shrug.
> > >
> > > --
> > > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> >
> > The callbacks clearly work the way they are, given the current
> > structure of phylink, as proven by the users of this driver. Code that
> > isn't there yet simply isn't there yet.
> >
> > What you consider "useless churn" and what I consider "useless churn"
> > are pretty different things.
> > To me, patch 7/7 is the useless churn, that's why it's at the end.
> > Patches 1-6 are structured in a way that is compatible with
> > backporting to a stable 5.4 tree. Patch 7, not so much.
> >
> > The fact that you have such an attitude and you make the effort to
> > actually send an email complaining about me using state->speed in
> > .mac_config(), when literally 3 patches later I'm moving this
> > configuration where you want it to be, is pretty annoying.
>
> I have asked you to update felix _prior_ to my patch update, because
> I forsee the possibility for there to be breakage from pushing the
> PCS support further forward.  In other words, I see there to be a
> dependency between moving forward with PCS support and drivers that
> still use the legacy method.
>
> You don't see that, so you constantly bitch and moan.
>

And that's what this patch series is, no?
Some cleanup needed to be done, and it needed to be done _before_ the
mac_link_up() conversion. And for things to go quicker, the cleanup
and the conversion are part of the same series.

> Please stop being a problem.
>

Come again, please?
