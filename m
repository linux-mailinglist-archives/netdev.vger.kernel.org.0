Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE682EFCC5
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 02:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbhAIBis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 20:38:48 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57270 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725836AbhAIBis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 20:38:48 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1091ZO2R020090;
        Fri, 8 Jan 2021 17:37:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=5OzQgLEkh0bXfFg7obdFkc8jk/24M16YYJZIjkKiYiU=;
 b=o2bMG0MUVh6VGvM2OKWy4ESrUUnpE5DcRvgRE5v2uPEancnBi2b6ttrkt8+BJuHLSoGb
 mB56CNgy4foyguoTkx/BPvYXKZJKlQuphHT8DMu5dEnYKqofq0K4xovMyK5tErXv4mB4
 pO/YCxfP1gsLfxn4IhCsYRf/CJKSHprcVJ4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35y0afgmcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 Jan 2021 17:37:48 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 8 Jan 2021 17:37:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=geFT/WsfQ6kKTRRyLmMmWxwihRIoSnq9Sqms+Jw18sgAi0XTXVAPRRgXaBl6eP5Q6WVgIzgHbOJ4lQOlosGRUNjda2zWO2K68JZneUq7KC/LPEko+PKd8Szigs5600jN7B/VPCC8doLz8Uuj5DKJu5V2+M5/yG100F6hUrjWqqind5D0o3w8OjddPYcODiGML8iUYDPifSxjKhDokXJTuqyzOEWu5iXYAsrvooU7Uno5YOt2SzYT+IbFj592k6N0fMVDHSDbYExGU/mjHLRP2GC91EHhZt3qt1Bj6jU+zHXUTO9jYWXVjPBlAQWpw0v4IUWBWitL82JBB3tHrfgV3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OzQgLEkh0bXfFg7obdFkc8jk/24M16YYJZIjkKiYiU=;
 b=DOQEwkKYcFDyhQaQT4l2xzPPFu1aQ5UcN1pTpvXOP75IshCttwLQDTPLw/lSeKComv4AAXEEaIqSnyPypnU+HYAMoymn4akZe+7JvuH79A2ZYXugRMgi6t52IoUzdD0dYPYyqWr9YwKsM6diiHi7YMtCXniJJi1efHlswuGq0iZpcwjOM3wESqddx81HjyxpcYjZ1Mxad1dQaso/4SiLLHw85uvdeplISrT1csNG7ddTSkomCMb/4gJp0QbGzK+2wAXasYhtEncdi5O/T11BNh+rHssdatyaLQG28ksnGRhJvDwgFsVPS4RoA6WKCX95my5thvNUOYz5BmGOyx5GXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OzQgLEkh0bXfFg7obdFkc8jk/24M16YYJZIjkKiYiU=;
 b=Wde59ja3YBpcFw/j5Pg9gpeHtYhNI01eqVOpWE7gWHlbH7RIG4IIFFQTDUnvCJj4vwroLwpeFYc9JDJoy3cAHqd5rjrpAKlre1I9nKsN+KRPUgzV2eHqyfSsnsjpWEUeQrMFf+M0c9myBQtWM1gAtaXdjdwMeOvgPvzefXWjB+U=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3666.namprd15.prod.outlook.com (2603:10b6:a03:1fc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.11; Sat, 9 Jan
 2021 01:37:46 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7%7]) with mapi id 15.20.3721.024; Sat, 9 Jan 2021
 01:37:46 +0000
Date:   Fri, 8 Jan 2021 17:37:39 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, Song Liu <songliubraving@fb.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH bpf-next v6 1/3] bpf: remove extra lock_sock for
 TCP_ZEROCOPY_RECEIVE
Message-ID: <20210109013739.vbqm4gllpo7g5xro@kafai-mbp.dhcp.thefacebook.com>
References: <20210108210223.972802-1-sdf@google.com>
 <20210108210223.972802-2-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108210223.972802-2-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:47b0]
