Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29ED42DC15C
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 14:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgLPNd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 08:33:56 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3797 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgLPNd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 08:33:56 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fda0c9b0000>; Wed, 16 Dec 2020 05:33:15 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Dec
 2020 13:33:13 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Dec 2020 13:33:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agDzzokNabXSGaNcMtgT3pGzQHAI6h97mZGEXNK7B3PbOxNBWxukQXhuwbNGpf/LdM9gIadKm0itI0KnLWUFLW1mJnFZfBhFf99PAtvky851hItlqY22Lnv2WqeZjBy1OLDa29ogwr1f7qfj+q6/Q9h4AOKkn+vpNatbSzSOiTwUIdYDqFyDFWeg6RPQ46HUZkV8Bbs2ZyVK3RzRKn/gY2jw2Efwx8FUcKT8IsU+vR/p9INXPPQmtfg/fChL/j/qSNJU7HI31j7/+VvY6jFVsQ0WKnwdBBT3luOpYZkfFOGnHe8kY0DSPLmCnx7o9aETCYs8hKz7F+NO4HhdYXE6Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynAkTSTOfyObBH759mQ91PYjzmn1dLSOYJQg1Hg+LiQ=;
 b=e6sivgpYCLdDzjURPoFUciJgf8bCMlDeXBQ8tS3U7pAxjOO11K7/FfLHOk+vtsN3jUoeuDOw4MFxnrS72mo2rzbo48UjJoNRe2v8pUUKdjRlMoQtNO+lxwZKMEouV7yvw0YMgVTo65VA1Vyf9m9Tl+wdx4tyGFtpMZnB+3Mqz+h6By2k9Qh+Ide+Z3hcl3Ya2VvJ/xmnoqS+So0jcJBGXxP+Fg4RsnzAfdY6oAstGQenBTKEg3zAWOKOg5gtzmyi+rU3/aNRs26n2VgELTvCM+jK9zBcYncBFLUfe61tqaGwYrIo8XAy1a/6UrjQFE/2lKw3PBtC7MUzpeSrnIsCrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1514.namprd12.prod.outlook.com (2603:10b6:4:f::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.12; Wed, 16 Dec 2020 13:33:11 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433%3]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 13:33:11 +0000
Date:   Wed, 16 Dec 2020 09:33:09 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
Message-ID: <20201216133309.GI552508@nvidia.com>
References: <20201214214352.198172-1-saeed@kernel.org>
 <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
 <608505778d76b1b01cb3e8d19ecda5b8578f0f79.camel@kernel.org>
 <CAKgT0UfEsd0hS=iJTcVc20gohG0WQwjsGYOw1y0_=DRVbhb1Ng@mail.gmail.com>
 <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com>
 <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com>
 <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
