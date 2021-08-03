Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2613DE381
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 02:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhHCAY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 20:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbhHCAY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 20:24:26 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBB8C0613D5
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 17:24:16 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id v9-20020a9d60490000b02904f06fc590dbso283180otj.4
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 17:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=doGlUnC2Izu+5zn4ZCfvspedKvqr3QZYCIrVSDIo8sk=;
        b=OJrGMH5xFj4M9BfrtuDMoJPOY/7A0gs9DjhAODbC4/++9MhtbAPyIoo2+37LuIfd+z
         O2ufKPyCRi1loYN6iw8cqvKWp9nU4phQNrYXY5B5iNdRhcjqm1ck22GWTlV105h1kbp3
         txBCFdoS2Ape/8UxbS5Xn994HaUXYD8fDUaPOXE+d6ETkZuU8eu5SblSTNpoMfRA449O
         AzeNwgP9Y2miwZR5bm0Z8TC6ATC6NtLq5u5LHV8C2lwYUxa28J4TwXJjHGyLBtiC/KWT
         2WuS0brQWTXRO7XmTPwauDW52c08x07C+ILcPR0MdLh0+9RlbNujffvlCGMjEGso6O+p
         iy0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=doGlUnC2Izu+5zn4ZCfvspedKvqr3QZYCIrVSDIo8sk=;
        b=oGDcM2iUPEjUL/peP1meoEBfsmAcd43qF+iGUlkSin7yOmyCIr9Cs5RuikDZjkmMxW
         DJMDGTnx69DDlf+kmXQRuJmpG84rYGYaggYocbTZdlITMeuLUZaI7Uw5S640tSbWy7bL
         pQhVrb2Ege4s6+nWJb9OLS1gNUES3y4Y9XifdF3jrg11xM7i5aby08lPoDW8mV0+7D5a
         hSIG3I3o258/f41gLz9izQj+dUAVJsJmcTLdqQGrIk+8v7BkEd6XHPe1hHuanUXWFuFu
         kB8nX6G0u1ZQyAM3IcmAkdwPVpO5BEb5H+4ZUuFUdDP2OUdjC0tXMxTqtN85rM4o4Ki4
         ITCg==
X-Gm-Message-State: AOAM532q4KuMIP58dweA2ZNbnf3x0cphjnj/Us45ZRpdKNDRYy6UKTzr
        bzvAkcdPQN/aG4BEz2ShHjRjGMhGIWs+L5/sA8nFbs08sn0=
X-Google-Smtp-Source: ABdhPJw8hTGNh2lYWwPy3nKOhvFq+7YU16hkOyePv2tW2S3BgRP5d4yHrFc5sAoQgq8Oc75oK2iZY0Cymv2+HzRolNo=
X-Received: by 2002:a05:6830:40c2:: with SMTP id h2mr13569636otu.56.1627950255573;
 Mon, 02 Aug 2021 17:24:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210802211912.116329-1-jiang.wang@bytedance.com> <20210802211912.116329-3-jiang.wang@bytedance.com>
In-Reply-To: <20210802211912.116329-3-jiang.wang@bytedance.com>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Mon, 2 Aug 2021 17:24:04 -0700
Message-ID: <CAP_N_Z-FJSZ+gaO36ui763SjVk+aDuUT0Cten3RgFTeX+h2qbQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/5] af_unix: add unix_stream_proto for sockmap
To:     Networking <netdev@vger.kernel.org>
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        =?UTF-8?B?5p+056iz?= <chaiwen.cc@bytedance.com>,
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
        linux-kernel@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 2, 2021 at 2:19 PM Jiang Wang <jiang.wang@bytedance.com> wrote:
>
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
>  include/net/af_unix.h |  8 +++-
>  net/core/sock_map.c   |  8 +++-
>  net/unix/af_unix.c    | 74 ++++++++++++++++++++++++++++-----
>  net/unix/unix_bpf.c   | 96 +++++++++++++++++++++++++++++++++----------
>  4 files changed, 150 insertions(+), 36 deletions(-)
>
> diff --git a/include/net/af_unix.h b/include/net/af_unix.h
> index 435a2c3d5..5d04fbf8a 100644
> --- a/include/net/af_unix.h
> +++ b/include/net/af_unix.h
> @@ -84,6 +84,8 @@ long unix_outq_len(struct sock *sk);
>
>  int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
>                          int flags);
> +int __unix_stream_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
> +                         int flags);
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
>                sk->sk_protocol == IPPROTO_TCP;
>  }
>
> +static bool sk_is_unix_stream(const struct sock *sk)
> +{
> +       return sk->sk_type == SOCK_STREAM &&
> +              sk->sk_protocol == PF_UNIX;
> +}
> +
>  static bool sock_map_redirect_allowed(const struct sock *sk)
>  {
> -       if (sk_is_tcp(sk))
> +       if (sk_is_tcp(sk) || sk_is_unix_stream(sk))
>                 return sk->sk_state != TCP_LISTEN;
>         else
>                 return sk->sk_state == TCP_ESTABLISHED;
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 0ae3fc4c8..9c1711c67 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -791,17 +791,35 @@ static void unix_close(struct sock *sk, long timeout)
>          */
>  }
>
> -struct proto unix_proto = {
> -       .name                   = "UNIX",
> +static void unix_unhash(struct sock *sk)
> +{
> +       /* Nothing to do here, unix socket does not need a ->unhash().
> +        * This is merely for sockmap.
> +        */
> +}
> +
> +struct proto unix_dgram_proto = {
> +       .name                   = "UNIX-DGRAM",
> +       .owner                  = THIS_MODULE,
> +       .obj_size               = sizeof(struct unix_sock),
> +       .close                  = unix_close,
> +#ifdef CONFIG_BPF_SYSCALL
> +       .psock_update_sk_prot   = unix_dgram_bpf_update_proto,
> +#endif
> +};
> +
> +struct proto unix_stream_proto = {
> +       .name                   = "UNIX-STREAM",
>         .owner                  = THIS_MODULE,
>         .obj_size               = sizeof(struct unix_sock),
>         .close                  = unix_close,
> +       .unhash                 = unix_unhash,
>  #ifdef CONFIG_BPF_SYSCALL
> -       .psock_update_sk_prot   = unix_bpf_update_proto,
> +       .psock_update_sk_prot   = unix_stream_bpf_update_proto,
>  #endif
>  };
>
> -static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
> +static struct sock *unix_create1(struct net *net, struct socket *sock, int kern, int type)
>  {
>         struct sock *sk = NULL;
>         struct unix_sock *u;
> @@ -810,7 +828,11 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
>         if (atomic_long_read(&unix_nr_socks) > 2 * get_max_files())
>                 goto out;
>
> -       sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_proto, kern);
> +       if (type == SOCK_STREAM)
> +               sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_stream_proto, kern);
> +       else /*dgram and  seqpacket */
> +               sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_dgram_proto, kern);
> +
>         if (!sk)
>                 goto out;
>
> @@ -872,7 +894,7 @@ static int unix_create(struct net *net, struct socket *sock, int protocol,
>                 return -ESOCKTNOSUPPORT;
>         }
>
> -       return unix_create1(net, sock, kern) ? 0 : -ENOMEM;
> +       return unix_create1(net, sock, kern, sock->type) ? 0 : -ENOMEM;
>  }
>
>  static int unix_release(struct socket *sock)
> @@ -1286,7 +1308,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
>         err = -ENOMEM;
>
>         /* create new sock for complete connection */
> -       newsk = unix_create1(sock_net(sk), NULL, 0);
> +       newsk = unix_create1(sock_net(sk), NULL, 0, sock->type);
>         if (newsk == NULL)
>                 goto out;
>
> @@ -2214,7 +2236,7 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t si
>         struct sock *sk = sock->sk;
>
>  #ifdef CONFIG_BPF_SYSCALL
> -       if (sk->sk_prot != &unix_proto)
> +       if (sk->sk_prot != &unix_dgram_proto)
>                 return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
>                                             flags & ~MSG_DONTWAIT, NULL);
>  #endif
> @@ -2533,6 +2555,20 @@ static int unix_stream_read_actor(struct sk_buff *skb,
>         return ret ?: chunk;
>  }
>
> +int __unix_stream_recvmsg(struct sock *sk, struct msghdr *msg,
> +                         size_t size, int flags)
> +{
> +       struct unix_stream_read_state state = {
> +               .recv_actor = unix_stream_read_actor,
> +               .socket = sk->sk_socket,
> +               .msg = msg,
> +               .size = size,
> +               .flags = flags
> +       };
> +
> +       return unix_stream_read_generic(&state, true);
> +}
> +
>  static int unix_stream_recvmsg(struct socket *sock, struct msghdr *msg,
>                                size_t size, int flags)
>  {
> @@ -2544,6 +2580,12 @@ static int unix_stream_recvmsg(struct socket *sock, struct msghdr *msg,
>                 .flags = flags
>         };
>
> +#ifdef CONFIG_BPF_SYSCALL
> +       struct sock *sk = sock->sk;
> +       if (sk->sk_prot != &unix_stream_proto)
> +               return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
> +                                           flags & ~MSG_DONTWAIT, NULL);
> +#endif
>         return unix_stream_read_generic(&state, true);
>  }
>
> @@ -2605,6 +2647,7 @@ static int unix_shutdown(struct socket *sock, int mode)
>
>                 int peer_mode = 0;
>
> +               other->sk_prot->unhash(other);
>                 if (mode&RCV_SHUTDOWN)
>                         peer_mode |= SEND_SHUTDOWN;
>                 if (mode&SEND_SHUTDOWN)
> @@ -2613,8 +2656,10 @@ static int unix_shutdown(struct socket *sock, int mode)
>                 other->sk_shutdown |= peer_mode;
>                 unix_state_unlock(other);
>                 other->sk_state_change(other);
> -               if (peer_mode == SHUTDOWN_MASK)
> +               if (peer_mode == SHUTDOWN_MASK) {
>                         sk_wake_async(other, SOCK_WAKE_WAITD, POLL_HUP);
> +                       other->sk_state = TCP_CLOSE;
> +               }
>                 else if (peer_mode & RCV_SHUTDOWN)
>                         sk_wake_async(other, SOCK_WAKE_WAITD, POLL_IN);
>         }
> @@ -2993,7 +3038,13 @@ static int __init af_unix_init(void)
>
>         BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_field(struct sk_buff, cb));
>
> -       rc = proto_register(&unix_proto, 1);
> +       rc = proto_register(&unix_dgram_proto, 1);
> +       if (rc != 0) {
> +               pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
> +               goto out;
> +       }
> +
> +       rc = proto_register(&unix_stream_proto, 1);
>         if (rc != 0) {
>                 pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
>                 goto out;
> @@ -3009,7 +3060,8 @@ static int __init af_unix_init(void)
>  static void __exit af_unix_exit(void)
>  {
>         sock_unregister(PF_UNIX);
> -       proto_unregister(&unix_proto);
> +       proto_unregister(&unix_dgram_proto);
> +       proto_unregister(&unix_stream_proto);
>         unregister_pernet_subsys(&unix_net_ops);
>  }
>
> diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
> index db0cda29f..17e210666 100644
> --- a/net/unix/unix_bpf.c
> +++ b/net/unix/unix_bpf.c
> @@ -38,9 +38,18 @@ static int unix_msg_wait_data(struct sock *sk, struct sk_psock *psock,
>         return ret;
>  }
>
> -static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
> -                                 size_t len, int nonblock, int flags,
> -                                 int *addr_len)
> +static int __unix_recvmsg(struct sock *sk, struct msghdr *msg,
> +                          size_t len, int flags)
> +{
> +       if (sk->sk_type == SOCK_DGRAM)
> +               return __unix_dgram_recvmsg(sk, msg, len, flags);
> +       else
> +               return __unix_stream_recvmsg(sk, msg, len, flags);
> +}
> +
> +static int unix_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
> +                           size_t len, int nonblock, int flags,
> +                           int *addr_len)
>  {
>         struct unix_sock *u = unix_sk(sk);
>         struct sk_psock *psock;
> @@ -48,12 +57,12 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>
>         psock = sk_psock_get(sk);
>         if (unlikely(!psock))
> -               return __unix_dgram_recvmsg(sk, msg, len, flags);
> +               return __unix_recvmsg(sk, msg, len, flags);
>
>         mutex_lock(&u->iolock);
>         if (!skb_queue_empty(&sk->sk_receive_queue) &&
>             sk_psock_queue_empty(psock)) {
> -               ret = __unix_dgram_recvmsg(sk, msg, len, flags);
> +               ret = __unix_recvmsg(sk, msg, len, flags);
>                 goto out;
>         }
>
> @@ -68,7 +77,7 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>                 if (data) {
>                         if (!sk_psock_queue_empty(psock))
>                                 goto msg_bytes_ready;
> -                       ret = __unix_dgram_recvmsg(sk, msg, len, flags);
> +                       ret = __unix_recvmsg(sk, msg, len, flags);
>                         goto out;
>                 }
>                 copied = -EAGAIN;
> @@ -80,43 +89,86 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>         return ret;
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
> +       *prot        = *base;
> +       prot->close  = sock_map_close;
> +       prot->recvmsg = unix_bpf_recvmsg;
> +}
>
> -static void unix_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
> +static void unix_stream_bpf_rebuild_protos(struct proto *prot,
> +                                          const struct proto *base)
>  {
>         *prot        = *base;
>         prot->close  = sock_map_close;
> -       prot->recvmsg = unix_dgram_bpf_recvmsg;
> +       prot->recvmsg = unix_bpf_recvmsg;
> +       prot->unhash  = sock_map_unhash;
> +}
> +
> +static void unix_dgram_bpf_check_needs_rebuild(struct proto *ops)
> +{
> +       if (unlikely(ops != smp_load_acquire(&unix_dgram_prot_saved))) {
> +               spin_lock_bh(&unix_dgram_prot_lock);
> +               if (likely(ops != unix_dgram_prot_saved)) {
> +                       unix_dgram_bpf_rebuild_protos(&unix_dgram_bpf_prot, ops);
> +                       smp_store_release(&unix_dgram_prot_saved, ops);
> +               }
> +               spin_unlock_bh(&unix_dgram_prot_lock);
> +       }
>  }
>
> -static void unix_bpf_check_needs_rebuild(struct proto *ops)
> +static void unix_stream_bpf_check_needs_rebuild(struct proto *ops)
>  {
> -       if (unlikely(ops != smp_load_acquire(&unix_prot_saved))) {
> -               spin_lock_bh(&unix_prot_lock);
> -               if (likely(ops != unix_prot_saved)) {
> -                       unix_bpf_rebuild_protos(&unix_bpf_prot, ops);
> -                       smp_store_release(&unix_prot_saved, ops);
> +       if (unlikely(ops != smp_load_acquire(&unix_stream_prot_saved))) {
> +               spin_lock_bh(&unix_stream_prot_lock);
> +               if (likely(ops != unix_stream_prot_saved)) {
> +                       unix_stream_bpf_rebuild_protos(&unix_stream_bpf_prot, ops);
> +                       smp_store_release(&unix_stream_prot_saved, ops);
>                 }
> -               spin_unlock_bh(&unix_prot_lock);
> +               spin_unlock_bh(&unix_stream_prot_lock);
> +       }
> +}
> +
> +int unix_dgram_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
> +{
> +       if (restore) {
> +               sk->sk_write_space = psock->saved_write_space;
> +               WRITE_ONCE(sk->sk_prot, psock->sk_proto);
> +               return 0;
>         }
> +
> +       unix_dgram_bpf_check_needs_rebuild(psock->sk_proto);
> +       WRITE_ONCE(sk->sk_prot, &unix_dgram_bpf_prot);
> +       return 0;
>  }
>
> -int unix_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
> +int unix_stream_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
>  {
> +       if (sk->sk_type != SOCK_STREAM)
> +               return -EOPNOTSUPP;
> +

Cong reminded me that there is no need to check sk_type here because
unix_stream_bpf_prot is only used by stream type. I will remove this part
in the next version.



>         if (restore) {
>                 sk->sk_write_space = psock->saved_write_space;
>                 WRITE_ONCE(sk->sk_prot, psock->sk_proto);
>                 return 0;
>         }
>
> -       unix_bpf_check_needs_rebuild(psock->sk_proto);
> -       WRITE_ONCE(sk->sk_prot, &unix_bpf_prot);
> +       unix_stream_bpf_check_needs_rebuild(psock->sk_proto);
> +       WRITE_ONCE(sk->sk_prot, &unix_stream_bpf_prot);
>         return 0;
>  }
>
>  void __init unix_bpf_build_proto(void)
>  {
> -       unix_bpf_rebuild_protos(&unix_bpf_prot, &unix_proto);
> +       unix_dgram_bpf_rebuild_protos(&unix_dgram_bpf_prot, &unix_dgram_proto);
> +       unix_stream_bpf_rebuild_protos(&unix_stream_bpf_prot, &unix_stream_proto);
> +
>  }
> --
> 2.20.1
>
