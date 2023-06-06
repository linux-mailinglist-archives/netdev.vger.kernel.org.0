Return-Path: <netdev+bounces-8490-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7D6724496
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:38:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 058EC280ECE
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528382A9C5;
	Tue,  6 Jun 2023 13:38:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4136537B71
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:38:22 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD0B12D
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686058700; x=1717594700;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VyTfApi8UPVQsy1YRWU+E5clL3tS7NmwbD8cJRmff3E=;
  b=Z7B9YkNpQCvYeS1BIjD64/DAb8D4tTCVGmcp7y5grEsSACREpVT8fZQg
   CFP8uFfyyoIpl4PUyT6m4/34NWbKoXytwp2ykp85YoivIMnlIQo+zqVA3
   DYSCHU3aOXF6Dd0odC2SkyHgWh1/H1rHegkSS8cJPNxxh6g708hq5L3nl
   dg1TeJ1T2uAguWjvMqGGri0doVr+eDwED3qv79E+segNcbZyn0WpJt2en
   4IXXHhfGag/X3bIJkYSwizS4R5EuMl/k1LmNZm5RuvDEOqzSm+iIhVxaG
   L84cLWFE+1xIbLNrbpJl7+IBQsK7d1UT50wIa6lEwlAEL+FpQ/IkWYGi4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="355526883"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="355526883"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 06:33:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="955750220"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="955750220"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 06 Jun 2023 06:33:01 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 06:33:00 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 06:33:00 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 06:33:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtWtXT0mvQZh4+VeOqRsSj4aNNL5OONTIRDrkwuUbrn0vtLLvAL7ZHEewXcwIvsYmhVedkKoL7N6C1GljB2bnMKkgiAzdlLSZgudB/Kd/3js6TDTdyU5vC+yvCGwL+WnYMFIdz+VtICKL+T0jmw7d0oKZydsYH4xlTfhjM7Udzr5Gh7qEASzf/zlnfTa9TZmEMJ6dCwP/vkNqmIjxZVbzqwkfBWuG3lAwkEL4dpn3DR8SiVsgHs+/CIDYkdZMOyKxzIkMxoO5w88kgy4SIVwMLP05fWWvjeDuiQaenhVICN/G8Z7TfXuMB2uvu1UfUzv4hqANGSzLHC3U8NrTFzDzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z6fUCvNlSEMj4xMScR5pLUeds3NdkZft8B+Yd5h6OTk=;
 b=e+nnWhuxTk11PSwD1EG1QzMAOM40IIafSUt+e6lLCkyWRQvCnFqI3f9RHUlopJ0CGPtN0qF3cBKZmxdbU9jWwcJrP7RktW4dQvG5tQVTFTgbffzp5j1Izvfc2+KX64DjnWZKEnUwTImTLbpFqPHT34XX31YhYgZtIjheEfO8rTOqHubt5YdA3Yy93zemBmbKNmVPg/q5BO9B2Flj5N30Jpie9xZ+cgLdqv6wQkapPiMEmMvKXGWtYKV0qLWSaZNuoZP6Y/IZ6HE3e4mSZcAY64PT4cpCq9L1h6gwTGh5yH1ITHBSwHR2fTh9322fONvQCkWop+cNJOgB5KIaZTHXxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA1PR11MB5946.namprd11.prod.outlook.com (2603:10b6:806:23a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 13:32:58 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 13:32:58 +0000
Message-ID: <1bd64ee9-4004-ddc8-6bff-6d8fc75c30c1@intel.com>
Date: Tue, 6 Jun 2023 15:31:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH iwl-next] ice: clean up __ice_aq_get_set_rss_lut()
Content-Language: en-US
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>, "Sudheer
 Mogilappagari" <sudheer.mogilappagari@intel.com>, <netdev@vger.kernel.org>
