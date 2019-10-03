Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 346BCCB0D7
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbfJCVKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:10:15 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41250 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfJCVKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:10:15 -0400
Received: by mail-qk1-f193.google.com with SMTP id p10so3837209qkg.8;
        Thu, 03 Oct 2019 14:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2tjulN517pEVQ3k4gO1et/ao7+Rl99KeHDcwuCD25KQ=;
        b=ABHQosbD4eilfxpIENJT8rYDamWkeQ6IIpkQryBCyU7fSYP20juaivLe354fOLsGTp
         i25PhSPQBfED6bXSoJ7xJbAyVDpWstGq0YoAe9uc63fsmJsHxYDa8zTrySktOohRXXfH
         wvpJ/myiucQls3AYHHm5JY2Ouv0fiWnv63dxM7IwSYG+AJ9bUj2+QsVt3K7Ex68DZ3YR
         rKe4yVU1mxmSHQhSrPaxKiI0r+f8rVTJqLZaC0mwfcnqcFNIDgmUcDB54EwI67KVQkda
         gGcQjuHptsO904VJg3oz1fZBkdbUkV+rJzy3Sim9QP0dgj3UN7vLKWQr/m8W5OMJWm98
         jvsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2tjulN517pEVQ3k4gO1et/ao7+Rl99KeHDcwuCD25KQ=;
        b=C6NVEmrWIILKo6pSMipp6O3huJvriWUPmKWml78npMm/RHYDINVgAm54NxIaxJbZBo
         C/O32HCp7xuJpWGYweXBaciY5oTc2zj+CtHyGKudG7dJg7T0F9dsg+WHk2ashr+qg0wC
         hFwi9tEFt+8JEFTyTqz69iqH0wl2fllPdMxDiwEWaEO7yxfBR0aJUWNZFoRiUjOrZbIy
         jJVoCaBaQIX54PbYCA6VahGuf4BgM4TybzXTZEuZ30EN++zm8g/jWrDvneC+ZSUeR3ka
         4NnYO6o6fRju5rUtyE3+5QAj29FuOanTphlQ1rRFFKcC8j1Uyc8LlLryOdCPvcsuHdGr
         m+pQ==
X-Gm-Message-State: APjAAAW7d/qT7eUnHi8hgdisUnh6QCVaNMjt1dwdsCgnq1/H2+zRDGnx
        u8ZimqGu1uq4cZngVaMlFJwXVbGoKwWLlhSOTSc=
X-Google-Smtp-Source: APXvYqyv11QK01UWJ4YpFyAyUlmZzOqKWF7PyC/vBMZhLWYu3bSbH2PatDVxWk7+rNX5aPlW4wP8GNiQffnk1MvAKYQ=
X-Received: by 2002:a37:4e55:: with SMTP id c82mr6688317qkb.437.1570137013428;
 Thu, 03 Oct 2019 14:10:13 -0700 (PDT)
MIME-Version: 1.0
References: <20191002215041.1083058-1-andriin@fb.com> <20191002215041.1083058-4-andriin@fb.com>
 <CAPhsuW7CHQAq-N9-OE=jRqgYhq71ZhzEYexNcHCP=docrhNptg@mail.gmail.com>
 <CAEf4BzbhDw0GZ0eY2ctH+--LCk99oCTLGJ=2zaG-_vcyqvYLTw@mail.gmail.com> <CAPhsuW70RCb5hMGvFN99R+HxkQMMzu-ZbyRwwGL17SgGyp8t9g@mail.gmail.com>
