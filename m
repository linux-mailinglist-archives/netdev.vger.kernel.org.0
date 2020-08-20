Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBEE24C487
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 19:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbgHTR3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 13:29:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19112 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730514AbgHTR3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 13:29:07 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07KHSLuT026202;
        Thu, 20 Aug 2020 10:28:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Zg2XBgDn0tUhXGIDQ7YiLJaRKb+R7NUhQXtc7TKc2+Y=;
 b=SQRH7nbxLVczcb3Odmsb/pAs+sczdXQ6UVXmJ3jGPVaWf/7XDqH5zgG+hZg8+YajWLry
 p+jmWH8EQGQMCwD0UGnUtN76tND7bSZ+eV1eAN+NiW36Cu6quLMDD3bL3qkTip8DFezU
 eZC+QPwOckwP0on4Ay9h42DowQLKzNSWjdU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3304jjff9u-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 10:28:26 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 10:28:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvxAXm7afJ6sRparhOGT91HupiWj5ZP+p+3XucxLZ0wSV678JB0nsr3i/SXfoFZV9T6QrPOKy0zEbxRBJyghX8hHim1Ay83xxOL9vZg7IHbESx8HobUkIYb2PV8HhdxrtoiTSxt+BN/wn2lu3klpXodifjKrUUaWdUL0CqyuEoR/5zaQYKevJZBpbtYGfPpokpd/HJprzB9EvWxdd4FEc2resf1u4goiJkIqrRn5nppXxIydXVJ4gS/dkl0Rs00qwlMzOsatNBdSfgQ/Yf8SnADjatEmRJVwQhxtvP7HUgQEWKrfMNdfi2/iwbSt7x3NLbVXAgKEgHyjmJnSTe0xVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zg2XBgDn0tUhXGIDQ7YiLJaRKb+R7NUhQXtc7TKc2+Y=;
 b=P7jO5bVIqotIftLXug+qVpa4jFcvPYU9XFIDZVHwkjBYni6loAMxI24HMtJeSIZAd9GAN8Dk85iiD3Pgnk8VawIo+40rz0vdoZEz1Wklh+mYpvoSWOueJVA0gwZVW9NHnZBvIEI2xJ5ZnOsNywA7kBHfxjH1K/UM+C/VaCMOxnLW8FksdvOAcXbf9jD7i9vKLiuCVqWtG3qbtXIQ6o+TIAq7LE+G5JI7v9RM2j7A19R/R+L87e2R451OQOeLh70MGeOR+XejlVTXaGYR9pEGdQi2kHS8WRcRdeWEWJXaq8pXZbEkVlbSvG5eMR0XlBlCmcUdeo/2YH0UB20DxaRnWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zg2XBgDn0tUhXGIDQ7YiLJaRKb+R7NUhQXtc7TKc2+Y=;
 b=B2Txxpmb3fXE0qWEQZNhJuRTLr2kip2eH6f140x1kUdLwgY7IeFu2n0Guj9wBI+py/C0DrbAQB9UCuvIbom2kjpHmm95mOcOLOmBjxQXvZLui8znO8oeqbrqRO5Z6JVRxNo3qE61nCqARJMCOXqwakpqNB4KSftSYUkDjS9jtpo=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3095.namprd15.prod.outlook.com (2603:10b6:a03:fe::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 17:28:10 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 17:28:10 +0000
Subject: Re: [PATCH bpf-next v1 5/8] bpf/selftests: ksyms_btf to test typed
 ksyms
To:     Hao Luo <haoluo@google.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
References: <20200819224030.1615203-1-haoluo@google.com>
 <20200819224030.1615203-6-haoluo@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <29b8358f-64fb-9e82-acb0-20b5922afc81@fb.com>
Date:   Thu, 20 Aug 2020 10:28:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819224030.1615203-6-haoluo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:208:236::22) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR05CA0053.namprd05.prod.outlook.com (2603:10b6:208:236::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.10 via Frontend Transport; Thu, 20 Aug 2020 17:28:07 +0000
X-Originating-IP: [2620:10d:c091:480::1:7ec1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ff7a7fe-b33b-4502-236a-08d8452e68ea
X-MS-TrafficTypeDiagnostic: BYAPR15MB3095:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3095708F1264BA60C22B1FAAD35A0@BYAPR15MB3095.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:294;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f5gdOHD09VpQxTcq+5mpffkrfbia5STKDaYDpGRA4OUFhOtlPWUyTSf3N/WyI3+8CbFhju2FCizKBmL9Mqq4Tp9qj6EkPfO/n+f1NbQNou4IGekQ6M2p8JiyZJGGPH6Ss6Xt3xUu2qz4dkCnm0Awg4l8C6e5QttF98rq3NxBWnov/BvMn2pLowjSy1URwCdia0rMR/5ThCu3CPrgPsrAR7LC1Aey1jr2Pgf009Z+qcGwhVFL+6J+5QxUPrk0OJGaqZLJSbMbcxVHrWdfCzTOFzqulYIf6OcmC/eZtQq8ulm1cErIvF/xTAV5y5Qzruslz36lBZkWXhgvvpeaqiIoRKdNPinXPcAQgxJguRPzgrFM+LXqSZcAwocrRspEDSLYiWwpkj7iepgk8hN5aA6ne/l9VeRU1caInrIgTUlOcIU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(346002)(376002)(396003)(66476007)(7416002)(66556008)(2906002)(5660300002)(66946007)(8936002)(6666004)(36756003)(478600001)(53546011)(54906003)(8676002)(110011004)(86362001)(6486002)(16576012)(316002)(4326008)(956004)(2616005)(52116002)(186003)(31696002)(83380400001)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: cCD57vVQfzQ4OvIthHTll3Mk0Mmm4kSDLQsNhvMjBz04FYDyq4bXh8j66cmOoHD+FwllSgTHGNTEyvnPQyE0sxN96syhI6ZpqNMwvXmXTzqeDh6ZLK2iYxa0xqjigWQVcPL4FJNRiryT3fYIq50VS0mT+lTQG0UmqdIKpOSZdUGKi0CD3g49rpQW6BPzIdfx050SNVW3fNdsyDZMmkAjn43gb6KMf7s6MvDo+G0HQrt5CtOyebXw9hABpoeb/veFFThsfBG9j30cxF3dfbpy3x7OzoSA1aw5/PNv2yttfP0ga5O0/5ytXhxamUx51GhP+VPcJsy3bOTr+IfdUFKFLEfdFtPyYEVX75H0yZ5U3oREGHAiBYwjxJ9U/ay/9BbMzJpLMg7vH24qAy21irKXgA2SW+3yc3alNwYwWk5setUZd3XYQWasZZrrg8XHh4NVOtF+FOmHPTDZJ7S208qjHIV13MlxZCBT6E5zkzWWiFv6CHbLKwcJggwkYKIbxfl0XIfjbb48JcTtf6ZQMsBqkLmocyjqyxmaxFCpE5chw4XolURQymZzAZBa5gacs7mNBMyvY7lCU4NnGUErc3Wwzia+VpfXFDEJZaS7CzQWnX6pnthFV3LQYDRO8urUCfdilB/GWYRpXIvlEHkJj4n25a3nOd723m213EnN/eIczss=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ff7a7fe-b33b-4502-236a-08d8452e68ea
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 17:28:10.6181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /hrOfmQAGfpzGy97kG4XImm8BTQPT3cTo7AliMkr6FgX6kAafd06q5UWHKJIy0F6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3095
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 3:40 PM, Hao Luo wrote:
> Selftests for typed ksyms. Tests two types of ksyms: one is a struct,
> the other is a plain int. This tests two paths in the kernel. Struct
> ksyms will be converted into PTR_TO_BTF_ID by the verifier while int
> typed ksyms will be converted into PTR_TO_MEM.
> 
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>   .../selftests/bpf/prog_tests/ksyms_btf.c      | 77 +++++++++++++++++++
>   .../selftests/bpf/progs/test_ksyms_btf.c      | 23 ++++++
>   2 files changed, 100 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> new file mode 100644
> index 000000000000..1dad61ba7e99
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> @@ -0,0 +1,77 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Google */
> +
> +#include <test_progs.h>
> +#include <bpf/libbpf.h>
> +#include <bpf/btf.h>
> +#include "test_ksyms_btf.skel.h"
> +
> +static int duration;
> +
> +static __u64 kallsyms_find(const char *sym)
> +{
> +	char type, name[500];
> +	__u64 addr, res = 0;
> +	FILE *f;
> +
> +	f = fopen("/proc/kallsyms", "r");
> +	if (CHECK(!f, "kallsyms_fopen", "failed to open: %d\n", errno))
> +		return 0;

could you check whether libbpf API can provide this functionality for 
you? As far as I know, libbpf does parse /proc/kallsyms.

> +
> +	while (fscanf(f, "%llx %c %499s%*[^\n]\n", &addr, &type, name) > 0) {
> +		if (strcmp(name, sym) == 0) {
> +			res = addr;
> +			goto out;
> +		}
> +	}
> +
> +	CHECK(false, "not_found", "symbol %s not found\n", sym);
> +out:
> +	fclose(f);
> +	return res;
> +}
> +
> +void test_ksyms_btf(void)
> +{
> +	__u64 runqueues_addr = kallsyms_find("runqueues");
> +	__u64 bpf_prog_active_addr = kallsyms_find("bpf_prog_active");
> +	struct test_ksyms_btf *skel;
> +	struct test_ksyms_btf__data *data;
> +	struct btf *btf;
> +	int percpu_datasec;
> +	int err;
> +
> +	btf = libbpf_find_kernel_btf();
> +	if (CHECK(IS_ERR(btf), "btf_exists", "failed to load kernel BTF: %ld\n",
> +		  PTR_ERR(btf)))
> +		return;
> +
> +	percpu_datasec = btf__find_by_name_kind(btf, ".data..percpu",
> +						BTF_KIND_DATASEC);
> +	if (percpu_datasec < 0) {
> +		printf("%s:SKIP:no PERCPU DATASEC in kernel btf\n",
> +		       __func__);
> +		test__skip();
> +		return;
> +	}
> +
> +	skel = test_ksyms_btf__open_and_load();
> +	if (CHECK(!skel, "skel_open", "failed to open and load skeleton\n"))
> +		return;
> +
> +	err = test_ksyms_btf__attach(skel);
> +	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
> +		goto cleanup;
> +
> +	/* trigger tracepoint */
> +	usleep(1);
> +
> +	data = skel->data;
> +	CHECK(data->out__runqueues != runqueues_addr, "runqueues",
> +	      "got %llu, exp %llu\n", data->out__runqueues, runqueues_addr);
> +	CHECK(data->out__bpf_prog_active != bpf_prog_active_addr, "bpf_prog_active",
> +	      "got %llu, exp %llu\n", data->out__bpf_prog_active, bpf_prog_active_addr);
> +
> +cleanup:
> +	test_ksyms_btf__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> new file mode 100644
> index 000000000000..e04e31117f84
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> @@ -0,0 +1,23 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Google */
> +
> +#include "vmlinux.h"
> +
> +#include <bpf/bpf_helpers.h>
> +
> +__u64 out__runqueues = -1;
> +__u64 out__bpf_prog_active = -1;
> +
> +extern const struct rq runqueues __ksym; /* struct type global var. */
> +extern const int bpf_prog_active __ksym; /* int type global var. */
> +
> +SEC("raw_tp/sys_enter")
> +int handler(const void *ctx)
> +{
> +	out__runqueues = (__u64)&runqueues;
> +	out__bpf_prog_active = (__u64)&bpf_prog_active;
> +
> +	return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> 
