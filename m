Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26976672ABE
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjARVmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbjARVmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:42:44 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372941CACE
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674078107; x=1705614107;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ml7P7wgDkeunhnfgN66rX20fFg6ve4UCGJAkEM+z1O8=;
  b=ErEZA1Gz3cpb+n2b3UBar7Z4VKGghBdcWenUA9Dz5nH+03ujJpYkdUGD
   lJD8LLHhOZDC1W4c5zHfDOExx2RGjplgK9Az97sLzIb/qv2+SfEgTJU0L
   9LIC2qVbqdhEXqEn5z64CY3uKzyUtn2K6yHaJz1jtHor5AlWyNGwEOi5E
   JEDj6ve0MJlfZqL1Qcd9TtMu3Zh2SMBeT10SHcBbGTM8t0xhFWQTniv3J
   vtJ4ZG2R/k8vrGMO7voSazVZUXP7o/+w/RquKeANQGP4ASoXYcpTqmO7o
   b/R+tsSUcaBVpHzXXE8y6MFXX9bW2tqDFIeGDqlJDHCM6LNP20g5+txQ1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="389606094"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="389606094"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:41:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="767925435"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="767925435"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 18 Jan 2023 13:41:46 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:41:45 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:41:45 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:41:45 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:41:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iN8YTSIkHRmhN6OdKkk15PrNLT0lyBYJZ+5mvx3WSa1E4t7QvRef3EmMA1xnpeAgOkniXmlWy1AJn9vuL/qS31ih8FA45JnDuV8+oH+EMRwV0Uc3n3lZWfwY5nhI5I9Er5S22NmCK8VRiuQ8xEW7pCBEE6fyA5QP3B3MLl2Hl+CVGY71vPpwT31wcOwKWFANDgGUTpR3NsAX4qGGStWAqzt38GQ7f9apz99dgwYA8gmdyERL9DoeSAX/xFSZ2N8bQsVjvvvFEqWlhuwmOi9AyarQXoShd0yVCYiddUb/grU5Shl9LDnK05yRdg2HUmuCEi+pz50SlD3lLth2tlJOsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xgH1UtYs0ncnCkFKnFWpMScnsojHaW/twzQaq8wa9Bk=;
 b=Wqe3ii4seXgq9vwI/3otLWgMqPi2J4UCXGH1XVKw5x7cl0P+PVOsmn5a710S2ItFIxYnMZP00he1G2W8Ea3J6xFZ8zCnLuLxuPkEvNTOi0GfVc3jjPujSDeErt3nkldwHmcRdplF2NZUOR18jFP8fuAGnhocmqBMb/qBtmURBKHk6P5wRmj4ooew5VvIPUZiX5GvXv/E2XgEKjAYV5ow7N8u6l/7AmVuueOV+fcc3zcQ+mYRQ2aruUN+3of1AQwsW5EgT8/tuW3d03j3J8z1xTZU3nibz/tBW4DIosyt7mgApABDP/RiFfB7zLpkUeKnzcyCuOvWwOtcCsKzKtbm/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SN7PR11MB6995.namprd11.prod.outlook.com (2603:10b6:806:2ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 21:41:43 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:41:43 +0000
Message-ID: <0a8045be-ce02-6c3b-ed6f-7170f8b922b0@intel.com>
Date:   Wed, 18 Jan 2023 13:41:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 06/15] net/mlx5e: Fail with messages when params are
 not valid for XSK
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Adham Faris <afaris@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-7-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118183602.124323-7-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0276.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::11) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SN7PR11MB6995:EE_
X-MS-Office365-Filtering-Correlation-Id: 17c4b625-6372-4b39-b726-08daf99cca2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5LTtslj5LaXf4p/gwUp/2/eRWfrEKsHOWeUHaPMJUgAS2KhXBL5tsh1624qCOwn3fyd9mNU2KAdZ0nISe/Nmujge+piukAR0n+K4uTAeO/phyKN2yWZY5W0rIrdziQAdXwH+92xhR16Naxq62SMd0IwfolIIINUaqecPDSACdETvFVayNcfvASJv6exdjrdfzAuyQ+0YqhmT/ra+yy7eTTaOqHxiuNhusMWIE/Z2AsBi5G08AA3XTfLFFgTlqhzcujFXIXrRJzVEz03OAkytGul/Yo0FAUVywaVmGdhr1IWzrDs56dhW296vV3Ihci6vrGYAle9EDhC26dx5IOycX0jbGzOp6ALaFRbXqmZ3t8mwBIu+15xVmBU231xs46VB5K6ck4CeCiJOv0AelOGANxcADwo1cK/3Yt3Jg3HrKlnSFnmrn3BNt82b6Pv35VjQttEHlMYw/3B4TTnTA+wHjzySy2iJlk27oiFvy7R3NkmOYQJyHaZVF0Vhd8nfXQjEt4WYHqalqHURB2fBHeGSHTO4kZLXPU3dO/yxBV9GCNbuAfIVWX0sJ3MJWMwNJQp5POsrzdzItYSq7jnGG8vnsRv5VJ4OKLw5Sxub8Ab5av3CFlH9Ff5naBIVQGFUxLZu2t7yCa2s1QM8tIcrkoaxdYzrO9kwmdM8LxwnKNXvSLf3QvO6OPJ2Ap/9fN6juk1K7fOtrnS13RnVYvlzNSaPVNYX5lHkM9w9f9ClIX9L1GA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199015)(86362001)(31686004)(66556008)(15650500001)(4744005)(66476007)(8936002)(5660300002)(2906002)(82960400001)(31696002)(66946007)(38100700002)(54906003)(53546011)(316002)(110136005)(6506007)(6486002)(36756003)(478600001)(41300700001)(8676002)(4326008)(186003)(83380400001)(26005)(6512007)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXZ6dkVnUVNCMmtBMWtlQWxZSkVuNUtKK29MRzAveWI0YXNndGU5VTlwRjZj?=
 =?utf-8?B?S2pSaG9ubFdiaHJjOVMzbkorK1pxQnNwWVpqNEhlOG9wamZVT0J5ejlLMndz?=
 =?utf-8?B?SHJiK2dsMVVwL0lhck1PMVpGNkhMaDlndjB2UnRXNk1TN0FaQjRFaDYzTlpD?=
 =?utf-8?B?VTFKNnprek5GRzhVWHRzV3F6d0NjMVdvTnRYTjJKMWhocXZrZ1YzTWo5MWFk?=
 =?utf-8?B?cUlMNWpWOHBYcDFQcktOS0FDNXBSdkdoV3NVQ3phbUE5dzJRRUQxSmZRY2kz?=
 =?utf-8?B?aFo4RnczVW1WMHZERTYxeTRiNHl3SFFGRDZqTWZCNEFBeWt3MmFtenFiRnhq?=
 =?utf-8?B?V2VkYXptZS84NVJ6eUFFSFJuTXNYUjRhZk5NaFlOQmo3dXZ5eDFnbTVxc0tF?=
 =?utf-8?B?VFNjQ0F0WVZxZmhBb3lRa2diUWNQU0RZaE5RMmM5Z2NhdEJibzhzeXhDb3NT?=
 =?utf-8?B?NU5iY0MrbWx5NlhlMjI5MUp0M2dudE15OE1WK014T1RWSVBaVENYNFJpOFVE?=
 =?utf-8?B?VXVMeFYvc0NnVEo3TE1VVXF4bzd2ZE5PQUF6b2d3NDVQd2ZlY0VkbjJ5K1RX?=
 =?utf-8?B?Qk1rRjNpRUtkRWtuTFZSWEc0U2lYa3lMK1ZKK2V1Tmd0VVNFcjR2SHFldUQ0?=
 =?utf-8?B?Y3B4Qk5GOSthYzhLVGtpVXI4cUlLc3NKR2pYY05NUjRDTjMzdzY1VmV4NCt3?=
 =?utf-8?B?TlltNVV4Nk5CUHY0QVVrTXJnam1tK0crSEh4VTFkL2JxUWROVlJ1NlNpcWli?=
 =?utf-8?B?TUUxTzdxZlVsWFcvWE5MZlhjNkR1OWMzYUw2M08vL0RUNlJjOWo2NXJuZThT?=
 =?utf-8?B?NklTMHdtRXNKZ1IzT0ZhNlVDVnIybTByNUxtTDNuOTg1QnB3OXBscXp4Tjlx?=
 =?utf-8?B?Q0d6eGRXdjFxU1hqSVdUcUxrYzFGbEx5VWZMVjgwUWpPYVh2Y1cvVWZYLzVX?=
 =?utf-8?B?Y3RXa0RhR0FYdmdyMGZPRVlDSkZYVjF2Z3VqcVVZQ2NCSVQ1OXVONEFidDRF?=
 =?utf-8?B?WG8zaGVKTTVkSURnRWFJSTN1cGJxLzkyODFyTndJdTBtYXJaNVFFVDNoUldB?=
 =?utf-8?B?MTZLWmRMTTB0Zm4zM2prM2JPaVNxelVlVGR6czI5bWJ2VFozMFVXNytMaEdG?=
 =?utf-8?B?SGdhOG13a005Z0pkbnRDR2RVbjVGdHgvcVA4Z0xuTmU4bElSR04wK3ppT21a?=
 =?utf-8?B?aFhHZ1RTR3Rwc2pSYy96TG1keXRQSFgxd1o0QndnenNsNitGaWhBR2p1eHhO?=
 =?utf-8?B?Wm9wOWZFekRVaDRxZ1ZXVWhXSWptQmEyLzMwMTJhSEI3TDRyMkxIeW5odVhV?=
 =?utf-8?B?WGF0dXAvaFV3b1ZTd2MwVE5CNzI0bG9EK2RlMUZhQVNvVzViUEtjU3BoQkxZ?=
 =?utf-8?B?dXhkNW53eEpXdEZ1UzJNd2RibThzYVc5dmZPNzBvbmkxL0xnK2d3QkpWVThH?=
 =?utf-8?B?L2Q1NTVmY3Avem1VU1htazc3bU1aL1R3TnhKS3lhcXpqMVJ2MCsxR3hncURi?=
 =?utf-8?B?NGRuYmc2RFVSNTcxcFNXa2VnMGVBQnpMVEZRV3BOUnlVQVZvSUtGNGl6cGJ5?=
 =?utf-8?B?Z0ZRbXd3Ymx2amNEaE5PL0lWNGMvUkRMM3FaTFUxOGQrRFdKUVFVOS84UGdx?=
 =?utf-8?B?YS9EeUFTdWZMeFdrTGxWUlhpRU5WeDlNcFFrTDRpV1VpT0ZpZXZYVnhMUDlR?=
 =?utf-8?B?clg4ZU9uRUtaYmp6TzB0NXdNU1FOTWg2MGVheXZVcmxWNVBZTSt2V2hrL2Jj?=
 =?utf-8?B?ZFRsQ3hkNjM5dEFHdUtzdUxESm00alIvYlZsT3FpQ0lMNzBTOGpzUmswbkNj?=
 =?utf-8?B?MlFncWVrbEF3Z2RxaHl1MTJ1eVY3ajNJck1DdVJGWkpMYVpMaSttTWcrMTN4?=
 =?utf-8?B?RFoyM2lBYUI3cFVrVHozSENuNHRGMlBQbFRtL1dEWUNxYzNjYVJkdHZ2ajMz?=
 =?utf-8?B?eVJWQkd4WUpwR0Y0Tm1TYXZWbTQvZDh3aVJmRDQ0V3Jkb0lWN3ZwKyt5RUZM?=
 =?utf-8?B?MXVGZWVwT1ZGYUNGdnR4RFhrYkZubk9CODJoVkF6Qk9WNll0YU5VSFVELzhJ?=
 =?utf-8?B?aWg4RU1uQ3JqOHJ3a3ZJcFBMRm4ya29zQ3R2bDl3VUFpTkM1NlppNVllWkZZ?=
 =?utf-8?B?cHR4SENtaEdtRFE2NkdzODBrWVE0dGxJTW54UUtQNDFsbU5zTUN1MFhPWTVV?=
 =?utf-8?B?dkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 17c4b625-6372-4b39-b726-08daf99cca2a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:41:43.0076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BAp0FuW3uWcPAlCn51a9bRJhzYCT/toUOI3rA5dcLK0pUrTg18RLoDLsT4WnYvMPoTnoo2kLi2xXa6uxaEfREBw3bWHuLZ4jIqFR6UXoXhw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6995
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
> From: Adham Faris <afaris@nvidia.com>
> 
> Current XSK prerequisites validation implementation
> (setup.c/mlx5e_validate_xsk_param()) fails silently when xsk
> prerequisites are not fulfilled.
> Add error messages to the kernel log to help the user understand what
> went wrong when params are not valid for XSK.
> 
> Signed-off-by: Adham Faris <afaris@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Makes sense. I'm not familiar with the XSK configuration but I assume we
don't have netlink_ext_ack or similar for error message reporting here.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
