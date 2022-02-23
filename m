Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E694C1E02
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 22:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242470AbiBWVxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 16:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiBWVxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 16:53:23 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C283D4A1;
        Wed, 23 Feb 2022 13:52:55 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 132so7693pga.5;
        Wed, 23 Feb 2022 13:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gXGApdCCkLLJU3lWOlSSJO79UnPt9wOKOFtUSzHhqkQ=;
        b=HR8mwc4RStBmg/lPZ2Wp4KAU3bQJ+wvNsZ1hQtoW98eO4xff9yIJCpYRwmDp7Jgdnm
         pJJZi4PigXgsxw85PMdWTpELCcqhgBPVqxv1RipxvOlpBLKUY+sRKaA0LxoMmpfeZdGV
         BoTQNBQ4rxoXqK9i6XyTtrolNl9msAVhV96tiRl3YJrebDJeL56IDgX/6/Q6SQhlv0iQ
         SG+XIUngtPH0UpS6T2o+Slb8p9dIM5rgnztjaMa3iTPX4uh0P0Haiq/qVHLAJ+BwlFFI
         cBmJhFOmwCcsHe3ceMy9KKz+YdinKxWJtdZHKTkhRA17yYSgeTlV0Xo4ltGVjWU115dj
         Xfyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gXGApdCCkLLJU3lWOlSSJO79UnPt9wOKOFtUSzHhqkQ=;
        b=i3bws+ELZG40JWc2MtElhlNKfIcNapg67as9moyaTHDCvyPYge9Ca0skA9XYkP15kZ
         mq3h1TSRomI3rqNwrvj7Mm7K1ZGw0SguHeNYSWo8eKcxAnENTDF/IJ4AAWc9OXmu7NnJ
         mvwScAxIuYEP/jviGK77TGKSj6OGmtRlawXhKEGwt/5Gy8h7PN8eIQ2OdFkAoMQGVuoz
         ++gKVU3X+VBOScGI5gksxN05aiTUuFa4WGf9uummato/AR1C3AzsLf0nATREhQ9e/bcr
         3IwwxZ509JP4PfdAtX/3qWML5yCPuvrQPqdv9leVTPULP8YTiabusUMljRYNmyk0RYKm
         Y27g==
X-Gm-Message-State: AOAM5307LL/W42VY1tvTu4Z3XrJu5wLlvnBZlBwjj8I5aw9tyAKfnETY
        A0cv+bmjbUfmCYAMyiGZKYAuYWi8BLUZKIlF7sk=
X-Google-Smtp-Source: ABdhPJy9Ner6v03TtXVxjONuOPQpO6/F6xh4gxQws0cozma7eIgHXcDBJDqPBqY5h+1zFGg9Q8eT0sNbpFEeQJtp9Ck=
X-Received: by 2002:a63:3481:0:b0:372:f3e7:6f8c with SMTP id
 b123-20020a633481000000b00372f3e76f8cmr1304605pga.336.1645653174772; Wed, 23
 Feb 2022 13:52:54 -0800 (PST)
MIME-Version: 1.0
References: <20220220134813.3411982-1-memxor@gmail.com> <20220220134813.3411982-5-memxor@gmail.com>
 <20220222065349.ladxy5cqfpdklk3a@ast-mbp.dhcp.thefacebook.com>
 <20220222071026.fqdjmd5fhjbl56xl@apollo.legion> <CAADnVQLba_X7fZczY774+1GGrGcC5sopD5pzMaDK_O8P+Aeyig@mail.gmail.com>
 <20220223030447.ugwjlfjiqynntbgj@apollo.legion>
In-Reply-To: <20220223030447.ugwjlfjiqynntbgj@apollo.legion>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 23 Feb 2022 13:52:43 -0800
Message-ID: <CAADnVQ+vKtE7_RHAMcc73aL+6XZMir_3tcCOxGaz_0sWiRQiOA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 04/15] bpf: Allow storing referenced
 PTR_TO_BTF_ID in map
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
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

