Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA561DD5EA
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 20:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgEUSXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 14:23:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61344 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728240AbgEUSXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 14:23:49 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04LIN568014689;
        Thu, 21 May 2020 11:23:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/w0CTZZFFseO1yFqqy8x8RnNGJzO4XeRappb+bkCovQ=;
 b=a+hEBKZuJFnbkZN6c/PZcAjebZTIlsMoe/KJVihpd4XCemu6B4tp09a/7A3IfbJZU0wG
 im0/1kj4HFQMTjJ916i63QOfKzlNzUtX1e9rcv0V9nkdyO69rwVQrnc/8uRMQSHqlJ02
 8qaHRs8HK0o4Bj7IlZG0YQNUuEz7zgaC9DQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 315bt2htwb-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 May 2020 11:23:33 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 21 May 2020 11:23:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dh4+jNWCu9lDtmVkUwMvLQ1aJk4RDRxrK2r6j4LL9fYcoRWw5LjnACroz+s/jZlovY4H5tr/mLPO5utgUrWjO9Ss//aIB5x+meCSqPLmQ36CIf6o2MGjnA8pYq24m3m0+v/bNkr9iYQrwoY1SyqOqU9RzFqrKGBupz9hFF1rfT+xxlI2UkyKtlBgwSbBZ5xeEjFFLCZEJgHBLxT/RWNIGwtVahGQ1xEeIj37h+H/xgc8XqMZZx1N5OksBilv0i0g1QAYBIc8XfsQfGk8vZzO3nBaLWOjugdHVuqG54ZwN1odqShdLof19wrAXQwbTsyoHByrZoGCPtNBUY7wAJeBog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/w0CTZZFFseO1yFqqy8x8RnNGJzO4XeRappb+bkCovQ=;
 b=LvZs2zrqljUCd1JqJVszlgdqthxyMcTe92MLBD9oVSFwgwZkdezjIPGTpYn+GwIloBNRsKJNkVZqvnoCSNma7ChpXYbSXxZZa/T+ZhjI9BcL7fbRBQCKibQGnScQk5a3mOX5QR0QP5+9tsUezH0P8WylhFjC8yQK727n6jIlXSI7R6X7FH3a4Z/1LPMgdmXOqXZAXeuRLcLRCP7Ti/l+3CZXLKkZmZd5dXb/NempPP4uObcCfVRPU6nXO0BHp6VdtptbxZ6xV4imfrI25WvUNMg9xYdjIz6t4gKFxdH0d1JBNe5Dg93cH60vLZMfFzGUyE0YnzRg1fp+gqd99DqwSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/w0CTZZFFseO1yFqqy8x8RnNGJzO4XeRappb+bkCovQ=;
 b=aaBC8G4pKUhgro3GcAKwutuPJPstDERKsNJkkjsbrJTJ3l4tmT+jqXBJeXYI0YT3wdiDjdyV10BGPX4pcWK65/Wd61mA/e3HHIPIZa7JR7M//sBdXQHsOQ/CNqkuhOdWhuGFnyPEOFK78OAWmtBmVw/f7P1116Yb8rYSukGrDPE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2791.namprd15.prod.outlook.com (2603:10b6:a03:154::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Thu, 21 May
 2020 18:23:31 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3021.024; Thu, 21 May 2020
 18:23:31 +0000
Subject: Re: [bpf-next PATCH v3 4/5] bpf: selftests, add sk_msg helpers load
 and attach test
To:     John Fastabend <john.fastabend@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>
CC:     <lmb@cloudflare.com>, <bpf@vger.kernel.org>,
        <jakub@cloudflare.com>, <netdev@vger.kernel.org>
References: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
 <159007175735.10695.9639519610473734809.stgit@john-Precision-5820-Tower>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <16a158b4-5e85-8ad3-3389-7687add809d1@fb.com>
