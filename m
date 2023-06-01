Return-Path: <netdev+bounces-7259-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B14F71F5DB
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 00:16:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 207A628194A
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 22:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6225F47004;
	Thu,  1 Jun 2023 22:16:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C44E2414E
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 22:16:42 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5841A2
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 15:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685657799; x=1717193799;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tren9qEvWtSC1BlYWfXVf0qUW5wEpRhNOmy3WliGbuI=;
  b=D2VePrd9I69nLEBFlOxNJm/yg11PI8xQu6+vG7Ge0nLI+kZU2nnGTMoV
   uZtBshmbhCzRBb6MScDuf10he4pFv4o2OfGicuda/N2C5cNa8AQABp59Z
   B7hknk/gGaXDgd9HoSxkuDlLZNFt/SkptsBeF3lEGcpJLPDnXzxO7kZKL
   HuS2iJHkwUbkpQBoSa1DXJ1j8ohszNn8Wo+dNVzV4oCnog8v+vs+XiPLJ
   iXoJFtjjO+cF3jV1BUxwiRjBS6ZWUlVWM1mutvMB0tk0CP9XtOvkMEB9y
   IdhvxwLIUPDMtdpO5UdCNgQC9eY6vj7WZMujX/O1XeGlkhv0twphlbH8b
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="442071519"
X-IronPort-AV: E=Sophos;i="6.00,211,1681196400"; 
   d="scan'208";a="442071519"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 15:16:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="772615494"
X-IronPort-AV: E=Sophos;i="6.00,211,1681196400"; 
   d="scan'208";a="772615494"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 01 Jun 2023 15:16:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 1 Jun 2023 15:16:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 1 Jun 2023 15:16:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 1 Jun 2023 15:16:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cxo2WHDcVNtvJlfC45+qLA5VUJvmLZr5SibbyOxD062h+TF0aSiRCU7Y17sdiKtyQSYFwVzeC/HGVnquQe2bYqVRyf5S1RMkELu5xU+GpJOXJCbMu4cSlYFFcLFXBrPr0QIfQWbo4oUp0BT1qXQKr3NrvRhRtgQe8ZHz+/Vz1OnArTAS1Q+iX6eSpfQMwr7r4Blo/JFVMffUuZcZllAvtJXtkoFUdBF0kwdW34LMsvLLSHdWzgg3b7sk3/JOf9mHwSYbP0Q7udzO1e39oG8z8LnKDSMDi0/ZvK15J6dDHaGTNPfw6FC0ruHHD6vd/Mz5AHUwEmmS2+4POVhvXSWHAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNRBmX/9QwV5w/LXrLEIRBZD+Iz/6zdTcBYkKI8RRLY=;
 b=HNv4JGrsePljLxg0iY664zOwdkpMZAUJsh34qJ5tNISNPDa4AVnplV/7bdnHAIPKPz9B8p6ESlph0HSLClqfvLgSqxAknSkDRa/kJcdmhIfvJAVEEfKCeLLCrRq164DsebQ/WPVno5OgSE+VCz1wclISUGqQWZ/X49Vpe9X0CBCufW2hNgwU86ab1L8/GY/C0N7+NpIR2mdFGEehz3o5tsKWo4IMO6aZqjG7fQCQnjIjyAK9eJnH8HTaG9TcYsfVGvMkCeddI6eXS7+or0QkO4I2VFusZdonybpFuVdBZ3Dt6Pp6uYihZxEGfmVXxlKHUsbUgttw/9ZFj2vyDpUaGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS0PR11MB7505.namprd11.prod.outlook.com (2603:10b6:8:153::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Thu, 1 Jun
 2023 22:16:20 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab%5]) with mapi id 15.20.6455.024; Thu, 1 Jun 2023
 22:16:20 +0000
Message-ID: <1afdbf89-6556-49a8-7905-43338f2a658e@intel.com>
Date: Thu, 1 Jun 2023 15:16:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [patch net-next v2 14/15] devlink: move port_del() to
 devlink_port_ops
Content-Language: en-US
To: Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC: <netdev@vger.kernel.org>, <pabeni@redhat.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <leon@kernel.org>, <saeedm@nvidia.com>,
	<moshe@nvidia.com>, <jesse.brandeburg@intel.com>,
	<anthony.l.nguyen@intel.com>, <tariqt@nvidia.com>, <idosch@nvidia.com>,
	<petrm@nvidia.com>, <simon.horman@corigine.com>, <ecree.xilinx@gmail.com>,
	<habetsm.xilinx@gmail.com>, <michal.wilczynski@intel.com>
