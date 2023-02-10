Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854F4692752
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbjBJTpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbjBJTpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:45:07 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166CB6C7F6
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676058272; x=1707594272;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EDZnXxNffYd5gsLU8TfYcV9ZAKvFi9HY4TiQhZeHb2k=;
  b=G25fFT+NB8vdbfHfAL4YjSxABnLt29GQT3EwzA91hfN8p5iyjKpUi9zr
   3PNTlCR3TIQ3BokaRZBxuZbzBh5H/+Fn2wUW/9UkYwv7RDDtzwFZcX1bl
   kp5hH5iYOHWNtH/vH8bpkG2vU8z7GLZ9CIO9HrtQpjVSi0bRmz8N8DTKL
   jSTVYortja0auWykiYUMjnFHYdSpnKWHPzF+UCyOQ3JBag8tFHi/BbP9/
   cPbAVywsKjHI2MJTMUPHyUUae6yCqkQLU5k+WGs+0xNSMjQmNNM2Hfdwz
   PjdEStxQIKKr4LJqndVl1P2sxf9hIjecCLF8RDnmdnH8k5XIkVP7yaPCb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="329141178"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="329141178"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 11:42:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="792090699"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="792090699"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 10 Feb 2023 11:42:06 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 11:42:05 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 11:42:05 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 11:42:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIM2d8sKlgFoXWcqP5y55fbJM7oabaRO9f6ZYKo2MipWiIV2dUA4dxXUa4lys9URt6JGOSZZ3pocbDLWIM6+q2ZMaLKvgtBlIScdtv3TX4JaYD/bHLfhSq6Vitf1NNJOVg2ny18xM6szVnzeQZa6FzDwfxbAfJyG84IjEWuHCC9n0Rvcryk16jT+mtwzWl6JDtB9eoobNOAYkdQm6vJU+cFVrWaYQpjbzjzdirTRm346dh0tVVbBS4pOIzgTygKg8t7VSxJvUk/5sUa5ExwXARrj3mvAB6IuioCGGBy2ut0gpkQF2Pg2N6fGSKLfKjsUCa4SICdg6rv7kYm7uEHL7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OxZh9v2+av3uwMGMs/UOdJyfsxxtIqUL/4yzTUnPn/U=;
 b=EvUNrG86qb8MzTyLcLEFsKn/qlrQElHmT3ozdM+bEeiez49rS/je9G7Ppw2XjKCbNVzBpQgH+TfTCw1IYtrJVSrmdRIiw1M0C3YvNojK5WtJS93kbgy9tIGdL+KGnQ+0cAWqKe3AwdgSwrixIuVQ8Fh/K4uEVSjZNgBhywcx4qEkYIFn7ygNb+NYsuDjPoCY9JCLzAANvg0Ro2Wp0DSFbfj5yROT5WURAmCQx01P8GyUn6uAK0rRiJ/ohQoPjNGbexQUqOJJ3hbb1Zj+Xz5E5nZeXeqQcM6rEPY5UnjkbtkuVXQvYkxWVFszsT5V3Pjf7xXjZkrSOVJA/rxV55uyHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB6455.namprd11.prod.outlook.com (2603:10b6:8:ba::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 19:42:04 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6086.017; Fri, 10 Feb 2023
 19:42:03 +0000
Message-ID: <c31ba60f-3276-45ed-d2ed-23b6dca7d245@intel.com>
Date:   Fri, 10 Feb 2023 11:42:01 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v2 7/7] devlink: add forgotten devlink instance
 lock assertion to devl_param_driverinit_value_set()
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <tariqt@nvidia.com>, <saeedm@nvidia.com>,
        <gal@nvidia.com>, <kim.phillips@amd.com>, <moshe@nvidia.com>,
        <simon.horman@corigine.com>, <idosch@nvidia.com>
