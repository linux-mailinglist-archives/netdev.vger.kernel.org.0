Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5408324A447
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 18:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgHSQpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 12:45:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62514 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726342AbgHSQpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 12:45:09 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JGdZvg002343;
        Wed, 19 Aug 2020 09:44:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9mYEprcoDNXSSNHtLOJPJdI3zxrTSBh3IHE5kPQqlUs=;
 b=BZubnJ6Hcu40emWIDtku9/de1hcDSq9aGtstmcksotStviWXjUxqW2y8vu/r4oL/8vQU
 CA+ew/jCce+cNjqncqEf0RHQFMILM3/Uly8+TiUlUCrSvMxRTG+ovZ3Z34+F8GmHsyC6
 TsMe2STLqgUpioEN/2JlhM7NDrNlvJaLdSc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304kpsee1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Aug 2020 09:44:55 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 09:44:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kdAEPcGsi08S+CvIxcltDECCpPy5zp0BWyx4419NYAUsSOkQMs81QUkngwwJ+ZL2fkFt4paNs29Opd4ZN5UCBDR+tJDcbX9IbIRjIjHxoTPdsFhxzgkajxHlZGUmPFth9JYG9scdoCrnJq8MtATcBVKsVznpmFpBQVDj8Ittka00RuEjnJVK9zT8WcHxNSKi+4T7cJFYe204RZ0XY7kLMgSC0VPSh9a4DPb2BvdC+GGkhP3n57Jm/JP7a5T5HfPemIAT+DW9EI67PFynNejc9bp+Gx7Zk+3SVoycyNNjt7gZyI+/cNRa9Ff3d4+8FhCCIr2KGigNFQCh2UXqowOu6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mYEprcoDNXSSNHtLOJPJdI3zxrTSBh3IHE5kPQqlUs=;
 b=MnDnPCrWGgPOc+tDjq6wVS57AkAKv4EdnRPz9684XTHQOHr6YDbEBJ1T4gwTqZ3mb1doz4xCkW3B5fMu9pZGzEDaztF7U890vazpzpWdR5EfdmZB6/kzRxPHpn1TqWsJAWa64rXsyYWhV2LnClx1H+MaXV8r+4mRwjGU5s9pWRBZoXnUkY9x0hHuWQBk9WYMSc28cqIBDBm4SD8q9BZdYqGER/IYpQxXncqVMA/sJtEwPU6KSN18sI6y+PWr794Up8qyEMHcxuYG51Ve/KxDeGHfs+WpJo9eF6mq5e5EDD2JRErWAThe6Gf1dokjUQeeWiy0iUoP68hOt8Abuhr38A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mYEprcoDNXSSNHtLOJPJdI3zxrTSBh3IHE5kPQqlUs=;
 b=kl0ZuTDSrM/2RgufmlELt/J99/Dx7l/Zp2wbtAIByT3yROrs6tZQ2TGY/EXrs2sU5yk/bI7HtZrOvhqOW1Ex63nfatBne79UTJNX9ScySgXC18xS1Nb9bp+/jc0DNNZwstyDEqWjhpIFz9Zt2iywBhJ1DZGTi2xxkjKcXu9nOcY=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2327.namprd15.prod.outlook.com (2603:10b6:a02:8e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.22; Wed, 19 Aug
 2020 16:44:37 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 16:44:37 +0000
Subject: Re: [PATCH v2 bpf-next 5/5] selftests/bpf: add tests for
 ENUMVAL_EXISTS/ENUMVAL_VALUE relocations
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200819052849.336700-1-andriin@fb.com>
 <20200819052849.336700-6-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <494555f1-7c3b-76e3-b8ad-bfd56cf36a8d@fb.com>
Date:   Wed, 19 Aug 2020 09:44:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819052849.336700-6-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:208:160::40) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:9a2) by MN2PR13CA0027.namprd13.prod.outlook.com (2603:10b6:208:160::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.15 via Frontend Transport; Wed, 19 Aug 2020 16:44:36 +0000
X-Originating-IP: [2620:10d:c091:480::1:9a2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6df74697-657c-47ba-29f3-08d8445f291a
X-MS-TrafficTypeDiagnostic: BYAPR15MB2327:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2327DC7A566050CEBF41CFEFD35D0@BYAPR15MB2327.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4qesVx7mQYzNvrPEb1agOLFs0b5e58421X5lkSIo24KW5gFgCnNpZwBtTbSfsn2KtWV2GEpuilekZPFrUE5jpbHxbeRv7iPp2lSED7wLoQPfZpfAlJVUoCeM+c6MOPlYDcWLbJkjNF2QnjkQMjU3WNSyB8tF2gC117ev4VTdKECAO+jJbShUqeyEfkLxLNhaLKbmPsvOI1F50RMR0a/YaKposmJoVy18H+lfBQEdQeK7vGNQwODbzwQ7FqF8eQJUpGK/zsSWtipNPLHeCPt1R7I8wOYZIi9uUHuGKrYxyLfRQaU9On6FJvu3HxL2yVF/B2CWQcMz2X5IwjKN+rF4MZu8Pu1K7Z8XcFfOtHUcVuz1p4AjL6l7hNo82SN/ZQiX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(346002)(39860400002)(136003)(2906002)(53546011)(31696002)(66556008)(316002)(8676002)(66476007)(52116002)(2616005)(86362001)(6666004)(4326008)(36756003)(66946007)(8936002)(478600001)(5660300002)(16526019)(186003)(6486002)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 5agIIcq1t4pz0Uxj/nzBmR3Ri3VTXCD52DtGhLB60+pDXavDi70LH43af/lObCUT18C52lYNohVl/ufd5nhPHLbx6hSEklXw5CkD3kq9nZVM+4fdJ7b4op6H/yQUKEAVI73Mxiqja6hquHjHp2j9NdhbTsrfYZWZnQemm9yTKmhE60FTumDWNLuJfLP0a/rEDko3HlTF9+Dw2Xqy8vYL1FHwOpPgJ5M+UBTWFx0YHgBA/qRmAUZL9Ur1OTmRHm2qHM8nnqZUQ8HI5fv6yoOSUn95kecrJisXghEgmsZG3p0ZplgG5ykoNJlYMpy+22SwjifOgSDtdeM3ZtUO1xD+pWNbvPzgWUl1VVhbl7ojcBtXIV+fY9E9ZSYftDSMK/36NqiIpPjOwWv84Jniy7HdTdNBDDRDP3zdh+v2jMV7vKNS+boY6884JMwKUTcFdwnWRLpG/LX1SQQQYZEAIXVVmV/SrfxQ2+SZyJsnkdbHppEXdDmHvVwF1HnkFrzOTb/ddY+st5geMF9WuosdLCukaGAJ8YUvzRDBiVBdgxIOikmmkpYIWlwcci7n8xRqTEIMWmbnQ6FBzcmBsxar71H2cKkCRf8F65ZNsF3dWKStamScCC67FEIWwyBxCMdE9pKWEAsEhezAm1fVtJRDeeoYM/NVYG7WuvvGoFacrUI7FnwhP/qQA/goSBYNnpluQsxn
X-MS-Exchange-CrossTenant-Network-Message-Id: 6df74697-657c-47ba-29f3-08d8445f291a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 16:44:37.7565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aGteLKuM88/K905F0u7QXstJTua1V3tsQg8KNTdN2wnPXm+IJczbmhadkCfhKAhq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2327
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_09:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190139
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/20 10:28 PM, Andrii Nakryiko wrote:
> Add tests validating existence and value relocations for enum value-based
> relocations. If __builtin_preserve_enum_value() built-in is not supported,
> skip tests.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>   .../selftests/bpf/prog_tests/core_reloc.c     | 56 +++++++++++++
>   .../bpf/progs/btf__core_reloc_enumval.c       |  3 +
>   .../progs/btf__core_reloc_enumval___diff.c    |  3 +
>   .../btf__core_reloc_enumval___err_missing.c   |  3 +
>   .../btf__core_reloc_enumval___val3_missing.c  |  3 +
>   .../selftests/bpf/progs/core_reloc_types.h    | 84 +++++++++++++++++++
>   .../bpf/progs/test_core_reloc_enumval.c       | 73 ++++++++++++++++
>   7 files changed, 225 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enumval.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enumval___diff.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enumval___err_missing.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enumval___val3_missing.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_enumval.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> index ad550510ef69..30e40ff4b0d8 100644
> --- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> +++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> @@ -289,6 +289,23 @@ static int duration = 0;
>   	.fails = true,							\
>   }
>   
[...]
> +
> +SEC("raw_tracepoint/sys_enter")
> +int test_core_enumval(void *ctx)
> +{
> +#if __has_builtin(__builtin_preserve_enum_value)
> +	struct core_reloc_enumval_output *out = (void *)&data.out;
> +	enum named_enum named = 0;
> +	anon_enum anon = 0;
> +
> +	out->named_val1_exists = bpf_core_enum_value_exists(named, NAMED_ENUM_VAL1);
> +	out->named_val2_exists = bpf_core_enum_value_exists(enum named_enum, NAMED_ENUM_VAL2);
> +	out->named_val3_exists = bpf_core_enum_value_exists(enum named_enum, NAMED_ENUM_VAL3);
> +
> +	out->anon_val1_exists = bpf_core_enum_value_exists(anon, ANON_ENUM_VAL1);
> +	out->anon_val2_exists = bpf_core_enum_value_exists(anon_enum, ANON_ENUM_VAL2);
> +	out->anon_val3_exists = bpf_core_enum_value_exists(anon_enum, ANON_ENUM_VAL3);
> +
> +	out->named_val1 = bpf_core_enum_value(named, NAMED_ENUM_VAL1);
> +	out->named_val2 = bpf_core_enum_value(named, NAMED_ENUM_VAL2);
> +	/* NAMED_ENUM_VAL3 value is optional */
> +
> +	out->anon_val1 = bpf_core_enum_value(anon, ANON_ENUM_VAL1);
> +	out->anon_val2 = bpf_core_enum_value(anon, ANON_ENUM_VAL2);
> +	/* ANON_ENUM_VAL3 value is optional */
> +#else
> +	data.skip = true;
> +#endif
> +
> +	return 0;
> +}
> +

empty line at the end of file?
