Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72634AB587
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 08:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiBGHF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 02:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244698AbiBGHBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 02:01:16 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DF7C03F93B
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 23:00:46 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id e145so17101173yba.12
        for <netdev@vger.kernel.org>; Sun, 06 Feb 2022 23:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZmRZcqkB5wgEKXAct0BMYSANh4hoGmYrDG4ujSxT6Pw=;
        b=peOiinB+klns57onhenWLYoN/ssMGvnLYuRY8qwVZ+9nCsa96TYFvzZkkaFfFhGIQ5
         V/78bWUVpLff55PqxeIgaIdNrTQQNmjvGl5NrCjPk5TZ7Ov5MSEMwD8h2GQh5xZQCWY0
         RZBW283HEEMeShYKLxHuFNDVVI9W4uVsPXBbvPql49EOhhI2tuNjdPbaNc3WOvcWIa/C
         fmKPih9BYtferfwVaYAi49/rWzh1MI3a1oecsDEgLsIaokKXMDhH6pvbzfZlIvdVTs9d
         aBzhvvhlcOrhPzU280S/2QHtnJRhaJHO/JaryYzr2E/VRKxWV+R6BuZwglMfrHGFmSAk
         sHVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZmRZcqkB5wgEKXAct0BMYSANh4hoGmYrDG4ujSxT6Pw=;
        b=fzI7euASW1sdFaLxC0Tj8AX7be7KMRK4Rj82tZE5z4rQqDi1NaGYIzUtxZEIa0peTG
         Nte9Cz6a8IJxuW+Lu494G71Op9Pkp5hGX2SZsl1skAFwNkRVkwHcR0DlsndBGpQJEKqA
         rMT4yJed5PCgyAAZpE74obI5MxibwArwHWDOPCL+/eRaMm4+367Yrp7UKmqq4cvWyNuC
         0znNcBo3C+T6O9gPRtSrUqVgmTwqakOi8sIgBN3iVurT7iP5uEwbeDKmSWbbCzOqJN2a
         eF2wpx+PqaOSEJKDrN0tVkguhG2orJxOZwGoxoywPB6prVuEKjQQHkWZtGgoMNkAZNSH
         YQUg==
X-Gm-Message-State: AOAM531i+s89umlCrBBG9blwy0YmTfwA0DxxzaOBYQVOTh9MnWxYyHVg
        xskikAqx1wWjgsgrOZ4jpskJOAn1JDa7vrsjn0FDyw==
X-Google-Smtp-Source: ABdhPJw+zGA/rEACJXt3DtC3VbD72C8nwlgwhw44AGPgf4hHk7PcRDngnIqlMGU3wHAqu/rj7fLzb7r7iPezrV4Sxk4=
X-Received: by 2002:a25:c043:: with SMTP id c64mr8922932ybf.598.1644217245845;
 Sun, 06 Feb 2022 23:00:45 -0800 (PST)
MIME-Version: 1.0
References: <20220205172711.3775171-1-eric.dumazet@gmail.com>
In-Reply-To: <20220205172711.3775171-1-eric.dumazet@gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Mon, 7 Feb 2022 08:00:00 +0100
Message-ID: <CANpmjNP4RvQO6apbddOpriGhMcz9_SNrPSLWEdn-T14+GyDwbA@mail.gmail.com>
Subject: Re: [PATCH net-next] ref_tracker: remove filter_irq_stacks() call
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Feb 2022 at 18:27, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> After commit e94006608949 ("lib/stackdepot: always do filter_irq_stacks()
> in stack_depot_save()") it became unnecessary to filter the stack
> before calling stack_depot_save().
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Marco Elver <elver@google.com>

Reviewed-by: Marco Elver <elver@google.com>


> Cc: Alexander Potapenko <glider@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> ---
>  lib/ref_tracker.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
> index 9c0c2e09df666d19aba441f568762afbd1cad4d0..dc7b14aa3431e2bf7a97a7e78220f04da144563d 100644
> --- a/lib/ref_tracker.c
> +++ b/lib/ref_tracker.c
> @@ -89,7 +89,6 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
>                 return -ENOMEM;
>         }
>         nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
> -       nr_entries = filter_irq_stacks(entries, nr_entries);
>         tracker->alloc_stack_handle = stack_depot_save(entries, nr_entries, gfp);
>
>         spin_lock_irqsave(&dir->lock, flags);
> @@ -120,7 +119,6 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
>                 return -EEXIST;
>         }
>         nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
> -       nr_entries = filter_irq_stacks(entries, nr_entries);
>         stack_handle = stack_depot_save(entries, nr_entries, GFP_ATOMIC);
>
>         spin_lock_irqsave(&dir->lock, flags);
> --
> 2.35.0.263.gb82422642f-goog
>
