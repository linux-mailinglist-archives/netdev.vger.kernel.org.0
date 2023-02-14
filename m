Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5C169678C
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 16:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbjBNPDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 10:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjBNPDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 10:03:04 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F07122002;
        Tue, 14 Feb 2023 07:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676386979; x=1707922979;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kX1NPelTt8WS4jdxAMuygMKDo8THrZVwrDXbIo1qxEc=;
  b=bEQpvcHh0lOAuFRE7JhKct69Nv4L3DsFzIY7dIiqshWoA1q31rYOC6y7
   uC4a5VOF2sCGlUQUi3KpQwCIeI9zSZIZLhurwwrKIrOYjQUjhBfxrG6Ri
   4zjTxHADDeuXLpnY0oCq4S1XvfJrcrvNQKU6irWt7OK+wJVzKS6aH4fHZ
   N5ps/ogi/nPXQuz/TSTc+gqW0Q7C+bHs+mBLfQoxH3XTJ93+9jYgI+0ef
   mWXJiYgj5f6p7UOS94hsEpcETUGB+3HbN6MRvrcNwJx3SqI0LGZ8pB9GJ
   h09McOTx9a8FkxN+0uj+9pQaPtAtyvdEXFeMcySFcAVhnuHXa0PJy/4fQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="314824329"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="314824329"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 07:02:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="701675339"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="701675339"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 14 Feb 2023 07:02:56 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 07:02:56 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 07:02:56 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 07:02:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vc1JIVwLmCRQLb3Zzho2acuvUNC8wwmLM5aVQESgTA3r8fB7OBoaVagfPS5PM7z0kdrZOOnnMaS+YImaZACv5K18r1H8TlBxQ0bU3QdZFOueuS+NTHf+mNUD7lJRfh9UmqsLBLUL5tuE+odFZPfKlcWXzurRkNv0BQEvCLm1ELDEZz11oUpsAmHSlH4mXOQBH2yHWMCbNpbfoXrIf5H1SxEHPM4lgmkEL9f9tQxwBrU7HiI7d0+KvCwU7kPOf1w8A/fyeYSfTsw/XkFKews+5bvSkGelOyxzLkZ+g6xONytpzWDYq5DbYiLzFzsj6xhFabthDs6vLFf5DODyt8ryGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RcRp5PlPbiHP2rV98g9HAi0mL2tJA6hvM4Ou7D0MxYM=;
 b=OJgAW+9FBpi+0J8mYA9sYNchPMiVmCIvgKAc7jXELFCMGCWNdI5/KPRyT6ukWZaF+ejN53dqvmt0gX++k2Rk/bYCgWya2+AqgzIKZOFRTj3CKBWNZ5vQ3KzM0wJwgU9BtLd3pONThpv6893UdcS4WL06H6WIqQw6yo0U7Sisll/X2RGOfVzG2i3WCZB8CmFj9ODunq3+wtM+qi8+z1tgrd2QhI/S6WG4Wvi1tYrIK9Pmw0kNtgqruJgSm3ejEZP+jq6UBQJ5ZzGIy9HGT//Y0ob1xh64q/4gfBs4RrVqByaRBGQOLzJ+M1vy6oAF7xerUoID+jIWBgV6IoBZAURoCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MN2PR11MB4630.namprd11.prod.outlook.com (2603:10b6:208:24e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 15:02:54 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 15:02:54 +0000
Message-ID: <611a9a70-0f6e-cba5-dcb3-3412e6e9956f@intel.com>
Date:   Tue, 14 Feb 2023 16:01:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v1 2/3] net/mlx5e: Add helper for
 encap_info_equal for tunnels with options
Content-Language: en-US
To:     Gavin Li <gavinl@nvidia.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20230214134137.225999-1-gavinl@nvidia.com>
 <20230214134137.225999-3-gavinl@nvidia.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230214134137.225999-3-gavinl@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::10) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MN2PR11MB4630:EE_
