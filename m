Return-Path: <netdev+bounces-5651-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00A9F712512
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:52:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFD641C20FF2
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06E1742E0;
	Fri, 26 May 2023 10:52:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB388742DB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:52:40 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574E5F7
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685098359; x=1716634359;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dg7GXmabh2otA6cwkYp9rNidxxRJl8L/NoM5AmFJe8M=;
  b=MhCzh7XzfritIkCfyH1wnA4V0+JCGGAGhdlckPNHytoIpsYkcek6/vj+
   AoolOoTlll1vqaldSbnp9I8rsh3EjFlnRUPOP4O1rkb4UcCv2AjTW1BFT
   FazQsMlA3yKWi4ujH7ExrL13xXsQBMjtVs2ejnbdFRy0nCzyVpLCvG95Q
   vrJW3AOAqM1gJWcnOWEInpMpA9pEST1ObV1t0fN9fhbrIWmTegYG0sxaL
   9O4XUqnS76TszWJNqvPMxd02TpR0+OlkBmS90ZzQhN0FgBrwsCoWyU2y9
   rB5sxgqR78jnR32LyCTyEHvV1p4/h2SrqIvazGtPTF+xffRofwyluVBB8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="334527077"
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="334527077"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 03:52:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="775058112"
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="775058112"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 26 May 2023 03:52:38 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 26 May 2023 03:52:37 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 26 May 2023 03:52:37 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 26 May 2023 03:52:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFybjRZ+cVmQU6D/a0HlBHAlZL08RFxijPo0Yd+j1/Nc8MT73hEBgdTY+RO8QVa98yT91SYBzxJEEu4tGJ4LA5HuKocFzv3C0qOiWDIdwjxlxj06cQydf3/iHW7eLJUCwDuSZQKyV+vnKlS9vtEECK6r4KH/2FYTWwda/SToTuMoJQG0ZU840Wq5LkX+9+6B1xdiSTF1OyvQb697xIMGgoXlYMSW2E3Z6PyjWJToIF8PxJY5k44+YORoI3SlxC5hTCqW1ogFo88nwnCf+yEEfUQh21oQVPDv0enkb2g5eaSciWaLQH5PoW/GEMDVl9ZsB97kLwCrFHCFVtAfNVfakw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ADuVQvi+VBqF5VaCgjpBI2Via0u6cdT4/TY5Y9VnOh0=;
 b=fI+BJmEfOSWh93J1B/ikYtpToaX0nTlKp5aDrVubggovDTcn7ttBJ8JCFgZVFJz4AJ8JfucYghEKMxV+XdqiyYLSzr2ynUZ/5RcSDKwWlsH74YvV0TR7s+JdkXPsnI8qIxgliSrEyvLvDhtmoCtgPW4TU8z8s4JMXnsBYHP4LBvXdk3qRVEZowWFDnQ3QXxULo6dhtjWU/xEYY3bMlnAM0mDCrtHoUCZX7G0X5sc/wQ3GQdjoUV5M4YmKCNmFhYLV8mKc3gcT8w3RAtJ8AMrWV+xfDPYQ5SNvA9yIGCz7IsHniYKyM1xHuMKnNFBKoGngBvJNfu24vqrxG+Ax5XO9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by IA0PR11MB7354.namprd11.prod.outlook.com (2603:10b6:208:434::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Fri, 26 May
 2023 10:52:30 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::4287:6d31:8c78:de92]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::4287:6d31:8c78:de92%6]) with mapi id 15.20.6433.015; Fri, 26 May 2023
 10:52:30 +0000
Message-ID: <4b8dcf1e-72df-48dc-b249-81d07323a632@intel.com>
Date: Fri, 26 May 2023 12:52:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [patch net-next v2 02/15] ice: register devlink port for PF with
 ops
Content-Language: en-US
To: Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC: <kuba@kernel.org>, <pabeni@redhat.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <leon@kernel.org>, <saeedm@nvidia.com>,
	<moshe@nvidia.com>, <jesse.brandeburg@intel.com>,
	<anthony.l.nguyen@intel.com>, <tariqt@nvidia.com>, <idosch@nvidia.com>,
	<petrm@nvidia.com>, <simon.horman@corigine.com>, <ecree.xilinx@gmail.com>,
	<habetsm.xilinx@gmail.com>, <jacob.e.keller@intel.com>
References: <20230526102841.2226553-1-jiri@resnulli.us>
 <20230526102841.2226553-3-jiri@resnulli.us>
