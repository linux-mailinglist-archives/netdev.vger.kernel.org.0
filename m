Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C11954EEC6
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 03:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379529AbiFQBZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 21:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379534AbiFQBZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 21:25:41 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC0E63538
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 18:25:33 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id m24so3868328wrb.10
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 18:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uNbNtYNUOkpq4DQQYD/bNQd8Np096f4o4ecAA/LLibg=;
        b=VHF+oQVqevD5c6rS1Dz6843WU5L6AgsnakYt/4mxKpLAGz9+OTYEMjgA2rRCnGloJy
         mihdf5Yfw9Co5rbDvexaeb+HN5aFOFbsUBWHXcDDyrVUbeMVsYLaKQaULsUvZHWI0dqp
         y7IIV2x+CnmHfTWdB9x1dwL5yVW/DRgiAEJbac30yOqgvj4zd/iKnkOBuRK9cUIEmA3U
         2+/OrMYQjWOj3ac/T2mNqDrx7CgnrZiYsVC6kPnXqXpOstK3nskxjtTIWOHhXUs3onTS
         tOIb4dr8tg2qHY4OXi+hOv8xHuvsYNL6KM9Ya1zWOkZId7CeSBWDZqhws4h/XNitWjAE
         oByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uNbNtYNUOkpq4DQQYD/bNQd8Np096f4o4ecAA/LLibg=;
        b=N5kj9s4yAYBGLM28TaHyjsHp9ZP92hJDbl5XgoBWuoKuO6dxjb3YfDmZoIVIGO5X/n
         M+IDYF/TljforqYBne5fcwQ9wcHOFm17D/I3lv6pqJOP4m5dwVzp8QfYM6m8Q7WqEjXq
         ocHaX2870lbfhEqj0IHIEssVul+W16zioqleyqI8zRGlpXDnJwdRLXys5C02gbyRdvuO
         pDENC5r1v6SBhbn/dXpKNgJvYQbM6zwiWXmH5mtBjEm4q4acrUngBYbsxU/JKQBbajvC
         VnVYqbsFReTikbfVl8F7NOrNP2RwWdeeTq0Yfl5BfWqgCN4tTShbs7f8oK59mUjeSOm0
         h5kw==
X-Gm-Message-State: AJIora9vBM/ubWetBhCBkSGMztAQHlA+/uafDMW6QU8BWXnoRLLvmIoe
        eWE+nn1IwVuF6UeChHOo5t8FtgsRQ310qlSdDFpaUA==
X-Google-Smtp-Source: AGRyM1u4B9pMpm2deQth0yQOPQYn3dwuz9UuLSAJFr/qfwTvYClla643fCKd2wzXCjLopKl4LX5mONAYT7rJ5OP1BHY=
X-Received: by 2002:a05:6000:1a8d:b0:219:e3f2:c092 with SMTP id
 f13-20020a0560001a8d00b00219e3f2c092mr7105521wry.375.1655429131650; Thu, 16
 Jun 2022 18:25:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220603055156.2830463-1-irogers@google.com> <165428101333.23591.13242354654538988127.git-patchwork-notify@kernel.org>
 <CAP-5=fWwKkj1HtAvOXxGxcrG99gpy8v4ReW_Jh7uumbQMiJYng@mail.gmail.com>
 <CAEf4BzYYcnu1PHoudKnvpjPJAszgu3TFSbNe=E6vctgh9JLkTg@mail.gmail.com>
 <CAP-5=fUANeeEHyCrynbJRrE4cU0BNrWYXN2G=MikjZS0cTJ1ZA@mail.gmail.com> <CAEf4BzbTJGbixzP7ZoUNTYPAa1=7AqrXoUutZPiHS97Dik4Xfw@mail.gmail.com>
In-Reply-To: <CAEf4BzbTJGbixzP7ZoUNTYPAa1=7AqrXoUutZPiHS97Dik4Xfw@mail.gmail.com>
From:   Ian Rogers <irogers@google.com>
Date:   Thu, 16 Jun 2022 18:25:18 -0700
Message-ID: <CAP-5=fV1LXNEi3U_RZxt12xPze41W9s27X_Gc6DbY6oDMJ4WvQ@mail.gmail.com>
Subject: Re: [PATCH v2] libbpf: Fix is_pow_of_2
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Yuze Chi <chiyuze@google.com>,
        open list <linux-kernel@vger.kernel.org>
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

On Thu, Jun 16, 2022 at 4:55 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jun 16, 2022 at 2:07 PM Ian Rogers <irogers@google.com> wrote:
> >
> > On Thu, Jun 16, 2022 at 2:00 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Tue, Jun 14, 2022 at 1:41 PM Ian Rogers <irogers@google.com> wrote:
> > > >
> > > > On Fri, Jun 3, 2022 at 11:30 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
> > > > >
> > > > > Hello:
> > > > >
> > > > > This patch was applied to bpf/bpf-next.git (master)
> > > > > by Andrii Nakryiko <andrii@kernel.org>:
> > > > >
> > > > > On Thu,  2 Jun 2022 22:51:56 -0700 you wrote:
> > > > > > From: Yuze Chi <chiyuze@google.com>
> > > > > >
> > > > > > Move the correct definition from linker.c into libbpf_internal.h.
> > > > > >
> > > > > > Reported-by: Yuze Chi <chiyuze@google.com>
> > > > > > Signed-off-by: Yuze Chi <chiyuze@google.com>
> > > > > > Signed-off-by: Ian Rogers <irogers@google.com>
> > > > > >
> > > > > > [...]
> > > > >
> > > > > Here is the summary with links:
> > > > >   - [v2] libbpf: Fix is_pow_of_2
> > > > >     https://git.kernel.org/bpf/bpf-next/c/f913ad6559e3
> > > > >
> > > > > You are awesome, thank you!
> > > >
> > > > Will this patch get added to 5.19?
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/lib/bpf/libbpf.c#n4948
> > > >
> > >
> > > I've applied it to bpf-next, so as it stands right now - no. Do you
> > > need this for perf?
> >
> > Nope. We carry it as a patch against 5.19 in Google and was surprised
> > to see I didn't need to drop the patch.  Our internal code had
> > encountered the bug, hence needing the fix. I'd expect others could
> > encounter it, but I'm unaware of an issue with it and perf.
> >
>
> So the fix is in Github mirror ([0]) and it is expected that everyone
> is using libbpf based on Github repo, so not sure why you'd care about
> this fix in bpf tree. I somehow assumed that you need it due to perf,
> but was a bit surprised that perf is affected because I don't think
> it's using BPF ringbuf.
>
> So I guess the question I have is why you don't use libbpf from [0]
> and what can be done to switch to the official libbpf repo?
>
>   [0] https://github.com/libbpf/libbpf

Agreed on not following Linus' tree for libbpf. Not sure about having
such an obvious bug in Linus' tree.

Thanks,
Ian

> > Thanks,
> > Ian
> >
> > > > Thanks,
> > > > Ian
> > > >
> > > > > --
> > > > > Deet-doot-dot, I am a bot.
> > > > > https://korg.docs.kernel.org/patchwork/pwbot.html
> > > > >
> > > > >
