Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD4034140C
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 05:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbhCSEOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 00:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbhCSEOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 00:14:07 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783B3C06174A;
        Thu, 18 Mar 2021 21:14:07 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id u75so4866223ybi.10;
        Thu, 18 Mar 2021 21:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tNTh8Q6caDvA2UsT4jWHD+D49y05dz3NhBiw1/vkx+M=;
        b=kDnyGmHnWMTczqJeSMrK7N1Z1Ti7WYELAxUYv1gm4+/6IfGDvE37wzTaeE+6ltEIpI
         3need+8LE9q9dXD0ezV9aFqIlKvBYmb52VzT98S7G6wXq/RtCiK9Lyy5suf7zybCG0fC
         Du1IlOBPfCes6nVeNDuIr58qK9MFdN20y9KEqaQ44LX+To9XYY0F4WluVvV1jaa6rKQN
         MLPr+F5duF62Vjawv47945iQUhLIAVhLZ9GVcpwVcE8CyZlW0l2YvLjsm3BCedIH6xq5
         r1W8I1lFsPcDWKF9bHeTPH3deYxPwmToUSjzrZnm+e990Z2FF++ABDaft+KKOXfpBL3t
         JkBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tNTh8Q6caDvA2UsT4jWHD+D49y05dz3NhBiw1/vkx+M=;
        b=nxKQsUFHzyeqTVXKJBO+C3//OAQ/hbHm7ZXfVCwYo7OJr4L9WRYCim4HjcsQ+qvV5p
         Z3csxeEUdOTc5YHnSBFSPGK5s4u5XbWP/FkL6WMCAd5Jp2iW1XeHh8PZgu9WzBwVwGsO
         Cw1sHvIiuCLdyTg//m0NyrpxyKsOgL8YBRtHeRcTIgOWz45fji/A5cxKsU9RCuGAW0BY
         K83Kd7016sujf3YogLv7AbN6eHID/nP+shw15vOEfGw9mNLNuGbyc9LbH8L8wOmViQN2
         ACvzeq4KnFa4GvGGxeO8Cg+ay40JH/ciLxSdggg8sjn4/1lmIdftH4EEKcvD/CooLRY9
         GL1Q==
X-Gm-Message-State: AOAM53166knqelwbcfeeg8IzrY7Esz1JjevkBugRlUmM0R88Al3pVBkN
        kMZhdf4ejpXQ8u/BhNnucBwo/yW21d2DyKkr/kk=
X-Google-Smtp-Source: ABdhPJxuRjxsXStT21SXcmwMg7l2qAj9qSKf3riej7NVrzJKepoqQbark0QQN4BOxR92IodQ4mCtw9g+dbr8UczSxDQ=
X-Received: by 2002:a25:40d8:: with SMTP id n207mr3733310yba.459.1616127246795;
 Thu, 18 Mar 2021 21:14:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011336.4173585-1-kafai@fb.com> <20210316011348.4175708-1-kafai@fb.com>
 <CAEf4Bzb57BrVOHRzikejK1ubWrZ_cd2FCS6BW6_E-2KuzJGrPg@mail.gmail.com> <20210318233907.r5pxtpe477jumjq6@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210318233907.r5pxtpe477jumjq6@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Mar 2021 21:13:56 -0700
