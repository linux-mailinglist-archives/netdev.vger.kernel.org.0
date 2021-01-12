Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961412F3912
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 19:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391311AbhALSoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 13:44:12 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5110 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729952AbhALSoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 13:44:11 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10CIZqjQ026178;
        Tue, 12 Jan 2021 10:43:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=dMNBbJFN1Kot4iruVTvfjRjuaIk5ALC2PkykGJqUlu4=;
 b=HF3bhFBNYWTWBzfGq3QQATVTxnBtMsPTKzh9sF6juNiZDnA0voS7ouZkuRRHh5gZusya
 mddeW+lg/S7aC/7xq0uPI0KvpSKgR6i6T56oLxWhpBE14jJ4lzN+fwiZqyyH9l33Hpf6
 Pth97jpMboo7w48SCElppWxtdfnYHs3El+Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 361fpfrpcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 Jan 2021 10:43:13 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 10:43:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOULx+sQgFubXqy36rP1jKHbB1gpF2Ks2mFpiYjO6D53+CoVH36CVLMSDyQEoTo4lsZWbTca7bMtGcG+LMBpn+MlPvKTA/ul4adtBwzkWnVRfH2hqs9FlZSxYz5AyWmQTdV70MEhnnPFkX6gYl7UVOReW135AjbgCRdTSdxy1PMfk7S3YmDNfMK6M0+HYu2RW7uwA9in7G7TfNeiyY9kgCWrdqmuaeTyVkr8oIE7OOKytuB1NFu6ihMmpDhzVIFQyB6ypKQDJQYSOSzRSLZKKGa9/uvnHsMEZNiDys0wbbrBlCHHeEr8e732ygpxCxymapDEaIpFhpp1uu8kB7Kebg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMNBbJFN1Kot4iruVTvfjRjuaIk5ALC2PkykGJqUlu4=;
 b=LiU9u8GmFT1IwFy2N5U0tiybgwKeLMJgAghQmFHWELynOfB7b0eY5UPmSwHWEsBJsTjKO+3DBDjxHQb6HCkHRUMBgEa1uwYRQ3pYmwbzIldkXq6Otw0+LBe7l+IP6f7+aYqBzi1LtqkIkc/MdP8ttcKD9T1kKMDKM5rxpp0gITRJMA1nB1RpGzszK0kWEICBN+p+PIAWpRlNteQn9SZei8MZwJD0rFPWTRu3F/cNTrnrs1DHTD1LVnHVYs0yBUkpLAHqqtN2BST1mLkZUwB7vfv54VzYhalJACbMlAY/6TO7c0ZPR0SKTDgZBpsoZHoRF4gBj4sJ3rKdeLASzTXBBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMNBbJFN1Kot4iruVTvfjRjuaIk5ALC2PkykGJqUlu4=;
 b=DFFjhBvASmv98c5vS3QzDQjksS6pOncAe3yY82Km3Mbop1e09MoXYztf8x3PY+5QCTypFWH0FHnsQ1OTao8l0/72m25ix2Pb8WCuKfHE4ZrGTkQLkayEM/oM2k4DgCJOlxtoL7STBTq+wPSyO0tHHG0df0xHWRuHslzQWbnwOFU=
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2454.namprd15.prod.outlook.com (2603:10b6:a02:89::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 18:43:07 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 18:43:07 +0000
Subject: Re: [PATCH v3 bpf-next 1/4] bpf: introduce task_vma bpf_iter
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>, <akpm@linux-foundation.org>
References: <20210107041801.2003241-1-songliubraving@fb.com>
 <20210107041801.2003241-2-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <982e7012-672c-dbde-da97-c3752f9976ae@fb.com>
Date:   Tue, 12 Jan 2021 10:43:03 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210107041801.2003241-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:3e3]
X-ClientProxiedBy: MW4PR04CA0404.namprd04.prod.outlook.com
 (2603:10b6:303:80::19) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::190b] (2620:10d:c090:400::5:3e3) by MW4PR04CA0404.namprd04.prod.outlook.com (2603:10b6:303:80::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Tue, 12 Jan 2021 18:43:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2822b7a-a56a-40b6-d0bb-08d8b729e759
X-MS-TrafficTypeDiagnostic: BYAPR15MB2454:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2454E652508684762B8217D3D3AA0@BYAPR15MB2454.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 41+53FtWuXRJ9irVQAXnPD7rtcpgF7Eo1sqkAUXbUe3LQIwCR7wFiGZvxat4YGXj2LaetYKBvaN1CnL63UkAibbFbQQ8SyiP+6GDbA7+0WhzFbMyYz5dY640rGmsR9+hOKF7Y72bIdfbeUDNLoHhfq8C4Jmiyv7zNHUFI9B2EjXjDjPlwus+AeK3Js7nDPPNf1Pz9QMD/zt6iRo2h6OQTzJaU5E0ruTe2o3VFYlT5j8Y06eVDFndZ1zMuGVJ2yIF39OUtF9hH6YFRRooKg5Lzk9WRzVbm0CFSP5sGrdS/NbTyHt6Q8s8tT/hGKmavZvhDjRHftcZg2s0API2Iss6sW8FKm9lpW9BiiOuAqUsuvVbmlwx1ze7Yqi2GCZ+zg5EuKCQHiQdgUndWM+k9Nvvexx93KPoBWzn76hroBJJX8MHqi8FAXVW2tWsqEUFoupCjgbX6Bnr/QxSERS/Ivl+pFlxPC0CZHtqNu4ZBdI0c1w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(136003)(39860400002)(376002)(31696002)(6666004)(478600001)(4326008)(66476007)(2906002)(66556008)(66946007)(5660300002)(186003)(8936002)(83380400001)(2616005)(6486002)(86362001)(53546011)(52116002)(31686004)(16526019)(316002)(36756003)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WHpSdjJpc2RYVytoREM2T29GbmFLTzd6R0o5cmxKY3lCWWp2eVBRcERmZ0M2?=
 =?utf-8?B?M3QySTJXL0lqQ1JDMEtLNDY2bzFKZXRlYVU3NEJneVpic2k0OFFNZVhBYk1l?=
 =?utf-8?B?Q2VpYkZzdDhjQTNJejFKWjJLRjZpbERtT3p2ZmJvOHlSQzd6OWZGUW9KZktE?=
 =?utf-8?B?TjhWTGZvNWJqVlUvUEhWdjJOUHlJcWlZcnRLbHdZcGRXYVdBcXZnQVgySDgy?=
 =?utf-8?B?WEgwbjhMQWJFU243d1ZkYUEwSkphSWJRMHVYaW1vZThnclRwaVBrYTAzdTAz?=
 =?utf-8?B?c3lZR3NZTS8vdTh1Y1AzQUZTbmRkdXVJSjFJUlJtUGhzcHByZU1JWG9IdFdm?=
 =?utf-8?B?VGttcGE4VGl1NlhwUkhqb3B6MzR3bDFCNS9uYlpJd2paUVJubmRWbUFiT3Jr?=
 =?utf-8?B?TnJhbXRCZWtraXRrZzVYYWZiRjBDYzczc3g2SE5qNnhHV2lxUWFMbmJyRW5D?=
 =?utf-8?B?Z0o1MGpXdVpyaGZ4bUxnQ0x4OC9NMHJ4ZDBEVjBNckR5cy9SS0plY0xBRnRH?=
 =?utf-8?B?ZCs2TW03dW1NdU9NWXFzdXVLWGxmU0hSS0hFUXdmQ3o1VWtRZlg2SkpMSkR0?=
 =?utf-8?B?Zk9LYi9QRWkxTWVLM1hxV0k0SnhMWU03dDFMOTVIYXczZ0tBU3gxcFNaeGRW?=
 =?utf-8?B?ZTE1S2QxOW5QcG01THFMT2JXekVxNTVEWExWdXJCckVSUmhTaVliaFM0ZTNQ?=
 =?utf-8?B?aDRsa1J2djhWS3pSOXBrZCt3dFh5R1l1K051WWl6UTVRQ1F0aUtoNGdia29Y?=
 =?utf-8?B?Z01ja0xBMUZxbXRUWjFFZE0zSWxwdW8yaHl1bWxIVHdWK2xjekVUcjZlcnRj?=
 =?utf-8?B?M1BWSlNkM0Q0WHQrbTFSK2xYVmMyQkdMR1hKMG9weXJzWWJ3OGN3c1F6S01s?=
 =?utf-8?B?TGNyd3hmeXczdWhac2lUSEhZNzdsd0IvMWtnK3llODBkN3NzTFZ1NHNGN2M1?=
 =?utf-8?B?d0dob3ZKdUkrd000YlhQNjdmbkZGUHlSc1NtUzUwaFkwUi9xcmdHY2x4amMv?=
 =?utf-8?B?ZGxUVkMzN1hUVzhPdFMwWHZvWGUxYi9FV2hVb2NiUEZXVUdicFh3bTEwS2Rw?=
 =?utf-8?B?VjVneWNoSTBsUGtRd1libjVxcHRXQTloekV6cjIwZ1RHUlRySkZOUGxGaVk4?=
 =?utf-8?B?Ym5Va3RmOXJCZU4xdTgyTTY2T0NPekVIbGM4Rkc3OUNnZk9GVnpzWWZGOHl4?=
 =?utf-8?B?VE9uTHBBdmNGNEhpZmlaekhna2RZUEh3dFBBeHBNc1VVMXhiVUI3ay8wNWR3?=
 =?utf-8?B?c1RFbjlpT2szdmdNR0pGbm5sMHhOTE1RMU9WZjdROU1XeWFtREdwbXZKQjhj?=
 =?utf-8?B?UUkrRFdRQ1pCbjRoYzhvOGFGMTFvR2FvcjFibUxFZUlOZ0JWWGdGVXFFQjl6?=
 =?utf-8?B?RFVTYjFjVzNwa1E9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 18:43:07.4091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: f2822b7a-a56a-40b6-d0bb-08d8b729e759
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yRIaY+v3XtHWsyzSBfwEZ6jjhn/lXDF8gRxtOSgWUvmdQHGEYWNFHpRB4EokEyrq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2454
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_15:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 clxscore=1011
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101120109
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/6/21 8:17 PM, Song Liu wrote:
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
>   kernel/bpf/task_iter.c | 211 ++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 210 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index 0458a40edf10a..a1d3c9d230f68 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -304,9 +304,192 @@ static const struct seq_operations task_file_seq_ops = {
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
> +again:

We can move label "again" to below right before "curr_task = 
task_seq_get_next()" since "goto again" always having info->task == NULL.

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

Could you explain when mmap_read_lock_killable() may fail?
What I try to find is if mmap_read_lock_killable() fails, we should
abort iterating or we may request user to try again (if user buffer
is not filled anything).

> +				goto finish;
> +		} else {
> +			op = task_vma_iter_next_vma;
> +		}
> +	} else {
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
> +static void *task_vma_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct bpf_iter_seq_task_vma_info *info = seq->private;
> +	struct vm_area_struct *vma;
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
> +	return task_vma_seq_get_next(info);
> +}
> +
> +struct bpf_iter__task_vma {
> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> +	__bpf_md_ptr(struct task_struct *, task);
> +	__bpf_md_ptr(struct vm_area_struct *, vma);
> +};
> +
> +DEFINE_BPF_ITER_FUNC(task_vma, struct bpf_iter_meta *meta,
> +		     struct task_struct *task, struct vm_area_struct *vma)
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
> +	ctx.vma = info->vma;
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
> +		info->prev_vm_start = info->vma->vm_start;
> +		info->prev_vm_end = info->vma->vm_end;

