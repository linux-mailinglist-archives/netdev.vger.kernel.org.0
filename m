Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA45825A2FC
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 04:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgIBCYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 22:24:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22988 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbgIBCYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 22:24:05 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0822LZDr023344;
        Tue, 1 Sep 2020 19:23:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=kfQ3pxehV7vbgU1PdHp9LvP4TUUqhV7CMKCkb2C7mWM=;
 b=P1hx4qvDcwsrE8eYCl9F0PAawF1XrWG0NCfxKjE3V84lK8LjbLaXzc0GWpMfMEhLDO+E
 mYBALxiVLnnz0zbU55JyGewoZ+MFvUCFzyUM8/CgI7jjZ3Sr/0uY71M0MaaKPbnGycE2
 R7ngbvDX06r1ZmHeyyPIQ4Eq673E42299ZE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3386gtenxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 01 Sep 2020 19:23:51 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Sep 2020 19:23:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKBRLoM5eMQMsK2uv0TpiU9T/OHFVnQ37kPU75RLnol6EE0yxGy7NvMThjptApzw6DjI+nlmxZLISaoSowUSLag+T0xruLhyw9dgbDUstPIBgEG5yuNcwnU0kFgrjJ+Q65jY0vfr0i7LP0Vc18XUUu5rBCo/S2ouCoLirq7S8U8B8duaXkBg+1AnhOB/DT0PuWUppgWLv4WLFaBK92mz2xNq+OmZUXAJ+3uu4sfg0O2SkjJdibXeq837wmCILU5Wl2AUu29VyUbV3jbcESD9LxVSi8Vau2E7HTZhYFOLo7hj7l/2I3IfJA56x5smxWdTJm2ar/8OOJlpSq+oL4fENg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfQ3pxehV7vbgU1PdHp9LvP4TUUqhV7CMKCkb2C7mWM=;
 b=D7UeRvKy6CbK/q7ZdwGY2CJCvqhq1PgTLBgAoZmeHFG3Bd/SRRFIlUa0478/giTXM9OwTcBqlLFBJ2t9yseo6oemscmAdwhko/500nG2DYIAzaF3OQuo69AP7S6vkWdggtB7FYyH+Mz3GoYZ3gdgaPK2JlBBREv715mpvgirkEygCohQBgdzFyP2Ygw5jWJqsm8wtixcwVFcNckEaGWcHnnIRC3qMAghDB26kVtyFKRd85hJtehVtu/cIcYxcBQF/ZOqqRrql2h7+sR9dBBYb9bMsTe6cMUuB90z8vkjQ/TC+R3bCOB3SQ2Vt2SsKP45LfnhpClytVl7slJeuF9Jtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfQ3pxehV7vbgU1PdHp9LvP4TUUqhV7CMKCkb2C7mWM=;
 b=Z5J1mmg/i0TUMfUElHeRLa9H6Wvr8EkJCNR8j0Xyf+GcrwNrWoBDV8xbKcdn/4T2EpSEEPWxhIb0Fw5uTfKHfS9EG00CenSQDXGwJ2AcYINyWbhCyXuIEj97V55TmRTvo3fh0Fa+RmWyzt9cXimTjtrFZDKJAxvo8XUxNriaAMg=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3206.namprd15.prod.outlook.com (2603:10b6:a03:10d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Wed, 2 Sep
 2020 02:23:45 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3348.015; Wed, 2 Sep 2020
 02:23:45 +0000
Subject: Re: [PATCH bpf-next 2/5] bpf: add main_thread_only customization for
 task/task_file iterators
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200827000618.2711826-1-yhs@fb.com>
 <20200827000620.2711963-1-yhs@fb.com>
 <CAEf4BzYBQVX-YQyZiJe+xrMUmk_k+mU=Q-RNULeS4pt-YyzQUA@mail.gmail.com>
 <784f27f8-552a-41e8-c8c4-a4ea0b590884@fb.com>
 <CAEf4BzbW20hYtFqTf+cynVqbOtVJK7oO7ySBB+WP6yRRYdQoNw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <18bd840f-1cfc-9b0e-23fc-c1f863855d55@fb.com>
Date:   Tue, 1 Sep 2020 19:23:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <CAEf4BzbW20hYtFqTf+cynVqbOtVJK7oO7ySBB+WP6yRRYdQoNw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:a03:40::47) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BYAPR04CA0034.namprd04.prod.outlook.com (2603:10b6:a03:40::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 2 Sep 2020 02:23:45 +0000
X-Originating-IP: [2620:10d:c090:400::5:365a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f25a6eff-a5ad-47dc-5e30-08d84ee737c6
X-MS-TrafficTypeDiagnostic: BYAPR15MB3206:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3206B343FDF4E3D625970673D32F0@BYAPR15MB3206.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dDjzaclax8OHti0PsWgbz0KVc+kVBWo2/Pg1cVsI+KqozfNGaTLbUPsq83RlRhPgtgPfmVG8C+Ngr1etQA3WrU0/idZpDBzIRZo+d0eKIVkhPMMVLlbhksGt+HacodlFSdBEP+EQkrYRy5gdsR2rkHep84zwzye9kEqyPrXcLbuKpoDM6h+/SYuON+wEI/sQjwxCi7VGBTRdWZSNWTecf14QvdTN0XL9e5Fvt/iL+YTYTNkqrMyFMt51QMZ4Na2PtIEDxjkUIxLM7ADIONP7j0NmUz2qvoLhuuWnCsf/kLuBdj8lrvRIKoUwT2WmxiPMl1y7H9ozjfROfeG0jdwYIIVN3F4R6vYwJLLT0yzPCkWm/rN0mp7qWrqBzbHdcmmB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(376002)(396003)(366004)(5660300002)(8676002)(2906002)(36756003)(8936002)(186003)(6916009)(478600001)(4326008)(2616005)(66476007)(54906003)(956004)(66556008)(52116002)(86362001)(31696002)(6486002)(31686004)(53546011)(66946007)(16576012)(316002)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 4MwWl9UY+dz0aRq3fa3uyzrWAnRPwohOOpc5Abuo+p96B2OKef3oNTq3ukWiMxBH12vBfYT2hq3w5KAl6bndaeqOGMr7whrhM3o58m/Fl6YgCH7w6rwJ3U6KTe5NITO7H6m7kLH7tXoJf/BqFKM97W/xfyqudKdjH6U4itKF2Tia7y8FLXoMSyuPGtfAqyz1Rd6IcWuy/0TJrBpq4HybyUfjIkJaIWEQnb4uvnNSilLNGvDchkS1v1FhowUkAiBK3Nlp1LVV+QQMnSP5HSoNshiFZeXB4AZv8UmFt2Rk/gnUjJmLTOas1MB0cz0CWliG2ajZYTnhkfUjDuGd0mQ57zi8T8ZG5aTj5ebj45xpyH4GeTPoRV0zFNNz94HQPJUn/lKXd1lzijUi562ByQJ8eT+peQozILdyWUyIVOnQ8gnyvqNciXJ55S0sgKirN66Dm15qm3RkrlB2gsM0n1p+F2vrmL/058B0w3wNlXjTPxiqK+K1GhyOsBdIeunCNFAQWUo0kPUggUKafefrRsWdu74QB5XVw9eZQujzEryUYeDwORfZrrB7bfrlvgNc+mgsXQOaZ6mbvhyiaDBE1bapBCJPPP8y68QWPa4CvYhBFzx8hGgi6c5x5mWrirgp+AjYHA2/VeeksyH4VxADBicxZ5vhg+0bF5Bakcs50yIllCM=
X-MS-Exchange-CrossTenant-Network-Message-Id: f25a6eff-a5ad-47dc-5e30-08d84ee737c6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2020 02:23:45.5382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FYroIzcyuZ92XlTqFGpgg46HIMop1x4Mkj7U0811Wnqo66PjBmCeJw2ZzjmGB2ns
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3206
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_02:2020-09-01,2020-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020020
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/20 5:34 PM, Andrii Nakryiko wrote:
> On Thu, Aug 27, 2020 at 11:09 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 8/26/20 10:07 PM, Andrii Nakryiko wrote:
>>> On Wed, Aug 26, 2020 at 5:07 PM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>> Currently, task and task_file by default iterates through
>>>> all tasks. For task_file, by default, all files from all tasks
>>>> will be traversed.
>>>>
>>>> But for a user process, the file_table is shared by all threads
>>>> of that process. So traversing the main thread per process should
>>>> be enough to traverse all files and this can save a lot of cpu
>>>> time if some process has large number of threads and each thread
>>>> has lots of open files.
>>>>
>>>> This patch implemented a customization for task/task_file iterator,
>>>> permitting to traverse only the kernel task where its pid equal
>>>> to tgid in the kernel. This includes some kernel threads, and
>>>> main threads of user processes. This will solve the above potential
>>>> performance issue for task_file. This customization may be useful
>>>> for task iterator too if only traversing main threads is enough.
>>>>
>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>> ---
>>>>    include/linux/bpf.h            |  3 ++-
>>>>    include/uapi/linux/bpf.h       |  5 ++++
>>>>    kernel/bpf/task_iter.c         | 46 +++++++++++++++++++++++-----------
>>>>    tools/include/uapi/linux/bpf.h |  5 ++++
>>>>    4 files changed, 43 insertions(+), 16 deletions(-)
>>>>
>>>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>>>> index a6131d95e31e..058eb9b0ba78 100644
>>>> --- a/include/linux/bpf.h
>>>> +++ b/include/linux/bpf.h
>>>> @@ -1220,7 +1220,8 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>>>>           int __init bpf_iter_ ## target(args) { return 0; }
>>>>
>>>>    struct bpf_iter_aux_info {
>>>> -       struct bpf_map *map;
>>>> +       struct bpf_map *map;    /* for iterator traversing map elements */
>>>> +       bool main_thread_only;  /* for task/task_file iterator */
>>>
>>> As a user of task_file iterator I'd hate to make this decision,
>>> honestly, especially if I can't prove that all processes share the
>>> same file table (I think clone() syscall allows to do weird
>>> combinations like that, right?). It does make sense for a task/
>>
>> Right. the clone() syscall permits different kinds of sharing,
>> sharing address space and sharing files are separated. It is possible
>> that address space is shared and files are not shared. That is
>> why I want to add flags for task_file so that if user knows
>> they do not have cases where address space shared and files not
>> shared, they can use main_thread_only to improve performance.
> 
> The problem with such options is that for a lot of users it won't be
> clear at all when and if those options can be used. E.g., when I
> imagine myself building some generic tool utilizing task_file bpf_iter
> that is supposed to be run on any server, how do I know if it's safe
> to specify "main_thread_only"? I can't guarantee that. So I'll be
> forced to either risk it or fallback to default and unnecessarily slow
> behavior.
> 
> This is different for task/ bpf_iter, though, so I support that for
> task/ only. But you've already done that split, so thank you! :)
> 
>>
>>> iterator, though, if I need to iterate a user-space process (group of
>>> tasks). So can we do this:
>>>
>>> 1a. Either add a new bpf_iter type process/ (or in kernel lingo
>>> task_group/) to iterate only main threads (group_leader in kernel
>>> lingo);
>>> 1b. Or make this main_thread_only an option for only a task/ iterator
>>> (and maybe call it "group_leader_only" or something to reflect kernel
>>> terminology?)
>>
>> The following is the kernel pid_type definition,
>>
>> enum pid_type
>> {
>>           PIDTYPE_PID,
>>           PIDTYPE_TGID,
>>           PIDTYPE_PGID,
>>           PIDTYPE_SID,
>>           PIDTYPE_MAX,
>> };
>>
>> Right now, task iterator is traversed following
>> PIDTYPE_PID, i.e., every tasks in the system.
>>
>> To iterate through main thread, we need to traverse following
>> PIDTYPE_TGID.
>>
>> In the future, it is possible, people want to traverse
>> following PIDTYPE_PGID (process group) or PIDTYPE_SID (session).
>>
>> Or we might have other customization, e.g., cgroup_id, which can
>> be filtered in the bpf program, but in-kernel filtering can
>> definitely improve performance.
>>
>> So I prefer 1b.
> 
> Sounds good, but let's use a proper enum, not a set of bit fields. We
> can support all 4 from the get go. There is no need to wait for the
> actual use case to appear, as the iteration semantics is pretty clear.

Agree. enum is better than individual bit fields esp. considering they
are mutually exclusive. Will design the interface along this line
when time comes to implement those customization. Thanks!

> 
>>
>> Yes, naming is hard.
>> The name "main_thread_only" is mostly from userspace perspective.
>> "group_leader_only" might not be good as it may be confused with
>> possible future process group.
>>
>>>
>>> 2. For task/file iterator, still iterate all tasks, but if the task's
>>> files struct is the same as group_leader's files struct, then go to
>>> the next one. This should eliminate tons of duplication of iterating
>>> the same files over and over. It would still iterate a bunch of tasks,
>>> but compared to the number of files that's generally a much smaller
>>> number, so should still give sizable savings. I don't think we need an
>>> extra option for this, tbh, this behavior was my intuitive
>>> expectation, so I don't think you'll be breaking any sane user of this
>>> iterator.
>>
>> What you suggested makes sense. for task_file iterator, we only promise
>> to visit all files from all tasks. We can do necessary filtering to
>> remove duplicates in the kernel and did not break promise.
>> I will remove customization from task_file iterator.
> 
> Thanks for doing that!
> 
>>
>>>
>>> Disclaimer: I haven't got a chance to look through kernel code much,
>>> so I'm sorry if what I'm proposing is something that is impossible to
>>> implement or extremely hard/unreliable. But thought I'll put this idea
>>> out there before we decide on this.
>>>
>>> WDYT?
>>>
>>> [...]
>>>
