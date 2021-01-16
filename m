Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F272F8A19
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 01:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbhAPA5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 19:57:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7614 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725934AbhAPA5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 19:57:20 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10G0rx94004253;
        Fri, 15 Jan 2021 16:56:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=RSHy0YRh+LYdVQe9Mzju14yhKpwWKbVkPbCrFc0jL1M=;
 b=l40Ff9pT/VeBQ9equnrN5fqvLZxkcCe1nPISikEaISwzbObCK1ylq5QrKHLwX0mjgxel
 1QUpaNVczeDLPRMzrZ1Gmyxm3FEVlsXXiJpJ949H/WEPTJ1NMvk1Logj8MZy/Vmkseye
 gq+chkQfTYLAbE8H0FXu+J5pt3TBffIeUCg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3631cawdyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 15 Jan 2021 16:56:15 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 15 Jan 2021 16:56:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ajMiE5UOEXX2lUMTPrqvH8XRHhvQrY8vRPsCil1Ywnkc0yADYln3piTwoEhYg6trUd3zewVVUcLHtZxmRz5eIo0C3CI6emgxKjb+FK8ULsIzM75OyZQAMpKWD+hvXjJ6Ba6qomLlQttF7o0NbvB7LPmi0dOsFNEXpvVbsozXno5tN1C6/10iJCmaf2qxJSLgyzIWsSOao5rfe/e5nATZ1rS4j0ibfZPqefj37H0F89hKtocWP+t+YCrwrg/wTRdNqfcy8yJnt6BG2zq5FO/2hWnYzucWrbgEHhFRUug0BrNgiZ7ccwVQT8+p8ZH0nXvVlZRNu2vQbhgjqTBbXZwr9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSHy0YRh+LYdVQe9Mzju14yhKpwWKbVkPbCrFc0jL1M=;
 b=K3u3aa3mcP4uNoX9XdqplJ8/texZHr7wVs7IGBquZu32l4a+4AxXdqTx1ErOnErIEaqPyPxWAg2U5DI0WtQFYmqJxgGTxx2BKONJ8bMRJ8u/gVMDOieAAVANSjU5QvySVnWSc/MV24AHhcbr4hq4fYih2DI3j/tTNCW/sEyoz43E7qlSvHF3uE9CqT6r5ZMK9o+dH9kAJfI7MYhom5i+cawO2zAXIkM9AK2KK2iwPTrZua1KqFQeWGVMsPUZp/IxJb9o/BQwxFZGHBwCWLqfjNl0ysBCOvDQmFcg+MoS79DrA5RvoiVuTg332/wD6Qq9AI1BH8xXPZEPQh0bLPos8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSHy0YRh+LYdVQe9Mzju14yhKpwWKbVkPbCrFc0jL1M=;
 b=eW3MziVvd8MrvHaVn91A+mEgO+tvSNuBbeVqdRZ1GmWs/jP5SUHAvlPUK2j4KryU5p5IogfUNKlxJ7rkmYIa1dx0y5Yjle+LiKJDdKpWSBrxd1itBBGknh/5DUcpcmlfdByqGgkMgedmu28715FyXIdjFLCE51dycRlWfMOV5Fw=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3511.namprd15.prod.outlook.com (2603:10b6:a03:10e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Sat, 16 Jan
 2021 00:55:57 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3763.011; Sat, 16 Jan 2021
 00:55:57 +0000
Subject: Re: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing
 programs
To:     Song Liu <songliubraving@fb.com>, KP Singh <kpsingh@kernel.org>
CC:     Martin Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <Kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        kernel test robot <lkp@intel.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-2-songliubraving@fb.com>
 <20210111185650.hsvfpoqmqc2mj7ci@kafai-mbp.dhcp.thefacebook.com>
 <CACYkzJ4mQrx1=owwrgBtu1Nvy9t0W4qP4=dthEutKpWPHxHrBw@mail.gmail.com>
 <20210111215820.t4z4g4cv66j7piio@kafai-mbp.dhcp.thefacebook.com>
 <9FF8CA8D-2D52-4120-99A5-86A68704BF4C@fb.com>
 <e4002f5c-6c2c-0945-9324-a8dc51125018@fb.com>
 <CACYkzJ64h53iZq9EpL01NukB6Rh+rQ0fupdn+shn-dTQ8NWH=A@mail.gmail.com>
 <A0F77AB9-5C1D-4657-96C9-33B5FDF6DF00@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <72a52715-dcfc-dc0b-ac5b-e14b7540fd31@fb.com>
Date:   Fri, 15 Jan 2021 16:55:54 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <A0F77AB9-5C1D-4657-96C9-33B5FDF6DF00@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bb30]
X-ClientProxiedBy: MWHPR08CA0041.namprd08.prod.outlook.com
 (2603:10b6:300:c0::15) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1366] (2620:10d:c090:400::5:bb30) by MWHPR08CA0041.namprd08.prod.outlook.com (2603:10b6:300:c0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Sat, 16 Jan 2021 00:55:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5cf02dde-c315-45ed-607c-08d8b9b97c0f
X-MS-TrafficTypeDiagnostic: BYAPR15MB3511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3511FF4F59E62E4B92BEA0B1D3A60@BYAPR15MB3511.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h7nTb3v3Jqq+Xwi+O3bgqfLUjQmTWbOHclDpU+FXxmpG8CGGumxnByV+YuSeVIPQaVOmNdHVgGw507eOKQUq80Dh3lgWGb+Ba8WH3wqDNYkSX3DwxmENOYK5oJNXmJS3IErjPVbq0TnTCQbST+jV2aOyWAxTfQZ8OyJ0yVfuzEofJEHsQPkgOYBdCE2Ulomqu0u9Wm53hY68qZvvt9JN/hfCgpAFHwPGJRbZByFuuIB7mw+jLqv0aIpEHgZOOsBEcAmCeie6J3EQdihbyHOGukTufk6n0nxgCQjnkagPPGfEx2wr+2bAuEdR3PLNkNIyF2KDUVGQ4CvCxHrrraoSTqxsJKs42HRdU+psi0GYlT85NvXbigmgifFSZHj11lUyunbskbjv6JJ6aCTXWvfHTZOFurv2uyYrvsrfldmM4H2pKsCghGBYHZiFU/SeWHoJWZ57l6NefuQ5UHwILuQ4a89zvsulQGoBJC/7n6mU6eE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(39860400002)(346002)(376002)(2906002)(478600001)(66946007)(66556008)(66476007)(83380400001)(36756003)(6486002)(4326008)(52116002)(86362001)(110136005)(7416002)(54906003)(16526019)(2616005)(186003)(8936002)(316002)(8676002)(53546011)(31686004)(31696002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UlZoZkZiYTNKZUxtZWhSZVVaeHozdkFjREJ1cnlvd3JyMlpIV0FBVlVjRG9h?=
 =?utf-8?B?cEZEUkJ2bnJoTmtHMFFWejN6S0RlbithZy96aXUvb1BoWlI0clpFRGg1TzN0?=
 =?utf-8?B?OGpUMGxOMGxMWlphQjJTVHNOSmJpUGNQOCtINFdwTHBnNDNLWExMbjRPZDhW?=
 =?utf-8?B?RGp6blIyb3Z1VXFWeGpxY3g1YXBVRXZQVnBORkJYTzcyWUNDKzQxbk9JcTl6?=
 =?utf-8?B?RGViUk9Lc1hUZGphNktlaXArRFdiV01NT2V1Uk51WDI4Si9ma2g4c2V4SHVV?=
 =?utf-8?B?aGFqbVJSRVVUMDJmSkJHVXovSkFQL0dmd0EzR01JY1c5LzlUdXNUbXdYbzJ2?=
 =?utf-8?B?MTNtUjNwSXZxQWprQWVSaUlwNEZ2VHNudVN5V2xKdUhyeVlwamkyYW5EVnJu?=
 =?utf-8?B?S2VWMHpUSkRqMXppL2lWbnd5SFhNU3RNZnBKcnp2dXFicWZ6ZmJoMkR2NExz?=
 =?utf-8?B?V0VNN2hsbEdmcTRNWGRRbDc4UTNoWGU2UlQxSnZxeHVGTFlwUGIwTVk2aURY?=
 =?utf-8?B?aVh3L21nZHVJeEllaDhqWmlINkg3d3N3MjlqV21vcHJHT0ExN2pMdVZmbUxV?=
 =?utf-8?B?Lyt3WXdYOUVJQWNtcHliaGNHMHBxYXltQjd4WDJqWWN0dFFyRnhzR3p2NEFk?=
 =?utf-8?B?SmJ4b0R5QTRwRzZTYlVoU1VVamVteDBGZGl2dHJFUE9pMVlSMzU2SmNsQ1hL?=
 =?utf-8?B?aFVIRFFHNVEvZndkNWo5d0cwR0IwSHhxUE5BN25sSzBxSDNrRkJYd3ZhbVV3?=
 =?utf-8?B?RXd4SDJibGl1Rk0wVEY4dXVJK1dtK2J2UFdEaGUrMXJFd3A4eDQ4eTREb05Z?=
 =?utf-8?B?WlBJU3dHaGUzN1FidSswOHF5V3IxK0ttUU5UQW1Xc3h2UWhsSjl2MEJYVmV3?=
 =?utf-8?B?Zklob0NWL0hOcVRSMzJtUTRrK2w3MFJDOXBRNXFzeUpla1FYQ003a2VDRzFI?=
 =?utf-8?B?dFJqMjhUckI1OEkxNmFzcFFTY2daKzlEd3hiMjZabnEvSmozcXUrTEdQekl0?=
 =?utf-8?B?V0tCckJRY2RoVmNTQzdpL04rSXB0K0Q2b0FMN2F5VDlSY0xkTzJ3NGk3SlRZ?=
 =?utf-8?B?UXZNNUZ3NHFRdjVSdjU2SURnRWUzS1p1OU1YWldVTkc2aktCTnlmWnYxSmpJ?=
 =?utf-8?B?aEVTMTliYU90WmYzSE1vd0c3R21HZGFvUUhUSS9YVmJtN0hHeUdaN05rakxY?=
 =?utf-8?B?bmNlNVZEUzd5SWFwUVZhYSt6L0tWeDBZd2VRKzZ2UTgxMzVsYUJWclJsMmRG?=
 =?utf-8?B?VGNhLzZPQTZDWXZMV3ZWSmZmV1ZDc3Qwb3FPcVNMUjVEeHZNZ1N1MnNiQ1lI?=
 =?utf-8?B?b0hQVkJ0aTBsL2VlL09XRjlpZ2tmelBaVmxtMUduZEdoSmRXUWI5M1FKd3Bp?=
 =?utf-8?B?RHJCYm5DTnNsM3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cf02dde-c315-45ed-607c-08d8b9b97c0f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2021 00:55:57.7084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SLlyyP4hJhyQIg0J8F39rRO0qbQLluIMncoMxgNddL+10VSuekB3ozwvZ83OK+OP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3511
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_15:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 bulkscore=0 phishscore=0 mlxscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101160005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/15/21 3:34 PM, Song Liu wrote:
> 
> 
>> On Jan 12, 2021, at 8:53 AM, KP Singh <kpsingh@kernel.org> wrote:
>>
>> On Tue, Jan 12, 2021 at 5:32 PM Yonghong Song <yhs@fb.com> wrote:
>>>
>>>
>>>
>>> On 1/11/21 3:45 PM, Song Liu wrote:
>>>>
>>>>
>>>>> On Jan 11, 2021, at 1:58 PM, Martin Lau <kafai@fb.com> wrote:
>>>>>
>>>>> On Mon, Jan 11, 2021 at 10:35:43PM +0100, KP Singh wrote:
>>>>>> On Mon, Jan 11, 2021 at 7:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
>>>>>>>
>>>>>>> On Fri, Jan 08, 2021 at 03:19:47PM -0800, Song Liu wrote:
>>>>>>>
>>>>>>> [ ... ]
>>>>>>>
>>>>>>>> diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
>>>>>>>> index dd5aedee99e73..9bd47ad2b26f1 100644
>>>>>>>> --- a/kernel/bpf/bpf_local_storage.c
>>>>>>>> +++ b/kernel/bpf/bpf_local_storage.c
>>
>> [...]
>>
>>>>>>>> +#include <linux/bpf.h>
>>>>>>>>
>>>>>>>> #include <asm/pgalloc.h>
>>>>>>>> #include <linux/uaccess.h>
>>>>>>>> @@ -734,6 +735,7 @@ void __put_task_struct(struct task_struct *tsk)
>>>>>>>>       cgroup_free(tsk);
>>>>>>>>       task_numa_free(tsk, true);
>>>>>>>>       security_task_free(tsk);
>>>>>>>> +     bpf_task_storage_free(tsk);
>>>>>>>>       exit_creds(tsk);
>>>>>>> If exit_creds() is traced by a bpf and this bpf is doing
>>>>>>> bpf_task_storage_get(..., BPF_LOCAL_STORAGE_GET_F_CREATE),
>>>>>>> new task storage will be created after bpf_task_storage_free().
>>>>>>>
>>>>>>> I recalled there was an earlier discussion with KP and KP mentioned
>>>>>>> BPF_LSM will not be called with a task that is going away.
>>>>>>> It seems enabling bpf task storage in bpf tracing will break
>>>>>>> this assumption and needs to be addressed?
>>>>>>
>>>>>> For tracing programs, I think we will need an allow list where
>>>>>> task local storage can be used.
>>>>> Instead of whitelist, can refcount_inc_not_zero(&tsk->usage) be used?
>>>>
>>>> I think we can put refcount_inc_not_zero() in bpf_task_storage_get, like:
>>>>
>>>> diff --git i/kernel/bpf/bpf_task_storage.c w/kernel/bpf/bpf_task_storage.c
>>>> index f654b56907b69..93d01b0a010e6 100644
>>>> --- i/kernel/bpf/bpf_task_storage.c
>>>> +++ w/kernel/bpf/bpf_task_storage.c
>>>> @@ -216,6 +216,9 @@ BPF_CALL_4(bpf_task_storage_get, struct bpf_map *, map, struct task_struct *,
>>>>           * by an RCU read-side critical section.
>>>>           */
>>>>          if (flags & BPF_LOCAL_STORAGE_GET_F_CREATE) {
>>>> +               if (!refcount_inc_not_zero(&task->usage))
>>>> +                       return -EBUSY;
>>>> +
>>>>                  sdata = bpf_local_storage_update(
>>>>                          task, (struct bpf_local_storage_map *)map, value,
>>>>                          BPF_NOEXIST);
>>>>
>>>> But where shall we add the refcount_dec()? IIUC, we cannot add it to
>>>> __put_task_struct().
>>>
>>> Maybe put_task_struct()?
>>
>> Yeah, something like, or if you find a more elegant alternative :)
>>
>> --- a/include/linux/sched/task.h
>> +++ b/include/linux/sched/task.h
>> @@ -107,13 +107,20 @@ extern void __put_task_struct(struct task_struct *t);
>>
>> static inline void put_task_struct(struct task_struct *t)
>> {
>> -       if (refcount_dec_and_test(&t->usage))
>> +
>> +       if (rcu_access_pointer(t->bpf_storage)) {
>> +               if (refcount_sub_and_test(2, &t->usage))
>> +                       __put_task_struct(t);
>> +       } else if (refcount_dec_and_test(&t->usage))
>>                 __put_task_struct(t);
>> }
>>
>> static inline void put_task_struct_many(struct task_struct *t, int nr)
>> {
>> -       if (refcount_sub_and_test(nr, &t->usage))
>> +       if (rcu_access_pointer(t->bpf_storage)) {
>> +               if (refcount_sub_and_test(nr + 1, &t->usage))
>> +                       __put_task_struct(t);
>> +       } else if (refcount_sub_and_test(nr, &t->usage))
>>                 __put_task_struct(t);
>> }
> 
> It is not ideal to leak bpf_storage here. How about we only add the
> following:
> 
> diff --git i/kernel/bpf/bpf_task_storage.c w/kernel/bpf/bpf_task_storage.c
> index f654b56907b69..2811b9fc47233 100644
> --- i/kernel/bpf/bpf_task_storage.c
> +++ w/kernel/bpf/bpf_task_storage.c
> @@ -216,6 +216,10 @@ BPF_CALL_4(bpf_task_storage_get, struct bpf_map *, map, struct task_struct *,
>           * by an RCU read-side critical section.
>           */
>          if (flags & BPF_LOCAL_STORAGE_GET_F_CREATE) {
> +               /* the task_struct is being freed, fail over*/
> +               if (!refcount_read(&task->usage))
> +                       return -EBUSY;

This may not work? Even we check here and task->usage is not 0, it could 
still become 0 immediately after the above refcount_read, right?

> +
>                  sdata = bpf_local_storage_update(
>                          task, (struct bpf_local_storage_map *)map, value,
>                          BPF_NOEXIST);
> 
>>
>>
>> I may be missing something but shouldn't bpf_storage be an __rcu
>> member like we have for sk_bpf_storage?
> 
> Good catch! I will fix this in v2.
> 
> Thanks,
> Song
> 
