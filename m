Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1DE368A07
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbhDWAvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:51:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59104 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229865AbhDWAvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:51:17 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13N0UrbZ019846;
        Thu, 22 Apr 2021 17:50:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=oU5/3FTx7Q2sTPdfnyzXLxIkolAM5PmzjQ8Qw9t56Zs=;
 b=CKBd+wir4HWHCbpdNBCp2q0myDPsYV5N9nxnpHHbh0v8jqmXPh4xTTSfjKMZDzYsyJJK
 moQeRU/yhtyJyxLn1o8YTspYSg0GcQnkmhqVLdP0L3nhHHn0DGmnDWp5PzgKwDu6KHBJ
 jlCCEaiUeOa9vXmfri8dVS1dU17LeZdo1mY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 383b4q3kyx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 17:50:26 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 17:50:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyOKw5RUhFaFl0HLI3okn0UfwCilOaPiS0SvYjTA0JRsIXAXSk5lyCIF7cwcMYLznefhqm7WvKOwSiMRTuS6/z+Qd/lm2RhOHRDSrh9Z58AOeDaNJUx5aBUvLRZsenRZR1P4zlZlhxCj9qvJngvWb7SRYsgEJQUfoXYnk8I8K6KK8BOfzdSfoZUIe08gU65k1LFN6q1tFl8nindyfxMr1A4C6crjJAshdQOCHuqP1hCuLp96lpylq8mhP3O7M/Rp0lSB/2mYplYUpztK9VrywU/lJypU6rb8V4HAQrMkHZ0cOnEaNAd7RO72XFWwXs/fGNnTg1WrTFqM2clR5n8e8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oU5/3FTx7Q2sTPdfnyzXLxIkolAM5PmzjQ8Qw9t56Zs=;
 b=MG8hZCxkoQ9CbG0NeyqaLpEXfML1y9GcXPMF5o1IXaiUnx0jNAfP1JO/MsNPxmIk2R59AdIfxchzO54uu8EJqRBf8PDmS33cdc7hqcw8YK2bBFAKhQfwR8Fgk+YFxjPs0OMtaGG0okQHC2PhlZxO8s72DSSuq/jTLhbQLeiTrxVKKMR9MW1467PgKwLgk64N4Em1PRm+kKR9ItQ1g/BI/9VX4WoR+Qr1JJrcSB2Qmo7ZzkS9FIeeki+gwNKtGOYCqh2kPzStfjIJeqm3inoqbvpot5XPzp5geafni1ciJvH4f35omvvoyoMtwGYAVG1TD8M0C/eR8HJDr5lNy1VDXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3760.namprd15.prod.outlook.com (2603:10b6:806:84::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.20; Fri, 23 Apr
 2021 00:50:22 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Fri, 23 Apr 2021
 00:50:22 +0000
Subject: Re: [PATCH v2 bpf-next 15/17] selftests/bpf: add function linking
 selftest
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-16-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3947e6ff-0b73-995e-630f-4a1252f8694b@fb.com>
Date:   Thu, 22 Apr 2021 17:50:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-16-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:83f]
X-ClientProxiedBy: MW4PR03CA0303.namprd03.prod.outlook.com
 (2603:10b6:303:dd::8) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:83f) by MW4PR03CA0303.namprd03.prod.outlook.com (2603:10b6:303:dd::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 00:50:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef85f905-284d-4112-2150-08d905f1c663
X-MS-TrafficTypeDiagnostic: SA0PR15MB3760:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB3760FFEDDA8623DE0A37B022D3459@SA0PR15MB3760.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f5gMxdQj+VrNHdbo2WNQ50om/s/hazs1Rm7TF3BZhQpCk7FJW/CKyFmv5KgeXOQRWThPcdgbnQBuhcbdUIRFhzIyRoe31eqSvujwjcTd2fmvayvt3XdulQ8yed2W66ViRgwRy3fjicMm/4W7Zfg1Y0fCaLyGfqlFc0YmhpU7LlkHVewLf7yXEgLALJD+uwYHUf0lBkhRtyLYK8D9usaXk4ujhE+WsI0WfMUb+1UVlQKnVPSpAS29/GFFPZnQ7GgMlGca4tz6K9JyA2tCxwrLgTSWBchJKGXXtH76fw2xRuRut2n9VdxEy7kRTEjqCs5SWR5mLx6+yBHVEGPgi+yLCx8jLaoEEon0yJl4rqsjgW3cUomGqIylBu3/oauFSg+7A9lKflEBwJIpm6jPfkbznei2uWST+gHrmY5DW8Jn711zaPMWwAmx/ObdgSMcc4ScY62EfjlGKNwJal8tt1wihl9hh4vKkDvHrdSyQfQSOL3yCGvtEn3xQi/71EMw2gPo8Jq4LnmpuIaPy2aN6n/8rPwIGh1C3UqAy9AroZRRKqhISfJh/i/04f49YZsZfZczQ1wrwF79X+VM9+PUnHeqm0Cd1rmSNqUg+66Y05c6MufueZvMUXaoLo/5IFrRvDEUG0keDRh4eVe3Xo+COVh9Q00NFeEaZ7Rt0zbIa19G2J9cpMY2FJbtjst7EGP7tQCg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(376002)(39860400002)(396003)(66476007)(478600001)(66556008)(4326008)(5660300002)(66946007)(6486002)(8676002)(36756003)(31696002)(186003)(52116002)(86362001)(53546011)(83380400001)(2616005)(8936002)(316002)(31686004)(2906002)(16526019)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RFBsbjkyRGlLZ0JCZzZtYXNLVUhvZW5Bc294dkw4WDhLUG1KdjJhSGxDdnpz?=
 =?utf-8?B?dUZqVWorY2RhQndldyt3bmZENnRUQ0VVSUdzdmpWQ2o5MUR1bGlxV0h6Y3Fj?=
 =?utf-8?B?cFJQYUFFeUNwL0UvbWN0K3VLdnpZYWVCeHJCdW0xSThBd3FpOHJpeHF4YVA2?=
 =?utf-8?B?bmdiNVFCbU1RTXc2UERRMVlqdDVLUGQ0dnFGSTc1SWZGK3ZDelJ4cWdncDJr?=
 =?utf-8?B?bTV0ZW9IdzZXaC9oaDRiUDJKU2tmVkZsOHg5RzJNNWRoMXJUMDQ1Z0ZHMmM2?=
 =?utf-8?B?eW9JOW5xS2d6azE3ZEQrcDF1OEV5SU5ZblNlT3Vzam9SenAzSkNIdHVFZ04w?=
 =?utf-8?B?UURpWGlSbFBGak81Nkx2Zmd5K2Y3WVJzaTV3V1BOakFqbGYrMURCRzhSamJW?=
 =?utf-8?B?cWg2WDVXUFBGdEdZZ09rRkg1dGJZNk1DWXBRcmF4NU1LU2dYWTJMemY1U2Vm?=
 =?utf-8?B?bVJzRHEweWp5M0xWS0tLOVdJWWlSQ2pNTjVuWVJZclFTUy9ZeFZUM0UxNjZ0?=
 =?utf-8?B?K011aXd1Q3lkWmkvTnUzWkpBLzlIYXZnK25keDdsWHNBSjFHQVlVQmdKMUdy?=
 =?utf-8?B?YzNHQmdMU2xQdWQyU1NieFJVemRXY3hwS25FZkVKTXlxSFVkcUtqYW11YmRi?=
 =?utf-8?B?cjVIM29WRm1uUWh4dU5LbzdyeDI0Wk50cWJzcUltaTBoemo3UHBWNWxtTFhD?=
 =?utf-8?B?azRNVGw5Ym5Kc1VNakdRaHZMOUJMZU5wYnFtMTdodXg5WWQyK3JicXdjUURi?=
 =?utf-8?B?TUYrK3VoR2F5V2JPZXM3NzFhMHdaSnZyWXE4QmpZaWxiaWdOc1pDVHpyWisv?=
 =?utf-8?B?amxWLzlFYmpVK0VyNUdFZTQrYWNuRElNRXRrZGxJVjgvZnVWb0tFOXU0Z0RD?=
 =?utf-8?B?c1VsOVJiTXZNd21ZMXA2TjR1SGduWU9tN0prZzNKUGhuTDZxMWI5ekVWeFpw?=
 =?utf-8?B?dWdrVkNTQXgyNlpVbXVOQjh4RXd2SjZ2SkEyT2djSmpPSFRLOTRRQWxGNExI?=
 =?utf-8?B?eFJzR3A2UTQzZm5hOHhjNVBnK29hS1F4MTVnc3BtdTlpallSYXYycE03NmhN?=
 =?utf-8?B?YlZ6SXJyanBtUU1GYjhvcmZEbHJCbVJuMGpQSXllWER4Yyt1MktDTmhnT2pV?=
 =?utf-8?B?UmpRd1Vwd2IyQVNoTTkzTjJxK2lpekpoekVjQVhJTjVpUG91eXUvdDZkbkNx?=
 =?utf-8?B?RnFMeUcxR2greDN6QVh1aHZmcEdpMUdzNk42ajhPUzFZTENxaGNaTDlGRUNG?=
 =?utf-8?B?Kys4Y1JCUWhxeEdZKzJWWUplaVd0UnZ4ZDlSL2RockNlQkFqSEhzQzFwcDZq?=
 =?utf-8?B?SHZCTCtjQW5UTFp2M2wyMUFSMUFXb3pLeXhxbTBtTnZ0bHMxTmVTVjhiSTBq?=
 =?utf-8?B?MmRpQnlsd0xLSzcxL1U2VnhtdXhiWkYwaEd6VlNSbXp3NndhOGFYVzZ2aHgx?=
 =?utf-8?B?ZWZFYWY3MUF3WTByMDhZVVgzRUgrZHJOVjUrTW13NlkwNS9VaGNVbVdHdDdv?=
 =?utf-8?B?L25EbG1XSk1VQ0dMSVQ4VmVDcXUrRU8xcGFhaE9DbHpBVWxwLys2UEhaOWh0?=
 =?utf-8?B?VGpWVDZkTEtaSlJTSmZiSVArdmU0bGwxakVUTC9FME51YWFpcmh3NDFXZ3dv?=
 =?utf-8?B?QnIyS1NrOWd2NThJaHpucTZXTzRRY1cyRnhRbnBFek5pQVl0ZlZla1ZBQVhr?=
 =?utf-8?B?RUYwOGlCb2JHWFUwa0tUOXBhUzZBL2hBZzJHY0ZZM0NqWlQwaXRHVUpLMzVk?=
 =?utf-8?B?VUFPVUluVnFFdmdaVE9wZUhZOHUybnh0eG9oREU0K2lRY2FIK0dKRzdSUXJo?=
 =?utf-8?Q?BIB1ENDH+8sc0ejSVZPgg5X6gDQ6SNVigWig0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ef85f905-284d-4112-2150-08d905f1c663
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 00:50:22.4267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EZSK/1QMowmT0lSE7fMGnlXiLEXzGdk24GjIBGA9DKqgT89Ho3Vykhksc3LiKNaS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3760
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: oA0wzK7hjjZTH6mWgkQYDH12-YpcFVgS
X-Proofpoint-ORIG-GUID: oA0wzK7hjjZTH6mWgkQYDH12-YpcFVgS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_15:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 mlxlogscore=999 phishscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:24 PM, Andrii Nakryiko wrote:
> Add selftest validating various aspects of statically linking functions:
>    - no conflicts and correct resolution for name-conflicting static funcs;
>    - correct resolution of extern functions;
>    - correct handling of weak functions, both resolution itself and libbpf's
>      handling of unused weak function that "lost" (it leaves gaps in code with
>      no ELF symbols);
>    - correct handling of hidden visibility to turn global function into
>      "static" for the purpose of BPF verification.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Ack with a small nit below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/testing/selftests/bpf/Makefile          |  3 +-
>   .../selftests/bpf/prog_tests/linked_funcs.c   | 42 +++++++++++
>   .../selftests/bpf/progs/linked_funcs1.c       | 73 +++++++++++++++++++
>   .../selftests/bpf/progs/linked_funcs2.c       | 73 +++++++++++++++++++
>   4 files changed, 190 insertions(+), 1 deletion(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_funcs.c
>   create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs1.c
>   create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs2.c
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 666b462c1218..427ccfec1a6a 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -308,9 +308,10 @@ endef
>   
>   SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
>   
> -LINKED_SKELS := test_static_linked.skel.h
> +LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h
>   
>   test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
> +linked_funcs.skel.h-deps := linked_funcs1.o linked_funcs2.o
>   
>   LINKED_BPF_SRCS := $(patsubst %.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
>   
> diff --git a/tools/testing/selftests/bpf/prog_tests/linked_funcs.c b/tools/testing/selftests/bpf/prog_tests/linked_funcs.c
> new file mode 100644
> index 000000000000..03bf8ef131ce
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/linked_funcs.c
> @@ -0,0 +1,42 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +
> +#include <test_progs.h>
> +#include <sys/syscall.h>
> +#include "linked_funcs.skel.h"
> +
> +void test_linked_funcs(void)
> +{
> +	int err;
> +	struct linked_funcs *skel;
> +
> +	skel = linked_funcs__open();
> +	if (!ASSERT_OK_PTR(skel, "skel_open"))
> +		return;
> +
> +	skel->rodata->my_tid = syscall(SYS_gettid);
> +	skel->rodata->syscall_id = SYS_getpgid;
> +
> +	err = linked_funcs__load(skel);
> +	if (!ASSERT_OK(err, "skel_load"))
> +		goto cleanup;
> +
> +	err = linked_funcs__attach(skel);
> +	if (!ASSERT_OK(err, "skel_attach"))
> +		goto cleanup;
> +
> +	/* trigger */
> +	syscall(SYS_getpgid);
> +
> +	ASSERT_EQ(skel->bss->output_val1, 2000 + 2000, "output_val1");
> +	ASSERT_EQ(skel->bss->output_ctx1, SYS_getpgid, "output_ctx1");
> +	ASSERT_EQ(skel->bss->output_weak1, 42, "output_weak1");
> +
> +	ASSERT_EQ(skel->bss->output_val2, 2 * 1000 + 2 * (2 * 1000), "output_val2");
> +	ASSERT_EQ(skel->bss->output_ctx2, SYS_getpgid, "output_ctx2");
> +	/* output_weak2 should never be updated */
> +	ASSERT_EQ(skel->bss->output_weak2, 0, "output_weak2");
> +
> +cleanup:
> +	linked_funcs__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/linked_funcs1.c b/tools/testing/selftests/bpf/progs/linked_funcs1.c
> new file mode 100644
> index 000000000000..cc621d4e4d82
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/linked_funcs1.c
> @@ -0,0 +1,73 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +/* weak and shared between two files */
> +const volatile int my_tid __weak = 0;
> +const volatile long syscall_id __weak = 0;

Since the new compiler (llvm13) is recommended for this patch set.
We can simplify the above two definition with
   int my_tid __weak;
   long syscall_id __weak;
The same for the other file.

But I am also okay with the current form
to *satisfy* llvm10 some people may still use.

> +
> +int output_val1 = 0;
> +int output_ctx1 = 0;
> +int output_weak1 = 0;
> +
> +/* same "subprog" name in all files, but it's ok because they all are static */
> +static __noinline int subprog(int x)
> +{
> +	/* but different formula */
> +	return x * 1;
> +}
> +
> +/* Global functions can't be void */
> +int set_output_val1(int x)
> +{
> +	output_val1 = x + subprog(x);
> +	return x;
> +}
> +
> +/* This function can't be verified as global, as it assumes raw_tp/sys_enter
> + * context and accesses syscall id (second argument). So we mark it as
> + * __hidden, so that libbpf will mark it as static in the final object file,
> + * right before verifying it in the kernel.
> + *
> + * But we don't mark it as __hidden here, rather at extern site. __hidden is
> + * "contaminating" visibility, so it will get propagated from either extern or
> + * actual definition (including from the losing __weak definition).
> + */
> +void set_output_ctx1(__u64 *ctx)
> +{
> +	output_ctx1 = ctx[1]; /* long id, same as in BPF_PROG below */
> +}
> +
> +/* this weak instance should win because it's the first one */
> +__weak int set_output_weak(int x)
> +{
> +	output_weak1 = x;
> +	return x;
> +}
> +
> +extern int set_output_val2(int x);
> +
> +/* here we'll force set_output_ctx2() to be __hidden in the final obj file */
> +__hidden extern void set_output_ctx2(__u64 *ctx);
> +
[...]
