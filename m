Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC81C2DB9F4
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 05:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgLPEOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 23:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgLPEOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 23:14:14 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09214C0613D6;
        Tue, 15 Dec 2020 20:13:34 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id p5so21348352iln.8;
        Tue, 15 Dec 2020 20:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ykBorVfusx0cuuPAmlYNHEakddLnEOiwDswKZ+CpIk=;
        b=j1bx6dYm0/Cm7QxHBn//s1fPcylVYxw9MdaPFIQpcsZkbj0L6NifePX8PlIFwpWfGb
         JAjneM/zvkcPzkhQdTRSADSmJq8RXyOaeuTcXlWDA7+gqMi6zz7eLgB2cTzgF/16frkM
         O9x20THcMrWa14ZCvbKSJLEbs38fz/5w/LtRGnJ81CqMhuxRQEfwqx2HpP0lHKroIFhH
         uP+tUIvGuL0qHcEo9tXlXFu5GVwmWWJM/FU2IPxlR0fBKPjtB5kuYIMIeNVoVxenjUFS
         9hsj2NkMoA/aFuumvEmNCLDMpmpMGwPeDR5zrWr4KpibnurHKQMlb+EDdfUua+vfjIFK
         Q3Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ykBorVfusx0cuuPAmlYNHEakddLnEOiwDswKZ+CpIk=;
        b=LUE+jTX8tNfHvV4aUKRfumv3Crc4xlCaslpYVccBy0kiiAlVqKQAelLpb2RXayoC+t
         nqV0NtlFq0rGjJa74Pbz3W1RFCRfZQ8NPZi+nCAJAaZS5+btT0ihk9cBN3ns98QeOa4P
         /4coGkgZow1+sIe2y9NwR5pCPPeZjjwDxB8xiSwZy+pLz40UxY/eQPqp8yFBCcXpgq4F
         ACXf5glXn0IG54+FTHpEiUD1twhXvsxesFjAcfSbZYg6nmiHM308YUQBvBCZPxc7T+Ok
         vwVznpOjTD2rEHhwh0wouYTiKsbEq+xNoWhHJ5ZdKUhPOtjt6m9TqOGFkeUECn+cd4NZ
         SMSg==
X-Gm-Message-State: AOAM5302h9EbyFA8CyWT0lASOWZv6g5hnt/nCYqB6hApcEm/BHUHtQiV
        rPAnFE8ZqpUsTC6O9pJH70/jB4Nb2ss0uEpqoY4=
X-Google-Smtp-Source: ABdhPJxwPo9OZiHOugyF4Uj2sATDncprxMwNDyjeOD7xseRulFdGTRLkpol2Lybta2+FPDFOS+bvNACnJdCv+r2KsiA=
X-Received: by 2002:a92:d8cc:: with SMTP id l12mr43251047ilo.64.1608092013230;
 Tue, 15 Dec 2020 20:13:33 -0800 (PST)
MIME-Version: 1.0
References: <20201214214352.198172-1-saeed@kernel.org> <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
 <608505778d76b1b01cb3e8d19ecda5b8578f0f79.camel@kernel.org>
 <CAKgT0UfEsd0hS=iJTcVc20gohG0WQwjsGYOw1y0_=DRVbhb1Ng@mail.gmail.com>
 <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com> <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com>
In-Reply-To: <20201216030351.GH552508@nvidia.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 15 Dec 2020 20:13:21 -0800
Message-ID: <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
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

