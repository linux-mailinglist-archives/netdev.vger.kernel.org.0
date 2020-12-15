Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4292DB45B
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 20:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731846AbgLOTOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 14:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731764AbgLOTNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 14:13:45 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45210C06179C;
        Tue, 15 Dec 2020 11:13:01 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id t9so20269797ilf.2;
        Tue, 15 Dec 2020 11:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MjBxeR6iqFs0La2Ze00m0vh6EKN6PVYTPDwtGigmCuA=;
        b=eElqqEvjfX5kIMcaicWDPOUitkwXijFS/KH8JZ29OBJWXbOWwExoD23KerVe4xUpez
         Y9ou5ozGwDOM4MEXewgzC0HVg4xezra7I4k89A7c3VqQuf7xRGf0ZbMdHQ2tmDAmOB9k
         +/4sEmKR/SiVjQq3zbYNhjwGvSubqc9mV8Ga8fFi3GGXQLX2XsSxXiSgS7nUMipVqWxk
         ya6LHGGUfykAxO7PkTBHUzbmTXI5UOZ3jweD9NJvEfGPbs/hTTzTM7dYHt3gPd46vKjm
         5CyI6pj6BFBZxtxVgVUdIG1zXWNuh39+YXte//ROAnBPpbGjQQY1RZWXmgTNxGB7J++N
         A9Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MjBxeR6iqFs0La2Ze00m0vh6EKN6PVYTPDwtGigmCuA=;
        b=jt36BmdZIyH7HTHek9D2gVcPD2TWVUCJVuUMmTAyWwAwcl2mTsDGwzGQyuZsohOaMI
         EoNb1/lzgHMMF+cfThQFswdoDd/xSE5H86e+s3Ha6QqjNS0WO3fCxeH6jzovHUTt17ov
         m0RdmMeXGUVwacnP0c8L/rAWBrJUyeakV7H0fhXVk3NMB0L+xMaEkXKqf/FCCBHc1+pL
         oWUxUtxyj1Hm2Tlbx2Yw8TPMoEffAsO5lsq4B89gj2bRDOTgyaidzRXe/hW1Mrru/LTc
         mA6aSAZvL+hwiiCAhQP+DfjT3MMa3OBZ5SZoodLMPMB4SOuUZXh1J+in9JJYqrgqB2TR
         M1Ag==
X-Gm-Message-State: AOAM531TBN47av3SizGM+q2wF6n3i1AwGlID142QunENgc8mb3awAHd7
        mBwFmI1YYKdJxWUSditCH32y+tNjUkqeyMDzbag=
X-Google-Smtp-Source: ABdhPJwIqjkzI+mADwafbGVWLyJYZkxyGEAg55i7g0Tu1ZaiTn4o2fPy0aqmL5UCUWQMRJZm3Vpz8R6Gr+RVXHsUqSw=
X-Received: by 2002:a92:730d:: with SMTP id o13mr41230055ilc.95.1608059580455;
 Tue, 15 Dec 2020 11:13:00 -0800 (PST)
MIME-Version: 1.0
References: <20201214214352.198172-1-saeed@kernel.org> <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
 <608505778d76b1b01cb3e8d19ecda5b8578f0f79.camel@kernel.org>
In-Reply-To: <608505778d76b1b01cb3e8d19ecda5b8578f0f79.camel@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 15 Dec 2020 11:12:49 -0800
Message-ID: <CAKgT0UfEsd0hS=iJTcVc20gohG0WQwjsGYOw1y0_=DRVbhb1Ng@mail.gmail.com>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
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

On Mon, Dec 14, 2020 at 10:15 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On Mon, 2020-12-14 at 17:53 -0800, Alexander Duyck wrote:
> > On Mon, Dec 14, 2020 at 1:49 PM Saeed Mahameed <saeed@kernel.org>
> > wrote:
> > > Hi Dave, Jakub, Jason,
> > >
> > > This series form Parav was the theme of this mlx5 release cycle,
> > > we've been waiting anxiously for the auxbus infrastructure to make
> > > it into
> > > the kernel, and now as the auxbus is in and all the stars are
> > > aligned, I
> > > can finally submit this V2 of the devlink and mlx5 subfunction
> > > support.
> > >
> > > Subfunctions came to solve the scaling issue of virtualization
> > > and switchdev environments, where SRIOV failed to deliver and users
> > > ran
> > > out of VFs very quickly as SRIOV demands huge amount of physical
> > > resources
> > > in both of the servers and the NIC.
> > >
> > > Subfunction provide the same functionality as SRIOV but in a very
> > > lightweight manner, please see the thorough and detailed
> > > documentation from Parav below, in the commit messages and the
> > > Networking documentation patches at the end of this series.
> > >
> >
> > Just to clarify a few things for myself. You mention virtualization
> > and SR-IOV in your patch description but you cannot support direct
> > assignment with this correct? The idea here is simply logical
> > partitioning of an existing network interface, correct? So this isn't
> > so much a solution for virtualization, but may work better for
> > containers. I view this as an important distinction to make as the
>
> at the current state yes, but the SF solution can be extended to
> support direct assignment, so this is why i think SF solution can do
> better and eventually replace SRIOV.

My only real concern is that this and mediated devices are essentially
the same thing. When you start making this work for direct-assignment
the only real difference becomes the switchdev and devlink interfaces.
Basically this is netdev specific mdev versus the PCIe specific mdev.

