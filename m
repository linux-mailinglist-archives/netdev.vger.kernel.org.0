Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7915E2DC948
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 23:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgLPWyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 17:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbgLPWyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 17:54:00 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B356EC06179C;
        Wed, 16 Dec 2020 14:53:19 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id t9so24132250ilf.2;
        Wed, 16 Dec 2020 14:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4WOPNvQID0y9RJh0I5Q8OTeknUMxhddaG1KTWu+3010=;
        b=B87qxU4lgnm7kSJItXKS9DuAptZ58Y+ttcykNy3SQZz2KEPb++1WVrr/AjjAH+rj7D
         zLbyTeata5m7DDs6Dy+V+zAu0vc+ov4pUhJP7LsFIvb3NDRhT2+YZp1NO/nCBMnD4H9m
         8FPpDibGsC+hq77S0854LDu4JIqSkmIa8FgrRV6zZWgtg7Opwpnmx+ssvoHo57OgCJT1
         LdPtTEP6Y71QGhFwgh5JfK88EaRU2y+lvQeVH7xxcfPpzK+wDE0ely6/zzvrk0vdiHI3
         gka9IU35W1CMEAJZR5+imEs78I3h1iNwM24VG0IlYvW/s7NIOqshE3y0Qb2umkBYL7nF
         T2vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4WOPNvQID0y9RJh0I5Q8OTeknUMxhddaG1KTWu+3010=;
        b=FUXLhtj2eeYWIoN8UFzAr+gYF7/PJf3Niq/RstbMWOI5/23kIOqkO2vLZBpJtlvyPC
         TH+BL8rVd6VzwvrT+Xc5/FQ8ApYQqXl/togKD2bz49dy4UFzp9k1fGLDxBXDalEA1CxH
         NcSd/ljnj2xVCbXB6uPvYvz/cbSaGBfNIQpBqd/tOwKKnnE7DtsgW1B9orhURy53joxO
         Gh8ErJSFoTsxaM2ULMGjzhacH1JDkxbYOScIBR8YbEagLwyk5l96lLt7joUfvjbiT16a
         4GpuSI+bddsrU8u8DGc4L+wQHBN36pkhJ12phexaWGT6d/zui5kgFkxjZA7OqWGm1eTm
         0xmw==
X-Gm-Message-State: AOAM5307nhCleTcoy/vqmGN6Mi67KeT0KhxMmiOSsR2xrPnGBmd47b5P
        lG0a0vH/m+GeqEh4aiKvngZRO1yem8NdXSir8a4ZYP39/Vs=
X-Google-Smtp-Source: ABdhPJxA/OH86ST3oGh1e2r1UkIZpZ/VBhsL0FvlluQDwLMEOEc0P/3ZdPYtG8MRut/Xb8zLtUihjkl3v7468qe8FcY=
X-Received: by 2002:a92:c682:: with SMTP id o2mr48121301ilg.97.1608159198846;
 Wed, 16 Dec 2020 14:53:18 -0800 (PST)
MIME-Version: 1.0
References: <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com> <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com> <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com> <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
 <20201216175112.GJ552508@nvidia.com> <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
 <20201216203537.GM552508@nvidia.com>
In-Reply-To: <20201216203537.GM552508@nvidia.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 16 Dec 2020 14:53:07 -0800
Message-ID: <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
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

