Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66068342831
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhCSVvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhCSVvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 17:51:54 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DFFC06175F;
        Fri, 19 Mar 2021 14:51:42 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id p3so5567877ybo.8;
        Fri, 19 Mar 2021 14:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q+e1jmCSAxjRfli/El6bWxVwffxvNofBc0j7Z3IPkHM=;
        b=fNTKKk+XX5VPGVqAXfOECmFI2keXW99qe0bDkQgSfYfm3YvCVzbjnI7m1iCNj/BZh3
         9iFteApCFo7nP3QjkVGVUsig18ZG+ulPXOvi7QIZx/I6eJRa6h5cGL+LR6gCYqdtQcrs
         jcYDCtkgi/jeB2GXQm8SMCG8G5V376Qtg/JzkK/6bd5HO7XZwWXsc2cgR43K5Ap8jA16
         JgmAC7hVT9XsKB8xslt02DTlfXXp5rL0YAyyAwB231vej6sbpzdd5AYe6/IQ/4o3GBEP
         C3HJ6jq1BEbpJUNRx/mh/1wMUcupR+k9tGdeBkvjMX0CzCdntQ/v7yotRwi1/6BoNcUA
         ttcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q+e1jmCSAxjRfli/El6bWxVwffxvNofBc0j7Z3IPkHM=;
        b=BjSvhiHTNNpGz+ep25wyfxtVfK8HxjKBluQ2Jr87nDX19ylDNGZk3cOVQF7jhgP2za
         uuH9IwBm7em5Wpxmhs3BNwPSlrYKQbmxUMS/jzxPH47whND+Q6RTSgFxUrmI6YA7s9rj
         ILhPvtekmq6UlZkK4mXiH7u+KZJLbYWt41M1x5PGWbzHuzj3Cf9QaUqPF7fA4VsdELrp
         SrKE30DhDtwUePMcV7a8CxgfvueD4zDYjITsX9vRkdfv2GYZJaKrsqJtOyfwnrKQdifg
         d9KrOfWyga3mVjRym6mfQEh8vd0LYGv7NlwAtO2YgxPgQeWlGo9dIgAUVsm33a4TSKwu
         me5Q==
X-Gm-Message-State: AOAM533ekNTyFtFkl2ni0OxZE7rlbdghgwfpTxI76hue9IM4tLQMkqAO
        Ah7aPLRytL7jZx7AiELnPrgG9A7HSFwWezoNrg8=
X-Google-Smtp-Source: ABdhPJzO6tTKC3Lj75YAkcg5L+LxDg77firOZ/baIt3ku/hnsdyUGdteMw2VRkSrWrBPuo980KcunObnbmcsM4mWwZk=
X-Received: by 2002:a25:9942:: with SMTP id n2mr8993835ybo.230.1616190702282;
 Fri, 19 Mar 2021 14:51:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011336.4173585-1-kafai@fb.com> <20210316011355.4176313-1-kafai@fb.com>
 <CAEf4BzbyKPgHC8h9z--j=h9Fw+Qd6HSgCtvPvytO5nw82FJoMQ@mail.gmail.com> <20210319193250.qogxn6ajnzoys43h@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210319193250.qogxn6ajnzoys43h@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Mar 2021 14:51:31 -0700
Message-ID: <CAEf4Bzb2UuzbiiG7ArFtH4eskJMm7XvQiGA5H7gzH+y7K0gPHA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 03/15] bpf: Refactor btf_check_func_arg_match
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 12:32 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Mar 18, 2021 at 04:32:47PM -0700, Andrii Nakryiko wrote:
> > On Tue, Mar 16, 2021 at 12:01 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This patch refactors the core logic of "btf_check_func_arg_match()"
> > > into a new function "do_btf_check_func_arg_match()".
> > > "do_btf_check_func_arg_match()" will be reused later to check
> > > the kernel function call.
> > >
> > > The "if (!btf_type_is_ptr(t))" is checked first to improve the indentation
> > > which will be useful for a later patch.
> > >
> > > Some of the "btf_kind_str[]" usages is replaced with the shortcut
> > > "btf_type_str(t)".
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >  include/linux/btf.h |   5 ++
> > >  kernel/bpf/btf.c    | 159 ++++++++++++++++++++++++--------------------
> > >  2 files changed, 91 insertions(+), 73 deletions(-)
> > >

