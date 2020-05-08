Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A61D1CB780
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgEHSkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:40:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38378 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726817AbgEHSkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 14:40:12 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 048IdiAt016934;
        Fri, 8 May 2020 11:39:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=7gOQfgFoSkNs27GeJjtWC/h+dq9fDTUWn/7frZdok0I=;
 b=CVm5DlV9VpMEyeFMebEC3xlclBXJpFUxmF9Rb1BB0m1KHWomKyw+9Yj40XFV4G+6Awbh
 MIwNw93b0o3C4tUWWLoOiZWUY9VVdv20fU4Qx1WH9T5Ll4zxzm5OTzoE10gIphjOXKU3
 R7eH31JwZTMP/yqdilpLmwIEf7kJ1aN4uRE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30vtd6dat9-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 May 2020 11:39:50 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 11:39:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTpKoVocf/Z2RViZYl21DiDXe1HSFkyG4Eedr2Gi5D8MMTNF8POVj+k4e8kxIw+ifyxMMXSqD/f2WFXFVShryXM/8Wa2x+eA6s0TQ9Jn557IQ+VtLfrmsCqriR9/B27icaWXDEkp24OhNqJZ4CCgaKRLIkq2+KIhA643eXXMMCgObGiz37A9isB0DKIve80yCFXkPSE3QhyK5u2oquzAcXsGid9J8cCESkbiIFLxx/6VmD82WdXZzOcCjOjit1MYDgeAigvWLu7o7ObkQupccAB7RMaZ9UzltsUsfg/hMtrhBAihvtc3jC4QHc9HO74dt3EPoufZuOisdMSObOH74w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gOQfgFoSkNs27GeJjtWC/h+dq9fDTUWn/7frZdok0I=;
 b=CTHUVK3bt7fFFYnM7oZnxPpsPLYThdQjkHaedFktSLbqZlKiduSwtGQe3PioG3ueKM+njeb7iwb+09ctD5D/YwQhrWUw6BCYFINefSdKdam+sSB/u4C3uGRcNMFcDv0ZQVm27ZSAj1AFjS+2K599IuYjV3uANjmGXB+0AWo9z9PdEt5gmK0bK4/porIZmONyKDbUsYldpe+CRjYgMB+TvTqViHg4uTYt7jhpLL0UM4roSHoiYo3B5D3tg9Ri5ctsrqQlKawp1HSZ3++Xrclo+Kq2K0jm0CEu/TFiVw3fgTuvZffPHzWAszAgc3v89H7eR3QMoqGSnyoCGFGcc01ukw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gOQfgFoSkNs27GeJjtWC/h+dq9fDTUWn/7frZdok0I=;
 b=jYuO3gb3HP5Z/hlKcCK9aI7i5bty4RyGVlos1PP+vvsE0NnJwzFZQtZL1tabb3VNxY+aEj6kpGSA4Vpp5phwT1+2lUWKQzOPSn6jLT1RZqYMY3Kj58qNmF3yQqpDTjdtwDZDmMkM6Gpr3fuDPhCDy4rJenAVca25NI2buACBTDg=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB4057.namprd15.prod.outlook.com (2603:10b6:303:47::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Fri, 8 May
 2020 18:39:32 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2979.033; Fri, 8 May 2020
 18:39:32 +0000
Date:   Fri, 8 May 2020 11:39:28 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <dccp@vger.kernel.org>, <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next 02/17] bpf: Introduce SK_LOOKUP program type
 with a dedicated attach point
