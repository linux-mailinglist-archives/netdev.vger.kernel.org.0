Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F93E2F0BBE
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 05:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbhAKEQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 23:16:15 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26410 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726029AbhAKEQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 23:16:15 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10B4E2Oh017475;
        Sun, 10 Jan 2021 20:15:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=tY+sOmwVCZmKO4d6kzVn3xrvqE6Y2mEPAc7scWbIghk=;
 b=jtT0PoUMakFiz9N7s8CtZN1pWWxgzZ0QtbpGWjvl/Uv7YVvkTr1PezBgWp2O+mAAmpcS
 TqRWzsRDWGrClpxAthGH3l18is8YdFoudzUaPSjshtmvzS8bVa+6gqFLI/HdqO5saYxI
 MCyxEbZwT7yiWpyzINH1yR/Y8gomZYFCTgI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35yweb2ruy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 10 Jan 2021 20:15:18 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 10 Jan 2021 20:15:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVfFf+mZ4KbYA7YuwbHL0po9JATfcqFfkSVjVD8a+zilNLoHrc+onvsgwZCwKXI8yjO9+M1zdga4Xu4QbXjevrjUPf3lnoP+G0ZhKPt1ZvHKY+wpKxAKaVx9nK95yA3Y/aSAWZfbh/P20RzoTSYa5IDCTjFhFaDk+bk+8XFoJ0SwWw+iaAwweuEa5TzhLM0Z2HFCTOg1heBlbfBIG1jvKZcPzjH8orIDXtQwvijcbX3zeMD6jJ7XRjWa3H23jCSt71WRqmAdqKkITJYpFd9FQYLTQRMXDBB2sCEmhu9RCDHzHpwvOV36wbxxfNoK//N0mp0HN7HeFhWzp53TIXRawQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tY+sOmwVCZmKO4d6kzVn3xrvqE6Y2mEPAc7scWbIghk=;
 b=AnYi858jrantnjsX+D2ZyAtA/YmMnDsO3RQbmE5j+2Wb6UDIQtiSjRGptuAuvuecmfSUbc+sUek7QyN9j2NXlP2uEsip/MUDDKiUwGrjGxpRhQkO2iq9wHQL/OPITu9CfSjlSFTIl9FBDzqwr5PXLpGA535hqFjG58tTReBB6njPZjT6uULvU/I2mxRZwI4t1IvMKrHxh+TxYjdM7miGozeTXSZ80x5nVsx2ByStfydDq2p3vaQmEqAaKbs5PwVLqSL7FcxGD5IYgDssCNSsEtdfGWDotj+i7f5Bkx8Nbnd9XbVxM2PL5Ov91XxV9bOIqalGEBPAjJV/UpoOK22mrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tY+sOmwVCZmKO4d6kzVn3xrvqE6Y2mEPAc7scWbIghk=;
 b=bR32V8h9Lx/EqI3s48ZgSv6Wk4X4gF+eW4wVMnBUWnbC/q/B/RfKX6Un2vgt/RO7J+y4ZQZglxpUejoa2crf2EgEqxq3N2KUyDHnrmGkeeUQw3yWvNXZ/iSf58XH57R22NEoN/rVvnNnko9ENnTelqOAYgvK+r2RbzpyEvzadMw=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by SJ0PR15MB4236.namprd15.prod.outlook.com (2603:10b6:a03:2cb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 04:15:15 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 04:15:15 +0000
Subject: Re: [PATCH v2 bpf-next 6/7] libbpf: support kernel module ksym
 externs
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>, Hao Luo <haoluo@google.com>
References: <20210108220930.482456-1-andrii@kernel.org>
 <20210108220930.482456-7-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <dc1a06fe-f957-deb8-772c-b4c65042c3b3@fb.com>
Date:   Sun, 10 Jan 2021 20:15:12 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210108220930.482456-7-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:b212]
X-ClientProxiedBy: MW4PR04CA0085.namprd04.prod.outlook.com
 (2603:10b6:303:6b::30) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:b212) by MW4PR04CA0085.namprd04.prod.outlook.com (2603:10b6:303:6b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 04:15:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 905f3178-14bc-4bba-1d1a-08d8b5e77f7d
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4236:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR15MB423665C7BC3993B3280F75C9D3AB0@SJ0PR15MB4236.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wiZKYQuc8KjBvXdcQtL744DhF0vsywcaI1VRSKT78eH95DnRrkFY7jru+XxRWMfsLgx2OH9yEIvYu4UOIIZgM5JIb22Rd8vZAyL+dgoWIIu6lPoUGJKBGo/VgoL8NzN7OJZ0+E24n4ArQJKlARWKleKhB71kkLVXclOLlhfNkts30KV43PXm5fMouInd3sdWxdastbzYDY2t70Bll/tcVrktXCzgvnW2IqIF5tsfZjc75Vn8XdYL1xBIsTQEkj1Jrk963H7PoT4OvFh3RX30DllkGa0gurFw8gme1n2DQQcpq/S8ZzoVnHofi8e3KN2TvP6At2ehd9xFCS0NZ4RK59wLNAaTKoegWRHUP77sJMonka8q1oQUdyTI99bMLwb45rciatI71ClTTjnZuEhPHgqfZf04he7mDdbq0glY1vUxGGXjnab5urTVIvU1LfJgwNnHIeXZMX+VDCfA+Q8tyJcSSf+2QkPTC7kZwPUyyhM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(346002)(136003)(39860400002)(8936002)(36756003)(316002)(52116002)(31696002)(8676002)(2906002)(66556008)(66476007)(5660300002)(53546011)(478600001)(66946007)(31686004)(2616005)(6486002)(186003)(16526019)(83380400001)(4326008)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VGlnV0JXYTJoU01MYWlENTNrSGJWcGxmbUdURDJlVFBlaHBBSURrWnhBZlB6?=
 =?utf-8?B?M09PYzNGeG0rVktsUHp4VGs0MDlGaHRsS2ZqdzdZVmhQdmxyb0hKT05ZVHQw?=
 =?utf-8?B?U0djbTMyRG0wSFQ5ZWZSRXhYZW9qOHNXTGZ6VjdKUjdKSDEzZ3JnbTNVMSt1?=
 =?utf-8?B?UEZPb1RwbDIreEVFckdXVU9YeENOUi9hQ3ZvK0RYWmhzUjRjMFBtVFh4TWEv?=
 =?utf-8?B?MUo4bkRsTGhnRUtEeHNPQVF4OG51TDh4TG5zU2JaaGlkWWRFemN6NXBVQ25r?=
 =?utf-8?B?UndTZFhNRWxJM09GOStPSHJuRnNOR0Q0Nk9Iemt2c1dramlsTDJKN2hSdVF0?=
 =?utf-8?B?dTBtTlZhb1I3WHh3S2lTMll2ZXM1TExua1lORGdSTGZGNXpNZWV0MHpjVDBL?=
 =?utf-8?B?S1dmS0drTGFZNW1IOHF6ZUMxa0hnaEdJbFdKT0NueU5sek9ZSURwTFBlOEo2?=
 =?utf-8?B?UytZaHlQdG9LNjRIWE0zWUJ5S3lEeTRXWXR5dVdZMHFGMnJtN0Z2SHkwUElZ?=
 =?utf-8?B?Q1lhN3hVTm5rOEFSaTFUODQ5RjFlRjBBd1k2OUZvSjBJQUNYWFFPbldvNW8z?=
 =?utf-8?B?TmNKa0NpUFJvbXdhNGFoMWZXSi8wRzhKZ2lCZEU4QVBhaUIvUnpHQzZTWTZh?=
 =?utf-8?B?b0tPc01FRUJFOSs0Ty9OSnNHY3dGd1dGZ2FPQWxrcnQvYXdCNjFzbWtqcW45?=
 =?utf-8?B?LzV5UW1yOGhTcHhSY2JqRkhCMmtvSE9CQmxZemd5Q1VMbjVjNFh6NlZRTEpo?=
 =?utf-8?B?cFNNM0Jkalk0TGJUbXdXNndObVgvS21McDRZWGdmekhxTFIzRks1d2JqOUVv?=
 =?utf-8?B?b3kxdVhUankzbng2VTRHa3poTElhcnlRRW8zd1hhRDIwbjE3MVA4Znl0RHly?=
 =?utf-8?B?U0l3ZFh2alpLTUVDa09vZ0VSYWlOZ3RUeGRsR1B1OXFHM1FwblVhbCthRzV0?=
 =?utf-8?B?a2VOcmQ1dlc0bkJWMGJ5NnprcXZ3Zk1ZeGFIZmxnZmJqeWh0S2thMDNMTDM3?=
 =?utf-8?B?OTdVMmhDcUhpNjNmajJsdEd1M2JwTVRGZkNobkxVUFFRS1ovNlRXenhobitI?=
 =?utf-8?B?U0R5dURBNVllak5PT2ZjdmQ0S2dYaDREZDZYWWxsTldHNExtbHh4WVJGeklq?=
 =?utf-8?B?emV0VmFjSGhJbDFMSHRpMXBXcTd5bllUWVBqckxEWFVWd3h2bElJdGVoQU9V?=
 =?utf-8?B?S3JmVlQwd1JNb3RUNkprVnV6TzVmQkhYMDFzcUNmS3EyVElvQjcwWjNnVVMz?=
 =?utf-8?B?S1lhMzR5WEppOENpd3pFaHFnMHg0QkZ4NWpsazU3WEJjSDFEYkhWQTBlVUF0?=
 =?utf-8?B?L2MxcmFTTWF0ZjBzTGp2VFY1SDVZUFZpOHNESkZIRzM3MFhHZUd4Wk5qNi8x?=
 =?utf-8?B?aWt3ZFBIRjFGSVE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 04:15:15.3224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 905f3178-14bc-4bba-1d1a-08d8b5e77f7d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nUU+7DYaYgd7NhFFm8SBz1g4rYcNzCmpd4QHphOeW2kCL57Hy20R5s4k6j4T56xO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4236
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 mlxscore=0
 adultscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101110024
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/21 2:09 PM, Andrii Nakryiko wrote:
> Add support for searching for ksym externs not just in vmlinux BTF, but across
> all module BTFs, similarly to how it's done for CO-RE relocations. Kernels
> that expose module BTFs through sysfs are assumed to support new ldimm64
> instruction extension with BTF FD provided in insn[1].imm field, so no extra
> feature detection is performed.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>   tools/lib/bpf/libbpf.c | 47 +++++++++++++++++++++++++++---------------
>   1 file changed, 30 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 6ae748f6ea11..57559a71e4de 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -395,7 +395,8 @@ struct extern_desc {
>   			unsigned long long addr;
>   
>   			/* target btf_id of the corresponding kernel var. */
> -			int vmlinux_btf_id;
> +			int kernel_btf_obj_fd;
> +			int kernel_btf_id;
>   
>   			/* local btf_id of the ksym extern's type. */
>   			__u32 type_id;
> @@ -6162,7 +6163,8 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
>   			} else /* EXT_KSYM */ {
>   				if (ext->ksym.type_id) { /* typed ksyms */
>   					insn[0].src_reg = BPF_PSEUDO_BTF_ID;
> -					insn[0].imm = ext->ksym.vmlinux_btf_id;
> +					insn[0].imm = ext->ksym.kernel_btf_id;
> +					insn[1].imm = ext->ksym.kernel_btf_obj_fd;
>   				} else { /* typeless ksyms */
>   					insn[0].imm = (__u32)ext->ksym.addr;
>   					insn[1].imm = ext->ksym.addr >> 32;
> @@ -7319,7 +7321,8 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
>   static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
>   {
>   	struct extern_desc *ext;
> -	int i, id;
> +	struct btf *btf;
> +	int i, j, id, btf_fd, err;
>   
>   	for (i = 0; i < obj->nr_extern; i++) {
>   		const struct btf_type *targ_var, *targ_type;
> @@ -7331,8 +7334,22 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
>   		if (ext->type != EXT_KSYM || !ext->ksym.type_id)
>   			continue;
>   
> -		id = btf__find_by_name_kind(obj->btf_vmlinux, ext->name,
> -					    BTF_KIND_VAR);
> +		btf = obj->btf_vmlinux;
> +		btf_fd = 0;
> +		id = btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
> +		if (id == -ENOENT) {
> +			err = load_module_btfs(obj);
> +			if (err)
> +				return err;
> +
> +			for (j = 0; j < obj->btf_module_cnt; j++) {
> +				btf = obj->btf_modules[j].btf;
> +				btf_fd = obj->btf_modules[j].fd;

Do we have possibility btf_fd == 0 here?

> +				id = btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
> +				if (id != -ENOENT)
> +					break;
> +			}
> +		}
>   		if (id <= 0) {
>   			pr_warn("extern (ksym) '%s': failed to find BTF ID in vmlinux BTF.\n",
>   				ext->name);
> @@ -7343,24 +7360,19 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
>   		local_type_id = ext->ksym.type_id;
>   
>   		/* find target type_id */
> -		targ_var = btf__type_by_id(obj->btf_vmlinux, id);
> -		targ_var_name = btf__name_by_offset(obj->btf_vmlinux,
> -						    targ_var->name_off);
> -		targ_type = skip_mods_and_typedefs(obj->btf_vmlinux,
> -						   targ_var->type,
> -						   &targ_type_id);
> +		targ_var = btf__type_by_id(btf, id);
> +		targ_var_name = btf__name_by_offset(btf, targ_var->name_off);
> +		targ_type = skip_mods_and_typedefs(btf, targ_var->type, &targ_type_id);
>   
>   		ret = bpf_core_types_are_compat(obj->btf, local_type_id,
> -						obj->btf_vmlinux, targ_type_id);
> +						btf, targ_type_id);
>   		if (ret <= 0) {
>   			const struct btf_type *local_type;
>   			const char *targ_name, *local_name;
>   
>   			local_type = btf__type_by_id(obj->btf, local_type_id);
> -			local_name = btf__name_by_offset(obj->btf,
> -							 local_type->name_off);
> -			targ_name = btf__name_by_offset(obj->btf_vmlinux,
> -							targ_type->name_off);
> +			local_name = btf__name_by_offset(obj->btf, local_type->name_off);
> +			targ_name = btf__name_by_offset(btf, targ_type->name_off);
>   
>   			pr_warn("extern (ksym) '%s': incompatible types, expected [%d] %s %s, but kernel has [%d] %s %s\n",
>   				ext->name, local_type_id,
> @@ -7370,7 +7382,8 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
>   		}
>   
>   		ext->is_set = true;
> -		ext->ksym.vmlinux_btf_id = id;
> +		ext->ksym.kernel_btf_obj_fd = btf_fd;
> +		ext->ksym.kernel_btf_id = id;
>   		pr_debug("extern (ksym) '%s': resolved to [%d] %s %s\n",
>   			 ext->name, id, btf_kind_str(targ_var), targ_var_name);
>   	}
> 
