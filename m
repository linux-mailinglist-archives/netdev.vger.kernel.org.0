Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD07B58158F
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 16:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239406AbiGZOlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 10:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239277AbiGZOlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 10:41:15 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA6428E0E
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 07:41:12 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e1so7312583ils.13
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 07:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e1kweWPqCc/tBFU0OU9GCkOUijk7o0nT66eaI6NMorI=;
        b=i61EPXgwER3DOjwmcIsQTQzv6gSQbEHyGanTbNrTyaPqEOsdVh42WvKJo/9pbpcpZS
         BTrtxcRDQidX7WCwTs/AN4uafMp/23Jz13CdoBX6OeSg2TUuEucu4pPHOmzmvn8d3YhT
         fiKHWsaxKkT05q2IbRx1A7J2J8WDIhwTitOZI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e1kweWPqCc/tBFU0OU9GCkOUijk7o0nT66eaI6NMorI=;
        b=KZ98iRS82QOskxX2gypzsLVc3udamOEvPCxwZ+SSYj3DoAnwhmDNPJQbdTy0meB7/Z
         Lj3DAfRk8o7HuqVEGJuiSq7RE8UQlfNNtCa9NJPQJF7V/+hXkIl/ft/CZM7LKjQh06Lp
         T+ijlIxaw7BumL6h7ETBUOAyEQ0dwRME8pXTwbPRvgp0GXCV1lSdw01AnT8vNnV6gqw9
         Vq/Oj2AjyugnSetsz1XvZv4bsqNupTdkfDvV2Gy/4YeK3gPOJBsl8E5Cu2IxKk5F3A6O
         Rmra6hhQWhsHvjogQH/rEYBWgw/VcU6iBEm8nbWSYowhkXIcJHmEeEyich91fWSoYJk2
         H2UQ==
X-Gm-Message-State: AJIora9ioHCZRSr4OXhRBYwLHJWgGW38JognZhKZcWHIdR9jyYyVg9TV
        GKkjxu5Ty0c7S7TctHXvLVqThXLGc+LLRnqehE6x3Q==
X-Google-Smtp-Source: AGRyM1tkabEKEkDMdpDbQ7ttjjCuhMKuPirK9Ul1i0a8JzqLJs3vv8V82jWRnDnuYDU1b0QMTVvmq8M8FBJFf08ynDE=
X-Received: by 2002:a05:6e02:148c:b0:2dd:a828:9382 with SMTP id
 n12-20020a056e02148c00b002dda8289382mr663795ilk.235.1658846472223; Tue, 26
 Jul 2022 07:41:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220721172808.585539-1-fred@cloudflare.com> <877d45kri4.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <877d45kri4.fsf@email.froward.int.ebiederm.org>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Tue, 26 Jul 2022 15:41:01 +0100
Message-ID: <CALrw=nGT0kcHh4wyBwUF-Q8+v8DgnyEJM55vfmABwfU67EQn=g@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Introduce security_create_user_ns()
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com,
        Paul Moore <paul@paul-moore.com>,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, Christian Brauner <brauner@kernel.org>,
        casey@schaufler-ca.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>, cgzones@googlemail.com,
        karl@bigbadwolfsecurity.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 6:05 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Frederick Lawler <fred@cloudflare.com> writes:
>
> > While creating a LSM BPF MAC policy to block user namespace creation, we
> > used the LSM cred_prepare hook because that is the closest hook to prevent
> > a call to create_user_ns().
>
> That description is wrong.  Your goal his is not to limit access to
> the user namespace.  Your goal is to reduce the attack surface of the
> kernel by not allowing some processes access to a user namespace.
>
> You have already said that you don't have concerns about the
> fundamentals of the user namespace, and what it enables only that
> it allows access to exploitable code.
>
> Achieving the protection you seek requires talking and thinking clearly
> about the goal.
>
>
>
>
> I have a couple of deep and fundamental problems with this approach,
> to limiting access to potentially exploitable code.
>
> 1) The first is that unless there is a high probability (say 90%) that at
>    any time the only exploitable code in the kernel can only be accessed
>    by an unprivileged user with the help of user namespaces, attackers
>    will just route around this restriction and so it will achieve
>    nothing in practice, while at the same time incur an extra
>    maintenance burden.
>
> 2) The second is that there is a long standing problem with code that
>    gets added to the kernel.  Many times new kernel code because it has
>    the potential to confuse suid root executables that code has been
>    made root only.  Over time that results in more and more code running
>    as root to be able to make use of the useful features of the linux
>    kernel.
>
>    One of the goals of the user namespace is to avoid more and more code
>    migrating to running as root.  To achieve that goal ordinary
>    application developers need to be able to assume that typically user
>    namespaces will be available on linux.
>
>    An assumption that ordinary applications like chromium make today.
>
>    Your intentions seem to be to place a capability check so that only
>    root can use user namespaces or something of the sort.  Thus breaking
>    the general availability of user namespaces for ordinary applications
>    on your systems.

