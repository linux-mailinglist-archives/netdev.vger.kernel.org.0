Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C07D1D240E
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 02:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733199AbgENAq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 20:46:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29666 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731334AbgENAq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 20:46:27 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04E0k5kJ015910;
        Wed, 13 May 2020 17:46:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=M1s5MAwJEdJo+itHJf+1QW4VdhPe8e4VQ90B+40JQVM=;
 b=kw/Bqk14q1e0Y14R+s/K/FN2YZ+zxJzXVadNSXMI4m5hUXDaQOZyo2x9O8Lp1E63S3sO
 WHvxWDXWTotTiEWemx9UrwVD110EE0t1Siq0/pI91XC6f49duiSHmRwygOWfMpdKIWvD
 5Zz2NXtsldGcZ1ue/p5ZI1DT3E6UbKrLDoU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3100xh8e8w-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 May 2020 17:46:07 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 17:45:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/iFSoO4FeCRSJ7FTgEHJMwMMPBTThRIrsYgS5Lcu2uk904K6Rw+qIhDWBBtUkw7rTwkJ7fTLi5ASG3J+eO1D2SdFUmGsPYZInvZ/D8i08o421ZdjxfwBRPOOZPEwWhLE72Uqq0O2N0S1yGustP1nW/yp0xep/qOvl/PFhE4RRT8h+peoycYd7Al7C5wmTCh4Hat7Dzfc9lLO54VPPyiaikcjnUQF8JeX4vVzTcIrClMvfIWQjO7fCdsNJrtwDee6nFaDEggECJLCBqfqiesmlPaJ3Y585fxuxyiqOawybj7yytjdFmbpYqv7qqT1lwjgX/Y2GDIHjVqOGcLLJg3oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1s5MAwJEdJo+itHJf+1QW4VdhPe8e4VQ90B+40JQVM=;
 b=dlZKBcT2xouGb/h6nKqK4NUAQlhlI93xfs5p+gLD3UqrjEYex7xRwkS1RPSVT/P8NEs2JwUsdovZm6VbUFxStvq7HDG8mJmVWyNN2vGeaWXm7JxeROzUaD6us7r/N1o2jNT9GAbbZpyXdvT+ihr+HtEo5YPvrNHGcwUDntPfR+dl0xRBypUw+QAWpTIFmV3ZJXVNajZVMkf5zGSuwM0eOeqR28/8zz9C8sJmkbNTxC9/BRA1Yf5oIep7l++mfND3WTbYJ+1hxKuYDQFEE/NKy+r5irFhu6/t+E4qR5uPlIM4At6CBiwjTbz5Q+HT2ZQ4hpF/w381RFGs+WwrqiCa7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1s5MAwJEdJo+itHJf+1QW4VdhPe8e4VQ90B+40JQVM=;
 b=eYUCQZnhSgo6a6BlmGzyWPzJKn9WI6ybj6CLLYG955Y0oYB9pYzpeIrM2neZ8KUNoIsuOMwl2PRInPlSoO+atuMWYwlji/KH7Fe9EJgH0m0WOf+hcRHYAVjLnPnF0EDMBybK1kAjYZNatDJmrwaAZF/XB/+czbjcuETCAz/DWj8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2455.namprd15.prod.outlook.com (2603:10b6:a02:90::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.35; Thu, 14 May
 2020 00:45:54 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Thu, 14 May 2020
 00:45:54 +0000
Subject: Re: [PATCH v2 bpf-next 4/7] printk: add type-printing %pT format
 specifier which uses BTF
To:     Alan Maguire <alan.maguire@oracle.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <bpf@vger.kernel.org>
CC:     <joe@perches.com>, <linux@rasmusvillemoes.dk>,
        <arnaldo.melo@gmail.com>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
 <1589263005-7887-5-git-send-email-alan.maguire@oracle.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <51ac81f5-3d74-e394-3183-5d8366e2ddcc@fb.com>
Date:   Wed, 13 May 2020 17:45:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <1589263005-7887-5-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0106.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::47) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:d8fa) by BYAPR11CA0106.namprd11.prod.outlook.com (2603:10b6:a03:f4::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Thu, 14 May 2020 00:45:53 +0000
X-Originating-IP: [2620:10d:c090:400::5:d8fa]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4089f485-e11b-47ae-562f-08d7f7a0285d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2455:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2455AE429E5C53922EE45BFDD3BC0@BYAPR15MB2455.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JDVD0ZYrJv+3eyyHI5fuYd0Si7eCV4rlY12BLArtOmViqGKJkrHJczdRy5W1FL9PXpul6u5LGIJzmmA+4U8pH3c1UccFvU+UDto9UWgJLqW0wn+I32Ke1rHygxjPjVK6q6kyn2zIP5HI4YMeOQYATIGt0DkK//OkLt/u7keh2TqCp+JJ9uCDc3YQQZGp9+PFVKRnvhv+nfBFfsOkO0yU2c2DghNulXMPwJMY7bVX+6AxEoMb4QBL3y0J1W+Msia/pFyHeuODWnTDL7uU+7fWqnLqBozMmtvvAY2udiJdrmsSU6xDqSCP5fyI9QWAvLY1Cdm1P8F6k32bni8VOVTDZ64cbrtAm11DXgXxjIcE4lvhCJXLWSRvF3q2moIj5GHWfjP4lCFSOm/ipjggNViqS7UwbjVy/UKSQR5OLYqliHQcZCIluRYC+hVkKQVqUipYJq2cy8uy5Nlxh21Xn+OQ0wff3tpEijzcI/35jUo9z6X21Rak7A8L9BmM1SoALovN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(136003)(366004)(376002)(346002)(7416002)(66556008)(86362001)(478600001)(2616005)(53546011)(36756003)(6512007)(8936002)(66476007)(6506007)(4326008)(16526019)(31686004)(8676002)(186003)(316002)(66946007)(52116002)(31696002)(2906002)(6486002)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: IpfjvRkb9mRIYkb937QlRTKkkpi2UkmA9fEz8uuBlv1D20t/3rt91rxJgVWpMVBxwmz8aDU1FoT/ENXb57lDKXBOqMGT7OFJT9vvJ4xu8TpNw0DNK7bo1Fh31H8ue04LtbkIqW+bf5DdQ+ScYwJx4jQJbGCjVHPU7FtAZSN9e1tzXWjOrf5hh2M02FDzL7B0QDUccv/9WcG1eMnshOAxYKDOt4XxiNX4dCJ6vlRNFE/OlxP0pRGeyBeVV4VVtfh1ngQ4MjM+g0RX11HvwiDAGu9HHZ54VX5iSPe4cuyJnP9oGnVIWs3COpsLSs5JpkbRAzfzZtgxdyb6yxqu2uWkG7PKcw41ZF+zsQKew8GJ/PgUljJsCyXmv8cWTKpvnGV5vuSM6QCuldCCvQ5uofM/aG3H5E7VtM8TApYFXMjH7BBLvPboEXPN00Dx2bbnbYaHa1dV0O5DSzoI9kHuarco7kCmLr7PaxyiOVEZDDWbZZ0BoGVmfmO1h7hKWtXYtyU6xjOnn8snHwmE9+QIOV6Q6A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4089f485-e11b-47ae-562f-08d7f7a0285d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 00:45:54.1947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dBih8V5nvstZ7DYr2T7/1+FhuLYmkTW3gzeyeua5DLhxJ2zLgz3PMkJYW9s9/7Ny
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2455
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_09:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 cotscore=-2147483648
 mlxscore=0 priorityscore=1501 adultscore=0 impostorscore=0 malwarescore=0
 spamscore=0 clxscore=1015 suspectscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140005
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/20 10:56 PM, Alan Maguire wrote:
> printk supports multiple pointer object type specifiers (printing
> netdev features etc).  Extend this support using BTF to cover
> arbitrary types.  "%pT" specifies the typed format, and the pointer
> argument is a "struct btf_ptr *" where struct btf_ptr is as follows:
> 
> struct btf_ptr {
> 	void *ptr;
> 	const char *type;
> 	u32 id;
> };
> 
> Either the "type" string ("struct sk_buff") or the BTF "id" can be
> used to identify the type to use in displaying the associated "ptr"
> value.  A convenience function to create and point at the struct
> is provided:
> 
> 	printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct sk_buff));
> 
> When invoked, BTF information is used to traverse the sk_buff *
> and display it.  Support is present for structs, unions, enums,
> typedefs and core types (though in the latter case there's not
> much value in using this feature of course).
> 
> Default output is indented, but compact output can be specified
> via the 'c' option.  Type names/member values can be suppressed
> using the 'N' option.  Zero values are not displayed by default
> but can be using the '0' option.  Pointer values are obfuscated
> unless the 'x' option is specified.  As an example:
> 
>    struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
>    pr_info("%pT", BTF_PTR_TYPE(skb, struct sk_buff));
> 
> ...gives us:
> 
> (struct sk_buff){
>   .transport_header = (__u16)65535,
>   .mac_header = (__u16)65535,
>   .end = (sk_buff_data_t)192,
>   .head = (unsigned char *)000000006b71155a,
>   .data = (unsigned char *)000000006b71155a,
>   .truesize = (unsigned int)768,
>   .users = (refcount_t){
>    .refs = (atomic_t){
>     .counter = (int)1,
>    },
>   },
>   .extensions = (struct skb_ext *)00000000f486a130,
> }
> 
> printk output is truncated at 1024 bytes.  For cases where overflow
> is likely, the compact/no type names display modes may be used.
> 
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>   Documentation/core-api/printk-formats.rst |  15 ++++
>   include/linux/btf.h                       |   3 +-
>   include/linux/printk.h                    |  16 +++++
>   lib/Kconfig                               |  16 +++++
>   lib/vsprintf.c                            | 113 ++++++++++++++++++++++++++++++
>   5 files changed, 162 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
> index 8ebe46b1..5c66097 100644
> --- a/Documentation/core-api/printk-formats.rst
> +++ b/Documentation/core-api/printk-formats.rst
> @@ -545,6 +545,21 @@ For printing netdev_features_t.
>   
>   Passed by reference.
>   
> +BTF-based printing of pointer data
> +----------------------------------
> +If '%pT' is specified, use the struct btf_ptr * along with kernel vmlinux
> +BPF Type Format (BTF) to show the typed data.  For example, specifying
> +
> +	printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct_sk_buff));
> +
> +will utilize BTF information to traverse the struct sk_buff * and display it.
> +
> +Supported modifers are
> + 'c' compact output (no indentation, newlines etc)
> + 'N' do not show type names
> + 'x' show raw pointers (no obfuscation)
> + '0' show zero-valued data (it is not shown by default)
> +
>   Thanks
>   ======
>   
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index d571125..7b585ab 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -169,10 +169,11 @@ static inline const struct btf_member *btf_type_member(const struct btf_type *t)
>   	return (const struct btf_member *)(t + 1);
>   }
>   
> +struct btf *btf_parse_vmlinux(void);
> +
>   #ifdef CONFIG_BPF_SYSCALL
>   const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
>   const char *btf_name_by_offset(const struct btf *btf, u32 offset);
> -struct btf *btf_parse_vmlinux(void);
>   struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
>   #else
>   static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index fcde0772..3c3ea53 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -528,4 +528,20 @@ static inline void print_hex_dump_debug(const char *prefix_str, int prefix_type,
>   #define print_hex_dump_bytes(prefix_str, prefix_type, buf, len)	\
>   	print_hex_dump_debug(prefix_str, prefix_type, 16, 1, buf, len, true)
>   
> +/**
> + * struct btf_ptr is used for %pT (typed pointer) display; the
> + * additional type string/BTF id are used to render the pointer
> + * data as the appropriate type.
> + */
> +struct btf_ptr {
> +	void *ptr;
> +	const char *type;
> +	u32 id;
> +};
> +
> +#define	BTF_PTR_TYPE(ptrval, typeval) \
> +	(&((struct btf_ptr){.ptr = ptrval, .type = #typeval}))
> +
> +#define BTF_PTR_ID(ptrval, idval) \
> +	(&((struct btf_ptr){.ptr = ptrval, .id = idval}))
>   #endif
[...]
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 7c488a1..f9276f8 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -43,6 +43,7 @@
>   #ifdef CONFIG_BLOCK
>   #include <linux/blkdev.h>
>   #endif
> +#include <linux/btf.h>
>   
>   #include "../mm/internal.h"	/* For the trace_print_flags arrays */
>   
> @@ -2059,6 +2060,103 @@ char *fwnode_string(char *buf, char *end, struct fwnode_handle *fwnode,
>   	return widen_string(buf, buf - buf_start, end, spec);
>   }
>   
> +#if IS_ENABLED(CONFIG_BTF_PRINTF)
> +#define btf_modifier_flag(c)	(c == 'c' ? BTF_SHOW_COMPACT :	\
> +				 c == 'N' ? BTF_SHOW_NONAME :	\
> +				 c == 'x' ? BTF_SHOW_PTR_RAW :	\
> +				 c == '0' ? BTF_SHOW_ZERO : 0)
> +
> +static noinline_for_stack
> +char *btf_string(char *buf, char *end, void *ptr, struct printf_spec spec,
> +		 const char *fmt)
> +{
> +	struct btf_ptr *bp = (struct btf_ptr *)ptr;
> +	u8 btf_kind = BTF_KIND_TYPEDEF;
> +	const struct btf_type *t;
> +	const struct btf *btf;
> +	char *buf_start = buf;
> +	const char *btf_type;
> +	u64 flags = 0, mod;
> +	s32 btf_id;
> +
> +	if (check_pointer(&buf, end, ptr, spec))
> +		return buf;
> +
> +	if (check_pointer(&buf, end, bp->ptr, spec))
> +		return buf;
> +
> +	while (isalnum(*fmt)) {
> +		mod = btf_modifier_flag(*fmt);
> +		if (!mod)
> +			break;
> +		flags |= mod;
> +		fmt++;
> +	}
> +
> +	btf = bpf_get_btf_vmlinux();
> +	if (IS_ERR_OR_NULL(btf))
> +		return ptr_to_id(buf, end, bp->ptr, spec);
> +
> +	if (bp->type != NULL) {
> +		btf_type = bp->type;
> +
> +		if (strncmp(bp->type, "struct ", strlen("struct ")) == 0) {
> +			btf_kind = BTF_KIND_STRUCT;
> +			btf_type += strlen("struct ");
> +		} else if (strncmp(btf_type, "union ", strlen("union ")) == 0) {
> +			btf_kind = BTF_KIND_UNION;
> +			btf_type += strlen("union ");
> +		} else if (strncmp(btf_type, "enum ", strlen("enum ")) == 0) {
> +			btf_kind = BTF_KIND_ENUM;
> +			btf_type += strlen("enum ");
> +		}

I think typedef should be supported here.
In kernel, we have some structure directly defined as typedef's.
A lot of internal int types also typedefs, like u32, atomic_t,
possible_net_t, etc.

A type name without prefix "struct", "union", "enum" can be
treated as a typedef first.

If the type name is not a typedef, it is then compared to a limited
number of C basic int types like "char", "unsigned char", "short",
"unsigned short", ...

> +
> +		if (strlen(btf_type) == 0)
> +			return ptr_to_id(buf, end, bp->ptr, spec);
> +
> +		/*
> +		 * Assume type specified is a typedef as there's not much
> +		 * benefit in specifying int types other than wasting time
> +		 * on BTF lookups; we optimize for the most useful path.
> +		 *
> +		 * Fall back to BTF_KIND_INT if this fails.
> +		 */
> +		btf_id = btf_find_by_name_kind(btf, btf_type, btf_kind);
> +		if (btf_id < 0)
> +			btf_id = btf_find_by_name_kind(btf, btf_type,
> +						       BTF_KIND_INT);
> +	} else if (bp->id > 0)
> +		btf_id = bp->id;
> +	else
> +		return ptr_to_id(buf, end, bp->ptr, spec);
> +
> +	if (btf_id > 0)
> +		t = btf_type_by_id(btf, btf_id);
> +	if (btf_id <= 0 || !t)
> +		return ptr_to_id(buf, end, bp->ptr, spec);
> +
> +	buf += btf_type_snprintf_show(btf, btf_id, bp->ptr, buf,
> +				      end - buf_start, flags);
> +
> +	return widen_string(buf, buf - buf_start, end, spec);
> +}
> +#else
> +static noinline_for_stack
> +char *btf_string(char *buf, char *end, void *ptr, struct printf_spec spec,
> +	const char *fmt)
> +{
> +	struct btf_ptr *bp = (struct btf_ptr *)ptr;
> +
> +	if (check_pointer(&buf, end, ptr, spec))
> +		return buf;
> +
> +	if (check_pointer(&buf, end, bp->ptr, spec))
> +		return buf;
> +
> +	return ptr_to_id(buf, end, bp->ptr, spec);
> +}
> +#endif /* IS_ENABLED(CONFIG_BTF_PRINTF) */
> +
>   /*
>    * Show a '%p' thing.  A kernel extension is that the '%p' is followed
>    * by an extra set of alphanumeric characters that are extended format
> @@ -2169,6 +2267,19 @@ char *fwnode_string(char *buf, char *end, struct fwnode_handle *fwnode,
>    *		P node name, including a possible unit address
>    * - 'x' For printing the address. Equivalent to "%lx".
>    *
> + * - 'T[cNx0]' For printing struct btf_ptr * data using BPF Type Format (BTF).
> + *
> + *			Optional arguments are
> + *			c		compact (no indentation/newlines)
> + *			N		do not print type and member names
> + *			x		do not obfuscate pointers
> + *			0		show 0-valued data
> + *
> + *    BPF_PTR_TYPE(ptr, type) can be used to place pointer and type string
> + *    in the "struct btf_ptr *" expected; for example:
> + *
> + *	printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct sk_buff));
> + *
>    * ** When making changes please also update:
>    *	Documentation/core-api/printk-formats.rst
>    *
> @@ -2251,6 +2362,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>   		if (!IS_ERR(ptr))
>   			break;
>   		return err_ptr(buf, end, ptr, spec);
> +	case 'T':
> +		return btf_string(buf, end, ptr, spec, fmt + 1);
>   	}
>   
>   	/* default is to _not_ leak addresses, hash before printing */
> 
