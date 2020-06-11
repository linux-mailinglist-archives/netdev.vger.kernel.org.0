Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0531F7012
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgFKW3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbgFKW3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 18:29:22 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDCCC03E96F;
        Thu, 11 Jun 2020 15:29:22 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id e125so4420125lfd.1;
        Thu, 11 Jun 2020 15:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IFOSCs4N1gx4htUBPn4BwNPKbv+NyvVgIbcUCgIZdt0=;
        b=i7bEQ7mFZC0I8baSofzmWtX4uOxUJRPhD6TONksY9W9knplKvcI+UsQcZSkCnyvU9Y
         OPh8bwJhKZmbq7z27QDWRsuR6ROPPqkijOgPc1m97ue3VHeV7Un5MqOAZGiltUpOZcjW
         nvCAXIVWo7pRvDYUxKDaym+AHWLUSTqZv2DFvYtoCcrEZHi5jVPpdLUBn6R92jLMef+/
         mNUQtl2CV1gwGxLI9mvY42pSnXtRr7hjETjd0rToxmORvRDk4sMH34te+nBLX9mZp7c5
         SZis7sqMtAETEK09UWSJsdA3Du5NHEJjX4ccWwRlXgqZ3mOKTPvcShgiKXbFKlUxb4DV
         b/6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IFOSCs4N1gx4htUBPn4BwNPKbv+NyvVgIbcUCgIZdt0=;
        b=CVa64hkxuEJl5yLbSMjANmWHP2ZFpionZ5yzI+dJqkB8gaocGa0SzYcAVwDJ2Ibtrj
         0j7BJZ2rQIDUstJgL6JOyFM2CdkMLFvqI2ABINNUaTlV+wTBoJ2VG8lcPH+ABxyz1xON
         LhUqetj0BI6+Zw6qK+Z7K5eg+Sz8yrjaOh3RHM+Bhz2Wzxm46iDHHd4l4/lSk17BNR7N
         juW3RzJS1Ao3c6e9hm3Xt7E3H4rZRUVtXltxRDVT39Ti7dUqVxdnByZo2j0/rQPgkyRt
         V7STQ0pVV26JLCzeax7GxeMHZo02+/T0pmh8pAww24NII3g6eBu0S9VRlYlwTftbNcol
         RVpw==
X-Gm-Message-State: AOAM531nXEInz9S0/BlapGHtQ7sKAM8Zd+lSsGtFtFUyv36Ml+bKnRnZ
        AbDYI9CkKMGnLtsqX0m6+oC29mNnkpJ0+qvj+70=
X-Google-Smtp-Source: ABdhPJx0AvEq5U4G3FHXcurxNo2IwQAhcgc9LLtnDiDUAmLwy5jO6tJRQR64GaXhvXo0pUDizvjxjaHWWBEpobFAbc0=
X-Received: by 2002:a19:103:: with SMTP id 3mr5123570lfb.196.1591914560535;
 Thu, 11 Jun 2020 15:29:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200611222340.24081-1-alexei.starovoitov@gmail.com> <20200611222340.24081-2-alexei.starovoitov@gmail.com>
In-Reply-To: <20200611222340.24081-2-alexei.starovoitov@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 11 Jun 2020 15:29:09 -0700
Message-ID: <CAADnVQ+Ed86oOZPA1rOn_COKPpH1917Q6QUtETkciC8L8+u22A@mail.gmail.com>
Subject: Re: [PATCH RFC v3 bpf-next 1/4] bpf: Introduce sleepable BPF programs
To:     "David S. Miller" <davem@davemloft.net>,
        Paul McKenney <paulmckrcu@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 3:23 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
>  /* dummy _ops. The verifier will operate on target program's ops. */
>  const struct bpf_verifier_ops bpf_extension_verifier_ops = {
> @@ -205,14 +206,12 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
>             tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs)
>                 flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
>
> -       /* Though the second half of trampoline page is unused a task could be
> -        * preempted in the middle of the first half of trampoline and two
> -        * updates to trampoline would change the code from underneath the
> -        * preempted task. Hence wait for tasks to voluntarily schedule or go
> -        * to userspace.
> +       /* the same trampoline can hold both sleepable and non-sleepable progs.
> +        * synchronize_rcu_tasks_trace() is needed to make sure all sleepable
> +        * programs finish executing. It also ensures that the rest of
> +        * generated tramopline assembly finishes before updating trampoline.
>          */
> -
> -       synchronize_rcu_tasks();
> +       synchronize_rcu_tasks_trace();

Hi Paul,

I've been looking at rcu_trace implementation and I think above change
is correct.
Could you please double check my understanding?

Also see benchmarking numbers in the cover letter :)

>         err = arch_prepare_bpf_trampoline(new_image, new_image + PAGE_SIZE / 2,
>                                           &tr->func.model, flags, tprogs,
> @@ -344,7 +343,14 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
>         if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
>                 goto out;
>         bpf_image_ksym_del(&tr->ksym);
> -       /* wait for tasks to get out of trampoline before freeing it */
> +       /* This code will be executed when all bpf progs (both sleepable and
> +        * non-sleepable) went through
> +        * bpf_prog_put()->call_rcu[_tasks_trace]()->bpf_prog_free_deferred().
> +        * Hence no need for another synchronize_rcu_tasks_trace() here,
> +        * but synchronize_rcu_tasks() is still needed, since trampoline
> +        * may not have had any sleepable programs and we need to wait
> +        * for tasks to get out of trampoline code before freeing it.
> +        */
>         synchronize_rcu_tasks();
>         bpf_jit_free_exec(tr->image);
>         hlist_del(&tr->hlist);
> @@ -394,6 +400,21 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
>         rcu_read_unlock();
>  }
>
> +/* when rcu_read_lock_trace is held it means that some sleepable bpf program is
> + * running. Those programs can use bpf arrays and preallocated hash maps. These
> + * map types are waiting on programs to complete via
> + * synchronize_rcu_tasks_trace();
> + */
> +void notrace __bpf_prog_enter_sleepable(void)
> +{
> +       rcu_read_lock_trace();
> +}
> +
> +void notrace __bpf_prog_exit_sleepable(void)
> +{
> +       rcu_read_unlock_trace();
> +}
> +
