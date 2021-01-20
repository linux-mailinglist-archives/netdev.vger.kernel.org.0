Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12DA2FC76F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 03:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbhATCEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728456AbhATCEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 21:04:20 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59681C061573;
        Tue, 19 Jan 2021 18:03:40 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id b11so15702413ybj.9;
        Tue, 19 Jan 2021 18:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DuJpvKb+zGEfODHyENQyTZcMz+avIndrK0WlUpuEiss=;
        b=UbtV1vS2SbMSOUNYzdTUkzfmLAtMWZhe/QCHTYktPn1HFIezRkWVvcfj+75eCe4ql7
         HdzpL+PzWOpAkr1dYPkr79347Zn/OS29G4I4utcsLlWh1Cks8ffQfrqhkf4R/g8rSx7T
         qFFuU5ovqve8mFu2TT4gSiGObQOELd4nMn8VOWFNWmXq96pIb36xTWsaZ3Mhs8rg25pj
         UqRVwprbw4nXDoOzYxoNqMS8x7HJe1Q2Fz4AJLwwB4lcDK4CMOAYhBiSte6Xfv2xQus0
         JCHQNvQlBK5pm2povE1cZ1bTOV8VbvAyk+cz1e9Sc51ErdiSRsLyb0f9MVfvq7R6UBkg
         /IVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DuJpvKb+zGEfODHyENQyTZcMz+avIndrK0WlUpuEiss=;
        b=DefnbWaz8eIEwSgZIksZu4uZ7hmkCqXBATJCv1QFW/P1mwLSoQd1jYm7z8rM0w8Xqr
         3y+fiEX4iTZaGWs78fTndqXIyqVXnUTd/6CTJsi92wObfSr/XbTc1E3X3ThKIPI4tFiB
         fOPEkTO0vuVGap23hB4BSH+D0LgpyB7oTHQPgBksSlL0bxwBCnqYE5PPkpFZsbjK3dod
         erlY+jAytpOUi43wqgybodGJuikfioo7veWpjqvHRescnBoA0Db7YT8+/YXIVQjmkh1f
         enTQst5brc7ZKwEbe/t7V9VWMCKzc28zuAHkJdgEZG/kozJS5JCIZf2KtMSX+Ity90TT
         /k/w==
X-Gm-Message-State: AOAM532GPUk+qI9OrNQubvUfIp/mtHQVC9onMHweokY0+NVUe16oApXH
        w1LpPs7TpUUn4fzX53cwDSqbP+4uFr6GN1N2UHg=
X-Google-Smtp-Source: ABdhPJyMTxhFMGmVdI3hKqNfsBoFTvfk5n/zhyfZCMV+39Fy6t9BJvT4uQsnVAh2RhG3Bt7CcP8ypjEexqpF5K2wK94=
X-Received: by 2002:a25:f40e:: with SMTP id q14mr10676148ybd.230.1611108219529;
 Tue, 19 Jan 2021 18:03:39 -0800 (PST)
MIME-Version: 1.0
References: <20210119221220.1745061-1-jolsa@kernel.org> <20210119221220.1745061-3-jolsa@kernel.org>
In-Reply-To: <20210119221220.1745061-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 19 Jan 2021 18:03:28 -0800
Message-ID: <CAEf4BzY323ioVnsDqih5kKo9Q23rOrLV6Lh-Ms+jRqAYJrCgCg@mail.gmail.com>
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

