Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E072DB8E1
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 03:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgLPCUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 21:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgLPCUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 21:20:10 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67004C0613D6;
        Tue, 15 Dec 2020 18:19:30 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id k8so21185338ilr.4;
        Tue, 15 Dec 2020 18:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vkgPnFEDRwEUBUDsWJgn2tHnrJWa9YZuKo6wizINjmY=;
        b=YFPRvnoD3DvkwMYvldDQ+r9oOw7DVqwoukq/XJM1ZH4hLMsCzWRtq7pgfemD8by6nE
         +IQoNcBBOXLquLQT5ghSU6cTGc1Ah6ZrJsoAU5o/dOakSigEe/sXt2G7izJ9jbK59TPv
         CUdE2lUsWFpei8/Zdd8o6cNOYcno14ax5C/CVNdzyji1/JvvyDrBeRE8qoNEnmhGW+fA
         BbKbTAVx0o8Tu6VqBZydMlAmKkw8mH0v/mPwtjMEAYRDpkRf0xYP3dP8QDqO3fWFqmU4
         QrZywFj8FxxcPIiYK5GeO/ZfEnzXmXZrtzvC1zTdRQFUv7vrDCzfcp0LEGMo6/bngBqs
         BHIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vkgPnFEDRwEUBUDsWJgn2tHnrJWa9YZuKo6wizINjmY=;
        b=TmPkT3SLS7GDP9TEvyza9ChS90u345PJ+RXfVp9IQY80eUpJ6Hby/bXF0FRK6ieQGE
         NWWZu4Xn0iU3qqPb0V0It+I6T3PRMtXtkv4rc8ePtoRoirrcJkG4z/hmmcTZS7v1+CVH
         QWhGSu680XdQ/BFb0PUbGlpXs78zAlNvWYRtMwPXDsLTIms6SxWXfL2ldz9J1CuA25cT
         Kx4Wu4x4flHFdRdOmfQmUaTxJZJpC8nD8PDm9EQu5FGMF626gAbkN+AqxoQB+gGRkc4Y
         3UFrcHUEewouvPmbgmNWfbnWXCxKrTb2jejy5/nks6r1p+3hwr2osRfzGfVdodOr4Ung
         kPIg==
X-Gm-Message-State: AOAM531blY05SSDhEe2O9f5R531M3h317AY2LVfyLWnBk4gHLggOw9un
        1qVdLEWDI8KoHQ8YmdUiarzAd3Tr1WyPsSd8/aM=
X-Google-Smtp-Source: ABdhPJwGw8vljZHYOvcGhuaObSLPTCJZ5Gmq0zcpfEVnc/4+oEJfJQa6OFV/+BaJCQhUsmjT+zunL19AskzqTU82DRs=
X-Received: by 2002:a05:6e02:929:: with SMTP id o9mr42616204ilt.42.1608085169591;
 Tue, 15 Dec 2020 18:19:29 -0800 (PST)
MIME-Version: 1.0
References: <20201214214352.198172-1-saeed@kernel.org> <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
 <608505778d76b1b01cb3e8d19ecda5b8578f0f79.camel@kernel.org>
 <CAKgT0UfEsd0hS=iJTcVc20gohG0WQwjsGYOw1y0_=DRVbhb1Ng@mail.gmail.com>
 <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com> <20201216001946.GF552508@nvidia.com>
In-Reply-To: <20201216001946.GF552508@nvidia.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 15 Dec 2020 18:19:18 -0800
Message-ID: <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
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

On Tue, Dec 15, 2020 at 4:20 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Tue, Dec 15, 2020 at 01:41:04PM -0800, Alexander Duyck wrote:
>
> > > not just devlink and switchdev, auxbus was also introduced to
> > > standardize some of the interfaces.
> >
> > The auxbus is just there to make up for the fact that there isn't
> > another bus type for this though. I would imagine otherwise this would
> > be on some sort of platform bus.
>
> Please lets not start this again. This was gone over with Greg for
> literally a year and a half and he explicitly NAK'd platform bus for
> this purpose.
>
> Aux bus exists to connect different kernel subsystems that touch the
> same HW block together. Here we have the mlx5_core subsystem, vdpa,
> rdma, and netdev all being linked together using auxbus.
>
> It is kind of like what MFD does, but again, using MFD for this was
> also NAK'd by Greg.

Sorry I wasn't saying we needed to use MFD or platform bus. I'm aware
of the discussions I was just saying there are some parallels, not
that we needed to go through and use that.

> At the very worst we might sometime find out there is some common
> stuff between ADIs that we might get an ADI bus, but I'm not
> optimistic. So far it looks like there is no commonality.
>
> Aux bus has at least 4 users already in various stages of submission,
> and many other target areas that should be replaced by it.

Aux bus is fine and I am happy with it. I was just saying that auxbus
isn't something that should really be used to say that this is
significantly different from mdev as they both rely on a bus topology.

