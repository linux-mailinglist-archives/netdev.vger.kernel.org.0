Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F053323164C
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 01:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730660AbgG1Xi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 19:38:27 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:31786 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbgG1XiY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 19:38:24 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f20b6ea0000>; Wed, 29 Jul 2020 07:38:18 +0800
Received: from HKMAIL103.nvidia.com ([10.18.16.12])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Tue, 28 Jul 2020 16:38:18 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Tue, 28 Jul 2020 16:38:18 -0700
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 28 Jul
 2020 23:38:09 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 28 Jul 2020 23:38:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SByggn2OGOuW7p7g3bznqFp2WH5U9n7yWvNAu0quasNvMEKcxrGbCeROephcpWEk/xzTbEAkL4nzcA1HetFpViRHOHLlBAPblvSX+Migtk6vetL0l5XHJjFZ9w793q/sHHW8H2xck1Hq6RBVqPAkXukPDbNGESykzA/Hs/guaDJCCjiKVoii+WvqLV2+APhm68b8o4dpUU/p6ErcbkkYHjZq+lwGqbwmtYMMc+R8FNo/dms1oTy07lA4jn1BGB9ODEAqVLT6s5b3aqECVfn71us5kNL9RaNwLPPgYtFBa7cVbfGuXQs3t3I+bmafIoi4eER2DQvf3OD2iVgkSXg/5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifcrXFNqyZsihRlJlYEi54uC/ULzJvQ/LLQ4wnSktko=;
 b=DicsLbJhvMQpRTE5mgBXtvtDHAmeQeNvwfVFSFhqId3U2+x1N/JT+qp3yGrzI0cD+/SmrDY4gX7O3einGcgaQJxoDjxnGG8ig1rlz3d/umDabfb9p5zh+OP8zIzOJ4Eq95JEd9TfLdUEm9LcUFBohPfUMnmR2gMribVW7/6FHnP5DJc1S9uB9vwIdkA7ffgt27JJGyNBZbesSnStykB/8uFxM4hfcDBzPD/jI8rvdj4HCsBB9M9g5btQktFMQE2NKttS3cCoIMWGDzanaaahzs3H7v6zskdltYeEBc86cI5PKux3YTp4nliBj4NoaaUwCRKUhjfMyKkdfTu1VwLLrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2583.namprd12.prod.outlook.com (2603:10b6:4:b3::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 23:38:07 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 23:38:07 +0000
Date:   Tue, 28 Jul 2020 20:38:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     Christoph Hellwig <hch@lst.de>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>, <robin.murphy@arm.com>,
        <akpm@linux-foundation.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <willemb@google.com>, <edumazet@google.com>,
        <steffen.klassert@secunet.com>, <saeedm@mellanox.com>,
        <maximmi@mellanox.com>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <borisp@mellanox.com>,
        <david@redhat.com>
Subject: Re: [RFC PATCH v2 21/21] netgpu/nvidia: add Nvidia plugin for netgpu
Message-ID: <20200728233806.GC16789@nvidia.com>
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com>
 <20200727052846.4070247-22-jonathan.lemon@gmail.com>
 <20200727073509.GB3917@lst.de>
 <20200727170003.clx5ytf7vn2emhvl@bsd-mbp.dhcp.thefacebook.com>
 <20200727182424.GA10178@lst.de>
 <20200728014812.izihmnon3khzyr32@bsd-mbp.dhcp.thefacebook.com>
 <20200728181904.GA138520@nvidia.com>
 <20200728210116.56potw45eyptmlc7@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200728210116.56potw45eyptmlc7@bsd-mbp.dhcp.thefacebook.com>
X-ClientProxiedBy: MN2PR16CA0006.namprd16.prod.outlook.com
 (2603:10b6:208:134::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR16CA0006.namprd16.prod.outlook.com (2603:10b6:208:134::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Tue, 28 Jul 2020 23:38:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1k0ZAc-000jOK-5j; Tue, 28 Jul 2020 20:38:06 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c1e294e-936a-405a-0c7f-08d8334f47ce
X-MS-TrafficTypeDiagnostic: DM5PR12MB2583:
X-Microsoft-Antispam-PRVS: <DM5PR12MB258330C57B300BAD4EA6A6B9C2730@DM5PR12MB2583.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cdj+keg0XQKWUikwdtDL2cqvd+rtUJVPbzJp3nrOERn1jbzauco3gx0onk9l9DTP9l6FCQV8pwNH+jvs5eWReTejpfknMuc8LSz4qDe02O5mfs0XpckqpzPbXIIfiuvgQdt3IP/3ck08unQCBUwK3GHKeVUYlJznrBj2xlEzX5qFBJO92E3Y4oEHPcYscdM/6ZXV6SgmdItnG8CgnLXTchDSdXGhfJwrSjtU8qdR3WAvP2M+KPx8bDvvtWKAvmLwDmVQEhiuAhfIj8Xi/QGAOLSj/gWtVOm37MRcjgKjRe7XLNgG0oF5PZvLKnaxcTCUX3x+0DQwuRWYPa581h4sLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(33656002)(36756003)(426003)(8936002)(1076003)(316002)(478600001)(2906002)(6916009)(8676002)(66476007)(5660300002)(66556008)(186003)(86362001)(83380400001)(9746002)(9786002)(66946007)(2616005)(26005)(4326008)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gxO7wFQ/UMjejBX2cUY3DqKrzjTuzdq6FGGBY8ZakmZJ4zLcptiWstWHtjnDOrvn1lxAgAR820/eHPIZh+68TwchcT++QsjbDADLpnjrFSsZa/2fp1ZBp8G9z3LTAkbqGB2mi01hi/m2OgoEq37HA9CgxzSLiT2O5qpzWaLS2E2TuIzfb6gQaTYE6JjXEi+y4LGQsJ4w7PUNBeGthjbb+IulzQsulsVdKZd8gZ0BknBQzsmpZKcWOlWFrfc2xxmu9sE88891B7pCFvhHxQiebsLM2uFppNvRYAnXPkZKMCk+edZyOzLZwqMaGH5xmPtU0g2E2RgGh70/m/qXfxKZ757xjS01ZazosSLhFHfcizmAZfgYXWp+8QngxaqXqCjKODJI2xYSdHsn/zoZT79r2ArEtVoE2joyLIpIwJMi9tYFqP0F0wK8JpDHnLd3/XdcOGZe7Wu/lGWRiG+O5WXqFusamisfk98Bs8sa2Nhkjfo=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c1e294e-936a-405a-0c7f-08d8334f47ce
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 23:38:07.6891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rdg3UTJMbezg3QZl5kYNO0G1C13ccRekAs2C+lgTAYQqubAAyfeZMvZAg/KX4Oog
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2583
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1595979498; bh=ifcrXFNqyZsihRlJlYEi54uC/ULzJvQ/LLQ4wnSktko=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Exchange-Transport-Forked:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=IA5og8OhdfroYs+AolxqREsHkkq//KzC5lX+IkfAdrqsXKheEI+NZyGO8jNYuWT+d
         Iy+RqAx+O/UesHscfj8ELiCD3gcUMjz9V1+nadFUfDWuOsv80nVCso0d51Yer0LAbP
         bNAL2cjTzP0mVh6i7Eko3GpTaC/fBiTbQdKYOSq4K2L/y9SAS/r7PVYbstYECbzY3F
         a6R4gCc1UPpS8ddVv1AAHxHhLB3AzUYW3A2SZfmp7YR5kQQsH4pmLW9QXVSy3KjmDz
         oaw38c/78WzsRBOcOA9qPUtHh3pMv2tttoackaLI5No1vwDusUhemWIkQBF5adeDBt
         kCHgpHF91PZpQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 02:01:16PM -0700, Jonathan Lemon wrote:
> On Tue, Jul 28, 2020 at 03:19:04PM -0300, Jason Gunthorpe wrote:
> > On Mon, Jul 27, 2020 at 06:48:12PM -0700, Jonathan Lemon wrote:
> > 
> > > While the current GPU utilized is nvidia, there's nothing in the rest of
> > > the patches specific to Nvidia - an Intel or AMD GPU interface could be
> > > equally workable.
> > 
> > I think that is very misleading.
> > 
> > It looks like this patch, and all the ugly MM stuff, is done the way
> > it is *specifically* to match the clunky nv_p2p interface that only
> > the NVIDIA driver exposes.
> 
> For /this/ patch [21], this is quite true.  I'm forced to use the nv_p2p
> API if I want to use the hardware that I have.  What's being overlooked
> is that the host mem driver does not do this, nor would another GPU
> if it used p2p_dma.  I'm just providing get_page, put_page, get_dma.

Not really, the design copied the nv_p2p api design directly into
struct netgpu_functions and then aligned the rest of the parts to use
it too. Yes, other GPU drivers could also be squeezed into this API,
but if you'd never looked at the NVIDIA driver you'd never pick such a
design. It is inherently disconnected from the MM.

> > Any approach done in tree, where we can actually modify the GPU
> > driver, would do sane things like have the GPU driver itself create
> > the MEMORY_DEVICE_PCI_P2PDMA pages, use the P2P DMA API framework, use
> > dmabuf for the cross-driver attachment, etc, etc.
> 
> So why doesn't Nvidia implement the above in the driver?
> Actually a serious question, not trolling here.

A kernel mailing list is not appropriate place to discuss a
proprietary out of tree driver, take questions like that with your
support channel.

> > If you are serious about advancing this then the initial patches in a
> > long road must be focused on building up the core kernel
> > infrastructure for P2P DMA to a point where netdev could consume
> > it. There has been a lot of different ideas thrown about on how to do
> > this over the years.
> 
> Yes, I'm serious about doing this work, and may not have seen or
> remember all the various ideas I've seen over time.  The netstack
> operates on pages - are you advocating replacing them with sglists?

So far, the general expectation is that any pages would be ZONE_DEVICE
MEMORY_DEVICE_PCI_P2PDMA pages created by the PCI device's driver to
cover the device's BAR. These are __iomem pages so they can't be
intermixed in the kernel with system memory pages. That detail has
a been a large stumbling block in most cases.

Resolving this design issue removes most of the MM hackery in the
netgpu. Though, I have no idea if you can intermix ZONE_DEVICE pages
into skb's in the net stack.

From there, I'd expect the pages are mmaped into userspace in a VMA or
passed into a userspace dmabuf FD.

At this point, consumers, like the net stack should rely on some core
APIs to extract the pages and DMA maps from the user objects. Either
some new pin_user_pages() variant for VMAs or via the work that was
started on the dma_buf_map_attachment() for dmabuf.

From there it needs to handle everything carefully and then call over
to the pcip2p code to validate and dma map them. There are many
missing little details along this path.

Overall there should be nothing like 'netgpu'. This is all just some
special case of an existing user memory flow where the user pages
being touched are allowed to be P2P pages or system memory and the
flow knows how to deal with the difference.

More or less. All of these touch points need beefing up and additional
features.

> > > I think this is a better patch than all the various implementations of
> > > the protocol stack in the form of RDMA, driver code and device firmware.
> > 
> > Oh? You mean "better" in the sense the header split offload in the NIC
> > is better liked than a full protocol running in the NIC?
> 
> Yes.  The NIC firmware should become simpler, not more complicated.

Do you have any application benchmarks? The typical AI communication
pattern is very challenging and a state of the art RDMA implementation
gets incredible performance.

Jason
