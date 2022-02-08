Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3A64ADFA7
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352745AbiBHR2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349421AbiBHR2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:28:30 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9FFC061578;
        Tue,  8 Feb 2022 09:28:30 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id k17so14460828plk.0;
        Tue, 08 Feb 2022 09:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Kw7Xek99WpttbgHdtFqYEzsdBAmkfRM2v4V6u1L0Rg=;
        b=jt0+PLagO5iZe7KJGr2Gr6poOKV8HsRHa8/DYLyqW+VUtAu+sGP1gWgf/aykUDfJ0T
         OaqeF4YkRfpFlNbQLXgjKNPihSlhBv7bf1Ral2GPFzfWDhqeLDq6kd1N+z6GyUHfJSGB
         bv4wgto/ItHmDFqCZQD56faC0M34sCCSPibTzfUcH1kbYa28eHLdPrZv9PdfDkayjFF/
         SGbwa0/5hwgEJJLpdXuWjFWy1/Q2SrXi7UuAHufE6AGgqXW5kEUD82VmERZygRW4YRdU
         BNHF02I+ayvWxITghQ78iOwDNl3GdUwuIkjHuc5VEhPLbeAMXtlL2n8wKijUv4FkSP1x
         mHdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Kw7Xek99WpttbgHdtFqYEzsdBAmkfRM2v4V6u1L0Rg=;
        b=RLnlvTRwz9ReM2zFC6Gs8rIdUjEkWN7eel16hR+ZVumjRWIgtdkX6HZl5uw0YKc+RR
         k6YfN/XV9ul6xOxT2OT2svvFCxbZUXA1D0EyJGU31wwYa7qFYIeOJlrOJgwtlQOUihVj
         g3h0FFTOucWxyHpgcPBkvxtZYkKv7kLjy/22xBsOvo47ka7GTDi5hQFd0o+Otj8yqdSG
         12BEeu+fw0aqsMIqMib7sK9UIOKnhr+p5t0y/X6LR6QgQxMWoerGY8kVK1pEJhb4b/s5
         g8xjdrQwET8nHDnf6hUKjhT1Bz7KrTvsL/2ZYHcNEHetvN0zyi7VHbukL4USaDIOaJDs
         RLWA==
X-Gm-Message-State: AOAM530imLksA5Kbe0ftl55SI8+nPshYulXsDisJzY9b3ooAxPBP5Frh
        v+s7d7lXnFgoqWE50raHsp70cW4Sz0CbBhfJsw3zYtyE
X-Google-Smtp-Source: ABdhPJz2ILpFusSB7XZKk9QXzX+YOfd964SbQ6Wbh6wodcY6zz4OXyu4V1hhVT1PxcHYGNWuFvw9EAZBkzx2ItBTfUQ=
X-Received: by 2002:a17:902:b682:: with SMTP id c2mr5574949pls.126.1644341309757;
 Tue, 08 Feb 2022 09:28:29 -0800 (PST)
MIME-Version: 1.0
References: <20220208062533.3802081-1-song@kernel.org>
In-Reply-To: <20220208062533.3802081-1-song@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 8 Feb 2022 09:28:18 -0800
Message-ID: <CAADnVQLpksvkKaJh1SAT0t2mjAb-1jUsTGp+EjhycsWfEThj1g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf, x86_64: fail gracefully on
 bpf_jit_binary_pack_finalize failures
To:     Song Liu <song@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>
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

On Mon, Feb 7, 2022 at 10:26 PM Song Liu <song@kernel.org> wrote:
>
> Instead of BUG_ON(), fail gracefully and return orig_prog.
>
> Fixes: 1022a5498f6f ("bpf, x86_64: Use bpf_jit_binary_pack_alloc")
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  arch/x86/net/bpf_jit_comp.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 643f38b91e30..08e8fd8f954a 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -2380,7 +2380,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>                          *
>                          * Both cases are serious bugs that we should not continue.

I tweaked that comment a bit, since it's no longer accurate and
pushed to bpf-next.
Thanks!

>                          */
> -                       BUG_ON(bpf_jit_binary_pack_finalize(prog, header, rw_header));
> +                       if (WARN_ON(bpf_jit_binary_pack_finalize(prog, header, rw_header))) {
> +                               prog = orig_prog;
> +                               goto out_addrs;
> +                       }
> +
>                         bpf_tail_call_direct_fixup(prog);
>                 } else {
>                         jit_data->addrs = addrs;
> --
> 2.30.2
>
