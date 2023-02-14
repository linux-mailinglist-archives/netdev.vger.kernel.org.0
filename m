Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D737A6968CB
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjBNQHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBNQHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:07:41 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFCB1BED;
        Tue, 14 Feb 2023 08:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676390854; x=1707926854;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wEel5lgQxeXDyZH170Z2kDOcezWIFO80bn7COGg4n7Y=;
  b=ZapZ1nRBuyqDpSMLMFXuzkUJMEuVnf0P/HsYF5xBudksQHlAT3ukHry1
   8jNQj3OtNUSP1C2b5Jhh77yFerU5s94A70yPkfPKeh+PKmdFlPlvo/RYb
   kyjhKE2tusPPvfo6JcIV+DCFs9gStsTNnGD4pOaqNwNshwA6PZ4jvRCHb
   9EbXdoAZN0+kuGZFzP2hWc+1d/6Ia5oPeXDCvCWoCs8tzq3S5vzMTZ8AH
   HorHxT+6fE8v8cfXXGDvjUMtktUCpBD1D8IkjdCc3LCPQw6VXCb0ILwMo
   abA9PWrhAOY4scALhHg2aoQU6PqdpS9auTNgi5km3U1n6tDiX2B2WFIP8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="319224864"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="319224864"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 08:05:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="662581209"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="662581209"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 14 Feb 2023 08:05:48 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 08:05:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 08:05:47 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 08:05:47 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 08:05:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGWgHaOfwDdkuUFIQiV8a45gjTGarQGhlFVIo332iCgU47kg4JfSStdnRaAELBMymG27fHZrvyqAItmKsv8VDWUNUbvunxJjhUmvvp/xdTMYyY7dfZ3ycTfdjQwpBEOkWw46aML+cTPqgK7YbBFg1u7DPZAiTsgg+T85G3Lh6+y15UJ+YtUsw9fwpklML35/rZ7Cx/eCQHoktKcs7X6NYk9u4QYANqVmP535eq+Q8Vz3W60ovt6rjG/GfEV3g9QTou3wk+w2Ad+/F/BnObduEcrJ7NpqyLSVd1BxZSOaYXq4HvfPkh1rPH+6S1qi3GKgmrl2kMrcs3rxlnxL5tm0bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oc2STVzheXdPMtiCIW5e1fVaBmZQh60Sy7pQcJkfRJ4=;
 b=NzCHEO/7f/7S+6+HB1foiMrR+zqbZ3QPUVJ+FHcA9KWyQ9dPWZ9iO86yQg66XHLtFC6S769luo+1V5n8barV9xc0YFONyRhaleMJoaKsw+HfS1GGNiwnjPjtBYTtaiwEhIpYDzaIHM9KRZ2jiaFsks/MoSycEhRn3daI8YwQ/dMeQz8i7SIZEe8UeqozfsVsbnGdqpCh3DweB//I8zT3Jzp8M5BmtkFfzju01zErwI3VrxQx0dHHfwjvCKqfaCTneJfj7E3eWCwPuShA3H/Yrn52zjQpswW5VDF4xc8ELhXTDCHxlBA/Qbnjh/bIg+5GHHS7huLL04bO7AViRkLTug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB5960.namprd11.prod.outlook.com (2603:10b6:510:1e3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 16:05:42 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 16:05:42 +0000
Message-ID: <e62296a6-7016-c98a-8419-69428f65d9cc@intel.com>
Date:   Tue, 14 Feb 2023 17:04:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 bpf] bpf, test_run: fix &xdp_frame misplacement for
 LIVE_FRAMES
Content-Language: en-US
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230213142747.3225479-1-alexandr.lobakin@intel.com>
 <8fffeae7-06a7-158e-e494-c17f4fdc689f@iogearbox.net>
 <6823f918-7b6c-7349-abb7-7bfb5c7600c2@intel.com>
