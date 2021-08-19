Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3753F20AB
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 21:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbhHSTdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 15:33:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:63558 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234838AbhHSTdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 15:33:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="216363100"
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="216363100"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 12:33:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="679605045"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 19 Aug 2021 12:33:01 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 19 Aug 2021 12:33:00 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 19 Aug 2021 12:33:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 19 Aug 2021 12:33:00 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 19 Aug 2021 12:32:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lK4wwfv05BcCF5faR/rO3fpVq2X6KNRTl+p65+i6yVvJFrfYtq5zntiOvvVUS7eUY43THmQKSDrTxGnRiBJs18xJkP8Gow+9rc085O5YDbdHuzxBEsTOe8XT+PV9TOcwRGKiC1+frep6hW8+nX2dSkdYIS/N5X/CYcr5ZQ1n4ZPow2lNGO0lbs3zzGcsmFsVdnj7KtbOZnTlrcndKmQRoTm/8/uGmyHmDlf4SJzurXA5JJKN6LV8k/aiCZ8Ifbvxdv9U+j0XHQ9VukZbbcthZ2PRrWlbgBVYlEQfWwLeeCiWlbhWg+KlJm6zKlqEhFlhzTxHP+eZkMteb/jQTd9KWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrOd1m/SOqhtuLLA7c38drYfrJzpafJD7Iuii28g8Ns=;
 b=GuLCgxG9SLp4VIqDVtLbZ1Q8SwcBnaJHOEiwHgqBZKHffSKRWOUpEU6bVVztnk2CToFV4sE/oqTMz3y3OHZPg1gY2XJFuCzDjGaP+IWKVzpUFsl2cX7WudLB1EzGdbj+dUSzbF1Z3H8ugYKoih5BtH14VXQIaqelJGmFJ6kV2SbBhPER7jQFmIT5GtTo5n5bID8zzgSWwMHy4QKMMlrop8xVhSABzDuDjt8AJ3EOq4jZ2PGczHij0lMsc7mb3tqn1pepJG8itgJPqYCd5JiTRmOghtPEHIPJbbaY3JaXonP5GLLakbgONDCr0fWjinSu8yX5mqMb1VNifdQaw6ZCOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrOd1m/SOqhtuLLA7c38drYfrJzpafJD7Iuii28g8Ns=;
 b=DdEiOCCiUdUbAhk2YyO+42/AJRHoNFfNU7+4lpPNfTubkr8GpYMtybF520puo4g4HYvfza2z7zXBnYaImdMjfEhG3oJjaf6Qr/JAgwP4U/eBNfaleNiCmQaPoolmAfUabhSr2L6LM2ZsdQpXGO9cBC5Vm/XQXFYyIo+IAGz39x4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5140.namprd11.prod.outlook.com (2603:10b6:303:95::6)
 by MWHPR1101MB2365.namprd11.prod.outlook.com (2603:10b6:300:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 19:32:58 +0000
Received: from CO1PR11MB5140.namprd11.prod.outlook.com
 ([fe80::1968:cbde:518e:2acb]) by CO1PR11MB5140.namprd11.prod.outlook.com
 ([fe80::1968:cbde:518e:2acb%9]) with mapi id 15.20.4415.025; Thu, 19 Aug 2021
 19:32:58 +0000
Subject: Re: [RFC bpf-next 2/5] libbpf: SO_TXTIME support in AF_XDP
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <hawk@kernel.org>,
        <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jithu Joseph <jithu.joseph@intel.com>
CC:     <brouer@redhat.com>
References: <20210803171006.13915-1-kishen.maloor@intel.com>
 <20210803171006.13915-3-kishen.maloor@intel.com>
 <31fb6a84-562e-a41d-0614-061e1f475db3@redhat.com>
From:   Kishen Maloor <kishen.maloor@intel.com>
Message-ID: <b3c05e8d-bb93-0287-2a96-e8d7f690be83@intel.com>
Date:   Thu, 19 Aug 2021 15:32:55 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <31fb6a84-562e-a41d-0614-061e1f475db3@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CO2PR04CA0132.namprd04.prod.outlook.com
 (2603:10b6:104:7::34) To CO1PR11MB5140.namprd11.prod.outlook.com
 (2603:10b6:303:95::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jhatkins-mobl1.amr.corp.intel.com (96.250.176.213) by CO2PR04CA0132.namprd04.prod.outlook.com (2603:10b6:104:7::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 19:32:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bebf0502-def2-4acb-4e47-08d96348269c
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1101MB2365255FF013A9574F9022FEE1C09@MWHPR1101MB2365.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ars9RGQrFm8w8yrFkn/2IGvSl+lqEgbJ8eEOjBpUGWHdhIjUf5Mgw6yEnbdoih7TKCU0bXsG+YjeNADx9YVdHfBuot3pcwuoDDAeLh6K/tDlR8uLFtt7paxDyHSlf8Kcco5PA+s9x80UWfumsYQyRyeqYeOAQJAcFT0ZdTnBwqm1LNGjAvn2GuVveMinOv0OXut+uh2Veqsn2Gj28ow5uDd6SEjaptdNLozQPTaJJfkswi0WWuHMZyaQOgwfz226J4LWVYgc9Y7PMrnG/6vs/dWcu9/Lroc3gHLAyWBCQcFOLSKlElB+/p28izTlF1/P9mQvsJuNW0r4WX+34ATdx88fUJFUu+u9YpiLcjCOQu89zHQwNR9RV39Mt2QaEAa1yJkv7iQ1jdd+eWIAQ4MxLRAEkjaKVu87JBNJFZFbFitoWZ5QCq6KNPh1Ayduo9ljQ0tNhoAzHJe/YIsDSgBBxe2V5a8JtusjurxmYw/+dYkOHWCIBaDGU54LvobBlPSRitUzSMHTuFAl190ebu9J6xRI5K+Or7rjz1scH8BFxLIOu3BxzhgbMuwtjV7lCfJskO5B47091y3wHg2BeGCS8m8VyJTEtsNHKE3bwsbUHxevBsdH/t6y/2/r8I2gnkw+gw1la9hxMmi2dmzJzfW+HHk/T9LcdrCt8sNySNlfI8/+vwduomVCkS8vQiX0AUcuseFPASyxDrKS7NCZ0VDPwgVPk6CBI8RkUtarB+dknGOmlaRlZxAxh8CRzHpRhfG6aDBVJ9dpZSjyqSc3gesJgkqb8EHUwz5uGVlhINusswkA4V/SCUWneD+qfxN8n4l7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5140.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(86362001)(31696002)(8936002)(316002)(110136005)(38100700002)(478600001)(36756003)(8676002)(4326008)(31686004)(53546011)(6486002)(956004)(66946007)(2906002)(66556008)(66476007)(44832011)(83380400001)(5660300002)(26005)(966005)(2616005)(7696005)(186003)(6636002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SllrNXNqbkFSTG1OcWVYMVdrMFpsTy94T0tsNHZ6aVkvMStHZlJ4bFN3S2J0?=
 =?utf-8?B?SGdIb25IQ2k5dUJ4MUdoaXN0Nlc4S0poNm1DeVpqNS9RSDVQbm9PZ1ZaSzZQ?=
 =?utf-8?B?T0t1NGNBbWdYQzcvd3hlZ0VUWVlzNzRYN3orVUhVZUZialBzeThTTDlUQndq?=
 =?utf-8?B?SnNtcVY4T1lobTJFMXJIRkR3N2p0dFZXVmNSNU9oL0NkYmRhYXVQNUVld0ZN?=
 =?utf-8?B?WWtDdlNqWDJYb3FhZXdtMUh1TEduSHIyNjBGS2twSEdHZGVZUkdGY21TbzBi?=
 =?utf-8?B?SWZJanB5MVVKaTFSOGVLNjJWUnlBdkh1aW1XTk1WSEs1cmc4ZENOaElwajJj?=
 =?utf-8?B?QklRREFJWVBITjJDejhmUmYxdGpucGxuMUpFZkZrc2R4eEZFL2Q2Z2VjSHVi?=
 =?utf-8?B?QjVGK1d6UXpqUHhXSzZNY1ozVmpkZzRWTDV1MzM5QXd0THRtNlU4dk9hRjM5?=
 =?utf-8?B?WmhYeHBLVEdrYUdmTkNYdWhlQmxPM3ZaYWoyWjF0dHNoemcrSHZOR00wWEVI?=
 =?utf-8?B?V2hlYVZoMEdYenNDanRXbDZyYjczYnRuQ1NsVUhJcmhrNWRsMzBjRURCM3Vz?=
 =?utf-8?B?MTc5dkZoTmVwR2I0Z3ZmSzZFdlpXQ01lSXl1Tll2TXpyRmpkVkRZQWRTSzU5?=
 =?utf-8?B?UERocEF6ZlNXditoRjlOOXgvMXFwbEYvMmUySjVMU0lhS0NIOXg0MWNlMEd0?=
 =?utf-8?B?ZENUMFF3bnM1cWNkTktremFLOUxSY1ZTeHJlb2MvSmJlc0lYQTg5U0pvRmE3?=
 =?utf-8?B?WE13cVVRWVQvSVk5OGVpRHdrNEF2ZGJkQXhQemYwTUc4bnhZTU80dStsWGVT?=
 =?utf-8?B?azVKWUhmenNyR2hsMXVJS2dSZ1VNMXlwWmJkT2djZ0t0U01EV3YwK0QyQ0V6?=
 =?utf-8?B?bFFocTBDdm9PYm84TWVNUUlYT0NnV0JXd1FINkkxR0FHQm5yMDEwSUNnTnFX?=
 =?utf-8?B?R0dYanhvRXlMV0hrM2xhT0xqL0h5RDBzVmpodUNPeUczdlZ3ZFRVODVUbEpi?=
 =?utf-8?B?UU9JU3ZuY1pBVVNhUUEyQnk4dXk1WnVjQzlOeTlSOVV5MWVvRVp4S08ySXQ3?=
 =?utf-8?B?ekQwOXE1NWc4YldDRTM4QmE3S3dTTEFPKzNteEVEdnFuL1RWZlRHaGF0blZY?=
 =?utf-8?B?c3VyWWZHZytPeUtUQ3Bsb295N1BPekFSVFByVGFJN09zbm5Hd2FBT1Rpek1J?=
 =?utf-8?B?ZDdRUk04UWdQYlhQWXdHZ0JzT0JVWWFnekxJdDdnZVNheUttcy84MlltNzNl?=
 =?utf-8?B?Wnc2YWZlYzhTZGtXYVRFWmhZRGtDSEJwR2Q4VUh5WjF1TGQ4Vm01ZWlaZWFW?=
 =?utf-8?B?bUN3dkZKUXhUZFh1TWRmV3ovSHVDNFo1VU1BSW9GQktaSHFScDQ5N3lwNTdW?=
 =?utf-8?B?aTMxSVh3TE1lem85dHZIa3FmVkFUT1phRThTR0VRRWwxRGhFVUxmZ1JUVnpk?=
 =?utf-8?B?eFRKcDc2Rnp4U0tkQUd3M0NuSFNWYnEySUl6S2orYW9nSitnYmx2bUdUVTh5?=
 =?utf-8?B?MFdQTjFJR1gvK3B5SzBuN3JnemFqYUFOYWh2TGp5ZXgrRWtBWFJtTVE1UEZn?=
 =?utf-8?B?RnRhaWZNVjVaYVBlTUlONnNNMWdEWWxPN3dWZjBCUFNWbVo5Wm9IRC9Bb2Ja?=
 =?utf-8?B?a0tubllTSVJjd0xSTEl4SVJ5MTJrSDBxaGh5d3RQSUdRV2J6MVBEV1RpdEtC?=
 =?utf-8?B?T0hPWGpRVjQxMzBOOXd5elJ4eFFqdnU1SzRFRmZiYUxVencxS1l1cEJsTTMw?=
 =?utf-8?Q?UeA3gTCmn4/yGToYUuGYedyu7KPnRtT7+tR9C5z?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bebf0502-def2-4acb-4e47-08d96348269c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5140.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 19:32:58.8020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CbdCIEC64CbxY2uoZz+aUt9vO4pa9XXXAmws9C5GoL1KbZg830tGIMqLavJdu43K4VIuhRuaTQ2TuNLYckpf6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2365
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/21 5:49 AM, Jesper Dangaard Brouer wrote:
> 
> 
> On 03/08/2021 19.10, Kishen Maloor wrote:
>> This change adds userspace support for SO_TXTIME in AF_XDP
>> to include a specific TXTIME (aka "Launch Time")
>> with XDP frames issued from userspace XDP applications.
>>
>> The userspace API has been expanded with two helper functons:
>>
>> - int xsk_socket__enable_so_txtime(struct xsk_socket *xsk, bool enable)
>>     Sets the SO_TXTIME option on the AF_XDP socket (using setsockopt()).
>>
>> - void xsk_umem__set_md_txtime(void *umem_area, __u64 chunkAddr,
>>                                 __s64 txtime)
>>     Packages the application supplied TXTIME into struct xdp_user_tx_metadata:
>>     struct xdp_user_tx_metadata {
> 
> Struct name is important and becomes UAPI. I'm not 100% convinced this is a good name.

Sure, we can choose a better name. Open to suggestions.

> 
> For BPF programs libbpf can at load-time lookup the 'btf_id' via:
> 
>   btf_id = bpf_core_type_id_kernel(struct xdp_user_tx_metadata);
> 
> Example see[1]
>  [1] https://github.com/xdp-project/bpf-examples/commit/2390b4b11079
> 
> I know this is AF_XDP userspace, but I hope Andrii can help guide us howto expose the bpf_core_type_id_kernel() API via libbpf, to be used by the AF_XDP userspace program.
> 
> 
>>          __u64 timestamp;
>>          __u32 md_valid;
>>          __u32 btf_id;
>>     };
> 
> I assume this struct is intended to be BTF "described".

Yes, the intention here was to be future-proof in a sense, as once all the related infrastructure/tooling for BTF comes into existence, it should hopefully be a 
simple matter to adapt this code to work with that.

> 
> Struct member *names* are very important for BTF. (E.g. see how 'spinlock' have special meaning and is matched internally by kernel).
> 
> The member name 'timestamp' seems too generic.  This is a very specific 'LaunchTime' feature, which could be reflected in the name.

Yes, LaunchTime is the specific use case addressed by this RFC, so open to suggestions on the struct member name (e.g. launch_time?).

> 
> Later it looks like you are encoding the "type" in md_valid, which I guess it is needed as timestamps can have different "types".

No, the purpose of md_valid is to flag all those md fields that have been set/conveyed by this metadata. So, XDP_METADATA_USER_TX_TIMESTAMP is 
meant as a reference to the 'timestamp' field in struct xdp_user_tx_metadata.

> E.g. some of the clockid_t types from clock_gettime(2):
>  CLOCK_REALTIME
>  CLOCK_TAI
>  CLOCK_MONOTONIC
>  CLOCK_BOOTTIME
> 
> Which of these timestamp does XDP_METADATA_USER_TX_TIMESTAMP represent?
> Or what timestamp type is the expected one?

CLOCK_TAI is what we use for LaunchTime, and supported by IGC/i225.

> 
> In principle we could name the member 'Launch_Time_CLOCK_TAI' to encoded the clockid_t type in the name, but I think that would be too much (and require too advanced BTF helpers to extract type, having a clock_type member is easier to understand/consume from C).
> 
> 
>>     and stores it in the XDP metadata area, which precedes the XDP frame.
>>
>> Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
>> ---
>>   tools/include/uapi/linux/if_xdp.h     |  2 ++
>>   tools/include/uapi/linux/xdp_md_std.h | 14 ++++++++++++++
>>   tools/lib/bpf/xsk.h                   | 27 ++++++++++++++++++++++++++-
>>   3 files changed, 42 insertions(+), 1 deletion(-)
>>   create mode 100644 tools/include/uapi/linux/xdp_md_std.h
>>
>> diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
>> index a78a8096f4ce..31f81f82ed86 100644
>> --- a/tools/include/uapi/linux/if_xdp.h
>> +++ b/tools/include/uapi/linux/if_xdp.h
>> @@ -106,6 +106,8 @@ struct xdp_desc {
>>       __u32 options;
>>   };
>>   +#define XDP_DESC_OPTION_METADATA (1 << 0)
>> +
>>   /* UMEM descriptor is __u64 */
>>     #endif /* _LINUX_IF_XDP_H */
>> diff --git a/tools/include/uapi/linux/xdp_md_std.h b/tools/include/uapi/linux/xdp_md_std.h
>> new file mode 100644
>> index 000000000000..f00996a61639
>> --- /dev/null
>> +++ b/tools/include/uapi/linux/xdp_md_std.h
>> @@ -0,0 +1,14 @@
>> +#ifndef _UAPI_LINUX_XDP_MD_STD_H
>> +#define _UAPI_LINUX_XDP_MD_STD_H
>> +
>> +#include <linux/types.h>
>> +
>> +#define XDP_METADATA_USER_TX_TIMESTAMP 0x1
>> +
>> +struct xdp_user_tx_metadata {
>> +    __u64 timestamp;
>> +    __u32 md_valid;
>> +    __u32 btf_id;
>> +};
>> +
>> +#endif /* _UAPI_LINUX_XDP_MD_STD_H */
>> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
>> index 01c12dca9c10..1b52ffe1c9a3 100644
>> --- a/tools/lib/bpf/xsk.h
>> +++ b/tools/lib/bpf/xsk.h
>> @@ -16,7 +16,8 @@
>>   #include <stdint.h>
>>   #include <stdbool.h>
>>   #include <linux/if_xdp.h>
>> -
>> +#include <linux/xdp_md_std.h>
>> +#include <errno.h>
>>   #include "libbpf.h"
>>     #ifdef __cplusplus
>> @@ -248,6 +249,30 @@ static inline __u64 xsk_umem__add_offset_to_addr(__u64 addr)
>>   LIBBPF_API int xsk_umem__fd(const struct xsk_umem *umem);
>>   LIBBPF_API int xsk_socket__fd(const struct xsk_socket *xsk);
>>   +/* Helpers for SO_TXTIME */
>> +
>> +static inline void xsk_umem__set_md_txtime(void *umem_area, __u64 addr, __s64 txtime)
>> +{
>> +    struct xdp_user_tx_metadata *md;
>> +
>> +    md = (struct xdp_user_tx_metadata *)&((char *)umem_area)[addr];
>> +
>> +    md->timestamp = txtime;
>> +    md->md_valid |= XDP_METADATA_USER_TX_TIMESTAMP;
> 
> Is this encoding the "type" of the timestamp?

No, it is hinting at the field (timestamp) being conveyed in this metadata.

> 
> I don't see the btf_id being updated.  Does that happen in another patch?

No. As I understand, BTF support and it's overall applicability (particularly from AF_XDP userspace) is still a WIP. So, btf_id currently exists as a 
placeholder to facilitate future BTF integration.
 
Meanwhile, this RFC re-purposes SO_TXTIME on the control path from AF_XDP userspace to exercise the LaunchTime feature in the presented pattern.

> 
> As I note above we are current;y lacking an libbpf equivalent bpf_core_type_id_kernel() lookup function in userspace.
> 
>> +}
>> +
>> +static inline int xsk_socket__enable_so_txtime(struct xsk_socket *xsk, bool enable)
>> +{
>> +    unsigned int val = (enable) ? 1 : 0;
>> +    int err;
>> +
>> +    err = setsockopt(xsk_socket__fd(xsk), SOL_XDP, SO_TXTIME, &val, sizeof(val));
>> +
>> +    if (err)
>> +        return -errno;
>> +    return 0;
>> +}
>> +
>>   #define XSK_RING_CONS__DEFAULT_NUM_DESCS      2048
>>   #define XSK_RING_PROD__DEFAULT_NUM_DESCS      2048
>>   #define XSK_UMEM__DEFAULT_FRAME_SHIFT    12 /* 4096 bytes */
>>
> 

