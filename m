Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCED569287
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 21:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbiGFTWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 15:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiGFTV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 15:21:59 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B6E25E98;
        Wed,  6 Jul 2022 12:21:58 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id p128so14919158iof.1;
        Wed, 06 Jul 2022 12:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8s9/Uokai1fVBK1q95wyRayXoafLGGfQZdaG6wUPqKQ=;
        b=P4UbFYB5VwbJqYOYRk0jtrmy4c42+kTNQnEVd7Ihf4+i0mfn0D5RTc6HtA/fb7AWaT
         SZJn/cTvjC332QLiQsAJYRBpIgCPlU7kYIu+H120+af0uIWrs8+tAH204wkmtb+qShaD
         cr1hvXWA+zTyMCxhNqv2MYDoaex000DJtz8cpEPnsQxzeMooP3LPgu2BJYlkuERQ0ycf
         3YdrERxSWLLiNCN3H0DbxVqMtwpq4Of6vVHgJT5ODi+J2gm7CXYYour3xW/0ZIKvEgUC
         OcP6QbL34yYKxNihiKx4gEUI8MYmrwW0j1H7WUNeUasXS/r0lfu5Q2iQE8dl20yaEne1
         prJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8s9/Uokai1fVBK1q95wyRayXoafLGGfQZdaG6wUPqKQ=;
        b=50simpHNVlKqtrUORGEVffe7SPfP00a4pK7DDZFRhPuvFFpwIxg4+6QLljKAu6ZRxl
         uBMUxYMlZkgnEWKlzbHu74C5MT5APbxjZ/n/6+chDn4pNV6Mfwb+FJWDByTqxdd/MJlZ
         OBKxmtP14aTQlXeFpHTYHgPjGJ1DOSY8AjhDYr6ZzObahwBzLvyCtmeR6tv4boeKlwv5
         rovav+1ktQdEwLtqkSp9+FmQb/W8uyfjJB6B3PzIQMYV+ec9r1hpQ8nYrUKOAxU/kWbi
         M30JJJn/5Lieo9LPbfSiYfBgaywTTU7cUY+iK23Dxfbk//Y4xYczR4FVZVG0iWJUua13
         ZXzw==
X-Gm-Message-State: AJIora8cYdEgJbLGovqDuJK9bMtz8jq5qh0yO+8IilZiGi1DgjuUFTGn
        WwRLmL/B4MvCWXaqN7wl6tq2ZBDIF5f16sbKQqw=
X-Google-Smtp-Source: AGRyM1ti+WF5tVkhFL0IZGx+fNFgzaeyt5zGML3gJMfZeUZskQlVpXrBMHHwsm+I7zfdB+Y9WvUvsgMibXZgPLo20xs=
X-Received: by 2002:a05:6638:1394:b0:33c:cd0c:fae3 with SMTP id
 w20-20020a056638139400b0033ccd0cfae3mr26320633jad.124.1657135314301; Wed, 06
 Jul 2022 12:21:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220623192637.3866852-1-memxor@gmail.com> <20220623192637.3866852-2-memxor@gmail.com>
 <20220629032304.h5ck7tizbfehiwut@macbook-pro-3.dhcp.thefacebook.com>
 <CAP01T77fsU8u6GP+HXfQQ_gdu+kp3Am1+Ao-mNYULjDazHs38Q@mail.gmail.com>
 <CAP01T75cVLehQbkE3LLwSG5wVecNz0FH9QZpmzoqs-e8YKpGtg@mail.gmail.com> <20220706184436.mf7oeexxfwswgdqf@MacBook-Pro-3.local>
In-Reply-To: <20220706184436.mf7oeexxfwswgdqf@MacBook-Pro-3.local>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Thu, 7 Jul 2022 00:51:15 +0530
Message-ID: <CAP01T75-EZfdBx+W+6pV0vDDD3Qi07KVLsFTupPfptTyAFxx1Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/8] bpf: Add support for forcing kfunc args
 to be referenced
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
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

