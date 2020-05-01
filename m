Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5591C200F
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 23:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgEAVwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 17:52:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44144 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726344AbgEAVwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 17:52:23 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041LYLq0021804;
        Fri, 1 May 2020 14:52:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=D6LHUdeJni784EED1TZzxjisJxJllC5HH80IfH3E7V8=;
 b=lGraYWkxje4AUC4tWkNDIc+KRtxT9PRNp1mGVJmKR/noaOUfiZO8AdPRsC6Tdbx/Jgu7
 whCJTPEjOuTkdkl416vB+ISX0Etx16X+mN6u0wniAhFqVRLIMQ/lrDGZBwayY6DXCO3g
 Xok7r7QY9CsN9f8vj4JqD8moEzNw/auDWKo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30r7dbx0ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 01 May 2020 14:52:06 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 1 May 2020 14:52:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2NeWrH7M3Wz9B5PTeJC5Bi1sNvT5+zvWQRTPtK45zQt6xg88C0Ybf+96CBuuhttIA1bWZMmN4nfJjVReKTHS8+49vQdI83BU57fR5cZcTCQ2g4oQLac3D5zulDpEoU8N8B7lX3OMlsT+AyV0dIwiME6vjMoDCoOXz/tJ3Dlk8xy3PYEHvcllR3ZKzgb72bvPqJJnfDx3+oCPvuJPhpeBplQeCc1fSn6/jJ1qQJbBEwxBdyqzwLurXU7KAyw/pnCeaEqM6VdcXzvbv2tbU2WqOcbFqyj443yEDQYf+Hh2kMueX4SV7/gPdWMOh+uEiXWN+uzLcbTHRcFcrLGmp5YTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6LHUdeJni784EED1TZzxjisJxJllC5HH80IfH3E7V8=;
 b=KWmYYcyVWyKuM0fNLmvGmicpc9zfQqf5rxDElSEd1MJsIDwu99EIv86LYbuntpEMncWooqnHcTsowlu0DhyR4DIQwjx48rOOnMChDLkqxuG/eo3M1bnb0CfVl54EcPbKheG9TS6LaGdeOtd86MuQXIiMBVkHPT90CD/HIViXtgH9NUyNoKQcruaHkcIm1NpqFsa7ku8ACUhoRWdlM00ukWveohabzS/VDHWfli2PDpEBv4+NiDaIZM5vFTaigvJzYIeYBj2S5gmePpbJwpZVgkkPcXRhH4jo6Mxbt+jKgYOM/VMKCyV0YnL8pSp6/mYc/rG9DSZzGUSUTHPBYy8yUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6LHUdeJni784EED1TZzxjisJxJllC5HH80IfH3E7V8=;
 b=CC8odlwGYAvD65hKuIM/BhBMKX96YFd1oefqhME8+1sF45foBM7XBfUIdiszx1tfX7cq8J2IAh1LmFZp259BspKDrrAUHQo/MCI4TmDTN8Is2pppPa+7IuJjXt5SzfLNTm8TFcxb4TjeV8OhiZ4LDwxD9x8c8RpcGyK1nypbn9g=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2855.namprd15.prod.outlook.com (2603:10b6:a03:b3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Fri, 1 May
 2020 21:52:04 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2937.028; Fri, 1 May 2020
 21:52:04 +0000
Date:   Fri, 1 May 2020 14:52:02 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v3] bpf: bpf_{g,s}etsockopt for struct
 bpf_sock_addr
