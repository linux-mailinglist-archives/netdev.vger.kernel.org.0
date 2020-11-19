Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AC52B8935
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgKSBBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:01:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10824 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbgKSBBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 20:01:17 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ10UI4012406;
        Wed, 18 Nov 2020 17:00:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=KT7VR2WRIZ7Y69mu1DnuOL2iDyOuaBvQG9BiV0r1NQ8=;
 b=GKgeekaSRcAeZdYanE8/HOkbfqwlvR/CIfzpm6CHD8zpNtwaK4wNzhKBbaL/57c9e5FD
 AHweaQN4a7EtHyGg10XVYS2PwjEWPt4YpD7O0lxk7JpSvzuSa6VClKqz6bIsDMMLKYjt
 VYbhRSJska0uX3fRBGzR6W43OSaWYDO8rec= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34vhky2gd7-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Nov 2020 17:00:56 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 18 Nov 2020 17:00:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDHhLA2EZUkFAeNbUB21GV2pS/ArZVjLcw6wR4rVfGK7YaAbemfSjVHzn884SKxSC5ISjURv8mAFktxFtLZJLMa4iT/cM6zBx/Loep1PSNjHOIUToCy8k+FQj2gYkiYp293m/5K0b8r5reePZTdmQaj5tKVpWyorJ3dzV53U6lX97rQtAZNz/zO/9WEOJxsce3tRQMuhlMRe335SiUOWajiNfJTj+ImKsq2tFju0aMRFF9kVmEcmENhLZ3AyjVPZ6Lzb8nabgJBitStJsho6EHXKEqwo5tFTcEI0doaamIXwf5A52Tu9cREQrrYRJ2PdH5ze8DeSUCVedjNOWDOzCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KT7VR2WRIZ7Y69mu1DnuOL2iDyOuaBvQG9BiV0r1NQ8=;
 b=NAN+dG8T68pg75cCn/JIH4eaRsdeVa9vNCAJ8ylPxB2mX1MXhc3lwFO+U8pafzPM5PeUn3/NgBMDxpO9XfBxsxVz/OVo8lsMf0yamiHJTHyFiNRb9s+C+e3SsGBmbKJfdIhltst4TGK1Z9BXqpWOdzHJDkDW3X9DTJyaybuGrvlwjBntZfEqpXGvBZWZtH3lSa0PsNhLjCTkDttwjbt/y/Ce3kitCcDraQXIUGz6nybXK/yWZadNTV2eNGRU5Hbw3hoIXs0xTurFt1QeD0h6KjPXc+qbfnqBsWeRMdTUdgxLxAzmTRIZyWVUvdCgI785s2T/AmxY4OF1XSJbSU9Uxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KT7VR2WRIZ7Y69mu1DnuOL2iDyOuaBvQG9BiV0r1NQ8=;
 b=hTH6WUGFhOyWrFMEH2dN4KmsF0RRHyJHvCUh3Tytzt3jly+9+/tRRNR5oFZ2tf6SUWwWifTd3f7uh5aPUCLKrU6g2gnQeAqPlQ533ElmrSLWXlyOW5eMNf7We09X10fWpvnuVXLJVBdA8EXzqP4kc+o5xsu9w5DKRXVa54yyOq4=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2407.namprd15.prod.outlook.com (2603:10b6:a02:8d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Thu, 19 Nov
 2020 01:00:52 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 01:00:52 +0000
Date:   Wed, 18 Nov 2020 17:00:45 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 7/8] bpf: Call bpf_run_sk_reuseport() for
 socket migration.
