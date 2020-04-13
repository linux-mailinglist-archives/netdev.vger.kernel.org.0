Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE62B1A6ED3
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 00:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389408AbgDMWAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 18:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389399AbgDMWAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 18:00:39 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0F5C0A3BDC;
        Mon, 13 Apr 2020 15:00:38 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id b10so8508701qtt.9;
        Mon, 13 Apr 2020 15:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UIEmqvRccNX9Xn4YanQo5OFMeDcInQqI1cVt7r9dDSU=;
        b=qFp8SoSfJF7gnCk3EWi7SXHj3Aum0EZbHMKZPsLg5oR8ZX09L30t32VXkb6MalcS3I
         4poOp2Qb03NjGmjORJxhx4wX0Q9gRf8qfNQ5ZOJOOqyfIF6KdqcXgpTUWRnQuNfvk6Po
         f88Ycc8zMixS/3NPTRldP2T7Pgv+ud0oquojr+l3FbUpjj5e+Q/SDBI3t2MPQObxsFV6
         0gWu6I5Xo5IWmvKJN3AW3nFLIPdsFaNKSL5/GhMBUaY58UzHEUnygRLSsiEiw/3xCtuG
         O2uhzmenL5tmNPPvkXEkRekK671dUFanmZSOZw01VUhJS5y21vokmoZ575S2dzfOG1o8
         Zq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UIEmqvRccNX9Xn4YanQo5OFMeDcInQqI1cVt7r9dDSU=;
        b=qCtCJ2SfmbrRm/upmffgcqEVZ2XKKFVjGctyto5ifUn2D1Co6lD3+6hpt4kNxe1wtF
         kf2zAXHDALgcFds/iOimKuKJb6s1j+waHe52Yhzb/oMjHeOGNctYhJ+Ou+TaV18G8n/2
         gSFNta4IO8pspfmQCj5SyX3XuYSuA/sgGxTuE0pnPiVvsL78xNpLnAboVZ84/O131mf9
         O4c3mTiEXG3d27kRvy0b8WLvGVbRVhBKWUk70C1A0OESYRxyWcTxbXWFRDe/RZKqyzKD
         OJabkHFRqaG9bdodyQVI6K/A8DLUQHMu9hU1e/hN8hbsG1369j/bM7cyhRdlsy6t+Rmb
         82KA==
X-Gm-Message-State: AGi0Pub6hLOhlU1BHRgxR8vEdbYnyUvZvoIYWMsBNCBYh/zyAg1hMVZ/
        Ncf/Uo6eMHVc9OxoxiGlRt0Rr1h3llX8S845k9pSEEKqDfg=
X-Google-Smtp-Source: APiQypKekT2wxgnvGHyc1g9iqBBqwoUnBjJ6sNFx8CkF65T03XwJdyk8dZerRATecFDK2K1jIi083yWF1Z2wIwZYf8M=
X-Received: by 2002:ac8:468d:: with SMTP id g13mr13087986qto.59.1586815237399;
 Mon, 13 Apr 2020 15:00:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200412055837.2883320-1-andriin@fb.com> <20200413202126.GA36960@rdna-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200413202126.GA36960@rdna-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Apr 2020 15:00:26 -0700
Message-ID: <CAEf4Bzbf7kuzTnq6d=Jh+hRdUi++vxabZz2oQU=hPh52rztbgg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: always specify expected_attach_type on
 program load if supported
To:     Andrey Ignatov <rdna@fb.com>
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

