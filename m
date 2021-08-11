Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0BE3E9A49
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhHKVQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhHKVQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 17:16:26 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919EBC061765;
        Wed, 11 Aug 2021 14:16:02 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id z128so7330516ybc.10;
        Wed, 11 Aug 2021 14:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GZkNP8NyqlnwVDqWKFFyzCmyU4skD6RZY5F39npq1pU=;
        b=OcLMBZUru52ljOOD/jfv/kO3sY7Y7qfxHxw4VMUhohUNPI30z5txn/ThnRko+HzePM
         CInkXrGZaupTT4TE2hIPKMt3q65BVh4ziPzCjCGFp2pHopgnISlOblG/X7AfxNGH/fAY
         oiakU8K3eF2HuORIToH10s91KLsdqLoyuCT1A+GMh0Zqjk+ls0mWT31zupUM4BQMROfY
         cUTyfX/5POOZUkel/PLIo+N3Je0rdAaw9dqxYDEUtYlI+6ZFgAymiqOnrBEhw0zQaOCl
         KYeTxhpKVuc975hOQYsHQwcO2wrMhTjS7+qaMEgufHpcBehtN8Fkw2IZCbJdSTvteT7U
         qS9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GZkNP8NyqlnwVDqWKFFyzCmyU4skD6RZY5F39npq1pU=;
        b=op8R20vb+ia9KaFcsugo1VqSIXnfcE0IVBjFcUIZd2SVtyc1JG3oDjRFDc7MFKxJQe
         18NoP2im9zF7EeGrppSi3eSQ5WgbaPP0YfPIJxbJa7WAtMMCc1z4Iiv7MPUFD84Qr4L6
         1/rVfrF2nFvMrbC4vRrW1+5V6GLmRvft2hut9Lzb/t38QfRzItgwIOppmHVFwTBk2q6/
         TuPqbm8m34gNKO/dK0fU0wdN3bqkNgCQackISabgcp2z7c015NdtbWbC7iTHZ3zObgAV
         mkyYmQL5YXJi3lYWFmFzm4UVkHyCJLGaBhCk26u/nfeurhJ0kEf+M79dyCmpawt2kv4i
         pDUw==
X-Gm-Message-State: AOAM533CUCYowiFkqROsC8Q9q9QSLRy/jep3hWo1smdO7YESYoMcRPDX
        vLKmOA7tWQk9wyHzsjWvWC+6uEY3I10V1RlZ+mQ=
X-Google-Smtp-Source: ABdhPJwnwRjMvrOd+6t0iTVhVcTvp6HfE9wFXhtrqwCcTzWPeMClYIsJATvweVwnBaVB9DtVfp6+Qwrbhjb7HR1RygQ=
X-Received: by 2002:a5b:648:: with SMTP id o8mr18374ybq.260.1628716561821;
 Wed, 11 Aug 2021 14:16:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210810092807.13190-1-kuniyu@amazon.co.jp> <20210810092807.13190-3-kuniyu@amazon.co.jp>
In-Reply-To: <20210810092807.13190-3-kuniyu@amazon.co.jp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Aug 2021 14:15:50 -0700
Message-ID: <CAEf4BzZBxA2+nNtbOVEyMXDG9i_3zfxm78=--ssjrX4ESC_ixA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/3] bpf: Support "%c" in bpf_bprintf_prepare().
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 2:29 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> /proc/net/unix uses "%c" to print a single-byte character to escape '\0' in
> the name of the abstract UNIX domain socket.  The following selftest uses
> it, so this patch adds support for "%c".  Note that it does not support
> wide character ("%lc" and "%llc") for simplicity.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  kernel/bpf/helpers.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 15746f779fe1..6d3aaf94e9ac 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -907,6 +907,20 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
>                         tmp_buf += err;
>                         num_spec++;
>
> +                       continue;
> +               } else if (fmt[i] == 'c') {

you are adding new features to printk-like helpers, please add
corresponding tests as well. I'm particularly curious how something
like "% 9c" (which is now allowed, along with a few other unusual
combinations) will work.

> +                       if (!tmp_buf)
> +                               goto nocopy_fmt;
> +
> +                       if (tmp_buf_end == tmp_buf) {
> +                               err = -ENOSPC;
> +                               goto out;
> +                       }
> +
> +                       *tmp_buf = raw_args[num_spec];
> +                       tmp_buf++;
> +                       num_spec++;
> +
>                         continue;
>                 }
>
> --
> 2.30.2
>
