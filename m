Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33BC20BA1C
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgFZURy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFZURx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:17:53 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C83C03E979;
        Fri, 26 Jun 2020 13:17:53 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id x62so8451977qtd.3;
        Fri, 26 Jun 2020 13:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QIwB+ahDHPjVVdK6sMA4E03ym0nLZs4H6OPzI5/Dx1U=;
        b=sRlyoOnVvort/pt7VBpA2D1hOKmlklptjK0SxmcfqR4jzVT9rw3cvsoVXMqciTvt9b
         T3jqmVTOhFEflEv7YF+eVwMRHzh2xdS/jzYgdfq12PM/qpSCPoKFRAX4HY4DGYWoI/ML
         znmpMIMaX/TzwVPWrOWPae+lnHPCLktioVsUNhnbqFbIi10xRXCLAWE/rCVCuAW+gYKw
         8rZPkt7vugAQ9y4VtGBcaxVvAF09XYZuYl5i6iYjBfy7IERYELNBKh24x3jXU9DAcT62
         kb2dJG61WkvOCcIx9r8Czhb5RKXsPTMbanp89vRpOJTjZHnq0LXUudBbJB7zsZ5IR8AR
         WVDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QIwB+ahDHPjVVdK6sMA4E03ym0nLZs4H6OPzI5/Dx1U=;
        b=JUN8pGbLWGxLmp1J6TeIXAeVNBbCJZ/VOQ2jnuU47jVNOm+kK/BaowRwetaSaqWpph
         qEZ03wMZyp4Mn4EoZU2PyZPlXDtVoU3QDlI3cablFKOjf66ULXx0fVlrl5u73sBgEjRN
         lSifbo0jZwK3GvUiF95rZ4kEqmv6qhE3j8Bl6Z17H0aIK8wkygY7rtAJZsQjDNsGkuEE
         akLP6eCqqA9fshu6CRtpGtHDWHMBm+H75uOJXuT/JPXdlJupe2WIVAxWbFzpQin5AC/k
         ZpZ9zTNJKoE0EkwZnusVzRFnaicustkDprXOwtM5cfW2gOzGWiEp2x1yp8nScJtwuepp
         mE4w==
X-Gm-Message-State: AOAM530Ac3aCF55x4QkqsKhE+8vHp4WAAvl3qekUr3/NAh2gwXJHxDdl
        hfTz4ptX1S/t/q+U9YZ0ayrd7eNGL+CuE8F52BE=
X-Google-Smtp-Source: ABdhPJy+ZilXtLIKhqUKYquUFL7S+eLn24dIURHiTUImCVw83PYwVVoAtdsuv2CE9T6Ho5iygREKXF9VPJYgFtXnYKA=
X-Received: by 2002:ac8:4714:: with SMTP id f20mr4578814qtp.141.1593202672978;
 Fri, 26 Jun 2020 13:17:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200626001332.1554603-1-songliubraving@fb.com> <20200626001332.1554603-3-songliubraving@fb.com>
In-Reply-To: <20200626001332.1554603-3-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 13:17:41 -0700
Message-ID: <CAEf4BzZ6-s-vqp+bLiCAVgS2kmp09a1WdaSvaL_jJySx7s7inA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/4] bpf: introduce helper bpf_get_task_stak()
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 5:14 PM Song Liu <songliubraving@fb.com> wrote:
>
> Introduce helper bpf_get_task_stack(), which dumps stack trace of given
> task. This is different to bpf_get_stack(), which gets stack track of
> current task. One potential use case of bpf_get_task_stack() is to call
> it from bpf_iter__task and dump all /proc/<pid>/stack to a seq_file.
>
> bpf_get_task_stack() uses stack_trace_save_tsk() instead of
> get_perf_callchain() for kernel stack. The benefit of this choice is that
> stack_trace_save_tsk() doesn't require changes in arch/. The downside of
> using stack_trace_save_tsk() is that stack_trace_save_tsk() dumps the
> stack trace to unsigned long array. For 32-bit systems, we need to
> translate it to u64 array.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

Looks great, I just think that there are cases where user doesn't
necessarily has valid task_struct pointer, just pid, so would be nice
to not artificially restrict such cases by having extra helper.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       | 35 ++++++++++++++-
>  kernel/bpf/stackmap.c          | 79 ++++++++++++++++++++++++++++++++--
>  kernel/trace/bpf_trace.c       |  2 +
>  scripts/bpf_helpers_doc.py     |  2 +
>  tools/include/uapi/linux/bpf.h | 35 ++++++++++++++-
>  6 files changed, 149 insertions(+), 5 deletions(-)
>

[...]

> +       /* stack_trace_save_tsk() works on unsigned long array, while
> +        * perf_callchain_entry uses u64 array. For 32-bit systems, it is
> +        * necessary to fix this mismatch.
> +        */
> +       if (__BITS_PER_LONG != 64) {
> +               unsigned long *from = (unsigned long *) entry->ip;
> +               u64 *to = entry->ip;
> +               int i;
> +
> +               /* copy data from the end to avoid using extra buffer */
> +               for (i = entry->nr - 1; i >= (int)init_nr; i--)
> +                       to[i] = (u64)(from[i]);

doing this forward would be just fine as well, no? First iteration
will cast and overwrite low 32-bits, all the subsequent iterations
won't even overlap.

> +       }
> +
> +exit_put:
> +       put_callchain_entry(rctx);
> +
> +       return entry;
> +}
> +

[...]

> +BPF_CALL_4(bpf_get_task_stack, struct task_struct *, task, void *, buf,
> +          u32, size, u64, flags)
> +{
> +       struct pt_regs *regs = task_pt_regs(task);
> +
> +       return __bpf_get_stack(regs, task, buf, size, flags);
> +}


So this takes advantage of BTF and having a direct task_struct
pointer. But for kprobes/tracepoint I think it would also be extremely
helpful to be able to request stack trace by PID. How about one more
helper which will wrap this one with get/put task by PID, e.g.,
bpf_get_pid_stack(int pid, void *buf, u32 size, u64 flags)? Would that
be a problem?

> +
> +static int bpf_get_task_stack_btf_ids[5];
> +const struct bpf_func_proto bpf_get_task_stack_proto = {
> +       .func           = bpf_get_task_stack,
> +       .gpl_only       = false,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_BTF_ID,
> +       .arg2_type      = ARG_PTR_TO_UNINIT_MEM,
> +       .arg3_type      = ARG_CONST_SIZE_OR_ZERO,
> +       .arg4_type      = ARG_ANYTHING,
> +       .btf_id         = bpf_get_task_stack_btf_ids,
> +};
> +

[...]
