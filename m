Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26178444E8F
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 06:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhKDF7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 01:59:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50118 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229912AbhKDF7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 01:59:39 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1A41UXIo027152;
        Wed, 3 Nov 2021 22:57:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=AWHg6c+vCso49LJUCObbBFapZMIm6zyxdaH4tR9bEJw=;
 b=PsjLVPBj0gnfmU5kcqNZ1KNOFkBrStz7Lydn6PR1EDoEZRTwXvqPyEhtXL9pF4LgKBSs
 /B8I/J8ArIkUD7xRPZqnzHSIxBTbK6HIUbtRF18P1fenqI8fgNkNckTdSIa+06Ui3vys
 DzSfsBXHA4sOSfIR3zlj4nqu6D0uGCijmeI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3c45wq9p12-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 03 Nov 2021 22:57:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 3 Nov 2021 22:56:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDAKC2DnBBqGmJJWpELGMBzqtIrjWW78VxAoAQolbgzj7nlxqcHqrlQ+bsyuimv0zAAXzgeppSvXX9Ew86P/JQBg4NXf6Rhqo0oGgnkPUtVVDlItFhRh9LYthpNhcv5TcMo0U0wmSm+aZGUD+a83PytuQmClc1I0i9mzUgBFM65Nq5IiPAbTwNtfiRExEY4Y4e8RmKJlmGdGTTdfDSJMCPM4yA4bzDdvHhLXuC5lQRdLCkptUvfBE0bmPfHAWvmW9rryAnbnc6T4Z3PK6PmIawEts1xVRwJ3tsZzdzPycDGBZwsq/PuvFrueTmbRFUihPxHOwc5kfPxAi2uo1EWW9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AWHg6c+vCso49LJUCObbBFapZMIm6zyxdaH4tR9bEJw=;
 b=LqLcbhKdRyHRwDm3YKLJ6EldhNr0hGT6OSgM6ALZiwqFUiKHgSrg9WXyZw+xGucQ5A6KmWVJ4QEqg6X+E98x/AG0J16PiDu/zahAqmdjMHyEdeYfKNGQwvIqFoj9WGzA6eCUYdSATy3pNAcJuwxmMvZmlDPjzx13AFM8jm5RvEmYXwkHS663B7Ygxt0MJSU161YakPhmrtZQ/S8ERQ8Ek/C4F6SqdZ+TsFCFEmPs2EywFMDZ/teAtztODr+97MeoOI8hoc7ovX8Gx+BrK8ozxsshirWZ8WC00by5Vb5MAT2ne6E9/OQXiC5tjQa6q9iLrS96x/Ob/5iy0L19S/nyCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5161.namprd15.prod.outlook.com (2603:10b6:806:234::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Thu, 4 Nov
 2021 05:56:56 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953%9]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 05:56:56 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
Subject: Re: [PATCH bpf-next 1/2] bpf: introduce helper bpf_find_vma
Thread-Topic: [PATCH bpf-next 1/2] bpf: introduce helper bpf_find_vma
Thread-Index: AQHXy34dUJKLIJdmf0quC2zhdA62zqvvR1QAgAM99gCAAGVEgA==
Date:   Thu, 4 Nov 2021 05:56:56 +0000
Message-ID: <A1EFD9C7-15FE-4419-A69F-7503F298C265@fb.com>
References: <20211027220043.1937648-1-songliubraving@fb.com>
 <20211027220043.1937648-2-songliubraving@fb.com>
 <368db409-c932-030b-a5bc-89efa56de289@iogearbox.net>
 <65E6A08E-1B20-4CFA-9756-4759728D21E2@fb.com>
