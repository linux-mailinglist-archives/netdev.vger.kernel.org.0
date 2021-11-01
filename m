Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B70441F2E
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 18:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhKAR1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 13:27:44 -0400
Received: from mail-dm6nam08on2053.outbound.protection.outlook.com ([40.107.102.53]:5280
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229541AbhKAR1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 13:27:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iI0L6RsOJwmVc/0DcevPTPPlWjgTGT9gdgt08dIO1puWJs/j6pAXG29bdX0+E1+Eezkdpr7vw8oWbX3USMYgtJYHmR3neaiPFnqq4QVXxJIhytEdETylm1d3eFh681ZMhaV3PmyUQaWdbHZAHo8frP/1tA+sG4YdBw3P+aw4xShWjt/Lo/Sv99EbKs1ZYHqeCHOlyLFIH2YU7TcdRfBZ9akkTgo4y2glt6wzigpE1MqmRnh5EoHjw/9jry3jCtfpByus7byUNzffIhq9OegtXtWh0F5HxEuWwLYS+mqrB6K8MPcveuLwDt2HQVBqPHKFPnYv9vQVEOjIvhOc+ceyUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmECHQ8iL4dyEwfonnNzoPFSRW4FoqsUBfFvifXoCv8=;
 b=ctRXsMO+cSE9yoHx5vk1eHMPsm+iasiDRN+VdCYkg9i8BxEc4xPDgysDFe9hKO1I6nloMRXDyimfnz+hKRlKygTfLQL9w9DNtQuZkLWgdVHwgmnsOth1XDAgZUBk/lVPM6otX979MspoFFGPYLx4v0j1F+O6W7ngI3/QbiroA17DHDVnJhMTLaSN7vl4mgY0TVaqyh9zkxlmUhs7VKDauFFl1kW5kmOpir2osyHP2lBgJEquH99uK67Dhg02JGbaVf2U31j68h1hCQvPvw6zAT7UIgXOwxJ1vERPZ6oqNlb9m6xoB5dYYuR/+gI0gq5REyS4Z+06dsXzk9qVc1AZQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmECHQ8iL4dyEwfonnNzoPFSRW4FoqsUBfFvifXoCv8=;
 b=ioHlsCrw8gmYJls3hYi7oLzbyOQeLNVCAlBrJ7rBVUKbvezO4qI2O+D/7lns5cJajSX6ksgXuzD42XZBJOAWGlhHUhaPnzBKU4Wwg0RqaOd0kqjeySSn4QQA2VoUKkdvyTcDrPtRb/EGRQQU0dghAFHORTxV0IhtLIUCmUHQit6Uli7Cp83ppf6iSuTKNHxeP84anhwS4cXhUc3093ySGCq9j/gBNy/7m6HWiIkIkMPWJRVCHY5p2TVaP74YUBRk07g9WmCDxARyh7/nXvEJ6x/O8PkDgoaz5Qvc9+NZDKD17qyk3Zeaox2nCAl6l7C/KhS+aM7SH6iPZIVkaOMc2Q==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5537.namprd12.prod.outlook.com (2603:10b6:208:1cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Mon, 1 Nov
 2021 17:25:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.019; Mon, 1 Nov 2021
 17:25:08 +0000
Date:   Mon, 1 Nov 2021 14:25:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211101172506.GC2744544@nvidia.com>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211029160621.46ca7b54.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR19CA0002.namprd19.prod.outlook.com
 (2603:10b6:208:178::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR19CA0002.namprd19.prod.outlook.com (2603:10b6:208:178::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Mon, 1 Nov 2021 17:25:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mhb3S-004YZo-SY; Mon, 01 Nov 2021 14:25:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1294a654-9f4a-4a72-e58c-08d99d5c8d1c
X-MS-TrafficTypeDiagnostic: BL0PR12MB5537:
X-Microsoft-Antispam-PRVS: <BL0PR12MB55371AC10E04EE5799DC21D8C28A9@BL0PR12MB5537.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W9eLefxY/Gq5eInS4cpMinZIRYagMAGF4BSdDlF1S8QYp7JslqMauI7hXFp6uzfgsOzunGmaMLyKdSaZwiVdiDW92GjGO8L/2+YnF2nEZbNzx00CdVnRZEGRAKbi/Ob2UYki8rRCzOd8ltsF5ksgSQqO7dKyf1dYT75rSoOkPdnEHNDrCobUBoO5kCpvyQ5Y5L3n2mNte5VcXogdqhsNAXmlHooXDrOJFu3mR/y959/n+vi8UERVYgpP5zj7r6Dp/yi1IANRXmP1pRS5eewvb0Z9IEeUvMICcmEvO3AFOBwJXbWly5li7fMCdxIfezpoD0+kYdjnN0rgC8NtZJBtw84zzjqF8vWvt2s0EW4amWlffr7ItkyQwT5HNwTOKRwFXDdIuxvhrLU5jLDY8IjuH5blgbxWF/+P7T8JmEsN48gQTwvn0migC2L0Sfyh2q3YTsdyRtOH1u/Vp9v+5YvhoQu2QB3DEng+jsNCVnq4wXCT/0NDwza2RRWEB4KJDZKmTXiSjhJLg1vgqT0ABlU+psUYIPIZ0ZW1jaMgW39CCajsqM0/DNCzcBDn64xr9fuHNIDR3zp9XZz1FJ8t80wJrGUCZqZAGqdABTt4q5bSzrxySaP/xizPwdNOr29gmlQG1IUSlQoX111sxFDIyUNzlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(5660300002)(54906003)(83380400001)(316002)(36756003)(86362001)(4326008)(2906002)(508600001)(33656002)(8936002)(66946007)(186003)(26005)(9786002)(9746002)(66556008)(66476007)(38100700002)(8676002)(2616005)(426003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vVXVuskqU1ST42BimKQ1lLEMQkPNscaEt++b7uXh0JeHBpq9mT/phMDznlNM?=
 =?us-ascii?Q?G5wZy3s08rvyVqzJgC6WsMe70dS8yygjDIA3OT9sT1VLNspKHYoPdVjGDftq?=
 =?us-ascii?Q?FIL7YrpwhrSdB6HEAVvpaMhERGL0+gvfgB4dtWyoLzgPopgA9q6dhmklbYaO?=
 =?us-ascii?Q?tLSjd6/z1Ue3F4HMbdwKiiUA0HjrLlt2ssTEkOLjM54wYsjKHFBl9IGO1JtZ?=
 =?us-ascii?Q?5JVKiAMIFdm7iNFnjVH97JUYPDP4fyxVo9zaD+DNV8EGsPaPDz5EFXRMrptY?=
 =?us-ascii?Q?hMYR2jEapsdNNMe15XGwEOzpeMn41fU91O1EmtTHxyUKrl0BiqfyEKUnImIi?=
 =?us-ascii?Q?dRRzsVMxzR2sia0iQrN/LvqAnVqiHVzlTIp78Y5bQR1FZxCb0CQgY7BpV0Yi?=
 =?us-ascii?Q?BFdCP0KrMdTTdnPyARJANa1pcCJSryT/bnVCBLBWs9yReFrqdHon2ZTp0HTm?=
 =?us-ascii?Q?qjydfpAAgTFXQ3+R0FFBiHe68r7POmVyIoDjXJj2akyvDyXj9JJ8+7LB98JQ?=
 =?us-ascii?Q?3wGuRQXJL85AWW8tSFnbLs+29v26xAixSLj+TMrgR7SfGh1dfXVZCbarBiPq?=
 =?us-ascii?Q?lzNw9kxUUJMGGxmN5t4Sp2glOyrwvUmWfCUNoRTlpBH3OBKyFyTo67N7DjL7?=
 =?us-ascii?Q?b5ttWh2he8S2iP9zq8B2dH4IWnkRKY5x57kozEdfltKaaoDh83Jy56/Cbvhs?=
 =?us-ascii?Q?/nunFWKQXrswr4QsQf6+YZ+pz34KbYz+OB01rKmuqztuAN3MQ7q8e5zf0/S9?=
 =?us-ascii?Q?nsSdzJROu07QaMvK56Ubi5Go7jMhUZM1QrNme22lVKpTBvfhzimlLp7EyahM?=
 =?us-ascii?Q?ikJgfqeKvMI7nfqazwojIHbxQkQ3tIGXjEtLYjQo7SXVzLgd3hrjmjydiK6A?=
 =?us-ascii?Q?zxPENWSBmsbEGBjZagMeyikYf1h9MokprBWQB2mzAK0QnrJ7P7+t8JOvqSl9?=
 =?us-ascii?Q?89xbXuXd2Yip1t0WGzfLBMi8tSTX0hk8gmGTJJuBFS4X/67FOVlWoczdqV4N?=
 =?us-ascii?Q?hYYsS/CK4+o5YfRLWLHJtGolWCvK91R0gwesSRLeyxrSNncBz05QTX0Yo1pc?=
 =?us-ascii?Q?Wc+ZNBg7c9Xv800YXaJ1ccFFokRBvatXEDWsk/fDPfa/uIpRfcwTxvPc/tUS?=
 =?us-ascii?Q?f7mLAnZa+f4Xy2P1JF8wyKW7AOvl3D9s50AMWUoKD9zU2eA1fLmfKI1B9aZ3?=
 =?us-ascii?Q?+dSgFOQoeITvg2fApNJkYcYdF13nEyDrP83FOhxP/UtR5vN1egwUOLeU5m5y?=
 =?us-ascii?Q?v6vdeSkiERXpkc53+PUsyfA0fO/zd1E5QHDaUtvrqc+3WLzVd1eVzw7+vnTg?=
 =?us-ascii?Q?HcwSAqJAltk0YkzSNerLs4hFKWo9zHy3RGqGO2lMg3Niq+cf2gJLYCR36AW9?=
 =?us-ascii?Q?+k7Lwqgj5LSqRDS8HvwinlptlBOqliq76SvRFRQ6/g22bCOH5LPuyfX2u+yB?=
 =?us-ascii?Q?EOEZb8r3HTFCBcUlDv7HCPrTWWnmx9Fdh1mpAep6RYdN83DbOzX5smmMrroZ?=
 =?us-ascii?Q?c+mJ4Jh+vLudaNWfjJnM6wA/oeWLedCvndMyINtbKBtRhqv/MPbraW25VZjP?=
 =?us-ascii?Q?K3mXb2Vp9Kk3WSiV+qw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1294a654-9f4a-4a72-e58c-08d99d5c8d1c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 17:25:08.3980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uyxNHBQ0OwDEAIoF1+hGO1tatVJCsQQsNCXvIFCzku1h9dE9Ex2hldCnIVQKXpgF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5537
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 04:06:21PM -0600, Alex Williamson wrote:

> > Right now we are focused on the non-P2P cases, which I think is a
> > reasonable starting limitation.
> 
> It's a reasonable starting point iff we know that we need to support
> devices that cannot themselves support a quiescent state.  Otherwise it
> would make sense to go back to work on the uAPI because I suspect the
> implications to userspace are not going to be as simple as "oops, can't
> migrate, there are two devices."  As you say, there's a universe of
> devices that run together that don't care about p2p and QEMU will be
> pressured to support migration of those configurations.

I agree with this, but I also think what I saw in the proposed hns
driver suggests it's HW cannot do quiescent, if so this is the first
counter-example to the notion it is a universal ability?

hns people: Can you put your device in a state where it is operating,
able to accept and respond to MMIO, and yet guarentees it generates no
DMA transactions?

> want migration.  If we ever want both migration and p2p, QEMU would
> need to reject any device that can't comply.

Yes, it looks like a complicated task on the qemu side to get this
resolved

> > It is not a big deal to defer things to rc1, though merging a
> > leaf-driver that has been on-list over a month is certainly not
> > rushing either.
> 
> If "on-list over a month" is meant to imply that it's well vetted, it
> does not.  That's a pretty quick time frame given the uAPI viability
> discussions that it's generated.

I only said rushed :)
  
> I'm tending to agree that there's value in moving forward, but there's
> a lot we're defining here that's not in the uAPI, so I'd like to see
> those things become formalized.

Ok, lets come up with a documentation patch then to define !RUNNING as
I outlined and start to come up with the allowed list of actions..

I think I would like to have a proper rst file for documenting the
uapi as well.

> I think this version is defining that it's the user's responsibility to
> prevent external DMA to devices while in the !_RUNNING state.  This
> resolves the condition that we have no means to coordinate quiescing
> multiple devices.  We shouldn't necessarily prescribe a single device
> solution in the uAPI if the same can be equally achieved through
> configuration of DMA mapping.

I'm not sure what this means?
 
> I was almost on board with blocking MMIO, especially as p2p is just DMA
> mapping of MMIO, but what about MSI-X?  During _RESUME we must access
> the MSI-X vector table via the SET_IRQS ioctl to configure interrupts.
> Is this exempt because the access occurs in the host?  

s/in the host/in the kernel/ SET_IRQS is a kernel ioctl that uses the
core MSIX code to do the mmio, so it would not be impacted by MMIO
zap.

Looks like you've already marked these points with the
vfio_pci_memory_lock_and_enable(), so a zap for migration would have
to be a little different than a zap for reset.

Still, this is something that needs clear definition, I would expect
the SET_IRQS to happen after resuming clears but before running sets
to give maximum HW flexibility and symmetry with saving.

And we should really define clearly what a device is supposed to do
with the interrupt vectors during migration. Obviously there are races
here.

> In any case, it requires that the device cannot be absolutely static
> while !_RUNNING.  Does (_RESUMING) have different rules than
> (_SAVING)?

I'd prever to avoid all device touches during both resuming and
saving, and do them during !RUNNING

> So I'm still unclear how the uAPI needs to be updated relative to
> region access.  We need that list of what the user is allowed to
> access, which seems like minimally config space and MSI-X table space,
> but are these implicitly known for vfio-pci devices or do we need
> region flags or capabilities to describe?  We can't generally know the
> disposition of device specific regions relative to this access.  Thanks,

I'd prefer to be general and have the spec forbid
everything. Specifying things like VFIO_DEVICE_SET_IRQS1 covers all the
bus types.

Other bus types should get spec updates before any other bus type
driver is merged.

Thanks,
Jason
