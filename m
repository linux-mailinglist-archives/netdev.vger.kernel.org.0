Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8303CE25A
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 18:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348142AbhGSPaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 11:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349053AbhGSPZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 11:25:16 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38507C05BD15
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 08:20:02 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id b13so28484669ybk.4
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 08:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j/mMD5FrwiFmd60yHCBx8dOAIgXil325rkA3OJud0Fg=;
        b=wMIJgeRqIdlcaeA8b2mAO/4XrXBibdjqmZYcV9w/DO//l2emk+vHG5kblUs3w7VccS
         TDQyRtlrol/RLcuV1oqGQcGVLxmO3Oa0OcaoL46UTVVxggTGTl5qilEYGkH5Nug/8Oli
         MpncizMHAUd65eEyDAsFdahPdSjh3hbleAmQpn0WdiIJ46LZXU+RrSCNkx5ueo2ZvOKp
         LBo9U+3UrtLoC3Mjy//DnejzlmaMaAWHr1kNhf+4Y/hfmvNP9pESD8XsXeNEiCYXnbT5
         XEyHeXZRpXDWL5F1YyqTtOZKSmvKbShbl/hlgF7/BmNK1vZ5YyHXMqUml+Kppq0GqGjE
         HX2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j/mMD5FrwiFmd60yHCBx8dOAIgXil325rkA3OJud0Fg=;
        b=Qg3/rHopVt42SsREx04UPgj+xs7vmg2+CC359DEAIfaFfCiMbr1d+Mr9EGCN2/56So
         xkns0/6JmWvP1vJaNi8PhQQXM8T3TIBuB6mREfiI4bivM6V+13yPRYhwfbRLF1jqv1ze
         WZpiCB1byudK9iIQDjYSAVtVTsH0OQP17uaD0ccavipJ14e6HnnULn4aS6RnvtVolljq
         tEuEq/sXqDvOrCyzVqDHWUr3aHlwWoYQkTY6gFa4d0l1B8T5/cjSOK0yKtlh7GElZFEF
         4pkWoPZv7cARLr4fAKrFV5ytiGzoCs1ZUDyYoJQHCNLg95BvL2i3r+CbQzDBaQdfLQ14
         1K8w==
X-Gm-Message-State: AOAM532Li0j9gSh5k0Qzbs6bRD8eA2w4m+J+xH00G5C60ux5Tbo3WRQ0
        4NcA+xa+R4zlcDDXIq8sca0qdwFnWx1XE9EaYWk1Ig==
X-Google-Smtp-Source: ABdhPJzPrxvxY9dQnh62tQdCHRUcfFU+sVOwuoA2uUWcKPJ2V2s9VDnnGVCFWOWgX5+quNMj3qw4ilP+yAC227tUEto=
X-Received: by 2002:a25:32c1:: with SMTP id y184mr34648707yby.187.1626709629834;
 Mon, 19 Jul 2021 08:47:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210719101107.3203943-1-eric.dumazet@gmail.com>
In-Reply-To: <20210719101107.3203943-1-eric.dumazet@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 19 Jul 2021 08:46:58 -0700
Message-ID: <CAEA6p_BRQPHnFcLqKKkzPn4csMM-w86VgwBhtbPJOsShEjYGRA@mail.gmail.com>
Subject: Re: [PATCH net-next] net/tcp_fastopen: remove tcp_fastopen_ctx_lock
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 3:11 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Remove the (per netns) spinlock in favor of xchg() atomic operations.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Wei Wang <weiwan@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> ---

Acked-by: Wei Wang <weiwan@google.com>

