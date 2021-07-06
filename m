Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770ED3BDF85
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 00:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhGFW40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 18:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhGFW40 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 18:56:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D52A161C60;
        Tue,  6 Jul 2021 22:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625612026;
        bh=Cx3OYUiMIuGgZL2xkgv/cIES4ovxlfB3m3OEH0Yg9qc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GA2XMBVYeg2MzDAOpXt1HFkLmh058gU79l7mHWdZfaN9Cntf2Y/QV6ixrv8aSCDDs
         voloa3ivzHtdpeBFkUyrovKowVoPbiMZmLOAe7oTMv0DCG2SO4FxskYuFTgd6GzOWE
         xHNLoeC0SmxFmTvuL31CAz9ooSLfEsIOW3ciD4x120SJm+EOdkQZdSk+XeEMkqn947
         BIyxDpih6t7TFTQXKf8FnkLnW0kqLa1wieUXfXGMsh0IUdQDF4cKr87bnVF9LhR0T3
         Hs0hOdJF8wpbsD0DhYlHXuLZGXsBdvYL+qckpjKQxbuKWfQrwts1/Lt2WZvwYSZslt
         vEpfijoKkrD2g==
Received: by mail-lj1-f178.google.com with SMTP id z9so190903ljm.2;
        Tue, 06 Jul 2021 15:53:46 -0700 (PDT)
X-Gm-Message-State: AOAM5304UullcgPJEX6dh2zpyZR5KF2l66aGZ0H92Wmt112pjZvw+jvv
        HnCbHfuG8EUqHeOozo5ZYfEV9wCPqkQzUzm1XhA=
X-Google-Smtp-Source: ABdhPJy5sAzAdq14CfPbfkGZGs7w8LVHWHKd4ZW1yh1a50sH/EfL1m4/mjgkMPziIZ6CiWtxeWbk8O9MaS7UpuCUXoQ=
X-Received: by 2002:a05:651c:504:: with SMTP id o4mr16715115ljp.357.1625612025206;
 Tue, 06 Jul 2021 15:53:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210706204005.92541-1-jolsa@kernel.org>
In-Reply-To: <20210706204005.92541-1-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Tue, 6 Jul 2021 15:53:34 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5Vs5_WKtoe3Yn1Da73HQ0G1Q1LDNFMJzGjJQtCjyRCnA@mail.gmail.com>
Message-ID: <CAPhsuW5Vs5_WKtoe3Yn1Da73HQ0G1Q1LDNFMJzGjJQtCjyRCnA@mail.gmail.com>
Subject: Re: [PATCH] tools/runqslower: Change state to __state
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 6, 2021 at 1:40 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> The task_struct state got renamed to __state, causing
> compile fail:
>
>   runqslower.bpf.c:77:12: error: no member named 'state' in 'struct task_struct'
>         if (prev->state == TASK_RUNNING)
>
> As this is tracing prog, I think we don't need to use
> READ_ONCE to access __state.
>
> Fixes: 2f064a59a11f ("sched: Change task_struct::state")
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
