Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0AB3DE9E8
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 11:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbhHCJpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 05:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbhHCJpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 05:45:08 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518CEC061798
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 02:44:57 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id p21so28189075edi.9
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 02:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=7ArTaS55GcHRrlg8uUcqb0/VYMv30LO+TcruGsLFfOA=;
        b=nneisuAfVkRQwNF4jkMM3S1DtCT6ZpBiwI/1yDvRZehpiYxoqROz3bsi/IoEPLpKyd
         xxYtdUxI5AUFsvWpnWsW4VtrS1REX+NU2X4KhDcQVUfGNLY1Zpz/Ub7T43jzhs4mtanz
         7mICSo5yZQJ2uQ+SbUsLuZ8AK/c318a9X5Qed4ZfRsOcVQY8vpHH+afBNrn1sV9xrbsr
         LF4tcKPQxxCnFpqDHBFrI9ttcK2wtfbiUtlj+8gUtRqtaztnfyGM8F06axoGMsSJCUbk
         8XgQjvEUFQOh+PaunyKWjeGTmxGqvAxdDZqjcaOeZ30GR3HdFULQN0ZIe9vZcPK3/sWV
         MQzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=7ArTaS55GcHRrlg8uUcqb0/VYMv30LO+TcruGsLFfOA=;
        b=Scja4c8K8DcsRH67lUN1RwhIAipa1ahZXiBFYFVdyeJ/XyBAwkp5yYrkz4/kzS11Yz
         7+Bdfcetkse/mcMNOiqtQQfw4O1fQ3PS66gCsOUPoVEkEsCDFQEQKOffkPFdrl1lB+r2
         mj6U87nLJwOH1hK5lhN0j6oSVXWDKTnwqaqrMnf40r/oKQPCBFU/ts7Iw26/Nv0iHY0O
         oF/g8svupqIUKyNQebH0yKMgkBxVi5XD0yf84L5CfrhjXL8t/2H7Os3xw0rvWIIdkgyI
         NfR+TA+8c8PoUdeReYzoV/rrkApk9kD+jOURem24ThXJ8dCAxo1wqGm15R/qlXFl4qsA
         F5Ow==
X-Gm-Message-State: AOAM531Wchlwtqtz8Na47sShap9RLERVqDSs39IMUHpZxQLMfV14Fa96
        M8jNX0cXbFwcbFgkPZCWWEhKwCiKI/Yysmln54odOQ==
X-Google-Smtp-Source: ABdhPJwiDRUWz8PbJ85/X6g/6bE/DA8L0p3jb1n24/i0E5m+g8kBV8qWpyTyCwUsN/CKVlU0ERzbNXb12Kz0b7pPzsk=
X-Received: by 2002:aa7:de92:: with SMTP id j18mr24304786edv.141.1627983895787;
 Tue, 03 Aug 2021 02:44:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:2486:0:0:0:0:0 with HTTP; Tue, 3 Aug 2021 02:44:55 -0700 (PDT)
X-Originating-IP: [5.35.57.254]
In-Reply-To: <20210803082553.25194-1-yajun.deng@linux.dev>
References: <20210803082553.25194-1-yajun.deng@linux.dev>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Tue, 3 Aug 2021 12:44:55 +0300
Message-ID: <CAOJe8K0_v0SHY913pnCHKZ9WUdNGOJ2nbagsr5t=ytiJ-Y3rrQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Modify sock_set_keepalive() for more scenarios
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, mptcp@lists.linux.dev,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-s390@vger.kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/21, Yajun Deng <yajun.deng@linux.dev> wrote:
> Add 2nd parameter in sock_set_keepalive(), let the caller decide
> whether to set. This can be applied to more scenarios.

It makes sense to send the patch within a context of other scenarios

