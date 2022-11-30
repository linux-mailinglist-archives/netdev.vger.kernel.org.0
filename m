Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9502463E367
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiK3W0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiK3W0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:26:08 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB16862CF
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669847166; x=1701383166;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dXOvQlk9e9hS8n7iTQ1cJnxcZQ9nCf4wv43/NaAmzbY=;
  b=ZkDTcBB48Xl7IjUu+GK95Psi7Loy++ADApTZ1oszJ2XNYHK/iZgQCEze
   YmPlD0dATrU/SWr9Qc9ufx95BCsLITKeRZB4k7zZ7wWRvPu8cQ3gGgf98
   g2mSHHXlaLfQ7vfbSnIoStSc2I/iG35AHmQtlK4J8xRIMgp71OkFB0ibl
   bZD3dCdqyuyttWQ9tzXHTxcJ5NwGE1OLlNyufSDQBCii8wqT5QU0xbQ1O
   hnhIJzuOHq3NDAtyL7q4N9s/ODSAwIwAKsN6H8m8fPPDE2FFeVlRTXVOD
   cSST22HXfZv89ypVBxniwLFCc4F+pIP67aDtELk0qabtrHDUcyh3wPlfj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="379803944"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="379803944"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 14:26:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="676988707"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="676988707"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 30 Nov 2022 14:26:04 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 14:26:03 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 14:26:03 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 14:26:03 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 14:26:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PySBPbhItL/Fa7VR4XvkEyv6HH0qtfpeC34s8IQFHmTjzBWyEWaaUmmP1NQD5qR+npkPQdR7NaJnLnqMummvQY/hHkC81r8I7xGj1y7jTnMft+i/iYUydbuuySXtCQA47Uiw+A2UX6KGtVs2HRVeSz8AyEyLWb4E+ua3VCDcRCdx90/L1B9KZ0Iou5sgRCPKi+7YSYYD8r9WxTKrk6DRssuNh93FlqNyMSQ3Ze+5B1CKY1fg19SjsQM1OZfdFcDWf233XbaYl09qxxQtqnA0pGkaBTQjtQiyG40Df3vymZQzUUrC1n7xpSEv7TpcK0OBWqxdQGcH4Gd9c6+DurWa5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E4TSuKVTcyWO/xmn4xWaIoizuGsXwztXMzT0pxiAkK4=;
 b=J1/zg5clClGu8X1rcJoCDNDnlXQfXB+8PTpStsgFHc5X3d0GbLyBSFSX+/C2DD6WeazypW7cUTwu53R7Sm6S9R0FdhkvLU802g8pPwhaw7VsTV6lGuyYpeFJoTdGQr2ViSDume75EkdcD/MT63nxoLTARDTlqwwE/o31xL3nxTFC0ylpLb4YDVf6l2vUvW+NqL0ccdT4lio4yHmCCocW2/SKddniV3+yrVO9zx+uzkaoS24/VqIizs+Pn1EFWpJpcAYyGBJJctTUNVCXTf8SeZ2p9+yxOFk0fdMS8a/AXh4epBb2PuAq69eyYaIVvZ9MBOraYw81KdWhvkM/HJK72g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA1PR11MB7110.namprd11.prod.outlook.com (2603:10b6:806:2b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 22:25:59 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 22:25:59 +0000
Message-ID: <f05fd605-98e2-d93d-4415-9357e06e0cd8@intel.com>
Date:   Wed, 30 Nov 2022 14:25:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Yang Yingliang <yangyingliang@huawei.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <jiri@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>
References: <20221122121048.776643-1-yangyingliang@huawei.com>
 <Y3zdaX1I0Y8rdSLn@unreal> <e311b567-8130-15de-8dbb-06878339c523@huawei.com>
 <Y30dPRzO045Od2FA@unreal> <20221122122740.4b10d67d@kernel.org>
 <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com> <Y33OpMvLcAcnJ1oj@unreal>
 <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com> <Y35x9oawn/i+nuV3@shredder>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y35x9oawn/i+nuV3@shredder>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0238.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::33) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA1PR11MB7110:EE_
