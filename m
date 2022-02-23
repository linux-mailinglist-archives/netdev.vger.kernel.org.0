Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE264C09E7
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 04:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235946AbiBWDFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 22:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237814AbiBWDFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 22:05:18 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEE0580D8;
        Tue, 22 Feb 2022 19:04:51 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id m22so1487326pja.0;
        Tue, 22 Feb 2022 19:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PMrqZxiS0watDAe+/4XF02fqh0CK2tKMQlLPhoYf6Wk=;
        b=RhfYAbkpylmxjsosh7CayJki71YjYufxvC0SOraaF/Pr5EafQw4/WwtjukFtYCh4zh
         mKfGU+yLEXMJOTyYNYN/CgkfnqGkh2Kycq9xG+GkksnFypeoGuwrwwySBvjV0U63GE6R
         f98iIRQSVH6J1oZ5bC9Y00oMd8ZtYbghu+semUI9tN4pEpKYRQiWyJWRNQq1syEa/xnL
         fDchZClr19TnP3w2UPtuSjVfySRXFBzdIgD2ii0Own6yo0gfPK+2iOWe+fE26Mh701Zi
         nY5nU6KMC0cWf72G+n7vlzqo7mJZpnc+0nTbwfFGzdXwtRqxbGUvQzCAoIQsyXXdBGKh
         Ylow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PMrqZxiS0watDAe+/4XF02fqh0CK2tKMQlLPhoYf6Wk=;
        b=BtxxXxoj3abASvR/CAnM3ziT6oO9Ta5HWLZp2GvAQsDCPkl7laRyvvQn3e4sAsjoQH
         faBvY08s1wnftRhfBPr4IWxhSvAznPR8TR5N/DlG2foQy6/HaLQl5TjVOm9sP00MnXLr
         JR1UNlMt/+NuW0A/f0hDKWE7xctO5poELhLKSD15osqMMbg08plneN7lEHlIJwf2vJcN
         X6fAN8wVcRgCZ26WH2eZJJ0ab4ukPlwPVcIEui6FAfL4ohSrQp1cS/pg0WmYcdKKZ3fw
         E1hKzGNEbT3aHWNLhetX4GmSMyr+7i8f9xel7ZpwJz7Aen50LSJeD8zlDe4lUPnZFEbj
         yxdw==
X-Gm-Message-State: AOAM530h/K5NGx2+votqVfHqSJFgXWbpA+rx8Eo6dzuPmLiehFbcadKJ
        vzHF9T8Z7n1tZd1A8dkynW3g99OLNkc=
X-Google-Smtp-Source: ABdhPJxbDw7Bez87vV6FICxachpNlnKU/haGTEcSoVfBdJ+Ztxo4A87pKcslU09O/i6eZaDFeuP4Bg==
X-Received: by 2002:a17:90b:47c4:b0:1b9:b213:5f7b with SMTP id kc4-20020a17090b47c400b001b9b2135f7bmr7158689pjb.86.1645585491104;
        Tue, 22 Feb 2022 19:04:51 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id lt8-20020a17090b354800b001bc509e0085sm1056316pjb.21.2022.02.22.19.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 19:04:50 -0800 (PST)
Date:   Wed, 23 Feb 2022 08:34:47 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 04/15] bpf: Allow storing referenced
 PTR_TO_BTF_ID in map
Message-ID: <20220223030447.ugwjlfjiqynntbgj@apollo.legion>
References: <20220220134813.3411982-1-memxor@gmail.com>
 <20220220134813.3411982-5-memxor@gmail.com>
 <20220222065349.ladxy5cqfpdklk3a@ast-mbp.dhcp.thefacebook.com>
 <20220222071026.fqdjmd5fhjbl56xl@apollo.legion>
 <CAADnVQLba_X7fZczY774+1GGrGcC5sopD5pzMaDK_O8P+Aeyig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLba_X7fZczY774+1GGrGcC5sopD5pzMaDK_O8P+Aeyig@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 09:50:00PM IST, Alexei Starovoitov wrote:
> On Mon, Feb 21, 2022 at 11:10 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Tue, Feb 22, 2022 at 12:23:49PM IST, Alexei Starovoitov wrote:
> > > On Sun, Feb 20, 2022 at 07:18:02PM +0530, Kumar Kartikeya Dwivedi wrote:
> > > >  static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regno,
> > > >                         int off, int bpf_size, enum bpf_access_type t,
> > > > -                       int value_regno, bool strict_alignment_once)
> > > > +                       int value_regno, bool strict_alignment_once,
> > > > +                       struct bpf_reg_state *atomic_load_reg)
> > >
> > > No new side effects please.
> > > value_regno is not pretty already.
> > > At least its known ugliness that we need to clean up one day.
> > >
> > > >  static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_insn *insn)
> > > >  {
> > > > +   struct bpf_reg_state atomic_load_reg;
> > > >     int load_reg;
> > > >     int err;
> > > >
> > > > +   __mark_reg_unknown(env, &atomic_load_reg);
> > > > +
> > > >     switch (insn->imm) {
> > > >     case BPF_ADD:
> > > >     case BPF_ADD | BPF_FETCH:
> > > > @@ -4813,6 +4894,7 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
> > > >             else
> > > >                     load_reg = insn->src_reg;
> > > >
> > > > +           atomic_load_reg = *reg_state(env, load_reg);
> > > >             /* check and record load of old value */
> > > >             err = check_reg_arg(env, load_reg, DST_OP);
> > > >             if (err)
> > > > @@ -4825,20 +4907,21 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
> > > >     }
> > > >
> > > >     /* Check whether we can read the memory, with second call for fetch
> > > > -    * case to simulate the register fill.
> > > > +    * case to simulate the register fill, which also triggers checks
> > > > +    * for manipulation of BTF ID pointers embedded in BPF maps.
> > > >      */
> > > >     err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
> > > > -                          BPF_SIZE(insn->code), BPF_READ, -1, true);
> > > > +                          BPF_SIZE(insn->code), BPF_READ, -1, true, NULL);
> > > >     if (!err && load_reg >= 0)
> > > >             err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
> > > >                                    BPF_SIZE(insn->code), BPF_READ, load_reg,
> > > > -                                  true);
> > > > +                                  true, load_reg >= 0 ? &atomic_load_reg : NULL);
> > >
> > > Special xchg logic should be down outside of check_mem_access()
> > > instead of hidden by layers of calls.
> >
> > Right, it's ugly, but if we don't capture the reg state before that
> > check_reg_arg(env, load_reg, DST_OP), it's not possible to see the actual
> > PTR_TO_BTF_ID being moved into the map, since check_reg_arg will do a
> > mark_reg_unknown for value_regno. Any other ideas on what I can do?
> >
> > 37086bfdc737 ("bpf: Propagate stack bounds to registers in atomics w/ BPF_FETCH")
> > changed the order of check_mem_access and DST_OP check_reg_arg.
>
> That highlights my point that side effects are bad.
> That commit tries to work around that behavior and makes things
> harder to extend like you found out with xchg logic.
> Another option would be to add bpf_kptr_xchg() helper
> instead of dealing with insn. It will be tiny bit slower,
> but it will work on all architectures. While xchg bpf jit is
> on x86,s390,mips so far.

Right, but kfunc is currently limited to x86, which is required to obtain a
refcounted PTR_TO_BTF_ID that you can move into the map, so it wouldn't make
much of a difference.

> We need to think more on how to refactor check_mem_acess without
> digging ourselves into an even bigger hole.

So I'm ok with working on untangling check_mem_access as a follow up, but for
now should we go forward with how it is? Just looking at it yesterday makes me
think it's going to require a fair amount of refactoring and discussion.

Also, do you have any ideas on how to change it? Do you want it to work like how
is_valid_access callbacks work? So passing something like a bpf_insn_access_aux
into the call, where it sets how it'd like to update the register, and then
actual updates take place in caller context?

--
Kartikeya