References: <20230606111149.33890-1-przemyslaw.kitszel@intel.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230606111149.33890-1-przemyslaw.kitszel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0155.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::15) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA1PR11MB5946:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c3a34aa-543d-4bd2-4328-08db66928a57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GfVy6QmN2585xB375birtR4RahxCJohqraPlchSlnu0eYuCSiNtGHBaiI/EHG7XTuEh5t1fjs/ouJ60HGcLPQQNwA2/6USmbYKvuv9ivUAXHoygBip/kxMhIvCOOQBlCLr2WXrAVSIR6c11om7B77qJZnlNWSu40XkuVRCxP55HVJOPAA+jbYGcPNCjwS+w8sDEUtYUPwrmJbRmWadi0RhgH0goP8hBSNbewIa/gqxX+z5M6GNRu8BpGVwY02MadOYRUXtFucqsILxh+Mpk/0moQaFqkVTfH7G8ebGAmclFaaZGM3j/K8HR5+KlZ9oesMuJLQWFCY4if+zsBnQYZVysTsAf07WXkBaAQxVDul8OZT27B3d9b54APNWselyWIEoq6RPTplnk7SogczSvuqKKisvBz5A8aYh/bUivTGY13nqJ+jwVNxG8g3NzQlqpM0OhM9R01pDXZaw9xVWarasoaj7CUM6TLXJ417nFgMsSJOuwjB9Lp2V5UdC66ehV6ieqZ9JyGBIMnZsNcTKh5+KluYcz7jpTZJYhLhHNP0gl8ThwisoSQwtK9+fGZGOwjFb18J/HzJtkttsB6MBsDmfLN9jBVtY4rQfzsaNBS2nmIFoKziORXr8eA+YttXoKIjsCAuyB/FeHld3brxBJYnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199021)(6512007)(6506007)(38100700002)(2616005)(41300700001)(6486002)(6666004)(31686004)(26005)(186003)(966005)(83380400001)(478600001)(37006003)(54906003)(6636002)(66556008)(66476007)(66946007)(316002)(82960400001)(4326008)(5660300002)(8676002)(8936002)(31696002)(2906002)(86362001)(6862004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3V6MVkwOHFmQmhSVW03YS9zZ1VmOXkxWmhvcks3L05GSFRQNk0xelljZnZC?=
 =?utf-8?B?M3FQeFFRbkJpcVhwUnczaUYyR1hnUDNuRWtLUjd0bTAzaWQ5UjQ4RjkwMGtL?=
 =?utf-8?B?bUxmbmVVTHY3SmJLNVo0SmJTU2wrOUJ4bmhoU3RIanl2R1VKbys0VVJtQ2E1?=
 =?utf-8?B?aC9PaFZJYS9DS0d0QUg4enNTWmk4NDN6Z1ZiZ1M1UzhLZlFneE1pblVHWVJu?=
 =?utf-8?B?SkZvV2VVNUIrSTE2UTZsYXBtd1RhNjlEbEZ4VDl6ajJjSDBaTXdRK2tqWnh0?=
 =?utf-8?B?K01JUmRPNGVaRWt3Y2hoZTVaclN2U0FhL1RtditNWWZ1R29UVDRQUitCZUZh?=
 =?utf-8?B?TzdNLzVHcXhDYVdPZk9SdnUyaU5Yd3FnakFFZFV6amtudlY4TWozM1BWdStW?=
 =?utf-8?B?U2dLZzdYdXRuYXBmUytxamZkUGNzMDQ1ZUg5aVZoN0F3Y2g5dDVVelRrRVAr?=
 =?utf-8?B?SSt4eVRWcHJ1VzJsQXlrdHBrZmhtOXFLLy82Q0lOY1JmYjBOT21JdGJvTTlz?=
 =?utf-8?B?QlF1ZXJFV0IreEQ4WVpVMzRJZldBdEhqbGJoei9VRTJBbkp3bmZicjhpQXhF?=
 =?utf-8?B?VEdhQjMvVStqSFJvUlNBSGFWRjRNOHNOa1ExNkVBRGVycjBTNUU5eU1wN0R6?=
 =?utf-8?B?SHRhdmJscFFjU055cmlwODcrNjF1K0llTEdIckE3NmlYQTN6RGI2RStLdGFq?=
 =?utf-8?B?azVQVkR2cStkcUQzOGtwS0ZKcHkxblU3MXRlWHVhb1RSZFpnVHJmN0YvQWVq?=
 =?utf-8?B?YXYrWk9YSEFBelgyZ2czK0NMNm9kRHF1K2h5UkVtTWVOem1VUmRPZTYybE85?=
 =?utf-8?B?Vm9WSkIyUENQaFRxSTUreElKcUgxVnNlcGVpN3Q1RHA1Umw4UzdqcERWQ3NI?=
 =?utf-8?B?ZGpJNExKUGVaL21LZU5iV2pacGFneW9nOVVJeTYvVi9GSXZzN2VQM3dOSGQ2?=
 =?utf-8?B?ZUNTV01YSjNHMjE3am05czk4RkRSc1U4V0hiTURrd2Rlc1RuWnFWdTRGVU5V?=
 =?utf-8?B?cXFRUzFpTnZUeVdMbU5CTEk4SGZIcUJ1OERCc2ZUdmZ4Q3F5NDhReWVpMEtI?=
 =?utf-8?B?dkxiVFRrOEJEbjY2TEZMd3EybS9mT2J3NUdhYUdXNTZQTGcvRnc1Qi9jSUVi?=
 =?utf-8?B?SU9tekJ2U21mbWhyWC9SeGZhQ2hxc3A4K0YwcGhndWhqclN1ek5FYmtaWXUr?=
 =?utf-8?B?SzNWZFBXbEg4MFljNURSQVZpZWVObW9nWE9yMVhPQWVURGtSek1jdFFiRHdq?=
 =?utf-8?B?MzJycU1ORk81dENNeEh4bi90ellQb0FLWWlXZTN0VlViUDcxRGJVZEFRdm5M?=
 =?utf-8?B?WjMrajNXeGUxUHZCQURmeU5zSXcyeWdXZ2JHOERqNkdLbGJIZkE4by84M0Nt?=
 =?utf-8?B?SHZWbWIrbThKbWU3VnVGWWRQeUtyTEw3OXc2RDdjR2prZUJLSE1sMjc0T0Zn?=
 =?utf-8?B?SytIblFNN0MrdStabFZSRVpWVWsyb2p4bWVWc2wrdnJJUjU3WGxxRVlPRVRj?=
 =?utf-8?B?UFE0Uk5TZTdiVjlLV2ViNEJ6ejZZTGpHMEhnZHpQNVUrU1lva1VONmxmTndv?=
 =?utf-8?B?bGFlRHlBbWtwcmdYRi9tN0FnNExTczN6L0VqQUVFdEpMOTNiekhRZ3d2YVFC?=
 =?utf-8?B?RzZoTFVGUjI2TzNUMmN1VklUamVYZDBGbWVwZFlGbGcxWnFndFBkRnVxMzZp?=
 =?utf-8?B?cFM1Mm1kSXg3RnRRQjVCRGE1cFdCRSszVEZQNXpLQklXTjBySXJGaEZpbnNk?=
 =?utf-8?B?N2NmZTkwQU1IdzQzdjVWTmY2YXQrdk5NVXJQYkdPazJqODk5S3ROWG5hMEZ1?=
 =?utf-8?B?VlpMN05LOEdkWWx1eXhJVGkzcXM2OE9OcmlETmJLdmNzREFYVlBEMGR5U1Bk?=
 =?utf-8?B?dTFPYi9ka0JJcytVUmUzenFkNnVRWXJLQkVaM05GaUZzd2I0aWladjBEN0h5?=
 =?utf-8?B?N1MrdHB2ZStLRFVWNWNJM2JKOEhqZWZjSERQU1ZIMGFuNTB0Y2Z3anN1Ry90?=
 =?utf-8?B?eXVLbTZqZ2xDMWYxMFR4NWpJNUdEVGl1cjJvZHlybHlNcWh2QU9lbHliWTFN?=
 =?utf-8?B?bDVhMnNmY3g4cTVscjJWWU9Xa2pqRUZ4amZ2Wm1HamZQVmlDN0FQWnVZTHNS?=
 =?utf-8?B?N2VBRHVLYVVmR3Q0RldPUEFUYXowczZXRzJRVkRvalIvMGVxUC9iUXJUYk5u?=
 =?utf-8?B?NkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c3a34aa-543d-4bd2-4328-08db66928a57
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 13:32:57.8412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZIHC6emhC1FsLI+yw5Za0o8/D4T9onKkBm+yv0yx7wZvJJ4CS1SF1u4y6bfZR4ZaeiSZcdGpqUAURoT9hkQvpJMcj+HJn+P3kuaguznbx3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5946
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Date: Tue, 6 Jun 2023 13:11:49 +0200

> Refactor __ice_aq_get_set_rss_lut() to improve reader experience and limit
> misuse scenarios (undesired LUT size for given LUT type).

[...]

<related block begin>

> +	opcode = set ? ice_aqc_opc_set_rss_lut : ice_aqc_opc_get_rss_lut;
> +	ice_fill_dflt_direct_cmd_desc(&desc, opcode);
> +	if (set)
> +		desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
>  
> -	lut_size = params->lut_size;
> -	lut_type = params->lut_type;
> -	glob_lut_idx = params->global_lut_id;
> +	desc_params = &desc.params.get_set_rss_lut;
>  	vsi_id = ice_get_hw_vsi_num(hw, vsi_handle);
> +	desc_params->vsi_id = cpu_to_le16(vsi_id | ICE_AQC_RSS_VSI_VALID);
>  
> -	cmd_resp = &desc.params.get_set_rss_lut;
> +	if (lut_type == ICE_LUT_GLOBAL)
> +		glob_lut_idx = FIELD_PREP(ICE_AQC_LUT_GLOBAL_IDX,
> +					  params->global_lut_id);
>  
> -	if (set) {
> -		ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_set_rss_lut);
> -		desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
> -	} else {
> -		ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_rss_lut);
> -	}
> +	flags = lut_type | glob_lut_idx | ice_lut_size_to_flag(lut_size);
> +	desc_params->flags = cpu_to_le16(flags);

</related block end>

Now the tricky part much harder to discover than FIELD_*(): you have

{u,__be,__le}{8,16,32,64}_{get,encode,replace}_bits()

macros for such cases :D
They aren't described in any kdoc and the indexers are not able to index
them (clangd however can IIRC), you even need some brain processing in
order to realize they exist. See [0].

I'm not saying they're perfectly applicable for this particular case,
just FYI.

>  
> -	cmd_resp->vsi_id = cpu_to_le16(((vsi_id <<
> -					 ICE_AQC_GSET_RSS_LUT_VSI_ID_S) &
> -					ICE_AQC_GSET_RSS_LUT_VSI_ID_M) |
> -				       ICE_AQC_GSET_RSS_LUT_VSI_VALID);

[...]

[0]
https://elixir.bootlin.com/linux/v6.4-rc5/source/include/linux/bitfield.h#L174

Thanks,
Olek

