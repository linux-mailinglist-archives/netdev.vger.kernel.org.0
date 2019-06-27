Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48775825D
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 14:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfF0MSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 08:18:39 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56084 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfF0MSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 08:18:39 -0400
Received: by mail-wm1-f65.google.com with SMTP id a15so5514419wmj.5
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 05:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Zdd4Pp3dYlawoEQsjCTjL1Bm9eBCVbOZ/q37LUapnaQ=;
        b=k8ywuutI5JJ1zOZBUSRsiA6wF2HW/8zzohHwXhnHqAE4EOXoGZ6iion4AWL7kpTwR6
         qAY+CpaQo3wjcaUtdet5Ew+axkm4VjOnlrKl9HBABghASKurGPUynYSpaOP4PU+6mece
         z7xORIC5BZJAMxRKJwKl4WQ6E0fiVnWmR9t39mGB2/DytymcTWatNM/SRNdT8DoCixeQ
         eudI3hm86XZDcojtmkzCOfoFGiokZRxpQQutxIzHUgMQAA339QF1UW1S2h7QIsQlNetS
         1vsloMKS2mL8TAN9kbK+Zjz8hEQZ7WBEOJKvJIoBDSTqwV5KXBqHBppJN9/PdbPQ+IiX
         mvDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Zdd4Pp3dYlawoEQsjCTjL1Bm9eBCVbOZ/q37LUapnaQ=;
        b=iqt0PSJAfS5/oN/M5lPI/5oTyhtguKTajWwtMvYAY+JiX519Tu6I9woSf2yykmzkE3
         JzWum/hUam/veJ6N2BCKq+Z/VrVCcUK5cyhBXVTscNrawdGuDEBpkrUfbzgX7Vto7Clc
         T2Hb1bb0T/6/jUMUWL58lny4hyuBCeYSKuJLliK0gtm3+VBVZgnxqKqzH2h4ZofRxeFQ
         5dCnR7YGOeTcA5+dzZB59Vrt/lO0v4h0jweIgBKMHg0f+8Y2/EexViMLR6B1IJqi6WeP
         Hat1VIeJIizOYhX7vraBs3jGP23W6EG3FUK8szxBwCQFiJUrPEAQa2/SnbKOGu5kCCKu
         sSvQ==
X-Gm-Message-State: APjAAAWjMOLmMccerX6lb4zNZgzFpqmpd5MD9xuNJaFbsmRqIsUvXUv1
        P0ZnbMkVxq6l2g/il5K1mFblsA==
X-Google-Smtp-Source: APXvYqwP5/KqbmGqmRh+sNx5VCR+6gZxpNd+GAZ3G0BUulrp4g0b6pfWHwk+3cirqW7BcslJWBkoWg==
X-Received: by 2002:a1c:7a01:: with SMTP id v1mr3202693wmc.10.1561637917201;
        Thu, 27 Jun 2019 05:18:37 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id l19sm3291337wmj.33.2019.06.27.05.18.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Jun 2019 05:18:36 -0700 (PDT)
References: <20190626231257.14495-1-lukenels@cs.washington.edu>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     linux-kernel@vger.kernel.org, Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        =?utf-8?B?QmrDtnJu?= =?utf-8?B?IFTDtnBlbA==?= 
        <bjorn.topel@gmail.com>, linux-riscv@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next] RV32G eBPF JIT
In-reply-to: <20190626231257.14495-1-lukenels@cs.washington.edu>
Date:   Thu, 27 Jun 2019 13:18:35 +0100
Message-ID: <87y31nuspw.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Luke Nelson writes:

<snip>
> +
> +static int emit_insn(const struct bpf_insn *insn,
> +		     struct rv_jit_context *ctx,
> +		     bool extra_pass)
> +{
> +	int rvoff, i = insn - ctx->prog->insnsi;
> +	u8 code = insn->code;
> +	s16 off = insn->off;
> +	s32 imm = insn->imm;
> +
> +	const s8 *dst = bpf2rv32[insn->dst_reg];
> +	const s8 *src = bpf2rv32[insn->src_reg];
> +	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
> +	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
> +
> +	switch (code) {
> +	case BPF_ALU64 | BPF_MOV | BPF_X:
> +		if (imm == 1) {
> +			/* Special mov32 for zext */
> +			emit_rv32_zext64(dst, ctx);
> +			break;
> +		}

Thanks for adding the 32-bit opt!

Just want to mention ZEXT is a special mov32, see include/linux/filter.h:

#define BPF_ZEXT_REG(DST)
        ((struct bpf_insn) {
                 .code  = BPF_ALU | BPF_MOV | BPF_X

So it can't be BPF_ALU64. It is safe to remove this chunk of code.

For backend like arm, riscv etc, they are grouping several CASE label
together and are sharing code. imm == 1 check is done inside the shared
code to avoid moving code around given imm == 1 can't be true for ALU64 as
if there is such insn (register format using imm) it should have been
rejected by verifier. While mov32 variant is inserted by verifier at very
late stage after main verification finished.

Regards,
Jiong
