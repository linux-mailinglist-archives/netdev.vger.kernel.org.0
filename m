Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CBA20B551
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 17:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbgFZPwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 11:52:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49772 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728355AbgFZPwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 11:52:43 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QFikoM013694;
        Fri, 26 Jun 2020 08:52:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=TGEl7x+TOM9e2eiKEws6LM0qO0HZLP/ODGP310QrSJE=;
 b=nhM01INBmuDqzfg4UqN6egwcX/7nNstLXTxEIJrp32nRhcW+rFzdl97bsxgPQkdOkGmL
 IRumK19u43mYVMZUtVRN1CzXZe2/FyzEB6TTf59elmgbptNrdDl3cD9ju8sf1NCFJ/KR
 f6YYMvrx3nGIJLZMQCyAoC71Ip2oh/0LTfg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux1ex10t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 08:52:29 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 08:52:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/moT68ZBkuDQtwOVaTJri0NilkjaxQ9rCY0Cc0GqRZelo1lAYmIzQMVSqPcDLvjdfMxtFO1847X4QuBS1k2mzvOIdVsAGUPdqVOizWwOwV9tmPRGVbgFWUCH75EARWYUP+fn1QNBLxy/8/HdJ2m6uAV+PleCi1NsqkJYdF24QRR3pTCM2UPX5iFSHoziGSM5aW1XNbnANcoQ01yumw0FfM5lvahPxJEuSLWw+gD+Ndrelnbt45BPTXRCkpDzMrOMRLlJcD+mTW9KuzPz95dkRiPuJcipy8J7lZeLVaJOllvs7B1W833sng9zxfm0/rv6ngvpZjIXWjSqQ7T5zioMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGEl7x+TOM9e2eiKEws6LM0qO0HZLP/ODGP310QrSJE=;
 b=V/HKP/beRYAaUFn+cnbTTZo4YTx+4E3rkhtuMdG7Rl7IuMDoS8OeThe+NgaVJk3RlbvScwSOT04jmfAw0GVnT1cw0rGlCmF01pLYraFtWZPeg4zCu6etRUmqaWXLG/i5Wr6aqnW7eTlK3LE+WnJmhcZ802ZtWXOyc1FwyMpEDNBNz9msG9zuIA9SO5Vb5VOMQ7tNtr0iH6OMilM69ilXZUponwBEY2kFCtai5lTZXDkzLPvdadYAKG8oDB8kc089vbPGTWE4LSVc4RfWk6AjOQugmM15JSc29OSf2G6v/vm9F/Zly8pZ00QB9qJ4zqOfuldoYqcvo9NVgKYQe1Zugw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGEl7x+TOM9e2eiKEws6LM0qO0HZLP/ODGP310QrSJE=;
 b=cW+Odew8a9Nz5ehQIPHmX4TmrtUiaVSkgxzyScf2gX0gwxL7tLIAt0MkPEr60knoBbo4SKOO/Hvfef1zSn3BI1dN7qTDPyUv/ds73HWsE70Q2+p9WVJOFjPzuiunx8rvPkWOvdQX1tt4TJJwaKMMRMeL9Na905cD0heb9XbU0tY=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2648.namprd15.prod.outlook.com (2603:10b6:a03:150::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Fri, 26 Jun
 2020 15:52:26 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.033; Fri, 26 Jun 2020
 15:52:26 +0000
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: add bpf_iter test with
 bpf_get_task_stack()
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>
References: <20200626001332.1554603-1-songliubraving@fb.com>
 <20200626001332.1554603-5-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d4f43b4b-af99-1a80-7eb7-5c7e892db1bb@fb.com>
Date:   Fri, 26 Jun 2020 08:52:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200626001332.1554603-5-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:40::17) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::18ce] (2620:10d:c090:400::5:ca25) by BYAPR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:40::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Fri, 26 Jun 2020 15:52:25 +0000
X-Originating-IP: [2620:10d:c090:400::5:ca25]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6790718-bc45-445e-941f-08d819e8ec84
X-MS-TrafficTypeDiagnostic: BYAPR15MB2648:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB264866DE73165A26ED9160B5D3930@BYAPR15MB2648.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:660;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7R+4WbugizcflIgq5FqlE8+P+nXe3xtNYX4QOwxO42R2kcG3dfmW03naj5G1SQDqLLRr/jcBrmmpgEvgZ+THAfAjH5h1nsom7WvcxJCMXdfYotI+iePosBjeobLHPMHhVRNkMVW9sp7bQh8S+WC50SfcQhOoxIc3Z4HmDxVShPxqUbaMiZDEq7injOkDGp/PhnnsZxoVEo/ocwBfLl6ODjbSzthkp0KQ8lQcXJp1iwYx+R/zWBdIQmxofQU63Hh7UIRXx2Hpmcr94smq1RqREDFXw8xZ16F0iDYIMqqviVvWPsWbIh7iEjxmgqi52SKzzVSL9yW5XSYDIP3sYX4IeouTRamH+Xd3Cwx+WHMtbaLy4Q5ORTUbZnZ/q0IqLn9J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(376002)(136003)(366004)(346002)(31696002)(31686004)(5660300002)(186003)(16526019)(6486002)(316002)(36756003)(2616005)(83380400001)(8676002)(8936002)(4326008)(478600001)(2906002)(66476007)(66946007)(52116002)(86362001)(66556008)(53546011)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: lKnKW8mZ0uMjwyy0+3EWXbWZ8R4AQxsU3GLdFo6qthSFNHwu2bVnvPae8zmK6SkIh2pngP/9VE6VIcCMvMSoElaIZKBNpb1J/7BwkOdTuk6nv8b2g+ifOURPLyDUGjQP3Pf0G8b9gtG1230d1xNwvcBBU/0w6Un2XIJ9FBjih9yU88IATHiwaeWh1x86n79Cvp/3qSLd3dt0KrfymVJpAusCeGWdBEvEa46y3Xi6oqJzEn/goQcZnj/p6jfr2JI+lXnIO78yfQ/kF50BwMDQNaB5cKYPTBJP0Fp774uJMlAIyG2udMPDdgnbcFVUiooFpfl/P1FU/5ActHUo2zq+mL4S/uhkTFmlPk+3cvy0oblnUqgochGyEOeHzDhgcsspykWPgGCaB62HAsFvFsBZlYs5kPibkcSyfPe4zyWL67sS+4mPvgYlIhR05wCarokEvneJoUGMLYLhpOoF54EvkPV0dHnwOdy2BjsF4U8OTqcIVU2RRsdxHiUbAe7foR9NkQyes9F7weLDTkkdFJuxGg==
X-MS-Exchange-CrossTenant-Network-Message-Id: c6790718-bc45-445e-941f-08d819e8ec84
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 15:52:26.5762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXil0IE9pcUEJ86y9UDIXa+JcfRZUeqILLb/vE9n1MuUYJ1+gBYEP84EbILNGCr4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2648
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_08:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 cotscore=-2147483648 spamscore=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260110
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/20 5:13 PM, Song Liu wrote:
> The new test is similar to other bpf_iter tests.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   .../selftests/bpf/prog_tests/bpf_iter.c       | 17 ++++++
>   .../selftests/bpf/progs/bpf_iter_task_stack.c | 60 +++++++++++++++++++
>   2 files changed, 77 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> index 87c29dde1cf96..baa83328f810d 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> @@ -5,6 +5,7 @@
>   #include "bpf_iter_netlink.skel.h"
>   #include "bpf_iter_bpf_map.skel.h"
>   #include "bpf_iter_task.skel.h"
> +#include "bpf_iter_task_stack.skel.h"
>   #include "bpf_iter_task_file.skel.h"
>   #include "bpf_iter_test_kern1.skel.h"
>   #include "bpf_iter_test_kern2.skel.h"
> @@ -106,6 +107,20 @@ static void test_task(void)
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
> @@ -392,6 +407,8 @@ void test_bpf_iter(void)
>   		test_bpf_map();
>   	if (test__start_subtest("task"))
>   		test_task();
> +	if (test__start_subtest("task_stack"))
> +		test_task_stack();
>   	if (test__start_subtest("task_file"))
>   		test_task_file();
>   	if (test__start_subtest("anon"))
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
> new file mode 100644
> index 0000000000000..83aca5b1a7965
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
> @@ -0,0 +1,60 @@
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

