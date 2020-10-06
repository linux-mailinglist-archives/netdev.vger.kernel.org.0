Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376C228515E
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 20:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgJFSIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 14:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgJFSIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 14:08:43 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9AAC061755;
        Tue,  6 Oct 2020 11:08:43 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y20so1599452pll.12;
        Tue, 06 Oct 2020 11:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UfWgDf/TSQvHhTZWk4ujqHBFOYkMgtpFB8dY13v6WJ0=;
        b=gRZyubkE3xz+BJTJuI0WZdZLh32LUpx+i5MaEjMWWJQYCA4z7oIyJiYAjPuAG6o150
         WveokJ3fK1caoL4x+xEp+Xlpfq9A9YAi+JuHFgg9YkD1xMYyEvolhjFPbLbxEA4vK0/y
         920N2Ub0QbOnY1hRWg/E+Ksv6yQ0FfmPsxvbiW1dK2JoGMGKKF2yIiMsq5DLutYM/J1H
         jrOmUozgF2mkYvJj2w53p+KptKNqmDE8ZcyZlFBlYxoN0vZZBhhIZ6grOOPC9k3tawrE
         8w8bzPIGvqU2DMAJcz8F9+2NPRjOLwg1VWpNohgVjhAmJvt/WR2/usUGF1lknX4YfmSt
         Ckvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UfWgDf/TSQvHhTZWk4ujqHBFOYkMgtpFB8dY13v6WJ0=;
        b=WT2lob2dBwYBYUAqcL1kC9IoaQHQmM2o5vtqGKR8Yv7ljBGYC7iC9jMmnPXHPLsNVq
         xJdlP/wFaQMHHxmpz/L3ZgXFg1LLx5aSRn9PI0CPHgQVOLS5XPorLks5djnD40hwOolI
         h9hpjYKOsnvokNJO5Wdzj35gvoR21xtowZCD1iXXo7jt8uCftW7ir/48cbiTNJzq89nm
         +j2VQWYL+n9frIKNjh0bmdexQDniVEidbXInVxB7HrllPhiYgNeo1waSiatbfs+gNnin
         bVtXkTXrlpfFWYBe1KYnOdEXI1dcWJCmVK72L2gyZT1Nsdz+p1nYpwz1QZ0sLNJruS3y
         mVMQ==
X-Gm-Message-State: AOAM531alYMitNMBd+vwUgrIDBI0VjZHMXuvmDszjGF+5i0qEqWTVmQq
        KJeZsh+x25m9SH8CFEs/mAfEZ7oodI4=
X-Google-Smtp-Source: ABdhPJyEjWwt81Osm8f5gqzSwY8rdn0CTsXLz431DeoNaFFlvjsc2MSJfxFBVZiuuubKcv14WPLO6w==
X-Received: by 2002:a17:90a:d311:: with SMTP id p17mr5327648pju.135.1602007723293;
        Tue, 06 Oct 2020 11:08:43 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:7333])
        by smtp.gmail.com with ESMTPSA id o20sm4011109pgh.63.2020.10.06.11.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 11:08:42 -0700 (PDT)
Date:   Tue, 6 Oct 2020 11:08:39 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Luka Perkov <luka.perkov@sartura.hr>,
        Tony Ambardar <tony.ambardar@gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: support safe subset of load/store
 instruction resizing with CO-RE
Message-ID: <20201006180839.lvoigzpmr32rrroj@ast-mbp>
References: <20201002010633.3706122-1-andriin@fb.com>
 <20201002010633.3706122-2-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002010633.3706122-2-andriin@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01, 2020 at 06:06:31PM -0700, Andrii Nakryiko wrote:
> Add support for patching instructions of the following form:
>   - rX = *(T *)(rY + <off>);
>   - *(T *)(rX + <off>) = rY;
>   - *(T *)(rX + <off>) = <imm>, where T is one of {u8, u16, u32, u64}.

llvm doesn't generate ST instruction. It never did.
STX is generated, but can it actually be used with relocations?
Looking at the test in patch 3... it's testing LDX only.
ST/STX suppose to work by analogy, but would be good to have a test.
At least of STX.

> +static int insn_mem_sz_to_bytes(struct bpf_insn *insn)
> +{
> +	switch (BPF_SIZE(insn->code)) {
> +	case BPF_DW: return 8;
> +	case BPF_W: return 4;
> +	case BPF_H: return 2;
> +	case BPF_B: return 1;
> +	default: return -1;
> +	}
> +}
> +
> +static int insn_bytes_to_mem_sz(__u32 sz)
> +{
> +	switch (sz) {
> +	case 8: return BPF_DW;
> +	case 4: return BPF_W;
> +	case 2: return BPF_H;
> +	case 1: return BPF_B;
> +	default: return -1;
> +	}
> +}

filter.h has these two helpers. They're named bytes_to_bpf_size() and bpf_size_to_bytes().
I guess we cannot really share kernel and libbpf implementation, but
could you please name them the same way so it's easier to follow
for folks who read both kernel and libbpf code?

> +		if (res->new_sz != res->orig_sz) {
> +			mem_sz = insn_mem_sz_to_bytes(insn);
> +			if (mem_sz != res->orig_sz) {
> +				pr_warn("prog '%s': relo #%d: insn #%d (LDX/ST/STX) unexpected mem size: got %u, exp %u\n",
> +					prog->name, relo_idx, insn_idx, mem_sz, res->orig_sz);
> +				return -EINVAL;
> +			}
> +
> +			mem_sz = insn_bytes_to_mem_sz(res->new_sz);
> +			if (mem_sz < 0) {

Please use new variable here appropriately named.
Few lines above mem_sz is in bytes while here it's encoding opcode.
