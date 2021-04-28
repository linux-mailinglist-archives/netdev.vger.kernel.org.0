Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E748136DFCE
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 21:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238325AbhD1Tme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 15:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbhD1Tmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 15:42:32 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF5EC061573;
        Wed, 28 Apr 2021 12:41:45 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id g38so75413399ybi.12;
        Wed, 28 Apr 2021 12:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dP37V867+l0+fx9YYXY81zIb0jg1dOgMN32/euUAirQ=;
        b=reHWh8TxLSpb/ZFxBKrmi4kou14LdfyLHm7aBhMhg+g2tpQ9+HjtRlmJr9H6/P2M33
         I3zo+zbpbbNwMRtSVNTI7Pn1HrjmqsNClA/xRzgPUOZKNtEfkaM4vgP2BzLCE7lPkaBJ
         ATRxPtvHMPRO0DALvOeduyVWJrlKPjQ24ZlicaWLa0QPiIfC4cxfCMzbtRAMmPlTCk1u
         3kC9Ohvc8Z+ATeTRAHcoZui4hch0nF5POMWi7lXC9Rk1xPCzorQCMiYILpjkY/pmHjJJ
         oCuK7OukFCmpO32OAfuYMuUPWNkMq8j1LSPhtD1HHqy/k9zryXulWtZ8aef5zaVaEP/x
         pNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dP37V867+l0+fx9YYXY81zIb0jg1dOgMN32/euUAirQ=;
        b=hL1GA7bSNnV/4qfaB3ZlTujkbI+6dkjHExo3hS/r/gG/iUyz1fGFgclPQ9ZhebxZnz
         UAIfGsfoCMM8+Qvcp0tgIO9/ODTs3yNBV1+06+yDQCbqa+6MiNCxGs/0+PDEVn/PnXmL
         36nvuliWDtahaA8itapTK5JTdfjPSYA0nEd3+e2TDrAtyaWZNZ4HtyoldFw9Qi1/1LbX
         woSqTVUN5Mk2HGWD/HF+/6RKNaFjzIKiHIR0/W9/W330aDTUKZEk9YSGhSY2llNdAvND
         CohrXW1MgAX7sXTha2SDUJP/SFlMfom8QF7r90rGDo6iJZ7v137zhtNRJWWik8frXmVR
         A2JQ==
X-Gm-Message-State: AOAM5313D5xHVOk4IgaHVUBnyBV5vwVg/5SvgM/yH9QjGBBad2OsIX8Z
        p4/FQI7zPCkplD+KyjwYV4vS7xM/z8NowzSfj+NGr3OH
X-Google-Smtp-Source: ABdhPJz+m9UEslTAzX8cho5PS0Tkqj4e36n/rDl9Plh88d1/H1iDUrx3jnDQ4qBXHvtIZS+S79boAB0TTg9scPiVhwM=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr42572328ybf.425.1619638904916;
 Wed, 28 Apr 2021 12:41:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210428161802.771519-1-jolsa@kernel.org>
In-Reply-To: <20210428161802.771519-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 28 Apr 2021 12:41:34 -0700
Message-ID: <CAEf4BzY8m5v0LY7eC1p-_xHg8yZms5HCS6D5AyRL7uFZfbKkKw@mail.gmail.com>
Subject: Re: [PATCH] bpf: Add deny list of btf ids check for tracing and ext programs
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 9:19 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The recursion check in __bpf_prog_enter and __bpf_prog_exit
> leaves some (not inlined) functions unprotected:
>
> In __bpf_prog_enter:
>   - migrate_disable is called before prog->active is checked
>
> In __bpf_prog_exit:
>   - migrate_enable,rcu_read_unlock_strict are called after
>     prog->active is decreased
>
> When attaching trampoline to them we get panic like:
>
>   traps: PANIC: double fault, error_code: 0x0
>   double fault: 0000 [#1] SMP PTI
>   RIP: 0010:__bpf_prog_enter+0x4/0x50
>   ...
>   Call Trace:
>    <IRQ>
>    bpf_trampoline_6442466513_0+0x18/0x1000
>    migrate_disable+0x5/0x50
>    __bpf_prog_enter+0x9/0x50
>    bpf_trampoline_6442466513_0+0x18/0x1000
>    migrate_disable+0x5/0x50
>    __bpf_prog_enter+0x9/0x50
>    bpf_trampoline_6442466513_0+0x18/0x1000
>    migrate_disable+0x5/0x50
>    __bpf_prog_enter+0x9/0x50
>    bpf_trampoline_6442466513_0+0x18/0x1000
>    migrate_disable+0x5/0x50
>    ...
>
> Fixing this by adding deny list of btf ids for tracing
> and ext programs and checking btf id during program
> verification. Adding above functions to this list.
>
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/verifier.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 2579f6fbb5c3..4ffd64eaffda 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -13112,6 +13112,17 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
>         return 0;
>  }
>
> +BTF_SET_START(btf_id_deny)
> +BTF_ID_UNUSED
> +#ifdef CONFIG_SMP
> +BTF_ID(func, migrate_disable)
> +BTF_ID(func, migrate_enable)
> +#endif
> +#if !defined CONFIG_PREEMPT_RCU && !defined CONFIG_TINY_RCU
> +BTF_ID(func, rcu_read_unlock_strict)
> +#endif
> +BTF_SET_END(btf_id_deny)
> +
>  static int check_attach_btf_id(struct bpf_verifier_env *env)
>  {
>         struct bpf_prog *prog = env->prog;
> @@ -13171,6 +13182,10 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
>                 ret = bpf_lsm_verify_prog(&env->log, prog);
>                 if (ret < 0)
>                         return ret;
> +       } else if ((prog->type == BPF_PROG_TYPE_TRACING ||
> +                   prog->type == BPF_PROG_TYPE_EXT) &&

BPF_PROG_TYP_EXT can only replace other BPF programs/subprograms, it
can't replace kernel functions, so the deny list shouldn't be checked
for them.

> +                  btf_id_set_contains(&btf_id_deny, btf_id)) {
> +               return -EINVAL;
>         }
>
>         key = bpf_trampoline_compute_key(tgt_prog, prog->aux->attach_btf, btf_id);
> --
> 2.30.2
>
