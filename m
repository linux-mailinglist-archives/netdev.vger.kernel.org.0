Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF35FD3A8
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 05:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKOE3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 23:29:46 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44302 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfKOE3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 23:29:46 -0500
Received: by mail-pg1-f195.google.com with SMTP id f19so5166385pgk.11;
        Thu, 14 Nov 2019 20:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yWWTL27YpOR9rROnC4ueooFH4+fm9f8C4aV1mOV1Cso=;
        b=gOA89t2ACr6O7LIqqlZld6zX81E/PWI2W30YaxOdLU7z3nOkhRpyb+q/NTFznT/GvW
         1Sk0VignDLDXQkfRUNeEWIZn2zI0U3Cyd3bbfTI54nkSKoXRx3tnTkMH5mfJrq9zlSYj
         O5T2xF6wtdPPL6ufVKbXLeTxiwKu3EyV5HsSe44C2ekd37uJPD2GpOtHFfrtXzQUgEiZ
         C4me/Kfbn4Os4BRBUby9cRMx7ek3J/+bfSlLW358Hk2m749tD90HoaUto/riZtXH8ryA
         e/D5eXgdLOCP6F5qTT4YEEEdTlj5Yhlxu5ZLQv/ZvEw547dQTFEI23W1GXOGIoU/v1vr
         Gt+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yWWTL27YpOR9rROnC4ueooFH4+fm9f8C4aV1mOV1Cso=;
        b=bQBX8KWAdC0w7xNT0+JJ5y8NfZyzaudCj1o/FPvuZPirNG+R5YctHU7+nAMWKo6zqN
         D79ezNsZH8/Gmhp1ox6OHpWb0zZiZdQe9VS7j/b8SAEXipWV64GT19J/b3e+ZdmIF84j
         /VjTAUUXziumEL5KcyPP1FrWh5yMfzTYfZLm0By6bKAZxqRdzoBvor+iOl0zoP81+uNi
         mXLToXAFrs47aOIbgtB3a04PiHTNBaK5yKFupOITOOoriu66uYZWTIFb8zipoOP+gEb8
         SvApVUnItbxzg+MNjEp7OxErf16SUppBYHUjcMyzf/eEeGoSmOZkOznp2gdq0BJy8XVi
         Dy6w==
X-Gm-Message-State: APjAAAV4BjyX0DeMg7eZhsav8m3dvhT/uwUn2k03YEF/ggGRUkZHaNAb
        xfByx+ChKebuZ7MTE6M50LRNcuv8
X-Google-Smtp-Source: APXvYqxeedN8VNsXvEJGzcmNCtvQLD00o8dv+9JAX5EhrSkNpWb4Kha0zRaDdiKsxfi4Pz1UMf46Gg==
X-Received: by 2002:a17:90a:989:: with SMTP id 9mr17278212pjo.35.1573792184064;
        Thu, 14 Nov 2019 20:29:44 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::a328])
        by smtp.gmail.com with ESMTPSA id y6sm6519612pfm.12.2019.11.14.20.29.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 20:29:43 -0800 (PST)
Date:   Thu, 14 Nov 2019 20:29:41 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH rfc bpf-next 8/8] bpf: constant map key tracking for prog
 array pokes
Message-ID: <20191115042939.ckt4fqvtfdi344y2@ast-mbp.dhcp.thefacebook.com>
References: <cover.1573779287.git.daniel@iogearbox.net>
 <fa3c2f6e2f4fbe45200d54a3c6d4c65c4f84f790.1573779287.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa3c2f6e2f4fbe45200d54a3c6d4c65c4f84f790.1573779287.git.daniel@iogearbox.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 02:04:02AM +0100, Daniel Borkmann wrote:
> Add tracking of constant keys into tail call maps. The signature of
> bpf_tail_call_proto is that arg1 is ctx, arg2 map pointer and arg3
> is a index key. The direct call approach for tail calls can be enabled
> if the verifier asserted that for all branches leading to the tail call
> helper invocation, the map pointer and index key were both constant
> and the same. Tracking of map pointers we already do from prior work
> via c93552c443eb ("bpf: properly enforce index mask to prevent out-of-bounds
> speculation") and 09772d92cd5a ("bpf: avoid retpoline for lookup/update/
> delete calls on maps"). Given the tail call map index key is not on
> stack but directly in the register, we can add similar tracking approach
> and later in fixup_bpf_calls() add a poke descriptor to the progs poke_tab
> with the relevant information for the JITing phase. We internally reuse
> insn->imm for the rewritten BPF_JMP | BPF_TAIL_CALL instruction in order
> to point into the prog's poke_tab and keep insn->imm == 0 as indicator
> that current indirect tail call emission must be used.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  include/linux/bpf_verifier.h |  1 +
>  kernel/bpf/verifier.c        | 98 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 99 insertions(+)
> 
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index cdd08bf0ec06..f494f0c9ac13 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -301,6 +301,7 @@ struct bpf_insn_aux_data {
>  			u32 map_off;		/* offset from value base address */
>  		};
>  	};
> +	u64 key_state; /* constant key tracking for maps */

may be map_key_state ?
key_state is a bit ambiguous in the bpf_insn_aux_data.

> +static int
> +record_func_key(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
> +		int func_id, int insn_idx)
> +{
> +	struct bpf_insn_aux_data *aux = &env->insn_aux_data[insn_idx];
> +	struct bpf_reg_state *regs = cur_regs(env), *reg;
> +	struct tnum range = tnum_range(0, U32_MAX);
> +	struct bpf_map *map = meta->map_ptr;
> +	u64 val;
> +
> +	if (func_id != BPF_FUNC_tail_call)
> +		return 0;
> +	if (!map || map->map_type != BPF_MAP_TYPE_PROG_ARRAY) {
> +		verbose(env, "kernel subsystem misconfigured verifier\n");
> +		return -EINVAL;
> +	}
> +
> +	reg = &regs[BPF_REG_3];
> +	if (!register_is_const(reg) || !tnum_in(range, reg->var_off)) {
> +		bpf_map_key_store(aux, BPF_MAP_KEY_POISON);
> +		return 0;
> +	}
> +
> +	val = reg->var_off.value;
> +	if (bpf_map_key_unseen(aux))
> +		bpf_map_key_store(aux, val);
> +	else if (bpf_map_key_immediate(aux) != val)
> +		bpf_map_key_store(aux, BPF_MAP_KEY_POISON);
> +	return 0;
> +}

I think this analysis is very useful in other cases as well. Could you
generalize it for array map lookups ? The key used in bpf_map_lookup_elem() for
arrays is often constant. In such cases we can optimize array_map_gen_lookup()
into absolute pointer. It will be possible to do
if (idx < max_entries) ptr += idx * elem_size;
during verification instead of runtime and the whole
bpf_map_lookup_elem(map, &key); will become single instruction that
assigns &array[idx] into R0.