In-Reply-To: <CAPhsuW70RCb5hMGvFN99R+HxkQMMzu-ZbyRwwGL17SgGyp8t9g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Oct 2019 14:10:02 -0700
Message-ID: <CAEf4BzZhaK2G8hPNGAgt7nKAczN2sro=dsa9W-HiXm4n0gZFbA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/7] selftests/bpf: adjust CO-RE reloc tests
 for new bpf_core_read() macro
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 1:42 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Thu, Oct 3, 2019 at 1:29 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Oct 3, 2019 at 1:17 PM Song Liu <liu.song.a23@gmail.com> wrote:
> > >
> > > On Wed, Oct 2, 2019 at 3:01 PM Andrii Nakryiko <andriin@fb.com> wrote:
> > > >
> > > > To allow adding a variadic BPF_CORE_READ macro with slightly different
> > > > syntax and semantics, define CORE_READ in CO-RE reloc tests, which is
> > > > a thin wrapper around low-level bpf_core_read() macro, which in turn is
> > > > just a wrapper around bpf_probe_read().
> > > >
> > > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > > Acked-by: Song Liu <songliubraving@fb.com>
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> > > >  tools/testing/selftests/bpf/bpf_helpers.h      |  8 ++++----
> > > >  .../bpf/progs/test_core_reloc_arrays.c         | 10 ++++++----
> > > >  .../bpf/progs/test_core_reloc_flavors.c        |  8 +++++---
> > > >  .../selftests/bpf/progs/test_core_reloc_ints.c | 18 ++++++++++--------
> > > >  .../bpf/progs/test_core_reloc_kernel.c         |  6 ++++--
> > > >  .../selftests/bpf/progs/test_core_reloc_misc.c |  8 +++++---
> > > >  .../selftests/bpf/progs/test_core_reloc_mods.c | 18 ++++++++++--------
> > > >  .../bpf/progs/test_core_reloc_nesting.c        |  6 ++++--
> > > >  .../bpf/progs/test_core_reloc_primitives.c     | 12 +++++++-----
> > > >  .../bpf/progs/test_core_reloc_ptr_as_arr.c     |  4 +++-
> > > >  10 files changed, 58 insertions(+), 40 deletions(-)
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> > > > index 7b75c38238e4..5210cc7d7c5c 100644
> > > > --- a/tools/testing/selftests/bpf/bpf_helpers.h
> > > > +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> > > > @@ -483,7 +483,7 @@ struct pt_regs;
> > > >  #endif
> > > >
> > > >  /*
> > > > - * BPF_CORE_READ abstracts away bpf_probe_read() call and captures offset
> > > > + * bpf_core_read() abstracts away bpf_probe_read() call and captures offset
> > > >   * relocation for source address using __builtin_preserve_access_index()
> > > >   * built-in, provided by Clang.
> > > >   *
> > > > @@ -498,8 +498,8 @@ struct pt_regs;
> > > >   * actual field offset, based on target kernel BTF type that matches original
> > > >   * (local) BTF, used to record relocation.
> > > >   */
> > > > -#define BPF_CORE_READ(dst, src)                                                \
> > > > -       bpf_probe_read((dst), sizeof(*(src)),                           \
> > > > -                      __builtin_preserve_access_index(src))
> > > > +#define bpf_core_read(dst, sz, src)                                        \
> > > > +       bpf_probe_read(dst, sz,                                             \
> > > > +                      (const void *)__builtin_preserve_access_index(src))
> > > >
> > > >  #endif
> > > > diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
> > > > index bf67f0fdf743..58efe4944594 100644
> > > > --- a/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
> > > > +++ b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
> > > > @@ -31,6 +31,8 @@ struct core_reloc_arrays {
> > > >         struct core_reloc_arrays_substruct d[1][2];
> > > >  };
> > > >
> > > > +#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
> > >
> > > We are using sizeof(*dst) now, but I guess sizeof(*src) is better?
> > > And it should be sizeof(*(src)).
> >
> > There is no clear winner and I've debated which one I should go with,
> > but I'm leaning towards using destination for the following reason.
> > Size of destination doesn't change, it's not relocatable and whatnot,
> > so this represents actual amount of storage we can safely read into
> > (if the program logic is correct, of course). On the other hand, size
> > of source might be different between kernels and we don't support
> > relocating it when it's passed into bpf_probe_read() as second arg.
> >
> > There is at least one valid case where we should use destination size,
> > not source size: if we have an array of something (e.g, chars) and we
> > want to read only up to first N elements. In this case sizeof(*dst) is
> > what you really want: program will pre-allocate exact amount of data
> > and we'll do, say, char comm[16]; bpf_core_read(dst,
> > task_struct->comm). If task_struct->comm ever increases, this all will
> > work: we'll read first 16 characters only.
> >
> > In almost every other case it doesn't matter whether its dst or src,
> > they have to match (i.e., we don't support relocation from int32 to
> > int64 right now).
>
> Hmm.. We could also reading multiple items into the same array, no?

Yeah, absolutely, there are cases in which BPF_CORE_READ won't work,
unfortunately. That's why it was an internal debate, because there is
no perfect answer :)

> Maybe we need another marco that takes size as an third parameter?

So my thinking for cases that are not compatible with BPF_CORE_READ
intended use cases was that users will just do bpf_core_read(), which
accepts same params as bpf_probe_read(), so they can do whatever they
need to do.


>
> Also, for dst, it needs to be sizeof(*(dst)).

You mean extra () around dst? Sure, will add.

>
> Thanks,
> Song
