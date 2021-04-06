Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5A1355602
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 16:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344870AbhDFOEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 10:04:51 -0400
Received: from mail-bn8nam12on2088.outbound.protection.outlook.com ([40.107.237.88]:60801
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244358AbhDFOEt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 10:04:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4w2T+pSAUI07YagG9WUxw6NZiSPhx0uwJxxep3f1q+Ot7bMHua40JJjlCWGmMC1BWwEMNpTqXIxc/K4AjDaQ+EVuQLpDH7QxSq+8YgbhrqWHl5+ng41iEHRNCjr+xELItNSH9D51ttYtqClT+lBEfMPKLwCANXH5VebT4fgNynE0pl172MRdCnEFWfCH2v67zeQT3oSvADZJ/0pUDb2Lq7Wp59ZxZla33Has9JYWMzmQdeI9rUaBJAT5FizU3145vO7l46edy7UbtoobmW7Ohd/EIXOFs9yfQWO+iwG1L7tQ7mv2wSnGvvj7+a9vWOMNEGhs25e89gMA2hrUPIQ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+NCxw+OIncMmFrtOkLqEGWY8VswashAmIcwn6Xqgz6Y=;
 b=V2VWc8H5+1rZMUgKpHRobS3SfYtQ+13GaQ+mtLJsQYMAVF55kvav3+McFyN/Dpq0CBAKKTcejcrF8kzcTzHijbNNIr2RorPWkpcPcUSG9lZ2RphTz2JlZdxN4XPe7uamNz+CqHsbs0f7txoDXvclf1Q26h2+IEOyCAu1oTw2AU/k9MjEjFWjIRVjWjsLvsLF3skVvxVd12NyT5iDiqACaiz+PNj0Z5FgtGpdnX25AZ/MGVePlsbZKmPinUUUBwIlLuM1oot+mab7t0AjbEs0GzM2nCxO9p1KvLnJlYg7hASlu+wRMfj1cA9fkH1XBTzl1QVtrXcdQZH209uxHcAQ1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+NCxw+OIncMmFrtOkLqEGWY8VswashAmIcwn6Xqgz6Y=;
 b=Wxrkp+V28kwFaszDMa3YM2kB5u1JlPMloccg1O1lXcLexIvgYmrlhQuaT8W+dfTmxA6k0Ksrb6jOm76evCPnpO5+CAuh9dwXcQnrtOEYlKGZLNwOgQ73TBQqKM9SYmvQOVokkLqN3JuCQ8Z1h0XpjxcgfdSTBDO5UoHxZWS3/gmrC8iN0grVMGX4PoKXsmKG4q6nsQl4+r3xdc9ZkTx6y5UuzrOjztNNUJybNe2BtgjrZDwN7eIl11jcqnBusL3+JKG2VHIMVz0zcl1QBKfu4h4GqHHxdIarSbFM3uswchawEzSvUU8jac9SpDkZwZsBaeuv+xJiB945PQGj0zF10Q==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4009.namprd12.prod.outlook.com (2603:10b6:5:1cd::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Tue, 6 Apr
 2021 14:04:39 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 14:04:39 +0000
Date:   Tue, 6 Apr 2021 11:04:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        rds-devel@oss.oracle.com, Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next 01/10] RDMA: Add access flags to ib_alloc_mr()
 and ib_mr_pool_init()
Message-ID: <20210406140437.GR7405@nvidia.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405052404.213889-2-leon@kernel.org>
 <c21edd64-396c-4c7c-86f8-79045321a528@acm.org>
 <YGvwUI022t/rJy5U@unreal>
 <20210406052717.GA4835@lst.de>
 <YGv4niuc31WnqpEJ@unreal>
 <20210406121312.GK7405@nvidia.com>
 <20210406123034.GA28930@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406123034.GA28930@lst.de>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR01CA0060.prod.exchangelabs.com (2603:10b6:208:23f::29)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR01CA0060.prod.exchangelabs.com (2603:10b6:208:23f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Tue, 6 Apr 2021 14:04:38 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTmJp-0018WQ-42; Tue, 06 Apr 2021 11:04:37 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9666134b-a6ef-4bab-f1b0-08d8f904eaa5
X-MS-TrafficTypeDiagnostic: DM6PR12MB4009:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB400968ED4A044BBD601B3A53C2769@DM6PR12MB4009.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oir2KNkxC4+RJLKSNtlsbMNk/KzWtf8dJK7Y8l5w0Qcs6cvzRcx3t2x/bFOgK6LZbuv0w4kSqTMMPrwu3r0sZ0fYj6CNk1FbnN2ApJ30pX5ux0g16Z3XLMXvVvkfbkvASHQf/PO2pWfZYGA4ciY2W/Q7k6Fl4I5EMQYoARoxYEHEEl4GEbbaVjgGuS2MBMUlqgaBPJHr1XUHx8F4Vjt0RBqnmzpuAQ/BcUId9MNhH9rY3k7kmBuvmdMmaKN+lBFcnsy1FO3l/vqE3N6SE2lXp8lB0guIVJz5glbXCvHwJvhWWZMotj02SoN7VNLQ9T6vy9B1t5/Objdt1/FUOAi1IAT4J3lQ4M5nZ15cmruegLU0mXP86L8r6FHVk6Ga5ihsu0YyR1uKhYpVDqUSHX3FLpEJliPsFsL1s8O2KuRiKC8V7SYqSDZORIdKuwMyK3Sww+eYVRzEORMSY8sE/ULyZhhzmjU7THhFD8Wl4KlsWGWIdGPixWdTFQ3pPPGd+0KSu5twvrtjVIjoeV4JSC1Am9brY935sfHboLDhMnFw/I18OnID/L3wqRjHXrrpLwbsz55wH/FCB/MChAvptdE1V26ruRt2vBEZlwNLpNoOW3XJUENBGnhUad//qV/VO3HErpVB6ihHFqh01I38gFFKKCrfM3NKJISxmK0LDDnkkmY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(2906002)(2616005)(186003)(54906003)(316002)(478600001)(36756003)(26005)(8936002)(426003)(83380400001)(9786002)(6916009)(38100700001)(66556008)(1076003)(8676002)(7406005)(66946007)(66476007)(9746002)(86362001)(7416002)(33656002)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GEKl4aWIza5J38UrYOi6SUHm+34yL08mSMQXeuVXE75144w0Gyzl6V61/VT4?=
 =?us-ascii?Q?ENiFRQ3gMoTR8t7nS3AA1Bkaw9r4pHEMuQgfPcCFP84lePUOpLSQ0lLLvjHW?=
 =?us-ascii?Q?qymi/w6Gnz+HczynPyHBEAr0URhbY2LYEWfURRyQTlkm9I/9e6QFaHqOYguc?=
 =?us-ascii?Q?v0nh2tJVGL+g3K/Ly1MxwUgKunFqInonGI7INtGOWFY5DLATepJwXLx58q2z?=
 =?us-ascii?Q?Nj6CpVHbgoC/bwlbgqMRLHKCWdOHF0x4UmkxmaPM3i8QMDnnFx35Sgf0BLv6?=
 =?us-ascii?Q?3LnO5dZe3nai+CfpBPN0z2M894Wlc88BdvXl5FRj/Yw5KoyyDWQp+jV8d0w5?=
 =?us-ascii?Q?cjvoENSGp7MSoidX0DUJTT5Wk/SNjUWUME6aQwesZkg8SuNCKfrF4Jv2vi1N?=
 =?us-ascii?Q?OjTXJyBUtL97Cc556FQ3T+K8qzCYDM6Lh/uAf9pSP8WVCr6Vlk6DGzjxAxvt?=
 =?us-ascii?Q?+9SOv4JyEms4e0ybTqvXU97I39JLXvW6F8vWUdF08uHMKI0DW73BTD076wmp?=
 =?us-ascii?Q?TSrgT3wplQWCdIKF7GPsjuTdTfuUw3i56zaljvwILznHidcJ8njjEGj5NsQv?=
 =?us-ascii?Q?7USnX+lgr0aFt0gNZT/qlgaQHKtKchpg5YYzxX0EzlJeqLpaDbxaKlI4/oym?=
 =?us-ascii?Q?JDT5oozke+nJtkZzGGoAim+WWFx/vtDyOWK7kDjgSidedlWDIH4imEtD8JJp?=
 =?us-ascii?Q?17H60QScEISWBr3dlqioTLy2JLPNOR4iS8MMKnF717SXISmThcAiSqHhAlJP?=
 =?us-ascii?Q?71HgHhbkD5gOBedkRMSlUqG6J1WnKrr5eZaUDnZPxHjS+RueaKcDW/8yQEG6?=
 =?us-ascii?Q?vuAUIhaRwN9IfoXWUyIQ8v/p+kUmY7n3vbTgtpjl7hUW4miFYccSSGN02NZ0?=
 =?us-ascii?Q?tuZSs/xtn1PMeEwStp939RySbMQlOclLWYbIyyHV2672s2M6PXByi5uiVqit?=
 =?us-ascii?Q?HTjq6v5ywahp6KWJjQlGKtq35OlQTIwJWKD6mPM21reqOt/+ifYEPtL1Vg2U?=
 =?us-ascii?Q?/Etmaq/Q5ngkIZWFX0/v6Vt0EtWL8V0i2fFgDmDmRB38YcH/cLy1u+FHWgOs?=
 =?us-ascii?Q?qK4tOznMyNFjq12urC9QevHnWBNx9KtBkF9MpvDx0BVkBOTmkJlNHwuynXjF?=
 =?us-ascii?Q?elIe8eb9ZbcHMK6gNqBdopg2qg/nKAbBNbFp4vB448dNv77elYTPKPyuSTCt?=
 =?us-ascii?Q?EdC4TYHwdnCKxT6jH2s4LpmGWCSLQbTwppurSZ6PpsTS9N4HdD3qQFfr0yBn?=
 =?us-ascii?Q?m/q7oRoJmMKW8tWHlZ5R+5DQDdhr3ZTm99eYipI7bWOOC/frZp0AJvqKNz+8?=
 =?us-ascii?Q?YeKj+XHsLHutAM5JMlysgdhMNwmxkdJZpS5gzZdn4IqBPg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9666134b-a6ef-4bab-f1b0-08d8f904eaa5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 14:04:39.1730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UuhyL1SDrVYoW1X9AdeYVvEJYVbB+sAfLob+VyaMT/bnfT6Eyujn62GOymm95Qqi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4009
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 02:30:34PM +0200, Christoph Hellwig wrote:
> On Tue, Apr 06, 2021 at 09:13:12AM -0300, Jason Gunthorpe wrote:
> > So we broadly have two choice
> >  1) Diverge the kernel and user interfaces and make the RDMA drivers
> >     special case all the kernel stuff to force
> >     ACCESS_RELAXED_ORDERING when they are building MRs and processing
> >     FMR WQE's
> >  2) Keep the two interfaces the same and push the
> >     ACCESS_RELAXED_ORDERING to a couple of places in the ULPs so the
> >     drivers see a consistent API
> > 
> > They are both poor choices, but I think #2 has a greater chance of
> > everyone doing their parts correctly.
> 
> No, 1 is the only sensible choice.  The userspace verbs interface is
> a mess and should not inflict pain on the kernel in any way.  We've moved
> away from a lot of the idiotic "Verbs API" concepts with things like
> how we handle the global lkey, the new CQ API and the RDMA R/W
> abstraction and that massively helped the kernel ecosystem.

It might be idiodic, but I have to keep the uverbs thing working
too.

There is a lot of assumption baked in to all the drivers that
user/kernel is the same thing, we'd have to go in and break this.

Essentially #2 ends up as deleting IB_ACCESS_RELAXED_ORDERING kernel
side and instead doing some IB_ACCESS_DISABLE_RO in kernel,
translating uverbs IBV_ACCESS_* to this then finding and inverting all
the driver logic and also finding and unblocking all the places that
enforce valid access flags in the drivers. It is complicated enough

Maybe Avihai will give it a try

Jason
