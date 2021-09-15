Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B1A40C69C
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 15:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbhIONtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 09:49:16 -0400
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:47020
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234504AbhIONtP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 09:49:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eg3GaoT9yLquxmx626ON5chhYRMWOwhvEZE+/9E5xjH7Mfz0NnOdTAC3LijWytFB55wbPkmCU4BNbx6IhCbmS2CrbyaCaJXwZx+GQy5iOquFRtyjmsYSGHFgMz+/X602AqHXcQVfsb5M4BDpXgzqvbvzzAYeVu0qLrRCFpDOZkhum+iGpHUpNdMbmbJ2R8XBq2wnwT4DXPqgO90qFdfgdBV/9Uk1Ug46RufTODOT7VIWzdkJQDtBtz+JePWKnycO5RhH6ELl5XiYTeNtaCBVPC+E1W8otags6nl8Wa3yG/FpWDcB7EY4USI04Mtk1fFgFYXT06ngV5h3VvMywQxk5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=duaHeuXIL38E/XexOJSE4yNcvWhTxEIe64zXDheigcU=;
 b=AyrxuPM4bOZCXDpCDFNnWimjXyXBTgUSdcWsbZBlcjs9o8Z2VwBDijhTftIr7bsmPygvkhAb6RWpJWIDvScFV9RaP3lzFCN7BFFDWn42H2XKn8mUJXDdTTwlJNzCcWjny814HPSm5i3Dsj0p0qToLzMvGI8vqzWArZLiNUuwtXxeB5w7K/6Wacqmg398+bOjGhahx9KMqM0p5RSQJBesqyPGmTwBDidqxN/TpHvJdDJ66ein/k0RSWatX/LIFm0phUAfLpnBwAZqV45yDfzStRq0NjIoGamEuTkcG0M3jSSG5xhpAilQZdcrtXlq5JvcUfhxi10UJWjKGs1+bgIoFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=duaHeuXIL38E/XexOJSE4yNcvWhTxEIe64zXDheigcU=;
 b=C7GOiZ3VLIpPJwhuF8GpfcvRshDFJMgeeh7YtHgd6IyYVHkp6J8KK9qe0hfTnvGtQ889tEnyZmGQtulBiRdUUMk+8lkTh60jeklWwd2BASYJ6toMlU/XeZ5XXlKqEd4YR+fWf/fGGIuo8zDTnVzBifmRvu05wnceypkYaXDlxZ9Cfzjyuqe66C2DUlD/cFGvZOSLixjspYX/l8ozAjs1cjopBmozqRUeMKvqZ3i5GTw613/En3XEQJNcY5g72NPoVDG6iEct+OaMbCJUCumvD7oKLA8kkWbiCIn46Wa+lkPNbWNKZOXi8BK9u6/zImxISucr7wk5q6OIe+8lPS+osQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5125.namprd12.prod.outlook.com (2603:10b6:208:309::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 13:47:55 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4523.014; Wed, 15 Sep 2021
 13:47:55 +0000
Date:   Wed, 15 Sep 2021 10:47:53 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Meir Lichtinger <meirl@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 2/2] IB/mlx5: Enable UAR to have DevX UID
Message-ID: <20210915134753.GA212159@nvidia.com>
References: <cover.1631660943.git.leonro@nvidia.com>
 <b6580419a845f750014df75f6ee1916cc3f0d2d7.1631660943.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6580419a845f750014df75f6ee1916cc3f0d2d7.1631660943.git.leonro@nvidia.com>
