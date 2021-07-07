Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BD63BF124
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 23:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhGGVDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 17:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbhGGVDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 17:03:31 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13677C061574;
        Wed,  7 Jul 2021 14:00:50 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id p22so5324111yba.7;
        Wed, 07 Jul 2021 14:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P1Nbtrbxt6aWe7JQzpYNK9vcZ7WcZdvC5Z9Jfj4k9JE=;
        b=ewnY/SG2HUz4uoVVPnpKN7dN4RPrCH0rv2Mj2gwd/1O8r/etJaD+nwu0gbQT26LN/u
         GmzH5DetR8KVNoPJ9WreJBo0jYHlZB3SyI49UiUg6sgnXgPOnzrnFjWxhVqoNBB9w1VG
         Vya/+rrTnOGV5gbvs6k+DxbKte2Z8Sqrz8Cv/c9sZG4M6WIjfl9/npgFNyZNo+QNanrn
         ic4Wtbi0CixXCT7zHsOINYLe31ZuOkx6GIrt8hYlOA6uNo7gHw+aq3KZrXYuaMbXqj3B
         vQ6Qb2iaIIhWgSAIbYu+MRU00hhpxWCfFA8WHGW46xQeDYwCT7/5uxe3AcvvZBaMFeYM
         0U/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P1Nbtrbxt6aWe7JQzpYNK9vcZ7WcZdvC5Z9Jfj4k9JE=;
        b=CCmBc6bUnJ/a6Clotsz90+DuOGEPa7+GdUD0JR7Yiqho+ecl2JAjRhnW3Z+2jzWG4w
         +6DvXQWTs2bDsXALdQlTiTcN8FGAbHSDGBnCq4Yn1PHDqRujhBxgQdpDo37NVfDjzSCy
         JxSJ2jA/INUdzI7D5UsMTYuMjA6zBjBqtFAcETtrqVIiHpIVhQkewXv2e+1ugHXZccHw
         p4YT0scn82mufR1AP2RzDBHFD8wk+pYA15tJR1a6T055ouD/UcdJ6h5f82h7e3JPoGA+
         Gbpmy7ylmzZv1Nqxxl8KGb3V7fat95gdYjMkgFkSyGKaQeNHf2UZrHHylemlqvt4MPTT
         ai7g==
X-Gm-Message-State: AOAM530igxZZt+Xyd+t8yafAeS+dA82oqfsjK8IgsmHAvo6dzNqbqSLr
        Dw+GGulpaGZoenerASWAUaIRxvD37iGFQMx2l7K5UzAH6xI=
X-Google-Smtp-Source: ABdhPJxB48v7tX227wTw05loDscBGJvfmjw0H8VDL17AJIh5JcRVt65RcYVp0DiqavGYw9UD2FRbxcIS2ldkX2sVXAc=
X-Received: by 2002:a25:9942:: with SMTP id n2mr34897297ybo.230.1625691649200;
 Wed, 07 Jul 2021 14:00:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210707194619.151676-1-jolsa@kernel.org> <YOYFZeY4U2wl/Ru5@krava>
In-Reply-To: <YOYFZeY4U2wl/Ru5@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Jul 2021 14:00:38 -0700
Message-ID: <CAEf4BzZgqOwN5N+pLPriWRmOFSgBd4vgO-S69L1mO51P82FRdA@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 0/7] bpf, x86: Add bpf_get_func_ip helper
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Alan Maguire <alan.maguire@oracle.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 1:42 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> ugh forgot to cc Masami.. sorry, I can resend if needed

Can you please also add v2, v3, etc tags to *each patch*, not just
cover letter? It makes tracking different versions much easier.
Thanks!

>
> jirka
>
> On Wed, Jul 07, 2021 at 09:46:12PM +0200, Jiri Olsa wrote:
> > hi,
> > adding bpf_get_func_ip helper that returns IP address of the
> > caller function for trampoline and krobe programs.
> >
> > There're 2 specific implementation of the bpf_get_func_ip
> > helper, one for trampoline progs and one for kprobe/kretprobe
> > progs.
> >
> > The trampoline helper call is replaced/inlined by verifier
> > with simple move instruction. The kprobe/kretprobe is actual
> > helper call that returns prepared caller address.
> >
> > Also available at:
> >   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> >   bpf/get_func_ip
> >
> > v2 changes:
> >   - use kprobe_running to get kprobe instead of cpu var [Masami]
> >   - added support to add kprobe on function+offset
> >     and test for that [Alan]
> >
> > thanks,
> > jirka
> >
> >
> > ---
> > Alan Maguire (1):
> >       libbpf: allow specification of "kprobe/function+offset"
> >
> > Jiri Olsa (6):
> >       bpf, x86: Store caller's ip in trampoline stack
> >       bpf: Enable BPF_TRAMP_F_IP_ARG for trampolines with call_get_func_ip
> >       bpf: Add bpf_get_func_ip helper for tracing programs
> >       bpf: Add bpf_get_func_ip helper for kprobe programs
> >       selftests/bpf: Add test for bpf_get_func_ip helper
> >       selftests/bpf: Add test for bpf_get_func_ip in kprobe+offset probe
> >
> >  arch/x86/net/bpf_jit_comp.c                               | 19 +++++++++++++++++++
> >  include/linux/bpf.h                                       |  5 +++++
> >  include/linux/filter.h                                    |  3 ++-
> >  include/uapi/linux/bpf.h                                  |  7 +++++++
> >  kernel/bpf/trampoline.c                                   | 12 +++++++++---
> >  kernel/bpf/verifier.c                                     | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  kernel/trace/bpf_trace.c                                  | 32 ++++++++++++++++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h                            |  7 +++++++
> >  tools/lib/bpf/libbpf.c                                    | 20 +++++++++++++++++---
> >  tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c | 42 ++++++++++++++++++++++++++++++++++++++++++
> >  tools/testing/selftests/bpf/progs/get_func_ip_test.c      | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  11 files changed, 270 insertions(+), 7 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/get_func_ip_test.c
>
