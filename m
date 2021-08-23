Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EEB3F5128
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 21:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhHWTUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 15:20:13 -0400
Received: from mail-bn8nam11on2044.outbound.protection.outlook.com ([40.107.236.44]:63904
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230192AbhHWTUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 15:20:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AnlSd6vZSzp8L5w3BScO6ExIEAxW4Ibvc3Dq1XSbmwao+uBhKBr+8CBudVuxCgDWMYamvFjC3jdaUCdCQIqdsCuEMBo9JgZ27Q7xJdeKfoXAb0nO2/+M28wUeXsDzekjhZS4cXARcmLYmbvJpiRZq0W8FIp32X136GjEFtPl4QO4+IUaH2skXztuh3nHxukEzibjWWWJ+7pMB2X0fqjBu9ke8zqlRkMiLNQjOeiq6pLT4regMXJBpwhtMqoFuuC3SqL9f8xAiUHbW4NRP3bn9IbB3hI4Xim5US2RK6O3xfWalqnyokqtdVJalNj7YdR1yEn7NojHr4BRvApt5cSiiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOeL9bkBW6G+D3RARm/hjdV6sVFG43v9c3J6PkE2/A0=;
 b=fjLcvXmITk+aIce4v0Ku6DQD/FKLlwjxZKhjGjg8Nsp/7sPpna4mNuYQBAVFTE+Wap05P7LBKtea5TRdApXspmLfT/nW2V9L79aStnBfqWKPxGkguuWWo+ovdNOEAj/2LUcb1z/C2oyXS32g0flbeEOJSyB+L7zRor3klxx6/7JtI7VuBG3iLgWefx1dK/jdHCaN6dwMWFjyp9AcxWj6B1IgeL/R6LvEXTruY8oKibVr9WkceFDT9VfEBU57ticg+qrB3OqqG2FpnhAB9+SwKxu4xnCkYGsD11uPPe0/Ut3rPtnrnqi2/pl1qNuTKAK4VLhfokqNAIfUAcvHEePxMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOeL9bkBW6G+D3RARm/hjdV6sVFG43v9c3J6PkE2/A0=;
 b=VDd+8p3eX+EEDiAUkSj8YA6Q30k74Yvf4C9Y9ECqdwIl0M0i1IARG0EMdiQ/rTzfGVMiYPz2lDDpkTjknPB4H/OwgqTm6Be62gJgAaTYsv1VdFB4ZmJLI1O2pkmnF880V2j8Wbilj/cRhLziet7ng9KSRtzhK8Ke+bOlnKqQtV5LnmazjCu65NbTpA4Lf1RdmX1M9NAo2GokEm52mTJk5cUnQPJXIdviiH1oymhOpzU76gWEBy6XY1ZnlNDDxUFp3zAJcUFeLZOIKg6W1UcVLiBL36UyCWjlv+kDSPQfC+sBQrxcKAgf0K1HoptcVYa8SYttcAtVwTtT+jC7QNabaA==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5553.namprd12.prod.outlook.com (2603:10b6:208:1c9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 23 Aug
 2021 19:19:28 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 19:19:28 +0000
Date:   Mon, 23 Aug 2021 16:19:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Mark Zhang <markzhang@nvidia.com>
Cc:     dledford@redhat.com, saeedm@nvidia.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, aharonl@nvidia.com, netao@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH rdma-next 04/10] RDMA/mlx5: Add alloc_op_port_stats()
 support
Message-ID: <20210823191926.GA1002502@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
 <20210818112428.209111-5-markzhang@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818112428.209111-5-markzhang@nvidia.com>
X-ClientProxiedBy: MN2PR10CA0012.namprd10.prod.outlook.com
 (2603:10b6:208:120::25) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR10CA0012.namprd10.prod.outlook.com (2603:10b6:208:120::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 19:19:27 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mIFTi-004Cov-UW; Mon, 23 Aug 2021 16:19:26 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4444fdf-a158-470d-bcdc-08d9666aed10
X-MS-TrafficTypeDiagnostic: BL0PR12MB5553:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB555358AD889CCCDFDB5BE398C2C49@BL0PR12MB5553.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GQ7+UECIXtcg+paNkuV2THTMcviJBSgqhIJYzmtxuy1x4D9/7VGb0rUsWLkTUK0RtyMleVm0Xxm9z6g9wnoHG6IQgAv4DHfaSVjyM63kSlp5UGmn65NvR01Z38I5+0oW2m3zaTDpMYpLwr5d+cW4bNoUXUx5GvY4pG8vF9oOpKfKDAOv/rfLYP1ovNtPFszR2Nsnj6mqS1aXJsClYBvXtjBV1NveRYzc3CN+wA8lqVfZqbAr+WMAVGhAzY50lY8nYYYv8uW8cbMagMEyGF/OoawZxXYtKL3uWZK1thd5vKpP7nk/3vG7X2zo8H6Ku0ubVrX6GJ/A0PFY1T8TTZ6j1wBjCWoJRlnoM2j+5VnPHsibdDwPJ2XWG4jL5gMckcyYWS3sq3xTfAQ+H47Wh3No/5ivV2QEI99vTTYQcppQd5sp7+KC0u/fLwewa5GNMhQZID9R2dFhsHgBD+d9VAF6xnRcxpCNuce0LYHmBCAofaKAKhabxisq+k/OZP+T1FUdPyaVR+XdyzHmmuerYMcL0ZNMBUNiDQrarhJZI6eBRF09qnDgASW1aW+Zd1luoqVQZ33101H9vkc17QxhWhmyJZm357HsmiT9/5GG5pjy/ZAb+mXSGB8iGraoKGnVOI+esekP2mVd5WVhq/+j2x5e1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(107886003)(66476007)(8936002)(66946007)(66556008)(4744005)(2616005)(316002)(4326008)(2906002)(1076003)(5660300002)(6636002)(37006003)(6862004)(86362001)(8676002)(26005)(33656002)(38100700002)(426003)(186003)(9786002)(9746002)(508600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sRZdvgDM2kaed4ftf4g/w2MVGu7vKin28noQnA0tXLZG2/r9TebWGcA40kOg?=
 =?us-ascii?Q?4524f53Thq6TMV5oy8fTgVzYv8MRJW0sOVSJklE6gOt27yV2OrvP+8l2M68L?=
 =?us-ascii?Q?vc8rnagJdWxZ5g/ZuDKpccY+3VKdtH9T6hzxVbYnPn2h2Wo4FNAqNzBJZZI8?=
 =?us-ascii?Q?/Z7/sgb/SvN1c2AW2NRXefJbdtk0JDPlLBz3V/afFtb6WMg+E00g2DYQxshO?=
 =?us-ascii?Q?TDO8Pe4i1cjAMiOJ97gFlW/tT3b83kLfWjNIFrHtLgJtQKxWyW/zmLbgdTS5?=
 =?us-ascii?Q?pSXYXQN2RqXWwhhqSJ2lKHqagXNv1ICVYf+5sJ5suxpdehpfU1tPeVp8ip9P?=
 =?us-ascii?Q?zUwtCjnZ3hp+eyr515JszBv/jWUFoLkFswQH4Pr1ulTZFRoSVkVCUWm48+LP?=
 =?us-ascii?Q?erI427+CT2KHfdSfibNtpc8kCBwS8aFnr2g40rpoVIlr0nN/ApPTWN749RJV?=
 =?us-ascii?Q?pMM/L0Ab0jZ/z/GYeWxIRVm7v/V5gAfgnOsI65VGTiOiD6AojzemQ9dQkk1H?=
 =?us-ascii?Q?MaqVotRJWHn+9tBFtwCT4/ZBIcsa7UrBXdjQGq84TL7YFyP+VhVI6sdNQzlY?=
 =?us-ascii?Q?lJVJYNi8FiznNzeFAbM6cxc6HevTJPyephzVuKS8p1ZmwQadlI7iWcwJiOXG?=
 =?us-ascii?Q?ciAuUlXGYK3q9MR3I1x/dI5fNzwlpkWqf1gPU0eagkH9C+7exfEPsZvKPFdM?=
 =?us-ascii?Q?3u8hhWoHOUJDfEITzXLzc6RbKg/RaMzPHfcdvjlYExnRg0PAvU888gBRUsOx?=
 =?us-ascii?Q?FJD3FQLxvUR9hRl9n/N/Da868UHyeJ6QJki+gRnGSzbcazueCwWuJATtRxP8?=
 =?us-ascii?Q?NpcTlHtRQAUHslAaiWXnDwAb97zBGLzZdCy+162ChFqtO4MVcKLam8n5AijW?=
 =?us-ascii?Q?ADy5b9kadypI2RVHaQ6Bdt7HHnMHFzyCCMaFVPjX7OZyqwqQHZ9rSRaZo2aF?=
 =?us-ascii?Q?M8o5LrYqEFhHzCvyrg+u2zDgouqCVHLhppxRQxvT+4WjuxnBfmxnLM2z5xC4?=
 =?us-ascii?Q?bdClzzzd5Y7Kg6NrfMSMwZVj+k/Ed+ZoT8RB9UHueCbQuGT2X8+HOnIRQr9X?=
 =?us-ascii?Q?1DR9cL4Y7f4OZ+3fcxHXOtt6GkCI7tgJgbDCFxWO6+4c8jpkCTieXMkmlOI6?=
 =?us-ascii?Q?qGkWYZrrKmrjTT/YNF6uv4KoOaaf2nopIQlUa0QRG2I6XzOx0UGA8BisBVeB?=
 =?us-ascii?Q?8YHLzAxbum77PFRuvgUzKAHYxoAb/Z9HzSTnTibf82BLYabvGIgTDaMuq41E?=
 =?us-ascii?Q?ufg9CaoFqZ7oY3NK8d0ctPAwkGb1nlKt+W8wKykREDiZbzJ7BKwkdxZ8VQ5N?=
 =?us-ascii?Q?lvjY9ZhscJ/qUlmTETkW2/5j?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4444fdf-a158-470d-bcdc-08d9666aed10
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 19:19:28.1012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8nPLeTQ3LKRlLp71JMgea8qXcwi3CUzKbArnsU5xWAHfBa4k9wjRCHxGGuVbdd1c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5553
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 02:24:22PM +0300, Mark Zhang wrote:

> +static struct rdma_op_stats *
> +mlx5_ib_alloc_op_port_stats(struct ib_device *ibdev, u32 port_num)
> +{
> +	struct rdma_op_stats *opstats;
> +	struct mlx5_ib_dev *dev = to_mdev(ibdev);
> +	int num_opcounters, i, j = 0;
> +
> +	num_opcounters = ARRAY_SIZE(basic_op_cnts);
> +
> +	if (MLX5_CAP_FLOWTABLE(dev->mdev,
> +			       ft_field_support_2_nic_receive_rdma.bth_opcode))
> +		num_opcounters += ARRAY_SIZE(rdmarx_cnp_op_cnts);
> +
> +	if (MLX5_CAP_FLOWTABLE(dev->mdev,
> +			       ft_field_support_2_nic_transmit_rdma.bth_opcode))
> +		num_opcounters += ARRAY_SIZE(rdmatx_cnp_op_cnts);
> +
> +	opstats = kzalloc(sizeof(*opstats) +
> +			  num_opcounters * sizeof(struct rdma_op_counter),
> +			  GFP_KERNEL);

This should use struct_size

Jason
