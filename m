Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15892DB4A4
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 20:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgLOTr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 14:47:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9404 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726266AbgLOTr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 14:47:29 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFJixOB015964;
        Tue, 15 Dec 2020 11:46:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=diHpSS9oTYuwutnnVW6tIdNr5lDuw7B+CKs4X5hfZUE=;
 b=p1SDBi44kTMnd5R4geLrlAVeqZeRBJGUjtORJivGbacJMroX7o+RpWcZjO2j5hZdzjSk
 PKsH3PRuDpTCBnxk1i71+LSn8dc5LfQAOa0MWN8h2vSFfen+tJLaFajRk2y2puFdVA7+
 befhoj09e5JSQD40tkxrKn4Igr5Xce/2yaA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35eypshpuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Dec 2020 11:46:33 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Dec 2020 11:46:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIm1vHuKLR8OtMTLdkYMM/FAglXBzXVo/Jx1q91OIczJjDfBLSffGn+daeANSToe9JTfFHxpHWUsQODLGeNfUtwsdvqNsx7cuXskD5SS2jSFisZoxNo9rk0V5OkTxqTxE7IC7DL+4zbe4kZIK2PhSgc36Mm+eg1a7FpUOkjT3bRk8spVHIjXRU06T1355PNgauYfJ94w+dN+7fhaVCzDMY+qGSr7YKDajWjYZTvc0RJC84Ws/c+6bncoWjjhY0N3qRtddqTL4GE1w+S2fwxt7J7zgHrj/OSXXAaVZzj+rGaFZLiZRUI/5mzHk8HKjxkWgD9+Kn8Xbj7B863nY7DgfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=diHpSS9oTYuwutnnVW6tIdNr5lDuw7B+CKs4X5hfZUE=;
 b=TZMUv96uhsjWKvNF5uvjaMHvZpoJOYrCh8kQV2WOVfxCNsPKj72eZwnOgBIslNH7ISal81E+HRhISK9cH0WqHHnxXAcGrfLzIjtRuMG7dR8lyMlzVtFaslteLWxDqfNczIxuyjJvdA0hEons9pOqCAPjP9OBnfZggcBg63+5gaodl/78qj6x9cxVkk0eoIh42Krp3AdEKBRESYfcd195lOvUAsdLV8tqPeroeuckC9to0Hw+SXCi4uOQBvzJB+lrAjfTSQcqvnEXh2gBqlU/Ail0MYrFBktIh5gGAR9OMIzLJYducc12PH18M56sg/Wd8XxoI9C9Af/oqOumf/8Z+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=diHpSS9oTYuwutnnVW6tIdNr5lDuw7B+CKs4X5hfZUE=;
 b=Vxq30ngUvNGNz5MiQ9rtmiPConcpYsxsqRhbMDGn2hycPPJ9kmIkO8X6tyJFfuv+eR/1ggQpmlV4wXkrwkV0JKyMwYjwE6dD01tPDX0RxNtm3vlowDb1rIQYi8XGxNZNvAWXzawfauQWnHytKCx4O9r8y9xRvrN6PNmjNaZN5fk=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2824.namprd15.prod.outlook.com (2603:10b6:a03:158::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Tue, 15 Dec
 2020 19:46:28 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 19:46:28 +0000
Subject: Re: [PATCH bpf-next 1/4] bpf: introduce task_vma bpf_iter
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>
References: <20201212024810.807616-1-songliubraving@fb.com>
 <20201212024810.807616-2-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4e3d3931-1877-ea75-acde-313ab1537531@fb.com>
Date:   Tue, 15 Dec 2020 11:46:25 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201212024810.807616-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:e381]
X-ClientProxiedBy: CO2PR05CA0094.namprd05.prod.outlook.com
 (2603:10b6:104:1::20) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::112b] (2620:10d:c090:400::5:e381) by CO2PR05CA0094.namprd05.prod.outlook.com (2603:10b6:104:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.13 via Frontend Transport; Tue, 15 Dec 2020 19:46:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36e0a3d3-03a3-48b5-b6b3-08d8a1321d1b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2824:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB28249165800D101D42C5442DD3C60@BYAPR15MB2824.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tmpZgMWbPcQUYptiM/JPyOpw6N8/wKS8eFu4R2yFBe68Zyb3Tiqv8ZapnJzZkayTw3xss+kungQsXO4AInRww+pW8Pq3TuTovo0Ao0zOnEgmRLK/+zvsrLt0thLKiKWaLCMbUm06RXr3DtA9p81TKTfom9EENAxpf5aiOK549EmZrli14WypDPaAGeCkX66BOfd9e4WfqnY1XCdmGrC3lKOp6bSQAc/Jtue1XstB6cCOO0Uf4/JKiQDaSsB1HdlMU9wm9RyfbSAawgWZUk8NJ2iF47ZGF+h35fMyHyvKEMSv4LA1KSn5LTEa/Ajmqtqd0YLscXSl/qvWHfgm+mG2wVHHyIGkT7LzxqoeWxMG81sVlaT6dGlBg7YLikbLZHUu/qe2DK6T/0DOCvuAvHcH1Wa6iKMNntA1uQ+GMmzCf2c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(346002)(376002)(366004)(8936002)(53546011)(186003)(478600001)(4326008)(6486002)(316002)(2906002)(5660300002)(16526019)(2616005)(31696002)(86362001)(66556008)(8676002)(36756003)(31686004)(83380400001)(52116002)(66476007)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eUJKby93ZlMxdm5aUjN3b0g4aU1MV0hCK0xETGRDYmdlTTBWRzMzNGVnVzkz?=
 =?utf-8?B?TERrUVZETjZaMUJGc1NYR0xVYmNYcU5uRTRmeU1LWXFhOTdHUkh2RGFtRWxi?=
 =?utf-8?B?QXZsbTJkNW1VWnJ3eTVyb3BBcW9iRzRTRHorZmNEMWh3cXF4dWdYK1dWNFha?=
 =?utf-8?B?cjFJbUd2bk9pMW0vdkN0cHB4ZjFGOW1CTU9yOGhMMmZNcTFPUUZFMms4RVpp?=
 =?utf-8?B?ZnZMMHE2cmN2MW1mMk1OTEdTSVRCVElmUWVjWnkzc01ueXJuZnVCRHd3NStU?=
 =?utf-8?B?eFdESzEwUWovY09scUR6WFU2OWw5R2RrbjZJdDV3N3VKNEQxeC83cklQczBC?=
 =?utf-8?B?TUFaSGkwaFN5ZTRXYzFZOVpmVjBnTG0rR3V3aG9vcjVZY0VQTHdMZUVmMGcw?=
 =?utf-8?B?Z0VIbUo3R0hxaTVwQ2tyYUpuMmRVNVNXeWFWZ0EvRHlBS2tIZHU5eW53dlY3?=
 =?utf-8?B?M2RqVjRVLzI5ZVp4OTFIcVhGMWxrYTMxckJqd09RR1RZMkQ3NUJyWTJuN3Ay?=
 =?utf-8?B?ZlhsTUpYVlZBK0xzMWZUc3czRUk4aFI5OXIwdDc1YzNSNnBhb0RjQXRjS0h0?=
 =?utf-8?B?OGN3bGF5eDI2cVV6cWFiRXBCeHJ2UGI3bGQwU1AzclRNWm9oZ0x3UXJPaVg2?=
 =?utf-8?B?a1poNE94STRxVWU3REFEdlg3MTlYL0w1YnVVM1UrRTc0aGxwd25QN0gwMDhr?=
 =?utf-8?B?aWc0ZXhua0JMSWR4S05Nb2Nhem9SZk1vUGFrTy9LM0EydENrMG9QdFBtV0pS?=
 =?utf-8?B?KzdDS0xROVMrTFdSZnpLYXF4Q1pWRTcwL3hQWEVqR1JvWVlhQmo0NHFyNkUz?=
 =?utf-8?B?Ukl1NkR2QlB3RUdwdjRtZ2k1SlFwZ1g2SytYaTIrSmdHMGZha2w4Tm5acTY3?=
 =?utf-8?B?cFRZZ3NTN2tEOTVmK25FSDBhT1VGUzdYQkQ2ZTNUTk5PbTBXcjFiRmVKT0lu?=
 =?utf-8?B?QTFaZkVXRGk4b1VYa29mT1ZadVJEWFFKUnFmbUtIOTd0NHdCRVgzK2d6citS?=
 =?utf-8?B?Q1ZyendSWEFxNzczMXp3NmJPMk5iYWpwMVl3NmJML1d4c2x6djE5VzFBSnlk?=
 =?utf-8?B?Ym5qdExNRVRQdTVTZ2hleDRJdU01dURqMWp3R2x0dXJoU1JiTUdZSWcyN2dC?=
 =?utf-8?B?QUxjQ2k4V29LSE5sUDlROTJTRGlVTm91eHRPSGg0ZTNTbE8xRTNZNUMyTlN2?=
 =?utf-8?B?VWh0MWwwM0g3dFNjTHFsNlMyTzhVZDZIbFVnQTlBYXQ1UWhxaFVSdTBKZGI1?=
 =?utf-8?B?YkorL25PRnlqcmx4MHZoTll0U1dWcktGbUNRaEhPTXNYUFdrVExpczZBY2I4?=
 =?utf-8?B?QUNtS2Zhd1htTnFkcG9xS0hFVlM4VU4yd25yamM4T3ByMkNRVkJOcXVYYXRL?=
 =?utf-8?B?T1lXNEdqQnVLQVE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 19:46:28.0468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e0a3d3-03a3-48b5-b6b3-08d8a1321d1b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cm6BWnntiH53voDWw3xPyef4B63XG2KYGU6sgPTYZM8wsfRmYTPRxnIxd5HNzNzs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2824
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_12:2020-12-15,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 spamscore=0 clxscore=1015 suspectscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/20 6:48 PM, Song Liu wrote:
> Introduce task_vma bpf_iter to print memory information of a process. It
> can be used to print customized information similar to /proc/<pid>/maps.
> 
> task_vma iterator releases mmap_lock before calling the BPF program.
> Therefore, we cannot pass vm_area_struct directly to the BPF program. A
> new __vm_area_struct is introduced to keep key information of a vma. On
> each iteration, task_vma gathers information in __vm_area_struct and
> passes it to the BPF program.
> 
> If the vma maps to a file, task_vma also holds a reference to the file
> while calling the BPF program.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   include/linux/bpf.h      |   2 +-
>   include/uapi/linux/bpf.h |   7 ++
>   kernel/bpf/task_iter.c   | 193 ++++++++++++++++++++++++++++++++++++++-
>   3 files changed, 200 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 07cb5d15e7439..49dd1e29c8118 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1325,7 +1325,7 @@ enum bpf_iter_feature {
>   	BPF_ITER_RESCHED	= BIT(0),
>   };
>   
> -#define BPF_ITER_CTX_ARG_MAX 2
> +#define BPF_ITER_CTX_ARG_MAX 3
>   struct bpf_iter_reg {
>   	const char *target;
>   	bpf_iter_attach_target_t attach_target;
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 30b477a264827..c2db8a1d0cbd2 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5151,4 +5151,11 @@ enum {
>   	BTF_F_ZERO	=	(1ULL << 3),
>   };
>   
> +struct __vm_area_struct {
> +	__u64 start;
> +	__u64 end;
> +	__u64 flags;
> +	__u64 pgoff;
> +};
> +
>   #endif /* _UAPI__LINUX_BPF_H__ */
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index 0458a40edf10a..30e5475d0831e 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -304,9 +304,171 @@ static const struct seq_operations task_file_seq_ops = {
>   	.show	= task_file_seq_show,
>   };
>   
> +struct bpf_iter_seq_task_vma_info {
> +	/* The first field must be struct bpf_iter_seq_task_common.
> +	 * this is assumed by {init, fini}_seq_pidns() callback functions.
> +	 */
> +	struct bpf_iter_seq_task_common common;
> +	struct task_struct *task;
> +	struct __vm_area_struct vma;
> +	struct file *file;
> +	u32 tid;
> +};
> +
> +static struct __vm_area_struct *
> +task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
> +{
> +	struct pid_namespace *ns = info->common.ns;
> +	struct task_struct *curr_task;
> +	struct vm_area_struct *vma;
> +	u32 curr_tid = info->tid;
> +	bool new_task = false;
> +
> +	/* If this function returns a non-NULL vma, it held a reference to

the function does not return vma, it returns an internal data
structure __vm_area_struct which captures some fields from vma.

> +	 * the task_struct. If info->file is non-NULL, it also holds a
> +	 * reference to the file. Otherwise, it does not hold any
> +	 * reference.
> +	 */
> +again:
> +	if (info->task) {
> +		curr_task = info->task;
> +	} else {
> +		curr_task = task_seq_get_next(ns, &curr_tid, true);
> +		if (!curr_task) {
> +			info->task = NULL;

adding "info->tid = curr_tid  + 1" so next read, e.g. after read()
syscall return 0 read length, will start after last checked curr_tid.

> +			return NULL;
> +		}
> +
> +		if (curr_tid != info->tid) {
> +			info->tid = curr_tid;
> +			new_task = true;
> +		}
> +
> +		if (!curr_task->mm)
> +			goto next_task;
> +		info->task = curr_task;
> +	}
> +
> +	mmap_read_lock(curr_task->mm);
> +	if (new_task) {
> +		vma = curr_task->mm->mmap;
> +	} else {
> +		/* We drop the lock between each iteration, so it is
> +		 * necessary to use find_vma() to find the next vma. This
> +		 * is similar to the mechanism in show_smaps_rollup().
> +		 */
> +		vma = find_vma(curr_task->mm, info->vma.end - 1);
> +		/* same vma as previous iteration, use vma->next */
> +		if (vma && (vma->vm_start == info->vma.start))
> +			vma = vma->vm_next;
> +	}
> +	if (!vma) {
> +		mmap_read_unlock(curr_task->mm);
> +		goto next_task;
> +	}
> +	info->task = curr_task;
> +	info->vma.start = vma->vm_start;
> +	info->vma.end = vma->vm_end;
> +	info->vma.pgoff = vma->vm_pgoff;
> +	info->vma.flags = vma->vm_flags;
> +	if (vma->vm_file)
> +		info->file = get_file(vma->vm_file);
> +	mmap_read_unlock(curr_task->mm);
> +	return &info->vma;
> +
> +next_task:
> +	put_task_struct(curr_task);
> +	info->task = NULL;
> +	curr_tid = ++(info->tid);
> +	goto again;
> +}
> +
> +static void *task_vma_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct bpf_iter_seq_task_vma_info *info = seq->private;
> +	struct __vm_area_struct *vma;
> +
> +	info->task = NULL;

Maybe put info->task = NULL in task_vma_seq_stop()?

> +	vma = task_vma_seq_get_next(info);
> +	if (vma && *pos == 0)
> +		++*pos;
> +
> +	return vma;
> +}
> +
> +static void *task_vma_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct bpf_iter_seq_task_vma_info *info = seq->private;
> +
> +	++*pos;
> +	if (info->file) {
> +		fput(info->file);
> +		info->file = NULL;
> +	}
> +	return task_vma_seq_get_next(info);
> +}
> +
> +struct bpf_iter__task_vma {
> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> +	__bpf_md_ptr(struct task_struct *, task);
> +	__bpf_md_ptr(struct __vm_area_struct *, vma);
> +	__bpf_md_ptr(struct file *, file);
> +};
> +
> +DEFINE_BPF_ITER_FUNC(task_vma, struct bpf_iter_meta *meta,
> +		     struct task_struct *task, struct __vm_area_struct *vma,
> +		     struct file *file)
> +
[...]
