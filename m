Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A003DBA27
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 16:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239078AbhG3ON4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 10:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238963AbhG3ON4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 10:13:56 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42337C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 07:13:51 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id h14so11478499wrx.10
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 07:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=VMj4lEzuK/2ZH8kE6DIO76eVFZbDyUutvVbJ/5hI7/Y=;
        b=KvmVgfwxCgSxLUrW648IOpcvvJmoI7yKKz2C3HlRgh/eTS/tZQ69QFZyg1a5F3IzYL
         jJwaKmed3L/c1WBFq6hTxv2i+h6i8zbUYPTS6KSvgcnoNsDpsoBAeSDoHl4YrOs7VkYX
         M9dmpSAaYtxkwGCGpkBGIaw/0pu+7Qnf60fZU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=VMj4lEzuK/2ZH8kE6DIO76eVFZbDyUutvVbJ/5hI7/Y=;
        b=RH+xAF1N+sLQufA+fxUgF1lwxEIPanX4eBpVLV3IlExpwLZCiQp4Elkjy6iN401g97
         Djtn9RTiRosVcN80hoP4pvWZzjVEECBg+rIHQ642kR9xdBx8eQCwJ+p2y8ln+xsf6tQk
         awdZLvYCpHY0WJjGv81Y+HIAXI7LXkjTB2z5v4mDlTHFv3n50NXhjWQDGxFtC41ebONn
         5XwSpnk1NonVuGlDKgLE7Q+6LZdBF/dVBe3ESSHp/jB2nk3NPVQhOGeN24TvfOULf/Dv
         Kfw3+LeWC+kMu0yKVYtQCW+z9DdO67azC0Xv8+AXn0SHzRy+lWQUBz7zC3eJGQuldwQY
         kxnw==
X-Gm-Message-State: AOAM5322ba+NPbqUTkYX9nY5CorfZKO2h+WVEmYBWCCxA17V+axatyHz
        N75AcMPR2PI9WMrQcRAsesVyXQ==
X-Google-Smtp-Source: ABdhPJyGNdAqI/a6C47y738JLM/bKNbYZk2DWlAs6huHXNOiUBe5oWqbXhwWEhNYpEg+JV5qFRApAA==
X-Received: by 2002:adf:f4ca:: with SMTP id h10mr3278632wrp.3.1627654429777;
        Fri, 30 Jul 2021 07:13:49 -0700 (PDT)
Received: from cloudflare.com (79.191.186.228.ipv4.supernova.orange.pl. [79.191.186.228])
        by smtp.gmail.com with ESMTPSA id v6sm1838050wru.50.2021.07.30.07.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 07:13:48 -0700 (PDT)
References: <20210729212402.1043211-1-jiang.wang@bytedance.com>
 <20210729212402.1043211-3-jiang.wang@bytedance.com>
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
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 2/5] af_unix: add unix_stream_proto for sockmap
In-reply-to: <20210729212402.1043211-3-jiang.wang@bytedance.com>
Date:   Fri, 30 Jul 2021 16:13:47 +0200
Message-ID: <875ywropno.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 11:23 PM CEST, Jiang Wang wrote:
> Previously, sockmap for AF_UNIX protocol only supports
> dgram type. This patch add unix stream type support, which
> is similar to unix_dgram_proto. To support sockmap, dgram
> and stream cannot share the same unix_proto anymore, because
> they have different implementations, such as unhash for stream
> type (which will remove closed or disconnected sockets from the map),
> so rename unix_proto to unix_dgram_proto and add a new
> unix_stream_proto.
>
> Also implement stream related sockmap functions.
> And add dgram key words to those dgram specific functions.
>
> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> ---

