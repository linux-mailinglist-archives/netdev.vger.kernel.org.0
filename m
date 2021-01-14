Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36A02F698D
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbhANSaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:30:30 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12721 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbhANSa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 13:30:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60008d9c0000>; Thu, 14 Jan 2021 10:29:48 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 14 Jan
 2021 18:29:47 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 14 Jan 2021 18:29:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DN/Ww9VB0Fsa8k482INqWwSg4wMJm3YgAu2b/hOAEFoKSYGFmpIrsm5KIhNgPhq/XKier6iMeeJx+NUmBjJakYCQ+9R9RvJa0WVuSfERI1/U8vN3hWNTIKG56Tlep+hhjuv6dVwAUupeLusNNfj6g4OFtfY5zRAsnFNqYnii2/PFJ4oEEEhN0sZ5FlG7Nv82Xqm5oDVhJiCU8P1rS/FB0MdgQA5eISAyNrUrY2jyiue9WdFukiPmeoLu8Au7txmyR8WGh8H4BdlF3b4CEYaXYsobMSeBXCebjgYlCJgQylCUm7kYL2w2rdXhoyRB4VBu/zzmG5Cj9iMmvXdl8hGZ7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wrf3nTZDCSV33tsOoxzZns6XNlveD8eoEEhs1l6NUXs=;
 b=n1ZVn3BIyj9KMyefdu+D7s0aG3OFkE3x+hhVHIwP9v4zrMQb0UHpsHnhG2wzE6Vaqs2EbP/z3VZ2/uHhho+wfJSp7Cal7e1v8R4UTKeZsYx1GZSGkbcN/HNHMgJU8Y9Zyc28JXSf6386gB6OUxkrCuxsFa6qkA/ykzp3ig9D+d2Se2G5q3kLloO9+rCnCuc4W89rVos73eG1LuMXWKSrZwrDgzqzLNXZIjUsg3f0McyXdp67Nu2PgOkDByW/k3yD0s64BlpjkQnffpBkel2Q//A/W7s5hlEGCv1l+6c7OIvbl9sz2kl4XzGC9zE2yLRFvyJDf1OTaoWecw3GD/pS/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3836.namprd12.prod.outlook.com (2603:10b6:5:1c3::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 14 Jan
 2021 18:29:46 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 18:29:46 +0000
Date:   Thu, 14 Jan 2021 14:29:45 -0400
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
Message-ID: <20210114182945.GO4147@nvidia.com>
References: <20210110150727.1965295-3-leon@kernel.org>
 <CAKgT0Uczu6cULPsVjFuFVmir35SpL-bs0hosbfH-T5sZLZ78BQ@mail.gmail.com>
 <20210112065601.GD4678@unreal>
 <CAKgT0UdndGdA3xONBr62hE-_RBdL-fq6rHLy0PrdsuMn1936TA@mail.gmail.com>
 <20210113061909.GG4678@unreal>
 <CAKgT0Uc4v54vqRVk_HhjOk=OLJu-20AhuBVcg7=C9_hsLtzxLA@mail.gmail.com>
 <20210114065024.GK4678@unreal>
 <CAKgT0UeTXMeH24L9=wsPc2oJ=ZJ5jSpJeOqiJvsB2J9TFRFzwQ@mail.gmail.com>
 <20210114164857.GN4147@nvidia.com>
 <CAKgT0UcKqt=EgE+eitB8-u8LvxqHBDfF+u2ZSi5urP_Aj0Btvg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKgT0UcKqt=EgE+eitB8-u8LvxqHBDfF+u2ZSi5urP_Aj0Btvg@mail.gmail.com>
