Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10491180446
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgCJREJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:04:09 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34603 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbgCJREJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:04:09 -0400
Received: by mail-pg1-f195.google.com with SMTP id t3so6586961pgn.1;
        Tue, 10 Mar 2020 10:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=lrG3ZucMdCcyeqyrVpI+vBHvy4Tg83he6u8Wj9VL7EA=;
        b=vfTezu0+R0NfBVEwSWE0hLsYLe4O3zJsZ0wgOJd2hqkcJ9j0h51dQnNuDNKPLYaN0A
         kqBfLKC9x6yNwZJuHc/aOx9jEtnPlSbyiiy8bxWtKmnkhgO+7WO7939ORhc8OsWK1hog
         oZ7vE5admdVZeh0YagmbKeSbIGVUWHbbH4PeqlXATCsy/PgP4+KyMqw2YIxgJWe2rXzZ
         d6+9gnILZ8qLxOgjLQIKPBLzImG63ZCGrQe2qECRRkA+AuOHjYQhxoDRY9ZpbfAwiuO/
         Fyf9W0efAdfw2IVuHnts4hvhuUY+pwNA0cGMos4bV4OVnfqfqnSLWWiLDvmxuSE27lZt
         vDFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=lrG3ZucMdCcyeqyrVpI+vBHvy4Tg83he6u8Wj9VL7EA=;
        b=YmLWt6VCG3dpLzb/Z7Po5ADsCfoHGZTiGumNPop0RGvOcUSFSGRcBUWgfQ8uGFsMvM
         FSnqF+cDXD6C4gah6n72zWr1pS9GCSJ+XhZJ8oHi+GQs5DrCWdQtSkehFJYNH4S+uSR6
         NsQitt6FsJolMRXRGEsU96fMiQb+oDOudpy32XVOXRKpVTenBfqUaM/zgyf6oaaeJ/77
         Eo6eg5HwE98IKG8vUpKZR6w/z7Nf1iBpsqLOHVzv/7Xp1cXh9V6oeaTdm2kqa4FNJG/d
         i7NfuH/RUuoNw5szT52zlq4K4Im6MRxVGLBHKwc4suVuEZ/sWLnwevcrEYDpKQT4JGa2
         80PQ==
X-Gm-Message-State: ANhLgQ3lLcfIf60HPl76porWjYKS/Adn8yXVrL/KBdGhYQAzeHTUu7Bg
        XMq6YbMgVEt5Z4qjXP8OPKg=
X-Google-Smtp-Source: ADFU+vv9KvcYMdxwNxd5rfv0Rh7dedLesnQACNDnW1qSeq23OcaJmLRxWYAANdPOnnpTJiR1X0yisQ==
X-Received: by 2002:a62:194c:: with SMTP id 73mr2281669pfz.159.1583859848018;
        Tue, 10 Mar 2020 10:04:08 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k16sm10589062pfa.10.2020.03.10.10.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 10:04:07 -0700 (PDT)
Date:   Tue, 10 Mar 2020 10:04:00 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     yhs@fb.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Message-ID: <5e67c8802f8e9_1e8a2b0e88e0a5bcc@john-XPS-13-9370.notmuch>
In-Reply-To: <20200309235828.wldukb66bdwy2dzd@ast-mbp>
References: <158353965971.3451.14666851223845760316.stgit@ubuntu3-kvm2>
 <158353986285.3451.6986018098665897886.stgit@ubuntu3-kvm2>
 <20200309235828.wldukb66bdwy2dzd@ast-mbp>
Subject: Re: [RFC PATCH 2/4] bpf: verifier, do explicit u32 bounds tracking
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Sat, Mar 07, 2020 at 12:11:02AM +0000, John Fastabend wrote:
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

[...]

> > Some questions and TBDs aka the RFC part,
> > 
> >  0) opinions on the approach?
> 
> thanks a lot for working it!
> That's absolutely essential verifier improvement.

Agreed, this works nicely with some of our codes and removes a
bunch of hacks we had to get C code verified, using uint64_t
unnecessarily for example and some scattered volatiles.

