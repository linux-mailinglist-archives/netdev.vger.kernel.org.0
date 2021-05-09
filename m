Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4743775A0
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 07:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhEIFi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 01:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhEIFi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 01:38:56 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F18C061573;
        Sat,  8 May 2021 22:37:53 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id i13so11524501pfu.2;
        Sat, 08 May 2021 22:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b+CaOKHF2wRvgJqlD3ywdIdIByKyjWji44jkH4zC5XE=;
        b=UPUUPCpAFgxvFi8kOr9rTxVfLCS2lmGp+gF17KpKnQzKR0JWYJDALIuqMKMFZeZPS+
         zqzhcmJwD+K8bkOILZSP5k48OJ+UXpRXCCphisSy2FG0QtIZpj1gAp4qP8KeyPBG+Nib
         nmuXlSAv62euCy/Xvg9UGpTVkGzVXY3cYAB4ba1o3v73TfVfvqrjKJQQRfr+rffuYd7T
         +fy4hcxCDTx+SUKJPqBteps8LUdXxbTPbFd/o8AgRCMXh4rlePvHLqSZdEGFp2t+vFnM
         gzCU+kFWp60iKPGc2bXgzebeOuurK2V5wCtuDR0xArPpFHqbJOPkaEvP/nDkPoewHuey
         M+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b+CaOKHF2wRvgJqlD3ywdIdIByKyjWji44jkH4zC5XE=;
        b=fZcZD6HlAQrQqu7Q1zPdRVB56FYEJBlKVTEnbLb2oLR0Qlu3Xf5kR1piqDQOrUZQHi
         GQWoVD6rp4gQmnOhluCGe7mj36NxRhbKToO7MxS5Gnq7e+SalN/WnVopIUn4MFoifGDm
         /kZwfXEnef/MoXYrr0zXmUhAEwYsrC9NwM1TYmMxR47/GkmaBCiZ2LzdT6H3qBfKiNiE
         oXSys5pkibgjhgCrQjizsymiv9/0PCT10P1Gq/aky+yJgLioqleCLApykUkXjrUCmSro
         SB8AjA4hnShgS7T6qymnuTjYG/EijeVWiVuCc+LE42A1ELGDcI0CYSAxhn+bmAdNkSY+
         7xzg==
X-Gm-Message-State: AOAM531GFZZGlib1GHT5eKKd2ZUTyssEhiVzTymo9xocrYGAfQ+Sk7d3
        WFFNNo2X55fTg4Eik+Aqh8gQ0Uvo59ZF8qLN6P8=
X-Google-Smtp-Source: ABdhPJxTV4Ap2Y95o+74XVJu4vKuHmNfphPRrJx/LeMosQlF6fkWzBsT+BEK+nEznSMp7rDYeSM+TipLT2F52FmNnf8=
X-Received: by 2002:a62:b609:0:b029:28e:af60:60f5 with SMTP id
 j9-20020a62b6090000b029028eaf6060f5mr18558879pff.43.1620538673181; Sat, 08
 May 2021 22:37:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210402192823.bqwgipmky3xsucs5@ast-mbp> <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
 <20210402234500.by3wigegeluy5w7j@ast-mbp> <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com>
 <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
 <CAM_iQpVtxgZNeqh4_Pqftc3D163JnRvP3AZRuFrYNeyWLgVBVA@mail.gmail.com>
 <CAADnVQLFehCeQRbwEQ9VM-=Y3V3es2Ze8gFPs6cZHwNH0Ct7vw@mail.gmail.com>
 <CAM_iQpWDhoY_msU=AowHFq3N3OuQpvxd2ADP_Z+gxBfGduhrPA@mail.gmail.com>
 <20210427020159.hhgyfkjhzjk3lxgs@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpVE4XG7SPAVBmV2UtqUANg3X-1ngY7COYC03NrT6JkZ+g@mail.gmail.com> <CAADnVQK9BgguVorziWgpMktLHuPCgEaKa4fz-KCfhcZtT46teQ@mail.gmail.com>
