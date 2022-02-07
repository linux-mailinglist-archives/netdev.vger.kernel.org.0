Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C924AC91F
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 20:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238334AbiBGTDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 14:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbiBGS7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:59:31 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABF2C0401E2;
        Mon,  7 Feb 2022 10:59:30 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id m185so9836199iof.10;
        Mon, 07 Feb 2022 10:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p5GJUhqoBZKVBO/8R0d/5vUo6i8ZBWVBkYqNLYhElO8=;
        b=ChvNyJebeZEzCBm65NSTxDwcm0+EoeNZz6fnhElk4Q1fex4qX0HSUngNK8fXpIW7cT
         nfJYNhBXgUzj1QkXSvQimCYQCP0zGkhhhkXRhRd5idBnx8rF18VZBtQFped0iSMPseXb
         PqdcH2bxvDbWMzsqY1b+GqogMpHKEyW7H+5hYklzo6nyyEby6z6o5H/9BGtVmmN4Avyt
         404hInAjcVVqnpbJR065oYJIML9+F8KoBPSru7wm4p1tMAV6ztfs08dzzCKjjeUdi9ld
         bnEGsMpJXCk4r2BsZ6r+qcmmGZTxs8XZGeNtWFE7Daux86vbTcly6OjAHzbKWYZ6H6rH
         Mfbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p5GJUhqoBZKVBO/8R0d/5vUo6i8ZBWVBkYqNLYhElO8=;
        b=F0sRPcNtwYSjcRt3wFwocrvdd06wobZbpj+WeBFGFLBQ9Vx4Nrlb+f1yx+coFUD3Wt
         MEQNkM0Io6PXKxx3YDkQNyuX63vyEiDyl3UkddwPt2XJKPrcQg/tv22g5B36Z/4VXp2M
         3YnMRL8aZyQKYNsJCr8eO5yTE1lhLtC74zPMEMfEPjy8ITVuD/OMolckOB5fbQe/Aqdl
         7/lhjGkHpWdn81FCHO+c56xZG8jqi09VjaLIdOKMGa9z9KLU/1M7xrH9CnnXPltVpqJq
         6D/VyHOX2oT4XGbKWY2ybHtuV5M8yb3yPR257tMdJlxiGx0lICQlcwWeHz7MbI+Rcbz/
         uaVA==
X-Gm-Message-State: AOAM532uWTUnhSMzGIIQmp1Gh9zvu0TztLC9aCo6bGbAgTJbJ/5GMEtb
        TpSBhoA/0l+eyHsxNLwHdkOx/4bPOclMxU4ymOeyHjOf
X-Google-Smtp-Source: ABdhPJzLSAmF/W74GX1w5Qqm7ogNnubYQHxdqFdwzd47NMaCrDI/EKitqlbOHw1LnJg1/ETnys+vMb3jPwQ1jEBCrvo=
X-Received: by 2002:a5e:a806:: with SMTP id c6mr449118ioa.112.1644260369518;
 Mon, 07 Feb 2022 10:59:29 -0800 (PST)
MIME-Version: 1.0
References: <20220202135333.190761-1-jolsa@kernel.org> <20220202135333.190761-3-jolsa@kernel.org>
In-Reply-To: <20220202135333.190761-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Feb 2022 10:59:18 -0800
Message-ID: <CAEf4Bzbrj01RJq7ArAo-kX-+8rPx9j5OH1OvGHxVJxiq8rn3FA@mail.gmail.com>
Subject: Re: [PATCH 2/8] bpf: Add bpf_get_func_ip kprobe helper for fprobe link
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
        Jiri Olsa <olsajiri@gmail.com>
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

On Wed, Feb 2, 2022 at 5:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Adding support to call get_func_ip_fprobe helper from kprobe
> programs attached by fprobe link.
>
> Also adding support to inline it, because it's single load
> instruction.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/verifier.c    | 19 ++++++++++++++++++-
>  kernel/trace/bpf_trace.c | 16 +++++++++++++++-
>  2 files changed, 33 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 1ae41d0cf96c..a745ded00635 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -13625,7 +13625,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
>                         continue;
>                 }
>
> -               /* Implement bpf_get_func_ip inline. */
> +               /* Implement tracing bpf_get_func_ip inline. */
>                 if (prog_type == BPF_PROG_TYPE_TRACING &&
>                     insn->imm == BPF_FUNC_get_func_ip) {
>                         /* Load IP address from ctx - 16 */
> @@ -13640,6 +13640,23 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
>                         continue;
>                 }
>
> +               /* Implement kprobe/fprobe bpf_get_func_ip inline. */
> +               if (prog_type == BPF_PROG_TYPE_KPROBE &&
> +                   eatype == BPF_TRACE_FPROBE &&
> +                   insn->imm == BPF_FUNC_get_func_ip) {
> +                       /* Load IP address from ctx (struct pt_regs) ip */
> +                       insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
> +                                                 offsetof(struct pt_regs, ip));

Isn't this architecture-specific? I'm starting to dislike this
inlining whole more and more. It's just a complication in verifier
without clear real-world benefits. We are clearly prematurely
optimizing here. In practice you'll just call bpf_get_func_ip() once
and that's it. Function call overhead will be negligible compare to
other *userful* work you'll be doing in your BPF program.


> +
> +                       new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
> +                       if (!new_prog)
> +                               return -ENOMEM;
> +
> +                       env->prog = prog = new_prog;
> +                       insn      = new_prog->insnsi + i + delta;
> +                       continue;
> +               }
> +
>  patch_call_imm:
>                 fn = env->ops->get_func_proto(insn->imm, env->prog);
>                 /* all functions that have prototype and verifier allowed
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index a2024ba32a20..28e59e31e3db 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1036,6 +1036,19 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
>         .arg1_type      = ARG_PTR_TO_CTX,
>  };
>
> +BPF_CALL_1(bpf_get_func_ip_fprobe, struct pt_regs *, regs)
> +{
> +       /* This helper call is inlined by verifier. */
> +       return regs->ip;
> +}
> +
> +static const struct bpf_func_proto bpf_get_func_ip_proto_fprobe = {
> +       .func           = bpf_get_func_ip_fprobe,
> +       .gpl_only       = false,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_CTX,
> +};
> +
>  BPF_CALL_1(bpf_get_attach_cookie_trace, void *, ctx)
>  {
>         struct bpf_trace_run_ctx *run_ctx;
> @@ -1279,7 +1292,8 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_override_return_proto;
>  #endif
>         case BPF_FUNC_get_func_ip:
> -               return &bpf_get_func_ip_proto_kprobe;
> +               return prog->expected_attach_type == BPF_TRACE_FPROBE ?
> +                       &bpf_get_func_ip_proto_fprobe : &bpf_get_func_ip_proto_kprobe;
>         case BPF_FUNC_get_attach_cookie:
>                 return &bpf_get_attach_cookie_proto_trace;
>         default:
> --
> 2.34.1
>
