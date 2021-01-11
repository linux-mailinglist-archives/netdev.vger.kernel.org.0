Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69FD2F0BC2
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 05:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbhAKETj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 23:19:39 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31180 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726278AbhAKETi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 23:19:38 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 10B4EIvn010861;
        Sun, 10 Jan 2021 20:18:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=0i6ksNt9jY314CDq0pZpmkpZTl4hN7MASIKBqkc3IOM=;
 b=S+3H04q7PUgfDPMzXoB70nnzAVSLsUqtMzhzjzUdfI3uXyCUp9EILOIsEZDN4YUjRUL1
 bPhhtjuDPgKw5Y6txwclArkdYGTG2lUNkIRCgJbGE6qyPIhsRQ3Qzn0h0fkwtug2TMnW
 yTdN9oQmAneGrufuWTrhey5p6i17qGaU3Ug= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 35y8v5dtv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 10 Jan 2021 20:18:43 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 10 Jan 2021 20:18:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUIU7nyCkFd7bFZCMEn0X3cs8etyv1vtKCh+mE+i39Tm41tz2EAMG/OHEyJxjfnJpO5YwWE56bhJBj7VXqFrEsc03RrfGyKXGmbnNYwAbP1BohtS5rQt2Y8Fa7U6akvruNWfwt3dI7qL8X1hw0hGDeeZxMybyTZWG/yHJqvx+iXazdmXjpL6qLJ1HS+GYpXCE4yZlIvULCCzGbFFvaSXuls/+6Rxvyh3YeFJq11SZMCouDxdxVmEapvIKW9FYIaM/9i89D7gWWlDLpDt/5MufcCcQH31J11dRnxm4pTRqT3wrlLLbqLaHt6GTw2FC8V40CcgGCNyoIvN4MuEosqq5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0i6ksNt9jY314CDq0pZpmkpZTl4hN7MASIKBqkc3IOM=;
 b=BFZgZ7Gos4OSuVZmABC8xmshuEv7xffbnoVNEFQq0BMDBmJo8sN1G1ae+OpD9N5RUY2YOhE5bkQTgv7h9X6fnuJS2rbZ+BE8o24IqqBS0nwJl6k7F4kgUD9sbApMKawnwy1gklnrvBRtGx43DfLUXrqGwr30h4Sb2MeJBU+n6mssntQZZmXp9YvtFdA3mry7RMJEu6nNn89UwkH5X9BwtNcKi0TIaZms962hnOYRCij6C5RlM5ezD/TurNcg6b+ixCG5m2O2uJjbCo81FSpuKNyzK6nKo5VNN9HLbX4qyR/WtRG0TPvT9/STSIzIDiTkFQ0ZbwVQq3r+FX8Ljn7Ccw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0i6ksNt9jY314CDq0pZpmkpZTl4hN7MASIKBqkc3IOM=;
 b=LU+PzzfkI3FRyKhJHYEe4vaAa00lCtELM4J2ONUPWn70f75fffCsYqgHihKt5Q9T+tXmg5Mb/qv/Wv0VD5fT0Y9/xV6MbWXgTgCWWR36M49RXgEtgwP3DcCndGLpjeBt9RKGOhnLWDfhGV7Vxy6ulJeZvh6C4QjdzXIBNyN4kXY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3256.namprd15.prod.outlook.com (2603:10b6:a03:10f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Mon, 11 Jan
 2021 04:18:41 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 04:18:40 +0000
Subject: Re: [PATCH v2 bpf-next 7/7] selftests/bpf: test kernel module ksym
 externs
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>, Hao Luo <haoluo@google.com>
References: <20210108220930.482456-1-andrii@kernel.org>
 <20210108220930.482456-8-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <24b84186-4cd6-131c-2284-d0fdc51ce7b4@fb.com>
Date:   Sun, 10 Jan 2021 20:18:37 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210108220930.482456-8-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:b212]
X-ClientProxiedBy: MWHPR08CA0037.namprd08.prod.outlook.com
 (2603:10b6:300:c0::11) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:b212) by MWHPR08CA0037.namprd08.prod.outlook.com (2603:10b6:300:c0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 04:18:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2af6fc7c-df76-4339-7b1d-08d8b5e7fa0a
X-MS-TrafficTypeDiagnostic: BYAPR15MB3256:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB325630C8DF61A531D836AF3AD3AB0@BYAPR15MB3256.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Czxpqgbh7/qH1GWC8Rqg15KKCzFLvfuQgnMdsIy0W+c4YCDQsamtiXlbE4WNC0ONMP0X7NOOwDoPtM5iMgoREwHpAyuISChw6r3Dp19gz9qzY4BQTYBTmoUhP7r8Tl1EscR1naa+pCJ8KGALDBUp44wZtK/8JZuWfGDPqaCozRqOyiwGzNsXTgOIHff4IhtLb/zCRtvhNikX6vPYtv7TfGE3AySp5kt6N0HkVo/TLN+J0tCAf90xHdfGiqLclP1gFok2dhakXxntoHhnhhTEA+AOTMTqgaJaUyEi/N8siMuvLev6OtZxngrJMIv1qsgxbUPhJtWziomvGmsiFlIPejlyiKmAEy9xMYW6HKdgzNBe0UtZBlivEJNggMY1I3OT8cUCUvm+VntgyGGSFAIwoqafuxbjI2d0uQe/sK7Syxtu7nJYqHJlHFZawGdeD47+Fj98rj6NkTu7eMfmyqD5r4nGfyf5wDr+jrLlO4a/UvI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(366004)(39860400002)(186003)(52116002)(31696002)(6666004)(6486002)(86362001)(66946007)(66476007)(478600001)(8676002)(66556008)(53546011)(2906002)(36756003)(31686004)(5660300002)(316002)(4326008)(83380400001)(2616005)(8936002)(16526019)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d0F3NzNzQWxrSTJvRUZDZkx2RXJGM09ZQTY2dyt1NThtbVNJN0VucDFNNEhK?=
 =?utf-8?B?cnV2amZ1bzJDYnhCOFNmK2grNXRSeHRYc1Z4ditoVWFGTE82NkE2NmZjUmts?=
 =?utf-8?B?Rzc3c1ZDNmpzTWMycG5LTVJ2eG5BdkJkazFUSCttYVF5WE85dFZnWVZSZmkw?=
 =?utf-8?B?TzU2YnI5K2lzeVpkUGoxNG9malBsOCs2VTlyaUQ0eHlhQUpmaTJ2T1pFQi9J?=
 =?utf-8?B?MFEzc1BvYzFiWUtJajFaeWkvdFgrWUZZUEcxR3pUNUJxT2JJVnN4cXVJVzdw?=
 =?utf-8?B?SXlBYjdXK0gwLzBJUEJYUFQxcGFSRGp5L1dpaDhOaFRxOVd2QW1QZ1Q4d3ph?=
 =?utf-8?B?WmhzYTZZc2RtT0syZGpUc3haNWhRVW5ZSHlDdEpsRC8vdENjUWZlNmdDQ0ZH?=
 =?utf-8?B?MFFrYWZGcUZneC9FaTdYZURaWnMvVVYzSWpCZUJtMFZ2ZHlvdDYzcnJ5Rlhm?=
 =?utf-8?B?bUY5TWJkNHNwWGhtWCt0N21BY2ZqSm5XcDQ0TjNWc1ZuUVlKSmZLbWJaY01P?=
 =?utf-8?B?djYyZjRWV3pBekxwd0EzaEpoUGF2SUZUcllza1dTcjFuTVFLY0NGM2g2V3RU?=
 =?utf-8?B?N3g4eVVYaUJhM2o2ZDRJb3V4L2ZNU2loTTc5eEJoNHdHRjBQdXBZWUVmREJu?=
 =?utf-8?B?QmFMV0pBOHdFKzY1WXlvYWJ4alBGUFBpMjRTcFQ5Z1FLUW1rTXdSd0t2Smht?=
 =?utf-8?B?UllFR2Z0WVhjdFRMQXB2ckVEU1MvRGVVNEpRaGd2NVRuaUdobVZ1cEJySkc4?=
 =?utf-8?B?bHhGTENWRUhpMDVHVDVZTU9HWjgzTUUrTzNZNnRZdTh4UFhacUJ1dXRqcXlC?=
 =?utf-8?B?cGNZbks1ZzZnKzc5U1pGdndGNWsrOG10WHEwVVgwbmpPdEFvMDBmYUl0WStX?=
 =?utf-8?B?YkhWTnIzOFczSDZjRWxqb3ZESWZrY2tjSjNJc3J1NkxJRDlxR05NNVVyL09p?=
 =?utf-8?B?MzVXc1l1UFVvNnUwZnY4UDl1b1pBbnE2OXpvZ29ZOTc2NmRoa2NkY0lKM29S?=
 =?utf-8?B?dkkyL2hzOXV4bkJ1MU1HOGZmNGpuVC8zNllQTXQyTThLSEpIU3Y1MGdjVVQ2?=
 =?utf-8?B?dk5vYUQxejVNMlRoZHNXYXVTRVpUdHFDMEwveU4xQWFqZC81R1pQOEQ1T2NF?=
 =?utf-8?B?LzE4MFlPTHZRWGNjZTNuWm1yaS9KWS9NaTFLdWloeE9pSzN6d2hHV0RCK0tM?=
 =?utf-8?B?WHVIeUNkY0tOTndUa3Q1bUtCMEZuMW4rcUZwN21MbHRXcFZZN1FMMFNEODlG?=
 =?utf-8?B?TkRDMXJOTGVGS0MyckJCWFFUQzN4RHFoYzhmaE43aXl4OVVreE1UaUtqY0k4?=
 =?utf-8?B?a0prZk1mL3JQcUhUQUtRWVRkY2hqdmRlbmVxMU9PVzBrWG1Yd245UWVITm5M?=
 =?utf-8?B?NDQ1UjhHWm13WXc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 04:18:40.9229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 2af6fc7c-df76-4339-7b1d-08d8b5e7fa0a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nVCrB0ZZ+QrGCWjK76M2ncLed16/EnD79KRn/9jFmMV4JmUyaHdx2svbY7UAST+n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3256
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 phishscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110024
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/21 2:09 PM, Andrii Nakryiko wrote:
> Add per-CPU variable to bpf_testmod.ko and use those from new selftest to
> validate it works end-to-end.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Ack with a nit below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  3 ++
>   .../selftests/bpf/prog_tests/ksyms_module.c   | 33 +++++++++++++++++++
>   .../selftests/bpf/progs/test_ksyms_module.c   | 26 +++++++++++++++
>   3 files changed, 62 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module.c
> 
> diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> index 2df19d73ca49..0b991e115d1f 100644
> --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> @@ -3,6 +3,7 @@
>   #include <linux/error-injection.h>
>   #include <linux/init.h>
>   #include <linux/module.h>
> +#include <linux/percpu-defs.h>
>   #include <linux/sysfs.h>
>   #include <linux/tracepoint.h>
>   #include "bpf_testmod.h"
> @@ -10,6 +11,8 @@
>   #define CREATE_TRACE_POINTS
>   #include "bpf_testmod-events.h"
>   
> +DEFINE_PER_CPU(int, bpf_testmod_ksym_percpu) = 123;
> +
>   noinline ssize_t
>   bpf_testmod_test_read(struct file *file, struct kobject *kobj,
>   		      struct bin_attribute *bin_attr,
> diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> new file mode 100644
> index 000000000000..7fa3d8b6ca30
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> @@ -0,0 +1,33 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +
> +#include <test_progs.h>
> +#include <bpf/libbpf.h>
> +#include <bpf/btf.h>
> +#include "test_ksyms_module.skel.h"
> +
> +static int duration;
> +
> +void test_ksyms_module(void)
> +{
> +	struct test_ksyms_module* skel;
> +	struct test_ksyms_module__bss *bss;
> +	int err;
> +
> +	skel = test_ksyms_module__open_and_load();
> +	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> +		return;
> +	bss = skel->bss;
> +
> +	err = test_ksyms_module__attach(skel);
> +	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
> +		goto cleanup;
> +
> +	usleep(1);

The above bss = skel->bss might be moved here for better readability.
Or better, you can remove definition bss and just use skel->bss
in below two ASSERT_EQs.

> +	ASSERT_EQ(bss->triggered, true, "triggered");
> +	ASSERT_EQ(bss->out_mod_ksym_global, 123, "global_ksym_val");
> +
> +cleanup:
> +	test_ksyms_module__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_module.c b/tools/testing/selftests/bpf/progs/test_ksyms_module.c
> new file mode 100644
> index 000000000000..d6a0b3086b90
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_ksyms_module.c
> @@ -0,0 +1,26 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +
> +#include "vmlinux.h"
> +
> +#include <bpf/bpf_helpers.h>
> +
> +extern const int bpf_testmod_ksym_percpu __ksym;
> +
> +int out_mod_ksym_global = 0;
> +bool triggered = false;
> +
> +SEC("raw_tp/sys_enter")
> +int handler(const void *ctx)
> +{
> +	int *val;
> +	__u32 cpu;
> +
> +	val = (int *)bpf_this_cpu_ptr(&bpf_testmod_ksym_percpu);
> +	out_mod_ksym_global = *val;
> +	triggered = true;
> +
> +	return 0;
> +}
> +
> +char LICENSE[] SEC("license") = "GPL";
> 
