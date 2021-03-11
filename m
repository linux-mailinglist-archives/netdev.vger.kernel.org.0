Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF87B337AE8
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 18:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhCKRdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 12:33:55 -0500
Received: from mail-bn7nam10on2086.outbound.protection.outlook.com ([40.107.92.86]:35680
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229806AbhCKRdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 12:33:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XLPfKrtFZhQ27DFRneO2/Fpk1lqdp71wQNtEhFir2aS5Vxglsw7tYGCVLGofUTN7vwpKsZzU8sbdMBdqwcbqEFnRLxBceGyq8cN0lZRYc6fSRVAN/KoMizLqIAObBcw2nmC4SAF3E+VnEn2bYK7L2i8/5996/GYP0CPRTaawUpvE10g8Og2lnxWhIam6qeQGG7JdtcgWOht8YjclPZJ2Wf0Nwt4fR7F8P0N4luZGpZVfx1cVFRf8YczT83ccFj27V6xMz7VntVGc2metyoC+m/F9hp9gqpGX3s+xaTqWoU64kOwH3ISzwqYmNj//ecBmETs85SR1cldGo6kXjf1Hhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbstgYSpkrAMyABzav+0yJgWivv2jMYROirGopQN5LE=;
 b=Mnv1ZsinxV4Ue7ZpBdqyjqmn3zKrYsJdHv+w1ERYnIH51RQHHc1ISxXogS3FA0Q2hjjMado8Xk1Lb0HGTNWBmEDqZr009Stb/saundkY9pSGestzuj+7H9ZtVarh+/POxEGGj4LRKEL3QDm3tv7h1KGNzc0/JwkemGJVc5KW/24NZxpTpbR7E/Xk9Y10NHJlv7y/QsSxLc73wL6a+ZXhTOjEEc3Hae/4+PuqjYEhzzlnetXZ4b0T/mw60ra9fkn3jcqJXgOLEw6YW+i1nTlTSKJZbqR/i+z87oYMiewPmvRp9q0afVrGp4Di63ruP2DS/2z9w2UjTWF/vSoUBucKqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbstgYSpkrAMyABzav+0yJgWivv2jMYROirGopQN5LE=;
 b=FrxGkxbI23RcRx5dn43gE20b/XfZs/oYkTxavC7LNhJYVFyf+rNJrNV51a0QLQn1iN2fwEAENiYyrXp845/DVcpwyarZzKMhA7KC0HgyBbx4LSUOZk9vTjppQKBNnuqbFE7/FdvMI0lEc8IyaAKBbjubxV84HXYbwVs5UUSp11NM8zlurwkorfq1verTPhhy+beE84zF21rGuiu1jm5b9QyFBnpuq/64Hg74TExpjnKQKZ+ufRbEAZ31YPI0eN3YoPfvuUqiTUBq7E73ZaVIbyCuE0TuiOHn0lRdAQbP/2pW6+VZbDytOUqUxDmLYK7G7zc75mKdZkBynBHF/RHl6w==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3211.namprd12.prod.outlook.com (2603:10b6:5:15c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Thu, 11 Mar
 2021 17:33:38 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.031; Thu, 11 Mar 2021
 17:33:38 +0000
Date:   Thu, 11 Mar 2021 13:33:35 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>
Subject: Re: [PATCH mlx5-next 6/9] RDMA/mlx5: Use represntor E-Switch when
 getting netdev and metadata
Message-ID: <20210311173335.GA2710053@nvidia.com>
References: <20210311070915.321814-1-saeed@kernel.org>
 <20210311070915.321814-7-saeed@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311070915.321814-7-saeed@kernel.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR01CA0005.prod.exchangelabs.com (2603:10b6:208:71::18)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR01CA0005.prod.exchangelabs.com (2603:10b6:208:71::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 17:33:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKPBn-00BN3C-FY; Thu, 11 Mar 2021 13:33:35 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fd71d66-a99b-48d7-e865-08d8e4b3cd68
X-MS-TrafficTypeDiagnostic: DM6PR12MB3211:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3211AD36F17341F19117F304C2909@DM6PR12MB3211.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h43xlhPXT3Rlfju0XWhDcaJz8gD33eLRQUFJ/Jlrv2svxANCpBrWmiOiXaCz3Mq4AsbeTuuh0PvUHzfrjfvvHRrx1iRfVkemFuNNo3yjoUGrzqA9Q8ebSY/mMVJctZ7F7tW/KxOSlEwAYmP3ioRLPnpahaKg8pG2XimoGILL7bA9xcxcoA9bZyIoH7e+jQ/q93hEY5C45XBujYphJ07EoMLNHO9myniWgEv6zgv2DQ9/0YwmopXZ635MjtqD45AAyny8RyOE2gObllie7cyt7J9JRqHOKqHS1UWBepQMCs4O2Z/TY6l8BTFpg3hbcqe3bB6x7wu0v3Zlr6Wlc5oECc9dwwKsVnBcAzHbog8qso3siIXnshQzL99vVNjfJbhuAA/opACmhu20S6z+AQeCi2UJrMYyi7X7Hsc+AoYBM+pEwcwHvvMSB4gtUPZrkZ9zODyk05gIdPLku1icMKE1qLR7vmqFXPB5gTT62pJ7WTO17JN+3dq50ggNlJvEYyiaI9G0JNqpcEeQX1jpSH4KEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(8676002)(66946007)(107886003)(26005)(36756003)(2616005)(66476007)(8936002)(86362001)(426003)(66556008)(33656002)(54906003)(83380400001)(6916009)(2906002)(4326008)(5660300002)(1076003)(9786002)(9746002)(478600001)(186003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3ki7zsdWGUiWZibNcCqySw3V38HSWVNW7+IgbSR1to+yk5kJncvXaIJFK94J?=
 =?us-ascii?Q?VPcn1VISR9MToVEKbjHQjEER7suZN8B3x7qnBAEo7n6LRUa902Bzg2vx140D?=
 =?us-ascii?Q?ptCk42JF0c7tgDsAQ67BqiJjD7QLtOMRWVivqLKQoMWrKma5k0CLGP4Y3+YH?=
 =?us-ascii?Q?SlGJBzSoFbjROGd54q3mmAyd3HLuYmVhyGRBNJPl3sY0RgSGDaddEGSuKAKW?=
 =?us-ascii?Q?aRU2blzqbl6nC3lECO4tZ3rJcmkuhgBILDW8guB4GGCgM3AnqBMLqP9HA+zz?=
 =?us-ascii?Q?42rm7tqACQCFskmc8oo+yz4ObbNI0vMV/w4iUxF9CGhBWoGGSIOdzFjDZdPa?=
 =?us-ascii?Q?11+YDekj7EKPzaTbI0Fuogu6Cfgbp+gWgkRFKUKF1aGVIa7X0WskCKjwcWqb?=
 =?us-ascii?Q?jYntX/lkjXUYixB8RJlpU+mUIzXF14v/qZn+KpbYGdevpOTBUCQfmgSD79xI?=
 =?us-ascii?Q?OKbv4gr/DIrLWTjwK16WFYRk/JIfosnvj+nO2Xf4W16TghLCZlaWZHtbcOc7?=
 =?us-ascii?Q?YA3VYIAB4xi2JWpZ8HWaBxPH/OQNW+rayTLjwalkTi8SOY0RCgH3FlQrL31a?=
 =?us-ascii?Q?gnW98oORWaWSSvt1L1axcl/80o1j2NkPx2wBnsH+k+zfBQCeH6OwdC/AFcP5?=
 =?us-ascii?Q?ONHC1kKxj00bh2EhOPq7cUJJwgS/nMYYmFBZosIJwXZxoFVSaRXo6sPx9PlU?=
 =?us-ascii?Q?bzHS7dXzsJw6yiG+15ShxXlb8TZsX3rnXdSgmsicNTkbtU5Pg6Nh2Qvkri5d?=
 =?us-ascii?Q?PI3KxEbZtdYgqwS5RhA5ST1Dw77AQvkk3VcNSKufY8X9GGUmGTriB67LqaZl?=
 =?us-ascii?Q?pC1I7n+B8Ja8TBm3z6Z3ndrmipPqTQ6wC8otv0d9JE8y5u/nEEbFS9ldZA+8?=
 =?us-ascii?Q?XCB5AJH9vFyWvwOsg/Hs7TB1XbgibyXNDVdR4TZd+PjvbhrjlfxlE3Bevb35?=
 =?us-ascii?Q?PIhQCGBteOOlU3ktfxf+FWEeJhRHylyJAkWE3cIQKFPM5UESrvB+AdhwaO0q?=
 =?us-ascii?Q?oH7GTpgRsAJJA7bysRSX5EFGy4+NxNwhIXH9LVhE8MbEleuoMHeIdWhdc/FJ?=
 =?us-ascii?Q?D6I1kzZj5M2nl/v9Ry2fUKC+U2j+ARC+wcYlovdni+Nu/OjBU0ufnPxEEGre?=
 =?us-ascii?Q?6ng3tzbvMJYGnljwZi+2y4XIQBOOs7NkDyKC4JKA1VLVS+CMMH4W8woe5a5O?=
 =?us-ascii?Q?n2uHKPIQV0hW9qovj3lKruKRN6/rSloiyuX+bWwBNSfXAYUEd85q5BayDy7H?=
 =?us-ascii?Q?UiEISfL4YEyIKXVvqzPYyYtG4y5q4UyrE8qOJPBqZbUHJ1RIzv8RNa3BLshc?=
 =?us-ascii?Q?UA4vyQ9hnRptNDU9KVkG/HcVGX33ASGvhZNvlkJSmVp2kw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd71d66-a99b-48d7-e865-08d8e4b3cd68
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 17:33:38.2840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xF+vvBAouLsCxRXxrvJkYBeChzFWHMKXXja/RaP+OvseQctU1UplbsWoiypt3xpZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3211
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 11:09:12PM -0800, Saeed Mahameed wrote:
> From: Mark Bloch <mbloch@nvidia.com>
> 
> Now that a pointer to the managing E-Switch is stored in the representor
> use it.
> 
> Signed-off-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/fs.c     | 2 +-
>  drivers/infiniband/hw/mlx5/ib_rep.c | 2 +-
>  drivers/infiniband/hw/mlx5/main.c   | 3 +--
>  3 files changed, 3 insertions(+), 4 deletions(-)

Spelling error in the subject

 
> diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
> index 25da0b05b4e2..01370d9a871a 100644
> --- a/drivers/infiniband/hw/mlx5/fs.c
> +++ b/drivers/infiniband/hw/mlx5/fs.c
> @@ -879,7 +879,7 @@ static void mlx5_ib_set_rule_source_port(struct mlx5_ib_dev *dev,
>  				    misc_parameters_2);
>  
>  		MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
> -			 mlx5_eswitch_get_vport_metadata_for_match(esw,
> +			 mlx5_eswitch_get_vport_metadata_for_match(rep->esw,
>  								   rep->vport));

Why not change the esw reference above too?

Seems Ok otherwise

Acked-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
