Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552281D0903
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbgEMGv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729367AbgEMGv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 02:51:27 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00395C061A0C;
        Tue, 12 May 2020 23:51:26 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id a10so4050251ybc.3;
        Tue, 12 May 2020 23:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Hq0+NcHUZkPr45/gSvsislYzDjnCtP4+4enTWioQS0=;
        b=HvSuMsTw+H6ECYAn3bYAHkH80FyGJz5hQVbr8w2zbDIKgzT+mPZUjcz9rgaIIn7hYP
         5B8HK/ayRmCLTTOfX5vn/5OorG1J9/m6Bz8wjgQjF/ynR0gn552SBN+Jsf9QlwLmxGjv
         RMVzXdogYOg1P/IMCQORiUu/Qegbe9/5pGvg2EqZc2iXuihIBijTMHx+DIs6IPjwgoCl
         f3AcPlcW9n0zSoKIQyfncFH6BvOcW8CVW2DtWpvBVPbVqV4Hd+txsAgqnOQsIx9FLVdg
         niWn6y4wIlGszRPT9jL7i1Ai7AC7NQpuLv/cYZiWteO9DzHEJWtb+R0lA9N3iBDWri/J
         lg+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Hq0+NcHUZkPr45/gSvsislYzDjnCtP4+4enTWioQS0=;
        b=T2FAQ9px+WDwUXtMIqOKpIyidRL+KjXO3wTbNPK9QxQB1mri6+JD1cG/nh1rx5hSwi
         CYKGilqkFqFrFC+8+qOZUAzrnTK7BFla2XkGe0gNNRgj+nMnnGLiLuIIhzVf0VBLUrrY
         rkgHPquyFCZMKLDI4d+iepPvR71wjLz2sBIMxb+nSNbIwj1ByRT0Zzq+KbnYFmwVmM5R
         ctaq2xzF8eWjAPre3e6gvqlnwWNIhZPW0qHVQbS4544XKL2NkJf3FmexhjRtCCGLEApQ
         jWJbwszjfWrN+5FG7H8sAL54Lh8ahUc6SyFTOlEgoKscIi454b1sT/bNQgaTj640s5jE
         usDA==
X-Gm-Message-State: AOAM530IxzhtMTHRfhqRWm52rrlLD5q/ijyD2Tl79R2RL33GcupphfNm
        r+q10igaTJeKIjgn5QM0lDHbKZ9JxmHyqV7j+zqMrt/GxVHmfhA=
X-Google-Smtp-Source: ABdhPJy53mfROHub+rZ0huUz9CN07I0rQaNYlC1G/rDqav2f790At8JYNBObnUshQ9zDcKHyHxC+LyQYKnUXay5o4IA=
X-Received: by 2002:a25:ab89:: with SMTP id v9mr19565502ybi.306.1589352686108;
 Tue, 12 May 2020 23:51:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200512144339.1617069-1-danieltimlee@gmail.com>
 <20200512144339.1617069-2-danieltimlee@gmail.com> <f8d524dc-245b-e8c6-3e0b-16969df76b0a@fb.com>
In-Reply-To: <f8d524dc-245b-e8c6-3e0b-16969df76b0a@fb.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Wed, 13 May 2020 15:51:10 +0900
Message-ID: <CAEKGpziAt7gDzqzvOO4=dMODB_wajFq-HbYNyfz6xNVaGaB9rQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] samples: bpf: refactor kprobe tracing user
 progs with libbpf
