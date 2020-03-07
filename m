Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8D7A17C9A9
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 01:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCGAXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 19:23:04 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39394 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbgCGAXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 19:23:04 -0500
Received: by mail-pf1-f195.google.com with SMTP id w65so1345774pfb.6;
        Fri, 06 Mar 2020 16:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=aHXwjj4kqoC1SEgDerAO76ZAkBN7HkBzq57ChieIJ0U=;
        b=Nz2RQ4qFr+9ebYLlKZqNkzxODM4KqVdJ9x3GWVD8X9Vd+K1ft67MwvMxweebPcZ4kX
         1fM8iIX0AxpLvCjuaVQcvo0F4vKXd1L698xkxPVAWWyKtAoAwYTLe1l022iQW4c91g74
         8PeB2LarCdInXICZCnLiTvVDjyPS8sLGpagWCRRRT7/bFDsZsp0Fl/FtKu/2ZkEqm7O/
         bS7a72XKbfjsGXoLYSNARDgOrAAfV7B6rOn1TlepgI9DwQzzAr03kb0nnTGpJbsMm3I8
         yLmNmHoXQhs2X7u/uVpsQfTS9HnJHWSitx+5VEXZzB+ykUaTcnsQcW38pK2lBp24ksJD
         I3Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=aHXwjj4kqoC1SEgDerAO76ZAkBN7HkBzq57ChieIJ0U=;
        b=R0y0jaaN4UTmG6gW7erT/r3CxlkaJ9UTeYKKlTcWmWMz5EWZI9poATsOF+g4qEtLRl
         ndlH03V4nx6FUAwwGaOaf1nImUROWUbiQDBGAT3Op/GaShdl/n7XS4rII+K0Oi2HVNUx
         Un/cyNKm4uOk1eBhgP4D6zT/HsGHJQkJ/o/ona0HYYfxMubMpW6r8VOyZR6B6YUSa97j
         Ip4Bw+6uFC97WPw43LCI0btWTt21Zd4QQP0bFr56vcu7og5YPG+UH60jmH44eCbdovI9
         PFVj2CdpRVHvM5SuqjBhbcCBNObzsLA84thjgsTP6JTWessfTEwt/Qb+wbn/uOqh1Dwz
         fPJw==
X-Gm-Message-State: ANhLgQ1YPWjr1dlWozdBW1JnzUOq4p+cF/nEGRPPRmP81C6L8jApG6h7
        WrqSkRcD/GDVFqQEikekYUofzpFU
X-Google-Smtp-Source: ADFU+vujmznr/FvN03NvGVp2ibfa+vFuZgMXugCLA83SB+CvO+9opTgcLLAKri4Pjw5o1u46X0nzFg==
X-Received: by 2002:aa7:8ad9:: with SMTP id b25mr6336042pfd.70.1583540581121;
        Fri, 06 Mar 2020 16:23:01 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 72sm26260687pgd.86.2020.03.06.16.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 16:23:00 -0800 (PST)
Date:   Fri, 06 Mar 2020 16:22:51 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>, yhs@fb.com,
        alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Message-ID: <5e62e95b61bdf_5f672ade5903a5b83c@john-XPS-13-9370.notmuch>
In-Reply-To: <158353986285.3451.6986018098665897886.stgit@ubuntu3-kvm2>
References: <158353965971.3451.14666851223845760316.stgit@ubuntu3-kvm2>
 <158353986285.3451.6986018098665897886.stgit@ubuntu3-kvm2>
Subject: RE: [RFC PATCH 2/4] bpf: verifier, do explicit u32 bounds tracking
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> It is not possible for the current verifier to track u32 alu ops and jmps
> correctly. This can result in the verifier aborting with errors even though
> the program should be verifiable. Cilium code base has hit this but worked
> around it by changing int variables to u64 variables and marking a few
> things volatile. It would be better to avoid these tricks.

Quick bit of clarification, originally I tried to just track u32 hence
the title and above u32 reference. After runnning some programs I realized
this wasn't really enough to handle all cases so I added the signed 32-bit
bounds tracker. If I missed some spots in the descriptions that was just
because I missed it in the proof reading here. u32 above should be 32-bit
subreg.

I also forgot to give Yonhong credit. Sorry Yonghong! The original alu ops
tracking patch came from him.

