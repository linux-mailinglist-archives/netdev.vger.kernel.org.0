Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7D963B615
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234780AbiK1Xm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbiK1Xm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:42:26 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852D625C
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669678945; x=1701214945;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cTw3Em5w9BmDYk1trsUYIslGsWTCfwfT6+jEGoBXqdo=;
  b=QreGb0URyVfHH+8HqbaEQY+pn9VvGxrRguYZ2dTV+DDy6BrZAU7Tzq4n
   P57xULrF26zL5UAwSidwnfkVJe5niAh5aIC0h60VSwUCa8TNDTycDvduQ
   enZJUcHZfCjY5YHoxnH9rc23J6cqta1hcm03LvCQUMY8cP3+UxHcEU8ad
   dpbqmnrbRQC8fblPgin9/FMpOpAlcvWvr8UJywkT4w33tuhK1igK7Hpgb
   AZ+Cwqe7qHWQxOpvSJZawYnZAE7hCoKjOvv2QFnPVB/fxpZJR7i1Sa+ZV
   4z+mAoaHmBfsUjhRFk2cEvJLXW+Cz3dflIvSe9OO9CJnKZKxpqlSELVwN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="377121712"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="377121712"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:42:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="888627137"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="888627137"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 28 Nov 2022 15:42:24 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:42:24 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:42:23 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:42:23 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:42:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LAhq07bfjm2IuCe6HaTG8yxPsynCdxbmrqY2B7oy6rTaiTkLNJtD1Ckgepf6qmWI4mrCu45AG85QJ77kOTX6GsDFGciS1E2eU0MGPv22Eob601sX40YSOAD31PqK9P4oAy1zgbDvzgwxgSGv9rK4/eJgFTF1ar68hYQ+WtgVA8Ocej0n5u+uhCsZCwtC0ZhTLAbIf4LDJzvbYgnNn7u/6rgh7DcQhK6l6Y7cn4tN1Ja8CIb4BdzRDQJLHYyGaUltdcYix9T/qJmZaAGbjkuwKkTnVB2lgRdbKS0qyCwtB9FUG25LQkRQymbZGXZ2OtwCNgM+Z8RxlWuSV2QWAY9j1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZtBLNSOpNzAA+LL2COdDFNiY0NASJ2aBKNjetDMSbzM=;
 b=eW7mCVe4GZpTEGqmeSZtmdH9G+3ga23CRiutVOzfaPtfQS0J9tGL2M+/u6AIp2anZ2LybHOe6oCrTyBXY0LEoIgyK6X11tQrmVVv3/w+7tz2aIgmDg8ipgMlxnqAhL9JCvGBPRLaqBahErYA4/DoDKu9cF++bXFeV6qhi1WO2454MX7OmOdmxv0sHuD2fb5o5o+TgctugFxsCBysiT1Qp4DNZImoCSEkcYI1D3LAuWxTpYvum2nK2jxpoSoedNlZA0UQJM+ylOj40tJ0LbwHG/3pNVXBAl+H3CxgIfTaELLZ/iOZK7YBt0ckDP2elqcsO/KRLmbgR+Gwa1RHRJgK0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB5253.namprd11.prod.outlook.com (2603:10b6:208:310::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Mon, 28 Nov
 2022 23:42:21 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:42:21 +0000
Message-ID: <4bc41493-f837-6536-5f10-7359cf082756@intel.com>
Date:   Mon, 28 Nov 2022 15:42:19 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [net 13/15] net/mlx5e: MACsec, remove replay window size
 limitation in offload path
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
References: <20221124081040.171790-1-saeed@kernel.org>
 <20221124081040.171790-14-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221124081040.171790-14-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0125.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::10) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BL1PR11MB5253:EE_
