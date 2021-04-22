Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AEA368664
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbhDVSLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236659AbhDVSLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 14:11:24 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3C2C06174A;
        Thu, 22 Apr 2021 11:10:47 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 130so8754930ybd.10;
        Thu, 22 Apr 2021 11:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PPYJpKOar/qFpGg/gU+1Gq10BuC71OZBVRDZh2PCs2w=;
        b=uNqdWu7+GScFbyxDvvcdZViXc9vq0dCZFTJH7QM7T4aunuBcKiBGLzKV9raBTxd105
         KU8RD9MBYww3khTOFEZyeAve65iCJ7G1hnC9/1jntvCpyW/hUSGL06EMmF0wj1fwd7RL
         NP9hihAEDcTRn7oJrLO+PYwSn5vQhs06wlY3xzyY1d60++oy2EAyCcdz70QOAo/x+KQr
         MIocG2JkEZBqqllN21FsktbLpS/VFB48/1fPULGW7mVunVopAG5R14zmKSxs6eLsB41I
         TC9DRriJmEp1HcwYn7kQjbQq+3U8XhBO+N7/3HVeFTK3Ib2QTG2o6S5knPKkI2nmKL5q
         DtDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PPYJpKOar/qFpGg/gU+1Gq10BuC71OZBVRDZh2PCs2w=;
        b=fR4n9ZYg/UYmv+JzdYrt0Ec0ttFMFsrY7gLdRXv4IFTnU/e3IeC0TX21Xg5bT31y2U
         cPorpSuYqFnD21QZSEodwijByMhJFeNC7RFYe/gIMcS/hSi0mTExWTcaXJYlkSTR0hlo
         EaPlU4C2THfxMabCiIj6AkJpXH12knbS9Sz8Qt2fAcjwrzpo33VjsYvG2h4waY03xy5d
         lkZL3kmIsogMybckvj9LJyAgPh34DZxxOwzCpwBcR1H+/VLHf3+qmA/DcWaoGvFDGi/3
         f5hIHGAq0BbX6Di7J797Hb3BihrvnCxs4IycA4/L7zdZKo+WVlJcd+LPI+BaUtt0ACUt
         em2w==
X-Gm-Message-State: AOAM532YgxDdaTKttaAkWpk1BkZLni0m5/KpIsycuVk9NlsjltBeipWq
        0nEW3PZG7n0K9AfwMY6ELSxK9AU5zDQFYgCz+84=
X-Google-Smtp-Source: ABdhPJwEEylLI7WkZTEHesGEkeGs8jIP9WF+IXWWr26jOPptKy2UTgFrIK0lWWzQ4Bel+MjOiX2/vUlTBhMxwzJdkGc=
X-Received: by 2002:a25:dc46:: with SMTP id y67mr6766176ybe.27.1619115046357;
 Thu, 22 Apr 2021 11:10:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-6-andrii@kernel.org>
 <71bfd67c-c8f0-595c-e721-201ec4e8e062@fb.com>
In-Reply-To: <71bfd67c-c8f0-595c-e721-201ec4e8e062@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Apr 2021 11:10:35 -0700
Message-ID: <CAEf4BzZ4kSXjv762oLW4ihGD235Xi4kHAPgZU5fHC3q+7_HKzA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 05/17] libbpf: allow gaps in BPF program
 sections to support overriden weak functions
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> > Currently libbpf is very strict about parsing BPF program isnstruction
>
> isnstruction => instruction

will fix

>
> > sections. No gaps are allowed between sequential BPF programs within a given
> > ELF section. Libbpf enforced that by keeping track of the next section offset
> > that should start a new BPF (sub)program and cross-checks that by searching for
> > a corresponding STT_FUNC ELF symbol.
> >
> > But this is too restrictive once we allow to have weak BPF programs and link
> > together two or more BPF object files. In such case, some weak BPF programs
> > might be "overriden" by either non-weak BPF program with the same name and
>
> overriden => overridden

will fix

>
> > signature, or even by another weak BPF program that just happened to be linked
> > first. That, in turn, leaves BPF instructions of the "lost" BPF (sub)program
> > intact, but there is no corresponding ELF symbol, because no one is going to
> > be referencing it.
> >
> > Libbpf already correctly handles such cases in the sense that it won't append
> > such dead code to actual BPF programs loaded into kernel. So the only change
> > that needs to be done is to relax the logic of parsing BPF instruction
> > sections. Instead of assuming next BPF (sub)program section offset, iterate
> > available STT_FUNC ELF symbols to discover all available BPF subprograms and
> > programs.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Ack with a minor suggestion below.
> Acked-by: Yonghong Song <yhs@fb.com>
>
> > ---
> >   tools/lib/bpf/libbpf.c | 56 ++++++++++++++++--------------------------
> >   1 file changed, 21 insertions(+), 35 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index ce5558d0a61b..a0e6d6bc47f3 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -502,8 +502,6 @@ static Elf_Scn *elf_sec_by_name(const struct bpf_object *obj, const char *name);
> >   static int elf_sec_hdr(const struct bpf_object *obj, Elf_Scn *scn, GElf_Shdr *hdr);
> >   static const char *elf_sec_name(const struct bpf_object *obj, Elf_Scn *scn);
> >   static Elf_Data *elf_sec_data(const struct bpf_object *obj, Elf_Scn *scn);
> > -static int elf_sym_by_sec_off(const struct bpf_object *obj, size_t sec_idx,
> > -                           size_t off, __u32 sym_type, GElf_Sym *sym);
> >
> >   void bpf_program__unload(struct bpf_program *prog)
> >   {
> > @@ -644,10 +642,12 @@ static int
> >   bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
> >                        const char *sec_name, int sec_idx)
> >   {
> > +     Elf_Data *symbols = obj->efile.symbols;
> >       struct bpf_program *prog, *progs;
> >       void *data = sec_data->d_buf;
> >       size_t sec_sz = sec_data->d_size, sec_off, prog_sz;
> > -     int nr_progs, err;
> > +     size_t n = symbols->d_size / sizeof(GElf_Sym);
>
> Maybe use "nr_syms" instead of "n" to be more descriptive?
>

sure

> > +     int nr_progs, err, i;
> >       const char *name;
> >       GElf_Sym sym;
> >
> > @@ -655,14 +655,16 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
> >       nr_progs = obj->nr_programs;
> >       sec_off = 0;
> >
> > -     while (sec_off < sec_sz) {
> > -             if (elf_sym_by_sec_off(obj, sec_idx, sec_off, STT_FUNC, &sym)) {
> > -                     pr_warn("sec '%s': failed to find program symbol at offset %zu\n",
> > -                             sec_name, sec_off);
> > -                     return -LIBBPF_ERRNO__FORMAT;
> > -             }
> > +     for (i = 0; i < n; i++) {
> > +             if (!gelf_getsym(symbols, i, &sym))
> > +                     continue;
> > +             if (sym.st_shndx != sec_idx)
> > +                     continue;
> > +             if (GELF_ST_TYPE(sym.st_info) != STT_FUNC)
> > +                     continue;
> >
> >               prog_sz = sym.st_size;
> > +             sec_off = sym.st_value;
> >
> >               name = elf_sym_str(obj, sym.st_name);
> >               if (!name) {
> > @@ -711,8 +713,6 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
> >
> >               nr_progs++;
> >               obj->nr_programs = nr_progs;
> > -
> > -             sec_off += prog_sz;
> >       }
> >
> >       return 0;
> > @@ -2825,26 +2825,6 @@ static Elf_Data *elf_sec_data(const struct bpf_object *obj, Elf_Scn *scn)
> >       return data;
> >   }
> >
> [...]