On Wed, Dec 16, 2020 at 12:35 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Wed, Dec 16, 2020 at 11:27:32AM -0800, Alexander Duyck wrote:
>
> > That has been the case for a long time. However it had been my
> > experience that SR-IOV never scaled well to meet those needs and so it
> > hadn't been used in such deployments.
>
> Seems to be going quite well here, perhaps the applications are
> different.
>
> > > The optimization here is to reduce the hypervisor workload and free up
> > > CPU cycles for the VMs/containers to consume. This means less handling
> > > of packets in the CPU, especially for VM cases w/ SRIOV or VDPA.
> > >
> > > Even the extra DMA on the NIC is not really a big deal. These are 400G
> > > NICs with big fast PCI. If you top them out you are already doing an
> > > aggregate of 400G of network traffic. That is a big number for a
> > > single sever, it is OK.
> >
> > Yes, but at a certain point you start bumping up against memory
> > throughput limitations as well. Doubling up the memory footprint by
> > having the device have to write to new pages instead of being able to
> > do something like pinning and zero-copy would be expensive.
>
> You can't zero-copy when using VMs.
>
> And when using containers every skb still has to go through all the
> switching and encapsulation logic, which is not free in SW.
>
> At a certain point the gains of avoiding the DMA copy are lost by the
> costs of all the extra CPU work. The factor being optimized here is
> CPU capacity.
>
> > > Someone might feel differently if they did this on a 10/40G NIC, in
> > > which case this is not the solution for their application.
> >
> > My past experience was with 10/40G NIC with tens of VFs. When we start
> > talking about hundreds I would imagine the overhead becomes orders of
> > magnitudes worse as the problem becomes more of an n^2 issue since you
> > will have n times more systems sending to n times more systems
>
> The traffic demand is application dependent. If an application has an
> n^2 traffic pattern then it needs a network to sustain that cross
> sectional bandwidth regardless of how the VMs are packed.
>
> It just becomes a design factor of the network and now the network
> includes that switching component on the PCIe NIC as part of the
> capacity for cross sectional BW.
>
> There is some balance where a VM can only generate so much traffic
> based on the CPU it has available, and you can design the entire
> infrastructure to balance the CPU with the NIC with the switches and
> come to some packing factor of VMs.
>
> As CPU constrains VM performance, removing CPU overheads from the
> system will improve packing density. A HW network data path in the VMs
> is one such case that can turn to a net win if the CPU bottleneck is
> bigger than the network bottleneck.
>
> It is really over simplifiying to just say PCIe DMA copies are bad.

I'm not saying the copies are bad. However they can be limiting. As
you said it all depends on the use case. If you have nothing but
functions that are performing bump-in-the-wire type operations odds
are the PCIe bandwidth won't be the problem. It all depends on the use
case and that is why I would prefer the interface to be more flexible
rather than just repeating what has been done with SR-IOV.

The problem in my case was based on a past experience where east-west
traffic became a problem and it was easily shown that bypassing the
NIC for traffic was significantly faster.

> > receiving. As such things like broadcast traffic would end up
> > consuming a fair bit of traffic.
>
> I think you have a lot bigger network problems if your broadcast
> traffic is so high that you start to worry about DMA copy performance
> in a 400G NIC.

Usually the problems were more multicast rather than broadcast, but
yeah this typically isn't an issue. However still at 256 VFs you would
be talking about a replication rate such that at 1-2Gbps one VF could
saturate the entire 400G device.

> > The key bit here is outside of netdev. Like I said, SIOV and SR-IOV
> > tend to be PCIe specific specifications. What we are defining here is
> > how the network interfaces presented by such devices will work.
>
> I think we've achieved this..

Somewhat. We have it explained for the control plane. What we are
defining now is how it will appear in the guest/container.

> > > That seems small enough it should be resolvable, IMHO. eg some new
> > > switch rule that matches that specific HW behavior?
> >
> > I would have to go digging to find the conversation. It was about 3 or
> > 4 years ago. I seem to recall mentioning the idea of having some
> > static rules but it was a no-go at the time. If we wanted to spin off
> > this conversation and pull in some Intel folks I would be up for us
> > revisiting it. However I'm not with Intel anymore so it would mostly
> > be something I would be working on as a hobby project instead of
> > anything serious.
>
> Personally I welcome getting more drivers to implement the switchdev
> model, I think it is only good for the netdev community as as a whole
> to understand and standardize on this.

Agreed.

> > > > Something like the vdpa model is more like what I had in mind. Only
> > > > vdpa only works for the userspace networking case.
> > >
> > > That's because making a driver that converts the native HW to VDPA and
> > > then running a generic netdev on the resulting virtio-net is a pretty
> > > wild thing to do. I can't really think of an actual use case.
> >
> > I'm not talking about us drastically changing existing models. I would
> > still expect the mlx5 driver to be running on top of the aux device.
> > However it may be that the aux device is associated with something
> > like the switchdev port as a parent
>  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> That is exactly how this works. The switchdev representor and the aux
> device are paired and form the analog of the veth tunnel. IIRC this
> relationship with the aux device is shown in the devlink output for
> the switchdev ports.
>
> I still can't understand what you think should be changed here.
>
> We can't get rid of the aux device, it is integral to the software
> layering and essential to support any device assignment flow.
>
> We can't add a mandatory netdev, because that is just pure waste for
> any device assignment flow.

