Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407DA3FF4D3
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 22:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346091AbhIBUW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 16:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbhIBUW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 16:22:26 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4B3C061575;
        Thu,  2 Sep 2021 13:21:27 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id g21so4749126edw.4;
        Thu, 02 Sep 2021 13:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=AFcTJM/1mhNsgSgPURjx0gJ3fOMmNuJ4K813cVRnYVk=;
        b=itrqqWrCMK/r+xsLy+tUfzWIWp2tlWX5pTAYZW9sVDuoOHHaukHQkyAlqPC5MPOs0j
         p7SgxY0Y4m+yEKIH8p+EBF9SQBjaljHwGftI88BaIWXsrys77OUe5GdrIEASrzxlTjxy
         qt1alNX+6DDn54i0oHp4ZB4ZYs/jgftbd+f61xWbm2RdFcl/kOCnckw1ZtOhzJXeiQN0
         TbV5YYjfWspD3oW58TmifB4CbtWLcEbxYK9KhLkPihg0ZRVOVm/gtzW/za25HgE2vSSc
         8MdjENR5h1J0wRjGZpBY9mTiml2hJ+InEtS3tKJ5+IWUw6rI7XI7jbhuUB+Bq4RMIVJH
         2RMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=AFcTJM/1mhNsgSgPURjx0gJ3fOMmNuJ4K813cVRnYVk=;
        b=FU/xZm48z9p5X7UTH1cbSJhqOKboOz5gBpXbj6TMoxWJ5z+nN228q/M6ijvCdNPN8j
         iaaeHTB+rBJ26sBMyJVYC98gfwxY0sldH5kH7vkKJXstymDBypZ3Ia0v2w5Fm/pyeIAW
         vXnsl4tMZglCRSZfonFe+Xio0CMOqYM/J/I4vLq/3TzKwn1kXVrAg1blkCJpvy1b4xNk
         QBZ4HXEY34H402XmsAzd8fNnjkzlkbfTHIE3EG2IcJ+WKQyDSlVsv8WNwmvkpyQ5kbCi
         lmtswaulBspePDzz9OqNW+7Xj7EE/kegBMR9DjJqjR/s4Q6ChKOvg56li1Rfo7NyirKN
         icHA==
X-Gm-Message-State: AOAM532CX6Pz8nNv6evHRzjUeWRhtfRmR5gUElm658OrLhdMwVbUFBx7
        opfgFgVCJjelSrpqX3Mk/7s=
X-Google-Smtp-Source: ABdhPJyV7/E/wloHWVt8oJoNY02iTbn4GPJ/wFEaqR2C8ezOUCOj2KCMggLFCY4qFWtnb6jl8HtcpA==
X-Received: by 2002:aa7:c313:: with SMTP id l19mr137763edq.131.1630614086275;
        Thu, 02 Sep 2021 13:21:26 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id b5sm1630291ejq.56.2021.09.02.13.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 13:21:25 -0700 (PDT)
Date:   Thu, 2 Sep 2021 23:21:24 +0300
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
Message-ID: <20210902202124.o5lcnukdzjkbft7l@skbuf>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210902121927.GE22278@shell.armlinux.org.uk>
 <20210902123532.ruvuecxoig67yv5v@skbuf>
 <20210902132635.GG22278@shell.armlinux.org.uk>
 <20210902152342.vett7qfhvhiyejvo@skbuf>
 <20210902163144.GH22278@shell.armlinux.org.uk>
 <20210902171033.4byfnu3g25ptnghg@skbuf>
 <20210902175043.GK22278@shell.armlinux.org.uk>
 <20210902190507.shcdmfi3v55l2zuj@skbuf>
 <20210902200301.GM22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210902200301.GM22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 09:03:01PM +0100, Russell King (Oracle) wrote:
> On Thu, Sep 02, 2021 at 10:05:07PM +0300, Vladimir Oltean wrote:
> > On Thu, Sep 02, 2021 at 06:50:43PM +0100, Russell King (Oracle) wrote:
> > > On Thu, Sep 02, 2021 at 05:10:34PM +0000, Vladimir Oltean wrote:
> > > > On Thu, Sep 02, 2021 at 05:31:44PM +0100, Russell King (Oracle) wrote:
> > > > > On Thu, Sep 02, 2021 at 06:23:42PM +0300, Vladimir Oltean wrote:
> > > > > > On Thu, Sep 02, 2021 at 02:26:35PM +0100, Russell King (Oracle) wrote:
> > > > > > > Debian has had support for configuring bridges at boot time via
> > > > > > > the interfaces file for years. Breaking that is going to upset a
> > > > > > > lot of people (me included) resulting in busted networks. It
> > > > > > > would be a sure way to make oneself unpopular.
> > > > > > >
> > > > > > > > I expect there to be 2 call paths of phy_attach_direct:
> > > > > > > > - At probe time. Both the MAC driver and the PHY driver are probing.
> > > > > > > >   This is what has this patch addresses. There is no issue to return
> > > > > > > >   -EPROBE_DEFER at that time, since drivers connect to the PHY before
> > > > > > > >   they register their netdev. So if connecting defers, there is no
> > > > > > > >   netdev to unregister, and user space knows nothing of this.
> > > > > > > > - At .ndo_open time. This is where it maybe gets interesting, but not to
> > > > > > > >   user space. If you open a netdev and it connects to the PHY then, I
> > > > > > > >   wouldn't expect the PHY to be undergoing a probing process, all of
> > > > > > > >   that should have been settled by then, should it not? Where it might
> > > > > > > >   get interesting is with NFS root, and I admit I haven't tested that.
> > > > > > >
> > > > > > > I don't think you can make that assumption. Consider the case where
> > > > > > > systemd is being used, DSA stuff is modular, and we're trying to
> > > > > > > setup a bridge device on DSA. DSA could be probing while the bridge
> > > > > > > is being setup.
> > > > > > >
> > > > > > > Sadly, this isn't theoretical. I've ended up needing:
> > > > > > >
> > > > > > > 	pre-up sleep 1
> > > > > > >
> > > > > > > in my bridge configuration to allow time for DSA to finish probing.
> > > > > > > It's not a pleasant solution, nor a particularly reliable one at
> > > > > > > that, but it currently works around the problem.
> > > > > >
> > > > > > What problem? This is the first time I've heard of this report, and you
> > > > > > should definitely not need that.
> > > > >
> > > > > I found it when upgrading the Clearfog by the DSL modems to v5.13.
> > > > > When I rebooted it with a previously working kernel (v5.7) it has
> > > > > never had a problem. With v5.13, it failed to add all the lan ports
> > > > > into the bridge, because the bridge was still being setup by the
> > > > > kernel while userspace was trying to configure it. Note that I have
> > > > > extra debug in my kernels, hence the extra messages:
> > > >
> > > > Ok, first you talked about the interfaces file, then systemd. If it's
> > > > not about systemd's network manager then I don't see how it is relevant.
> > >
> > > You're reading in stuff to what I write that I did not write... I said:
> > >
> > > "Consider the case where systemd is being used, DSA stuff is modular,
> > > and we're trying to setup a bridge device on DSA."
> > >
> > > That does not mean I'm using systemd's network manager - which is
> > > something I know little about and have never used.
> > 
> > You should definitely try it out, it gets a lot of new features added
> > all the time, it uses the netlink interface, it reacts on udev events.
> > 
> > > The reason I mentioned systemd is precisely because with systemd, you
> > > get a hell of a lot happening parallel - and that's significiant in
> > > this case, because it's very clear that modules are being loaded in
> > > parallel with networking being brought up - and that is where the
> > > problems begin. In fact, modules themselves get loaded in paralllel
> > > with systemd.
> > 
> > So that's what I don't understand. You're saying that the ifupdown
> > service runs in parallel with systemd-modules-load.service, and
> > networking is a kernel module? Doesn't that mean it behaves as expected,
> > then? /shrug/
> > Have you tried adding an 'After=systemd-modules-load.service' dependency
> > to the ifupdown service? I don't think that DSA is that bad that it
> > registers its net devices outside of the process context in which the
> > insmod mv88e6xxx.ko is called. Quite the opposite, I think (but I
> > haven't actually taken a close look yet) that the component stuff
> > Saravana is proposing would do exactly that. So you "fix" one issue, you
> > introduce another.
> 
> # systemctl list-dependencies networking.service
> networking.service
>   ├─ifupdown-pre.service
>   ├─system.slice
>   └─network.target
> # systemctl list-dependencies ifupdown-pre.service
> ifupdown-pre.service
>   ├─system.slice
>   └─systemd-udevd.service
> 
> Looking in the service files for a better idea:
> 
> networking.service:
> Requires=ifupdown-pre.service
> Wants=network.target
> After=local-fs.target network-pre.target apparmor.service systemd-sysctl.service systemd-modules-load.service ifupdown-pre.service
> Before=network.target shutdown.target network-online.target
> 
> ifupdown-pre.service:
> Wants=systemd-udevd.service
> After=systemd-udev-trigger.service
> Before=network.target
> 
> So, the dependency you mention is already present. As is a dependency
> on udev. The problem is udev does all the automatic module loading
> asynchronously and in a multithreaded way.
> 
> I don't think there's a way to make systemd wait for all module loads
> to complete.

So ifupdown-pre.service has a call to "udevadm settle". This "watches
the udev event queue, and exits if all current events are handled",
according to the man page. But which current events? ifupdown-pre.service
does not have the dependency on systemd-modules-load.service, just
networking.service does. So maybe ifupdown-pre.service does not wait for
DSA to finish initializing, then it tells networking.service that all is ok.
