Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3148C43A
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 00:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfHMW1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 18:27:06 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:42833 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfHMW1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 18:27:06 -0400
Received: by mail-ua1-f66.google.com with SMTP id a97so37242uaa.9
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 15:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3TAQIgVJ77T2ZHlT5XpZJ5AnvKBJ+GDe2Kn0XBXuch8=;
        b=EAQJU3V4SVKSDYNeLGqRom0wBQqrQg+C4KhktsSNYgA8Ep3ZWZobNQkC+JW3Ulphjb
         WQ2zzX2iGpcNA6yWcXIIE9irpmZ1hrqw3dRA2aY3NztaPTzMB6H64uDNSeK0TXDdo3+N
         MsDO+7b3nzB+AJV+ISLR79xy3AYHwfuowoSuSO8shdoKtDzeXHXTiVqquWDWrCRJht0f
         d5Nfump0P8UFGugW5EnsuuiOxDx0tPYFML6/vbicqKc58pAu2/WPXn14mY4y8ihMzpvb
         CeNj74cI5nUYrt6l44+bej4rpvEE7WzkNgNjVwPJfEhOM1P0GOGA8Nu9QF1n9qVb4dqK
         vNRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3TAQIgVJ77T2ZHlT5XpZJ5AnvKBJ+GDe2Kn0XBXuch8=;
        b=OU031wRAmy/u6VLkfciNJ7QU7nteGcoY6byj1QUP21EfjHJPRpWEp3iMl44n9R39wx
         so80QxJa68OI1rtRjcsMb+e+gS6ZMeLJUlvDs66YfeLzKiLlfX+3eL2jxbDzXfsquu8L
         4lBrJCFNIWEY1AAuxFm6ui9Nxu7Fi9mFp7UQO2YiIOxIBfTxAxAO3nuKpPjsepJGMIMl
         9ElaNzQzV9b3Clhwif2s/wBupKQqaHTXp417ClpZ2GdJXp4P5H4MQcFM530i1ysLZhUn
         itNJ8/reAGZUdYzCxr3MkDbZAH2xqFZWIdNbRXnL3S653xJf+EEKgFzpqwUpKisKUjsh
         rulQ==
X-Gm-Message-State: APjAAAXxCw75sEmYx+WQRl8UQhAi6ZyTKGaYEEDFHH88d52O2jyVm8vi
        fsCJwxR+sL+Ngx23yMOvhmtQNSlbSDhs0i8C29ApSQ==
X-Google-Smtp-Source: APXvYqyTUXrjuSmWAEAuLB7sGtL+kdsIoFCnEMIiLLsDSVFLkQHtXYmJXLBlN4Ffm7M0Y4tcGtM+OPCuupGxtyipDw4=
X-Received: by 2002:ab0:7091:: with SMTP id m17mr40650ual.46.1565735224699;
 Tue, 13 Aug 2019 15:27:04 -0700 (PDT)
MIME-Version: 1.0
References: <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com> <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com> <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp> <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp> <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp>
In-Reply-To: <20190813215823.3sfbakzzjjykyng2@ast-mbp>
From:   Daniel Colascione <dancol@google.com>
Date:   Tue, 13 Aug 2019 15:26:28 -0700
Message-ID: <CAKOZuev8XY5+shG8SiWcx4z12QnkgzhcUqCHs9t+eV2z-6nzPA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 2:58 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 06, 2019 at 10:24:25PM -0700, Andy Lutomirski wrote:
> > >
> > > Inside containers and inside nested containers we need to start processes
> > > that will use bpf. All of the processes are trusted.
> >
> > Trusted by whom?  In a non-nested container, the container manager
> > *might* be trusted by the outside world.  In a *nested* container,
> > unless the inner container management is controlled from outside the
> > outer container, it's not trusted.  I don't know much about how
> > Facebook's containers work, but the LXC/LXD/Podman world is moving
> > very strongly toward user namespaces and maximally-untrusted
> > containers, and I think bpf() should work in that context.
>
> agree that containers (namespaces) reduce amount of trust necessary
> for apps to run, but the end goal is not security though.
> Linux has become a single user system.
> If user can ssh into the host they can become root.
> If arbitrary code can run on the host it will be break out of any sandbox.
> Containers are not providing the level of security that is enough
> to run arbitrary code. VMs can do it better, but cpu bugs don't make it easy.
> Containers are used to make production systems safer.
> Some people call it more 'secure', but it's clearly not secure for
> arbitrary code and that is what kernel.unprivileged_bpf_disabled allows.
> When we say 'unprivileged bpf' we really mean arbitrary malicious bpf program.
> It's been a constant source of pain. The constant blinding, randomization,
> verifier speculative analysis, all spectre v1, v2, v4 mitigations
> are simply not worth it. It's a lot of complex kernel code without users.
> There is not a single use case to allow arbitrary malicious bpf
> program to be loaded and executed.
> As soon as we have /dev/bpf to allow all of bpf to be used without root
> we will set sysctl kernel.unprivileged_bpf_disabled=1
> Hence I prefer this /dev/bpf mechanism to be as simple a possible.
> The applications that will use it are going to be just as trusted as systemd.
>
> > > To solve your concern of bypassing all capable checks...
> > > How about we do /dev/bpf/full_verifier first?
> > > It will replace capable() checks in the verifier only.
> >
> > I'm not convinced that "in the verifier" is the right distinction.
> > Telling administrators that some setting lets certain users bypass
> > bpf() verifier checks doesn't have a clear enough meaning.
>
> linux is a single user system. there are no administrators any more.
> No doubt, folks will disagree, but that game is over.
> At least on bpf side it's done.
>
> > I propose,
> > instead, that the current capable() checks be divided into three
> > categories:
>
> I don't see a use case for these categories.
> All bpf programs extend the kernel in some way.
> The kernel vs user is one category.
> Conceptually CAP_BPF is enough. It would be similar to CAP_NET_ADMIN.
> When application has CAP_NET_ADMIN it covers all of networking knobs.
> There is no use case that would warrant fine grain CAP_ROUTE_ADMIN,
> CAP_ETHTOOL_ADMIN, CAP_ETH0_ADMIN, etc.
> Similarly CAP_BPF as the only knob is enough.
> The only disadvantage of CAP_BPF is that it's not possible to
> pass it from one systemd-like daemon to another systemd-like daemon.
> Hence /dev/bpf idea and passing file descriptor.
>
> > This type of thing actually fits quite nicely into an idea I've been
> > thinking about for a while called "implicit rights". In very brief
> > summary, there would be objects called /dev/rights/xyz, where xyz is
> > the same of a "right".  If there is a readable object of the right
> > type at the literal path "/dev/rights/xyz", then you have right xyz.
> > There's a bit more flexibility on top of this.  BPF could use
> > /dev/rights/bpf/maptypes/lpm and
> > /dev/rights/bpf/verifier/bounded_loops, for example.  Other non-BPF
> > use cases include a biggie:
> > /dev/rights/namespace/create_unprivileged_userns.
> > /dev/rights/bind_port/80 would be nice, too.
>
> The concept of "implicit rights" is very nice and I'm sure it will
> be a good fit somewhere, but I don't see why use it in bpf space.
> There is no use case for fine grain partition of bpf features.

Isn't this "implicit rights" model just another kind of ambient
authority --- one that constrains the otherwise-free filesystem
namespace to boot? IMHO, the kernel should be moving toward explicit
authorization tokens modeled by file descriptors and away from
contextual authorization decisions.
