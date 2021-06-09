Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB193A1AD7
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 18:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbhFIQ0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 12:26:43 -0400
Received: from mail-il1-f180.google.com ([209.85.166.180]:41712 "EHLO
        mail-il1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhFIQ0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 12:26:42 -0400
Received: by mail-il1-f180.google.com with SMTP id t6so20028710iln.8;
        Wed, 09 Jun 2021 09:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=UV5ISwuSm2BiKNUsyJD3w95GG8YyIiHOJd/kM+0brmY=;
        b=T6Af8+J62s99JyGpcp0DqcM1fQpv48s7/iWVlNdu0hED68WdgC6NM1ghqb2iGzvBb6
         fcKOE8Tv8+zITxyVRpZsrGUIekUlohE2soudjaJhQJM1BYf/zYlqnr971iaxH3KjRvZ3
         1lZ2mP9jsLG7byQlmcvK4//K0/8NReX7wc4KsLY3huJhKzG4SxEWK41yI32Kvy3Ap9Kl
         XjtX6VMcCqhf8oUMJ5xPVGhdt7FLTmj6tBKBgJlKHT4AWxSwxIIjOfTCmo8W0TnnViZc
         SNhdSqmTkAaWgejQIOJ/FOqsJ9dvty3rU+NrallQymjq3forsPtKkyfgLZYfOCvoZlcN
         gL5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=UV5ISwuSm2BiKNUsyJD3w95GG8YyIiHOJd/kM+0brmY=;
        b=XCELETrh7RzG8wdXj1ZBe/S0CTTytzUVusdFH7N9+TJJgy6rMvGPnh+/4qWUF11fXJ
         N8be/NiLyTeDmJR468V6rVrUtPuEYT1EdiJSK9xCLk3c1IN6fyF7PJbmhg7vsHJ2Zdh1
         TbVR449o+aJvYqykGIf+ZyYEDILaRjJ49Pl0q2KCcv+PRHyaVTa0wmYlSt0rKSflZ/S8
         ahBuykdnqZFspJds6eK4PzsUImAdfXnWl05yEAigkjS9R8GsvnBfFXHHNS6BplLtQTLw
         2voHxyIwsKGi0N0B6H1CC3BK4BvXmplkBDN1/1Fnfg9RjXGcMTGAnuoraYgQ4wtvrg+r
         092w==
X-Gm-Message-State: AOAM53292xYT58w8HOAkSntvjL5m3VxF1esqj4v9jWSnBEb0resikQXx
        gv0Pr42Iy5/nrZadTinP9/k=
X-Google-Smtp-Source: ABdhPJwZCO7Iz0fXmRCVGtmS/4rqt1YVsM+AdLhh07nrUEI3t4cyUGmVJjOuFjGAr3tpVBHK+uU4ZQ==
X-Received: by 2002:a05:6e02:1068:: with SMTP id q8mr420681ilj.276.1623255827646;
        Wed, 09 Jun 2021 09:23:47 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id j12sm322059ils.42.2021.06.09.09.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 09:23:47 -0700 (PDT)
Date:   Wed, 09 Jun 2021 09:23:39 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <60c0eb0bd56d6_9862120870@john-XPS-13-9370.notmuch>
In-Reply-To: <20210609155131.GA12061@ranger.igk.intel.com>
References: <162318053542.323820.3719766457956848570.stgit@john-XPS-13-9370>
 <162318061518.323820.4329181800429686297.stgit@john-XPS-13-9370>
 <20210609155131.GA12061@ranger.igk.intel.com>
Subject: Re: [PATCH bpf 1/2] bpf: Fix null ptr deref with mixed tail calls and
 subprogs
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> On Tue, Jun 08, 2021 at 12:30:15PM -0700, John Fastabend wrote:
> > The sub-programs prog->aux->poke_tab[] is populated in jit_subprogs() and
> > then used when emitting 'BPF_JMP|BPF_TAIL_CALL' insn->code from the
> > individual JITs. The poke_tab[] to use is stored in the insn->imm by
> > the code adding it to that array slot. The JIT then uses imm to find the
> > right entry for an individual instruction. In the x86 bpf_jit_comp.c
> > this is done by calling emit_bpf_tail_call_direct with the poke_tab[]
> > of the imm value.
> > 
> > However, we observed the below null-ptr-deref when mixing tail call
> > programs with subprog programs. For this to happen we just need to
> > mix bpf-2-bpf calls and tailcalls with some extra calls or instructions
> > that would be patched later by one of the fixup routines. So whats
> > happening?
> > 
> > Before the fixup_call_args() -- where the jit op is done -- various
> > code patching is done by do_misc_fixups(). This may increase the
> > insn count, for example when we patch map_lookup_up using map_gen_lookup
> > hook. This does two things. First, it means the instruction index,
> > insn_idx field, of a tail call instruction will move by a 'delta'.
> > 
> > In verifier code,
> > 
> >  struct bpf_jit_poke_descriptor desc = {
> >   .reason = BPF_POKE_REASON_TAIL_CALL,
> >   .tail_call.map = BPF_MAP_PTR(aux->map_ptr_state),
> >   .tail_call.key = bpf_map_key_immediate(aux),
> >   .insn_idx = i + delta,
> >  };
> > 
> > Then subprog start values subprog_info[i].start will be updated
> > with the delta and any poke descriptor index will also be updated
> > with the delta in adjust_poke_desc(). If we look at the adjust
> > subprog starts though we see its only adjusted when the delta
> > occurs before the new instructions,
> > 
> >         /* NOTE: fake 'exit' subprog should be updated as well. */
> >         for (i = 0; i <= env->subprog_cnt; i++) {
> >                 if (env->subprog_info[i].start <= off)
> >                         continue;
> > 
> > Earlier subprograms are not changed because their start values
> > are not moved. But, adjust_poke_desc() does the offset + delta
> > indiscriminately. The result is poke descriptors are potentially
> > corrupted.
> > 
> > Then in jit_subprogs() we only populate the poke_tab[]
> > when the above insn_idx is less than the next subprogram start. From
> > above we corrupted our insn_idx so we might incorrectly assume a
> > poke descriptor is not used in a subprogram omitting it from the
> > subprogram. And finally when the jit runs it does the deref of poke_tab
> > when emitting the instruction and crashes with below. Because earlier
> > step omitted the poke descriptor.
> > 
> > The fix is straight forward with above context. Simply move same logic
> > from adjust_subprog_starts() into adjust_poke_descs() and only adjust
> > insn_idx when needed.
> > 
> > [   88.487438] BUG: KASAN: null-ptr-deref in do_jit+0x184a/0x3290
> > [   88.487455] Write of size 8 at addr 0000000000000008 by task test_progs/5295
> > [   88.487490] Call Trace:
> > [   88.487498]  dump_stack+0x93/0xc2
> > [   88.487515]  kasan_report.cold+0x5f/0xd8
> > [   88.487530]  ? do_jit+0x184a/0x3290
> > [   88.487542]  do_jit+0x184a/0x3290
> >  ...
> > [   88.487709]  bpf_int_jit_compile+0x248/0x810
> >  ...
> > [   88.487765]  bpf_check+0x3718/0x5140
> >  ...
> > [   88.487920]  bpf_prog_load+0xa22/0xf10
> > 
> > CC: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Fixes: a748c6975dea3 ("bpf: propagate poke descriptors to subprograms")
> > Reviewed-by: Daniel Borkmann <daniel@iogearbox.net>
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  kernel/bpf/verifier.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 94ba5163d4c5..ac8373da849c 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -11408,7 +11408,7 @@ static void adjust_subprog_starts(struct bpf_verifier_env *env, u32 off, u32 len
> >  	}
> >  }
> >  
> > -static void adjust_poke_descs(struct bpf_prog *prog, u32 len)
> > +static void adjust_poke_descs(struct bpf_prog *prog, u32 off, u32 len)
> >  {
> >  	struct bpf_jit_poke_descriptor *tab = prog->aux->poke_tab;
> >  	int i, sz = prog->aux->size_poke_tab;
> > @@ -11416,6 +11416,8 @@ static void adjust_poke_descs(struct bpf_prog *prog, u32 len)
> >  
> >  	for (i = 0; i < sz; i++) {
> >  		desc = &tab[i];
> 
> Can we have a comment below that would say something like:
> "don't update taicall's insn idx if the patching is being done on higher
> insns" ?
> 
> What I'm saying is that after a long break from that code I find 'off' as
> a confusing name. It's the offset within the flat-structured bpf prog (so
> the prog that is not yet sliced onto subprogs). Maybe we could find a
> better name for that, like "curr_insn_idx". I'm not sure what's your view
> on that.
> 
> OTOH I'm aware that whole content of bpf_patch_insn_data operates on
> 'off'.

I'm not necessarily opposed to a comment there but we don't have a comment
above for the same operation on start offsets. I'll think about it for
a follow up patch assuming no one shouts.

> 
> Generally sorry that I missed that, it didn't come to my mind to mix in
> other helpers that include patching.


Thanks for testing.

> 
> Anyway:
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Tested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> > +		if (desc->insn_idx <= off)
> > +			continue;
> >  		desc->insn_idx += len - 1;
> >  	}
> >  }
> > @@ -11436,7 +11438,7 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
> >  	if (adjust_insn_aux_data(env, new_prog, off, len))
> >  		return NULL;
> >  	adjust_subprog_starts(env, off, len);
> > -	adjust_poke_descs(new_prog, len);
> > +	adjust_poke_descs(new_prog, off, len);
> >  	return new_prog;
> >  }
> >  
> > 
> > 
