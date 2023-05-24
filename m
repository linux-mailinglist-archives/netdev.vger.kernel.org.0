Return-Path: <netdev+bounces-5142-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE2F370FCAE
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:31:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4D991C20CF9
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34AA91C76F;
	Wed, 24 May 2023 17:31:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2236C19E6E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:31:38 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AA893
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 10:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684949496; x=1716485496;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=trz5eU6t4hsISYsnWej2uy4s11CFt3rUcYfk8j+zbX0=;
  b=dQ+fAftb2SkkZzKoKiJ5gK8hyThD3tIxylu9k1sK07Qp5I0DluNWlQcE
   TGrGKmkM/8UwbTM8zJsXaau7Fabxo3fD4ve1qrnXUUM8np7jtOwHrF4XT
   DY6UtAB2SyPRkUUzr7Ttwpi+FoVk192gjEVzTfQvvopYbu1Xpt+PuNkya
   QkdzJEQ7hLjYgN2azuaheOk3sFrStKiVin9tAL7fUlt2J7w32T0mtIZj3
   q0vXcjE8PaTGBqQUqVfp8T8xbTNrCU0jZ12LNalLOxoE4xUpXR0kCzZ+H
   vI/T0WQGjcLsaRF8f5GH17WwDs9X5Y3vwTXHS8Xi7Uv82BfMJXCK58ouK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="439996124"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="439996124"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 10:31:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="769538832"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="769538832"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 24 May 2023 10:30:59 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 10:30:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 10:30:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 10:30:58 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 10:30:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbB4+BhuRM0MyNBUc/kcuKaCtzfSSZGiLMuXcrRPyaY6tFGmwI52AM0U5tj92kTRF+E4+6Y9SUHHKssgddlHcUaN9dqeYfImz74u0gvZe9gc8Ijr3QwW42rbuF0+Wm6kxcF3EHHXcNz8CRhOFx6md288R0J31Bh8OytLqEl0MxZZgwCfPLANldCOlKu0LYxTrNmqy8Okho+v1WjDW4dPopRmZ/hZQHjQF73y5cT7iX749ubCIZ+klhUuXeAoTdGg11KpmlgW8y37ltAB8Otdu9+meIurVkoGd5Rsc8YB3RC/96n9eDINJQCa/E8PVAI8f5l7fYc7ELblnmJ4f9GipA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BTwqGpeGL68zh6pSktjCNoHtvybXCazjFFEEc4g7ggE=;
 b=U8S7eZgeuhg1veHFyeaNThVxilCwbczhMyrnEDvRcTj2rPNHbRvYIgYiGTxEdHopNhNr9y5zECQxNBdhAy8WUigp+wrH9a6CJJs0iAhtYHMZkAbDVwW4LM0nVsUqLsAhKRXOvYoOhzXLvxdGpvnCdav/to6Jdu7KSoQinj+2a9u3VqCjnvK8UMBOpv+PX+ClXztBJxXq2ytvvKJTLvobx2H1mknmxyY1PU++rzHZjBsCIv5METwg+Utk6ZjIILGhKOIxYDGj1Y9yM/iWz0Jc8/SNhWJCCkzdJdrXtx1wwUNbEWNp2LBK+221OOv1qxWX47Wu7939bel7cjdYeo+pLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by BL1PR11MB5368.namprd11.prod.outlook.com (2603:10b6:208:311::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Wed, 24 May
 2023 17:30:54 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::57f1:e14c:754d:bb00]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::57f1:e14c:754d:bb00%5]) with mapi id 15.20.6433.015; Wed, 24 May 2023
 17:30:54 +0000
Message-ID: <66cb6b22-0239-6784-851c-02652487a62d@intel.com>
Date: Wed, 24 May 2023 10:30:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [patch net-next 02/15] ice: register devlink port for PF with ops
Content-Language: en-US
To: Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC: <kuba@kernel.org>, <pabeni@redhat.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <leon@kernel.org>, <saeedm@nvidia.com>,
	<moshe@nvidia.com>, <anthony.l.nguyen@intel.com>, <tariqt@nvidia.com>,
	<idosch@nvidia.com>, <petrm@nvidia.com>, <simon.horman@corigine.com>,
	<ecree.xilinx@gmail.com>, <habetsm.xilinx@gmail.com>,
	<michal.wilczynski@intel.com>, <jacob.e.keller@intel.com>
