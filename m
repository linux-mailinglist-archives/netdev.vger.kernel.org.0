Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982732DDA8C
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 22:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731747AbgLQVF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 16:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727098AbgLQVF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 16:05:56 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7E9C061794;
        Thu, 17 Dec 2020 13:05:16 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id q1so203439ilt.6;
        Thu, 17 Dec 2020 13:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R97mLYIX7kdbmaBC+pqxzDjyqmvSasP0w/jYNgrx+TA=;
        b=LLi5KWWXmyNlvtPSuHNqd7oHefH7zQl18JI8uLvUicOunKk5zdkrWQkdbE0qsHL7JE
         69IISNnCW6SjMojga1rWH+nv2jaf6BfzM+/Xk30ttmvgBAhZIoRtO3H5ZTabE628FB/T
         SmGjVYKPQ3cpuNy2+xGfNAJiWVJiFEvr1laBPEDFWVbu6gHca2EvOLu6gOLSP+3WzOa4
         Sjw1kekGFmIkF/gVXaOfw6JrIMswzPayv/DcRNDJsnlX+VQNe2tVSzAuw5cbtr02fmTq
         1iiE72ajVU7+Gr2Cyb4Ha0SfkcikuQomdmK2e8v+Kv+Wg2//5Ycgr0nxy3pOFT6GXLFO
         zn5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R97mLYIX7kdbmaBC+pqxzDjyqmvSasP0w/jYNgrx+TA=;
        b=kqlFv+xkH3HWp7nZUKgpA3GIhCLTunXdQgJkxnfUj5sgTWzXZzIlNGYiWlH02AflS8
         P7KCx6MP+bPlAn2vjUlsrYWQTjXv/NH0hphJcG2Q861o3fyF4NH5JQsxP8JuU4GDijVc
         vjawFjM14cr85rFTLauWPlMw4tsGn6a8lBCn3ljgDXkLm1tFL92SMQrRaTIctdudtn8z
         AxlpWeeB4iz3bXbTx/uJJOA5Hzae4xUFOpMB9YjUbJ6E8vPpFlljhJA3dzXpgBNLmUbr
         QxwAVL3/FTxBfPYiIcEcYhMvtdcOTNJvCQuPJq376Wt06WVTfm4oY1JTFPMt0MsVu2Yn
         OYKQ==
X-Gm-Message-State: AOAM530sB51BhtQ24Mabd2j/cHQseZze9ixuk3sUEDnrAZ5NqYqEyOFK
        22KAiRJKPtO2aq8dOAtiyDLsjaRIrp6E+B7G/AsLKWhR7lM=
X-Google-Smtp-Source: ABdhPJyxnPp7/3/QSQdcIjlzhFLzuQMPybzvZ4HO/HC+5dxFwbITsWoWWF+Hln5429caADGX1DlXLOrL4bqCtfwAfIQ=
X-Received: by 2002:a05:6e02:929:: with SMTP id o9mr805990ilt.42.1608239115389;
 Thu, 17 Dec 2020 13:05:15 -0800 (PST)
MIME-Version: 1.0
References: <20201216030351.GH552508@nvidia.com> <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com> <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
 <20201216175112.GJ552508@nvidia.com> <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
 <20201216203537.GM552508@nvidia.com> <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
 <20201217003829.GN552508@nvidia.com> <CAKgT0UcEjekh0Z+A+aZKWJmeudr5CZTXPwPtYb52pokDi1TF_w@mail.gmail.com>
 <20201217194035.GT552508@nvidia.com>
In-Reply-To: <20201217194035.GT552508@nvidia.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 17 Dec 2020 13:05:03 -0800
Message-ID: <CAKgT0Ue9+cd-Mp4qgusorDX1mnjfzMXrQvB2FqLaH+ouzVTMRQ@mail.gmail.com>
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

On Thu, Dec 17, 2020 at 11:40 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Thu, Dec 17, 2020 at 10:48:48AM -0800, Alexander Duyck wrote:
>
> > Just to clarify I am not with Intel, nor do I plan to work on any
> > Intel drivers related to this.
>
> Sure
>
> > I disagree here. In my mind a design where two interfaces, which both
> > exist in the kernel, have to go to hardware in order to communicate is
> > very limiting. The main thing I am wanting to see is the option of
> > being able to pass traffic directly between the switchdev and the SF
> > without the need to touch the hardware.
>
> I view the SW bypass path you are talking about similarly to
> GSO/etc. It should be accessed by the HW driver as an optional service
> provided by the core netdev, not implemented as some wrapper netdev
> around a HW implementation.

I view it as being something that would be a part of the switchdev API
itself. Basically the switchev and endpoint would need to be able to
control something like this because if XDP were enabled on one end or
the other you would need to be able to switch it off so that all of
the packets followed the same flow and could be scanned by the XDP
program.