Message-ID: <CAEf4BzZx+1bN0VazE5t5_z8X+GXFZUmiLbpxZ-WfM_mLba0OYg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/15] bpf: btf: Support parsing extern func
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 4:39 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Mar 18, 2021 at 03:53:38PM -0700, Andrii Nakryiko wrote:
> > On Tue, Mar 16, 2021 at 12:01 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This patch makes BTF verifier to accept extern func. It is used for
> > > allowing bpf program to call a limited set of kernel functions
> > > in a later patch.
> > >
> > > When writing bpf prog, the extern kernel function needs
> > > to be declared under a ELF section (".ksyms") which is
> > > the same as the current extern kernel variables and that should
> > > keep its usage consistent without requiring to remember another
> > > section name.
> > >
> > > For example, in a bpf_prog.c:
> > >
> > > extern int foo(struct sock *) __attribute__((section(".ksyms")))
> > >
> > > [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
> > >         '(anon)' type_id=18
> > > [25] FUNC 'foo' type_id=24 linkage=extern
> > > [ ... ]
> > > [33] DATASEC '.ksyms' size=0 vlen=1
> > >         type_id=25 offset=0 size=0
> > >
> > > LLVM will put the "func" type into the BTF datasec ".ksyms".
> > > The current "btf_datasec_check_meta()" assumes everything under
> > > it is a "var" and ensures it has non-zero size ("!vsi->size" test).
> > > The non-zero size check is not true for "func".  This patch postpones the
> > > "!vsi-size" test from "btf_datasec_check_meta()" to
> > > "btf_datasec_resolve()" which has all types collected to decide
> > > if a vsi is a "var" or a "func" and then enforce the "vsi->size"
> > > differently.
> > >
> > > If the datasec only has "func", its "t->size" could be zero.
> > > Thus, the current "!t->size" test is no longer valid.  The
> > > invalid "t->size" will still be caught by the later
> > > "last_vsi_end_off > t->size" check.   This patch also takes this
> > > chance to consolidate other "t->size" tests ("vsi->offset >= t->size"
> > > "vsi->size > t->size", and "t->size < sum") into the existing
> > > "last_vsi_end_off > t->size" test.
> > >
> > > The LLVM will also put those extern kernel function as an extern
> > > linkage func in the BTF:
> > >
> > > [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
> > >         '(anon)' type_id=18
> > > [25] FUNC 'foo' type_id=24 linkage=extern
> > >
> > > This patch allows BTF_FUNC_EXTERN in btf_func_check_meta().
> > > Also extern kernel function declaration does not
> > > necessary have arg name. Another change in btf_func_check() is
> > > to allow extern function having no arg name.
> > >
> > > The btf selftest is adjusted accordingly.  New tests are also added.
> > >
> > > The required LLVM patch: https://reviews.llvm.org/D93563
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> >
> > High-level question about EXTERN functions in DATASEC. Does kernel
> > need to see them under DATASEC? What if libbpf just removed all EXTERN
> > funcs from under DATASEC and leave them as "free-floating" EXTERN
> > FUNCs in BTF.
> >
> > We need to tag EXTERNs with DATASECs mainly for libbpf to know whether
> > it's .kconfig or .ksym or other type of externs. Does kernel need to
> > care?
> Although the kernel does not need to know, since the a legit llvm generates it,
> I go with a proper support in the kernel (e.g. bpftool btf dump can better
> reflect what was there).

LLVM also generates extern VAR with BTF_VAR_EXTERN, yet libbpf is
replacing it with fake INTs. We could do just that here as well. If
anyone would want to know all the kernel functions that some BPF
program is using, they could do it from the instruction dump, with
proper addresses and kernel function names nicely displayed there.
That's way more useful, IMO.

>
> >
> > >  kernel/bpf/btf.c                             |  52 ++++---
> > >  tools/testing/selftests/bpf/prog_tests/btf.c | 154 ++++++++++++++++++-
> > >  2 files changed, 178 insertions(+), 28 deletions(-)
> > >
> >
> > [...]
> >
> > > @@ -3611,9 +3594,28 @@ static int btf_datasec_resolve(struct btf_verifier_env *env,
> > >                 u32 var_type_id = vsi->type, type_id, type_size = 0;
> > >                 const struct btf_type *var_type = btf_type_by_id(env->btf,
> > >                                                                  var_type_id);
> > > -               if (!var_type || !btf_type_is_var(var_type)) {
> > > +               if (!var_type) {
> > > +                       btf_verifier_log_vsi(env, v->t, vsi,
> > > +                                            "type not found");
> > > +                       return -EINVAL;
> > > +               }
> > > +
> > > +               if (btf_type_is_func(var_type)) {
> > > +                       if (vsi->size || vsi->offset) {
> > > +                               btf_verifier_log_vsi(env, v->t, vsi,
> > > +                                                    "Invalid size/offset");
> > > +                               return -EINVAL;
> > > +                       }
> > > +                       continue;
> > > +               } else if (btf_type_is_var(var_type)) {
> > > +                       if (!vsi->size) {
> > > +                               btf_verifier_log_vsi(env, v->t, vsi,
> > > +                                                    "Invalid size");
> > > +                               return -EINVAL;
> > > +                       }
> > > +               } else {
> > >                         btf_verifier_log_vsi(env, v->t, vsi,
> > > -                                            "Not a VAR kind member");
> > > +                                            "Neither a VAR nor a FUNC");
> > >                         return -EINVAL;
> >
> > can you please structure it as follow (I think it is bit easier to
> > follow the logic then):
> >
> > if (btf_type_is_func()) {
> >    ...
> >    continue; /* no extra checks */
> > }
> >
> > if (!btf_type_is_var()) {
> >    /* bad, complain, exit */
> >    return -EINVAL;
> > }
> >
> > /* now we deal with extra checks for variables */
> >
> > That way variable checks are kept all in one place.
> >
> > Also a question: is that ok to enable non-extern functions under
> > DATASEC? Maybe, but that wasn't explicitly mentioned.
> The patch does not check.  We could reject that for now.
>
> >
> > >                 }
> > >
> > > @@ -3849,9 +3851,11 @@ static int btf_func_check(struct btf_verifier_env *env,
> > >         const struct btf_param *args;
> > >         const struct btf *btf;
> > >         u16 nr_args, i;
> > > +       bool is_extern;
> > >
> > >         btf = env->btf;
> > >         proto_type = btf_type_by_id(btf, t->type);
> > > +       is_extern = btf_type_vlen(t) == BTF_FUNC_EXTERN;
> >
> > using btf_type_vlen(t) for getting func linkage is becoming more and
> > more confusing. Would it be terrible to have btf_func_linkage(t)
> > helper instead?
> I have it in my local v2.  and also just return when it is extern.
>
> >
> > >
> > >         if (!proto_type || !btf_type_is_func_proto(proto_type)) {
> > >                 btf_verifier_log_type(env, t, "Invalid type_id");
> > > @@ -3861,7 +3865,7 @@ static int btf_func_check(struct btf_verifier_env *env,
> > >         args = (const struct btf_param *)(proto_type + 1);
> > >         nr_args = btf_type_vlen(proto_type);
> > >         for (i = 0; i < nr_args; i++) {
> > > -               if (!args[i].name_off && args[i].type) {
> > > +               if (!is_extern && !args[i].name_off && args[i].type) {
> > >                         btf_verifier_log_type(env, t, "Invalid arg#%u", i + 1);
> > >                         return -EINVAL;
> > >                 }
> >
> > [...]
