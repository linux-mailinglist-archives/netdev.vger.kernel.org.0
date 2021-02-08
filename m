Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A300B3129BF
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 05:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhBHEby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 23:31:54 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60182 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229681AbhBHEbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 23:31:44 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1184TGK3008217;
        Sun, 7 Feb 2021 20:30:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Ps5V4Pbxr2k/Dm9YUJHrFE0blBbMQThxxmQhsusepgk=;
 b=oAn+XvRXJ6RbEGIicJXXlsdQTy/gpvnrgH6MNvaWACtoQteMJUC4Z4bXQ2QDJUaa5AHd
 +dzwUW+Nt7vEUNoRpwZ+Jj063JM8qYhGc2xH+BiyIcPkx5qwSJjYQqCulLjySnqMk5HZ
 UsQG8rJXMe/Si9QmzMVHRVyyogRKekNuJ7w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36hstp5c86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 07 Feb 2021 20:30:36 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 7 Feb 2021 20:30:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ll10S/nsRpWJCmOW/O5qS4eZZ+cs6SNMPD83rQeuoefF+3UFPwNg6EI2d4W6dkP4tDmL9Ii5FDtwCKecpLO/lDU704rtJlcH8n8pZREBszorUIK5nkl4mImUnnCAJbZ6QTFnDTHp2sPC6wNxdGffSg+FFiH6AR7SL9U/PXbZBG0pgamtCAczhPd8W7tw+DxJwjLMi6eiXsgabOgMJUdDaQlOnBfPd4TSrFiV4RPgVlQonXRjCMOGiv6udDg9qfFVCIypjMyFFbstnUYWqb4ETBDsj7StaOsW1KiupZB383SOUcvNTGjSzp2YusgzhRbuMFIJd+QhMHYo9QfGYnTpyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ps5V4Pbxr2k/Dm9YUJHrFE0blBbMQThxxmQhsusepgk=;
 b=EemTMAdPFTZgy2tejMghSVotlI4zwZNd8ltwdEEufo1gOXRGiRZassakO6kbZ6WxFM9uhZW4ztLh0Va3lhJDEuTiw/lynPZIJIS9FVzarM9wC+42kH7Cc3AErJ+zk6ZXzM+jo+vqt51657vhuTbAKDmuU4OrZhWErA0iFnpQQ2EJhVgqj85Ayr8Q3wTLc+a5TiJoa1fKkS8dLjPkqUnTwCTXNfBblxK5izR66BCoFlHg3pM1Z1eFOFpv5tNykzwMnl73Zihze+Tku0/GpmEeKW7pdbzuWFAoDnyvMp+8gIooMLdOr9QYMG5ZuBuFrSCdknltUT9sSL1bkFdPqvPMCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ps5V4Pbxr2k/Dm9YUJHrFE0blBbMQThxxmQhsusepgk=;
 b=byggfLB4Pta3xUyKubLwsVrr6cr4PeJbgJD6Evl/P0OSAzVFOZHAmwrqHEb53QMI8GCoKkSwBXRBGdKl32P9324HPBpWJ15im6x7mmfOUl3OhjL0+WHpdwMR6SkLuSOy9mAHMWTiENepF/9qAUyOd7RrPOHhXHC50wrf50+G1z8=
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2951.namprd15.prod.outlook.com (2603:10b6:a03:f7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.24; Mon, 8 Feb
 2021 04:30:33 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5%5]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 04:30:33 +0000
Subject: Re: [PATCH v4 bpf-next 1/4] bpf: introduce task_vma bpf_iter
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <akpm@linux-foundation.org>
References: <20210204205002.4075937-1-songliubraving@fb.com>
 <20210204205002.4075937-2-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a120160a-df39-a68e-cc01-2d6d90ea5aa5@fb.com>