X-ClientProxiedBy: MW4PR04CA0081.namprd04.prod.outlook.com
 (2603:10b6:303:6b::26) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:47b0) by MW4PR04CA0081.namprd04.prod.outlook.com (2603:10b6:303:6b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Sat, 9 Jan 2021 01:37:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d1c7bdc-1fe9-4688-1819-08d8b43f2a95
X-MS-TrafficTypeDiagnostic: BY5PR15MB3666:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB36663503998DD47D65BE3AADD5AD0@BY5PR15MB3666.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ugpdj5D/RlI2MHal6B7uro+tGPoclo2wUE9n0hBtFy4UbL+oYivQ81b2yuCxehz3x5yu3TjVap0i7cCbXE9Vj0xSg9Iso8TOAqQBQBjJvLQ3ihbqYzHI/TUDg83q9leu3xYDfGTFFNu3+RLc1QSyBvchNCWukaPps2n0Hs6iBHURHXnRT4YYZqBccG+owOxpPJmnFek7jH0Y9AouVkDrRkveUklQ74wmyumVaTFxDxYC4ejy6O3Z9sqM0XCvRMjTRO0jukEmJqU/Q0NiooS7UFr9K8nrl3go1ZYU2GUulmN1OyU1Ex1wPmuwV240cf490e6nkJHUD3cr7MX8b+xJen3xXjy3RjuFOae/oKGU1wlxkrjA+gSPEA+mBLA7S2LqoJgFsnckCocZT5d7ExtAZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(136003)(39860400002)(346002)(55016002)(9686003)(66946007)(8676002)(66476007)(66556008)(2906002)(8936002)(16526019)(83380400001)(54906003)(186003)(316002)(6506007)(86362001)(6666004)(7696005)(5660300002)(52116002)(6916009)(4326008)(478600001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?b/BOJX3X/fth4qxcVRmPGJ47uFGqvwz2tr4m/H+zsi+FCYuPDpiW+fiNXTRl?=
 =?us-ascii?Q?QazkLKJOna6MKrG+4Wovjzx7FfYC3o2P1Xa157rYtPZw0yV2QvaWUB+Kx3Cc?=
 =?us-ascii?Q?O/KN5O35Vw4DEODZ8+RfZ/0CR/oNBwrfAx4G3kWXZWj/R+6NNTZPUy13vE6d?=
 =?us-ascii?Q?JBVqcl9f+NR8/0zQwoaXfqI3DNROXxbEUFkcSeNB4uwWwxhWLoz8/vULIMkx?=
 =?us-ascii?Q?t7tDxRPNZ5N+z1NbLih8Y7g6V10nNtTzJchEcP0JPowNw8GZA3jmmssMmezb?=
 =?us-ascii?Q?ddX940dIYFdCLyLe1kMU2/aF3C8kHEK4BUSwEVYz/MVYbXY22p5X2Sb6S3ND?=
 =?us-ascii?Q?NMAowaaIpLTySgIdm0v7MpfMhOlkvi7f3ILsBvcAk3cvyYG8YG9LpPHrkJhe?=
 =?us-ascii?Q?8c567EiULNUAeIdoKkMOVX2zmSuN//HOdFtqrWRDs08WvKNvf2+Ubc/zhf5A?=
 =?us-ascii?Q?ZwLd18Xmh3oxUI7CNx/N07W8Pw04kBhfJHuXRVQmU79Z3oZW2W19ismIvOaT?=
 =?us-ascii?Q?JxfbtC9BOLuTPaOuAGoxmY0UyR1NSti41Q9zEPFT8zlEoV3jgv1QEZ/E5v6X?=
 =?us-ascii?Q?lkpYl278Fb5yG2hABJ4H66PL1CQfoOS5qLTYl1M9+9ps1f1nCPDZkDH6KoQX?=
 =?us-ascii?Q?fOuUdKEwVqBKvg22AQLyFN4lL6W1OiVBVS+JPT8PPGlOpqCp2jiCSQToX1GL?=
 =?us-ascii?Q?tALOqRB9qaphExeglrV2URIo491Z82A3OQeuoGV3pjoKD3GFCfNN1smrSlKm?=
 =?us-ascii?Q?8kul/2DdmaokiX+cV/kWFpJVGdf8jvZPtMSR9W0gFVNl2BRyJNvLqVu80R7u?=
 =?us-ascii?Q?5aBzXc8iJk5Vv2DKPyun6SKs9VWpMo17fRgLIuzSeCMxvDcGVLFuVsudhQNp?=
 =?us-ascii?Q?T8gK7qyE71yFx0O0kpARp/Isrys9JQHHOBkNzAURJd2EWPRLMOBwxMg0MsuC?=
 =?us-ascii?Q?KdEnOV/yYdhhlnsEaUDYDVshG8Dp9CVqBH5hcXMzzoGzVTf8XsSm3pDKcnjL?=
 =?us-ascii?Q?D6ut3lq32XJO0GPyKUssk6xHVA=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2021 01:37:46.2119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d1c7bdc-1fe9-4688-1819-08d8b43f2a95
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vuqMrxDZicAu7Gtafo50fHbcgpMNgOAUHwwGNirXOwl1pvH18/Jj0joF62B4aWao
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3666
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-08_12:2021-01-07,2021-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 spamscore=0 suspectscore=0 phishscore=0
 malwarescore=0 clxscore=1015 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101090008
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 01:02:21PM -0800, Stanislav Fomichev wrote:
> Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
> We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> call in do_tcp_getsockopt using the on-stack data. This removes
> 3% overhead for locking/unlocking the socket.
> 
> Without this patch:
>      3.38%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
>             |
>              --3.30%--__cgroup_bpf_run_filter_getsockopt
>                        |
>                         --0.81%--__kmalloc
> 
> With the patch applied:
>      0.52%     0.12%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Eric Dumazet <edumazet@google.com>
> ---
>  include/linux/bpf-cgroup.h                    | 27 +++++++++++--
>  include/linux/indirect_call_wrapper.h         |  6 +++
>  include/net/sock.h                            |  2 +
>  include/net/tcp.h                             |  1 +
>  kernel/bpf/cgroup.c                           | 38 +++++++++++++++++++
>  net/ipv4/tcp.c                                | 14 +++++++
>  net/ipv4/tcp_ipv4.c                           |  1 +
>  net/ipv6/tcp_ipv6.c                           |  1 +
>  net/socket.c                                  |  3 ++
>  .../selftests/bpf/prog_tests/sockopt_sk.c     | 22 +++++++++++
>  .../testing/selftests/bpf/progs/sockopt_sk.c  | 15 ++++++++
>  11 files changed, 126 insertions(+), 4 deletions(-)
> 
[ ... ]

> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 6ec088a96302..c41bb2f34013 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1485,6 +1485,44 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
>  	sockopt_free_buf(&ctx);
>  	return ret;
>  }
> +
> +int __cgroup_bpf_run_filter_getsockopt_kern(struct sock *sk, int level,
> +					    int optname, void *optval,
> +					    int *optlen, int retval)
> +{
> +	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> +	struct bpf_sockopt_kern ctx = {
> +		.sk = sk,
> +		.level = level,
> +		.optname = optname,
> +		.retval = retval,
> +		.optlen = *optlen,
> +		.optval = optval,
> +		.optval_end = optval + *optlen,
> +	};
> +	int ret;
> +
The current behavior only passes kernel optval to bpf prog when
retval == 0.  Can you explain a few words here about
the difference and why it is fine?
Just in case some other options may want to reuse the
__cgroup_bpf_run_filter_getsockopt_kern() in the future.

> +	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[BPF_CGROUP_GETSOCKOPT],
> +				 &ctx, BPF_PROG_RUN);
> +	if (!ret)
> +		return -EPERM;
> +
> +	if (ctx.optlen > *optlen)
> +		return -EFAULT;
> +
> +	/* BPF programs only allowed to set retval to 0, not some
> +	 * arbitrary value.
> +	 */
> +	if (ctx.retval != 0 && ctx.retval != retval)
> +		return -EFAULT;
> +
> +	/* BPF programs can shrink the buffer, export the modifications.
> +	 */
> +	if (ctx.optlen != 0)
> +		*optlen = ctx.optlen;
> +
> +	return ctx.retval;
> +}
>  #endif
>  
>  static ssize_t sysctl_cpy_dir(const struct ctl_dir *dir, char **bufp,

[ ... ]

> diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
> index b25c9c45c148..6bb18b1d8578 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
> @@ -11,6 +11,7 @@ static int getsetsockopt(void)
>  		char u8[4];
>  		__u32 u32;
>  		char cc[16]; /* TCP_CA_NAME_MAX */
> +		struct tcp_zerocopy_receive zc;
I suspect it won't compile at least in my setup.

However, I compile tools/testing/selftests/net/tcp_mmap.c fine though.
I _guess_ it is because the net's test has included kernel/usr/include.

AFAIK, bpf's tests use tools/include/uapi/.

Others LGTM.
