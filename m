Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C5221630E
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 02:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgGGAjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 20:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgGGAjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 20:39:06 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54AEC061755;
        Mon,  6 Jul 2020 17:39:06 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id j10so30487185qtq.11;
        Mon, 06 Jul 2020 17:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QEhkXAm0gn2ypM+JD7u3I0KsLSwMNvlrcfnw12nXtkM=;
        b=r37KtY/9VBE5nZFE9eB4rqfyzAMq/TDwEmMdrOXzCUzsAocLXQcGD14sXwvjI4G3vO
         0plxAJyrS9fRCPfmc3YqKct2NKBgO6nMtRlHFsaw5inxwDgR/6a433DLWheJyjGu0eDi
         w4v8z2n7Ht5622n9CrRY7pLTmWoOJgMIc+220ifsbXDC0aHtL7ekqvM3gUVaCOHpK9QY
         rpPQbK5j28RJGbQ14v4/HvcV2REdclM/OnpuSxYkarrkMBNH3v7VHm92GOV7ZxEi148K
         ZZ4+DSGGEJuAGzNZIZDk+VGg7+jw5QkTJGn9Pa7xh9Lom64rciQlZaTL5zYEUZAEIEZt
         U7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QEhkXAm0gn2ypM+JD7u3I0KsLSwMNvlrcfnw12nXtkM=;
        b=k50gizWJwc8WNjgHxegs2x+bcZ6V3c/i/4iK00QmnSLz0Eu6NMsNzEiAUqeWQcTp7m
         af/gffZh9A59A1u1IlWw6KCOmYdqRHW4V8/If4xl+BDsF8RbjFm9DesE4zskDjpcx3UZ
         wfNL7mOcGg9rDNWkD8qv4+cFpEHEiR+ohJPBIKalcg4KXZJinR7KtrC6VutOB3dowUTu
         /ZzaUBKnbTPXqrzl/A94PQeoiGITbor9vyZshQbuMFO9/OIrv0eGpkKD70xU1yczfV/M
         Yd0/RxyptwOEamkS9Dw8ZCLwpBGMuEwvbq2dqV9ixzkkI9pKbkTQ96JtHEjiuATZK8tQ
         0AmA==
X-Gm-Message-State: AOAM531smtKGVjSfQAUef+vFQU6nC2d9frOkMKyet2g1F1uHxzuZgfGM
        J/+0gAjxqLUvIj/hQkQo3+K9X8WesydoaIciLHI=
X-Google-Smtp-Source: ABdhPJwEn8/+LVwFauaXNrLlBe22bsuaSvu+V921O9u/gbGtkUpQ4RFF3sIQ1Ku3h3c8kyK/IqbjHwaOqqMfvenNEHg=
X-Received: by 2002:ac8:1991:: with SMTP id u17mr50050882qtj.93.1594082345749;
 Mon, 06 Jul 2020 17:39:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200703095111.3268961-1-jolsa@kernel.org> <20200703095111.3268961-5-jolsa@kernel.org>
In-Reply-To: <20200703095111.3268961-5-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Jul 2020 17:38:54 -0700
Message-ID: <CAEf4BzaDVGWpmMVuL5HG_pfRdqOVnq92EP8BSibwX7t+0FL4ZQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 4/9] bpf: Resolve BTF IDs in vmlinux image
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 3, 2020 at 2:52 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Using BTF_ID_LIST macro to define lists for several helpers
> using BTF arguments.
>
> And running resolve_btfids on vmlinux elf object during linking,
> so the .BTF_ids section gets the IDs resolved.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  Makefile                 | 3 ++-
>  kernel/trace/bpf_trace.c | 9 +++++++--
>  net/core/filter.c        | 9 +++++++--
>  scripts/link-vmlinux.sh  | 6 ++++++
>  4 files changed, 22 insertions(+), 5 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 8db4fd8097e0..def58d4f9ed7 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -448,6 +448,7 @@ OBJSIZE             = $(CROSS_COMPILE)size
>  STRIP          = $(CROSS_COMPILE)strip
>  endif
>  PAHOLE         = pahole
> +RESOLVE_BTFIDS = $(srctree)/tools/bpf/resolve_btfids/resolve_btfids

Oh, this is probably wrong and why out-of-tree build fails. Why don't
you follow how this is done for objtool?

>  LEX            = flex
>  YACC           = bison
>  AWK            = awk
> @@ -510,7 +511,7 @@ GCC_PLUGINS_CFLAGS :=
>  CLANG_FLAGS :=
>
>  export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC
> -export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE READELF PAHOLE LEX YACC AWK INSTALLKERNEL
> +export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE READELF PAHOLE RESOLVE_BTFIDS LEX YACC AWK INSTALLKERNEL
>  export PERL PYTHON PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
>  export KGZIP KBZIP2 KLZOP LZMA LZ4 XZ
>  export KBUILD_HOSTCXXFLAGS KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS LDFLAGS_MODULE

[...]
