Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4F020BD22
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 01:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgFZX3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 19:29:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14030 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726002AbgFZX3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 19:29:46 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QNKiDT007503;
        Fri, 26 Jun 2020 16:29:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=dVVfgQJhkoJmc+HHSJfwiIVKYnZrQgoC6IP4VKGkRDs=;
 b=rSdhHbzU4vsTdvIWkeIH+5jMzsF8AtJwMFqswEv6601z7OHNl5G/rg5pGpKaTRD2E6EB
 PuV72pXhrDbo4fwyA8Aa4pSmyxf/AqU0sROVC5mzgt1cOfR6dKy5h4h8LZVO8FbqRoKp
 eRbK9Ig8ea5lfQGZTBG59PbIxB6VBmZeeU0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux1f00w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 16:29:29 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 16:29:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5gI/E9iKCrb93YzO9QxZjt4J9YQui6eTUkTN1eDJJLdteSTXIy/tDUV4Vb7CxRocTkd873GRswbVpHvyJJH6Z12g9f4mH5azo10x25vDySm5DBkxTExLMuB6czqaqQLcC/9XkoiPUscNXCxRwBV76USlgLtFqU71BIthj4KfXwdqRQ8v0NvyVa721YnB/NvOj41G5huIWVxxORasaWyyT8w4kevnehkMYhtEuLOGK5CVAoGO3s3n2iH4m2MYuyY/8ACiApP7Ygca4Iib3pVsLdwJb1k10j5jIUmZ+P0YrbojI4S2MbBtrwGCAAgbqOohiHbsKZ6R49KDKahUSRKFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dVVfgQJhkoJmc+HHSJfwiIVKYnZrQgoC6IP4VKGkRDs=;
 b=ioMRncQV2NLhQ1/vz/fTy9BZE5AP00f6aWCpx9N9VfFc8XzFXfY1oTdY0fk3WVCEM73fCP3zH0L71oHDSKd8fNCRWIaM8ZZHRMl9dNbjReFb5GUetjMgOp/lrSII0y7pIgU0ol/iF1tRZ1tOnLNOvo7BvCX6UkWLm7632+MblD3SNfckYC5bRVFJiOGyrnNCoWUlpHZ6P5DFQF8gf2LQ2Fjye1X3y0BHY0ZJ090tbbPctnYaZbKijkpoNTOIqMjMiQZ/5Vno7mz065mtkx+yB+lk3XcLOfzdnOMFjYREFVSQZBsUPv94iWdzEkF2lTwogec27oIUjH213AZYbaVMVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dVVfgQJhkoJmc+HHSJfwiIVKYnZrQgoC6IP4VKGkRDs=;
 b=StVNOAU7rux/Td+h1kHnKwYkD7O54/rbke5sv22lUygBn25LSg6x0qGjdVd61XeSb5EC+emUWVymA31TN6Z7pJXKHkm70ex2QEE8ny1y9J40iGGn2kNsu4FHkESn8EsFz4TTfoWUXkvm9dXOthPJKAOro+z59OROBFelMQTNoH0=
