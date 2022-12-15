Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F1064E14B
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 19:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiLOSuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 13:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiLOSuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 13:50:18 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B339260B
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 10:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671130217; x=1702666217;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ipG9a3+L5jY7gZ4YNtZHqkN22rkCv+8tyCFKJ+9Pxwo=;
  b=lVwCnlLCwY3Naa7ZNuAAO12NsrS3+J8QLNAInWw4cqq7iwzF0RyGpBNA
   HbwBAJ9b56MQ5ZOVJ8orT4LurMrfVzzp3PpUJ6EdzIfsa8zK3+uW8Sfh/
   ffFac1Sbq4aBiaKI04e/5Qg+9qnrZzLKL36p5ICAljb5eTWLvOQby++VE
   YmC8eVrBvN7H8dykMsD3XpYhc7zNOYjbi+TNAelDEmvHLc6sV8o4NxtHT
   9XR+BUXfTUaUIZ490SLq4baf7L3WmFPXWru/V3su/FuC6NzOH/SZIAXpw
   io+1x0ksWeMKRzujKNqpPTv6QIu1bYhJZkD6HTDQ3Axi+Csv8l52invyB
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="318819137"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="318819137"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 10:50:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="649538903"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="649538903"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 15 Dec 2022 10:50:16 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 10:50:16 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 10:50:15 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 10:50:15 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 10:50:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bk68GKJjn7c4N9fTCUWGMia5oDCZQXXV3NlBuPB2NpcOGzxmi03kgZ2qHWRQixiq7QpHzj+xett/BRBq1aiQkzu46ZGwzx6u0tBugkDe4GV5OjSKIl3egmPivCMm+UhgKJ9oyHvsphLGKEgJTEHmWbCK+X4tjpjNLB4eH5F4ABvwCXxyxvmJLpb1aiObZiRCCteddQwJ+fZWyRInBtfmae+4a4AJyfx1NQxaP5pbQf53COGLey5aF594h6jPL71MsbrMJ3g9WbBqZX6nF5gBT55aJ8GVFeyAR5NT4WC6mw+9ghMLfYUmWheU/HuPziP9+x/ibrndR0WQvw6xSqsDYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v0UeoLQBAJ1uo1xh2XwPxZHrxgaei4Sa0Fp8Dq6/sh8=;
 b=SJHFDCmINxPFiboIo65Uu/IFSO+qGoJ2RV9cn33qwegjdwmwWLIZzuXiJtg8ByfF/f+cUshifoyRrzu0qS6jL+ZKYIa+K/YuXx6k3JpFY1tO0dEGGm6kNU2AR752yj/f46vaxsZ0DprVc/nluyBSLl/LumAeEcwMHmVlVSUdCtlLAMcCA0bPWMhJJtSWW4o4iKibXbqTSUjJBKpLuA++GBiu0bt1q0pRvwMhlm5gqpOYEjvJXPq1gu5GBQt6fpDMbZkmxX84ny011vp8v6v0RmqpGHlhGxaHukYDKbhdxpjOkRulg8377/31vE/dJMrWbdmW7sy0Aw8pmj0jS3wliA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CH0PR11MB5378.namprd11.prod.outlook.com (2603:10b6:610:b9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 18:50:14 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 18:50:14 +0000
Message-ID: <0f79a6ea-13cd-98d7-1f88-c4e6375ade3a@intel.com>
Date:   Thu, 15 Dec 2022 10:50:11 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 06/15] devlink: use an explicit structure for dump
 context
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <leon@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-7-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221215020155.1619839-7-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0056.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::31) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CH0PR11MB5378:EE_
X-MS-Office365-Filtering-Correlation-Id: cb933836-cf4f-4b5e-a64f-08dadecd337d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jPyQ34RbxxsQWNk3agGdJXszgRmEnRxuP/yTeI6a1miIZGFIZaaaD2UB494BhkfYW4BnsVe5S1yMMDwkq38MwNOa6C6dtrnGOSf97/ugEBuLoAnUMD5HOqqK9FneTP29PoagykBBo4P8bKwMLUjm7+UQsH6TlskFM2NUOUFyMUGt7eODAylQe6IieMxWO8kRf8Tylvajip+mUk6bOebSJeeoHBXsxSn8n6EXfg0Wd5LiAjLMy8KEqZAeuMS0SzYPsptyshcCBGn8NNMF1aefcHDX51+udALNUv6ebmyy6bV/rmfC2yxOIzE9TE1b6py2YqbZq/dIvLTtHBcCpmxHUB13uoDX9Rj3QrQJViQQisv8VRmBF7uu+slwpF3q8czFcPIwLmhb5VNl0od32HsBZn84usL3TZPbYFrhNZkNnhDtNXm3MRBmlACueZ9bqaH3ltNHVH7u6UWYF60kbowlcwGl2W4wJLIkJJmTZmPb2BYnT7zoRhlYdmDi03EM4GTAfE7Y+l/ON67ATnI2a9OfvO4Xvwg7tF0rf5M0bCgh6TY4Frtm1uITo/XWi/DP8T0ozUUG5qfG8nZQmdpNplUOlP3qy5T+0bBj3S9UsP7iZwb2di0yp2VsnO4kdTEmBNOBm/ZfUaGqIFHbsgqE5aXV4rltBNtZ89D0JOlKXUoGMDb/U9FrrEZdJ32tEeoelA7sZ9+PV4SkiBHSYTvUcdMEpa88ufNmisnYRPoVWGuFurE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199015)(86362001)(31696002)(82960400001)(4744005)(2906002)(5660300002)(8936002)(41300700001)(4326008)(6506007)(6666004)(186003)(26005)(2616005)(6512007)(316002)(66476007)(66946007)(66556008)(8676002)(53546011)(31686004)(478600001)(6486002)(38100700002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TlIzWTcydENkbkluOW1kWkRTSytGYzI0VVAveFhUOFZPZlowVEQvWFhiVmcv?=
 =?utf-8?B?alk2Q0tkOTdnN2oyVUtWakpLNk14L1FVbEplVW1pWmx0Z3hMZEhJN1FKaU5B?=
 =?utf-8?B?aDc3QWtJQkhWVkRWQkZ3YWtXa0JnVjdIUExsa2xtUjZEdE5IMmFiWjhYeUVF?=
 =?utf-8?B?RzJxcUpHMVVDMnh1RHFhZzlCWU9XU0VBN2o4eDNtMitwOFVkcDNseCtNSWFl?=
 =?utf-8?B?bkhuTnRhSUFDdndjWVFVQndVREF2ZjRYSnZmQnQySjZtOHVmcEJoT2FFTkVG?=
 =?utf-8?B?YmRzbmdaMjJ5SHVsMzRPVDBhb21IczdGdWYvc3h3Q2V4ajFnNzhwOXVQbUlk?=
 =?utf-8?B?U3Y2NUFrZEU2MUVUckFtVlVrcjJIUkN1MHpDR0RubjRvcm54amtoa1BkOXpu?=
 =?utf-8?B?QTNZazlBamJHdnBManhYNDFNb2o0V0QzblZDSDk1cWNyVERXVWxUNzBOTllw?=
 =?utf-8?B?dHlLdTdsaG40d2pzeUYyQmd6YVZZanUzajRNdndQc3lQSFlwc3l6cDV4SnVs?=
 =?utf-8?B?RWRHVzhjRkJEdWdHZ1NhMHRPNzJkeFBGUHo4a3A5ODFmSzRrdGVKVVRyVCtN?=
 =?utf-8?B?bjdOeFJQa3ZSYitLZzluQU1SOWRvRlVVY2xsS3RNVTlrMVBKSXU1RkhyaWdV?=
 =?utf-8?B?dFg2ZlhKbkMzQ0FUMHNxWk5xODF6ejAvU1hWVFdlc1RUQm9zeFBMUW81WktX?=
 =?utf-8?B?VWF6S0prVmhTRnZQeTBLaC84blJwZGhrbGl1WXlBNWwzbWJnK2FxTXgyZ1p1?=
 =?utf-8?B?NUpmQ0E0OElLeEhPWEI4WGdzRnluZHdLWDExWW5wNHdnb0dSaEw3S1lCaWNM?=
 =?utf-8?B?WFlheXNFOUZBeDNCOVpKdGlUSnA5b2R2OUF2eFkvNjk1RUk1L3EwcW5YOWVI?=
 =?utf-8?B?NTU5dzJFMEk2NWdRRllQYkNyTmFkbmczbUJiaWpMOXpIbGEySFgvNkhjSUds?=
 =?utf-8?B?dElvMnBXZkRlVnN4OGtQNE4rVEFMbkExU1Y0T2JKVkFGZ2JseUlqV2ozMDhC?=
 =?utf-8?B?d3cvWGFjdlhpeVRHTWgvWnZWOG1WYnVvTkRyUkhuNlFFL0NtVTBaczRuZk01?=
 =?utf-8?B?S3BSa2xLRWpFMlA3Y291ZzM4WkJ3ZGhNakNjWURoZmpGamRZRHVIckliZ0Fn?=
 =?utf-8?B?VTBSTUpRQ3FrQk9jWmtmWXdFNkhIUDhia2lCeFJsSDNhclpYbG5XL0R1SVZW?=
 =?utf-8?B?OENqb2FOckYvNFd4NFBoVUQxY0sxSkRvYndTMkFzNnZuZnZoUUVBaHJONW1Q?=
 =?utf-8?B?dndCWGV1T09oczFtb2ZVOHdiQzNORXkyTlQvUTFSQ0lJVkhrV2pmeG4zZmlq?=
 =?utf-8?B?ZHcrdWpFcnhUMytWcC9jRWR0MGQwTFFPTWJYbXlhbUMwZlpCOGNKSFdKcXFo?=
 =?utf-8?B?blZESkszZHJONU9STzJ1Ujd5cmU1aWd6YzQyY2gvRG5zcUFubHlZMWJMbWh2?=
 =?utf-8?B?RlQ0NUxyQUJRMWlSR0NDbTM4NEtSZ01PUy94ZjYzOXhuc1U0U1M4NnJJTjZv?=
 =?utf-8?B?SE9nSWtPeFpxZHVpWEdUdmJ2YXJFcE15YzF1d0t0dTBMdTgxUDVWUU50dDFh?=
 =?utf-8?B?ZS84SlJyblkyK2pUTC9oc2pvanptYkFNRlBSNkRkdndObkNNZ1UzcW1UVnVo?=
 =?utf-8?B?eVJmaTdIbmQ1MGkvT3VmWXM3NmEzRzhLK3pnZnFQV1RRNm96WlJWSUhhT1hh?=
 =?utf-8?B?bXBjZWlCN2hpamUrY0FJYU9pMUZHVi91clpmZlFqSk43aXRKeU1WbGQ5UXlE?=
 =?utf-8?B?b25jTDI4bE4xaW51RmxQU05KaVlMVGFBV1FCR3phUmk5bVpUUWtpYU9yMmhh?=
 =?utf-8?B?MVIvQXIxVHI3citlVyt6WTUraHp1d2lmM0hqY0FLdTZqZ3RLYlVYY2I5TDlU?=
 =?utf-8?B?TDVmRWJSTWVoMGY4REhGL1FsSGNhL29CQnhvZlFlNVJURXFENGh6bWVRUEZm?=
 =?utf-8?B?YzRjbzQ1ZlR3cExQWmRiaitlTEZucVhMWXpWOVQ5cG9JYXJWdWhXZUVReGZz?=
 =?utf-8?B?QURlUmh1cmNZUjl6ZTc2dllIWmNTek1rRmRVQmtMTE5NR1Y4ckRCNFptTlZX?=
 =?utf-8?B?a25aeXNIYmY1OUpFQ3h6VTlHWCtlYVF6TGZsd0l6R1Z6cXBMNHNEYXp2ZitX?=
 =?utf-8?B?aXJJTWNFRUR2OFNtdXJRODFRRWhrcDl5eTdSd25yM1VxU3ZuSnhMaXlHM3o1?=
 =?utf-8?B?MXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cb933836-cf4f-4b5e-a64f-08dadecd337d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 18:50:14.1287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hrlvLL+4SMWzGA4l6EEfgsqrPuZFMwB1HLp9gLpHI4Y5b5KVfUsQf5bwjux2Hmiji2Pb1PvlBNiMVbwe5RhQDnYWBObuLoQSoZHkAX3motA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5378
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/14/2022 6:01 PM, Jakub Kicinski wrote:
> Create a dump context structure instead of using cb->args
> as an unsigned long array. This is a pure conversion which
> is intended to be as much of a noop as possible.
> Subsequent changes will use this to simplify the code.
> 
> The two non-trivial parts are:
>   - devlink_nl_cmd_health_reporter_dump_get_dumpit() checks args[0]
>     to see if devlink_fmsg_dumpit() has already been called (whether
>     this is the first msg), but doesn't use the exact value, so we
>     can drop the local variable there already
>   - devlink_nl_cmd_region_read_dumpit() uses args[0] for address
>     but we'll use args[1] now, shouldn't matter
> 

And to be clear, the context is not ABI since its not exported outside 
the kernel. Thus, these changes don't break compatibility with user space.
