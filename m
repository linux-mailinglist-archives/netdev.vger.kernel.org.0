Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344453FC010
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 02:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239185AbhHaAjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 20:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbhHaAjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 20:39:02 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B553AC061575;
        Mon, 30 Aug 2021 17:38:07 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id e129so31633678yba.5;
        Mon, 30 Aug 2021 17:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dIoCwE46sRweXCxYQ2GXPb1y5Z88T5kmd3WMggOIQlM=;
        b=C6WzzhEIa5tkiDWnP3ym+GCLUImj02sSwGurz0W6JfMrbtFPZjckdOW9JbSeAzdaAV
         AtPwUXpxVShsYGTxB9UhtWr4Zo4iC/r6JQclZInmZOzxWasR5AIjU/XTJdJrs90McPzf
         x+9AMAqZwJZcCQbEWXKMRq2K9VknG3kaOmIW0WbGC/Xw6WpK/44PuCR/Lk/+I0vooMAF
         x5xVJur/sFD263w1kQ4uWX8MD5lFptG5mPh/5dDIRAaeJqD2blUDXXOuL9dqiRT8S/JH
         h81OuB0R8f6GvLqu+imHUFaBNHZoFM5AxHo6IXJhUzkKiYV13YseDoZCy/SyD/ZJWh/u
         AXgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dIoCwE46sRweXCxYQ2GXPb1y5Z88T5kmd3WMggOIQlM=;
        b=im2nGHqe3Wxb6BK1wTWSROYfYJ720G1zhyDF1un7Lg7Sco/vgWGm2w0ORXZSYBAGaI
         OxcLg3ihOAI4olROppr/nDyyYORu/QS5jDnc8VhAWbAhWUWLwtFnXf1CZwawCKqc8BVW
         kCwc69l+uWB20GaGs7ZyU8MTkDhzehe6pbRERFLXgtlh+/ZVWTk+hquYgYUM/LxyaKBY
         MCrAfUOHW7IuAZMTM1ju8++N7FLKFubh5IJhlO/EHFPMvzKDSO71DZMtpqfamB20lcdf
         GmfzymuDVP5dUG9JoFuUVpO50Hf4fqzylp8jrI3AHdyOmjsj0Lpijg07Xc8Ekb3W6cK7
         ew+A==
X-Gm-Message-State: AOAM533ZTJZmC5EiIa2fxkzwHbbBBx2EOa8AHGdbcEwQBXjE1aMnyEQi
        DfA3xYcOlpRvbQjYpxtQpAY4XJyMy0Odv7pYKOEW2FuQ
X-Google-Smtp-Source: ABdhPJxeMygX7oYWfVfD8GI1jlPX2zWgC/Q1jXddRHXB0y2VFfDm3QhGq4IOGRbcJ56FB2pcnlXuK2JkA+pjetlFZKA=
X-Received: by 2002:a25:4941:: with SMTP id w62mr26991045yba.230.1630370286948;
 Mon, 30 Aug 2021 17:38:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210828052006.1313788-1-davemarchevsky@fb.com> <20210828052006.1313788-5-davemarchevsky@fb.com>
In-Reply-To: <20210828052006.1313788-5-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Aug 2021 17:37:56 -0700
Message-ID: <CAEf4BzZMaWFWqmucCczJ8DtHjY6zsWizr7G7_O9Lc-uV_1yEKQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 4/7] libbpf: use static const fmt string in __bpf_printk
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 10:20 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> The __bpf_printk convenience macro was using a 'char' fmt string holder
> as it predates support for globals in libbpf. Move to more efficient
> 'static const char', but provide a fallback to the old way via
> BPF_NO_GLOBAL_DATA so users on old kernels can still use the macro.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---
>  tools/lib/bpf/bpf_helpers.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 5f087306cdfe..a1d5ec6f285c 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -216,10 +216,16 @@ enum libbpf_tristate {
>                      ___param, sizeof(___param));               \
>  })
>
> +#ifdef BPF_NO_GLOBAL_DATA
> +#define BPF_PRINTK_FMT_TYPE char
> +#else
> +#define BPF_PRINTK_FMT_TYPE static const char
> +#endif
> +
>  /* Helper macro to print out debug messages */
>  #define __bpf_printk(fmt, ...)                         \
>  ({                                                     \
> -       char ____fmt[] = fmt;                           \
> +       BPF_PRINTK_FMT_TYPE ____fmt[] = fmt;            \

personal preferences, of course, but I'd leave char right there (I
think it makes it a bit more obvious what's going on right there), and
s/BPF_PRINTK_FMT_TYPE/BPF_PRINTK_FMT_MOD/ and have it as either "" or
"static const".

>         bpf_trace_printk(____fmt, sizeof(____fmt),      \
>                          ##__VA_ARGS__);                \
>  })
> --
> 2.30.2
>