X-MS-Office365-Filtering-Correlation-Id: b651882f-a524-4933-8767-08dad19a3179
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HjaFjmEyYgNNriaJ6TudwYitnx99HHn9zwFi/FjbHMUByAVNCttg4CoFEOph6FEK3vk33UfPEB8e+y37J8QkJNK1nViY6LZCAPh+eyBoYyktA9hqn6agWRfZedbTP3Sr6BQmlLI5WzakbEl3W69snLqXNzWL5eJqaACZvFXBLOzEyMBuvH55j22DLq8HrX5z02LNgKRf42X1wV+AlqqskIuZXsoknTMfR0gLI4MGAgPpQGsUDvyPfWh4EQbDHMVFb2bNCcj4y4FF04QWU/n6SP19Yq4ykQ4DYvSTHqDDk7iYlSkvUyJWSiS0KH2heqxxYUd9Tqn9HZ6io51ht97h4BgIBwnRKBqkyVvx2T8JmSvnEzP1mcZ5oI2KGSLAFWKfkmq21QI2P/W7buALI1RgR9O6b1xMqBt6r9kNq3Nczvt67pMTT3HHph4fKQnmrRAZHLu7gErlDFOP2Xt7r0fmfbAggsnU3ZXgcD/RuOPH3wcT95sZBxe1tcw2WIN6jBSN3kCmcZkWsYWVqCVR1VSnCRSYZ3zRBmznBClXOz/bmgwZNOkj5BvYxNnCchZNPo5Cbko6NHCxBhzLRHeMCmVxEbLS3Q2Espq5dF8+ooNMPqwD1jMbvmsN2L45O9Dzx9MRYVU5wj7+1vdo37MPxM8UBnoQBDzuwejACPVGgrqO8L2j6rUl9/y0tt72xxL9C3E3IN2WZYxTNlHkEfN8eRWhHLip7TAvhh34a7nFS4RSSVI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(396003)(39860400002)(136003)(366004)(451199015)(83380400001)(31686004)(26005)(86362001)(6506007)(110136005)(54906003)(6486002)(6512007)(31696002)(36756003)(38100700002)(82960400001)(186003)(2616005)(478600001)(5660300002)(8936002)(7416002)(8676002)(53546011)(66476007)(66946007)(66556008)(41300700001)(4326008)(316002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzVFb0J5MDhYSVdDMGRUeUhwektzMGhrVUhxSk5sQy9iVXNiODlyZWY0cTBK?=
 =?utf-8?B?dmt4S3V5SlZ3VVlSUzJUc0g4SWo5NTZ5MG90d0Fmd0FBSzRHQ3FBVUhkbE9D?=
 =?utf-8?B?WExnRU9xOW5pc3R0RDM4Q2NILzRuSmtKTUcwcXBCSWlOaGhLS0lJWS9sSlNw?=
 =?utf-8?B?eDkxNThBdlNnV2FEcC9IcVB0aW91RGs2OFJrWm1OM1FsSzNZbDRxa2VTdkxQ?=
 =?utf-8?B?eWhHemJSaXlrSlo3c25PSXVlbjUySmU5aWdUQTlmS0k0Z2FlWWpVZG5UNXQy?=
 =?utf-8?B?WG85VmN3NHBjMUM1SmJlMFFnMFVHcVdKdEpSaW9weXMybnVnVHlvaWJEcHVu?=
 =?utf-8?B?c2VHUXJLSTNtdmkvTm1jaGFraTBEUTR0K05xMC9LSnEyZDA0T25LRTRYL1dy?=
 =?utf-8?B?SEVtSkl5Wkthc3k4VUVSaXgxOHNxcndsZXgva0xndWJ2ckYweEUxYmMyM2gr?=
 =?utf-8?B?T1dlNk02Zm42cmh5dCtJR0ZmMWlRaElKM1Jic0YvZUR2STloNVNHUHo1SVlT?=
 =?utf-8?B?eG9kR2RnT1FnQnZHSWZ4cnRXblFsMzVZVG0zK0duTEZ2NEZKQTJuczhWMEZR?=
 =?utf-8?B?YktQZERYaWxyMDZOcXpjVm03L253eGgrd3kvNU56ODdLUVhOTGNNeGtrZ3Nz?=
 =?utf-8?B?V3lBd3JxZlJjU1lmZVgyZm1oUGJqSEJ4K3FpUlVPaUxwTjNwTmdVdmtHbGUx?=
 =?utf-8?B?ejNQZG9ocFJXekd1b2JuTHRLRWZoS29ybEc1TXFYYkwwYktmNnQxbk0yOFVk?=
 =?utf-8?B?SUxCNlhhUk5RUFhMeEZsVmVpWlJpRzFWOUpyNERteDNVbDV0cU9yRDc5aTlr?=
 =?utf-8?B?cmFOcXpYdDRMamp1OVZLWVpLd1NMSU03QmRJcU02NFFFb1cyQUxkc3RmamVG?=
 =?utf-8?B?QnkwMWVqS1JkYkJrYUlma283cXJKVW1TRTZpQ2VYYjJwRmF3ZWZOMUpNN05J?=
 =?utf-8?B?ZU1BS21BNXc1UzlIcnJ3dXlPRUc2K2F0eEFqY2RheGpkcmZqd1hreHBZenFV?=
 =?utf-8?B?YUZWTGp5YzVsa2JEOHBQZmxFUnpsemtabUxQSUwrb2tGSHY4QlFyU2grNWda?=
 =?utf-8?B?SmxoUVdhMlh3MEFDak9EbEJVK0VXNVBJMFVJYVVPRFRBK1VVS3Y0UkZ1UVU3?=
 =?utf-8?B?MkhQSEdSRTc3Y1VmUjBTLzRxb1BPUFRjanFwTUk1cXNld3F4M0tkNXloQ2d4?=
 =?utf-8?B?V2pnMEMzZ3V3L0owYVZjaVh3VVducDlXWGZhVTFGKytWMFM3VTNsQ2I3Y1Qv?=
 =?utf-8?B?cmcyajBGQ042cjIzMkF1czllTVZ3TXZKNlZpdUNRdkhjYVk1Z25lOUltcEo3?=
 =?utf-8?B?RDRwakRIcEZLUnBuR2pzNG9GTndyOGlNdUQ1R1gwVTRVaHdJb2tzZTJRdmtr?=
 =?utf-8?B?QTZ0d1BHNEt6b3ZQZUpvTnlXQVFUSzhCRUU5MFNqQW9URVZOVjY0TURya01Q?=
 =?utf-8?B?QVZWSjJNTCtIRFNldFZTMmZMVHFRQUkzWExoMkNabENNVGxVWVRDWlhPbkNr?=
 =?utf-8?B?RXNWeDFGNG1IT1F5WVpvM3lhQmlRdzRodllSUE9qQThiVWpZMm85b2wvaElR?=
 =?utf-8?B?M2tweFpoRGFXTjNnL05vM0VnSHZQUTRjSXBWV3VIZnNMbWhmWGlMNnhualR1?=
 =?utf-8?B?UWNlY1FPYW1VazhPV3V2d3N0ZHFsNzlUS2xFbE03ZjJ6a3BaWUQ3NkE0U0pR?=
 =?utf-8?B?QXZadDN4SnBGakFPbTlhbXB6OVhQckhSdFAvemxWNDhuTjh5cVZsRmxwdkxx?=
 =?utf-8?B?Z2dZMjFHMlB1Z1NyWTFsSEpVY2J1VGFyOFlIazQ1YkRtankxelhIQWdKMzlM?=
 =?utf-8?B?MWRmYmplMzZRQ3J3Y2tLOGpFRVZJcUN4VUhxdkY2aHp1Ynh1clFsRXltZHRl?=
 =?utf-8?B?SlZYTUhZbXhFRy9ZK054c2VxeEtuRzhvcHMvK2tJbVJOb0JMcDVxenFFNVE2?=
 =?utf-8?B?RzlKRzM2cEJyYnFpekw1cTBvak90eHV5ZGh1U1NpSjk2SStZdFNFeWtVM0N2?=
 =?utf-8?B?V3M0OWZNck1lZ1ZNbHROd0VOVk5YOGVpM2VEZHh4TEhWUS9zeDJtNFF3N0xZ?=
 =?utf-8?B?WVVjeitNOFdGY05UaDVtekRoMmxUc3dVV2RVUmlDanI3eVhHTnBLVGdCTlhl?=
 =?utf-8?B?WUlpSnkyNlExYisvQUxFdDRSMnFjckpPbE5yak5MblpBT1pQblVFYlVRcG9H?=
 =?utf-8?B?cEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b651882f-a524-4933-8767-08dad19a3179
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:42:21.2969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HrO/RdUxFsQidO6bNBQdcMjIl56WytG+aKXunBcVol4XDMUzb6mKUqTI0HuVNeW5C74ypMpuXxj5jieLVs8js8tq78JlYn15F21r3IDiqfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5253
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/24/2022 12:10 AM, Saeed Mahameed wrote:
> From: Emeel Hakim <ehakim@nvidia.com>
> 
> Currently offload path limits replay window size to 32/64/128/256 bits,
> such a limitation should not exist since software allows it.
> Remove such limitation.
> 
> Fixes: eb43846b43c3 ("net/mlx5e: Support MACsec offload replay window")
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>   .../mellanox/mlx5/core/en_accel/macsec.c         | 16 ----------------
>   include/linux/mlx5/mlx5_ifc.h                    |  7 -------
>   2 files changed, 23 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> index c19581f1f733..72f8be65fa90 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> @@ -229,22 +229,6 @@ static int macsec_set_replay_protection(struct mlx5_macsec_obj_attrs *attrs, voi
>   	if (!attrs->replay_protect)
>   		return 0;
>   
> -	switch (attrs->replay_window) {
> -	case 256:
> -		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_256BIT;
> -		break;
> -	case 128:
> -		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_128BIT;
> -		break;
> -	case 64:
> -		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_64BIT;
> -		break;
> -	case 32:
> -		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_32BIT;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}

What sets window_sz now? Looking at the current code wouldn't this leave 
window_sz uninitialized and this undefined behavior of MLX5_SET? Either 
you should just forward in attrs->replay_window and remove window_sz 
local or drop the MLX5_SET call for setting window size?

>   	MLX5_SET(macsec_aso, aso_ctx, window_size, window_sz);
>   	MLX5_SET(macsec_aso, aso_ctx, mode, MLX5_MACSEC_ASO_REPLAY_PROTECTION);
> > diff --git a/include/linux/mlx5/mlx5_ifc.h 
b/include/linux/mlx5/mlx5_ifc.h
> index 5a4e914e2a6f..981fc7dfa408 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -11611,13 +11611,6 @@ enum {
>   	MLX5_MACSEC_ASO_REPLAY_PROTECTION = 0x1,
>   };
>   
> -enum {
> -	MLX5_MACSEC_ASO_REPLAY_WIN_32BIT  = 0x0,
> -	MLX5_MACSEC_ASO_REPLAY_WIN_64BIT  = 0x1,
> -	MLX5_MACSEC_ASO_REPLAY_WIN_128BIT = 0x2,
> -	MLX5_MACSEC_ASO_REPLAY_WIN_256BIT = 0x3,
> -};
> -
>   #define MLX5_MACSEC_ASO_INC_SN  0x2
>   #define MLX5_MACSEC_ASO_REG_C_4_5 0x2
>   
