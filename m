Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD565BCCA6
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 15:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiISNMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 09:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiISNMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 09:12:42 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7B41DA6D
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 06:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663593160; x=1695129160;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7F+kMmJ33cel6zHKAkQ7bCV6KQ9v+ByrclRbSTzZrzI=;
  b=UozyqD0T5eA0ON+u/TtzsNV7KQDSbW60Jb7cCMBvZ+CApDfp03qjzMiz
   TmYIc/+/9AxDkj4c0TwKaQBroH4q9/wR6cCr44PcUCdeGH82tzqqIpwq4
   OYq1ftjeRoYaVEUNyfPTUl8mJyqDeepeR6p06rM1FNM4tJ00o+H65/Ohx
   /f0dZUIpdwVhhl/wRWSMv7hE7IMB4eWEy6ei1+2jndE2vRXMf/PQOA0dD
   ga4dDF6KPKzZiGc9dMEN1HvwelPkK5AQmJM34YAnuBaE+ZtjBuVF3NnS/
   SvkZwYlbN6CYSD8LSrnP7W9SR7f08daHaVrOpDuserhB8bOvs+jqYDgBD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="363352864"
X-IronPort-AV: E=Sophos;i="5.93,327,1654585200"; 
   d="scan'208";a="363352864"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 06:12:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,327,1654585200"; 
   d="scan'208";a="947215215"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 19 Sep 2022 06:12:38 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 06:12:38 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 06:12:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 19 Sep 2022 06:12:37 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 19 Sep 2022 06:12:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EV4F2h284tzUhv/GL0bTuvgYysUFmEMsyML5BOOX5cDqTYiv042npy2JhhrxUjzla235wHQoBC2qaq8BOJ70/YCFhuxRAT8UdwPhQ2gymrhfnhAxK9MSV3FDfGPnxawNEil9KXm2W+4FbQMdvaNEzAIwoFYyzuNIVwxQIuOkcizvI7uQuIaarhRx0a5S//9zZZ+6wynjFzlDSwJUys/ete2GSlYZT9wE1jHU02ssGWe1JhZRMSb9F+6PLo/wwQAGk1NsnYWu4gttDAhOz2+Jd68Mt7AO0Pfx8eC5CHE6oW1Cilzr4A6WIHE+YwGBKC5V1Pi9Slbp78TTPfp5lAqoNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b6faLvzh3dPeT5ncYc0m7sKaG7rPWDYxqkEmX+pMHYw=;
 b=Ci5N+NJ1TrvjAc7d4ohIOOaly80fTmXZcgKhc8dbLh0j85uYtUN3OmI+jCzwKuCQ/o0kOj1q8aLVfM2W+mCnEx36qGoNsAO58tuaLnFgzUM+S5gyvy5GgcZQ9rAYshJ6rklZyS8HcaU7+M3YwpjDGLgrsCOpDNMw7o1jPApnXzgfXEiQaa4GoHw9nP9+0g/GakxYg/+ZGH5mRiFb9YQm5FCulZwm2TsG7LlXxSZS8rxQq+xzdQNmfnu5V2rPx79/8e+YoJiRBkrSf0yDKb2SYjgloDZ4IIo0qNvhkRBbSdORagSjcTCzgP78MhExFCIG9Uu2LOLd69MDkPo6NthoEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by PH7PR11MB6793.namprd11.prod.outlook.com (2603:10b6:510:1b7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.17; Mon, 19 Sep
 2022 13:12:35 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9%6]) with mapi id 15.20.5632.021; Mon, 19 Sep 2022
 13:12:34 +0000
Message-ID: <7ce70b9f-23dc-03c9-f83a-4b620cdc8a7d@intel.com>
Date:   Mon, 19 Sep 2022 15:12:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api with
 queues and new parameters
Content-Language: en-US
To:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>
CC:     <alexandr.lobakin@intel.com>, <dchumak@nvidia.com>,
        <maximmi@nvidia.com>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <przemyslaw.kitszel@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
 <20220915134239.1935604-3-michal.wilczynski@intel.com>
 <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
 <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
 <df4cd224-fc1b-dcd0-b7d4-22b80e6c1821@gmail.com>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <df4cd224-fc1b-dcd0-b7d4-22b80e6c1821@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM5PR0502CA0011.eurprd05.prod.outlook.com
 (2603:10a6:203:91::21) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|PH7PR11MB6793:EE_
