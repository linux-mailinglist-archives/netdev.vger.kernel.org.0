Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5B5389EA4
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 09:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhETHJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 03:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhETHJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 03:09:39 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B615C061574
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 00:08:17 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q5so16438305wrs.4
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 00:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nvNvutw5U6lnRUPBURCHGGCHa2JEZhSNhVEi39PMdZ8=;
        b=tCxQqsbYzVQEm011DO+lyzx7w+KGgEImTqonurjp5IVJQYfCV6mmWhyKPRneYZqryr
         WCwER0ilrgnpv9m7l63j4bVceBrFZaaL4253a1x3h6xs1MWj+ZRDtSf1H2iQCL6WBuPj
         m+BIiZQp93QLQnOTPRSDnkEViXcN0o17Z6i1AAF7KCtyx4qNmYnndxkUOJ0PsFWVR4Fs
         5u4mPonLst22NHiANW1d2Y9SBo5QryFH3cNYu5lUg506yk9NouHrEsNRAhJW4V49kAwQ
         Ke5VX1gBAdmDYAqTDVSNEumEI8oTgBHAtFscfO9LLP3t4YytJknuBOlVfbusPcbROA+F
         eJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nvNvutw5U6lnRUPBURCHGGCHa2JEZhSNhVEi39PMdZ8=;
        b=KYiLafWTgvkQni0SbeQKcf6S8FVPW3+dpSOHg4/KIxviCHQtaa5/BHARguWuWdbm9E
         bA0pI96NmKkCSWH5FLDSG3xVfXbC9QWzJsaH2pp7ogYgMDqUN9J55zINzsuloCNL2pb4
         qh+0TcPqbK9BOaaHD8KvP3zfd/Ef6jH4pmKldE5WO75iucrc114MFFQN+Ef+t5WoJr9w
         XZJmkc4E+ZP/gry3lhJPMgHk+HC0DWEL0fFEHh0dZ538InD1zpvxC5G+4xhDeMbBdkaL
         dZxtOyiQMAqjPrkKIR+sgpZSjE6e2LucDNo61QMwqivcs06V64e2mNQe7AaCwIga/rjk
         iVoA==
X-Gm-Message-State: AOAM530wcYbHZ9/dtuZowgQVOAUJJoR2n4uy3tRtaefO3/bhiANnKKUU
        Rlz9smL46GTDUwTabwOGoRZD4w==
X-Google-Smtp-Source: ABdhPJyxKQ6svKMvsszD2eHww08+OJaqvwJG59ev+lZ+IPZHrRZigYzE5+Rk0HIDnB103F0UDnz27A==
X-Received: by 2002:a5d:4d05:: with SMTP id z5mr2568820wrt.127.1621494495642;
        Thu, 20 May 2021 00:08:15 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id s7sm7939504wmh.35.2021.05.20.00.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 00:08:14 -0700 (PDT)
Date:   Thu, 20 May 2021 11:08:07 +0400
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     Song Liu <song@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next 02/11] bpfilter: Add logging facility
Message-ID: <20210520070807.cpmloff4urdsifuy@amnesia>
References: <20210517225308.720677-1-me@ubique.spb.ru>
 <20210517225308.720677-3-me@ubique.spb.ru>
 <CAPhsuW4osuNOagPRwUB30tk3V=ECANktt9jzb+NK1mqOamouSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW4osuNOagPRwUB30tk3V=ECANktt9jzb+NK1mqOamouSQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 10:32:25AM -0700, Song Liu wrote:
> On Tue, May 18, 2021 at 11:05 PM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
> >
> > There are three logging levels for messages: FATAL, NOTICE and DEBUG.
> > When a message is logged with FATAL level it results in bpfilter
> > usermode helper termination.
> 
> Could you please explain why we choose to have 3 levels? Will we need
> more levels,
> like WARNING, ERROR, etc.?


I found that I need one level for development - to trace what
goes rignt and wrong. At the same time as those messages go to
dmesg this level is too verbose to be used under normal
circumstances. That is why another level is introduced. And the
last one exists to verify invariants or error condintions from
which there is no right way to recover and they result in
bpfilter termination.

Probably we may have just two levels - DEBUG and NOTICE and some
analogue of BUG_ON/WARN_ON/runtime assert that results in a
message on NOTICE level and program termination if the checked
condition is false.

I don't think that we will need more levels - until we decide to
utilize syslog facility. Even in that case I don't know how to
differntiate between e.g. NOTICE and INFO messages.

