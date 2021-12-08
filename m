Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFD546D65E
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbhLHPIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:08:00 -0500
Received: from mga03.intel.com ([134.134.136.65]:28037 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229496AbhLHPH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 10:07:59 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="237786805"
X-IronPort-AV: E=Sophos;i="5.88,189,1635231600"; 
   d="scan'208";a="237786805"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 07:04:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,189,1635231600"; 
   d="scan'208";a="580617731"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 08 Dec 2021 07:04:25 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 07:04:25 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 07:04:25 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 8 Dec 2021 07:04:25 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 8 Dec 2021 07:04:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7ie9nLqVthb0Ndy1vBFJT72p4WhywawIQ06HR69SSJ7B5c7rhvCkznBATGWoCJ5oEfkpH1oMe6zREQ3yGrUSxZpU49dqjMohuq7O4ksY4QV1glriNVBJbgBxf4bC/cbEUBvvSOAcgyzUGSNMPzZ9PicFodqylepvEH+dpVGfimunX+Lmn2r1yKVWCFmLxC5HIExdu2xZUN8YDRNO/7UPIDsWT6eUDACefPuFqlyU7nbf/rT0RwGWdY7Xz50/vqjZ+xqmRxgJ6cNsa0bJ6k8j2HtWxlgy0tBh/RHO2+VpAIubkf6KyUhWjB4MIQroOUYOPipfXN09Fkdc7KtVragjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kScrRH6OJ+GLvXUH4jUjoNw4QyHbrH7PkxYYaJb+M0A=;
 b=MMDtIA1D8jgQFrbTR5gl3kCjCz4OFumt6mfbDhMa7wcB3xhpzb9CdOaTlmJp9ZOV/V8n00hPxEJwPrvCfK4/Vu2Qrf3iCJZiJliwguRkCJHSAiXevaUmMVCTevTxJHSB0kFV1n7qqxe5NOXZD5WakgNS9NEu32khDWb+OiiMuNLi/q1QgU0opwJc9GEjdd6TaE4ljwC3/ZekLPNnhCZ+SIpm5CR16wu/K/GRO2xMOtM/veSz5xvlJSr9Md0j9CuPMC6pq9dRNDTqgSH3PRa66mO93xK6fTxiqChhihZ9g6uzi4fqesF1tusxVfeXAerCRP80aujPntiDD95skUZZDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kScrRH6OJ+GLvXUH4jUjoNw4QyHbrH7PkxYYaJb+M0A=;
 b=VNO9PdgfhfZ9BTa36bFDN2MN2wb9M4KQ+zuumFDzmdof679GVws1HZxtNjoVDv6lDYmgnCvR2o+2cE1h2j7WV5hBCwRa8VwFQALRRXA3abSa2KEwdNRaGw5/GobHKNreBayVi6AXHSfwB//W8IjM62O/l9NCj9DJvepAlhoecgE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3180.namprd11.prod.outlook.com (2603:10b6:5:9::13) by
 DM6PR11MB2667.namprd11.prod.outlook.com (2603:10b6:5:c1::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.19; Wed, 8 Dec 2021 15:04:23 +0000
Received: from DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::a94a:21d4:f847:fda8]) by DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::a94a:21d4:f847:fda8%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 15:04:23 +0000
Message-ID: <7996aac8-a5cb-d92b-88fe-e4afde5782d1@intel.com>
Date:   Wed, 8 Dec 2021 16:04:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.2
Subject: Re: [PATCH v3 net-next 01/23] lib: add reference counting tracking
 infrastructure
Content-Language: en-US
To:     Dmitry Vyukov <dvyukov@google.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>,
        Ingo Molnar <mingo@redhat.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <20211205042217.982127-2-eric.dumazet@gmail.com>
 <3d80c863-8f1d-5e94-44c8-cc1193cca06a@intel.com>
 <CACT4Y+a8aXJRU5u31=4Nu4czBZCUaH06TV1VjiFxRGo9zeYjKQ@mail.gmail.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <CACT4Y+a8aXJRU5u31=4Nu4czBZCUaH06TV1VjiFxRGo9zeYjKQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0117.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::33) To DM6PR11MB3180.namprd11.prod.outlook.com
 (2603:10b6:5:9::13)
