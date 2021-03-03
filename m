Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE9D32B433
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbhCCEkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236734AbhCCE14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 23:27:56 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2BBC061756;
        Tue,  2 Mar 2021 20:27:16 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id h82so9346573ybc.13;
        Tue, 02 Mar 2021 20:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fBF8gj9kqNqcjblmL6ZQ3CB+04Ivo3KVBToXOGMBVfo=;
        b=FyTAgSUwhNXg7siQe2Tp8f81k2FGfBUulUZvHjhyt7vtMiis15M3KCaFuvVm7s1Guz
         LEjAMrKP6hLv2DwI0YEq0Mj0d4W9pN+gpQF5KDzczDqlsruGA4H53pfhzJxw63k0R4JY
         psLI8WaPOpGZMkh5mEzPeZwCoKZzvaZ3Ces+Tc3QUioADAfbO8DQ6sd5LEFzv+fYLe6O
         RS1f79ac7e+rz1knMkPcruRn/0uceeKfuGrcZxkreW+hT3IzZctlGg+XgNJPgvVeEJE1
         /em3maD8bzK4O0UILA1DqtA2H0GKJTdk1t9B5452TzEz7wUDIydXIY/HxDSRK/tN2ral
         v5tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fBF8gj9kqNqcjblmL6ZQ3CB+04Ivo3KVBToXOGMBVfo=;
        b=K8d507hZ6y2C2yHdIHPp7o6Svk3ENvoPuLE4uCui+RI4A4eaDj1z4YktaqbYmAn+sS
         2GAkAY1smafHow/rKYdMdq+24jvWjS7eDWtywHppCu3QAyU/hSKubEiIq/c+8ufA/iG1
         F12e6/mDRqjY/w2o0GQDWpNSH/ZMKLeCYfEM2uAuRrBoaBXdD8oiIr7hmGuqCe7ENMfC
         x+VIr6G0qfB3IyEyu3L4QPlUd6BOllw9vZCiRnZWPJD3UKZ2DYPxhpSFNUcT+nWfJz33
         wrG5tnvjBoGqWdrDyA58waPPpcbJbdSoxieE92L4Hej9HZHwhpTj5rWG4347hINrPoeK
         nRCA==
X-Gm-Message-State: AOAM530A3v1EeRylBlEYui2MMwEgcR0+JmLYrA4R/XtprLOledk8QEjQ
        jJQ5t5Ypx65kMo0D1azr7Na3ki5/Y4rpxI5KV69SnEEdZmU=
X-Google-Smtp-Source: ABdhPJz6LxSej6j5jca3f3+Yulb2eQe9Rmjxx4iPWu2s+AGHHWIFJUOGuTT2JGWp48n/dpvrPSGRgZuFIJ70PpUzu68=
X-Received: by 2002:a25:3d46:: with SMTP id k67mr34222012yba.510.1614745635773;
 Tue, 02 Mar 2021 20:27:15 -0800 (PST)
MIME-Version: 1.0
References: <20210301101859.46045-1-lmb@cloudflare.com> <20210301101859.46045-2-lmb@cloudflare.com>
In-Reply-To: <20210301101859.46045-2-lmb@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 2 Mar 2021 20:27:04 -0800
Message-ID: <CAEf4BzYvteVTJkGkyTNK_1YPV8aEQTYxDkW5uXTpWj5SvE4pvg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/5] bpf: consolidate shared test timing code
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 1, 2021 at 2:19 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Share the timing / signal interruption logic between different
> implementations of PROG_TEST_RUN. There is a change in behaviour
> as well. We check the loop exit condition before checking for
> pending signals. This resolves an edge case where a signal
> arrives during the last iteration. Instead of aborting with
> EINTR we return the successful result to user space.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  net/bpf/test_run.c | 141 +++++++++++++++++++++++++--------------------
>  1 file changed, 78 insertions(+), 63 deletions(-)
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 58bcb8c849d5..ac8ee36d60cc 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -16,14 +16,78 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/bpf_test_run.h>
>
> +struct test_timer {

nit: super generic name, I'd add bpf_ prefix throughout
(bpf_test_timer, bpf_test_timer_enter, bpf_test_timer_leave, and so
on)

> +       enum { NO_PREEMPT, NO_MIGRATE } mode;
> +       u32 i;
> +       u64 time_start, time_spent;
> +};
> +

[...]
