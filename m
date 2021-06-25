Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB103B470A
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 17:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhFYP5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 11:57:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49400 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229738AbhFYP5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 11:57:34 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PFocsc002805;
        Fri, 25 Jun 2021 08:55:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=uweTxAw4AANpy+a4/WOarC4isghWooQBb1BBW9D+JMk=;
 b=L4x66a5RHCCRChqb8AzeclLn1tdKboYZ5ims60CRr6rmHuqDVbGHzJMq2W1kZd1dfFWP
 1vPm4yeMIirLEolLPGg33X8ZhPCH9sOYSEsGVHtNZOqlANA7VYC9Ck1hDGCVNusUIlz3
 XoVa4FoRoYDs2bC53gwYV62z0Ln4IZojdCA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39d255myx9-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 25 Jun 2021 08:54:59 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 08:54:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKCvw4ZjvUWQDkGmIzOWUKBwQ5D/9BFE3d+4cEjtFIs8hRizfl+Ig14demFFspkWuVnHBFzQhlON739sfcRkbrS8gaAOlmS4j4dleyh6b8WiVxRc5u/vUADR3e1XTGVLI2oBeUTjI02zQQ9TW3VoBT7XOCjvtROg3FkEbawYPhWU8r7oLF5hvDQwjeECoWHJuS3M2+YIt99ADD5kqGPE9INZWO9BOU0qTsXZUEljZaCrBggxvfHYRpD04jlRYQU6KZ4niOlx/AJxs6pnCgAi1bTJJDhyAXXw9Mq3vA17CqlauyaGYBYauHLUculbW0vppEvb6Q3+yW4OvbhUJbc/bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uweTxAw4AANpy+a4/WOarC4isghWooQBb1BBW9D+JMk=;
 b=IRXp20CSHEj/QhRaHlMLAe2StyeM8ymeT+Anwfz9uTmUxWAp6JfZUYh/iUdcpd2/IB27UE6igoh8PqieeXcUFcRO0h2yssRmLVsHywA1thF7PyEICd3iRDliC8QPv/W2OS/LQSjvneLin1X7/tF3PCRUrk4kcexVSmiUPq+KzMg9ILi8W7OvVtHEnRb+lh8cqyMyjvWyLOa2dirPigpD2YXog7n7SRnig4eqw/GBOv6pn819DeudHBzlwbnCJ/kNIgDDkdRfrHnTEq0LugyQjYNcCRKvsEvB5K19FLOhBMSgCYr2I1uvFoWusERSz9lAz9o4jIotQTvnQqqDPTetAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4659.namprd15.prod.outlook.com (2603:10b6:806:19e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Fri, 25 Jun
 2021 15:54:58 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 15:54:58 +0000
Subject: Re: [PATCH v3 bpf-next 1/8] bpf: Introduce bpf timers.
To:     Alexei Starovoitov <ast@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
 <20210624022518.57875-2-alexei.starovoitov@gmail.com>
 <4bf664bc-aad0-ef80-c745-af01fed8757a@fb.com>
 <de1204cc-8c20-0e09-8880-e39c9ee6d889@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <cfa10fa1-9ee4-95de-109d-a24cd5d43a98@fb.com>
Date:   Fri, 25 Jun 2021 08:54:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <de1204cc-8c20-0e09-8880-e39c9ee6d889@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:4ed3]
X-ClientProxiedBy: BYAPR06CA0036.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::49) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1328] (2620:10d:c090:400::5:4ed3) by BYAPR06CA0036.namprd06.prod.outlook.com (2603:10b6:a03:d4::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Fri, 25 Jun 2021 15:54:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acf791ab-b719-4c1b-692e-08d937f19571
X-MS-TrafficTypeDiagnostic: SA1PR15MB4659:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4659685B5DF30EEA3D0E7ED2D3069@SA1PR15MB4659.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QIuds0W/bMs73SrULXZVibBYz3lL1FzmRuU7ryRpqhtrNnbFMMkKe9naYAKXJVLRuZv7b0xr/xZRblMt9PYgGFrqjWKISlx9/kfp6SnZhC3aIrNvV9v+ykS/PaJh35IKZMdeDVybvBlEKA8ySCxdf2+f6ZUWrIAjlprcZ4RNjC4gTBq/ohybGmaqIxtyT58GbTkjnidnDvl+scCj4YoSNkogMVdKNx6jtzPuAGnIbNSQGDklmD2Yr95XO8g24mu9XJjfw+NMdzX+AANWOQVunFS5HzGJ+jEkw6e5bEBUepLlk4KsHkjXYOsVKjprCxOwo+k5f7VsLnTGe45taiVlnsUC6FhcEmAVlyIrljGZVneVgxWKCl6euxgqZ2EAx3XcJ3Bf+/5Pzr5mftjGFuo22HPTB+0JzVsPLX39tyHwa9wXeQP9h8SfY2ubEatb3bWNJV4shxpqcYGidcj4x2ipLGdJadv1D3dNJ0KXIiw7OSwRsAxCd33o1S0e0HPXqpt1/X8tCLVWD9iWVY0kUKA3Ds2vS3VQy/LlpGfzM+XtGwYC9fHj0GZnNbaA23B+LYWTKZ/GJ4esNKtIQcazTQBCb5fh+sTjcC13tDqKBRccs0G6ZIy8vVfEIHvfPV8gxGmYjuaVxuWbr43dCa8x7WcSSHqqlUvD9XHVuCMmm/rsvjv5l/ud/0ARZXFGySRN6xk3oH/0ER3VwEtmTCZD9vxT45YkbbjaGPSTnLBthZfIuDk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(66556008)(5660300002)(66476007)(110136005)(66946007)(316002)(38100700002)(2906002)(31686004)(83380400001)(6486002)(4326008)(186003)(16526019)(36756003)(31696002)(86362001)(53546011)(2616005)(478600001)(8936002)(52116002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFp3b2VWTWFWNjZUemFtTUtwT1hkLzZMdW5RRml2ZkU5T2hJRXVsMUtEWHJs?=
 =?utf-8?B?MDFVQnhtTnBVWGhYTFJESUtFNVRJYldmTmdaOEJ0VkhLZmZqVlQ2S2RmVHJw?=
 =?utf-8?B?YmRmbkJtTDNZWEVQNWVTRUxhV0xoRk43S1MrSm1SSVNrRHFnVDliTVluRXNQ?=
 =?utf-8?B?TEl0MFUwY1BlUHJad2FGTlY4N1VZNWRCZDZRUWx1bkFIOGxkVW9uWDROendB?=
 =?utf-8?B?YnVaaFpZcFhWeEdkbmIwTFlUajJkRjFBUUpQMmxqWm9IM0hSZFp3WEtmbXN1?=
 =?utf-8?B?UndLaE92Q3Mzcm5WajUrVEY3aGJUWU50SVhSVjIyVDB3NnZlVGtnMm81d2FP?=
 =?utf-8?B?NVM1L2FIOHdncVVQd2ZxOHY4WW80SUxJenV1WDJUaXl2TXFaSWFNdWtxT2RJ?=
 =?utf-8?B?bXN5UVdYQ2xoUEpSUGtGeGNzdUNjak9kTHJydFF6aGlwOCs1cXNDQUFyckx4?=
 =?utf-8?B?UTZHZXl0QVhpclJLcXh2VWc4RG5NRlJNM0REY2JkME5heG9hQlovenlid3J1?=
 =?utf-8?B?VjI2dlVJWFhWb0xtdHIyTk9vSDIzWDJTaTF5Z2szQWpDNTk4bDdzeXo5cmhJ?=
 =?utf-8?B?V2NITExLM0g1Z1pyWEg4dFVMbmJQN0NKTFllcnVpU1htQ2ZZT3lNUEVtcnNa?=
 =?utf-8?B?TnhGbUZtdTRyQjJhdlhwci9vbXFTWXk4V2NEQjhCdjhFR0ZpQTM3a2wreXM0?=
 =?utf-8?B?MFVjUXA3VkFicVNMRkNGdnJJZmJJc052bHA4bGl3eUx2MUxwUG04ckRUMW56?=
 =?utf-8?B?QkhDTHJiYVlnaThIZlNzQXd5K3h5VW5DSEpoRER4cno5aDgwUnBQT1pzbnVP?=
 =?utf-8?B?OHprTzhKWG9NdTBxVWpNSFdMMFJnUm93cGdmRFZ6c0FNcEQ0TTFXNm5GbXlE?=
 =?utf-8?B?QXU0dWlqbSszRUZGVmFWVUVVREVlU25XSUh6U1ZQRG5Sdi9BK29SR0ZXN0l3?=
 =?utf-8?B?aU9wUGFkOFV2OVFTL0JwaEgxMmlpVnRxVXIzOVk2ZnBPcDUrS3VEVEN5bGpY?=
 =?utf-8?B?b1FuenJWZXdoN2NZTjI5NTZEMjE5L0h1d3BMcUZUU1V3WUdEU2FQU3pzaG9q?=
 =?utf-8?B?azJkc1VxeEIzc1o0VFFnMzJwbGdHMWM0UFdyQktRYXpxVjRHNDAxM05zWXpH?=
 =?utf-8?B?b3hWTnEyL1o3bk9WaW9rc2NXSVVqVnJxSU53UUNsR3JNSW9QT255UDlJaVYv?=
 =?utf-8?B?ckcvTmx4Kzlid3JjQzNlOUk4elZPVTFUbFVibG43UCtETkl1bVRQNDdMcytu?=
 =?utf-8?B?SGdXOTczQmNiWStpdDJYbXY4NWpiYjRwWWFjMGFxMWdwaDB2NXFYY3AxakZK?=
 =?utf-8?B?ZUpXdWVwb0UrbzRSV1oweW5MNHB5TGROMHRkMmFqbWtxQzZEM3Q0TzRaK3Yy?=
 =?utf-8?B?dVJoUlZBTDlod05QRWE3ZGpQOUhBcVpKVVBhTFc3MDZ2S2hMVW5wekVDSzJU?=
 =?utf-8?B?Yk80UXpMRjVnUG9ia1hZRzZzV0pXWkFtcHhsVktPMGZRemFkaG5waUpyNHJp?=
 =?utf-8?B?b3h6bG9CUnh3SEkyOS8vUFQrYmwvME52UzZFem5RVG5Bc0o3ZlkvRVBzeTlI?=
 =?utf-8?B?RkF5ZCs3eTExalJ3eWg5MGFXcUk5VS9nZENPWWw1eHphZ0tDcW5yZ0EzQmpl?=
 =?utf-8?B?YkJaSnVxbE1OaXVwTVBQUFpla2QzMk9LbGMwWXdlVHB3cTFMdksxWmM1Q2NY?=
 =?utf-8?B?T2ZRMlNTZWswdEU4eG5wMytDNUdHdVlUeXNpU2RYMTE3dXF2dnU2dGVTT3lV?=
 =?utf-8?B?bDRvVHlBYjY2c0F5Uk9WK2JvV1kwemNab2dLOUorVWdvM0ZNWFpMQmorNndm?=
 =?utf-8?B?MGs3Z1ZkZXpNNkJZNmxvZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: acf791ab-b719-4c1b-692e-08d937f19571
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 15:54:58.5018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZkHClMEzNJ+scOfcZClP6khiVA7a5+5MsVGRPykkeV8uONeLMKYHHzgmeBDJQoS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4659
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: TIsD7wBhgKjI6ciAcf5B6HzqhxUfFbzN
X-Proofpoint-GUID: TIsD7wBhgKjI6ciAcf5B6HzqhxUfFbzN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_06:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 phishscore=0 spamscore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250093
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/21 7:57 AM, Alexei Starovoitov wrote:
> On 6/24/21 11:25 PM, Yonghong Song wrote:
>>
>>> +
>>> +    ____bpf_spin_lock(&timer->lock);
>>
>> I think we may still have some issues.
>> Case 1:
>>    1. one bpf program is running in process context,
>>       bpf_timer_start() is called and timer->lock is taken
>>    2. timer softirq is triggered and this callback is called
> 
> ___bpf_spin_lock is actually irqsave version of spin_lock.
> So this race is not possible.

Sorry I missed that ____bpf_spin_lock() has local_irq_save(),
so yes. the above situation cannot happen.

> 
>> Case 2:
>>    1. this callback is called, timer->lock is taken
>>    2. a nmi happens and some bpf program is called (kprobe, tracepoint,
>>       fentry/fexit or perf_event, etc.) and that program calls
>>       bpf_timer_start()
>>
>> So we could have deadlock in both above cases?
> 
> Shouldn't be possible either because bpf timers are not allowed
> in nmi-bpf-progs. I'll double check that it's the case.
> Pretty much the same restrictions are with bpf_spin_lock.

The patch added bpf_base_func_proto() to bpf_tracing_func_proto:

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 7a52bc172841..80f6e6dafd5e 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1057,7 +1057,7 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, 
const struct bpf_prog *prog)
  	case BPF_FUNC_snprintf:
  		return &bpf_snprintf_proto;
  	default:
-		return NULL;
+		return bpf_base_func_proto(func_id);
  	}
  }

