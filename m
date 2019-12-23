Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55CBE1299CA
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 19:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfLWSSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 13:18:34 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54535 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfLWSSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 13:18:33 -0500
Received: by mail-pj1-f67.google.com with SMTP id kx11so97387pjb.4
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 10:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:subject:cc:to:in-reply-to:references:message-id
         :mime-version:content-transfer-encoding;
        bh=zK2dqRZFS4Tk68ZjEPDcZyRGqoWDUUoOCtx/zcjLAa8=;
        b=Raq8pOWRd58UBJ/XlorG9PHdb3nwTwb99CWU6qK3tMfO/rB3RXY0OHHjFsyf1aiBC0
         gpZwslvwpwLMPr+VKy8BKctJc38v9SYhLLBR/JtqFRvOlEJzjuzRzPnfWWHuBAQVpR8a
         3RisGBNuVlqJscxqpE+YMBW0MWiDmyjri5lv1oF2MMWqZqXdXHXr4H/AhIay5YrB0rKp
         0xG5oAnZ5XQ7ekO4dHCNMv1rRLhVu7CujihtuTb/d+wJvVlycChQYYXmqCAaWmLzWsG5
         pWTaWRRN3P1EzFfOXWYR4jEWIe+M4rmnjtBH8aMNxuhIMLckqeAW+YCUa1CAf6HLtA5Y
         3Z9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:cc:to:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=zK2dqRZFS4Tk68ZjEPDcZyRGqoWDUUoOCtx/zcjLAa8=;
        b=eRtSv55WSypTe8JEF8MdVxQqTl505sAXsyGduAQvi4OWLWCEPDUQzjJT53cU5JAV9k
         7h3lHWy1De1zp10b+ZjyyAtwjfFIpng4dmNnXLNmKbChmIcS2HvT6t/R0dbnK+slxI1k
         o0yYMF79OEc1RKrlSRXF/41f62OD1SbskscwnjqcbwfBrSqoKslZ5v2SHdcSV/NClmP4
         cG8bzt93mx12JSHmcX6NVCSgg51MGB3Iq3ZkZDtMGvpDW2mFFva5NBWKA/IrX7dKqKwY
         E4lMlZhcDdS371VugyBuEocqP0Qt2CwAJ6nWqpmffjQePwFVgCHAgnJkq509NP+jvu/b
         VljQ==
X-Gm-Message-State: APjAAAXhS3/7maKfmK0xkrZ3RmpOgpW26zobRfFvPCdT6/X+MDmzP2FQ
        EHU7u7k/8TBAvYR86KuzVIAH9g==
X-Google-Smtp-Source: APXvYqy2LuNE78PASVhWkIvEthlm+Q7EFCSizUqYaOIPJWesml4iWZxM9tHwOQVWYbu5LbJYVOUH1g==
X-Received: by 2002:a17:90a:8008:: with SMTP id b8mr441916pjn.37.1577125112953;
        Mon, 23 Dec 2019 10:18:32 -0800 (PST)
Received: from localhost ([2620:0:1000:2514:7f69:cd98:a2a2:a03d])
        by smtp.gmail.com with ESMTPSA id d2sm127009pjv.18.2019.12.23.10.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 10:18:32 -0800 (PST)
Date:   Mon, 23 Dec 2019 10:18:32 -0800 (PST)
X-Google-Original-Date: Mon, 23 Dec 2019 10:14:05 PST (-0800)
From:   Palmer Dabbelt <palmerdabbelt@google.com>
X-Google-Original-From: Palmer Dabbelt <palmer@dabbelt.com>
Subject:     Re: [PATCH bpf-next v2 4/9] riscv, bpf: add support for far jumps and exits
CC:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        Bjorn Topel <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, lukenels@cs.washington.edu,
        bpf@vger.kernel.org, xi.wang@gmail.com
To:     Bjorn Topel <bjorn.topel@gmail.com>
In-Reply-To: <20191216091343.23260-5-bjorn.topel@gmail.com>
References: <20191216091343.23260-5-bjorn.topel@gmail.com>
  <20191216091343.23260-1-bjorn.topel@gmail.com>
Message-ID: <mhng-c035e490-421b-4df0-9875-ec3059b8f749@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 01:13:38 PST (-0800), Bjorn Topel wrote:
> This commit add support for far (offset > 21b) jumps and exits.
>
> Reviewed-by: Luke Nelson <lukenels@cs.washington.edu>
> Cc: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
> ---
>  arch/riscv/net/bpf_jit_comp.c | 37 ++++++++++++++++-------------------
>  1 file changed, 17 insertions(+), 20 deletions(-)
>
> diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
> index c38c95df3440..2fc0f24ad30f 100644
> --- a/arch/riscv/net/bpf_jit_comp.c
> +++ b/arch/riscv/net/bpf_jit_comp.c
> @@ -496,16 +496,6 @@ static int is_12b_check(int off, int insn)
>  	return 0;
>  }
>
> -static int is_21b_check(int off, int insn)
> -{
> -	if (!is_21b_int(off)) {
> -		pr_err("bpf-jit: insn=%d 21b < offset=%d not supported yet!\n",
> -		       insn, (int)off);
> -		return -1;
> -	}
> -	return 0;
> -}
> -
>  static void emit_imm(u8 rd, s64 val, struct rv_jit_context *ctx)
>  {
>  	/* Note that the immediate from the add is sign-extended,
> @@ -820,6 +810,21 @@ static void emit_sext_32_rd(u8 *rd, struct rv_jit_context *ctx)
>  	*rd = RV_REG_T2;
>  }
>
> +static void emit_jump_and_link(u8 rd, int rvoff, struct rv_jit_context *ctx)
> +{
> +	s64 upper, lower;
> +
> +	if (is_21b_int(rvoff)) {
> +		emit(rv_jal(rd, rvoff >> 1), ctx);
> +		return;
> +	}
> +
> +	upper = (rvoff + (1 << 11)) >> 12;
> +	lower = rvoff & 0xfff;
> +	emit(rv_auipc(RV_REG_T1, upper), ctx);
> +	emit(rv_jalr(rd, RV_REG_T1, lower), ctx);
> +}

What constrains these jumps to always be 32-bit PC relative?  We have some
issues in the module loader with references to kernel symbols being too far
away to the loaded modules, it seems like similar issues could creep in here.

>  static bool is_signed_bpf_cond(u8 cond)
>  {
>  	return cond == BPF_JSGT || cond == BPF_JSLT ||
> @@ -1101,13 +1106,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>  	/* JUMP off */
>  	case BPF_JMP | BPF_JA:
>  		rvoff = rv_offset(i, off, ctx);
> -		if (!is_21b_int(rvoff)) {
> -			pr_err("bpf-jit: insn=%d offset=%d not supported yet!\n",
> -			       i, rvoff);
> -			return -1;
> -		}
> -
> -		emit(rv_jal(RV_REG_ZERO, rvoff >> 1), ctx);
> +		emit_jump_and_link(RV_REG_ZERO, rvoff, ctx);
>  		break;
>
>  	/* IF (dst COND src) JUMP off */
> @@ -1245,9 +1244,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>  			break;
>
>  		rvoff = epilogue_offset(ctx);
> -		if (is_21b_check(rvoff, i))
> -			return -1;
> -		emit(rv_jal(RV_REG_ZERO, rvoff >> 1), ctx);
> +		emit_jump_and_link(RV_REG_ZERO, rvoff, ctx);
>  		break;
>
>  	/* dst = imm64 */
