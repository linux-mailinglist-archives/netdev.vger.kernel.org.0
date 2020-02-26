Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B89E1707F0
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 19:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgBZSr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 13:47:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59752 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726878AbgBZSr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 13:47:26 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 01QIX9LV009747;
        Wed, 26 Feb 2020 10:47:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=fA33lAeoRodG0zABrZlccakyHo3b+gw67fJxr2EKsKs=;
 b=FhGDzbXDV/XeAJWr18Mo9qbAzwYVyOID1ezEd+M8rVrpKe326T19QfWIp+Rll6m6aKlJ
 BhOYReb+7wKg7bWXDs+rqR4DyLFZD6QONkjzFd9JGSY1BZLSqTmceup4tC9yqzxnL7CJ
 nUBl1tq5fp7Ns5V43rctCUjyBHy7WekeFT0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2ydcmumpha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 26 Feb 2020 10:47:12 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 26 Feb 2020 10:47:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eD58jPQzG+snK2zFbg8hAa7Sg/WEmr+TRmI1pPbjXLr3Eqx6oumONmbU1r9nJIMoOOjNMGZqmrvL6Zq5oBcZv5fcIhPKjunirojy5PXkC2Iq+rWjDsd35eZxyhgZwMTNM4Y9orXBasQK4KRU0teirRizjVDHakzOIXAQhK5YDhkiea0lF+P0nLe6LzU4HnUbwO3hMT/7BVuTGnX3wIfiUmVFRYsn+g7eEiq0D/1McRyAOvgPUQG5TDbDdbIy/jISmUVaNpWZ/XUrscAKcgry29bLBdzXIpohpg5M/eO6tZZrbLViL0qc9MeLbIvrElludh0tr73uadIZwJ5BiImX/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fA33lAeoRodG0zABrZlccakyHo3b+gw67fJxr2EKsKs=;
 b=N/4R1P5LMENaTcvbnmRyZVSn41Tzg5U6rjkoypZUv83OXDoT8wtyLc+AxmvndWOBEL6kFhKCYsFHs81JJqX854LvsbZibLQTgFJYVHhsmwd26+rFTMyMWMu85mESOVoEZO3PvXUdUYSlHeXLoazMhhwPQywljFOMiAl7hJfE+YQWjICkytw55heeOMg4mCVSRCw9+viqBA81gPEEX1dwDgwQKgxA4cZBzb7EmLm0RQzmR4yr3sriM7Ed+kN8UOI0ijVFPrjuXGkLnqCOx0tk5erOhv3x8PWwJ1+bsK611mwf7rk+EaHE2z5PmMFsEApL91Nlb4j0YyKu6pB1pb8T/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fA33lAeoRodG0zABrZlccakyHo3b+gw67fJxr2EKsKs=;
 b=GBtfbuvPPktk8IzhLsUaV1a54Bnxf/Do6GX6RWJ0Etd37WKqFgyK7igo67su/vfZHWdxlDPzjXOIE8GfyZ/WG5BuKCavRM2qewe5oGyck07VYRjIFdg7D61uzzT5SoJdfAIgZbJucc6hu9NKMffkQCk7krSHFM/o4Z6grzZ73QA=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2200.namprd15.prod.outlook.com (2603:10b6:a02:89::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21; Wed, 26 Feb
 2020 18:47:10 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 18:47:10 +0000
Date:   Wed, 26 Feb 2020 10:47:07 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next 4/7] bpf: sockmap: allow UDP sockets
Message-ID: <20200226184707.yxtadvqb2cxa4gbs@kafai-mbp>
References: <20200225135636.5768-1-lmb@cloudflare.com>
 <20200225135636.5768-5-lmb@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225135636.5768-5-lmb@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MW2PR2101CA0035.namprd21.prod.outlook.com
 (2603:10b6:302:1::48) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:500::6:997f) by MW2PR2101CA0035.namprd21.prod.outlook.com (2603:10b6:302:1::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.5 via Frontend Transport; Wed, 26 Feb 2020 18:47:09 +0000
X-Originating-IP: [2620:10d:c090:500::6:997f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a56c0fa-0368-4d66-d65f-08d7baec495c
X-MS-TrafficTypeDiagnostic: BYAPR15MB2200:
X-Microsoft-Antispam-PRVS: <BYAPR15MB220056607AFC788531936156D5EA0@BYAPR15MB2200.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:331;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(366004)(39860400002)(136003)(189003)(199004)(6496006)(86362001)(33716001)(478600001)(6916009)(2906002)(5660300002)(52116002)(316002)(81156014)(16526019)(186003)(9686003)(8676002)(4326008)(66946007)(66556008)(1076003)(66476007)(81166006)(8936002)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2200;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MLxJ5CSkGy1NHb9N4xZUJYdw2kTrSap2FDQWesyGTf69tf9/iUBETg6+xryG+VD8ZHLVfrXWlqKlaGB8RHQN9+r2a4mLlV9hyoakzrMiJgYyEsa/guLAHhVrsC5Hvli4MQL+ibeKuSEGAcn5vjRlAJ0KpfpaI1vtuPmEypYyVGc1Nia0F6Kq/dung6u//liO0JCJQDNLNen3n4swFuudZ/qThNwL1v+05Z9O0Chapl84VIfInAaqi4lfSrYVwx36nIGRXT45WLJbXlPrtRA/WMkrcbx8Ccun2SFGDe7vydgAmF0YUU+53xJvdgUJitS4eZYN/MOB1Gm+d5/wsGLrL6m6dgA4QUFaU5ff/b9/mc4O3oO7B1SWddCwK8kduxteTc/7wKS2zB/rsmHqqCvaePdnDYL0Vrrg5yFxHAFgLRf3rCuJBieerODgDIW46K8E
X-MS-Exchange-AntiSpam-MessageData: UgUB1RsyvpuexqPbxcV0p+xCXp1qF6jGA6A/UK+xMX6eIX9qXQW+eCzKqLqDxfXWo3TZxdTx5JEuXlYlvvsSIglqs6cgzJGZn28FczMymN3w2KRI71w6FeHGaLQPTOBLekJrKRISydMBqRVxb2C9Q7T7gxEncLuMY7ti6B6e3Ay/mZN90zib0TFddRZgrNTU
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a56c0fa-0368-4d66-d65f-08d7baec495c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 18:47:10.4772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mc7t0USO727X0rwygs7sJeZMty5JlX43opND587rVpdNurrOk1i7QvEmlaJQUJEd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2200
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_06:2020-02-26,2020-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 adultscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002260117
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 01:56:33PM +0000, Lorenz Bauer wrote:
> Add basic psock hooks for UDP sockets. This allows adding and
> removing sockets, as well as automatic removal on unhash and close.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  MAINTAINERS         |  1 +
>  include/linux/udp.h |  4 ++++
>  net/core/sock_map.c | 47 +++++++++++++++++++++++-----------------
>  net/ipv4/Makefile   |  1 +
>  net/ipv4/udp_bpf.c  | 53 +++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 86 insertions(+), 20 deletions(-)
>  create mode 100644 net/ipv4/udp_bpf.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2af5fa73155e..495ba52038ad 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9358,6 +9358,7 @@ F:	include/linux/skmsg.h
>  F:	net/core/skmsg.c
>  F:	net/core/sock_map.c
>  F:	net/ipv4/tcp_bpf.c
> +F:	net/ipv4/udp_bpf.c
>  
>  LANTIQ / INTEL Ethernet drivers
>  M:	Hauke Mehrtens <hauke@hauke-m.de>
> diff --git a/include/linux/udp.h b/include/linux/udp.h
> index aa84597bdc33..d90d8fd5f73d 100644
> --- a/include/linux/udp.h
> +++ b/include/linux/udp.h
> @@ -143,4 +143,8 @@ static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
>  
>  #define IS_UDPLITE(__sk) (__sk->sk_protocol == IPPROTO_UDPLITE)
>  
> +#if defined(CONFIG_NET_SOCK_MSG)
> +int udp_bpf_init(struct sock *sk);
> +#endif
> +
>  #endif	/* _LINUX_UDP_H */
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index c84cc9fc7f6b..f998192c425f 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -153,7 +153,7 @@ static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
>  	rcu_read_lock();
>  	psock = sk_psock(sk);
>  	if (psock) {
> -		if (sk->sk_prot->recvmsg != tcp_bpf_recvmsg) {
> +		if (sk->sk_prot->close != sock_map_close) {
>  			psock = ERR_PTR(-EBUSY);
>  			goto out;
>  		}
> @@ -166,6 +166,14 @@ static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
>  	return psock;
>  }
>  
> +static int sock_map_init_hooks(struct sock *sk)
> +{
> +	if (sk->sk_type == SOCK_DGRAM)
> +		return udp_bpf_init(sk);
> +	else
> +		return tcp_bpf_init(sk);
> +}
> +
>  static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
>  			 struct sock *sk)
>  {
> @@ -220,7 +228,7 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
>  	if (msg_parser)
>  		psock_set_prog(&psock->progs.msg_parser, msg_parser);
>  
> -	ret = tcp_bpf_init(sk);
> +	ret = sock_map_init_hooks(sk);
>  	if (ret < 0)
>  		goto out_drop;
>  
> @@ -267,7 +275,7 @@ static int sock_map_link_no_progs(struct bpf_map *map, struct sock *sk)
>  		return -ENOMEM;
>  
>  init:
> -	ret = tcp_bpf_init(sk);
> +	ret = sock_map_init_hooks(sk);
>  	if (ret < 0)
>  		sk_psock_put(sk, psock);
>  	return ret;
> @@ -394,9 +402,14 @@ static int sock_map_get_next_key(struct bpf_map *map, void *key, void *next)
>  	return 0;
>  }
>  
> +static bool sock_map_sk_is_tcp(const struct sock *sk)
> +{
> +	return sk->sk_type == SOCK_STREAM && sk->sk_protocol == IPPROTO_TCP;
> +}
> +
>  static bool sock_map_redirect_allowed(const struct sock *sk)
>  {
> -	return sk->sk_state != TCP_LISTEN;
> +	return sock_map_sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN;
>  }
>  
>  static int sock_map_update_common(struct bpf_map *map, u32 idx,
> @@ -466,15 +479,17 @@ static bool sock_map_op_okay(const struct bpf_sock_ops_kern *ops)
>  	       ops->op == BPF_SOCK_OPS_TCP_LISTEN_CB;
>  }
>  
> +static bool sock_map_sk_is_udp(const struct sock *sk)
> +{
> +	return sk->sk_type == SOCK_DGRAM && sk->sk_protocol == IPPROTO_UDP;
> +}
> +
>  static bool sock_map_sk_is_suitable(const struct sock *sk)
>  {
> -	return sk->sk_type == SOCK_STREAM &&
> -	       sk->sk_protocol == IPPROTO_TCP;
> -}
> +	const int tcp_flags = TCPF_ESTABLISHED | TCPF_LISTEN | TCPF_SYN_RECV;
hmm... I thought this patch is for adding UDP only.  However, if I read
it correctly, the tcp_flags is changed (| TCPF_SYN_RECV)?
Please elaborate in the commit message.

>  
> -static bool sock_map_sk_state_allowed(const struct sock *sk)
> -{
> -	return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
> +	return (sock_map_sk_is_udp(sk) && sk_hashed(sk)) ||
> +	       (sock_map_sk_is_tcp(sk) && (1 << sk->sk_state) & tcp_flags);
>  }
>  
>  static int sock_map_update_elem(struct bpf_map *map, void *key,
