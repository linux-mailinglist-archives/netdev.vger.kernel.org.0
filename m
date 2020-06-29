Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8045120D29C
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgF2Suv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:50:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24134 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726567AbgF2Sus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:50:48 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05TF5qSs029221;
        Mon, 29 Jun 2020 08:06:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=HnDEnL8zq+AAbs9pmTHb2Jebp8tfA5gmJOXiPnRU+6Q=;
 b=KLxd5ONfJS108jEFUTGK8ALhFNm7n0PJZV414k9CuOjBpDAbJoaIo1PTvagqGU9fvc70
 8gPJ+Op66orWRmscd1zcWAg3YS6YKd4Ph+C7MP0FdmHof4KCvJUFOIAfft+zacq02fvC
 GdxBc+weqiB29fil4oQQMc51Ju5yWdxBaNQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31xntbmx05-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Jun 2020 08:06:55 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 08:06:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VI5TIAinUwO3/a4x8Tqi5v/L6ycGdW8fQz0YrJQzE6grSHP74H/C4SlU4+RYg37fabZGmVOv+fUlsx0spbo+/yecpOCbW+PzfcI4YtqPdoxr7aQy2Yq/nvqvvmloR3Sw7vCBEwcIfzSsXzqKwt4Ky4AdCEovWUwPxm40rN1h48HcPhLHFKZIYH7N1VQSNhtgEz0Wa3m4smpX2juuBDqI1iiwXPG5EZsVKthm+xSOIYnw4ogsOCr+JiZR5lyJTUrZw2RnbJ0CCVbXnP7LVOZbDO0QNP23PYFjXRGFww6Z1zuFTNCvNggTt9w9fUueKKV/W2hTezuiYiVp98Avn/dxlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HnDEnL8zq+AAbs9pmTHb2Jebp8tfA5gmJOXiPnRU+6Q=;
 b=VPYGSz6L/evJeAW19z0+lHT7y+9BU4o+w6e/w+5RxxMlBuFlrN+1v8279j/Bs/pglrcAbXF5PebJW1U83ZuEi7Nn2phVcXR/MSI5rroryFUbEr0vt3w6U30hbkqM59u8zpJwRBUDtSB6tOkZdzug43bKyaplRwRiUDu71gQjAt2vbmpHqcJqDCSG5fpsV1Ficl50EQYkur1RiJjmj+lNGnt8+O4fDgbSeVKwlRio8y/JmoF6CQ+nE4QLfc74Nj7utOXRP+Daju0Lqrn5Seb54QagjJ9StFs+c5oyUY1NkSjh/MHT3Wpb8gHWSeiKMmN6y67+b5OwSAMBRC0XeeZlLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HnDEnL8zq+AAbs9pmTHb2Jebp8tfA5gmJOXiPnRU+6Q=;
 b=TFHT1r2I9g+Q56H1M+mQh2zllsJbBbp2zDdHBJYrwpC2bVxmdFnwBMcR5S8OGqtxe6Ip5S+p3u29uI3qDKSReiFe1+wzCw2xkJfA67d7Gh5cf3g7N+ebtEDS5PJZbEjm/Z8Bm/rWUQaH3EuzPbkqqWfoSmFzVWQ4Maxv1e2yBGU=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4086.namprd15.prod.outlook.com (2603:10b6:a02:ca::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Mon, 29 Jun
 2020 15:06:52 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 15:06:52 +0000
Subject: Re: [PATCH v4 bpf-next 4/4] selftests/bpf: add bpf_iter test with
 bpf_get_task_stack()
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>
References: <20200629055530.3244342-1-songliubraving@fb.com>
 <20200629055530.3244342-5-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <bd62a752-df45-8e65-9f74-e340ef708764@fb.com>
Date:   Mon, 29 Jun 2020 08:06:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200629055530.3244342-5-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:a03:217::33) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::11fb] (2620:10d:c090:400::5:c5e6) by BY3PR04CA0028.namprd04.prod.outlook.com (2603:10b6:a03:217::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Mon, 29 Jun 2020 15:06:51 +0000
X-Originating-IP: [2620:10d:c090:400::5:c5e6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e56ea51-0810-4319-1068-08d81c3e0dcd
X-MS-TrafficTypeDiagnostic: BYAPR15MB4086:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB408637CCA26C9BBC4BAED91AD36E0@BYAPR15MB4086.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-Forefront-PRVS: 044968D9E1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7NFhi/9PsteJntgUNk6AWolagnRvPRZ8XCXzkVH3GvJyBzlZ0eDgXxScsLO2EBnYuWUhvuQIepozpVfVAQ4qB42hjje0v8/oVtOl+NLy7w06+Z/fnWoB4LYi9RYk8uGQUvpmLhlRJMQLaGZFsRKLV6qwJHb1XDKOWgIskQ8udJG4fU6+jjWdwpcrqV3WPuQZKDYCutEEC5oT4oGqs4RxSlP99XUhsLbFUzJY8JOZPpAJ2+6h8MoZFRekPDkS2fbp5S/qwfISAV1je6hiXmsP7p5gvSTLkmDUM+p+9x+c+jnJVzShFp9oXDOhfgiJyZn7DFeMGegLqgbFQQf7jJauK9mPusSVrjr8TiUsSYfEaZBNmG3r1JifdMndZs/SGPaU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(376002)(366004)(39860400002)(346002)(2616005)(6486002)(2906002)(53546011)(52116002)(66476007)(86362001)(66946007)(36756003)(66556008)(8676002)(31686004)(31696002)(478600001)(16526019)(8936002)(4326008)(186003)(316002)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ouBvviEUcdAGT9du771AMjemwjT+SeTwS2iPsekg9mQJe9WwEA0u+P3QSvdBH8NtGB54s7SJo8StfTiAX7Ojr+W2gicDg8UQOLlhfc2NBPiScqqdt/OOM1Vw0U1L8/LFjMYC8PtBQSJeTnZny/vJ7zf2dPN9h02fbdSYnsjTctxP2BP8izOWPgM5gzivwxtix93WkfUw/b8ks85KEFoEggUZ8LG30ZyluzvIurK9PxzufoftZnY5BZjrKztFKR3VO4sY7hboT6EdLO8qOvQepYGgffZQ3FkgT23RMpiv49LWpAyee4wG14ASSul10tgMggWYvXA+psnV4NOdm5EO0o1OlaSSK0GtHv1u5Vqv2NcR7keuHBK4xtCrD+qGqPkdAc5YlAF6H8j3lvdv0smbiGtndDzCH0jPaSEdk/c0UZUF1ZHNK/ztZ2xauA6egQzMs48zlDqUnvcJ8N4ZxWtJdKHxVQA+58PCjlwfkmPWZAbKY3zvCyXMEUxNsBLQWkm0Vy8xJ0W186iFjvYOfZ19OA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e56ea51-0810-4319-1068-08d81c3e0dcd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2020 15:06:52.0956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hq2cE5by6XT3ztgpppxqr+d4CtaUQRrtrt0ZZX0P2LljaUlMQc5/HRV57TCvVaqF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4086
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-29_15:2020-06-29,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 spamscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006290103
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/28/20 10:55 PM, Song Liu wrote:
> The new test is similar to other bpf_iter tests. It dumps all
> /proc/<pid>/stack to a seq_file. Here is some example output:
> 
> pid:     2873 num_entries:        3
> [<0>] worker_thread+0xc6/0x380
> [<0>] kthread+0x135/0x150
> [<0>] ret_from_fork+0x22/0x30
> 
> pid:     2874 num_entries:        9
> [<0>] __bpf_get_stack+0x15e/0x250
> [<0>] bpf_prog_22a400774977bb30_dump_task_stack+0x4a/0xb3c
> [<0>] bpf_iter_run_prog+0x81/0x170
> [<0>] __task_seq_show+0x58/0x80
> [<0>] bpf_seq_read+0x1c3/0x3b0
> [<0>] vfs_read+0x9e/0x170
> [<0>] ksys_read+0xa7/0xe0
> [<0>] do_syscall_64+0x4c/0xa0
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Note: To print the output, it is necessary to modify the selftest.

I do not know what this sentence means. It seems confusing
and probably not needed.

> 
> Signed-off-by: Song Liu <songliubraving@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++++++
>   .../selftests/bpf/progs/bpf_iter_task_stack.c | 37 +++++++++++++++++++
>   2 files changed, 54 insertions(+)
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
> index 0000000000000..e40d32a2ed93d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
> @@ -0,0 +1,37 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +#include "bpf_iter.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
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