> 
> s32_{min|max}_value, u32_{min|max}_value are necessary, for sure.
> but could you explain why permanent var32_off is necessary too?
> It seems to me var32_off is always temporary and doesn't need to
> be part of bpf_reg_state.
> It seems scalar32_min_max_sub/add/... funcs can operate on var_off
> with 32-bit masking or they can accept 'struct tnum *' as
> another argument and adjust_scalar_min_max_vals() can have
> stack local var32_off that gets adjusted similar to what you have:
>   if (alu32)
>     zext_32_to_64(dst_reg);
> at the end?
> but with local var32_off passed into zext_32_to_64().

Seems better to me. Will use a temporary variable.

> 
> In a bunch of places the verifier looks at var_off directly and
> I don't think it needs to look at var32_off.
> Thinking about it differently... var_off is a bit representation of
> 64-bit register. So that bit representation doesn't really have
> 32 or 16-bit chunks. It's a full 64-bit register. I think all alu32
> and jmp32 ops can update var_off without losing information.

+1

> 
> Surely having var32_off in reg_state makes copy-pasting scalar_min_max
> into scalar32_min_max easier, but with temporary var_off it should
> be just as easy to copy-paste...

Doesn't really make the code any harder to read/write imo

> 
> >  1) We currently tnum always has 64-bits even for the 32-bit tnum
> >     tracking. I think ideally we convert the tnum var32_off to a
> >     32-bit type so the types are correct both in the verifier and
> >     from what it is tracking. But this in turn means we end up
> >     with tnum32 ops. It seems to not be strictly needed though so
> >     I'm saving it for a follow up series. Any thoughts?
> > 
> >     struct tnum {
> >        u64 value;
> >        u64 mask;
> >     }
> > 
> >     struct tnum32 {
> >        u32 value;
> >        u32 mask;
> >     }
> 
> I wouldn't bother.

Per above we can skip adding tnum32 to registers but I think we need
to have 32-bit tnum ops.

For example, BPF_ADD will do a tnum_add() this is a different
operation when overflows happen compared to tnum32_add(). Simply
truncating tnum_add result to 32-bits is not the same operation.

> 
> >  2) I guess this patch could be split into two and still be
> >     workable. First patch to do alu32 logic and second to
> >     do jmp32 logic. I slightly prefer the single big patch
> >     to keep all the logic in one patch but it makes for a
> >     large change. I'll tear it into two if folks care.
> 
> single patch is fine by me.

good, not clear to me that ripping them apart adds anything or
is even bisectable.

> 
> >  3) This is passing test_verifier I need to run test_progs
> >     all the way through still. My test box missed a few tests
> >     due to kernel feature flags.
> > 
> >  4) I'm testing Cilium now as well to be sure we are still
> >     working there.
> > 
> >  5) Do we like this approach? Should we push it all the way
> >     through to stable? We need something for stable and I
> >     haven't found a better solution yet. Its a good chunk
> >     of code though if we do that we probably want the fuzzers
> >     to run over it first.
> 
> eventually we can send it to older releases.
> With this much extra verifier code it has to bake in for
> a release or two.

Makes sense to me.

> 
> >  6) I need to do another review pass.
> > 
> >  7) I'm writing a set of verifier tests to exercise some of
> >     the more subtle 32 vs 64-bit cases now.
> 
> +1
> 
> >  		}
> > +		scalar32_min_max_add(dst_reg, &src_reg);
> >  		scalar_min_max_add(dst_reg, &src_reg);
> >  		break;
> >  	case BPF_SUB:
> > @@ -5131,25 +5635,19 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> >  			verbose(env, "R%d tried to sub from different pointers or scalars\n", dst);
> >  			return ret;
> >  		}
> > +		scalar32_min_max_sub(dst_reg, &src_reg);
> >  		scalar_min_max_sub(dst_reg, &src_reg);
> >  		break;
> >  	case BPF_MUL:
> > +		scalar32_min_max_mul(dst_reg, &src_reg);
> >  		scalar_min_max_mul(dst_reg, &src_reg);
> 
> I think it's correct to keep adjusting 64-bit and 32-bit min/max
> individually for every alu, but it feels that var_off should be common.

+1.