On Mon, Apr 13, 2020 at 1:21 PM Andrey Ignatov <rdna@fb.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> [Sat, 2020-04-11 22:58 -0700]:
> > For some types of BPF programs that utilize expected_attach_type, libbpf won't
> > set load_attr.expected_attach_type, even if expected_attach_type is known from
> > section definition. This was done to preserve backwards compatibility with old
> > kernels that didn't recognize expected_attach_type attribute yet (which was
> > added in 5e43f899b03a ("bpf: Check attach type at prog load time"). But this
> > is problematic for some BPF programs that utilize never features that require
> > kernel to know specific expected_attach_type (e.g., extended set of return
> > codes for cgroup_skb/egress programs).
> >
> > This patch makes libbpf specify expected_attach_type by default, but also
> > detect support for this field in kernel and not set it during program load.
> > This allows to have a good metadata for bpf_program
> > (e.g., bpf_program__get_extected_attach_type()), but still work with old
> > kernels (for cases where it can work at all).
> >
> > Additionally, due to expected_attach_type being always set for recognized
> > program types, bpf_program__attach_cgroup doesn't have to do extra checks to
> > determine correct attach type, so remove that additional logic.
> >
> > Also adjust section_names selftest to account for this change.
> >
> > More detailed discussion can be found in [0].
> >
> >   [0] https://lore.kernel.org/bpf/20200412003604.GA15986@rdna-mbp.dhcp.thefacebook.com/
> >
> > Reported-by: Andrey Ignatov <rdna@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c                        | 123 +++++++++++-------
> >  .../selftests/bpf/prog_tests/section_names.c  |  42 +++---
> >  2 files changed, 106 insertions(+), 59 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index ff9174282a8c..925f720deea0 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -178,6 +178,8 @@ struct bpf_capabilities {
> >       __u32 array_mmap:1;
> >       /* BTF_FUNC_GLOBAL is supported */
> >       __u32 btf_func_global:1;
> > +     /* kernel support for expected_attach_type in BPF_PROG_LOAD */
> > +     __u32 exp_attach_type:1;
> >  };
> >
> >  enum reloc_type {
> > @@ -194,6 +196,22 @@ struct reloc_desc {
> >       int sym_off;
> >  };
> >
> > +struct bpf_sec_def;
> > +
> > +typedef struct bpf_link *(*attach_fn_t)(const struct bpf_sec_def *sec,
> > +                                     struct bpf_program *prog);
> > +
> > +struct bpf_sec_def {
> > +     const char *sec;
> > +     size_t len;
> > +     enum bpf_prog_type prog_type;
> > +     enum bpf_attach_type expected_attach_type;
> > +     bool is_exp_attach_type_optional;
> > +     bool is_attachable;
> > +     bool is_attach_btf;
> > +     attach_fn_t attach_fn;
> > +};
> > +
> >  /*
> >   * bpf_prog should be a better name but it has been used in
> >   * linux/filter.h.
> > @@ -204,6 +222,7 @@ struct bpf_program {
> >       char *name;
> >       int prog_ifindex;
> >       char *section_name;
> > +     const struct bpf_sec_def *sec_def;
> >       /* section_name with / replaced by _; makes recursive pinning
> >        * in bpf_object__pin_programs easier
> >        */
> > @@ -3315,6 +3334,32 @@ static int bpf_object__probe_array_mmap(struct bpf_object *obj)
> >       return 0;
> >  }
> >
> > +static int
> > +bpf_object__probe_exp_attach_type(struct bpf_object *obj)
> > +{
> > +     struct bpf_load_program_attr attr;
> > +     struct bpf_insn insns[] = {
> > +             BPF_MOV64_IMM(BPF_REG_0, 0),
> > +             BPF_EXIT_INSN(),
> > +     };
> > +     int fd;
> > +
> > +     memset(&attr, 0, sizeof(attr));
> > +     attr.prog_type = BPF_PROG_TYPE_CGROUP_SOCK;
> > +     attr.expected_attach_type = BPF_CGROUP_INET_EGRESS;
>
> Could you clarify semantics of this function please?
>
> According to the name it looks like it should check whether
> expected_attach_type attribute is supported or not. But
> BPF_CGROUP_INET_EGRESS doesn't align with this since
> expected_attach_type itself was added long before it was supported for
> BPF_CGROUP_INET_EGRESS.
>
> For example 4fbac77d2d09 ("bpf: Hooks for sys_bind") added in Mar 2018 is
> the first hook ever that used expected_attach_type.
>
> aac3fc320d94 ("bpf: Post-hooks for sys_bind") added a bit later is the
> first hook that made expected_attach_type optional (for
> BPF_CGROUP_INET_SOCK_CREATE).
>
> But 5cf1e9145630 ("bpf: cgroup inet skb programs can return 0 to 3") for
> BPF_CGROUP_INET_EGRESS was merged more than a year after the previous
> two.

I'm checking if kernel is rejecting non-zero expected_attach_type
field in bpf_attr for BPF_PROG_LOAD command.

Before 5e43f899b03a ("bpf: Check attach type at prog load time"),
kernel would reject non-zero expected_attach_type because
expected_attach_type didn't exist in bpf_attr. So if that's the case,
we shouldn't specify expected_attach_type.

After that commit, BPF_CGROUP_INET_EGRESS for
BPF_PROG_TYPE_CGROUP_SOCK would be supported, even if it is optional,
so using that combination should work.

Did I miss something?

>
> > +     attr.insns = insns;
> > +     attr.insns_cnt = ARRAY_SIZE(insns);
> > +     attr.license = "GPL";
> > +
> > +     fd = bpf_load_program_xattr(&attr, NULL, 0);
> > +     if (fd >= 0) {
> > +             obj->caps.exp_attach_type = 1;
> > +             close(fd);
> > +             return 1;
> > +     }
> > +     return 0;
> > +}
> > +
> >  static int
> >  bpf_object__probe_caps(struct bpf_object *obj)
> >  {
> > @@ -3325,6 +3370,7 @@ bpf_object__probe_caps(struct bpf_object *obj)
> >               bpf_object__probe_btf_func_global,
> >               bpf_object__probe_btf_datasec,
> >               bpf_object__probe_array_mmap,
> > +             bpf_object__probe_exp_attach_type,
> >       };
> >       int i, ret;
> >
> > @@ -4861,7 +4907,13 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
> >
> >       memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
> >       load_attr.prog_type = prog->type;
> > -     load_attr.expected_attach_type = prog->expected_attach_type;
> > +     /* old kernels might not support specifying expected_attach_type */
> > +     if (!prog->caps->exp_attach_type && prog->sec_def &&
> > +         prog->sec_def->is_exp_attach_type_optional)
> > +             load_attr.expected_attach_type = 0;
> > +     else
> > +             load_attr.expected_attach_type = prog->expected_attach_type;
>
> I'm having a hard time checking whether it'll work for all cases or may
> not work for some combination of prog/attach type and kernel version
> since there are many subtleties.
>
> For example BPF_PROG_TYPE_CGROUP_SOCK has both a hook where
> expected_attach_type is optional (BPF_CGROUP_INET_SOCK_CREATE) and hooks
> where it's required (BPF_CGROUP_INET{4,6}_POST_BIND), and there
> bpf_prog_load_fixup_attach_type() function in always sets
> expected_attach_type if it's not yet.

Right, so we use the fact that they are allowed, even if optional.
Libbpf should provide correct expected_attach_type, according to
section definitions and kernel should be happy (unless user specified
wrong section name, of course, but we can't help that).

>
> But I don't have context on all hooks that can be affected by this
> change and could easily miss something.
>
> Ideally it should be verified by tests. Current section_names.c test
> only verifies what will be returned, but AFAIK there is no test that
> checks whether provided combination of prog_type/expected_attach_type at
> load time and attach_type at attach time would actually work both on
> current and old kernels. Do you think it's possible to add such a
> selftest? (current libbpf CI supports running on old kernels, doesn't
> it?)

So all the existing selftests are essentially verifying this, if run
on old kernel. I don't think libbpf currently runs tests on such old
kernels, though. But there is no extra selftest that we need to add,
because every single existing one will execute this piece of libbpf
logic.

>
>
> > +     pr_warn("prog %s exp_Attach %d\n", prog->name, load_attr.expected_attach_type);
> >       if (prog->caps->name)
> >               load_attr.name = prog->name;
> >       load_attr.insns = insns;
> > @@ -5062,6 +5114,8 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
> >       return 0;
> >  }
> >

trimming irrelevant parts is good ;)

[...]