To:     Yonghong Song <yhs@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 10:40 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/12/20 7:43 AM, Daniel T. Lee wrote:
> > Currently, the kprobe BPF program attachment method for bpf_load is
> > quite old. The implementation of bpf_load "directly" controls and
> > manages(create, delete) the kprobe events of DEBUGFS. On the other hand,
> > using using the libbpf automatically manages the kprobe event.
> > (under bpf_link interface)
> >
> > By calling bpf_program__attach(_kprobe) in libbpf, the corresponding
> > kprobe is created and the BPF program will be attached to this kprobe.
> > To remove this, by simply invoking bpf_link__destroy will clean up the
> > event.
> >
> > This commit refactors kprobe tracing programs (tracex{1~7}_user.c) with
> > libbpf using bpf_link interface and bpf_program__attach.
> >
> > tracex2_kern.c, which tracks system calls (sys_*), has been modified to
> > append prefix depending on architecture.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >   samples/bpf/Makefile       | 12 +++----
> >   samples/bpf/tracex1_user.c | 41 ++++++++++++++++++++----
> >   samples/bpf/tracex2_kern.c |  8 ++++-
> >   samples/bpf/tracex2_user.c | 55 ++++++++++++++++++++++++++------
> >   samples/bpf/tracex3_user.c | 65 ++++++++++++++++++++++++++++----------
> >   samples/bpf/tracex4_user.c | 55 +++++++++++++++++++++++++-------
> >   samples/bpf/tracex6_user.c | 53 +++++++++++++++++++++++++++----
> >   samples/bpf/tracex7_user.c | 43 ++++++++++++++++++++-----
> >   8 files changed, 268 insertions(+), 64 deletions(-)
> >
> > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > index 424f6fe7ce38..4c91e5914329 100644
> > --- a/samples/bpf/Makefile
> > +++ b/samples/bpf/Makefile
> > @@ -64,13 +64,13 @@ fds_example-objs := fds_example.o
> >   sockex1-objs := sockex1_user.o
> >   sockex2-objs := sockex2_user.o
> >   sockex3-objs := bpf_load.o sockex3_user.o
> > -tracex1-objs := bpf_load.o tracex1_user.o $(TRACE_HELPERS)
> > -tracex2-objs := bpf_load.o tracex2_user.o
> > -tracex3-objs := bpf_load.o tracex3_user.o
> > -tracex4-objs := bpf_load.o tracex4_user.o
> > +tracex1-objs := tracex1_user.o $(TRACE_HELPERS)
> > +tracex2-objs := tracex2_user.o
> > +tracex3-objs := tracex3_user.o
> > +tracex4-objs := tracex4_user.o
> >   tracex5-objs := bpf_load.o tracex5_user.o $(TRACE_HELPERS)
> > -tracex6-objs := bpf_load.o tracex6_user.o
> > -tracex7-objs := bpf_load.o tracex7_user.o
> > +tracex6-objs := tracex6_user.o
> > +tracex7-objs := tracex7_user.o
> >   test_probe_write_user-objs := bpf_load.o test_probe_write_user_user.o
> >   trace_output-objs := bpf_load.o trace_output_user.o $(TRACE_HELPERS)
> >   lathist-objs := bpf_load.o lathist_user.o
> > diff --git a/samples/bpf/tracex1_user.c b/samples/bpf/tracex1_user.c
> > index 55fddbd08702..1b15ab98f7d3 100644
> > --- a/samples/bpf/tracex1_user.c
> > +++ b/samples/bpf/tracex1_user.c
> > @@ -1,21 +1,45 @@
> >   // SPDX-License-Identifier: GPL-2.0
> >   #include <stdio.h>
> > -#include <linux/bpf.h>
> >   #include <unistd.h>
> > -#include <bpf/bpf.h>
> > -#include "bpf_load.h"
> > +#include <bpf/libbpf.h>
> >   #include "trace_helpers.h"
> >
> > +#define __must_check
>
> This is not very user friendly.
> Maybe not including linux/err.h and
> use libbpf API libbpf_get_error() instead?
>

This approach looks more apparent and can stick with the libbpf API.
I'll update code using this way.

