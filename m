Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B92582826A
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731284AbfEWQQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:16:08 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46993 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730918AbfEWQQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:16:08 -0400
Received: by mail-pf1-f195.google.com with SMTP id y11so3487330pfm.13;
        Thu, 23 May 2019 09:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Z2nD5dlrUDk/tbf7BtzNKoNVccIVOErTYJzbwwK2BsI=;
        b=U2skwTEUHSXGdOzKEaAeXfDl0WVyZvCxwuuu6kVBJ5ynwxB+CXY2ddNRGoVY+GbZi0
         ac4PhMdm7G9oeqbqTeEyv6DTxE/WglPOvQfot5Qd+PzGaWpXbIh3JLLyadLfgXSWZdQ5
         iAtuqX7xsennM2Qgh6Gqcvk+KmT8eiMNaACzrdreqpAy9hKNJMRw4PJDa6RNFzjPByiV
         yjkb4NKogjw+ZFoKPbPdROj5yoyiWEHTn6784zeJavu8d4W8dTOJTQb/12PfTIU5L/ip
         Ipl3FFCZfQOAaUy1mmQXIQAokknUHrJsgy1PixMRkKk07wneB9yQqJbn5klQvl0wrOtD
         JYnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Z2nD5dlrUDk/tbf7BtzNKoNVccIVOErTYJzbwwK2BsI=;
        b=Ri0HErCfyxbt3/HoQv9g1CtIYJqA5e7fugP37m0cRgA4JQdNnPNspvoIhantKE1sXC
         QOtjFBBRqzUCIU8/2qBllg3c7k5nIdu5JmE1+mZ/kORDz+UkljkDidqd3/2gRsGstBLQ
         GAZmLN97HdD7TNIKtTV3wAxa+gT510PPwZbLmEE438/wfmVnVcdd5uOZPZqWtX3RSFTc
         W/jdY1jasmjPmslB4n6pTzVjgqDPXLwfi1xJ+5X8R1mSOZnlqwzq6k42QQ64QW+xQJ4e
         u9gzTMZWB1RHGdxiVSiC9lg/tzGIU9fRawLGDgSZ7y8VeUdK3BtOSeZdNac+nDBEYNOn
         ERlw==
X-Gm-Message-State: APjAAAVlMxbz3XwE44F/fZJMtXJVkZvvn0tCD0GmabjVpCBnmkF/s6/E
        ay6or0DpttKjoQAjJpNbWe0=
X-Google-Smtp-Source: APXvYqy4ugdVDwmpm/l7oqBdA29rsnaTdd21O8RKyCYwHRm1gUKgfHeKqzxCbgnTWPV5HzvyrdUQlA==
X-Received: by 2002:a65:56cb:: with SMTP id w11mr79035155pgs.236.1558628166080;
        Thu, 23 May 2019 09:16:06 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:d5a9])
        by smtp.gmail.com with ESMTPSA id i9sm1712648pjd.29.2019.05.23.09.16.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 09:16:05 -0700 (PDT)
Date:   Thu, 23 May 2019 09:16:03 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        davem@davemloft.net, paul.burton@mips.com, udknight@gmail.com,
        zlim.lnx@gmail.com, illusionist.neo@gmail.com,
        naveen.n.rao@linux.ibm.com, sandipan@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH v7 bpf-next 01/16] bpf: verifier: mark verified-insn with
 sub-register zext flag
Message-ID: <20190523161601.mqvkzwjegon2cqku@ast-mbp.dhcp.thefacebook.com>
References: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
 <1558551312-17081-2-git-send-email-jiong.wang@netronome.com>
 <20190523020757.mwbux72pqjbvpqkh@ast-mbp.dhcp.thefacebook.com>
 <B9C052B7-DFB9-461A-B334-1607A94833D3@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B9C052B7-DFB9-461A-B334-1607A94833D3@netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 03:28:15PM +0100, Jiong Wang wrote:
> 
> > On 23 May 2019, at 03:07, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > 
> > On Wed, May 22, 2019 at 07:54:57PM +0100, Jiong Wang wrote:
> >> eBPF ISA specification requires high 32-bit cleared when low 32-bit
> >> sub-register is written. This applies to destination register of ALU32 etc.
> >> JIT back-ends must guarantee this semantic when doing code-gen. x86_64 and
> >> AArch64 ISA has the same semantics, so the corresponding JIT back-end
> >> doesn't need to do extra work.
> >> 
> >> However, 32-bit arches (arm, x86, nfp etc.) and some other 64-bit arches
> >> (PowerPC, SPARC etc) need to do explicit zero extension to meet this
> >> requirement, otherwise code like the following will fail.
> >> 
> >>  u64_value = (u64) u32_value
> >>  ... other uses of u64_value
> >> 
> >> This is because compiler could exploit the semantic described above and
> >> save those zero extensions for extending u32_value to u64_value, these JIT
> >> back-ends are expected to guarantee this through inserting extra zero
> >> extensions which however could be a significant increase on the code size.
> >> Some benchmarks show there could be ~40% sub-register writes out of total
> >> insns, meaning at least ~40% extra code-gen.
> >> 
> >> One observation is these extra zero extensions are not always necessary.
> >> Take above code snippet for example, it is possible u32_value will never be
> >> casted into a u64, the value of high 32-bit of u32_value then could be
> >> ignored and extra zero extension could be eliminated.
> >> 
> >> This patch implements this idea, insns defining sub-registers will be
> >> marked when the high 32-bit of the defined sub-register matters. For
> >> those unmarked insns, it is safe to eliminate high 32-bit clearnace for
> >> them.
> >> 
> >> Algo:
> >> - Split read flags into READ32 and READ64.
> >> 
> >> - Record index of insn that does sub-register write. Keep the index inside
> >>   reg state and update it during verifier insn walking.
> >> 
> >> - A full register read on a sub-register marks its definition insn as
> >>   needing zero extension on dst register.
> >> 
> >>   A new sub-register write overrides the old one.
> >> 
> >> - When propagating read64 during path pruning, also mark any insn defining
> >>   a sub-register that is read in the pruned path as full-register.
> >> 
> >> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> >> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> >> ---
> >> include/linux/bpf_verifier.h |  14 +++-
> >> kernel/bpf/verifier.c        | 175 +++++++++++++++++++++++++++++++++++++++----
> >> 2 files changed, 173 insertions(+), 16 deletions(-)
> >> 
> >> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> >> index 1305ccb..60fb54e 100644
> >> --- a/include/linux/bpf_verifier.h
> >> +++ b/include/linux/bpf_verifier.h
> >> @@ -36,9 +36,11 @@
> >>  */
> >> enum bpf_reg_liveness {
> >> 	REG_LIVE_NONE = 0, /* reg hasn't been read or written this branch */
> >> -	REG_LIVE_READ, /* reg was read, so we're sensitive to initial value */
> >> -	REG_LIVE_WRITTEN, /* reg was written first, screening off later reads */
> >> -	REG_LIVE_DONE = 4, /* liveness won't be updating this register anymore */
> >> +	REG_LIVE_READ32 = 0x1, /* reg was read, so we're sensitive to initial value */
> >> +	REG_LIVE_READ64 = 0x2, /* likewise, but full 64-bit content matters */
> >> +	REG_LIVE_READ = REG_LIVE_READ32 | REG_LIVE_READ64,
> >> +	REG_LIVE_WRITTEN = 0x4, /* reg was written first, screening off later reads */
> >> +	REG_LIVE_DONE = 0x8, /* liveness won't be updating this register anymore */
> >> };
> >> 
> >> struct bpf_reg_state {
> >> @@ -131,6 +133,11 @@ struct bpf_reg_state {
> >> 	 * pointing to bpf_func_state.
> >> 	 */
> >> 	u32 frameno;
> >> +	/* Tracks subreg definition. The stored value is the insn_idx of the
> >> +	 * writing insn. This is safe because subreg_def is used before any insn
> >> +	 * patching which only happens after main verification finished.
> >> +	 */
> >> +	s32 subreg_def;
> >> 	enum bpf_reg_liveness live;
> >> };
> >> 
> >> @@ -232,6 +239,7 @@ struct bpf_insn_aux_data {
> >> 	int ctx_field_size; /* the ctx field size for load insn, maybe 0 */
> >> 	int sanitize_stack_off; /* stack slot to be cleared */
> >> 	bool seen; /* this insn was processed by the verifier */
> >> +	bool zext_dst; /* this insn zero extends dst reg */
> >> 	u8 alu_state; /* used in combination with alu_limit */
> >> 	unsigned int orig_idx; /* original instruction index */
> >> };
> >> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >> index 95f93544..0efccf8 100644
> >> --- a/kernel/bpf/verifier.c
> >> +++ b/kernel/bpf/verifier.c
> >> @@ -981,6 +981,7 @@ static void mark_reg_not_init(struct bpf_verifier_env *env,
> >> 	__mark_reg_not_init(regs + regno);
> >> }
> >> 
> >> +#define DEF_NOT_SUBREG	(-1)
> >> static void init_reg_state(struct bpf_verifier_env *env,
> >> 			   struct bpf_func_state *state)
> >> {
> >> @@ -991,6 +992,7 @@ static void init_reg_state(struct bpf_verifier_env *env,
> >> 		mark_reg_not_init(env, regs, i);
> >> 		regs[i].live = REG_LIVE_NONE;
> >> 		regs[i].parent = NULL;
> >> +		regs[i].subreg_def = DEF_NOT_SUBREG;
> > 
> > shouldn't it be moved into __mark_reg_unknown ?
> 
> I had pondered this in early version, but thought it is not correct.
> Like “live”, “subreg_def" is initialised inside init_reg_state, they are
> not touched by __mark_reg_unknown, instead, they are updated mostly
> updated by check_reg_arg which is strictly called at every reg read/write
> sites which are places where register def and use happened and are the
> places we want to update “subreg_def”.
> 
> From my understanding, __mark_reg_unknown could be called when verifier
> is not sure about the value of a register, but the call site doesn’t care
> about width at the moment. For example, for a narrow loads from stack,
> __mark_reg_unknown could be triggered, the dst_reg then will be marked as
> DEF_NOT_SUBREG, but it is a subreg define. 
> 
> Make sense?

yes.

> > Also what about my old suggestion to use DEF_NOT_SUBREG==0
> > to be on safer side when we zero things out?
> 
> Will change DEF_NOT_SUBREG to 0 if no problem shown up.
> 
> TBH, I thought about this in initial version, but later used -1
> to avoid index + 1 and some other code change issues IIRC.
> 
> if we use DEF_NOT_SUBREG == 0, then when we zero things out, we will
> mark one register def as a full register, it then won’t be zero extended
> in any case.
> 
> if we use DEF_NOT_SUBREG == -1, then when we zero things out, one register
> will be marked as sub-register def and defined by insn 0, which normally
> is a context register move.

'normally is a context register' is a dangerous assumption to make.
that's exactly the reason I prefer DEF_NOT_SUBREG == 0

> 
> > 
> >> 	}
> >> 
> >> 	/* frame pointer */
> >> @@ -1136,7 +1138,7 @@ static int check_subprogs(struct bpf_verifier_env *env)
> >>  */
> >> static int mark_reg_read(struct bpf_verifier_env *env,
> >> 			 const struct bpf_reg_state *state,
> >> -			 struct bpf_reg_state *parent)
> >> +			 struct bpf_reg_state *parent, u8 flag)
> >> {
> >> 	bool writes = parent == state->parent; /* Observe write marks */
> >> 	int cnt = 0;
> >> @@ -1151,17 +1153,26 @@ static int mark_reg_read(struct bpf_verifier_env *env,
> >> 				parent->var_off.value, parent->off);
> >> 			return -EFAULT;
> >> 		}
> >> -		if (parent->live & REG_LIVE_READ)
> >> +		/* The first condition is more likely to be true than the
> >> +		 * second, checked it first.
> >> +		 */
> >> +		if ((parent->live & REG_LIVE_READ) == flag ||
> >> +		    parent->live & REG_LIVE_READ64)
> >> 			/* The parentage chain never changes and
> >> 			 * this parent was already marked as LIVE_READ.
> >> 			 * There is no need to keep walking the chain again and
> >> 			 * keep re-marking all parents as LIVE_READ.
> >> 			 * This case happens when the same register is read
> >> 			 * multiple times without writes into it in-between.
> >> +			 * Also, if parent has the stronger REG_LIVE_READ64 set,
> >> +			 * then no need to set the weak REG_LIVE_READ32.
> >> 			 */
> >> 			break;
> >> 		/* ... then we depend on parent's value */
> >> -		parent->live |= REG_LIVE_READ;
> >> +		parent->live |= flag;
> >> +		/* REG_LIVE_READ64 overrides REG_LIVE_READ32. */
> >> +		if (flag == REG_LIVE_READ64)
> >> +			parent->live &= ~REG_LIVE_READ32;
> >> 		state = parent;
> >> 		parent = state->parent;
> >> 		writes = true;
> >> @@ -1173,12 +1184,111 @@ static int mark_reg_read(struct bpf_verifier_env *env,
> >> 	return 0;
> >> }
> >> 
> >> +/* This function is supposed to be used by the following 32-bit optimization
> >> + * code only. It returns TRUE if the source or destination register operates
> >> + * on 64-bit, otherwise return FALSE.
> >> + */
> >> +static bool is_reg64(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >> +		     u32 regno, struct bpf_reg_state *reg, enum reg_arg_type t)
> >> +{
> >> +	u8 code, class, op;
> >> +
> >> +	code = insn->code;
> >> +	class = BPF_CLASS(code);
> >> +	op = BPF_OP(code);
> >> +	if (class == BPF_JMP) {
> >> +		/* BPF_EXIT for "main" will reach here. Return TRUE
> >> +		 * conservatively.
> >> +		 */
> >> +		if (op == BPF_EXIT)
> >> +			return true;
> >> +		if (op == BPF_CALL) {
> >> +			/* BPF to BPF call will reach here because of marking
> >> +			 * caller saved clobber with DST_OP_NO_MARK for which we
> >> +			 * don't care the register def because they are anyway
> >> +			 * marked as NOT_INIT already.
> >> +			 */
> >> +			if (insn->src_reg == BPF_PSEUDO_CALL)
> >> +				return false;
> >> +			/* Helper call will reach here because of arg type
> >> +			 * check, conservatively return TRUE.
> >> +			 */
> >> +			if (t == SRC_OP)
> >> +				return true;
> >> +
> >> +			return false;
> >> +		}
> >> +	}
> >> +
> >> +	if (class == BPF_ALU64 || class == BPF_JMP ||
> >> +	    /* BPF_END always use BPF_ALU class. */
> >> +	    (class == BPF_ALU && op == BPF_END && insn->imm == 64))
> >> +		return true;
> >> +
> >> +	if (class == BPF_ALU || class == BPF_JMP32)
> >> +		return false;
> >> +
> >> +	if (class == BPF_LDX) {
> >> +		if (t != SRC_OP)
> >> +			return BPF_SIZE(code) == BPF_DW;
> >> +		/* LDX source must be ptr. */
> >> +		return true;
> >> +	}
> >> +
> >> +	if (class == BPF_STX) {
> >> +		if (reg->type != SCALAR_VALUE)
> >> +			return true;
> >> +		return BPF_SIZE(code) == BPF_DW;
> >> +	}
> >> +
> >> +	if (class == BPF_LD) {
> >> +		u8 mode = BPF_MODE(code);
> >> +
> >> +		/* LD_IMM64 */
> >> +		if (mode == BPF_IMM)
> >> +			return true;
> >> +
> >> +		/* Both LD_IND and LD_ABS return 32-bit data. */
> >> +		if (t != SRC_OP)
> >> +			return  false;
> >> +
> >> +		/* Implicit ctx ptr. */
> >> +		if (regno == BPF_REG_6)
> >> +			return true;
> > 
> > compiler will optimize above 'if' away.
> > What's the point of the above stmt?
> 
> I implemented this function insn class by class to make sure I had thorough
> checks for each insn class and won’t miss some corner case. I think the code
> is more clear for maintain. And was making each insn class do full return
> after finishing their own checks, tried to avoid fall through, this is why
> these “redundant” checks are here.       
>                                                                                  
> And for this BPF_REG_6 check, BPF_LD insn looked quite special to me, so was     
> implementing it following the comments above check_ld_abs case by case, this     
> check was for the following comment:                                             
>                                                                                  
>  * Implicit input:                                                               
>  *   ctx == skb == R6 == CTX                                                     
>                                                                                  
> It is true these checks could be merged, checks inside BPF_LD could be             
> even further compressed into single line along with the class == BPF_LD
> check but I am thinking that would be a little bit over compressed,
> will just drop the following BPF_ST check and this BPF_REG_6 check, I
> am thinking avoid fall through might make the code more clear, so will
> stop at letting BPF_LD fall through to default return, new code then
> will look like the following:
> 
>         if (class == BPF_LD) {
>                 u8 mode = BPF_MODE(code);
> 
>                 /* LD_IMM64 */
>                 if (mode == BPF_IMM)
>                         return true;
> 
>                 /* Both LD_IND and LD_ABS return 32-bit data. */
>                 if (t != SRC_OP)
>                         return  false;
>               
>                 /* SRC is implicit ctx ptr which is 64-bit, or explicit source
>                  * which could be any width.
>                  */
>                 return true;
>         }
> 
>         /* Conservatively return true for all the other cases. */
>         return true;
> 
> Does this looks good?

well, it made me realize that we're probably doing it wrong,
since after calling check_reg_arg() we need to re-parse insn encoding.
How about we change check_reg_arg()'s enum reg_arg_type instead?
The caller has much more context and no need to parse insn opcode again.
Something like:
enum reg_arg_type {
        SRC_OP64,        
        DST_OP64,       
        DST_OP_NO_MARK, // probably no need to split this one ?
        SRC_OP32,      
        DST_OP32,      
};

> > 
> >> +
> >> +		/* Explicit source could be any width. */
> >> +		return true;
> >> +	}
> >> +
> >> +	if (class == BPF_ST)
> >> +		/* The only source register for BPF_ST is a ptr. */
> >> +		return true;
> > 
> > ditto
> 
> > 
> >> +
> >> +	/* Conservatively return true at default. */
> >> +	return true;
> >> +}
> >> +
> >> +static void mark_insn_zext(struct bpf_verifier_env *env,
> >> +			   struct bpf_reg_state *reg)
> >> +{
> >> +	s32 def_idx = reg->subreg_def;
> >> +
> >> +	if (def_idx == DEF_NOT_SUBREG)
> >> +		return;
> >> +
> >> +	env->insn_aux_data[def_idx].zext_dst = true;
> >> +	/* The dst will be zero extended, so won't be sub-register anymore. */
> >> +	reg->subreg_def = DEF_NOT_SUBREG;
> >> +}
> >> +
> >> static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
> >> 			 enum reg_arg_type t)
> >> {
> >> 	struct bpf_verifier_state *vstate = env->cur_state;
> >> 	struct bpf_func_state *state = vstate->frame[vstate->curframe];
> >> +	struct bpf_insn *insn = env->prog->insnsi + env->insn_idx;
> >> 	struct bpf_reg_state *reg, *regs = state->regs;
> >> +	bool rw64;
> >> 
> >> 	if (regno >= MAX_BPF_REG) {
> >> 		verbose(env, "R%d is invalid\n", regno);
> >> @@ -1186,6 +1296,7 @@ static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
> >> 	}
> >> 
> >> 	reg = &regs[regno];
> >> +	rw64 = is_reg64(env, insn, regno, reg, t);
> >> 	if (t == SRC_OP) {
> >> 		/* check whether register used as source operand can be read */
> >> 		if (reg->type == NOT_INIT) {
> >> @@ -1196,7 +1307,11 @@ static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
> >> 		if (regno == BPF_REG_FP)
> >> 			return 0;
> >> 
> >> -		return mark_reg_read(env, reg, reg->parent);
> >> +		if (rw64)
> >> +			mark_insn_zext(env, reg);
> >> +
> >> +		return mark_reg_read(env, reg, reg->parent,
> >> +				     rw64 ? REG_LIVE_READ64 : REG_LIVE_READ32);
> >> 	} else {
> >> 		/* check whether register used as dest operand can be written to */
> >> 		if (regno == BPF_REG_FP) {
> >> @@ -1204,6 +1319,7 @@ static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
> >> 			return -EACCES;
> >> 		}
> >> 		reg->live |= REG_LIVE_WRITTEN;
> >> +		reg->subreg_def = rw64 ? DEF_NOT_SUBREG : env->insn_idx;
> >> 		if (t == DST_OP)
> >> 			mark_reg_unknown(env, regs, regno);
> >> 	}
> >> @@ -1383,7 +1499,8 @@ static int check_stack_read(struct bpf_verifier_env *env,
> >> 			state->regs[value_regno].live |= REG_LIVE_WRITTEN;
> >> 		}
> >> 		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
> >> -			      reg_state->stack[spi].spilled_ptr.parent);
> >> +			      reg_state->stack[spi].spilled_ptr.parent,
> >> +			      REG_LIVE_READ64);
> >> 		return 0;
> >> 	} else {
> >> 		int zeros = 0;
> >> @@ -1400,7 +1517,9 @@ static int check_stack_read(struct bpf_verifier_env *env,
> >> 			return -EACCES;
> >> 		}
> >> 		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
> >> -			      reg_state->stack[spi].spilled_ptr.parent);
> >> +			      reg_state->stack[spi].spilled_ptr.parent,
> >> +			      size == BPF_REG_SIZE
> >> +			      ? REG_LIVE_READ64 : REG_LIVE_READ32);
> > 
> > I don't think that's correct.
> > It's a parial read from a stack slot that doesn't contain a pointer.
> > It can be of any size and any offset.
> > Hence 4-byte read can read upper bits too.
> 
> That’s true. But I think this won’t cause correctness issue. Because
> for stack read, we call mark_reg_read mostly to set the read bit in
> “live”, and it is used by stacksafe to know whether one stack slot
> is ever used or not. Either REG_LIVE_READ64 or REG_LIVE_READ32 will
> let the slot marked as “read”, and let stacksafe know it is used.

yes. that's technically correct, but very fragile.

> For stack content, if it comes from eBPF register A, then it must have
> been stored by STX to stack which should have triggered zero extension
> on the original A if it is a sub-register. So the content is correct.
> 
> Here, the issue is stack slot read is reusing mark_reg_read, the last
> parameter for stack slot read just need to let mark_reg_read know this
> slot has been read, perhaps just pass REG_LIVE_READ64 for all stack
> read?

yes. please.