In-Reply-To: <6823f918-7b6c-7349-abb7-7bfb5c7600c2@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::15) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: 07cd7d0c-a92e-443a-25fc-08db0ea552c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5NcaJ8GLmX6dYjST6ypZ2x7QAB41RbmEXe7dISSCeJP5IgoRAXdWt7WD3JmiE61GlzJk5Oxix1nbprbfNmfvfFV/rFfyPTNJWGtvUGzTJ8vA57k2S657HfOUDqSb8YfzJXdhk6GI+8YNITgG32A88O33S4FBAeil1dL2kFcsgcdDgu97reRE+GykkO9tKkgVhTJO4riK82/8mMQ2O0/Jh+TDlKM/kbkFAlSzTFMVfuZIPiCmT7DOi9Zj04/D6IW9RBJtJp9T5XDWNhBLfB7a6mNsy382UbXuzErYuaBCgzGa3u0Fli3/4eOmjsmUrH5A3jDPWUHk2UGkIMyg7qteuMUv2hTVQqGU60DS2n/BSxPcEHUeC5in407x9zIsFEsCGxT+WCgoUEE7YpvqYX6Hp6Hiywf4PzbLZZYegl7cC9Jusgq3LjcIfoH752q1F2PQUlPkASQUvq2PkxCq8d7mL4I/gF0702pSZv95GCh/KsKpL97oRAt1ShQJUMcPqrsEu0ybmJhwyY5hyutKVOG2JVaUaxqCHnfme6TFvycy8N9CtK9Ylb6Etjd8StF764PHI+9hkUAzI9+P5/VOoKK9xV6Rdorbz95Tc7jD16ybgmlqnqZTxs9R2hcZG9dgJ0Ru55shdmFMKWA5NqIt4NyG/Pq948zg7ir06GJLLivCjCI3Xfd3oEQeT5ToiFU3evZExuytWgGyIUGQzcOlkjlZ8qqH1jj1RIfdyVuNkoNXTPw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199018)(31686004)(2906002)(86362001)(6512007)(186003)(38100700002)(26005)(53546011)(7416002)(6506007)(2616005)(5660300002)(82960400001)(8936002)(478600001)(6666004)(41300700001)(6486002)(31696002)(316002)(966005)(66556008)(4326008)(66476007)(110136005)(83380400001)(54906003)(66946007)(8676002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHN6UENhZlVKbDZGNmtUNkN6QnN0SUk0ZHJkUmVNdTlzRzJ3T0Q1SW9XejBB?=
 =?utf-8?B?cTVkWFN4bnhVNjYxYzNaQXBTMVRnSktSaGZHTmRUbi9PYVZUKytBSi8rZndP?=
 =?utf-8?B?azRsSzRUS01NeEVoenhoZTZSQ3BsMzBhWlpVNUdaOUh2YlBpYm0xdXNIM0Mw?=
 =?utf-8?B?ZzdtelJZVXcrcFlBN002c1BDT3NTMTdEQndiM1dMTmp1WU0zU3d4Sm0xK2cw?=
 =?utf-8?B?bWwvQTltMVVZeFdweGtpM1p0MkRpY1BrY1FIVGZtNC81SjYrNGdQaG9jd241?=
 =?utf-8?B?RFV3cGdUN0V1cWN5Tlc5ZEF1SFZtQ0VkRWpBY29XYmtKeTlOWXlYbEZlZU0z?=
 =?utf-8?B?alpmektwZCtIS0xoQVJSYVZ6MnN2WDkrU2hDSlNkbktVdXFYdmZWSDRGam1X?=
 =?utf-8?B?clVSMEc1WTBFTE1LTEhub3NMZ2p0RVlEMDJRblg4WE5ac0M1NlBlT0UzZWJj?=
 =?utf-8?B?THRtOWpXOWVYckRTM2NTaGxWUncxQ0EzZDQwTERUVG9PZ3ZlWWt6ZGtMdjAy?=
 =?utf-8?B?aVBQSkhmdFE5SnNDcHBzdjRSSE1NMHVScjIrRDdhQlBlczZuUTZUWEVBY1VK?=
 =?utf-8?B?bjd3amlXT2l4T1A5eUxGQzNBeHFMd2xQcU96b1lBc0MzeDUwbHBHQ1RyWElm?=
 =?utf-8?B?aVlUMlFFdDZUWUc1NEFlZ0lUSlI3Rmx3YVpHN3VwY3cva1RSWFkwU0xHSHBs?=
 =?utf-8?B?WlJ4cU1YaTVLUnM0N3YwNUJxcDZFM0JidE5qaW9HM2kzS3lSeVV4SVovT3Jo?=
 =?utf-8?B?WkprM1RPdWpaR0dQb3VudTBYV3ZjZUR6UFpRUlNPWEhPUEtuMzZHQ1oxSjNa?=
 =?utf-8?B?Nlk1dVFOQjVqMk5uOWtoc2swdExzVVE2dGdYUE1wMVUzanN6cVBJL25mMlFj?=
 =?utf-8?B?UW8xM3pGS3MvM2xXT3B5cVpzVVJJSmJjSGRvV0phMEJPS3RuS25YalVWVWZB?=
 =?utf-8?B?WjQyZ2VhL1JQSjdWRHZUOHJTRlExWlpSKy96ZTVZdU9zMmNxOHRYY2tYbW1T?=
 =?utf-8?B?cjF3RjBLUllZRUN1NWFzNU1LQ3k1d2pud3lob2U5Ujh3MXd2TzFUMzl0N2x1?=
 =?utf-8?B?RmlnekRCZ01yQ0l4Vm92aGRuTmoveEN0Z2JVSE1KN3hlTGdkLysrTGVqTkZF?=
 =?utf-8?B?b1NFeEFUclhqWU5HRjFGalBmM3FBVEVkc0pIbkIwWG5kcElhMjA3RG5EOHow?=
 =?utf-8?B?YXVCbXBqVm16NkFJbjFtOHRkY2IwMnEvcTJMSnRNTDcyc3ArR251M05kNlpN?=
 =?utf-8?B?enlNK0NGZXpGbUpTSXppd1lDRExIN29vOWdsZDJiaWZSOVJkbUJPN1JqNVU5?=
 =?utf-8?B?Ykc3ZkI2dStmTitVdGhEWE1zcExyYWY4a3BDVzdXQ3FmMEJzRE1oRmRVdnd5?=
 =?utf-8?B?Qkpzb0UyTENadCtob29wd211MFVHbTVLZlB6U3pob04wZnlqWmJqb2t1anIy?=
 =?utf-8?B?eGw4U3kwSGMxR2dadjJLcHRHcE9xQVo3bXNWK0xUeGFBeVRiNXRwTzIydlJE?=
 =?utf-8?B?dm1zbjlBMGYrMjlhL0F5b1gvVFJVcU5OZkExL3Zmam1jdXh2TWtxb2hISk5v?=
 =?utf-8?B?SDEyQU5VM3lkQmFQeittV0cvaFp1OTdIcFRYbW54QlkzVDMwcnlaNSt5NkRM?=
 =?utf-8?B?Vk9ZTU1pWkdkckUzWUMwTGpTVlRES0gwYVJUVmtyMlR4VGhKVlNHTGVRcEJT?=
 =?utf-8?B?Y2QrR3U5WGdHd0pmZjJCUnYrc0FscUhqbmttdkJ2NWlYc2QvM1IzRVNDTFd3?=
 =?utf-8?B?UGFKTS9VNXZhK0Z3ZEtVbDBiZnFKY3dFL2UydnRSejFkSjhoTFErQXp0R0dt?=
 =?utf-8?B?SlVlaWNzcFFFMUdvYkhTZ0p6eks3NGhzMDJ2UUd5aVpRSE9jWWh6SFZYNGpX?=
 =?utf-8?B?TEhzakQrQXlBaFZkZjRaR1lwK3d0c2tZMmRwM0c4dk1ud1BneE40bjVSWVBB?=
 =?utf-8?B?QThpVW1iS0ptV0NVTEk5S3h3NnF5RWpvaVVlcyszY011L09ObEtSc3dSWVk2?=
 =?utf-8?B?K3AvTnVtL1lvTnlyR2xOaWprZWJ3Z05tbWFkU0xTVEdtbXEzVGxrMlNBNFds?=
 =?utf-8?B?enRnQ1hDL2YvUmVUOHlpNFlPbnorbTFLSXdBbGF6cG1EYnYwZGNld0JVS1Vs?=
 =?utf-8?B?WmJTRVF3blF1V09hUllmdGNvWjlPRUJpR29jb0pBdFEwWEMyU0p2eVJlK2c4?=
 =?utf-8?B?WEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 07cd7d0c-a92e-443a-25fc-08db0ea552c3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:05:42.6626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEIE74CwmYG5YzUiZ/8yK9a7IBtxNJhYs5LJb0YiqS2RE1qKRry5vtzYq0ERH0LzQmWr/E95MKu3CU5T/PZMszf+Zj73ddOxAK05LMaHbAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5960
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>
Date: Tue, 14 Feb 2023 16:39:25 +0100

> From: Daniel Borkmann <daniel@iogearbox.net>
> Date: Tue, 14 Feb 2023 16:24:10 +0100
> 
>> On 2/13/23 3:27 PM, Alexander Lobakin wrote:

[...]

>>> Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in
>>> BPF_PROG_RUN")
>>> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>>
>> Could you double check BPF CI? Looks like a number of XDP related tests
>> are failing on your patch which I'm not seeing on other patches where runs
>> are green, for example test_progs on several archs report the below:
>>
>> https://github.com/kernel-patches/bpf/actions/runs/4164593416/jobs/7207290499
>>
>>   [...]
>>   test_xdp_do_redirect:PASS:prog_run 0 nsec
>>   test_xdp_do_redirect:PASS:pkt_count_xdp 0 nsec
>>   test_xdp_do_redirect:PASS:pkt_count_zero 0 nsec
>>   test_xdp_do_redirect:PASS:pkt_count_tc 0 nsec
>>   test_max_pkt_size:PASS:prog_run_max_size 0 nsec
>>   test_max_pkt_size:FAIL:prog_run_too_big unexpected prog_run_too_big:
>> actual -28 != expected -22
>>   close_netns:PASS:setns 0 nsec
>>   #275     xdp_do_redirect:FAIL
>>   Summary: 273/1581 PASSED, 21 SKIPPED, 2 FAILED
> Ah I see. xdp_do_redirect.c test defines:
> 
> /* The maximum permissible size is: PAGE_SIZE -
>  * sizeof(struct xdp_page_head) - sizeof(struct skb_shared_info) -
>  * XDP_PACKET_HEADROOM = 3368 bytes
>  */
> #define MAX_PKT_SIZE 3368
> 
> This needs to be updated as it now became bigger. The test checks that
> this size passes and size + 1 fails, but now it doesn't.
> Will send v3 in a couple minutes.

Problem :s

This 3368/3408 assumes %L1_CACHE_BYTES is 64 and we're running on a
64-bit arch. For 32 bits the value will be bigger, also for cachelines
bigger than 64 it will be smaller (skb_shared_info has to be aligned).
Given that selftests are generic / arch-independent, how to approach
this? I added a static_assert() to test_run.c to make sure this value
is in sync to not run into the same problem in future, but then realized
it will fail on a number of architectures.

My first thought was to hardcode the worst-case value (64 bit, cacheline
is 128) in test_run.c for every architecture, but there might be more
elegant ways.

> 
> Thanks,
> Olek
Thanks,
Olek