> If you feel strongly it is needed then there is nothing standing in
> the way to implement it in the switchdev auxdevice model.
>
> It is simple enough, the HW driver's tx path would somehow detect
> east/west and queue it differently, and the rx path would somehow be
> able to mux in skbs from a SW queue. Not seeing any blockers here.

In my mind the simple proof of concept for this would be to check for
the multicast bit being set in the destination MAC address for packets
coming from the subfunction. If it is then shunt to this bypass route,
and if not then you transmit to the hardware queues. In the case of
packets coming from the switchdev port it would probably depend. The
part I am not sure about is if any packets need to be actually
transmitted to the hardware in the standard case for packets going
from the switchdev port to the subfunction. If there is no XDP or
anything like that present in the subfunction it probably wouldn't
matter and you could just shunt it straight across and bypass the
hardware, however if XDP is present you would need to get the packets
into the ring which would force the bypass to be turned off.

> > > model. I would recommend creating a simple RDMA raw ethernet queue
> > > driver over the aux device for something like this :)
> >
> > You lost me here, I'm not seeing how RDMA and macvlan are connected.
>
> RDMA is the standard uAPI to get a userspace HW DMA queue for ethernet
> packets.

Ah, I think you are talking about device assignment. In my mind I was
just talking about the interface assigned to the container which as
you have stated is basically just a netdev.

> > > > Essentially what I am getting at is that the setup in the container
> > > > should be vendor agnostic. The interface exposed shouldn't be specific
> > > > to any one vendor. So if I want to fire up a container or Mellanox,
> > > > Broadcom, or some other vendor it shouldn't matter or be visible to
> > > > the user. They should just see a vendor agnostic subfunction
> > > > netdevice.
> > >
> > > Agree. The agnostic container user interface here is 'struct
> > > net_device'.
> >
> > I disagree here. The fact is a mellanox netdev, versus a broadcom
> > netdev, versus an intel netdev all have a very different look at feel
> > as the netdev is essentially just the base device you are building
> > around.
>
> Then fix the lack of standardization of netdev implementations!

We're trying to work on that, but trying to fix it after the fact is
like herding cats.

> Adding more abstraction layers isn't going to fix that fundamental
> problem.
>
> Frankly it seems a bit absurd to complain that the very basic element
> of the common kernel uAPI - struct net_device - is so horribly
> fragmented and vendor polluted that we can't rely on it as a stable
> interface for containers.

The problem isn't necessarily the net_device it is more the
net_device_ops and the fact that there are so many different ways to
get things done. Arguably the flexibility of the netd_device is great
for allowing vendors to expose their features. However at the same
time it allows for features to be left out so what you end up with a
wide variety of things that are net_devices.

> Even if that is true, I don't belive for a second that adding a
> different HW abstraction layer is going to somehow undo the mistakes
> of the last 20 years.

It depends on how it is done. The general idea is to address the
biggest limitation that has occured, which is the fact that in many
cases we don't have software offloads to take care of things when the
hardware offloads provided by a certain piece of hardware are not
present. It would basically allow us to reset the feature set. If
something cannot be offloaded in software in a reasonable way, it is
not allowed to be present in the interface provided to a container.
That way instead of having to do all the custom configuration in the
container recipe it can be centralized to one container handling all
of the switching and hardware configuration.

> > Again, the hot-swap isn't necessarily what I am talking about. I am
> > talking about setting up a config for a set of containers in a
> > datacenter. What I don't want to do is have to have one set of configs
> > for an mlx5 SF, another for a broadcom SF, and yet another set for any
> > other vendors out there. I would much rather have all of that dealt
> > with within the namespace that is handling the switchdev setup.
>
> If there is real problems here then I very much encourage you to start
> an effort to push all the vendors to implement a consistent user
> experience for the HW netdevs.

To some extent that has been going on for some time. It is one of the
reasons why there is supposed to be software offloads for any datapath
features that get added to the hardware. Such as GSO to offset TSO.
However there always ends up the occasional thing that ends up getting
past and that is where the frustration comes in.

> I don't know what your issues are, but it sounds like it would be a
> very interesting conference presentation.
>
> But it has nothing to do with this series.
>
> Jason

There I disagree. Now I can agree that most of the series is about
presenting the aux device and that part I am fine with. However when
the aux device is a netdev and that netdev is being loaded into the
same kernel as the switchdev port is where the red flags start flying,
especially when we start talking about how it is the same as a VF.

In my mind we are talking about how the switchdev will behave and it
makes sense to see about defining if a east-west bypass makes sense
and how it could be implemented, rather than saying we won't bother
for now and potentially locking in the subfunction to virtual function
equality. In my mind we need more than just the increased count to
justify going to subfunctions, and I think being able to solve the
east-west problem at least in terms of containers would be such a
thing.
