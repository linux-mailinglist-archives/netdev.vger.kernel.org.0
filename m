Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407972DC56F
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 18:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgLPRhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 12:37:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13906 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726689AbgLPRhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 12:37:12 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BGHT1PP010346;
        Wed, 16 Dec 2020 09:36:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Dr3xJpPRwQ1cz7UwfeNW5MKSpTXgiGEFJTHk3c8V/cQ=;
 b=MT1ZU8vQovGdbsZwReUdf1T5Pp/eEGR69YoyHgymHVRDOTUUIhmV2InXBYxnN0I76bJI
 ETXfUb3vpua7x0WwEbSwZrIPChyNa1lr6U/Nbm5O4BVtIZKWuuuR6k4zsxWohYUKkDbx
 6+k9XQIEYACfnqAqGWtWhalZtY66uRy0E2Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35fpcw859v-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Dec 2020 09:36:17 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Dec 2020 09:36:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+ev1kJzUbjoUS0/ZrNpVToWt6a8S2aBXU6hBD7nAZbjCMPPirZ02QB9KqcJscbYSM5OB/xoPlzxPexazpruphKqp/YOzkF57riT7c+cHnzrMN7+n3pijakup3VxtgEHCvKvS5CpuZNOOueDaUkqKM4VKH6D2CE3oS4rq/jpZ+hq6jQA2fLnXYhRoP0ujsX5ZEiMvVbVM+NbpxGlE70Hv4TdUTUsSIsTWc4JS7jexH9xFuTzSP2YIAdKGa62/YYzDibcSj+rpd/heUu8s2nmOYx/4zfFlYp4M51+aO451yDjVKy8GGorNE+zlEcrcszPB7oM6nLo42QNL9ND7xNU1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dr3xJpPRwQ1cz7UwfeNW5MKSpTXgiGEFJTHk3c8V/cQ=;
 b=W/d58AHq/7w4eVLdWNJPPklJnyaYchGCdrhgytv6bYgpXlmH39bq1DvO8BmZ5aF+Ogtb9cKSi0Ogfq+Lh4o/64OtY3qkuNsA7x/cOnPSTcjIvVvfHTm2w85W7OTpzaNlh/IpEJ9HmPoKmBOsUu5OUMkCebq1B+E0siA8kA8aIJqgizIiLgxrbwwhZg7WXiJv9tQTYTzXvoasRJvwr4GAgInoQCiLwRLDGIL9uTIAFGllmJbMWDR0tDwN6LD2JkELaIKcgDaAV3wzcXHxfNvruSFMiTRAIeLYq40RVSQfD6JSaDO3l1HWhrGDBUIzmLP3ecNaCEsxqugQ3QpmQwyQNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dr3xJpPRwQ1cz7UwfeNW5MKSpTXgiGEFJTHk3c8V/cQ=;
 b=G0CzXtJeAkGrQgm71moxGNNmpj6eeXlByxkZeryfovTdiyiNgDJd6zEyqBk8Rybo047TEio3S5HBKx9Itprq9UwVGwUR23+uIzAGCTpHSFNPT2wER0gPc+G2HWV8xYoQxDOeCiFCcX2Ky1oIQx92dOTyU6XAWbyB1lEQpqd4siU=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2199.namprd15.prod.outlook.com (2603:10b6:a02:83::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Wed, 16 Dec
 2020 17:36:05 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 17:36:05 +0000
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-2-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a0892e60-7cc3-80ed-f4d3-004128cb6b8e@fb.com>
Date:   Wed, 16 Dec 2020 09:36:03 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201215233702.3301881-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:4fea]
X-ClientProxiedBy: MWHPR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:300:117::23) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::12e6] (2620:10d:c090:400::5:4fea) by MWHPR03CA0013.namprd03.prod.outlook.com (2603:10b6:300:117::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 16 Dec 2020 17:36:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 014135d2-9724-43bb-2e46-08d8a1e9111c
X-MS-TrafficTypeDiagnostic: BYAPR15MB2199:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2199CAFFFE814B9ED297369CD3C50@BYAPR15MB2199.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 56RdFJJ81CTVVM2h2IoRPWP+usqkXNofKXNk6M0YUw/tIA3OurPQ197DOmP4SmoEMKXTxsXubWywB98HIjEvuOqGYEIb6XL08sWOnSZBrmtQdTI8NDuiGLYd4E/+9Es48Ri6ZPlvBWdzoBFqL49FZ7+4AB42ztjWTuo3sv3yNHYK5eHPMYCayCDZrYOnnEXSUCvUSWnE101hMHbcrcHUQCiK70F2foyBDC+PlFUOjLq+6PtVZUgNBTRhc5qWGEaNevM5W0Z0x58YQdOABJnZnCE5gIT9U8STEuKid5KW2RO30bsULFulwRj++MFwbzwdIy69j5SJ3hvbRZyo/PNP7RZyMO/ph5pfqcmE2+h6RrS6i7ltLbxxCYcQjbyUst/GVPvZwV4TXUmrTwIirGTnUeT4mrWApG79q7ChNvAYjac=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(366004)(39860400002)(186003)(6486002)(66476007)(4326008)(478600001)(66556008)(8936002)(86362001)(8676002)(31686004)(31696002)(2616005)(83380400001)(316002)(66946007)(36756003)(16526019)(52116002)(53546011)(5660300002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aC9ZS1Iwd1UwdkdaeWN1ZU9LTmVtSVZ5aXd2aDJVYmlibnNVV0ZEZ2E5UEhO?=
 =?utf-8?B?VlRjTkJmRGFXNm85cnNBci9NUU4zVENHbnlleWFoUS9PTWp0QW1NcFhCeXhz?=
 =?utf-8?B?elRuaXhmcjgxYVc2MElNQ01nM01mTmRUZmxkN29iT2JrTDhaU3U3RUdlOGtH?=
 =?utf-8?B?N3Nkem80dHpJOWhYRGNDamZaQzM4VWJ5QXVpWCtIMzRMRzhKZlFkNUVhbTha?=
 =?utf-8?B?eHFBdy9pUTZVYmd3dGlHYUhTRnpoMmNmSVJSb2lnekR2ejc3NXRmSSs0WUdl?=
 =?utf-8?B?bmlrTUlYS3NHSExzYUY0Snd5eU9nR2dCcnArQ01qYTdubXNxdGpPd1IyMmRl?=
 =?utf-8?B?V2JtZHVoN1cxRHptR1ZSb1NrVU1ERS83c0JXN3lCZUFIMExyR3lVT0VQaTlI?=
 =?utf-8?B?b0UyOW9FWWtJZVd4NVVMeGlnVVQzTGxhS0VTa0FWY2crbklWOVg0RERLcFdr?=
 =?utf-8?B?TnF2WWo5blBKQXJzUUpBT2xYSzNBNGFjL0ZCV09ETDFpSTdLbStlVXdkUXFv?=
 =?utf-8?B?ODdPUGFLNjBGeFk4bEVjZmc1MzZaNGlPdHB1TTNtNkEzcEJaekNETU1HYUUy?=
 =?utf-8?B?UlBXK1BoamlrK3BIS2hsYmFDampxRW1IN2g5d2J4aXIyY3VBY0plTzlBWG5P?=
 =?utf-8?B?Z3pVMlUvQzF5K0c0K3Fwb1ZYaWpDZzZxdi9sVStPd2k2ZHVxOUVrOENIaXJ0?=
 =?utf-8?B?RXlKY210Q1EwaHlCVk5WVFBrY0tqQkl0dC9BRGFiR2ptTkhCNEVsUDg4cWpo?=
 =?utf-8?B?Y21PZ0drRDJvNmVzcTBtcDcvaEl5QzIyRVB4YWFzYXBaUW5uZSttSndqeGxP?=
 =?utf-8?B?STlNOTgzVmNQUUUzL05tV0NsYnJtQmxFamZjSGRsQkR6YjlraVVRdGE3eUVI?=
 =?utf-8?B?Q2hadHhYL3N1MjI0ZVFib09yaXpZcE03b0JZdEtDOXRMNmQ0RkEwVmxRRzFm?=
 =?utf-8?B?UFYyRWJnUmJBNS9rOTBMWkJOc0VYYndvZTN2RnovamQvUGVod2crUWY5L0do?=
 =?utf-8?B?OG8yMER0UjR4WnBjWE1MQzBWNmh5U2RXYys2RktzRXFoRTgxRVJzT0tkZmdM?=
 =?utf-8?B?V0lZdERrQ2VLSUpWWFNmY3gyS0tzSjloVFhyQXU3dDdiaGNZa3JJa0tFWHR3?=
 =?utf-8?B?UUxDSUwySGEvMEVLTVZFZkdTTzJ4aGxUaW1QUCtiMHMzb2V2TEdGVU14TWhB?=
 =?utf-8?B?TFFWajliMERXZVdvcnR2TlJRWFJmUE5kMS9HSHh0RUpVbFhDT0pPM00yTjQr?=
 =?utf-8?B?M0JiaEVZeEh1aUp1N0YvaXNaNXdMYVQwTVFmTTM0Mk5NSnlLZTdFMmFGRmJl?=
 =?utf-8?B?em5xTEJxNU5jRW9XNUlQQmVHNXJ2YWdvT0lydzhKVW9nWTQ5Y0pYbnpzR0pH?=
 =?utf-8?B?aU1xd2huKzRZSHc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2020 17:36:05.8277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 014135d2-9724-43bb-2e46-08d8a1e9111c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YP5FZaIm4tXLiVjPCOa7M73USShhbpC0xVUTSrmDfoKI+f91uh6xAP+GvACcurF0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2199
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_07:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012160113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/15/20 3:36 PM, Song Liu wrote:
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
>   include/linux/bpf.h    |   2 +-
>   kernel/bpf/task_iter.c | 205 ++++++++++++++++++++++++++++++++++++++++-
>   2 files changed, 205 insertions(+), 2 deletions(-)
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
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index 0458a40edf10a..15a066b442f75 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -304,9 +304,183 @@ static const struct seq_operations task_file_seq_ops = {
>   	.show	= task_file_seq_show,
>   };
>   
> +/*
> + * Key information from vm_area_struct. We need this because we cannot
> + * assume the vm_area_struct is still valid after each iteration.
> + */
> +struct __vm_area_struct {
> +	__u64 start;
> +	__u64 end;
> +	__u64 flags;
> +	__u64 pgoff;
> +};
> +
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
> +	/* If this function returns a non-NULL __vm_area_struct, it held
> +	 * a reference to the task_struct. If info->file is non-NULL, it
> +	 * also holds a reference to the file. If this function returns
> +	 * NULL, it does not hold any reference.
> +	 */
> +again:
> +	if (info->task) {
> +		curr_task = info->task;
> +	} else {
> +		curr_task = task_seq_get_next(ns, &curr_tid, true);
> +		if (!curr_task) {
> +			info->task = NULL;
> +			info->tid++;

Here, info->tid should be info->tid = curr_tid + 1.
For exmaple, suppose initial curr_tid = info->tid = 10, and the
above task_seq_get_next(...) returns NULL with curr_tid = 100
which means tid = 100 has been visited. So we would like
to set info->tid = 101 to avoid future potential redundant work.
Returning NULL here will signal end of iteration but user
space can still call read()...

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

We may have some issues here if control is returned to user space
in the middle of iterations. For example,
    - seq_ops->next() sets info->vma properly (say corresponds to vma1 
of tid1)
    - control returns to user space
    - control backs to kernel and this is not a new task since
      tid is the same
    - but we skipped this vma for show().

I think the above skipping should be guarded. If the function
is called from seq_ops->next(), yes it can be skipped.
If the function is called from seq_ops->start(), it should not
be skipped.

Could you double check such a scenario with a smaller buffer
size for read() in user space?

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
> +static int __task_vma_seq_show(struct seq_file *seq, bool in_stop)
> +{
> +	struct bpf_iter_seq_task_vma_info *info = seq->private;
> +	struct bpf_iter__task_vma ctx;
> +	struct bpf_iter_meta meta;
> +	struct bpf_prog *prog;
> +
> +	meta.seq = seq;
> +	prog = bpf_iter_get_info(&meta, in_stop);
> +	if (!prog)
> +		return 0;
> +
> +	ctx.meta = &meta;
> +	ctx.task = info->task;
> +	ctx.vma = &info->vma;
> +	ctx.file = info->file;
> +	return bpf_iter_run_prog(prog, &ctx);
> +}
> +
> +static int task_vma_seq_show(struct seq_file *seq, void *v)
> +{
> +	return __task_vma_seq_show(seq, false);
> +}
> +
> +static void task_vma_seq_stop(struct seq_file *seq, void *v)
> +{
> +	struct bpf_iter_seq_task_vma_info *info = seq->private;
> +
> +	if (!v) {
> +		(void)__task_vma_seq_show(seq, true);
> +	} else {
> +		put_task_struct(info->task);
> +		if (info->file) {
> +			fput(info->file);
> +			info->file = NULL;
> +		}
> +		info->task = NULL;
> +	}
> +}
> +
[...]
