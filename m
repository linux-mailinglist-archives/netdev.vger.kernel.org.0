Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 205EB10B6D3
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 20:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbfK0TdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 14:33:14 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43184 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbfK0TdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 14:33:14 -0500
Received: by mail-lf1-f67.google.com with SMTP id l14so18090616lfh.10;
        Wed, 27 Nov 2019 11:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RSx7OTjw0zpOYqU/X0SJ0HyqOXCDIW8v0m9WjClqi/s=;
        b=vIGB6nuya7dBARFwL6uh1DiYOzq9Jys1GzivJONLdY04SYXv4UC7ZOPhw6WqAfC23n
         LPrzYDsE++IHWb7q3NQQIcJtb6xVjkXFvTfth888vv+nGy7XUk9U6qqNDztXIP3064re
         JCJQmGmKlGV3vYma9bj19BRsJarwG16feKZZm1gh+bhg8BqI79uYYLZPy9CtybMu/la+
         qHry2xprY9N581HzFYnT/E1QdgTBgANf+KFi8bhSVhTrNGnaYIhGqzuEbfGLWdFut48J
         q1C6unGkgI3hjK2QsgjQeJ9MqH8gzcNTN2IkjcFfTp3gdaMGBCX6ShmxnOAYooUbCz8s
         9QAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RSx7OTjw0zpOYqU/X0SJ0HyqOXCDIW8v0m9WjClqi/s=;
        b=J6z7czPM1xNMWvOuzgXnUfHcdK06Ia/RgUk6455NR729eLoFJSmxy6fObSzBtgPfi3
         m0C/HqijyRPK6IpFhmva3S+3x0vztC8JNJnPiY+KPRovPtMgm8Y2xZAk+wkzdtY/yCbB
         krrp9kMzZcqaNssctInAz7tDPzVDOUz0shxKlKeYFqYv3Ma/CUsicpH3aV01Py96Ixru
         0NQ5F4jcHX50h1iXmRqndTkAyDu42BFKh6lp8uSQVyztXElh9J5u6RWwJ1mt5qBfjGTm
         sSu5tx4nyoAaF0X/6jvh04V1Wxq2Dvx3Z+AIweQvD/P0XL/P6KUoop1g9OhgVZ0XyOEu
         UlKw==
X-Gm-Message-State: APjAAAW5jP0hA6mtklvwFUJhxVq8rXZazWISR/WoYf3n3fBRKrfbEg1z
        9ZYwVuosS0dzphILHWLrkH+O47kQm/drXPQBRTOvEg==
X-Google-Smtp-Source: APXvYqy7HPCiJyTFwTniD3JzD0iem2k+Ybd0glPQhP2ykdIub0GuS7FZOgktbwp0EhMv0fROSauC/ZqH+aDJTAlO9GE=
X-Received: by 2002:a19:888:: with SMTP id 130mr20156546lfi.167.1574883191745;
 Wed, 27 Nov 2019 11:33:11 -0800 (PST)
MIME-Version: 1.0
References: <20191126183451.GC29071@kernel.org> <87d0dexyij.fsf@toke.dk>
 <20191126190450.GD29071@kernel.org> <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com>
 <20191126221018.GA22719@kernel.org> <20191126221733.GB22719@kernel.org>
 <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com>
 <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net> <20191126155228.0e6ed54c@cakuba.netronome.com>
 <20191127013901.GE29071@kernel.org> <20191127134553.GC22719@kernel.org>
In-Reply-To: <20191127134553.GC22719@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 27 Nov 2019 11:33:00 -0800
Message-ID: <CAADnVQ+Hgqg0Pi0GRrRw-fwySbMiYVNwdgvTqOtRTRJPAnEhcQ@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Use PRIu64 for sym->st_value to fix build on
 32-bit arches
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 5:45 AM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Another fix I'm carrying in my perf/core branch,
>
> Regards,
>
> - Arnaldo
>
> commit 98bb09f90a0ae33125fabc8f41529345382f1498
> Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date:   Wed Nov 27 09:26:54 2019 -0300
>
>     libbpf: Use PRIu64 for sym->st_value to fix build on 32-bit arches
>
>     The st_value field is a 64-bit value, so use PRIu64 to fix this error on
>     32-bit arches:
>
>       In file included from libbpf.c:52:
>       libbpf.c: In function 'bpf_program__record_reloc':
>       libbpf_internal.h:59:22: error: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'Elf64_Addr' {aka 'const long long unsigned int'} [-Werror=format=]
>         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
>                             ^~~~~~~~~~
>       libbpf_internal.h:62:27: note: in expansion of macro '__pr'
>        #define pr_warn(fmt, ...) __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
>                                  ^~~~
>       libbpf.c:1822:4: note: in expansion of macro 'pr_warn'
>           pr_warn("bad call relo offset: %lu\n", sym->st_value);
>           ^~~~~~~
>       libbpf.c:1822:37: note: format string is defined here
>           pr_warn("bad call relo offset: %lu\n", sym->st_value);
>                                          ~~^
>                                          %llu
>
>     Fixes: 1f8e2bcb2cd5 ("libbpf: Refactor relocation handling")
>     Cc: Alexei Starovoitov <ast@kernel.org>
>     Cc: Andrii Nakryiko <andriin@fb.com>
>     Link: https://lkml.kernel.org/n/tip-iabs1wq19c357bkk84p7blif@git.kernel.org
>     Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index b20f82e58989..6b0eae5c8a94 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1819,7 +1819,7 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
>                         return -LIBBPF_ERRNO__RELOC;
>                 }
>                 if (sym->st_value % 8) {
> -                       pr_warn("bad call relo offset: %lu\n", sym->st_value);
> +                       pr_warn("bad call relo offset: %" PRIu64 "\n", sym->st_value);

Looking at this more... I never liked this PRI stuff. It makes for
such unreadable code.
How about just typecasting st_value to (long) ?
