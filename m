Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F3F446A70
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 22:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhKEVPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 17:15:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53146 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233889AbhKEVPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 17:15:50 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5LD5JG009613;
        Fri, 5 Nov 2021 14:13:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=QJBrgRfIXm4HkSkAmTw2E/t/C2snQ0VE/QaRH8La2lQ=;
 b=TCqLHvJNVmJlAdBD2wOfPvGlvAS4O3oOvcpjpL2zE4gUmo0rurjiKRQOm7Jxja6lHhSU
 XKTiEdsNVa410SJuatCQSiupCF7UacoNjM4rYYSXLQTSim+afAAGtlgOZDUrZ96ZXECl
 ooaZrDTdr9w89gDVNxhmhag56+RmZfV8MT4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c56mtk23b-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 05 Nov 2021 14:13:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 5 Nov 2021 14:11:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kp25qrdyDbzNWiGrXLOeDnzhqR0kCxc6jUglX32lz6CVi+hiWIBRYzm3lzZrVDt+O3PSRfYheLyvFeWVSqGZgn/rBo7v1AqI8nr3LGUZFTSsUS1B87V3P2H+NLMc7bslSFdVerTpLacgeMN1g8GKhQm5yYV0K3sf5Qav9ndDseTZ3wy5KmgkaPjqVNSj7eutcWyPY4TB6x4/Un0u2gQt/ahRCclDNeBe38+6y0O1Ku5grmGxzudRso0ZPNPvyghSSDhptfxw0SfT5GhfQc7vZ89ekchO6CfWIPL5NXK3cjock9Axa7jQ9TuGnAZEZ9h0T9b2ZWZAFyHbHEQADtwgBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QJBrgRfIXm4HkSkAmTw2E/t/C2snQ0VE/QaRH8La2lQ=;
 b=Isw/N/+gsuEmJSmk4aX33lyNjr/rZ2wgce+t6eQp88CiaaYs03WNgN/XLD/h1hppM9GIIUF3Pg3bveOdORZd2CbQbJe7XUKgvmCwDJs8MhOuLG1uy8VlHwQC27MVOc+RxQ9GvTZn1oG3GWYpWdtyTzujhjBAaEg9Y98INKqX8vftqNLgXIx17TRtGtaR0iOeI2GzwDnhFhdY9OBduxG/VZ5NcVcfQQJdCGl3pI+cD3eJ0/5B94DDRfCGAU7kPNeLOwwBDUne5WS5LI6hhPL6CL6OnT0wuZyiMI6PQbM6yLIiyRPPQJTDjIcVCTQnEy0RqBK2MfD/yQjSl43H7pWKqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5078.namprd15.prod.outlook.com (2603:10b6:806:1dd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Fri, 5 Nov
 2021 21:11:53 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953%9]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 21:11:53 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Hengqi Chen <hengqi.chen@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v4 bpf-next 1/2] bpf: introduce helper bpf_find_vma
Thread-Topic: [PATCH v4 bpf-next 1/2] bpf: introduce helper bpf_find_vma
Thread-Index: AQHX0cNmjspUhj3x/0iaOuPiWfpDeqv1DsAAgABhPIA=
Date:   Fri, 5 Nov 2021 21:11:53 +0000
Message-ID: <622ED3C4-7D40-46CF-B33E-32A73B0E0516@fb.com>
References: <20211104213138.2779620-1-songliubraving@fb.com>
 <20211104213138.2779620-2-songliubraving@fb.com>
 <6a6dd497-4592-7e28-72e0-ae253badba8b@gmail.com>
