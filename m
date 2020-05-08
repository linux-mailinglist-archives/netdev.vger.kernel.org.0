Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B151CA4C8
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 09:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgEHHHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 03:07:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34124 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726048AbgEHHHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 03:07:18 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0486vjv2016834;
        Fri, 8 May 2020 00:06:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=FH2LVrr/CPZJPWVwh9Qmz6uKJvE0vnMhA2oMbXcFhQU=;
 b=eOSIUdmF+IxneALp/TbX76WvW+mriaXw7xK/kOeo+jc02DvVrVaYS2j7ZBP2rUqrQzRD
 OWnBntk2yrM5RaGFCZlkEik/OxHfmYDNhKHd1CLf4pAEw314iusyqgf7Xp0E598jKOts
 6L0lxPI8ODzJ4RrucvN5jF14z9CAb8htTSA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 30vtcat4pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 May 2020 00:06:56 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 00:06:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lI0z01VX69pdDNn5PrMsGmOto91MxU9o0w0/AIvigDI3QRjWN4GtKB9ZGkwH3lNxYzSTVN1YbwrrYs83g//6FyF1wvzztQitiqdr68nk79p3IDcH2/V2HKRMalo1QS+FRckNMswQf5q4wUIELhyTxlYcS22DgPdmJz9B0D3xgvtzfN7cnf2fCxuuNytpUhYsVtTzWzgmSV90xnZzhuWt/LsbzYTM9+UXR9VL+SqJYqvJF0Lvl8M4awqkEyKhtBAIhOy0Zgi1xXJbAawEgu5V7Eg5Klm/jOFAKNVAquJN+ia7HSgu3yQb2T49awsEw93pgh7ryrKytg/HRTFQQwSVAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FH2LVrr/CPZJPWVwh9Qmz6uKJvE0vnMhA2oMbXcFhQU=;
 b=XtwLEEy80LQEDk1zaryQsIhdPB3Q44SOWD8FbGCLNnqyGPZ9d3Hpa5UxycnaCh9oe/zU6vqp9VhRTSXD8qQP7B9lNR7jy0DkP268YyYNm9a/6rDYlC4BkiDdzR7hzqsCtouz7+b2r8LIUdyVwZI6SSMv06EyTeCE2gzur24r28Qx0TtzhpT4xdCh5eSRbFllOOoXfNABNcGtU2Olj2fAbfAirND36Rh/5XwdCSlP7ZwajvuZWFVuDnmYyTo6qnVQRGsQZYOenKlNLf2aKXsIRA+QvcndSBv5PfGAHuLEvWYMC75XBLAdLIn8+1XdRjqud5h0IjGpB6ld81lz7CH3FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FH2LVrr/CPZJPWVwh9Qmz6uKJvE0vnMhA2oMbXcFhQU=;
 b=P+2ywP6Sm5mRUC8MWHIga8OtyAdYXa3QpetywBpYYZ08924XyOfDdzzsHOU7ZbcP4rkY+ylKoIA2wj9xRgutwolkaaR4ctyFoVtIT25yAnA3BXLI+ZpA/1qNULi6BvuiwAYT8lBSQFtKT0j/Nm4ljaSq6d/haFzk12v+jCxVcUM=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3852.namprd15.prod.outlook.com (2603:10b6:303:45::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27; Fri, 8 May
 2020 07:06:41 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.034; Fri, 8 May 2020
 07:06:41 +0000
Date:   Fri, 8 May 2020 00:06:38 -0700
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
Message-ID: <20200508070638.pqe73q4v3paxpkq5@kafai-mbp.dhcp.thefacebook.com>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
 <20200506125514.1020829-3-jakub@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506125514.1020829-3-jakub@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY3PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:217::24) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:2a2) by BY3PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:217::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.30 via Frontend Transport; Fri, 8 May 2020 07:06:40 +0000
