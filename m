Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72ED91080A6
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 21:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKWUrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 15:47:08 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35863 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWUrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 15:47:07 -0500
Received: by mail-ed1-f67.google.com with SMTP id f7so9071851edq.3
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 12:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ryizMM2YacY3T6gwYV6d4yvs9KWczS+VkPonMo/jXEI=;
        b=rTc2pnUfe02I7xpoN62PonssLbr56CRAX2Kkcq/A98jUymLe4yMzNHfHKlBJLV4nEw
         vr2bDxjCymCmYxdkUd82V4EhPsH7ErCOIU28Lf8PHALIIhe04hJfu4qv1r01k9bVJG4I
         GouvNyNXgs6PI/Dl45LDAhOkXUTqTMo6mEQ82VEXx44LGMlsBVGhnWpXexEyF9h335kC
         +lDl1syAHSEJQL24Cw5gggjUmMG5/VKIq+M8V06esmi+zDkZeg7gQAt8+9+L4iTQo47l
         5oK5LPFLtwANcyzpm557up4AmJU7lJilEJa+110JmS2ylJIlRGaHUOFYQFq3pVQxfvdC
         aSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ryizMM2YacY3T6gwYV6d4yvs9KWczS+VkPonMo/jXEI=;
        b=MrSKomGloICvjrNO7bWrLHwXIM1TUPp29JS3rtmCGPV4AlpFWeIkIx1MnZRoQRbjDx
         IqvQ+HDfpWsZaIEMHVydEL/2aQnKJIUBc0sZgN3ZpCOv3NVqo9pjdbTY3goOw8/DxexR
         hbXNnuaTtH8JcN1hvyU1DEqDw2XNZd1SBqDfyvsER+dw9tujEK8LWH+wLs/GJb45BUgu
         8kpVM2jhhNwO0gGRARjjAExCfB2t9R9qSMqcZIO0gG2sn500HzvcvjaA4R7mo/dOXbhK
         AnbOxixPfYlIKNVS7TOMCmOcHJyO5xN5ThnEkHBjwjaVRwIH8gECcIyGm9fOn7Dy1+Wu
         VsWA==
X-Gm-Message-State: APjAAAXIU6jy3ijqk/VmrgcD4C5j7X99U/LPgt0iJP8EJp1Uqg0mK+Ta
        njmLwelANTIUL7EBjKBdjGyPqehM972OMjHQl+Q=
X-Google-Smtp-Source: APXvYqwuhUczwo6fasaet81DAy5woBLZ4adWPCHzUC4pc4LHJcgWp0MIfKh+VOKSNnNjsR/Pi7GIB8xDlTgJ4Ube1Co=
X-Received: by 2002:a05:6402:51:: with SMTP id f17mr8919454edu.123.1574542023752;
 Sat, 23 Nov 2019 12:47:03 -0800 (PST)
MIME-Version: 1.0
References: <20191123194844.9508-1-olteanv@gmail.com> <20191123194844.9508-2-olteanv@gmail.com>
 <329f394b-9e6c-d3b0-dc3d-5e3707fa8dd7@gmail.com>
