Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FE928569F
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 04:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgJGCSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 22:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgJGCSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 22:18:46 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26F3C061755;
        Tue,  6 Oct 2020 19:18:45 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s19so232795plp.3;
        Tue, 06 Oct 2020 19:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qzK2CQRWv87jy1mjNO34cYBzbGptSb8SbqaMjxbGxO0=;
        b=XsnyntYaqaFbMgpKWrU0ulwUaXdUrsE/YlELYvjbKWfWDPVRqDWWjkT9M4Zm8FII0W
         Zf/kxPHXIIKhl/8GTf+aZeHBVn+mzEL1f7cJtBoO79q2uNN9gAyTAQQCWP+Oy7vlr19U
         rXxbn5SKTlUbfg0c2kdWmXF+jVAZWcNlxoeOnwx38jSGTkpeMqmjfKMBCbCvCRS3qx/X
         83ZhX52mI8WHPZSSSTwoJWLf28Q1rQEMKQZjnQ0L42Bfi52PGd2sQLCq7flfvjOSf2/B
         u4HZEUTQwWfeH4CqAeRjurgtaIiNyhXSKySk6JOt/xvnhIqm2kydo+JAu54OMDM5K/NS
         HHog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qzK2CQRWv87jy1mjNO34cYBzbGptSb8SbqaMjxbGxO0=;
        b=tLpE1Bv1ZYuSe28edgINc4xueLIkZUSyuptrfVndSIH8AjFDpmTzw8yvsCXB7MwbcJ
         CQ77B62/LgW84xlCEpvpuvlwp+KKOG90o7IWWTB23M3DiHCjVPLvrUXawFJZdLvORfCK
         y+3fBfiyoTDTWc10yno7OwOtnjTxaZJ9vo5z6QRU8INQ1z/YecvKMINSgJJa0l0jhhkr
         gNrn9zctwDjjSOskV96DG+OKKf7ZjcyqZ790udLFUNHDvSoPMqOMisQCnOJ+RxR1nNnQ
         8t+gEnrk2j5jt4TsHK6yEXbb0mdbjCHBUeN/B5CEMMFuk+a5rheEd1BYqGN93l5h90nP
         ZO+g==
X-Gm-Message-State: AOAM533kDcp9egypcfRs7dEmTY/g9druzvQBu9i1qFHhj23jGHH9xfwr
        80WyZT2sbkXv9XCkPl6qhoInJ1KV2k4=
X-Google-Smtp-Source: ABdhPJzjhsDaXVc9iye9OfHMg75CGswnHGgfFq3bBXcejIVz1r+KkrtKIAOFfVZUxf+HIWSgAtbxaw==
X-Received: by 2002:a17:90b:3581:: with SMTP id mm1mr925704pjb.180.1602037125258;
        Tue, 06 Oct 2020 19:18:45 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:9c77])
        by smtp.gmail.com with ESMTPSA id f9sm327536pjq.26.2020.10.06.19.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 19:18:44 -0700 (PDT)
Date:   Tue, 6 Oct 2020 19:18:42 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Propagate scalar ranges through
 register assignments.
Message-ID: <20201007021842.2lwngvsvj2hbuzh5@ast-mbp>
References: <20201006200955.12350-1-alexei.starovoitov@gmail.com>
 <20201006200955.12350-2-alexei.starovoitov@gmail.com>
 <CAEf4BzbRLLJ=r3LJfQbkkXtXgNqQL3Sr01ibhOaxNN-QDqiXdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbRLLJ=r3LJfQbkkXtXgNqQL3Sr01ibhOaxNN-QDqiXdw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 06:56:14PM -0700, Andrii Nakryiko wrote:
> On Tue, Oct 6, 2020 at 1:14 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > The llvm register allocator may use two different registers representing the
> > same virtual register. In such case the following pattern can be observed:
> > 1047: (bf) r9 = r6
> > 1048: (a5) if r6 < 0x1000 goto pc+1
> > 1050: ...
> > 1051: (a5) if r9 < 0x2 goto pc+66
> > 1052: ...
> > 1053: (bf) r2 = r9 /* r2 needs to have upper and lower bounds */
> >
> > In order to track this information without backtracking allocate ID
> > for scalars in a similar way as it's done for find_good_pkt_pointers().
> >
> > When the verifier encounters r9 = r6 assignment it will assign the same ID
> > to both registers. Later if either register range is narrowed via conditional
> > jump propagate the register state into the other register.
> >
> > Clear register ID in adjust_reg_min_max_vals() for any alu instruction.
> >
> > Newly allocated register ID is ignored for scalars in regsafe() and doesn't
> > affect state pruning. mark_reg_unknown() also clears the ID.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> 
> I couldn't find the problem with the logic, though it's quite
> non-obvious at times that reg->id will be cleared on BPF_END/BPF_NEG
> and few other operations. But I think naming of this function can be
> improved, see below.
> 
> Also, profiler.c is great, but it would still be nice to add selftest
> to test_verifier that will explicitly test the logic in this patch

