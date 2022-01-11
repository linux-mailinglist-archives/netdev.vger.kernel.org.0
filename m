Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB2448B890
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 21:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiAKUWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 15:22:03 -0500
Received: from mail-bn8nam08on2054.outbound.protection.outlook.com ([40.107.100.54]:58413
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229593AbiAKUWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 15:22:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLKx75OY0AR3FZ0nomTos0EFeeO0vh/SlNUuCEq9lyLxwO5DLU3ptbkedbkAqkxUM90bCaH7iNGaImHWNgg8huMFpRYBpORUJIbmXHNYMqlsHm7jKohSmbPZXQ2FTj7aphHG4Q3NhcF67NQXB2/fB5ukmRWTlahYMfYUiCF7OcA/p7ukICNBz+sGWztFSIO/HbbFoj81OfVBUqIQcK5/XcfK8Ahg/YKCI+QkWTG66rT2RnL+u8oUovBGyp7B95gL0LYZnZBUiPV3TZzoZJPG99qFW9cPtTQ4LPWMqzaUW1nLkbzj6A7xFtqWCm2VSmUkonFU2b6tDDQopTe1+bGq8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6oht+wiqfW6CRF3bDMwGl53fP5YBrHGaZNGvocvRuBg=;
 b=ST9C8mKKE7g2Cv3NxGfSZx4XrXqrDgC4qiY8myQ5xXaDjqPC9F006bWMrVUJT6PQn/jt8huiOpe24ocXNHJ/pspZfrZjj7hEWzfZ9vRpVRVSYCiFc+Bp+H5tQfY1pEESI2xL02FZHex1N7MXGKz2lKt0++/aEUBJ5wXsTV96KYIQliRe8/tNALuMIWKjTNkuXIl5MQZZqiGaWvxYXf/9WlNXlDSmbnj/f9LO7C4HwXptRKKNWkiwbMP411a6nPmEFTolbtuS8p5TPzhgzVWnJclasUMjDnGi3VpfiDQpbFoJxTu07S5zwc8c69HmiOqCsOYSdse44HblANThXZG4JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6oht+wiqfW6CRF3bDMwGl53fP5YBrHGaZNGvocvRuBg=;
 b=S9ckaXblLadm5+eZMo3TiCEsRUvvic32uBmKEZKdzK4LH3qNMDOROrfcHT3HKVqjUfnBeeU8U/Ww4Mifd2GghF565NoZsSx7w3WXViDoFQpNaY756+pNki6cm9CcEaKNxiVkyKOKfv4ONE0ETLi5EnnV3ak6vaHgDutGIMGBxZOCiBTPh6oVloOENXJ2KO0j6ywKwgIF4QudmrLKg8cFlj2R1MtyqQmsn1qokJpNtgQpj2XUGv/80MAMAITuWXPo1zVE+PN41t5qs7i1JEMDAkrY6xI5QEbUKzDYQuj1BxtZBrx7u5SplAn1BDHSpWHAfGfVfOoponjD1ilLIEXh2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5079.namprd12.prod.outlook.com (2603:10b6:208:31a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Tue, 11 Jan
 2022 20:22:00 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 20:22:00 +0000
Date:   Tue, 11 Jan 2022 16:21:59 -0400
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
Message-ID: <20220111202159.GO2328285@nvidia.com>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <20220111004126.GJ2328285@nvidia.com>
 <Yd0IeK5s/E0fuWqn@casper.infradead.org>
 <20220111150142.GL2328285@nvidia.com>
 <Yd3Nle3YN063ZFVY@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd3Nle3YN063ZFVY@casper.infradead.org>
X-ClientProxiedBy: BLAPR03CA0061.namprd03.prod.outlook.com
 (2603:10b6:208:329::6) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86cee649-6012-4ee2-cdca-08d9d54005d3
X-MS-TrafficTypeDiagnostic: BL1PR12MB5079:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5079C95DCB4516856EE3F8DFC2519@BL1PR12MB5079.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SjShiEvefYjGR0Ya7cQ8/cfN25r/HixCcZ/Xc39/HRGe7kp9F2FooSyevxKzAUOQ1mNwJ3Ba4XlydFShRMHBypQ2YkGGzVbNCB0RGjRVBnncATRu95nefPgNmOPxzq4mQd0X+gRLHFg0qhVtrfl/RYawACmOy/5AzYYx7d0fOcEiX9FjMCVin7H07rwGK93WpSMjd9yAQcGDnL5G2jT36/luTnuGpbyRFpX1fEfk4gGQw07USyBWz94Nmz2RE5CAAGu+wkaNinLvYN8kpWATwe64mceU8c8nxXFGr5Njb7WTmyA8i4zyynyCkGpVzaYIOLJ4HzWTsFHnPbj53nFOUHKuj91MnRuEAxg8NPPnIR/4zez+X/sIn68APXcPsoMB/5EW7eJmicygPJXTe7s5sjDPWNBPNDLLjD2B49DltvL+FyfK4i6KVbAgygtMLtBIooB84Dzbt39Lwv/v8sKwqG5nvl02Xcy/jsekspB5z2eq6IvJFu1o5QwcN1SjbBCI1af5u6CnlZnpIDcPVizBcHiT3g2dk1hZp3PK4RJwAZ9z/gkt6rW8SW2m6YZSBli6czv/22WHAioep/kb5KYK3Rk4CHDb4ad4oWTldj68y/ZFqk1E8FGUv+ca0VCHJaYIi2Fctbcgwu1dCoE/lpfa+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(7416002)(3480700007)(26005)(36756003)(33656002)(186003)(6512007)(8676002)(508600001)(2616005)(54906003)(5660300002)(6486002)(2906002)(4326008)(38100700002)(8936002)(6916009)(316002)(86362001)(6506007)(7116003)(83380400001)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CYC5cwrammXBc/DJlwuGOF+oeRRaAq26J19ifEbS74jvDZNx6MT1NRQwLhaG?=
 =?us-ascii?Q?JERacSbchkwkIpfuLi/nt8x97FIuPDoR9G676rRAtXW7cZO55khcMeEVU4nL?=
 =?us-ascii?Q?JsqiCD1d/NMZFTHUQ4khnAFsf3NPTzxJMnomcr6ggI1HkiTYG+lvBMnUIh3F?=
 =?us-ascii?Q?iu7UUT1FNkJnUxPU34qaWW4muRGTeRPh/w38k5oxwfUnBZff+0hqwxtc+Qei?=
 =?us-ascii?Q?5U0CfBcarwZAGjFzh9L4r+2iSF4SXSyg5yQDNKA+u+j38fVOhU4TSv1ufYPg?=
 =?us-ascii?Q?6K/xJzOAuVj/whW9Rlp6JOfcDBfm2dNOFXZmBLototnz+vglTIqQP5PbSDYL?=
 =?us-ascii?Q?08ERMiVRuy+8U5Z6xogv6eYM7LU4ZxPRd63uhfCYq5MdEpnF5JCp2fIuY6cU?=
 =?us-ascii?Q?SIMMnPHa0iGiB1E0KaVYJdKC3vEHR5GU+/Bm2UqZ11W3SJWzhTFNTrzxM0IK?=
 =?us-ascii?Q?8kI+68DPk8tT/j4s7vvMQW8nAxchBA7nN5vzDwHXkkXCtkJ29KdoXI5y7mQy?=
 =?us-ascii?Q?pwe/8mMPgu7hCavxUmmAArk6L7YCaFbYDdyIyzu4hlEid5S3O/HIigB93zp8?=
 =?us-ascii?Q?O3HErkeLXDX/hLV9GntDtlopftxv5xn0nyhQl5aqNtf0C8D572U6TplCpEzr?=
 =?us-ascii?Q?gI8dtWKugzbE+/ZvevyAPx4cKhoIyZ5gtHOXjSl1huSSd+85YLd08Z8enU6G?=
 =?us-ascii?Q?sCJsVDRHYlbl14/IzufT8LCweoVMSFT3VgWl/WUHfu4fe6K+lik8B4KOD4ys?=
 =?us-ascii?Q?5jwedKSXtE78TfusPg4sjqDRwSM+26RvCWmiWp6Y2Xr499GLUfe7vgtT+7A/?=
 =?us-ascii?Q?/PC35KwSNIaMcrTj8DrnomrCHHPPz69mwwqRcmZbEvv2A/9dnxon8lrjO2cp?=
 =?us-ascii?Q?I7ZIlL4sv7lf2uLclOHyftKmHLCYDzBLOeX0vEF/MFDtHZ9tmFus2VdOPKt8?=
 =?us-ascii?Q?a+wvTTn3wSIMcqekDORSzt2thjj5wCMoRNdMzAGf0+WBp08gLiXTaBT3wAJQ?=
 =?us-ascii?Q?TEOv2yZ83yvoQHX3K6p0o7TcZDfk1yokrIwLuOGHXVK45OwAGqMSH5C3ogsg?=
 =?us-ascii?Q?LGUq5DO+k/XA7jRE+XMq5UpLdghBCbUW/6KQNfK6oWZNii9ULxzKosVj68hL?=
 =?us-ascii?Q?WXeAlta90ouw5SJS3EVadNeQzG6bJIg/Hyh9JwcjGsLyFRCfc0HR1A8FXOza?=
 =?us-ascii?Q?75VUGefL+O3+JIjqhoDGbFar+V/IIUv6Sdq17h5zjqpBf63DrGE46GKElU3f?=
 =?us-ascii?Q?RX1/4Xm1XZseiC9LVFKRUK0bSuTxCj4ZkBt3cOHvsCa6ecVXzhcSjFKDBc1i?=
 =?us-ascii?Q?AkJb5GZlVFC7FQczcXogvrSTfFcPD+y2yYxrRv9BOlkymQwh7r8tkCgZxNYJ?=
 =?us-ascii?Q?YoHAf46Jt60QNea/gpkcNSN3TX/jLMplPhS2gavelIGGAzpzNJLwUsg0NVk6?=
 =?us-ascii?Q?x6f/jI4wltcsLTXYbQjNa2eMiSsk6SD+czp2C3ZfxRo8bm893JinJl3TH+Ed?=
 =?us-ascii?Q?gUsnVr+q/vZffF5xqpPPZ7zd1jIdrzCbTgBigBeh01025IpsO9zf1u+xAwqQ?=
 =?us-ascii?Q?o0gK1jMexPvZR6EQxV0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86cee649-6012-4ee2-cdca-08d9d54005d3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 20:22:00.5150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tV/8B7NcLsa7kmzqQH9N0etFQ2xTEF83IU8DedsuZpHbrdtHfSz5SPrNouXG05J3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5079
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 06:33:57PM +0000, Matthew Wilcox wrote:

> > Then we are we using get_user_phyr() at all if we are just storing it
> > in a sg?
> 
> I did consider just implementing get_user_sg() (actually 4 years ago),
> but that cements the use of sg as both an input and output data structure
> for DMA mapping, which I am under the impression we're trying to get
> away from.

I know every time I talked about a get_user_sg() Christoph is against
it and we need to stop using scatter list...

> > Also 16 entries is way to small, it should be at least a whole PMD
> > worth so we don't have to relock the PMD level each iteration.
> > 
> > I would like to see a flow more like:
> > 
> >   cpu_phyr_list = get_user_phyr(uptr, 1G);
> >   dma_phyr_list = dma_map_phyr(device, cpu_phyr_list);
> >   [..]
> >   dma_unmap_phyr(device, dma_phyr_list);
> >   unpin_drity_free(cpu_phy_list);
> > 
> > Where dma_map_phyr() can build a temporary SGL for old iommu drivers
> > compatability. iommu drivers would want to implement natively, of
> > course.
> > 
> > ie no loops in drivers.
> 
> Let me just rewrite that for you ...
> 
> 	umem->phyrs = get_user_phyrs(addr, size, &umem->phyr_len);
> 	umem->sgt = dma_map_phyrs(device, umem->phyrs, umem->phyr_len,
> 			DMA_BIDIRECTIONAL, dma_attr);
> 	...
> 	dma_unmap_phyr(device, umem->phyrs, umem->phyr_len, umem->sgt->sgl,
> 			umem->sgt->nents, DMA_BIDIRECTIONAL, dma_attr);
> 	sg_free_table(umem->sgt);
> 	free_user_phyrs(umem->phyrs, umem->phyr_len);

Why? As above we want to get rid of the sgl, so you are telling me to
adopt phyrs I need to increase the memory consumption by a hefty
amount to store the phyrs and still keep the sgt now? Why?

I don't need the sgt at all. I just need another list of physical
addresses for DMA. I see no issue with a phsr_list storing either CPU
Physical Address or DMA Physical Addresses, same data structure.

In the fairly important passthrough DMA case the CPU list and DMA list
are identical, so we don't even need to do anything.

In the typical iommu case my dma map's phyrs is only one entry.

Other cases require a larger allocation. This is the advantage against
today's scatterlist - it forces 24 bytes/page for *everyone* to
support niche architectures even if 8 bytes would have been fine for a
server platform.

> > > The question is whether this is the right kind of optimisation to be
> > > doing.  I hear you that we want a dense format, but it's questionable
> > > whether the kind of thing you're suggesting is actually denser than this
> > > scheme.  For example, if we have 1GB pages and userspace happens to have
> > > allocated pages (3, 4, 5, 6, 7, 8, 9, 10) then this can be represented
> > > as a single phyr.  A power-of-two scheme would have us use four entries
> > > (3, 4-7, 8-9, 10).
> > 
> > That is not quite what I had in mind..
> > 
> > struct phyr_list {
> >    unsigned int first_page_offset_bytes;
> >    size_t total_length_bytes;
> >    phys_addr_t min_alignment;
> >    struct packed_phyr *list_of_pages;
> > };
> > 
> > Where each 'packed_phyr' is an aligned page of some kind. The packing
> > has to be able to represent any number of pfns, so we have four major
> > cases:
> >  - 4k pfns (use 8 bytes)
> >  - Natural order pfn (use 8 bytes)
> >  - 4k aligned pfns, arbitary number (use 12 bytes)
> >  - <4k aligned, arbitary length (use 16 bytes?)
> > 
> > In all cases the interior pages are fully used, only the first and
> > last page is sliced based on the two parameters in the phyr_list.
> 
> This kind of representation works for a virtually contiguous range.
> Unfortunately, that's not sufficient for some bio users (as I discovered
> after getting a representation like this enshrined in the NVMe spec as
> the PRP List).

This is what I was trying to convay with the 4th bullet, I'm not
suggesting a PRP list.

As an example coding - Use the first 8 bytes to encode this:

 51:0 - Physical address / 4k (ie pfn)
 56:52 - Order (simple, your order encoding can do better)
 61:57 - Unused
 63:62 - Mode, one of:
         00 = natural order pfn (8 bytes)
         01 = order aligned with length (12 bytes)
         10 = arbitary (12 bytes)

Then the optional 4 bytes are used as:

Mode 01 (Up to 2^48 bytes of memory on a 4k alignment)
  31:0 - # of order pages

Mode 10 (Up to 2^25 bytes of memory on a 1 byte alignment)
  11:0 - starting byte offset in the 4k
  31:12 - 20 bits, plus the 5 bit order from the first 8 bytes:
          length in bytes

I think this covers everything? I assume BIO cannot be doing
non-aligned contiguous transfers beyond 2M? The above can represent
33M of arbitary contiguous memory at 12 bytes/page.

If BIO really needs > 33M then we can use the extra mode to define a
16 byte entry that will cover everything.

> > The last case is, perhaps, a possible route to completely replace
> > scatterlist. Few places need true byte granularity for interior pages,
> > so we can invent some coding to say 'this is 8 byte aligned, and n
> > bytes long' that only fits < 4k or something. Exceptional cases can
> > then still work. I'm not sure what block needs here - is it just 512?
> 
> Replacing scatterlist is not my goal.  That seems like a lot more work
> for little gain.  

Well, I'm not comfortable with the idea above where RDMA would have to
take a memory penalty to use the new interface. To avoid that memory
penalty we need to get rid of scatterlist entirely.

If we do the 16 byte struct from the first email then a umem for MRs
will increase in memory consumption by 160% compared today's 24
bytes/page. I think the HPC workloads will veto this.

This is exactly why everything has been stuck here for so long. Nobody
wants to build on scatterlist and we don't have anything that can
feasibly replace it.

IMHO scatterlist has the wrong tradeoffs, the way it uses the 24 bytes
per page isn't a win in today's world.

And on the flip side, I don't see the iommu driver people being
enthused to implement something that isn't sufficiently general.

> I just want to delete page_link, offset and length from struct
> scatterlist.  Given the above sequence of calls, we're going to get
> sg lists that aren't chained.  They may have to be vmalloced, but
> they should be contiguous.

I don't understand that? Why would the SGL out of the iommu suddenly
not be chained?

From what I've heard I'm also not keen on a physr list using vmalloc
either, that is said to be quite slow?

> > I would imagine a few steps to this process:
> >  1) 'phyr_list' datastructure, with chaining, pre-allocation, etc
> >  2) Wrapper around existing gup to get a phyr_list for user VA
> >  3) Compat 'dma_map_phyr()' that coverts a phyr_list to a sgl and back
> >     (However, with full performance for iommu passthrough)
> >  4) Patches changing RDMA/VFIO/DRM to this API
> >  5) Patches optimizing get_user_phyr()
> >  6) Patches implementing dma_map_phyr in the AMD or Intel IOMMU driver
> 
> I was thinking ...
> 
> 1. get_user_phyrs() & free_user_phyrs()
> 2. dma_map_phyrs() and dma_unmap_phyrs() wrappers that create a
>    scatterlist from phyrs and call dma_map_sg() / dma_unmap_sg() to work
>    with current IOMMU drivers

IMHO, the scatterlist has to go away. The interface should be physr
list in, physr list out.

In the two cases I care most about in RDMA, not scatter list is alot
less memory than today.

For iommu pass through the DMA address and CPU address are the same,
so we can re-use the original physr list. So 8 byes/page.

For the iommu case where the iommu linearizes the whole map I end up
with 1 entry for the DMA list. Also 8 bytes/page for enough pages.

Even the degenerate case where I need to have unique DMA addresses for
each page (eg bus offset, no iommu) is still only 16 bytes per page
instead of 24. (I don't have a use case for RDMA)

The rarer case of non-page aligned transfer becomes 24 bytes and is
just as bad as SGL. (RDMA doesn't ever do this)

So in typical cases for RDMA HPC workloads I go from 24 -> 8 bytes of
long term storage. This is a huge win, IMHO.

I can live with the temporary compat performance overhead in IOMMU
mode of building a temporary SGL and then copying it to a DMA physr
list while we agitate to get the server IOMMU drivers updated, so long
as special passthrough mode is optimized to re-use the CPU list out of
the gate.

I don't realistically expect that replacing every scatterlist with
physr will ever happen. It just need to be a sufficiently general API
that it could be done to be worth all the work to implement it. IMHO.

Jason
