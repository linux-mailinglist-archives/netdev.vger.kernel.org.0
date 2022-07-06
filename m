Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30455694FD
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 00:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbiGFWEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 18:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiGFWEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 18:04:36 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4639F313;
        Wed,  6 Jul 2022 15:04:35 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id r18so20906293edb.9;
        Wed, 06 Jul 2022 15:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0pjXsxvLXJt+LczILSuc8kU8VcrSNLSdV+Rd2QZM5OQ=;
        b=GIEwVfojKqzA+1f2K4ZPZw1u+zJ3Jt9weYZQmVyITDvrU2DUT22qo9VTWzbyzQuxB5
         +zdB4awjGcqzbxGw88I2xYMsF89axmsYfdfkNuolCa/IE5Q3pg4a27u0EwxVCnCquYBe
         x96wSC+D02ADQLkAhwaNi0Q76eQhYVIX7bUo9SVD8yO+i2rUDZoEwbt5hUd3O+l3qL1g
         iF5+OkjXjsGKuBuvLUF4VA+DDpVsDp/hX+p5Y6p92HHlkG/GjWJnI0HPdv7VSTRqh0L0
         71j8VquTl03RcjChBigYnTav842qp40AMijBvAC36Jpyufx4cgXseSL8GYpBlmJiXCKa
         27hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0pjXsxvLXJt+LczILSuc8kU8VcrSNLSdV+Rd2QZM5OQ=;
        b=KhVjjwSB3qEoqKkNDu4F9b3Jhb/BkK3CSHlqmCHPW7STVCcPEGvK/vis/63XleC1Gh
         of+5OeLDLha94iVOosJTtQeQQxD5fVqu9s2JyqsYyKeuvMT88MjHgDoT5YYeb9nN4Rx1
         iFooSFaQD0PNNCMrxgPTyUqJj0Nw81JNqonQpoJKNog7DhM1I9yPbk1TAneCZMdeQ3Px
         Kz6//WnyW2I1siEpEBsqp6aVKtz05TjkY9Lg1U+9qWcxUKHP74/nMfI/iPEqF6lAvwA+
         lSKSC9tiQXXMWVk4w8FIh/HMKPgirVtRjtwM1ctKBZYE3V0hNPgtzLzgnlDajGEzbpsD
         P4Iw==
X-Gm-Message-State: AJIora9e4iJdyUgamajGjNtdm7mlxDgVYVEC6Sus0zmTZ2PRc8rvnxfg
        /qyU4fSLU/AjcxWC3i4wbRnssuxb0UlT8g81UwA=
X-Google-Smtp-Source: AGRyM1uQnqEkBbigqrn3tC3CaactZ/5IxP7JiFu10XXKH8OviJwPszxWuCftJsUNxRy63LxTVtWRw3WdxXHRD1U4oC0=
X-Received: by 2002:a05:6402:2398:b0:435:9685:1581 with SMTP id
 j24-20020a056402239800b0043596851581mr57275419eda.333.1657145073767; Wed, 06
 Jul 2022 15:04:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220623192637.3866852-1-memxor@gmail.com> <20220623192637.3866852-2-memxor@gmail.com>
 <20220629032304.h5ck7tizbfehiwut@macbook-pro-3.dhcp.thefacebook.com>
 <CAP01T77fsU8u6GP+HXfQQ_gdu+kp3Am1+Ao-mNYULjDazHs38Q@mail.gmail.com>
 <CAP01T75cVLehQbkE3LLwSG5wVecNz0FH9QZpmzoqs-e8YKpGtg@mail.gmail.com>
 <20220706184436.mf7oeexxfwswgdqf@MacBook-Pro-3.local> <CAP01T75-EZfdBx+W+6pV0vDDD3Qi07KVLsFTupPfptTyAFxx1Q@mail.gmail.com>
 <20220706212903.az2mtqodtzmn2gwq@MacBook-Pro-3.local>