Date:   Thu, 21 May 2020 11:23:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <159007175735.10695.9639519610473734809.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:a03:217::28) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:741b) by BY3PR04CA0023.namprd04.prod.outlook.com (2603:10b6:a03:217::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Thu, 21 May 2020 18:23:30 +0000
X-Originating-IP: [2620:10d:c090:400::5:741b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae5564b9-cecb-45d9-52ca-08d7fdb4107f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2791:
X-Microsoft-Antispam-PRVS: <BYAPR15MB279125E483D7E58A9F7BCCECD3B70@BYAPR15MB2791.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:489;
X-Forefront-PRVS: 041032FF37
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D6vD7zHVJgIQs8Nij6wO4k5JYo27210eUoA2HjMi5ytYOYaSoW6mrjTEoI8n/nlVkWQDS7gWjmZlNK6yCjFzg/74pkn/K4doNKH+rask3TlzbdZT+RgMYFWVUDgYAKZGY9cviWMCjw9oKZA4svzHmX6gVOldlXuN2tm/atAFzPzJ8aR2LWsk2ouByRpLgK+ty8HC0gzx/xHw3MqvQOVgyudz63CDeASECTHiaIe56ZReJqk8RUi/KLqFr+rfcQl57Gl8/qaknLrlmW+DPPKWx1gz5TwKj6BNZ9cK967k9S3m+YIzQIBi0zcHV7ajzZxk3q/I+mzKVyCdjXlWFqCmJVvyggqsx9JP00zAhJ1YdT7j+QAe4a0/1SPKrVol+Qjv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(52116002)(6486002)(86362001)(66556008)(66946007)(31686004)(8676002)(6506007)(16526019)(6666004)(186003)(316002)(8936002)(6512007)(36756003)(4326008)(2906002)(2616005)(53546011)(478600001)(31696002)(5660300002)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: J5Pk7ZJf8tmLqG4WmeI+g/xmkC0uNyXO6pEBNtnVz2jo6ekTatsngNfeLH1D3Qn6IC+HFOXY8XvxNkCK0UmWcT6nCdOi3fS964y57kUlvxvcTqj75YQ0BK3jcAexdL9Vjz60q7fyjPRWYxYFUB9gZIp0L6q6qjnYQ4FDUYLYu6gN+8d/k9cfP1sbdA+QXA8rLYoo4GlMVekcWEflFXh2grdNUM9xBLPTP6M21+5NbBM3IT/zlPtsw9CbQRNKP6mnjRLUwUeGkhxBHvyK62aEM0RF7mUuKAF/hfuPaTFF+5uHGklAcPwAxW9GDDXmbn9LojmDSjbDbqhhwSbDR1SZ+KHPRhXyEbPyf8RMWkfYF8QSazeZmU0Lx3pSGT3Fhahh+aUtqZM9IWqEZCQvs3UImtSiXPjK8kXVv9utlczhHAdjnHyLGpgtm0oNc4u7+OcMoe5RRTBTx9OsSIfQec663fiDVEwMI3AG8Y7FXCRB9Pew6GyN7jPCGsqnFrPgoJ4QJSUzAKFuCp63xDvITm5ArQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: ae5564b9-cecb-45d9-52ca-08d7fdb4107f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2020 18:23:31.1903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HvJUbnekkAY0+oaXFdFRCXduPTO6DFVBWRgc6XZuoKA2UXKmaNs3Hzrg1BbEr9E9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2791
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-21_12:2020-05-21,2020-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 cotscore=-2147483648 phishscore=0
 priorityscore=1501 suspectscore=2 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/21/20 7:35 AM, John Fastabend wrote:
> The test itself is not particularly useful but it encodes a common
> pattern we have.
> 
> Namely do a sk storage lookup then depending on data here decide if
> we need to do more work or alternatively allow packet to PASS. Then
> if we need to do more work consult task_struct for more information
> about the running task. Finally based on this additional information
> drop or pass the data. In this case the suspicious check is not so
> realisitic but it encodes the general pattern and uses the helpers
> so we test the workflow.
> 
> This is a load test to ensure verifier correctly handles this case.
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>   .../selftests/bpf/prog_tests/sockmap_basic.c       |   57 ++++++++++++++++++++
>   .../selftests/bpf/progs/test_skmsg_load_helpers.c  |   48 +++++++++++++++++
>   2 files changed, 105 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> index aa43e0b..cacb4ad 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> @@ -1,13 +1,46 @@
>   // SPDX-License-Identifier: GPL-2.0
>   // Copyright (c) 2020 Cloudflare
> +#include <error.h>
>   
>   #include "test_progs.h"
> +#include "test_skmsg_load_helpers.skel.h"
>   
>   #define TCP_REPAIR		19	/* TCP sock is under repair right now */
>   
>   #define TCP_REPAIR_ON		1
>   #define TCP_REPAIR_OFF_NO_WP	-1	/* Turn off without window probes */
>   
> +#define _FAIL(errnum, fmt...)                                                  \
> +	({                                                                     \
> +		error_at_line(0, (errnum), __func__, __LINE__, fmt);           \
> +		CHECK_FAIL(true);                                              \
> +	})
> +#define FAIL(fmt...) _FAIL(0, fmt)
> +#define FAIL_ERRNO(fmt...) _FAIL(errno, fmt)
> +#define FAIL_LIBBPF(err, msg)                                                  \
> +	({                                                                     \
> +		char __buf[MAX_STRERR_LEN];                                    \
> +		libbpf_strerror((err), __buf, sizeof(__buf));                  \
> +		FAIL("%s: %s", (msg), __buf);                                  \
> +	})

Can we use existing macros in test_progs.h?
This will be consistent with other test_progs selftests.

> +
> +#define xbpf_prog_attach(prog, target, type, flags)                            \
> +	({                                                                     \
> +		int __ret =                                                    \
> +			bpf_prog_attach((prog), (target), (type), (flags));    \
> +		if (__ret == -1)                                               \
> +			FAIL_ERRNO("prog_attach(" #type ")");                  \
> +		__ret;                                                         \
> +	})
> +
> +#define xbpf_prog_detach2(prog, target, type)                                  \
> +	({                                                                     \
> +		int __ret = bpf_prog_detach2((prog), (target), (type));        \
> +		if (__ret == -1)                                               \
> +			FAIL_ERRNO("prog_detach2(" #type ")");                 \
> +		__ret;                                                         \
> +	})

The above xbpf_prog_attach() and xbpf_prog_detach2()
are only called once, maybe fold into the calling function itself?

> +
>   static int connected_socket_v4(void)
>   {
>   	struct sockaddr_in addr = {
> @@ -70,10 +103,34 @@ static void test_sockmap_create_update_free(enum bpf_map_type map_type)
>   	close(s);
>   }
>   
> +static void test_skmsg_helpers(enum bpf_map_type map_type)
> +{
> +	struct test_skmsg_load_helpers *skel;
> +	int err, map, verdict;
> +
> +	skel = test_skmsg_load_helpers__open_and_load();
> +	if (!skel) {
> +		FAIL("skeleton open/load failed");
> +		return;
> +	}
> +
> +	verdict = bpf_program__fd(skel->progs.prog_msg_verdict);
> +	map = bpf_map__fd(skel->maps.sock_map);
> +
> +	err = xbpf_prog_attach(verdict, map, BPF_SK_MSG_VERDICT, 0);
> +	if (err)
> +		return;
> +	xbpf_prog_detach2(verdict, map, BPF_SK_MSG_VERDICT);
> +}
> +
>   void test_sockmap_basic(void)
>   {
>   	if (test__start_subtest("sockmap create_update_free"))
>   		test_sockmap_create_update_free(BPF_MAP_TYPE_SOCKMAP);
>   	if (test__start_subtest("sockhash create_update_free"))
>   		test_sockmap_create_update_free(BPF_MAP_TYPE_SOCKHASH);
> +	if (test__start_subtest("sockmap sk_msg load helpers"))
> +		test_skmsg_helpers(BPF_MAP_TYPE_SOCKMAP);
> +	if (test__start_subtest("sockhash sk_msg load helpers"))
> +		test_skmsg_helpers(BPF_MAP_TYPE_SOCKHASH);
>   }
> diff --git a/tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c b/tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c
> new file mode 100644
> index 0000000..b68eb6c
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c
> @@ -0,0 +1,48 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2020 Isovalent, Inc.
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_SOCKMAP);
> +	__uint(max_entries, 2);
> +	__type(key, __u32);
> +	__type(value, __u64);
> +} sock_map SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_SOCKHASH);
> +	__uint(max_entries, 2);
> +	__type(key, __u32);
> +	__type(value, __u64);
> +} sock_hash SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
> +	__uint(map_flags, BPF_F_NO_PREALLOC);
> +	__type(key, __u32);
> +	__type(value, __u64);
> +} socket_storage SEC(".maps");
> +
> +SEC("sk_msg")
> +int prog_msg_verdict(struct sk_msg_md *msg)
> +{
> +	struct task_struct *task = (struct task_struct *)bpf_get_current_task();
> +	int verdict = SK_PASS;
> +	__u32 pid, tpid;
> +	__u64 *sk_stg;
> +
> +	pid = bpf_get_current_pid_tgid() >> 32;
> +	sk_stg = bpf_sk_storage_get(&socket_storage, msg->sk, 0, BPF_SK_STORAGE_GET_F_CREATE);
> +	if (!sk_stg)
> +		return SK_DROP;
> +	*sk_stg = pid;
> +	bpf_probe_read_kernel(&tpid , sizeof(tpid), &task->tgid);
> +	if (pid != tpid)
> +		verdict = SK_DROP;
> +	bpf_sk_storage_delete(&socket_storage, (void *)msg->sk);
> +	return verdict;
> +}
> +
> +int _version SEC("version") = 1;
> +char _license[] SEC("license") = "GPL";
> 
