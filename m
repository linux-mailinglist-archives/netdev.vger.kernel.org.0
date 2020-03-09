Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9760317ECF3
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 00:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgCIX6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 19:58:35 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39565 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727143AbgCIX6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 19:58:34 -0400
Received: by mail-pl1-f195.google.com with SMTP id j20so4658205pll.6;
        Mon, 09 Mar 2020 16:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NmQYWpcTP8I5Ko3cbga3LrE5MI1w4+kEnJc7a8Uw8ZY=;
        b=vb9F1idfpU/2F0ZxpMPcPcph7a9LbP23tSsk6YLSAeZ/dr8Sg+iWck5r0+LJtnZT0v
         MUEh6IsbWyJMTJUkwb8lu8X/phs/r8DmkoosPZFGsagpivf2QsjYPDpAfVhn3pmCJMet
         L4mp+61TJfU4iUqkoyo993oGmWl8OBEAs8mGpdAaEdvWTAbTPZhiPgnm9TMEBk48JD02
         LGnviGL2QiHvIiwnI0qDkyTrJkZFaUAWYb57cqn10X+g9+a65Ar91/00ba0UVJKiwkaU
         ykvazET8vPBmDw7NHE5zHqCHaNF7e84wlbYN23Un3DnBmnT0AEtLmSBlWDyWTDakYKJ9
         MlWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NmQYWpcTP8I5Ko3cbga3LrE5MI1w4+kEnJc7a8Uw8ZY=;
        b=KBZtDEdGGb7KH5xGmGiiHWD/N13h6BMRnDkqvRiuQfSOpXH9tNqSuqP6J4nr6eNMm2
         qYjeOag2bAvWibB2dYaRDD1NVTed1c4/YFNVs6IjkA28vw1bsFA9iM3l2wx40Dk8US3o
         ZSlK8nXkbuL55x10hDkUpbFiRIo5Gin+B6mePZXPqDSS4mBiMjNE42KLKE6wnq7drTrB
         +kc3h8aiAFhHJo4VajSuI0s0Vabr7lepUXncUmD5alk7x8LF4U7CMCpSuxM8UkpxQ8GS
         CGuPnjv7xBp6+vCbgidr6QyOXAJ8Fe3kzlnggO26f1pHqkECzPUc/+pl4gjH9wFUwfTi
         A+GQ==
X-Gm-Message-State: ANhLgQ3Vo7kh7pwVmx5KkFhKkEr9QKCioQXgXKLvAFDZ5MY7e0/hUyWL
        ccYxhEHqHVf5/cJ0n3k480I=
X-Google-Smtp-Source: ADFU+vuIahbi5Tm/dpCxb9mVp2ryjilIS2BS7KYsA5C0coiSTh1qPj5eKuElgFxKevRUe5JYEjVZMA==
X-Received: by 2002:a17:90a:240f:: with SMTP id h15mr1929252pje.176.1583798313493;
        Mon, 09 Mar 2020 16:58:33 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:500::7:4bc0])
        by smtp.gmail.com with ESMTPSA id s21sm17720586pfd.99.2020.03.09.16.58.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Mar 2020 16:58:31 -0700 (PDT)
Date:   Mon, 9 Mar 2020 16:58:30 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     yhs@fb.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] bpf: verifier, do explicit u32 bounds tracking
Message-ID: <20200309235828.wldukb66bdwy2dzd@ast-mbp>
References: <158353965971.3451.14666851223845760316.stgit@ubuntu3-kvm2>
 <158353986285.3451.6986018098665897886.stgit@ubuntu3-kvm2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158353986285.3451.6986018098665897886.stgit@ubuntu3-kvm2>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 07, 2020 at 12:11:02AM +0000, John Fastabend wrote:
> It is not possible for the current verifier to track u32 alu ops and jmps
> correctly. This can result in the verifier aborting with errors even though
> the program should be verifiable. Cilium code base has hit this but worked
> around it by changing int variables to u64 variables and marking a few
> things volatile. It would be better to avoid these tricks.
> 
> But, the main reason to address this now is do_refine_retval_range() was
> assuming return values could not be negative. Once we fix this in the
> next patches code that was previously working will no longer work.
> See do_refine_retval_range() patch for details.
> 
> The simplest example code snippet that illustrates the problem is likelyy
> this,
> 
>  53: w8 = w0                    // r8 <- [0, S32_MAX],
>                                 // w8 <- [-S32_MIN, X]
>  54: w8 <s 0                    // r8 <- [0, U32_MAX]
>                                 // w8 <- [0, X]
> 
> The expected 64-bit and 32-bit bounds after each line are shown on the
> right. The current issue is without the w* bounds we are forced to use
> the worst case bound of [0, U32_MAX]. To resolve this type of case,
> jmp32 creating divergent 32-bit bounds from 64-bit bounds, we add explicit
> 32-bit register bounds s32_{min|max}_value, u32_{min|max}_value, and
> var32_off. Then from branch_taken logic creating new bounds we can
> track 32-bit bounds explicitly.
> 
> The next case we observed is ALU ops after the jmp32,
> 
>  53: w8 = w0                    // r8 <- [0, S32_MAX],
>                                 // w8 <- [-S32_MIN, X]
>  54: w8 <s 0                    // r8 <- [0, U32_MAX]
>                                 // w8 <- [0, X]
>  55: w8 += 1                    // r8 <- [0, U32_MAX+1]
>                                 // w8 <- [0, X+1]
> 
> In order to keep the bounds accurate at this point we also need to track
> ALU32 ops. To do this we add explicit alu32 logic for each of the alu
> ops, mov, add, sub, etc.
> 
> Finally there is a question of how and when to merge bounds. The cases
> enumerate here,
> 
> 1. MOV ALU32   - zext 32-bit -> 64-bit
> 2. MOV ALU64   - copy 64-bit -> 32-bit
> 3. op  ALU32   - zext 32-bit -> 64-bit
> 4. op  ALU64   - n/a
> 5. jmp ALU32   - 64-bit: var32_off | var64_off
> 6. jmp ALU64   - 32-bit: (>> (<< var64_off))
> 
> Details for each case,
> 
> For "MOV ALU32" BPF arch zero extends so we simply copy the bounds
> from 32-bit into 64-bit ensuring we cast the var32_off. See zext_32_to_64.
> 
> For "MOV ALU64" copy all bounds including 32-bit into new register. If
> the src register had 32-bit bounds the dst register will as well.
> 
> For "op ALU32" zero extend 32-bit into 64-bit, see zext_32_to_64.
> 
> For "op ALU64" calculate both 32-bit and 64-bit bounds no merging
> is done here. Except we have a special case. When RSH or ARSH is
> done we can't simply ignore shifting bits from 64-bit reg into the
> 32-bit subreg. So currently just push bounds from 64-bit into 32-bit.
> This will be correct in the sense that they will represent a valid
> state of the register. However we could lose some accuracy if an
> ARSH is following a jmp32 operation. We can handle this special
> case in a follow up series.
> 
> For "jmp ALU32" mark 64-bit reg unknown and recalculate 64-bit bounds
> from tnum by setting var_off to ((<<(>>var_off)) | var32_off). We
> special case if 64-bit bounds has zero'd upper 32bits at which point
> wee can simply copy 32-bit bounds into 64-bit register. This catches
> a common compiler trick where upper 32-bits are zeroed and then
> 32-bit ops are used followed by a 64-bit compare or 64-bit op on
> a pointer. See __reg_combine_64_into_32().
> 
> For "jmp ALU64" cast the bounds of the 64bit to their 32-bit
> counterpart. For example s32_min_value = (s32)reg->smin_value. For
> tnum use only the lower 32bits via, (>>(<<var_off)). See
> __reg_combine_64_into_32().
> 
> Some questions and TBDs aka the RFC part,
> 
>  0) opinions on the approach?

thanks a lot for working it!
That's absolutely essential verifier improvement.

s32_{min|max}_value, u32_{min|max}_value are necessary, for sure.
but could you explain why permanent var32_off is necessary too?
It seems to me var32_off is always temporary and doesn't need to
be part of bpf_reg_state.
It seems scalar32_min_max_sub/add/... funcs can operate on var_off
with 32-bit masking or they can accept 'struct tnum *' as
another argument and adjust_scalar_min_max_vals() can have
stack local var32_off that gets adjusted similar to what you have:
  if (alu32)
    zext_32_to_64(dst_reg);
at the end?
but with local var32_off passed into zext_32_to_64().

In a bunch of places the verifier looks at var_off directly and
I don't think it needs to look at var32_off.
Thinking about it differently... var_off is a bit representation of
64-bit register. So that bit representation doesn't really have
32 or 16-bit chunks. It's a full 64-bit register. I think all alu32
and jmp32 ops can update var_off without losing information.

Surely having var32_off in reg_state makes copy-pasting scalar_min_max
into scalar32_min_max easier, but with temporary var_off it should
be just as easy to copy-paste...

>  1) We currently tnum always has 64-bits even for the 32-bit tnum
>     tracking. I think ideally we convert the tnum var32_off to a
>     32-bit type so the types are correct both in the verifier and
>     from what it is tracking. But this in turn means we end up
>     with tnum32 ops. It seems to not be strictly needed though so
>     I'm saving it for a follow up series. Any thoughts?
> 
>     struct tnum {
>        u64 value;
>        u64 mask;
>     }
> 
>     struct tnum32 {
>        u32 value;
>        u32 mask;
>     }

I wouldn't bother.

>  2) I guess this patch could be split into two and still be
>     workable. First patch to do alu32 logic and second to
>     do jmp32 logic. I slightly prefer the single big patch
>     to keep all the logic in one patch but it makes for a
>     large change. I'll tear it into two if folks care.

single patch is fine by me.

>  3) This is passing test_verifier I need to run test_progs
>     all the way through still. My test box missed a few tests
>     due to kernel feature flags.
> 
>  4) I'm testing Cilium now as well to be sure we are still
>     working there.
> 
>  5) Do we like this approach? Should we push it all the way
>     through to stable? We need something for stable and I
>     haven't found a better solution yet. Its a good chunk
>     of code though if we do that we probably want the fuzzers
>     to run over it first.

eventually we can send it to older releases.
With this much extra verifier code it has to bake in for
a release or two.

>  6) I need to do another review pass.
> 
>  7) I'm writing a set of verifier tests to exercise some of
>     the more subtle 32 vs 64-bit cases now.

+1

>  		}
> +		scalar32_min_max_add(dst_reg, &src_reg);
>  		scalar_min_max_add(dst_reg, &src_reg);
>  		break;
>  	case BPF_SUB:
> @@ -5131,25 +5635,19 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
>  			verbose(env, "R%d tried to sub from different pointers or scalars\n", dst);
>  			return ret;
>  		}
> +		scalar32_min_max_sub(dst_reg, &src_reg);
>  		scalar_min_max_sub(dst_reg, &src_reg);
>  		break;
>  	case BPF_MUL:
> +		scalar32_min_max_mul(dst_reg, &src_reg);
>  		scalar_min_max_mul(dst_reg, &src_reg);

I think it's correct to keep adjusting 64-bit and 32-bit min/max
individually for every alu, but it feels that var_off should be common.
