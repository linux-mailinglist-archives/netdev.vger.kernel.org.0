Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E155C44ADB4
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 13:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244575AbhKIMsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 07:48:02 -0500
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:32096
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244542AbhKIMsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 07:48:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9wvBy0RPOtxvEUVcIsoGateV8LcUzNFWw32FARpj6hSzLMUy3FcMyYEEcyJdJOAOAiQFq8Gkj7Bdk9bgsJ4k7okFQN1PYl4hPHbOpFMihbvtCu2peabuPh0sKqOuYYoPI5dwTTQBWhsY2Fz+DEkcJQ0+YGVSXB7UNDPUNjqnhnzXgpOCOiNhabj6PQF1tYW/F3f7HKBie/NLLhWDTLoMkKZsdnUHblQ9XtWUqjR6E+Ul8UJVnNH6LoI69bn2u4SyE93OewvxJfU9gqSCeSlneiJziu1SCI8bX5Q7oZMjbuye+HcJ/zs1G12lgvYKE0fJuAgjaQxssMfUpekQhzUHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PajCo2FQXmLx+40eTXjwuI0kPMesTrqoZ8XHfJOC+3s=;
 b=mWJ64haw5AW4OfXABj4i89lXrCyY7d6C1Q+wSsT0fpzK3u9nj7EUEo9LluIJ83ymyTGi6Dz5mtFktKOLupaOfY0tGEj1nCYkefgGhAjvTApR8Q+Q3zc0cr7nQ+fML5zvH62KqdXo+wqnxjfw33CY2QBXDDb8fHVFtleJRsRDmOtWPv1GhkDYyUu2FX3B4eHnGv7ls7/3bhroMlgbdUGs3W5x241Al1Lu/38Guchbg6nX8aZo1z0jsAGuCDJCddhmTMyfcJS6zggs8DMMjvl5BIuceRW0jmQ33iVzMjPgatJgArsH+jAQ7Z8aavzGtpLi6UUlAW0d50C1nConnW4Gqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PajCo2FQXmLx+40eTXjwuI0kPMesTrqoZ8XHfJOC+3s=;
 b=VWh2nnEz9koaPXnNFnhYQF/EW1MRYoUF3TKuA5S0mazswVF6ll/wsdkEQ7Swc6g3p2+1Ebg9jpW6w7ceCu3D8OmX4E4FhtBHHlT6ZLwil09H0FgB0JJQXC9w/fNR3QnqCzadHFgIB75EFY8KoKPXpwsP43JMhhkLvXkUpMr/jshu4I6Z3mp84nRe2NLp9OMpx5fMvh6VZTdunwoNIU3YJtLbYj5tEfX1HXKlUgrabSwcqIh+tVUbMi4yh2iBJ6OjKimlCRW8dPF+0vjRglB000jRRjnMTrcCrvbqKhVTjlw7BX9pLw2ubwqjlyiDGVnO89AdZrYfLdNNwI06FZL8Mw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5206.namprd12.prod.outlook.com (2603:10b6:208:31c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 9 Nov
 2021 12:45:11 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 12:45:11 +0000
Date:   Tue, 9 Nov 2021 08:45:09 -0400
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
Message-ID: <20211109124509.GC1740502@nvidia.com>
References: <87o87isovr.fsf@redhat.com>
 <20211021154729.0e166e67.alex.williamson@redhat.com>
 <20211025122938.GR2744544@nvidia.com>
 <20211025082857.4baa4794.alex.williamson@redhat.com>
 <20211025145646.GX2744544@nvidia.com>
 <20211026084212.36b0142c.alex.williamson@redhat.com>
 <20211026151851.GW2744544@nvidia.com>
 <BN9PR11MB5433ACFD8418D888F9E1BCAE8C919@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211108123547.GS2744544@nvidia.com>
 <BN9PR11MB5433435CAAAB23EAE085C3128C929@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433435CAAAB23EAE085C3128C929@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:208:c0::37) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR05CA0024.namprd05.prod.outlook.com (2603:10b6:208:c0::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.4 via Frontend Transport; Tue, 9 Nov 2021 12:45:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mkQUv-007d4a-Jj; Tue, 09 Nov 2021 08:45:09 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8eaba287-daf9-4007-cfad-08d9a37ec4ad
X-MS-TrafficTypeDiagnostic: BL1PR12MB5206:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5206BD3002B3A9479284CC7DC2929@BL1PR12MB5206.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BSneR/NiYjwqH7zCRL3acco93GKS5oney76eqV98Lt9AG7cli7qsc5yzE9Nz2HhGSL/fu8wGVyo/8xpDzz0yy+bf9RIo3VVPNO6ogiV+K4BisMXeTGnKdhdeqVRxL7twxVUBdYkK5pbdZmELLZgv+H7MTzit4qbNs3F4mheRCjk/2f+LevIDIVC5pFCE85E81h/1ATZaxbr17FTwPrs8ZmSz5MR7SyrvjV4Eym/uce8hAd2BYJeqRczCI5+LFmoZo1DcUX/2Y/s49wHhy7kXGikuM7iBpU1iD0IN9pe6lCge0UccNv2VHLCvTcI/20PMLFy30kDQ7HfS+7g5YvEVptP6n1Hl/Vab67ASxvhgdD9MHjfCMVyAuRLxDtykS9gbuPnKGMJslpx73gvyaPvrMT+cJ/1dgcLb+cZEItWrtuuVWmGLE/G2tH0+whspjT+bhLW2KtIQOEIbyF0JvWDbVHiRoNZvofqYhbrrPypzhCqFRmayz/2n454Be86YcG8FvUzZheYxY7KCa4kOHFq56hyXhz9jJWwzeYzUhvyCBBhevpqpQG+Dj6JoSZBbNxCrt9wGt6cm/nUeAP/lUzk9iI4Nv06XfqJ2ra4377UO8SkHFL9hzVZi8yx2fGa1nufyRO84IdQqUgLVE9CYV9DgGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(26005)(316002)(2906002)(36756003)(9746002)(426003)(9786002)(5660300002)(508600001)(33656002)(1076003)(186003)(66556008)(66946007)(86362001)(66476007)(4326008)(54906003)(38100700002)(8676002)(83380400001)(6916009)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ha8oXLZbvpdaA5F5ZsRHMHxchw0enQV39Rv3qLdFUSxi0TwyVeVZCpTHzx5V?=
 =?us-ascii?Q?5pNZKCNz2S4bZv198esHMU6Jvzs17YL+s4Mj8mXm1PlG1ebaqZPcJ6usUG3B?=
 =?us-ascii?Q?tpi971BroYeCgseQ5xDYfjy3D4j39t3OLNWVpDXMac23GgVpXfIJvTE/lmGQ?=
 =?us-ascii?Q?JdLpn082UQ0eD+BXuat/alsZO4+fvC+ZuvkqsicLRjHwCQpQPOoe2g+ckWf0?=
 =?us-ascii?Q?YGaj67kdkwnLpBvbOtVIoomlH5SgAyz+hU9XnX0zPIoKOzRURE68C+C+WgzL?=
 =?us-ascii?Q?HonBFb/pfcl/gyfyqDo84GXQlzUZeX5q9C7ED3KGJnG8N02q4oQQp9fod8Dt?=
 =?us-ascii?Q?q+119vRKsIup2kW6IcSH1Z2geahQ/YX+mf5ZRSdnkhVHUfIZkFFyZqGRRNJe?=
 =?us-ascii?Q?wojWk1Ske0A9GzTNd/YkwXzMYlWUAY2hGlCZk3KhjSPaY3xIMg3m1XbZFbn3?=
 =?us-ascii?Q?q4bKm5EbS3qoplMFu3A5VgIwDaEdmwkraX1flRotAFNNNDctfiQ6FytVDcr2?=
 =?us-ascii?Q?2hdVZBQ4DKwHUuz+fJAHHDtaxtcO9XVbS+ZBpvNxvjYAcnIu0e40ee+9sdJ0?=
 =?us-ascii?Q?IS856zFpivCb12HqzzZ5Q5aa5O5PxxoIh/HIoJdJraQRQeO88X/X3n6sOUVP?=
 =?us-ascii?Q?IyIg0hsEdEBptKizpOO3Xw1QZoYHIn5lexEYVoN5lRzFC3CI/dCOEzARQL9j?=
 =?us-ascii?Q?urxVh7pO1uZDhIu2685G4MV1F4Oarf7SunTnCWdi9PGOrcjk818LsP0ZAI8J?=
 =?us-ascii?Q?n8LvJqNdRL3zIHhlYtkuURQwFfMYCwbE147AJS/crdEebsrvH7qfE2D0svWx?=
 =?us-ascii?Q?oSI7O2MXBQjzrbiR/JRJ0QSUF1FfCg/Wtrnr9webjtB9buFfxnwTqLwR+H78?=
 =?us-ascii?Q?sWlTOHTKQnJ6Ge1bYjafWmNDd/okCIKAjqbwBTfgwsGwdAf8dSl/usozAjPA?=
 =?us-ascii?Q?iUurDvr9DfjxrpmSUsvT7hlSYSEtTf2mm88Xpdp4dywn+rNC7nmmeJgZo6hA?=
 =?us-ascii?Q?0Vvb8L4LxqOLFSRtQm7moZPYmuB0uY2dUKHTs531TT23xsAuEt1SGJf4Udw2?=
 =?us-ascii?Q?+eqA1p/He1R8Q4Z0KUlgIVt9RV2S49ytmi1eOmpmwOPSannyCyENf/BaViSC?=
 =?us-ascii?Q?2vSkIDtjbG3h2HOBWfhiXa5nro2/LpjNNfomvxeSDWpCbCtewPhKMj2aNe2e?=
 =?us-ascii?Q?Eu5eu3KMpl1sTOO8jxlDFcjuAx5Z3g1VIzG6YgKvnVYo8XP33RMCI01sENvN?=
 =?us-ascii?Q?oi5BMPBOgJBM/tNWY/aJXhkh9si3CUk5jMWG5lSw1fizv2HfxmCcIQWYOB/d?=
 =?us-ascii?Q?91Ve3cvzOdgkmkNraWsOBKiDAOKZ+6s34d/qOKpyOG5/eM2kEZPcFiHVfNli?=
 =?us-ascii?Q?mQSjGdxQ5VncKesz7k8g+35/GwDEE33EaFv3qwyt1whbq7RED7ae2XP/yTcl?=
 =?us-ascii?Q?Red+N6yLkpW44OB32iQU+94w0AdXnEGdGvmpT9it6t/3z0TX8uJA4DXfkaSW?=
 =?us-ascii?Q?rPNaM0uPZt9MxU+J5uwhX8FzRnFlolIuuHzWaU5kkbpALMC9xrmhNlNvRghA?=
 =?us-ascii?Q?pe2Xrj8l7vCjKjowKhM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eaba287-daf9-4007-cfad-08d9a37ec4ad
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 12:45:11.2439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: raZRQfoH5O0ySjoZ4xPj4L8lN05XPbeqHZ935nh5re0ufxG0UxkyJvrjnbtJhhNG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5206
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 12:58:26AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Monday, November 8, 2021 8:36 PM
> > 
> > On Mon, Nov 08, 2021 at 08:53:20AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Tuesday, October 26, 2021 11:19 PM
> > > >
> > > > On Tue, Oct 26, 2021 at 08:42:12AM -0600, Alex Williamson wrote:
> > > >
> > > > > > This is also why I don't like it being so transparent as it is
> > > > > > something userspace needs to care about - especially if the HW
> > cannot
> > > > > > support such a thing, if we intend to allow that.
> > > > >
> > > > > Userspace does need to care, but userspace's concern over this should
> > > > > not be able to compromise the platform and therefore making VF
> > > > > assignment more susceptible to fatal error conditions to comply with a
> > > > > migration uAPI is troublesome for me.
> > > >
> > > > It is an interesting scenario.
> > > >
> > > > I think it points that we are not implementing this fully properly.
> > > >
> > > > The !RUNNING state should be like your reset efforts.
> > > >
> > > > All access to the MMIO memories from userspace should be revoked
> > > > during !RUNNING
> > >
> > > This assumes that vCPUs must be stopped before !RUNNING is entered
> > > in virtualization case. and it is true today.
> > >
> > > But it may not hold when talking about guest SVA and I/O page fault [1].
> > > The problem is that the pending requests may trigger I/O page faults
> > > on guest page tables. W/o running vCPUs to handle those faults, the
> > > quiesce command cannot complete draining the pending requests
> > > if the device doesn't support preempt-on-fault (at least it's the case for
> > > some Intel and Huawei devices, possibly true for most initial SVA
> > > implementations).
> > 
> > It cannot be ordered any other way.
> > 
> > vCPUs must be stopped first, then the PCI devices must be stopped
> > after, otherwise the vCPU can touch a stopped a device while handling
> > a fault which is unreasonable.
> > 
> > However, migrating a pending IOMMU fault does seem unreasonable as well.
> > 
> > The NDA state can potentially solve this:
> > 
> >   RUNNING | VCPU RUNNING - Normal
> >   NDMA | RUNNING | VCPU RUNNING - Halt and flush DMA, and thus all
> > faults
> >   NDMA | RUNNING - Halt all MMIO access
> 
> should be two steps?
> 
> NDMA | RUNNING - vCPU stops access to the device
> NDMA - halt all MMIO access by revoking mapping

No, NDMA without running is equivalent to 0, which is the next step:

> >   0 - Halted everything

Jason
