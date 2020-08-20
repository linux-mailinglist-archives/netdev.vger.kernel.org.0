Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7255A24C382
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbgHTQo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:44:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64614 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729295AbgHTQoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 12:44:23 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KGexF2019576;
        Thu, 20 Aug 2020 09:43:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=oCgkEzR61Ww8D3uxegvSqWerdwVf6X81wRDVXfWa7U8=;
 b=MKFyf4EQGnTCWHYhwauuqvoRCcvPRNXpAXPTnG6KqAGMLXp1/E1W/ZoJhPzuUux/Fe24
 UDVnXI4CIYv+LgVkA+5ZoctHRqDKmeHrOve4AiFay044xlo5azwKMVCqPBGg90dkcZCM
 Ng7NLbXwxxSETGUNe8d1LHTyBIQga8qYJOI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p3q6kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 09:43:33 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 09:43:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpD6ZHr2qbCIOm2F992qFwoHbHMdebwZWhMy/kqMsYMO7l/hEKXbec5+/vE9tCZkaTVNJxS2olbES3xNzYz/V7Gmquu2zZTdvhoFmSBGflrn6k70+nmpVWd+MxGWPEZZRCjR08U+3rQHhxk2mjKmZdfgwvM0WkohqhtP5VdnO+UYkvo8SzcmZ05lgKspzvU25a4p92e+RiyA36LKTkf6y7czd4Bn1MyGfMbxowz7l+K9ESi/f0hoJkVk7xc9bH8+J3vj8FSdlsEygxXjAk3CfhpQjNvdqK1YpDzJpOdzD8PxBfR+un3PNAXy//2XrXSZxbDrlcBTrEPagfS93j1keQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCgkEzR61Ww8D3uxegvSqWerdwVf6X81wRDVXfWa7U8=;
 b=YNsArXOI0ros6mRsW8DwCud9p+55W+EAjIw5qVrYiwCAswSzf/Ys4iRdRo8lubaavMZlw8SIHzcu5PPufHsc4k3BDEcA5uvP8bhyIj6L7QLWZkV8bIViLDvrcMKQesary/pDP8KLiHiSahADSUO/hKnS23nXcLGW+p7SmEa2INAsAm0incykUUxfha5erjp+viHGeq2IbOc+Okok090APB+ySMO19KTuINBVfCUvfvLAkn4qUpiOu3ecu938oK28/1RWw8I5a5y83NhGJ+YZ6kQzZJ/c017U/Ox+tByA3CoXDoNzObkGi2WMzr4z2HPtg38Qw/YbooVjMngHBrsGqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCgkEzR61Ww8D3uxegvSqWerdwVf6X81wRDVXfWa7U8=;
 b=IW2pc/5rVaAwTkYlXP0wKU02t76TV7YWNv4Zsai2tyoX15kc11QLBbCFvgFNHl3RAY1YWEkJlqo+pOQSInqjOGz2F3Z7XxBTKSZ8hSM3gZxw/u+BLVh61p2aiAvSBABxG7lSIaINzKu724oRkk0N1UWZ6GmYWdDFjVXoNm0vM8w=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2821.namprd15.prod.outlook.com (2603:10b6:a03:15d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Thu, 20 Aug
 2020 16:43:31 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 16:43:31 +0000
Subject: Re: [PATCH bpf-next v1 1/8] bpf: Introduce pseudo_btf_id
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
 <20200819224030.1615203-2-haoluo@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3c14ea8e-fd86-51bf-16b4-498cfc30ca48@fb.com>
Date:   Thu, 20 Aug 2020 09:43:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819224030.1615203-2-haoluo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0032.prod.exchangelabs.com (2603:10b6:208:10c::45)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR01CA0032.prod.exchangelabs.com (2603:10b6:208:10c::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Thu, 20 Aug 2020 16:43:27 +0000
X-Originating-IP: [2620:10d:c091:480::1:7ec1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 374afd0e-b636-4f8f-7269-08d845282bc2
X-MS-TrafficTypeDiagnostic: BYAPR15MB2821:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB282156D0094981E96D7BDCFDD35A0@BYAPR15MB2821.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 06UILhyRCqGwy8tWKNYBXsZ6SHCdAtcK5gRu9jrXjOneiNS7Jow/XA7O52QcfR2COK4UJj8fuEGojmL9W30Bu9Kt4xiotZD1TPT5R5ko1/dde8HLa3qqYsER4y259GBw/ISY1yQo6kmCVl13KnTI5kYcJFFd6shj+Ggf0yFN0P/y5i4iLxBOYhs8LJpG8mbCAIpdQHgqKA5wVa1YIZwtwCSeU3pwupglOPvvfGNu4DIxfWhZW+Lvg1N719a7XRvCbilObiwl8dwoMvsAuGImNitpYXzdmRgOany4cINQVA1INZrD9Nlh6Hw7P1rrVfrOqzDNNPsDgFPxg6/zihV2VLPNv08sYQcfMxpDbYKMU55cxRhOrecjQGXQwhmlks/M/jMoLHAey7ElH108H1b3Fow7I8VxedEtymprHW3uiVM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(366004)(136003)(396003)(110011004)(6666004)(31696002)(316002)(478600001)(54906003)(53546011)(52116002)(86362001)(16576012)(31686004)(186003)(2616005)(7416002)(956004)(36756003)(2906002)(8936002)(83380400001)(66946007)(4326008)(6486002)(66476007)(66556008)(8676002)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: BQ4rs3/LdJmEmx7pC0VBGi1Nz52ZfXYW8qHDNRz0k3mqvaxmkqQy4jR62BV4D6Zs076y2vejuD2yQE9ww9uzFzheM/Z08woMNN7C2qS8TggNzja3wpklCdwNfjqacbCO54OE7MXZiFbBK6BWrXy6+HGz69oEEwFl8QkVle0QnhDKI1pmAPTRLx2pPm4UPqUiOO0YYRtZ6oFxNxp4E6sGoso7C1Ik8QoWlK9v3eG5q6VkHUnc/48nQbQFnxyW2yf04AWN7GeUQOb4EFMJvV0NRvfRcXYWLiuuPjfTQPsZ8+0fbSoBUVgUS3N3fka6aoG2ORncJn+nXMyjV4ISeuOA+p9/6jw+JfDUDUcHI+dfrtBknA0boPzt06fhr1YRP2JoPQkEPvIYi2Z1feTTdAG3AHLS2E739qH0XcWJVhPmIHGtlDMKjV9k4ciDzbjiCRdBqFk5O0Zg/cuUY71KirgyU1FF6Q8jLD7B/bwLEMHVEhVKbZqIW6iZhH8IeIYzBDdR1IfcD40noujG6ftlzyIUcfX4+///7qKM2J9M4qCqtUgx5HvYcztNOJejjNySib576ZlFiioSgGBI5WQ4ybuTrijgSo/ShWEb1ysKEVPh430NQmCW9sjhWnXw004TfVB0CnrhKci+3zdItS2QSUhaMLzO8SUmZa0q0mHp9OqqkP0=
X-MS-Exchange-CrossTenant-Network-Message-Id: 374afd0e-b636-4f8f-7269-08d845282bc2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 16:43:31.1655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 32dSUcKqeTSsXvT+8i0uz7tJAy58IeV5JD+ZMXgzINRWn8ESWjEDjxqGGocI9DmH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2821
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 mlxscore=0 clxscore=1015 suspectscore=0 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 3:40 PM, Hao Luo wrote:
> Pseudo_btf_id is a type of ld_imm insn that associates a btf_id to a
> ksym so that further dereferences on the ksym can use the BTF info
> to validate accesses. Internally, when seeing a pseudo_btf_id ld insn,
> the verifier reads the btf_id stored in the insn[0]'s imm field and
> marks the dst_reg as PTR_TO_BTF_ID. The btf_id points to a VAR_KIND,
> which is encoded in btf_vminux by pahole. If the VAR is not of a struct
> type, the dst reg will be marked as PTR_TO_MEM instead of PTR_TO_BTF_ID
> and the mem_size is resolved to the size of the VAR's type.
> 
>  From the VAR btf_id, the verifier can also read the address of the
> ksym's corresponding kernel var from kallsyms and use that to fill
> dst_reg.
> 
> Therefore, the proper functionality of pseudo_btf_id depends on (1)
> kallsyms and (2) the encoding of kernel global VARs in pahole, which
> should be available since pahole v1.18.
> 
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>   include/linux/btf.h      | 15 +++++++++
>   include/uapi/linux/bpf.h | 38 ++++++++++++++++------
>   kernel/bpf/btf.c         | 15 ---------
>   kernel/bpf/verifier.c    | 68 ++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 112 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 8b81fbb4497c..cee4089e83c0 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -107,6 +107,21 @@ static inline bool btf_type_is_func_proto(const struct btf_type *t)
>   	return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC_PROTO;
>   }
>   
> +static inline bool btf_type_is_var(const struct btf_type *t)
> +{
> +	return BTF_INFO_KIND(t->info) == BTF_KIND_VAR;
> +}
> +
> +/* union is only a special case of struct:
> + * all its offsetof(member) == 0
> + */
> +static inline bool btf_type_is_struct(const struct btf_type *t)
> +{
> +	u8 kind = BTF_INFO_KIND(t->info);
> +
> +	return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
> +}
> +
>   static inline u16 btf_type_vlen(const struct btf_type *t)
>   {
>   	return BTF_INFO_VLEN(t->info);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 0480f893facd..468376f2910b 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -346,18 +346,38 @@ enum bpf_link_type {
>   #define BPF_F_TEST_STATE_FREQ	(1U << 3)
>   
>   /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
> - * two extensions:
> - *
> - * insn[0].src_reg:  BPF_PSEUDO_MAP_FD   BPF_PSEUDO_MAP_VALUE
> - * insn[0].imm:      map fd              map fd
> - * insn[1].imm:      0                   offset into value
> - * insn[0].off:      0                   0
> - * insn[1].off:      0                   0
> - * ldimm64 rewrite:  address of map      address of map[0]+offset
> - * verifier type:    CONST_PTR_TO_MAP    PTR_TO_MAP_VALUE
> + * the following extensions:
> + *
> + * insn[0].src_reg:  BPF_PSEUDO_MAP_FD
> + * insn[0].imm:      map fd
> + * insn[1].imm:      0
> + * insn[0].off:      0
> + * insn[1].off:      0
> + * ldimm64 rewrite:  address of map
> + * verifier type:    CONST_PTR_TO_MAP
>    */
>   #define BPF_PSEUDO_MAP_FD	1
> +/*
> + * insn[0].src_reg:  BPF_PSEUDO_MAP_VALUE
> + * insn[0].imm:      map fd
> + * insn[1].imm:      offset into value
> + * insn[0].off:      0
> + * insn[1].off:      0
> + * ldimm64 rewrite:  address of map[0]+offset
> + * verifier type:    PTR_TO_MAP_VALUE
> + */
>   #define BPF_PSEUDO_MAP_VALUE	2
> +/*
> + * insn[0].src_reg:  BPF_PSEUDO_BTF_ID
> + * insn[0].imm:      kernel btd id of VAR
> + * insn[1].imm:      0
> + * insn[0].off:      0
> + * insn[1].off:      0
> + * ldimm64 rewrite:  address of the kernel variable
> + * verifier type:    PTR_TO_BTF_ID or PTR_TO_MEM, depending on whether the var
> + *                   is struct/union.
> + */
> +#define BPF_PSEUDO_BTF_ID	3
>   
>   /* when bpf_call->src_reg == BPF_PSEUDO_CALL, bpf_call->imm == pc-relative
>    * offset to another bpf function
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 91afdd4c82e3..b6d8f653afe2 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -353,16 +353,6 @@ static bool btf_type_nosize_or_null(const struct btf_type *t)
>   	return !t || btf_type_nosize(t);
>   }
>   
> -/* union is only a special case of struct:
> - * all its offsetof(member) == 0
> - */
> -static bool btf_type_is_struct(const struct btf_type *t)
> -{
> -	u8 kind = BTF_INFO_KIND(t->info);
> -
> -	return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
> -}
> -
>   static bool __btf_type_is_struct(const struct btf_type *t)
>   {
>   	return BTF_INFO_KIND(t->info) == BTF_KIND_STRUCT;
> @@ -373,11 +363,6 @@ static bool btf_type_is_array(const struct btf_type *t)
>   	return BTF_INFO_KIND(t->info) == BTF_KIND_ARRAY;
>   }
>   
> -static bool btf_type_is_var(const struct btf_type *t)
> -{
> -	return BTF_INFO_KIND(t->info) == BTF_KIND_VAR;
> -}
> -
>   static bool btf_type_is_datasec(const struct btf_type *t)
>   {
>   	return BTF_INFO_KIND(t->info) == BTF_KIND_DATASEC;
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index ef938f17b944..47badde71f83 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7205,6 +7205,68 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
>   	return 0;
>   }
>   
> +/* verify ld_imm64 insn of type PSEUDO_BTF_ID is valid */
> +static inline int check_pseudo_btf_id(struct bpf_verifier_env *env,
> +				      struct bpf_insn *insn)
> +{
> +	struct bpf_reg_state *regs = cur_regs(env);
> +	u32 type, id = insn->imm;
> +	u64 addr;
> +	const char *sym_name;
> +	const struct btf_type *t = btf_type_by_id(btf_vmlinux, id);

Since this is new code, please try to conform to reverse christmas tree 
coding style. For the last one, the assignment no need to be in
declaration, you can put "t = ..." right before the first use of "t".

same for other places.

> +
> +	if (!t) {
> +		verbose(env, "%s: invalid btf_id %d\n", __func__, id);
> +		return -ENOENT;
> +	}
> +
> +	if (insn[1].imm != 0) {
> +		verbose(env, "%s: BPF_PSEUDO_BTF_ID uses reserved fields\n",
> +			__func__);
> +		return -EINVAL;
> +	}
> +
> +	if (!btf_type_is_var(t)) {
> +		verbose(env, "%s: btf_id %d isn't KIND_VAR\n", __func__, id);
> +		return -EINVAL;
> +	}
> +
> +	sym_name = btf_name_by_offset(btf_vmlinux, t->name_off);
> +	addr = kallsyms_lookup_name(sym_name);
> +	if (!addr) {
> +		verbose(env, "%s: failed to find the address of symbol '%s'.\n",
> +			__func__, sym_name);
> +		return -ENOENT;
> +	}
> +
> +	insn[0].imm = (u32)addr;
> +	insn[1].imm = addr >> 32;
> +	mark_reg_known_zero(env, regs, insn->dst_reg);
> +
> +	type = t->type;
> +	t = btf_type_skip_modifiers(btf_vmlinux, type, NULL);
> +	if (!btf_type_is_struct(t)) {
> +		u32 tsize;
> +		const struct btf_type *ret;
> +		const char *tname; > +
> +		/* resolve the type size of ksym. */
> +		ret = btf_resolve_size(btf_vmlinux, t, &tsize, NULL, NULL);
> +		if (IS_ERR(ret)) {
> +			tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> +			verbose(env, "unable to resolve the size of type '%s': %ld\n",
> +				tname, PTR_ERR(ret));
> +			return -EINVAL;
> +		}
> +		regs[insn->dst_reg].type = PTR_TO_MEM;
> +		regs[insn->dst_reg].mem_size = tsize;
> +	} else {
> +		regs[insn->dst_reg].type = PTR_TO_BTF_ID;
> +		regs[insn->dst_reg].btf_id = type;
> +	}
> +	return 0;
> +}
> +
>   /* verify BPF_LD_IMM64 instruction */
[...]
