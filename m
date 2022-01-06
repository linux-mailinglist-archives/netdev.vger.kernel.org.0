Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7BB485FDD
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 05:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbiAFEbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 23:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiAFEbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 23:31:00 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AC4C061245;
        Wed,  5 Jan 2022 20:31:00 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id d14so1200077ila.1;
        Wed, 05 Jan 2022 20:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fz3RCTlY0w6FHN7nD7d9m1WKlBVUFVueBabV5uh2JBE=;
        b=PJY2LB6s8pSjMM+o2yuIZLBMaKAQkAzYWxW/0KZhDFf8L3eDuhvXXuJg2rtDhtfCMt
         WY0UJkk7s2GISbe3D8gmO8+wZnj2DjR0rNyoN2wjIUYeIsEC6aWxZfbSN59b4djDCJ4n
         Sa2bWdlo/lyI0S4/8/x1qD0xys+BJkQPHaOSSD0bW7dkr32bAqehGS77wVxcMsiLfX8y
         VHY1/GKqEhLJs1jV1Sk5UqllKvgYMaabRP1G0rkxINt6yic3mRAYLnMneE7+DuXTZuGg
         0oCA9I2CKPG8d9J53CAcpMIHwyuy0eNQUAK/GBvLmzSe/N8lOUDbY0DJyEa/XlSuuWDI
         91Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fz3RCTlY0w6FHN7nD7d9m1WKlBVUFVueBabV5uh2JBE=;
        b=nm+X/64xHXHlx/zE8iCd1JO5et5djHj0O6g0sLGk3IcHiblYiIvcdPAuI1pra/OP2A
         kPwqmMy0RB2wB9wsGcmID0wTHCnkt39T9tHLUqKVxVJs1AwzPnXlvQVAGK/fUBdbUNwl
         DMba1/lCmCkL3Ere7otKQdCCJRbSm3qh+UiRVJI6Hd+r19lz+LMQ/lVBtYPCPjm/WIar
         /ViJLx3uvb2YqYxupoFx7EEAc29rG6mkitcw4nwN30mIwBrQ9IlfM5G9GURn56JQ5r7I
         sUGYfbkBU+wJHQnUzJUgCLWAqwUA5WW9+0qiIOxt4qmy2huZmJbjuoHDZ+zos1k/nPTa
         TZxA==
X-Gm-Message-State: AOAM533uhiq9X03N3O2Vexh29GMST0dRNUZ5P1WJTdX5/PdB7Q5oucI/
        zTiycfTZLEpGu5fpeSWJe3K1XGayjdE7WgrrJ72QHms+
X-Google-Smtp-Source: ABdhPJyEq17m+X99bIG8kSaAMx7SaoU5k6DPDSJ+9JUDJn3wXjHnG0io/qgrhfVeYI82NwboUrwn2Scd/fA+JVkLlGk=
X-Received: by 2002:a05:6e02:190e:: with SMTP id w14mr27525268ilu.98.1641443459334;
 Wed, 05 Jan 2022 20:30:59 -0800 (PST)
MIME-Version: 1.0
References: <20220104080943.113249-1-jolsa@kernel.org> <20220104080943.113249-3-jolsa@kernel.org>
In-Reply-To: <20220104080943.113249-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Jan 2022 20:30:48 -0800
Message-ID: <CAEf4BzYMF=zNNF-T3fmpXWx3ozek2nb3ektteBwVE=sjw8BE4g@mail.gmail.com>
Subject: Re: [PATCH 02/13] kprobe: Keep traced function address
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 12:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> The bpf_get_func_ip_kprobe helper should return traced function
> address, but it's doing so only for kprobes that are placed on
> the function entry.
>
> If kprobe is placed within the function, bpf_get_func_ip_kprobe
> returns that address instead of function entry.
>
> Storing the function entry directly in kprobe object, so it could
> be used in bpf_get_func_ip_kprobe helper.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/kprobes.h                              |  3 +++
>  kernel/kprobes.c                                     | 12 ++++++++++++
>  kernel/trace/bpf_trace.c                             |  2 +-
>  tools/testing/selftests/bpf/progs/get_func_ip_test.c |  4 ++--
>  4 files changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index 8c8f7a4d93af..a204df4fef96 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -74,6 +74,9 @@ struct kprobe {
>         /* Offset into the symbol */
>         unsigned int offset;
>
> +       /* traced function address */
> +       unsigned long func_addr;
> +

keep in mind that we'll also need (maybe in a follow up series) to
store bpf_cookie somewhere close to this func_addr as well. Just
mentioning to keep in mind as you decide with Masami where to put it.


>         /* Called before addr is executed. */
>         kprobe_pre_handler_t pre_handler;
>
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index d20ae8232835..c4060a8da050 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1310,6 +1310,7 @@ static void init_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
>         copy_kprobe(p, ap);
>         flush_insn_slot(ap);
>         ap->addr = p->addr;
> +       ap->func_addr = p->func_addr;
>         ap->flags = p->flags & ~KPROBE_FLAG_OPTIMIZED;
>         ap->pre_handler = aggr_pre_handler;
>         /* We don't care the kprobe which has gone. */
> @@ -1588,6 +1589,16 @@ static int check_kprobe_address_safe(struct kprobe *p,
>         return ret;
>  }
>
> +static unsigned long resolve_func_addr(kprobe_opcode_t *addr)
> +{
> +       char str[KSYM_SYMBOL_LEN];
> +       unsigned long offset;
> +
> +       if (kallsyms_lookup((unsigned long) addr, NULL, &offset, NULL, str))
> +               return (unsigned long) addr - offset;
> +       return 0;
> +}
> +
>  int register_kprobe(struct kprobe *p)
>  {
>         int ret;
> @@ -1600,6 +1611,7 @@ int register_kprobe(struct kprobe *p)
>         if (IS_ERR(addr))
>                 return PTR_ERR(addr);
>         p->addr = addr;
> +       p->func_addr = resolve_func_addr(addr);
>
>         ret = warn_kprobe_rereg(p);
>         if (ret)
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 21aa30644219..25631253084a 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1026,7 +1026,7 @@ BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
>  {
>         struct kprobe *kp = kprobe_running();
>
> -       return kp ? (uintptr_t)kp->addr : 0;
> +       return kp ? (uintptr_t)kp->func_addr : 0;
>  }
>
>  static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
> diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> index a587aeca5ae0..e988aefa567e 100644
> --- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> +++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> @@ -69,7 +69,7 @@ int test6(struct pt_regs *ctx)
>  {
>         __u64 addr = bpf_get_func_ip(ctx);
>
> -       test6_result = (const void *) addr == &bpf_fentry_test6 + 5;
> +       test6_result = (const void *) addr == &bpf_fentry_test6;
>         return 0;
>  }
>
> @@ -79,6 +79,6 @@ int test7(struct pt_regs *ctx)
>  {
>         __u64 addr = bpf_get_func_ip(ctx);
>
> -       test7_result = (const void *) addr == &bpf_fentry_test7 + 5;
> +       test7_result = (const void *) addr == &bpf_fentry_test7;

we can treat this as a bug fix for bpf_get_func_ip() for kprobes,
right? I think "Fixes: " tag is in order then.


>         return 0;
>  }

> --
> 2.33.1
>
