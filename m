Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246BD2F35DB
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392844AbhALQdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:33:33 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14126 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388991AbhALQdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 11:33:32 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10CGVbB3016114;
        Tue, 12 Jan 2021 08:32:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=bDDvF3g6OCZJ2Am1YluK4bYCWH32K8G6zEF2mkvINvw=;
 b=Xwm2xm1y102Ql2VOjqxLXg8vDGlXE6o1FLDb/rDfzCXqBQeeiDjQG80yqyXIsCgH5xx0
 /Ll120j9Hu5uNOp4j1zEXWhiTjlEM9ITs2NZqGzAdymgp7gJb+0+6nSfDxb9wccfLfVb
 rGZcQTI3miNbzdrXduY8/4zUtQT1NG7AJgQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35yw1pkk0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 Jan 2021 08:32:25 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 08:32:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ut5JLomFrkN9s+eqNOoCpJPJCkiP7eYC2sX15pOG0cbDxkeyyyvK0lp7hOlfkTbnpT5ecbTFlX201vAMlLVu8Vkfk50bmGktccorJnaeXYHyaVxfLa0f7B1/o5LOK9GFdprc/FGkH9iUoLzZrcmmD0tMsr4Qu8ZCLhsfSyntgqc6KGjIYbryZHtUXRVvjrRHj/c7SvgxxikBEXUzhkRPh+DtAR/DtaLyB43PCJrJc3nGweMHE4aTTIV7S+FadhwayBMkDLBqH0w5yTSdVoZTu5X1AB6IRmTOPLnT3H7JsSJ7rPiL476tWK8DRTAOvmVpfjFW6NfdwhlK3OLi3EEV/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDDvF3g6OCZJ2Am1YluK4bYCWH32K8G6zEF2mkvINvw=;
 b=ZmnwemCCIqt7MP2cgFt1qRwAvpW6VTaQMJVXvAUBywNvrYbWI0qlwyYicz3ozfmpiRPegkqKwl5aRa7KnlfnFuaJB63tn0m2hzoC+XI8bIxzMlJp/rbP3CQOBR2LqcN/8gQ1ghBYi19PGOhO1zF/mAi7EQMZzMoo5rwc/gWJsV6Yxe5BySaVuxMXIDOlm7Gv2fDnizdopTyJ67yCKzOfJQbT8Ud1jAOyFztY2zO3YDTCn9Qg+vWzrlVBSXOvI1361m9tF1B+JxvlgqxAjPgMBUzQP+iBF3+RAC4h145RnYXq2TlMh1UkB+KNODRnphFhM+CEZRmRDFDaa9UpI5X82w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDDvF3g6OCZJ2Am1YluK4bYCWH32K8G6zEF2mkvINvw=;
 b=O1qCf6lSlpR1Pa5OCyntXxpZIuE5hIIcvVBXZE0cVCqCBlsIWfm0uyGB6hDwFEoyostzsOweClWooeBLTnvkJDSNzYJAvzfjLIKGrXtwKN4guMww5GnCFTwChyiavtrM1pDrXKO2iRaB5b8onEBoSyOA6JniTyP9UhrIEH6z/dk=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.10; Tue, 12 Jan
 2021 16:32:22 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 16:32:22 +0000
Subject: Re: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing
 programs
