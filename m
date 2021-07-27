Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B553D7B24
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhG0Qh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbhG0QhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:37:23 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46C9C061757;
        Tue, 27 Jul 2021 09:37:22 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id c3so12649815ilh.3;
        Tue, 27 Jul 2021 09:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=RTwk880HfQhQ0IwAIoJim6xXKj/ubfPkCIhwmd1n+kg=;
        b=uU3v0p/3epsp047PVt2+Q1XO3JskJ5eOHiR3ALD0hZnSP1lp4tJkBa1CsUbFYqC2FR
         U4IDNK+AXRL8r2n82oGkhbbezL/8F3Q9N9DfOkqd9M+rdL9cefP/TDU9mGxo1Jtz3KL2
         1K2J+MDiqSdYQvCL+YPMn9fTPIcxz+zp8eo6+4reS9JnyAgLhKPFzhTTTEtLeUV0hTMK
         iNBgQUQtbmiG+FS8i1wTLNt1pMoeXrSZ0XTeAE8zjqlaEN65GUoT1JBNyjM/yU+eqWp8
         7mKeGZSLP6ChUJs2ubMYDkwHHBqxkRFmmQCNhm44cyqcy6tmKlFL/lsQNie/DEtJbrCj
         AQnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=RTwk880HfQhQ0IwAIoJim6xXKj/ubfPkCIhwmd1n+kg=;
        b=cjy5WgDW+W4U0kPR9YU4pfnKjZwPQ+PCm7z7oqimIZE4yClJXhR5kd6ezobeSluDKH
         NiyCW2pHCMc1VK3K0wd7Os81VuvgYntRDI2UcjGSxhr7jigMXpVD2M2EY1rUt+CuHzY0
         Vyi1i8p5aJyli7LACAhfy/EfFX3x0WIjQlVI4hye1TU+HGDZr74blevCVSpA247lDUyj
         wcqRRFB4mfmnZEcbxNZYQoKRJjEhj+iYgO1Lnz4fw1oZwdEi2fXNonpkrIhY3NsoQ7lE
         etxsKXd9D9mGoj2zoeIr5/uXYoP2fY6VkP3gvyBFYkn0qgmz3FeG+adjDnTLk5F6MZXM
         A13A==
X-Gm-Message-State: AOAM532SKJVQ7pfZCLfdNO4t80FPi5F6Zy/BgkgGbyFrUdtsIIZUv/cX
        FZTMoO6OBFi0PmHkiiQkkhI=
X-Google-Smtp-Source: ABdhPJwKgXuuOXfE8iOfZVK1zICbuypuUQd5/Y13rSiWMlRYGfBbZ+jp5z6hGqGu0xJYVbZWO7RXbg==
X-Received: by 2002:a92:c10c:: with SMTP id p12mr16639460ile.92.1627403842275;
        Tue, 27 Jul 2021 09:37:22 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id x11sm2129830ilu.3.2021.07.27.09.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:37:21 -0700 (PDT)
Date:   Tue, 27 Jul 2021 09:37:14 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jiang Wang <jiang.wang@bytedance.com>, netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, duanxiongchun@bytedance.com,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Message-ID: <6100363add8a9_199a412089@john-XPS-13-9370.notmuch>
In-Reply-To: <20210727001252.1287673-3-jiang.wang@bytedance.com>
References: <20210727001252.1287673-1-jiang.wang@bytedance.com>
 <20210727001252.1287673-3-jiang.wang@bytedance.com>
Subject: RE: [PATCH bpf-next v1 2/5] af_unix: add unix_stream_proto for
 sockmap
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiang Wang wrote:
> unix_stream_proto is similar to unix_dgram_proto.
> Also implement stream related sockmap functions.
> 
> Add dgram key words to those dgram specific functions.
> 
> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>.
> ---

Overall LGTM a few small question/comments below.