References: <20230524121836.2070879-1-jiri@resnulli.us>
 <20230524121836.2070879-3-jiri@resnulli.us>
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230524121836.2070879-3-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0097.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::38) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|BL1PR11MB5368:EE_
X-MS-Office365-Filtering-Correlation-Id: 320a61a0-c7f9-464f-a59c-08db5c7ca06f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LwzjjHFY6hAPVgFKNa5KyI0mjCm9/zFwxdFTTQWzXRFYcG9C9RmcIaoZHpAs+3A4SrjHuTLyVfdtuqMzSXAX/kkg92xO5g533ek36xnaWdfrSxF/nQ0SccENUO+M7znU7SwUFtgNKepePve5Il3Cd987L0ViHngeoVciY02BtTdQ8MWBzOaTsv/m6WtBPxohQu9a/PXkRpX9kdqFrBXcPSXAl41VU7WKmMkvEImUOa1ecX17f31k1jGg87YJu0IxxBkZ/whciOscjjP+2GSdb+j+93TcRNm89xZvB3IK/pyHyJfBGiAk56FxdR9A5vHeb+44YFvFTBPSWiBhJCSE1RqJEUu6FqkUeavGkABhcJWoT9yv72NH/AR43NSmGVmdAWQc7ymb9vX+TaVYP7zSlvksyCsWQez7NdHoIQCo6wWrFjencSav/pmlq8HIU/7re+2J4wrSVMtt925OGEEsOkdFotTZsuJUJeQI2ZEVLsP9n9bRsHM6b1vgp6ZpNAYco21TgZ2xuwEA5W9nBQptZCjfzrZU+krW2gK5bni1pC8JJQhkaCXOePo/RcJNkIERhEB58JlzDuHF9NE7Dr+lGneuUVU8aneYh62DJTmDEVIuXZ8qd8t1hk5i0NaLIt/rClakhFvgYRnsCk23I/3fQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199021)(6666004)(66946007)(66556008)(4326008)(82960400001)(38100700002)(66476007)(478600001)(316002)(41300700001)(31686004)(6486002)(86362001)(31696002)(5660300002)(8936002)(8676002)(44832011)(7416002)(107886003)(26005)(6512007)(6506007)(53546011)(2906002)(186003)(36756003)(83380400001)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0gyUU9aSVFwR25xcENUYWhxS3JKZnhua2hNUTBBbHZGbEtJMkpRSGZiZW9Z?=
 =?utf-8?B?OWg5eTJqRDFDYmlSMDBkSE5mUmdZOU1hdGpjNnVISWswU3BjdUFsV3YrdWZW?=
 =?utf-8?B?dHo2Zk1qSTFEUnVvam5ReE1IYldMcXdab291Q0x6L3c2MVFKUy93TDlGVEtM?=
 =?utf-8?B?NnV3dWdtT1lYVmFsKzVQVnlGd3UrYWpjTUwxMnRhNk9MVkhmVmpMRXI5MXJ2?=
 =?utf-8?B?dG1HelJOdTRHUTc5MExoczVKaElvRnZJSzZCYXdmeXlQL1h0eTFMaHREUTl2?=
 =?utf-8?B?WCtvRktydzNaRDVaN2I0bitTRzErenJuWWNsekswYkxSVDNjUDFWNzFwdTVP?=
 =?utf-8?B?MUVNWUlpekowR0pEMkVJQlpBNDRIemdtN2RGd0d6U0tkU2pLbkZDUUxJcUFa?=
 =?utf-8?B?K1oyMDM2OUIvKzREUURoa2RjY1RqUG92VHZ0cDgvMlQzL2pOOGtDcDJBYnBG?=
 =?utf-8?B?TjZwYUJlNks1YmVqN3RPSXc0TzJJOTdRdnRaMkR6Q055WHEvVWFZRWlkMEVZ?=
 =?utf-8?B?TmxtSmNQY3YxRzBPV0pveUpuQ0hjYVhSZUNpWGYrSHZmdTNrM1NLeGF0V05m?=
 =?utf-8?B?MW1UUXQ5bXg2bXlNRWhyZ1VFc01BQ1BjVXJYUnI4aE1PNkFlZm1zbXZJRS9y?=
 =?utf-8?B?UTNMT0ZKUGJ1OUlKKzUrWEg0ZzkyR1V2dlhPUWRMNW1FMHpLOU9RdzluOUpv?=
 =?utf-8?B?SjUrLzNxdjV0OGY3MUhDWjdjVmgwZWJaeXFvSHJ0WERNMXJSVGQwdmlTUWtj?=
 =?utf-8?B?YzBVeHBzendOOEpTYVlWWFB1STF0T29jRm1qREdaZ251aWYyMWlhRjZ1cjd4?=
 =?utf-8?B?dTh5WjhCNUZsTWxPTExmZ1NTVlRJakl0bzUvcEFGVVNRT2Q5eWswYVhzcFdr?=
 =?utf-8?B?WWZHLzlLczlrSythQ2tQMDlTeVpBL2hQZFd6dytnQTF1WXVlUHlEcEpiSWJS?=
 =?utf-8?B?bzEveVZML1JOSytsSU9zb2FEVlJibm44dW90L0d2UVVSdTJGRDk2REdTcWVI?=
 =?utf-8?B?ak9lM1ZyL29OY1hKWGJYWEttM2Z6SUg3cm1zUktqWHVsaTZQZytuYkQ2YVV5?=
 =?utf-8?B?M0ZMMlJpRmVFNGZTSm9CODFLN3kvT3RLeHBtNXI0Tmp4UXoxWU9DRytqWmR6?=
 =?utf-8?B?cHlIMnlObE9oaXRhdUJ6c04zOVkwUFFzQ2NPYVgrUnRBbkZsQmVtTXptTGpm?=
 =?utf-8?B?NlZMUk9PbWdwbkhCUWd6eUI1d28wZ0Q3K294d2FoMHp4UEFsSC9wb0thRDQ0?=
 =?utf-8?B?SzZ3b1NFWW1ZTUZ6MElCSUthY2ZsTXAzakxCdm5iR1BjSGtBY0t0WEROSWxH?=
 =?utf-8?B?dnc4ZFBIOWpBSHFENmxob3lLakZHUFdjaVRqUTQycXl1NHpyZUxROTBWRW9S?=
 =?utf-8?B?VXFmY04zUUxFYlNONGRxQ0gvc3dPVnBJLytWcEg1d0NoTm9lbnQ0UG9md3Mx?=
 =?utf-8?B?bXJnaWJsU3JUTWFFc3ZPNUNCZTE2dCt0RE5EUUVjbU41aWFkVDc4STFJa25q?=
 =?utf-8?B?Rlp1eEkrTXFZUjNmL3FVRm9QblZBYlVUZkl5NjFTRlJ0cmloMzBDZmhCSDFn?=
 =?utf-8?B?blpWMnJkYnpONnlPSVpKSXFDNXh4UHpZaFlLWEJtWGZydW5LZlA2TGEvRmxa?=
 =?utf-8?B?ZEpLUTRMYWZVSnVkQjdySEhyRXRDYXhOeENUS00wOGZCZEZmVEY3OGcrL0I0?=
 =?utf-8?B?YSs1RDZhRHpLbk9HNld2VERvVWdZVWZObUdZTDN3T3JGNVovNVQ5bnlCTUVp?=
 =?utf-8?B?WjVlZEUzNU1MK1cwM2doTU1nQzE2eW15UkVRVjl6aXdHdllqZXZQM2hUaDZG?=
 =?utf-8?B?T3JZY2tycXNhSEVjVlNyMTZ2OVdtU0lYelpNb0dFRFVTR1QrRUxaYXRxb2J2?=
 =?utf-8?B?V2Z0dDVsSk81SGNYU0RQSWF2TktCM3NnNnVsZXNEcmZVNVpEc3JTTjdTNGcx?=
 =?utf-8?B?TDVpdG54SS96eUYwUHVkRlNodWoydHVPM2N4cE9OMW5MYmJoYlJ5WmxMekZH?=
 =?utf-8?B?V0tFZVN6Y2prcEZMSTBOYkFBbWMzZHhuNGMyWS9rZXl3bHc0eUdSMWdIcWQv?=
 =?utf-8?B?cjFGa2c3d3pWWlVjaXY3MjRuQ3M0dGlUTk5Xam5BY2FFLzlQU1drNmVRbjVi?=
 =?utf-8?B?T2hRbm9iWG5lSzJ1Rk9ZTTVKMWVIdjdPczVQUU5zYjRRekpjc1VmTE1SQWF6?=
 =?utf-8?B?WVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 320a61a0-c7f9-464f-a59c-08db5c7ca06f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 17:30:54.2063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xv8rZpyQw6qkcVONqQfPsEtt8vDp+hPhGyxJTJjBTfc4IhVg5KklgeibEmwA2UOiKBVVEVprpBFpqz+JilPz56S/ltWZdrmsk0M3KYa4jP0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5368
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/24/2023 5:18 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Use newly introduce devlink port registration function variant and
> register devlink port passing ops.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
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

Looks good to me.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