In-Reply-To: <65E6A08E-1B20-4CFA-9756-4759728D21E2@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 610391f0-7df8-4c63-3a64-08d99f57e8b8
x-ms-traffictypediagnostic: SA1PR15MB5161:
x-microsoft-antispam-prvs: <SA1PR15MB5161A872B89CB803AF31B3D4B38D9@SA1PR15MB5161.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XvOIKv0imurzI+5x9JPB52jrsozTuvADmLaTE7RgnLGwP9XOqKruXoWPB53bUH0WC1T4NBJnpXIBznOH/EzP03/YqR87IeSkvI6G+x2EZ4A5ryuHdFDbqj/nKe0j4ih+MvhnrlzHEOgnDpoPTktg6FIicaQKV2Xh+eHnj4RzgNugcAwEPEAdhiY5Eqq56naWRemX9+cNvGBcAxwrLM9U532dO1q6HK8TWQ4PWuV7+Nc8qEgTh8jAwSP/jp/WKBDW9n9M9RyVg+K/uEOWoiEUjnGTTMAvUaIzRjgrXEose0AJlnhe7QSamxw9ciUQtbI4pX5ImwbFjXUrl6BF7wfTPMk/Vk1rZ2sGOCPOHWvohCkbOcQBmhP573s4tLRHlXWVgvsP/6cT3acXul+BNyXnNaWXZo31ZKt7W+cFq4SrELtaYIxStKDVE+CRucQJWOXJMO7QumzzbG7DH5sEWLN3gDBZVGiYR/U2fU3R4Y+6uFZpVafEwwyE0D9xYBHNBbrVlT+e4Fe/EQTmJ+TF8FmJt1de/pN7Gpa0hvpAtuCLi/PUWsQjHdq0t5mmKEGXJUmk1/mhpCtydn2+iUW4m2w00EfAL8ooFu+eo8d6eaNuSsqU11WYxqfBarakz08IHBxzmjbPO7WQ/C/3aLNseLG+tTO+GJEQeyXoANIxHqZNn6YDssEIorC61ZL2jtXCIjUhtsJCriYN2D/6HEXEe+f0kgJ9+tuIqsNB2IC2Fbtem2FB2gMQRJuGfET9x+dP9xg8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(4326008)(122000001)(6486002)(64756008)(6916009)(66556008)(5660300002)(53546011)(33656002)(8676002)(66446008)(66946007)(66476007)(54906003)(76116006)(316002)(86362001)(6506007)(91956017)(83380400001)(36756003)(8936002)(186003)(508600001)(38070700005)(71200400001)(2616005)(2906002)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bWnYo2JJ6KMkq+QTp4tgenbMVibbf6cHVs7zqc22cj8s+bMgImPZtD+LB+2Z?=
 =?us-ascii?Q?SeHnrf1o7rXzHQycmvi26NvFVYhjXQldnyT6rLPy/8+Ut0UKURtWmf4GmAOd?=
 =?us-ascii?Q?uDG5CmG3amaRBUFcU01y7FdvlogA8dXdQHy3GaOdkSiEeY+uPx5iywdzWTAs?=
 =?us-ascii?Q?LpboB3lnuhp5C38FFPWDQSGuIZuACg3RkgvHGVc6JKWTqnBj6HKtvPhKzolB?=
 =?us-ascii?Q?NaemScimgSVwkDYlnQCU7ExPqj+q4OiF/cF0Fig594GJk5k2/lQfcna588Xy?=
 =?us-ascii?Q?uJGPcHZClxZJYqTUnVDzDtnIjKmZCqhusj2yBjkFjKoLgJL2puOoXIM0m9Dv?=
 =?us-ascii?Q?sM7m0Kx2jmsGiiMhMsHjjI/B2nyBFDUN7fffQm5FMgQ7CThbjVW/MiSxweYs?=
 =?us-ascii?Q?p4SEcmNri2Ct5tDg6A+ZCPiz4ChjlYPFkA4xLXz1NvdCfncGxDelO+/vgAgj?=
 =?us-ascii?Q?sr/l2zroq15tj92lWlglgfZdbs8ckipcalcSLDmUgPX9xQG15AAZFblBptB6?=
 =?us-ascii?Q?9E1GTln3sGmrBzO8QpeuLXDZN7RXqEZENUndR4m8oJRigvraChwjkCfyhAYk?=
 =?us-ascii?Q?NlUfuiTb3OwEEKKFyAtfQezyweg+uxEACe2+e1J05A+MFhzS/NujsHXr0Kko?=
 =?us-ascii?Q?G9NHU5xFBgfcylAdVqD6e3LU9/RDdVeoHSkImN8FEw7mnv1W+xcm5XrhgntC?=
 =?us-ascii?Q?z6lYGvn4CpJo6ZBJCL7h078oOUuHRhI+L/+MeofMlKqHJ/HkPRvde60P24t3?=
 =?us-ascii?Q?/7EJ5s+dhEf3GbB166GmKIWoRCD/uwVWCvcSagfIdkWBihYDqxBMgLitMC+7?=
 =?us-ascii?Q?yvRlhFi8GHjsB4CT4Z+eq8OHB0hMMEWCwuil2p5ntW8juiRWUy4mroTrDYrZ?=
 =?us-ascii?Q?M0OKScpEwOmDipCZR5QRlYJ9T0KTq1aE3g/gxdKrUWiBZrM7ykfGhuaTAq1L?=
 =?us-ascii?Q?8OZKuHzJ1J9URdXSDjaXG2Nqd5amnBE25IyWeZYLLfNWW/El7wzZo2zNSooV?=
 =?us-ascii?Q?nOkUDV7s0DirpXAIOo2r9aUtMErvN5BWupshUvQlQSpW/OCL2zAYIj8pISUU?=
 =?us-ascii?Q?2c/3KlNVH0/0uB1wl2dUcBj809DUfo/YgsHfgx25Cpiv0Djaf40l9GVF8tpg?=
 =?us-ascii?Q?S0WTA4/KYTRROcetFP0MxjnnHB0wEb1pa0V15x/cyQPba+YmlwOzy+kefn4V?=
 =?us-ascii?Q?Sobweq3Gcgagq3/OTzGoAI947BKR4d1FKtUFNDtVJlpaZWcn4UGEpWF8o9/b?=
 =?us-ascii?Q?S8Y+bJs2myKFYsfpJQcb7Qp8Q5+dJp2ALhrXvFxVqu9Cmoc2AAKm2maMOIRZ?=
 =?us-ascii?Q?hy4U1KnZiqJpPpTdWz+aiMHVoxYefNcv3MVZZ6UPzvsY6yzoQNqVst6m/JPf?=
 =?us-ascii?Q?bYsvt0PFexolBy8hshxysSwuJsHRNrP59SAzZPW/5dj3PZIllI12CtRZyiQQ?=
 =?us-ascii?Q?2P8Wa2ONjpW1sUBeSJPZFF/rxatxDWRcFvKoo59tC9AW/wnxrQs11gmcDi6g?=
 =?us-ascii?Q?QKZBmyyM73XMNZmCWSuD3rNFAl6fAC5d+lWp6MRmmN/NTZM1iyWgT76I9G1a?=
 =?us-ascii?Q?hADcIoAFl2wnznsYtszWKU1y3pxm2V1lo3WHPPAapqYDrRwqBuHF5wHxlf5u?=
 =?us-ascii?Q?qRrnO8oUqvez7gDJ9BPxXGi0vlyqQ3vYq5oLSXOAQYM1PWLD529zTNol2Tqh?=
 =?us-ascii?Q?kQ8UOQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3D6AF223AAEDEE41ACA3A8F429FA6033@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 610391f0-7df8-4c63-3a64-08d99f57e8b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 05:56:56.3620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3bFeRB2vslWdUO1l4v61ZFa3z9A0ITU8d20LS8UMlcyfiRD6vArn9vvbVe7j310DoHIX3VhDy3U+bXSWNtobQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5161
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: o0O93E5kkvDTpoWiwuXq6CWcitxbwIPH
X-Proofpoint-ORIG-GUID: o0O93E5kkvDTpoWiwuXq6CWcitxbwIPH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_01,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040033
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 3, 2021, at 4:54 PM, Song Liu <songliubraving@fb.com> wrote:
> 
> 
> 
>> On Nov 1, 2021, at 3:23 PM, Daniel Borkmann <daniel@iogearbox.net> wrote:
>> 
>> On 10/28/21 12:00 AM, Song Liu wrote:
>> [...]
>>> /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>>> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
>>> index b48750bfba5aa..ad30f2e885356 100644
>>> --- a/kernel/bpf/task_iter.c
>>> +++ b/kernel/bpf/task_iter.c
>>> @@ -8,6 +8,7 @@
>>> #include <linux/fdtable.h>
>>> #include <linux/filter.h>
>>> #include <linux/btf_ids.h>
>>> +#include <linux/irq_work.h>
>>>   struct bpf_iter_seq_task_common {
>>> 	struct pid_namespace *ns;
>>> @@ -21,6 +22,25 @@ struct bpf_iter_seq_task_info {
>>> 	u32 tid;
>>> };
>>> +/* irq_work to run mmap_read_unlock() */
>>> +struct task_iter_irq_work {
>>> +	struct irq_work irq_work;
>>> +	struct mm_struct *mm;
>>> +};
>>> +
>>> +static DEFINE_PER_CPU(struct task_iter_irq_work, mmap_unlock_work);
>>> +
>>> +static void do_mmap_read_unlock(struct irq_work *entry)
>>> +{
>>> +	struct task_iter_irq_work *work;
>>> +
>>> +	if (WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT)))
>>> +		return;
>>> +
>>> +	work = container_of(entry, struct task_iter_irq_work, irq_work);
>>> +	mmap_read_unlock_non_owner(work->mm);
>>> +}
>>> +
>>> static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
>>> 					     u32 *tid,
>>> 					     bool skip_if_dup_files)
>>> @@ -586,9 +606,89 @@ static struct bpf_iter_reg task_vma_reg_info = {
>>> 	.seq_info		= &task_vma_seq_info,
>>> };
>>> +BPF_CALL_5(bpf_find_vma, struct task_struct *, task, u64, start,
>>> +	   bpf_callback_t, callback_fn, void *, callback_ctx, u64, flags)
>>> +{
>>> +	struct task_iter_irq_work *work = NULL;
>>> +	struct mm_struct *mm = task->mm;
>> 
>> Won't this NULL deref if called with task argument as NULL?
> 
> Will fix. 
> 
>> 
>>> +	struct vm_area_struct *vma;
>>> +	bool irq_work_busy = false;
>>> +	int ret = -ENOENT;
>>> +
>>> +	if (flags)
>>> +		return -EINVAL;
>>> +
>>> +	if (!mm)
>>> +		return -ENOENT;
>>> +
>>> +	/*
>>> +	 * Similar to stackmap with build_id support, we cannot simply do
>>> +	 * mmap_read_unlock when the irq is disabled. Instead, we need do
>>> +	 * the unlock in the irq_work.
>>> +	 */
>>> +	if (irqs_disabled()) {
>>> +		if (!IS_ENABLED(CONFIG_PREEMPT_RT)) {
>>> +			work = this_cpu_ptr(&mmap_unlock_work);
>>> +			if (irq_work_is_busy(&work->irq_work)) {
>>> +				/* cannot queue more mmap_unlock, abort. */
>>> +				irq_work_busy = true;
>>> +			}
>>> +		} else {
>>> +			/*
>>> +			 * PREEMPT_RT does not allow to trylock mmap sem in
>>> +			 * interrupt disabled context, abort.
>>> +			 */
>>> +			irq_work_busy = true;
>>> +		}
>>> +	}
>>> +
>>> +	if (irq_work_busy || !mmap_read_trylock(mm))
>>> +		return -EBUSY;
>>> +
>>> +	vma = find_vma(mm, start);
>>> +
>>> +	if (vma && vma->vm_start <= start && vma->vm_end > start) {
>>> +		callback_fn((u64)(long)task, (u64)(long)vma,
>>> +			    (u64)(long)callback_ctx, 0, 0);
>>> +		ret = 0;
>>> +	}
>>> +	if (!work) {
>>> +		mmap_read_unlock(current->mm);
>>> +	} else {
>>> +		work->mm = current->mm;
>>> +
>>> +		/* The lock will be released once we're out of interrupt
>>> +		 * context. Tell lockdep that we've released it now so
>>> +		 * it doesn't complain that we forgot to release it.
>>> +		 */
>>> +		rwsem_release(&current->mm->mmap_lock.dep_map, _RET_IP_);
>>> +		irq_work_queue(&work->irq_work);
>>> +	}
>> 
>> Given this is pretty much the same logic around the vma retrieval, could this be
>> refactored/consolidated with stack map build id retrieval into a common function?
> 
> I thought about sharing the irq_work code amount the two. The problem was we need
> to include irq_work.h in bpf.h. But on a second thought, maybe we should just 
> move bpf_find_vma to stackmap.c? This will avoid including irq_work.h. I guess it 
> is not too weird to have bpf_find_vma in stackmap.c.  

Actually, we can just add a local header for it in kernel/bpf. Adding bpf_find_vma
to stackmap.c means bpf_find_vma requires CONFIG_PERF_EVENTS. It is not a real 
issue in most systems, but may break some build tests. 

Song


