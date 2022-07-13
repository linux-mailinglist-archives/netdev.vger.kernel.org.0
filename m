Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505D9573624
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 14:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235887AbiGMMN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 08:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiGMMN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 08:13:56 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4623286E4;
        Wed, 13 Jul 2022 05:13:54 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id l24so10606927ion.13;
        Wed, 13 Jul 2022 05:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uX4s6SH9kIRL3r8hlHVS4pJZBU9yNhZ8vlkpIT1/TDI=;
        b=NZtdL0ID/m/l1wOVhESbnM3o0GLOBzDO/oUXPF/2ASH+HhDppsH7VdazxJkNUbPmo4
         NJ1tQtm5bg0++tn5y8MtG+Zhbr7kN1bExxfmbnwKPFOf8kPasaGgOmB1/rRyoCXuScD9
         vmzWix/sCjiFsv9tq+IRf8ZYQgdds4bWiVOmMav2sVzB3yGJuASK1vImlZGQ+YDb579h
         FrU6YcqYnS7x+92jsN+LzySVK1CSqn4/f2OogRIvcQdY1ol8zmqctWflumjRH+G6KqcU
         m1u1ixcPVppk/kQ0EBj6TPHlxFI+wRq9j8NURL7ja686lF+ILToZD9LarlRP6sWgyftX
         gNdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uX4s6SH9kIRL3r8hlHVS4pJZBU9yNhZ8vlkpIT1/TDI=;
        b=pnYtSH3HoBEVsOtf5YN1xhMTwUrRqSO1SHEZjY62ig95WhjdrLYPGUxRzCVi+RdxUU
         7K0naobJL65F1QpU9dzHt2BH0fqhuUFu3DesCP9fsvyt61w0wXaRIZ+pp5tcNwg/Uru3
         1/e528EKtVdHIZi483OeYXn5tTN0Woc9Ague1fGLsBqncwES3TLjp0G+Qc7P5BiVDXwq
         GJQmnw45cVkKfxwNhaiPkqHFsqjWCpWwlEPW3Hev1FxYrQFxg4X7QG9HvH4JRAL1MWad
         iIPoytuOxIoiVNEAlDfQWXT8EetE6IVp/DXBKWyd0+ha5884msxTDidvPd5MqFSRP6Pn
         bEeA==
X-Gm-Message-State: AJIora+EUyw4vwh2YeIk5yvietOL/qw6p07CEIUFL8TbZimwj4qZndSs
        6pK3InKexs2F0ss91VWyLCYmJL+MksRwMHo+rZA=
X-Google-Smtp-Source: AGRyM1vlNjEAgp4pnWVHHXwmroczpGqs6jkw2j3LXXKfgnHgqZJyR1Cr1b7Z9v673yiEmxPI2PmbBT3VhraaBnpOrdc=
X-Received: by 2002:a05:6638:3802:b0:32e:3d9a:9817 with SMTP id
 i2-20020a056638380200b0032e3d9a9817mr1839946jav.206.1657714434367; Wed, 13
 Jul 2022 05:13:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220623192637.3866852-1-memxor@gmail.com> <20220623192637.3866852-2-memxor@gmail.com>
 <20220629032304.h5ck7tizbfehiwut@macbook-pro-3.dhcp.thefacebook.com>
 <CAP01T77fsU8u6GP+HXfQQ_gdu+kp3Am1+Ao-mNYULjDazHs38Q@mail.gmail.com>
 <CAP01T75cVLehQbkE3LLwSG5wVecNz0FH9QZpmzoqs-e8YKpGtg@mail.gmail.com>
 <20220706184436.mf7oeexxfwswgdqf@MacBook-Pro-3.local> <CAP01T75-EZfdBx+W+6pV0vDDD3Qi07KVLsFTupPfptTyAFxx1Q@mail.gmail.com>
 <20220706212903.az2mtqodtzmn2gwq@MacBook-Pro-3.local> <CAADnVQJsAfjFwgoiWdsmuWBi9BX7eaCw8Tpe7sd=HPG4QQck1A@mail.gmail.com>