On Tue, Feb 22, 2022 at 7:04 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Tue, Feb 22, 2022 at 09:50:00PM IST, Alexei Starovoitov wrote:
> > On Mon, Feb 21, 2022 at 11:10 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > On Tue, Feb 22, 2022 at 12:23:49PM IST, Alexei Starovoitov wrote:
> > > > On Sun, Feb 20, 2022 at 07:18:02PM +0530, Kumar Kartikeya Dwivedi wrote:
> > > > >  static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regno,
> > > > >                         int off, int bpf_size, enum bpf_access_type t,
> > > > > -                       int value_regno, bool strict_alignment_once)
> > > > > +                       int value_regno, bool strict_alignment_once,
> > > > > +                       struct bpf_reg_state *atomic_load_reg)
> > > >
> > > > No new side effects please.
> > > > value_regno is not pretty already.
> > > > At least its known ugliness that we need to clean up one day.
> > > >
> > > > >  static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_insn *insn)
> > > > >  {
> > > > > +   struct bpf_reg_state atomic_load_reg;
> > > > >     int load_reg;
> > > > >     int err;
> > > > >
> > > > > +   __mark_reg_unknown(env, &atomic_load_reg);
> > > > > +
> > > > >     switch (insn->imm) {
> > > > >     case BPF_ADD:
> > > > >     case BPF_ADD | BPF_FETCH:
> > > > > @@ -4813,6 +4894,7 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
> > > > >             else
> > > > >                     load_reg = insn->src_reg;
> > > > >
> > > > > +           atomic_load_reg = *reg_state(env, load_reg);
> > > > >             /* check and record load of old value */
> > > > >             err = check_reg_arg(env, load_reg, DST_OP);
> > > > >             if (err)
> > > > > @@ -4825,20 +4907,21 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
> > > > >     }
> > > > >
> > > > >     /* Check whether we can read the memory, with second call for fetch
> > > > > -    * case to simulate the register fill.
> > > > > +    * case to simulate the register fill, which also triggers checks
> > > > > +    * for manipulation of BTF ID pointers embedded in BPF maps.
> > > > >      */
> > > > >     err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
> > > > > -                          BPF_SIZE(insn->code), BPF_READ, -1, true);
> > > > > +                          BPF_SIZE(insn->code), BPF_READ, -1, true, NULL);
> > > > >     if (!err && load_reg >= 0)
> > > > >             err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
> > > > >                                    BPF_SIZE(insn->code), BPF_READ, load_reg,
> > > > > -                                  true);
> > > > > +                                  true, load_reg >= 0 ? &atomic_load_reg : NULL);
> > > >
> > > > Special xchg logic should be down outside of check_mem_access()
> > > > instead of hidden by layers of calls.
> > >
> > > Right, it's ugly, but if we don't capture the reg state before that
> > > check_reg_arg(env, load_reg, DST_OP), it's not possible to see the actual
> > > PTR_TO_BTF_ID being moved into the map, since check_reg_arg will do a
> > > mark_reg_unknown for value_regno. Any other ideas on what I can do?
> > >
> > > 37086bfdc737 ("bpf: Propagate stack bounds to registers in atomics w/ BPF_FETCH")
> > > changed the order of check_mem_access and DST_OP check_reg_arg.
> >
> > That highlights my point that side effects are bad.
> > That commit tries to work around that behavior and makes things
> > harder to extend like you found out with xchg logic.
> > Another option would be to add bpf_kptr_xchg() helper
> > instead of dealing with insn. It will be tiny bit slower,
> > but it will work on all architectures. While xchg bpf jit is
> > on x86,s390,mips so far.
>
> Right, but kfunc is currently limited to x86, which is required to obtain a
> refcounted PTR_TO_BTF_ID that you can move into the map, so it wouldn't make
> much of a difference.

Well the patches to add trampoline support to powerpc were already posted.

> > We need to think more on how to refactor check_mem_acess without
> > digging ourselves into an even bigger hole.
>
> So I'm ok with working on untangling check_mem_access as a follow up, but for
> now should we go forward with how it is? Just looking at it yesterday makes me
> think it's going to require a fair amount of refactoring and discussion.
>
> Also, do you have any ideas on how to change it? Do you want it to work like how
> is_valid_access callbacks work? So passing something like a bpf_insn_access_aux
> into the call, where it sets how it'd like to update the register, and then
> actual updates take place in caller context?

I don't like callbacks in general.
They're fine for walk_the_tree, for_each_elem accessors,
but passing a callback into check_mem_access is not great.
Do you mind going with a bpf_kptr_xchg() helper for now
and optimizing into direct xchg insn later?
It's not clear whether it's going to be faster to be noticeable.
