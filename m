Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4212F981A
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 04:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbhARDR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 22:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729550AbhARDRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 22:17:22 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F72C061573;
        Sun, 17 Jan 2021 19:16:41 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id y19so30211419iov.2;
        Sun, 17 Jan 2021 19:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ejhEkrrlCdvSz/w2hBpJHroA3OZ0GfHtQsf8yJhbs8=;
        b=sQxYlzCebBfQuGxEbZl6K4lM0T7dFqH7fScOChD3HnRReek+4mD15OImi/pTLu/CMV
         3GB+mqd2VrSip2p2+Cf2HXVqK/TXXSwp7NdsvR38BpQlbTG0e9H7COdALCJmaocZBDhT
         ZBYJJra3F5HJdLZBj9Do0zHUfeqF24ddXenFyqWPHcTEDclDK49ucvpm5VjNXArrlphe
         LREUiWEQqvgOJWGzEp2OaOOqLG49D7uOi7qFAIjkRqO8dujfyuURaNenRauvR4ws5aiz
         khnELRK1YKyKdKgQJS2tQGPX7ju4BYbYN4cLiJKjkNcQxNdCEwYw1J+1EaXem8tOrpNa
         W6jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0ejhEkrrlCdvSz/w2hBpJHroA3OZ0GfHtQsf8yJhbs8=;
        b=Mjqu2XegT/MWzrLSWAsQt/ap2USN+/Nle65+c2lB16AyZoW2s36rQcCs10BoqcVG9P
         XkHsAtfd2O+KAxfW2Odo7QkiFGYyKz0e0AM8F465tyi2R4jf5NNr5N8Fr2UXR4fzt+ID
         pSg5bMS5dMg7wSGCDC7YF8vHgR/iVhdZ1kpOAvg5epA2X5xQWgmv5iP4XP+kLPUp6Gx2
         Hv1+csJYquLvDgoHsPGUSan7wZhbPyAl64CBq/z9MjZnaPf/rD6DZbKtJm9oePrubgGI
         Mz/xOefP1KzMeL8MmliTIrXirdu2k8VRBw3so9N2ikr+qxcX/TQ7i3lQ6L9sHYVUKupM
         S75Q==
X-Gm-Message-State: AOAM5313RsONG9cR7JO/0pswgohLSEDRFoqZWcZTFWK+/DQqmLm/hAd8
        5GwtQFRwDhnOr+hcLBGQp2ZkhFPjQajoUIevvN8=
X-Google-Smtp-Source: ABdhPJwCtfL23UMYf+C0R7TV2eGSlFpWTzoMl9Awnq5Q971i6GvBEsDDUMcKRNcYf+MLnxkgE/KqHcGKKa96Dc3N7dI=
X-Received: by 2002:a02:969a:: with SMTP id w26mr18666399jai.96.1610939801062;
 Sun, 17 Jan 2021 19:16:41 -0800 (PST)
MIME-Version: 1.0
References: <CAKgT0UcKqt=EgE+eitB8-u8LvxqHBDfF+u2ZSi5urP_Aj0Btvg@mail.gmail.com>
 <20210114182945.GO4147@nvidia.com> <CAKgT0UcQW+nJjTircZAYs1_GWNrRud=hSTsphfVpsc=xaF7aRQ@mail.gmail.com>
 <20210114200825.GR4147@nvidia.com> <CAKgT0UcaRgY4XnM0jgWRvwBLj+ufiabFzKPyrf3jkLrF1Z8zEg@mail.gmail.com>
 <20210114162812.268d684a@omen.home.shazbot.org> <CAKgT0Ufe1w4PpZb3NXuSxug+OMcjm1RP3ZqVrJmQqBDt3ByOZQ@mail.gmail.com>
 <20210115140619.GA4147@nvidia.com> <20210115155315.GJ944463@unreal>
 <CAKgT0UdzCqbLwxSnDTtgha+PwTMW5iVb-3VXbwdMNiaAYXyWzQ@mail.gmail.com> <20210116082031.GK944463@unreal>