>
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  include/net/sock.h    |  2 +-
>  net/core/filter.c     |  4 +---
>  net/core/sock.c       | 10 ++++------
>  net/mptcp/sockopt.c   |  4 +---
>  net/rds/tcp_listen.c  |  2 +-
>  net/smc/af_smc.c      |  2 +-
>  net/sunrpc/xprtsock.c |  2 +-
>  7 files changed, 10 insertions(+), 16 deletions(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index ff1be7e7e90b..0aae26159549 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2772,7 +2772,7 @@ int sock_set_timestamping(struct sock *sk, int
> optname,
>
>  void sock_enable_timestamps(struct sock *sk);
>  void sock_no_linger(struct sock *sk);
> -void sock_set_keepalive(struct sock *sk);
> +void sock_set_keepalive(struct sock *sk, bool valbool);
>  void sock_set_priority(struct sock *sk, u32 priority);
>  void sock_set_rcvbuf(struct sock *sk, int val);
>  void sock_set_mark(struct sock *sk, u32 val);
> diff --git a/net/core/filter.c b/net/core/filter.c
> index faf29fd82276..41b2bf140b89 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4769,9 +4769,7 @@ static int _bpf_setsockopt(struct sock *sk, int level,
> int optname,
>  			ret = sock_bindtoindex(sk, ifindex, false);
>  			break;
>  		case SO_KEEPALIVE:
> -			if (sk->sk_prot->keepalive)
> -				sk->sk_prot->keepalive(sk, valbool);
> -			sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);
> +			sock_set_keepalive(sk, !!valbool);
>  			break;
>  		case SO_REUSEPORT:
>  			sk->sk_reuseport = valbool;
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 9671c32e6ef5..7041e6355ae1 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -892,12 +892,12 @@ int sock_set_timestamping(struct sock *sk, int
> optname,
>  	return 0;
>  }
>
> -void sock_set_keepalive(struct sock *sk)
> +void sock_set_keepalive(struct sock *sk, bool valbool)
>  {
>  	lock_sock(sk);
>  	if (sk->sk_prot->keepalive)
> -		sk->sk_prot->keepalive(sk, true);
> -	sock_valbool_flag(sk, SOCK_KEEPOPEN, true);
> +		sk->sk_prot->keepalive(sk, valbool);
> +	sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);
>  	release_sock(sk);
>  }
>  EXPORT_SYMBOL(sock_set_keepalive);
> @@ -1060,9 +1060,7 @@ int sock_setsockopt(struct socket *sock, int level,
> int optname,
>  		break;
>
>  	case SO_KEEPALIVE:
> -		if (sk->sk_prot->keepalive)
> -			sk->sk_prot->keepalive(sk, valbool);
> -		sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);
> +		sock_set_keepalive(sk, !!valbool);
>  		break;
>
>  	case SO_OOBINLINE:
> diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
> index 8c03afac5ca0..879b8381055c 100644
> --- a/net/mptcp/sockopt.c
> +++ b/net/mptcp/sockopt.c
> @@ -81,9 +81,7 @@ static void mptcp_sol_socket_sync_intval(struct mptcp_sock
> *msk, int optname, in
>  			sock_valbool_flag(ssk, SOCK_DBG, !!val);
>  			break;
>  		case SO_KEEPALIVE:
> -			if (ssk->sk_prot->keepalive)
> -				ssk->sk_prot->keepalive(ssk, !!val);
> -			sock_valbool_flag(ssk, SOCK_KEEPOPEN, !!val);
> +			sock_set_keepalive(ssk, !!val);
>  			break;
>  		case SO_PRIORITY:
>  			ssk->sk_priority = val;
> diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
> index 09cadd556d1e..b69ebb3f424a 100644
> --- a/net/rds/tcp_listen.c
> +++ b/net/rds/tcp_listen.c
> @@ -44,7 +44,7 @@ void rds_tcp_keepalive(struct socket *sock)
>  	int keepidle = 5; /* send a probe 'keepidle' secs after last data */
>  	int keepcnt = 5; /* number of unack'ed probes before declaring dead */
>
> -	sock_set_keepalive(sock->sk);
> +	sock_set_keepalive(sock->sk, true);
>  	tcp_sock_set_keepcnt(sock->sk, keepcnt);
>  	tcp_sock_set_keepidle(sock->sk, keepidle);
>  	/* KEEPINTVL is the interval between successive probes. We follow
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 898389611ae8..ad8f4302037f 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -68,7 +68,7 @@ static void smc_set_keepalive(struct sock *sk, int val)
>  {
>  	struct smc_sock *smc = smc_sk(sk);
>
> -	smc->clcsock->sk->sk_prot->keepalive(smc->clcsock->sk, val);
> +	sock_set_keepalive(smc->clcsock->sk, !!val);
>  }
>
>  static struct smc_hashinfo smc_v4_hashinfo = {
> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
> index e573dcecdd66..306a332f8d28 100644
> --- a/net/sunrpc/xprtsock.c
> +++ b/net/sunrpc/xprtsock.c
> @@ -2127,7 +2127,7 @@ static void xs_tcp_set_socket_timeouts(struct rpc_xprt
> *xprt,
>  	spin_unlock(&xprt->transport_lock);
>
>  	/* TCP Keepalive options */
> -	sock_set_keepalive(sock->sk);
> +	sock_set_keepalive(sock->sk, true);
>  	tcp_sock_set_keepidle(sock->sk, keepidle);
>  	tcp_sock_set_keepintvl(sock->sk, keepidle);
>  	tcp_sock_set_keepcnt(sock->sk, keepcnt);
> --
> 2.32.0
>
>
