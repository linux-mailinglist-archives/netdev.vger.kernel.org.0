Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EF32FF8F6
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 00:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbhAUXde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 18:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbhAUXdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 18:33:32 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79CFC06174A;
        Thu, 21 Jan 2021 15:32:51 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id r32so3754819ybd.5;
        Thu, 21 Jan 2021 15:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C35DAsDroDMGIM4MMP/P6qJgJuHQSd/cD+Jb12xBf3g=;
        b=Apbw0vO93JmJbwU/yJK7bayXp92Nyji3WGiv7dMrDtrmUt4YN7loBbnFKDN2gOItgW
         /7EMuFaBmhXFPI12sjvc2o0otTB/pbs1kSDOHOe+1AnMoLZKQoGnnpJnbHKj6n3J9Llm
         B5dhkJ7sMHdDoUQ/FGoUwF3HZzoGa4hGNCN+w1o2We83ZGMQtd31t8RvLgSGldU17NBb
         XbcPwWaJDEhceclGSf0nKzJktIqxYCJIkalAl/Ugc4aG5fATF2BkahAffOfL6AQ70iH1
         deeZhFG3+WQ5C+PQbYdAmRkpIQz0S5RnoEmygb8f9lr1ZACYxvt4Ycm8xY1OBfoc7Ym9
         xYgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C35DAsDroDMGIM4MMP/P6qJgJuHQSd/cD+Jb12xBf3g=;
        b=ZBiESZofN0Wgu0HNbXGV177MXFRbvLie/z3IeCoadkfvbdqADdfabzi5uVn6N4E21l
         zGlsAMAT+PR7YedYbTx+1tcfMOimETGOcB76gTlU4z/DVaTMuyRel2H/MlgSfZfXaEah
         T2x5irWG1hEKpMN9O9LwvgDMvRhrRATcUMJkGG0omCMXnYVvM7TP0iuhRctlcEm7amjQ
         ZcfbNxzbG66T3tuzES04hvPEucvNU/ZFuBS4SK+AdKEP3o8KoP88rIDun5PzlLE44aj9
         QzE7Kke2KCOZ2U6mNuDH8NFvh1f0mLYJcAfWRw9EIxt8geLyxKjVg1pW+CMjM7g20/Oy
         DK+w==
X-Gm-Message-State: AOAM531CvTCIXCgFIhH0kifkyyq7rxOy9Ka00jOcORR82hCzN4GOJ6LK
        Q9kx/UDHLYfDxkablYgW0x11RXmpJt1QB7H454I=
X-Google-Smtp-Source: ABdhPJyL0ewKMDLbSTGtIweOcKpLoQvr2K7sPQXPnxWclNHXupHIeuyAWNeykewGSbIkx1fALMF+s+T4AdnmHAimgHw=
X-Received: by 2002:a25:d6d0:: with SMTP id n199mr2484251ybg.27.1611271971000;
 Thu, 21 Jan 2021 15:32:51 -0800 (PST)
MIME-Version: 1.0
References: <20210121202203.9346-1-jolsa@kernel.org> <20210121202203.9346-3-jolsa@kernel.org>
In-Reply-To: <20210121202203.9346-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 Jan 2021 15:32:40 -0800
Message-ID: <CAEf4BzZquSn0Th7bpVuM0M4XbTPU5-9jDPPd5RJBS5AH2zqaMA@mail.gmail.com>
Subject: Re: [PATCH 2/3] bpf_encoder: Translate SHN_XINDEX in symbol's
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

On Thu, Jan 21, 2021 at 12:25 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> For very large ELF objects (with many sections), we could
> get special value SHN_XINDEX (65535) for symbol's st_shndx.
>
> This patch is adding code to detect the optional extended
> section index table and use it to resolve symbol's section
> index.
>
> Adding elf_symtab__for_each_symbol_index macro that returns
> symbol's section index and usign it in collect_symbols function.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

You missed fixing up collect_function() as well, which is using
elf_sym__section(), which doesn't know about extended numbering.

>  btf_encoder.c | 36 ++++++++++++++++++++++++++++++++----
>  elf_symtab.c  | 39 ++++++++++++++++++++++++++++++++++++++-
>  elf_symtab.h  |  2 ++
>  3 files changed, 72 insertions(+), 5 deletions(-)
>
> diff --git a/btf_encoder.c b/btf_encoder.c
> index 5557c9efd365..6e6f22c438ce 100644
> --- a/btf_encoder.c
> +++ b/btf_encoder.c
> @@ -585,12 +585,13 @@ static int collect_percpu_var(struct btf_elf *btfe, GElf_Sym *sym)
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
> @@ -598,9 +599,36 @@ static void collect_symbol(GElf_Sym *sym, struct funcs_layout *fl)
>                 fl->mcount_stop = sym->st_value;
>  }
>
> +static bool elf_sym__get(Elf_Data *syms, Elf_Data *syms_sec_idx_table,
> +                        int id, GElf_Sym *sym, Elf32_Word *sym_sec_idx)
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


gelf_getsymshndx() is supposed to work even for cases that don't use
extended numbering, so this should work, right?

if (!gelf_getsymshndx(syms, syms_sec_idx_table, id, sym, sym_sec_idx))
    return false;

if (sym->st_shndx == SHN_XINDEX)
  *sym_sec_idx = sym->st_shndx;

return true;

?

> +                       return false;
> +       }
> +
> +       return true;
> +}
> +
> +#define elf_symtab__for_each_symbol_index(symtab, id, sym, sym_sec_idx)                \
> +       for (id = 0, elf_sym__get(symtab->syms, symtab->syms_sec_idx_table,     \
> +                                 id, &sym, &sym_sec_idx);                      \
> +            id < symtab->nr_syms;                                              \
> +            id++, elf_sym__get(symtab->syms, symtab->syms_sec_idx_table,       \
> +                               id, &sym, &sym_sec_idx))

what do we want to do if elf_sym__get() returns error (false)? We can
either stop or ignore that symbol, right? But currently you are
returning invalid symbol data.

so either

for (id = 0; id < symtab->nr_syms && elf_sym__get(symtab->syms,
symtab->syms_sec_idx_table, d, &sym, &sym_sec_idx); id++)

or

for (id = 0; id < symtab->nr_syms; id++)
  if (elf_sym__get(symtab->syms, symtab->syms_sec_idx_table, d, &sym,
&sym_sec_idx))


But the current variant looks broken. Oh, and
elf_symtab__for_each_symbol() is similarly broken, can you please fix
that as well?

And this new macro should probably be in elf_symtab.h, along the
elf_symtab__for_each_symbol.


> +
>  static int collect_symbols(struct btf_elf *btfe, bool collect_percpu_vars)
>  {
>         struct funcs_layout fl = { };
> +       Elf32_Word sym_sec_idx;
>         uint32_t core_id;
>         GElf_Sym sym;
>

[...]
