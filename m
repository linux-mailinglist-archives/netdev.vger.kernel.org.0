Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2895301836
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbhAWUIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbhAWUIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:08:01 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19E7C06178B;
        Sat, 23 Jan 2021 12:07:20 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id x6so9155310ybr.1;
        Sat, 23 Jan 2021 12:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FoRhbF3AY2tf8R9X0t7lFdWrbbFsIlLRq8prCz6/ZtQ=;
        b=UGMbQh0ebVaoX1/WBev/efsQFH38p7S/M8EAlOCFn3mpVJ0XqFD5+cAMs1PJKwhEAN
         l6EjOhxgrrSLwmkBPyb0FRqc1yP1QkYoF8HxuoagciBBfKReN5kd/thrfeA7O9qN2NHt
         dz0SSpTLAT6/7lJifgtGxf+xoMOUMEOOvYJyPI05cLZJ8FGZF8lJltmc/2eg7tcpNmld
         37oZQnVLyrlfbiqgltxrTdFxrsjUQUZ5wCMey9HmS3EOpCrdpxNVvCzM5L9L3Njk8ar3
         Cl8px632/Z3WS0ZNjKyXCLFJbOEfhNqTjOzkVdzkLzqeOhpN4Jjby+4mBGNFzPSt+TvB
         MLHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FoRhbF3AY2tf8R9X0t7lFdWrbbFsIlLRq8prCz6/ZtQ=;
        b=JvanCT2byNbDueP1yETGtmkYi5vwvnOw+/JkhinNruGSmgLh10T7AmI3Uus9zVzjlE
         io6fkVmlkR9JYl5BIbWtuPY0iOvHTtDRpmVWa6R2mUXT5yQhwl33gNL8f3eTVvuhZz0j
         NBFww7b10CPVpEn03OHXQ5SR505mGYNaIDlaflQYZ5OxNsk6Q01jK+E18SXU4+s1NXNw
         BN64hcp7JMlTeyRuytkgB+qBBuLrHU2kFZIAPO3Zswr93Ox+6nOJmqFwrWx6rbiOnDjy
         66WGtvW9XMa0L8/kY/2d7zjK+4/MLv2C5ff2nuih0vUOhBZ8FZLdNdN3kj06qFX0UEZN
         3OMw==
X-Gm-Message-State: AOAM5321UgUe5R5NlrJo1O1dMW+neDgI6beMItdTixRPU6J0IRlg5FOB
        PCQHJv0ndeP5Gj+bGtUWrYbyt254yPAB/pfY/Nw=
X-Google-Smtp-Source: ABdhPJy7PfTdqk28+IF5xQeuOhmTQ56zJXSjfuDKgjqhzWZ3NDYfzxqiz2loSL3eLkbjVZSJk8GA1grUi6wcH2CwzU8=
X-Received: by 2002:a25:b195:: with SMTP id h21mr14997797ybj.347.1611432439892;
 Sat, 23 Jan 2021 12:07:19 -0800 (PST)
MIME-Version: 1.0
References: <20210121202203.9346-1-jolsa@kernel.org> <20210121202203.9346-3-jolsa@kernel.org>
 <CAEf4BzZquSn0Th7bpVuM0M4XbTPU5-9jDPPd5RJBS5AH2zqaMA@mail.gmail.com>
 <20210122204654.GB70760@krava> <CAEf4BzaRrMp1+2dgv_1WrkBt+=KF1BJnN_KGwZKx5gDg7t++Yg@mail.gmail.com>
 <20210123185143.GA117714@krava>
In-Reply-To: <20210123185143.GA117714@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 23 Jan 2021 12:07:08 -0800
Message-ID: <CAEf4BzaviAOnNc31vUjWcCK7JvEwc8_nPQTiEpxMFcoTcvNw8w@mail.gmail.com>
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

On Sat, Jan 23, 2021 at 10:51 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Fri, Jan 22, 2021 at 02:55:51PM -0800, Andrii Nakryiko wrote:
> > On Fri, Jan 22, 2021 at 12:47 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Thu, Jan 21, 2021 at 03:32:40PM -0800, Andrii Nakryiko wrote:
> > >
> > > SNIP
> > >
> > > > > @@ -598,9 +599,36 @@ static void collect_symbol(GElf_Sym *sym, struct funcs_layout *fl)
> > > > >                 fl->mcount_stop = sym->st_value;
> > > > >  }
> > > > >
> > > > > +static bool elf_sym__get(Elf_Data *syms, Elf_Data *syms_sec_idx_table,
> > > > > +                        int id, GElf_Sym *sym, Elf32_Word *sym_sec_idx)
> > > > > +{
> > > > > +       if (!gelf_getsym(syms, id, sym))
> > > > > +               return false;
> > > > > +
> > > > > +       *sym_sec_idx = sym->st_shndx;
> > > > > +
> > > > > +       if (sym->st_shndx == SHN_XINDEX) {
> > > > > +               if (!syms_sec_idx_table)
> > > > > +                       return false;
> > > > > +               if (!gelf_getsymshndx(syms, syms_sec_idx_table,
> > > > > +                                     id, sym, sym_sec_idx))
> > > >
> > > >
> > > > gelf_getsymshndx() is supposed to work even for cases that don't use
> > > > extended numbering, so this should work, right?
> > > >
> > > > if (!gelf_getsymshndx(syms, syms_sec_idx_table, id, sym, sym_sec_idx))
> > > >     return false;
> > > >
> > >
> > > it seems you're right, gelf_getsymshndx seem to work for
> > > both cases, I'll check
> > >
> > >
> > > > if (sym->st_shndx == SHN_XINDEX)
> > > >   *sym_sec_idx = sym->st_shndx;
> > >
> > > I don't understand this..  gelf_getsymshndx will return both
> > > symbol and proper index, no? also sym_sec_idx is already
> > > assigned from previou call
> >
> > Reading (some) implementation of gelf_getsymshndx() that I found
> > online, it won't set sym_sec_idx, if the symbol *doesn't* use extended
> > numbering. But it will still return symbol data. So to return the
>
> the latest upstream code seems to set it always,
> but I agree we should be careful

oh, then maybe it's not necessary. I honestly don't even know where
the authoritative source code of libelf is, so I just found some
random source code with Google.

>
> Mark, any insight in here? thanks
>
> > section index in all cases, we need to check again *after* we got
> > symbol, and if it's not extended, then set index manually.
>
> hum, then we should use '!=', right?
>
>   if (sym->st_shndx != SHN_XINDEX)
>     *sym_sec_idx = sym->st_shndx;


yeah, sorry, that was a typo

>
> SNIP
>
> > > > so either
> > > >
> > > > for (id = 0; id < symtab->nr_syms && elf_sym__get(symtab->syms,
> > > > symtab->syms_sec_idx_table, d, &sym, &sym_sec_idx); id++)
> > > >
> > > > or
> > > >
> > > > for (id = 0; id < symtab->nr_syms; id++)
> > > >   if (elf_sym__get(symtab->syms, symtab->syms_sec_idx_table, d, &sym,
> > > > &sym_sec_idx))
> > >
> > > if we go ahead with skipping symbols, this one seems good
> >
> > I think skipping symbols is nicer. If ELF is totally broken, then all
> > symbols are going to be ignored anyway. If it's some one-off issue for
> > a specific symbol, we'll just ignore it (unfortunately, silently).
>
> agreed, I'll use this

sounds good

>
> thanks,
> jirka
>
