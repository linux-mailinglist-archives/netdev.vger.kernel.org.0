Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC4AB180899
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 20:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgCJTyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 15:54:37 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40002 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgCJTye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 15:54:34 -0400
Received: by mail-pf1-f196.google.com with SMTP id l184so6986813pfl.7;
        Tue, 10 Mar 2020 12:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Y4tA04pXdn66xtIddT5nQMb5sFPUgMMqbHV1x3je3pI=;
        b=IMyOf2F3fK5McXdqe72kP6J++XnfPnSlV0xqs5dqaXxf3gAsfEu7ScOnRKy7blgMLk
         fhGFnIFxQw0kOHNwCB1HvnpTQ1qeOpvDfYJovdFn3uFgsL0AEZ4WtIoBCQxZ48Rhdqwq
         0B12zBvg09S9zmA3lGezjXY03reQcqWi+eIYNLyT1X9CIjkdT4/oastHIIlfVVHzaSEq
         feyP1+BW5x5Sb863q3IMX4ZKHt2hGTLLw2svcqykfPR33L286xcGaO5dyCogCX91HcuI
         fa5NzMvQJ5npKVp02e+RJNHeD1/lczcEMWJeb4CQYMpdNgnwLMDukw2wI2ypgviV5e7J
         4yzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Y4tA04pXdn66xtIddT5nQMb5sFPUgMMqbHV1x3je3pI=;
        b=eQm67S6oZt0cmvAwQ1Y07qkakBXN3y+hv7Gpuz8ZtylKkl476qLDs76GAraLiPQOyu
         d5jsHGiwF6BZSEy6ElJ/ESl9k+vIiusp0IZH7qOgA2Em5XT1R2Bgh2lYs/xwk3O3mmd5
         qPmosibD0rfCFZILBOJ5r17KxAhF2O2L29RqGqScby95U7sxUa3hj7Eymn1nAiGcvwB7
         104gcsX13SccaMdbj9NPBwDVrkWhOUWtepH/84OUdPFUnKUrsDfNwbuPiEgl8dJ2JTvS
         wvrtoCqCSQq3XSWjVipqmv++aHuHOvNvtqhCWu5flItTpGDCNjWuQeDM4Pia0OHqbHsU
         gnEw==
X-Gm-Message-State: ANhLgQ0tF+hYdEfPxtZ34WSru+FM16reovHiNaN7j3fa2yX4y18bQI6A
        yMDr49pZYsLZs3CrLoAFydk=
X-Google-Smtp-Source: ADFU+vtGFN11GEgtLvyIiXGr0pihFV7pugxka5iVIHYOsmvD2j7dQiAHsO8aUTZYGgYAzg8UloQh5A==
X-Received: by 2002:a63:382:: with SMTP id 124mr22756503pgd.49.1583870072018;
        Tue, 10 Mar 2020 12:54:32 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s18sm3026176pjp.24.2020.03.10.12.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 12:54:31 -0700 (PDT)
Date:   Tue, 10 Mar 2020 12:54:23 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5e67f06f526b1_586d2b10f16785b82b@john-XPS-13-9370.notmuch>
In-Reply-To: <e41f7369-1215-43fb-6418-5ff37310eeae@fb.com>
References: <158353965971.3451.14666851223845760316.stgit@ubuntu3-kvm2>
 <158353986285.3451.6986018098665897886.stgit@ubuntu3-kvm2>
 <e41f7369-1215-43fb-6418-5ff37310eeae@fb.com>
