Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3FE6BD221
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 15:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjCPOPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 10:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbjCPOPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 10:15:18 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74021A18A7;
        Thu, 16 Mar 2023 07:14:22 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id x36so1839255ljq.7;
        Thu, 16 Mar 2023 07:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678976056;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XFgru5gPc+aHNBW3vlG+3dqxpYhuOK2D750z3nKQHv0=;
        b=M3ZV2p0n9KQQDzhTmvrnt3gFPi3l8OBk914LMDfpT97OS60zwtV/NxeT/P6NwjJeHW
         SnsJQSmuBGYhWfiguR+TY+KZ4JdrbBNPAf8VNhYR3iRFavcZ7CCM2EYjOmVkUt+p/4GW
         KGwzA7hs+79F1pb1RUkbI6hmR4gcb4DFN1pi08tq3b+OYTqubEp81g86dRK7mPNFXuhf
         2qMQKrj3mmhVuybAuUhxflGUalmDNEyyeja+WpHX5aUGGsjJr5sk5f7ETVSWBSXaEyi8
         zUh8eap4Bw1LGcSfh7LFXF7RdcMvsqm9/1R0thhHwPwIUnFmyxSNrcSiZfNahzCA+bfy
         a+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678976056;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XFgru5gPc+aHNBW3vlG+3dqxpYhuOK2D750z3nKQHv0=;
        b=5i/0dh+q8IoXaZ5A6Wfwpbw9p893dPS1a8PBGVPHwHaZJV37C9b6ISNzFS4R5VDvDN
         usrLWEaxXKwsago3gQe16jUo/0hleMxSVG8qCjNWKK8X5R7HX7ChyT9CxMA3TO4T3Euc
         /Fx3MmRy5U0DokcwYUyxAIZ0TpjCUCgQLBWQPW72jwC6M1lGphg5Z4sBZaB3TeOWZ9gc
         Ej16dBAq/GTExVtHDRC2YcAQH8U4PYJr7oCtf8kinwT16jZYuowzfJI1aoRFnEOIhWYJ
         df4gE/S8Sr4GPxanHamy2RaP4VItTVtv+d8+7GGz+gmSYgL7n9xwihfXp3Js3OndArAm
         lIHw==
X-Gm-Message-State: AO0yUKU4KrMaQMmltWteniga1tTggnWK16/rqo/i+E0eits0dfVncIMT
        N9UHmKChAZsWUrLco4aCuf9mAQ44IwY9CrzP
X-Google-Smtp-Source: AK7set/K58nMRzeH33F8w1ezsZYcCPvJadMxvHARkv0N/NBuqD2vhfVwZKmLJsPBtyYqG5weUVg7Og==
X-Received: by 2002:a2e:90da:0:b0:298:ad8e:e65 with SMTP id o26-20020a2e90da000000b00298ad8e0e65mr2048949ljg.21.1678976055904;
        Thu, 16 Mar 2023 07:14:15 -0700 (PDT)
Received: from [192.168.1.95] (host-176-36-0-241.b024.la.net.ua. [176.36.0.241])
        by smtp.gmail.com with ESMTPSA id s2-20020a05651c048200b00298798f7e38sm1265560ljc.77.2023.03.16.07.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 07:14:14 -0700 (PDT)
Message-ID: <e3a68d87c4f7589ab19fe6ddf6b0341404108386.camel@gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Allow ld_imm64 instruction to point
 to kfunc.
From:   Eduard Zingerman <eddyz87@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Date:   Thu, 16 Mar 2023 16:14:11 +0200
In-Reply-To: <20230315223607.50803-2-alexei.starovoitov@gmail.com>
References: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
         <20230315223607.50803-2-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-03-15 at 15:36 -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
>=20
> Allow ld_imm64 insn with BPF_PSEUDO_BTF_ID to hold the address of kfunc.
> PTR_MEM is already recognized for NULL-ness by is_branch_taken(),
> so unresolved kfuncs will be seen as zero.
> This allows BPF programs to detect at load time whether kfunc is present
> in the kernel with bpf_kfunc_exists() macro.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  kernel/bpf/verifier.c       | 7 +++++--
>  tools/lib/bpf/bpf_helpers.h | 3 +++
>  2 files changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 60793f793ca6..4e49d34d8cd6 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -15955,8 +15955,8 @@ static int check_pseudo_btf_id(struct bpf_verifie=
r_env *env,
>  		goto err_put;
>  	}
> =20
> -	if (!btf_type_is_var(t)) {
> -		verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VAR.\n", id);
> +	if (!btf_type_is_var(t) && !btf_type_is_func(t)) {
> +		verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VAR or KIND_FUNC\=
n", id);
>  		err =3D -EINVAL;
>  		goto err_put;
>  	}
> @@ -15990,6 +15990,9 @@ static int check_pseudo_btf_id(struct bpf_verifie=
r_env *env,
>  		aux->btf_var.reg_type =3D PTR_TO_BTF_ID | MEM_PERCPU;
>  		aux->btf_var.btf =3D btf;
>  		aux->btf_var.btf_id =3D type;
> +	} else if (!btf_type_is_func(t)) {
> +		aux->btf_var.reg_type =3D PTR_TO_MEM | MEM_RDONLY;
> +		aux->btf_var.mem_size =3D 0;

This if statement has the following conditions in master:

	if (percpu) {
    	// ...
	} else if (!btf_type_is_struct(t)) {
    	// ...
	} else {
    	// ...
	}

Conditions `!btf_type_is_func()` and `!btf_type_is_struct()` are
not mutually exclusive, thus adding `if (!btf_type_is_func())`
would match certain conditions that were previously matched by struct
case, wouldn't it? E.g. if type is `BTF_KIND_INT`?

Although, I was not able to trigger it, as it seems that pahole only
encodes per-cpu vars in BTF.

>  	} else if (!btf_type_is_struct(t)) {
>  		const struct btf_type *ret;
>  		const char *tname;
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 7d12d3e620cc..43abe4c29409 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -177,6 +177,9 @@ enum libbpf_tristate {
>  #define __kptr_untrusted __attribute__((btf_type_tag("kptr_untrusted")))
>  #define __kptr __attribute__((btf_type_tag("kptr")))
> =20
> +/* pass function pointer through asm otherwise compiler assumes that any=
 function !=3D 0 */
> +#define bpf_kfunc_exists(fn) ({ void *__p =3D fn; asm ("" : "+r"(__p)); =
__p; })
> +
>  #ifndef ___bpf_concat
>  #define ___bpf_concat(a, b) a ## b
>  #endif

