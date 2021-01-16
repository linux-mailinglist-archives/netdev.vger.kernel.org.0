Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04802F8A95
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbhAPBvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:51:15 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35426 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726059AbhAPBvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:51:14 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10G1Sjdm023141;
        Fri, 15 Jan 2021 17:50:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=oaQzAhhlrkNVoNaCMGFdaZIzQAtb10Yx/rNJPWmW8hw=;
 b=LBuoPTzMLdNh40rv2WvTwAZ575uDhVzZZDBB0JkZdb6n7gN3LFzOobCAy0ZmFxyEnHZX
 EwAc3tz0Vke6670Qti8OQ0TUvyeJv2l1UL4iIPP6tbPS+MplL4MTGP5g3TSAcZ+xczWh
 GrneyKhq8rABdb9Fati7yQzDl9Fm6xSSIC4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 363e4ftnx2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 15 Jan 2021 17:50:11 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 15 Jan 2021 17:50:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDItLRZNEbJ1u9w+lNeVZV4kJx/e8xp4oano1l7gBZ3kiOC2X82S+TDowODzXXbO3taFfxTKamEN6CmM1a+Ehyu8CU1E3IsP4V6zEKaONLwJ+WMzWp1HA6XL24H8TgYVGdACM2CYwiZx1/iaTNt1cu60Q97Zg1luvPQnLK7Paag2YmRb8QxCXnZ3KHQ6DKHFy/q5bQm9q6v8OQMvWJBw/KQz1t2GnXoT0RxaBxv0UXaf722W8dQj6+HuQIvJZcUWeEbQPstfF5+y7KSxu3pcH01bhpVTurL63dotyZ6jKFhnpkCeyLljUWVXh0pCt/AygQqarRaEVNuq+UhLnjtoWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oaQzAhhlrkNVoNaCMGFdaZIzQAtb10Yx/rNJPWmW8hw=;
 b=bIRdTVGGnxFipJYodKk7JpbKukdIRD7ccBfJm9ui39r1AfMqZljy2dWomuAEedhmy6IG6YLH9w+mUTGjQrd3icqmBRKfNbXCSZly6nLfBratiL3Up56S6aqpy04UQVIWLX13G4Ueb/I9uC1aZ2Yg6MSrf+Y9DJPSZu9WA7C1TSci9UDl4VuDCimQJN2qfq5jWWUbH6xVEQ/V0y7WxZfdUtIT8zD+kiidgNkDyMOuSjezAltnbWtFfAjqFwRTe+IZW5G1RQTwoVBw9JF7whI6LxG8uf2Z7QgvaYiZQ8wh3gTC5yMhLbqQPk060MlnzCHLzM/nyke2CBlZcmBpNrBmyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oaQzAhhlrkNVoNaCMGFdaZIzQAtb10Yx/rNJPWmW8hw=;
 b=BiyOdHJXeojFtbQcWZ1vbPaqofoB6slrf6bZEt+381j1x58c8Eb3tUIM416SppiI6M9MNWl2LaeIshxsD5eNKvflFCxwu020m+7SMG866v/qc7LCwdEdDjBCyy+tb4wZmEzwhK1kBOvoH3X5UD97TVEmfvA5+KTUpcOJashDqHM=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2823.namprd15.prod.outlook.com (2603:10b6:a03:15a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Sat, 16 Jan
 2021 01:50:06 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3763.011; Sat, 16 Jan 2021
 01:50:06 +0000
Subject: Re: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing
 programs
To:     Song Liu <songliubraving@fb.com>
CC:     KP Singh <kpsingh@kernel.org>, Martin Lau <kafai@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
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
 <72a52715-dcfc-dc0b-ac5b-e14b7540fd31@fb.com>
 <75A2A254-4D51-41F0-9B01-ED2AFA745E03@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d798d2c0-66da-a3ee-a140-df11cd4ba69b@fb.com>
Date:   Fri, 15 Jan 2021 17:50:03 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <75A2A254-4D51-41F0-9B01-ED2AFA745E03@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bb30]
X-ClientProxiedBy: MWHPR04CA0048.namprd04.prod.outlook.com
 (2603:10b6:300:ee::34) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1366] (2620:10d:c090:400::5:bb30) by MWHPR04CA0048.namprd04.prod.outlook.com (2603:10b6:300:ee::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Sat, 16 Jan 2021 01:50:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f6e9145-0063-4370-dd5e-08d8b9c10caa
X-MS-TrafficTypeDiagnostic: BYAPR15MB2823:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB282335C38D86C4593E9EAC08D3A60@BYAPR15MB2823.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 73RwfzoHDhuuNNMROsNwSoq5TxzWGfGHQZWyRAE9aSFbEdsAorPTSfSpdyoq6SmfgqLa5vIEp6e8Woj1/tiu1/65K56ZMxuJGMXCf90ryaybuDUfA7Mmi87PHYXJ8+NnWbKI+yZjtBJR7H6FcF0HUOdHE+dU4l1YEIL9SvehbDU9m3KhhfBsvMiWduGYlOhRf5EccuPPf5ZT/XSMJSbk7Im0B+jXo6+AB1nNzYW3apOKGRjyEgKYrJrokyFT1S5hB0V3LIEwDgnrMFIkGtKu2CQ8SmBW2ftBOxB7K6YzfxQvYDdjZ5FwA+qLkwdMdUCsIiCpx7diBwF8aVvvmO+CgIYsS3YjHND7QXhWAOJHixa1GQoQ+lwfscBfGu+h0AOcBBDWzlEcI01NNAavtpKA9Nv9gUtvsjrxae9KwdGehkEbHF6/+JVLYqmXQxY3+7h1q0dZHEYhhSrl12oiiHvELgvCIQ+vnJN21KX8ccuY3nI/xu2flMX5q5ZvaYJlBVzvuq7Xh6CCE/wrjrN6zimlByu9lwVF/5axyA79AfMHAXsSImctcYnAMneHicCLQDz9sOZ9QVg/FcbGxEN5ONVWlm442qxTnN/TyBTlgkZmndc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(136003)(396003)(366004)(16526019)(66476007)(66556008)(7416002)(8936002)(31686004)(2616005)(86362001)(186003)(83380400001)(54906003)(6486002)(53546011)(37006003)(478600001)(36756003)(8676002)(6636002)(5660300002)(52116002)(66946007)(316002)(31696002)(4326008)(6862004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QUFZU20zT3l0VTZiQVhkL2Y5Ylc2bFJnQTZOblUxcWw4RVZ3OHNKbytITFlj?=
 =?utf-8?B?WnNTUjhIaEEzd0hVNkQrZEhrV1luSUVtb1M3a096VHpHTk4xNVZMUHFDV0lO?=
 =?utf-8?B?Q283ZjFrN1hHdWVsY3NZbFdpZXVrVng1M0oxWVk3L1I4LzFZU29lTENCaHlz?=
 =?utf-8?B?ZTVHbWVrZGU2ZVllZU1DNlo1d0dLMk1QSjVESGhiSHQ2SW5JUWRTVnhzTndI?=
 =?utf-8?B?clRUakQrTTdZYXpucnJucTBJc0xJcmNVNnVuajQ1UWxVWVF6TGtrd2JDSXVJ?=
 =?utf-8?B?OHczdWRMQkpTdk9oS1d1SVg1dWpaM3B1UGlmbFErYWxWcTJ4b2dSQnRPWC9K?=
 =?utf-8?B?ZU8zd2tJYzg3bmx0SThFOTZtdGpyN05wUXlIdldiL2dZL05wQk5uRzdDbDhh?=
 =?utf-8?B?V0FUL3BlOU45L0x2TEVjbjE3YldDY3hpUnhmZlpOcW5KeWNSc2tNUUdCdEZ4?=
 =?utf-8?B?L0FzZ0taYnkrNmc0WEhqaFJNQTV5Zk9QQlA1b3BHc0dhMmx1ckl4ZWxuSGhr?=
 =?utf-8?B?ak9BVDhyUmJsSXNBemVOeU1ERi8wRWZVMVRKSkpKNWpXRm1CRHhlem11aGYx?=
 =?utf-8?B?b0ZUR1QwNFBYTnhCZ2ZxQURxazFkc1EveDRpUnRsS09COTNxa3YrNjZRY0RC?=
 =?utf-8?B?L3E3SXpIcVMyY2txcjJHcVRNenFpQmtJY0lMTzhqN3lUSzlJL3lhK1o5OFl1?=
 =?utf-8?B?OXoxb1lrb28vUGlaZ1hmdGoxTzBtYXg2aHQwRjlJay9WSVl1MExNQndNRUVK?=
 =?utf-8?B?OUJHcWxtV1ZUL0FpdTBTcVFHcDlPZmxiN1ZZajRCSElHRTY0QVQwTUdwdVhE?=
 =?utf-8?B?aWpQdFFaTG45dE9HZ2FHR1R4QVBsUFhKQ0svclBiVG1mVmZoblV0T1ZkNXpv?=
 =?utf-8?B?eWlsbkErb25LbW5Fa1p1NUZVZjZGc1dIVzdjV1hPTlZQYzJsT25IRks0MXBi?=
 =?utf-8?B?VUtIOWlqK0UrRFYraW9MVGFCSVlCR2N2bFA1Q1VlS0NjdFcwZGlGcGJ0N1Iz?=
 =?utf-8?B?WS9laDF0TlhXbWlnZ2NudWRtQ05hZndaRkhjNEpGRnlnUndKUEg3WWNvbkhC?=
 =?utf-8?B?bjFLaWJZditpc3g3bkk0Qnczak4yeWhHTGFVdzhYQ3dpUnk5TjNQTGhWT3FI?=
 =?utf-8?B?alZqajNUOFRyUEJDQjlhaFJObmUva3lTOFh1T1ZCNWVqbHF3STA2cktsbTRH?=
 =?utf-8?B?Z3hYR1VrUmlpOU5oMllIbTFxeVhiYzlWbXkrQXpKYjF5TDhkVXFmUkUrampZ?=
 =?utf-8?B?NWxLemVtQUtzK1dKcDVaVXJsNWxQRXlLbXJ0MUR6a25XbC9wWWZjWmVvYUZi?=
 =?utf-8?B?eEJaVFp2dEVLMnA4RnNpSUNlMHNwc1g4UXR3QmhzL0tHN1RhNXBmWFFFOHNR?=
 =?utf-8?B?ZUgrNzdkWWxycnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f6e9145-0063-4370-dd5e-08d8b9c10caa
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2021 01:50:06.7345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7maUk4O3J8eJ8Spi0KLSyun3j54BkLJLKJzNTyy9Mj/fiSLizNVhLpOeN+90QpPW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2823
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_15:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101160009
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/15/21 5:12 PM, Song Liu wrote:
> 
> 
>> On Jan 15, 2021, at 4:55 PM, Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 1/15/21 3:34 PM, Song Liu wrote:
>>>> On Jan 12, 2021, at 8:53 AM, KP Singh <kpsingh@kernel.org> wrote:
>>>>
>>>> On Tue, Jan 12, 2021 at 5:32 PM Yonghong Song <yhs@fb.com> wrote:
>>>>>
>>>>>
>>>>>
>>>>> On 1/11/21 3:45 PM, Song Liu wrote:
>>>>>>
>>>>>>
>>>>>>> On Jan 11, 2021, at 1:58 PM, Martin Lau <kafai@fb.com> wrote:
>>>>>>>
>>>>>>> On Mon, Jan 11, 2021 at 10:35:43PM +0100, KP Singh wrote:
>>>>>>>> On Mon, Jan 11, 2021 at 7:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
>>>>>>>>>
>>>>>>>>> On Fri, Jan 08, 2021 at 03:19:47PM -0800, Song Liu wrote:
>>>>>>>>>
>>>>>>>>> [ ... ]
>>>>>>>>>
>>>>>>>>>> diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
>>>>>>>>>> index dd5aedee99e73..9bd47ad2b26f1 100644
>>>>>>>>>> --- a/kernel/bpf/bpf_local_storage.c
>>>>>>>>>> +++ b/kernel/bpf/bpf_local_storage.c
>>>>
>>>> [...]
>>>>
>>>>>>>>>> +#include <linux/bpf.h>
>>>>>>>>>>
>>>>>>>>>> #include <asm/pgalloc.h>
>>>>>>>>>> #include <linux/uaccess.h>
>>>>>>>>>> @@ -734,6 +735,7 @@ void __put_task_struct(struct task_struct *tsk)
>>>>>>>>>>       cgroup_free(tsk);
>>>>>>>>>>       task_numa_free(tsk, true);
>>>>>>>>>>       security_task_free(tsk);
>>>>>>>>>> +     bpf_task_storage_free(tsk);
>>>>>>>>>>       exit_creds(tsk);
>>>>>>>>> If exit_creds() is traced by a bpf and this bpf is doing
>>>>>>>>> bpf_task_storage_get(..., BPF_LOCAL_STORAGE_GET_F_CREATE),
>>>>>>>>> new task storage will be created after bpf_task_storage_free().
>>>>>>>>>
>>>>>>>>> I recalled there was an earlier discussion with KP and KP mentioned
>>>>>>>>> BPF_LSM will not be called with a task that is going away.
>>>>>>>>> It seems enabling bpf task storage in bpf tracing will break
>>>>>>>>> this assumption and needs to be addressed?
>>>>>>>>
>>>>>>>> For tracing programs, I think we will need an allow list where
>>>>>>>> task local storage can be used.
>>>>>>> Instead of whitelist, can refcount_inc_not_zero(&tsk->usage) be used?
>>>>>>
>>>>>> I think we can put refcount_inc_not_zero() in bpf_task_storage_get, like:
>>>>>>
>>>>>> diff --git i/kernel/bpf/bpf_task_storage.c w/kernel/bpf/bpf_task_storage.c
>>>>>> index f654b56907b69..93d01b0a010e6 100644
>>>>>> --- i/kernel/bpf/bpf_task_storage.c
>>>>>> +++ w/kernel/bpf/bpf_task_storage.c
>>>>>> @@ -216,6 +216,9 @@ BPF_CALL_4(bpf_task_storage_get, struct bpf_map *, map, struct task_struct *,
>>>>>>           * by an RCU read-side critical section.
>>>>>>           */
>>>>>>          if (flags & BPF_LOCAL_STORAGE_GET_F_CREATE) {
>>>>>> +               if (!refcount_inc_not_zero(&task->usage))
>>>>>> +                       return -EBUSY;
>>>>>> +
>>>>>>                  sdata = bpf_local_storage_update(
>>>>>>                          task, (struct bpf_local_storage_map *)map, value,
>>>>>>                          BPF_NOEXIST);
>>>>>>
>>>>>> But where shall we add the refcount_dec()? IIUC, we cannot add it to
>>>>>> __put_task_struct().
>>>>>
>>>>> Maybe put_task_struct()?
>>>>
>>>> Yeah, something like, or if you find a more elegant alternative :)
>>>>
>>>> --- a/include/linux/sched/task.h
>>>> +++ b/include/linux/sched/task.h
>>>> @@ -107,13 +107,20 @@ extern void __put_task_struct(struct task_struct *t);
>>>>
>>>> static inline void put_task_struct(struct task_struct *t)
>>>> {
>>>> -       if (refcount_dec_and_test(&t->usage))
>>>> +
>>>> +       if (rcu_access_pointer(t->bpf_storage)) {
>>>> +               if (refcount_sub_and_test(2, &t->usage))
>>>> +                       __put_task_struct(t);
>>>> +       } else if (refcount_dec_and_test(&t->usage))
>>>>                 __put_task_struct(t);
>>>> }
>>>>
>>>> static inline void put_task_struct_many(struct task_struct *t, int nr)
>>>> {
>>>> -       if (refcount_sub_and_test(nr, &t->usage))
>>>> +       if (rcu_access_pointer(t->bpf_storage)) {
>>>> +               if (refcount_sub_and_test(nr + 1, &t->usage))
>>>> +                       __put_task_struct(t);
>>>> +       } else if (refcount_sub_and_test(nr, &t->usage))
>>>>                 __put_task_struct(t);
>>>> }
>>> It is not ideal to leak bpf_storage here. How about we only add the
>>> following:
>>> diff --git i/kernel/bpf/bpf_task_storage.c w/kernel/bpf/bpf_task_storage.c
>>> index f654b56907b69..2811b9fc47233 100644
>>> --- i/kernel/bpf/bpf_task_storage.c
>>> +++ w/kernel/bpf/bpf_task_storage.c
>>> @@ -216,6 +216,10 @@ BPF_CALL_4(bpf_task_storage_get, struct bpf_map *, map, struct task_struct *,
>>>           * by an RCU read-side critical section.
>>>           */
>>>          if (flags & BPF_LOCAL_STORAGE_GET_F_CREATE) {
>>> +               /* the task_struct is being freed, fail over*/
>>> +               if (!refcount_read(&task->usage))
>>> +                       return -EBUSY;
>>
>> This may not work? Even we check here and task->usage is not 0, it could still become 0 immediately after the above refcount_read, right?
> 
> We call bpf_task_storage_get() with "task" that has valid BTF, so "task"
> should not go away during the BPF program? Whatever mechanism that

Oh, right. this is true. Otherwise, we cannot use task ptr in the helper.

> triggers the BPF program should either hold a reference to task (usage > 0)
> or be the only one owning it (usage == 0, in __put_task_struct). Did I miss
> anything?

Sorry. I think you are right. Not sure lsm requirement. There are two
more possible ways to check task is exiting which happens before 
__put_task_struct():
   . check task->exit_state
   . check task->flags & PF_EXITING (used in bpf_trace.c)

Not sure which condition is the correct one to check.

> 
> Thanks,
> Song
> 
>>
>>> +
>>>                  sdata = bpf_local_storage_update(
>>>                          task, (struct bpf_local_storage_map *)map, value,
>>>                          BPF_NOEXIST);
>>>>
>>>>
>>>> I may be missing something but shouldn't bpf_storage be an __rcu
>>>> member like we have for sk_bpf_storage?
>>> Good catch! I will fix this in v2.
>>> Thanks,
>>> Song
> 
