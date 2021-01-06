Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98102EC427
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 20:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbhAFTtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 14:49:05 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13564 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726612AbhAFTtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 14:49:04 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 106JitVN026832;
        Wed, 6 Jan 2021 11:48:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=V5rfnqUwxgbMjKAX+Xx8rCTMMVrmZztBu76kaPD7rQs=;
 b=YpghjUgRCwGlti2/XA28ifBd8b1u4fl2YdWfqhKAx537K5ry0cAn30EPiOoALVHKncNi
 7QYVbqDuEcdVuURNYyY5kEdlLjetFoVbmep9OVVz/F7STGbmUbb/v5K6p55OI7IoowNC
 71h8VfbtQUs9fAUH+jko6rlAVm36+LiXvK0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35w5dvv0pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 Jan 2021 11:48:06 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 6 Jan 2021 11:48:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kg3GvFoub8FSfM5NZQ17lyyNO1b0WgUGeRBeKdv4BN+9gpC6ioDH4xYnuWqjxm2741t2a8ArGYkd4vOmBWYnbf8fQuDR09/kzbnox8o+p6GwHc2UhxnAPu3rIiyOcZKAayAI/r6Xnu/NWw2HCLd9rjrxuCUoVKqCsbGWoD1Q+xUnZGWfPSEu0V7+8tyLhb5MZA2PyyJdOXctxxp/V0X1rC6tzLJFiEq8pwn1+9ZBKX6q2AaFXSuNgtQmfj+84xG2yTL7jqNnqDz8cdXQ+qbEL8ZrQVv524axAQ4U40JkmAE8gD2RIUOeb9CAHFwE6JvpFB1xmnO+og5xKy5qclUjLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5rfnqUwxgbMjKAX+Xx8rCTMMVrmZztBu76kaPD7rQs=;
 b=dmOffCThg1h/lFbCxyEZMJJS1tBXUPPLtuCzflG1SqQZnsMy8/2zuywpnwmzYrzMCo1ZPVVA7XhpoeFErQS2rgZCpfabkZSLz+9YrXQf4el1DR5Sbm6BFDzeFxWdPA/iQbJ1+gk2i6Bm7EkF4f5Xb//EuNJIkNDnKulTbazcR0WO2skuJ2HyMAARf9ZoB9q3xH7eyhpPygm6uXnt9O95NTJQicA/UkZ/nNsCLcuYBAEyHTKk72B5JUTCjb/48gZPGqDo45Kmbj034kkg48h6Lsbj+7eq9pq923Y8v+xffh3rSHkjqBS+BBkhO2nXHFVu1ZDaJ9sozFTPIaZGyimBOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5rfnqUwxgbMjKAX+Xx8rCTMMVrmZztBu76kaPD7rQs=;
 b=Ko5rN0FdLrv6jhfG+iGRpFhfX2ysGC9DMA40GwSQGZn4LmvIvGqBT6YRENaCQP3O+BwmXzEl8YLvkS+K/YpxapSr+FbQivrZsm/UKUa08DTw93Dxr1cUHfcPyXFjtNHR0l5UowmPmxOcUC2H4EN4UChFwikEa7lJBDRLDnN5iyo=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2696.namprd15.prod.outlook.com (2603:10b6:a03:156::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Wed, 6 Jan
 2021 19:48:03 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7%7]) with mapi id 15.20.3721.024; Wed, 6 Jan 2021
 19:48:03 +0000
Date:   Wed, 6 Jan 2021 11:47:56 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, Song Liu <songliubraving@fb.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH bpf-next v3 3/3] bpf: remove extra lock_sock for
 TCP_ZEROCOPY_RECEIVE
Message-ID: <20210106194756.vjkulozifc4bfuut@kafai-mbp.dhcp.thefacebook.com>
References: <20210105214350.138053-1-sdf@google.com>
 <20210105214350.138053-4-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105214350.138053-4-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:8a1b]
