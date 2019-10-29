Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78608E8EBC
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 18:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfJ2R4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 13:56:18 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38882 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfJ2R4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 13:56:17 -0400
Received: by mail-wr1-f67.google.com with SMTP id v9so14670919wrq.5
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 10:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9y5pAuKUQe+2mP2sM59Bqs+PcCYg/QelzhgIbR5sqHk=;
        b=bMnWnc4xjuF6LpYbt+ZL/mcJP0eo2Kl9FtQ+5gS6Ksju7a4KnGCrvqF1YRV6Q+Ke7u
         MT/cAAXLCI5jSb4XF0+SMgx+DZxsd9uEtNbR7Gqv9o2HLFmjV5Yo/+7MduRG7pnEF91Z
         TiQeROStJ1b8PhLEEmnMxhXpZ1FZEQDogWOTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9y5pAuKUQe+2mP2sM59Bqs+PcCYg/QelzhgIbR5sqHk=;
        b=i0uD56q10o6t3oqFUX1OERxiC8UbOyQ3C1oxNMq5EXQ8lNlCJOg05PjYaR4kYZ3KXJ
         DnHlJt/QsuIMWZ7rsVTjHpSYOi4X0WzcIQzwafjrl7f/gxg6I1z19OH85fXCJ0LbN8gQ
         nPAX19eewDg7tDgdckbw5cJptejY5tqPsdmQYYl2sUVBzTMVNBh59F8F07evo4dhqRcO
         eEy3cERCCsiP8ytF2RQDxDp0BpUP1OqFx+b4sXGADgcqRUm4XBk1SSXbaKGxLz7c8TeT
         8bh+jmPgXWpoanNrg6v040jhY+tEEgY3L3qAq3sXs7L8b2yQz85LRGt7a5b9VNtAakfY
         g/vA==
X-Gm-Message-State: APjAAAUPx9rXi83Dm77Lo69/HAhjj7kGIAsifqKwzU9XhfXbPkY28NRV
        Hd2GlazdZdxjq4ofnBGOsXJLlA==
X-Google-Smtp-Source: APXvYqxdVgTtMhAxKmjAtssL2oi1jS5QOGQGujQbarrLtMAN7iD+obcAKqV3DppxJANkQIqPTjvffA==
X-Received: by 2002:adf:a506:: with SMTP id i6mr20448647wrb.159.1572371773846;
        Tue, 29 Oct 2019 10:56:13 -0700 (PDT)
Received: from C02YVCJELVCG.dhcp.broadcom.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id l4sm2894418wml.33.2019.10.29.10.56.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Oct 2019 10:56:13 -0700 (PDT)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Tue, 29 Oct 2019 13:56:03 -0400
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Yuval Avnery <yuvalav@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 0/9] devlink vdev
Message-ID: <20191029175603.GA76503@C02YVCJELVCG.dhcp.broadcom.net>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
 <20191023120046.0f53b744@cakuba.netronome.com>
 <20191023192512.GA2414@nanopsycho>
 <20191023151409.75676835@cakuba.hsd1.ca.comcast.net>
 <9f3974a1-95e9-a482-3dcd-0b23246d9ab7@mellanox.com>
 <20191023195141.48775df1@cakuba.hsd1.ca.comcast.net>
 <20191025145808.GA20298@C02YVCJELVCG.dhcp.broadcom.net>
 <20191029100810.66b1695a@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029100810.66b1695a@cakuba.hsd1.ca.comcast.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 10:08:10AM -0700, Jakub Kicinski wrote:
> On Fri, 25 Oct 2019 10:58:08 -0400, Andy Gospodarek wrote:
> > Thanks, Jakub, I'm happy to chime in based on our deployment experience.
> > We definitely understand the desire to be able to configure properties
> > of devices on the SmartNIC (the kind with general purpose cores not the
> > kind with only flow offload) from the server side.
> 
> Thanks!
> 
> > In addition to addressing NVMe devices, I'd also like to be be able to
> > create virtual or real serial ports as well as there is an interest in
> > *sometimes* being able to gain direct access to the SmartNIC console not
> > just a shell via ssh.  So my point is that there are multiple use-cases.
> 
> Shelling into a NIC is the ultimate API backdoor. IMO we should try to
> avoid that as much as possible.