In-Reply-To: <CAADnVQK9BgguVorziWgpMktLHuPCgEaKa4fz-KCfhcZtT46teQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 8 May 2021 22:37:42 -0700
Message-ID: <CAM_iQpWBrxuT=Y3CbhxYpE5a+QSk-O=Vj4euegggXAAKTHRBqw@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Joe Stringer <joe@cilium.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 11:34 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Apr 27, 2021 at 9:36 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > If we enforce this ownership, in case of conntrack the owner would be
> > the program which sees the connection first, which is pretty much
> > unpredictable. For example, if the ingress program sees a connection
> > first, it installs a timer for this connection, but the traffic is
> > bidirectional,
> > hence egress program needs this connection and its timer too, we
> > should not remove this timer when the ingress program is freed.
>
> Sure. That's trivially achieved with pinning.

If users forget to do so, their ebpf program would crash the kernel,
right? But ebpf programs should never crash the kernel, right?

> One can have an ingress prog that tailcalls into another prog
> that arms the timer with one of its subprogs.
> Egress prog can tailcall into the same prog as well.
> The ingress and egress progs can be replaced one by one
> or removed both together and middle prog can stay alive
> if it's pinned in bpffs or held alive by FD.

This looks necessarily complex. Look at the overhead of using
a timer properly here:

1. pin timer callback program
2. a program to install timer
3. a program array contains the above program
4. a tail call into the above program array

Why not design a simpler solution?

>
> > From another point of view: maps and programs are both first-class
> > resources in eBPF, a timer is stored in a map and associated with a
> > program, so it is naturally a first-class resource too.
>
> Not really. The timer abstraction is about data. It invokes the callback.
> That callback is a part of the program. The lifetime of the timer object
> and lifetime of the callback can be different.
> Obviously the timer logic need to make sure that callback text is alive
> when the timer is armed.

Only if the callback could reference struct bpf_prog... And even if it
could, how about users forgetting to do so? ebpf verifier has to reject
such cases.

> Combining timer and callback concepts creates a messy abstraction.
> In the normal kernel code one can have a timer in any kernel data
> structure and callback in the kernel text or in the kernel module.
> The code needs to make sure that the module won't go away while
> the timer is armed. Same thing with bpf progs. The progs are safe
> kernel modules. The timers are independent objects.

Kernel modules can take reference count of its own module very
easily, plus there is no verifier for kernel modules. I don't understand
why you want to make ebpf programs as close to kernel modules as
possible in this case.

>
> > >
> > > > >
> > > > > Also if your colleagues have something to share they should be
> > > > > posting to the mailing list. Right now you're acting as a broken phone
> > > > > passing info back and forth and the knowledge gets lost.
> > > > > Please ask your colleagues to participate online.
> > > >
> > > > They are already in CC from the very beginning. And our use case is
> > > > public, it is Cilium conntrack:
> > > > https://github.com/cilium/cilium/blob/master/bpf/lib/conntrack.h
> > > >
> > > > The entries of the code are:
> > > > https://github.com/cilium/cilium/blob/master/bpf/bpf_lxc.c
> > > >
> > > > The maps for conntrack are:
> > > > https://github.com/cilium/cilium/blob/master/bpf/lib/conntrack_map.h
> > >
> > > If that's the only goal then kernel timers are not needed.
> > > cilium conntrack works well as-is.
> >
> > We don't go back to why user-space cleanup is inefficient again,
> > do we? ;)
>
> I remain unconvinced that cilium conntrack _needs_ timer apis.
> It works fine in production and I don't hear any complaints
> from cilium users. So 'user space cleanup inefficiencies' is
> very subjective and cannot be the reason to add timer apis.

I am pretty sure I showed the original report to you when I sent
timeout hashmap patch, in case you forgot here it is again:
https://github.com/cilium/cilium/issues/5048

and let me quote the original report here:

"The current implementation (as of v1.2) for managing the contents of
the datapath connection tracking map leaves something to be desired:
Once per minute, the userspace cilium-agent makes a series of calls to
the bpf() syscall to fetch all of the entries in the map to determine
whether they should be deleted. For each entry in the map, 2-3 calls
must be made: One to fetch the next key, one to fetch the value, and
perhaps one to delete the entry. The maximum size of the map is 1
million entries, and if the current count approaches this size then
the garbage collection goroutine may spend a significant number of CPU
cycles iterating and deleting elements from the conntrack map."

(Adding Joe in Cc too.)

Thanks.