X-ClientProxiedBy: BL0PR02CA0060.namprd02.prod.outlook.com
 (2603:10b6:207:3d::37) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0060.namprd02.prod.outlook.com (2603:10b6:207:3d::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 16 Dec 2020 13:33:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kpWvV-00BGmZ-Dt; Wed, 16 Dec 2020 09:33:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608125595; bh=ynAkTSTOfyObBH759mQ91PYjzmn1dLSOYJQg1Hg+LiQ=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=sGisFtoZXQdqFXSZBcgfFdzT1TwmYLTNVYtmydIIyOsifvpGV4DEL7N4vLxEPvWMF
         ws3N1gqdkwFAqDv8YAYTIfZYsfya7nUXHcNrBbsPJW/3POSxKws/9OBD7B28MesCU6
         imtliFmaefGdcMveyx0R3qiYAxdCvsNaHilPcBIsoBT07HOzu73cQgXY0yXd6NMNxV
         oK5aVLkV+b46kGkvCALEi5RjkV7Lk6MQXTuZfqFlokxjGQG9MHaBM9YyUhUywCyfEl
         c97q3lPyP+4ZoVYxazxvJ/BoMQkwYBhfLiy6DotmYzFfDpaMpVY0aRj04xZcAkzlhK
         jwZt5MECtL7Gw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 08:13:21PM -0800, Alexander Duyck wrote:

> > > Ugh, don't get me started on switchdev. The biggest issue as I see it
> > > with switchev is that you have to have a true switch in order to
> > > really be able to use it.
> >
> > That cuts both ways, suggesting HW with a true switch model itself
> > with VMDq is equally problematic.
> 
> Yes and no. For example the macvlan offload I had setup could be
> configured both ways and it made use of VMDq. I'm not necessarily
> arguing that we need to do VMDq here, however at the same time saying
> that this is only meant to replace SR-IOV becomes problematic since we
> already have SR-IOV so why replace it with something that has many of
> the same limitations?

Why? Because SR-IOV is the *only* option for many use cases. Still. I
said this already, something more generic does not magicaly eliminate
SR-IOV.

The SIOV ADI model is a small refinement to the existing VF scheme, it
is completely parallel to making more generic things.

It is not "repeating mistakes" it is accepting the limitations of
SR-IOV because benefits exist and applications need those benefits.
 
> That said I understand your argument, however I view the elimination
> of SR-IOV to be something we do after we get this interface right and
> can justify doing so. 

Elimination of SR-IOV isn't even a goal here!

> Also it might be useful to call out the flavours and planned flavours
> in the cover page. Admittedly the description is somewhat lacking in
> that regard.

This is more of a general switchdev remark though. In the swithdev
model you have a the switch and a switch port. Each port has a
swichdev representor on the switch side and a "user port" of some
kind.

It can be a physical thing:
 - SFP
 - QSFP
 - WiFi Antennae

It could be a semi-physical thing outside the view of the kernel:
 - SmartNIC VF/SF attached to another CPU

It can be a semi-physical thing in view of this kernel:
 - SRIOV VF (struct pci device)
 - SF (struct aux device)

It could be a SW construct in this kernel:
 - netdev (struct net device)

*all* of these different port types are needed. Probably more down the
road!

Notice I don't have VPDA, VF/SF netdev, or virtio-mdev as a "user
port" type here. Instead creating the user port pci or aux device
allows the user to use the Linux driver model to control what happens
to the pci/aux device next.

> I would argue that is one of the reasons why this keeps being
> compared to either VMDq or VMQ as it is something that SR-IOV has
> yet to fully replace and has many features that would be useful in
> an interface that is a subpartition of an existing interface.

In what sense does switchdev and a VF not fully replace macvlan VMDq?

> The Intel drivers still have the macvlan as the assignable ADI and
> make use of VMDq to enable it.

Is this in-tree or only in the proprietary driver? AFAIK there is no
in-tree way to extract the DMA queue from the macvlan netdev into
userspace..

Remeber all this VF/SF/VDPA stuff results in a HW dataplane, not a SW
one. It doesn't really make sense to compare a SW dataplane to a HW
one. HW dataplanes come with limitations and require special driver
code.

> The limitation as I see it is that the macvlan interface doesn't allow
> for much in the way of custom offloads and the Intel hardware doesn't
> support switchdev. As such it is good for a basic interface, but
> doesn't really do well in terms of supporting advanced vendor-specific
> features.

I don't know what it is that prevents Intel from modeling their
selector HW in switchdev, but I think it is on them to work with the
switchdev folks to figure something out.

I'm a bit surprised HW that can do macvlan can't be modeled with
switchdev? What is missing?

> > That is goal here. This is not about creating just a netdev, this is
> > about the whole kit: rdma, netdev, vdpa virtio-net, virtio-mdev.
> 
> One issue is right now we are only seeing the rdma and netdev. It is
> kind of backwards as it is using the ADIs on the host when this was
> really meant to be used for things like mdev.

This is second 15 patch series on this path already. It is not
possible to pack every single thing into this series. This is the
micro step of introducing the SF idea and using SF==VF to show how the
driver stack works. The minimal changing to the existing drivers
implies this can support an ADI as well.

Further, this does already show an ADI! vdpa_mlx5 will run on the
VF/SF and eventually causes qemu to build a virtio-net ADI that
directly passes HW DMA rings into the guest.

Isn't this exactly the kind of generic SRIOV replacement option you
have been asking for? Doesn't this completely supersede stuff built on
macvlan?

> expected to work. The swtichdev API puts some restrictions in place
> but there still ends up being parts without any definition.

I'm curious what you see as needing definition here? 

The SRIOV model has the HW register programming API is device
specific.

The switchdev model is: no matter what HW register programing is done
on the VF/SF all the packets tx/rx'd will flow through the switchdev.

The purpose of switchdev/SRIOV/SIOV has never been to define a single
"one register set to rule them all".

That is the area that VDPA virtio-net and others are covering.

Jason
