Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0555F2F5307
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbhAMTEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 14:04:50 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23166 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728108AbhAMTEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 14:04:49 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10DIxwTe014147;
        Wed, 13 Jan 2021 11:03:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=L5Znl3qrLvH1zy53gfzZDyPtY1DmjMem7Fxm+YtXPDo=;
 b=Z0jVQYkOWjrVLrY446uI9OtSrNa0cZOlUkOWHII8kvVuoXr+OQ3bJRknVBJlW5bRPoBQ
 bv4uOkQcEfZKLR7LRfnfxRHYmkZhi1o4dCYoYZFAg39GI81M+NXwNMX6FOnaCi2kjZHo
 Y/2pgBuVYoOMerXQ7eE9SR4sFAAyTZBnrBw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 361fpfxv1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 Jan 2021 11:03:53 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 11:03:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCTGjAaThZNuWNzEAqXI3kgRrvYdfOIStjSZLj20CHbDCqOGtDtLA6oWZ/pNUyJj+zrPS6cpEIqgVV/Xsvd4smA3Nqk/N+uNXuz7oWJH0euIUpmJGKmkEyvNSjMklvX7OYYHaoWX1LhYPu+caf9YiDjxbAPDTUZETrclOVC0xXOXoi3PKQReUB67Je+giJQq08GNMPyMLx5X5p+SFSeUYuSOJd/5uZYl8NqyZSc9jnDU64F4dOw2RhCSoxuBn9f4p8pgAh0/C3Bgt9Kk0BHgSORFdjfCJYAXpGjlilvDSlZWHqxa43jw3yh2d5XJfqboKeGJGiNs5ezQ8ShGvzZbLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L5Znl3qrLvH1zy53gfzZDyPtY1DmjMem7Fxm+YtXPDo=;
 b=RfrW3QJrejoFDGJ7K7OkLJLhc/dKmWSkoOmQ8iytmgS9zAFpXbG/ySHhc+PWoixjhClml+vnSQarwzqg9TQnYOVYZvIxjr8oWFfV99rytvnJGyGeggY44qiRj1QeG/08XmLkTl6IqKujKVwX5Ts6HlC+rET+loT1eyPcMuWOhfPyLMJhB/1KRgr/qTPNyuPkJnjcJx0mgEFPDfuPBTGHbGw2RIfsqT+rq+7F3IcMPfpUjIlKpBUostYcz3lYaB13A6aTiWeaSE3RXWC8Aa2irruZ9Ynk66kQjBJGCrDmBgED/7JNtH0WqFdndxaVmRc1DdFfOlAoYAA+etVrLzErPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L5Znl3qrLvH1zy53gfzZDyPtY1DmjMem7Fxm+YtXPDo=;
 b=Dqr7Rq0gEASwLY4TJ5b1Rcgry4SKj8qgQKblwkLc6Sdc72TTbJ7dHlzYW1te+wokE13CHabyPMz5ayZZbPeH2+wkBom1pinWKAuqrt8wuGSLY/khAvARN1c2hiDIEzzPOT3AYy6MdRAJZ+pxL2jo39q035DZn9i6zn9Cxm/lCLA=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2951.namprd15.prod.outlook.com (2603:10b6:a03:f7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 13 Jan
 2021 19:03:49 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66%3]) with mapi id 15.20.3763.010; Wed, 13 Jan 2021
 19:03:49 +0000
Date:   Wed, 13 Jan 2021 11:03:42 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH bpf-next v7 3/4] bpf: try to avoid kzalloc in
 cgroup/{s,g}etsockopt
Message-ID: <20210113190342.dzqylb6oqrkfhccv@kafai-mbp.dhcp.thefacebook.com>
References: <20210112223847.1915615-1-sdf@google.com>
 <20210112223847.1915615-4-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112223847.1915615-4-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:55b1]
