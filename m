Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D9D27F97
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 16:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730752AbfEWO2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 10:28:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42436 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730709AbfEWO2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 10:28:21 -0400
Received: by mail-wr1-f67.google.com with SMTP id l2so6522474wrb.9
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 07:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Kuh/fIlehW9iNhueu+e8oAgjoI6ermGT05gQvF/D6xA=;
        b=mp4eEeNsbkgzLxfUzHldSq1o7OMSzyvbCe3TgSJV+9qz5Jv5d7i+zq0mt+SJ0DskWy
         QONZjp2SUdzUL+5cw84a+kFaA5zrDvCgZFbLLpZGJSBamaVDCvptbYs8659S/2g+JlSL
         OffXcLFwh18icM+vrzT2FqT65xU7MaFL4rBmLuAW+9S663kJRtAS/n7QHWeN+3li7Crm
         YWtVyNYMi3RW4zggR9saCJpiTgZVF7Q2X8mwUHzKVW1Qg1ESp2vVYRcbHEOVW76PSDjm
         0q65zqBikuFvMqwYqzcVXl7ni6vAgZgQlo3f6bDqSDDoLwhTF9XR5NQfZnwuWFo7nR45
         /tQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Kuh/fIlehW9iNhueu+e8oAgjoI6ermGT05gQvF/D6xA=;
        b=lpgWE1pqGKa78jI5NwpfJRlszhsh8pqiuybdVQRsErdH4EuS6mEfs0CrrWTjP4iO1A
         JAPCNU/OxqcxGsUMyxeGcY5WWkaE9h+6B20QMde2YkN842LUFt7iZT3UUaG1EbHMiCNm
         4VtOynkKvfMrTuj1ZvFzUEHYgj9WUk6bezmla/nk40BtCs7EoGb2NL4bV1lrLi1+Ide9
         FWcQX2+NW42Cx3BFLLGiVGtVx0TnmBLMR5QwJnPZpAJIqcqMr69tB8te3hdArLK7yKnB
         0w2ilbh9VDmwaToVkw7XJW4fSYKMBo7B0IKO2CCtQKaWefjxYmvEXbMv+KWSYxYLvWli
         6QMg==
X-Gm-Message-State: APjAAAU1g8qngXPsAdksaEZpMyg60BRYf3KMG1pDJesnRY7n2d7I3CHS
        SP6zNdsLC55z/00ZNRQOrcK+mw==
X-Google-Smtp-Source: APXvYqw7Vx0KPEFSH2rPwFVFEJBCD9OSFnm3/DVt0N7ZfAz060isax+0O2kKqYWOV6LndFSq6xjVig==
X-Received: by 2002:a5d:504f:: with SMTP id h15mr5936400wrt.208.1558621698258;
        Thu, 23 May 2019 07:28:18 -0700 (PDT)
Received: from [172.20.1.229] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id y132sm15826276wmd.35.2019.05.23.07.28.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 07:28:17 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v7 bpf-next 01/16] bpf: verifier: mark verified-insn with
 sub-register zext flag
From:   Jiong Wang <jiong.wang@netronome.com>
In-Reply-To: <20190523020757.mwbux72pqjbvpqkh@ast-mbp.dhcp.thefacebook.com>
Date:   Thu, 23 May 2019 15:28:15 +0100
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        davem@davemloft.net, paul.burton@mips.com, udknight@gmail.com,
        zlim.lnx@gmail.com, illusionist.neo@gmail.com,
        naveen.n.rao@linux.ibm.com, sandipan@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        jakub.kicinski@netronome.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <B9C052B7-DFB9-461A-B334-1607A94833D3@netronome.com>
References: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
 <1558551312-17081-2-git-send-email-jiong.wang@netronome.com>
 <20190523020757.mwbux72pqjbvpqkh@ast-mbp.dhcp.thefacebook.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
