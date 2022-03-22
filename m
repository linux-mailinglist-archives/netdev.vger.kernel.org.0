Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1224E4E43F3
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 17:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238948AbiCVQMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 12:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236331AbiCVQMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 12:12:41 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BC827CC2;
        Tue, 22 Mar 2022 09:11:13 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id x4so20722548iop.7;
        Tue, 22 Mar 2022 09:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=baRMAaoLZ6j7/FVomQdBqIuec+cMbKw6k540DXigCaE=;
        b=I9WwCZEIe9bxTL+3OuIgnWedsPBmr8+UrB76dvYJJqSy4PJaS//CnCjS6001utn24C
         9UkQDSekD25Ke6R6S7xNSxXpihfAOHcxQ+LTCaJlzvntUH0ZgEO23A8PF1V1YsG8RqCb
         y94ij+ZciRe5OZ4K88z8997HmLsntnyohZiBxeAaRiBoT4lebSG24wIO3iWZhKrHCw1N
         i9O2o4zYMdOPMdGC3r/kb+FconbTUK+t6v9dttQnjhIUVwTbbGdqa0d+171PH87NTUuk
         CnBKaEGQmxszX25jKaDlutK83I/6yyIQOQ7NW29NyuNA1qUfKteXC3IDKlacdfUGYLhk
         lwCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=baRMAaoLZ6j7/FVomQdBqIuec+cMbKw6k540DXigCaE=;
        b=5nLexK11gVW4FeZZ0ZNkVr+zVfxbE5SkhQy9+ShvSY08J9A+HC5KYrtU8rRonuxpsJ
         PQFCmyDRrt0IM/nqJkAT3J9TYM5cTgYzp1ilDNBgr/aDHPlMKu44v7NIcUWUMidacvw7
         qtSPUWq5QbXxT+K1A6sD/I0JOlgbMctoY4YboC+UB4lI//XRKA10GLDWeGF1MS05+1RL
         FSMh9jIRIKh+KykUB4+T7gyZhCmyMDBefIreY737v1Erc+J94eOZ6Gvyl3lepys8uNoc
         kBONwP/5yFg4382nTuBAPVxUCeogRK0Upw8xlAU/tDhhPGbu9RvDu8dCGN+f04MOlOxn
         8qag==
X-Gm-Message-State: AOAM5311U5H7mwgWXGWxxFt/fEREobyt9iAoXPUIzNO4s0txfWSO7mq8
        ctFVUkiP7f7k2/KXxkz+KJDJCH23H3R9ksjbgSZnBAbBnN5hbg==
X-Google-Smtp-Source: ABdhPJyRJtL9wMaMN9wmdxB6zBG3rSrktEDpk/ApLcMtrNs4uIUOxmv/Aofc8yGJkXe1NdRKML4YD22V8pMHHqGdTVo=
X-Received: by 2002:a05:6602:2c4f:b0:645:bb89:28c7 with SMTP id
 x15-20020a0566022c4f00b00645bb8928c7mr12825990iov.76.1647965473150; Tue, 22
 Mar 2022 09:11:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220319173036.23352-1-laoar.shao@gmail.com> <YjkBkIHde+fWHw9K@carbon.dhcp.thefacebook.com>
In-Reply-To: <YjkBkIHde+fWHw9K@carbon.dhcp.thefacebook.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Wed, 23 Mar 2022 00:10:34 +0800
Message-ID: <CALOAHbBaRnF4g0uFdYMMJfAimfK+oQDhgshuohrLdQiKVShP+A@mail.gmail.com>
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

On Tue, Mar 22, 2022 at 6:52 AM Roman Gushchin <roman.gushchin@linux.dev> w=
rote:
>
> Hello, Yafang!
>
> Thank you for continuing working on this!
>
> On Sat, Mar 19, 2022 at 05:30:22PM +0000, Yafang Shao wrote:
> > After switching to memcg-based bpf memory accounting, the bpf memory is
> > charged to the loader's memcg by defaut, that causes unexpected issues =
for
> > us. For instance, the container of the loader-which loads the bpf progr=
ams
> > and pins them on bpffs-may restart after pinning the progs and maps. Af=
ter
> > the restart, the pinned progs and maps won't belong to the new containe=
r
> > any more, while they actually belong to an offline memcg left by the
> > previous generation. That inconsistent behavior will make trouble for t=
he
> > memory resource management for this container.
>
> I'm looking at this text and increasingly feeling that it's not a bpf-spe=
cific
> problem and it shouldn't be solved as one.
>

