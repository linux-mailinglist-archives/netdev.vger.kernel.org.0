Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0134568F6
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 05:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbhKSERP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 23:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbhKSERN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 23:17:13 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E419C061574;
        Thu, 18 Nov 2021 20:14:12 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id x5so8294267pfr.0;
        Thu, 18 Nov 2021 20:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k+gIdsYJUjvK45A0v4seSNPfEuc4BsYKoVtwqDX/ZFw=;
        b=Zwy9Us4QMRnr2c2+DmK+5FZoNEkwxmTmaWpsWU1HQYKhO64yHJ7qnqD/N1MrZeDVh2
         tdBTPejQpTD5PxD/Zia3JvUKqJ/uVcA1Ns32RAFVyPdDZSaGXHWckkDlGyb1BO7HuS05
         9jHd4q3W9hfLc90un77Eo801ZM7aJVDj3tZJV+IJsUmGfNut1pOd2eYdPw3orlVPO1vV
         Ob+nI7TO9nf2JrjsR6OhcTEdBymBj8tNtYYp67tuVFAoHS5eB6gAn+vVeY5TR7tpKnsc
         U187NrGLenAff91/Q3TYIJlkettmSXsw3UwP9oA8kqV7Ky1RItTNAdbJNLTPG9PlHirr
         KnCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k+gIdsYJUjvK45A0v4seSNPfEuc4BsYKoVtwqDX/ZFw=;
        b=GAno16GByE5Pugx7RK8uHYRmXGYyLphI1/CtQjZydXeIVol4JiEUe00tWoYgOpgIWH
         FdEBy455XjIfXEcsDKnDSVshPXfcfT8d0M1oLHuXWmuj5cG/VikAmZe0wcRY7O8Fve57
         b+G7R/mHgkW5H1w+uP6jD5bg2y+HNUan1KJqKTqA0nq71ofGo/PVTLuYRUOQv7N6c0Qk
         k8q7TqjVtYH/2AjnMopNASIgjjojzEglcyQPk9A8LHVB1wrwbIrtE8Us4bRAa6ah+n+4
         7/CKakVUGX+GCZzkD6CHd4Anm3RxTt0NXWmvIz024ljlCfd57FQclZ3kYVoFKN0TORq/
         f15Q==
X-Gm-Message-State: AOAM532ssxHD648HPeRN+g+yXpHiI9mS3ceOHWZH7VKITDUMV9mxbYnl
        u7HCrRX94/B6UG0w7m9mvKw=
X-Google-Smtp-Source: ABdhPJzbvO/bSAjgVtv7OWCWhP6/NP/dc4+yfPI96GMSHPL8LmizuKKtWCwMSUk8P9ZZANy3wdbKQw==
X-Received: by 2002:a62:8441:0:b0:4a2:e934:56b8 with SMTP id k62-20020a628441000000b004a2e93456b8mr26422107pfd.20.1637295251588;
        Thu, 18 Nov 2021 20:14:11 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4e33])
        by smtp.gmail.com with ESMTPSA id w5sm1085784pfu.219.2021.11.18.20.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 20:14:11 -0800 (PST)
Date:   Thu, 18 Nov 2021 20:14:09 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 07/29] bpf, x64: Allow to use caller address
 from stack
Message-ID: <20211119041409.rb7b4i7nukowfcwb@ast-mbp.dhcp.thefacebook.com>
References: <20211118112455.475349-1-jolsa@kernel.org>
 <20211118112455.475349-8-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118112455.475349-8-jolsa@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 12:24:33PM +0100, Jiri Olsa wrote:
> Currently we call the original function by using the absolute address
> given at the JIT generation. That's not usable when having trampoline
> attached to multiple functions. In this case we need to take the
> return address from the stack.
> 
> Adding support to retrieve the original function address from the stack
> by adding new BPF_TRAMP_F_ORIG_STACK flag for arch_prepare_bpf_trampoline
> function.
> 
> Basically we take the return address of the 'fentry' call:
> 
>    function + 0: call fentry    # stores 'function + 5' address on stack
>    function + 5: ...
> 
> The 'function + 5' address will be used as the address for the
> original function to call.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  arch/x86/net/bpf_jit_comp.c | 13 +++++++++----
>  include/linux/bpf.h         |  5 +++++
>  2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 67e8ac9aaf0d..d87001073033 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -2035,10 +2035,15 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>  	if (flags & BPF_TRAMP_F_CALL_ORIG) {
>  		restore_regs(m, &prog, nr_args, stack_size);
>  
> -		/* call original function */
> -		if (emit_call(&prog, orig_call, prog)) {
> -			ret = -EINVAL;
> -			goto cleanup;
> +		if (flags & BPF_TRAMP_F_ORIG_STACK) {
> +			emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
> +			EMIT2(0xff, 0xd0); /* call *rax */

Either return an eror if repoline is on
or use emit_indirect_jump().
