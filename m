Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FB3444A2D
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 22:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhKCV02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 17:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhKCV01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 17:26:27 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8878C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 14:23:50 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id a20-20020a1c7f14000000b003231d13ee3cso5674403wmd.3
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 14:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ASM16knmeuNz5Je3Dcaw1hffBq36knNoh8i2fZ0jgQo=;
        b=TGFT9tM/bqGcnTBjSE7V6iC8Tgnk2mMyYwRYjh2U43HzmimxQl0KR4Upx6Iat+D5VN
         cwoG6EX3vsdOBjht6eYbs/n1zg8rHPdbhcTq3ZWlnXmfH19UTOWDxmrjMlIV1D6ywigw
         l9xbxlUbXogj/wtqWTvDVuO3S7pMsYlKXa5Ee8rEUPNRAXJLLhsluoSH9HdzRoP6GO2p
         B+POVGInFUTsDZz6ZcfSWFVkoMTWxyc5zJGinV4MfEnn9ZbbW+4KxConpnbBAuXr0cVq
         OAA/00v5PUOMam5YjkrYVS6P3M1IqbiHkHkirKlEc6PTzVcYBGD/+NjFuvefY2VID+Cq
         t16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ASM16knmeuNz5Je3Dcaw1hffBq36knNoh8i2fZ0jgQo=;
        b=8BsjW01eaYlZbdVYeKhBcSiGAVYiWGfVc2KTbBVBxvux22faPxyiDz0i5YkjKt6X0O
         pIri+gkNUPII5DE3EBYW+ell7o67+9E+mzYsyBMee/FLyBf5XPvuqNkp9bdnh89VwSpi
         cVhTYLbAhJiD2SXe6UC+g5eZldPoIzyqDvYdAcJequfqM2bdO2sBrXXscHEJ3UxpOAwL
         +ixDdQRlx6z7e0SQQLclAI77Pk+0qa+mV1/QgMM3cfHieciRot+qyiUhamwxXi5Vt8j9
         psWd+yweGPtKQ+1wi8cvHzQrjaefVWcSFVbxfvQ3+0tnkaQn1FxvcykEgxm6XYH0MWgB
         Z6Jw==
X-Gm-Message-State: AOAM533twsBsq2yQEuRV+K1frCk1LU2Kf9qVVLqRDA3hBhMM1Gz86itb
        UOGjrcOh9n57fNu5WSP9OUDNRsQNZ9IQur3e+6B18Q==
X-Google-Smtp-Source: ABdhPJxyF4Dsd0usfoRUWRZwEU7SJXMPnt5APDduOQ5NKLQZcckVh72Ah53fDBaQ7L8pgQBrNPchV1fhuIHSgNOYhc8=
X-Received: by 2002:a1c:43c2:: with SMTP id q185mr18344349wma.30.1635974628544;
 Wed, 03 Nov 2021 14:23:48 -0700 (PDT)
MIME-Version: 1.0
References: <20211025121253.8643-1-hmukos@yandex-team.ru> <20211103204607.21491-1-hmukos@yandex-team.ru>
In-Reply-To: <20211103204607.21491-1-hmukos@yandex-team.ru>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Wed, 3 Nov 2021 14:23:11 -0700
Message-ID: <CAK6E8=dfHURjNyLbPEqvFvP9nQh45PFGjK05MJaAxMU-LEboag@mail.gmail.com>
Subject: Re: [PATCH v3] tcp: Use BPF timeout setting for SYN ACK RTO
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
Cc:     kafai@fb.com, brakmo@fb.com, eric.dumazet@gmail.com,
        mitradir@yandex-team.ru, ncardwell@google.com,
        netdev@vger.kernel.org, zeil@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 3, 2021 at 1:46 PM Akhmat Karakotov <hmukos@yandex-team.ru> wrote:
>
> When setting RTO through BPF program, some SYN ACK packets were unaffected
> and continued to use TCP_TIMEOUT_INIT constant. This patch adds timeout
> option to struct request_sock. Option is initialized with TCP_TIMEOUT_INIT
> and is reassigned through BPF using tcp_timeout_init call. SYN ACK
> retransmits now use newly added timeout option.
>
> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> ---
>  include/net/request_sock.h      |  2 ++
>  include/net/tcp.h               |  2 +-
>  net/ipv4/inet_connection_sock.c |  4 +++-
>  net/ipv4/tcp_input.c            |  8 +++++---
>  net/ipv4/tcp_minisocks.c        | 12 +++++++++---
>  5 files changed, 20 insertions(+), 8 deletions(-)
>
> diff --git a/include/net/request_sock.h b/include/net/request_sock.h
> index 29e41ff3ec93..144c39db9898 100644
> --- a/include/net/request_sock.h
> +++ b/include/net/request_sock.h
> @@ -70,6 +70,7 @@ struct request_sock {
>         struct saved_syn                *saved_syn;
>         u32                             secid;
>         u32                             peer_secid;
> +       u32                             timeout;
>  };
>
>  static inline struct request_sock *inet_reqsk(const struct sock *sk)
> @@ -104,6 +105,7 @@ reqsk_alloc(const struct request_sock_ops *ops, struct sock *sk_listener,
>         sk_node_init(&req_to_sk(req)->sk_node);
>         sk_tx_queue_clear(req_to_sk(req));
>         req->saved_syn = NULL;
> +       req->timeout = 0;
>         req->num_timeout = 0;
>         req->num_retrans = 0;
>         req->sk = NULL;
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 3166dc15d7d6..e328d6735e38 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -2323,7 +2323,7 @@ static inline u32 tcp_timeout_init(struct sock *sk)
>
>         if (timeout <= 0)
>                 timeout = TCP_TIMEOUT_INIT;
> -       return timeout;
> +       return min_t(int, timeout, TCP_RTO_MAX);
>  }
>
>  static inline u32 tcp_rwnd_init_bpf(struct sock *sk)
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 0d477c816309..cdf16285e193 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -870,7 +870,9 @@ static void reqsk_timer_handler(struct timer_list *t)
>
>                 if (req->num_timeout++ == 0)
>                         atomic_dec(&queue->young);
> -               timeo = min(TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
> +               timeo = min_t(unsigned long,
> +                             (unsigned long)req->timeout << req->num_timeout,
> +                             TCP_RTO_MAX);

would it make sense to have a helper tcp_timeout_max() to reduce
clutter? but that can be done by a later refactor patch

>                 mod_timer(&req->rsk_timer, jiffies + timeo);
>
>                 if (!nreq)
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 3f7bd7ae7d7a..5c181dc4e96f 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -6706,6 +6706,7 @@ struct request_sock *inet_reqsk_alloc(const struct request_sock_ops *ops,
>                 ireq->ireq_state = TCP_NEW_SYN_RECV;
>                 write_pnet(&ireq->ireq_net, sock_net(sk_listener));
>                 ireq->ireq_family = sk_listener->sk_family;
> +               req->timeout = TCP_TIMEOUT_INIT;
>         }
>
>         return req;
> @@ -6922,9 +6923,10 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
>                 sock_put(fastopen_sk);
>         } else {
>                 tcp_rsk(req)->tfo_listener = false;
> -               if (!want_cookie)
> -                       inet_csk_reqsk_queue_hash_add(sk, req,
> -                               tcp_timeout_init((struct sock *)req));
> +               if (!want_cookie) {
> +                       req->timeout = tcp_timeout_init((struct sock *)req);
> +                       inet_csk_reqsk_queue_hash_add(sk, req, req->timeout);
> +               }
>                 af_ops->send_synack(sk, dst, &fl, req, &foc,
>                                     !want_cookie ? TCP_SYNACK_NORMAL :
>                                                    TCP_SYNACK_COOKIE,
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index 0a4f3f16140a..9ebcd554f601 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -583,6 +583,8 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
>                 tcp_parse_options(sock_net(sk), skb, &tmp_opt, 0, NULL);
>
>                 if (tmp_opt.saw_tstamp) {
> +                       unsigned long timeo;
> +
>                         tmp_opt.ts_recent = req->ts_recent;
>                         if (tmp_opt.rcv_tsecr)
>                                 tmp_opt.rcv_tsecr -= tcp_rsk(req)->ts_off;
> @@ -590,7 +592,10 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
>                          * it can be estimated (approximately)
>                          * from another data.
>                          */
> -                       tmp_opt.ts_recent_stamp = ktime_get_seconds() - ((TCP_TIMEOUT_INIT/HZ)<<req->num_timeout);
> +                       timeo = min_t(unsigned long,
> +                                     (unsigned long)req->timeout << req->num_timeout,
> +                                     TCP_RTO_MAX);
> +                       tmp_opt.ts_recent_stamp = ktime_get_seconds() - timeo / HZ;
>                         paws_reject = tcp_paws_reject(&tmp_opt, th->rst);
>                 }
>         }
> @@ -629,8 +634,9 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
>                     !inet_rtx_syn_ack(sk, req)) {
>                         unsigned long expires = jiffies;
>
> -                       expires += min(TCP_TIMEOUT_INIT << req->num_timeout,
> -                                      TCP_RTO_MAX);
> +                       expires += min_t(unsigned long,
> +                                        (unsigned long)req->timeout << req->num_timeout,
> +                                        TCP_RTO_MAX);
>                         if (!fastopen)
>                                 mod_timer_pending(&req->rsk_timer, expires);
>                         else
> --
> 2.17.1
>