I'm not sure whether it is a common issue or not, but I'm sure bpf has
its special attribute that we should handle it specifically.  I can
show you an example on why bpf is a special one.

The pinned bpf is similar to a kernel module, right?
But that issue can't happen in a kernel module, while it can happen in
bpf only.  The reason is that the kernel module has the choice on
whether account the allocated memory or not, e.g.
    - Account
      kmalloc(size,  GFP_KERNEL | __GFP_ACCOUNT);
   - Not Account
      kmalloc(size, GFP_KERNEL);

While the bpf has no choice because the GFP_KERNEL is a KAPI which is
not exposed to the user.

Then the issue is exposed when the memcg-based accounting is
forcefully enabled to all bpf programs. That is a behavior change,
while unfortunately we don't give the user a chance to keep the old
behavior unless they don't use memcg....

But that is not to say the memcg-based accounting is bad, while it is
really useful, but it needs to be improved. We can't expose
GFP_ACCOUNT to the user, but we can expose a wrapper of GFP_ACCOUNT to
the user, that's what this patchset did, like what we always have done
in bpf.

> Is there any significant reason why the loader can't temporarily enter th=
e
> root cgroup before creating bpf maps/progs? I know it will require some c=
hanges
> in the userspace code, but so do new bpf flags.
>

On our k8s environment, the user agents should be deployed in a
Daemonset[1].  It will make more trouble to temporarily enter the root
group before creating bpf maps/progs, for example we must change the
way we used to deploy user agents, that will be a big project.

[1]. https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/

> >
> > The reason why these progs and maps have to be persistent across multip=
le
> > generations is that these progs and maps are also used by other process=
es
> > which are not in this container. IOW, they can't be removed when this
> > container is restarted. Take a specific example, bpf program for clsact
> > qdisc is loaded by a agent running in a container, which not only loads
> > bpf program but also processes the data generated by this program and d=
o
> > some other maintainace things.
> >
> > In order to keep the charging behavior consistent, we used to consider =
a
> > way to recharge these pinned maps and progs again after the container i=
s
> > restarted, but after the discussion[1] with Roman, we decided to go
> > another direction that don't charge them to the container in the first
> > place. TL;DR about the mentioned disccussion: recharging is not a gener=
ic
> > solution and it may take too much risk.
> >
> > This patchset is the solution of no charge. Two flags are introduced in
> > union bpf_attr, one for bpf map and another for bpf prog. The user who
> > doesn't want to charge to current memcg can use these two flags. These =
two
> > flags are only permitted for sys admin as these memory will be accounte=
d to
> > the root memcg only.
>
> If we're going with bpf-specific flags (which I'd prefer not to), let's
> define them as the way to create system-wide bpf objects which are expect=
ed
> to outlive the original cgroup. With expectations that they will be treat=
ed
> as belonging to the root cgroup by any sort of existing or future resourc=
e
> accounting (e.g. if we'll start accounting CPU used by bpf prgrams).
>

Now that talking about the cpu resource, I have some more complaints
that cpu cgroup does really better than memory cgroup. Below is the
detailed information why cpu cgroup does a good job,

   - CPU
                        Task Cgroup
      Code          CPU time is accounted to the one who is executeING
 this code

   - Memory
                         Memory Cgroup
      Data           Memory usage is accounted to the one who
allocatED this data.

Have you found the difference?
The difference is that, cpu time is accounted to the one who is using
it (that is reasonable), while memory usage is accounted to the one
who allocated it (that is unreasonable). If we split the Data/Code
into private and shared, we can find why it is unreasonable.

                                Memory Cgroup
Private Data           Private and thus accounted to one single memcg, good=
.
Shared Data           Shared but accounted to one single memcg, bad.

                                Task Cgroup
Private Code          Private and thus accounted to one single task group, =
good.
Shared Code          Shared and thus accounted to all the task groups, good=
.

The pages are accounted when they are allocated rather than when they
are used, that is why so many ridiculous things happen.   But we have
a common sense that we can=E2=80=99t dynamically charge the page to the
process who is accessing it, right?  So we have to handle the issues
caused by shared pages case by case.

> But then again: why just not create them in the root cgroup?
>

As I explained above, that is limited by the deployment.

--=20
Thanks
Yafang
