Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F76D2DC716
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgLPT2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbgLPT2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 14:28:25 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB49C061794;
        Wed, 16 Dec 2020 11:27:45 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id n4so25093430iow.12;
        Wed, 16 Dec 2020 11:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KU4LT2OrkDkWhkvdXNGdgrIrThcY6rZEg8AzSyHpsrU=;
        b=ZJn7PLDuJwvKDUenYYbpMjyrWb+JnhpvAwjaIIxNu5lnnHbZRAHjY8aSK+UWTFc0n6
         R3g/bDaejQ4T17RtK7JtL5g/lCnBSHW30crfMBvoq6U6fzFHpGqCRFJYPuv+ANL7mMhT
         Pl8Sm5L5uqo3YPlvpoWVrNz9/jdAEALqh5dv9qurECWE3eiw+qYKhHuWUJo+I0K7ruY8
         JASqZeV6ydpcYS5yP1x5NkJHHnuQyI0q4zsXvj1i6Bk6esVfj8YEOBatYMyae8JMKZVb
         W20h2ZTmJ1M9jAvv3hyQwRWKynWd6iyH0mLSSlgQ2uMAO/liGosHU/+/W5FelN+URhup
         kbnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KU4LT2OrkDkWhkvdXNGdgrIrThcY6rZEg8AzSyHpsrU=;
        b=l15siiFc7Ou34cjmaBkA8z0LELsJo2/1TAuSMuO6b0Q9njJKsDQzT80G8YJYI8Fqi1
         V9cSleRJwPONcMqgfynPVR1zAOUoX97CvksB+odTgYnikVeDHFuVKktRsAk5lIZVKZcy
         w7aPO8XE0y4fLA6V52wi9pv2thLqVf1AZrnabRdV2cHmXb3L21HQtPKrM7AfbiF72ger
         g2bvd8l7BD+zpSfD3hAmhmoQiuE+rZwcQ4WTeIiVcm3vLcodGbpT7GbPG34J3MjOtvOd
         U7FU4u5ZW0f6mL7ejT7ta5FwHzz1nvKV6m5NXmYKDq9tfBT9vQUgEhTyQ9hcxoUUfJG3
         oFAw==
X-Gm-Message-State: AOAM5308CtQv7M5Drg3R5tzSSQZVXH2l+DZ8aS5xOcadzWvl1uFYVx2O
        wnCddq1n4/6V2zaNSL8+/xohUjA8zVcOZEK/UvA=
X-Google-Smtp-Source: ABdhPJzFFypmhSgrLr+7xyrOp9jbzSLMqDYE1e6v+PEXRKfpRbHzMu7q/7akd+DzwKEoRkHy7s32iKaCd1a0fgiyPgg=
X-Received: by 2002:a05:6602:150b:: with SMTP id g11mr43179764iow.88.1608146864028;
 Wed, 16 Dec 2020 11:27:44 -0800 (PST)
MIME-Version: 1.0
References: <608505778d76b1b01cb3e8d19ecda5b8578f0f79.camel@kernel.org>
 <CAKgT0UfEsd0hS=iJTcVc20gohG0WQwjsGYOw1y0_=DRVbhb1Ng@mail.gmail.com>
 <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com> <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com> <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com> <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
 <20201216175112.GJ552508@nvidia.com>
In-Reply-To: <20201216175112.GJ552508@nvidia.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 16 Dec 2020 11:27:32 -0800
Message-ID: <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
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

On Wed, Dec 16, 2020 at 9:51 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Wed, Dec 16, 2020 at 08:31:44AM -0800, Alexander Duyck wrote:
>
> > You say this will scale better but I am not even sure about that. The
> > fact is SR-IOV could scale to 256 VFs, but for networking I kind of
> > doubt the limitation would have been the bus number and would more
> > likely be issues with packet replication and PCIe throughput,
> > especially when you start dealing with east-west traffic within the
> > same system.
>
> We have been seeing deployments already hitting the 256 limit. This is
> not a "theoretical use" patch set. There are already VM and container
> farms with SW networking that support much more than 256 VM/containers
> per server.

That has been the case for a long time. However it had been my
experience that SR-IOV never scaled well to meet those needs and so it
hadn't been used in such deployments.

> The optimization here is to reduce the hypervisor workload and free up
> CPU cycles for the VMs/containers to consume. This means less handling
> of packets in the CPU, especially for VM cases w/ SRIOV or VDPA.
>
> Even the extra DMA on the NIC is not really a big deal. These are 400G
> NICs with big fast PCI. If you top them out you are already doing an
> aggregate of 400G of network traffic. That is a big number for a
> single sever, it is OK.

Yes, but at a certain point you start bumping up against memory
throughput limitations as well. Doubling up the memory footprint by
having the device have to write to new pages instead of being able to
do something like pinning and zero-copy would be expensive.

For something like an NFV use case it might make sense, but in the
general high server count case it seems like it is a setup that would
be detrimental.