X-MS-Office365-Filtering-Correlation-Id: f1a84812-e071-4f46-23d1-08db0e9c8c78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iPwEiA2rUOn1wkpbRLqp2cPRGXyMSQE5ByS//rg9JH8Nl7ES7Vuw8s1C9Jw8QB+QiTRxIP7v1rV+oeSUqkmyewP3aRLz51GQJ9vkcwVVhPGy/BDBbRu+qUVSWwskw1sGMoSuUiml2nzj3ogKvbqWoPouQmzqYcDL/7TYRDg2+LJJYVVNNT/3Ya/0Ynb+FVa3BPFaYIGdM1A9mpm/jONwkUgXoETtt8JHN+tCOqJ06CuVU7D/3WIo8CiUK2CFJ9NXYcy5FC1MRGwQmro2OZE9pq24CN1YFu+njpi5m9o77ZXBSMA3ClwjoE9uf19O6adkX4KcBWAJi3TPUdSVlcxIrxA60t10pxadXuPulbzAdQDZ4A4HtRvv9NnKAPFlpjOejzWqEiOl+wm8oy1bAOwrVyplnIjyRbhBrwFtBWfqNiGv5/Q331I+nENcahapRNDtgl0+Jb67UNeYMbiSWKUU0vssL5Sqo0HVFRq4uQ2HBX+fi0oLFuajazw/mNZ2LLEduO/ntbbmbE0pmyzXp1kHxClLxQLLkNbZBv9mF9/+c+NKohIsqILhhfDqdWnzaC3Q4fOkrT1k/s3MHkdJJIltWbCIJq0DVI1cBlogZj5SQUNG7pRuYPMm82RLotiE9DJ30uFq3aFbAWqKzU+OKV601EpOR3tTc9+s0QfRgTSOy+xnnf7LCIMl5/Dy1kR566TcXtvekrJELqAV3GR6guBI/mNmg87/SX+RsaDVH/wQTgk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199018)(6486002)(2906002)(82960400001)(86362001)(31696002)(38100700002)(6512007)(478600001)(186003)(36756003)(2616005)(26005)(6506007)(4326008)(41300700001)(8936002)(54906003)(316002)(66556008)(8676002)(66946007)(66476007)(6916009)(6666004)(31686004)(7416002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXQ2UDNaZ0kvNEN0dncyeklrbGZacXVJN3c3SWl6NDhESFJhdWtiUlVpdXJr?=
 =?utf-8?B?bXZNQXV4K1RRRTU5YXBzWHBUcjhjTDdvZVJiT3JrM2daL3VjVklYT2d3SGFp?=
 =?utf-8?B?S0VuNk03a3dWR3UvdnZZOGdnQWpLWlJzVFU1aEo5UTNHc1c1eW4xbGVOZkZZ?=
 =?utf-8?B?WjVpR0ZBS3J5a0VGNmpGd1BzOUt5LzhmN0ZWblR0dmJidjFnR3RyTFU2VjNz?=
 =?utf-8?B?b1JHcXF2bWV1cUVHOUk5REV1dWNSYUM1dzBkd0UrSlV3NFFPWldpc25tYjNo?=
 =?utf-8?B?V2ZKcWlCdDdhcDdTSnB3VDZlU2FVTGpYWUdadGN5dkxxVTR1OE5hWlJ3eklk?=
 =?utf-8?B?LzZXMi9JM1lqQ2E5WXBZWUZhdm9rblhNSEVHY3pWU2t1bnRsUVljYTI5V0lp?=
 =?utf-8?B?bzFCS2J4a0lWcWw1R2lFNnVwaHZTdU1vTHZvVm1SMitxNzRkbThNQk82Zzk3?=
 =?utf-8?B?b3RtYXlqQ1hsTFBKMGpRN3k1VjNJbHVhTE1SOG83OUNvWjAxMVlOanFPclVF?=
 =?utf-8?B?djhQS1dVNmp3VGZ0R3ltTGtOZTRXRmZYOXl5TElIbFlrRUpBcHgrbXl6VHBZ?=
 =?utf-8?B?eXVBdHl2Zjk1WTZQL2x5a0xMRFlYcUNuRnVQM2dLRXJrcWxpd21UMjVjazR0?=
 =?utf-8?B?YWI2blltNFpDT2psNXN1MHJ5bkQwK2JUTjhnNUhKUlFaOEV2MlYvaU43L3Zz?=
 =?utf-8?B?a3NxMGtwWlo0cmFyZnIrOEdLQmw1UXJ1TktobkJLaVBxeTliWEYrdnZrOXpT?=
 =?utf-8?B?ejU5bFovekpDZThJRFB5azR0NytoSmIzeVlnd0RoN1pDa1lNM2NBOWduTFh0?=
 =?utf-8?B?amlqMGJ0czFuaENpL2ZINFJJQkJuZDB6Q0YvSVAydXA0SXRiZmxzanRVeEg2?=
 =?utf-8?B?VThqR3BmaUMrQkttVEg0YldDcFVRMXNoRENiQkIvUzRjSERBOW1icU5PaGUz?=
 =?utf-8?B?elBzeXpFVTBmT25LUGl1cUkxdml0SGY4RjRGWTUraUI3bTdIV3VmZ2JPc0Y1?=
 =?utf-8?B?UXl4azErenZlQlJGQUhvZ01uUnNKaGR0QkVUMVVMaXRDMVV3VkV4RGxDc2xh?=
 =?utf-8?B?elVTRTBsRnhPYTkxaWZkMUt0cVo3QTJKRUdTTlpLY3BvcmpkbEFUdWdjRTkz?=
 =?utf-8?B?MWFob1hCaVJqcTYzSnhVdDBwZERoYWljN2VBa1ZObm02RjZVMzRRejZIS2Vq?=
 =?utf-8?B?aUM3ZW5jNW52ZkFiRm54dmJnMFRjN2dUK05LWGFOcjV0VVBkLzI0VFVmT1pm?=
 =?utf-8?B?NlY2Ym8yWncrMk5OeldtR0JTQUNOb0UzUWI2N1JJU3JnZkFrODdOVUp5eG5D?=
 =?utf-8?B?MmVUY0VIY2ZYaXlqczJpM3EwdDBHSFhUU2E0UEdMdWZDbGFiMzY3MFdoM09t?=
 =?utf-8?B?QmxJZG5VMkY3OGFJU1BUMFhrSFc0aGpzY2h3WXBvbGtEdlJ4Y0xaRy9NL21F?=
 =?utf-8?B?M3NCdmUvNndqZlM1bEFiWDl0OUpRdG95YW5yL2pQRnlFY01uOXo4QkszUndj?=
 =?utf-8?B?RWNKYnBlMmRWV2JlVDZIVTA3STBuRjh2NlEzakJwZkpVZHNIbTBRTnpzb1h0?=
 =?utf-8?B?dFJwTnF6S0VLVVhWNVNDcWR2NmJENndGOC9Obk9VT0JzRGNWbkx5Q3NCOFkw?=
 =?utf-8?B?dlNzUVJwQk5xbHN5Nks3SGVKYkpJZFIrenNMZEhSOWNWN0VNQnlsLzltdDNr?=
 =?utf-8?B?c05GK1BkQml1QWwxWUFVdkZGbmtvTVZkbThmQUdMVXUzQkF2ZlZOa0xvc1lD?=
 =?utf-8?B?MkQ0MGZ6dnlIZGdaVzRIQlJqTVUyMC90RjVuQXpzdFQvTkFWblkyUGFjRG5j?=
 =?utf-8?B?dmZFd1dwMDFpTWgzMm94LzVXd1ZHaWVXSXZ2cDBSeXZIWWczb3lxUUVwTjdT?=
 =?utf-8?B?ZHo3anM4ekM0WUxLOEJwdzlKSG1wMGVNbm1mZ3dheGdXTU0yL2kzV3pMNWVy?=
 =?utf-8?B?SVo5aFdvMXNaUG1yOGFSVk8xaUxmenpDa2p2d0NYbkEyZ2ppcWxtWHYwR3NW?=
 =?utf-8?B?eld6SXpWOTlLT2ZNZXRuMC9LSmVScDBDSVNqTUR3WVN4TGhyeXN4alhadmpX?=
 =?utf-8?B?cklHOEtvWCtKS0dNUEJhbGlRRllwUXd4YWJQTDJpM3NlTThidjBZK25xSnBq?=
 =?utf-8?B?YVpzL0oxWitMSFhZaFdMSXB4b1dGRzJLNWwyN2xZUjdyelRQOGlSTk5yN2Jt?=
 =?utf-8?B?OEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a84812-e071-4f46-23d1-08db0e9c8c78
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 15:02:53.9927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7jPYPvN4su8vOVbZRjK0+6x9yu4FyrFLKdnxEdC7xyHKBUlc4W6EaMmqwQzWx3hoMWB8dUWwB+VUt/Mi4HOKBMfU9g0c6yZDqCZWKMd0kDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4630
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavin Li <gavinl@nvidia.com>
Date: Tue, 14 Feb 2023 15:41:36 +0200

