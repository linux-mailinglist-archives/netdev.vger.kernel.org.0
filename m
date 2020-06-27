Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846B120BD80
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 02:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgF0AnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 20:43:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30906 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725952AbgF0AnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 20:43:02 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05R0dGrf003698;
        Fri, 26 Jun 2020 17:42:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=J0kOgnXpXAtHNOue29odeRreRTP3XXhVe5z/kWbMomc=;
 b=iW/sU5MDzPQo367hde45m7ltu+KrkN5vnzUtPqI7M0HG9A9IRg6BWS3lrlZJ4oDTPLYo
 PJ6XkEj18sB7sntwBXUI5PqwuLsRmgTEqN8/jnEsyWQr44Xurc1aqocWeTy3yu2emclM
 NbSG+bXufZVqNMYL+nfuw1d/9TJjX1nkcF0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0qg7qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 17:42:38 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 17:42:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XIqebdCICcZRaHP4zKZYsuD8w3hYei82IdrVLVOjFIMbl5aYyk12UygHJPxoln7Fmd0eotIJtdyTqtR9uxbK8Vpl1x9yA/h1GP265sMC0Hioy/tWUuyER/3Fu1O7phXciYAZ13N9cw7qnNJF+sBmSilo29fIfnJ4ilF3rIamLv4veR8vootVOGuXQeIZ/fozHMcZoY5iWY6wNKWacCMd7AeBi/5AMmo9KElbe6tFf/Ia2Lnev2oqQkiunJZyGy4WCl+EGMCHgY1CtLeFr6cdUMqs/kHkqJB0zlytnqUj0IlBtjK4rDGQl7WVbFczJ+6hA1wz2wlqXfbqsDBdUoIROw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J0kOgnXpXAtHNOue29odeRreRTP3XXhVe5z/kWbMomc=;
 b=Eb2NexqGiSw4393bxTUKs9XeWtqxMVLcDs5w5W3bfMfOlm8ieNMwbFlQPCi3CFrdjcprf76Y5jITRGCcqbSoJWRjqWr/KdOkdXdkPRYC3gnyWsXNDpQjqN8RvXLbsSVQ/6uagZSCgvTbRrAxrqJsbHbku5fUp36zjDLg6wWXTFEjPy8JOXbGct1eHOUr0tnjzvBnTk6VMGnR52WRbDH5ev3Dmylk+Y1tL4DV+6dkNJqoekmO6kIJsVv4XBwOYi+vuufltdMyjTyPBanpeH5UzaZm/YzdlnnH6pX5iF91AVv7kSWeWIb3qeKCTu6YF7/2KbbmF6IVmZU2dq5KhSs14A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J0kOgnXpXAtHNOue29odeRreRTP3XXhVe5z/kWbMomc=;
 b=TMTBWnwA44ko8FYkpaVgm1dVcr8z8tI2lzaPJiG2mHW6scUfWP90Jwn/Ic4HhpcM7sebL/q2wq6t9LR581pkt2cEucKA2UizcrToLwSiJ4SN8gS+VXjjOqRuDnrI6vJpHEm+yab/VOW4Q2emG6kxASk6JDViOjxeSTpK03bVMxs=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2326.namprd15.prod.outlook.com (2603:10b6:a02:84::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Sat, 27 Jun
 2020 00:42:36 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.033; Sat, 27 Jun 2020
 00:42:36 +0000
Subject: Re: [PATCH v3 bpf-next 4/4] selftests/bpf: add bpf_iter test with
 bpf_get_task_stack()
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>
References: <20200627002609.3222870-1-songliubraving@fb.com>
 <20200627002609.3222870-6-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d586dcf6-f06e-ca6f-e173-aea8e4717e13@fb.com>
Date:   Fri, 26 Jun 2020 17:42:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200627002609.3222870-6-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::38) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1988] (2620:10d:c090:400::5:90d4) by BYAPR02CA0025.namprd02.prod.outlook.com (2603:10b6:a02:ee::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sat, 27 Jun 2020 00:42:35 +0000
X-Originating-IP: [2620:10d:c090:400::5:90d4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60cc666d-81b4-46ea-af30-08d81a32fc91
X-MS-TrafficTypeDiagnostic: BYAPR15MB2326:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2326EE5B666C0748D78E9E85D3900@BYAPR15MB2326.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ib4iXOaJOCCjT+XcKMz1vZJ9mrLjsx2EUCcBB/HbzxvzQkOtyFpZ297M7uDv+xS7UnjlY3it31aNe4/i9d6Hj7WnN5dfbB4Zjnge59Tz1C9i6HwWXUggLkv3qidkDDqX3qmurwZJc5c+whixCa9VB3HI1EoBsW/khF4+D+hZSA8ml2CxA8kJLPFOae5yLlscFyslo0ecNLXAWQosogAk5KG9rrEXcN3aHpxmay3DabKfheM3XdyN9A+SbuwJOQa+H1BqMzFDF/UVElpB690ADecOPqYZ0M97OC6HRdX3gQBvahXO6BE3mqCYKkHMe7PwweaYSRtYL1UnE9ISPn8jPhG7u/ph0AYMmeTFxI6xW6roSBvd3UI/olV2isIUk5b8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(136003)(366004)(346002)(39860400002)(52116002)(478600001)(186003)(6486002)(31686004)(2616005)(2906002)(16526019)(53546011)(8676002)(66946007)(4326008)(66556008)(8936002)(31696002)(66476007)(36756003)(316002)(86362001)(5660300002)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 4pjI5xay4D2tu/LyLlwow0sCInfAjnbkTVkcnyLDh3TIH8C/+RRhzjKTyVDuEPfpmgrVdZBA8dRcjRsDpooUpromqZf/CF/78BZXU1nwGfc0mezyV9HS4ByQd8SAA1Ti6+TC5KE1IEwh7wJs/BHwXalB1uT7BXx71b6yPpPuxK2UNsdNQOHSy/N7ZgWX5JR+Vms7H/0aJIEYS2IIoBLQJI7uCFZpiMrUb9RBAUhdhX6GxhgGaYmu9nIp8TX5I1hm1RGMIt358Nwpy/akR7tVPIilH9b2EY6CmauUuEZ3lVtWUslpeFS3ZxUvA+7Lcbh60Bvt7ya6KHh/YbHk6M+jngOLUdok6N1tyMH4Sl9feHeDeYpCbsfY86EKruM4XLpprjUWKZUoTSsZ8PuyRvRTynHAa0hGjMEXCLIbPtRnGpQKBwcuALPL1h5oLGZoc0rMn430CfEzOnYnwlVh+bOXXkopInE5GUpc4yipzgtuY8U7QSqvW0wWp719gN/k8Y2wwO4fYBZkPreiews+wW/s9w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 60cc666d-81b4-46ea-af30-08d81a32fc91
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 00:42:36.3406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfT7XzikXZYShtxj22QcBUTSmq6CaxVvNzEPBEk+/HKrnShhxRyDjariHDt2QnTr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2326
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015
 cotscore=-2147483648 mlxlogscore=999 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006270002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/26/20 5:26 PM, Song Liu wrote:
> The new test is similar to other bpf_iter tests.

It would be great if you can show some results from 
bpf_iter_task_stack.c dump.

> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   .../selftests/bpf/prog_tests/bpf_iter.c       | 17 ++++++
>   .../selftests/bpf/progs/bpf_iter_task_stack.c | 53 +++++++++++++++++++
>   2 files changed, 70 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> index 1e2e0fced6e81..fed42755416db 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> @@ -5,6 +5,7 @@
>   #include "bpf_iter_netlink.skel.h"
>   #include "bpf_iter_bpf_map.skel.h"
>   #include "bpf_iter_task.skel.h"
> +#include "bpf_iter_task_stack.skel.h"
>   #include "bpf_iter_task_file.skel.h"
>   #include "bpf_iter_tcp4.skel.h"
>   #include "bpf_iter_tcp6.skel.h"
> @@ -110,6 +111,20 @@ static void test_task(void)
>   	bpf_iter_task__destroy(skel);
>   }
>   
> +static void test_task_stack(void)
> +{
> +	struct bpf_iter_task_stack *skel;
> +
> +	skel = bpf_iter_task_stack__open_and_load();
> +	if (CHECK(!skel, "bpf_iter_task_stack__open_and_load",
> +		  "skeleton open_and_load failed\n"))
> +		return;
> +
> +	do_dummy_read(skel->progs.dump_task_stack);
> +
> +	bpf_iter_task_stack__destroy(skel);
> +}
> +
>   static void test_task_file(void)
>   {
>   	struct bpf_iter_task_file *skel;
> @@ -452,6 +467,8 @@ void test_bpf_iter(void)
>   		test_bpf_map();
>   	if (test__start_subtest("task"))
>   		test_task();
> +	if (test__start_subtest("task_stack"))
> +		test_task_stack();
>   	if (test__start_subtest("task_file"))
>   		test_task_file();
>   	if (test__start_subtest("tcp4"))
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
> new file mode 100644
> index 0000000000000..39b21df17c3ee
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
> @@ -0,0 +1,53 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +/* "undefine" structs in vmlinux.h, because we "override" them below */
> +#define bpf_iter_meta bpf_iter_meta___not_used
> +#define bpf_iter__task bpf_iter__task___not_used
> +#include "vmlinux.h"
> +#undef bpf_iter_meta
> +#undef bpf_iter__task
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +struct bpf_iter_meta {
> +	struct seq_file *seq;
> +	__u64 session_id;
> +	__u64 seq_num;
> +} __attribute__((preserve_access_index));
> +
> +struct bpf_iter__task {
> +	struct bpf_iter_meta *meta;
> +	struct task_struct *task;
> +} __attribute__((preserve_access_index));

Please take a look at bpf_iter_task.c. The above code can be simplified as
#include "bpf_iter.h"
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_tracing.h>

> +
> +#define MAX_STACK_TRACE_DEPTH   64
> +unsigned long entries[MAX_STACK_TRACE_DEPTH];
> +#define SIZE_OF_ULONG (sizeof(unsigned long))
> +
> +SEC("iter/task")
> +int dump_task_stack(struct bpf_iter__task *ctx)
> +{
> +	struct seq_file *seq = ctx->meta->seq;
> +	struct task_struct *task = ctx->task;
> +	long i, retlen;
> +
> +	if (task == (void *)0)
> +		return 0;
> +
> +	retlen = bpf_get_task_stack(task, entries,
> +				    MAX_STACK_TRACE_DEPTH * SIZE_OF_ULONG, 0);
> +	if (retlen < 0)
> +		return 0;
> +
> +	BPF_SEQ_PRINTF(seq, "pid: %8u num_entries: %8u\n", task->pid,
> +		       retlen / SIZE_OF_ULONG);
> +	for (i = 0; i < MAX_STACK_TRACE_DEPTH; i++) {
> +		if (retlen > i * SIZE_OF_ULONG)
> +			BPF_SEQ_PRINTF(seq, "[<0>] %pB\n", (void *)entries[i]);
> +	}
> +	BPF_SEQ_PRINTF(seq, "\n");
> +
> +	return 0;
> +}
> 
