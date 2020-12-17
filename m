Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90EE12DD8AC
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgLQStl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbgLQStl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 13:49:41 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E7CC061794;
        Thu, 17 Dec 2020 10:49:00 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id t9so26761276ilf.2;
        Thu, 17 Dec 2020 10:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YtpPyk1+Ge3NrlWYSV22bI8aTPFUBxydBhltGP4WJBg=;
        b=pNqnoUQYV7IRs+UQHVII3tXCRH8heJ2X5lFiMz2ZmnTl98K2e2nqIy6OFDuOOcgWkX
         yLjxmFNnFxddfA+gENLqzBi2OhiK9S80Z+fFNM4i30aFN2DclL9hXJNQZi066NqazDbG
         Z1d2t/gx/oXlWEVYNOLewNbKiLcZNg0t/Ikqp7OliYCa600S7r0ZFPkDsieWXb3UWVgG
         r+ttYYQVt4HB9bcNiWxjSDuJYMStI2/mjX8jDNoPmANjprwf/1EIR7DVZnp4NloRFL34
         SZyvMRga1VcXIcmuaRzB53BzUE4ZItxF5jxqav/wNt+wnf9xWnzydnvfIaFeuj+/qyPn
         kp/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YtpPyk1+Ge3NrlWYSV22bI8aTPFUBxydBhltGP4WJBg=;
        b=Rgv+fj3cw+sKTzYtUkJ1egBvTSVc6Hj3gxdrwHdNhmrxZSVkq9qc88YVi2Ul9kymut
         4LFcVyVTH5Gew56nm4yG99CMeT2wf1xzLFz2p/hGWoHCLf3iUYdpiITYh/KA6+VcB/59
         lssVB9szTBdyOoLny5UFH6KCRrioBtTHFgs7QFWgMHLnkFof7Imhwv8LbgLuxXX45dlx
         ZcE3nhcsvLZ4qjR7fm8bQj9lcgWsn3DiCNgtZ4ny6gcldUNpaN41cowXWOI8XiebLHkw
         +pVTWisE+vQBrC/Xo4nwQoZ57TXsjaNozYxWN2UaYjyPqPJ3/uDCnKfQ3YJ3qUtUsu2u
         3CDw==
X-Gm-Message-State: AOAM5301gLql3wFe52bVfEHcG1K3PY4U8ekt/HMbBhW1jmge37B6r0lJ
        J9He+gnphg695Yl1l1jkLcTq+YhOZwX+wQXKnK0=
X-Google-Smtp-Source: ABdhPJxQ8XeLgQWU082wlW/YG8RurqSRt4AqMvYpdKwBeUweDBCjsGSqd/pGB5jsxASxbNc0j4DkeLcRSvrRleOanoE=
X-Received: by 2002:a92:d8cc:: with SMTP id l12mr240700ilo.64.1608230940078;
 Thu, 17 Dec 2020 10:49:00 -0800 (PST)
MIME-Version: 1.0
References: <20201216001946.GF552508@nvidia.com> <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com> <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com> <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
 <20201216175112.GJ552508@nvidia.com> <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
 <20201216203537.GM552508@nvidia.com> <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
 <20201217003829.GN552508@nvidia.com>
In-Reply-To: <20201217003829.GN552508@nvidia.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 17 Dec 2020 10:48:48 -0800
Message-ID: <CAKgT0UcEjekh0Z+A+aZKWJmeudr5CZTXPwPtYb52pokDi1TF_w@mail.gmail.com>
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

On Wed, Dec 16, 2020 at 4:38 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Wed, Dec 16, 2020 at 02:53:07PM -0800, Alexander Duyck wrote:
>
> > It isn't about the association, it is about who is handling the
> > traffic. Going back to the macvlan model what we did is we had a group
> > of rings on the device that would automatically forward unicast
> > packets to the macvlan interface and would be reserved for
> > transmitting packets from the macvlan interface. We took care of
> > multicast and broadcast replication in software.
>
> Okay, maybe I'm starting to see where you are coming from.
>
> First, I think some clarity here, as I see it the devlink
> infrastructure is all about creating the auxdevice for a switchdev
> port.
>
> What goes into that auxdevice is *completely* up to the driver. mlx5
> is doing a SF which == VF, but that is not a requirement of the design
> at all.
>
> If an Intel driver wants to put a queue block into the aux device and
> that is != VF, it is just fine.
>
> The Intel netdev that binds to the auxdevice can transform the queue
> block and specific switchdev config into a netdev identical to
> accelerated macvlan. Nothing about the breaks the switchdev model.

Just to clarify I am not with Intel, nor do I plan to work on any
Intel drivers related to this.

My concern has more to do with how this is being plumbed and the fact
that the basic architecture is somewhat limiting.

> Essentially think of it as generalizing the acceleration plugin for a
> netdev. Instead of making something specific to limited macvlan, the
> driver gets to provide exactly the structure that matches its HW to
> provide the netdev as the user side of the switchdev port. I see no
> limitation here so long as the switchdev model for controlling traffic
> is followed.

I see plenty. The problem is it just sets up more vendor lock-in and
features that have to be thrown away when you have to settle for
least-common denominator in order to maintain functionality across
vendors.

