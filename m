Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379DE318746
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 10:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhBKJpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 04:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbhBKJgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 04:36:11 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D0EC0613D6;
        Thu, 11 Feb 2021 01:35:31 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id v7so6205689eds.10;
        Thu, 11 Feb 2021 01:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HCKcRp36jKpHDKsIoPlzTnpZmo2FFbM2qog3PW0onGA=;
        b=TeiLXz9uxBxr0RNLjVXoPdeXMU0vPvWH8GKmzaoGwcRAJXsTI4sqzxOFft+uqhVGuC
         3S9oJr9Bmqno+SA0dcWdgHYCedaajyGqKGGsc4xOvKVy8ccz5UCqmA9KGLNBJDQaHyEG
         VHmGPZwltdjper4JRzS3iuFYi5MKTUwcZTW93JdLwWT0LQ5Ozfo8NtuD8UXSa8rxJG98
         duXnERXYtR00eFVh969nmkyAfAQn5FIk7IZk8DQ8mfBZ9ACEpMUQuoZi4trlE87QtLbk
         l6E7NDEkQfzssfWAqKcV7mUOOqzDzKsGW5xcfmtpxgupkGs5LODApcHB9z1WBU5SSiy8
         APiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HCKcRp36jKpHDKsIoPlzTnpZmo2FFbM2qog3PW0onGA=;
        b=TaXxM2+imbuLww34foKeZTzbrRrlgR3+/aMwHdFcFFkuxfRnrX6B5eGMKzs+MYo6Gd
         iiHAlXQMML7Jm0ZbyiUjP59jJt9nuv6u9Q27WPr3A3cZ1gJDw9t02P3KRyVygZmoctyE
         3GbeOtV5Od+rZUesmPwnCOWYQlFFgQtUNGqhVXGTjHRbd9jY+qqDopmxpjTcm3CAPcH5
         RCsCIqM9xbs1R/+ZU88tENXMKW6xZgcRAo5Cfnd6RJdA8bTvUpjD8teqNtYqpUm7pUj6
         deOs98VMtE5VMgPuNsgGThDh5m8bc+U8vmka02ksZVbM+P5cc/Nw49X7w3OULMk4wjde
         30UQ==
X-Gm-Message-State: AOAM531YZosmEciRjk8F9foy5++2EgnpDMh6FkgwBaYEfbz9l4Pcw+wb
        EQiHPzgVlX2Rd3b/9BCM7xA=
X-Google-Smtp-Source: ABdhPJzhRp4lLIofJYT+F83VReZpVe64dnuAnm/l2lEP0HrHgktCW0qPgvBMYd1i8qGDsCWxZbC3Rg==
X-Received: by 2002:a05:6402:c7:: with SMTP id i7mr7618522edu.328.1613036129899;
        Thu, 11 Feb 2021 01:35:29 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id cb21sm3396330edb.57.2021.02.11.01.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 01:35:29 -0800 (PST)
Date:   Thu, 11 Feb 2021 11:35:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 net-next 04/11] net: bridge: offload initial and final
 port flags through switchdev
Message-ID: <20210211093527.qyaa3czumgggvm7z@skbuf>
References: <20210209151936.97382-1-olteanv@gmail.com>
 <20210209151936.97382-5-olteanv@gmail.com>
 <20210209185100.GA266253@shredder.lan>
 <20210209202045.obayorcud4fg2qqb@skbuf>
 <20210209220124.GA271860@shredder.lan>
 <20210209225153.j7u6zwnpdgskvr2v@skbuf>
 <20210210105949.GB287766@shredder.lan>
 <20210210232352.m7nqzvs2g4i74rx4@skbuf>
 <20210211074443.GB324421@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211074443.GB324421@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 09:44:43AM +0200, Ido Schimmel wrote:
> On Thu, Feb 11, 2021 at 01:23:52AM +0200, Vladimir Oltean wrote:
> > On Wed, Feb 10, 2021 at 12:59:49PM +0200, Ido Schimmel wrote:
> > > > > The reverse, during unlinking, would be to refuse unlinking if the upper
> > > > > has uppers of its own. netdev_upper_dev_unlink() needs to learn to
> > > > > return an error and callers such as team/bond need to learn to handle
> > > > > it, but it seems patchable.
> > > >
> > > > Again, this was treated prior to my deletion in this series and not by
> > > > erroring out, I just really didn't think it through.
> > > >
> > > > So you're saying that if we impose that all switchdev drivers restrict
> > > > the house of cards to be constructed from the bottom up, and destructed
> > > > from the top down, then the notification of bridge port flags can stay
> > > > in the bridge layer?
> > >
> > > I actually don't think it's a good idea to have this in the bridge in
> > > any case. I understand that it makes sense for some devices where
> > > learning, flooding, etc are port attributes, but in other devices these
> > > can be {port,vlan} attributes and then you need to take care of them
> > > when a vlan is added / deleted and not only when a port is removed from
> > > the bridge. So for such devices this really won't save anything. I would
> > > thus leave it to the lower levels to decide.
> >
> > Just for my understanding, how are per-{port,vlan} attributes such as
> > learning and flooding managed by the Linux bridge? How can I disable
> > flooding only in a certain VLAN?
>
> You can't (currently). But it does not change the fact that in some
> devices these are {port,vlan} attributes and we are talking here about
> the interface towards these devices. Having these as {port,vlan}
> attributes allows you to support use cases such as a port being enslaved
> to a VLAN-aware bridge and its VLAN upper(s) enslaved to VLAN unaware
> bridge(s).

I don't think I understand the use case really. You mean something like this?

    br1 (vlan_filtering=0)
    /           \
   /             \
 swp0.100         \
   |               \
   |(vlan_filtering \
   |  br0  =1)       \
   | /   \            \
   |/     \            \
 swp0    swp1         swp2

A packet received on swp0 with VLAN tag 100 will go to swp0.100 which
will be forwarded according to the FDB of br1, and will be delivered to
swp2 as untagged? Respectively in the other direction, a packet received
on swp2 will have a VLAN 100 tag pushed on egress towards swp0, even if
it is already VLAN-tagged?

What do you even use this for?
And also: if the {port,vlan} attributes can be simulated by making the
bridge port be an 8021q upper of a physical interface, then as far as
the bridge is concerned, they still are per-port attributes, and they
are per-{port,vlan} only as far as the switch driver is concerned -
therefore I don't see why it isn't okay for the bridge to notify the
brport flags in exactly the same way for them too.

> Obviously you need to ensure there is no conflict between the
> VLANs used by the VLAN-aware bridge and the VLAN device(s).

On the other hand I think I have a more real-life use case that I think
is in conflict with this last phrase.
I have a VLAN-aware bridge and I want to run PTP in VLAN 7, but I also
need to add VLAN 7 in the VLAN table of the bridge ports so that it
doesn't drop traffic. PTP is link-local, so I need to run it on VLAN
uppers of the switch ports. Like this:

ip link add br0 type bridge vlan_filtering 1
ip link set swp0 master br0
ip link set swp1 master br0
bridge vlan add dev swp0 vid 7 master
bridge vlan add dev swp1 vid 7 master
bridge vlan add dev br0 vid 7 self
ip link add link swp0 name swp0.7 type vlan id 7
ip link add link swp1 name swp0.7 type vlan id 7
ptp4l -i swp0.7 -i swp1.7 -m

How can I do that considering that you recommend avoiding conflicts
between the VLAN-aware bridge and 8021q uppers? Or is that true only
when the 8021q uppers are bridged?