In-Reply-To: <329f394b-9e6c-d3b0-dc3d-5e3707fa8dd7@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 23 Nov 2019 22:46:52 +0200
Message-ID: <CA+h21hpcvGZavmSZK3KEjfKVDt6ySw2Fv42EVfp5HxbZoesSqg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: dsa: Configure the MTU for switch ports
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Nov 2019 at 22:28, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> Hi Vladimir,
>
> On 11/23/2019 11:48 AM, Vladimir Oltean wrote:
> > It is useful be able to configure port policers on a switch to accept
> > frames of various sizes:
> >
> > - Increase the MTU for better throughput from the default of 1500 if it
> >   is known that there is no 10/100 Mbps device in the network.
> > - Decrease the MTU to limit the latency of high-priority frames under
> >   congestion.
> >
> > For DSA slave ports, this is mostly a pass-through callback, called
> > through the regular ndo ops and at probe time (to ensure consistency
> > across all supported switches).
> >
> > The CPU port is called with an MTU equal to the largest configured MTU
> > of the slave ports. The assumption is that the user might want to
> > sustain a bidirectional conversation with a partner over any switch
> > port.
> >
> > The DSA master is configured the same as the CPU port, plus the tagger
> > overhead. Since the MTU is by definition L2 payload (sans Ethernet
> > header), it is up to each individual driver to figure out if it needs to
> > do anything special for its frame tags on the CPU port (it shouldn't
> > except in special cases). So the MTU does not contain the tagger
> > overhead on the CPU port.
> > However the MTU of the DSA master, minus the tagger overhead, is used as
> > a proxy for the MTU of the CPU port, which does not have a net device.
> > This is to avoid uselessly calling the .change_mtu function on the CPU
> > port when nothing should change.
> >
> > So it is safe to assume that the DSA master and the CPU port MTUs are
> > apart by exactly the tagger's overhead in bytes.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
>
> [snip]
> > +static int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
> > +{
> > +     struct net_device *master = dsa_slave_to_master(dev);
> > +     struct dsa_slave_priv *p = netdev_priv(dev);
> > +     struct dsa_switch *ds = p->dp->ds;
> > +     struct dsa_port *cpu_dp;
> > +     int port = p->dp->index;
> > +     int max_mtu = 0;
> > +     int cpu_mtu;
> > +     int err, i;
> > +
> > +     if (!ds->ops->change_mtu)
> > +             return -EOPNOTSUPP;
> > +
> > +     err = ds->ops->change_mtu(ds, port, new_mtu);
> > +     if (err < 0)
> > +             return err;
> > +
> > +     dev->mtu = new_mtu;
> > +
> > +     for (i = 0; i < ds->num_ports; i++) {
> > +             if (!dsa_is_user_port(ds, i))
> > +                     continue;
> > +
> > +             /* During probe, this function will be called for each slave
> > +              * device, while not all of them have been allocated. That's
> > +              * ok, it doesn't change what the maximum is, so ignore it.
> > +              */
> > +             if (!dsa_to_port(ds, i)->slave)
> > +                     continue;
> > +
> > +             if (max_mtu < dsa_to_port(ds, i)->slave->mtu)
> > +                     max_mtu = dsa_to_port(ds, i)->slave->mtu;
> > +     }
> > +
> > +     cpu_dp = dsa_to_port(ds, port)->cpu_dp;
> > +
> > +     max_mtu += cpu_dp->tag_ops->overhead;
> > +     cpu_mtu = master->mtu;
> > +
> > +     if (max_mtu != cpu_mtu) {
> > +             err = ds->ops->change_mtu(ds, dsa_upstream_port(ds, port),
> > +                                       max_mtu - cpu_dp->tag_ops->overhead);
> > +             if (err < 0)
> > +                     return err;
>
> Before changing and committing the slave_dev's MTU you should actually
> perform these two operations first to make sure that you can honor the
> user port MTU that is requested. Here, you would possibly leave an user
> port configured for a MTU value that is unsupported by the upstream
> port(s) and/or the CPU port and/or the DSA master device, which could
> possibly break frame forwarding depending on what the switch is willing
> to accept.
>

Correct. I was actually held back a bit while looking at Andrew's
patch dc0fe7d47f9f ("net: dsa: Set the master device's MTU to account
for DSA overheads") where he basically discarded errors, so that's the
approach I took too (thinking that some DSA masters would not have ops
for changing or reporting the MTU).

> I had prepared a patch series with Murali doing nearly the same thing
> and targeting Broadcom switches nearly a year ago but since I never got
> feedback whether this worked properly for the use case he was after, I
> did not submit it since I did not need it personally and found it to be
> a nice can of worms.
>

Nice, do you mind if I take your series instead then?

> Another thing that I had not gotten around testing was making sure that
> when a slave_dev gets enslaved as a bridge port member, that bridge MTU
> normalization would kick in and make sure that if you have say: port 0
> configured with MTU 1500 and port 1 configured with MTU 9000, the bridge
> would normalize to MTU 1500 as you would expect.
>

Nope, that doesn't happen by default, at least in my implementation.
Is there code in the bridge core for it?

> https://github.com/ffainelli/linux/commits/dsa-mtu
>
> This should be a DSA switch fabric notifier IMHO because changing the
> MTU on an user port implies changing the MTU on every DSA port in
> between plus the CPU port. Your approach here works for the first
> upstream port, but not for the ones in between, and there can be more,
> as is common with the ZII devel Rev. B and C boards.

Yes, correct. Your patch implements notifiers which is definitely
good. I don't have a cascaded setup to test yet (my Turris Mox was
supposed to arrive but for some reason it was returned to the seller
by the shipping company...).

> --
> Florian

Thanks,
-Vladimir
