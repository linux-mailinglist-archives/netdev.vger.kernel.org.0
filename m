Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB18521429
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 13:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241217AbiEJLvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 07:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241241AbiEJLvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 07:51:03 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386EC250E96
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 04:47:05 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id z2so30802288ejj.3
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 04:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=mIOxc2Hr0TwMKC4GyCG7ad4BrNm8On4BnelZfSZoMY8=;
        b=Cq0YVifZjAg/L4a+qlOkNkDWcHo+balp673bgz2Xzq8NYuyUWd4UIlNecRZHOmOZtL
         WITd7u5+Q3fwt/lMny//WQLUUvidBhKfkO/Jl2oNOUFBqFEwcFcey9lf7Y1aelLuySDz
         FKzgrBUKgHOFhkT5RWUHKLhJIy72//L2kETTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=mIOxc2Hr0TwMKC4GyCG7ad4BrNm8On4BnelZfSZoMY8=;
        b=aKTrrj3EpL9hneV6yAliY9wl5QX3U5vCj2IEgCGbszKaI6ssBeB66S78oWH5nsEgre
         gyuGyTDXNR2LQCMEmnHqOiEcyBe+6J/dBo48pS711aj85ShDZS/QFcxWkM+K6O1TFweW
         KMeA9X5U7SNcG1FCsBYv3oPZhTxUS2OqwFJkZr5z5XXuE1q9c10TZfQEOvN/V4aq2vvZ
         yJvoZe04tCU/TjAqpKixYMjkxJY7JgF8AwFsqwPj92J6J7LSviT8sElhW5tkLcZq7ciH
         aBttXtWfpNHR2x1yWHTEZkd5yQMW3liv/ec1QZWZ0rWPymMXr1TNmxqsPUlbOtN2ghi2
         oVuw==
X-Gm-Message-State: AOAM5308TOo0YhWH+kUtY4aRhSQfHCDB3ffg5sFxSe5aT9pH3eyZaJDw
        6EPzaqvbOuL3UfnURyfuZsk++A==
X-Google-Smtp-Source: ABdhPJwH5mhjRvh6ubT75T74jcRYxHqZKy0ovowvflSqOUgy8E1RfmWmmzchzDbkunBXYV3eG+hSPw==
X-Received: by 2002:a17:906:d554:b0:6f5:2242:a499 with SMTP id cr20-20020a170906d55400b006f52242a499mr18119410ejc.488.1652183223425;
        Tue, 10 May 2022 04:47:03 -0700 (PDT)
Received: from cloudflare.com (79.184.139.106.ipv4.supernova.orange.pl. [79.184.139.106])
        by smtp.gmail.com with ESMTPSA id lr9-20020a170906fb8900b006f3ef214dd9sm5997773ejb.63.2022.05.10.04.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 04:47:02 -0700 (PDT)
References: <20220424154028.1698685-1-xukuohai@huawei.com>
 <20220424154028.1698685-5-xukuohai@huawei.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        hpa@zytor.com, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH bpf-next v3 4/7] bpf, arm64: Impelment
 bpf_arch_text_poke() for arm64
Date:   Tue, 10 May 2022 13:45:38 +0200
In-reply-to: <20220424154028.1698685-5-xukuohai@huawei.com>
Message-ID: <87ee11obih.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 11:40 AM -04, Xu Kuohai wrote:
> Impelment bpf_arch_text_poke() for arm64, so bpf trampoline code can use
> it to replace nop with jump, or replace jump with nop.
>
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> ---
>  arch/arm64/net/bpf_jit_comp.c | 63 +++++++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
>
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index 8ab4035dea27..3f9bdfec54c4 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -9,6 +9,7 @@
>  
>  #include <linux/bitfield.h>
>  #include <linux/bpf.h>
> +#include <linux/memory.h>
>  #include <linux/filter.h>
>  #include <linux/printk.h>
>  #include <linux/slab.h>
> @@ -18,6 +19,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/debug-monitors.h>
>  #include <asm/insn.h>
> +#include <asm/patching.h>
>  #include <asm/set_memory.h>
>  
>  #include "bpf_jit.h"
> @@ -1529,3 +1531,64 @@ void bpf_jit_free_exec(void *addr)
>  {
>  	return vfree(addr);
>  }
> +
> +static int gen_branch_or_nop(enum aarch64_insn_branch_type type, void *ip,
> +			     void *addr, u32 *insn)
> +{
> +	if (!addr)
> +		*insn = aarch64_insn_gen_nop();
> +	else
> +		*insn = aarch64_insn_gen_branch_imm((unsigned long)ip,
> +						    (unsigned long)addr,
> +						    type);
> +
> +	return *insn != AARCH64_BREAK_FAULT ? 0 : -EFAULT;
> +}
> +
> +int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
> +		       void *old_addr, void *new_addr)
> +{
> +	int ret;
> +	u32 old_insn;
> +	u32 new_insn;
> +	u32 replaced;
> +	enum aarch64_insn_branch_type branch_type;
> +
> +	if (!is_bpf_text_address((long)ip))
> +		/* Only poking bpf text is supported. Since kernel function
> +		 * entry is set up by ftrace, we reply on ftrace to poke kernel
> +		 * functions. For kernel funcitons, bpf_arch_text_poke() is only

Nit: s/funcitons/functions/

> +		 * called after a failed poke with ftrace. In this case, there
> +		 * is probably something wrong with fentry, so there is nothing
> +		 * we can do here. See register_fentry, unregister_fentry and
> +		 * modify_fentry for details.
> +		 */
> +		return -EINVAL;
> +
> +	if (poke_type == BPF_MOD_CALL)
> +		branch_type = AARCH64_INSN_BRANCH_LINK;
> +	else
> +		branch_type = AARCH64_INSN_BRANCH_NOLINK;
> +
> +	if (gen_branch_or_nop(branch_type, ip, old_addr, &old_insn) < 0)
> +		return -EFAULT;
> +
> +	if (gen_branch_or_nop(branch_type, ip, new_addr, &new_insn) < 0)
> +		return -EFAULT;
> +
> +	mutex_lock(&text_mutex);
> +	if (aarch64_insn_read(ip, &replaced)) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (replaced != old_insn) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	ret = aarch64_insn_patch_text_nosync((void *)ip, new_insn);

Nit: No need for the explicit cast to void *. Type already matches.

> +out:
> +	mutex_unlock(&text_mutex);
> +	return ret;
> +}