X-MS-Office365-Filtering-Correlation-Id: bc52e4b2-8972-4e97-6da0-08dad321db1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: peqZTjq3AyAg+pmC9bhSp8D1DdeTxTVMKHgXz5Es1SA/1o3PmX+AatGbNyIWj4YunmTxGpDjXEU7psOEK1A1IANBUiS1sZELOCbTp6KFWk6UvBIq9okxq9X5eW6Olyw5Sqd4S9O6l73s1vj/WweYL4wJ79UnUGb3WO+tlbv4c3f5EuXzm7MKz1oxnvojPLKPkwzOrNsjZkXwXpMOd01hX8jaC/5g8utRPri4suUh92EtUavjUkj/nKYNtZvqD3o1mLSR0llO6RxPcRVOlG2NIFz/j4/Y1b0DE43sxlHAW2wjzS97lbIAK5+LhezC7USxt8VlD/5zokZ8qMAXfLxGiN3XqDHJuKG1pW8AABRrX96ehvkQ3TQW6OfqnywOvhiyF083VAJg3ztxk6uJdotd8EphLoWpvdzelJiosvQLUBTJqzW/yH2YWE3AAPQgg+Bx/tljmCV2zGkVDGWfZBnmmRqicUte0pTs3U/H0q7mdUf9jvNGls2igY6T93FIX0CltQOvBivxzKKOKcIyGFIILdWgM5SROi3Hr/qphJfuplN82oOh0BfTdN0/8tZ8YaxZyie2KzXx/akr6ZNfDOrCxjnOyruVCK8/wxcCL/2I4rcz2mxOPzRa2pZGb8Fnq1Vy15O9vXjfz9V3tqgy9MphvygNsz/Pky+zfTFQ9KQgP58J003JrVEsSh9wAFdwvB2buGPkcax3FstXBNuYymweNk65VX/pcPRXz6tEdcNe298=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(376002)(136003)(346002)(451199015)(86362001)(31696002)(186003)(5660300002)(6512007)(54906003)(36756003)(6486002)(6666004)(6506007)(110136005)(26005)(478600001)(8936002)(2906002)(316002)(66556008)(66946007)(4326008)(41300700001)(66476007)(8676002)(53546011)(2616005)(82960400001)(38100700002)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUxTYTcwZFRCcXBNVDZZcHpkV1MyWUpHRmxjYmdkdnlFWk1Ya3FuUTBackFI?=
 =?utf-8?B?YlVudGFiK0xsWkpTQVEvaGFBOTN4emZ0QlpmR3FNdW55WE12VkpXQVpCOGFN?=
 =?utf-8?B?ZVp1UEs3OFNxOFBSVlZZakh3TGpaNCsvTFovNjlMRTdhd05LZ1ZaZzBic3RJ?=
 =?utf-8?B?NXR2V296NDgrZUdiaTAxWUliZzgrNzBYNHErK1E4dk1aRnZWOFdKK0NWV2dD?=
 =?utf-8?B?WHBSL3FrQjZzTUtqb1J5LzVSUE12TmRBQkthZnZxbStDeGREcUVDaXBrNFMx?=
 =?utf-8?B?VmMyNEdTNlZ6N2xtMm9MUWR5a1NlbHpzZEd2eEx0ZGFQU0dzQnlYRjJwT0F3?=
 =?utf-8?B?bFA5cWIrL2J6MmZmL3Z1VUtNQWZVZXVPbHhtOG82bStGUTRPWW00RmJWOGxz?=
 =?utf-8?B?bHZONnpBVnd1dXkrNU94dGtQV2NGM0s5YjYySGhzbHBqdlVDeDNUSXVPVmsy?=
 =?utf-8?B?empPS2Z5YXc1Wko4bkZoek9PWGZBbHp1bXlIVS9MZEtpbEMxVUprS1ZuMWxp?=
 =?utf-8?B?VUNqeHM0TUVrc1RCV3U2VkozMjFPZlBiNEhZRTJxQS9hUXQ5dFk0dnRtWG0x?=
 =?utf-8?B?RS9yUWN0b3pLdjF3N0dadjFFQWNEMk0zS1BnZjV5c3RCSmd1blBBUSt5aGsz?=
 =?utf-8?B?OFpCd2M0K1FsSjg3c2YxUCtiaTVlaDU2eDQwUXZESEtEVTJGRUtGR0lXNjBz?=
 =?utf-8?B?QXFnM2dGellYdTZTT2hLa3hHMHdZcHNZY0l6WjZDT29BdVhpRy9rdFQybFRY?=
 =?utf-8?B?bVFXNlhNeE9lWWVBZWhIbVdGQUlOb21maU1ZTndlT0NTcnRjOHY4RHZ3RTJl?=
 =?utf-8?B?bjkyVkt4ZW9EaGorS1hMSkNpVko3eTJabGo3NEI1K3RjU1dRWnB6a3dWbEVy?=
 =?utf-8?B?c2RveTVZQkpkbHh5VEFaNCtHQUsrWjNVYUMzSFkyZnQ3cEU3QnpjbTJsVGt5?=
 =?utf-8?B?dEdOVXQ3TWkyaVhiRnZzMHlwQVVVSWJ0b3JzNWhsdnRncGU1SFVtZFozYldv?=
 =?utf-8?B?YjV3dS94VithdXNhbTlzbllBdjlSdGtuelJmRkhVYmFDN3lsRkxWNTA1Ny8z?=
 =?utf-8?B?VTJYWjNxWTRqS3NBWTVJR2d1dXBQQkpuVUdiV1lrSDdUaktPNVY2K0hBNEtT?=
 =?utf-8?B?c0QwUDRZSVZQSnlnZ29SNVVPYldsbC9IaWlMek5KV0gxbDlTNDhROU10QzRC?=
 =?utf-8?B?ZmJNTW5RWGlKeDlyNlpBNzlra3RWajhJbjBiUlcxMmFRcDVWb3c0Y1BqR09B?=
 =?utf-8?B?c29sTC9LLy9BZDg4cGJoMGZsUXNXWFlTaGpUZFlWOWQ1RmFmUXFrNERRQ09k?=
 =?utf-8?B?S2ZuSjBsK0IyMWFYTThmbTY4a1pyenZPTExRL2NWekRaYkZITEVZVmZneFR6?=
 =?utf-8?B?SDB1TFpTaXgvZjMyMklQVVRJOEZhMEZ4aXQvTHQrcmg1bndRRWYrK0xoMHJV?=
 =?utf-8?B?dlJlZTFHNHBVcTY1ZHp5NjJ3N0N4NWlDMWRReXNRQlhkZ3EwRW9ycjZienpj?=
 =?utf-8?B?Yk9wcU8rSEw5b0lvM1Z1V2ZubW9oTEsxRWR6S2g0dUxzTmw5aE1tTUk4VW5w?=
 =?utf-8?B?ZUNsaTQwdUFKa2dxOHllbFhRSHBSTUZxcFhZTHNWeEJUSkNwMDVMdkkzQk1u?=
 =?utf-8?B?Z0ZCV0dqSHlxWjJnMW8yREFlY09Icm9GOG5sZ3JMdWlmakJJQVFCbWlUa2lZ?=
 =?utf-8?B?MHdKTjVHbXQxc2JZaG02VkFTVWEyVlpIK0l0S2ZKcmdLaFN6ei9RbzFJRi9W?=
 =?utf-8?B?STM1eTUrUGV2SmNkK2QzSFpxakFjaXpzakRyUlhxcXBxWjFzRGNYd3dhaHJN?=
 =?utf-8?B?VXJobnpNaHpUUFpneXFVTGl0bkZwWDJOakpjcjVOQTNseDNEOUJlYlhzbjcw?=
 =?utf-8?B?V2lNTDc4ZCtVYjJjdEgvdEkrL1hwWVo2RjM4R1ZxT3QzQXEwNjZlRmpyTUx3?=
 =?utf-8?B?dTN6MU5paE5oQjRSVnErTzRwUmhtM0NZbzBJY3kvVlZWakxWbFl3ZUtvUGFl?=
 =?utf-8?B?ZjlNRFh0cWRZUDFZSDB0QmlJQmtJZjQyajR3T2drL0I0OWd0MkVEOWNCTE0y?=
 =?utf-8?B?Zzd6WjlLVkgxeUJmRVNoaWt3aTZmLzBPaVNtSGJwV3RvQ29rcGZaU2RqZmVF?=
 =?utf-8?B?WVVOenorVXhsWE82R0ovaGF1RkloYWZETkFyQzNvMTRXbS9XVGpqaERyQkJQ?=
 =?utf-8?B?NkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc52e4b2-8972-4e97-6da0-08dad321db1a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 22:25:59.2627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u77ILuS5iSFTDfaqYgMs8sZYXdNB4PiyASDkjKLFOjIJbphBByoK3ACyN9GnGCiZWG5qm8hnRLNgo0/L3Oqg32ZJrqOaDAJ+G2VSUnE6Geo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7110
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



