Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C22D495304
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 18:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377278AbiATRR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 12:17:28 -0500
Received: from mail-mw2nam08on2075.outbound.protection.outlook.com ([40.107.101.75]:44417
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243820AbiATRR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 12:17:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/iFnFHkvsRJbRHN3YR+MDZGsVhBBIUGfQnMzEqfAOJBJGIiHLjIDXkad20ZkfI7ZrPjsQJP7vd1JmXmuNjx3UbR94rbfrgaQVeD9n4MBNWrEdoKev63bEnInciKGGPRP6mwVslslq9r/i5/na7GolmRQOopkfSJlC4HlV7PazUXeeL/rZ4hri5qAaGK27iMXxlPjTtZFebP13Qmzc6c6S2pc0JtJnQYdnMkpmCUPimxmL2OXlgKzVbTYEBqKZ1QHvqujhjFXQcHGr47sT7Hkn/xYf5BfVh/RZAxpG6Tfg78oqsJT5WaHvmNi0LQkScWL90Lt2S5g7NCdJtIk/awZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dx4FXYZd7ix3Z9+gnaV2DXgQLuiJ+cXJJ7qfhOh2CeQ=;
 b=dvT1vPMt5XQXZEt4PdANP5AbGx0fieZ1UqmOqJj5U3gfoCLFa47ipsGc1hSL/3wBfh5Wb3ysWLZdrwx1OGMFJ751FotBWhj/Glxcu96rckZQZthsIxqS9VKM3XzIu/VRVs6E9QvCfXmonaLKN5vyQKlkRO5yCd2ArfU99Lqp1gc4BTVlc7piWiivThZ6V0Z5UonqqTjI8ADLrQ0rOY0nmBzd/wYEDjwvCB1sEFhte5PqhO1lrhydOFZLnX80hqO4r1cMeIqqZF6rqd7LmALr5IAxIqO7OQuG8Gpowt/2RtCYTgpuPw36eE/C0d/NIF9/2f8rP0tmm/OaAPNXukOhTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dx4FXYZd7ix3Z9+gnaV2DXgQLuiJ+cXJJ7qfhOh2CeQ=;
 b=pU7tx9iY9BNPGfSbPS5ty2ajc9qfJssUeEa6bQ9CGOChLOp0UWwIQnIT8TipT3dAFX+sDx70I5Y8ydyjMNt52OIi7qFaJLmIWOa53PlM2gsj+2kTraguulvVZdRsYgkRAKKHIhPzLcc+Lsk6mPhs5x8URQwdSVMj+n0lB9D6PAS1Mt14N6EjuLJnk69I0Q1pQK3Nn+G+q09TM75rDVLsrW6TBaRhLQw+UHe0HnwSc9Bo+LbXS/FXMcfN4MqitzC4yNnmi8U34FaaLLD/LCLbpG7113CduLpSdcMZHOB+0PG+AD9o9n/nIwKxRV0fF3hgE3Z9aCu9O252DSlMU4xCDQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by CY4PR12MB1637.namprd12.prod.outlook.com (2603:10b6:910:d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Thu, 20 Jan
 2022 17:17:25 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%8]) with mapi id 15.20.4909.010; Thu, 20 Jan 2022
 17:17:24 +0000
Date:   Thu, 20 Jan 2022 13:17:23 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220120171723.GT84788@nvidia.com>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <20220111004126.GJ2328285@nvidia.com>
 <Yd0IeK5s/E0fuWqn@casper.infradead.org>
 <20220111150142.GL2328285@nvidia.com>
 <Yd3Nle3YN063ZFVY@casper.infradead.org>
 <20220111202159.GO2328285@nvidia.com>
 <Yd311C45gpQ3LqaW@casper.infradead.org>
 <20220111225306.GR2328285@nvidia.com>
 <Yd8fz4bY/aMMk24h@casper.infradead.org>
 <20220120140340.GC11223@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120140340.GC11223@lst.de>
