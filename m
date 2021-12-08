Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484CF46D543
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhLHONA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:13:00 -0500
Received: from mga18.intel.com ([134.134.136.126]:54628 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229550AbhLHONA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 09:13:00 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="224704812"
X-IronPort-AV: E=Sophos;i="5.88,189,1635231600"; 
   d="scan'208";a="224704812"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 06:09:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,189,1635231600"; 
   d="scan'208";a="751911120"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 08 Dec 2021 06:09:27 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 06:09:25 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 8 Dec 2021 06:09:25 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 8 Dec 2021 06:09:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y8E1t0BFehkfeev78he4Bcm0QZ12IZSC6iz3AgBJfNxcXfPPZvLOfHXeuNESO4rfUSw6i4hFj1ZFxX6lNWENDio5NHgnS3DiwsoAefjM+tesI3JlcXpwebh+0epbDRSF6HeYbrYqwTTdvRZRh4Up7BgchIQJy3ZKcJtMD1tqPw/XLlXtjodnT6xV1+FL9OFj21wzDZWnP5PunvktnBbj4I/I7BaddY6JysbsvmpcJLXTqZGzYIm8CxMEsR62LYlMryz+0zkcngfqLP+zS4bzD387a2/LvW6oc6HaP88EuAO7CcE54A/FYCSQfju09+o0cBK7su7b90fmCLKm50WY4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GXZX3wtOhdm6ww3AVx0GIUQq6Mm6Oe2dDm5Htp92Sx0=;
 b=LOnRBxblt1D6hjfBwXDDAkJxSNRjQVWjw2THzR6mqWGztTymKcfQwWYGktTDFy6EvSnSJ/Qh4V08CkIt3/xJch++N5t2mogoF1nS/7pFfQRbzZT8e/qjwzqRrdpp833te1UrifIv2rmIL+x/NoN9HcESQC8dbQHNeC0YO9mtPbccwGodPR/qZcgdo1+ulaIM2X27bzi1RSg09Op8ZVu9UoDupH9Ux7nSbE31kKK1bMaWWnhgr2OkL0Sf2sii/M2OiNZgj9dkjz958O/wv3fVIlT0PJry0o3UCh7zjat3DfU4S9p7kwq7lIFTBNeYb9iwBilPKHb1mpERhaEVdlHtwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXZX3wtOhdm6ww3AVx0GIUQq6Mm6Oe2dDm5Htp92Sx0=;
 b=TMAt6PBYcJfJeWwi/zQapBoBJnHvO148D3j8JvjYyeH3eDmm8pCZbqI34SOkql3HTcBu7zN0Er4T32GsUzNlXs46mriUg3Z5S13msovPgi9XdPKdM/hpLtua1KNuDAxdI1jN1CCCHfiR6Qzj7T93+F1F2EYw/ugAXJh16DBKjbg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3180.namprd11.prod.outlook.com (2603:10b6:5:9::13) by
 DM6PR11MB4457.namprd11.prod.outlook.com (2603:10b6:5:203::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.11; Wed, 8 Dec 2021 14:09:23 +0000
Received: from DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::a94a:21d4:f847:fda8]) by DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::a94a:21d4:f847:fda8%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 14:09:23 +0000
Message-ID: <3d80c863-8f1d-5e94-44c8-cc1193cca06a@intel.com>
Date:   Wed, 8 Dec 2021 15:09:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.2
Subject: Re: [PATCH v3 net-next 01/23] lib: add reference counting tracking
 infrastructure
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>,
        Ingo Molnar <mingo@redhat.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <20211205042217.982127-2-eric.dumazet@gmail.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20211205042217.982127-2-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0091.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::6) To DM6PR11MB3180.namprd11.prod.outlook.com
 (2603:10b6:5:9::13)
