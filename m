Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94402681E23
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 23:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbjA3Wbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 17:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjA3Wbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 17:31:46 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780E12CFD9;
        Mon, 30 Jan 2023 14:31:45 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id z1so5919291pfg.12;
        Mon, 30 Jan 2023 14:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=65f4t+iaeVyCtrD2vqOKBx8xiVW8biy9pLalqhDoA/4=;
        b=nbsrGAYEHFjb454W4qvS/j557mBHJaMrJp6fwasY9MkYCAP0ZfuQtvxHqhIEDKzFKW
         xQAVhUDmYvEjxIzw4H4w81KU/kxSoT2uklashsTTLNpunYwBi08+GmecBZejXtYNIFsF
         bGuwPThPyaHvz5j4a9lSJ69uilSVC6btZTooLRKHX/r+6VaWdv0ChFeHi3zNF2vdxwKU
         jblY2LFl19YgzUTeul8yRovE7C7QtyMiZVfmI8Gef3zaS7EodL1UI4zRad9nuBzUXRkV
         zLIKA9Jh2N3KmZkEQK66/+AKh+LpKNm5WNmpUHgixzmzOtFW3Xza9tiCfXVZYFBWKeIR
         n9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=65f4t+iaeVyCtrD2vqOKBx8xiVW8biy9pLalqhDoA/4=;
        b=oi1/umP7BA7keCvfx1N90De5vNcLCHMK3J2PGND3zSpt5JxkzkX3GeXEOhv9Cf4i6r
         0oSydkgrGwMWvTrQ2C0t5AeqXVYtnga5FiyMt/Ssu9ICsXuvCJJu+i4od6o3b/Gd0GIF
         0Gdp3kywmf1H/q6bk3XY5LBDfkI5D6jLMWhtSpghr2gn/FXRsfhcnrmDr2ZKiAtp4pC7
         Bfth6zCEhzDlw27apSo6gmpS6mr44vOSaBRjAdOJPmx94HZcc1I8KqMbEWQarXBEVnxO
         x3I25GPr2udYrAVKeO5PIQEz6QDxmIBjPEeWQsBUaDoH9kdN2jZMiE9hs7gnb33wKkiD
         bPbw==
X-Gm-Message-State: AO0yUKUNX+6lGAEhKb81IjTKUQuds9+chAfb+Bywba9m9a0GM1KBqImJ
        O1kwW2T5UPv6NFVZ4xTUWc4=
X-Google-Smtp-Source: AK7set9FJ16VRm18dsZU4KAF9xSAcOcODC/NU0FHwv5IA+cs3ShSK6o00/fx9/YZvlALiuTCCc42/g==
X-Received: by 2002:a05:6a00:8cd:b0:591:3d20:3827 with SMTP id s13-20020a056a0008cd00b005913d203827mr22130547pfu.21.1675117904752;
        Mon, 30 Jan 2023 14:31:44 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:a52d])
        by smtp.gmail.com with ESMTPSA id 26-20020aa7915a000000b0058d99337381sm8118135pfi.172.2023.01.30.14.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 14:31:44 -0800 (PST)
Date:   Mon, 30 Jan 2023 14:31:41 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Joanne Koong <joannelkoong@gmail.com>, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@kernel.org, ast@kernel.org,
        netdev@vger.kernel.org, memxor@gmail.com, kernel-team@fb.com,
        bpf@vger.kernel.org
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
Message-ID: <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com>
 <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 02:04:08PM -0800, Martin KaFai Lau wrote:
> On 1/27/23 11:17 AM, Joanne Koong wrote:
> > @@ -8243,6 +8316,28 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
> >   		mark_reg_known_zero(env, regs, BPF_REG_0);
> >   		regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
> >   		regs[BPF_REG_0].mem_size = meta.mem_size;
> > +		if (func_id == BPF_FUNC_dynptr_data &&
> > +		    dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> > +			bool seen_direct_write = env->seen_direct_write;
> > +
> > +			regs[BPF_REG_0].type |= DYNPTR_TYPE_SKB;
> > +			if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE))
> > +				regs[BPF_REG_0].type |= MEM_RDONLY;
> > +			else
> > +				/*
> > +				 * Calling may_access_direct_pkt_data() will set
> > +				 * env->seen_direct_write to true if the skb is
> > +				 * writable. As an optimization, we can ignore
> > +				 * setting env->seen_direct_write.
> > +				 *
> > +				 * env->seen_direct_write is used by skb
> > +				 * programs to determine whether the skb's page
> > +				 * buffers should be cloned. Since data slice
> > +				 * writes would only be to the head, we can skip
> > +				 * this.
> > +				 */
> > +				env->seen_direct_write = seen_direct_write;
> > +		}
> 
> [ ... ]
> 
> > @@ -9263,17 +9361,26 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
> >   				return ret;
> >   			break;
> >   		case KF_ARG_PTR_TO_DYNPTR:
> > +		{
> > +			enum bpf_arg_type dynptr_arg_type = ARG_PTR_TO_DYNPTR;
> > +
> >   			if (reg->type != PTR_TO_STACK &&
> >   			    reg->type != CONST_PTR_TO_DYNPTR) {
> >   				verbose(env, "arg#%d expected pointer to stack or dynptr_ptr\n", i);
> >   				return -EINVAL;
> >   			}
> > -			ret = process_dynptr_func(env, regno, insn_idx,
> > -						  ARG_PTR_TO_DYNPTR | MEM_RDONLY);
> > +			if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb])
> > +				dynptr_arg_type |= MEM_UNINIT | DYNPTR_TYPE_SKB;
> > +			else
> > +				dynptr_arg_type |= MEM_RDONLY;
> > +
> > +			ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type,
> > +						  meta->func_id);
> >   			if (ret < 0)
> >   				return ret;
> >   			break;
> > +		}
> >   		case KF_ARG_PTR_TO_LIST_HEAD:
> >   			if (reg->type != PTR_TO_MAP_VALUE &&
> >   			    reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
> > @@ -15857,6 +15964,14 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >   		   desc->func_id == special_kfunc_list[KF_bpf_rdonly_cast]) {
> >   		insn_buf[0] = BPF_MOV64_REG(BPF_REG_0, BPF_REG_1);
> >   		*cnt = 1;
> > +	} else if (desc->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb]) {
> > +		bool is_rdonly = !may_access_direct_pkt_data(env, NULL, BPF_WRITE);
> 
> Does it need to restore the env->seen_direct_write here also?
> 
> It seems this 'seen_direct_write' saving/restoring is needed now because
> 'may_access_direct_pkt_data(BPF_WRITE)' is not only called when it is
> actually writing the packet. Some refactoring can help to avoid issue like
> this.
> 
> While at 'seen_direct_write', Alexei has also pointed out that the verifier
> needs to track whether the (packet) 'slice' returned by bpf_dynptr_data()
> has been written. It should be tracked in 'seen_direct_write'. Take a look
> at how reg_is_pkt_pointer() and may_access_direct_pkt_data() are done in
> check_mem_access(). iirc, this reg_is_pkt_pointer() part got loss somewhere
> in v5 (or v4?) when bpf_dynptr_data() was changed to return register typed
> PTR_TO_MEM instead of PTR_TO_PACKET.

btw tc progs are using gen_prologue() approach because data/data_end are not kfuncs
(nothing is being called by the bpf prog).
In this case we don't need to repeat this approach. If so we don't need to
set seen_direct_write.
Instead bpf_dynptr_data() can call bpf_skb_pull_data() directly.
And technically we don't need to limit it to skb head. It can handle any off/len.
It will work for skb, but there is no equivalent for xdp_pull_data().
I don't think we can implement xdp_pull_data in all drivers.
That's massive amount of work, but we need to be consistent if we want
dynptr to wrap both skb and xdp.
We can say dynptr_data is for head only, but we've seen bugs where people
had to switch from data/data_end to load_bytes.

Also bpf_skb_pull_data is quite heavy. For progs that only want to parse
the packet calling that in bpf_dynptr_data is a heavy hammer.

It feels that we need to go back to skb_header_pointer-like discussion.
Something like:
bpf_dynptr_slice(const struct bpf_dynptr *ptr, u32 offset, u32 len, void *buffer)
Whether buffer is a part of dynptr or program provided is tbd.
