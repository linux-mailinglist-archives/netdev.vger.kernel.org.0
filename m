Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B15D5A1E4B
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 03:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244516AbiHZBmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 21:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243899AbiHZBmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 21:42:04 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12696B5E47;
        Thu, 25 Aug 2022 18:42:02 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id lx1so459107ejb.12;
        Thu, 25 Aug 2022 18:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=quqbhae9tE+u+AuLu2p96mCxM/yvBDszB/bTDBaigeA=;
        b=DVfp8xZ0ZsJuW29ra11t3CveVoIOlgCAeTBHFvwcXUXJuPz9MfnvLIr5WvgXV2m6IN
         qRbBT37zyUFfc7CSq94cpgFL1ZTgzLydSwXzWEXn6Nc0bTbPtpSn1IKlulFxTsorgDsa
         IWw1SjjYOavpqX1e6EJaiBEay3rjqLipNd5XRPdWCkl1ll1txb/DMSttvVFuKglVt1s3
         7lg9DR394b2A2VMf+85lRITjVZ650A9QsQ+7wVbVj85eFWP6AjgIFGojK3Fove9I3ZTs
         b9e+gO965DgLnAFBrXX97X/T6OoOqdi05wZB0FPmDFPv7lB5Xjq70qVDlY9gveHrGCtd
         2m3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=quqbhae9tE+u+AuLu2p96mCxM/yvBDszB/bTDBaigeA=;
        b=pkq5yRJuKfS80cXlB5nyne7LRCg/uPwB90+ChOKp9V74smRqCNmToLPuWwWvc+UFVg
         GFiWDwcr69Z2vWgnIdroxnTXvOHJl1hevQtBmx2MnIYrPT8HyuOyqFqZ3SqQmXiQb/6W
         zZiu5NnTQao+gCwSP+7Ag97AT226wE7jW0fo29ydWfUPHuRv6C/rdsPsrOjcR7Wev+5g
         EKTxs1cWPQ0hb+zHVcbJ/75h3pWYk1i1frZnzkA1FVfDjWiFSbbTfLOvcoBhP7rQPyCs
         wOHGEqqLA+jHtwq5H6kifvOneBzlqcND6WfkZP1H+pmTgbw0uNxL+22vEDh0yFK9B/N1
         Q5Rw==
X-Gm-Message-State: ACgBeo1aAsPMJWmZJu7l7y+LMhmoyiCoLmEjJdLruvJOOLsFxFXx77QN
        t/3wBDzEnoOJeCPwZTUZwhomphwGyBp2DJKAJNM=
X-Google-Smtp-Source: AA6agR5PS8ZOJ+z0uD7rWY0c7lK03WtKQPHQ4chiwWkm17j7fYBMhw8neFuDjgLE8SeBkxc5+p52ZeKjmmtitPIa/0E=
X-Received: by 2002:a17:907:e8d:b0:730:a4e8:27ed with SMTP id
 ho13-20020a1709070e8d00b00730a4e827edmr3886774ejc.58.1661478120333; Thu, 25
 Aug 2022 18:42:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com> <20220824134055.1328882-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20220824134055.1328882-2-benjamin.tissoires@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 25 Aug 2022 18:41:49 -0700
Message-ID: <CAADnVQKgkFpLh_URJn6qCiAONteA1dwZHd6=4cZn15g1JCAPag@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 01/23] bpf/verifier: allow all functions to
 read user provided context
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
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

On Wed, Aug 24, 2022 at 6:41 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> When a function was trying to access data from context in a syscall eBPF
> program, the verifier was rejecting the call unless it was accessing the
> first element.
> This is because the syscall context is not known at compile time, and
> so we need to check this when actually accessing it.
>
> Check for the valid memory access if there is no convert_ctx callback,
> and allow such situation to happen.
>
> There is a slight hiccup with subprogs. btf_check_subprog_arg_match()
> will check that the types are matching, which is a good thing, but to
> have an accurate result, it hides the fact that the context register may
> be null. This makes env->prog->aux->max_ctx_offset being set to the size
> of the context, which is incompatible with a NULL context.
>
> Solve that last problem by storing max_ctx_offset before the type check
> and restoring it after.
>
> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> changes in v9:
> - rewrote the commit title and description
> - made it so all functions can make use of context even if there is
>   no convert_ctx
> - remove the is_kfunc field in bpf_call_arg_meta
>
> changes in v8:
> - fixup comment
> - return -EACCESS instead of -EINVAL for consistency
>
> changes in v7:
> - renamed access_t into atype
> - allow zero-byte read
> - check_mem_access() to the correct offset/size
>
> new in v6
> ---
>  kernel/bpf/btf.c      | 11 ++++++++++-
>  kernel/bpf/verifier.c | 19 +++++++++++++++++++
>  2 files changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 903719b89238..386300f52b23 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -6443,8 +6443,8 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
>  {
>         struct bpf_prog *prog = env->prog;
>         struct btf *btf = prog->aux->btf;
> +       u32 btf_id, max_ctx_offset;
>         bool is_global;
> -       u32 btf_id;
>         int err;
>
>         if (!prog->aux->func_info)
> @@ -6457,9 +6457,18 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
>         if (prog->aux->func_info_aux[subprog].unreliable)
>                 return -EINVAL;
>
> +       /* subprogs arguments are not actually accessing the data, we need
> +        * to check for the types if they match.
> +        * Store the max_ctx_offset and restore it after btf_check_func_arg_match()
> +        * given that this function will have a side effect of changing it.
> +        */
> +       max_ctx_offset = env->prog->aux->max_ctx_offset;
> +
>         is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
>         err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, 0);
>
> +       env->prog->aux->max_ctx_offset = max_ctx_offset;

I don't understand this.
If we pass a ctx into a helper and it's going to
access [0..N] bytes from it why do we need to hide it?
max_ctx_offset will be used later raw_tp, tp, syscall progs
to determine whether it's ok to load them.
By hiding the actual size of access somebody can construct
a prog that reads out of bounds.
How is this related to NULL-ness property?

> +
>         /* Compiler optimizations can remove arguments from static functions
>          * or mismatched type can be passed into a global function.
>          * In such cases mark the function as unreliable from BTF point of view.
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 2c1f8069f7b7..d694f43ab911 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5229,6 +5229,25 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
>                                 env,
>                                 regno, reg->off, access_size,
>                                 zero_size_allowed, ACCESS_HELPER, meta);
> +       case PTR_TO_CTX:
> +               /* in case the function doesn't know how to access the context,
> +                * (because we are in a program of type SYSCALL for example), we
> +                * can not statically check its size.
> +                * Dynamically check it now.
> +                */
> +               if (!env->ops->convert_ctx_access) {
> +                       enum bpf_access_type atype = meta && meta->raw_mode ? BPF_WRITE : BPF_READ;
> +                       int offset = access_size - 1;
> +
> +                       /* Allow zero-byte read from PTR_TO_CTX */
> +                       if (access_size == 0)
> +                               return zero_size_allowed ? 0 : -EACCES;
> +
> +                       return check_mem_access(env, env->insn_idx, regno, offset, BPF_B,
> +                                               atype, -1, false);
> +               }

This part looks good alone. Without max_ctx_offset save/restore.

> +               fallthrough;
>         default: /* scalar_value or invalid ptr */
>                 /* Allow zero-byte read from NULL, regardless of pointer type */
>                 if (zero_size_allowed && access_size == 0 &&
> --
> 2.36.1
>
