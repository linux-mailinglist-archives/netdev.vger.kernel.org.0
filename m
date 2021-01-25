Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A5730301A
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732754AbhAYX0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:26:50 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7714 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732645AbhAYX0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 18:26:16 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10PNLLp0027426;
        Mon, 25 Jan 2021 15:25:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=rp+ID/k3DvSiIwHzMKXrP1ImUvnYEOl3Ufb3GjZ42zg=;
 b=b1lPVnzq8O0pT+zYy8dTbzHamKWy11WHONZm8w0XwDySbbS/OuJk6jw6Ex5HheCGZHVO
 QuzdO6pgIA3jTG5+36LSKS9lYBMcY7IuiCijealo2BAvVDOkGWbQA/ktCoxniGdzEmlU
 HNIl1QvqLwI8YCBOjYbaCvhUd/ULC699uLo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3694qurnvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 25 Jan 2021 15:25:10 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 25 Jan 2021 15:25:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZT7lWL7aw/SSOAmTJiaXSdXHM9/HGCiRxfDJfKZkr16DzTaDJFmhXSAFtk3/VgrklC6IU+lH0mPN86TYUeOh3hXoiJ6n1nEVnPNmm4/tpLXWVOM8/h97VeC6M7ShmNTM8gLRnDKki690Q+VkEotlg2y69pk2KN0ykbaIK4v4C9uh/ivSbzwO21CaT7/UBqlOOotUjHQhN/DmY7pJt6lR/lgX/3Ip7/p45sy/lRrBeob+r1Y1fJwHa0Rm2jlDDTR6obRs3bdr4GOAWNo5dRoajPFUfnSvM34/IGI9OOEE9mAQUtwiV0bKHcntFopWp6Gju5RuSFWYnPbC838Z++3BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rp+ID/k3DvSiIwHzMKXrP1ImUvnYEOl3Ufb3GjZ42zg=;
 b=FCtEsofOkrBiHfTC3g+7DoD8V3VzF+46fgPig4hPRXtskbCaubXPbySpQNau0VtqBQ8OLsVZ3GZztRJZU83JLEJS2fAShP3RC5FSAdKT6spGvrg8MVKR7DsVWt2TSXS9oJv+32hjjq/1Gi+4uhBNXRmyXKbhtJN1B2Ov61WsA9qX36cXpRQWkRgMyry8wjWbpVd6MFZLnmQdW7yPozAwBSt1/c5MJsi//FSTHz3QdGWTdlZ4fJEAMLpgFNjEDdv+Ko2/CUsAyg1gvPShErhIHZhD3R0fDlc2nXWMrvWwehGfaGSLI5YbvHipSV/wgBpd15RvRne3Z5AULKeeED+/NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rp+ID/k3DvSiIwHzMKXrP1ImUvnYEOl3Ufb3GjZ42zg=;
 b=KFBkApMAuFkb+60bv8Q0rD/kxbOST38OiPVr/762Fhrt49rjfswUw/+aZ5M1z4c6am5WMLDGfjsYWuIOhkjYb3ZNdZZmeA8swXxC+Os5uduW0iis6Ag3ScmhMEXMc05FeFyNJZ6EJiY398DLiUlwNYGt2Y5ZB+yzNiIXarAYPtQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3716.namprd15.prod.outlook.com (2603:10b6:a03:1b4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Mon, 25 Jan
 2021 23:25:07 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66%3]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 23:25:07 +0000
Date:   Mon, 25 Jan 2021 15:25:00 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v2 1/2] bpf: allow rewriting to ports under
 ip_unprivileged_port_start
