Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE897366361
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 03:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhDUBfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 21:35:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55782 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231475AbhDUBfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 21:35:08 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13L1Pa19018178;
        Tue, 20 Apr 2021 18:34:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Im0ElmkWJ1NdSlIaSIcFBUrCPRAkf1U+a3a1w+FJnGU=;
 b=bVAwg3QvdD8HW3xALhR1IRwo7iloTdSMTT9Z6tIheM61Ic7JsUA4AACk7Xc6PmSnEosO
 my+5/z7ENRNqIc1nSJ1xhjHrybcd9r6wELq9LBioH144I1dBsI/KYDC3xik4QaHC5Tp0
 565qK17wR42I6HoKkBY00KwgjiAT6vmuqkA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 382726gwgx-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Apr 2021 18:34:18 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Apr 2021 18:34:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=awX/oZ75QUatoRwZ+m6BJdh//ofhPUt53kBkw8gOJjbIUAQDdfuNcHiKcC/mlT8XiMw610FzhXC5VIuFbMDMgncl9vsRGify9+t2OrOkdMV+FLJTPPxPoMgnqUxjpLN9GpU3WFErKZ6yxnYYrx9CjcDteTfPotjuIOPjxx+iU3fOArqx+MVOd66Xew88C5Cpa9HtCEOFOG13tK7V1y38DWUUdruEWObsw7Ju/3mgWS5ZBIOZ2vI69IWGTPLqETLl/HWwMbx6U4g2uuRGNQp44tG7S1/870NjMp3dnrp1K1lu4wOdgiNJ0O0QFltI9TujXda5YNdH3OMVUFPMl90qHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Im0ElmkWJ1NdSlIaSIcFBUrCPRAkf1U+a3a1w+FJnGU=;
 b=nYfGjR3hS//fNcaQC+Szh/olbi9RRK5ixKvG70ZJ0fx6jPx5uEwGpcW+P9GvL7Mh9xELomnUJJ1Zz/zuDnMtuEXlsYSJ+1tiWTJAvRz2fk9pyd1zcsiyUmHtjJ8r2pV3CJ4dajpBm8vpuYxDW3OUQDGliapEMagp312qJIB1+73STsoNd7Xjy9ZaBzAOhpbaGLhhu7JlzfmKlZKMYHcNBJ3wQdbCKgIKHxYzHkgtLgO34XxXKYR7pUa4uwvsG+mM4MMTJrYzT3lcYloW5sjg+gHKOU0+GLlVtKdc0ZfmFxPKZAHviKzoLtg1P8WF39j4/qyEjulwv8Qp02FO6LwvHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4340.namprd15.prod.outlook.com (2603:10b6:806:1af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 21 Apr
 2021 01:34:15 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 01:34:15 +0000
Subject: Re: [PATCH bpf-next 13/15] libbpf: Generate loader program out of BPF
 ELF file.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
 <20210417033224.8063-14-alexei.starovoitov@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a63a54c3-e04a-e557-3fe1-dacfece1e359@fb.com>
