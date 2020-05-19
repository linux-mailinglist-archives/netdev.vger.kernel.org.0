Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175341D8C07
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 02:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgESAKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 20:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgESAJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 20:09:59 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB29FC05BD09
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 17:09:58 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id x1so10300670ejd.8
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 17:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IxrqFxJdqSnS7VAVDqLnJkOH5P3wut+0z7ZMFgHZj30=;
        b=OwsxdxHif5GFjHubXSJp6rvDOZwLJi7vXG5yU3ZO8BbDACR2v48yEeLiOPcdZtOo11
         9QCKurOKyqOiS4Pgas32x/doPXSRsxxLlAJXkpuXKIXLNbfXsue23L1hLeNzu9tLHGZs
         JooBGkjDk5B39aNx/i6N5D1BPrMGdednoHEoUPxRGgs/rMLBfMYsI+L34P3l/KLCIhAE
         Bcyz+XdzYrBu3iJk713GoaG18d7vyw8yTTFvmwUHJJKgbNu/6iOn7L5r/YskAnjCWFf/
         uu3R1h80bv8xGMkXT6HOWEdvCQmXWmY4WjF1ZkoAjSJH6uNo8IXKKLMPsOQqktMUqaCg
         S/Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IxrqFxJdqSnS7VAVDqLnJkOH5P3wut+0z7ZMFgHZj30=;
        b=J8LPbitOO5kQ1NI7EIfNfdZeE0+34HCBowANDKwQYZMQ++86Lrotw6Hw9yW1q+3Sys
         PEdyu3o+CP1MvxZgVK2x3C6+7ytdJp9rP4IDDgc42QfQ+PQn0E6Px/DpHUc2sydu39mn
         YVMJ3INK0cnuPI/09MyiFNgQog73w2mlJFF31ClhmZzpLzr09U+81OcioIcutRu2UpnS
         l7k6cqTzcHBvDSUUhHJZScB5qIJkEcz8oqoL9LCQf758Q4UW+fvfzubWa8hqhK7vaRvV
         rGodg0z9OKzj4F6ZVlDFM2wYnsCJpdfLJX4f2hqxAoo4M9gBY2RUnyCVuoedKFbdQthh
         nqLg==
X-Gm-Message-State: AOAM531GM1Xjt3wbWjrDQrc2LpIPDgyg+RAEx7Hvv6AxmlAUgsyWL6JD
        ATsJ4amisvkamQR9v3bgNI0EX/HZbCWN5UckzKCLoQ==
X-Google-Smtp-Source: ABdhPJyM9kGDV9TZPMgj39tKayJfeBGR62rAJ1b5FnKzloflEafk1UWqAI2Uso93q9XPvEKdMmcwZqvltLQWyV5XW88=
X-Received: by 2002:a17:906:4d9a:: with SMTP id s26mr16447641eju.153.1589846997488;
 Mon, 18 May 2020 17:09:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAG=TAF6mfrwxF1-xEJJ9dL675uMUa7RZrOa_eL2mJizZJ-U7iQ@mail.gmail.com>
 <CAEf4BzazvGOoJbm+zNMqTjhTPJAnVLVv9V=rXkdXZELJ4FPtiA@mail.gmail.com>
In-Reply-To: <CAEf4BzazvGOoJbm+zNMqTjhTPJAnVLVv9V=rXkdXZELJ4FPtiA@mail.gmail.com>
From:   Qian Cai <cai@lca.pw>
Date:   Mon, 18 May 2020 20:09:46 -0400
Message-ID: <CAG=TAF6aqo-sT2YE30riqp7f47KyXH_uhNJ=M9L12QU6EEEfqQ@mail.gmail.com>
Subject: Re: UBSAN: array-index-out-of-bounds in kernel/bpf/arraymap.c:177
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 7:55 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, May 17, 2020 at 7:45 PM Qian Cai <cai@lca.pw> wrote:
> >
> > With Clang 9.0.1,
> >
> > return array->value + array->elem_size * (index & array->index_mask);
> >
> > but array->value is,
> >
> > char value[0] __aligned(8);
>
> This, and ptrs and pptrs, should be flexible arrays. But they are in a
> union, and unions don't support flexible arrays. Putting each of them
> into anonymous struct field also doesn't work:
>
> /data/users/andriin/linux/include/linux/bpf.h:820:18: error: flexible
> array member in a struct with no named members
>    struct { void *ptrs[] __aligned(8); };
>
> So it probably has to stay this way. Is there a way to silence UBSAN
> for this particular case?

I am not aware of any way to disable a particular function in UBSAN
except for the whole file in kernel/bpf/Makefile,

UBSAN_SANITIZE_arraymap.o := n

If there is no better way to do it, I'll send a patch for it.