In-Reply-To: <20210116082031.GK944463@unreal>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sun, 17 Jan 2021 19:16:30 -0800
Message-ID: <CAKgT0UeKiz=gh+djt83GRBGi8qQWTBzs-qxKj_78N+gx-KtkMQ@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 12:20 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Fri, Jan 15, 2021 at 05:48:59PM -0800, Alexander Duyck wrote:
> > On Fri, Jan 15, 2021 at 7:53 AM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Fri, Jan 15, 2021 at 10:06:19AM -0400, Jason Gunthorpe wrote:
> > > > On Thu, Jan 14, 2021 at 05:56:20PM -0800, Alexander Duyck wrote:
> > > >
> > > > > That said, it only works at the driver level. So if the firmware is
> > > > > the one that is having to do this it also occured to me that if this
> > > > > update happened on FLR that would probably be preferred.
> > > >
> > > > FLR is not free, I'd prefer not to require it just for some
> > > > philosophical reason.
> > > >
> > > > > Since the mlx5 already supports devlink I don't see any reason why the
> > > > > driver couldn't be extended to also support the devlink resource
> > > > > interface and apply it to interrupts.
> > > >
> > > > So you are OK with the PF changing the VF as long as it is devlink not
> > > > sysfs? Seems rather arbitary?
> > > >
> > > > Leon knows best, but if I recall devlink becomes wonky when the VF
> > > > driver doesn't provide a devlink instance. How does it do reload of a
> > > > VF then?
> > > >
> > > > I think you end up with essentially the same logic as presented here
> > > > with sysfs.
> > >
> > > The reasons why I decided to go with sysfs are:
> > > 1. This MSI-X table size change is applicable to ALL devices in the world,
> > > and not only netdev.
> >
> > In the PCI world MSI-X table size is a read only value. That is why I
> > am pushing back on this as a PCI interface.
>
> And it stays read-only.

Only if you come at it directly. What this is adding is a back door
that is visible as a part of the VF sysfs.

> >
> > > 2. This is purely PCI field and apply equally with same logic to all
> > > subsystems and not to netdev only.
> >
> > Again, calling this "purely PCI" is the sort of wording that has me
> > concerned. I would prefer it if we avoid that wording. There is much
> > more to this than just modifying the table size field. The firmware is
> > having to shift resources between devices and this potentially has an
> > effect on the entire part, not just one VF.
>
> It is internal to HW implementation, dumb device can solve it differently.

That is my point. I am worried about "dumb devices" that may follow. I
would like to see the steps that should be taken to prevent these sort
of things called out specifically. Basically this isn't just modifying
the PCIe config space, it is actually resizing the PBA and MSI-X
table.

> >
> > > 3. The sysfs interface is the standard way of configuring PCI/core, not
> > > devlink.
> >
> > This isn't PCI core that is being configured. It is the firmware for
> > the device. You are working with resources that are shared between
> > multiple functions.
>
> I'm ensuring that "lspci -vv .." will work correctly after such change.
> It is PCI core responsibility.

The current code doesn't work on anything with a driver loaded on it.
In addition the messaging provided is fairly minimal which results in
an interface that will be difficult to understand when it doesn't
work. In addition there is currently only one piece of hardware that
works with this interface which is the mlx5. My concern is this is
adding overhead to all VFs that will not be used by most SR-IOV
capable devices. In my view it would make much more sense to have a
top-down approach instead of bottom-up where the PF is registering
interfaces for the VFs.

If you want yet another compromise I would be much happier with the PF
registering the sysfs interfaces on the VFs rather than the VFs
registering the interface and hoping the PF supports it. At least with
that you are guaranteed the PF will respond to the interface when it
is registered.

> >
> > > 4. This is how orchestration software provisioning VFs already. It fits
> > > real world usage of SR-IOV, not the artificial one that is proposed during
> > > the discussion.
> >
> > What do you mean this is how they are doing it already? Do you have
> > something out-of-tree and that is why you are fighting to keep the
> > sysfs? If so that isn't a valid argument.
>
> I have Kubernetes and OpenStack, indeed they are not part of the kernel tree.
> They already use sriov_driver_autoprobe sysfs knob to disable autobind
> before even starting. They configure MACs and bind VFs through sysfs/netlink
> already. For them, the read/write of sysfs that is going to be bound to
> the already created VM with known CPU properties, fits perfectly.

