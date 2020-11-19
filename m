Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28E62B89EC
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbgKSB5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgKSB5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 20:57:37 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAED3C0613D4;
        Wed, 18 Nov 2020 17:57:36 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id o71so3688722ybc.2;
        Wed, 18 Nov 2020 17:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GY7J00zdZ0V443xLk8PUAFUN/cn75YLkx80p8NxMLOE=;
        b=aE5B+imROphFayJmarBMyyXGcotrNTCNnAUNnwNLXMW6DpCK7P0kQeWiyIa1ojTLwa
         0R1GmLNRc16S9msy+mZzdKSUEl7tLgd2qQv4+liEt8muxxqXMCrvaImSbqWu7bPd5H5W
         IiJae68oJmEIjxNHbJtxQ7iVnvJmqWTxUViRtyeFeuzs5cQg5EP9PwJYCdJHewQ6187f
         m8ybiYQUJNiBK1nztwupRcp8tjgBakNY6x67GD9y1jQ60XYD/tzvxQPHqsYBV/r+NYc1
         WgM/R379c/amA4v2saVf8FmF2Gtt5q/tFXVB4Q22w8z3VDcvzx7vSUfqSM6rymQt0FLq
         w2pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GY7J00zdZ0V443xLk8PUAFUN/cn75YLkx80p8NxMLOE=;
        b=GS6eIajoymAE3NWWhh1MCF4TEBRJXp6QovS/TTMezbVPdhTDJFAKEF4I53RVBkZpHQ
         X2MWN3Stj7hF2NyE+dbq58Y1uUznv0hQ7RN5FzurOIEP53PfSJm4Xx/qAuPIES46CqrA
         ibAqHgnQkFwCuNEYZMs7JlpLziR2/Fr6Oy0rDGcKcahR0B9tRUwovdMS7zNSeC1Kp2De
         5j0YEfeAg9JfZpPG20rTIBvoxmmzkH+6IQa4udmvmCVsoMuhyan+izQIz6Q1F/qCsYyY
         uxtwlmE1WzCeglSteNEaViwLZQ+vAA3SC+x3tW29P2KvlmNY9OZgyRVeREG5apujoI3X
         B/4g==
X-Gm-Message-State: AOAM533CU9J8aWdOeCdclMNJ3e8/UUKg/IqjB10eiZ2s1yV+5TmgRTTO
        UWIvt/IFF66XkLnTFYTAJOm4UQUH0s6PovERnuk=
X-Google-Smtp-Source: ABdhPJz2ZrNMGh8Zak/Lm21EQuVy3Et5GxaIxpM29qhkA5+uT87OYfXzoApMSjhzr++xWfhvC3OLWYq2DEuded98uc4=
X-Received: by 2002:a25:2845:: with SMTP id o66mr13391164ybo.260.1605751056232;
 Wed, 18 Nov 2020 17:57:36 -0800 (PST)
MIME-Version: 1.0
References: <20201118211350.1493421-1-jolsa@kernel.org>
In-Reply-To: <20201118211350.1493421-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Nov 2020 17:57:25 -0800
Message-ID: <CAEf4BzYdQz7p3khLPbNA_1cKbVJv-XJCcKtpxbsoXzExo+g_DQ@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fix VERSIONED_SYM_COUNT number parsing
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 1:15 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> We remove "other info" from "readelf -s --wide" output when
> parsing GLOBAL_SYM_COUNT variable, which was added in [1].
> But we don't do that for VERSIONED_SYM_COUNT and it's failing
> the check_abi target on powerpc Fedora 33.
>
> The extra "other info" wasn't problem for VERSIONED_SYM_COUNT
> parsing until commit [2] added awk in the pipe, which assumes
> that the last column is symbol, but it can be "other info".
>
> Adding "other info" removal for VERSIONED_SYM_COUNT the same
> way as we did for GLOBAL_SYM_COUNT parsing.
>
> [1] aa915931ac3e ("libbpf: Fix readelf output parsing for Fedora")
> [2] 746f534a4809 ("tools/libbpf: Avoid counting local symbols in ABI check")
>
> Cc: Tony Ambardar <tony.ambardar@gmail.com>
> Cc: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Cc: Aurelien Jarno <aurelien@aurel32.net>
> Fixes: 746f534a4809 ("tools/libbpf: Avoid counting local symbols in ABI check")
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

LGTM. For the future, though, please specify the destination tree: [PATCH bpf].

Acked-by: Andrii Nakryiko <andrii@kernel.org>


>  tools/lib/bpf/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index 5f9abed3e226..55bd78b3496f 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -146,6 +146,7 @@ GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
>                            awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
>                            sort -u | wc -l)
>  VERSIONED_SYM_COUNT = $(shell readelf --dyn-syms --wide $(OUTPUT)libbpf.so | \
> +                             sed 's/\[.*\]//' | \
>                               awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
>                               grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
>
> @@ -214,6 +215,7 @@ check_abi: $(OUTPUT)libbpf.so
>                     awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
>                     sort -u > $(OUTPUT)libbpf_global_syms.tmp;           \
>                 readelf --dyn-syms --wide $(OUTPUT)libbpf.so |           \
> +                   sed 's/\[.*\]//' |                                   \
>                     awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
>                     grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |             \
>                     sort -u > $(OUTPUT)libbpf_versioned_syms.tmp;        \
> --
> 2.26.2
>
