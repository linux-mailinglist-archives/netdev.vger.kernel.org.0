Return-Path: <netdev+bounces-9033-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6631A726A58
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:04:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69C261C20E99
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36A0B39232;
	Wed,  7 Jun 2023 20:03:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F7C10FC;
	Wed,  7 Jun 2023 20:03:54 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9AA18F;
	Wed,  7 Jun 2023 13:03:53 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-6537d2a8c20so3758136b3a.2;
        Wed, 07 Jun 2023 13:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686168232; x=1688760232;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bHKjzGwc0lyJg1vFqfFtVd9GS9Kft6p18Bc6rAwcZpY=;
        b=PPezEEDAUHoR22KL+52rSryCqk0L2lWwGbb9sdngOl/RelbDtEsIfQKkfQ3pMtFY6H
         ZtsVKSBesSMVHHVYbWc1E+8idpNEccXmz+D7iymjtNiDeBQXZzkVtNLQaUocziBs56pP
         6S3tVC1Bj6LUpcQM5aWzpn6eJyeJMXNXg9ySyxsojecfYlgBIdSz9M2sGRAFwV003bdn
         gcVoixNATS7rKcpkOc8x5TV8vF7b2qs2CkBQHi5T13ff35Z8h3qHvw5bfMfpJCg7fG40
         erxhciVpnki0Xo6LduNp5BajjI27w1ihgwJkSJpMdn9BImsy/vd9JlCp7eYFz2kawVBk
         GzMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686168232; x=1688760232;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bHKjzGwc0lyJg1vFqfFtVd9GS9Kft6p18Bc6rAwcZpY=;
        b=UX5oDTno2PbkrY2TwsdM1NIT+P0gTjbkz5t0GVI30Grxq61tVaIBvgIQvBXsw1KFyE
         kLQz7lxd5fqg/Qi9kC+qIMhwMi1p6BxFCYSE5BmSYe42/exmE7coSK42b2+tL5zYnw52
         5HjU/Eo1q2bYgldY+aN1x9OPbZCcKksBhAMY3ha5tDhEOAnQDU/ZdcA9hR2wujyapq5Y
         eM+vFhF/dxpfv0qiokQd0FpCZLFGtVaKaj9QrYEXreOB+9vR4xnFsK1a3aT/PWttr0Q2
         Cujg8j6GFtOqrfpYStAOKIsSi3mhJSX41kvuVWhcQA1DK+gWhU/UMtJ2bhQ6kwx79BgW
         bFUw==
X-Gm-Message-State: AC+VfDzyci9Gw22bRX1mVLYYoQBQk/SclWQjw9WFUCKOT1SawVbHTPes
	Zg1ywMNnvVbfmFqLbCR6pl0=
X-Google-Smtp-Source: ACHHUZ4cEI1Aezo0gDCSmMAHryAhSIaXaDeg1qlzjazwCTwZcZfh4VaquvPc440BrSplyEvViigb/g==
X-Received: by 2002:a05:6a20:438b:b0:10c:5802:fce4 with SMTP id i11-20020a056a20438b00b0010c5802fce4mr1991827pzl.48.1686168232268;
        Wed, 07 Jun 2023 13:03:52 -0700 (PDT)
Received: from macbook-pro-8.dhcp.thefacebook.com ([2620:10d:c090:500::6:1c96])
        by smtp.gmail.com with ESMTPSA id y23-20020a62b517000000b0064d2ad04cbesm8660972pfe.209.2023.06.07.13.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 13:03:51 -0700 (PDT)
Date: Wed, 7 Jun 2023 13:03:48 -0700
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: menglong8.dong@gmail.com
Cc: davem@davemloft.net, dsahern@kernel.org, ast@kernel.org,
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@google.com, x86@kernel.org,
	imagedong@tencent.com, benbjiang@tencent.com,
	netdev@vger.kernel.org, bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 2/3] bpf, x86: clean garbage value in the
 stack of trampoline
Message-ID: <20230607200348.dprmfvpzdvk5ldpp@macbook-pro-8.dhcp.thefacebook.com>
References: <20230607125911.145345-1-imagedong@tencent.com>
 <20230607125911.145345-3-imagedong@tencent.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607125911.145345-3-imagedong@tencent.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 08:59:10PM +0800, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> There are garbage values in upper bytes when we store the arguments
> into stack in save_regs() if the size of the argument less then 8.
> 
> As we already reserve 8 byte for the arguments in regs and stack,
> it is ok to store/restore the regs in BPF_DW size. Then, the garbage
> values in upper bytes will be cleaned.
> 
> Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  arch/x86/net/bpf_jit_comp.c | 19 ++++++-------------
>  1 file changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 413b986b5afd..e9bc0b50656b 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -1878,20 +1878,16 @@ static void save_regs(const struct btf_func_model *m, u8 **prog, int nr_regs,
>  
>  		if (i <= 5) {
>  			/* copy function arguments from regs into stack */
> -			emit_stx(prog, bytes_to_bpf_size(arg_size),
> -				 BPF_REG_FP,
> +			emit_stx(prog, BPF_DW, BPF_REG_FP,
>  				 i == 5 ? X86_REG_R9 : BPF_REG_1 + i,
>  				 -(stack_size - i * 8));

This is ok,

>  		} else {
>  			/* copy function arguments from origin stack frame
>  			 * into current stack frame.
>  			 */
> -			emit_ldx(prog, bytes_to_bpf_size(arg_size),
> -				 BPF_REG_0, BPF_REG_FP,
> +			emit_ldx(prog, BPF_DW, BPF_REG_0, BPF_REG_FP,
>  				 (i - 6) * 8 + 0x18);
> -			emit_stx(prog, bytes_to_bpf_size(arg_size),
> -				 BPF_REG_FP,
> -				 BPF_REG_0,
> +			emit_stx(prog, BPF_DW, BPF_REG_FP, BPF_REG_0,
>  				 -(stack_size - i * 8));

But this is not.
See https://godbolt.org/z/qW17f6cYe
mov dword ptr [rsp], 6

the compiler will store 32-bit only. The upper 32-bit are still garbage.

>  		}
>  
> @@ -1918,7 +1914,7 @@ static void restore_regs(const struct btf_func_model *m, u8 **prog, int nr_regs,
>  			next_same_struct = !next_same_struct;
>  		}
>  
> -		emit_ldx(prog, bytes_to_bpf_size(arg_size),
> +		emit_ldx(prog, BPF_DW,
>  			 i == 5 ? X86_REG_R9 : BPF_REG_1 + i,
>  			 BPF_REG_FP,
>  			 -(stack_size - i * 8));
> @@ -1949,12 +1945,9 @@ static void prepare_origin_stack(const struct btf_func_model *m, u8 **prog,
>  		}
>  
>  		if (i > 5) {
> -			emit_ldx(prog, bytes_to_bpf_size(arg_size),
> -				 BPF_REG_0, BPF_REG_FP,
> +			emit_ldx(prog, BPF_DW, BPF_REG_0, BPF_REG_FP,
>  				 (i - 6) * 8 + 0x18);
> -			emit_stx(prog, bytes_to_bpf_size(arg_size),
> -				 BPF_REG_FP,
> -				 BPF_REG_0,
> +			emit_stx(prog, BPF_DW, BPF_REG_FP, BPF_REG_0,
>  				 -(stack_size - (i - 6) * 8));
>  		}
>  
> -- 
> 2.40.1
> 

