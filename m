Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59641FEB3A
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 08:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgFRGBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 02:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgFRGBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 02:01:42 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5AFC06174E;
        Wed, 17 Jun 2020 23:01:41 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id l6so881354qkc.6;
        Wed, 17 Jun 2020 23:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KS5EC5Sc+C38bLntJac1O3X5hPQtnOtVxpWGWEabC9s=;
        b=fV/0X1z21LHew0uLfzj5Tnqyhc5MY7oAjg/X7e32Jp+sNvCowBpab6Al24Ujg7xXy2
         cNtbBg51tZi8zmLRRvajCahMa3jX/We6lOKRZvqYbnUHJl1D71xiXALqL0vudCFoYMKg
         0YP2yTVY1vxp1mUK0l92TF2KtWhl3mQ925H1rUrkMD2OvnNtAxlAwohhlfPDbLwgMxkT
         ZupHD8+AHy0wWWhMCj9Q4HLsD32H4dtS9+Y3wAe2qha9f+qE7pd5wu2hAkUmgc8Z/+1Y
         Qqzm5cdxVftFIlDaBZgBYUg0XhQGB+spJqvRK0W2L02Rffw2rhdKrs5AZkVxdHY4sZJF
         4wew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KS5EC5Sc+C38bLntJac1O3X5hPQtnOtVxpWGWEabC9s=;
        b=DFJTfRFp6PrXInF3d3/WBWzAcPkjgYuMufFxk1nzOD40n8EG8RjYEGdASWU/toIyUX
         X98R2iHVTOrToPIHle1aEnoD6ZFu53H6I5oZbOVcOaZPI2M6CEHdzPqB05BwzNIxdxbO
         M7AHZfiFubYFGbVNpU/V48wqlSDDDDDYhX13JMDWPVaPLI17r+k2O0limH8yaXVEYNCE
         rXjc1xM/7DYpvG1Br3DwV21PrXtCsc52rK/7YNAL/VJsPh/7ANQOElUqS/niEXJpUVwu
         +Mrku9vpyeTWIL4a9cY5gR+zq97JgDgI6MisMZ55d321kIeWPTyeDB9jlZ3XfFijjQfE
         IQhA==
X-Gm-Message-State: AOAM532y6O99RtvwCGd4yXAgjuRB6BbOz9oKbiqLRa7S2XLqsdztR0W7
        mOzPEMMvKiUnfCxcIoxIyue8c6HqoESEMkfYtBk=
X-Google-Smtp-Source: ABdhPJwI6crUidmv4sc3RkhV9Qdhrz5/4euOGmXN6YRX+pN3VS2piX5MVUEy2HsBjcWsJFiIDti8C8tU1Rm+Uc8ISkk=
X-Received: by 2002:a37:6712:: with SMTP id b18mr2324647qkc.36.1592460100817;
 Wed, 17 Jun 2020 23:01:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200617161832.1438371-1-andriin@fb.com> <20200617161832.1438371-9-andriin@fb.com>
 <eebb2cea-dc27-77c6-936e-06ac5272921a@isovalent.com>