> also many customers are currently using SRIOV with containers to get
> the performance and isolation features since there was no other
> options.

There were, but you hadn't implemented them. The fact is the approach
Intel had taken for that was offloaded macvlan.

I think the big thing we really should do if we are going to go this
route is to look at standardizing what the flavours are that get
created by the parent netdevice. Otherwise we are just creating the
same mess we had with SRIOV all over again and muddying the waters of
mediated devices.

> > first thing that came to mind when I read this was mediated devices
> > which is similar, but focused only on the virtualization case:
> > https://www.kernel.org/doc/html/v5.9/driver-api/vfio-mediated-device.html
> >
> > > Parav Pandit Says:
> > > =================
> > >
> > > This patchset introduces support for mlx5 subfunction (SF).
> > >
> > > A subfunction is a lightweight function that has a parent PCI
> > > function on
> > > which it is deployed. mlx5 subfunction has its own function
> > > capabilities
> > > and its own resources. This means a subfunction has its own
> > > dedicated
> > > queues(txq, rxq, cq, eq). These queues are neither shared nor
> > > stealed from
> > > the parent PCI function.
> >
> > Rather than calling this a subfunction, would it make more sense to
> > call it something such as a queue set? It seems like this is exposing
> > some of the same functionality we did in the Intel drivers such as
> > ixgbe and i40e via the macvlan offload interface. However the
> > ixgbe/i40e hardware was somewhat limited in that we were only able to
> > expose Ethernet interfaces via this sort of VMQ/VMDQ feature, and
> > even
> > with that we have seen some limitations to the interface. It sounds
> > like you are able to break out RDMA capable devices this way as well.
> > So in terms of ways to go I would argue this is likely better.
>
> We've discussed this thoroughly on V0, the SF solutions is closer to a
> VF than a VMDQ, this is not just a set of queues.
>
> https://lore.kernel.org/linux-rdma/421951d99a33d28b91f2b2997409d0c97fa5a98a.camel@kernel.org/

VMDq is more than just a set of queues. The fact is it is a pool of
resources that get created to handle the requests for a specific VM.
The extra bits that are added here are essentially stuff that was
required to support mediated devices.

> > However
> > one downside is that we are going to end up seeing each subfunction
> > being different from driver to driver and vendor to vendor which I
> > would argue was also one of the problems with SR-IOV as you end up
> > with a bit of vendor lock-in as a result of this feature since each
> > vendor will be providing a different interface.
> >
>
> I disagree, SFs are tightly coupled with switchdev model and devlink
> functions port, they are backed with the a well defined model, i can
> say the same about sriov with switchdev mode, this sort of vendor lock-
> in issues is eliminated when you migrate to switchdev mode.

What you are talking about is the backend. I am talking about what is
exposed to the user. The user is going to see a Mellanox device having
to be placed into their container in order to support this. One of the
advantages of the Intel approach was that the macvlan interface was
generic so you could have an offloaded interface or not and the user
wouldn't necessarily know. The offload could be disabled and the user
would be none the wiser as it is moved from one interface to another.
I see that as a big thing that is missing in this solution.

> > > When subfunction is RDMA capable, it has its own QP1, GID table and
> > > rdma
> > > resources neither shared nor stealed from the parent PCI function.
> > >
> > > A subfunction has dedicated window in PCI BAR space that is not
> > > shared
> > > with ther other subfunctions or parent PCI function. This ensures
> > > that all
> > > class devices of the subfunction accesses only assigned PCI BAR
> > > space.
> > >
> > > A Subfunction supports eswitch representation through which it
> > > supports tc
> > > offloads. User must configure eswitch to send/receive packets
> > > from/to
> > > subfunction port.
> > >
> > > Subfunctions share PCI level resources such as PCI MSI-X IRQs with
> > > their other subfunctions and/or with its parent PCI function.
> >
> > This piece to the architecture for this has me somewhat concerned. If
> > all your resources are shared and you are allowing devices to be
>
> not all, only PCI MSIX, for now..

They aren't shared after you partition them but they are coming from
the same device. Basically you are subdividing the BAR2 in order to
generate the subfunctions. BAR2 is a shared resource in my point of
view.

> > created incrementally you either have to pre-partition the entire
> > function which usually results in limited resources for your base
> > setup, or free resources from existing interfaces and redistribute
> > them as things change. I would be curious which approach you are
> > taking here? So for example if you hit a certain threshold will you
> > need to reset the port and rebalance the IRQs between the various
> > functions?
> >
>
> Currently SFs will use whatever IRQs the PF has pre-allocated for
> itself, so there is no IRQ limit issue at the moment, we are
> considering a dynamic IRQ pool with dynamic balancing, or even better
> us the IMS approach, which perfectly fits the SF architecture.
> https://patchwork.kernel.org/project/linux-pci/cover/1568338328-22458-1-git-send-email-megha.dey@linux.intel.com/

When you say you are using the PF's interrupts are you just using that
as a pool of resources or having the interrupt process interrupts for
both the PF and SFs? Without IMS you are limited to 2048 interrupts.
Moving over to that would make sense since SF is similar to mdev in
the way it partitions up the device and resources.

> for internal resources the are fully isolated (not shared) and
> they are internally managed by FW exactly like a VF internal resources.

I assume by isolated you mean they are contained within page aligned
blocks like what was required for mdev?