> 
> >
> > Introduce struct context to avoid use of global objects and store there
> > the logging parameters: log level and log sink.
> >
> > Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
> > ---
> >  net/bpfilter/Makefile  |  2 +-
> >  net/bpfilter/bflog.c   | 29 +++++++++++++++++++++++++++++
> >  net/bpfilter/bflog.h   | 24 ++++++++++++++++++++++++
> >  net/bpfilter/context.h | 16 ++++++++++++++++
> 
> Maybe combine bflog.h and context.h into one file? And bflog() can
> probably fit in
> that file too.


Sure.

> 
> Thanks,
> Song
> 
> >  4 files changed, 70 insertions(+), 1 deletion(-)
> >  create mode 100644 net/bpfilter/bflog.c
> >  create mode 100644 net/bpfilter/bflog.h
> >  create mode 100644 net/bpfilter/context.h
> >
> > diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
> > index cdac82b8c53a..874d5ef6237d 100644
> > --- a/net/bpfilter/Makefile
> > +++ b/net/bpfilter/Makefile
> > @@ -4,7 +4,7 @@
> >  #
> >
> >  userprogs := bpfilter_umh
> > -bpfilter_umh-objs := main.o
> > +bpfilter_umh-objs := main.o bflog.o
> >  userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
> >
> >  ifeq ($(CONFIG_BPFILTER_UMH), y)
> > diff --git a/net/bpfilter/bflog.c b/net/bpfilter/bflog.c
> > new file mode 100644
> > index 000000000000..2752e39060e4
> > --- /dev/null
> > +++ b/net/bpfilter/bflog.c
> > @@ -0,0 +1,29 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2021 Telegram FZ-LLC
> > + */
> > +
> > +#define _GNU_SOURCE
> > +
> > +#include "bflog.h"
> > +
> > +#include <stdarg.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +
> > +#include "context.h"
> > +
> > +void bflog(struct context *ctx, int level, const char *fmt, ...)
> > +{
> > +       if (ctx->log_file &&
> > +           (level == BFLOG_LEVEL_FATAL || (level & ctx->log_level))) {
> > +               va_list va;
> > +
> > +               va_start(va, fmt);
> > +               vfprintf(ctx->log_file, fmt, va);
> > +               va_end(va);
> > +       }
> > +
> > +       if (level == BFLOG_LEVEL_FATAL)
> > +               exit(EXIT_FAILURE);
> > +}
> > diff --git a/net/bpfilter/bflog.h b/net/bpfilter/bflog.h
> > new file mode 100644
> > index 000000000000..4ed12791cfa1
> > --- /dev/null
> > +++ b/net/bpfilter/bflog.h
> > @@ -0,0 +1,24 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (c) 2021 Telegram FZ-LLC
> > + */
> > +
> > +#ifndef NET_BPFILTER_BFLOG_H
> > +#define NET_BPFILTER_BFLOG_H
> > +
> > +struct context;
> > +
> > +#define BFLOG_IMPL(ctx, level, fmt, ...) bflog(ctx, level, "bpfilter: " fmt, ##__VA_ARGS__)
> > +
> > +#define BFLOG_LEVEL_FATAL (0)
> > +#define BFLOG_LEVEL_NOTICE (1)
> > +#define BFLOG_LEVEL_DEBUG (2)
> > +
> > +#define BFLOG_FATAL(ctx, fmt, ...)                                                                 \
> > +       BFLOG_IMPL(ctx, BFLOG_LEVEL_FATAL, "fatal error: " fmt, ##__VA_ARGS__)
> > +#define BFLOG_NOTICE(ctx, fmt, ...) BFLOG_IMPL(ctx, BFLOG_LEVEL_NOTICE, fmt, ##__VA_ARGS__)
> > +#define BFLOG_DEBUG(ctx, fmt, ...) BFLOG_IMPL(ctx, BFLOG_LEVEL_DEBUG, fmt, ##__VA_ARGS__)
> > +
> > +void bflog(struct context *ctx, int level, const char *fmt, ...);
> > +
> > +#endif // NET_BPFILTER_BFLOG_H
> > diff --git a/net/bpfilter/context.h b/net/bpfilter/context.h
> > new file mode 100644
> > index 000000000000..e85c97c3d010
> > --- /dev/null
> > +++ b/net/bpfilter/context.h
> > @@ -0,0 +1,16 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (c) 2021 Telegram FZ-LLC
> > + */
> > +
> > +#ifndef NET_BPFILTER_CONTEXT_H
> > +#define NET_BPFILTER_CONTEXT_H
> > +
> > +#include <stdio.h>
> > +
> > +struct context {
> > +       FILE *log_file;
> > +       int log_level;
> > +};
> > +
> > +#endif // NET_BPFILTER_CONTEXT_H
> > --
> > 2.25.1
> >

-- 

Dmitrii Banshchikov
