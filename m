Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9BD129B86
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 23:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfLWWzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 17:55:25 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33160 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfLWWzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 17:55:24 -0500
Received: by mail-qk1-f196.google.com with SMTP id d71so6906727qkc.0;
        Mon, 23 Dec 2019 14:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hFRSuELUfsOU19FxywO7oDhfhqX0ADpqMh4EBYlSxEk=;
        b=vHTSvyBaek14gv2gHOxnCQoFesdGrim/ke4m2iiCl/tnn5fxi7L4aUw7RSzPbHmco6
         i4ir0z3Pe5/nj5Kz+pHXwfOOX6dmHqRYzHtxH+ETHacrGY5l4V1d0rwNvQ9K0V8hMlOn
         YutQdJHJj5zTZhRrLSgsB9NNsFGTlMZCbzmwNNF1PHp46NOqn2YzNySO0//CPSGRvFV1
         qPbnwg17wwGkzf3rKgG4QMSNCOpmfsxXBnInsgvgvFoOC4k9krxmoOmTsXlkWcwhoJI5
         9boQNYylqLk29GeF4vwpBz1SHD/mSAa4ON1YdeUflAKmmqryZ6lpLAuxKeyba3exkeA9
         //Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hFRSuELUfsOU19FxywO7oDhfhqX0ADpqMh4EBYlSxEk=;
        b=hhna/mPPf9LUzIXL1Mdz0MOQz5QnClmSQts9ObXE68N+r/SBq3Sf+SQLdUO/djJbPj
         SqqNwJileYLIBgUzEpSqxlzsJTtqUfHFG7UZLfqRnbWbh+LrRHubOksYmscaH5FKvRpj
         YMUsmrucMG9bA9JO4Xl+ycm7MR50Wgy3XJcyvHGIPxFb6k2dewDzdtToW/hRaEl+fnnr
         3rS+GGqoEHweXcdw9/oejOaCq7aWdyeGtm/6n//mH8KiODM68OMsmHeOBK7V17iu/roc
         fgHd38aM7a7IlaBX/3/24spvvfIsoDA5oF9+JW7TPjwrSLCpGWzyPsDwUSZxa6OcrpdM
         wqcg==
X-Gm-Message-State: APjAAAX/vF1xcZ3yKaoyEylEMHKq4G4FvAwB1fsEFztLmkATVNfDMGaf
        t19Fo5O7iNTCeinW0rrdjAqYdcPeVlV+KVT4ydEVjw==
X-Google-Smtp-Source: APXvYqx7u1vfv6k2BcE+ZvH/AOFjzuGTTSEU5ihRVE7aWj7Y/FKq9UfgTFuD/Td29Y6LYP05XL416HtkNM4fLXfTMKo=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr29228299qkq.437.1577141723623;
 Mon, 23 Dec 2019 14:55:23 -0800 (PST)
MIME-Version: 1.0
References: <20191221062556.1182261-1-kafai@fb.com> <20191221062606.1182939-1-kafai@fb.com>
 <CAEf4BzYF8mBrkzM3=+XtyCwoQrLGvkA-6Uc3KXJ9CWmaKePX8Q@mail.gmail.com> <20191223222955.2d2hxboqzgp7662r@kafai-mbp>