Date:   Tue, 20 Apr 2021 18:34:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210417033224.8063-14-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:7b71]
X-ClientProxiedBy: MW4PR03CA0048.namprd03.prod.outlook.com
 (2603:10b6:303:8e::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1aae] (2620:10d:c090:400::5:7b71) by MW4PR03CA0048.namprd03.prod.outlook.com (2603:10b6:303:8e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Wed, 21 Apr 2021 01:34:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 322fa1cf-c3d9-444e-a257-08d9046592fc
X-MS-TrafficTypeDiagnostic: SA1PR15MB4340:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB43402C7B1AC508D90A9FB3B6D3479@SA1PR15MB4340.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PBLQABtMkLRKKZfbDXaxxtewklX3ZD4Gs1acrHivkq6Shs/OWezB4LOEJgVy93AyDe4i2CCNTGZlXaMdxtPbwnYus4HT4+cbX2bdsra9Rt72f6kr9HrAGp0xdmfVsCkMCJu/MHGhDDdv9lhtgl1kAnLS3GhaK0VlpwVD5Y423soroUkglj003WnsS8Yr4ui9G0q03fI6QIUJ68yl9qtlWc+Z0q/VV4APhgnhlSnqDOm7RXOAtpSr8cgJJEs7lrg5NKJW7JeSsIhpqsgVV/YMLOihbcwDUj1QlQjIjfHkdlrgJByjpRJ/qctSiYe961cMr/ZH5lSGEBhwxErQbndaxJ5Ss5pGsYuBlKKl4xJ/bLKqFSE1whV1PrfXFO49Gy+w0/LqxdQ1z2R+eoqQ/bupLz8OzoX0jj68nsZHjiP2TWxN71ACEDBNNTGKJKSv6jiZcMNN/2s2by3bA0uHGei8GQcaQYgODnz/fVvfSh+Ugh7VoFMVQKs7c6KQxwttNz5fKEjSeLCv58WTRupJjoROzsKz23tYVgfLS/vMC4WGYE3JVjrjFQIRHS8ZV91gQj5U1hwOoDSURAAX1PFxqWATusrnXYvxBKOVZwsrTK9UXesebGwiPmbnfyjs9fB+fwbGg5a+Vj7V2QOKjNy0ZvLG+W2o9k4VhXhyV/7W0hcXpURJKV599/AZuV8eAXCqxi7N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(39860400002)(136003)(396003)(31696002)(52116002)(2616005)(31686004)(8936002)(66946007)(6486002)(478600001)(30864003)(5660300002)(53546011)(316002)(38100700002)(36756003)(66476007)(83380400001)(186003)(16526019)(6666004)(8676002)(4326008)(2906002)(86362001)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aUlycVl3VGc4a0FYOE5ha0tFRkJqK09kTTdlMUI1cHVBdHpVOW0vb3ZXVnRq?=
 =?utf-8?B?UU9MSzFyOUZnVUMwMGo3RlJHdDNoeUQrYkZkUnRhdHM0NHJDR1hORENlWTVv?=
 =?utf-8?B?L2VJMHUrb2FLbG41a2RpNWhlckRuMVl2a0h2Z3hCSWFTb3YxM0RWT3ZRaWJv?=
 =?utf-8?B?Z0szMCtGTS9ieXdHdndyMzNBUFBWSWRiRnowZUgxOXhFZ3RYUUpVU2lPL01M?=
 =?utf-8?B?V0NwbTRsS285ZXZzNms4eVBRWFVySG9CNVMzOCtiaDJvK1kwc1RWdzhMUnNF?=
 =?utf-8?B?c1d2b0tTQitmbTdVczVUeElNU2pLbXNGRkpsMnp1WVdJY0xLb3diakFkVDEv?=
 =?utf-8?B?Wlp3NUcvcm5kUlVkdGxPTnpyWm8wV3B1RzNidFBTbWlEbkVoZktwcjh1Vk94?=
 =?utf-8?B?cUtJNmNJMFExL09mZXdEVFZ2RXYvK3lubE9VWHVxejRLQldEeHpsUlFJMUQ1?=
 =?utf-8?B?MWExTVBaVG51SXlnN3BWdnNCQ0NsZ1J5TlB4QjdKMzB2NkdSUXhGc2k2UThC?=
 =?utf-8?B?Yk5tbENIcE9WR0JyT2pRYlBTOFVpK0pOLzNTREdKWkE4OG9sZkMyUVJLSkxO?=
 =?utf-8?B?VzJqallLQytLNm0xVXhsb0dMbFJQdzNxSWZkSU9FZDI5c3dLTzQvQkNZSmxs?=
 =?utf-8?B?UForSVNFTW51akMwbUpUejEwS1RGS1p1c2pacHBqeFFvb3IxdUoxTGh3aHZO?=
 =?utf-8?B?akFEMm5KTE9VdDVEVWJIenF1eXZXVmpGaE0wSFRxZlJIRUprZy9DRlVXbms0?=
 =?utf-8?B?eEFENGJXVzYwKytGdUh6V054bEgreUVEa3psWWF5RmNQSmxTMkpkUFRmSzdE?=
 =?utf-8?B?em5Vd3ZMLzgwem9nQnJhNHNKR2IvOEtoWitkOHd2L2xwU1JodWsvQ2xGK2lr?=
 =?utf-8?B?c3B6cExVOFlVMXlBL1h0bjUvdEpmUlFtcmpLYW5pQTZQblhIU2JuWHlBU3hT?=
 =?utf-8?B?RFg3aDREZ210ZmZpYWN1TTZJcDdwcHIrNnBuL256K2l5MCtTaHVoNEVsQmlI?=
 =?utf-8?B?TkJXdnRJNEo5N09BdFlxWmtqaVV2R1QvWjF4Rnk5c3p2UCtnY2hDWGRyRTdU?=
 =?utf-8?B?dGR1akJXbllyODBna3F6aGNyWS9IUElTU3ZIUlp4cnVYS3dvckpOQ21CUlpG?=
 =?utf-8?B?S0ZTcnhYTVBIRkZaK1dnRWIwbTBKTmJtNE11Znc2VW1PM1NHRlI5cUQ2bTEz?=
 =?utf-8?B?U3p6c3plMStkZ01GUWowemhRdDlVVDF1U2lRdzdMeDdUT2JLU01QUFU2ZmVn?=
 =?utf-8?B?WTA1cDdxMTdybHN2TEgwRGlma1IweUd4OUNzckUzRm5KemFHaHlBclV6S1oz?=
 =?utf-8?B?L3F5Sko2T3BEOWNDbEM0QmxpZFBWQmhMWjBGTENVOWNLaWVKeTgzMUVKdWFp?=
 =?utf-8?B?a1BxQ0drUFh5S2RLQjFtNlNsM1lLVFR4OWE0RHlqamRpSm1yM09xY2grcW4x?=
 =?utf-8?B?TUl3SHJXOFM1SDV0NEtXMnlnQmFUTjJGWjd6Q1M2ajJJbkwwWTVTWnJIUzVH?=
 =?utf-8?B?RnJEY3lKTUpOWTdEc2lDck01UXJHdjJLbTUwUERxMFhOZ1R6MW1GVlQxTHVV?=
 =?utf-8?B?TVBiNUlVbGU4Z2lEcGVsQ3RIc0N2LzVDUW5TcGpsU0wzeVhZd3JTSGRVUzFt?=
 =?utf-8?B?SjZwUk5MTHlCaVBxWFdqSEpiWXhzeDFXWmNuKy9NbWhVWVlLYksxUFFuNTB1?=
 =?utf-8?B?QWFUdXBGZmQxV2NycFBrK0d2anNvb1hZRjh1OWplQ3IrRkFzL1ZnTTVTODAw?=
 =?utf-8?B?NUhjeDBWS0VFbUJ2RGxFcCszaFBjZ0p0NUQxdzBtVGVIdWFDR3VPMlArWVAv?=
 =?utf-8?B?dkIzRlh2bmtEVFhhYWVmUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 322fa1cf-c3d9-444e-a257-08d9046592fc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 01:34:15.5852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFYFzRR3JEBK5jbPFA6WHGJBs2NqyCdkst5OzwXIpNm7odCiMS94qyokwQTw+xWG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4340
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: c6ffnY_eybrDC9yL-RC0mWSn8u0un-Px
X-Proofpoint-GUID: c6ffnY_eybrDC9yL-RC0mWSn8u0un-Px
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_11:2021-04-20,2021-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104210010
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 8:32 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The BPF program loading process performed by libbpf is quite complex
> and consists of the following steps:
> "open" phase:
> - parse elf file and remember relocations, sections
> - collect externs and ksyms including their btf_ids in prog's BTF
> - patch BTF datasec (since llvm couldn't do it)
> - init maps (old style map_def, BTF based, global data map, kconfig map)
> - collect relocations against progs and maps
> "load" phase:
> - probe kernel features
> - load vmlinux BTF
> - resolve externs (kconfig and ksym)
> - load program BTF
> - init struct_ops
> - create maps
> - apply CO-RE relocations
> - patch ld_imm64 insns with src_reg=PSEUDO_MAP, PSEUDO_MAP_VALUE, PSEUDO_BTF_ID
> - reposition subprograms and adjust call insns
> - sanitize and load progs
> 
> During this process libbpf does sys_bpf() calls to load BTF, create maps,
> populate maps and finally load programs.
> Instead of actually doing the syscalls generate a trace of what libbpf
> would have done and represent it as the "loader program".
> The "loader program" consists of single map with:
> - union bpf_attr(s)
> - BTF bytes
> - map value bytes
> - insns bytes
> and single bpf program that passes bpf_attr(s) and data into bpf_sys_bpf() helper.
> Executing such "loader program" via bpf_prog_test_run() command will
> replay the sequence of syscalls that libbpf would have done which will result
> the same maps created and programs loaded as specified in the elf file.
> The "loader program" removes libelf and majority of libbpf dependency from
> program loading process.
> 
> kconfig, typeless ksym, struct_ops and CO-RE are not supported yet.

Beyond this, currently libbpf has a lot of flexibility between prog open
and load, change program type, key/value size, pin maps, max_entries, 
reuse map, etc. it is worthwhile to mention this in the cover letter.
It is possible that these changes may defeat the purpose of signing the
program though.

> 
> The order of relocate_data and relocate_calls had to change in order
> for trace generation to see all relocations for given program with
> correct insn_idx-es.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>   tools/lib/bpf/Build              |   2 +-
>   tools/lib/bpf/bpf.c              |  61 ++++
>   tools/lib/bpf/bpf.h              |  35 ++
>   tools/lib/bpf/bpf_gen_internal.h |  38 +++
>   tools/lib/bpf/gen_trace.c        | 529 +++++++++++++++++++++++++++++++
>   tools/lib/bpf/libbpf.c           | 199 ++++++++++--
>   tools/lib/bpf/libbpf.map         |   1 +
>   tools/lib/bpf/libbpf_internal.h  |   2 +
>   8 files changed, 834 insertions(+), 33 deletions(-)
>   create mode 100644 tools/lib/bpf/bpf_gen_internal.h
>   create mode 100644 tools/lib/bpf/gen_trace.c
> 
> diff --git a/tools/lib/bpf/Build b/tools/lib/bpf/Build
> index 9b057cc7650a..d0a1903bcc3c 100644
> --- a/tools/lib/bpf/Build
> +++ b/tools/lib/bpf/Build
> @@ -1,3 +1,3 @@
>   libbpf-y := libbpf.o bpf.o nlattr.o btf.o libbpf_errno.o str_error.o \
>   	    netlink.o bpf_prog_linfo.o libbpf_probes.o xsk.o hashmap.o \
> -	    btf_dump.o ringbuf.o strset.o linker.o
> +	    btf_dump.o ringbuf.o strset.o linker.o gen_trace.o
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index b96a3aba6fcc..517e4f949a73 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -972,3 +972,64 @@ int bpf_prog_bind_map(int prog_fd, int map_fd,
[...]
> +/* The layout of bpf_map_prog_desc and bpf_loader_ctx is feature dependent
> + * and will change from one version of libbpf to another and features
> + * requested during loader program generation.
> + */
> +union bpf_map_prog_desc {
> +	struct {
> +		__u32 map_fd;
> +		__u32 max_entries;
> +	};
> +	struct {
> +		__u32 prog_fd;
> +		__u32 attach_prog_fd;
> +	};
> +};
> +
> +struct bpf_loader_ctx {
> +	size_t sz;
> +	__u32 log_level;
> +	__u32 log_size;
> +	__u64 log_buf;
> +	union bpf_map_prog_desc u[];
> +};
> +
> +struct bpf_load_opts {
> +	size_t sz; /* size of this struct for forward/backward compatibility */
> +	struct bpf_loader_ctx *ctx;
> +	const void *data;
> +	const void *insns;
> +	__u32 data_sz;
> +	__u32 insns_sz;
> +};
> +#define bpf_load_opts__last_field insns_sz
> +
> +LIBBPF_API int bpf_load(const struct bpf_load_opts *opts);
> +
>   #ifdef __cplusplus
>   } /* extern "C" */
>   #endif
> diff --git a/tools/lib/bpf/bpf_gen_internal.h b/tools/lib/bpf/bpf_gen_internal.h
> new file mode 100644
> index 000000000000..a79f2e4ad980
> --- /dev/null
> +++ b/tools/lib/bpf/bpf_gen_internal.h
> @@ -0,0 +1,38 @@
> +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> +/* Copyright (c) 2021 Facebook */
> +#ifndef __BPF_GEN_INTERNAL_H
> +#define __BPF_GEN_INTERNAL_H
> +
> +struct relo_desc {
> +	const char *name;
> +	int kind;
> +	int insn_idx;
> +};
> +
> +struct bpf_gen {
> +	void *data_start;
> +	void *data_cur;
> +	void *insn_start;
> +	void *insn_cur;
> +	__u32 nr_progs;
> +	__u32 nr_maps;
> +	int log_level;
> +	int error;
> +	struct relo_desc *relos;
> +	int relo_cnt;
> +};
> +
> +void bpf_object__set_gen_trace(struct bpf_object *obj, struct bpf_gen *gen);
> +
> +void bpf_gen__init(struct bpf_gen *gen, int log_level);
> +int bpf_gen__finish(struct bpf_gen *gen);
> +void bpf_gen__load_btf(struct bpf_gen *gen, const void *raw_data, __u32 raw_size);
> +void bpf_gen__map_create(struct bpf_gen *gen, struct bpf_create_map_attr *map_attr, int map_idx);
> +struct bpf_prog_load_params;
> +void bpf_gen__prog_load(struct bpf_gen *gen, struct bpf_prog_load_params *load_attr, int prog_idx);
> +void bpf_gen__map_update_elem(struct bpf_gen *gen, int map_idx, void *value, __u32 value_size);
> +void bpf_gen__map_freeze(struct bpf_gen *gen, int map_idx);
> +void bpf_gen__record_find_name(struct bpf_gen *gen, const char *name, enum bpf_attach_type type);
> +void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind, int insn_idx);
> +
> +#endif
> diff --git a/tools/lib/bpf/gen_trace.c b/tools/lib/bpf/gen_trace.c
> new file mode 100644
> index 000000000000..1a80a8dd1c9f
> --- /dev/null
> +++ b/tools/lib/bpf/gen_trace.c
> @@ -0,0 +1,529 @@
> +// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> +/* Copyright (c) 2021 Facebook */
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <linux/filter.h>
> +#include "btf.h"
> +#include "bpf.h"
> +#include "libbpf.h"
> +#include "libbpf_internal.h"
> +#include "hashmap.h"
> +#include "bpf_gen_internal.h"
> +
> +#define MAX_USED_MAPS 64
> +#define MAX_USED_PROGS 32
> +
> +/* The following structure describes the stack layout of the loader program.
> + * In addition R6 contains the pointer to context.
> + * R7 contains the result of the last sys_bpf command (typically error or FD).
> + */
> +struct loader_stack {
> +	__u32 btf_fd;
> +	__u32 map_fd[MAX_USED_MAPS];
> +	__u32 prog_fd[MAX_USED_PROGS];
> +	__u32 inner_map_fd;
> +	__u32 last_btf_id;
> +	__u32 last_attach_btf_obj_fd;
> +};
> +#define stack_off(field) (__s16)(-sizeof(struct loader_stack) + offsetof(struct loader_stack, field))
> +
> +static int bpf_gen__realloc_insn_buf(struct bpf_gen *gen, __u32 size)
> +{
> +	size_t off = gen->insn_cur - gen->insn_start;
> +
> +	if (gen->error)
> +		return -ENOMEM;

return gen->error?

> +	if (off + size > UINT32_MAX) {
> +		gen->error = -ERANGE;
> +		return -ERANGE;
> +	}
> +	gen->insn_start = realloc(gen->insn_start, off + size);
> +	if (!gen->insn_start) {
> +		gen->error = -ENOMEM;
> +		return -ENOMEM;
> +	}
> +	gen->insn_cur = gen->insn_start + off;
> +	return 0;
> +}
> +
> +static int bpf_gen__realloc_data_buf(struct bpf_gen *gen, __u32 size)

Maybe change the return type to size_t? Esp. in the below
we have off + size > UINT32_MAX.

> +{
> +	size_t off = gen->data_cur - gen->data_start;
> +
> +	if (gen->error)
> +		return -ENOMEM;

return gen->error?

> +	if (off + size > UINT32_MAX) {
> +		gen->error = -ERANGE;
> +		return -ERANGE;
> +	}
> +	gen->data_start = realloc(gen->data_start, off + size);
> +	if (!gen->data_start) {
> +		gen->error = -ENOMEM;
> +		return -ENOMEM;
> +	}
> +	gen->data_cur = gen->data_start + off;
> +	return 0;
> +}
> +
> +static void bpf_gen__emit(struct bpf_gen *gen, struct bpf_insn insn)
> +{
> +	if (bpf_gen__realloc_insn_buf(gen, sizeof(insn)))
> +		return;
> +	memcpy(gen->insn_cur, &insn, sizeof(insn));
> +	gen->insn_cur += sizeof(insn);
> +}
> +
> +static void bpf_gen__emit2(struct bpf_gen *gen, struct bpf_insn insn1, struct bpf_insn insn2)
> +{
> +	bpf_gen__emit(gen, insn1);
> +	bpf_gen__emit(gen, insn2);
> +}
> +
> +void bpf_gen__init(struct bpf_gen *gen, int log_level)
> +{
> +	gen->log_level = log_level;
> +	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_6, BPF_REG_1));
> +	bpf_gen__emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_10, stack_off(last_attach_btf_obj_fd), 0));

