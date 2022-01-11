Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B569948BB05
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 23:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346671AbiAKWxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 17:53:14 -0500
Received: from mail-mw2nam12on2085.outbound.protection.outlook.com ([40.107.244.85]:9121
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230248AbiAKWxN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 17:53:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixQF6K9XXNFHLSUY+x00LdwOOiFMxrenZ4Bf1ifZpzBC8/oH21CyVLgV1bdPJF4ZMTyyOEIpRnhyl1wmphF5i0aHrwu5ni3dFV1iFqWQWsl73EgRlgRLt8outWBlWDrpy3o+fCd1aujWXgat4eq+1vnvGSLheaVmSWrcuqSsrt+b77HF48FbnbdbmQMWToUipa+xPlBRbDUkNE4fIpreF0/d9pz7/qFrPJt1EPWRB17Pzyng6B4aeTb4kSktu6djAOwi3ft/wVA2WYbc95QInoeiirx/BPz/JUgFUuTvxXPnc35UFwgJIrndfsSNJfO5k3pBNZjxQIV4wmRkS3IWoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nMKftnEg/RHkK1nzGjHy/1e045HRdkALlFyl7w6+6A0=;
 b=k7X4untJ+Gtv7jHlBTg72ZBBV9+5EYv1T58V6LWs0YqXs5NzVMZJksU5hc6yZka4BYE9gCmsn8GWv4IbdGFGqABxcTKPCo3Fkp1FlOTHRf+Mdjo3uZ7BfDBpemuWFSGskQZB3EZoyAMz7E3FO8fvbk1MaSUOOKPlFrU1wzQLiupMdyXtmVhz8ZLdxjJeev47nLoBTx0na2O6erxHzz+FB4Z/kdkLDStp2Iv4lm0MxftJQXxIGEPnbHgXz4hja+zaddELP4vZeSiXvof1Bkg5LShT//ltup2pTKho0qhyyAAZL16K+A7mOkoj7tCOKvU5BYPvGmp97uYHGcpGqH+AfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMKftnEg/RHkK1nzGjHy/1e045HRdkALlFyl7w6+6A0=;
 b=fCmSoR3oPi4t3aStW2krZdAP0E/hIcKv/cqq1Hgw0MP1Wa45kuS/wjHk6JcvHlUus67+OAX+80/Fnl7Y2JN1sthSdNPONjBs0EPKtsmW9hFFbHv8M5vquiy1PJVAFqglY0tQd8/MuTK4a0TC7x4A1QHrP/EBMjZRjHCMGPWGRjsS6Ku0OKQPnTnostkWGIkZK79EoFHIDLqCbxkwZmaqe7Pi7yHbCwMYVDmsAe7umvuffU/BYrgWj0FLxCa7RdQgA86D/6llOwDxLTVEgKQ+pVJ0hlNNGq4uYHJ37MSX6ptRYcfB3WafuQHN1XiWVNQzfAdRR4YVJhaHHZVJDc4rAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5224.namprd12.prod.outlook.com (2603:10b6:208:319::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Tue, 11 Jan
 2022 22:53:10 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 22:53:10 +0000
Date:   Tue, 11 Jan 2022 18:53:06 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220111225306.GR2328285@nvidia.com>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <20220111004126.GJ2328285@nvidia.com>
 <Yd0IeK5s/E0fuWqn@casper.infradead.org>
 <20220111150142.GL2328285@nvidia.com>
 <Yd3Nle3YN063ZFVY@casper.infradead.org>
 <20220111202159.GO2328285@nvidia.com>
 <Yd311C45gpQ3LqaW@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd311C45gpQ3LqaW@casper.infradead.org>
X-ClientProxiedBy: SJ0PR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::26) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91b7bf59-9333-4105-6d58-08d9d55523f2
X-MS-TrafficTypeDiagnostic: BL1PR12MB5224:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB522429062807DEC17CDCA368C2519@BL1PR12MB5224.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2R8z0iunW8YfwBJJSkrCkT2mKPY4VBP3JKV8iMVW3k+AOsKIpfGaB5uGn2ogG4eR+sKjJSIA8Doh5YXGc6P3gBBZRM1LSzw3jlH6UGIofDRQVBUCoyqEwBjCYwDNuhMo1ykH4zySIz6rTkPb58Ega/zPzQKZzd5tBxKhbWxnxi3bZHG5BxTI/uGF88ZKQ/sf77Vqbj9Ia21shIIOHdKzo8fPvmfDwQtQi3FXfcIrLNj9x+wA5qf13msWlmlPZo8hv5HwyY0mE1/K2JssNtKHbcD32OAY39qoCoKfnpEESsyO1wlKGgHONJ6CH3GKIIjq29MlLCzmI+HM2BY1ZuEJKqTLY3+xeNcT01Rck1K8ULiyliALQ8JVEG5NklrSr39QZNmsyli4DzB5stLYtU0d93LW5RQ4Vuay6RMRiukL+AMpTA1J1HgH0F9+0W68yXZgAPRxKS3kD3u5o2DoU0zWkEaF1S5G33c0u+W1CWGATLudPbhz2Gmh+YrsK+tB6+Q2jiVnQ1V977+YF5fkfEZi+EWtrJz7ItNW52iptCoCGxzFIW+najBGdINHOEC7d6D2skxURCQCChLEqU8LWlCjb49QAqIm7PgJxeiM2jpA1+Jj8zsZEfWQmkf46iiBaAa1JkI9ESTiVrEiWDdAwkdr1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7116003)(38100700002)(8676002)(3480700007)(2616005)(6486002)(186003)(54906003)(5660300002)(2906002)(6916009)(86362001)(83380400001)(6512007)(4326008)(33656002)(316002)(1076003)(66556008)(36756003)(6666004)(26005)(6506007)(8936002)(66946007)(66476007)(508600001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KO6hsjUpW/ExHD7kn51bGtm0gaeY377DapWZM/nrRAq4rica1rnb2sgtKcTK?=
 =?us-ascii?Q?bmJ2aS3JKfIw/MeTxOEv92poosUcPQ0BXNedLh38ebebjoxy8QIt4Nj5wLW5?=
 =?us-ascii?Q?18y0Y2kQ9yI0PxwBYVlyY/DyXaAWRekegfBstsyoTnu8Qo0D2Anft5x1j6ps?=
 =?us-ascii?Q?Z9rA3WXsC9Zvxxc+wBb2wE9lc2HzsMApn3mDV09jMvOikg7JZdmdKTyHhLDu?=
 =?us-ascii?Q?ja+zPupyH4/gwJ4W4EY9nl6Hp2n3sxKxUC72O0/kkHZUpO5Sr5yKZQlvipjo?=
 =?us-ascii?Q?wCgoqMKIpUhZATJ/jBryZCpfZXpQShkeGmokyJlO+7owHt39FiDBVwnK1+2L?=
 =?us-ascii?Q?AExfMEf81oOIW2xRiNInDE8o53ixA3y+f0ONMEbdpW+YbM6bJNJw3T6PX0u1?=
 =?us-ascii?Q?ZMmMP+vmvzkMl+tK7z9PNItFDCYWFuVwvpyWF8koAHkUoRVuIqEWfDSvqBCt?=
 =?us-ascii?Q?ZCndHQoirII0/8ookcnVs2owzIn6VIvve1lQhzytcKP70VzCrRTeZr8Ld8o8?=
 =?us-ascii?Q?5dTt3jKYOvCLfHznyjK8KcTaz3/ayQvEvyr9xCoXPp8CzFV29Yv3daOhYujb?=
 =?us-ascii?Q?JkND+ut7RyAHSlp3kMFbPjISvkZHWeW+EAGelFaykkxcrMJhHMz6Y2ctt9RO?=
 =?us-ascii?Q?YmJSUqNwq/2voGLnlUa+wBuVQKoAraIayVhXsMW/4LMPTAsi2Nhymnp1kQbo?=
 =?us-ascii?Q?QLEUPHhio32wypk6sTvA4Y0iVOKPNBXo8LusHmMtqFiBfbymGMAlvQdWhmEj?=
 =?us-ascii?Q?eqiFbJJBMWuI3MbZ30Ak0cmBy2w+J4UTJ+JQPs0s67/+0MTfUCE0f31JHhBp?=
 =?us-ascii?Q?NIXQssEEZDwxtw/+6I7gFk8OdZVJ/7WLBsHXQtHZ4IA1dyrarCYamf+xXAMJ?=
 =?us-ascii?Q?Hlgaz2M6r6Wr1F3Hl+4W64p0xpFXp37uJOfne3bVW4V6AQdzZ++p+eScmb+Z?=
 =?us-ascii?Q?WGUWymKGh68ZFdN4gR5msCH9X4q+FYcqubITa7Zu9y2UXaQdtkya2DA5h0hS?=
 =?us-ascii?Q?h8nt0GaqjYLjGsLXDL/tklbYeqKXpjZiGzEt9cdNeQBhwo0VMouUV7L1Xsny?=
 =?us-ascii?Q?bVeHA13uBYH0+Rz0wPmfEAOJx7XavMTBPj0kWacvcab8ctR0f759Yxhrz0xp?=
 =?us-ascii?Q?TdXGKPfw80YiJHs3I5kNfwZrETfGoND83R6wd1vdYvexAd6mgfhQVaKw0r+R?=
 =?us-ascii?Q?MurrcGg5K3KJW/jUPm7iH17YsMaUUzgDa6aPd5/8pT1rFy7YM4JaO0lCDrIl?=
 =?us-ascii?Q?wvp0vP4oS1kebbwTuCATUqldVriCYGp7PdWGwdfhyYC+iGW2jRnriUDMDWAp?=
 =?us-ascii?Q?pcSZVISfRTF1tHk8i0ZLVJuNuke17lyRfjbRGGPO1imtZYBvYcTSi1i2RBfp?=
 =?us-ascii?Q?vVDiM9BeqeccWn6HUS8O3mOyy5WkB6LinzzlXEup9+/L2UviT1LXwciNoiMz?=
 =?us-ascii?Q?9BPZjbb5h/enawIL5wchPMmNBmjRaystmh7vCYJIhmBg+dLj3bD4EHoRgcFw?=
 =?us-ascii?Q?zBDZD8NsNdEw5qVqHQdYBKmyC24kuApE40/wWbr4bcD7eLI5UthkLurNV56+?=
 =?us-ascii?Q?WOWpIvkp4BKzsV9ir5M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b7bf59-9333-4105-6d58-08d9d55523f2
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 22:53:10.4474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OTJadnK+uuL/mk2IK/Al+zl03eeC8oEz+V0SQ5n/rseS6N4BmwPN7DMIGlUSjDEk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5224
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 09:25:40PM +0000, Matthew Wilcox wrote:
> > I don't need the sgt at all. I just need another list of physical
> > addresses for DMA. I see no issue with a phsr_list storing either CPU
> > Physical Address or DMA Physical Addresses, same data structure.
> 
> There's a difference between a phys_addr_t and a dma_addr_t.  They
> can even be different sizes; some architectures use a 32-bit dma_addr_t
> and a 64-bit phys_addr_t or vice-versa.  phyr cannot store DMA addresses.

I know, but I'm not sure optimizing for 32 bit phys_addr_t is
worthwhile. So I imagine phyrs forced to be 64 bits so it can always
hold a dma_addr_t and we can re-use all the machinery that supports it
for the DMA list as well.

Even on 32 bit physaddr platforms scatterlist is still 24 bytes,
forcing 8 bytes for the physr CPU list is still a net space win.

> > Mode 01 (Up to 2^48 bytes of memory on a 4k alignment)
> >   31:0 - # of order pages
> > 
> > Mode 10 (Up to 2^25 bytes of memory on a 1 byte alignment)
> >   11:0 - starting byte offset in the 4k
> >   31:12 - 20 bits, plus the 5 bit order from the first 8 bytes:
> >           length in bytes
> 
> Honestly, this looks awful to operate on.  Mandatory 8-bytes per entry
> with an optional 4 byte extension?

I expect it is, if we don't value memory efficiency then make it
simpler. A fixed 12 bytes means that the worst case is still only 24
bytes so it isn't a degredation from scatterlist. 

Unfortunately 16 bytes is a degredation.

My point is the structure can hold what scatterlist holds and we can
trade some CPU power to achieve memory compression. I don't know what
the right balance is, but it suggests to me that the idea of a general
flexable array to hold 64 bit addr/length intervals is a useful
generic data structure for this problem.

> > Well, I'm not comfortable with the idea above where RDMA would have to
> > take a memory penalty to use the new interface. To avoid that memory
> > penalty we need to get rid of scatterlist entirely.
> > 
> > If we do the 16 byte struct from the first email then a umem for MRs
> > will increase in memory consumption by 160% compared today's 24
> > bytes/page. I think the HPC workloads will veto this.
> 
> Huh?  We do 16 bytes per physically contiguous range.  Then, if your
> HPC workloads use an IOMMU that can map a virtually contiguous range
> into a single sg entry, it uses 24 bytes for the entire mapping.  It
> should shrink.

IOMMU is not common in those cases, it is slow.

So you end up with 16 bytes per entry then another 24 bytes in the
entirely redundant scatter list. That is now 40 bytes/page for typical
HPC case, and I can't see that being OK.

> > > I just want to delete page_link, offset and length from struct
> > > scatterlist.  Given the above sequence of calls, we're going to get
> > > sg lists that aren't chained.  They may have to be vmalloced, but
> > > they should be contiguous.
> > 
> > I don't understand that? Why would the SGL out of the iommu suddenly
> > not be chained?
> 
> Because it's being given a single set of ranges to map, instead of
> being given 512 pages at a time.

I still don't understand what you are describing here? I don't know of
any case where a struct scatterlist will be vmalloc'd not page chained
- we don't even support that??

> It would only be slow for degenerate cases where the pinned memory
> is fragmented and not contiguous.

Degenerate? This is the normal case today isn't it? I think it is for
RDMA the last time I looked. Even small allocations like < 64k were
fragmented...

> > IMHO, the scatterlist has to go away. The interface should be physr
> > list in, physr list out.
> 
> That's reproducing the bad decision of the scatterlist, only with
> a different encoding.  You end up with something like:
> 
> struct neoscat {
> 	dma_addr_t dma_addr;
> 	phys_addr_t phys_addr;
> 	size_t dma_len;
> 	size_t phys_len;
> };

This isn't what I mean at all!

I imagine a generic data structure that can hold an array of 64 bit
intervals.

The DMA map operation takes in this array that holds CPU addreses,
allocates a new array and fills it with DMA addresses and returns
that. The caller ends up with two arrays in two memory allocations.

No scatterlist required.

It is undoing the bad design of scatterlist by forcing the CPU and DMA
to be in different memory. 

I just want to share the whole API that will have to exist to
reasonably support this flexible array of intervals data structure..

Jason