>  include/net/af_unix.h |  8 +++-
>  net/core/sock_map.c   |  8 +++-
>  net/unix/af_unix.c    | 77 ++++++++++++++++++++++++++++++-----
>  net/unix/unix_bpf.c   | 93 +++++++++++++++++++++++++++++++++----------
>  4 files changed, 151 insertions(+), 35 deletions(-)
> 
> diff --git a/include/net/af_unix.h b/include/net/af_unix.h
> index 435a2c3d5..5d04fbf8a 100644
> --- a/include/net/af_unix.h
> +++ b/include/net/af_unix.h
> @@ -84,6 +84,8 @@ long unix_outq_len(struct sock *sk);
>  
>  int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
>  			 int flags);
> +int __unix_stream_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
> +			  int flags);
>  #ifdef CONFIG_SYSCTL
>  int unix_sysctl_register(struct net *net);
>  void unix_sysctl_unregister(struct net *net);
> @@ -93,9 +95,11 @@ static inline void unix_sysctl_unregister(struct net *net) {}
>  #endif
>  
>  #ifdef CONFIG_BPF_SYSCALL
> -extern struct proto unix_proto;
> +extern struct proto unix_dgram_proto;
> +extern struct proto unix_stream_proto;
>  
> -int unix_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
> +int unix_dgram_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
> +int unix_stream_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
>  void __init unix_bpf_build_proto(void);
>  #else
>  static inline void __init unix_bpf_build_proto(void)
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index ae5fa4338..42f50ea7a 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -517,9 +517,15 @@ static bool sk_is_tcp(const struct sock *sk)
>  	       sk->sk_protocol == IPPROTO_TCP;
>  }
>  
> +static bool sk_is_unix_stream(const struct sock *sk)
> +{
> +	return sk->sk_type == SOCK_STREAM &&
> +	       sk->sk_protocol == PF_UNIX;
> +}
> +
>  static bool sock_map_redirect_allowed(const struct sock *sk)
>  {
> -	if (sk_is_tcp(sk))
> +	if (sk_is_tcp(sk) || sk_is_unix_stream(sk))
>  		return sk->sk_state != TCP_LISTEN;
>  	else
>  		return sk->sk_state == TCP_ESTABLISHED;
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 32eeb4a6a..c68d13f61 100644
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

Do we really need an unhash hook for unix_stream? I'm doing some testing
now to pull it out of TCP side as well. It seems to be an artifact of old
code that is no longer necessary. On TCP side at least just using close()
looks to be enough now.

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
> @@ -810,7 +828,17 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
>  	if (atomic_long_read(&unix_nr_socks) > 2 * get_max_files())
>  		goto out;
>  
> -	sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_proto, kern);
> +	if (type != 0) {
> +		if (type == SOCK_STREAM)
> +			sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_stream_proto, kern);
> +		else /*for seqpacket */
> +			sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_dgram_proto, kern);
> +	} else {
> +		if (sock->type == SOCK_STREAM)
> +			sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_stream_proto, kern);
> +		else
> +			sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_dgram_proto, kern);
> +	}
>  	if (!sk)
>  		goto out;
>  
> @@ -872,7 +900,7 @@ static int unix_create(struct net *net, struct socket *sock, int protocol,
>  		return -ESOCKTNOSUPPORT;
>  	}
>  
> -	return unix_create1(net, sock, kern) ? 0 : -ENOMEM;
> +	return unix_create1(net, sock, kern, 0) ? 0 : -ENOMEM;
>  }
>  
>  static int unix_release(struct socket *sock)
> @@ -1286,7 +1314,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
>  	err = -ENOMEM;
>  
>  	/* create new sock for complete connection */
> -	newsk = unix_create1(sock_net(sk), NULL, 0);
> +	newsk = unix_create1(sock_net(sk), NULL, 0, sock->type);
>  	if (newsk == NULL)
>  		goto out;
>  
> @@ -2214,7 +2242,7 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t si
>  	struct sock *sk = sock->sk;
>  
>  #ifdef CONFIG_BPF_SYSCALL
> -	if (sk->sk_prot != &unix_proto)
> +	if (sk->sk_prot != &unix_dgram_proto)
>  		return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
>  					    flags & ~MSG_DONTWAIT, NULL);
>  #endif
> @@ -2533,6 +2561,21 @@ static int unix_stream_read_actor(struct sk_buff *skb,
>  	return ret ?: chunk;
>  }
>  
> +int __unix_stream_recvmsg(struct sock *sk, struct msghdr *msg,
> +			  size_t size, int flags)
> +{
> +	struct socket *sock = sk->sk_socket;
> +	struct unix_stream_read_state state = {
> +		.recv_actor = unix_stream_read_actor,
> +		.socket = sock,
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
> @@ -2544,6 +2587,13 @@ static int unix_stream_recvmsg(struct socket *sock, struct msghdr *msg,
>  		.flags = flags
>  	};
>  
> +	struct sock *sk = sock->sk;
> +
> +#ifdef CONFIG_BPF_SYSCALL
> +	if (sk->sk_prot != &unix_stream_proto)
> +		return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
> +					    flags & ~MSG_DONTWAIT, NULL);
> +#endif
>  	return unix_stream_read_generic(&state, true);
>  }
>  
> @@ -2993,7 +3043,13 @@ static int __init af_unix_init(void)
>  
>  	BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_field(struct sk_buff, cb));
>  
> -	rc = proto_register(&unix_proto, 1);
> +	rc = proto_register(&unix_dgram_proto, 1);