It seems that with commit c63829182c37 ("af_unix: Implement
->psock_update_sk_prot()") we have enabled inserting dgram, stream, and
seqpacket UNIX sockets into sockmap.

After all, in ->map_update_elem we only check if
sk->sk_prot->psock_update_sk_prot is set (sock_map_sk_is_suitable).

Socket can be in listening, established or disconnected (TCP_CLOSE)
state, that is before bind+listen/connect, or after connect(AF_UNSPEC).

For connection-oriented socket types (stream, seqpacket) there's not
much you can do with disconnected sockets. I think we should limit the
allowed states to listening and established for UNIX domain, as we do
for TCP.

AFAIU we also seem to be already allowing redirect to connected stream
(and dgram, and seqpacket) UNIX sockets. sock_map_redirect_allowed()
checks only if a socket is in TCP_ESTABLISHED state for anything else
than TCP. Not sure what it leads to, though.

Is this change is also a fix in a sense?

[...]

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

For the moment we can have TCP_CLOSE stream and seqpacket sockets in a
sockmap . This means that the above allows redirecting to TCP_CLOSE
connection-oriented sockets. sock_map_sk_state_allowed() needs an update
for the this check to be effective. And we also need to account for
seqpacket.


> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 0ae3fc4c8..cfcd0d9e5 100644
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
>  	.owner			= THIS_MODULE,
>  	.obj_size		= sizeof(struct unix_sock),
>  	.close			= unix_close,
>  #ifdef CONFIG_BPF_SYSCALL
> -	.psock_update_sk_prot	= unix_bpf_update_proto,
> +	.psock_update_sk_prot	= unix_dgram_bpf_update_proto,
>  #endif
>  };
>
> -static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
> +struct proto unix_stream_proto = {
> +	.name			= "UNIX-STREAM",
> +	.owner			= THIS_MODULE,
> +	.obj_size		= sizeof(struct unix_sock),
> +	.close			= unix_close,
> +	.unhash			= unix_unhash,
> +#ifdef CONFIG_BPF_SYSCALL
> +	.psock_update_sk_prot	= unix_stream_bpf_update_proto,
> +#endif
> +};
> +
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

Seqpacket also needs .unhash, right?

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
> @@ -2214,7 +2236,7 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t si
>  	struct sock *sk = sock->sk;
>
>  #ifdef CONFIG_BPF_SYSCALL
> -	if (sk->sk_prot != &unix_proto)
> +	if (sk->sk_prot != &unix_dgram_proto)
>  		return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
>  					    flags & ~MSG_DONTWAIT, NULL);
>  #endif
> @@ -2533,6 +2555,21 @@ static int unix_stream_read_actor(struct sk_buff *skb,
>  	return ret ?: chunk;
>  }
>
> +int __unix_stream_recvmsg(struct sock *sk, struct msghdr *msg,
> +			  size_t size, int flags)
> +{
> +	struct socket *sock = sk->sk_socket;

Nit: This intermediate variable might be not needed.

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
> @@ -2544,6 +2581,13 @@ static int unix_stream_recvmsg(struct socket *sock, struct msghdr *msg,
>  		.flags = flags
>  	};
>
> +	struct sock *sk = sock->sk;

This will generate a warning if CONFIG_BPF_SYSCALL is unset.

> +
> +#ifdef CONFIG_BPF_SYSCALL
> +	if (sk->sk_prot != &unix_stream_proto)
> +		return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
> +					    flags & ~MSG_DONTWAIT, NULL);
> +#endif
>  	return unix_stream_read_generic(&state, true);
>  }
>
> @@ -2605,6 +2649,7 @@ static int unix_shutdown(struct socket *sock, int mode)
>
>  		int peer_mode = 0;
>
> +		other->sk_prot->unhash(other);
>  		if (mode&RCV_SHUTDOWN)
>  			peer_mode |= SEND_SHUTDOWN;
>  		if (mode&SEND_SHUTDOWN)
> @@ -2613,8 +2658,10 @@ static int unix_shutdown(struct socket *sock, int mode)
>  		other->sk_shutdown |= peer_mode;
>  		unix_state_unlock(other);
>  		other->sk_state_change(other);
> -		if (peer_mode == SHUTDOWN_MASK)
> +		if (peer_mode == SHUTDOWN_MASK) {
>  			sk_wake_async(other, SOCK_WAKE_WAITD, POLL_HUP);
> +			other->sk_state = TCP_CLOSE;
> +		}
>  		else if (peer_mode & RCV_SHUTDOWN)
>  			sk_wake_async(other, SOCK_WAKE_WAITD, POLL_IN);
>  	}
> @@ -2993,7 +3040,13 @@ static int __init af_unix_init(void)
>
>  	BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_field(struct sk_buff, cb));
>
> -	rc = proto_register(&unix_proto, 1);
> +	rc = proto_register(&unix_dgram_proto, 1);
> +	if (rc != 0) {
> +		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
> +		goto out;
> +	}
> +
> +	rc = proto_register(&unix_stream_proto, 1);
>  	if (rc != 0) {
>  		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
>  		goto out;
> @@ -3009,7 +3062,8 @@ static int __init af_unix_init(void)
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

What about seqpacket? Looks like we should continue to delegate to
__unix_dgram_recvmsg, as this is what unix_seqpacket_recvmsg does.

> +
> +static int unix_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
> +			    size_t len, int nonblock, int flags,
> +			    int *addr_len)
>  {
>  	struct unix_sock *u = unix_sk(sk);
>  	struct sk_psock *psock;

[...]