Here we initialize last_attach_btf_obj_fd, do we need to initialize 
last_btf_id?

> +}
> +
> +static int bpf_gen__add_data(struct bpf_gen *gen, const void *data, __u32 size)
> +{
> +	void *prev;
> +
> +	if (bpf_gen__realloc_data_buf(gen, size))
> +		return 0;
> +	prev = gen->data_cur;
> +	memcpy(gen->data_cur, data, size);
> +	gen->data_cur += size;
> +	return prev - gen->data_start;
> +}
> +
> +static int insn_bytes_to_bpf_size(__u32 sz)
> +{
> +	switch (sz) {
> +	case 8: return BPF_DW;
> +	case 4: return BPF_W;
> +	case 2: return BPF_H;
> +	case 1: return BPF_B;
> +	default: return -1;
> +	}
> +}
> +
[...]
> +
> +static void __bpf_gen__debug(struct bpf_gen *gen, int reg1, int reg2, const char *fmt, va_list args)
> +{
> +	char buf[1024];
> +	int addr, len, ret;
> +
> +	if (!gen->log_level)
> +		return;
> +	ret = vsnprintf(buf, sizeof(buf), fmt, args);
> +	if (ret < 1024 - 7 && reg1 >= 0 && reg2 < 0)
> +		strcat(buf, " r=%d");

Why only for reg1 >= 0 && reg2 < 0?

> +	len = strlen(buf) + 1;
> +	addr = bpf_gen__add_data(gen, buf, len);
> +
> +	bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, addr));
> +	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_2, len));
> +	if (reg1 >= 0)
> +		bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_3, reg1));
> +	if (reg2 >= 0)
> +		bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_4, reg2));
> +	bpf_gen__emit(gen, BPF_EMIT_CALL(BPF_FUNC_trace_printk));
> +}
> +
> +static void bpf_gen__debug_regs(struct bpf_gen *gen, int reg1, int reg2, const char *fmt, ...)
> +{
> +	va_list args;
> +
> +	va_start(args, fmt);
> +	__bpf_gen__debug(gen, reg1, reg2, fmt, args);
> +	va_end(args);
> +}
> +
> +static void bpf_gen__debug_ret(struct bpf_gen *gen, const char *fmt, ...)
> +{
> +	va_list args;
> +
> +	va_start(args, fmt);
> +	__bpf_gen__debug(gen, BPF_REG_7, -1, fmt, args);
> +	va_end(args);
> +}
> +
> +static void bpf_gen__emit_sys_close(struct bpf_gen *gen, int stack_off)
> +{
> +	bpf_gen__emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_10, stack_off));
> +	bpf_gen__emit(gen, BPF_JMP_IMM(BPF_JSLE, BPF_REG_1, 0, 2 + (gen->log_level ? 6 : 0)));