From: "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20230526102841.2226553-3-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0077.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::16) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|IA0PR11MB7354:EE_
X-MS-Office365-Filtering-Correlation-Id: acb0d12a-0842-4be5-a590-08db5dd74d11
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OkeYwpIo6M1MjElgAxYVh/sR/oTh/WQi+5c1gghrN8iSf4WDefHON2xrYw57b16MNXzwdAIvjVtESrb7Q8kenl9Kk2tgkLvELdi9Bw76FBVOpMSkUCaTehHGDL+AV9/JhJHVakZjfyHf7JqG3+alyb9BFUQHbSMVzHi9yz4W+EHl5uZejS+2FrMBMRizktSu9WjDLt7LIVAdiNBUMS7CJwmLrU+02+DAlAn3joflWZDF19HMDqvZaEjxWpwUQznEaa4e3KIk/y+xNdejjeFB3v5p43IHf6RFe79Xw/3l79aGeyW9bP5G8gn+0enj6KvgF3lDTSM6Dy944UDNPCe/rb9Xz/zE4DbmVlwoIERhKzF63Ud5bHGG/uqwpzz+JVvbrELR4QDDiB7FLR3c7F2RQSOi+Xre19uRtJ3DeFna2q5YlVxDZiQbmbQbQVMXMwjnuKi2qoZADeNFup5GeWzbC/SQQBTz2/BygF9sDjxJZOxd2jqLyVSrVIKJNfVG1QDGqx5pN+ziljicG67RwwuWS30GJVAsymoENXrnCFbA+4f7aW/TSsCY9CRnKHwpbQE7ZzeN1NGWTxEPUmPS+yc7Cg7AB8OUMJ93AONYranjIlU/UNMXUHR8KkEGtuzAHs3zNKZiT1jdhwdSDRFTx/aSpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(366004)(136003)(376002)(451199021)(186003)(26005)(6506007)(53546011)(7416002)(82960400001)(107886003)(6512007)(38100700002)(36756003)(2616005)(2906002)(8936002)(83380400001)(316002)(6666004)(66476007)(66946007)(4326008)(66556008)(6486002)(31686004)(31696002)(41300700001)(86362001)(478600001)(8676002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3IwZnF2T3Y1dXBmZGh0TTF4S1g1dWpIT2s4b2JCZW5IMXV2cExidGplSTlj?=
 =?utf-8?B?M1l3SlBOcXlTbHF4NFR6Y0dleUV4bmlRRzBqdmlWbEE0RFVEM1Rmbzd6eE5l?=
 =?utf-8?B?L2R3Y2NIZXc0WVNNRENHNnVpY3FsYndBa1RXMUtaYVlJRytMbDJNZnZTN0xM?=
 =?utf-8?B?ZU5CS0lxSHE1QjhsUXFPTDMvRFR3S05MSG40Z29TM3ZZQTZqV2Y4SEJldFJi?=
 =?utf-8?B?RGpFZXFPNFk2NnFXaUQzQUE5NVJjN2tTeEE5NWhMUDZWL1hUazllcWdpOWhK?=
 =?utf-8?B?OXM2MUFtUzFFTURGM1lNVGFaMUZ2bndvMGhnUU9vY2p1K29zNWExK08xMzQy?=
 =?utf-8?B?WTExZE5nc1lLQ1hKbkRLTVZuREpDNHVvTEZub2V2Q1FYY3VxY3JYV2tMb3BV?=
 =?utf-8?B?N21CMlRzdmtwZHphVGsxci9xS016TGNIZVRNemw0NnBhOGVOZ05FYWdJUU1Y?=
 =?utf-8?B?eVVLMHJhOE1PTmdJdzJiSERVKzdHYjVxY1piM2ZlR2pLa0R6eXVJLzlDU2lF?=
 =?utf-8?B?QmlUZzBpd3p0Z3ZhM0ZMTkxOTVl0ZXRpQUFVM1hMejkxZzVSMTYwK0w5aXVR?=
 =?utf-8?B?N1ltSjRKTzJqMnFpdVZLNlVFbXROR24waXZIK2xJczNWNEFtMU1KcThnWnN1?=
 =?utf-8?B?dmFwTSt6bVowaGx5TTVpMENmYXE5SmM3MllKOVEwcHFPNzdxNklNOEhnajlO?=
 =?utf-8?B?c1A0T0dpQ0tsTWJrb1h5dzh5OGRBVmhGOFBMY1g4ckdiWHJob3RTc255ZkN1?=
 =?utf-8?B?UkMyTVJJcWw4Ly9VOStkMnB2M1plQlRVNVVmRnJ1eWE3TENmS3IveUNvV3k4?=
 =?utf-8?B?Q2RrbVYvbjdpME1BR3hVWkFrZ2ZFY1lNVnRreTdsQXNzc3Y5VkJIQWxRcTRG?=
 =?utf-8?B?UFNYVWdWL0wwUSswb2d3TnRUWXlTV3VzT3dxR1VnMDVuNGxLdW9zTElDKzNY?=
 =?utf-8?B?TG5sbkUzSGU4Zy9wanF3OGgxNk10QXhsajhjWXlaTEszVGg4dUhaODdGZUhm?=
 =?utf-8?B?R0grQ2dDVXJ3czNLUFZ3RU5EM3ZMdjE0b0F6MWs2VHdZOStGdjlacCtEVEpj?=
 =?utf-8?B?V0tDRzBxZ21nMzg3SHVNb3QwVU9zcUJOSjNWaHQvTnBBakdWVm0ydUhSOHNz?=
 =?utf-8?B?c1JFZm82WDgwSy9ZSmZ3U1V5ZWV6dzBibVQrbEd0NjU2YW95VEFNSFk2ZHg1?=
 =?utf-8?B?cndYKzZsK3FPZ09PVm5mRUV6R0JPWVR1MDZ0dUNLOG9BSDlRT1N5dVNkandX?=
 =?utf-8?B?Nm1pbjJ3RGgxTkt2V2lwVEhIcnpPeVpkRGpLWmFBQTY1M0c2R2F5aklMQjhy?=
 =?utf-8?B?dVlYM01hbnNQNHdQSzMxS0pGTVJad1REUG1tV0JJelhVMWR4dmpFQmwremdK?=
 =?utf-8?B?Mmp0dEFMRVg4MDBlbklNMVRtdVVFTVh4YnUvQTJLbzdWRTliOWE5RXFBVjNv?=
 =?utf-8?B?Q3JxRzhzc1VPS2k5N21nNEh5MldycXlydWRCelZLd2c1UytDUm1JS0x2Y3Nv?=
 =?utf-8?B?RmN6VHV4YSs0eGZrc0JQNmxETzVyQkIrK2RNRFFCck93VTNrSlhvZUZnajYw?=
 =?utf-8?B?NE1taHlGN1h6b3RwUHFLYXpBNTUwOWJjc3JaMmhqR2d4d3Jld3VxMUVPbkI4?=
 =?utf-8?B?M2VvOW52dHEwNU5mZGExY0g1MlpuNnMxdW1BOHRHbzIrQjQxMHp0Z2dGN1p2?=
 =?utf-8?B?cldSSTcxQ0EwUURkMmFKWlRSSXJJNlRaRzRlN1ZTZnF2YTJ5Zk8rRzJsM2tS?=
 =?utf-8?B?enRzZEtMQkJMNVJtMFNsWlZ2VUk3WDAwUFBweXd4LzYxVFJoMng4OHRCS29q?=
 =?utf-8?B?Q0ljMlEzRG1SOFdJM3FWTzNxUVd3ekJRaUhFU3UyQkRmaHR3eUpVdC9lUGRu?=
 =?utf-8?B?cjBjN2Ztci82Um5PU1YxOUJuNnNIWUtjUWtOR3RrTCtkVnlncjRhbzU2d09x?=
 =?utf-8?B?ZmM5dHhja09qdHNzeWRHa0tyd1R1Y0xqbW4rbzY4TyttM3Y4ZzBDOWJZOHhK?=
 =?utf-8?B?OWh4ZVp0NE56ZTRkRmkzZ1NlOGhhTDR6SXhOVnlnR01WZ0Z0N1EyckdocUgz?=
 =?utf-8?B?NlRsanErelNUbUw3L1JobzlzVTNlQnZoNkFKUEpkS09jc1dpOWU4YjhhT3NN?=
 =?utf-8?B?a3dSM2xTUk1BRUxmRld0bDA3ZTk3WUhVYmhhSndkWUJMRjRCcXQwWENDcmth?=
 =?utf-8?B?Ync9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: acb0d12a-0842-4be5-a590-08db5dd74d11
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 10:52:30.0228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +iO/H1X3JW6P9A/5yuLKUSZMCpcp+x32lSLvyx/D9gq68sm+a5z+mLOPTPQBzEvBm1UtqImZtm1likApFytEZ88HKhAsp/GxBqePVspVX74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7354
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/26/2023 12:28 PM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
>
> Use newly introduce devlink port registration function variant and
> register devlink port passing ops.
>
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_devlink.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
> index bc44cc220818..6661d12772a3 100644
> --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
> +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> @@ -1512,6 +1512,9 @@ ice_devlink_set_port_split_options(struct ice_pf *pf,
>  	ice_active_port_option = active_idx;
>  }
>  
> +static const struct devlink_port_ops ice_devlink_port_ops = {
> +};

I can see that you're doing this everywhere, but aren't those braces redundant ?
This struct would be initialized to zero anyway.

> +
>  /**
>   * ice_devlink_create_pf_port - Create a devlink port for this PF
>   * @pf: the PF to create a devlink port for
> @@ -1551,7 +1554,8 @@ int ice_devlink_create_pf_port(struct ice_pf *pf)
>  	devlink_port_attrs_set(devlink_port, &attrs);
>  	devlink = priv_to_devlink(pf);
>  
> -	err = devlink_port_register(devlink, devlink_port, vsi->idx);
> +	err = devlink_port_register_with_ops(devlink, devlink_port, vsi->idx,
> +					     &ice_devlink_port_ops);
>  	if (err) {
>  		dev_err(dev, "Failed to create devlink port for PF %d, error %d\n",
>  			pf->hw.pf_id, err);

Looks good to me,

Reviewed-by: Michal Wilczynski <michal.wilczynski@intel.com>