and timer helpers are added to bpf_base_func_proto:
@@ -1055,6 +1330,12 @@ bpf_base_func_proto(enum bpf_func_id func_id)
  		return &bpf_per_cpu_ptr_proto;
  	case BPF_FUNC_this_cpu_ptr:
  		return &bpf_this_cpu_ptr_proto;
+	case BPF_FUNC_timer_init:
+		return &bpf_timer_init_proto;
+	case BPF_FUNC_timer_start:
+		return &bpf_timer_start_proto;
+	case BPF_FUNC_timer_cancel:
+		return &bpf_timer_cancel_proto;
  	default:
  		break;
  	}

static const struct bpf_func_proto *
pe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
{
         switch (func_id) {
...
         default:
                 return bpf_tracing_func_proto(func_id, prog);
         }
}

static const struct bpf_func_proto *
kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog 
*prog)
{
...
         default:
                 return bpf_tracing_func_proto(func_id, prog);
         }
}

Also, we have some functions inside ____bpf_spin_lock() e.g., 
bpf_prog_inc(), hrtimer_start(), etc. If we want to be absolutely safe,
we need to mark them not tracable for kprobe/kretprobe/fentry/fexit/...
But I am not sure whether this is really needed or not.

> 
>>
>>> +    /* callback_fn and prog need to match. They're updated together
>>> +     * and have to be read under lock.
>>> +     */
>>> +    prog = t->prog;
>>> +    callback_fn = t->callback_fn;
>>> +
>>> +    /* wrap bpf subprog invocation with prog->refcnt++ and -- to make
>>> +     * sure that refcnt doesn't become zero when subprog is executing.
>>> +     * Do it under lock to make sure that bpf_timer_start doesn't drop
>>> +     * prev prog refcnt to zero before timer_cb has a chance to bump 
>>> it.
>>> +     */
>>> +    bpf_prog_inc(prog);
>>> +    ____bpf_spin_unlock(&timer->lock);
>>> +
>>> +    /* bpf_timer_cb() runs in hrtimer_run_softirq. It doesn't 
>>> migrate and
>>> +     * cannot be preempted by another bpf_timer_cb() on the same cpu.
>>> +     * Remember the timer this callback is servicing to prevent
>>> +     * deadlock if callback_fn() calls bpf_timer_cancel() on the 
>>> same timer.
>>> +     */
>>> +    this_cpu_write(hrtimer_running, t);
>>
>> This is not protected by spinlock, in bpf_timer_cancel() and
>> bpf_timer_cancel_and_free(), we have spinlock protected read, so
>> there is potential race conditions if callback function and 
>> helper/bpf_timer_cancel_and_free run in different context?
> 
> what kind of race do you see?
> This is per-cpu var and bpf_timer_cb is in softirq
> while timer_cancel/cancel_and_free are calling it under
> spin_lock_irqsave... so they cannot race because softirq
> and bpf_timer_cb will run after start/canel/cancel_free
> will do unlock_irqrestore.

Again, I missed local_irq_save(). With irqsave, this indeed
won't happen. The same for a few comments below.

> 
>>> +    prev = t->prog;
>>> +    if (prev != prog) {
>>> +        if (prev)
>>> +            /* Drop pref prog refcnt when swapping with new prog */
>>
>> pref -> prev
>>
>>> +            bpf_prog_put(prev);
>>
>> Maybe we want to put the above two lines with {}?
> 
> you mean add {} because there is a comment ?
> I don't think the kernel coding style considers comment as a statement.
> 
>>> +    if (this_cpu_read(hrtimer_running) != t)
>>> +        hrtimer_cancel(&t->timer);
>>
>> We could still have race conditions here when 
>> bpf_timer_cancel_and_free() runs in process context and callback in
>> softirq context. I guess we might be okay.
> 
> No, since this check is under spin_lock_irsave.
> 
>> But if bpf_timer_cancel_and_free() in nmi context, not 100% sure
>> whether we have issues or not.
> 
> timers shouldn't be available to nmi-bpf progs.
> There will be all sorts of issues.
> The underlying hrtimer implementation cannot deal with nmi either.
