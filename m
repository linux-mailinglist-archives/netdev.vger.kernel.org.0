Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03C74168B39
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 01:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgBVAry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 19:47:54 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36907 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgBVAry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 19:47:54 -0500
Received: by mail-lj1-f193.google.com with SMTP id q23so4060876ljm.4;
        Fri, 21 Feb 2020 16:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6CWSp9D95/ClcPNludIOVS8ECeBxf6G5kqK9VdBzJ0Y=;
        b=UwO5yd6rjp7TB+TZ3xUBL/hwFSU9gy1ve8t/WbXOlFluTOQeWGfXgDaHIu2LkSaHJA
         tH5KegakZwlVsXdW+8c7JLhIPJBnxjj1gdPr1aAe9BJ5vmUQa9lizaWUP065uhzZX0FS
         NF9v5klfpT4bTqa+pN+LoAur+fnh+aBhUubAdStexWySdyAKqJkKFMwjCdAbNvfEDtaQ
         YajQJf2gKIXDKPfk/dfGPviJJHhpPWnCqQwUQIWMV0idtYrK1CmDbEI+v4BzjCGj37uJ
         RSJ/jccQwcDWj6YIit/gZek32muriFNQrJBn4Hph7BejdaWR0vLRadNhB4rfs45VfZoi
         3JqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6CWSp9D95/ClcPNludIOVS8ECeBxf6G5kqK9VdBzJ0Y=;
        b=nMj+9pBacY95p0BXHFaTAUa8snc1U7NXh1b+A2hxHagsl4HEruNSv7ES762OVdUeLa
         x2gLD7lvHxBp6mkRWFA+0b9BuVvBy52Y2i/ffXDCkIRch3DqL1Aww5tMf9xv9oS4okIZ
         43XK/D2HljDEhlJjCRyRqmgi/j00RDrqnigHWxhWMYss/rq9qGS2Lp0+UistSgfM83Ju
         bqTKPOis+MnbxN1VYNqfkmKR9zY68Md5MIZCp6h1oQiTXloQ2UxtjULcv+2Yr96laQhB
         zGXH71f/Tg6H23bAidgAiFLpK5kjOZUFwh8XzgpQ+v4UHsVgftDdPRph/QpeY15ezuNf
         /6jw==
X-Gm-Message-State: APjAAAWmqDWlTtZAEScyBVlq69/1DdTWHTH8cfItJI8XAUh1Poe94zei
        c2K41EJuWbT0nGfowsYvRPoPaYuBFMEU1g66mRM=
X-Google-Smtp-Source: APXvYqxsSnDlzQCyabpGJTgevyCIs0lHIu+pOYrWRrCitfPuqasfjdGY+aNgVvUsEABoUmDFsGhKWpuXJJ0Ah6jzJ+g=
X-Received: by 2002:a2e:8145:: with SMTP id t5mr23907862ljg.144.1582332471492;
 Fri, 21 Feb 2020 16:47:51 -0800 (PST)
MIME-Version: 1.0
References: <20200218171023.844439-1-jakub@cloudflare.com> <c86784f5-ef2c-cfd6-cb75-a67af7e11c3c@iogearbox.net>
In-Reply-To: <c86784f5-ef2c-cfd6-cb75-a67af7e11c3c@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Feb 2020 16:47:40 -0800
Message-ID: <CAADnVQJrsfpsT47SqyCTM6=MSkeMESZACZR12Kx+0kRGBnRbvg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 00/11] Extend SOCKMAP/SOCKHASH to store
 listening sockets
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 1:41 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 2/18/20 6:10 PM, Jakub Sitnicki wrote:
> > This patch set turns SOCK{MAP,HASH} into generic collections for TCP
> > sockets, both listening and established. Adding support for listening
> > sockets enables us to use these BPF map types with reuseport BPF programs.
> >
> > Why? SOCKMAP and SOCKHASH, in comparison to REUSEPORT_SOCKARRAY, allow the
> > socket to be in more than one map at the same time.
> >
> > Having a BPF map type that can hold listening sockets, and gracefully
> > co-exist with reuseport BPF is important if, in the future, we want
> > BPF programs that run at socket lookup time [0]. Cover letter for v1 of
> > this series tells the full story of how we got here [1].
> >
> > Although SOCK{MAP,HASH} are not a drop-in replacement for SOCKARRAY just
> > yet, because UDP support is lacking, it's a step in this direction. We're
> > working with Lorenz on extending SOCK{MAP,HASH} to hold UDP sockets, and
> > expect to post RFC series for sockmap + UDP in the near future.
> >
> > I've dropped Acks from all patches that have been touched since v6.
> >
> > The audit for missing READ_ONCE annotations for access to sk_prot is
> > ongoing. Thus far I've found one location specific to TCP listening sockets
> > that needed annotating. This got fixed it in this iteration. I wonder if
> > sparse checker could be put to work to identify places where we have
> > sk_prot access while not holding sk_lock...
> >
> > The patch series depends on another one, posted earlier [2], that has been
> > split out of it.
> >
> > Thanks,
> > jkbs
> >
> > [0] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
> > [1] https://lore.kernel.org/bpf/20191123110751.6729-1-jakub@cloudflare.com/
> > [2] https://lore.kernel.org/bpf/20200217121530.754315-1-jakub@cloudflare.com/
> >
> > v6 -> v7:
> >
> > - Extended the series to cover SOCKHASH. (patches 4-8, 10-11) (John)
> >
> > - Rebased onto recent bpf-next. Resolved conflicts in recent fixes to
> >    sk_state checks on sockmap/sockhash update path. (patch 4)
> >
> > - Added missing READ_ONCE annotation in sock_copy. (patch 1)
> >
> > - Split out patches that simplify sk_psock_restore_proto [2].
>
> Applied, thanks!

Jakub,

what is going on here?
# test_progs -n 40
#40 select_reuseport:OK
Summary: 1/126 PASSED, 30 SKIPPED, 0 FAILED

Does it mean nothing was actually tested?
I really don't like to see 30 skipped tests.
Is it my environment?
If so please make them hard failures.
I will fix whatever I need to fix in my setup.
