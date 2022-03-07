Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B554CF325
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 09:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236038AbiCGIFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 03:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbiCGIFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 03:05:17 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997024B849;
        Mon,  7 Mar 2022 00:04:23 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id mv5-20020a17090b198500b001bf2a039831so6556641pjb.5;
        Mon, 07 Mar 2022 00:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8xCyUJ819zmTEom5rd2U1Jn8nrXih6wcRjO3YGtluhI=;
        b=IYCBY26tt46xSFR5Kn8lc0DTyhvA2990szr0QH8LlDI6LMEOy7eCi6ioFcgho71Q43
         NAIy1t53IQaE8kH5YwNQXNuzqsag1FDBVlI7QOsD8eveInRrPR2RdZ0/euVAFrQi5D25
         l4Ljgs9yLZ9Age8X1Xk2+cem+p3nvQAop+8JEcnVwFjkYEwfKcUJEQ+t6zqBdNWXNPva
         BSUB+3zQJa98NRSxGfjEnn8Zi5mqc+9YshN57dy2+HlN1qjitPjoD4MlMWLDB2oSd6Zm
         M0i0kQIA//8abNBedrWmfJUGHM8YjVpGQHJtKmtTE5ANi8pff8+exgJxzUdwC4/doq0O
         llPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8xCyUJ819zmTEom5rd2U1Jn8nrXih6wcRjO3YGtluhI=;
        b=jFF/Llz4rLPThFurWMMrLfIMpGs36KgT5WX2NyEnPncOZNuKi6BzmWNtalT650MFdE
         ybosGUGxir6kL/owwdH7H8q4Zszl5lFe1gyuVASAf5ZeiMGp/i06J9w9oXj31x8m12dx
         0Z8ph2iUlHS235khUWmtlk7QwG501sZD0IXVR+ePLYS/fpfKuE/4EB5OkSZvfrbJvg1a
         dym5TyJwXpR40sp8wFVtcUGdI08rKjsVdmfU4AGZI3kzkZsCLF+Ls8v16iwrRi1h3mtI
         fu4uykzSnsKYocG61ljrrJ4OmOQJK3NF1d0zvDDEpvQKU1wXmW5jSsAD20PIpksfsW45
         KALA==
X-Gm-Message-State: AOAM5329wRRqAEr+gkHX0na2s6pLytLscdJ5fZkGnYyxa7QaFZLmBVz8
        4Z6xNDyHJOO+OBw04GdsKHpRwiAvLHKVftryYEk=
X-Google-Smtp-Source: ABdhPJx2v2nAtkO0rjMzgiPIuVf8ReM/Icq3ZDcG4eqN3NNwqjqq3ugHQQk7FME/6E8JdYzeDbKrBu4p3JBM8gJMAfc=
X-Received: by 2002:a17:90a:4542:b0:1b9:bc2a:910f with SMTP id
 r2-20020a17090a454200b001b9bc2a910fmr11454690pjm.133.1646640262988; Mon, 07
 Mar 2022 00:04:22 -0800 (PST)
MIME-Version: 1.0
References: <20220306023426.19324-1-guozhengkui@vivo.com>
In-Reply-To: <20220306023426.19324-1-guozhengkui@vivo.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 7 Mar 2022 09:04:12 +0100
Message-ID: <CAJ8uoz01xnVOsrbUdFFLegb9szSgG81xpi0nAu6ONX18obNe+g@mail.gmail.com>
Subject: Re: [PATCH] libbpf: fix array_size.cocci warning
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Sun, Mar 6, 2022 at 5:20 AM Guo Zhengkui <guozhengkui@vivo.com> wrote:
>
> Fix the following coccicheck warning:
> tools/lib/bpf/bpf.c:114:31-32: WARNING: Use ARRAY_SIZE
> tools/lib/bpf/xsk.c:484:34-35: WARNING: Use ARRAY_SIZE
> tools/lib/bpf/xsk.c:485:35-36: WARNING: Use ARRAY_SIZE

Thanks for the fix. Note that the AF_XDP support has been deprecated
and will be removed in the 1.0 libbpf release. So there is no point in
fixing this for the xsk.c file. These days, the AF_XDP support resides
in libxdp. I checked if your patch would apply to libxdp, but the
loading of the default program is handled differently there, so this
line does not exist anymore.

> It has been tested with gcc (Debian 8.3.0-6) 8.3.0 on x86_64.
>
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> ---
>  tools/lib/bpf/bpf.c | 3 ++-
>  tools/lib/bpf/xsk.c | 4 ++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 418b259166f8..3c7c180294fa 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -29,6 +29,7 @@
>  #include <errno.h>
>  #include <linux/bpf.h>
>  #include <linux/filter.h>
> +#include <linux/kernel.h>
>  #include <limits.h>
>  #include <sys/resource.h>
>  #include "bpf.h"
> @@ -111,7 +112,7 @@ int probe_memcg_account(void)
>                 BPF_EMIT_CALL(BPF_FUNC_ktime_get_coarse_ns),
>                 BPF_EXIT_INSN(),
>         };
> -       size_t insn_cnt = sizeof(insns) / sizeof(insns[0]);
> +       size_t insn_cnt = ARRAY_SIZE(insns);
>         union bpf_attr attr;
>         int prog_fd;
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index edafe56664f3..19dbefb1caf1 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -481,8 +481,8 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>                 BPF_EMIT_CALL(BPF_FUNC_redirect_map),
>                 BPF_EXIT_INSN(),
>         };
> -       size_t insns_cnt[] = {sizeof(prog) / sizeof(struct bpf_insn),
> -                             sizeof(prog_redirect_flags) / sizeof(struct bpf_insn),
> +       size_t insns_cnt[] = {ARRAY_SIZE(prog),
> +                             ARRAY_SIZE(prog_redirect_flags),
>         };
>         struct bpf_insn *progs[] = {prog, prog_redirect_flags};
>         enum xsk_prog option = get_xsk_prog();
> --
> 2.20.1
>