MIME-Version: 1.0
Received: from [192.168.0.29] (88.156.143.198) by LO2P265CA0117.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::33) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 8 Dec 2021 15:04:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66bf8e31-c7f2-439c-e45e-08d9ba5c04b5
X-MS-TrafficTypeDiagnostic: DM6PR11MB2667:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB2667D6245161CA64CDDE3419EB6F9@DM6PR11MB2667.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vrqHh9ph9uBHPA84fe0tyHlNjkuHcIiK2xRUf3xjN/B1UgGjzTk0R12RqXtiIhTBuVQ6qBdiiNfP6Kz7a6cEM+bq4mRHk84P3gS0AsocCqTdeE7xAImMcDQIyWweAc0o90qWEWXWZVqtVd2XnLBF8ssuHSKLdQS/1CD6UALDoM0mhBCJv3laxupoS6WAJ+uUz/bhaIzSDeSoollPfHJ57I7sQ8UwEuZXRc3QS/8ckxJ3BrUIkUZFg+UG7th2uKjld7q4fYyUqfLgT/oRjjv0AH2/k60LYgWKr86NrpXfO/i9CI+pUW0fjGVyxQ+M9T6CJDUHKoaqL6CU/8wRJxH97F0VtW32h4iX+YfRIjOJmZI5rcaYfrEB7FtSGVmGji7WPhEnXxmio+NqekKApHbd97pDvld52Umk/fxWNGtRCxkpPeYyEf9Z3cq4yAxy5U2fiLTUg70h/J+IwlNjJtC2ST/QXh7jlB87jgJTANH8rG8XI0cSZ4RblhyYBnE9cgWnyvxELqQHs5//Rym6HOegXzVkPIBTs6kzvPfbmzkUHYvY5ZUkiaWCG5vKblALd6S3UOseC4UMmyD/DqvQ4DAA0bWi3RrAU5yVUUOD9B+enTywEH2HFgesHOewVgqiigGWGbr3v1O85Mj6QFbHFfg1F6jjltwOHRe6YfdCLvGf9spSnyYAXN3DtrVi/4QX03BNk4FVP1iI0EIwpkbE/PN7SsYnv+OC2gEU9+3QulWj2p4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36916002)(6916009)(5660300002)(38100700002)(8676002)(36756003)(53546011)(8936002)(508600001)(31686004)(31696002)(66476007)(2616005)(82960400001)(54906003)(44832011)(66556008)(956004)(83380400001)(16576012)(66946007)(2906002)(186003)(6666004)(4326008)(316002)(6486002)(26005)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVNwOS95TTlETmhqSXF6NUozQkt6TXF0QmN3Z1Y1LzI2SFFud3hMa2hkMnZa?=
 =?utf-8?B?Q0JlUHh5KzRuQUdtSFhFUGlqeU1ObmpnaXZINE1LNHdvNkN5c3lkdGFEQ2xE?=
 =?utf-8?B?VWJ1cmlkcVNvR2lURk14VFlpbnJTN1RzaGJKTno5ckNLK1I2WjUySldVMW8y?=
 =?utf-8?B?RHZFVHJQMUlIc3FacHNKMW9BSnc5YjV1NzVJVTVDQ3hBd3hBV0Jkb2NCQmIz?=
 =?utf-8?B?d3JUWnhmblRUQUx1N2NqNHAzbkZialBQN3FGczUxZGNtb1lOVThucUhGaTJI?=
 =?utf-8?B?SVZzVEJhTEtUM05JNTZlbEV5MFVBSG9HZTFHanAweEFteFVjTDZLL3NhZzVB?=
 =?utf-8?B?WGpiY3RpUElFdHRKUDFFSCtxTURXdEVDcy9SaUpRM1hPWDJQRkU3bFkvL09t?=
 =?utf-8?B?TVV1WFFsemFtaHZBV3hxb0RpcmZXWnZvU2JGUXJtaDlOWVJNOGlMbm9nY2dj?=
 =?utf-8?B?OGNNSkxIUlVuUkRUWGU3TG1kakRtcDlab0lWRXJiSktLY2RnMEFOcjdOL3BC?=
 =?utf-8?B?ZDNtelJNb1pVbloyK3dad0VKT3lHU0srR0xaR0NqS2pEOUkzK1FJazQ1VVJo?=
 =?utf-8?B?TDE3bzl6M3g3cDZHbWg0b3BTdHJnNTZmZ2g1dmJUZURzVDUxQWdMbXVIQWlE?=
 =?utf-8?B?TnptVSt5LzBZcndmMGRJNFd5Rng0VEtTNXRpY2FqL1g2Q0Z3SzBSKzdONjk5?=
 =?utf-8?B?M1RDL2lmemMxUHJ2dVhubnJqVGd3bUdNWVJ2RjRTVEc4Rm5mMjhsVzQ1NWlj?=
 =?utf-8?B?R2lBQ20zTi94OGkrS25GY2N2TkRsb09UU3o5WTFUbUh1TlExTS9KdW00cTJU?=
 =?utf-8?B?U2crbDRMQzVnQzI3bnR6dWZCaXkxdVBmOFhZZnFCMXBxUnFQVGtRQ0hiVzV1?=
 =?utf-8?B?bStaUXpxZDJUZ3ZXNno3dnpGN3V5Q01ObnFQQ05XU2tSUUpiV250cmFLWTFW?=
 =?utf-8?B?VXpMZk1RY09kTUpiSkJaQ1NQdGNaSmRGZVppRGhmc1RDUlI5K0Z5Vkg4NmJU?=
 =?utf-8?B?WWhxMkw5UU5vbnlzUXN4UExzeTBmb2E1N2htNmVaMjlEQlFZQUYvQUVqQXBU?=
 =?utf-8?B?Y2FWYmE1Q1plRWdLT3JMM1ljcW9jMmtPN0c3bUwwVnhiMktYODU3K2xtVmly?=
 =?utf-8?B?cWJKcG93NzhBSzQwVEF3Q2E1S2ZUWWVSR3I3cXZUTVhSdE5kd1ovQXFpNjZZ?=
 =?utf-8?B?bk81QzcxSzByUStkTWZhZEJSTlJPcFdGYUFDR3BuaGd3RENqRXU1SDJYV2J6?=
 =?utf-8?B?SXJwNjV3dENONCsraCtJZjJSclYyckE4UHhlNUF0UVZ0eUdzQndRdUV2UGNV?=
 =?utf-8?B?SDJSZEQvUTN2cld0RHBVTVovNzVkb1JSTDJhdThOanJSak9zSVVmQVVIdHdF?=
 =?utf-8?B?Rm9vWjZDbHh4cFQ3MW1LNWxHS2VSaEUvWlRPWXd4Y1Z1Szd6ckJzYjgzZGh5?=
 =?utf-8?B?WmpoK3YzcEVVMjNHNXRtc2VNYTduU01RbjRYNk9IbkhRMEJUTXNIRkhoU1Q2?=
 =?utf-8?B?UHBpbGVCSGRIdm5jWXdDd0ZZWE54cHN1ajk0cWhRbHZSZTl3eXFJTkJ6QWt6?=
 =?utf-8?B?NmwzM3c4UGxnaWZuM0RMTzZ4ZGRnMHp0ZFZWRzRZWVg3WHl6NER0UHJlR3RI?=
 =?utf-8?B?b04vN2RTbEFLSlZRY1ZjYXZmWlNTRnBKejlkZlI0V0t2OWpFSWJ4VExpeUNG?=
 =?utf-8?B?cFVQUmpYNHcvS0x2YUp0eGVySGlXRlBZNHlFQ1RMd2l1SGZHdHlMbm9FR1p0?=
 =?utf-8?B?MVBLbG85VVFsTVVLekx1bnNybmJMWldWZksyUlRrRnlKVHNDa2NIcWh1ZGVy?=
 =?utf-8?B?ZWRaUithVlhIUlA2eEYzTFcwc3RxS2pPVnN5TUx3Mml1Y3Z1eUp3WlZzZWdJ?=
 =?utf-8?B?MW5SdGU2K29reUw0YlhRRzU3cUhWd3VvZFhFR0pONXNWcklBd0ErWFcwWnhs?=
 =?utf-8?B?Tm4zTUMxMDN0cUR0TmVmNm1KZGNxd3R3Z0dMQ0w2cFBCeU9BTHFJTUpzanFJ?=
 =?utf-8?B?YjRITDMxWUNPczlsWGVVN0JIeGVTN2J6SXBiQURqSnRmeWhxb0ZTdUdZZCs0?=
 =?utf-8?B?T29QV25zZUVMek1oQXRGbFIxZWFUN0xnSW9PSmY1NzRZU2dKWlJMT3JLZUMz?=
 =?utf-8?B?dHBmSGkrUUpXTE9Yb0lGY3FXUFcrVnZUbDJpOTBJSjRuK29DMWFpSkJPdGJK?=
 =?utf-8?Q?PPTn9LpWOM4lt60d1rgRtls=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 66bf8e31-c7f2-439c-e45e-08d9ba5c04b5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 15:04:23.4579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LtAsmfmaiS5ehlaXwgDaQXlI6eAd+cAxuEXrf8I8xmnT2qUwNwCtulIKPX/a0pC9rl2t/tlG6Ma8dp2Tp3Sp4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2667
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08.12.2021 15:27, Dmitry Vyukov wrote:
> On Wed, 8 Dec 2021 at 15:09, Andrzej Hajda <andrzej.hajda@intel.com> wrote:
>> Hi Eric,
>>
>>
>> I've spotted this patchset thanks to LWN, anyway it was merged very
>> quickly, I think it missed more broader review.
>>
>> As the patch touches kernel lib I have added few people who could be
>> interested.
>>
>>
>> On 05.12.2021 05:21, Eric Dumazet wrote:
>>> From: Eric Dumazet <edumazet@google.com>
>>>
>>> It can be hard to track where references are taken and released.
>>>
>>> In networking, we have annoying issues at device or netns dismantles,
>>> and we had various proposals to ease root causing them.
>>>
>>> This patch adds new infrastructure pairing refcount increases
>>> and decreases. This will self document code, because programmers
>>> will have to associate increments/decrements.
>>>
>>> This is controled by CONFIG_REF_TRACKER which can be selected
>>> by users of this feature.
>>>
>>> This adds both cpu and memory costs, and thus should probably be
>>> used with care.
>>>
>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>> Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
>>> ---
>>
>> Life is surprising, I was working on my own framework, solving the same
>> issue, with intention to publish it in few days :)
>>
>>
>> My approach was little different:
>>
>> 1. Instead of creating separate framework I have extended debug_objects.
>>
>> 2. There were no additional fields in refcounted object and trackers -
>> infrastructure of debug_objects was reused - debug_objects tracked both
>> pointers of refcounted object and its users.
>>
>> Have you considered using debug_object? it seems to be good place to put
>> it there, I am not sure about performance differences.
> Hi Andrzej,
>
> How exactly did you do it? Do you have a link to your patch?
> There still should be something similar to `struct ref_tracker` in
> this patch, right? Or how do you match decrements with increments and
> understand when a double-decrement happens?


User during taking/dropping reference should pass pointer of the object 
who uses the reference (user).

And this pointer is tracked by debug_objects:

- on taking reference: the pointer is added to in-framework array 
associated with that reference,

- on dropping reference: framework checks if the pointer is in the 
array/quarantine, and the bug is accordingly reported.

- on destroying reference: bug is reported if users array is not empty,

- on taking/dropping reference to non-existing/destroyed object: bug is 
reported.


So instead of adding tracker field to user and passing it to the 
framework, address of the user itself is passed to the framework.


Regards

Andrzej