>  include/net/netns/ipv4.h |  1 -
>  net/ipv4/tcp_fastopen.c  | 17 +++--------------
>  net/ipv4/tcp_ipv4.c      |  1 -
>  3 files changed, 3 insertions(+), 16 deletions(-)
>
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index b8620519eace8191c76c41f37bd51ac0d3788bc2..2f65701a43c953bd3a9a9e3d491882cb7bb11859 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -174,7 +174,6 @@ struct netns_ipv4 {
>         int sysctl_tcp_fastopen;
>         const struct tcp_congestion_ops __rcu  *tcp_congestion_control;
>         struct tcp_fastopen_context __rcu *tcp_fastopen_ctx;
> -       spinlock_t tcp_fastopen_ctx_lock;
>         unsigned int sysctl_tcp_fastopen_blackhole_timeout;
>         atomic_t tfo_active_disable_times;
>         unsigned long tfo_active_disable_stamp;
> diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
> index 47c32604d38fca960d2cd56f3588bfd2e390b789..1a9fbd5448a719bb5407a8d1e8fbfbe54f56f258 100644
> --- a/net/ipv4/tcp_fastopen.c
> +++ b/net/ipv4/tcp_fastopen.c
> @@ -55,12 +55,7 @@ void tcp_fastopen_ctx_destroy(struct net *net)
>  {
>         struct tcp_fastopen_context *ctxt;
>
> -       spin_lock(&net->ipv4.tcp_fastopen_ctx_lock);
> -
> -       ctxt = rcu_dereference_protected(net->ipv4.tcp_fastopen_ctx,
> -                               lockdep_is_held(&net->ipv4.tcp_fastopen_ctx_lock));
> -       rcu_assign_pointer(net->ipv4.tcp_fastopen_ctx, NULL);
> -       spin_unlock(&net->ipv4.tcp_fastopen_ctx_lock);
> +       ctxt = xchg((__force struct tcp_fastopen_context **)&net->ipv4.tcp_fastopen_ctx, NULL);
>
>         if (ctxt)
>                 call_rcu(&ctxt->rcu, tcp_fastopen_ctx_free);
> @@ -89,18 +84,12 @@ int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
>                 ctx->num = 1;
>         }
>
> -       spin_lock(&net->ipv4.tcp_fastopen_ctx_lock);
>         if (sk) {
>                 q = &inet_csk(sk)->icsk_accept_queue.fastopenq;
> -               octx = rcu_dereference_protected(q->ctx,
> -                       lockdep_is_held(&net->ipv4.tcp_fastopen_ctx_lock));
> -               rcu_assign_pointer(q->ctx, ctx);
> +               octx = xchg((__force struct tcp_fastopen_context **)&q->ctx, ctx);
>         } else {
> -               octx = rcu_dereference_protected(net->ipv4.tcp_fastopen_ctx,
> -                       lockdep_is_held(&net->ipv4.tcp_fastopen_ctx_lock));
> -               rcu_assign_pointer(net->ipv4.tcp_fastopen_ctx, ctx);
> +               octx = xchg((__force struct tcp_fastopen_context **)&net->ipv4.tcp_fastopen_ctx, ctx);
>         }
> -       spin_unlock(&net->ipv4.tcp_fastopen_ctx_lock);
>
>         if (octx)
>                 call_rcu(&octx->rcu, tcp_fastopen_ctx_free);
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index b9dc2d6197be8b8b03a4d052ad1c87987c7a62aa..e9321dd39cdbcb664843d4ada09a21685b93abb7 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2964,7 +2964,6 @@ static int __net_init tcp_sk_init(struct net *net)
>         net->ipv4.sysctl_tcp_comp_sack_slack_ns = 100 * NSEC_PER_USEC;
>         net->ipv4.sysctl_tcp_comp_sack_nr = 44;
>         net->ipv4.sysctl_tcp_fastopen = TFO_CLIENT_ENABLE;
> -       spin_lock_init(&net->ipv4.tcp_fastopen_ctx_lock);
>         net->ipv4.sysctl_tcp_fastopen_blackhole_timeout = 60 * 60;
>         atomic_set(&net->ipv4.tfo_active_disable_times, 0);
>
> --
> 2.32.0.402.g57bb445576-goog
>