X-MS-Office365-Filtering-Correlation-Id: 73ff875e-d46c-488f-7839-08da9a409e01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kAo2XpKT8ZNCQBg9JjSK11CUoRyzDDfEdhUF4s3bhQiYaIADsGFmVCzwCijSmDOzEpC/ftwKRVOwrrD2XXQpxP6xsc+CL3YxDYNFBPJXAnvX6aQq+NVjQ775YL8oulArL47Hz/CSWgVO5uni8E/Gll3qRsFKxA5jxakc3q0PHllEiVblGacDuYu2qriXHMb+jNbMB15wgnx+rNNytqWwnhvQYjr3WFXK5cA2jdOICoFiAK9ggwiPHFPfdjkBnNguTJWdISZxW9LsJiphi4AgBKKBs8PdhCS0LVOf0LWzEiEnZ9gfxBOKL3qKD6OB2nqPJS8aod8tAYPCBb5phK+mR9PtCpR5Hk43m4cxnaLbQhUc/iGQdbIbdQ1N3fvEN6GWGk6v257nOf2GgOI0e/jL0nwzDKKKJDY4vCSmlpk5UB8+DXJTMAsUiEx6OLWxWAtI72YtFvB9v+dswDVDQm8CmMjlYn+eZt8+EDbrK6iK/icwacEm6hijVuBblJ75A4csq+PIhBGoLCj3yBUpGt5cbQ+5iai+wp7KcvngSsHy4HHrULhznKFjTRmxzWa17kXA4oSGXN5xEXcVqnXtWK9/V1qXAHyjA8XvoO7RT6s1z8cps4PB6TULGE4r1Xb9ZGzSkT1CfiI20bem4PEng+oJYEcH2SNzvdNFbQ+MxMw1PznOlbLcmMRKtq71HCp6oP3sdYJJ6/jWyuq+Wd1lALaGCU1AW0XLd3WMEfhYbG5WQSLaZhyEKcL5m0KMBV18TJRi5+g3Dp2WUAxry3hui6IXVZNvPnwptRSSHmf2U4fXHBD9HkseSV7+d1s/7BOxFiB8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(2906002)(36756003)(186003)(107886003)(31696002)(2616005)(38100700002)(53546011)(6512007)(6666004)(82960400001)(6506007)(8936002)(83380400001)(8676002)(66476007)(4326008)(66946007)(41300700001)(66556008)(478600001)(26005)(6486002)(966005)(316002)(86362001)(5660300002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUdpZHhmc3FJVzNrRXF3S1NhNmh2Q3J4OVhEZ1hsUjBwQnlncjJUSzd4RjJQ?=
 =?utf-8?B?RGpLY0dnRUpPZG5rZzB2clFHZnQ0NzV0WC9LUDJqcm1DaFNYaEdoZHJ2d203?=
 =?utf-8?B?NnpYYi9Mb3BCSEN6Q0o5di91SkVkcXlSdE1TYkxrQUNwWHhPQ1V5QnVRY3pS?=
 =?utf-8?B?MkZjZTVmaU9xYjZVL2VMcEJpaTFBTU5zUDhOWlFhbE9kMU5PZjhGU2lpZEc0?=
 =?utf-8?B?U0FGRVpmTnVKRlpqK0JUSWRZSk53aWlKYmVhN0FDL3psVmxET2twZUcyOCtn?=
 =?utf-8?B?R3oxTCtaVXM5eHJZcjBnRnQ1dURLZytzWjlKNnNuNXhsMWtwVnpiUzY4emR3?=
 =?utf-8?B?T3l1dDNJblkyWUxMNHhsRTZpQ1NBd1UvTW5NenBOSU8xall4aVdKYjd3Wi8y?=
 =?utf-8?B?ZGNrcVh0amhWV1d5Z1VUdzFFTXU2d0YzWjBXRXJpTW5DR3pMREpEeElZM0tF?=
 =?utf-8?B?MnNuT1JKMHk5aTBJNUp2b3N2Tzlnay9CMWtqY0pJZ0liRkZHNjhBMFhEWW5Y?=
 =?utf-8?B?dXVsRE1oUnNwL2IyUkpLNk9UY282YnR5eE4rRno2a0ozS213c2Q2L2s3Rkk4?=
 =?utf-8?B?ZnJ0MnJUOHF0M1NRNzFtODl3WUIvODk3SkRNUWk4MnJyajZ5L2VyemxMSXMw?=
 =?utf-8?B?UWwxTnQ2SHNjQ0hhQWUxUkxhOFhPZzRtc2tBUGhNc25uMzhGSWlBUWxWV1hT?=
 =?utf-8?B?TWxjTyt3QWFaeWpYMGdwak1RWENNOVV2em1oYUdBVDRwQWhhSmcyUVhUYzJz?=
 =?utf-8?B?ckd0dUZ1WEhDejc2Vk5hVCt3cURHZWRQOG5naXNqYm8wZVQwdDJsWU0vc2Nz?=
 =?utf-8?B?UjMyZzJFdWM5azA0M055SWtEaUtCdDllczB5TXZmYTN1TUd3QUhEYVoraG1t?=
 =?utf-8?B?bWgwdnBOdDVrUHVsdCtoTDg4Q1hEclJSeGNMV05NUkhma3pEY21kY09aTzdh?=
 =?utf-8?B?cVg3aXJCdEpUd2YwTTNxQ2pGd1JETzVaSW5yTnlxNTUyMlErVUM1cDh4VzF0?=
 =?utf-8?B?SHREcWpJbnE1WWppb3phbVNZejVIblBoMU9ZVUh4R3VxNXprK0JZaVN3bjF1?=
 =?utf-8?B?SmVZOWhGKzdVSzhhV01hWXJZV0U5SG9LdWJnampQUi9KZ2N5cHE0bmN1QkhZ?=
 =?utf-8?B?T1EyUVRsVEIrY29yVHJ0djEzQkNIbnp4YUdDYzRJcXNZU2l6UnA2c1VveVlm?=
 =?utf-8?B?R3IwNWZ5elduRDIxUUY3c3RZU2hZSStBQVdxVnBRZlNoVjIyclg4NzFjMTZ6?=
 =?utf-8?B?MGtvbFEzUnEvQUtiaHFReTU2TWdWMERKd0lRQ3hJVUx6NGpKSFZxTWU5UlZj?=
 =?utf-8?B?Q2QyQXRZbzM2dkFJVXo4b0VEbkNsTFFsTEhXRzl4MzhqS3VGcXVSUTdtSUc0?=
 =?utf-8?B?a1M0dzYvaTZod2JHcFk4M1FZTXZ1OW5IN0FkYXczVlk4aDBBcnhEWllaaG9r?=
 =?utf-8?B?RlI2SE9LQzJYdStOUFRDUS9wOHRxajVVQWIzM0pHTWJPZE1ncUxIMkZabjJk?=
 =?utf-8?B?bDZoeGpDSHMwaDI3ZnlJdXIrRGZRak9GT3pMcHRyZWt0S0xHUDVobnlxSVo3?=
 =?utf-8?B?YmRudEtEQ3Jia1FNVE85czk4K1V6NXNENmpEdE5FUlNsVTVXT09jNi9zcGZh?=
 =?utf-8?B?VW5tZUlNOGVhUlFkaUVkTUh1L09LMnVHckx5WFluKzNETU9FcEVDTHFDWHBP?=
 =?utf-8?B?MTFoQWpBRUxKODhiMFNCQ2pXNG1obmcwVWVIbUZBYS90a21XZHBIdUtsTEI5?=
 =?utf-8?B?THdkNDdqZnFrVkpRSHBnVlJFWlFlSkgxSHJHOVh6czhGNnlDQ0JEeVM1czlF?=
 =?utf-8?B?N0kwVFcwY0tKcmo1Z2gvNGlMb3NnVUZpQ2Foa3hyR3ZYbDdZdVd2emVOMHVp?=
 =?utf-8?B?bm1vcTlCYnNwRy9tTElHTStVbXBjQnV5VHJNRG5XQWZ6UlVGNFN0TkVXaVUw?=
 =?utf-8?B?WW5RM3NiQTVaT1FSdlMyaGQrM3VGQjg0UStSc2ZMMzFBaHk2d0RHZ1M1eEdN?=
 =?utf-8?B?NTdBZmtuYytyYzA1M1lIVVlXdEVkZVh5cmtWUG1pMU53SW9GaUluTFFjNDJK?=
 =?utf-8?B?anV6eGN6T3hzSDJSK3EyYlBSOUU2NFpENHloZ3NRT2pMYTl0S3FRaE8reVR0?=
 =?utf-8?B?clVXZmw5cUMxWDFtSkF6cU56aVBTZUt4NGZMSy9LVFNDS2pTZzh2Q0g1U1lY?=
 =?utf-8?B?bmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73ff875e-d46c-488f-7839-08da9a409e01
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 13:12:34.8795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CsQhE3Wqx4GJfu5Ofs0PikKBa1uce/6++bnebXGGXq61ppmMFwCzGB6xCJLy/0YG7MWJOsrL713BwoktFY+UlUWUWAxyvc8fk//kcqdu/Ko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6793
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/15/2022 11:01 PM, Edward Cree wrote:
> On 15/09/2022 19:41, Wilczynski, Michal wrote:
>> Hi,
>> Previously we discussed adding queues to devlink-rate in this thread:
>> https://lore.kernel.org/netdev/20220704114513.2958937-1-michal.wilczynski@intel.com/T/#u
>> In our use case we are trying to find a way to expose hardware Tx scheduler tree that is defined
>> per port to user. Obviously if the tree is defined per physical port, all the scheduling nodes will reside
>> on the same tree.
>>
>> Our customer is trying to send different types of traffic that require different QoS levels on the same
>> VM, but on a different queues. This requires completely different rate setups for that queue - in the
>> implementation that you're mentioning we wouldn't be able to arbitrarily reassign the queue to any node.
> I'm not sure I 100% understand what you're describing, but I get the
>   impression it's maybe a layering violation — the hypervisor should only
>   be responsible for shaping the VM's overall traffic, it should be up to
>   the VM to decide how to distribute that bandwidth between traffic types.

Maybe a switchdev case would be a good parallel here. When you enable 
switchdev, you get port representors on
the host for each VF that is already attached to the VM. Something that 
gives the host power to configure
netdev that it doesn't 'own'. So it seems to me like giving user more 
power to configure things from the host
is acceptable.


> But if it's what your customer needs then presumably there's some reason
>   for it that I'm not seeing.  I'm not a QoS expert by any means — I just
>   get antsy that every time I look at devlink it's gotten bigger and keeps
>   escaping further out of the "device-wide configuration" concept it was
>   originally sold as :(

I understand the concern, and sympathize with the desire to keep things 
small, but this is the least
evil method I've found, that would enable the customer to achieve 
optimal configuration. I've experimented
with tc-htb in the previous thread, but there are multiple problems with 
that approach - I tried to describe them
there.

In my mind this is a device-wide configuration, since the ice driver 
registers each port as a separate pci device.
And each of this devices have their own hardware Tx Scheduler tree 
global to that port. Queues that we're
discussing are actually hardware queues, and are identified by hardware 
assigned txq_id.

The use-case is basically enabling user to fully utilize hardware 
Hierarchical QoS accounting for every queue
in the system. The current kernel interfaces doesn't allow us to do so, 
so we figured that least amount of duplication
would be to teach devlink about queues, and let user configure the 
desired tree using devlink-rate.

>
>> Those queues would still need to share a single parent - their netdev. This wouldn't allow us to fully take
>> advantage of the HQoS and would introduce arbitrary limitations.
> Oh, so you need a hierarchy within which the VF's queues don't form a
>   clade (subtree)?  That sounds like something worth calling out in the
>   commit message as the reason why you've designed it this way.

This is one of possible supported scenarios. Will include this in a 
commit message, thanks for the tip.

>
>> Regarding the documentation,  sure. I just wanted to get all the feedback from the mailing list and arrive at the final
>> solution before writing the docs.
> Fair.  But you might get better feedback on the code if people have the
>   docs to better understand the intent; just a suggestion.

Thanks for the advice :)


BR,
Michał

>
> -ed

