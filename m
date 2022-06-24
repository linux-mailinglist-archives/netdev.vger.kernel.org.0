Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4ED55A44C
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 00:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiFXWTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 18:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiFXWTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 18:19:02 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E88585D16;
        Fri, 24 Jun 2022 15:18:58 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id fd6so5300702edb.5;
        Fri, 24 Jun 2022 15:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ulIt/Igd8gDLR6TWT3Hlfca+jdris+ZEDB86QcOsJGw=;
        b=CO8BiD4fs3OYUDtRl7xvny/phW+PwBlQGwIYDps/YPmCV3QOSxe/vbQwAnjHmAxkL4
         VlWUMC9JYKGIgTacugRHWlDpn3QNtHI7cLgXWKdeYhsKIi7YMYOPo2fBwfLzKMxH5WvC
         OKcfMcWTl2077iOMzlXpZrBlfhXuReA+geB5VSA3xcDzIziOtczjTalyolLiqjUZaRbR
         rzlPDQpZF6l5s9uACs0IqQ9mUvuyyJ29J3UYnRjP4liHAl4l85XGibx4W27cqvFbreol
         zSzbQ9suXdgcIqWeKvzNW/Uaye9GJ5xHlrDKYL6HZyIH8M+AM1dFMpSAcWaKClAf/dRF
         XTHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ulIt/Igd8gDLR6TWT3Hlfca+jdris+ZEDB86QcOsJGw=;
        b=bcdrVwNw1u01ZJQSJX/4fi+B4fCen7UpFCku6ndytJju6oftlp0NuZ90iBIYIzI9wO
         Vhw+mpqm7EPE2AEek9LAOH9Zy8Yn8Fh+NKn22oL3C97oP4+LGZtpj5m4j0nNHCC6wAY+
         OgGKOo8xqBFeb97dCReBhOUVhvAaPkgX7L/il8E+Wnns8fmyp3U5kEMXKwVTvpa95VBs
         Zll5l/y11VLqSJUutjHjC6MbpiLgZvyJQQhMtlTfB/JYugfCgLxim3c1Gpzs/nIj6osO
         SFhPwDcNmsw8G1/tmNyCzxPal81OR1XpFlWcfZRub86c4qZDZT3CAr+h3mcWXx5um22B
         L7xA==
X-Gm-Message-State: AJIora+80S2e5a73F40UJPtDfnjtbWjLlwc3YWpa3JNyZ2OocjGpGqql
        pbI0onlGX6wNWfIBFtNdj3KmUY9F6oL1yFXuD98=
X-Google-Smtp-Source: AGRyM1tnJoQudUlMTxFEjBDPNW+JIoG2Yj25BxvcmRcoFLK8C8K5ObZOeaMQ1fWn73jOf8qD+LVl2nMfEIRxZPjGn5M=
X-Received: by 2002:a05:6402:3514:b0:435:f24a:fbad with SMTP id
 b20-20020a056402351400b00435f24afbadmr1530472edd.311.1656109137035; Fri, 24
 Jun 2022 15:18:57 -0700 (PDT)
MIME-Version: 1.0
References: <1656089118-577-1-git-send-email-alan.maguire@oracle.com> <1656089118-577-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1656089118-577-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 24 Jun 2022 15:18:45 -0700
Message-ID: <CAEf4BzaigeecrZi9QSxR5o6afY0GPdF5v7yFjZ_Ft_wikF9rMA@mail.gmail.com>
Subject: Re: [RFC bpf-next 1/2] bpf: add a kallsyms BPF iterator
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, void@manifault.com,
        swboyd@chromium.org, Nick Desaulniers <ndesaulniers@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 9:45 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> add a "kallsyms" iterator which provides access to a "struct kallsym_iter"
> for each symbol.  Intent is to support more flexible symbol parsing
> as discussed in [1].
>
> [1] https://lore.kernel.org/all/YjRPZj6Z8vuLeEZo@krava/
>
> Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  kernel/kallsyms.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 93 insertions(+)
>
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index fbdf8d3..ffaf464 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -30,6 +30,7 @@
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/bsearch.h>
> +#include <linux/btf_ids.h>
>
>  /*
>   * These will be re-linked against their real values
> @@ -799,6 +800,95 @@ static int s_show(struct seq_file *m, void *p)
>         .show = s_show
>  };
>
> +#ifdef CONFIG_BPF_SYSCALL
> +
> +struct bpf_iter__kallsyms {

So I know this is derived from /proc/kallsyms, but for BPF iterators
we have a singular name convention (e.g., iter/task and
iter/task_vma), which makes sense because we call BPF program for each
individual item. So here it seems like "iter/ksym" would make good
sense?

> +       __bpf_md_ptr(struct bpf_iter_meta *, meta);
> +       __bpf_md_ptr(struct kallsym_iter *, kallsym_iter);

nit: can we call this field just "ksym"?

> +};
> +
> +static int s_prog_seq_show(struct seq_file *m, bool in_stop)
> +{
> +       struct bpf_iter__kallsyms ctx;
> +       struct bpf_iter_meta meta;
> +       struct bpf_prog *prog;
> +
> +       meta.seq = m;
> +       prog = bpf_iter_get_info(&meta, in_stop);
> +       if (!prog)
> +               return 0;
> +
> +       ctx.meta = &meta;
> +       ctx.kallsym_iter = m ? m->private : NULL;
> +       return bpf_iter_run_prog(prog, &ctx);
> +}
> +
> +static int bpf_iter_s_seq_show(struct seq_file *m, void *p)

stupid question, but what does "_s_" part stand for? Is it for "sym"?
If yes, maybe then "bpf_iter_ksym_seq_show"?

> +{
> +       return s_prog_seq_show(m, false);
> +}
> +

[...]

> +static struct bpf_iter_reg kallsyms_iter_reg_info = {
> +       .target                 = "kallsyms",
> +       .ctx_arg_info_size      = 1,
> +       .ctx_arg_info           = {
> +               { offsetof(struct bpf_iter__kallsyms, kallsym_iter),
> +                 PTR_TO_BTF_ID_OR_NULL },
> +       },
> +       .seq_info               = &kallsyms_iter_seq_info,
> +};
> +
> +BTF_ID_LIST(btf_kallsym_iter_id)
> +BTF_ID(struct, kallsym_iter)
> +
> +static void __init bpf_kallsyms_iter_register(void)
> +{
> +       kallsyms_iter_reg_info.ctx_arg_info[0].btf_id = *btf_kallsym_iter_id;
> +       if (bpf_iter_reg_target(&kallsyms_iter_reg_info))
> +               pr_warn("Warning: could not register bpf kallsyms iterator\n");
> +}
> +
> +#endif /* CONFIG_PROC_FS */

Is there any reason to depend on CONFIG_PROC_FS for BPF iterator?
Seems like kernel/kallsyms.c itself is only depending on
CONFIG_KALLSYMS? So why adding unnecessary dependency?

> +
> +#endif /* CONFIG_BPF_SYSCALL */
> +
>  static inline int kallsyms_for_perf(void)
>  {
>  #ifdef CONFIG_PERF_EVENTS
> @@ -885,6 +975,9 @@ const char *kdb_walk_kallsyms(loff_t *pos)
>  static int __init kallsyms_init(void)
>  {
>         proc_create("kallsyms", 0444, NULL, &kallsyms_proc_ops);
> +#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
> +       bpf_kallsyms_iter_register();
> +#endif
>         return 0;
>  }
>  device_initcall(kallsyms_init);
> --
> 1.8.3.1
>
