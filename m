Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263E0286B95
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 01:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgJGXoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 19:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgJGXoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 19:44:22 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FC6C061755;
        Wed,  7 Oct 2020 16:44:22 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id z5so4028229ilq.5;
        Wed, 07 Oct 2020 16:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=SZ0JhaCIGHS14xbgQZAAz+ODt1cKAexG8cxga0f0jOQ=;
        b=jMmED/YNSN6yJ/a9nVfNTJfLVn5NGU/+ZzE5ZvDJEuhU9ilbyzhpT2J+j2dapfrANX
         DpbsxNA1H3cncm8wc8rOjsOdj13tCawzJasB54fNk2C99whIBnenocpIS6oAG5XaylvV
         WyaOMqU9tbmiFVWsGBJYTaxM1HSN/0VyMoHUv3ZL977n8+24psPDO+Af/deeg3aQ1/9s
         8idQuJvfNIIuS+l5CS9V6x2DApE2gLqr8f2P52R41icLFLAuKGEtucVgFsEMyfMqeiyF
         A/2lYrpRqKuA7CXMFzG/9Mn5DI2/EfsKSrtDJ7NrSRcOM+kSFdDFT8TRDQ9egKcakajM
         2GzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=SZ0JhaCIGHS14xbgQZAAz+ODt1cKAexG8cxga0f0jOQ=;
        b=Fi88t8eELw6e3uB6C6kd8tP+zVieoudkd99eOB80hqX37pqo3Xlu43ju1JiEfP2KzG
         TFDGLfrLP/7km1UZZVETv2JI+P2Nw6FyWu8o9pa0bkjuhRZk0r0uznQdvNcJJJCZnMh/
         WsI8fWQiyln4haEeV+sq3pkZ/erql8V79NXrjfeGrlxgE4dtLso1DlMWbvAz7C8Rkvv6
         Geq++7L0/J+5Py4/t5z/ygzZvW2SdMTEEe9wDO8+y2u89WoGWrwaC0tzLWE6TkaoCTpT
         pQONFG6K28phuh8YFVkYI0lkWqqV7ftZnfvMwJX0XJdvx9+xOlle/zqn1UNUQSs01IoT
         QcaA==
X-Gm-Message-State: AOAM5310Xci5Wro2tKgAyibMbCx1yUKtm3rzQo27sQ5Lsm2wcgiF/LGK
        Iqgn69Fv/FjCCZVe7GLiU2M=
X-Google-Smtp-Source: ABdhPJyqkrfqQnxoy1/Y08GYe+4rRCm4DAHiEufPMLhJhvzcNKiFoib5AodADoA8KOteuWI6pSN6+w==
X-Received: by 2002:a92:9fd5:: with SMTP id z82mr4625539ilk.262.1602114261903;
        Wed, 07 Oct 2020 16:44:21 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f2sm1687318ilr.13.2020.10.07.16.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 16:44:20 -0700 (PDT)
Date:   Wed, 07 Oct 2020 16:44:14 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Message-ID: <5f7e52ce81308_1a83120890@john-XPS-13-9370.notmuch>
In-Reply-To: <20201006200955.12350-2-alexei.starovoitov@gmail.com>
References: <20201006200955.12350-1-alexei.starovoitov@gmail.com>
 <20201006200955.12350-2-alexei.starovoitov@gmail.com>
Subject: RE: [PATCH bpf-next 1/3] bpf: Propagate scalar ranges through
 register assignments.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The llvm register allocator may use two different registers representing the
> same virtual register. In such case the following pattern can be observed:
> 1047: (bf) r9 = r6
> 1048: (a5) if r6 < 0x1000 goto pc+1
> 1050: ...
> 1051: (a5) if r9 < 0x2 goto pc+66
> 1052: ...
> 1053: (bf) r2 = r9 /* r2 needs to have upper and lower bounds */
> 
> In order to track this information without backtracking allocate ID
> for scalars in a similar way as it's done for find_good_pkt_pointers().
> 
> When the verifier encounters r9 = r6 assignment it will assign the same ID
> to both registers. Later if either register range is narrowed via conditional
> jump propagate the register state into the other register.
> 
> Clear register ID in adjust_reg_min_max_vals() for any alu instruction.

Do we also need to clear the register ID on reg0 for CALL ops into a
helper?

Looks like check_helper_call might mark reg0 as a scalar, but I don't
see where it would clear the reg->id? Did I miss it. Either way maybe
a comment here would help make it obvious how CALLs are handled?

Thanks,
John

> 
> Newly allocated register ID is ignored for scalars in regsafe() and doesn't
> affect state pruning. mark_reg_unknown() also clears the ID.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  kernel/bpf/verifier.c                         | 38 +++++++++++++++++++
>  .../testing/selftests/bpf/prog_tests/align.c  | 16 ++++----
>  .../bpf/verifier/direct_packet_access.c       |  2 +-
>  3 files changed, 47 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 01120acab09a..09e17b483b0b 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -6432,6 +6432,8 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
>  	src_reg = NULL;
>  	if (dst_reg->type != SCALAR_VALUE)
>  		ptr_reg = dst_reg;
> +	else
> +		dst_reg->id = 0;
>  	if (BPF_SRC(insn->code) == BPF_X) {
>  		src_reg = &regs[insn->src_reg];
>  		if (src_reg->type != SCALAR_VALUE) {
> @@ -6565,6 +6567,8 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
>  				/* case: R1 = R2
>  				 * copy register state to dest reg
>  				 */
> +				if (src_reg->type == SCALAR_VALUE)
> +					src_reg->id = ++env->id_gen;
>  				*dst_reg = *src_reg;
>  				dst_reg->live |= REG_LIVE_WRITTEN;
>  				dst_reg->subreg_def = DEF_NOT_SUBREG;
> @@ -7365,6 +7369,30 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
>  	return true;
>  }
