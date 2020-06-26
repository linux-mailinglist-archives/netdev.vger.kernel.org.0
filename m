Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E378620BBAF
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgFZVhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:37:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2018 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725803AbgFZVhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 17:37:00 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QLXKeb027536;
        Fri, 26 Jun 2020 14:36:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gqP0QGkZUvrLHAB5+w41Wir9U7m8054CGHf0JJwmVzU=;
 b=bHirWo/+fXmom9FxpAk/Qcl2RZQuEaTecCXZJw4cUgVjFBhNKxHjxFgkNKv2Z/puGu4c
 1qzgk/Qs8T1YebdQ/JBV9g3ulbY3tl4PXtTUy/cpxHoicS8DzGfsDUl5iMPvQar5NcNr
 LgwdXc7J4y6xxr13mhAtyMXPITBuXC3p3hY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0u7hvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 14:36:42 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 14:36:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4aWSsLy186WZHbRjuYec5PsI0XFN++g0MgwBhRLeqJg+bZfnoREHVQE6Oz7ab+O+x9KRLHsb74god44c0ReoYp4x0vSaU9cnL01NJMNSnSneNxYG1D4lMecco3rpvch3FN7CRLCSeTWmZ4fYmHaVjmwcLawfMxGXbIRSnsv55Qeysp1PJSCjdBN42Upa0XRHbGLnYbhoxcoB8vkQKNprheq29kONlDIL0NXYWA4CYhB8y7uCjV9n84zpHQQfE54SQSj8cyWVSqwbIU0szlsGExFCgmKC8C7QR+wqzQmGK0zqRMTTY/HUG+5i+bROr0Fej0iyJ7EJ1cZXP39kmWRqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gqP0QGkZUvrLHAB5+w41Wir9U7m8054CGHf0JJwmVzU=;
 b=NM4PnrpqY3bYnFJvZyghT0Qlbx+s1KBAr9MLaA7oj9L+Sh+Hmt9+2+bsOnh+RPddhnkyMPrhY8ILO84JzQlsLRaiG6fcCEDG4XMQqrQIecm/R7wbDDldrV9/NxRidh0cOCypOpypknRYQrjF3TlYSDsPXjR6yo4HNQcrnCBGuKQ1xQP303ICDa86MhTmSMmtE7BaSfqUgyfCSwoif0kvD4483oQ4dhWcLkScU3Ice6E3ZCNEVw81oyWneOso6n2KlPmXSyPK1rbTyfZ42OmyrGNcy2oegs9cIoTCuZO2gh+j8TayL48fUameGdZBie+ggUL3LPWzxYZe/UcC3YdeFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gqP0QGkZUvrLHAB5+w41Wir9U7m8054CGHf0JJwmVzU=;
 b=XsHD7OWQE8w6GX3R5T9I5dDwt5AzhbXw0RwhS1d17BK5X8mHBQ+hoZTwc2Ad8zeYGVlYwI4Ao2SOtVjpnuyzvR/CP+MMb/m3Irb2/oBCwdmh8HJDVz+Abn2tUY2F09rcxUHOMjo71bDMm/y3zVLIR+sjOkBpj+1cwDsINIQ8tHQ=
