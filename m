Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99631E0BAD
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732760AbfJVSpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:45:19 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43640 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732580AbfJVSpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:45:19 -0400
Received: by mail-qk1-f193.google.com with SMTP id a194so13180148qkg.10;
        Tue, 22 Oct 2019 11:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sja+Fgo0bAvbRP0S/b7Ybm+O4OdzsMHo7UdKMU1Ey/0=;
        b=SbunP9hNL4Rg3+mPuQzprPPBCeBIXu/LCMocGCSvMD5LatAWUanoqIxdLScicxVKyU
         e313W6rMeMPoR8KHHX6LVpDnTJpuxDZy2wuky8ZB4Oxy9H1KW/jGpqsO/rAJB5cCpU1V
         0KmJd0c1paaQ3nmFAU3krC/PPPtanjxh/7bFyWZbNjlCavZnxIXOJ6sVcM1JrvqegnwJ
         yB9NTfUOC8J58EZsASfIxffVwKOJFXIVVn01r6SZ3qtPL8QYdyb6AYetYDV6LR3ZlSmB
         wMxoJLZMOQlMM6ceHFmmDze/aEvLdYr/f/8eCAg4gDPLLMDL6dMdSREBsAKBghsBVfkL
         39rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sja+Fgo0bAvbRP0S/b7Ybm+O4OdzsMHo7UdKMU1Ey/0=;
        b=ZZqzXlh9ccUaegRO+bM4sn1B82nakX45tdFOpQtMZ/LhlvgZ+Yr1TSw5tBe8dh5QJl
         RK1Wv5H50FbduQ165DjgGOEb6RfY6DvuQdTW883ljbLbyzrR2DpNPC7fblgHjcWFnJi1
         Dtq2oV+VSRMyzYFdWzcaPMplXeKtK1y39s9sGFt4tIMda6vzm3j8S3eXWatLt+XsEWbd
         +ame+vaq8unV12CxelKr3Y1hI3SMAwU57+IJos+0iFnVo4nJwHPgK56PDS+/Q5Pmqvge
         eduo8QqyIwJAt33wVZZBFbGGQjLOtwrL+xLoivqiqegs28PVmvE1ZusjH/tCmK8R1/EV
         5/og==
X-Gm-Message-State: APjAAAWyjpgNY3koilmxGqyHjgl2R/DGnUerEdA2u3R9UOF5cp4QLI4S
        KNa2yZD4c6Eim5QhoeVUynOSljrDx2jU+Lp+srbHZUBcn4M=
X-Google-Smtp-Source: APXvYqzo6tB7YHIGHkKxvcbXXVxptE7FDc85alkFLwsdJHhJeKgsw+5SlCtEhkXQSZHo4uSYzEcOYypTihUkB5P2PHE=
X-Received: by 2002:a37:520a:: with SMTP id g10mr4512468qkb.39.1571769918191;
 Tue, 22 Oct 2019 11:45:18 -0700 (PDT)
MIME-Version: 1.0
References: <20191022125925.10508-1-ben.dooks@codethink.co.uk>
In-Reply-To: <20191022125925.10508-1-ben.dooks@codethink.co.uk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Oct 2019 11:45:07 -0700
Message-ID: <CAEf4BzY597=GXirqXzvps+-SbCXohTR-9=hDOxzXdZ9+HUieGQ@mail.gmail.com>
Subject: Re: [PATCH] xdp: fix type of string pointer in __XDP_ACT_SYM_TAB
To:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
Cc:     linux-kernel@lists.codethink.co.uk,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 6:51 AM Ben Dooks (Codethink)
<ben.dooks@codethink.co.uk> wrote:
>
> The table entry in __XDP_ACT_SYM_TAB for the last item is set
> to { -1, 0 } where it should be { -1, NULL } as the second item
> is a pointer to a string.
>
> Fixes the following sparse warnings:
>
> ./include/trace/events/xdp.h:28:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:53:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:82:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:140:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:155:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:190:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:225:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:260:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:318:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:356:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:390:1: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  include/trace/events/xdp.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
> index 8c8420230a10..c7e3c9c5bad3 100644
> --- a/include/trace/events/xdp.h
> +++ b/include/trace/events/xdp.h
> @@ -22,7 +22,7 @@
>  #define __XDP_ACT_SYM_FN(x)    \
>         { XDP_##x, #x },
>  #define __XDP_ACT_SYM_TAB      \
> -       __XDP_ACT_MAP(__XDP_ACT_SYM_FN) { -1, 0 }
> +       __XDP_ACT_MAP(__XDP_ACT_SYM_FN) { -1, NULL }
>  __XDP_ACT_MAP(__XDP_ACT_TP_FN)
>
>  TRACE_EVENT(xdp_exception,
> --
> 2.23.0
>