On 11/23/2022 11:18 AM, Ido Schimmel wrote:
> On Wed, Nov 23, 2022 at 04:34:49PM +0800, Yang Yingliang wrote:
>>
>> On 2022/11/23 15:41, Leon Romanovsky wrote:
>>> On Wed, Nov 23, 2022 at 02:40:24PM +0800, Yang Yingliang wrote:
>>>> On 2022/11/23 4:27, Jakub Kicinski wrote:
>>>>> On Tue, 22 Nov 2022 21:04:29 +0200 Leon Romanovsky wrote:
>>>>>>>> Please fix nsim instead of devlink.
>>>>>>> I think if devlink is not registered, it can not be get and used, but there
>>>>>>> is no API for driver to check this, can I introduce a new helper name
>>>>>>> devlink_is_registered() for driver using.
>>>>>> There is no need in such API as driver calls to devlink_register() and
>>>>>> as such it knows when devlink is registered.
>>>>>>
>>>>>> This UAF is nsim specific issue. Real devices have single .probe()
>>>>>> routine with serialized registration flow. None of them will use
>>>>>> devlink_is_registered() call.
>>>>> Agreed, the fix is to move the register call back.
>>>>> Something along the lines of the untested patch below?
>>>>> Yang Yingliang would you be able to turn that into a real patch?
>>>>>
>>>>> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>>>>> index e14686594a71..26602d5fe0a2 100644
>>>>> --- a/drivers/net/netdevsim/dev.c
>>>>> +++ b/drivers/net/netdevsim/dev.c
>>>>> @@ -1566,12 +1566,15 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
>>>>>     	err = devlink_params_register(devlink, nsim_devlink_params,
>>>>>     				      ARRAY_SIZE(nsim_devlink_params));
>>>>>     	if (err)
>>>>> -		goto err_dl_unregister;
>>>>> +		goto err_resource_unregister;
>>>>>     	nsim_devlink_set_params_init_values(nsim_dev, devlink);
>>>>> +	/* here, because params API still expect devlink to be unregistered */
>>>>> +	devl_register(devlink);
>>>>> +
>>>> devlink_set_features() called at last in probe() also needs devlink is not
>>>> registered.
>>>>>     	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
>>>>>     	if (err)
>>>>> -		goto err_params_unregister;
>>>>> +		goto err_dl_unregister;
>>>>>     	err = nsim_dev_traps_init(devlink);
>>>>>     	if (err)
>>>>> @@ -1610,7 +1613,6 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
>>>>>     	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
>>>>>     	devlink_set_features(devlink, DEVLINK_F_RELOAD);
>>>>>     	devl_unlock(devlink);
>>>>> -	devlink_register(devlink);
>>>>>     	return 0;
>>>>>     err_hwstats_exit:
>>>>> @@ -1629,10 +1631,11 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
>>>>>     	nsim_dev_traps_exit(devlink);
>>>>>     err_dummy_region_exit:
>>>>>     	nsim_dev_dummy_region_exit(nsim_dev);
>>>>> -err_params_unregister:
>>>>> +err_dl_unregister:
>>>>> +	devl_unregister(devlink);
>>>> It races with dev_ethtool():
>>>> dev_ethtool
>>>>     devlink_try_get()
>>>>                                   nsim_drv_probe
>>>>                                   devl_lock()
>>>>       devl_lock()
>>>>                                   devlink_unregister()
>>>>                                     devlink_put()
>>>>                                     wait_for_completion() <- the refcount is
>>>> got in dev_ethtool, it causes ABBA deadlock
>>> But all these races are nsim specific ones.
>>> Can you please explain why devlink.[c|h] MUST be changed and nsim can't
>>> be fixed?
>> I used the fix code proposed by Jakub, but it didn't work correctly, so
>> I tried to correct and improve it, and need some devlink helper.
>>
>> Anyway, it is a nsim problem, if we want fix this without touch devlink,
>> I think we can add a 'registered' field in struct nsim_dev, and it can be
>> checked in nsim_get_devlink_port() like this:
> 
> I read the discussion and it's not clear to me why this is a netdevsim
> specific problem. The fundamental problem seems to be that it is
> possible to hold a reference on a devlink instance before it's
> registered and that devlink_free() will free the instance regardless of
> its current reference count because it expects devlink_unregister() to
> block. In this case, the instance was never registered, so
> devlink_unregister() is not called.
> 

Shouldn't devlink_free never free until after all references drop? 
That's how typical reference count works. I guess its just assuming that 
unregister will prevent this but....

> ethtool was able to get a reference on the devlink instance before it
> was registered because netdevsim registers its netdevs before
> registering its devlink instance. However, netdevsim is not the only one
> doing this: funeth, ice, prestera, mlx4, mlxsw, nfp and potentially
> others do the same thing.
> 

We used to register devlink before netdev, but this was changed at some 
point because we wanted to register it late after things had been setup.

> When you think about it, it's strange that it's even possible for
> ethtool to reach the driver when the netdev used in the request is long
> gone, but it's not holding a reference on the netdev (it's holding a
> reference on the devlink instance instead) and
> devlink_compat_running_version() is called without RTNL.

Yea that seems weird. I would expect ethtool to get to devlink via 
netdev? (especially now with the way we changed netdev to hold the devlink?)

Hmm.