X-ClientProxiedBy: YTXPR0101CA0019.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YTXPR0101CA0019.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 13:47:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mQVGT-000tEY-57; Wed, 15 Sep 2021 10:47:53 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc12a479-c7d1-495c-01e7-08d9784f6ba2
X-MS-TrafficTypeDiagnostic: BL1PR12MB5125:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5125F1150CF7EDBB2D446870C2DB9@BL1PR12MB5125.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W/BlWGTvDs7K8h1fXpvP8PjA0e5gATFw3Ey+jSNFBRcoMTPxiPxnoaAmXWqB5L2jlsEupEeoiLK6QV5C0aBmwMWWno2Fbv3GsZT9skSBSe4H9e2T6H5LcW4FI904efpJK5n1GJaqChJ1J1Eti1iDs2t2iP8CAUilTtsrrQyXrYbec/oiSwna9RvGvlSbsKYRT3H+TTCkYw3/6ods5EG9DwucDqzVdP0jI+rS6G0zPJ0p1FnpquKhtPurBGdTB2TYUpn3KgUywyv12LfFCnXEsK0k5AEmDtu1p3rSnLyvIquPhMSblq9BKms1Hd65eH9pF3VADVjVo0OmONxvwjdZiIC9W2RW+ajXx/KUKMCXUrVxBHsWIGi/7hPf9vmfrjOj821ZzYZKeFxWMa3hkthxTUt6EE8WQB5wURmCRqRyoTE0hkMEh4AWBkdYBHo6I7XXu75wPpdylNKDM5nOig3VRFzCdjdrN40uq6/BK6yvhKiGfdD8CYs14r/H3vDOTLnb5ZuNqyUSAIA6Q9mBGrccA42Oq+DIEmQgLOEXYWl3V/Fl23d0twSZ75C5mPNpgaaUtNSrrhTvSM9LysIRG0GaI51vRJ5Dgx4Jl/+8va/3KEUud5FJJWhGCXkB9PTivwqjzBTH9lAn5B2VtIDUccSc6g0RO/iIOhORS2n04rGp21bID25QAbYFErUPj4A6tqFm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(136003)(346002)(366004)(66556008)(1076003)(2616005)(66946007)(66476007)(107886003)(426003)(86362001)(83380400001)(38100700002)(33656002)(36756003)(8936002)(2906002)(6916009)(9786002)(9746002)(4326008)(8676002)(54906003)(5660300002)(26005)(186003)(316002)(478600001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cxEikM2rFGI7rHW7ahNrNVYiYewoyRhi4BOsOVuatWG/U2IWFBct6/Yl+7hu?=
 =?us-ascii?Q?HykULTXIixjP94ZdCnrCjWThHESkMbctFGGdGJAXJR5T4rGpSkheQ87JnEkf?=
 =?us-ascii?Q?ZelOZ/M/YE0k54LO0ZDxMcgA8NaOdygMKloSrMZ5ehkQy12+zv2UMM5nvsnT?=
 =?us-ascii?Q?ILiqgn/Y5FhTZuMEdgzhGvPry+0YwBHFfWhRVZUi/Ek75YuGGv5WRvPBlGLN?=
 =?us-ascii?Q?kGbcQg8gCwuPO6b6Lh4EEaR4KNYlhBZ04zDRrEdknGnicY1K2B10ICW7mPzg?=
 =?us-ascii?Q?wgHkHC4xVUcWMulE5HOTRLdIIfsbBD4Szz66GZC89WadKN1KJ7kXa7v73rd6?=
 =?us-ascii?Q?hEfhoem0uLgI+EBH7aT8XDQLZDC6/YFf3zpJQulPYvvbPc2iN/w9uo1yyT4E?=
 =?us-ascii?Q?EzoteLO3GRSYlOUErgrcEIQIpuYE0rMTflvAwdiNEiguonLB4WdQaCWaEfNN?=
 =?us-ascii?Q?uClk/Te3iNFaBHYxOUI7lySGAn4yW1qIUM6pi6W4ufiop7yiSyb2vi1OjpOO?=
 =?us-ascii?Q?Wq8i+mGooQhtI80vhHAoWMqrrsrJByMUwHl7CKFLvM8BqVRtgLNQZqbqqp7w?=
 =?us-ascii?Q?qIETb5Qb+vjUlCS0t4yGfeEAY+OS1c1pmrXXxJDlhhZPJGVkGJxKwg50Z3oE?=
 =?us-ascii?Q?cEPouGnlnCVVuMc3ULD+ot75P/JgodCRS0Xaq+9drmKTholiZzzmTWQYUUz8?=
 =?us-ascii?Q?I1clKwd9pgaQ1TKaXDR8e0wMKbA96d+cOfWpM8BSQUsaFvEq+lrWHX+9o3kI?=
 =?us-ascii?Q?XN6VNvxVpl9LRgkVXHem+VozfwYjCwWTebaSx10j3xc9ZOIU9ulRTjIL24Xf?=
 =?us-ascii?Q?7S9xTksbvTlm3iiqDluYTMaYFIhcO1I05UeQMzlN1ArjzAqhhwlVAuszqN0K?=
 =?us-ascii?Q?SZPDutrz2pyX5GUKAciLmBw0TX7UVHjcVcnFpglc2NNIiV6C9aiRANWIYCEA?=
 =?us-ascii?Q?NeaRPHVWSUl40jfo7VbYLaGYBlf1qieI3p8v81GdS7+YIZWtsUUnYu9Ec3En?=
 =?us-ascii?Q?F39tZY4G55cn2PRIzOAst8t0xRrX5J0zwS0d8EIBBDxz5d6d953v4PbnitpX?=
 =?us-ascii?Q?If1InN5+m+DtnL6PYCt788/iOkbVcuZII0JlKmKvsMkenO905flKppdR31Xt?=
 =?us-ascii?Q?nQbaAu1stRMO37PnuF+xWt7LBFtYgttrPtX9fK7b3oxrqZFo9vFV1Uy+Lrj3?=
 =?us-ascii?Q?lVGAXWEeF1HQfwUCkfqGr41WgnBb+GZebpQh8FW7iEtqvN604xXRqM8GswKq?=
 =?us-ascii?Q?CB6q3q2ttwPKjKtdEetSsghQBD7h39Re92a95zY+te5HD8wDg24+pTIuNsCG?=
 =?us-ascii?Q?5m22zgxz0F4bg7yFdJ4kADQT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc12a479-c7d1-495c-01e7-08d9784f6ba2
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 13:47:55.5245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IGDdHsfMywq2gcnEJBIdXAOztO0t7+BNnFu2qvDwaC+vdPIY3crz6G3+R+9Rvhf0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 02:11:23AM +0300, Leon Romanovsky wrote:
> From: Meir Lichtinger <meirl@nvidia.com>
> 
> UID field was added to alloc_uar and dealloc_uar PRM command, to specify
> DevX UID for UAR. This change enables firmware validating user access to
> its own UAR resources.
> 
> For the kernel allocated UARs the UID will stay 0 as of today.
> 
> Signed-off-by: Meir Lichtinger <meirl@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>  drivers/infiniband/hw/mlx5/cmd.c  | 24 ++++++++++++++
>  drivers/infiniband/hw/mlx5/cmd.h  |  2 ++
>  drivers/infiniband/hw/mlx5/main.c | 55 +++++++++++++++++--------------
>  3 files changed, 57 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
> index a8db8a051170..0fe3c4ceec43 100644
> +++ b/drivers/infiniband/hw/mlx5/cmd.c
> @@ -206,3 +206,27 @@ int mlx5_cmd_mad_ifc(struct mlx5_core_dev *dev, const void *inb, void *outb,
>  	kfree(in);
>  	return err;
>  }
> +
> +int mlx5_ib_cmd_uar_alloc(struct mlx5_core_dev *dev, u32 *uarn, u16 uid)
> +{
> +	u32 out[MLX5_ST_SZ_DW(alloc_uar_out)] = {};
> +	u32 in[MLX5_ST_SZ_DW(alloc_uar_in)] = {};
> +	int err;
> +
> +	MLX5_SET(alloc_uar_in, in, opcode, MLX5_CMD_OP_ALLOC_UAR);
> +	MLX5_SET(alloc_uar_in, in, uid, uid);
> +	err = mlx5_cmd_exec_inout(dev, alloc_uar, in, out);
> +	if (!err)
> +		*uarn = MLX5_GET(alloc_uar_out, out, uar);

Success oriented flow:

 if (err)
     return err;
 *uarn = MLX5_GET(alloc_uar_out, out, uar);
 return 0;

And why did we add entirely new functions instead of just adding a uid
argument to the core ones? Or, why doesn't this delete the old core
functions that look unused outside of IB anyhow?

Jason
