Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C356224C467
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 19:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbgHTRV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 13:21:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4892 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727917AbgHTRVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 13:21:04 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07KHILrm010851;
        Thu, 20 Aug 2020 10:20:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5WxRxUZnWNhbfX4EfmCF4q0zsNsJkuC7JzpteQdmMHk=;
 b=Iz7u6d/QJK/a9qWMivetiHIJ/ui/wQjkhElxOU3zAmC6psPtSxxEDYnaEkH98xTdmVN7
 gdUepbAcsE00tsHr5y3O7BfDpcKM/c8UGO0rdlgNw/ZgpeZ5CY5pVBXfYB9mtUqNditq
 ugpuIHQkha+et28mgTo1/I9RlsZgv1Z9DCY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3304jjfdvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 10:20:16 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 10:20:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgAvlwUO0hs8AJub4b3On2Zly5NhbLsN/eiRwJFN+Es+mBKNDhbUTc362Ow0bb1CS9kdvM40f56Vi+EQcyUzLGU39Zk54lu02PaXEexHlsWjDgYVKUWjEoztlM5IWbuHic/Jxu32bz3FwfiNuhFBebKig3+cgiC44QpWRyCYDDj7MJTC8iCJ9DsnG29yU4wkccyPts2tU6PB//SfJK8b2/8wpRggMwuUu+UJdBznKY/pUhgFuIMARDwYRQ1Ljh6nX17tmMiEQJf4B09lw/zYdOSq9zJc1NTRs9bR+XuEJ1UoCH4oEy4ltC/ipahpy/IZ0y0DV+vWkq3xY3TSlxbBmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WxRxUZnWNhbfX4EfmCF4q0zsNsJkuC7JzpteQdmMHk=;
 b=Ei6fFLBNaWOapJa2RE8uN+boun61E37fa/QvTrce/yoXBdPyHCGiBcyvkgIecZ30VoTXDkEokYX99lXyxGm2lduGN8wOmUXXjVonnz0ZkwPqbggOiYPQV6nYdN8iSSytZ8tjwO8dKMuxdSIcuS0wzYCOoNc1hPrO1JWNgGV0cqW/QEhLaPGlBwvUbvF31KTIeaMp41WLwSdiAqDiBmsYsyyZxXYe2/aPeUWN4oaeDKCQcBnbvb95IemkmJ2ULwtPGPJwfxAwLCG20emt6M24y84ohXiuYKlZqDvGoD+KMAm3laLuYUC1z+ovIdRWVClJ68f14t1mWOpMpU3PQW3OvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WxRxUZnWNhbfX4EfmCF4q0zsNsJkuC7JzpteQdmMHk=;
 b=dQnqXaXYlQHfKjk5DeItOVBc9wLNe6bRIia+3F6bRJmVoFVtoopT1yuBuv8jFJq1b9N+tlEqkPtI38BtX7p79mmEa6z9cf5fc3nzfERFJn0XEoQ8VSFQWBXodzjbtUcvuWeTxkOra95hJdQTdnrRnY6aCvRolebOK2jQ5KekbeM=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2407.namprd15.prod.outlook.com (2603:10b6:a02:8d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Thu, 20 Aug
 2020 17:20:13 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 17:20:13 +0000
Subject: Re: [PATCH bpf-next v1 3/8] bpf: Introduce help function to validate
 ksym's type.
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
 <20200819224030.1615203-4-haoluo@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d50a1530-9a9f-45b2-5aba-05fe4b895fbc@fb.com>
Date:   Thu, 20 Aug 2020 10:20:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819224030.1615203-4-haoluo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0061.namprd02.prod.outlook.com
 (2603:10b6:207:3d::38) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BL0PR02CA0061.namprd02.prod.outlook.com (2603:10b6:207:3d::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Thu, 20 Aug 2020 17:20:10 +0000
X-Originating-IP: [2620:10d:c091:480::1:7ec1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f480da57-89ab-4ae3-8a04-08d8452d4c75
X-MS-TrafficTypeDiagnostic: BYAPR15MB2407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2407DBE8757EAF8A5D1A745BD35A0@BYAPR15MB2407.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D575INhQv2JNU+vnk4p0sGFLZWR5AOu7lkpPHIuEjaQNi8SQgaREiyzFfJqlmOOnKK+OF0NH7chYeStJmQ/vAFNfbnMJilHYsjFPCYIWNozVJtcHfEGEENxBVKOxY5naAtyIyVwGUfXobYLjsQm7vBlPDwnsRMplkG4CnO0EAvzN0+G6QLlYmZ5QKaMFfjMGnGLkcBEwbT8VzEbEIZ4nRtmTExAW5v7x5/pSNb0oOnZGHY4XsqjvbZd6aee14D2+yUooayE5QAXVOXHd4uva9+y4ZsY9q4LkXG+MqeLYmERUv6bSq3Qpr/ED2SzIvNFLDz5f2FKYhlu0dPuaB1IByo5JVTrAwzma23UIhrWeJhwqOg//EoGAYRzPRib/CoaU/rfP6ip+A73PjAlkbM0vAs4RMUYBSVgtxcDdifmUPnY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(376002)(346002)(136003)(956004)(8676002)(2616005)(316002)(5660300002)(66476007)(54906003)(66556008)(53546011)(36756003)(16576012)(4326008)(186003)(8936002)(86362001)(52116002)(478600001)(31696002)(83380400001)(110011004)(31686004)(6486002)(66946007)(7416002)(2906002)(6666004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: v8yu9X/yQVMdZkJloyx4tzxbxT5KOoHEEKZSPPxV3h2wfWQ23icEX77QizTpzrIMKBSDdtdNkMJzUzHIBPga07/DLlN4UotjOPH9e4VKOqvVYczecvO0rTvp8naVM7plHZMJMlZmr4ZxDnEF5vBOZfr77/9evpMjRmrISnVipt/iGP6L1DeaVzY77vglkgXm1n377kgi720UyKnyQEf6ynToyYcRTBp22eKGA71CDQXAK3j+E7zQhtmWXI/y6gkHLYaUaPTBe1OBaeX5CjY86E4bvHPRHAbsZ5jkcq35hCpH5J+ISxgD4WlkYTKrNCz3w3sbes/4hE3V1tPegC919akLfPlXh6axQqeCTRBsDAlKiUzgR0VNnfot8NRK/EaXrdXnyxcrVu/ED3hgWiI05g0c1909bJAjcqBgZO18ZVGBm3Oy/2+559cNdiQF6CVrRg8K2A7latBOJFHy6gl+fd5d53Ejbab/6aNAyaHrarvVlL2uxC5lmPqnX029HVlhRG+bJmnZeyuqIfQ2YwnnzfmGF6qb4zT/sec9E/dD5w/694Q/n7qK7r8OQ+L5jUMiZYreQ3ArT8QYWf9BRDxy39+1U/cv39xFJiflvPH9/8nJspcS7sit0quif/1o8gPhD+vW4HbHWjbSgkodU7TViovOzzXzDujSDtCP43Ty5CFZ03N30ym5LIPYvjElNHv5
X-MS-Exchange-CrossTenant-Network-Message-Id: f480da57-89ab-4ae3-8a04-08d8452d4c75
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 17:20:13.3460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J8+c37FEtKW+Hs6faPeRv1JoGsLEWSmjILGLScvKWRJqc8OnxZiOsqLFU2cNhZ9B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2407
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=2
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=814 phishscore=0 mlxscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200140
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 3:40 PM, Hao Luo wrote:
> For a ksym to be safely dereferenced and accessed, its type defined in
> bpf program should basically match its type defined in kernel. Implement
> a help function for a quick matching, which is used by libbpf when
> resolving the kernel btf_id of a ksym.
> 
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>   tools/lib/bpf/btf.c | 171 ++++++++++++++++++++++++++++++++++++++++++++
>   tools/lib/bpf/btf.h |   2 +
>   2 files changed, 173 insertions(+)
> 
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index a3d259e614b0..2ff31f244d7a 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -1005,6 +1005,177 @@ int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
>   	return 0;
>   }
>   
> +/*
> + * Basic type check for ksym support. Only checks type kind and resolved size.
> + */
> +static inline
> +bool btf_ksym_equal_type(const struct btf *ba, __u32 type_a,
> +			 const struct btf *bb, __u32 type_b)

"ba" and "bb" is not descriptive. Maybe "btf_a" or "btf_b"?
or even "btf1" or "btf2" since the number does not carry
extra meaning compared to letters.

The same for below, may be t1, t2?

> +{
> +	const struct btf_type *ta, *tb;
> +
> +	ta = btf__type_by_id(ba, type_a);
> +	tb = btf__type_by_id(bb, type_b);
> +
> +	/* compare type kind */
> +	if (btf_kind(ta) != btf_kind(tb))
> +		return false;
> +
> +	/* compare resolved type size */
> +	return btf__resolve_size(ba, type_a) == btf__resolve_size(bb, type_b);
> +}
> +
> +/*
> + * Match a ksym's type defined in bpf programs against its type encoded in
> + * kernel btf.
> + */
> +bool btf_ksym_type_match(const struct btf *ba, __u32 id_a,
> +			 const struct btf *bb, __u32 id_b)
> +{
> +	const struct btf_type *ta = btf__type_by_id(ba, id_a);
> +	const struct btf_type *tb = btf__type_by_id(bb, id_b);
> +	int i;
> +
> +	/* compare type kind */
> +	if (btf_kind(ta) != btf_kind(tb)) {
> +		pr_warn("%s:mismatched type kind (%d v.s. %d).\n",
> +			__func__, btf_kind(ta), btf_kind(tb));
> +		return false;
> +	}
> +
> +	switch (btf_kind(ta)) {
> +	case BTF_KIND_INT: { /* compare size and encoding */
> +		__u32 ea, eb;
> +
> +		if (ta->size != tb->size) {
> +			pr_warn("%s:INT size mismatch, (%u v.s. %u)\n",
> +				__func__, ta->size, tb->size);
> +			return false;
> +		}
> +		ea = *(__u32 *)(ta + 1);
> +		eb = *(__u32 *)(tb + 1);
> +		if (ea != eb) {
> +			pr_warn("%s:INT encoding mismatch (%u v.s. %u)\n",
> +				__func__, ea, eb);
> +			return false;
> +		}
> +		break;
> +	}
> +	case BTF_KIND_ARRAY: { /* compare type and number of elements */
> +		const struct btf_array *ea, *eb;
> +
> +		ea = btf_array(ta);
> +		eb = btf_array(tb);
> +		if (!btf_ksym_equal_type(ba, ea->type, bb, eb->type)) {
> +			pr_warn("%s:ARRAY elem type mismatch.\n", __func__);
> +			return false;
> +		}
> +		if (ea->nelems != eb->nelems) {
> +			pr_warn("%s:ARRAY nelems mismatch (%d v.s. %d)\n",
> +				__func__, ea->nelems, eb->nelems);
> +			return false;
> +		}
> +		break;
> +	}
> +	case BTF_KIND_STRUCT:
> +	case BTF_KIND_UNION: { /* compare size, vlen and member offset, name */
> +		const struct btf_member *ma, *mb;
> +
> +		if (ta->size != tb->size) {
> +			pr_warn("%s:STRUCT size mismatch, (%u v.s. %u)\n",
> +				__func__, ta->size, tb->size);
> +			return false;
> +		}
> +		if (btf_vlen(ta) != btf_vlen(tb)) {
> +			pr_warn("%s:STRUCT vlen mismatch, (%u v.s. %u)\n",
> +				__func__, btf_vlen(ta), btf_vlen(tb));
> +			return false;
> +		}
> +
> +		ma = btf_members(ta);
> +		mb = btf_members(tb);
> +		for (i = 0; i < btf_vlen(ta); i++, ma++, mb++) {
> +			const char *na, *nb;
> +
> +			if (ma->offset != mb->offset) {
> +				pr_warn("%s:STRUCT field offset mismatch, (%u v.s. %u)\n",
> +					__func__, ma->offset, mb->offset);
> +				return false;
> +			}
> +			na = btf__name_by_offset(ba, ma->name_off);
> +			nb = btf__name_by_offset(bb, mb->name_off);
> +			if (strcmp(na, nb)) {
> +				pr_warn("%s:STRUCT field name mismatch, (%s v.s. %s)\n",
> +					__func__, na, nb);
> +				return false;
> +			}
> +		}

I am wondering whether this is too strict and how this can co-work with 
CO-RE. Forcing users to write almost identical structure definition to 
the underlying kernel will not be user friendly and may not work cross
kernel versions even if the field user cares have not changed.

Maybe we can relax the constraint here. You can look at existing
libbpf CO-RE code.

> +		break;
> +	}
> +	case BTF_KIND_ENUM: { /* compare vlen and member value, name */
> +		const struct btf_enum *ma, *mb;
> +
> +		if (btf_vlen(ta) != btf_vlen(tb)) {
> +			pr_warn("%s:ENUM vlen mismatch, (%u v.s. %u)\n",
> +				__func__, btf_vlen(ta), btf_vlen(tb));
> +			return false;
> +		}
> +
> +		ma = btf_enum(ta);
> +		mb = btf_enum(tb);
> +		for (i = 0; i < btf_vlen(ta); i++, ma++, mb++) {
> +			if (ma->val != mb->val) {
> +				pr_warn("%s:ENUM val mismatch, (%u v.s. %u)\n",
> +					__func__, ma->val, mb->val);
> +				return false;
> +			}
> +		}
> +		break;
> +	}
> +	case BTF_KIND_PTR: { /* naive compare of ref type for PTR */
> +		if (!btf_ksym_equal_type(ba, ta->type, bb, tb->type)) {
> +			pr_warn("%s:PTR ref type mismatch.\n", __func__);
> +			return false;
> +		}
> +		break;
> +	}
> +	case BTF_KIND_FUNC_PROTO: { /* naive compare of vlen and param types */
> +		const struct btf_param *pa, *pb;
> +
> +		if (btf_vlen(ta) != btf_vlen(tb)) {
> +			pr_warn("%s:FUNC_PROTO vlen mismatch, (%u v.s. %u)\n",
> +				__func__, btf_vlen(ta), btf_vlen(tb));
> +			return false;
> +		}
> +
> +		pa = btf_params(ta);
> +		pb = btf_params(tb);
> +		for (i = 0; i < btf_vlen(ta); i++, pa++, pb++) {
> +			if (!btf_ksym_equal_type(ba, pa->type, bb, pb->type)) {
> +				pr_warn("%s:FUNC_PROTO params type mismatch.\n",
> +					__func__);
> +				return false;
> +			}
> +		}
> +		break;
> +	}
> +	case BTF_KIND_FUNC:
> +	case BTF_KIND_CONST:
> +	case BTF_KIND_VOLATILE:
> +	case BTF_KIND_RESTRICT:
> +	case BTF_KIND_TYPEDEF:
> +	case BTF_KIND_VAR:
> +	case BTF_KIND_DATASEC:
> +		pr_warn("unexpected type for matching ksym types.\n");
> +		return false;
> +	default:
> +		pr_warn("unsupported btf types.\n");
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>   struct btf_ext_sec_setup_param {
>   	__u32 off;
>   	__u32 len;
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index 91f0ad0e0325..5ef220e52485 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -52,6 +52,8 @@ LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
>   				    __u32 expected_key_size,
>   				    __u32 expected_value_size,
>   				    __u32 *key_type_id, __u32 *value_type_id);
> +LIBBPF_API bool btf_ksym_type_match(const struct btf *ba, __u32 id_a,
> +				    const struct btf *bb, __u32 id_b);
>   
>   LIBBPF_API struct btf_ext *btf_ext__new(__u8 *data, __u32 size);
>   LIBBPF_API void btf_ext__free(struct btf_ext *btf_ext);

The new API function should be added to libbpf.map.
