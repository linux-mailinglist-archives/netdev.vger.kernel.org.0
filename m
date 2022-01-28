Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC34449F133
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345460AbiA1CoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345415AbiA1CoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:44:02 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7BFC061714;
        Thu, 27 Jan 2022 18:44:01 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id r144so6087117iod.9;
        Thu, 27 Jan 2022 18:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=K47owdukZ3L+Q1Bw1pTKJShEH+8gkfNPshmL9QJjSTg=;
        b=dzVmGVl+nhmM3yhSmCBWlfuw+He5ANz15j0yP08+zvTwHn9AyoovWvlHxOkdnvM0mq
         YMz+hFR8dkoY10nRkuygkiN+9jMuCd+aSBUKTQgTgdQObpmroMxLYOlxzag4I85xb8y6
         IQz9dMLcA1sKaYuSbuTjQD7srUx8w+3BILy7ov4Wq6W+xFc5QDQtqpPleiGhft/V3O27
         VhzR0J9Wd2XnQK1b/qCovFoadn+BuOgiFNjCzqFnZWcMR8Epk6EGCenz6qiiqh64oBsz
         NvydbwIjvd4TBuzXWriD9NmjviZnH38YSjobtB4XvXV90ZGMs8H5VKDY4EaXUI4rFOPQ
         TgTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=K47owdukZ3L+Q1Bw1pTKJShEH+8gkfNPshmL9QJjSTg=;
        b=YAs/in2CW8mC/ER8ozT2oVJ/b6GkAYfz0lbMk/mZ9GnoZMsUKkO+JkyNChhe/GsR8l
         PMxqc8/KNo4rMaLdTMG67bNRO/laqdY4EU9W+/o3lothZQcp6iTPrcSbiZyjLbDxv6sS
         OszaVBajhHGEdgQZ6ALlMuwoL7PPtGw8OVWyHY9GYeXXbvy590PNhQ4vw45gubMUk0pq
         sFrjcqPoFcJEcAGZDdiLbmIGuqEoduOr+/BZp86Q5o0Cf/Dde4A7zCj3H/kiTey8cTvC
         80h64WBJ9VZWUXwp7CszyuHYd5/UwEAAtfKMvFiA5IgV9el9Ol0qsNRUTrlS4NOy3neb
         eFiw==
X-Gm-Message-State: AOAM532YiJ6Do/QvQQkYWPlfycBJquJGHfomos6nSYcbLKpxfxryq5tO
        DmX0Au4+sT4pwDYhCWHS+y4=
X-Google-Smtp-Source: ABdhPJymMELJ1CdpYpWIBTdVJ1aPN5utjMqz6/81dXFHsCZNwwMCuafa5f2GvPLfd6h8OW4k13RuMQ==
X-Received: by 2002:a05:6638:d2:: with SMTP id w18mr3552306jao.291.1643337841331;
        Thu, 27 Jan 2022 18:44:01 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id w4sm13013551ilq.56.2022.01.27.18.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 18:44:01 -0800 (PST)
Date:   Thu, 27 Jan 2022 18:43:53 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hou Tao <houtao1@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <jthierry@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <61f35869ba5a_738dc20823@john.notmuch>
In-Reply-To: <8b67fa3d-f83c-85a5-5159-70b0f913833a@huawei.com>
References: <20220121135632.136976-1-houtao1@huawei.com>
 <20220121135632.136976-3-houtao1@huawei.com>
 <61f23655411bc_57f032084@john.notmuch>
 <8b67fa3d-f83c-85a5-5159-70b0f913833a@huawei.com>
Subject: Re: [PATCH bpf-next 2/2] arm64, bpf: support more atomic operations
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hou Tao wrote:
> Hi,
> 
> On 1/27/2022 2:06 PM, John Fastabend wrote:
> > Hou Tao wrote:
> >> Atomics for eBPF patch series adds support for atomic[64]_fetch_add,
> >> atomic[64]_[fetch_]{and,or,xor} and atomic[64]_{xchg|cmpxchg}, but
> >> it only add support for x86-64, so support these atomic operations
> >> for arm64 as well.
> >>
> >> +static int emit_lse_atomic(const struct bpf_insn *insn, struct jit_ctx *ctx)
> >> +{
> >> +	const u8 code = insn->code;
> >> +	const u8 dst = bpf2a64[insn->dst_reg];
> >> +	const u8 src = bpf2a64[insn->src_reg];
> >> +	const u8 tmp = bpf2a64[TMP_REG_1];
> >> +	const u8 tmp2 = bpf2a64[TMP_REG_2];
> >> +	const bool isdw = BPF_SIZE(code) == BPF_DW;
> >> +	const s16 off = insn->off;
> >> +	u8 reg;
> >> +
> >> +	if (!off) {
> >> +		reg = dst;
> >> +	} else {
> >> +		emit_a64_mov_i(1, tmp, off, ctx);
> >> +		emit(A64_ADD(1, tmp, tmp, dst), ctx);
> >> +		reg = tmp;
> >> +	}
> >> +
> >> +	switch (insn->imm) {
> > Diff'ing X86 implementation which has a BPF_SUB case how is it avoided
> > here?
> I think it is just left over from patchset [1], because according to the LLVM
> commit [2]
> __sync_fetch_and_sub(&addr, value) is implemented by __sync_fetch_and_add(&addr,
> -value).
> I will post a patch to remove it.

OK in that case LGTM with the caveat not an ARM expert.

Acked-by: John Fastabend <john.fastabend@gmail.com>

[...]

> >> +	default:
> >> +		pr_err_once("unknown atomic op code %02x\n", insn->imm);
> >> +		return -EINVAL;
> > Was about to suggest maybe EFAULT to align with x86, but on second
> > thought seems arm jit uses EINVAL more universally so best to be
> > self consistent. Just an observation.
> OK. So I will still return -EINVAL for invalid atomic operation.

Sounds good to me.

> >
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> > .
> 


