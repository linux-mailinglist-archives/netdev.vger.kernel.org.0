Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E3A20997E
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 07:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389857AbgFYF34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 01:29:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56904 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389705AbgFYF3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 01:29:55 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05P5L45P006951;
        Wed, 24 Jun 2020 22:29:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=BxLsNjZZG6vd1Fr66AyoCdiMJqAWkAq9WWEySMPu7LI=;
 b=UP7kyOvXiI+o/U8eYVaVgmbWF1ZiT3q1dOIxdv/Px4V6glNUud/LZEtZbvDLDJxsRaO2
 L2QwluzLoTJsC1s5QN+fj4TDKqvVjec20oWMFrEVVTc6l4UdO9PNMc2bDVrcIXPCh66e
 q0GPzkhKLV0PwJJQKHPwJU8NXKBXemeWCT8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 31ux0np1tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 24 Jun 2020 22:29:40 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Jun 2020 22:29:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGjTc6ITYoNA+3ZqsStv9sjVKWgncVUBQEL44301lr2kEqNBqn50VGphwlB+H1QgcTZdzZ7jIOY0aJgKmP+EjHIsWAHpwxLwBBJEo6MCQKu31QqoJTkIL7RLuyAuZ1zzMCdEMSvdWJKHAmHnLCQMZAnOaW834GdEhVcQqVbOpB+MsvkHmxaXaosdFc8UtxMbQYQ6xNTXv7I2Vrbpj6UJVTnwfYdX6AFPzxUryOJCBf1aFubX6EHvz6D+0K6I6Hq8TtPPCxucY4vMsy8F1bCOUkzcPPGtLa7BlN4JpWtZT2HJrQXmlOR689a0v8XZl6VUb7mMkg2ok5R6a3G00/g4PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BxLsNjZZG6vd1Fr66AyoCdiMJqAWkAq9WWEySMPu7LI=;
 b=cpdYr3AWb59FsIqP4S3vrbkPA6m89fo7bezkiaXE0pi1Cdf1IZozhz4TLS1+RPKbeutyuVnR2uDs0vfite0HxUZSydVqUCxEE7qgg0SxE4H4PnoD+FE17i0uP0yvtdehh6IRkGMJ2/EcnqEaiCggUKcx/Gn9zEb2cftppoZOR/B+Pg8xb2zCtwv3jcb2Vkbgw9oTCyl+JsyYC1IfIXK1JlcZEyewi9Ire5RaBwVKh4QwHR2jcaTu9QGtqG7lvpgreKpjgFlZxbryz67ZHQZlpcVtu528fOppBw2npXOKRT4TSV9A+0f9B++uaBHvrrGEKgpIFjnWu7o4s5KPzpUheQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BxLsNjZZG6vd1Fr66AyoCdiMJqAWkAq9WWEySMPu7LI=;
 b=aavSx7UJ0jTSLz12BZljAdQ0CV2gz/0+G5gZ/3CCQyCXVIBrJ1ArcA8zx5TU+tAKCxbLyPLNxuGaT72OtUZQdbGuLVfbG1/4FYLu03IuTL74VEzZL2eVEYijNyIGOJYleNCJLEl3VdRq6/5lAFU8Qfs6TrLmDq+6Pj1RDjFY99s=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4117.namprd15.prod.outlook.com (2603:10b6:a02:c1::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Thu, 25 Jun
 2020 05:29:38 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.027; Thu, 25 Jun 2020
 05:29:38 +0000
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add bpf_iter test with
 bpf_get_task_stack_trace()
To:     Song Liu <songliubraving@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
References: <20200623070802.2310018-1-songliubraving@fb.com>
 <20200623070802.2310018-4-songliubraving@fb.com>
 <445e1e04-882f-7ff7-9bd4-ebcf679cebbb@fb.com>
 <78BB08A3-D049-4795-8702-470C5841062C@fb.com>
 <dda0849f-f106-18d9-b805-5fe1edb72e42@fb.com>
 <03A78005-BDCD-4A90-BD27-724DA6056D9B@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4644728a-4d0d-a5a7-e008-d8c3d7289397@fb.com>
Date:   Wed, 24 Jun 2020 22:29:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <03A78005-BDCD-4A90-BD27-724DA6056D9B@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0027.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::40) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::196b] (2620:10d:c090:400::5:43f0) by BY5PR20CA0027.namprd20.prod.outlook.com (2603:10b6:a03:1f4::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Thu, 25 Jun 2020 05:29:37 +0000
X-Originating-IP: [2620:10d:c090:400::5:43f0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da738175-62c4-4659-4203-08d818c8c0fc
X-MS-TrafficTypeDiagnostic: BYAPR15MB4117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB411700FEA6B01401A599D766D3920@BYAPR15MB4117.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0445A82F82
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vn8ZqSWjc5vjxBFERZM4T1mUMQqpQwVtdvOILK55paa2H+96QgT1Z1MZqmciQs2C5NYuASESuE1G/KJBzGEwAQOkwC3BA55kea9ugvIVOupd5L6lZvpoEZZMlXUGVwFqigy7WVwoyHi1wt6ariTs8XCsDJxteDYXuvMGz6kOgVL3wq57q43Gf1yDrOYvTGSoYfvUbyL4u94wkxlM12Y+Yfmw3Bwh3sYOji0nL30V7p3BlryPrBpQ3z8KmJc5cky91129ukqrJ0aNeZELd8nfNVh9Zsv+su5u8Lzep0nAGuJC+oAT3W7qvzy8ikFgM7/6y379lLEOi4vGf90bY2GwjhNqHGeWCOCX8A/bRx/CUXPCvmBfstUpBlualH2APbBs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(136003)(376002)(366004)(346002)(53546011)(5660300002)(478600001)(66946007)(31686004)(6486002)(4326008)(316002)(186003)(37006003)(54906003)(16526019)(2616005)(52116002)(2906002)(6636002)(83380400001)(66556008)(66476007)(86362001)(8936002)(31696002)(36756003)(8676002)(6862004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: y8KwRak4tP4ehjyOgVl3l5nWjlUw2BppMRBm5VPhtSNXLHzmfmLp824Qxy3SpOzxiGQQEveSm8nzkALuDgWNVWaEl0hjUAHU/gI2zihSVQC8N5GeRLvAcLFXJb5RttuvLWdFam1sVxjeDs4oKNqLB04Jx/z20iN68zPvKRpeMOsW1/eyIkBSu9oIXdp3habxeC45APQK7mq2W1NgYFtP/8u2qvInyxbiNU1SO5dqMVzlIsNIAhKZiyzqjV5/cOjY0PiGPZNgqtwHdDgNQo6dpqm3CBSx/4U73TlLsggnhKbyCm3VzMixH/3bDGDNZiTuZwkUIlV4kzTF7gj0cWOyuBBHZM3JHwmZ86+GP7FgPkQMQnhCgNanXyIJH2Bpbkc+M5ppwYtenOM17pOnvVBmOY3FXhtJZrUWy3ArqiEe3TzJZpDMWTy5Sz2KyLf6S3YJFuSXxto3tRLP58tZ6/Kpl/qhRwMBSE1jAHedZubnT80S5mN2Ra2rqHkO0m1FJS+Iy65WtSIswOokgsdzJIv+MQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: da738175-62c4-4659-4203-08d818c8c0fc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2020 05:29:38.4907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pGow6hB84Lv3b9GP64FI+dnL9SOzM1iRzkJt3339IyUhELXr54AoXpiY/kSNd0f+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4117
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_02:2020-06-24,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 cotscore=-2147483648 spamscore=0 suspectscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 malwarescore=0 phishscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250030
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/20 1:37 PM, Song Liu wrote:
> 
> 
>> On Jun 23, 2020, at 3:27 PM, Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 6/23/20 3:07 PM, Song Liu wrote:
>>>> On Jun 23, 2020, at 11:57 AM, Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>>
>>>>
>>>> On 6/23/20 12:08 AM, Song Liu wrote:
>>>>> The new test is similar to other bpf_iter tests.
>>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>>> ---
>>>>>   .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++++
>>>>>   .../selftests/bpf/progs/bpf_iter_task_stack.c | 50 +++++++++++++++++++
>>>>>   2 files changed, 67 insertions(+)
>>>>>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
>>>>> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>>>>> index 87c29dde1cf96..baa83328f810d 100644
>>>>> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>>>>> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>>>>> @@ -5,6 +5,7 @@
>>>>>   #include "bpf_iter_netlink.skel.h"
>>>>>   #include "bpf_iter_bpf_map.skel.h"
>>>>>   #include "bpf_iter_task.skel.h"
>>>>> +#include "bpf_iter_task_stack.skel.h"
>>>>>   #include "bpf_iter_task_file.skel.h"
>>>>>   #include "bpf_iter_test_kern1.skel.h"
>>>>>   #include "bpf_iter_test_kern2.skel.h"
>>>>> @@ -106,6 +107,20 @@ static void test_task(void)
>>>>>   	bpf_iter_task__destroy(skel);
>>>>>   }
>>>>>   +static void test_task_stack(void)
>>>>> +{
>>>>> +	struct bpf_iter_task_stack *skel;
>>>>> +
>>>>> +	skel = bpf_iter_task_stack__open_and_load();
>>>>> +	if (CHECK(!skel, "bpf_iter_task_stack__open_and_load",
>>>>> +		  "skeleton open_and_load failed\n"))
>>>>> +		return;
>>>>> +
>>>>> +	do_dummy_read(skel->progs.dump_task_stack);
>>>>> +
>>>>> +	bpf_iter_task_stack__destroy(skel);
>>>>> +}
>>>>> +
>>>>>   static void test_task_file(void)
>>>>>   {
>>>>>   	struct bpf_iter_task_file *skel;
>>>>> @@ -392,6 +407,8 @@ void test_bpf_iter(void)
>>>>>   		test_bpf_map();
>>>>>   	if (test__start_subtest("task"))
>>>>>   		test_task();
>>>>> +	if (test__start_subtest("task_stack"))
>>>>> +		test_task_stack();
>>>>>   	if (test__start_subtest("task_file"))
>>>>>   		test_task_file();
>>>>>   	if (test__start_subtest("anon"))
>>>>> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
>>>>> new file mode 100644
>>>>> index 0000000000000..4fc939e0fca77
>>>>> --- /dev/null
>>>>> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
>>>>> @@ -0,0 +1,50 @@
>>>>> +// SPDX-License-Identifier: GPL-2.0
>>>>> +/* Copyright (c) 2020 Facebook */
>>>>> +/* "undefine" structs in vmlinux.h, because we "override" them below */
>>>>> +#define bpf_iter_meta bpf_iter_meta___not_used
>>>>> +#define bpf_iter__task bpf_iter__task___not_used
>>>>> +#include "vmlinux.h"
>>>>> +#undef bpf_iter_meta
>>>>> +#undef bpf_iter__task
>>>>> +#include <bpf/bpf_helpers.h>
>>>>> +#include <bpf/bpf_tracing.h>
>>>>> +
>>>>> +char _license[] SEC("license") = "GPL";
>>>>> +
>>>>> +struct bpf_iter_meta {
>>>>> +	struct seq_file *seq;
>>>>> +	__u64 session_id;
>>>>> +	__u64 seq_num;
>>>>> +} __attribute__((preserve_access_index));
>>>>> +
>>>>> +struct bpf_iter__task {
>>>>> +	struct bpf_iter_meta *meta;
>>>>> +	struct task_struct *task;
>>>>> +} __attribute__((preserve_access_index));
>>>>> +
>>>>> +#define MAX_STACK_TRACE_DEPTH   64
>>>>> +unsigned long entries[MAX_STACK_TRACE_DEPTH];
>>>>> +
>>>>> +SEC("iter/task")
>>>>> +int dump_task_stack(struct bpf_iter__task *ctx)
>>>>> +{
>>>>> +	struct seq_file *seq = ctx->meta->seq;
>>>>> +	struct task_struct *task = ctx->task;
>>>>> +	unsigned int i, num_entries;
>>>>> +
>>>>> +	if (task == (void *)0)
>>>>> +		return 0;
>>>>> +
>>>>> +	num_entries = bpf_get_task_stack_trace(task, entries, MAX_STACK_TRACE_DEPTH);
>>>>> +
>>>>> +	BPF_SEQ_PRINTF(seq, "pid: %8u\n", task->pid);
>>>>> +
>>>>> +	for (i = 0; i < MAX_STACK_TRACE_DEPTH; i++) {
>>>>> +		if (num_entries > i)
>>>>> +			BPF_SEQ_PRINTF(seq, "[<0>] %pB\n", (void *)entries[i]);
>>>>
>>>> We may have an issue on 32bit issue.
>>>> On 32bit system, the following is called in the kernel
>>>> +	return stack_trace_save_tsk(task, (unsigned long *)entries, size, 0);
>>>> it will pack addresses at 4 byte increment.
>>>> But in BPF program, the reading is in 8 byte increment.
>>> Can we avoid potential issues by requiring size % 8 == 0? Or maybe round down
>>> size to closest multiple of 8?
>>
>> This is what I mean:
>>   for bpf program: "long" means u64, so we allocate 64 * 8 buffer size
>>                    and pass it to the helper
>>   in the helper, the address will be increased along sizeof(long), which
>>                  is 4 for 32bit system.
>>           So address is recorded at buf, buf + 4, buf + 8, buf + 12, ...
>>   After the helper returns, the bpf program tries to retrieve
>>           the address at buf, buf + 8, buf + 16.
>>
>> The helper itself is okay. But BPF_SEQ_PRINTF above is wrong.
>> Is this interpretation correct?
> 
> Thanks for the clarification. I guess the best solution is to fix this
> once in the kernel, so BPF programs don't have to worry about it.

The kernel could make each entry 8 bytes. This will cause less potential
entries for 32bit, probably fine. Another option is BPF program declares 
an extern variable CONFIG_64BIT and it is 'y', that means 64 bit. 
Otherwise it is 32bit. libbpf should set CONFIG_64BIT correctly.

I guess storing each address as 64bit probably a better and less
confusion choice.

> 
> Song
> 
