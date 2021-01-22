Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A95300EE7
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 22:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730019AbhAVV1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 16:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729150AbhAVURf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 15:17:35 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD777C06174A;
        Fri, 22 Jan 2021 12:16:54 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id k4so6653034ybp.6;
        Fri, 22 Jan 2021 12:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=caUFpVR6WIj9qgWvacov+DHyivBtNRs+N8epP9yO/t8=;
        b=R2UlZf13C1n+2qMYFEmGHCQpWXguM8bjrjK47G7zubr2mCGfpRj35d/tTUX5LaEroz
         kMEO2Ro6mKRg6K91HmL+13wr7sd62D80iSo1OfM8iZR546EqH63P+We6TAVjJh8/ewdQ
         wzi8AfT8we+IosttgD7datgdeEMV5lm58DeCKKdtVDF6+mAEDqiMgC0bdXHVV9Ftf/hZ
         NSQ4qNm/sGn8TDaIWtCfd14sc7jOLJEL6+PYgHfclVB0mjMwlCpdtqIyWfKrzKqTN0C2
         qbG1REx/2nPw9+wv7sF4UBFWhZS+xWjPFFfa8kM2cyw+F9eIYyYpIfyJ+DQl48Xw0Z/L
         BYkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=caUFpVR6WIj9qgWvacov+DHyivBtNRs+N8epP9yO/t8=;
        b=od5sJVsi8DfFC4VFSTpaEeSI/NeadlTQWh7iQ6anfd6ZSjEcG2DtqROoFKeEWT7YXI
         S076Xf6Qo8aajBftoTPH0txfbvVjebw0Alw9rDA/y8AC9H8qq+J8chxHzwclGg525Uxw
         DEcl48WREcE2dxVo7vhshOR8zgg3ei9VD6MNxn94MZrdZyhuXrw6hfy9PPkHOUlmKvAz
         qhjJsFxMy9a9jgunOSoIrecwkF61RaiFtly4JTgSPTV3NQvvzVN7tO3I6Rxb+eBwZoqq
         hydZAxWJKOyP0MZA3eayOGGhqZCOXnRci/H31jDnxHM2m5STk755fzRoWW2AM3ztJD2V
         RSSg==
X-Gm-Message-State: AOAM533zIxL/2ccz2iWWitAbGKBgnwaGlpY2b8ZtgUGh2OoxapquEP9T
        ljnXnGbc9cSBsjzXqRAcxPbmM2gQbguADGM1lD8=
X-Google-Smtp-Source: ABdhPJxralpJGF5PIDOEOKkhCz6tgqoquH7R0a5BTagdkhDJudHS5ZwU9sy1Q8YIvIGCvkCMXq5VEO/rY+gWn2nlY6c=
X-Received: by 2002:a25:4b86:: with SMTP id y128mr8637826yba.403.1611346614035;
 Fri, 22 Jan 2021 12:16:54 -0800 (PST)
MIME-Version: 1.0
References: <20210122163920.59177-1-jolsa@kernel.org> <20210122163920.59177-3-jolsa@kernel.org>
In-Reply-To: <20210122163920.59177-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 Jan 2021 12:16:42 -0800
Message-ID: <CAEf4BzbC-s=27vmcJ1KYLVKgGbns2py1bHny3Q_yr4v3Oe49RQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] bpf_encoder: Translate SHN_XINDEX in symbol's
 st_shndx values
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 8:46 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> For very large ELF objects (with many sections), we could
> get special value SHN_XINDEX (65535) for symbol's st_shndx.
>
> This patch is adding code to detect the optional extended
> section index table and use it to resolve symbol's section
> index.
>
> Adding elf_symtab__for_each_symbol_index macro that returns
> symbol's section index and usign it in collect functions.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  btf_encoder.c | 59 +++++++++++++++++++++++++++++++++++++--------------
>  elf_symtab.c  | 39 +++++++++++++++++++++++++++++++++-
>  elf_symtab.h  |  2 ++
>  3 files changed, 83 insertions(+), 17 deletions(-)
>
> diff --git a/btf_encoder.c b/btf_encoder.c
> index 5557c9efd365..56ee55965093 100644
> --- a/btf_encoder.c
> +++ b/btf_encoder.c
> @@ -63,13 +63,13 @@ static void delete_functions(void)
>  #define max(x, y) ((x) < (y) ? (y) : (x))
>  #endif
>
> -static int collect_function(struct btf_elf *btfe, GElf_Sym *sym)
> +static int collect_function(struct btf_elf *btfe, GElf_Sym *sym,
> +                           Elf32_Word sym_sec_idx)

nit: we use size_t or int for this, no need for libelf types here, imo



