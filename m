Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DDD20A352
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 18:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390917AbgFYQsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 12:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390451AbgFYQsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 12:48:36 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C02C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 09:48:36 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id ga4so6584863ejb.11
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 09:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qm4/oVyY0nIgnvJ8yDp1/EQo7KEMjjTZJbLZILX5vWs=;
        b=HdFiejt4FtgH8bE9IrXu+lMMH3CEt4OxcJBFWPQhScE7AZZaBWp82N2LeYVqH5WGiO
         FWVTYC9II8kjwpj7tP91vLDgkmXbr+PCXry78mFVefBonFv1ggFMdrOQtbsZRAfXTTAU
         Vn98E7zsBLr2dSCJ6wRmOlBl98utBMTzKneJMxhcdDxawD/470w75LaSxqAlS1KkQoDn
         yi/EJW5zg2W7ThOeQHZQxTjrrJ8nst3GdW9FbZludklyZZn28rM5xqIrb82h0nul7TXH
         3/4kiDd1AjqxVfLyudg6C3NsXOwIDE3QmASwTYzSNOwRoJ125w5t/g7GKidUIO1L6jNP
         ZfTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qm4/oVyY0nIgnvJ8yDp1/EQo7KEMjjTZJbLZILX5vWs=;
        b=Co15Z+6rtE+dYNtdjxqwYe3JIDQfh5cU7l9+yfY0n9SZKK7In4ZjhWikZDqhwn1RKD
         fM0Fi8OUzT6BHh7vkzY98UTMjnZpI0EjvEBXANT/kgiEejJI2CGWw11wW8zm7CQSOsDl
         kj8+t/oi3K2RFnL2QbmM5gIUrEjTeH9NJSzjuEQWgKGS6OXAfFUMIulA9ZVki55pm6XN
         WlmHJ0VsZUuoIUT1damzU2hwueOEmJJrlUYxEI3JXGi83TSjG9wDFNG3tBe7YViXTunL
         0i5N1XmP/h2Tns2EWKofzvKchMJohuihwxNtBV0DIaAYU3zNdLV3iwURNSrm3Yt3dGP5
         zvJg==
X-Gm-Message-State: AOAM532CZ9RBIt7cjBL3Q8GTmUvUnsc8klQQ26yfL7LW3QJSvjRAdemh
        TlBM8nRVjC8isG342SO2Qekovb9YP3CNz9+gc8n1UQ==
X-Google-Smtp-Source: ABdhPJzrbySmpKSY6us7naD250zb1SrPzyU69XP6ok/X9cJGuiFUIZNj0/7ELVlcITvj7HQPPIcCPnVTNB5cQEbAtPw=
X-Received: by 2002:a17:906:5949:: with SMTP id g9mr12147324ejr.305.1593103714794;
 Thu, 25 Jun 2020 09:48:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200625152331.3784018-1-olteanv@gmail.com> <20200625152331.3784018-5-olteanv@gmail.com>
 <20200625163715.GH1551@shell.armlinux.org.uk>
In-Reply-To: <20200625163715.GH1551@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 25 Jun 2020 19:48:23 +0300
Message-ID: <CA+h21hqVF-QkyuhPY9AjOmebYBKhLH7ACo4cdWa8q2Y_7jRHbg@mail.gmail.com>
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

On Thu, 25 Jun 2020 at 19:37, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Thu, Jun 25, 2020 at 06:23:28PM +0300, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > state->speed holds a value of 10, 100, 1000 or 2500, but
> > SYS_MAC_FC_CFG_FC_LINK_SPEED expects a value in the range 0, 1, 2 or 3.
> >
> > So set the correct speed encoding into this register.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/net/dsa/ocelot/felix.c | 27 +++++++++++++++++++++++----
> >  1 file changed, 23 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> > index d229cb5d5f9e..da337c63e7ca 100644
> > --- a/drivers/net/dsa/ocelot/felix.c
> > +++ b/drivers/net/dsa/ocelot/felix.c
> > @@ -250,10 +250,25 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
> >                          DEV_CLOCK_CFG_LINK_SPEED(OCELOT_SPEED_1000),
> >                          DEV_CLOCK_CFG);
> >
> > -     /* Flow control. Link speed is only used here to evaluate the time
> > -      * specification in incoming pause frames.
> > -      */
> > -     mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(state->speed);
> > +     switch (state->speed) {
> > +     case SPEED_10:
> > +             mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(3);
> > +             break;
> > +     case SPEED_100:
> > +             mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(2);
> > +             break;
> > +     case SPEED_1000:
> > +     case SPEED_2500:
> > +             mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(1);
> > +             break;
> > +     case SPEED_UNKNOWN:
> > +             mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(0);
> > +             break;
> > +     default:
> > +             dev_err(ocelot->dev, "Unsupported speed on port %d: %d\n",
> > +                     port, state->speed);
> > +             return;
> > +     }
> >
> >       /* handle Rx pause in all cases, with 2500base-X this is used for rate
> >        * adaptation.
> > @@ -265,6 +280,10 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
> >                             SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
> >                             SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
> >                             SYS_MAC_FC_CFG_ZERO_PAUSE_ENA;
> > +
> > +     /* Flow control. Link speed is only used here to evaluate the time
> > +      * specification in incoming pause frames.
> > +      */
> >       ocelot_write_rix(ocelot, mac_fc_cfg, SYS_MAC_FC_CFG, port);
>
> I'm not that happy with the persistence of felix using the legacy
> method; I can bring a horse to water but can't make it drink comes
> to mind.  I'm at the point where I don't care _if_ my phylink changes
> break code that I've asked people to convert and they haven't yet,
> and I'm planning to send the series that /may/ cause breakage in
> that regard pretty soon, so the lynx PCS changes can move forward.
>
> I even tried to move felix forward by sending a patch for it, and I
> just gave up with that approach based on your comment.
>
> Shrug.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

The callbacks clearly work the way they are, given the current
structure of phylink, as proven by the users of this driver. Code that
isn't there yet simply isn't there yet.

What you consider "useless churn" and what I consider "useless churn"
are pretty different things.
To me, patch 7/7 is the useless churn, that's why it's at the end.
Patches 1-6 are structured in a way that is compatible with
backporting to a stable 5.4 tree. Patch 7, not so much.

The fact that you have such an attitude and you make the effort to
actually send an email complaining about me using state->speed in
.mac_config(), when literally 3 patches later I'm moving this
configuration where you want it to be, is pretty annoying.
