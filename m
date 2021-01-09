Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4AB2EFCEF
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 02:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbhAIB5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 20:57:00 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45546 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726418AbhAIB5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 20:57:00 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1091nn4a010134;
        Fri, 8 Jan 2021 17:56:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=2pba+ppLU5cKaNKpCyL+e+AiP57PyvEhENQ+605u0RE=;
 b=nisBXCzZ1DD6PDrrJjIVGSdT0eZz8gInWQAK7nb2CR4gAr87eTXd/8EY+z8aSe/6Amnu
 JmNl7lJygKWFH5K9lhslINbl+EjdZuP7UkCpQL3RolJ+B7AbTXUYNrz0vcOcpRxM+YE4
 k9pXtbM63FbW96AZC7ln6MXNI/+v2UlTG1A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35y0afgnpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 Jan 2021 17:56:05 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 8 Jan 2021 17:56:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kk4IEMxfTccPs+bgZ9gCQxr4PKhzdmDzxYxwGYcaJ5aYkz1UkBqJ0GdMxrN5SqNSchJHjJWwN7ZN2zJXmyz0yzbcfUxREHGJeZ68qPuuSUxAdW5T/YvIJvIjf5QhzSEqhkN9ZyNV3tbf68v/vccXhMmwTi3ioK21QIjKdWTyPpoTXUVacq0ZzicP4bWgnWHMvA5HsiuJTDDMZXb/hPOWsDCTqMD2Ebmmjn5aWofPo49MJ0n7qXpc0PfZVT7vATO9MZzvBitf0ilQ3wrvR+c6ZdzxawEPn2CWLluD2DCzzAB6BFRGAIvnTS40DL8utd80Ske2uMnHt1xnIJ+Rx4bG4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pba+ppLU5cKaNKpCyL+e+AiP57PyvEhENQ+605u0RE=;
 b=hl1nqBZ9sMnhj3W6/No0WMD/vCdW8cTStsbsDWz7BIlMdIfjq7t2nOWEzd/wKVnuHp0As/sEWs/RZ/r3t4nx7VvekS7G4zdzPyEEA9g0+xE1GDJIvFcc34CYT1gV0xZDXRDvT5wePTBvK1GGogCLdynnlhV5HetWNqW+nDmFQ2sApocOKKYyE9m4QaXJbhMnIRmkvalo3x5VyUx/KMXsEXhq4oFKsmvAKaYuCh7UG2dP5z2PhXa6TnDm8sEZCuRC9v5nKSbGLVdbmXIxvaaIrmBqsGlkyMYUy0R2GNBupi98t0499C9kyhD5v+9Dl+skrImyCP90n9n2eq9sImzmqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pba+ppLU5cKaNKpCyL+e+AiP57PyvEhENQ+605u0RE=;
 b=SCIu6++s91UmtZXQA+TSEAb2gW5FTMQGW89ldZv8pZGbGcWdf418cRmwv6ajeYlSCHmBbOqf+n0OMp0Or9llqAzTlX2q4cWlkbfOjnoXqKdJRD4Rei/XksrI5HaYnF9kzUl44fXRf5uVmUJmK2SaL+19/PsFWL1uv8ZRTAXkAO0=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2456.namprd15.prod.outlook.com (2603:10b6:a02:82::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Sat, 9 Jan
 2021 01:56:03 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7%7]) with mapi id 15.20.3721.024; Sat, 9 Jan 2021
 01:56:03 +0000
Date:   Fri, 8 Jan 2021 17:55:56 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH bpf-next v6 2/3] bpf: try to avoid kzalloc in
 cgroup/{s,g}etsockopt
Message-ID: <20210109015556.6sajviuria5qknf7@kafai-mbp.dhcp.thefacebook.com>
References: <20210108210223.972802-1-sdf@google.com>
 <20210108210223.972802-3-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108210223.972802-3-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:47b0]
