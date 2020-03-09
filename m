Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8248D17D91F
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 06:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgCIF6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 01:58:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13356 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725796AbgCIF6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 01:58:23 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0295uiWo012136;
        Sun, 8 Mar 2020 22:58:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=hGGPA/GT4S0c8nxmQaMvzX/UsBq09ZsjENp6uDwK6hE=;
 b=QtF+jJWxya2q91LAm+Tw3SOoDGyt+fSab/UjQEuCKW8gVaE3X0wAvmLfYEnBwA7+UK09
 EFfdRBWRPo/DTo6QsMXlQfLq+3seW6xngRzdsFo3g1RIfeGLys57rlMu6CMkjJPQMiEN
 CIMmVbXJKGjZ4O1RY2mmZ0F8k5NVpzIEMz4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yma7ywerh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 08 Mar 2020 22:58:09 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 8 Mar 2020 22:58:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkxx9HswJEztwKBd1xepIQyBsLOah3mSeM2GNQz4+lkau8kLU2LOMwnPASw8weSow17IUFDZ/ZzIh3LF18x0Kce6w4pokOdT2KFnQbN5S/NbCFbWSsqMagr0s5G16OaR8s0nIxWd/NlrNOFiQii92muwLtQp/5JBsD2h/WHfDpLSzDufIcRN7Bnlg5o76mF6WqEZY87rjTjCGdjUEqoXLrHxbumJzjcRNi1y1Ia4myD4e3+YrBYfc3Ll2SbnYfdTFBQPwiltYT7L2tjGbrYIzKb3o/65HctklFg36pPtX65SxfAgADx69f9hOo+7yXbo1/ff8qG/6T0gTeVT1xRuXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGGPA/GT4S0c8nxmQaMvzX/UsBq09ZsjENp6uDwK6hE=;
 b=ijMVh87+AHw5PvOaB13haIoGK7bIiuMVSpOk/zuLo2ICPjqGSzl4CBogsbcdXe5kHmzaANNY2kxDQKbtoMVWoTXHVaIM+cnJHonb8OryfhDqFWGPoPis5akkJIgnRVUm/QiypUBPzNFeieHhr5a7dRTaU7MEpuKZh5Gq650RW6NHQnHlqLwDs/JjV+NkkWbZbnGV590QQcqHglyPLYWyRCb0fc9RcjGx1XRoEGlJ4NcSOEco/bfjAofR3zbnAPh+JG/bMxPNxNOUVBrui1Qwe7wxRqKWF9RLhxSSt3z1Dk0JeHoEq9JoWa53uDSrzmuipS1jkCzauCsTGFaCSsqRdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGGPA/GT4S0c8nxmQaMvzX/UsBq09ZsjENp6uDwK6hE=;
 b=GSP5qtVxzALfeCW2IifHc0UrA+X6GG6mDYChShdGNmHx9s2b9Z9YtlJBFveMlNxkZeb5Oy29MODx1fKCzBtddhdha8PVg441lygvuJimpmqOJ+R0rb1cjydpYDRgH2c+BzMePlBIQXmV/gqfmPwQWwLrs93rdsIPem6vT+BYWCQ=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB2363.namprd15.prod.outlook.com (20.176.69.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Mon, 9 Mar 2020 05:58:03 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2793.013; Mon, 9 Mar 2020
 05:58:03 +0000
Subject: Re: [PATCH v5 bpf-next 1/4] bpftool: introduce "prog profile" command
To:     Song Liu <songliubraving@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <quentin@isovalent.com>, <kernel-team@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <arnaldo.melo@gmail.com>,
        <jolsa@kernel.org>
References: <20200307001713.3559880-1-songliubraving@fb.com>
 <20200307001713.3559880-2-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4fe1d235-21a5-0463-3079-ca1852b3510d@fb.com>
Date:   Sun, 8 Mar 2020 22:57:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <20200307001713.3559880-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR17CA0066.namprd17.prod.outlook.com
 (2603:10b6:300:93::28) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:23) by MWHPR17CA0066.namprd17.prod.outlook.com (2603:10b6:300:93::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11 via Frontend Transport; Mon, 9 Mar 2020 05:58:02 +0000
X-Originating-IP: [2620:10d:c090:400::5:23]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f87748f-0a08-44f0-edc0-08d7c3eed4a4
X-MS-TrafficTypeDiagnostic: DM6PR15MB2363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB236317CFE1B6ED4D52ED8B01D3FE0@DM6PR15MB2363.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0337AFFE9A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(366004)(346002)(376002)(189003)(199004)(2906002)(6512007)(81166006)(6506007)(5660300002)(53546011)(4326008)(8936002)(81156014)(6486002)(52116002)(8676002)(36756003)(66946007)(66556008)(66476007)(2616005)(6666004)(86362001)(31696002)(316002)(31686004)(186003)(16526019)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2363;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BVOjeFNXWuYeZrcm1bBGvj7QptTn+e+JDJ5RtlJeuDvwoztusG5ZymYDVOSGorIHDAbcbVs5+pQ/TdNsCtckQd2ECjzjXSE5mzVgSoyM0NllSVW1X6HjhZP3o6ZolVz0UGkc1wUB2blnfYHCtO3z6/rogXmkrICqpKurvwwpJnkWluiA+xlyFX7KTlMA96ve4xu1h0SIsbcGa1q0Dq/4X7fTfeYBW6YcG2noeHjXuXOvfET4xL90znJc0iPLZeLCua27+ByipdHH1FN9cp+/mIVmwu2YrQJ9sVZPO/8hCNuuFN9na/+HzCfggQQybZHMwo/vOopE2dJ7D9qGiStCXy9UFINPOcbqpg8AcSgw6M/RxvVYMqzJRlHfS1e2Eg2C3YiI45/RaMX1dbIPfJoftVu4aWPLOEVOXzI8j+5jRXW+nbG2gCXJUAEKhGGBQNti
X-MS-Exchange-AntiSpam-MessageData: gYu7cs2akuDTW9POIUCSdZWELz5HbHqiKUqUcgj3a516MUqK7hinlTMi8q4sskQhDo13eXziaKQIwx8i09v0sdVb2ITp2CStY3fkaAcQIr2syEqDc3X0dRK3F3F72rDPUD3CLRvLac9tFGAkiSDJmluyqTMspFv/U3CUh/dOZRw=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f87748f-0a08-44f0-edc0-08d7c3eed4a4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2020 05:58:03.6344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nb4CJp9vkUZUWo9/fff/CNZNjcvukoGS4gZQxFap83f5C30DvgB6YLy3Nf5110Yw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2363
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_01:2020-03-06,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 clxscore=1011 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090044
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/6/20 4:17 PM, Song Liu wrote:
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
>    ./bpftool prog profile id 337 duration 3 cycles instructions llc_misses
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
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   tools/bpf/bpftool/Makefile                |  18 +
>   tools/bpf/bpftool/prog.c                  | 424 +++++++++++++++++++++-
>   tools/bpf/bpftool/skeleton/profiler.bpf.c | 171 +++++++++
>   tools/bpf/bpftool/skeleton/profiler.h     |  47 +++
>   tools/scripts/Makefile.include            |   1 +
>   5 files changed, 660 insertions(+), 1 deletion(-)
>   create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
>   create mode 100644 tools/bpf/bpftool/skeleton/profiler.h

[...]

> diff --git a/tools/bpf/bpftool/skeleton/profiler.bpf.c b/tools/bpf/bpftool/skeleton/profiler.bpf.c
> new file mode 100644
> index 000000000000..20594ccb393d
> --- /dev/null
> +++ b/tools/bpf/bpftool/skeleton/profiler.bpf.c
> @@ -0,0 +1,171 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2020 Facebook
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


The above change has merged into tools/lib/bpf/bpf_tracing.h.
You can remove them by just including "bpf/bpf_tracing.h"?
