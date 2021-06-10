Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE363A31B3
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhFJRIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:08:48 -0400
Received: from mail-yb1-f175.google.com ([209.85.219.175]:34522 "EHLO
        mail-yb1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhFJRIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:08:47 -0400
Received: by mail-yb1-f175.google.com with SMTP id i6so345497ybm.1;
        Thu, 10 Jun 2021 10:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=twqTpD3lMY3xa6wp83J+FTRxJuth7SRGMzQZ8YjPS+k=;
        b=ZnVzxV6rqbOxZ9w2xLImC4kz9hliKxWX0X5z45yhW7atdJG3mv8s5DtdxCWLh4Kih8
         pL4z+rMuslpddlYfMc5AtuJsOfTAyOZVvXc+DppVRPD/HL1Lkum65YSQ576JZsZS7Wwj
         9ByxviTMj7QdPaLPG0vFfFARYclvSNiz+GlnHgbuDHGni1/H+MpbHeHr9PgK/pDer+SZ
         YfJGheB53/rHQHtBJtrSJ03HnUFlZ9P42llr3/eO/H2Vj/aJAP9gv5u5Ith1e1qT8KS9
         wCcgYukjGCh0L7mNwHaflSpCLwKdl6XLVFzSf6yagFhw7wAeN/StilbDkal2N7HwVnus
         3Nxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=twqTpD3lMY3xa6wp83J+FTRxJuth7SRGMzQZ8YjPS+k=;
        b=l8nGvqvMCFV91iYb2NZElWlOxnWGJEqqRWRJ4aTMIsOK220CEqXBavhQwDmta4S95P
         PVi+L7yjnG2qomf+RylBELftTDOdpl/3vqaGiafP9PcDDfs5MU2hb4emIYTAJ5AJHP+x
         dQEzwt5h4HLa50jZ9aKnPrh7g2GQUPoO2h9P0idVvB6dzXDCZsYy63LlyqWPWEmMEjta
         NPAGQmrC9l4ec5PtOktVrcQdTOsy+Sdr26/pWEV68yaDryusjgAwB3KJflNZtL6hbYwk
         r9jUMzxJnsVyt6Gtnu7ITLkMAuiD+epc5AsJMHI7H1CxNni5tTVH21N6GQyrcybz0P6T
         TjnQ==
X-Gm-Message-State: AOAM531/Zb3pP8QFfL0E3KtiavEHlocxDGi41+LN4L6Mi92KJoAbtee7
        A5GgeU3WzKAB6sa/5WTOng8R1MsLiTpBkHNi8/M=
X-Google-Smtp-Source: ABdhPJyikvS19vhbZ63jUAw5GKLps6InxLiLWlKWlGQu4eciGlJEDACQvqSdRH5CBAoasYKmIck+4qd0PG4MzSE86A4=
X-Received: by 2002:a25:4182:: with SMTP id o124mr8792722yba.27.1623344750476;
 Thu, 10 Jun 2021 10:05:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210605111034.1810858-1-jolsa@kernel.org> <20210605111034.1810858-16-jolsa@kernel.org>
 <CAEf4BzaCWG1WtkQA6gZGvvGUhk3Si9jkZ2s6ToWowKhU4cXMuw@mail.gmail.com> <YMDNeve5/TColRcq@krava>
In-Reply-To: <YMDNeve5/TColRcq@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Jun 2021 10:05:39 -0700
Message-ID: <CAEf4Bzb-_SJpubQ4oiO4chGG8+EMUGbnChAC9tUB3FftRJzceA@mail.gmail.com>
Subject: Re: [PATCH 15/19] libbpf: Add support to link multi func tracing program
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 7:17 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Jun 08, 2021 at 10:34:11PM -0700, Andrii Nakryiko wrote:
> > On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Adding support to link multi func tracing program
> > > through link_create interface.
> > >
> > > Adding special types for multi func programs:
> > >
> > >   fentry.multi
> > >   fexit.multi
> > >
> > > so you can define multi func programs like:
> > >
> > >   SEC("fentry.multi/bpf_fentry_test*")
> > >   int BPF_PROG(test1, unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
> > >
> > > that defines test1 to be attached to bpf_fentry_test* functions,
> > > and able to attach ip and 6 arguments.
> > >
> > > If functions are not specified the program needs to be attached
> > > manually.
> > >
> > > Adding new btf id related fields to bpf_link_create_opts and
> > > bpf_link_create to use them.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  tools/lib/bpf/bpf.c    | 11 ++++++-
> > >  tools/lib/bpf/bpf.h    |  4 ++-
> > >  tools/lib/bpf/libbpf.c | 72 ++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 85 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > > index 86dcac44f32f..da892737b522 100644
> > > --- a/tools/lib/bpf/bpf.c
> > > +++ b/tools/lib/bpf/bpf.c
> > > @@ -674,7 +674,8 @@ int bpf_link_create(int prog_fd, int target_fd,
> > >                     enum bpf_attach_type attach_type,
> > >                     const struct bpf_link_create_opts *opts)
> > >  {
> > > -       __u32 target_btf_id, iter_info_len;
> > > +       __u32 target_btf_id, iter_info_len, multi_btf_ids_cnt;
> > > +       __s32 *multi_btf_ids;
> > >         union bpf_attr attr;
> > >         int fd;
> > >
> > > @@ -687,6 +688,9 @@ int bpf_link_create(int prog_fd, int target_fd,
> > >         if (iter_info_len && target_btf_id)
> >
> > here we check that mutually exclusive options are not specified, we
> > should do the same for multi stuff
>
> right, ok
>
> >
> > >                 return libbpf_err(-EINVAL);
> > >
> > > +       multi_btf_ids = OPTS_GET(opts, multi_btf_ids, 0);
> > > +       multi_btf_ids_cnt = OPTS_GET(opts, multi_btf_ids_cnt, 0);
> > > +
> > >         memset(&attr, 0, sizeof(attr));
> > >         attr.link_create.prog_fd = prog_fd;
> > >         attr.link_create.target_fd = target_fd;
> > > @@ -701,6 +705,11 @@ int bpf_link_create(int prog_fd, int target_fd,
> > >                 attr.link_create.target_btf_id = target_btf_id;
> > >         }
> > >
> > > +       if (multi_btf_ids && multi_btf_ids_cnt) {
> > > +               attr.link_create.multi_btf_ids = (__u64) multi_btf_ids;
> > > +               attr.link_create.multi_btf_ids_cnt = multi_btf_ids_cnt;
> > > +       }
> > > +
> > >         fd = sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
> > >         return libbpf_err_errno(fd);
> > >  }
> > > diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> > > index 4f758f8f50cd..2f78b6c34765 100644
> > > --- a/tools/lib/bpf/bpf.h
> > > +++ b/tools/lib/bpf/bpf.h
> > > @@ -177,8 +177,10 @@ struct bpf_link_create_opts {
> > >         union bpf_iter_link_info *iter_info;
> > >         __u32 iter_info_len;
> > >         __u32 target_btf_id;
> > > +       __s32 *multi_btf_ids;
> >
> > why ids are __s32?..
>
> hum not sure why I did that.. __u32 then
>
> >
> > > +       __u32 multi_btf_ids_cnt;
> > >  };
> > > -#define bpf_link_create_opts__last_field target_btf_id
> > > +#define bpf_link_create_opts__last_field multi_btf_ids_cnt
> > >
> > >  LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
> > >                                enum bpf_attach_type attach_type,
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 65f87cc1220c..bd31de3b6a85 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -228,6 +228,7 @@ struct bpf_sec_def {
> > >         bool is_attachable;
> > >         bool is_attach_btf;
> > >         bool is_sleepable;
> > > +       bool is_multi_func;
> > >         attach_fn_t attach_fn;
> > >  };
> > >
> > > @@ -7609,6 +7610,8 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
> > >
> > >                 if (prog->sec_def->is_sleepable)
> > >                         prog->prog_flags |= BPF_F_SLEEPABLE;
> > > +               if (prog->sec_def->is_multi_func)
> > > +                       prog->prog_flags |= BPF_F_MULTI_FUNC;
> > >                 bpf_program__set_type(prog, prog->sec_def->prog_type);
> > >                 bpf_program__set_expected_attach_type(prog,
> > >                                 prog->sec_def->expected_attach_type);
> > > @@ -9070,6 +9073,8 @@ static struct bpf_link *attach_raw_tp(const struct bpf_sec_def *sec,
> > >                                       struct bpf_program *prog);
> > >  static struct bpf_link *attach_trace(const struct bpf_sec_def *sec,
> > >                                      struct bpf_program *prog);
> > > +static struct bpf_link *attach_trace_multi(const struct bpf_sec_def *sec,
> > > +                                          struct bpf_program *prog);
> > >  static struct bpf_link *attach_lsm(const struct bpf_sec_def *sec,
> > >                                    struct bpf_program *prog);
> > >  static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
> > > @@ -9143,6 +9148,14 @@ static const struct bpf_sec_def section_defs[] = {
> > >                 .attach_fn = attach_iter),
> > >         SEC_DEF("syscall", SYSCALL,
> > >                 .is_sleepable = true),
> > > +       SEC_DEF("fentry.multi/", TRACING,
> > > +               .expected_attach_type = BPF_TRACE_FENTRY,
> >
> > BPF_TRACE_MULTI_FENTRY instead of is_multi stuff everywhere?.. Or a
> > new type of BPF program altogether?
> >
> > > +               .is_multi_func = true,
> > > +               .attach_fn = attach_trace_multi),
> > > +       SEC_DEF("fexit.multi/", TRACING,
> > > +               .expected_attach_type = BPF_TRACE_FEXIT,
> > > +               .is_multi_func = true,
> > > +               .attach_fn = attach_trace_multi),
> > >         BPF_EAPROG_SEC("xdp_devmap/",           BPF_PROG_TYPE_XDP,
> > >                                                 BPF_XDP_DEVMAP),
> > >         BPF_EAPROG_SEC("xdp_cpumap/",           BPF_PROG_TYPE_XDP,
> > > @@ -9584,6 +9597,9 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd,
> > >         if (!name)
> > >                 return -EINVAL;
> > >
> > > +       if (prog->prog_flags & BPF_F_MULTI_FUNC)
> > > +               return 0;
> > > +
> > >         for (i = 0; i < ARRAY_SIZE(section_defs); i++) {
> > >                 if (!section_defs[i].is_attach_btf)
> > >                         continue;
> > > @@ -10537,6 +10553,62 @@ static struct bpf_link *bpf_program__attach_btf_id(struct bpf_program *prog)
> > >         return (struct bpf_link *)link;
> > >  }
> > >
> > > +static struct bpf_link *bpf_program__attach_multi(struct bpf_program *prog)
> > > +{
> > > +       char *pattern = prog->sec_name + prog->sec_def->len;
> > > +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> > > +       enum bpf_attach_type attach_type;
> > > +       int prog_fd, link_fd, cnt, err;
> > > +       struct bpf_link *link = NULL;
> > > +       __s32 *ids = NULL;
> > > +
> > > +       prog_fd = bpf_program__fd(prog);
> > > +       if (prog_fd < 0) {
> > > +               pr_warn("prog '%s': can't attach before loaded\n", prog->name);
> > > +               return ERR_PTR(-EINVAL);
> > > +       }
> > > +
> > > +       err = bpf_object__load_vmlinux_btf(prog->obj, true);
> > > +       if (err)
> > > +               return ERR_PTR(err);
> > > +
> > > +       cnt = btf__find_by_pattern_kind(prog->obj->btf_vmlinux, pattern,
> > > +                                       BTF_KIND_FUNC, &ids);
> >
> > I wonder if it would be better to just support a simplified glob
> > patterns like "prefix*", "*suffix", "exactmatch", and "*substring*"?
> > That should be sufficient for majority of cases. For the cases where
> > user needs something more nuanced, they can just construct BTF ID list
> > with custom code and do manual attach.
>
> as I wrote earlier the function is just for the purpose of the test,
> and we can always do the manual attach
>
> I don't mind adding that simplified matching you described

I use that in retsnoop and that seems to be simple but flexible enough
for all the purposes, so far. It matches typical file globbing rules
(with extra limitations, of course), so it's also intuitive.

But I still am not sure about making it a public API, because in a lot
of cases you'll want a list of patterns (both allowing and denying
different patterns), so it should be generalized to something like

btf__find_by_glob_kind(btf, allow_patterns, deny_patterns, ids)

which gets pretty unwieldy. I'd start with telling users to just
iterate BTF on their own and apply whatever custom filtering they
need. For simple cases libbpf will just initially support a simple and
single glob filter declaratively (e.g, SEC("fentry.multi/bpf_*")).


>
> jirka
>
> >
> > > +       if (cnt <= 0)
> > > +               return ERR_PTR(-EINVAL);
> > > +
> > > +       link = calloc(1, sizeof(*link));
> > > +       if (!link) {
> > > +               err = -ENOMEM;
> > > +               goto out_err;
> > > +       }
> > > +       link->detach = &bpf_link__detach_fd;
> > > +
> > > +       opts.multi_btf_ids = ids;
> > > +       opts.multi_btf_ids_cnt = cnt;
> > > +
> > > +       attach_type = bpf_program__get_expected_attach_type(prog);
> > > +       link_fd = bpf_link_create(prog_fd, 0, attach_type, &opts);
> > > +       if (link_fd < 0) {
> > > +               err = -errno;
> > > +               goto out_err;
> > > +       }
> > > +       link->fd = link_fd;
> > > +       free(ids);
> > > +       return link;
> > > +
> > > +out_err:
> > > +       free(link);
> > > +       free(ids);
> > > +       return ERR_PTR(err);
> > > +}
> > > +
> > > +static struct bpf_link *attach_trace_multi(const struct bpf_sec_def *sec,
> > > +                                          struct bpf_program *prog)
> > > +{
> > > +       return bpf_program__attach_multi(prog);
> > > +}
> > > +
> > >  struct bpf_link *bpf_program__attach_trace(struct bpf_program *prog)
> > >  {
> > >         return bpf_program__attach_btf_id(prog);
> > > --
> > > 2.31.1
> > >
> >
>