By that argument the same could be said about netlink. What I don't
get is why it is okay to configure the MAC through netlink but
suddenly when we are talking about interrupts it is out of the
question. As far as the binding that is the driver interface which is
more or less grandfathered in anyway as there aren't too many ways to
deal with them as there isn't an alternate interface for the drivers
to define support.

> >
> > > So the idea to use devlink just because mlx5 supports it, sound really
> > > wrong to me. If it was other driver from another subsystem without
> > > devlink support, the request to use devlink won't never come.
> > >
> > > Thanks
> >
> > I am suggesting the devlink resources interface because it would be a
> > VERY good fit for something like this. By the definition of it:
> > ``devlink`` provides the ability for drivers to register resources, which
> > can allow administrators to see the device restrictions for a given
> > resource, as well as how much of the given resource is currently
> > in use. Additionally, these resources can optionally have configurable size.
> > This could enable the administrator to limit the number of resources that
> > are used.
>
> It is not resource, but HW objects. The devlink doesn't even see the VFs
> as long as they are not bound to the drivers.
>
> This is an example:
>
> [root@vm ~]# echo 0 > /sys/bus/pci/devices/0000\:01\:00.0/sriov_drivers_autoprobe
> [root@vm ~]# echo 0 > /sys/bus/pci/devices/0000\:01\:00.0/sriov_numvfs
> [ 2370.579711] mlx5_core 0000:01:00.0: E-Switch: Disable: mode(LEGACY), nvfs(2), active vports(3)
> [root@vm ~]# echo 2 > /sys/bus/pci/devices/0000\:01\:00.0/sriov_numvfs
> [ 2377.663666] mlx5_core 0000:01:00.0: E-Switch: Enable: mode(LEGACY), nvfs(2), active vports(3)
> [ 2377.777010] pci 0000:01:00.1: [15b3:101c] type 00 class 0x020000
> [ 2377.784903] pci 0000:01:00.2: [15b3:101c] type 00 class 0x020000
> [root@vm ~]# devlink dev
> pci/0000:01:00.0
> [root@vm ~]# lspci |grep nox
> 01:00.0 Ethernet controller: Mellanox Technologies MT28908 Family [ConnectX-6]
> 01:00.1 Ethernet controller: Mellanox Technologies MT28908 Family [ConnectX-6 Virtual Function]
> 01:00.2 Ethernet controller: Mellanox Technologies MT28908 Family [ConnectX-6 Virtual Function]
>
> So despite us having 2 VFs ready to be given to VMs, administrator doesn't
> see them as devices.

The MSI-X vectors are a resource assigned to hardware objects. It just
depends on how you want to look at things. Right now you have the VFs
register an interface on behalf of the PF. I am arguing it would be
better to have the PF register an interface on behalf of the VFs.
Ultimately the PF is responsible for creating the VFs in the first
place. I don't see it as that much of a leap to have the
mlx5_sriov_enable call register interfaces for the VFs so that you can
configure the MSI-X vectors from the PF, and then tear them down
before it frees the VFs. Having the VFs do the work seems error prone
since it is assuming the interfaces are there on the PF when in all
cases but one (mlx5) it currently isn't.

> >
> > Even looking over the example usage I don't see there being much to
> > prevent you from applying it to this issue. In addition it has the
> > idea of handling changes that cannot be immediately applied already
> > included. Your current solution doesn't have a good way of handling
> > that and instead just aborts with an error.
>
> Yes, because it is HW resource that should be applied immediately to
> make sure that it is honored, before it is committed to the users.

The problem is you cannot do that at all if the driver is already
loaded. One advantage of using something like devlink is that you
could potentially have the VF driver help to coordinate things so you
could have the case where the VF has the mlx5 driver loaded work
correctly where you would update the MSI-X vector count and then
trigger the driver reload via devlink.

> It is very tempting to use devlink everywhere, but it is really wrong
> tool for this scenario.

We can agree to disagree there. I am not a fan of sysfs being applied
everywhere either. The problem is it is an easy goto when someone is
looking for a quick and dirty solution and often leads to more
problems later as it usually misses critical path locking issues and
the like.

Especially when it is making a subordinate interface look like the
MSI-X table size is somehow writable. I would much rather the creation
of any interface controlled more directly by the PF, or at a minimum
have the PF registering the interfaces rather than leaving this up to
the VF in the hopes that the PF provides the functionality needed to
service the request.
