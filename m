Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED92039A95E
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhFCRlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:41:01 -0400
Received: from mail-mw2nam10on2063.outbound.protection.outlook.com ([40.107.94.63]:3283
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230291AbhFCRk7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:40:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTcw+fT8T+5c1FvhFWlHDWR0RzdIi8sN+nTw+3LveqY5FGDekKXUiwOsUQqCHLs+qh1vzB9ApsuH2i+toLTynGo15YRkp/WoKeiZ3cavNocYcM3xMtNq4XDbWiECadH2022BSX9H+i/MvfySTw79iPWtBS7HcyHMWly4j+afP5Z/n8a49+xfPhWOxU9n88opUbUrFpCM6xAxmXRXEF7xWZwAkvXl5UdHsLEauadjK8MaV7zxTE0MOpWXmSyNgg0rXukhMH0qXLOo+GuEOoqxlSu6qkiZpCBZ1KNHE64Sck7oAFLH2hvqMlVxEgcfLKMyHipIcXk2ssKAUQA0u8P5og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVUQL8kG+wcBiJRNDawF6ubUtt7sSvXUUdcm5qZdlDY=;
 b=bsrT7UZ1hk2zovk/zM1619/5CZYuPEgsRbBX+ttcu8SN3ZvbeHXpsNGsI83ut5/oWuHzRwVfA8YbC0VJ7L1LfWQHJV/69WdNI6RkiHL+lpZyp2IlYXLxAnJXyzJA8myFZQdr9r+a9XWXLacLw1g7kSqjHuLKuG7gJMGHExEYjurLrkUq7BkBuw8hBRlNNsprqwNVKkWHS5teBWzAJpjrBPtUZDgHHE7ySpHjme8x0VS7efJ5ANHx5OPgimLjMXvsalmKSpsrlHZkBKo+BzRItj7yfbOU2Jb4jnEB0Dp8fQrDC/h1wMQ0u9vOsU+epAg32c0Yo3OWI7JHC1RHxraSpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVUQL8kG+wcBiJRNDawF6ubUtt7sSvXUUdcm5qZdlDY=;
 b=tMZxlPOd/JiqpXjoUMEA7g9bvq/JhHgEsUIPWpK7+bb6q/ifjMS3JFRajc5mChMyAe7RCb1VoDadqhmH39lzkwPkhWMFKEPngwf0gbodAbsQL3lLU5cXSn/hSr307Iv3PqCb5VP4yl00mKQg+eWz2ilWPWEKtAyF1/2e9PxLhAfiJMubv1BOcyv4tJpfiOBKsAHgFGUsfQ+GQppw2oBLg6CrHs+eOABwdvR/kEPZjvMx8fAjbQPeUjcGa+viXrg2F54BtPD7Khrg0oI2UbgcJdDMrw20/bE7cFb6DvKEA20yfR6vz1ueMQkpQfC1TGKBW1qY2cT1XPnhbqg96VCZ+g==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5192.namprd12.prod.outlook.com (2603:10b6:208:311::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 3 Jun
 2021 17:39:13 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Thu, 3 Jun 2021
 17:39:13 +0000
Date:   Thu, 3 Jun 2021 14:39:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>, Shay Drory <shayd@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-rc] RDMA/mlx4: Map core_clock page to user space
 only when allowed
Message-ID: <20210603173912.GB303986@nvidia.com>
References: <9632304e0d6790af84b3b706d8c18732bc0d5e27.1622726305.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9632304e0d6790af84b3b706d8c18732bc0d5e27.1622726305.git.leonro@nvidia.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR1501CA0018.namprd15.prod.outlook.com
 (2603:10b6:207:17::31) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR1501CA0018.namprd15.prod.outlook.com (2603:10b6:207:17::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 17:39:13 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lorJI-001H6D-Nq; Thu, 03 Jun 2021 14:39:12 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e862f99e-d836-406b-30b9-08d926b680a2
X-MS-TrafficTypeDiagnostic: BL1PR12MB5192:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5192BF056A147E0EFAB6717AC23C9@BL1PR12MB5192.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T6fUqrPO/2sdQyu1mUWRkoRDGGRUovByDjDGWfu0G1/WhCobzKXAGCWMtVkOUCgHQx8d/ZkxKugDLPLS7TIfDIbJtBMneUOo5vmhkzdkCNyYAPdsql0Zk9Pa2+JGIunPLtgk6DK69ZYT9CusnVDcR6KmE/nQ6vI+7yiLx24o9Q7Yt0rLmxf/e8Biv+3I4TDTqSnL3n/hJekS07yZfM7hv3gJzIc9eXNEorA7ZlGLWZN8XrhWZH6Yl7WvxYB+JL1HsjqGL5wtzoNHY7tTDYgrq3N2DV4PdCj19mR0OChgcLdIUJa47zOQZgdLcziWRyhqP9DUTLE9WhfICMFHHccvzluy3NMc6P4c/hOmqfJf9XT+Zks1mR/uOXZzYF3Fnrq2uADGT2E8ojLB4NacG1zomV149G9ywQCozKWWDfJTzlo1W40wnghKE5Ol+0D/jJ72jBKsprcA1nWiHSJMrsh3yXARgZDYKjpkV9yGCchGfXIU77OBmKeRAoK6D3/iNSB6fQfxJM58xxUWRaTMH7wkaZnJ3IpA7QuE/WfZ805mw39pSto0auOq5XFzydhR9ST1zXfRaRdKWWliLD/hWc7Va37jcPAD8KWWlnzV2hx+ubuuUGH/BS21ZBLL5UJ0XcuEDZCGh1pu4AwaeipF7CY4X3kohn4smCxrXoPG5LmgmZM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(5660300002)(9786002)(9746002)(66556008)(4326008)(66476007)(86362001)(1076003)(38100700002)(66946007)(54906003)(8936002)(33656002)(83380400001)(478600001)(8676002)(186003)(26005)(2616005)(2906002)(36756003)(107886003)(6916009)(426003)(316002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Sz6O+wzAxxkTT1cejmTQDR5rA4dlQuQZ32LR+5TCYj/UP4da/D+Vt6FeIxEi?=
 =?us-ascii?Q?TGYCa7FJBqJf3M2P5FHaM1OFFXh2mbUoYmD3qoul+b57fAQjrOyuy0VpMU9D?=
 =?us-ascii?Q?YrKC+IUvguAthkev9IHwd6rKkuJk6ri1B844RYTrvtpZPGyAhJMg9+4p5R6H?=
 =?us-ascii?Q?7/JpH4Obnh+APGRiw5CbPmNhy7iUPCSCFnAJtAMVbPvzDjaCPP3SKA+h+SHM?=
 =?us-ascii?Q?MR7Q+5EPSAKWddxR9SGY5H7AW9zyoQUchG1x965W/8XwWwLdZDVSqDjxjiAI?=
 =?us-ascii?Q?0zb43N/CSx70QYNnFolGbHQFhDT3T/1Fr7/e8Fp4n1TBjEkYFh4Na5sPEF07?=
 =?us-ascii?Q?1kmvAhM0wVcxd5XbDuhaEII67c9NmrbkUsqd/3mq5CK3ohxbrprgF01rcTE/?=
 =?us-ascii?Q?RSEKqrl4eIy/dedxpOWNlpODcW4BTTkx9wGI5LzDm7JzMkxzyImggjYLoWM+?=
 =?us-ascii?Q?o0+hDG0RCbvihYBy6LoKF4edjU/HqlNSTjgLQUZpJbqpRnkC7OpIsxRaAeUx?=
 =?us-ascii?Q?mZTiRbY/anhPkSGGBDZkthG+lkymTdqrEiGyZUCYvcxSSMe5sVnFuWwK39gJ?=
 =?us-ascii?Q?3eAe3HxYTqA3ARTA5geCKQ7ktrfWKSbZPLt/N8yyL9Xn6A9ZKKaF1/GyfnmQ?=
 =?us-ascii?Q?f6m+vmUgnHcXX9Bx2DhrVjZpfdVpxtu117uCRWJlMfzOM0OxVsZik7qH9l5s?=
 =?us-ascii?Q?CG+Wk6/xFvjbZnBGp/SfdppFWhieaMqnyYOhH4nI0FQ7dflOlhBWzNp0r6Z5?=
 =?us-ascii?Q?HjO26Y0fkts1/aDRDWe3fTOcmffScHoS9qhclsNjvA2sP3JPXvnCaPl9CVGB?=
 =?us-ascii?Q?30AjvcTEYoZ8yq5AOBI3ydC4Q6/4WSdBVZA4Dsat5Aggqe7zJltqwIJMoSIu?=
 =?us-ascii?Q?6rEXACvPBhDpuM8L8zuhkvYOpQ574szvKfqSr17EkmzuBtFnvGXmuHlWnYGd?=
 =?us-ascii?Q?8q2TAR59AjZnUgTpAlmx4aYc7TpR3TZJ00zdjuRBKQkpZVjit0D6vefryuGP?=
 =?us-ascii?Q?J3Q6SQufgU1GeypCcrNjSsb1d7fL17VQ2TJVI0NaQ6NgUeiTqomHdvpaqwfc?=
 =?us-ascii?Q?+IoWeCJhrWlGLkMRhgrGXVaZgQXjgsurDI5GgsaTQY/zxUDx4K888nOocq+s?=
 =?us-ascii?Q?wRtWA0Zliq/PEViOvo8Vdcc3AmSzKxKNpvft+MIuLfhZTBi4VMOI5IoKrYoA?=
 =?us-ascii?Q?dsnPJJEMaNXGtl4Fq5AEqTPK5yjHtU13wCZFQlaIh6askgW4t18bPnzgt4WY?=
 =?us-ascii?Q?BcP5mlqYdvb3LtMeIKK/zw4Z5ICSSiVQU5OAVvxwYK5wxytWXqbCljmLyS+U?=
 =?us-ascii?Q?a+5DQtIPxDxksfBBWSBkopqx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e862f99e-d836-406b-30b9-08d926b680a2
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 17:39:13.4518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fOp3LWfM4zLd//DV/bzX7t6O8KVHysf2NhW8ArDV1w+5MZY7Q+FkmbBb3BK8uBlU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5192
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 04:19:39PM +0300, Leon Romanovsky wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> Currently when we map the hca_core_clock page to the user space,
> there are vulnerable registers, one of which is semaphore, on
> this page as well. If user read the wrong offset, it can modify the
> above semaphore and hang the device.
> 
> Hence, mapping the hca_core_clock page to the user space only when
> user required it specifically.
> 
> After this patch, mlx4 core_clock won't be mapped to user space by
> default. Oppose to current state, where mlx4 core_clock is always mapped
> to user space.
> 
> Fixes: 52033cfb5aab ("IB/mlx4: Add mmap call to map the hardware clock")
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx4/main.c         | 5 +----
>  drivers/net/ethernet/mellanox/mlx4/fw.c   | 3 +++
>  drivers/net/ethernet/mellanox/mlx4/fw.h   | 1 +
>  drivers/net/ethernet/mellanox/mlx4/main.c | 6 ++++++
>  include/linux/mlx4/device.h               | 1 +
>  5 files changed, 12 insertions(+), 4 deletions(-)

Applied to for-rc, thanks

Jason