On Tue, Dec 15, 2020 at 7:04 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Tue, Dec 15, 2020 at 06:19:18PM -0800, Alexander Duyck wrote:
>
> > > > I would really like to see is a solid standardization of what this is.
> > > > Otherwise the comparison is going to be made. Especially since a year
> > > > ago Mellanox was pushing this as an mdev type interface.
> > >
> > > mdev was NAK'd too.
> > >
> > > mdev is only for creating /dev/vfio/*.
> >
> > Agreed. However my worry is that as we start looking to make this
> > support virtualization it will still end up swinging more toward
> > mdev.
>
> Of course. mdev is also the only way to create a /dev/vfio/* :)
>
> So all paths that want to use vfio must end up creating a mdev.
>
> Here we would choose to create the mdev on top of the SF aux device.
> There isn't really anything mlx5 specific about that decision.
>
> The SF models the vendor specific ADI in the driver model.
>
> > It isn't so much about right or wrong but he use cases. My experience
> > has been that SR-IOV ends up being used for very niche use cases where
> > you are direct assigning it into either DPDK or some NFV VM and you
> > are essentially building the application around the NIC. It is all
> > well and good, but for general virtualization it never really caught
> > on.
>
> Sure
>
> > > So encourage other vendors to support the switchdev model for managing
> > > VFs and ADIs!
> >
> > Ugh, don't get me started on switchdev. The biggest issue as I see it
> > with switchev is that you have to have a true switch in order to
> > really be able to use it.
>
> That cuts both ways, suggesting HW with a true switch model itself
> with VMDq is equally problematic.

Yes and no. For example the macvlan offload I had setup could be
configured both ways and it made use of VMDq. I'm not necessarily
arguing that we need to do VMDq here, however at the same time saying
that this is only meant to replace SR-IOV becomes problematic since we
already have SR-IOV so why replace it with something that has many of
the same limitations?

> > As such dumbed down hardware like the ixgbe for instance cannot use
> > it since it defaults to outputting anything that doesn't have an
> > existing rule to the external port. If we could tweak the design to
> > allow for more dumbed down hardware it would probably be much easier
> > to get wider adoption.
>
> I'd agree with this
>
> > interface, but keep the SF interface simple. Then you can back it with
> > whatever you want, but without having to have a vendor specific
> > version of the interface being plugged into the guest or container.
>
> The entire point *is* to create the vendor version because that serves
> the niche cases where SRIOV assignment is already being used.
>
> Having a general solution that can't do vendor SRIOV is useful for
> other application, but doesn't eliminate the need for the SRIOV case.

So part of the problem here is we already have SR-IOV. So we don't
need to repeat the mistakes. Rather, we need to have a solution to the
existing problems and then we can look at eliminating it.

That said I understand your argument, however I view the elimination
of SR-IOV to be something we do after we get this interface right and
can justify doing so. I don't have a problem necessarily with vendor
specific instances, unless we are only able to get vendor specific
instances. Thus I would prefer that we have a solution in place before
we allow the switch over.

> > One of the reasons why virtio-net is being pushed as a common
> > interface for vendors is for this reason. It is an interface that can
> > be emulated by software or hardware and it allows the guest to run on
> > any arbitrary hardware.
>
> Yes, and there is mlx5_vdpa to support this usecase, and it binds to
> the SF. Of course all of that is vendor specific too, the driver to
> convert HW specifc register programming into a virio-net ADI has to
> live *somewhere*

Right, but this is more the model I am in favor of. The backend is
hidden from the guest and lives somewhere on the host.

Also it might be useful to call out the flavours and planned flavours
in the cover page. Admittedly the description is somewhat lacking in
that regard.

> > It has plenty to do with this series. This topic has been under
> > discussion since something like 2017 when Mellanox first brought it up
> > at Netdev 2.1. At the time I told them they should implement this as a
> > veth offload.
>
> veth doesn't give an ADI, it is useless for these niche cases.
>
> veth offload might be interesting for some container case, but feels
> like writing an enormous amount of code to accomplish nothing new...

My concern is if we are going to start partitioning up a PF on the
host we might as well make the best use of it. I would argue that it
would make more sense to have some standardized mechanism in place for
the PF to communicate and interact with the SFs. I would argue that is
one of the reasons why this keeps being compared to either VMDq or VMQ
as it is something that SR-IOV has yet to fully replace and has many
features that would be useful in an interface that is a subpartition
of an existing interface.

> > Then it becomes obvious what the fallback becomes as you can place
> > packets into one end of a veth and it comes out the other, just like
> > a switchdev representor and the SF in this case. It would make much
> > more sense to do it this way rather than setting up yet another
> > vendor proprietary interface pair.
>
> I agree it makes sense to have an all SW veth-like option, but I
> wouldn't try to make that as the entry point for all the HW
> acceleration or to serve the niche SRIOV use cases, or to represent an
> ADI.
>
> It just can't do that and it would make a huge mess if you tried to
> force it. Didn't Intel already try this once with trying to use the
> macvlan netdev and its queue offload to build an ADI?

The Intel drivers still have the macvlan as the assignable ADI and
make use of VMDq to enable it. Actually I would consider it an example
of the kind of thing I am talking about. It is capable of doing
software switching between interfaces, broadcast/multicast replication
in software, and makes use of the hardware interfaces to allow for
receiving directly from the driver into the macvlan interface.

The limitation as I see it is that the macvlan interface doesn't allow
for much in the way of custom offloads and the Intel hardware doesn't
support switchdev. As such it is good for a basic interface, but
doesn't really do well in terms of supporting advanced vendor-specific
features.

> > > Anyhow, if such a thing exists someday it could make sense to
> > > automatically substitute the HW version using a SF, if available.
> >
> > The main problem as I see it is the fact that the SF interface is
> > bound too tightly to the hardware.
>
> That is goal here. This is not about creating just a netdev, this is
> about the whole kit: rdma, netdev, vdpa virtio-net, virtio-mdev.

One issue is right now we are only seeing the rdma and netdev. It is
kind of backwards as it is using the ADIs on the host when this was
really meant to be used for things like mdev.

> The SF has to support all of that completely. Focusing only on the
> one use case of netdevs in containers misses the bigger picture.
>
> Yes, lots of this stuff is niche, but niche stuff needs to be
> supported too.

I have no problem with niche stuff, however we need to address the
basics before we move on to the niche stuff.

> > Yes, it is a standard feature set for the control plane. However for
> > the data-path it is somewhat limited as I feel it only describes what
> > goes through the switch.
>
> Sure, I think that is its main point.
>
> > Not the interfaces that are exposed as the endpoints.
>
> It came from modeling physical HW so the endports are 'physical'
> things like actual HW switch ports, or SRIOV VFs, ADI, etc.

The problem is the "physical things" such as the SRIOV VFs and ADI
aren't really defined in the specification and are left up to the
implementers interpretation. These specs have always been fuzzy since
they are essentially PCI specifications and don't explain anything
about how the network on such a device should be configured or
expected to work. The swtichdev API puts some restrictions in place
but there still ends up being parts without any definition.

> > It is the problem of that last bit and how it is handled that can
> > make things ugly. For example the multicast/broadcast replication
> > problem that just occurred to me while writing this up.  The fact is
> > for east-west traffic there has always been a problem with the
> > switchdev model as it limits everything to PCIe/DMA so there are
> > cases where software switches can outperform the hardware ones.
>
> Yes, but, mixing CPU and DMA in the same packet delivery scheme is
> very complicated :)

I'm not necessarily saying we need to mix the two. However there are
cases such as multicast/broadcast where it would make much more sense
to avoid the duplication of packets and instead simply send one copy
and have it replicated by the software.

What would probably make sense for now would be to look at splitting
the netdev into two pieces. The frontend which would provide the
netdev and be a common driver for subfunction netdevs in this case,
and a backend which would be a common point for all the subfunctions
that are being used directly on the host. This is essentially what we
have with the macvlan model. The idea is that if we wanted to do
software switching or duplication of traffic we could, but if not then
we wouldn't.