In-Reply-To: <6a6dd497-4592-7e28-72e0-ae253badba8b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 083d8190-6cec-44d6-6833-08d9a0a0e477
x-ms-traffictypediagnostic: SA1PR15MB5078:
x-microsoft-antispam-prvs: <SA1PR15MB50784BA61099847890F5C1DDB38E9@SA1PR15MB5078.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o0jFr6tfhIOneQ5/SRe2rdDygNfuROSA3YsCeFRdHkwb0i1ZsDZUFwQ9SruREq/s5DRc5CO2z+/VXL36uWxJio6I8hC8TZU0NHMbDfzqXvkCpg8x5Pq3NldXIIqKXU9KYQmKO6s2A8FWDnyILA5pmZ/dJRxB1dbi3MfN/K4YHvhIjHo0TY4U0mVdn7Nx/en2uTrTe21TSOKjjo/i3SjxbsL0ptl8/jLAjB+b6u/bbCm3pKZwDLvF/O9BwysIJucP+/pO1/Bw7tGqq2tcptwataKslwVmMXawMQ0B0xoIuxcAAFvXcsv2TLhOEZvm8CItRZT8evu3AQhFaDg45TjYsHtw/5hdj3tCNGY356E5MWX4r8WDvvDVtX6aQ4wo+NBYUNl9B88MeDk+shZGXQ3WRtf2mh2tilklkZTziStxvdCKsYFPuBZ0gA4eKSRDRBGwLF+Zf42SzwRrAPNMMGx2oaglyShZzXfZqkjy3WKnA7Ek153BASoUHBPTita4D7WsPGqlEcT1HqCaoUDSAA15Q4B55Dw8PmBJ1AHUpMoMIICV3NkXlpZ/k/O9CLY8/z6I2mNuXqXDZnRdqD8TavRgzGepjbcgZejCxxRtwA5w22KDJP/Vm0Kjy/DGoxW0Tvwdmj2UxxjZwE4Bo/qjkPKp+El9/b97s6mi7L+kDiuijJjxdCUCTYA1MTXq9tv8ACR0nebOOTIYPOMBmPBzRPeW9EwAkTVpNKdggkyQmJbEuyc8kYAd8X1fD46gMWMkP7FM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(2616005)(6916009)(36756003)(8936002)(66556008)(76116006)(316002)(38070700005)(5660300002)(53546011)(91956017)(2906002)(6506007)(6512007)(54906003)(38100700002)(66476007)(83380400001)(66946007)(8676002)(186003)(33656002)(66446008)(4326008)(508600001)(64756008)(71200400001)(86362001)(122000001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+nM7fKQSrplP7sZOL4/ndYEvjHiB7GjZO2bXqwRvoSAfapT6yXFhIYkFAE/e?=
 =?us-ascii?Q?NF6MCxgHGo1Xv6ol6ETo77vju31I+WLPlbncxKj0VvYnY7k5F/NABfyX3LMs?=
 =?us-ascii?Q?YZqXIuw7s1oseLNGNG2rjzWhEWUI2Iv20BNiyMmKxxCD8sH9xWKjBuRiTVZl?=
 =?us-ascii?Q?zimD3+xelPS5a/bYE9ctdfB3pRNp4waURt3frql9pwmvP1zHBC8t9jhMk3A+?=
 =?us-ascii?Q?Q8NLTjnmpDS4TSzKMz7ahx/FTX7oKZ63Zfw8epf29jteBaR8K81Na1XwkQTV?=
 =?us-ascii?Q?aAzQ7llelqpO9SnC2a51JQwuKHaL8NF2uyiwa8DOF1tbC5eQ8EBG+HZ+9Vh+?=
 =?us-ascii?Q?r/sSpQ19k8/+p7rvH5gA1MUIDYpNrvngLUGyV847tlPdXFpNCeU8Q1WrG3mj?=
 =?us-ascii?Q?1kTMGldaR4r7vvyX/ASUERosWPR3iSJGzhfd+H6/waTLCRcdV/hyIX1uZG8J?=
 =?us-ascii?Q?gkpnlBtRxa5qhlt3JhB/K+sGHPuCF56GeYrwKNfHyYtCIATO0t+Np5BmqmFa?=
 =?us-ascii?Q?Rk3xDWiZgAuIl0+rO2tHqOxo1bCIWCfxyLRoJr30qZ8PIt4rqvpRGV21fWjm?=
 =?us-ascii?Q?8LQR2AMsbucDYaikBEdWYuSQAAS2eMSGPzhPmZMeFOQ4fNbttbRlTtRGOz7p?=
 =?us-ascii?Q?DylpoTVmEZPbLtW3a7SwKqIHJ9qmhjBfw7LJLwASz0/EXSrM8nfW7tfc17zK?=
 =?us-ascii?Q?Yfg8B1wfe0M+hdVw2gAAGVW/WL+se98o3z47wNgVNYXDyLREi1uZJlFvteGA?=
 =?us-ascii?Q?RN8f7hdVFulX32V/v2OuIEU1nrJjTbFhi8rJ+2dirW85XtkEY+OyXjvGCwoE?=
 =?us-ascii?Q?dYRiGqOvpFrnUZItxMcvENv41u+U5efxUkPz8R7VqcY85hsEV9JZATswkpJm?=
 =?us-ascii?Q?Vlhmdovtv67o98guKrQwdMsf361htqWTkeeWhUGsGpd7HcQGu1EWD1ytRfaI?=
 =?us-ascii?Q?t4e6n1VDLcvhCjvFutYRmEPol4pQSXOtXnK8RkGenDCi367DaJ3QL8Til/yK?=
 =?us-ascii?Q?9jnXUp9bY4uobmUhwbqRwd9szlB2iBYBtMGr5JfN43Lf0/raxBYVvUGhfJuN?=
 =?us-ascii?Q?3dGOXZDN42/Na2vpqndlyz/QYfEMn2mkB84IZA2xafbqTJSmJ627M2C0WS1r?=
 =?us-ascii?Q?K2kQ2gmuoo9QqjSh4vkjyo5MeQHYP3+f/UVnXr8Rn1nd6MvRCyGfPimnB8iS?=
 =?us-ascii?Q?vBYTrJHbohwanfyoR39otkQj3ofV3nXVehJvZClouXK7h91nh2PMzX2v1lcY?=
 =?us-ascii?Q?Wza5Zs7rHsu0AsZjFVeGg/HOaRG15DmLw5cbelmff917rH+c5nAfgawzxi5G?=
 =?us-ascii?Q?RPB0vCM10H4IJ9CkK7LaTSFcb93WShyOl7uTlNZFw3biiIaWQ95zYqxSye7d?=
 =?us-ascii?Q?PJHo225hduG0Ld+0mWPhE5A4DR2mjbcLFocBVxV9aR7mnKCFB+8i7NhNTswZ?=
 =?us-ascii?Q?iMmT+tWrES9VnXMHzMWQ1WfSkSSJKjTSXStBwl0TvJ8ykxWPMsiWDW75K3nh?=
 =?us-ascii?Q?Czm719EwhECX/vqfy/OGE+JttVT2Uh9VfdL9KxmHufJb8BZf2IanbP48uVYB?=
 =?us-ascii?Q?mvQi3b6XsrNgSVFbM7Ssqqy/nT/rolhbxa/IWm3FxEP+tF5PupRAw6LuwpBa?=
 =?us-ascii?Q?Q5ThNUofLTFmjVrTh3tYlUIi7hCZJJkhNOl690Lkpse6GsaBsHzZvmQKpzBd?=
 =?us-ascii?Q?cEy2Rw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3ABDD35E505F18408C88C3F4B8F4B72E@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 083d8190-6cec-44d6-6833-08d9a0a0e477
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 21:11:53.6464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nQcx0LxPYbm+9/8tkDCv9h0OAXx3ZncJLUkIIeS9ia8b47xwudfAlFtfQu42hUvd7nlFMz84oGfHORE+MDl3hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5078
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 9JWzJnOQ0s1TU7CbpKOrcWGGbidLGmO1
X-Proofpoint-ORIG-GUID: 9JWzJnOQ0s1TU7CbpKOrcWGGbidLGmO1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-05_03,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050115
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 5, 2021, at 8:23 AM, Hengqi Chen <hengqi.chen@gmail.com> wrote:
> 
> Hi, Song
> 
> On 2021/11/5 5:31 AM, Song Liu wrote:
>> In some profiler use cases, it is necessary to map an address to the
>> backing file, e.g., a shared library. bpf_find_vma helper provides a
>> flexible way to achieve this. bpf_find_vma maps an address of a task to
>> the vma (vm_area_struct) for this address, and feed the vma to an callback
>> BPF function. The callback function is necessary here, as we need to
>> ensure mmap_sem is unlocked.
>> 
>> It is necessary to lock mmap_sem for find_vma. To lock and unlock mmap_sem
>> safely when irqs are disable, we use the same mechanism as stackmap with
>> build_id. Specifically, when irqs are disabled, the unlocked is postponed
>> in an irq_work. Refactor stackmap.c so that the irq_work is shared among
>> bpf_find_vma and stackmap helpers.
>> 
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
> 
> [...]
> 
>> 
>> -BTF_ID_LIST(btf_task_file_ids)
>> -BTF_ID(struct, file)
>> -BTF_ID(struct, vm_area_struct)
>> -
>> static const struct bpf_iter_seq_info task_seq_info = {
>> 	.seq_ops		= &task_seq_ops,
>> 	.init_seq_private	= init_seq_pidns,
>> @@ -586,9 +583,74 @@ static struct bpf_iter_reg task_vma_reg_info = {
>> 	.seq_info		= &task_vma_seq_info,
>> };
>> 
>> +BPF_CALL_5(bpf_find_vma, struct task_struct *, task, u64, start,
>> +	   bpf_callback_t, callback_fn, void *, callback_ctx, u64, flags)
>> +{
>> +	struct mmap_unlock_irq_work *work = NULL;
>> +	struct vm_area_struct *vma;
>> +	bool irq_work_busy = false;
>> +	struct mm_struct *mm;
>> +	int ret = -ENOENT;
>> +
>> +	if (flags)
>> +		return -EINVAL;
>> +
>> +	if (!task)
>> +		return -ENOENT;
>> +
>> +	mm = task->mm;
>> +	if (!mm)
>> +		return -ENOENT;
>> +
>> +	irq_work_busy = bpf_mmap_unlock_get_irq_work(&work);
>> +
>> +	if (irq_work_busy || !mmap_read_trylock(mm))
>> +		return -EBUSY;
>> +
>> +	vma = find_vma(mm, start);
>> +
> 
> I found that when a BPF program attach to security_file_open which is in
> the bpf_d_path helper's allowlist, the bpf_d_path helper is also allowed
> to be called inside the callback function. So we can have this in callback
> function:
> 
>    bpf_d_path(&vma->vm_file->f_path, path, sizeof(path));
> 
> 
> I wonder whether there is a guarantee that vma->vm_file will never be null,
> as you said in the commit message, a backing file.

I don't think we can guarantee vma->vm_file never be NULL here, so this is
a real problem. Let me see how to fix it.

Thanks for finding this case!

Song
