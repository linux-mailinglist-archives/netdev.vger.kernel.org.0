Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BAA3FF3C5
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347257AbhIBTGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347090AbhIBTGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 15:06:09 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AED8C061575;
        Thu,  2 Sep 2021 12:05:10 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id q17so4471150edv.2;
        Thu, 02 Sep 2021 12:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F3V7EjM9yRS05v9IOxp0t6fq7hXaIjKJDbM8wh8rkpk=;
        b=EF/FsMDX4vrswrhLo9RSoWV7HVr/ZuqCV/v0uXSO4x2FsIxogZq5BuPlR+fsgfohcH
         zI0QY9+Dt2Pif4GIio7YUYPjwq0IzvxcH4KX75/77YnDRCOygKHqN3GAc2qtWAcAAwfG
         zTgIys+QTvqR2qSOb7PG8M4ZZok4O45gV6JIRiCGCG0xhdJ3v9AEK6uB36cICO/IXyky
         m759QMzjFOH/t81EWzu0meQM0wCKpNTV8lSasgcJ1DE0agc0hpifYPSeo9sf7QQ7axQA
         5VWPoQ4LtoVhTx+yVrNHp2RkYQ1WTfZuLL4GWWLqY+yGDYy321Qvv/UFbQtNLe/sLB69
         TmXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F3V7EjM9yRS05v9IOxp0t6fq7hXaIjKJDbM8wh8rkpk=;
        b=bw+XrO+WlTvznO8xueA4U28srzpnhJ2ILPeZD0P378wfkr2st+oJOMn4TD3IR9OVuJ
         Y9Tuz0DkUZyYcqqnbR8TLkFvj0DgyrdE4X/Ed9pG53/NB6OsDngpYxE/dyxa3Q/KONo/
         5ScTKnxwOGFS+E3aq2QwjQhYXVY9CsEdXJ2g0zm3l4MtHqC4NmKjOXl1olVTKbwDQg/z
         uXxOinl+6T3woh0Ja3qmMTCfFpfgFN9a8IMRMuB0zdu+uuGr5FLok6xOxE7dOpQJf/CZ
         Pb5nxtIYMTXsBGVR3hTaR0qRgmNC+g+ExadsZvpyEY8pKjo5odbyVaznlnPUVqXi0kCT
         cT4Q==
X-Gm-Message-State: AOAM533+2FjBh5YJ7HZ/P+jC/HawG3z8Ao+cx/tLZzcyDQfMUPRHA1nI
        PBKE7nGVEUj6xOWVgWWJaRg=
X-Google-Smtp-Source: ABdhPJyd8Bmg4wTz9yS3MrergaOCvIa58tdB0/8KB3W3Zu4EZnAbYLxBZhK6TzvvUv2aFpWJsMwTyw==
X-Received: by 2002:aa7:d986:: with SMTP id u6mr5083172eds.156.1630609508814;
        Thu, 02 Sep 2021 12:05:08 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id b2sm1574735ejj.124.2021.09.02.12.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 12:05:08 -0700 (PDT)
Date:   Thu, 2 Sep 2021 22:05:07 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <20210902190507.shcdmfi3v55l2zuj@skbuf>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210902121927.GE22278@shell.armlinux.org.uk>
 <20210902123532.ruvuecxoig67yv5v@skbuf>
 <20210902132635.GG22278@shell.armlinux.org.uk>
 <20210902152342.vett7qfhvhiyejvo@skbuf>
 <20210902163144.GH22278@shell.armlinux.org.uk>
 <20210902171033.4byfnu3g25ptnghg@skbuf>
 <20210902175043.GK22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902175043.GK22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 06:50:43PM +0100, Russell King (Oracle) wrote:
> On Thu, Sep 02, 2021 at 05:10:34PM +0000, Vladimir Oltean wrote:
> > On Thu, Sep 02, 2021 at 05:31:44PM +0100, Russell King (Oracle) wrote:
> > > On Thu, Sep 02, 2021 at 06:23:42PM +0300, Vladimir Oltean wrote:
> > > > On Thu, Sep 02, 2021 at 02:26:35PM +0100, Russell King (Oracle) wrote:
> > > > > Debian has had support for configuring bridges at boot time via
> > > > > the interfaces file for years. Breaking that is going to upset a
> > > > > lot of people (me included) resulting in busted networks. It
> > > > > would be a sure way to make oneself unpopular.
> > > > >
> > > > > > I expect there to be 2 call paths of phy_attach_direct:
> > > > > > - At probe time. Both the MAC driver and the PHY driver are probing.
> > > > > >   This is what has this patch addresses. There is no issue to return
> > > > > >   -EPROBE_DEFER at that time, since drivers connect to the PHY before
> > > > > >   they register their netdev. So if connecting defers, there is no
> > > > > >   netdev to unregister, and user space knows nothing of this.
> > > > > > - At .ndo_open time. This is where it maybe gets interesting, but not to
> > > > > >   user space. If you open a netdev and it connects to the PHY then, I
> > > > > >   wouldn't expect the PHY to be undergoing a probing process, all of
> > > > > >   that should have been settled by then, should it not? Where it might
> > > > > >   get interesting is with NFS root, and I admit I haven't tested that.
> > > > >
> > > > > I don't think you can make that assumption. Consider the case where
> > > > > systemd is being used, DSA stuff is modular, and we're trying to
> > > > > setup a bridge device on DSA. DSA could be probing while the bridge
> > > > > is being setup.
> > > > >
> > > > > Sadly, this isn't theoretical. I've ended up needing:
> > > > >
> > > > > 	pre-up sleep 1
> > > > >
> > > > > in my bridge configuration to allow time for DSA to finish probing.
> > > > > It's not a pleasant solution, nor a particularly reliable one at
> > > > > that, but it currently works around the problem.
> > > >
> > > > What problem? This is the first time I've heard of this report, and you
> > > > should definitely not need that.
> > >
> > > I found it when upgrading the Clearfog by the DSL modems to v5.13.
> > > When I rebooted it with a previously working kernel (v5.7) it has
> > > never had a problem. With v5.13, it failed to add all the lan ports
> > > into the bridge, because the bridge was still being setup by the
> > > kernel while userspace was trying to configure it. Note that I have
> > > extra debug in my kernels, hence the extra messages:
> >
> > Ok, first you talked about the interfaces file, then systemd. If it's
> > not about systemd's network manager then I don't see how it is relevant.
>
> You're reading in stuff to what I write that I did not write... I said:
>
> "Consider the case where systemd is being used, DSA stuff is modular,
> and we're trying to setup a bridge device on DSA."
>
> That does not mean I'm using systemd's network manager - which is
> something I know little about and have never used.

You should definitely try it out, it gets a lot of new features added
all the time, it uses the netlink interface, it reacts on udev events.

> The reason I mentioned systemd is precisely because with systemd, you
> get a hell of a lot happening parallel - and that's significiant in
> this case, because it's very clear that modules are being loaded in
> parallel with networking being brought up - and that is where the
> problems begin. In fact, modules themselves get loaded in paralllel
> with systemd.

So that's what I don't understand. You're saying that the ifupdown
service runs in parallel with systemd-modules-load.service, and
networking is a kernel module? Doesn't that mean it behaves as expected,
then? /shrug/
Have you tried adding an 'After=systemd-modules-load.service' dependency
to the ifupdown service? I don't think that DSA is that bad that it
registers its net devices outside of the process context in which the
insmod mv88e6xxx.ko is called. Quite the opposite, I think (but I
haven't actually taken a close look yet) that the component stuff
Saravana is proposing would do exactly that. So you "fix" one issue, you
introduce another.