X-ClientProxiedBy: MN2PR07CA0025.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::35) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR07CA0025.namprd07.prod.outlook.com (2603:10b6:208:1a0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 18:29:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l07NR-001Lsk-6u; Thu, 14 Jan 2021 14:29:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610648988; bh=Wrf3nTZDCSV33tsOoxzZns6XNlveD8eoEEhs1l6NUXs=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=LPkDjE0CrnO76+iYFJ4C/TEF5Fy3kO6gNK339REzXGHkP8UW1RKwJKqdXty9x4BuX
         I9p7qOAM1mRjdpRmLQcgAg1MocjzjDF5b09jQbpCSzBnqx9wmz12DgDUSKC81/Qxpb
         xu+AH79nMhB1H07SX1v1KnwCXim+klfVOXxltk1VsoVsy6aoXMU4NFqwFPovNqAkXv
         op7HQgaLhda3d7bLrg68Uz6YkFBD2h5OPWgHDifmf02GdwrAcx8q27QEDv6Q8dcyA7
         BhprjCoOZBmYgfxenWNQttgVLApEBIr2n5TZifxKZNXOOh/nyT6BjKxwdlsCSRoN1d
         QZre90+6Dodmg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 09:55:24AM -0800, Alexander Duyck wrote:
> On Thu, Jan 14, 2021 at 8:49 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Thu, Jan 14, 2021 at 08:40:14AM -0800, Alexander Duyck wrote:
> >
> > > Where I think you and I disagree is that I really think the MSI-X
> > > table size should be fixed at one value for the life of the VF.
> > > Instead of changing the table size it should be the number of vectors
> > > that are functional that should be the limit. Basically there should
> > > be only some that are functional and some that are essentially just
> > > dummy vectors that you can write values into that will never be used.
> >
> > Ignoring the PCI config space to learn the # of available MSI-X
> > vectors is big break on the how the device's programming ABI works.
> >
> > Or stated another way, that isn't compatible with any existing drivers
> > so it is basically not a useful approach as it can't be deployed.
> >
> > I don't know why you think that is better.
> >
> > Jason
> 
> First off, this is technically violating the PCIe spec section 7.7.2.2
> because this is the device driver modifying the Message Control
> register for a device, even if it is the PF firmware modifying the VF.
> The table size is something that should be set and fixed at device
> creation and not changed.

The word "violating" is rather an over-reaction, at worst this is an
extension.

> The MSI-X table is essentially just an MMIO resource, and I believe it
> should not be resized, just as you wouldn't expect any MMIO BAR to be
> dynamically resized. 

Resizing the BAR is already defined see commit 276b738deb5b ("PCI:
Add resizable BAR infrastructure")

As you say BAR and MSI vector table are not so different, it seems
perfectly in line with current PCI sig thinking to allow resizing the
MSI as well

> Many drivers don't make use of the full MSI-X table nor do they
> bother reading the size. We just populate a subset of the table
> based on the number of interrupt causes we will need to associate to
> interrupt handlers. 

This isn't about "many drivers" this is about what mlx5 does in all
the various OS drivers it has, and mlx5 has a sophisticated use of
MSI-X.

> What I see this patch doing is trying to push driver PF policy onto
> the VF PCIe device configuration space dynamically.

Huh? This is using the PF to dynamically reconfigure a child VF beyond
what the PCI spec defined. This is done safely under Linux because no
driver is bound when it is reconfigured, and any stale config data is
flushed out of any OS caches.

This is also why there is not a strong desire to standardize an ECN at
PCI-sig, the rules for how resizing can work are complicated and OS
specific.

> Having some limited number of interrupt causes should really be what
> is limiting things here. 

MSI inherently requires dedicated on-die resources to implement, so
every device has a maximum # of MSI vectors it can currently
expose. This is some consequence of various PCI rules and applies to
all devices.

To make effective use of this limited pool requires a hard restriction
enforced by the secure domain (hypervisor and FW) onto every
user. Every driver attached to the function needs to be aware of the
hard enforced limit by the secure domain to operate properly. It has
nothing to do with "limited number of interrupt causes".

The standards based way to communicate that limit is the MSI table cap
size.

To complain that changing the MSI table cap size dynamically is
non-standard then offer up a completely non-standard way to operate
MSI instead seems to miss the entire point.

The important standard is to keep the PCI config space acting per-spec
so all the various consumers can work as-is. The extension is to only
modify the rare hypervisor to support a dynamic MSI resizing extension
for VFs.

As far as applicability, any device working at high scale with MSI and
VMs is going to need this. Dynamically assigning the limited MSI HW is
really required to support the universe of VM configurations people
want. eg generally I would expect a VM to receive the number of MSI
vectors equal to the number of CPUs the VM gets.

> I see that being mostly a thing between the firmware and the VF in
> terms of configuration and not something that necessarily has to be
> pushed down onto the PCIe configuration space itself.

If mlx5 drivers had been designed long ago to never use standard based
MSI and instead did something internal with FW you might have a point,
but they weren't. All the mlx5 drivers use standards based MSI and
expect the config space to be correct.

Jason
