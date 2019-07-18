Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0722D6D651
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 23:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfGRVQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 17:16:42 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43087 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbfGRVQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 17:16:41 -0400
Received: by mail-qk1-f196.google.com with SMTP id m14so21606098qka.10;
        Thu, 18 Jul 2019 14:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iba2KQpPE7SITH+9AYOcxKiP/U5m4j3sBxoYky/TYmg=;
        b=qLbazF8th1IsIqhC+uzx9jzOqpeSSod5P1cNwL1ptr+GIek7KAEkf33eeygN/hibmN
         tvl4OXFX+vmkdDlNl3nv0hpHP3VEqSuSVhZqMMLjT1mBA/cl9i0eULWccYDE3v1pN66M
         Bmp3AteVjjUW2UupwF7mhE9QvMTphDHHxrrLTSaLhgmnKNus81EvtH4eFYh1c4YQxO51
         y7vlu+hiyySb5IJdjMNNmWIjrBnWVuIMptjGGDzCr8bvWe8yFlBQo93xWgc5KFRkA6S3
         e/yflnwEgSKfiCEhjjV/wN21a2U80NIpK5MmAOjpHZZwFLrJ1XqGcc1Rd+uUXJmU+9mP
         U1LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iba2KQpPE7SITH+9AYOcxKiP/U5m4j3sBxoYky/TYmg=;
        b=qfZfj4l2HLNv4q52wbpioeYWDgV9KLFm6TJc037ZJP/kzQqZYYVRbKj1gCzxOZBCnQ
         QCJQU9Lz6SyTwL2W2cobl84qtq0CIykXqaaAOHbQ2ZGMcJNsXfq2m/U7+9qvyRe/vFsX
         1IdyFbbdjfgRew9gN/JskCPVN7HTinIcZnp5mpK+t4mR8/WMEZ+Qi0eG3f82WtP+rdAh
         WwBtPdWjKh26GLPkGMYnx8aDvxQsF11bzJTUl+z6qqDzdEGgP1LhtX5a3wzpmzLunHE6
         mwPY1N09Wfql5zjCPz8wH0FNvzVSH1GbHCrvd1zZPhY/eDIz8dbH4DV1lwYTaSY/e0qB
         ltJQ==
X-Gm-Message-State: APjAAAVbVL7WRVPt/eN3njVuPRma0fwKiFuxS/J8y5qt4NBtLJDgbYK5
        FUkeMgc5PB4yq8kZ6s8skFbwVZXx2EXVfR85rME=
X-Google-Smtp-Source: APXvYqyheSJF9udl7pCCdypbxQpk3vcjRFttMxyLMGS3Nbok9flPKKoO9v6CdV5sm9hxZOFxZncryaZzvmQJP7UD5cA=
X-Received: by 2002:a37:bf42:: with SMTP id p63mr33133525qkf.437.1563484600543;
 Thu, 18 Jul 2019 14:16:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190718172513.2394157-1-andriin@fb.com> <20190718175533.GG2093@redhat.com>
 <CAEf4BzaPySx-hBwD5Lxo1tD7F_8ejA9qFjC0-ag56cakweqcbA@mail.gmail.com>
 <20190718185619.GL3624@kernel.org> <20190718191452.GM3624@kernel.org>
In-Reply-To: <20190718191452.GM3624@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jul 2019 14:16:29 -0700
Message-ID: <CAEf4BzburdiRTYSJUSpSFAxKmf6ELpvEeNW502eKskzyyMaUxQ@mail.gmail.com>
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

On Thu, Jul 18, 2019 at 12:14 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Thu, Jul 18, 2019 at 03:56:19PM -0300, Arnaldo Carvalho de Melo escreveu:
> > I'll stop and replace my patch with yours to see if it survives all the
> > test builds...
>
> So, Alpine:3.4, the first image for this distro I did when I started
> these builds, survives the 6 builds with gcc and clang with your patch:
>
>
> [perfbuilder@quaco linux-perf-tools-build]$ export PERF_TARBALL=http://192.168.124.1/perf/perf-5.2.0.tar.xz
> [perfbuilder@quaco linux-perf-tools-build]$ dm
>    1  alpine:3.4                    : Ok   gcc (Alpine 5.3.0) 5.3.0, clang version 3.8.0 (tags/RELEASE_380/final)
>
>
> [perfbuilder@quaco linux-perf-tools-build]$ grep "+ make" dm.log/alpine\:3.4
> + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= -C /git/linux/tools/perf O=/tmp/build/perf
> + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= NO_LIBELF=1 -C /git/linux/tools/perf O=/tmp/build/perf
> + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= -C /git/linux/tools/perf O=/tmp/build/perf CC=clang
> + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= NO_LIBELF=1 -C /git/linux/tools/perf O=/tmp/build/perf CC=clang
> + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= LIBCLANGLLVM=1 -C /git/linux/tools/perf O=/tmp/build/perf CC=clang
> + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= LIBCLANGLLVM=1 -C /git/linux/tools/perf O=/tmp/build/perf
> [perfbuilder@quaco linux-perf-tools-build]$
>
> Probably all the rest will go well, will let you know.
>
> Daniel, do you mind if I carry this one in my perf/core branch? Its
> small and shouldn't clash with other patches, I think. It should go
> upstream soon:
>
> Andrii, there are these others:

I took a look at them, but I think it would be better, if you could
post them as proper patches to
bpf@vger.kernel.org/netdev@vger.kernel.org, so that others can check
and comment, if necessary.

One nit for all three of them: we typically prefix subject with just
"libbpf: " instead of "tools lib libbpf".

>
> 8dfb6ed300bf tools lib bpf: Avoid designated initializers for unnamed union members

+ attr.sample_period = attr.wakeup_events = 1;

let's instead

+ attr.sample_period = 1;
+ attr.wakeup_events = 1;

I don't like multi-assignments.

Also, if we are doing explicit assignment, let's do it for all the
fields, not split initialization like that.


> 80f7f8f21441 tools lib bpf: Avoid using 'link' as it shadows a global definition in some systems

For this one I'm confused. What compiler/system you are getting it on?

I tried to reproduce it with this example (trying both global
variable, as well as function):

#include <stdio.h>

//int link = 1;
void link() {}

int f(int link) {
        return link;
}
int main() {
        printf("%d\n", f(123));
        return 0;
}

I haven't gotten any errors nor warnings. I'm certainly liking
existing naming better, but my main concern is that we'll probably add
more code like this, and we'll forget about this problem and will
re-introduce.

So I'd rather figure out why it's happening and some rare system and
see if we can mitigate that without all the renames.


> d93fe741e291 tools lib bpf: Fix endianness macro usage for some compilers

This one looks good to me, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>


>
> If you could take a look at them at my tmp.perf/core branch at:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/log/?h=tmp.perf/core
>
> I'm force pushing it now to replace my __WORDSIZE patch with yours, the
> SHAs should be the 3 above and the one below.
>
> And to build cleanly I had to cherry pick this one:
>
> 3091dafc1884 (HEAD -> perf/core) libbpf: fix ptr to u64 conversion warning on 32-bit platforms
>
> Alpine:3.5 just finished:
>
>    2 alpine:3.5                    : Ok   gcc (Alpine 6.2.1) 6.2.1 20160822, clang version 3.8.1 (tags/RELEASE_381/final)
>
> - Arnaldo
