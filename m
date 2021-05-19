Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043A03894AB
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 19:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhESReB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 13:34:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229455AbhESRd6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 13:33:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 243FC6124C;
        Wed, 19 May 2021 17:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621445558;
        bh=/ANZHSTBWpiTzot37Zi9F3VT6IQjor/GqsSYdMSaDMM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=swkc4oXXx9XDoO7GShyix4Pgo+/s9m9pFdyd55BFtpdFCTmOKLfp37bcCcWsjUaSj
         JvmSmf0/rBjeCjQDJlNzBM0EIJUI73BoKAkDf+y7+6kAtjE3oYtGtrnGoTXf5uungm
         6UldhuwcpK5BndMsDRUSQ2VPRa+onsxM1YUq007CSBXcUA/aaOxx39AqA+NDTtKXSu
         NMREhLxGqwwIwdwZ2g9L4tERDJpkFO4W50LAwTTiD5FVqNV2pZODSqwPVt1oE4uzW7
         0o8Ih0K34lLp1yCBOz8yz5e4SlFuZDUJlTiP4K1HY0ypBpGM7de00c60irxBs3vqVV
         OnzCsXVxeIpog==
Received: by mail-lf1-f49.google.com with SMTP id w33so12339631lfu.7;
        Wed, 19 May 2021 10:32:38 -0700 (PDT)
X-Gm-Message-State: AOAM530B3nG1Hf0vdqel1egKnmlYxZ3RBtmO5m+Q3rez+xTllkpl1kvB
        ie62ooPpP5U8GCHpub+qzCtiVoDySGMiDiXu7MU=
X-Google-Smtp-Source: ABdhPJxN3AM9ofn1xXzqEvplfdC0npmsRcbVngTo2wqwjoiWFXBCiPAdbCJk5DbGlI1Z8wt1wcnFN020zkIzbcTFSAk=
X-Received: by 2002:ac2:5b12:: with SMTP id v18mr401062lfn.261.1621445556390;
 Wed, 19 May 2021 10:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210517225308.720677-1-me@ubique.spb.ru> <20210517225308.720677-3-me@ubique.spb.ru>
In-Reply-To: <20210517225308.720677-3-me@ubique.spb.ru>
From:   Song Liu <song@kernel.org>
Date:   Wed, 19 May 2021 10:32:25 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4osuNOagPRwUB30tk3V=ECANktt9jzb+NK1mqOamouSQ@mail.gmail.com>
Message-ID: <CAPhsuW4osuNOagPRwUB30tk3V=ECANktt9jzb+NK1mqOamouSQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/11] bpfilter: Add logging facility
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 11:05 PM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
>
> There are three logging levels for messages: FATAL, NOTICE and DEBUG.
> When a message is logged with FATAL level it results in bpfilter
> usermode helper termination.

Could you please explain why we choose to have 3 levels? Will we need
more levels,
like WARNING, ERROR, etc.?

>
> Introduce struct context to avoid use of global objects and store there
> the logging parameters: log level and log sink.
>
> Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
> ---
>  net/bpfilter/Makefile  |  2 +-
>  net/bpfilter/bflog.c   | 29 +++++++++++++++++++++++++++++
>  net/bpfilter/bflog.h   | 24 ++++++++++++++++++++++++
>  net/bpfilter/context.h | 16 ++++++++++++++++

Maybe combine bflog.h and context.h into one file? And bflog() can
probably fit in
that file too.

Thanks,
Song

>  4 files changed, 70 insertions(+), 1 deletion(-)
>  create mode 100644 net/bpfilter/bflog.c
>  create mode 100644 net/bpfilter/bflog.h
>  create mode 100644 net/bpfilter/context.h
>
> diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
> index cdac82b8c53a..874d5ef6237d 100644
> --- a/net/bpfilter/Makefile
> +++ b/net/bpfilter/Makefile
> @@ -4,7 +4,7 @@
>  #
>
>  userprogs := bpfilter_umh
> -bpfilter_umh-objs := main.o
> +bpfilter_umh-objs := main.o bflog.o
>  userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
>
>  ifeq ($(CONFIG_BPFILTER_UMH), y)
> diff --git a/net/bpfilter/bflog.c b/net/bpfilter/bflog.c
> new file mode 100644
> index 000000000000..2752e39060e4
> --- /dev/null
> +++ b/net/bpfilter/bflog.c
> @@ -0,0 +1,29 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2021 Telegram FZ-LLC
> + */
> +
> +#define _GNU_SOURCE
> +
> +#include "bflog.h"
> +
> +#include <stdarg.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +
> +#include "context.h"
> +
> +void bflog(struct context *ctx, int level, const char *fmt, ...)
> +{
> +       if (ctx->log_file &&
> +           (level == BFLOG_LEVEL_FATAL || (level & ctx->log_level))) {
> +               va_list va;
> +
> +               va_start(va, fmt);
> +               vfprintf(ctx->log_file, fmt, va);
> +               va_end(va);
> +       }
> +
> +       if (level == BFLOG_LEVEL_FATAL)
> +               exit(EXIT_FAILURE);
> +}
> diff --git a/net/bpfilter/bflog.h b/net/bpfilter/bflog.h
> new file mode 100644
> index 000000000000..4ed12791cfa1
> --- /dev/null
> +++ b/net/bpfilter/bflog.h
> @@ -0,0 +1,24 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2021 Telegram FZ-LLC
> + */
> +
> +#ifndef NET_BPFILTER_BFLOG_H
> +#define NET_BPFILTER_BFLOG_H
> +
> +struct context;
> +
> +#define BFLOG_IMPL(ctx, level, fmt, ...) bflog(ctx, level, "bpfilter: " fmt, ##__VA_ARGS__)
> +
> +#define BFLOG_LEVEL_FATAL (0)
> +#define BFLOG_LEVEL_NOTICE (1)
> +#define BFLOG_LEVEL_DEBUG (2)
> +
> +#define BFLOG_FATAL(ctx, fmt, ...)                                                                 \
> +       BFLOG_IMPL(ctx, BFLOG_LEVEL_FATAL, "fatal error: " fmt, ##__VA_ARGS__)
> +#define BFLOG_NOTICE(ctx, fmt, ...) BFLOG_IMPL(ctx, BFLOG_LEVEL_NOTICE, fmt, ##__VA_ARGS__)
> +#define BFLOG_DEBUG(ctx, fmt, ...) BFLOG_IMPL(ctx, BFLOG_LEVEL_DEBUG, fmt, ##__VA_ARGS__)
> +
> +void bflog(struct context *ctx, int level, const char *fmt, ...);
> +
> +#endif // NET_BPFILTER_BFLOG_H
> diff --git a/net/bpfilter/context.h b/net/bpfilter/context.h
> new file mode 100644
> index 000000000000..e85c97c3d010
> --- /dev/null
> +++ b/net/bpfilter/context.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2021 Telegram FZ-LLC
> + */
> +
> +#ifndef NET_BPFILTER_CONTEXT_H
> +#define NET_BPFILTER_CONTEXT_H
> +
> +#include <stdio.h>
> +
> +struct context {
> +       FILE *log_file;
> +       int log_level;
> +};
> +
> +#endif // NET_BPFILTER_CONTEXT_H
> --
> 2.25.1
>