[...]

> > > +               if (!btf_type_is_ptr(t)) {
> > > +                       bpf_log(log, "Unrecognized arg#%d type %s\n",
> > > +                               i, btf_type_str(t));
> > > +                       return -EINVAL;
> > > +               }
> > > +
> > > +               ref_t = btf_type_skip_modifiers(btf, t->type, NULL);
> > > +               ref_tname = btf_name_by_offset(btf, ref_t->name_off);
> >
> > these two seem to be used only inside else `if (ptr_to_mem_ok)`, let's
> > move the code and variables inside that branch?
> It is kept here because the next patch uses it in
> another case also.

yeah, I saw that once I got to that patch, never mind

>
> >
> > > +               if (btf_get_prog_ctx_type(log, btf, t, env->prog->type, i)) {
> > >                         /* If function expects ctx type in BTF check that caller
> > >                          * is passing PTR_TO_CTX.
> > >                          */
> > > -                       if (btf_get_prog_ctx_type(log, btf, t, prog->type, i)) {
> > > -                               if (reg->type != PTR_TO_CTX) {
> > > -                                       bpf_log(log,
> > > -                                               "arg#%d expected pointer to ctx, but got %s\n",
> > > -                                               i, btf_kind_str[BTF_INFO_KIND(t->info)]);
> > > -                                       goto out;
> > > -                               }
> > > -                               if (check_ctx_reg(env, reg, i + 1))
> > > -                                       goto out;
> > > -                               continue;
> > > +                       if (reg->type != PTR_TO_CTX) {
> > > +                               bpf_log(log,
> > > +                                       "arg#%d expected pointer to ctx, but got %s\n",
> > > +                                       i, btf_type_str(t));
> > > +                               return -EINVAL;
> > >                         }
> > > +                       if (check_ctx_reg(env, reg, regno))
> > > +                               return -EINVAL;
> >
> > original code had `continue` here allowing to stop tracking if/else
> > logic. Any specific reason you removed it? It keeps logic simpler to
> > follow, imo.
> There is no other case after this.
> "continue" becomes redundant, so removed.

well, there is the entire "else if (ptr_to_mem_ok)" which now you need
to skip and go check if there is anything else that is supposed to
happen after if. `continue;`, on the other hand, makes it very clear
that nothing more is going to happen

>
> >
> > > +               } else if (ptr_to_mem_ok) {
> >
> > similarly to how you did reduction of nestedness with btf_type_is_ptr, I'd do
> >
> > if (!ptr_to_mem_ok)
> >     return -EINVAL;
> >
> > and let brain forget about another if/else branch tracking
> I don't see a significant difference.  Either way looks the same with
> a few more test cases, IMO.
>
> I prefer to keep it like this since there is
> another test case added in the next patch.
>
> There are usages with much longer if-else-if statement inside a
> loop in the verifier also without explicit "continue" in the middle
> or handle the last case differently and they are very readable.

It's a matter of taste, I suppose. I'd probably disagree with you on
the readability of those verifier parts ;) So it's up to you, of
course, but for me this code pattern:

for (...) {
    if (A) {
        handleA;
    } else if (B) {
        handleB;
    } else {
        return -EINVAL;
    }
}

is much harder to follow than more linear (imo)

for (...) {
    if (A) {
        handleA;
        continue;
    }

    if (!B)
        return -EINVAL;

    handleB;
}

especially if handleA and handleB are quite long and complicated.
Because I have to jump back and forth to validate that C is not
allowed/handled later, and that there is no common subsequent logic
for both A and B (or even C). In the latter code pattern there are
clear "only A" and "only B" logic and it's quite obvious that no C is
allowed/handled.

>
> >
> > > +                       const struct btf_type *resolve_ret;
> > > +                       u32 type_size;
> > >
> > > -                       if (!is_global)
> > > -                               goto out;
> > > -

[...]
