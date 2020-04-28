Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D8F1BC525
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 18:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgD1Q1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 12:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728037AbgD1Q1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 12:27:33 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696D6C03C1AB;
        Tue, 28 Apr 2020 09:27:33 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id w6so21031798ilg.1;
        Tue, 28 Apr 2020 09:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=na2CronQlPXMGJSe8oAgvCWNyPqAvvAm9Hmg5f4CQbM=;
        b=FNyzcHU+pPBHzPuSCHbxBVI4zYphGVv4rGdb+YjyXhoVU1w3dbLeF1Nca7bDB9pKE4
         RMZQRKa+fbM4oNDkaDW+NFNP+LnFckaG9C3mlAlK9ax3YDtxA22HsYOrSGHufmpnqIak
         iLpCttTYg3jeHnEEOtGF+TDMefL6Mhee2OzOjthNCG4Rnuh2UiJyas/8sxHwDoai2ao3
         U1z9E4/KXjgYAH5Oc/f3h+D2HeFyEaNtSH8aNNYwjmwt/asem/U8RDlfQhIwCvD/DbiW
         PqplS37VQoSoC7axDwmx2bjf6HRHK26QgTMPerbIBXUbOvv3pPJjkynBpMhE/9oYHivI
         Zp3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=na2CronQlPXMGJSe8oAgvCWNyPqAvvAm9Hmg5f4CQbM=;
        b=KXUfcfKwIOB3Di9RMWXlmeNXZCmtCbT1S32MowFXRFan1v4pTdC9Fp5jrxfIu8l8NQ
         WAiAiEIxzvfrvB6mDft/ieeOEK/tNFz/czAp5THo5eOuife27GJrxwgFdTWQwNcDDhEP
         pUCNd8P38MyMrzjNUIGKE1OXZhacfXA5usCq6Rwc8PHtMJ7P45WFvSqHTfPPDdXzz48E
         aZ3EoFw3eG5HjlNDjBWIJS+dUblPGp0/lzJsQaGDOWYz4AbDmka2zWC1wmsA3QwaarEZ
         k09l5Yt+uXfi+2t5zswcCpp488DFIuJJsCbVFPtax85cCqibaAuFg6johVpW3uMK3U/X
         r2ag==
X-Gm-Message-State: AGi0PubHU/OYstHCTg5WmAPGqpC8UbaA8utNY3PW2k1ZRVyHxnUrA1L5
        X7yWKJuyUsHjRcitZFtbQ8E3OATgul6DOXLj4bw=
X-Google-Smtp-Source: APiQypJ0x5UbKLCbWSzH1iS9N/cRQVywcbW6Z/3yOROc+2EvaAhDC+NU7QQURHfY7AUtzE/hZlPHIf0q1TmzF2m7y6g=
X-Received: by 2002:a92:4989:: with SMTP id k9mr10719101ilg.104.1588091252551;
 Tue, 28 Apr 2020 09:27:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200428054944.4015462-1-andriin@fb.com> <20200428054944.4015462-5-andriin@fb.com>
 <87mu6wvt6t.fsf@toke.dk>