In-Reply-To: <20220706212903.az2mtqodtzmn2gwq@MacBook-Pro-3.local>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 6 Jul 2022 15:04:22 -0700
Message-ID: <CAADnVQJsAfjFwgoiWdsmuWBi9BX7eaCw8Tpe7sd=HPG4QQck1A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/8] bpf: Add support for forcing kfunc args
 to be referenced
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 6, 2022 at 2:29 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jul 07, 2022 at 12:51:15AM +0530, Kumar Kartikeya Dwivedi wrote:
> > On Thu, 7 Jul 2022 at 00:14, Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Sun, Jul 03, 2022 at 11:04:22AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > > On Sun, 3 Jul 2022 at 10:54, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > > > >
> > > > > On Wed, 29 Jun 2022 at 08:53, Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > On Fri, Jun 24, 2022 at 12:56:30AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > > > > > Similar to how we detect mem, size pairs in kfunc, teach verifier to
> > > > > > > treat __ref suffix on argument name to imply that it must be a
> > > > > > > referenced pointer when passed to kfunc. This is required to ensure that
> > > > > > > kfunc that operate on some object only work on acquired pointers and not
> > > > > > > normal PTR_TO_BTF_ID with same type which can be obtained by pointer
> > > > > > > walking. Release functions need not specify such suffix on release
> > > > > > > arguments as they are already expected to receive one referenced
> > > > > > > argument.
> > > > > > >
> > > > > > > Note that we use strict type matching when a __ref suffix is present on
> > > > > > > the argument.
> > > > > > ...
> > > > > > > +             /* Check if argument must be a referenced pointer, args + i has
> > > > > > > +              * been verified to be a pointer (after skipping modifiers).
> > > > > > > +              */
> > > > > > > +             arg_ref = is_kfunc_arg_ref(btf, args + i);
> > > > > > > +             if (is_kfunc && arg_ref && !reg->ref_obj_id) {
> > > > > > > +                     bpf_log(log, "R%d must be referenced\n", regno);
> > > > > > > +                     return -EINVAL;
> > > > > > > +             }
> > > > > > > +
> > > > > >
> > > > > > imo this suffix will be confusing to use.
> > > > > > If I understand the intent the __ref should only be used
> > > > > > in acquire (and other) kfuncs that also do release.
> > > > > > Adding __ref to actual release kfunc will be a nop.
> > > > > > It will be checked, but it's not necessary.
> > > > > >
> > > > > > At the end
> > > > > > +struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct__ref)
> > > > > > will behave like kptr_xchg with exception that kptr_xchg takes any btf_id
> > > > > > while here it's fixed.
> > > > > >
> > > > > > The code:
> > > > > >  if (rel && reg->ref_obj_id)
> > > > > >         arg_type |= OBJ_RELEASE;
> > > > > > should probably be updated with '|| arg_ref'
> > > > > > to make sure reg->off == 0 ?
> > > > > > That looks like a small bug.
> > > > > >
> > > > >
> > > > > Indeed, I missed that. Thanks for catching it.
> > > > >
> > > > > > But stepping back... why __ref is needed ?
> > > > > > We can add bpf_ct_insert_entry to acq and rel sets and it should work?
> > > > > > I'm assuming you're doing the orthogonal cleanup of resolve_btfid,
> > > > > > so we will have a single kfunc set where bpf_ct_insert_entry will
> > > > > > have both acq and rel flags.
> > > > > > I'm surely missing something.
> > > > >
> > > > > It is needed to prevent the case where someone might do:
> > > > > ct = bpf_xdp_ct_alloc(...);
> > > > > bpf_ct_set_timeout(ct->master, ...);
> > > > >
> > > >
> > > > A better illustration is probably bpf_xdp_ct_lookup and
> > > > bpf_ct_change_timeout, since here the type for ct->master won't match
> > > > with bpf_ct_set_timeout, but the point is the same.
> > >
> > > Sorry, I'm still not following.
> > > Didn't we make pointer walking 'untrusted' so ct->master cannot be
> > > passed into any kfunc?
> > >
> >
> > I don't believe that is the case, it is only true for kptrs loaded
> > from BPF maps (that too those with BPF_LDX, not the ones with
> > kptr_xchg). There we had a chance to do things differently. For normal
> > PTR_TO_BTF_ID obtained from kfuncs/BPF helpers, there is no untrusted
> > flag set on them, nor is it set when walking them.
> >
> > I also think we discussed switching to this mode, by making many cases
> > untrusted by default, and using annotation to allow cases, making
> > pointers trusted at one level (like args for tracing/lsm progs, but
> > next deref becomes untrusted), but admittedly it may not cover enough
> > ground, and you didn't like it much either, so I stopped pursuing it.
>
> Ahh. Now I remember. Thanks for reminding :)
> Could you please summarize this thread and add all of it as a big comment
> in the source code next to __ref handling to explain the motivation
> and an example on when and how this __ref suffix should be used.
> Otherwise somebody, like me, will forget the context soon.
>
> I was thinking of better name than __ref, but couldn't come up with one.
> __ref fits this use case the best.

Actually, maybe a kfunc flag will be better?
Like REF_ARGS
that would apply to all arguments of the kfunc
(not only those with __ref suffix).

We have three types of ptr_btf_id:
- ref counted
- untrusted
- old legacy that we cannot be break due to backward compat

In the future we'll probably be adding new kfuncs where we'd want
every argument to be trusted. In our naming convention these are
the refcounted ptr_to_btf_id that come from lookup-like kfuncs.
To consume them in the release kfunc they have to be refcounted,
but non-release kfunc (like set_timeout) also want a trusted ptr.
So the simple way of describe the intent would be:
BTF_ID(func, bpf_ct_release, RELEASE)
BTF_ID(func, bpf_ct_set_timeout, REF_ARGS)

or maybe TRUSTED_ARGS would be a better flag name.
wdyt?