Authentication-Results: zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3416.namprd15.prod.outlook.com (2603:10b6:a03:110::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Fri, 26 Jun
 2020 21:36:40 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.033; Fri, 26 Jun 2020
 21:36:40 +0000
Subject: Re: [PATCH v4 bpf-next 05/14] bpf: Remove btf_id helpers resolving
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-6-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7480f7b2-01f0-f575-7e4f-cf3bde851c3f@fb.com>
Date:   Fri, 26 Jun 2020 14:36:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200625221304.2817194-6-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1988] (2620:10d:c090:400::5:90d4) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 21:36:38 +0000
X-Originating-IP: [2620:10d:c090:400::5:90d4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a495be0a-decd-4f5d-8e58-08d81a1902a1
X-MS-TrafficTypeDiagnostic: BYAPR15MB3416:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB34167B052E2B82BCD09C782AD3930@BYAPR15MB3416.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: djbnaExsNFEIC4TfeghtEIzyEEMz2f00Qmb2GdAOqN7dpkzKTEfCnsBjpuNwa3yXih+l/f55rOYYG3R+mIKbV+EiorcugM5vLL0+Z02LsK4Muwd65idspZ3cFSVjCnIUE3MA82rDbHj3oqDnKsIMrRvjZZAxCkEr89+/Ky8xtTz0kvPlTAuc8O0h+5HWtgATThHqLox7TdBR5KwdIpMnH0yGoQkZHvTQVOyWTxzpnWY4Ts+qmlG337gAoLybZHLAItKIWYPZ/Z7Geakl3d72wCYBa+s77OAlBh0QCzP6e3Gq9GIIooUNgQXEF34bjIrHk9z0shA2069blxiokrtxiihIzPV1uaNCdE0Y+0n//F1409LXzTfgWBVLGT+HkVES
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(136003)(346002)(39860400002)(376002)(2616005)(316002)(8936002)(54906003)(6486002)(7416002)(53546011)(8676002)(4326008)(31696002)(2906002)(83380400001)(52116002)(478600001)(86362001)(31686004)(16526019)(66556008)(36756003)(186003)(66946007)(66476007)(110136005)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9sT2X80vkj/FgTnfbWU+UgWOabkY/yWgQyiLLZbPQIEoM8X40pJWi5rsB0nu6P/Up3GlEun4TtqIqYYtNQ06Yr5MbbKacpPkZC7h8gWBhCCux3QKcKrUwj2d9Jz0OmdTj3atZ2jeGPk1yOXgQThFgfhQvWmshVtYxh0e57l5jPCGQgXis1a7nnxLjd4blAY4Gv5dmqfC7vPpt1K7QLlfMPyRunaZS9znUcciCfzZ5+skVWW9l54HQ0cBv5yWsCG0nZw++Kev5OWhqiN41qP2ZtR1Sud17fp9fGx0d148XPv59m2ZHARt79bl1hMCJAqZi/wwA5+O/5ijb5+ol/YGWM45Fsh3HUcZdMJK/3/6sWo325myff2VUiNFCCjKwi0LwyiL+oxH+F7ydr/Q0DmKu+YHj9z1TR6YjudfzxO/T1ZO7Is3rzfjooAzKtkjtgPxd3nN51OH7QbwHM7e8D3TQmh8vRLUtpZ9dNFTEFWIwjsT+fxjI/BeW5Hejs6sO5Gp4M7ksnJTZhPpkJybC3hyfw==
X-MS-Exchange-CrossTenant-Network-Message-Id: a495be0a-decd-4f5d-8e58-08d81a1902a1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 21:36:40.0677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iAuoutngc4mTn20a9NPmjKHGumknvttAg2TI9/rEQc7rExwjTR1/b1VSpkPcQFCt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3416
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0
 cotscore=-2147483648 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 mlxscore=0 bulkscore=0 phishscore=0 suspectscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/20 3:12 PM, Jiri Olsa wrote:
> Now when we moved the helpers btf_id arrays into .BTF_ids section,
> we can remove the code that resolve those IDs in runtime.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   kernel/bpf/btf.c | 90 +++++-------------------------------------------
>   1 file changed, 8 insertions(+), 82 deletions(-)
> 
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 4c3007f428b1..4da6b0770ff9 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4079,96 +4079,22 @@ int btf_struct_access(struct bpf_verifier_log *log,
>   	return -EINVAL;
>   }
>   
> -static int __btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn,
> -				   int arg)
> +int btf_resolve_helper_id(struct bpf_verifier_log *log,
> +			  const struct bpf_func_proto *fn, int arg)
>   {
> -	char fnname[KSYM_SYMBOL_LEN + 4] = "btf_";
> -	const struct btf_param *args;
> -	const struct btf_type *t;
> -	const char *tname, *sym;
> -	u32 btf_id, i;
> +	int id;
>   
> -	if (IS_ERR(btf_vmlinux)) {
> -		bpf_log(log, "btf_vmlinux is malformed\n");
> +	if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
>   		return -EINVAL;
> -	}
> -
> -	sym = kallsyms_lookup((long)fn, NULL, NULL, NULL, fnname + 4);
> -	if (!sym) {
> -		bpf_log(log, "kernel doesn't have kallsyms\n");
> -		return -EFAULT;
> -	}
>   
> -	for (i = 1; i <= btf_vmlinux->nr_types; i++) {
> -		t = btf_type_by_id(btf_vmlinux, i);
> -		if (BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF)
> -			continue;
> -		tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
> -		if (!strcmp(tname, fnname))
> -			break;
> -	}
> -	if (i > btf_vmlinux->nr_types) {
> -		bpf_log(log, "helper %s type is not found\n", fnname);
> -		return -ENOENT;
> -	}
> -
> -	t = btf_type_by_id(btf_vmlinux, t->type);
> -	if (!btf_type_is_ptr(t))
> -		return -EFAULT;
> -	t = btf_type_by_id(btf_vmlinux, t->type);
> -	if (!btf_type_is_func_proto(t))
> -		return -EFAULT;
> -
> -	args = (const struct btf_param *)(t + 1);
> -	if (arg >= btf_type_vlen(t)) {
> -		bpf_log(log, "bpf helper %s doesn't have %d-th argument\n",
> -			fnname, arg);
> +	if (WARN_ON_ONCE(!fn->btf_id))

The original code does not have this warning. It directly did
"ret = READ_ONCE(*btf_id);" after testing reg arg type ARG_PTR_TO_BTF_ID.

>   		return -EINVAL;
> -	}
>   
> -	t = btf_type_by_id(btf_vmlinux, args[arg].type);
> -	if (!btf_type_is_ptr(t) || !t->type) {
> -		/* anything but the pointer to struct is a helper config bug */
> -		bpf_log(log, "ARG_PTR_TO_BTF is misconfigured\n");
> -		return -EFAULT;
> -	}
> -	btf_id = t->type;
> -	t = btf_type_by_id(btf_vmlinux, t->type);
> -	/* skip modifiers */
> -	while (btf_type_is_modifier(t)) {
> -		btf_id = t->type;
> -		t = btf_type_by_id(btf_vmlinux, t->type);
> -	}
> -	if (!btf_type_is_struct(t)) {
> -		bpf_log(log, "ARG_PTR_TO_BTF is not a struct\n");
> -		return -EFAULT;
> -	}
> -	bpf_log(log, "helper %s arg%d has btf_id %d struct %s\n", fnname + 4,
> -		arg, btf_id, __btf_name_by_offset(btf_vmlinux, t->name_off));
> -	return btf_id;
> -}
> +	id = fn->btf_id[arg];

