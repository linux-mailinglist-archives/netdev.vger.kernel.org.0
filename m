Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822863FF7AA
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 01:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347915AbhIBXKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 19:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbhIBXKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 19:10:30 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E484C061757;
        Thu,  2 Sep 2021 16:09:31 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id a93so6905443ybi.1;
        Thu, 02 Sep 2021 16:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LLnJqzfhM8qBd8H1VVDw8R6SqG+AxJfODpjZZTe4sB8=;
        b=K7zOXr+32sGSJUR/DWIk7erTYj1laOBiruQNVw0VDaYJBziG1TDBb6g8fPZShOAmc5
         z3SLVWkfc7Pvt8i+qRoYfzXMogRScjLczaaBe5+DGO79ZZVVvIZcs9TnoHIUE/Phoqpx
         Xs6R8OE5tp86vwv0naD5uenTMnMAh3aTKrUtogWfA2lNO5V3uNFVZvKtvFWSYXzQqjQ7
         O6m1pt5hk4U2SVINqD3tUxd+Y6jc3yQj3V9+G09fBn7Z+ukCjXzevhvU69mIA0FuxW5y
         KGXt4bMywzhhkLGgZ/o1Tis0V1jwfHZZP5T3BwGlICY8hLed4rOgqgTSHZptmll5xleS
         7SMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LLnJqzfhM8qBd8H1VVDw8R6SqG+AxJfODpjZZTe4sB8=;
        b=U8QPdiKpGaTi+sVVIDWe1bmDeX/LayT+sHwr4ieTZ/igMw44ogtkhnTqKwiUvXkSE4
         KvrMOYglCB0rZ8b7vpmuvwyEFsgJrFQIoJvpd7el/sz9IYrvJPgVb6j4KiSfzCVsBhSG
         ect8Ix4vwaGTVkknJ7/INQkWndBpjCgDj+/l90nRvCV0Mvq8+2PXN+U4d1sTrQzW4rAt
         ZJS7XLPHI78QsXQfRzcybdD9nZyO3XMcNt532wLpYvrsa8+oKeb8R66LaijDmVDRZUep
         FeqEKCacV3q2SMBQkWcEUXdZeyLTfWEF1CXPr62EbQsuWz43XD9rQVEafEdmtvcD7xkr
         1dXA==
X-Gm-Message-State: AOAM531B1RZY1rUo3ylPd0qG5q85vqo/OR/AdOvzwbqtYPGj+xGrla28
        K3NlcwruhHVYMy6Unh4O1xoqGv3XwNFvSLW2MGUHqFYDz00=
X-Google-Smtp-Source: ABdhPJxgUNhRmz+p73pmKDt1LlB8daA7QIXpDufFxmRg+UzCpPcn/cuurCxjahi9zLRfECoQS7b3mQYdPOf3VSNrwgo=
X-Received: by 2002:a25:bb13:: with SMTP id z19mr1104521ybg.347.1630624170757;
 Thu, 02 Sep 2021 16:09:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210902171929.3922667-1-davemarchevsky@fb.com> <20210902171929.3922667-6-davemarchevsky@fb.com>
In-Reply-To: <20210902171929.3922667-6-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 2 Sep 2021 16:09:19 -0700
Message-ID: <CAEf4Bza3Aye9fyhMvR_iuF93ES3OeFwgoXZxCbA=C_+EpLQk_w@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 5/9] libbpf: use static const fmt string in __bpf_printk
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 10:23 AM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> The __bpf_printk convenience macro was using a 'char' fmt string holder
> as it predates support for globals in libbpf. Move to more efficient
> 'static const char', but provide a fallback to the old way via
> BPF_NO_GLOBAL_DATA so users on old kernels can still use the macro.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---

Great, thanks!

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/bpf_helpers.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index a7e73be6dac4..7df7d9a23099 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -216,10 +216,16 @@ enum libbpf_tristate {
>                      ___param, sizeof(___param));               \
>  })
>
> +#ifdef BPF_NO_GLOBAL_DATA
> +#define BPF_PRINTK_FMT_MOD
> +#else
> +#define BPF_PRINTK_FMT_MOD static const
> +#endif
> +
>  /* Helper macro to print out debug messages */
>  #define __bpf_printk(fmt, ...)                         \
>  ({                                                     \
> -       char ____fmt[] = fmt;                           \
> +       BPF_PRINTK_FMT_MOD char ____fmt[] = fmt;        \
>         bpf_trace_printk(____fmt, sizeof(____fmt),      \
>                          ##__VA_ARGS__);                \
>  })
> --
> 2.30.2
>
