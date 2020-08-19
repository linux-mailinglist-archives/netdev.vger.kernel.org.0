Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8334249262
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHSBd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgHSBd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:33:27 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2833EC061389;
        Tue, 18 Aug 2020 18:33:27 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id s195so12441238ybc.8;
        Tue, 18 Aug 2020 18:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lPoUyrt4uJ5uw2ukJwBbLx8ZuUKwMWAqBkstTSZf3PM=;
        b=XjbUX8eDSJb3aw/Sb4oMnYJARybUJkviLJ8lScdNt2Zt4HWsz5EQnkwxR17ArGfWuT
         2QS1VZ3i5ZsEjk6F98zcbyh8SyjJQyU93X6chzX0YaAlWz7NRFewARn+7YOuD+k3IrqO
         YS8FeQA4PAgyYDGv3TFrS/PlH1lQN0zHOj8cm5kAZR52jpnKB9MnLyv8R3qib4tBFI44
         +G29Os/9Cdg7ZmaDO3LC48p/HzTD0hsQvu6aVi48fNq31cemb4mSgaB1SuO8uDB5mAgf
         YACqYG+XlygAS3TpNKcbvjbppBgMi31+/IVXKA6C6725Ef9WkxVfVXXOdpg/jOUEIfyZ
         IKlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lPoUyrt4uJ5uw2ukJwBbLx8ZuUKwMWAqBkstTSZf3PM=;
        b=Rl1cKMm5zJGQxabtvLwd+Y2aLeZvDGg5MME9qS8wIhxIx5qKySKg+j8bQ2sintN//B
         5umcmtXyYAvMhF/U8xUYJYu6Rypj5a/aEu3O1ezo6Z3/a1BmJvpHp0AYQuXLPkAWqyTk
         HRDxHgGPvDOJzPknG7nOgHMpCYLghVXLeQZf2dwsv6vTuulFar4DOvHK9rfqdJcI18PK
         J3Zo376SpKRClTNraoZrLrb++XFnRm3RBUn6ohU8+PniEjp2/iR5PXK4TC8zkCabyw2X
         7u1chFhNSJ1fQ2c3Ak7086coK6JlLoGXqFCSYQhUth7kG7O+GyNqcaxc4HxuJ8Mk6MjZ
         afFA==
X-Gm-Message-State: AOAM530/8Dwrsa1TpBPN+ZOB7mNVkHUp4+PML0KAPgQHPcYIl9u0tSYK
        c3tx9+U8mIexbSuFsr5K+G+JyPqEApAEnseAnkQ=
X-Google-Smtp-Source: ABdhPJykckLzMQsJL8b1i/t1scpZ5ynLHj/MbrRao8CGAa/+ta2z6KbYgviV362wg/DrgOyTEExIDVgpuz0nSFc6sUc=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr29760507ybe.510.1597800806442;
 Tue, 18 Aug 2020 18:33:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200819012156.3525852-1-andriin@fb.com> <CAADnVQLw6a7VKWVhUhNtYWjaOKUhAhLT8nzqHnFAm4nnCUzQkA@mail.gmail.com>
In-Reply-To: <CAADnVQLw6a7VKWVhUhNtYWjaOKUhAhLT8nzqHnFAm4nnCUzQkA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 18 Aug 2020 18:33:15 -0700
Message-ID: <CAEf4BzYbwYLqa4SanVmiSp95=StzNDkjPSvwjMwABdLEojqwzA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/4] libbpf: minimize feature detection
 (reallocarray, libelf-mmap)
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 6:25 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 18, 2020 at 6:24 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Get rid of two feature detectors: reallocarray and libelf-mmap. Optional
> > feature detections complicate libbpf Makefile and cause more troubles for
> > various applications that want to integrate libbpf as part of their build.
> >
> > Patch #1 replaces all reallocarray() uses into libbpf-internal reallocarray()
> > implementation. Patches #2 and #3 makes sure we won't re-introduce
> > reallocarray() accidentally. Patch #2 also removes last use of
> > libbpf_internal.h header inside bpftool. There is still nlattr.h that's used
> > by both libbpf and bpftool, but that's left for a follow up patch to split.
> > Patch #4 removed libelf-mmap feature detector and all its uses, as it's
> > trivial to handle missing mmap support in libbpf, the way objtool has been
> > doing it for a while.
> >
> > v1->v2:
> >   - rebase to latest bpf-next (Alexei).
>
> still no good. pls rebase again.

can't keep up :) rebasing
