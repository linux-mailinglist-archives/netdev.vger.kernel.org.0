Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBE521481A
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 20:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgGDSnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 14:43:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41544 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726791AbgGDSnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 14:43:23 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 064IedNC028752;
        Sat, 4 Jul 2020 11:43:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Qm+lFeuXeAe4C1N0CfBeQjbX33gwn6pxtG01QheGUw0=;
 b=AR5UikScC8ywvJosNA3JUkLt+N68z405IbscjoBWYv+uGUKMgwobQDig6TKWkwlmio5l
 RamwptMu02VSHmEgVzR9VEEhabNKpFUZ1hYWKHbleL8u7Bu3qWqhgumilI+EcMkhsRnA
 jHHPO/FtAp6dHqrKeoaAgkKXW9lWQyjIvq0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 322qgusbkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 04 Jul 2020 11:43:01 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 4 Jul 2020 11:43:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/JBwGpFsziVF9f9dUP5+OGJhO+AWMKd2H5Fu+gyKleLNtEk1xNFKOURNngRnWT3u2uvQHtVMJVkmFYk1gOcwFc5FOl49/aHhA5p9lXKpkDr0dUX9jTJQPwB7Xxpk4WHtSKyS4GmzNnSHEUG4QkP30zwEaNKFQHSOZ7MtY+fVfXedKJL+8pt7xmAPbXBIXp1EfojxUk7XLWlhmaELWfHl1TcK2zlf/fGVe2ORFFBbEKDbFIAyyfXwhoywF/eP+Gsaq0E6H9Xu3rgICAggIVTY5i2qx49yrZ6GFz+aprYk4q6kPan4vYAL3NX5TqhYvh4GRljAHvAHehJ3vky88BOig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qm+lFeuXeAe4C1N0CfBeQjbX33gwn6pxtG01QheGUw0=;
 b=KaeBYvhN7awbmySWnnEbfYFUt4zye6NIzQUMFgHPvpLJF+fQt/NAlXA1sfQHV31dFcSNrXOENMvBdBXGg069/gCLVQt4ZrQB7xaDH9O2xMgKCb/dkp+qokMKwMNTsHC045Mk9wYB5AD992Ay2EoXfYM0JMsB2sJwzDqRJgSefanJ2uuASszZVpOCUoAG2PEAVcXW2D4EK7T6nXdaWx2Nnxe/W59BNPpZmkqyAPEplH6rtLC8Pa2DE2BRJmYpEyCpGRp4rJ5Lxti2wkLAwJOVun/TXy/SPNbSWsO10Fb5n3fP967AnAF7GKYFMl4m+BBvrH95Wtug2tLwHcQ+OwNT2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qm+lFeuXeAe4C1N0CfBeQjbX33gwn6pxtG01QheGUw0=;
 b=BTPdvsnndc6bsHjR9Lwb3DaoldaoqQ0tpHGXs/nWkNVkJWaDhPSRobV/jdlH43DqHnclxurJIi51olOiGXtywXg5pMSZg6fMq7P505aGnS3HNyRlQGkTWUSMIuM217y0iitY4HYJK+PtlJ7UJ6Dk8uaPSoTvDB76NpQFS4Y+Qw0=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3713.namprd15.prod.outlook.com (2603:10b6:a03:1f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Sat, 4 Jul
 2020 18:42:44 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3153.029; Sat, 4 Jul 2020
 18:42:44 +0000
Subject: Re: [PATCH bpf-next v3 02/16] bpf: Introduce SK_LOOKUP program type
 with a dedicated attach point
To:     Jakub Sitnicki <jakub@cloudflare.com>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
References: <20200702092416.11961-1-jakub@cloudflare.com>
 <20200702092416.11961-3-jakub@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e9aab68e-def7-1216-c1cc-c001f70b3e02@fb.com>
Date:   Sat, 4 Jul 2020 11:42:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <20200702092416.11961-3-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0005.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::18) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::106a] (2620:10d:c090:400::5:aacf) by BY5PR16CA0005.namprd16.prod.outlook.com (2603:10b6:a03:1a0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Sat, 4 Jul 2020 18:42:42 +0000
X-Originating-IP: [2620:10d:c090:400::5:aacf]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f92a2a17-98ba-41cb-2188-08d8204a09c9
X-MS-TrafficTypeDiagnostic: BY5PR15MB3713:
X-Microsoft-Antispam-PRVS: <BY5PR15MB371380720E4B1A890EA56A0FD36B0@BY5PR15MB3713.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0454444834
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fArnYU2XGPPNLieVTPsi4wTY/TXTr6bBTXFKdjzj4l0dYxnW1qKP65tQuFwjLuiMTNYKEtJHkgq68YVVyieD5TyAVwbLjDHFKkslr6dYbvVbIwJYc1CTVxCc0m1NE00rSwdmmdDnryEtc17k57Sc0Z9oRu3kgq2fvVuw+Iqu9AptmsBhqE567Bd0r0o+aLko0SlJ34umdd4K6iirq7e/psyUM4bpl2E3vHTLvmiqUOmy5V9wRG2mUbvLSQl4nEj1UT/GsO48wG1G1hQsJIDxK+shKqPG3xU7qpco6k2xentZzqPU4FWQsm9LEHRUP9wU831CpNs5uOuhZeRMcWK2pFCBrRK0ghuZZYrJYyJcP6+txVSZzYkpqHXz6NU6Joox
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(366004)(346002)(396003)(376002)(186003)(16526019)(53546011)(6486002)(2906002)(83380400001)(66556008)(66476007)(66946007)(30864003)(36756003)(2616005)(86362001)(8676002)(478600001)(31696002)(8936002)(52116002)(5660300002)(4326008)(316002)(54906003)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 6ZiKpoUWkGxX4eEr+NvmFoPy9WEQve96uNVgBtVOXvOEtQiEKx8ODN1/QbHnRSUBd97Ud1YPD9q/zkzYRMfFOkbVg/UIiRZcQwmF9GyoSHAwVhhHmzuqTzN8DEVg9lz8B+SbefO7C5fUh/6E2ltVBK/gSKdLYzXDnpGUoVzT3E6RVvv+VHCISJHhH2sN6pLWS40lrh3C7COcLLUlBrytbvaNkG0u0jCGR3/IiYvOUoeBYw4BSaA15ms9vgQNnqzW8whJ/QkVANEvhzQWTa8AwrMzMXFkLolCN55SsKwImNl7ZZ3toY5lm/QwB8IbdsXIBmKayCXWuFA5PJBMCX50b72ZmK5pS+iNsFLgIuykixtmSV3gT/I0UJjY0N1n/HqKB5XhksMXPQdrBqHndRQx4eae/uhcCHiQOkV4tWPVpA1d+TuVxEk1ftosEu95vUDCJORrOmznCsWF9VHmwdg9n1+BhMApUmJnV4Sqv8vgN0Kve2cnf9zwSmebbefdVa9h/LCqPiAoIKY/IxG8VTyT5A==
X-MS-Exchange-CrossTenant-Network-Message-Id: f92a2a17-98ba-41cb-2188-08d8204a09c9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2020 18:42:43.8849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s2De8glXJlNcx6WGF59WetFnZA2JGeJ9liv410dMv9OqcX2o9bNYdzpFLfac8NpB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3713
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-04_15:2020-07-02,2020-07-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0 spamscore=0
 impostorscore=0 cotscore=-2147483648 malwarescore=0 phishscore=0
 mlxscore=0 priorityscore=1501 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007040129
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/2/20 2:24 AM, Jakub Sitnicki wrote:
> Add a new program type BPF_PROG_TYPE_SK_LOOKUP with a dedicated attach type
> BPF_SK_LOOKUP. The new program kind is to be invoked by the transport layer
> when looking up a listening socket for a new connection request for
> connection oriented protocols, or when looking up an unconnected socket for
> a packet for connection-less protocols.
> 
> When called, SK_LOOKUP BPF program can select a socket that will receive
> the packet. This serves as a mechanism to overcome the limits of what
> bind() API allows to express. Two use-cases driving this work are:
> 
>   (1) steer packets destined to an IP range, on fixed port to a socket
> 
>       192.0.2.0/24, port 80 -> NGINX socket
> 
>   (2) steer packets destined to an IP address, on any port to a socket
> 
>       198.51.100.1, any port -> L7 proxy socket
> 
> In its run-time context program receives information about the packet that
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
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
> 
> Notes:
>      v3:
>      - Allow bpf_sk_assign helper to replace previously selected socket only
>        when BPF_SK_LOOKUP_F_REPLACE flag is set, as a precaution for multiple
>        programs running in series to accidentally override each other's verdict.
>      - Let BPF program decide that load-balancing within a reuseport socket group
>        should be skipped for the socket selected with bpf_sk_assign() by passing
>        BPF_SK_LOOKUP_F_NO_REUSEPORT flag. (Martin)
>      - Extend struct bpf_sk_lookup program context with an 'sk' field containing
>        the selected socket with an intention for multiple attached program
>        running in series to see each other's choices. However, currently the
>        verifier doesn't allow checking if pointer is set.
>      - Use bpf-netns infra for link-based multi-program attachment. (Alexei)
>      - Get rid of macros in convert_ctx_access to make it easier to read.
>      - Disallow 1-,2-byte access to context fields containing IP addresses.
>      
>      v2:
>      - Make bpf_sk_assign reject sockets that don't use RCU freeing.
>        Update bpf_sk_assign docs accordingly. (Martin)
>      - Change bpf_sk_assign proto to take PTR_TO_SOCKET as argument. (Martin)
>      - Fix broken build when CONFIG_INET is not selected. (Martin)
>      - Rename bpf_sk_lookup{} src_/dst_* fields remote_/local_*. (Martin)
>      - Enforce BPF_SK_LOOKUP attach point on load & attach. (Martin)
> 
>   include/linux/bpf-netns.h  |   3 +
>   include/linux/bpf_types.h  |   2 +
>   include/linux/filter.h     |  19 ++++
>   include/uapi/linux/bpf.h   |  74 +++++++++++++++
>   kernel/bpf/net_namespace.c |   5 +
>   kernel/bpf/syscall.c       |   9 ++
>   net/core/filter.c          | 186 +++++++++++++++++++++++++++++++++++++
>   scripts/bpf_helpers_doc.py |   9 +-
>   8 files changed, 306 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/bpf-netns.h b/include/linux/bpf-netns.h
> index 4052d649f36d..cb1d849c5d4f 100644
> --- a/include/linux/bpf-netns.h
> +++ b/include/linux/bpf-netns.h
> @@ -8,6 +8,7 @@
>   enum netns_bpf_attach_type {
>   	NETNS_BPF_INVALID = -1,
>   	NETNS_BPF_FLOW_DISSECTOR = 0,
> +	NETNS_BPF_SK_LOOKUP,
>   	MAX_NETNS_BPF_ATTACH_TYPE
>   };
>   
> @@ -17,6 +18,8 @@ to_netns_bpf_attach_type(enum bpf_attach_type attach_type)
>   	switch (attach_type) {
>   	case BPF_FLOW_DISSECTOR:
>   		return NETNS_BPF_FLOW_DISSECTOR;
> +	case BPF_SK_LOOKUP:
> +		return NETNS_BPF_SK_LOOKUP;
>   	default:
>   		return NETNS_BPF_INVALID;
>   	}
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index a18ae82a298a..a52a5688418e 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -64,6 +64,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2,
>   #ifdef CONFIG_INET
>   BPF_PROG_TYPE(BPF_PROG_TYPE_SK_REUSEPORT, sk_reuseport,
>   	      struct sk_reuseport_md, struct sk_reuseport_kern)
> +BPF_PROG_TYPE(BPF_PROG_TYPE_SK_LOOKUP, sk_lookup,
> +	      struct bpf_sk_lookup, struct bpf_sk_lookup_kern)
>   #endif
>   #if defined(CONFIG_BPF_JIT)
>   BPF_PROG_TYPE(BPF_PROG_TYPE_STRUCT_OPS, bpf_struct_ops,
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 259377723603..ba4f8595fa54 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -1278,4 +1278,23 @@ struct bpf_sockopt_kern {
>   	s32		retval;
>   };
>   
> +struct bpf_sk_lookup_kern {
> +	u16		family;
> +	u16		protocol;
> +	union {
> +		struct {
> +			__be32 saddr;
> +			__be32 daddr;
> +		} v4;
> +		struct {
> +			const struct in6_addr *saddr;
> +			const struct in6_addr *daddr;
> +		} v6;
> +	};
> +	__be16		sport;
> +	u16		dport;
> +	struct sock	*selected_sk;
> +	bool		no_reuseport;
> +};
> +
>   #endif /* __LINUX_FILTER_H__ */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 0cb8ec948816..8dd6e6ce5de9 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -189,6 +189,7 @@ enum bpf_prog_type {
>   	BPF_PROG_TYPE_STRUCT_OPS,
>   	BPF_PROG_TYPE_EXT,
>   	BPF_PROG_TYPE_LSM,
> +	BPF_PROG_TYPE_SK_LOOKUP,
>   };
>   
>   enum bpf_attach_type {
> @@ -226,6 +227,7 @@ enum bpf_attach_type {
>   	BPF_CGROUP_INET4_GETSOCKNAME,
>   	BPF_CGROUP_INET6_GETSOCKNAME,
>   	BPF_XDP_DEVMAP,
> +	BPF_SK_LOOKUP,
>   	__MAX_BPF_ATTACH_TYPE
>   };
>   
> @@ -3067,6 +3069,10 @@ union bpf_attr {
>    *
>    * long bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)
>    *	Description
> + *		Helper is overloaded depending on BPF program type. This
> + *		description applies to **BPF_PROG_TYPE_SCHED_CLS** and
> + *		**BPF_PROG_TYPE_SCHED_ACT** programs.
> + *
>    *		Assign the *sk* to the *skb*. When combined with appropriate
>    *		routing configuration to receive the packet towards the socket,
>    *		will cause *skb* to be delivered to the specified socket.
> @@ -3092,6 +3098,53 @@ union bpf_attr {
>    *		**-ESOCKTNOSUPPORT** if the socket type is not supported
>    *		(reuseport).
>    *
> + * int bpf_sk_assign(struct bpf_sk_lookup *ctx, struct bpf_sock *sk, u64 flags)

recently, we have changed return value from "int" to "long" if the 
helper intends to return a negative error. See above
    long bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)

> + *	Description
> + *		Helper is overloaded depending on BPF program type. This
> + *		description applies to **BPF_PROG_TYPE_SK_LOOKUP** programs.
> + *
> + *		Select the *sk* as a result of a socket lookup.
> + *
> + *		For the operation to succeed passed socket must be compatible
> + *		with the packet description provided by the *ctx* object.
> + *
> + *		L4 protocol (**IPPROTO_TCP** or **IPPROTO_UDP**) must
> + *		be an exact match. While IP family (**AF_INET** or
> + *		**AF_INET6**) must be compatible, that is IPv6 sockets
> + *		that are not v6-only can be selected for IPv4 packets.
> + *
> + *		Only TCP listeners and UDP unconnected sockets can be
> + *		selected.
> + *
> + *		*flags* argument can combination of following values:
> + *
> + *		* **BPF_SK_LOOKUP_F_REPLACE** to override the previous
> + *		  socket selection, potentially done by a BPF program
> + *		  that ran before us.
> + *
> + *		* **BPF_SK_LOOKUP_F_NO_REUSEPORT** to skip
> + *		  load-balancing within reuseport group for the socket
> + *		  being selected.
> + *
> + *	Return
> + *		0 on success, or a negative errno in case of failure.
> + *
> + *		* **-EAFNOSUPPORT** if socket family (*sk->family*) is
> + *		  not compatible with packet family (*ctx->family*).
> + *
> + *		* **-EEXIST** if socket has been already selected,
> + *		  potentially by another program, and
> + *		  **BPF_SK_LOOKUP_F_REPLACE** flag was not specified.
> + *
> + *		* **-EINVAL** if unsupported flags were specified.
> + *
> + *		* **-EPROTOTYPE** if socket L4 protocol
> + *		  (*sk->protocol*) doesn't match packet protocol
> + *		  (*ctx->protocol*).
> + *
> + *		* **-ESOCKTNOSUPPORT** if socket is not in allowed
> + *		  state (TCP listening or UDP unconnected).
> + *
[...]
> +static bool sk_lookup_is_valid_access(int off, int size,
> +				      enum bpf_access_type type,
> +				      const struct bpf_prog *prog,
> +				      struct bpf_insn_access_aux *info)
> +{
> +	if (off < 0 || off >= sizeof(struct bpf_sk_lookup))
> +		return false;
> +	if (off % size != 0)
> +		return false;
> +	if (type != BPF_READ)
> +		return false;
> +
> +	switch (off) {
> +	case bpf_ctx_range(struct bpf_sk_lookup, family):
> +	case bpf_ctx_range(struct bpf_sk_lookup, protocol):
> +	case bpf_ctx_range(struct bpf_sk_lookup, remote_ip4):
> +	case bpf_ctx_range(struct bpf_sk_lookup, local_ip4):
> +	case bpf_ctx_range_till(struct bpf_sk_lookup, remote_ip6[0], remote_ip6[3]):
> +	case bpf_ctx_range_till(struct bpf_sk_lookup, local_ip6[0], local_ip6[3]):
> +	case bpf_ctx_range(struct bpf_sk_lookup, remote_port):
> +	case bpf_ctx_range(struct bpf_sk_lookup, local_port):
> +		return size == sizeof(__u32);

Maybe some of the above forcing 4-byte access too restrictive?
For example, if user did
    __u16 *remote_port = ctx->remote_port;
    __u16 *local_port = ctx->local_port;
compiler is likely to generate a 2-byte load and the verifier
will reject the program. The same for protocol, family, ...
Even for local_ip4, user may just want to read one byte to
do something ...

One example, bpf_sock_addr->user_port.

We have numerous instances like this and kernel has to be
patched to permit it later.

I think for read we should allow 1/2/4 byte accesses
whenever possible. pointer of course not allowed.

> +
> +	case offsetof(struct bpf_sk_lookup, sk):
> +		info->reg_type = PTR_TO_SOCKET;
> +		return size == sizeof(__u64);
> +
> +	default:
> +		return false;
> +	}
> +}
> +
> +static u32 sk_lookup_convert_ctx_access(enum bpf_access_type type,
> +					const struct bpf_insn *si,
> +					struct bpf_insn *insn_buf,
> +					struct bpf_prog *prog,
> +					u32 *target_size)
> +{
> +	struct bpf_insn *insn = insn_buf;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	int off;
> +#endif
> +
> +	switch (si->off) {
> +	case offsetof(struct bpf_sk_lookup, family):
> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, family) != 2);
> +
> +		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, family));
> +		break;
> +
> +	case offsetof(struct bpf_sk_lookup, protocol):
> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, protocol) != 2);
> +
> +		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, protocol));
> +		break;
> +
> +	case offsetof(struct bpf_sk_lookup, remote_ip4):
> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, v4.saddr) != 4);
> +
> +		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, v4.saddr));
> +		break;
> +
> +	case offsetof(struct bpf_sk_lookup, local_ip4):
> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, v4.daddr) != 4);
> +
> +		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, v4.daddr));
> +		break;
> +
> +	case bpf_ctx_range_till(struct bpf_sk_lookup,
> +				remote_ip6[0], remote_ip6[3]):
> +#if IS_ENABLED(CONFIG_IPV6)
> +		BUILD_BUG_ON(sizeof_field(struct in6_addr, s6_addr32[0]) != 4);
> +
> +		off = si->off;
> +		off -= offsetof(struct bpf_sk_lookup, remote_ip6[0]);
> +		off += offsetof(struct in6_addr, s6_addr32[0]);
> +		*insn++ = BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, v6.saddr));
> +		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg, off);
> +#else
> +		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
> +#endif
> +		break;
> +
> +	case bpf_ctx_range_till(struct bpf_sk_lookup,
> +				local_ip6[0], local_ip6[3]):
> +#if IS_ENABLED(CONFIG_IPV6)
> +		BUILD_BUG_ON(sizeof_field(struct in6_addr, s6_addr32[0]) != 4);
> +
> +		off = si->off;
> +		off -= offsetof(struct bpf_sk_lookup, local_ip6[0]);
> +		off += offsetof(struct in6_addr, s6_addr32[0]);
> +		*insn++ = BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, v6.daddr));
> +		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg, off);
> +#else
> +		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
> +#endif
> +		break;
> +
> +	case offsetof(struct bpf_sk_lookup, remote_port):
> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, sport) != 2);
> +
> +		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, sport));
> +		break;
> +
> +	case offsetof(struct bpf_sk_lookup, local_port):
> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, dport) != 2);
> +
> +		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, dport));
> +		break;
> +
> +	case offsetof(struct bpf_sk_lookup, sk):
> +		*insn++ = BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, selected_sk));
> +		break;
> +	}
> +
> +	return insn - insn_buf;
> +}
> +
> +const struct bpf_prog_ops sk_lookup_prog_ops = {
> +};
> +
> +const struct bpf_verifier_ops sk_lookup_verifier_ops = {
> +	.get_func_proto		= sk_lookup_func_proto,
> +	.is_valid_access	= sk_lookup_is_valid_access,
> +	.convert_ctx_access	= sk_lookup_convert_ctx_access,
> +};
> +
>   #endif /* CONFIG_INET */
>   
>   DEFINE_BPF_DISPATCHER(xdp)
[...]
