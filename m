Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E87651175
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 19:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbiLSSBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 13:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbiLSSBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 13:01:42 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5659611A1F
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 10:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671472901; x=1703008901;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AXOgjnCad1RCmc6zUumScoEGqcMYtU9U/vBDUtrrxGg=;
  b=jsPJBsIov2jn+HmJxJPBO529Kj3/PhJuRFy5aRLFTY4NMVWy8/MRrDhA
   S1ZR9dn4fCI3LEjnAvUvba2kZQe5LfD1YtqomtxVjuenpv1gtJ2NLgK2T
   gylCQtsNO8oo/fbm/KjCAHm3Qe9Qj1SWrPRzjHl6bgf8OfiB7HOQy2kRH
   40MSczkZ4CEq1XCkySSD37ALTxYm0bVupOBkZfyrpNrBQcXBoCjlL4zvc
   Jpx1xA52Ag9ZEa2yL72fPb3lA7aouQKZR8jdWTsimM+AK5Mu2nmwfTfKB
   XSfI3iasFq5i3MbrsaWY0g/YCkC9SmhfxH7PPNr8PbuvmwGWJ6wq+nTlX
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="299751305"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="299751305"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 10:01:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="650614104"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="650614104"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 19 Dec 2022 10:01:14 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 10:01:14 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 10:01:14 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 10:01:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2nVTdzyeJ73QkyBOzGFPQQGgZIoEFrM6bnIjshjQGuIGwF9xBLuS/rYc/yjNLKp30KTFAR2wBCctddWf2XOHHOC7WGvlSoLeb5IjA4N5wCdsd37qxQHRvzQSlnL+qDrMXYK5R0fR3huH0LjEdXlDx7mZg1uI9y/mPPIEZveEuVuy9fM7WGiOKm2FzeZjkadr+kj04BQxJ0IvovJ7ZSzn/2NMUbOSj72BpEsTg/Ycbm1r20c7CyBS88Ro/0BCUGCALugMKXnCQ+2ht9t+gAN0Z81UAativqhPIZu4Tlo3MWCOVztocxcRgyw2Urac3bpzM2oXfyNJ4wLThA29f0FJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1DeRLQJEoNgp1WLiPdghkt6WtjsVIhPrLaIJDTIUOVo=;
 b=HZlcWnH8av1BJs5TDsaFgz+YqH6UyrPozlUX4PoZAbw2WdMGHfC7F2Jf20HdV1L1dFiNkfYndfgTfsXNlGr2WEwp6DYUt8VeTimduhkPi/i8D/ghNtGZd8EZmm/M1ljAdOnujqtfzQO/QrCu9fC3PlsEOPtcrsPZ/nIOrHiKYNXK4n3ElP4Q4zV6LiVHqejxrFq+jV7BjHRG3JkS3VjGjoN5+UMUt9/bF1RS+nuf49oJ9O4G8EXS8K7PmiLB4qlw5dw1LlUCKpdB7i14hPPCMP3xk6Cv4AF0MF+jVg5ALRHaexxtoETHMZ42yPUcfdPPp6wrVIbWOXBQdlRg45uqQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA2PR11MB5162.namprd11.prod.outlook.com (2603:10b6:806:114::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 18:01:11 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d%7]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 18:01:11 +0000
Message-ID: <3cc678f5-573f-2b4e-a4da-83266fe419e9@intel.com>
Date:   Mon, 19 Dec 2022 10:01:09 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 07/10] netdevsim: rename a label
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <jiri@resnulli.us>,
        <leon@kernel.org>