Date:   Sun, 7 Feb 2021 20:30:29 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <20210204205002.4075937-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:ba14]
X-ClientProxiedBy: MWHPR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:300:116::28) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1261] (2620:10d:c090:400::5:ba14) by MWHPR07CA0018.namprd07.prod.outlook.com (2603:10b6:300:116::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Mon, 8 Feb 2021 04:30:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2926777d-6237-4d44-bca6-08d8cbea45c9
X-MS-TrafficTypeDiagnostic: BYAPR15MB2951:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2951849EEE7998D931345286D38F9@BYAPR15MB2951.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2PMf69Xvkkv2yL+hkbgKu2c1pjBrjj3v7aJQ3dAxOygXNBXM+C3W6yIZUk+q+dzv4uo+gZtKYkyZ1SarMW9FStTkI8L+XrmIMNqr97Doo9GM9MSNks3W+otMdSKol0Po+/RaNQOHS8pvyLOqvQ2CPaBmalsXntNOzNeoMPRL4JDxAG8l7NK55KKWOAfXzNsbTibiliUT/cNv0MaPpExM3BIvWZsr8iwHyOn+AnmJpfIeDR+ZhJA9kCrKn5pSpN2reqbrsLU6Rhjmx/f41UePgHKviB7Y54D71I1/AQuSe0Nc2rdWcB3griSjYDbEqWNJQC5usK32e8nNAeu98CzgIumdxSJShCjKh1NVwDxSWs9KrD3o8UI4CnYgHsQRMOx0KwtA2c3CS1/mUy27i7TqGWWLH0PSfaq6Q29czz/HUIr51gey7uoszNHHSVk2YGum7SzXsZTBFwjlEc0MANheudinCgu/9k2uu9gDGfY65B2P5oaB4Ccpu90WptFprZZY+nX6U0KooWiTvlbH1dKcMEnOZ3LV/i03vkSFQL9LRsGUqk6NDonMroxHu9Pd9qh7btRAFt6H4xGLhafsLXg6rgAG5/Xmg1qPAvU1HxEhPAc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(346002)(39860400002)(136003)(31686004)(186003)(66946007)(316002)(2616005)(31696002)(66556008)(16526019)(6666004)(5660300002)(83380400001)(66476007)(8676002)(2906002)(8936002)(478600001)(86362001)(6486002)(36756003)(53546011)(4326008)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MzdKaUdCTmVEMUFRdkhiSU9CVlk1TTFuU2R2cXpjSldqKzZDZmp2em9NZkFP?=
 =?utf-8?B?V1VWQ2ZwR3pEcFc5dEExcDFzeGpRVTh5ZGlyczJDZTJTS1dVZG9QeFY3TFkz?=
 =?utf-8?B?V0pWTW5hNjFHbEhXV3BzTXNVcElOWnE1c3d3cXI5b2gwYXIyMFJDTWM3VGhX?=
 =?utf-8?B?T0ZMV0hoKzN0eEI1Y3Qvb1JoSDVUeGhVK09NUUNvOU9NanM5cHhGOUU4czE0?=
 =?utf-8?B?cjdCeFg2Q2hnQ3RLRmFoQVJBbXAvQkVBMmp4VGxpRmR5eEQ0R0Fmb0FZQlpu?=
 =?utf-8?B?UlVUZzNQaE9BNTZPUm5kSkZTL05YakJwa2t1VFZXOFdueU5xb2Z0cU9jMkpB?=
 =?utf-8?B?dmc5MTJhczJFc1RzWXZ4Q2JLNE1kdWVsWjV3NzhLU0NEUEZsWXZJaWE4dVU3?=
 =?utf-8?B?ZEVKVWpQV05MOU4vQ1hLTm1hSnJ1RVE5U0NuU0dBMkZOM1RhWXhRTDFxek05?=
 =?utf-8?B?WVFnMnI1ZjN5c3FxbEsvNytyWUlTakpHWXBHVmx5K3FEcXNGOS9sNUNzSmpC?=
 =?utf-8?B?cWZGNWoyVzBETTRnbEdTa1Zoak1rL1UybFdoRWhxbFNLWHkxQXlHVEQyT3ha?=
 =?utf-8?B?OWd0QVJCSGdZMEJXVUgvV3BVclNtRE1weTZWZ3pKTjVOcEMxelFSS0RjeFFu?=
 =?utf-8?B?c2Q2aVlpN0dUZkYxb3Q1NEhmUnpodURWbm9iSldPaHhHSTVQeGJDbWMrYWhx?=
 =?utf-8?B?NDVIRmJTYXBlUWlLNVlaVXNlQ1VPNUtuL3k4TnBxZGlzb3k0VTl2K3hVbEJ6?=
 =?utf-8?B?K3pTeml5UitvUUR0ZndvTGgxUGNuYmEyUWhrcUFZMTMwT1JQcEdId3dGZnZC?=
 =?utf-8?B?LzIybXkwdHJQNk0yUjBuNGQ4RkRFcloxelRnT21ZMlA4bmUzZmNUVnhVcEN0?=
 =?utf-8?B?SkRyUjNXdXNiSUFlcTU3U08vQTBYV3FqbWRSYzRnNVNuZ3VxZEwxUXczeTlY?=
 =?utf-8?B?R1hWajBabEptalJIaXcraFNqdFRZTk05Rmg1UGwxYzBDU3A4MUg0bzZUbGNn?=
 =?utf-8?B?M2k5dXl4VDVrV01RQWNmdFpKbGE1Sm96bnlCSmhKeU85TU1zWk11YlZ1d2M2?=
 =?utf-8?B?TG9pU2p2OXp5d3l6NFZVUFhjT3ErUk5sUXREREJqY1FNNkFZd0lFaG9QVHNJ?=
 =?utf-8?B?M0ZGSFR4TG5HVFpVMUtJckJkSzdwQW43dVdhdjFoemo1SzZwTE10NW5qZTM2?=
 =?utf-8?B?TjdaV3poUlROUHdia0NjSDJPZTFLT1NxQlVmY1R3Qm1za2dIOHMzTWFiTWFL?=
 =?utf-8?B?LytOQWsvV3BxTGUyWGFLWGk3SysybEJnTXhwMG93UFhmU3BlUXBROTRmcDRB?=
 =?utf-8?B?TDVzT1VQMURra3lZTFY5UkQzNHlVYlIxd1R6NW1hRGZiNWQwTDdCMEtwek9O?=
 =?utf-8?B?RlZBOCtJL0JnRG5BZXFOa2Z4QWZZMFNHa1lGSURKK0N1MkxWeWxhM3o2UHBl?=
 =?utf-8?B?MHROTTVNVzhjR0lKcmR5MTVqZ0pjdGN5M0cvWDN4VUd2eUlYV25IbnR4aENm?=
 =?utf-8?B?ek9FWjk1dyt2eXdYd0dsQzJJMEdENG8vdjd5TTlrbUJHeW0ySkw3UndBZ0Fy?=
 =?utf-8?B?LzR2bG4zUXhURGZpRUhHWkZnU2FVUEJTN2VCRlgxMlBHMzhqT2tkcThTbUVk?=
 =?utf-8?B?YTRaeUxWQ3JuZE4rVS9says1VjgrdDJLSlBvMGVvNE1tMXdLRmV0MERxTVRq?=
 =?utf-8?B?MFp5ODMyaVFBMldCSEs1dmorY1A5T2VkL1J4U3FUZ09CQ3ZubEZOQ2FSWEF1?=
 =?utf-8?B?a0REYStYRkw1OWNMWDRnaUhxUjhzaCt4ME55cTNwSHhFM1FjbE1LVHBNb24v?=
 =?utf-8?Q?lW3rgEpgkQc8S0M6+dPcGDrbbKZqDTSabPxAU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2926777d-6237-4d44-bca6-08d8cbea45c9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 04:30:32.9378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pc5foq+bwcR3R8FiOJdovsgnQbASqxbx08CCFYbpxIHptS3DnphivBqSfZs3xphn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2951
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-08_01:2021-02-05,2021-02-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102080029
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/4/21 12:49 PM, Song Liu wrote:
> Introduce task_vma bpf_iter to print memory information of a process. It
> can be used to print customized information similar to /proc/<pid>/maps.
> 
> Current /proc/<pid>/maps and /proc/<pid>/smaps provide information of
> vma's of a process. However, these information are not flexible enough to
> cover all use cases. For example, if a vma cover mixed 2MB pages and 4kB
> pages (x86_64), there is no easy way to tell which address ranges are
> backed by 2MB pages. task_vma solves the problem by enabling the user to
> generate customize information based on the vma (and vma->vm_mm,
> vma->vm_file, etc.).
> 
> To access the vma safely in the BPF program, task_vma iterator holds
> target mmap_lock while calling the BPF program. If the mmap_lock is
> contended, task_vma unlocks mmap_lock between iterations to unblock the
> writer(s). This lock contention avoidance mechanism is similar to the one
> used in show_smaps_rollup().
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   kernel/bpf/task_iter.c | 215 ++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 214 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index 175b7b42bfc46..31e63b6c3d718 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -286,9 +286,196 @@ static const struct seq_operations task_file_seq_ops = {
>   	.show	= task_file_seq_show,
>   };
>   
> +struct bpf_iter_seq_task_vma_info {
> +	/* The first field must be struct bpf_iter_seq_task_common.
> +	 * this is assumed by {init, fini}_seq_pidns() callback functions.
> +	 */
> +	struct bpf_iter_seq_task_common common;
> +	struct task_struct *task;
> +	struct vm_area_struct *vma;
> +	u32 tid;
> +	unsigned long prev_vm_start;
> +	unsigned long prev_vm_end;
> +};
> +
> +enum bpf_task_vma_iter_find_op {
> +	task_vma_iter_first_vma,   /* use mm->mmap */
> +	task_vma_iter_next_vma,    /* use curr_vma->vm_next */
> +	task_vma_iter_find_vma,    /* use find_vma() to find next vma */
> +};
> +
> +static struct vm_area_struct *
> +task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
> +{
> +	struct pid_namespace *ns = info->common.ns;
> +	enum bpf_task_vma_iter_find_op op;
> +	struct vm_area_struct *curr_vma;
> +	struct task_struct *curr_task;
> +	u32 curr_tid = info->tid;
> +
> +	/* If this function returns a non-NULL vma, it holds a reference to
> +	 * the task_struct, and holds read lock on vma->mm->mmap_lock.
> +	 * If this function returns NULL, it does not hold any reference or
> +	 * lock.
> +	 */
> +	if (info->task) {
> +		curr_task = info->task;
> +		curr_vma = info->vma;
> +		/* In case of lock contention, drop mmap_lock to unblock
> +		 * the writer.
> +		 */
> +		if (mmap_lock_is_contended(curr_task->mm)) {
> +			info->prev_vm_start = curr_vma->vm_start;
> +			info->prev_vm_end = curr_vma->vm_end;
> +			op = task_vma_iter_find_vma;
> +			mmap_read_unlock(curr_task->mm);
> +			if (mmap_read_lock_killable(curr_task->mm))
> +				goto finish;
> +		} else {
> +			op = task_vma_iter_next_vma;
> +		}
> +	} else {
> +again:
> +		curr_task = task_seq_get_next(ns, &curr_tid, true);
> +		if (!curr_task) {
> +			info->tid = curr_tid + 1;
> +			goto finish;
> +		}
> +
> +		if (curr_tid != info->tid) {
> +			info->tid = curr_tid;
> +			op = task_vma_iter_first_vma;
> +		} else {
> +			op = task_vma_iter_find_vma;
> +		}
> +
> +		if (!curr_task->mm)
> +			goto next_task;
> +
> +		if (mmap_read_lock_killable(curr_task->mm))
> +			goto finish;

We hold a reference for curr_task here.
Going to "finish" does not release the reference.

> +	}
> +
> +	switch (op) {
> +	case task_vma_iter_first_vma:
> +		curr_vma = curr_task->mm->mmap;
> +		break;
> +	case task_vma_iter_next_vma:
> +		curr_vma = curr_vma->vm_next;
> +		break;
> +	case task_vma_iter_find_vma:
> +		/* We dropped mmap_lock so it is necessary to use find_vma
> +		 * to find the next vma. This is similar to the  mechanism
> +		 * in show_smaps_rollup().
> +		 */
> +		curr_vma = find_vma(curr_task->mm, info->prev_vm_end - 1);
> +
> +		if (curr_vma && (curr_vma->vm_start == info->prev_vm_start))
> +			curr_vma = curr_vma->vm_next;
> +		break;
> +	}
> +	if (!curr_vma) {
> +		mmap_read_unlock(curr_task->mm);
> +		goto next_task;
> +	}
> +	info->task = curr_task;
> +	info->vma = curr_vma;
> +	return curr_vma;
> +
> +next_task:
> +	put_task_struct(curr_task);
> +	info->task = NULL;
> +	curr_tid++;
> +	goto again;
> +
> +finish:
> +	info->task = NULL;
> +	info->vma = NULL;
> +	return NULL;
> +}
> +
[...]