X-ClientProxiedBy: MWHPR10CA0061.namprd10.prod.outlook.com
 (2603:10b6:300:2c::23) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:47b0) by MWHPR10CA0061.namprd10.prod.outlook.com (2603:10b6:300:2c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Sat, 9 Jan 2021 01:56:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45eedc68-2b1a-40d2-b408-08d8b441b861
X-MS-TrafficTypeDiagnostic: BYAPR15MB2456:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2456ACE8B9B69D1254A4AB51D5AD0@BYAPR15MB2456.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FfVXncWe1lm0MEg+JHXPoy72PWKa0dsL3ts0lhV8+xoL4i5GSzEPCnWC8bj6TwxGHMLss2qQgsRx0BNwmmPaLiLsmPtwNbZm4i+qGpymsQZ5riQAjdUwBzeTwpqqVTwf1/7EcfzQDVFuCID82fVVBi8lE9ODOaOYnuh1qpQYWPbBCAlySOmhb13vTNyBqQgbptinopS8soA37tx5RFD4kn92/QYyrzIoz16/J0CCJ7GEgvNwr1t7OFZSPrXj/7FCryzZ6h+7RvFsZj0Qks1CWv9V132lRFyqjqrN+qLMoNDgclkyYNSV7PJyd76y5s1yhXmPihJLvnYcKJQY7dJMLygY98GuSAYska5CWZ2ItMPeLNlOEk9Wd1xcdTKaFJ2ljf4+Fq/BFq7iW2D2NpaYTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(366004)(39860400002)(376002)(5660300002)(316002)(83380400001)(4326008)(2906002)(66946007)(6506007)(66476007)(8676002)(7696005)(478600001)(52116002)(66556008)(186003)(6916009)(6666004)(1076003)(9686003)(86362001)(16526019)(55016002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oVineNd+V94YFMuX6elz+wBJ7zxG57x1H/R2IpSnLf9kev+ZNKO2tzCC424Q?=
 =?us-ascii?Q?ZtQiUNWTfWZbRv9x5/CJP9JyFGqqzvwUSS1rBzwAINXgfvubz+qTGUGh1Rjg?=
 =?us-ascii?Q?7sbodJGaWVa5+ApfYHUhUPaFvq0StmDT8H5yUDBpMgjvasS/DIbnQBiZBebu?=
 =?us-ascii?Q?8SJbm9Xxv5ZFgvoyEXaH2Bg2/eWvI/9TS59evZeSepayCvkjtY/sM5IEN0E8?=
 =?us-ascii?Q?hDmiO0e2xh2E8nrzej14CGA0O8qX3tumEEBUFD9qDjJA5kZ5CrBEyADmXZBx?=
 =?us-ascii?Q?0NyNYgXnduBOAKmByf7yL1M9NoBrlAbO8191tUxfdN5dqghane0bOwUFqF7h?=
 =?us-ascii?Q?5kDKWpQrSyPgTy6c9clfbXQ2H74pgyKJw5IF0D8aDuOIBjZ5KUqrxkQmU22E?=
 =?us-ascii?Q?+jRvO92NPw94dt8Hg+OfdSI39y5LQmyBsr/qlZ98SHAkInrd0f0fHJwDfLW9?=
 =?us-ascii?Q?w5FASo4TR/CmPoAdDA6TTEGOznrr5MW4ONpfxeYlgjDzR9ibBaOMrcMa1oEq?=
 =?us-ascii?Q?TQmxN9AkT2EptyEsdihZXytDzm2FOB0QLItmeFmOg3ROOLHtKGBaSSrsVrsl?=
 =?us-ascii?Q?qsxtup63krprZiAN+Rp8wHHaSDhTJB5OJtCk9B6qPYUrmV8/LFwNCVTbd1xd?=
 =?us-ascii?Q?EqjL6OAf7wHUukZMdktlo2TOdcSkq9RHUK1EUtlrxQ+jQYnIbJqGsqFN7YRm?=
 =?us-ascii?Q?94f+bMe+1oIALoEgN0M22w+qonRP4vwtUisPL0EG+Tv/0SnBbwXssGPEpS3P?=
 =?us-ascii?Q?K6dEIlCdGQpfvlhhLDcQcPmR5fdxDilnGBqYhMgbsfyuBxGAkfY9iP1SZa+E?=
 =?us-ascii?Q?LP+NC2Ojb0Oq6g9cLr8cPyhQ5hhujPTSLnJoacX6GsQ/eK+vhGcuQmMJ6Tzi?=
 =?us-ascii?Q?a8kLfLcdsvf2QgTKaubmnlc+HWZ7DBzeFcr3XhzYrhvTchtHKOeFjHrK6914?=
 =?us-ascii?Q?3BmWd/0h+OIihAv9pq/4UbZfGeO0XwWFGHhMAQkD3+K3/Y6Wk1bCWDyAQwXw?=
 =?us-ascii?Q?SogO+PHSANF2v9iW8fN8XPnwLQ=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2021 01:56:03.1430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 45eedc68-2b1a-40d2-b408-08d8b441b861
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ZaHjJNxiz7IwzWdxKDU2n/MvU5UROd3gYLLg0ryiPYULcymPE13b67KFbrta5Z5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2456
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-08_12:2021-01-07,2021-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 spamscore=0 suspectscore=0 phishscore=0
 malwarescore=0 clxscore=1015 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101090010
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 01:02:22PM -0800, Stanislav Fomichev wrote:
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
> index c41bb2f34013..a9aad9c419e1 100644
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
> @@ -1390,13 +1410,30 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>  		 */
>  		if (ctx.optlen != 0) {
When ctx.optlen == 0, is sockopt_free_buf() called?
Did I miss something?

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
> +
> +				if (!p) {
> +					ret = -ENOMEM;
> +					goto out;
> +				}
> +				memcpy(p, ctx.optval, ctx.optlen);
> +				*kernel_optval = p;
> +			} else {
> +				*kernel_optval = ctx.optval;
> +			}
>  		}
>  	}
>  
>  out:
>  	if (ret)
> -		sockopt_free_buf(&ctx);
> +		sockopt_free_buf(&ctx, &buf);
>  	return ret;
>  }
>  