Subject: Re: [RFC PATCH 2/4] bpf: verifier, do explicit u32 bounds tracking
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong Song wrote:
> 
> 
> On 3/6/20 4:11 PM, John Fastabend wrote:
> > It is not possible for the current verifier to track u32 alu ops and jmps
> > correctly. This can result in the verifier aborting with errors even though
> > the program should be verifiable. Cilium code base has hit this but worked
> > around it by changing int variables to u64 variables and marking a few
> > things volatile. It would be better to avoid these tricks.
> > 
> > But, the main reason to address this now is do_refine_retval_range() was
> > assuming return values could not be negative. Once we fix this in the
> > next patches code that was previously working will no longer work.
> > See do_refine_retval_range() patch for details.
> > 
> > The simplest example code snippet that illustrates the problem is likelyy
> > this,
> > 
> >   53: w8 = w0                    // r8 <- [0, S32_MAX],
> >                                  // w8 <- [-S32_MIN, X]
> >   54: w8 <s 0                    // r8 <- [0, U32_MAX]
> >                                  // w8 <- [0, X]
> > 
> > The expected 64-bit and 32-bit bounds after each line are shown on the
> > right. The current issue is without the w* bounds we are forced to use
> > the worst case bound of [0, U32_MAX]. To resolve this type of case,
> > jmp32 creating divergent 32-bit bounds from 64-bit bounds, we add explicit
> > 32-bit register bounds s32_{min|max}_value, u32_{min|max}_value, and
> > var32_off. Then from branch_taken logic creating new bounds we can
> > track 32-bit bounds explicitly.
> > 
> > The next case we observed is ALU ops after the jmp32,
> > 
> >   53: w8 = w0                    // r8 <- [0, S32_MAX],
> >                                  // w8 <- [-S32_MIN, X]
> >   54: w8 <s 0                    // r8 <- [0, U32_MAX]
> >                                  // w8 <- [0, X]
> >   55: w8 += 1                    // r8 <- [0, U32_MAX+1]
> >                                  // w8 <- [0, X+1]
> > 
> > In order to keep the bounds accurate at this point we also need to track
> > ALU32 ops. To do this we add explicit alu32 logic for each of the alu
> > ops, mov, add, sub, etc.
> > 
> > Finally there is a question of how and when to merge bounds. The cases
> > enumerate here,
> > 
> > 1. MOV ALU32   - zext 32-bit -> 64-bit
> > 2. MOV ALU64   - copy 64-bit -> 32-bit
> > 3. op  ALU32   - zext 32-bit -> 64-bit
> > 4. op  ALU64   - n/a
> > 5. jmp ALU32   - 64-bit: var32_off | var64_off
> > 6. jmp ALU64   - 32-bit: (>> (<< var64_off))
> > 
> > Details for each case,
> > 
> > For "MOV ALU32" BPF arch zero extends so we simply copy the bounds
> > from 32-bit into 64-bit ensuring we cast the var32_off. See zext_32_to_64.
> > 
> > For "MOV ALU64" copy all bounds including 32-bit into new register. If
> > the src register had 32-bit bounds the dst register will as well.
> > 
> > For "op ALU32" zero extend 32-bit into 64-bit, see zext_32_to_64.
> > 
> > For "op ALU64" calculate both 32-bit and 64-bit bounds no merging
> > is done here. Except we have a special case. When RSH or ARSH is
> > done we can't simply ignore shifting bits from 64-bit reg into the
> > 32-bit subreg. So currently just push bounds from 64-bit into 32-bit.
> > This will be correct in the sense that they will represent a valid
> > state of the register. However we could lose some accuracy if an
> > ARSH is following a jmp32 operation. We can handle this special
> > case in a follow up series.
> > 
> > For "jmp ALU32" mark 64-bit reg unknown and recalculate 64-bit bounds
> > from tnum by setting var_off to ((<<(>>var_off)) | var32_off). We
> > special case if 64-bit bounds has zero'd upper 32bits at which point
> > wee can simply copy 32-bit bounds into 64-bit register. This catches
> > a common compiler trick where upper 32-bits are zeroed and then
> > 32-bit ops are used followed by a 64-bit compare or 64-bit op on
> > a pointer. See __reg_combine_64_into_32().
> > 
> > For "jmp ALU64" cast the bounds of the 64bit to their 32-bit
> > counterpart. For example s32_min_value = (s32)reg->smin_value. For
> > tnum use only the lower 32bits via, (>>(<<var_off)). See
> > __reg_combine_64_into_32().
> > 
> > Some questions and TBDs aka the RFC part,
> > 
> >   0) opinions on the approach?
> > 
> >   1) We currently tnum always has 64-bits even for the 32-bit tnum
> >      tracking. I think ideally we convert the tnum var32_off to a
> >      32-bit type so the types are correct both in the verifier and
> >      from what it is tracking. But this in turn means we end up
> >      with tnum32 ops. It seems to not be strictly needed though so
> >      I'm saving it for a follow up series. Any thoughts?
> > 
> >      struct tnum {
> >         u64 value;
> >         u64 mask;
> >      }
> > 
> >      struct tnum32 {
> >         u32 value;
> >         u32 mask;
> >      }
> > 
> >   2) I guess this patch could be split into two and still be
> >      workable. First patch to do alu32 logic and second to
> >      do jmp32 logic. I slightly prefer the single big patch
> >      to keep all the logic in one patch but it makes for a
> >      large change. I'll tear it into two if folks care.
> > 
> >   3) This is passing test_verifier I need to run test_progs
> >      all the way through still. My test box missed a few tests
> >      due to kernel feature flags.
> > 
> >   4) I'm testing Cilium now as well to be sure we are still
> >      working there.
> > 
> >   5) Do we like this approach? Should we push it all the way
> >      through to stable? We need something for stable and I
> >      haven't found a better solution yet. Its a good chunk
> >      of code though if we do that we probably want the fuzzers
> >      to run over it first.
> > 
> >   6) I need to do another review pass.
> > 
> >   7) I'm writing a set of verifier tests to exercise some of
> >      the more subtle 32 vs 64-bit cases now.
> > 
> >   8) I have a small test patch I use with test_verifier to
> >      dump the verifier state every line which I find helpful
> >      I'll push it to bpf-next in case anyone else cares to
> >      use it.
> 
> As reading the patch, a few minor comments below.
> 
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >   tools/testing/selftests/bpf/test_verifier.c |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> [...]
> >   
> > +/* BPF architecture zero extends alu32 ops into 64-bit registesr */
> > +static void zext_32_to_64(struct bpf_reg_state *reg)
> > +{
> > +	reg->var_off = reg->var32_off = tnum_cast(reg->var32_off, 4);
> > +	reg->umin_value = reg->smin_value = reg->u32_min_value;
> 
> reg->smin_value = reg->u32_min_value? Could you explain?

First zero extending smin_value > 0 the s32_min_value is not
relevant here. The only lower bound we can claim is the
u32_min_value. I'll send a v2 with a comment explaining better
the above answer feels a bit hand-waving to me at the moment.

> 
> > +	reg->umax_value = reg->smax_value = reg->u32_max_value;
> > +}
> >   
> >   /* truncate register to smaller size (in bytes)
> >    * must be called with size < BPF_REG_SIZE
> > @@ -2791,6 +2957,7 @@ static int check_tp_buffer_access(struct bpf_verifier_env *env,
> >   static void coerce_reg_to_size(struct bpf_reg_state *reg, int size)
> >   {
> >   	u64 mask;
> > +	u32 u32mask;
> >   
> >   	/* clear high bits in bit representation */
> >   	reg->var_off = tnum_cast(reg->var_off, size);
> > @@ -2804,8 +2971,36 @@ static void coerce_reg_to_size(struct bpf_reg_state *reg, int size)
> >   		reg->umin_value = 0;
> >   		reg->umax_value = mask;
> >   	}
> > +
> > +	/* TBD this is its own patch */
> > +	if (reg->smin_value < 0 || reg->smax_value > reg->umax_value)
> 
> When reg->smax_value > reg->umax_value could happen?
> 
> > +		reg->smax_value = reg->umax_value;
> > +	else
> > +		reg->umax_value = reg->smax_value;
> 
> Not quite understand the above logic.

I'll drop this for now. But maybe it helps to write it this
way,

  if (reg->smin_value > 0 && reg->smax_value < reg->umax_value)
     reg->umax_value = reg->smax_value;

> 
> 
> >   	reg->smin_value = reg->umin_value;
> > -	reg->smax_value = reg->umax_value;
> > +
> > +	/* If size is smaller than 32bit register the 32bit register
> > +	 * values are also truncated.
> > +	 */
> > +	if (size >= 4) {
> > +		reg->var32_off = tnum_cast(reg->var_off, 4);
> > +		return;
> > +	}
> > +
> > +	reg->var32_off = tnum_cast(reg->var_off, size);
> > +	u32mask = ((u32)1 << (size *8)) - 1;
> 
> Looks like here u32mask trying to remove the 32bit sign and try to 
> compare values. Not quite follow the logic below.

Its convoluted for sure. I'll clean this up in a v2 and it hopefully
will be clear.