the test align.c actualy does the id checking better than I expected.
I'm planning to add more asm tests in the follow up.

> >  kernel/bpf/verifier.c                         | 38 +++++++++++++++++++
> >  .../testing/selftests/bpf/prog_tests/align.c  | 16 ++++----
> >  .../bpf/verifier/direct_packet_access.c       |  2 +-
> >  3 files changed, 47 insertions(+), 9 deletions(-)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 01120acab09a..09e17b483b0b 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -6432,6 +6432,8 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
> >         src_reg = NULL;
> >         if (dst_reg->type != SCALAR_VALUE)
> >                 ptr_reg = dst_reg;
> > +       else
> > +               dst_reg->id = 0;
> >         if (BPF_SRC(insn->code) == BPF_X) {
> >                 src_reg = &regs[insn->src_reg];
> >                 if (src_reg->type != SCALAR_VALUE) {
> > @@ -6565,6 +6567,8 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
> >                                 /* case: R1 = R2
> >                                  * copy register state to dest reg
> >                                  */
> > +                               if (src_reg->type == SCALAR_VALUE)
> > +                                       src_reg->id = ++env->id_gen;
> >                                 *dst_reg = *src_reg;
> >                                 dst_reg->live |= REG_LIVE_WRITTEN;
> >                                 dst_reg->subreg_def = DEF_NOT_SUBREG;
> > @@ -7365,6 +7369,30 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
> >         return true;
> >  }
> >
> > +static void find_equal_scalars(struct bpf_verifier_state *vstate,
> > +                              struct bpf_reg_state *known_reg)
> 
> this is double-misleading name:
> 
> 1) it's not just "find", but also "update" (or rather the purpose of
> this function is specifically to update registers, not find them, as
> we don't really return found register)
> 2) "equal" is not exactly true either. You can have two scalar
> register with exactly the same state, but they might not share ->id.
> So it's less about being equal, rather being "linked" by assignment.

I don't think I can agree.
We already have find_good_pkt_pointers() that also updates,
so 'find' fits better than 'update'.
'linked' is also wrong. The regs are exactly equal.
In case of pkt and other pointers two regs will have the same id
as well, but they will not be equal. Here these two scalars are equal
otherwise doing *reg = *known_reg would be wrong.

> > +{
> > +       struct bpf_func_state *state;
> > +       struct bpf_reg_state *reg;
> > +       int i, j;
> > +
> > +       for (i = 0; i <= vstate->curframe; i++) {
> > +               state = vstate->frame[i];
> > +               for (j = 0; j < MAX_BPF_REG; j++) {
> > +                       reg = &state->regs[j];
> > +                       if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)
> > +                               *reg = *known_reg;
> > +               }
> > +
> > +               bpf_for_each_spilled_reg(j, state, reg) {
> > +                       if (!reg)
> > +                               continue;
> > +                       if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)
> > +                               *reg = *known_reg;
> > +               }
> > +       }
> > +}
> > +
> >  static int check_cond_jmp_op(struct bpf_verifier_env *env,
> >                              struct bpf_insn *insn, int *insn_idx)
> >  {
> > @@ -7493,6 +7521,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
> >                                 reg_combine_min_max(&other_branch_regs[insn->src_reg],
> >                                                     &other_branch_regs[insn->dst_reg],
> >                                                     src_reg, dst_reg, opcode);
> > +                       if (src_reg->id) {
> > +                               find_equal_scalars(this_branch, src_reg);
> > +                               find_equal_scalars(other_branch, &other_branch_regs[insn->src_reg]);
> > +                       }
> > +
> >                 }
> >         } else if (dst_reg->type == SCALAR_VALUE) {
> >                 reg_set_min_max(&other_branch_regs[insn->dst_reg],
> > @@ -7500,6 +7533,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
> >                                         opcode, is_jmp32);
> >         }
> >
> > +       if (dst_reg->type == SCALAR_VALUE && dst_reg->id) {
> > +               find_equal_scalars(this_branch, dst_reg);
> > +               find_equal_scalars(other_branch, &other_branch_regs[insn->dst_reg]);
> 
> will this cover the case above where reg_combine_min_max() can update
> dst_reg's as well? 

yes.

> Even if yes, it probably would be more
> straightforward to call appropriate updates in the respective if
> branches (it's just a single line for each register, so not like it's
> duplicating tons of code). 

You mean inside reg_set_min_max() and inside reg_combine_min_max() ?
That won't work because find_equal_scalars() needs access to the whole
bpf_verifier_state and not just bpf_reg_state.

> It will make reasoning about this logic
> easier, IMO. Also, moving reg->id check into find_equal_scalars()
> would make the above suggestion even cleaner.

I don't think so. I think checking for type == SCALAR && dst_reg->id != 0
should be done outside of that function. It makes the logic cleaner.
For the same reason we check type outside of find_good_pkt_pointers().