MIME-Version: 1.0
Received: from [192.168.0.29] (88.156.143.198) by LO2P123CA0091.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:139::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22 via Frontend Transport; Wed, 8 Dec 2021 14:09:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8702416-8dd9-4a5f-6ec4-08d9ba5455c4
X-MS-TrafficTypeDiagnostic: DM6PR11MB4457:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB445750B2C5D68B91DD0A8267EB6F9@DM6PR11MB4457.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ASpD/2i+DcSSEJXxWBmKB2ZlURGIu7pRUtBRstvEhRgv63un/e156arVFo/IADXqJLkE+4+C7QXVtSxwTDAVLDJN1VIJLnmqPbzoFvFuqGyeX/Jnmu7FXiQgMAlwBE1EAQb3OzA62eq5RDjONSlS3PRYrzzjN1Hgq8n0HNMvvbu9nWVgv3ub8RcuZBFM1uYRQc2JSXixl4B5gkvEdT6FZXp+dW67qN3J0LjUwh7B7v1LzBtlfNcUvfvKqfpn6+ua+liuyP2VtBq4mcEO5wXPBSg5i0NRZmiXRVgEWBYhGvj4FAS1AkL5JjrEHZy2Ci20zBdQ9wSR29YDjR4d8ggw/EYM5KsztnvETjWMcDmuXY8N9Kuaw8xYSNH6qDi3RQoOT9BLP1voKvmwFo9wIvn81KeqTrJR4Sl1tsN2EMR/xWRB5Pb0kYKx+L5pM05AQfCy/1HXxN0WwAhL1qtoef7sEfwWh+RFTLWBojMedlxRBH4wrxKfW/hANr7SGRzaOJ9bmqXTsLDzPtiMAX7Hgy2iKxqERIndmTivVQfiLOWxYHra3NyBNcr48pTk6ZiZeLBxU1b2JCRzzjfwmHJJhUAi/REOdzVtxzMn1tHot9S/meiqMFHJ62fy38NGNOBo9+6CPD+l6xp9jOuTfnZOiwag+7d6VL0YTMd2qW/vgTIzJ/Jpyi6Beq3+Nb226j3oaUQMGE0Xd9pAl4bBiMAfhvlPOiYAltpBTpC6sPHnEb7hZbM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(316002)(26005)(956004)(508600001)(36916002)(8936002)(16576012)(6666004)(2906002)(44832011)(66556008)(36756003)(86362001)(66476007)(110136005)(83380400001)(2616005)(66946007)(6486002)(82960400001)(5660300002)(31696002)(54906003)(53546011)(31686004)(8676002)(4326008)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUEreXBlbHprTlVzMGhJQWN3SVFRNkVzUnhxV2w4UTdvRWZBZE95M1N1RHhk?=
 =?utf-8?B?SUk4ZFMrOStzV3IxNDRra3BEQ2xYKzN3TFpRdVBPVU1JUlhjVDZkZkpYbzFU?=
 =?utf-8?B?TGppOWxBYlRwMU85Q29yeWV2MUlxakZUaW9oby9PUHhvNEMvcFUzRHYvd3Rs?=
 =?utf-8?B?Qmd5d2tmSUZJYWFpcVY0ck10aXIxajI4S1hwYUMrUElCSGlsVjFtV1FWY2NC?=
 =?utf-8?B?dE03V0hrUnhhM0VJdlhHMUhYWGlHTmV6aEpxOThJa3RiMDRxcmxadEVCeXNy?=
 =?utf-8?B?cHRQVFlycS9RckhIZGhoTnB4dDVVVUg3WHl5dEVCRHdQTHBqWWwzTDRBUHpC?=
 =?utf-8?B?Y0VTTVBYdGtjTDZ2ZlVtZDdJUnN1WkxhYkhpRWxtN1pBWU4vdi9nTHJZUDNy?=
 =?utf-8?B?Ris0VUVZdXlWUmdrVXcxUHhheW5ML1NISW5VaUlUMmVnRTdSSGNtUzMrZ0Jo?=
 =?utf-8?B?UmpNTUJHbU1XNmZyN0QydGM5MDBzMHJqS2x0OW8zT0ZFdFo2VTd4dGg3a1lW?=
 =?utf-8?B?bXUwSW5yUXJwajA5WkozQVAvOEJtcERJbjh6UFFrNmsvVmpmSVM0YzZyd0tE?=
 =?utf-8?B?bkFIaThYNWxOSCtscy8vL3Vid0YrdTZLMWJ6RlZlZ3hkSStnRWVocnJCbUp1?=
 =?utf-8?B?T3JPdGF6SXV4RXdhQlU3UjRpY0ZybTZrVGFFNEpRVXArbEJkQlR2dTgvTnMy?=
 =?utf-8?B?d3dyeWZNdW90MVhkbG5pTFVxT0hFaXdlN25CcHZQOTVSSnZTaDh4bXBUTTNU?=
 =?utf-8?B?d2xrVEV2eDJucTB6OHl1c0tBSkhlNXZlTkZzNkd5T2pHMGdjYVhpbGhraFZO?=
 =?utf-8?B?Z2dGZGtqbkVRT2s4TlFaLy9YbkNobUQ2MWE0SWZnL2RYWmdlaW1Mc1ZBNXdn?=
 =?utf-8?B?VForTHlVTVpsa2FKdHhSVUdST284dXozT2V3aVpUQVg5RkN5YVVBdHBCTU9N?=
 =?utf-8?B?OGdKaVM3VU1EcjA0RzJRbUlTZG1Gak1mN3dUMEZtWnVuQVhXK2U3Z1dHc1pu?=
 =?utf-8?B?a3hPeTA4ZTR3Y2dPMjV1QURWN3hxOE4zejY3SEtnVGZQWUNvQmFjWk9maS9K?=
 =?utf-8?B?MjlIWS9jQ3NkSi9BVStHaDVnajkzSU5QVWNxN1RkdVI2TnRYUnFrKzVjV3V1?=
 =?utf-8?B?alY4bFVaZ1p3b3FrZkc5bDNTZzNZZTRwVkVVZFlaTFlaWU1XNE8wYzFHejlV?=
 =?utf-8?B?OXlpOEVldjRCeXEzMXcrVk9xNC93RS9NdHpKaDRXdFJ6WGxJdVIyRUplOFl0?=
 =?utf-8?B?VHFLZ1BIUTZkbzlGUkFpdmVJbVR4RE5vc0RqSDJHWnZxOTVaa1RkWUpkbHE3?=
 =?utf-8?B?Zk9XVHZZNFpDcUY3MTQzVnBMTDlvSU14RmpzOG9UYVRhbkI2alVISEdLOE94?=
 =?utf-8?B?SVluNVRUczNVTmJMeE16TklnRkRnSjJkV1JrS3V6eFF2b1hsYmJ1RlFpRkFO?=
 =?utf-8?B?VGNlbDYrc3VtaVlrL0Joai8xRG5rdGNrbXdQOUNlTnlRT0JIQlY1ZnlTWWpx?=
 =?utf-8?B?Tk5EejhLT1pDNkVZZFdaOURhTGcxejFxVEl6Z2pCZzNpRzhnU0V6YVB1VlJp?=
 =?utf-8?B?QnJQVEJSK2V6WUI5TWhtVU9DVEFKUjFJakNORUpiNW5Ca2tNUHV3UFR4Zkcv?=
 =?utf-8?B?N3ZDaFpBUGt5eElIZTZvV2pOZHhXYzdZNThLZjIybER2WUpjRTNQNlVvYWlI?=
 =?utf-8?B?SHZmRFU5bWdPSi9KdCtvdlBLaEloMDVhQnJTaldHaEJWTm83eUpQMlJldTBI?=
 =?utf-8?B?VmhWSjU3NDBBdnhSR0M3dlNUaGZtNVY2RzJEZ1hCRFE2SVhJVUpSMXE0OGVH?=
 =?utf-8?B?TXl0aVBIZW9hQjRSem1mWFpTR0QrN0FRZURkSHZySTNrSWw5dE9pcXhxcTk0?=
 =?utf-8?B?bEE4OVJpVXBtMXZTR3VHOGlpVzNPUTJoYnltNm0zMGYycEJ2STRhRHJvaTY4?=
 =?utf-8?B?bFRhSjE4Ujh4dHRwVW0zUmwvcGtJa2JXVm1teE5oajR4bnpSYkUxelN5N1V3?=
 =?utf-8?B?UWd5M25UMEFkcEpjc3JOK0ZuMThYMWdGY0c2L1paMHFGUUJwc1dpc0hyOFo2?=
 =?utf-8?B?SkJySDd1RnRQbVlOUS9jNXdjWjNIWXRSaEo5bVBvWFhwd016Z0FQWEFtNjAx?=
 =?utf-8?B?R2FqQ3VGTVN0dE1aRGhkd0hGVHZSZnkrbm96MEEydFVIb2lOOEV0dFJqTWg0?=
 =?utf-8?Q?uuQM43Jv7phw8+synuz1O4s=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a8702416-8dd9-4a5f-6ec4-08d9ba5455c4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 14:09:23.0460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ez/IBieKK3eM15Gf50/jnw7oRCFiF5jE97sMzFWnDQWnLpQtejZUOwwRtPk2eGeEjlT7jC0lltZLdnmW0Irluw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4457
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,


