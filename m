Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C816A3F5770
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 06:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhHXEzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 00:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbhHXEzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 00:55:50 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD32C061575;
        Mon, 23 Aug 2021 21:55:06 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id z18so38504350ybg.8;
        Mon, 23 Aug 2021 21:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+KMvXEJhh1L8ZFzc0Mgjqr6x5W3tA5UEIC68g+yzA6I=;
        b=GcO6Bdd9yymY921Z35gKtB52sPw5Ye0ScCVxhTLg3C9E3f6r78p366UCodHgBGLJCJ
         iO0qh+NQ0rioy6CLEmvDrceDOL7Qb+K2mPhg8hH7JPcJW2zzmpLDw8YU7pXrr2jPhd1K
         d3f7Tp1rvQQIDDRR4sLsS+FZ3z7Qlndy0MPF1uv7glfY0XypDRtWF9Ni/4EZqveAlLAu
         Bd4PNjng/wiSAyAyvg4SVcRbZPxw7SayAVUSjyABNh7H0oEPrC825ah44G/8HvgUYLuC
         WuD5qL5JUrpQhMqMksYseYD5hqBv8DMpOddfk9qn2lAbwN45C7h2AX0UNdgzLyMlVJgz
         ojFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+KMvXEJhh1L8ZFzc0Mgjqr6x5W3tA5UEIC68g+yzA6I=;
        b=inXZvFO2fXcRGc+jTUVU0DEvRKypO4N+iBzxWg0fgsKdGuZd8WmY9/Y7VlH9ahzA/P
         hEZrEiwStkaGf6ETjKjhyv36YhhIQY2ZumzMRyBTdQmCz4l3+vQMGUdvYT3xO9pIE4yp
         GxozPIMHfEZcZ4gAGu6yK6xOYClwHuITsQUmjUxsx9jwlfkFu/o9+bOpmfFuoWNRWX6a
         uqojOj/2CO3Rvy7b3dWJcicx5oShrXn1NS97K+Dj7SS/bQwnwvZMG6QtpWM5VqdjamvV
         9s60Fa35knoDM1kxW6jBPxBkXJGo1MJFB+3UnlfPxBhvEByYcO5WB8SgmybE3uS5yUCk
         QYLw==
X-Gm-Message-State: AOAM5316mUHd7g74wqJpBZxur+1vz5QLYNnGBQ4f8IY+oKmdDRDvciN5
        DVJFIC8zrJ3wP3n95xB/G+EBYSYENUpurl0IOE4=
X-Google-Smtp-Source: ABdhPJzzS79+u+0Z3Ykd6LeORBcXWUfGxYOPJpYhN0SZZJQ/qd4w2JS50PgDjuz65y+8QwY+eLwUUwrNpJV8m7A5id0=
X-Received: by 2002:a25:ac7:: with SMTP id 190mr9028555ybk.260.1629780906120;
 Mon, 23 Aug 2021 21:55:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210821025837.1614098-1-davemarchevsky@fb.com> <20210821025837.1614098-4-davemarchevsky@fb.com>
In-Reply-To: <20210821025837.1614098-4-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Aug 2021 21:54:55 -0700
Message-ID: <CAEf4BzbakwDBO1w-R3dAVOiQ5DQ9QKwwTMO6N2YMkUtq_Jsdfw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] libbpf: Add bpf_vprintk convenience macro
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Florent Revest <revest@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 7:59 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> bpf_vprintk functions similarly to BPF_SEQ_PRINTF and BPF_SNPRINTF
> macros elsewhere in the file - it allows use of bpf_trace_vprintk
> without manual conversion of varargs to u64 array.
>
> Like the bpf_printk macro, bpf_vprintk is meant to be the main interface
> to the bpf_trace_vprintk helper and thus is uncapitalized.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---
>  tools/lib/bpf/bpf_helpers.h | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index b9987c3efa3c..43c8115956c3 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -224,4 +224,22 @@ enum libbpf_tristate {
>                      ___param, sizeof(___param));               \
>  })
>
> +/*
> + * bpf_vprintk wraps the bpf_trace_printk helper with variadic arguments
> + * instead of an array of u64.
> + */
> +#define bpf_vprintk(fmt, args...)                              \

Given BPF_SNPRINTF and BPF_SEQ_PRINTF, should we call this one in
all-caps as well?

> +({                                                             \
> +       static const char ___fmt[] = fmt;                       \
> +       unsigned long long ___param[___bpf_narg(args)];         \

I wonder how hard would it be to still use bpf_trace_printk() if the
number of input arguments is less than 3? That way you could use
BPF_PRINTF() everywhere, even on old kernels (you just need to
remember to use < 3 arguments). WDYT? It might be more challenging
than it seems, given it's hard to do conditionals inside #defines :(

> +                                                               \
> +       _Pragma("GCC diagnostic push")                          \
> +       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> +       ___bpf_fill(___param, args);                            \
> +       _Pragma("GCC diagnostic pop")                           \
> +                                                               \
> +       bpf_trace_vprintk(___fmt, sizeof(___fmt),               \
> +                    ___param, sizeof(___param));               \
> +})
> +
>  #endif
> --
> 2.30.2
>
