Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363BD447F84
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 13:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239555AbhKHMil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 07:38:41 -0500
Received: from mail-bn8nam11on2058.outbound.protection.outlook.com ([40.107.236.58]:52513
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239535AbhKHMik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 07:38:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2hat7adjmUgFRXcans/dQkAoywojttNzNPvzrrYwLeNWNhN+v8aISdYxYqOG2j0MkMGuzIaTudXGRkvWalvzliuM0ymJRiYkZU2Dx9Vw0/1/1NyVy59fxFzBr426mbRLFh0h/P1g4IaeS2pumQN5/hQunYua2LxEOuREzGnym3Tg9urwQGVICZmOGY2XQFV4qt6Qlk9WOZThYnlthUiW48klUhgKD7RtNHi6+NB1IeLomwUiN+72TOEpcv6zgNf2yOqHudpaNaHMDNdG+kSFAy5j0SPPF/HnTg5y9fkhEXKRADhKgzt2mZfIq+XZ1L1dPa2/LBqbwcBiU/cXWNvPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tL/cT/YBUDIETlv23hfYzXDT0Eljhq9tHUTBTI0EjNc=;
 b=k1WeBTErHeWLSmzLWrnn5RcCRP8njo2CejX0C7N4Ep3jZZ9UUZssq7c3gK4u0wl7J5atz+mEbX7rF0sIo3wymIbwpy4hnc+uzgEXsByAugmiJTdUvzXoe0xpFijG7OSqytpDpRKhS0fBzs8pk4kzX5yvkhyWEcbiYkPL1YrTXtaiXiw0Rwr9l9iKHO6IbqeREn06aFN0DcvT51+2mFzUpPAxsSHiyPkMWIlrEXY6w+RlouIfZ16bIUrSKYJWnIS8UywR0fGIGQRTtxlvKNBRQ+xdfadIe5bb05WGfr0VwCSJrbJfwN/DZOV7rjME2X1e7e4gqDtcF2VcWpeXt/NGBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tL/cT/YBUDIETlv23hfYzXDT0Eljhq9tHUTBTI0EjNc=;
 b=WEb6KCtJCB6a5zYEsR2JWriVuWeAJKKHks+eg/6O6vfY4NgW2MuVPCq+usb4c8P5iWH+6mQTfCexJy/w8/KJ4EQieaFBFXrKT12MbYADTbNFcnzbcMpraGTX3x3i4L4h8j31bvWXluMr5p+0EV3y+QSYj0mZrGI9rD3HQ5GDUi/ArdLsuAcLXyXZgYFYjZrNKv8w+oqVBQf2vJobYBmIBHqDJSoxQhX8Cbq9xQ4L9/1NV7RCDL0HhixG/pEPmS3gjLN2Dba59wNhwjS5BWein+8SWPHzjlngtiwF7FMsh9rjD4tbJlcdeNLQCn3gq8GZUe44KKgVkW4tblAbiJqVtw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5095.namprd12.prod.outlook.com (2603:10b6:208:31b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Mon, 8 Nov
 2021 12:35:48 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 12:35:48 +0000
Date:   Mon, 8 Nov 2021 08:35:47 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
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
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211108123547.GS2744544@nvidia.com>
References: <20211020185919.GH2744544@nvidia.com>
 <20211020150709.7cff2066.alex.williamson@redhat.com>
 <87o87isovr.fsf@redhat.com>
 <20211021154729.0e166e67.alex.williamson@redhat.com>
 <20211025122938.GR2744544@nvidia.com>
 <20211025082857.4baa4794.alex.williamson@redhat.com>
 <20211025145646.GX2744544@nvidia.com>
 <20211026084212.36b0142c.alex.williamson@redhat.com>
 <20211026151851.GW2744544@nvidia.com>
 <BN9PR11MB5433ACFD8418D888F9E1BCAE8C919@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433ACFD8418D888F9E1BCAE8C919@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0110.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::25) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0110.namprd13.prod.outlook.com (2603:10b6:208:2b9::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Mon, 8 Nov 2021 12:35:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mk3sJ-0078nD-7n; Mon, 08 Nov 2021 08:35:47 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27a2a26b-1fc8-40da-5437-08d9a2b44aa6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5095:
X-Microsoft-Antispam-PRVS: <BL1PR12MB509568CD1A5AD274AC01878EC2919@BL1PR12MB5095.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uNYwy57NGIA0WRvcCA95v4ggiEXa6WOKUNCLnAvg/c4dfe2cPfoFKhro3HWtA2Zpbumr+bTTNdWeMt36R9Yw8P3EqGJgBucCzm9YgaPW3oTNAj8xKvof04lEOHOpKPS3YAkEf57PN/iClew3VxRuBcQvxRxFrDRlG1343A8VeDzVi1B3iAVYmxyKRdwwOjqApdlocK3flWEJEMSac+b8bSJa0rcWGRHrbwXIHX4m6mTFRAHjGSnmufKkdLpY6ZszoBF7wCCc8blKPxJAge0LE0KTzi9/0xlT18chet1ZplMU8lF6Z/izGbWcbpggqrk4yBwOCIWGZYgtttrnZknlv03M9NfQKjPxNf56eZqrIc/JGcX6vaolgsdchmK8aFkHazl4yNnuE0UviyMwA1py0fEnzyWI2ykbfqD9SjVbfpT2edhOiGiQAERkAhcRUm/yuCaGPL30aHq4vFTGSg2sIYEfwBjrpk9we0vsAGqGtq61Oterpc7Mjf0tG6JeozjWX8GDBM+clpkOvuLto0+Em7CGiEc+Swm3xzS0xsOFZwfY0Ol67EphhaacsXFn5JfpwEo0x117kWDOfAokxYVRelC1LlIENFyNFBbSfDLWTDlgLbRx8P0axO0eJbTh1/39cfhI0/Mj1q+2VHbo+wLbWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(8676002)(26005)(1076003)(38100700002)(316002)(66556008)(66946007)(54906003)(2616005)(66476007)(186003)(33656002)(83380400001)(5660300002)(426003)(2906002)(9746002)(86362001)(36756003)(6916009)(4326008)(508600001)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Anl7F15BE03CViO14+OhK34KNOmG5+S+vPWxpifgsg4tfsk6h9UShvLtloAt?=
 =?us-ascii?Q?T1qkS+2/R5Fj5ko8ctOUf4EPNaVqpnKcg0wyRdnq4PSJcLMJoN+FyDYpPo6B?=
 =?us-ascii?Q?No0gMHt7iHqpsfzBVQx+FxDkZ68Cm4ifyPKfWn/F6Ul8qcor0gSVc97jXjZ0?=
 =?us-ascii?Q?7du5NLwqdajmd2l65RU8dcXVteEF3UTYwr/EzpKRU5rA7ZDy+WrYk/9bLh0L?=
 =?us-ascii?Q?q8JnaYsqXVl/XG3Z57CnznnOhrySaCgrOjRbisC8q0S+1xJmAtLZHkkRU8DW?=
 =?us-ascii?Q?vsrsWcTh6MThf3IGIdV+lAKMaK9euOsF4oq2foxI+Qyy9RE5+37P8ZR2ju+R?=
 =?us-ascii?Q?qFjynvpkgksXtezcuGP2fDTthCvfiyHLLGi0jxqiqsi5W/WGFExYDptGCS9N?=
 =?us-ascii?Q?Z93mAyvS3LkxGoupBVry4rHNkjp+SunsC6Y8340zk/i8iq95jlu2Wnwxs18e?=
 =?us-ascii?Q?OG3Lhme5A7iyklZt/Pr7oKpUGd5oDFjNuKGPf0ciQ+zOyRXXoKAbwPY/5CW7?=
 =?us-ascii?Q?Q6ldvlEWUTaAuZp4O2Dvmr2/mTgAEVurVRyMSBMmHXlORwWW8SV6Ki67nf/Y?=
 =?us-ascii?Q?AWHMWfBI+WlOvf5HGZZosEGtk3/j0L0NGzqAKePEw8vLQWjKLGDUYFzcpyMG?=
 =?us-ascii?Q?tVU8/YWTpqxIiHduSm246Q5SvweRm2st5iLi557+hW1UtWqP4Kn6mPWhxdOD?=
 =?us-ascii?Q?foCsYcOOC299U98os7iwMne15nIw4MFNhRAI9lUJt5tjuJzTcs6pnwdHDh9M?=
 =?us-ascii?Q?nViWjC34xjguZifPjH2R/++4ts0BC/eK0f0PM42uywmDa8pcz87lemar0Mtx?=
 =?us-ascii?Q?GDOeQJdDTnjmqmhV6QqjdSfjNJB0VL2mLxmU/joCHb4mtCRkhvCNMA23T8eA?=
 =?us-ascii?Q?bUOy2S0juX0Y+u/W3QTF/VMUAk458iKfIWnVBIWDJlaOKlKXYI7EA1257tUm?=
 =?us-ascii?Q?GxNDtXNqXU2hQpzAQhjFVXyRLK0IKQFdiyDqgMYHh8yhfzl3KxN9NPHuWwjH?=
 =?us-ascii?Q?UY+wqxc8t0TFNvu6HXls1P/qGO1S75T8WWfZodY1w9TtCBjR6af97KbbmHJH?=
 =?us-ascii?Q?9l4kjIJD1aiK+kNz495xkKzFEk3vgapANGfIb5NfODA4/f2nhk/RD6vH35rc?=
 =?us-ascii?Q?ksSTzYAxCBJKNk6ljrDNsx0EI7x2O1Z5y1PO5YdZcLHTS6qiepQq3LwYqCJN?=
 =?us-ascii?Q?GkInxCFym9fhm9mx+UFrYnbniupwslfAyptP6RzPRipVJR+q7Y5wmi8yz/Q1?=
 =?us-ascii?Q?MWnrwbsFYMLzXF2D3AkX6plB1CBNnhdFeTo/pZO8EseeTcEadfEvcfcfnmUx?=
 =?us-ascii?Q?42Z8kWbsl+sOvWkJNaw2v96JGmP05lKBAnZlKmo03LLrYZZww9fAQQIYLFMx?=
 =?us-ascii?Q?JONjFYAk3SyjERGso5qud8uDEBH4JL0u9QZs4RvIL7cxYQQQnPsWERTfqHKI?=
 =?us-ascii?Q?buseMw3nSaZU+25yfvyWXNZZlS9E5sBAlITljLozd+WQWMw/oftBe92bNLct?=
 =?us-ascii?Q?22j0B/ZXlJn9ipT8AEkSYa7Gyu8XtanXm1bVfNtDd4Ck+9b1GxoplfY/GWTO?=
 =?us-ascii?Q?bvD/ZoUbZGLFYUYOtnE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27a2a26b-1fc8-40da-5437-08d9a2b44aa6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2021 12:35:48.1844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9XdIW2dy/h6DS4/S6jlA8RONN3cKJcJsP2Cv9GdyjbUOG6YIRkcoLH0kEBrUVlZn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5095
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 08:53:20AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, October 26, 2021 11:19 PM
> > 
> > On Tue, Oct 26, 2021 at 08:42:12AM -0600, Alex Williamson wrote:
> > 
> > > > This is also why I don't like it being so transparent as it is
> > > > something userspace needs to care about - especially if the HW cannot
> > > > support such a thing, if we intend to allow that.
> > >
> > > Userspace does need to care, but userspace's concern over this should
> > > not be able to compromise the platform and therefore making VF
> > > assignment more susceptible to fatal error conditions to comply with a
> > > migration uAPI is troublesome for me.
> > 
> > It is an interesting scenario.
> > 
> > I think it points that we are not implementing this fully properly.
> > 
> > The !RUNNING state should be like your reset efforts.
> > 
> > All access to the MMIO memories from userspace should be revoked
> > during !RUNNING
> 
> This assumes that vCPUs must be stopped before !RUNNING is entered 
> in virtualization case. and it is true today.
> 
> But it may not hold when talking about guest SVA and I/O page fault [1].
> The problem is that the pending requests may trigger I/O page faults
> on guest page tables. W/o running vCPUs to handle those faults, the
> quiesce command cannot complete draining the pending requests
> if the device doesn't support preempt-on-fault (at least it's the case for
> some Intel and Huawei devices, possibly true for most initial SVA
> implementations). 

It cannot be ordered any other way.

vCPUs must be stopped first, then the PCI devices must be stopped
after, otherwise the vCPU can touch a stopped a device while handling
a fault which is unreasonable.

However, migrating a pending IOMMU fault does seem unreasonable as well.

The NDA state can potentially solve this:

  RUNNING | VCPU RUNNING - Normal
  NDMA | RUNNING | VCPU RUNNING - Halt and flush DMA, and thus all faults
  NDMA | RUNNING - Halt all MMIO access
  0 - Halted everything

Though this may be more disruptive to the vCPUs as they could spin on
DMA/interrupts that will not come.

Jason
