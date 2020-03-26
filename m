Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE5F519461B
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgCZSJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:09:38 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:33117 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgCZSJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 14:09:38 -0400
Received: by mail-qv1-f67.google.com with SMTP id p19so3540822qve.0;
        Thu, 26 Mar 2020 11:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FBAT0AY1024uZ1M6/q4MPkxFSHQcbUv2bJEoRwbVFe8=;
        b=NfyWrZDaDGqu06UBmgckvYHwoJ5vbVTm/+8ZJzNMYhpj60i0z/XcYtHbEHZp3XmdsQ
         IZBs1HcVfTTKN+LU+PA+wX1sbJMi8zJGscOX6N1w1xEAOobV+UeY2av0exekavnlOINV
         RDq0Qc6upwJ/zVhMw9GLvFFSyt96u9m7knGf1viXr35JSh600ANcyw4/pbWEMoEZ0nJ5
         93J0D69ZZ7H39A9sPolJ9P1qG0679V9jVBdh8km1Pme83eaYkO5sEejHYQa+k851ffKV
         faQyIx/KeGu+eW5Cc/kBkEmCQnsAXO6FpVYWJw/dm56tXGF7tFvSHWLFbq1EEzqbPRi4
         t5Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FBAT0AY1024uZ1M6/q4MPkxFSHQcbUv2bJEoRwbVFe8=;
        b=bKXxieKB4hFwgnyntVlsfjpgwnOdeBpO0PWZeEMXNtaWxPk6JrTXxJk37db6MGoxfk
         yLAZKJmdd3FpDL28m+Ui4OVyFkaOAUE9OHCssN5I13ZZ92DmPmOExbUb0fHGBu9IYhDi
         utZyw+6HLWq71leWS9d4lxtzi0UrHM9nVEK58l7WeeKVva1h6DqyEIoYHf7H7XNHRCvt
         JK3D+gTZVkqIQTNKF6Dlv1HdbjBmFYJlE5S8JVEVonHIWkbJ1p6/28DIZy1n/ybZD2ay
         1ig8GRcUmlvhD+aRn+X0/cbykBDMI1A59/4IKa7TDWBUDhtk5HgJ0eYGnXvVE7fuqMNZ
         6F4A==
X-Gm-Message-State: ANhLgQ1UfRnosyb92EAu8ywAuJE+/FTFM7pFmD/q1vprfaJof7hdctMk
        f+NiuFMeIK8y8yDKSueuWpbj9H7TG2/vuDuB76dIc12wDjY=
X-Google-Smtp-Source: ADFU+vuetwz1OFONpMBWVoSKfAWFAlGt8XjbJkydjLcAcCeEO1nxcggvvXJdA0oNk96HoacAdU1PY7Xb5aW1AGcN/1k=
X-Received: by 2002:a05:6214:14e8:: with SMTP id k8mr9124290qvw.228.1585246176063;
 Thu, 26 Mar 2020 11:09:36 -0700 (PDT)
MIME-Version: 1.0
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <20200325221323.00459c8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200325221323.00459c8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 26 Mar 2020 11:09:22 -0700
Message-ID: <CAEf4BzZJUBcJYJHFT4VTRuhqV3SJvpSJW7bvH3-wct8nV2+HsQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 10:13 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 25 Mar 2020 17:16:13 -0700 Andrii Nakryiko wrote:
> > > >> Well, I wasn't talking about any of those subsystems, I was talking
> > > >> about networking :)
> > > >
> > > > So it's not "BPF subsystem's relation to the rest of the kernel" from
> > > > your previous email, it's now only "talking about networking"? Since
> > > > when the rest of the kernel is networking?
> > >
> > > Not really, I would likely argue the same for any other subsystem, I
> >
> > And you would like lose that argument :) You already agreed that for
> > tracing this is not the case. BPF is not attached by writing text into
> > ftrace's debugfs entries. Same for cgroups, we don't
> > create/update/write special files in cgroupfs, we have an explicit
> > attachment API in BPF.
> >
> > BTW, kprobes started out with the same model as XDP has right now. You
> > had to do a bunch of magic writes into various debugfs files to attach
> > BPF program. If user-space application crashed, kprobe stayed
> > attached. This was horrible and led to many problems in real world
> > production uses. So a completely different interface was created,
> > allowing to do it through perf_event_open() and created anonymous
> > inode for BPF program attachment. That allowed crashing program to
> > auto-detach kprobe and not harm production use case.
> >
> > Now we are coming after cgroup BPF programs, which have similar issues
> > and similar pains in production. cgroup BPF progs actually have extra
> > problems: programs can user-space applications can accidentally
> > replace a critical cgroup program and ruin the day for many folks that
> > have to deal with production breakage after that. Which is why I'm
> > implementing bpf_link with all its properties: to solve real pain and
> > real problem.
> >
> > Now for XDP. It has same flawed model. And even if it seems to you
> > that it's not a big issue, and even if Jakub thinks we are trying to
> > solve non-existing problem, it is a real problem and a real concern
> > from people that have to support XDP in production with many
>
> More than happy to talk to those folks, and see the tickets.

