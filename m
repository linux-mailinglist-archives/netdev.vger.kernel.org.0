Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB8B39CC34
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 04:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhFFCNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 22:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhFFCNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 22:13:20 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF9CC061768
        for <netdev@vger.kernel.org>; Sat,  5 Jun 2021 19:11:15 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id g18so13822928edq.8
        for <netdev@vger.kernel.org>; Sat, 05 Jun 2021 19:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nOTcniWTVc9slYXWLxXSv1uRyKmcmZRO+63M/pSzE/U=;
        b=cwZ2lIKKIQuoesuejMOtqIBw38LWmdJQRco7DTpm+On7hiyFzSIynCDa52d+sLCIqB
         2zP8pj4E3rGCuqfhnJ5MRag1NFm53lXVMwQKVQbdijwfbaxWRtV4bmYjHioSZXD6kkwg
         Dlj3L7D4QLBXl9X//0lK2mPz5kWslHUxKRvcBa2juD05DpNuxQp//Z0f+OYjTO6stdwc
         EZHN0Y1DxgOncdZ7gzfETOgtK9k4bhYfZebdAtgUMPDxU3VJkT9f7Tfuk6EcJw0zLdbF
         FqFv+pxxBNtA2aX39hOynje/H5TcETj5t1HDzA84k39g9uwCsZz2riUv/7IvQm3jw6Tq
         ydjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nOTcniWTVc9slYXWLxXSv1uRyKmcmZRO+63M/pSzE/U=;
        b=eLmK+RVNEUh4sFrziTB0Wu1iV/DhWb+dMDWTkIa4gzOnIeXuGy8rgPHiBBT8jbWm/r
         3xWe/ik0y7o2h0cv1wRhbUtlbJcbnG/Ncge1GQXaD1wZgJrOnpmULU9fHrAYvTB+xkbh
         BWjBqQwZR98OgKB01+6QpiEqONjiru54TFdmAVsc/HlEKMTCeMQ+Wvp5t6Q/U8hwsXEw
         2FvTGNYHgU9O6bdsKtPxPf3ar4N//dkCux6LTR/hrA3cHGqSKIwk92LMp5Sdc0bC5pxY
         XNf9WSSNo9v+9QylX/H3Di/vEKyg4L8r3IKhiZViMaClIRKODWLqFwhDgXvDVioPXbhh
         DWUQ==
X-Gm-Message-State: AOAM530RHwBvhDxD1lpa0VbAV3m5Jjzn7EhTfhpIIrK0h0gBL+4x/HQ+
        +ZyGXLHRUdYTmIMJyomymBVWcUFSbOJY3PZqk6+L
X-Google-Smtp-Source: ABdhPJwLR1qKiHaU3a0P90iLeTPVN3ZXpgSHJmVvViAS0IGrSqN4ECheDNlb9g/W/t2kLVz7Gr1DZIJGJ5G/2AgcIkk=
X-Received: by 2002:a05:6402:348f:: with SMTP id v15mr1175334edc.135.1622945471846;
 Sat, 05 Jun 2021 19:11:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210517092006.803332-1-omosnace@redhat.com> <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
 <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net> <CAHC9VhR-kYmMA8gsqkiL5=poN9FoL-uCyx1YOLCoG2hRiUBYug@mail.gmail.com>
 <c7c2d7e1-e253-dce0-d35c-392192e4926e@iogearbox.net> <CAHC9VhS1XRZjKcTFgH1+n5uA-CeT+9BeSP5jvT2+RE5ougLpUg@mail.gmail.com>
 <2e541bdc-ae21-9a07-7ac7-6c6a4dda09e8@iogearbox.net> <CAHC9VhT464vr9sWxqY3PRB4DAccz=LvRMLgWBsSViWMR0JJvOQ@mail.gmail.com>
 <3ca181e3-df32-9ae0-12c6-efb899b7ce7a@iogearbox.net> <CAHC9VhTuPnPs1wMTmoGUZ4fvyy-es9QJpE7O_yTs2JKos4fgbw@mail.gmail.com>
 <f4373013-88fb-b839-aaaa-3826548ebd0c@iogearbox.net> <CAHC9VhS=BeGdaAi8Ae5Fx42Fzy_ybkcXwMNcPwK=uuA6=+SRcg@mail.gmail.com>
 <c59743f6-0000-1b15-bc16-ff761b443aef@iogearbox.net> <CAHC9VhT1JhdRw9P_m3niY-U-vukxTWKTE9q6AMyQ=r_ohpPxMw@mail.gmail.com>
 <CAADnVQ+0bNtDj46Q8s-h=rqJgZz2JaGTeHpbmof3e7fBBQKuDQ@mail.gmail.com>
 <64552a82-d878-b6e6-e650-52423153b624@schaufler-ca.com> <CAHk-=wiUVqHN76YUwhkjZzwTdjMMJf_zN4+u7vEJjmEGh3recw@mail.gmail.com>
In-Reply-To: <CAHk-=wiUVqHN76YUwhkjZzwTdjMMJf_zN4+u7vEJjmEGh3recw@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sat, 5 Jun 2021 22:11:00 -0400
Message-ID: <CAHC9VhRJDr6HO8NbEwcqcXCgpzyLL7KEmKM=VLXGz0zPJG5iXw@mail.gmail.com>
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 5, 2021 at 2:17 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Jun 5, 2021 at 11:11 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >
> > You have fallen into a common fallacy. The fact that the "code runs"
> > does not assure that the "system works right". In the security world
> > we face this all the time, often with performance expectations. In this
> > case the BPF design has failed [..]
>
> I think it's the lockdown patches that have failed. They did the wrong
> thing, they didn't work,
>
> The report in question is for a regression.
>
> THERE ARE NO VALID ARGUMENTS FOR REGRESSIONS.

To think I was worried we might end this thread without a bit of CAPS
LOCK, whew! :)

I don't think anyone in this discussion, even Casey's last comment,
was denying that there was a problem.  The discussion and the
disagreements were about what a "proper" fix would be, and how one
might implement that fix; of course there were different ideas of
"proper" and implementations vary even when people agree, so things
were a bit of a mess.  If you want to get upset and shouty, I think
there are a few things spread across the subsystems involved that
would be worthy targets, but to say that Casey, myself, or anyone else
who plays under security/ denied the problem in this thread is not
fair, or correct, in my opinion.

> Honestly, security people need to understand that "not working" is not
> a success case of security. It's a failure case.

I can't pretend to know what all of the "security people" are
thinking, but I can say with a good degree of certainty that my goal
is not to crash, panic, kill, or otherwise disable a user's system.
When it comes to things like the LSM hooks, my goal is to try and make
sure we have the right hooks in the right places so that admins and
users have the tools they need to control access to their data and
systems in the way that they choose.  Sometimes this puts us at odds
with other subsystems in the kernel, we saw that in this thread, but
that's to be expected anytime you have competing priorities.  The
important part is that eventually we figure out some way to move
forward, and the fact that we are still all making progress and
putting out new kernel releases is proof that we are finding a way.
That's what matters to me, and if I was forced to guess, I would
imagine that matters quite a lot to most of us here.

-- 
paul moore
www.paul-moore.com
