Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A4F2128EC
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgGBQEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:04:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24912 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726102AbgGBQEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 12:04:40 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 062G4HW5028507;
        Thu, 2 Jul 2020 09:04:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/LcvoL23z9sCcPoEUEUHXbeniFc1RKNc+lCscP4IZvM=;
 b=eUsKFqb7EEY1CXxRtQkycw37oiehGB91CwpzQxWgV+SepHuS3P5i+9zu/GRLPjnjg5Vz
 Zkc7eZ2P83vH7f6zfBa9grGhvzMk8yCFO42UaLbbUnDYYLoLbZpQw9Wej/t9IejIhi6f
 07fJhG9T3czKK4x+rqfp2tiRJ6HJc2cAp5U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 31ykcjgfr4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 02 Jul 2020 09:04:25 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 09:04:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTMwSnwgSrl2B9MBGHesx3zT1xXjZSb3DdVflFM/06bZB4+VqvrBc2UQGl/4Ea0uNvfau8b7Lcpt8FoIDKDDuSV/Xiok6Y8goOKc+6aGPJUejQ1UmynPlV7/pZtxhIYSsl9Z+l4AQFLlVWZ6p2p/6hRZxeoRShhXXbO2oFnD7D89WSXHbfo54eCjVtc71E4ym/a2HdVRah6xbQv5FcjIHsGi/ZYRmv1Rt1f+F6tKllHcHsKJVuT/JRHYe7Nawq16GiCGAu/40+JFP++O0ZrLj7szD97D8rxIwszfn6y3AiIP9E6W4CLNr9SYj6PXGn8/ljdnzvHERIwSnUH+l4+inA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/LcvoL23z9sCcPoEUEUHXbeniFc1RKNc+lCscP4IZvM=;
 b=UT+QXd7A234mfkH8fi3eW/9QoETV2kYXvoDqgdwOundaa/kfHeWd7F6RU8Ms+ccGiLXVjUxun9o4bS0NvWTSPzrVr/atqPLVr6D/3w3K+SSmlXo9Qwv3nnCxqWD3KguugpJFKif1WUNc0larZNoZLelj7+GNKsS+aK8zWGcHsiugcCNbYsNFiNhgC+Oz4cP7RLS7Eyuyv4LZqK8HNJ3vExV6LxIgP28yXBnQJnuaEwsu0jJETD7/OtoSGUstSIh6JvfLSE9pvuEXUtQ0tytSmc1D1YMjkWq8/VuhuxmJjKHhiw10Whg3R/rF5MSBavooO9NVZMkUTEaLVeRRmM0bBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/LcvoL23z9sCcPoEUEUHXbeniFc1RKNc+lCscP4IZvM=;
 b=QtbdFKqTIuw/ndcoGRSn1bWf0rvQSqPp1y2c20CTxlMs/DaTVT02bkaCbWBmtd0GmBjHX4HXB9MW07++ZvF17/TLxfG7nXqOSQ90tXZRqBxCc+aVhwscvxhzJ8UuiE521ujpbK9drXev92xNoytAbQPK2poqMR50/rKgC/muXvE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3572.namprd15.prod.outlook.com (2603:10b6:a03:1b2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Thu, 2 Jul
 2020 16:04:21 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.036; Thu, 2 Jul 2020
 16:04:21 +0000
Subject: Re: [PATCH bpf-next 1/4] samples: bpf: fix bpf programs with
 kprobe/sys_connect event
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20200702021646.90347-1-danieltimlee@gmail.com>
 <20200702021646.90347-2-danieltimlee@gmail.com>
 <c4061b5f-b42e-4ecc-e3fb-7a70206da417@fb.com>
 <CAEKGpzhU31p=i=xbD3Fk2vJh_btrk73CgkJXMXDgM1umsEaEpg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <41ca5ad1-2b79-dbc2-5f6e-e466712fe7a9@fb.com>
Date:   Thu, 2 Jul 2020 09:04:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <CAEKGpzhU31p=i=xbD3Fk2vJh_btrk73CgkJXMXDgM1umsEaEpg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::34) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::10fa] (2620:10d:c090:400::5:d408) by BY5PR03CA0024.namprd03.prod.outlook.com (2603:10b6:a03:1e0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27 via Frontend Transport; Thu, 2 Jul 2020 16:04:20 +0000
X-Originating-IP: [2620:10d:c090:400::5:d408]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f9dab96-87dc-4c83-7bdd-08d81ea19504
X-MS-TrafficTypeDiagnostic: BY5PR15MB3572:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB357292527D03037F24BE7171D36D0@BY5PR15MB3572.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pX3XQdqUhQ8w6pU8Hn/EAXVoWD1ZsKG71D4JCUBMoEUcWUrdbNaO73tHfoARkmLUNL+zCVLEDJG6GGvSfwJsdA/uxI4+hM1pQw67a9NHXxZm7Laar7J1PiJfleSWMqvXhpGfyBe76TfWD9ejuOlPPm9O9CWjvCY9fpRP0BKzX687byyg/aNJzmDbdviiW4z6W6KdcoI+9wZ6p8G9rhVxNVvx9J8RkdZTGTdYQGjVMOAiVmQQ1J/UgueALSy3wzl50syrirmpswyp5PAqW8kDdn+/+WzQKyO4tvJFGjFKBleK/oAM97AeabToJ+4+AYtQES/yu1z/bQqv0BZ2qZhKyKPr9ftU5HzgFNnfqsgYj9+veviibOIypw/qMSeq84za
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(346002)(366004)(136003)(39860400002)(66476007)(86362001)(31696002)(66946007)(36756003)(16526019)(186003)(4326008)(53546011)(54906003)(2616005)(316002)(52116002)(83380400001)(2906002)(66556008)(8936002)(8676002)(6916009)(478600001)(5660300002)(6486002)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ht1aZz6Ih9MNK8NiGdFGs9n+xvJUsKrmE0sL5cKqlIi1JOfkT8rMqMKKurceRiNjmOHDD0FB09AkAtV40law0qBKq4E9pDoQdgV4ABpGf5fUTkRFIw9bDCp0K16BQskeCsbGwANVedRG6iNP5DW9zrvtlHqCa5FZRbtlNEXmPSakWUzzQb2pXea4aN7bHJ/IT23UwgIw09CNw66xZjeq+Gb9oE6eYk5tpHeiBExDrocEGgU+U0wRl/vP8BYAdoPxEppuY118kzNt5uRAyDLzlc7VhtAiFaLBxi5GIiTypg7o5yF22n5N3JwVOy/OGpNVJhKfDHbzNl4IJD4nRFzcArlSuVv53SIQf482e09CBO1Ma8dS5/UwoeZW+Ihc1+LEPGwsrmgSuj2dsG60q5EvjKG9MVcQIPOtfTsMR8tnN4bChPwaoBHlTaz9osR/YrGkaaVnda51H92PwWaFXeXxk55enngSAOlwLD/vlBW/znkj2Pf9prCaIuVL2luVZPq2ng3ucp1UuFjDfi69I2AMsA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f9dab96-87dc-4c83-7bdd-08d81ea19504
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 16:04:21.3421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J+dyYhoP1l5tV8T/F25JDoy39IUSNMJZgRZd98fIPLSVAMHJg9ZOYT6FBA1TKVxx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3572
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_09:2020-07-02,2020-07-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=999 clxscore=1015 suspectscore=0 lowpriorityscore=0
 adultscore=0 spamscore=0 bulkscore=0 impostorscore=0 cotscore=-2147483648
 mlxscore=0 malwarescore=0 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020111
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/2/20 4:13 AM, Daniel T. Lee wrote:
> On Thu, Jul 2, 2020 at 2:13 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 7/1/20 7:16 PM, Daniel T. Lee wrote:
>>> Currently, BPF programs with kprobe/sys_connect does not work properly.
>>>
>>> Commit 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
>>> This commit modifies the bpf_load behavior of kprobe events in the x64
>>> architecture. If the current kprobe event target starts with "sys_*",
>>> add the prefix "__x64_" to the front of the event.
>>>
>>> Appending "__x64_" prefix with kprobe/sys_* event was appropriate as a
>>> solution to most of the problems caused by the commit below.
>>>
>>>       commit d5a00528b58c ("syscalls/core, syscalls/x86: Rename struct
>>>       pt_regs-based sys_*() to __x64_sys_*()")
>>>
>>> However, there is a problem with the sys_connect kprobe event that does
>>> not work properly. For __sys_connect event, parameters can be fetched
>>> normally, but for __x64_sys_connect, parameters cannot be fetched.
>>>
>>> Because of this problem, this commit fixes the sys_connect event by
>>> specifying the __sys_connect directly and this will bypass the
>>> "__x64_" appending rule of bpf_load.
>>
>> In the kernel code, we have
>>
>> SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
>>                   int, addrlen)
>> {
>>           return __sys_connect(fd, uservaddr, addrlen);
>> }
>>
>> Depending on compiler, there is no guarantee that __sys_connect will
>> not be inlined. I would prefer to still use the entry point
>> __x64_sys_* e.g.,
>>      SEC("kprobe/" SYSCALL(sys_write))
>>
> 
> As you mentioned, there is clearly a possibility that problems may arise
> because the symbol does not exist according to the compiler.
> 
> However, in x64, when using Kprobe for __x64_sys_connect event, the
> tests are not working properly because the parameters cannot be fetched,
> and the test under selftests/bpf is using "kprobe/_sys_connect" directly.

This is the assembly code for __x64_sys_connect.

ffffffff818d3520 <__x64_sys_connect>:
ffffffff818d3520: e8 fb df 32 00        callq   0xffffffff81c01520 
<__fentry__>
ffffffff818d3525: 48 8b 57 60           movq    96(%rdi), %rdx
ffffffff818d3529: 48 8b 77 68           movq    104(%rdi), %rsi
ffffffff818d352d: 48 8b 7f 70           movq    112(%rdi), %rdi
ffffffff818d3531: e8 1a ff ff ff        callq   0xffffffff818d3450 
<__sys_connect>
ffffffff818d3536: 48 98                 cltq
ffffffff818d3538: c3                    retq
ffffffff818d3539: 0f 1f 80 00 00 00 00  nopl    (%rax)

In bpf program, the step is:
       struct pt_regs *real_regs = PT_REGS_PARM1(pt_regs);
       param1 = PT_REGS_PARM1(real_regs);
       param2 = PT_REGS_PARM2(real_regs);
       param3 = PT_REGS_PARM3(real_regs);
The same for s390.

For other architectures, no above indirection is needed.

I guess you can abstract the above into trace_common.h?

> 
> I'm not sure how to deal with this problem. Any advice and suggestions
> will be greatly appreciated.
> 
> Thanks for your time and effort for the review.
> Daniel
> 
>>>
>>> Fixes: 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
>>> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
>>> ---
>>>    samples/bpf/map_perf_test_kern.c         | 2 +-
>>>    samples/bpf/test_map_in_map_kern.c       | 2 +-
>>>    samples/bpf/test_probe_write_user_kern.c | 2 +-
>>>    3 files changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
>>> index 12e91ae64d4d..cebe2098bb24 100644
>>> --- a/samples/bpf/map_perf_test_kern.c
>>> +++ b/samples/bpf/map_perf_test_kern.c
>>> @@ -154,7 +154,7 @@ int stress_percpu_hmap_alloc(struct pt_regs *ctx)
>>>        return 0;
>>>    }
>>>
>>> -SEC("kprobe/sys_connect")
>>> +SEC("kprobe/__sys_connect")
>>>    int stress_lru_hmap_alloc(struct pt_regs *ctx)
>>>    {
>>>        char fmt[] = "Failed at stress_lru_hmap_alloc. ret:%dn";
>>> diff --git a/samples/bpf/test_map_in_map_kern.c b/samples/bpf/test_map_in_map_kern.c
>>> index 6cee61e8ce9b..b1562ba2f025 100644
>>> --- a/samples/bpf/test_map_in_map_kern.c
>>> +++ b/samples/bpf/test_map_in_map_kern.c
>>> @@ -102,7 +102,7 @@ static __always_inline int do_inline_hash_lookup(void *inner_map, u32 port)
>>>        return result ? *result : -ENOENT;
>>>    }
>>>
>>> -SEC("kprobe/sys_connect")
>>> +SEC("kprobe/__sys_connect")
>>>    int trace_sys_connect(struct pt_regs *ctx)
>>>    {
>>>        struct sockaddr_in6 *in6;
>>> diff --git a/samples/bpf/test_probe_write_user_kern.c b/samples/bpf/test_probe_write_user_kern.c
>>> index 6579639a83b2..9b3c3918c37d 100644
>>> --- a/samples/bpf/test_probe_write_user_kern.c
>>> +++ b/samples/bpf/test_probe_write_user_kern.c
>>> @@ -26,7 +26,7 @@ struct {
>>>     * This example sits on a syscall, and the syscall ABI is relatively stable
>>>     * of course, across platforms, and over time, the ABI may change.
>>>     */
>>> -SEC("kprobe/sys_connect")
>>> +SEC("kprobe/__sys_connect")
>>>    int bpf_prog1(struct pt_regs *ctx)
>>>    {
>>>        struct sockaddr_in new_addr, orig_addr = {};
>>>
