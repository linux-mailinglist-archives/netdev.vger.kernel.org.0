Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD585205B45
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 20:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733248AbgFWS5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 14:57:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9898 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733138AbgFWS5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 14:57:51 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NIv2Bs027787;
        Tue, 23 Jun 2020 11:57:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=cSj6yhpCy8KJ+NENP8JLmd+8p0Ck96OOmnJwY0usylU=;
 b=cCflcYhWXeZYmP2etMlk4bU8FFjjkG8ymy3Qvy6aBy5bwQyAlElDkjeSDsLmRWuCQa/u
 FUVz/FwJcUJ7O5PzRPOy9xo1sN8kkCFBunjXLbdxSou+3XZ0eolU/1zWebxAA4GCOq4u
 2z+cyAx+AfZ457cOzP+8kUu1OytvGZpb8a4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk3chhw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 11:57:37 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 11:57:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HkEeSxo4SeZ76QYUD9V/rz6JAnQLkGQPAkVsF9vEfXzCD7Jvb8pSEa3mICpg/dDfLBxeZFqTBIIuWM6NMFaNhOjwsdZ87RiL2ZaTl8MhLQxCRLdd1FYtrrMu+MGTeFhRoelaxWJJ+1tYLOok7P3IXisqqen6qnX2cp5r22fzcgfYvTZh7bnYgE8WK5KUWPqOgB0tMQR7DPygGcWzeV873qlG2UgbSgn9wWcXRJqMcG6QmVMqFEtM3vSlq4aPlfoQF3UP08dd+YZpJ/BihvmCroNnCeBKsN5W2RRs5Bhn2C2yFsBzilUex4zEQOSjWyA6J7sE7YH+XVCZFS0aW3Ok3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSj6yhpCy8KJ+NENP8JLmd+8p0Ck96OOmnJwY0usylU=;
 b=G4UBnGDDfwPs0CNnNI/bHPb6XdmP7QrUj6ROWXtbKPCD+upwd5luRYc8WJw/d/iFT3oIvbKvXA1hO0FLigCCq4qKGRbyhpLap6rnLeGVI7ec3G/VBg3HNkdrkEzwAeNsoeHKHTpv+7z6ZDrjCVludwucaFhsG+QwyismI8KEJLhnxZzWq0O1nudKcU+WNBHoGCeg6B9ybr0/edxrZ8Xla6Y6UCI+TReZudMRMrsczM3ZkhmlfleRSAErtstsVsbKrJrgrpKPbbuSYfFfgKiArreAFxYMfbzaYJ00w+v5P/nfK4BaVYpeJjiW8Aoo+l/6gbBkf9P99WoIjrf3kdtcOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSj6yhpCy8KJ+NENP8JLmd+8p0Ck96OOmnJwY0usylU=;
 b=KbD6fSWesZzIrd3K23fKVzk9crlhJ/MpUXrICToeuwtrqeIeJyp5ASRTiP9X+xJmWo1BPZnikLhb9PFqd+oKq4mp+zQMnM//98h5PzAxHanGYWGhJ8bTqPGJxHV5qhjPPTpzyTZz2li7p/+BfuZM/lvM+WxcKC3no/OKJci8USE=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3192.namprd15.prod.outlook.com (2603:10b6:a03:10f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 18:57:34 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 18:57:34 +0000
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add bpf_iter test with
 bpf_get_task_stack_trace()
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>
References: <20200623070802.2310018-1-songliubraving@fb.com>
 <20200623070802.2310018-4-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <445e1e04-882f-7ff7-9bd4-ebcf679cebbb@fb.com>
