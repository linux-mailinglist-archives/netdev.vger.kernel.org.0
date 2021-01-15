Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E51F2F8036
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730569AbhAOQFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727719AbhAOQE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:04:59 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14D9C061799;
        Fri, 15 Jan 2021 08:04:18 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id x20so13815101lfe.12;
        Fri, 15 Jan 2021 08:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cjjKngUNXSmp5+ZG99wAVh2M/rHKatH6hgVDyGroZyU=;
        b=aga/UzIvB7XonoZN9FJbkyLXYjzRnOYPE7P3LvOHIsimtqOj5i9WDUx9NUxqLD0Cix
         G/A7ruEMmPhgoOULPdQ4Fql/24dqyS1v0OZ7/3J+HEWR9MFhC3+fNRi0HVK7xx8z09YN
         /mro9lDOPzlCMbyHn6Ev3sgSQgml2xM5+WNkzFIbS4s60hsu9teXEHEp7gpCbyJrJqCg
         StbQNdhgpYjJkKDUKBa4BrgMcX1/JtAzPnfG89F037S1hDGbL8VZWe5ZegWCs/5BYSGZ
         ZVZKMkHCT0otzW+nlLQbb0DqnklR0JXpcJuUxyjRzw8+xz0zJ0O7u1vvI78rpaSX4RsQ
         VWUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cjjKngUNXSmp5+ZG99wAVh2M/rHKatH6hgVDyGroZyU=;
        b=fQsvZTJx9AQLga1xOLR5W0ev1RsLxxa3puR8g4CexVXTw0xzstHywfJsUfOxBTxiKt
         Id2DYgkcvPLkozCrJwD2+kJmhl93poWrfYkcAr5gT1b+fA+Al4Y3hAnfXN/DzmyMx3Jg
         ctyYeVingG30A32r3TMZOuPYh8fP0A47XsoNyRJK6Rd2tV18pR+lZ5vXeGpRYYDUqnow
         iIBkMixiXlGt7Q1358jHiy4Yl1CwW/iZOi4jBezK4ruVjrS19WmW0+hEFIDOtSOkAonq
         zLBVTatwYuG6sBKgxtra7aA278PXuCRamKClPU8lOoq7wj3KVtSxYBDTL1IZ1AmTywAo
         5lcA==
X-Gm-Message-State: AOAM530/01zSIJifQF3Mnuk6Ee6gVUeoRix6NLJtNiYQCGGNnffCwnLK
        Q2qpULsGTKB5L7esqrx049Yv+Qyki859IBcntNU=
X-Google-Smtp-Source: ABdhPJyAM58RuuCJIC1lGGiETeUBk/Fcbag5Pz3FxGpPQY8BaTmgwgyckOgXWGGopAMW0vBJ/3692m/dBQY1lY5FTdE=
X-Received: by 2002:a19:8983:: with SMTP id l125mr5670209lfd.182.1610726657406;
 Fri, 15 Jan 2021 08:04:17 -0800 (PST)
MIME-Version: 1.0
References: <20210114095411.20903-1-glin@suse.com> <20210114095411.20903-2-glin@suse.com>
 <CAADnVQJiK3BWLr5LRhThUySC=6VyiP=tt3ttiyZPHGLmoU4jDg@mail.gmail.com> <YAFjLNg2XStnTL3W@GaryWorkstation>
In-Reply-To: <YAFjLNg2XStnTL3W@GaryWorkstation>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 15 Jan 2021 08:04:06 -0800
Message-ID: <CAADnVQJ7LQMv513dDwy3ogdq+PaFN5gu6DOS-GiRT72MP4mmcQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] bpf,x64: pad NOPs to make images converge more easily
To:     Gary Lin <glin@suse.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 1:41 AM Gary Lin <glin@suse.com> wrote:
>
> On Thu, Jan 14, 2021 at 10:37:33PM -0800, Alexei Starovoitov wrote:
> > On Thu, Jan 14, 2021 at 1:54 AM Gary Lin <glin@suse.com> wrote:
> > >          * pass to emit the final image.
> > >          */
> > > -       for (pass = 0; pass < 20 || image; pass++) {
> > > -               proglen = do_jit(prog, addrs, image, oldproglen, &ctx);
> > > +       for (pass = 0; pass < MAX_PASSES || image; pass++) {
> > > +               if (!padding && pass >= PADDING_PASSES)
> > > +                       padding = true;
> > > +               proglen = do_jit(prog, addrs, image, oldproglen, &ctx, padding);
> >
> > I'm struggling to reconcile the discussion we had before holidays with
> > the discussion you guys had in v2:
> >
> > >> What is the rationale for the latter when JIT is called again for subprog to fill in relative
> > >> call locations?
> > >>
> > > Hmmmm, my thinking was that we only enable padding for those programs
> > > which are already padded before. But, you're right. For the programs
> > > converging without padding, enabling padding won't change the final
> > > image, so it's safe to always set "padding" to true for the extra pass.
> > >
> > > Will remove the "padded" flag in v3.
> >
> > I'm not following why "enabling padding won't change the final image"
> > is correct.
> > Say the subprog image converges without padding.
> > Then for subprog we call JIT again.
> > Now extra_pass==true and padding==true.
> > The JITed image will be different.
> Actually no.
>
> > The test in patch 3 should have caught it, but it didn't,
> > because it checks for a subprog that needed padding.
> > The extra_pass needs to emit insns exactly in the right spots.
> > Otherwise jump targets will be incorrect.
> > The saved addrs[] array is crucial.
> > If extra_pass emits different things the instruction starts won't align
> > to places where addrs[] expects them to be.
> >
> When calculating padding bytes, if the image already converges, the
> emitted instruction size just matches (addrs[i] - addrs[i-1]), so
> emit_nops() emits 0 byte, and the image doesn't change.

I see. You're right. That's very tricky.

The patch set doesn't apply cleanly.
Could you please rebase and add a detailed comment about this logic?

Also please add comments why we check:
nops != 0 && nops != 4
nops != 0 && nops != 2 && nops != 5
nops != 0 && nops != 3
None of it is obvious.

Does your single test cover all combinations of numbers?