In-Reply-To: <eebb2cea-dc27-77c6-936e-06ac5272921a@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 17 Jun 2020 23:01:29 -0700
Message-ID: <CAEf4BzbwKObO7CTrC8DJJo-M2trrB94spn2Ta0-GDWJ82uE41A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 8/9] tools/bpftool: show info for processes
 holding BPF map/prog/link/btf FDs
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 5:24 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2020-06-17 09:18 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> > Add bpf_iter-based way to find all the processes that hold open FDs against
> > BPF object (map, prog, link, btf). bpftool always attempts to discover this,
> > but will silently give up if kernel doesn't yet support bpf_iter BPF programs.
> > Process name and PID are emitted for each process (task group).
> >
> > Sample output for each of 4 BPF objects:
> >
> > $ sudo ./bpftool prog show
> > 2694: cgroup_device  tag 8c42dee26e8cd4c2  gpl
> >         loaded_at 2020-06-16T15:34:32-0700  uid 0
> >         xlated 648B  jited 409B  memlock 4096B
> >         pids systemd(1)
> > 2907: cgroup_skb  name egress  tag 9ad187367cf2b9e8  gpl
> >         loaded_at 2020-06-16T18:06:54-0700  uid 0
> >         xlated 48B  jited 59B  memlock 4096B  map_ids 2436
> >         btf_id 1202
> >         pids test_progs(2238417), test_progs(2238445)
> >
> > $ sudo ./bpftool map show
> > 2436: array  name test_cgr.bss  flags 0x400
> >         key 4B  value 8B  max_entries 1  memlock 8192B
> >         btf_id 1202
> >         pids test_progs(2238417), test_progs(2238445)
> > 2445: array  name pid_iter.rodata  flags 0x480
> >         key 4B  value 4B  max_entries 1  memlock 8192B
> >         btf_id 1214  frozen
> >         pids bpftool(2239612)
> >
> > $ sudo ./bpftool link show
> > 61: cgroup  prog 2908
> >         cgroup_id 375301  attach_type egress
> >         pids test_progs(2238417), test_progs(2238445)
> > 62: cgroup  prog 2908
> >         cgroup_id 375344  attach_type egress
> >         pids test_progs(2238417), test_progs(2238445)
> >
> > $ sudo ./bpftool btf show
> > 1202: size 1527B  prog_ids 2908,2907  map_ids 2436
> >         pids test_progs(2238417), test_progs(2238445)
> > 1242: size 34684B
> >         pids bpftool(2258892)
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
>
> [...]
>
> > diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
> > new file mode 100644
> > index 000000000000..3474a91743ff
> > --- /dev/null
> > +++ b/tools/bpf/bpftool/pids.c
> > @@ -0,0 +1,229 @@
>
> [...]
>
> > +int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
> > +{
> > +     char buf[4096];
> > +     struct pid_iter_bpf *skel;
> > +     struct pid_iter_entry *e;
> > +     int err, ret, fd = -1, i;
> > +     libbpf_print_fn_t default_print;
> > +
> > +     hash_init(table->table);
> > +     set_max_rlimit();
> > +
> > +     skel = pid_iter_bpf__open();
> > +     if (!skel) {
> > +             p_err("failed to open PID iterator skeleton");
> > +             return -1;
> > +     }
> > +
> > +     skel->rodata->obj_type = type;
> > +
> > +     /* we don't want output polluted with libbpf errors if bpf_iter is not
> > +      * supported
> > +      */
> > +     default_print = libbpf_set_print(libbpf_print_none);
> > +     err = pid_iter_bpf__load(skel);
> > +     libbpf_set_print(default_print);
> > +     if (err) {
> > +             /* too bad, kernel doesn't support BPF iterators yet */
> > +             err = 0;
> > +             goto out;
> > +     }
> > +     err = pid_iter_bpf__attach(skel);
> > +     if (err) {
> > +             /* if we loaded above successfully, attach has to succeed */
> > +             p_err("failed to attach PID iterator: %d", err);
>
> Nit: What about using strerror(err) for the error messages, here and
> below? It's easier to read than an integer value.

I'm actually against it. Just a pure string message for error is often
quite confusing. It's an extra step, and sometimes quite a quest in
itself, to find what's the integer value of errno it was, just to try
to understand what kind of error it actually is. So I certainly prefer
having integer value, optionally with a string error message.

But that's too much hassle for this "shouldn't happen" type of errors.
If they happen, the user is unlikely to infer anything useful and fix
the problem by themselves. They will most probably have to ask on the
mailing list and paste error messages verbatim and let people like me
and you try to guess what's going on. In such cases, having an errno
number is much more helpful.

>
> > +             goto out;
> > +     }
> > +
> > +     fd = bpf_iter_create(bpf_link__fd(skel->links.iter));
> > +     if (fd < 0) {
> > +             err = -errno;
> > +             p_err("failed to create PID iterator session: %d", err);
> > +             goto out;
> > +     }
> > +
> > +     while (true) {
> > +             ret = read(fd, buf, sizeof(buf));
> > +             if (ret < 0) {
> > +                     err = -errno;
> > +                     p_err("failed to read PID iterator output: %d", err);
> > +                     goto out;
> > +             }
> > +             if (ret == 0)
> > +                     break;
> > +             if (ret % sizeof(*e)) {
> > +                     err = -EINVAL;
> > +                     p_err("invalid PID iterator output format");
> > +                     goto out;
> > +             }
> > +             ret /= sizeof(*e);
> > +
> > +             e = (void *)buf;
> > +             for (i = 0; i < ret; i++, e++) {
> > +                     add_ref(table, e);
> > +             }
> > +     }
> > +     err = 0;
> > +out:
> > +     if (fd >= 0)
> > +             close(fd);
> > +     pid_iter_bpf__destroy(skel);
> > +     return err;
> > +}
>
> [...]
>
> > diff --git a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
> > new file mode 100644
> > index 000000000000..f560e48add07
> > --- /dev/null
> > +++ b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
> > @@ -0,0 +1,80 @@
> > +// SPDX-License-Identifier: GPL-2.0
>
> This would make it the only file not dual-licensed GPL/BSD in bpftool.
> We've had issues with that before [0], although linking to libbfd is no
> more a hard requirement. But I see you used a dual-license in the
> corresponding header file pid_iter.h, so is the single license
> intentional here? Or would you consider GPL/BSD?
>

The other BPF program (skeleton/profiler.bpf.c) is also GPL-2.0, we
should probably switch both.

> [0] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=896165#38
>
> > +// Copyright (c) 2020 Facebook
> > +#include <vmlinux.h>
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_core_read.h>
> > +#include <bpf/bpf_tracing.h>
> > +#include "pid_iter.h"
>
> [...]
>
> > +
> > +char LICENSE[] SEC("license") = "GPL";

I wonder if leaving this as GPL would be ok, if the source code itself
is dual GPL/BSD?


> > diff --git a/tools/bpf/bpftool/skeleton/pid_iter.h b/tools/bpf/bpftool/skeleton/pid_iter.h
> > new file mode 100644
> > index 000000000000..5692cf257adb
> > --- /dev/null
> > +++ b/tools/bpf/bpftool/skeleton/pid_iter.h
> > @@ -0,0 +1,12 @@
> > +/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
>
> [...]
>
