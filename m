Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8BF58EFDA
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiHJP5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiHJP44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:56:56 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E16647EA
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 08:56:37 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id j42-20020a4a88ad000000b00442fbe0a601so2638990ooa.11
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 08:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=MyyYsWnNuRMUjd2eI/Dvu8Th4mgBO3EpdltSOaGhqQI=;
        b=oBBr2ryopAc+YzuBfud3NhlgOw0q5S0KtoYsty8e5t32fVmLSAU9i40L4NsWvhmDs4
         QsXNoWSgL6o1ITOgdIMF4x5buwF33hP4io8LFszlrlYW7C2eby2b3jbXfVyUwISw/cdI
         iSBBXhHeQhT8mchzODNh2OU+z4tmVzDzUlU21wfU62E/es0dgPFfDLd9gdRCuKwR/0wb
         NGeAkKDSrRZGfilGv8N/i7aCrl5KnIYVa4EVPEypc5Ph5+i+O+PPMwhga16C7fyEe4Xg
         K1SfpbM8BnpAU+V9oukAS0voMAeLkE86YJKhabz6Fr2aUdXm2j6UFq4Ar2OViWlWoJAD
         JjUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=MyyYsWnNuRMUjd2eI/Dvu8Th4mgBO3EpdltSOaGhqQI=;
        b=4W3d9Cv13xBZ9EpcoQ2EXXVFeN4kEYFIe65Zs5VyItOKs3TYqsj/TzzSA8uupfdy7r
         9xQ6jxGG8XCLbTzdDlvb2y3IiZOk6KlNHKb4jDshEHmTsSGuO9dalKJpIaa3/TTLEn9U
         VVE7CUitjhcJwaa3Ln6tbKZuO+BAcEH++bNQtkiuN4mJediGISmD7J860LVG43au+LO9
         F5YLDZleV/O8D5dvZ2wQZLBACr24OVJpgZTp7cAf0FztT+s0NtyouYfhKu8x0zuqA4HG
         c08uwuWdfHKSGIsF0mFr7o9qY1xy7uE+oUCkc+MK+V0l/LKfYPajAXVGqXcex4yB854Q
         8fQg==
X-Gm-Message-State: ACgBeo1Od6JgyIbWyIqJsVeZMKWrEU/nASi1H4HnGyGJxrag/H4ZHDzO
        Dj/j6dSifWboWggCZf36d4lPoW+7Rx8d1+xsGq0=
X-Google-Smtp-Source: AA6agR5oQ/Ep5E4xUTrccnJDM9vidSKRsc1QhBVLP58WuXCVrgkYhlCYahhLVxzijjb3IqvO4Vx/zT8hNodOhVffUzg=
X-Received: by 2002:a05:6820:180b:b0:435:9610:e9ac with SMTP id
 bn11-20020a056820180b00b004359610e9acmr9762523oob.14.1660146996929; Wed, 10
 Aug 2022 08:56:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220810082745.1466895-1-saproj@gmail.com> <20220810100818.greurtz6csgnfggv@skbuf>
 <CABikg9zb7z8p7tE0H+fpmB_NSK3YVS-Sy4sqWbihziFdPBoL+Q@mail.gmail.com> <20220810133531.wia2oznylkjrgje2@skbuf>