The number "6" is magic. This refers the number of insns generated below 
with
    bpf_gen__debug_regs(gen, BPF_REG_9, BPF_REG_0, "close(%%d) = %%d");
At least some comment will be better.

> +	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_9, BPF_REG_1));
> +	bpf_gen__emit(gen, BPF_EMIT_CALL(BPF_FUNC_sys_close));
> +	bpf_gen__debug_regs(gen, BPF_REG_9, BPF_REG_0, "close(%%d) = %%d");
> +}
> +
> +int bpf_gen__finish(struct bpf_gen *gen)
> +{
> +	int i;
> +
> +	bpf_gen__emit_sys_close(gen, stack_off(btf_fd));
> +	for (i = 0; i < gen->nr_progs; i++)
> +		bpf_gen__move_stack2ctx(gen, offsetof(struct bpf_loader_ctx,
> +						      u[gen->nr_maps + i].map_fd), 4,

Maybe u[gen->nr_maps + i].prog_fd?
u[..] is a union, but prog_fd better reflects what it is.

> +					stack_off(prog_fd[i]));
> +	for (i = 0; i < gen->nr_maps; i++)
> +		bpf_gen__move_stack2ctx(gen, offsetof(struct bpf_loader_ctx,
> +						      u[i].prog_fd), 4,

u[i].map_fd?

> +					stack_off(map_fd[i]));
> +	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_0, 0));
> +	bpf_gen__emit(gen, BPF_EXIT_INSN());
> +	pr_debug("bpf_gen__finish %d\n", gen->error);
> +	return gen->error;
> +}
> +
> +void bpf_gen__load_btf(struct bpf_gen *gen, const void *btf_raw_data, __u32 btf_raw_size)
> +{
> +	union bpf_attr attr = {};
> +	int attr_size = offsetofend(union bpf_attr, btf_log_level);
> +	int btf_data, btf_load_attr;
> +
> +	pr_debug("btf_load: size %d\n", btf_raw_size);
> +	btf_data = bpf_gen__add_data(gen, btf_raw_data, btf_raw_size);
> +
> +	attr.btf_size = btf_raw_size;
> +	btf_load_attr = bpf_gen__add_data(gen, &attr, attr_size);
> +
> +	/* populate union bpf_attr with user provided log details */
> +	bpf_gen__move_ctx2blob(gen, btf_load_attr + offsetof(union bpf_attr, btf_log_level), 4,
> +			       offsetof(struct bpf_loader_ctx, log_level));
> +	bpf_gen__move_ctx2blob(gen, btf_load_attr + offsetof(union bpf_attr, btf_log_size), 4,
> +			       offsetof(struct bpf_loader_ctx, log_size));
> +	bpf_gen__move_ctx2blob(gen, btf_load_attr + offsetof(union bpf_attr, btf_log_buf), 8,
> +			       offsetof(struct bpf_loader_ctx, log_buf));
> +	/* populate union bpf_attr with a pointer to the BTF data */
> +	bpf_gen__emit_rel_store(gen, btf_load_attr + offsetof(union bpf_attr, btf), btf_data);
> +	/* emit BTF_LOAD command */
> +	bpf_gen__emit_sys_bpf(gen, BPF_BTF_LOAD, btf_load_attr, attr_size);
> +	bpf_gen__debug_ret(gen, "btf_load size %d", btf_raw_size);
> +	bpf_gen__emit_check_err(gen);
> +	/* remember btf_fd in the stack, if successful */
> +	bpf_gen__emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7, stack_off(btf_fd)));
> +}
> +
> +void bpf_gen__map_create(struct bpf_gen *gen, struct bpf_create_map_attr *map_attr, int map_idx)
> +{
> +	union bpf_attr attr = {};
> +	int attr_size = offsetofend(union bpf_attr, btf_vmlinux_value_type_id);
> +	bool close_inner_map_fd = false;
> +	int map_create_attr;
> +
> +	attr.map_type = map_attr->map_type;
> +	attr.key_size = map_attr->key_size;
> +	attr.value_size = map_attr->value_size;
> +	attr.map_flags = map_attr->map_flags;
> +	memcpy(attr.map_name, map_attr->name,
> +	       min((unsigned)strlen(map_attr->name), BPF_OBJ_NAME_LEN - 1));
> +	attr.numa_node = map_attr->numa_node;
> +	attr.map_ifindex = map_attr->map_ifindex;
> +	attr.max_entries = map_attr->max_entries;
> +	switch (attr.map_type) {
> +	case BPF_MAP_TYPE_PERF_EVENT_ARRAY:
> +	case BPF_MAP_TYPE_CGROUP_ARRAY:
> +	case BPF_MAP_TYPE_STACK_TRACE:
> +	case BPF_MAP_TYPE_ARRAY_OF_MAPS:
> +	case BPF_MAP_TYPE_HASH_OF_MAPS:
> +	case BPF_MAP_TYPE_DEVMAP:
> +	case BPF_MAP_TYPE_DEVMAP_HASH:
> +	case BPF_MAP_TYPE_CPUMAP:
> +	case BPF_MAP_TYPE_XSKMAP:
> +	case BPF_MAP_TYPE_SOCKMAP:
> +	case BPF_MAP_TYPE_SOCKHASH:
> +	case BPF_MAP_TYPE_QUEUE:
> +	case BPF_MAP_TYPE_STACK:
> +	case BPF_MAP_TYPE_RINGBUF:
> +		break;
> +	default:
> +		attr.btf_key_type_id = map_attr->btf_key_type_id;
> +		attr.btf_value_type_id = map_attr->btf_value_type_id;
> +	}
> +
> +	pr_debug("map_create: %s idx %d type %d value_type_id %d\n",
> +		 attr.map_name, map_idx, map_attr->map_type, attr.btf_value_type_id);
> +
> +	map_create_attr = bpf_gen__add_data(gen, &attr, attr_size);
> +	if (attr.btf_value_type_id)
> +		/* populate union bpf_attr with btf_fd saved in the stack earlier */
> +		bpf_gen__move_stack2blob(gen, map_create_attr + offsetof(union bpf_attr, btf_fd), 4,
> +					 stack_off(btf_fd));
> +	switch (attr.map_type) {
> +	case BPF_MAP_TYPE_ARRAY_OF_MAPS:
> +	case BPF_MAP_TYPE_HASH_OF_MAPS:
> +		bpf_gen__move_stack2blob(gen, map_create_attr + offsetof(union bpf_attr, inner_map_fd),
> +					 4, stack_off(inner_map_fd));
> +		close_inner_map_fd = true;
> +		break;
> +	default:;
> +	}
> +	/* emit MAP_CREATE command */
> +	bpf_gen__emit_sys_bpf(gen, BPF_MAP_CREATE, map_create_attr, attr_size);
> +	bpf_gen__debug_ret(gen, "map_create %s idx %d type %d value_size %d",
> +			   attr.map_name, map_idx, map_attr->map_type, attr.value_size);
> +	bpf_gen__emit_check_err(gen);
> +	/* remember map_fd in the stack, if successful */
> +	if (map_idx < 0) {
> +		bpf_gen__emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7, stack_off(inner_map_fd)));