Could you rebase on top of latest bpf-next?
A new header bpf_iter.h is introduced and it will
make code simpler.

> +
> +char _license[] SEC("license") = "GPL";
> +
> +/* bpf_get_task_stack needs a stackmap to work */
> +struct {
> +	__uint(type, BPF_MAP_TYPE_STACK_TRACE);
> +	__uint(max_entries, 16384);
> +	__uint(key_size, sizeof(__u32));
> +	__uint(value_size, sizeof(__u64) * 20);
> +} stackmap SEC(".maps");
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
> +
> +#define MAX_STACK_TRACE_DEPTH   64
> +unsigned long entries[MAX_STACK_TRACE_DEPTH];
> +
> +SEC("iter/task")
> +int dump_task_stack(struct bpf_iter__task *ctx)
> +{
> +	struct seq_file *seq = ctx->meta->seq;
> +	struct task_struct *task = ctx->task;
> +	int i, retlen;

long retlen after rebase?

> +
> +	if (task == (void *)0)
> +		return 0;
> +
> +	retlen = bpf_get_task_stack(task, entries,
> +				    MAX_STACK_TRACE_DEPTH * sizeof(unsigned long), 0);
> +	if (retlen < 0) > +		return 0;
> +
> +	BPF_SEQ_PRINTF(seq, "pid: %8u num_entries: %8u\n", task->pid,
> +		       retlen / sizeof(unsigned long));

sizeof(unsigned long) is used a few times. It is worthwhile to
have a variable for it.

> +	for (i = 0; i < MAX_STACK_TRACE_DEPTH / sizeof(unsigned long); i++) {
> +		if (retlen > i * sizeof(unsigned long))
> +			BPF_SEQ_PRINTF(seq, "[<0>] %pB\n", (void *)entries[i]);
> +	}
> +	BPF_SEQ_PRINTF(seq, "\n");
> +
> +	return 0;
> +}
> 
