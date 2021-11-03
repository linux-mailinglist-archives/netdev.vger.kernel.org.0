Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB7C444BD3
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 00:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhKCX5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 19:57:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24750 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229541AbhKCX5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 19:57:13 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1A3KAc4q017162;
        Wed, 3 Nov 2021 16:54:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=/AZ+97RAAPk5o4jjOn4wkrJ4oSlCfPNuUgsLcpEaSJM=;
 b=DHuvZ1dkNBpv1EWqBxYnfvPa5QqwJC9OUwtb5rAbdt2IS4/nTMYtrEhCOTEi829wBANH
 hydRKTwS3XruG4FoynBFtg5URXIokBON40KzTTrnXa4q4naEWIyrIfLipiiQUuh8dtDh
 kc+xau7gWdQZZ0IiZ69XXnZcu3wl/xCpe2g= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3c3dcf1a60-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 03 Nov 2021 16:54:35 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 3 Nov 2021 16:54:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwtZQdS42QtRz1SUk554Dp0z4lCK3nyni5+kokCjzdwJBfWii9HxdTqY9Bs04O84SannAXfjxxg9rQEhNSfj5qUYU+mP+jlYeTqa0hTy3VqO+wO2D6KXiVGNvLvmxtoo13Xg1Rxzpy6Vpu1dFSlcslgqQWJjyWYuvGwmpEOuVndoKrW5HBXZTzwy5I9gPMAQLfdGS40gc9da67qMOZb7otoIuhqL0hDzwiEjSWSgVRkTMbLCsoU233O10dvNaaHE7JaEodGm3utGn7ACSu8Re+ACgVGXh/Qpb6j6NvZpyiC3c8HRPUyHxQlw6Oe4wQKDpcLNan3GghXqtZuI20n5dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/AZ+97RAAPk5o4jjOn4wkrJ4oSlCfPNuUgsLcpEaSJM=;
 b=T6N54H4pa6tS+z29O77M3Kdxh4Swe+nHHx7gQ+JYsyhJEPyea56bXj+cqwiPkhrJ1WlqIN5GQ//sCQLM4b1mVhTAaf+WfQJivdW492Lq/iFzITf/8R9ahjvyVtwXyMCyK8Q+PMs6AZNtIh2Yot+zosz/YdhDoiYEPT5X8x1aG7vZ7XQHMr9gjjwK0rh9tEcN9Q256m322cyPrt4xdA2zlvv8LIEV7FdZ7/TSM70Ilezu0Hpb0NCLwXXZPjodJ6w054iF7o86IzskZv0aUOG6AVAUdnDMVsVcZlqVvZ7EsVNBNeUAeyxOYUaaZpVlnJ8Nw5Uu24JgdX7MTSHFWm2ocw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5140.namprd15.prod.outlook.com (2603:10b6:806:234::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Wed, 3 Nov
 2021 23:54:29 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953%9]) with mapi id 15.20.4669.011; Wed, 3 Nov 2021
 23:54:29 +0000
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
Thread-Index: AQHXy34dUJKLIJdmf0quC2zhdA62zqvvR1QAgAM99gA=
Date:   Wed, 3 Nov 2021 23:54:29 +0000
Message-ID: <65E6A08E-1B20-4CFA-9756-4759728D21E2@fb.com>
References: <20211027220043.1937648-1-songliubraving@fb.com>
 <20211027220043.1937648-2-songliubraving@fb.com>
 <368db409-c932-030b-a5bc-89efa56de289@iogearbox.net>