> Someone might feel differently if they did this on a 10/40G NIC, in
> which case this is not the solution for their application.

My past experience was with 10/40G NIC with tens of VFs. When we start
talking about hundreds I would imagine the overhead becomes orders of
magnitudes worse as the problem becomes more of an n^2 issue since you
will have n times more systems sending to n times more systems
receiving. As such things like broadcast traffic would end up
consuming a fair bit of traffic.

> > Sorry you used the word "replace", and my assumption here was that the
> > goal is to get something in place that can take the place of SR-IOV so
> > that you wouldn't be maintaining the two systems at the same time.
> > That is my concern as I don't want us having SR-IOV, and then several
> > flavors of SIOV. We need to decide on one thing that will be the way
> > forward.
>
> SRIOV has to continue until the PASID and IMS platform features are
> widely available and mature. It will probably be 10 years before we
> see most people able to use SIOV for everything they want.
>
> I think we will see lots of SIOV varients, I know Intel is already
> pushing SIOV parts outside netdev.

The key bit here is outside of netdev. Like I said, SIOV and SR-IOV
tend to be PCIe specific specifications. What we are defining here is
how the network interfaces presented by such devices will work.

> > I get that. That is why I said switchdev isn't a standard for the
> > endpoint. One of the biggest issues with SR-IOV that I have seen is
> > the fact that the last piece isn't really defined. We never did a good
> > job of defining how the ADI should look to the guest and as a result
> > it kind of stalled in adoption.
>
> The ADI is supposed to present the HW programming API that is
> desired. It is always up to the implementation.
>
> SIOV was never a project to standardize HW programming models like
> virtio-net, NVMe, etc.

I agree. Just like SR-IOV never spelled out that network devices
should be using switchdev. That is something we decided on as a
community. What I am explaining here is that we should be thinking
about the implications of how the network interface is exposed in the
host in the case of subfunctions that are associated with a given
switchdev device.

> > > I'm a bit surprised HW that can do macvlan can't be modeled with
> > > switchdev? What is missing?
> >
> > If I recall it was the fact that the hardware defaults to transmitting
> > everything that doesn't match an existing rule to the external port
> > unless it comes from the external port.
>
> That seems small enough it should be resolvable, IMHO. eg some new
> switch rule that matches that specific HW behavior?

I would have to go digging to find the conversation. It was about 3 or
4 years ago. I seem to recall mentioning the idea of having some
static rules but it was a no-go at the time. If we wanted to spin off
this conversation and pull in some Intel folks I would be up for us
revisiting it. However I'm not with Intel anymore so it would mostly
be something I would be working on as a hobby project instead of
anything serious.

> > Something like the vdpa model is more like what I had in mind. Only
> > vdpa only works for the userspace networking case.
>
> That's because making a driver that converts the native HW to VDPA and
> then running a generic netdev on the resulting virtio-net is a pretty
> wild thing to do. I can't really think of an actual use case.

I'm not talking about us drastically changing existing models. I would
still expect the mlx5 driver to be running on top of the aux device.
However it may be that the aux device is associated with something
like the switchdev port as a parent and the output from the traffic is
then going to the subfunction netdev.

> > Basically the idea is to have an assignable device interface that
> > isn't directly tied to the hardware.
>
> The switchdev model is to create a switch port. As I explained in
> Linux we see "pci device" and "aux device" as being some "user port"
> options to access to that switch.
>
> If you want a "generic device" that is fine, but what exactly is that
> programming interface in Linux? Sketch out an API, where does the idea
> go?  What does the driver that implement it look like? What consumes
> it?
>
> Should this be a great idea, then a mlx5 version of this will still be
> to create an SF aux device, bind mlx5_core, then bind "generic device"
> on top of that. This is simply a reflection of how the mlx5 HW/SW
> layering works. Squashing all of this into a single layer is work with
> no bad ROI.

In my mind the mlx5_core is still binding to the SF aux device so I am
fine with that. The way I view this working is that it would work sort
of like the macvlan approach that was taken with the Intel parts.
Although instead of binding to the PF it might make more sense to have
it bound to the switchdev port associated with the subfunction and
looking like a veth pair from the host perspective in terms of
behavior. The basic idea is most of the control is still in the
switchdev port, but it becomes more visible that the switchdev port
and the subfunction netdev are linked with the switchdev port as the
parent.

> > they are pushed into containers you don't have to rip them out if for
> > some reason you need to change the network configuration.
>
> Why would you need to rip them out?

Because they are specifically tied to the mlx5 device. So if for
example I need to hotplug out the mlx5 and replace it, it would be
useful to allow the interface in the containers to stay in place and
fail over to some other software backing interface in the switchdev
namespace. One of the issues with VFs is that we have always had to
push some sort of bond on top, or switch over to a virtio-net
interface in order to support fail-over. If we can resolve that in the
host case that would go a long way toward solving one of the main
issues of SR-IOV.