In-Reply-To: <87mu6wvt6t.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Apr 2020 09:27:21 -0700
Message-ID: <CAEf4BzabqYMRDzn0ztHQithWJ56o_CWZCWotnkyhJ6D7nuNG1Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 04/10] bpf: add support for
 BPF_OBJ_GET_INFO_BY_FD for bpf_link
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 2:46 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > Add ability to fetch bpf_link details through BPF_OBJ_GET_INFO_BY_FD co=
mmand.
> > Also enhance show_fdinfo to potentially include bpf_link type-specific
> > information (similarly to obj_info).
> >
> > Also introduce enum bpf_link_type stored in bpf_link itself and expose =
it in
> > UAPI. bpf_link_tracing also now will store and return bpf_attach_type.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  include/linux/bpf-cgroup.h     |   2 -
> >  include/linux/bpf.h            |  10 +-
> >  include/linux/bpf_types.h      |   6 ++
> >  include/uapi/linux/bpf.h       |  28 ++++++
> >  kernel/bpf/btf.c               |   2 +
> >  kernel/bpf/cgroup.c            |  45 ++++++++-
> >  kernel/bpf/syscall.c           | 164 +++++++++++++++++++++++++++++----
> >  kernel/bpf/verifier.c          |   2 +
> >  tools/include/uapi/linux/bpf.h |  31 +++++++
> >  9 files changed, 266 insertions(+), 24 deletions(-)
> >
> > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> > index d2d969669564..ab95824a1d99 100644
> > --- a/include/linux/bpf-cgroup.h
> > +++ b/include/linux/bpf-cgroup.h
> > @@ -57,8 +57,6 @@ struct bpf_cgroup_link {
> >       enum bpf_attach_type type;
> >  };
> >
> > -extern const struct bpf_link_ops bpf_cgroup_link_lops;
> > -
> >  struct bpf_prog_list {
> >       struct list_head node;
> >       struct bpf_prog *prog;
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 875d1f0af803..701c4387c711 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1026,9 +1026,11 @@ extern const struct file_operations bpf_prog_fop=
s;
> >       extern const struct bpf_verifier_ops _name ## _verifier_ops;
> >  #define BPF_MAP_TYPE(_id, _ops) \
> >       extern const struct bpf_map_ops _ops;
> > +#define BPF_LINK_TYPE(_id, _name)
> >  #include <linux/bpf_types.h>
> >  #undef BPF_PROG_TYPE
> >  #undef BPF_MAP_TYPE
> > +#undef BPF_LINK_TYPE
> >
> >  extern const struct bpf_prog_ops bpf_offload_prog_ops;
> >  extern const struct bpf_verifier_ops tc_cls_act_analyzer_ops;
> > @@ -1086,6 +1088,7 @@ int bpf_prog_new_fd(struct bpf_prog *prog);
> >  struct bpf_link {
> >       atomic64_t refcnt;
> >       u32 id;
> > +     enum bpf_link_type type;
> >       const struct bpf_link_ops *ops;
> >       struct bpf_prog *prog;
> >       struct work_struct work;
> > @@ -1103,9 +1106,14 @@ struct bpf_link_ops {
> >       void (*dealloc)(struct bpf_link *link);
> >       int (*update_prog)(struct bpf_link *link, struct bpf_prog *new_pr=
og,
> >                          struct bpf_prog *old_prog);
> > +     void (*show_fdinfo)(const struct bpf_link *link, struct seq_file =
*seq);
> > +     int (*fill_link_info)(const struct bpf_link *link,
> > +                           struct bpf_link_info *info,
> > +                           const struct bpf_link_info *uinfo,
> > +                           u32 info_len);
> >  };
> >
> > -void bpf_link_init(struct bpf_link *link,
> > +void bpf_link_init(struct bpf_link *link, enum bpf_link_type type,
> >                  const struct bpf_link_ops *ops, struct bpf_prog *prog)=
;
> >  int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *prim=
er);
> >  int bpf_link_settle(struct bpf_link_primer *primer);
> > diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> > index ba0c2d56f8a3..8345cdf553b8 100644
> > --- a/include/linux/bpf_types.h
> > +++ b/include/linux/bpf_types.h
> > @@ -118,3 +118,9 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
> >  #if defined(CONFIG_BPF_JIT)
> >  BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
> >  #endif
> > +
> > +BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
> > +BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
> > +#ifdef CONFIG_CGROUP_BPF
> > +BPF_LINK_TYPE(BPF_LINK_TYPE_CGROUP, cgroup)
> > +#endif
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 7e6541fceade..0eccafae55bb 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -222,6 +222,15 @@ enum bpf_attach_type {
> >
> >  #define MAX_BPF_ATTACH_TYPE __MAX_BPF_ATTACH_TYPE
> >
> > +enum bpf_link_type {
> > +     BPF_LINK_TYPE_UNSPEC =3D 0,
> > +     BPF_LINK_TYPE_RAW_TRACEPOINT =3D 1,
> > +     BPF_LINK_TYPE_TRACING =3D 2,
> > +     BPF_LINK_TYPE_CGROUP =3D 3,
> > +
> > +     MAX_BPF_LINK_TYPE,
> > +};
> > +
> >  /* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
> >   *
> >   * NONE(default): No further bpf programs allowed in the subtree.
> > @@ -3612,6 +3621,25 @@ struct bpf_btf_info {
> >       __u32 id;
> >  } __attribute__((aligned(8)));
> >
> > +struct bpf_link_info {
> > +     __u32 type;
> > +     __u32 id;
> > +     __u32 prog_id;
> > +     union {
> > +             struct {
> > +                     __aligned_u64 tp_name; /* in/out: tp_name buffer =
ptr */
> > +                     __u32 tp_name_len;     /* in/out: tp_name buffer =
len */
> > +             } raw_tracepoint;
> > +             struct {
> > +                     __u32 attach_type;
> > +             } tracing;
>
> On the RFC I asked whether we could get the attach target here as well.
> You said you'd look into it; what happened to that? :)
>

Right, sorry, forgot to mention this. I did take a look, but tracing
links are quite diverse, so I didn't see one clear way to structure
such "target" information, so I'd say we should push it into a
separate patch/discussion. E.g., fentry/fexit/fmod_exit are attached
to kernel functions (how do we represent that), freplace are attached
to another BPF program (this is a bit clearer how to represent, but
how do we combine that with fentry/fexit info?). LSM is also attached
to kernel function, but who knows, maybe we want slightly more
extended semantics for it. Either way, I don't see one best way to
structure this information and would want to avoid blocking on this
for this series. Also bpf_link_info is extensible, so it's not a
problem to extend it in follow up patches.

Does it make sense?

> -Toke
>