Date:   Tue, 23 Jun 2020 11:57:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200623070802.2310018-4-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0002.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::15) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1377] (2620:10d:c090:400::5:7789) by BYAPR07CA0002.namprd07.prod.outlook.com (2603:10b6:a02:bc::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 23 Jun 2020 18:57:33 +0000
X-Originating-IP: [2620:10d:c090:400::5:7789]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad330c03-956a-4aae-f83b-08d817a74a18
X-MS-TrafficTypeDiagnostic: BYAPR15MB3192:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB319258C827AC3A4C80329E6ED3940@BYAPR15MB3192.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9JbavVdyubRWuY7w2dmmpnXRyrIOhE4WJ/lFezW1ti0oP9jfpglTVlwl5P3HoNhTBBaHe7S0sgY9Cqg/mTkkeEVQbgxSO2dA87PmwIHKWItfaxB+0/EU5auKZmkRVZHTtBIllvpwg5ZMVarye10eFbmziHH/yVrpn8f9KeGyVIRIQ0VJWK9kXT6QVJYhzHkqhOX0LtXSTKksxF1LTqSXlhAlhizvk5BF9ksA5ZByrG8j9N8d2qQ9g9eVJuBuFuLOAVaM79wHo3I0hZciJ+kmkALbQ/jC9+XY2guS6qFWxlKUJD/5U8NJwhoKTFg+RLsftFntWn4fdj4ltUU4aUA3Dmq3VC12eE6S3doYjhUsxzHj7nPnsYF16VguIjgOw5Vc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(186003)(31686004)(498600001)(16526019)(53546011)(52116002)(8936002)(2616005)(66946007)(5660300002)(2906002)(66556008)(66476007)(36756003)(6486002)(4326008)(86362001)(31696002)(83380400001)(8676002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: msJ+eooVJm24WTXwrOjWV1dyEkufkrUyGaEjd8s+tu36k8oMMqcHRR6Ct55ww1TWMR6byiA3xyR9oHIE7vMlGQTzH+d+yMy/whs9ZhdAejIiX1m60C/Rt0WcJYMG3ITA1UBX05Om/24qc889xbKr/ggpvn+DEx9GGBn97g2Xlwxh8ubt8TBE9I+yaKjH5TZXjSXjZftzqBbp30ZWBXxA+jV6r4Lp55Erp1OMGVP9UnWvX31dEvh29sqfQGqCs6E1RxmSlPRPFxd/8xuRmwYUys0JYxyZHmBU3+3nmOW92dn614Rq07jVMIRuatXD6cSIgdH93KvXke9lQhpOBU3DTm3kzY3cKm0GCtvT6TIUe9+SRhZ99Rnpcp6Yz609+VO2Q0PaTIbLnaI423P2875JAj/csOotvgFJ0nUwIiq1+4a2Q0j19fKBhIsiUuIPNd8t/B3pIGgj4s/v4ysqrvESClToTQa78I6KvaBO7FP4KwedGxBwsVD06MTLzakAO9rGabDBFdnD6Uaag1qXKoM/Lw==
X-MS-Exchange-CrossTenant-Network-Message-Id: ad330c03-956a-4aae-f83b-08d817a74a18
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 18:57:34.4691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TNgePXGA09336nPt9PysrmTOg3o9Aq7b7uKeuxt2cf8QiDgE89jMOFy/MaTVf6c2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3192
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_12:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230129
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/20 12:08 AM, Song Liu wrote:
> The new test is similar to other bpf_iter tests.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++++
>   .../selftests/bpf/progs/bpf_iter_task_stack.c | 50 +++++++++++++++++++
>   2 files changed, 67 insertions(+)
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
> index 0000000000000..4fc939e0fca77
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
> @@ -0,0 +1,50 @@
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
> +
> +#define MAX_STACK_TRACE_DEPTH   64
> +unsigned long entries[MAX_STACK_TRACE_DEPTH];
> +
> +SEC("iter/task")
> +int dump_task_stack(struct bpf_iter__task *ctx)
> +{
> +	struct seq_file *seq = ctx->meta->seq;
> +	struct task_struct *task = ctx->task;
> +	unsigned int i, num_entries;
> +
> +	if (task == (void *)0)
> +		return 0;
> +
> +	num_entries = bpf_get_task_stack_trace(task, entries, MAX_STACK_TRACE_DEPTH);
> +
> +	BPF_SEQ_PRINTF(seq, "pid: %8u\n", task->pid);
> +
> +	for (i = 0; i < MAX_STACK_TRACE_DEPTH; i++) {
> +		if (num_entries > i)
> +			BPF_SEQ_PRINTF(seq, "[<0>] %pB\n", (void *)entries[i]);

We may have an issue on 32bit issue.
On 32bit system, the following is called in the kernel
+	return stack_trace_save_tsk(task, (unsigned long *)entries, size, 0);
it will pack addresses at 4 byte increment.
But in BPF program, the reading is in 8 byte increment.

If "entries" are handled in user space, user space can just using "long 
*" pointer and will be able to correctly retrieve the stack addresses.

Maybe add some comments to clarify this prog only works for 64bit system.

> +	}
> +
> +	BPF_SEQ_PRINTF(seq, "\n");
> +
> +	return 0;
> +}
> 
