Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6BB4E4A90
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 02:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237500AbiCWBjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 21:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbiCWBjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 21:39:47 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87948BE22;
        Tue, 22 Mar 2022 18:38:17 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id b16so130659ioz.3;
        Tue, 22 Mar 2022 18:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XKnZR1Uiyw2PN5sPoFzxBAiQwF0e221zQ+vA02UCB0Q=;
        b=S4w2/7eEKrLn3Y8CNsCRT6p1ZPy6URN+PwVKEznVp2aShgRS5SUpcoKxTOy8N7MNJX
         74WZc15swxSMNMDwfww6Wo3grfbpcqr5gID+gHcO8uAor6QzZ4dM6f0F75kWMEBEJlZB
         rUoUr9YtFLCrOKT7mp3HTkZYr0IALey4/5hqBAr+PYCjX26sSQ+WdwovgdH0T7iLRF2J
         vhj72tE702Z93glT9I5cSTTP+nc3S17zELm4G6QYqY1vBa4NhkWoFl4OdZGCUMZ/8+x+
         Isup6CXqNgxrBIjJWh/nyCfAabNCNXpktHy/F42ZZ0DWf66RVklW/KqrnbyXTpD58kl/
         evFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XKnZR1Uiyw2PN5sPoFzxBAiQwF0e221zQ+vA02UCB0Q=;
        b=TYUCRSKQrCRvSLmfkMQ8ZFXqXsWQYu4aOIjkAJ99OEEMkZHI/5knTunCpN8SDaLfyB
         VXp4CFGitCEigblneH/lB/o66DApU66jrfo4HHjc7e0I03Q52lYWVHwKV98mJi7f6ICG
         X4WAyzYamjzlnJ5FYxAVRoLcbNGav+uJ7QaCvdpBANeaTKEJ2p5njk9hV/J0Mz8CT5M4
         Y9v+4kairuX4hn1S16VUm2JB4xNfP3qbIomifa7B8UKSguYvZzRnrgKmFMzMHEdGaiNf
         egjikx9OKCeAzXWQXDu72kSpdJnXsZB9h6aGIWxEFyLoEZsJ8iKCNK10FQjXZVI5o28P
         grKQ==
X-Gm-Message-State: AOAM533qaA21akb4YiWlgEO2P3CzY4V2vbbZ0dkCSm01M1o88SHnX6n2
        HHQ98uAZR+tnpZtsBpe0uesmS5kfbfBrBfkRIgHxx6sD22c=
X-Google-Smtp-Source: ABdhPJzJpv2xZGPVvY4Eou0BEF7mREHYpI2wRSXguuppQ/Dbxxdg85pNMxIKt32W6LE0Peu/QBDem48FNUQT4Ay+6Ns=
X-Received: by 2002:a02:c014:0:b0:317:bbd9:839e with SMTP id
 y20-20020a02c014000000b00317bbd9839emr15464091jai.140.1647999496894; Tue, 22
 Mar 2022 18:38:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220319173036.23352-1-laoar.shao@gmail.com> <YjkBkIHde+fWHw9K@carbon.dhcp.thefacebook.com>
 <CALOAHbBaRnF4g0uFdYMMJfAimfK+oQDhgshuohrLdQiKVShP+A@mail.gmail.com> <YjofCAq3chsgVv2n@carbon.dhcp.thefacebook.com>