We can certainly set up some meeting with Andrey and Takshak.

>
> Toke has actual user space code which needs his extension, and for
> which "ownership" makes no difference as it would just be passed with
> whoever touched the program last.

As has been repeated time and time again, we cannot allow any random
application to just go and replace XDP program. Same for cgroups. It's
not a hypothetical problem, it has happened and it has caused
problems.

So just because Toke's prototype doesn't have any protection against
this, doesn't mean it's how it will end up being.

>
> > well-meaning developers developing BPF applications independently.
>
> There is one single program which can be attached to the XDP hook,
> the "everybody attaches their program model" does not apply.

Yes, but you've followed all the XDP chaining discussion and freplace
stuff up until now, right? There is going to be a single XDP root
program, but other applications are going to plug in their freplace
programs into it. And Tupperware wants to control XDP root program and
not let anyone replace it, even though some program will need to have
root access anyways.

>
> TW agent should just listen on netlink notifications to see if someone

I'll leave it up to TW agent team to decide if that's a good idea. But
please educate me. When some app replaces XDP program accidentally,
how TW agent can make sure (by following netlink notifications) that
**no** packet is intercepted and mis-routed by this wrong XDP program?
Are there such guarantees by netlink notifications that listening
application will be able to undo the operation in between two network
packets?

> replaced its program. cgroups have multi-attachment and no notifications

Multi-attachment is not always appropriate, which is why Andrey
Ignatov asked to support all modes (NONE, OVERRIDABLE, MULTI).  But
honestly I lost why this is relevant here.

> (although not sure anyone was explicitly asking for links there,
> either).

Tupperware did.

>
> In production a no-op XDP program is likely to be attached from the
> moment machine boots, to avoid traffic interruption and the risk of
> something going wrong with the driver when switching between skb to
> xdp datapath. And then the program is only replaced, not detached.

Good, so there in no problem to pin it somewhere forever.

>
> Not to mention the fact that networking applications generally don't
> want to remove their policy from the kernel when they crash :/

Yes, which is why bpf_link are trivially pinnable. bpf_link gives
choice. What's there right now in XDP (program FD attachment) doesn't
give a choice of auto-detaching on application crash for cases where
it's appropriate (some relatively short-running XDP monitoring script,
for example).

>
> > Now, those were fundamental things, but I'd like to touch on a "nice
> > things we get with that". Having a proper kernel object representing
> > single instance of attached BPF program to some other kernel object
> > allows to build an uniform and consistent API around bpf_link with
> > same semantics. We can do LINK_UPDATE and allow to atomically replace
> > BPF program inside the established bpf_link. It's applicable to all
> > types of BPF program attachment and can be done in a way that ensures
> > no BPF program invocation is skipped while BPF programs are swapped
> > (because at the lowest level it boils down to an atomic pointer swap).
> > Of course not all bpf_links might have this support initially, but
> > we'll establish a lot of common infrastructure which will make it
> > simpler, faster and more reliable to add this functionality.
>
> XDP replace is already atomic, no packet will be passed without either
> old or new program executed on it.

Please re-read what I wrote again, entire thing. You are picking
arbitrary pieces and considering them in isolation. It's either
dishonest or you are missing the point.

>
> > And to wrap up. I agree, consistent API is not a goal in itself, as
> > Jakub mentioned. But it is a worthy goal nevertheless, especially if
> > it doesn't cost anything extra. It makes kernel developers lives
>
> Not sure how having two interfaces instead of one makes kernel
> developer's life easier.

There is no interface for bpf_link for XDP right now. But let's
separate netlink vs bpf syscall discussion from bpf_link general
discussion.
