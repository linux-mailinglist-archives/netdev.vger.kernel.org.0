Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C71FF15985C
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 19:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbgBKSVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 13:21:24 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43777 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbgBKSVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 13:21:23 -0500
Received: by mail-qk1-f194.google.com with SMTP id p7so6077274qkh.10;
        Tue, 11 Feb 2020 10:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TDpMd7W581bUlXP4nChfOPw5AAn6kPHGANYHSCkpwSI=;
        b=OkqXj8aQOtMCMMx8FEf15NvudCqArUtEaxErKvdpaENZRM8CVXMhZyZJw7mg5YhOTo
         PN2yJoJjUuFUC3Q/v5EVXHlF6+83k9EYMAOgOsHmnHEaT0EZtMbMWUOkQ94AZmhn9BHo
         Ig52UwRM37+CAtx0+YloiRntXmZTzZGUAkGUGfDf6GT3iCiAbP7MWY5GOgMA8D9qo1Qj
         d/K72dPnwalUGmBz9cukCEvQ1P8TKndHplfXngsZW2rvOLeWa97SZ/tsaH3yWOIuSpzU
         7gVxZVkBLhtQalIuJai6dIZqLn9ozLUcfDnN3BEfyrU++Gj71t0jy2TF8HKdsmQzxkoj
         pgxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TDpMd7W581bUlXP4nChfOPw5AAn6kPHGANYHSCkpwSI=;
        b=R3cNdfowZa7iFYx+hIC+6lws8n/ZvwpvJYYK3ci2p89jjSWX1TW7qTtT6dejPEDUz3
         tgcs9sqxwI9coHUU/zuJKFdx7CWLnYKp+3Ih7WNjCjpY8HNfM3BhQhjF1D2f2gZ6Rhji
         fu1fu4eKTasoIPAZQ33joN0l5wPMn1PBVd8D139RcYTrkb3Auls2IkSED02FZwMSG34l
         WmDkybe6aaluI56wEmwhK9L/5xpxAdJiV2OaUsZsA+T6uyCVM6XVR1ZhkWo7ZE0RCZaL
         ubTGWSeaTt7yIuwFZUrHz7PmuUy9gJ9Fd4gCMBcDlbadzHl5NtZ7f+aKvWcdVtA9oMKo
         /8RA==
X-Gm-Message-State: APjAAAWH3IYCG1AY9r8mMQUOSg4ekg8CdHJMv9dRJNKdtAw0kX6vqXbr
        IYZvi7nkKGCkNWKQu8ZWAFZHvoWXxLuZ2jmuzSA=
X-Google-Smtp-Source: APXvYqz22tH/9dNOv/buMkSQYR6CK4F/rye3pq2WIbT/3mssRTVqtufQlip4slw722rK+cLOXlybW4eowyHFbPP4AQQ=
X-Received: by 2002:a37:785:: with SMTP id 127mr7523144qkh.437.1581445281544;
 Tue, 11 Feb 2020 10:21:21 -0800 (PST)
MIME-Version: 1.0
References: <20200208154209.1797988-1-jolsa@kernel.org> <20200208154209.1797988-7-jolsa@kernel.org>
In-Reply-To: <20200208154209.1797988-7-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 11 Feb 2020 10:21:10 -0800
Message-ID: <CAEf4BzYyJBh+zh0NYTEXV=ocCCtJJ_+skeRJQJt1AKQSAEEWqw@mail.gmail.com>
Subject: Re: [PATCH 06/14] bpf: Add bpf_kallsyms_tree tree
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 8, 2020 at 7:43 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The bpf_tree is used both for kallsyms iterations and searching
> for exception tables of bpf programs, which is needed only for
> bpf programs.
>
> Adding bpf_kallsyms_tree that will hold symbols for all bpf_prog,
> bpf_trampoline and bpf_dispatcher objects and keeping bpf_tree
> only for bpf_prog objects exception tables search to keep it fast.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h |  1 +
>  kernel/bpf/core.c   | 60 ++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 55 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index da67ca3afa2f..151d7b1c8435 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -468,6 +468,7 @@ struct bpf_ksym {
>         unsigned long            end;
>         char                     name[KSYM_NAME_LEN];
>         struct list_head         lnode;
> +       struct latch_tree_node   tnode;
>  };
>
>  enum bpf_tramp_prog_type {
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index b9b7077e60f3..1daa72341450 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -606,8 +606,46 @@ static const struct latch_tree_ops bpf_tree_ops = {
>         .comp   = bpf_tree_comp,
>  };
>
> +static __always_inline unsigned long
> +bpf_get_ksym_start(struct latch_tree_node *n)

I thought static functions are never marked as inline in kernel
sources. Are there some special cases when its ok/necessary?

> +{
> +       const struct bpf_ksym *ksym;
> +
> +       ksym = container_of(n, struct bpf_ksym, tnode);
> +       return ksym->start;
> +}
> +
> +static __always_inline bool
> +bpf_ksym_tree_less(struct latch_tree_node *a,
> +                  struct latch_tree_node *b)
> +{
> +       return bpf_get_ksym_start(a) < bpf_get_ksym_start(b);
> +}
> +
> +static __always_inline int
> +bpf_ksym_tree_comp(void *key, struct latch_tree_node *n)
> +{
> +       unsigned long val = (unsigned long)key;
> +       const struct bpf_ksym *ksym;
> +
> +       ksym = container_of(n, struct bpf_ksym, tnode);
> +
> +       if (val < ksym->start)
> +               return -1;
> +       if (val >= ksym->end)
> +               return  1;
> +
> +       return 0;
> +}
> +
> +static const struct latch_tree_ops bpf_kallsyms_tree_ops = {

Given all the helper functions use bpf_ksym_tree and bpf_ksym
(bpf_ksym_find) prefixes, call this bpf_ksym_tree_ops?

> +       .less   = bpf_ksym_tree_less,
> +       .comp   = bpf_ksym_tree_comp,
> +};
> +
>  static DEFINE_SPINLOCK(bpf_lock);
>  static LIST_HEAD(bpf_kallsyms);
> +static struct latch_tree_root bpf_kallsyms_tree __cacheline_aligned;

same as above, bpf_ksym_tree for consistency?

>  static struct latch_tree_root bpf_tree __cacheline_aligned;
>
>  static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
> @@ -615,6 +653,7 @@ static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
>         WARN_ON_ONCE(!list_empty(&aux->ksym.lnode));
>         list_add_tail_rcu(&aux->ksym.lnode, &bpf_kallsyms);
>         latch_tree_insert(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
> +       latch_tree_insert(&aux->ksym.tnode, &bpf_kallsyms_tree, &bpf_kallsyms_tree_ops);
>  }
>

[...]