In-Reply-To: <YjofCAq3chsgVv2n@carbon.dhcp.thefacebook.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Wed, 23 Mar 2022 09:37:40 +0800
Message-ID: <CALOAHbB5i71Y6cq6oy7-zdySP6wh8b1rKzKJ5+oP5WJmAMaNgQ@mail.gmail.com>
Subject: Re: [PATCH 00/14] bpf: Allow not to charge bpf memory
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, shuah@kernel.org,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 3:10 AM Roman Gushchin <roman.gushchin@linux.dev> w=
rote:
>
> On Wed, Mar 23, 2022 at 12:10:34AM +0800, Yafang Shao wrote:
> > On Tue, Mar 22, 2022 at 6:52 AM Roman Gushchin <roman.gushchin@linux.de=
v> wrote:
> > >
> > > Hello, Yafang!
> > >
> > > Thank you for continuing working on this!
> > >
> > > On Sat, Mar 19, 2022 at 05:30:22PM +0000, Yafang Shao wrote:
> > > > After switching to memcg-based bpf memory accounting, the bpf memor=
y is
> > > > charged to the loader's memcg by defaut, that causes unexpected iss=
ues for
> > > > us. For instance, the container of the loader-which loads the bpf p=
rograms
> > > > and pins them on bpffs-may restart after pinning the progs and maps=
. After
> > > > the restart, the pinned progs and maps won't belong to the new cont=
ainer
> > > > any more, while they actually belong to an offline memcg left by th=
e
> > > > previous generation. That inconsistent behavior will make trouble f=
or the
> > > > memory resource management for this container.
> > >
> > > I'm looking at this text and increasingly feeling that it's not a bpf=
-specific
> > > problem and it shouldn't be solved as one.
> > >
> >
> > I'm not sure whether it is a common issue or not, but I'm sure bpf has
> > its special attribute that we should handle it specifically.  I can
> > show you an example on why bpf is a special one.
> >
> > The pinned bpf is similar to a kernel module, right?
> > But that issue can't happen in a kernel module, while it can happen in
> > bpf only.  The reason is that the kernel module has the choice on
> > whether account the allocated memory or not, e.g.
> >     - Account
> >       kmalloc(size,  GFP_KERNEL | __GFP_ACCOUNT);
> >    - Not Account
> >       kmalloc(size, GFP_KERNEL);
> >
> > While the bpf has no choice because the GFP_KERNEL is a KAPI which is
> > not exposed to the user.
>
> But if your process opens a file, creates a pipe etc there are also
> kernel allocations happening and the process has no control over whether
> these allocations are accounted or not. The same applies for the anonymou=
s
> memory and pagecache as well, so it's not even kmem-specific.
>

So what is the real problem in practice ?
Does anyone complain about it ?

