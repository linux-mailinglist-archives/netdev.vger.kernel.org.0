Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E12CFE2DF
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 17:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfKOQd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 11:33:56 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38036 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727540AbfKOQd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 11:33:56 -0500
Received: by mail-pl1-f193.google.com with SMTP id q18so1303720pls.5;
        Fri, 15 Nov 2019 08:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PX2qVREAhHbZq/IjrX600hVEOeGs6JZyVyVItE1rm9U=;
        b=IAPKvUYk9zHnocd+O8N7i8yksGAOJm9YpTsTyAA+bT3rzE0Q3q5JB7FAcRerDN8oMa
         cMUDIgZwFklbPWb1x3U8Atx4QM9mGtZi/bUWf+NWrroN9jS/43KGUZx+k1oPfbqKvbF4
         MtkyMFqFIRlA8GzWHEnkHvcNz1L5/rO262qoxHoM0hLwrqgLqpUgyAOso2gd2Ka/HS9v
         hCsT5c88ZDDVeHRKKpYZBgemGBdrvKHIZjl5z/TxSva/sKd814jxL/en/0V2TBUyUKtO
         ZC1uoqP9rPD+9+7rNdr3DvSXX4iys37IsSa+/V+zE99esp4FkPAe94YgSwTeg3uYD4E/
         go0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PX2qVREAhHbZq/IjrX600hVEOeGs6JZyVyVItE1rm9U=;
        b=FgROFbM0M06X8nFgjuxkackpKXSzJra+iUYlZmRYVld4J+0S9l1lxIVKKQ/hTn2Hjn
         078Xv+sxeUgQhCany6BoZUd7IZufJFX7T5I43Qc0e9/eCOVXlbhVMHyl6zHvA9gMrrWh
         5q/sjrk8hT75A1uyCOgMMfMtKQKlmU3OEeF5nBql04tV3XDvIpXNOItqwoPIbGCq1O+K
         sTpKQIYC897VK+Zo8cIkSHN8kF7f3zlek2IoWwEMymGY2unfGxiMvjpNsdXw82YF7BZs
         4WgT0NaT8yW3ak12wMa31AQDH1EcRdWuW9O1Iwl6gZjl4KxzAul6XnFNhgcLBYbETg49
         SHfw==
X-Gm-Message-State: APjAAAU+pU5xLPfnTaX8Ha2Z5Q1Kj5mGC5E4tQh+4SaSYAsYamD91Qis
        pa74e2lxH0JTS/KdnC+jX/4=
X-Google-Smtp-Source: APXvYqwWWiBCqhV/t8OT/FL7ZmSm1LHAw8MZNIfM/Avn0PnBglLdVOKwE7M00grXoTnWIdOK/pUHbg==
X-Received: by 2002:a17:90a:8a11:: with SMTP id w17mr20616502pjn.136.1573835634978;
        Fri, 15 Nov 2019 08:33:54 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::8ac1])
        by smtp.gmail.com with ESMTPSA id o15sm9943127pjs.24.2019.11.15.08.33.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 08:33:54 -0800 (PST)
Date:   Fri, 15 Nov 2019 08:33:52 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH rfc bpf-next 8/8] bpf: constant map key tracking for prog
 array pokes
Message-ID: <20191115163351.nm4hpofdcthkgmmp@ast-mbp.dhcp.thefacebook.com>
References: <cover.1573779287.git.daniel@iogearbox.net>
 <fa3c2f6e2f4fbe45200d54a3c6d4c65c4f84f790.1573779287.git.daniel@iogearbox.net>
 <20191115042939.ckt4fqvtfdi344y2@ast-mbp.dhcp.thefacebook.com>
 <20191115071358.GA3957@pc-9.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115071358.GA3957@pc-9.home>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 08:13:58AM +0100, Daniel Borkmann wrote:
> On Thu, Nov 14, 2019 at 08:29:41PM -0800, Alexei Starovoitov wrote:
> > On Fri, Nov 15, 2019 at 02:04:02AM +0100, Daniel Borkmann wrote:
> > > Add tracking of constant keys into tail call maps. The signature of
> > > bpf_tail_call_proto is that arg1 is ctx, arg2 map pointer and arg3
> > > is a index key. The direct call approach for tail calls can be enabled
> > > if the verifier asserted that for all branches leading to the tail call
> > > helper invocation, the map pointer and index key were both constant
> > > and the same. Tracking of map pointers we already do from prior work
> > > via c93552c443eb ("bpf: properly enforce index mask to prevent out-of-bounds
> > > speculation") and 09772d92cd5a ("bpf: avoid retpoline for lookup/update/
> > > delete calls on maps"). Given the tail call map index key is not on
> > > stack but directly in the register, we can add similar tracking approach
> > > and later in fixup_bpf_calls() add a poke descriptor to the progs poke_tab
> > > with the relevant information for the JITing phase. We internally reuse
> > > insn->imm for the rewritten BPF_JMP | BPF_TAIL_CALL instruction in order
> > > to point into the prog's poke_tab and keep insn->imm == 0 as indicator
> > > that current indirect tail call emission must be used.
> > > 
> > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > > ---
> > >  include/linux/bpf_verifier.h |  1 +
> > >  kernel/bpf/verifier.c        | 98 ++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 99 insertions(+)
> > > 
> > > diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> > > index cdd08bf0ec06..f494f0c9ac13 100644
> > > --- a/include/linux/bpf_verifier.h
> > > +++ b/include/linux/bpf_verifier.h
> > > @@ -301,6 +301,7 @@ struct bpf_insn_aux_data {
> > >  			u32 map_off;		/* offset from value base address */
> > >  		};
> > >  	};
> > > +	u64 key_state; /* constant key tracking for maps */
> > 
> > may be map_key_state ?
> > key_state is a bit ambiguous in the bpf_insn_aux_data.
> 
> Could be, alternatively could also be idx_state or map_idx_state since
> it's really just for u32 type key indices.
> 
> > > +static int
> > > +record_func_key(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
> > > +		int func_id, int insn_idx)
> > > +{
> > > +	struct bpf_insn_aux_data *aux = &env->insn_aux_data[insn_idx];
> > > +	struct bpf_reg_state *regs = cur_regs(env), *reg;
> > > +	struct tnum range = tnum_range(0, U32_MAX);
> > > +	struct bpf_map *map = meta->map_ptr;
> > > +	u64 val;
> > > +
> > > +	if (func_id != BPF_FUNC_tail_call)
> > > +		return 0;
> > > +	if (!map || map->map_type != BPF_MAP_TYPE_PROG_ARRAY) {
> > > +		verbose(env, "kernel subsystem misconfigured verifier\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	reg = &regs[BPF_REG_3];
> > > +	if (!register_is_const(reg) || !tnum_in(range, reg->var_off)) {
> > > +		bpf_map_key_store(aux, BPF_MAP_KEY_POISON);
> > > +		return 0;
> > > +	}
> > > +
> > > +	val = reg->var_off.value;
> > > +	if (bpf_map_key_unseen(aux))
> > > +		bpf_map_key_store(aux, val);
> > > +	else if (bpf_map_key_immediate(aux) != val)
> > > +		bpf_map_key_store(aux, BPF_MAP_KEY_POISON);
> > > +	return 0;
> > > +}
> > 
> > I think this analysis is very useful in other cases as well. Could you
> > generalize it for array map lookups ? The key used in bpf_map_lookup_elem() for
> > arrays is often constant. In such cases we can optimize array_map_gen_lookup()
> > into absolute pointer. It will be possible to do
> > if (idx < max_entries) ptr += idx * elem_size;
> > during verification instead of runtime and the whole
> > bpf_map_lookup_elem(map, &key); will become single instruction that
> > assigns &array[idx] into R0.
> 
> Was thinking exactly the same. ;-) I started coding this yesterday night [0],
> but then had the (in hinsight obvious) realization that as-is the key_state
> holds the address but not the index for plain array map lookup. Hence I'd need
> to go a step further there to look at the const stack content. Will proceed on
> this as a separate set on top.
> 
>   [0] https://git.kernel.org/pub/scm/linux/kernel/git/dborkman/bpf.git/commit/?h=pr/bpf-tail-call-rebased2&id=b86b7eae4646d8233e3e9058e68fef27536bf0c4

yeah. good point. For map_lookup it's obvious that the verifier needs to
compare both map ptr and *key, but that is the case for bpf_tail_call too, no?
It seems tracking 'key_state' only is not enough. Consider:
if (..)
  map = mapA;
else
  map = mapB;
bpf_tail_call(ctx, map, 1);

May be to generalize the logic the verifier should remember bpf_reg_state
instead of specific part of it like u32 ? The verifier keeps
insn_aux_data[insn_idx].ptr_type; to prevent incorrect ctx access. That can
also be generalized? Probably later, but conceptually it's the same category of
tracking that the verifier needs to do. For bpf_map_lookup and bpf_tail_call
callsite it can remember bpf_reg_state of r1,r2,r3. The bpf_reg_state should be
saved in insn_aux_data the first time the verifier goes through the callsite than 
everytime the verifier goes through the callsite again additional per-helper
logic is invoked. Like for bpf_tail_call it will check:
if (tnum_is_const(insn_aux_data[callsite]->r3_reg_state->var_off))
  // good. may be can optimize later.
and will use insn_aux_data[callsite]->r2_reg_state->map_ptr plus
insn_aux_data[callsite]->r3_reg_state->var_off to compute bpf_prog's jited address
inside that prog_array.
Similarly for bpf_map_lookup... r1_reg_state->map_ptr is the same map
for saved insn_aux_data->r1_reg_state and for current->r1.
The r2_reg_state should be PTR_TO_STACK and that stack value should be u32 const.
Should be a bit more generic and extensible... instead of specific 'key_state' ?

