Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A6F3AF786
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 23:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhFUVkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 17:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhFUVkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 17:40:07 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30649C06175F
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 14:37:51 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id q23so16782240ljh.0
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 14:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc
         :content-transfer-encoding;
        bh=IRAe1gzac7nCzxXjKWrhQY2IFkQPRwkIOAaDOtq0Gqk=;
        b=gFRNGq5Ceg5goaAdSU2H/UZuotNIWaUMO3o70dCpvzhpPF1nMSQ4Vr8MaUBkso4ktV
         lsfsfoolsCt/OCwkayNVEbks/Lx2srbO5dv31mm0qs6kCd/nvX7zTRn9DvSsICZYmc41
         GQMzhaVIrxB7uslhKgsEe6pmCh83CF8qwnUQfdFH5ox52M0lEudNDaImDT4UQiNRDqng
         jdFEUrbFptgBDpJwMv1qgWnldvuNr7j/Kdju8td1PUL76F6+ZV3ZsLXQIsPQ78MjyriE
         40WumzH7VFPLh11ZhiBqnUsQTQUC3OvBSoY2bZ8c/4I0LSoQADSmkdUrGnwrsUzyQmFC
         XIhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc:content-transfer-encoding;
        bh=IRAe1gzac7nCzxXjKWrhQY2IFkQPRwkIOAaDOtq0Gqk=;
        b=P8DAyUnz7T607UuBRSzLLiGCT5SBuDqLRbn2ADTwQdmF8+LkWjWytK/5rOT02GxFNT
         X0LvIIOFxIDtUdPn+cx/xxLU9F0NkuhTPFWZxiaRDl3FtiRBTwMDgoB+DVJIQoIrvbKF
         2N9UVGrn+aHrlR90glDMj7YCSoZR7aQDeMeUckKOkzp9NLDmXPgDBa/CxG3SKaqPfHhR
         g8amQ/SsHAHxRjtzePXOZBVQNOkNUgo6ZsRzQgaQS5sHqXJCcwl/UNYmZ/hATQ/yoLQM
         pPtH3cg0DduRd2PI+ZPUPqcA06wsNdywhQyHyMGMLqWf5ZbtWlLDVfuSlqw1ECMzX37c
         SWbg==
X-Gm-Message-State: AOAM5338OrAe1SoCum9rpjMQSIfqZm09MD4Cy5egHXVqZ9kX+a4Xn4n+
        R+GyvsPuAPdyQctchWf9O6FD4lYhOlSx7Net8K4=
X-Received: by 2002:a2e:8145:: with SMTP id t5mt70948ljg.183.1624311469469;
 Mon, 21 Jun 2021 14:37:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210618105526.265003-1-zenczykowski@gmail.com>
 <CACAyw99k4ZhePBcRJzJn37rvGKnPHEgE3z8Y-47iYKQO2nqFpQ@mail.gmail.com>
 <CANP3RGdrpb+KiD+a29zTSU3LKR8Qo6aFdo4QseRvPdNhZ_AOJw@mail.gmail.com> <CACAyw9948drqRE=0tC=5OrdX=nOVR3JSPScXrkdAv+kGD_P3ZA@mail.gmail.com>
In-Reply-To: <CACAyw9948drqRE=0tC=5OrdX=nOVR3JSPScXrkdAv+kGD_P3ZA@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Mon, 21 Jun 2021 14:37:37 -0700
Message-ID: <CAHo-Oozra2ygb4qW6s8rsgZFmdr-gaQuGzREtXuZLwzzESCYNw@mail.gmail.com>
Subject: Re: [PATCH bpf] Revert "bpf: program: Refuse non-O_RDWR flags in BPF_OBJ_GET"
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Greg Kroah-Hartman <gregkh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Lorenzo Colitti <lorenzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch this reverts breaks (Android) userspace, and I've even
pointed out the specific code in question that it breaks.
What happened to the policy of not breaking userspace?

Why are 'Changes Requested' (see
https://patchwork.kernel.org/project/netdevbpf/patch/20210618105526.265003-=
1-zenczykowski@gmail.com/
)
by whom? What changes?  What do you expect me to do?

Why should I even care?  Why should it even be me?  I'm not the one
that broke things.