I've spotted this patchset thanks to LWN, anyway it was merged very 
quickly, I think it missed more broader review.

As the patch touches kernel lib I have added few people who could be 
interested.


On 05.12.2021 05:21, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
>
> It can be hard to track where references are taken and released.
>
> In networking, we have annoying issues at device or netns dismantles,
> and we had various proposals to ease root causing them.
>
> This patch adds new infrastructure pairing refcount increases
> and decreases. This will self document code, because programmers
> will have to associate increments/decrements.
>
> This is controled by CONFIG_REF_TRACKER which can be selected
> by users of this feature.
>
> This adds both cpu and memory costs, and thus should probably be
> used with care.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
> ---


Life is surprising, I was working on my own framework, solving the same 
issue, with intention to publish it in few days :)


My approach was little different:

1. Instead of creating separate framework I have extended debug_objects.

2. There were no additional fields in refcounted object and trackers - 
infrastructure of debug_objects was reused - debug_objects tracked both 
pointers of refcounted object and its users.


Have you considered using debug_object? it seems to be good place to put 
it there, I am not sure about performance differences.

One more thing about design - as I understand CONFIG_REF_TRACKER turns 
on all trackers in whole kernel, have you considered possibility/helpers 
to enable/disable tracking per class of objects?


>   include/linux/ref_tracker.h |  73 +++++++++++++++++++
>   lib/Kconfig                 |   5 ++
>   lib/Makefile                |   2 +
>   lib/ref_tracker.c           | 140 ++++++++++++++++++++++++++++++++++++
>   4 files changed, 220 insertions(+)
>   create mode 100644 include/linux/ref_tracker.h
>   create mode 100644 lib/ref_tracker.c
>
> diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
> new file mode 100644
> index 0000000000000000000000000000000000000000..c11c9db5825cf933acf529c83db441a818135f29
> --- /dev/null
> +++ b/include/linux/ref_tracker.h
> @@ -0,0 +1,73 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +#ifndef _LINUX_REF_TRACKER_H
> +#define _LINUX_REF_TRACKER_H
> +#include <linux/refcount.h>
> +#include <linux/types.h>
> +#include <linux/spinlock.h>
> +
> +struct ref_tracker;


