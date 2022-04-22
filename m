Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4A250B639
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 13:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351594AbiDVLgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 07:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239757AbiDVLgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 07:36:50 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1B7F14
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 04:33:56 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id bv16so10602855wrb.9
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 04:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=uz+KcNIj+v9WSFSUjytskdEFRoZIQjG/EVCHIE7PoXA=;
        b=gzbQuJCj0I2T04uY0UYnVWLijPTDjp9cU8gjljlQbHYCpA8RUc0SI+1iOS8JCVDX30
         wHYpTjb2TVGttz0rLW8wUREcv0cSVao2eWrMuveVbBcuvb69FNpN1EiELHQyz7N6bS5c
         3TUxO7P8UkMUTNvh+TLzQ0YBXD9IfwQPSNMvk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=uz+KcNIj+v9WSFSUjytskdEFRoZIQjG/EVCHIE7PoXA=;
        b=yydS/T0oGiHrmuIfaKYkLfId1mLyMUhocqhz6O868WvVg8iEUjV6yl1apPVxKUhSmE
         JaZOCJ1qO4wB4xwIGh6vBRTbg/Nl/JIhHJlwYCMsAcotNJHXPPHKWS8fNArvwGgXhJ/2
         w5C+7GwUTWFcamo2kYIoj9niuDJJdqhNkbyVvok7lRX/aVXatFY7nWlLcE8bfE4Vrf5M
         S6LFt66CPEJgNFH6PV/IipSRipg+ZxTDmvNbKMRKxPxlizb1Dl1ATamoAoYUAN5Ot8qV
         TgTcl/xk/qFr7j34WuoFjXJK4rMDqeQ0iv6+ANks4YWIioc+zb7n8Xpq+e2MPKSYSmoG
         zwbw==
X-Gm-Message-State: AOAM530uduBSXpC3o3dQPGo1uoiqNe2Fw0oOFt124n5SpY1uYYOZrPNv
        ZwBaAweDR3xxUn5buDa5iQm9iw==
X-Google-Smtp-Source: ABdhPJytQeZpvy34ZOAAMQB7w6jF7X6Nf/OgCkIilBTulJnvg3gtBspcR68ouVwuJUzFMunZvSQqjw==
X-Received: by 2002:a5d:4e08:0:b0:20a:8f9e:beef with SMTP id p8-20020a5d4e08000000b0020a8f9ebeefmr3571401wrt.8.1650627235044;
        Fri, 22 Apr 2022 04:33:55 -0700 (PDT)
Received: from cloudflare.com (79.184.126.143.ipv4.supernova.orange.pl. [79.184.126.143])
        by smtp.gmail.com with ESMTPSA id r25-20020adfa159000000b0020ac9758f17sm1338619wrr.23.2022.04.22.04.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 04:33:54 -0700 (PDT)
References: <20220414162220.1985095-1-xukuohai@huawei.com>
 <20220414162220.1985095-5-xukuohai@huawei.com>
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
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Collingbourne <pcc@google.com>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Delyan Kratunov <delyank@fb.com>, kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next v2 4/6] bpf, arm64: Impelment
 bpf_arch_text_poke() for arm64
Date:   Fri, 22 Apr 2022 12:54:02 +0200
In-reply-to: <20220414162220.1985095-5-xukuohai@huawei.com>
Message-ID: <87levxfj32.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xu,

Thanks for working on this.

We are also looking forward to using fentry hooks on arm64.
In particular, attaching to entry/exit into/from XDP progs.

On Thu, Apr 14, 2022 at 12:22 PM -04, Xu Kuohai wrote:
> Impelment bpf_arch_text_poke() for arm64, so bpf trampoline code can use
> it to replace nop with jump, or replace jump with nop.
>
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> ---
>  arch/arm64/net/bpf_jit_comp.c | 52 +++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
>
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index 8ab4035dea27..1a1c3ea75ee2 100644
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
> @@ -1529,3 +1531,53 @@ void bpf_jit_free_exec(void *addr)
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
> +	if (poke_type == BPF_MOD_CALL)
> +		branch_type = AARCH64_INSN_BRANCH_LINK;

This path, bpf_arch_text_poke(<ip>, BPF_MOD_CALL, ...), is what we hit
when attaching a BPF program entry. It is exercised by selftest #232
xdp_bpf2bpf.

However, with this patchset alone it will not work because we don't
emit, yet, the ftrace patch (MOV X9, LR; NOP) as a part of BPF prog
prologue, like ftrace_init_nop() does. So patching attempt will fail.

I think that is what you mentioned to in your reply to Hou [1]

So my question is - is support for attaching to BPF progs in scope for
this patchset?

If no, then perhaps it would be better for now to fail early with
something like -EOPNOTSUPP when poke_type is BPF_MOD_CALL, rather then
attempt to patch the code.

If you plan to enable it as a part of this patchset, then I've given it
a quick try, and it seems that not a lot is needed get fentry to BPF
attachment to work.

I'm including the diff for my quick and dirty attempt below. With that
patch on top, the xdp_bpf2bpf tests pass:

#232 xdp_bpf2bpf:OK

[1] https://lore.kernel.org/bpf/d8c4f1fb-a020-9457-44e2-dc63982a9213@huawei.com/

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
> +	ret =  aarch64_insn_patch_text_nosync((void *)ip, new_insn);
> +out:
> +	mutex_unlock(&text_mutex);

The body of this critical section is identical as ftrace_modify_code().
Perhaps we could export it and reuse?

> +	return ret;
> +}

---
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 5f6bd755050f..94d8251500ab 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -240,9 +240,9 @@ static bool is_lsi_offset(int offset, int scale)
 /* Tail call offset to jump into */
 #if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) || \
 	IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL)
-#define PROLOGUE_OFFSET 9
+#define PROLOGUE_OFFSET 11
 #else
-#define PROLOGUE_OFFSET 8
+#define PROLOGUE_OFFSET 10
 #endif
 
 static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
@@ -281,6 +281,10 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 	 *
 	 */
 
+	/* Set up ftrace patch (initially in disabled state) */
+	emit(A64_MOV(1, A64_R(9), A64_LR), ctx);
+	emit(A64_NOP, ctx);
+
 	/* Sign lr */
 	if (IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL))
 		emit(A64_PACIASP, ctx);
@@ -1888,10 +1892,16 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
 	u32 replaced;
 	enum aarch64_insn_branch_type branch_type;
 
-	if (poke_type == BPF_MOD_CALL)
+	if (poke_type == BPF_MOD_CALL) {
 		branch_type = AARCH64_INSN_BRANCH_LINK;
-	else
+		/*
+		 * Adjust addr to point at the BL in the callsite.
+		 * See ftrace_init_nop() for the callsite sequence.
+		 */
+		ip = (void *)((unsigned long)ip + AARCH64_INSN_SIZE);
+	} else {
 		branch_type = AARCH64_INSN_BRANCH_NOLINK;
+	}
 
 	if (gen_branch_or_nop(branch_type, ip, old_addr, &old_insn) < 0)
 		return -EFAULT;
