Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E74F39E7A7
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 21:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhFGTmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 15:42:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30122 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231258AbhFGTme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 15:42:34 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 157JXgu8025099;
        Mon, 7 Jun 2021 12:40:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=7SUE6w+XcTPyezobDIRfuy0nKIhPfR2hKBLq6A6gBPY=;
 b=jSm/L8aq0QhYlSWlehRiPeruqbMHIPg6sV8AZIc7IKkXKVQvIsRsWBMvTFPjKPw6qg0g
 kHrfwiwBXhmahH3dNu7BZhdenQbh8bCggz3UaJD/ylDGKAsixt9AW20zw/sEQSNa8vsR
 7T5mgdWMfc2J0sCvd6kj+WiotHO+KHP85Fc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 391rhygg8j-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Jun 2021 12:40:01 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 12:39:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7Gq2IZXdl4FEUyv9d0NVFaTgiuwBzsLfbqvBf1GqkZMkMTuLYVyV9opKOBR8bYcgRUgHiFpa9vDYUuVy9llS89KKp+6/WTO/3HRreq8AYWF9/J0A3UcFipfpxERqVX1mx0/R0FEdOgaCI0VPBU0w2tKBz8gSDY2+GKZKoC1hnv705wUBcjQbKklb5ezrqRQ8nV5iu1gf2FrKL7YwOUpF9dldDSW75AgF/Iv1oxhXD/k5HzlU0lNVVFV+Im/G1JVxWSc8Xw2l2PcgfdmBjvwrIR6X9+jw+eroZVBjLGCd1nuOqj3ssFgAqxMYbi1cYoReHPazr37teIbmRStxrc1ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SUE6w+XcTPyezobDIRfuy0nKIhPfR2hKBLq6A6gBPY=;
 b=kahLUDnx0Mm8j/aKELn3uCnYfF57bdBqouVGRR4oRnDtvAbu85yWRAje1GS2IMMmq5exqB/msa8KkORGIg1XJtOfwY1jLzJMnn202iS7Dwf1ipJvU7dyX4pc1wZa+nQLK3TGE6ieQMmFze3g9AkQhI1TNrmYlWc7591A8Hc5B0KwqUe0yVt0AcrCAP9lM0X2b/768h5DtRdgLXJnbPmxq4uJsIu8NSHhGK6vqhB7KAaF4NBos7tdHtG01ypghG9Fk2CyJdQNAnqZTh75asPqyRpWaCFkYI5ts1CbH+YSQjaZQzy0t9yfIerRJ9OUaf+/x4exKCDWaz+3yNtgs1dQxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2416.namprd15.prod.outlook.com (2603:10b6:805:21::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Mon, 7 Jun
 2021 19:39:58 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 19:39:58 +0000
Subject: Re: [PATCH 13/19] bpf: Add support to link multi func tracing program
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-14-jolsa@kernel.org>
 <de10c18b-5861-911e-ace8-eb599b72b0a8@fb.com> <YL5ksRAvQEW+0csh@krava>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <22358f97-f188-c592-2577-a3c79c5c668d@fb.com>
Date:   Mon, 7 Jun 2021 12:39:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <YL5ksRAvQEW+0csh@krava>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:db22]
X-ClientProxiedBy: SJ0PR03CA0303.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::8) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1097] (2620:10d:c090:400::5:db22) by SJ0PR03CA0303.namprd03.prod.outlook.com (2603:10b6:a03:39d::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Mon, 7 Jun 2021 19:39:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 127de687-7757-481a-d849-08d929ec089e
X-MS-TrafficTypeDiagnostic: SN6PR15MB2416:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB24166FFF24701B2229D01AC0D3389@SN6PR15MB2416.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /2PFW8s6wlqx5V96EQKvGkT1km680lJBNwne0PLw5HbEaoZPvEU3pplFlizfB2FUC6ujHSxOfhK3r1Br4/Tm4HDtwrCj2MPfaHEFbsQJ34b4M5g761e42UXYGvSJhakXAPDRPztNLVvfeyIbaTkvCsRLR5kHyOOXx5mLNp0hHG2x+0+332g4+VuiSZaT2V/MmWOu2hNJfBdQxNXJG1ycEpMwYXORZ+RZW49BfEUuMsmc+HgayHb0X89v32Dti2hByEdHNkYdRd0Rr8f8+fvBDYQ31puRK5ApB6p1RDaWHc1KBT4DBcU+KUzrmlKX9P1HZHuu6lZqrb0khHNCXzOw/lkYk23K2FSNHc0k+dGaZnQbs8yEuIlZ0UqnVv69QUD97lYFY+uRWOlQCD9J38YJhohqtGRM/crXgt5ajngWf3rSRslW2AfmS3tFbLZhhprYw8yVKzoY/6AOeTFoztduuRa2Ry9dg4v/1PPMwOkrisalB/BCFJMs5LD/xZ8o72kUc8TfnRkDtYf5uJkkkSf0Qr3n/RH4xDdIPJaaq7DQOJ8cJes+pKksO9Pl9EwQcoHsuom7RJwXUSwyE6nHkOssUaoH9oFSYKyPeSLbyikEyzhBOxnBDDwVhX3afW9DWZi6A40jZwRYxg+XwJMvItS09pm/x/oQ5K1QkSRop+nmCXif9QHSfMBcSq+igtaTznye
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(366004)(396003)(376002)(66946007)(66476007)(66556008)(8676002)(5660300002)(54906003)(38100700002)(83380400001)(36756003)(8936002)(31686004)(86362001)(52116002)(7416002)(16526019)(31696002)(6486002)(6916009)(186003)(4326008)(2906002)(478600001)(53546011)(316002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MllqQVptOC8rd0tPa0p1UkQ0OXNiOC8vcElsN3RqMXYyZ2FwdTlZSklUUGwz?=
 =?utf-8?B?ZzdUcjl3RzcramdwYWswaklNSXpMMXpSMjZtNXJkZHhJbmNpOFNJVzFsaU1m?=
 =?utf-8?B?OEpCb3pYWTYvSktWY3pnNFVVV1llQjdHRkZnZXlsbkhPWE9CMkRaNzgrWG85?=
 =?utf-8?B?RklZWDVzL3REV2d0cXk0Tk9lS24xUmt6aDJEL1VERTVmNnNGUWkvNkY4SCtX?=
 =?utf-8?B?QWo1WEgybGdvVUtIRzJrZURVNnZ4ZzBGMlMzbGgwNVpHeXFNcjArZFhtUTJS?=
 =?utf-8?B?Rk9QSi80cHJTUTRDT1IyanJkV2hRcWFUL1VlNnViaWRlRmVLZmJPUW1HNXIy?=
 =?utf-8?B?SEFldnhrYVpwTWZnZ2F0c1VJZTZkc2tMcFE2R1lhYVBzMllPVFZlL0ZQN1di?=
 =?utf-8?B?MTZXdm8rV2JETWxEbi9Zc1JPb1RRZXRQQ3BqZGRBdHJzZGx5c0prRU0vZ004?=
 =?utf-8?B?RXpZWFVvTVNITXZUckxIU1J5cEJ6TUt1YlVITE8rLzNMZTc1OUdrVGxOeEk0?=
 =?utf-8?B?N3B6d2hKbkFsOUFOOWRvaDY0aW9YWFBHd04za0U5cHMwT1dGNWU4WEQ1eldh?=
 =?utf-8?B?aU5najVlRDhkWkZTTVRDdWRXMjZkNjZBcHpBY3k5ZzBaQXhGakc5NktaTmYy?=
 =?utf-8?B?Q3hvdG83TlRMQUNnVlVidHJ1VENaUWVZMkxwamMvOWpqbGRMUkEvKytwbmxs?=
 =?utf-8?B?NXVnTkE5YjIzQnIyRXFhMkNmUml4NlllSGh3N1ZQQmJyVURwRUZ2UGpvdDR4?=
 =?utf-8?B?QTllbTh6emw4NzR0Z3hyU3EvTm9kMkdoN21tSjZ3Yzlpak5wWHY0ZVQvTTAx?=
 =?utf-8?B?bHpSOEN2Y1lsS0g3RWI1U09qWTZ1MWY3WWZObU84Z0RYMmozYURoUm94enNp?=
 =?utf-8?B?VmtXTU5xb1NMeWdhYmxZT3JhazR6Skh1RDhnNVRYS29SZGhuaVJmVXF0R1J5?=
 =?utf-8?B?b0dsRGFpY3N4VElDakpYakhFQzNyekJaWjVkeERlT1FaOCs4K2FhT2laQ0p4?=
 =?utf-8?B?K1NZemhETUR2K05lYkxrUTgvdDNHWkJkeGJkU2EvcFdzdmtJNVhzNTFPelJ5?=
 =?utf-8?B?Qy9HS2t1N0RYeGk1VE9HUXkrQWJKRU04dlpPTmVZcTFsdTJBbjhtQ0N0Y3dz?=
 =?utf-8?B?NnVzS0hRd1ZTcGtmZm1WM2xYKzhrN1l5ZzE0SFFqS1R5T2VYeVJLQ3lua0l0?=
 =?utf-8?B?ZGFvazZTSDluc1FyenBwTzNtZjVpYW1zb2wyUXRuRWwyZThaazQvblFYd0Fn?=
 =?utf-8?B?WjlWcDRLbmNMa0NNYXhLTkx5bEdXY1RMSmhDQUJ5cUpZTU5BQnhiejJGOG9H?=
 =?utf-8?B?amdqZjIvTE1oY0IvVERQVWpNclhxNlNYbGVlWkdyLzg2WlJoM2RZRXQ0a3lk?=
 =?utf-8?B?U3VXU2wyblF3UVlCelJ1M1VLN25JdHZUc1l5eGcrSTRncW5tTklqeFJMZE1z?=
 =?utf-8?B?eDl4TEQrSGRLWkUxZTB6S1BUTjI1MTduQTczNXRGaHovU0VzUjF6Y3RTWGsv?=
 =?utf-8?B?ZTF1ZGlreGhwSmZhRWV2NmVCYWxmRThtaTR0T2o2S2prclJZcWdVNHRoKzg1?=
 =?utf-8?B?N0ZVaHRrbkdBb2FZOWxhL3hQMm1Od0xiL0pHbTZYY3h6VHJWZXh4V3VpeEpL?=
 =?utf-8?B?d0psZGhGZEE5c3MxaldCVXRSM0JBMjRXc2wxa1pnZGt6R2N3eU5vSVFjcE93?=
 =?utf-8?B?YUcrUXBzS09MVDRLMXdmRVhHU0JOdWNWRzFDdjdQMk4vK0ZpNjlmUkQ2WXFG?=
 =?utf-8?B?VmI0MFRmU3kzWUMxdnhBMmFpc3JUSDRaazhZYnJCVEhBOWNvOXR1Qi9CVnZq?=
 =?utf-8?Q?pLruqL2l6U4TVs/XItKU0YKEO3s0Kw9o1fATA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 127de687-7757-481a-d849-08d929ec089e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 19:39:58.6132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: os3dZ2tFb6kx0LvEjKbKAPDabfxvAxjfiDGXHyfeLC5xHUYiibew8i4rJOH1TpUc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2416
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Yrh4pzihVp9dBEMUbtVIskUQp_36-bEP
X-Proofpoint-ORIG-GUID: Yrh4pzihVp9dBEMUbtVIskUQp_36-bEP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-07_14:2021-06-04,2021-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106070132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/21 11:25 AM, Jiri Olsa wrote:
> On Sun, Jun 06, 2021 at 10:36:57PM -0700, Yonghong Song wrote:
>>
>>
>> On 6/5/21 4:10 AM, Jiri Olsa wrote:
>>> Adding support to attach multiple functions to tracing program
>>> by using the link_create/link_update interface.
>>>
>>> Adding multi_btf_ids/multi_btf_ids_cnt pair to link_create struct
>>> API, that define array of functions btf ids that will be attached
>>> to prog_fd.
>>>
>>> The prog_fd needs to be multi prog tracing program (BPF_F_MULTI_FUNC).
>>>
>>> The new link_create interface creates new BPF_LINK_TYPE_TRACING_MULTI
>>> link type, which creates separate bpf_trampoline and registers it
>>> as direct function for all specified btf ids.
>>>
>>> The new bpf_trampoline is out of scope (bpf_trampoline_lookup) of
>>> standard trampolines, so all registered functions need to be free
>>> of direct functions, otherwise the link fails.
>>
>> I am not sure how severe such a limitation could be in practice.
>> It is possible in production some non-multi fentry/fexit program
>> may run continuously. Does kprobe program impact this as well?
> 
> I did not find a way how to combine current trampolines with the
> new ones for multiple programs.. what you described is a limitation
> of the current approach
> 
> I'm not sure about kprobes and trampolines, but the limitation
> should be same as we do have for current trampolines.. I'll check
> 
>>
>>>
>>> The new bpf_trampoline will store and pass to bpf program the highest
>>> number of arguments from all given functions.
>>>
>>> New programs (fentry or fexit) can be added to the existing trampoline
>>> through the link_update interface via new_prog_fd descriptor.
>>
>> Looks we do not support replacing old programs. Do we support
>> removing old programs?
> 
> we don't.. it's not what bpftrace would do, it just adds programs
> to trace and close all when it's done.. I think interface for removal
> could be added if you think it's needed

This can be a followup patch. Indeed removing selective old programs 
probably not a common use case.

> 
>>
>>>
>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>> ---
>>>    include/linux/bpf.h            |   3 +
>>>    include/uapi/linux/bpf.h       |   5 +
>>>    kernel/bpf/syscall.c           | 185 ++++++++++++++++++++++++++++++++-
>>>    kernel/bpf/trampoline.c        |  53 +++++++---
>>>    tools/include/uapi/linux/bpf.h |   5 +
>>>    5 files changed, 237 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>>> index 23221e0e8d3c..99a81c6c22e6 100644
>>> --- a/include/linux/bpf.h
>>> +++ b/include/linux/bpf.h
>>> @@ -661,6 +661,7 @@ struct bpf_trampoline {
>>>    	struct bpf_tramp_image *cur_image;
>>>    	u64 selector;
>>>    	struct module *mod;
>>> +	bool multi;
>>>    };
>>>    struct bpf_attach_target_info {
>>> @@ -746,6 +747,8 @@ void bpf_ksym_add(struct bpf_ksym *ksym);
>>>    void bpf_ksym_del(struct bpf_ksym *ksym);
>>>    int bpf_jit_charge_modmem(u32 pages);
>>>    void bpf_jit_uncharge_modmem(u32 pages);
>>> +struct bpf_trampoline *bpf_trampoline_multi_alloc(void);
>>> +void bpf_trampoline_multi_free(struct bpf_trampoline *tr);
>>>    #else
>>>    static inline int bpf_trampoline_link_prog(struct bpf_prog *prog,
>>>    					   struct bpf_trampoline *tr)
[...]
>>> @@ -363,9 +366,15 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
>>>    		goto out;
>>>    	}
>>> +	if (tr->multi)
>>> +		flags |= BPF_TRAMP_F_IP_ARG;
>>> +
>>>    	if (tprogs[BPF_TRAMP_FEXIT].nr_progs ||
>>> -	    tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs)
>>> +	    tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs) {
>>>    		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
>>> +		if (tr->multi)
>>> +			flags |= BPF_TRAMP_F_ORIG_STACK | BPF_TRAMP_F_IP_ARG;
>>
>> BPF_TRAMP_F_IP_ARG is not needed. It has been added before.
> 
> it's erased in 2 lines above.. which reminds me that I forgot to check
> if that's a bug or intended ;-)

Oh, yes, I miss that too :-) I guess it would be good if you can
re-organize the code to avoid resetting of flags.

> 
> jirka
> 