X-Originating-IP: [2620:10d:c090:400::5:2a2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99c0dc7d-1d79-48b6-4025-08d7f31e5b96
X-MS-TrafficTypeDiagnostic: MW3PR15MB3852:
X-Microsoft-Antispam-PRVS: <MW3PR15MB38529115C955C87DD42BDE40D5A20@MW3PR15MB3852.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1iS+r9J5dxWKpXX7+oeZQ97//GCA9qgW9c9zzQvTB5NlIY7OWqzu2pQ506czMIIMR+wkKRUPqHKmEiqYant8bHsD7WXw2T8csi/nAafgVR9zwFg9yYww5rm+JcvWlG+v9lcegsd7zZmX007Owi1Wvd2TrZ7/fYXy/lIHKWau7YEdxsM3E/PsbhOpmrwHY089nmUhrya9BmtGuYgUHjiSMCvl9sVwAjAc7jUum40jOf2uHvFWnDQafjVFR2bFGQSFjZDjhREmXfUmNyShHpLiY3SCIHk38AMVUuAZO3n+kzna9BTl602I6c8VNIYHmh7WE6T7ks7b72GrVoslu04wcTBFNzKyAeE/l71KicNsNccX37TgR/W77Tm+L/CVQojZnUlq3rpbAUY6vTNm8ml2DgMshxXuxcVIPKIpxivJvNPQOC4y0gYjidKGeuGW3EfctpPOQZv+ZgE+/IiSHQf3cJRYAN5IUEs8/S6cA4ER0uAy2+MRUH7Wl2plVU6XFeaj/RbV7AUb6p3SLwfI6z93wQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(136003)(346002)(39860400002)(376002)(33430700001)(6916009)(5660300002)(478600001)(2906002)(9686003)(186003)(8676002)(66556008)(83300400001)(16526019)(55016002)(7696005)(66476007)(83280400001)(83310400001)(83320400001)(83290400001)(8936002)(33440700001)(86362001)(54906003)(7416002)(66946007)(30864003)(6506007)(52116002)(1076003)(316002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: y+40FzPVGMNawVg7xENYjMGAumGF2mMvT0+ixKEBlOblmKU6R0PdgLHRrPGQDwLFOMUZc3O0zFwikQ5HlmQ+XdCcEmdebcu/AEuog2rrv4B9XD39kpzd8x2Mr8UaBFjZ465vhRt/KpLZ7oD98xl4c/1WEMOKxH7JhbxXqjNFmfUGD55Gjmmpr7yqTia2zAZqXQw6zuAd3ve6etANJGX8L+NlUBolKv1PXhdHxAHB3KgJgOasXqbknR8A/DNCGFF+5aR781d6eU8VCJcvlPm+ZwA47nK8O8PVEBOtwgVoQ8UvoxVsL7IJAKOnFAdMLdKT/z/asfgfqZgHdGDkGTRvfF5tdQALn5qYjrDSlPQn8Od1Tay2hJKRRJUHFKfTefTT2Z6cnv2sNGpS/uKgZ+UiKnOj0HcDqp+UZY8lQlosNEbQ0zBis84Ld3UltFUhOz/C3soWyrf656tCstswZnbxP+mula/5w2VNSBn3YYzqGkRbv77tghu98RF8O/+5/tc4bg32NH9bRvB0r3lwCoDPog==
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c0dc7d-1d79-48b6-4025-08d7f31e5b96
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 07:06:41.0592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0KpbwoI6aqR5O1nPfO4P9COXhwAlLRu2aJ1/O14ShcAqFBYT5Nj5RV2S4tSL39IF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3852
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_08:2020-05-07,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080060
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 02:54:58PM +0200, Jakub Sitnicki wrote:
> Add a new program type BPF_PROG_TYPE_SK_LOOKUP and a dedicated attach type
> called BPF_SK_LOOKUP. The new program kind is to be invoked by the
> transport layer when looking up a socket for a received packet.
> 
> When called, SK_LOOKUP program can select a socket that will receive the
> packet. This serves as a mechanism to overcome the limits of what bind()
> API allows to express. Two use-cases driving this work are:
> 
>  (1) steer packets destined to an IP range, fixed port to a socket
> 
>      192.0.2.0/24, port 80 -> NGINX socket
> 
>  (2) steer packets destined to an IP address, any port to a socket
> 
>      198.51.100.1, any port -> L7 proxy socket
> 
> In its run-time context, program receives information about the packet that
> triggered the socket lookup. Namely IP version, L4 protocol identifier, and
> address 4-tuple. Context can be further extended to include ingress
> interface identifier.
> 
> To select a socket BPF program fetches it from a map holding socket
> references, like SOCKMAP or SOCKHASH, and calls bpf_sk_assign(ctx, sk, ...)
> helper to record the selection. Transport layer then uses the selected
> socket as a result of socket lookup.
> 
> This patch only enables the user to attach an SK_LOOKUP program to a
> network namespace. Subsequent patches hook it up to run on local delivery
> path in ipv4 and ipv6 stacks.
> 
> Suggested-by: Marek Majkowski <marek@cloudflare.com>
> Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  include/linux/bpf_types.h   |   2 +
>  include/linux/filter.h      |  23 ++++
>  include/net/net_namespace.h |   1 +
>  include/uapi/linux/bpf.h    |  53 ++++++++
>  kernel/bpf/syscall.c        |   9 ++
>  net/core/filter.c           | 247 ++++++++++++++++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py  |   9 +-
>  7 files changed, 343 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index 8345cdf553b8..08c2aef674ac 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -64,6 +64,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2,
>  #ifdef CONFIG_INET
>  BPF_PROG_TYPE(BPF_PROG_TYPE_SK_REUSEPORT, sk_reuseport,
>  	      struct sk_reuseport_md, struct sk_reuseport_kern)
> +BPF_PROG_TYPE(BPF_PROG_TYPE_SK_LOOKUP, sk_lookup,
> +	      struct bpf_sk_lookup, struct bpf_sk_lookup_kern)
>  #endif
>  #if defined(CONFIG_BPF_JIT)
>  BPF_PROG_TYPE(BPF_PROG_TYPE_STRUCT_OPS, bpf_struct_ops,
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index af37318bb1c5..33254e840c8d 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -1280,4 +1280,27 @@ struct bpf_sockopt_kern {
>  	s32		retval;
>  };
>  
> +struct bpf_sk_lookup_kern {
> +	unsigned short	family;
> +	u16		protocol;
> +	union {
> +		struct {
> +			__be32 saddr;
> +			__be32 daddr;
> +		} v4;
> +		struct {
> +			struct in6_addr saddr;
> +			struct in6_addr daddr;
> +		} v6;
> +	};
> +	__be16		sport;
> +	u16		dport;
> +	struct sock	*selected_sk;
> +};
> +
> +int sk_lookup_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog);
> +int sk_lookup_prog_detach(const union bpf_attr *attr);
> +int sk_lookup_prog_query(const union bpf_attr *attr,
> +			 union bpf_attr __user *uattr);
> +
>  #endif /* __LINUX_FILTER_H__ */
> diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
> index ab96fb59131c..70bf4888c94d 100644
> --- a/include/net/net_namespace.h
> +++ b/include/net/net_namespace.h
> @@ -163,6 +163,7 @@ struct net {
>  	struct net_generic __rcu	*gen;
>  
>  	struct bpf_prog __rcu	*flow_dissector_prog;
> +	struct bpf_prog __rcu	*sk_lookup_prog;
>  
>  	/* Note : following structs are cache line aligned */
>  #ifdef CONFIG_XFRM
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b3643e27e264..e4c61b63d4bc 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -187,6 +187,7 @@ enum bpf_prog_type {
>  	BPF_PROG_TYPE_STRUCT_OPS,
>  	BPF_PROG_TYPE_EXT,
>  	BPF_PROG_TYPE_LSM,
> +	BPF_PROG_TYPE_SK_LOOKUP,
>  };
>  
>  enum bpf_attach_type {
> @@ -218,6 +219,7 @@ enum bpf_attach_type {
>  	BPF_TRACE_FEXIT,
>  	BPF_MODIFY_RETURN,
>  	BPF_LSM_MAC,
> +	BPF_SK_LOOKUP,
>  	__MAX_BPF_ATTACH_TYPE
>  };
>  
> @@ -3041,6 +3043,10 @@ union bpf_attr {
>   *
>   * int bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)
>   *	Description
> + *		Helper is overloaded depending on BPF program type. This
> + *		description applies to **BPF_PROG_TYPE_SCHED_CLS** and
> + *		**BPF_PROG_TYPE_SCHED_ACT** programs.
> + *
>   *		Assign the *sk* to the *skb*. When combined with appropriate
>   *		routing configuration to receive the packet towards the socket,
>   *		will cause *skb* to be delivered to the specified socket.
> @@ -3061,6 +3067,39 @@ union bpf_attr {
>   *					call from outside of TC ingress.
>   *		* **-ESOCKTNOSUPPORT**	Socket type not supported (reuseport).
>   *
> + * int bpf_sk_assign(struct bpf_sk_lookup *ctx, struct bpf_sock *sk, u64 flags)
> + *	Description
> + *		Helper is overloaded depending on BPF program type. This
> + *		description applies to **BPF_PROG_TYPE_SK_LOOKUP** programs.
> + *
> + *		Select the *sk* as a result of a socket lookup.
> + *
> + *		For the operation to succeed passed socket must be compatible
> + *		with the packet description provided by the *ctx* object.
> + *
> + *		L4 protocol (*IPPROTO_TCP* or *IPPROTO_UDP*) must be an exact
> + *		match. While IP family (*AF_INET* or *AF_INET6*) must be
> + *		compatible, that is IPv6 sockets that are not v6-only can be
> + *		selected for IPv4 packets.
> + *
> + *		Only full sockets can be selected. However, there is no need to
> + *		call bpf_fullsock() before passing a socket as an argument to
> + *		this helper.
> + *
> + *		The *flags* argument must be zero.
> + *	Return
> + *		0 on success, or a negative errno in case of failure.
> + *
> + *		**-EAFNOSUPPORT** is socket family (*sk->family*) is not
> + *		compatible with packet family (*ctx->family*).
> + *
> + *		**-EINVAL** if unsupported flags were specified.
> + *
> + *		**-EPROTOTYPE** if socket L4 protocol (*sk->protocol*) doesn't
> + *		match packet protocol (*ctx->protocol*).
> + *
> + *		**-ESOCKTNOSUPPORT** if socket is not a full socket.
> + *
>   * u64 bpf_ktime_get_boot_ns(void)
>   * 	Description
>   * 		Return the time elapsed since system boot, in nanoseconds.
> @@ -4012,4 +4051,18 @@ struct bpf_pidns_info {
>  	__u32 pid;
>  	__u32 tgid;
>  };
> +
> +/* User accessible data for SK_LOOKUP programs. Add new fields at the end. */
> +struct bpf_sk_lookup {
> +	__u32 family;		/* AF_INET, AF_INET6 */
> +	__u32 protocol;		/* IPPROTO_TCP, IPPROTO_UDP */
> +	/* IP addresses allows 1, 2, and 4 bytes access */
> +	__u32 src_ip4;
> +	__u32 src_ip6[4];
> +	__u32 src_port;		/* network byte order */
> +	__u32 dst_ip4;
> +	__u32 dst_ip6[4];
> +	__u32 dst_port;		/* host byte order */
> +};
> +
>  #endif /* _UAPI__LINUX_BPF_H__ */
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index bb1ab7da6103..26d643c171fd 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2729,6 +2729,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
>  	case BPF_CGROUP_GETSOCKOPT:
>  	case BPF_CGROUP_SETSOCKOPT:
>  		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
> +	case BPF_SK_LOOKUP:
It may be a good idea to enforce the "expected_attach_type ==
BPF_SK_LOOKUP" during prog load time in bpf_prog_load_check_attach().
The attr->expected_attach_type could be anything right now if I read
it correctly.

> +		return BPF_PROG_TYPE_SK_LOOKUP;
>  	default:
>  		return BPF_PROG_TYPE_UNSPEC;
>  	}
> @@ -2778,6 +2780,9 @@ static int bpf_prog_attach(const union bpf_attr *attr)
>  	case BPF_PROG_TYPE_FLOW_DISSECTOR:
>  		ret = skb_flow_dissector_bpf_prog_attach(attr, prog);
>  		break;
> +	case BPF_PROG_TYPE_SK_LOOKUP:
> +		ret = sk_lookup_prog_attach(attr, prog);
> +		break;
>  	case BPF_PROG_TYPE_CGROUP_DEVICE:
>  	case BPF_PROG_TYPE_CGROUP_SKB:
>  	case BPF_PROG_TYPE_CGROUP_SOCK:
> @@ -2818,6 +2823,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
>  		return lirc_prog_detach(attr);
>  	case BPF_PROG_TYPE_FLOW_DISSECTOR:
>  		return skb_flow_dissector_bpf_prog_detach(attr);
> +	case BPF_PROG_TYPE_SK_LOOKUP:
> +		return sk_lookup_prog_detach(attr);
>  	case BPF_PROG_TYPE_CGROUP_DEVICE:
>  	case BPF_PROG_TYPE_CGROUP_SKB:
>  	case BPF_PROG_TYPE_CGROUP_SOCK:
> @@ -2867,6 +2874,8 @@ static int bpf_prog_query(const union bpf_attr *attr,
>  		return lirc_prog_query(attr, uattr);
>  	case BPF_FLOW_DISSECTOR:
>  		return skb_flow_dissector_prog_query(attr, uattr);
> +	case BPF_SK_LOOKUP:
> +		return sk_lookup_prog_query(attr, uattr);
"# CONFIG_NET is not set" needs to be taken care.

>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/net/core/filter.c b/net/core/filter.c
> index bc25bb1085b1..a00bdc70041c 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -9054,6 +9054,253 @@ const struct bpf_verifier_ops sk_reuseport_verifier_ops = {
>  
>  const struct bpf_prog_ops sk_reuseport_prog_ops = {
>  };
> +
> +static DEFINE_MUTEX(sk_lookup_prog_mutex);
> +
> +int sk_lookup_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> +{
> +	struct net *net = current->nsproxy->net_ns;
> +	int ret;
> +
> +	if (unlikely(attr->attach_flags))
> +		return -EINVAL;
> +
> +	mutex_lock(&sk_lookup_prog_mutex);
> +	ret = bpf_prog_attach_one(&net->sk_lookup_prog,
> +				  &sk_lookup_prog_mutex, prog,
> +				  attr->attach_flags);
> +	mutex_unlock(&sk_lookup_prog_mutex);
> +
> +	return ret;
> +}
> +
> +int sk_lookup_prog_detach(const union bpf_attr *attr)
> +{
> +	struct net *net = current->nsproxy->net_ns;
> +	int ret;
> +
> +	if (unlikely(attr->attach_flags))
> +		return -EINVAL;
> +
> +	mutex_lock(&sk_lookup_prog_mutex);
> +	ret = bpf_prog_detach_one(&net->sk_lookup_prog,
> +				  &sk_lookup_prog_mutex);
> +	mutex_unlock(&sk_lookup_prog_mutex);
> +
> +	return ret;
> +}
> +
> +int sk_lookup_prog_query(const union bpf_attr *attr,
> +			 union bpf_attr __user *uattr)
> +{
> +	struct net *net;
> +	int ret;
> +
> +	net = get_net_ns_by_fd(attr->query.target_fd);
> +	if (IS_ERR(net))
> +		return PTR_ERR(net);
> +
> +	ret = bpf_prog_query_one(&net->sk_lookup_prog, attr, uattr);
> +
> +	put_net(net);
> +	return ret;
> +}
> +
> +BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
> +	   struct sock *, sk, u64, flags)
> +{
> +	if (unlikely(flags != 0))
> +		return -EINVAL;
> +	if (unlikely(!sk_fullsock(sk)))
May be ARG_PTR_TO_SOCKET instead?

> +		return -ESOCKTNOSUPPORT;
> +
> +	/* Check if socket is suitable for packet L3/L4 protocol */
> +	if (sk->sk_protocol != ctx->protocol)
> +		return -EPROTOTYPE;
> +	if (sk->sk_family != ctx->family &&
> +	    (sk->sk_family == AF_INET || ipv6_only_sock(sk)))
> +		return -EAFNOSUPPORT;
> +
> +	/* Select socket as lookup result */
> +	ctx->selected_sk = sk;
Could sk be a TCP_ESTABLISHED sk?

> +	return 0;
> +}
> +
