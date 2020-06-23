Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94F420673A
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387843AbgFWWjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:39:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28118 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387502AbgFWW2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:28:47 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05NMSVm8021324;
        Tue, 23 Jun 2020 15:28:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=GzuCRgiB6RtaXYo+388GEUac3KEnWDNEPss7oPWv4XQ=;
 b=Byp1T9gWyFe+zGRbzWEbTQz4vuuS3bgvRKqg8SV0eDv/7C4a+bUKtEifDmWCoYEMHxaY
 LPfgjYkk2HCattb2SBt4ouFw6LW6RXX7gClL5InXVmruSDPlKpIyRP2F7ux1Mr2Qoebx
 hM8B/zaw2m3er6YSprRsNdjceKq42PQy8Gc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 31uk102mav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 15:28:31 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 15:27:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHa1w9opjbHGJnDvT2QTbCXVKFt2zRJgCCbwqtBXYh/wz8fkXPY4Lw7BSq/5BJkt30mhqZj4hMDzxVtr4wzBd1HNJR+2Iq4Tpsru68Kt/2d/f0p1hcYr8wqKlak/qKMrY64P4yGa2N5YBmP5ld/mWC9i8Rb7to4UzIOTqXicifr1Gep1gD/jFTQLfW0Bg6YihKCDBIy8/a1fvokhfYKgRSHOwSEog0A1Jic2A948fEjdlYisWoB6OH4LAqAygmyG6MXsD5+XPk47zkrHCSZ3iG7ldg5yq5CzTyK71yizHtEeRdaH8U5X/04C9JO6dXs6oyHpYSHz2a8nx5Ey4Lw8LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzuCRgiB6RtaXYo+388GEUac3KEnWDNEPss7oPWv4XQ=;
 b=gDb/0D1ubKV8fQtDXPLa8RPC8j+3J7Ug2gY4+FXpiy/2FWWXXrG5eeFM7s2L0fePhYub245cNUs3GqI2ReeqwxXAzWiWJNrJYHIZDqmNJZ+d2z7afTd5EZR9hJorSikmukHmK4fQMEOsP5bM0lVvGNX35Q0YFZGmjyBzNCfzLgQY0ogvczYUGVK9GvPuYiDt94sv1PylBz5PFSfHlbVSLpwrdkd9WIHsQpeS8PpHDWBgDEaUeeck4+b+iy7qBmjqNOSUM4Ehp/CNRmaRVA90ryBqkMfFx68mlh14ZYDZgy7j9EioxLiVFwG+Xs88R+mUA/PPJJMiYtlnrDNqMyJgew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzuCRgiB6RtaXYo+388GEUac3KEnWDNEPss7oPWv4XQ=;
 b=KvFW7+r1LMntF0uy3ydCBTQ75aJ5PrEU6xEygWFHgx1dUJttohBbxQ0K/Fa+lu64WRdyQSuAPk7zEU+e+Id0d9tK9FFepWd1DzRRe19wvEOwRNJhf7G4pQ/Y0r1EUmhiHiuzhTyHGQ5/nEkjjEBtIQWGUHQb03wv1UUyhmMvHIk=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3303.namprd15.prod.outlook.com (2603:10b6:a03:10e::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Tue, 23 Jun
 2020 22:27:41 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 22:27:41 +0000
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
From:   Yonghong Song <yhs@fb.com>
Message-ID: <dda0849f-f106-18d9-b805-5fe1edb72e42@fb.com>
Date:   Tue, 23 Jun 2020 15:27:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <78BB08A3-D049-4795-8702-470C5841062C@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0060.namprd07.prod.outlook.com
 (2603:10b6:a03:60::37) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1926] (2620:10d:c090:400::5:d956) by BYAPR07CA0060.namprd07.prod.outlook.com (2603:10b6:a03:60::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 22:27:40 +0000
X-Originating-IP: [2620:10d:c090:400::5:d956]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5085bf0a-edfc-49a3-6def-08d817c4a42c
X-MS-TrafficTypeDiagnostic: BYAPR15MB3303:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB33030307C9619BBB50C91EFCD3940@BYAPR15MB3303.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CDYo7EZhPkhqOa+qKoQN2chpKjb2jPBcq+9ph9T5YKdsNarIeYRfDL14g8cJ6/YJatAGq7gwLnZDPU3M0SXgv8RxG4ZWbmQTZo/ZHaX4gqU/JK64qjZHOJL4kglOYBsg5CsVo6QnvPZeWTifaxxmeNkKiAG80i5PtKsQJSZMcIiH4boLWJcfQW53gKeiNW17sGNO5Fy9QZN3DxjTXdnXp4lDtfULgHojiaN3R4eKcyU66Qxq9qDf1P+0uEDf9X/b6KbxFyppX0LOOJ785XRlAJ5nfdAmWrvn02pKm5BLFPTaU37n9Ku42TXuZqgW5rQ4liHenpVtTyfHYf+D20g3OlO1NudC7+SVu1zJQxIjzb0T6HfJ+RqA/6vEyo9M4hjl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(396003)(346002)(366004)(39860400002)(478600001)(5660300002)(2906002)(66476007)(66946007)(6636002)(83380400001)(66556008)(8676002)(52116002)(6486002)(8936002)(31686004)(2616005)(36756003)(186003)(31696002)(16526019)(54906003)(53546011)(316002)(37006003)(4326008)(86362001)(6862004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: JIA2ebYc60kzelBjvD2ULPqm7WAp6FgsVAMQWGSLjLCaonhir2byXGLgCPhsRIVEhJO+KRzQDqsPuAaZ+eISoH9kKdmqoEBTi+qp84ys+cSIetDCgIQbvS8wbe8iBMsxe3JeR+RrztLVPcIwONTStI1x+m8uCUbP6UTahU5riLo10jMif5cd71Kzs9807u90t3yu/2vE+bo5Njzkq+ew9vDBp3EN/sFk+T2Mpt2FtRMsXQePhodcgrV7bVwTH7cJrCgrwZ+4wFgEdKyNcTmPBCIrtKy4LgXsTd2m9soR/dLRES4JfhjhdmBYvgXMOMKh6adCYzq6arMfQboz9KxD3BxvVTSiifKw/HxXWd8gs6nkex+bhCGYZyWhcZemNznC2b9ASRQLPw6AWDQwBxID2uAL0jrVBTzJIC4uMAuiNqKyc+tERf+wim14eQLhkIgyagjF9y8y97Us8BCdULqXegJOf7WBTNPCz60L5hN3Ta7gtDhh2xzed8Aqj30x/wc63YPX9VzNlJvFjs+gzMEEeg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5085bf0a-edfc-49a3-6def-08d817c4a42c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 22:27:41.0268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fai327TXV1yi2++rbb3OaJXGaBlo70YHW8lEalx4qdmeQLhf2OflHlYlilevR2ie
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3303
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_14:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230148
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/20 3:07 PM, Song Liu wrote:
> 
> 
>> On Jun 23, 2020, at 11:57 AM, Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 6/23/20 12:08 AM, Song Liu wrote:
>>> The new test is similar to other bpf_iter tests.
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>> ---
>>>   .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++++
>>>   .../selftests/bpf/progs/bpf_iter_task_stack.c | 50 +++++++++++++++++++
>>>   2 files changed, 67 insertions(+)
>>>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
>>> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>>> index 87c29dde1cf96..baa83328f810d 100644
>>> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>>> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>>> @@ -5,6 +5,7 @@
>>>   #include "bpf_iter_netlink.skel.h"
>>>   #include "bpf_iter_bpf_map.skel.h"
>>>   #include "bpf_iter_task.skel.h"
>>> +#include "bpf_iter_task_stack.skel.h"
>>>   #include "bpf_iter_task_file.skel.h"
>>>   #include "bpf_iter_test_kern1.skel.h"
>>>   #include "bpf_iter_test_kern2.skel.h"
>>> @@ -106,6 +107,20 @@ static void test_task(void)
>>>   	bpf_iter_task__destroy(skel);
>>>   }
>>>   +static void test_task_stack(void)
>>> +{
>>> +	struct bpf_iter_task_stack *skel;
>>> +
>>> +	skel = bpf_iter_task_stack__open_and_load();
>>> +	if (CHECK(!skel, "bpf_iter_task_stack__open_and_load",
>>> +		  "skeleton open_and_load failed\n"))
>>> +		return;
>>> +
>>> +	do_dummy_read(skel->progs.dump_task_stack);
>>> +
>>> +	bpf_iter_task_stack__destroy(skel);
>>> +}
>>> +
>>>   static void test_task_file(void)
>>>   {
>>>   	struct bpf_iter_task_file *skel;
>>> @@ -392,6 +407,8 @@ void test_bpf_iter(void)
>>>   		test_bpf_map();
>>>   	if (test__start_subtest("task"))
>>>   		test_task();
>>> +	if (test__start_subtest("task_stack"))
>>> +		test_task_stack();
>>>   	if (test__start_subtest("task_file"))
>>>   		test_task_file();
>>>   	if (test__start_subtest("anon"))
>>> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
>>> new file mode 100644
>>> index 0000000000000..4fc939e0fca77
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
>>> @@ -0,0 +1,50 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/* Copyright (c) 2020 Facebook */
>>> +/* "undefine" structs in vmlinux.h, because we "override" them below */
>>> +#define bpf_iter_meta bpf_iter_meta___not_used
>>> +#define bpf_iter__task bpf_iter__task___not_used
>>> +#include "vmlinux.h"
>>> +#undef bpf_iter_meta
>>> +#undef bpf_iter__task
>>> +#include <bpf/bpf_helpers.h>
>>> +#include <bpf/bpf_tracing.h>
>>> +
>>> +char _license[] SEC("license") = "GPL";
>>> +
>>> +struct bpf_iter_meta {
>>> +	struct seq_file *seq;
>>> +	__u64 session_id;
>>> +	__u64 seq_num;
>>> +} __attribute__((preserve_access_index));
>>> +
>>> +struct bpf_iter__task {
>>> +	struct bpf_iter_meta *meta;
>>> +	struct task_struct *task;
>>> +} __attribute__((preserve_access_index));
>>> +
>>> +#define MAX_STACK_TRACE_DEPTH   64
>>> +unsigned long entries[MAX_STACK_TRACE_DEPTH];
>>> +
>>> +SEC("iter/task")
>>> +int dump_task_stack(struct bpf_iter__task *ctx)
>>> +{
>>> +	struct seq_file *seq = ctx->meta->seq;
>>> +	struct task_struct *task = ctx->task;
>>> +	unsigned int i, num_entries;
>>> +
>>> +	if (task == (void *)0)
>>> +		return 0;
>>> +
>>> +	num_entries = bpf_get_task_stack_trace(task, entries, MAX_STACK_TRACE_DEPTH);
>>> +
>>> +	BPF_SEQ_PRINTF(seq, "pid: %8u\n", task->pid);
>>> +
>>> +	for (i = 0; i < MAX_STACK_TRACE_DEPTH; i++) {
>>> +		if (num_entries > i)
>>> +			BPF_SEQ_PRINTF(seq, "[<0>] %pB\n", (void *)entries[i]);
>>
>> We may have an issue on 32bit issue.
>> On 32bit system, the following is called in the kernel
>> +	return stack_trace_save_tsk(task, (unsigned long *)entries, size, 0);
>> it will pack addresses at 4 byte increment.
>> But in BPF program, the reading is in 8 byte increment.
> 
> Can we avoid potential issues by requiring size % 8 == 0? Or maybe round down
> size to closest multiple of 8?

This is what I mean:
   for bpf program: "long" means u64, so we allocate 64 * 8 buffer size
                    and pass it to the helper
   in the helper, the address will be increased along sizeof(long), which
                  is 4 for 32bit system.
           So address is recorded at buf, buf + 4, buf + 8, buf + 12, ...
   After the helper returns, the bpf program tries to retrieve
           the address at buf, buf + 8, buf + 16.

The helper itself is okay. But BPF_SEQ_PRINTF above is wrong.
Is this interpretation correct?

> 
> Thanks,
> Song
> 
