Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757E75A18D6
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242941AbiHYSgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbiHYSgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:36:40 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598CA8C02D
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:36:39 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id c135-20020a624e8d000000b0053617082770so7653797pfb.8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=oyBXURF9YG/v27ncFf/mRCNlp5AuCrFo5WlVihsTHZc=;
        b=q/sFBEeicreJT0ZJyAMqOX2kQ8JCPWupA5flHhu+YhY4RKUjoUV7OHHjChV0GGV7Vk
         /EbRjU1XvaLcfVfs6wIKlnaJ+A5ZOklZ4e79KhSFST8SXVgUsEs8aMJkXku2vElZpf+/
         gBCenj1/vRxTa65Jv1o7JRCSzgr7Hp20m17U+LSj9qlCL+CrUZ/XEFOKvD9uMff2stDh
         4PiLvE35NVErn/mbsP2BgmY3NcE+yZZe0lNHNCkEAloNCR/sjsnLuK2GZhpDgM0bLD6N
         cNiRs8RXHufosnBmsHYnvYAnbOYaJoRKiPNh3y2a6/cXhf7gh9zk00T8WMDQODjDwiu7
         tzKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=oyBXURF9YG/v27ncFf/mRCNlp5AuCrFo5WlVihsTHZc=;
        b=i5WgQgBaAms7D4BuRbOICgvzCPzUqXhK0yqw9B0ixyfItY44Zdys1q/lFs+WqixNcw
         /xWhUHwcV4jFuaBpTq/s637FVpyUPnOhIp+vaUyRrh7HxSMIFGDwnHB7HKzNDDlUBkK5
         9AsOgtRX8DbwX8ElnXJqKMlH8I57CAOTa1w1Ks0BpCrYn16jI9/UCs3Ug544wTRuskdN
         eASjcTWrO6z1Jtblp1c+bfLaBso9l7P3Nq0W1pyYZoJpvmoasqpaim0g9BCUt4HGzrRA
         pcczD9uTz83Q1+FWjTpZysNHBC4IXGhU4K6BjUf7258fFhhBnxIU5t34KV2WRyx5s4Gq
         bdhA==
X-Gm-Message-State: ACgBeo1CnwwRTxMChcnM1NSmCrfatakomRXWI+3JC7DCUJsgBB4/B6EO
        0YKYgDKgfZ97MBNv75Um6hZPu4Q=
X-Google-Smtp-Source: AA6agR7lA7T076hyKsjD+WyQZZVjwg/mVPh8akWx95M4BIv2vR/pr8c8mjBADKv+UnKjo1ktYmDCmmQ=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:10cf:b0:528:48c3:79e0 with SMTP id
 d15-20020a056a0010cf00b0052848c379e0mr334339pfu.18.1661452598753; Thu, 25 Aug
 2022 11:36:38 -0700 (PDT)
Date:   Thu, 25 Aug 2022 11:36:36 -0700
In-Reply-To: <20220824222730.1923992-1-kafai@fb.com>
Mime-Version: 1.0
References: <20220824222601.1916776-1-kafai@fb.com> <20220824222730.1923992-1-kafai@fb.com>
Message-ID: <YwfBNEVrxkafzpYE@google.com>
Subject: Re: [PATCH bpf-next 14/17] bpf: Change bpf_getsockopt(SOL_TCP) to
 reuse do_tcp_getsockopt()
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/24, Martin KaFai Lau wrote:
> This patch changes bpf_getsockopt(SOL_TCP) to reuse
> do_tcp_getsockopt().  It removes the duplicated code from
> bpf_getsockopt(SOL_TCP).

> Before this patch, there were some optnames available to
> bpf_setsockopt(SOL_TCP) but missing in bpf_getsockopt(SOL_TCP).
> For example, TCP_NODELAY, TCP_MAXSEG, TCP_KEEPIDLE, TCP_KEEPINTVL,
> and a few more.  It surprises users from time to time.  This patch
> automatically closes this gap without duplicating more code.

> bpf_getsockopt(TCP_SAVED_SYN) does not free the saved_syn,
> so it stays in sol_tcp_sockopt().

> For string name value like TCP_CONGESTION, bpf expects it
> is always null terminated, so sol_tcp_sockopt() decrements
> optlen by one before calling do_tcp_getsockopt() and
> the 'if (optlen < saved_optlen) memset(..,0,..);'
> in __bpf_getsockopt() will always do a null termination.

> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>   include/net/tcp.h |  2 ++
>   net/core/filter.c | 70 ++++++++++++++++++++++++++---------------------
>   net/ipv4/tcp.c    |  4 +--
>   3 files changed, 43 insertions(+), 33 deletions(-)

> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index c03a50c72f40..735e957f7f4b 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -402,6 +402,8 @@ void tcp_init_sock(struct sock *sk);
>   void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb);
>   __poll_t tcp_poll(struct file *file, struct socket *sock,
>   		      struct poll_table_struct *wait);
> +int do_tcp_getsockopt(struct sock *sk, int level,
> +		      int optname, sockptr_t optval, sockptr_t optlen);
>   int tcp_getsockopt(struct sock *sk, int level, int optname,
>   		   char __user *optval, int __user *optlen);
>   bool tcp_bpf_bypass_getsockopt(int level, int optname);
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 68b52243b306..cdbbcec46e8b 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5096,8 +5096,9 @@ static int bpf_sol_tcp_setsockopt(struct sock *sk,  
> int optname,
>   	return 0;
>   }

