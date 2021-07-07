Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3C63BE0A0
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 03:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhGGBk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 21:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhGGBk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 21:40:59 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD61C061574;
        Tue,  6 Jul 2021 18:38:19 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id k8so573825lja.4;
        Tue, 06 Jul 2021 18:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cDuZteS2QwTI95+5VYx9oVAFvfkoqZKJL0R7UK6mN5o=;
        b=op9HoDkw0wHwVMu2ZjWzEFSiO+0d476ts6xMjBMtzYmNb8v91OJQ1XXFJk0BIgWxPX
         jNUrrjzGyaSrgRffc7sRdZ3ulYBcMyOPDkEl8vKe8GCCb6Ezs+pEfNEUF++3BGcbV+n/
         BSYMWi8/Jl2vppXcpDiJUpbQZ9ZJ6I6XvquxcPSoZRuvqj6qYnDbktqEbwR4hFgJHIiZ
         LF3ssFpKyq6GY5sYuY28oClPNkLslVfmXO68k/cNFZAqs4uzLwSuIs67p92BZ1F9EYlp
         s86rmoRZIgMr9C++rRZmMMXYXhiqSwdaC+fAndvn6w2Cs55Shx26/s/3DUgalC/MNOpe
         Icdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cDuZteS2QwTI95+5VYx9oVAFvfkoqZKJL0R7UK6mN5o=;
        b=TQH72V4VMlP6bowpUMG+L6xH4wCn2gMz6WUr88ZnlTNt0nzQZMCABqJixWNSXhDQGt
         lMDgiYlPxiKHZyk4QIYK0p5BdRveg8arkE0uglVmokXvQHOhfsMLDC7JGqGXyXvcRrd6
         vNngmse1GjbtNjMs8BLHTM/I2rrWEBLlXBJonegKZmWCOrFE4dLH7j46AswznMxp9mOc
         WLpNWGNwT12V4CTY7P4TgGN+9WgQrDbENXPzGkkDAQVWEbVo/dkYRWKomhhHji2SSvvK
         MIchvQMEYTVbLEVrUCEZidaXOPyP7kMGg078YHGd2iYJ6cOYCBbr8dIz9vC8DStMMN6U
         9ufg==
X-Gm-Message-State: AOAM532pl5af/IfxWaocVywbO6rH132rSywplIOdaPtR1x0khz5iNm0f
        p3YXXL1y2yU77pqc8Zlb1ZOMRFhk5GJuy+g7FCw=
X-Google-Smtp-Source: ABdhPJzHedLLl3dv3JMO8nQRi6i+xdLp/K74FhJEvM7YrynBMK4eelex2HOP5Lj/K3jklXijej0Grt71Cak0FabEtWg=
X-Received: by 2002:a2e:710b:: with SMTP id m11mr8711741ljc.258.1625621898255;
 Tue, 06 Jul 2021 18:38:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
 <20210701192044.78034-2-alexei.starovoitov@gmail.com> <20210702010455.3h4v5c4g7wx2aeth@kafai-mbp.dhcp.thefacebook.com>
 <CAADnVQKYGBdZJiMsxMVRX8axEbH_Uh+HekcECpiZqU2oWeWv2Q@mail.gmail.com>
In-Reply-To: <CAADnVQKYGBdZJiMsxMVRX8axEbH_Uh+HekcECpiZqU2oWeWv2Q@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 6 Jul 2021 18:38:06 -0700
Message-ID: <CAADnVQLsUzQ=-n3mwgXxQBCdyLSKGgXt79Th-Z+yGVWU_BZnfA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/9] bpf: Introduce bpf timers.
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 4, 2021 at 7:19 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> > > +                     struct bpf_insn ld_addrs[2] = {
> > > +                             BPF_LD_IMM64(BPF_REG_3, (long)prog),
> > The "prog" pointer value is used here.
> >
> > > +                     };
> > > +
> > > +                     insn_buf[0] = ld_addrs[0];
> > > +                     insn_buf[1] = ld_addrs[1];
> > > +                     insn_buf[2] = *insn;
> > > +                     cnt = 3;
> > > +
> > > +                     new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
> > > +                     if (!new_prog)
> > > +                             return -ENOMEM;
> > > +
> > > +                     delta    += cnt - 1;
> > > +                     env->prog = prog = new_prog;
> > After bpf_patch_insn_data(), a new prog may be allocated.
> > Is the above old "prog" pointer value updated accordingly?
> > I could have missed something.
>
> excellent catch. The patching of prog can go bad either here
> or later if patching of some other insn happened to change prog.
> I'll try to switch to dynamic prog fetching via ksym.
> The timers won't work in the interpreted mode though.
> But that's better trade-off than link-list of insns to patch with a prog
> after all of bpf_patch_insn_data are done?
> Some other way to fix this issue?

fyi we've discussed it with Martin offline and he came up with an excellent idea
to patch prog->aux instead of prog here. I'll add that to a respin.
