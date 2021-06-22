Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7D83B0D2D
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhFVSsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:48:15 -0400
Received: from mail-dm6nam12on2076.outbound.protection.outlook.com ([40.107.243.76]:17376
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232638AbhFVSsO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 14:48:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKltZSoOeCB25y+hWd0GN/sJ93LEllqbqvWqV9ndnflBNNjlnyIOaXVIi5q9HoQDWvvA4LscJyrw17u584IMPOYhy+A3PgTI7fIX6WNc+P+mLf+WNNWRNOFc8w5PFZ/8g/Qe1Qi68lC6QFDwchuS9sqGpZkaHN1MopUyHe/otppFP6qkyLB6SY0oOPtYl1wM/Ni+q/UHO0odweep1DfPrsIM14IsE6opTRNM2peQSgkG3lK41Ff7hAhj/d0P0LZEr3X2c7beQvsArLLLKMsCktAexgNXdnqy438WGFfmYzAkm/nBi/MkGWDvdsipFbAmbc882+QxAn665kAL2Sf5fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMGZiI9byiiNt/jwj3RKb0biAafqOxsDIRUVTzOQItk=;
 b=G4c1S2lC2qtiFkgXwnglLk1OEU2Dwe1/DBeIpaxZaXx823H4ErobfxkkfaI3jJLkzIPeaxT/9W2MdMO45qzQ8tJZomcNbDmBenO2mXnW0NHvXSmX/eD2B0tKrv8eUrGw+djNIL3r7OLqFw6Q79/lVSc3yHO7rC6buFQqmokiakxjyr/Vg9o80NLiCp2tnw+6PzMTdWOxakgSywnT4zd/mBJ2yqQFugRfKKwJIoZQ+tnCIhU/6Mjy/udSLgZOJlJAPRmmxEt4/xqjJkvnR3Mdd2Lw0bv/sIZPAj+cVFnASzTk6wr/ukuJ+Hcolt9nC+SqcuERiveqFIWEOopC3NUUzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMGZiI9byiiNt/jwj3RKb0biAafqOxsDIRUVTzOQItk=;
 b=k7qzBTibV1HC3byk9tbGSiF7bgwIokFMrAw1eOxfzBURSz51KVj4YCaF+K8CZB1Tt+gZum8smzg3kj6tDpsG333T4puY0uaXVCQ6/Ny7HCDhMI7Du7qaD+CgYjjoPB8MrjuSfb7rGsJ8TNf7Am3AUEvg/MZfVEpVfL7yMER50b2syp2WtkcSxpMsQ/3BpnJkhoMPScLJUZ4S+/lhvYOJYNqsRq9U1XBYP97zz3MZxOQXQ47pzsQjBAZXPITXjgFTN8QLqYVeg7KLXjQwEYw8akcGFosiTHDlxOaQ20hQXiYohwAcqhQFR02DnlxuIKf+Uh4JgMuf7LgwHDXIJoGZlA==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5205.namprd12.prod.outlook.com (2603:10b6:208:308::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 22 Jun
 2021 18:45:57 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4264.018; Tue, 22 Jun 2021
 18:45:57 +0000
Date:   Tue, 22 Jun 2021 15:45:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Meir Lichtinger <meirl@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next v1 2/3] RDMA/mlx5: Separate DCI QP creation
 logic
Message-ID: <20210622184556.GA2596427@nvidia.com>
References: <cover.1624258894.git.leonro@nvidia.com>
 <b4530bdd999349c59691224f016ff1efb5dc3b92.1624258894.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4530bdd999349c59691224f016ff1efb5dc3b92.1624258894.git.leonro@nvidia.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0268.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0268.namprd13.prod.outlook.com (2603:10b6:208:2ba::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.9 via Frontend Transport; Tue, 22 Jun 2021 18:45:57 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lvlPI-00AtWJ-CR; Tue, 22 Jun 2021 15:45:56 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae6b796f-3527-4576-e49b-08d935adf8f1
X-MS-TrafficTypeDiagnostic: BL1PR12MB5205:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52059AE28AD1F483A8BF6818C2099@BL1PR12MB5205.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P6K8mpFipdyQkibNGNyRFeJOyHcJ7gFPkGQkQY9SrAQWKHO5TZ0dbgcS6dfBDVKBzrmOK+SLHXNZbva8CGzjrKTQq+0WDl/xjXbQJVhGgpHHYKTsbftepG8/pyicxaoNjiET6MHH9iEVI7VWc6lSI9P04GvANBl6mi0ghjxf0e70Fvuo5Veuka9q1JWJDQFUWafECKSNhSniETujSUHVmN9CvHoLNuy7Gb+i9oeXUIpJ9Ano6bqyzBt2A05pFxlZJDqGPnTNPqcw40LG8gbHaz1aDjT5Pncr1gNYT/0ge0ROs4fkv7xVqtJiHdPupRaxmUx8b9etAUp5LrXhX7dFT9oR3QLQFyrdelYa3Ylvnw3WP3l9MG+E3rkcJISJ8RK/wc5oC4eOjWHO688RkdSORCNaDNjyLCafvbR9x/ODjNpG+nsvkHe4SBV8t+Fm7drLVfu9TdfRamv0UNsKUmAj0644zrilpVfK2th/z859PrblBU4u7RjGAbCbiaUaq4u6FL+sgRii2Q0nzENL4gMv4PgMHxjwbhCPa3MIJL6TlA9v4DxqABcFYL1nTHpy+lwU9Y7oX5WwV1AxLGWF5fcAVPTAhEteNDrmG7e0ZtkplFM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(346002)(396003)(136003)(36756003)(66946007)(2616005)(66476007)(66556008)(9786002)(9746002)(426003)(8936002)(2906002)(8676002)(316002)(54906003)(5660300002)(86362001)(186003)(33656002)(26005)(1076003)(38100700002)(107886003)(4326008)(478600001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QjHZjnZZNJ0wI7DF715He9r2YqCG7xRpRRPUlooA1lYvZDjLp3QbKAEKLcDK?=
 =?us-ascii?Q?RermJqFmUD5BrU5ifS+adIG0owZjudkJAbkUYG+f94gvaBtRZhXsCpRmBTmg?=
 =?us-ascii?Q?1D4snAZ5z/u1yN+g/HpihqshqUgHWKcvRBJ82f+JIzEYflLxKGshqRSeTd6O?=
 =?us-ascii?Q?ftrob6psfguvGfWk21/N/tnDPV/cnn1jhOS/+aEyq/qUvnXzt5QvVXUlj5JW?=
 =?us-ascii?Q?kriRZ+i/5Q/fbM4f3pwF8TSGtWUDvsxC/Ys2WCcoiKl7J5kyQ3+3EaTQyMT2?=
 =?us-ascii?Q?Ws9IRMB6rcJanf2ZPCoL+6g0dBlXLWFhD8XPg7LvbO+eucYK6MUkOQghWT60?=
 =?us-ascii?Q?w/EVnNRTqJAYyT4KDxx2GinAh56ncX18r26AS6lnvNqn+fIPiFibMtiYiZYZ?=
 =?us-ascii?Q?QouOiVK6xgTTHTQuHNoqJ1PuAx24kzCsYu4U/B/p5UCaO7gWz4yTgZPJnhOp?=
 =?us-ascii?Q?c5TpdzFm7PoJ8tRgy5esNiXNVj8PxC5xCJrXITEBdAacdEedndeflENRiid/?=
 =?us-ascii?Q?FxmufhErXJfBAg/OLH1YvTrnm30iOTrBiTcdoVEz0DekzlwuXcfbmGjJabe8?=
 =?us-ascii?Q?fnsqCcDeQh0soexMaBtHK79/VJM5LKZhHYlw/wYuz/OhorMbQCcoxurmGZqT?=
 =?us-ascii?Q?m6CWuEX7xo931hbaW/fzaSQ98mc4lb7GcolgXA0nUheHmtOz1Hn+Ec/zvO84?=
 =?us-ascii?Q?bcYFxTL/kipaSWzua4skCKJa5OleG/K4HaDJrXfd3ATP+9ZeoF0Dt70zYELB?=
 =?us-ascii?Q?Li6d8Na8yrbIX0sqpADDGEUQUOIe61kt+MBWazTIxxTRyW6bJjsEryMjjOnv?=
 =?us-ascii?Q?dg/DMB4Y/Mtxr4TBq/scxeGXISRAnPbiHZpI9NvDpy64Y3MMUGY2aPghcVPM?=
 =?us-ascii?Q?4/DWmr7L8ceKUxPrp61zvJD3YyuvIningV5iHKeQixdb2IOu+ofrs8VuQVVN?=
 =?us-ascii?Q?cJ21FhaEpbEAd1wma8rnnNORYVsu3ezR5jSpiXWrsmkMA7x54OaHJQmBEYie?=
 =?us-ascii?Q?zQNYCFR/CrDktheAfQMJrZnsBnkeHCrxjUSTvXmJGgDXHP5nCLRNqyCha/tF?=
 =?us-ascii?Q?/6e+u8N265icqtCNrCLuSPTyPULkA8dvbvoVXjKiGJFEYgrG6a5xAE60NPJT?=
 =?us-ascii?Q?X7rxmDqnIxjGC9prFWrO1qYvNt2YpBfDQ8me5iANuaxZs282nAJQv7nVLbFo?=
 =?us-ascii?Q?SwI5EJpx8OMZAGb+LPvnsRMkUoEomNg+VGhuznbGV0gngWviRni6Szxi9AKe?=
 =?us-ascii?Q?D6zPE52mRFPeoRyC1AvmNQLtg85Ykay/j9vCKZGOYpktoSnKSFEjr1duj3VF?=
 =?us-ascii?Q?cYZ0MfsIeu+35ALJTL/9pzi8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae6b796f-3527-4576-e49b-08d935adf8f1
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2021 18:45:57.3335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sxLsGpByaApBFYANBkeaYOL8BNU7ZOLrtqPt7oMe8uqUxLU4FYyaoHFkk+9f6vNR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5205
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 10:06:15AM +0300, Leon Romanovsky wrote:
> From: Lior Nahmanson <liorna@nvidia.com>
> 
> This patch isolates DCI QP creation logic to separate function, so this
> change will reduce complexity when adding new features to DCI QP without
> interfering with other QP types.
> 
> The code was copied from create_user_qp() while taking only DCI relevant bits.
> 
> Reviewed-by: Meir Lichtinger <meirl@nvidia.com>
> Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>  drivers/infiniband/hw/mlx5/qp.c | 157 ++++++++++++++++++++++++++++++++
>  1 file changed, 157 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> index 7a5f1eba60e3..65a380543f5a 100644
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -1974,6 +1974,160 @@ static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
>  	return 0;
>  }
>  
> +static int create_dci(struct mlx5_ib_dev *dev, struct ib_pd *pd,
> +		      struct mlx5_ib_qp *qp,
> +		      struct mlx5_create_qp_params *params)
> +{

This is a huge amount of copying just to add 4 lines, why?

There must be a better way to do this qp stuff.

Why not put more stuff in _create_user_qp()?

Jason