> Let me segue into a short story from RDMA.. We've had a netdev called
> IPoIB for a long time. It is actually kind of similar to this general
> thing you are talking about, in that there is a programming layer
> under the IPOIB netdev called RDMA verbs that generalizes the actual
> HW. Over the years this became more complicated because every new
> netdev offloaded needed mirroring into the RDMA verbs general
> API. TSO, GSO, checksum offload, endlessly onwards. It became quite
> dumb in the end. We gave up and said the HW driver should directly
> implement netdev. Implementing a middle API layer makes zero sense
> when netdev is already perfectly suited to implement ontop of
> HW. Removing SW layers caused performance to go up something like
> 2x.
>
> The hard earned lesson I take from that is don't put software layers
> between a struct net_device and the actual HW. The closest coupling is
> really the best thing. Provide libary code in the kernel to help
> drivers implement common patterns when making their netdevs, do not
> provide wrapper netdevs around drivers.
>
> IMHO the approach of macvlan accleration made some sense in 2013, but
> today I would say it is mashing unrelated layers together and
> polluting what should be a pure SW implementation with HW hooks.

I disagree here. In my mind a design where two interfaces, which both
exist in the kernel, have to go to hardware in order to communicate is
very limiting. The main thing I am wanting to see is the option of
being able to pass traffic directly between the switchdev and the SF
without the need to touch the hardware.

An easy example of such traffic that would likely benefit from this is
multicast/broadcast traffic. Instead of having to process each and
every broadcast packet in hardware you could very easily process it at
the switchdev and then directly hand it off from the switchdev to the
SF in this case instead of having to send it to hardware for each
switchdev instance.

> I see from the mailing list comments this was done because creating a
> device specific netdev via 'ip link add' was rightly rejected. However
> here we *can* create a device specific vmdq *auxdevice*.  This is OK
> because the netdev is controlling and containing the aux device via
> switchdev.
>
> So, Intel can get the "VMDQ link type" that was originally desired more
> or less directly, so long as the associated switchdev port controls
> the MAC filter process, not "ip link add".
>
> And if you want to make the vmdq auxdevice into an ADI by user DMA to
> queues, then sure, that model is completely sane too (vs hacking up
> macvlan to expose user queues) - so long as the kernel controls the
> selection of traffic into those queues and follows the switchdev
> model. I would recommend creating a simple RDMA raw ethernet queue
> driver over the aux device for something like this :)

You lost me here, I'm not seeing how RDMA and macvlan are connected.

> > That might be a bad example, I was thinking of the issues we have had
> > with VFs and direct assignment to Qemu based guests in the past.
>
> As described, this is solved by VDPA.
>
> > Essentially what I am getting at is that the setup in the container
> > should be vendor agnostic. The interface exposed shouldn't be specific
> > to any one vendor. So if I want to fire up a container or Mellanox,
> > Broadcom, or some other vendor it shouldn't matter or be visible to
> > the user. They should just see a vendor agnostic subfunction
> > netdevice.
>
> Agree. The agnostic container user interface here is 'struct
> net_device'.

I disagree here. The fact is a mellanox netdev, versus a broadcom
netdev, versus an intel netdev all have a very different look at feel
as the netdev is essentially just the base device you are building
around.

In addition it still doesn't address my concern as called out above
which is the east-west traffic problem.

> > > I have the feeling this stuff you are asking for is already done..
> >
> > The case you are describing has essentially solved it for Qemu
> > virtualization and direct assignment. It still doesn't necessarily
> > solve it for the container case though.
>
> The container case doesn't need solving.

I disagree and that is at the heart where you and I have different
views. I view there being two advantages to having the container case
solved:
1. A standardized set of features that can be provided regardless of vendor
2. Allowing for the case where east-west traffic can avoid having to
touch hardware

> Any scheme I've heard for container live migration, like CRIU,
> essentially hot plugs the entire kernel in/out of a user process. We
> rely on the kernel providing low leakage of the implementation details
> of the struct net_device as part of it's uAPI contract. When CRIU
> swaps the kernel the new kernel can have any implementation of the
> container netdev it wants.

I'm not thinking about migration. I am thinking more about the user
experience. In my mind if I set up a container I shouldn't need to
know which vendor provided the network interface when I set it up. The
problem is most NICs have so many one-off proprietary tweaks needed
that it gets annoying. That is why in my mind it would make much more
sense to have a simple vendor agnostic interface. That is why I would
prefer to avoid the VF model.

> I've never heard of a use case to hot swap the implemention *under* a
> netdev from a container. macvlan can't do this today. If you have a
> use case here, it really has nothing to do with with this series.

Again, the hot-swap isn't necessarily what I am talking about. I am
talking about setting up a config for a set of containers in a
datacenter. What I don't want to do is have to have one set of configs
for an mlx5 SF, another for a broadcom SF, and yet another set for any
other vendors out there. I would much rather have all of that dealt
with within the namespace that is handling the switchdev setup.

In addition, the east-west traffic is the other bit I would like to
see addressed. I am okay excusing this in the case of direct
assignment since the resources for the SF will not be available to the
host. However if the SF will be operating in the same kernel as the
PF/switchev it would make much more sense to enable an east/west
channel which would allow for hardware bypass under certain
circumstances without having to ever leave the kernel.
