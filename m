Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED162219D4
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 04:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgGPCXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 22:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbgGPCXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 22:23:22 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B852BC061755;
        Wed, 15 Jul 2020 19:23:21 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id u12so3694671qth.12;
        Wed, 15 Jul 2020 19:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AHCM/Vm5YPHkzx659hJjD3hc5D8Y8Z+WICzJA1TTTs4=;
        b=Z+rzZo0l6JOcbbW9FHKOG3DhIeabG9zdxaDviLComxfuASqK6vgEhh0GG7wQdm5A3e
         Y48hEygXFK64oWNPSoJdknPWGhPl5Hc29MNHx2RwkZsnQxBdV8VNuA2J69ZgAkKZ5Fzs
         oVOWabSkxMUzMT8X0promatHtal2HbyUQggAixWFVt+KzQW4sVrwPX/mrqZn7MU7vGzU
         Xks/fr0H/kjalySJvTBDzUpA3PVl/Mz6zPcPnuxRo4SPYfaqXXMQnzvVDNJbKEsT2JMR
         XsxAEuG0T814p2ZC5gGX6i7jS+nX0buwQZXuYOPX5nqKjIdTNS/y/5757KQOPwI/K9Bl
         SMeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AHCM/Vm5YPHkzx659hJjD3hc5D8Y8Z+WICzJA1TTTs4=;
        b=C8ykoevGo6GrqlhF6IhtlcRkUe3kuUVRwPakKHh5EfFWpGuDaaO0Fx+WuVNbPLJTYO
         fxCa4jU1pBSiExtJhdn2hbKVz7PttFxT7YGlvrZYkE5A2+1BDyihjjPSTs1qOr3C8HMW
         +P9lVpDx0tEsJzh5BbRO6biOebFNtxXN009RsvrtWDJ7FwLIF+wZDJAPrg5LtlVqCXwb
         Fw+KwhbM1piaSaRUqN9oU7NMckkVjC17yLBn52PMoacN02buJbDy/pzircelHQ01zSll
         l7pKZql8EOf31c8jb6UKjKHnrKtxINdd2Ou6uApPdeFB4qVA93U9uxpFWTgIp7SPVHcN
         +YCg==
X-Gm-Message-State: AOAM5306s8wPYNe9ymGRHt7HrkKIWVL9Z/Fenv1Q5w9ADfqnX4W2bPGG
        zT9YK9dfmg70r4t+dhk0M0aAbCGl+BQvmu/no80=
X-Google-Smtp-Source: ABdhPJwJe6oCaGZvcIHjWnINnsndXWILkvDTm2TQyVjA2h1FcY8PjInTdx9W5erpJa1Mbq2tIN1YQ1DtrDtKuLEg+5k=
X-Received: by 2002:aed:2cc5:: with SMTP id g63mr2893348qtd.59.1594866200813;
 Wed, 15 Jul 2020 19:23:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200713174654.642628-1-jakub@cloudflare.com> <20200713174654.642628-5-jakub@cloudflare.com>
In-Reply-To: <20200713174654.642628-5-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jul 2020 19:23:09 -0700
Message-ID: <CAEf4BzY0Gc_FH=KUWY3xz6qG8yk+0U0mjXcAx7+39tWt_kQnGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 04/16] inet: Run SK_LOOKUP BPF program on
 socket lookup
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 10:47 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Run a BPF program before looking up a listening socket on the receive path.
> Program selects a listening socket to yield as result of socket lookup by
> calling bpf_sk_assign() helper and returning SK_PASS code. Program can
> revert its decision by assigning a NULL socket with bpf_sk_assign().
>
> Alternatively, BPF program can also fail the lookup by returning with
> SK_DROP, or let the lookup continue as usual with SK_PASS on return, when
> no socket has not been selected with bpf_sk_assign(). Other return values

you probably meant "no socket has been selected"?

> are treated the same as SK_DROP.


Why not enforce it instead? Check check_return_code() in verifier.c,
it's trivial to do it for SK_LOOKUP.


>
> This lets the user match packets with listening sockets freely at the last
> possible point on the receive path, where we know that packets are destined
> for local delivery after undergoing policing, filtering, and routing.
>
> With BPF code selecting the socket, directing packets destined to an IP
> range or to a port range to a single socket becomes possible.
>
> In case multiple programs are attached, they are run in series in the order
> in which they were attached. The end result is determined from return codes
> of all the programs according to following rules:
>
>  1. If any program returned SK_PASS and selected a valid socket, the socket
>     is used as result of socket lookup.
>  2. If more than one program returned SK_PASS and selected a socket,
>     last selection takes effect.
>  3. If any program returned SK_DROP or an invalid return code, and no
>     program returned SK_PASS and selected a socket, socket lookup fails
>     with -ECONNREFUSED.
>  4. If all programs returned SK_PASS and none of them selected a socket,
>     socket lookup continues to htable-based lookup.
>
> Suggested-by: Marek Majkowski <marek@cloudflare.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>
> Notes:
>     v4:
>     - Reduce BPF sk_lookup prog return codes to SK_PASS/SK_DROP. (Lorenz)