X-Mailer: Apple Mail (2.3273)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 23 May 2019, at 03:07, Alexei Starovoitov =
<alexei.starovoitov@gmail.com> wrote:
>=20
> On Wed, May 22, 2019 at 07:54:57PM +0100, Jiong Wang wrote:
>> eBPF ISA specification requires high 32-bit cleared when low 32-bit
>> sub-register is written. This applies to destination register of =
ALU32 etc.
>> JIT back-ends must guarantee this semantic when doing code-gen. =
x86_64 and
>> AArch64 ISA has the same semantics, so the corresponding JIT back-end
>> doesn't need to do extra work.
>>=20
>> However, 32-bit arches (arm, x86, nfp etc.) and some other 64-bit =
arches
>> (PowerPC, SPARC etc) need to do explicit zero extension to meet this
>> requirement, otherwise code like the following will fail.
>>=20
>>  u64_value =3D (u64) u32_value
>>  ... other uses of u64_value
>>=20
>> This is because compiler could exploit the semantic described above =
and
>> save those zero extensions for extending u32_value to u64_value, =
these JIT
>> back-ends are expected to guarantee this through inserting extra zero
>> extensions which however could be a significant increase on the code =
size.
>> Some benchmarks show there could be ~40% sub-register writes out of =
total
>> insns, meaning at least ~40% extra code-gen.
>>=20
>> One observation is these extra zero extensions are not always =
necessary.
>> Take above code snippet for example, it is possible u32_value will =
never be
>> casted into a u64, the value of high 32-bit of u32_value then could =
be
>> ignored and extra zero extension could be eliminated.
>>=20
>> This patch implements this idea, insns defining sub-registers will be
>> marked when the high 32-bit of the defined sub-register matters. For
>> those unmarked insns, it is safe to eliminate high 32-bit clearnace =
for
>> them.
>>=20
>> Algo:
>> - Split read flags into READ32 and READ64.
>>=20
>> - Record index of insn that does sub-register write. Keep the index =
inside
>>   reg state and update it during verifier insn walking.
>>=20
>> - A full register read on a sub-register marks its definition insn as
>>   needing zero extension on dst register.
>>=20
>>   A new sub-register write overrides the old one.
>>=20
>> - When propagating read64 during path pruning, also mark any insn =
defining
>>   a sub-register that is read in the pruned path as full-register.
>>=20
>> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
>> ---
>> include/linux/bpf_verifier.h |  14 +++-
>> kernel/bpf/verifier.c        | 175 =
+++++++++++++++++++++++++++++++++++++++----
>> 2 files changed, 173 insertions(+), 16 deletions(-)
>>=20
>> diff --git a/include/linux/bpf_verifier.h =
b/include/linux/bpf_verifier.h
>> index 1305ccb..60fb54e 100644
>> --- a/include/linux/bpf_verifier.h
>> +++ b/include/linux/bpf_verifier.h
>> @@ -36,9 +36,11 @@
>>  */
>> enum bpf_reg_liveness {
>> 	REG_LIVE_NONE =3D 0, /* reg hasn't been read or written this =
branch */
>> -	REG_LIVE_READ, /* reg was read, so we're sensitive to initial =
value */
>> -	REG_LIVE_WRITTEN, /* reg was written first, screening off later =
reads */
>> -	REG_LIVE_DONE =3D 4, /* liveness won't be updating this register =
anymore */
>> +	REG_LIVE_READ32 =3D 0x1, /* reg was read, so we're sensitive to =
initial value */
>> +	REG_LIVE_READ64 =3D 0x2, /* likewise, but full 64-bit content =
matters */
>> +	REG_LIVE_READ =3D REG_LIVE_READ32 | REG_LIVE_READ64,
>> +	REG_LIVE_WRITTEN =3D 0x4, /* reg was written first, screening =
off later reads */
>> +	REG_LIVE_DONE =3D 0x8, /* liveness won't be updating this =
register anymore */
>> };
>>=20
>> struct bpf_reg_state {
>> @@ -131,6 +133,11 @@ struct bpf_reg_state {
>> 	 * pointing to bpf_func_state.
>> 	 */
>> 	u32 frameno;
>> +	/* Tracks subreg definition. The stored value is the insn_idx of =
the
>> +	 * writing insn. This is safe because subreg_def is used before =
any insn
>> +	 * patching which only happens after main verification finished.
>> +	 */
>> +	s32 subreg_def;
>> 	enum bpf_reg_liveness live;
>> };
>>=20
>> @@ -232,6 +239,7 @@ struct bpf_insn_aux_data {
>> 	int ctx_field_size; /* the ctx field size for load insn, maybe 0 =
*/
>> 	int sanitize_stack_off; /* stack slot to be cleared */
>> 	bool seen; /* this insn was processed by the verifier */
>> +	bool zext_dst; /* this insn zero extends dst reg */
>> 	u8 alu_state; /* used in combination with alu_limit */
>> 	unsigned int orig_idx; /* original instruction index */
>> };
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 95f93544..0efccf8 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -981,6 +981,7 @@ static void mark_reg_not_init(struct =
bpf_verifier_env *env,
>> 	__mark_reg_not_init(regs + regno);
>> }
>>=20
>> +#define DEF_NOT_SUBREG	(-1)
>> static void init_reg_state(struct bpf_verifier_env *env,
>> 			   struct bpf_func_state *state)
>> {
>> @@ -991,6 +992,7 @@ static void init_reg_state(struct =
bpf_verifier_env *env,
>> 		mark_reg_not_init(env, regs, i);
>> 		regs[i].live =3D REG_LIVE_NONE;
>> 		regs[i].parent =3D NULL;
>> +		regs[i].subreg_def =3D DEF_NOT_SUBREG;
>=20
> shouldn't it be moved into __mark_reg_unknown ?

I had pondered this in early version, but thought it is not correct.
Like =E2=80=9Clive=E2=80=9D, =E2=80=9Csubreg_def" is initialised inside =
init_reg_state, they are
not touched by __mark_reg_unknown, instead, they are updated mostly
updated by check_reg_arg which is strictly called at every reg =
read/write
sites which are places where register def and use happened and are the
places we want to update =E2=80=9Csubreg_def=E2=80=9D.

=46rom my understanding, __mark_reg_unknown could be called when =
verifier
is not sure about the value of a register, but the call site doesn=E2=80=99=
t care
about width at the moment. For example, for a narrow loads from stack,
__mark_reg_unknown could be triggered, the dst_reg then will be marked =
as
DEF_NOT_SUBREG, but it is a subreg define.=20

Make sense?


> Also what about my old suggestion to use DEF_NOT_SUBREG=3D=3D0
> to be on safer side when we zero things out?

Will change DEF_NOT_SUBREG to 0 if no problem shown up.

TBH, I thought about this in initial version, but later used -1
to avoid index + 1 and some other code change issues IIRC.

if we use DEF_NOT_SUBREG =3D=3D 0, then when we zero things out, we will
mark one register def as a full register, it then won=E2=80=99t be zero =
extended
in any case.

if we use DEF_NOT_SUBREG =3D=3D -1, then when we zero things out, one =
register
will be marked as sub-register def and defined by insn 0, which normally
is a context register move.
 =20

>=20
>> 	}
>>=20
>> 	/* frame pointer */
>> @@ -1136,7 +1138,7 @@ static int check_subprogs(struct =
bpf_verifier_env *env)
>>  */
>> static int mark_reg_read(struct bpf_verifier_env *env,
>> 			 const struct bpf_reg_state *state,
>> -			 struct bpf_reg_state *parent)
>> +			 struct bpf_reg_state *parent, u8 flag)
>> {
>> 	bool writes =3D parent =3D=3D state->parent; /* Observe write =
marks */
>> 	int cnt =3D 0;
>> @@ -1151,17 +1153,26 @@ static int mark_reg_read(struct =
bpf_verifier_env *env,
>> 				parent->var_off.value, parent->off);
>> 			return -EFAULT;
>> 		}
>> -		if (parent->live & REG_LIVE_READ)
>> +		/* The first condition is more likely to be true than =
the
>> +		 * second, checked it first.
>> +		 */
>> +		if ((parent->live & REG_LIVE_READ) =3D=3D flag ||
>> +		    parent->live & REG_LIVE_READ64)
>> 			/* The parentage chain never changes and
>> 			 * this parent was already marked as LIVE_READ.
>> 			 * There is no need to keep walking the chain =
again and
>> 			 * keep re-marking all parents as LIVE_READ.
>> 			 * This case happens when the same register is =
read
>> 			 * multiple times without writes into it =
in-between.
>> +			 * Also, if parent has the stronger =
REG_LIVE_READ64 set,
>> +			 * then no need to set the weak REG_LIVE_READ32.
>> 			 */
>> 			break;
>> 		/* ... then we depend on parent's value */
>> -		parent->live |=3D REG_LIVE_READ;
>> +		parent->live |=3D flag;
>> +		/* REG_LIVE_READ64 overrides REG_LIVE_READ32. */
>> +		if (flag =3D=3D REG_LIVE_READ64)
>> +			parent->live &=3D ~REG_LIVE_READ32;
>> 		state =3D parent;
>> 		parent =3D state->parent;
>> 		writes =3D true;
>> @@ -1173,12 +1184,111 @@ static int mark_reg_read(struct =
bpf_verifier_env *env,
>> 	return 0;
>> }
>>=20
>> +/* This function is supposed to be used by the following 32-bit =
optimization
>> + * code only. It returns TRUE if the source or destination register =
operates
>> + * on 64-bit, otherwise return FALSE.
>> + */
>> +static bool is_reg64(struct bpf_verifier_env *env, struct bpf_insn =
*insn,
>> +		     u32 regno, struct bpf_reg_state *reg, enum =
reg_arg_type t)
>> +{
>> +	u8 code, class, op;
>> +
>> +	code =3D insn->code;
>> +	class =3D BPF_CLASS(code);
>> +	op =3D BPF_OP(code);
>> +	if (class =3D=3D BPF_JMP) {
>> +		/* BPF_EXIT for "main" will reach here. Return TRUE
>> +		 * conservatively.
>> +		 */
>> +		if (op =3D=3D BPF_EXIT)
>> +			return true;
>> +		if (op =3D=3D BPF_CALL) {
>> +			/* BPF to BPF call will reach here because of =
marking
>> +			 * caller saved clobber with DST_OP_NO_MARK for =
which we
>> +			 * don't care the register def because they are =
anyway
>> +			 * marked as NOT_INIT already.
>> +			 */
>> +			if (insn->src_reg =3D=3D BPF_PSEUDO_CALL)
>> +				return false;
>> +			/* Helper call will reach here because of arg =
type
>> +			 * check, conservatively return TRUE.
>> +			 */
>> +			if (t =3D=3D SRC_OP)
>> +				return true;
>> +
>> +			return false;
>> +		}
>> +	}
>> +
>> +	if (class =3D=3D BPF_ALU64 || class =3D=3D BPF_JMP ||
>> +	    /* BPF_END always use BPF_ALU class. */
>> +	    (class =3D=3D BPF_ALU && op =3D=3D BPF_END && insn->imm =3D=3D=
 64))
>> +		return true;
>> +
>> +	if (class =3D=3D BPF_ALU || class =3D=3D BPF_JMP32)
>> +		return false;
>> +
>> +	if (class =3D=3D BPF_LDX) {
>> +		if (t !=3D SRC_OP)
>> +			return BPF_SIZE(code) =3D=3D BPF_DW;
>> +		/* LDX source must be ptr. */
>> +		return true;
>> +	}
>> +
>> +	if (class =3D=3D BPF_STX) {
>> +		if (reg->type !=3D SCALAR_VALUE)
>> +			return true;
>> +		return BPF_SIZE(code) =3D=3D BPF_DW;
>> +	}
>> +
>> +	if (class =3D=3D BPF_LD) {
>> +		u8 mode =3D BPF_MODE(code);
>> +
>> +		/* LD_IMM64 */
>> +		if (mode =3D=3D BPF_IMM)
>> +			return true;
>> +
>> +		/* Both LD_IND and LD_ABS return 32-bit data. */
>> +		if (t !=3D SRC_OP)
>> +			return  false;
>> +
>> +		/* Implicit ctx ptr. */
>> +		if (regno =3D=3D BPF_REG_6)
>> +			return true;
>=20
> compiler will optimize above 'if' away.
> What's the point of the above stmt?

I implemented this function insn class by class to make sure I had =
thorough
checks for each insn class and won=E2=80=99t miss some corner case. I =
think the code
is more clear for maintain. And was making each insn class do full =
return
after finishing their own checks, tried to avoid fall through, this is =
why
these =E2=80=9Credundant=E2=80=9D checks are here.      =20
                                                                         =
       =20
And for this BPF_REG_6 check, BPF_LD insn looked quite special to me, so =
was    =20
implementing it following the comments above check_ld_abs case by case, =
this    =20
check was for the following comment:                                     =
       =20
                                                                         =
       =20
 * Implicit input:                                                       =
       =20
 *   ctx =3D=3D skb =3D=3D R6 =3D=3D CTX                                 =
                   =20
                                                                         =
       =20
It is true these checks could be merged, checks inside BPF_LD could be   =
         =20
even further compressed into single line along with the class =3D=3D =
BPF_LD
check but I am thinking that would be a little bit over compressed,
will just drop the following BPF_ST check and this BPF_REG_6 check, I
am thinking avoid fall through might make the code more clear, so will
stop at letting BPF_LD fall through to default return, new code then
will look like the following:

        if (class =3D=3D BPF_LD) {
                u8 mode =3D BPF_MODE(code);

                /* LD_IMM64 */
                if (mode =3D=3D BPF_IMM)
                        return true;

                /* Both LD_IND and LD_ABS return 32-bit data. */
                if (t !=3D SRC_OP)
                        return  false;
             =20
                /* SRC is implicit ctx ptr which is 64-bit, or explicit =
source
                 * which could be any width.
                 */
                return true;
        }

        /* Conservatively return true for all the other cases. */
        return true;

Does this looks good?

>=20
>> +
>> +		/* Explicit source could be any width. */
>> +		return true;
>> +	}
>> +
>> +	if (class =3D=3D BPF_ST)
>> +		/* The only source register for BPF_ST is a ptr. */
>> +		return true;
>=20
> ditto

>=20
>> +
>> +	/* Conservatively return true at default. */
>> +	return true;
>> +}
>> +
>> +static void mark_insn_zext(struct bpf_verifier_env *env,
>> +			   struct bpf_reg_state *reg)
>> +{
>> +	s32 def_idx =3D reg->subreg_def;
>> +
>> +	if (def_idx =3D=3D DEF_NOT_SUBREG)
>> +		return;
>> +
>> +	env->insn_aux_data[def_idx].zext_dst =3D true;
>> +	/* The dst will be zero extended, so won't be sub-register =
anymore. */
>> +	reg->subreg_def =3D DEF_NOT_SUBREG;
>> +}
>> +
>> static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
>> 			 enum reg_arg_type t)
>> {
>> 	struct bpf_verifier_state *vstate =3D env->cur_state;
>> 	struct bpf_func_state *state =3D =
vstate->frame[vstate->curframe];
>> +	struct bpf_insn *insn =3D env->prog->insnsi + env->insn_idx;
>> 	struct bpf_reg_state *reg, *regs =3D state->regs;
>> +	bool rw64;
>>=20
>> 	if (regno >=3D MAX_BPF_REG) {
>> 		verbose(env, "R%d is invalid\n", regno);
>> @@ -1186,6 +1296,7 @@ static int check_reg_arg(struct =
bpf_verifier_env *env, u32 regno,
>> 	}
>>=20
>> 	reg =3D &regs[regno];
>> +	rw64 =3D is_reg64(env, insn, regno, reg, t);
>> 	if (t =3D=3D SRC_OP) {
>> 		/* check whether register used as source operand can be =
read */
>> 		if (reg->type =3D=3D NOT_INIT) {
>> @@ -1196,7 +1307,11 @@ static int check_reg_arg(struct =
bpf_verifier_env *env, u32 regno,
>> 		if (regno =3D=3D BPF_REG_FP)
>> 			return 0;
>>=20
>> -		return mark_reg_read(env, reg, reg->parent);
>> +		if (rw64)
>> +			mark_insn_zext(env, reg);
>> +
>> +		return mark_reg_read(env, reg, reg->parent,
>> +				     rw64 ? REG_LIVE_READ64 : =
REG_LIVE_READ32);
>> 	} else {
>> 		/* check whether register used as dest operand can be =
written to */
>> 		if (regno =3D=3D BPF_REG_FP) {
>> @@ -1204,6 +1319,7 @@ static int check_reg_arg(struct =
bpf_verifier_env *env, u32 regno,
>> 			return -EACCES;
>> 		}
>> 		reg->live |=3D REG_LIVE_WRITTEN;
>> +		reg->subreg_def =3D rw64 ? DEF_NOT_SUBREG : =
env->insn_idx;
>> 		if (t =3D=3D DST_OP)
>> 			mark_reg_unknown(env, regs, regno);
>> 	}
>> @@ -1383,7 +1499,8 @@ static int check_stack_read(struct =
bpf_verifier_env *env,
>> 			state->regs[value_regno].live |=3D =
REG_LIVE_WRITTEN;
>> 		}
>> 		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
>> -			      reg_state->stack[spi].spilled_ptr.parent);
>> +			      reg_state->stack[spi].spilled_ptr.parent,
>> +			      REG_LIVE_READ64);
>> 		return 0;
>> 	} else {
>> 		int zeros =3D 0;
>> @@ -1400,7 +1517,9 @@ static int check_stack_read(struct =
bpf_verifier_env *env,
>> 			return -EACCES;
>> 		}
>> 		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
>> -			      reg_state->stack[spi].spilled_ptr.parent);
>> +			      reg_state->stack[spi].spilled_ptr.parent,
>> +			      size =3D=3D BPF_REG_SIZE
>> +			      ? REG_LIVE_READ64 : REG_LIVE_READ32);
>=20
> I don't think that's correct.
> It's a parial read from a stack slot that doesn't contain a pointer.
> It can be of any size and any offset.
> Hence 4-byte read can read upper bits too.

That=E2=80=99s true. But I think this won=E2=80=99t cause correctness =
issue. Because
for stack read, we call mark_reg_read mostly to set the read bit in
=E2=80=9Clive=E2=80=9D, and it is used by stacksafe to know whether one =
stack slot
is ever used or not. Either REG_LIVE_READ64 or REG_LIVE_READ32 will
let the slot marked as =E2=80=9Cread=E2=80=9D, and let stacksafe know it =
is used.

For stack content, if it comes from eBPF register A, then it must have
been stored by STX to stack which should have triggered zero extension
on the original A if it is a sub-register. So the content is correct.

Here, the issue is stack slot read is reusing mark_reg_read, the last
parameter for stack slot read just need to let mark_reg_read know this
slot has been read, perhaps just pass REG_LIVE_READ64 for all stack
read?
   =20
>=20
>> 		if (value_regno >=3D 0) {
>> 			if (zeros =3D=3D size) {
>> 				/* any size read into register is zero =
extended,
>> @@ -2109,6 +2228,12 @@ static int check_mem_access(struct =
bpf_verifier_env *env, int insn_idx, u32 regn
>> 						    value_regno);
>> 				if (reg_type_may_be_null(reg_type))
>> 					regs[value_regno].id =3D =
++env->id_gen;
>> +				/* A load of ctx field could have =
different
>> +				 * actual load size with the one encoded =
in the
>> +				 * insn. When the dst is PTR, it is for =
sure not
>> +				 * a sub-register.
>> +				 */
>> +				regs[value_regno].subreg_def =3D =
DEF_NOT_SUBREG;
>=20
> because of cases like above I think that DEF_NOT_SUBREG=3D=3D0 is a =
safer choice.
> To make any mark_reg_* to set it DEF_NOT_SUBREG and only two places
> would have to do dst_reg->subreg_def =3D env->insn_idx + 1;

>=20
>> 			}
>> 			regs[value_regno].type =3D reg_type;
>> 		}
>> @@ -2368,7 +2493,9 @@ static int check_stack_boundary(struct =
bpf_verifier_env *env, int regno,
>> 		 * the whole slot to be marked as 'read'
>> 		 */
>> 		mark_reg_read(env, &state->stack[spi].spilled_ptr,
>> -			      state->stack[spi].spilled_ptr.parent);
>> +			      state->stack[spi].spilled_ptr.parent,
>> +			      access_size =3D=3D BPF_REG_SIZE
>> +			      ? REG_LIVE_READ64 : REG_LIVE_READ32);
>> 	}
>> 	return update_stack_depth(env, state, min_off);
>> }
>> @@ -3332,6 +3459,9 @@ static int check_helper_call(struct =
bpf_verifier_env *env, int func_id, int insn
>> 		check_reg_arg(env, caller_saved[i], DST_OP_NO_MARK);
>> 	}
>>=20
>> +	/* helper call returns 64-bit value. */
>> +	regs[BPF_REG_0].subreg_def =3D DEF_NOT_SUBREG;
>> +
>> 	/* update return register (already marked as written above) */
>> 	if (fn->ret_type =3D=3D RET_INTEGER) {
>> 		/* sets type to SCALAR_VALUE */
>> @@ -4263,6 +4393,7 @@ static int check_alu_op(struct bpf_verifier_env =
*env, struct bpf_insn *insn)
>> 				 */
>> 				*dst_reg =3D *src_reg;
>> 				dst_reg->live |=3D REG_LIVE_WRITTEN;
>> +				dst_reg->subreg_def =3D DEF_NOT_SUBREG;
>> 			} else {
>> 				/* R1 =3D (u32) R2 */
>> 				if (is_pointer_value(env, =
insn->src_reg)) {
>> @@ -4273,6 +4404,7 @@ static int check_alu_op(struct bpf_verifier_env =
*env, struct bpf_insn *insn)
>> 				} else if (src_reg->type =3D=3D =
SCALAR_VALUE) {
>> 					*dst_reg =3D *src_reg;
>> 					dst_reg->live |=3D =
REG_LIVE_WRITTEN;
>> +					dst_reg->subreg_def =3D =
env->insn_idx;
>> 				} else {
>> 					mark_reg_unknown(env, regs,
>> 							 insn->dst_reg);
>> @@ -5352,6 +5484,8 @@ static int check_ld_abs(struct bpf_verifier_env =
*env, struct bpf_insn *insn)
>> 	 * Already marked as written above.
>> 	 */
>> 	mark_reg_unknown(env, regs, BPF_REG_0);
>> +	/* ld_abs load up to 32-bit skb data. */
>> +	regs[BPF_REG_0].subreg_def =3D env->insn_idx;
>> 	return 0;
>> }
>>=20
>> @@ -6292,20 +6426,33 @@ static bool states_equal(struct =
bpf_verifier_env *env,
>> 	return true;
>> }
>>=20
>> +/* Return 0 if no propagation happened. Return negative error code =
if error
>> + * happened. Otherwise, return the propagated bit.
>> + */
>> static int propagate_liveness_reg(struct bpf_verifier_env *env,
>> 				  struct bpf_reg_state *reg,
>> 				  struct bpf_reg_state *parent_reg)
>> {
>> +	u8 parent_flag =3D parent_reg->live & REG_LIVE_READ;
>> +	u8 flag =3D reg->live & REG_LIVE_READ;
>> 	int err;
>>=20
>> -	if (parent_reg->live & REG_LIVE_READ || !(reg->live & =
REG_LIVE_READ))
>> +	/* When comes here, read flags of PARENT_REG or REG could be any =
of
>> +	 * REG_LIVE_READ64, REG_LIVE_READ32, REG_LIVE_NONE. There is no =
need
>> +	 * of propagation if PARENT_REG has strongest REG_LIVE_READ64.
>> +	 */
>> +	if (parent_flag =3D=3D REG_LIVE_READ64 ||
>> +	    /* Or if there is no read flag from REG. */
>> +	    !flag ||
>> +	    /* Or if the read flag from REG is the same as PARENT_REG. =
*/
>> +	    parent_flag =3D=3D flag)
>> 		return 0;
>>=20
>> -	err =3D mark_reg_read(env, reg, parent_reg);
>> +	err =3D mark_reg_read(env, reg, parent_reg, flag);
>> 	if (err)
>> 		return err;
>>=20
>> -	return 0;
>> +	return flag;
>> }
>>=20
>> /* A write screens off any subsequent reads; but write marks come =
from the
>> @@ -6339,8 +6486,10 @@ static int propagate_liveness(struct =
bpf_verifier_env *env,
>> 		for (i =3D frame < vstate->curframe ? BPF_REG_6 : 0; i < =
BPF_REG_FP; i++) {
>> 			err =3D propagate_liveness_reg(env, =
&state_reg[i],
>> 						     &parent_reg[i]);
>> -			if (err)
>> +			if (err < 0)
>> 				return err;
>> +			if (err =3D=3D REG_LIVE_READ64)
>> +				mark_insn_zext(env, &parent_reg[i]);
>> 		}
>>=20
>> 		/* Propagate stack slots. */
>> @@ -6350,11 +6499,11 @@ static int propagate_liveness(struct =
bpf_verifier_env *env,
>> 			state_reg =3D &state->stack[i].spilled_ptr;
>> 			err =3D propagate_liveness_reg(env, state_reg,
>> 						     parent_reg);
>> -			if (err)
>> +			if (err < 0)
>> 				return err;
>> 		}
>> 	}
>> -	return err;
>> +	return 0;
>> }
>>=20
>> static int is_state_visited(struct bpf_verifier_env *env, int =
insn_idx)
>> --=20
>> 2.7.4

