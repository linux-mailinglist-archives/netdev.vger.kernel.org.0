Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B414B672AAA
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbjARVk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjARVkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:40:22 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725693C24
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674078021; x=1705614021;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6odpgnmopb4EZXjYCUkYpzfWazDZWa73ykeG14ScA0A=;
  b=nWG0jyuohcTxnzC6vqMiLr6d/tcflXEaOswh2wYBosCTGKtrbC6lEjga
   xdmuOzCIF1YMBICkp6YNx125vFbcdV/+rjOVnizrufUqaErnlYwhxzpwJ
   MZE1XRftmoIJFAoK3LD2G3DuF+FTr5jGPfgI5TT1WFVDCWCggJUZcJzDb
   YgVJM+nWpw45BUcE7FPUeaB3VY3GxPpWaaQyX0vyqEuHipWEj/GuqCFj9
   8xqVaQyIaiGdxiPgNCliy+wQb4Bea5rYb0P440y9VMMqkvTP9DjAGmLq4
   YYAdEHsUzKIq8e66+P22gtiZo8JTZ8lW2WOuAK6MEtkDN9PO3cfUyGdQD
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="387459947"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="387459947"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:40:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="748636790"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="748636790"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Jan 2023 13:40:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:40:18 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:40:18 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:40:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnZlOvJ/HWp3SxgsZGDsZtTlgHkTrLg9x7KCPQX67sBxo4gtd3IbXwKe2MHhITaTWNZiMhTUCVbkWFTVPUzedODbGoSTOaUqE4F4xZNUcJgoruaz5lebSlkcWMNWzc+WCwHZqosOh8lp8uZsBGlM/wU2AMPUUemZJUdK1cF34J4eNArm2te1M0gthJohP3BvcChB/UQoGtSbTdLzaKCb4i8x26Gf57X//DWscljCv3rRQ8mc0Y1L9ss3UGve+x4C9ew/+BfXuSqCb+hkGoEC0AK/pL07bb5aM1AM2BlNllyuBI3njUI1w6DeYY/kJsSF6plHVGXkZNThC8jjZ/Zo7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hGmeU6ey19ywYkHNdyOuRLjM/3f3qfbMFcesz9YFr/A=;
 b=Zgz3k62yP1u6nN/uRP2qBW5fAFPHL61ukx5apRPvP4GvMkLEmNCnryDSL4OhvtxGNLJBXPkJiu2K2KsXbPm6/CcbEY5QdYYivxuQ16SydE6ka/mPnFxdAPTiQgiVErdSBSDYKOuev4INZhL0OGjK7dOFi0M7E/1ovGoAevjng0iKI8PJw4HxrZQFOhWSvDQ9OOdk0VgrqVF1jdssVloJRA3TiSnBwbnKlUJlIZgmDaanLXkVI+2+Itm5NEX5uoO/IWhrHVVnoUZsQXPc8DnPDxaJFDmzBBcb1rg60AfvWOXulpd8Qnqf8RQ0UttSvtrxspkYWgqkx7ScQQn7xebN2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY5PR11MB6390.namprd11.prod.outlook.com (2603:10b6:930:39::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 21:40:16 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:40:16 +0000
Message-ID: <a502e055-2210-0831-531b-3fdc9ff545e0@intel.com>
Date:   Wed, 18 Jan 2023 13:40:13 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 05/15] net/mlx5: E-switch, Remove redundant comment
 about meta rules
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-6-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118183602.124323-6-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::39) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CY5PR11MB6390:EE_
X-MS-Office365-Filtering-Correlation-Id: a50ba63a-8e92-49b0-dc93-08daf99c9691
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mw7T9iiYOWugK45sPICQWwBkBPBMVJEJTBVCiJp9MylDYKFOTrZMKaeviMRjPBOpx+sYgvYLZCFpMGX+YeHO7OIFr2I9rKh/eaZFX5p01FRUMRJ6+58nze3IJPr8WtneIAlnDW5xKhzUIsu1nWjsUjbnewgKeIDc3n7/pB2duEqQFRF4GJ1+aD+K4rgFplDbzkZpTVkAc7DjvnRRPxnhauou9jOxikOrFpKyyijNgmHPIopUz+IIW/85ttFcRU5w6ivtfQKGEq8VmEB5EtktWL6foH3hoyjB1l9LWguevC3H5E1DUOUvzOwcdfRbyONB+xdY8UQhurcetQdWRi9NqpbuaGzB2uXqbI0+xbdwipSu+iZlzIiLYZvG3tW1feRmE86X3bs3DXm1+nzPwRtwWRUvhhdk05W/Dl/CJ9ZsWn0WUYsg1fFqpVUbuPMxeOEQe1NisLEXkMuEQNRIQBKV1vnjypXDcG40AEG92hjxgDkB49uTQdzkzFqXg7uDVb0IhZlBC9vuZA/kWi1SYKMdkAXrz+0X/pE8Q/SZImh+4xw/DeIZmd8NRreMTWvq2C+x0yBPoE3p0QrabLVLO1ut3cduLs7yq2CE29njrlXM0ktTi1UzLPoOFV+1LkZqBCcEvAaz/23Ztf8Yb6rIUJlzfrwNkP4PxvPSM07U0NjUHyAUdEvhbFj2cyIkjEqpY3IP7Wm9rGm2ICGEKVvgCuJd/udAPP2TzJcUfFlX7dSv0PQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(366004)(396003)(39860400002)(451199015)(36756003)(41300700001)(86362001)(4326008)(7416002)(66946007)(6666004)(5660300002)(66556008)(83380400001)(8676002)(186003)(8936002)(478600001)(6486002)(6512007)(6506007)(26005)(53546011)(110136005)(54906003)(316002)(2616005)(66476007)(31696002)(82960400001)(38100700002)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amJuS1pERjNmT0JoajVBNENTeUpiQWxOdm40V0Jkd1Q3THVIeFY0WU5ieEk2?=
 =?utf-8?B?aXZObUE2YmQ2eU9NQXVsS1JWWS9rVlp1MGtUNHRscXliRnpCNDNUVjBsM21o?=
 =?utf-8?B?UGd2Kyt0VlVuVDBaVjV0T1o4ZlZYRTFrTFNBY1NXSFM1S3NTK1N0dlFuSFJh?=
 =?utf-8?B?cERCd0diZWZJVzVzcVRreXVHdVRSYkdiK3pta0ZmV1lndmdqS0d1bjdzNFV6?=
 =?utf-8?B?cTlZRnJTNjU4OUEyY1R1RzNnd0pNMUJDdmorYlo5MTFjamZ0R0NpSzF5bFJL?=
 =?utf-8?B?Q1drbWpRdDBPckhpTjRhMTBxYmpURExpYWVZTDFOQ3Nuam1iUVFIN01CTUJO?=
 =?utf-8?B?NFFhczd5UGpKMXdsMC9nUGhLdWVYV0JHMGdMLzlzQlgyQlZ3QitKUitnaU4z?=
 =?utf-8?B?dk1sQ0cyMzJDaXJ2Y1BxaFhaUG1McE0yMElIazlIdlpWTGJuVXluT05KZS82?=
 =?utf-8?B?OU4wb2VOc1dwRVFtV1N5OHUwRU9zeTZVUEdiZlMzUktVdHJ2WXI3MFYrOUpx?=
 =?utf-8?B?UDFpZjYyb0VvRnlQUzVxdTNxck9wZXZ4aU5EWWlIeVR3eGNyT2pJNEROUGlp?=
 =?utf-8?B?SmxTd082OElPaXJmNFJYZzZMcEpOV0ZrdVpXVGZlQ2ZzbXNFRVhMdk00aHJT?=
 =?utf-8?B?dDlYdHJla1dPcGVRY216eU5xdzFXb21TdWFRcnYycTR2a0RzWXBhQWRBTERy?=
 =?utf-8?B?aEcvSHJPY2hqS1l0MDVzVkFLZ1BubXpLT0xldTFKbzVYMmYxbnpHbEdXMWVY?=
 =?utf-8?B?RldyQ21qZWhPM0VidHJLOUt1VktUOVVtUG56QmZRY0FqcDdIS1QxNHIrSTF4?=
 =?utf-8?B?SC9nVUorVXU2Sk56T2FpQkpSaXoyVGdpSWRaUjdURFpmdmhhMjZwWUtoVHps?=
 =?utf-8?B?eWVHUEp3L1Y3N3dRQ04ycldCcHJpRXBHU3hqWTJvd0hqUE5TekI4Nk9RVExs?=
 =?utf-8?B?M0cwVzdlOW85WWtjeWxWVS85ZnRJL3NSbnpCSHlsM2V3bzl3dEV6dDR5OEsw?=
 =?utf-8?B?UjNYSWdHQWQ2YnJOZ0M5ZjZISU45VFl2Y1doOTUrYjJ0Vi96clZ4bkIxZDh3?=
 =?utf-8?B?cGZaMFMvQVpjcXJ3Ri9PWS9jWXNlZXZuUUxPRW1FbkZnWTd5cFBuUlBHODhZ?=
 =?utf-8?B?dFVJWWhFcGxDN0R4WHhPOGNpaDJyRFdVYmNNQlROV2xZVnB1WDlzTHlaN00w?=
 =?utf-8?B?MzBxaGxJYUtSK0dFblVNY2MxWUZpdDlRSGt2eDRqUjFXWU0rVXB0M2JzaWhH?=
 =?utf-8?B?anNiQkRva3krc2srK2tDbW5MV0gvU25uUDZtQmVhS1J0VTdUaG5JU0xDb2c1?=
 =?utf-8?B?SW5NZyt3dUM2QnFPbnUyT3R5NVAwdlc2YnVUVUZpN1RmWDFIUzBlaVFDQ3lO?=
 =?utf-8?B?dnlKSnEwa3JoZFhta01EeWF5SUovaEVnN2VuUFpmTTM2a0ZvREU1Rk9jU0c2?=
 =?utf-8?B?SXRrOW8yNU1zWVI1dXVMbkRTcmhEUEY4aHpHWXMvYjZML0loUTZrL0Npb3Br?=
 =?utf-8?B?d2JMb2hsR2NRL2VuVmQ1YkhtYTlHZFdWbmF2bjc2LzJYT2gvNFhCL20zTFF6?=
 =?utf-8?B?ZHl4M2xQU2RMWmpjeUxkZkZvSEQ0SG9RM1VEbk80b0ZKS1I0dXVLTjBXU0ll?=
 =?utf-8?B?MEJlKzUxWk1QamNLeUJVZWJYWVcrRFBjTlkzZVpYZkRZT3V1bnQ1SzZSRmhM?=
 =?utf-8?B?alk5K2pjN2V3c1kwVjlPWmtlbDNTTjE3MzVQSldOTlpuMHMvTldDdWdyQldE?=
 =?utf-8?B?bUNNVmZNUWZtMEdrZWx6cTBVLzh2MExMRllSMW8ybFp1eFFqT0oreWR0R2pX?=
 =?utf-8?B?RWpWTkxuM3RNbExoNjZPSEgwbXU1d0tIR1p4MEVQVUJsNlgvdkVwa2NWekdR?=
 =?utf-8?B?ZDlPOGNjMzM1WC8yUVZ0cjhKTDRhYmpnNjFpYytzSEhKYWl5TVRLZ2x6bXM3?=
 =?utf-8?B?YWw2ZDVRMDBSeHlnd1MwRVhCYWlVbGQyVWxMZkkwaGtnZE5nWSs0Y1Y1Q3Fs?=
 =?utf-8?B?T3BIbU1CMEFqUE5XUkFmcUdoUS9PZlUxdWxVdk5nREJURlpYT3dET2JTK0lH?=
 =?utf-8?B?Vkx2eDhkVS9pRm0vQ2E5ZVV2OTBpZXp1TVV3Q0h0c2dKM2VDb3RJNWYyU0V0?=
 =?utf-8?B?QVFGdURsWXgxd2tUNVFuRk5vdzRlR3Bwb1NQa0RyME9jYUwwbm5WY1hObzFR?=
 =?utf-8?B?SkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a50ba63a-8e92-49b0-dc93-08daf99c9691
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:40:16.3796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5io82u0WpeLW8BaX7vJK7wgTk6wA3gsd4cy7/HREbf2V53VRUZkjwL1sIdgRUtYy5PM+QfyBlt4JJ/NLVbILGMgBUP3O7x1Y41Z90i19jVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6390
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 10:35 AM, Saeed Mahameed wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> Meta rules are created/destroyed per vport and not in eswitch
> init/destroy.
> 
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> index bbb6dab3b21f..05a352d8d13f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> @@ -1406,9 +1406,7 @@ void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf)
>  	mlx5_eswitch_unload_vf_vports(esw, esw->esw_funcs.num_vfs);
>  	if (clear_vf)
>  		mlx5_eswitch_clear_vf_vports_info(esw);
> -	/* If disabling sriov in switchdev mode, free meta rules here
> -	 * because it depends on num_vfs.
> -	 */
> +

The comment was added in f019679ea5f2 ("net/mlx5: E-switch, Remove
dependency between sriov and eswitch mode") which included the line
esw_offloads_del_send_to_vport_meta_rules(esw);

That was removed in 430e2d5e2a98 ("net/mlx5: E-Switch, Move send to
vport meta rule creation")

This could be viewed as:

Fixes: 430e2d5e2a98 ("net/mlx5: E-Switch, Move send to vport meta rule
creation")

Makes sense.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  	if (esw->mode == MLX5_ESWITCH_OFFzLOADS) {
>  		struct devlink *devlink = priv_to_devlink(esw->dev);
>  
