Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8270E3679E2
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 08:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbhDVG0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 02:26:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2152 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229547AbhDVG0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 02:26:52 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13M6Olx0030498;
        Wed, 21 Apr 2021 23:26:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Vv22pK2Ku9KQbud5SDdswHuFljZKhuJ8PWoflhwSGdc=;
 b=SCZtwNjMRhrMwNyQ5vq1T5FSgzjEDZH1tbBhOUEgHuI3CmNVCPqD27QxzsqNj5K9Oduf
 ib4v7kUPngYq96wXJ7rQWoOfgNZbvI+flqTOyhhK20EPuWenih/QMuwHoBwNmyBYPdxj
 ubBFialAhVrkd0OrJaNQwmtiKCyGEwmmkKM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 382npsw5f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 21 Apr 2021 23:26:00 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 21 Apr 2021 23:25:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exufiNXbGd4uLjyvkVWUzbbp5ZRb7c4vy/buZhmZzOL4AjJJieGhBJle+VPWBNydr35HfB8oPyukmOLz83Ls7BKeHtij3pmtAnnAX1KDCcP9JpdRWEiaxN+JQqJsZ+OT44VCmm0Nm0pJnP/tOka2rAemhWfcmYBly9/DaHKeDl2UZfKo69MuEbJM086/ij/Fz7U/6FopaCj/X0pjz0jIaZV21TtRNOMfCKjEyE/H4kZYSek18dPd/KJiqBGLQcdHN7xavOc0CojKp1jUSUa6ODxjT+gqrr1g1CTNy4Kx6R4iobbA81IGovNOOiYpQiNGAeofKaJZ9dWx3n8KA5vm8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vv22pK2Ku9KQbud5SDdswHuFljZKhuJ8PWoflhwSGdc=;
 b=Z08ZcgZQjTotTqme3Rt7OvJmwJixuTbGlyPDIhXOm9ddfGJMEs+HoeEIoq0mNnF+urQb8tVa24Me3Q2/oniDbZycW+kudf9Fc9XwhNHnnm5cKWzV2JuLeQviGxmZnN+IW4FzHTqLi9jpa0/68YpSZgd9XBj3bZCG+O+YsPai4mhf5rTSU8VPcxA+j1zbQfsOtEA+JGeYPCiD2I2CUzDWeRZg9kO2lLknCkLxLTLJsMsCzWp+GBvg6uD2grc4OG1ftWxlsvxKjm6ivIWO53dB4HidAREX51ttFT51fqVe0NCMi7M1w+vrPVU2IJ0CV4pB860qt/97PBXCW90vKMcvqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4738.namprd15.prod.outlook.com (2603:10b6:806:19d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 06:25:55 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 06:25:55 +0000
Subject: Re: [PATCH v2 bpf-next 05/17] libbpf: allow gaps in BPF program
 sections to support overriden weak functions
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-6-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <71bfd67c-c8f0-595c-e721-201ec4e8e062@fb.com>
Date:   Wed, 21 Apr 2021 23:25:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-6-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:df89]
X-ClientProxiedBy: CO2PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:104:6::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::16ea] (2620:10d:c090:400::5:df89) by CO2PR04CA0091.namprd04.prod.outlook.com (2603:10b6:104:6::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Thu, 22 Apr 2021 06:25:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4557689-7101-40a1-e3a5-08d905577bf8
X-MS-TrafficTypeDiagnostic: SA1PR15MB4738:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4738EDCC077B65BCDF5A0263D3469@SA1PR15MB4738.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M8OU966brIWrnHhYlOwXg0xvnJT0bNU0IpWQFe0qV8kxUMd+Vo3a44SmWfSPc8eiL3V5us/EI+MR6Df8BFFwAnGf49qn18yHFPZmJ7WuuJifOFQCGrtF/b3W9YJrP1n0Ot4ClPjHuOFMvguTdEGnJwVPbOwkAHK+xTMnkvHnrHMNmfwJn0mtXfYM42KsU6pu4PkE/eiWObQg29tsXds/ogau9Dwg0fWfFLef2D9MQsg9ycdksfUURA8zoodRjpDPScpcdt3wLUBapL4m2DVLhRufE18I6ZZV9b15RIVFdVXgHUTL8O+eZczvNZkMbWDGA/GPG3hA8vCOzR23/ltjIOiNgDJ9Nli26lXJo61sdfolwPbv44Y096PTlGi6PcvXAZTjTdRsAi1BSXk9tqca+gNDKa+WIBHWL3LMe9kjy8Hb9Z5TsebL3TQ8V6T+pqigcYomhWHF+CF5u2bnFH+JtWYD87kp4uGfi3K266zBPAT3xyDoj+dwLugCgdW4gON8xxg+4xXDSuiN5P+6GC0fRZj50Lwfstx/Rowlxz16f3GE1LcnyKfe+B9C2PMojdTnHkuA+BOVHh5jtM94wGDh/trwHmZG1dGQT0sPUqfbEHlMvo/kmpBsZHc7wLYcyOhQuLjvFlF5RDgeXRE1Qh1qYy7WMJ4WNUe3RFlqRrkWhwKTggPJBTJZhOpN0W6IA/fm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(376002)(136003)(366004)(66946007)(5660300002)(316002)(478600001)(2616005)(52116002)(53546011)(31696002)(66556008)(36756003)(31686004)(8676002)(86362001)(6486002)(66476007)(6666004)(83380400001)(186003)(16526019)(2906002)(38100700002)(8936002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RVhsSGh6YUlhZDllZ0R5U1RaRitQUTg2ZUUvZEhiK2NFUSttNFNFM09MaDZU?=
 =?utf-8?B?MmxMSlBjNDltNUVSY0xORWI5allNeE5rQjQ1MGh2MGZEZGc2VE0rcy9oR3Bu?=
 =?utf-8?B?Q1FjdzhLdS9MUGhra3BKM0w3YjQxRTZuL2V1c20zN3pteWlYYUVYMWFGS0ZB?=
 =?utf-8?B?bnFqWjRDKzlxMjZQV0RHaUxvREN2amQzRUVheXkvakZDOGozdkorT2tpd1RH?=
 =?utf-8?B?Snh1eCthd3RpN1dmUUl4OHdndTNacHlmSEwxcytpeDVhTU5kMzNPeHI4Q1pp?=
 =?utf-8?B?SU5Kck0vUlhOUi9XOGtWZjh2eGEzellmWVgvQnhnb3VrMVVnbHMzMXU3blg3?=
 =?utf-8?B?Z0h3N2tpRXNWaGNsMkFFbU5IR0VENlNqL3ZxelFOTFJDVjFmakhrenh2azd4?=
 =?utf-8?B?VzFDaUltd2pFMjV4cU1EYmxTYm51Y1gwY0hSektCQ1I3bUlvNm9samV4Mkpz?=
 =?utf-8?B?YXhTdWRjSzhJM1E2cFRtS0pObDZRcERCS2pJQVd4bkcrYmpUMHlyK0FqZEdv?=
 =?utf-8?B?UGcvV0t0SUhvM2lvMWFFTG41WlUvb2hvSlhjTWFSTlFuVlFUeU5BMzArTnFW?=
 =?utf-8?B?b2lwdFppV3EyWVR2QjlTekVBeFJYYUNxQ1RYaDhzcXlWcWkvNDR0T3R5S2Mw?=
 =?utf-8?B?VHI4NGxnZWVHWUdGMmlZZ0tBVXl1UWthcGk3RjZTQTNwUDdEL3loOFhZU002?=
 =?utf-8?B?VXo5elpBbVVSdG5PSi95VXIyZkwwVk0xRUtWdnhubFNndzE3ZzZvRkZmYk1D?=
 =?utf-8?B?bHBpR05naVJaVVpiQjlUNnpTOXIwQlJVYXpCaGtHaXkyc0FudExRREh6Y3JT?=
 =?utf-8?B?dzN4SHQ4dWpIRnVybUlIWEYvS3RVRFEzQmJZNFBhcEtQc0F6Zmo3R1hTTGlE?=
 =?utf-8?B?ZDB0WTZxbGJNcUxpMWNWdFczN25FTlB4L2hYRGxBQklTUzUwZWx3Yk01SEt2?=
 =?utf-8?B?U0pzWmVqb2Z5RjNaK0diODM5SG5xQS8rT2x6eEdONlFsUHJ3ZTNTZkRqdTFU?=
 =?utf-8?B?NkNmbUViYlNnUmt6VVppRXRVSUNFTC9adDl6QVBNcUdMQUtzd2hsc1dIdkwy?=
 =?utf-8?B?T0s4RGlZMzZNeUMxdE1VaTdDcWhLWlJ2a2IvZG5vcVcyZkhnSEZPSUJXQjRh?=
 =?utf-8?B?UERHL0FVRVFyM3NXeFJQczYrQnBCWTNKYjBxNFZMSjBCTXdWMjNEVjBhNUl2?=
 =?utf-8?B?NW5vejF5ZVZDU3o0cUN0UGJIL2RTNFJXUmU4L1JrQjBEZ3p2TGsvYkNaSWhx?=
 =?utf-8?B?WjlhYVlXdEcwK3pVTE52alVUNkozZUhqTTFtdnBKdllwcHQxek9yKy84MDhw?=
 =?utf-8?B?eGxXVUE4WUhndlFmYzR2Zko4MDNxMXE0QkJKdzRUb05FKzg2dE9DalFwN2xO?=
 =?utf-8?B?c2xhL1FMbmxRQUcwLy9yWUtpK0NVekFRK01vemlNVGFwVFRoazBKWGxWeEtn?=
 =?utf-8?B?VFNWbVI1anNoS1czcTRhRGR6Nk5VWG1naVJ3dmlydzJjNm1mVGtqWDJqaG11?=
 =?utf-8?B?dGJTNGhYTWZtOFo2ZVdCWVBhMVppMXlHMVFMZ0sycXVFb1FJM0RJQXI5dlg4?=
 =?utf-8?B?V0tjaXV6ZU16VldDelQzRW8yZ0F0UkhORDJLQ3QvR2hJQTFtUXFZNVhId0Yz?=
 =?utf-8?B?aGo3b0dWUWovbzIzVGVFR0RjdnR1WlZZVDFEMDhNQ3RwdUU1a2o2Z0FhY2Zo?=
 =?utf-8?B?VzlxQ2o3WTNtdE5OT3N1bjhsQkhKZUtoaFJta0RIbXFnZFhIZExwVzkzL3NH?=
 =?utf-8?B?OWJuVmk2S0dkalJzOFpYcXBxV2RLUlhaMEN1ZHdDcVpPZkdFSnduRWl2MFRo?=
 =?utf-8?Q?Txvxv2VvJEC09csnWOWUTwT7Ra6LhRp9L5/h8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c4557689-7101-40a1-e3a5-08d905577bf8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 06:25:55.2756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1euol/LSG/fAfStphRFBJJI1zI2086cfCW1/uTa/30XuyhDCcyu/OLU5/WmOXjpw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4738
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: rLklhxAA1rjhXwmwn7KkNgZV5lYLX0kg
X-Proofpoint-ORIG-GUID: rLklhxAA1rjhXwmwn7KkNgZV5lYLX0kg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_01:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104220055
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> Currently libbpf is very strict about parsing BPF program isnstruction

isnstruction => instruction

> sections. No gaps are allowed between sequential BPF programs within a given
> ELF section. Libbpf enforced that by keeping track of the next section offset
> that should start a new BPF (sub)program and cross-checks that by searching for
> a corresponding STT_FUNC ELF symbol.
> 
> But this is too restrictive once we allow to have weak BPF programs and link
> together two or more BPF object files. In such case, some weak BPF programs
> might be "overriden" by either non-weak BPF program with the same name and

overriden => overridden

> signature, or even by another weak BPF program that just happened to be linked
> first. That, in turn, leaves BPF instructions of the "lost" BPF (sub)program
> intact, but there is no corresponding ELF symbol, because no one is going to
> be referencing it.
> 
> Libbpf already correctly handles such cases in the sense that it won't append
> such dead code to actual BPF programs loaded into kernel. So the only change
> that needs to be done is to relax the logic of parsing BPF instruction
> sections. Instead of assuming next BPF (sub)program section offset, iterate
> available STT_FUNC ELF symbols to discover all available BPF subprograms and
> programs.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Ack with a minor suggestion below.
Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/lib/bpf/libbpf.c | 56 ++++++++++++++++--------------------------
>   1 file changed, 21 insertions(+), 35 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ce5558d0a61b..a0e6d6bc47f3 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -502,8 +502,6 @@ static Elf_Scn *elf_sec_by_name(const struct bpf_object *obj, const char *name);
>   static int elf_sec_hdr(const struct bpf_object *obj, Elf_Scn *scn, GElf_Shdr *hdr);
>   static const char *elf_sec_name(const struct bpf_object *obj, Elf_Scn *scn);
>   static Elf_Data *elf_sec_data(const struct bpf_object *obj, Elf_Scn *scn);
> -static int elf_sym_by_sec_off(const struct bpf_object *obj, size_t sec_idx,
> -			      size_t off, __u32 sym_type, GElf_Sym *sym);
>   
>   void bpf_program__unload(struct bpf_program *prog)
>   {
> @@ -644,10 +642,12 @@ static int
>   bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
>   			 const char *sec_name, int sec_idx)
>   {
> +	Elf_Data *symbols = obj->efile.symbols;
>   	struct bpf_program *prog, *progs;
>   	void *data = sec_data->d_buf;
>   	size_t sec_sz = sec_data->d_size, sec_off, prog_sz;
> -	int nr_progs, err;
> +	size_t n = symbols->d_size / sizeof(GElf_Sym);

Maybe use "nr_syms" instead of "n" to be more descriptive?

> +	int nr_progs, err, i;
>   	const char *name;
>   	GElf_Sym sym;
>   
> @@ -655,14 +655,16 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
>   	nr_progs = obj->nr_programs;
>   	sec_off = 0;
>   
> -	while (sec_off < sec_sz) {
> -		if (elf_sym_by_sec_off(obj, sec_idx, sec_off, STT_FUNC, &sym)) {
> -			pr_warn("sec '%s': failed to find program symbol at offset %zu\n",
> -				sec_name, sec_off);
> -			return -LIBBPF_ERRNO__FORMAT;
> -		}
> +	for (i = 0; i < n; i++) {
> +		if (!gelf_getsym(symbols, i, &sym))
> +			continue;
> +		if (sym.st_shndx != sec_idx)
> +			continue;
> +		if (GELF_ST_TYPE(sym.st_info) != STT_FUNC)
> +			continue;
>   
>   		prog_sz = sym.st_size;
> +		sec_off = sym.st_value;
>   
>   		name = elf_sym_str(obj, sym.st_name);
>   		if (!name) {
> @@ -711,8 +713,6 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
>   
>   		nr_progs++;
>   		obj->nr_programs = nr_progs;
> -
> -		sec_off += prog_sz;
>   	}
>   
>   	return 0;
> @@ -2825,26 +2825,6 @@ static Elf_Data *elf_sec_data(const struct bpf_object *obj, Elf_Scn *scn)
>   	return data;
>   }
>   
[...]
