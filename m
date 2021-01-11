Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4ECD2F1D1B
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390003AbhAKRue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:50:34 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58476 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728056AbhAKRud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:50:33 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 10BHeAPK010513;
        Mon, 11 Jan 2021 09:49:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=29md/iY//w8AFV8GRncemqZnygd9IL9aHZei+PfAmfA=;
 b=hxH4TG3IiqkmKOAX6jlhGJ7MVOeqZNNOr8YKNVhbu+zNmhUJgZd44O+jh9ReZYB2z/bb
 76jX83SxuiyTYxnhAxQ/Akzw5cKQLhqsPqk1JPlAsulzP2iwO7NWu6iLSfImOo5iTea3
 hRnpwIwuoYMhHtxXa55gM/z6krMYbj0RYrI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 35y8v5gy4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 09:49:31 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 09:49:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uc0PYV2fAlA1r0oe0fCPSeeqc+y1K3ix5fSLxCmZpUzkq2zEIMhUOguTeCCNG2aXEe75PjHFu8EweOC/Nifu97zxycdWgoSx81iJNdjcFsGGzkjgVM4ChS55LZ3f9XMyi0SZNjhjEJ/MXHl2znlDaiZs0GH9iF8lkhYkw5zwJWc4CqGTaroHevXdeK1IXHlS4XDN+Og5L1U34F6rh/WOOPhIv0QuDij7FSsl/UAKuodQREREqIKSzggsGvtKY2o69J2thn2/7rW5eVmlNDoO9Nn7JjJau/Pq/2FUpIwV75enS+MxOA3UdkmFGjQkNAuHM0GGterJCgtLtv9LgT5tqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29md/iY//w8AFV8GRncemqZnygd9IL9aHZei+PfAmfA=;
 b=GH5liVNkad+Yk9wis5UkcuHtYVj6NCgQlkyyHYCzT2djuvIl8uC1nTZaNq6sqBozTTJPpjknAP8IA1dvYwlEOnvfgVikHhEnwDhEJO6iqIZkCNShLXLlYpxJkkP/zdOUnNvBVZhxoURsWDWdmwUZEEW4+5LBSe8aXEqkhawlb56PnsPgzNorlwblEmg/FZzRyblcNjNUXQvnQO0Uhq6+toS1avUIS84liaKNlYiG3jmsCA3vqHIlorADvtLIUcv8Z5xtO0xHDvnmd+jtsVIZ03dMKC54L3Xs0in0JxqNhOpNtC3YmiTO09utKBhk1q6ws8AVsKAPep8xxbUpO5RVhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29md/iY//w8AFV8GRncemqZnygd9IL9aHZei+PfAmfA=;
 b=XrjOO6Y6+OrjVIwVxRmOmuKVzV0MthB9CpQZyMA6nHE7G4jGBeM8+1yrqJh/xR/vCN0fnZsHo69luYk7pyhTZQTSqIr92Xe+sGxRWkwi95pBpW4Y5eEWd8WSvCYxwj1jffCPH9OmZk6MtTamgOgS+EJ+wYmPAe/BavqugxUjGRc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2407.namprd15.prod.outlook.com (2603:10b6:a02:8d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 17:49:29 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 17:49:29 +0000
Subject: Re: [PATCH bpf-next 4/4] bpf: runqslower: use task local storage
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <mingo@redhat.com>, <peterz@infradead.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>, <haoluo@google.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-5-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ad40d69d-9c0f-8205-26df-c5a755778f9e@fb.com>
Date:   Mon, 11 Jan 2021 09:49:26 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210108231950.3844417-5-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6450]
X-ClientProxiedBy: SJ0PR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::10) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:6450) by SJ0PR03CA0035.namprd03.prod.outlook.com (2603:10b6:a03:33e::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 17:49:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da30fc74-f16a-4f7d-2881-08d8b6593eb7
X-MS-TrafficTypeDiagnostic: BYAPR15MB2407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB240706D71056519261F197D4D3AB0@BYAPR15MB2407.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TSfSt72y4QT0dYxXeb+inl39dFYiOAw+bA24eyRZZHkKOEMCbUjRvuRUWg7IxiQtfnYdOZAg0byflDKCwoAoikS3BSN0EbdmWmM4Efk7dJ8mSzQ99ug1HBLVKw+jzxv0/9E2QYL11wsKV9X+LP5cl8BWgCW7SLhzvq9IeFV+NjJvAHfY2QxYtL4tknKc5+NuafQi33daCL+SxSD5MmYBA6HobV8/7bdVm5DOqxIXSqEFDjDV7//ShepPUYYPIs4B0XdDDLNfdiDU9g/TQWqUMBa+pkrM6nL4BE95AThfCuxPvW9rQ0T8S5b7PROA80h/dLPTCCw7LcsR2Qtj1Y6SajVzeJL7IgcevD/uMuONslyaDLgreahHF12nHr2ST3iMKODPLG6loQAms1HMiJ3/RPuuu43bAhbmVBIv/hYb5y4T+tgNTuv2jyQ5OwzBnmz3J9c6LWxMAK2EebaYmlPmCNVz/zbakL84GpXJN/6iv1E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(7416002)(6486002)(316002)(52116002)(8936002)(8676002)(2906002)(5660300002)(4326008)(66556008)(66476007)(66946007)(36756003)(83380400001)(16526019)(186003)(2616005)(53546011)(86362001)(478600001)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ajhnWjBnR2hZQWRsMi9tOEsyQlpFU1Iwd0QrYU5WTTZOZGFscGpjb1l0WEJu?=
 =?utf-8?B?YkZnR3Jlbi8xMU9Yd29iN3R4L0tUMVlzNVg5VUdHY21TOERXVm04bnlLQjdR?=
 =?utf-8?B?bUM0R2tYTlBMMVlFcWhnME9LK1dnQklXYU8vMXFFQlRqL1d4aWdDSTBXcmU5?=
 =?utf-8?B?aXo4aVROR21SR3k3c01vZVY4ME9QWnVFelJKTHlEbFRDYk14dTZTZ29zOTUx?=
 =?utf-8?B?U0E3NlZ2YW13cXdBNmcvekYySGVLOGsxd2twcUhaejU5VnFzOENyQ2NSZHJT?=
 =?utf-8?B?WmJFa3dhYURQUjlVYXZUZXdTaDA2RFFhTWpiZS9KUGRTSjNqcndWeFQ1ZTZW?=
 =?utf-8?B?UFVtc1UwVEtpdHUzMTA1SzRMYzhZOHdjbUxCMElwRHdsV3dlTGJFcitrU3lL?=
 =?utf-8?B?c1VCZmEzdnZwcmxHTTI3U2R1d3c3TDNqWG5iYzZRUWc0WCtIMDB6OFNBRHNU?=
 =?utf-8?B?NnlGeEhsbE5HV29Oa01idHNQclJrYzFLc2ZMZjQ5b2w5NHFmWk4zY0wvcW1I?=
 =?utf-8?B?YjlIRHFmNkozbHVuaGM4N2kzcW81VkhqZklRWDcwU1g5cTBzSjk2eUFJVmxk?=
 =?utf-8?B?bVZSV2lsMkJJQ0tZVGtLOFJpcUtjTkVaVEJpMFpxcFNkTUxIMWVYVzRLeTFU?=
 =?utf-8?B?MWJVb3BZUWlUNFRtYnhSR05vWHR0TjJHUFdBQ25td05MZmFHNjdVNXcveXhj?=
 =?utf-8?B?end4V1FlSHFoUmxObERvOGRaNVF3bk9oSE1zZUM0VVJ5Y05EcEozS1dnS1Zy?=
 =?utf-8?B?SjJmeFVRYkFqRmZyTzRsVlVnbk8xbDAzZnd6SmVOZ0IwY2xzUmwwMFZJRC8y?=
 =?utf-8?B?SXRaTi9BZk5FZ3BWZndkSlZFa0d6S2k1RTM0YjVmNk5DZU11ak1MTFJCTEd1?=
 =?utf-8?B?dEF0L2dUQXVjUkpueWh3cWd6YnNqQWNObG8rbFJybEpZWWxiZjdMN3JTMXpr?=
 =?utf-8?B?dEtQM0c1VE5MaUpFbU1XcmM4ZGJpTTUxZUN1ek94R3JwTTNXOUpVZG54T2sz?=
 =?utf-8?B?KytuRVhtMVlGaFRoZjhKTlR1WE5EdW5OaHllWE4yZVhVR09BWXpSanIxMnYr?=
 =?utf-8?B?ZC9CMUFCWlpPYnRySFlwb0FOWit0WGpoS3ZPekQvRUdEQk1KcloxMEdrbE1D?=
 =?utf-8?B?Q0NoR3owczRaNWJYMzV1V1VIcWdwQ2V1R3diZUxRWGNSV0dxOGNZQ2VTaTE4?=
 =?utf-8?B?Unh6dmFOa1JkT0VHeXJkNlUxYnhNb05QWmZLbm1qNHF6S3JiWkZoTFMra1BO?=
 =?utf-8?B?bDU5NTB1ekRMM0lta0VkaTJnaUdDYWZHK1R5QVByNVEvTlMwRzJndlN3S285?=
 =?utf-8?B?ckYxWDd2UXgrWVJlYVQzYVJqejBrcTRyK0tVQWlmRkR5S0VHK280WFNZTlI4?=
 =?utf-8?B?N0R3dmc0dzJhbmc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 17:49:29.2571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: da30fc74-f16a-4f7d-2881-08d8b6593eb7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UiszHQvNnWh/ySbrTWJssG69j/9hc2ap6J6B3ITO7841HsxHI1pVGySJ6EZoAmRW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2407
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_29:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 phishscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110101
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/21 3:19 PM, Song Liu wrote:
> Replace hashtab with task local storage in runqslower. This improves the
> performance of these BPF programs. The following table summarizes average
> runtime of these programs, in nanoseconds:
> 
>                            task-local   hash-prealloc   hash-no-prealloc
> handle__sched_wakeup             125             340               3124
> handle__sched_wakeup_new        2812            1510               2998
> handle__sched_switch             151             208                991
> 
> Note that, task local storage gives better performance than hashtab for
> handle__sched_wakeup and handle__sched_switch. On the other hand, for
> handle__sched_wakeup_new, task local storage is slower than hashtab with
> prealloc. This is because handle__sched_wakeup_new accesses the data for
> the first time, so it has to allocate the data for task local storage.
> Once the initial allocation is done, subsequent accesses, as those in
> handle__sched_wakeup, are much faster with task local storage. If we
> disable hashtab prealloc, task local storage is much faster for all 3
> functions.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   tools/bpf/runqslower/runqslower.bpf.c | 26 +++++++++++++++-----------
>   1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
> index 1f18a409f0443..c4de4179a0a17 100644
> --- a/tools/bpf/runqslower/runqslower.bpf.c
> +++ b/tools/bpf/runqslower/runqslower.bpf.c
> @@ -11,9 +11,9 @@ const volatile __u64 min_us = 0;
>   const volatile pid_t targ_pid = 0;
>   
>   struct {
> -	__uint(type, BPF_MAP_TYPE_HASH);
> -	__uint(max_entries, 10240);
> -	__type(key, u32);
> +	__uint(type, BPF_MAP_TYPE_TASK_STORAGE);
> +	__uint(map_flags, BPF_F_NO_PREALLOC);
> +	__type(key, int);
>   	__type(value, u64);
>   } start SEC(".maps");
>   
> @@ -25,15 +25,19 @@ struct {
>   
>   /* record enqueue timestamp */
>   __always_inline
> -static int trace_enqueue(u32 tgid, u32 pid)
> +static int trace_enqueue(struct task_struct *t)
>   {
> -	u64 ts;
> +	u32 pid = t->pid;
> +	u64 ts, *ptr;
>   
>   	if (!pid || (targ_pid && targ_pid != pid))
>   		return 0;
>   
>   	ts = bpf_ktime_get_ns();
> -	bpf_map_update_elem(&start, &pid, &ts, 0);
> +	ptr = bpf_task_storage_get(&start, t, 0,
> +				   BPF_LOCAL_STORAGE_GET_F_CREATE);
> +	if (ptr)
> +		*ptr = ts;
>   	return 0;
>   }
>   
> @@ -43,7 +47,7 @@ int handle__sched_wakeup(u64 *ctx)
>   	/* TP_PROTO(struct task_struct *p) */
>   	struct task_struct *p = (void *)ctx[0];
>   
> -	return trace_enqueue(p->tgid, p->pid);
> +	return trace_enqueue(p);
>   }
>   
>   SEC("tp_btf/sched_wakeup_new")
> @@ -52,7 +56,7 @@ int handle__sched_wakeup_new(u64 *ctx)
>   	/* TP_PROTO(struct task_struct *p) */
>   	struct task_struct *p = (void *)ctx[0];
>   
> -	return trace_enqueue(p->tgid, p->pid);
> +	return trace_enqueue(p);
>   }
>   
>   SEC("tp_btf/sched_switch")
> @@ -70,12 +74,12 @@ int handle__sched_switch(u64 *ctx)
>   
>   	/* ivcsw: treat like an enqueue event and store timestamp */
>   	if (prev->state == TASK_RUNNING)
> -		trace_enqueue(prev->tgid, prev->pid);
> +		trace_enqueue(prev);
>   
>   	pid = next->pid;
>   
>   	/* fetch timestamp and calculate delta */
> -	tsp = bpf_map_lookup_elem(&start, &pid);
> +	tsp = bpf_task_storage_get(&start, next, 0, 0);
>   	if (!tsp)
>   		return 0;   /* missed enqueue */

Previously, hash table may overflow so we may have missed enqueue.
Here with task local storage, is it possible to add additional pid
filtering in the beginning of handle__sched_switch such that
missed enqueue here can be treated as an error?

>   
> @@ -91,7 +95,7 @@ int handle__sched_switch(u64 *ctx)
>   	bpf_perf_event_output(ctx, &events, BPF_F_CURRENT_CPU,
>   			      &event, sizeof(event));
>   
> -	bpf_map_delete_elem(&start, &pid);
> +	bpf_task_storage_delete(&start, next);
>   	return 0;
>   }
>   
> 
