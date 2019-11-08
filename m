Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 078C8F420C
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 09:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfKHIYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 03:24:10 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33523 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfKHIYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 03:24:10 -0500
Received: by mail-qk1-f195.google.com with SMTP id 71so4571482qkl.0;
        Fri, 08 Nov 2019 00:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ylZtXsGX91kH7Dqbo0BnsKW8PhIfg/TWG7A6n5OwFqM=;
        b=suDoiDGtFRdnRgyAh/t2snA/V4IaKsdK9gjp2IYkK6RdZYRq7p7GeC7/VSkxCHth1L
         e053OMjeYxtEYfIhQadHrB0dKpOdroWDGSVedIzrA4zjnSOvbnXJSxqeueSTlinY7vNY
         YFTeBdpgsk9sUs2a11orRHOr1QOoBRnZe7i1Q2q+in4LKgidIBECyXlK+fYUsEHIHshE
         B9YKWqIMi4KgkdnvlUuFp/D1cAbulwhNNXU1SsGUEERtUUbrTf0WMwBWsqXmpSNRcZkV
         9A0KbwxxggdjlOqusx6eEoS2WkAKAiQPJPqmY/nQPtiHk2nvhnJJzRPoYqthxHW0q3/M
         PVsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ylZtXsGX91kH7Dqbo0BnsKW8PhIfg/TWG7A6n5OwFqM=;
        b=eZGeM9K361/7HO0InSDo5vS2yeniRPcpp0gu5CUP4u2HTN3EoPLNJdyKlU/nEouwQb
         YLD4mE6qVezFF01HHlSQigEH37lagtlvh+pLTj7WhbT9PlPpxYcAkYKQHGjeSWU6QfcE
         CdY3jiZpJUMoJdFSJ9NkUpZ5uLlS2QC5CiCcGFo3Av0LoifTVOPQX+jng97iIoxJgCPb
         drwMYOAmG7dJLmhxYjf0yD5fNAOhpeDf2XTbPf7/OUwBkteoZlgqQw1bJDxk13l9zfGX
         B3/mN6/hIq4iW+rDCNxpF8J2/HQutIb4XtSzPSX2SNlggtq3gxHkKBQYPApWmTbl4pQ0
         wGwA==
X-Gm-Message-State: APjAAAXcPVMJ/aSWY3CuWmUTctegolg1bLv87Ta6eG8P5LG9rBcNdRJM
        0+tSTyqdFQviiKtvUxRNMTXhjolsiEYxWNqreh7vRpAKzXM=
X-Google-Smtp-Source: APXvYqwgai6dS/qQ9Jfq237IatUHX8ugJUUoQGomUBNz9B6ULoOxuaYNJfQEj0oiccfTE8fUKr+t47AYgWw0VBwHflk=
X-Received: by 2002:a37:8b03:: with SMTP id n3mr5235664qkd.493.1573201448644;
 Fri, 08 Nov 2019 00:24:08 -0800 (PST)
MIME-Version: 1.0
References: <20191108064039.2041889-1-ast@kernel.org> <20191108064039.2041889-3-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-3-ast@kernel.org>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 8 Nov 2019 09:23:57 +0100
Message-ID: <CAJ+HfNhOBCamXzMV0XKmVUeDFvdEJXpDHdVCNsdTb6PFRP7Hqg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 02/18] bpf: Add bpf_arch_text_poke() helper
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Nov 2019 at 07:41, Alexei Starovoitov <ast@kernel.org> wrote:
>
> Add bpf_arch_text_poke() helper that is used by BPF trampoline logic to patch
> nops/calls in kernel text into calls into BPF trampoline and to patch
> calls/nops inside BPF programs too.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  arch/x86/net/bpf_jit_comp.c | 51 +++++++++++++++++++++++++++++++++++++
>  include/linux/bpf.h         |  8 ++++++
>  kernel/bpf/core.c           |  6 +++++
>  3 files changed, 65 insertions(+)
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 0399b1f83c23..bb8467fd6715 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -9,9 +9,11 @@
>  #include <linux/filter.h>
>  #include <linux/if_vlan.h>
>  #include <linux/bpf.h>
> +#include <linux/memory.h>
>  #include <asm/extable.h>
>  #include <asm/set_memory.h>
>  #include <asm/nospec-branch.h>
> +#include <asm/text-patching.h>
>
>  static u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
>  {
> @@ -487,6 +489,55 @@ static int emit_call(u8 **pprog, void *func, void *ip)
>         return 0;
>  }
>
> +int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
> +                      void *old_addr, void *new_addr)
> +{
> +       u8 old_insn[X86_CALL_SIZE] = {};
> +       u8 new_insn[X86_CALL_SIZE] = {};
> +       u8 *prog;
> +       int ret;
> +
> +       if (!is_kernel_text((long)ip))
> +               /* BPF trampoline in modules is not supported */
> +               return -EINVAL;
> +
> +       if (old_addr) {
> +               prog = old_insn;
> +               ret = emit_call(&prog, old_addr, (void *)ip);
> +               if (ret)
> +                       return ret;
> +       }
> +       if (new_addr) {
> +               prog = new_insn;
> +               ret = emit_call(&prog, new_addr, (void *)ip);
> +               if (ret)
> +                       return ret;
> +       }
> +       ret = -EBUSY;
> +       mutex_lock(&text_mutex);
> +       switch (t) {
> +       case BPF_MOD_NOP_TO_CALL:
> +               if (memcmp(ip, ideal_nops[NOP_ATOMIC5], X86_CALL_SIZE))
> +                       goto out;
> +               text_poke(ip, new_insn, X86_CALL_SIZE);

I'm probably missing something, but why isn't text_poke_bp() needed here?

> +               break;
> +       case BPF_MOD_CALL_TO_CALL:
> +               if (memcmp(ip, old_insn, X86_CALL_SIZE))
> +                       goto out;
> +               text_poke(ip, new_insn, X86_CALL_SIZE);
> +               break;
> +       case BPF_MOD_CALL_TO_NOP:
> +               if (memcmp(ip, old_insn, X86_CALL_SIZE))
> +                       goto out;
> +               text_poke(ip, ideal_nops[NOP_ATOMIC5], X86_CALL_SIZE);
> +               break;
> +       }
> +       ret = 0;
> +out:
> +       mutex_unlock(&text_mutex);
> +       return ret;
> +}
> +
>  static bool ex_handler_bpf(const struct exception_table_entry *x,
>                            struct pt_regs *regs, int trapnr,
>                            unsigned long error_code, unsigned long fault_addr)
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 7c7f518811a6..8b90db25348a 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1157,4 +1157,12 @@ static inline u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
>  }
>  #endif /* CONFIG_INET */
>
> +enum bpf_text_poke_type {
> +       BPF_MOD_NOP_TO_CALL,
> +       BPF_MOD_CALL_TO_CALL,
> +       BPF_MOD_CALL_TO_NOP,
> +};
> +int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
> +                      void *addr1, void *addr2);
> +
>  #endif /* _LINUX_BPF_H */
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index c1fde0303280..c4bcec1014a9 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2140,6 +2140,12 @@ int __weak skb_copy_bits(const struct sk_buff *skb, int offset, void *to,
>         return -EFAULT;
>  }
>
> +int __weak bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
> +                             void *addr1, void *addr2)
> +{
> +       return -ENOTSUPP;
> +}
> +
>  DEFINE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
>  EXPORT_SYMBOL(bpf_stats_enabled_key);
>
> --
> 2.23.0
>
