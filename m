Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF8E509279
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 00:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344465AbiDTWHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 18:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241241AbiDTWHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 18:07:01 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB0E15710;
        Wed, 20 Apr 2022 15:04:13 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id r12so3386750iod.6;
        Wed, 20 Apr 2022 15:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AqSqh/QUGJKPRLizwmCZ1Lq3K6HPJDw5uOsD7B6yAig=;
        b=ZK4n/n9duOs+/Cjo6ytagt0HtFG+kY7KIzKS4vn5w4wjZbk2hMa4sizowGME1pzJo2
         MoZHsTxRDMBkio0bMKqxzbYXIudKlmRPDmH/8xXrMcQW7OW000H5Ew5vz/8Ol84RVPD2
         tKoRK71/0ecWZ8blcsakFhipiEP5hYgOD9lypjAIMj8BNwkX0lns15CaJ4CChTKl1Ag3
         YBqavtW8zQ24xRY7SuZsQYd0jL3DNrmG0AjBz4/lXEGLfCTMJy5Iym/r0+KcPmbIdxOb
         5pctsDk+K7FltswMy8IaRFzOkzpE3r2LPoGqmC7ogmEbtLv2Z+ALjAZHcmhx0ALXii+l
         gcwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AqSqh/QUGJKPRLizwmCZ1Lq3K6HPJDw5uOsD7B6yAig=;
        b=gW6dyITp1nyxgXzN2URM1BWZ/7jZwC4iMrsT6axX14MbLfOll7QyExJbPKPQiT94Fs
         43JyNaUX3/77hOzXjp0uDYbht8vhLpzkoPq3cvAjdg1c5wSZxVYtEFr7sjmLvjwUof5j
         HQ8R2A56m/c285cZ918yAmwcu6lITcKQZe/mz+SBMAd0A8c3fHgO5RuiX5xLChTRHzFC
         fPrvN1Ht/M+lwMFFBDlMQvsHE7eKtOrOsI6XTU1S2ORclAtdaVVM3D0P9HPMc/KFUAj+
         Q76CERrBFgVKgj9yoouEwiyjC0HpXvuIYfrJlAAq+seOIL8lrX9RPminbz6Ief6ZLpKc
         4nnw==
X-Gm-Message-State: AOAM532P8ra9zSmSaVVZ0r7dXMBGw+oD5qAlMolm8HO/FUxVHy9TM9Ou
        H2ngac+64yjnBWJ4adgFkVxFNvBfQfdnoXc/TtE=
X-Google-Smtp-Source: ABdhPJylkc2Y1Ec4U0fUYQ8YccC7Fwk9LjkqTODP1UknYReLEBz9QxfvuMDvykoFAmm3LT0JpUxL4FOrPraTtBoyp1k=
X-Received: by 2002:a02:a18c:0:b0:326:6de8:ed2f with SMTP id
 n12-20020a02a18c000000b003266de8ed2fmr11040398jah.237.1650492252993; Wed, 20
 Apr 2022 15:04:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220419222259.287515-1-sdf@google.com>
