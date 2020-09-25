Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FCE2789F0
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgIYNu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbgIYNu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:50:57 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD5CC0613D3
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 06:50:56 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id a3so2859267oib.4
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 06:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ApgS+Z/9D62Ae6u3psVuEdkiA8zlCd+1iMhF03CW1ZM=;
        b=qXuDQa8jcp13fs27a78iyxJCLOGurxxrzE5PLlYL/WpCJKfPuZjtRBC1g9e4rGLwlz
         M3RlVw6Xr0myhhEOUaLog0ou6pQiBjkGDcONaMwKcaIhD2fdEhUhs8rP/J6pHymF578Y
         uAre/fY5etP7QjZPp4DpQRIDOKwpKx/Cl48j0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ApgS+Z/9D62Ae6u3psVuEdkiA8zlCd+1iMhF03CW1ZM=;
        b=ecvgPAxXK+jy6l8xtnzXkqfZBvEfZAVxYdCKmQVk4vCtZHUUnXPjAe8yMeKZ9+Q9xL
         Ru+j8jBWjNWMYT5Dq6wM39EQKuc4LOIdmZDg/bDUSlq9esOyEg1ZoObwWTjn0vm03yU2
         YNo9R+OWxNde7tPFwWXZUqOIT4zhIALqWmW4P8GLWO4C3AWGraB0ZFe8/7ORKNvlOFpr
         EnnYWF7vl7qbY1OvSivcOiJgbKj8GevkE1rFfU2IUFWRiOYs13wUCwDf1+RT1Fae5aBS
         zG5L6HOaeXUdtYBfMb0BtnJd914Z6cga4jfoKSDDe2lb4FThQHBYvtpBpbdQ4VoUOxsA
         5MBg==
X-Gm-Message-State: AOAM533CN+nJQZAUYyt8luc4Av/MSnzHvKEb2dWRR0nMuXF2UrPI2gJh
        bO5w4tmnsUjNs9HsLTPMkblxJQckz9tRxVjnGZ79Rg==
X-Google-Smtp-Source: ABdhPJwFjuH/n2DXTVKD8/eKbF3xFvb72RzzTzd8MX37YM8E+OgPS/bTq2V9ZdxPvgXx92zUxNGFWJ/2TfY68O22vVg=
X-Received: by 2002:aca:3087:: with SMTP id w129mr298879oiw.102.1601041855923;
 Fri, 25 Sep 2020 06:50:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200925000337.3853598-1-kafai@fb.com> <20200925000350.3855720-1-kafai@fb.com>
 <CACAyw98fk6Vp3H_evke+-azatkz7eoqQaqy+37mMshkQf1Ri4Q@mail.gmail.com> <20200925131820.f5yknxfzivjuy6j6@kafai-mbp>
