Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C765554EE2F
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 01:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378778AbiFPXzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 19:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378634AbiFPXzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 19:55:16 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A6862118;
        Thu, 16 Jun 2022 16:55:15 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id gl15so5649814ejb.4;
        Thu, 16 Jun 2022 16:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IICDe7B16NcVod8ngha127cVizMJy8Rx+JH41yIJ0dg=;
        b=jMzNP0uK+DBt/ArFu9MgcHSRXHdyN9/hU+44KDhhVHUfEhTPAsRycxHoxYxBD8m43w
         5fM2nMzmV3xT3h24M8TZnDdU3CGoQCuV04nI7epLVXCKIDSNuK7+odnH33PfMJR2ArgU
         z10dYDDxuEKrYIeR8tsZ4blcjs5N3rn/Cpfsi1kAEaOeKanLZB4lgGayJMXqo96ECtMy
         VB9t2iQrLsiSWCYEuln8AEvPP3t9Y6qGGAzxB1BfM5oycfUQTtZafjynG/FAZcrjvV6G
         FtMLlaR2r5t5dzxDHClSy7RyjF34cHfyuJcvKjBMQEvgjw6crDxQuA/J2pT4phxcN6RG
         J0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IICDe7B16NcVod8ngha127cVizMJy8Rx+JH41yIJ0dg=;
        b=mizfLvxBybqj04HBM0POiTRk3slywtwYEiRa+52pCeZ1vRFYiVeNIBM7ob5pxnhJrV
         jvlSH6ZUzGipfDJClq05t/jxxb799CqvcE9Pu68eQRz9u/01MJSbOv+ExJAxRrSOlxeA
         VSkdiZu83f3EHnywLKDWMKkoilyqsessfvtOQsjAqGuYh4hq/3xYAqxtCg+08tOmYee+
         aagrnNbtx4ului1dI7Z03F6gNiIUKp6eHqkUwuG4inIjeVQtco4qXqc4UwHd8BB04ebi
         k0JIBVRh98/JyyT/aUgQKgws0Yy030r7wuclL6bhHEpaIMZ0SCl08PE0hJoQILBz60bu
         vjIQ==
X-Gm-Message-State: AJIora+skGqbNrfRJGwxbJ4j6ew3AglcMGvhJmgJuqXp7YUT39xMY06D
        R64oq/N62US+q6j5juNk55d5tV4/Oxc3PB8DlEB8f8Y4tAqA+A==
X-Google-Smtp-Source: AGRyM1sQDvErIqeYpvhDh/Rim9xQhoKiWQkLy30sEKSsGLmBzYAkt9WvmnwqI2HTLwUM29zx+/31YMgUoZRVscooMnI=
X-Received: by 2002:a17:906:1f52:b0:6f4:ebc2:da82 with SMTP id
 d18-20020a1709061f5200b006f4ebc2da82mr6944806ejk.176.1655423713575; Thu, 16
 Jun 2022 16:55:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220603055156.2830463-1-irogers@google.com> <165428101333.23591.13242354654538988127.git-patchwork-notify@kernel.org>
 <CAP-5=fWwKkj1HtAvOXxGxcrG99gpy8v4ReW_Jh7uumbQMiJYng@mail.gmail.com>
 <CAEf4BzYYcnu1PHoudKnvpjPJAszgu3TFSbNe=E6vctgh9JLkTg@mail.gmail.com> <CAP-5=fUANeeEHyCrynbJRrE4cU0BNrWYXN2G=MikjZS0cTJ1ZA@mail.gmail.com>
In-Reply-To: <CAP-5=fUANeeEHyCrynbJRrE4cU0BNrWYXN2G=MikjZS0cTJ1ZA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jun 2022 16:55:01 -0700
Message-ID: <CAEf4BzbTJGbixzP7ZoUNTYPAa1=7AqrXoUutZPiHS97Dik4Xfw@mail.gmail.com>
Subject: Re: [PATCH v2] libbpf: Fix is_pow_of_2
To:     Ian Rogers <irogers@google.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Yuze Chi <chiyuze@google.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 2:07 PM Ian Rogers <irogers@google.com> wrote:
>
> On Thu, Jun 16, 2022 at 2:00 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Jun 14, 2022 at 1:41 PM Ian Rogers <irogers@google.com> wrote:
> > >
> > > On Fri, Jun 3, 2022 at 11:30 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
> > > >
> > > > Hello:
> > > >
> > > > This patch was applied to bpf/bpf-next.git (master)
> > > > by Andrii Nakryiko <andrii@kernel.org>:
> > > >
> > > > On Thu,  2 Jun 2022 22:51:56 -0700 you wrote:
> > > > > From: Yuze Chi <chiyuze@google.com>
> > > > >
> > > > > Move the correct definition from linker.c into libbpf_internal.h.
> > > > >
> > > > > Reported-by: Yuze Chi <chiyuze@google.com>
> > > > > Signed-off-by: Yuze Chi <chiyuze@google.com>
> > > > > Signed-off-by: Ian Rogers <irogers@google.com>
> > > > >
> > > > > [...]
> > > >
> > > > Here is the summary with links:
> > > >   - [v2] libbpf: Fix is_pow_of_2
> > > >     https://git.kernel.org/bpf/bpf-next/c/f913ad6559e3
> > > >
> > > > You are awesome, thank you!
> > >
> > > Will this patch get added to 5.19?
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/lib/bpf/libbpf.c#n4948
> > >
> >
> > I've applied it to bpf-next, so as it stands right now - no. Do you
> > need this for perf?
>
> Nope. We carry it as a patch against 5.19 in Google and was surprised
> to see I didn't need to drop the patch.  Our internal code had
> encountered the bug, hence needing the fix. I'd expect others could
> encounter it, but I'm unaware of an issue with it and perf.
>

So the fix is in Github mirror ([0]) and it is expected that everyone
is using libbpf based on Github repo, so not sure why you'd care about
this fix in bpf tree. I somehow assumed that you need it due to perf,
but was a bit surprised that perf is affected because I don't think
it's using BPF ringbuf.

So I guess the question I have is why you don't use libbpf from [0]
and what can be done to switch to the official libbpf repo?

  [0] https://github.com/libbpf/libbpf

> Thanks,
> Ian
>
> > > Thanks,
> > > Ian
> > >
> > > > --
> > > > Deet-doot-dot, I am a bot.
> > > > https://korg.docs.kernel.org/patchwork/pwbot.html
> > > >
> > > >