>  {
>         struct elf_function *new;
>         static GElf_Shdr sh;
> -       static int last_idx;
> +       static Elf32_Word last_idx;
>         const char *name;
> -       int idx;
>
>         if (elf_sym__type(sym) != STT_FUNC)
>                 return 0;
> @@ -90,12 +90,10 @@ static int collect_function(struct btf_elf *btfe, GElf_Sym *sym)
>                 functions = new;
>         }
>
> -       idx = elf_sym__section(sym);
> -
> -       if (idx != last_idx) {
> -               if (!elf_section_by_idx(btfe->elf, &sh, idx))
> +       if (sym_sec_idx != last_idx) {
> +               if (!elf_section_by_idx(btfe->elf, &sh, sym_sec_idx))
>                         return 0;
> -               last_idx = idx;
> +               last_idx = sym_sec_idx;
>         }
>
>         functions[functions_cnt].name = name;
> @@ -542,14 +540,15 @@ static bool percpu_var_exists(uint64_t addr, uint32_t *sz, const char **name)
>         return true;
>  }
>
> -static int collect_percpu_var(struct btf_elf *btfe, GElf_Sym *sym)
> +static int collect_percpu_var(struct btf_elf *btfe, GElf_Sym *sym,
> +                             Elf32_Word sym_sec_idx)

nit: same, size_t or just int would be fine

>  {
>         const char *sym_name;
>         uint64_t addr;
>         uint32_t size;
>
>         /* compare a symbol's shndx to determine if it's a percpu variable */
> -       if (elf_sym__section(sym) != btfe->percpu_shndx)
> +       if (sym_sec_idx != btfe->percpu_shndx)
>                 return 0;
>         if (elf_sym__type(sym) != STT_OBJECT)
>                 return 0;
> @@ -585,12 +584,13 @@ static int collect_percpu_var(struct btf_elf *btfe, GElf_Sym *sym)
>         return 0;
>  }
>
> -static void collect_symbol(GElf_Sym *sym, struct funcs_layout *fl)
> +static void collect_symbol(GElf_Sym *sym, struct funcs_layout *fl,
> +                          Elf32_Word sym_sec_idx)
>  {
>         if (!fl->mcount_start &&
>             !strcmp("__start_mcount_loc", elf_sym__name(sym, btfe->symtab))) {
>                 fl->mcount_start = sym->st_value;
> -               fl->mcount_sec_idx = sym->st_shndx;
> +               fl->mcount_sec_idx = sym_sec_idx;
>         }
>
>         if (!fl->mcount_stop &&
> @@ -598,9 +598,36 @@ static void collect_symbol(GElf_Sym *sym, struct funcs_layout *fl)
>                 fl->mcount_stop = sym->st_value;
>  }
>
> +static bool elf_sym__get(Elf_Data *syms, Elf_Data *syms_sec_idx_table,
> +                        int id, GElf_Sym *sym, Elf32_Word *sym_sec_idx)

This is a generic function, why don't you want to move it into elf_symtab.h?

> +{
> +       if (!gelf_getsym(syms, id, sym))
> +               return false;
> +
> +       *sym_sec_idx = sym->st_shndx;
> +
> +       if (sym->st_shndx == SHN_XINDEX) {
> +               if (!syms_sec_idx_table)
> +                       return false;
> +               if (!gelf_getsymshndx(syms, syms_sec_idx_table,
> +                                     id, sym, sym_sec_idx))
> +                       return false;

You also ignored my feedback about not fetching symbol twice. Why?

> +       }
> +
> +       return true;
> +}
> +
> +#define elf_symtab__for_each_symbol_index(symtab, id, sym, sym_sec_idx)                \
> +       for (id = 0;                                                            \
> +            id < symtab->nr_syms &&                                            \
> +            elf_sym__get(symtab->syms, symtab->syms_sec_idx_table,             \
> +                         id, &sym, &sym_sec_idx);                              \
> +            id++)

This should be in elf_symtab.h next to elf_symtab__for_each_symbol.

And thinking a bit more, the variant with just ignoring symbols that
we failed to get is probably a safer alternative. I.e., currently
there is no way to communicate that we terminated iteration with
error, so it's probably better to skip failed symbols and still get
the rest, no? I was hoping to discuss stuff like this on the previous
version of the patch...

And please do fix elf_symtab__for_each_symbol().

> +
>  static int collect_symbols(struct btf_elf *btfe, bool collect_percpu_vars)
>  {
>         struct funcs_layout fl = { };
> +       Elf32_Word sym_sec_idx;
>         uint32_t core_id;
>         GElf_Sym sym;
>

[...]
