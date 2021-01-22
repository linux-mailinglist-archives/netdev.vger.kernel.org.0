Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E9630106F
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbhAVW5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728476AbhAVW4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 17:56:43 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E92C06174A;
        Fri, 22 Jan 2021 14:56:03 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id k132so7041069ybf.2;
        Fri, 22 Jan 2021 14:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P0ru974B6Q7RoDzmI3kqeFvMXnnLKfdBNCMfCCuAQoc=;
        b=Dy3XH+z66gPAWI5CiE1jF47tii7PIt2u0jWt0l1d1mQMedGBEj7G7JhEvyT3i0O1yO
         oBEgVViqSsj0piUDEGmkTBycvCBXeEmnsimtKVPB8TclbnIFh+aRgVRFSEpSJTtw5+uB
         eesPfdfkMVexptkNMeC+9KY9H2ZWze2h1ZCeYGrgKp58oTD3UfO7Y5pL7Ivgk8PIgJ4T
         5/G51j1WDjAPgp824+W8SRGzX0IgOacQI22ChB9+LweK4YY25n/0RvcZUF0+HBHDgYAy
         JU6q5HEjansFuQ2ojT77//s1+e7Z30S/9hTJbIIEF3H9We2hOCvRv0UvAHbnkJujiQwD
         ge3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P0ru974B6Q7RoDzmI3kqeFvMXnnLKfdBNCMfCCuAQoc=;
        b=KhiZQGm8mawm/H5B5vv7/2UgU3DZagIQhvXnQ0ZC6KyB1l4e0DP0KHZZvdMSEm7Pbw
         nQ8r+e+tJa8vdjlvbjr+NjJZGIFVkW2KdczEUBUCuqCjspZsYO2x5zI9b0e9H4pUx3ZW
         ZB/rtfExGATnKaidHQGHr5vqDD+FpAWFjy/yDqX91OQg/XPc51+/eAijaoYc5P9/sOwG
         GW/9dBRmUjg+pGmRZkG9rDwUlfohysKD3GiArYWz1F1/4Jc7Fpcxc5tQb5fOmJPa8HiQ
         ImS6/UpmHwPcpo0dccaLbpYMkK/Mt4x23H26gava/0nrZ1CaWfGhZXlpKqe2wcvTEtUL
         A6aQ==
X-Gm-Message-State: AOAM533z6YVCYLPpGLaiMblPmIi0Zl/cN273JZiMacqZhGV4d5KGzTIM
        B5DsrRiwTBiKLnS2js7JGXCt89sqg4keizbCMmE=
X-Google-Smtp-Source: ABdhPJyxyI3w5nhampQQpIxt6t3H3fRoaOerAjdnOfYSALoPKMFIljdbUWvNiE7K9t0IRENryz1WOmeg71PwQaQOBzc=
X-Received: by 2002:a25:4b86:: with SMTP id y128mr9448441yba.403.1611356162405;
 Fri, 22 Jan 2021 14:56:02 -0800 (PST)
MIME-Version: 1.0
References: <20210121202203.9346-1-jolsa@kernel.org> <20210121202203.9346-3-jolsa@kernel.org>
 <CAEf4BzZquSn0Th7bpVuM0M4XbTPU5-9jDPPd5RJBS5AH2zqaMA@mail.gmail.com> <20210122204654.GB70760@krava>
In-Reply-To: <20210122204654.GB70760@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 Jan 2021 14:55:51 -0800
Message-ID: <CAEf4BzaRrMp1+2dgv_1WrkBt+=KF1BJnN_KGwZKx5gDg7t++Yg@mail.gmail.com>
Subject: Re: [PATCH 2/3] bpf_encoder: Translate SHN_XINDEX in symbol's
 st_shndx values
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
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

On Fri, Jan 22, 2021 at 12:47 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Jan 21, 2021 at 03:32:40PM -0800, Andrii Nakryiko wrote:
>
> SNIP
>
> > > @@ -598,9 +599,36 @@ static void collect_symbol(GElf_Sym *sym, struct funcs_layout *fl)
> > >                 fl->mcount_stop = sym->st_value;
> > >  }
> > >
> > > +static bool elf_sym__get(Elf_Data *syms, Elf_Data *syms_sec_idx_table,
> > > +                        int id, GElf_Sym *sym, Elf32_Word *sym_sec_idx)
> > > +{
> > > +       if (!gelf_getsym(syms, id, sym))
> > > +               return false;
> > > +
> > > +       *sym_sec_idx = sym->st_shndx;
> > > +
> > > +       if (sym->st_shndx == SHN_XINDEX) {
> > > +               if (!syms_sec_idx_table)
> > > +                       return false;
> > > +               if (!gelf_getsymshndx(syms, syms_sec_idx_table,
> > > +                                     id, sym, sym_sec_idx))
> >
> >
> > gelf_getsymshndx() is supposed to work even for cases that don't use
> > extended numbering, so this should work, right?
> >
> > if (!gelf_getsymshndx(syms, syms_sec_idx_table, id, sym, sym_sec_idx))
> >     return false;
> >
>
> it seems you're right, gelf_getsymshndx seem to work for
> both cases, I'll check
>
>
> > if (sym->st_shndx == SHN_XINDEX)
> >   *sym_sec_idx = sym->st_shndx;
>
> I don't understand this..  gelf_getsymshndx will return both
> symbol and proper index, no? also sym_sec_idx is already
> assigned from previou call

Reading (some) implementation of gelf_getsymshndx() that I found
online, it won't set sym_sec_idx, if the symbol *doesn't* use extended
numbering. But it will still return symbol data. So to return the
section index in all cases, we need to check again *after* we got
symbol, and if it's not extended, then set index manually.

>
> >
> > return true;
> >
> > ?
> >
> > > +                       return false;
> > > +       }
> > > +
> > > +       return true;
> > > +}
> > > +
> > > +#define elf_symtab__for_each_symbol_index(symtab, id, sym, sym_sec_idx)                \
> > > +       for (id = 0, elf_sym__get(symtab->syms, symtab->syms_sec_idx_table,     \
> > > +                                 id, &sym, &sym_sec_idx);                      \
> > > +            id < symtab->nr_syms;                                              \
> > > +            id++, elf_sym__get(symtab->syms, symtab->syms_sec_idx_table,       \
> > > +                               id, &sym, &sym_sec_idx))
> >
> > what do we want to do if elf_sym__get() returns error (false)? We can
> > either stop or ignore that symbol, right? But currently you are
> > returning invalid symbol data.
> >
> > so either
> >
> > for (id = 0; id < symtab->nr_syms && elf_sym__get(symtab->syms,
> > symtab->syms_sec_idx_table, d, &sym, &sym_sec_idx); id++)
> >
> > or
> >
> > for (id = 0; id < symtab->nr_syms; id++)
> >   if (elf_sym__get(symtab->syms, symtab->syms_sec_idx_table, d, &sym,
> > &sym_sec_idx))
>
> if we go ahead with skipping symbols, this one seems good

I think skipping symbols is nicer. If ELF is totally broken, then all
symbols are going to be ignored anyway. If it's some one-off issue for
a specific symbol, we'll just ignore it (unfortunately, silently).

>
> >
> >
> > But the current variant looks broken. Oh, and
> > elf_symtab__for_each_symbol() is similarly broken, can you please fix
> > that as well?
> >
> > And this new macro should probably be in elf_symtab.h, along the
> > elf_symtab__for_each_symbol.
>
> thanks,
> jirka
>
