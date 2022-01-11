Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0A548B030
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 16:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243555AbiAKPCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 10:02:22 -0500
Received: from mail-bn8nam11on2077.outbound.protection.outlook.com ([40.107.236.77]:40439
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243685AbiAKPBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 10:01:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jq+/G8hYD8R50wnR3i4Z9oxgO4Jdf1xsxsmdWvotKDpmy/nB4g0gVpb8ppiyItGEO9OkoXq976K7zMjFa67rrEyausc86nJo3QV30/T3csiup2tEV7z6SABdCV4g0gDeENGls2tvugufyKwxQ9Tax8dSi/R7jQvYA32igJW2aztrOAEbJ3ihDWJ1+NK1vIrt8fOV+iC1QuZV9O2Hbo93GYkCfHic9ZBo/ZXtb/fv6nf8aHM+g4A7ybpY1cqDp1SBQtSo57Hqr2UMvMn4+vdliaZ0jmqrFMCyhNvj3bOaDpj69KTQ8bTn9j6ewVG5h5nUfqgJGftyRNUNafUYA5kF+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQjKVlMnu0Ru3GoOr7mMmQQWUkdJlkntvr31BEo2KB4=;
 b=BJayLNifTml9Kty9+xBPL91m36Vy0N4BJyTjfGBXxh2MPJL6ot2hUG1I4g48rsrDZFX1CBQp3JkKunWiQp6ATecAsQ3BZJeY3kJXLblWPuCwX/odLh2JYN/vLkjScQftUPMDau7EyD5JrNc6rx3GggvlCkNPdR6D7lXVhTFR69vv3sWB0rVRDS225s4BkUsZAfujVOee6waEJ7XPPRrFRTN3L9OuaPCcBQ04Ll1KiCR+/a/tUPSv9syDjlI8mSRKRPa0pK3OE9kM5hkCfOIQn8d/h7kT6a1zpW/GFltHS2xk7NRF6bFeMLzyFWMgEesa8pMZQQwMnGA5TWw0EmRnog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQjKVlMnu0Ru3GoOr7mMmQQWUkdJlkntvr31BEo2KB4=;
 b=JWk8wNSHmiQ5iGQcqB5zccOCKQl6dQuovRGJN5pXYu2vgq2Dbro4b/DmvRTMXAhOjCZ3i8AFO5z7vaNMjDFJxGv1X/6e6HkfiYy15E9l41WtrB3Ci0O3oqwpjknujrQE84pNRG6rwRJtkuu1AIrgkAcMUrjsjyl/DoiysXJJKmfM/6TfQ5O/XORXfiJow+MQK7XBvyGsKkfGXtfGLFYXhtXms+zJUIs0HvSf1Nm4WDDZwBOZTm0JC7tTj774wY4ZZ7AQj5zwJiwmMKio0V1mCRLxGqmAsKcEeZR6+sLIgwg2LYnrqEhKjCvzJ2cHcsJYZTtfINrmUOXhfBSk9UCr5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5128.namprd12.prod.outlook.com (2603:10b6:208:316::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Tue, 11 Jan
 2022 15:01:44 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 15:01:44 +0000
Date:   Tue, 11 Jan 2022 11:01:42 -0400
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
Message-ID: <20220111150142.GL2328285@nvidia.com>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <20220111004126.GJ2328285@nvidia.com>
 <Yd0IeK5s/E0fuWqn@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd0IeK5s/E0fuWqn@casper.infradead.org>
X-ClientProxiedBy: BL0PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:207:3c::25) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f3f420f-9c2e-41cf-6c99-08d9d51347eb
X-MS-TrafficTypeDiagnostic: BL1PR12MB5128:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB51287DD02D7599F5879764E3C2519@BL1PR12MB5128.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ttJouvQPMO/u8EFuB+T6LshiempvI7l3TGPi9Csp2wGoTW/pGnQU06EH9pqAVb0yMdbYwKIW1sSI7yf0QonW5Nu7wjYW0MpDUSl9ILqlPREdfpB1JYGQ+sA4S81hSduc7VqASCEtX014kXLSRCeGmvDFHT6ONOJhQU90UqRE/M0EIJwQz9KtuFIxga3bYgfh2V0nEQDUGjmO1l4KSzhpgsH2CV8/9WpaLNlXfwZ95EqcqF4zxKcN/WbCwbziZJEZw+tW20J7s5ox5nzuLGfP/Zqd4E3rwf1iiJ7caRVWOYBoXGiQqGbjuWxXJAV3zx/ZKGAKLCSt0kaD29KCKufDbJ0j5I7MkamRbKEBbDmgTsZI/8xNPOIyGhiWEBVe5qgESvxTal0gbNCLKBr62tafwJg1uXkKX3UxCnWKJIEKn+FrMkDKASyiYaFTfWKj2pt8LmtTqGJimnVSwbfCZf3Kwdb26pPDfYR4wE4yzw4KkmwkKL/EgCZ/Zr9gtzpdQTRmLzeFB3ZOGtJuHnR7ZlOTD9VA5Mamefbm2aooz1PWwqhe6T4lHVfQ6mVzmj07thEJpTInjoE5euluPp2MnvhZVyyANFg/mnv8FUUjxMb/tZ3sUXuBlyWDsqlGRekKDk0qJvsqYTX9TkwKNOsPEWhMyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(316002)(66476007)(6512007)(8676002)(6506007)(26005)(54906003)(186003)(7116003)(8936002)(66946007)(6916009)(66556008)(6486002)(83380400001)(1076003)(38100700002)(5660300002)(33656002)(508600001)(4326008)(3480700007)(36756003)(2906002)(86362001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bk0D/tVpvXuefE8enUQt6HPP3zOHIf0LsSsmtW3Q8D3Wo7V0MHPceZB6SjF0?=
 =?us-ascii?Q?ZfBL1BtceFo/W9DLzk5WYjkUBVUBVH1hvdQNqfoRF4JFZi/Pq1LTXkWZbNxj?=
 =?us-ascii?Q?I6TWUq4co3CYKL+ngEepsNNq/YwX6aVGfgwSPrZCnYH/XWTgmBoEBkypRst2?=
 =?us-ascii?Q?n1eQntPYqRKxWT+zDYiEtnhm4OlaQYY56ZGpS6TpE8OXcusm4RDyyr9QEgjF?=
 =?us-ascii?Q?NVwwYb2sEz+AiF2AVPZ0U8MmlLJu3qWjhny4NW6fkakf9SnfD3nX/Lq4cUv7?=
 =?us-ascii?Q?sZI+PgWsreFQXn4H6Kp3UvvJPMqVoLYo3sEDRy0EENkx991kl6LCagZI2LTQ?=
 =?us-ascii?Q?amil0+INxlKCG6KbFZu+Wh/bw2rkg5FF95g2UWB6gp6jxiShiL6H7Tvr8o03?=
 =?us-ascii?Q?UXvTux+Z1otP2IEB5VOH6UPOtjHM8EMYd7vrUYTXxMpyOhDnk5GTBrGhC1yR?=
 =?us-ascii?Q?eBmVbQ82cI475GGgAr48ZnSmhvG4eMBEVYqzosFuHqB67qZceg4QMobq6l9h?=
 =?us-ascii?Q?8XLF404rlS+eA1MenZ/ryR5krNNKXQINtW8hE+4b0FC6DHm7cIN7xAGOVuwA?=
 =?us-ascii?Q?EIERj+FJhDvuQsytCdX3wu0Fh+3fyaJ4Ko5Formb/FWfOb+KB6drUVQD6Gvr?=
 =?us-ascii?Q?WAp+3361ZMffWZU2JLNYDgAzjo86wKa/iMqAaUV7QDoVlWL+nPQ5izjih5f1?=
 =?us-ascii?Q?1WiTc/7Kq+uQA5vrmDI5i8b7hsuMJ1+exq/DRvWu+J6lF+u3KitMnq0auCgF?=
 =?us-ascii?Q?2R8qOrvfimMGK6LFjziNijUjYJgGM1AEjIszC5Ksm4UnkL3xCk/zNEc1HjOH?=
 =?us-ascii?Q?ePz8cXNFjYd2NVVOnSU1xsF0tAG3spT/eBJ3vdriVE6HQO8KegC3ZxJgDf1A?=
 =?us-ascii?Q?upbfDZwBezzu7QFIoJKhWdc3wilEdwBUUJ1QmTY073cCIX3+gNaUXl+89A2q?=
 =?us-ascii?Q?W/l1IUr+1aAKngJQDI5wLnuN4cxBU5VVLAf3DL3zZpmckQQazJ67gFkRyFnw?=
 =?us-ascii?Q?9YovQPXaMYLlH5SYzBCQrRAO0viq+KZ10ni+fx0lTkDJVIVXjbgbR9cJ0izF?=
 =?us-ascii?Q?QBeGAewFOYqiF6jznhbBgRBdplMrAYSWHaStCvuAlOi4C/hqQnNEXDHplSAQ?=
 =?us-ascii?Q?PM+GIBA0UjKbqR4vxSBSEtR2PlXZUOH+46Qe32qPZxXDyQP8A92Gia5uxrzX?=
 =?us-ascii?Q?YA+wTRWFxCMBpsS6V1PMdfl7zwutIuXitleXf7QHWgi/fVe6IwrQ2BcVJmrO?=
 =?us-ascii?Q?9rlGpBp0IH7YsWMtaAqkMZCxLgRgQAcekGB6AQPute4s/7at5AIAvjuDDG5X?=
 =?us-ascii?Q?dav/mQAvAnBUbQwfPGpQSTUo8P0F8hpHRG0vrTH2CE+/YtTA/T5I2EMpwiis?=
 =?us-ascii?Q?bDZuQDz+cqlUpec10uLfZuwHblmEb8HKxgZ4tsDcCZC498f7QSMe40ilYO2T?=
 =?us-ascii?Q?P/nmIE3E7KyNWjmlRaybFbX/J4TfQk3VbMRM00JSa09EHn2Ab/lP4b3wYu76?=
 =?us-ascii?Q?3s+RBqUqCTKhU7LM2gBSduPtiqO75RwxtdcqXwzJuLlKHovuzQVpvBmGg4sy?=
 =?us-ascii?Q?3Pd0djKerawm67aU7Cc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f3f420f-9c2e-41cf-6c99-08d9d51347eb
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 15:01:44.0622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: USCOoFE2AchAZtYIKyxp8tB687u4UPgh5lkqRifdeZk2JrgOzcTT9kXmDivNwzSI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5128
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 04:32:56AM +0000, Matthew Wilcox wrote:
> On Mon, Jan 10, 2022 at 08:41:26PM -0400, Jason Gunthorpe wrote:
> > On Mon, Jan 10, 2022 at 07:34:49PM +0000, Matthew Wilcox wrote:
> > 
> > > Finally, it may be possible to stop using scatterlist to describe the
> > > input to the DMA-mapping operation.  We may be able to get struct
> > > scatterlist down to just dma_address and dma_length, with chaining
> > > handled through an enclosing struct.
> > 
> > Can you talk about this some more? IMHO one of the key properties of
> > the scatterlist is that it can hold huge amounts of pages without
> > having to do any kind of special allocation due to the chaining.
> > 
> > The same will be true of the phyr idea right?
> 
> My thinking is that we'd pass a relatively small array of phyr (maybe 16
> entries) to get_user_phyr().  If that turned out not to be big enough,
> then we have two options; one is to map those 16 ranges with sg and use
> the sg chaining functionality before throwing away the phyr and calling
> get_user_phyr() again. 

Then we are we using get_user_phyr() at all if we are just storing it
in a sg?

Also 16 entries is way to small, it should be at least a whole PMD
worth so we don't have to relock the PMD level each iteration.

I would like to see a flow more like:

  cpu_phyr_list = get_user_phyr(uptr, 1G);
  dma_phyr_list = dma_map_phyr(device, cpu_phyr_list);
  [..]
  dma_unmap_phyr(device, dma_phyr_list);
  unpin_drity_free(cpu_phy_list);

Where dma_map_phyr() can build a temporary SGL for old iommu drivers
compatability. iommu drivers would want to implement natively, of
course.

ie no loops in drivers.

> The question is whether this is the right kind of optimisation to be
> doing.  I hear you that we want a dense format, but it's questionable
> whether the kind of thing you're suggesting is actually denser than this
> scheme.  For example, if we have 1GB pages and userspace happens to have
> allocated pages (3, 4, 5, 6, 7, 8, 9, 10) then this can be represented
> as a single phyr.  A power-of-two scheme would have us use four entries
> (3, 4-7, 8-9, 10).

That is not quite what I had in mind..

struct phyr_list {
   unsigned int first_page_offset_bytes;
   size_t total_length_bytes;
   phys_addr_t min_alignment;
   struct packed_phyr *list_of_pages;
};

Where each 'packed_phyr' is an aligned page of some kind. The packing
has to be able to represent any number of pfns, so we have four major
cases:
 - 4k pfns (use 8 bytes)
 - Natural order pfn (use 8 bytes)
 - 4k aligned pfns, arbitary number (use 12 bytes)
 - <4k aligned, arbitary length (use 16 bytes?)

In all cases the interior pages are fully used, only the first and
last page is sliced based on the two parameters in the phyr_list.

The first_page_offset_bytes/total_length_bytes mean we don't need to
use the inefficient coding for many common cases, just stick to the 4k
coding and slice the first/last page down.

The last case is, perhaps, a possible route to completely replace
scatterlist. Few places need true byte granularity for interior pages,
so we can invent some coding to say 'this is 8 byte aligned, and n
bytes long' that only fits < 4k or something. Exceptional cases can
then still work. I'm not sure what block needs here - is it just 512?

Basically think of list_of_pages as showing a contiguous list of at
least min_aligned pages and first_page_offset_bytes/total_length_bytes
taking a byte granular slice out of that logical range.

From a HW perspective I see two basic modalities:

 - Streaming HW, which read/writes in a single pass (think
   NVMe/storage/network). Usually takes a list of dma_addr_t and
   length that HW just walks over. Rarely cares about things like page
   boundaries. Optimization goal is to minimize list length. In this
   case we map each packed_phyr into a HW SGL

 - Random Access HW, which is randomly touching memory (think RDMA,
   VFIO, DRM, IOMMU). Usually stores either a linear list of same-size
   dma_addr_t pages, or a radix tree page table of dma_addr_t.
   Needs to have a minimum alignment of each chunk (usually 4k) to
   represent it. Optimization goal is to have maximum page size. In
   this case we use min_alignment to size the HW array and decode the
   packed_phyrs into individual pages.

> Using a (dma_addr, size_t) tuple makes coalescing adjacent pages very
> cheap.

With the above this still works, the very last entry in list_of_pages
would be the 12 byte pfn type and when we start a new page the logic
would then optimize it down to 8 bytes, if possible. At that point we
know we are not going to change it:
 
 - An interior page that is up perfectly aligned is represented as a
   natural order
 - A starting page that ends on perfect alignment is widened to
   natural order and first_page_offset_bytes is corrected
 - An ending page that starts on perfect alignment is widened to
   natural order and total_length_bytes is set
   (though no harm in keeping the 12 byte represetation I suppose)

The main detail is to make the extra 4 bytes needed to store the
arbtiary pfn counts optional so when we don't need it, it isn't there.

> > VFIO would like this structure as well as it currently is a very
> > inefficient page at a time loop when it iommu maps things.
> 
> I agree that you need these things.  I think I'll run into trouble
> if I try to do them for you ... so I'm going to stop after doing the
> top end (pinning pages and getting them into an sg list) and let
> people who know that area better than I do work on that.

I agree, that is why I was asking for the datastructure 'phyr_list',
with chaining and so on.

I would imagine a few steps to this process:
 1) 'phyr_list' datastructure, with chaining, pre-allocation, etc
 2) Wrapper around existing gup to get a phyr_list for user VA
 3) Compat 'dma_map_phyr()' that coverts a phyr_list to a sgl and back
    (However, with full performance for iommu passthrough)
 4) Patches changing RDMA/VFIO/DRM to this API
 5) Patches optimizing get_user_phyr()
 6) Patches implementing dma_map_phyr in the AMD or Intel IOMMU driver

Obviously not all done by you.. I'm happy to help and take a swing at
the RDMA and VFIO parts.

I feel like we can go ahead with RDMA so long as the passthrough IOMMU
case is 100% efficient. VFIO is already maximually inefficient here,
so no worry there already. If VFIO and RDMA consume these APIs then
the server IOMMU driver owners should have a strong motivation to
implement.

My feeling is that at the core this project is about making a better
datastructure than scattterlist that can mostly replace it, then going
around the kernel and converting scatterlist users.

Given all the usage considerations I think it is an interesting
datastructure.

Jason
