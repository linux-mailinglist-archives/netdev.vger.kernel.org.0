Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168591D4809
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgEOIWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726694AbgEOIWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 04:22:05 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954DFC061A0C;
        Fri, 15 May 2020 01:22:03 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id o134so723196ybg.2;
        Fri, 15 May 2020 01:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XyeTfqz3UGt24SeLIl2g9AW/ng3n23DMpFGeZuB/a4I=;
        b=YEIYBUKZdtoQMH76Hn/eg25d0HtVDe0gcV96ufGesve/aUfuOPt1EZ7PgZcfuJVeTs
         jZ3fxx8uFDJ6Us/fAoTgvH7bSnd2UbmqaYaFXxCNfk5yb+Ron2SyzrX6UP7fV7CFfC1Z
         CbWRWyQ/wFQeJIo49bzNHGLQdNuu+g0xfXUhuh8uqWqsLyp9MUqL3RAtr/veo5Ze7bUX
         +eqZzIy3Wp2hTv2RieFhsNmpwyfmk/wAtYEv0abfG11g8lzbpVwkI+XSiVXaQMab71Jg
         vWGc/0rk/LQo3ybZDKKUsWZcqSUi+uuUN/ekRUFJhtgHPL40+3b+EyGhpuS2AS249QDy
         rVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XyeTfqz3UGt24SeLIl2g9AW/ng3n23DMpFGeZuB/a4I=;
        b=E2u63S01soCCmswIrJRUwn9jN1Iut0lXhot5cAxMdgvQ75D5q3tYZlH1JeoHWpgtHn
         zTWmshp4x40Q7aGb/vXOfjn92f3JmvTehJoSiK2SaXhnoOJKm9qTwA84d4WJC8wukNCZ
         7nkKR/K9PcZPp9O2qlW++xq+8RvK5p9h2BSfxuPdGrzQtM10XL4N2iYkWhk1PDGnry+T
         nc2FZMzQB1XD7X0mSoKQLN5PRlOGXUcRZ8y1CHWF/LhrDarOa8oE+fiaI5QtiBwJNxA0
         bBo2u6Wuq5k6/p2qNcbOo7TW83KO33USKktusu4aGEKJye29FIJDOFCJUuLE7Of3yqUb
         MEbQ==
X-Gm-Message-State: AOAM532tjnkHFB+bWPUSXt75dMMvTHar/bKy8AkqOPzhvTfAioxkguFO
        g1ovDkmlV40OIVWbv3EfIuA68H9ZO8wEAuLwCA==
X-Google-Smtp-Source: ABdhPJyHnsWBDpbb05bub9sdNsZ3Gg/mOoa6Ey0zYN65Nzw/NCwva/6eExilVCQd2Hpx4UztSqz40yhVp7/R6N4U/rw=
X-Received: by 2002:a25:b9c4:: with SMTP id y4mr3597726ybj.349.1589530922516;
 Fri, 15 May 2020 01:22:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200512144339.1617069-1-danieltimlee@gmail.com>
 <20200512144339.1617069-2-danieltimlee@gmail.com> <f8d524dc-245b-e8c6-3e0b-16969df76b0a@fb.com>
 <CAEKGpziAt7gDzqzvOO4=dMODB_wajFq-HbYNyfz6xNVaGaB9rQ@mail.gmail.com> <c677db23-1680-6fcb-1629-0a93f60bf2c8@fb.com>
In-Reply-To: <c677db23-1680-6fcb-1629-0a93f60bf2c8@fb.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Fri, 15 May 2020 17:21:48 +0900
Message-ID: <CAEKGpzhuTg3N20eRYjTXj74OzCiG-L0YCsBouMYP2weG6AJ2QA@mail.gmail.com>
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

