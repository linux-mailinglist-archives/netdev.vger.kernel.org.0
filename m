Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DFA1C2EB4
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 21:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgECTLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 15:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728847AbgECTLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 15:11:49 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562CCC061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 12:11:48 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id 71so12246671qtc.12
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 12:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XUcUJXd5sYMeG+kspj4N5/bj4os1+aQN1aLG3jtxArc=;
        b=boGqOoWVBuW/orXYBuIe3K4kpBzsSgngKxQI0d0UzC3Ioa9sYlPbB7ZzCyImFmV3Vh
         /NomXPGoB6XeTwCh7Ker+eHF+GaK3aEHGfPdHI6GWaWdUBocv2KePEZIX8dIl/Lk30Ws
         8kisV4oUHEsp7ilHqjvB7drz5ZAz1qFRxXjpyMk6S3Wz7FlOnZGXp2+CPao7UsrmnUb9
         zPREOCCH1JnHH9UWfM8ICXZoiiVk/L3tbSnE/5d4a4oDpG1Clsq4xYOik3a/PwpMEQ84
         ee6q87ab9WThIcbdy9HdbzE8Ograqm8yCoqqpaDNCXfmDTeKFIXUAQM0dXZOVZ3+OLZ2
         FJug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XUcUJXd5sYMeG+kspj4N5/bj4os1+aQN1aLG3jtxArc=;
        b=IIzJ06a15iMTtdJL/kvK4z7kwglUt4BsHzfEYTGcYDCXZ+EWqunWS53mlY7AzwNRbx
         iCNmekxO2+JgDFnfjwrX7uKVB20etu7rYTHg8yooTKyzaYPpR4sOvNkpdKl0Qdb6wpI7
         Qib1WEQL2+jkBKM9u9dTRALhicrHHLI9DHLGDjfiV2VvWQTaKhBZvvBU2Il6ICaX3pD6
         QJYkx9kBhAFppStUrkHThvIciC6DynIBPvhA+QdQ6lshrmZqTL3/sgfkw3CLBO6G7Ce8
         OA2NwMphzVI2/QVLcgKbJONMPotty024/8Xw0qDOAWNYmoSQe0mMJQLqFK9W8VReafKB
         2AyQ==
X-Gm-Message-State: AGi0PuY2URhyQIC5TErQL5cv0B8eU41XuPGBoHsiVxHr9SgKjQtux4Uc
        Gg/YtPvvbqDtfTs6fAOibiYxCUrd
X-Google-Smtp-Source: APiQypKmVaHEPTtnI1fsEyrUTrRTrfTFNHPo7Z4NbIBORR4zBnSx3/ERwc6zgKutQJ97WJw1hfWqhw==
X-Received: by 2002:ac8:543:: with SMTP id c3mr13325678qth.8.1588533105580;
        Sun, 03 May 2020 12:11:45 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id f68sm3662550qke.74.2020.05.03.12.11.44
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2020 12:11:44 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id r14so648711ybm.12
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 12:11:44 -0700 (PDT)
X-Received: by 2002:a25:afd0:: with SMTP id d16mr21958835ybj.441.1588533103318;
 Sun, 03 May 2020 12:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200502082856.GA3152@white>
In-Reply-To: <20200502082856.GA3152@white>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 3 May 2020 15:11:05 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc0jEw53Ngx6x+Q7+Sj=UwO71n+Pg6mD_FOx6nhTHij9Q@mail.gmail.com>
Message-ID: <CA+FuTSc0jEw53Ngx6x+Q7+Sj=UwO71n+Pg6mD_FOx6nhTHij9Q@mail.gmail.com>
Subject: Re: [PATCH v6] net: Option to retrieve the pending data from send
 queue of UDP socket
To:     Lese Doru Calin <lesedorucalin01@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 2, 2020 at 4:29 AM Lese Doru Calin
<lesedorucalin01@gmail.com> wrote:
>
> In this year's edition of GSoC, there is a project idea for CRIU to add support
> for checkpoint/restore of cork-ed UDP sockets. But to add it, the kernel API needs
> to be extended.
> This is what this patch does. It adds a new command, called SIOUDPPENDGET, to the
> ioctl syscall regarding UDP sockets, which stores the pending data from the write
> queue and the destination address in a struct msghdr. The arg for ioctl needs to
> be a pointer to a user space struct msghdr. The syscall returns the number of writed
> bytes, if successful, or error. To retrive the data requires the CAP_NET_ADMIN
> capability.
>
> Signed-off-by: Lese Doru Calin <lesedorucalin01@gmail.com>

A few concerns:

- why call the BPF recvmsg hook from this ioctl function?

- The patch saves msg_name, but not other relevant state stored in
inet_cork, such as state passed through cmsg. Without that, this might
introduce more subtle bugs than not checkpointing at all.

- Duplicating usercopy code from net/socket.c is fragile and adds
maintenance burden. If anything such refactoring should stay inside
that file. To some extent the same applies to udp_peek_sndq and
net/core/datagram.c.

Less important

- a getsockopt is generally preferred over extending ioctl.

Overall, I'm not sure that this is the right approach. It is quite a
bit of code, for a mostly hypothetical omission to CRIU?

Since these are unreliable datagrams, it is arguably sufficient to
just drop a datagram if checkpoint/restore happened on a corked
socket. That might be simpler.

As long as CRIU is behind a static branch and thus adds no cycles in
the common hot path, I personally don't mind having it in the normal
send/recv path as much -- if that allows it to reuse existing code,
e.g., for copy to user. The MSG_ERRQUEUE path in particular is already
a slow path to loop packets from the send patch back to the sending
process.


> ---
>  include/linux/socket.h       |   2 +
>  include/uapi/linux/sockios.h |   3 +
>  net/ipv4/udp.c               | 145 +++++++++++++++++++++++++++++++----
>  net/socket.c                 |   4 +-
>  4 files changed, 139 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 54338fac45cb..632ba0ea6709 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -351,6 +351,8 @@ struct ucred {
>  #define IPX_TYPE       1
>
>  extern int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *kaddr);
> +extern int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
> +                            void __user *uaddr, int __user *ulen);
>  extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
>
>  struct timespec64;
> diff --git a/include/uapi/linux/sockios.h b/include/uapi/linux/sockios.h
> index 7d1bccbbef78..3639fa906604 100644
> --- a/include/uapi/linux/sockios.h
> +++ b/include/uapi/linux/sockios.h
> @@ -153,6 +153,9 @@
>  #define SIOCSHWTSTAMP  0x89b0          /* set and get config           */
>  #define SIOCGHWTSTAMP  0x89b1          /* get config                   */
>
> +/* UDP socket calls*/
> +#define SIOUDPPENDGET 0x89C0   /* get the pending data from write queue */
> +
>  /* Device private ioctl calls */
>
>  /*
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 32564b350823..f729a5e7f90b 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1620,6 +1620,133 @@ static int first_packet_length(struct sock *sk)
>         return res;
>  }
>
> +static void udp_set_source_addr(struct sock *sk, struct msghdr *msg,
> +                               int *addr_len, u32 addr, u16 port)
> +{
> +       DECLARE_SOCKADDR(struct sockaddr_in *, sin, msg->msg_name);
> +
> +       if (sin) {
> +               sin->sin_family = AF_INET;
> +               sin->sin_port = port;
> +               sin->sin_addr.s_addr = addr;
> +               memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
> +               *addr_len = sizeof(*sin);
> +
> +               if (cgroup_bpf_enabled)
> +                       BPF_CGROUP_RUN_PROG_UDP4_RECVMSG_LOCK(sk,
> +                                        (struct sockaddr *)sin);
> +       }
> +}
> +
> +static int udp_peek_sndq(struct sock *sk, struct msghdr *msg, int off, int len)
> +{
> +       int copy, copied = 0, err = 0;
> +       struct sk_buff *skb;
> +
> +       skb_queue_walk(&sk->sk_write_queue, skb) {
> +               copy = len - copied;
> +               if (copy > skb->len - off)
> +                       copy = skb->len - off;
> +
> +               err = skb_copy_datagram_msg(skb, off, msg, copy);
> +               if (err)
> +                       break;
> +
> +               copied += copy;
> +               if (len <= copied)
> +                       break;
> +       }
> +       return err ?: copied;
> +}
> +
> +static int udp_get_pending_write_queue(struct sock *sk, struct msghdr *msg,
> +                                      int *addr_len)
> +{
> +       int err = 0, off = sizeof(struct udphdr);
> +       struct inet_sock *inet = inet_sk(sk);
> +       struct udp_sock *up = udp_sk(sk);
> +       struct flowi4 *fl4;
> +       struct flowi6 *fl6;
> +
> +       switch (up->pending) {
> +       case 0:
> +               return -ENODATA;
> +       case AF_INET:
> +               off += sizeof(struct iphdr);
> +               fl4 = &inet->cork.fl.u.ip4;
> +               udp_set_source_addr(sk, msg, addr_len,
> +                                   fl4->daddr, fl4->fl4_dport);
> +               break;
> +       case AF_INET6:
> +               off += sizeof(struct ipv6hdr);
> +               if (msg->msg_name) {
> +                       DECLARE_SOCKADDR(struct sockaddr_in6 *, sin6,
> +                                        msg->msg_name);
> +
> +                       fl6 = &inet->cork.fl.u.ip6;
> +                       sin6->sin6_family = AF_INET6;
> +                       sin6->sin6_port = fl6->fl6_dport;
> +                       sin6->sin6_flowinfo = 0;
> +                       sin6->sin6_addr = fl6->daddr;
> +                       sin6->sin6_scope_id = fl6->flowi6_oif;
> +                       *addr_len = sizeof(*sin6);
> +
> +                       if (cgroup_bpf_enabled)
> +                               BPF_CGROUP_RUN_PROG_UDP6_RECVMSG_LOCK(sk,
> +                                               (struct sockaddr *)sin6);
> +               }
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       lock_sock(sk);
> +       if (unlikely(!up->pending)) {
> +               release_sock(sk);
> +               return -EINVAL;
> +       }
> +       err = udp_peek_sndq(sk, msg, off, msg_data_left(msg));
> +       release_sock(sk);
> +       return err;
> +}
> +
> +static int prep_msghdr_recv_pending(struct sock *sk, void __user *argp)
> +{
> +       struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
> +       struct user_msghdr __user *msg;
> +       struct sockaddr __user *uaddr;
> +       struct sockaddr_storage addr;
> +       struct msghdr msg_sys;
> +       int __user *uaddr_len;
> +       int err = 0, len = 0;
> +
> +       if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
> +               return -EPERM;
> +
> +       if (!argp)
> +               return -EINVAL;
> +
> +       msg = (struct user_msghdr __user *)argp;
> +       err = recvmsg_copy_msghdr(&msg_sys, msg, 0, &uaddr, &iov);
> +       if (err < 0)
> +               return err;
> +
> +       uaddr_len = &msg->msg_namelen;
> +       msg_sys.msg_name = &addr;
> +       msg_sys.msg_flags = 0;
> +
> +       err = udp_get_pending_write_queue(sk, &msg_sys, &len);
> +       msg_sys.msg_namelen = len;
> +       len = err;
> +
> +       if (uaddr && err >= 0)
> +               err = move_addr_to_user(&addr, msg_sys.msg_namelen,
> +                                       uaddr, uaddr_len);
> +
> +       kfree(iov);
> +       return err < 0 ? err : len;
> +}
> +
>  /*
>   *     IOCTL requests applicable to the UDP protocol
>   */
> @@ -1641,6 +1768,9 @@ int udp_ioctl(struct sock *sk, int cmd, unsigned long arg)
>                 return put_user(amount, (int __user *)arg);
>         }
>
> +       case SIOUDPPENDGET:
> +               return prep_msghdr_recv_pending(sk, (void __user *)arg);
> +
>         default:
>                 return -ENOIOCTLCMD;
>         }
> @@ -1729,7 +1859,6 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
>                 int flags, int *addr_len)
>  {
>         struct inet_sock *inet = inet_sk(sk);
> -       DECLARE_SOCKADDR(struct sockaddr_in *, sin, msg->msg_name);
>         struct sk_buff *skb;
>         unsigned int ulen, copied;
>         int off, err, peeking = flags & MSG_PEEK;
> @@ -1794,18 +1923,8 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
>
>         sock_recv_ts_and_drops(msg, sk, skb);
>
> -       /* Copy the address. */
> -       if (sin) {
> -               sin->sin_family = AF_INET;
> -               sin->sin_port = udp_hdr(skb)->source;
> -               sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
> -               memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
> -               *addr_len = sizeof(*sin);
> -
> -               if (cgroup_bpf_enabled)
> -                       BPF_CGROUP_RUN_PROG_UDP4_RECVMSG_LOCK(sk,
> -                                                       (struct sockaddr *)sin);
> -       }
> +       udp_set_source_addr(sk, msg, addr_len, ip_hdr(skb)->saddr,
> +                           udp_hdr(skb)->source);
>
>         if (udp_sk(sk)->gro_enabled)
>                 udp_cmsg_recv(msg, sk, skb);
> diff --git a/net/socket.c b/net/socket.c
> index 2dd739fba866..bd25d528c9a0 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -217,8 +217,8 @@ int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *k
>   *     specified. Zero is returned for a success.
>   */
>
> -static int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
> -                            void __user *uaddr, int __user *ulen)
> +int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
> +                     void __user *uaddr, int __user *ulen)
>  {
>         int err;
>         int len;
> --
> 2.17.1
>
