Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56D930C75A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbhBBRSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:18:36 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9686 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237359AbhBBRPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 12:15:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601988990000>; Tue, 02 Feb 2021 09:15:05 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 17:15:04 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 17:14:58 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 2 Feb 2021 17:14:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZY4wfd3RcD16qODVhstTCzCDCyx7n6Lc6wYzaxdM9yoknpaSKT3ZHREp71pleRWUafXgoOEGStabkMhB0WtHmRFo0kaQem7+rdWPk6lfgl54RqmHOak3aXMhAvP+Ks21+G1cZWhAEOYHFsKNjV6L5ntwIXl6tnNE9kt9xMNyOVdAOo/pmdtn8fLNOSgHR4XZbEbaUzVCB5fkFVezDJKzWtouDfsBr3XOkH1upX1nq7upQwx9UAyUMDGg3StufVtqTmMXsmI209CDEKyMrOHNwkQ0hibgFGyvPbPAVHwU0NphEnOaw0vdMh1SLN3wHH83PRvhBuaKXEDuOUjmZ4lW2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFWeLPdexSpoMRDUFwjP/3U5BhaEi9T3Yh6avk+uA+w=;
 b=bdXOTJvEri2vX71lTgpx38iAIWosQzhyID5WgB9wR1f56QsmXGp2OsI1/T4pY9cGcU+ArCzzV5G1mrdmpPLnwlOg/eY1YqY8wwcuo+I0sQ2ThfdL7vY2s+1U+2eu2vg7rF/rI88REDLdEN3K4l6DGd+KNxLMnJEM5/p9aTJP9yWdydfzExjF7mSj1di+X+IxZ8NacCsYFH2jOHUxoWYMQNOsrOAqft7oJQmh9QukO6Z96tjGCc+dduHzMMvh963LuiydnZXsEBQL2ZbJUATLz88iXtE7b2JpXttzUfHbBu2GGRdAyIzPlR0r2m8xWf8T6n1mW+BmAH3gpfF6Hvaeyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4451.namprd12.prod.outlook.com (2603:10b6:5:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Tue, 2 Feb
 2021 17:14:55 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3805.025; Tue, 2 Feb 2021
 17:14:55 +0000
Date:   Tue, 2 Feb 2021 13:14:54 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dan Williams <dan.j.williams@intel.com>
CC:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210202171454.GX4247@nvidia.com>
References: <20210126005928.GF4147@nvidia.com>
 <031c2675aff248bd9c78fada059b5c02@intel.com>
 <20210127121847.GK1053290@unreal>
 <ea62658f01664a6ea9438631c9ddcb6e@intel.com>
 <20210127231641.GS4147@nvidia.com> <20210128054133.GA1877006@unreal>
 <d58f341898834170af1bfb6719e17956@intel.com>
 <20210201191805.GO4247@nvidia.com>
 <925c33a0b174464898c9fc5651b981ee@intel.com>
 <CAPcyv4gbW-27ySTmxf97zzcoVA_myM8uLV=ziscMuSKGBz7dqg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAPcyv4gbW-27ySTmxf97zzcoVA_myM8uLV=ziscMuSKGBz7dqg@mail.gmail.com>
X-ClientProxiedBy: MN2PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:208:d4::14) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR04CA0001.namprd04.prod.outlook.com (2603:10b6:208:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Tue, 2 Feb 2021 17:14:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l6zGQ-002cWt-8J; Tue, 02 Feb 2021 13:14:54 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612286105; bh=VFWeLPdexSpoMRDUFwjP/3U5BhaEi9T3Yh6avk+uA+w=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=dk6rKSEbb4BAKPnM9WyZOfedxViMOh+uS5rKLCGXmchYIZ7AoPCLkMFw9AJjfrYqX
         +zoDxb4Eyo4EF4uM+z4hKLD1U6t8N91KyOpP0lak3oqwYqkktUNJccwBukjRD7f1wj
         DgerNdOqzheGBnuiWcyzoYklDwNeAAtSUogz1u+aAnYqi5X6waW3t9Kuf+ahnItXv0
         nj8pLhBCAXSs4NbA3drhdIzw9cQZ8vxwTRpOFtcE6hs7yIroLFzDZ6V2G3y7tdABmN
         NOZSF3i0BbxZ7IPejBhCrnzTCd49WBpeH4bfDD3yf1vFRMRwnEodWIoXlcP64VoBhV
         EHre/1Dz/ADIg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 05:06:58PM -0800, Dan Williams wrote:
> On Mon, Feb 1, 2021 at 4:40 PM Saleem, Shiraz <shiraz.saleem@intel.com> wrote:
> >
> > > Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> > > implement private channel OPs
> > >
> > > On Sat, Jan 30, 2021 at 01:19:36AM +0000, Saleem, Shiraz wrote:
> > > > > Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver
> > > > > and implement private channel OPs
> > > > >
> > > > > On Wed, Jan 27, 2021 at 07:16:41PM -0400, Jason Gunthorpe wrote:
> > > > > > On Wed, Jan 27, 2021 at 10:17:56PM +0000, Saleem, Shiraz wrote:
> > > > > >
> > > > > > > Even with another core PCI driver, there still needs to be
> > > > > > > private communication channel between the aux rdma driver and
> > > > > > > this PCI driver to pass things like QoS updates.
> > > > > >
> > > > > > Data pushed from the core driver to its aux drivers should either
> > > > > > be done through new callbacks in a struct device_driver or by
> > > > > > having a notifier chain scheme from the core driver.
> > > > >
> > > > > Right, and internal to driver/core device_lock will protect from
> > > > > parallel probe/remove and PCI flows.
> > > > >
> > > >
> > > > OK. We will hold the device_lock while issuing the .ops callbacks from core
> > > driver.
> > > > This should solve our synchronization issue.
> > > >
> > > > There have been a few discussions in this thread. And I would like to
> > > > be clear on what to do.
> > > >
> > > > So we will,
> > > >
> > > > 1. Remove .open/.close, .peer_register/.peer_unregister 2. Protect ops
> > > > callbacks issued from core driver to the aux driver with device_lock
> > >
> > > A notifier chain is probably better, honestly.
> > >
> > > Especially since you don't want to split the netdev side, a notifier chain can be
> > > used by both cases equally.
> > >
> >
> > The device_lock seems to be a simple solution to this synchronization problem.
> > May I ask what makes the notifier scheme better to solve this?
> >
> 
> Only loosely following the arguments here, but one of the requirements
> of the driver-op scheme is that the notifying agent needs to know the
> target device. With the notifier-chain approach the target device
> becomes anonymous to the notifier agent.

Yes, and you need to have an aux device in the first place. The netdev
side has neither of this things. I think it would be a bit odd to have
extensive callbacks that are for RDMA only, that suggests something in
the core API is not general enough.

Jason
