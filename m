Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7353248BB12
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 23:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346677AbiAKW5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 17:57:20 -0500
Received: from mail-mw2nam12on2040.outbound.protection.outlook.com ([40.107.244.40]:24732
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232045AbiAKW5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 17:57:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fgK3Gb6OaMOJR4I0cSn4H1hB33UYV770rgk29jVA6xTkHr+WPrJ48onodNSaohRSKNo0zZ0BLOjbOsdU3OvZNzPEnWurRjIKaJ/FQGyq3aXpaLaaxRyWvC0ru3Y0xsgOPj+xZpZdcfPkq6MnFQAd+buH5csQx0Sp3KK80q9HPyxW+3qhUzwPCX4jq9UhEL8t1IrkMxP6FKImbYFms6IyIZenGSbETFpG11Qvpvbe2AmbilVgnN7+xGFU/28vDE7OqY6ZIKsTt4MRk8I+9mnhti+U+GKcItGfBjDd6ThnS9/TpovKdNW3NgvhKOJiBnD7x3X4nCCUStECFXRiDDirPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EAvCLgC9IaVF5+GHIu4lph7LQ+cL81pFL3wZQRJa/CY=;
 b=Uds0j5+ssO0MLwnBgv8OflbAQ7gjtn0do0thXnK5PlXZoCxfXKp5REWaCDB+Gd0liyxOd9bTfkWm09cqMoSgPQm4/Ef4mWmusoNfuM7lQwRP8djoqVmJ6Ajmylaycjpz3wcXtP5cdBvKHi3O9DlPjw3lnfNXavea3VONuy5Uail2w48CbSP3KCrEmkMkAH11zslTYPFPCE7ZjFgs8+pTN4ax8Ymp8CbcLOwMMwIyQ0IhxhvSv5dNdKgG0xyCj060DHXwCPWtVwttzk2br59KBhSMNQPBcKqRuQc6sjyCLVWo/DUwYqf9CV05Bq0l81y85NgID2JS059yh9YVkwlTBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAvCLgC9IaVF5+GHIu4lph7LQ+cL81pFL3wZQRJa/CY=;
 b=pVZHqguG9xyDUrLpunJ5v+SkNaRTLJ6r60sA5fQPxIxiDQ4NNID+HenNBLEIobj/pld6lDEFOtLDxaMRK0KJmhuufNXCJgHZjaYj2e/aMu7xa2ZeEVxEvifo/NyZpaHZdzSY+Cx/5fHhKaDeWFAlp9VE4Nw0esfSHOkFyZqFwEvYwydHjfnxC4PPTApqldHVFkxdgHxHMWRcgCvODT6p97Rs4RbqTnssSHELiewPNxC5aW8F8pbhFy6OZjryJsS3E3voJTTaF+MRvDIOxRqPSOhJh0nIkdmDdsq2OxuUBmYG9DMht0Z7nQH77RtUhldtddEKccjjew2HS4qeQC4/LQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Tue, 11 Jan
 2022 22:57:16 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 22:57:16 +0000
Date:   Tue, 11 Jan 2022 18:57:13 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220111225713.GS2328285@nvidia.com>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <20220111004126.GJ2328285@nvidia.com>
 <Yd0IeK5s/E0fuWqn@casper.infradead.org>
 <20220111150142.GL2328285@nvidia.com>
 <Yd3Nle3YN063ZFVY@casper.infradead.org>
 <20220111202159.GO2328285@nvidia.com>
 <Yd311C45gpQ3LqaW@casper.infradead.org>
 <ef01ce7d-f1d3-0bbb-38ba-2de4d3f7e31a@deltatee.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef01ce7d-f1d3-0bbb-38ba-2de4d3f7e31a@deltatee.com>
X-ClientProxiedBy: SJ0PR13CA0058.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b10715a2-d7ac-456c-8b88-08d9d555b679
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB517617AFAA9116D212B031C9C2519@BL1PR12MB5176.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gIwj4SpzzDlxVriJrZJwRCA1+JI57YSnpzSKiRGJdcPdiiIyNyRFn7zjFshuhcD3Tqs5ArZR4TlLBU7qxS8Ul2qVAEQNYEETSKVGU7o+F/OL4BVJkNTq3/SDwyt+f9x2aHVjR++/VkN4twJUACREWc0av8xqHj2Ng//Mk1l31DZLVXTIKKciATrOifxhvH7evpOyeuAWoXjQoM/NKaHPBE+6OBajYK6fjCLeZesIMo0p8R1ojyi4mLkVI4zLHd/bV8AAYHPQdSeuZ23Vmg9Ifof82tyL9/DPUs2wj5dLu/Il7orV+gd18NEMri2LaaejM+YQJC8qpA6LRyART0WseDLXAMHxkaogQoHX9jSVOoZG6JPoZItlV8P4TnhP/GO6FPKS4TAcNXCN+kr9sJ2fmWDjrOX4cxH1k/oZkrUU7lRoOMJf2qDCA2UcdukslpQIboWMtXgNonNMJ1WY0hCzzFXLqxcvVtc065t8l/93tgzqUgWWU6IFmZxMDEAqhwBf8Z/osCTcG4ry7zjbEGFbU7j4AiPhWlproL57LreL7ZKDpKzwGu30txJbhk1kCvqK2nL+fq8bw6o7mTIy4bOqsRNneNYG11lb30VBiDfGgofNy+Z753Iu6gq3WluSFT9cWX3WN9S+jcZKwzPNWDIuVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(6666004)(66946007)(36756003)(66476007)(7116003)(2906002)(6916009)(4744005)(7416002)(508600001)(3480700007)(26005)(5660300002)(316002)(4326008)(1076003)(33656002)(6506007)(6486002)(86362001)(186003)(8676002)(6512007)(54906003)(66556008)(8936002)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AnphlhCESFefVxShya5sH/2wbDUwCLUfzj1yXdB/4OJ9Dp5djHWiFfbwbvOX?=
 =?us-ascii?Q?7FzhyIvIn8FOpVEyxwFyOjGCPAxpABoI/Aixaqq5X2sdqrBfXK/iQGRBsJuk?=
 =?us-ascii?Q?3bUIuk26aahIzNZSCRho79RvMqslwt16vxebFbNffrFDtIWEGKqQ3xsyBwtz?=
 =?us-ascii?Q?P03kETJO05n2qP2UUyGl7auP602TKRJFxHiLcqpSzIDXDEB7W19ODz03gudH?=
 =?us-ascii?Q?Dm3RTjRyTCeet3nz6dphnNYqjN2jvMVevZKhu8XgsJ8ERCqzvq68j2R/vgYx?=
 =?us-ascii?Q?B6o6fZRdZcKPS3LpVC9+oeHOZ/pfTq33ytTGCMu2dWGwMkPy5UYm21ZOBFGh?=
 =?us-ascii?Q?3KYRMrb+V297BgepF5aUdVwJnieUR/tRR19WdWU2gDtaJ/C4+USg/LZklw1i?=
 =?us-ascii?Q?Qlgx3bTz9PiY6oA8oIg4ujS9RfSgb8lhCOAy2EEDgDMGNvJWej4NwzNtwOb7?=
 =?us-ascii?Q?03fKzN7DlyVjNL1a6UsD5Ngdz2bQw7MeNIlvzX/wNuGn7A30DdrjfRGE00R7?=
 =?us-ascii?Q?qvHQ7XoTZxTvQuhHfDAdZKnwBtaMfOFSES30HkIRU+oWZsh0l3/aB0LQnWgv?=
 =?us-ascii?Q?uJw2TYKTRejcKO+JeIuv+af+nsiJGqPNL+RQvTLkfY5yFYNs9OSZF5JVVwXk?=
 =?us-ascii?Q?+1W/E5oi5oxZGkaJe0X3dj8T8Y9tzzndanPRFRdPUTTjDUVIcbX43DB95mJg?=
 =?us-ascii?Q?L+x65V7gDi0RsZpq7vpeagV+071Y3zsgJcMD/QQBeKyrPt7LpUoYgEwuyLxO?=
 =?us-ascii?Q?BD27E51DvAsCgAJCz9LwaEFU2wVSBlME4gQ0XMImzianf6zfSIW3SEs7/199?=
 =?us-ascii?Q?Vfs1bWxD/Zkniej2Z10LiOv3OVYBEMDPoaq6RSogjsWhT3/HFHHDw/1pmpW1?=
 =?us-ascii?Q?m+hRR3LnkfKeItdqUKOwoPa2GK7rzJQ681IZoKG3RxcSmg/xy9UjtrF79ZSj?=
 =?us-ascii?Q?297vLJ+tQUyN2HWlyjh8NVRPh6QVc8YmgMKePlRl4Vnh3TlIJiVvbHIjQfXH?=
 =?us-ascii?Q?Yp/atDtYImt6305gXWGrY7mcqO1jnogc0Y4/jB2nYp3bsAFxH3d3iV3Dzowt?=
 =?us-ascii?Q?QCAHaRmvjv/Um1gWGe0moGiNfavjCtadMRpavGU48wrnVowaOYPm4T7rL5Bp?=
 =?us-ascii?Q?7x580QwvuHHUJoR9w+7bawZu37BSC24kuCDcXdBayivcZpBWrEyh49GLzC9o?=
 =?us-ascii?Q?vXAM3+zMk6bXWZ5P0dCBKxK5kXnyuwgz+Wc96OV56YTY6cR9AVMBLMbQSY6z?=
 =?us-ascii?Q?LzcmEgbrOxTXiHa8dWBo9Iur7RLv0lnUJuLdJINfqNFGZ5iI0irKiyZmdbWB?=
 =?us-ascii?Q?/HBNDs/9KscPOv0hR+lYmP+1kBKNlbjz88QxADoys5XWVxJZBusvyPLZiGiG?=
 =?us-ascii?Q?OzVs2xzpeCTxSdkHKk6PfL0glQqTECRxomxtAKPy0MM3SASFD8rlA/J2ArtK?=
 =?us-ascii?Q?afzLdbTwy3rkBMNS3Sf+tYU/8XEQC/g8iAmygnVh/Tbw+rNGjywVSUMYbbBM?=
 =?us-ascii?Q?N3DzpQTErrYyaZ1r+hR254ujPM5kSffnCmZqI6RDeQMZpQPJjkUJscaYwnxL?=
 =?us-ascii?Q?RQUgD4Nw/POT+yoxeFM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b10715a2-d7ac-456c-8b88-08d9d555b679
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 22:57:16.2646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: twYCF+kiHldxhyduWaCj4QY8Eio10AFcvmcF91I3zcvfTYMCFfd/GbIDtJAU+Jq3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5176
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 03:09:13PM -0700, Logan Gunthorpe wrote:

> Either that, or we need a wrapper that allocates an appropriately
> sized SGL to pass to any dma_map implementation that doesn't support
> the new structures.

This is what I think we should do. If we start with RDMA then we can
motivate the 4 main server IOMMU drivers to get updated ASAP, then it
can acceptably start to spread to other users.

The passthrough path would have to be optimized from the start to
avoid the SGL.

Jason
