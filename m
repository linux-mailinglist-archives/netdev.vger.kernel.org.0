Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5876EAA2
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 20:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbfGSS1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 14:27:03 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46081 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbfGSS1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 14:27:03 -0400
Received: by mail-qk1-f194.google.com with SMTP id r4so23858368qkm.13;
        Fri, 19 Jul 2019 11:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p9u+/lSmVLhPGZFtHnmVylFIIt3k8vIZOGVf8nKV1I0=;
        b=oTNOveAR2yX0P9+ASdk6jI07AfwxhZbg0FMc8zeIlrveGnRWKLjZ9xtt64uwYLxLKR
         l7UCzfE7GsiKTcfF8FCTBPzHkfOByh/qP+qsBzYZUyPPa4EblW15JgKUsjTL8xG7as/h
         uN3rB5XwojHGJKeoM7t23Wfdzc4uh8FUikLDyUyUMr+zhkx2uEUBjArCjKbpn7dux+MJ
         nW7D3tRYA/G8l7cUg5N7wqa+YhCi19zmYBwfn5CCJMtKIprNlQTCOqRhK6b51ON5825E
         wQgDC8ASox6/kBZbuMJY8Pujl3nV1oBMTo6RZ5WK0SK0/7t6Dt4z+S1c4Yme+rCXXyT+
         3TAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p9u+/lSmVLhPGZFtHnmVylFIIt3k8vIZOGVf8nKV1I0=;
        b=I6t39zX25Hlq7+YzKOpjsTiaMu0DgUbIvQwfIebdwXaVO+Y+6i2uYMSSZUkfT2R1Fe
         IKZv2ncdW+QuswJDRmWKzHOi8lTnLtNxwZ8cERJiDroIE8VMbCo5aJpxWqlTOl5SPvjr
         zstGmggcKfMOiI7SOQqSucZoKLi/LAlLNQ4HUIjiHWYWLWmqLHyT1HQSTVXeP1EplvyK
         nMvJaYDDuLVn704ej+5DQUMZKHHZkNiaSYXg1z6/RJGcoZ8OMtPOS8W3IkwAdgdg0U+R
         dRdmY0V8E1BugX9s80YZlaD6JLIrWKw6I4QOSzAOtmDooM5D+0NQFAgqcwBJ7ieNJifZ
         zJRg==
X-Gm-Message-State: APjAAAUIvPQNTr16jwR9OCmR2b7KCjmkqH09cDGSp1ibUUrw4E39IfJr
        bdCSz8efnm9Nx9moKRNQEc/mhArPuhBO1gbPTic=
X-Google-Smtp-Source: APXvYqwdYC0TRSOXogsk8/MS+MMjzEgMVLZHvCt9vpij8JRaWALALDG00PZg9/FDLGDvYmkv6aPVQKk84FoKRN6c5/o=
X-Received: by 2002:a37:660d:: with SMTP id a13mr8267169qkc.36.1563560821887;
 Fri, 19 Jul 2019 11:27:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190718172513.2394157-1-andriin@fb.com> <20190718175533.GG2093@redhat.com>
 <CAEf4BzaPySx-hBwD5Lxo1tD7F_8ejA9qFjC0-ag56cakweqcbA@mail.gmail.com>
 <20190718185619.GL3624@kernel.org> <20190718191452.GM3624@kernel.org>
 <CAEf4BzburdiRTYSJUSpSFAxKmf6ELpvEeNW502eKskzyyMaUxQ@mail.gmail.com>
 <20190719011644.GN3624@kernel.org> <CAEf4BzaKDTnqe4QYebNSoCLfhcUJbhzgXC5sG+y+c4JLc9PFqg@mail.gmail.com>
 <20190719181423.GO3624@kernel.org>
In-Reply-To: <20190719181423.GO3624@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Jul 2019 11:26:50 -0700
Message-ID: <CAEf4BzZtYnVG3tnn25-TTJLOmeevv9fSZnAf7S2pG3VA+dMM+Q@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix missing __WORDSIZE definition
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 19, 2019 at 11:14 AM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Fri, Jul 19, 2019 at 10:54:44AM -0700, Andrii Nakryiko escreveu:
> > On Thu, Jul 18, 2019 at 6:16 PM Arnaldo Carvalho de Melo
> > <arnaldo.melo@gmail.com> wrote:
> > >
> > > Em Thu, Jul 18, 2019 at 02:16:29PM -0700, Andrii Nakryiko escreveu:
> > > > On Thu, Jul 18, 2019 at 12:14 PM Arnaldo Carvalho de Melo
> > > > <arnaldo.melo@gmail.com> wrote:
> > > > >
> > > > > Em Thu, Jul 18, 2019 at 03:56:19PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > > > > I'll stop and replace my patch with yours to see if it survives all the
> > > > > > test builds...
> > > > >
> > > > > So, Alpine:3.4, the first image for this distro I did when I started
> > > > > these builds, survives the 6 builds with gcc and clang with your patch:
> > > > >
> > > > >

[...]

> >
> > Ok, did some more googling. This warning (turned error in your setup)
> > is emitted when -Wshadow option is enabled for GCC/clang. It appears
> > to be disabled by default, so it must be enabled somewhere for perf
> > build or something.
>
> Right, I came to the exact same conclusion, doing tests here:
>
> [perfbuilder@3a58896a648d tmp]$ gcc -Wshadow shadow_global_decl.c   -o shadow_global_decl
> shadow_global_decl.c: In function 'main':
> shadow_global_decl.c:9: warning: declaration of 'link' shadows a global declaration
> shadow_global_decl.c:4: warning: shadowed declaration is here
> [perfbuilder@3a58896a648d tmp]$ gcc --version |& head -1
> gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-23)
> [perfbuilder@3a58896a648d tmp]$ gcc shadow_global_decl.c   -o shadow_global_decl
> [perfbuilder@3a58896a648d tmp]$
>
> So I'm going to remove this warning from the places where it causes
> problems.
>
> > Would it be possible to disable it at least for libbpf when building
> > from perf either everywhere or for those systems where you see this
> > warning? I don't think this warning is useful, to be honest, just
> > random name conflict between any local and global variables will cause
> > this.
>
> Yeah, I might end up having this applied.

Thanks!

>
> [acme@quaco perf]$ git diff
> diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
> index 495066bafbe3..b6e902a2312f 100644
> --- a/tools/scripts/Makefile.include
> +++ b/tools/scripts/Makefile.include
> @@ -32,7 +32,6 @@ EXTRA_WARNINGS += -Wno-system-headers
>  EXTRA_WARNINGS += -Wold-style-definition
>  EXTRA_WARNINGS += -Wpacked
>  EXTRA_WARNINGS += -Wredundant-decls
> -EXTRA_WARNINGS += -Wshadow
>  EXTRA_WARNINGS += -Wstrict-prototypes
>  EXTRA_WARNINGS += -Wswitch-default
>  EXTRA_WARNINGS += -Wswitch-enum
> [acme@quaco perf]$
>
>
> Sorry for the noise...

No worries, I learned something new today :)

>
> - Arnaldo
