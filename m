Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94252CB405
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 05:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgLBErW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 23:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgLBErW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 23:47:22 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB0CC0613CF;
        Tue,  1 Dec 2020 20:46:41 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id t37so326251pga.7;
        Tue, 01 Dec 2020 20:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=o3CORTg+9lKTe8fpIQY2Q7dwP00QXkDgkfzcppu9NAk=;
        b=cAgDXszgF0oBtbfKVgDbWSQmT+5AOLkB73lU4O2Mu1un1Dpmu285luzhxnUbbhhVHn
         /UNAd1IL01xBEVB5ewfEIcjLve847FyG1DCGCbbhVmHRC5brDqA2dyu7DhvB7Tklhc34
         qJ1CueS1sFZO6Ei9DyoxboYICsQtWJt1ntOOTDYBvVVIqjprooIURzRokPGg8juk22ZF
         L5i0ysnXIzLvzQf+6j3tHjNm3WrfAvMqNc7MXgn6/ymR2OTrHL8jfMjTRmQmKqvI9V1W
         lzO/UEOgKMwEcTPGcnf2hT4+FJvuCF9ZQrywSCj1qK6PsSU8EglDZLJkg7OkxDzHLvtX
         wSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=o3CORTg+9lKTe8fpIQY2Q7dwP00QXkDgkfzcppu9NAk=;
        b=klj+9BjwO78AcXpUC1gkDXnDjKXBxddyT32ZT9JInVWhAVjMsyO6oPa4HA1MRTNdGd
         L7AbU3HS6BVnWQfItILbAQuuRwTtacSaL8C2sFUziYa45ArrzNw+VeCw6qykj8lV0v98
         NLe/YFGYlwb5bTn1c6mLa/iuAr89igerRKrjFvP8ZblmqP2VSc8XRmpI5JLV5YLe8SNc
         d1l3PX3ma8OVypBC6bSyO1EoyR8MqNIj5tZDvZTodc3Jkjq9RtChKjI2tauikmKhgeIq
         KYIYxzSN9jiPxiIsv7wCz3AHdQSViid6drVfu/HIx9I6UjpMHR9ET24X8b2yRGSgOre9
         cjAQ==
X-Gm-Message-State: AOAM530QD2GiVbehinIznZZnPyWboy27EyYYoTtVgRkqRBtpTgVXNQ+O
        8E22KapDJbXfDOMBJXk5EkM=
X-Google-Smtp-Source: ABdhPJw0KNsRcvB82oD30qFCbJ0XZt51AL58/6Pop7B/VSyZIJ5QWKPBixlU/Ds/vB/fXW+5Iq4inw==
X-Received: by 2002:a05:6a00:16c5:b029:19b:696:28a0 with SMTP id l5-20020a056a0016c5b029019b069628a0mr895102pfc.9.1606884401534;
        Tue, 01 Dec 2020 20:46:41 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:ab4a])
        by smtp.gmail.com with ESMTPSA id a11sm562802pfc.31.2020.12.01.20.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 20:46:40 -0800 (PST)
Date:   Tue, 1 Dec 2020 20:46:38 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, hawk@kernel.org, kuba@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com
Subject: Re: [PATCH bpf-next] bpf, xdp: add bpf_redirect{,_map}() leaf node
 detection and optimization
Message-ID: <20201202044638.zqqlgabmx2xjsunf@ast-mbp>
References: <20201201172345.264053-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201201172345.264053-1-bjorn.topel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 06:23:45PM +0100, Björn Töpel wrote:
> +static void check_redirect_opt(struct bpf_verifier_env *env, int func_id, int insn_idx)
> +{
> +	struct bpf_insn *insns = env->prog->insnsi;
> +	int insn_cnt = env->prog->len;
> +	struct bpf_insn *insn;
> +	bool is_leaf = false;
> +
> +	if (!(func_id == BPF_FUNC_redirect || func_id == BPF_FUNC_redirect_map))
> +		return;
> +
> +	/* Naive peephole leaf node checking */
> +	insn_idx++;
> +	if (insn_idx >= insn_cnt)
> +		return;
> +
> +	insn = &insns[insn_idx];
> +	switch (insn->code) {
> +	/* Is the instruction following the call, an exit? */
> +	case BPF_JMP | BPF_EXIT:
> +		is_leaf = true;
> +		break;
> +	/* Follow the true branch of "if return value (r/w0) is not
> +	 * zero", and look for exit.
> +	 */
> +	case BPF_JMP | BPF_JSGT | BPF_K:
> +	case BPF_JMP32 | BPF_JSGT | BPF_K:
> +	case BPF_JMP | BPF_JGT | BPF_K:
> +	case BPF_JMP32 | BPF_JGT | BPF_K:
> +	case BPF_JMP | BPF_JNE | BPF_K:
> +	case BPF_JMP32 | BPF_JNE | BPF_K:
> +		if (insn->dst_reg == BPF_REG_0 && insn->imm == 0) {
> +			insn_idx += insn->off + 1;
> +			if (insn_idx >= insn_cnt)
> +				break;
> +
> +			insn = &insns[insn_idx];
> +			is_leaf = insn->code == (BPF_JMP | BPF_EXIT);
> +		}
> +		break;
> +	default:
> +		break;
> +	}

Sorry I don't like this check at all. It's too fragile.
It will work for one hard coded program.
It may work for something more real, but will break with minimal
changes to the prog or llvm changes.
How are we going to explain that fragility to users?

> +static u64 __bpf_xdp_redirect_map_opt(struct bpf_map *map, u32 index, u64 flags,
> +				      struct bpf_redirect_info *ri)
> +{
> +	const struct bpf_prog *xdp_prog;
> +	struct net_device *dev;
> +	struct xdp_buff *xdp;
> +	void *val;
> +	int err;
> +
> +	xdp_prog = ri->xdp_prog_redirect_opt;
> +	xdp = ri->xdp;
> +	dev = xdp->rxq->dev;
> +
> +	ri->xdp_prog_redirect_opt = NULL;
> +
> +	switch (map->map_type) {
> +	case BPF_MAP_TYPE_DEVMAP: {
> +		val = __dev_map_lookup_elem(map, index);
> +		if (unlikely(!val))
> +			return flags;
> +		err = dev_map_enqueue(val, xdp, dev);
> +		break;
> +	}
> +	case BPF_MAP_TYPE_DEVMAP_HASH: {
> +		val = __dev_map_hash_lookup_elem(map, index);
> +		if (unlikely(!val))
> +			return flags;
> +		err = dev_map_enqueue(val, xdp, dev);
> +		break;
> +	}
> +	case BPF_MAP_TYPE_CPUMAP: {
> +		val = __cpu_map_lookup_elem(map, index);
> +		if (unlikely(!val))
> +			return flags;
> +		err = cpu_map_enqueue(val, xdp, dev);
> +		break;
> +	}
> +	case BPF_MAP_TYPE_XSKMAP: {
> +		val = __xsk_map_lookup_elem(map, index);
> +		if (unlikely(!val))
> +			return flags;
> +		err = __xsk_map_redirect(val, xdp);
> +		break;

I haven't looked through all possible paths, but it feels very dangerous.
The stack growth is big. Calling xsk_rcv from preempt_disabled
and recursively calling into another bpf prog?
That violates all stack checks we have in the verifier.

I see plenty of cons and not a single pro in this patch.
5% improvement for micro benchmark? That's hardly a justification.