In-Reply-To: <20220419222259.287515-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Apr 2022 15:04:01 -0700
Message-ID: <CAEf4BzYoA4xvqv7SaM2TvcbKef=m4n6TSGVNA34T2we05fRwpw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: use bpf_prog_run_array_cg_flags everywhere
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 3:23 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Rename bpf_prog_run_array_cg_flags to bpf_prog_run_array_cg and
> use it everywhere. check_return_code already enforces sane
> return ranges for all cgroup types. (only egress and bind hooks have
> uncanonical return ranges, the rest is using [0, 1])
>
> No functional changes.
>
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/linux/bpf-cgroup.h |  8 ++---
>  kernel/bpf/cgroup.c        | 70 ++++++++++++--------------------------
>  2 files changed, 24 insertions(+), 54 deletions(-)
>
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 88a51b242adc..669d96d074ad 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -225,24 +225,20 @@ static inline bool cgroup_bpf_sock_enabled(struct sock *sk,
>
>  #define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, atype)                                      \
>  ({                                                                            \
> -       u32 __unused_flags;                                                    \
>         int __ret = 0;                                                         \
>         if (cgroup_bpf_enabled(atype))                                         \
>                 __ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, atype,     \
> -                                                         NULL,                \
> -                                                         &__unused_flags);    \
> +                                                         NULL, NULL);         \
>         __ret;                                                                 \
>  })
>
>  #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, atype, t_ctx)                  \
>  ({                                                                            \
> -       u32 __unused_flags;                                                    \
>         int __ret = 0;                                                         \
>         if (cgroup_bpf_enabled(atype))  {                                      \
>                 lock_sock(sk);                                                 \
>                 __ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, atype,     \
> -                                                         t_ctx,               \
> -                                                         &__unused_flags);    \
> +                                                         t_ctx, NULL);        \
>                 release_sock(sk);                                              \
>         }                                                                      \
>         __ret;                                                                 \
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 0cb6211fcb58..f61eca32c747 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -25,50 +25,18 @@ EXPORT_SYMBOL(cgroup_bpf_enabled_key);
>  /* __always_inline is necessary to prevent indirect call through run_prog
>   * function pointer.
>   */
> -static __always_inline int
> -bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
> -                           enum cgroup_bpf_attach_type atype,
> -                           const void *ctx, bpf_prog_run_fn run_prog,
> -                           int retval, u32 *ret_flags)
> -{
> -       const struct bpf_prog_array_item *item;
> -       const struct bpf_prog *prog;
> -       const struct bpf_prog_array *array;
> -       struct bpf_run_ctx *old_run_ctx;
> -       struct bpf_cg_run_ctx run_ctx;
> -       u32 func_ret;
> -
> -       run_ctx.retval = retval;
> -       migrate_disable();
> -       rcu_read_lock();
> -       array = rcu_dereference(cgrp->effective[atype]);
> -       item = &array->items[0];
> -       old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
> -       while ((prog = READ_ONCE(item->prog))) {
> -               run_ctx.prog_item = item;
> -               func_ret = run_prog(prog, ctx);
> -               if (!(func_ret & 1) && !IS_ERR_VALUE((long)run_ctx.retval))
> -                       run_ctx.retval = -EPERM;
> -               *(ret_flags) |= (func_ret >> 1);
> -               item++;
> -       }
> -       bpf_reset_run_ctx(old_run_ctx);
> -       rcu_read_unlock();
> -       migrate_enable();
> -       return run_ctx.retval;
> -}
> -
>  static __always_inline int
>  bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
>                       enum cgroup_bpf_attach_type atype,
>                       const void *ctx, bpf_prog_run_fn run_prog,
> -                     int retval)
> +                     int retval, u32 *ret_flags)
>  {
>         const struct bpf_prog_array_item *item;
>         const struct bpf_prog *prog;
>         const struct bpf_prog_array *array;
>         struct bpf_run_ctx *old_run_ctx;
>         struct bpf_cg_run_ctx run_ctx;
> +       u32 func_ret;
>
>         run_ctx.retval = retval;
>         migrate_disable();
> @@ -78,8 +46,11 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
>         old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
>         while ((prog = READ_ONCE(item->prog))) {
>                 run_ctx.prog_item = item;
> -               if (!run_prog(prog, ctx) && !IS_ERR_VALUE((long)run_ctx.retval))
> +               func_ret = run_prog(prog, ctx);
> +               if (!(func_ret & 1) && !IS_ERR_VALUE((long)run_ctx.retval))

to be completely true to previous behavior, shouldn't there be

if (ret_flags)
    func_ret &= 1;
if (!func_ret && !IS_ERR_VALUE(...))

here?

This might have been discussed previously and I missed it. If that's
so, please ignore.


>                         run_ctx.retval = -EPERM;
> +               if (ret_flags)
> +                       *(ret_flags) |= (func_ret >> 1);
>                 item++;
>         }
>         bpf_reset_run_ctx(old_run_ctx);

[..]
