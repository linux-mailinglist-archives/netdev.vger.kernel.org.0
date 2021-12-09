Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B69746F175
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239405AbhLIRVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbhLIRVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:21:09 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B00C061746;
        Thu,  9 Dec 2021 09:17:36 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id v138so15288979ybb.8;
        Thu, 09 Dec 2021 09:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KJRsMEiCufFN8dYu+nozb0ZGQF4pRkj8EjJsyMDC1hA=;
        b=pA2iGHk6K6TLdCgL34LbE89MSGKM5QwLVYICG1FP4iMYDgH5CXR40XTTErwPfAfXsJ
         NVHBBR4vgxs6SqpI+y8mIC0JYxZ4YJpEGWA5k6SNw3qMdu5GO+efL9g0z5AdWwrja95W
         IZ6J7jC76UNIQz2cdw/MW0eGHqwLc12l4Z0511Gj8o2d0V6i0+DRJsHVduAn5hmFdCdc
         bK6+w99Q1K7ibJP+3vHuRt1Ae1OvYP7ZkB/dGwWSjPRjH4rNlYFK7XxgHfNw1xVnwI6u
         3WYKvRmF4j0EaerTmZ2aUSenGpZD7BFuX0wlxFUuqbqQ6k9x4mTdNtCyRn+PMXM9Kk+g
         EN+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KJRsMEiCufFN8dYu+nozb0ZGQF4pRkj8EjJsyMDC1hA=;
        b=Txfh1mNNViYeU3q8bpjkx7zyLEFtZ8diPLVm8hizkVHEh6no7rmFkAHzAWwrcw7eDc
         mvB+nEf3FgOcoyK8LP9/LIIDX2slBB5O2+520gtQ4D/oozQLJj5GCHAM6mSxP/WAbRCg
         g4sro/IsVHej9TX/JXts1zmKoKdzssPFooutrVoagsckjfqbAB7lL2e73FwTuuYpJwEr
         psnqSKY1hjJzhvw4YNH/BoLuO1L9AtYht7eS+nMoQrqgFnG3YKSrj8Nl2j0cLHO4vEcT
         xGdfreuBqr0qzICW9d85AAkN4nbeo8qC1NRrVlcBrxU5oDhavxumjT4lo7dUBjvPUyOW
         mD1Q==
X-Gm-Message-State: AOAM531RZneizUSMH7W6aY2bpGW2t2832vzqdp3e/LYRlsrRET3/Zoym
        dgmfdUpnRIug6ze4+XKHXs0+aLY7fO0T4xCjNlE=
X-Google-Smtp-Source: ABdhPJzD7sQLxXI+0ul6gHy1pLJfEc2cVbG3P/mxPmTfZZd3BBsFt3PkohYiJkNuvuaL0HOXgiJS9rdT/Cx5m6Dy/FQ=
X-Received: by 2002:a25:3c9:: with SMTP id 192mr7999253ybd.766.1639070255451;
 Thu, 09 Dec 2021 09:17:35 -0800 (PST)
MIME-Version: 1.0
References: <20211209120327.551952-1-emmanuel.deloget@eho.link>
In-Reply-To: <20211209120327.551952-1-emmanuel.deloget@eho.link>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Dec 2021 09:17:24 -0800
Message-ID: <CAEf4BzYJ+GPpjcMMYQM_BfQ1-aq6dz_JbF-m5meiCZ=oPbrM=w@mail.gmail.com>
Subject: Re: [PATCH v1 bpf 1/1] libbpf: don't force user-supplied ifname
 string to be of fixed size
To:     Emmanuel Deloget <emmanuel.deloget@eho.link>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 9, 2021 at 4:03 AM Emmanuel Deloget
<emmanuel.deloget@eho.link> wrote:
>
> When calling either xsk_socket__create_shared() or xsk_socket__create()
> the user supplies a const char *ifname which is implicitely supposed to
> be a pointer to the start of a char[IFNAMSIZ] array. The internal
> function xsk_create_ctx() then blindly copy IFNAMSIZ bytes from this
> string into the xsk context.
>
> This is counter-intuitive and error-prone.
>
> For example,
>
>         int r = xsk_socket__create(..., "eth0", ...)
>
> may result in an invalid object because of the blind copy. The "eth0"
> string might be followed by random data from the ro data section,
> resulting in ctx->ifname being filled with the correct interface name
> then a bunch and invalid bytes.
>
> The same kind of issue arises when the ifname string is located on the
> stack:
>
>         char ifname[] = "eth0";
>         int r = xsk_socket__create(..., ifname, ...);
>
> Or comes from the command line
>
>         const char *ifname = argv[n];
>         int r = xsk_socket__create(..., ifname, ...);
>
> In both case we'll fill ctx->ifname with random data from the stack.
>
> In practice, we saw that this issue caused various small errors which,
> in then end, prevented us to setup a valid xsk context that would have
> allowed us to capture packets on our interfaces. We fixed this issue in
> our code by forcing our char ifname[] to be of size IFNAMSIZ but that felt
> weird and unnecessary.

I might be missing something, but the eth0 example above would include
terminating zero at the right place, so ifname will still have
"eth0\0" which is a valid string. Yes there will be some garbage after
that, but it shouldn't matter. It could cause ASAN to complain about
reading beyond allocated memory, of course, but I'm curious what
problems you actually ran into in practice.

>
> Fixes: 2f6324a3937f8 (libbpf: Support shared umems between queues and devices)
> Signed-off-by: Emmanuel Deloget <emmanuel.deloget@eho.link>
> ---
>  tools/lib/bpf/xsk.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 81f8fbc85e70..8dda80bcefcc 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -944,6 +944,7 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
>  {
>         struct xsk_ctx *ctx;
>         int err;
> +       size_t ifnamlen;
>
>         ctx = calloc(1, sizeof(*ctx));
>         if (!ctx)
> @@ -965,8 +966,10 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
>         ctx->refcount = 1;
>         ctx->umem = umem;
>         ctx->queue_id = queue_id;
> -       memcpy(ctx->ifname, ifname, IFNAMSIZ - 1);
> -       ctx->ifname[IFNAMSIZ - 1] = '\0';
> +
> +       ifnamlen = strnlen(ifname, IFNAMSIZ);
> +       memcpy(ctx->ifname, ifname, ifnamlen);

maybe use strncpy instead of strnlen + memcpy? keep the guaranteed
zero termination (and keep '\0', why did you change it?)

Also, note that xsk.c is deprecated in libbpf and has been moved into
libxdp, so please contribute a similar fix there.

> +       ctx->ifname[IFNAMSIZ - 1] = 0;
>
>         ctx->fill = fill;
>         ctx->comp = comp;
> --
> 2.32.0
>