> -static int sol_tcp_setsockopt(struct sock *sk, int optname,
> -			      char *optval, int optlen)
> +static int sol_tcp_sockopt(struct sock *sk, int optname,
> +			   char *optval, int *optlen,
> +			   bool getopt)
>   {
>   	if (sk->sk_prot->setsockopt != tcp_setsockopt)
>   		return -EINVAL;
> @@ -5114,17 +5115,47 @@ static int sol_tcp_setsockopt(struct sock *sk,  
> int optname,
>   	case TCP_USER_TIMEOUT:
>   	case TCP_NOTSENT_LOWAT:
>   	case TCP_SAVE_SYN:
> -		if (optlen != sizeof(int))
> +		if (*optlen != sizeof(int))
>   			return -EINVAL;
>   		break;

[..]

>   	case TCP_CONGESTION:
> +		if (*optlen < 2)
> +			return -EINVAL;
> +		break;
> +	case TCP_SAVED_SYN:
> +		if (*optlen < 1)
> +			return -EINVAL;
>   		break;

This looks a bit inconsistent vs '*optlen != sizeof(int)' above. Maybe

if (*optlen < sizeof(u16))
if (*optlen < sizeof(u8))

?

>   	default:
> -		return bpf_sol_tcp_setsockopt(sk, optname, optval, optlen);
> +		if (getopt)
> +			return -EINVAL;
> +		return bpf_sol_tcp_setsockopt(sk, optname, optval, *optlen);
> +	}
> +
> +	if (getopt) {
> +		if (optname == TCP_SAVED_SYN) {
> +			struct tcp_sock *tp = tcp_sk(sk);
> +
> +			if (!tp->saved_syn ||
> +			    *optlen > tcp_saved_syn_len(tp->saved_syn))
> +				return -EINVAL;

You mention in the description that bpf doesn't doesn't free saved_syn,
maybe worth putting a comment with the rationale here as well?
I'm assuming we don't free from bpf because we want userspace to
have an opportunity to read it as well?

> +			memcpy(optval, tp->saved_syn->data, *optlen);
> +			return 0;
> +		}
> +
> +		if (optname == TCP_CONGESTION) {
> +			if (!inet_csk(sk)->icsk_ca_ops)
> +				return -EINVAL;

Is it worth it doing null termination more explicitly here?
For readability sake:
			/* BPF always expects NULL-terminated strings. */
			optval[*optlen-1] = '\0';
> +			(*optlen)--;
> +		}
> +
> +		return do_tcp_getsockopt(sk, SOL_TCP, optname,
> +					 KERNEL_SOCKPTR(optval),
> +					 KERNEL_SOCKPTR(optlen));
>   	}

>   	return do_tcp_setsockopt(sk, SOL_TCP, optname,
> -				 KERNEL_SOCKPTR(optval), optlen);
> +				 KERNEL_SOCKPTR(optval), *optlen);
>   }

>   static int sol_ip_setsockopt(struct sock *sk, int optname,
> @@ -5179,7 +5210,7 @@ static int __bpf_setsockopt(struct sock *sk, int  
> level, int optname,
>   	else if (IS_ENABLED(CONFIG_IPV6) && level == SOL_IPV6)
>   		return sol_ipv6_setsockopt(sk, optname, optval, optlen);
>   	else if (IS_ENABLED(CONFIG_INET) && level == SOL_TCP)
> -		return sol_tcp_setsockopt(sk, optname, optval, optlen);
> +		return sol_tcp_sockopt(sk, optname, optval, &optlen, false);

>   	return -EINVAL;
>   }
> @@ -5202,31 +5233,8 @@ static int __bpf_getsockopt(struct sock *sk, int  
> level, int optname,

>   	if (level == SOL_SOCKET) {
>   		err = sol_socket_sockopt(sk, optname, optval, &optlen, true);
> -	} else if (IS_ENABLED(CONFIG_INET) &&
> -		   level == SOL_TCP && sk->sk_prot->getsockopt == tcp_getsockopt) {
> -		struct inet_connection_sock *icsk;
> -		struct tcp_sock *tp;
> -
> -		switch (optname) {
> -		case TCP_CONGESTION:
> -			icsk = inet_csk(sk);
> -
> -			if (!icsk->icsk_ca_ops || optlen <= 1)
> -				goto err_clear;
> -			strncpy(optval, icsk->icsk_ca_ops->name, optlen);
> -			optval[optlen - 1] = 0;
> -			break;
> -		case TCP_SAVED_SYN:
> -			tp = tcp_sk(sk);
> -
> -			if (optlen <= 0 || !tp->saved_syn ||
> -			    optlen > tcp_saved_syn_len(tp->saved_syn))
> -				goto err_clear;
> -			memcpy(optval, tp->saved_syn->data, optlen);
> -			break;
> -		default:
> -			goto err_clear;
> -		}
> +	} else if (IS_ENABLED(CONFIG_INET) && level == SOL_TCP) {
> +		err = sol_tcp_sockopt(sk, optname, optval, &optlen, true);
>   	} else if (IS_ENABLED(CONFIG_INET) && level == SOL_IP) {
>   		struct inet_sock *inet = inet_sk(sk);

> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index ab8118225797..a47cb5662be6 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4043,8 +4043,8 @@ struct sk_buff  
> *tcp_get_timestamping_opt_stats(const struct sock *sk,
>   	return stats;
>   }

> -static int do_tcp_getsockopt(struct sock *sk, int level,
> -			     int optname, sockptr_t optval, sockptr_t optlen)
> +int do_tcp_getsockopt(struct sock *sk, int level,
> +		      int optname, sockptr_t optval, sockptr_t optlen)
>   {
>   	struct inet_connection_sock *icsk = inet_csk(sk);
>   	struct tcp_sock *tp = tcp_sk(sk);
> --
> 2.30.2