On Mon, Jun 21, 2021 at 2:02 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Fri, 18 Jun 2021 at 19:30, Maciej =C5=BBenczykowski
> <zenczykowski@gmail.com> wrote:
> >
> > On Fri, Jun 18, 2021 at 4:55 AM Lorenz Bauer <lmb@cloudflare.com> wrote=
:
> > >
> > > On Fri, 18 Jun 2021 at 11:55, Maciej =C5=BBenczykowski
> > > <zenczykowski@gmail.com> wrote:
> > > >
> > > > This reverts commit d37300ed182131f1757895a62e556332857417e5.
> > > >
> > > > This breaks Android userspace which expects to be able to
> > > > fetch programs with just read permissions.
> > >
> > > Sorry about this! I'll defer to the maintainers what to do here.
> > > Reverting leaves us with a gaping hole for access control of pinned
> > > programs.
> >
> > Not sure what hole you're referring to.  Could you provide more details=
/explanation?
> >
> > It seems perfectly reasonable to be able to get a program with just rea=
d privs.
> > After all, you're not modifying it, just using it.
>
> Agreed, if that was what the kernel is doing. What you get with
> BPF_F_RDONLY is a fully read-write fd, since the rest of the BPF
> subsystem doesn't check program fd flags. Hence my fix to only allow
> O_RDWR, which matches what the kernel actually does. Otherwise any
> user with read-only access can get a R/W fd.
>
> > AFAIK there is no way to modify a program after it was loaded, has this=
 changed?
>
> You can't modify the program, but you can detach it, for example. Any
> program related bpf command that takes a program fd basically.

I fail to see how this is a problem, since it's not modifying the program,
why should it need a rdwr file descriptor to do so?

AFAIK in many cases, you don't even need the bpf file descriptor at
all (for example
you can detach a tc bpf program via removing the tc filter or tc qdisc
or the network interface).

Do you perhaps mean to say you can unpin it?
But, if so, then that's a problem in the unpin code...

Or it's even entirely unrelated, since deleting files does not need
read or write access to the file, just the folder the file is in.

[maze@zeus ~]$ touch foo; chmod a-rwx foo; sudo chown root:root foo; ls -al=
 foo
----------. 1 root root 0 Jun 21 14:26 foo
[maze@zeus ~]$ rm -f foo; ls -al foo
ls: cannot access 'foo': No such file or directory

> > if so, the checks should be on the modifications not the fd fetch.
>
> True, unfortunately that code doesn't exist. It's also not
> straightforward to write and probably impossible to backport.

Now you're suggesting you expect this broken patch (that I'm trying to reve=
rt)
to make it into older LTS releases and break things out in the field???

> > I guess one could argue fetching with write only privs doesn't make sen=
se?
> >
> > Anyway... userspace is broken... so revert is the answer.
> >
> > In Android the process loading/pinning bpf maps/programs is a different
> > process (the 'bpfloader') to the users (which are far less privileged)
>
> If the revert happens you need to make sure that all of your pinned
> state is only readable by the bpfloader user. And everybody else,
> realistically.

On Android selinux prevents anyone from doing untoward things, since
they can't get the fds in the first place.

I *want* less privileged users (that can't load bpf programs, but have
the selinux privs to get pinned program fds) to be able to
attach/detach them (via xdp, tc or to cgroups). That's how stuff works
right *now*.

Could I perhaps redesign the system to work around this?
I don't know.  Perhaps.  Perhaps not.

I haven't given it that much thought - I'm still trying to fix
(workaround) an hrtimer ncm performance regression that was introduced
in 5.10.~24 LTS (there at least we can argue the old code was buggy,
and the hrtimer implementation on the hardware in question outright
terrible and super slow).

I'm guessing changes would be needed to the progRetrieve() function,
and the tests, and the bpfloader, and the permissions embedded in the
programs themselves, and possibly the iptables binary (and the
netutils wrapper) since it uses xt_bpf, and possibly to binaries
privileges and/or selinux capabilities/policies.  Or maybe not.  I
simply don't know.

Well tested patches to make things work are welcome at the aosp project.
A word of warning: I haven't checked / thought things through, but it
may take 5+ years to roll them out.
At this point it's far too late to make such changes in Android 12/S.

Here's another example of fetching programs with BPF_F_RDONLY in
iptables (yes, it was added by me, due to our use in Android):
  https://android.googlesource.com/platform/external/iptables.git/+/refs/he=
ads/master/extensions/libxt_bpf.c#64

The fact that this snuck into the 5.12 final release is not relevant
(ie. this is a regression in 5.12 vs 5.11, and it is still broken in
5.13-rcX).

Please revert immediately.  I've got better things to do.  I shouldn't
have to be thinking about this or arguing about this.
It already took me significantly more than a day simply to track this
down (arguably due to miscommunications with Greg, who'd earlier
actually found this in 5.12, but misunderstood the problem, but
still...).

Thanks,
Maciej
