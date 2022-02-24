Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0729D4C267D
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 09:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbiBXIoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 03:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiBXIn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 03:43:56 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119E4546A0;
        Thu, 24 Feb 2022 00:43:26 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id d187so1242565pfa.10;
        Thu, 24 Feb 2022 00:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DGXjlcc+X0sRfKyRVlLE2UGPc34DxTor0AEsPttBRek=;
        b=D+PLMxcc8lINE6mpuwuY1VfenkvrJfJnOaAujRcYieS/rOtaxJ3jb1cRjPfYTPY/4y
         KMpoUKix63+bVmTBzzpfx/Fm3fPFJs3iw8eC8cOzVdmaRFW9NwWVovZ9IzuYhLUxqopv
         3TazpJjWh5jJin7dAvajs3POa1Xqquy6uXljMZzCSKL8ELB2JB6FNwMYmpDI92TLF7AI
         Jm/FXzeh7kFA8/eG+e8MAYyzryptjB2JQjdAJQJtAdHaRbhFYnwkEBqHN+qo3VEDSEhN
         HeewN0OjZV84MZsyBw43npT7OmHY18+u5O43j9i1uk1+taDbgRohdz0WsBzhDVvq2+7U
         xIYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DGXjlcc+X0sRfKyRVlLE2UGPc34DxTor0AEsPttBRek=;
        b=75W8qZqZDhCWwtDmhD57KiWbTaVFeksNHbFZ6tC/05oLXDrRrNlVQeklXI/EkSkb1E
         s1dAn/UaykEGGVkS5QITJPoC5bAdj8QdmzIOuGUeb06VOHTBPOWhP1H/ILsJpvQpOIp0
         SC479XhHC9eCAubH5kyd2ccg7fU9FQM7S9JtKKQ5HeMJTGeSU8HMfU1QW8aY4Ak7SEhg
         jpdVpvDXVvubFAraY4+k8b8AEQ6oE9P7nZqouZ/xf77xEPTSbxPgFNF+fXCPYkxsIGLu
         GcMRH7uDF3LGKagtvAlyeZqI25+VQomtamgaJBzorA75PCoeP+lpp/sS9Vuxs6hvZSAO
         lIIQ==
X-Gm-Message-State: AOAM531NWhJGLbVjn5VmC//M/VxC3DEf9Y+3VE8/AQYy4hwaREuM7oXo
        XgSF74+AnPNObuCFHgl8BBE=
X-Google-Smtp-Source: ABdhPJy3utqnYppxVF8zQ3qjoHKCNxlEqERdaX/VdiVHrzuJvrihVrYzj8EoMG1dG+Kv4S0G6Qtqcg==
X-Received: by 2002:a65:64d1:0:b0:374:9f3f:d8f5 with SMTP id t17-20020a6564d1000000b003749f3fd8f5mr1482527pgv.186.1645692205360;
        Thu, 24 Feb 2022 00:43:25 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id o3sm2580462pfu.50.2022.02.24.00.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 00:43:25 -0800 (PST)
Date:   Thu, 24 Feb 2022 14:13:22 +0530
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
Message-ID: <20220224084322.vmyvusyukanc6z45@apollo.legion>
References: <20220220134813.3411982-1-memxor@gmail.com>
 <20220220134813.3411982-5-memxor@gmail.com>
 <20220222065349.ladxy5cqfpdklk3a@ast-mbp.dhcp.thefacebook.com>
 <20220222071026.fqdjmd5fhjbl56xl@apollo.legion>
 <CAADnVQLba_X7fZczY774+1GGrGcC5sopD5pzMaDK_O8P+Aeyig@mail.gmail.com>
 <20220223030447.ugwjlfjiqynntbgj@apollo.legion>
 <CAADnVQ+vKtE7_RHAMcc73aL+6XZMir_3tcCOxGaz_0sWiRQiOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+vKtE7_RHAMcc73aL+6XZMir_3tcCOxGaz_0sWiRQiOA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 03:22:43AM IST, Alexei Starovoitov wrote:
> On Tue, Feb 22, 2022 at 7:04 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Tue, Feb 22, 2022 at 09:50:00PM IST, Alexei Starovoitov wrote:
> > > On Mon, Feb 21, 2022 at 11:10 PM Kumar Kartikeya Dwivedi
> > > <memxor@gmail.com> wrote:
> > > >
> > > > On Tue, Feb 22, 2022 at 12:23:49PM IST, Alexei Starovoitov wrote:
> > > > > On Sun, Feb 20, 2022 at 07:18:02PM +0530, Kumar Kartikeya Dwivedi wrote:
> > > > > >  static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regno,
> > > > > >                         int off, int bpf_size, enum bpf_access_type t,
> > > > > > -                       int value_regno, bool strict_alignment_once)
> > > > > > +                       int value_regno, bool strict_alignment_once,
> > > > > > +                       struct bpf_reg_state *atomic_load_reg)
> > > > >
> > > > > No new side effects please.
> > > > > value_regno is not pretty already.
> > > > > At least its known ugliness that we need to clean up one day.
> > > > >
> > > > > >  static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_insn *insn)
> > > > > >  {
> > > > > > +   struct bpf_reg_state atomic_load_reg;
> > > > > >     int load_reg;
> > > > > >     int err;
> > > > > >
> > > > > > +   __mark_reg_unknown(env, &atomic_load_reg);
> > > > > > +
> > > > > >     switch (insn->imm) {
> > > > > >     case BPF_ADD:
> > > > > >     case BPF_ADD | BPF_FETCH:
> > > > > > @@ -4813,6 +4894,7 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
> > > > > >             else
> > > > > >                     load_reg = insn->src_reg;
> > > > > >
> > > > > > +           atomic_load_reg = *reg_state(env, load_reg);
> > > > > >             /* check and record load of old value */
> > > > > >             err = check_reg_arg(env, load_reg, DST_OP);
> > > > > >             if (err)
> > > > > > @@ -4825,20 +4907,21 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
> > > > > >     }
> > > > > >
> > > > > >     /* Check whether we can read the memory, with second call for fetch
> > > > > > -    * case to simulate the register fill.
> > > > > > +    * case to simulate the register fill, which also triggers checks
> > > > > > +    * for manipulation of BTF ID pointers embedded in BPF maps.
> > > > > >      */
> > > > > >     err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
> > > > > > -                          BPF_SIZE(insn->code), BPF_READ, -1, true);
> > > > > > +                          BPF_SIZE(insn->code), BPF_READ, -1, true, NULL);
> > > > > >     if (!err && load_reg >= 0)
> > > > > >             err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
> > > > > >                                    BPF_SIZE(insn->code), BPF_READ, load_reg,
> > > > > > -                                  true);
> > > > > > +                                  true, load_reg >= 0 ? &atomic_load_reg : NULL);
> > > > >
> > > > > Special xchg logic should be down outside of check_mem_access()
> > > > > instead of hidden by layers of calls.
> > > >
> > > > Right, it's ugly, but if we don't capture the reg state before that
> > > > check_reg_arg(env, load_reg, DST_OP), it's not possible to see the actual
> > > > PTR_TO_BTF_ID being moved into the map, since check_reg_arg will do a
> > > > mark_reg_unknown for value_regno. Any other ideas on what I can do?
> > > >
> > > > 37086bfdc737 ("bpf: Propagate stack bounds to registers in atomics w/ BPF_FETCH")
> > > > changed the order of check_mem_access and DST_OP check_reg_arg.
> > >
> > > That highlights my point that side effects are bad.
> > > That commit tries to work around that behavior and makes things
> > > harder to extend like you found out with xchg logic.
> > > Another option would be to add bpf_kptr_xchg() helper
> > > instead of dealing with insn. It will be tiny bit slower,
> > > but it will work on all architectures. While xchg bpf jit is
> > > on x86,s390,mips so far.
> >
> > Right, but kfunc is currently limited to x86, which is required to obtain a
> > refcounted PTR_TO_BTF_ID that you can move into the map, so it wouldn't make
> > much of a difference.
>
> Well the patches to add trampoline support to powerpc were already posted.
>
> > > We need to think more on how to refactor check_mem_acess without
> > > digging ourselves into an even bigger hole.
> >
> > So I'm ok with working on untangling check_mem_access as a follow up, but for
> > now should we go forward with how it is? Just looking at it yesterday makes me
> > think it's going to require a fair amount of refactoring and discussion.
> >
> > Also, do you have any ideas on how to change it? Do you want it to work like how
> > is_valid_access callbacks work? So passing something like a bpf_insn_access_aux
> > into the call, where it sets how it'd like to update the register, and then
> > actual updates take place in caller context?
>
> I don't like callbacks in general.
> They're fine for walk_the_tree, for_each_elem accessors,
> but passing a callback into check_mem_access is not great.

I didn't mean passing a callback, I meant passing a struct like you mentioned in
a previous comment to another patch (btf_field_info) where we can set state that
must be updated for the register, and then updates are done by the caller, to
separate the 'side effects' from the other checks. is_valid_access verifier
callback receive a similar bpf_insn_access_aux parameter which is then used to
update register state.

> Do you mind going with a bpf_kptr_xchg() helper for now
> and optimizing into direct xchg insn later?

I don't have a problem with that. I just didn't see any advantages (except the
wider architecture support that you pointed out). We still have to special case
some places in check_helper_call (since it needs to transfer R1's btf_id to R0,
and work with all PTR_TO_BTF_ID, not just 1), so the implementation is similar.

I guess for most usecases it wouldn't matter much.

> It's not clear whether it's going to be faster to be noticeable.

Just for curiosity, I measured a loop of 5000 xchg ops, one with bpf_xchg, one
with bpf_kptr_xchg. This is the simple case (uncontended, raw cost of both
operations) xchg insn is at ~4 nsecs, bpf_kptr_xchg is at ~8 nsecs (single
socket 8 core Intel i5 @ 2.5GHz). I'm guessing in a complicated case spill/fill
of caller saved regs will also come into play for the helper case.

--
Kartikeya
