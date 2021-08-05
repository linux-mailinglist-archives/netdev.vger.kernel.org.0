Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543DD3E1B9C
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241655AbhHESo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241592AbhHESoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:44:55 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9BEC061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:44:40 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id x8so13030031lfe.3
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=INk3XSw8EkiiqWSqdb59L6OOJd8smcU62HiHOCZ/eNY=;
        b=qMLBzO6WhhUWnOWwFvXaPVjifn5YOEjQwvC516itc7t6Mwr4H8VCjaT3jBqjzLeGhY
         3CUPlSirGnmvkmFCbqVwxqZR+2pGt3y58ZpMSA1gvcFuDPQt/XlYrqC+fJEhGHuOvlbh
         cn8SqEgzJN8b4Q31k84p4Znd3NPG42xgCQ2Jc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=INk3XSw8EkiiqWSqdb59L6OOJd8smcU62HiHOCZ/eNY=;
        b=IIfvfEWBhzetB+nBMMtGPKz5UPbDuxtW7RqEd3m8fz8dG12C3jNZ/pGQ21wWPw1Q4v
         ZEWt9bSrO5q2RYt/L0IuRXevbPuhqrdDppuIkjMX/4K1DhVwopsL+6D80ropYcE7bpl0
         CkrGrjFwbG1zwkURL3gT47q6jCOE7MyAFMfFdB4HGUrzZCAMyfQcvkTIyMNUt4jG1laM
         O4EYJ49eNxRDRSmiPENKuiSAoY8W559oI9dvA8mB0hveo45AyRBOCZaoDdARgAQURJYo
         EykvVCU43EnC4pYJ3MSswfmg6PU6o3z/QW3FijjuMp75zs8c9sz7fcNdaucur3I+JJEF
         0hvg==
X-Gm-Message-State: AOAM530I4rXrv85dqNVMB5lzWknXOj38Ymy2PHrZWYbE8sHZTgRoOV4o
        /hoJutPSlMTp/W4NLvoVOWIAhA==
X-Google-Smtp-Source: ABdhPJzyPq0ysU2CTi312TtSkUo2U7Utcg5KrzfhL0ZenWSLzwonHZ35S8TOFPmBzOicf3YiKwRHlg==
X-Received: by 2002:a05:6512:260e:: with SMTP id bt14mr4621782lfb.491.1628189079192;
        Thu, 05 Aug 2021 11:44:39 -0700 (PDT)
Received: from cloudflare.com (79.191.182.217.ipv4.supernova.orange.pl. [79.191.182.217])
        by smtp.gmail.com with ESMTPSA id v16sm469447ljn.93.2021.08.05.11.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:44:38 -0700 (PDT)
References: <20210805051340.3798543-1-jiang.wang@bytedance.com>
 <20210805051340.3798543-3-jiang.wang@bytedance.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Jiang Wang <jiang.wang@bytedance.com>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        duanxiongchun@bytedance.com, xieyongji@bytedance.com,
        chaiwen.cc@bytedance.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 2/5] af_unix: add unix_stream_proto for sockmap
In-reply-to: <20210805051340.3798543-3-jiang.wang@bytedance.com>
Date:   Thu, 05 Aug 2021 20:44:37 +0200
Message-ID: <87y29fd94a.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 07:13 AM CEST, Jiang Wang wrote:

[...]

> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -791,17 +791,35 @@ static void unix_close(struct sock *sk, long timeout)
>  	 */
>  }
>
> -struct proto unix_proto = {
> -	.name			= "UNIX",
> +static void unix_unhash(struct sock *sk)
> +{
> +	/* Nothing to do here, unix socket does not need a ->unhash().
> +	 * This is merely for sockmap.
> +	 */
> +}
> +
> +struct proto unix_dgram_proto = {
> +	.name			= "UNIX-DGRAM",
> +	.owner			= THIS_MODULE,
> +	.obj_size		= sizeof(struct unix_sock),
> +	.close			= unix_close,
> +#ifdef CONFIG_BPF_SYSCALL
> +	.psock_update_sk_prot	= unix_dgram_bpf_update_proto,
> +#endif
> +};
> +
> +struct proto unix_stream_proto = {
> +	.name			= "UNIX-STREAM",
>  	.owner			= THIS_MODULE,
>  	.obj_size		= sizeof(struct unix_sock),
>  	.close			= unix_close,
> +	.unhash			= unix_unhash,
>  #ifdef CONFIG_BPF_SYSCALL
> -	.psock_update_sk_prot	= unix_bpf_update_proto,
> +	.psock_update_sk_prot	= unix_stream_bpf_update_proto,
>  #endif
>  };
>
> -static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
> +static struct sock *unix_create1(struct net *net, struct socket *sock, int kern, int type)
>  {
>  	struct sock *sk = NULL;
>  	struct unix_sock *u;
> @@ -810,7 +828,11 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
>  	if (atomic_long_read(&unix_nr_socks) > 2 * get_max_files())
>  		goto out;
>
> -	sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_proto, kern);
> +	if (type == SOCK_STREAM)
> +		sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_stream_proto, kern);
> +	else /*dgram and  seqpacket */
> +		sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_dgram_proto, kern);
> +
>  	if (!sk)
>  		goto out;
>
> @@ -872,7 +894,7 @@ static int unix_create(struct net *net, struct socket *sock, int protocol,
>  		return -ESOCKTNOSUPPORT;
>  	}
>
> -	return unix_create1(net, sock, kern) ? 0 : -ENOMEM;
> +	return unix_create1(net, sock, kern, sock->type) ? 0 : -ENOMEM;
>  }
>
>  static int unix_release(struct socket *sock)
> @@ -1286,7 +1308,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
>  	err = -ENOMEM;
>
>  	/* create new sock for complete connection */
> -	newsk = unix_create1(sock_net(sk), NULL, 0);
> +	newsk = unix_create1(sock_net(sk), NULL, 0, sock->type);
>  	if (newsk == NULL)
>  		goto out;
>
> @@ -2261,7 +2283,7 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t si
>  	struct sock *sk = sock->sk;
>
>  #ifdef CONFIG_BPF_SYSCALL
> -	if (sk->sk_prot != &unix_proto)
> +	if (READ_ONCE(sk->sk_prot) != &unix_dgram_proto)
>  		return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
>  					    flags & ~MSG_DONTWAIT, NULL);

Notice we have two reads from sk->sk_prot here.  And the value
sk->sk_prot holds might change between reads (that is when we remove the
socket from sockmap). So we want to load it just once.

Otherwise, it seems possible that sk->sk_prot->recvmsg will be called,
when sk->sk_prot == unix_proto. Which means sk->sk_prot->recvmsg is NULL.

>  #endif
> @@ -2580,6 +2602,20 @@ static int unix_stream_read_actor(struct sk_buff *skb,
>  	return ret ?: chunk;
>  }
>
> +int __unix_stream_recvmsg(struct sock *sk, struct msghdr *msg,
> +			  size_t size, int flags)
> +{
> +	struct unix_stream_read_state state = {
> +		.recv_actor = unix_stream_read_actor,
> +		.socket = sk->sk_socket,
> +		.msg = msg,
> +		.size = size,
> +		.flags = flags
> +	};
> +
> +	return unix_stream_read_generic(&state, true);
> +}
> +
>  static int unix_stream_recvmsg(struct socket *sock, struct msghdr *msg,
>  			       size_t size, int flags)
>  {
> @@ -2591,6 +2627,12 @@ static int unix_stream_recvmsg(struct socket *sock, struct msghdr *msg,
>  		.flags = flags
>  	};
>
> +#ifdef CONFIG_BPF_SYSCALL
> +	struct sock *sk = sock->sk;
> +	if (sk->sk_prot != &unix_stream_proto)
> +		return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
> +					    flags & ~MSG_DONTWAIT, NULL);

Also needs READ_ONCE annotations.

> +#endif
>  	return unix_stream_read_generic(&state, true);
>  }
>
> @@ -2652,6 +2694,7 @@ static int unix_shutdown(struct socket *sock, int mode)
>
>  		int peer_mode = 0;
>
> +		other->sk_prot->unhash(other);

Here as well.

>  		if (mode&RCV_SHUTDOWN)
>  			peer_mode |= SEND_SHUTDOWN;
>  		if (mode&SEND_SHUTDOWN)

[...]
