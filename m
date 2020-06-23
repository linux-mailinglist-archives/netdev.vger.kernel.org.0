Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A252061FF
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390861AbgFWUx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:53:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47210 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392856AbgFWUqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:46:44 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NKGKCC019902;
        Tue, 23 Jun 2020 13:46:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=FJkbm/pwU5vUP5LN87/6wfeVe94xGeWXfE8rjpLkUIQ=;
 b=Hn1SYQ4SeDfow8BpyRISXjbA93Eq6lCsL0vQxG121Ymi/UQmSNxqxPzaUGtTbrD5fXyA
 vqHH/e49zoGPF5wLR/qg65lR1cktOlM1JpuzZI6JhRRveTL7qhdC+wVxJRrwCiDLkM2U
 MwSbviw7iie5PajiGFB057RGBzI3toTN5yE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk2uj3nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 13:46:28 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 13:46:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UVC5IfAbHJPXuUx+SUp6EwalM7HEAl3f4rsZpoQzyARI5RfAp+gYbmzWsM8pwVXnISqNsGj/3hQJxIQrq/oIBNEGYraWxZkLObhSduDJ/1q8F2ZwtSFxq4mwl4pv0zHvX4fOWj8RUmUNUJuu3YOJ5sifmlglOCQUbRE0C6/VkzozbhpKbWz4TQ68L/gkbUQMcjzgYwb6czw2UgCTasOjXSWxsswjpT1Kui7uRrvwLC+xqvvNdETxnqB2WPLI4XPRI9Wm5v4TB5HqEWfY/w3lIPxTSZWp8EHNO/zOx/UlKH0oFpBywBGLYsN/f+5AT+gnpRq7tznGFeD0iJqiyAiZrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FJkbm/pwU5vUP5LN87/6wfeVe94xGeWXfE8rjpLkUIQ=;
 b=Wrs1JknD37YHE/aJYADE5nNauAOjBY2hGGz7yHZp9hAHlKRCL9BG7kiZP+olCYDBPA/t8xiiqoaXzDy12J0yCPq58n0hlYfVud2RPxoGPH1c5CBJyIDx0ktHbBYbTR7nD4RapP7RoH23OLKL24e/hIBzsOk8BJwkHKi2+al3nbvoXIQC6WNOIa18/F6AddikUQKW+McMfN5jG8k+eG735/qnQ1ESRM1U3XCeokFKv/BVpsvPFxSWWTb1gDQ+fq5fgxi9XNkY3v1IekKokRg6lx1fCQXHeiNpcRLmT0FJHZfacxSCYrHqKnGw3Yv9W1UZaR2RrcbqV6vQ0nxvI7sFJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FJkbm/pwU5vUP5LN87/6wfeVe94xGeWXfE8rjpLkUIQ=;
 b=TD3cn+BoA1jdGIGyTRHEExfhtYyQqRbdPIHkmU7n3MPkbw+79iB7TA7F9KpffLC04JDzuh3ukQM9Kz/Bmm6oL3GvRjlAELkKrcqoK8bRFw9bEofbKZb4y6h71z7rAFdHgeHaIaEvxQnJb4swV2Nbw7H8u0g99s/xXtOGyP5CPJk=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3569.namprd15.prod.outlook.com (2603:10b6:a03:1ff::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.25; Tue, 23 Jun
 2020 20:46:24 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 20:46:24 +0000
Subject: Re: [PATCH bpf-next v3 05/15] bpf: add bpf_skc_to_tcp6_sock() helper
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200623003626.3072825-1-yhs@fb.com>
 <20200623003631.3073864-1-yhs@fb.com>
 <CAEf4BzaGWuAYzN2-+Gy9X8N2YPb341ZGugKzk78qiPURMgv7rw@mail.gmail.com>
 <26d6f7ee-28ea-80ba-fd76-e3b2f0327163@fb.com>
 <CAEf4BzYvra0bijcbzpBbwwtFQg4_8Uy3tGLwYYj=9CpkMPW=-w@mail.gmail.com>
 <bfd134a9-d808-d66d-3870-361f8f5aab64@fb.com>
 <CAEf4BzYMG7xu2ot-8OVJjYG7w14OciKgN=hZombOqo=7d5oUNQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <051dab4c-bbde-320e-c2bf-da63a7994fc4@fb.com>
Date:   Tue, 23 Jun 2020 13:46:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <CAEf4BzYMG7xu2ot-8OVJjYG7w14OciKgN=hZombOqo=7d5oUNQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0027.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::40) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1926] (2620:10d:c090:400::5:d956) by BYAPR02CA0027.namprd02.prod.outlook.com (2603:10b6:a02:ee::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 20:46:23 +0000
X-Originating-IP: [2620:10d:c090:400::5:d956]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a88992fc-3748-49f4-aa05-08d817b67e48
X-MS-TrafficTypeDiagnostic: BY5PR15MB3569:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3569621E809FD13D1A61BD3DD3940@BY5PR15MB3569.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pgRNSH0HDQO2aXhzDXrtoq4YlXQkHRdG2XksY277ZmsHCH0FiYWNWEdEW0qW7Ov4GoZpF3Ktdd9+PQA7S0vsLuxpZRxl9v6TgYbFD6X3JPGH2QN1Sl5zRFE+/z9Ww/MjwdOOguAYojiZH7z+SJeN26nQuc8I3p5qa9VhRAf27sbEhqVlUpfTllU46sMj5DR4eKvDXGEnT/qm5jHwHTD8G0LxfoOJPiFZaNS5IcooFHqf9fbKGBxBB/B/TN+Kj48BarsDY1VO0scyatPpp89oSJacVd2EjuyUAFdtH6++XQIxB7Dx0CsXFuJ7UPZIvkSvqoLoCPAuB9oYzqqJVSsgp4ye8ahlcSBBTjAF1tE5wVrYdRmB/82qrXSL5diW6+tg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(136003)(346002)(376002)(366004)(31686004)(5660300002)(2616005)(6486002)(478600001)(31696002)(66946007)(66556008)(66476007)(316002)(6916009)(53546011)(54906003)(8936002)(52116002)(2906002)(83380400001)(8676002)(86362001)(186003)(4326008)(16526019)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: tVa+KleguvNigXh4WPML9HLP6umBNF7+4afOWgyQO1YBWKlVVNKXtHT9nwDFKKOjkjiUXBw7tuTXqMv7JKN2jQz1/3KsztXR8j3HLHUKTBZmNhZ8xwY3Vc0jDHjmyWu1qw05CmmQ7q6xNL4WSoIISlTAde/AYbu6gXPd6Igz32ev+sxra42mapFzxPJQQlsIIGySWRR42Qx58jKL6i21NMB8D2+GYNQdr5c/2JhcALfxnx/t02EP8YGa2XCIEL1Kgasvu4uTGbPRVdZAOHxEwuLPtlvJ9+9QFJWE2DezmbzujPhBeoxy+FbuX9m8jLJx4NPjT2hxd/WG73NjSj3o3qMojxJwZLeBXvaXux1Evq5Kt+nosgwPuw7LB43SIvrF4nfsksjBB3mGs91NmRWf0JM1FoUgaHJoJikp40IITZBMDNW65qnDLpsu/WGSJTUX4Lc0Rp+Fb+j2kuCtKnkJL+rmawlumbh36XbqHgrrMQuQWsfHYalym5WfMWPSGlW3/fTRYkTiWXm3w6Ue7LcBkQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: a88992fc-3748-49f4-aa05-08d817b67e48
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 20:46:24.4282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b24KcPU5iFe4upjbayDg9LHep+Fkgvt5yoE9+KUBB+DFtyYVlXD0S/8U1WDT44eh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3569
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_13:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 spamscore=0 malwarescore=0 suspectscore=0
 adultscore=0 clxscore=1015 phishscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230139
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/20 1:11 PM, Andrii Nakryiko wrote:
> On Tue, Jun 23, 2020 at 12:47 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 6/23/20 11:23 AM, Andrii Nakryiko wrote:
>>> On Tue, Jun 23, 2020 at 7:52 AM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>>
>>>>
>>>> On 6/22/20 11:39 PM, Andrii Nakryiko wrote:
>>>>> On Mon, Jun 22, 2020 at 5:38 PM Yonghong Song <yhs@fb.com> wrote:
>>>>>>
>>>>>> The helper is used in tracing programs to cast a socket
>>>>>> pointer to a tcp6_sock pointer.
>>>>>> The return value could be NULL if the casting is illegal.
>>>>>>
>>>>>> A new helper return type RET_PTR_TO_BTF_ID_OR_NULL is added
>>>>>> so the verifier is able to deduce proper return types for the helper.
>>>>>>
>>>>>> Different from the previous BTF_ID based helpers,
>>>>>> the bpf_skc_to_tcp6_sock() argument can be several possible
>>>>>> btf_ids. More specifically, all possible socket data structures
>>>>>> with sock_common appearing in the first in the memory layout.
>>>>>> This patch only added socket types related to tcp and udp.
>>>>>>
>>>>>> All possible argument btf_id and return value btf_id
>>>>>> for helper bpf_skc_to_tcp6_sock() are pre-calculcated and
>>>>>> cached. In the future, it is even possible to precompute
>>>>>> these btf_id's at kernel build time.
>>>>>>
>>>>>> Acked-by: Martin KaFai Lau <kafai@fb.com>
>>>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>>>> ---
>>>>>
>>>>> Looks good to me as is, but see a few suggestions, they will probably
>>>>> save me time at some point as well :)
>>>>>
>>>>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>>>>>
>>>>>
>>>>>>     include/linux/bpf.h            | 12 +++++
>>>>>>     include/uapi/linux/bpf.h       |  9 +++-
>>>>>>     kernel/bpf/btf.c               |  1 +
>>>>>>     kernel/bpf/verifier.c          | 43 +++++++++++++-----
>>>>>>     kernel/trace/bpf_trace.c       |  2 +
>>>>>>     net/core/filter.c              | 80 ++++++++++++++++++++++++++++++++++
>>>>>>     scripts/bpf_helpers_doc.py     |  2 +
>>>>>>     tools/include/uapi/linux/bpf.h |  9 +++-
>>>>>>     8 files changed, 146 insertions(+), 12 deletions(-)
>>>>>>
>>>>>
>>>>> [...]
>>>>>
>>>>>> @@ -4815,6 +4826,18 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
>>>>>>                    regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
>>>>>>                    regs[BPF_REG_0].id = ++env->id_gen;
>>>>>>                    regs[BPF_REG_0].mem_size = meta.mem_size;
>>>>>> +       } else if (fn->ret_type == RET_PTR_TO_BTF_ID_OR_NULL) {
>>>>>> +               int ret_btf_id;
>>>>>> +
>>>>>> +               mark_reg_known_zero(env, regs, BPF_REG_0);
>>>>>> +               regs[BPF_REG_0].type = PTR_TO_BTF_ID_OR_NULL;
>>>>>> +               ret_btf_id = *fn->ret_btf_id;
[...]
>>>
>>>>
>>>>>
>>>>>> +               if (ret_btf_id == 0) {
>>>>>
>>>>> This also has to be struct/union (after typedef/mods stripping, of
>>>>> course). Or are there other cases?
>>>>
>>>> This is an "int". The func_proto difinition is below:
>>>> int *ret_btf_id; /* return value btf_id */
>>>
>>> I meant the BTF type itself that this btf_id points to. Is there any
>>> use case where this won't be a pointer to struct/union and instead
>>> something like a pointer to an int?
>>
>> Maybe you misunderstood. The mechanism is similar to the argument btf_id
>> encoding in func_proto's:
>>
>> static int bpf_seq_printf_btf_ids[5];
>> ...
>>           .btf_id         = bpf_seq_printf_btf_ids,
>>
>> func_proto->ret_btf_id will be a pointer to int which encodes the
>> btf_id, not the btf_type.
> 
> I understand that. Say it points to value 25. BTF type with ID=25 is
> going to be BTF_KIND_PTR -> BTF_KIND_STRUCT. I was wondering if we
> want/need to check that it's always BTF_KIND_PTR -> (modifier)* ->
> BTF_KIND_STRUCT/BTF_KIND_UNION. That's it.

Just to be clear. The ret_btf_id returned here is the btf id is the
type id of the pointee, so in this case it is BTF_KIND_STRUCT/....

These id's are pre-calculated and stored in memory. Unless the whole
thing is mess up, there is no need to check...

> 
>>
>>>
>>>>
>>>>>
>>>>>> +                       verbose(env, "invalid return type %d of func %s#%d\n",
>>>>>> +                               fn->ret_type, func_id_name(func_id), func_id);
>>>>>> +                       return -EINVAL;
>>>>>> +               }
>>>>>> +               regs[BPF_REG_0].btf_id = ret_btf_id;
>>>>>>            } else {
>>>>>>                    verbose(env, "unknown return type %d of func %s#%d\n",
>>>>>>                            fn->ret_type, func_id_name(func_id), func_id);
>>>>>
>>>>> [...]
>>>>>
>>>>>> +void init_btf_sock_ids(struct btf *btf)
>>>>>> +{
>>>>>> +       int i, btf_id;
>>>>>> +
>>>>>> +       for (i = 0; i < MAX_BTF_SOCK_TYPE; i++) {
>>>>>> +               btf_id = btf_find_by_name_kind(btf, bpf_sock_types[i],
>>>>>> +                                              BTF_KIND_STRUCT);
>>>>>> +               if (btf_id > 0)
>>>>>> +                       btf_sock_ids[i] = btf_id;
>>>>>> +       }
>>>>>> +}
>>>>>
>>>>> This will hopefully go away with Jiri's work on static BTF IDs, right?
>>>>> So looking forward to that :)
>>>>
>>>> Yes. That's the plan.
>>>>
>>>>>
>>>>>> +
>>>>>> +static bool check_arg_btf_id(u32 btf_id, u32 arg)
>>>>>> +{
>>>>>> +       int i;
>>>>>> +
>>>>>> +       /* only one argument, no need to check arg */
>>>>>> +       for (i = 0; i < MAX_BTF_SOCK_TYPE; i++)
>>>>>> +               if (btf_sock_ids[i] == btf_id)
>>>>>> +                       return true;
>>>>>> +       return false;
>>>>>> +}
>>>>>> +
>>>>>
>>>>> [...]
>>>>>