References: <20230210100131.3088240-1-jiri@resnulli.us>
 <20230210100131.3088240-8-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230210100131.3088240-8-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB6455:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c36868a-4665-4659-7453-08db0b9ee242
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WJINQ13CxC/s+JuIJxI3iYJlkEETgUiEK50ohAm9yXKAYfDD3olrrAwrxc5+KOyfpEpn5Eq9cw5LLVuCdCrzHh8B8OHuE2gm6tJ4yA1QV7+iPhfpWOtYW/i0RaYVvEbNDRji+nBo53v/b3HOBWpquA1/9gSuBK6T65HhLyusERmBWmcP28RcdYVUokCr2rSn/r5V3Ga+/XBvhEp48eiVMgWsJTiSMknUXL4otJmnjiL4xiq8en1aEutR7vCtTFYqKXWJpv1BjksRlvnopnABFk4uZDp8pNzHhKvORxM7Gy6ZIvAkZ9Nu0SyzduMhAk8Wv6iPllfqYJ6xTMyYMkIEVhJPRXhDVCX4cauyFkV625FoE6IaLvAEaTMtQv5hPmaCC6sD7v3AC9JtXul8QoBDkwuTpEfS5K5ZpNAhyLNlFm+lnOgF3TbfJyPUHIGVy5OhRaQaHLew6iu6GzkvvJcks+H0njHd7y11at0DDRBKkUBP3dft0q+3faSoi9iacCrVei9EWt3svhulQz6iXKsm9JEAcUosB8jd2ed2+W6D495Vpi8f+Of/xlYHpOYXc9jEkP39HJj8oyOX06jsUBO92f96lu/lez18HHKgsw8s/c6wHy3gY7ROFdqCrXtHaroMd0qB/x3bw4pRed3NtuL/SQ6hJIti5QxtAJEUckxzXrD0AuHfep3ELT0ZXojhBW/gtfK8D61OXaRZVPqaPMKCLimLG+/K8V0dwD48raIunuw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199018)(4744005)(2906002)(186003)(7416002)(86362001)(2616005)(8936002)(5660300002)(26005)(82960400001)(6486002)(6506007)(53546011)(478600001)(31686004)(36756003)(31696002)(83380400001)(6512007)(38100700002)(66476007)(66946007)(316002)(4326008)(66556008)(8676002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RTFRU0FjekVtbUd6SkJGeG5rV1pxS0Z3SVdqRFgvRC9VYStFdmhMQy9QL05L?=
 =?utf-8?B?a2lGRXFrakMwYjRBeldKQWNGNUpVVjRHa0NQYXY3Z0kzQW90blNpQk9FTk82?=
 =?utf-8?B?dm9yQUlva3ZiR2lIYnIrUFFmYlc3VDBIQlhCTVpFZlVlUVVsdTBSR2YweEFx?=
 =?utf-8?B?M0VmZVdvVGJuK1VHSFZjdW9GdEszWCtWTjFrV3gzM2RqYjZUZExacVZHSnNq?=
 =?utf-8?B?eldqbElCbE12dG1adExFNlhYTFlPUHFoRWVBTVZXMlRndkhqdXArYVRidDJl?=
 =?utf-8?B?V05OZlN4MnVWSU9NanZIU2lrK3VkODFMTlpza1E5MDFmOUwrNGt0NHRoVFFw?=
 =?utf-8?B?WmJKZEtiL0VRN2I0WmV6c1RmVzYwMzdHcXVIOEIwZWk1MDN3M3BrN3U2UWJD?=
 =?utf-8?B?bjhZa2NPZmIycVdvQWRjelBuNkJ2TmNMdGFwODJzWHNITzEvYUQ5RjY0Rlps?=
 =?utf-8?B?VHNuYmx0QlhrR2E2RDRtdnQ3Wk5uWkhMUlFkOE9WRmpXVjZqbkt0VmJhdVlh?=
 =?utf-8?B?UEdTZzJuT3E2K2IwTVhKNEZXNlZCeEtXMTMvMmNWMUtGQlB3WlRDajJKd3hr?=
 =?utf-8?B?RlJqK2ZqSFJ5RWFpam1BSk5uakhjVUZpc1FHT242akliUW1HUllLZGJvQlNS?=
 =?utf-8?B?TW9lNDJsNWpBb245b0FZSnhST1RqVFBrck8yMDZjL3BZaSs3NnJoZUFqdlI4?=
 =?utf-8?B?dmxZOG9WYi9mS21FQnRuQXU0K3pvRFAzc0lnRkppZEZOK0RDTHN0NkYvaVA5?=
 =?utf-8?B?aW5vYVVRTURoNElkdC84N1dTTWNnUEVtY3VJWlRINWs1dFBsWmVVVGZhZlFm?=
 =?utf-8?B?V29IUW9QK3NuYmtmd2gxa0V1dm5nWUx6OUI0MXp0WXJwWktDMkF5bHl6Q2xl?=
 =?utf-8?B?cWx2NkpiM2JCeFZ6VkxYMk81SGFTN0VMdmR0UDg4UjlmYnNpVmpubktnWk1H?=
 =?utf-8?B?TFduTTBlTWJqMFd2Q2UrdEpwKzFobzFCWmwvWU1EZS9VeDhvT0hjV01ITnNZ?=
 =?utf-8?B?YjErZlFPL1dnUnlxU0JyN1c5K2J1QTRlQy9kR21lZE83T0dMVnRMRjJkaEZD?=
 =?utf-8?B?RnpUc2luN1BPcEtueW14NWNNYjgwSHAzZFFtalBQdmh3bzdOUW5qTjBoRHVT?=
 =?utf-8?B?eDB6UEx3OWl1b1NPZHFNWXFvQUNvaDRodmdFdlBGWVJSeXE1UmhDQk9ud1lI?=
 =?utf-8?B?T2RTOWdJVW9nSEhyU3Z3M2V3a2JEU3A4MkNtSmFoYXNCNzBpOTI2RnpTdjdJ?=
 =?utf-8?B?czNxeUJvM2JoOGlVTUpNMXVpK1hNTXk0cU9lQkx1VWNkdXBRU0dHUzltaGZr?=
 =?utf-8?B?NmpnU2lZajlWMmpVVU5JbTJaandBMnhidU5XaU1jTE82bDVZUFhiU09ZVFZM?=
 =?utf-8?B?S1ZGT0VYZERIcjQ0OENycjNya1lXR3Q4bGp2ME1kWGZORHRqTStoMVZFOFZP?=
 =?utf-8?B?ejBDYzQ3WWJ4NDJYbUtDK3ZGWTVYVWhiZi92ZjdEb0cxYTI4NyszNWhYUEgz?=
 =?utf-8?B?dUNtd2FkZWIxUEhDUlZoME5BRGxIMWtHQ0NRbGJ2Q1RNNUkxSXhZMkhlZm1S?=
 =?utf-8?B?OVZjMlFpYkozU2Z0cTBqL2hvSVlTQ1VQSjZ4YzJxdHJ3bzlMUmJpN1RrckFJ?=
 =?utf-8?B?NENtS0pKM25ScC9ldy9yM1RMQjlqVWNvclNid0ZpVk1qbnVPWEd6Z2NoWTQ4?=
 =?utf-8?B?L2NUcnFxNlF4UDFqL1d2clg1UnVBdldHQUQzeHVqU2RiaUpPdzc1UDh5Z0xy?=
 =?utf-8?B?VmFteU5sNDNkVHkrQityK2NhZUlDTjUySVN2OUZWNWlncGV4cmZXQmw4cEpI?=
 =?utf-8?B?QWdYUTRvNk9pOXdJYVY1RTFjNWtHUThLWXNnMG5PbGY2aGV5aTgrQ0c1YnpL?=
 =?utf-8?B?emxpMzlTNG80SmVycVlJVG9LejNEc3pnYUdnT2ZDbThidUR5dkl3MURxbXZ2?=
 =?utf-8?B?dERsU2V0WjRMV2M1QTlmK3lOYkZQK2t2R2txellBVWRzcDllOFI4SjNXakZ2?=
 =?utf-8?B?dFJQWVFteFBPMGcra1h1TmxzS1diWVRCSnE5VVEwZncxMUNweTA3ZE1CS1pN?=
 =?utf-8?B?Wi9oYnZMYlBrY0xNWm94R1FYeVhaUkZXNXJOUGc4bkM5QmFQZUdpY2k1RXN4?=
 =?utf-8?B?WXloTGtXaHlIWTYyYVBkMzh5aTJrYzhSWDFiRHdpQjFQRDJFS3Jqc3lXUmJt?=
 =?utf-8?B?TlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c36868a-4665-4659-7453-08db0b9ee242
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 19:42:03.4925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ZJu323FH6JGYSXEryqL+IhcIaU+IGfsks1Sr+3Df7X9BbjSRa2vX4N9Mu+Bq35hPJlQiR1NNGKzAV2D+bHDqhu9DiZlUCMfbTm91aB5Vsc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6455
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



On 2/10/2023 2:01 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Driver calling devl_param_driverinit_value_set() has to hold devlink
> instance lock while doing that. Put an assertion there.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  net/devlink/leftover.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
> index 9f0256c2c323..38cdbc2039dd 100644
> --- a/net/devlink/leftover.c
> +++ b/net/devlink/leftover.c
> @@ -9682,6 +9682,8 @@ void devl_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
>  {
>  	struct devlink_param_item *param_item;
>  
> +	devl_assert_locked(devlink);
> +
>  	param_item = devlink_param_find_by_id(&devlink->params, param_id);
>  	if (WARN_ON(!param_item))
>  		return;