I'm not saying to get rid of the netdev. I'm saying the netdev created
should be a generic interface that could be reused by other vendors.
The whole idea behind using something like macvlan is to hide the
underlying device. It becomes the namespace assignable interface. What
I would like to see is us get rid of that step and instead just have a
generic interface spawned in the first place and push the driver
specific bits back to the switchdev port.

The problem right now is that the switchdev netdev and the subfunction
netdev are treated as peers. In my mind it should work somewhere in
between the macvlan and veth. Basically you have the switchedev port
handling both ends of the traffic and handling the aux device
directly, and the subfunction device is floating on top of it
sometimes acting like a macvlan when traffic is going to/from the aux
device, and acting like a veth pair in some cases perhaps such as
broadcast/multicast allowing the swtichdev to take care of that
locally.

> > The basic idea is most of the control is still in the switchdev
> > port, but it becomes more visible that the switchdev port and the
> > subfunction netdev are linked with the switchdev port as the parent.
>
> If a user netdev is created, say for a container, then it should have
> as a parent the aux device.
>
> If you inspect the port configuration on the switchdev side it will
> show the aux device associated with the port.
>
> Are you just asking that the userspace tools give a little help and
> show that switchdev port XX is visable as netdev YYY by cross matching
> the auxbus?

It isn't about the association, it is about who is handling the
traffic. Going back to the macvlan model what we did is we had a group
of rings on the device that would automatically forward unicast
packets to the macvlan interface and would be reserved for
transmitting packets from the macvlan interface. We took care of
multicast and broadcast replication in software.

In my mind it should be possible to do something similar for the
swtichdev case. Basically the packets would be routed from the
subfunction netdev, to the switchdev netdev, and could then be
transmitted through the aux device. In order to make this work in the
case of ixgbe I had come up with the concept of a subordinate device,
"sb_dev", which was a pointer used in the Tx case to identify Tx rings
and qdiscs that had been given to macvlan interface.

> > > > they are pushed into containers you don't have to rip them out if for
> > > > some reason you need to change the network configuration.
> > >
> > > Why would you need to rip them out?
> >
> > Because they are specifically tied to the mlx5 device. So if for
> > example I need to hotplug out the mlx5 and replace it,
>
> Uhh, I think we are very very far away from being able to hot unplug a
> switchdev driver, keep the switchdev running, and drop in a different
> driver.
>
> That isn't even on the radar, AFAIK.

That might be a bad example, I was thinking of the issues we have had
with VFs and direct assignment to Qemu based guests in the past.
Essentially what I am getting at is that the setup in the container
should be vendor agnostic. The interface exposed shouldn't be specific
to any one vendor. So if I want to fire up a container or Mellanox,
Broadcom, or some other vendor it shouldn't matter or be visible to
the user. They should just see a vendor agnostic subfunction
netdevice.

Something like that is doable already using something like a macvlan
on top of a subfunction interface, but I feel like that is an
unnecessary step and creates unnecessary netdevices.

> > namespace. One of the issues with VFs is that we have always had to
> > push some sort of bond on top, or switch over to a virtio-net
> > interface in order to support fail-over. If we can resolve that in the
> > host case that would go a long way toward solving one of the main
> > issues of SR-IOV.
>
> This is all solved already, virtio-net is the answer.
>
> qemu can swap back ends under the virtio-net ADI it created on the
> fly. This means it can go from processing a virtio-net queue in mlx5
> HW, to full SW, to some other HW on another machine. All hitlessly and
> transparently to the guest VM.
>
> Direct HW processing of a queue inside a VM without any downsides for
> VM migration. Check.
>
> I have the feeling this stuff you are asking for is already done..

The case you are describing has essentially solved it for Qemu
virtualization and direct assignment. It still doesn't necessarily
solve it for the container case though.