In-Reply-To: <CAADnVQJsAfjFwgoiWdsmuWBi9BX7eaCw8Tpe7sd=HPG4QQck1A@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 13 Jul 2022 14:13:17 +0200
Message-ID: <CAP01T77GxdU6AQE3ADVFZ6YA89diFFAev3aQFpYNboxM76QJ6w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/8] bpf: Add support for forcing kfunc args
 to be referenced
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Thu, 7 Jul 2022 at 00:04, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jul 6, 2022 at 2:29 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Jul 07, 2022 at 12:51:15AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > On Thu, 7 Jul 2022 at 00:14, Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Sun, Jul 03, 2022 at 11:04:22AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > > > On Sun, 3 Jul 2022 at 10:54, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > > > > >
> > > > > > On Wed, 29 Jun 2022 at 08:53, Alexei Starovoitov
> > > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > > >
> > > > > > > On Fri, Jun 24, 2022 at 12:56:30AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > > > > > > Similar to how we detect mem, size pairs in kfunc, teach verifier to
> > > > > > > > treat __ref suffix on argument name to imply that it must be a
> > > > > > > > referenced pointer when passed to kfunc. This is required to ensure that
> > > > > > > > kfunc that operate on some object only work on acquired pointers and not
> > > > > > > > normal PTR_TO_BTF_ID with same type which can be obtained by pointer
> > > > > > > > walking. Release functions need not specify such suffix on release
> > > > > > > > arguments as they are already expected to receive one referenced
> > > > > > > > argument.
> > > > > > > >
> > > > > > > > Note that we use strict type matching when a __ref suffix is present on
> > > > > > > > the argument.
> > > > > > > ...
> > > > > > > > +             /* Check if argument must be a referenced pointer, args + i has
> > > > > > > > +              * been verified to be a pointer (after skipping modifiers).
> > > > > > > > +              */
> > > > > > > > +             arg_ref = is_kfunc_arg_ref(btf, args + i);
> > > > > > > > +             if (is_kfunc && arg_ref && !reg->ref_obj_id) {
> > > > > > > > +                     bpf_log(log, "R%d must be referenced\n", regno);
> > > > > > > > +                     return -EINVAL;
> > > > > > > > +             }
> > > > > > > > +
> > > > > > >
> > > > > > > imo this suffix will be confusing to use.
> > > > > > > If I understand the intent the __ref should only be used
> > > > > > > in acquire (and other) kfuncs that also do release.
> > > > > > > Adding __ref to actual release kfunc will be a nop.
> > > > > > > It will be checked, but it's not necessary.
> > > > > > >
> > > > > > > At the end
> > > > > > > +struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct__ref)
> > > > > > > will behave like kptr_xchg with exception that kptr_xchg takes any btf_id
> > > > > > > while here it's fixed.
> > > > > > >
> > > > > > > The code:
> > > > > > >  if (rel && reg->ref_obj_id)
> > > > > > >         arg_type |= OBJ_RELEASE;
> > > > > > > should probably be updated with '|| arg_ref'
> > > > > > > to make sure reg->off == 0 ?
> > > > > > > That looks like a small bug.
> > > > > > >
> > > > > >
> > > > > > Indeed, I missed that. Thanks for catching it.
> > > > > >
> > > > > > > But stepping back... why __ref is needed ?
> > > > > > > We can add bpf_ct_insert_entry to acq and rel sets and it should work?
> > > > > > > I'm assuming you're doing the orthogonal cleanup of resolve_btfid,
> > > > > > > so we will have a single kfunc set where bpf_ct_insert_entry will
> > > > > > > have both acq and rel flags.
> > > > > > > I'm surely missing something.
> > > > > >
> > > > > > It is needed to prevent the case where someone might do:
> > > > > > ct = bpf_xdp_ct_alloc(...);
> > > > > > bpf_ct_set_timeout(ct->master, ...);
> > > > > >
> > > > >
> > > > > A better illustration is probably bpf_xdp_ct_lookup and
> > > > > bpf_ct_change_timeout, since here the type for ct->master won't match
> > > > > with bpf_ct_set_timeout, but the point is the same.
> > > >
> > > > Sorry, I'm still not following.
> > > > Didn't we make pointer walking 'untrusted' so ct->master cannot be
> > > > passed into any kfunc?
> > > >
> > >
> > > I don't believe that is the case, it is only true for kptrs loaded
> > > from BPF maps (that too those with BPF_LDX, not the ones with
> > > kptr_xchg). There we had a chance to do things differently. For normal
> > > PTR_TO_BTF_ID obtained from kfuncs/BPF helpers, there is no untrusted
> > > flag set on them, nor is it set when walking them.
> > >
> > > I also think we discussed switching to this mode, by making many cases
> > > untrusted by default, and using annotation to allow cases, making
> > > pointers trusted at one level (like args for tracing/lsm progs, but
> > > next deref becomes untrusted), but admittedly it may not cover enough
> > > ground, and you didn't like it much either, so I stopped pursuing it.
> >
> > Ahh. Now I remember. Thanks for reminding :)
> > Could you please summarize this thread and add all of it as a big comment
> > in the source code next to __ref handling to explain the motivation
> > and an example on when and how this __ref suffix should be used.
> > Otherwise somebody, like me, will forget the context soon.
> >
> > I was thinking of better name than __ref, but couldn't come up with one.
> > __ref fits this use case the best.
>
> Actually, maybe a kfunc flag will be better?
> Like REF_ARGS
> that would apply to all arguments of the kfunc
> (not only those with __ref suffix).
>
> We have three types of ptr_btf_id:
> - ref counted
> - untrusted
> - old legacy that we cannot be break due to backward compat
>
> In the future we'll probably be adding new kfuncs where we'd want
> every argument to be trusted. In our naming convention these are
> the refcounted ptr_to_btf_id that come from lookup-like kfuncs.
> To consume them in the release kfunc they have to be refcounted,
> but non-release kfunc (like set_timeout) also want a trusted ptr.
> So the simple way of describe the intent would be:
> BTF_ID(func, bpf_ct_release, RELEASE)
> BTF_ID(func, bpf_ct_set_timeout, REF_ARGS)
>
> or maybe TRUSTED_ARGS would be a better flag name.
> wdyt?

Ok, I've implemented the kfunc flags and kept TRUSTED_ARGS as the
name. Just need to do a little bit of testing and will post it
together with this.

Just to confirm, should I still keep __ref or drop it? I think
TRUSTED_ARGS has its use but it may be too coarse. I already have the
patch so if you like we can add both ways now.