On Thu, May 14, 2020 at 12:29 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/12/20 11:51 PM, Daniel T. Lee wrote:
> > On Wed, May 13, 2020 at 10:40 AM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 5/12/20 7:43 AM, Daniel T. Lee wrote:
> >>> Currently, the kprobe BPF program attachment method for bpf_load is
> >>> quite old. The implementation of bpf_load "directly" controls and
> >>> manages(create, delete) the kprobe events of DEBUGFS. On the other hand,
> >>> using using the libbpf automatically manages the kprobe event.
> >>> (under bpf_link interface)
> >>>
> >>> By calling bpf_program__attach(_kprobe) in libbpf, the corresponding
> >>> kprobe is created and the BPF program will be attached to this kprobe.
> >>> To remove this, by simply invoking bpf_link__destroy will clean up the
> >>> event.
> >>>
> >>> This commit refactors kprobe tracing programs (tracex{1~7}_user.c) with
> >>> libbpf using bpf_link interface and bpf_program__attach.
> >>>
> >>> tracex2_kern.c, which tracks system calls (sys_*), has been modified to
> >>> append prefix depending on architecture.
> >>>
> >>> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> >>> ---
> >>>    samples/bpf/Makefile       | 12 +++----
> >>>    samples/bpf/tracex1_user.c | 41 ++++++++++++++++++++----
> >>>    samples/bpf/tracex2_kern.c |  8 ++++-
> >>>    samples/bpf/tracex2_user.c | 55 ++++++++++++++++++++++++++------
> >>>    samples/bpf/tracex3_user.c | 65 ++++++++++++++++++++++++++++----------
> >>>    samples/bpf/tracex4_user.c | 55 +++++++++++++++++++++++++-------
> >>>    samples/bpf/tracex6_user.c | 53 +++++++++++++++++++++++++++----
> >>>    samples/bpf/tracex7_user.c | 43 ++++++++++++++++++++-----
> >>>    8 files changed, 268 insertions(+), 64 deletions(-)
> >>>
> >>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> >>> index 424f6fe7ce38..4c91e5914329 100644
> >>> --- a/samples/bpf/Makefile
> >>> +++ b/samples/bpf/Makefile
> >>> @@ -64,13 +64,13 @@ fds_example-objs := fds_example.o
> >>>    sockex1-objs := sockex1_user.o
> >>>    sockex2-objs := sockex2_user.o
> >>>    sockex3-objs := bpf_load.o sockex3_user.o
> >>> -tracex1-objs := bpf_load.o tracex1_user.o $(TRACE_HELPERS)
> >>> -tracex2-objs := bpf_load.o tracex2_user.o
> >>> -tracex3-objs := bpf_load.o tracex3_user.o
> >>> -tracex4-objs := bpf_load.o tracex4_user.o
> >>> +tracex1-objs := tracex1_user.o $(TRACE_HELPERS)
> >>> +tracex2-objs := tracex2_user.o
> >>> +tracex3-objs := tracex3_user.o
> >>> +tracex4-objs := tracex4_user.o
> >>>    tracex5-objs := bpf_load.o tracex5_user.o $(TRACE_HELPERS)
> >>> -tracex6-objs := bpf_load.o tracex6_user.o
> >>> -tracex7-objs := bpf_load.o tracex7_user.o
> >>> +tracex6-objs := tracex6_user.o
> >>> +tracex7-objs := tracex7_user.o
> >>>    test_probe_write_user-objs := bpf_load.o test_probe_write_user_user.o
> >>>    trace_output-objs := bpf_load.o trace_output_user.o $(TRACE_HELPERS)
> >>>    lathist-objs := bpf_load.o lathist_user.o
> >>> diff --git a/samples/bpf/tracex1_user.c b/samples/bpf/tracex1_user.c
> >>> index 55fddbd08702..1b15ab98f7d3 100644
> >>> --- a/samples/bpf/tracex1_user.c
> >>> +++ b/samples/bpf/tracex1_user.c
> >>> @@ -1,21 +1,45 @@
> >>>    // SPDX-License-Identifier: GPL-2.0
> >>>    #include <stdio.h>
> >>> -#include <linux/bpf.h>
> >>>    #include <unistd.h>
> >>> -#include <bpf/bpf.h>
> >>> -#include "bpf_load.h"
> >>> +#include <bpf/libbpf.h>
> >>>    #include "trace_helpers.h"
> >>>
> >>> +#define __must_check
> >>
> >> This is not very user friendly.
> >> Maybe not including linux/err.h and
> >> use libbpf API libbpf_get_error() instead?
> >>
> >
> > This approach looks more apparent and can stick with the libbpf API.
> > I'll update code using this way.
> >
> >>> +#include <linux/err.h>
> >>> +
> >>>    int main(int ac, char **argv)
> >>>    {
> >>> -     FILE *f;
> >>> +     struct bpf_link *link = NULL;
> >>> +     struct bpf_program *prog;
> >>> +     struct bpf_object *obj;
> >>>        char filename[256];
> >>> +     FILE *f;
> >>>
> >>>        snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> >>> +     obj = bpf_object__open_file(filename, NULL);
> >>> +     if (IS_ERR(obj)) {
> >>> +             fprintf(stderr, "ERROR: opening BPF object file failed\n");
> >>> +             obj = NULL;
> >>> +             goto cleanup;
> >>
> >> You do not need to goto cleanup, directly return 0 is okay here.
> >> The same for other files in this patch.
> >>
> >
> > As you said, it would be better to return right away than to proceed
> > any further. I'll apply the code at next patch.
> >
> >>> +     }
> >>> +
> >>> +     prog = bpf_object__find_program_by_name(obj, "bpf_prog1");
> >>> +     if (!prog) {
> >>> +             fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
> >>> +             goto cleanup;
> >>> +     }
> >>> +
> >>> +     /* load BPF program */
> >>> +     if (bpf_object__load(obj)) {
> >>> +             fprintf(stderr, "ERROR: loading BPF object file failed\n");
> >>> +             goto cleanup;
> >>> +     }
> >>>
> >>> -     if (load_bpf_file(filename)) {
> >>> -             printf("%s", bpf_log_buf);
> >>> -             return 1;
> >>> +     link = bpf_program__attach(prog);
> >>> +     if (IS_ERR(link)) {
> >>> +             fprintf(stderr, "ERROR: bpf_program__attach failed\n");
> >>> +             link = NULL;
> >>> +             goto cleanup;
> >>>        }
> >>>
> >>>        f = popen("taskset 1 ping -c5 localhost", "r");
> >>> @@ -23,5 +47,8 @@ int main(int ac, char **argv)
> >>>
> >>>        read_trace_pipe();
> >>>
> >>> +cleanup:
> >>> +     bpf_link__destroy(link);
> >>> +     bpf_object__close(obj);
> >>
> >> Typically in kernel, we do multiple labels for such cases
> >> like
> >> destroy_link:
> >>          bpf_link__destroy(link);
> >> close_object:
> >>          bpf_object__close(obj);
> >>
> >> The error path in the main() function jumps to proper label.
> >> This is more clean and less confusion.
> >>
> >> The same for other cases in this file.
> >>
> >
> > I totally agree that multiple labels are much more intuitive.
> > But It's not very common to jump to the destroy_link label.
> >
> > Either when on the routine is completed successfully and jumps to the
> > destroy_link branch, or an error occurred while bpf_program__attach
> > was called "several" times and jumps to the destroy_link branch.
> >
> > Single bpf_program__attach like this tracex1 sample doesn't really have
> > to destroy link, since the link has been set to NULL on attach error and
> > bpf_link__destroy() is designed to do nothing if passed NULL to it.
> >
> > So I think current approach will keep consistent between samples since
> > most of the sample won't need to jump to destroy_link.
>
> Since this is the sample code, I won't enforce that. So yes, you can
> keep your current approach.
>
> >
> >>>        return 0;
> >>>    }
> >>> diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
> >>> index d865bb309bcb..ff5d00916733 100644
> >>> --- a/samples/bpf/tracex2_kern.c
> >>> +++ b/samples/bpf/tracex2_kern.c
> >>> @@ -11,6 +11,12 @@
> >>>    #include <bpf/bpf_helpers.h>
> >>>    #include <bpf/bpf_tracing.h>
> >>>
> >>> +#ifdef __x86_64__
> >>> +#define SYSCALL "__x64_"
> >>> +#else
> >>> +#define SYSCALL
> >>> +#endif
> >>
> >> See test_progs.h, one more case to handle:
> >> #ifdef __x86_64__
> >> #define SYS_NANOSLEEP_KPROBE_NAME "__x64_sys_nanosleep"
> >> #elif defined(__s390x__)
> >> #define SYS_NANOSLEEP_KPROBE_NAME "__s390x_sys_nanosleep"
> >> #else
> >> #define SYS_NANOSLEEP_KPROBE_NAME "sys_nanosleep"
> >> #endif
> >>
> >
> > That was also one of the considerations when writing patches.
> > I'm planning to refactor most of the programs in the sample using
> > libbpf, and found out that there are bunch of samples that tracks
> > syscall with kprobe. Replacing all of them will take lots of macros
> > and I thought using prefix will be better idea.
> >
> > Actually, my initial plan was to create macro of SYSCALL()
> >
> >         #ifdef __x86_64__
> >         #define PREFIX "__x64_"
> >         #elif defined(__s390x__)
> >         #define PREFIX "__s390x_"
> >         #else
> >         #define PREFIX ""
> >         #endif
> >
> >         #define SYSCALL(SYS) PREFIX ## SYS
> >
> > And to use this macro universally without creating additional headers,
> > I was trying to add this to samples/bpf/syscall_nrs.c which later
> > compiles to samples/bpf/syscall_nrs.h. But it was pretty hacky way and
> > it won't work properly. So I ended up with just adding prefix to syscall.
>
> I think it is okay to create a trace_common.h to have this definition
> defined in one place and use them in bpf programs.
>
> >
> > Is it necessary to define all of the macro for each architecture?
>
> Yes, if we define in trace_common.h, let us do for x64/x390x/others
> similar to the above.
>

Sounds great. I'll add trace_common.h and apply the syscall macro.
I'll send a new version of the patch soon.

> >
> >>> +
> >>>    struct bpf_map_def SEC("maps") my_map = {
> >>>        .type = BPF_MAP_TYPE_HASH,
> >>>        .key_size = sizeof(long),
> >>> @@ -77,7 +83,7 @@ struct bpf_map_def SEC("maps") my_hist_map = {
> >>>        .max_entries = 1024,
> >>>    };
> >>>
> >>> -SEC("kprobe/sys_write")
> >>> +SEC("kprobe/" SYSCALL "sys_write")
> >>>    int bpf_prog3(struct pt_regs *ctx)
> >>>    {
> >>>        long write_size = PT_REGS_PARM3(ctx);
> >> [...]
> >
> >
> > Thank you for your time and effort for the review :)
> >
> > Best,
> > Daniel
> >

Thank you for your time and effort for the review :)

-- 
Best,
Daniel T. Lee
