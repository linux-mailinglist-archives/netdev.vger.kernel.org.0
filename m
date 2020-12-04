Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81382CE925
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 09:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgLDICz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 03:02:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7746 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727007AbgLDICz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 03:02:55 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B47tnZ1022948;
        Fri, 4 Dec 2020 00:01:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=MP43SE1AizmpoV61uv3VU+eVsypjoBNohXZXpxqMFas=;
 b=Y/NflD7wJ53wv7bKqrVbzdS7WC00QhgAf5QkxTy3bgXwh0F3lW7RSplKvA4VRl2Ot5Rn
 hVMzb8QglpkwwQoGHjntz0oCF40EglLgb/qhVTgy0cWo8vPIOsAyN8NG09teF+8S8Ps3
 L+1vzJPzevVK7BdChtZj58qV1Pzy1LihRRo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3577a2bkr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 04 Dec 2020 00:01:58 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 00:01:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tzceqk9wuFbhIQqEQWNdREDswlu8Gt0RqGkuW5KOGJSxNRJ3WQlDveO0UBbVYpVg27uvPkTu3FrRbe9iQWMVq+wqKNO2jw7ZTv2pSGu0iKNIWu/sQ5rJsOpBJdU+xmaltCeGsaMDsU/KRsrUtKCltXx9I4a4NA8/uwhvS3qe/F38Y4W4cbSEKoBOXnEKnw1ujL9AqxnCMUIzd13l7RkKvFk+tKvVClA48xULI9K/iSFtZcBPv0AtTZM0d7jBqYL7C5lgyVZXu7GGvrZpLA8qzP/PWS1s9r4GisadFIF04OGTlg9/FjDwe2CCBV0E9Vr6AKlVPfdQeW4cy9LCsgN2ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MP43SE1AizmpoV61uv3VU+eVsypjoBNohXZXpxqMFas=;
 b=DccNIkkY+vGmcCSOT/5uNXhvCFw80IcSjWO661s2RF2VctmCxhF1ybtcGX+AMYGJ5pmNpWfrL7GruzRdxGKxWzbg9apTSRBVcyCpMZ6bfzVFZwNwU/NSC3AUDSPBjBMGJaVx458zoczrdHef5Rjyh+SbtUE1/KvSWbNtWUU0lywQWarYRts9O/Zbr0jT1GfzdkKhRmTFeU/R5t9xtqlx2mT5G1fyv8zJzecFR0lAu562hQjW83u8synNVxgurpDM0ywJsioMnihxgh7wePByoRVfES4y1JWigiWHcNxuuAFqQl25qa8l5WgUJ3CwvO5YLG0F1wkQ10NooVZ+JO0xBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MP43SE1AizmpoV61uv3VU+eVsypjoBNohXZXpxqMFas=;
 b=gDLTX7jMf/uhKCKVBI2zdMN3fs8ZIgm63EEqmGQUetBx4a9x6aSkxb+H96vm6w8ULIFVIi6O8JyasalrFvCaV/pKpVp0hErzsWnOCqvkZPfAiOGj9wOkl1pVAOBqUOEiDDBlQ3cSKptQGkTVVUqeZqepxSvwYa5ywwN1WB8AfGs=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3366.namprd15.prod.outlook.com (2603:10b6:a03:10d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Fri, 4 Dec
 2020 08:01:56 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 08:01:56 +0000
Subject: Re: [PATCH v2 bpf-next] bpf: increment and use correct thread
 iterator
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20201204034302.2123841-1-jonathan.lemon@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2b90f131-5cb0-3c67-ea2e-f2c66ad918a7@fb.com>
Date:   Fri, 4 Dec 2020 00:01:53 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201204034302.2123841-1-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:1dae]
X-ClientProxiedBy: MW4PR03CA0341.namprd03.prod.outlook.com
 (2603:10b6:303:dc::16) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::12b3] (2620:10d:c090:400::5:1dae) by MW4PR03CA0341.namprd03.prod.outlook.com (2603:10b6:303:dc::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Fri, 4 Dec 2020 08:01:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11464475-f710-4509-f9b7-08d8982ade33
X-MS-TrafficTypeDiagnostic: BYAPR15MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3366A1E5BA1EEE680ECF0320D3F10@BYAPR15MB3366.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wk4QWmUrQ9/l0u6RpWpVxJX4x4ZPBEzlkbJ/KIuokjte/Kmqq/I7F3sslaiPrn9ZmyjXLQldQUPWTMt+UfDvypn0uSytMGCMVr+VZVsG5JT8N4wUcjNwtmm0vJpXQW9z3cBzOg5Z2x0bIRSLHIA6uqToK9XuEB3XJLOmFE3744ouM97F8Hc6EiAZws+kbv6egarHCslpCjTteh65U/Ewgc/YXmczeMwA3sBqpN/zBe+wbmSIkpD7EOv+Y5SdUBsc22k2E1wGn0qgBwmDNa4b5M0uEgP23/DozGIGEZaAzZwOLwtuYwgc/2VzwvJpDX+bmwXlaiISwSAbmOW52OzLYDJiDIe1T/hTDkQ+MaisU1MDAkIhZ01/uKFWDy1r6qb02OrCdriqgLwZWle52hS8VOoDUWgol7t3s3f30p6VK0s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(346002)(376002)(39860400002)(16526019)(186003)(53546011)(86362001)(83380400001)(6486002)(2616005)(8936002)(316002)(31696002)(4326008)(36756003)(52116002)(66476007)(2906002)(8676002)(31686004)(66556008)(5660300002)(478600001)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dFI5UkV0cCtXKytxSUNaQjhUVXhPZE1qN2FaeVVVaTJXYUxzeU1iU2UyRzk1?=
 =?utf-8?B?YVlWekJ1eTRsZVZTYW0rYm5IQ2FHSzNZaEV1Y0QvMFRrbGlXdTNWbEVLQ2pW?=
 =?utf-8?B?b1k3WjJLNElvTnUxT1ZwWCtOYVFGak0yRlZHYmhxR3JJcHJ2Nk1kdGR1T0Np?=
 =?utf-8?B?aUdJSzVTN3k1UndwSldSOWI4d2k5eTY1aksvZXkydkN2eHFpZ0lkT1k4U0Vo?=
 =?utf-8?B?VUpNZDlBN2xvalF6b0Yxb25wU3gwdkpqKzY2NFlDVXh5N0NQaXh2WjJ0bXNz?=
 =?utf-8?B?TWE2U0Z5aXRHbHJHNVZyUkdpS05vY3pDUGxLeDNoZFE0QXZzTC91YzRCOG5i?=
 =?utf-8?B?c09YTWFsNHVoYUJYcUc3ZlY4YlZDKzg4eWZ5OFVrZnhrV3BmN09mS095WVli?=
 =?utf-8?B?M3dkOW9Lemd5S3k2aFZXTkhzSTZ3a29oc2p2RThaMS9vbGpRai9DZElCM1NU?=
 =?utf-8?B?M1VEUzBFQVdLTTVHeWZoelZPNjYzbjlqYmhDN1FGRk1RZVZ3dFowYTFaVm1a?=
 =?utf-8?B?UVJSVVJVbDdEWVc2V2hIRkRFbEVVb1VobWNGOVFHNDlOdGRtdGNNeU1yWlJp?=
 =?utf-8?B?N29zRnVHanRnbjlnaGd5OVdVTGs3NjNPS0prQk5RWFhwdytLTDhlOXN4STlR?=
 =?utf-8?B?Vk05TE9MQjM5clZjbG53TlJiT21UY0lsR3BHVFpQR1NYbUNrRlNwajBrMDZl?=
 =?utf-8?B?Nk9zQ1V4VXpReXJ2MklMZ2xDZ1pMRWFSN01vUXRKdmY5Y3BLRVA4YmhmakZE?=
 =?utf-8?B?WlJTdkc5NGVkVXpZSWNhRlQwMThvRHRwZzBiSWxQZ2NjQThXZzNveVZTMjZY?=
 =?utf-8?B?R2hYZHcvaXcxVzhzS2prNXJ3b2t2R0dEajJ6NCs3SnBLdk5QOFh5R2RURVp3?=
 =?utf-8?B?bFRSWmMyTXVNdnQxR0VyRkl2RVJvTDBVbFo0RzZiZjlGT1ZwZG50RGZKNVJF?=
 =?utf-8?B?R2F5Sk4wWjBzWWxGOGRYZ2ZHWGhiQ0NtUzAvMzJCRlJDZ0p2bmhoQ3dxVkFh?=
 =?utf-8?B?bkNNVHJzWUdRQ2xlZU8xTXBzdi9JZThQY1FTVW9lSlU5MmMrbnZCWVJHYXJJ?=
 =?utf-8?B?TmVlWDZjMk1JUnhSV0lTc1o2VVBwNTY4TVhTRFVsSk1PSDZrNW9lZDJORlFo?=
 =?utf-8?B?cWhWL3JERUhWZUFOblB3LzhLVytrMlBHZ0lRcTZJWXdxS0cvZkJSMlM5Tkdi?=
 =?utf-8?B?Y2RvZW00dDJmL3d3MmxSVzlwS2FKSVo2UHVsUHpzRTluVHZmMlJTS0VkY2J1?=
 =?utf-8?B?b3lZd1Q1bWNZckJPQnNsUWFTOHd6WlQ5Z21rMjBveHJncTVlMFd2QnBPZ3Ex?=
 =?utf-8?B?T2FrbDN0Z3NEVjJkVzBGdGxNOTBRN21jMU1wNFI0T200V2E3UzhHVjBWV2h1?=
 =?utf-8?B?b3F0Tk9yaXBSRWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 11464475-f710-4509-f9b7-08d8982ade33
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 08:01:55.9030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: knu7aW21q7pleCJm1vrPpwGu0Njh9/lQxcd+FnIe/vGf6DyOJ7RcC/z3y474syQa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3366
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_02:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012040046
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/3/20 7:43 PM, Jonathan Lemon wrote:
> From: Jonathan Lemon <bsd@fb.com>

Could you explain in the commit log what problem this patch
tries to solve? What bad things could happen without this patch?

> 
> If unable to obtain the file structure for the current task,
> proceed to the next task number after the one returned from
> task_seq_get_next(), instead of the next task number from the
> original iterator.
This seems a correct change. The current code should still work
but it may do some redundant/unnecessary work in kernel.
This only happens when a task does not have any file,
no sure whether this is the culprit for the problem this
patch tries to address.

> 
> Use thread_group_leader() instead of comparing tgid vs pid, which
> might may be racy.

I see

static inline bool thread_group_leader(struct task_struct *p)
{
         return p->exit_signal >= 0;
}

I am not sure whether thread_group_leader(task) is equivalent
to task->tgid == task->pid or not. Any documentation or explanation?

Could you explain why task->tgid != task->pid in the original
code could be racy?

> 
> Only obtain the task reference count at the end of the RCU section
> instead of repeatedly obtaining/releasing it when iterathing though
> a thread group.

I think this is an optimization and not about the correctness.

> 
> Fixes: eaaacd23910f ("bpf: Add task and task/file iterator targets")
> Fixes: 203d7b054fc7 ("bpf: Avoid iterating duplicated files for task_file iterator")
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>   kernel/bpf/task_iter.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index 0458a40edf10..66a52fcf589a 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -33,17 +33,17 @@ static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
>   	pid = find_ge_pid(*tid, ns);
>   	if (pid) {
>   		*tid = pid_nr_ns(pid, ns);
> -		task = get_pid_task(pid, PIDTYPE_PID);
> +		task = pid_task(pid, PIDTYPE_PID);
>   		if (!task) {
>   			++*tid;
>   			goto retry;
> -		} else if (skip_if_dup_files && task->tgid != task->pid &&
> +		} else if (skip_if_dup_files && !thread_group_leader(task) &&
>   			   task->files == task->group_leader->files) {
> -			put_task_struct(task);
>   			task = NULL;
>   			++*tid;
>   			goto retry;
>   		}
> +		get_task_struct(task);
>   	}
>   	rcu_read_unlock();
>   
> @@ -164,7 +164,7 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info)
>   		curr_files = get_files_struct(curr_task);
>   		if (!curr_files) {
>   			put_task_struct(curr_task);
> -			curr_tid = ++(info->tid);
> +			curr_tid = curr_tid + 1;
>   			info->fd = 0;
>   			goto again;
>   		}
> 