I would like to comment here that our intention with the hook is quite
the opposite:
we do want to embrace user namespaces in our code and some of our workloads
already depend on it. Hence we didn't agree to Debian's approach of just
having a global sysctl. But there is "our code" and there is "third
party" code, which
might not even be open source due to various reasons. And while the path exists
for that code to do something bad - we want to block it.

So in a way, I think this hook allows better adoption of user
namespaces in the first
place and gives distros and other system maintainers a reasonable
alternative than
just providing a global "kill" sysctl (which is de-facto is used by
many, thus actually
limiting userspace applications accessing the user namespace functionality)

>
> My apologies if this has been addressed somewhere in the conversation
> already.  I don't see these issues addressed in the descriptions of your
> patches.
>
> Until these issues are firmly addressed and you are not proposing a
> patch that can only cause regressions in userspace applications.
>
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> >
> > The calls look something like this:
> >
> >     cred = prepare_creds()
> >         security_prepare_creds()
> >             call_int_hook(cred_prepare, ...
> >     if (cred)
> >         create_user_ns(cred)
> >
> > We noticed that error codes were not propagated from this hook and
> > introduced a patch [1] to propagate those errors.
> >
> > The discussion notes that security_prepare_creds()
> > is not appropriate for MAC policies, and instead the hook is
> > meant for LSM authors to prepare credentials for mutation. [2]
> >
> > Ultimately, we concluded that a better course of action is to introduce
> > a new security hook for LSM authors. [3]
> >
> > This patch set first introduces a new security_create_user_ns() function
> > and userns_create LSM hook, then marks the hook as sleepable in BPF.
> >
> > Links:
> > 1. https://lore.kernel.org/all/20220608150942.776446-1-fred@cloudflare.com/
> > 2. https://lore.kernel.org/all/87y1xzyhub.fsf@email.froward.int.ebiederm.org/
> > 3. https://lore.kernel.org/all/9fe9cd9f-1ded-a179-8ded-5fde8960a586@cloudflare.com/
> >
> > Past discussions:
> > V2: https://lore.kernel.org/all/20220707223228.1940249-1-fred@cloudflare.com/
> > V1: https://lore.kernel.org/all/20220621233939.993579-1-fred@cloudflare.com/
> >
> > Changes since v2:
> > - Rename create_user_ns hook to userns_create
> > - Use user_namespace as an object opposed to a generic namespace object
> > - s/domB_t/domA_t in commit message
> > Changes since v1:
> > - Add selftests/bpf: Add tests verifying bpf lsm create_user_ns hook patch
> > - Add selinux: Implement create_user_ns hook patch
> > - Change function signature of security_create_user_ns() to only take
> >   struct cred
> > - Move security_create_user_ns() call after id mapping check in
> >   create_user_ns()
> > - Update documentation to reflect changes
> >
> > Frederick Lawler (4):
> >   security, lsm: Introduce security_create_user_ns()
> >   bpf-lsm: Make bpf_lsm_userns_create() sleepable
> >   selftests/bpf: Add tests verifying bpf lsm userns_create hook
> >   selinux: Implement userns_create hook
> >
> >  include/linux/lsm_hook_defs.h                 |  1 +
> >  include/linux/lsm_hooks.h                     |  4 +
> >  include/linux/security.h                      |  6 ++
> >  kernel/bpf/bpf_lsm.c                          |  1 +
> >  kernel/user_namespace.c                       |  5 ++
> >  security/security.c                           |  5 ++
> >  security/selinux/hooks.c                      |  9 ++
> >  security/selinux/include/classmap.h           |  2 +
> >  .../selftests/bpf/prog_tests/deny_namespace.c | 88 +++++++++++++++++++
> >  .../selftests/bpf/progs/test_deny_namespace.c | 39 ++++++++
> >  10 files changed, 160 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/deny_namespace.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_deny_namespace.c
> >
> > --
> > 2.30.2
>
> Eric