Some comments here to indicate map_idx < 0 is for inner map creation 
will help understand the code.

> +	} else {
> +		if (map_idx != gen->nr_maps) {
> +			gen->error = -EDOM; /* internal bug */
> +			return;
> +		}
> +		bpf_gen__emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7, stack_off(map_fd[map_idx])));
> +		gen->nr_maps++;
> +	}
> +	if (close_inner_map_fd)
> +		bpf_gen__emit_sys_close(gen, stack_off(inner_map_fd));
> +}
> +
> +void bpf_gen__record_find_name(struct bpf_gen *gen, const char *attach_name,
> +			       enum bpf_attach_type type)
> +{
> +	const char *prefix;
> +	int kind, len, name;
> +
> +	btf_get_kernel_prefix_kind(type, &prefix, &kind);
> +	pr_debug("find_btf_id '%s%s'\n", prefix, attach_name);
> +	len = strlen(prefix);
> +	if (len)
> +		name = bpf_gen__add_data(gen, prefix, len);
> +	name = bpf_gen__add_data(gen, attach_name, strlen(attach_name) + 1);
> +	name -= len;
> +
> +	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_1, 0));
> +	bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_2, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, name));
> +	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_3, kind));
> +	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_4, BPF_REG_10));
> +	bpf_gen__emit(gen, BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, stack_off(last_attach_btf_obj_fd)));
> +	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_5, 0));
> +	bpf_gen__emit(gen, BPF_EMIT_CALL(BPF_FUNC_btf_find_by_name_kind));
> +	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_0));
> +	bpf_gen__debug_ret(gen, "find_by_name_kind(%s%s,%d)", prefix, attach_name, kind);
> +	bpf_gen__emit_check_err(gen);
> +	/* remember btf_id */
> +	bpf_gen__emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7, stack_off(last_btf_id)));
> +}
> +
> +void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind, int insn_idx)
> +{
> +	struct relo_desc *relo;
> +
> +	relo = libbpf_reallocarray(gen->relos, gen->relo_cnt + 1, sizeof(*relo));
> +	if (!relo) {
> +		gen->error = -ENOMEM;
> +		return;
> +	}
> +	gen->relos = relo;
> +	relo += gen->relo_cnt;
> +	relo->name = name;
> +	relo->kind = kind;
> +	relo->insn_idx = insn_idx;
> +	gen->relo_cnt++;
> +}
> +
> +static void bpf_gen__emit_relo(struct bpf_gen *gen, struct relo_desc *relo, int insns)
> +{
> +	int name, insn;
> +
> +	pr_debug("relo: %s at %d\n", relo->name, relo->insn_idx);
> +	name = bpf_gen__add_data(gen, relo->name, strlen(relo->name) + 1);
> +
> +	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_1, 0));
> +	bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_2, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, name));
> +	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_3, relo->kind));
> +	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_4, BPF_REG_10));
> +	bpf_gen__emit(gen, BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, stack_off(last_attach_btf_obj_fd)));
> +	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_5, 0));
> +	bpf_gen__emit(gen, BPF_EMIT_CALL(BPF_FUNC_btf_find_by_name_kind));
> +	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_0));
> +	bpf_gen__debug_ret(gen, "find_by_name_kind(%s,%d)", relo->name, relo->kind);
> +	bpf_gen__emit_check_err(gen);
> +	/* store btf_id into insn[insn_idx].imm */
> +	insn = (int)(long)&((struct bpf_insn *)(long)insns)[relo->insn_idx].imm;

