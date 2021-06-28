Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217D33B6750
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 19:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhF1RM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 13:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbhF1RM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 13:12:27 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDDBC061760
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 10:10:01 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id x12so10449063vsp.4
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 10:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mo3OdiLTZvGcXxBpncIESoNRczm8dPaHap71ZY+M2V0=;
        b=vIIyxo7OmqipykkX5c7TZY0dBl2DBO3LJAsvk6kupavZ/V87biwTFvAdI+3oiiDJX+
         EzSvGXjyp22IIwsK7mBLNaYK555SXWp/BRJ0EhlU636KrVcvtIAssh5/qazVZqfrqcuF
         92aIwWe3w8N96gfULh0Ql+FKm+XbNgVhqm0e/M2O3+0TR6w6FCUycRXn0Jw4F/JcKgUk
         LsF/f8FZNQLv+CpRz5a7Ruq6qCmvTmH/c5Fy8hb8bLFq18kpNQ74EBh7HGgcau3OuQoq
         XAiVrjqI5gMizAgWSksVHOLw/nOB4/PnbeLua3/N28XxnwCnK6rVI0SCLJ4q4CN3/5hk
         tr7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mo3OdiLTZvGcXxBpncIESoNRczm8dPaHap71ZY+M2V0=;
        b=Fp9x4/7tpe2IsyGbYrkG8KBVqkEkLkgd+VoALzkrP/fZqRpfeme3oHgXrl3/x+IlIt
         V6u81s4LiTFcj2As6j0hwtk3Eq2GOfq8Qy9yHyob2U21mDfrsLIba84DTN7EFKwylcgm
         DVhLre53suqqu3Z0jJd5gJDGRDEP3zzJPaSI9nzgMx/k96nZlpfLOZjBsdW0AGesIqD9
         6e74DK1vfY/Feiqr9ZxJRLNhh7M2qYZODVIxajD480f4ZmpVnQRg2rcygKWlfLpHgMs3
         sov594UVejrX/ZPvjvgwsoLFb/+WQYsUWc+0Whv0C2Yy/EXAKSGWQKVdSpVCJBtoLoLX
         tupQ==
X-Gm-Message-State: AOAM530J7XphMGAQ4ZHiq6/I0ErtIClWB/1h50q4CyidJfkJjmcSGNSl
        X9zoh5Ks5DJnRhPUT+Y1YTrQ8SMsk84ItsLNQHXGdQ==
X-Google-Smtp-Source: ABdhPJxZvUL4IYU2328Efy3AR47Zraw12zY2/+WkyDw8j3H3zqpchIbYSF4iWNXEHqJseW4aHy4U7rx1BK2J5qYZGL4=
X-Received: by 2002:a67:f244:: with SMTP id y4mr20182870vsm.52.1624900200466;
 Mon, 28 Jun 2021 10:10:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210628144908.881499-1-phind.uet@gmail.com>
In-Reply-To: <20210628144908.881499-1-phind.uet@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 28 Jun 2021 13:09:43 -0400
Message-ID: <CADVnQy=QDCFi8mj249krPyPZmPickEaC+3z_7-tCSvsde65xOw@mail.gmail.com>
Subject: Re: [PATCH] tcp: Do not reset the icsk_ca_initialized in tcp_init_transfer.
To:     Nguyen Dinh Phi <phind.uet@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 11:39 AM Nguyen Dinh Phi <phind.uet@gmail.com> wrote:
>
> icsk_ca_initialized be always set to zero before we examine it in if
> block, this makes the congestion control module's initialization be
> called even if the CC module was initialized already.
> In case the CC module allocates and setups its dynamically allocated
> private data in its init() function, e.g, CDG, the memory leak may occur.
>
> Reported-by: syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com
>
> Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
> ---
>  net/ipv4/tcp_input.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 7d5e59f688de..855ada2be25e 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5922,7 +5922,6 @@ void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb)
>                 tp->snd_cwnd = tcp_init_cwnd(tp, __sk_dst_get(sk));
>         tp->snd_cwnd_stamp = tcp_jiffies32;
>
> -       icsk->icsk_ca_initialized = 0;

If this patch removes that line, then AFAICT the patch should also
insert a corresponding:

  icsk->icsk_ca_initialized = 0;

in tcp_ca_openreq_child(), so that any non-zero icsk_ca_initialized
value in a listener socket (on which setsockopt(TCP_CONGESTION) was
called)  is not erroneously inherited by a child socket due to the
tcp_create_openreq_child() -> inet_csk_clone_lock() -> sock_copy()
call chain. Something like:

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index c48d8336f26d..4d6a76dfa1c4 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -446,6 +446,7 @@ void tcp_ca_openreq_child(struct sock *sk, const
struct dst_entry *dst)
        }

        /* If no valid choice made yet, assign current system default ca. */
+       icsk->icsk_ca_initialized = 0;
        if (!ca_got_dst &&
            (!icsk->icsk_ca_setsockopt ||
             !bpf_try_module_get(icsk->icsk_ca_ops, icsk->icsk_ca_ops->owner)))

thanks,
neal