X-ClientProxiedBy: CO2PR04CA0168.namprd04.prod.outlook.com
 (2603:10b6:104:4::22) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:8a1b) by CO2PR04CA0168.namprd04.prod.outlook.com (2603:10b6:104:4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 19:48:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2788e164-9d89-4961-0949-08d8b27bfb32
X-MS-TrafficTypeDiagnostic: BYAPR15MB2696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB269627535A73A289E4DA5730D5D00@BYAPR15MB2696.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HIaBi1hTCT4n1uqA0+V6XeCq3gxyXqypRQN28WpXqVMHRN6foOcj5wWsNWEMjQqt2/o2JL6O45SGX9rbvrDXmhEbeXtBLqnejjl1fGFb0jbZkXpo4+tbi5llVdZuX4lReJ8X+lZDmR/B6XLxS8QCq1TY+GkS7BxBL6wK6CfEUtJsIAfIoKf15WGUckHopIx6Yhf00lSI4Akw6UuiVuSo6MyjpmfxBZdlYiviLO92d+qEPJMa1otM7NQbravMCbl9v9a576HOlQb4DZpFsFgEMKxr0zEUsJErrWQXpmDbhoulSj0B0fkOkuraoiGuDCxPgNBwN/8YSmDchN1rLaK86yXxo+hCnsPNlolsFun6Pa3vSV68OJaTMmcYjQojA5DbHkrxAUGZ9NwBnJSqb1CA6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(39860400002)(346002)(366004)(7696005)(86362001)(8936002)(83380400001)(2906002)(8676002)(6666004)(54906003)(478600001)(4326008)(186003)(16526019)(66946007)(6916009)(52116002)(316002)(5660300002)(1076003)(66476007)(66556008)(55016002)(6506007)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/de09YXOQvAQvR2FNkxZtB0G5kwR2IjtdxY4lfzvnoueAWyyDAoFe/wr4DTY?=
 =?us-ascii?Q?SpwKD0oRIxUJfkkMCQIyLu36pvz/PtNlqC6RtcUmZFPVjJnTlZxxSCfjl5Lj?=
 =?us-ascii?Q?IW7xMpME0ErR7IkkeQgelGQuSaAWMT093YtmQHqU5huISYrvvX0I0M3PJRXN?=
 =?us-ascii?Q?3dtW7EBi6BQkckQlKc36aAxQzd9yh1VJ+NrRWwnec7FnoIbjKy94tjFVGfhN?=
 =?us-ascii?Q?iRkQqP6sEHNTaM0LcJjAR4eg4CeEdSvFzJ7uqugLn93DLnTr39ndiY8tPFSi?=
 =?us-ascii?Q?uVZiW14jMhgSazrj6+pfxF5EnhmgzdiSg7gny66odaj0QEZHOER9Qq3PZ+7j?=
 =?us-ascii?Q?fJywvL7OkthmwTQO5wG+lIwhlMex9ffHNvRlcnp3SuueYc/Qx13X8XrsRA7C?=
 =?us-ascii?Q?nXJBrs4ofaPu2QZ0cPTKDwizyon3x+wJv2bqm/yWi3y/uJnGvFaEPFTdDz1p?=
 =?us-ascii?Q?y04GbZeULHHAWGz/YL4IJ0FknSH+rdfUKSaAysoFXKXsJ1ZmGKd27gJegv/S?=
 =?us-ascii?Q?JTmnTQnjUr+bU9ELI7sUQT7Mgh7WttHPhhkvpz1AEYnp6N+zzAQHAdeCMltL?=
 =?us-ascii?Q?NjWr1+ML7rOP3ihHdzFVCLSrB92EDPdW1ijZC/vCGeD3Vb/RI6xHmJ3d80OA?=
 =?us-ascii?Q?Ty+C71t9qeS4sEA4I+eHS+oRy8a1Uk3WWp0z2gjlOcl7+l1LySXmmyas7Igw?=
 =?us-ascii?Q?I+qIO7bgOREbdmYp7+59KoRO6H8JW9xXfyDZ4VjzeOQXDCknRvtuGWJk1e/N?=
 =?us-ascii?Q?UGDBMdlb7UT+xsvpz8K9x8LTjGvdUskzTRRnqme8PlJUEhkr7vVjJ+uaklpK?=
 =?us-ascii?Q?JNJnlxLEjZmwsSy9mbEqgf/A8/jhw1qBrWcE9cgmcc4RdpF36mysN7CpEzkF?=
 =?us-ascii?Q?1aA9WOsLtNQQzMn9fef4WsfTAKTDrHtJWgUJnbFvUSw0cT+2oSXGcXhho052?=
 =?us-ascii?Q?yf8iKIX6xXmkAHhZiVRr0Wu0MFjq/jQcgs0ZlJYTypyzX4mWfmLLs6cEh02A?=
 =?us-ascii?Q?fVvRgTepXBqaL4iLcsNaIRmlWA=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 19:48:03.6957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 2788e164-9d89-4961-0949-08d8b27bfb32
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /uhgnnoPdQjZX7Gm/1/FgZLS7EX3uktT5UTZaxjof5FusWroGU2XNC4GMlaG3uJ7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2696
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-06_11:2021-01-06,2021-01-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=754 spamscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060111
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 01:43:50PM -0800, Stanislav Fomichev wrote:
> Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
> We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> call in do_tcp_getsockopt using the on-stack data. This removes
> 3% overhead for locking/unlocking the socket.
> 
> Also:
> - Removed BUILD_BUG_ON (zerocopy doesn't depend on the buf size anymore)
> - Separated on-stack buffer into bpf_sockopt_buf and downsized to 32 bytes
>   (let's keep it to help with the other options)
> 
> (I can probably split this patch into two: add new features and rework
>  bpf_sockopt_buf; can follow up if the approach in general sounds
>  good).
> 
> Without this patch:
>      3.29%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
>             |
>              --3.22%--__cgroup_bpf_run_filter_getsockopt
>                        |
>                        |--0.66%--lock_sock_nested
A general question for sockopt prog, why the BPF_CGROUP_(GET|SET)SOCKOPT prog
has to run under lock_sock()?

>                        |
>                        |--0.57%--__might_fault
>                        |
>                         --0.56%--release_sock
> 
> With the patch applied:
>      0.42%     0.10%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern
>      0.02%     0.02%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
> 
[ ... ]

> @@ -1445,15 +1442,29 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
>  				       int __user *optlen, int max_optlen,
>  				       int retval)
>  {
> -	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> -	struct bpf_sockopt_kern ctx = {
> -		.sk = sk,
> -		.level = level,
> -		.optname = optname,
> -		.retval = retval,
> -	};
> +	struct bpf_sockopt_kern ctx;
> +	struct bpf_sockopt_buf buf;
> +	struct cgroup *cgrp;
>  	int ret;
>  
> +#ifdef CONFIG_INET
> +	/* TCP do_tcp_getsockopt has optimized getsockopt implementation
> +	 * to avoid extra socket lock for TCP_ZEROCOPY_RECEIVE.
> +	 */
> +	if (sk->sk_prot->getsockopt == tcp_getsockopt &&
> +	    level == SOL_TCP && optname == TCP_ZEROCOPY_RECEIVE)
> +		return retval;
> +#endif
That seems too much protocol details and not very scalable.
It is not very related to kernel/bpf/cgroup.c which has very little idea
whether a specific protocol has optimized things in some ways (e.g. by
directly calling cgroup's bpf prog at some strategic places in this patch).
Lets see if it can be done better.

At least, these protocol checks belong to the net's socket.c
more than the bpf's cgroup.c here.  If it also looks like layering
breakage in socket.c, may be adding a signal in sk_prot (for example)
to tell if the sk_prot->getsockopt has already called the cgroup's bpf
prog?  (e.g. tcp_getsockopt() can directly call the cgroup's bpf for all
optname instead of only TCP_ZEROCOPY_RECEIVE).

For example:

int __sys_getsockopt(...)
{
	/* ... */

	if (!sk_prot->bpf_getsockopt_handled)
		BPF_CGROUP_RUN_PROG_GETSOCKOPT(...);
}

Thoughts?

> +
> +	memset(&buf, 0, sizeof(buf));
> +	memset(&ctx, 0, sizeof(ctx));
> +
> +	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> +	ctx.sk = sk;
> +	ctx.level = level;
> +	ctx.optname = optname;
> +	ctx.retval = retval;
> +
>  	/* Opportunistic check to see whether we have any BPF program
>  	 * attached to the hook so we don't waste time allocating
>  	 * memory and locking the socket.