This is really fancy. Maybe something like
	insn = insns + sizeof(struct bpf_insn) * relo->insn_idx + 
offsetof(struct bpf_insn, imm).
Does this sound better?

> +	bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_0, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, insn));
> +	bpf_gen__emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_0, BPF_REG_7, 0));
> +}
> +
[...]
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 083e441d9c5e..a61b4d401527 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -54,6 +54,7 @@
>   #include "str_error.h"
>   #include "libbpf_internal.h"
>   #include "hashmap.h"
> +#include "bpf_gen_internal.h"
>   
>   #ifndef BPF_FS_MAGIC
>   #define BPF_FS_MAGIC		0xcafe4a11
> @@ -435,6 +436,8 @@ struct bpf_object {
>   	bool loaded;
>   	bool has_subcalls;
>   
> +	struct bpf_gen *gen_trace;
> +
>   	/*
>   	 * Information when doing elf related work. Only valid if fd
>   	 * is valid.
> @@ -2651,7 +2654,15 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
>   		bpf_object__sanitize_btf(obj, kern_btf);
>   	}
>   
> -	err = btf__load(kern_btf);
> +	if (obj->gen_trace) {
> +		__u32 raw_size = 0;
> +		const void *raw_data = btf__get_raw_data(kern_btf, &raw_size);
> +
> +		bpf_gen__load_btf(obj->gen_trace, raw_data, raw_size);
> +		btf__set_fd(kern_btf, 0);
> +	} else {
> +		err = btf__load(kern_btf);
> +	}
>   	if (sanitize) {
>   		if (!err) {
>   			/* move fd to libbpf's BTF */
> @@ -4277,6 +4288,17 @@ static bool kernel_supports(enum kern_feature_id feat_id)
>   	return READ_ONCE(feat->res) == FEAT_SUPPORTED;
>   }
>   
> +static void mark_feat_supported(enum kern_feature_id last_feat)
> +{
> +	struct kern_feature_desc *feat;
> +	int i;
> +
> +	for (i = 0; i <= last_feat; i++) {
> +		feat = &feature_probes[i];
> +		WRITE_ONCE(feat->res, FEAT_SUPPORTED);
> +	}

This assumes all earlier features than FD_IDX are supported. I think 
this is probably fine although it may not work for some weird backport.
Did you see any issues if we don't explicitly set previous features
supported?

> +}
> +
>   static bool map_is_reuse_compat(const struct bpf_map *map, int map_fd)
>   {
>   	struct bpf_map_info map_info = {};
> @@ -4344,6 +4366,13 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
>   	char *cp, errmsg[STRERR_BUFSIZE];
>   	int err, zero = 0;
>   
> +	if (obj->gen_trace) {
> +		bpf_gen__map_update_elem(obj->gen_trace, map - obj->maps,
> +					 map->mmaped, map->def.value_size);
> +		if (map_type == LIBBPF_MAP_RODATA || map_type == LIBBPF_MAP_KCONFIG)
> +			bpf_gen__map_freeze(obj->gen_trace, map - obj->maps);
> +		return 0;
> +	}
>   	err = bpf_map_update_elem(map->fd, &zero, map->mmaped, 0);
>   	if (err) {
>   		err = -errno;
> @@ -4369,7 +4398,7 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
>   
>   static void bpf_map__destroy(struct bpf_map *map);
[...]
> @@ -9383,7 +9512,13 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd,
>   	}
>   
>   	/* kernel/module BTF ID */
> -	err = find_kernel_btf_id(prog->obj, attach_name, attach_type, btf_obj_fd, btf_type_id);
> +	if (prog->obj->gen_trace) {
> +		bpf_gen__record_find_name(prog->obj->gen_trace, attach_name, attach_type);
> +		*btf_obj_fd = 0;
> +		*btf_type_id = 1;

We have quite some codes like this and may add more to support more 
features. I am wondering whether we could have some kind of callbacks
to make the code more streamlined. But I am not sure how easy it is.

> +	} else {
> +		err = find_kernel_btf_id(prog->obj, attach_name, attach_type, btf_obj_fd, btf_type_id);
> +	}
>   	if (err) {
>   		pr_warn("failed to find kernel BTF type ID of '%s': %d\n", attach_name, err);
>   		return err;
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index b9b29baf1df8..a5dffc0a3369 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -361,4 +361,5 @@ LIBBPF_0.4.0 {
>   		bpf_linker__new;
>   		bpf_map__inner_map;
>   		bpf_object__set_kversion;
> +		bpf_load;

Based on alphabet ordering, this should move a few places earlier.

I will need to go through the patch again for better understanding ...
