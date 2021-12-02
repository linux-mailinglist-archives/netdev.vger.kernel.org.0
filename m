Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A324B4668FC
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 18:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376284AbhLBRWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 12:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376296AbhLBRWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 12:22:15 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8461C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 09:18:52 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id v203so1506708ybe.6
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 09:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gR5v7Hmx1H9C80Kd/39wd9YW7roBvEkPZJIQza/oVmQ=;
        b=mRhvLide/qgnLye1w0+3ImqbSb1BnWRSFFfZ926a0Lobe27EKFrFlRkW4f6rJcMgxp
         qE0h9pf8YjIDoK+Fs1gAueEOMdxKJCSDXLuGnkhkZZTNBQVTbRmZgzoZulv+XQX6M1/Q
         U5RMOztblKdnQUDfUO8SMkGxhRslkDQBAEFHW3v/HMi45QLQWmO0vPoHiYerInBYW7yO
         tTHQ5w1Je57kno9hmuvAh0HFvX0fZxkoOFxaHin77MdQ8A5YKlcqumfZpvudznPJpC6O
         NSRTYd04Bsn7vCXygmGrVgaFgWidzajBcv5Bs4ZdJabEflBidqU9ruoxjVGUuDWmHS7J
         ML5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gR5v7Hmx1H9C80Kd/39wd9YW7roBvEkPZJIQza/oVmQ=;
        b=2DuHjuwB28ubfLgMygQyuZr/wL2pVYLUnkDkJid8c66hUqTVzsDElEwejY6UE+3DDM
         zzCMKU8Das9/WTo8s2w3pz1LyHh5fg4zKymSehOjS9VlBKo/GS/ZhUqFt8tZd6fYz71y
         +24hDeablzJRJ7QNa4GyckPtDeZ43L9fRNugzqDlwujz5iUSp1yKxVRvLZCg4RhYqkpf
         etAg1s1KnCnjWywTEjkB3qWK/Mtav/5ESVEl1ArHLk2+4GOA/RGdCB3SlvNGpnoLi8Wa
         nlHb+PCcratOSAN/mLzx7rgmxYcPeSc7wZ6nB6dXU1UWgAdntapTnnzh+oSjVbV8Uc5H
         Z0FA==
X-Gm-Message-State: AOAM530sKs9bGxQWbDG7hhO3iDJ6IL9kCcJCkesMlIL9d/ZXYUys6UPA
        b879+5vQH9dJkP+bQGMUHjnFREFYNpuKwJpJOX7sKg==
X-Google-Smtp-Source: ABdhPJzb+8l650uz0+C731x8hvdT5PkoFOaHjOFkQaHz3W4WOAnGPJirYfcdQlgFMzAfapWuaP+WkRTremaHJ4nUA7U=
X-Received: by 2002:a05:6902:1024:: with SMTP id x4mr17556043ybt.383.1638465531563;
 Thu, 02 Dec 2021 09:18:51 -0800 (PST)
MIME-Version: 1.0
References: <5c7100d2-8327-1e5d-d04b-3db1bb86227a@gmail.com>
 <20211202164031.18134-1-hmukos@yandex-team.ru> <20211202164031.18134-3-hmukos@yandex-team.ru>
In-Reply-To: <20211202164031.18134-3-hmukos@yandex-team.ru>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 2 Dec 2021 09:18:40 -0800
Message-ID: <CANn89iJNCK_vqBOk0nsBGmB1GAPMp7N3AT3g_SeMWDXUOH0GgQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 net-next 2/4] txhash: Add socket option to control
 TX hash rethink behavior
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
Cc:     eric.dumazet@gmail.com, mitradir@yandex-team.ru,
        netdev@vger.kernel.org, tom@herbertland.com, zeil@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 2, 2021 at 8:41 AM Akhmat Karakotov <hmukos@yandex-team.ru> wrote:
>
> Add the SO_TXREHASH socket option to control hash rethink behavior per socket.
> When default mode is set, sockets disable rehash at initialization and use
> sysctl option when entering listen state. setsockopt() overrides default
> behavior.
>
> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> ---
>  arch/alpha/include/uapi/asm/socket.h  |  2 ++
>  arch/mips/include/uapi/asm/socket.h   |  2 ++
>  arch/parisc/include/uapi/asm/socket.h |  2 ++
>  arch/sparc/include/uapi/asm/socket.h  |  2 ++
>  include/net/sock.h                    | 12 +++---------
>  include/uapi/asm-generic/socket.h     |  2 ++
>  include/uapi/linux/socket.h           |  1 +
>  net/core/sock.c                       | 13 +++++++++++++
>  net/ipv4/inet_connection_sock.c       |  3 +++
>  9 files changed, 30 insertions(+), 9 deletions(-)
>
> diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
> index 1dd9baf4a6c2..e6b3f38f8c0e 100644
> --- a/arch/alpha/include/uapi/asm/socket.h
> +++ b/arch/alpha/include/uapi/asm/socket.h
> @@ -131,6 +131,8 @@
>
>  #define SO_BUF_LOCK            72
>
> +#define SO_TXREHASH            73
> +
>  #if !defined(__KERNEL__)
>
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
> index 1eaf6a1ca561..2c8085ecde0a 100644
> --- a/arch/mips/include/uapi/asm/socket.h
> +++ b/arch/mips/include/uapi/asm/socket.h
> @@ -142,6 +142,8 @@
>
>  #define SO_BUF_LOCK            72
>
> +#define SO_TXREHASH            73
> +
>  #if !defined(__KERNEL__)
>
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
> index 8baaad52d799..8bb78ed36e97 100644
> --- a/arch/parisc/include/uapi/asm/socket.h
> +++ b/arch/parisc/include/uapi/asm/socket.h
> @@ -123,6 +123,8 @@
>
>  #define SO_BUF_LOCK            0x4046
>
> +#define SO_TXREHASH            0x4047
> +
>  #if !defined(__KERNEL__)
>
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
> index e80ee8641ac3..cd43a690fbac 100644
> --- a/arch/sparc/include/uapi/asm/socket.h
> +++ b/arch/sparc/include/uapi/asm/socket.h
> @@ -124,6 +124,8 @@
>
>  #define SO_BUF_LOCK              0x0051
>
> +#define SO_TXREHASH              0x0052
> +
>  #if !defined(__KERNEL__)
>
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index cc83140d6502..26c0efd7aa4b 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -313,6 +313,7 @@ struct bpf_local_storage;
>    *    @sk_rcvtimeo: %SO_RCVTIMEO setting
>    *    @sk_sndtimeo: %SO_SNDTIMEO setting
>    *    @sk_txhash: computed flow hash for use on transmit
> +  *    @sk_txrehash: enable TX hash rethink
>    *    @sk_filter: socket filtering instructions
>    *    @sk_timer: sock cleanup timer
>    *    @sk_stamp: time stamp of last packet received
> @@ -462,6 +463,7 @@ struct sock {
>         unsigned int            sk_gso_max_size;
>         gfp_t                   sk_allocation;
>         __u32                   sk_txhash;
> +       u8                      sk_txrehash;

This adds a 7 byte hole.

Perhaps put this right after sk_prefer_busy_poll, since there is a
1-byte hole there.

Same cache line.


>
>         /*
>          * Because of non atomicity rules, all
> @@ -1954,18 +1956,10 @@ static inline void sk_set_txhash(struct sock *sk)
>
>  static inline bool sk_rethink_txhash(struct sock *sk)
>  {
> -       u8 rehash;
> -
> -       if (!sk->sk_txhash)
> -               return false;
> -
> -       rehash = READ_ONCE(sock_net(sk)->core.sysctl_txrehash);
> -
> -       if (rehash) {
> +       if (sk->sk_txhash && sk->sk_txrehash == SOCK_TXREHASH_ENABLED) {
>                 sk_set_txhash(sk);
>                 return true;
>         }
> -
>         return false;
>  }
>
> diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
> index 1f0a2b4864e4..6c17e477ec9f 100644
> --- a/include/uapi/asm-generic/socket.h
> +++ b/include/uapi/asm-generic/socket.h
> @@ -126,6 +126,8 @@
>
>  #define SO_BUF_LOCK            72
>
> +#define SO_TXREHASH            73
> +
>  #if !defined(__KERNEL__)
>
>  #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
> diff --git a/include/uapi/linux/socket.h b/include/uapi/linux/socket.h
> index 0accd6102ece..75fab2ada8cf 100644
> --- a/include/uapi/linux/socket.h
> +++ b/include/uapi/linux/socket.h
> @@ -31,6 +31,7 @@ struct __kernel_sockaddr_storage {
>
>  #define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
>
> +#define SOCK_TXREHASH_DEFAULT  -1
>  #define SOCK_TXREHASH_DISABLED 0
>  #define SOCK_TXREHASH_ENABLED  1
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 62627e868e03..ca349ca4c31d 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1367,6 +1367,14 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
>                                           ~SOCK_BUF_LOCK_MASK);
>                 break;
>
> +       case SO_TXREHASH:
> +               if (val < -1 || val > 1) {
> +                       ret = -EINVAL;
> +                       break;
> +               }
> +               sk->sk_txrehash = val;
> +               break;
> +
>         default:
>                 ret = -ENOPROTOOPT;
>                 break;
> @@ -1733,6 +1741,10 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
>                 v.val = sk->sk_userlocks & SOCK_BUF_LOCK_MASK;
>                 break;
>
> +       case SO_TXREHASH:
> +               v.val = sk->sk_txrehash;
> +               break;
> +
>         default:
>                 /* We implement the SO_SNDLOWAT etc to not be settable
>                  * (1003.1g 7).
> @@ -3165,6 +3177,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
>         sk->sk_pacing_rate = ~0UL;
>         WRITE_ONCE(sk->sk_pacing_shift, 10);
>         sk->sk_incoming_cpu = -1;
> +       sk->sk_txrehash = SOCK_TXREHASH_DEFAULT;
>
>         sk_rx_queue_clear(sk);
>         /*
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index f25d02ad4a8a..0d477c816309 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -1046,6 +1046,9 @@ int inet_csk_listen_start(struct sock *sk, int backlog)
>         sk->sk_ack_backlog = 0;
>         inet_csk_delack_init(sk);
>
> +       if (sk->sk_txrehash == SOCK_TXREHASH_DEFAULT)
> +               sk->sk_txrehash = READ_ONCE(sock_net(sk)->core.sysctl_txrehash);
> +
>         /* There is race window here: we announce ourselves listening,
>          * but this transition is still not validated by get_port().
>          * It is OK, because this socket enters to hash table only
> --
> 2.17.1
>