> > +#include <linux/err.h>
> > +
> >   int main(int ac, char **argv)
> >   {
> > -     FILE *f;
> > +     struct bpf_link *link = NULL;
> > +     struct bpf_program *prog;
> > +     struct bpf_object *obj;
> >       char filename[256];
> > +     FILE *f;
> >
> >       snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> > +     obj = bpf_object__open_file(filename, NULL);
> > +     if (IS_ERR(obj)) {
> > +             fprintf(stderr, "ERROR: opening BPF object file failed\n");
> > +             obj = NULL;
> > +             goto cleanup;
>
> You do not need to goto cleanup, directly return 0 is okay here.
> The same for other files in this patch.
>

As you said, it would be better to return right away than to proceed
any further. I'll apply the code at next patch.

> > +     }
> > +
> > +     prog = bpf_object__find_program_by_name(obj, "bpf_prog1");
> > +     if (!prog) {
> > +             fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
> > +             goto cleanup;
> > +     }
> > +
> > +     /* load BPF program */
> > +     if (bpf_object__load(obj)) {
> > +             fprintf(stderr, "ERROR: loading BPF object file failed\n");
> > +             goto cleanup;
> > +     }
> >
> > -     if (load_bpf_file(filename)) {
> > -             printf("%s", bpf_log_buf);
> > -             return 1;
> > +     link = bpf_program__attach(prog);
> > +     if (IS_ERR(link)) {
> > +             fprintf(stderr, "ERROR: bpf_program__attach failed\n");
> > +             link = NULL;
> > +             goto cleanup;
> >       }
> >
> >       f = popen("taskset 1 ping -c5 localhost", "r");
> > @@ -23,5 +47,8 @@ int main(int ac, char **argv)
> >
> >       read_trace_pipe();
> >
> > +cleanup:
> > +     bpf_link__destroy(link);
> > +     bpf_object__close(obj);
>
> Typically in kernel, we do multiple labels for such cases
> like
> destroy_link:
>         bpf_link__destroy(link);
> close_object:
>         bpf_object__close(obj);
>
> The error path in the main() function jumps to proper label.
> This is more clean and less confusion.
>
> The same for other cases in this file.
>

I totally agree that multiple labels are much more intuitive.
But It's not very common to jump to the destroy_link label.

Either when on the routine is completed successfully and jumps to the
destroy_link branch, or an error occurred while bpf_program__attach
was called "several" times and jumps to the destroy_link branch.

Single bpf_program__attach like this tracex1 sample doesn't really have
to destroy link, since the link has been set to NULL on attach error and
bpf_link__destroy() is designed to do nothing if passed NULL to it.

So I think current approach will keep consistent between samples since
most of the sample won't need to jump to destroy_link.

> >       return 0;
> >   }
> > diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
> > index d865bb309bcb..ff5d00916733 100644
> > --- a/samples/bpf/tracex2_kern.c
> > +++ b/samples/bpf/tracex2_kern.c
> > @@ -11,6 +11,12 @@
> >   #include <bpf/bpf_helpers.h>
> >   #include <bpf/bpf_tracing.h>
> >
> > +#ifdef __x86_64__
> > +#define SYSCALL "__x64_"
> > +#else
> > +#define SYSCALL
> > +#endif
>
> See test_progs.h, one more case to handle:
> #ifdef __x86_64__
> #define SYS_NANOSLEEP_KPROBE_NAME "__x64_sys_nanosleep"
> #elif defined(__s390x__)
> #define SYS_NANOSLEEP_KPROBE_NAME "__s390x_sys_nanosleep"
> #else
> #define SYS_NANOSLEEP_KPROBE_NAME "sys_nanosleep"
> #endif
>

That was also one of the considerations when writing patches.
I'm planning to refactor most of the programs in the sample using
libbpf, and found out that there are bunch of samples that tracks
syscall with kprobe. Replacing all of them will take lots of macros
and I thought using prefix will be better idea.

Actually, my initial plan was to create macro of SYSCALL()

       #ifdef __x86_64__
       #define PREFIX "__x64_"
       #elif defined(__s390x__)
       #define PREFIX "__s390x_"
       #else
       #define PREFIX ""
       #endif

       #define SYSCALL(SYS) PREFIX ## SYS

And to use this macro universally without creating additional headers,
I was trying to add this to samples/bpf/syscall_nrs.c which later
compiles to samples/bpf/syscall_nrs.h. But it was pretty hacky way and
it won't work properly. So I ended up with just adding prefix to syscall.

Is it necessary to define all of the macro for each architecture?

> > +
> >   struct bpf_map_def SEC("maps") my_map = {
> >       .type = BPF_MAP_TYPE_HASH,
> >       .key_size = sizeof(long),
> > @@ -77,7 +83,7 @@ struct bpf_map_def SEC("maps") my_hist_map = {
> >       .max_entries = 1024,
> >   };
> >
> > -SEC("kprobe/sys_write")
> > +SEC("kprobe/" SYSCALL "sys_write")
> >   int bpf_prog3(struct pt_regs *ctx)
> >   {
> >       long write_size = PT_REGS_PARM3(ctx);
> [...]


Thank you for your time and effort for the review :)

Best,
Daniel