[At least,  there's no behavior change in these areas.]

> >
> > Then the issue is exposed when the memcg-based accounting is
> > forcefully enabled to all bpf programs. That is a behavior change,
> > while unfortunately we don't give the user a chance to keep the old
> > behavior unless they don't use memcg....
> >
> > But that is not to say the memcg-based accounting is bad, while it is
> > really useful, but it needs to be improved. We can't expose
> > GFP_ACCOUNT to the user, but we can expose a wrapper of GFP_ACCOUNT to
> > the user, that's what this patchset did, like what we always have done
> > in bpf.
> >
> > > Is there any significant reason why the loader can't temporarily ente=
r the
> > > root cgroup before creating bpf maps/progs? I know it will require so=
me changes
> > > in the userspace code, but so do new bpf flags.
> > >
> >
> > On our k8s environment, the user agents should be deployed in a
> > Daemonset[1].  It will make more trouble to temporarily enter the root
> > group before creating bpf maps/progs, for example we must change the
> > way we used to deploy user agents, that will be a big project.
>
> I understand, however introducing new kernel interfaces to overcome such
> things has its own downside: every introduced interface will stay pretty
> much forever and we'll _have_ to support it. Kernel interfaces have a ver=
y long
> life cycle, we have to admit it.
>
> The problem you're describing - inconsistencies on accounting of shared r=
egions
> of memory - is a generic cgroup problem, which has a configuration soluti=
on:
> the resource accounting and control should be performed on a stable level=
 and
> actual workloads can be (re)started in sub-cgroups with optionally disabl=
ed
> physical controllers.
> E.g.:
>                         /
>         workload2.slice   workload1.slice     <- accounting should be per=
formed here
> workload_gen1.scope workload_gen2.scope ...
>

I think we talked about it several days earlier.

>
> >
> > [1]. https://kubernetes.io/docs/concepts/workloads/controllers/daemonse=
t/
> >
> > > >
> > > > The reason why these progs and maps have to be persistent across mu=
ltiple
> > > > generations is that these progs and maps are also used by other pro=
cesses
> > > > which are not in this container. IOW, they can't be removed when th=
is
> > > > container is restarted. Take a specific example, bpf program for cl=
sact
> > > > qdisc is loaded by a agent running in a container, which not only l=
oads
> > > > bpf program but also processes the data generated by this program a=
nd do
> > > > some other maintainace things.
> > > >
> > > > In order to keep the charging behavior consistent, we used to consi=
der a
> > > > way to recharge these pinned maps and progs again after the contain=
er is
> > > > restarted, but after the discussion[1] with Roman, we decided to go
> > > > another direction that don't charge them to the container in the fi=
rst
> > > > place. TL;DR about the mentioned disccussion: recharging is not a g=
eneric
> > > > solution and it may take too much risk.
> > > >
> > > > This patchset is the solution of no charge. Two flags are introduce=
d in
> > > > union bpf_attr, one for bpf map and another for bpf prog. The user =
who
> > > > doesn't want to charge to current memcg can use these two flags. Th=
ese two
> > > > flags are only permitted for sys admin as these memory will be acco=
unted to
> > > > the root memcg only.
> > >
> > > If we're going with bpf-specific flags (which I'd prefer not to), let=
's
> > > define them as the way to create system-wide bpf objects which are ex=
pected
> > > to outlive the original cgroup. With expectations that they will be t=
reated
> > > as belonging to the root cgroup by any sort of existing or future res=
ource
> > > accounting (e.g. if we'll start accounting CPU used by bpf prgrams).
> > >
> >
> > Now that talking about the cpu resource, I have some more complaints
> > that cpu cgroup does really better than memory cgroup. Below is the
> > detailed information why cpu cgroup does a good job,
> >
> >    - CPU
> >                         Task Cgroup
> >       Code          CPU time is accounted to the one who is executeING
> >  this code
> >
> >    - Memory
> >                          Memory Cgroup
> >       Data           Memory usage is accounted to the one who
> > allocatED this data.
> >
> > Have you found the difference?
>
> Well, RAM is a vastly different thing than CPU :)
> They have different physical properties and corresponding accounting limi=
tations.
>
> > The difference is that, cpu time is accounted to the one who is using
> > it (that is reasonable), while memory usage is accounted to the one
> > who allocated it (that is unreasonable). If we split the Data/Code
> > into private and shared, we can find why it is unreasonable.
> >
> >                                 Memory Cgroup
> > Private Data           Private and thus accounted to one single memcg, =
good.
> > Shared Data           Shared but accounted to one single memcg, bad.
> >
> >                                 Task Cgroup
> > Private Code          Private and thus accounted to one single task gro=
up, good.
> > Shared Code          Shared and thus accounted to all the task groups, =
good.
> >
> > The pages are accounted when they are allocated rather than when they
> > are used, that is why so many ridiculous things happen.   But we have
> > a common sense that we can=E2=80=99t dynamically charge the page to the
> > process who is accessing it, right?  So we have to handle the issues
> > caused by shared pages case by case.
>
> The accounting of shared regions of memory is complex because of two
> physical limitations:
>
> 1) Amount of (meta)data which we can be used to track ownership. We expec=
t
> the memory overhead be small in comparison to the accounted data. If a pa=
ge
> is used by many cgroups, even saving a single pointer to each cgroup can =
take
> a lot of space. Even worse for slab objects. At some point it stops makin=
g
> sense: if the accounting takes more memory than the accounted memory, it'=
s
> better to not account at all.
>
> 2) CPU overhead: tracking memory usage beyond the initial allocation adds
> an overhead to some very hot paths. Imagine two processes mapping the sam=
e file,
> first processes faults in the whole file and the second just uses the pag=
ecache.
> Currently it's very efficient. Causing the second process to change the o=
wnership
> information on each minor page fault will lead to a performance regressio=
n.
> Think of libc binary as this file.
>
> That said, I'm not saying it can't be done better that now. But it's a co=
mplex
> problem.
>

Memcg-based accounting is also complex, but it introduces user visible
behavior change now :(

--=20
Thanks
Yafang
