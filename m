Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DBE1FFA9D
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 19:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgFRRxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 13:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbgFRRx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 13:53:27 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3ECEC06174E;
        Thu, 18 Jun 2020 10:53:26 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id l17so6395327qki.9;
        Thu, 18 Jun 2020 10:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yq8e8gIvbXqQ4rRwZVqh8S7lLdpmKVcmmToQa1hhZLM=;
        b=iLqGHLCu1HSxVWeIze62d+6an/8ebsIyxu6pAjAvPkKier+IEupWQiTTEPfT0icPDt
         0629C3+2Qhqw2DfGxJzfMrG6muZ847OqqOvQMbT7TTSLApMKBazVATc00AV56tFDuTrf
         axkvaRqNRE3hWBhPm6rFdJlfb1CMv6C0FlzOG5+dixFG3ZXEG+4kHufIPz+Bb+OWFZcB
         OM5fyrtKWa+P1mMvE3ocqdzCEZxSxiNYJ9om0n8urUufdi6GMR1A20pl6+ykF31CWB8R
         5QZ6umQFtTBaaF3nDRifjoHRriMbXVf6USYVruxKg35nbWKQnffQuSTkIqCx2N/hQFTL
         kKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yq8e8gIvbXqQ4rRwZVqh8S7lLdpmKVcmmToQa1hhZLM=;
        b=OgMf7lfdusbvyNlYwa71eF0BdJqlNBpnmTUlgPF0skaH1lKvVarW1AH6S4+TM/lj0s
         STIEpwNX/gPZ/eg7EzO0hrMK8Z23fHOLCw2tTpPDKf+HxOgyleRd2/WhJODPpjFEhXAO
         NhQhDyVRmxP6w9az4KOz6Qdf9JoFjhE+Alpwc3xDwo4LJwP0VPllK1/gCbXVQS6XvNV5
         nn0SKPiQng2u7ApGhYc0U9xRmm1DGlxdwm+iOlmrUhhIWoHgrqa0vHjTfgTrSWo8xmDH
         TcfuFoUNfL4c4uSmpbTtFDzBUUWfZQJB5akhvpsHAhb7ufhOFSbiKDz3jG5Px3vWSrAr
         toHQ==
X-Gm-Message-State: AOAM533yo4Vznl1dLoOVltAYyY6n/OlEBQr9XQ6KoLGHT7ihmMgp2meJ
        4fdVtJYmqo1Z5KmMigyhwoVk+qnYzzwV4zATy4c=
X-Google-Smtp-Source: ABdhPJwa9Z+FAHeFhMeDqZXOdNTHTULvsTCmEKB9jkpgSopMTOCiTNP6aEV82wLvjpoLM0nssiEXm80iJfO48kHYWhw=
X-Received: by 2002:a37:a89:: with SMTP id 131mr41442qkk.92.1592502805937;
 Thu, 18 Jun 2020 10:53:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200617161832.1438371-1-andriin@fb.com> <20200617161832.1438371-9-andriin@fb.com>
 <eebb2cea-dc27-77c6-936e-06ac5272921a@isovalent.com> <CAEf4BzbwKObO7CTrC8DJJo-M2trrB94spn2Ta0-GDWJ82uE41A@mail.gmail.com>
 <f8ba3a62-0bca-a2b3-9b17-1209c6cf42bb@isovalent.com>
In-Reply-To: <f8ba3a62-0bca-a2b3-9b17-1209c6cf42bb@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 10:53:14 -0700
Message-ID: <CAEf4BzYxDXFqiEAMvznXwObkjwj0+-W1F+apNO_XH6A9AaU0jQ@mail.gmail.com>
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