CC:     <netdev@vger.kernel.org>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-8-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221217011953.152487-8-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:217::34) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA2PR11MB5162:EE_
X-MS-Office365-Filtering-Correlation-Id: 8db638ae-e7cb-4b5f-60a5-08dae1eb034d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fAzIlz/SeJbhuH5SvVx2FThcQH7XPuhCP+VXrnidke6GwVqDHd3haSpmqkqZNIQCXKrZkzmwsm6wQOh90tX3faSt81bQN4+3htfMsco1SSBfCezzmVizM9ob9XfG0M37RAtrxlrTAkMDmN0WD+BgLZe/pwGClsMO9OWyO28hqTXOKYQ3QGI7zC1P4EhNOIADF8bWJcJGETewQ3wCJFZwDsvC7usYl+cfW62UuXZ3kSTmEzAy0KzfqCJq6bhYKGs4F39zyy1SZFHXvKDMmqoPUvCYz2TPWCjkkOstKRUW97VlVj+jF/65K0WdOnww9yA+gztnsISxdkHK8MDoYOQMmZ6pg7rx0G820E5HUlpSSM9e3xFjDlQijnCNyK5JfvAH+LYn8v+fym107wzOnfr8L1gHBONlKKowhi7ccZbdKqzUEX5lKt3lv/cuQXofEGBtLCpOEkqILchq7FaQ5KwdC419fwrjBrEdh2E6whw6GvXB2fwr5eUIU1EIgYSKN8RyeSpPyTivq+QrsInF9bnFeJ7CIklPO/QY7dGnYKoGWQ/2ltwjIRaASmnQg14EM6iRbDvTL2rPymsx08QbJwk4zcvZxBvuMHJmJK0bGPCvdetu38fytzZao43a9b8Nzen9/lySDTaT9SvXc0rMu2ex6o9KnxMXlugToMD1hoOJGYelvsKGCweo3Zkq2aMJJJmhj3RK7psbLF4De0oto4sbJlrWMoiCXvztQeQC5KsNlqs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199015)(31696002)(31686004)(186003)(478600001)(53546011)(6506007)(6486002)(82960400001)(38100700002)(6512007)(26005)(41300700001)(4326008)(316002)(2906002)(66476007)(2616005)(8676002)(66946007)(66556008)(5660300002)(83380400001)(8936002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3J3TE9peGJqM2daMU4rUXd6UHZsL0RHZVQyZTRiWkxZdnJja2s5YnljaTNQ?=
 =?utf-8?B?SUEwTVNFZTdHM1g3UklxRGhQTk5jQmtGK3AwRUJmRE1OcXcxcVhhcXBNTkk2?=
 =?utf-8?B?aEh0d0tEOWRBZzk5TVlSbDFLTitVdkErcUdqN01GbFI0eXB1ZmVadjVUTWpI?=
 =?utf-8?B?RUNMOXIyRmp4NUNUaHQrNC9BN05zM1kyQXRBTjlaNnVwVW5hNWpFQUd5WjFt?=
 =?utf-8?B?bXVnQzNjV0E1QkJKckhpQXZmRmZLaDdlM0RMSHh6T3BqWHZVMkUxU2ZaWWdY?=
 =?utf-8?B?SlltMWJsWkhRSjJDK0VGdlNBQ3lUYndGSFJtT2NuTUgzWENON1JPdXFZMjRu?=
 =?utf-8?B?d3VtcE1lL2RjUGJrYStzKzdnb1B0OUNTb1NOWmp3eHBmTW1aTzFTMDE5RmVp?=
 =?utf-8?B?UjlqTnNwOFRlNm9FT01RbmVuMWRoVWhoRUZOaG1KSlJDZG5MY2VXVmV0ZXJJ?=
 =?utf-8?B?SklvQ3pvRjh3UXhBTXF0bEhsYTZhVStPdE9kR0lnSzNwUlRyYTgzQUFHY3JW?=
 =?utf-8?B?WGpic3RMWjlJaDdvd0ZGRk90TUNHTDFKbXFKZ0EvMkJ1dmlpSHk3UXZ4NXpR?=
 =?utf-8?B?dXVxREJaaXlLSm4zNldsbWY5ek9VUU5rMEovMW9jT09vT3F3cG9lZFErQjFP?=
 =?utf-8?B?RGxGNDFhd1dRaFFWcmNpdjJpc29aVHk1SDhWQTJneDFXcEQraFIrTGF4ZVBz?=
 =?utf-8?B?NEM0MTFwbUxzMlNsRGpXNWx1NGw3UDlVQWlCTWZDZmJGb202MTJQVE5hOHNs?=
 =?utf-8?B?dENPVWNVZDlhQTRXUmZFWEcrWkNleUEzVk5hUDc2R0hyemJ1U0ZhSjZTZGRm?=
 =?utf-8?B?bG1sSUoyV2VLdDVMMVZYbStRZVp0clh0Z1FIRTcxMlNDSTd4UkxLUGVJWmht?=
 =?utf-8?B?RlFaKzJ3bk1QR21BVDNOcDRTRFhVRkY3b1NuMWtjY1htMjNtdVRjaHY1UVJp?=
 =?utf-8?B?QTRwRFF3V290Q0FTMDlGdDg0Wm1pRjY2c1JKem5kNTREdm1YNXN4TVBmM1hi?=
 =?utf-8?B?alBDVU1sZ0lDSmo0M0tXVUozbm04Uks0TzBnVDh1eEpqMDA2NFE3ZHR2MHlV?=
 =?utf-8?B?enFQZmw3cXpjMHlQK2FoNmt5cmVXeHF4Q0xuVHFPVTBtbFoyeWdDdFc0eXlj?=
 =?utf-8?B?YXh3bkErMjNsK0xsR0piVTZ5UWdOa2d5V1pWVzBTZnRwZUFEZWMxbGlvcmhW?=
 =?utf-8?B?Q1BiUkd6V09JWEk0ejRod053ck9zL1FjcjNWV3FZNG4yT1UzZkoyckNyODJk?=
 =?utf-8?B?S1VCUGcxNi9tVHJFUU5SRExwVWhJZ3A2M2dSVzZaaVhPQzZGZ0tJdldVK2JH?=
 =?utf-8?B?clJVNzRLeFEwNGJ0K3QzRks2Zks0NllQZ01JYTgra0N1NDFjaTRGRXFwaTAw?=
 =?utf-8?B?cGFrb3lOc2crMGR1SDNqa0ZtMDdyc0lKYklyRTh1NFpsU3UyakhxbXVXSWJM?=
 =?utf-8?B?QXlwS2N4OXFyclgwZjJBVzY0clNWQ3V1R0tyWURTT2tnOXhjNE0ycG5aZ3hl?=
 =?utf-8?B?Uk40Rmcyd1NTb2dBMDMrVW5XMHIrbEgwcS9pTTVkVUIwYWRORitvb1pFYVM0?=
 =?utf-8?B?bTl0cTVwOGovQTBaanFmenRPMXo2OWtNSHVrQkhHOUprUG9PaFJzc3BsYkI1?=
 =?utf-8?B?NXd4b1Z2dFBTaEQ0OVVwSFNoN1dyUENxUFBDRkViRXpaQllRbHZuS0toQ2JB?=
 =?utf-8?B?Qko4OVBoblEvMVlkZWpEWkhpdVBWQSs5Y1IvY2VhQVUxVm1GTEhhdDBYZ1pQ?=
 =?utf-8?B?ODltWENiamRFQ2U4SFBOb2RGVU13MmsxeElpbzFhVnRsTnUyRW93SHBZYTA0?=
 =?utf-8?B?aHJHQnRoVkQwU3BVWnU1RW9UM2c4SGx3aEZxOHBkM3A3MDcyWXIwdVpBQzZC?=
 =?utf-8?B?dE5lMjFNS2xuYXFkQUg1dytDUUxaRDBTNjN5VVgrSndQMjVzVS9sb3lqMXBj?=
 =?utf-8?B?ZC9jOUczeGFMOGlqcDhPM3Q2QVJSdGR6TU1LWk4xbWtkL2wvSnVhR1FVcFFC?=
 =?utf-8?B?R09BWG9BQ1B6eHA3UmJRNWFjS1BtV1BacEUwQ1RXNzNLYzJZTlBDMVJldEV6?=
 =?utf-8?B?cWVWS1cwVEsvRUNqMkkvd0Y0V1VpSTVtY0pqUlZvb2U4SkdxRkh1ZEdHREJn?=
 =?utf-8?B?SUFxbUtkWGFLNXdLMW5RUHF5OUhkcDhIQnZhdG9ZQ2l6RG9zbHdWRGxySjhW?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8db638ae-e7cb-4b5f-60a5-08dae1eb034d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 18:01:11.6875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bol1B9HYrObvoxo54X4RrXdKTZ9Iept0JS/CgQ5qyvC/YuAKg8V3qnm3Ypxz63N6FXU4NW31ydwePtVh0NFMW282kstljnZ14pEugIruACw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5162
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/2022 5:19 PM, Jakub Kicinski wrote:
> err_dl_unregister should unregister the devlink instance.
> Looks like renaming it was missed in one of the reshufflings.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Makes sense.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  drivers/net/netdevsim/dev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index b962fc8e1397..d25f6e86d901 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -1563,7 +1563,7 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
>  	err = devlink_params_register(devlink, nsim_devlink_params,
>  				      ARRAY_SIZE(nsim_devlink_params));
>  	if (err)
> -		goto err_dl_unregister;
> +		goto err_resource_unregister;
>  	nsim_devlink_set_params_init_values(nsim_dev, devlink);
>  
>  	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
> @@ -1629,7 +1629,7 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
>  err_params_unregister:
>  	devlink_params_unregister(devlink, nsim_devlink_params,
>  				  ARRAY_SIZE(nsim_devlink_params));
> -err_dl_unregister:
> +err_resource_unregister:
>  	devl_resources_unregister(devlink);
>  err_vfc_free:
>  	kfree(nsim_dev->vfconfigs);
