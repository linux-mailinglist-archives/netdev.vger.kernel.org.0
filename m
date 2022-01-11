Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5900548A47B
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 01:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345934AbiAKAla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 19:41:30 -0500
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:48992
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343871AbiAKAla (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 19:41:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U8Wl9jMqYHF+MRsXMd4l0LQ9Q/d4bffa+n+SG7r+yuS4vtvFPmeazX8uy+wRRNmnazzuiivKtls6d+W0XY/HEDJzrMcBZCH0vNwS1hpt9R3ZXuuCwgnqV+jA0y/hjRJsb/9qq6GCf165SvgB2shHfAUY0Dn5bnl+T+0RsqMfbuA6JeEOdaId1xWzKV+2PRMIwyMuMpEKhTeadkCoBEquz0yWIJEC3twx1y4fBniipExW26gcOrPbUkq6MFj8HdVTHhbQTiMa15cj1CR2mAMDZ1aGkJ9mIY5oeY1S2WkF8878+/L4YUnIDJWxTgdynylm6fqx/VV9zHltQWyYxLiXyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Zw7ioGBSR3dqnFaJfuZlqEQdCCR+ajfDuQMhi8m6Zc=;
 b=PNQfj3fQ5hyqvhm+P2yo8o68Z9F4tAzi3lT9COP15K6Lj7A9svu2zydHYZ1cDNGXwLD+t6x+0+TJgB67x3DoME0DgWIDNAVQ1AC87o6xpmqzHHaewEisHzgTY5g33Of1IhjFCzZdCuBxFNlSDsn6FJeL51XuaKPTRN1KaiDshm7tCa/VWGzg+fCHIszl7tdyOq0OqfpVU8QOwyUUhKrKhWLERaB9j/8Ei5WRghvhE4escnbEJLDEsRJuhbOG8xdoh8XdxGBC7i3MEw8rST+xy6S/0OGMYcDRwda7wN3K6X/UnGiTAj4XLxYDeRs8yUE0GQ70JpgJxmTmaFp6SRZcew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Zw7ioGBSR3dqnFaJfuZlqEQdCCR+ajfDuQMhi8m6Zc=;
 b=m6jYzK6rXDdVK8/+QvgRtoHNNyVgpqLdsDQ0vf3Ufv5XsQWVMwZiy/G0rHeJNBATO+NdLsGzj+7i2uE0Nb77P3/VSaQdbCjfL1omEUfi7gUERQCKBLg3L8kOJN3tHgLd6ivQEUidrJUtSUCYelm583qeCMjwPVh9V42dXiYYotgjvUdfRi/QLsHpmdde56h61rfuT1Vt5rA7WHDBcs4UeUM9B3btIVytHoPkhUJEjVoQxhzpE5f6ACXxuuRyhVZMhLXvw18Pexz34zyUSkLCptmAOpbUW8qoJYBdqXO7fOoPHVM2ypmFRlMLGQ9h+13X2gGHitf2U8WDs/Up5XVc7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5333.namprd12.prod.outlook.com (2603:10b6:208:31f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Tue, 11 Jan
 2022 00:41:28 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 00:41:28 +0000
Date:   Mon, 10 Jan 2022 20:41:26 -0400
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
Message-ID: <20220111004126.GJ2328285@nvidia.com>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdyKWeU0HTv8m7wD@casper.infradead.org>
X-ClientProxiedBy: BL0PR0102CA0058.prod.exchangelabs.com
 (2603:10b6:208:25::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3588fbf7-61d0-4ca9-93cc-08d9d49b1aaa
X-MS-TrafficTypeDiagnostic: BL1PR12MB5333:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB53336BC94B275B27420F4385C2519@BL1PR12MB5333.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xSYGm/2TBefftNgpazkW8BldoJSx/O17DJlzWpOXrBx/wcQ2d9MvixB7bQ8XClEe8pSXhug7ljhB9Slwj/ne5o08if/DAp48WSuvGemYYONQKidH25KWyFNZJ7R9dYn5q8SnFatsmZ66yyjWH0+qxIy//4HiL/m3ZmfaXwhP41zw/Zk9ElXfabyCvo1xJHZy0FWKu0R75R+XDHXyYO+9QR1vlLidc3n6IzXO7aluqudxz9HdZEQEY3m12H6nk7G2CyJqmCBsTNH+WSkl3NY+x1wFg0uAZvAgXJTQaCE/lNhXtYfGrDedt9gWsO7T9ZMJNOuPYFi0ep4m9J6zQ+aHs+U2VpHwcFCiIVpv1zdYwuvwR/yZ6d2e79nW2+jlbEkIU0SgSNQ+TARIUXJkgLtMZJw62i1H4+h/5oMztlfCrZQqNfRm6jIB/p0629VhYMkClFvjGxIqqYT8mhEt5GDpK6rjzEDurmyk4f74Tl0cZXOl4NV1f5oj/Cg+Aze9c57SPK5E90eaNZkF2io21BODRIE8DF3PXlAb+DBPCGpkwTCrFZanTLgQk454wQ5JDw/H6B+TtYbYKFdtzMhBSFXu/7KR+B+lAKJpmGh6DvTHrICkJTIA2fcA8Ug4qkyPLH4Q/GcF7xZ0tz15FOs1TyBSdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(6512007)(26005)(6486002)(508600001)(66946007)(38100700002)(186003)(6506007)(86362001)(33656002)(54906003)(66476007)(316002)(8676002)(3480700007)(7116003)(36756003)(7416002)(66556008)(8936002)(2616005)(83380400001)(5660300002)(1076003)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ivumNZJV0QBeAhOOF2dDOWXLqY/LHU3EbQLyy7mYy51hI8t9n7LTjkyUK/Sq?=
 =?us-ascii?Q?THGaB1dWs4LLIZAEmTXNFbelixY84AcfAAF4Y8J9UoAj6CzAlZZPuGudAphB?=
 =?us-ascii?Q?ULKzwcO13twwPTl/HgLXmbxFYu5VuMphrAeuvQGd+DgDhyyCfyLwwelQserv?=
 =?us-ascii?Q?eLHH2mMYGmzgk79yidmLmLtEvbEGtS+O1IyOkfhgbacG4cLiMpn8vdYh/EIh?=
 =?us-ascii?Q?1/GbzqI3BXpNo76lKu8HCJernAesIlXWCGxPnyRj8biG/PqnXJ2OxyaNvHDe?=
 =?us-ascii?Q?2nVuohGDfLb5Ez9c4yfAOAyZ3XcYoXiS0aWS/7IpMICuiJOmul5X1rIoawX7?=
 =?us-ascii?Q?lii3Vk52wVRX89tBCAN506uyKzc4MYkgUZLT4v00TkTMqdDE0dlrgJ4kGgDH?=
 =?us-ascii?Q?r63Mw4NAyXMEd1p1p1x0yS7TVa+wZd4Yu35nS61RQthhElScEKxTAZOtJEZ0?=
 =?us-ascii?Q?eBmvvPPkQhfDboYt1epyGMYUh0AY+DaD27FCTJ7btllAm66BN6/tm4GTFeNe?=
 =?us-ascii?Q?AWqHjtqtCdzV1UyTOXryeH1KxKCpY4W3/+VevN2h6EOi0pZrdmnERgVnd7X+?=
 =?us-ascii?Q?aL4fKYo2x9+9xTIYtfBTQ+uoeLyF9XPRzgdrkoAV/5ggU2Q3aqdrvAm3zmRn?=
 =?us-ascii?Q?IT7Xuj6UTAVVxlXrcE5R6tGzeWxCkCRFcw3G7iMVyI7CLmIjUXpJ2rvn1+4x?=
 =?us-ascii?Q?0UWBU0DiTjsj81D3XUSFwis2GPdGm2aTqLvwT8/B+jjlGg6RjImRQ+tzJd/e?=
 =?us-ascii?Q?Q4pYhZJVHoQTZHDI8d791AIC9+KbTkl4bpJV818my76adnSRg6TjQ4Su/Ugw?=
 =?us-ascii?Q?UhSsyrR274rTdtKIJlTP+S9iFazyxn9qdD6QloF+G723EA1mOYjktUTy1Y21?=
 =?us-ascii?Q?37MRuCnjvPcznynSgD487PoCHt1sQp25cC6lCXqwbc2LBSbSDMvrn83Kguoy?=
 =?us-ascii?Q?n4fQDpwYxY4IH7PTIncPFd3s6BQAYpTxZ0VLcnEd7Lg+p2vo+cSC4axRWw7k?=
 =?us-ascii?Q?IVaRxW7yr+5c1B2yyHN7ZWlWnnlUtmNqYe/vkAcoi4/5pVnkePKLj6noOvI+?=
 =?us-ascii?Q?twZrJLB1vcWG3O4ARDea/1TebWlvHUxNxrRl36ccO1kgaJmCOLQ+Gp9BRzEq?=
 =?us-ascii?Q?jpmQA9H1O8iIAWLoeXey+Pc3dAU8zZ019juixe6xciYQJTVGCuJpdE6VB57i?=
 =?us-ascii?Q?Vi3z5sNyd3phRK3nd/dkOvRgU9N+ygX52/JKJLcFNmsJFF6Ur58akYjyNq3W?=
 =?us-ascii?Q?en6bvqCiYT6DP6uNGJASJ02dV4W6ZDCMNcf3kxGemGzrXBD3q/XEFpHy+uQo?=
 =?us-ascii?Q?e4MN1BN4lzyUUQM6YrbdIR2yXu9na54Yl+TrniesP+BiECgINQGDgPenikcW?=
 =?us-ascii?Q?R5QWA6r2pSJONSjijhIBUKTwqrAK8fyf5DvJYyDrHUZeSDbC97XVflakJzmV?=
 =?us-ascii?Q?lM3yEMGZVqbtLT5ujiCDY2TxxU1bOzdcAEEpSEZkZ0Zk1YRbhqpQfdNg9BJt?=
 =?us-ascii?Q?mNvZ7VzIYllMBNrHZnbiTw+cca7mw7s+o1xCpPPiFNNnL1mm4KdhzQ/v+Qg6?=
 =?us-ascii?Q?MlIsL0NH1ZBbEl4TwWA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3588fbf7-61d0-4ca9-93cc-08d9d49b1aaa
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 00:41:28.3916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qPbGD3m5Lb2HMHQGx5sqs/rDgFeQUbBbNYzcl5mAfVAYem/CAkSmjIOwAJYJXhVG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 07:34:49PM +0000, Matthew Wilcox wrote:

> Finally, it may be possible to stop using scatterlist to describe the
> input to the DMA-mapping operation.  We may be able to get struct
> scatterlist down to just dma_address and dma_length, with chaining
> handled through an enclosing struct.

Can you talk about this some more? IMHO one of the key properties of
the scatterlist is that it can hold huge amounts of pages without
having to do any kind of special allocation due to the chaining.

The same will be true of the phyr idea right?

> I would like to see phyr replace bio_vec everywhere it's currently used.
> I don't have time to do that work now because I'm busy with folios.
> If someone else wants to take that on, I shall cheer from the sidelines.
> What I do intend to do is:

I wonder if we mixed things though..

IMHO there is a lot of optimization to be had by having a
datastructure that is expressly 'the physical pages underlying a
contiguous chunk of va'

If you limit to that scenario then we can be more optimal because
things like byte granular offsets and size in the interior pages don't
need to exist. Every interior chunk is always aligned to its order and
we only need to record the order.

An overall starting offset and total length allow computing the slice
of the first/last entry.

If the physical address is always aligned then we get 12 free bits
from the min 4k alignment and also only need to store order, not an
arbitary byte granular length.

The win is I think we can meaningfully cover most common cases using
only 8 bytes per physical chunk. The 12 bits can be used to encode the
common orders (4k, 2M, 1G, etc) and some smart mechanism to get
another 16 bits to cover 'everything'.

IMHO storage density here is quite important, we end up having to keep
this stuff around for a long time.

I say this here, because I've always though bio_vec/etc are more
general than we actually need, being byte granular at every chunk.

>  - Add an interface to gup.c to pin/unpin N phyrs
>  - Add a sg_map_phyrs()
>    This will take an array of phyrs and allocate an sg for them
>  - Whatever else I need to do to make one RDMA driver happy with
>    this scheme

I spent alot of time already cleaning all the DMA code in RDMA - it is
now nicely uniform and ready to do this sort of change. I was
expecting to be a bio_vec, but this is fine too.

What is needed is a full scatterlist replacement, including the IOMMU
part.

For the IOMMU I would expect the datastructure to be re-used, we start
with a list of physical pages and then 'dma map' gives us a list of
IOVA physical pages, in another allocation, but exactly the same
datastructure.

This 'dma map' could return a pointer to the first datastructure if
there is no iommu, allocate a single entry list if the whole thing can
be linearly mapped with the iommu, and other baroque cases (like pci
offset/etc) will need to allocate full array. ie good HW runs fast and
is memory efficient.

It would be nice to see a patch sketching showing what this
datastructure could look like.

VFIO would like this structure as well as it currently is a very
inefficient page at a time loop when it iommu maps things.

Jason
