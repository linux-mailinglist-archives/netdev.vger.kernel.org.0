Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A44E446413
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 14:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhKEN0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 09:26:48 -0400
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:2401
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232258AbhKEN0r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 09:26:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TdpXNtVCuFmmTabm4A25ljQN2yi82WlrFHtVT+fy/HIURHjLM32Nrj1wAxzk8E2yFDe6VgIk7b/voNWszmjC6c2fyl0tjxrNbPQ0TvzEerNu1Afj4Ac6XhGZpTV9p6SfcYuXUvtAEmo0fEcm1Dy9kiDxxcZi/qcR+tqzus2dh6IG3GMoIEJmhwHbTNAd9CaUZF0fMov2hehyjFfnmUHUYehG2ZqIe434Eo3VE34PP07Ojvy7BrQpg1TaFW3hhur5Q+ZMFf49deMxz9FEeT0s4loAZZddtmr1JsTkVribTlCg6TIRSM1tQzpliwdJIm9TqKFHqd/+2QyAe+wv4hpE5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fg+rrJ3u5Xugl80Wka052s5fBV+X81ssAzykmhJKPhE=;
 b=EX+D8dkRdAWQDy04DNrj9mvt90JNyUSNFETark1SUqr3gqh9vEkJaD8wRCg9kgvfmwHstWlLnc8Axo9734JhvgvjZJ5PnB3wZG6NwzeZ8kqogvZFQF6dqrEDJJxQSXhImH1wpX4Xpvib3Uo0qQiCAIVbkAFcD9/mkrTzcK7gh5dL96E61AtpK5sJKtt9mK2fxikk8lU+XRmRD8/PHjEOXNvJewOyypFtwhpHvZasqC3EZ8dVk5MX3p3IS3RqwUfzFQsXdpk1J2a1U36RhtmBfVn6PvEm4utQ+Au5AsJ69vBLxSVpt3mcq8XkiA6l/NUmmq+JGwPtBhv2Hg06y8Ulhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fg+rrJ3u5Xugl80Wka052s5fBV+X81ssAzykmhJKPhE=;
 b=uL8ScYJaHu9iygHroMP7QHL57T4HQE1PRZCVhS1FIfqC2V/dr5KB/9SWseMlQoqDU9kJSYBoFv9cuq7cHSVLUifpKTyuO/AgmoVsa5ik1pU7jrci5n0TpLEJsv9ER8DsITQ1OnqvO3e4W114+voQEU+bbqarB54PurHdxVjlbYkEirfN92qyTRp0EueFCBd3c5FIzDO715LGDyal5PN9zZrnGBe4sxfsKPS7e8OKZkfF2hF2g/0VOFI8teFrOAlr/h5fIVjsVjkGSYtidNRjub8zADWMmXW8QFIq10M8gKxWrzv5OagSaT//tuvyNfxtxPvyKPqS7Rnr6VoLBXgaRA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Fri, 5 Nov
 2021 13:24:06 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 13:24:06 +0000