In-Reply-To: <20200925131820.f5yknxfzivjuy6j6@kafai-mbp>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 25 Sep 2020 14:50:44 +0100
Message-ID: <CACAyw98EPhkRumV0xZR0J3HiVwVpE7iH1+aTWvrxpgKYndiVhw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 02/13] bpf: Enable bpf_skc_to_* sock casting
 helper to networking prog type
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Sep 2020 at 14:18, Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Sep 25, 2020 at 09:26:36AM +0100, Lorenz Bauer wrote:
> > On Fri, 25 Sep 2020 at 01:04, Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > There is a constant need to add more fields into the bpf_tcp_sock
> > > for the bpf programs running at tc, sock_ops...etc.
> > >
> > > A current workaround could be to use bpf_probe_read_kernel().  However,
> > > other than making another helper call for reading each field and missing
> > > CO-RE, it is also not as intuitive to use as directly reading
> > > "tp->lsndtime" for example.  While already having perfmon cap to do
> > > bpf_probe_read_kernel(), it will be much easier if the bpf prog can
> > > directly read from the tcp_sock.
> > >
> > > This patch tries to do that by using the existing casting-helpers
> > > bpf_skc_to_*() whose func_proto returns a btf_id.  For example, the
> > > func_proto of bpf_skc_to_tcp_sock returns the btf_id of the
> > > kernel "struct tcp_sock".
> > >
> > > These helpers are also added to is_ptr_cast_function().
> > > It ensures the returning reg (BPF_REF_0) will also carries the ref_obj_id.
> > > That will keep the ref-tracking works properly.
> > >
> > > The bpf_skc_to_* helpers are made available to most of the bpf prog
> > > types in filter.c. The bpf_skc_to_* helpers will be limited by
> > > perfmon cap.
> > >
> > > This patch adds a ARG_PTR_TO_BTF_ID_SOCK_COMMON.  The helper accepting
> > > this arg can accept a btf-id-ptr (PTR_TO_BTF_ID + &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON])
> > > or a legacy-ctx-convert-skc-ptr (PTR_TO_SOCK_COMMON).  The bpf_skc_to_*()
> > > helpers are changed to take ARG_PTR_TO_BTF_ID_SOCK_COMMON such that
> > > they will accept pointer obtained from skb->sk.
> > >
> > > Instead of specifying both arg_type and arg_btf_id in the same func_proto
> > > which is how the current ARG_PTR_TO_BTF_ID does, the arg_btf_id of
> > > the new ARG_PTR_TO_BTF_ID_SOCK_COMMON is specified in the
> > > compatible_reg_types[] in verifier.c.  The reason is the arg_btf_id is
> > > always the same.  Discussion in this thread:
> > > https://lore.kernel.org/bpf/20200922070422.1917351-1-kafai@fb.com/
> > >
> > > The ARG_PTR_TO_BTF_ID_ part gives a clear expectation that the helper is
> > > expecting a PTR_TO_BTF_ID which could be NULL.  This is the same
> > > behavior as the existing helper taking ARG_PTR_TO_BTF_ID.
> > >
> > > The _SOCK_COMMON part means the helper is also expecting the legacy
> > > SOCK_COMMON pointer.
> > >
> > > By excluding the _OR_NULL part, the bpf prog cannot call helper
> > > with a literal NULL which doesn't make sense in most cases.
> > > e.g. bpf_skc_to_tcp_sock(NULL) will be rejected.  All PTR_TO_*_OR_NULL
> > > reg has to do a NULL check first before passing into the helper or else
> > > the bpf prog will be rejected.  This behavior is nothing new and
> > > consistent with the current expectation during bpf-prog-load.
> > >
> > > [ ARG_PTR_TO_BTF_ID_SOCK_COMMON will be used to replace
> > >   ARG_PTR_TO_SOCK* of other existing helpers later such that
> > >   those existing helpers can take the PTR_TO_BTF_ID returned by
> > >   the bpf_skc_to_*() helpers.
> > >
> > >   The only special case is bpf_sk_lookup_assign() which can accept a
> > >   literal NULL ptr.  It has to be handled specially in another follow
> > >   up patch if there is a need (e.g. by renaming ARG_PTR_TO_SOCKET_OR_NULL
> > >   to ARG_PTR_TO_BTF_ID_SOCK_COMMON_OR_NULL). ]
> > >
> > > [ When converting the older helpers that take ARG_PTR_TO_SOCK* in
> > >   the later patch, if the kernel does not support BTF,
> > >   ARG_PTR_TO_BTF_ID_SOCK_COMMON will behave like ARG_PTR_TO_SOCK_COMMON
> > >   because no reg->type could have PTR_TO_BTF_ID in this case.
> > >
> > >   It is not a concern for the newer-btf-only helper like the bpf_skc_to_*()
> > >   here though because these helpers must require BTF vmlinux to begin
> > >   with. ]
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >  include/linux/bpf.h   |  1 +
> > >  kernel/bpf/verifier.c | 34 +++++++++++++++++++--
> > >  net/core/filter.c     | 69 ++++++++++++++++++++++++++++++-------------
> > >  3 files changed, 82 insertions(+), 22 deletions(-)
> > >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index fc5c901c7542..d0937f1d2980 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -292,6 +292,7 @@ enum bpf_arg_type {
> > >         ARG_PTR_TO_ALLOC_MEM,   /* pointer to dynamically allocated memory */
> > >         ARG_PTR_TO_ALLOC_MEM_OR_NULL,   /* pointer to dynamically allocated memory or NULL */
> > >         ARG_CONST_ALLOC_SIZE_OR_ZERO,   /* number of allocated bytes requested */
> > > +       ARG_PTR_TO_BTF_ID_SOCK_COMMON,  /* pointer to in-kernel sock_common or bpf-mirrored bpf_sock */
> > >         __BPF_ARG_TYPE_MAX,
> > >  };
> > >
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 945fa2b4d096..d4ba29fb17a6 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -486,7 +486,12 @@ static bool is_acquire_function(enum bpf_func_id func_id,
> > >  static bool is_ptr_cast_function(enum bpf_func_id func_id)
> > >  {
> > >         return func_id == BPF_FUNC_tcp_sock ||
> > > -               func_id == BPF_FUNC_sk_fullsock;
> > > +               func_id == BPF_FUNC_sk_fullsock ||
> > > +               func_id == BPF_FUNC_skc_to_tcp_sock ||
> > > +               func_id == BPF_FUNC_skc_to_tcp6_sock ||
> > > +               func_id == BPF_FUNC_skc_to_udp6_sock ||
> > > +               func_id == BPF_FUNC_skc_to_tcp_timewait_sock ||
> > > +               func_id == BPF_FUNC_skc_to_tcp_request_sock;
> > >  }
> > >
> > >  /* string representation of 'enum bpf_reg_type' */
> > > @@ -3953,6 +3958,7 @@ static int resolve_map_arg_type(struct bpf_verifier_env *env,
> > >
> > >  struct bpf_reg_types {
> > >         const enum bpf_reg_type types[10];
> > > +       u32 *btf_id;
> > >  };
> > >
> > >  static const struct bpf_reg_types map_key_value_types = {
> > > @@ -3973,6 +3979,17 @@ static const struct bpf_reg_types sock_types = {
> > >         },
> > >  };
> > >
> > > +static const struct bpf_reg_types btf_id_sock_common_types = {
> > > +       .types = {
> > > +               PTR_TO_SOCK_COMMON,
> > > +               PTR_TO_SOCKET,
> > > +               PTR_TO_TCP_SOCK,
> > > +               PTR_TO_XDP_SOCK,
> > > +               PTR_TO_BTF_ID,
> > > +       },
> > > +       .btf_id = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
> > > +};
> > > +
> > >  static const struct bpf_reg_types mem_types = {
> > >         .types = {
> > >                 PTR_TO_STACK,
> > > @@ -4014,6 +4031,7 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
> > >         [ARG_PTR_TO_CTX]                = &context_types,
> > >         [ARG_PTR_TO_CTX_OR_NULL]        = &context_types,
> > >         [ARG_PTR_TO_SOCK_COMMON]        = &sock_types,
> > > +       [ARG_PTR_TO_BTF_ID_SOCK_COMMON] = &btf_id_sock_common_types,
> > >         [ARG_PTR_TO_SOCKET]             = &fullsock_types,
> > >         [ARG_PTR_TO_SOCKET_OR_NULL]     = &fullsock_types,
> > >         [ARG_PTR_TO_BTF_ID]             = &btf_ptr_types,
> > > @@ -4059,6 +4077,14 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
> > >
> > >  found:
> > >         if (type == PTR_TO_BTF_ID) {
> > > +               if (!arg_btf_id) {
> > > +                       if (!compatible->btf_id) {
> > > +                               verbose(env, "verifier internal error: missing arg compatible BTF ID\n");
> > > +                               return -EFAULT;
> > > +                       }
> > > +                       arg_btf_id = compatible->btf_id;
> > > +               }
> > > +
> > >                 if (!btf_struct_ids_match(&env->log, reg->off, reg->btf_id,
> > >                                           *arg_btf_id)) {
> > >                         verbose(env, "R%d is of type %s but %s is expected\n",
> > > @@ -4575,10 +4601,14 @@ static bool check_btf_id_ok(const struct bpf_func_proto *fn)
> > >  {
> > >         int i;
> > >
> > > -       for (i = 0; i < ARRAY_SIZE(fn->arg_type); i++)
> > > +       for (i = 0; i < ARRAY_SIZE(fn->arg_type); i++) {
> > >                 if (fn->arg_type[i] == ARG_PTR_TO_BTF_ID && !fn->arg_btf_id[i])
> > >                         return false;
> > >
> > > +               if (fn->arg_type[i] != ARG_PTR_TO_BTF_ID && fn->arg_btf_id[i])
> > > +                       return false;
> > > +       }
> > > +
> >
> > This is a hold over from the previous patchset?
> hmm... what do you mean?

Sorry, I misread the patch!

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