To:     Song Liu <songliubraving@fb.com>, Martin Lau <kafai@fb.com>
CC:     KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
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
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e4002f5c-6c2c-0945-9324-a8dc51125018@fb.com>
Date:   Tue, 12 Jan 2021 08:32:18 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <9FF8CA8D-2D52-4120-99A5-86A68704BF4C@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:3e3]
X-ClientProxiedBy: MW2PR2101CA0019.namprd21.prod.outlook.com
 (2603:10b6:302:1::32) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::190b] (2620:10d:c090:400::5:3e3) by MW2PR2101CA0019.namprd21.prod.outlook.com (2603:10b6:302:1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.1 via Frontend Transport; Tue, 12 Jan 2021 16:32:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb711ab4-c73b-44a2-b9b8-08d8b717a37f
X-MS-TrafficTypeDiagnostic: BYAPR15MB4088:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB40880BA2C012F0B2F52C0DC4D3AA0@BYAPR15MB4088.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l0QoSrtU6tJolR/3Mg6YecnsBYgxvD7YXxKQ+/zxx3hzxjuREEfkPEHpoDM4O8PYXEgdPwbxRSWN9hV3/fTkXmJHW+R/kzx4NhNhsKFtAwg3emOokbcZdaaazXa7u1AP59f3PEIqdCRQHWXCzBBhzTpfA5htBGPxvfny6es2K14uxfchsTGPRT8HTmriPIm59EHoSFDYSrxpMXW3qj3qQk6pndqQe9ylaHo76iAbZehb/wEu/nM0mqAVBx9z1QrAHlbmzGqJgEeobwFvNPm2JuGDGl6YxMumdfq83ynGVlryE+n6zyl2DhGPfiNXeJd2Zniux/petAfhxZqRnckh01hs+7ie8vanhxIE+uER1oOu+OSPiJn8zr0Nv0Us7nKTe82OQv36uo1bS7FDeh3ejdEdXEFz29sVi14jbUDBEocwyinqQdGI1m9I9YKYJSrjGdCQ5FeiMlH2gR7ErOoU3norkP+bhklrHQCtGjfLvsw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(39860400002)(346002)(136003)(2906002)(53546011)(2616005)(6486002)(5660300002)(110136005)(8936002)(31686004)(83380400001)(7416002)(4326008)(66556008)(8676002)(478600001)(186003)(66476007)(316002)(54906003)(6636002)(36756003)(66946007)(16526019)(86362001)(52116002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dFRpMDh2Ry9vaW15VFV1OGdLVHdZcTFkcGhVMGtLWGRRNE9ISU9UK05xVzZB?=
 =?utf-8?B?cnI1dmExUGF4dDBEZkdCWXlTeGRscDRldUt0YmJESWZaWHNGeFZOaFNHOGoz?=
 =?utf-8?B?emhha0Q3RzJKZ1VzVGR1S3NXMk9Mdit0OFAyK2VkUXBMc0ZiUkFMOVhNY282?=
 =?utf-8?B?YUJDVlRIQmoyeGcrK3NmTFA4TDNYV3V3TU1PN2tlWVMwZnJQaHRocFpmV1M0?=
 =?utf-8?B?Mk12YTdnaWZPVTBNRDZXZCtHSkRieVI3RGZoVUdnSHI2Q092Tmx0UCtCK1lk?=
 =?utf-8?B?V1AyTUErYnhnUWM1SDNhdGZtQjBiazBKSXJsUGRPWTRzT2s1TTIvSFU3MFZm?=
 =?utf-8?B?c0dFSWVyd2t0VGxuZ1hDYk9LNC9YZkRIODMxN29xbW9kOEhzcTVKQlpuRE5K?=
 =?utf-8?B?OURsN2w4MTBIRFFIa3pwUjVrY2NtSG9RWnZRZFZkK3RtUG5raGtiUUl0ZSt2?=
 =?utf-8?B?RWlIVldOMXlCSnhyQXpmWk05L0NxTGN0RVBsOWR0cXJGNVFGeXZOcnNsck81?=
 =?utf-8?B?aE54L0k5WitqQ2VSOC8xaG0zSEREbnpta3NHcW9BalUwZ1NTQkdtWnZmeTlK?=
 =?utf-8?B?TzNacEd6clFISXRhVHlGMm5XRnovRkFwQ256Q1BLUktsN2VxSUVUR1RnTk51?=
 =?utf-8?B?NjJOZU9CNFlkdWV1RDFKMVVEb0VlZGRsUUFkWG8rUUg0TlFsSjBvdXFxdDNh?=
 =?utf-8?B?dXFuSzZVUDhGUGRLZE5zcTJ2T1VwZWIyRm1TUGEwa0N0ckgxNnArOGk0MDFY?=
 =?utf-8?B?SisxYkM2aDJiMm5jclRUYzUxMnZWeGRka0tYQUtpeDJoZTg4em5pcE1FUVhL?=
 =?utf-8?B?MU5pSkVkanV5QW5PN09kQTJYdWdjUGwwdUpJdVp3RGVEaVUrYWgvcXczd0JU?=
 =?utf-8?B?NGpxb2RxcGpIdS9walg2a3MvZ2ZrZTdtNHhOR1gwMUh1ODBzZmNZVHVaMlRC?=
 =?utf-8?B?NjFtTklHS25mYTJOODJJVW9mZUpsaEsyMFoyMmRqOFVVRy9DN1A5OUUwdzNT?=
 =?utf-8?B?SFIrcEtCOFRXRVU2T3lVU2lQRzRIUkF2ekhKZ2Z3T05kM0E1QytTNExuTFIr?=
 =?utf-8?B?MFRTRUp5RHFCMlBSSExsSThRaHdhK1AzRTF3MzNKaGR5a3JtWnRMQ3djYkN3?=
 =?utf-8?B?bC95RCtmdG92alBkN1BSNUk4Q2VONEVOcXJGd3FReXE5SEdNK3dnUzhNVW5P?=
 =?utf-8?B?RG84MCtXYVVtZ3ByMWZFWjdhbFAyR2grZmI3RHpnUStHZ3Y1aHJvV1VNcmpT?=
 =?utf-8?B?RWQzWUJkeE9NdmlYZ21KM1BreGhrQlJHWUlHcHlFU3doRCt4VTVKUU5BSnVM?=
 =?utf-8?B?MW9ZTXU5Z3JxRUN3TjEwZ3ZrdWgyQVlmSHByMFhOOFRuVkx0dkV0NEhIM0Y4?=
 =?utf-8?B?NFZ0SEh0ZkJRSFE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 16:32:22.6433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: fb711ab4-c73b-44a2-b9b8-08d8b717a37f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TnC48+z7g6+8HXEZ9iLsIiaTYZfAp7m7fBChGbNtRyLjC6/OrjmudVMoJQ2C8+j9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4088
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_12:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120095
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/21 3:45 PM, Song Liu wrote:
> 
> 
>> On Jan 11, 2021, at 1:58 PM, Martin Lau <kafai@fb.com> wrote:
>>
>> On Mon, Jan 11, 2021 at 10:35:43PM +0100, KP Singh wrote:
>>> On Mon, Jan 11, 2021 at 7:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
>>>>
>>>> On Fri, Jan 08, 2021 at 03:19:47PM -0800, Song Liu wrote:
>>>>
>>>> [ ... ]
>>>>
>>>>> diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
>>>>> index dd5aedee99e73..9bd47ad2b26f1 100644
>>>>> --- a/kernel/bpf/bpf_local_storage.c
>>>>> +++ b/kernel/bpf/bpf_local_storage.c
>>>>> @@ -140,17 +140,18 @@ static void __bpf_selem_unlink_storage(struct bpf_local_storage_elem *selem)
>>>>> {
>>>>>       struct bpf_local_storage *local_storage;
>>>>>       bool free_local_storage = false;
>>>>> +     unsigned long flags;
>>>>>
>>>>>       if (unlikely(!selem_linked_to_storage(selem)))
>>>>>               /* selem has already been unlinked from sk */
>>>>>               return;
>>>>>
>>>>>       local_storage = rcu_dereference(selem->local_storage);
>>>>> -     raw_spin_lock_bh(&local_storage->lock);
>>>>> +     raw_spin_lock_irqsave(&local_storage->lock, flags);
>>>> It will be useful to have a few words in commit message on this change
>>>> for future reference purpose.
>>>>
>>>> Please also remove the in_irq() check from bpf_sk_storage.c
>>>> to avoid confusion in the future.  It probably should
>>>> be in a separate patch.
>>>>
>>>> [ ... ]
>>>>
>>>>> diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.c
>>>>> index 4ef1959a78f27..f654b56907b69 100644
>>>>> diff --git a/kernel/fork.c b/kernel/fork.c
>>>>> index 7425b3224891d..3d65c8ebfd594 100644
>>>> [ ... ]
>>>>
>>>>> --- a/kernel/fork.c
>>>>> +++ b/kernel/fork.c
>>>>> @@ -96,6 +96,7 @@
>>>>> #include <linux/kasan.h>
>>>>> #include <linux/scs.h>
>>>>> #include <linux/io_uring.h>
>>>>> +#include <linux/bpf.h>
>>>>>
>>>>> #include <asm/pgalloc.h>
>>>>> #include <linux/uaccess.h>
>>>>> @@ -734,6 +735,7 @@ void __put_task_struct(struct task_struct *tsk)
>>>>>       cgroup_free(tsk);
>>>>>       task_numa_free(tsk, true);
>>>>>       security_task_free(tsk);
>>>>> +     bpf_task_storage_free(tsk);
>>>>>       exit_creds(tsk);
>>>> If exit_creds() is traced by a bpf and this bpf is doing
>>>> bpf_task_storage_get(..., BPF_LOCAL_STORAGE_GET_F_CREATE),
>>>> new task storage will be created after bpf_task_storage_free().
>>>>
>>>> I recalled there was an earlier discussion with KP and KP mentioned
>>>> BPF_LSM will not be called with a task that is going away.
>>>> It seems enabling bpf task storage in bpf tracing will break
>>>> this assumption and needs to be addressed?
>>>
>>> For tracing programs, I think we will need an allow list where
>>> task local storage can be used.
>> Instead of whitelist, can refcount_inc_not_zero(&tsk->usage) be used?
> 
> I think we can put refcount_inc_not_zero() in bpf_task_storage_get, like:
> 
> diff --git i/kernel/bpf/bpf_task_storage.c w/kernel/bpf/bpf_task_storage.c
> index f654b56907b69..93d01b0a010e6 100644
> --- i/kernel/bpf/bpf_task_storage.c
> +++ w/kernel/bpf/bpf_task_storage.c
> @@ -216,6 +216,9 @@ BPF_CALL_4(bpf_task_storage_get, struct bpf_map *, map, struct task_struct *,
>           * by an RCU read-side critical section.
>           */
>          if (flags & BPF_LOCAL_STORAGE_GET_F_CREATE) {
> +               if (!refcount_inc_not_zero(&task->usage))
> +                       return -EBUSY;
> +
>                  sdata = bpf_local_storage_update(
>                          task, (struct bpf_local_storage_map *)map, value,
>                          BPF_NOEXIST);
> 
> But where shall we add the refcount_dec()? IIUC, we cannot add it to
> __put_task_struct().

Maybe put_task_struct()?

> Thanks,
> Song
> 