On Thu, 7 Jul 2022 at 00:14, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Jul 03, 2022 at 11:04:22AM +0530, Kumar Kartikeya Dwivedi wrote:
> > On Sun, 3 Jul 2022 at 10:54, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > >
> > > On Wed, 29 Jun 2022 at 08:53, Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Fri, Jun 24, 2022 at 12:56:30AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > > > Similar to how we detect mem, size pairs in kfunc, teach verifier to
> > > > > treat __ref suffix on argument name to imply that it must be a
> > > > > referenced pointer when passed to kfunc. This is required to ensure that
> > > > > kfunc that operate on some object only work on acquired pointers and not
> > > > > normal PTR_TO_BTF_ID with same type which can be obtained by pointer
> > > > > walking. Release functions need not specify such suffix on release
> > > > > arguments as they are already expected to receive one referenced
> > > > > argument.
> > > > >
> > > > > Note that we use strict type matching when a __ref suffix is present on
> > > > > the argument.
> > > > ...
> > > > > +             /* Check if argument must be a referenced pointer, args + i has
> > > > > +              * been verified to be a pointer (after skipping modifiers).
> > > > > +              */
> > > > > +             arg_ref = is_kfunc_arg_ref(btf, args + i);
> > > > > +             if (is_kfunc && arg_ref && !reg->ref_obj_id) {
> > > > > +                     bpf_log(log, "R%d must be referenced\n", regno);
> > > > > +                     return -EINVAL;
> > > > > +             }
> > > > > +
> > > >
> > > > imo this suffix will be confusing to use.
> > > > If I understand the intent the __ref should only be used
> > > > in acquire (and other) kfuncs that also do release.
> > > > Adding __ref to actual release kfunc will be a nop.
> > > > It will be checked, but it's not necessary.
> > > >
> > > > At the end
> > > > +struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct__ref)
> > > > will behave like kptr_xchg with exception that kptr_xchg takes any btf_id
> > > > while here it's fixed.
> > > >
> > > > The code:
> > > >  if (rel && reg->ref_obj_id)
> > > >         arg_type |= OBJ_RELEASE;
> > > > should probably be updated with '|| arg_ref'
> > > > to make sure reg->off == 0 ?
> > > > That looks like a small bug.
> > > >
> > >
> > > Indeed, I missed that. Thanks for catching it.
> > >
> > > > But stepping back... why __ref is needed ?
> > > > We can add bpf_ct_insert_entry to acq and rel sets and it should work?
> > > > I'm assuming you're doing the orthogonal cleanup of resolve_btfid,
> > > > so we will have a single kfunc set where bpf_ct_insert_entry will
> > > > have both acq and rel flags.
> > > > I'm surely missing something.
> > >
> > > It is needed to prevent the case where someone might do:
> > > ct = bpf_xdp_ct_alloc(...);
> > > bpf_ct_set_timeout(ct->master, ...);
> > >
> >
> > A better illustration is probably bpf_xdp_ct_lookup and
> > bpf_ct_change_timeout, since here the type for ct->master won't match
> > with bpf_ct_set_timeout, but the point is the same.
>
> Sorry, I'm still not following.
> Didn't we make pointer walking 'untrusted' so ct->master cannot be
> passed into any kfunc?
>

I don't believe that is the case, it is only true for kptrs loaded
from BPF maps (that too those with BPF_LDX, not the ones with
kptr_xchg). There we had a chance to do things differently. For normal
PTR_TO_BTF_ID obtained from kfuncs/BPF helpers, there is no untrusted
flag set on them, nor is it set when walking them.

I also think we discussed switching to this mode, by making many cases
untrusted by default, and using annotation to allow cases, making
pointers trusted at one level (like args for tracing/lsm progs, but
next deref becomes untrusted), but admittedly it may not cover enough
ground, and you didn't like it much either, so I stopped pursuing it.

> > > Or just obtain PTR_TO_BTF_ID by pointer walking and try to pass it in
> > > to bpf_ct_set_timeout.
> > >
> > > __ref allows an argument on a non-release kfunc to have checks like a
> > > release argument, i.e. refcounted, reg->off == 0 (var_off is already
> > > checked to be 0), so use the original pointer that was obtained from
> > > an acquire kfunc. As you noted, it isn't strictly needed on release
> > > kfunc (like bpf_ct_insert_entry) because the same checks happen for it
> > > anyway. But both timeout and status helpers should use it if they
> > > "operate" on the acquired ct (from alloc, insert, or lookup).
