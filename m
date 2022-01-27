Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4D849DA6F
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 07:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236387AbiA0GGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 01:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiA0GGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 01:06:23 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20371C061714;
        Wed, 26 Jan 2022 22:06:23 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id s6-20020a0568301e0600b0059ea5472c98so1544072otr.11;
        Wed, 26 Jan 2022 22:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=cOfoUhoFx3jKlhD91yxDstyBmmtQrEA0QvMamiSos8A=;
        b=bgpkoroeWbjXup7dfsQ6y1qhz4a9tQ0Ea7HEinBfWJjNW/cOK+4W3H/g8Jjw004k01
         vOatqsNNK8bMxuDycGTIE2YeaCw4LbizYZEZ2IXYjvTeoYvdOSSC3kNdcxg7XUZvug7e
         R2k8BTVi0/GCyazcE6gj0nBK/bHAfQvT0T7l24RSfe6iCCPsZ+uVV/YCb7PoraRdOgFy
         TO32yZOwNky55DBZV3qY9xu6SWEurAiclYcYalL0aLErJZvMtOnsr9P7TSntjzloYdRX
         CZys8fib++e1z2aTUQGbNGj2L3r6se8JH8JRMr6GVQb5ekukZ3ALZiKqsqxSvJyGpxlF
         kchg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=cOfoUhoFx3jKlhD91yxDstyBmmtQrEA0QvMamiSos8A=;
        b=wvJtqUQnjkGz5TcGOPol+pGyMEyQ/TejUlUrGyzQgQIr5JGKHHIfdl01H1XW1xRG7Z
         SRlkSD5HA+HoKMyVsaBv/VJ/4WHJa1PJWzNGpxLiq19oKnCNK7HO3d7eah5tqfpT6+56
         YyD3hwfieB6epdMKDr1N4TOBOh25YxiyKkkJhtTCYVpx7ijO0S2m6LYQwqz9vGNzgzng
         5l98JbKfc3veUZitzJiLzTq1BTZSMKiErNSasv955oF5JfdMw89euL9DE7P+HvjFdTTf
         pusvaPdlSPpwQG31iPGzCb+E8DCgaJZG9dUbUVQ5NuknNRQCRJj5bbkYPT9eBOs+EBB1
         QXwQ==
X-Gm-Message-State: AOAM5307Ybw3rerspk+Ir67BqCHYU8+LMCRve3f5zLwrstvYSZIA8cng
        qYMDLTIGRxckM9Sp6Q0kaElHji1VikMugQ==
X-Google-Smtp-Source: ABdhPJzthtDDVq5A55A2CfKyw2Y8wVNKgQAyDsBSu7233h9Br8CMh73tnllAPgizN+LnmoCE4RiAcA==
X-Received: by 2002:a05:6830:3148:: with SMTP id c8mr1407385ots.380.1643263582464;
        Wed, 26 Jan 2022 22:06:22 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id q188sm7466800oig.15.2022.01.26.22.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 22:06:22 -0800 (PST)
Date:   Wed, 26 Jan 2022 22:06:13 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, houtao1@huawei.com,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <jthierry@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <61f23655411bc_57f032084@john.notmuch>
In-Reply-To: <20220121135632.136976-3-houtao1@huawei.com>
References: <20220121135632.136976-1-houtao1@huawei.com>
 <20220121135632.136976-3-houtao1@huawei.com>
Subject: RE: [PATCH bpf-next 2/2] arm64, bpf: support more atomic operations
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hou Tao wrote:
> Atomics for eBPF patch series adds support for atomic[64]_fetch_add,
> atomic[64]_[fetch_]{and,or,xor} and atomic[64]_{xchg|cmpxchg}, but
> it only add support for x86-64, so support these atomic operations
> for arm64 as well.
> 
> Basically the implementation procedure is almost mechanical translation
> of code snippets in atomic_ll_sc.h & atomic_lse.h & cmpxchg.h located
> under arch/arm64/include/asm. An extra temporary register is needed
> for (BPF_ADD | BPF_FETCH) to save the value of src register, instead of
> adding TMP_REG_4 just use BPF_REG_AX instead.
> 
> For cpus_have_cap(ARM64_HAS_LSE_ATOMICS) case and no-LSE-ATOMICS case,
> both ./test_verifier and "./test_progs -t atomic" are exercised and
> passed correspondingly.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  

[...]

> +static int emit_lse_atomic(const struct bpf_insn *insn, struct jit_ctx *ctx)
> +{
> +	const u8 code = insn->code;
> +	const u8 dst = bpf2a64[insn->dst_reg];
> +	const u8 src = bpf2a64[insn->src_reg];
> +	const u8 tmp = bpf2a64[TMP_REG_1];
> +	const u8 tmp2 = bpf2a64[TMP_REG_2];
> +	const bool isdw = BPF_SIZE(code) == BPF_DW;
> +	const s16 off = insn->off;
> +	u8 reg;
> +
> +	if (!off) {
> +		reg = dst;
> +	} else {
> +		emit_a64_mov_i(1, tmp, off, ctx);
> +		emit(A64_ADD(1, tmp, tmp, dst), ctx);
> +		reg = tmp;
> +	}
> +
> +	switch (insn->imm) {

Diff'ing X86 implementation which has a BPF_SUB case how is it avoided
here?

> +	/* lock *(u32/u64 *)(dst_reg + off) <op>= src_reg */
> +	case BPF_ADD:
> +		emit(A64_STADD(isdw, reg, src), ctx);
> +		break;
> +	case BPF_AND:
> +		emit(A64_MVN(isdw, tmp2, src), ctx);
> +		emit(A64_STCLR(isdw, reg, tmp2), ctx);
> +		break;
> +	case BPF_OR:
> +		emit(A64_STSET(isdw, reg, src), ctx);
> +		break;
> +	case BPF_XOR:
> +		emit(A64_STEOR(isdw, reg, src), ctx);
> +		break;
> +	/* src_reg = atomic_fetch_add(dst_reg + off, src_reg) */
> +	case BPF_ADD | BPF_FETCH:
> +		emit(A64_LDADDAL(isdw, src, reg, src), ctx);
> +		break;
> +	case BPF_AND | BPF_FETCH:
> +		emit(A64_MVN(isdw, tmp2, src), ctx);
> +		emit(A64_LDCLRAL(isdw, src, reg, tmp2), ctx);
> +		break;
> +	case BPF_OR | BPF_FETCH:
> +		emit(A64_LDSETAL(isdw, src, reg, src), ctx);
> +		break;
> +	case BPF_XOR | BPF_FETCH:
> +		emit(A64_LDEORAL(isdw, src, reg, src), ctx);
> +		break;
> +	/* src_reg = atomic_xchg(dst_reg + off, src_reg); */
> +	case BPF_XCHG:
> +		emit(A64_SWPAL(isdw, src, reg, src), ctx);
> +		break;
> +	/* r0 = atomic_cmpxchg(dst_reg + off, r0, src_reg); */
> +	case BPF_CMPXCHG:
> +		emit(A64_CASAL(isdw, src, reg, bpf2a64[BPF_REG_0]), ctx);
> +		break;
> +	default:
> +		pr_err_once("unknown atomic op code %02x\n", insn->imm);
> +		return -EINVAL;

Was about to suggest maybe EFAULT to align with x86, but on second
thought seems arm jit uses EINVAL more universally so best to be
self consistent. Just an observation.

> +	}
> +
> +	return 0;
> +}
> +