Message-ID: <20210125232500.fmb4trbady6jfdfp@kafai-mbp>
References: <20210125172641.3008234-1-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125172641.3008234-1-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:4fac]
X-ClientProxiedBy: MWHPR22CA0050.namprd22.prod.outlook.com
 (2603:10b6:300:12a::12) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:4fac) by MWHPR22CA0050.namprd22.prod.outlook.com (2603:10b6:300:12a::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Mon, 25 Jan 2021 23:25:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d28fc547-ec35-40cd-9e71-08d8c18873b2
X-MS-TrafficTypeDiagnostic: BY5PR15MB3716:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3716C1BD3641B93AF7AFE4A5D5BD9@BY5PR15MB3716.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /3EbEFCHTPSmt9snCKCDYY/GKSp8SygrAB4EjUsgBXH3mdX5kM67sUv+8YU0apdj6MnhOMF2aPbR4qd0iC3ykuv8VAr9hWTIPrTvVRAJ+7lc19QwpYT0kDpoxjT2+0VYwmH0aBR33phE7NZ5WGCwsR3ixWMpTDchk1DIs/jU28Xxh3iMQgaRKtud/dY4PRLRY/B9WJcC4DD05vbawwC1vIHtJGs3PTjTIahE6wxdsM0LZ0CPjtRM/k2pd6qT3DM/HXULEfGd6aJfAux7eZumS8CHYJJsfsGCK36k9naz1ePavd1MEFaIXQb5Gte03Ofx3noFThHhUd4zmd4mCQCUV6kWiiskw8TfgG3hKy4GrVFohACjU1AXl6OxF7t7BYURf5ukoTRNmBjPTjkEZ1nIcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(39860400002)(346002)(1076003)(16526019)(33716001)(4326008)(6666004)(186003)(66476007)(66556008)(66946007)(52116002)(86362001)(55016002)(83380400001)(5660300002)(316002)(478600001)(8936002)(6916009)(2906002)(6496006)(9686003)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2WrOsYSZeDuy7ER6kHjrh3JpoqnS1MkFdVv22HxUXEHIjya89wOs9iqHNaHN?=
 =?us-ascii?Q?DnI7WFQ8LywyQdhon1VTEPEvaEEcqn+UhOBQFA8sHlUniduDBaQcUIMIB2T5?=
 =?us-ascii?Q?dX753bogMFvfAU1aQc22GSF8UDRTUp+BlwnQ4HNBRhQCD38x7wmPVFX3SrZK?=
 =?us-ascii?Q?Cm9LUAd/puXwNpuwN2ZeHGnTQuyAtHEK7GKBH5CbUgPnfiIx0AdJqzZUCCJe?=
 =?us-ascii?Q?MLg2vQI+mb32uOzZE6O67uJ+FBF7Zb6KBjnA1xzyKSh6emlEckdQxYI5Qv4E?=
 =?us-ascii?Q?cdptshLX453IaWCl5y9Nu8JPM7VXtQI062W6sFnpXjXoLSVqVEw9bhVnojBd?=
 =?us-ascii?Q?N/ZE+nrOxfW0od/khCxAVcP9L4vrMtJIWPJDETgNJLZDhB4R+GnX5mDngMz8?=
 =?us-ascii?Q?+EADRIG/fc8mI6s/EJ5GSD9wJ73ustDGkYYzxGk4VCTXlqTVhCYDXCwuwbFW?=
 =?us-ascii?Q?iCu70DRdUKK20AgHBAL2kICROMJVu8l1hC3HrObjy6k9lNE6s4eUq/46MIev?=
 =?us-ascii?Q?tOnOQiS6CX15GuAyYGoWwSYWiZcyOyuhoRy3ERL3JSY89V6AoYmfthkzSvSz?=
 =?us-ascii?Q?odxu7cCDwD/TjJyhTE7gBj8aYKiFHdOLrC6P9+gRV7ZBzfLeuflDA+RtM/ID?=
 =?us-ascii?Q?An9maifnqnD6EUf9AmrTHHZEyrr/RHdAgUbZUjPK4kJb6knUJfafc5wZB06p?=
 =?us-ascii?Q?iqpf+7UiNgpMaDYq8s+YSSki0zuGSOQfDpaKCnrHTFYeaBh774g5N4+xA1ud?=
 =?us-ascii?Q?AQImo16/SL5tSVLCJNoI+sUNgWYKKpfsUM5pcH7SjGIOS7uJcSVU4kAg/sRt?=
 =?us-ascii?Q?mwz416VQGeoKZwf4IHCCM7C3feXH92jE2gFjiK2ZqFBGw1QuzYS4SMkA47Wm?=
 =?us-ascii?Q?nJ1cmTsOPb1cSGnIPo+YyCJNpQ65utHi7F0NqmkEl2cJN0E3avyimiyBt5bn?=
 =?us-ascii?Q?lPUjsi221aR9O614R8S8MAIZyfR+nhF7+zlyJNbWCQleqLMeprnwzOtm4c09?=
 =?us-ascii?Q?fuXB8ioId4c+KLg6Rf5HfzJl/ssVukr+RFUSYwq0nEevo9uZ+l1canY/1qAT?=
 =?us-ascii?Q?2pXF6GK7TXUq+rU+RFGtnLZmKdO1HceaUAdWznGh+esMwii4W/k=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d28fc547-ec35-40cd-9e71-08d8c18873b2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2021 23:25:07.6632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ksWP7R5yp/4pDP5SB8xKYsSYr0ITtAAqaAz4JRDoxdJzOUlN33caNbP8F4dqq4gI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3716
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-25_10:2021-01-25,2021-01-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101250118
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 09:26:40AM -0800, Stanislav Fomichev wrote:
> At the moment, BPF_CGROUP_INET{4,6}_BIND hooks can rewrite user_port
> to the privileged ones (< ip_unprivileged_port_start), but it will
> be rejected later on in the __inet_bind or __inet6_bind.
> 
> Let's export 'port_changed' event from the BPF program and bypass
> ip_unprivileged_port_start range check when we've seen that
> the program explicitly overrode the port. This is accomplished
> by generating instructions to set ctx->port_changed along with
> updating ctx->user_port.
The description requires an update.

[ ... ]

> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index da649f20d6b2..cdf3c7e611d9 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1055,6 +1055,8 @@ EXPORT_SYMBOL(__cgroup_bpf_run_filter_sk);
>   * @uaddr: sockaddr struct provided by user
>   * @type: The type of program to be exectuted
>   * @t_ctx: Pointer to attach type specific context
> + * @flags: Pointer to u32 which contains higher bits of BPF program
> + *         return value (OR'ed together).
>   *
>   * socket is expected to be of type INET or INET6.
>   *
> @@ -1064,7 +1066,8 @@ EXPORT_SYMBOL(__cgroup_bpf_run_filter_sk);
>  int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
>  				      struct sockaddr *uaddr,
>  				      enum bpf_attach_type type,
> -				      void *t_ctx)
> +				      void *t_ctx,
> +				      u32 *flags)
>  {
>  	struct bpf_sock_addr_kern ctx = {
>  		.sk = sk,
> @@ -1087,7 +1090,8 @@ int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
>  	}
>  
>  	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> -	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[type], &ctx, BPF_PROG_RUN);
> +	ret = BPF_PROG_RUN_ARRAY_FLAGS(cgrp->bpf.effective[type], &ctx,
> +				       BPF_PROG_RUN, flags);
>  
>  	return ret == 1 ? 0 : -EPERM;
>  }
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index d0eae51b31e4..ef7c3ca53214 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7986,6 +7986,11 @@ static int check_return_code(struct bpf_verifier_env *env)
>  		    env->prog->expected_attach_type == BPF_CGROUP_INET4_GETSOCKNAME ||
>  		    env->prog->expected_attach_type == BPF_CGROUP_INET6_GETSOCKNAME)
>  			range = tnum_range(1, 1);
> +		if (env->prog->expected_attach_type == BPF_CGROUP_INET4_BIND ||
> +		    env->prog->expected_attach_type == BPF_CGROUP_INET6_BIND) {
> +			range = tnum_range(0, 3);
> +			enforce_attach_type_range = tnum_range(0, 3);
It should be:
			enforce_attach_type_range = tnum_range(2, 3);