(dropping non-existent nikolay@nvidia.com)

> For tunnels with options, eg, geneve and vxlan with gbp, they share the
> same way to compare the headers and options. Extract the code as a common
> function for them
> 
> Change-Id: I3ea697293c8d5d66c0c20080dbde88f60bcbd62f
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Acked-by: Saeed Mahameed <saeedm@nvidia.com>

[...]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> index 780224fd67a1..4df9d27a63ad 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> @@ -571,6 +571,35 @@ bool mlx5e_tc_tun_encap_info_equal_generic(struct mlx5e_encap_key *a,
>  		a->tc_tunnel->tunnel_type == b->tc_tunnel->tunnel_type;
>  }
>  
> +bool mlx5e_tc_tun_encap_info_equal_options(struct mlx5e_encap_key *a,
> +					   struct mlx5e_encap_key *b,
> +					   __be16 tun_flags)
> +{
> +	struct ip_tunnel_info *a_info;
> +	struct ip_tunnel_info *b_info;
> +	bool a_has_opts, b_has_opts;
> +
> +	if (!mlx5e_tc_tun_encap_info_equal_generic(a, b))
> +		return false;
> +
> +	a_has_opts = !!(a->ip_tun_key->tun_flags & tun_flags);
> +	b_has_opts = !!(b->ip_tun_key->tun_flags & tun_flags);
> +
> +	/* keys are equal when both don't have any options attached */
> +	if (!a_has_opts && !b_has_opts)
> +		return true;
> +
> +	if (a_has_opts != b_has_opts)
> +		return false;
> +
> +	/* options stored in memory next to ip_tunnel_info struct */
> +	a_info = container_of(a->ip_tun_key, struct ip_tunnel_info, key);
> +	b_info = container_of(b->ip_tun_key, struct ip_tunnel_info, key);
> +
> +	return a_info->options_len == b_info->options_len &&
> +		memcmp(a_info + 1, b_info + 1, a_info->options_len) == 0;

1. memcmp() is not aligned to the first expr (off-by-one to the right).
2. `!expr` is preferred over `expr == 0`.

> +}
> +
>  static int cmp_decap_info(struct mlx5e_decap_key *a,
>  			  struct mlx5e_decap_key *b)
>  {
[...]

Thanks,
Olek 
