Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316BD24D97B
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 18:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgHUQN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 12:13:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50708 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725824AbgHUQNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 12:13:24 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LGB6Ew005531;
        Fri, 21 Aug 2020 09:13:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qwr8Jqr2SvP4KpZzQH4BA+FBvCgoDb3dsORCCfSSumo=;
 b=kNtYp58ZkgrTEq9rfpxJAjxD7cS2/NAj6qKGg2Ssy8+VbdYYCQi+JRWmpBzhIhPHLh4e
 rsL9QBy9OvvvJPaD1mf4dqJF3N+S4lYC+teewUOaWPGLCbovwIdIvPZYG3545fdc/mXO
 7yGhkUwVKzmrEaiqI7BdNfkoBqBnnDuzs80= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p3wh0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Aug 2020 09:13:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 21 Aug 2020 09:13:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7kTsQ+dRDaSmt7acpC3tp8yJirEVdAVAzPv4T8S1kphbyfusTu6kJiYFk/qbEjw0uCJnXU9+e+EICpSd1LzpgSpuh3O4j0UHxa2nWojpN44Mbn/z8G53YTlcnEt35FJ/iaZVMhcLNfTXboDkX5W6lwjYGTrDsjOetYV0Is8vLy1KvLSSK1BBLyWB9aFBXUeMahlqwUckrMPcg1GNmr5c45K8BhOKbTYYsj12mEo+1cDfgmvbX+dw9ELQnMvE9q2Oa2huoa3CHXb7SnFcQ3UtTDT8FrYBwPeQgI7fb0PbE9KwbxbAyNqEulI77Hgn8bqJfG3k2cA6orIof3aJFCJ7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwr8Jqr2SvP4KpZzQH4BA+FBvCgoDb3dsORCCfSSumo=;
 b=BWJUWzT3Vfzp28Pl8FhPPfNoCR69HptQ+r1DZV1IZqNwMsUSXBufNsMC1AresmEyLMHqqwNHn9HOpFxXNxEef9xgxGvoTdMZ4nxeh8Zhqia/8blln8HNk6rngyeo3HO095iBxDBy3K2shLSmmQtHrx0mx0PhBmztSL8OxgHkhymAeBbBpPLwmfJr5eJh6NtWlQE71KVC7+O/CFMJny11C0uUVZJfQWUg+K9hkoOT1bvFsgjkd2RpgiNsRdMHcWvpKh2e9bob20kHNfoaTt4AhCwjN5aH49Xlw8aMyi1eS1QWpl+gyGCv0HJ1oPiz4qXGylHVlsAmh0sCjoCCMqXJIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwr8Jqr2SvP4KpZzQH4BA+FBvCgoDb3dsORCCfSSumo=;
 b=NBOx7gMrWoQvUq1cbbgBHui2PM/0ZUtEIgPxOeYvLtU+wB6aohojzpkaKyiYCZAYvbb62z9NKsxCZNoo0xKrgmmOSzbghxfuqFtwTsFuu5cK1yadMdLR1v6P1OWYuYxstH2cFKPru40QIDxZQMGPmSzgNHGRTzkokyvGjS0xS5g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (52.135.225.146) by
 BYAPR15MB2581.namprd15.prod.outlook.com (20.179.158.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.25; Fri, 21 Aug 2020 16:13:06 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Fri, 21 Aug 2020
 16:13:06 +0000
Subject: Re: [PATCH bpf-next v3 6/6] selftests: bpf: test sockmap update from
 BPF
To:     Lorenz Bauer <lmb@cloudflare.com>, <jakub@cloudflare.com>,
        <john.fastabend@gmail.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     <kernel-team@cloudflare.com>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20200821102948.21918-1-lmb@cloudflare.com>
 <20200821102948.21918-7-lmb@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <9a309be3-ffd4-23bb-b67a-f47d7785a96f@fb.com>
Date:   Fri, 21 Aug 2020 09:13:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200821102948.21918-7-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0144.namprd02.prod.outlook.com
 (2603:10b6:208:35::49) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BL0PR02CA0144.namprd02.prod.outlook.com (2603:10b6:208:35::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Fri, 21 Aug 2020 16:13:04 +0000
X-Originating-IP: [2620:10d:c091:480::1:8c09]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f0a1a87-f9a1-445f-68c6-08d845ed166d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2581:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2581A18A9580954F7A862C13D35B0@BYAPR15MB2581.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X2mpfc2hwjCKC7Rl3T9ECoG0Dnj8Frco2L5gIcVoeCKLB1A4sncgCIWPMjuUqxv3ilbn49s0m1R9YtCyhr21F6SViRsP6jMO2/nwg9AYzDSZxiI9X2Doeh48cI/f9V7laS5Fw2UszcG/hogCgt40ry6Kda2m9UBGpyH01xzNOoO+yDbWouaAG3lBiXknxRUCQcVs8jBWGAMtLXd8sr1yYUtHcQhMDPbxaoEj4xpcrEqo88Cxh/OIJX5fdeXQznrIU4RfWeHOrlnmjRWO8joFPPcf5trWstkLzHkQYEosD96/QYjICSjIcMFqhhGERaWcEyNMxVurr40/hC8pG+JPwylZa0nPH4yEy5eC3Ll7PyFfCAaZJyJ9PjGMpop1WfStmMv8iVjahV4Wb182zKPH4m2OxiKxq1r1fWyhsKJOXX8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(136003)(376002)(396003)(66476007)(7416002)(66556008)(66946007)(6486002)(36756003)(31686004)(478600001)(53546011)(6666004)(2906002)(31696002)(956004)(2616005)(5660300002)(4326008)(83380400001)(110136005)(8676002)(15650500001)(86362001)(186003)(16576012)(110011004)(316002)(8936002)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: cnl+qdapGqoTvh9vKvnC486pAMWnJ5DEnpl/UEg3R/yK4vbeLrrTHjG16WME8OrfZYkSlVDQHfBlig69m0UCo7AfRzKyqKtXzDsC3ajzvGhf8clRLRgV9mCD6gt8llFzeLB26oZezHOmsTmYzZl2Q2YbHO01axoPzJagF6z7fWaEMcBMM889K4U1wOfAQQeWHI3jgPLeK7hdX6+WeqTdJWUas/PC5T+PIlp11cnWSbwY0y3WgW2iXbXfF3gMa/Dv76PZwU6VZeF+nbZuKjo8o4kqd43xGgAbdSFCAmYdfET2dWlGqUEoCKgk3jCNyalzdz+v9ylnDYDakM/5Pon5gLXwlnndzpM+4b7/0T9eAmILj3ePM2obqXkZFweGfrkSOyhJ7kAn7Guu54eApK1xsXF1mnctPyqg+H1gkhv1Sj2n9MSLODl9qpt22gh1BFVW2R4ykC/Xm8noVE6kXxMEAWvKiD5mh40J1GRquDGRnukHCr6iqsDPYMn/CsZVBx/tnumRvZ6oAxizyzmoM7emKnrTvkPSun7hWcXGxeOQpO9ryPCEwnmJjM9WYFEPlN4EIyFoxYJaoKWb2Zbogj+toNh6I3EgeWivrn9wz0X9ff0+/i4eYRMx2kcflruld2mrdBh6YANimZq1qgON9exAmF5i3+dTVrpXTkUeVP80u3JP/9pVSNNDW1sCqLq+SW3k
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0a1a87-f9a1-445f-68c6-08d845ed166d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 16:13:06.2377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FID/nPUPtjsljRqlLq37ycMC/yLAu6//OXzrb4dYEwBAjAXlnDVNTPESsRa4UVgI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2581
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_08:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 mlxscore=0 clxscore=1015 suspectscore=2 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/21/20 3:29 AM, Lorenz Bauer wrote:
> Add a test which copies a socket from a sockmap into another sockmap
> or sockhash. This excercises bpf_map_update_elem support from BPF
> context. Compare the socket cookies from source and destination to
> ensure that the copy succeeded.
> 
> Also check that the verifier rejects map_update from unsafe contexts.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>

A few nits below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   .../selftests/bpf/prog_tests/sockmap_basic.c  | 78 +++++++++++++++++++
>   .../bpf/progs/test_sockmap_invalid_update.c   | 23 ++++++
>   .../selftests/bpf/progs/test_sockmap_update.c | 48 ++++++++++++
>   3 files changed, 149 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_invalid_update.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_update.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> index 96e7b7f84c65..65ce7c289534 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> @@ -4,6 +4,8 @@
>   
>   #include "test_progs.h"
>   #include "test_skmsg_load_helpers.skel.h"
> +#include "test_sockmap_update.skel.h"
> +#include "test_sockmap_invalid_update.skel.h"
>   
>   #define TCP_REPAIR		19	/* TCP sock is under repair right now */
>   
> @@ -101,6 +103,76 @@ static void test_skmsg_helpers(enum bpf_map_type map_type)
>   	test_skmsg_load_helpers__destroy(skel);
>   }
>   
> +static void test_sockmap_update(enum bpf_map_type map_type)
> +{
> +	struct bpf_prog_test_run_attr tattr;
> +	int err, prog, src, dst, duration = 0;
> +	struct test_sockmap_update *skel;
> +	__u64 src_cookie, dst_cookie;
> +	const __u32 zero = 0;
> +	char dummy[14] = {0};
> +	__s64 sk;
> +
> +	sk = connected_socket_v4();
> +	if (CHECK(sk == -1, "connected_socket_v4", "cannot connect\n"))
> +		return;
> +
> +	skel = test_sockmap_update__open_and_load();
> +	if (CHECK(!skel, "open_and_load", "cannot load skeleton\n")) {
> +		close(sk);
> +		return;
> +	}
> +
> +	prog = bpf_program__fd(skel->progs.copy_sock_map);
> +	src = bpf_map__fd(skel->maps.src);
> +	if (map_type == BPF_MAP_TYPE_SOCKMAP)
> +		dst = bpf_map__fd(skel->maps.dst_sock_map);
> +	else
> +		dst = bpf_map__fd(skel->maps.dst_sock_hash);
> +
> +	err = bpf_map_update_elem(src, &zero, &sk, BPF_NOEXIST);
> +	if (CHECK(err, "update_elem(src)", "errno=%u\n", errno))
> +		goto out;
> +
> +	err = bpf_map_lookup_elem(src, &zero, &src_cookie);
> +	if (CHECK(err, "lookup_elem(src, cookie)", "errno=%u\n", errno))
> +		goto out;
> +
> +	tattr = (struct bpf_prog_test_run_attr){
> +		.prog_fd = prog,
> +		.repeat = 1,
> +		.data_in = dummy,
> +		.data_size_in = sizeof(dummy),
> +	};
> +
> +	err = bpf_prog_test_run_xattr(&tattr);
> +	if (CHECK_ATTR(err || !tattr.retval, "bpf_prog_test_run",
> +		       "errno=%u retval=%u\n", errno, tattr.retval))
> +		goto out;
> +
> +	err = bpf_map_lookup_elem(dst, &zero, &dst_cookie);
> +	if (CHECK(err, "lookup_elem(dst, cookie)", "errno=%u\n", errno))
> +		goto out;
> +
> +	CHECK(dst_cookie != src_cookie, "cookie mismatch", "%llu != %llu\n",
> +	      dst_cookie, src_cookie);
> +
> +out:
> +	close(sk);
> +	test_sockmap_update__destroy(skel);

nit. In the beginning of the function, 'sk' is available and then skel 
is opened and loaded. You can have

out:
	test_sockmap_update__destroy(skel);
close_sk:
	close(sk);

this probably more conforms to linux coding style.

Then you can have
	if (CHECK(!skel, "open_and_load", "cannot load skeleton\n"))
		goto close_sk;

> +}
> +
> +static void test_sockmap_invalid_update(void)
> +{
> +	struct test_sockmap_invalid_update *skel;
> +	int duration = 0;
> +
> +	skel = test_sockmap_invalid_update__open_and_load();
> +	CHECK(skel, "open_and_load", "verifier accepted map_update\n");
> +	if (skel)
> +		test_sockmap_invalid_update__destroy(skel);

nit, you can just have
	if (CHECK(skel, "open_and_load", "verifier accepted map_update\n"))
		test_sockmap_invalid_update__destroy(skel);

> +}
> +
>   void test_sockmap_basic(void)
>   {
>   	if (test__start_subtest("sockmap create_update_free"))
> @@ -111,4 +183,10 @@ void test_sockmap_basic(void)
>   		test_skmsg_helpers(BPF_MAP_TYPE_SOCKMAP);
>   	if (test__start_subtest("sockhash sk_msg load helpers"))
>   		test_skmsg_helpers(BPF_MAP_TYPE_SOCKHASH);
> +	if (test__start_subtest("sockmap update"))
> +		test_sockmap_update(BPF_MAP_TYPE_SOCKMAP);
> +	if (test__start_subtest("sockhash update"))
> +		test_sockmap_update(BPF_MAP_TYPE_SOCKHASH);
> +	if (test__start_subtest("sockmap update in unsafe context"))
> +		test_sockmap_invalid_update();
>   }
> diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_invalid_update.c b/tools/testing/selftests/bpf/progs/test_sockmap_invalid_update.c
> new file mode 100644
> index 000000000000..02a59e220cbc
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_sockmap_invalid_update.c
> @@ -0,0 +1,23 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2020 Cloudflare
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_SOCKMAP);
> +	__uint(max_entries, 1);
> +	__type(key, __u32);
> +	__type(value, __u64);
> +} map SEC(".maps");
> +
> +SEC("sockops")
> +int bpf_sockmap(struct bpf_sock_ops *skops)
> +{
> +	__u32 key = 0;
> +
> +	if (skops->sk)
> +		bpf_map_update_elem(&map, &key, skops->sk, 0);
> +	return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_update.c b/tools/testing/selftests/bpf/progs/test_sockmap_update.c
> new file mode 100644
> index 000000000000..9d0c9f28cab2
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_sockmap_update.c
> @@ -0,0 +1,48 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2020 Cloudflare
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_SOCKMAP);
> +	__uint(max_entries, 1);
> +	__type(key, __u32);
> +	__type(value, __u64);
> +} src SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_SOCKMAP);
> +	__uint(max_entries, 1);
> +	__type(key, __u32);
> +	__type(value, __u64);
> +} dst_sock_map SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_SOCKHASH);
> +	__uint(max_entries, 1);
> +	__type(key, __u32);
> +	__type(value, __u64);
> +} dst_sock_hash SEC(".maps");
> +
> +SEC("classifier/copy_sock_map")
> +int copy_sock_map(void *ctx)
> +{
> +	struct bpf_sock *sk;
> +	bool failed = false;
> +	__u32 key = 0;
> +
> +	sk = bpf_map_lookup_elem(&src, &key);
> +	if (!sk)
> +		return SK_DROP;
> +
> +	if (bpf_map_update_elem(&dst_sock_map, &key, sk, 0))
> +		failed = true;
> +
> +	if (bpf_map_update_elem(&dst_sock_hash, &key, sk, 0))
> +		failed = true;
> +
> +	bpf_sk_release(sk);
> +	return failed ? SK_DROP : SK_PASS;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> 
