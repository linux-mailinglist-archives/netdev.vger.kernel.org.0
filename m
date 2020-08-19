Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EFC24A418
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 18:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgHSQb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 12:31:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59062 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725275AbgHSQbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 12:31:23 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JGKUt8009438;
        Wed, 19 Aug 2020 09:31:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Pytkadmlaz814tNo+4sEWDgIvCHWQkQEHOoVsvVmoVc=;
 b=qLwoG7/UY5KUSZhGrmSUAStTgdJW3R13y/QGe+946hCAT37lK1kD3GMTss/cqvIvEGZA
 ImycWVNqhR/lcaTg2WwSM+LuUM00XztTPNd6UCmLCj7HZfBO0Hi8yAYwPRQwcn/0vlLV
 neR292Z3nM5UcQLjxF06imDpqnja7dG0z78= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304pb1d3u-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Aug 2020 09:31:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 09:31:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoN6R1FR2EeE8n9Ji5aMkgpBfdRuaQ50WKrKpof6AnQtQjC9DbadoHbEx7FtzFLCT6J7tXzQBesDNtqYTMDFqKtfRoAZQw1ZEhPDMmI7Ujql+1iHBvQ8pgzf3A+Ck6ERLvGFrdcOo9pFTjtWXw6lzQfnIUxCREjvaoBpopz3+qc2LTG8mB0T3s9Q2zdlarnx6z5JGQ/dgFcbk0KycaudOrBO7/cXi1XklFhe0KQKK2u1c2sh/ez3fXzN6jNtQayZmGQgzEz/ro8A5+W0yvMZjnnO3f6RT0ql7AbJajKCSxKD6d21OK0Z7HdJ+lUkJ/+PLPMge0xmfaa6FNLiz3V0QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pytkadmlaz814tNo+4sEWDgIvCHWQkQEHOoVsvVmoVc=;
 b=I9Kl/7cDkk+7NzL6JM8AIch64edGAEWNbY6JvpiOOnUGOHB5lXQ1BfaC69P9kOeScKwUwA0O1TB8G0CpIU0EH0Mefd8Zq4rEyNcD1DziivGU59xKjFgiVDml9BlVMdzaXRk1QkIBTRXbSfihLUnuYS/I0G+b9EDckDoMg+CBMps2s0wc6GJB2vGUqKiTZV3U5sJ+FszWR+ygzU2mJtQyu/etNViGMtMCk/nMA7mzah0GUGBJCUY0HoCxHRFp8MYAR1p0uPqiYDlBT8evRB7q8jobN7tMmsblJFLvOeERojxHlPGRfHQFZ7UoUIuMMrOKyTbWl7udmsyReKqKMQMCgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pytkadmlaz814tNo+4sEWDgIvCHWQkQEHOoVsvVmoVc=;
 b=AIUYPf5aGWBtgUNm4lIK7TcM0I36h4P7rn3chkwjBO8VmYjXiJXiaU8F7banvaLM1xFuIfzm92zsKo9ctWGXrn/4GeJypMxiXz+StO8Ao/xK3Eigjy01wJtBwRII/tqYBLp0FVYnooK8fmzvXU7gG3oe7wY9SfARDQRSSZMrD+Q=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3617.namprd15.prod.outlook.com (2603:10b6:a03:1fc::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Wed, 19 Aug
 2020 16:31:04 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 16:31:04 +0000
Subject: Re: [PATCH v2 bpf-next 2/5] selftests/bpf: test TYPE_EXISTS and
 TYPE_SIZE CO-RE relocations
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200819052849.336700-1-andriin@fb.com>
 <20200819052849.336700-3-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <8840d113-86bb-bd55-b97c-1d5a869472fe@fb.com>
Date:   Wed, 19 Aug 2020 09:30:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819052849.336700-3-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0023.namprd16.prod.outlook.com
 (2603:10b6:208:134::36) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:9a2) by MN2PR16CA0023.namprd16.prod.outlook.com (2603:10b6:208:134::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Wed, 19 Aug 2020 16:31:02 +0000
X-Originating-IP: [2620:10d:c091:480::1:9a2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4231033c-5329-43e5-39fe-08d8445d4405
X-MS-TrafficTypeDiagnostic: BY5PR15MB3617:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3617C449993FD0F0560C1EB3D35D0@BY5PR15MB3617.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zGi17XSVSAIqWslI5T5WmVzicQiIMdPGEdWfass+kGdR32n0nfoK+gsHXL0rtDxxWFohMWi43peek9QqrzOkKvRkbXf13Vb/lVA6E1eX6k28J+57M+936npvfN7rG/+Gm7KIHTq2Kozm5dO0pMv2X7lk9m/R4YW4Guy8WWsnAa8aMEwez6wkbQVEct5n6uvq1gTtOsQXynwhxaonjIM03al3k4mLLvfvpZhxQdFxcsCX0C4Si5ZN1Anac3gOzePxYxY/xr4jvRsD6XtHUSAzlWVO9oriD3BmrnOrtDir1DP+3B40ZUVcTJPWyEzLJXCI4MYT42EW9PMkuNErbZQsPBVQF/ljh2aqPBynf3M82NZwLO7fl9F20qFPvIsaiByx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(39860400002)(376002)(346002)(53546011)(52116002)(6666004)(66556008)(316002)(478600001)(86362001)(83380400001)(2616005)(6486002)(31686004)(66476007)(5660300002)(66946007)(4326008)(16526019)(2906002)(186003)(8936002)(31696002)(8676002)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 3485vdOc33hJY4iJOyj9+h0G85Doc0wIw0mnjnreMttZMvP1m1CF+X/MpLbhHgWEeplrbcmV4xWiAaX9Olh1IXIXGVl1BjQNm7cxad50EB3jIRyqRoyPSmXf0NBi/0f5xQJUHDfIWFgkWPlJVW2yC0Y4BYe81Glc37vlBa/FFJkU6ps71apRTVad5rrdZoBkSpWA7xj3T3EE5QW0oHogWwqkKcUa6taviXq2tCPbiwqTXesuEVO0fw25T3OyNb875lo1yPMdOgq1C+FRL+vnqB3oVWP7/N+ofkdI0t/vaiJ2r/djF/XuuNyxSdURQziQP0dqxdN+EzMaTOf/XGCm6JlUCrOZzHpGf8qB6+yh+sVI1EZzE3m6uIK56iI0psuKgSqc0TCUuGzKd9qZ9hXjMZ3L9YYebwXTl3cBe93qPcknvXbnTRZ88oeKpHnhBWnRqEAFbcqoV0pdjD+gbmSHxO5FfAuZDtFXeg1BvVoEjQbQPBRPOAQkgfk5GeAKBom4qZkwgIbxwM8HdRz5LeOrG5vEjfWOTgRp+Kr7o25H4bVJ3qmTZ/PDW/gbt9FGsEtxBsz9ME1SAmQyfhipjhLQJEt+PhRnWKYm4fkmoyurVKJ1yHF7ACa5cfO+LFIZ4PkUBVsQLjOGPRRDoGMQywoteIpUjs8fMMXOAXWsfQr1oiGYKM95tlWUBMWYNsZko6XV
X-MS-Exchange-CrossTenant-Network-Message-Id: 4231033c-5329-43e5-39fe-08d8445d4405
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 16:31:04.0463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rF2wSoKwN1IJL9wbluF5Mbpx7pqT+BK8VxWspE5Ji4sWMcVn9ozPEn+9eXno/nWX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3617
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_09:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/20 10:28 PM, Andrii Nakryiko wrote:
> Add selftests for TYPE_EXISTS and TYPE_SIZE relocations, testing correctness
> of relocations and handling of type compatiblity/incompatibility.
> 
> If __builtin_preserve_type_info() is not supported by compiler, skip tests.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>   .../selftests/bpf/prog_tests/core_reloc.c     | 125 +++++++++--
>   .../bpf/progs/btf__core_reloc_type_based.c    |   3 +
>   ...btf__core_reloc_type_based___all_missing.c |   3 +
>   .../btf__core_reloc_type_based___diff_sz.c    |   3 +
>   ...f__core_reloc_type_based___fn_wrong_args.c |   3 +
>   .../btf__core_reloc_type_based___incompat.c   |   3 +
>   .../selftests/bpf/progs/core_reloc_types.h    | 203 +++++++++++++++++-
>   .../bpf/progs/test_core_reloc_kernel.c        |   2 +
>   .../bpf/progs/test_core_reloc_type_based.c    | 125 +++++++++++
>   9 files changed, 448 insertions(+), 22 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___all_missing.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___diff_sz.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___fn_wrong_args.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___incompat.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_type_based.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> index 4d650e99be28..b775ce0ede41 100644
> --- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> +++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> @@ -177,14 +177,13 @@
>   	.fails = true,							\
>   }
>   
[...]
> +/* func_proto with incompatible signature */
> +typedef void (*func_proto_typedef___fn_wrong_ret1)(long);
> +typedef int * (*func_proto_typedef___fn_wrong_ret2)(long);
> +typedef struct { int x; } int_struct_typedef;
> +typedef int_struct_typedef (*func_proto_typedef___fn_wrong_ret3)(long);
> +typedef int (*func_proto_typedef___fn_wrong_arg)(void *);
> +typedef int (*func_proto_typedef___fn_wrong_arg_cnt1)(long, long);
> +typedef int (*func_proto_typedef___fn_wrong_arg_cnt2)(void);
> +
> +struct core_reloc_type_based___fn_wrong_args {
> +	/* one valid type to make sure relos still work */
> +	struct a_struct f1;
> +	func_proto_typedef___fn_wrong_ret1 f2;
> +	func_proto_typedef___fn_wrong_ret2 f3;
> +	func_proto_typedef___fn_wrong_ret3 f4;
> +	func_proto_typedef___fn_wrong_arg f5;
> +	func_proto_typedef___fn_wrong_arg_cnt1 f6;
> +	func_proto_typedef___fn_wrong_arg_cnt2 f7;
> +};
> +

empty line at the end of file?

> diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> index aba928fd60d3..145028b52ad8 100644
> --- a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> +++ b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> @@ -3,6 +3,7 @@
>   
>   #include <linux/bpf.h>
>   #include <stdint.h>
> +#include <stdbool.h>
>   #include <bpf/bpf_helpers.h>
>   #include <bpf/bpf_core_read.h>
>   
> @@ -11,6 +12,7 @@ char _license[] SEC("license") = "GPL";
>   struct {
>   	char in[256];
>   	char out[256];
> +	bool skip;
>   	uint64_t my_pid_tgid;
>   } data = {};
>   
[...]
> +
> +SEC("raw_tracepoint/sys_enter")
> +int test_core_type_based(void *ctx)
> +{
> +#if __has_builtin(__builtin_preserve_type_info)
> +	struct core_reloc_type_based_output *out = (void *)&data.out;
> +
> +	out->struct_exists = bpf_core_type_exists(struct a_struct);
> +	out->union_exists = bpf_core_type_exists(union a_union);
> +	out->enum_exists = bpf_core_type_exists(enum an_enum);
> +	out->typedef_named_struct_exists = bpf_core_type_exists(named_struct_typedef);
> +	out->typedef_anon_struct_exists = bpf_core_type_exists(anon_struct_typedef);
> +	out->typedef_struct_ptr_exists = bpf_core_type_exists(struct_ptr_typedef);
> +	out->typedef_int_exists = bpf_core_type_exists(int_typedef);
> +	out->typedef_enum_exists = bpf_core_type_exists(enum_typedef);
> +	out->typedef_void_ptr_exists = bpf_core_type_exists(void_ptr_typedef);
> +	out->typedef_func_proto_exists = bpf_core_type_exists(func_proto_typedef);
> +	out->typedef_arr_exists = bpf_core_type_exists(arr_typedef);
> +
> +	out->struct_sz = bpf_core_type_size(struct a_struct);
> +	out->union_sz = bpf_core_type_size(union a_union);
> +	out->enum_sz = bpf_core_type_size(enum an_enum);
> +	out->typedef_named_struct_sz = bpf_core_type_size(named_struct_typedef);
> +	out->typedef_anon_struct_sz = bpf_core_type_size(anon_struct_typedef);
> +	out->typedef_struct_ptr_sz = bpf_core_type_size(struct_ptr_typedef);
> +	out->typedef_int_sz = bpf_core_type_size(int_typedef);
> +	out->typedef_enum_sz = bpf_core_type_size(enum_typedef);
> +	out->typedef_void_ptr_sz = bpf_core_type_size(void_ptr_typedef);
> +	out->typedef_func_proto_sz = bpf_core_type_size(func_proto_typedef);
> +	out->typedef_arr_sz = bpf_core_type_size(arr_typedef);
> +#else
> +	data.skip = true;
> +#endif
> +	return 0;
> +}
> +

empty line at the end of file?
