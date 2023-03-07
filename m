Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EFD6AE8D8
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 18:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjCGRTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 12:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjCGRSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 12:18:33 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DE2A254;
        Tue,  7 Mar 2023 09:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678209256; x=1709745256;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nwpBGzTI8muQFk0kLLm/6W70UnZT8o8TBspbnIFkgyA=;
  b=YCI6HKQCx15XViJWzICvolyi8SQcZAoFRoHEYKobm8qgvvBjzYPdRTs3
   dqSln5Tl6FTsVh0YZM5dhjIMINrTXfFMnbEC5Ubrsuh32mM73beShuJd0
   4RgvIL0rfURX8hdnFCx1PsZuZ4ab8U5YKF/ao0nyY/8bzkbjXEDEYt3gm
   aQuTqP4Dr3mUQZcAJUG/Eb2CJwYxsU6kY53nN/ADP/UUl/llVNrkdRQCz
   SULYEqFsiI28kSyrkUD3NbgL0kU/2cQx6TkBBLyuPdeS6AZe24Mz6YxZr
   QS5YkDETQ6mkReItGx5eElIwYbFg7UIFx29LtAmE2kbV5Pma7Zr8GB6Ja
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="333381068"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="333381068"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 09:14:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="669972100"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="669972100"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 07 Mar 2023 09:14:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 09:14:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 09:14:08 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 09:14:08 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 09:14:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gn1aP3SaSMBhf779F+FscpniVI8FnJivrj18dWwvg9az9lJdyGgfN8HPG5OZ3GipyPBE/WqXro909cJGqkBW6Xc8lkpvCSJdUZYxsjshAo7qNRUWAaoEfm+QnIbMWXV7Jl/r3qAFy55JGb6fN6LjfATfKHms0gVkgtzC1aYnGYoJ0xyH8ENg7s799mscqsVnyR9Zswa21BgxgyopxgJkBj0RydggDv5a991XSLMvm1ymUvJ1A+zjvqioLn25Wc6tpTCXpzLfKNknOioYD4O+53B+bbpN0lRP4my46EaK0zPUPW0lvK5xRUQb8vryVrKvJXoAPY/fuZ5oaDadBGFnjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0QjQGwpi0N3OGUFBZrcJzxKYNAHDfzsyKgsb4MES3TU=;
 b=bYKM/RS9mB1zTZXsZ9aZlSRvMewHpL0qeZpCgzz36tqPNEWfLhabx8yP2zf8rMYcjB6mc1TjQbqWdIeruYhrZR2qnBBL5qM/wddm1ojn1DjQf4ZdHGrMxlZN3IF9t6nz+50rhhU7pxMlKQUu2TwGnJqg+Q8oqVi4sB3BeIQHGdDR8XC5tyuJJMKSBMuLA5RSQUVVzbcONNiSvPDNwPuy+OTFle+XdW21kjw4XaT4q8ikGm9pWEXLUjTULv2QnBwVeGdUXl+0q/Br8uV0MCVPdI8cbRqqADUqzITiK0em60jrwfxRgm9l4uWlZ0f97361cKClVL/bIFs0bLNUspNuNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MW4PR11MB6888.namprd11.prod.outlook.com (2603:10b6:303:22d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 17:14:06 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 17:14:06 +0000
Message-ID: <8a90dca3-af66-5348-72b9-ac49610f22ce@intel.com>
Date:   Tue, 7 Mar 2023 18:13:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2] qede: remove linux/version.h and linux/compiler.h
Content-Language: en-US
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
CC:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <kernel@collabora.com>,
        <kernel-janitors@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230303185351.2825900-1-usama.anjum@collabora.com>
 <20230303155436.213ee2c0@kernel.org>
 <df8a446a-e8a9-3b3d-fd0f-791f0d01a0c9@collabora.com>
 <ZAdoivY94Y5dfOa4@corigine.com>
 <1107bc10-9b14-98f4-3e47-f87188453ce7@collabora.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <1107bc10-9b14-98f4-3e47-f87188453ce7@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0066.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::17) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MW4PR11MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: 4efdddc1-5e07-4cb7-540a-08db1f2f5b27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Bn5eDymd+uckx6YZLK2hGHRmjA4rjrzPCcsalOUMONHU4w0qEM/PK3l4Kd21zLuUYMfqz2hIGi3QuMT1E+HMvCCfLB3WWML+TkeWjryL1aEAV+1WvYrP0QLDrdSjBq1pZsDvIXs/s2REtUPn41616pr3NH5KyF3I8ftnFbBpCHJHvbbad4H3a0Ig6UTB643UWlBzNzyK8KCBvTRat00bcUX13u01vn0QQgRKXfPJK55Hm+VgdcTNde7hzOAOfjRLr3IStH/2eRJWqOIk4MYtuX9aAXieQfkl0U8AZbuQ6lYauJmV6K/tR071aSMl8a20KgIs56iPYicMHfzjfwvgAGUwbskmXGsnIy0Rhyj79JiYTaXDh1q50SeAdDZUFObutzuMOFN5jaQdhCaEpdQx4WKdtVvSPvEJReeBAiQgGvQThYO7tiOjNaGn/SmEuDzivsNj2KpH4kf0ejrs58rpOKg5AyUzMlvGIvbOYo85eLqY9pHTzQlZ6AwFcBPXPEu2j/Hn+omdqdXqp0bHSsJSf6tKxVG4qrEe6oWK92F7zVbHPbQYBXxUjaethyDInZ6ptTmDCu6AqeWx1MJ8hufga/DnBd9WT6FSZyf72VskPiOU/RnEuusR/VySqTBfauV8pOEOeHMfjef+e5WVUP7aDGRoBgjzSJqP/qvty5w1HjaQH+kli5IOo64NcHpMIbj/jsQjI2I3Mxufl/mIo1F1yaxXpZRbH2rsRnUSaVRhpM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(376002)(39860400002)(366004)(346002)(451199018)(41300700001)(66946007)(6512007)(2616005)(53546011)(83380400001)(6506007)(26005)(186003)(82960400001)(38100700002)(316002)(54906003)(478600001)(31696002)(8676002)(66556008)(4326008)(6486002)(6916009)(66476007)(36756003)(6666004)(86362001)(966005)(2906002)(31686004)(7416002)(5660300002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STRVcmNsdGJlU3NIOTl5b1N1WEwvL1dwR3JqbUJ4dTFnWHJGMnhvdEppd0tn?=
 =?utf-8?B?dEZ1RGxhclNONVdMcnAwT1Vvc1E2RENqMms2WENIcmF3QXZnNjh5NGVGeGlU?=
 =?utf-8?B?Wm05NzFvZHE1aHV3bjg5S1dVUDBRUlBja3JqNzZQd3ArSE5zVXFHNEt1d05Z?=
 =?utf-8?B?WkZsY3ErUnZHNFFBY3l2Z0VXWkRJb3pVR1ZhR21GK2kxUUV1bm0xMU5UVjRS?=
 =?utf-8?B?WEgvVHlHd0VSVlpLSHNjQW1uVkpMSmhqNzRwSnV3Yy9xeWVuUE84RjdMbFhO?=
 =?utf-8?B?ZGdrZ2dueGdDcmx5MzNQNzJ2clgwRG1kNllIdGdHbWM5SjEzd1dMWHBDaUhu?=
 =?utf-8?B?bnpQWCtxK3JRZG55TzNMc0poNE5wMEtiMVFBZE1JQ015RVhCaUFQbnNjUmpX?=
 =?utf-8?B?eVVQQkxoNWRSeEtuNjRJUWVKUWJ2VDBSOWhVb25hZEFHUWFmUmJyd2o0cGJF?=
 =?utf-8?B?eGZCVW1lUUdCcjl1VFZVVkZyZVZZMHBlbHN4YURuZlJLUTgxSEx6L0d0aytB?=
 =?utf-8?B?a28wMjN0RHowSXhXbE9aWnMvdVRuWDhrT0lGTzByVGFNQXRlNHR2U280Qi9U?=
 =?utf-8?B?V20vN3lCUXdTZWFmSmxCeHZPYUI2aGZzek9lOU5jZC9MSngvMk1iTk5XamFN?=
 =?utf-8?B?eE5HTmlyYmpadWQ5RDR0aVRqNmthTndHQVpYa1BnSmVULzA5YW1ldloxZ0V5?=
 =?utf-8?B?bmlpWFY1KzBjU0dOSk1BamNPRXZ3UEp1RnIzNjVUYldvYnRIVENaUXlkbHNL?=
 =?utf-8?B?Mk1XME9MTG1tZHBadEs0QU5yUkxPQXdrS0R5SEdld0VnQmZldlEvcmFvVGsr?=
 =?utf-8?B?Y25LZW5DZVlnVktZc1RjNlFnQmJVNmRLOHVSdFBPcS9Ed1lTUEIrZUNHSmtM?=
 =?utf-8?B?N3E2WWhxdFphRjRhdHFRVU1HS3pxS0FHMGIySFNNYjJmQzQ4cVNQaUdmclpH?=
 =?utf-8?B?TnRyNFNLb3A5M2dBaEtIUGFvSkZ1aEZoUnNMQ1YvVTIxYVNoaGZLaDFDNWhY?=
 =?utf-8?B?RkdVZ0VlUTd6bjFOTjhnUGdmcHVsaWFxVUVSYTJhV0xwc2cwNWQxVnc3Rk0x?=
 =?utf-8?B?cnJOUkkrZVVlNVRWSm04bU80aUx4RzBsWnB2ZTV4Y3NFQmVhNnM3ak9veTFY?=
 =?utf-8?B?c2dOTUVxVXIzcHlaL0ExNWxHM0FyWFZIR0hyNkwzT3NVSHVQdTd2UVNaSkJG?=
 =?utf-8?B?dmRvQ1laTjRSOHh3MVgvdWZySkhMQjZyUFhaNWtjcGpmcCtxWGRpMUlsei85?=
 =?utf-8?B?dTRxa2dld1UrUzMwaGVGdEl2OUl3MFJ6ZWR5eE9OYmlUL3VYZDZ1UUF4WHIw?=
 =?utf-8?B?RHE5Yy9Ic3dhbkp5Q2RUYzl6TURLK2NkVXFhTGJEMkdYNnFxcVEyaGlRaEJ4?=
 =?utf-8?B?S012SlozNmdYMGlyd3QraVJwTmUwMUVDdG9mbGxxV0VsYkJETzRvSUxHQlpR?=
 =?utf-8?B?SXdUYmdGK0MvS2hqckdsbm84bjVpVCt0WTl4NkZienFCL1lOVi9RcWZHbXNw?=
 =?utf-8?B?MlFaaDVGcnB4ckdPOVRyeGVCRVdCeXlaTGFjK2Rwak80MkJmTFY1Y3lLTldk?=
 =?utf-8?B?dmFLa09PWlZPaW5ydUN5VkxLMW5CNlZFZkZxbWlzenJRVllxRk1tU0JrNWto?=
 =?utf-8?B?T1VCaTkwUzNsQ3V1eVIyVm1FOGRXK1Z1NytEdmlSdnRjV0ZacXBob0tFUkU5?=
 =?utf-8?B?YStnY3pPTVdoOVFBUVRQd0p3NWtMSWQxM2hsc3lmWU41MHMvTUtnRTZuKzRv?=
 =?utf-8?B?ek5xZzNEQnBRSXpGRHRiR1V2MVhrR3NhM3czVklwc25VbDdaV1ZIeVhtNHpW?=
 =?utf-8?B?NzRkZWhoNDFxTWpuc2g0alNRN1ZzWmJneml3cnd2N2lzTXVjeWR3THZFN3Rm?=
 =?utf-8?B?UVQ5ZXRWakx2a3F3NjJJczB2VFR4eFF2NG9qQzB0TUg0TVl2ZlJaVG1NNWQv?=
 =?utf-8?B?WU5GaDc2bEExSWhiMXAyWlJIYUVNL1dvMVZFNEdzY1BCOUN2SnpjQStKRk5a?=
 =?utf-8?B?R1ZmeTRud04zckp4NkVNYkZXbXY2aGFVSWlUWktuZ0NNM1JlSS9YdUpzOWRG?=
 =?utf-8?B?ZXpYaGdRNW9oMitlTDgrZkRBNXRaRGplZWw5blRnRS8yUkZPOUNRSmNOYnFU?=
 =?utf-8?B?a3FwOGNXMUN4bDNLeThldXdpdEtMMHEybVpFVkp6TG5WRnhhcnl4ZUExQ2Yw?=
 =?utf-8?Q?zq7rY9OA0BYOJRaux2DVBD0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4efdddc1-5e07-4cb7-540a-08db1f2f5b27
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 17:14:06.3472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pkvy3D+UK5jYlkzdibn2kwNbpiqy6qGcc7Rd9rJoQNoUuMmF8T5ZBcuXL6Stk/ilZ7yo1RKdA7+hJNLM9xSoNcnXf581Vfc6QegTATXd2c0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6888
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Date: Tue, 7 Mar 2023 21:53:48 +0500

> On 3/7/23 9:38 PM, Simon Horman wrote:
>> On Tue, Mar 07, 2023 at 06:39:20PM +0500, Muhammad Usama Anjum wrote:
>>> On 3/4/23 4:54 AM, Jakub Kicinski wrote:
>>>> On Fri,  3 Mar 2023 23:53:50 +0500 Muhammad Usama Anjum wrote:
>>>>> make versioncheck reports the following:
>>>>> ./drivers/net/ethernet/qlogic/qede/qede.h: 10 linux/version.h not needed.
>>>>> ./drivers/net/ethernet/qlogic/qede/qede_ethtool.c: 7 linux/version.h not needed.
>>>>>
>>>>> So remove linux/version.h from both of these files. Also remove
>>>>> linux/compiler.h while at it as it is also not being used.
>>>>>
>>>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
>>>>
>>>> # Form letter - net-next is closed
>>>>
>>>> The merge window for v6.3 has begun and therefore net-next is closed
>>>> for new drivers, features, code refactoring and optimizations.
>>>> We are currently accepting bug fixes only.
>>>>
>>>> Please repost when net-next reopens after Mar 6th.
>>> It is Mar 7th. Please review.
>>
>> I think that the way it works is that you need to repost the patch.
>> Probably with REPOST in the subject if it is unchanged:Sorry, I didn't know. I'll repost it.
> 
>>
>> Subject: [PATCH net-next repost v2] ...
>>
>> Or bumped to v3 if there are changes.
>>
>> Subject: [PATCH net-next v3] ...
>>
>> Also, as per the examples above, the target tree, in this case
>> 'net-next' should be included in the subject.
> I don't know much about net tree and its location. This is why people use

Here[0].

> linux-next for sending patches. I'm not sure about the networking sub

No, people use the corresponding mailing lists to send and repositories
to base their patches on.

> system. Would it be accepted if I send it against linux-next as in [PATCH
> linux-next repost v2]?

No. Please use net-next I provided above. Your subject prefix will be

[PATCH net-next v3]

since you'll have changes (specifying the correct tree).
You can ask git-format-patch to generate it automatically via

`git format-patch --subject-prefix='PATCH net-next' -v3 ...`

> 
> 

One more note: I was participating in reviewing/discussing your first
patch version, so please add all the participants to --cc when you send
next versions. For this particular patch it means Jakub, Simon and me
must be specified explicitly in --cc when you send v3.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/

Thanks,
Olek