Message-ID: <20200508183928.ofudkphlb3vgpute@kafai-mbp.dhcp.thefacebook.com>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
 <20200506125514.1020829-3-jakub@cloudflare.com>
 <20200508070638.pqe73q4v3paxpkq5@kafai-mbp.dhcp.thefacebook.com>
 <87a72ivh6t.fsf@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a72ivh6t.fsf@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY5PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::30) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:fac5) by BY5PR04CA0020.namprd04.prod.outlook.com (2603:10b6:a03:1d0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Fri, 8 May 2020 18:39:31 +0000
X-Originating-IP: [2620:10d:c090:400::5:fac5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dfe21d6-5bfe-479a-6e38-08d7f37f2613
X-MS-TrafficTypeDiagnostic: MW3PR15MB4057:
X-Microsoft-Antispam-PRVS: <MW3PR15MB40579C40BC8ED3A7524DBED7D5A20@MW3PR15MB4057.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x6UlM/YkGT9gWfKWDbwGofqu2GBSqedQ5DYoPiQenxHzG5izeu6UZ5rsa9MvfsYbIE8inv5HExpWfmsP0F9sWGgAtSQNWzZFW+Y/JO4SEx3B8mfn4TEgpruXGTOTRBDFG74lCBSKcQyjraV2kGD9ryco1DHnt4ZY8FDkLrjpdfZsbnQoHOaH5XJ/rlY97rFT/B8w5H+AQNtLn/mP6qF4DyykBcXBdAvB+mbGfypg+nI/1ggjfRvrqkMslyh9+i6D5Zp2ZaTI2GnTrEYelg6vukowIMWn5g3Y6mN3KP8WVIYjI24SE4sbbxbauCRnDaZLaOb1evyQhh7RZHulcr3PqLcPJP5Hjrtv4NCjSlYonUe7aJyjLp6LcQp1ejF+bCGsnviAN9Jx32rCWRy3aovPcUVWJ2DUGDIScbox0ZjrJvOqW2qL3a9LGyJsz9K6KAaU9z/KXGfCT5pHLs+KGJWxUdlRmbNLEw/e+e8mSG5i09bQS60LlqnnJt892G2YURbOwHBd6EO+qDrWX9pM7l+a1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(366004)(39860400002)(346002)(136003)(33430700001)(5660300002)(478600001)(83290400001)(54906003)(316002)(8936002)(186003)(4326008)(8676002)(6506007)(16526019)(7696005)(53546011)(52116002)(83280400001)(33440700001)(83310400001)(83320400001)(83300400001)(55016002)(9686003)(66476007)(7416002)(6916009)(6666004)(66946007)(2906002)(86362001)(66556008)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: in7kAbEsuA/e34igKm321tjrakruiz0WPtkSaJUO4BcqbkmgeuWDaQz4pTgCfYnT16wrvS5ktR5bhuu+NfeOWgnRRL8KJK7+gIoy81YcbJ7SIRak+6CZAdYVJOXrrlgQ63Nhgi3saZh8sFfOKJxQjwm1kGnstfgXV/NZZkPahFOyU/MXWlze7555gWpACWYPmmXikRwVZz3Mjc1fw06suK0pGMbEzAZkNaYNx3YqRCVUsjaOn1BaO4CB5R1BQLfl57rYML+Hgkt4vDqGKiB+P7A0crDGm7/ny6gsdRiyXxLT+Umlerbq6elltn+dab4edST/6Lc+FcNIF5YhJ6l1WijTCmXfVTgdxwONOjsNdauHplR6v/VjL70qyleXe5eRYW1Lf0qcZoV4Vz5ehRkobx9NknySa77ON+aQgt8De4nOfSRI+1HfSpYflo3wiJC+3xF+FVyWgNZwOet4C/8lrOco2EkSNZ5EuQtrw2KUy2gmPpYcsgrYc9vhZI4LZPGabS6tm69B3Ai+yu72lsWaZA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dfe21d6-5bfe-479a-6e38-08d7f37f2613
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 18:39:32.4853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tUCAaij//LXrXsqjdQVvjMH7nPpJ8EWUQxzCAk7PHZtIwoQbcHrH81eBsaqyreCD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4057
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_16:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 mlxscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005080158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 12:45:14PM +0200, Jakub Sitnicki wrote:
> On Fri, May 08, 2020 at 09:06 AM CEST, Martin KaFai Lau wrote:
> > On Wed, May 06, 2020 at 02:54:58PM +0200, Jakub Sitnicki wrote:
> >> Add a new program type BPF_PROG_TYPE_SK_LOOKUP and a dedicated attach type
> >> called BPF_SK_LOOKUP. The new program kind is to be invoked by the
> >> transport layer when looking up a socket for a received packet.
> >>
> >> When called, SK_LOOKUP program can select a socket that will receive the
> >> packet. This serves as a mechanism to overcome the limits of what bind()
> >> API allows to express. Two use-cases driving this work are:
> >>
> >>  (1) steer packets destined to an IP range, fixed port to a socket
> >>
> >>      192.0.2.0/24, port 80 -> NGINX socket
> >>
> >>  (2) steer packets destined to an IP address, any port to a socket
> >>
> >>      198.51.100.1, any port -> L7 proxy socket
> >>
> >> In its run-time context, program receives information about the packet that
> >> triggered the socket lookup. Namely IP version, L4 protocol identifier, and
> >> address 4-tuple. Context can be further extended to include ingress
> >> interface identifier.
> >>
> >> To select a socket BPF program fetches it from a map holding socket
> >> references, like SOCKMAP or SOCKHASH, and calls bpf_sk_assign(ctx, sk, ...)
> >> helper to record the selection. Transport layer then uses the selected
> >> socket as a result of socket lookup.
> >>
> >> This patch only enables the user to attach an SK_LOOKUP program to a
> >> network namespace. Subsequent patches hook it up to run on local delivery
> >> path in ipv4 and ipv6 stacks.
> >>
> >> Suggested-by: Marek Majkowski <marek@cloudflare.com>
> >> Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> 

[...]

> >> +BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
> >> +	   struct sock *, sk, u64, flags)
> >> +{
> >> +	if (unlikely(flags != 0))
> >> +		return -EINVAL;
> >> +	if (unlikely(!sk_fullsock(sk)))
> > May be ARG_PTR_TO_SOCKET instead?
> 
> I had ARG_PTR_TO_SOCKET initially, then switched to SOCK_COMMON to match
> the TC bpf_sk_assign proto. Now that you point it out, it makes more
> sense to be more specific in the helper proto.
> 
> >
> >> +		return -ESOCKTNOSUPPORT;
> >> +
> >> +	/* Check if socket is suitable for packet L3/L4 protocol */
> >> +	if (sk->sk_protocol != ctx->protocol)
> >> +		return -EPROTOTYPE;
> >> +	if (sk->sk_family != ctx->family &&
> >> +	    (sk->sk_family == AF_INET || ipv6_only_sock(sk)))
> >> +		return -EAFNOSUPPORT;
> >> +
> >> +	/* Select socket as lookup result */
> >> +	ctx->selected_sk = sk;
> > Could sk be a TCP_ESTABLISHED sk?
> 
> Yes, and what's worse, it could be ref-counted. This is a bug. I should
> be rejecting ref counted sockets here.
Agree. ref-counted (i.e. checking rcu protected or not) is the right check
here.

An unrelated quick thought, it may still be fine for the
TCP_ESTABLISHED tcp_sk returned from sock_map because of the
"call_rcu(&psock->rcu, sk_psock_destroy);" in sk_psock_drop().
I was more thinking about in the future, what if this helper can take
other sk not coming from sock_map.

> 
> Callers of __inet_lookup_listener() and inet6_lookup_listener() expect
> an RCU-freed socket on return.
> 
> For UDP lookup, returning a TCP_ESTABLISHED (connected) socket is okay.
> 
> 
> Thank you for valuable comments. Will fix all of the above in v2.
