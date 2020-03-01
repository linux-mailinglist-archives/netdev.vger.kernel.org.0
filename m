Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51463174AEF
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 04:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbgCADxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 22:53:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65364 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727242AbgCADxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 22:53:19 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0213njN2002497;
        Sat, 29 Feb 2020 19:53:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=4gECi0zz7283KsYypyhNf0hBR66HOa6EZF6ieZ2nbok=;
 b=Zs0tTDZj+53ApTPe9mkhfV1AgmcIc/1byCJEAWXYTWttmxEiHo8BcQKyQt5E7fdIs0sc
 tt9RH+UFtRqWyRF5IDShaYCWCQf9sk+Qb0a3TcFxMAVrhkC1oqSQJIv8rutc+keLS3hD
 z0f9fezkstZeA3G0o5XTbjxUHx2lqmmh9Yc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yfnxqak4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 29 Feb 2020 19:53:01 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sat, 29 Feb 2020 19:53:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YgHV9Tgy1GX+QZ5RsTZrprUgLuPVbw7L7kPEV6f//ddEFCakg54Gdo/1t2i5ioT2pUp94SPUYlR9w9/4kWyJ3fcCCNTfPpJKJrOhHK6/1K8ybd5Hm5CPIiJWTO8SiRWbLXglzBZV25FhwjvgIhwT8XpcPdWLWBc6k4fZR1C8te0wcxyO+faInbpJD34DWuCw7miidmyZmolSU32h69WLU3nlm6mslpBw87Q0P5tN3EU2vE5G1EjcreGRr3//V76+zITliaGK81NPNwG5+jEeL18bLcrqTQwRlUQJrWa5GG/p9UI+aOzhemYAkaavo2t3+g6Mi+UQXVZ9NBenu2B9nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gECi0zz7283KsYypyhNf0hBR66HOa6EZF6ieZ2nbok=;
 b=hspClknY8Y/wYVHEYnIUxQ7IjBXLG7T7NYAvbpqrzyCkT+f4ZMuN/Mm3kMPE9SqE7j8ZhZcsvaGiWS5z+wq74xa6a968nyNhm7vFE0Q7sYaRYBlo9JcP67nBgUh3zBkyKpSRPxoIhzu8prwehZk/IfLfvT+AciVpcvsmTSsrEsc7c0JWW3dqOABT/6BRH3gUBeSlNu/fYuxTq8vpBW2jgcUUI9/6dbXVl3EB5Q+QJrNgDinlWb4JD5sTRFJ13LHH56qILQ5yyVb8amb9CtEmHidtjllrCI2ovy9RtBcZ4nmXTIEFVw95QxN1u0bJZ7TNcLKCIjHaXGDVwWZwiKC9/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gECi0zz7283KsYypyhNf0hBR66HOa6EZF6ieZ2nbok=;
 b=etjdKxfNeJG34/0UKMyT3R0t4Z8jNVAtUD8gOeC/bGdsKoasmK5dAGvEzcGqIw5f5h+aAc0f3+ORYrCqsz8/DXehQJxWnis3hxo4e8e33TLM/pNiVtLLFOwDkE2zF6b83Xpt52anvslg0IqRThkLR0L4cZ/wbZiSrKP4QilF4Bk=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (2603:10b6:5:13c::16)
 by DM6PR15MB3563.namprd15.prod.outlook.com (2603:10b6:5:1d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18; Sun, 1 Mar
 2020 03:52:57 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2772.019; Sun, 1 Mar 2020
 03:52:57 +0000
Subject: Re: [PATCH v2 bpf-next 1/2] bpftool: introduce "prog profile" command
To:     Song Liu <songliubraving@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <arnaldo.melo@gmail.com>, <jolsa@kernel.org>
References: <20200228234058.634044-1-songliubraving@fb.com>
 <20200228234058.634044-2-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <07478dd7-99e2-3399-3c75-db83a283e754@fb.com>
Date:   Sat, 29 Feb 2020 19:52:52 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <20200228234058.634044-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR14CA0056.namprd14.prod.outlook.com
 (2603:10b6:300:81::18) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:9248) by MWHPR14CA0056.namprd14.prod.outlook.com (2603:10b6:300:81::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18 via Frontend Transport; Sun, 1 Mar 2020 03:52:55 +0000
X-Originating-IP: [2620:10d:c090:400::5:9248]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 267a3f0d-5062-42a4-fc5a-08d7bd9406e3
X-MS-TrafficTypeDiagnostic: DM6PR15MB3563:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB3563D99A7E0737465313B543D3E60@DM6PR15MB3563.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0329B15C8A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(136003)(396003)(346002)(376002)(39860400002)(199004)(189003)(6486002)(316002)(5660300002)(66946007)(4326008)(6512007)(16526019)(6666004)(31686004)(30864003)(86362001)(66556008)(53546011)(52116002)(478600001)(81166006)(66476007)(8676002)(81156014)(186003)(36756003)(2616005)(8936002)(6506007)(2906002)(31696002)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3563;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jKPikqGJS6YB+LfTRXatKA2S227KfeKfMHuQC/NCZAyX6rr59gY+iFCLx5Nyrv66H0oXWCD0XAZe4JCTZ+RYceOSqsxv0ALR7+4vQ2qgWsvMZj1DpqBuPOlVIU406+kx3904v7Iq9rAMFHZxb35ywjUiEw92XSyfzybY8lH5gNk+zQI4tBI79NbdsLrU7oVrcvaxVY6ZWL51CoepkWK0Nyw/CKIsuVYHRPJSJOizQR7JTrM0Yymj5bh3mMSIoSzWbag9m/8H8Si/EWL0G9gfXgsBPCPVZB95tTH92w1Mq0Xch492OaR4wRzRXGaQEptTDjqkifEae2x+FtjrrqJTCg1/S3C2exo82dPzK1m0LTlA2nHlzEWjEbdXXx1E6iKZkML3FXXZcFv0Wk586BERSxeUF4tClLxcLb82uhN2IaSQ6r61YznIXO0GcysIMj/y8b3YA2EGI+dqALNjKNrvDKwKs4U/K50fOKoQNC/d8Lv7Ag7uypb62HEWHgnZSqZg
X-MS-Exchange-AntiSpam-MessageData: VzW86yyPGvM+wlhOJZyO16+FSBW+OxIlv5x1p3071uUOrP1mpRRn2P8iVHeba+Psu+/3bXrh0fpYmg3Mr52DTIBCXx4aS/uhbQaGALS2KwYHAKtDBVYUYzyWaXnTrY17EpZh0oJVRxRRfzXUorQ3SeIq+RWWY8/7FCGknJc1W5QXPgIdC6PSyQXEfGPnrSR+
X-MS-Exchange-CrossTenant-Network-Message-Id: 267a3f0d-5062-42a4-fc5a-08d7bd9406e3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2020 03:52:56.8826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NeKwN+WZpe9Xtqz9PJDRmzp8nmz3pa0YubIEehfTkBf1bziC7nDy6GNN/VQeTqG/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3563
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-29_09:2020-02-28,2020-02-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 suspectscore=2 impostorscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003010028
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/28/20 3:40 PM, Song Liu wrote:
> With fentry/fexit programs, it is possible to profile BPF program with
> hardware counters. Introduce bpftool "prog profile", which measures key
> metrics of a BPF program.
> 
> bpftool prog profile command creates per-cpu perf events. Then it attaches
> fentry/fexit programs to the target BPF program. The fentry program saves
> perf event value to a map. The fexit program reads the perf event again,
> and calculates the difference, which is the instructions/cycles used by
> the target program.
> 
> Example input and output:
> 
>    ./bpftool prog profile 3 id 337 cycles instructions llc_misses
> 
>          4228 run_cnt
>       3403698 cycles                                              (84.08%)
>       3525294 instructions   #  1.04 insn per cycle               (84.05%)
>            13 llc_misses     #  3.69 LLC misses per million isns  (83.50%)
> 
> This command measures cycles and instructions for BPF program with id
> 337 for 3 seconds. The program has triggered 4228 times. The rest of the
> output is similar to perf-stat. In this example, the counters were only
> counting ~84% of the time because of time multiplexing of perf counters.
> 
> Note that, this approach measures cycles and instructions in very small
> increments. So the fentry/fexit programs introduce noticeable errors to
> the measurement results.
> 
> The fentry/fexit programs are generated with BPF skeletons. Therefore, we
> build bpftool twice. The first time _bpftool is built without skeletons.
> Then, _bpftool is used to generate the skeletons. The second time, bpftool
> is built with skeletons.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   tools/bpf/bpftool/Makefile                |  18 +
>   tools/bpf/bpftool/prog.c                  | 428 +++++++++++++++++++++-
>   tools/bpf/bpftool/skeleton/profiler.bpf.c | 171 +++++++++
>   tools/bpf/bpftool/skeleton/profiler.h     |  47 +++
>   tools/scripts/Makefile.include            |   1 +
>   5 files changed, 664 insertions(+), 1 deletion(-)
>   create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
>   create mode 100644 tools/bpf/bpftool/skeleton/profiler.h
> 
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index c4e810335810..c035fc107027 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -59,6 +59,7 @@ LIBS = $(LIBBPF) -lelf -lz
>   
>   INSTALL ?= install
>   RM ?= rm -f
> +CLANG ?= clang
>   
>   FEATURE_USER = .bpftool
>   FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
> @@ -110,6 +111,22 @@ SRCS += $(BFD_SRCS)
>   endif
>   
>   OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
> +_OBJS = $(filter-out $(OUTPUT)prog.o,$(OBJS)) $(OUTPUT)_prog.o
> +
> +$(OUTPUT)_prog.o: prog.c
> +	$(QUIET_CC)$(COMPILE.c) -MMD -DBPFTOOL_WITHOUT_SKELETONS -o $@ $<
> +
> +$(OUTPUT)_bpftool: $(_OBJS) $(LIBBPF)
> +	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(_OBJS) $(LIBS)
> +
> +skeleton/profiler.bpf.o: skeleton/profiler.bpf.c
> +	$(QUIET_CLANG)$(CLANG) -g -O2 -target bpf -c $< -o $@

With a fresh checkout, applying this patch and just selftests like
   make -C tools/testing/selftests/bpf

I got the following build error:

make[2]: Leaving directory `/data/users/yhs/work/net-next/tools/lib/bpf'
clang -g -O2 -target bpf -c skeleton/profiler.bpf.c -o 
skeleton/profiler.bpf.o
skeleton/profiler.bpf.c:5:10: fatal error: 'bpf/bpf_helpers.h' file not 
found
#include <bpf/bpf_helpers.h>
          ^~~~~~~~~~~~~~~~~~~
1 error generated.
make[1]: *** [skeleton/profiler.bpf.o] Error 1

I think Makefile should be tweaked to avoid selftest failure.

> +
> +profiler.skel.h: $(OUTPUT)_bpftool skeleton/profiler.bpf.o
> +	$(QUIET_GEN)$(OUTPUT)./_bpftool gen skeleton skeleton/profiler.bpf.o > $@
> +
> +$(OUTPUT)prog.o: prog.c profiler.skel.h
> +	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
>   
>   $(OUTPUT)disasm.o: $(srctree)/kernel/bpf/disasm.c
>   	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
> @@ -125,6 +142,7 @@ $(OUTPUT)%.o: %.c
>   clean: $(LIBBPF)-clean
>   	$(call QUIET_CLEAN, bpftool)
>   	$(Q)$(RM) -- $(OUTPUT)bpftool $(OUTPUT)*.o $(OUTPUT)*.d
> +	$(Q)$(RM) -- $(OUTPUT)_bpftool profiler.skel.h skeleton/profiler.bpf.o
>   	$(Q)$(RM) -r -- $(OUTPUT)libbpf/
>   	$(call QUIET_CLEAN, core-gen)
>   	$(Q)$(RM) -- $(OUTPUT)FEATURE-DUMP.bpftool
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index 1996e67a2f00..39f0f14464ad 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -10,12 +10,16 @@
>   #include <string.h>
>   #include <time.h>
>   #include <unistd.h>
> +#include <signal.h>
>   #include <net/if.h>
>   #include <sys/types.h>
>   #include <sys/stat.h>
> +#include <sys/ioctl.h>
> +#include <sys/syscall.h>
>   
>   #include <linux/err.h>
>   #include <linux/sizes.h>
> +#include <linux/perf_event.h>
>   
>   #include <bpf/bpf.h>
>   #include <bpf/btf.h>
> @@ -1537,6 +1541,425 @@ static int do_loadall(int argc, char **argv)
>   	return load_with_options(argc, argv, false);
>   }
>   
> +#ifdef BPFTOOL_WITHOUT_SKELETONS
> +
> +static int do_profile(int argc, char **argv)
> +{
> +	return 0;
> +}
> +
> +#else /* BPFTOOL_WITHOUT_SKELETONS */
> +
> +#include "profiler.skel.h"
> +
> +#define SAMPLE_PERIOD  0x7fffffffffffffffULL
> +struct profile_metric {
> +	const char *name;
> +	struct perf_event_attr attr;
> +	bool selected;
> +	struct bpf_perf_event_value val;
> +
> +	/* calculate ratios like instructions per cycle */
> +	const int ratio_metric; /* 0 for N/A, 1 for index 0 (cycles)  */
> +	const float ratio_mul;
> +	const char *ratio_desc;
> +} metrics[] = {
> +	{
> +		.name = "cycles",
> +		.attr = {
> +			.freq = 0,
> +			.sample_period = SAMPLE_PERIOD,
> +			.inherit = 0,
> +			.type = PERF_TYPE_HARDWARE,
> +			.read_format = 0,
> +			.sample_type = 0,
> +			.config = PERF_COUNT_HW_CPU_CYCLES,
> +		},
> +	},
> +	{
> +		.name = "instructions",
> +		.attr = {
> +			.freq = 0,
> +			.sample_period = SAMPLE_PERIOD,
> +			.inherit = 0,
> +			.type = PERF_TYPE_HARDWARE,
> +			.read_format = 0,
> +			.sample_type = 0,
> +			.config = PERF_COUNT_HW_INSTRUCTIONS,
> +		},
> +		.ratio_metric = 1,
> +		.ratio_mul = 1.0,
> +		.ratio_desc = "insn per cycle",
> +	},
> +	{
> +		.name = "l1d_loads",
> +		.attr = {
> +			.freq = 0,
> +			.sample_period = SAMPLE_PERIOD,
> +			.inherit = 0,
> +			.type = PERF_TYPE_HW_CACHE,
> +			.read_format = 0,
> +			.sample_type = 0,
> +			.config =
> +				PERF_COUNT_HW_CACHE_L1D |
> +				(PERF_COUNT_HW_CACHE_OP_READ << 8) |
> +				(PERF_COUNT_HW_CACHE_RESULT_ACCESS << 16),
> +		},
> +	},
> +	{
> +		.name = "llc_misses",
> +		.attr = {
> +			.freq = 0,
> +			.sample_period = SAMPLE_PERIOD,
> +			.inherit = 0,
> +			.type = PERF_TYPE_HW_CACHE,
> +			.read_format = 0,
> +			.sample_type = 0,
> +			.config =
> +				PERF_COUNT_HW_CACHE_LL |
> +				(PERF_COUNT_HW_CACHE_OP_READ << 8) |
> +				(PERF_COUNT_HW_CACHE_RESULT_MISS << 16),
> +		},
> +		.ratio_metric = 2,
> +		.ratio_mul = 1e6,
> +		.ratio_desc = "LLC misses per million isns",
> +	},
> +};
> +
> +u64 profile_total_count;
> +
> +#define MAX_NUM_PROFILE_METRICS 4
> +
> +static int profile_parse_metrics(int argc, char **argv)
> +{
> +	unsigned int metric_cnt;
> +	int selected_cnt = 0;
> +	unsigned int i;
> +
> +	metric_cnt = sizeof(metrics) / sizeof(struct profile_metric);
> +
> +	while (argc > 0) {
> +		for (i = 0; i < metric_cnt; i++) {
> +			if (strcmp(argv[0], metrics[i].name) == 0) {
> +				if (!metrics[i].selected)
> +					selected_cnt++;
> +				metrics[i].selected = true;
> +				break;
> +			}
> +		}
> +		if (i == metric_cnt) {
> +			p_err("unknown metric %s", argv[0]);
> +			return -1;
> +		}
> +		NEXT_ARG();
> +	}
> +	if (selected_cnt > MAX_NUM_PROFILE_METRICS) {
> +		p_err("too many (%d) metrics, please specify no more than %d metrics at at time",
> +		      selected_cnt, MAX_NUM_PROFILE_METRICS);
> +		return -1;
> +	}
> +	return selected_cnt;
> +}
> +
> +static void profile_read_values(struct profiler_bpf *obj)
> +{
> +	u32 m, cpu, num_cpu = obj->rodata->num_cpu;
> +	u64 counts[num_cpu];
> +	int reading_map_fd, count_map_fd;
> +	u32 key = 0;
> +
> +	reading_map_fd = bpf_map__fd(obj->maps.accum_readings);
> +	count_map_fd = bpf_map__fd(obj->maps.counts);
> +	if (reading_map_fd < 0 || count_map_fd < 0) {
> +		p_err("failed to get fd for map");
> +		return;
> +	}
> +
> +	assert(bpf_map_lookup_elem(count_map_fd, &key, counts) == 0);
> +	profile_total_count = 0;
> +	for (cpu = 0; cpu < num_cpu; cpu++)
> +		profile_total_count += counts[cpu];
> +
> +	for (m = 0; m < ARRAY_SIZE(metrics); m++) {
> +		struct bpf_perf_event_value values[obj->rodata->num_cpu];
> +
> +		if (!metrics[m].selected)
> +			continue;
> +
> +		assert(bpf_map_lookup_elem(reading_map_fd, &key, values) == 0);
> +		for (cpu = 0; cpu < num_cpu; cpu++) {
> +			metrics[m].val.counter += values[cpu].counter;
> +			metrics[m].val.enabled += values[cpu].enabled;
> +			metrics[m].val.running += values[cpu].running;
> +		}
> +		key++;
> +	}
> +}
> +
> +static void profile_print_readings_json(void)
> +{
> +	u32 m;
> +
> +	jsonw_start_array(json_wtr);
> +	for (m = 0; m < ARRAY_SIZE(metrics); m++) {
> +		if (!metrics[m].selected)
> +			continue;
> +		jsonw_start_object(json_wtr);
> +		jsonw_string_field(json_wtr, "metric", metrics[m].name);
> +		jsonw_lluint_field(json_wtr, "run_cnt", profile_total_count);
> +		jsonw_lluint_field(json_wtr, "value", metrics[m].val.counter);
> +		jsonw_lluint_field(json_wtr, "enabled", metrics[m].val.enabled);
> +		jsonw_lluint_field(json_wtr, "running", metrics[m].val.running);
> +
> +		jsonw_end_object(json_wtr);
> +	}
> +	jsonw_end_array(json_wtr);
> +}
> +
> +static void profile_print_readings_plain(void)
> +{
> +	u32 m;
> +
> +	printf("\n%18lu %-20s\n", profile_total_count, "run_cnt");
> +	for (m = 0; m < ARRAY_SIZE(metrics); m++) {
> +		struct bpf_perf_event_value *val = &metrics[m].val;
> +		int r;
> +
> +		if (!metrics[m].selected)
> +			continue;
> +		printf("%18llu %-20s", val->counter, metrics[m].name);
> +
> +		r = metrics[m].ratio_metric - 1;
> +		if (r >= 0 && metrics[r].selected) {
> +			printf("# %8.2f %-30s",
> +			       val->counter * metrics[m].ratio_mul /
> +			       metrics[r].val.counter,
> +			       metrics[m].ratio_desc);
> +		} else {
> +			printf("%-41s", "");
> +		}
> +
> +		if (val->enabled > val->running)
> +			printf("(%4.2f%%)",
> +			       val->running * 100.0 / val->enabled);
> +		printf("\n");
> +	}
> +}
> +
> +static void profile_print_readings(void)
> +{
> +	if (json_output)
> +		profile_print_readings_json();
> +	else
> +		profile_print_readings_plain();
> +}
> +
> +static void profile_close_perf_events(struct profiler_bpf *obj)
> +{
> +	int map_fd, pmu_fd;
> +	u32 i;
> +
> +	map_fd = bpf_map__fd(obj->maps.events);
> +	if (map_fd < 0) {
> +		p_err("failed to get fd for events map");
> +		return;
> +	}
> +
> +	for (i = 0; i < obj->rodata->num_cpu * obj->rodata->num_metric; i++) {
> +		bpf_map_lookup_elem(map_fd, &i, &pmu_fd);
> +		close(pmu_fd);
> +	}
> +}
> +
> +static int profile_open_perf_events(struct profiler_bpf *obj)
> +{
> +	int map_fd, pmu_fd, i, key = 0;
> +	unsigned int cpu, m;
> +
> +	map_fd = bpf_map__fd(obj->maps.events);
> +	if (map_fd < 0) {
> +		p_err("failed to get fd for events map");
> +		return -1;
> +	}
> +
> +	for (m = 0; m < ARRAY_SIZE(metrics); m++) {
> +		if (!metrics[m].selected)
> +			continue;
> +		for (cpu = 0; cpu < obj->rodata->num_cpu; cpu++) {
> +			pmu_fd = syscall(__NR_perf_event_open, &metrics[m].attr,
> +					 -1/*pid*/, cpu, -1/*group_fd*/, 0);
> +			if (pmu_fd < 0 ||
> +			    bpf_map_update_elem(map_fd, &key,
> +						&pmu_fd, BPF_ANY) ||
> +			    ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0)) {
> +				p_err("failed to create event %s on cpu %d",
> +				      metrics[m].name, cpu);
> +				goto err;
> +			}
> +			key++;
> +		}
> +	}
> +	return 0;
> +err:
> +	for (i = key - 1; i >= 0; i--) {
> +		bpf_map_lookup_elem(map_fd, &i, &pmu_fd);
> +		close(pmu_fd);
> +	}
> +	return -1;
> +}
> +
> +static char *profile_target_name(int tgt_fd)
> +{
> +	struct bpf_prog_info_linear *info_linear;
> +	struct bpf_func_info *func_info;
> +	const struct btf_type *t;
> +	char *name = NULL;
> +	struct btf *btf;
> +
> +	info_linear = bpf_program__get_prog_info_linear(
> +		tgt_fd, 1UL << BPF_PROG_INFO_FUNC_INFO);
> +	if (IS_ERR_OR_NULL(info_linear)) {
> +		p_err("failed to get info_linear for prog FD %d", tgt_fd);
> +		return NULL;
> +	}
> +
> +	if (info_linear->info.btf_id == 0 ||
> +	    btf__get_from_id(info_linear->info.btf_id, &btf)) {
> +		p_err("prog FD %d doesn't have valid btf", tgt_fd);
> +		goto out;
> +	}
> +
> +	func_info = (struct bpf_func_info *)(info_linear->info.func_info);
> +	t = btf__type_by_id(btf, func_info[0].type_id);
> +	if (!t) {
> +		p_err("btf %d doesn't have type %d",
> +		      info_linear->info.btf_id, func_info[0].type_id);
> +		goto out;
> +	}
> +	name = strdup(btf__name_by_offset(btf, t->name_off));
> +out:
> +	free(info_linear);
> +	return name;
> +}
> +
> +struct profiler_bpf *profile_obj;
> +int profile_tgt_fd = -1;
> +char *profile_tgt_name;
> +
> +static void profile_print_and_cleanup(void)
> +{
> +	profile_close_perf_events(profile_obj);
> +	profiler_bpf__detach(profile_obj);
> +	profile_read_values(profile_obj);
> +	profiler_bpf__destroy(profile_obj);
> +	profile_print_readings();
> +
> +	if (profile_tgt_fd >= 0)
> +		close(profile_tgt_fd);
> +	free(profile_tgt_name);
> +}
> +
> +#define PROFILE_DEFAULT_LONG_DURATION (3600 * 24)
> +
> +static void int_exit(int signo)
> +{
> +	profile_print_and_cleanup();
> +	exit(0);
> +}
> +
> +static int do_profile(int argc, char **argv)
> +{
> +	int num_metric, num_cpu, err = -1;
> +	struct bpf_program *prog;
> +	unsigned long duration;
> +	char *endptr;
> +
> +	/* we at least need: <duration>, "id", <id>, <metric> */
> +	if (argc < 4)
> +		usage();
> +
> +	/* parse profiling duration */
> +	duration = strtoul(*argv, &endptr, 0);
> +	if (*endptr)
> +		duration = PROFILE_DEFAULT_LONG_DURATION;
> +	else
> +		NEXT_ARG();
> +
> +	/* parse target fd */
> +	profile_tgt_fd = prog_parse_fd(&argc, &argv);
> +	if (profile_tgt_fd < 0) {
> +		p_err("failed to parse fd");
> +		return -1;
> +	}
> +
> +	num_metric = profile_parse_metrics(argc, argv);
> +	if (num_metric <= 0)
> +		goto out;
> +
> +	num_cpu = libbpf_num_possible_cpus();
> +	if (num_cpu <= 0) {
> +		p_err("failed to identify number of CPUs");
> +		goto out;
> +	}
> +
> +	profile_obj = profiler_bpf__open();
> +	if (!profile_obj) {
> +		p_err("failed to open and/or load BPF object");
> +		goto out;
> +	}
> +
> +	profile_obj->rodata->num_cpu = num_cpu;
> +	profile_obj->rodata->num_metric = num_metric;
> +
> +	/* adjust map sizes */
> +	bpf_map__resize(profile_obj->maps.events, num_metric * num_cpu);
> +	bpf_map__resize(profile_obj->maps.fentry_readings, num_metric);
> +	bpf_map__resize(profile_obj->maps.accum_readings, num_metric);
> +	bpf_map__resize(profile_obj->maps.counts, 1);
> +
> +	/* change target name */
> +	profile_tgt_name = profile_target_name(profile_tgt_fd);
> +	if (!profile_tgt_name) {
> +		p_err("failed to load target function name");
> +		goto out;
> +	}
> +
> +	bpf_object__for_each_program(prog, profile_obj->obj) {
> +		err = bpf_program__set_attach_target(prog, profile_tgt_fd,
> +						     profile_tgt_name);
> +		if (err) {
> +			p_err("failed to set attach target\n");
> +			goto out;
> +		}
> +	}
> +
> +	set_max_rlimit();
> +	err = profiler_bpf__load(profile_obj);
> +	if (err) {
> +		p_err("failed to load profile_obj");
> +		goto out;
> +	}
> +
> +	profile_open_perf_events(profile_obj);
> +
> +	err = profiler_bpf__attach(profile_obj);
> +	if (err) {
> +		p_err("failed to attach profile_obj");
> +		goto out;
> +	}
> +	signal(SIGINT, int_exit);
> +
> +	sleep(duration);
> +	profile_print_and_cleanup();
> +	return 0;
> +out:
> +	close(profile_tgt_fd);
> +	free(profile_tgt_name);
> +	return err;
> +}
> +
> +#endif /* BPFTOOL_WITHOUT_SKELETONS */
> +
>   static int do_help(int argc, char **argv)
>   {
>   	if (json_output) {
> @@ -1560,6 +1983,7 @@ static int do_help(int argc, char **argv)
>   		"                         [data_out FILE [data_size_out L]] \\\n"
>   		"                         [ctx_in FILE [ctx_out FILE [ctx_size_out M]]] \\\n"
>   		"                         [repeat N]\n"
> +		"       %s %s profile [DURATION] PROG METRICs\n"
>   		"       %s %s tracelog\n"
>   		"       %s %s help\n"
>   		"\n"
> @@ -1578,11 +2002,12 @@ static int do_help(int argc, char **argv)
>   		"       ATTACH_TYPE := { msg_verdict | stream_verdict | stream_parser |\n"
>   		"                        flow_dissector }\n"
>   		"       " HELP_SPEC_OPTIONS "\n"
> +		"       METRIC := { cycles | instructions | l1d_loads | llc_misses }\n"
>   		"",
>   		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
>   		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
>   		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
> -		bin_name, argv[-2]);
> +		bin_name, argv[-2], bin_name, argv[-2]);
>   
>   	return 0;
>   }
> @@ -1599,6 +2024,7 @@ static const struct cmd cmds[] = {
>   	{ "detach",	do_detach },
>   	{ "tracelog",	do_tracelog },
>   	{ "run",	do_run },
> +	{ "profile",	do_profile },
>   	{ 0 }
>   };
>   
> diff --git a/tools/bpf/bpftool/skeleton/profiler.bpf.c b/tools/bpf/bpftool/skeleton/profiler.bpf.c
> new file mode 100644
> index 000000000000..abd3a7aacc1f
> --- /dev/null
> +++ b/tools/bpf/bpftool/skeleton/profiler.bpf.c
> @@ -0,0 +1,171 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +#include "profiler.h"
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#define ___bpf_concat(a, b) a ## b
> +#define ___bpf_apply(fn, n) ___bpf_concat(fn, n)
> +#define ___bpf_nth(_, _1, _2, _3, _4, _5, _6, _7, _8, _9, _a, _b, _c, N, ...) N
> +#define ___bpf_narg(...) \
> +	___bpf_nth(_, ##__VA_ARGS__, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
> +#define ___bpf_empty(...) \
> +	___bpf_nth(_, ##__VA_ARGS__, N, N, N, N, N, N, N, N, N, N, 0)
> +
> +#define ___bpf_ctx_cast0() ctx
> +#define ___bpf_ctx_cast1(x) ___bpf_ctx_cast0(), (void *)ctx[0]
> +#define ___bpf_ctx_cast2(x, args...) ___bpf_ctx_cast1(args), (void *)ctx[1]
> +#define ___bpf_ctx_cast3(x, args...) ___bpf_ctx_cast2(args), (void *)ctx[2]
> +#define ___bpf_ctx_cast4(x, args...) ___bpf_ctx_cast3(args), (void *)ctx[3]
> +#define ___bpf_ctx_cast5(x, args...) ___bpf_ctx_cast4(args), (void *)ctx[4]
> +#define ___bpf_ctx_cast6(x, args...) ___bpf_ctx_cast5(args), (void *)ctx[5]
> +#define ___bpf_ctx_cast7(x, args...) ___bpf_ctx_cast6(args), (void *)ctx[6]
> +#define ___bpf_ctx_cast8(x, args...) ___bpf_ctx_cast7(args), (void *)ctx[7]
> +#define ___bpf_ctx_cast9(x, args...) ___bpf_ctx_cast8(args), (void *)ctx[8]
> +#define ___bpf_ctx_cast10(x, args...) ___bpf_ctx_cast9(args), (void *)ctx[9]
> +#define ___bpf_ctx_cast11(x, args...) ___bpf_ctx_cast10(args), (void *)ctx[10]
> +#define ___bpf_ctx_cast12(x, args...) ___bpf_ctx_cast11(args), (void *)ctx[11]
> +#define ___bpf_ctx_cast(args...) \
> +	___bpf_apply(___bpf_ctx_cast, ___bpf_narg(args))(args)
> +
> +/*
> + * BPF_PROG is a convenience wrapper for generic tp_btf/fentry/fexit and
> + * similar kinds of BPF programs, that accept input arguments as a single
> + * pointer to untyped u64 array, where each u64 can actually be a typed
> + * pointer or integer of different size. Instead of requring user to write
> + * manual casts and work with array elements by index, BPF_PROG macro
> + * allows user to declare a list of named and typed input arguments in the
> + * same syntax as for normal C function. All the casting is hidden and
> + * performed transparently, while user code can just assume working with
> + * function arguments of specified type and name.
> + *
> + * Original raw context argument is preserved as well as 'ctx' argument.
> + * This is useful when using BPF helpers that expect original context
> + * as one of the parameters (e.g., for bpf_perf_event_output()).
> + */
> +#define BPF_PROG(name, args...)						    \
> +name(unsigned long long *ctx);						    \
> +static __always_inline typeof(name(0))					    \
> +____##name(unsigned long long *ctx, ##args);				    \
> +typeof(name(0)) name(unsigned long long *ctx)				    \
> +{									    \
> +	_Pragma("GCC diagnostic push")					    \
> +	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
> +	return ____##name(___bpf_ctx_cast(args));			    \
> +	_Pragma("GCC diagnostic pop")					    \
> +}									    \
> +static __always_inline typeof(name(0))					    \
> +____##name(unsigned long long *ctx, ##args)
> +
> +/* map of perf event fds, num_cpu * num_metric entries */
> +struct {
> +	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
> +	__uint(key_size, sizeof(u32));
> +	__uint(value_size, sizeof(int));
> +} events SEC(".maps");
> +
> +/* readings at fentry */
> +struct {
> +	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +	__uint(key_size, sizeof(u32));
> +	__uint(value_size, sizeof(struct bpf_perf_event_value));
> +} fentry_readings SEC(".maps");
> +
> +/* accumulated readings */
> +struct {
> +	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +	__uint(key_size, sizeof(u32));
> +	__uint(value_size, sizeof(struct bpf_perf_event_value));
> +} accum_readings SEC(".maps");
> +
> +/* sample counts, one per cpu */
> +struct {
> +	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +	__uint(key_size, sizeof(u32));
> +	__uint(value_size, sizeof(u64));
> +} counts SEC(".maps");
> +
> +const volatile __u32 num_cpu = 1;
> +const volatile __u32 num_metric = 1;
> +#define MAX_NUM_MATRICS 4
> +
> +SEC("fentry/XXX")
> +int BPF_PROG(fentry_XXX)
> +{
> +	struct bpf_perf_event_value *ptrs[MAX_NUM_MATRICS];
> +	u32 key = bpf_get_smp_processor_id();
> +	u32 i;
> +
> +	/* look up before reading, to reduce error */
> +	for (i = 0; i < num_metric && i < MAX_NUM_MATRICS; i++) {
> +		u32 flag = i;
> +
> +		ptrs[i] = bpf_map_lookup_elem(&fentry_readings, &flag);
> +		if (!ptrs[i])
> +			return 0;
> +	}
> +
> +	for (i = 0; i < num_metric && i < MAX_NUM_MATRICS; i++) {
> +		struct bpf_perf_event_value reading;
> +		int err;
> +
> +		err = bpf_perf_event_read_value(&events, key, &reading,
> +						sizeof(reading));
> +		if (err)
> +			return 0;
> +		*(ptrs[i]) = reading;
> +		key += num_cpu;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline void
> +fexit_update_maps(u32 id, struct bpf_perf_event_value *after)
> +{
> +	struct bpf_perf_event_value *before, diff, *accum;
> +
> +	before = bpf_map_lookup_elem(&fentry_readings, &id);
> +	/* only account samples with a valid fentry_reading */
> +	if (before && before->counter) {
> +		struct bpf_perf_event_value *accum;
> +
> +		diff.counter = after->counter - before->counter;
> +		diff.enabled = after->enabled - before->enabled;
> +		diff.running = after->running - before->running;
> +
> +		accum = bpf_map_lookup_elem(&accum_readings, &id);
> +		if (accum) {
> +			accum->counter += diff.counter;
> +			accum->enabled += diff.enabled;
> +			accum->running += diff.running;
> +		}
> +	}
> +}
> +
> +SEC("fexit/XXX")
> +int BPF_PROG(fexit_XXX)
> +{
> +	struct bpf_perf_event_value readings[MAX_NUM_MATRICS];
> +	u32 cpu = bpf_get_smp_processor_id();
> +	u32 i, one = 1, zero = 0;
> +	int err;
> +	u64 *count;
> +
> +	/* read all events before updating the maps, to reduce error */
> +	for (i = 0; i < num_metric && i < MAX_NUM_MATRICS; i++) {
> +		err = bpf_perf_event_read_value(&events, cpu + i * num_cpu,
> +						readings + i, sizeof(*readings));
> +		if (err)
> +			return 0;
> +	}
> +	count = bpf_map_lookup_elem(&counts, &zero);
> +	if (count) {
> +		*count += 1;
> +		for (i = 0; i < num_metric && i < MAX_NUM_MATRICS; i++)
> +			fexit_update_maps(i, &readings[i]);
> +	}
> +	return 0;
> +}
> +
> +char LICENSE[] SEC("license") = "GPL";
> diff --git a/tools/bpf/bpftool/skeleton/profiler.h b/tools/bpf/bpftool/skeleton/profiler.h
> new file mode 100644
> index 000000000000..ae15cb0c4d43
> --- /dev/null
> +++ b/tools/bpf/bpftool/skeleton/profiler.h
> @@ -0,0 +1,47 @@
> +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> +#ifndef __PROFILER_H
> +#define __PROFILER_H
> +
> +/* useful typedefs from vimlinux.h */
> +
> +typedef signed char __s8;
> +typedef unsigned char __u8;
> +typedef short int __s16;
> +typedef short unsigned int __u16;
> +typedef int __s32;
> +typedef unsigned int __u32;
> +typedef long long int __s64;
> +typedef long long unsigned int __u64;
> +
> +typedef __s8 s8;
> +typedef __u8 u8;
> +typedef __s16 s16;
> +typedef __u16 u16;
> +typedef __s32 s32;
> +typedef __u32 u32;
> +typedef __s64 s64;
> +typedef __u64 u64;
> +
> +enum {
> +	false = 0,
> +	true = 1,
> +};
> +
> +#ifdef __CHECKER__
> +#define __bitwise__ __attribute__((bitwise))
> +#else
> +#define __bitwise__
> +#endif
> +#define __bitwise __bitwise__
> +
> +typedef __u16 __bitwise __le16;
> +typedef __u16 __bitwise __be16;
> +typedef __u32 __bitwise __le32;
> +typedef __u32 __bitwise __be32;
> +typedef __u64 __bitwise __le64;
> +typedef __u64 __bitwise __be64;
> +
> +typedef __u16 __bitwise __sum16;
> +typedef __u32 __bitwise __wsum;
> +
> +#endif /* __PROFILER_H */
> diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
> index ded7a950dc40..59f31f01cb93 100644
> --- a/tools/scripts/Makefile.include
> +++ b/tools/scripts/Makefile.include
> @@ -106,6 +106,7 @@ ifneq ($(silent),1)
>     ifneq ($(V),1)
>   	QUIET_CC       = @echo '  CC       '$@;
>   	QUIET_CC_FPIC  = @echo '  CC FPIC  '$@;
> +	QUIET_CLANG    = @echo '  CLANG    '$@;
>   	QUIET_AR       = @echo '  AR       '$@;
>   	QUIET_LINK     = @echo '  LINK     '$@;
>   	QUIET_MKDIR    = @echo '  MKDIR    '$@;
> 
