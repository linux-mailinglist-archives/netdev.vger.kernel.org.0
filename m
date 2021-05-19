Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6A13894B8
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 19:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhESRjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 13:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhESRjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 13:39:41 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD80C06175F;
        Wed, 19 May 2021 10:38:21 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id e15so3428125ybc.10;
        Wed, 19 May 2021 10:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZF+ogBr+ZoCho+MfyFNrLvpNXGoVZjnSZVtBK1HfLnM=;
        b=Jnl84FYP+jD+w4a1tDV6jB4ZB1sMq+d68AU+urNjDaofLORd3JfBPndb3H92oSxbwQ
         bMyfZck42SW0NmelcxtD8I3FqCfLYOiOQX05uLyfMQ45qrjvI4qY0qdTJOC0n2PKnULW
         qz22nhb+dPtZfZNUVjSegnHk533W0MK4yY45P90uj7JXAJ8bOr/yfHw0ymfn2Hu3ui1s
         hMPCZn3VvyCRBi5EoK1tDiLIDSHiuW3vVvqdJ1QFVvbamuuJEhjYoXeOeKc3m1yz/RoW
         MoGUQtbmU5yR9LLrXcnwG6ytJ1IUHNWO+a8HJex9Trpwa3jJl4ziDDorIAPIfW2GHssW
         9lxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZF+ogBr+ZoCho+MfyFNrLvpNXGoVZjnSZVtBK1HfLnM=;
        b=hWnjodh//AqBzhEPFpYxbLFY6loTlWIIaqMT3X2Co8vAO7Yfxw94iGNxKxqkwAPgrh
         IDJm3ezR8iuQh978dD++1h7BK8r3bVWV1ecVFah7nQ4oOY/0NKrTOFjspbCaxukjF5q/
         vEvaGbuJtk91XVtp1/RJNo+Jb9Z8chE18iF4UyqiPXJCNEKVavlQSN7OyBvve/6omydn
         d00ecRYKv39IbLsROgew+51Da4aV8LTBKMRnQWxoAnYqIGPQCgs6SWDnu+VE74MEGEph
         zkN5NCqMfp1Vk6jtzSc+mFspPNzU6+qvoPckeLNODGIud/Fe6ph35WyrwOx5cZle+7R9
         /hJg==
X-Gm-Message-State: AOAM530LN1334Jv2x4eXK6JI7l8dBFTXevpaHKnyg4lcar6YRpBL96HO
        mfTvNsUhvLsvWlHfpYrzk/XKFqIUwf9p/oo8O5g=
X-Google-Smtp-Source: ABdhPJzh1IbUJQsYMdZ46Kg4+03gx0aMuKhhQ4ikI0/VbmB56Z/VPcvCDMnYf9gZal8qtd0dGkyUMqYHT6a6xcqwsZg=
X-Received: by 2002:a25:3357:: with SMTP id z84mr999463ybz.260.1621445900407;
 Wed, 19 May 2021 10:38:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1621424513.git.asml.silence@gmail.com> <94134844a6f4be2e0da2c518cb0e2e9ebb1d71b0.1621424513.git.asml.silence@gmail.com>
In-Reply-To: <94134844a6f4be2e0da2c518cb0e2e9ebb1d71b0.1621424513.git.asml.silence@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 May 2021 10:38:09 -0700
Message-ID: <CAEf4BzZU_QySZFHA1J0jr5Fi+gOFFKzTyxrvCUt1_Gn2H6hxLA@mail.gmail.com>
Subject: Re: [PATCH 18/23] libbpf: support io_uring
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 7:14 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  tools/lib/bpf/libbpf.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 4181d178ee7b..de5d1508f58e 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -13,6 +13,10 @@
>  #ifndef _GNU_SOURCE
>  #define _GNU_SOURCE
>  #endif
> +
> +/* hack, use local headers instead of system-wide */
> +#include "../../../include/uapi/linux/bpf.h"
> +

libbpf is already using the latest UAPI headers, so you don't need
this hack. You just haven't synced include/uapi/linux/bpf.h into
tools/include/uapi/linux/bpf.h

>  #include <stdlib.h>
>  #include <stdio.h>
>  #include <stdarg.h>
> @@ -8630,6 +8634,9 @@ static const struct bpf_sec_def section_defs[] = {
>         BPF_PROG_SEC("struct_ops",              BPF_PROG_TYPE_STRUCT_OPS),
>         BPF_EAPROG_SEC("sk_lookup/",            BPF_PROG_TYPE_SK_LOOKUP,
>                                                 BPF_SK_LOOKUP),
> +       SEC_DEF("iouring/",                     IOURING),
> +       SEC_DEF("iouring.s/",                   IOURING,
> +               .is_sleepable = true),
>  };
>
>  #undef BPF_PROG_SEC_IMPL
> --
> 2.31.1
>