The corresponding BTF_ID definition here is:
   BTF_ID_LIST(bpf_skb_output_btf_ids)
   BTF_ID(struct, sk_buff)

The bpf helper writer needs to ensure proper declarations
of BTF_IDs like the above matching helpers definition.
Support we have arg1 and arg3 as BTF_ID. then the list
definition may be

   BTF_ID_LIST(bpf_skb_output_btf_ids)
   BTF_ID(struct, sk_buff)
   BTF_ID(struct, __unused)
   BTF_ID(struct, task_struct)

This probably okay, I guess.

>   
> -int btf_resolve_helper_id(struct bpf_verifier_log *log,
> -			  const struct bpf_func_proto *fn, int arg)
> -{
> -	int *btf_id = &fn->btf_id[arg];
> -	int ret;
> -
> -	if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
> +	if (!id || id > btf_vmlinux->nr_types)
>   		return -EINVAL;

id == 0 if btf_id cannot be resolved by resolve_btfids, right?
when id may be greater than btf_vmlinux->nr_types? If resolve_btfids 
application did incorrect transformation?

Anyway, this is to resolve helper meta btf_id. Even if you
return a btf_id > btf_vmlinux->nr_types, verifier will reject
since it will never be the same as the real parameter btf_id.
I would drop id > btf_vmlinux->nr_types here. This should never
happen for a correct tool. Even if it does, verifier will take
care of it.

> -
> -	ret = READ_ONCE(*btf_id);
> -	if (ret)
> -		return ret;
> -	/* ok to race the search. The result is the same */
> -	ret = __btf_resolve_helper_id(log, fn->func, arg);
> -	if (!ret) {
> -		/* Function argument cannot be type 'void' */
> -		bpf_log(log, "BTF resolution bug\n");
> -		return -EFAULT;
> -	}
> -	WRITE_ONCE(*btf_id, ret);
> -	return ret;
> +	return id;
>   }
>   
>   static int __get_type_size(struct btf *btf, u32 btf_id,
> 