With sth similar to:

#ifdef CONFIG_REF_TRACKER

typedef struct ref_tracker *ref_tracker_p;
#else
typedef struct {} ref_tracker_p;
#endif

you can eliminate unused field in user's structures.

Beside this it looks OK to me.


Regards

Andrzej


> +
> +struct ref_tracker_dir {
> +#ifdef CONFIG_REF_TRACKER
> +	spinlock_t		lock;
> +	unsigned int		quarantine_avail;
> +	refcount_t		untracked;
> +	struct list_head	list; /* List of active trackers */
> +	struct list_head	quarantine; /* List of dead trackers */
> +#endif
> +};
> +
> +#ifdef CONFIG_REF_TRACKER
> +static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
> +					unsigned int quarantine_count)
> +{
> +	INIT_LIST_HEAD(&dir->list);
> +	INIT_LIST_HEAD(&dir->quarantine);
> +	spin_lock_init(&dir->lock);
> +	dir->quarantine_avail = quarantine_count;
> +	refcount_set(&dir->untracked, 1);
> +}
> +
> +void ref_tracker_dir_exit(struct ref_tracker_dir *dir);
> +
> +void ref_tracker_dir_print(struct ref_tracker_dir *dir,
> +			   unsigned int display_limit);
> +
> +int ref_tracker_alloc(struct ref_tracker_dir *dir,
> +		      struct ref_tracker **trackerp, gfp_t gfp);
> +
> +int ref_tracker_free(struct ref_tracker_dir *dir,
> +		     struct ref_tracker **trackerp);
> +
> +#else /* CONFIG_REF_TRACKER */
> +
> +static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
> +					unsigned int quarantine_count)
> +{
> +}
> +
> +static inline void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
> +{
> +}
> +
> +static inline void ref_tracker_dir_print(struct ref_tracker_dir *dir,
> +					 unsigned int display_limit)
> +{
> +}
> +
> +static inline int ref_tracker_alloc(struct ref_tracker_dir *dir,
> +				    struct ref_tracker **trackerp,
> +				    gfp_t gfp)
> +{
> +	return 0;
> +}
> +
> +static inline int ref_tracker_free(struct ref_tracker_dir *dir,
> +				   struct ref_tracker **trackerp)
> +{
> +	return 0;
> +}
> +
> +#endif
> +
> +#endif /* _LINUX_REF_TRACKER_H */
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 5e7165e6a346c9bec878b78c8c8c3d175fc98dfd..655b0e43f260bfca63240794191e3f1890b2e801 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -680,6 +680,11 @@ config STACK_HASH_ORDER
>   	 Select the hash size as a power of 2 for the stackdepot hash table.
>   	 Choose a lower value to reduce the memory impact.
>   
> +config REF_TRACKER
> +	bool
> +	depends on STACKTRACE_SUPPORT
> +	select STACKDEPOT
> +
>   config SBITMAP
>   	bool
>   
> diff --git a/lib/Makefile b/lib/Makefile
> index 364c23f1557816f73aebd8304c01224a4846ac6c..c1fd9243ddb9cc1ac5252d7eb8009f9290782c4a 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -270,6 +270,8 @@ obj-$(CONFIG_STACKDEPOT) += stackdepot.o
>   KASAN_SANITIZE_stackdepot.o := n
>   KCOV_INSTRUMENT_stackdepot.o := n
>   
> +obj-$(CONFIG_REF_TRACKER) += ref_tracker.o
> +
>   libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o \
>   	       fdt_empty_tree.o fdt_addresses.o
>   $(foreach file, $(libfdt_files), \
> diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
> new file mode 100644
> index 0000000000000000000000000000000000000000..0ae2e66dcf0fdb976f4cb99e747c9448b37f22cc
> --- /dev/null
> +++ b/lib/ref_tracker.c
> @@ -0,0 +1,140 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +#include <linux/export.h>
> +#include <linux/ref_tracker.h>
> +#include <linux/slab.h>
> +#include <linux/stacktrace.h>
> +#include <linux/stackdepot.h>
> +
> +#define REF_TRACKER_STACK_ENTRIES 16
> +
> +struct ref_tracker {
> +	struct list_head	head;   /* anchor into dir->list or dir->quarantine */
> +	bool			dead;
> +	depot_stack_handle_t	alloc_stack_handle;
> +	depot_stack_handle_t	free_stack_handle;
> +};
> +
> +void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
> +{
> +	struct ref_tracker *tracker, *n;
> +	unsigned long flags;
> +	bool leak = false;
> +
> +	spin_lock_irqsave(&dir->lock, flags);
> +	list_for_each_entry_safe(tracker, n, &dir->quarantine, head) {
> +		list_del(&tracker->head);
> +		kfree(tracker);
> +		dir->quarantine_avail++;
> +	}
> +	list_for_each_entry_safe(tracker, n, &dir->list, head) {
> +		pr_err("leaked reference.\n");
> +		if (tracker->alloc_stack_handle)
> +			stack_depot_print(tracker->alloc_stack_handle);
> +		leak = true;
> +		list_del(&tracker->head);
> +		kfree(tracker);
> +	}
> +	spin_unlock_irqrestore(&dir->lock, flags);
> +	WARN_ON_ONCE(leak);
> +	WARN_ON_ONCE(refcount_read(&dir->untracked) != 1);
> +}
> +EXPORT_SYMBOL(ref_tracker_dir_exit);
> +
> +void ref_tracker_dir_print(struct ref_tracker_dir *dir,
> +			   unsigned int display_limit)
> +{
> +	struct ref_tracker *tracker;
> +	unsigned long flags;
> +	unsigned int i = 0;
> +
> +	spin_lock_irqsave(&dir->lock, flags);
> +	list_for_each_entry(tracker, &dir->list, head) {
> +		if (i < display_limit) {
> +			pr_err("leaked reference.\n");
> +			if (tracker->alloc_stack_handle)
> +				stack_depot_print(tracker->alloc_stack_handle);
> +			i++;
> +		} else {
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(&dir->lock, flags);
> +}
> +EXPORT_SYMBOL(ref_tracker_dir_print);
> +
> +int ref_tracker_alloc(struct ref_tracker_dir *dir,
> +		      struct ref_tracker **trackerp,
> +		      gfp_t gfp)
> +{
> +	unsigned long entries[REF_TRACKER_STACK_ENTRIES];
> +	struct ref_tracker *tracker;
> +	unsigned int nr_entries;
> +	unsigned long flags;
> +
> +	*trackerp = tracker = kzalloc(sizeof(*tracker), gfp | __GFP_NOFAIL);
> +	if (unlikely(!tracker)) {
> +		pr_err_once("memory allocation failure, unreliable refcount tracker.\n");
> +		refcount_inc(&dir->untracked);
> +		return -ENOMEM;
> +	}
> +	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
> +	nr_entries = filter_irq_stacks(entries, nr_entries);
> +	tracker->alloc_stack_handle = stack_depot_save(entries, nr_entries, gfp);
> +
> +	spin_lock_irqsave(&dir->lock, flags);
> +	list_add(&tracker->head, &dir->list);
> +	spin_unlock_irqrestore(&dir->lock, flags);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ref_tracker_alloc);
> +
> +int ref_tracker_free(struct ref_tracker_dir *dir,
> +		     struct ref_tracker **trackerp)
> +{
> +	unsigned long entries[REF_TRACKER_STACK_ENTRIES];
> +	struct ref_tracker *tracker = *trackerp;
> +	depot_stack_handle_t stack_handle;
> +	unsigned int nr_entries;
> +	unsigned long flags;
> +
> +	if (!tracker) {
> +		refcount_dec(&dir->untracked);
> +		return -EEXIST;
> +	}
> +	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
> +	nr_entries = filter_irq_stacks(entries, nr_entries);
> +	stack_handle = stack_depot_save(entries, nr_entries, GFP_ATOMIC);
> +
> +	spin_lock_irqsave(&dir->lock, flags);
> +	if (tracker->dead) {
> +		pr_err("reference already released.\n");
> +		if (tracker->alloc_stack_handle) {
> +			pr_err("allocated in:\n");
> +			stack_depot_print(tracker->alloc_stack_handle);
> +		}
> +		if (tracker->free_stack_handle) {
> +			pr_err("freed in:\n");
> +			stack_depot_print(tracker->free_stack_handle);
> +		}
> +		spin_unlock_irqrestore(&dir->lock, flags);
> +		WARN_ON_ONCE(1);
> +		return -EINVAL;
> +	}
> +	tracker->dead = true;
> +
> +	tracker->free_stack_handle = stack_handle;
> +
> +	list_move_tail(&tracker->head, &dir->quarantine);
> +	if (!dir->quarantine_avail) {
> +		tracker = list_first_entry(&dir->quarantine, struct ref_tracker, head);
> +		list_del(&tracker->head);
> +	} else {
> +		dir->quarantine_avail--;
> +		tracker = NULL;
> +	}
> +	spin_unlock_irqrestore(&dir->lock, flags);
> +
> +	kfree(tracker);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ref_tracker_free);