> 
> But, the main reason to address this now is do_refine_retval_range() was
> assuming return values could not be negative. Once we fix this in the
> next patches code that was previously working will no longer work.
> See do_refine_retval_range() patch for details.
> 
> The simplest example code snippet that illustrates the problem is likelyy
> this,
> 
>  53: w8 = w0                    // r8 <- [0, S32_MAX],
>                                 // w8 <- [-S32_MIN, X]
>  54: w8 <s 0                    // r8 <- [0, U32_MAX]
>                                 // w8 <- [0, X]

[...]
 
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 5406e6e96585..66126c411d52 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -114,6 +114,7 @@ struct bpf_reg_state {
>  	 * with the same id as us.
>  	 */
>  	struct tnum var_off;
> +	struct tnum var32_off;
>  	/* Used to determine if any memory access using this register will
>  	 * result in a bad access.
>  	 * These refer to the same value as var_off, not necessarily the actual
> @@ -123,6 +124,10 @@ struct bpf_reg_state {
>  	s64 smax_value; /* maximum possible (s64)value */
>  	u64 umin_value; /* minimum possible (u64)value */
>  	u64 umax_value; /* maximum possible (u64)value */
> +	s32 s32_min_value; /* minimum possible (s32)value */
> +	s32 s32_max_value; /* maximum possible (s32)value */
> +	u32 u32_min_value; /* minimum possible (u32)value */
> +	u32 u32_max_value; /* maximum possible (u32)value */
>  	/* parentage chain for liveness checking */
>  	struct bpf_reg_state *parent;
>  	/* Inside the callee two registers can be both PTR_TO_STACK like
> diff --git a/include/linux/limits.h b/include/linux/limits.h
> index 76afcd24ff8c..0d3de82dd354 100644
> --- a/include/linux/limits.h
> +++ b/include/linux/limits.h
> @@ -27,6 +27,7 @@
>  #define S16_MAX		((s16)(U16_MAX >> 1))
>  #define S16_MIN		((s16)(-S16_MAX - 1))
>  #define U32_MAX		((u32)~0U)
> +#define U32_MIN		((u32)0)

I like using U32_MIN and U64_MIN defines, I think it reads better
but not necessary and could be pushed into bpf-next perhaps.

>  #define S32_MAX		((s32)(U32_MAX >> 1))
>  #define S32_MIN		((s32)(-S32_MAX - 1))
>  #define U64_MAX		((u64)~0ULL)
> diff --git a/include/linux/tnum.h b/include/linux/tnum.h

[...]

> diff --git a/kernel/bpf/tnum.c b/kernel/bpf/tnum.c
> index d4f335a9a899..a444f77fb169 100644
> --- a/kernel/bpf/tnum.c
> +++ b/kernel/bpf/tnum.c
> @@ -12,6 +12,8 @@
>  #define TNUM(_v, _m)	(struct tnum){.value = _v, .mask = _m}
>  /* A completely unknown value */
>  const struct tnum tnum_unknown = { .value = 0, .mask = -1 };
> +/* should we have a proper 32-bit tnum so math works without hacks? */
> +const struct tnum tnum32_unknown = { .value = 0, .mask = 0xffffffff };
>  
>  struct tnum tnum_const(u64 value)
>  {

Per commit message comment ^^^^ here is the tnum logic that I suspect
should be made 32 bit types although maybe not harmful as is.

>  
>  	/* detect if R == 0 where R is returned from bpf_map_lookup_elem().
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index 87eaa49609a0..97463ad255ac 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -943,7 +943,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>  	attr.insns = prog;
>  	attr.insns_cnt = prog_len;
>  	attr.license = "GPL";
> -	attr.log_level = verbose || expected_ret == VERBOSE_ACCEPT ? 1 : 4;
> +	attr.log_level = verbose || expected_ret == VERBOSE_ACCEPT ? 2 : 4;

This is just test code I'll push something to bpf-next so we can make
test_verifier more verbose. I found this helpful when debugging errors.
Seems probably useful upstream as well seeing I do this often I'm
guessing others probably do as well. Probably 'test_verifier -vv' should
do the trick.


>  	attr.prog_flags = pflags;
>  
>  	fd_prog = bpf_load_program_xattr(&attr, bpf_vlog, sizeof(bpf_vlog));
> 


