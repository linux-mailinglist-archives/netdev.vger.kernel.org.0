Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9616E2F22D4
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 23:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390515AbhAKWc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 17:32:56 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15756 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390130AbhAKWcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 17:32:54 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BMS6s4009648;
        Mon, 11 Jan 2021 14:31:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=4u92JsJLa8F+3yT60J1p3oM/A0HWN/P1BoMeed8LaSc=;
 b=Ki+piEBi/1gL1YEiOZHCUx5Rm2shiVyk25WcgoL16sgNUfYVGHQ/p1vlgme2SG2avkBb
 LqaIxL2Rauqzjp+s26iWPfwH+KUEvUHK7YCz6Lyg4wg7l6xrf2O/lLjO9q5ki2z8sYhS
 Hc/vPPliAznUY9L1nOU4O3u/TsuluVbgDoI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35yweb7dx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 14:31:58 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 14:31:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5ceJ/ugMR1kBkdCW0PkJJZjv2lKX02Wi++30d5XqQKjr0ufM5F7rjtLXBs4tXAtCOG9iIgFghyWfLDrO+tz2kBA7H5gF8/V+cZGAcwtnhBwCT/J/fQyARIiAhxGGP4bjsR/GdboJu+uJTGK7YpmBJ9/2cq/jx8LETvK0nq6VesWH/VEo6LGkDsqZbpmY9GGZqyUUAWpAwcAvW6IsQ7EkSvo/ovfsisEVuHMC8jyt/wb/94gRtT7o6jUcSFrWJKppP4O7rrkc97zvBZJqUXQDVw+cUwJjKl4pv8lkbgSA4O1Jnci9M4mpBfi632sYaU2P/Pb/z4u0u9MjQgCFmdytw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4u92JsJLa8F+3yT60J1p3oM/A0HWN/P1BoMeed8LaSc=;
 b=I/+sZIaWbn0/Qcafiau33yEo2GRQ+N2AgUr20kzFQX1OEZy+grbnFJQh50LYZt29niublthZQfY9heTdYasi/PIUBxgmI6Symm0Pkv5mPneUZmPbaNZjxTZeLcYWqKUmsVHxMu7d+1lUTqN4rL4R7O4GJMP1Wc8ukJ+wT9IdaQ/XmZkkgQ2eP7EPwPYvCEcWfKjsX/hn8U6tyUntVob0c8oxjKc3s/CuUKNieD7fWDIZa7IQ+V9dFAiIrA36os/D5bnMVywSgfckr5Jh7iHa2DPzUuKDqD7K/QTqS3drebwGtrmUqKSW9e4mKm6b4QB9HTdfK/rYNPd22i7RHAiO1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4u92JsJLa8F+3yT60J1p3oM/A0HWN/P1BoMeed8LaSc=;
 b=D6+Qt9+gAWk9WDQtEha4yfR56LsW5TKmT6YQhjF+qAXcV+zaCq6AnFoIHEcPaar+lZlZhF+cs2MloGQNE90n0FTg474/vemirpwAIWgvBAemzQRP3NoHa0bCUpx4+obds/R3ZGGcYlYusc9aTtJ2OG5eX5Ab4TrT7ZI4v9197vc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3254.namprd15.prod.outlook.com (2603:10b6:a03:110::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.10; Mon, 11 Jan
 2021 22:31:55 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66%3]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 22:31:55 +0000
Date:   Mon, 11 Jan 2021 14:31:47 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>
Subject: Re: [PATCH bpf] bpf: don't leak memory in bpf getsockopt when optlen
 == 0
