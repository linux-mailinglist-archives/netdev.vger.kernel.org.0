Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D8D2F26A4
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 04:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbhALDZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 22:25:43 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42936 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbhALDZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 22:25:42 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10C3BeQ4030704;
        Mon, 11 Jan 2021 19:24:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=OzRt5NIIrblVP31wasPvF8YVDTkweHdWigIWCHfi2L0=;
 b=Uz4Dk9rN6JL7Zki6Fq/xegPYbuDIjmwuh3g7w5fyZ2vyYjFFo3F2g4cPmOaMOBHqlb1E
 1jpjzf9Ud99Wh0MVa0PrdyeR6brN66+2SUeSyrnL/vZdWXpg5mhtXY2lF/IV4PF8zmSH
 VuDWVKyki/oNqvJrm0VSFKPqD91/cR8ARgQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35yw1pgk38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 19:24:29 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 19:24:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8CI8ZDOxrqdYsDTSxHeVIJfIMVYVym/9dWzcv7w3NvCh5LfNMny+FEfcRR4stw+txF2e5+W+49HCGof8Ylfc3oGoT+RvHGkOaKP4hyAI2nrkAJmJbza1E/vOrUKcrVqMKEhl9uLek4nJhcptH+clY19V3ApFit+ZteffiWgzLYt52K6ytRNpzHVyUsueeE/XyvAZp4AQaJfgR3+Jf4h4dDnb658I8hg7n+MGDF4W4J7JF5px9Wq1QI1EA4G1gLODVXnBIlMNHL45wFZKqzHcwYKlSCKhvt48uh+qi6o0sQImWZB555kEe1+vQgnvTP93C5JEeoXZG0NwFaPP6KNsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzRt5NIIrblVP31wasPvF8YVDTkweHdWigIWCHfi2L0=;
 b=nWlds5Opd4PpibQA5ytD766ljWXFq/wF0bB1rvmPS9UD4XR0cZ/Byb9HRMh+d4+pjDJawyfFL5YUzQc/gnD2KB6k33ojT+n6b+TxA6aTRA26cr0JFEU3qJP1zXGLsrUaihVGdPh3sbw6Qsg3NSDwK5eop6pOOYD3i31gCwIPFgrdJF6dbfBRaJcwgWwdCxETYxbWDxkLP5k9VS7EJ4QG64HhQuuhKCV3MtvgduSCGyJX49prUyOK91X2+ezrvYfMBxuPcNQTFQEkm6HBy5NOeRPW7cBevI4hjddzRUgZQIzRAPXtPy1qdb6CmQ/veEqNsWwFYZY61eWa1NHoXF3bAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzRt5NIIrblVP31wasPvF8YVDTkweHdWigIWCHfi2L0=;
 b=c3axWr7Uh8lDOVgAJUjeTKmmeCNHE15emSZWXne/s4/vWTW5xbJNJ0cwwUeOzy1coikvtfiV79sZiosUWmmVIp4AMQe0omgn57VpJpyKHgrIaf3GQoLH6+1EIuenQhPNyvmHOZPZZpvAtSuI4o0ebgg8lHh+Rjvl+m9g6oxWjWM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2838.namprd15.prod.outlook.com (2603:10b6:a03:b4::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 03:24:25 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 03:24:25 +0000
Subject: Re: [PATCH bpf-next 4/4] bpf: runqslower: use task local storage
To:     Song Liu <songliubraving@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
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
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e890e08e-99d0-9d81-b835-c3a1b4b8bbbf@fb.com>
Date:   Mon, 11 Jan 2021 19:24:23 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <352FED72-11B3-44F0-9B1C-92552AEB4AE8@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:3aac]
X-ClientProxiedBy: MWHPR2001CA0017.namprd20.prod.outlook.com
 (2603:10b6:301:15::27) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::190b] (2620:10d:c090:400::5:3aac) by MWHPR2001CA0017.namprd20.prod.outlook.com (2603:10b6:301:15::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 03:24:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6e376a2-753f-4a96-bca1-08d8b6a99044
X-MS-TrafficTypeDiagnostic: BYAPR15MB2838:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2838A938FFFE5599087BD690D3AA0@BYAPR15MB2838.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kybGvUynuyv9o65/ESK1SsdL/NnfnCkgiIBdf3ZToACeqc0UB5IRJEnBZk/vlTEepkUum+gYrS3z1Q+fuy0RppkvbBQw1lOquFOB+6pjbbSUwIGbnthKkP2ysZQZ129TzfqKUxqI5N8zOv9ARG9oLT4labGRhPRt2iyGlGmm+xZ2ayWQlQ/34CWaG1go40Snj1aQpwovGD/xk9vZmGuBS0nBNLWSC7NLZbCfNma1Gg2GBbwN6or2n9ZXFXDXpjxiYPyCIZeO3yCDbc2w95ZjANgMunaTzfPqem4Tnn1Vd2lg1EiyB9ojvMBIaa/5qtZZLEhLMmP3uJSkcZion7LldE5G+nMZp48Mt5OoYaiHJ7tBgrx7bSsfAM8po4SCtb9UvnLV7TplSct4+h6HpAuD5nEO0Ap73YFHdOLPe+96HeLU4j3rGSkhRdPGmR7WQdaf/DE+fiToXkuPEfD99jPYSM4Qhl+OHSzk8o68NLiTPjw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(396003)(376002)(39860400002)(31696002)(54906003)(6636002)(5660300002)(31686004)(4326008)(53546011)(186003)(37006003)(8936002)(86362001)(16526019)(316002)(66476007)(6486002)(83380400001)(66946007)(66556008)(6862004)(8676002)(52116002)(2616005)(36756003)(7416002)(2906002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QTFPV2ZNeGhXQ1BtYU5MdHlvZDVYZ3BxbVNvZ2hHZnVPOFF6clhiQ0EyME1H?=
 =?utf-8?B?T1AxaG54SHBuckswM3U4c1VTV3IyUXVkYlNhelBvdGZ6aWs2aXJONENKaVlB?=
 =?utf-8?B?RTZFS1RETnhtUHRSZWdUZ2JRT2NBa2dBNzNrZTUwQjU5dDZMMXpmaE05YkEr?=
 =?utf-8?B?RTVPeTI2cW42b2l0VlpPbUlhamVTMGRHUjBxek5LZ3BqRzFiM0d3YUZoMVpj?=
 =?utf-8?B?Y2JPVjBDMU1zSTNXZFFGRTllU05yeDZxcm9CRk0vd1VGNHNLTUxoZGNEVHRy?=
 =?utf-8?B?UzM3aTFvOXJOYjNUYk5vTmxibWozdjZ4ZXJVVDlWYXFXMFF4TGdXenRWOUht?=
 =?utf-8?B?Vnc1RjdMRWQ1dGRxN1ZyVWxlUi84Wk1oempyVHlpMnV6MUVJNzhubmNOelA1?=
 =?utf-8?B?Vyt3czRRdFc1M0VnQTVEdHRPNGRmanJ2cDJ1VlYzWmR2ckhyWWhGMzNHOC9C?=
 =?utf-8?B?VkU1L0dXWFFRNDBINGczeTdUMkREQTJpTGxHbmJSQllkeEx2ODMybGVWN1Rq?=
 =?utf-8?B?ZHNMeHd4blBqbnFIWS9ucDh1YTk5U1k5cm1tWkExRlpaczZWZFVBZ0ZNbDBX?=
 =?utf-8?B?K2FpR2pXNnZCUnFkSkY3UHBlUW1SeXFick5kWHFLY0x4WTExYlpWWEJicnpw?=
 =?utf-8?B?cldHOVZiTFJvbGVsVXVPWHAvWXlQemRTRVhGOTBXaHVSdTlCYWtLMVJVUDAx?=
 =?utf-8?B?b25uT1c4V242ZmswcmFOVUYrSWRQVlFhRFQ0ajc1TEExb3gzdHpvTmhDV0Za?=
 =?utf-8?B?SDJ1SGwvbm8vZ0phaGduaEtxZkFOL0NFQVIwQ1JrQyttM1d6bUd6M3ZFNTND?=
 =?utf-8?B?aVFrV2o2SnZUNXVRNEJUVWZnd09zNlBZSi8wRjRvckwzU3pWa0hwTzZtVHpk?=
 =?utf-8?B?c0NOdElBbTNYTGdOSU1PN25QRGV3OHJxbFgzVDdia2Nmd3FjQ2cvMWkyMGhp?=
 =?utf-8?B?alV5ZG9mYjBOZDAyeTB1ZFdBUjZITi9CR2NFK3o4eTQ1a0pnc3VDcjArRFlZ?=
 =?utf-8?B?MW1YZkRMSi81RWwrZFoxY2dqdjIrdGRNcTUwTXNtODhxSXdoSHdndTVkQnpI?=
 =?utf-8?B?NnBsSEpFZENvYkVHT3BRWHR2SmJOSHR2NHhpajYwaUVZYmo4QksyNTdMaUQ2?=
 =?utf-8?B?cDZDcmF3Y0hTd0VMemxieDg1OVYvMTRXK0FWVE1ibm9ZYmdhNU5oTlF1dVc5?=
 =?utf-8?B?VzNnU2NXZmNBU0xlelFiVlgrclBHK2hMSksrUk5WbGZwOU5ia2M5WHZHMGF1?=
 =?utf-8?B?d2IwWnpoZWFaNWFUNitBVlYzV1I1ZEtKRUZ6Tyt4V3JTN2hhOHNZSm9Vdjc4?=
 =?utf-8?B?aDY5eFVPaUcwTjdJYnRNMWpzelZQeUViS3ZlY0Nja1V6cHIzTEdOTTRTcm05?=
 =?utf-8?B?M0dpdHVOSUM4eUE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 03:24:25.7997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: f6e376a2-753f-4a96-bca1-08d8b6a99044
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vxTqQX7aez4kmXjF4Ba0xIGfZDtaIzU2fwNdiBZKT+2+IKmoUBpBP9qf3OBft7FI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2838
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_01:2021-01-11,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120017
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/21 2:54 PM, Song Liu wrote:
> 
> 
>> On Jan 11, 2021, at 9:49 AM, Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 1/8/21 3:19 PM, Song Liu wrote:
>>> Replace hashtab with task local storage in runqslower. This improves the
>>> performance of these BPF programs. The following table summarizes average
>>> runtime of these programs, in nanoseconds:
>>>                            task-local   hash-prealloc   hash-no-prealloc
>>> handle__sched_wakeup             125             340               3124
>>> handle__sched_wakeup_new        2812            1510               2998
>>> handle__sched_switch             151             208                991
>>> Note that, task local storage gives better performance than hashtab for
>>> handle__sched_wakeup and handle__sched_switch. On the other hand, for
>>> handle__sched_wakeup_new, task local storage is slower than hashtab with
>>> prealloc. This is because handle__sched_wakeup_new accesses the data for
>>> the first time, so it has to allocate the data for task local storage.
>>> Once the initial allocation is done, subsequent accesses, as those in
>>> handle__sched_wakeup, are much faster with task local storage. If we
>>> disable hashtab prealloc, task local storage is much faster for all 3
>>> functions.
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>> ---
>>>   tools/bpf/runqslower/runqslower.bpf.c | 26 +++++++++++++++-----------
>>>   1 file changed, 15 insertions(+), 11 deletions(-)
>>> diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
>>> index 1f18a409f0443..c4de4179a0a17 100644
>>> --- a/tools/bpf/runqslower/runqslower.bpf.c
>>> +++ b/tools/bpf/runqslower/runqslower.bpf.c
>>> @@ -11,9 +11,9 @@ const volatile __u64 min_us = 0;
>>>   const volatile pid_t targ_pid = 0;
>>>     struct {
>>> -	__uint(type, BPF_MAP_TYPE_HASH);
>>> -	__uint(max_entries, 10240);
>>> -	__type(key, u32);
>>> +	__uint(type, BPF_MAP_TYPE_TASK_STORAGE);
>>> +	__uint(map_flags, BPF_F_NO_PREALLOC);
>>> +	__type(key, int);
>>>   	__type(value, u64);
>>>   } start SEC(".maps");
>>>   @@ -25,15 +25,19 @@ struct {
>>>     /* record enqueue timestamp */
>>>   __always_inline
>>> -static int trace_enqueue(u32 tgid, u32 pid)
>>> +static int trace_enqueue(struct task_struct *t)
>>>   {
>>> -	u64 ts;
>>> +	u32 pid = t->pid;
>>> +	u64 ts, *ptr;
>>>     	if (!pid || (targ_pid && targ_pid != pid))
>>>   		return 0;
>>>     	ts = bpf_ktime_get_ns();
>>> -	bpf_map_update_elem(&start, &pid, &ts, 0);
>>> +	ptr = bpf_task_storage_get(&start, t, 0,
>>> +				   BPF_LOCAL_STORAGE_GET_F_CREATE);
>>> +	if (ptr)
>>> +		*ptr = ts;
>>>   	return 0;
>>>   }
>>>   @@ -43,7 +47,7 @@ int handle__sched_wakeup(u64 *ctx)
>>>   	/* TP_PROTO(struct task_struct *p) */
>>>   	struct task_struct *p = (void *)ctx[0];
>>>   -	return trace_enqueue(p->tgid, p->pid);
>>> +	return trace_enqueue(p);
>>>   }
>>>     SEC("tp_btf/sched_wakeup_new")
>>> @@ -52,7 +56,7 @@ int handle__sched_wakeup_new(u64 *ctx)
>>>   	/* TP_PROTO(struct task_struct *p) */
>>>   	struct task_struct *p = (void *)ctx[0];
>>>   -	return trace_enqueue(p->tgid, p->pid);
>>> +	return trace_enqueue(p);
>>>   }
>>>     SEC("tp_btf/sched_switch")
>>> @@ -70,12 +74,12 @@ int handle__sched_switch(u64 *ctx)
>>>     	/* ivcsw: treat like an enqueue event and store timestamp */
>>>   	if (prev->state == TASK_RUNNING)
>>> -		trace_enqueue(prev->tgid, prev->pid);
>>> +		trace_enqueue(prev);
>>>     	pid = next->pid;
>>>     	/* fetch timestamp and calculate delta */
>>> -	tsp = bpf_map_lookup_elem(&start, &pid);
>>> +	tsp = bpf_task_storage_get(&start, next, 0, 0);
>>>   	if (!tsp)
>>>   		return 0;   /* missed enqueue */
>>
>> Previously, hash table may overflow so we may have missed enqueue.
>> Here with task local storage, is it possible to add additional pid
>> filtering in the beginning of handle__sched_switch such that
>> missed enqueue here can be treated as an error?
> 
> IIUC, hashtab overflow is not the only reason of missed enqueue. If the
> wakeup (which calls trace_enqueue) happens before runqslower starts, we
> may still get missed enqueue in sched_switch, no?

the wakeup won't happen before runqslower starts since runqslower needs
to start to do attachment first and then trace_enqueue() can run.

For the current implementation trace_enqueue() will happen for any non-0 
pid before setting test_progs tgid, and will happen for any non-0 and 
test_progs tgid if it is set, so this should be okay if we do filtering
in handle__sched_switch. Maybe you can do an experiment to prove whether
my point is correct or not.

> 
> Thanks,
> Song
> 
