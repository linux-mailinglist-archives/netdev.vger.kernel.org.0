Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F8B2F7D2A
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 14:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731149AbhAONvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 08:51:48 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3096 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727719AbhAONvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 08:51:47 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60019dca0000>; Fri, 15 Jan 2021 05:51:06 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 Jan
 2021 13:51:05 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 15 Jan 2021 13:51:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fp4P7pWOI6zIblMTlm0C3O64C1fipUCJrVf3UqZEkyixfKygYry2zdZtf4AC/3v25Vj9617NeloAllNBZZXYLWcgowsVppJIkMLK3btLrB6Jh8HJPJHiGfrHIavBq8QYENQZLRLbRG/QLEfYQ6jcleYRkKnL3iNqpZ2N3dLFTNzQEpbWygxKrMCORoLKr29Rgwa4LMJPSctPxevhbWGfQHstVPAtlDocT/uLJiKnYMHOA569uPAnUZ1GhSALQSVGBYrwTKnonMlGykuk3gQiBL7wSUzEPqLZkKRqNUMtTSwhuSPH+/T1xPyQInQQyupwTIkm7MpPdTdZHPsNL4zD7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMpK4w50/w9wRjGK2OnyygB3HriB2HHlDcshwBA3+kI=;
 b=iPT/yQKt48T5NXeyH/6il5ZwCwzjwY74s7nh39o8t+3o48Pzk+oKdMktUFHiCVGGm5RjHI00Uj22wZte39MhkIQEAorOLXegHzuLaWr1RfhXrUJF/dnFbKn3mgflr7wTz0ppy59frbZERvO0YV51XGj7U2EQ+deNyqQHVOJAlXqE2jmT1kgpqDwi/F7mL1RWX2GJMHyBCeZ5bqWxVtX/0SbnuhW2JPyIt1gxKKM5622L+D0zXX2ZkWlq3G7vZoPK1Cx3QBwZT+cPnZ09XKZ4rkoQ3bv27QKC5zy+a29U5LBdn3avZFeVf7+KXTeekT8o/BKN2f08Wx6nTld938VFbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2440.namprd12.prod.outlook.com (2603:10b6:4:b6::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 13:51:03 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 13:51:03 +0000
Date:   Fri, 15 Jan 2021 09:51:01 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
Message-ID: <20210115135101.GZ4147@nvidia.com>
References: <20210113061909.GG4678@unreal>
 <CAKgT0Uc4v54vqRVk_HhjOk=OLJu-20AhuBVcg7=C9_hsLtzxLA@mail.gmail.com>
 <20210114065024.GK4678@unreal>
 <CAKgT0UeTXMeH24L9=wsPc2oJ=ZJ5jSpJeOqiJvsB2J9TFRFzwQ@mail.gmail.com>
 <20210114164857.GN4147@nvidia.com>
 <CAKgT0UcKqt=EgE+eitB8-u8LvxqHBDfF+u2ZSi5urP_Aj0Btvg@mail.gmail.com>
 <20210114182945.GO4147@nvidia.com>
 <CAKgT0UcQW+nJjTircZAYs1_GWNrRud=hSTsphfVpsc=xaF7aRQ@mail.gmail.com>
 <20210114200825.GR4147@nvidia.com>
 <CAKgT0UcaRgY4XnM0jgWRvwBLj+ufiabFzKPyrf3jkLrF1Z8zEg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKgT0UcaRgY4XnM0jgWRvwBLj+ufiabFzKPyrf3jkLrF1Z8zEg@mail.gmail.com>
X-ClientProxiedBy: BL0PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:208:91::33) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR05CA0023.namprd05.prod.outlook.com (2603:10b6:208:91::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.6 via Frontend Transport; Fri, 15 Jan 2021 13:51:03 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l0PVF-001d2B-1s; Fri, 15 Jan 2021 09:51:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610718666; bh=VMpK4w50/w9wRjGK2OnyygB3HriB2HHlDcshwBA3+kI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=VzG2FySHRa+gWAieS+V+HMjnjYpEvg2ImXpNYMFp3HMrsPeVtVmPwJAfZp3UilSiC
         0TcXXRaflAgWM2w4641VBylWEmTtWssjc6S1IWJwE+6PAE8w2L5XbxaMKx9ZsM6Xdn
         tWQhKOSCWEJ0ot6eDp9ct256uBlH/9lJ+RBDC4PXQlEj1Noh6fIYFHru4gz6k0P90u
         VzLkgf+W7jyP4MDEru+OOSErSEmpTRlLZAVRvkffvZXrcM6GfIY1szDhgIXsN/oeA7
         YzwXrptKrlcUCVw88FhdIYfmgvQ+FOTF14hjQGWoVyubgjStrSz6/+MJaVazlyX978
         axzKTJHyK4+Ew==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 01:43:57PM -0800, Alexander Duyck wrote:

> > > In addition Leon still hasn't answered my question on preventing the
> > > VF driver from altering entries beyond the ones listed in the table.
> >
> > Of course this is blocked, the FW completely revokes the HW resource
> > backing the vectors.
> 
> One of the troubles with this is that I am having to take your word
> for it.

This is a Linux patch review, not a security review of a HW
implementation. There are million ways to screw up a PCI device
implementation and in SRIOV the PCI device HW implementation forms
part of the trust base of the hypervisor.

If the HW API can be implemented securely and the Linux code is
appropriate is the only question here.

In this case mlx5 HW is implemented correctly and securely, if you
don't belive then you are free not to use it.

> What it defines is the aperture available in MMIO to define the
> possible addresses and values to be written to trigger the
> interrupts. The device itself plays a large role in defining the
> number of interrupts ultimately requested.

Again you are confused about what is going on here - this is about
reconfiguring the HW so that MSI vector entries exist or not - it has
absoultely nothing to do with the driver. We are not optimizing for
the case where the driver does not use MSI vectors the VF has
available.

> > > At a minimum I really think we need to go through and have a clear
> > > definition on when updating the MSI-X table size is okay and when it
> > > is not. I am not sure just saying to not update it when a driver isn't
> > > attached is enough to guarantee all that.
> >
> > If you know of a real issue then please state it, other don't fear
> > monger "maybe" issues that don't exist.
>
> Well I don't have visibility into your firmware so I am not sure what
> is going on in response to this command so forgive me when I do a bit
> of fear mongering when somebody tells me that all this patch set does
> is modify the VF configuration space.

You were not talking about the FW, "is okay and when it is not" is a
*Linux* question.

> > > What we are talking about is the MSI-X table size. Not the number of
> > > MSI-X vectors being requested by the device driver. Those are normally
> > > two seperate things.
> >
> > Yes, table size is what is critical. The number of entries in that BAR
> > memory is what needs to be controlled.
> 
> That is where we disagree. 

Huh? You are disagreeing this is how the mlx5 device works?

> Normally as a part of that the device itself will place some
> limit on how many causes and vectors you can associate before you even
> get to the MSI-X table.

For mlx5 this cause limit is huge. With IMS it can even be higher than
the 2K MSI-X limit. Remember on an x86 system you get 256 interrupt
vectors per CPU *and* per vCPU, so with interrupt remapping there can
be huge numbers of interrupts required.

Your "normally" is for simplistic fixed function HW devices not
intended for use at this scale.

> The MSI-X table size is usually a formality that defines the upper
> limit on the number of entries the device might request.

It is not a formality. PCI rules require *actual physical HW* to be
dedicated to the MSI vector entries.

Think of it like this - the device has a large global MSI-X table of
say 2K entires. This is the actual physical HW SRAM backing MSI
entires required by PCIe.

The HW will map the MSI-X table BAR space in every PF/VF to a slice of
that global table. If the PCI Cap says 8 entries then the MSI-X page has
only 8 entries, everything else is /dev/null.

Global MSI entries cannot be shared - the total of all PF/VFs cap
field must not be more than 2K.

One application requires 2K MSI-X on a single function because it uses
VDPA devices and VT-d interrupt remapping

Another application requires 16 MSI-X on 128 VFs because it is using
SRIOV with VMs having 16 vCPUs.

The HW is configured differently in both cases. It is not something
that can be faked with VFIO!

> > That is completely different, in the hypervisor there is no idea how
> > many vectors a guest OS will create. The FW is told to only permit 1
> > vector. How is the guest to know this if we don't update the config
> > space *as the standard requires* ?
> 
> Doesn't the guest driver talk to the firmware? Last I knew it had to
> request additional resources such as queues and those come from the
> firmware don't they?

That is not how things work. Because VFIO has to be involved in
setting up interrupt remapping through its MSI emulation we don't get
to use a dynamic FW only path as something like IMS might imagine.

That would be so much better, but lots of things are not ready for
that.

> > 1) The FW has to be told of the limit and everything has to be in sync
> >    If the FW is out of sync with the config space then everything
> >    breaks if the user makes even a small mistake - for instance
> >    forgetting to use the ioctl to override vfio. This is needlessly
> >    frail and complicated.
> 
> That is also the way I feel about the sysfs solution.

Huh? The sysfs is much safer. If the write() succeeds I can't think of
any way the system would be left broken? Why do you think it is frail?

> I'm just kind of surprised the firmware itself isn't providing some
> sort of messaging on the number of interrupt vectors that a given

It does, it is the PCI cap, just because you keep saying it isn't used
doesn't make that true :)

> device has since I assume that it is already providing you with
> information on the number of queues and such since that isn't
> provided by any other mechanism.

Queues are effectively unlimited.

Jason