In the case of a network controlled device (where the host has no real
knowledge that the NIC contains general purpose cores), we definitely do
not want to shell into the NIC, but there are requests to have this
available from many users.

Even if there is a way to get console with a cable, there is an interest
in not having to wire-up a another cable for every device in the
network.

> > Arm are also _extremely_ interested in developing a method to enable
> > some form of SmartNIC discovery method and while lots of ideas have been
> > thrown around, discovery via devlink is a reasonable option.  So while
> > doing all this will be much more work than simply handling this case
> > where we set the peer or local MAC for a vdev, I think it will be worth
> > it to make this more usable for all^W more types of devices.  I also
> > agree that not everything on the other side of the wire should be a
> > port. 
> > 
> > So if we agree that addressing this device as a PCIe device then it
> > feels like we would be better served to query device capabilities and
> > depending on what capabilities exist we would be able to configure
> > properties for those.  In an ideal world, I could query a device using
> > devlink ('devlink info'?) and it would show me different devices that
> > are available for configuration on the SmartNIC and would also give me a
> > way to address them.  So while I like the idea of being able to address
> > and set parameters as shown in patch 05 of this series, I would like to
> > see a bit more flexibility to define what type of device is available
> > and how it might be configured.
> 
> We shall see how this develops. For now sounds pretty high level.
> If the NIC needs to expose many "devices" that are independently
> controlled we should probably look at re-using the standard device
> model and not reinvent the wheel. 
> If we need to configure particular aspects and resource allocation, 
> we can add dedicated APIs as needed.
> 
> What I definitely want to avoid is adding a catch-all API with unclear
> semantics which will become the SmartNIC dumping ground.

Despite the fact that I proposed this, that is also my concern.  That
said I think there is a definite need to be able to understand the
hardware capabilities present on a PCI device.

> > So if we took the devlink info command as an example (whether its the
> > proper place for this or not), it could look _like_ this:
> > 
> > $ devlink dev info pci/0000:03:00.0
> > pci/0000:03:00.0:
> >   driver foo
> >   serial_number 8675309
> >   versions:
> > [...]
> >   capabilities:
> >       storage 0
> >       console 1
> >       mdev 1024
> >       [something else] [limit]
> > 
> > (Additionally rather than putting this as part of 'info' the device
> > capabilities and limits could be part of the 'resource' section and
> > frankly may make more sense if this is part of that.)
> > 
> > and then those capabilities would be something that could be set using the
> > 'vdev' or whatever-it-is-named interface:
> > 
> > # devlink vdev show pci/0000:03:00.0
> > pci/0000:03:00.0/console/0: speed 115200 device /dev/ttySNIC0
> 
> The speed in this console example makes no sense to me.
> 
> The patches as they stand are about the peer side/other side of the
> port. So which side of the serial device is the speed set on? One can
> just read the speed from /dev/ttySNIC0. And link that serial device to
> the appropriate parent via sysfs.

That's true and setting the speed is probably not that valuable, so we
do not need that option.  Proposal to set/read speed rescinded.  :)

>  This is pure wheel reinvention.
> 
> > pci/0000:03:00.0/mdev/0: hw_addr 02:00:00:00:00:00
> > [...]
> > pci/0000:03:00.0/mdev/1023: hw_addr 02:00:00:00:03:ff
> > 
> > # devlink vdev set pci/0000:03:00.0/mdev/0 hw_addr 00:22:33:44:55:00
> > 
> > Since these Arm/RISC-V based SmartNICs are going to be used in a variety
> > of different ways and will have a variety of different personalities
> > (not just different SKUs that vendors will offer but different ways in
> > which these will be deployed), I think it's critical that we consider
> > more than just the mdev/representer case from the start.
