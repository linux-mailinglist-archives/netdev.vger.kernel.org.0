Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C85449B8D
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 19:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbhKHSXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 13:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235228AbhKHSXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 13:23:40 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B18C061570;
        Mon,  8 Nov 2021 10:20:56 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id q74so45934785ybq.11;
        Mon, 08 Nov 2021 10:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r7XPmJ4Slk0Ee3SezOzVKKKVWOfK/ZMFCj2/Il/40bw=;
        b=iz01UfRunQAw2bNi51uhKvnwK2/Te9f/yoUFFKDmp5I6iZld01jP8o5venupoJWDO+
         mT94brOYF2rsnQ9uqe12t0Y+xbOW7arQ2DH21TpPvZeFWaXI5omzz1VApkGnM2MZ15FJ
         1zrT4C+5b5xSRAioqhGnsxz35d7mTG9TJy1xlk8nSZNpch7bGx/VzMczpRLQYkDGKLgP
         5ReQhsl85aBI38ZkG/w/Zi2jMhqZqgCQ5fiW15aIJpYxdPWKRvVUhoLq9j1KgTwlCnT9
         nr2UlZ5lWY9ldfsGC+IC+8RUNbeyEOvkY8IZR5FH5Fq96rFeepMMgtBf9TwyowqfnTsJ
         FQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r7XPmJ4Slk0Ee3SezOzVKKKVWOfK/ZMFCj2/Il/40bw=;
        b=I7ZRzP1GYj+660QOf/Kt6LiEsIkKcyoIpw3wizWepEdoy3kXYg2N3VTdnxZoyow3Rm
         ssB2A1Cs3SKFavu78EP4+/iKylfDBvSHoTO2Bozo8mZLqbCC9Y5eMyFEj8C8wYr8F15N
         baIcTl/SNJLFaDJ7GHefrE9AKmZzCSYdY0vF6r0qfUwt9qw/eUdQDLu3my5JBQ0vKO0H
         A6hUhg8gdOJ39ZAHM2PrrqzkuaTzB5Jpibk+bW8MHbsVRWfcaeU6MqAsHEVqP4ClbSdf
         XR+GU7Phcj7ZtuYM2FW6AejYtlc4TDYoXU+ndybHOxSAbAdOUfa1mt6npVaS/3XejMNA
         mdqg==
X-Gm-Message-State: AOAM5333zwdGKHmvt/V7GGahPeAHbRzuzySF5bnmBwsjHdYT82ekRhBT
        S+OQQ396a2BdoaJXMex2weXiM3TsN+DShiR7iOyyNBlpM0s=
X-Google-Smtp-Source: ABdhPJzKAxzbKjPtiiGNx7AYawm+AKqI67L99mxmMg0zsCRfBfiQ633kM0HeDLshFyAnNtdF6Ej5bom8rFbvvTcqyW4=
X-Received: by 2002:a25:cc4c:: with SMTP id l73mr1441620ybf.114.1636395655412;
 Mon, 08 Nov 2021 10:20:55 -0800 (PST)
MIME-Version: 1.0
References: <20211108083840.4627-1-laoar.shao@gmail.com> <20211108083840.4627-6-laoar.shao@gmail.com>
In-Reply-To: <20211108083840.4627-6-laoar.shao@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Nov 2021 10:20:44 -0800
Message-ID: <CAEf4BzYn3PwjhjzWV8oPD3A8ozLN_Y4ef7xAHW+oECOMgtMgcA@mail.gmail.com>
Subject: Re: [PATCH 5/7] samples/bpf/test_overhead_kprobe_kern: make it adopt
 to task comm size change
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 8, 2021 at 12:39 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> bpf_probe_read_kernel_str() will add a nul terminator to the dst, then
> we don't care about if the dst size is big enough. This patch also
> replaces the hard-coded 16 with TASK_COMM_LEN to make it adopt to task
> comm size change.
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Petr Mladek <pmladek@suse.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  samples/bpf/offwaketime_kern.c          |  4 ++--
>  samples/bpf/test_overhead_kprobe_kern.c | 11 ++++++-----
>  samples/bpf/test_overhead_tp_kern.c     |  5 +++--
>  3 files changed, 11 insertions(+), 9 deletions(-)
>

[...]
