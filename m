Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DF6672ADD
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjARVux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjARVuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:50:52 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D7C59551
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674078651; x=1705614651;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y8zQfUPaGAhrM7wwegT8sahcyOL4WPKGVo+81CDCV+I=;
  b=hQVGzSDfQm3AtL7IHI+BJVLoNjjKSFy/2qaJAHIGlGb3gVci538SzQ1v
   xcnWl+TdaesFaqs/yFprZxo8C4VZ2Cd9cYCi5NaPL4Z/E5evhTc6eoGV4
   G80mcHYCoSex1riMUa1m/uJeRmrgffBfRq9Wlrbse1uT3wAcZuRE/K7m0
   Qsr9acqmGbGHE/A/RR6b3/GywX2RRLVavXNxLbaZvQwCJtQ/tB6G7d7qv
   MzB+FN8gdJzp0nf4PbzQ2AfHZn8gICmWvgeE5BE/7QRCFHq+E8IfONr46
   kUiteAf976yw7NpGq+7howD00iwJOiXXSLXFjSfbGeuKi30oSzxlDY4Q6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="312986029"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="312986029"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:50:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="723252676"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="723252676"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jan 2023 13:50:50 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:50:50 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:50:50 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:50:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yt2WCBn9JXClLog2wkNo1x59MecXMRaG13AKlmq+Rx6HODDPWPDQwMUWStQ0d7SWARaLN49csuz5+WB78zpZD7SLj6HAYwoetHqWR0JvUTxqqjoMjstlEmlv9EWUdh2vnwjHStPYKTo0RCyRhu4wpxXWnLi9HL6kqEMM93R7RaZ+afehHrmTnMqQvUNuKehUHYnnoXsi+jLxmzapuwwO2jN9VrSn40OxWk9JByO/69Rs4uWEZKk9s6h/NVRWqKx+4MP3ya8HOgL4bwx3cw95mjBfanv87dH30eSnKA0LAs4npcMEUfC3oV1GZCoNHBFO0R9oZ3Nec9B+jP+Iw+ngsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AK/CqRTKXR0xs4k72ECyq7TjM+qptda9dPCsLenysuU=;
 b=dbTGWZpn2BRUGtB/Gsb2i/tkPhRvq0JiZlBNjnci85WoYgWPP/yKFvu/UdvGRLqa8lx2WfXS4EZ7QE0QO3/zxRoiA68uXtLHhKNRGnzRahz9vO3Krnas8cL+HtUOLc6ZjG2dQVQYpKacKn9vynffaOGfU3ZE4PWzUJtsKuH4mB8NEX06uJSSg5godaUOd0TUS7pJRKyd8vDf+a2GalkgrIBsjABwDouTVLUm2Yz5Y6ETzRtjACZMRHeIig2jILMECgLtZe6Cz8YTE4RrLRXYOMyMUQWhCaY/MpGXZZS+m4JMQiC+Vx0zhmFqDXxzs9RUz3/IPxIUWzKtiCvNi4vDhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA2PR11MB5211.namprd11.prod.outlook.com (2603:10b6:806:fb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 21:50:48 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:50:48 +0000
Message-ID: <25315234-d6c9-3b4e-d041-d2e0dcae0d5e@intel.com>
Date:   Wed, 18 Jan 2023 13:50:45 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 14/15] net/mlx5e: Remove redundant allocation of spec
 in create indirect fwd group
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-15-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118183602.124323-15-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::15) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA2PR11MB5211:EE_
X-MS-Office365-Filtering-Correlation-Id: d917636f-fa20-4729-7348-08daf99e0f48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oS3pwyDK6kZlWlMKUq3FsWGKMYJbJf6WBhZtnPFInlWRkoPS1tkhiloOozCXUhiASQJ1QE8EH0nLbbQmYF7AxSJNseIJDWZeT+0g61F6UWHPLxYEwFGwQH5B7ZxdVQTP8ZJORiuJgpER5W+oxfAN2wu+NRjvRmRLAFjKnTA/umfVZmqilgXAeiAh07kEW484GRu7Af/xOM3H7+fGNGUWeKRkm4MltUPqPcd398df+p4BCamz6nSmWLXj8Iok7Ecxu7NQp5jAcBNOX8PF+4+IK84SygGVAXlmjZ2rmk8iQYYLaFrhN8wAkQ5hHwgcvNy3ICtNCGN5b6MwTkodd5DZP8dNH7lniQ1zNpniCBcJGJ4iMbjbf/mVF8WpY2qHKKTTWvJgw/Bf1xXwIEYhdmJZKeACnznWCZyuxiqbUVD9PyLtaeuyrNxeMVW20fZ29vCrnZwJQ32cOcgeQxHNBjn+YZPSBckT3UtUkVDS3EoEdTLtDOA8B6SM19089Pnu8fDy67rl0cHgCVYGmASkci+1euoCsZicup6SJyhgj64jMl1w2zsG86qNYXWgnHvcUDJGCdxukVdifINcMza96vJ8/SJ42EYcWbkOJpQikkyggJYgZYJYurxvgYLBT1b4Y6XXxfozBVrhdPQXFTu8Lxyg/Mehn8J6AGnvQS7uWySQtUSj0TUdLIchZF0ie0t2gyHDTa5HoDvO5lwlFhMRHaNBRw++ZiuZXHAp8tm+uOnWdG4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199015)(82960400001)(38100700002)(31696002)(86362001)(5660300002)(8936002)(7416002)(66946007)(2906002)(66556008)(66476007)(4326008)(8676002)(41300700001)(2616005)(6512007)(186003)(83380400001)(26005)(53546011)(110136005)(316002)(6666004)(54906003)(6506007)(478600001)(36756003)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFVEdWluV1llWEdzWXFVZjhiTFBlQnZxeHlvbU92Ukw5WFdpQVN5UmhEcnRa?=
 =?utf-8?B?OEg0b1hja0sxbXNGRnd3ZGplVXFRai84V1lIbFhVN1hIMmlPL2k3VElWSWFC?=
 =?utf-8?B?d3p2MkhjbmsxL1pmb0dPR0U2c2VrU09uZmhFakpCdmo0Ri9JSXI5dzdDMDg0?=
 =?utf-8?B?Snh4ZjJQV0F3RG52ZzFpUVA2K3U4akFzSVR0OG5xeVNzUzExMGFHa1g3SkQ2?=
 =?utf-8?B?WlZyNDVEcDhiUlpaVThCNWpxNVFSRWZiblFMK25EQ1E1cDExYWVSUGZSdmtz?=
 =?utf-8?B?RXBBM3FCb1kzWisvRVRXREp0aW9EazAzMGd6OTRmNU9lc3h0ZDg3ekExSHdG?=
 =?utf-8?B?cEMvaldiRGdxUXkrcVRXbXFiMzN5aVQ1dzViUyt1bmdsa0U2azRXNEpHbHpq?=
 =?utf-8?B?SmNVbEdwMWxVZzZBQkcwZi9JZFh5a1hHY1JCWG1aN2RxSGVPZkRSbUtuTXBF?=
 =?utf-8?B?Y1BuSitma0ErVUFSMnFSTjBrRGRxUUVNUEpCc3dLWHdCbHpYT0E5L20yYjFp?=
 =?utf-8?B?aFgzdzBSdmZVYWpVTjBQMldVRjdXbWRjbWRJeWNQS1pFcTNUZjZocjQ3Znky?=
 =?utf-8?B?RUJFZkJTWW9ybFZjRHlSZy82WTZFa09OQ25mWVBnQW1xTy9yNDNTb0hUbUYy?=
 =?utf-8?B?dmFaSTlwSStLbjhlMDFoMjNka2laR0VrOU9HbGVsVkZlS3FjQVVUNU1XVUsy?=
 =?utf-8?B?N05TR1RCREpSRHcvN2huMkQ5QnRGZ2dqTmlyZXJNRXQ3UnhUTUpjeHNmY0xx?=
 =?utf-8?B?STV2Vkt4VWpEWHV4djZSTmlBd01zMFM2ZzhSWmphYkhwZUlsdFpHejd1V2dS?=
 =?utf-8?B?aXJQcXBnTXJmaFZMRkxBREVtOUpSdFU1YWNCWEcxSnREOVFvUTdFSjlrQTlU?=
 =?utf-8?B?b1ZSdUd5cnU3NW8vZXVrN0VUSG9wQ21aSVE3YzczRXMvaS9CUFcxMVR3NGlI?=
 =?utf-8?B?NndiTTAzZ20wcFd0eHk3clNjbG9JNjhyWTh1QWg5RGxIQ0RvMERYMWJrZUdw?=
 =?utf-8?B?YnJJTjZqWTFBalZvcU5xYUlhQlY2NmZqQkt3S3AvMlBkYXluUWpoTmZ5YjJQ?=
 =?utf-8?B?N1NIZTV4Yi9PQ3MrRzh5c2Nra25RNSsxSzhZNWEvNHFhMmZ1RUhZVnlIZnpx?=
 =?utf-8?B?bWJOc21vcXdqeS9NVlV0a0phNVF2OVVYK0R2YWErZWZnRkhqYXoxbTU2VlJz?=
 =?utf-8?B?emNGeTNxay9yTWZGNUVhMmVEZUx4R3dQNi9ydnhCUFpBZmRLaUhFSHpkSFNw?=
 =?utf-8?B?NUVNdUZZUDhud3hlQklQMFZyZ1JhaXBGQTJDU3FvK24xcGk5VkNyaDFoSGRS?=
 =?utf-8?B?LzBOaGV0MFJlbnEvczM2QytsaVliTjRGSzB5QTdUWmt0WVBxOC94djh0RFVS?=
 =?utf-8?B?UWZ5VzAwckl4amN3NEhCOUVvUDI2azFyeWZpd1FIbWtKcExyZ2JITnpoY0Vu?=
 =?utf-8?B?eW0wWld1RDJ4Nmc4dElyZjdaY0cra3pGc2lPVURKdHJWN0VsRjlrNUNydkda?=
 =?utf-8?B?SUlmaUFnWGhTdStDMkxUTU1HeXlhb1FmUlZHMFpkOTNYKytBQXdpRElFWmJx?=
 =?utf-8?B?SE5RNE9WNXUrU0t1ZlFlVm5MeTcyZURHUFl3U0R6YjRubklKN1dVeEpROStH?=
 =?utf-8?B?TFM1Wk9kL05uRFloUFoxWUI1K1djZG44VFIxL3VGQm5RTy9VODFTQ0tlckxR?=
 =?utf-8?B?OTl0YU9nM1dCY3ZUOHZiaTlnanNlWlBXOW1xYjNFNHpPVHJrZTdSa3RHMFZl?=
 =?utf-8?B?eVJyOWNZaC9NeXJaZXR0REpieDJrcnZzMU91S0tZVlNucXVyejV2UVNaV2Zo?=
 =?utf-8?B?MWlFeW9KQVpjU1drdHFTV1BTK0tLZWdXVlVWSmcxczZYR3lvcHJlek1DK3ov?=
 =?utf-8?B?RzJTemxQLzBkKzdtdTFIenYxc3hvK3g0SHEvRHMyQkdzQ2tkQ3ptK1BYczFN?=
 =?utf-8?B?eVZ2bmVENmVaQThZcm9MdFdRdkU4MmU4UEc0eEE5cnVrRnZYNktjTWdJcTdz?=
 =?utf-8?B?elVJSFovSmpOWUVCQ1JQNTdvTUpFVU50L29xSkY3M09EdmNqQURQaHplbi9k?=
 =?utf-8?B?cnZPQkhxU2tNZ3N5dW9hUEs1UThIQXZTNlI2SEdUOEhsUVJKYkhPSG9BbjJB?=
 =?utf-8?B?VW9Ea2F2VVV2NFdsYTJWWkZjMnNSOFdhazVEM0YwMUNHaXdockIvTGxVaC9Z?=
 =?utf-8?B?blE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d917636f-fa20-4729-7348-08daf99e0f48
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:50:48.4464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6AF5fpfzELdl8WOhdtU64DUOJ7ThLmlVopDDqntMzWTm9sMOfZXY+doZxhNO6mivlKSKMSoH+QouhKVV5tRH2TNt391N1v/1CWEYW63kyr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5211
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 10:36 AM, Saeed Mahameed wrote:
> From: Maor Dickman <maord@nvidia.com>
> 
> mlx5_add_flow_rules supports creating rules without any matches by passing NULL
> pointer instead of spec, if NULL is passed it will use a static empty spec.
> This make allocation of spec in mlx5_create_indir_fwd_group unnecessary.
> 
> Remove the redundant allocation.
> 

