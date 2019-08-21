Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C5A986DE
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 23:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbfHUVvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 17:51:40 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36618 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728872AbfHUVvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 17:51:40 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so3644978wme.1
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 14:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=tzs0xL7F6e4DYv0KKXWstcIwevn1IeV2WU1eJYUjfUc=;
        b=cSapzLObrFhl9WiOnkT1Yt3qMrv+d9JGVzxCP0RCrg4HDDoOq9rDy26FxLVG1MUZWU
         Tb3wG8LMVh2xbjCriUATkhMeVZCg4a4IaoE0La8xSVXj2Vj55w0A4Jb6KQFbsbDaT0lq
         RbjwbjviHSBy9Ih21aDFJiuNnLLsa8FprO2LzTBYqg3pWDKz1Lk86wy/DzYpt2mxi+0M
         agenDEbadExsbz/tlANeVWRO5zI1fm2U9mK3oimhQdlChq+5WojjnsV0IxhasGg54NzQ
         PeE/BQUGj2ZarJ43yyiKHKL6xiB7I8ASK50mlaQGzkhcyI0fDVH97/iYsutzOeOjPXkd
         zkpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=tzs0xL7F6e4DYv0KKXWstcIwevn1IeV2WU1eJYUjfUc=;
        b=UZ+Ek8FOX1K0hYbz0/lnf4heUKw9oREacKmLxqVK10qurWuiv1Po3gxxmEbq0rmRI9
         /qPaX07ju8sW+W69WuzHCAn3yQVWdbvHFCk/86jkOzQg+cbrO89QF7HYpcV4ZeRvAaKN
         VIqqoceyIXTdBDb01X6CvfGUfvv0Y7Yg3m6kokIFnbARhLDBb44s/zj1nlc/k60fA5QD
         HAafjIBzH9ZjdkB5TII1lWQHYqRgrIoSMoMAO9LL/oVATkyG2LSbWv3hB7gDf952F/5v
         G2yCanYV9KbzHH9AWOsQ1KBTyOoz179cQ0Cl6LX+Zu/Qp7po/ZeWcqxDweeawJCNWQ+/
         L8BQ==
X-Gm-Message-State: APjAAAXTJ5CFMzxW7kRprRWFQZYijtIX8x/ItwaenvJiyVkEHrmJosoh
        CrTZZzPv0/XI+lJtLBAnBW/OYCLfUgk=
X-Google-Smtp-Source: APXvYqy2LFveaB3xNaCXGpcvOKttC8dJWdS9RQtFwtlXe9SG6QFy84en6i34jTXyo21MVdAelxHMqA==
X-Received: by 2002:a1c:7d08:: with SMTP id y8mr2441435wmc.50.1566424298379;
        Wed, 21 Aug 2019 14:51:38 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL (cpc1-cmbg19-2-0-cust104.5-4.cable.virginm.net. [82.27.180.105])
        by smtp.gmail.com with ESMTPSA id r15sm38044110wrj.68.2019.08.21.14.51.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Aug 2019 14:51:37 -0700 (PDT)
References: <20190821192358.31922-1-naveen.n.rao@linux.vnet.ibm.com>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiong Wang <jiong.wang@netronome.com>,
        Michael Ellerman <mpe@ellerman.id.au>, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bpf: handle 32-bit zext during constant blinding
In-reply-to: <20190821192358.31922-1-naveen.n.rao@linux.vnet.ibm.com>
Date:   Wed, 21 Aug 2019 22:51:35 +0100
Message-ID: <87zhk2faqg.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Naveen N. Rao writes:

> Since BPF constant blinding is performed after the verifier pass, the
> ALU32 instructions inserted for doubleword immediate loads don't have a
> corresponding zext instruction. This is causing a kernel oops on powerpc
> and can be reproduced by running 'test_cgroup_storage' with
> bpf_jit_harden=2.
>
> Fix this by emitting BPF_ZEXT during constant blinding if
> prog->aux->verifier_zext is set.
>
> Fixes: a4b1d3c1ddf6cb ("bpf: verifier: insert zero extension according to analysis result")
> Reported-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

Thanks for the fix.

Reviewed-by: Jiong Wang <jiong.wang@netronome.com>

Just two other comments during review in case I am wrong on somewhere.

  - Use verifier_zext instead of bpf_jit_needs_zext() seems better, even
    though the latter could avoid extending function argument.

    Because JIT back-ends look at verifier_zext, true means zext inserted
    by verifier so JITs won't do the code-gen.

    Use verifier_zext is sort of keeping JIT blinding the same behaviour
    has verifier even though blinding doesn't belong to verifier, but for
    such insn patching, it could be seen as a extension of verifier,
    therefore use verifier_zext seems better than bpf_jit_needs_zext() to
    me.
   
  - JIT blinding is also escaping the HI32 randomization which happens
    inside verifier, otherwise x86-64 regression should have caught this issue.

Regards,
Jiong

> ---
> Changes since RFC:
> - Removed changes to ALU32 and JMP32 ops since those don't alter program 
>   execution, and the verifier would have already accounted for them.  
>
>
>  kernel/bpf/core.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 8191a7db2777..66088a9e9b9e 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -890,7 +890,8 @@ int bpf_jit_get_func_addr(const struct bpf_prog *prog,
>  
>  static int bpf_jit_blind_insn(const struct bpf_insn *from,
>  			      const struct bpf_insn *aux,
> -			      struct bpf_insn *to_buff)
> +			      struct bpf_insn *to_buff,
> +			      bool emit_zext)
>  {
>  	struct bpf_insn *to = to_buff;
>  	u32 imm_rnd = get_random_int();
> @@ -1005,6 +1006,8 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
>  	case 0: /* Part 2 of BPF_LD | BPF_IMM | BPF_DW. */
>  		*to++ = BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ aux[0].imm);
>  		*to++ = BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
> +		if (emit_zext)
> +			*to++ = BPF_ZEXT_REG(BPF_REG_AX);
>  		*to++ = BPF_ALU64_REG(BPF_OR,  aux[0].dst_reg, BPF_REG_AX);
>  		break;
>  
> @@ -1088,7 +1091,8 @@ struct bpf_prog *bpf_jit_blind_constants(struct bpf_prog *prog)
>  		    insn[1].code == 0)
>  			memcpy(aux, insn, sizeof(aux));
>  
> -		rewritten = bpf_jit_blind_insn(insn, aux, insn_buff);
> +		rewritten = bpf_jit_blind_insn(insn, aux, insn_buff,
> +						clone->aux->verifier_zext);
>  		if (!rewritten)
>  			continue;

