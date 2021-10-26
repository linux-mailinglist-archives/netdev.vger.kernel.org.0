Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF91243AB70
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 06:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbhJZEtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 00:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbhJZEtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 00:49:23 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F07CC061745;
        Mon, 25 Oct 2021 21:47:00 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id v7so31811297ybq.0;
        Mon, 25 Oct 2021 21:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=snF+FgRXlmPR3jIjKkl30XVFVxT4Om22kZ8kNiegnwE=;
        b=bTH4TGqO5GorcGcg/EjKv+pqJU53vEC3xUasoHEnFYvNsxcSYYHn8wQ891rxzE9OJs
         dZu7TY3pVPU9LmLGxQ08CpWYugaXaoy7nKCwfmgAjyP7dATKpp/CBjoPwCu2o4OPl0mo
         RIX6GFWWqAs4pQ5zCk8u0KG04lK/sJhVAIA6DQc0nyHbI8qqsXqGYsUQLhB7URPS+U5q
         eh9VttpyGu4Fa2a2f9cuk3jIX6rNqxuFMzEk7Yct2Sg+sqUvw4UC32BqfH0tFKwX9Ove
         YwYLLScfx4M4487z3QbRUFrL9eZ6P1Xd6BbNuska2N+XVKD1fwpSPOld843vRTXjh/E9
         CFcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=snF+FgRXlmPR3jIjKkl30XVFVxT4Om22kZ8kNiegnwE=;
        b=Q2vj54p2Y/Qq0PgpjFBZfgUznfxkPRdaDgpEn5Xck3M/Q2t1qKw3gKnrDk5TMycklE
         WaN6MOHgx7UoQBE5L50c3t1d4bRnH0y/968A6XLasr/N5q0PA7sEux8xaFMDSl3tAxDp
         uEBym5k4X4iL7peRyrUOXSC3jIAKMU5kKnVpqkgKdQPX9oRHydBrwnCFSpuVqqTm4bgP
         UyvDJ4qvGL9Y79vfobVRoCbEWV1mTE8CHPN4Z9u4iLmoRQ842NAa/d0jdYsKfoxTmlX4
         +jy7FpPsDfW/aAXojUtTAEyDPIPYN8RHS4E3M+0kr2YCXG7mM+RCGHCgzVMy/CwrVKkG
         7pYg==
X-Gm-Message-State: AOAM531hdna+ngWH90uPaX54vjKklnaWN67AqxZ2UTntVYQbm45QSXbm
        QDpQuNR7S/KD7R3hj5i4wOYV05NsxRiU0kRIinw=
X-Google-Smtp-Source: ABdhPJy7F4dFHuWsjEsI1C3xFE1RJr+4lQSqw2mb1SRXVvvZUt3O3HsWPZ0kwscrS1trOC1Tjy7ssyJMHAAQ0aPdqHk=
X-Received: by 2002:a25:afcf:: with SMTP id d15mr20890438ybj.433.1635223619696;
 Mon, 25 Oct 2021 21:46:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211022234814.318457-1-songliubraving@fb.com>
In-Reply-To: <20211022234814.318457-1-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Oct 2021 21:46:48 -0700
Message-ID: <CAEf4BzYdfgZDh4pLkeFr_BbzhOgg26PX1fgUZgi04w-n4p11bw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: guess function end for test_get_branch_snapshot
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 4:48 PM Song Liu <songliubraving@fb.com> wrote:
>
> Function in modules could appear in /proc/kallsyms in random order.
>
> ffffffffa02608a0 t bpf_testmod_loop_test
> ffffffffa02600c0 t __traceiter_bpf_testmod_test_writable_bare
> ffffffffa0263b60 d __tracepoint_bpf_testmod_test_write_bare
> ffffffffa02608c0 T bpf_testmod_test_read
> ffffffffa0260d08 t __SCT__tp_func_bpf_testmod_test_writable_bare
> ffffffffa0263300 d __SCK__tp_func_bpf_testmod_test_read
> ffffffffa0260680 T bpf_testmod_test_write
> ffffffffa0260860 t bpf_testmod_test_mod_kfunc
>
> Therefore, we cannot reliably use kallsyms_find_next() to find the end of
> a function. Replace it with a simple guess (start + 128). This is good
> enough for this test.

It's so annoying that sizes of all those symbols are known and
available in ELF, yet kallsyms don't expose them :( I've applied this
"fix", but it makes me very sad.

>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  .../bpf/prog_tests/get_branch_snapshot.c      |  7 ++--
>  tools/testing/selftests/bpf/trace_helpers.c   | 36 -------------------
>  tools/testing/selftests/bpf/trace_helpers.h   |  5 ---
>  3 files changed, 4 insertions(+), 44 deletions(-)
>

[...]
