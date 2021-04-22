Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333A3367961
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 07:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhDVFoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 01:44:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58574 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229547AbhDVFoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 01:44:06 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13M5dpbN002475;
        Wed, 21 Apr 2021 22:43:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=RqzE3VA6+UvDRAjcUN+kEG7u1RebuyVLc7l1hnGqDuE=;
 b=g5ozZUbNg89bHwqC9HCkKq/IEaVoHALG1jtIvzSF7Ibx0LjIiRChBteRVIJIMEv9bhXf
 JMq1vzJ/85+olzssYtNDqOtfP/PBN3b+GRW5WGFe1lRj1offkr7ztf0nm8jKsU1cW+rd
 xejxdgxm6IYPcvZAsAxANvcrSJ7cIqpI55o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 382p4smv9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 21 Apr 2021 22:43:19 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 21 Apr 2021 22:43:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYe7n+QEPzZ/sfFouLZ/0Ymy5nh+2F1jC5LEnoc5Z5Wu0wiQtjWpwWr/lrLGG2dwWqs/aYFkN59J/Zi0BnlzWNkYGlER3JjQDVm+TIh5vVf8wGNQFI1j1EM6NWVwPfP5fHXmWZxTvHd4W9fNJJrnoY7qjBWE9HeJJowN2v8gQ/2gggWwMT4h7Mg5IIN/wKO1WtKz1K7CNrAoBF7wiVNz2D9hDywuS1zTmTBBALhNwwu36zemNH0ez6NjVWWN+p/L16cyFKsZtJZQ32TMiYBYzdnpfuOQ/wWx753dy3Oq2ZKK5sVz06/qGOoKEtmfiuSywNXiD3ltK9CuzAgH31Bn5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqzE3VA6+UvDRAjcUN+kEG7u1RebuyVLc7l1hnGqDuE=;
 b=O5HhxM7mo8TA5UIoXeW4ZXGrpOr081TL9Hh6VW7Jl9Co0P2KHNpzgtI9hs1QSjn9me4lJQ2VxmFJJhcb8jP5kd2Rsa0LEzxtI5f8sW1aJMQbHXX4ae1DtibS6sqX0uja3WaFoyooMiOCqSJGVCOEWov/KeYxORSvSLKtpZjzDDOsTZtZZimF5mY9N5Ai8fNwTPqY7DEeggnX5sxsVPhLhlkIX0KVr0P73R0ekeQCBVgoDLL14xhkynoYN8rFEOpIeY/Kb5cbdyZBu8pYRxD1jKWxqVWK+ATk62gU1oliqgLT3evXnq29HZJhuV8oUUJWehdcHwWFvXMXGhfbFf+ZUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2253.namprd15.prod.outlook.com (2603:10b6:805:20::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 05:43:18 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 05:43:18 +0000
Subject: Re: [PATCH v2 bpf-next 04/17] libbpf: mark BPF subprogs with hidden
 visibility as static for BPF verifier
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-5-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <8cde2756-e62f-7103-05b1-7d9a9d97442a@fb.com>
Date:   Wed, 21 Apr 2021 22:43:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-5-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:df89]
X-ClientProxiedBy: MW4PR04CA0059.namprd04.prod.outlook.com
 (2603:10b6:303:6a::34) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::16ea] (2620:10d:c090:400::5:df89) by MW4PR04CA0059.namprd04.prod.outlook.com (2603:10b6:303:6a::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Thu, 22 Apr 2021 05:43:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56b30156-d861-4748-61ed-08d9055187c6
X-MS-TrafficTypeDiagnostic: SN6PR15MB2253:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB22539CEE40C94B2FAAC49BD4D3469@SN6PR15MB2253.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vgaiCaULLrCfIqcOEmqOYIFbj9nVdLfJv1nsntqO2rkwy/Hpuj3rUBsIQcCi8wZS7RdAmwfV0R4uV+ZaLVxg+FLM1YJXOfESIcR/Fru0+BLPc+PLIXI9ZpS7gLNdyinDApetvybUzKkkPGd/yw6FzMJy230kBcxjELPn1fzSWUuce5QrbOvY4LFuPjLGFekDc1KhHQU92P6LGS321OIyuBrP+6YYU7Q73fZP/I59vnU+tVWtc7rb8RU2fAdy/qB7uRadUvfsmH/x1TchJy/B4ZFLSAs25jigvkPwjNkuvQJeZt+uy99O3ywYNuWTwNujj2IQpddhyCc1Zs/c/vddP4X6FcY7+pVKSidWKVXXwWUFwgxFrT+/VWtl8Hltiao99oQyayc0S1H3g1ivYFC8Evfkfcqad80dO0ptgMuAW7NJMTE5W2BkVTjlPm6JxNGw0NTkbYsPvY0GB35V8eqe1yYcRDYwvrgp1M6E2SaxSf3t3ukRvwRUZ3pWDO+mIP5nQkUyfX+Uat6gBLgEMaVq6bulZJnBsbUw2TATXTRcQig+qnNBRWr6De4mApFSV3XKsNnJCuPa6Wu19ZenNkf2aenBoKQajzlz3WDbaz+YKk0aK6QoiSdf9ww4S0vdRbzpSeoPSAhtEPdTzHH2GvBproIxo605M+U1pFVowM27sz20Wstn9GvOkxG3sLdyTMlm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(39860400002)(376002)(396003)(31696002)(66946007)(53546011)(5660300002)(8676002)(31686004)(6666004)(478600001)(8936002)(66476007)(36756003)(38100700002)(4326008)(83380400001)(16526019)(66556008)(316002)(186003)(52116002)(86362001)(2616005)(6486002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WEFtc0dHYVRHa0lVUGFRUmttekZIMmJ4amtPZlQ0eDJkckxGRGdtK0VNWjlC?=
 =?utf-8?B?NTExczZPZDF5cDU1S3RRTk5BTHVPVmpRZFJmTURSS3pEcW1RR3NWUU5aellS?=
 =?utf-8?B?TGQ0Mkl5Nmh2T1R5emRQOVRUL0QxanVrRG9pcjdqaXd1UHU5UWhKQ2pWbDdv?=
 =?utf-8?B?WCtyVHF2OEZOSTV2eXptS2JnVVI5ekQ5RS9LelJ3aDRId0VyWEtXWnVqMk10?=
 =?utf-8?B?VWNQRjF3MFNWNWpXaEZMN0JZK0kyNERURC9ySEdYQUpleWVqZkZwQ21VZWpq?=
 =?utf-8?B?SXUyVW5xMUZvNm1SV0xlbVJXT2xVdVFoTXBBWVBaZnovdysyaE4vQkRCWU5L?=
 =?utf-8?B?d3JST041a0R5TE1uNlVyaFU3SjBIa1BZZWpCdW42MDB3RzAzUDFGZVozdDg5?=
 =?utf-8?B?cll6bzV4VFVXcTBrRllleTFldE02bUh6NlVGQVg3VUppNFY3VDJDVTlXdGlB?=
 =?utf-8?B?WDlmT3BLWVlodmZRTXh1NlZCamdQU0NFZERIOHRUYmpsNEYvaVErNUVrWEdG?=
 =?utf-8?B?SFpKem83bzkrWjBFaHc0aXB0Mi9xR1k3UnZQQWJ2bkJhRmU4eTAvL2MzdjVZ?=
 =?utf-8?B?UDdvd21Jb2FKMWhGV0FFVEtkNHVKSkt6TWljYzV4WFc0M0dSR1Z0MWtKOHBS?=
 =?utf-8?B?U08yTnptZmw2TitPL3MyQ0FKZ2RQSmpzSzJDMDE0WTQxMkplMlhZYkVtcllC?=
 =?utf-8?B?cjJqMVdIZFBuVklGOWhTaGdBYTdJUXBVdnVXTlcyTXY2RU52MXBPU3pNek92?=
 =?utf-8?B?TUVDQUtYc0xqRWRNSkFSQXBhQ29IUW9oUStQbEFRZCtuNWJGaHFoL2hNYm5v?=
 =?utf-8?B?SW5UaGRKNmlndG92bWVDSnhIWG1WN09XZE5ETit3c21MV0UxUE9tazJWOEgy?=
 =?utf-8?B?UXJtQVEzUHl2RHM1QXI3R2QxbENtTlJPOVhjcGVpTGlydEsycm5scGdiV0FD?=
 =?utf-8?B?R0M3dUczNjVtWkNpcllVeTR1ZjkwWUw2bnhxZDBRejRyMG04blpBSStmbGIz?=
 =?utf-8?B?bDdlMHBrVG9DSlBsVjUzakdYS3NwbEF6NDNuMEZ0anB2ZjF1L0RtU003SXJF?=
 =?utf-8?B?MXhNTTdEWmpSVTQ1dVBkcnFydkdadGxjd2huNU8xQmV2YXNwN3E0dFcwSzNs?=
 =?utf-8?B?ZDNRU0hGTGt2anFlRmFuUy9Vd1ZJNTI3dU1RM3hQYkVkeGduRjJyZTcvK295?=
 =?utf-8?B?bHVsM3B1eW5QT1Qrc3dNK1dRVkp5TXNMK1dKSU4yVk9tMkk5R1ppdGplZ2ds?=
 =?utf-8?B?STU0bDlmdjRwN3hOeXBBeWJNR1A4VzlyNWI4anRFUkNJYmFPVERPMURQWUQx?=
 =?utf-8?B?WW1kNmZZRzhWQlROL1JQQmlrT29LYlQwNmc3aGt6OE5Oa1RFbjBWY0FyK1VM?=
 =?utf-8?B?MUNzeUVDYWxOQTkydFZEUWc0WkhOZCtrcmhwbzcrc1VjUXhaV1pKZHgvSlVD?=
 =?utf-8?B?OGJEdW05QkFHT2lnTEpNWFUyVHBWWlIveU1rRVQ4cno1V2lua1FhOVNBc25r?=
 =?utf-8?B?alR2bnV5N2pMa0pqMnlOaXJ6dis2WERYMXJPMXBPVllxWG9sYmxOa2Fxd2ty?=
 =?utf-8?B?SnlrZXVZVHN3NW8zbVhRNnRmUjJ6REk5STRmWUFlV2hvMlZhN3Y3QUxmdWUv?=
 =?utf-8?B?UmNFVGVhNmZpREtTbExERjZadTJoQSsvU0UyODYvc3BkMzIzZjg3d2l4OG0v?=
 =?utf-8?B?VWYvUTVXdytVYXpGdzVrbE9Od3JLMG9mY094OThQRVFkSWR0ZEU0dlVjMXlp?=
 =?utf-8?B?andlVmNzVi80NTFqbERXZ280aG5YT0MwS2c2Y1JVbEkrNkVUMFIvcXhTSFRm?=
 =?utf-8?Q?1JeqTc7P2feJToZUtfC8utjmPFkkfIyuN5JbY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b30156-d861-4748-61ed-08d9055187c6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 05:43:18.0179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PeN2UAli5fqr9ey/efuTcGcOomvpiDH4vLiIB75C+5miRjiv3VvfjzffpuK6FeuD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2253
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: csUom0kO7IpeBMBErSd4jfgnVfk8jKJ3
X-Proofpoint-GUID: csUom0kO7IpeBMBErSd4jfgnVfk8jKJ3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_01:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104220048
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> Define __hidden helper macro in bpf_helpers.h, which is a short-hand for
> __attribute__((visibility("hidden"))). Add libbpf support to mark BPF
> subprograms marked with __hidden as static in BTF information to enforce BPF
> verifier's static function validation algorithm, which takes more information
> (caller's context) into account during a subprogram validation.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>   tools/lib/bpf/bpf_helpers.h     |  8 ++++++
>   tools/lib/bpf/btf.c             |  5 ----
>   tools/lib/bpf/libbpf.c          | 45 ++++++++++++++++++++++++++++++++-
>   tools/lib/bpf/libbpf_internal.h |  6 +++++
>   4 files changed, 58 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 75c7581b304c..9720dc0b4605 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -47,6 +47,14 @@
>   #define __weak __attribute__((weak))
>   #endif
>   
> +/*
> + * Use __hidden attribute to mark a non-static BPF subprogram effectively
> + * static for BPF verifier's verification algorithm purposes, allowing more
> + * extensive and permissive BPF verification process, taking into account
> + * subprogram's caller context.
> + */
> +#define __hidden __attribute__((visibility("hidden")))

To prevent potential external __hidden macro definition conflict, how
about

#ifdef __hidden
#undef __hidden
#define __hidden __attribute__((visibility("hidden")))
#endif

> +
>   /* When utilizing vmlinux.h with BPF CO-RE, user BPF programs can't include
>    * any system-level headers (such as stddef.h, linux/version.h, etc), and
>    * commonly-used macros like NULL and KERNEL_VERSION aren't available through
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index d30e67e7e1e5..d57e13a13798 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -1605,11 +1605,6 @@ static void *btf_add_type_mem(struct btf *btf, size_t add_sz)
>   			      btf->hdr->type_len, UINT_MAX, add_sz);
>   }
>   
> -static __u32 btf_type_info(int kind, int vlen, int kflag)
> -{
> -	return (kflag << 31) | (kind << 24) | vlen;
> -}
> -
>   static void btf_type_inc_vlen(struct btf_type *t)
>   {
>   	t->info = btf_type_info(btf_kind(t), btf_vlen(t) + 1, btf_kflag(t));
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 9cc2d45b0080..ce5558d0a61b 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -71,6 +71,7 @@
>   static struct bpf_map *bpf_object__add_map(struct bpf_object *obj);
>   static const struct btf_type *
>   skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id);
> +static bool prog_is_subprog(const struct bpf_object *obj, const struct bpf_program *prog);
>   
>   static int __base_pr(enum libbpf_print_level level, const char *format,
>   		     va_list args)
> @@ -274,6 +275,7 @@ struct bpf_program {
>   	bpf_program_clear_priv_t clear_priv;
>   
>   	bool load;
> +	bool mark_btf_static;
>   	enum bpf_prog_type type;
>   	enum bpf_attach_type expected_attach_type;
>   	int prog_ifindex;
> @@ -698,6 +700,15 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
>   		if (err)
>   			return err;
>   
> +		/* if function is a global/weak symbol, but has hidden
> +		 * visibility (or any non-default one), mark its BTF FUNC as
> +		 * static to enable more permissive BPF verification mode with
> +		 * more outside context available to BPF verifier
> +		 */
> +		if (GELF_ST_BIND(sym.st_info) != STB_LOCAL
> +		    && GELF_ST_VISIBILITY(sym.st_other) != STV_DEFAULT)

Maybe we should check GELF_ST_VISIBILITY(sym.st_other) == STV_HIDDEN 
instead?

> +			prog->mark_btf_static = true;
> +
>   		nr_progs++;
>   		obj->nr_programs = nr_progs;
>   
> @@ -2618,7 +2629,7 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
>   {
>   	struct btf *kern_btf = obj->btf;
>   	bool btf_mandatory, sanitize;
> -	int err = 0;
> +	int i, err = 0;
>   
>   	if (!obj->btf)
>   		return 0;
> @@ -2632,6 +2643,38 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
>   		return 0;
>   	}
>   
> +	/* Even though some subprogs are global/weak, user might prefer more
> +	 * permissive BPF verification process that BPF verifier performs for
> +	 * static functions, taking into account more context from the caller
> +	 * functions. In such case, they need to mark such subprogs with
> +	 * __attribute__((visibility("hidden"))) and libbpf will adjust
> +	 * corresponding FUNC BTF type to be marked as static and trigger more
> +	 * involved BPF verification process.
> +	 */
> +	for (i = 0; i < obj->nr_programs; i++) {
> +		struct bpf_program *prog = &obj->programs[i];
> +		struct btf_type *t;
> +		const char *name;
> +		int j, n;
> +
> +		if (!prog->mark_btf_static || !prog_is_subprog(obj, prog))
> +			continue;
> +
> +		n = btf__get_nr_types(obj->btf);
> +		for (j = 1; j <= n; j++) {
> +			t = btf_type_by_id(obj->btf, j);
> +			if (!btf_is_func(t) || btf_func_linkage(t) != BTF_FUNC_GLOBAL)
> +				continue;
> +
> +			name = btf__str_by_offset(obj->btf, t->name_off);
> +			if (strcmp(name, prog->name) != 0)
> +				continue;
> +
> +			t->info = btf_type_info(BTF_KIND_FUNC, BTF_FUNC_STATIC, 0);
> +			break;
> +		}
> +	}
> +
>   	sanitize = btf_needs_sanitization(obj);
[...]