your description above still assumes prog can return something besides
SK_PASS and SK_DROP?

>     - Default to drop & warn on illegal return value from BPF prog. (Lorenz)
>     - Rename netns_bpf_attach_type_enable/disable to _need/unneed. (Lorenz)
>     - Export bpf_sk_lookup_enabled symbol for CONFIG_IPV6=m (kernel test robot)
>     - Invert return value from bpf_sk_lookup_run_v4 to true on skip reuseport.
>     - Move dedicated prog_array runner close to its callers in filter.h.
>
>     v3:
>     - Use a static_key to minimize the hook overhead when not used. (Alexei)
>     - Adapt for running an array of attached programs. (Alexei)
>     - Adapt for optionally skipping reuseport selection. (Martin)
>
>  include/linux/filter.h     | 102 +++++++++++++++++++++++++++++++++++++
>  kernel/bpf/net_namespace.c |  32 +++++++++++-
>  net/core/filter.c          |   3 ++
>  net/ipv4/inet_hashtables.c |  31 +++++++++++
>  4 files changed, 167 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 380746f47fa1..b9ad0fdabca5 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -1295,4 +1295,106 @@ struct bpf_sk_lookup_kern {
>         bool            no_reuseport;
>  };
>
> +extern struct static_key_false bpf_sk_lookup_enabled;
> +
> +/* Runners for BPF_SK_LOOKUP programs to invoke on socket lookup.
> + *
> + * Allowed return values for a BPF SK_LOOKUP program are SK_PASS and
> + * SK_DROP. Any other return value is treated as SK_DROP. Their
> + * meaning is as follows:
> + *
> + *  SK_PASS && ctx.selected_sk != NULL: use selected_sk as lookup result
> + *  SK_PASS && ctx.selected_sk == NULL: continue to htable-based socket lookup
> + *  SK_DROP                           : terminate lookup with -ECONNREFUSED
> + *
> + * This macro aggregates return values and selected sockets from
> + * multiple BPF programs according to following rules:
> + *
> + *  1. If any program returned SK_PASS and a non-NULL ctx.selected_sk,
> + *     macro result is SK_PASS and last ctx.selected_sk is used.
> + *  2. If any program returned non-SK_PASS return value,
> + *     macro result is the last non-SK_PASS return value.
> + *  3. Otherwise result is SK_PASS and ctx.selected_sk is NULL.
> + *
> + * Caller must ensure that the prog array is non-NULL, and that the
> + * array as well as the programs it contains remain valid.
> + */
> +#define BPF_PROG_SK_LOOKUP_RUN_ARRAY(array, ctx, func)                 \
> +       ({                                                              \
> +               struct bpf_sk_lookup_kern *_ctx = &(ctx);               \
> +               struct bpf_prog_array_item *_item;                      \
> +               struct sock *_selected_sk;                              \
> +               struct bpf_prog *_prog;                                 \
> +               u32 _ret, _last_ret;                                    \
> +               bool _no_reuseport;                                     \
> +                                                                       \
> +               migrate_disable();                                      \
> +               _last_ret = SK_PASS;                                    \
> +               _selected_sk = NULL;                                    \
> +               _no_reuseport = false;                                  \

these three could be moved before migrate_disable(), or even better
just initialize corresponding variables above?


> +               _item = &(array)->items[0];                             \
> +               while ((_prog = READ_ONCE(_item->prog))) {              \
> +                       /* restore most recent selection */             \
> +                       _ctx->selected_sk = _selected_sk;               \
> +                       _ctx->no_reuseport = _no_reuseport;             \
> +                                                                       \
> +                       _ret = func(_prog, _ctx);                       \
> +                       if (_ret == SK_PASS) {                          \
> +                               /* remember last non-NULL socket */     \
> +                               if (_ctx->selected_sk) {                \
> +                                       _selected_sk = _ctx->selected_sk;       \
> +                                       _no_reuseport = _ctx->no_reuseport;     \
> +                               }                                       \
> +                       } else {                                        \
> +                               /* remember last non-PASS ret code */   \
> +                               _last_ret = _ret;                       \
> +                       }                                               \
> +                       _item++;                                        \
> +               }                                                       \
> +               _ctx->selected_sk = _selected_sk;                       \
> +               _ctx->no_reuseport = _no_reuseport;                     \
> +               migrate_enable();                                       \
> +               _ctx->selected_sk ? SK_PASS : _last_ret;                \
> +        })
> +

[...]
