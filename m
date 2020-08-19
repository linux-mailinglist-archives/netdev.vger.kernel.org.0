Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E1C24A43D
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 18:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgHSQoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 12:44:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16520 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726734AbgHSQnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 12:43:37 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07JGeWBE001398;
        Wed, 19 Aug 2020 09:43:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=DOm0rJ/F0DhUn8gkeVBLnzD7fKPPfYl5zIChKzPEptY=;
 b=XcO5gQH84v1bqNcQvm9BnNqLVt+sQexEBO+GMfEOMyl203aa7teuByIqGX/nD5Xb6ROt
 /PHDsB1JwIavqG6wd8vKR6Rz3IzqYriCkDXMmyfMdtyOAykuIUa2fNorhUWn8UlBnRgx
 SURMoABuycPtStXNfR5vVtJgCNjhCSFwqSE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3304jq9ejx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Aug 2020 09:43:20 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 09:43:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihd3wP1/35ZBYxyBBk8QNcGSkywk76Gk8XiHYZGXD104ReDth5/5dCiqZqydbjLUFQoQMTuGqIsIESU7Ef3CaDn+T+MK0SdFuZBg+59GF53XSGZ/oZLk1A7IjDgnXavZnNqw+fLgI7HcC9x5Uzj7Ldim5T35nD6yYwMsuTM+4h2r2q3mn5aH3YT78wn2kSKduB9T/vp8FvBWmWLWDF/pOBe/Lwzoq5j4uYa2DRdCTwAsN3M2PumcWf+xF9SkH6Bzmf4iqVxmtCL22ccmeMHB5pK2r/D+o3784vguKI2woYu3FEQh/ba2fMa1v5omVKMZbgw1rQMYZ0wzyH8pnf4z7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOm0rJ/F0DhUn8gkeVBLnzD7fKPPfYl5zIChKzPEptY=;
 b=iWI1JviLT2U48GaqGKFqvKmyrbH3d9NxcGQ6w3NaZX7Rn45yc1KFJh6bhHEfq5aK7itgNI3uYC3IGcM35gqb9AmyaAgeI70uNRUD0445aeMhqDol7bUwfBnh5mHPSl70ZG3arUEHjs5hLLELTx4TIYQTmBK5LWdvyWuTa7EWS6plWHXWm7eKXXe1po/K40U3PhQ3qIPFrKKSakH3/IPxmJaeMU0s0u6JFtXfHv0rgq6wUX6QlbZmdj0bHEJRufMgTnKc7vwQWXW7kqSHsdmgr9ScorZJfUoe5HteLI6egIRnl8pZGIf8ahNGtqRD6k+elXbH9wQbMe6kNki+cJ8qUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOm0rJ/F0DhUn8gkeVBLnzD7fKPPfYl5zIChKzPEptY=;
 b=k9WMOcZQm8s76l8PgkenQztuhPRFFPzmWFEmbnVhFsgmfWtShcr+C/QJf902alIV6mqsLrGsVSN5cfRrfnM7zdCGVB8hYE6xprwnL5bCabcTlSEq+n0IoYmJ4iF8k4zAPML5rgp1/jgZOj2CeTmKE5nVahVciA+0aUGb6WF2Pqg=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2838.namprd15.prod.outlook.com (2603:10b6:a03:b4::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.22; Wed, 19 Aug
 2020 16:43:16 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 16:43:16 +0000
Subject: Re: [PATCH v2 bpf-next 3/5] selftests/bpf: add CO-RE relo test for
 TYPE_ID_LOCAL/TYPE_ID_TARGET
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200819052849.336700-1-andriin@fb.com>
 <20200819052849.336700-4-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <077f60a0-c457-15a1-ba5e-b2ec37457fcf@fb.com>
Date:   Wed, 19 Aug 2020 09:43:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819052849.336700-4-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:208:160::39) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:9a2) by MN2PR13CA0026.namprd13.prod.outlook.com (2603:10b6:208:160::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.15 via Frontend Transport; Wed, 19 Aug 2020 16:43:14 +0000
X-Originating-IP: [2620:10d:c091:480::1:9a2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 262f9b40-68cb-4c31-5ac7-08d8445ef8a9
X-MS-TrafficTypeDiagnostic: BYAPR15MB2838:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB283801DA30DF0B56D600FAB3D35D0@BYAPR15MB2838.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rHoTaQZN2ggdEpbMllsPxind1nfz0WQJelcTXoDamux1XLPCDK/hvoxYFBTEOthjdopKwGIt3jjm1ILGA8mQqLibJlj5bGVpC6glQlkkHDIkponEGuwfvDkGZ148qOTW+2q0oYYX51d4bR7EhuxFv/q2i9YBkSbmna+6NN/u3ilKcT4GEJFNWcW52Zf3o3qCt0GM9CBzCiNLgGmo/LRVFvXZgCI1Oe/3ckLNp2ck8cdJG9G5rrij9X0uzXj5G5W7QzQJAcfaWoDoOxUtQW/ks1x6lFfP4uP1MBFOf537wHZidXeDml3Pt+5+6GtioiJ0XmGBwvRCJbtLFoMkBn+kLR8+2H2lFri+YU3kpwoGWl90UJJkxJFUgJghFdQ52HV7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(366004)(136003)(346002)(186003)(6666004)(2616005)(5660300002)(86362001)(83380400001)(4326008)(36756003)(53546011)(31696002)(16526019)(8936002)(31686004)(6486002)(2906002)(478600001)(316002)(52116002)(66476007)(8676002)(66946007)(66556008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: BIZO6h6B5CvCNLZ5WxWtvT0tGXJG1MRMi2FT+khVLRPgpC0T9iz/bMPlUZtYulFKVdxROMfDTDoJXlN/i19AO2nFOO2fyEE3VBL1HF5WCB24sxL7l2mcgNTRGY1/MSOLjAfqQzTQQUdUuMpD1UYy5qhHFZa/QBwY6WElgZ6IZvZ9TdC/ZDuIchCiVY/sdJJYinGzG9V8K1UO6MOrWtLTtVzgS/7FVCI0vMOvPlhrEwaKCxbUTcEQqnII8FI3pD8gq0ZO7PD0eE5f7u3BoVlDkGtHBIMPsAJccJzVlcTl8folxAbKZm5bV8ypidtSMR5vEut9EUm55Arv4f/weQu2xBwCmDfXUsFtFw4g8ZdfJuuKmE+9uXbLnU9o4E7GzRMDvaPdPY58kFWMz1gm2yaSyhjfGLldUr72nycNj0HeVw9ClG6GpA3MpO/q+zL7H6pTZ++bs6zhmPalii05QOLXNci6SASLV3kZi2SnrnSUA5meP6Gn3eN3kGDy0GmxjN0xgAUoad8jFNBmjS8kwS6CeQdNB+uxwbUiTgL/T6zmzu2JixE+/HtHoh1VQ+WgzGMoFYIsWSSFH9LbcwMEEeDTG0SMfWnrG4/rJV2eKm7Vi3H7iN6RC9XyqRC0Q/zLinoDmFBCZTfJB1jZMhrpArk6Wy8A97nhbA4gbXRXvICGCiUcVeYRWzPxYt99tnK+XkJA
X-MS-Exchange-CrossTenant-Network-Message-Id: 262f9b40-68cb-4c31-5ac7-08d8445ef8a9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 16:43:16.4976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G6bR2Vl2Nk3/sZoU2P/CYTnKL2ixcymTdDjnhU/Sn522eehdhmI/4p2Wp4Ny9Wek
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2838
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_09:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190139
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/20 10:28 PM, Andrii Nakryiko wrote:
> Add tests for BTF type ID relocations. To allow testing this, enhance
> core_relo.c test runner to allow dynamic initialization of test inputs.
> If __builtin_btf_type_id() is not supported by Clang, skip tests.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>   .../selftests/bpf/prog_tests/core_reloc.c     | 168 +++++++++++++++++-
>   .../bpf/progs/btf__core_reloc_type_id.c       |   3 +
>   ...tf__core_reloc_type_id___missing_targets.c |   3 +
>   .../selftests/bpf/progs/core_reloc_types.h    |  40 +++++
>   .../bpf/progs/test_core_reloc_type_based.c    |  14 --
>   .../bpf/progs/test_core_reloc_type_id.c       | 107 +++++++++++
>   6 files changed, 316 insertions(+), 19 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_id.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_id___missing_targets.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_type_id.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> index b775ce0ede41..ad550510ef69 100644
> --- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> +++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> @@ -3,6 +3,9 @@
>   #include "progs/core_reloc_types.h"
>   #include <sys/mman.h>
>   #include <sys/syscall.h>
> +#include <bpf/btf.h>
> +
> +static int duration = 0;
>   
>   #define STRUCT_TO_CHAR_PTR(struct_name) (const char *)&(struct struct_name)
>   
[...]
> +
> +typedef struct a_struct named_struct_typedef;
> +
> +typedef int (*func_proto_typedef)(long);
> +
> +typedef char arr_typedef[20];
> +
> +struct core_reloc_type_id_output {
> +	int local_anon_struct;
> +	int local_anon_union;
> +	int local_anon_enum;
> +	int local_anon_func_proto_ptr;
> +	int local_anon_void_ptr;
> +	int local_anon_arr;
> +
> +	int local_struct;
> +	int local_union;
> +	int local_enum;
> +	int local_int;
> +	int local_struct_typedef;
> +	int local_func_proto_typedef;
> +	int local_arr_typedef;
> +
> +	int targ_struct;
> +	int targ_union;
> +	int targ_enum;
> +	int targ_int;
> +	int targ_struct_typedef;
> +	int targ_func_proto_typedef;
> +	int targ_arr_typedef;
> +};
> +
> +/* preserve types even if Clang doesn't support built-in */
> +struct a_struct t1 = {};
> +union a_union t2 = {};
> +enum an_enum t3 = 0;
> +named_struct_typedef t4 = {};
> +func_proto_typedef t5 = 0;
> +arr_typedef t6 = {};
> +
> +SEC("raw_tracepoint/sys_enter")
> +int test_core_type_id(void *ctx)
> +{
> +#if __has_builtin(__builtin_btf_type_id)

__builtin_btf_type_id is introduced in llvm11 but has issues for the 
following case:
    - struct t { ... } is defined
    - typedef struct t __t is defined
both "struct t" and "__t" are used in __builtin_btf_type_id in the same 
function. This is a corner case but it will make the test failure with 
llvm11.

I suggest to test builtin __builtin_preserve_type_info here with a 
comment to explain why. This will available test failure with llvm11.


> +	struct core_reloc_type_id_output *out = (void *)&data.out;
> +
> +	out->local_anon_struct = bpf_core_type_id_local(struct { int marker_field; });
> +	out->local_anon_union = bpf_core_type_id_local(union { int marker_field; });
> +	out->local_anon_enum = bpf_core_type_id_local(enum { MARKER_ENUM_VAL = 123 });
> +	out->local_anon_func_proto_ptr = bpf_core_type_id_local(_Bool(*)(int));
> +	out->local_anon_void_ptr = bpf_core_type_id_local(void *);
> +	out->local_anon_arr = bpf_core_type_id_local(_Bool[47]);
> +
> +	out->local_struct = bpf_core_type_id_local(struct a_struct);
> +	out->local_union = bpf_core_type_id_local(union a_union);
> +	out->local_enum = bpf_core_type_id_local(enum an_enum);
> +	out->local_int = bpf_core_type_id_local(int);
> +	out->local_struct_typedef = bpf_core_type_id_local(named_struct_typedef);
> +	out->local_func_proto_typedef = bpf_core_type_id_local(func_proto_typedef);
> +	out->local_arr_typedef = bpf_core_type_id_local(arr_typedef);
> +
> +	out->targ_struct = bpf_core_type_id_kernel(struct a_struct);
> +	out->targ_union = bpf_core_type_id_kernel(union a_union);
> +	out->targ_enum = bpf_core_type_id_kernel(enum an_enum);
> +	out->targ_int = bpf_core_type_id_kernel(int);
> +	out->targ_struct_typedef = bpf_core_type_id_kernel(named_struct_typedef);
> +	out->targ_func_proto_typedef = bpf_core_type_id_kernel(func_proto_typedef);
> +	out->targ_arr_typedef = bpf_core_type_id_kernel(arr_typedef);
> +#else
> +	data.skip = true;
> +#endif
> +
> +	return 0;
> +}
> +

empty line at the end of file?
