Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A462DC453
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgLPQch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgLPQch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 11:32:37 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB86C061794;
        Wed, 16 Dec 2020 08:31:56 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id r9so24530109ioo.7;
        Wed, 16 Dec 2020 08:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZQp5ijXK6KyYcBGlAOyLi4/Gh/VnhNPH4dDbbxSDTDo=;
        b=SBq+9NaFUaP5iugVwaXPwFSTB6sEJpoCvWoVRYJ3eK1vZCJVVBFNFPuy9ZYyMbSKQ3
         IxLUDq1z4y2ZV9YDyik4YjbbdQ+Bhj58wPQwp0J4AS+ig1ljjnW0pcky9ZmIGf1PPb7v
         Ql0gg6kBmhshnKicdAg6hfjzL8GDr0yciF38qYJNhCTzOKlajefpalqWZpUr7MkbAmqF
         rf8hDPgduM82fNXANDDCVwxNXi4Dql/aLjAAse7tQjve7tNrHE3p4SchRGdh0Y/n6+Bm
         i9Rcoqc9har+5z26Yq6uqFogZsDG5eSR08ZIRhhCREc7+nROggaBiTxEZO8Q1hc3FZv3
         l25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZQp5ijXK6KyYcBGlAOyLi4/Gh/VnhNPH4dDbbxSDTDo=;
        b=Wf4apZf/DuLdUr3zO88mgUeLuKYUwJKGoO5QPXKUImOFM5DeAF3kkYNowT3cooArsr
         4dYbCcWbiGmYDEVdp76H49rmdPxURLAU4TcB7jVWGjO9m+3Bcz9j9SCsHGWr3ROzfewX
         TcIn954ZQ+q24HnzrEZpVA5stylgK1sZE1uhsfpby5mkXx98KvyfTiF2xiviXmxAF1/6
         vGz0O+gY+R7midfSonvFLHO7NAycRBhdJ3QV/cS/Wk9dTDziYP0JITTjpMhAkNE6JEv0
         +Z4hvi2Yau7yAiakDM3uxZBdwLpo47oydeWXaZaf/y/LNjrv5Sjb/bsREu+/VBQloaKw
         Td2g==
X-Gm-Message-State: AOAM532M7NwJTBY8rJ62yaBxwBY4miMu/yJm+T0YmUzjiOeTUnH+VPy0
        60bctuI2Xrx9dvW6a9SvtjvWcqAFizObNjfdK24=
X-Google-Smtp-Source: ABdhPJwAYqYW4YHhzF2Ec+IZHqNwF+ao6AMYUqQEVeGY8STKewvUfQrALFJCitWUYUr7AKbvdcoyPyyZvjtcEAqdMj4=
X-Received: by 2002:a02:4:: with SMTP id 4mr44086679jaa.121.1608136316013;
 Wed, 16 Dec 2020 08:31:56 -0800 (PST)
MIME-Version: 1.0
References: <20201214214352.198172-1-saeed@kernel.org> <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
 <608505778d76b1b01cb3e8d19ecda5b8578f0f79.camel@kernel.org>
 <CAKgT0UfEsd0hS=iJTcVc20gohG0WQwjsGYOw1y0_=DRVbhb1Ng@mail.gmail.com>
 <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com> <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com> <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com>
In-Reply-To: <20201216133309.GI552508@nvidia.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 16 Dec 2020 08:31:44 -0800
Message-ID: <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 5:33 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Tue, Dec 15, 2020 at 08:13:21PM -0800, Alexander Duyck wrote:
>
> > > > Ugh, don't get me started on switchdev. The biggest issue as I see it
> > > > with switchev is that you have to have a true switch in order to
> > > > really be able to use it.
> > >
> > > That cuts both ways, suggesting HW with a true switch model itself
> > > with VMDq is equally problematic.
> >
> > Yes and no. For example the macvlan offload I had setup could be
> > configured both ways and it made use of VMDq. I'm not necessarily
> > arguing that we need to do VMDq here, however at the same time saying
> > that this is only meant to replace SR-IOV becomes problematic since we
> > already have SR-IOV so why replace it with something that has many of
> > the same limitations?
>
> Why? Because SR-IOV is the *only* option for many use cases. Still. I
> said this already, something more generic does not magicaly eliminate
> SR-IOV.
>
> The SIOV ADI model is a small refinement to the existing VF scheme, it
> is completely parallel to making more generic things.
>
> It is not "repeating mistakes" it is accepting the limitations of
> SR-IOV because benefits exist and applications need those benefits.

If we have two interfaces, both with pretty much the same limitations
then many would view it as "repeating mistakes". The fact is we
already have SR-IOV. Why introduce yet another interface that has the
same functionality?

You say this will scale better but I am not even sure about that. The
fact is SR-IOV could scale to 256 VFs, but for networking I kind of
doubt the limitation would have been the bus number and would more
likely be issues with packet replication and PCIe throughput,
especially when you start dealing with east-west traffic within the
same system.

> > That said I understand your argument, however I view the elimination
> > of SR-IOV to be something we do after we get this interface right and
> > can justify doing so.
>
> Elimination of SR-IOV isn't even a goal here!

Sorry you used the word "replace", and my assumption here was that the
goal is to get something in place that can take the place of SR-IOV so
that you wouldn't be maintaining the two systems at the same time.
That is my concern as I don't want us having SR-IOV, and then several
flavors of SIOV. We need to decide on one thing that will be the way
forward.

