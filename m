Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1365F54552F
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 21:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbiFIT5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 15:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbiFIT5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 15:57:16 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BAE2250E
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 12:57:13 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id o43so169871qvo.4
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 12:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vzHrKikFkmIF6ny/D7XTKKS8xCl2YNNNxtNZO+KQjGQ=;
        b=R9wurIPmzd3tUzlgX9+jDxuTVPWAVRkS2yilHiuK1HmEH862vfYY19+bi9uZEmJQmd
         GCIFM3FSA9ozamXkrJC7crinnjbhnQaMS08BDCNejqyyusK5bHvokW0uSvnl6kF1lViF
         KM6E/svUOYpgKbRcUoIegfC3hQlXVMpXdhSFgr6mHzAOyxSgRtK/Vjlxw8fq++u4lGjZ
         Olcu7oVJ+2X1w7XC1tSQvTTkDrafvvHD40f25JlO8gIrMOcDNUuKMB8BAUKZRz462gRP
         U7HKiUKzBM/Uo7vefVOE34DXpMxwWpdsq9NIGYD3LfKuFR/4DWCYqhS7J8a0unRJgz+i
         ctOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vzHrKikFkmIF6ny/D7XTKKS8xCl2YNNNxtNZO+KQjGQ=;
        b=F1wy+tC5nkjPOvvS/SUXhDH+lITEDxrkFIUWzdp9xLiWf2OoB0luJa7U76uBBRC/6F
         VrTbaFuDYSTNL0ZSfYeRNz7f6wv4hO+uYulXgz82qoH5biNW5gmVirUAB8Hx6fYaGSOl
         DoYvjwOp70K4SZayvEJgCwWcFWMmVi5dP1v+o/tvSISpcQcreCbFKxkl8EwDXd+rDZgm
         JDg+fTze3uHajSMo0wVr5I7o/fE5qJ0nGR3MeAz0IV2P9YF5gpTK2Y0xTOeOj+xcUfO2
         rOfrwXtUUDDrLNO5n3f1t+FZ8Ttpc0j47OCUV2QVKNpQKn4maNnjrp8bcAf3K+FWhJ4c
         RZ9g==
X-Gm-Message-State: AOAM530QUtrljzQd9FTbXrxDmf8rx0SvKIQi2lILZMoV5y5AhYI57nt1
        ZgHRfuOn+4vOwHXtQWQVfAeGlpfTH8z8JSAjkUWVaQ==
X-Google-Smtp-Source: ABdhPJyAI1LzFdVJ0qepulozvV5tqrC3ccR52VhZMBEyYQAqmbjBKFn8zKC+QL1qc9ceZkrzENPjhxh7XY3rzTdXOuc=
X-Received: by 2002:ad4:5ba4:0:b0:46d:8787:c902 with SMTP id
 4-20020ad45ba4000000b0046d8787c902mr3710290qvq.107.1654804632692; Thu, 09 Jun
 2022 12:57:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220609143614.97837-1-quentin@isovalent.com> <YqI4XrKeQkENT/+w@google.com>
 <CAEf4BzZYWGKA7S_1jWcGcNyPmrDJeGo8YfKXpmboRdDSeEmOZw@mail.gmail.com>
In-Reply-To: <CAEf4BzZYWGKA7S_1jWcGcNyPmrDJeGo8YfKXpmboRdDSeEmOZw@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Thu, 9 Jun 2022 20:57:01 +0100
Message-ID: <CACdoK4J0uJkWVavK3__FkfWBQoBWj4YpBK_+bkxz3vSPK5ztPA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Improve probing for memcg-based memory accounting
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Harsh Modi <harshmodi@google.com>,
        Paul Chaignon <paul@cilium.io>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Jun 2022 at 19:38, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jun 9, 2022 at 11:13 AM <sdf@google.com> wrote:
> >
> > On 06/09, Quentin Monnet wrote:
> > > To ensure that memory accounting will not hinder the load of BPF
> > > objects, libbpf may raise the memlock rlimit before proceeding to some
> > > operations. Whether this limit needs to be raised depends on the version
> > > of the kernel: newer versions use cgroup-based (memcg) memory
> > > accounting, and do not require any adjustment.
> >
> > > There is a probe in libbpf to determine whether memcg-based accounting
> > > is supported. But this probe currently relies on the availability of a
> > > given BPF helper, bpf_ktime_get_coarse_ns(), which landed in the same
> > > kernel version as the memory accounting change. This works in the
> > > generic case, but it may fail, for example, if the helper function has
> > > been backported to an older kernel. This has been observed for Google
> > > Cloud's Container-Optimized OS (COS), where the helper is available but
> > > rlimit is still in use. The probe succeeds, the rlimit is not raised,
> > > and probing features with bpftool, for example, fails.
> >
> > > Here we attempt to improve this probe and to effectively rely on memory
> > > accounting. Function probe_memcg_account() in libbpf is updated to set
> > > the rlimit to 0, then attempt to load a BPF object, and then to reset
> > > the rlimit. If the load still succeeds, then this means we're running
> > > with memcg-based accounting.
> >
> > > This probe was inspired by the similar one from the cilium/ebpf Go
> > > library [0].
> >
> > > [0] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39
> >
> > > Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> > > ---
> > >   tools/lib/bpf/bpf.c | 23 ++++++++++++++++++-----
> > >   1 file changed, 18 insertions(+), 5 deletions(-)
> >
> > > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > > index 240186aac8e6..781387e6f66b 100644
> > > --- a/tools/lib/bpf/bpf.c
> > > +++ b/tools/lib/bpf/bpf.c
> > > @@ -99,31 +99,44 @@ static inline int sys_bpf_prog_load(union bpf_attr
> > > *attr, unsigned int size, int
> >
> > >   /* Probe whether kernel switched from memlock-based (RLIMIT_MEMLOCK) to
> > >    * memcg-based memory accounting for BPF maps and progs. This was done
> > > in [0].
> > > - * We use the support for bpf_ktime_get_coarse_ns() helper, which was
> > > added in
> > > - * the same 5.11 Linux release ([1]), to detect memcg-based accounting
> > > for BPF.
> > > + * To do so, we lower the soft memlock rlimit to 0 and attempt to create
> > > a BPF
> > > + * object. If it succeeds, then memcg-based accounting for BPF is
> > > available.
> > >    *
> > >    *   [0]
> > > https://lore.kernel.org/bpf/20201201215900.3569844-1-guro@fb.com/
> > > - *   [1] d05512618056 ("bpf: Add bpf_ktime_get_coarse_ns helper")
> > >    */
> > >   int probe_memcg_account(void)
> > >   {
> > >       const size_t prog_load_attr_sz = offsetofend(union bpf_attr,
> > > attach_btf_obj_fd);
> > >       struct bpf_insn insns[] = {
> > > -             BPF_EMIT_CALL(BPF_FUNC_ktime_get_coarse_ns),
> > >               BPF_EXIT_INSN(),
> > >       };
> > > +     struct rlimit rlim_init, rlim_cur_zero = {};
> > >       size_t insn_cnt = ARRAY_SIZE(insns);
> > >       union bpf_attr attr;
> > >       int prog_fd;
> >
> > > -     /* attempt loading freplace trying to use custom BTF */
> > >       memset(&attr, 0, prog_load_attr_sz);
> > >       attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
> > >       attr.insns = ptr_to_u64(insns);
> > >       attr.insn_cnt = insn_cnt;
> > >       attr.license = ptr_to_u64("GPL");
> >
> > > +     if (getrlimit(RLIMIT_MEMLOCK, &rlim_init))
> > > +             return -1;
> > > +
> > > +     /* Drop the soft limit to zero. We maintain the hard limit to its
> > > +      * current value, because lowering it would be a permanent operation
> > > +      * for unprivileged users.
> > > +      */
> > > +     rlim_cur_zero.rlim_max = rlim_init.rlim_max;
> > > +     if (setrlimit(RLIMIT_MEMLOCK, &rlim_cur_zero))
> > > +             return -1;
> > > +
> > >       prog_fd = sys_bpf_fd(BPF_PROG_LOAD, &attr, prog_load_attr_sz);
> > > +
> > > +     /* reset soft rlimit as soon as possible */
> > > +     setrlimit(RLIMIT_MEMLOCK, &rlim_init);
> >
> > Isn't that adding more flakiness to the other daemons running as
> > the same user? Also, there might be surprises if another daemon that
> > has libbpf in it starts right when we've set the limit temporarily to zero.
> >
>
> I agree, it briefly changes global process state and can introduce
> some undesirable (and very non-obvious) side effects.
>
> > Can we push these decisions to the users as part of libbpf 1.0 cleanup?
>
>
> Quentin, at least for bpftool, I think it's totally fine to just
> always bump RLIMIT_MEMLOCK to avoid this issue. That would solve the
> issue with probing, right? And for end applications I think I agree
> with Stanislav that application might need to ensure rlimit bumping
> for such backported changes.

Agreed, changing the rlimit in the probe is not ideal. We haven't
managed to find a better way to probe the feature, unfortunately. I
don't mind restoring the rlimit bump in bpftool - yes, it should be
fine for our use case. We already raise the limit in Cilium, but after
the feature probe from bpftool, so it's only the feature probing that
is an issue at the moment. I'll send a patch for it tomorrow.

I still believe it would be nice to improve the probe, I'll come back
to it if we ever find a better way to proceed.

Thanks,
Quentin
