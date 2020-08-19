Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EBF24A7DC
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgHSUqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:46:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55656 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725275AbgHSUqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:46:16 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JKjwxw011195;
        Wed, 19 Aug 2020 13:46:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=XJB4NA4Am05DP9Uk6l/pmNxmfbhezivZ+WZv5kP5R08=;
 b=ByoGNB+XlXAkGSaSlqK9lE1432ymDrtYDKplh7P1FEQWIgSPx58Bsg92Hx/UTDH2CV4i
 IAzQR7AkdDxBO8HUWSz/wEP8xGIgBEkW6ZCzBpnQvEJKcoG0w8agkO8md5JKt3qTEFHE
 FzRMT+SqVpn1y00B8VNk7AFFyVVUn5NHiQ0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3318g0gx2r-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Aug 2020 13:46:00 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 13:45:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9VKBWuLQuZLmoMGQM/c7xFAoT/J+W6GIVh9pS1W2yKd4HuaQcSS10FunhEOAqc5mLec108ZLeKUybA3vtbKa2GAjwwrykuSkoyJDvOO0BfG3cMyfw5Qs87o/EQ1OekxSfyvTI5VqpzOVcFUfFLv+YPZ6xW9pY1WkYqBtizdxQ3qX9wro2U89LNU4xjvwgSSHlWEalfg1oKTt3KiDmLkEkOpAjmQPijhyTFerJiG3HYLjS6g3D1WNW0pAM5N0+sMM5QOy43lS8OE76yQWrDqEgrvItCOSrHjGdHZehaMQfsIWj9mWjhZRANva4rLzbXFkymY7y2gkde7P7/f6fZmsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJB4NA4Am05DP9Uk6l/pmNxmfbhezivZ+WZv5kP5R08=;
 b=TGDAaVtx6zLsju2gHwoGbXQbD6sSCjhig0ChEgnZmeQDoNgVJh/lP0U18xDqyT2C1XQZbvBdZJHNSJ9GbxuG6LaYJCtm8pPjAcRe2o0fMefcwnKFVprvxf9pFan8GFXzoJeUbOBi/l3e50SUaRs0tJTYeDKBYX1pDbzrfFuhsJcfItuOg0sAfOt3wr2ggcb0ZqIR8+xSdUil9uryh0a3q3BKrwwds9ode6PRJvuybEEovX22dz5D77ebj+6Xk1aTeV0ls/ziBrLevIEP76OhPLif5cukiJ49m/5vzNAKxA9S3gIEjF4Enhkt8XgTVR6KIk3dmFUInzMMTjcqesetuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJB4NA4Am05DP9Uk6l/pmNxmfbhezivZ+WZv5kP5R08=;
 b=XXyMnrSy65U3JtJ6zaTdsbjBgE++we2Iq1GKDAfqNYBV4BPmI7pwBF2lYZxnXsQwg95vaHQjHsnBgTky0tEBsgOYiq+goebpxzrClGNANG4ouyKfo+tzCj/1+Fq0s73orYhQKtvtMhTI+ZYKze2pslAEycMxcM8wK7iuSDg7jac=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2645.namprd15.prod.outlook.com (2603:10b6:a03:156::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.22; Wed, 19 Aug
 2020 20:45:37 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 20:45:37 +0000
Subject: Re: [PATCH bpf-next 6/6] selftests: bpf: test sockmap update from BPF
To:     Lorenz Bauer <lmb@cloudflare.com>, <jakub@cloudflare.com>,
        <john.fastabend@gmail.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     <kernel-team@cloudflare.com>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20200819092436.58232-1-lmb@cloudflare.com>
 <20200819092436.58232-7-lmb@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1ad29823-1925-01ee-f042-20b422a62a73@fb.com>
Date:   Wed, 19 Aug 2020 13:45:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819092436.58232-7-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR06CA0003.namprd06.prod.outlook.com
 (2603:10b6:208:23d::8) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:d29f) by MN2PR06CA0003.namprd06.prod.outlook.com (2603:10b6:208:23d::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 20:45:35 +0000
X-Originating-IP: [2620:10d:c091:480::1:d29f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba64ab10-60ba-4892-13e5-08d84480d3ab
X-MS-TrafficTypeDiagnostic: BYAPR15MB2645:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2645BDB28024F4C82B895A66D35D0@BYAPR15MB2645.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:83;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: exOuukPjK0vSvgjg0f3bjgzMpNaCsSO8qyp0ESF0uyj62Zzp15iou8PKIKS4X9oFPRGB5AlQLMrXO/O9j3E+rCJgoHT9NbOGxO4BSkctKfdD3r47Q76kEq316sHlwom1SdQ30DaKTKwl0GNhwImNmQF97ZMFCaldF2IS1jjDY5CvhYgkCo5G1zBXLGNZ1tLFbkwpKjvWqHXxegOiqPL58NAh5tvvbT58eiD3o62w3q87XHfquySQxyx3STNG0wiEd4kudLBmYpjvPvCMiay5ddUL0jkdhI+id8Fqrfn9pNZZ7tmMzjiJQ9dVzoIfbrU6c8T3P4knH2oJWGuJx9osF6JHtiT1bxD7Y7O+FxWfVaOHJWO/l0eTJ9t50ZF+lxlY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(346002)(366004)(136003)(396003)(36756003)(7416002)(31686004)(86362001)(16526019)(4326008)(110136005)(6486002)(2906002)(316002)(5660300002)(8936002)(8676002)(31696002)(478600001)(66556008)(66946007)(2616005)(186003)(6666004)(53546011)(66476007)(52116002)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: QmFXgvG1rAqCp51ySFwSDWUWElMD49gZe8QnD+gyeFaNO0AHt5HxWG2nC2HLY4nLQQE29GbpsChZfhfsZKJ2ofvYmiDtNPOr627VmbubgU6C5jikf0f/CGAPq85lty+tWN5CR2MDFRvcweNXhVu69wRzaxPoInpKQjO0dkFs9ZYHNoZqU3yrpKLdA9SyV0Qv/U3Qj2C6T98nVfytFAOQETBXS9LjwGLk4ivg/is7Gdzk4KN+/LI1bcFVrH+OPtlffEU4RqfqLr4xgAdNstFbnquy7x5UByMlREy0XDPE86u3kRlHZZW5Mpv6xYuxxPTO34Esvan0RfbNMBsMeUw5gl/ufg/ubVKdZMFde1NeoSeG3iu3zXV/ReDUl0ODG10C5B37OtCF2ATRhcV7rHcl6YNU5YrIqlW8Nl35GP0+zyMB1+0MyD++21SKkCsY26mxhmO0TI6o2HntZCNRzoTlfOUHxjDWE4OA3OfnETv37StW9j0yaq18HQ1iCXRJ6xv++fAbHkyyjGAU+BdI/LtaYP/EIplR+FWgmKBfcSjyZW0HSlByCzrng8Te+HX7Ziktc/h5eUfD52eJ6H4EH3ciuHGoAnUVlLkxMbFO/bcbc49s3bVFrYRcOTnuz4sKWgBN2CkV7KMt8T8jJ34pkrwb/h/Z7a/0I9agakOyBvpFoWaXPP+xpRL9rCCV4pOT+1e4
X-MS-Exchange-CrossTenant-Network-Message-Id: ba64ab10-60ba-4892-13e5-08d84480d3ab
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 20:45:37.4829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vVc9Q+skrDgU51l4OMy+oSQf/Ny1dvmt98bStr28n6Ok7LJvjj5M9BrvlFDOfQWH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2645
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=2 mlxscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190169
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 2:24 AM, Lorenz Bauer wrote:
> Add a test which copies a socket from a sockmap into another sockmap
> or sockhash. This excercises bpf_map_update_elem support from BPF
> context. Compare the socket cookies from source and destination to
> ensure that the copy succeeded.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>   .../selftests/bpf/prog_tests/sockmap_basic.c  | 76 +++++++++++++++++++
>   .../selftests/bpf/progs/test_sockmap_copy.c   | 48 ++++++++++++
>   2 files changed, 124 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_copy.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> index 96e7b7f84c65..d30cabc00e9e 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> @@ -4,6 +4,7 @@
>   
>   #include "test_progs.h"
>   #include "test_skmsg_load_helpers.skel.h"
> +#include "test_sockmap_copy.skel.h"
>   
>   #define TCP_REPAIR		19	/* TCP sock is under repair right now */
>   
> @@ -101,6 +102,77 @@ static void test_skmsg_helpers(enum bpf_map_type map_type)
>   	test_skmsg_load_helpers__destroy(skel);
>   }
>   
> +static void test_sockmap_copy(enum bpf_map_type map_type)
> +{
> +	struct bpf_prog_test_run_attr attr;
> +	struct test_sockmap_copy *skel;
> +	__u64 src_cookie, dst_cookie;
> +	int err, prog, s, src, dst;
> +	const __u32 zero = 0;
> +	char dummy[14] = {0};
> +
> +	s = connected_socket_v4();

Maybe change variable name to "sk" for better clarity?

> +	if (CHECK_FAIL(s == -1))
> +		return;
> +
> +	skel = test_sockmap_copy__open_and_load();
> +	if (CHECK_FAIL(!skel)) {
> +		close(s);
> +		perror("test_sockmap_copy__open_and_load");
> +		return;
> +	}

Could you use CHECK instead of CHECK_FAIL?
With CHECK, you can print additional information without perror.


> +
> +	prog = bpf_program__fd(skel->progs.copy_sock_map);
> +	src = bpf_map__fd(skel->maps.src);
> +	if (map_type == BPF_MAP_TYPE_SOCKMAP)
> +		dst = bpf_map__fd(skel->maps.dst_sock_map);
> +	else
> +		dst = bpf_map__fd(skel->maps.dst_sock_hash);
> +
> +	err = bpf_map_update_elem(src, &zero, &s, BPF_NOEXIST);

The map defined in bpf program is __u64 and here "s" is int.
Any potential issues?

> +	if (CHECK_FAIL(err)) {
> +		perror("bpf_map_update");
> +		goto out;
> +	}
> +
> +	err = bpf_map_lookup_elem(src, &zero, &src_cookie);
> +	if (CHECK_FAIL(err)) {
> +		perror("bpf_map_lookup_elem(src)");
> +		goto out;
> +	}
> +
> +	attr = (struct bpf_prog_test_run_attr){
> +		.prog_fd = prog,
> +		.repeat = 1,
> +		.data_in = dummy,
> +		.data_size_in = sizeof(dummy),
> +	};
> +
> +	err = bpf_prog_test_run_xattr(&attr);
> +	if (err) {

You can use CHECK macro here.

> +		test__fail();
> +		perror("bpf_prog_test_run");
> +		goto out;
> +	} else if (!attr.retval) {
> +		PRINT_FAIL("bpf_prog_test_run: program returned %u\n",
> +			   attr.retval);
> +		goto out;
> +	}
> +
> +	err = bpf_map_lookup_elem(dst, &zero, &dst_cookie);
> +	if (CHECK_FAIL(err)) {
> +		perror("bpf_map_lookup_elem(dst)");
> +		goto out;
> +	}
> +
> +	if (dst_cookie != src_cookie)
> +		PRINT_FAIL("cookie %llu != %llu\n", dst_cookie, src_cookie);

Just replace the whole if statement with a CHECK macro.

> +
> +out:
> +	close(s);
> +	test_sockmap_copy__destroy(skel);
> +}
> +
>   void test_sockmap_basic(void)
>   {
>   	if (test__start_subtest("sockmap create_update_free"))
> @@ -111,4 +183,8 @@ void test_sockmap_basic(void)
>   		test_skmsg_helpers(BPF_MAP_TYPE_SOCKMAP);
>   	if (test__start_subtest("sockhash sk_msg load helpers"))
>   		test_skmsg_helpers(BPF_MAP_TYPE_SOCKHASH);
> +	if (test__start_subtest("sockmap copy"))
> +		test_sockmap_copy(BPF_MAP_TYPE_SOCKMAP);
> +	if (test__start_subtest("sockhash copy"))
> +		test_sockmap_copy(BPF_MAP_TYPE_SOCKHASH);
>   }
> diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_copy.c b/tools/testing/selftests/bpf/progs/test_sockmap_copy.c
> new file mode 100644
> index 000000000000..9d0c9f28cab2
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_sockmap_copy.c
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