Message-ID: <20210111223147.crc56dz52j342wlb@kafai-mbp.dhcp.thefacebook.com>
References: <20210111194738.132139-1-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111194738.132139-1-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:e2df]
X-ClientProxiedBy: MW4PR04CA0213.namprd04.prod.outlook.com
 (2603:10b6:303:87::8) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:e2df) by MW4PR04CA0213.namprd04.prod.outlook.com (2603:10b6:303:87::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 22:31:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63ec3367-37a2-4ea7-ddb7-08d8b680b345
X-MS-TrafficTypeDiagnostic: BYAPR15MB3254:
X-Microsoft-Antispam-PRVS: <BYAPR15MB32548254AE00BA9D8A268174D5AB0@BYAPR15MB3254.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DWiTrER+2FJ9dM9U47v2V+7bWAFG+JUthKop7dXxuht5FoBDhidibH9XWLPWodVu4d/LV1J4qf9MODoqXt9GOU5P5TNwTjhqR5rQ7TlOtZyIzZuD0NrBgTEvlRPYjEo8WKR6GyuIKdVTpxpPun1FH2kUiXpLhK7mo2wA4UDLtE+V5RIVEcU38Mpqx4g01WtPDnR0il8wlrDsNlGaaOlkKEy2Zzj+316Sc0OfyLHqH1eOxqOJKBDz7Xh4Gez78nF96VnY06Gs1MCCE7sxtMXZT4TZFsM6Gxqv/HBc1Hz0LG++3PP/tneaRcD5ffm0d2uBS6fF+r59v97CBvzW+KIOfC+yYMGwGVljoeyNbuDi9kr/OfP0xRABAojeLPntkKDXvU5Yv9J5DGzvrbFytvlvHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(346002)(136003)(376002)(66476007)(8936002)(83380400001)(5660300002)(66556008)(6916009)(2906002)(16526019)(1076003)(8676002)(52116002)(86362001)(316002)(66946007)(7696005)(6506007)(186003)(55016002)(6666004)(4326008)(9686003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iLBNDJc0P4Q/sGs+0oLA8JVL2GvLPjUYG9HBgVs55fB4zRSKWSRxD6IYnLHb?=
 =?us-ascii?Q?Atx97hhaSrZ4pWrUKaXfNlyb5/7lgIJ+ZHnTp/CFZualK/u/4xr9tKuWJLPl?=
 =?us-ascii?Q?2bD+GfNiU/TaAALoe9j4qwGo6d0i/NGb6e+6sOA0A39qN5eMBsdLSclW0qnz?=
 =?us-ascii?Q?JhQeeFzCUjmdyXYUEVSUWS4bqT8e1XchPnQZkZy42vMcBAfKmyQwK45ddeTK?=
 =?us-ascii?Q?9+iXGayaFEvFSqOyl4j/Hu4omP0+W8DZKkzIgUf9G8N/23cg28NNB5C2P/Y7?=
 =?us-ascii?Q?74tiRlSczBZCtO65YTPLBDSSoUFY4IGDUdnf+8lR0Ou1Nn5P2i/kXGQHlO5t?=
 =?us-ascii?Q?5s6W1DBden9xo51wrj2+b0bJWXLyhqnk3hTLbUs14yIM8r6jok4zEKeUjfhm?=
 =?us-ascii?Q?ve//QF0kAenPseGXxKCSXrWIUC9mOUD3fcFTDpAUp/3HD/YWwgN7yxv0Ld4Y?=
 =?us-ascii?Q?3ukxH2KULXytSnO8zsWhodokFlTY1WZYBrCR+3nN53mqVIvp68jiETJ4VQpX?=
 =?us-ascii?Q?4n/XRypE0/NL9fmDYuF5pjLpVxaVRp8ty93ubKENaJgph1VUVrVjJtr3WYwW?=
 =?us-ascii?Q?HEAspKmJaz1vhby4w1uqqj1kUdhhH3d7UCBEuaYuOKpWXu3c/gETkejjo710?=
 =?us-ascii?Q?vW0nbIueV4qzSLCcjpkg6/PTD/5/r3H7aMS3PmNwems07u6Bw+FfKZJKa2w3?=
 =?us-ascii?Q?zuaV6ScQQgS7puvK1gXISxtmsQ7hdeSH3VNQhedyVheO0C1SltGBcwutAml/?=
 =?us-ascii?Q?Nv/+Q1YaOiAUUpejFvFw4Lbu/TNo1DltY/xfiSj4y8HLfD3u8fBTCG8Ez0Z7?=
 =?us-ascii?Q?/e98unl9goxSNl+br92dRHwGPCHs6psnhIstOfE0nCNvd43WRnipgfzBuW6Z?=
 =?us-ascii?Q?sTlJZYyBSaysly3WwZ7KRvCafvgFaJ0tB1clZLfhxjVBbJpAMJR1xdPDopSk?=
 =?us-ascii?Q?4yNgdJjxQdjDYw+D2MCQ32mk+iBEKR7GHU4/OeTxDmyp8tI7/Z9AwTZaPn1d?=
 =?us-ascii?Q?G0DqwnyUWiYRIPLDs1NBK9+rYg=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 22:31:55.2414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 63ec3367-37a2-4ea7-ddb7-08d8b680b345
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7sx2CeyzvXBrlSx3V6taehaXQNZ52VIYhBQG2H2GwjSBfZCmBpe037MWtekZ2B48
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3254
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_32:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 mlxscore=0
 adultscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101110126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 11:47:38AM -0800, Stanislav Fomichev wrote:
> optlen == 0 indicates that the kernel should ignore BPF buffer
> and use the original one from the user. We, however, forget
> to free the temporary buffer that we've allocated for BPF.
> 
> Reported-by: Martin KaFai Lau <kafai@fb.com>
> Fixes: d8fe449a9c51 ("bpf: Don't return EINVAL from {get,set}sockopt when optlen > PAGE_SIZE")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  kernel/bpf/cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 6ec088a96302..09179ab72c03 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1395,7 +1395,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>  	}
>  
>  out:
> -	if (ret)
> +	if (*kernel_optval == NULL)
It seems fragile to depend on the caller to init *kernel_optval to NULL.

How about something like:

diff --git i/kernel/bpf/cgroup.c w/kernel/bpf/cgroup.c
index 6ec088a96302..8d94c004e781 100644
--- i/kernel/bpf/cgroup.c
+++ w/kernel/bpf/cgroup.c
@@ -1358,7 +1358,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 
 	if (copy_from_user(ctx.optval, optval, min(*optlen, max_optlen)) != 0) {
 		ret = -EFAULT;
-		goto out;
+		goto err_out;
 	}
 
 	lock_sock(sk);
@@ -1368,7 +1368,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 
 	if (!ret) {
 		ret = -EPERM;
-		goto out;
+		goto err_out;
 	}
 
 	if (ctx.optlen == -1) {
@@ -1379,7 +1379,6 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 		ret = -EFAULT;
 	} else {
 		/* optlen within bounds, run kernel handler */
-		ret = 0;
 
 		/* export any potential modifications */
 		*level = ctx.level;
@@ -1391,12 +1390,15 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 		if (ctx.optlen != 0) {
 			*optlen = ctx.optlen;
 			*kernel_optval = ctx.optval;
+		} else {
+			sockopt_free_buf(&ctx);
 		}
+
+		return 0;
 	}
 
-out:
-	if (ret)
-		sockopt_free_buf(&ctx);
+err_out:
+	sockopt_free_buf(&ctx);
 	return ret;
 }