This change, together with task_vma_iter_find_vma action,
is not correct.

What we typically have is info->vma->vm_start/info->vma->vm_end
is the next show but since there is no room for that we will
delay until user space processed buffer and come back.
So here, it is not prev_vm_start/end as it has not been
displayed.

Maybe you can separate task_vma_iter_find_vma into two?
task_vma_iter_find_vma and task_vma_iter_find_vma_next.
(task_vma_iter_find_vma_next carriers the action with
what you have now for task_vma_iter_find_vma).

In the above task_vma_seq_get_next(), if info->task != NULL,
you will use task_vma_iter_find_vma_next (the one after previous
vm_start/end), if info->task == NULL, which means back from user
space, not going to next vma if there is an exact match.

> +		mmap_read_unlock(info->task->mm);
> +		put_task_struct(info->task);
> +		info->task = NULL;
> +	}
> +}
> +
> +static const struct seq_operations task_vma_seq_ops = {
> +	.start	= task_vma_seq_start,
> +	.next	= task_vma_seq_next,
> +	.stop	= task_vma_seq_stop,
> +	.show	= task_vma_seq_show,
> +};
> +
>   BTF_ID_LIST(btf_task_file_ids)
>   BTF_ID(struct, task_struct)
>   BTF_ID(struct, file)
> +BTF_ID(struct, vm_area_struct)
>   
>   static const struct bpf_iter_seq_info task_seq_info = {
>   	.seq_ops		= &task_seq_ops,
> @@ -346,6 +529,26 @@ static struct bpf_iter_reg task_file_reg_info = {
>   	.seq_info		= &task_file_seq_info,
>   };
>   
> +static const struct bpf_iter_seq_info task_vma_seq_info = {
> +	.seq_ops		= &task_vma_seq_ops,
> +	.init_seq_private	= init_seq_pidns,
> +	.fini_seq_private	= fini_seq_pidns,
> +	.seq_priv_size		= sizeof(struct bpf_iter_seq_task_vma_info),
> +};
> +
> +static struct bpf_iter_reg task_vma_reg_info = {
> +	.target			= "task_vma",
> +	.feature		= BPF_ITER_RESCHED,
> +	.ctx_arg_info_size	= 2,
> +	.ctx_arg_info		= {
> +		{ offsetof(struct bpf_iter__task_vma, task),
> +		  PTR_TO_BTF_ID_OR_NULL },
> +		{ offsetof(struct bpf_iter__task_vma, vma),
> +		  PTR_TO_BTF_ID_OR_NULL },
> +	},
> +	.seq_info		= &task_vma_seq_info,
> +};
> +
>   static int __init task_iter_init(void)
>   {
>   	int ret;
> @@ -357,6 +560,12 @@ static int __init task_iter_init(void)
>   
>   	task_file_reg_info.ctx_arg_info[0].btf_id = btf_task_file_ids[0];
>   	task_file_reg_info.ctx_arg_info[1].btf_id = btf_task_file_ids[1];
> -	return bpf_iter_reg_target(&task_file_reg_info);
> +	ret =  bpf_iter_reg_target(&task_file_reg_info);
> +	if (ret)
> +		return ret;
> +
> +	task_vma_reg_info.ctx_arg_info[0].btf_id = btf_task_file_ids[0];
> +	task_vma_reg_info.ctx_arg_info[1].btf_id = btf_task_file_ids[2];
> +	return bpf_iter_reg_target(&task_vma_reg_info);
>   }
>   late_initcall(task_iter_init);
> 