Yep. The code to handle this was added in 5c2aa8ae3a2c ("net/mlx5:
Accept flow rules without match").

Makes sense, saves an allocation and the zero_spec struct used was
already/always on the stack so no change there.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Signed-off-by: Maor Dickman <maord@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/esw/indir_table.c  | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
> index 8a94870c5b43..9959e9fd15a1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
> @@ -212,19 +212,12 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
>  	int err = 0, inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
>  	struct mlx5_flow_destination dest = {};
>  	struct mlx5_flow_act flow_act = {};
> -	struct mlx5_flow_spec *spec;
>  	u32 *in;
>  
>  	in = kvzalloc(inlen, GFP_KERNEL);
>  	if (!in)
>  		return -ENOMEM;
>  
> -	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
> -	if (!spec) {
> -		kvfree(in);
> -		return -ENOMEM;
> -	}
> -
>  	/* Hold one entry */
>  	MLX5_SET(create_flow_group_in, in, start_flow_index, MLX5_ESW_INDIR_TABLE_FWD_IDX);
>  	MLX5_SET(create_flow_group_in, in, end_flow_index, MLX5_ESW_INDIR_TABLE_FWD_IDX);
> @@ -240,14 +233,13 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
>  	dest.vport.num = e->vport;
>  	dest.vport.vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
>  	dest.vport.flags = MLX5_FLOW_DEST_VPORT_VHCA_ID;
> -	e->fwd_rule = mlx5_add_flow_rules(e->ft, spec, &flow_act, &dest, 1);
> +	e->fwd_rule = mlx5_add_flow_rules(e->ft, NULL, &flow_act, &dest, 1);
>  	if (IS_ERR(e->fwd_rule)) {
>  		mlx5_destroy_flow_group(e->fwd_grp);
>  		err = PTR_ERR(e->fwd_rule);
>  	}
>  
>  err_out:
> -	kvfree(spec);
>  	kvfree(in);
>  	return err;
>  }
