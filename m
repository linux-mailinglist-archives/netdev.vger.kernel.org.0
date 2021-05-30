Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC431394F01
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 05:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhE3DJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 23:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhE3DJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 23:09:30 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A2BC061574;
        Sat, 29 May 2021 20:07:51 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id i4so11459618ybe.2;
        Sat, 29 May 2021 20:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7LiPC8ld+lUcz1o2fSSPn/XHPlT9wH53dI+8pH6V/1s=;
        b=ZQpNGQyb263CHetFjRGIFadf0ki7cRz0JJhKXR4ZTUIWiKh3GdF56HDt/22ZOTCe/i
         c9TRhrkb64eqIxBD/8gQUzg7RCBcMWBbJaGGLI5eP1tErssLLjRvE8EKY7nyM0WDe9ie
         8JFg+CvDy35a0Zy2b5h+uV1ffG+VC/52GOk11LbZYnSquu810pTkdJBfdyPFNh3HFwQC
         rglylVbol8IaQIMGrG+TIfR91LsXYIjbLpy8SwccQ+ZsgLAy9GYcbWbgsaVgCd4jfOqT
         c5o+h3E8aX/sKpV19gB5nOo/P7oFn1PoeCiiWKu4m4W2Ih6z6umsfW0o69f7+8GyFsDq
         PZeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7LiPC8ld+lUcz1o2fSSPn/XHPlT9wH53dI+8pH6V/1s=;
        b=haF4n158nsLDTM3ej/3FNSHIzNQJqKHVfrL5Sa4N/9iLP7bYdYvvsDcRmq6jJUFbLr
         33ANytJImIXc+pyM+BPplJEhtBascMVLXuLfu/873VtcOFUh+60lbbRvalHx7kRV8wvv
         thReelNeMNs4LE0k0vZhbrd7IYi/I5ajJH3Jx2blny5n28B+mRvgj+bHNOajfKzstwWa
         hDhOgTZKLbQs4t4GInem99hnvnkPyH8j+H2QHzOIZ8+X3WfRloZmcUG/oCW6qlas2xNh
         ppKI9wOlSwvhL4ZZJF/BSeaMif9ULmL3AGDHAZ6I4ODYtkQLD1Xo3W+uOYteBOsb9/Tb
         RP8w==
X-Gm-Message-State: AOAM531HwQgH+iGy8ZhG91Mq3PO/iU4gJmV/t2iNtcjt7Qos63UOBG8u
        glOXsNuq8cmuoZw4a1DuG9GbVQbf+OUIqaQnC3k=
X-Google-Smtp-Source: ABdhPJyleJfqgDTuZzAOG1wYCsoOFTvFS1d3ffjXojiMSVpWf05qt5ibmkI3CUNSkdbHPMqFGYynyRXAteZwX6XqUjU=
X-Received: by 2002:a25:9942:: with SMTP id n2mr23833289ybo.230.1622344071195;
 Sat, 29 May 2021 20:07:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210528235250.2635167-1-memxor@gmail.com> <20210528235250.2635167-16-memxor@gmail.com>
In-Reply-To: <20210528235250.2635167-16-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 29 May 2021 20:07:40 -0700
Message-ID: <CAEf4BzZ76CYnUnOqn+qqqPhpFKSPVo2YqLZe6cSGyDna7+-_XQ@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 15/15] samples: bpf: convert xdp_samples to
 use raw_tracepoints
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 4:54 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> These are faster, and hence speeds up cases where user passes --stats to
> enable success case redirect accounting. We can extend this to all other
> tracepoints as well, so make that part of this change.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  samples/bpf/xdp_sample_kern.h | 145 +++++++++++-----------------------
>  samples/bpf/xdp_sample_user.c |   2 +-
>  2 files changed, 45 insertions(+), 102 deletions(-)
>

[...]

>
> -/* Tracepoint format: /sys/kernel/debug/tracing/events/xdp/xdp_exception/format
> - * Code in:                kernel/include/trace/events/xdp.h
> - */
> -struct xdp_exception_ctx {
> -       u64 __pad;      // First 8 bytes are not accessible by bpf code
> -       int prog_id;    //      offset:8;  size:4; signed:1;
> -       u32 act;        //      offset:12; size:4; signed:0;
> -       int ifindex;    //      offset:16; size:4; signed:1;
> -};
> -
> -SEC("tracepoint/xdp/xdp_exception")
> -int trace_xdp_exception(struct xdp_exception_ctx *ctx)
> +SEC("raw_tracepoint/xdp_exception")
> +int trace_xdp_exception(struct bpf_raw_tracepoint_args *ctx)
>  {

check out use of BPF_PROG macro for raw_tracepoint and fentry/fexit
programs, it looks nicer, IMO.

> +       u32 key = ctx->args[2];
>         struct datarec *rec;
> -       u32 key = ctx->act;
>
>         if (key > XDP_REDIRECT)
>                 key = XDP_UNKNOWN;

[...]