> > I would really like to see is a solid standardization of what this is.
> > Otherwise the comparison is going to be made. Especially since a year
> > ago Mellanox was pushing this as an mdev type interface.
>
> mdev was NAK'd too.
>
> mdev is only for creating /dev/vfio/*.

Agreed. However my worry is that as we start looking to make this
support virtualization it will still end up swinging more toward mdev.
I would much prefer to make certain that any mdev is a flavor and
doesn't end up coloring the entire interface.

> > That is all well and good. However if we agree that SR-IOV wasn't done
> > right saying that you are spinning up something that works just like
> > SR-IOV isn't all that appealing, is it?
>
> Fitting into some universal least-common-denominator was never a goal
> for SR-IOV, so I wouldn't agree it was done wrong.

It isn't so much about right or wrong but he use cases. My experience
has been that SR-IOV ends up being used for very niche use cases where
you are direct assigning it into either DPDK or some NFV VM and you
are essentially building the application around the NIC. It is all
well and good, but for general virtualization it never really caught
on.

My thought is that if we are going to do this we need to do this in a
way that improves the usability, otherwise we are looking at more
niche use cases.

> > I am talking about my perspective. From what I have seen, one-off
> > features that are only available from specific vendors are a pain to
> > deal with and difficult to enable when you have to support multiple
> > vendors within your ecosystem. What you end up going for is usually
> > the lowest common denominator because you ideally want to be able to
> > configure all your devices the same and have one recipe for setup.
>
> So encourage other vendors to support the switchdev model for managing
> VFs and ADIs!

Ugh, don't get me started on switchdev. The biggest issue as I see it
with switchev is that you have to have a true switch in order to
really be able to use it. As such dumbed down hardware like the ixgbe
for instance cannot use it since it defaults to outputting anything
that doesn't have an existing rule to the external port. If we could
tweak the design to allow for more dumbed down hardware it would
probably be much easier to get wider adoption.

Honestly, the switchdev interface isn't what I was talking about. I
was talking about the SF interface, not the switchdev side of it. In
my mind you can place your complexity into the switchdev side of the
interface, but keep the SF interface simple. Then you can back it with
whatever you want, but without having to have a vendor specific
version of the interface being plugged into the guest or container.

One of the reasons why virtio-net is being pushed as a common
interface for vendors is for this reason. It is an interface that can
be emulated by software or hardware and it allows the guest to run on
any arbitrary hardware.

> > I'm not saying you cannot enable those features. However at the same
> > time I am saying it would be nice to have a vendor neutral way of
> > dealing with those if we are going to support SF, ideally with some
> > sort of software fallback that may not perform as well but will at
> > least get us the same functionality.
>
> Is it really true there is no way to create a software device on a
> switchdev today? I looked for a while and couldn't find
> anything. openvswitch can do this, so it does seem like a gap, but
> this has nothing to do with this series.

It has plenty to do with this series. This topic has been under
discussion since something like 2017 when Mellanox first brought it up
at Netdev 2.1. At the time I told them they should implement this as a
veth offload. Then it becomes obvious what the fallback becomes as you
can place packets into one end of a veth and it comes out the other,
just like a switchdev representor and the SF in this case. It would
make much more sense to do it this way rather than setting up yet
another vendor proprietary interface pair.

> A software switchdev path should still end up with the representor and
> user facing netdev, and the behavior of the two netdevs should be
> identical to the VF switchdev flow we already have today.
>
> SF doesn't change any of this, it just shines a light that, yes,
> people actually have been using VFs with netdevs in containers and
> switchdev, as part of their operations.
>
> FWIW, I view this as a positive because it shows the switchdev model
> is working very well and seeing adoption beyond the original idea of
> controlling VMs with SRIOV.

PF/VF isolation is a given. So the existing switchdev behavior is fine
in that regard. I wouldn't expect that to change. The fact is we
actually support something similar in the macvlan approach we put in
the Intel drivers since the macvlan itself provided an option for
isolation or to hairpin the traffic if you wanted to allow the VMDq
instances to be bypassed. That was another thing I view as a huge
feature as broadcast/multicast traffic can really get ugly when the
devices are all separate pipelines and being able to switch that off
and just do software replication and hairpinning can be extremely
useful.

> > I'm trying to remember which netdev conference it was. I referred to
> > this as a veth switchdev offload when something like this was first
> > brought up.
>
> Sure, though I think the way you'd create such a thing might be
> different. These APIs are really about creating an ADI that might be
> assigned to a VM and never have a netdev.
>
> It would be nonsense to create a veth-switchdev thing with out a
> netdev, and there have been various past attempts already NAK'd to
> transform a netdev into an ADI.
>
> Anyhow, if such a thing exists someday it could make sense to
> automatically substitute the HW version using a SF, if available.

The main problem as I see it is the fact that the SF interface is
bound too tightly to the hardware. The direct pass-thru with no
hairpin is always an option but if we are going to have an interface
where both ends are in the same system there are many cases where
always pushing all the packets off to the hardware don't necessarily
make sense.

> > could address those needs would be a good way to go for this as it
> > would force everyone to come together and define a standardized
> > feature set that all of the vendors would want to expose.
>
> I would say switchdev is already the standard feature set.

Yes, it is a standard feature set for the control plane. However for
the data-path it is somewhat limited as I feel it only describes what
goes through the switch. Not the interfaces that are exposed as the
endpoints. It is the problem of that last bit and how it is handled
that can make things ugly. For example the multicast/broadcast
replication problem that just occurred to me while writing this up.
The fact is for east-west traffic there has always been a problem with
the switchdev model as it limits everything to PCIe/DMA so there are
cases where software switches can outperform the hardware ones.