> > Also it might be useful to call out the flavours and planned flavours
> > in the cover page. Admittedly the description is somewhat lacking in
> > that regard.
>
> This is more of a general switchdev remark though. In the swithdev
> model you have a the switch and a switch port. Each port has a
> swichdev representor on the switch side and a "user port" of some
> kind.
>
> It can be a physical thing:
>  - SFP
>  - QSFP
>  - WiFi Antennae
>
> It could be a semi-physical thing outside the view of the kernel:
>  - SmartNIC VF/SF attached to another CPU
>
> It can be a semi-physical thing in view of this kernel:
>  - SRIOV VF (struct pci device)
>  - SF (struct aux device)
>
> It could be a SW construct in this kernel:
>  - netdev (struct net device)
>
> *all* of these different port types are needed. Probably more down the
> road!
>
> Notice I don't have VPDA, VF/SF netdev, or virtio-mdev as a "user
> port" type here. Instead creating the user port pci or aux device
> allows the user to use the Linux driver model to control what happens
> to the pci/aux device next.

I get that. That is why I said switchdev isn't a standard for the
endpoint. One of the biggest issues with SR-IOV that I have seen is
the fact that the last piece isn't really defined. We never did a good
job of defining how the ADI should look to the guest and as a result
it kind of stalled in adoption.

> > I would argue that is one of the reasons why this keeps being
> > compared to either VMDq or VMQ as it is something that SR-IOV has
> > yet to fully replace and has many features that would be useful in
> > an interface that is a subpartition of an existing interface.
>
> In what sense does switchdev and a VF not fully replace macvlan VMDq?

One of the biggest is east-west traffic. You quickly run up against
the PCIe bandwidth bottleneck and then the performance tanks. I have
seen a number of cases where peer-to-peer on the same host swamps the
network interface.

> > The Intel drivers still have the macvlan as the assignable ADI and
> > make use of VMDq to enable it.
>
> Is this in-tree or only in the proprietary driver? AFAIK there is no
> in-tree way to extract the DMA queue from the macvlan netdev into
> userspace..
>
> Remeber all this VF/SF/VDPA stuff results in a HW dataplane, not a SW
> one. It doesn't really make sense to compare a SW dataplane to a HW
> one. HW dataplanes come with limitations and require special driver
> code.

I get that. At the same time we can mask some of those limitations by
allowing for the backend to be somewhat abstract so you have the
possibility of augmenting the hardware dataplane with a software one
if needed.

> > The limitation as I see it is that the macvlan interface doesn't allow
> > for much in the way of custom offloads and the Intel hardware doesn't
> > support switchdev. As such it is good for a basic interface, but
> > doesn't really do well in terms of supporting advanced vendor-specific
> > features.
>
> I don't know what it is that prevents Intel from modeling their
> selector HW in switchdev, but I think it is on them to work with the
> switchdev folks to figure something out.

They tried for the ixgbe and i40e. The problem is the hardware
couldn't conform to what was asked for if I recall. It has been a few
years since I worked in the Ethernet group at intel so I don't recall
the exact details.

> I'm a bit surprised HW that can do macvlan can't be modeled with
> switchdev? What is missing?

If I recall it was the fact that the hardware defaults to transmitting
everything that doesn't match an existing rule to the external port
unless it comes from the external port.

> > > That is goal here. This is not about creating just a netdev, this is
> > > about the whole kit: rdma, netdev, vdpa virtio-net, virtio-mdev.
> >
> > One issue is right now we are only seeing the rdma and netdev. It is
> > kind of backwards as it is using the ADIs on the host when this was
> > really meant to be used for things like mdev.
>
> This is second 15 patch series on this path already. It is not
> possible to pack every single thing into this series. This is the
> micro step of introducing the SF idea and using SF==VF to show how the
> driver stack works. The minimal changing to the existing drivers
> implies this can support an ADI as well.
>
> Further, this does already show an ADI! vdpa_mlx5 will run on the
> VF/SF and eventually causes qemu to build a virtio-net ADI that
> directly passes HW DMA rings into the guest.
>
> Isn't this exactly the kind of generic SRIOV replacement option you
> have been asking for? Doesn't this completely supersede stuff built on
> macvlan?

Something like the vdpa model is more like what I had in mind. Only
vdpa only works for the userspace networking case.

Basically the idea is to have an assignable device interface that
isn't directly tied to the hardware. Instead it is making use of a
slice of it and referencing the PF as the parent leaving the PF as the
owner of the slice. If at some point in the future we could make
changes to allow for software to step in and do some switching if
needed. The key bit is the abstraction of the assignable interface so
that it is vendor agnostic and could be switched over to pure software
backing if needed.

> > expected to work. The swtichdev API puts some restrictions in place
> > but there still ends up being parts without any definition.
>
> I'm curious what you see as needing definition here?
>
> The SRIOV model has the HW register programming API is device
> specific.
>
> The switchdev model is: no matter what HW register programing is done
> on the VF/SF all the packets tx/rx'd will flow through the switchdev.
>
> The purpose of switchdev/SRIOV/SIOV has never been to define a single
> "one register set to rule them all".
>
> That is the area that VDPA virtio-net and others are covering.

That is fine and that covers it for direct assigned devices. However
that doesn't cover the container case. My thought is if we are going
to partition a PF into multiple netdevices we should have some generic
interface that can be provided to represent the netdevs so that if
they are pushed into containers you don't have to rip them out if for
some reason you need to change the network configuration. For the
Intel NICs we did that with macvlan in the VMDq case. I see no reason
why you couldn't do something like that here with the subfunction
case.
