Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4391CC310
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 19:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgEIRKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 13:10:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17542 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726013AbgEIRKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 13:10:36 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 049H6U0u005028;
        Sat, 9 May 2020 10:10:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=woDi4jAwR9zHatUmX4uTaCeUSWaYZ12KpwFPzKGqLcQ=;
 b=Hh+C5kpmnYK4ve3XjNP7EAuMjR3iEy82aEh9ZGOv8clfs/jG7qIPWQ4vW9RSt7Il3Euh
 YhRh67UAHgZBYZX3KuawMPAygit4v7Z2qwZyKaA/taXXpoXwoD04ZUhAKCD8tdsxRiGb
 rprAe0zLidkXd3Ki9CuMLRtKoyJyZ/tW3C4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30wt78h8vx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 09 May 2020 10:10:17 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 10:10:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADE8H7+cOdteB0FwdnnMBM7BT09Wqx2q7NuByzE4S7D0y68b2h6clkMbaIFRNF1H39R0lR9mwO0IJ1Z1z3EiUWhCh7UkeN+fmILD3yfDPJ1wSbBVrSyAPNr77PR571t76wiGViCCYd+SLBKeqIbCYIv0JygecBfnGYjpe2Is5CZ3g31zfla6bubHW7S4S6YNkoCjczG1ngJ1LWCh4IUT5waeYvL+IChkLGLG9dZcDdyG1ChtyWCFRp4EfwKlis8RF2M9LxwGtVvvvt0MfbUCUXRmXUnQr1TSxYFJteAc7dLw8eJNKpVYWxc1lPb5j+fA0OIuhzAppHx4YXP4b6kOSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=woDi4jAwR9zHatUmX4uTaCeUSWaYZ12KpwFPzKGqLcQ=;
 b=WAuswR+VE01MG6IoCI6DnlZMzW10xJS8F7rXztx2RcsID0UB/za0IlCRoRr4GnSeExl6z1Ohrc7ghRu+4gm3WPD2UZeVFFD7ATV2EVNSN+DZCJzBUo7zJbu7GaNaXwZQxQ63d4e0kjU+gzKlrYHwcKyw0FBh5gZSDO0VJXekuPI1XJirAtikXxXN5Oyj7vzQT2i/i33oDra3OvO6d5urFnmfgfsxnn3kfDWaahGsSBBmIkCTo6+rDBSl6ztX9ef1Mhru8ase82nbrbl9Nrv+6IcsXT6XSXE/VubKxKDjJra0Wn6w8hprXoezd53yG1kbJj4W8PT1fyaP8SkB/mj1rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=woDi4jAwR9zHatUmX4uTaCeUSWaYZ12KpwFPzKGqLcQ=;
 b=G2LRuuKWhs2zQo1FzprSFlXfCfWyLDlALr1w/7jnWuQ5DAjvdCIU8GF3K6JuHjLxCwZ5hTs8XI01NH3rvz825bC+SMPd8gl/isFW8uuk1WBz5F7YBb2w76EiIOXvsNVoI9tXW9JRh2qgHNIW9pFxAliatQ6PfNgkF43MInGE8N0=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2213.namprd15.prod.outlook.com (2603:10b6:a02:85::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Sat, 9 May
 2020 17:10:12 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Sat, 9 May 2020
 17:10:12 +0000
Subject: Re: [PATCH v2 bpf-next 1/3] selftests/bpf: add benchmark runner
 infrastructure
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200508232032.1974027-1-andriin@fb.com>
 <20200508232032.1974027-2-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3fc4af5c-739a-35c3-c649-03eef18a3144@fb.com>
Date:   Sat, 9 May 2020 10:10:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200508232032.1974027-2-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:a03:74::30) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sprihad-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:e112) by BYAPR05CA0053.namprd05.prod.outlook.com (2603:10b6:a03:74::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.11 via Frontend Transport; Sat, 9 May 2020 17:10:11 +0000
X-Originating-IP: [2620:10d:c090:400::5:e112]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e850088-c903-47d7-f455-08d7f43bd57d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2213:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2213D43D8D20D38528F1F5BAD3A30@BYAPR15MB2213.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SYbkFhzdrObH8X2anlFvVHrSBAHSivz8M6HRHiF1Xq9EcEKIYZ7lf6QvxtZPgJTKDgrXJYmkd2Bec3exFBVFuUgi6YCYMzQl3h00way7G8Q9ZcPzHxkwQs30FArnh/Baf7/af3M3WQhSiVFiDwiGfoNGvqGBayaeDmY/VLCx9HE1uDQUyEMl46ij8J9oHyLuF9Z2/Q+8mfaNrWRMT5Pc7okndLL+GRia4Uk6ZTMQsjtWcFMQZUm8VVeKME6p5VheKPsPSJLpPVxjTrlZhOxW8nfNIKqv8TVqo34eCIdAbs05by20PBzm+RaIUQwkDPFU7U7fntdvwkZ1faRUrbddUbJtgReYkYb3uwsp8owyKRjalVbvK65Ozv0u2xIpkQ/4hcp2qa293zhmwsKbQ1QACToVSXTOvnvgfGQRdNEEFNPGDWf9Qjc0jhbipwa3uJDO3Mquut0N7j4m+uNykShle04+QQpblIxORxyIr1WWMFwgdexaj5gBgfZQ2CopM5cMfH0frIn6MY4zFt0QiRKzkr+4lHZh+M2zmli6MclMuavFO5bPBQYTwinPGfhTHknd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(376002)(396003)(39860400002)(136003)(33430700001)(52116002)(36756003)(316002)(31696002)(86362001)(478600001)(33440700001)(66946007)(66476007)(66556008)(186003)(16526019)(5660300002)(6506007)(53546011)(30864003)(2616005)(6486002)(6512007)(4326008)(31686004)(2906002)(8676002)(8936002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: j8DyAjNTIoMKldE+qgq8yE7+OKo1Umlgfrqk5KqsU2Q45OfSYZL8PV3YBnbdp37Ral8fv9FM8cvTUDZ/BWZsupcg0yVx9clk33PIn5SX2tMJYH4NtUkywHdy78dN14NvFsRyHg0DsxniIOMMGr4ihbBQse5tc//GWCYqr0l4ikOQN0xP+Gd4ggamyLdrLuob38JkdNhR9k9F+kz7BQVLXZN1HXJYJEjU72OP5o4a1tFFFT5GC3yQWgYp2flK4lHXvOlcNSgAU/gInwCxA6H9agxtookg0uvSHyKEceOxFJWLtko9pbe/3d/D1o3MTf31jfFnds2ObdSfw2klKw2FpoGo+sMWUBxjEoDVoyCngfBjWIdN5gYiSLaMkegeN3u+yMwf7UGZHECTMTw2KlA4WJs+hNzHJWNXwJuV9PTeGjHPxpHOkI4zRpD6OKBoippWowlPb+UU9JAK+cy1lp/7mHiJpV8j9MSULxRVkHJ62Pi43bdmzs8Wny0RL04bZ4O100nOc0p1eEp6UNXvEOv6Bw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e850088-c903-47d7-f455-08d7f43bd57d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 17:10:12.1082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x3nHE43rMRslLv1d5iRH1Mq/Vr2FQsXx1Pmgirn9pVvjkBt7apCYvM45JPkft666
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2213
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_06:2020-05-08,2020-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=999 priorityscore=1501 spamscore=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005090147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/20 4:20 PM, Andrii Nakryiko wrote:
> While working on BPF ringbuf implementation, testing, and benchmarking, I've
> developed a pretty generic and modular benchmark runner, which seems to be
> generically useful, as I've already used it for one more purpose (testing
> fastest way to trigger BPF program, to minimize overhead of in-kernel code).
> 
> This patch adds generic part of benchmark runner and sets up Makefile for
> extending it with more sets of benchmarks.
> 
> Benchmarker itself operates by spinning up specified number of producer and
> consumer threads, setting up interval timer sending SIGALARM signal to
> application once a second. Every second, current snapshot with hits/drops
> counters are collected and stored in an array. Drops are useful for
> producer/consumer benchmarks in which producer might overwhelm consumers.
> 
> Once test finishes after given amount of warm-up and testing seconds, mean and
> stddev are calculated (ignoring warm-up results) and is printed out to stdout.
> This setup seems to give consistent and accurate results.
> 
> To validate behavior, I added two atomic counting tests: global and local.
> For global one, all the producer threads are atomically incrementing same
> counter as fast as possible. This, of course, leads to huge drop of
> performance once there is more than one producer thread due to CPUs fighting
> for the same memory location.
> 
> Local counting, on the other hand, maintains one counter per each producer
> thread, incremented independently. Once per second, all counters are read and
> added together to form final "counting throughput" measurement. As expected,
> such setup demonstrates linear scalability with number of producers (as long
> as there are enough physical CPU cores, of course). See example output below.
> Also, this setup can nicely demonstrate disastrous effects of false sharing,
> if care is not taken to take those per-producer counters apart into
> independent cache lines.
> 
> Demo output shows global counter first with 1 producer, then with 4. Both
> total and per-producer performance significantly drop. The last run is local
> counter with 4 producers, demonstrating near-perfect scalability.
> 
> $ ./bench -a -w1 -d2 -p1 count-global
> Setting up benchmark 'count-global'...
> Benchmark 'count-global' started.
> Iter   0 ( 24.822us): hits  148.179M/s (148.179M/prod), drops    0.000M/s
> Iter   1 ( 37.939us): hits  149.308M/s (149.308M/prod), drops    0.000M/s
> Iter   2 (-10.774us): hits  150.717M/s (150.717M/prod), drops    0.000M/s
> Iter   3 (  3.807us): hits  151.435M/s (151.435M/prod), drops    0.000M/s
> Summary: hits  150.488 ± 1.079M/s (150.488M/prod), drops    0.000 ± 0.000M/s
> 
> $ ./bench -a -w1 -d2 -p4 count-global
> Setting up benchmark 'count-global'...
> Benchmark 'count-global' started.
> Iter   0 ( 60.659us): hits   53.910M/s ( 13.477M/prod), drops    0.000M/s
> Iter   1 (-17.658us): hits   53.722M/s ( 13.431M/prod), drops    0.000M/s
> Iter   2 (  5.865us): hits   53.495M/s ( 13.374M/prod), drops    0.000M/s
> Iter   3 (  0.104us): hits   53.606M/s ( 13.402M/prod), drops    0.000M/s
> Summary: hits   53.608 ± 0.113M/s ( 13.402M/prod), drops    0.000 ± 0.000M/s
> 
> $ ./bench -a -w1 -d2 -p4 count-local
> Setting up benchmark 'count-local'...
> Benchmark 'count-local' started.
> Iter   0 ( 23.388us): hits  640.450M/s (160.113M/prod), drops    0.000M/s
> Iter   1 (  2.291us): hits  605.661M/s (151.415M/prod), drops    0.000M/s
> Iter   2 ( -6.415us): hits  607.092M/s (151.773M/prod), drops    0.000M/s
> Iter   3 ( -1.361us): hits  601.796M/s (150.449M/prod), drops    0.000M/s
> Summary: hits  604.849 ± 2.739M/s (151.212M/prod), drops    0.000 ± 0.000M/s
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>   tools/testing/selftests/bpf/.gitignore        |   1 +
>   tools/testing/selftests/bpf/Makefile          |  13 +-
>   tools/testing/selftests/bpf/bench.c           | 372 ++++++++++++++++++
>   tools/testing/selftests/bpf/bench.h           |  74 ++++
>   .../selftests/bpf/benchs/bench_count.c        |  91 +++++
>   5 files changed, 550 insertions(+), 1 deletion(-)
>   create mode 100644 tools/testing/selftests/bpf/bench.c
>   create mode 100644 tools/testing/selftests/bpf/bench.h
>   create mode 100644 tools/testing/selftests/bpf/benchs/bench_count.c
> 
> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> index 3ff031972975..1bb204cee853 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -38,3 +38,4 @@ test_cpp
>   /bpf_gcc
>   /tools
>   /runqslower
> +/bench
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 3d942be23d09..289fffbf975e 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -77,7 +77,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
>   # Compile but not part of 'make run_tests'
>   TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
>   	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
> -	test_lirc_mode2_user xdping test_cpp runqslower
> +	test_lirc_mode2_user xdping test_cpp runqslower bench
>   
>   TEST_CUSTOM_PROGS = urandom_read
>   
> @@ -405,6 +405,17 @@ $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core_extern.skel.h $(BPFOBJ)
>   	$(call msg,CXX,,$@)
>   	$(CXX) $(CFLAGS) $^ $(LDLIBS) -o $@
>   
> +# Benchmark runner
> +$(OUTPUT)/bench_%.o: benchs/bench_%.c bench.h
> +	$(call msg,CC,,$@)
> +	$(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
> +$(OUTPUT)/bench.o: bench.h
> +$(OUTPUT)/bench: LDLIBS += -lm
> +$(OUTPUT)/bench: $(OUTPUT)/bench.o \
> +		 $(OUTPUT)/bench_count.o
> +	$(call msg,BINARY,,$@)
> +	$(CC) $(LDFLAGS) -o $@ $(filter %.a %.o,$^) $(LDLIBS)
> +
>   EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)			\
>   	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
>   	feature								\
> diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
> new file mode 100644
> index 000000000000..dddc97cd4db6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/bench.c
> @@ -0,0 +1,372 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +#define _GNU_SOURCE
> +#include <argp.h>
> +#include <linux/compiler.h>
> +#include <sys/time.h>
> +#include <sched.h>
> +#include <fcntl.h>
> +#include <pthread.h>
> +#include <sys/sysinfo.h>
> +#include <sys/resource.h>
> +#include <signal.h>
> +#include "bench.h"
> +
> +struct env env = {
> +	.warmup_sec = 1,
> +	.duration_sec = 5,
> +	.affinity = false,
> +	.consumer_cnt = 1,
> +	.producer_cnt = 1,
> +};
> +
> +static int libbpf_print_fn(enum libbpf_print_level level,
> +		    const char *format, va_list args)
> +{
> +	if (level == LIBBPF_DEBUG && !env.verbose)
> +		return 0;
> +	return vfprintf(stderr, format, args);
> +}
> +
> +static int bump_memlock_rlimit(void)
> +{
> +	struct rlimit rlim_new = {
> +		.rlim_cur	= RLIM_INFINITY,
> +		.rlim_max	= RLIM_INFINITY,
> +	};
> +
> +	return setrlimit(RLIMIT_MEMLOCK, &rlim_new);
> +}
> +
> +void setup_libbpf()
> +{
> +	int err;
> +
> +	libbpf_set_print(libbpf_print_fn);
> +
> +	err = bump_memlock_rlimit();
> +	if (err)
> +		fprintf(stderr, "failed to increase RLIMIT_MEMLOCK: %d", err);
> +}
> +
> +void hits_drops_report_progress(int iter, struct bench_res *res, long delta_ns)
> +{
> +	double hits_per_sec, drops_per_sec;
> +	double hits_per_prod;
> +
> +	hits_per_sec = res->hits / 1000000.0 / (delta_ns / 1000000000.0);
> +	hits_per_prod = hits_per_sec / env.producer_cnt;
> +	drops_per_sec = res->drops / 1000000.0 / (delta_ns / 1000000000.0);
> +
> +	printf("Iter %3d (%7.3lfus): ",
> +	       iter, (delta_ns - 1000000000) / 1000.0);
> +
> +	printf("hits %8.3lfM/s (%7.3lfM/prod), drops %8.3lfM/s\n",
> +	       hits_per_sec, hits_per_prod, drops_per_sec);
> +}
> +
> +void hits_drops_report_final(struct bench_res res[], int res_cnt)
> +{
> +	int i;
> +	double hits_mean = 0.0, drops_mean = 0.0;
> +	double hits_stddev = 0.0, drops_stddev = 0.0;
> +
> +	for (i = 0; i < res_cnt; i++) {
> +		hits_mean += res[i].hits / 1000000.0 / (0.0 + res_cnt);
> +		drops_mean += res[i].drops / 1000000.0 / (0.0 + res_cnt);
> +	}
> +
> +	if (res_cnt > 1)  {
> +		for (i = 0; i < res_cnt; i++) {
> +			hits_stddev += (hits_mean - res[i].hits / 1000000.0) *
> +				       (hits_mean - res[i].hits / 1000000.0) /
> +				       (res_cnt - 1.0);
> +			drops_stddev += (drops_mean - res[i].drops / 1000000.0) *
> +					(drops_mean - res[i].drops / 1000000.0) /
> +					(res_cnt - 1.0);
> +		}
> +		hits_stddev = sqrt(hits_stddev);
> +		drops_stddev = sqrt(drops_stddev);
> +	}
> +	printf("Summary: hits %8.3lf \u00B1 %5.3lfM/s (%7.3lfM/prod), ",
> +	       hits_mean, hits_stddev, hits_mean / env.producer_cnt);
> +	printf("drops %8.3lf \u00B1 %5.3lfM/s\n",
> +	       drops_mean, drops_stddev);

The unicode char \u00B1 (for +|-) may cause some old compiler (e.g., 
4.8.5) warnings as it needs C99 mode.

/data/users/yhs/work/net-next/tools/testing/selftests/bpf/bench.c:91:9: 
warning: universal character names are only valid in C++ and C99 
[enabled by default]
   printf("Summary: hits %8.3lf \u00B1 %5.3lfM/s (%7.3lfM/prod), ",

"+|-" is alternative, but not as good as \u00B1 indeed. Newer
compiler may already have the default C99. Maybe we can just add
C99 for build `bench`?

> +}
> +
> +const char *argp_program_version = "benchmark";
> +const char *argp_program_bug_address = "<bpf@vger.kernel.org>";
> +const char argp_program_doc[] =
> +"benchmark    Generic benchmarking framework.\n"
> +"\n"
> +"This tool runs benchmarks.\n"
> +"\n"
> +"USAGE: benchmark <bench-name>\n"
> +"\n"
> +"EXAMPLES:\n"
> +"    # run 'count-local' benchmark with 1 producer and 1 consumer\n"
> +"    benchmark count-local\n"
> +"    # run 'count-local' with 16 producer and 8 consumer thread, pinned to CPUs\n"
> +"    benchmark -p16 -c8 -a count-local\n";

Some of the above global variables probably are statics.
But I do not have a strong preference on this.

> +
> +static const struct argp_option opts[] = {
> +	{ "list", 'l', NULL, 0, "List available benchmarks"},
> +	{ "duration", 'd', "SEC", 0, "Duration of benchmark, seconds"},
> +	{ "warmup", 'w', "SEC", 0, "Warm-up period, seconds"},
> +	{ "producers", 'p', "NUM", 0, "Number of producer threads"},
> +	{ "consumers", 'c', "NUM", 0, "Number of consumer threads"},
> +	{ "verbose", 'v', NULL, 0, "Verbose debug output"},
> +	{ "affinity", 'a', NULL, 0, "Set consumer/producer thread affinity"},
> +	{ "b2b", 'b', NULL, 0, "Back-to-back mode"},
> +	{ "rb-output", 10001, NULL, 0, "Set consumer/producer thread affinity"},

I did not see b2b and rb-output options are processed in this file.

> +	{},
> +};
> +
> +static error_t parse_arg(int key, char *arg, struct argp_state *state)
> +{
> +	static int pos_args;
> +
> +	switch (key) {
> +	case 'v':
> +		env.verbose = true;
> +		break;
> +	case 'l':
> +		env.list = true;
> +		break;
> +	case 'd':
> +		env.duration_sec = strtol(arg, NULL, 10);
> +		if (env.duration_sec <= 0) {
> +			fprintf(stderr, "Invalid duration: %s\n", arg);
> +			argp_usage(state);
> +		}
> +		break;
> +	case 'w':
> +		env.warmup_sec = strtol(arg, NULL, 10);
> +		if (env.warmup_sec <= 0) {
> +			fprintf(stderr, "Invalid warm-up duration: %s\n", arg);
> +			argp_usage(state);
> +		}
> +		break;
> +	case 'p':
> +		env.producer_cnt = strtol(arg, NULL, 10);
> +		if (env.producer_cnt <= 0) {
> +			fprintf(stderr, "Invalid producer count: %s\n", arg);
> +			argp_usage(state);
> +		}
> +		break;
> +	case 'c':
> +		env.consumer_cnt = strtol(arg, NULL, 10);
> +		if (env.consumer_cnt <= 0) {
> +			fprintf(stderr, "Invalid consumer count: %s\n", arg);
> +			argp_usage(state);
> +		}
> +		break;
> +	case 'a':
> +		env.affinity = true;
> +		break;
> +	case ARGP_KEY_ARG:
> +		if (pos_args++) {
> +			fprintf(stderr,
> +				"Unrecognized positional argument: %s\n", arg);
> +			argp_usage(state);
> +		}
> +		env.bench_name = strdup(arg);
> +		break;
> +	default:
> +		return ARGP_ERR_UNKNOWN;
> +	}
> +	return 0;
> +}
> +
> +static void parse_cmdline_args(int argc, char **argv)
> +{
> +	static const struct argp argp = {
> +		.options = opts,
> +		.parser = parse_arg,
> +		.doc = argp_program_doc,
> +	};
> +	if (argp_parse(&argp, argc, argv, 0, NULL, NULL))
> +		exit(1);
> +	if (!env.list && !env.bench_name) {
> +		argp_help(&argp, stderr, ARGP_HELP_DOC, "bench");
> +		exit(1);
> +	}
> +}
> +
> +static void collect_measurements(long delta_ns);
> +
> +static __u64 last_time_ns;
> +static void sigalarm_handler(int signo)
> +{
> +	long new_time_ns = get_time_ns();
> +	long delta_ns = new_time_ns - last_time_ns;
> +
> +	collect_measurements(delta_ns);
> +
> +	last_time_ns = new_time_ns;
> +}
> +
> +/* set up periodic 1-second timer */
> +static void setup_timer()
> +{
> +	static struct sigaction sigalarm_action = {
> +		.sa_handler = sigalarm_handler,
> +	};
> +	struct itimerval timer_settings = {};
> +	int err;
> +
> +	last_time_ns = get_time_ns();
> +	err = sigaction(SIGALRM, &sigalarm_action, NULL);
> +	if (err < 0) {
> +		fprintf(stderr, "failed to install SIGALARM handler: %d\n", -errno);
> +		exit(1);
> +	}
> +	timer_settings.it_interval.tv_sec = 1;
> +	timer_settings.it_value.tv_sec = 1;
> +	err = setitimer(ITIMER_REAL, &timer_settings, NULL);
> +	if (err < 0) {
> +		fprintf(stderr, "failed to arm interval timer: %d\n", -errno);
> +		exit(1);
> +	}
> +}
> +
> +static void set_thread_affinity(pthread_t thread, int cpu)
> +{
> +	cpu_set_t cpuset;
> +
> +	CPU_ZERO(&cpuset);
> +	CPU_SET(cpu, &cpuset);
> +	if (pthread_setaffinity_np(thread, sizeof(cpuset), &cpuset)) {
> +		fprintf(stderr, "setting affinity to CPU #%d failed: %d\n",
> +			cpu, errno);
> +		exit(1);
> +	}
> +}
> +
> +static struct bench_state {
> +	int res_cnt;
> +	struct bench_res *results;
> +	pthread_t *consumers;
> +	pthread_t *producers;
> +} state;
> +
> +const struct bench *bench = NULL;
> +
> +extern const struct bench bench_count_global;
> +extern const struct bench bench_count_local;
> +
> +static const struct bench *benchs[] = {
> +	&bench_count_global,
> +	&bench_count_local,
> +};
> +
> +static void setup_benchmark()
> +{
> +	int i, err;
> +
> +	if (!env.bench_name) {
> +		fprintf(stderr, "benchmark name is not specified\n");
> +		exit(1);
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(benchs); i++) {
> +		if (strcmp(benchs[i]->name, env.bench_name) == 0) {
> +			bench = benchs[i];
> +			break;
> +		}
> +	}
> +	if (!bench) {
> +		fprintf(stderr, "benchmark '%s' not found\n", env.bench_name);
> +		exit(1);
> +	}
> +
> +	printf("Setting up benchmark '%s'...\n", bench->name);
> +
> +	state.producers = calloc(env.producer_cnt, sizeof(*state.producers));
> +	state.consumers = calloc(env.consumer_cnt, sizeof(*state.consumers));
> +	state.results = calloc(env.duration_sec + env.warmup_sec + 2,
> +			       sizeof(*state.results));
> +	if (!state.producers || !state.consumers || !state.results)
> +		exit(1);
> +
> +	if (bench->validate)
> +		bench->validate();
> +	if (bench->setup)
> +		bench->setup();
> +
> +	for (i = 0; i < env.consumer_cnt; i++) {
> +		err = pthread_create(&state.consumers[i], NULL,
> +				     bench->consumer_thread, (void *)(long)i);
> +		if (err) {
> +			fprintf(stderr, "failed to create consumer thread #%d: %d\n",
> +				i, -errno);
> +			exit(1);
> +		}
> +		if (env.affinity)
> +			set_thread_affinity(state.consumers[i], i);
> +	}
> +	for (i = 0; i < env.producer_cnt; i++) {
> +		err = pthread_create(&state.producers[i], NULL,
> +				     bench->producer_thread, (void *)(long)i);
> +		if (err) {
> +			fprintf(stderr, "failed to create producer thread #%d: %d\n",
> +				i, -errno);
> +			exit(1);
> +		}
> +		if (env.affinity)
> +			set_thread_affinity(state.producers[i],
> +					    env.consumer_cnt + i);

Here, we bind consumer threads first and then producer threads, I think 
this is probably just arbitrary choice?

In certain cases, I think people may want to have more advanced binding
scenarios, e.g., for hyperthreading, binding consumer and producer on
the same core or different cores etc. One possibility is to introduce
-c option similar to taskset. If -c not supplied, you can have
the current default. Otherwise, using -c list.

> +	}
> +
> +	printf("Benchmark '%s' started.\n", bench->name);
> +}
> +
> +static pthread_mutex_t bench_done_mtx = PTHREAD_MUTEX_INITIALIZER;
> +static pthread_cond_t bench_done = PTHREAD_COND_INITIALIZER;
> +
> +static void collect_measurements(long delta_ns) {
> +	int iter = state.res_cnt++;
> +	struct bench_res *res = &state.results[iter];
> +
> +	bench->measure(res);
> +
> +	if (bench->report_progress)
> +		bench->report_progress(iter, res, delta_ns);
> +
> +	if (iter == env.duration_sec + env.warmup_sec) {
> +		pthread_mutex_lock(&bench_done_mtx);
> +		pthread_cond_signal(&bench_done);
> +		pthread_mutex_unlock(&bench_done_mtx);
> +	}
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	parse_cmdline_args(argc, argv);
> +
> +	if (env.list) {
> +		int i;
> +
> +		printf("Available benchmarks:\n");
> +		for (i = 0; i < ARRAY_SIZE(benchs); i++) {
> +			printf("- %s\n", benchs[i]->name);
> +		}
> +		return 0;
> +	}
> +
> +	setup_benchmark();
> +
> +	setup_timer();
> +
> +	pthread_mutex_lock(&bench_done_mtx);
> +	pthread_cond_wait(&bench_done, &bench_done_mtx);
> +	pthread_mutex_unlock(&bench_done_mtx);
> +
> +	if (bench->report_final)
> +		/* skip first sample */
> +		bench->report_final(state.results + env.warmup_sec,
> +				    state.res_cnt - env.warmup_sec);
> +
> +	return 0;
> +}
> +
> diff --git a/tools/testing/selftests/bpf/bench.h b/tools/testing/selftests/bpf/bench.h
> new file mode 100644
> index 000000000000..08aa0c5b1177
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/bench.h
> @@ -0,0 +1,74 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#pragma once
> +#include <stdlib.h>
> +#include <stdbool.h>
> +#include <linux/err.h>
> +#include <errno.h>
> +#include <unistd.h>
> +#include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
> +#include <math.h>
> +#include <time.h>
> +#include <sys/syscall.h>
> +
> +struct env {
> +	char *bench_name;
> +	int duration_sec;
> +	int warmup_sec;
> +	bool verbose;
> +	bool list;
> +	bool back2back;

seems not used.

> +	bool affinity;
> +	int consumer_cnt;
> +	int producer_cnt;
> +};
> +
> +struct bench_res {
> +	long hits;
> +	long drops;
> +};
> +
> +struct bench {
> +	const char *name;
> +	void (*validate)();
> +	void (*setup)();
> +	void *(*producer_thread)(void *ctx);
> +	void *(*consumer_thread)(void *ctx);
> +	void (*measure)(struct bench_res* res);
> +	void (*report_progress)(int iter, struct bench_res* res, long delta_ns);
> +	void (*report_final)(struct bench_res res[], int res_cnt);
> +};
> +
> +struct counter {
> +	long value;
> +} __attribute__((aligned(128)));
> +
> +extern struct env env;
> +extern const struct bench *bench;
> +
> +void setup_libbpf();
> +void hits_drops_report_progress(int iter, struct bench_res *res, long delta_ns);
> +void hits_drops_report_final(struct bench_res res[], int res_cnt);
> +
> +static inline __u64 get_time_ns() {
> +	struct timespec t;
> +
> +	clock_gettime(CLOCK_MONOTONIC, &t);
> +
> +	return (u64)t.tv_sec * 1000000000 + t.tv_nsec;
> +}
> +
> +static inline void atomic_inc(long *value)
> +{
> +	(void)__atomic_add_fetch(value, 1, __ATOMIC_RELAXED);
> +}
> +
> +static inline void atomic_add(long *value, long n)
> +{
> +	(void)__atomic_add_fetch(value, n, __ATOMIC_RELAXED);
> +}
> +
> +static inline long atomic_swap(long *value, long n)
> +{
> +	return __atomic_exchange_n(value, n, __ATOMIC_RELAXED);
> +}
> diff --git a/tools/testing/selftests/bpf/benchs/bench_count.c b/tools/testing/selftests/bpf/benchs/bench_count.c
> new file mode 100644
> index 000000000000..befba7a82643
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/benchs/bench_count.c
> @@ -0,0 +1,91 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +#include "bench.h"
> +
> +/* COUNT-GLOBAL benchmark */
> +
> +static struct count_global_ctx {
> +	struct counter hits;
> +} count_global_ctx;
> +
> +static void *count_global_producer(void *input)
> +{
> +	struct count_global_ctx *ctx = &count_global_ctx;
> +
> +	while (true) {
> +		atomic_inc(&ctx->hits.value);
> +	}
> +	return NULL;
> +}
> +
> +static void *count_global_consumer(void *input)
> +{
> +	return NULL;
> +}
> +
> +static void count_global_measure(struct bench_res *res)
> +{
> +	struct count_global_ctx *ctx = &count_global_ctx;
> +
> +	res->hits = atomic_swap(&ctx->hits.value, 0);
> +}
> +
> +/* COUNT-local benchmark */
> +
> +static struct count_local_ctx {
> +	struct counter *hits;
> +} count_local_ctx;
> +
> +static void count_local_setup()
> +{
> +	struct count_local_ctx *ctx = &count_local_ctx;
> +
> +	ctx->hits = calloc(env.consumer_cnt, sizeof(*ctx->hits));
> +	if (!ctx->hits)
> +		exit(1);
> +}
> +
> +static void *count_local_producer(void *input)
> +{
> +	struct count_local_ctx *ctx = &count_local_ctx;
> +	int idx = (long)input;
> +
> +	while (true) {
> +		atomic_inc(&ctx->hits[idx].value);
> +	}
> +	return NULL;
> +}
> +
> +static void *count_local_consumer(void *input)
> +{
> +	return NULL;
> +}
> +
> +static void count_local_measure(struct bench_res *res)
> +{
> +	struct count_local_ctx *ctx = &count_local_ctx;
> +	int i;
> +
> +	for (i = 0; i < env.producer_cnt; i++) {
> +		res->hits += atomic_swap(&ctx->hits[i].value, 0);
> +	}
> +}
> +
> +const struct bench bench_count_global = {
> +	.name = "count-global",
> +	.producer_thread = count_global_producer,
> +	.consumer_thread = count_global_consumer,
> +	.measure = count_global_measure,
> +	.report_progress = hits_drops_report_progress,
> +	.report_final = hits_drops_report_final,
> +};
> +
> +const struct bench bench_count_local = {
> +	.name = "count-local",
> +	.setup = count_local_setup,
> +	.producer_thread = count_local_producer,
> +	.consumer_thread = count_local_consumer,
> +	.measure = count_local_measure,
> +	.report_progress = hits_drops_report_progress,
> +	.report_final = hits_drops_report_final,
> +};
> 