Message-ID: <20200501215202.GA72448@rdna-mbp.dhcp.thefacebook.com>
References: <20200430233152.199403-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200430233152.199403-1-sdf@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: BYAPR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::18) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:be22) by BYAPR07CA0005.namprd07.prod.outlook.com (2603:10b6:a02:bc::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Fri, 1 May 2020 21:52:04 +0000
X-Originating-IP: [2620:10d:c090:400::5:be22]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e91fd1d-4b5b-4d03-dc7e-08d7ee19e2a7
X-MS-TrafficTypeDiagnostic: BYAPR15MB2855:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2855CFA8ACD988565208CD49A8AB0@BYAPR15MB2855.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WWRQxO4V5j+3aNFF1N9tsvuG8eSx76EucUID+loo7LgKqiINgBc5kkqSpMAENVs0fgqrgc1jSlprv4vnjLxmu7IucerC6GVca9iRQt/3DgKMfCGuS5mi75IWrOV2TdyyYjdcOLrR7Y2VDfqgOp4bBIWjgbIE/SN39gvzWs+wuqYF+bJ5kbCgs4UP3dHoxKp8c/KWyl0rgQDKNBDZaI74uZbuKOuMoNJSw4Nnv5YY+dIMDQ8TfjzGjr8ak+jvjVJGcarfJi1QmvXW/VRvsELFLTy9DMvzU6QmnuuqcpXAMkb0rOmRLXEl9YzjuJAgSqX+04NzYFvFb0T3Qjf+pzJnhp1zTjf/SOcYVEZYoFKpAOm203fMbOn9ljVjWdG/vm/XFj9l4/vu8J3dh/eY5wdIyX0T6+B5TXLEvsrTX8c78LB/Qm1N4BXBoglFzCMQc4ahRIvvjM87fEL5BABcguN6OTmjMWxSVyRRLYZKBqq00WU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(376002)(366004)(39860400002)(346002)(86362001)(1076003)(5660300002)(6496006)(52116002)(16526019)(6486002)(186003)(478600001)(9686003)(2906002)(8676002)(8936002)(54906003)(316002)(66946007)(66556008)(66476007)(33656002)(6916009)(4326008)(142933001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: lHJcuPURgP9pzXE8SqGQdGZUpSLjQdpRorxaiDskRzN8cljTUKh83Y7KAWLm9gGRxQMFTDnrPvWi/JSP99ArxSVckhxdLAlVuNeBMMCWwHxZsh4HcW0/744+c8LmqYsaWHZCnOQrHv9F0AinYNuAZGIKaahKVU7cpMTFB0/fbHZMv9cUswwjoVuAI6EQSGwYRRMXyFh6nzx1r3lXanm+mvY7D1mp60WiBZkALzVifVNy5jYy5g1Sj2zzARWmFSeLn4eDSW/bAk3V5LyCltvDCeXYt4Q5ApFi0x+qW8zMtZN9YrhDyfmRynp+phx1HJKMz/WISqhFlj6IKjT8JbYspa1niwABCvzD3Xt+de9FwFmvTQV0mQWmNVsvdE7vxhTvFoZLmCEEoCpumpT3TcTPXLl9aaFdeLF+AENSNLfrkimBjBWp5ZOAcDF/aOelCKYTDlQ1OF3A04vBW6Flr0IgXuVybvFf/OTXkMI1vVH/Ur61lZ0sZF+2eYko21S/FfdSZOM/YK3oyTrvkXFqu//Lh5+Z4Fo7zQzRXbAO+aQtbgU7uT4HcxUf50zTBjtCJmCgeppzVO5dppAIERtnvis3AhapkzcMOaCraAIgN9BK11V0tyVYpbdEAePudEEhQKNmzaBkLT6vu/lpn2xrxIirhUo599u+wyayoECdh6IDbYg3dQu1ysNKebL+0ff2SSoVAXj+ZzTVcz/lP2y6TWy7sjOaVpvloI1Z377FxAzdJdd1SJKxgbmKdALBNmP7rtnLzpCswmA8dynZRzv5Zc1DOrNZjLbHgDzG8jUjpZDm/MS5ITEc1g2mvDlDWWO0qvjvRZe2BxSWmNyE/N1vefYF3A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e91fd1d-4b5b-4d03-dc7e-08d7ee19e2a7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 21:52:04.3617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJs0I5NxJIl3d3lkpSATeWnmjpgToFbjVCft7DNjAjpKqRvCImvRxKnxXq1ElsL4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2855
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_16:2020-05-01,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 adultscore=0 clxscore=1011
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> [Thu, 2020-04-30 16:32 -0700]:
> Currently, bpf_getsockopt and bpf_setsockopt helpers operate on the
> 'struct bpf_sock_ops' context in BPF_PROG_TYPE_SOCK_OPS program.
> Let's generalize them and make them available for 'struct bpf_sock_addr'.
> That way, in the future, we can allow those helpers in more places.
> 
> As an example, let's expose those 'struct bpf_sock_addr' based helpers to
> BPF_CGROUP_INET{4,6}_CONNECT hooks. That way we can override CC before the
> connection is made.
> 
> v3:
> * Expose custom helpers for bpf_sock_addr context instead of doing
>   generic bpf_sock argument (as suggested by Daniel). Even with
>   try_socket_lock that doesn't sleep we have a problem where context sk
>   is already locked and socket lock is non-nestable.
> 
> v2:
> * s/BPF_PROG_TYPE_CGROUP_SOCKOPT/BPF_PROG_TYPE_SOCK_OPS/
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

...

>  SEC("cgroup/connect4")
>  int connect_v4_prog(struct bpf_sock_addr *ctx)
>  {
> @@ -66,6 +108,10 @@ int connect_v4_prog(struct bpf_sock_addr *ctx)
>  
>  	bpf_sk_release(sk);
>  
> +	/* Rewrite congestion control. */
> +	if (ctx->type == SOCK_STREAM && set_cc(ctx))
> +		return 0;

Hi Stas,

This new check breaks one of tests in test_sock_addr:

	root@arch-fb-vm1:/home/rdna/bpf-next/tools/testing/selftests/bpf ./test_sock_addr.sh
	...
	(test_sock_addr.c:1199: errno: Operation not permitted) Fail to connect to server
	Test case: connect4: rewrite IP & TCP port .. [FAIL]
	...
	Summary: 34 PASSED, 1 FAILED

What the test does is it sets up TCPv4 server:

	[pid   386] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 6
	[pid   386] bind(6, {sa_family=AF_INET, sin_port=htons(4444), sin_addr=inet_addr("127.0.0.1")}, 128) = 0
	[pid   386] listen(6, 128)              = 0

Then tries to connect to a fake IPv4:port and this connect4 program
should redirect it to that TCP server, but only if every field in
context has expected value.

But after that commit program started denying the connect:

	[pid   386] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 7
	[pid   386] connect(7, {sa_family=AF_INET, sin_port=htons(4040), sin_addr=inet_addr("192.168.1.254")}, 128) = -1 EPERM (Operation not permitted)
	(test_sock_addr.c:1201: errno: Operation not permitted) Fail to connect to server
	Test case: connect4: rewrite IP & TCP port .. [FAIL] 

I verified that commenting out this new `if` fixes the problem, but
haven't spent time root-causing it. Could you please look at it?

Thanks.


-- 
Andrey Ignatov