X-ClientProxiedBy: BL1P221CA0019.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::20) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 486237c3-c8b2-47a6-789a-08d9dc38ba04
X-MS-TrafficTypeDiagnostic: CY4PR12MB1637:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1637F38FA1ECC8B7942455CCC25A9@CY4PR12MB1637.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tVyDiHfqQeMfrahhf2TRdpeJwUWym7GCAdIoCBYDEWiUNDyRyz41FfLO6uthIEqZ39DiH7FUhJaoXGRZXFxpws5HpwFlEPdnzvHf7q+5cNnNNvGuJ5kQkT376jz4TH7+RlynYOCRdBzzJIUUaxzl8jt1M+Txowe3CR8gvCk7Y8dcwxC38LXn++Vo/YtnIdeA81ISYv8Gx4f7B+faKxOuDsWjUfM0wbuDN3npsMwu4ci8WLv7TKCVmn2aQLX2xSUnMG2vHmPvNEVn5cjauxeZRavntdqhlJ1GO61FbBbjqdPhu4PImHH/ejvb+EXE812HtMEaie/xUKo8Fn6J7+kH/DuYwANAXgx0LERjEBiJQrJa089NW5fcfnj3NVFNMsZN423ShXpD2TDZQ6NW4y5wAy3voj6z+gBRNW9X1pew1LZ0sGNaMR5Bgq4BH/KmEGdYyc92Np6PUnFJ28kgTzyvZlzY23FVaLDAsQqimG2VtQt+JJoy1aJIeBTDBs/FmkUNIJilVZGPKS8/5qYDxZ4/zs5HJGDNJ8v/wlYGa4wXZadxTt4n1bI3U0Nw7ZtnMKSWbVwldIn1oCLXVQQbTtp8jCU4ih2eLsIPwFgG8Z/z3XCvVOkXWZ5VgF6lxVJi5v1WshC5QAchwZDR9vHWni9vMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(7116003)(1076003)(6486002)(2616005)(36756003)(7416002)(4326008)(508600001)(38100700002)(186003)(33656002)(3480700007)(316002)(8676002)(5660300002)(66946007)(66476007)(66556008)(6512007)(86362001)(26005)(54906003)(6916009)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S680Aa53hjzCQckfq3hbc3pHdX6y4omH+laMXzgUVmmD6vKvcOXfrbNbNftB?=
 =?us-ascii?Q?9NVW9O1/TR6L15jKtvZKqvWMe+xSJPn5FAs/XZaLdsaqGDosa4rte7z50/8s?=
 =?us-ascii?Q?eFBLh2eqy3zkH7hljaYcPCJId9s7oO6wCm98JphG8bBUDwHIQvvqw4kgH/d0?=
 =?us-ascii?Q?QpOpmUgOyBCorEKWu2OeKltYwH5KXHQGsWkcVYyvxhoSJZkNuWL/0t75jUIh?=
 =?us-ascii?Q?8hfUBKtNDIRpYnGeltx3wIERVXs9lphbZr3eYGajxVpXJz2kRM4WM4SxxHn6?=
 =?us-ascii?Q?jGxNOLOfaMxvuEPaqvtk7AEWIHgZcAjz6HnHVQmiTRFqNKdgCIxU8U2WOe6L?=
 =?us-ascii?Q?nxkqy8CQ8AwSVCaTX2/NXnT+HE38lH6pqFQJzsS/aKGVj+adu1YhhtOoqbaH?=
 =?us-ascii?Q?np0S5x66IK6ixLOd9RsNYilYTs/XOMhHLr/KxEQKj4bn4vS7+N7cSLYt/Cnp?=
 =?us-ascii?Q?V6zY5Y02pwvuDCDTRKwGU+DILnI4rGCrvzcQ/Zw5UfUvkpfTavkh+KcQpyw8?=
 =?us-ascii?Q?d/hcMMsYeYX9RnE3EJW4aC3ui8XKF4PE093RMQnnRQjU4Yx3MNIO7miZgDgZ?=
 =?us-ascii?Q?HIF47eHH4ZnKGTNw/FherJ1zi1aQhpz5qxN4T8b+XUGwBPrSYymeiq4xU/HH?=
 =?us-ascii?Q?DFA43BgpSd8wAKDGWqj2RbdGzLpq700A8L/yefa+qESPTGEwPHsl6vIU2Hr3?=
 =?us-ascii?Q?ungH1Xx/0f6Ti3PLmcvAEZ3JIaivIBTr+GPLe6SFUIeGmH7j41x8UtkYbJ5P?=
 =?us-ascii?Q?YkReFBJbSZhfTrUcK+s3LYSMCYsEHsa1Fb8Smgf38xL/ct+r2imD+h8sw077?=
 =?us-ascii?Q?3X3U3DDERQcDRybN3zy/0mxFBuSoZ2zxiPnwt1di3GU+Ycb5JNjunvCmLAzq?=
 =?us-ascii?Q?kGeB3P6xWe3ing2EBxJEy3NzUVAtBxas7gJpO9lNlWG5FQ2RxZBf1dkA//w4?=
 =?us-ascii?Q?v2jE6twnmIIvtepwj5ZCUpKG53O2CY1oTHyr1L8r9gtf7F5EvLYcoqkGEQ55?=
 =?us-ascii?Q?rAzsrd6mM+qbdwAk5nMP2ac9ADv9x0oTwgWxa4/0GCIc0FiXa9AS0+ABarhm?=
 =?us-ascii?Q?I86sbaXvMx1Zd9epJ0/poFl5CpTuVTNV8aox40gzLO2862wFvL6KEFYISOmL?=
 =?us-ascii?Q?1lCY0IQytExjEdNu3lNSafM7OlyMQy5yA1+54ZPIvjkRKBbjwxmGzBJ6aFQA?=
 =?us-ascii?Q?wOkanJ2IfcKWUGITepvMxhynjX/fiDKWirXc6yNT3pIrCGkLOAq7VFNSUbL8?=
 =?us-ascii?Q?fDQZH2zPGFHsxt26F/mOly28NNsMm1fXhUFeM3Rsq4NNQ/Bbp5/VU2oXfM2c?=
 =?us-ascii?Q?RKtrEm50R8MMz0IOv0VrgfBXmRWk/td6dD5KcrCkbViUHPDuRb3BiLh0KLZD?=
 =?us-ascii?Q?45mNTFzo1p7h0W/sZEwNdfbpfQApl0MBSBhvlBXGG1humYnfncdcW/Gcw2rF?=
 =?us-ascii?Q?16qSKjpDrjbR0p6is0GFN4wO8igTnkvtjzg5X+ZwRHvjLCKSGNTIeP5HMTlW?=
 =?us-ascii?Q?3tlNw28sS1u+vzOKNTgF/HOwh87uUFJ+nuajRJgmzKlVWNHrMHvet5p8J0ir?=
 =?us-ascii?Q?FJzPo4d3MhvickP5ruA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 486237c3-c8b2-47a6-789a-08d9dc38ba04
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 17:17:24.8972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8553A+nzo0MPhPKQvyYG2DsImsu3cKv4OvU3bP7Eo+8TPKbGnzwnrxM3+x2qxde1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 03:03:40PM +0100, Christoph Hellwig wrote:
> On Wed, Jan 12, 2022 at 06:37:03PM +0000, Matthew Wilcox wrote:
> > But let's go further than that (which only brings us to 32 bytes per
> > range).  For the systems you care about which use an identity mapping,
> > and have sizeof(dma_addr_t) == sizeof(phys_addr_t), we can simply
> > point the dma_range pointer to the same memory as the phyr.  We just
> > have to not free it too early.  That gets us down to 16 bytes per range,
> > a saving of 33%.
> 
> Even without an IOMMU the dma_addr_t can have offsets vs the actual
> physical address.  Not on x86 except for a weirdo SOC, but just about
> everywhere else.

The point is dma_map knows if that is happening or not and giving
dma_map the option to just return a pointer to the input memory to
re-use as the dma list does optimize important widely used cases.

Yes, some weirdo SOC cannot do this optimization, but the weirdo SOC
will allocate a new memory and return the adjusted dma_addr_t just
fine.

Ideally we should not pay a cost for weirdo SOC on sane systems.

Jason