Message-ID: <20201119010045.a6mqkzuv4tjruny6@kafai-mbp.dhcp.thefacebook.com>
References: <20201117094023.3685-1-kuniyu@amazon.co.jp>
 <20201117094023.3685-8-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117094023.3685-8-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MWHPR18CA0062.namprd18.prod.outlook.com
 (2603:10b6:300:39::24) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MWHPR18CA0062.namprd18.prod.outlook.com (2603:10b6:300:39::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Thu, 19 Nov 2020 01:00:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d87f632-a253-499f-ec77-08d88c268f91
X-MS-TrafficTypeDiagnostic: BYAPR15MB2407:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2407E4D84CE9BB2DD27DC95FD5E00@BYAPR15MB2407.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lkXW4/cglCzGmnPB516/+Asd26LDDbxY7bXai6ocMRsN4RxdzEpF6AW6ngtahch8GO860Vg4KJAzMl+zdpvHlsED8JW/srCLKqAORXWlBYOer+GSs0T/FYvlmQYztJVZMz9m5sZVlP/4AiJCAvyXc8r4DcuXW84oRbI4ToRZXufxBUM6Kk/VYbfs/NTQ5RlNDWEkl4Qr1FweHtlykOTRqEYdzToFwDRBf16B1zEDAM2JWjH9qUrb+y41PjhNcCzTw8Y0oRS7FHCeLrX+w+vra9k/SVKrkn0mNCqxCtA3kBpgGTOUr9+JWHEmom3i7cvo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(376002)(366004)(136003)(186003)(6916009)(478600001)(316002)(4326008)(7416002)(55016002)(1076003)(9686003)(66476007)(54906003)(6666004)(16526019)(52116002)(2906002)(7696005)(6506007)(66946007)(5660300002)(66556008)(83380400001)(8676002)(8936002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: QCGZDzlLsljZ/X4y8DVeJj5+Ih20VE0Fs4vjQ/y5SafbqXCb6dcyBYIkrjnD9R89dvGdw+cklikXt+26XR5MUvxxzRiamyaI7pBgAJBF8TsPyomP6bSEAhbjbo7RduuRvm9/HoMaEO9eOI7ZFjQuCO7CEKk6vhE/u3CHV+x27ZcOhhRUajORrbfsuKvmY5ZgJOg/CXgPTpTyxFB6yY8ZUI06v0U2rQVuZXNMjra72zeMlc/5HnDlxZGq0y9T1ndw7xljoQYcjAxkQd8bcjzldJammJBaqg2AufmwE+oZ7XV/ELVnDYpSjyOFtkGEz1ZtEw6seD9Fv78+Pe6ULB3oPauabxxA2Be8hCs4tLrAD4OUuGbTJ/eFHv9CcMUSs3634YQOaQT/0CpGyVRdObKLerdO96umm7xuRXm28x/5JS2/RhUKAAyAxXFFm7pSF1B9jKNqAA822skpYJs1tQFKbfuOc6Yq4LJ66ZeGqWchodmvlrTIEyjbfRiek3y3c6PdT3Vm5fK6t4mm9brlre4HChNNNTOLbpeKfNZhlUF5nOFedWANws07cZyczrUYxaIpOFH6dUGg1KpED5mUNlKmgb/Tpsm8Ni3guZhGG54FqB48ZBro/t/gNVpcO6G9WsLMu8Gzt49RbH/24tPI7AkAK9++tN7UivDUOaNl2HXW3tIhr6SCBMr70tcq9mbqgsZCmr99TGndVXr/zIiU+k955TQ8jjUi9wdeFDSC8k+AjQ7Jv9gIitIFHeA8z8hI9i6+RpWTlahttQx/DEYJUU3fP6F11gnlGq6Av5qxGkfbuNrV8//Y0xxtKMjIFd0zungI2GUdiDNODYsGmMThjhBU6YYEtU24Jsdnt0QBGM/wpgVrt3VcTf7SmxPLGxjbeX0eggxOYqStpJzhKipIFPY/oPhavJFdxeQiYzSMiJPrcyg=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d87f632-a253-499f-ec77-08d88c268f91
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 01:00:52.0624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T46snWfZqrxavYtze1mzDLcOABZbZJZkJo1ayp5xWvoup04ljvcnl5su6749IZTM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2407
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_10:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=5 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190003
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 06:40:22PM +0900, Kuniyuki Iwashima wrote:
> This patch makes it possible to select a new listener for socket migration
> by eBPF.
> 
> The noteworthy point is that we select a listening socket in
> reuseport_detach_sock() and reuseport_select_sock(), but we do not have
> struct skb in the unhash path.
> 
> Since we cannot pass skb to the eBPF program, we run only the
> BPF_PROG_TYPE_SK_REUSEPORT program by calling bpf_run_sk_reuseport() with
> skb NULL. So, some fields derived from skb are also NULL in the eBPF
> program.
More things need to be considered here when skb is NULL.

Some helpers are probably assuming skb is not NULL.

Also, the sk_lookup in filter.c is actually passing a NULL skb to avoid
doing the reuseport select.

> 
> Moreover, we can cancel migration by returning SK_DROP. This feature is
> useful when listeners have different settings at the socket API level or
> when we want to free resources as soon as possible.
> 
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  net/core/filter.c          | 26 +++++++++++++++++++++-----
>  net/core/sock_reuseport.c  | 23 ++++++++++++++++++++---
>  net/ipv4/inet_hashtables.c |  2 +-
>  3 files changed, 42 insertions(+), 9 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 01e28f283962..ffc4591878b8 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -8914,6 +8914,22 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
>  	SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF(S, NS, F, NF,		       \
>  					     BPF_FIELD_SIZEOF(NS, NF), 0)
>  
> +#define SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF_OR_NULL(S, NS, F, NF, SIZE, OFF)	\
> +	do {									\
> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(S, F), si->dst_reg,	\
> +				      si->src_reg, offsetof(S, F));		\
> +		*insn++ = BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 1);		\
Although it may not matter much, always doing this check seems not very ideal
considering the fast path will always have skb and only the slow
path (accept-queue migrate) has skb is NULL.  I think the req_sk usually
has the skb also except the timer one.

First thought is to create a temp skb but it has its own issues.
or it may actually belong to a new prog type.  However, lets keep
exploring possible options (including NULL skb).

> +		*insn++ = BPF_LDX_MEM(						\
> +			SIZE, si->dst_reg, si->dst_reg,				\
> +			bpf_target_off(NS, NF, sizeof_field(NS, NF),		\
> +				       target_size)				\
> +			+ OFF);							\
> +	} while (0)