Can you add a note in the commit message on why they proto_register is
needed. I think it might be helpful later.

> +	if (rc != 0) {
> +		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
> +		goto out;
> +	}
> +
> +	rc = proto_register(&unix_stream_proto, 1);
>  	if (rc != 0) {
>  		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
>  		goto out;
> @@ -3009,7 +3065,8 @@ static int __init af_unix_init(void)
>  static void __exit af_unix_exit(void)
>  {
>  	sock_unregister(PF_UNIX);
> -	proto_unregister(&unix_proto);
> +	proto_unregister(&unix_dgram_proto);
> +	proto_unregister(&unix_stream_proto);
>  	unregister_pernet_subsys(&unix_net_ops);
>  }
>  
> diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
> index db0cda29f..9067210d3 100644
> --- a/net/unix/unix_bpf.c
> +++ b/net/unix/unix_bpf.c
> @@ -38,9 +38,18 @@ static int unix_msg_wait_data(struct sock *sk, struct sk_psock *psock,
>  	return ret;
>  }
>  
> -static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
> -				  size_t len, int nonblock, int flags,
> -				  int *addr_len)
> +static int __unix_recvmsg(struct sock *sk, struct msghdr *msg,
> +			   size_t len, int flags)
> +{
> +	if (sk->sk_type == SOCK_DGRAM)
> +		return __unix_dgram_recvmsg(sk, msg, len, flags);
> +	else
> +		return __unix_stream_recvmsg(sk, msg, len, flags);
> +}
> +
> +static int unix_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
> +			    size_t len, int nonblock, int flags,
> +			    int *addr_len)
>  {
>  	struct unix_sock *u = unix_sk(sk);
>  	struct sk_psock *psock;
> @@ -48,12 +57,12 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>  
>  	psock = sk_psock_get(sk);
>  	if (unlikely(!psock))
> -		return __unix_dgram_recvmsg(sk, msg, len, flags);
> +		return __unix_recvmsg(sk, msg, len, flags);
>  
>  	mutex_lock(&u->iolock);
>  	if (!skb_queue_empty(&sk->sk_receive_queue) &&
>  	    sk_psock_queue_empty(psock)) {
> -		ret = __unix_dgram_recvmsg(sk, msg, len, flags);
> +		ret = __unix_recvmsg(sk, msg, len, flags);

Will need rebase after Cong's fix for iolock goes in.

>  		goto out;
>  	}
>  
> @@ -68,7 +77,7 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>  		if (data) {
>  			if (!sk_psock_queue_empty(psock))
>  				goto msg_bytes_ready;
> -			ret = __unix_dgram_recvmsg(sk, msg, len, flags);
> +			ret = __unix_recvmsg(sk, msg, len, flags);
>  			goto out;
>  		}
>  		copied = -EAGAIN;
> @@ -80,30 +89,55 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>  	return ret;
>  }
>  
> -static struct proto *unix_prot_saved __read_mostly;
> -static DEFINE_SPINLOCK(unix_prot_lock);
> -static struct proto unix_bpf_prot;
> +static struct proto *unix_dgram_prot_saved __read_mostly;
> +static DEFINE_SPINLOCK(unix_dgram_prot_lock);
> +static struct proto unix_dgram_bpf_prot;
> +
> +static struct proto *unix_stream_prot_saved __read_mostly;
> +static DEFINE_SPINLOCK(unix_stream_prot_lock);
> +static struct proto unix_stream_bpf_prot;
> +
> +static void unix_dgram_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
> +{
> +	*prot        = *base;
> +	prot->close  = sock_map_close;
> +	prot->recvmsg = unix_bpf_recvmsg;
> +}
>  
> -static void unix_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
> +static void unix_stream_bpf_rebuild_protos(struct proto *prot,
> +					   const struct proto *base)
>  {
>  	*prot        = *base;
>  	prot->close  = sock_map_close;
> -	prot->recvmsg = unix_dgram_bpf_recvmsg;
> +	prot->recvmsg = unix_bpf_recvmsg;
> +	prot->unhash  = sock_map_unhash;

Still unsure whats different between stream and dgram that means we now
need the unhash hook.

>  }
>  
> -static void unix_bpf_check_needs_rebuild(struct proto *ops)
> +static void unix_dgram_bpf_check_needs_rebuild(struct proto *ops)
>  {
> -	if (unlikely(ops != smp_load_acquire(&unix_prot_saved))) {
> -		spin_lock_bh(&unix_prot_lock);
> -		if (likely(ops != unix_prot_saved)) {
> -			unix_bpf_rebuild_protos(&unix_bpf_prot, ops);
> -			smp_store_release(&unix_prot_saved, ops);
> +	if (unlikely(ops != smp_load_acquire(&unix_dgram_prot_saved))) {
> +		spin_lock_bh(&unix_dgram_prot_lock);
> +		if (likely(ops != unix_dgram_prot_saved)) {
> +			unix_dgram_bpf_rebuild_protos(&unix_dgram_bpf_prot, ops);
> +			smp_store_release(&unix_dgram_prot_saved, ops);
>  		}
> -		spin_unlock_bh(&unix_prot_lock);
> +		spin_unlock_bh(&unix_dgram_prot_lock);
>  	}
>  }
>  
> -int unix_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
> +static void unix_stream_bpf_check_needs_rebuild(struct proto *ops)
> +{
> +	if (unlikely(ops != smp_load_acquire(&unix_stream_prot_saved))) {
> +		spin_lock_bh(&unix_stream_prot_lock);
> +		if (likely(ops != unix_stream_prot_saved)) {
> +			unix_stream_bpf_rebuild_protos(&unix_stream_bpf_prot, ops);
> +			smp_store_release(&unix_stream_prot_saved, ops);
> +		}
> +		spin_unlock_bh(&unix_stream_prot_lock);
> +	}
> +}
> +
> +int unix_dgram_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
>  {
>  	if (restore) {
>  		sk->sk_write_space = psock->saved_write_space;
> @@ -111,12 +145,27 @@ int unix_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
>  		return 0;
>  	}
>  
> -	unix_bpf_check_needs_rebuild(psock->sk_proto);
> -	WRITE_ONCE(sk->sk_prot, &unix_bpf_prot);
> +	unix_dgram_bpf_check_needs_rebuild(psock->sk_proto);
> +	WRITE_ONCE(sk->sk_prot, &unix_dgram_bpf_prot);
> +	return 0;
> +}
> +
> +int unix_stream_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
> +{
> +	if (restore) {
> +		sk->sk_write_space = psock->saved_write_space;
> +		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
> +		return 0;
> +	}
> +
> +	unix_stream_bpf_check_needs_rebuild(psock->sk_proto);
> +	WRITE_ONCE(sk->sk_prot, &unix_stream_bpf_prot);
>  	return 0;
>  }
>  
>  void __init unix_bpf_build_proto(void)
>  {
> -	unix_bpf_rebuild_protos(&unix_bpf_prot, &unix_proto);
> +	unix_dgram_bpf_rebuild_protos(&unix_dgram_bpf_prot, &unix_dgram_proto);
> +	unix_stream_bpf_rebuild_protos(&unix_stream_bpf_prot, &unix_stream_proto);
> +
>  }
> -- 
> 2.20.1
> 