On Tue, Jan 19, 2021 at 2:16 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> For very large ELF objects (with many sections), we could
> get special value SHN_XINDEX (65535) for symbol's st_shndx.
>
> This patch is adding code to detect the optional extended
> section index table and use it to resolve symbol's section
> index id needed.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  btf_encoder.c | 18 ++++++++++++++++++
>  elf_symtab.c  | 31 ++++++++++++++++++++++++++++++-
>  elf_symtab.h  |  1 +
>  3 files changed, 49 insertions(+), 1 deletion(-)
>
> diff --git a/btf_encoder.c b/btf_encoder.c
> index 5557c9efd365..2ab6815dc2b3 100644
> --- a/btf_encoder.c
> +++ b/btf_encoder.c
> @@ -609,6 +609,24 @@ static int collect_symbols(struct btf_elf *btfe, bool collect_percpu_vars)
>
>         /* search within symtab for percpu variables */
>         elf_symtab__for_each_symbol(btfe->symtab, core_id, sym) {

How about we introduce elf_symtab__for_each_symbol variant that uses
gelf_getsymshndx undercover and returns a real section index as the
4th macro argument?

> +               struct elf_symtab *symtab = btfe->symtab;
> +
> +               /*
> +                * Symbol's st_shndx needs to be translated with the
> +                * extended section index table.
> +                */
> +               if (sym.st_shndx == SHN_XINDEX) {
> +                       Elf32_Word xndx;
> +
> +                       if (!symtab->syms_shndx) {
> +                               fprintf(stderr, "SHN_XINDEX found, but no symtab shndx section.\n");
> +                               return -1;
> +                       }
> +
> +                       if (gelf_getsymshndx(symtab->syms, symtab->syms_shndx, core_id, &sym, &xndx))
> +                               sym.st_shndx = xndx;

This bit makes me really nervous and it looks very unclean, which is
why I think providing correct section index as part of iterator macro
is better approach. And all this code would just go away.

> +               }
> +
>                 if (collect_percpu_vars && collect_percpu_var(btfe, &sym))
>                         return -1;
>                 if (collect_function(btfe, &sym))
> diff --git a/elf_symtab.c b/elf_symtab.c
> index 741990ea3ed9..c1def0189652 100644
> --- a/elf_symtab.c
> +++ b/elf_symtab.c
> @@ -17,11 +17,13 @@
>
>  struct elf_symtab *elf_symtab__new(const char *name, Elf *elf, GElf_Ehdr *ehdr)
>  {
> +       size_t index;
> +
>         if (name == NULL)
>                 name = ".symtab";
>
>         GElf_Shdr shdr;
> -       Elf_Scn *sec = elf_section_by_name(elf, ehdr, &shdr, name, NULL);
> +       Elf_Scn *sec = elf_section_by_name(elf, ehdr, &shdr, name, &index);
>
>         if (sec == NULL)
>                 return NULL;
> @@ -29,6 +31,8 @@ struct elf_symtab *elf_symtab__new(const char *name, Elf *elf, GElf_Ehdr *ehdr)
>         if (gelf_getshdr(sec, &shdr) == NULL)
>                 return NULL;
>
> +       int xindex = elf_scnshndx(sec);

move this closer to where you check (xindex > 0)? Can you please leave
a small comment that this returns extended section index table's
section index (I know, this is horrible), if it exists. It's
notoriously hard to find anything about libelf's API, especially for
obscure APIs like this.

> +
>         struct elf_symtab *symtab = malloc(sizeof(*symtab));
>         if (symtab == NULL)
>                 return NULL;
> @@ -49,6 +53,31 @@ struct elf_symtab *elf_symtab__new(const char *name, Elf *elf, GElf_Ehdr *ehdr)
>         if (symtab->symstrs == NULL)
>                 goto out_free_name;
>
> +       /*
> +        * The .symtab section has optional extended section index
> +        * table, load its data so it can be used to resolve symbol's
> +        * section index.
> +        **/
> +       if (xindex > 0) {
> +               GElf_Shdr shdr_shndx;
> +               Elf_Scn *sec_shndx;
> +
> +               sec_shndx = elf_getscn(elf, xindex);
> +               if (sec_shndx == NULL)
> +                       goto out_free_name;
> +
> +               if (gelf_getshdr(sec_shndx, &shdr_shndx) == NULL)
> +                       goto out_free_name;
> +
> +               /* Extra check to verify it belongs to the .symtab */
> +               if (index != shdr_shndx.sh_link)
> +                       goto out_free_name;

you can also verify that section type is SHT_SYMTAB_SHNDX

> +
> +               symtab->syms_shndx = elf_getdata(elf_getscn(elf, xindex), NULL);

my mind breaks looking at all those shndxs, especially in this case
where it's not a section number, but rather data. How about we call it
something like symtab->syms_sec_idx_table or something similar but
human-comprehensible?

> +               if (symtab->syms_shndx == NULL)
> +                       goto out_free_name;
> +       }
> +
>         symtab->nr_syms = shdr.sh_size / shdr.sh_entsize;
>
>         return symtab;
> diff --git a/elf_symtab.h b/elf_symtab.h
> index 359add69c8ab..f9277a48ed4c 100644
> --- a/elf_symtab.h
> +++ b/elf_symtab.h
> @@ -16,6 +16,7 @@ struct elf_symtab {
>         uint32_t  nr_syms;
>         Elf_Data  *syms;
>         Elf_Data  *symstrs;
> +       Elf_Data  *syms_shndx;

please add comment mentioning that it's data of SHT_SYMTAB_SHNDX
section, it will make it a bit easier to Google what that is

>         char      *name;
>  };
>
> --
> 2.27.0
>
