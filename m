Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9AB83BDF88
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 00:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhGFXAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 19:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhGFXAZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 19:00:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F97D61CB7;
        Tue,  6 Jul 2021 22:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625612266;
        bh=Nl7gMxMmDvpXrZ/MzAsmLHRtkTSNsJ96S2OihsfVaUE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Zx2d2uAenSD4VXx3AsDuksyXf3BQUZdDkbcZ027hczzIgOQhQpMyMwCWlf2TQ8Zg9
         iz7TbNpLjTijBA3VpEfDvUrIuDBGO5bwxtWgTm48G6NUB/T4hwf9FjJ21bqpqgAm4W
         AF4kFlvYrBon4SeAvMJM4Ltiz7Y5Z7dNuRoDZY3eETxQyXBT2cqx9HCXjlB0lFblbR
         hoJ5y8Lf8KMLgnl3u/HcCEHe9SYzcGufQJelxRxbEMBAWMd5b4OLldy6JkThsgrsYi
         IhwLjvPvWx4VgHnXfNU2JaBlY+vZeACh51rIpr9pntB2LGJy//Bj9OH2rm9Er0P3aW
         DBUGeEyP9y88A==
Received: by mail-lj1-f180.google.com with SMTP id a18so180601ljk.6;
        Tue, 06 Jul 2021 15:57:45 -0700 (PDT)
X-Gm-Message-State: AOAM5329ItKKxtBHkAe/oBsPT3Q5r8hbrMXhrVja3yky7gV5iF2yih2E
        bf/YgZ2Zr/JWV6Ac+Cmnz5g6PwD9w20yreHJAUQ=
X-Google-Smtp-Source: ABdhPJy0HTmTapx//iQEZNizEJYlp3Znk4OolUUBcyerUh4twWjQ6a6s8bhNcH/eHso8XEnVhem3+FVjjdq8v5YsBhk=
X-Received: by 2002:a2e:22c6:: with SMTP id i189mr17291368lji.97.1625612264282;
 Tue, 06 Jul 2021 15:57:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210706204005.92541-1-jolsa@kernel.org> <CAPhsuW5Vs5_WKtoe3Yn1Da73HQ0G1Q1LDNFMJzGjJQtCjyRCnA@mail.gmail.com>
In-Reply-To: <CAPhsuW5Vs5_WKtoe3Yn1Da73HQ0G1Q1LDNFMJzGjJQtCjyRCnA@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 6 Jul 2021 15:57:33 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4H20yNVuJW9RT01V2Qti8Yhxo=K432KBKoexe4boMhnw@mail.gmail.com>
Message-ID: <CAPhsuW4H20yNVuJW9RT01V2Qti8Yhxo=K432KBKoexe4boMhnw@mail.gmail.com>
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

On Tue, Jul 6, 2021 at 3:53 PM Song Liu <song@kernel.org> wrote:
>
> On Tue, Jul 6, 2021 at 1:40 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > The task_struct state got renamed to __state, causing
> > compile fail:
> >
> >   runqslower.bpf.c:77:12: error: no member named 'state' in 'struct task_struct'
> >         if (prev->state == TASK_RUNNING)
> >
> > As this is tracing prog, I think we don't need to use
> > READ_ONCE to access __state.
> >
> > Fixes: 2f064a59a11f ("sched: Change task_struct::state")
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>
> Acked-by: Song Liu <songliubraving@fb.com>

Just realized there is another thread fixing the same error.

Thanks,
Song