In-Reply-To: <20191223222955.2d2hxboqzgp7662r@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Dec 2019 14:55:12 -0800
Message-ID: <CAEf4BzaM7OGnocOc=58hXAAcLvM0qaYRWuwiqt1L2cPY1rWykA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 05/11] bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS
To:     Martin Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 2:30 PM Martin Lau <kafai@fb.com> wrote:
>
> On Mon, Dec 23, 2019 at 12:29:37PM -0800, Andrii Nakryiko wrote:
> > On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This patch allows the kernel's struct ops (i.e. func ptr) to be
> > > implemented in BPF.  The first use case in this series is the
> > > "struct tcp_congestion_ops" which will be introduced in a
> > > latter patch.
> > >
> > > This patch introduces a new prog type BPF_PROG_TYPE_STRUCT_OPS.
> > > The BPF_PROG_TYPE_STRUCT_OPS prog is verified against a particular
> > > func ptr of a kernel struct.  The attr->attach_btf_id is the btf id
> > > of a kernel struct.  The attr->expected_attach_type is the member
> > > "index" of that kernel struct.  The first member of a struct starts
> > > with member index 0.  That will avoid ambiguity when a kernel struct
> > > has multiple func ptrs with the same func signature.
> > >
> > > For example, a BPF_PROG_TYPE_STRUCT_OPS prog is written
> > > to implement the "init" func ptr of the "struct tcp_congestion_ops".
> > > The attr->attach_btf_id is the btf id of the "struct tcp_congestion_ops"
> > > of the _running_ kernel.  The attr->expected_attach_type is 3.
> > >
> > > The ctx of BPF_PROG_TYPE_STRUCT_OPS is an array of u64 args saved
> > > by arch_prepare_bpf_trampoline that will be done in the next
> > > patch when introducing BPF_MAP_TYPE_STRUCT_OPS.
> > >
> > > "struct bpf_struct_ops" is introduced as a common interface for the kernel
> > > struct that supports BPF_PROG_TYPE_STRUCT_OPS prog.  The supporting kernel
> > > struct will need to implement an instance of the "struct bpf_struct_ops".
> > >
> > > The supporting kernel struct also needs to implement a bpf_verifier_ops.
> > > During BPF_PROG_LOAD, bpf_struct_ops_find() will find the right
> > > bpf_verifier_ops by searching the attr->attach_btf_id.
> > >
> > > A new "btf_struct_access" is also added to the bpf_verifier_ops such
> > > that the supporting kernel struct can optionally provide its own specific
> > > check on accessing the func arg (e.g. provide limited write access).
> > >
> > > After btf_vmlinux is parsed, the new bpf_struct_ops_init() is called
> > > to initialize some values (e.g. the btf id of the supporting kernel
> > > struct) and it can only be done once the btf_vmlinux is available.
> > >
> > > The R0 checks at BPF_EXIT is excluded for the BPF_PROG_TYPE_STRUCT_OPS prog
> > > if the return type of the prog->aux->attach_func_proto is "void".
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >  include/linux/bpf.h               |  30 +++++++
> > >  include/linux/bpf_types.h         |   4 +
> > >  include/linux/btf.h               |  34 ++++++++
> > >  include/uapi/linux/bpf.h          |   1 +
> > >  kernel/bpf/Makefile               |   2 +-
> > >  kernel/bpf/bpf_struct_ops.c       | 122 +++++++++++++++++++++++++++
> > >  kernel/bpf/bpf_struct_ops_types.h |   4 +
> > >  kernel/bpf/btf.c                  |  88 ++++++++++++++------
> > >  kernel/bpf/syscall.c              |  17 ++--
> > >  kernel/bpf/verifier.c             | 134 +++++++++++++++++++++++-------
> > >  10 files changed, 372 insertions(+), 64 deletions(-)
> > >  create mode 100644 kernel/bpf/bpf_struct_ops.c
> > >  create mode 100644 kernel/bpf/bpf_struct_ops_types.h
> > >
> >
> > All looks good, apart from the concern with partially-initialized
> > bpf_struct_ops.
> >
> > [...]
> >
> > > +const struct bpf_prog_ops bpf_struct_ops_prog_ops = {
> > > +};
> > > +
> > > +void bpf_struct_ops_init(struct btf *_btf_vmlinux)
> >
> > this is always get passed vmlinux's btf, so why not call it short and
> > sweet "btf"? _btf_vmlinux is kind of ugly and verbose.
> >
> > > +{
> > > +       const struct btf_member *member;
> > > +       struct bpf_struct_ops *st_ops;
> > > +       struct bpf_verifier_log log = {};
> > > +       const struct btf_type *t;
> > > +       const char *mname;
> > > +       s32 type_id;
> > > +       u32 i, j;
> > > +
> >
> > [...]
> >
> > > +static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
> > > +{
> > > +       const struct btf_type *t, *func_proto;
> > > +       const struct bpf_struct_ops *st_ops;
> > > +       const struct btf_member *member;
> > > +       struct bpf_prog *prog = env->prog;
> > > +       u32 btf_id, member_idx;
> > > +       const char *mname;
> > > +
> > > +       btf_id = prog->aux->attach_btf_id;
> > > +       st_ops = bpf_struct_ops_find(btf_id);
> >
> > if struct_ops initialization fails, type will be NULL and type_id will
> > be 0, which we rely on here to not get partially-initialized
> > bpf_struct_ops, right? Small comment mentioning this would be helpful.
> >
> >
> > > +       if (!st_ops) {
> > > +               verbose(env, "attach_btf_id %u is not a supported struct\n",
> > > +                       btf_id);
> > > +               return -ENOTSUPP;
> > > +       }
> > > +
> >
> > [...]
> >
> > >  static int check_attach_btf_id(struct bpf_verifier_env *env)
> > >  {
> > >         struct bpf_prog *prog = env->prog;
> > > @@ -9520,6 +9591,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
> > >         long addr;
> > >         u64 key;
> > >
> > > +       if (prog->type == BPF_PROG_TYPE_STRUCT_OPS)
> > > +               return check_struct_ops_btf_id(env);
> > > +
> >
> > There is a btf_id == 0 check below, you need to check that for
> > STRUCT_OPS as well, otherwise you can get partially-initialized
> > bpf_struct_ops struct in check_struct_ops_btf_id.
> This btf_id == 0 check is done at the beginning of bpf_struct_ops_find().
> Hence, bpf_struct_ops_find() won't try to search if btf_id is 0.
>

Ah right, I missed that check. Then yeah, it's not a concern. I still
don't like _btf_vmlinux name, but that's just a nit.

Acked-by: Andrii Nakryiko <andriin@fb.com>

> st_ops fields is only set when everything passed, so individual st_ops
> will not be partially initialized.
>
>
> >
> > >         if (prog->type != BPF_PROG_TYPE_TRACING)
> > >                 return 0;
> > >
> > > --
> > > 2.17.1
> > >
