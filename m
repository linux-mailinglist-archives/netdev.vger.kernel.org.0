Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34D1B1707D1
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 19:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgBZSiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 13:38:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63998 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726789AbgBZSiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 13:38:06 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QIZHgC025048;
        Wed, 26 Feb 2020 10:37:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=mOtEbXcYY/OWQ7peQ4TFfGiNvAGLdfzubgdx8JzSB7A=;
 b=SVziu2buamMjhf20E+mEb3FxQNgeT7eGso+YqhF08++vxrS8ChLSI0qIVQVehuvuXGQA
 8uqrkM9aSxQuKsG22//mHgwinr/0jEPv54sD2mCeCfgAF8rh6Z3ikrmPSF56LDOLI9nN
 kOOqlVg3gLI9dLSuWvAXQsExtdzQcsYsiJM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ydcj0vmud-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 26 Feb 2020 10:37:52 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 26 Feb 2020 10:37:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWpB69veJchePfihPOxhbbxlZIjO8IsCNoFgkKLim6hEXC5apYtK+ueR1YAnZdfwDPNKQcUpdlsAy2tsgaycapqP/nepDZVxxDznVcyRdbmSg0EAgT/Pg0qwoYMtPJTTKG82+EDKEKdO+QPhEHxgvNITpmexEJ4MaW1QiMIHrTizy1lebJNUOqVmtSSYeewDVn84AniYoMSbYgjTMO2f8Vcx/ptDAeV+eLv1ZsBclQOfIhD21dokVXt+9jEv/VPXWkmhpBkGcQOLVRh4l4I/x0wY5whngYjKjFFAkYhyxfDoMwmkXTkb8edDQs7435usvXReKtbTSfJi+0rcQs4nAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOtEbXcYY/OWQ7peQ4TFfGiNvAGLdfzubgdx8JzSB7A=;
 b=Hqd6yvxwhYUCdqzQy1msAHzIHAKBDeHBkQ/Oxs2/w0uPm6ZT/6cjsPX3NDo6qt6TNZHmjwyPR16r0D6A6Mu8mBfNCuuMQgF51WUj7CTbznUukddkNJ908m8QsX9DfvEfhhOKehIScBdSdwnfPWYA/H1uAOj6OujRE0X1Rd9I+mp5U/pT/k4gaD76rYwRcjhhhDJgKWovNCKl9My34vmcqdpyKV3rei7ssNQ/Q80k/zsczZdwf/oMslky+IJnZT6A57KELPM0CLXyCW1VURY9D0fjj4IVgaXAG4fqWtQIOAO1udBsedXzfmj3KGQQr5npri/Q4rZRt2ziQVDQ5AK3ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOtEbXcYY/OWQ7peQ4TFfGiNvAGLdfzubgdx8JzSB7A=;
 b=XkQiHEFQNl7u6afT3k3p5lLtUuB1WJSbchjBQqVaFZjwBD9rVQbhTUM570M20An7cxYnmlP5c7Nomtd2n+iC+rMj1ybc6IgBdwMqqOR9X8Jhj/eYqlWhNXR/Np3XAwYi2gORdl1wPwkfYTRV8XHt/n1S4rhBT4VeNrxfQgzoVkY=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB3431.namprd15.prod.outlook.com (2603:10b6:a03:108::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21; Wed, 26 Feb
 2020 18:37:50 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 18:37:49 +0000
Date:   Wed, 26 Feb 2020 10:37:46 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next 3/7] skmsg: introduce sk_psock_hooks
Message-ID: <20200226183746.wvkp2mrstotyepyc@kafai-mbp>
References: <20200225135636.5768-1-lmb@cloudflare.com>
 <20200225135636.5768-4-lmb@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225135636.5768-4-lmb@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: CO2PR04CA0111.namprd04.prod.outlook.com
 (2603:10b6:104:7::13) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:500::6:997f) by CO2PR04CA0111.namprd04.prod.outlook.com (2603:10b6:104:7::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 18:37:48 +0000
X-Originating-IP: [2620:10d:c090:500::6:997f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d205a75-6fe0-4162-10ec-08d7baeafac1
X-MS-TrafficTypeDiagnostic: BYAPR15MB3431:
X-Microsoft-Antispam-PRVS: <BYAPR15MB34314A835BC7E5F4702E20DDD5EA0@BYAPR15MB3431.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(376002)(39860400002)(366004)(199004)(189003)(6496006)(316002)(8676002)(52116002)(478600001)(2906002)(81166006)(81156014)(16526019)(186003)(6916009)(1076003)(86362001)(66556008)(66476007)(4326008)(66946007)(9686003)(33716001)(55016002)(5660300002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3431;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6gr2LXOnW9bZpQdgxwM1OOwThU0tCFPr0VoDmTicGW38ucfSAaJ9zJmD3L2QIOkOicKO2UUpWJ7v3xkewZGFe5V+JEATx4pzVvSJe0zD0MUEnLwQGnU6mr4oZ6HqnDdGOd3JVb+4fNmLOiuNfsFR92iNZ/NvmBwaw9qEVVz9k79fGWFf3w8Nq9j38r+l0pxwz22NLr7a18hQ0YgxfAED5ZamuGT+oU5DV7m+pZvNt5Zb+U+3X0tAk/T6Nn0Q2xJn+12HFkbLrSG/0MX3agNcNg/frtRAP1fmHAQDIzlbWE3gqbpXpkDl/er/KrrsmhR7yf90kFMDV7qWxPyvk1HHS2/bI0+txJTj3ZOQ6BR3g1qMdN88rkkr17+UTXm2SmCMDSVwhfXM4vi4d7VxxK/qzPUKyEJa2H/xEV29BWWA73CsYtDclUxwyjEUJCHirPd1
X-MS-Exchange-AntiSpam-MessageData: BJBSlUEch34/kQLrBBLTyUGjjNEKyipSmulgTIqWi0bBdFFJ5lHbEMJjbaGnlGtpPB3VNVVIjaR+S5kxCsLPaNbfNZ47g0UVH3esycJar60AW3tDR3ogyySiM1LY3Hh8wXE0fRmutM/oaJzYEhw9J+iDZ7uY48pbR4fu05ZXfw/zst25xOT/48iqtE3/3rtw
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d205a75-6fe0-4162-10ec-08d7baeafac1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 18:37:49.6440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MlB9cpoX+fXzpXMjw/S57UM0LojQX0TZX12sZJ8zXLoAIXCK5tKhiAbFvbl0r0Ua
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3431
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_07:2020-02-26,2020-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=2 phishscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 mlxlogscore=799 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002260117
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 01:56:32PM +0000, Lorenz Bauer wrote:
> The sockmap works by overriding some of the callbacks in sk->sk_prot, while
> leaving others untouched. This means that we need access to the struct proto
> for any protocol we want to support. For IPv4 this is trivial, since both
> TCP and UDP are always compiled in. IPv6 may be disabled or compiled as a
> module, so the existing TCP sockmap hooks use some trickery to lazily
> initialize the modified struct proto for TCPv6.
> 
> Pull this logic into a standalone struct sk_psock_hooks, so that it can be
> re-used by UDP sockmap.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  include/linux/skmsg.h |  36 ++++++++-----
>  include/net/tcp.h     |   1 -
>  net/core/skmsg.c      |  52 +++++++++++++++++++
>  net/core/sock_map.c   |  24 ++++-----
>  net/ipv4/tcp_bpf.c    | 114 ++++++++++++------------------------------
>  5 files changed, 116 insertions(+), 111 deletions(-)
> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index c881094387db..70d65ab10b5c 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -109,6 +109,16 @@ struct sk_psock {
>  	};
>  };
>  
> +struct sk_psock_hooks {
> +	struct proto *base_ipv6;
> +	struct proto *ipv4;
> +	struct proto *ipv6;
> +	spinlock_t ipv6_lock;
> +	int (*rebuild_proto)(struct proto prot[], struct proto *base);
> +	struct proto *(*choose_proto)(struct proto prot[],
> +				      struct sk_psock *psock);
> +};
> +
>  int sk_msg_alloc(struct sock *sk, struct sk_msg *msg, int len,
>  		 int elem_first_coalesce);
>  int sk_msg_clone(struct sock *sk, struct sk_msg *dst, struct sk_msg *src,
> @@ -335,23 +345,14 @@ static inline void sk_psock_cork_free(struct sk_psock *psock)
>  	}
>  }
>  
> -static inline void sk_psock_update_proto(struct sock *sk,
> -					 struct sk_psock *psock,
> -					 struct proto *ops)
> -{
> -	psock->saved_unhash = sk->sk_prot->unhash;
> -	psock->saved_close = sk->sk_prot->close;
> -	psock->saved_write_space = sk->sk_write_space;
> -
> -	psock->sk_proto = sk->sk_prot;
> -	/* Pairs with lockless read in sk_clone_lock() */
> -	WRITE_ONCE(sk->sk_prot, ops);
> -}
> -
>  static inline void sk_psock_restore_proto(struct sock *sk,
>  					  struct sk_psock *psock)
>  {
> +	if (!psock->sk_proto)
> +		return;
> +
>  	sk->sk_prot->unhash = psock->saved_unhash;
> +
>  	if (inet_sk(sk)->is_icsk) {
>  		tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
>  	} else {
> @@ -424,4 +425,13 @@ static inline void psock_progs_drop(struct sk_psock_progs *progs)
>  	psock_set_prog(&progs->skb_verdict, NULL);
>  }
>  
> +static inline int sk_psock_hooks_init(struct sk_psock_hooks *hooks,
> +				       struct proto *ipv4_base)
> +{
> +	hooks->ipv6_lock = __SPIN_LOCK_UNLOCKED();
> +	return hooks->rebuild_proto(hooks->ipv4, ipv4_base);
> +}
> +
> +int sk_psock_hooks_install(struct sk_psock_hooks *hooks, struct sock *sk);
> +
>  #endif /* _LINUX_SKMSG_H */
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 07f947cc80e6..ccf39d80b695 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -2196,7 +2196,6 @@ struct sk_msg;
>  struct sk_psock;
>  
>  int tcp_bpf_init(struct sock *sk);
> -void tcp_bpf_reinit(struct sock *sk);
>  int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg, u32 bytes,
>  			  int flags);
>  int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index eeb28cb85664..a9bdf02c2539 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -844,3 +844,55 @@ void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
>  	strp_stop(&parser->strp);
>  	parser->enabled = false;
>  }
> +
> +static inline int sk_psock_hooks_init_ipv6(struct sk_psock_hooks *hooks,
> +					    struct proto *base)
> +{
> +	int ret = 0;
> +
> +	if (likely(base == smp_load_acquire(&hooks->base_ipv6)))
> +		return 0;
> +
> +	spin_lock_bh(&hooks->ipv6_lock);
> +	if (likely(base != hooks->base_ipv6)) {
> +		ret = hooks->rebuild_proto(hooks->ipv6, base);
> +		if (!ret)
> +			smp_store_release(&hooks->base_ipv6, base);
> +	}
> +	spin_unlock_bh(&hooks->ipv6_lock);
> +	return ret;
> +}
> +
> +int sk_psock_hooks_install(struct sk_psock_hooks *hooks, struct sock *sk)
> +{
> +	struct sk_psock *psock = sk_psock(sk);
> +	struct proto *prot_base;
> +
> +	WARN_ON_ONCE(!rcu_read_lock_held());
Is this only for the earlier sk_psock(sk)?

> +
> +	if (unlikely(!psock))
When will this happen?

> +		return -EINVAL;
> +
> +	/* Initialize saved callbacks and original proto only once.
> +	 * Since we've not installed the hooks, psock is not yet in use and
> +	 * we can initialize it without synchronization.
> +	 */
> +	if (!psock->sk_proto) {
If I read it correctly, this is to replace the tcp_bpf_reinit_sk_prot()?

I think some of the current reinit comment is useful to keep also:

/* Reinit occurs when program types change e.g. TCP_BPF_TX is removed ... */

> +		struct proto *prot = READ_ONCE(sk->sk_prot);
> +
> +		if (sk->sk_family == AF_INET6 &&
> +		    sk_psock_hooks_init_ipv6(hooks, prot))
> +			return -EINVAL;
> +
> +		psock->saved_unhash = prot->unhash;
> +		psock->saved_close = prot->close;
> +		psock->saved_write_space = sk->sk_write_space;
> +
> +		psock->sk_proto = prot;
> +	}
> +
> +	/* Pairs with lockless read in sk_clone_lock() */
> +	prot_base = sk->sk_family == AF_INET ? hooks->ipv4 : hooks->ipv6;
> +	WRITE_ONCE(sk->sk_prot, hooks->choose_proto(prot_base, psock));
> +	return 0;
> +}
