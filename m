Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64954442C5D
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 12:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhKBLWD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Nov 2021 07:22:03 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:27097 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhKBLWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 07:22:03 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Hk6nB4Z0gz1DHmR;
        Tue,  2 Nov 2021 19:17:18 +0800 (CST)
Received: from kwepemm000015.china.huawei.com (7.193.23.180) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 2 Nov 2021 19:19:22 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 kwepemm000015.china.huawei.com (7.193.23.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 2 Nov 2021 19:19:21 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.015; Tue, 2 Nov 2021 11:19:18 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>
Subject: RE: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Thread-Topic: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Thread-Index: AQHXxNiJ5sEZ2IosYUWOFwYUAR8/1avamBEAgAALEACAABqtAIAAIxaAgACddACAAIzwAIAAI2+AgAAjt4CAANCrAIAAzO+AgAWtdwCAACFWgIAAB8UAgAGOQwCAAAo+gIAAS/kAgABA4gCAAUTBAIAABSWAgAFRMICAAIruAIABdfqAgAR5LQCAAPvA4A==
Date:   Tue, 2 Nov 2021 11:19:18 +0000
Message-ID: <d3a4eefb5b3c43ef9b151583f5c8a9ba@huawei.com>
References: <20211025145646.GX2744544@nvidia.com>
 <20211026084212.36b0142c.alex.williamson@redhat.com>
 <20211026151851.GW2744544@nvidia.com>
 <20211026135046.5190e103.alex.williamson@redhat.com>
 <20211026234300.GA2744544@nvidia.com>
 <20211027130520.33652a49.alex.williamson@redhat.com>
 <20211027192345.GJ2744544@nvidia.com>
 <20211028093035.17ecbc5d.alex.williamson@redhat.com>
 <20211028234750.GP2744544@nvidia.com>
 <20211029160621.46ca7b54.alex.williamson@redhat.com>
 <20211101172506.GC2744544@nvidia.com>
In-Reply-To: <20211101172506.GC2744544@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.87.75]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> Sent: 01 November 2021 17:25
> To: Alex Williamson <alex.williamson@redhat.com>; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: Cornelia Huck <cohuck@redhat.com>; Yishai Hadas <yishaih@nvidia.com>;
> bhelgaas@google.com; saeedm@nvidia.com; linux-pci@vger.kernel.org;
> kvm@vger.kernel.org; netdev@vger.kernel.org; kuba@kernel.org;
> leonro@nvidia.com; kwankhede@nvidia.com; mgurtovoy@nvidia.com;
> maorg@nvidia.com; Dr. David Alan Gilbert <dgilbert@redhat.com>
> Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
> for mlx5 devices
> 
> On Fri, Oct 29, 2021 at 04:06:21PM -0600, Alex Williamson wrote:
> 
> > > Right now we are focused on the non-P2P cases, which I think is a
> > > reasonable starting limitation.
> >
> > It's a reasonable starting point iff we know that we need to support
> > devices that cannot themselves support a quiescent state.  Otherwise it
> > would make sense to go back to work on the uAPI because I suspect the
> > implications to userspace are not going to be as simple as "oops, can't
> > migrate, there are two devices."  As you say, there's a universe of
> > devices that run together that don't care about p2p and QEMU will be
> > pressured to support migration of those configurations.
> 
> I agree with this, but I also think what I saw in the proposed hns
> driver suggests it's HW cannot do quiescent, if so this is the first
> counter-example to the notion it is a universal ability?
> 
> hns people: Can you put your device in a state where it is operating,
> able to accept and respond to MMIO, and yet guarentees it generates no
> DMA transactions?

AFAIK, I am afraid we cannot guarantee that as per our current implementation.
At present in !RUNNING state we are putting the device in to a PAUSE state so it
will complete the current request and keep the remaining ones in queue. But it can
still receive a new request which will trigger the PAUSE state exit and resume the
operation.

So I guess, it is possible to corrupt the migration if user space misbehaves.

Thanks,
Shameer