Authentication-Results: zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2584.namprd15.prod.outlook.com (2603:10b6:a03:150::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Fri, 26 Jun
 2020 23:29:26 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.033; Fri, 26 Jun 2020
 23:29:26 +0000
Subject: Re: [PATCH v4 bpf-next 05/14] bpf: Remove btf_id helpers resolving
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-6-jolsa@kernel.org>
 <7480f7b2-01f0-f575-7e4f-cf3bde851c3f@fb.com>
 <CAEf4BzYPvNbYNBuqFDY8xCqSGTZ2G8HM=waq9b=qO9UYOUK7+A@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b9258020-cd38-b818-e3a9-4f6d9cdf6b88@fb.com>
Date:   Fri, 26 Jun 2020 16:29:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <CAEf4BzYPvNbYNBuqFDY8xCqSGTZ2G8HM=waq9b=qO9UYOUK7+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0043.namprd11.prod.outlook.com
 (2603:10b6:a03:80::20) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1988] (2620:10d:c090:400::5:90d4) by BYAPR11CA0043.namprd11.prod.outlook.com (2603:10b6:a03:80::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Fri, 26 Jun 2020 23:29:25 +0000
X-Originating-IP: [2620:10d:c090:400::5:90d4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7652b26-59e3-4847-cbb6-08d81a28c3d5
X-MS-TrafficTypeDiagnostic: BYAPR15MB2584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2584CABFE49954C215606400D3930@BYAPR15MB2584.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DuJ4jm5A40dvuymiUDX6i1D5z2c6OkPEWLIRYC0VuL6i2jCD0iWbMcPHgP+iR800z22UJE/JgRJv9Y4jRMco/4fStNe3WOT3HaIab7tAFKgxPARgjnQF8ooXbgnwk4lWOQWQdIW/7COv9J5ZUZdTLBsR81KWqQm5c++OHjJZsGYtriVMqXfXUqcw3ashkfFIqjfkmLqWtvzmfedRBBulDJYWjCbI0mCnTYCo00NXjgvnMHaMOfB2YsjlylQ15jAeSXvSddMA5y8Rig0/Y2NXWZA88Yg46N12zTRncU9oBHj/qvkV0aLEokiU9H0bcH8PdfZ96v2lbGVvOZPoBKDyjNJgBS0OYuJ/0tLIRWsLWWVPDgOzNF8th/BsYJgqn6rg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(366004)(39860400002)(396003)(136003)(66476007)(31686004)(66946007)(52116002)(83380400001)(2616005)(53546011)(66556008)(2906002)(478600001)(316002)(8676002)(16526019)(6486002)(7416002)(5660300002)(4326008)(86362001)(54906003)(31696002)(8936002)(6916009)(36756003)(186003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: tDUxBmvLEeZ4DHhza7cX+yn1olgi6jYthexGQLhf7tGCl/HWXyKhmlq1Tw+6Cmtjg/u2ocPT2FnlDdTAForRaAu8AMrFSdUr3JwRLcGI4xlZ/XTYAaVN4JavPZiOiAxP26qHwMPTpa+yTd7Zr7Da4n852LBb4J4aIEU77kcZCMVzbEblfKjam6cGCJayBdaoczvVlg+25/DlfT6/JS3jFkeggkxDpzLwdkR3vghKY21dlzM5wz1MjCiYNqXn3LrzOKrlkdnLBAxIHz3ZBayLzUEyeCXFROze6F3TRjq7UJRE2cMz1yvkp46100uLiVNiOA2+JVBQ5yYtVmllT3UwjTIdtoLxuwnzKwDsXwVAiOhJE0o6Ph2d6YQZwBL394p9O8Y400bTzC4cy1n1Ntz07hVF73ZM+lQTLdxf7yxSBK22wSbW7RrOwD3tNz4Uoqv7U/HkS0UHqWfCZllD0V7Fs1uDbDBHZ41x9as8q+bNppEAdF5pXistlxNZ9L3EKjM/i4xN5uACozM/pXRy+OUl0A==
X-MS-Exchange-CrossTenant-Network-Message-Id: d7652b26-59e3-4847-cbb6-08d81a28c3d5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 23:29:26.2136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lv+b5As9MQewMQWSIXG6QNBvtCCHfoI/g5FME/BALyJxpvUTXLL/WqmQ2QcKvfMD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2584
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 cotscore=-2147483648 spamscore=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/26/20 2:40 PM, Andrii Nakryiko wrote:
> On Fri, Jun 26, 2020 at 2:37 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 6/25/20 3:12 PM, Jiri Olsa wrote:
>>> Now when we moved the helpers btf_id arrays into .BTF_ids section,
>>> we can remove the code that resolve those IDs in runtime.
>>>
>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>> ---
>>>    kernel/bpf/btf.c | 90 +++++-------------------------------------------
>>>    1 file changed, 8 insertions(+), 82 deletions(-)
>>>
>>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>>> index 4c3007f428b1..4da6b0770ff9 100644
>>> --- a/kernel/bpf/btf.c
>>> +++ b/kernel/bpf/btf.c
>>> @@ -4079,96 +4079,22 @@ int btf_struct_access(struct bpf_verifier_log *log,
>>>        return -EINVAL;
>>>    }
>>>
>>> -static int __btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn,
>>> -                                int arg)
>>> +int btf_resolve_helper_id(struct bpf_verifier_log *log,
>>> +                       const struct bpf_func_proto *fn, int arg)
>>>    {
>>> -     char fnname[KSYM_SYMBOL_LEN + 4] = "btf_";
>>> -     const struct btf_param *args;
>>> -     const struct btf_type *t;
>>> -     const char *tname, *sym;
>>> -     u32 btf_id, i;
>>> +     int id;
>>>
>>> -     if (IS_ERR(btf_vmlinux)) {
>>> -             bpf_log(log, "btf_vmlinux is malformed\n");
>>> +     if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
>>>                return -EINVAL;
>>> -     }
>>> -
>>> -     sym = kallsyms_lookup((long)fn, NULL, NULL, NULL, fnname + 4);
>>> -     if (!sym) {
>>> -             bpf_log(log, "kernel doesn't have kallsyms\n");
>>> -             return -EFAULT;
>>> -     }
>>>
>>> -     for (i = 1; i <= btf_vmlinux->nr_types; i++) {
>>> -             t = btf_type_by_id(btf_vmlinux, i);
>>> -             if (BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF)
>>> -                     continue;
>>> -             tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
>>> -             if (!strcmp(tname, fnname))
>>> -                     break;
>>> -     }
>>> -     if (i > btf_vmlinux->nr_types) {
>>> -             bpf_log(log, "helper %s type is not found\n", fnname);
>>> -             return -ENOENT;
>>> -     }
>>> -
>>> -     t = btf_type_by_id(btf_vmlinux, t->type);
>>> -     if (!btf_type_is_ptr(t))
>>> -             return -EFAULT;
>>> -     t = btf_type_by_id(btf_vmlinux, t->type);
>>> -     if (!btf_type_is_func_proto(t))
>>> -             return -EFAULT;
>>> -
>>> -     args = (const struct btf_param *)(t + 1);
>>> -     if (arg >= btf_type_vlen(t)) {
>>> -             bpf_log(log, "bpf helper %s doesn't have %d-th argument\n",
>>> -                     fnname, arg);
>>> +     if (WARN_ON_ONCE(!fn->btf_id))
>>
>> The original code does not have this warning. It directly did
>> "ret = READ_ONCE(*btf_id);" after testing reg arg type ARG_PTR_TO_BTF_ID.
>>
>>>                return -EINVAL;
>>> -     }
>>>
>>> -     t = btf_type_by_id(btf_vmlinux, args[arg].type);
>>> -     if (!btf_type_is_ptr(t) || !t->type) {
>>> -             /* anything but the pointer to struct is a helper config bug */
>>> -             bpf_log(log, "ARG_PTR_TO_BTF is misconfigured\n");
>>> -             return -EFAULT;
>>> -     }
>>> -     btf_id = t->type;
>>> -     t = btf_type_by_id(btf_vmlinux, t->type);
>>> -     /* skip modifiers */
>>> -     while (btf_type_is_modifier(t)) {
>>> -             btf_id = t->type;
>>> -             t = btf_type_by_id(btf_vmlinux, t->type);
>>> -     }
>>> -     if (!btf_type_is_struct(t)) {
>>> -             bpf_log(log, "ARG_PTR_TO_BTF is not a struct\n");
>>> -             return -EFAULT;
>>> -     }
>>> -     bpf_log(log, "helper %s arg%d has btf_id %d struct %s\n", fnname + 4,
>>> -             arg, btf_id, __btf_name_by_offset(btf_vmlinux, t->name_off));
>>> -     return btf_id;
>>> -}
>>> +     id = fn->btf_id[arg];
>>
>> The corresponding BTF_ID definition here is:
>>     BTF_ID_LIST(bpf_skb_output_btf_ids)
>>     BTF_ID(struct, sk_buff)
>>
>> The bpf helper writer needs to ensure proper declarations
>> of BTF_IDs like the above matching helpers definition.
>> Support we have arg1 and arg3 as BTF_ID. then the list
>> definition may be
>>
>>     BTF_ID_LIST(bpf_skb_output_btf_ids)
>>     BTF_ID(struct, sk_buff)
>>     BTF_ID(struct, __unused)
>>     BTF_ID(struct, task_struct)
>>
>> This probably okay, I guess.
>>
>>>
>>> -int btf_resolve_helper_id(struct bpf_verifier_log *log,
>>> -                       const struct bpf_func_proto *fn, int arg)
>>> -{
>>> -     int *btf_id = &fn->btf_id[arg];
>>> -     int ret;
>>> -
>>> -     if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
>>> +     if (!id || id > btf_vmlinux->nr_types)
>>>                return -EINVAL;
>>
>> id == 0 if btf_id cannot be resolved by resolve_btfids, right?
>> when id may be greater than btf_vmlinux->nr_types? If resolve_btfids
>> application did incorrect transformation?
>>
>> Anyway, this is to resolve helper meta btf_id. Even if you
>> return a btf_id > btf_vmlinux->nr_types, verifier will reject
>> since it will never be the same as the real parameter btf_id.
>> I would drop id > btf_vmlinux->nr_types here. This should never
>> happen for a correct tool. Even if it does, verifier will take
>> care of it.
>>
> 
> I'd love to hear Alexei's thoughts about this change as well. Jiri
> removed not just BTF ID resolution, but also all the sanity checks.
> This now means more trust in helper definitions to not screw up
> anything. It's probably OK, but still something to consciously think
> about.

The kernel will have to trust the result. Otherwise, things may go bad.
For example, if the tool incorrectly calculated the type_id to be 100
although the correct id is 50, and the bpf program happens to have
the type id 100 for the parameter. Then the helper is allowed, this
could crash the kernel... I do not know whether we have security
issue here or not.

> 
>>> -
>>> -     ret = READ_ONCE(*btf_id);
>>> -     if (ret)
>>> -             return ret;
>>> -     /* ok to race the search. The result is the same */
>>> -     ret = __btf_resolve_helper_id(log, fn->func, arg);
>>> -     if (!ret) {
>>> -             /* Function argument cannot be type 'void' */
>>> -             bpf_log(log, "BTF resolution bug\n");
>>> -             return -EFAULT;
>>> -     }
>>> -     WRITE_ONCE(*btf_id, ret);
>>> -     return ret;
>>> +     return id;
>>>    }
>>>
>>>    static int __get_type_size(struct btf *btf, u32 btf_id,
>>>
