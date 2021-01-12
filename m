Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3485D2F28FF
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732913AbhALHfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:35:05 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37490 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727959AbhALHfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 02:35:04 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10C7VtcV013439;
        Mon, 11 Jan 2021 23:33:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=F7pO5LpJvkFs0eKLBj7V3fRpF6y27PkIoc8ZWScoTFE=;
 b=anNpXry5y0VsrH1jvoq8PWDBA2pmZAAJM9LdzMvlBEz2XBqRRNe8ncm38VWDEd6xnwij
 OyPt0wDX9csRxSnM4zN7871z2m9ylRUdIY6Uy0ZS0E7xSm6O+AqFj2hI1ZI0/iIv0jUb
 842yYBy0GYdLC0ynEcW1DGVbNSdgYUKEiUA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35yw1phbe2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 23:33:54 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 23:33:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3yUhwbB4v1dSOOMUhR2UGa3FM8/3aJU6GTnzgr5+QNMXFQuK5/Fl7NEjkgw4bJihQeFBi2tyJ4C4HU6nBqiu7xN3gw7Kdi+53/qPXTJBtRp7LNkhPgtqxQd0NtqOWHChKD6K3KMoNdbIfFinYFREEd4Pr4hyRyv7PcfJsOJXg47gUff3vkhl1Spq2KaTygbvYF9QHcXbwOcbP+r+YcIS3XXTJdzfiIDw10fsRPIHAFDAw/0BMb0n+mZ1NkYHizAZrURYZgcugSJq4gQpozcU8cOMUcz/6i9SLMABPUJ8paqx8chOal09T/vgLBthqtL0byaa9m14K8ht8la6sCZOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7pO5LpJvkFs0eKLBj7V3fRpF6y27PkIoc8ZWScoTFE=;
 b=Vrumhf4Gz0TzEcSYbXG1PXOSPDsVNFzU1tPcrLptuuJ+hlrIN117kLXqOQU5zGrCGSojtP4LB3pbZ+gEr5sPs2w8/UgTdOUbjcjYsM36D1WlL17uYoMb+v9ZW6JTv5eFQxcOm5qCbiVLyPPKZmuOvKB1z0+OCa9r9wulyNoWhVnZFaLW2t08gvsW3MdtoQP1ufwQRPbqx0hjDo1Z14XJGRfKlGoTDED3rQHYYDvD9cWqryGgilvJKaYYmjUT7aXemfnj3yV7vQiCq7v2soZyhO/tOxle+/CGzoew5mWRPIsb6VLUFwD/aTUxaNym/tzSftCu2jgr9yNTLpO7Yl2YIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7pO5LpJvkFs0eKLBj7V3fRpF6y27PkIoc8ZWScoTFE=;
 b=h4vhMqOQjGa7S2wqMKodr7dy/VDKnNlKrzO02m3IgcIBiZvTcb3FdEnv5siN5yUYKjJ80NAWMwyOmL2ggFShaiKdW+HYz4f5lq+zrS86M+VNMU79PYVbaNhNrqwwdrDkyY+4yIZgSd228hjAmBff4w76/cqIilpTUelhk/B7KY4=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3191.namprd15.prod.outlook.com (2603:10b6:a03:107::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 07:33:46 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 07:33:46 +0000
Subject: Re: [PATCH bpf-next 4/4] bpf: runqslower: use task local storage
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>,
        "haoluo@google.com" <haoluo@google.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-5-songliubraving@fb.com>
 <ad40d69d-9c0f-8205-26df-c5a755778f9e@fb.com>
 <352FED72-11B3-44F0-9B1C-92552AEB4AE8@fb.com>
 <e890e08e-99d0-9d81-b835-c3a1b4b8bbbf@fb.com>
 <CAEf4BzZivGBmDbUxfiDwAC3aFoTWNfyWaiZRA4Vu16ZT9kzE8A@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <8d9983c4-2842-e2f8-94ce-1676977bb720@fb.com>
Date:   Mon, 11 Jan 2021 23:33:42 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <CAEf4BzZivGBmDbUxfiDwAC3aFoTWNfyWaiZRA4Vu16ZT9kzE8A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:4443]
X-ClientProxiedBy: MW4PR03CA0234.namprd03.prod.outlook.com
 (2603:10b6:303:b9::29) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::190b] (2620:10d:c090:400::5:4443) by MW4PR03CA0234.namprd03.prod.outlook.com (2603:10b6:303:b9::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 07:33:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08635121-cd66-4d3e-6d53-08d8b6cc65a4
X-MS-TrafficTypeDiagnostic: BYAPR15MB3191:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3191E04E53250D818AB8E8CDD3AA0@BYAPR15MB3191.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FJNFzMQOjoi4t5V7mDHwU/hdn0N0rUpx/DiKMPPCQbFgrxk8MMoLeLx5lp3NFsWbuEd5q7khmlDcX4f0bd3bZV+zZ8zf81f7webbxjG/9G2O0cfqkXq1OnJIDCw6hqO+NPCJQexAB6+k1eOQD6uXSfB+SLmIB4i6nqndRvh0bAi5FejLE2+zIFGBZdpq3ZjXBILSqvzyh2Hz0UJKJl3F/wVaJgjAlPm+fxvDpUx9ICrzNra2/UAQNSJDVsrcy3txD7pdGOxl3twxqe6Dk2+NiHvC+FwnQydW8xvUNQDNKc3iVD5hDMyIBl46uYNNyPmn+QDJWTVbjIgnIIbs14zpkd5IX8k/MghF+U5vzzPdX7d8BItdhhfu8TtVznbMkKTAzEgJzKPWKID7P12kwjQDaeIUWzZiuJ2Mre6ptkGUXNQi6nr6NrOcKm8LYyLo/Z8XkcRxyStFJG7WF552W1mQydybVGzvLIGMsCUxXQbYtD8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(376002)(136003)(346002)(6666004)(2616005)(186003)(6486002)(66476007)(16526019)(53546011)(8936002)(52116002)(5660300002)(6916009)(4326008)(31696002)(66556008)(31686004)(478600001)(86362001)(54906003)(316002)(2906002)(7416002)(83380400001)(8676002)(66946007)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MkdROW5MZXdVQzhSRkpWRmp6R2ltWVp4ZXZqdEYzTEJtN3EvbEJXdjNHUnlE?=
 =?utf-8?B?NnF4ZVo4SXpqT21OV2xBOXFOYnFnVFptNzdycmhCYldHWmhjSFIraU1wclJR?=
 =?utf-8?B?YzlrNE80TUJiZWpwUytMVit0MEpzR3JIV2lRWWwwaUo3RnNEMnNZajUrUzZW?=
 =?utf-8?B?Y3JLUW9OTXlhQThoV3dzeFlFMGxielZCa3dBTTRsbG5vdEpXdG5kaXNxVzlW?=
 =?utf-8?B?Z0xMcHJRRERGYnFPOEw5ZUtxd2RONXVKcUZxMk55ZWJMcGJPaUxHMzNwNGxU?=
 =?utf-8?B?VU9pbkg2TUU3c1llMlc3QktTRy9GeE5KYVRXQ3FNRGwyWWJkT2tDSVB0REht?=
 =?utf-8?B?Zk8xUk5EbXFSRXhBVVVHd2tLcDc0d2tEaHRNTVhvL0Fyd2dJMEUrcG5zRitF?=
 =?utf-8?B?UkJSMDcvdkVqYmZXaXVNWXE2cjUxU1VNb2VyVWtnWUw2MzkvT1dZUmR2VVRw?=
 =?utf-8?B?dEEzbGhBSDl3NXN0ckN6V1lMbmxWWWNWSXFyY0dsTU9pS3F3REEzbFFraXpU?=
 =?utf-8?B?MzgybEtzTG9Pb01VSGJaalRML29hVVZrcUMvOTkvUnhzSHRYcHNhVlFWaHp3?=
 =?utf-8?B?MnZodi90eG1zQ1NvL0ZVV1U1TzMwMU9tMDN1bHkwZGRlZ3NJaEJxWkpTZC9U?=
 =?utf-8?B?NGdrbUZFdFVkd3ZrY2ZTSG1Ub3dXbzFYbmlTVXg0MDhzZEcvd1I3WDFUV1RW?=
 =?utf-8?B?Q0ZzZVJrNVF0aTVOV0VBTUhPQURRR0MwdnZLNzljcGc2Y3RxQlhFQ0xPbkdl?=
 =?utf-8?B?bGREdi9ZYmdacGN3b2tlK0g2TjY4aFNQam1NR3NNcVZtN0J2K0QwS2Z4aHYw?=
 =?utf-8?B?YTQrUFExekNXdzhDMndRd1MwelRQbkRxS3grMWd2ZzRpdDZYN2tXeFlsK0hV?=
 =?utf-8?B?S3JNMWJDMnVWelFmQnlNL2gvVVU4VmF1RHZXbG9HYzRIVURaL3RBTEVaell4?=
 =?utf-8?B?M2h5dnRuQUZRTm50Q01sSHdqVXhmMEN1S3JnOGQzbC9KR2JLU1NGTkh3YzA0?=
 =?utf-8?B?UXhtZE9TeFl4ZkxaWGFmTDEwelJ2WGpmQVdpSUtiTHZJWlAxcW1ZTFdETWJo?=
 =?utf-8?B?K1d0WnY4Mmt5Q2l6SmpLeEdVcVBpRC9OL1E5dUtvL1poZklqOHIvT0RIMGVG?=
 =?utf-8?B?K0g5MzhIZnVUSXQySEtJcjQ3YU1GcmJZRUNjUyt6ZzN3UEc1N2lBM3padWwv?=
 =?utf-8?B?VGJYamZVTEtEL3Jjb2kvL3ZmM3pTbW1JRUZScEpOUjhOZzdqbk81b3pBMkdW?=
 =?utf-8?B?YjVlSUg0VHBMSS9IblFaQ0tYeWhtME1ySFAvbWJjSW9qT2ZxMXhGblVhVVBx?=
 =?utf-8?B?L1gxTHVoWFlrbEZrZmFhZktWUHBwZms1Q2hpUXpQNncwMm5pNnNpQ2Q4ZCtN?=
 =?utf-8?B?dThtRlY2UFpSbEE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 07:33:46.6114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 08635121-cd66-4d3e-6d53-08d8b6cc65a4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +M5vEzOdY4FhFBnJWj18S5u+KQdHt9NtWeSCx1Igg7Ogru/HsVuUMD/MNS3SMJ+c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3191
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_03:2021-01-11,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120039
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/21 11:14 PM, Andrii Nakryiko wrote:
> On Mon, Jan 11, 2021 at 7:24 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 1/11/21 2:54 PM, Song Liu wrote:
>>>
>>>
>>>> On Jan 11, 2021, at 9:49 AM, Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>>
>>>>
>>>> On 1/8/21 3:19 PM, Song Liu wrote:
>>>>> Replace hashtab with task local storage in runqslower. This improves the
>>>>> performance of these BPF programs. The following table summarizes average
>>>>> runtime of these programs, in nanoseconds:
>>>>>                             task-local   hash-prealloc   hash-no-prealloc
>>>>> handle__sched_wakeup             125             340               3124
>>>>> handle__sched_wakeup_new        2812            1510               2998
>>>>> handle__sched_switch             151             208                991
>>>>> Note that, task local storage gives better performance than hashtab for
>>>>> handle__sched_wakeup and handle__sched_switch. On the other hand, for
>>>>> handle__sched_wakeup_new, task local storage is slower than hashtab with
>>>>> prealloc. This is because handle__sched_wakeup_new accesses the data for
>>>>> the first time, so it has to allocate the data for task local storage.
>>>>> Once the initial allocation is done, subsequent accesses, as those in
>>>>> handle__sched_wakeup, are much faster with task local storage. If we
>>>>> disable hashtab prealloc, task local storage is much faster for all 3
>>>>> functions.
>>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>>> ---
>>>>>    tools/bpf/runqslower/runqslower.bpf.c | 26 +++++++++++++++-----------
>>>>>    1 file changed, 15 insertions(+), 11 deletions(-)
>>>>> diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
>>>>> index 1f18a409f0443..c4de4179a0a17 100644
>>>>> --- a/tools/bpf/runqslower/runqslower.bpf.c
>>>>> +++ b/tools/bpf/runqslower/runqslower.bpf.c
>>>>> @@ -11,9 +11,9 @@ const volatile __u64 min_us = 0;
>>>>>    const volatile pid_t targ_pid = 0;
>>>>>      struct {
>>>>> -   __uint(type, BPF_MAP_TYPE_HASH);
>>>>> -   __uint(max_entries, 10240);
>>>>> -   __type(key, u32);
>>>>> +   __uint(type, BPF_MAP_TYPE_TASK_STORAGE);
>>>>> +   __uint(map_flags, BPF_F_NO_PREALLOC);
>>>>> +   __type(key, int);
>>>>>      __type(value, u64);
>>>>>    } start SEC(".maps");
>>>>>    @@ -25,15 +25,19 @@ struct {
>>>>>      /* record enqueue timestamp */
>>>>>    __always_inline
>>>>> -static int trace_enqueue(u32 tgid, u32 pid)
>>>>> +static int trace_enqueue(struct task_struct *t)
>>>>>    {
>>>>> -   u64 ts;
>>>>> +   u32 pid = t->pid;
>>>>> +   u64 ts, *ptr;
>>>>>              if (!pid || (targ_pid && targ_pid != pid))
>>>>>              return 0;
>>>>>              ts = bpf_ktime_get_ns();
>>>>> -   bpf_map_update_elem(&start, &pid, &ts, 0);
>>>>> +   ptr = bpf_task_storage_get(&start, t, 0,
>>>>> +                              BPF_LOCAL_STORAGE_GET_F_CREATE);
>>>>> +   if (ptr)
>>>>> +           *ptr = ts;
>>>>>      return 0;
>>>>>    }
>>>>>    @@ -43,7 +47,7 @@ int handle__sched_wakeup(u64 *ctx)
>>>>>      /* TP_PROTO(struct task_struct *p) */
>>>>>      struct task_struct *p = (void *)ctx[0];
>>>>>    - return trace_enqueue(p->tgid, p->pid);
>>>>> +   return trace_enqueue(p);
>>>>>    }
>>>>>      SEC("tp_btf/sched_wakeup_new")
>>>>> @@ -52,7 +56,7 @@ int handle__sched_wakeup_new(u64 *ctx)
>>>>>      /* TP_PROTO(struct task_struct *p) */
>>>>>      struct task_struct *p = (void *)ctx[0];
>>>>>    - return trace_enqueue(p->tgid, p->pid);
>>>>> +   return trace_enqueue(p);
>>>>>    }
>>>>>      SEC("tp_btf/sched_switch")
>>>>> @@ -70,12 +74,12 @@ int handle__sched_switch(u64 *ctx)
>>>>>              /* ivcsw: treat like an enqueue event and store timestamp */
>>>>>      if (prev->state == TASK_RUNNING)
>>>>> -           trace_enqueue(prev->tgid, prev->pid);
>>>>> +           trace_enqueue(prev);
>>>>>              pid = next->pid;
>>>>>              /* fetch timestamp and calculate delta */
>>>>> -   tsp = bpf_map_lookup_elem(&start, &pid);
>>>>> +   tsp = bpf_task_storage_get(&start, next, 0, 0);
>>>>>      if (!tsp)
>>>>>              return 0;   /* missed enqueue */
>>>>
>>>> Previously, hash table may overflow so we may have missed enqueue.
>>>> Here with task local storage, is it possible to add additional pid
>>>> filtering in the beginning of handle__sched_switch such that
>>>> missed enqueue here can be treated as an error?
>>>
>>> IIUC, hashtab overflow is not the only reason of missed enqueue. If the
>>> wakeup (which calls trace_enqueue) happens before runqslower starts, we
>>> may still get missed enqueue in sched_switch, no?
>>
>> the wakeup won't happen before runqslower starts since runqslower needs
>> to start to do attachment first and then trace_enqueue() can run.
> 
> I think Song is right. Given wakeup and sched_switch need to be
> matched, depending at which exact time we attach BPF programs, we can
> end up missing wakeup, but not missing sched_switch, no? So it's not
> an error.

The current approach works fine. What I suggested is to
tighten sched_switch only for target_pid. wakeup (doing queuing) will
be more relaxed than sched_switch to ensure task local storage creation
is always there for target_pid regardless of attachment timing.
I think it should work, but we have to experiment to see actual
results...

> 
>>
>> For the current implementation trace_enqueue() will happen for any non-0
>> pid before setting test_progs tgid, and will happen for any non-0 and
>> test_progs tgid if it is set, so this should be okay if we do filtering
>> in handle__sched_switch. Maybe you can do an experiment to prove whether
>> my point is correct or not.
>>
>>>
>>> Thanks,
>>> Song
>>>
