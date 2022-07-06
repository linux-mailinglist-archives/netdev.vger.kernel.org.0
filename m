Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB41569456
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbiGFV3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbiGFV3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:29:07 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4AA1EADA;
        Wed,  6 Jul 2022 14:29:07 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o15so11864906pjh.1;
        Wed, 06 Jul 2022 14:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=udhuCkPitOH3CHDU61QUBRRayHKW8eKwG2SoQ0+rvF0=;
        b=QdkCLyqPAO67cOfE0yyn6qAcov18uuSq4SPI8+KW4RfTWPQwMaIpT4OfreGoVHai0N
         KuQJc+28fsA1uU6VJyEXtEFFQiLTCefHiB5hM3FLGNOQyQiCCZI8LlGtiWRhNKbqxbBD
         z1yonSRVS09aa5XboYP3zjeLR9BEDbRn/SnqSYMUa8YdtT6AvJ3DUW32YiUZ5VtP2p/C
         5W2JnWnDH2+k2j0h5Vb+F/1460ZUm0BdFaFtWQ///isY74Dh8Jxm4m51mAiRTkZFuuID
         etkr+852cBdXQ4Fd06GVOps7wP7IfFhLRfBS1QMO7rZfQelqeqsDPkZq+XFX1kxoapwP
         T3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=udhuCkPitOH3CHDU61QUBRRayHKW8eKwG2SoQ0+rvF0=;
        b=tesoK/9HjOrdFQjP2b4XduNK4EF3GfrZIAWgC/Cp6ZHF0b7Utf/K5J9o8GjPW6fkq0
         uPBBZ6Y+khjPu0e/V+XDkXH+hzGHE7bZZ+6AWQkkeoigoPi8ImJ5GD9g2iIh6WfLvnBb
         EWRDMsqXsP2d+5HQyin01EIpqPbS2A2s5xxi44aIKuDmy+8CV0rDOrJsq4xpo7rU6pe8
         6LLsUQxxyKhn6byPi5hacT4gM2Ne6Zw7B1UK//gvdGJcUbNHD1EWIqT1sLJx7Pbhs3Ht
         OemO9Ag4DlTK8sG89C2JuA1CdOWG2Fuf8ij2Ow839SsmgUC8naEqj7/Dmddr8sW6liWG
         auIQ==
X-Gm-Message-State: AJIora/c5vVZlrFKSkdLbqGngpSkdo25sCdK5Zai7saxijZnX9y+4oeF
        eeLxcAzp/iMRFT+2ln02rfU=
X-Google-Smtp-Source: AGRyM1ufykB0P1yFUIA5SiKBLy/Kp4hUKCRSzBQTMXvWjrJ4NwjJLQUKt9cbgPJAyPeQgmk/JWoLsQ==
X-Received: by 2002:a17:90b:4fc1:b0:1ef:bd2c:696e with SMTP id qa1-20020a17090b4fc100b001efbd2c696emr830924pjb.45.1657142946503;
        Wed, 06 Jul 2022 14:29:06 -0700 (PDT)
Received: from MacBook-Pro-3.local ([2620:10d:c090:500::2:8597])
        by smtp.gmail.com with ESMTPSA id n7-20020aa79847000000b00528aad783dcsm2037574pfq.15.2022.07.06.14.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 14:29:05 -0700 (PDT)
Date:   Wed, 6 Jul 2022 14:29:03 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 1/8] bpf: Add support for forcing kfunc args
 to be referenced
Message-ID: <20220706212903.az2mtqodtzmn2gwq@MacBook-Pro-3.local>
References: <20220623192637.3866852-1-memxor@gmail.com>
 <20220623192637.3866852-2-memxor@gmail.com>
 <20220629032304.h5ck7tizbfehiwut@macbook-pro-3.dhcp.thefacebook.com>
 <CAP01T77fsU8u6GP+HXfQQ_gdu+kp3Am1+Ao-mNYULjDazHs38Q@mail.gmail.com>
 <CAP01T75cVLehQbkE3LLwSG5wVecNz0FH9QZpmzoqs-e8YKpGtg@mail.gmail.com>
 <20220706184436.mf7oeexxfwswgdqf@MacBook-Pro-3.local>
 <CAP01T75-EZfdBx+W+6pV0vDDD3Qi07KVLsFTupPfptTyAFxx1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP01T75-EZfdBx+W+6pV0vDDD3Qi07KVLsFTupPfptTyAFxx1Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 12:51:15AM +0530, Kumar Kartikeya Dwivedi wrote:
> On Thu, 7 Jul 2022 at 00:14, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Sun, Jul 03, 2022 at 11:04:22AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > On Sun, 3 Jul 2022 at 10:54, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > > >
> > > > On Wed, 29 Jun 2022 at 08:53, Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Fri, Jun 24, 2022 at 12:56:30AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > > > > Similar to how we detect mem, size pairs in kfunc, teach verifier to
> > > > > > treat __ref suffix on argument name to imply that it must be a
> > > > > > referenced pointer when passed to kfunc. This is required to ensure that
> > > > > > kfunc that operate on some object only work on acquired pointers and not
> > > > > > normal PTR_TO_BTF_ID with same type which can be obtained by pointer
> > > > > > walking. Release functions need not specify such suffix on release
> > > > > > arguments as they are already expected to receive one referenced
> > > > > > argument.
> > > > > >
> > > > > > Note that we use strict type matching when a __ref suffix is present on
> > > > > > the argument.
> > > > > ...
> > > > > > +             /* Check if argument must be a referenced pointer, args + i has
> > > > > > +              * been verified to be a pointer (after skipping modifiers).
> > > > > > +              */
> > > > > > +             arg_ref = is_kfunc_arg_ref(btf, args + i);
> > > > > > +             if (is_kfunc && arg_ref && !reg->ref_obj_id) {
> > > > > > +                     bpf_log(log, "R%d must be referenced\n", regno);
> > > > > > +                     return -EINVAL;
> > > > > > +             }
> > > > > > +
> > > > >
> > > > > imo this suffix will be confusing to use.
> > > > > If I understand the intent the __ref should only be used
> > > > > in acquire (and other) kfuncs that also do release.
> > > > > Adding __ref to actual release kfunc will be a nop.
> > > > > It will be checked, but it's not necessary.
> > > > >
> > > > > At the end
> > > > > +struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct__ref)
> > > > > will behave like kptr_xchg with exception that kptr_xchg takes any btf_id
> > > > > while here it's fixed.
> > > > >
> > > > > The code:
> > > > >  if (rel && reg->ref_obj_id)
> > > > >         arg_type |= OBJ_RELEASE;
> > > > > should probably be updated with '|| arg_ref'
> > > > > to make sure reg->off == 0 ?
> > > > > That looks like a small bug.
> > > > >
> > > >
> > > > Indeed, I missed that. Thanks for catching it.
> > > >
> > > > > But stepping back... why __ref is needed ?
> > > > > We can add bpf_ct_insert_entry to acq and rel sets and it should work?
> > > > > I'm assuming you're doing the orthogonal cleanup of resolve_btfid,
> > > > > so we will have a single kfunc set where bpf_ct_insert_entry will
> > > > > have both acq and rel flags.
> > > > > I'm surely missing something.
> > > >
> > > > It is needed to prevent the case where someone might do:
> > > > ct = bpf_xdp_ct_alloc(...);
> > > > bpf_ct_set_timeout(ct->master, ...);
> > > >
> > >
> > > A better illustration is probably bpf_xdp_ct_lookup and
> > > bpf_ct_change_timeout, since here the type for ct->master won't match
> > > with bpf_ct_set_timeout, but the point is the same.
> >
> > Sorry, I'm still not following.
> > Didn't we make pointer walking 'untrusted' so ct->master cannot be
> > passed into any kfunc?
> >
> 
> I don't believe that is the case, it is only true for kptrs loaded
> from BPF maps (that too those with BPF_LDX, not the ones with
> kptr_xchg). There we had a chance to do things differently. For normal
> PTR_TO_BTF_ID obtained from kfuncs/BPF helpers, there is no untrusted
> flag set on them, nor is it set when walking them.
> 
> I also think we discussed switching to this mode, by making many cases
> untrusted by default, and using annotation to allow cases, making
> pointers trusted at one level (like args for tracing/lsm progs, but
> next deref becomes untrusted), but admittedly it may not cover enough
> ground, and you didn't like it much either, so I stopped pursuing it.

Ahh. Now I remember. Thanks for reminding :)
Could you please summarize this thread and add all of it as a big comment
in the source code next to __ref handling to explain the motivation
and an example on when and how this __ref suffix should be used.
Otherwise somebody, like me, will forget the context soon.

I was thinking of better name than __ref, but couldn't come up with one.
__ref fits this use case the best.
