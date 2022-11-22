Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8E4633E0B
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbiKVNsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiKVNsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:48:13 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171CB5801F;
        Tue, 22 Nov 2022 05:48:12 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z18so20679245edb.9;
        Tue, 22 Nov 2022 05:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gFTU+Fx2dMdGbkWxtpQ34MMYPindEk62yGei1gUT+Zk=;
        b=E4RMTH853dz0Tye1ZcgFRagMcChD0SCWSg5Eudbl4gmsjXGZZtqZHWz9BWZjjqYDJU
         Jp83NumjGXOawKibk24psIn4ndfDO+kn0AnfGAny2yZZRBaENEUkuxlQs+nKwTin1Yvw
         OfqMBz7CglTxxXUVRnSDEnXEU+CozbU/dNwMVfB9IH5d9T6fuweYwj8bGFWn4XEdf7Hb
         2TszkEeerHWlvGaDudgHUkR/gsMzYHNItEskq2FzYd8BAlPSSdOSAoZzGFyFSp2gfXmZ
         +kQbQq8ZohAlPu1VoHzfqW/etuUTtNUW48kmS7q/j0ZasH3mEQdcBE27dIS2rzWU+AJM
         EAPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gFTU+Fx2dMdGbkWxtpQ34MMYPindEk62yGei1gUT+Zk=;
        b=1P3PWAZmxCLmCBRaYuz0A8deWdcpI/4o80+DeYdORq+9ObskHABoupZxd93SlbhKWr
         BlOiayr0TRF+qh10j923YPBK6sJVZQEqjlvmprCP3r8YHBfPLFe543nFoFiZfbzyLRzB
         1cKUc3gFN5yKbKE8UGQa9d3f84kwVk4q2ZcQR5N+ihJh0+RUFpoFM9Wi8OUae7Ztjc+6
         EH3DUxOhQ8qSNXLWSPv9vgoROjmNWdHoCmn2IJCyqlRDvkFaHIFS32ZezSCjS+OoHBpZ
         VWOEF/e7bJ8H8+wqAVyiH2xzns2sZKL0DYjFk3rZdzgtDqFTS/5T/waycVsFqC+LPxCc
         DeYA==
X-Gm-Message-State: ANoB5plZjQ12K4R9lyruVx5HNQjP7tYacdfSzHDcBfPtBWs0gpv7Bykg
        fDydnFLWeAfQomRqdjRnoxk=
X-Google-Smtp-Source: AA0mqf7Q5cH/cuUJFJXJBFxknUJ2e9+YpSp0dMjvYnLf1Mk6pu3Rmna/5STT8ZV2GgmZ78ebbbGLFg==
X-Received: by 2002:a05:6402:3785:b0:461:e598:e0bb with SMTP id et5-20020a056402378500b00461e598e0bbmr21422348edb.21.1669124890435;
        Tue, 22 Nov 2022 05:48:10 -0800 (PST)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id la1-20020a170907780100b00787f91a6b16sm6048721ejc.26.2022.11.22.05.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 05:48:09 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 22 Nov 2022 14:48:07 +0100
To:     Chen Hu <hu1.chen@intel.com>
Cc:     jpoimboe@kernel.org, memxor@gmail.com, bpf@vger.kernel.org,
        Pengfei Xu <pengfei.xu@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH bpf v2] selftests/bpf: Fix "missing ENDBR" BUG for
 destructor kfunc
Message-ID: <Y3zTF0CjQFt/dR2M@krava>
References: <20221122073244.21279-1-hu1.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122073244.21279-1-hu1.chen@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 11:32:43PM -0800, Chen Hu wrote:
> With CONFIG_X86_KERNEL_IBT enabled, the test_verifier triggers the
> following BUG:
> 
>   traps: Missing ENDBR: bpf_kfunc_call_test_release+0x0/0x30
>   ------------[ cut here ]------------
>   kernel BUG at arch/x86/kernel/traps.c:254!
>   invalid opcode: 0000 [#1] PREEMPT SMP
>   <TASK>
>    asm_exc_control_protection+0x26/0x50
>   RIP: 0010:bpf_kfunc_call_test_release+0x0/0x30
>   Code: 00 48 c7 c7 18 f2 e1 b4 e8 0d ca 8c ff 48 c7 c0 00 f2 e1 b4 c3
> 	0f 1f 44 00 00 66 0f 1f 00 0f 1f 44 00 00 0f 0b 31 c0 c3 66 90
>        <66> 0f 1f 00 0f 1f 44 00 00 48 85 ff 74 13 4c 8d 47 18 b8 ff ff ff
>    bpf_map_free_kptrs+0x2e/0x70
>    array_map_free+0x57/0x140
>    process_one_work+0x194/0x3a0
>    worker_thread+0x54/0x3a0
>    ? rescuer_thread+0x390/0x390
>    kthread+0xe9/0x110
>    ? kthread_complete_and_exit+0x20/0x20
> 
> This is because there are no compile-time references to the destructor
> kfuncs, bpf_kfunc_call_test_release() for example. So objtool marked
> them sealable and ENDBR in the functions were sealed (converted to NOP)
> by apply_ibt_endbr().
> 
> This fix creates dummy compile-time references to destructor kfuncs so
> ENDBR stay there.
> 
> Fixes: 05a945deefaa ("selftests/bpf: Add verifier tests for kptr")
> Signed-off-by: Chen Hu <hu1.chen@intel.com>
> Tested-by: Pengfei Xu <pengfei.xu@intel.com>
> ---
> v2:
> - Use generic macro name and place the macro after function body as
> - suggested by Jiri Olsa
> 
> v1: https://lore.kernel.org/all/20221121085113.611504-1-hu1.chen@intel.com/
> 
>  include/linux/btf_ids.h | 7 +++++++
>  net/bpf/test_run.c      | 4 ++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> index 2aea877d644f..db02691b506d 100644
> --- a/include/linux/btf_ids.h
> +++ b/include/linux/btf_ids.h
> @@ -266,4 +266,11 @@ MAX_BTF_TRACING_TYPE,
>  
>  extern u32 btf_tracing_ids[];
>  
> +#if defined(CONFIG_X86_KERNEL_IBT) && !defined(__DISABLE_EXPORTS)
> +#define FUNC_IBT_NOSEAL(name)					\
> +	asm(IBT_NOSEAL(#name));
> +#else
> +#define FUNC_IBT_NOSEAL(name)
> +#endif /* CONFIG_X86_KERNEL_IBT */

hum, IBT_NOSEAL is x86 specific, so this will probably fail build
on other archs.. I think we could ifdef it with CONFIG_X86, but
it should go to some IBT related header? surely not to btf_ids.h

cc-ing Peter and Josh

thanks,
jirka


> +
>  #endif
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 13d578ce2a09..07263b7cc12d 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -597,10 +597,14 @@ noinline void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p)
>  	refcount_dec(&p->cnt);
>  }
>  
> +FUNC_IBT_NOSEAL(bpf_kfunc_call_test_release)
> +
>  noinline void bpf_kfunc_call_memb_release(struct prog_test_member *p)
>  {
>  }
>  
> +FUNC_IBT_NOSEAL(bpf_kfunc_call_memb_release)
> +
>  noinline void bpf_kfunc_call_memb1_release(struct prog_test_member1 *p)
>  {
>  	WARN_ON_ONCE(1);
> -- 
> 2.34.1
> 