Date:   Fri, 5 Nov 2021 10:24:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211105132404.GB2744544@nvidia.com>
References: <20211101172506.GC2744544@nvidia.com>
 <20211102085651.28e0203c.alex.williamson@redhat.com>
 <20211102155420.GK2744544@nvidia.com>
 <20211102102236.711dc6b5.alex.williamson@redhat.com>
 <20211102163610.GG2744544@nvidia.com>
 <20211102141547.6f1b0bb3.alex.williamson@redhat.com>
 <20211103120955.GK2744544@nvidia.com>
 <20211103094409.3ea180ab.alex.williamson@redhat.com>
 <20211103161019.GR2744544@nvidia.com>
 <20211103120411.3a470501.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103120411.3a470501.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:208:c0::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR05CA0001.namprd05.prod.outlook.com (2603:10b6:208:c0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Fri, 5 Nov 2021 13:24:05 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mizCO-006L7R-HK; Fri, 05 Nov 2021 10:24:04 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e1df56e-cf43-48a8-c8c8-08d9a05f8a6a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5304:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53045F68066C025F730CBC87C28E9@BL1PR12MB5304.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rWEkfMgWGxyKA6CE4MkVyljBoxJjNWkgsXk0VRZbb8tlZ3CnXeBvzPHOcq5yzaUDEYKN5DsMeH+gBIvke+eYWZT285VfK1Xu2thjWULlMz3MIMI3XmVadn4QOGXU0KwA3asOgPgkmKLsKOAgOD04lc/i64CkPHXe2cOxk1C2uxlelE57gCl6CdyRO07WGlCkcCpL2eu6VvM4oCmsB0TeOCwUZgdDfjWUTaNp0Rtfkcaxg3bjyRTM3Gn/jSZAwF6SnZpQEVEUkJMt/EoZm6AshCqAtlF57kIcYM+lQTrc5UkBoj409suayqeJNu9xfZbazkc7OAUMF1QgItF+OdrNVyFMZwZmgpOzEkfPkwrKWcv9YfL6MWCr8xApiH7zRvyB8mXgvwUt/rNPXnHMHVQtkgvJJDN06/oijaGFGUYcV8AkStkwAP2ov/5EhNoXHRxaUvEkz3fNG6qUrHfXjCQTkcnflQFzETHFonJzMAwF7092W3Vj64dZZDy3AGvm/xUZXGYCKtyBTsAgQJIG/nlsffwYFN0QfTa2FMfFFMSmKqg8skvJ1z2RYSBs9KqCxAav9Dz5aj0WUPIpDtcXiofFtKpc5MD9xYx5Y/NdYoR68sxHDECuVabrzXePItd7nvKeCPqFlzylnv6rOh4RYn2aTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(26005)(36756003)(2906002)(86362001)(38100700002)(186003)(83380400001)(8676002)(54906003)(4326008)(426003)(66476007)(33656002)(6916009)(66556008)(9786002)(8936002)(1076003)(9746002)(66946007)(2616005)(5660300002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i4IMgBq3t3qLiRQ7+uvbEU70VsLeONuRrUb5LzHqK2GJPMNdkTuhEuZfET11?=
 =?us-ascii?Q?MPQ7j/o82ipaF1LfNPTUtJIf9kWhija62oDPtoLFnnY/ajgEeUjvGxoHS7YV?=
 =?us-ascii?Q?t5wYk1TgXUWu/arNAMhfqxcBIo38OxIvGSVB889pcNiQR8C5GjtEGM+rkCJF?=
 =?us-ascii?Q?UuftHD0nTzVeL6grflBvCT2NYU2zGMRYIdyENEj4XEaZj/1jiQmtyBUykfy5?=
 =?us-ascii?Q?H0PR4QlgsNIMDrwqvkzwr/J/BavzWtAU7e7S8Xr7NL1dbT2D7QKbUr4VnIuc?=
 =?us-ascii?Q?ThpJ2ycfgg3G/KymF7fw4QCpmMuQd/JFjvLNbhh+eLJJvUN+F9mn7LnepeM+?=
 =?us-ascii?Q?VHS+msmb+m1QOymGBUmEfBi6d7eJeL7GS6IyccgJmKRz8Cl/HJVvOYLnOL42?=
 =?us-ascii?Q?pcnT+mNBYlq4st7PzBonwYwcsRn7XpLTyF4Ql3FKBGSuow/tpPloVL7u2JKm?=
 =?us-ascii?Q?cl/WaQY2huR9zyKWiHfJxDry2tLGQGX21h5LtdBZcj1MlULMg4ewQYlC88Bh?=
 =?us-ascii?Q?fUyWTSlexRvyDHJlM7mAT2TX5T/gpSt2EgHSSe6y5TiYd9Z9dSTQEfDtTUwX?=
 =?us-ascii?Q?V3F1wzhl+ULrE39wxIiRSRRMvPluI0hVhbE5le+if2uL9mZasnVq9aMuU/Ft?=
 =?us-ascii?Q?pS+WV4MJnDW+R/ZV5zT3WG88W3dSuHzQo9WkMwI+NRako1OftEcvIOsAy6Wt?=
 =?us-ascii?Q?IoVv62ab3DG87TKc2ZxLBrSZ+or9mETroAUa2MnXJy4ZJjNW2JOvNS/o8vOp?=
 =?us-ascii?Q?RpM8WZ193Adm8DxaUDB0fiIegaC/hF0GD72MRkWH88XBnZoONMF+oNyIz0WT?=
 =?us-ascii?Q?CEvkc54lK7wuWu2A2cnmEtBHMLuuie8dAGrr2B2yeAibH8/oPcJclfuwWoIl?=
 =?us-ascii?Q?HdfHS+5rafBzK898aX2139crisQnGhOtAX/Dv50SkLTwcdAZY2md5CKFq5pQ?=
 =?us-ascii?Q?vk4Buz5w1MjI2pS+IVKw5CpFTxFYgtUwXzDPpmImJA+O/b4Erz2Kny3fxIPv?=
 =?us-ascii?Q?s/pfofgLw1sLLh4XVDonr7flBBTSXrdiYsqtd783LKZbWYky/yHJdDlamXVY?=
 =?us-ascii?Q?uvW83WR/+dAWbbhc6b1S8Qaq65zXFQBpSHp1GLmSkn8jK7QjKxtvjaSjAT1d?=
 =?us-ascii?Q?3GFI8tsaTe/7xiE51W7GkKmemp2s8k3pkaFGwkhYjd3ohMy+c5Maw9Pwy5Pv?=
 =?us-ascii?Q?uaLs/39S3iN/FsgL1Ix2TI4msyaIhj5roU7Ntt7EnSjIgcHHuFWVYpkYINEN?=
 =?us-ascii?Q?QGPLyt4igjbtjg4tb+86byfMCHbt9jUZSyz46ecFV/UWS6rOgp8ISDK8BWkA?=
 =?us-ascii?Q?mOXaEH4XMNcefGAS4gr2qQejmbH1rOT8nbmgYgD0LaHKjueTWEYP8WjUOex7?=
 =?us-ascii?Q?lK7EnxdC+s/fNdFUqVxpYnN9GvauXF+sHXuA1xBNB0/Od7ZGuDPmVPAgUN/Q?=
 =?us-ascii?Q?McSPlqpOFUo2a+9EaiKYOYErlY1/+I9dO0pk+phc0+jqcv+hkH3Al0+ShIcZ?=
 =?us-ascii?Q?CaFY2mXoL5fAN4BnptOMFKtdlbi9gosweitjy9QAOXcSZZCpp5+YHV4FftAB?=
 =?us-ascii?Q?BgolZabVdusLxCd1mOc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e1df56e-cf43-48a8-c8c8-08d9a05f8a6a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 13:24:06.0887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5DxL2cVyPtJYZ4C/NcxHjtYElYSFz324nwsPUIyv+CnavX23n8dtnMkHeHYCcO4Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 12:04:11PM -0600, Alex Williamson wrote:

> We agreed that it's easier to add a feature than a restriction in a
> uAPI, so how do we resolve that some future device may require a new
> state in order to apply the SET_IRQS configuration?

I would say don't support those devices. If there is even a hint that
they could maybe exist then we should fix it now. Once the uapi is set
and documented we should expect device makers to consider it when
building their devices.

As for SET_IRQs, I have been looking at making documentation and I
don't like the way the documentation has to be wrriten because of
this.

What I see as an understandable, clear, documentation is:

 - SAVING set - no device touches allowed beyond migration operations
   and reset via XX
   Must be set with !RUNNING
 - RESUMING set - same as SAVING
 - RUNNING cleared - limited device touches in this list: SET_IRQs, XX
   config, XX.
   Device may assume no touches outside the above. (ie no MMIO)
   Implies NDMA
 - NDMA set - full device touches
   Device may not issue DMA or interrupts (??)
   Device may not dirty pages
 - RUNNING set - full functionality
 * In no state may a device generate an error TLP, device
   hang/integrity failure or kernel intergity failure, no matter
   what userspace does.
   The device is permitted to corrupt the migration/VM or SEGV
   userspace if userspace doesn't follow the rules.

(we are trying to figure out what the XX's are right now, would
appreciate any help)

This is something I think we could expect a HW engineering team to
follow and implement in devices. It doesn't complicate things.

Overall, at this moment, I would prioritize documentation clarity over
strict compatability with qemu, because people have to follow this
documentation and make their devices long into the future. If the
documentation is convoluted for compatibility reasons HW people are
more likely to get it wrong. When HW people get it wrong they are more
likely to ask for "quirks" in the uAPI to fix their mistakes.

The pending_bytes P2P idea is also quite complicated to document as
now we have to describe an HW state not in terms of a NDMA control
bit, but in terms of a bunch of implicit operations in a protocol. Not
so nice.

So, here is what I propose. Let us work on some documentation and come
up with the sort of HW centric docs like above and we can then decide
if we want to make the qemu changes it will imply, or not. We'll
include the P2P stuff, as we see it, so it shows a whole picture.

I think that will help everyone participate fully in the discussion.

> If we're going to move forward with the existing uAPI, then we're going
> to need to start factoring compatibility into our discussions of
> missing states and protocols.  For example, requiring that the device
> is "quiesced" when the _RUNNING bit is cleared and "frozen" when
> pending_bytes is read has certain compatibility advantages versus
> defining a new state bit. 

Not entirely, to support P2P going from RESUMING directly to RUNNING
is not possible. There must be an in between state that all devices
reach before they go to RUNNING. It seems P2P cannot be bolted into
the existing qmeu flow with a kernel only change?

> clarifications were trying for within the existing uAPI rather than
> toss out new device states and protocols at every turn for the sake of
> API purity.  The rate at which we're proposing new states and required
> transitions without a plan for the uAPI is not where I want to be for
> adding the driver that could lock us in to a supported uAPI.  Thanks,

Well, to be fair, the other cases I suggested new stats was when you
asked about features we don't have at all today (like post-copy). I
think adding new states is a very reasonable way to approach adding
new features. As long as new features can be supported with new states
we have a forward compatability story.

Thanks,
Jason