On Thu, Jun 18, 2020 at 12:51 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2020-06-17 23:01 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Wed, Jun 17, 2020 at 5:24 PM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> 2020-06-17 09:18 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> >>> Add bpf_iter-based way to find all the processes that hold open FDs against
> >>> BPF object (map, prog, link, btf). bpftool always attempts to discover this,
> >>> but will silently give up if kernel doesn't yet support bpf_iter BPF programs.
> >>> Process name and PID are emitted for each process (task group).
> >>>
> >>> Sample output for each of 4 BPF objects:
> >>>
> >>> $ sudo ./bpftool prog show
> >>> 2694: cgroup_device  tag 8c42dee26e8cd4c2  gpl
> >>>         loaded_at 2020-06-16T15:34:32-0700  uid 0
> >>>         xlated 648B  jited 409B  memlock 4096B
> >>>         pids systemd(1)
> >>> 2907: cgroup_skb  name egress  tag 9ad187367cf2b9e8  gpl
> >>>         loaded_at 2020-06-16T18:06:54-0700  uid 0
> >>>         xlated 48B  jited 59B  memlock 4096B  map_ids 2436
> >>>         btf_id 1202
> >>>         pids test_progs(2238417), test_progs(2238445)
> >>>
> >>> $ sudo ./bpftool map show
> >>> 2436: array  name test_cgr.bss  flags 0x400
> >>>         key 4B  value 8B  max_entries 1  memlock 8192B
> >>>         btf_id 1202
> >>>         pids test_progs(2238417), test_progs(2238445)
> >>> 2445: array  name pid_iter.rodata  flags 0x480
> >>>         key 4B  value 4B  max_entries 1  memlock 8192B
> >>>         btf_id 1214  frozen
> >>>         pids bpftool(2239612)
> >>>
> >>> $ sudo ./bpftool link show
> >>> 61: cgroup  prog 2908
> >>>         cgroup_id 375301  attach_type egress
> >>>         pids test_progs(2238417), test_progs(2238445)
> >>> 62: cgroup  prog 2908
> >>>         cgroup_id 375344  attach_type egress
> >>>         pids test_progs(2238417), test_progs(2238445)
> >>>
> >>> $ sudo ./bpftool btf show
> >>> 1202: size 1527B  prog_ids 2908,2907  map_ids 2436
> >>>         pids test_progs(2238417), test_progs(2238445)
> >>> 1242: size 34684B
> >>>         pids bpftool(2258892)
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>> ---
> >>
> >> [...]
> >>
> >>> diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
> >>> new file mode 100644
> >>> index 000000000000..3474a91743ff
> >>> --- /dev/null
> >>> +++ b/tools/bpf/bpftool/pids.c
> >>> @@ -0,0 +1,229 @@
> >>
> >> [...]
> >>
> >>> +int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
> >>> +{
> >>> +     char buf[4096];
> >>> +     struct pid_iter_bpf *skel;
> >>> +     struct pid_iter_entry *e;
> >>> +     int err, ret, fd = -1, i;
> >>> +     libbpf_print_fn_t default_print;
> >>> +
> >>> +     hash_init(table->table);
> >>> +     set_max_rlimit();
> >>> +
> >>> +     skel = pid_iter_bpf__open();
> >>> +     if (!skel) {
> >>> +             p_err("failed to open PID iterator skeleton");
> >>> +             return -1;
> >>> +     }
> >>> +
> >>> +     skel->rodata->obj_type = type;
> >>> +
> >>> +     /* we don't want output polluted with libbpf errors if bpf_iter is not
> >>> +      * supported
> >>> +      */
> >>> +     default_print = libbpf_set_print(libbpf_print_none);
> >>> +     err = pid_iter_bpf__load(skel);
> >>> +     libbpf_set_print(default_print);
> >>> +     if (err) {
> >>> +             /* too bad, kernel doesn't support BPF iterators yet */
> >>> +             err = 0;
> >>> +             goto out;
> >>> +     }
> >>> +     err = pid_iter_bpf__attach(skel);
> >>> +     if (err) {
> >>> +             /* if we loaded above successfully, attach has to succeed */
> >>> +             p_err("failed to attach PID iterator: %d", err);
> >>
> >> Nit: What about using strerror(err) for the error messages, here and
> >> below? It's easier to read than an integer value.
> >
> > I'm actually against it. Just a pure string message for error is often
> > quite confusing. It's an extra step, and sometimes quite a quest in
> > itself, to find what's the integer value of errno it was, just to try
> > to understand what kind of error it actually is. So I certainly prefer
> > having integer value, optionally with a string error message.
> >
> > But that's too much hassle for this "shouldn't happen" type of errors.
> > If they happen, the user is unlikely to infer anything useful and fix
> > the problem by themselves. They will most probably have to ask on the
> > mailing list and paste error messages verbatim and let people like me
> > and you try to guess what's going on. In such cases, having an errno
> > number is much more helpful.
>
> Ok, fair enough.
>
> >>> +             goto out;
> >>> +     }
> >>> +
> >>> +     fd = bpf_iter_create(bpf_link__fd(skel->links.iter));
> >>> +     if (fd < 0) {
> >>> +             err = -errno;
> >>> +             p_err("failed to create PID iterator session: %d", err);
> >>> +             goto out;
> >>> +     }
> >>> +
> >>> +     while (true) {
> >>> +             ret = read(fd, buf, sizeof(buf));
> >>> +             if (ret < 0) {
> >>> +                     err = -errno;
> >>> +                     p_err("failed to read PID iterator output: %d", err);
> >>> +                     goto out;
> >>> +             }
> >>> +             if (ret == 0)
> >>> +                     break;
> >>> +             if (ret % sizeof(*e)) {
> >>> +                     err = -EINVAL;
> >>> +                     p_err("invalid PID iterator output format");
> >>> +                     goto out;
> >>> +             }
> >>> +             ret /= sizeof(*e);
> >>> +
> >>> +             e = (void *)buf;
> >>> +             for (i = 0; i < ret; i++, e++) {
> >>> +                     add_ref(table, e);
> >>> +             }
> >>> +     }
> >>> +     err = 0;
> >>> +out:
> >>> +     if (fd >= 0)
> >>> +             close(fd);
> >>> +     pid_iter_bpf__destroy(skel);
> >>> +     return err;
> >>> +}
> >>
> >> [...]
> >>
> >>> diff --git a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
> >>> new file mode 100644
> >>> index 000000000000..f560e48add07
> >>> --- /dev/null
> >>> +++ b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
> >>> @@ -0,0 +1,80 @@
> >>> +// SPDX-License-Identifier: GPL-2.0
> >>
> >> This would make it the only file not dual-licensed GPL/BSD in bpftool.
> >> We've had issues with that before [0], although linking to libbfd is no
> >> more a hard requirement. But I see you used a dual-license in the
> >> corresponding header file pid_iter.h, so is the single license
> >> intentional here? Or would you consider GPL/BSD?
> >>
> >
> > The other BPF program (skeleton/profiler.bpf.c) is also GPL-2.0, we
> > should probably switch both.
>
> Oh I missed that one :(. Yeah, if this is possible, that would be great!
>
> >> [0] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=896165#38
> >>
> >>> +// Copyright (c) 2020 Facebook
> >>> +#include <vmlinux.h>
> >>> +#include <bpf/bpf_helpers.h>
> >>> +#include <bpf/bpf_core_read.h>
> >>> +#include <bpf/bpf_tracing.h>
> >>> +#include "pid_iter.h"
> >>
> >> [...]
> >>
> >>> +
> >>> +char LICENSE[] SEC("license") = "GPL";
> >
> > I wonder if leaving this as GPL would be ok, if the source code itself
> > is dual GPL/BSD?
>
> If the concern is to pass the verifier, it accepts a handful of
> different strings (see include/linux/license.h), one of which is "Dual
> BSD/GPL" and should probably be used in that case. Or did you have
> something else in mind?

Oh, awesome, wasn't aware of this. I'll use "Dual BSD/GPL" then.