In-Reply-To: <368db409-c932-030b-a5bc-89efa56de289@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4de442a-2277-4604-331f-08d99f254693
x-ms-traffictypediagnostic: SA1PR15MB5140:
x-microsoft-antispam-prvs: <SA1PR15MB5140A87A598F203DD654F5DFB38C9@SA1PR15MB5140.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Cjm2NCrNTBHXNSncUNMeMVal+qMp203IQpzVbx/Ds4l8/ov36X86KP5W9kdZBXyiVJIPLaUcf7LZ0Lzx8cqtuPQs5+psqIggW5L2FeLSaFpmu6MpXNFgfUUCVxEWbV9GFH/PBUaGcZqGmUUdfNXMec34aXJSzX/kXQbZUJ/lgh1NFs7GBk/0egwJpIaJtLQQuM4luludKF0f+IxLpFymwdNZmGsR7+sHOldiuXzvoXup7sW98z45XBnDCATe7TZKj/vrkfZkYB19q++kfFtmA7DQ/sm3yKGXCgB15qm7EeedHbLWhvXj0zk8rVIJeil/+EDCu+XTj66LkoWyMzHvdTG3gcLR0BgdRalDwxEkld657XQofi6oVAomc0qzA7GUyD0SnVxTS9Qjhl0FLiQLofodDtqJYvPw35r2nj621DlPOUW8ysnVO9Y18KGU/HboHqZ0feSfSupCIfjpCCOFGrCVAkQCRwISdATNiItuHdpWohuVZi1j0sL1qITn4b3Ix+u1JgDBXa/PVXWAp2yAF6IRXFMnVfGhpXJhZ0cOTI8WceRqmrG5Z70oP17EC0IhrBMxe8oiW5X+0zIjTCab89nSPNyFcjKaVi7YRR14stx6rj/bx4ECYmDEbGS7SinS1GhaxUwue4/vc3XHhxLUatVO8m90rIeYxOp7cHvOUXSo02ncZD0gbMVrFFcSfJLfedgW68ncDTBXoIeXJ6bkYg96ZG/KrFKlUJAqW++6xH6/fMfG5uyTAHJHxy8ntJG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(64756008)(66446008)(2906002)(83380400001)(71200400001)(66476007)(122000001)(5660300002)(86362001)(53546011)(54906003)(2616005)(38070700005)(4326008)(36756003)(508600001)(66946007)(6486002)(6916009)(186003)(316002)(33656002)(6506007)(8936002)(38100700002)(91956017)(76116006)(8676002)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LV3lbARV5E2RpsEEYvaTlETxYa2Wx8ln9/ItlhzPGIfPw5jrHFr777m0J54m?=
 =?us-ascii?Q?YPMNWyNud9A9UZuMXjSnbfWvDCAD7lArXjrFX55W6mgvfKOS1BgYmhVGlDID?=
 =?us-ascii?Q?7gqcRwaLYi961pC+UZtwjCA2lfa9ia6wF2ylbUcVJ/VmvRXzUyg0F1l5aw5F?=
 =?us-ascii?Q?CFdRhzeJEZa06wkMcBeXtUfyWDkR4iKj4ipLjkezTkFkERs8aQT6Jyi6V+WD?=
 =?us-ascii?Q?+B/7DujmeFYUnpUtsMJxmgh8qLli3e+HKzc7UnJIww2XnT/ki5YzpZab+5JV?=
 =?us-ascii?Q?ijXQJ4DNP+EtncJ4FuA21XT2HieXrgwJU9oY4dbwSFQ+qRs6Dr4KyXnxPh7f?=
 =?us-ascii?Q?8EyKLdDK5DyWAgWla2nNTYwVfNKNvJeZ/RCrmnDjcnFb3LMfxSskHrq8uK7v?=
 =?us-ascii?Q?dM+bmCJMuHdk5XrRKem4Gkf+FJIuxbe7FW5OswqzNwHyvMcoFEAPkTAhpT1j?=
 =?us-ascii?Q?0EN4k3RD42kSHyoQ0Av2XDW7+izCiVtsqlpsiNxEHDtf33AcmvHClfELW4tq?=
 =?us-ascii?Q?xQaCdiCEoGM2RyAXp2+bBC6fviof85WzWJLcrNhLgTrNviZ3tQAhopE/YFpZ?=
 =?us-ascii?Q?SCbsEFd5rn3vSbI4lwHMFJ3FtJDtxelMAbm+g2eXqXj9Xd6j6d0/+HHxB+rh?=
 =?us-ascii?Q?4PZ55Y/dfy02kNG9Iv6HRn0m074j0vHNBKa5nTh9yL3ISzfMOXGn6CvSQqUi?=
 =?us-ascii?Q?y3TXsX/lSmK/rAVx5nNkFiTkpw+Oa5qBOkusOCbtI9NzKWagkYS2FHUIBaki?=
 =?us-ascii?Q?EcpxGB4wJX8vEjr/o7m9S5WvIsgrOphEnGdzWYvlhhj2UEtdyWjbmKWPlue8?=
 =?us-ascii?Q?aLmKo+zlGro+ywlcCfDuF/DmRGz7M0gdYZASR7v63R54GdUtlV34xDEul+x2?=
 =?us-ascii?Q?iteNgVMpdHS+b4p9pTI5e1d+IOPeefVct3ckBPB6cY4RykpUpO1OZzYdSiph?=
 =?us-ascii?Q?lTjV2CLp0oTx/aeELLGy7e9kq3rwW6aul1y8qKoXGnAjJX0IN78aSCo7ucsm?=
 =?us-ascii?Q?8LoVLQcB2ehMUPgx7/qHKjmoZG6xOyHnJ5ClVPJ1tN2oaUSqsuvGVhlo7Tha?=
 =?us-ascii?Q?4I/l4tdzxBPen5rnnmoUyyozrIT9zirZ1FyIvHz0thUwrk9XsJhtyOrx1ryz?=
 =?us-ascii?Q?q95V+OD91EKqlGpjaqZjABdLPMHvw35ZvSpaZxQMs8rwF7UPvHAJv0fCVR7g?=
 =?us-ascii?Q?1YEO4ljZzznpQ0PTmIYvc8Y8HFOTWu9sv9IKDAFYo34u9GOxf7QScZlTFLda?=
 =?us-ascii?Q?l2RMhUiKlCxnv9lNPj8OM/X7vhbjeYTEXYQRJQxVj8ziFg5LJ26U9P9ML0ff?=
 =?us-ascii?Q?KDsmWy5uyJyNwPFfYT2ktDjpb6xhThz40sYke3jGVBOHMa0cg6Q7h6WYldqH?=
 =?us-ascii?Q?+6EhISULFmoJ0mrur3jMC4SbjxBoCkLv6RTnMlUhfJUwsJM8IoyDrA2grVqF?=
 =?us-ascii?Q?CsqHpgjel9b5yJs11+8Kf+tCKKTTk0H61tQBU6r/nc/Os1OXaCe8Jxm0kp0e?=
 =?us-ascii?Q?SZPdrg8XCzEPbTD7WtTmn6ujIN+sZEyGci6/igVsOurYP7fyQrDiQ351AJVT?=
 =?us-ascii?Q?Qa8Q4vj5HjV9eTYbXUgVOoVdLs6HeliZIBZ8wdUtevrc4NcG8/NwNFwtfs2Q?=
 =?us-ascii?Q?2uDMa0U7mp581CDtvpIUYeMVFG/ucHD/QaLgG+H5ioh83G5yWk7iJjFR5Nrb?=
 =?us-ascii?Q?f0JJ9A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6C7F72DEFB41DE4C95ACC7E1C46F38B1@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4de442a-2277-4604-331f-08d99f254693
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 23:54:29.5527
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C+UhgnEovKT1BQYFRAS6fFHQBHCivKbcyrly/WbKVa7hP2G/fTggo04YlipqVvN91ZkOkoyx1Olou64t5D3f3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5140
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: LvDwdFx4wxwack_YA1aWJMID6qZ4XqUc
X-Proofpoint-ORIG-GUID: LvDwdFx4wxwack_YA1aWJMID6qZ4XqUc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-03_06,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 phishscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 clxscore=1015 adultscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111030126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 1, 2021, at 3:23 PM, Daniel Borkmann <daniel@iogearbox.net> wrote:
> 
> On 10/28/21 12:00 AM, Song Liu wrote:
> [...]
>>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
>> index b48750bfba5aa..ad30f2e885356 100644
>> --- a/kernel/bpf/task_iter.c
>> +++ b/kernel/bpf/task_iter.c
>> @@ -8,6 +8,7 @@
>>  #include <linux/fdtable.h>
>>  #include <linux/filter.h>
>>  #include <linux/btf_ids.h>
>> +#include <linux/irq_work.h>
>>    struct bpf_iter_seq_task_common {
>>  	struct pid_namespace *ns;
>> @@ -21,6 +22,25 @@ struct bpf_iter_seq_task_info {
>>  	u32 tid;
>>  };
>>  +/* irq_work to run mmap_read_unlock() */
>> +struct task_iter_irq_work {
>> +	struct irq_work irq_work;
>> +	struct mm_struct *mm;
>> +};
>> +
>> +static DEFINE_PER_CPU(struct task_iter_irq_work, mmap_unlock_work);
>> +
>> +static void do_mmap_read_unlock(struct irq_work *entry)
>> +{
>> +	struct task_iter_irq_work *work;
>> +
>> +	if (WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT)))
>> +		return;
>> +
>> +	work = container_of(entry, struct task_iter_irq_work, irq_work);
>> +	mmap_read_unlock_non_owner(work->mm);
>> +}
>> +
>>  static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
>>  					     u32 *tid,
>>  					     bool skip_if_dup_files)
>> @@ -586,9 +606,89 @@ static struct bpf_iter_reg task_vma_reg_info = {
>>  	.seq_info		= &task_vma_seq_info,
>>  };
>>  +BPF_CALL_5(bpf_find_vma, struct task_struct *, task, u64, start,
>> +	   bpf_callback_t, callback_fn, void *, callback_ctx, u64, flags)
>> +{
>> +	struct task_iter_irq_work *work = NULL;
>> +	struct mm_struct *mm = task->mm;
> 
> Won't this NULL deref if called with task argument as NULL?

Will fix. 

> 
>> +	struct vm_area_struct *vma;
>> +	bool irq_work_busy = false;
>> +	int ret = -ENOENT;
>> +
>> +	if (flags)
>> +		return -EINVAL;
>> +
>> +	if (!mm)
>> +		return -ENOENT;
>> +
>> +	/*
>> +	 * Similar to stackmap with build_id support, we cannot simply do
>> +	 * mmap_read_unlock when the irq is disabled. Instead, we need do
>> +	 * the unlock in the irq_work.
>> +	 */
>> +	if (irqs_disabled()) {
>> +		if (!IS_ENABLED(CONFIG_PREEMPT_RT)) {
>> +			work = this_cpu_ptr(&mmap_unlock_work);
>> +			if (irq_work_is_busy(&work->irq_work)) {
>> +				/* cannot queue more mmap_unlock, abort. */
>> +				irq_work_busy = true;
>> +			}
>> +		} else {
>> +			/*
>> +			 * PREEMPT_RT does not allow to trylock mmap sem in
>> +			 * interrupt disabled context, abort.
>> +			 */
>> +			irq_work_busy = true;
>> +		}
>> +	}
>> +
>> +	if (irq_work_busy || !mmap_read_trylock(mm))
>> +		return -EBUSY;
>> +
>> +	vma = find_vma(mm, start);
>> +
>> +	if (vma && vma->vm_start <= start && vma->vm_end > start) {
>> +		callback_fn((u64)(long)task, (u64)(long)vma,
>> +			    (u64)(long)callback_ctx, 0, 0);
>> +		ret = 0;
>> +	}
>> +	if (!work) {
>> +		mmap_read_unlock(current->mm);
>> +	} else {
>> +		work->mm = current->mm;
>> +
>> +		/* The lock will be released once we're out of interrupt
>> +		 * context. Tell lockdep that we've released it now so
>> +		 * it doesn't complain that we forgot to release it.
>> +		 */
>> +		rwsem_release(&current->mm->mmap_lock.dep_map, _RET_IP_);
>> +		irq_work_queue(&work->irq_work);
>> +	}
> 
> Given this is pretty much the same logic around the vma retrieval, could this be
> refactored/consolidated with stack map build id retrieval into a common function?

I thought about sharing the irq_work code amount the two. The problem was we need
to include irq_work.h in bpf.h. But on a second thought, maybe we should just 
move bpf_find_vma to stackmap.c? This will avoid including irq_work.h. I guess it 
is not too weird to have bpf_find_vma in stackmap.c.  

> 
>> +	return ret;
>> +}
>> +
>> +BTF_ID_LIST_SINGLE(btf_find_vma_ids, struct, task_struct)
>> +
>> +const struct bpf_func_proto bpf_find_vma_proto = {
>> +	.func		= bpf_find_vma,
>> +	.ret_type	= RET_INTEGER,
>> +	.arg1_type	= ARG_PTR_TO_BTF_ID,
>> +	.arg1_btf_id	= &btf_find_vma_ids[0],
>> +	.arg2_type	= ARG_ANYTHING,
>> +	.arg3_type	= ARG_PTR_TO_FUNC,
>> +	.arg4_type	= ARG_PTR_TO_STACK_OR_NULL,
>> +	.arg5_type	= ARG_ANYTHING,
>> +};
> [...]
>> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
>> index c108200378834..056c00da1b5d6 100644
>> --- a/tools/include/uapi/linux/bpf.h
>> +++ b/tools/include/uapi/linux/bpf.h
>> @@ -4915,6 +4915,24 @@ union bpf_attr {
>>   *		Dynamically cast a *sk* pointer to a *unix_sock* pointer.
>>   *	Return
>>   *		*sk* if casting is valid, or **NULL** otherwise.
>> + * long bpf_find_vma(struct task_struct *task, u64 addr, void *callback_fn, void *callback_ctx, u64 flags)
> 
> nit: Wrongly copied uapi header over to tooling?

Right... You get really good eyes. :-)

[...]