References: <20230526102841.2226553-1-jiri@resnulli.us>
 <20230526102841.2226553-15-jiri@resnulli.us>
 <20230526211008.7b06ac3e@kernel.org> <ZHG0dSuA7s0ggN0o@nanopsycho>
 <20230528233334.77dc191d@kernel.org> <ZHRi0qZD/Hsjn0Fq@nanopsycho>
 <20230529184119.414d62f3@kernel.org> <ZHWep0dU9gCGJW0d@nanopsycho>
 <20230530103400.3d0be965@kernel.org> <ZHbqUHYHO3D8Nf/d@nanopsycho>
From: Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <ZHbqUHYHO3D8Nf/d@nanopsycho>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0067.namprd11.prod.outlook.com
 (2603:10b6:a03:80::44) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS0PR11MB7505:EE_
X-MS-Office365-Filtering-Correlation-Id: c9ed94bb-c768-4f1d-1b8c-08db62edd345
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zuc4gxpUUOz5/xi2g7MK3dNYO0DmshSqouRlKZ4IVvvm1u6Q/MTSAItaa6smwoOeardeBOgL7SXNACr2URg1DYK0YZHy97/91KgqrRZDkBLIXP9Bib6yQBny4kMlnQcMp0dv0exgZ0A8PwGLI0lEajAjyR5yfQQcoD+EsNlQ0PPTF4LWnkCcFlLdxfg0miuHjFmmY7GlN0EIZj7aTcF2g9LdgA/yPBXeZcXn3OZFEaz7kGmJb7GHa1E/VuapqBlmMBFpjdcVG8+QvRVfXyvTyk4eKfvMAZcGfm5ot0jpRxl3sW+/kzjvxRYPzLsORE016lrfNR/LJfg8KJtokEIfrVsH/pNIMxQ9osUcPNpvyabJAxjHO10WU/n9tePnbRPHJosksTEGujPWVoYjgvdSMmaSXZY3tAPT1aStoRisilAMt8U4FSawsHvVQ7a7hazyeyYo7r32sU/7tWa96S+ltyDUU/vxuX1IFS16QNDJlosCCFTAQd0gggUt61lvTaElEJC3nfIY8qupMasw26RACElkCXL7MWRDGgP/erW1Rxdvg/2hIOZBl8SyJbC+rixqhk8s6puqXaYBebgq/ieharX0zHtCdkCvcUmETfwkrco+9w5X2saa6DuGeaE+FZzRWMhohVJ7aHitzHrISfWjdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199021)(82960400001)(38100700002)(31686004)(110136005)(86362001)(478600001)(66476007)(66946007)(66556008)(36756003)(31696002)(4326008)(6486002)(6666004)(53546011)(186003)(26005)(107886003)(6506007)(6512007)(2906002)(316002)(8676002)(8936002)(5660300002)(7416002)(2616005)(41300700001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tnhqd213UWFRcjNIVUNTbm81TFFSQnRQWTBwSTV0b0kvaWxJNENKdUxyMEVU?=
 =?utf-8?B?aTJMQ0k0bURYSjA2SHJaMFVidGFEdTJoTzNiZUsrWU5iRkMwQzd0ZG5MT284?=
 =?utf-8?B?M0E5WEhiVm1DZGhxdzIySGd4Z3N3RnFZYzQwemUxRlVjK0VQTUYxMUZvVVgv?=
 =?utf-8?B?WjZMa0JaQnRuUXhKREpGdzNSU3JBTTd0RkkwVkZzMC9BcVJNUDc1WU93Unhl?=
 =?utf-8?B?cEloTVFzYW9hRzVZcHBTYzI2M2NZVzA5T1lWTGdvd2ZiTTFNdi9JN3hGeXgw?=
 =?utf-8?B?TWZEa2NsRVNhTElobDZldnYwY2lWQm5PZnd5alh5SnFiMktQaE0xcHdxTFBP?=
 =?utf-8?B?NGo3ZVVPRGczRDF2MjcwSWQ5a1BsR1p2MzVkdVhIVEF1MDU0U0Nab090STIr?=
 =?utf-8?B?endUU0FzenRkVUlHQUpRVWFJQXJCWnZQRkMraDBuZm9iU0Q4T2QwTkVNTXhF?=
 =?utf-8?B?cnNRV1VDOEJreW5vTS9RdTFOaHJxaTU5V1ZFMlp2RHJxWUNLemR3YjBGM0pq?=
 =?utf-8?B?ak1hdGlwVXg0NGhGSzdONlpuTDlUckoyTS8vM2Q0MUdJWFNtK2daTTQzWTdB?=
 =?utf-8?B?cTNUUnJOZGFwMkd3SUdvdTFzaWdFbkh1dm04VmlqbkUvSi94cWoyb3I2Y2Vo?=
 =?utf-8?B?L21JWVk2d0hEUWRSM3A2TDhhSzhwaW5Mcm44WjRoclRjU2t0MTlPK1NOd0lM?=
 =?utf-8?B?a3dROVEwQzZhRkd1ZyszZjJGczBZcXZRYkcwQmZrNUZIVXVCRTJ0dGpxOGV5?=
 =?utf-8?B?TVdkc24zZzBSMnZQaWI3VUo4RG1takM2TElheitQVmZkck12aXloMHlobFVC?=
 =?utf-8?B?Ny91V0ZmcDJHRkEwRzNzVURQOE96UTQybnVtNUhTTFdmK2RKWjRlYUtxMkdH?=
 =?utf-8?B?cDdYYUh3L05EeXdQc3RZZUx4U3l0L014N1dkbnhZTkUzVUhYUmd3RVp2N21E?=
 =?utf-8?B?MU9ZYW5ZZlRQMytQWVBSaHRBUE1mdjBEMlk5akROa1BYR1dRV1R4bUErd1NT?=
 =?utf-8?B?WkFLM3ZQK1NJSStrZ1BOQlRDcTFGTkVDZThMa2hKdlVMZVFyU3JiNWJVR0xl?=
 =?utf-8?B?SXdVWEo3M1dHVzdQMjFrN3RhVFhaRlkzMitxeGxNUFVSbzhZNk43ckl6RGhy?=
 =?utf-8?B?K1F4MVBoeDNoQkxsT0NweHFFa0V5UzZJemxBY1pibHo2dzU5cy80dUt6WjZC?=
 =?utf-8?B?U20xR1FIUzhDTEZIbWtiOUhsTGFuTDMrTW5PVFN2OUxZdThaamFuWWoycnk3?=
 =?utf-8?B?R3B2bWUxMUlUT252SWppbU8xbFBkK2Q2Q21VTkQrdktZWHdKRWp2RkppdUxF?=
 =?utf-8?B?bDhkWU5Yb3hsSFVnaEtVaFBsZDB0ZG5oV2JTV2Q2UWVoNUphdmM5b0ZLSDJL?=
 =?utf-8?B?cVRQb2ZOM1ZXcTZCMWtIRGorVC9ncGIvMVhBRlQxZjIrRm91akU2M2oxOXN6?=
 =?utf-8?B?YWFaa1RQdW9JdXUzczFxZG1BT0R3L29CRVhBbzVGVExMYy82MXA1MlVGS1Y2?=
 =?utf-8?B?a0p6Q0hCYTlHN25mMnJmZnhRbDNCL1ZDanZxNjhwTzRnRmh2RFA1YzJxc0x3?=
 =?utf-8?B?dHBDajlTTEh5TGdUUk1BOENvZzZHbmkwbkVwNHJPQlJ6ajhsOS9LNXdqUDg1?=
 =?utf-8?B?cEJ1S3lrc3RWVmRwKzg1dmNreEJNYTlBR3UrOWhXUkRtS2NESVZEVSt1OFhn?=
 =?utf-8?B?NDFMbWlHSjU3NXlOVGl6Y0V4S284NUpBVTRvOG5LNjRWK0FWTEM0ZFUzbUR5?=
 =?utf-8?B?MUdIOS9rK3RVekhQUnQ5NkdBTUlmVUtkbldOVU1kZnFzOU82L1h3ZjIvYytX?=
 =?utf-8?B?Vkl3RmNSWnlTMjd2SHI4Y3g3eG5SWG9GVmFocXJ5RDVmRHVIYng0ZWdCaG9S?=
 =?utf-8?B?NG01anAzeG9XMnpTaDRMcWVXZnZVY3BETFIzMGJmTVozZnRYNDNwdEJnVEhN?=
 =?utf-8?B?TDNXZnJLaWplR2VwRWlOc1U5YU9naFp0Z2FJTnphNEVreVQxK09yVnVjQmlK?=
 =?utf-8?B?cVlyOTJhcHUyMVc1SDBwcmt5WWZmVVI4VmZFNHlsY1ZSZ1JNUFVjWHEzaUpm?=
 =?utf-8?B?RGJZN1pEN2g0akRFNVcwR214TlEyKzJzQTh5MHlES1hlNXd2RnYzV2MxTjFn?=
 =?utf-8?B?L2I1dHFtanljQ2dtQ1htSU1TQ1Q0cUJBRktEUXFYMjZZcWpnNWgzZTJmZVpx?=
 =?utf-8?B?ekE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ed94bb-c768-4f1d-1b8c-08db62edd345
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 22:16:19.7167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zxRZPQC8zhVv2kbiigou+KvPf6cMVtnISNkPh0hrma3t3BObucc1kiPb+gHmY7N4YoxuVAGc6epvS8kKWFJfK+of0XwTit3mD4siCfeegOE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7505
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/30/2023 11:33 PM, Jiri Pirko wrote:
> Tue, May 30, 2023 at 07:34:00PM CEST, kuba@kernel.org wrote:
>> On Tue, 30 May 2023 08:58:47 +0200 Jiri Pirko wrote:
>>>>>  	.port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
>>>>>  	.port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
>>>>>  	.port_fn_roce_get = mlx5_devlink_port_fn_roce_get,  
>>>>
>>>> Is it okay if we deferred the port_del() patch until there's some
>>>> clear benefit?  
>>>
>>> Well actually, there is a clear benefit even in this patchset:
>>>
>>> We have 2 flavours of ports each with different ops in mlx5:
>>> VF:
>>> static const struct devlink_port_ops mlx5_esw_dl_port_ops = {
>>>         .port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
>>>         .port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
>>>         .port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
>>>         .port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
>>>         .port_fn_migratable_get = mlx5_devlink_port_fn_migratable_get,
>>>         .port_fn_migratable_set = mlx5_devlink_port_fn_migratable_set,
>>> };
>>>
>>> SF:
>>> static const struct devlink_port_ops mlx5_esw_dl_sf_port_ops = {
>>>         .port_del = mlx5_devlink_sf_port_del,
>>>         .port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
>>>         .port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
>>>         .port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
>>>         .port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
>>>         .port_fn_state_get = mlx5_devlink_sf_port_fn_state_get,
>>>         .port_fn_state_set = mlx5_devlink_sf_port_fn_state_set,
>>> };
>>>
>>> You can see that the port_del() op is supported only on the SF flavour.
>>> VF does not support it and therefore port_del() is not defined on it.
>>
>> This is what I started thinking as well yesterday. Is there any reason
>> to delete a port which isn't an SF? Similarly - is there any reason to
>> delete a port which wasn't allocated via port_new?
> 
> Good question. Not possible atm. For SR-IOV VFs it probably does not make
> sense as there are PCI sysfs knobs to do that. Not sure about SIOV.
> 
> 

At least for ice, the current plan for Scalable IOV I had was creating
ports via port_new, so port_del makes sense there. I don't know how else
others were planning on doing this. We're a bit delayed on being able to
post actual patches just yet though :(

>>
>>> Without this patch, I would have to have a helper
>>> mlx5_devlink_port_del() that would check if the port is SF and call
>>> mlx5_devlink_sf_port_del() in that case. This patch reduces the
>>> boilerplate.
>>
>> ... Because if port_del can only happen on port_new'd ports, we should
>> try to move that check into the core. It'd prevent misuse of the API.
> 
> Okay, that is fair. Will make this change now. If the future brings
> different needs, easy to change.
> 
> 
>>
>>> Btw if you look at the cmd line api, it also aligns:
>>> $ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 101
>>> pci/0000:08:00.0/32768: type eth netdev eth4 flavour pcisf controller 0 pfnum 0 sfnum 101 splittable false
>>>   function:
>>>     hw_addr 00:00:00:00:00:00 state inactive opstate detached
>>> $ devlink port del pci/0000:08:00.0/32768
>>>
>>> You use pci/0000:08:00.0/32768 as a delete handle.
>>>
>>> port_del() is basically an object destructor. Would it perhaps help to
>>> rename is to .port_destructor()? That would somehow ease the asymmetry
>>> :) IDK. I would leave the name as it is a and move to port_ops.
>>
>> Meh.
> 

i like thinking about it in terms of destructor, but that sort of
implies its called whenever the port is removed (i.e. even if removed by
the driver via something like devlink_port_unregister or whatever its
called).

> Yeah :)
> 

