Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6915A205C18
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387513AbgFWTrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:47:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52102 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733220AbgFWTrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 15:47:39 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NJlOQG027094;
        Tue, 23 Jun 2020 12:47:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zhAr9ddi2F9U26fGMkwTWNyWO880iXXuaAnS1v1weH0=;
 b=MxKkZ3QM8z+lGJINPQXF1a07y8MPwB1sfYl5F8bVLGJ+iGpthE1jZ2EU65PVyvZvo2Pi
 GRbg15sGk/b5Y+CrNkCruO94YkIwhLTeqeQgVkTubDalkJLHAOU5cRGAzQxfhuOEejPL
 ZXIYP8uDIkdDL1/NUxbnVvJO62MWVJC6dOM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk21htqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 12:47:23 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 12:46:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjLjcWjOf2LOtSLiFJC1ozDPv7TZFG5vLwpJfAbt7oF7sKILsXGfAiyc4ySxC7/DxQRv0lwt65EGUIHGyp6vAtMws1n4EPbYSrLbwzMW3C16k0sgPHhrSAICb3ZDe58knbGKVniEc+OZ3WSbABt8QbEdq0gsaPk6PVJl6lvebRmcVN9Cg7/w6KRYW7p9ixbm55uW+SfSJeJsFAxc3rirKA2s78ZlBgBkvByqG28S0G8m2Vg+rzx/GGe3ESTSESxvCnwC4MDhm2WfzCeiiPTVIaZbWfPBqBrQwGwz0l7CNzfEEPHHy9efuwZVy7foUaNYBwG0CcRdhRjd6uRjSwRYYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhAr9ddi2F9U26fGMkwTWNyWO880iXXuaAnS1v1weH0=;
 b=K43g/7Orb+Z3bws6PC9paP+hqgE9wNlx0O+LnDRxodCsMFGxRi/bZoHgD8HcVgJneWki5QQ1gQYFefF2ytYt5DvG2Vjp4tlD1H9jR/TWhLOEZRVVHyem8qknyz/RZZLMDqVh0VvH0fkeZRADY0uFfuaHs56GP0IOaPBSvda2GPcOBoF7GurPpT7q0mR1pD1F7XlBMHRh5DNtEMwnzlnTpk9DpTs9EJM8R5KACm+tbn+O7NWPI4Aw8gZey+85YdEyQbo/sB6BUkfPdPgm5qPnwzwASMMblXCBiyWhFNZccwfLeb7sBophNYCS79BryZUsd5h/oFHSjEk+IFoodzNxgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhAr9ddi2F9U26fGMkwTWNyWO880iXXuaAnS1v1weH0=;
 b=C4PzRtLcZFHcmRZch3CdZTrIVHq70lFzT/aD2LXLUv5BKrtxJOtinfatlFJWSVoYcqK2RcaeHvoVSI63vVGpaX1P0qIzdJrvAYg8CaDx4ACE4OeYQm0I0XJYje3jtp2fv62ihicHs3hETDLFBrVBQrnQ3Q7ab7soDynFq/OXnWY=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3192.namprd15.prod.outlook.com (2603:10b6:a03:10f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 19:45:59 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 19:45:58 +0000
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
From:   Yonghong Song <yhs@fb.com>
Message-ID: <bfd134a9-d808-d66d-3870-361f8f5aab64@fb.com>
Date:   Tue, 23 Jun 2020 12:45:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <CAEf4BzYvra0bijcbzpBbwwtFQg4_8Uy3tGLwYYj=9CpkMPW=-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:a03:74::41) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1926] (2620:10d:c090:400::5:d956) by BYAPR05CA0064.namprd05.prod.outlook.com (2603:10b6:a03:74::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.13 via Frontend Transport; Tue, 23 Jun 2020 19:45:57 +0000
X-Originating-IP: [2620:10d:c090:400::5:d956]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e68bcebf-7450-4c0d-b2e8-08d817ae0d15
X-MS-TrafficTypeDiagnostic: BYAPR15MB3192:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB319235807505694915AB6270D3940@BYAPR15MB3192.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PK0EwmvnO0I/85ZP97LlzNRCHpa9uEM/uH+qjMyOUZSvBAnIpvX16/0zlUZMWwgs1LIQKnsZz3X15gwV9Ullnsd5ETfXvbarmptrK6oSXv8tgfBhFKmbRS7vi+sSj84e2Q9L9/pPZ/cg/RdMcv4ArpGEEBGXmGNPhZiKTOVWLKtAfQZHG7gdcOilgJwp9ISXaeyQBXYFTXpRnKsU9wTFae5DAAwoGWk/h1yeAUPn6Vl7d5kW/5897m6/b+lYO7URcgQVuiBOLjyruud0GJR2tR601JnCSkXJ51y7vgvNCkAGIlll8306ATU349cPK9nw1fd9mcq89hQOYXPMmbsWoif3j/kbhtk7jrOlTAyXcEloCiITqKDrqi2PozE4/te8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(346002)(396003)(39850400004)(376002)(54906003)(2906002)(66946007)(66476007)(5660300002)(6916009)(66556008)(31696002)(83380400001)(86362001)(4326008)(8676002)(6486002)(36756003)(16526019)(52116002)(478600001)(316002)(186003)(53546011)(31686004)(2616005)(8936002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Yr9PDy1CvmGR5LHHdx1zvRi7/NNNafDc/FJL77iiZ495w8iYD/CdXgv+ZOm/RnNRZQgbYrfmb7lAtriU/6+hEs5SUiG7x64WxTHTFpIf3/pzfjnHzkaQbnFMLqYAEvh+8R/nviDBZeVBLd8Bfvj9rwrIPvIljlKUgQo9lqcOMJ3jBnoRA3oiuutGbjhm+/lkY9ll+F3iVOpBOLeVqMPec4R8Ihd85SHuWn/eVgvby27CvVzFAPF1mx21k4qA9wGONVJQQb2NFQDhHHH11pxC7xv3dwktQPMC8urCpOJ7F1iYPc7DOpYkOeUgjD78ZTqMefpC/P1uncm08GbpTnWK2tMlpUBxzQmI0/J8K9xcPxR5sKf8gwomilpLr7IAAiWEIc24FYtwxk0YCsKN9srD741bTWLj+GNpbRHrMq8T8/iUdEAz4xUEvbNQ+OEc11Xdq8NSU0eOQdMnU2+pnhbZCU6dQHQl7RFowyV4jOXpCyrJfp3W/K0z4GyY3oH6SqNGNPHjjERCK9V2mn4DHBtZEw==
X-MS-Exchange-CrossTenant-Network-Message-Id: e68bcebf-7450-4c0d-b2e8-08d817ae0d15
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 19:45:58.5848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8sbqB1DRqOXCHwEd7iUIRP0A55clcRlABIWXO5vuOkHLFPisYaktbVHs5YonqyE6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3192
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_13:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/20 11:23 AM, Andrii Nakryiko wrote:
> On Tue, Jun 23, 2020 at 7:52 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 6/22/20 11:39 PM, Andrii Nakryiko wrote:
>>> On Mon, Jun 22, 2020 at 5:38 PM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>> The helper is used in tracing programs to cast a socket
>>>> pointer to a tcp6_sock pointer.
>>>> The return value could be NULL if the casting is illegal.
>>>>
>>>> A new helper return type RET_PTR_TO_BTF_ID_OR_NULL is added
>>>> so the verifier is able to deduce proper return types for the helper.
>>>>
>>>> Different from the previous BTF_ID based helpers,
>>>> the bpf_skc_to_tcp6_sock() argument can be several possible
>>>> btf_ids. More specifically, all possible socket data structures
>>>> with sock_common appearing in the first in the memory layout.
>>>> This patch only added socket types related to tcp and udp.
>>>>
>>>> All possible argument btf_id and return value btf_id
>>>> for helper bpf_skc_to_tcp6_sock() are pre-calculcated and
>>>> cached. In the future, it is even possible to precompute
>>>> these btf_id's at kernel build time.
>>>>
>>>> Acked-by: Martin KaFai Lau <kafai@fb.com>
>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>> ---
>>>
>>> Looks good to me as is, but see a few suggestions, they will probably
>>> save me time at some point as well :)
>>>
>>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>>>
>>>
>>>>    include/linux/bpf.h            | 12 +++++
>>>>    include/uapi/linux/bpf.h       |  9 +++-
>>>>    kernel/bpf/btf.c               |  1 +
>>>>    kernel/bpf/verifier.c          | 43 +++++++++++++-----
>>>>    kernel/trace/bpf_trace.c       |  2 +
>>>>    net/core/filter.c              | 80 ++++++++++++++++++++++++++++++++++
>>>>    scripts/bpf_helpers_doc.py     |  2 +
>>>>    tools/include/uapi/linux/bpf.h |  9 +++-
>>>>    8 files changed, 146 insertions(+), 12 deletions(-)
>>>>
>>>
>>> [...]
>>>
>>>> @@ -4815,6 +4826,18 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
>>>>                   regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
>>>>                   regs[BPF_REG_0].id = ++env->id_gen;
>>>>                   regs[BPF_REG_0].mem_size = meta.mem_size;
>>>> +       } else if (fn->ret_type == RET_PTR_TO_BTF_ID_OR_NULL) {
>>>> +               int ret_btf_id;
>>>> +
>>>> +               mark_reg_known_zero(env, regs, BPF_REG_0);
>>>> +               regs[BPF_REG_0].type = PTR_TO_BTF_ID_OR_NULL;
>>>> +               ret_btf_id = *fn->ret_btf_id;
>>>
>>> might be a good idea to check fb->ret_btf_id for NULL and print a
>>> warning + return -EFAULT. It's not supposed to happen on properly
>>> configured kernel, but during development this will save a bunch of
>>> time and frustration for next person trying to add something with
>>> RET_PTR_TO_BTF_ID_OR_NULL.
>>
>> I would like prefer to delay this with current code. Otherwise,
>> it gives an impression fn->ret_btf_id might be NULL and it is
>> actually never NULL. We can add NULL check if the future change
>> requires it. I am not sure what the future change could be,
>> but you need some way to get the return btf_id, the above is
>> one of them.
> 
> It's not **supposed** to be NULL, same as a bunch of other invariants
> about BPF helper proto definitions, but verifier does check sanity for
> such cases, instead of crashing. But up to you. I'm pretty sure
> someone will trip up on this.

I think there are certain expectation for argument reg_state vs. certain
fields in the structure.

int btf_resolve_helper_id(struct bpf_verifier_log *log,
                           const struct bpf_func_proto *fn, int arg)
{
         int *btf_id = &fn->btf_id[arg];
         int ret;

         if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
                 return -EINVAL;

         ret = READ_ONCE(*btf_id);
	...
}

If ARG_PTR_TO_BTF_ID, the verifier did not really check
whether btf_id pointer is valid or not. It just use it.

The same applies to the new return type. If in func_proto,
somebody sets RET_PTR_TO_BTF_ID_OR_NULL, it is expected
that func_proto->ret_btf_id is valid.

Code review or feature selftest should catch errors
if they are out-of-sync.

> 
>>
>>>
>>>> +               if (ret_btf_id == 0) {
>>>
>>> This also has to be struct/union (after typedef/mods stripping, of
>>> course). Or are there other cases?
>>
>> This is an "int". The func_proto difinition is below:
>> int *ret_btf_id; /* return value btf_id */
> 
> I meant the BTF type itself that this btf_id points to. Is there any
> use case where this won't be a pointer to struct/union and instead
> something like a pointer to an int?

Maybe you misunderstood. The mechanism is similar to the argument btf_id 
encoding in func_proto's:

static int bpf_seq_printf_btf_ids[5];
...
         .btf_id         = bpf_seq_printf_btf_ids,

func_proto->ret_btf_id will be a pointer to int which encodes the 
btf_id, not the btf_type.

> 
>>
>>>
>>>> +                       verbose(env, "invalid return type %d of func %s#%d\n",
>>>> +                               fn->ret_type, func_id_name(func_id), func_id);
>>>> +                       return -EINVAL;
>>>> +               }
>>>> +               regs[BPF_REG_0].btf_id = ret_btf_id;
>>>>           } else {
>>>>                   verbose(env, "unknown return type %d of func %s#%d\n",
>>>>                           fn->ret_type, func_id_name(func_id), func_id);
>>>
>>> [...]
>>>
>>>> +void init_btf_sock_ids(struct btf *btf)
>>>> +{
>>>> +       int i, btf_id;
>>>> +
>>>> +       for (i = 0; i < MAX_BTF_SOCK_TYPE; i++) {
>>>> +               btf_id = btf_find_by_name_kind(btf, bpf_sock_types[i],
>>>> +                                              BTF_KIND_STRUCT);
>>>> +               if (btf_id > 0)
>>>> +                       btf_sock_ids[i] = btf_id;
>>>> +       }
>>>> +}
>>>
>>> This will hopefully go away with Jiri's work on static BTF IDs, right?
>>> So looking forward to that :)
>>
>> Yes. That's the plan.
>>
>>>
>>>> +
>>>> +static bool check_arg_btf_id(u32 btf_id, u32 arg)
>>>> +{
>>>> +       int i;
>>>> +
>>>> +       /* only one argument, no need to check arg */
>>>> +       for (i = 0; i < MAX_BTF_SOCK_TYPE; i++)
>>>> +               if (btf_sock_ids[i] == btf_id)
>>>> +                       return true;
>>>> +       return false;
>>>> +}
>>>> +
>>>
>>> [...]
>>>