X-ClientProxiedBy: CO2PR04CA0198.namprd04.prod.outlook.com
 (2603:10b6:104:5::28) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:55b1) by CO2PR04CA0198.namprd04.prod.outlook.com (2603:10b6:104:5::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Wed, 13 Jan 2021 19:03:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d08a7d11-c85c-4775-32d8-08d8b7f5f5f4
X-MS-TrafficTypeDiagnostic: BYAPR15MB2951:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB29513E5BC49385284FF5BB1CD5A90@BYAPR15MB2951.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hcFUnyDUCm5ElU7xdY2/+I7fIlLnzLcYykQFW3N7eE+UwU9h1Kf4PDA+oAXKTymH2DRHGB62RyCay/VnIFDWaWocr/JlqQQUOSBke29KdWk4t0SknpU83JM1wHaoAnV1LBSKSfkK+5biEvPhglcxm8hP0SlmExK/UM4FFi/jBhAIz/SqRgMeRjjOkCYQQe0cN81rM7rxmolXFb1C712HywnHR8BIQh7vl/0AWxU5UGlmiCill1ZCpiUXvfZXI+A+VMTC7xPl/qnli4KSl0yup2jMvWKvw5BUy1gj176f/HUvLf9jRkJGp+ZVjfyTjBDBAi6/YMAZ1NkBi0Pn5gafha+T9lj4LPevR2mGYoOIrQU7PVZwLdkn/us0so1UyeNPaehWgAHvnHqT0xIzCRkenw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(396003)(346002)(39860400002)(83380400001)(2906002)(6916009)(6506007)(316002)(86362001)(16526019)(9686003)(55016002)(4326008)(8676002)(7696005)(66476007)(52116002)(6666004)(66556008)(66946007)(8936002)(5660300002)(1076003)(478600001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XkpOeep51k2lOnawm8VEpeS5FZls1wJ/3duU7j9ecCbG0cfCkuVjkqSiRSfw?=
 =?us-ascii?Q?OO3ajdlGeZER1V4bTciHRFHWT4QzQSP5ShjtuM7HBjg/ZXqVSMxD+gR7NTRE?=
 =?us-ascii?Q?dhxlngMEhAk9z5lcaSB5BtKE738Pgxb+FbSWhAAofjkYdZdc8OtFHN63DzEx?=
 =?us-ascii?Q?4eLeHN6pdH9ifAe/DWLgRuvY1JIVT/T5df0o2PyAEouChmqVB6rUxefx1EKD?=
 =?us-ascii?Q?RZJZVgA+NAUwvaX9VjzSMkFisyF2+1eGAzWsYc18Z0EO7J2po9gY/xKwzuy4?=
 =?us-ascii?Q?48r0a7rPy2BisJ2sYH7N88wqo4i7SwIdxb3fROEUkJx+Tr7+xPwULNTxFmd5?=
 =?us-ascii?Q?q22R5IBN2KlyxFhLTCe0AATvKApb6OhT+C/FzoIPScLxcMproDNM0qsj+9/P?=
 =?us-ascii?Q?1X/HJOYqKrD3+GW/gJRv7GehfvYQpck/eJFsdbdUPKGiYGNzdcTZZSedCfke?=
 =?us-ascii?Q?D5VVO/XiS5W9ShkcfE2Vb9DLw5ivojmNL84qWtJxmfTlkRQv+AkQU89L3YAy?=
 =?us-ascii?Q?ekDhC46A1kr2KYnWXJ3PkgrWNlZ2E1+/s01PV0Ogq5vALUnsMZV/oIoghkc+?=
 =?us-ascii?Q?D7iw9dNnnFDl+2F2W71HQr9/1Z7FCtCzFB7KelUf4CeMIdZY/raiaOemlFHM?=
 =?us-ascii?Q?4efPXd4D7x+77t5MRt8WjfERG9nTq6X4b/GBK+sR7BiXqT3VCzxLCvzAEncp?=
 =?us-ascii?Q?hblm4b8VjlqhgBcklFUR/QN6daF2NisoMGfi4x2wHGbEW/cIqj/6iYe+ridq?=
 =?us-ascii?Q?Wmc7X9B0WMxINYlEjc0t/uRh6TxsPB1O8x1NNvOP3HXH51g/ObBLIoM6Y1Su?=
 =?us-ascii?Q?m9wDtetFSTn8F68Yl4HaXo8Jo/I7x651+X3D1JIhsvArzAYSSLSdLKnB5jvJ?=
 =?us-ascii?Q?mtw8bECnhcylXdmzJq3YLiUVMeDSKfT/WRGjArR1KJS3PTlCV9tHUSlzhJQC?=
 =?us-ascii?Q?DeOzwLRWyhzRENbpPZtkztLYXVEemXF3dRyI1L3somwjclzwni1jNKQaNWLI?=
 =?us-ascii?Q?nkIAuyPjZRjLdHWm9uEtLLtcwA=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 19:03:49.2968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: d08a7d11-c85c-4775-32d8-08d8b7f5f5f4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ++nfJaiAwtxmCMEae6BJYZi+8IZWChMHKedUYwtQSczsiTX+GBEnwzIR3mbCuk6C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2951
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_09:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101130113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 02:38:46PM -0800, Stanislav Fomichev wrote:
> When we attach a bpf program to cgroup/getsockopt any other getsockopt()
> syscall starts incurring kzalloc/kfree cost.
> 
> Let add a small buffer on the stack and use it for small (majority)
> {s,g}etsockopt values. The buffer is small enough to fit into
> the cache line and cover the majority of simple options (most
> of them are 4 byte ints).
> 
> It seems natural to do the same for setsockopt, but it's a bit more
> involved when the BPF program modifies the data (where we have to
> kmalloc). The assumption is that for the majority of setsockopt
> calls (which are doing pure BPF options or apply policy) this
> will bring some benefit as well.
> 
> Without this patch (we remove about 1% __kmalloc):
>      3.38%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
>             |
>              --3.30%--__cgroup_bpf_run_filter_getsockopt
>                        |
>                         --0.81%--__kmalloc
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> ---
>  include/linux/filter.h |  5 ++++
>  kernel/bpf/cgroup.c    | 52 ++++++++++++++++++++++++++++++++++++------
>  2 files changed, 50 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 29c27656165b..8739f1d4cac4 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -1281,6 +1281,11 @@ struct bpf_sysctl_kern {
>  	u64 tmp_reg;
>  };
>  
> +#define BPF_SOCKOPT_KERN_BUF_SIZE	32
> +struct bpf_sockopt_buf {
> +	u8		data[BPF_SOCKOPT_KERN_BUF_SIZE];
> +};
> +
>  struct bpf_sockopt_kern {
>  	struct sock	*sk;
>  	u8		*optval;
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 416e7738981b..dbeef7afbbf9 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1298,7 +1298,8 @@ static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
>  	return empty;
>  }
>  
> -static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
> +static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen,
> +			     struct bpf_sockopt_buf *buf)
>  {
>  	if (unlikely(max_optlen < 0))
>  		return -EINVAL;
> @@ -1310,6 +1311,15 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
>  		max_optlen = PAGE_SIZE;
>  	}
>  
> +	if (max_optlen <= sizeof(buf->data)) {
> +		/* When the optval fits into BPF_SOCKOPT_KERN_BUF_SIZE
> +		 * bytes avoid the cost of kzalloc.
> +		 */
> +		ctx->optval = buf->data;
> +		ctx->optval_end = ctx->optval + max_optlen;
> +		return max_optlen;
> +	}
> +
>  	ctx->optval = kzalloc(max_optlen, GFP_USER);
>  	if (!ctx->optval)
>  		return -ENOMEM;
> @@ -1319,16 +1329,26 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
>  	return max_optlen;
>  }
>  
> -static void sockopt_free_buf(struct bpf_sockopt_kern *ctx)
> +static void sockopt_free_buf(struct bpf_sockopt_kern *ctx,
> +			     struct bpf_sockopt_buf *buf)
>  {
> +	if (ctx->optval == buf->data)
> +		return;
>  	kfree(ctx->optval);
>  }
>  
> +static bool sockopt_buf_allocated(struct bpf_sockopt_kern *ctx,
> +				  struct bpf_sockopt_buf *buf)
> +{
> +	return ctx->optval != buf->data;
> +}
> +
>  int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>  				       int *optname, char __user *optval,
>  				       int *optlen, char **kernel_optval)
>  {
>  	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> +	struct bpf_sockopt_buf buf = {};
>  	struct bpf_sockopt_kern ctx = {
>  		.sk = sk,
>  		.level = *level,
> @@ -1350,7 +1370,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>  	 */
>  	max_optlen = max_t(int, 16, *optlen);
>  
> -	max_optlen = sockopt_alloc_buf(&ctx, max_optlen);
> +	max_optlen = sockopt_alloc_buf(&ctx, max_optlen, &buf);
>  	if (max_optlen < 0)
>  		return max_optlen;
>  
> @@ -1390,14 +1410,31 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>  		 */
>  		if (ctx.optlen != 0) {
>  			*optlen = ctx.optlen;
> -			*kernel_optval = ctx.optval;
> +			/* We've used bpf_sockopt_kern->buf as an intermediary
> +			 * storage, but the BPF program indicates that we need
> +			 * to pass this data to the kernel setsockopt handler.
> +			 * No way to export on-stack buf, have to allocate a
> +			 * new buffer.
> +			 */
> +			if (!sockopt_buf_allocated(&ctx, &buf)) {
> +				void *p = kzalloc(ctx.optlen, GFP_USER);
nit. zero-ing is unnecessary when memcpy() will be done later.

Acked-by: Martin KaFai Lau <kafai@fb.com>