In-Reply-To: <20220810133531.wia2oznylkjrgje2@skbuf>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Wed, 10 Aug 2022 18:56:25 +0300
Message-ID: <CABikg9yVpQaU_cf+iuPn5EV0Hn9ydwigdmZrrdStq7y-y+=YsQ@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6060: report max mtu 1536
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Aug 2022 at 16:35, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Wed, Aug 10, 2022 at 03:00:20PM +0300, Sergei Antonov wrote:
> > > >       val = addr[0] << 8 | addr[1];
> > > >
> > > >       /* The multicast bit is always transmitted as a zero, so the switch uses
> > > > @@ -212,6 +211,11 @@ static int mv88e6060_setup(struct dsa_switch *ds)
> > > >       return 0;
> > > >  }
> > > >
> > > > +static int mv88e6060_port_max_mtu(struct dsa_switch *ds, int port)
> > > > +{
> > > > +     return MV88E6060_MAX_MTU;
> > > > +}
> > >
> > > Does this solve any problem? It's ok for the hardware MTU to be higher
> > > than advertised. The problem is when the hardware doesn't accept what
> > > the stack thinks it should.
> >
> > I need some time to reconstruct the problem. IIRC there was an attempt
> > to set MTU 1504 (1500 + a switch overhead), but can not reproduce it
> > at the moment.
>
> What kernel are you using? According to Documentation/process/maintainer-netdev.rst,
> you should test the patches you submit against the master branch from one of
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
> or
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
> depending on whether it's a new feature or if it fixes a problem.
>
> Currently, both net and net-next contain the same thing (we are in a
> merge window so net-next will not progress until kernel 6.0-rc1 is cut),
> which is that dsa_slave_change_mtu() will not do anything because of
> this:
>
>         if (!ds->ops->port_change_mtu)
>                 return -EOPNOTSUPP;
>
> (which mv88e6060 does not implement)
>
> So I am slightly doubtful that anyone attempts an MTU change for this
> switch, as you say.
>
> The DSA master (host port, not switch), on the other hand, is a
> different story. Its MTU is updated to 1504 by dsa_master_setup().
>
> > > You're the first person to submit a patch on mv88e6060 that I see.
> > > Is there a board with this switch available somewhere? Does the driver
> > > still work?
> >
> > Very nice to get your feedback. Because, yes, I am working with a
> > device which has mv88e6060, it is called MOXA NPort 6610.
> >
> > The driver works now. There was one problem which I had to workaround.
> > Inside my device only ports 2 and 5 are used, so I initially wrote in
> > .dts:
> >         switch@0 {
> >                 compatible = "marvell,mv88e6060";
> >                 reg = <16>;
>
> reg = <16> for switch@0? Something is wrong, probably switch@0.

Thanks for noticing it.
In my case the device addresses are:
  PHY Registers - 0x10-0x14
  Switch Core Registers - 0x18-0x1D
  Switch Global Registers - 0x1F
I renamed switch@0 to switch@10 and made reg hexadecimal for clarity:
"reg = <0x10>". It works, see below for more information on testing.
Should I leave it like so?

> > 2. Insert this code at the beginning of mv88e6060_setup_port():
> > if(!dsa_is_cpu_port(priv->ds, p) && !dsa_to_port(priv->ds, p)->cpu_dp)
> >     return 0;
> > 'cpu_dp' was the null pointer the driver crashed at.
>
> You mean here:
>
>                         (dsa_is_cpu_port(priv->ds, p) ?
>                          dsa_user_ports(priv->ds) :
>                          BIT(dsa_to_port(priv->ds, p)->cpu_dp->index)));

Yes.

> Yes, this is a limitation that has been made worse by blind code
> conversions (nobody seems to have the hardware or to know someone who
> does; I've been tempted to delete the driver a few times or at least to
> move it to staging, because of the unrealistically long delays until
> someone chirps that something is broken for it, even when it obviously is).
> The driver assumes that if the port isn't a CPU port, it's a user port.
> That's clearly false.
>
> You can probably put this at the beginning of mv88e6060_setup_port():
>
>         if (dsa_is_unused_port(priv->ds, p))
>                 return 0;
>
> The bug seems to have been introduced by commit 0abfd494deef ("net: dsa:
> use dedicated CPU port"), because, although before we'd be uselessly
> programming the port VLAN for a disabled port, now in doing so, we
> dereference a NULL pointer.

The suggested fix with dsa_is_unused_port() works. I tested it on the
'netdev/net.git' repo, see below. Should I submit it as a patch
(Fixes: 0abfd494deef)?

So I tested "dsa_is_unused_port()" and "switch@10" fixes with
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
What I did after system boot-up:

~ # dmesg | grep mv88
[    7.187296] mv88e6060 92000090.mdio--1-mii:10: switch Marvell
88E6060 (B0) detected
[    8.325712] mv88e6060 92000090.mdio--1-mii:10: switch Marvell
88E6060 (B0) detected
[    9.190299] mv88e6060 92000090.mdio--1-mii:10 lan2 (uninitialized):
PHY [dsa-0.0:02] driver [Generic PHY] (irq=POLL)

~ # ip a
1: lo: <LOOPBACK> mtu 65536 qdisc noop qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST> mtu 1504 qdisc noop qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
3: lan2@eth0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff

~ # ip link set dev eth0 address 00:90:e8:00:10:03 up

~ # ip a add 192.168.127.254/24 dev lan2

~ # ip link set dev lan2 address 00:90:e8:00:10:03 up
[   56.383801] DSA: failed to set STP state 3 (-95)
[   56.385491] mv88e6060 92000090.mdio--1-mii:10 lan2: configuring for
phy/gmii link mode
[   58.694319] mv88e6060 92000090.mdio--1-mii:10 lan2: Link is Up -
100Mbps/Full - flow control off
[   58.699244] IPv6: ADDRCONF(NETDEV_CHANGE): lan2: link becomes ready

~ # ip a
1: lo: <LOOPBACK> mtu 65536 qdisc noop qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1504 qdisc pfifo_fast qlen 1000
    link/ether 00:90:e8:00:10:03 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::290:e8ff:fe00:1003/64 scope link
       valid_lft forever preferred_lft forever
3: lan2@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue qlen 1000
    link/ether 00:90:e8:00:10:03 brd ff:ff:ff:ff:ff:ff
    inet 192.168.127.254/24 scope global lan2
       valid_lft forever preferred_lft forever
    inet6 fe80::290:e8ff:fe00:1003/64 scope link
       valid_lft forever preferred_lft forever

Ping, ssh, scp work.

Is it correct for eth0 and lan2@eth0 to have the same MAC? I could not
make it work with different MACs.

> FWIW, in case there is ever a need to backport, the vintage-correct fix
> would be to use something like this:
>
>         if (!dsa_port_is_valid(priv->ds->ports[p]))
>                 return 0;
>
> but in that case the process is:
> - send patch against current "net" tree
> - wait until patch is queued up for "linux-stable" and backported as far
>   as possible
> - email will be sent that patch failed to apply to the still-maintained
>   LTS branches as far as the Fixes: tag required (this is why it is
>   important to populate the Fixes: tag correctly)
> - reply to that email with a manually backported patch, just for that
>   stable tree (linux-4.14.y etc)
>
> >
> > One more observation. Generating and setting a random MAC in
> > mv88e6060_setup_addr() is not necessary - the switch works without it
> > (at least in my case).
>
> The GLOBAL_MAC address that the switch uses there will be used as MAC SA
> in PAUSE frames (802.3 flow control). Not clear if you were aware of
> that fact when saying that the switch "works without it". In other words,
> if you make a change in that area, I expect that flow control is what
> you test, and not, say, ping.
>
> It's true that some other switches use a MAC SA of 00:00:00:00:00:00 for
> PAUSE frames (ocelot_init_port) and this hasn't caused a problem for them.
> I don't know if the 6060 supports this mode. If it does, it's worth a shot.

I don't know how to test flow control. Ping, ssh, scp work even with
mv88e6060_setup_addr() code removed. Of course, if MAC SA plays some
role in other scenarios, let it be :).
