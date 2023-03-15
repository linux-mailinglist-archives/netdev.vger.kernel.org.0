Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E986BB39D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbjCOMvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbjCOMvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:51:17 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9663D8B060
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 05:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678884675; x=1710420675;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xazWU1l7FXE1W9L4j5EB7fh0QQ9YIZ4h2sdLj5Xjas4=;
  b=ML3ymvPzSUi81PnVe23tUA9XO3IwsrkxPt/qFlKRvluEE22ISq2N5ZyB
   bk/7M3wGRJNIf9NFenShTSq5uEOeXp5Nm/4ZpC3uroAWuHWJ0+BvO+pl1
   XQcjWMCADBH5vVHaNzg5q6ILV/7WpSHOx50gZKg22abUags2/JdUb0iKr
   ADc3rLr2ULesFmfsRGQ0StpDBhZ7xvxXfQtO5QzRYAKvq1OrE+onVh+ii
   /qOteDOu7S/aixbQx4+uRnFXX3IGTOEcYyMX8TDaPJdV7qEuERDUJgzR7
   WSGuno5eaL5kB7F2WvbRDCXI4MtjT8wBYHI05HW+typ9ssPj/3UGTqvnD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="365371516"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="365371516"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 05:51:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="853611909"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="853611909"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 15 Mar 2023 05:51:14 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 05:51:14 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 05:51:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 05:51:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 05:51:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SdhbCE2uoq0zYLbdXaxXA6WHHBSM0MZLGU+47WD/pRUBKxGSKzIoJuU9BTE6dB0y3r+5XzhZACqMHZ/28xI84LsGD0Wln0Kju1Li/Bmd9CIGlq5KOVactmgL3AXfD2qo06eowy/t7g52qGhtLMlVM11Awa7DR0D62WdcsHYUP+xR4VPd8O5Eqs5qk24QG9i2KIF8EScoc2SC3uCbg1EbTyrAy82MjSLtWI81xoRbVegA3i5kWx6L8I6hEUO+8IkrKMdnig88zTKFv9h2GLnRnAILboPOcSgehGNdQv3LTFWpvGmJ9DxPeUcEmB9X4yupJP+jebgFtKE4qr89q4r73w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xf/w7um0L3MWkNfK/gbMR8pykWby7+HNXKgEB5iVr2I=;
 b=FGdsRKDNI6/QLTugqYdi63e8dFHwk8nMDOqroMWU9dkN5t6o7cdQ4rllVRBcoaBMFHPTAhlgmVE/b/Ou9ZdSNCxdZxnE6HbYNP5WvxY4Joz9quKE0QlL8dwEeY+i4rVdseutvgus7dF5k1NUkop8GUc8jck/gNGuodDnXODYrl2DAGXTRo119HyIYsgqVlCVAoF1b2NPD8pR7lyWGnLa089UNNrdWXulUljyuEhmqeiAqxQRG1VQ3xWo1DjFA9umuNn9RdSRP486KOM3uNPxr4T/CNqIia+pgumpdPKzPti2pipnvB0CRPzBRgysV8bV0sw6dDlxK0JCDWu6eXVPOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by IA1PR11MB6321.namprd11.prod.outlook.com (2603:10b6:208:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 12:51:06 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 12:51:06 +0000
Date:   Wed, 15 Mar 2023 13:51:06 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Daniel Jurgens <danielj@nvidia.com>
Subject: Re: [net 04/14] net/mlx5: Disable eswitch before waiting for VF pages
Message-ID: <ZBG/Oi7Bda3Rg+gB@nimitz>
References: <20230314174940.62221-1-saeed@kernel.org>
 <20230314174940.62221-5-saeed@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230314174940.62221-5-saeed@kernel.org>
X-ClientProxiedBy: LO4P123CA0477.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::14) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|IA1PR11MB6321:EE_
X-MS-Office365-Filtering-Correlation-Id: 89806985-4560-44e0-c2f4-08db2553f158
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZHkSryRCaB/43Z+LM8/jySlVym0CUCWdr3IglrOwwKHY0FmcqJJe9YFfPf4ZuNtiYa0KYbJUDRuhJXh4RwFz7njnUvkgpDDikqXSoJDMid9RTww39+WM05fi3q2cLFRdvC9APd0tTUtPTRYoQQQU/p0uNjvKARJshcbL/Z6tdQK3vWbsI/ETODqdZp64EmvHcy7h7b29JmtApo4fNUiijrZG4QL5/JQ6wVVNh4oA4ARfGtFBxISqJDVWKPyneCVpUMGqdk2ii6F1uljy65upWG7u0iMewCX323s56SOCZGxoV6K64N1WIyb0SruBzaLf209V4WfYuW2z3Xi3raPZMK0jjaBLcmGGX5zUNuhQ8YSo6aB9XG1JLU/pH8EVVOYGSsTGpOBNUS8ysIJA/Fi4cTZmw0+VV1WCTTUx74dHZeYuwOiCdOWYBMkCJJJUPwh5ASxPEPcCvyk6x4vfwx/ykLLiZBDRFLN5lhf1/2fWIWKJgk/TyOKbAiSWaDOg2OhzT4fhkCceq427S54YmLAtQMWedGC2b1yRCFoG7tF+R+D4pJdAAj16iHbb62UCOV3RtkCsM6FSoTOAbqZOJa+DBuxsq3XHqu5L7uVcILnwd0JqKttgPXX2GQAFGxp15yHowN99U2t8uOHzX/jl230kLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(39860400002)(366004)(376002)(136003)(396003)(451199018)(5660300002)(66946007)(44832011)(83380400001)(478600001)(6506007)(26005)(186003)(6486002)(6512007)(33716001)(38100700002)(66476007)(86362001)(8676002)(6916009)(4326008)(66556008)(9686003)(54906003)(8936002)(316002)(82960400001)(41300700001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/ofF82aM73uWkAOIiwUigd8XjnfLCcTn2HrFpHKX0dYZylm7GgtwNuUuTKQl?=
 =?us-ascii?Q?4X5J3UKEZzkG0kqrWFp5dP6rEvlEX13rdUcbpcuL7jhGFzLF0UhdE3P/A59J?=
 =?us-ascii?Q?fuc3sQPY6lJ4aXdR6QwDbAQh2aOXoGcZLbWiWloHKwNBDrb8QVBsocCScvCL?=
 =?us-ascii?Q?YdarmfO4dC2CdXoSu0or8CpG95FV4zjDugYGwc8tCXm40symxDm79Y1/KRJ7?=
 =?us-ascii?Q?/l2ou1DJEIkJhYFlScz0PQbNkTIJHNCawm/w0/33CfigWfOBogoY4VPuwSr+?=
 =?us-ascii?Q?rH7aLfcLMjK1AG6NPj+72n1IE7mHjGcDi0bdGLZTHW+fGO7mtFRdjlRz37e7?=
 =?us-ascii?Q?H3DKwXLH8M4wbSdGKjd3zbRUT4TAk2Nz9B33sb0QPAMijoOAtLNuW937qqkZ?=
 =?us-ascii?Q?sSCkBuXB8HJuxqD0zm3JoQiEwWcF/vQC/MZaME52JFwnBTc1BX7qs3t4FGb7?=
 =?us-ascii?Q?fk0XUFFZ3Pfa6KYjDpmx874lpsY7ctgNUKRC6hNPMQeSbmhkperSZd1NRGjz?=
 =?us-ascii?Q?W2pSp9L8+3i1EMIdm3T1PTnASjMqF9nTfBCH4CJr9vOYpfRqcEsyd/2Cd/PJ?=
 =?us-ascii?Q?DCc3LxBVRVqJiqdF6bC1GEjvOY2bFVDeRwIfKi5pt07LuK50edoCyLzZLWS0?=
 =?us-ascii?Q?EwiT0wpPjsskx8nbhqHFl/fMvbI021Npl1ognjDEcouADtYFV7WTUT/IeJ6k?=
 =?us-ascii?Q?ZidrK4Idy4xhbFiuU74FNQGiVQ3kp4QHRAeHlca68FrCd8ri/ZtAIh3FaW2e?=
 =?us-ascii?Q?SrSOSKtnQutdKOMygIQ7WTIuO077Xw+4qF9axvn96OLZQMl78F6MvIeowyRR?=
 =?us-ascii?Q?Glzs2hupbv9qHCVEz8K0yQwLwx1oiXthiga4mpNBbqWDh9exbsM1gvK3Kcs/?=
 =?us-ascii?Q?G+jRKijMSKwwPMB+J+haJ2u/1A/rE5WQQEw/XmiOD0fYZzJ5oKhQ4Z3R6v3F?=
 =?us-ascii?Q?nZ5kT2I3vhgxXqNbyBtjiW76nMNWyy5PERmoc+bUF3rY2T9PthPwHELNGcR/?=
 =?us-ascii?Q?zfpZpwi3+x0HixmmGvjy/uPUacRfUiRDipnRK3fbigakVovwzNzRd13RfvBw?=
 =?us-ascii?Q?nzNjq6wrfBZ2i3s9/T9Avf+oeLJcs4SflP5O6jve3eQNEAFzjPG+QhyDq6YO?=
 =?us-ascii?Q?zjWkVSspOBnAaH7utT59+Z0zNyEY1DoM0BVMTyzxFuQfM5adhZeLzXLbj1Wf?=
 =?us-ascii?Q?rXxzB3PVm9MVWMEVpon39E2KW2nCtLuU465mMIkSiWubaCfysNRHeHYPOSjj?=
 =?us-ascii?Q?o5yzRv/3Oo/b50SEmMCNG8QV39AIeLgaL7pXtXNzxGQuyQ2lCycoKg5BIkAK?=
 =?us-ascii?Q?V139jwIb1Vj91Z7q5WlUQy79DI9xx6gayKReIxAVEkj7HoM2b7diC9dCjbsG?=
 =?us-ascii?Q?t0tfi79CpS4qLf9j6nl/nBDIsPgPLSHLKrAElEUotnRA1MwtCCp2ucHW5/Xo?=
 =?us-ascii?Q?wFv0b9h1QKIuTCnTYK3JEwoj9p+G4/1VmX/AS7ObXFhs///lYNhm8S81K0lH?=
 =?us-ascii?Q?h1BXv/wOUn/J4pHecYuaPDH/qwMDC7K9kJ4drN+f31Dq21EbaV5GNqKRSlDX?=
 =?us-ascii?Q?uv7rRb2uPUDtXYLW7VSfA2J1sLyCcyjZfm6P2UdOvJ+S5hrvWjGYJH367dsx?=
 =?us-ascii?Q?9w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 89806985-4560-44e0-c2f4-08db2553f158
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 12:51:06.6415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6bM71EWZVFstY4P4XoPLPDvNec/hVoxtaPagxtKtV7h3XtmfGb8utDt+hQ3EDuZAfN8mJyBApymnFKcyg4NOCEJCxJsd9Dp9Na8oIbDKsJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6321
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 10:49:30AM -0700, Saeed Mahameed wrote:
> From: Daniel Jurgens <danielj@nvidia.com>
> 
> The offending commit changed the ordering of moving to legacy mode and
> waiting for the VF pages. Moving to legacy mode is important in
> bluefield, because it sends the host driver into error state, and frees
> its pages. Without this transition we end up waiting 2 minutes for
> pages that aren't coming before carrying on with the unload process.
> 
> Fixes: f019679ea5f2 ("net/mlx5: E-switch, Remove dependency between sriov and eswitch mode")
> 
> Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index 540840e80493..f36a3aa4b5c8 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -1364,8 +1364,8 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
>  {
>  	mlx5_devlink_traps_unregister(priv_to_devlink(dev));
>  	mlx5_sf_dev_table_destroy(dev);
> -	mlx5_sriov_detach(dev);
>  	mlx5_eswitch_disable(dev->priv.eswitch);
> +	mlx5_sriov_detach(dev);
>  	mlx5_lag_remove_mdev(dev);
>  	mlx5_ec_cleanup(dev);
>  	mlx5_sf_hw_table_destroy(dev);
> -- 
> 2.39.2
> 
Looks good, thanks.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
